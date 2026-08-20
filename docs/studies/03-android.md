# Preparação do Android

## Partes necessárias

Android Studio é o programa oficial usado para administrar as ferramentas de desenvolvimento Android. Mesmo quando o código é escrito em outro editor, ele facilita a instalação dos demais componentes.

Android SDK é o conjunto de ferramentas que constrói o aplicativo Android. Ele não é o próprio sistema Android e não faz parte do código do LexisApp.

Um emulador cria um aparelho Android virtual dentro do computador. Como alternativa, pode-se usar um aparelho físico conectado por cabo USB.

## Configuração pelo Android Studio

No administrador de SDK do Android Studio, devem ser instalados:

- uma versão estável da plataforma Android;
- as ferramentas de construção dessa plataforma;
- as ferramentas de linha de comando;
- as ferramentas de comunicação com aparelhos;
- o emulador, caso seja usado um aparelho virtual.

Depois, é preciso aceitar as licenças de uso:

```bash
flutter doctor --android-licenses
```

## Usar um emulador

No administrador de aparelhos do Android Studio, cria-se um aparelho virtual e baixa-se uma imagem do Android. O aparelho virtual precisa estar iniciado antes de executar o projeto.

Os aparelhos reconhecidos podem ser conferidos com:

```bash
flutter devices
```

Para abrir o aplicativo em um aparelho reconhecido:

```bash
flutter run -d ID_DO_APARELHO
```

`ID_DO_APARELHO` é o identificador mostrado por `flutter devices`.

## Usar um aparelho físico

No aparelho, é necessário liberar as opções de desenvolvedor e a depuração USB. Ao conectar o cabo, o aparelho pede autorização para confiar no computador. O comando `adb devices` deve então mostrá-lo como autorizado.

## Estrutura exigida no repositório

Um projeto Flutter preparado para Android possui uma pasta `android/`. Se ela estiver ausente, o suporte pode ser gerado a partir da raiz do projeto:

```bash
flutter create --platforms=android .
```

Esse comando cria arquivos de plataforma; antes de executá-lo, é prudente guardar o estado atual do projeto no controle de versões.

## Resultado esperado

O Android está pronto quando existe a pasta `android/`, `flutter doctor` aprova as ferramentas Android, `flutter devices` encontra um aparelho e `flutter run` abre o LexisApp nele.

