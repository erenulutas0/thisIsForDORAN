-- Order Service - Test Data
-- Migration: V2__Insert_test_orders.sql
-- Description: Inserts sample orders for test users

-- Note: User IDs and Product IDs should match actual IDs from user_db and product_db
-- For testing, we'll use placeholder UUIDs that should be replaced with actual IDs

-- Order 1 - User: john_doe (550e8400-e29b-41d4-a716-446655440002)
-- Using placeholder product IDs - replace with actual product IDs from product_db
DO $$
DECLARE
    order1_id UUID := gen_random_uuid();
    order2_id UUID := gen_random_uuid();
    order3_id UUID := gen_random_uuid();
    user1_id UUID := '550e8400-e29b-41d4-a716-446655440002';
    user2_id UUID := '550e8400-e29b-41d4-a716-446655440003';
    user3_id UUID := '550e8400-e29b-41d4-a716-446655440004';
    product1_id UUID;
    product2_id UUID;
    product3_id UUID;
BEGIN
    -- Get product IDs from product_db (we'll use first available products)
    -- Note: In a real scenario, these would be fetched via service call
    SELECT id INTO product1_id FROM products WHERE category = 'Electronics' LIMIT 1;
    SELECT id INTO product2_id FROM products WHERE category = 'Clothing' LIMIT 1;
    SELECT id INTO product3_id FROM products WHERE category = 'Home & Garden' LIMIT 1;
    
    -- If products don't exist, use random UUIDs (for testing)
    IF product1_id IS NULL THEN product1_id := gen_random_uuid(); END IF;
    IF product2_id IS NULL THEN product2_id := gen_random_uuid(); END IF;
    IF product3_id IS NULL THEN product3_id := gen_random_uuid(); END IF;
    
    -- Order 1
    INSERT INTO orders (id, user_id, status, total_amount, shipping_address, city, zip_code, phone_number, order_date, created_at, updated_at)
    VALUES (
        order1_id,
        user1_id,
        'DELIVERED',
        1299.98,
        '456 Main Avenue',
        'Ankara',
        '06000',
        '5552345678',
        CURRENT_TIMESTAMP - INTERVAL '5 days',
        CURRENT_TIMESTAMP - INTERVAL '5 days',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    );
    
    INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
    VALUES 
        (gen_random_uuid(), order1_id, product1_id, 'iPhone 15 Pro Max', 1, 1199.99, 1199.99),
        (gen_random_uuid(), order1_id, product2_id, 'Classic White T-Shirt', 2, 29.99, 59.99);
    
    -- Order 2
    INSERT INTO orders (id, user_id, status, total_amount, shipping_address, city, zip_code, phone_number, order_date, created_at, updated_at)
    VALUES (
        order2_id,
        user2_id,
        'SHIPPED',
        179.97,
        '789 Oak Boulevard',
        'Izmir',
        '35000',
        '5553456789',
        CURRENT_TIMESTAMP - INTERVAL '3 days',
        CURRENT_TIMESTAMP - INTERVAL '3 days',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    );
    
    INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
    VALUES 
        (gen_random_uuid(), order2_id, product2_id, 'Classic White T-Shirt', 3, 29.99, 89.97),
        (gen_random_uuid(), order2_id, product3_id, 'Smart LED Bulbs Pack 4', 1, 49.99, 49.99),
        (gen_random_uuid(), order2_id, product3_id, 'Indoor Plant Set 3', 1, 39.99, 39.99);
    
    -- Order 3
    INSERT INTO orders (id, user_id, status, total_amount, shipping_address, city, zip_code, phone_number, order_date, created_at, updated_at)
    VALUES (
        order3_id,
        user3_id,
        'PENDING',
        399.99,
        '321 Premium Lane',
        'Antalya',
        '07000',
        '5554567890',
        CURRENT_TIMESTAMP - INTERVAL '1 day',
        CURRENT_TIMESTAMP - INTERVAL '1 day',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    );
    
    INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
    VALUES 
        (gen_random_uuid(), order3_id, product1_id, 'Sony WH-1000XM5 Headphones', 1, 399.99, 399.99);
END $$;

