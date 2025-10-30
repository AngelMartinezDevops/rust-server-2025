# Rust Server - Modern Edition

> 🌍 [Versión en español disponible](README.md)

Modernized Rust dedicated server with **Ubuntu 22.04 LTS** and **Node.js 20 LTS**.

## Features

- ✅ **Ubuntu 22.04 LTS** - Stable base system, SteamCMD compatible
- ✅ **Node.js 20 LTS** - Modern Node.js version
- ✅ **SteamCMD** - Automatic installation and updates
- ✅ **WebRCON** - Integrated web administration
- ✅ **Rust+** - Companion app support
- ✅ **Automatic installation** - Downloads server on first start
- ✅ **Data persistence** - Saves your progress

## Quick Start

```bash
# Download and run
docker pull b3lerofonte/rust-server:latest

# Using docker run
docker run -d \
  --name rust-server \
  --user 1000:1000 \
  -p 28015:28015/tcp \
  -p 28015:28015/udp \
  -p 28016:28016 \
  -p 8080:8080 \
  -p 28082:28082 \
  -v rust-data:/steamcmd/rust \
  -e RUST_SERVER_NAME="My Rust Server" \
  -e RUST_RCON_PASSWORD="your_password_here" \
  b3lerofonte/rust-server:latest
```

## Using Docker Compose

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
      RUST_SERVER_NAME: "My Rust Server"
      RUST_SERVER_SEED: "12345"
      RUST_SERVER_WORLDSIZE: "3500"
      RUST_SERVER_MAXPLAYERS: "50"
      RUST_RCON_PASSWORD: "change_this_password"
      RUST_RCON_WEB: "1"

volumes:
  rust-data:
```

Then run:
```bash
docker compose up -d
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUST_SERVER_NAME` | Server name | "Rust Server" |
| `RUST_SERVER_SEED` | Map seed | "12345" |
| `RUST_SERVER_WORLDSIZE` | Map size | "3500" |
| `RUST_SERVER_MAXPLAYERS` | Max players | "50" |
| `RUST_SERVER_IDENTITY` | Identity folder | "rust-server" |
| `RUST_RCON_PASSWORD` | RCON password | "changeme" |
| `RUST_RCON_PORT` | RCON port | "28016" |
| `RUST_RCON_WEB` | WebRCON enabled | "1" |
| `RUST_UPDATE_CHECKING` | Check for updates | "0" |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 28015 | TCP/UDP | Main game port |
| 28016 | TCP | RCON port |
| 8080 | TCP | Rust+ app |
| 28082 | TCP | Application port |

## Connecting to the Server

### From the Game

1. Press `F1` to open console
2. Type:
```
client.connect localhost:28015
```

### From Another Computer

```
client.connect YOUR_SERVER_IP:28015
```

## RCON Administration

### WebRCON
Access via browser: `http://your-server-ip:28016`

### CLI (from inside container)
```bash
docker exec -it rust-server rcon say "Hello Server!"
```

## First Start

On first startup, the server will:
1. Download SteamCMD (~75 MB)
2. Download Rust server (~8 GB)
3. Generate the procedural map
4. Start the server

**This can take 15-30 minutes depending on your connection.**

## View Logs

```bash
# Real-time logs
docker compose logs -f rust-server

# Last 100 lines
docker compose logs --tail 100 rust-server
```

## Restart Server

```bash
docker compose restart rust-server
```

## Stop Server

```bash
docker compose down
```

## Update Server

```bash
docker compose pull
docker compose up -d
```

## Data Persistence

All server data is stored in the Docker volume `rust-data`:
- Map and world
- Player blueprints
- Player data
- Server configuration

## System Requirements

### Minimum
- **CPU**: 2 cores
- **RAM**: 4 GB
- **Disk**: 15 GB
- **Network**: Stable connection with open ports

### Recommended
- **CPU**: 4+ cores
- **RAM**: 8+ GB
- **Disk**: 20+ GB SSD
- **Network**: Stable connection with open ports

## Base Image

This image is built on top of:
- **b3lerofonte/base:nodejs-20-steamcmd-ubuntu-22.04**
- Repository: [base-2025](https://github.com/AngelMartinezDevops/base-2025)

## Repository

Source code: [rust-server-2025](https://github.com/AngelMartinezDevops/rust-server-2025)

## License

MIT License - See LICENSE.md

## Author

**b3lerofonte**
- GitHub: [@AngelMartinezDevops](https://github.com/AngelMartinezDevops)
- Docker Hub: [b3lerofonte](https://hub.docker.com/u/b3lerofonte)
- Email: angel200391@gmail.com

## Credits

Based on the excellent work of:
- [Didstopia/rust-server](https://github.com/Didstopia/rust-server)

Modernized and updated for 2025 with the latest software versions.

## Support

If you encounter any issues:
1. Check the logs: `docker compose logs -f rust-server`
2. Verify ports are open
3. Ensure you have enough disk space
4. Check Docker and Docker Compose versions

For bugs and feature requests, open an issue on GitHub.

