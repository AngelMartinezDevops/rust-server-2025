# Script para construir la imagen Docker del servidor Rust en Windows

Write-Host "🚀 Construyendo imagen del servidor Rust modernizado..." -ForegroundColor Cyan
Write-Host ""

# Tags de la imagen
$IMAGE_NAME = "b3lerofonte/rust-server"
$TAG = "latest"

# Construir imagen
docker build `
  -t "${IMAGE_NAME}:${TAG}" `
  .

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Imagen construida exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tags creados:" -ForegroundColor Yellow
    Write-Host "  - ${IMAGE_NAME}:${TAG_UBUNTU}"
    Write-Host "  - ${IMAGE_NAME}:${TAG_NODEJS}"
    Write-Host "  - ${IMAGE_NAME}:${TAG_LATEST}"
    Write-Host ""
    Write-Host "Para iniciar el servidor:" -ForegroundColor Yellow
    Write-Host "  docker-compose up -d"
} else {
    Write-Host ""
    Write-Host "❌ Error al construir la imagen" -ForegroundColor Red
    exit 1
}

