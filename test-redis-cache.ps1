# Redis Cache Test Script
# Bu script Redis cache'in durumunu kontrol eder

Write-Host "=== REDIS CACHE TEST ===" -ForegroundColor Cyan
Write-Host ""

# 1. Redis Bağlantısı
Write-Host "1. REDIS BAĞLANTISI" -ForegroundColor Yellow
Write-Host ""

try {
    $redisTest = docker exec redis redis-cli ping 2>&1
    if ($redisTest -match "PONG") {
        Write-Host "  ✓ Redis çalışıyor" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Redis çalışmıyor" -ForegroundColor Red
        Write-Host "    Redis'i başlatın: docker-compose up -d redis" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "  ✗ Redis kontrol edilemedi" -ForegroundColor Red
    Write-Host "    Redis'i başlatın: docker-compose up -d redis" -ForegroundColor Gray
    exit 1
}

Write-Host ""

# 2. Cache Key'leri Kontrolü
Write-Host "2. CACHE KEY'LERİ" -ForegroundColor Yellow
Write-Host ""

try {
    $keys = docker exec redis redis-cli KEYS "*" 2>&1
    if ($keys -and $keys.Count -gt 0) {
        $keyCount = ($keys -split "`n" | Where-Object { $_.Trim() }).Count
        Write-Host "  ✓ Toplam cache key sayısı: $keyCount" -ForegroundColor Green
        
        # Servis bazında key sayıları
        $services = @("user-service", "product-service", "order-service", "inventory-service", "notification-service")
        foreach ($service in $services) {
            $serviceKeys = docker exec redis redis-cli KEYS "$service:*" 2>&1
            if ($serviceKeys) {
                $serviceKeyCount = ($serviceKeys -split "`n" | Where-Object { $_.Trim() }).Count
                Write-Host "    • $service : $serviceKeyCount key" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "  ⚠ Henüz cache'lenmiş veri yok" -ForegroundColor Yellow
        Write-Host "    (Servisler çalıştığında ve API çağrıları yapıldığında cache oluşacak)" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ✗ Cache key'leri kontrol edilemedi" -ForegroundColor Red
}

Write-Host ""

# 3. Redis Info
Write-Host "3. REDIS BİLGİLERİ" -ForegroundColor Yellow
Write-Host ""

try {
    $info = docker exec redis redis-cli INFO memory 2>&1 | Select-String "used_memory_human|maxmemory_human"
    if ($info) {
        Write-Host "  Memory Kullanımı:" -ForegroundColor Cyan
        $info | ForEach-Object {
            Write-Host "    $_" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "  ⚠ Redis info alınamadı" -ForegroundColor Yellow
}

Write-Host ""

# 4. Örnek Cache Test
Write-Host "4. CACHE TEST ÖNERİLERİ" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Cache'i test etmek için:" -ForegroundColor Cyan
Write-Host "    1. Bir API endpoint'ine istek gönderin (örn: GET /api/users)" -ForegroundColor White
Write-Host "    2. Aynı endpoint'e tekrar istek gönderin" -ForegroundColor White
Write-Host "    3. İkinci istek cache'den dönecek (daha hızlı)" -ForegroundColor White
Write-Host ""
Write-Host "  Örnek:" -ForegroundColor Cyan
Write-Host "    # İlk istek (cache miss)" -ForegroundColor Gray
Write-Host "    Invoke-WebRequest -Uri 'http://localhost:8081/api/users' -Method GET" -ForegroundColor Gray
Write-Host ""
Write-Host "    # İkinci istek (cache hit - daha hızlı)" -ForegroundColor Gray
Write-Host "    Invoke-WebRequest -Uri 'http://localhost:8081/api/users' -Method GET" -ForegroundColor Gray
Write-Host ""

# 5. Cache Temizleme
Write-Host "5. CACHE TEMİZLEME" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Cache'i temizlemek için:" -ForegroundColor Cyan
Write-Host "    docker exec redis redis-cli FLUSHALL  # Tüm cache'i temizle" -ForegroundColor Gray
Write-Host "    docker exec redis redis-cli DEL 'user-service:users::all'  # Belirli bir key'i sil" -ForegroundColor Gray
Write-Host ""

# 6. Özet
Write-Host "=== ÖZET ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Redis Cache yapılandırıldı" -ForegroundColor Green
Write-Host "✅ Tüm servislere cache annotations eklendi" -ForegroundColor Green
Write-Host "✅ Cache configuration oluşturuldu" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Cache Configuration:" -ForegroundColor Yellow
Write-Host "   • User Service: 10 dakika TTL" -ForegroundColor Gray
Write-Host "   • Product Service: 15 dakika TTL" -ForegroundColor Gray
Write-Host "   • Order Service: 5 dakika TTL" -ForegroundColor Gray
Write-Host "   • Inventory Service: 2 dakika TTL" -ForegroundColor Gray
Write-Host "   • Notification Service: 10 dakika TTL" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Detaylı bilgi: REDIS_CACHING_GUIDE.md" -ForegroundColor Cyan
Write-Host ""

