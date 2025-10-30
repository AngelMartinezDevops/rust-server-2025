# Rust Server - Imagen Docker Modernizada

Este proyecto contiene una versión modernizada del servidor Rust en Docker, actualizado con las últimas versiones de todas las dependencias.

## 🎯 Características

### Versiones Actualizadas
- **Ubuntu 24.04 LTS** (anteriormente 18.04)
- **Node.js 20 LTS** (anteriormente 12)
- **npm actualizado** a la última versión
- **Python 3** nativo
- **Dependencias actualizadas** (lib32gcc-s1, libstdc++6, etc.)

### Componentes Incluidos
- ✅ SteamCMD (última versión)
- ✅ Nginx + WebRCON
- ✅ Aplicaciones Node.js de gestión:
  - shutdown_app - Apagado controlado
  - restart_app - Reinicio automático
  - scheduler_app - Tareas programadas
  - heartbeat_app - Monitor de salud
  - rcon_app - Comandos RCON

## 📦 Construcción de la Imagen

### Opción 1: Imagen Completa del Servidor
```bash
docker build -t rustserver/rust-server:latest .
```

### Opción 2: Con Tags Específicos
```bash
docker build -t rustserver/rust-server:ubuntu-24.04 \
             -t rustserver/rust-server:nodejs-20 \
             -t rustserver/rust-server:latest .
```

## 🚀 Uso con Docker Compose

Ver `docker-compose.yml` para un ejemplo completo de configuración.

```bash
docker-compose up -d
```

## 📋 Variables de Entorno

### Configuración del Servidor
- `RUST_SERVER_NAME` - Nombre del servidor
- `RUST_SERVER_DESCRIPTION` - Descripción
- `RUST_SERVER_URL` - URL del servidor
- `RUST_SERVER_WORLDSIZE` - Tamaño del mapa (por defecto: 3500)
- `RUST_SERVER_MAXPLAYERS` - Jugadores máximos (por defecto: 500)
- `RUST_SERVER_SEED` - Semilla del mapa

### Configuración RCON
- `RUST_RCON_PASSWORD` - Contraseña RCON
- `RUST_RCON_PORT` - Puerto RCON (por defecto: 28016)
- `RUST_RCON_WEB` - Habilitar WebRCON (1/0)

### Otras Opciones
- `RUST_UPDATE_CHECKING` - Verificar actualizaciones (0/1)
- `RUST_START_MODE` - Modo de inicio (0=sin actualizar, 1=actualizar)
- `RUST_OXIDE_ENABLED` - Habilitar Oxide (0/1)

## 🔧 Puertos

- `28015` - Puerto del juego (TCP/UDP)
- `28016` - Puerto RCON
- `8080` - Puerto Rust+ (app companion)
- `28082` - Puerto de aplicación

## 📁 Volúmenes

- `/steamcmd/rust` - Datos del servidor (mapas, configuración, etc.)

## 🔄 Diferencias con la Versión Original

| Componente | Original | Modernizada |
|-----------|----------|-------------|
| Ubuntu | 18.04 | 24.04 LTS |
| Node.js | 12 | 20 LTS |
| Python | python-dev | python3 + python3-dev |
| lib32gcc | lib32gcc1 | lib32gcc-s1 |
| bsdtar | bsdtar | libarchive-tools |
| UID/GID | 1000:1000 | 1001:1001 |

## 🐛 Solución de Problemas

### Error de UID/GID
Ubuntu 24.04 usa UID 1000 por defecto, por lo que esta imagen usa 1001:1001.

### Error de npm registry
El proyecto original usaba un registry privado. Esta versión usa el registry público de npm.

## 📝 Licencia

Ver LICENSE.md

## 👨‍💻 Autor Original

Didstopia <support@didstopia.com>

## 🔧 Modernización

Actualizado a Ubuntu 24.04 y Node.js 20 LTS

