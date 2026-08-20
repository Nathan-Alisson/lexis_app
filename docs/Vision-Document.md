# 1. Visão do produto

Construir um aplicativo Flutter para **Android e desktop**, desenvolvido inicialmente no Ubuntu, em que cada usuário cria seu próprio dicionário.

O aplicativo deverá funcionar completamente sem internet para suas funções principais.

A internet será necessária somente para recursos como:

- sincronização entre dispositivos;
- autenticação;
- assinatura;
- geração de conteúdo por IA;
- sincronização das imagens.

A arquitetura deverá permitir adicionar futuramente:

- novos idiomas;
- novas IAs;
- Windows/macOS;
- revisão de vocabulário;
- categorias;
- tags;
- importação/exportação;
- compartilhamento;
- novos planos.

---

# 2. Regra principal da arquitetura

A regra será:

```text
O APP SEMPRE TRABALHA COM O BANCO LOCAL.
```

Não:

```text
App → internet → servidor → banco
```

Mas:

```text
                     ┌──────────── Servidor
                     │
Interface → Repository
                     │
                     └──────────── SQLite local
```

Quando estiver offline:

```text
Flutter
   ↓
SQLite
```

Quando estiver online e o usuário tiver sincronização:

```text
Flutter
   ↓
SQLite
   ↕
Sync Engine
   ↕
Servidor
   ↓
PostgreSQL
```

Portanto, mesmo estando online, uma edição será primeiramente registrada localmente.

Depois será sincronizada.

---

# 3. Stack planejada

## Aplicativo

```text
Flutter
Dart
```

## Banco local

```text
SQLite
+
Drift
```

## Backend

Inicialmente:

```text
Supabase
```

Mas ele será colocado atrás de interfaces próprias do aplicativo.

O aplicativo não deve ficar estruturalmente dependente dele.

Supabase fornecerá principalmente:

```text
PostgreSQL
Autenticação
Storage
Backend/API
```

Supabase atualmente oferece PostgreSQL, autenticação, Storage e APIs para aplicações Flutter.

## IA

Primeiro provedor:

```text
Google Gemini
```

Mas através de:

```dart
abstract interface class AiProvider
```

e não:

```dart
class GeminiService
```

espalhado pelo projeto inteiro.

Isso permitirá futuramente:

```text
Gemini
OpenAI
Claude
modelo local
outro provedor
```

sem reconstruir o aplicativo.

---

# 4. Estrutura geral

```text
┌─────────────────────────────────────┐
│             Flutter UI              │
├─────────────────────────────────────┤
│             ViewModels              │
├─────────────────────────────────────┤
│             Use Cases               │
├─────────────────────────────────────┤
│            Repositories             │
├───────────────┬─────────────────────┤
│ Local         │ Remote              │
│               │                     │
│ Drift/SQLite  │ Sync API            │
├───────────────┼─────────────────────┤
│ Lemmatizer    │ Auth                │
│               │ AI                  │
│               │ Storage             │
│               │ Billing             │
└───────────────┴─────────────────────┘
```

A interface nunca deve saber diretamente:

```text
"estou salvando no Supabase"
```

Ela saberá apenas:

```dart
dictionaryRepository.saveEntry(...)
```

---

# 5. Estrutura inicial do projeto

```text
lib/
│
├── core/
│   ├── database/
│   ├── sync/
│   ├── auth/
│   ├── ai/
│   ├── billing/
│   ├── ads/
│   ├── connectivity/
│   └── lemmatization/
│
├── features/
│   │
│   ├── dictionary/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── authentication/
│   ├── subscription/
│   ├── synchronization/
│   └── settings/
│
└── main.dart
```

Não começar implementando tudo isso.

A estrutura vai crescendo conforme as etapas abaixo.

---

# ETAPA 1 — Preparação do ambiente

Configurar no Ubuntu:

```text
Git
Flutter SDK
Android Studio
Android SDK
Emulador Android
VS Code ou Android Studio
Flutter Linux Desktop
```

Validar tudo com:

```bash
flutter doctor
```

Criar:

```bash
flutter create personal_dictionary
```

Primeiro objetivo:

```text
Aplicação rodando no Android.
Aplicação rodando no Linux.
```

Nenhuma funcionalidade ainda.

---

# ETAPA 2 — Fundamentos de Dart

Estudar somente o necessário para começar.

Manual de apoio: [Fundamentos de Dart sem jargões](studies/07-fundamentos-de-dart.md).

## Tipos

```dart
String
int
double
bool
List
Map
Set
```

## Null safety

```dart
String?
```

## Classes

```dart
class DictionaryEntry {}
```

## Construtores

## Enums

## Interfaces

## Generics

## Exceptions

## Future

```dart
Future<T>
```

## async / await

## Stream

## Imutabilidade

## Testes unitários

Não estudar Dart inteiro antes de começar Flutter.

Aprender cada conceito junto do projeto.

---

# ETAPA 3 — Flutter básico

Construir apenas a interface.

Ainda sem banco.

Criar:

```text
Home
Nova palavra
Visualizar palavra
Editar palavra
Configurações
```

Primeira tela:

```text
Meu Dicionário

[ Pesquisar........................ ]

A

alcova
andar

B

barreira

C

comedido

                         +
```

---

# ETAPA 4 — Primeiro modelo de domínio

Criar o conceito central:

```dart
DictionaryEntry
```

Ele poderá ter aproximadamente:

```text
id
languageCode

originalWord
lemma
lemmaKey

meaning
notes

createdAt
updatedAt

source
```

Com estruturas relacionadas para:

```text
examples
synonyms
antonyms
images
```

Um ponto importante:

```text
originalWord != lemma
```

Exemplo hipotético:

```text
Digitado:
casas

Lema:
casa
```

Guardar os dois.

Nunca destruir a palavra originalmente fornecida pelo usuário.

---

# ETAPA 5 — Banco SQLite

Agora entra o Drift.

Criar o banco local.

Inicialmente:

```text
dictionary_entries
examples
word_relations
attachments
```

`word_relations` poderá representar:

```text
synonym
antonym
```

Exemplo:

```text
word_relations

id
entry_id
type
value
```

---

# ETAPA 6 — CRUD completamente offline

Implementar:

```text
Cadastrar
Consultar
Editar
Excluir
Pesquisar
```

Neste momento:

```text
Internet = desnecessária
Supabase = inexistente
Google = inexistente
IA = inexistente
Sincronização = inexistente
```

O aplicativo já deverá ser útil.

Critério dessa etapa:

> desligar a internet, cadastrar palavras, fechar o aplicativo, abrir novamente e encontrar todos os dados.

---

# ETAPA 7 — Lemmatização

Esta é uma parte central do domínio, não um detalhe da interface.

Criar:

```dart
abstract interface class Lemmatizer {
  Future<LemmaResult> lemmatize(
    String text,
    String languageCode,
  );
}
```

A implementação precisa funcionar **offline**.

A IA não será responsável pela lematização.

Motivo arquitetural:

```text
sem internet
    ↓
usuário ainda precisa cadastrar palavras
    ↓
lematização obrigatoriamente local
```

---

# 8. Pipeline para cadastrar uma palavra

Toda palavra deverá passar por:

```text
ENTRADA
  ↓
limpeza
  ↓
normalização Unicode
  ↓
identificação do idioma
  ↓
lematização
  ↓
normalização do lema
  ↓
geração de lemmaKey
  ↓
verificação de duplicidade
  ↓
cadastro
```

Exemplo:

```text
"CASAS "
    ↓
"CASAS"
    ↓
lema = "casa"
    ↓
lemmaKey = "pt-BR:casa"
```

Não retirar acentos indiscriminadamente.

Palavras diferentes podem depender deles.

---

# 9. Idioma deve fazer parte da identidade

Não usar apenas:

```text
lemma = casa
```

Usar:

```text
languageCode = pt-BR
lemma = casa
```

A chave lógica passa a ser:

```text
pt-BR:casa
```

Isso prepara o aplicativo para múltiplos idiomas.

Exemplo:

```text
pt-BR
en-US
es-ES
fr-FR
```

---

# 10. Garantia de palavra única

Nunca confiar apenas em:

```dart
if (!list.contains(word))
```

A regra precisa existir no banco.

Localmente:

```text
UNIQUE (
    owner,
    language_code,
    lemma_key
)
```

No servidor:

```text
UNIQUE (
    user_id,
    language_code,
    lemma_key
)
```

Portanto:

```text
casas
casa
Casa
CASA
```

depois da normalização e lematização poderão apontar para:

```text
pt-BR:casa
```

O novo cadastro será bloqueado.

O aplicativo abrirá a palavra existente em vez de gerar uma duplicata.

---

# 11. Versão do algoritmo de lematização

Adicionar:

```text
lemma_engine_version
```

Exemplo:

```text
lemma_engine_version = 1
```

Isso parece desnecessário agora, mas evita um problema futuro.

Imagine que a versão 1 produza:

```text
melhores → melhor
```

e uma versão futura produza outro resultado.

Será possível saber qual algoritmo originou aquele registro e executar migrações controladas.

---

# ETAPA 8 — Imagens locais

Antes de pensar em nuvem:

```text
selecionar imagem
↓
copiar para diretório privado do app
↓
registrar caminho no SQLite
```

Não salvar a imagem como um enorme campo dentro da tabela da palavra.

Guardar:

```text
attachment_id
entry_id
local_path
mime_type
size
sha256
sync_status
```

O hash também será útil futuramente para evitar uploads repetidos.

---

# ETAPA 9 — Pesquisa

Implementar pesquisa local.

Pesquisar por:

```text
palavra original
lema
significado
sinônimo
antônimo
```

Inicialmente simples.

Depois poderá usar:

```text
SQLite FTS
```

caso a quantidade de palavras justifique.

---

# ETAPA 10 — Repository definitivo

Neste momento o aplicativo será reorganizado para utilizar:

```dart
DictionaryRepository
```

Exemplo conceitual:

```dart
abstract interface class DictionaryRepository {
  Future<DictionaryEntry> create(...);

  Future<void> update(...);

  Future<void> delete(...);

  Stream<List<DictionaryEntry>> watchAll();

  Future<DictionaryEntry?> findByLemma(...);
}
```

Uma implementação:

```text
LocalDictionaryRepository
```

Depois surgirá:

```text
SyncDictionaryRepository
```

A interface não muda.

---

# ETAPA 11 — Preparação para sincronização

Antes de existir servidor, cada registro ganhará metadados.

```text
id
revision
sync_status
last_synced_revision
created_at
updated_at
deleted_at
device_id
```

O ID deverá ser criado no próprio dispositivo.

Não usar:

```text
1
2
3
4
```

como identidade global.

Usar identificadores globalmente únicos.

---

# ETAPA 12 — Outbox de sincronização

Criar uma tabela:

```text
sync_operations
```

Exemplo:

```text
operation_id
entity_id
operation_type
base_revision
payload
created_at
status
```

Operações possíveis:

```text
CREATE
UPDATE
DELETE
```

Exemplo:

```text
Usuário está offline

edita "alcova"
       ↓
SQLite salva
       ↓
sync_operations recebe UPDATE
       ↓
continua usando normalmente
```

Quando a conexão volta:

```text
Sync Engine
    ↓
consulta sync_operations
    ↓
envia operações pendentes
```

Essa abordagem evita precisar comparar o banco inteiro a cada sincronização.

---

# ETAPA 13 — Exclusão sincronizável

Não apagar imediatamente registros sincronizados.

Usar:

```text
deleted_at
```

Isso é chamado de tombstone.

Exemplo:

```text
Celular offline:
remove "alcova"
```

Se simplesmente apagássemos:

```text
como o computador saberia que precisa apagar também?
```

Com:

```text
deleted_at = ...
```

a exclusão consegue ser propagada.

A remoção física pode acontecer posteriormente.

---

# ETAPA 14 — Criar backend

Somente agora aprender Supabase.

Responsabilidades:

```text
PostgreSQL
Auth
Storage
API
```

A tabela remota terá conceitos equivalentes ao banco local.

Não necessariamente exatamente a mesma estrutura física.

---

# ETAPA 15 — Conta do usuário

Existirão dois estados.

## Usuário local

```text
Sem login
Sem sincronização
Dicionário somente no dispositivo
```

## Usuário autenticado

```text
Conta Google
Possibilidade de assinatura
Possibilidade de sincronização
```

Isso significa que alguém poderá instalar o aplicativo e começar imediatamente sem criar conta.

---

# ETAPA 16 — Login com Google

O login servirá para identificar:

```text
quem é o dono do dicionário sincronizado?
```

Conceitualmente:

```text
Google
  ↓
OAuth
  ↓
Backend
  ↓
user_id
```

Os registros remotos sempre pertencerão a:

```text
user_id
```

Nunca usar o e-mail como chave primária.

---

# ETAPA 17 — Migração de usuário local para conta

Situação:

```text
Usuário tem 300 palavras offline.

Depois compra sincronização.
```

Não pode perder nada.

Fluxo:

```text
Login
 ↓
criar/vincular conta
 ↓
examinar banco local
 ↓
comparar com servidor
 ↓
enviar registros
```

Se o servidor já tiver palavras:

```text
resolver duplicidades e conflitos
```

antes de concluir a migração.

---

# ETAPA 18 — Motor de sincronização

Criar:

```dart
SyncEngine
```

Responsabilidades:

```text
push local changes
pull server changes
detectar conflito
registrar conflito
atualizar revision
limpar outbox concluída
```

Fluxo:

```text
Internet voltou
      ↓
SyncEngine.start()
      ↓
PUSH
      ↓
servidor responde
      ↓
PULL
      ↓
aplica alterações
      ↓
identifica conflitos
```

---

# 19. Revisionamento

Cada palavra sincronizada terá:

```text
revision
```

Exemplo:

```text
Servidor

alcova
revision = 7
```

O celular baixou revision 7.

Depois ficou offline.

O computador alterou a palavra:

```text
Servidor:

revision = 8
```

Enquanto isso, o celular também alterou sua revision 7.

Quando celular enviar:

```text
base_revision = 7
```

servidor possui:

```text
revision = 8
```

Logo:

```text
CONFLITO
```

Nenhuma versão será silenciosamente sobrescrita.

---

# ETAPA 20 — Central de conflitos

Criar uma tela:

```text
Conflitos de sincronização

1 conflito encontrado
```

Ao abrir:

```text
ALCOVA

VERSÃO DESTE DISPOSITIVO

Significado:
Pequeno espaço recuado...

Exemplo:
...

----------------------------

VERSÃO DO SERVIDOR

Significado:
Pequeno aposento...

Exemplo:
...

[ Manter deste dispositivo ]

[ Manter versão do servidor ]

[ Mesclar ]
```

O requisito mínimo será:

```text
Local
ou
Servidor
```

Mas já deixaria a arquitetura preparada para:

```text
Mesclar campo por campo
```

---

# 21. Conflito por palavra duplicada

Existe um caso diferente.

Dispositivo A offline:

```text
casas
→ lema: casa
```

Dispositivo B offline:

```text
casa
→ lema: casa
```

Os dois bancos locais permitem inicialmente porque não conhecem um ao outro.

Ao sincronizar:

```text
Servidor detecta:

pt-BR:casa
já existe.
```

Criar:

```text
DUPLICATE_LEMMA_CONFLICT
```

Mostrar ambas para o usuário.

Ele poderá:

```text
manter A
manter B
mesclar informações
```

A constraint UNIQUE do servidor impede que as duas sobrevivam como registros diferentes.

---

# 22. Sincronização idempotente

Toda operação terá:

```text
operation_id
```

Se uma requisição for enviada duas vezes por falha de conexão:

```text
operação ABC
operação ABC novamente
```

o servidor reconhecerá:

```text
ABC já processada.
```

e não criará duplicações.

---

# ETAPA 23 — Sincronização de imagens

Depois que texto estiver funcionando corretamente.

Fluxo:

```text
imagem local
   ↓
calcular hash
   ↓
upload
   ↓
Storage
   ↓
guardar remote_path
```

Texto e mídia terão estados de sincronização independentes.

Assim uma falha no upload da imagem não impede o significado da palavra de sincronizar.

---

# ETAPA 24 — Cadastro manual

Agora teremos o primeiro fluxo definitivo.

```text
Nova palavra
   ↓
Manual
```

Formulário:

```text
Palavra
Idioma
Significado

Exemplos

Sinônimos

Antônimos

Observações

Imagem
```

Ao salvar:

```text
palavra
 ↓
lematização local
 ↓
verificação de duplicidade
 ↓
validação
 ↓
SQLite
 ↓
outbox
 ↓
sincronização, se disponível
```

---

# ETAPA 25 — Cadastro por IA

Segundo fluxo:

```text
Nova palavra

[ Manual ]

[ Preencher com IA ]
```

Usuário escolhe IA:

```text
Palavra:
"alcovas"
```

Fluxo:

```text
"alcovas"
    ↓
normalização
    ↓
lematização LOCAL
    ↓
"alcova"
    ↓
verificação de duplicidade
```

Se existir:

```text
Abrir "alcova"
```

e não consumir IA.

Se não existir:

```text
Gemini
```

recebe aproximadamente:

```text
Idioma: pt-BR
Palavra original: alcovas
Lema confirmado: alcova

Retorne informações para preencher
um verbete de dicionário pessoal.
```

---

# ETAPA 26 — JSON estruturado da IA

Não pedir:

```text
"responda em JSON por favor"
```

e torcer para funcionar.

Usar resposta estruturada com schema.

A Gemini API possui suporte a Structured Outputs usando JSON Schema.

Contrato conceitual:

```json
{
  "meaning": "...",
  "examples": ["..."],
  "synonyms": ["..."],
  "antonyms": ["..."],
  "notes": "..."
}
```

A IA **não decide o lema**.

O lema já foi definido pelo mecanismo determinístico do aplicativo.

---

# ETAPA 27 — IA nunca salva automaticamente

Fluxo obrigatório:

```text
Gemini
 ↓
JSON
 ↓
validação
 ↓
formulário preenchido
 ↓
USUÁRIO REVISA
 ↓
Salvar
```

Exemplo:

```text
IA preencheu:

Significado:
Pequeno aposento...

Exemplos:
...

Sinônimos:
...

[ Editável ]
```

Somente depois:

```text
SALVAR
```

Isso evita transformar erro da IA em dado permanente sem revisão.

---

# ETAPA 28 — Abstração de IA

Criar:

```dart
abstract interface class AiDictionaryProvider {
  Future<GeneratedEntry> generateEntry({
    required String lemma,
    required String originalWord,
    required String languageCode,
  });
}
```

Primeira implementação:

```text
GeminiAiDictionaryProvider
```

Futuramente:

```text
OpenAiDictionaryProvider
LocalAiDictionaryProvider
```

---

# ETAPA 29 — Google e Gemini

Separar dois conceitos na interface.

## Entrar com Google

```text
[ Continuar com Google ]
```

Serve para:

```text
conta
assinatura
sincronização
identidade
```

## Conectar Google AI

Em Configurações:

```text
IA

Google Gemini

[ Conectar ]
```

Serve para autorizar utilização da API.

Essas conexões não devem ser tratadas como se fossem a mesma coisa.

---

# 30. Importante sobre a conta Gemini

O objetivo será:

```text
usuário usa a própria infraestrutura Google AI
```

Mas o produto não deverá assumir que:

```text
"Tenho Gemini Pro"
=
"meu aplicativo pode usar gratuitamente essa conta"
```

A utilização da API depende da infraestrutura de API/Google Cloud e suas quotas.

Portanto o módulo será preparado para:

```text
Google OAuth
+
Google Cloud quota project
```

ou outro mecanismo oficial que estiver disponível no momento da implementação.

Se a experiência exigida pelo Google for ruim demais para usuários comuns, a arquitetura permitirá futuramente trocar para:

```text
IA paga pelo próprio aplicativo
+
limite mensal
```

sem modificar o módulo do dicionário.

---

# ETAPA 31 — Particularidade do Linux

O desenvolvimento será feito no Ubuntu.

Flutter suporta desenvolvimento de aplicações Linux desktop.

Entretanto, o plugin oficial `google_sign_in` atualmente lista suporte para:

```text
Android
iOS
macOS
Web
```

e não lista Linux.

Portanto, para Linux, a arquitetura não dependerá diretamente desse plugin.

A autenticação desktop deverá utilizar fluxo OAuth via navegador.

Exemplo conceitual:

```text
App Linux
  ↓
Abrir navegador
  ↓
Google OAuth
  ↓
Usuário autoriza
  ↓
retorno ao aplicativo
```

Essa decisão evita travar o projeto em Android.

---

# ETAPA 32 — Planos comerciais

Inicialmente apenas dois.

## FREE — R$ 0

Inclui:

```text
dicionário offline
palavras ilimitadas localmente
cadastro manual
lematização
pesquisa
imagens locais
importação/exportação
IA com credenciais/conta compatível do próprio usuário
```

Não inclui:

```text
sincronização em nuvem
backup em nuvem
sincronização das imagens
```

Android:

```text
com propagandas
```

---

# ETAPA 33 — Plano SYNC

Preço inicial sugerido:

```text
R$ 9,90 / mês
```

Inclui:

```text
tudo do plano gratuito

+

sincronização entre dispositivos
backup no servidor
sincronização de imagens
resolução de conflitos
múltiplos dispositivos
sem propagandas
```

A IA continua utilizando a configuração do próprio usuário.

Portanto:

```text
R$ 9,90
```

é principalmente pelo:

```text
servidor
storage
sincronização
backup
operação do serviço
remoção de anúncios
```

e não pela compra de tokens de IA.

O preço deverá ser validado depois que os custos reais de servidor e armazenamento forem conhecidos.

---

# 34. Limite de armazenamento

Não oferecer inicialmente:

```text
imagens ilimitadas
```

Texto ocupa muito pouco.

Imagem pode se tornar o maior custo do servidor.

Definir, por exemplo:

```text
Plano Sync

1 GB de mídia
```

O limite poderá ser alterado comercialmente sem alterar a arquitetura.

---

# ETAPA 35 — Propagandas

No Android:

```text
Google AdMob
```

O plugin oficial Google Mobile Ads para Flutter atualmente suporta Android e iOS, mas não desktop.

Portanto:

```text
Android Free → anúncios
Android Sync → sem anúncios

Linux Free → sem AdMob
Linux Sync → sem anúncios
```

Não tentar inventar uma solução de anúncios desktop apenas para manter paridade.

Se futuramente houver motivo comercial, avaliar um sistema específico para desktop.

---

# ETAPA 36 — Assinatura Android

Utilizar:

```text
Google Play Billing
```

O Google Play Billing possui suporte oficial a assinaturas recorrentes e seus respectivos entitlements.

Fluxo:

```text
Usuário compra
    ↓
Google Play
    ↓
Backend valida
    ↓
subscription_entitlements
    ↓
usuário recebe Sync
```

Nunca confiar apenas em:

```dart
isPremium = true;
```

no aplicativo.

O servidor é quem decide o entitlement.

---

# 37. Entitlement

Modelo conceitual:

```text
user_id
plan
status
starts_at
expires_at
provider
provider_subscription_id
```

Exemplo:

```text
plan = sync
status = active
```

O Linux consulta a mesma conta.

Portanto:

```text
comprou no Android
      ↓
mesma conta Google
      ↓
Linux reconhece o plano
```

---

# ETAPA 38 — Funcionamento Premium offline

Se o usuário pagou e ficou sem internet:

```text
não remover Premium imediatamente.
```

O aplicativo manterá um estado local de entitlement com período de tolerância.

Quando voltar à internet:

```text
revalidar assinatura.
```

Naturalmente:

```text
sincronização
```

não funciona sem internet.

Mas:

```text
uso do dicionário
```

continua funcionando.

---

# ETAPA 39 — Testes essenciais

Antes de lançamento, criar testes específicos.

## Lematização

```text
entrada flexionada
→ lema correto
```

## Duplicação

```text
Casa
casa
casas

→ não gerar entradas duplicadas quando
o mecanismo determinar o mesmo lema
```

## Banco

```text
migração v1 → v2
migração v2 → v3
```

## Sync

Simular:

```text
Dispositivo A
Dispositivo B
Servidor
```

---

# 40. Cenários obrigatórios de sincronização

## Cenário A

```text
A cria palavra offline
A fica online
B sincroniza
```

Resultado:

```text
palavra aparece em B
```

## Cenário B

```text
A edita offline
B edita offline
```

Resultado:

```text
conflito
```

## Cenário C

```text
A adiciona "casas"
B adiciona "casa"
```

Resultado após lematização:

```text
conflito de lema
```

## Cenário D

```text
A apaga
B modifica
```

Resultado:

```text
conflito delete/update
```

## Cenário E

Mesma operação enviada duas vezes.

Resultado:

```text
uma única alteração
```

## Cenário F

Aplicativo fecha no meio da sincronização.

Resultado:

```text
reiniciar sincronização
sem perder dados
sem duplicar dados
```

---

# ETAPA 41 — Segurança

Nunca guardar no SQLite:

```text
senha Google
client secret
segredo do backend
chave privada de servidor
```

Credenciais e tokens sensíveis deverão utilizar armazenamento seguro específico da plataforma.

As imagens sincronizadas serão privadas.

Cada usuário só poderá acessar:

```text
seus próprios registros
seus próprios arquivos
```

---

# ETAPA 42 — Observabilidade

Quando houver servidor, registrar:

```text
sync_started
sync_finished
sync_failed

conflict_detected
conflict_resolved

ai_request_failed

upload_failed
```

Sem armazenar desnecessariamente o conteúdo privado do dicionário nos logs.

---

# ETAPA 43 — Backup e portabilidade

Mesmo no plano gratuito, permitir futuramente:

```text
Exportar meu dicionário
```

Por exemplo:

```text
JSON
```

E:

```text
Importar dicionário
```

A importação obrigatoriamente passa novamente por:

```text
validação
lematização
duplicidade
```

Nunca inserir JSON diretamente no banco.

---

# 44. Ordem real de desenvolvimento

Não desenvolver todas as funcionalidades simultaneamente.

A ordem será:

```text
1. Ambiente Ubuntu
       ↓
2. Dart
       ↓
3. Flutter básico
       ↓
4. Modelo DictionaryEntry
       ↓
5. Drift + SQLite
       ↓
6. CRUD offline
       ↓
7. Lemmatização
       ↓
8. Garantia de unicidade
       ↓
9. Pesquisa
       ↓
10. Imagens locais
       ↓
11. Repository
       ↓
12. Outbox
       ↓
13. Backend
       ↓
14. Login
       ↓
15. Sync básico
       ↓
16. Revisionamento
       ↓
17. Conflitos
       ↓
18. Sync das imagens
       ↓
19. IA
       ↓
20. OAuth Google AI
       ↓
21. Assinatura
       ↓
22. Propagandas
       ↓
23. Hardening
       ↓
24. Publicação
```

---

# 45. Marcos do projeto

## Marco 1 — Dicionário

```text
Android + Linux
CRUD
SQLite
pesquisa
```

Aplicativo já funciona offline.

---

## Marco 2 — Dicionário inteligente

```text
lematização
unicidade
imagens
```

O núcleo do produto está pronto.

---

## Marco 3 — Offline-first

```text
outbox
revision
sync status
device id
tombstones
```

Ainda pode utilizar servidor falso nos testes.

---

## Marco 4 — Cloud

```text
conta
PostgreSQL
sincronização
storage
```

Dois dispositivos conseguem compartilhar um dicionário.

---

## Marco 5 — Sync robusto

```text
conflito de edição
conflito de exclusão
conflito de lema
central de conflitos
```

Agora a sincronização pode ser considerada confiável.

---

## Marco 6 — IA

```text
Google authorization
Gemini
Structured Output
pré-preenchimento
revisão
salvamento
```

---

## Marco 7 — Monetização

```text
Free
Sync R$ 9,90/mês
AdMob Android
Play Billing
entitlements
```

---

## Marco 8 — Produto

```text
testes
telemetria
backup
exportação
política de privacidade
tratamento de erros
atualizações de banco
publicação
```

---

# 46. Princípio mais importante

Não começar pelo servidor.

Não começar pela IA.

Não começar pelo pagamento.

Não começar pela sincronização.

Começar por:

```text
palavra
  ↓
lematização
  ↓
unicidade
  ↓
SQLite
```

Quando isso estiver sólido:

```text
SQLite
  ↓
Sync Engine
  ↓
Servidor
```

Depois:

```text
IA
assinatura
anúncios
```

Assim cada camada nova é adicionada sobre um núcleo que já funciona, em vez de o projeto depender de dez serviços externos desde o primeiro dia.

# Primeira meta concreta

O primeiro objetivo técnico do projeto será extremamente pequeno:

```text
Ubuntu
  ↓
Flutter instalado
  ↓
app rodando no Android
  ↓
app rodando no Linux
  ↓
criar DictionaryEntry
  ↓
formulário "Nova palavra"
  ↓
lista em memória
```

Nem SQLite ainda.

Depois que isso estiver funcionando, entraremos no banco local.

Essa será a base sobre a qual todo o restante será construído.
