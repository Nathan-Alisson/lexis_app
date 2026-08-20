# Verificação do ambiente

## Diagnóstico geral

O comando principal é:

```bash
flutter doctor -v
```

Ele examina o Flutter, o Android e o Linux e explica o que falta. A opção `-v` mostra detalhes úteis, como os caminhos das ferramentas encontradas.

Nem todo aviso impede este projeto. Por exemplo, a falta de ferramentas para iPhone não é um problema no Ubuntu, pois a meta inicial contém somente Android e Linux. Erros nas seções de Android, Linux ou Flutter precisam ser resolvidos.

## Conferências separadas

```bash
flutter --version
flutter pub get
flutter analyze
flutter test
flutter devices
```

- `flutter --version` confirma que a ferramenta abre.
- `flutter pub get` confere os pacotes pedidos pelo projeto.
- `flutter analyze` procura erros no código sem abrir o aplicativo.
- `flutter test` executa verificações automáticas existentes.
- `flutter devices` mostra onde o aplicativo pode ser aberto.

## Teste em cada sistema

No Linux:

```bash
flutter run -d linux
```

No Android, primeiro inicie um emulador ou conecte um aparelho e use:

```bash
flutter run -d ID_DO_APARELHO
```

## Quando considerar a etapa concluída

A preparação inicial termina somente quando a tela do LexisApp abre nas duas plataformas. Uma compilação antiga prova que o projeto já funcionou em algum momento, mas não substitui uma nova execução depois de qualquer mudança no ambiente ou no código.

