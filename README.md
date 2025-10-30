# Rust Server - Modern Edition

Servidor dedicado de Rust modernizado con **Ubuntu 22.04 LTS** y **Node.js 20 LTS**.

## Características

- ✅ **Ubuntu 22.04 LTS** - Sistema base estable y compatible con SteamCMD
- ✅ **Node.js 20 LTS** - Versión moderna de Node.js
- ✅ **SteamCMD** - Instalación y actualización automática
- ✅ **WebRCON** - Administración web integrada
- ✅ **Rust+** - Soporte para companion app
- ✅ **Instalación automática** - Descarga el servidor al iniciar
- ✅ **Persistencia de datos** - Guarda tu progreso

## Inicio Rápido

```bash
# Descargar y ejecutar
docker pull b3lerofonte/rust-server:latest

# Usando docker run
docker run -d \
  --name rust-server \
  --user 1000:1000 \
  -p 28015:28015/tcp \
  -p 28015:28015/udp \
  -p 28016:28016 \
  -p 8080:8080 \
  -p 28082:28082 \
  -v rust-data:/steamcmd/rust \
  -e RUST_SERVER_NAME="Mi Servidor Rust" \
  -e RUST_RCON_PASSWORD="tu_password_aqui" \
  b3lerofonte/rust-server:latest
```

## Usando Docker Compose

```yaml
services:
  rust-server:
    image: b3lerofonte/rust-server:latest
    container_name: rust-server
    user: "1000:1000"
    restart: unless-stopped
    ports:
      - "28015:28015"          # Rust game port (TCP)
      - "28015:28015/udp"      # Rust game port (UDP)
      - "28016:28016"          # Rust RCON port
      - "8080:8080"            # Rust+ companion app
      - "28082:28082"          # Application port
    volumes:
      - rust-data:/steamcmd/rust
    environment:
      RUST_SERVER_NAME: "Mi Servidor Rust"
      RUST_SERVER_SEED: "12345"
      RUST_SERVER_WORLDSIZE: "3500"
      RUST_SERVER_MAXPLAYERS: "50"
      RUST_RCON_PASSWORD: "cambiar_esta_password"
      RUST_RCON_WEB: "1"

volumes:
  rust-data:
```

Luego ejecuta:
```bash
docker compose up -d
```

## Variables de Entorno

| Variable | Descripción | Por Defecto |
|----------|-------------|-------------|
| `RUST_SERVER_NAME` | Nombre del servidor | "Rust Server" |
| `RUST_SERVER_SEED` | Seed del mapa | "12345" |
| `RUST_SERVER_WORLDSIZE` | Tamaño del mapa | "3500" |
| `RUST_SERVER_MAXPLAYERS` | Jugadores máximos | "50" |
| `RUST_SERVER_IDENTITY` | Carpeta de identidad | "rust-server" |
| `RUST_RCON_PASSWORD` | Contraseña RCON | "changeme" |
| `RUST_RCON_PORT` | Puerto RCON | "28016" |
| `RUST_RCON_WEB` | WebRCON activado | "1" |
| `RUST_UPDATE_CHECKING` | Comprobar updates | "0" |

## Puertos

| Puerto | Protocolo | Descripción |
|--------|-----------|-------------|
| 28015 | TCP/UDP | Puerto de juego principal |
| 28016 | TCP | Puerto RCON |
| 8080 | TCP | Rust+ companion app |
| 28082 | TCP | Puerto de aplicación |

## Volúmenes

- `/steamcmd/rust` - Datos persistentes del servidor (mapas, configuración, etc.)

## Primera Ejecución

En el primer arranque, el servidor:
1. Descargará e instalará SteamCMD (~75 MB)
2. Descargará los archivos del servidor Rust (~8 GB)
3. Generará el mapa procedural
4. Iniciará el servidor

**Esto puede tardar 10-15 minutos** dependiendo de tu conexión.

## Administración

### Acceder a RCON

WebRCON disponible en: `http://tu-ip:28016`

### Ver logs en tiempo real

```bash
docker logs -f rust-server
```

### Reiniciar servidor

```bash
docker restart rust-server
```

### Detener servidor

```bash
docker stop rust-server
```

## Recursos Recomendados

- **CPU**: Mínimo 2 cores, recomendado 4+
- **RAM**: Mínimo 4 GB, recomendado 8 GB
- **Disco**: Mínimo 10 GB libres
- **Red**: Conexión estable con puertos abiertos

## Imagen Base

Esta imagen está construida sobre:
- **b3lerofonte/base:nodejs-20-steamcmd-ubuntu-22.04**
- Repositorio: [base-2025](https://github.com/AngelMartinezDevops/base-2025)

## Repositorio

Código fuente: [rust-server-2025](https://github.com/AngelMartinezDevops/rust-server-2025)

## Soporte

Si encuentras algún problema, por favor abre un issue en GitHub.

## Licencia

MIT License - Libre para uso personal y comercial.

---

**Nota**: Esta es una imagen independiente no oficial. No está afiliada con Facepunch Studios.
