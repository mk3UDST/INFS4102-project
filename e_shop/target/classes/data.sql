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
(5, 'Spring Boot in Action', 'Learn Spring Boot development', 39.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTSIzpXgs0ODS7ulPtmljNxYKc_A14xtQhDw&s', 75, 3),
(6, 'Wireless Headphones', 'Noise-cancelling over-ear headphones', 199.99, 'https://media.istockphoto.com/id/1412240771/photo/headphones-on-white-background.jpg?s=612x612&w=0&k=20&c=DwpnlOcMzclX8zJDKOMSqcXdc1E7gyGYgfX5Xr753aQ=', 80, 1),
(7, 'Smartwatch', 'Fitness tracker with heart rate monitor', 149.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwaDnd_5Z3ira-qykE3I-dlXiOfZskmI9fsg&s', 120, 1),
(8, 'Leather Jacket', 'Genuine leather, stylish design', 249.99, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJ5koxzyHnxddpEtDFl85VPPwRNEB965HmQA&s', 60, 2),
(9, 'Running Shoes', 'Lightweight and comfortable', 89.99, 'https://media.istockphoto.com/id/528298062/photo/healthy-trail-running.jpg?s=612x612&w=0&k=20&c=NGnsssN5pJuVf-OX2kDbxA6A5jXdJILip7YbQX-Gc_Q=', 100, 2),
(10, 'Data Science Handbook', 'Comprehensive guide to data science', 59.99, 'https://media.istockphoto.com/id/1389238948/photo/hand-touching-global-networking-on-data-connection-science-big-data-internet-technology.jpg?s=612x612&w=0&k=20&c=yCNE-b7vr1kD9iRAIH4Qq6J3ZRBalj_mCZVrNVsev50=', 50, 3);

-- Insert users
INSERT INTO users (id, username, email, address) VALUES 
(1, 'john_doe', 'john@example.com', '123 Main St, City, State');
