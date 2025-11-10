# 🚀 Redis Caching Kılavuzu

## 📋 Genel Bakış

Bu projede **Spring Cache abstraction** ile **Redis** kullanarak distributed caching implementasyonu yapılmıştır.

### Ne İşe Yarar?

- ✅ **Database Load Reduction**: Database'e daha az query (cache'den okuma)
- ✅ **Response Time Improvement**: Cache'den okuma çok daha hızlı
- ✅ **Scalability**: Distributed cache (tüm servisler aynı cache'i paylaşır)
- ✅ **Cost Reduction**: Database load azalır, daha az kaynak kullanılır

---

## 🛠️ Teknoloji

- **Spring Cache**: Cache abstraction layer
- **Redis**: Distributed cache provider
- **Spring Data Redis**: Redis integration

---

## 📁 Cache Configuration

Her serviste `RedisCacheConfig.java` dosyası bulunur:

```
user-service/src/main/java/com/microservices/user/Config/RedisCacheConfig.java
product-service/src/main/java/com/microservices/product/Config/RedisCacheConfig.java
order-service/src/main/java/com/microservices/order/Config/RedisCacheConfig.java
inventory-service/src/main/java/com/microservices/inventory/Config/RedisCacheConfig.java
notification-service/src/main/java/com/microservices/notification/Config/RedisCacheConfig.java
```

### Cache TTL (Time To Live)

Her servis için farklı TTL değerleri:

- **User Service**: 10 dakika
- **Product Service**: 15 dakika (ürünler daha az değişir)
- **Order Service**: 5 dakika (siparişler daha sık değişir)
- **Inventory Service**: 2 dakika (stok bilgileri çok sık değişir)
- **Notification Service**: 10 dakika

---

## 🎯 Cache Annotations

### @Cacheable

Method sonucunu cache'ler. İlk çağrıda database'den okur, sonraki çağrılarda cache'den döner.

```java
@Cacheable(value = "users", key = "#id.toString()")
public User getUserById(UUID id) {
    return userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
}
```

**Örnekler:**
- `@Cacheable(value = "users", key = "'all'")` - Tüm kullanıcılar listesi
- `@Cacheable(value = "products", key = "#productId.toString()")` - Tek ürün
- `@Cacheable(value = "products", key = "'category:' + #category")` - Kategoriye göre ürünler

### @CacheEvict

Cache'i temizler. Create, update, delete işlemlerinde kullanılır.

```java
@CacheEvict(value = "users", key = "#id.toString()")
public void deleteUser(UUID id) {
    userRepository.deleteById(id);
}
```

**Örnekler:**
- `@CacheEvict(value = "users", key = "#id.toString()")` - Tek bir cache entry'sini temizle
- `@CacheEvict(value = "products", allEntries = true)` - Tüm cache'i temizle
- `@CacheEvict(value = "orders", key = "'user:' + #order.userId.toString()")` - Kullanıcının sipariş listesi cache'ini temizle

### @CachePut

Cache'i günceller. Update işlemlerinde kullanılabilir (bu projede kullanılmadı).

```java
@CachePut(value = "users", key = "#user.id.toString()")
public User updateUser(User user) {
    return userRepository.save(user);
}
```

---

## 📊 Cache Keys

Cache key'leri şu formatta oluşturulur:

```
{service-name}:{cache-name}::{key}
```

**Örnekler:**
- `user-service:users::all` - Tüm kullanıcılar
- `user-service:users::550e8400-e29b-41d4-a716-446655440000` - Tek kullanıcı
- `product-service:products::category:ELECTRONICS` - Kategoriye göre ürünler
- `inventory-service:inventories::product:550e8400-e29b-41d4-a716-446655440000` - Ürün stoku

---

## 🔧 Configuration

### Config Repository (`C:\Users\pc\config-repo\application.yaml`)

```yaml
# Redis Cache Configuration
spring:
  cache:
    type: redis  # Redis'i cache provider olarak kullan
  data:
    redis:
      host: localhost
      port: 6379
      timeout: 2000ms
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 0
```

### Service-Specific Configuration

Her serviste `RedisCacheConfig.java`:

```java
@Configuration
@EnableCaching
public class RedisCacheConfig {
    @Bean
    public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(10))  // TTL
                .serializeKeysWith(RedisSerializationContext.SerializationPair
                    .fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair
                    .fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();  // Null değerleri cache'leme

        return RedisCacheManager.builder(redisConnectionFactory)
                .cacheDefaults(config)
                .build();
    }
}
```

---

## 🚀 Kullanım Örnekleri

### User Service

```java
// Cache'den oku
@Cacheable(value = "users", key = "#id.toString()")
public User getUserById(UUID id) { ... }

// Cache'i temizle
@CacheEvict(value = "users", key = "#id.toString()")
public void deleteUser(UUID id) { ... }
```

### Product Service

```java
// Kategoriye göre cache'le
@Cacheable(value = "products", key = "'category:' + #category")
public List<Product> getProductsByCategory(String category) { ... }

// Yeni ürün eklenince tüm cache'i temizle
@CacheEvict(value = "products", allEntries = true)
public Product createProduct(Product product) { ... }
```

### Inventory Service

```java
// Ürün stok bilgisini cache'le (kısa TTL: 2 dakika)
@Cacheable(value = "inventories", key = "'product:' + #productId.toString()")
public Inventory getInventoryByProductId(UUID productId) { ... }
```

---

## 🔍 Cache Monitoring

### Redis CLI ile Kontrol

```bash
# Redis'e bağlan
docker exec -it redis redis-cli

# Tüm key'leri listele
KEYS *

# Belirli bir pattern'e göre key'leri listele
KEYS user-service:users::*

# Bir key'in değerini oku
GET user-service:users::550e8400-e29b-41d4-a716-446655440000

# TTL (Time To Live) kontrol et
TTL user-service:users::550e8400-e29b-41d4-a716-446655440000

# Cache'i temizle
DEL user-service:users::550e8400-e29b-41d4-a716-446655440000

# Tüm cache'i temizle (dikkatli kullanın!)
FLUSHALL
```

### Actuator Metrics

Cache metrics'leri Actuator ile görüntülenebilir:

```
GET http://localhost:8081/actuator/metrics/cache.gets
GET http://localhost:8081/actuator/metrics/cache.puts
GET http://localhost:8081/actuator/metrics/cache.evictions
```

---

## ⚠️ Best Practices

### 1. Cache Key Strategy

- **Unique Keys**: Her cache entry için unique key kullanın
- **Descriptive Keys**: Key'ler açıklayıcı olsun (`'category:' + category`)
- **Consistent Format**: Tüm servislerde aynı format kullanın

### 2. Cache Eviction Strategy

- **Create**: İlgili cache'leri temizleyin (örn: `allEntries = true` veya specific key)
- **Update**: İlgili cache entry'sini temizleyin
- **Delete**: İlgili cache entry'sini temizleyin

### 3. TTL (Time To Live)

- **Sık Değişen Data**: Kısa TTL (örn: Inventory: 2 dakika)
- **Nadiren Değişen Data**: Uzun TTL (örn: Product: 15 dakika)
- **Production**: TTL değerlerini production'da optimize edin

### 4. Null Values

- **disableCachingNullValues()**: Null değerleri cache'lemeyin
- **Exception Handling**: Exception'lar cache'lenmez (zaten cache'lenmemeli)

### 5. Cache Warming

İlk başlatmada cache'i doldurmak için:

```java
@PostConstruct
public void warmCache() {
    // Popüler verileri cache'e yükle
    getAllUsers();
    getActiveProducts();
}
```

---

## 🔧 Troubleshooting

### Cache Çalışmıyor

1. **Redis Bağlantısı Kontrolü:**
   ```bash
   docker ps | grep redis
   docker exec redis redis-cli ping  # PONG dönmeli
   ```

2. **Configuration Kontrolü:**
   - `spring.cache.type=redis` ayarı var mı?
   - `@EnableCaching` annotation'ı var mı?
   - `RedisCacheConfig` bean'i oluşturulmuş mu?

3. **Log Kontrolü:**
   ```
   Cache hit/miss log'larını kontrol edin
   ```

### Cache Stale Data Gösteriyor

- **Cache Eviction**: Update/delete işlemlerinde cache'i temizlediğinizden emin olun
- **TTL**: TTL değerlerini kontrol edin
- **Manual Eviction**: Gerekirse manuel olarak cache'i temizleyin

### Memory Kullanımı Yüksek

- **TTL**: TTL değerlerini düşürün
- **Cache Size**: Redis maxmemory ayarını kontrol edin
- **Eviction Policy**: Redis eviction policy'sini ayarlayın (LRU, LFU, vb.)

---

## 📚 Kaynaklar

- [Spring Cache Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/integration.html#cache)
- [Spring Data Redis Documentation](https://docs.spring.io/spring-data/redis/docs/current/reference/html/)
- [Redis Documentation](https://redis.io/documentation)

---

## ✅ Avantajlar

- ✅ Database load azalır
- ✅ Response time iyileşir
- ✅ Scalability artar (distributed cache)
- ✅ Cost reduction (daha az database kaynağı)
- ✅ High availability (Redis cluster ile)

---

## 🎉 Sonuç

Redis Caching ile:
- ✅ Database query'leri azalır
- ✅ Response time iyileşir
- ✅ Sistem daha scalable olur
- ✅ Cost reduction sağlanır

