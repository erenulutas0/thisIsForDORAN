-- Test Users Insert Script
INSERT INTO users (id, username, email, password, first_name, last_name, phone, address, city, state, zip)
VALUES 
    ('550e8400-e29b-41d4-a716-446655440001', 'admin', 'admin@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Admin', 'User', '5551234567', '123 Admin Street', 'Istanbul', 'IST', '34000'),
    ('550e8400-e29b-41d4-a716-446655440002', 'john_doe', 'john.doe@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'John', 'Doe', '5552345678', '456 Main Avenue', 'Ankara', 'ANK', '06000'),
    ('550e8400-e29b-41d4-a716-446655440003', 'jane_smith', 'jane.smith@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jane', 'Smith', '5553456789', '789 Oak Boulevard', 'Izmir', 'IZM', '35000'),
    ('550e8400-e29b-41d4-a716-446655440004', 'premium_user', 'premium@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Premium', 'Customer', '5554567890', '321 Premium Lane', 'Antalya', 'ANT', '07000'),
    ('550e8400-e29b-41d4-a716-446655440005', 'test_user', 'test@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Test', 'User', '5555678901', '999 Test Road', 'Bursa', 'BRS', '16000')
ON CONFLICT (id) DO NOTHING;

