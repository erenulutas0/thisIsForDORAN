# 📊 ELK Stack (Logging & Monitoring) Kılavuzu

## 📋 Genel Bakış

Bu projede **ELK Stack** (Elasticsearch, Logstash, Kibana) kullanarak centralized logging ve monitoring implementasyonu yapılmıştır.

### Ne İşe Yarar?

- ✅ **Centralized Logging**: Tüm servislerin logları tek yerde toplanır
- ✅ **Real-time Search**: Loglar gerçek zamanlı aranabilir
- ✅ **Visualization**: Kibana dashboards ile log görselleştirme
- ✅ **Performance Monitoring**: Sistem performansı izlenir
- ✅ **Error Tracking**: Hatalar takip edilir ve analiz edilir
- ✅ **Distributed Tracing Integration**: Trace ID ile log correlation

---

## 🛠️ Teknoloji

- **Elasticsearch**: Log storage ve search engine
- **Logstash**: Log collection ve processing
- **Kibana**: Log visualization ve dashboards
- **Logstash Logback Encoder**: JSON formatında log output
- **Filebeat**: Log file collection (opsiyonel)

---

## 📁 Yapılandırma Dosyaları

### Logback Configuration

Her serviste `logback-spring.xml` dosyası bulunur:

```
user-service/src/main/resources/logback-spring.xml
product-service/src/main/resources/logback-spring.xml
order-service/src/main/resources/logback-spring.xml
inventory-service/src/main/resources/logback-spring.xml
notification-service/src/main/resources/logback-spring.xml
api-gateway/src/main/resources/logback-spring.xml
```

### ELK Stack Configuration

```
elk/
  ├── logstash/
  │   ├── pipeline/
  │   │   └── logstash.conf
  │   └── config/
  │       └── logstash.yml
  └── filebeat/
      └── filebeat.yml
```

---

## 🚀 Kurulum

### 1. ELK Stack Servislerini Başlat

```bash
# Sadece ELK Stack servislerini başlat
docker-compose up -d elasticsearch logstash kibana

# Veya tüm servisleri başlat
docker-compose up -d
```

### 2. Servis Durumunu Kontrol Et

```bash
# Elasticsearch
curl http://localhost:9200/_cluster/health

# Logstash
curl http://localhost:9600/_node/stats

# Kibana
curl http://localhost:5601/api/status
```

### 3. Kibana'ya Eriş

Tarayıcıda açın: `http://localhost:5601`

---

## 📊 Kibana Setup

### 1. Index Pattern Oluştur

1. Kibana'da **Management** > **Stack Management** > **Index Patterns**'e gidin
2. **Create index pattern** butonuna tıklayın
3. Index pattern: `microservices-logs-*` yazın
4. Time field: `@timestamp` seçin
5. **Create index pattern** butonuna tıklayın

### 2. Discover'da Logları Görüntüle

1. Kibana'da **Discover** sekmesine gidin
2. Index pattern: `microservices-logs-*` seçin
3. Loglar görüntülenecektir

### 3. Dashboard Oluştur

1. **Dashboard** > **Create dashboard**'a gidin
2. Widget'lar ekleyin:
   - **Log count by service**: Her servisin log sayısı
   - **Error rate**: Hata oranı
   - **Log level distribution**: Log seviyeleri dağılımı
   - **Response time**: Response time grafikleri

---

## 🔍 Log Format

Loglar JSON formatında üretilir:

```json
{
  "@timestamp": "2024-01-15T10:30:45.123Z",
  "level": "INFO",
  "message": "User created successfully",
  "service": "user-service",
  "logger": "com.microservices.user.Service.UserService",
  "thread": "http-nio-8081-exec-1",
  "traceId": "550e8400-e29b-41d4-a716-446655440000",
  "spanId": "660e8400-e29b-41d4-a716-446655440001"
}
```

### Log Fields

- `@timestamp`: Log zamanı
- `level`: Log seviyesi (INFO, DEBUG, WARN, ERROR)
- `message`: Log mesajı
- `service`: Servis adı
- `logger`: Logger adı
- `thread`: Thread adı
- `traceId`: Distributed tracing trace ID
- `spanId`: Distributed tracing span ID

---

## 🔧 Configuration

### Logback Configuration

Her serviste `logback-spring.xml`:

```xml
<encoder class="net.logstash.logback.encoder.LogstashEncoder">
    <customFields>{"service":"user-service"}</customFields>
    <includeContext>true</includeContext>
    <includeMdcKeyName>traceId</includeMdcKeyName>
    <includeMdcKeyName>spanId</includeMdcKeyName>
</encoder>
```

### Logstash Pipeline

`elk/logstash/pipeline/logstash.conf`:

```conf
input {
  beats {
    port => 5044
  }
  tcp {
    port => 5000
    codec => json_lines
  }
}

filter {
  if [message] =~ /^\{/ {
    json {
      source => "message"
    }
  }
  date {
    match => [ "timestamp", "ISO8601" ]
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "microservices-logs-%{+YYYY.MM.dd}"
  }
}
```

---

## 📈 Kibana Queries

### Service Bazında Loglar

```
service: "user-service"
```

### Error Logları

```
level: "ERROR"
```

### Belirli Trace ID'ye Göre Loglar

```
traceId: "550e8400-e29b-41d4-a716-446655440000"
```

### Time Range

```
@timestamp: [now-1h TO now]
```

### Kombine Query

```
service: "order-service" AND level: "ERROR" AND @timestamp: [now-1h TO now]
```

---

## 🎯 Use Cases

### 1. Error Tracking

Kibana'da error loglarını filtreleyin:

```
level: "ERROR"
```

### 2. Performance Monitoring

Response time loglarını analiz edin:

```
message: "Response time"
```

### 3. Distributed Tracing

Trace ID ile tüm servislerdeki logları bulun:

```
traceId: "550e8400-e29b-41d4-a716-446655440000"
```

### 4. Service Health

Her servisin log sayısını ve error rate'ini izleyin.

---

## 🔧 Troubleshooting

### Elasticsearch Başlamıyor

```bash
# Elasticsearch loglarını kontrol et
docker logs elasticsearch

# Memory limit kontrolü
docker stats elasticsearch
```

### Logstash Logları İşlemiyor

```bash
# Logstash loglarını kontrol et
docker logs logstash

# Pipeline configuration kontrolü
docker exec logstash cat /usr/share/logstash/pipeline/logstash.conf
```

### Kibana Logları Görünmüyor

1. Index pattern'in doğru oluşturulduğundan emin olun
2. Time range'i kontrol edin
3. Elasticsearch'te index'lerin oluştuğunu kontrol edin:
   ```bash
   curl http://localhost:9200/_cat/indices
   ```

---

## 📚 Kaynaklar

- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Logstash Documentation](https://www.elastic.co/guide/en/logstash/current/index.html)
- [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Logstash Logback Encoder](https://github.com/logfellow/logstash-logback-encoder)

---

## ✅ Avantajlar

- ✅ Centralized logging (tüm loglar tek yerde)
- ✅ Real-time search ve analysis
- ✅ Log visualization (Kibana dashboards)
- ✅ Performance monitoring
- ✅ Error tracking ve alerting
- ✅ Distributed tracing integration

---

## 🎉 Sonuç

ELK Stack ile:
- ✅ Tüm servislerin logları merkezi olarak toplanır
- ✅ Loglar gerçek zamanlı aranabilir ve analiz edilir
- ✅ Kibana dashboards ile görselleştirme yapılır
- ✅ Sistem performansı ve hatalar izlenir

