# Nombre del proyecto

> Una frase: qué es y para quién.

## Qué hace
_(descripción clara, funcionalidades principales)_

## Stack
_(según patrones de CLAUDE.md: web = HTML/CSS/JS, datos = SQLite/MySQL, escritorio = Rust, API = Go)_

## Estructura
```
.
├── CLAUDE.md        reglas del proyecto para Claude
├── TAREAS.md        plan, prioridades y estados
├── MEMORIA.md       decisiones y aprendizajes
├── .claude/         permisos, hooks y skills
├── brand/           identidad Diusframi (tokens, componentes, logos)
├── scripts/         verificación, auditoría y hooks de git
└── docs/            guía del arnés, seguridad e identidad visual
```

## Puesta en marcha
1. `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/instalar-hooks-git.ps1`
2. Copia `.env.example` a `.env` y completa los valores.
3. _(comandos de build/ejecución del proyecto)_

## Tests
`powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verificar.ps1`

## Seguridad
Ver `docs/SEGURIDAD.md`. Los secretos nunca se versionan.

## Estado
Ver `TAREAS.md`.
