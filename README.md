
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

