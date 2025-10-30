# Script Automatizado para Configurar y Subir a GitHub
# Ejecutar después de crear el repositorio en GitHub

Write-Host "🚀 Configuración Automática de GitHub" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en el directorio correcto
$expectedPath = "rust-server-modern"
$currentPath = Split-Path -Leaf (Get-Location)

if ($currentPath -ne $expectedPath) {
    Write-Host "⚠️  Cambiando al directorio correcto..." -ForegroundColor Yellow
    Set-Location -Path $PSScriptRoot
}

Write-Host "📍 Directorio actual: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Verificar git
Write-Host "🔍 Verificando Git..." -ForegroundColor Cyan
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitInstalled) {
    Write-Host "❌ Git no está instalado. Instálalo desde: https://git-scm.com/" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Git encontrado" -ForegroundColor Green
Write-Host ""

# Mostrar configuración actual
Write-Host "📋 Configuración actual de Git:" -ForegroundColor Cyan
Write-Host "   Usuario: $(git config --global user.name)" -ForegroundColor Gray
Write-Host "   Email:   $(git config --global user.email)" -ForegroundColor Gray
Write-Host ""

# Verificar si el repositorio ya está inicializado
if (-not (Test-Path ".git")) {
    Write-Host "⚠️  Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "feat: servidor Rust modernizado con Ubuntu 24.04 y Node.js 20 LTS

- Actualizado de Ubuntu 18.04 a 24.04 LTS
- Actualizado de Node.js 12 a Node.js 20 LTS
- Configurado npm registry público
- Ajustado UIDs para compatibilidad (1001:1001)
- Incluye apps Node.js: shutdown, restart, scheduler, heartbeat, rcon
- Docker Compose listo para usar
- Scripts de build para Windows y Linux
- Documentación completa"
    git branch -M main
    Write-Host "✓ Repositorio inicializado" -ForegroundColor Green
} else {
    Write-Host "✓ Repositorio ya inicializado" -ForegroundColor Green
}
Write-Host ""

# Verificar/configurar remote
Write-Host "🔗 Configurando remote de GitHub..." -ForegroundColor Cyan
$remoteUrl = "https://github.com/AngelMartinezDevops/rust-server-doblemartinez.git"

$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    Write-Host "   Remote actual: $existingRemote" -ForegroundColor Gray
    if ($existingRemote -ne $remoteUrl) {
        Write-Host "   Actualizando remote..." -ForegroundColor Yellow
        git remote set-url origin $remoteUrl
    }
} else {
    Write-Host "   Añadiendo remote..." -ForegroundColor Yellow
    git remote add origin $remoteUrl
}
Write-Host "✓ Remote configurado: $remoteUrl" -ForegroundColor Green
Write-Host ""

# Preguntar si ya creó el repositorio en GitHub
Write-Host "❓ ¿Ya has creado el repositorio en GitHub?" -ForegroundColor Yellow
Write-Host "   (Debe estar en: https://github.com/AngelMartinezDevops/rust-server-doblemartinez)" -ForegroundColor Gray
Write-Host ""
Write-Host "   Si NO lo has creado todavía:" -ForegroundColor Cyan
Write-Host "   1. Se abrirá tu navegador" -ForegroundColor Gray
Write-Host "   2. Crea el repositorio con el nombre: rust-server-doblemartinez" -ForegroundColor Gray
Write-Host "   3. NO marques ninguna opción (README, .gitignore, license)" -ForegroundColor Gray
Write-Host "   4. Vuelve aquí y presiona Enter" -ForegroundColor Gray
Write-Host ""

$response = Read-Host "¿Continuar con el push? (S/N)"

if ($response -match '^[Ss]$') {
    Write-Host ""
    Write-Host "📤 Haciendo push a GitHub..." -ForegroundColor Cyan
    Write-Host ""
    
    try {
        git push -u origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ ¡Éxito! Repositorio subido a GitHub" -ForegroundColor Green
            Write-Host ""
            Write-Host "🌐 Tu repositorio está en:" -ForegroundColor Cyan
            Write-Host "   https://github.com/AngelMartinezDevops/rust-server-doblemartinez" -ForegroundColor White
            Write-Host ""
            Write-Host "📝 Próximos pasos:" -ForegroundColor Yellow
            Write-Host "   - Ver tu repo en GitHub" -ForegroundColor Gray
            Write-Host "   - Clonar en otros lugares: git clone $remoteUrl" -ForegroundColor Gray
            Write-Host "   - Construir imagen: .\build.ps1" -ForegroundColor Gray
            Write-Host "   - Iniciar servidor: docker-compose up -d" -ForegroundColor Gray
            Write-Host ""
            
            # Preguntar si quiere abrir el repositorio
            $openBrowser = Read-Host "¿Abrir el repositorio en el navegador? (S/N)"
            if ($openBrowser -match '^[Ss]$') {
                Start-Process "https://github.com/AngelMartinezDevops/rust-server-doblemartinez"
            }
        } else {
            Write-Host ""
            Write-Host "❌ Error al hacer push" -ForegroundColor Red
            Write-Host ""
            Write-Host "Posibles causas:" -ForegroundColor Yellow
            Write-Host "1. El repositorio no existe en GitHub" -ForegroundColor Gray
            Write-Host "   → Créalo en: https://github.com/new" -ForegroundColor Gray
            Write-Host ""
            Write-Host "2. Problemas de autenticación" -ForegroundColor Gray
            Write-Host "   → Usa GitHub Desktop: https://desktop.github.com/" -ForegroundColor Gray
            Write-Host "   → O configura SSH: https://docs.github.com/en/authentication" -ForegroundColor Gray
            Write-Host ""
            Write-Host "3. El repositorio ya existe y tiene contenido" -ForegroundColor Gray
            Write-Host "   → Usa: git pull origin main --rebase" -ForegroundColor Gray
            Write-Host "   → Luego: git push -u origin main" -ForegroundColor Gray
        }
    } catch {
        Write-Host ""
        Write-Host "❌ Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "⏸️  Operación cancelada" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Para crear el repositorio:" -ForegroundColor Cyan
    Write-Host "1. Ve a: https://github.com/new" -ForegroundColor Gray
    Write-Host "2. Nombre: rust-server-doblemartinez" -ForegroundColor Gray
    Write-Host "3. NO marques ninguna opción" -ForegroundColor Gray
    Write-Host "4. Ejecuta este script de nuevo" -ForegroundColor Gray
    Write-Host ""
    Start-Process "https://github.com/new"
}

Write-Host ""
Write-Host "👋 Script finalizado" -ForegroundColor Cyan

