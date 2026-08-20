# Preparação do Linux

## O que significa suporte a Linux

No Linux, o Flutter transforma a interface Dart em um programa de computador. O projeto guarda os arquivos específicos dessa plataforma na pasta `linux/`.

## Ferramentas necessárias no Ubuntu

Além do Flutter, a construção usa um compilador e bibliotecas da interface gráfica do sistema. Uma instalação típica é:

```bash
sudo apt update
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
```

Cada pacote tem uma finalidade simples:

- `clang` transforma parte do projeto em código executável;
- `cmake` organiza as regras de construção;
- `ninja-build` executa essas regras;
- `pkg-config` localiza bibliotecas instaladas;
- `libgtk-3-dev` fornece a interface de janelas do Linux;
- `liblzma-dev` fornece funções de compactação usadas pelas ferramentas.

O suporte de computador deve estar habilitado:

```bash
flutter config --enable-linux-desktop
```

## Executar e construir

Para abrir o aplicativo durante o desenvolvimento:

```bash
flutter run -d linux
```

Para criar uma versão final:

```bash
flutter build linux --release
```

O resultado final fica dentro de `build/linux/`. O executável deve ser mantido junto das pastas `data` e `lib` criadas no mesmo pacote; copiar somente o executável pode impedir sua abertura.

## Limitação futura de login

O aplicativo básico pode funcionar normalmente no Linux. O documento de visão prevê, porém, que o futuro login do Google use o navegador nessa plataforma. Essa escolha evita depender de um componente de login que não oferece o mesmo suporte em todos os sistemas. Isso não interfere na tela atual nem no uso sem internet.

## Resultado esperado

O Linux está pronto quando `flutter doctor` aprova a ferramenta de Linux e `flutter run -d linux` abre uma janela do LexisApp.

