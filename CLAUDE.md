# CLAUDE.md — Reglas del proyecto

> Plantilla base del arnés. Ajusta la sección "Proyecto" y deja el resto salvo que tengas motivo.

## Proyecto
- **Nombre:** _(completar)_
- **Objetivo:** _(una frase)_
- **Stack elegido:** _(ver "Infraestructura"; justificar si te sales)_

## Archivos que mandan
| Archivo | Para qué | Cuándo se toca |
|---|---|---|
| `TAREAS.md` | Plan: tareas, prioridad y estado | Al planificar y al cambiar de estado cualquier tarea |
| `MEMORIA.md` | Decisiones, aprendizajes, trampas | Al cerrar cada tarea |
| `README.md` | Descripción clara del proyecto | Cuando cambie algo visible |
| `docs/` | Guía del arnés y detalle de seguridad/diseño | Rara vez |

## Cómo trabajar
1. **Lee `MEMORIA.md` y `TAREAS.md` al empezar.** No repitas lo ya decidido.
2. **Planifica antes de construir** (skill `planificacion`): genera tareas con ID `T-001`, prioridad y estado en `TAREAS.md`.
3. **Una tarea a la vez**, en orden de prioridad. Márcala `En curso` al empezar y `Hecha` al cumplir la checklist.
4. **Pruebas atómicas** (skill `tests-atomicos`): cada función/endpoint/componente nuevo lleva su test en el mismo paso, no al final.
5. **Pasos pequeños.** Si un cambio no se puede probar solo, divídelo.

## Infraestructura (patrones por defecto)
| Necesidad | Usar |
|---|---|
| Web | HTML + CSS + JS (sin framework salvo necesidad justificada) |
| Datos pequeños / locales | SQLite |
| Datos de proyectos grandes / multiusuario | MySQL |
| Aplicación de escritorio | Rust |
| API / backend | Go |

Si el requisito no encaja, propón la alternativa y regístrala en `MEMORIA.md` como decisión.

## Seguridad (resumen; detalle en skill `seguridad` y `docs/SEGURIDAD.md`)
- Nunca secretos en código, logs ni commits: variables de entorno + `.env.example`.
- Valida toda entrada externa; consultas SQL siempre parametrizadas.
- Mínimo privilegio y dependencias mínimas; no añadas librerías sin necesidad.
- No leas `.env`, claves ni certificados.
- Los hooks protegen: `pre-commit` (gitleaks), `pre-push` (govulncheck, cargo audit, npm audit). **Nunca uses `--no-verify`.**

## Diseño
Identidad visual de Diusframi: skill `diseno-diusframi`. Tokens en `brand/tokens.css`, reglas completas en `docs/diseno/IDENTIDAD.md`.
- Tipografía **Inter**; solo la paleta corporativa (no inventes colores); logo sin alterar.
- Toda interfaz importa `brand/tokens.css` y usa `var(--ds-*)`. Si falta un valor, pregunta.

## Definición de "Hecho" (checklist única)
Una tarea solo pasa a `Hecha` si **todo** se cumple:
- [ ] Tests en verde (`scripts/verificar.ps1`)
- [ ] Lint limpio (incluido en el mismo script)
- [ ] Revisión de seguridad hecha si toca entradas, auth, datos, dependencias o red
- [ ] `MEMORIA.md` actualizada (qué se hizo, decisiones, trampas)
- [ ] `README.md` actualizado si cambia uso, instalación o estructura
- [ ] `TAREAS.md` con el estado actualizado
- [ ] Commit con el ID de la tarea: `T-003: descripción corta`

El hook `Stop` ejecuta tests y lint y no te deja terminar si fallan. No es negociable ni se desactiva.

## Comandos
- Verificar todo: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verificar.ps1`
- Auditoría de seguridad: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/auditoria.ps1`
- Proyecto nuevo (pregunta nombre y objetivo, crea la carpeta y activa hooks): `git clone --depth 1 https://github.com/pimgux/arnes-diusframi arnes-tmp && powershell -NoProfile -ExecutionPolicy Bypass -File arnes-tmp/scripts/nuevo-proyecto.ps1` (en PowerShell 5.1 cambia `&&` por `;`)
- Reactivar hooks de git en un clon existente: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/instalar-hooks-git.ps1`

## Estilo
- Responde y comenta en español. Código e identificadores en inglés o español, pero consistentes con el proyecto.
- Comentarios solo cuando el "por qué" no es obvio.
- No crees archivos fuera de la estructura sin motivo.
