# Pre-commit: bloquea el commit si gitleaks encuentra secretos en lo staged.
$raiz = Split-Path -Parent $PSScriptRoot
if (-not (Get-Command gitleaks -ErrorAction SilentlyContinue)) {
    Write-Host 'BLOQUEADO: gitleaks no esta instalado. Instalar: winget install gitleaks.gitleaks'
    exit 1
}
gitleaks protect --staged --config (Join-Path $raiz '.gitleaks.toml') --redact --no-banner
if ($LASTEXITCODE -ne 0) {
    Write-Host 'BLOQUEADO: secretos detectados en el commit. Quitalos y usa variables de entorno.'
    exit 1
}
exit 0
