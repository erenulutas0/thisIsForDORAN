package com.microservices.order.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

/**
 * WebSocket Configuration
 * Real-time order tracking için WebSocket yapılandırması
 * 
 * STOMP (Simple Text Oriented Messaging Protocol) kullanıyoruz
 * - Client'lar /ws endpoint'ine bağlanır
 * - Server /topic/order-updates/{orderId} topic'ine mesaj gönderir
 * - Client'lar bu topic'i subscribe eder
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    /**
     * Message Broker Configuration
     * - /topic: Broadcast messages (birden fazla client'a)
     * - /queue: Point-to-point messages (tek client'a)
     */
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Enable simple broker (in-memory message broker)
        // Production'da RabbitMQ veya Redis kullanılabilir
        config.enableSimpleBroker("/topic", "/queue");
        
        // Application destination prefix
        // Client'lar /app prefix'i ile mesaj gönderir
        config.setApplicationDestinationPrefixes("/app");
    }

    /**
     * STOMP Endpoint Registration
     * Client'lar bu endpoint'e bağlanır
     */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // WebSocket endpoint
        // Client: ws://localhost:8083/ws
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")  // CORS - Production'da specific domain'ler belirtilmeli
                .withSockJS();  // SockJS fallback (WebSocket desteklemeyen browser'lar için)
    }
}

