-- Moving neg values to a separate table
CREATE TABLE online_retail_returns AS
SELECT *
FROM online_retail
WHERE quantity < 0;

-- Creating a clean normal transactions table
CREATE TABLE retail_clean AS
SELECT *
FROM online_retail
WHERE quantity > 0 
  AND unitprice > 0
  AND customerid IS NOT NULL;