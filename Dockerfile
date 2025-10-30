# Dockerfile para Servidor Rust
# Usa la imagen base con Ubuntu 22.04 + Node.js 20 + SteamCMD

FROM b3lerofonte/base:nodejs-20-steamcmd-ubuntu-22.04

LABEL maintainer="b3lerofonte"

# ============================================
# VARIABLES DE ENTORNO DEL SERVIDOR RUST
# ============================================
ENV RUST_SERVER_STARTUP_ARGUMENTS="-batchmode -load -nographics +server.secure 1"
ENV RUST_SERVER_IDENTITY="rust-server"
ENV RUST_SERVER_PORT="28015"
ENV RUST_SERVER_SEED="12345"
ENV RUST_SERVER_WORLDSIZE="3500"
ENV RUST_SERVER_MAXPLAYERS="50"
ENV RUST_SERVER_HOSTNAME="Rust Server"
ENV RUST_SERVER_URL="https://rust.facepunch.com"
ENV RUST_SERVER_BANNER_URL=""
ENV RUST_SERVER_DESCRIPTION="Rust server running on Docker"
ENV RUST_SERVER_SAVE_INTERVAL="300"
ENV RUST_RCON_WEB="1"
ENV RUST_RCON_PORT="28016"
ENV RUST_RCON_PASSWORD="changeme"
ENV RUST_UPDATE_CHECKING="0"
ENV RUST_UPDATE_BRANCH="public"
ENV RUST_START_MODE="0"
ENV RUST_OXIDE_ENABLED="0"
ENV RUST_OXIDE_UPDATE_ON_BOOT="1"
ENV RUST_SERVER_ENCRYPTION_LEVEL="2"
ENV RUST_APP_PORT="28082"

# Variables adicionales
USER root

# ============================================
# CONFIGURAR NPM PARA REGISTRY PÚBLICO
# ============================================
RUN npm config set registry https://registry.npmjs.org/

# ============================================
# INSTALAR APLICACIONES NODE.JS
# ============================================

# Shutdown app
COPY shutdown_app/ /app/shutdown_app/
WORKDIR /app/shutdown_app
RUN rm -f .npmrc package-lock.json && \
    npm install --registry=https://registry.npmjs.org/

# Restart app
COPY restart_app/ /app/restart_app/
WORKDIR /app/restart_app
RUN rm -f .npmrc package-lock.json && \
    npm install --registry=https://registry.npmjs.org/

# Scheduler app
COPY scheduler_app/ /app/scheduler_app/
WORKDIR /app/scheduler_app
RUN rm -f .npmrc package-lock.json && \
    npm install --registry=https://registry.npmjs.org/

# Heartbeat app
COPY heartbeat_app/ /app/heartbeat_app/
WORKDIR /app/heartbeat_app
RUN rm -f .npmrc package-lock.json && \
    npm install --registry=https://registry.npmjs.org/

# RCON app
COPY rcon_app/ /app/rcon_app/
WORKDIR /app/rcon_app
RUN rm -f .npmrc package-lock.json && \
    npm install --registry=https://registry.npmjs.org/
RUN ln -s /app/rcon_app/app.js /usr/bin/rcon

# ============================================
# COPIAR SCRIPTS Y CONFIGURACIÓN
# ============================================

# Scripts principales
COPY start_rust.sh /app/start_rust.sh
COPY update_check.sh /app/update_check.sh
COPY install.txt /app/install.txt
COPY fix_conn.sh /app/fix_conn.sh

# Configuración de Nginx para WebRCON
COPY nginx_rcon.conf /etc/nginx/sites-available/default

# Convertir finales de línea de Windows a Unix
RUN sed -i 's/\r$//' /app/*.sh

# ============================================
# CONFIGURAR PERMISOS
# ============================================
RUN chown -R 1000:1000 \
    /steamcmd \
    /app \
    /usr/share/nginx/html \
    /var/log/nginx && \
    chmod +x /app/*.sh

# ============================================
# EXPONER PUERTOS
# ============================================
EXPOSE 8080/tcp
EXPOSE 28015/tcp
EXPOSE 28015/udp
EXPOSE 28016/tcp
EXPOSE 28082/tcp

# ============================================
# VOLÚMENES
# ============================================
VOLUME ["/steamcmd/rust"]

# ============================================
# INICIO
# ============================================
WORKDIR /app

# Cambiar a usuario docker
USER docker

# Script de inicio
CMD ["/bin/bash", "/app/start_rust.sh"]
