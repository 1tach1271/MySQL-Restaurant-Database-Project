/* ============================================================
   PROJECT: Restaurant Orders Analysis (MySQL)
   DATABASE: restaurant
   TABLES  : customer, menu, orders
   AUTHOR  : Shashi Yadav
   ============================================================ */

-- CREATE DATABASE
DROP DATABASE IF EXISTS restaurant;
CREATE DATABASE restaurant;
USE restaurant;

-- CREATE TABLES
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE menu (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(50) NOT NULL,
    category VARCHAR(30) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    order_date DATE NOT NULL,
    payment_mode VARCHAR(20) NOT NULL,
    
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_orders_menu FOREIGN KEY (item_id)
        REFERENCES menu(item_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- INDEXES
CREATE INDEX idx_orders_orderdate ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_item ON orders(item_id);

-- INSERT DATA 
INSERT INTO customer (customer_id, customer_name, city, created_at) VALUES
(1,'Shashi','Chennai','2025-12-15'),
(2,'Amit','Delhi','2025-12-20'),
(3,'Priya','Bangalore','2025-12-22'),
(4,'Rahul','Mumbai','2025-12-25'),
(5,'Sneha','Chennai','2025-12-30'),
(6,'Karthik','Hyderabad','2026-01-02'),
(7,'Neha','Pune','2026-01-04');

INSERT INTO menu (item_id, item_name, category, price) VALUES
(101,'Chicken Biriyani','Main Course',180),
(102,'Veg Burger','Fast Food',120),
(103,'Pizza','Fast Food',250),
(104,'Masala Dosa','South Indian',80),
(105,'Pasta','Italian',220),
(106,'Ice Cream','Dessert',90),
(107,'Paneer Butter Masala','Main Course',200),
(108,'Cold Coffee','Beverage',110);

INSERT INTO orders (order_id, customer_id, item_id, quantity, order_date, payment_mode) VALUES
(1001,1,101,2,'2026-01-01','UPI'),
(1002,2,103,1,'2026-01-02','Card'),
(1003,3,104,3,'2026-01-03','Cash'),
(1004,1,106,2,'2026-01-03','UPI'),
(1005,4,102,4,'2026-01-04','Card'),
(1006,5,105,1,'2026-01-04','UPI'),
(1007,2,101,1,'2026-01-05','UPI'),
(1008,3,103,2,'2026-01-06','Card'),
(1009,1,104,2,'2026-01-06','Cash'),
(1010,5,106,5,'2026-01-07','Cash'),
(1011,6,108,2,'2026-01-07','UPI'),
(1012,7,107,1,'2026-01-08','Card'),
(1013,6,101,1,'2026-01-08','UPI'),
(1014,2,108,3,'2026-01-09','Cash');

-- ============================================================
-- COMMANDS
-- ============================================================

--1 Total orders
SELECT COUNT(*) AS total_orders FROM orders;

--2 Total customers
SELECT COUNT(*) AS total_customers FROM customer;

--3 Total menu items
SELECT COUNT(*) AS total_menu_items FROM menu;

--4 Total revenue
SELECT ROUND(SUM(m.price * o.quantity),2) AS total_revenue
FROM orders o
JOIN menu m ON o.item_id = m.item_id;

--5 Revenue by payment mode
SELECT o.payment_mode,
       ROUND(SUM(m.price * o.quantity),2) AS revenue
FROM orders o
JOIN menu m ON o.item_id = m.item_id
GROUP BY o.payment_mode
ORDER BY revenue DESC;

--6 Orders per day
SELECT order_date,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;

--7 Daily revenue trend
SELECT o.order_date,
       ROUND(SUM(m.price * o.quantity),2) AS day_revenue
FROM orders o
JOIN menu m ON o.item_id = m.item_id
GROUP BY o.order_date
ORDER BY o.order_date;

--8 Monthly revenue
SELECT DATE_FORMAT(order_date,'%Y-%m') AS month,
       ROUND(SUM(m.price * o.quantity),2) AS revenue
FROM orders o
JOIN menu m ON o.item_id = m.item_id
GROUP BY month
ORDER BY month;

--9 Top 5 items by quantity sold
SELECT m.item_name,
       SUM(o.quantity) AS total_qty
FROM orders o
JOIN menu m ON o.item_id = m.item_id
GROUP BY m.item_name
ORDER BY total_qty DESC
LIMIT 5;

--10 Top 5 items by revenue
SELECT m.item_name,
       ROUND(SUM(m.price * o.quantity),2) AS revenue
FROM orders o
JOIN menu m ON o.item_id = m.item_id
GROUP BY m.item_name
ORDER BY revenue DESC
LIMIT 5;

--11 Category-wise revenue
SELECT m.category,
       ROUND(SUM(m.price * o.quantity),2) AS revenue
FROM orders o
JOIN menu m ON o.item_id = m.item_id
GROUP BY m.category
ORDER BY revenue DESC;

--12 Average order value (AOV)
SELECT ROUND(AVG(order_total),2) AS avg_order_value
FROM (
    SELECT o.order_id,
           SUM(m.price * o.quantity) AS order_total
    FROM orders o
    JOIN menu m ON o.item_id = m.item_id
    GROUP BY o.order_id
) x;

--13 Most valuable customer (highest spend)
SELECT c.customer_name,
       ROUND(SUM(m.price * o.quantity),2) AS total_spent
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN menu m ON o.item_id = m.item_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

--14 Spend per customer
SELECT c.customer_name,
       ROUND(SUM(m.price * o.quantity),2) AS total_spent
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN menu m ON o.item_id = m.item_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

--15 Repeat customers (more than 1 order)
SELECT c.customer_name,
       COUNT(*) AS total_orders
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING total_orders > 1
ORDER BY total_orders DESC;

--16 City-wise revenue
SELECT c.city,
       ROUND(SUM(m.price * o.quantity),2) AS revenue
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN menu m ON o.item_id = m.item_id
GROUP BY c.city
ORDER BY revenue DESC;

--17 Most used payment mode
SELECT payment_mode,
       COUNT(*) AS total_orders
FROM orders
GROUP BY payment_mode
ORDER BY total_orders DESC
LIMIT 1;

--18 Orders with quantity > 2 (bulk orders)
SELECT *
FROM orders
WHERE quantity > 2
ORDER BY quantity DESC;

--19 Customer ranking by total spend
SELECT c.customer_name,
       ROUND(SUM(m.price * o.quantity),2) AS total_spent,
       RANK() OVER (ORDER BY SUM(m.price * o.quantity) DESC) AS spend_rank
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN menu m ON o.item_id = m.item_id
GROUP BY c.customer_name;

--20 Running total revenue by date
SELECT order_date,
       day_revenue,
       ROUND(SUM(day_revenue) OVER (ORDER BY order_date),2) AS running_revenue
FROM (
    SELECT o.order_date,
           SUM(m.price * o.quantity) AS day_revenue
    FROM orders o
    JOIN menu m ON o.item_id = m.item_id
    GROUP BY o.order_date
) t
ORDER BY order_date;

--21 Top item per category (ROW_NUMBER)
SELECT category, item_name, revenue
FROM (
    SELECT m.category,
           m.item_name,
           ROUND(SUM(m.price * o.quantity),2) AS revenue,
           ROW_NUMBER() OVER (PARTITION BY m.category ORDER BY SUM(m.price * o.quantity) DESC) AS rn
    FROM orders o
    JOIN menu m ON o.item_id = m.item_id
    GROUP BY m.category, m.item_name
) x
WHERE rn = 1;

-- VIEW (FOR DASHBOARD-LIKE OUTPUT)
DROP VIEW IF EXISTS order_bill_view;
CREATE VIEW order_bill_view AS
SELECT o.order_id,
       o.order_date,
       c.customer_name,
       c.city,
       m.item_name,
       m.category,
       o.quantity,
       m.price,
       ROUND(m.price * o.quantity,2) AS amount,
       o.payment_mode
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN menu m ON o.item_id = m.item_id;

SELECT * FROM order_bill_view ORDER BY order_date, order_id;

-- STORED PROCEDURE

DROP PROCEDURE IF EXISTS GetCustomerSummary;
DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(IN p_customer_id INT)
BEGIN
    SELECT c.customer_id,
           c.customer_name,
           c.city,
           COUNT(o.order_id) AS total_orders,
           ROUND(SUM(m.price * o.quantity),2) AS total_spent
    FROM customer c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN menu m ON o.item_id = m.item_id
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id, c.customer_name, c.city;
END $$

DELIMITER ;

CALL GetCustomerSummary(1);

-- ============================================================
-- END OF PROJECT
-- ============================================================

