-- Notification Service - Test Data
-- Migration: V2__Insert_test_notifications.sql
-- Description: Inserts sample notifications for test users

-- Using known user IDs from user_db
INSERT INTO notifications (id, recipient, type, subject, message, status, user_id, related_entity_type, created_at, updated_at, sent_at, delivered_at)
VALUES 
    -- Order confirmation notifications
    (gen_random_uuid(), 'john.doe@test.com', 'EMAIL', 'Order Confirmation', 'Your order #12345 has been confirmed and is being processed.', 'DELIVERED', '550e8400-e29b-41d4-a716-446655440002', 'ORDER', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (gen_random_uuid(), 'jane.smith@test.com', 'EMAIL', 'Order Shipped', 'Your order #12346 has been shipped and is on its way!', 'DELIVERED', '550e8400-e29b-41d4-a716-446655440003', 'ORDER', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    (gen_random_uuid(), 'premium@test.com', 'EMAIL', 'Order Pending', 'Your order #12347 is pending payment confirmation.', 'PENDING', '550e8400-e29b-41d4-a716-446655440004', 'ORDER', CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '1 day', NULL, NULL),
    
    -- Promotional notifications
    (gen_random_uuid(), 'john.doe@test.com', 'EMAIL', 'Special Offer', 'Get 20% off on all Electronics! Limited time offer.', 'DELIVERED', '550e8400-e29b-41d4-a716-446655440002', NULL, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    (gen_random_uuid(), 'jane.smith@test.com', 'SMS', 'Flash Sale', 'Flash Sale: 50% off on selected items. Shop now!', 'SENT', '550e8400-e29b-41d4-a716-446655440003', NULL, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '1 day', NULL),
    (gen_random_uuid(), 'premium@test.com', 'PUSH', 'New Arrivals', 'Check out our new product arrivals!', 'DELIVERED', '550e8400-e29b-41d4-a716-446655440004', NULL, CURRENT_TIMESTAMP - INTERVAL '6 hours', CURRENT_TIMESTAMP - INTERVAL '6 hours', CURRENT_TIMESTAMP - INTERVAL '6 hours', CURRENT_TIMESTAMP - INTERVAL '5 hours'),
    
    -- Account notifications
    (gen_random_uuid(), 'john.doe@test.com', 'EMAIL', 'Welcome!', 'Welcome to our e-commerce platform! Enjoy shopping.', 'DELIVERED', '550e8400-e29b-41d4-a716-446655440002', NULL, CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (gen_random_uuid(), 'jane.smith@test.com', 'EMAIL', 'Password Reset', 'Your password has been successfully reset.', 'DELIVERED', '550e8400-e29b-41d4-a716-446655440003', NULL, CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days');

