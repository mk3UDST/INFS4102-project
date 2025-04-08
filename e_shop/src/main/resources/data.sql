-- Insert categories
INSERT INTO categories (id, name, description) VALUES 
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Fashion items and accessories'),
(3, 'Books', 'Books and e-books');

-- Insert products
INSERT INTO products (id, name, description, price, image_url, stock_quantity, category_id) VALUES 
(1, 'MacBook Pro', '13-inch, Apple M1 chip with 8‑core CPU', 1299.99, 'https://media.istockphoto.com/id/1425655509/photo/apple-macbook-pro.jpg?s=612x612&w=0&k=20&c=Qvvkux4tUjgOnZInhR6C8zQdpnx_YHS4RhKBHZ3-ouM=', 50, 1),
(2, 'iPhone 13', '6.1-inch Super Retina XDR display', 799.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1VIDU0HNiZzY7tIjqY3no_SiW7iRbbq0mVQ&s', 100, 1),
(3, 'Cotton T-Shirt', '100% cotton, comfortable fit', 19.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxaGnA1YEvMCk8je1QvK7_vooh_RW7I7VLVg&s', 200, 2),
(4, 'Slim Fit Jeans', 'Blue denim, slim fit design', 49.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4rCNdRi2BBvhJU4SuwyOHASndCQ8ckfdnww&s', 150, 2),
(5, 'Spring Boot in Action', 'Learn Spring Boot development', 39.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTSIzpXgs0ODS7ulPtmljNxYKc_A14xtQhDw&s', 75, 3);

-- Insert users
INSERT INTO users (id, username, email, address) VALUES 
(1, 'john_doe', 'john@example.com', '123 Main St, City, State');
