-- =====================================================================================================================
-- Online Retail Sales Analysis Project - MASTER VERSION
-- Covers: Constraints, Indexing, Views, Triggers, Functions, Procedures
-- =====================================================================================================================

-- CREATE DATABASE

CREATE DATABASE IF NOT EXISTS OnlineRetail;
USE OnlineRetail;

-- Cleanup old tables in FK-safe order
DROP TABLE IF EXISTS Payments, Order_Details, Orders, Products, Customers;

-- CREATE TABLES with CONSTRAINTS
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category ENUM('Electronics','Accessories','Furniture') NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT (CURRENT_DATE),
    shipping_address VARCHAR(150) NOT NULL,
    shipping_city VARCHAR(50) NOT NULL,
    shipping_country VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_per_unit DECIMAL(10,2) NOT NULL CHECK (price_per_unit >= 0),
    discount DECIMAL(5,2) DEFAULT 0 CHECK (discount >= 0 AND discount <= 100),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method ENUM('Credit Card','Debit Card','PayPal','UPI','Cash') NOT NULL,
    payment_date DATE DEFAULT (CURRENT_DATE),
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- INDEXES
CREATE INDEX idx_customers_country ON Customers(country);
CREATE INDEX idx_products_category ON Products(category);
CREATE INDEX idx_orders_date ON Orders(order_date);
CREATE INDEX idx_payments_method ON Payments(payment_method);

-- SAMPLE DATA INSERTION (reusing your records)
INSERT INTO Customers (first_name,last_name,email,phone,city,country,registration_date) VALUES
('Ravi', 'Kumar', 'ravi.kumar@example.com', '9876543210', 'Pune', 'India', '2023-01-15'),
('Sneha', 'Patil', 'sneha.patil@example.com', '9876501234', 'Mumbai', 'India', '2023-02-10'),
('John', 'Smith', 'john.smith@example.com', '9998887777', 'New York', 'USA', '2022-11-20'),
('Anna', 'Johnson', 'anna.johnson@example.com', '5551234567', 'Los Angeles', 'USA', '2023-03-05'),
('Priya', 'Sharma', 'priya.sharma@example.com', '9876512345', 'Delhi', 'India', '2023-01-20'),
('David', 'Brown', 'david.brown@example.com', '4445556666', 'London', 'UK', '2022-12-15'),
('Maria', 'Garcia', 'maria.garcia@example.com', '3332221111', 'Madrid', 'Spain', '2023-04-10'),
('Chen', 'Wei', 'chen.wei@example.com', '8889997777', 'Shanghai', 'China', '2023-02-28');

INSERT INTO Products (product_name,category,unit_price,stock_quantity) VALUES
('Laptop', 'Electronics', 75000, 20),
('Smartphone', 'Electronics', 30000, 50),
('Headphones', 'Accessories', 1500, 100),
('Tablet', 'Electronics', 25000, 30),
('Wireless Mouse', 'Accessories', 800, 150),
('Gaming Chair', 'Furniture', 12000, 25),
('Monitor', 'Electronics', 18000, 40),
('Keyboard', 'Accessories', 2000, 80),
('Webcam', 'Accessories', 3500, 60),
('Desk Lamp', 'Furniture', 1800, 70);

INSERT INTO Orders (customer_id,order_date,shipping_address,shipping_city,shipping_country,total_amount) VALUES
(1, '2024-05-10', '123 Main St', 'Pune', 'India', 76500),
(2, '2024-06-15', '45 MG Road', 'Mumbai', 'India', 31500),
(3, '2024-07-20', '78 Broadway', 'New York', 'USA', 31500),
(4, '2024-05-25', '456 Sunset Blvd', 'Los Angeles', 'USA', 43800),
(5, '2024-06-05', '789 CP Road', 'Delhi', 'India', 27000),
(1, '2024-07-30', '123 Main St', 'Pune', 'India', 20000),
(6, '2024-06-20', '321 Baker St', 'London', 'UK', 15300),
(7, '2024-07-15', '654 Gran Via', 'Madrid', 'Spain', 33500);

INSERT INTO Order_Details (order_id,product_id,quantity,price_per_unit,discount) VALUES
(1, 1, 1, 75000, 0),
(1, 3, 1, 1500, 0),
(2, 2, 1, 30000, 5),
(2, 3, 1, 1500, 0),
(3, 2, 1, 30000, 0),
(3, 3, 1, 1500, 0),
(4, 4, 1, 25000, 10),
(4, 7, 1, 18000, 5),
(4, 5, 1, 800, 0),
(5, 2, 1, 30000, 10),
(6, 4, 1, 25000, 20),
(7, 3, 2, 1500, 0),
(7, 6, 1, 12000, 0),
(8, 2, 1, 30000, 5),
(8, 8, 1, 2000, 0),
(8, 3, 1, 1500, 0);

INSERT INTO Payments (order_id,payment_method,payment_date,amount) VALUES
(1, 'Credit Card', '2024-05-10', 76500),
(2, 'PayPal', '2024-06-15', 31500),
(3, 'Credit Card', '2024-07-20', 31500),
(4, 'Debit Card', '2024-05-25', 43800),
(5, 'UPI', '2024-06-05', 27000),
(6, 'Credit Card', '2024-07-30', 20000),
(7, 'PayPal', '2024-06-20', 15300),
(8, 'Credit Card', '2024-07-15', 33500);

-- BASIC OVERVIEW QUERIES
-- =======================================================

-- Question 1: What is the total number of customers in our database?
SELECT COUNT(*) AS total_customers FROM Customers;

-- Question 2: How many products do we have in each category?
SELECT category, COUNT(*) AS product_count 
FROM Products 
GROUP BY category 
ORDER BY product_count DESC;

-- Question 3: What are all the electronics products with their prices?
SELECT * FROM Products WHERE category = 'Electronics' ORDER BY unit_price DESC;

-- Question 4: What is the total revenue generated so far?
SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- CUSTOMER ANALYSIS QUERIES
-- =======================================================

-- Question 5: Who are our top 5 customers by total spending?
SELECT c.first_name, c.last_name, c.email, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 5;

-- Question 6: Which customers have made repeat purchases?
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

-- Question 7: What is the customer distribution by country?
SELECT country, COUNT(*) AS customer_count,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customers)), 2) AS percentage
FROM Customers
GROUP BY country
ORDER BY customer_count DESC;

-- Question 8: Which customers have registered but never made a purchase?
SELECT c.customer_id, c.first_name, c.last_name, c.email, c.registration_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Question 9: What is the average time between customer registration and first purchase?
SELECT ROUND(AVG(DATEDIFF(o.first_order_date, c.registration_date)), 2) AS avg_days_to_first_purchase
FROM Customers c
JOIN (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
) o ON c.customer_id = o.customer_id;

-- PRODUCT PERFORMANCE QUERIES
-- =======================================================

-- Question 10: What are the top 5 best-selling products by quantity?
SELECT p.product_name, p.category, SUM(od.quantity) AS total_quantity_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Question 11: Which products generate the highest revenue?
SELECT p.product_name, p.category, 
       SUM(od.quantity * od.price_per_unit * (1 - od.discount/100)) AS total_revenue
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

-- Question 12: What is the best-selling product in each category?
SELECT category, product_name, total_quantity_sold
FROM (
    SELECT p.category, p.product_name, SUM(od.quantity) AS total_quantity_sold,
           RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.quantity) DESC) AS rank_in_category
    FROM Order_Details od
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY p.category, p.product_name
) ranked_products
WHERE rank_in_category = 1;

-- Question 13: Which products have never been sold?
SELECT p.product_id, p.product_name, p.category, p.unit_price
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
WHERE od.product_id IS NULL;

-- Question 14: What is the profit margin for each product category?
SELECT p.category,
       SUM(od.quantity * od.price_per_unit) AS gross_revenue,
       SUM(od.quantity * od.price_per_unit * od.discount / 100) AS total_discount,
       SUM(od.quantity * od.price_per_unit * (1 - od.discount/100)) AS net_revenue
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY net_revenue DESC;

-- SALES TREND ANALYSIS
-- =======================================================

-- Question 15: What are the monthly sales trends?
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, 
       COUNT(order_id) AS total_orders,
       SUM(total_amount) AS monthly_revenue,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders 
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Question 16: What is the month-over-month revenue growth rate?
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
    ORDER BY month
),
growth_calc AS (
    SELECT month, revenue,
           LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT month, revenue, previous_month_revenue,
       CASE 
           WHEN previous_month_revenue IS NULL THEN NULL
           ELSE ROUND(((revenue - previous_month_revenue) / previous_month_revenue) * 100, 2)
       END AS growth_percentage
FROM growth_calc;

-- Question 17: What is the daily sales pattern (which day of week performs best)?
SELECT DAYNAME(order_date) AS day_of_week,
       COUNT(order_id) AS total_orders,
       SUM(total_amount) AS total_revenue,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY DAYOFWEEK(order_date);

-- Question 18: What is the cumulative revenue over time?
SELECT order_date,
       total_amount,
       SUM(total_amount) OVER (ORDER BY order_date) AS cumulative_revenue
FROM Orders
ORDER BY order_date;

-- DISCOUNT AND PRICING ANALYSIS
-- =======================================================

-- Question 19: How do different discount levels impact sales volume?
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 5 THEN 'Low Discount (1-5%)'
        WHEN discount <= 10 THEN 'Medium Discount (6-10%)'
        ELSE 'High Discount (>10%)'
    END AS discount_category,
    COUNT(*) AS order_count,
    SUM(quantity) AS total_quantity,
    SUM(quantity * price_per_unit) AS gross_revenue,
    SUM(quantity * price_per_unit * (1 - discount/100)) AS net_revenue
FROM Order_Details
GROUP BY discount_category
ORDER BY net_revenue DESC;

-- Question 20: What is the average discount given per product category?
SELECT p.category,
       ROUND(AVG(od.discount), 2) AS avg_discount_percent,
       COUNT(*) AS items_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_discount_percent DESC;

-- PAYMENT METHOD ANALYSIS
-- =======================================================

-- Question 21: What is the revenue share by payment method?
SELECT payment_method,
       COUNT(*) AS transaction_count,
       SUM(amount) AS total_revenue,
       ROUND((SUM(amount) / (SELECT SUM(amount) FROM Payments)) * 100, 2) AS revenue_share_percent
FROM Payments
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Question 22: What is the average transaction value by payment method?
SELECT payment_method,
       ROUND(AVG(amount), 2) AS avg_transaction_value,
       COUNT(*) AS transaction_count
FROM Payments
GROUP BY payment_method
ORDER BY avg_transaction_value DESC;

-- GEOGRAPHIC ANALYSIS
-- =======================================================

-- Question 23: Which countries generate the highest revenue?
SELECT shipping_country,
       COUNT(order_id) AS total_orders,
       SUM(total_amount) AS total_revenue,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY shipping_country
ORDER BY total_revenue DESC;

-- Question 24: What is the top-performing city in each country by revenue?
SELECT country, city, total_revenue, total_orders
FROM (
    SELECT shipping_country AS country, shipping_city AS city,
           SUM(total_amount) AS total_revenue,
           COUNT(order_id) AS total_orders,
           RANK() OVER (PARTITION BY shipping_country ORDER BY SUM(total_amount) DESC) AS city_rank
    FROM Orders
    GROUP BY shipping_country, shipping_city
) ranked_cities
WHERE city_rank = 1;

-- ADVANCED BUSINESS INTELLIGENCE QUERIES
-- =======================================================

-- Question 25: What is the Customer Lifetime Value (CLV) for each customer?
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value,
       ROUND(SUM(o.total_amount) / COUNT(o.order_id), 2) AS clv_per_order
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Question 26: Which customer segments should we focus on (RFM Analysis - simplified)?
WITH customer_metrics AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           DATEDIFF('2024-08-14', MAX(o.order_date)) AS recency_days,
           COUNT(o.order_id) AS frequency,
           SUM(o.total_amount) AS monetary_value
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, recency_days, frequency, monetary_value,
       CASE 
           WHEN recency_days <= 30 AND frequency >= 2 AND monetary_value >= 50000 THEN 'VIP Customer'
           WHEN recency_days <= 60 AND frequency >= 1 AND monetary_value >= 25000 THEN 'Regular Customer'
           WHEN recency_days > 60 THEN 'At Risk Customer'
           ELSE 'New Customer'
       END AS customer_segment
FROM customer_metrics
ORDER BY monetary_value DESC;

-- Question 27: What is the order completion rate (orders with payments vs total orders)?
SELECT 
    (SELECT COUNT(*) FROM Orders) AS total_orders,
    (SELECT COUNT(DISTINCT order_id) FROM Payments) AS paid_orders,
    ROUND(((SELECT COUNT(DISTINCT order_id) FROM Payments) * 100.0 / (SELECT COUNT(*) FROM Orders)), 2) AS completion_rate_percent;

-- Question 28: What is the inventory turnover for each product?
SELECT p.product_id, p.product_name, p.stock_quantity,
       COALESCE(SUM(od.quantity), 0) AS units_sold,
       CASE 
           WHEN p.stock_quantity > 0 THEN ROUND(COALESCE(SUM(od.quantity), 0) / p.stock_quantity, 2)
           ELSE 0
       END AS turnover_ratio
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.stock_quantity
ORDER BY turnover_ratio DESC;

-- Question 29: What is the seasonal performance analysis?
SELECT 
    CASE 
        WHEN MONTH(order_date) IN (3,4,5) THEN 'Spring'
        WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer'
        WHEN MONTH(order_date) IN (9,10,11) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY season
ORDER BY total_revenue DESC;

-- Question 30: Which products are frequently bought together (Market Basket Analysis)?
SELECT od1.product_id AS product_1, p1.product_name AS product_1_name,
       od2.product_id AS product_2, p2.product_name AS product_2_name,
       COUNT(*) AS frequency
FROM Order_Details od1
JOIN Order_Details od2 ON od1.order_id = od2.order_id AND od1.product_id < od2.product_id
JOIN Products p1 ON od1.product_id = p1.product_id
JOIN Products p2 ON od2.product_id = p2.product_id
GROUP BY od1.product_id, od2.product_id, p1.product_name, p2.product_name
ORDER BY frequency DESC;

-- =====================================================================================================================

-- CUSTOMER & SALES ANALYSIS
-- =======================================================

-- Question 31: Who are the top 5 customers in each country by total spending?
SELECT country, first_name, last_name, total_spent
FROM (
    SELECT c.country, c.first_name, c.last_name,
           SUM(o.total_amount) AS total_spent,
           RANK() OVER (PARTITION BY c.country ORDER BY SUM(o.total_amount) DESC) AS rnk
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.country, c.first_name, c.last_name
) ranked
WHERE rnk <= 5
ORDER BY country, total_spent DESC;

-- Question 32: What percentage of total revenue comes from the top 10% of customers?
WITH customer_revenue AS (
    SELECT c.customer_id, SUM(o.total_amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
),
top_customers AS (
    SELECT *
    FROM customer_revenue
    ORDER BY total_spent DESC
    LIMIT CEIL(SELECT COUNT(*) FROM customer_revenue) * 0.1)
)
SELECT ROUND((SUM(tc.total_spent) / (SELECT SUM(total_spent) FROM customer_revenue)) * 100, 2) AS percent_revenue_from_top_10_percent
FROM top_customers tc;

-- Question 33: Which customers have increased their spending compared to the previous month?
WITH monthly_spending AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           DATE_FORMAT(o.order_date, '%Y-%m') AS month,
           SUM(o.total_amount) AS monthly_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, month
),
spending_comparison AS (
    SELECT customer_id, first_name, last_name, month, monthly_spent,
           LAG(monthly_spent) OVER (PARTITION BY customer_id ORDER BY month) AS prev_month_spent
    FROM monthly_spending
)
SELECT customer_id, first_name, last_name, month, monthly_spent, prev_month_spent
FROM spending_comparison
WHERE prev_month_spent IS NOT NULL AND monthly_spent > prev_month_spent;

-- Question 34: What is the churn rate (customers with no purchases in last 3 months)?
SELECT ROUND((COUNT(c.customer_id) / (SELECT COUNT(*) FROM Customers)) * 100, 2) AS churn_rate_percent
FROM Customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM Orders
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
);

-- Question 35: Average number of items per order by customer country
SELECT c.country, ROUND(AVG(order_item_count), 2) AS avg_items_per_order
FROM (
    SELECT o.order_id, o.customer_id, SUM(od.quantity) AS order_item_count
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    GROUP BY o.order_id, o.customer_id
) order_items
JOIN Customers c ON order_items.customer_id = c.customer_id
GROUP BY c.country
ORDER BY avg_items_per_order DESC;

-- Question 36: Which customers have the highest average order values?
SELECT c.first_name, c.last_name, c.email,
       COUNT(o.order_id) AS total_orders,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(o.order_id) >= 1
ORDER BY avg_order_value DESC
LIMIT 10;

-- PRODUCT & INVENTORY ANALYSIS
-- =======================================================

-- Question 37: Which products have the highest profit margin percentage?
SELECT product_name, category, unit_price,
       ROUND(((unit_price - (unit_price * 0.6)) / unit_price) * 100, 2) AS estimated_profit_margin_percent
FROM Products
ORDER BY estimated_profit_margin_percent DESC;

-- Question 38: What products contribute to 80% of total revenue (Pareto Analysis)?
WITH product_revenue AS (
    SELECT p.product_name, p.category,
           SUM(od.quantity * od.price_per_unit * (1 - od.discount/100)) AS product_revenue
    FROM Order_Details od
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
revenue_with_cumulative AS (
    SELECT product_name, category, product_revenue,
           SUM(product_revenue) OVER (ORDER BY product_revenue DESC) / SUM(product_revenue) OVER () AS cumulative_percent
    FROM product_revenue
)
SELECT product_name, category, product_revenue, 
       ROUND(cumulative_percent * 100, 2) AS cumulative_revenue_percent
FROM revenue_with_cumulative
WHERE cumulative_percent <= 0.8
ORDER BY product_revenue DESC;

-- Question 39: Which products have declining sales over the last few months?
WITH monthly_product_sales AS (
    SELECT p.product_id, p.product_name,
           DATE_FORMAT(o.order_date, '%Y-%m') AS month,
           SUM(od.quantity) AS monthly_quantity
    FROM Order_Details od
    JOIN Products p ON od.product_id = p.product_id
    JOIN Orders o ON od.order_id = o.order_id
    GROUP BY p.product_id, p.product_name, month
),
sales_with_previous AS (
    SELECT product_id, product_name, month, monthly_quantity,
           LAG(monthly_quantity) OVER (PARTITION BY product_id ORDER BY month) AS prev_month_quantity
    FROM monthly_product_sales
)
SELECT DISTINCT product_id, product_name
FROM sales_with_previous
WHERE prev_month_quantity IS NOT NULL AND monthly_quantity < prev_month_quantity;

-- Question 40: Which product categories see the highest average discounts?
SELECT p.category,
       ROUND(AVG(od.discount), 2) AS avg_discount_percent,
       COUNT(od.order_detail_id) AS items_with_discount
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
WHERE od.discount > 0
GROUP BY p.category
ORDER BY avg_discount_percent DESC;

-- Question 41: What is the inventory turnover ratio for each product?
SELECT p.product_id, p.product_name, p.stock_quantity,
       COALESCE(SUM(od.quantity), 0) AS total_sold,
       CASE 
           WHEN p.stock_quantity > 0 THEN ROUND(COALESCE(SUM(od.quantity), 0) / p.stock_quantity, 2)
           ELSE NULL
       END AS turnover_ratio
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.stock_quantity
ORDER BY turnover_ratio DESC;

-- Question 42: Which products are slow-moving (sold less than 5 units total)?
SELECT p.product_id, p.product_name, p.category, p.stock_quantity,
       COALESCE(SUM(od.quantity), 0) AS total_sold
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category, p.stock_quantity
HAVING total_sold < 5
ORDER BY total_sold ASC;

-- SALES & REVENUE TRENDS
-- =======================================================

-- Question 43: Compare seasonal sales performance
SELECT 
    CASE 
        WHEN MONTH(order_date) IN (3,4,5) THEN 'Spring'
        WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer'
        WHEN MONTH(order_date) IN (9,10,11) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
    YEAR(order_date) AS year,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS seasonal_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY season, year
ORDER BY year, seasonal_revenue DESC;

-- Question 44: What is the year-over-year revenue growth rate?
WITH yearly_revenue AS (
    SELECT YEAR(order_date) AS year, SUM(total_amount) AS annual_revenue
    FROM Orders
    GROUP BY year
),
revenue_growth AS (
    SELECT year, annual_revenue,
           LAG(annual_revenue) OVER (ORDER BY year) AS previous_year_revenue
    FROM yearly_revenue
)
SELECT year, annual_revenue, previous_year_revenue,
       CASE 
           WHEN previous_year_revenue IS NULL THEN NULL
           ELSE ROUND(((annual_revenue - previous_year_revenue) / previous_year_revenue) * 100, 2)
       END AS yoy_growth_percent
FROM revenue_growth;

-- Question 45: Which month had the highest order volume?
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       COUNT(order_id) AS order_volume,
       SUM(total_amount) AS monthly_revenue
FROM Orders
GROUP BY month
ORDER BY order_volume DESC
LIMIT 1;

-- Question 46: Revenue comparison between weekends vs weekdays
SELECT 
    CASE 
        WHEN DAYOFWEEK(order_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY day_type;

-- Question 47: Identify months with revenue dips larger than 20%
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY month
    ORDER BY month
),
revenue_changes AS (
    SELECT month, revenue,
           LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
           CASE 
               WHEN LAG(revenue) OVER (ORDER BY month) IS NULL THEN NULL
               ELSE ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)) * 100, 2)
           END AS month_over_month_change
    FROM monthly_revenue
)
SELECT month, revenue, prev_month_revenue, month_over_month_change
FROM revenue_changes
WHERE month_over_month_change < -20;

-- Question 48: Average time between order placement and payment
SELECT ROUND(AVG(DATEDIFF(p.payment_date, o.order_date)), 2) AS avg_days_to_payment
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id;

-- PAYMENT & TRANSACTION ANALYSIS
-- =======================================================

-- Question 49: Payment method with highest avg transaction value per country
SELECT o.shipping_country, p.payment_method, 
       ROUND(AVG(p.amount), 2) AS avg_transaction_value,
       COUNT(p.payment_id) AS transaction_count
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
GROUP BY o.shipping_country, p.payment_method
ORDER BY o.shipping_country, avg_transaction_value DESC;

-- Question 50: Payment success rate by method
SELECT payment_method,
       COUNT(payment_id) AS total_attempts,
       COUNT(CASE WHEN amount > 0 THEN 1 END) AS successful_payments,
       ROUND((COUNT(CASE WHEN amount > 0 THEN 1 END) / COUNT(payment_id)) * 100, 2) AS success_rate_percent
FROM Payments
GROUP BY payment_method
ORDER BY success_rate_percent DESC;

-- Question 51: Does payment method correlate with higher basket size?
SELECT p.payment_method,
       COUNT(o.order_id) AS order_count,
       ROUND(AVG(o.total_amount), 2) AS avg_basket_size,
       SUM(o.total_amount) AS total_revenue
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
GROUP BY p.payment_method
ORDER BY avg_basket_size DESC;

-- Question 52: Payment method preferences by customer segment
WITH customer_segments AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency_days,
           COUNT(o.order_id) AS frequency,
           SUM(o.total_amount) AS monetary_value,
           CASE 
               WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 30 AND COUNT(o.order_id) >= 2 AND SUM(o.total_amount) >= 50000 THEN 'VIP Customer'
               WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 60 AND COUNT(o.order_id) >= 1 AND SUM(o.total_amount) >= 25000 THEN 'Regular Customer'
               WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 60 THEN 'At Risk Customer'
               ELSE 'New Customer'
           END AS customer_segment
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT cs.customer_segment, pm.payment_method, COUNT(*) AS usage_count
FROM customer_segments cs
JOIN Orders o ON cs.customer_id = o.customer_id
JOIN Payments pm ON o.order_id = pm.order_id
GROUP BY cs.customer_segment, pm.payment_method
ORDER BY cs.customer_segment, usage_count DESC;

-- Question 53: Seasonal trends in payment method usage
SELECT 
    CASE 
        WHEN MONTH(o.order_date) IN (3,4,5) THEN 'Spring'
        WHEN MONTH(o.order_date) IN (6,7,8) THEN 'Summer'
        WHEN MONTH(o.order_date) IN (9,10,11) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
    p.payment_method,
    COUNT(p.payment_id) AS usage_count
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
GROUP BY season, p.payment_method
ORDER BY season, usage_count DESC;

-- GEOGRAPHIC & MARKET ANALYSIS
-- =======================================================

-- Question 54: Cities with highest customer acquisition in the last year
SELECT city, country, COUNT(*) AS new_customers
FROM Customers
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY city, country
ORDER BY new_customers DESC;

-- Question 55: Revenue per capita by country (assuming population data)
SELECT shipping_country,
       COUNT(DISTINCT customer_id) AS unique_customers,
       SUM(total_amount) AS total_revenue,
       ROUND(SUM(total_amount) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM Orders
GROUP BY shipping_country
ORDER BY revenue_per_customer DESC;

-- Question 56: Cross-country comparison of average order values
SELECT shipping_country,
       COUNT(order_id) AS total_orders,
       ROUND(AVG(total_amount), 2) AS avg_order_value,
       MIN(total_amount) AS min_order,
       MAX(total_amount) AS max_order
FROM Orders
GROUP BY shipping_country
ORDER BY avg_order_value DESC;

-- Question 57: Underperforming regions (low revenue despite high customer count)
SELECT c.country,
       COUNT(DISTINCT c.customer_id) AS customer_count,
       COALESCE(SUM(o.total_amount), 0) AS total_revenue,
       ROUND(COALESCE(SUM(o.total_amount), 0) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.country
HAVING customer_count >= 2 AND revenue_per_customer < 30000
ORDER BY customer_count DESC;

-- Question 58: Which countries respond best to discounts?
SELECT o.shipping_country,
       ROUND(AVG(od.discount), 2) AS avg_discount_offered,
       COUNT(od.order_detail_id) AS discounted_items,
       SUM(od.quantity * od.price_per_unit * (1 - od.discount/100)) AS revenue_with_discount
FROM Order_Details od
JOIN Orders o ON od.order_id = o.order_id
WHERE od.discount > 0
GROUP BY o.shipping_country
ORDER BY avg_discount_offered DESC;

-- Question 59: Shipping destinations with order patterns
SELECT shipping_city, shipping_country,
       COUNT(order_id) AS total_orders,
       ROUND(AVG(total_amount), 2) AS avg_order_value,
       MIN(order_date) AS first_order,
       MAX(order_date) AS latest_order
FROM Orders
GROUP BY shipping_city, shipping_country
ORDER BY total_orders DESC;

-- MARKETING & PROMOTION ANALYSIS
-- =======================================================

-- Question 60: Correlation between discount percentage and repeat purchase rate
WITH customer_discount_behavior AS (
    SELECT o.customer_id,
           AVG(od.discount) AS avg_discount_received,
           COUNT(DISTINCT o.order_id) AS total_orders
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT 
    CASE 
        WHEN avg_discount_received = 0 THEN 'No Discount'
        WHEN avg_discount_received <= 5 THEN 'Low Discount (1-5%)'
        WHEN avg_discount_received <= 10 THEN 'Medium Discount (6-10%)'
        ELSE 'High Discount (>10%)'
    END AS discount_segment,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS repeat_customers,
    ROUND((COUNT(CASE WHEN total_orders > 1 THEN 1 END) / COUNT(customer_id)) * 100, 2) AS repeat_rate_percent
FROM customer_discount_behavior
GROUP BY discount_segment;

-- Question 61: Impact of high discounts on sales volume
SELECT 
    CASE 
        WHEN discount >= 15 THEN 'High Discount (15%+)'
        WHEN discount >= 10 THEN 'Medium Discount (10-14%)'
        WHEN discount >= 5 THEN 'Low Discount (5-9%)'
        ELSE 'No/Minimal Discount (0-4%)'
    END AS discount_category,
    COUNT(*) AS order_items,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * price_per_unit * (1 - discount/100)) AS net_revenue
FROM Order_Details
GROUP BY discount_category
ORDER BY net_revenue DESC;

-- Question 62: Customer acquisition effectiveness by registration period
SELECT DATE_FORMAT(registration_date, '%Y-%m') AS registration_month,
       COUNT(c.customer_id) AS customers_registered,
       COUNT(o.customer_id) AS customers_who_purchased,
       ROUND((COUNT(o.customer_id) / COUNT(c.customer_id)) * 100, 2) AS conversion_rate_percent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY registration_month
ORDER BY registration_month;

-- Question 63: Holiday season performance analysis
SELECT 
    CASE 
        WHEN MONTH(order_date) = 12 THEN 'December Holiday Season'
        WHEN MONTH(order_date) IN (1,2) THEN 'Post-Holiday Period'
        WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer Season'
        ELSE 'Regular Period'
    END AS period,
    COUNT(order_id) AS orders,
    SUM(total_amount) AS revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY period
ORDER BY revenue DESC;

-- Question 64: First-time vs repeat customer analysis
WITH customer_order_sequence AS (
    SELECT customer_id, order_id, order_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
    FROM Orders
)
SELECT 
    CASE 
        WHEN order_sequence = 1 THEN 'First-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(order_id) AS order_count,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customer_order_sequence cos
JOIN Orders o ON cos.order_id = o.order_id
GROUP BY customer_type;

-- ADVANCED BI & PREDICTIVE INSIGHTS
-- =======================================================

-- Question 65: Revenue forecast for next month (based on 3-month average)
SELECT ROUND(AVG(monthly_revenue), 2) AS forecasted_next_month_revenue
FROM (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, 
           SUM(total_amount) AS monthly_revenue
    FROM Orders
    GROUP BY month
    ORDER BY month DESC
    LIMIT 3
) recent_months;

-- Question 66: Predict stockout dates for top-selling products
SELECT p.product_name, p.stock_quantity,
       ROUND(SUM(od.quantity) / COUNT(DISTINCT DATE(o.order_date)), 2) AS avg_daily_sales,
       DATE_ADD(CURDATE(), INTERVAL FLOOR(p.stock_quantity / (SUM(od.quantity) / COUNT(DISTINCT DATE(o.order_date)))) DAY) AS estimated_stockout_date
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
JOIN Orders o ON od.order_id = o.order_id
WHERE p.stock_quantity > 0
GROUP BY p.product_id, p.product_name, p.stock_quantity
HAVING avg_daily_sales > 0
ORDER BY estimated_stockout_date ASC;

-- Question 67: Customer lifetime value prediction
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value,
       DATEDIFF(CURDATE(), c.registration_date) AS customer_age_days,
       ROUND(SUM(o.total_amount) / (DATEDIFF(CURDATE(), c.registration_date) / 365), 2) AS estimated_annual_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.registration_date
ORDER BY estimated_annual_value DESC;

-- Question 68: Customers likely to churn (RFM-based risk analysis)
WITH customer_rfm AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency_days,
           COUNT(o.order_id) AS frequency,
           SUM(o.total_amount) AS monetary_value
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, recency_days, frequency, monetary_value,
       CASE 
           WHEN recency_days > 90 AND frequency = 1 THEN 'High Churn Risk'
           WHEN recency_days > 60 AND frequency <= 2 THEN 'Medium Churn Risk'
           WHEN recency_days <= 30 THEN 'Low Churn Risk'
           ELSE 'Moderate Churn Risk'
       END AS churn_risk_level
FROM customer_rfm
ORDER BY recency_days DESC, frequency ASC;

-- Question 69: Market basket analysis - Products frequently bought together
SELECT od1.product_id AS product_1, p1.product_name AS product_1_name,
       od2.product_id AS product_2, p2.product_name AS product_2_name,
       COUNT(*) AS frequency,
       ROUND((COUNT(*) / (SELECT COUNT(DISTINCT order_id) FROM Order_Details)) * 100, 2) AS support_percent
FROM Order_Details od1
JOIN Order_Details od2 ON od1.order_id = od2.order_id AND od1.product_id < od2.product_id
JOIN Products p1 ON od1.product_id = p1.product_id
JOIN Products p2 ON od2.product_id = p2.product_id
GROUP BY od1.product_id, od2.product_id, p1.product_name, p2.product_name
HAVING frequency >= 2
ORDER BY frequency DESC;

-- Question 70: Customer purchase pattern prediction
WITH purchase_intervals AS (
    SELECT customer_id,
           DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
    FROM Orders
)
SELECT o.customer_id, c.first_name, c.last_name,
       COUNT(pi.days_between_orders) AS intervals_count,
       ROUND(AVG(pi.days_between_orders), 0) AS avg_days_between_orders,
       DATE_ADD(MAX(o.order_date), INTERVAL ROUND(AVG(pi.days_between_orders)) DAY) AS predicted_next_order_date
FROM purchase_intervals pi
JOIN Orders o ON pi.customer_id = o.customer_id
JOIN Customers c ON o.customer_id = c.customer_id
WHERE pi.days_between_orders IS NOT NULL
GROUP BY o.customer_id, c.first_name, c.last_name
HAVING intervals_count >= 1
ORDER BY predicted_next_order_date ASC;

-- =====================================================================================================================