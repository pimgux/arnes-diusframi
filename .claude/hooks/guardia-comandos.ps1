# Hook PreToolUse (Bash): bloquea comandos peligrosos antes de ejecutarlos.
# Exit 2 = bloquear; el mensaje de stderr le llega a Claude.
$raw = [Console]::In.ReadToEnd()
try { $cmd = ($raw | ConvertFrom-Json).tool_input.command } catch { exit 0 }
if (-not $cmd) { exit 0 }

$reglas = @(
    @{ Patron = 'git\s+commit.*--no-verify';           Motivo = 'No se permite saltar los hooks de git (--no-verify).' },
    @{ Patron = 'git\s+push.*(--force|\s-f(\s|$))';    Motivo = 'No se permite push --force.' },
    @{ Patron = 'rm\s+-rf?\s+(/|~|\.\.?(\s|$))';       Motivo = 'Borrado recursivo peligroso.' },
    @{ Patron = 'Remove-Item.*-Recurse.*-Force';       Motivo = 'Borrado recursivo forzado.' },
    @{ Patron = '(curl|wget|iwr|Invoke-WebRequest).*\|\s*(sh|bash|iex|Invoke-Expression)'; Motivo = 'No se ejecuta codigo descargado directamente.' },
    @{ Patron = '(cat|type|Get-Content|gc)\s+.*\.env(\s|$|\.)'; Motivo = 'No se leen archivos .env; usa .env.example.' },
    @{ Patron = 'git\s+reset\s+--hard';                Motivo = 'reset --hard descarta trabajo; pidelo al usuario.' }
)

foreach ($r in $reglas) {
    if ($cmd -match $r.Patron) {
        [Console]::Error.WriteLine("BLOQUEADO por el arnes: $($r.Motivo) Comando: $cmd")
        exit 2
    }
}
exit 0
