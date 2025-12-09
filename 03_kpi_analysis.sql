-- Total revenue
SELECT SUM(quantity * unitprice) AS total_revenue FROM online_retail;

-- Monthly revenue
SELECT date_trunc('month', invoicedate) AS month, SUM(quantity * unitprice) AS revenue
FROM online_retail
GROUP BY month
ORDER BY month;

-- Top 10 products by quantity
SELECT description, SUM(quantity) AS units_sold
FROM online_retail
GROUP BY description
ORDER BY units_sold DESC
LIMIT 10;

-- Monthly active customers
SELECT DATE_TRUNC('month', invoicedate) AS month,
       COUNT(DISTINCT customerid) AS active_customers
FROM online_retail
GROUP BY 1;

-- Monthly active customers (cleaned)
SELECT DATE_TRUNC('month', invoicedate) AS month,
       COUNT(DISTINCT customerid) AS active_customers
FROM retail_clean
GROUP BY 1;

-- Monthly average order value
SELECT DATE_TRUNC('month', invoicedate) AS month,
       SUM(quantity * unitprice) / COUNT(DISTINCT invoiceno) AS aov
FROM online_retail
GROUP BY 1;

-- Revenue by Country
SELECT country,
       ROUND(SUM(quantity * unitprice),2) AS revenue
FROM online_retail
GROUP BY country
ORDER BY revenue DESC;

-- Number of negative or 0 values for quantity (returns)
SELECT COUNT(*) FROM online_retail 
WHERE quantity <=0

-- Cleaned top 10 best sellers by quantity
SELECT stockcode, description,
       SUM(quantity) AS total_sold
FROM retail_clean
GROUP BY 1,2
ORDER BY total_sold DESC
LIMIT 10;

-- Top 10 return offenders
SELECT stockcode, description,
       ABS(SUM(quantity)) AS total_returns
FROM online_retail_returns
GROUP BY 1,2
ORDER BY total_returns DESC
LIMIT 10;

SELECT
    StockCode,
    Description,
    SUM(Quantity * UnitPrice) AS Product_Revenue

-- Revenue Contribution by Product
FROM
    online_retail -- Use your primary sales table
WHERE
    Quantity > 0 AND UnitPrice > 0 -- Exclude returns/invalid transactions
GROUP BY
    StockCode,
    Description
ORDER BY
    Product_Revenue DESC;
