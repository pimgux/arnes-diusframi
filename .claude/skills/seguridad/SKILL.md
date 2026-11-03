---
name: seguridad
description: Pautas básicas de seguridad para cualquier proyecto. Usar al tocar entradas de usuario, autenticación, base de datos, dependencias, red, archivos o configuración, y antes de cerrar una tarea que lo implique.
---

# Seguridad básica

## Checklist de revisión
1. **Secretos:** ninguno en código, logs, tests ni commits. Config por variables de entorno; `.env.example` sin valores reales.
2. **Entradas:** validar tipo, longitud y formato en el borde (formularios, API, archivos, CLI). Rechazar por defecto.
3. **SQL:** solo consultas parametrizadas (SQLite y MySQL). Nunca concatenar cadenas.
4. **Web:** escapar salida en HTML (evitar `innerHTML` con datos externos), cabeceras seguras, CSRF en formularios con estado.
5. **Autenticación/autorización:** comprobar permisos en el servidor, no en el cliente. Contraseñas con hash fuerte (argon2/bcrypt), nunca en claro.
6. **Errores y logs:** mensajes genéricos al usuario; sin datos personales ni secretos en logs.
7. **Dependencias:** mínimas, fijadas y auditadas (`scripts/auditoria.ps1`). Justificar cada nueva.
8. **Archivos y rutas:** sanear rutas (sin `..`), no ejecutar nada derivado de entrada externa.
9. **Red:** TLS siempre; timeouts en clientes; CORS restrictivo.
10. **Privilegios:** el proceso corre con el mínimo necesario.

## Si encuentras un secreto
Detente, no lo copies a otro sitio, sácalo del código, avisa al usuario de que debe **rotarlo** (quitarlo del historial no basta).

## Cierre
Anota en `MEMORIA.md` cualquier riesgo aceptado o pendiente.
