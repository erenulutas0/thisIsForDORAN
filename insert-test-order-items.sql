-- Order Items - Manual Insert
-- Product IDs from product_db:
-- Electronics: 69641955-6041-4af4-8f7b-8a403bedf8b3
-- Clothing: fc5a6da4-9fd0-4991-a649-afef6649b8cd
-- Home & Garden: cc17ccf9-2f31-471f-93a9-3be13bd5dc1c

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    '69641955-6041-4af4-8f7b-8a403bedf8b3'::uuid,
    'iPhone 15 Pro Max',
    1,
    1199.99,
    1199.99
FROM orders o
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440002'
ORDER BY o.created_at DESC
LIMIT 1;

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    'fc5a6da4-9fd0-4991-a649-afef6649b8cd'::uuid,
    'Classic White T-Shirt',
    2,
    29.99,
    59.99
FROM orders o
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440002'
ORDER BY o.created_at DESC
LIMIT 1;

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    'fc5a6da4-9fd0-4991-a649-afef6649b8cd'::uuid,
    'Classic White T-Shirt',
    3,
    29.99,
    89.97
FROM orders o
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440003'
ORDER BY o.created_at DESC
LIMIT 1;

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    'cc17ccf9-2f31-471f-93a9-3be13bd5dc1c'::uuid,
    'Smart LED Bulbs Pack 4',
    1,
    49.99,
    49.99
FROM orders o
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440003'
ORDER BY o.created_at DESC
LIMIT 1;

INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, subtotal)
SELECT 
    gen_random_uuid(),
    o.id,
    '69641955-6041-4af4-8f7b-8a403bedf8b3'::uuid,
    'Sony WH-1000XM5 Headphones',
    1,
    399.99,
    399.99
FROM orders o
WHERE o.user_id = '550e8400-e29b-41d4-a716-446655440004'
ORDER BY o.created_at DESC
LIMIT 1;

