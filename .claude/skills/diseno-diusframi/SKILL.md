---
name: diseno-diusframi
description: Aplicar la identidad visual de Diusframi a cualquier interfaz, documento o pieza gráfica. Usar al crear o modificar pantallas, estilos, componentes, logos o contenido visual.
---

# Diseño Diusframi

Fuentes (en este orden de prioridad):
1. `brand/tokens.css` — valores reales; manda ante cualquier duda.
2. `docs/diseno/IDENTIDAD.md` — reglas completas de marca (paleta, tipografía, logo, UI, fotografía).
3. `docs/diseno/Diusframi_Manual de Identidad Corporativo.pdf` — manual original.

## Reglas esenciales
- Importa `brand/tokens.css` primero y consume siempre `var(--ds-*)`. Para web sin framework añade `brand/components.css` (`.ds-btn`, `.ds-card`, `.ds-input`, `.ds-table`, `.ds-badge`).
- Tailwind 4: `brand/tailwind.v4.css`; Tailwind 3: `brand/tailwind.config.js`; shadcn: `brand/shadcn-theme.css`; JS/Figma: `brand/tokens.json`.
- Tipografía única: **Inter**. Colores: solo la paleta; **no inventes colores**. Naranja `#FF5100` = acento accionable; azul oscuro `#111C4E` = color dominante.
- Texto pequeño naranja: usar `--ds-orange-700` (contraste AA).
- Logo: archivos de `brand/assets/`, sin alterarlo (sin sombras, degradados, giros ni recolorear). Mínimo 120px (imagotipo) / 32px (isotipo).
- Radios 12/10px, espaciado en múltiplos de 4px, foco visible, sin emoji en la UI, iconos sólidos de un solo color.
- Modo oscuro: `<html data-theme="dark">`.
- Aplicaciones de escritorio (Rust): mapea los mismos valores de `brand/tokens.json` a la librería gráfica.

## Si falta un valor
Pregunta al usuario; no lo inventes.
