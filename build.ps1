# Script para construir la imagen Docker del servidor Rust en Windows

Write-Host "🚀 Construyendo imagen del servidor Rust modernizado..." -ForegroundColor Cyan
Write-Host ""

# Tags de la imagen
$IMAGE_NAME = "rustserver/rust-server"
$TAG_UBUNTU = "ubuntu-24.04"
$TAG_NODEJS = "nodejs-20"
$TAG_LATEST = "latest"

# Construir con múltiples tags
docker build `
  -t "${IMAGE_NAME}:${TAG_UBUNTU}" `
  -t "${IMAGE_NAME}:${TAG_NODEJS}" `
  -t "${IMAGE_NAME}:${TAG_LATEST}" `
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

