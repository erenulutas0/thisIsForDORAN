-- User Service - Extended Test Users
-- Migration: V2__Insert_test_users.sql
-- Description: Inserts 20 sample users for testing

-- Password for all users: Admin123! (BCrypt hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy)

INSERT INTO users (id, username, email, password, first_name, last_name, phone, address, city, state, zip)
VALUES 
    -- Admin Users
    ('550e8400-e29b-41d4-a716-446655440001', 'admin', 'admin@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Admin', 'User', '5551234567', '123 Admin Street', 'Istanbul', 'IST', '34000'),
    
    -- Regular Customers
    ('550e8400-e29b-41d4-a716-446655440002', 'john_doe', 'john.doe@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'John', 'Doe', '5552345678', '456 Main Avenue', 'Ankara', 'ANK', '06000'),
    ('550e8400-e29b-41d4-a716-446655440003', 'jane_smith', 'jane.smith@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jane', 'Smith', '5553456789', '789 Oak Boulevard', 'Izmir', 'IZM', '35000'),
    ('550e8400-e29b-41d4-a716-446655440004', 'premium_user', 'premium@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Premium', 'Customer', '5554567890', '321 Premium Lane', 'Antalya', 'ANT', '07000'),
    ('550e8400-e29b-41d4-a716-446655440005', 'test_user', 'test@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Test', 'User', '5555678901', '999 Test Road', 'Bursa', 'BRS', '16000'),
    
    -- Additional Customers
    ('550e8400-e29b-41d4-a716-446655440006', 'alice_williams', 'alice.williams@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Alice', 'Williams', '5556789012', '111 Elm Street', 'Istanbul', 'IST', '34010'),
    ('550e8400-e29b-41d4-a716-446655440007', 'bob_johnson', 'bob.johnson@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Bob', 'Johnson', '5557890123', '222 Pine Avenue', 'Ankara', 'ANK', '06010'),
    ('550e8400-e29b-41d4-a716-446655440008', 'charlie_brown', 'charlie.brown@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Charlie', 'Brown', '5558901234', '333 Maple Drive', 'Izmir', 'IZM', '35010'),
    ('550e8400-e29b-41d4-a716-446655440009', 'diana_prince', 'diana.prince@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Diana', 'Prince', '5559012345', '444 Cedar Lane', 'Antalya', 'ANT', '07010'),
    ('550e8400-e29b-41d4-a716-446655440010', 'emma_watson', 'emma.watson@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Emma', 'Watson', '5550123456', '555 Birch Road', 'Bursa', 'BRS', '16010'),
    
    -- More Customers
    ('550e8400-e29b-41d4-a716-446655440011', 'frank_miller', 'frank.miller@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Frank', 'Miller', '5551234568', '666 Spruce Street', 'Istanbul', 'IST', '34020'),
    ('550e8400-e29b-41d4-a716-446655440012', 'grace_kelly', 'grace.kelly@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Grace', 'Kelly', '5552345679', '777 Willow Way', 'Ankara', 'ANK', '06020'),
    ('550e8400-e29b-41d4-a716-446655440013', 'henry_ford', 'henry.ford@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Henry', 'Ford', '5553456780', '888 Ash Boulevard', 'Izmir', 'IZM', '35020'),
    ('550e8400-e29b-41d4-a716-446655440014', 'isabella_swan', 'isabella.swan@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Isabella', 'Swan', '5554567891', '999 Poplar Drive', 'Antalya', 'ANT', '07020'),
    ('550e8400-e29b-41d4-a716-446655440015', 'jack_sparrow', 'jack.sparrow@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jack', 'Sparrow', '5555678902', '1010 Oak Street', 'Bursa', 'BRS', '16020'),
    
    -- Final Customers
    ('550e8400-e29b-41d4-a716-446655440016', 'kate_bishop', 'kate.bishop@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Kate', 'Bishop', '5556789013', '1111 Pine Avenue', 'Istanbul', 'IST', '34030'),
    ('550e8400-e29b-41d4-a716-446655440017', 'luke_skywalker', 'luke.skywalker@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Luke', 'Skywalker', '5557890124', '1212 Maple Drive', 'Ankara', 'ANK', '06030'),
    ('550e8400-e29b-41d4-a716-446655440018', 'maria_garcia', 'maria.garcia@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Maria', 'Garcia', '5558901235', '1313 Cedar Lane', 'Izmir', 'IZM', '35030'),
    ('550e8400-e29b-41d4-a716-446655440019', 'noah_taylor', 'noah.taylor@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Noah', 'Taylor', '5559012346', '1414 Birch Road', 'Antalya', 'ANT', '07030'),
    ('550e8400-e29b-41d4-a716-446655440020', 'olivia_martinez', 'olivia.martinez@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Olivia', 'Martinez', '5550123457', '1515 Spruce Street', 'Bursa', 'BRS', '16030')
ON CONFLICT (id) DO NOTHING;
