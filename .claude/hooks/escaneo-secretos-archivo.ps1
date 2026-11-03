# Hook PostToolUse (Edit|Write): aviso inmediato si el archivo escrito parece contener un secreto.
# Es una red barata; la defensa real es gitleaks en el pre-commit.
$raw = [Console]::In.ReadToEnd()
try { $ruta = ($raw | ConvertFrom-Json).tool_input.file_path } catch { exit 0 }
if (-not $ruta -or -not (Test-Path -LiteralPath $ruta -PathType Leaf)) { exit 0 }
if ($ruta -match '\.(example|md)$|\.env\.example$') { exit 0 }

$patrones = @(
    'AKIA[0-9A-Z]{16}',
    '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----',
    '(?i)(api[_-]?key|secret|passwd|password|token)\s*[:=]\s*["''][^"'']{12,}["'']',
    'ghp_[A-Za-z0-9]{36}',
    'sk-[A-Za-z0-9]{32,}',
    '(?i)(mysql|postgres|mongodb)://[^:\s]+:[^@\s]+@'
)

$contenido = Get-Content -LiteralPath $ruta -Raw -ErrorAction SilentlyContinue
if (-not $contenido) { exit 0 }

foreach ($p in $patrones) {
    if ($contenido -match $p) {
        [Console]::Error.WriteLine("POSIBLE SECRETO en $ruta (patron: $p). Muevelo a una variable de entorno / .env y deja un .env.example.")
        exit 2
    }
}
exit 0
