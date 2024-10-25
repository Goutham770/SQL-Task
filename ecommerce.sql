-- Create the ecommerce database
CREATE DATABASE ecommerce;

-- Use the newly created database
USE ecommerce;

-- Create customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    discount DECIMAL(5, 2) DEFAULT 0.00  -- Adding discount column initially
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);


-- Insert sample data into customers table
INSERT INTO customers (name, email, address) VALUES
('Daniel', 'daniel@gofimilar.com', 'upper gudalur'),
('punniya', 'punniya@gofimilar.com', 'marthoma'),
('Goutham', 'goutham@gofimilar.com', 'gudalur');

-- Insert sample data into products table
INSERT INTO products (name, price, description) VALUES
('soap', 30.00, 'bathing soap'),
('paste', 25.00, 'colgate paste '),
('bread', 50.00, 'bread');

-- Insert sample data into orders table
INSERT INTO orders (customer_id, total_amount) VALUES
(1, 100.00),
(2, 200.00),
(1, 150.00);

-- 1. Retrieve all customers who have placed an order in the last 30 days.
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= NOW() - INTERVAL 30 DAY;

-- 2. Get the total amount of all orders placed by each customer.
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;

-- 3. Update the price of bread to 45.00.
UPDATE products
SET price = 45.00
WHERE name = 'bread';

-- 4. Add a new column discount to the products table.
-- (Already added in table creation step)

-- 5. Retrieve the top 3 products with the highest price.
SELECT * FROM products
ORDER BY price DESC
LIMIT 3;

-- 6. Get the names of customers who have ordered Product A.
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN products p ON p.id = o.id  -- Assuming order table references products
WHERE p.name = 'soap';

-- 7. Join the orders and customers tables to retrieve the customer's name and order date for each order.
SELECT c.name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- 8. Retrieve the orders with a total amount greater than 150.00.
SELECT * FROM orders
WHERE total_amount > 150.00;

-- 9. Normalize the database by creating a separate table for order items.
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Example of inserting data into order_items table
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),  -- 2 of soap for Order 1
(2, 2, 1);  -- 1 of paste for Order 2

-- 10. Retrieve the average total of all orders.
SELECT AVG(total_amount) AS average_order_total
FROM orders;