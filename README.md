# lua-prill

Utilitário de linha de comando em Lua para manipulação de textos, conversões (HEX, Base64) e formatação de strings JSON. O projeto é totalmente portátil e não requer instalação do Lua no sistema.

## 🚀 Funcionalidades

- **Conversão Hexadecimal:** Converte strings HEX (com ou sem espaços) para texto legível.
- **Manipulação JSON:** Escapa e desescapa caracteres especiais de strings para uso seguro em payloads JSON.
- **Conversão Base64:** Codifica textos para Base64 e decodifica de volta para texto (implementação nativa).
- **Contagem de Caracteres:** Conta o tamanho de textos, nomes de branch e strings em geral (com suporte nativo a acentos/UTF-8).

## 🛠️ Como usar

O projeto já inclui o interpretador Lua, então não é necessário instalar nada na sua máquina.

1. Baixe ou clone este repositório.
2. Execute o arquivo `run.bat` para iniciar o menu interativo.

### Menu do programa

- **1:** Converter HEX para texto (`48 65 6C 6C 6F` ➔ `Hello`)
- **2:** Escapar string para JSON (Prepara textos com aspas e quebras de linha para JSON)
- **3:** Desescapar string JSON (Restaura o texto original de um JSON)
- **4:** Contar caracteres (Conta letras de uma branch ou texto)
- **5:** Converter texto para Base64
- **6:** Converter Base64 para texto
- **0:** Sair

## 🌟 Criando um atalho na Área de Trabalho

Para facilitar o uso no dia a dia, você pode criar um atalho do programa direto na sua Área de Trabalho com um ícone personalizado.

Basta dar um **duplo clique** no arquivo:
👉 `instalar_atalho.bat`

*Nota: Esse arquivo `.bat` foi criado especialmente para executar o script `criar_atalho.ps1` contornando automaticamente as políticas de bloqueio de segurança do Windows, sem que você precise digitar comandos.*

> **Observação:** Se você mover a pasta do projeto para outro local no seu computador, o atalho perderá a referência. Basta executar o `instalar_atalho.bat` novamente no novo local para atualizar o atalho!

## ⚙️ Requisitos

- Sistema Operacional: Windows
- Nenhuma instalação extra é necessária. O interpretador nativo (Lua 5.5) já está incluso na pasta do projeto, utilizando os binários oficiais do projeto [LuaBinaries](https://luabinaries.sourceforge.net/).

## 🧠 Estrutura do Código

- O programa faz tratamento de erros nativo para entradas inválidas, impedindo "crashes".
- A lógica principal de interface está em `main.lua`.
- Todas as funções utilitárias (matemáticas e de string) ficam isoladas de forma limpa em `utils.lua`.