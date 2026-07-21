/*
=========================================
Project: SQL Retail Sales Analysis
Author: Kala
Database: PostgreSQL
Description: Portfolio project analyzing retail sales data
=========================================
*/
CREATE TABLE retail_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit NUMERIC(10,2),
    cogs NUMERIC(10,2),
    total_sale NUMERIC(10,2)
);
-- =========================================
-- 1. Data Validation
-- =========================================

-- Check total number of records
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- Preview the first 10 rows
SELECT *
FROM retail_sales
LIMIT 10;

-- Check for NULL values
SELECT *
FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
	
--Check for Duplicate Transaction IDs
SELECT
    transactions_id,
    COUNT(*)
FROM retail_sales
GROUP BY transactions_id
HAVING COUNT(*) > 1;

-- =========================================
-- 2. Business Analysis
-- =========================================

-- Q1. Retrieve all sales made on 2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Clothing transactions with quantity >= 4 in November 2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
  
-- Q3. Total sales by category

SELECT
    category,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

-- Q4. Average age of customers purchasing Beauty products

SELECT
    ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Transactions with total sale greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Number of transactions by gender

SELECT
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY gender;

-- Q7. Average sale amount by category

SELECT
    category,
    ROUND(AVG(total_sale), 2) AS average_sale
FROM retail_sales
GROUP BY category;

-- Q8. Top 5 highest sales transactions

SELECT *
FROM retail_sales
ORDER BY total_sale DESC
LIMIT 5;

-- Q9. Monthly sales revenue

SELECT
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY month
ORDER BY month;

-- Q10. Best-selling category by revenue

SELECT
    category,
    SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY category
ORDER BY revenue DESC;


-- Q11. Top 5 customers by total spending

SELECT
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;


-- Q12. Total quantity sold by category

SELECT
    category,
    SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY category
ORDER BY total_quantity DESC;


-- Q13. Average transaction value by gender

SELECT
    gender,
    ROUND(AVG(total_sale), 2) AS average_transaction
FROM retail_sales
GROUP BY gender;


-- Q14. Customers with more than 5 purchases

SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_orders DESC;


-- Q15. Sales made on weekends

SELECT *
FROM retail_sales
WHERE EXTRACT(DOW FROM sale_date) IN (0, 6);


