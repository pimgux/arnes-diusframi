# Seguridad — detalle

Resumen operativo en `.claude/skills/seguridad/SKILL.md`. Aquí, qué protege cada capa.

| Capa | Mecanismo | Se dispara | Qué evita |
|---|---|---|---|
| Permisos | `.claude/settings.json` (`deny`) | Siempre | Leer `.env`/claves, `push --force`, `rm -rf`, `--no-verify` |
| Guardia de comandos | hook `guardia-comandos.ps1` | Antes de cada comando Bash | Comandos peligrosos aunque pasen los permisos |
| Escaneo de archivo | hook `escaneo-secretos-archivo.ps1` | Tras cada Edit/Write | Secretos escritos por Claude |
| Pre-commit | `gitleaks protect --staged` | Cada `git commit` | Secretos en el historial |
| Pre-push | `scripts/auditoria.ps1` | Cada `git push` | Dependencias vulnerables (govulncheck, cargo audit, npm audit) y secretos |

## Herramientas
```powershell
winget install gitleaks.gitleaks
go install golang.org/x/vuln/cmd/govulncheck@latest
cargo install cargo-audit
```
`scripts/instalar-hooks-git.ps1` comprueba cuáles faltan. En CI usa `auditoria.ps1 -Estricto` para que la ausencia de una herramienta también falle.

## Límites
- El hook de archivo usa patrones simples: puede dar falsos positivos/negativos. gitleaks es la defensa real.
- Un secreto que llegó a un commit se considera comprometido: **rotarlo**.
- `git commit --no-verify` se bloquea aquí, pero un humano puede hacerlo; añade comprobaciones en CI.
