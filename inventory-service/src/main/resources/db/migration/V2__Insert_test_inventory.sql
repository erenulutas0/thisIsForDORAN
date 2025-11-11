-- Inventory Service - Test Data
-- Migration: V2__Insert_test_inventory.sql
-- Description: Inserts inventory records for products
-- Note: Product IDs are fetched from product_db, but this migration runs in inventory_db
-- For now, we'll insert inventory records that will be synced when products are created

-- Insert inventory records for first 50 products (sample)
-- In production, inventory should be created automatically when products are created
INSERT INTO inventory (id, product_id, quantity, reserved_quantity, min_stock_level, max_stock_level, status, location, created_at, updated_at)
VALUES
    -- Sample inventory records (product_ids will be synced via service)
    -- These are placeholder records that should match product IDs from product_db
    (gen_random_uuid(), gen_random_uuid(), 50, 0, 10, 100, 'IN_STOCK', 'Warehouse A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 30, 0, 5, 60, 'IN_STOCK', 'Warehouse B', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 75, 0, 15, 150, 'IN_STOCK', 'Warehouse A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 200, 0, 20, 400, 'IN_STOCK', 'Warehouse C', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 45, 0, 5, 90, 'IN_STOCK', 'Warehouse B', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 120, 0, 10, 240, 'IN_STOCK', 'Warehouse A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 80, 0, 8, 160, 'IN_STOCK', 'Warehouse C', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 60, 0, 6, 120, 'IN_STOCK', 'Warehouse B', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 25, 0, 3, 50, 'LOW_STOCK', 'Warehouse A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 15, 0, 2, 30, 'LOW_STOCK', 'Warehouse C', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (product_id) DO NOTHING;
