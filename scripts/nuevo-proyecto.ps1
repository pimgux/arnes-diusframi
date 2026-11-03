# Convierte una copia recien clonada de la plantilla en un proyecto nuevo:
# pregunta nombre y objetivo, crea la carpeta del proyecto con ese nombre,
# rellena CLAUDE.md, inicia un repo limpio y activa los hooks de git.
# Uso: se ejecuta desde la carpeta temporal donde se clono la plantilla.
param(
    [string]$Nombre,
    [string]$Objetivo
)
$ErrorActionPreference = 'Stop'

$origen = Split-Path -Parent $PSScriptRoot
$padre  = Split-Path -Parent $origen

# --- Preguntas (se saltan si llegan por parametro) ---
if (-not $Nombre)   { $Nombre   = Read-Host 'Nombre del proyecto' }
if (-not $Objetivo) { $Objetivo = Read-Host 'Objetivo (una frase)' }
$Nombre   = ($Nombre   -replace '\s+', ' ').Trim()
$Objetivo = ($Objetivo -replace '\s+', ' ').Trim()
if (-not $Nombre)   { Write-Host 'El nombre no puede estar vacio.';   exit 1 }
if (-not $Objetivo) { Write-Host 'El objetivo no puede estar vacio.'; exit 1 }

# Nombre de carpeta: espacios -> guiones; solo letras, numeros, punto, guion y guion bajo.
$carpeta = $Nombre -replace ' ', '-'
if ($carpeta -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') {
    Write-Host "Nombre no valido para una carpeta: '$carpeta'. Usa letras, numeros, '-' o '_' (sin tildes ni caracteres especiales)."
    exit 1
}
$destino = Join-Path $padre $carpeta
if (Test-Path -LiteralPath $destino) {
    Write-Host "Ya existe la carpeta: $destino. Elige otro nombre."
    exit 1
}

# --- Crear el proyecto (sin el .git de la plantilla) ---
New-Item -ItemType Directory -Path $destino | Out-Null
Get-ChildItem -LiteralPath $origen -Force | Where-Object { $_.Name -ne '.git' } |
    Copy-Item -Destination $destino -Recurse -Force

# --- Rellenar CLAUDE.md (reemplazo literal: el texto del usuario no se interpreta) ---
$claude = Join-Path $destino 'CLAUDE.md'
$utf8   = New-Object System.Text.UTF8Encoding($false)
$texto  = [System.IO.File]::ReadAllText($claude, $utf8)
$texto  = $texto.Replace('- **Nombre:** _(completar)_',  "- **Nombre:** $Nombre")
$texto  = $texto.Replace('- **Objetivo:** _(una frase)_', "- **Objetivo:** $Objetivo")
[System.IO.File]::WriteAllText($claude, $texto, $utf8)

# --- Repo limpio + hooks ---
Set-Location $destino
git init -q -b main
Write-Host 'Repositorio nuevo inicializado (rama main).'
& (Join-Path $destino 'scripts\instalar-hooks-git.ps1')

# --- Limpiar la carpeta temporal del clon ---
Set-Location $padre
try { Remove-Item -LiteralPath $origen -Recurse -Force }
catch { Write-Host "No se pudo borrar la carpeta temporal $origen; puedes eliminarla a mano." }

Write-Host ''
Write-Host "Proyecto listo en: $destino"
Write-Host 'Siguiente paso: abre Claude Code en esa carpeta.'
