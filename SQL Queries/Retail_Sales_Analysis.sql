/*
=========================================
Project: SQL Retail Sales Analysis
Author: Kala
Database: PostgreSQL
Description : SQL analysis of retail sales data using PostgreSQL
=========================================
*/

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
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

-- Data imported using pgAdmin Import/Export Wizard
-- Source file: Retail_Sales.csv


-- =========================================
-- SECTION 1 : DATA VALIDATION
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

-- Check distinct product categories
SELECT DISTINCT category
FROM retail_sales;

-- Check date range
SELECT
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
FROM retail_sales;

-- =========================================
-- SECTION 2 : BUSINESS ANALYSIS
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


-- =========================================
-- SECTION 3 : ADVANCED SQL
-- =========================================

-- Q16. Number of transactions by sales shift

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS sales_shift,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY sales_shift
ORDER BY total_transactions DESC;


-- Q17. Revenue generated each month

SELECT
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY month
ORDER BY total_revenue DESC;


-- Q18. Average quantity purchased by category

SELECT
    category,
    ROUND(AVG(quantity), 2) AS avg_quantity
FROM retail_sales
GROUP BY category
ORDER BY avg_quantity DESC;


-- Q19. Customers whose total spending is above the average customer spending

SELECT
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING SUM(total_sale) >
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT
            customer_id,
            SUM(total_sale) AS customer_total
        FROM retail_sales
        GROUP BY customer_id
    ) AS customer_summary
)
ORDER BY total_spent DESC;


-- Q20. Highest single sale in each category

SELECT
    category,
    MAX(total_sale) AS highest_sale
FROM retail_sales
GROUP BY category;


-- Q21. Rank categories by total revenue

SELECT
    category,
    SUM(total_sale) AS total_revenue,
    RANK() OVER (ORDER BY SUM(total_sale) DESC) AS revenue_rank
FROM retail_sales
GROUP BY category;


-- Q22. Running total of daily sales

WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(total_sale) AS daily_revenue
    FROM retail_sales
    GROUP BY sale_date
)

SELECT
    sale_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY sale_date) AS running_total
FROM daily_sales;


-- Q23. Highest transaction in each month

SELECT
    EXTRACT(MONTH FROM sale_date) AS month,
    MAX(total_sale) AS highest_sale
FROM retail_sales
GROUP BY month
ORDER BY month;


-- Q24. Number of purchases made by each customer

SELECT
    customer_id,
    COUNT(*) AS purchase_count
FROM retail_sales
GROUP BY customer_id
ORDER BY purchase_count DESC;


-- Q25. Top spending customer in each category

WITH customer_category_sales AS (
    SELECT
        category,
        customer_id,
        SUM(total_sale) AS total_spent
    FROM retail_sales
    GROUP BY category, customer_id
)

SELECT *
FROM (
    SELECT
        category,
        customer_id,
        total_spent,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_spent DESC
        ) AS rank_no
    FROM customer_category_sales
) ranked_customers
WHERE rank_no = 1;


/*
=========================================
End of SQL Retail Sales Analysis Project
=========================================
*/