-- Create the new aggregated table for return rate 
DROP TABLE IF EXISTS monthly_sales_returns;

CREATE TABLE monthly_sales_returns AS
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', invoicedate) AS month,
        SUM(quantity) AS sold_qty
    FROM retail_clean
    GROUP BY month
),
monthly_returns AS (
    SELECT
        DATE_TRUNC('month', invoicedate) AS month,
        SUM(-quantity) AS returned_qty  -- flip negative returns to positive
    FROM online_retail_returns
    GROUP BY month
)
SELECT
    s.month,
    s.sold_qty,
    r.returned_qty,  
    r.returned_qty::numeric / NULLIF(s.sold_qty, 0) AS return_rate
FROM monthly_sales s
LEFT JOIN monthly_returns r
    ON s.month = r.month
ORDER BY s.month;

SELECT * FROM monthly_sales_returns