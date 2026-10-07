@echo off
setlocal

REM Define um título para a janela do terminal
title Lua-Prill - Ferramenta de utilidades em Lua

REM Define o diretório base do script (a pasta onde o .bat está)
set BASE_DIR=%~dp0

REM Caminho do interpretador Lua
set LUA_EXE=%BASE_DIR%lua\lua55.exe

REM Arquivo principal Lua
set SCRIPT=main.lua

REM Seta pagina de codigo UTF-8 para o console (feito antes dos 'echo' para acentos funcionarem)
chcp 65001 >nul

REM Verifica se o interpretador Lua existe
if not exist "%LUA_EXE%" (
    echo ERRO: Interpretador Lua não encontrado em:
    echo    "%LUA_EXE%"
    echo Verifique o caminho e tente novamente.
    pause
    exit /b 1
)

REM Verifica se o arquivo main.lua existe
if not exist "%BASE_DIR%%SCRIPT%" (
    echo ERRO: O arquivo '%SCRIPT%' não foi encontrado em:
    echo    "%BASE_DIR%"
    pause
    exit /b 1
)

REM Executa o script Lua repassando possíveis argumentos (%*)
pushd "%BASE_DIR%"
"%LUA_EXE%" "%SCRIPT%" %*

REM Salva o status de saída do Lua (0 = Sucesso, Diferente de 0 = Erro)
set EXIT_CODE=%errorlevel%
popd

REM Se o Lua crashar por algum erro no código (ex: erro de sintaxe)
if %EXIT_CODE% neq 0 (
    echo.
    echo ----------------------------------------------------
    echo [AVISO] O script Lua encerrou com erro ^(Codigo: %EXIT_CODE%^).
    echo ----------------------------------------------------
    pause
    exit /b %EXIT_CODE%
)

REM Só exibe encerramento amigável se não teve erros
echo.
echo Programa finalizado. Pressione qualquer tecla para sair.
pause >nul