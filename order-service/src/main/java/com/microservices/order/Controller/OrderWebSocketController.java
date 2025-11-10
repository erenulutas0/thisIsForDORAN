package com.microservices.order.Controller;

import java.util.UUID;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.microservices.order.DTO.OrderStatusUpdate;

import lombok.RequiredArgsConstructor;

/**
 * WebSocket Controller
 * Real-time order status updates için
 * 
 * Kullanım:
 * - Client /topic/order-updates/{orderId} topic'ini subscribe eder
 * - Order status değiştiğinde bu controller mesaj gönderir
 */
@Controller
@RequiredArgsConstructor
public class OrderWebSocketController {

    private final SimpMessagingTemplate messagingTemplate;

    /**
     * Order status update mesajını broadcast et
     * 
     * @param update Order status update DTO
     * @return Update mesajı (tüm subscriber'lara gönderilir)
     */
    @MessageMapping("/order/status")
    @SendTo("/topic/order-updates")
    public OrderStatusUpdate broadcastOrderUpdate(OrderStatusUpdate update) {
        return update;
    }

    /**
     * Belirli bir sipariş için status update gönder
     * OrderService'den çağrılır
     * 
     * @param orderId Sipariş ID
     * @param update Status update DTO
     */
    public void sendOrderStatusUpdate(UUID orderId, OrderStatusUpdate update) {
        // Belirli sipariş için topic'e mesaj gönder
        // Client: /topic/order-updates/{orderId} subscribe eder
        messagingTemplate.convertAndSend("/topic/order-updates/" + orderId, update);
        
        // Ayrıca genel topic'e de gönder (tüm siparişler için)
        messagingTemplate.convertAndSend("/topic/order-updates", update);
    }

    /**
     * Kullanıcının tüm siparişleri için update gönder
     * 
     * @param userId Kullanıcı ID
     * @param update Status update DTO
     */
    public void sendUserOrderUpdate(UUID userId, OrderStatusUpdate update) {
        // Kullanıcı bazlı topic'e mesaj gönder
        // Client: /topic/user-orders/{userId} subscribe eder
        messagingTemplate.convertAndSend("/topic/user-orders/" + userId, update);
    }
}

