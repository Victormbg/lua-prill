# criar_atalho.ps1
# Cria um atalho na área de trabalho para rodar um script com ícone customizado

# Pega o diretório atual do script de forma moderna e nativa
$base = $PSScriptRoot

# Define os caminhos dos arquivos base
$batPath = Join-Path $base "run.bat"
$iconPath = Join-Path $base "lua\lexe.ico"

# Validação: Verifica se o arquivo .bat realmente existe antes de criar o atalho
if (-Not (Test-Path $batPath)) {
    Write-Host "[ERRO] O arquivo run.bat não foi encontrado na pasta $base" -ForegroundColor Red
    Pause
    Exit
}

# Obtém o caminho real da Área de Trabalho (suporta pastas redirecionadas pelo OneDrive)
$desktopPath = [Environment]::GetFolderPath('Desktop')
$atalhoPath = Join-Path $desktopPath "LuaPrill.lnk"

# Cria objeto para manipular atalhos no Windows
$WshShell = New-Object -ComObject WScript.Shell
$Atalho = $WshShell.CreateShortcut($atalhoPath)

# Configura as propriedades do atalho
$Atalho.TargetPath = $batPath
$Atalho.WorkingDirectory = $base

# Só define o ícone se o arquivo .ico realmente existir
if (Test-Path $iconPath) {
    $Atalho.IconLocation = $iconPath
} else {
    Write-Host "[AVISO] Ícone não encontrado em $iconPath. Usando ícone padrão." -ForegroundColor Yellow
}

# Salva o atalho
$Atalho.Save()

# Feedback de sucesso para o usuário
Write-Host "Atalho 'LuaPrill' criado com sucesso na Área de Trabalho!" -ForegroundColor Green
Start-Sleep -Seconds 3 # Aguarda 3 segundos antes de fechar a janela automaticamente