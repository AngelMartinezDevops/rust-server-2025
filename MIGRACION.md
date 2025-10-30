# 📋 Notas de Migración - Ubuntu 18.04 → 22.04

## 🎯 Resumen de Cambios

Esta imagen ha sido completamente modernizada manteniendo la compatibilidad funcional con la versión original de Didstopia.

## 🔄 Cambios Técnicos Importantes

### 1. Sistema Operativo
- **Antes**: Ubuntu 18.04 (EOL Abril 2023)
- **Ahora**: Ubuntu 22.04 LTS (Soporte hasta 2027, compatible con SteamCMD)

### 2. Runtime JavaScript
- **Antes**: Node.js 12 (EOL Abril 2022)
- **Ahora**: Node.js 20 LTS (Soporte hasta 2026)

### 3. Paquetes Actualizados

| Paquete Antiguo | Paquete Nuevo | Motivo |
|----------------|---------------|---------|
| `bsdtar` | `libarchive-tools` | Renombrado en Ubuntu 22.04 |
| `lib32gcc1` | `lib32gcc-s1` | Actualización GCC |
| `python-dev` | `python3-dev` | Python 2 deprecado |

### 4. IDs de Usuario

**⚠️ Cambio Importante**

```yaml
# Ubuntu 18.04
PUID: 1000
PGID: 1000

# Ubuntu 22.04
PUID: 1000
PGID: 1000
```

**Nota:** Los UIDs se mantienen en 1000:1000, sin cambios necesarios para datos existentes.

### 5. npm Registry

**Antes**: Registry privado de Didstopia (no disponible)
```
https://npm.didstopia.com/
```

**Ahora**: Registry público oficial
```
https://registry.npmjs.org/
```

**Solución**: Se eliminan `package-lock.json` y `.npmrc` durante el build.

## 🛠️ Proceso de Construcción

### Cambios en el Dockerfile

1. **Gestión de package-lock.json**
```dockerfile
# Se añade eliminación explícita
RUN rm -f .npmrc package-lock.json && npm install --registry=https://registry.npmjs.org/
```

2. **IDs de usuario**
```dockerfile
# Se mantiene igual en ambas versiones
RUN groupadd --system --gid 1000 docker
RUN useradd --uid 1000 --gid 1000 docker
```

**Nota**: Los UIDs se mantienen en 1000:1000 para máxima compatibilidad.

3. **Configuración npm global**
```dockerfile
# Se añade configuración explícita
RUN npm config set registry https://registry.npmjs.org/
```

## 📦 Tamaño de Imagen

- **Imagen Base Original**: ~1.2 GB
- **Imagen Modernizada**: ~1.65 GB

*Aumento debido a dependencias más recientes y completas de Ubuntu 22.04*

## ✅ Compatibilidad

### Compatible ✓
- Todos los scripts originales (start_rust.sh, update_check.sh, etc.)
- Todas las apps Node.js (shutdown, restart, scheduler, heartbeat, rcon)
- Variables de entorno originales
- Estructura de directorios
- Puertos y volúmenes

### Cambios Necesarios ✗
- **Ninguno** - Los UIDs se mantienen en 1000:1000
- Uso de volúmenes Docker recomendado para evitar problemas de permisos

## 🔧 Guía de Migración

### Paso 1: Backup
```bash
# Respaldar datos existentes
cp -r ./rust-data ./rust-data.backup
```

### Paso 2: Construcción
```bash
# Construir nueva imagen
./build.sh  # o build.ps1 en Windows
```

### Paso 3: Detener servidor antiguo
```bash
docker compose down
```

### Paso 4: Usar volúmenes Docker (recomendado)
```yaml
# En docker-compose.yml
volumes:
  - rust-data:/steamcmd/rust  # Volumen Docker en lugar de ./rust-data

volumes:
  rust-data:
```

### Paso 5: Actualizar docker-compose.yml
```yaml
services:
  rust-server:
    image: b3lerofonte/rust-server:latest  # Nueva imagen
    user: "1000:1000"  # Asegurar UID/GID
    volumes:
      - rust-data:/steamcmd/rust  # Volumen Docker
    # ... resto de configuración
```

### Paso 6: Iniciar
```bash
docker compose up -d
```

## 🐛 Problemas Conocidos

### 1. Warning de npm deprecated packages
```
npm warn deprecated har-validator@5.1.5
npm warn deprecated uuid@3.4.0
npm warn deprecated request@2.88.2
```

**Causa**: Dependencias antiguas en `restart_app`
**Impacto**: Ninguno en funcionalidad
**Estado**: No crítico

### 2. Vulnerabilidades npm audit
```
3 vulnerabilities (1 moderate, 2 critical)
```

**Causa**: Paquetes heredados del proyecto original
**Recomendación**: Actualizar dependencias en apps si es posible
**Workaround**: Las apps funcionan correctamente

## 📊 Tests Realizados

- ✅ Construcción de imagen exitosa
- ✅ Inicio de contenedor
- ✅ Aplicaciones Node.js funcionando
- ✅ Registry npm público accesible
- ⏳ Instalación Rust server (requiere primera ejecución)
- ⏳ Conexión de clientes (requiere configuración de red)

## 📚 Referencias

- [Ubuntu 22.04 Release Notes](https://ubuntu.com/blog/ubuntu-22-04-lts-released)
- [Node.js 20 LTS](https://nodejs.org/en/blog/release/v20.0.0)
- [Rust Server Original](https://github.com/Didstopia/rust-server)

## 🤝 Créditos

- **Proyecto Original**: Didstopia
- **Modernización**: 2025
- **Base**: Ubuntu 22.04 LTS + Node.js 20 LTS

