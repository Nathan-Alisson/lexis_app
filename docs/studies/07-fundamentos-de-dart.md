# Fundamentos de Dart sem jargões

Este manual ensina somente o Dart necessário para começar o LexisApp. Ele pode ser lido sem os outros documentos e não exige experiência com programação.

Os exemplos podem ser testados no [DartPad](https://dartpad.dev/) ou em um arquivo com extensão `.dart`. Em um arquivo local, use:

```bash
dart run nome_do_arquivo.dart
```

## Como ler um programa

Um programa é uma lista de instruções. A execução começa na função `main`:

```dart
void main() {
  print('Olá, LexisApp!');
}
```

- `void` informa que a função não entrega um resultado.
- `main` é o ponto de início.
- Parênteses `()` guardam as informações recebidas pela função. Aqui não há nenhuma.
- Chaves `{}` delimitam as instruções da função.
- `print` mostra algo no terminal.
- O ponto e vírgula `;` encerra uma instrução.
- Texto fica entre aspas.

Linhas iniciadas por `//` são comentários para pessoas e não são executadas:

```dart
// Esta linha explica o código.
print('Esta linha é executada.');
```

## Valores e variáveis

Uma variável é um nome dado a um valor para poder usá-lo depois:

```dart
String word = 'alcova';
int reviewCount = 3;
double progress = 0.75;
bool isFavorite = true;
```

Os tipos dizem qual espécie de valor cabe em cada variável:

| Tipo | Guarda | Exemplo |
| --- | --- | --- |
| `String` | texto | `'alcova'` |
| `int` | número inteiro | `3` |
| `double` | número com parte decimal | `0.75` |
| `bool` | verdadeiro ou falso | `true` |

O sinal `=` coloca o valor da direita no nome da esquerda. Para inserir um valor em um texto, use `$`:

```dart
print('Palavra: $word');
```

### `var`, `final` e `const`

Dart pode descobrir o tipo pelo valor:

```dart
var language = 'pt-BR'; // Dart entende que é String.
```

Prefira `final` quando o nome não deva receber outro valor depois:

```dart
final createdAt = DateTime.now();
```

Use `const` quando o valor já for conhecido antes de o aplicativo executar:

```dart
const maximumExamples = 5;
```

`final` e `const` evitam mudanças acidentais. Isso é a base da **imutabilidade**: criar um novo valor em vez de alterar silenciosamente o antigo.

## Coleções: vários valores juntos

### List

`List` é uma lista ordenada. Um item pode se repetir:

```dart
final examples = <String>[
  'A cama fica na alcova.',
  'A alcova recebe pouca luz.',
];

print(examples[0]); // O primeiro lugar é o número 0.
print(examples.length); // Quantidade de itens.
```

`<String>` informa que todos os itens são textos.

### Set

`Set` é um conjunto que não mantém itens repetidos:

```dart
final tags = <String>{'casa', 'arquitetura', 'casa'};
print(tags); // {casa, arquitetura}
```

### Map

`Map` relaciona uma chave a um valor, como uma pequena ficha:

```dart
final meanings = <String, String>{
  'alcova': 'Pequeno aposento.',
  'casa': 'Lugar usado como moradia.',
};

print(meanings['alcova']);
```

O primeiro `String` é o tipo da chave; o segundo é o tipo do valor.

## Ausência de valor e null safety

`null` significa “não há valor”. Dart exige que essa possibilidade seja declarada com `?`:

```dart
String word = 'alcova'; // Sempre deve ter texto.
String? imagePath;      // Pode ter texto ou não ter valor.
```

Antes de usar um valor opcional, verifique se ele existe:

```dart
if (imagePath != null) {
  print('Imagem: $imagePath');
} else {
  print('Esta palavra não possui imagem.');
}
```

Também é possível fornecer uma alternativa com `??`:

```dart
print(imagePath ?? 'Sem imagem');
```

Evite `!` no começo. Ele força Dart a acreditar que o valor existe e causa erro durante a execução se isso não for verdade.

## Funções

Uma função reúne instruções que realizam uma tarefa. Ela pode receber valores e entregar um resultado:

```dart
String normalizeWord(String word) {
  return word.trim().toLowerCase();
}

void main() {
  final normalized = normalizeWord('  Alcova ');
  print(normalized); // alcova
}
```

O primeiro `String` é o tipo do resultado. `String word` é a entrada. `return` entrega o resultado.

Entradas nomeadas tornam a chamada mais legível. `required` torna a entrada obrigatória:

```dart
String label({required String word, required String language}) {
  return '$word ($language)';
}

final text = label(word: 'alcova', language: 'pt-BR');
```

## Classes e objetos

Uma classe é o modelo de uma coisa do aplicativo. Um objeto é uma ficha criada a partir desse modelo:

```dart
class DictionaryEntry {
  final String word;
  final String meaning;
  final List<String> examples;

  const DictionaryEntry({
    required this.word,
    required this.meaning,
    this.examples = const [],
  });
}

void main() {
  const entry = DictionaryEntry(
    word: 'alcova',
    meaning: 'Pequeno aposento.',
    examples: ['A cama fica na alcova.'],
  );

  print(entry.meaning);
}
```

O trecho com o mesmo nome da classe é o **construtor**: ele recebe os dados necessários para criar a ficha. `this.word` coloca o valor recebido no campo `word`. `const []` é a lista vazia usada quando nenhum exemplo é informado.

Como os campos são `final`, a ficha não muda depois de criada. Para representar uma edição, crie outra:

```dart
final editedEntry = DictionaryEntry(
  word: entry.word,
  meaning: 'Pequeno espaço recuado de um aposento.',
  examples: entry.examples,
);
```

Essa imutabilidade torna mudanças mais previsíveis e reduz erros.

## Enums: opções limitadas

Um `enum` representa uma escolha entre opções conhecidas:

```dart
enum EntryStatus { draft, saved, deleted }

final status = EntryStatus.saved;

if (status == EntryStatus.saved) {
  print('Verbete salvo.');
}
```

É mais seguro do que escrever textos livres como `'salvo'`, `'Salvo'` ou `'save'`.

## Interfaces: um acordo de comportamento

Uma interface declara o que uma parte do aplicativo deve saber fazer, sem decidir como fará. Pense nela como uma tomada: aparelhos diferentes funcionam se respeitarem o mesmo encaixe.

```dart
abstract interface class DictionaryRepository {
  Future<void> save(DictionaryEntry entry);
  Future<List<DictionaryEntry>> findAll();
}
```

Não é possível criar uma ficha `DictionaryRepository` diretamente, pois ela contém apenas o acordo. Uma classe concreta cumpre esse acordo:

```dart
class MemoryDictionaryRepository implements DictionaryRepository {
  final List<DictionaryEntry> _entries = [];

  @override
  Future<void> save(DictionaryEntry entry) async {
    _entries.add(entry);
  }

  @override
  Future<List<DictionaryEntry>> findAll() async {
    return List.unmodifiable(_entries);
  }
}
```

O sublinhado em `_entries` indica que esse detalhe só deve ser usado dentro do mesmo arquivo. `implements` diz que a classe cumprirá o acordo. `@override` marca as operações que vêm dele.

No LexisApp, esse acordo permite trocar a memória por SQLite sem mudar a tela que pede para salvar.

## Generics: um espaço para indicar o tipo

O `T` em `Future<T>` é um espaço que será preenchido por um tipo:

```dart
class Result<T> {
  final T value;

  const Result(this.value);
}

const wordResult = Result<String>('alcova');
const countResult = Result<int>(3);
```

A mesma caixa `Result` pode guardar texto ou número e Dart ainda consegue impedir uma mistura indevida. `List<String>`, `Set<String>` e `Map<String, String>` usam a mesma ideia.

## Exceptions: quando uma operação não consegue terminar

Uma exception é um aviso de que uma operação falhou. Lance uma com `throw`:

```dart
String validateWord(String word) {
  final normalized = word.trim();

  if (normalized.isEmpty) {
    throw ArgumentError('A palavra não pode ficar vazia.');
  }

  return normalized;
}
```

Quem chama pode tratar a falha:

```dart
try {
  print(validateWord('   '));
} on ArgumentError catch (error) {
  print(error.message);
}
```

Use exceptions para falhas que interrompem uma operação. Uma opção normal, como “verbete sem imagem”, deve ser representada por um valor opcional, não por uma exception.

## Future, async e await

Algumas tarefas demoram, como ler o banco. `Future<T>` representa um resultado que chegará depois. O aplicativo pode continuar funcionando enquanto espera.

```dart
Future<String> loadMeaning() async {
  await Future<void>.delayed(const Duration(milliseconds: 100));
  return 'Pequeno aposento.';
}

Future<void> main() async {
  print('Buscando...');
  final meaning = await loadMeaning();
  print(meaning);
}
```

- `async` permite que a função use `await`.
- `await` espera o resultado daquela tarefa sem travar todo o aplicativo.
- Depois de `await`, a variável contém o valor pronto, não o `Future`.

Falhas de uma tarefa futura também podem ser tratadas com `try` e `catch` ao redor do `await`.

## Stream: valores que chegam ao longo do tempo

Um `Future` entrega um resultado uma vez. Um `Stream` pode entregar vários resultados, como uma torneira aberta. Ele é útil para observar alterações no banco:

```dart
Stream<int> countUp() async* {
  yield 1;
  yield 2;
  yield 3;
}

Future<void> main() async {
  await for (final number in countUp()) {
    print(number);
  }
}
```

`async*` cria um fluxo e cada `yield` envia um novo valor. `await for` recebe os valores até o fluxo terminar. No aplicativo, um fluxo do banco poderá atualizar a lista na tela sempre que um verbete mudar.

## Testes unitários

Um teste unitário verifica uma regra pequena automaticamente. No projeto Flutter, arquivos de teste ficam em `test/` e seus nomes terminam em `_test.dart`.

Exemplo para a função `normalizeWord`:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('remove espaços e converte a palavra para minúsculas', () {
    final result = normalizeWord('  Alcova ');

    expect(result, 'alcova');
  });
}
```

Execute todos os testes com:

```bash
flutter test
```

Um bom teste tem três partes: prepara os dados, executa uma ação e confere o resultado. Teste regras próprias do LexisApp; não é necessário testar se a própria linguagem sabe somar números.

## Pequeno exercício completo

Crie um arquivo `practice.dart` com o código abaixo e complete a função `findByWord`:

```dart
class DictionaryEntry {
  final String word;
  final String meaning;

  const DictionaryEntry({required this.word, required this.meaning});
}

DictionaryEntry? findByWord(
  List<DictionaryEntry> entries,
  String searchedWord,
) {
  // Percorra entries e devolva o verbete correspondente.
  // Se ele não existir, devolva null.
  return null;
}

void main() {
  const entries = [
    DictionaryEntry(word: 'alcova', meaning: 'Pequeno aposento.'),
    DictionaryEntry(word: 'casa', meaning: 'Lugar usado como moradia.'),
  ];

  final found = findByWord(entries, 'alcova');
  print(found?.meaning ?? 'Palavra não encontrada.');
}
```

Uma solução possível:

```dart
for (final entry in entries) {
  if (entry.word == searchedWord) {
    return entry;
  }
}
return null;
```

`for` visita cada item. `if` executa seu bloco somente quando a comparação com `==` é verdadeira. O primeiro `return` encerra a busca ao encontrar a palavra.

## O que aprender depois

Este conteúdo já basta para começar a criar modelos, regras, repositórios simples e testes. Não é necessário decorar tudo. Consulte o manual quando um conceito aparecer no projeto e avance para Flutter praticando uma pequena funcionalidade de cada vez.
