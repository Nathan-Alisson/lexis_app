# Flutter e Dart

## O que são

Flutter é o conjunto de ferramentas que transforma o projeto em um aplicativo para cada sistema. Dart é a linguagem em que o comportamento e a interface do aplicativo são escritos.

O Flutter já inclui uma versão compatível do Dart. Por isso, não é necessário instalar Dart separadamente.

## Instalação

O Flutter SDK deve ser instalado em uma pasta na qual o usuário tenha permissão de leitura e escrita. Depois, a pasta `bin` do Flutter deve ser acrescentada ao caminho de programas do terminal. Isso permite usar o comando `flutter` em qualquer pasta.

Após a instalação, estes comandos devem funcionar:

```bash
flutter --version
dart --version
```

## Dependências do projeto

O arquivo `pubspec.yaml` informa o nome, a versão do aplicativo e os pacotes usados. O comando abaixo baixa ou confere esses pacotes:

```bash
flutter pub get
```

O LexisApp ainda usa apenas os pacotes básicos do Flutter. Banco local, sincronização e inteligência artificial descritos no documento de visão ainda não foram adicionados.

## Cuidado com a instalação por Snap

Snap é uma forma de distribuir programas no Ubuntu. Ele pode ser adequado em uma máquina comum, mas ambientes restritos podem impedir que programas Snap sejam executados. Se `flutter --version` apresentar uma mensagem dizendo que aplicativos Snap não podem rodar, a instalação do Flutter não está utilizável naquele ambiente. Uma instalação do SDK fora do Snap será necessária.

## Resultado esperado

A configuração está pronta quando os comandos de versão e `flutter pub get` terminam sem erro.

