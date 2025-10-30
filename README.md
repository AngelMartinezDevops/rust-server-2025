# 🦀 Rust Server - Imagen Docker Modernizada

Versión actualizada del servidor Rust en Docker con Ubuntu 24.04 LTS y Node.js 20 LTS.

## 📦 Inicio Rápido

### Windows
```powershell
.\build.ps1
docker-compose up -d
```

### Linux/Mac
```bash
chmod +x build.sh
./build.sh
docker-compose up -d
```

## 📁 Estructura del Proyecto

```
rust-server-modern/
├── Dockerfile                 # Dockerfile principal modernizado
├── docker-compose.yml         # Configuración Docker Compose
├── build.sh / build.ps1       # Scripts de construcción
├── .dockerignore             # Archivos a excluir del build
│
├── Apps Node.js (Gestión del servidor)
│   ├── shutdown_app/         # Apagado controlado
│   ├── restart_app/          # Reinicio automático
│   ├── scheduler_app/        # Tareas programadas
│   ├── heartbeat_app/        # Monitor de salud
│   └── rcon_app/             # Comandos RCON
│
├── Scripts
│   ├── start_rust.sh         # Script de inicio del servidor
│   ├── update_check.sh       # Verificación de actualizaciones
│   ├── fix_conn.sh           # Fix de conexiones
│   └── install.txt           # Script de instalación SteamCMD
│
├── Configuración
│   ├── nginx_rcon.conf       # Configuración Nginx para WebRCON
│   ├── LICENSE.md            # Licencia
│   └── README.md             # Este archivo
│
└── Datos (creado al ejecutar)
    └── rust-data/            # Volumen persistente del servidor
```

## 🎯 Características

### ✨ Versiones Actualizadas
- **Ubuntu 24.04 LTS** (anteriormente 18.04)
- **Node.js 20 LTS** (anteriormente 12)
- **npm** última versión estable
- **Python 3** nativo
- **Dependencias modernas** actualizadas

### 🛠️ Componentes
- ✅ **SteamCMD** - Instalación y actualización de Rust
- ✅ **Nginx + WebRCON** - Control web del servidor
- ✅ **Apps Node.js** - Gestión automatizada
- ✅ **Soporte Oxide** - Mods y plugins

## 🚀 Uso

### Construcción de la Imagen

```bash
# Opción 1: Usando script
./build.sh              # Linux/Mac
.\build.ps1             # Windows

# Opción 2: Docker directo
docker build -t rustserver/rust-server:latest .
```

### Iniciar el Servidor

```bash
# Modo demonio (background)
docker-compose up -d

# Modo interactivo (ver logs)
docker-compose up

# Ver logs en tiempo real
docker-compose logs -f
```

### Comandos Útiles

```bash
# Detener el servidor
docker-compose down

# Reiniciar el servidor
docker-compose restart

# Acceder a la consola
docker-compose exec rust-server bash

# Ver estadísticas
docker stats rust-server
```

## ⚙️ Configuración

### Variables de Entorno Principales

Edita `docker-compose.yml` para personalizar:

```yaml
environment:
  # Servidor
  RUST_SERVER_NAME: "Mi Servidor"
  RUST_SERVER_WORLDSIZE: "3500"        # Tamaño del mapa
  RUST_SERVER_MAXPLAYERS: "50"         # Jugadores máximos
  RUST_SERVER_SEED: "12345"            # Semilla del mapa
  
  # RCON
  RUST_RCON_PASSWORD: "tu_password"    # ⚠️ CAMBIAR ESTO
  RUST_RCON_WEB: "1"                   # WebRCON habilitado
  
  # Actualizaciones
  RUST_UPDATE_CHECKING: "0"            # 0=manual, 1=automático
  RUST_START_MODE: "0"                 # 0=sin actualizar, 1=actualizar
```

### Puertos

| Puerto | Protocolo | Uso |
|--------|-----------|-----|
| 28015  | TCP/UDP   | Juego principal |
| 28016  | TCP       | RCON |
| 8080   | TCP       | Rust+ App |
| 28082  | TCP       | Aplicación |

### Volúmenes

- `./rust-data:/steamcmd/rust` - Datos persistentes del servidor

## 🔄 Actualización

```bash
# Reconstruir imagen
docker-compose build --no-cache

# Actualizar y reiniciar
docker-compose down
docker-compose up -d --build
```

## 🐛 Solución de Problemas

### Error de permisos
```bash
# Ajustar permisos del volumen
chown -R 1001:1001 ./rust-data
```

### Puerto ocupado
```bash
# Ver qué usa el puerto 28015
netstat -an | grep 28015    # Linux
netstat -an | findstr 28015 # Windows
```

### Limpiar y reiniciar
```bash
docker-compose down -v
docker-compose up -d
```

## 📊 Diferencias con Versión Original

| Componente | Original | Modernizada |
|-----------|----------|-------------|
| Ubuntu | 18.04 | **24.04 LTS** |
| Node.js | 12 | **20 LTS** |
| Python | python-dev | **python3** |
| gcc 32-bit | lib32gcc1 | **lib32gcc-s1** |
| archive tools | bsdtar | **libarchive-tools** |
| UID/GID | 1000:1000 | **1001:1001** |
| npm registry | privado | **público** |

## 📝 Archivos Importantes

- `Dockerfile` - Imagen modernizada completa
- `docker-compose.yml` - Configuración de servicios
- `README-MODERNO.md` - Documentación detallada
- `build.sh` / `build.ps1` - Scripts de construcción

## 🤝 Contribuir

Este es un proyecto modernizado. El proyecto original:
- **Autor**: Didstopia <support@didstopia.com>
- **Repo**: https://github.com/Didstopia/rust-server

## 📄 Licencia

Ver `LICENSE.md`

## 🆘 Soporte

Para más información consulta `README-MODERNO.md`
