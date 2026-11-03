# Identidad visual Diusframi — reglas para Claude Code

Este proyecto usa la identidad corporativa de **Diusframi**. Todo lo que generes
(UI, docs, presentaciones, emails) debe respetar estas reglas. Ante la duda,
prevalece `brand/tokens.css`.

## 1. Lo innegociable

- Tipografía: **Inter** (única familia). Fallback de sistema: `-apple-system, "Segoe UI", Roboto, sans-serif`.
- Colores: solo la paleta corporativa. **No inventes colores nuevos.** Usa los tokens.
- El naranja `#FF5100` es acento: acciones, énfasis, datos clave. No lo uses para grandes superficies de texto.
- El azul oscuro `#111C4E` es el color de marca dominante: texto, fondos oscuros, navegación.
- Nunca alteres el logo: sin sombras, sin degradados, sin rotar, sin deformar, sin recolorear.
- Sin emoji en la UI de producto.

## 2. Paleta

| Rol | Token | HEX |
|---|---|---|
| Azul oscuro (principal) | `--ds-navy` | `#111C4E` |
| Naranja (principal) | `--ds-orange` | `#FF5100` |
| Azul eléctrico (secundario, solo digital) | `--ds-blue` | `#0053FF` |
| Amarillo (secundario) | `--ds-yellow` | `#FFD040` |
| Blanco | `--ds-white` | `#FFFFFF` |

Proporción de uso recomendada por el manual: **blanco 30% · azul oscuro 20% ·
naranja 20% · azul eléctrico 15% · amarillo 15%**. En interfaces eso se traduce
en: fondo claro dominante, azul oscuro para texto y chrome, naranja reservado
para lo accionable.

Degradado corporativo (fondos y bloques destacados, contenido encima siempre
blanco o naranja):
```css
background: linear-gradient(135deg, #111C4E 0%, #0053FF 55%, #FF5100 100%);
```

## 3. Tipografía

| Nivel | Peso / tamaño | Line-height |
|---|---|---|
| Título principal | Inter Light 48px | 56px |
| Subtítulo | Inter Bold 36px | 44px |
| Encabezado secundario | Inter Medium 28px | 36px |
| Destacado | Inter Medium 24px | 32px |
| Cuerpo | Inter Regular 20px | 30px |

En interfaces densas (dashboards, tablas) baja la escala de forma proporcional
pero conserva la jerarquía: display Light, títulos Bold/Medium, cuerpo Regular.
Nunca por debajo de 12px. Tracking ligeramente negativo (`-0.02em`) en display.

## 4. Logo

Archivos en `brand/assets/`:

- `imagotipo-color.png` — isotipo naranja + wordmark azul, sobre fondo blanco/claro.
- `imagotipo-blanco-naranja.png` — sobre fondo azul oscuro.
- `imagotipo-blanco.png` — sobre fondo naranja o azul eléctrico.
- `isotipo-naranja.png` / `isotipo-blanco.png` — marca corta, favicon, avatar.

Reglas:
- Área de seguridad: margen igual a la altura de la "D" del wordmark en los 4 lados.
- Tamaño mínimo: imagotipo 120px de ancho; isotipo 32px.
- En fondos fotográficos usa la versión blanca sobre una zona de suficiente contraste.

## 5. Sistema gráfico

Deriva del isotipo: **curvas y círculos**. Úsalo con moderación.
- Círculos sólidos en naranja/azul como acentos, viñetas o marcadores de dato.
- Curvas amplias como divisores de sección o máscara de imagen.
- Radios: contenedores `12px`, botones/inputs `10px`, píldoras `999px`.
- Iconos: estilo **sólido**, formas redondeadas, un solo color (navy o naranja).
  Nada de iconos lineales finos mezclados con sólidos.

## 6. Fotografía

Realista, humana y tecnológica. Planos medios o de detalle, luz natural, tonos
alineados con la paleta. Entornos profesionales y personas reales. Nada de stock
genérico ni de ilustraciones vectoriales decorativas.

## 7. Reglas de UI

- **Botón primario**: fondo naranja, texto blanco, radio 10px. Hover: `#E04700`.
- **Botón secundario**: borde navy 1.5px, texto navy, fondo transparente.
- **Enlaces**: navy con subrayado; hover naranja. Define siempre `a` y `a:hover`.
- **Foco visible**: `outline: 2px solid #0053FF; outline-offset: 2px`.
- **Estados semánticos**: éxito `#0E8F5B`, aviso `#FFD040` (con texto navy),
  error `#D92D20`, info `#0053FF`. No uses el naranja de marca para errores.
- **Contraste mínimo AA**: 4.5:1 en cuerpo de texto. El naranja sobre blanco
  (~3.2:1) **solo** vale para texto ≥24px o elementos gráficos — para texto
  pequeño usa `--ds-orange-700` (`#B33900`).
- Layout con flex/grid y `gap`, escala de espaciado de 4px.

## 8. Cómo usar los archivos

- `brand/tokens.css` — variables CSS, modo claro y oscuro. Punto de entrada para cualquier proyecto.
- `brand/tokens.json` — mismos valores para JS, Style Dictionary o Figma.
- `brand/tailwind.v4.css` — bloque `@theme` para Tailwind 4.
- `brand/tailwind.config.js` — preset para Tailwind 3.
- `brand/components.css` — clases base (`.ds-btn`, `.ds-card`, `.ds-input`…) para proyectos sin framework.
- `brand/shadcn-theme.css` — override de variables shadcn/ui.

Importa `tokens.css` antes que nada y consume siempre `var(--ds-*)`.
Si necesitas un valor que no existe como token, pregúntalo — no lo inventes.

## 9. Recursos descargados de la web (`recursos-web/`)

Copia de fotos, vídeos, iconos/animaciones y fuentes tal como están
publicados en diusframi.es (ver `recursos-web/README.md` para el detalle
y la fecha de descarga). Úsalo como banco de recursos, no como fuente de
reglas de marca:

- `fotos/`, `videos/`, `iconos/` (SVG + `animaciones/` GIF) — contenido
  propio de Diusframi, reutilizable en piezas de marca.
- `fuentes/inter/` — mismos archivos que la tipografía única definida en
  la sección 3. `fuentes/roboto/` y `fuentes/robotoslab/` están servidos
  por la web pero no son tipografía de marca aprobada; no los uses sin
  confirmarlo.
- `logos-partners/` y `certificaciones/` — logos de terceros (bancos,
  fabricantes) y sellos ISO/PCI/SA-8000: son contexto, no activos de
  marca de Diusframi.
