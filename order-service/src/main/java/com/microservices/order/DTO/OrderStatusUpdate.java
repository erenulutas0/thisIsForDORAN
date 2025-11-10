package com.microservices.order.DTO;

import java.time.LocalDateTime;
import java.util.UUID;

import com.microservices.order.Model.OrderStatus;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Order Status Update DTO
 * WebSocket üzerinden gönderilecek sipariş durumu güncelleme mesajı
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderStatusUpdate {
    private UUID orderId;
    private OrderStatus oldStatus;
    private OrderStatus newStatus;
    private String message;
    private LocalDateTime timestamp;
    private UUID userId;  // Hangi kullanıcının siparişi
    
    public OrderStatusUpdate(UUID orderId, OrderStatus oldStatus, OrderStatus newStatus, UUID userId) {
        this.orderId = orderId;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.userId = userId;
        this.timestamp = LocalDateTime.now();
        this.message = String.format("Order status changed from %s to %s", oldStatus, newStatus);
    }
}

