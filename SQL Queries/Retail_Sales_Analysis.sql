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