# 🔌 WebSocket Real-time Order Tracking Kılavuzu

## 📋 Genel Bakış

Bu projede **WebSocket** kullanarak **real-time order tracking** implementasyonu yapılmıştır. Kullanıcılar sipariş durumunu sayfa yenilemeden canlı olarak takip edebilir.

### Ne İşe Yarar?

- ✅ **Real-time Updates**: Sipariş durumu değiştiğinde anında bildirim
- ✅ **No Page Refresh**: Sayfa yenilemeye gerek yok
- ✅ **Better UX**: Modern, responsive kullanıcı deneyimi
- ✅ **Live Notifications**: Canlı bildirimler

---

## 🛠️ Teknoloji

- **Spring WebSocket**: WebSocket support
- **STOMP**: Simple Text Oriented Messaging Protocol
- **SockJS**: WebSocket fallback (eski browser'lar için)

---

## 📁 Dosya Yapısı

```
order-service/
  ├── src/main/java/com/microservices/order/
  │   ├── Config/
  │   │   └── WebSocketConfig.java          # WebSocket configuration
  │   ├── Controller/
  │   │   └── OrderWebSocketController.java # WebSocket controller
  │   ├── DTO/
  │   │   └── OrderStatusUpdate.java        # Status update DTO
  │   └── Service/
  │       └── OrderService.java             # Order status değiştiğinde WebSocket'e mesaj gönderir
```

---

## 🚀 Nasıl Çalışır?

### 1. WebSocket Bağlantısı

Client WebSocket'e bağlanır:
```javascript
const socket = new SockJS('http://localhost:8083/ws');
const stompClient = Stomp.over(socket);
stompClient.connect({}, onConnected, onError);
```

### 2. Topic Subscribe

Client, sipariş durumu güncellemelerini dinler:
```javascript
stompClient.subscribe('/topic/order-updates/' + orderId, (message) => {
    const update = JSON.parse(message.body);
    updateUI(update);
});
```

### 3. Order Status Değişir

Order Service'de status değiştiğinde:
```java
OrderStatusUpdate statusUpdate = new OrderStatusUpdate(...);
webSocketController.sendOrderStatusUpdate(orderId, statusUpdate);
```

### 4. Client Anında Güncelleme Alır

WebSocket üzerinden mesaj gelir, UI otomatik güncellenir.

---

## 📊 WebSocket Endpoints

### Connection Endpoint
```
ws://localhost:8083/ws
```

### Topics

#### 1. Belirli Sipariş İçin
```
/topic/order-updates/{orderId}
```
**Kullanım:** Tek bir siparişi takip etmek için

**Örnek:**
```javascript
stompClient.subscribe('/topic/order-updates/550e8400-e29b-41d4-a716-446655440000', callback);
```

#### 2. Tüm Siparişler İçin
```
/topic/order-updates
```
**Kullanım:** Tüm sipariş güncellemelerini dinlemek için (admin paneli)

**Örnek:**
```javascript
stompClient.subscribe('/topic/order-updates', callback);
```

#### 3. Kullanıcının Tüm Siparişleri İçin
```
/topic/user-orders/{userId}
```
**Kullanım:** Kullanıcının tüm siparişlerini takip etmek için

**Örnek:**
```javascript
stompClient.subscribe('/topic/user-orders/660e8400-e29b-41d4-a716-446655440001', callback);
```

---

## 💻 Frontend Implementation

### HTML
```html
<!DOCTYPE html>
<html>
<head>
    <title>Order Tracking</title>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2/lib/stomp.min.js"></script>
</head>
<body>
    <div id="order-status">
        <h2>Order Status: <span id="status">Loading...</span></h2>
        <div id="updates"></div>
    </div>

    <script src="websocket-client.js"></script>
</body>
</html>
```

### JavaScript (websocket-client.js)
```javascript
// WebSocket bağlantısı
const socket = new SockJS('http://localhost:8083/ws');
const stompClient = Stomp.over(socket);

// Order ID (örnek)
const orderId = '550e8400-e29b-41d4-a716-446655440000';

// Bağlantı başarılı
function onConnected() {
    console.log('WebSocket connected');
    
    // Sipariş durumu güncellemelerini dinle
    stompClient.subscribe('/topic/order-updates/' + orderId, onOrderUpdate);
}

// Bağlantı hatası
function onError(error) {
    console.error('WebSocket error:', error);
}

// Sipariş güncellemesi geldi
function onOrderUpdate(message) {
    const update = JSON.parse(message.body);
    console.log('Order update received:', update);
    
    // UI güncelle
    document.getElementById('status').textContent = update.newStatus;
    
    // Güncelleme logu ekle
    const updatesDiv = document.getElementById('updates');
    const updateElement = document.createElement('div');
    updateElement.innerHTML = `
        <p><strong>${update.timestamp}</strong>: ${update.message}</p>
        <p>Status: ${update.oldStatus} → ${update.newStatus}</p>
    `;
    updatesDiv.insertBefore(updateElement, updatesDiv.firstChild);
}

// Bağlan
stompClient.connect({}, onConnected, onError);

// Sayfa kapanırken bağlantıyı kapat
window.addEventListener('beforeunload', () => {
    if (stompClient.connected) {
        stompClient.disconnect();
    }
});
```

---

## 📨 Message Format

### OrderStatusUpdate DTO

```json
{
  "orderId": "550e8400-e29b-41d4-a716-446655440000",
  "oldStatus": "PENDING",
  "newStatus": "CONFIRMED",
  "message": "Order status changed from PENDING to CONFIRMED",
  "timestamp": "2024-01-15T10:30:45.123",
  "userId": "660e8400-e29b-41d4-a716-446655440001"
}
```

### Order Status Values

- `PENDING`: Sipariş bekliyor
- `CONFIRMED`: Sipariş onaylandı
- `PROCESSING`: Hazırlanıyor
- `SHIPPED`: Kargoya verildi
- `DELIVERED`: Teslim edildi
- `CANCELLED`: İptal edildi

---

## 🔧 Configuration

### WebSocketConfig.java

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic", "/queue");
        config.setApplicationDestinationPrefixes("/app");
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")  // Production'da specific domain'ler
                .withSockJS();
    }
}
```

### CORS Configuration

Production'da `setAllowedOriginPatterns("*")` yerine specific domain'ler belirtilmeli:

```java
registry.addEndpoint("/ws")
        .setAllowedOriginPatterns("https://yourdomain.com", "https://www.yourdomain.com")
        .withSockJS();
```

---

## 🧪 Testing

### 1. WebSocket Bağlantısını Test Et

**Browser Console:**
```javascript
const socket = new SockJS('http://localhost:8083/ws');
const stomp = Stomp.over(socket);
stomp.connect({}, () => {
    console.log('Connected!');
    stomp.subscribe('/topic/order-updates', (msg) => {
        console.log('Update:', JSON.parse(msg.body));
    });
});
```

### 2. Order Status Değiştir

API ile sipariş durumunu değiştir:
```bash
curl -X PUT http://localhost:8083/api/orders/{orderId}/status \
  -H "Content-Type: application/json" \
  -d '{"status": "CONFIRMED"}'
```

### 3. WebSocket Mesajını Kontrol Et

Browser console'da mesaj görünmeli.

---

## 🎯 Use Cases

### 1. Order Tracking Page

Kullanıcı sipariş sayfasında:
- Sayfa açık kalır
- Sipariş durumu değiştiğinde otomatik güncellenir
- Progress bar canlı olarak ilerler

### 2. Admin Dashboard

Admin panelinde:
- Yeni siparişler anında görünür
- Sipariş durumu değişiklikleri canlı takip edilir
- Bildirimler otomatik çıkar

### 3. Mobile App

Mobil uygulamada:
- Push notification yerine WebSocket kullanılabilir
- Real-time updates
- Daha az battery drain

---

## ⚠️ Best Practices

### 1. Connection Management

```javascript
// Bağlantıyı düzgün kapat
window.addEventListener('beforeunload', () => {
    if (stompClient.connected) {
        stompClient.disconnect();
    }
});
```

### 2. Error Handling

```javascript
stompClient.connect({}, onConnected, (error) => {
    console.error('Connection error:', error);
    // Retry logic
    setTimeout(() => reconnect(), 5000);
});
```

### 3. Reconnection Logic

```javascript
function reconnect() {
    if (!stompClient.connected) {
        socket = new SockJS('http://localhost:8083/ws');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, onConnected, onError);
    }
}
```

### 4. Production Considerations

- **Load Balancing**: WebSocket için sticky sessions gerekir
- **Message Broker**: Production'da Redis veya RabbitMQ kullanılmalı
- **Security**: Authentication/Authorization eklenmeli
- **Rate Limiting**: WebSocket mesajları için rate limiting

---

## 🔒 Security

### Authentication

WebSocket bağlantısında authentication eklenebilir:

```java
@Override
public void registerStompEndpoints(StompEndpointRegistry registry) {
    registry.addEndpoint("/ws")
            .setHandshakeHandler(new DefaultHandshakeHandler() {
                @Override
                protected Principal determineUser(ServerHttpRequest request, 
                                                   WebSocketHandler wsHandler, 
                                                   Map<String, Object> attributes) {
                    // JWT token'dan user bilgisini çıkar
                    String token = request.getHeaders().getFirst("Authorization");
                    return extractUserFromToken(token);
                }
            })
            .withSockJS();
}
```

---

## 📚 Kaynaklar

- [Spring WebSocket Documentation](https://docs.spring.io/spring-framework/reference/web/websocket.html)
- [STOMP Protocol](https://stomp.github.io/)
- [SockJS Documentation](https://github.com/sockjs/sockjs-client)

---

## ✅ Avantajlar

- ✅ Real-time updates
- ✅ Better user experience
- ✅ No polling needed
- ✅ Lower server load
- ✅ Modern, impressive feature

---

## 🎉 Sonuç

WebSocket ile:
- ✅ Sipariş durumu canlı takip edilir
- ✅ Kullanıcı deneyimi iyileşir
- ✅ Modern, responsive uygulama
- ✅ Production-ready real-time features

