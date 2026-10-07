@echo off
echo Criando atalho na area de trabalho...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0criar_atalho.ps1"
pause