# 🐳 Docker ile Tüm Servisleri Başlatma Kılavuzu

## 🚀 Hızlı Başlangıç

Tüm servisleri tek komutla başlatmak için:

```bash
docker-compose up -d
```

Bu komut tüm servisleri arka planda başlatır:
- ✅ PostgreSQL (Database)
- ✅ RabbitMQ (Message Queue)
- ✅ Redis (Cache)
- ✅ Zipkin (Distributed Tracing)
- ✅ Elasticsearch, Logstash, Kibana (ELK Stack)
- ✅ Service Registry (Eureka)
- ✅ Config Server
- ✅ User Service
- ✅ Product Service
- ✅ Order Service
- ✅ Inventory Service
- ✅ Notification Service
- ✅ API Gateway

---

## 📋 Servisler ve Portlar

| Servis | Port | URL |
|--------|------|-----|
| **Service Registry (Eureka)** | 8761 | http://localhost:8761 |
| **Config Server** | 8888 | http://localhost:8888 |
| **API Gateway** | 8080 | http://localhost:8080 |
| **User Service** | 8081 | http://localhost:8081 |
| **Product Service** | 8082 | http://localhost:8082 |
| **Order Service** | 8083 | http://localhost:8083 |
| **Inventory Service** | 8084 | http://localhost:8084 |
| **Notification Service** | 8085 | http://localhost:8085 |
| **PostgreSQL** | 5432 | localhost:5432 |
| **RabbitMQ** | 5672, 15672 | http://localhost:15672 |
| **Redis** | 6379 | localhost:6379 |
| **Zipkin** | 9411 | http://localhost:9411 |
| **Elasticsearch** | 9200 | http://localhost:9200 |
| **Kibana** | 5601 | http://localhost:5601 |

---

## 🛠️ Komutlar

### Tüm Servisleri Başlat
```bash
docker-compose up -d
```

### Servisleri Durdur
```bash
docker-compose down
```

### Servisleri Yeniden Başlat
```bash
docker-compose restart
```

### Logları Görüntüle
```bash
# Tüm servislerin logları
docker-compose logs -f

# Belirli bir servisin logları
docker-compose logs -f user-service
docker-compose logs -f api-gateway
```

### Servis Durumunu Kontrol Et
```bash
docker-compose ps
```

### Servisleri Yeniden Build Et
```bash
docker-compose build
docker-compose up -d
```

### Sadece Database Servislerini Başlat
```bash
docker-compose up -d postgres rabbitmq redis
```

### Sadece Microservices'i Başlat
```bash
docker-compose up -d service-registry config-server user-service product-service order-service inventory-service notification-service api-gateway
```

---

## 🔍 Servis Durumunu Kontrol Etme

### Docker Compose ile
```bash
docker-compose ps
```

### Health Check ile
```powershell
# Service Registry
Invoke-WebRequest -Uri "http://localhost:8761/actuator/health"

# Config Server
Invoke-WebRequest -Uri "http://localhost:8888/actuator/health"

# User Service
Invoke-WebRequest -Uri "http://localhost:8081/actuator/health"

# Product Service
Invoke-WebRequest -Uri "http://localhost:8082/actuator/health"

# Order Service
Invoke-WebRequest -Uri "http://localhost:8083/actuator/health"

# Inventory Service
Invoke-WebRequest -Uri "http://localhost:8084/actuator/health"

# Notification Service
Invoke-WebRequest -Uri "http://localhost:8085/actuator/health"

# API Gateway
Invoke-WebRequest -Uri "http://localhost:8080/actuator/health"
```

### Eureka Dashboard
Tarayıcıda açın: http://localhost:8761

Tüm kayıtlı servisleri görebilirsiniz.

---

## 🐛 Sorun Giderme

### Servisler Başlamıyor

1. **Logları kontrol edin:**
   ```bash
   docker-compose logs [servis-adı]
   ```

2. **Servisleri sırayla başlatın:**
   ```bash
   # 1. Database servisleri
   docker-compose up -d postgres rabbitmq redis
   
   # 2. Service Registry
   docker-compose up -d service-registry
   
   # 3. Config Server
   docker-compose up -d config-server
   
   # 4. Microservices
   docker-compose up -d user-service product-service order-service inventory-service notification-service
   
   # 5. API Gateway
   docker-compose up -d api-gateway
   ```

3. **Port çakışması kontrol edin:**
   ```bash
   # Windows PowerShell
   netstat -ano | findstr :8080
   netstat -ano | findstr :8081
   # ...
   ```

### Config Server Hatası

Config Server, `config-repo` klasöründeki dosyaları okur. Bu klasörün proje root'unda olduğundan emin olun:

```bash
# Config dosyalarını kontrol edin
ls config-repo/
```

Eğer config dosyaları `C:\Users\pc\config-repo` altındaysa, bunları proje root'una kopyalayın:

```powershell
Copy-Item -Path "C:\Users\pc\config-repo\*" -Destination "config-repo\" -Recurse -Force
```

### Database Bağlantı Hatası

PostgreSQL container'ının çalıştığından emin olun:

```bash
docker-compose ps postgres
docker-compose logs postgres
```

### Servisler Birbirini Bulamıyor

1. **Network kontrolü:**
   ```bash
   docker network ls
   docker network inspect java-microservices_microservices-network
   ```

2. **Service Registry kontrolü:**
   - http://localhost:8761 adresini açın
   - Tüm servislerin kayıtlı olduğunu kontrol edin

---

## 🔄 Servis Başlatma Sırası

Docker Compose otomatik olarak dependency'leri yönetir, ancak manuel başlatma için sıra:

1. **Infrastructure:**
   - PostgreSQL
   - RabbitMQ
   - Redis

2. **Service Discovery:**
   - Service Registry (Eureka)

3. **Configuration:**
   - Config Server

4. **Microservices:**
   - User Service
   - Product Service
   - Order Service
   - Inventory Service
   - Notification Service

5. **Gateway:**
   - API Gateway

---

## 📝 Notlar

- İlk build işlemi uzun sürebilir (Maven dependencies indiriliyor)
- Servislerin tamamen başlaması 2-3 dakika sürebilir
- Health check'ler servislerin hazır olmasını bekler
- Config Server başlamadan microservices başlamaz (fail-fast: true)

---

## 🧹 Temizlik

### Tüm Container'ları ve Volume'ları Sil
```bash
docker-compose down -v
```

### Sadece Container'ları Sil (Volume'ları koru)
```bash
docker-compose down
```

### Image'ları Sil
```bash
docker-compose down --rmi all
```

---

## 🎯 Örnek Kullanım

```bash
# 1. Tüm servisleri başlat
docker-compose up -d

# 2. Logları izle
docker-compose logs -f

# 3. Servis durumunu kontrol et
docker-compose ps

# 4. Eureka Dashboard'u aç
# http://localhost:8761

# 5. API Gateway üzerinden test et
curl http://localhost:8080/api/users

# 6. Servisleri durdur
docker-compose down
```

