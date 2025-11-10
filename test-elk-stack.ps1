# ELK Stack Test Script
# Bu script ELK Stack servislerinin durumunu kontrol eder

Write-Host "=== ELK STACK TEST ===" -ForegroundColor Cyan
Write-Host ""

# 1. Elasticsearch Kontrolü
Write-Host "1. ELASTICSEARCH" -ForegroundColor Yellow
Write-Host ""

try {
    $esHealth = Invoke-RestMethod -Uri "http://localhost:9200/_cluster/health" -Method GET -ErrorAction Stop
    if ($esHealth.status -eq "green" -or $esHealth.status -eq "yellow") {
        Write-Host "  ✓ Elasticsearch çalışıyor" -ForegroundColor Green
        Write-Host "    Status: $($esHealth.status)" -ForegroundColor Gray
        Write-Host "    Cluster Name: $($esHealth.cluster_name)" -ForegroundColor Gray
        Write-Host "    Number of Nodes: $($esHealth.number_of_nodes)" -ForegroundColor Gray
    } else {
        Write-Host "  ⚠ Elasticsearch çalışıyor ama status: $($esHealth.status)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ✗ Elasticsearch çalışmıyor" -ForegroundColor Red
    Write-Host "    Elasticsearch'i başlatın: docker-compose up -d elasticsearch" -ForegroundColor Gray
}

Write-Host ""

# 2. Logstash Kontrolü
Write-Host "2. LOGSTASH" -ForegroundColor Yellow
Write-Host ""

try {
    $lsStats = Invoke-RestMethod -Uri "http://localhost:9600/_node/stats" -Method GET -ErrorAction Stop
    Write-Host "  ✓ Logstash çalışıyor" -ForegroundColor Green
    Write-Host "    Version: $($lsStats.version)" -ForegroundColor Gray
    Write-Host "    Pipeline Workers: $($lsStats.pipelines.main.workers)" -ForegroundColor Gray
} catch {
    Write-Host "  ✗ Logstash çalışmıyor" -ForegroundColor Red
    Write-Host "    Logstash'i başlatın: docker-compose up -d logstash" -ForegroundColor Gray
}

Write-Host ""

# 3. Kibana Kontrolü
Write-Host "3. KIBANA" -ForegroundColor Yellow
Write-Host ""

try {
    $kibanaStatus = Invoke-RestMethod -Uri "http://localhost:5601/api/status" -Method GET -ErrorAction Stop
    Write-Host "  ✓ Kibana çalışıyor" -ForegroundColor Green
    Write-Host "    Version: $($kibanaStatus.version.number)" -ForegroundColor Gray
    Write-Host "    Status: $($kibanaStatus.status.overall.state)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    🌐 Kibana UI: http://localhost:5601" -ForegroundColor Cyan
} catch {
    Write-Host "  ✗ Kibana çalışmıyor" -ForegroundColor Red
    Write-Host "    Kibana'yı başlatın: docker-compose up -d kibana" -ForegroundColor Gray
}

Write-Host ""

# 4. Index Kontrolü
Write-Host "4. ELASTICSEARCH INDEX'LERİ" -ForegroundColor Yellow
Write-Host ""

try {
    $indices = Invoke-RestMethod -Uri "http://localhost:9200/_cat/indices?v" -Method GET -ErrorAction Stop
    if ($indices) {
        Write-Host "  ✓ Index'ler:" -ForegroundColor Green
        $indices -split "`n" | Where-Object { $_.Trim() -and $_ -notmatch "health" } | ForEach-Object {
            Write-Host "    $_" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⚠ Henüz index oluşturulmamış" -ForegroundColor Yellow
        Write-Host "    (Loglar üretildiğinde otomatik oluşturulacak)" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ✗ Index'ler kontrol edilemedi" -ForegroundColor Red
}

Write-Host ""

# 5. Log Örnekleri
Write-Host "5. LOG ÖRNEKLERİ" -ForegroundColor Yellow
Write-Host ""

try {
    $searchResult = Invoke-RestMethod -Uri "http://localhost:9200/microservices-logs-*/_search?size=5&sort=@timestamp:desc" -Method GET -ErrorAction Stop
    if ($searchResult.hits.total.value -gt 0) {
        Write-Host "  ✓ Toplam log sayısı: $($searchResult.hits.total.value)" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Son 5 log:" -ForegroundColor Cyan
        foreach ($hit in $searchResult.hits.hits) {
            $source = $hit._source
            Write-Host "    • [$($source.'@timestamp')] [$($source.level)] [$($source.service)] $($source.message)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⚠ Henüz log yok" -ForegroundColor Yellow
        Write-Host "    (Servisler çalıştığında loglar üretilecek)" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ⚠ Log örnekleri alınamadı (index henüz oluşturulmamış olabilir)" -ForegroundColor Yellow
}

Write-Host ""

# 6. Özet
Write-Host "=== ÖZET ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ ELK Stack yapılandırıldı" -ForegroundColor Green
Write-Host "✅ Logback JSON encoder eklendi" -ForegroundColor Green
Write-Host "✅ Docker Compose'da ELK servisleri eklendi" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Sonraki Adımlar:" -ForegroundColor Yellow
Write-Host "   1. Kibana'ya gidin: http://localhost:5601" -ForegroundColor White
Write-Host "   2. Index pattern oluşturun: microservices-logs-*" -ForegroundColor White
Write-Host "   3. Discover'da logları görüntüleyin" -ForegroundColor White
Write-Host "   4. Dashboard oluşturun" -ForegroundColor White
Write-Host ""
Write-Host "📚 Detaylı bilgi: ELK_STACK_GUIDE.md" -ForegroundColor Cyan
Write-Host ""

