---
name: tests-atomicos
description: Escribir y ejecutar pruebas pequeñas a medida que se construye cada pieza. Usar siempre que se cree o modifique una función, endpoint, componente o módulo.
---

# Pruebas atómicas

Cada pieza nueva se prueba **en el momento**, no al final.

## Ciclo
1. Define la unidad más pequeña que aporta valor (una función, un endpoint, una regla).
2. Escribe primero (o junto al código) un test que la verifique: caso feliz, caso límite y un error esperado.
3. Ejecuta solo ese test; luego `scripts/verificar.ps1 -SoloTests`.
4. No avances a la siguiente pieza con tests en rojo.

## Por stack
| Stack | Herramienta | Ubicación |
|---|---|---|
| Go | `go test ./...` | `*_test.go` junto al código; tests de tabla |
| Rust | `cargo test` | módulo `#[cfg(test)]` o `tests/` |
| JS (web) | `npm test` (p. ej. `node --test`) | `*.test.js` |
| SQLite/MySQL | tests contra BD temporal/en memoria | sin tocar datos reales |

## Reglas
- Un test comprueba una cosa y tiene nombre descriptivo.
- Sin dependencias de red, fecha o orden de ejecución.
- Un bug corregido deja su test de regresión.
- Para HTML/CSS sin lógica, basta una comprobación manual anotada en `MEMORIA.md`.

El hook `Stop` volverá a ejecutar todo antes de dejarte terminar.
