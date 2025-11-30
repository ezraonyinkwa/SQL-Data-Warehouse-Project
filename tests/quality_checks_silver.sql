-- QUALTY CHECKS

--(A.) bronze.crm_cust_info data cleaning 

--Check for nulls or duplicates in primary key
SELECT cst_id,
COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

---Check for unwanted spaces
SELECT * FROM bronze.crm_cust_info;

SELECT cst_firstname
FROM  bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

--- Check for data standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;


--- (B.) bronze.crm_prd_info data cleaning
SELECT TOP (1000) [prd_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [DataWarehouse].[bronze].[crm_prd_info]

  --- 1. Check for nulss or duplcates primary key.
SELECT prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL; ---No duplicates or nulls

--2. Extract prd_key (extract a specific part of a string value.
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,--Position to begin extracting and number of Characters
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key
FROM bronze.crm_prd_info;


--- Check to see what category is not matching to the prd_info ID
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_') NOT IN
(SELECT DISTINCT id from[bronze].[erp_px_cat_g1v2]);

-- Checkfor unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm); --No Unwanted spaces found.

--Data Standadization.
SELECT prd_line
FROM bronze.crm_prd_info;

--Check for Invalid Date Orders
SELECT prd_key,prd_start_dt,
CAST(LAG(prd_start_dt)OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE)AS prd_end_dt
FROM bronze.crm_prd_info


-- (C.) bronze.sales_details data cleaning
SELECT TOP (1000) [sls_ord]
      ,sls_prd
      ,sls_cust_id
      ,sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
  FROM bronze.crm_sales_details;

--Lets check for the sls_prd & sls_cust_id
SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN 
(SELECT DISTINCT cst_id FROM [silver].[crm_cust_info]);--Okay the ID are in both cust_info & prd_info.

---Check for invalid dates
SELECT 
NULLIF(sls_due_dt,0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt = 0 --Checks for nulls
OR LEN(sls_due_dt )!=8 -- Length of the date format is not like the noraml of 8 digits
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

--Check for unproper dates in terms of the order date & the other dates
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt; --Dates are okay

--Lets check for the sales and where the formula is not applied.
SELECT DISTINCT
sls_ord,
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales ! = sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0
ORDER BY sls_sales , sls_price,sls_quantity;


--ERP DATA CLEANING
--silver.erp_cust_az12 data cleaning
SELECT 
cid,
bdate,
gen
FROM bronze.erp_cust_az12;

--Lets check for out of range dates
SELECT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate > GETDATE(); --Checks for people born on dates that are after the current date

--Data Standardization
SELECT DISTINCT
gen
FROM bronze.erp_cust_az12;

--silver.erp_loc_a101 Data cleaning
SELECT
cid,
cntry
FROM bronze.erp_loc_a101

---[silver].[erp_px_cat_g1v2] data cleaning
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info)

-- Checking or unwanted space
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat !=TRIM(subcat) OR maintenance !=TRIM(maintenance); -- Clean

SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2

SELECT * 
FROM bronze.erp_px_cat_g1v2

