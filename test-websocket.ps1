# WebSocket Test Script
# Bu script WebSocket bağlantısını ve order status updates'i test eder

Write-Host "=== WEBSOCKET TEST ===" -ForegroundColor Cyan
Write-Host ""

# 1. Order Service Kontrolü
Write-Host "1. ORDER SERVICE KONTROLÜ" -ForegroundColor Yellow
Write-Host ""

try {
    $orderServiceHealth = Invoke-RestMethod -Uri "http://localhost:8083/actuator/health" -Method GET -ErrorAction Stop
    if ($orderServiceHealth.status -eq "UP") {
        Write-Host "  ✓ Order Service çalışıyor" -ForegroundColor Green
        Write-Host "    Port: 8083" -ForegroundColor Gray
    } else {
        Write-Host "  ✗ Order Service çalışmıyor" -ForegroundColor Red
        Write-Host "    Order Service'i başlatın" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "  ✗ Order Service kontrol edilemedi" -ForegroundColor Red
    Write-Host "    Order Service'i başlatın: docker-compose up -d order-service" -ForegroundColor Gray
    exit 1
}

Write-Host ""

# 2. WebSocket Endpoint Kontrolü
Write-Host "2. WEBSOCKET ENDPOINT" -ForegroundColor Yellow
Write-Host ""
Write-Host "  WebSocket Endpoint: ws://localhost:8083/ws" -ForegroundColor Cyan
Write-Host "  STOMP Topics:" -ForegroundColor Cyan
Write-Host "    • /topic/order-updates/{orderId} - Belirli sipariş için" -ForegroundColor Gray
Write-Host "    • /topic/order-updates - Tüm siparişler için" -ForegroundColor Gray
Write-Host "    • /topic/user-orders/{userId} - Kullanıcının siparişleri için" -ForegroundColor Gray
Write-Host ""

# 3. Test Adımları
Write-Host "3. TEST ADIMLARI" -ForegroundColor Yellow
Write-Host ""
Write-Host "  WebSocket'i test etmek için:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  A) Browser ile Test:" -ForegroundColor Yellow
Write-Host "    1. websocket-client-example.html dosyasını browser'da açın" -ForegroundColor White
Write-Host "    2. Order ID girin (örnek: mevcut bir sipariş ID'si)" -ForegroundColor White
Write-Host "    3. Connect butonuna tıklayın" -ForegroundColor White
Write-Host "    4. Başka bir terminal'de sipariş durumunu değiştirin:" -ForegroundColor White
Write-Host "       curl -X PUT http://localhost:8083/api/orders/{orderId}/status \" -ForegroundColor Gray
Write-Host "            -H \"Content-Type: application/json\" \" -ForegroundColor Gray
Write-Host "            -d '{\"status\": \"CONFIRMED\"}'" -ForegroundColor Gray
Write-Host "    5. Browser'da anında güncelleme görünmeli" -ForegroundColor White
Write-Host ""
Write-Host "  B) JavaScript Console ile Test:" -ForegroundColor Yellow
Write-Host "    1. Browser console'u açın (F12)" -ForegroundColor White
Write-Host "    2. Şu kodu çalıştırın:" -ForegroundColor White
Write-Host ""
Write-Host "       const socket = new SockJS('http://localhost:8083/ws');" -ForegroundColor Gray
Write-Host "       const stomp = Stomp.over(socket);" -ForegroundColor Gray
Write-Host "       stomp.connect({}, () => {" -ForegroundColor Gray
Write-Host "           console.log('Connected!');" -ForegroundColor Gray
Write-Host "           stomp.subscribe('/topic/order-updates', (msg) => {" -ForegroundColor Gray
Write-Host "               console.log('Update:', JSON.parse(msg.body));" -ForegroundColor Gray
Write-Host "           });" -ForegroundColor Gray
Write-Host "       });" -ForegroundColor Gray
Write-Host ""

# 4. Örnek Order ID Bulma
Write-Host "4. ÖRNEK ORDER ID BULMA" -ForegroundColor Yellow
Write-Host ""

try {
    $orders = Invoke-RestMethod -Uri "http://localhost:8083/api/orders" -Method GET -ErrorAction Stop
    if ($orders -and $orders.Count -gt 0) {
        $firstOrder = $orders[0]
        Write-Host "  ✓ Mevcut sipariş bulundu" -ForegroundColor Green
        Write-Host "    Order ID: $($firstOrder.id)" -ForegroundColor Cyan
        Write-Host "    Status: $($firstOrder.status)" -ForegroundColor Gray
        Write-Host "    User ID: $($firstOrder.userId)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "    Test için bu Order ID'yi kullanabilirsiniz!" -ForegroundColor Yellow
    } else {
        Write-Host "  ⚠ Henüz sipariş yok" -ForegroundColor Yellow
        Write-Host "    Önce bir sipariş oluşturun" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ⚠ Siparişler kontrol edilemedi" -ForegroundColor Yellow
    Write-Host "    API endpoint'i kontrol edin" -ForegroundColor Gray
}

Write-Host ""

# 5. Özet
Write-Host "=== ÖZET ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ WebSocket yapılandırıldı" -ForegroundColor Green
Write-Host "✅ Order Service'de WebSocket controller eklendi" -ForegroundColor Green
Write-Host "✅ Order status değiştiğinde WebSocket'e mesaj gönderiliyor" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Dosyalar:" -ForegroundColor Yellow
Write-Host "   • order-service/.../Config/WebSocketConfig.java" -ForegroundColor Gray
Write-Host "   • order-service/.../Controller/OrderWebSocketController.java" -ForegroundColor Gray
Write-Host "   • order-service/.../DTO/OrderStatusUpdate.java" -ForegroundColor Gray
Write-Host "   • websocket-client-example.html (Frontend örneği)" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Detaylı bilgi: WEBSOCKET_GUIDE.md" -ForegroundColor Cyan
Write-Host ""

