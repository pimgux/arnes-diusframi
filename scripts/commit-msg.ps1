# commit-msg: exige el ID de tarea (T-001) en el mensaje. Ver TAREAS.md.
param([string]$ArchivoMensaje)
$msg = Get-Content -LiteralPath $ArchivoMensaje -Raw
if ($msg -match '^(Merge|Revert)') { exit 0 }
if ($msg -notmatch '\bT-\d{3,}\b') {
    Write-Host 'BLOQUEADO: el mensaje de commit debe incluir el ID de tarea, p. ej. "T-003: agrega login".'
    exit 1
}
exit 0
