# Pack de identidad Diusframi

Copia la carpeta `brand/` y el archivo `CLAUDE.md` a la raíz de cualquier
proyecto nuevo. Claude Code leerá `CLAUDE.md` automáticamente y respetará la
marca.

```
CLAUDE.md                  reglas de marca para el agente
brand/
  tokens.css               variables CSS (light + dark)   ← punto de entrada
  tokens.json              mismos valores para JS/Figma
  tailwind.v4.css          bloque @theme (Tailwind 4)
  tailwind.config.js       preset (Tailwind 3)
  shadcn-theme.css         override de variables shadcn/ui
  components.css           botones, inputs, cards, tablas, badges
  assets/                  logos PNG
```

## Arranque rápido

CSS puro:
```html
<link rel="stylesheet" href="brand/tokens.css">
<link rel="stylesheet" href="brand/components.css">
```

Tailwind 4 (`app.css`):
```css
@import "tailwindcss";
@import "./brand/tailwind.v4.css";
```

Tailwind 3 (`tailwind.config.js`):
```js
module.exports = { presets: [require('./brand/tailwind.config.js')], content: [...] };
```

Modo oscuro: `<html data-theme="dark">`.

## Prompt sugerido al arrancar un proyecto

> Usa la identidad de `CLAUDE.md` y los tokens de `brand/tokens.css`.
> No inventes colores ni tipografías fuera del pack.
