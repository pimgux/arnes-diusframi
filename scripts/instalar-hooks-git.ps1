# Activa los hooks de git del repo (.githooks) y comprueba las herramientas.
$raiz = Split-Path -Parent $PSScriptRoot
Set-Location $raiz

if (-not (Test-Path (Join-Path $raiz '.git'))) { git init | Out-Null; Write-Host 'Repositorio git inicializado.' }
git config core.hooksPath .githooks
Write-Host 'core.hooksPath = .githooks'

$herramientas = @{
    'gitleaks'    = 'winget install gitleaks.gitleaks'
    'govulncheck' = 'go install golang.org/x/vuln/cmd/govulncheck@latest'
    'cargo-audit' = 'cargo install cargo-audit'
    'npm'         = 'instalar Node.js'
}
foreach ($h in $herramientas.GetEnumerator()) {
    if (Get-Command $h.Key -ErrorAction SilentlyContinue) { Write-Host "OK    $($h.Key)" }
    else { Write-Host "FALTA $($h.Key)  ->  $($h.Value)" }
}
