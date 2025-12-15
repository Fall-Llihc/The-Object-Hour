-- Sample Data untuk Testing The Object Hour
-- Run this SQL in your Supabase SQL Editor

-- 1. Create Admin User (password: admin123)
INSERT INTO users (username, password_hash, name, role) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Admin User', 'ADMIN');

-- 2. Create Customer User (password: customer123)
INSERT INTO users (username, password_hash, name, role) VALUES
('customer', '8bdb4b16f046c7faebc7128e5e5f8de0d8d0f5e99be1e5d5b6a4f2a0f2c7a8c1', 'John Doe', 'CUSTOMER'),
('jane', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Jane Smith', 'CUSTOMER');

-- 3. Insert Sample Products (Premium Watches)
INSERT INTO products (name, brand, type, strap_material, price, stock, is_active) VALUES
-- Rolex Collection
('Rolex Submariner Date', 'Rolex', 'ANALOG', 'Stainless Steel', 95000000, 5, true),
('Rolex Datejust 41', 'Rolex', 'ANALOG', 'Oyster Steel', 125000000, 3, true),
('Rolex GMT-Master II', 'Rolex', 'ANALOG', 'Jubilee Bracelet', 155000000, 2, true),
('Rolex Daytona', 'Rolex', 'ANALOG', 'Oysterflex', 185000000, 1, true),

-- Omega Collection
('Omega Speedmaster Professional', 'Omega', 'ANALOG', 'Stainless Steel', 75000000, 8, true),
('Omega Seamaster Aqua Terra', 'Omega', 'ANALOG', 'Leather', 65000000, 10, true),
('Omega Constellation', 'Omega', 'ANALOG', 'Gold/Steel', 85000000, 6, true),

-- Seiko Collection
('Seiko Presage Cocktail Time', 'Seiko', 'ANALOG', 'Leather', 4500000, 15, true),
('Seiko Prospex Diver', 'Seiko', 'ANALOG', 'Silicone', 6500000, 12, true),
('Seiko 5 Sports', 'Seiko', 'ANALOG', 'NATO Strap', 3200000, 20, true),

-- Casio G-Shock Collection  
('Casio G-Shock GA-2100', 'Casio', 'DIGITAL', 'Resin', 1850000, 25, true),
('Casio G-Shock MTG-B2000', 'Casio', 'DIGITAL', 'Metal', 12500000, 7, true),
('Casio G-Shock Mudmaster', 'Casio', 'DIGITAL', 'Carbon Fiber', 9500000, 10, true),

-- Apple Watch Collection
('Apple Watch Series 9 GPS', 'Apple', 'SMARTWATCH', 'Sport Band', 6499000, 30, true),
('Apple Watch Ultra 2', 'Apple', 'SMARTWATCH', 'Alpine Loop', 13999000, 15, true),
('Apple Watch Hermes Series 9', 'Apple', 'SMARTWATCH', 'Leather', 24999000, 5, true),

-- Samsung Galaxy Watch
('Samsung Galaxy Watch 6 Classic', 'Samsung', 'SMARTWATCH', 'Stainless Steel', 5499000, 20, true),
('Samsung Galaxy Watch 6', 'Samsung', 'SMARTWATCH', 'Silicone', 3999000, 25, true),

-- Tag Heuer Collection
('Tag Heuer Carrera Chronograph', 'Tag Heuer', 'ANALOG', 'Stainless Steel', 45000000, 4, true),
('Tag Heuer Monaco', 'Tag Heuer', 'ANALOG', 'Leather', 75000000, 2, true),

-- Citizen Collection
('Citizen Eco-Drive Promaster', 'Citizen', 'ANALOG', 'Titanium', 8500000, 12, true),
('Citizen Chronomaster', 'Citizen', 'ANALOG', 'Stainless Steel', 15000000, 6, true),

-- Tissot Collection
('Tissot PRX Powermatic 80', 'Tissot', 'ANALOG', 'Stainless Steel', 9500000, 10, true),
('Tissot Gentleman Automatic', 'Tissot', 'ANALOG', 'Leather', 11000000, 8, true),

-- Garmin Smartwatch
('Garmin Fenix 7X Solar', 'Garmin', 'SMARTWATCH', 'Silicone', 14500000, 10, true),
('Garmin Epix Pro', 'Garmin', 'SMARTWATCH', 'Titanium', 18500000, 5, true);

-- Verify data
SELECT 'Total Products:', COUNT(*) FROM products;
SELECT 'Total Users:', COUNT(*) FROM users;
