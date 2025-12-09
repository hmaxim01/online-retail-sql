DROP TABLE IF EXISTS online_retail;
CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INTEGER,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(12,4),
    CustomerID VARCHAR(20),
    Country TEXT
);
-- Normal Select Function
SELECT * FROM online_retail LIMIT 20;

-- verifying type by column

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'online_retail'
ORDER BY ordinal_position;

-- Row count
SELECT COUNT(*) FROM online_retail;

-- Null / blank checks for important columns
SELECT
  SUM(CASE WHEN invoicedate IS NULL THEN 1 ELSE 0 END) AS missing_invoicedate,
  SUM(CASE WHEN unitprice IS NULL THEN 1 ELSE 0 END) AS missing_unitprice,
  SUM(CASE WHEN customerid IS NULL OR trim(customerid) = '' THEN 1 ELSE 0 END) AS missing_customerid
FROM online_retail;
-- Customerid is missing for about half of the rows
-- many transactions were anonymous

-- Check for invalid rows
SELECT COUNT(*) FROM online_retail WHERE trim(customerid) = ''

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