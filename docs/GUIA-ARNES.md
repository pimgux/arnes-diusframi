# Guía del arnés

Para qué sirve, cómo se instala y cómo se adapta.

## 1. Qué es
Un conjunto de archivos que se copia a cada proyecto para que Claude trabaje con orden: plan con tareas, memoria, tests automáticos, seguridad y una definición única de "Hecho". La idea es que las reglas **se cumplan por mecanismo** (hooks), no porque Claude se acuerde.

## 2. Instalación (5 minutos)
1. Ejecuta una sola línea (cambia `mi-proyecto` por el nombre de tu carpeta):
   ```bat
   git clone --depth 1 https://github.com/pimgux/arnes-diusframi mi-proyecto && powershell -NoProfile -ExecutionPolicy Bypass -File mi-proyecto/scripts/nuevo-proyecto.ps1
   ```
   Vale para cmd, Git Bash y PowerShell 7. En Windows PowerShell 5.1 `&&` no existe: usa `;`.
   Clona la plantilla, elimina su historial, inicia un repo limpio en `main`, activa los hooks de git e indica qué herramientas faltan (gitleaks, govulncheck, cargo-audit). Si ya tienes una copia de los archivos, `scripts/instalar-hooks-git.ps1` solo activa los hooks.
2. Completa en `CLAUDE.md` la sección **Proyecto**. La identidad Diusframi ya viene incluida en `brand/`.
3. Abre Claude Code en la carpeta. Los hooks de `.claude/settings.json` se cargan solos (la primera vez pedirá confirmar).

Requisitos: Windows con PowerShell 5.1+, Git, y según el stack: Go, Rust, Node.

## 3. Mapa de archivos
| Archivo | Función |
|---|---|
| `CLAUDE.md` | Reglas, patrones de infraestructura y checklist de "Hecho". Claude lo lee siempre |
| `TAREAS.md` | Plan: ID, prioridad (P1–P3) y estado |
| `MEMORIA.md` | Decisiones y aprendizajes entre sesiones |
| `README.md` | Descripción del proyecto (plantilla) |
| `.claude/settings.json` | Permisos y registro de hooks |
| `.claude/hooks/*.ps1` | Reglas automáticas (ver §4) |
| `.claude/skills/*/SKILL.md` | Procedimientos: seguridad, tests-atomicos, planificacion, memoria, diseno-diusframi |
| `.githooks/` + `scripts/` | pre-commit, commit-msg, pre-push, verificar, auditoría |
| `brand/` | Pack de identidad Diusframi: `tokens.css`, `components.css`, Tailwind/shadcn, logos |
| `docs/` | Esta guía, seguridad, y `diseno/` (reglas de marca + manual PDF) |

## 4. Qué se ejecuta solo
| Cuándo | Qué | Efecto |
|---|---|---|
| Antes de un comando Bash | `guardia-comandos.ps1` | Bloquea `--no-verify`, `push --force`, `rm -rf`, leer `.env`… |
| Tras editar un archivo | `escaneo-secretos-archivo.ps1` | Avisa de posibles secretos |
| Al intentar terminar | `stop-verificar.ps1` → `verificar.ps1` | Corre tests + lint; si fallan, Claude **no puede terminar** (máx. 3 intentos para no entrar en bucle) |
| `git commit` | `pre-commit` (gitleaks), `commit-msg` | Bloquea secretos y commits sin ID de tarea |
| `git push` | `pre-push` (`auditoria.ps1`) | govulncheck, cargo audit, npm audit, gitleaks |

`verificar.ps1` detecta el stack por archivos (`go.mod`, `Cargo.toml`, `package.json`, hasta un nivel de subcarpeta). Sin tests detectados, pasa.

## 5. Flujo de trabajo recomendado
1. Describe el objetivo a Claude. Pide: *"Planifica con la skill planificacion"*.
2. Revisa `TAREAS.md` y aprueba.
3. Claude ejecuta tarea a tarea: código + test atómico → verificar → memoria → commit `T-00X: ...`.
4. Al cerrar, mira `MEMORIA.md` y `README.md`: deben reflejar el trabajo.

## 6. Cómo adaptarlo
- **Otro stack:** añade un bloque en `verificar.ps1` y `auditoria.ps1` siguiendo el patrón existente; actualiza la tabla de infraestructura en `CLAUDE.md`.
- **Más/menos permisos:** edita `permissions` en `.claude/settings.json`. Preferencias personales van en `.claude/settings.local.json` (ignorado por git).
- **Reglas nuevas del guardia:** añade una entrada `Patron`/`Motivo` en `guardia-comandos.ps1`.
- **Checklist de Hecho:** edítala solo en `CLAUDE.md`; es la única copia.
- **Marca:** viene de `Identidad visual Diusframi.zip`. Para actualizarla, reemplaza `brand/` y `docs/diseno/IDENTIDAD.md` con la versión nueva del pack. Los recursos pesados del zip (`recursos-web/`, `Oficinas/`) no se copian; cógelos del zip cuando un proyecto los necesite.

## 7. Problemas frecuentes
| Síntoma | Causa / solución |
|---|---|
| El hook no se ejecuta | Revisa que `powershell` esté en el PATH y que aceptaste los hooks al abrir Claude Code. Comprueba con `/hooks` |
| `gitleaks no está instalado` al commitear | `winget install gitleaks.gitleaks` |
| Claude no termina y los tests fallan | Es lo esperado: corrige el fallo. Tras 3 intentos se libera con aviso |
| Commit rechazado | Falta el ID `T-NNN` en el mensaje |
| Falso positivo de secreto | Ajusta `.gitleaks.toml` (allowlist) o el patrón del hook; nunca uses `--no-verify` |
| La ruta `$CLAUDE_PROJECT_DIR` no se resuelve en los hooks | Si tu shell de hooks no es Git Bash, cambia por ruta relativa `.claude/hooks/...` |

## 8. Pendiente de completar por el equipo
- CI que repita `verificar.ps1` y `auditoria.ps1 -Estricto` (los hooks locales se pueden saltar a mano).
