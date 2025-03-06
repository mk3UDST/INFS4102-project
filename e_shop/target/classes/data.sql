-- Insert categories
INSERT INTO categories (id, name, description) VALUES 
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Fashion items and accessories'),
(3, 'Books', 'Books and e-books');

-- Insert products
INSERT INTO products (id, name, description, price, image_url, stock_quantity, category_id) VALUES 
(1, 'MacBook Pro', '13-inch, Apple M1 chip with 8‑core CPU', 1299.99, 'https://example.com/macbook.jpg', 50, 1),
(2, 'iPhone 13', '6.1-inch Super Retina XDR display', 799.99, 'https://example.com/iphone.jpg', 100, 1),
(3, 'Cotton T-Shirt', '100% cotton, comfortable fit', 19.99, 'https://example.com/tshirt.jpg', 200, 2),
(4, 'Slim Fit Jeans', 'Blue denim, slim fit design', 49.99, 'https://example.com/jeans.jpg', 150, 2),
(5, 'Spring Boot in Action', 'Learn Spring Boot development', 39.99, 'https://example.com/springbook.jpg', 75, 3);

-- Insert users
INSERT INTO users (id, username, email, address) VALUES 
(1, 'john_doe', 'john@example.com', '123 Main St, City, State'),
(2, 'jane_smith', 'jane@example.com', '456 Oak Ave, City, State');

-- Insert cart for user1
INSERT INTO carts (id, user_id, created_at, updated_at) VALUES 
(1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert cart items
INSERT INTO cart_items (id, cart_id, product_id, quantity) VALUES 
(1, 1, 1, 1),  -- MacBook in John's cart
(2, 1, 3, 2);  -- 2 T-shirts in John's cart

-- Insert order for user2
INSERT INTO orders (id, user_id, order_date, status, total_amount) VALUES 
(1, 2, CURRENT_TIMESTAMP, 'SHIPPED', 839.98);

-- Insert order items
INSERT INTO order_items (id, order_id, product_id, quantity, price) VALUES 
(1, 1, 2, 1, 799.99),  -- iPhone in Jane's order
(2, 1, 5, 1, 39.99);   -- Book in Jane's order