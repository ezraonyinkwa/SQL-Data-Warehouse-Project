============================================
checking gold.dim_customer
=============================================
-------check for uniqueness of customer key in gold.dim_customer
----Expectation no result
SELECT 
customer_key,
COUNT (*) AS duplicate_count
FROM gold.dim_cutomer
GROUP BY customer_key
HAVING COUNT(*) > 1;

---Checking for correctness and compatibility of the two tables
---Expectation return nothing

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL
