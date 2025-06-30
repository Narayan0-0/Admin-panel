-- CarryClub Database Schema
-- Database: carry_club

-- Create categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status TINYINT(1) DEFAULT 1,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    image VARCHAR(255),
    status TINYINT(1) DEFAULT 1,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'customer') DEFAULT 'customer',
    status TINYINT(1) DEFAULT 1,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

-- Insert sample categories
INSERT INTO categories (name, description, status) VALUES
('Tote Bags', 'Spacious and stylish tote bags for everyday use', 1),
('Crossbody Bags', 'Convenient crossbody bags for hands-free carrying', 1),
('Clutches', 'Elegant clutches for special occasions', 1),
('Backpacks', 'Fashionable backpacks for modern lifestyle', 1),
('Shoulder Bags', 'Classic shoulder bags for professional and casual wear', 1),
('Evening Bags', 'Sophisticated bags for formal events', 1),
('Travel Bags', 'Durable bags for travel and adventure', 1),
('Work Bags', 'Professional bags for office and business', 1);

-- Insert sample users
INSERT INTO users (name, email, password, role, status) VALUES
('Admin User', 'admin@carryclub.com', 'admin123', 'admin', 1),
('John Doe', 'user@carryclub.com', 'user123', 'customer', 1),
('Jane Smith', 'jane@example.com', 'password123', 'customer', 1),
('Mike Johnson', 'mike@example.com', 'password123', 'customer', 1),
('Sarah Wilson', 'sarah@example.com', 'password123', 'customer', 1),
('David Brown', 'david@example.com', 'password123', 'customer', 1),
('Emily Davis', 'emily@example.com', 'password123', 'customer', 1),
('Chris Miller', 'chris@example.com', 'password123', 'customer', 1);

-- Insert sample products
INSERT INTO products (name, description, price, category_id, image, status) VALUES
('Elegant Tote', 'A spacious and stylish tote bag perfect for everyday use. Made from premium leather with a cotton lining.', 149.99, 1, 'images/tote.webp', 1),
('Crossbody Classic', 'A versatile crossbody bag that transitions seamlessly from day to night. Features multiple compartments.', 129.99, 2, 'images/handbag.webp', 1),
('Mini Clutch', 'An elegant clutch for special occasions. Includes a detachable chain strap and secure magnetic closure.', 89.99, 3, 'images/mini.webp', 1),
('Professional Backpack', 'A sleek backpack designed for the modern professional. Features laptop compartment and multiple pockets.', 199.99, 4, 'images/c1.webp', 1),
('Casual Shoulder Bag', 'Perfect for daily use with adjustable strap and multiple compartments for organization.', 119.99, 5, 'images/c2.webp', 1),
('Evening Clutch', 'Sophisticated clutch perfect for formal events and evening occasions.', 79.99, 3, 'images/c3.webp', 1),
('Large Tote', 'Extra spacious tote bag ideal for shopping and travel. Durable and stylish.', 169.99, 1, 'images/c4.webp', 1),
('Compact Crossbody', 'Small and convenient crossbody bag for essentials. Perfect for hands-free activities.', 99.99, 2, 'images/c5.webp', 1),
('Designer Evening Bag', 'Luxurious evening bag with crystal embellishments and silk lining.', 299.99, 6, 'images/c6.webp', 1),
('Travel Duffel', 'Large capacity travel bag with multiple compartments and durable construction.', 249.99, 7, 'images/tote.webp', 1),
('Executive Briefcase', 'Professional leather briefcase with laptop compartment and document organizer.', 349.99, 8, 'images/travel.webp', 1),
('Vintage Crossbody', 'Retro-style crossbody bag with vintage hardware and distressed leather finish.', 159.99, 2, 'images/mini.webp', 1);

-- Insert sample orders
INSERT INTO orders (user_id, total_amount, status) VALUES
(2, 149.99, 'delivered'),
(3, 219.98, 'shipped'),
(4, 89.99, 'processing'),
(2, 329.97, 'pending'),
(3, 199.99, 'delivered'),
(5, 459.98, 'shipped'),
(6, 129.99, 'processing'),
(7, 249.99, 'pending'),
(8, 179.98, 'delivered'),
(4, 299.99, 'shipped'),
(5, 119.99, 'processing'),
(6, 349.99, 'pending'),
(7, 89.99, 'delivered'),
(8, 169.99, 'shipped'),
(2, 399.98, 'processing');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 149.99),
(2, 2, 1, 129.99),
(2, 3, 1, 89.99),
(3, 3, 1, 89.99),
(4, 1, 1, 149.99),
(4, 4, 1, 199.99),
(5, 4, 1, 199.99),
(6, 9, 1, 299.99),
(6, 7, 1, 169.99),
(7, 2, 1, 129.99),
(8, 10, 1, 249.99),
(9, 5, 1, 119.99),
(9, 6, 1, 79.99),
(10, 9, 1, 299.99),
(11, 5, 1, 119.99),
(12, 11, 1, 349.99),
(13, 3, 1, 89.99),
(14, 7, 1, 169.99),
(15, 1, 2, 149.99),
(15, 8, 1, 99.99);
