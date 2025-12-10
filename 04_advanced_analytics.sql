-- Create the new aggregated table for return rate by month
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

/* RFM SEGMENTATION ANALYSIS
   -------------------------
   1. Calculate Recency, Frequency, Monetary for each customer.
   2. Score each metric from 1-5 (5 being best) using NTILE.
   3. Group customers into named segments based on their scores.
*/

CREATE OR REPLACE VIEW v_rfm_segmentation AS

WITH rfm_base AS (
    -- Step 1: Calculate raw metrics for each customer
    SELECT 
        customerid,
        MAX(invoicedate) AS last_purchase_date,
        -- Calculate Recency: Days since last purchase (relative to the max date in dataset)
        (SELECT MAX(invoicedate) FROM retail_clean)::date - MAX(invoicedate)::date AS recency_days,
        COUNT(DISTINCT invoiceno) AS frequency,
        SUM(quantity * unitprice) AS monetary
    FROM 
        retail_clean
    WHERE 
        customerid IS NOT NULL
    GROUP BY 
        customerid
),
rfm_scored AS (
    -- Step 2: Assign scores from 1 (worst) to 5 (best)
    SELECT 
        customerid,
        recency_days,
        frequency,
        monetary,
        -- Recency: Lower days = Better score (We invert order so low days get high score)
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        -- Frequency: Higher count = Better score
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        -- Monetary: Higher spend = Better score
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM 
        rfm_base
)
-- Step 3: Define segments based on the "RFM Cell" (string concatenation of scores)
SELECT 
    customerid,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    -- Concatenate scores to create an "RFM Cell" (e.g., '555', '121')
    CAST(r_score AS varchar) || CAST(f_score AS varchar) || CAST(m_score AS varchar) AS rfm_cell,
    -- Assign clear business segments
    CASE 
        WHEN (r_score = 5 AND f_score = 5 AND m_score = 5) THEN 'Champions'
        WHEN (r_score >= 3 AND f_score >= 3 AND m_score >= 3) THEN 'Loyal Customers'
        WHEN (r_score >= 4 AND f_score <= 2) THEN 'New Customers'
        WHEN (r_score <= 2 AND f_score >= 4) THEN 'At Risk'
        WHEN (r_score <= 2 AND f_score <= 2) THEN 'Lost'
        ELSE 'Potential Loyalists'
    END AS customer_segment
FROM 
    rfm_scored;
