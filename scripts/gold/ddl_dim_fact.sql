--Creating the dimension products data and view
IF OBJECT_ID('gold.dim_products ', 'V') IS NOT NULL
    DROP VIEW gold.dim_products ;
GO
CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER () OVER (ORDER BY pn.prd_start_dt,pn.prd_key ) AS product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_number,
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintenance,
pn.prd_cost AS product_cost,
pn.prd_line AS product_line,
pn.prd_start_dt AS product_start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id=pc.id
WHERE prd_end_dt IS NULL --- Filter Out all historical data

IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer;
GO
CREATE VIEW gold.dim_customer AS
SELECT
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS customer_firstname,
ci.cst_lastname AS customer_lastname,
ci.cst_marital_status marital_status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --- CRM is the master or gender
ELSE COALESCE (ca.gen,'n.a')
END AS gender,
cst_create_date AS create_date,
ca.bdate AS birthdate,
la.cntry AS Country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid


IF OBJECT_ID('fact_sales ', 'V') IS NOT NULL
    DROP VIEW fact_sales ;
GO
CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS sales_due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd = pr.product_number
LEFT JOIN gold.dim_customer cu
ON sd.sls_cust_id = cu.customer_id
