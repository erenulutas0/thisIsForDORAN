-- Order Service - Test Data (Manual Insert)
-- This file contains SQL to manually insert test orders
-- Run this directly in order_db

-- Order 1
INSERT INTO orders (id, user_id, status, total_amount, shipping_address, city, zip_code, phone_number, order_date, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    '550e8400-e29b-41d4-a716-446655440002',
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

-- Order Items for Order 1 (replace product_id with actual IDs)
INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    p1.id,
    'iPhone 15 Pro Max',
    1,
    1199.99,
    1199.99
FROM orders o
CROSS JOIN (SELECT id FROM products WHERE category = 'Electronics' LIMIT 1) p1
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440002'
ORDER BY o.created_at DESC
LIMIT 1;

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    p2.id,
    'Classic White T-Shirt',
    2,
    29.99,
    59.99
FROM orders o
CROSS JOIN (SELECT id FROM products WHERE category = 'Clothing' LIMIT 1) p2
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440002'
ORDER BY o.created_at DESC
LIMIT 1;

-- Order 2
INSERT INTO orders (id, user_id, status, total_amount, shipping_address, city, zip_code, phone_number, order_date, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    '550e8400-e29b-41d4-a716-446655440003',
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

-- Order Items for Order 2
INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    p2.id,
    'Classic White T-Shirt',
    3,
    29.99,
    89.97
FROM orders o
CROSS JOIN (SELECT id FROM products WHERE category = 'Clothing' LIMIT 1) p2
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440003'
ORDER BY o.created_at DESC
LIMIT 1;

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    p3.id,
    'Smart LED Bulbs Pack 4',
    1,
    49.99,
    49.99
FROM orders o
CROSS JOIN (SELECT id FROM products WHERE category = 'Home & Garden' LIMIT 1) p3
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440003'
ORDER BY o.created_at DESC
LIMIT 1;

-- Order 3
INSERT INTO orders (id, user_id, status, total_amount, shipping_address, city, zip_code, phone_number, order_date, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    '550e8400-e29b-41d4-a716-446655440004',
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
SELECT 
    gen_random_uuid(),
    o.id,
    p1.id,
    'Sony WH-1000XM5 Headphones',
    1,
    399.99,
    399.99
FROM orders o
CROSS JOIN (SELECT id FROM products WHERE category = 'Electronics' LIMIT 1 OFFSET 3) p1
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440004'
ORDER BY o.created_at DESC
LIMIT 1;

