
-- PROJECT: Retail Sales Data Analysis
-- Database: SQLite
-- Dataset: Fictional retail business

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    unit_price REAL NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Alice', 'Tallinn'),
(2, 'Mark', 'Tartu'),
(3, 'Sara', 'Tallinn'),
(4, 'John', 'Parnu'),
(5, 'Emma', 'Tallinn');

INSERT INTO products VALUES
(1, 'Coffee', 'Beverages', 8.00),
(2, 'Tea', 'Beverages', 6.00),
(3, 'Mug', 'Accessories', 12.00),
(4, 'Coffee Beans', 'Grocery', 15.00),
(5, 'Bottle', 'Accessories', 20.00);

INSERT INTO orders VALUES
(101, 1, '2026-01-05'),
(102, 2, '2026-01-07'),
(103, 1, '2026-01-20'),
(104, 3, '2026-02-02'),
(105, 4, '2026-02-11'),
(106, 2, '2026-02-15'),
(107, 5, '2026-03-01'),
(108, 3, '2026-03-08'),
(109, 1, '2026-03-18'),
(110, 5, '2026-03-20');

INSERT INTO order_items VALUES
(1, 101, 1, 2),
(2, 101, 3, 1),
(3, 102, 2, 3),
(4, 103, 4, 2),
(5, 104, 3, 2),
(6, 105, 5, 1),
(7, 106, 1, 1),
(8, 106, 2, 1),
(9, 107, 4, 1),
(10, 107, 5, 1),
(11, 108, 2, 2),
(12, 108, 3, 1),
(13, 109, 1, 3),
(14, 110, 5, 2);

SELECT * FROM customers;
SELECT * FROM orders;


-- 1. Calculate total sales revenue

SELECT
    ROUND(SUM(oi.quantity * p.unit_price), 2)
        AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;


-- 2. Revenue by product category

SELECT
    p.category,
    ROUND(SUM(oi.quantity * p.unit_price), 2)
        AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- 3. Revenue by customer

SELECT
    c.customer_name,
    c.city,
    ROUND(SUM(oi.quantity * p.unit_price), 2)
        AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent DESC;


-- 4. Monthly sales trends

SELECT
    strftime('%Y-%m', o.order_date) AS sales_month,
    ROUND(SUM(oi.quantity * p.unit_price), 2)
        AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY sales_month;
