# Dockerfile completo para servidor Rust con Ubuntu 24.04 LTS + Node.js 20 LTS
# Versión todo-en-uno (no requiere imagen base separada)

FROM ubuntu:24.04

LABEL maintainer="Tu Nombre <tu@email.com>"

# ============================================
# VARIABLES Y CONFIGURACIÓN INICIAL
# ============================================
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV TERM=xterm
ENV TZ=Etc/UTC
ENV PGID=1001
ENV PUID=1001

# ============================================
# INSTALACIÓN BASE
# ============================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        software-properties-common \
        locales \
        wget \
        curl \
        git \
        sudo \
        libarchive-tools \
        gnupg2 \
        dirmngr \
        apt-transport-https \
        lsb-release && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Crear usuario (usa IDs diferentes ya que 1000 está ocupado en Ubuntu 24.04)
RUN groupadd --system --gid 1001 docker && \
    useradd \
        --create-home \
        --home /app \
        --uid 1001 \
        --gid 1001 \
        --groups users \
        --shell /bin/bash \
        docker && \
    mkdir -p /app

# ============================================
# INSTALACIÓN DE STEAMCMD
# ============================================
RUN dpkg --add-architecture i386 && \
    add-apt-repository multiverse && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        steamcmd \
        lib32gcc-s1 \
        libstdc++6 \
        libstdc++6:i386 \
        libsdl2-2.0-0:i386 \
        libcurl4:i386 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /steamcmd && \
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
    | tar -v -C /steamcmd -zx && \
    chmod +x /steamcmd/steamcmd.sh

# ============================================
# INSTALACIÓN DE NODE.JS 20 LTS
# ============================================
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        nodejs \
        python3 \
        python3-dev \
        build-essential \
        jq && \
    npm install -g npm@latest && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ============================================
# INSTALACIÓN DE NGINX Y DEPENDENCIAS
# ============================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        expect \
        tcl \
        libgdiplus && \
    rm -rf /var/lib/apt/lists/*

# Limpiar configuración nginx
RUN rm -fr /usr/share/nginx/html/* && \
    rm -fr /etc/nginx/sites-available/* && \
    rm -fr /etc/nginx/sites-enabled/*

# ============================================
# CONFIGURACIÓN DE WEBRCON
# ============================================
COPY nginx_rcon.conf /etc/nginx/nginx.conf
RUN curl -sL https://github.com/Facepunch/webrcon/archive/24b0898d86706723d52bb4db8559d90f7c9e069b.zip | bsdtar -xvf- -C /tmp && \
    mv /tmp/webrcon-24b0898d86706723d52bb4db8559d90f7c9e069b/* /usr/share/nginx/html/ && \
    rm -fr /tmp/webrcon-24b0898d86706723d52bb4db8559d90f7c9e069b

ADD fix_conn.sh /tmp/fix_conn.sh

# ============================================
# CREAR DIRECTORIOS
# ============================================
RUN mkdir -p /steamcmd/rust /usr/share/nginx/html /var/log/nginx

# ============================================
# INSTALACIÓN DE APLICACIONES NODE.JS
# ============================================

# Configurar npm para usar registry público
RUN npm config set registry https://registry.npmjs.org/

# Shutdown app
ADD shutdown_app/ /app/shutdown_app/
WORKDIR /app/shutdown_app
RUN rm -f .npmrc package-lock.json && npm install --registry=https://registry.npmjs.org/

# Restart app
ADD restart_app/ /app/restart_app/
WORKDIR /app/restart_app
RUN rm -f .npmrc package-lock.json && npm install --registry=https://registry.npmjs.org/

# Scheduler app
ADD scheduler_app/ /app/scheduler_app/
WORKDIR /app/scheduler_app
RUN rm -f .npmrc package-lock.json && npm install --registry=https://registry.npmjs.org/

# Heartbeat app
ADD heartbeat_app/ /app/heartbeat_app/
WORKDIR /app/heartbeat_app
RUN rm -f .npmrc package-lock.json && npm install --registry=https://registry.npmjs.org/

# RCON app
ADD rcon_app/ /app/rcon_app/
WORKDIR /app/rcon_app
RUN rm -f .npmrc package-lock.json && npm install --registry=https://registry.npmjs.org/
RUN ln -s /app/rcon_app/app.js /usr/bin/rcon

# ============================================
# COPIAR SCRIPTS Y ARCHIVOS
# ============================================
ADD install.txt /app/install.txt
ADD start_rust.sh /app/start.sh
ADD update_check.sh /app/update_check.sh
COPY README.md LICENSE.md /app/

WORKDIR /

# ============================================
# PERMISOS
# ============================================
RUN chown -R 1001:1001 \
    /steamcmd \
    /app \
    /usr/share/nginx/html \
    /var/log/nginx

# ============================================
# PUERTOS
# ============================================
EXPOSE 8080
EXPOSE 28015
EXPOSE 28016
EXPOSE 28082

# ============================================
# VARIABLES DE ENTORNO DEL SERVIDOR
# ============================================
ENV RUST_SERVER_STARTUP_ARGUMENTS="-batchmode -load -nographics +server.secure 1"
ENV RUST_SERVER_IDENTITY="docker"
ENV RUST_SERVER_PORT=""
ENV RUST_SERVER_QUERYPORT=""
ENV RUST_SERVER_SEED="12345"
ENV RUST_SERVER_NAME="Rust Server [DOCKER]"
ENV RUST_SERVER_DESCRIPTION="This is a Rust server running inside a Docker container!"
ENV RUST_SERVER_URL="https://hub.docker.com/r/didstopia/rust-server/"
ENV RUST_SERVER_BANNER_URL=""
ENV RUST_RCON_WEB="1"
ENV RUST_RCON_PORT="28016"
ENV RUST_RCON_PASSWORD="docker"
ENV RUST_APP_PORT="28082"
ENV RUST_UPDATE_CHECKING="0"
ENV RUST_HEARTBEAT="0"
ENV RUST_UPDATE_BRANCH="public"
ENV RUST_START_MODE="0"
ENV RUST_OXIDE_ENABLED="0"
ENV RUST_OXIDE_UPDATE_ON_BOOT="1"
ENV RUST_RCON_SECURE_WEBSOCKET="0"
ENV RUST_SERVER_WORLDSIZE="3500"
ENV RUST_SERVER_MAXPLAYERS="500"
ENV RUST_SERVER_SAVE_INTERVAL="600"
ENV CHOWN_DIRS="/app,/steamcmd,/usr/share/nginx/html,/var/log/nginx"

# ============================================
# INICIO
# ============================================
CMD ["bash", "/app/start.sh"]

