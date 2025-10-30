#!/bin/bash
# Script para construir la imagen Docker del servidor Rust

echo "🚀 Construyendo imagen del servidor Rust modernizado..."
echo ""

# Tags de la imagen
IMAGE_NAME="rustserver/rust-server"
TAG_UBUNTU="ubuntu-24.04"
TAG_NODEJS="nodejs-20"
TAG_LATEST="latest"

# Construir con múltiples tags
docker build \
  -t ${IMAGE_NAME}:${TAG_UBUNTU} \
  -t ${IMAGE_NAME}:${TAG_NODEJS} \
  -t ${IMAGE_NAME}:${TAG_LATEST} \
  .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Imagen construida exitosamente!"
    echo ""
    echo "Tags creados:"
    echo "  - ${IMAGE_NAME}:${TAG_UBUNTU}"
    echo "  - ${IMAGE_NAME}:${TAG_NODEJS}"
    echo "  - ${IMAGE_NAME}:${TAG_LATEST}"
    echo ""
    echo "Para iniciar el servidor:"
    echo "  docker-compose up -d"
else
    echo ""
    echo "❌ Error al construir la imagen"
    exit 1
fi

