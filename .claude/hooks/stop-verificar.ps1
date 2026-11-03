# Hook Stop: Claude no puede terminar si tests o lint fallan.
# Para evitar bucles infinitos, tras 3 intentos fallidos seguidos deja terminar y avisa.
$null = [Console]::In.ReadToEnd()
$raiz = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
Set-Location $raiz

$script = Join-Path $raiz 'scripts/verificar.ps1'
if (-not (Test-Path $script)) { exit 0 }

$contador = Join-Path $raiz '.claude/.stop-intentos'
$salida = & powershell -NoProfile -ExecutionPolicy Bypass -File $script 2>&1 | Out-String
$codigo = $LASTEXITCODE

if ($codigo -eq 0) {
    Remove-Item $contador -ErrorAction SilentlyContinue
    exit 0
}

$n = 0
if (Test-Path $contador) { $n = [int](Get-Content $contador -ErrorAction SilentlyContinue) }
$n++

$cola = ($salida -split "`r?`n" | Select-Object -Last 40) -join "`n"

if ($n -ge 3) {
    Remove-Item $contador -ErrorAction SilentlyContinue
    [Console]::Error.WriteLine("AVISO: la verificacion sigue fallando tras 3 intentos. Se permite terminar; informa al usuario del estado exacto.`n$cola")
    exit 0
}

Set-Content $contador $n
[Console]::Error.WriteLine("NO has terminado: tests/lint fallan (intento $n/3). Corrigelo antes de cerrar.`n$cola")
exit 2
