# Auditoria de seguridad fija: gitleaks + govulncheck + cargo audit + npm audit.
# Uso: scripts/auditoria.ps1 [-Estricto]   (-Estricto: falla tambien si falta una herramienta)
param([switch]$Estricto)

$raiz = Split-Path -Parent $PSScriptRoot
$fallos = New-Object System.Collections.Generic.List[string]
$excluir = '\\(node_modules|target|vendor|\.git)(\\|$)'

function Test-Herramienta($exe, $instalar) {
    if (Get-Command $exe -ErrorAction SilentlyContinue) { return $true }
    Write-Host "AVISO: '$exe' no instalado. Instalar: $instalar"
    if ($Estricto) { $script:fallos.Add("herramienta ausente: $exe") }
    return $false
}

function Find-Proyectos($archivo) {
    Get-ChildItem -Path $raiz -Filter $archivo -Recurse -Depth 1 -File -ErrorAction SilentlyContinue |
        Where-Object { $_.DirectoryName -notmatch $excluir } |
        ForEach-Object { $_.DirectoryName }
}

Write-Host '== gitleaks (repositorio completo)'
if (Test-Herramienta 'gitleaks' 'winget install gitleaks.gitleaks') {
    $cfg = Join-Path $raiz '.gitleaks.toml'
    gitleaks detect --source $raiz --config $cfg --redact --no-banner
    if ($LASTEXITCODE -ne 0) { $fallos.Add('gitleaks: secretos detectados') }
}

foreach ($d in Find-Proyectos 'go.mod') {
    Write-Host "== govulncheck ($d)"
    if (Test-Herramienta 'govulncheck' 'go install golang.org/x/vuln/cmd/govulncheck@latest') {
        Push-Location $d; govulncheck ./...; if ($LASTEXITCODE -ne 0) { $fallos.Add("govulncheck ($d)") }; Pop-Location
    }
}

foreach ($d in Find-Proyectos 'Cargo.toml') {
    Write-Host "== cargo audit ($d)"
    if (Test-Herramienta 'cargo-audit' 'cargo install cargo-audit') {
        Push-Location $d; cargo audit; if ($LASTEXITCODE -ne 0) { $fallos.Add("cargo audit ($d)") }; Pop-Location
    }
}

foreach ($d in Find-Proyectos 'package.json') {
    Write-Host "== npm audit ($d)"
    if (Test-Herramienta 'npm' 'instalar Node.js') {
        Push-Location $d; npm audit --audit-level=high; if ($LASTEXITCODE -ne 0) { $fallos.Add("npm audit ($d)") }; Pop-Location
    }
}

if ($fallos.Count -gt 0) {
    Write-Host "`nAUDITORIA CON HALLAZGOS:"; $fallos | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "`nAuditoria OK."
exit 0
