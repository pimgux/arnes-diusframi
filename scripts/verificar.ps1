# Ejecuta tests y lint de todos los stacks detectados (raiz + 1 nivel de subcarpetas).
# Uso: scripts/verificar.ps1 [-SoloTests]
# Exit 0 = todo en verde. Sin stacks detectados = exit 0 (proyecto web estatico, p. ej.).
param([switch]$SoloTests)

$raiz = Split-Path -Parent $PSScriptRoot
$fallos = New-Object System.Collections.Generic.List[string]
$ejecutados = 0

function Invoke-Paso($nombre, $dir, [scriptblock]$bloque) {
    $script:ejecutados++
    Write-Host "== $nombre ($dir)"
    Push-Location $dir
    try {
        & $bloque
        if ($LASTEXITCODE -ne 0) { $script:fallos.Add("$nombre ($dir)") }
    } finally { Pop-Location }
}

function Test-Herramienta($exe, $para) {
    if (Get-Command $exe -ErrorAction SilentlyContinue) { return $true }
    Write-Host "FALTA '$exe' para $para"
    $script:fallos.Add("herramienta ausente: $exe")
    return $false
}

$excluir = '\\(node_modules|target|vendor|\.git)(\\|$)'
function Find-Proyectos($archivo) {
    Get-ChildItem -Path $raiz -Filter $archivo -Recurse -Depth 1 -File -ErrorAction SilentlyContinue |
        Where-Object { $_.DirectoryName -notmatch $excluir } |
        ForEach-Object { $_.DirectoryName }
}

foreach ($d in Find-Proyectos 'go.mod') {
    if (-not (Test-Herramienta 'go' 'proyecto Go')) { break }
    Invoke-Paso 'go test' $d { go test ./... }
    if (-not $SoloTests) { Invoke-Paso 'go vet' $d { go vet ./... } }
}

foreach ($d in Find-Proyectos 'Cargo.toml') {
    if (-not (Test-Herramienta 'cargo' 'proyecto Rust')) { break }
    Invoke-Paso 'cargo test' $d { cargo test }
    if (-not $SoloTests) { Invoke-Paso 'cargo clippy' $d { cargo clippy -- -D warnings } }
}

foreach ($d in Find-Proyectos 'package.json') {
    if (-not (Test-Herramienta 'npm' 'proyecto JS')) { break }
    Invoke-Paso 'npm test' $d { npm test --if-present }
    if (-not $SoloTests) { Invoke-Paso 'npm lint' $d { npm run lint --if-present } }
}

if ($ejecutados -eq 0) { Write-Host 'Sin stacks con tests detectados: nada que verificar.' }

if ($fallos.Count -gt 0) {
    Write-Host "`nFALLOS:"; $fallos | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "`nVerificacion OK."
exit 0
