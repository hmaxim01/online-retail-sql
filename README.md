# online-retail-sql

## Overview
This project involves a comprehensive data analysis of a UK-based online retail dataset, focusing on customer behavior, sales trends, and key performance indicators (KPIs). The analysis was performed entirely using SQL to demonstrate proficiency in data cleaning, transformation, and complex analytical queries.

Database: PostgreSQL (v18)
SQL Client: pgAdmin 4
Visualization: Microsoft Power BI
Data Cleaning and Transformation: SQL

## Key business questions answered
1.  Sales Performance: What are the monthly revenue trends and Average Order Value (AOV)?
2.  Customer Retention: How well does the company retain customers over time? (Cohort Analysis)
3.  Returns Analysis: Which products suffer the highest return rates, and what is the monthly financial impact?
4.  Customer Segmentation: Who are the most valuable customers based on Recency, Frequency, and Monetary (RFM) scores?
5.  Geographic Trends: Which countries drive the most revenue outside of the UK?

## 🧹 Data Cleaning & Modeling Strategy
Raw data often contains errors. Before analysis, I performed the following SQL cleaning steps:
 Handling Missing Values: Identified and handled over 130,000 rows with missing `CustomerID`s (treated as anonymous transactions).
 Return Separation: Separated negative quantity transactions (returns) into a distinct table (`online_retail_returns`) to accurately calculate "Net Sales" vs. "Gross Sales."
 Outlier Removal: Filtered out bad data such as zero unit prices and test transactions.
 Data Type Casts: Converted string dates to proper `TIMESTAMP` formats for time-series analysis.

 ## 📊 Key SQL Analyses
### 1. Cohort Retention Analysis
Used complex SQL **Window Functions** to group customers by their first purchase month and track their activity over subsequent months to calculate a retention rate curve.

### 2. Monthly Return Rate
Created a dynamic view combining sales and returns tables to track the percentage of items returned month-over-month.

### 3. RFM Segmentation
Scored customers on a scale of 1-5 for Recency, Frequency, and Monetary value to categorize them into segments like "Champions," "Loyal Customers," and "At Risk."

## 📈 Power BI Dashboard
The SQL views were imported into Power BI to create a dynamic dashboard with the following pages:
* **Executive Summary:** High-level KPIs (Total Revenue, Total Customers, Return Rate).
* **Customer Insights:** Cohort retention heatmaps and new vs. returning customer trends.
* **Product Performance:** Top 10 best-sellers and top 5 "return offenders."
* **Geographic Analysis:** Revenue heatmap by country.

* ## 📂 Repository Structure
* `sql/`: Contains all SQL scripts for table creation, cleaning, and analysis views.
* `data/`: Sample extract of the dataset (or link to source).
* `screenshots/`: Images of the final Power BI dashboard and key SQL query outputs.
