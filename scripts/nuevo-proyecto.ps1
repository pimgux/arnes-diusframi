# Convierte una copia recién clonada de la plantilla en un proyecto nuevo:
# elimina el historial de la plantilla, inicia un repo limpio y activa los hooks.
$raiz = Split-Path -Parent $PSScriptRoot
Set-Location $raiz

$git = Join-Path $raiz '.git'
if (Test-Path $git) {
    # Los objetos de .git son de solo lectura: -Force es necesario en Windows.
    Remove-Item -LiteralPath $git -Recurse -Force
    Write-Host 'Historial de la plantilla eliminado.'
}
git init -q -b main
Write-Host 'Repositorio nuevo inicializado (rama main).'

& (Join-Path $PSScriptRoot 'instalar-hooks-git.ps1')

Write-Host ''
Write-Host "Proyecto listo en: $raiz"
Write-Host 'Siguiente paso: completa la seccion "Proyecto" de CLAUDE.md y abre Claude Code aqui.'
