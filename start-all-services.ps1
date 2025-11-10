# Docker ile Tüm Servisleri Başlatma Scripti
# Kullanım: .\start-all-services.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Docker Microservices Başlatılıyor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Docker'ın çalışıp çalışmadığını kontrol et
Write-Host "Docker kontrol ediliyor..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✅ Docker çalışıyor" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker çalışmıyor! Lütfen Docker Desktop'ı başlatın." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Config repo kontrolü
Write-Host "Config repository kontrol ediliyor..." -ForegroundColor Yellow
if (-not (Test-Path "config-repo")) {
    Write-Host "⚠️  config-repo klasörü bulunamadı, oluşturuluyor..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "config-repo" | Out-Null
    
    if (Test-Path "C:\Users\pc\config-repo") {
        Copy-Item -Path "C:\Users\pc\config-repo\*" -Destination "config-repo\" -Recurse -Force
        Write-Host "✅ Config dosyaları kopyalandı" -ForegroundColor Green
    } else {
        Write-Host "⚠️  C:\Users\pc\config-repo bulunamadı" -ForegroundColor Yellow
        Write-Host "   Lütfen config dosyalarını manuel olarak config-repo klasörüne kopyalayın" -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ config-repo klasörü mevcut" -ForegroundColor Green
}

Write-Host ""

# Servisleri başlat
Write-Host "Servisler başlatılıyor..." -ForegroundColor Yellow
Write-Host "Bu işlem birkaç dakika sürebilir..." -ForegroundColor Yellow
Write-Host ""

docker-compose up -d

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Servisler Başlatıldı!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Servis durumunu göster
Write-Host "Servis durumu kontrol ediliyor..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

docker-compose ps

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Servis URL'leri" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Service Registry (Eureka):" -ForegroundColor Yellow
Write-Host "  http://localhost:8761" -ForegroundColor White
Write-Host ""
Write-Host "Config Server:" -ForegroundColor Yellow
Write-Host "  http://localhost:8888" -ForegroundColor White
Write-Host ""
Write-Host "API Gateway:" -ForegroundColor Yellow
Write-Host "  http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "User Service:" -ForegroundColor Yellow
Write-Host "  http://localhost:8081" -ForegroundColor White
Write-Host ""
Write-Host "Product Service:" -ForegroundColor Yellow
Write-Host "  http://localhost:8082" -ForegroundColor White
Write-Host ""
Write-Host "Order Service:" -ForegroundColor Yellow
Write-Host "  http://localhost:8083" -ForegroundColor White
Write-Host ""
Write-Host "Inventory Service:" -ForegroundColor Yellow
Write-Host "  http://localhost:8084" -ForegroundColor White
Write-Host ""
Write-Host "Notification Service:" -ForegroundColor Yellow
Write-Host "  http://localhost:8085" -ForegroundColor White
Write-Host ""
Write-Host "RabbitMQ Management:" -ForegroundColor Yellow
Write-Host "  http://localhost:15672 (guest/guest)" -ForegroundColor White
Write-Host ""
Write-Host "Zipkin:" -ForegroundColor Yellow
Write-Host "  http://localhost:9411" -ForegroundColor White
Write-Host ""
Write-Host "Kibana:" -ForegroundColor Yellow
Write-Host "  http://localhost:5601" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Logları Görüntüleme" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tüm servislerin logları:" -ForegroundColor Yellow
Write-Host "  docker-compose logs -f" -ForegroundColor White
Write-Host ""
Write-Host "Belirli bir servisin logları:" -ForegroundColor Yellow
Write-Host "  docker-compose logs -f [servis-adı]" -ForegroundColor White
Write-Host ""
Write-Host "Servisleri durdurmak için:" -ForegroundColor Yellow
Write-Host "  docker-compose down" -ForegroundColor White
Write-Host ""

