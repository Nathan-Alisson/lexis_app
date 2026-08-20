# Ferramentas básicas

## Git

Git é uma ferramenta que guarda o histórico dos arquivos do projeto. Ele permite comparar alterações e recuperar uma versão anterior do código.

No Ubuntu, a instalação pode ser feita pelo gerenciador de programas do sistema ou pelo terminal:

```bash
sudo apt update
sudo apt install git
```

Para verificar a instalação:

```bash
git --version
```

Um número de versão indica que o programa está disponível. Git não é necessário para abrir o aplicativo, mas é importante para proteger e organizar o trabalho.

## Editor de código

O editor é o programa usado para ler e alterar os arquivos. O projeto pode ser desenvolvido no Visual Studio Code ou no Android Studio.

- Visual Studio Code é menor e mais simples. Para trabalhar com este projeto, deve receber as extensões Flutter e Dart.
- Android Studio ocupa mais espaço, mas também instala e administra as ferramentas do Android.

Não é necessário usar os dois como editores. Mesmo quem escolhe o Visual Studio Code normalmente mantém o Android Studio instalado para administrar o Android SDK e os emuladores.

## Resultado esperado

Esta configuração está pronta quando `git --version` funciona e o editor consegue abrir a pasta do projeto sem alterar sua estrutura.

