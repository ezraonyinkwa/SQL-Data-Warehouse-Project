EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
      DECLARE @start_time DATETIME , @end_time DATETIME,@batch_start_time DATETIME @batch_end_time DATETIME;
BEGIN TRY
PRINT'===========================================';
PRINT 'Loading Bronze Layer';
PRINT'===========================================';

SET @batch_start_time
	PRINT'-----------------------------------------';
	PRINT 'LOADING CRM Tables';
	PRINT'-----------------------------------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating Table:bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info

	PRINT'>> Inserting Data Into:bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info --- Insert (Full Load)
	FROM 'C:\Users\marieta\OneDrive\Desktop\My Datasets\crm\cust_info.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
);
SET @end_time = GETDATE();
PRINT'>>Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'seconds';
PRINT '--------------------------------------------';--- Checking for the loading time of our queries


SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info

PRINT'>> Inserting Data Into :bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info --- Insert (Full Load)
	FROM 'C:\Users\marieta\onedrive\Desktop\My Datasets\crm\prd_info.CSV'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
);
SET @end_time = GETDATE();
PRINT'>>Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'seconds';
PRINT '--------------------------------------------';


SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details

PRINT'>> Inserting Data Into:bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\marieta\onedrive\Desktop\My Datasets\crm\sales_details.CSV'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
);
SET @end_time = GETDATE();
PRINT'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'seconds';
PRINT '--------------------------------------------';


	PRINT'-----------------------------------------';
	PRINT 'LOADING ERP Tables';
	PRINT'-----------------------------------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating Table:bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12

	PRINT '>> Inserting Data Into:bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\marieta\OneDrive\Desktop\My Datasets\erp\erp_cust_az12.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
);
SET @end_time = GETDATE();
PRINT'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'seconds';
PRINT '--------------------------------------------';


SET @start_time = GETDATE();
	PRINT'>> Truncating Table:bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101

	PRINT'>> Inserting Data Into:bronze.erp_loc_a101';
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\marieta\OneDrive\Desktop\My Datasets\erp\erp_loc_a101.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
);
SET @end_time = GETDATE();
PRINT'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'seconds';
PRINT '--------------------------------------------';


SET @start_time = GETDATE();
	PRINT'>> Truncating Table:bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2

	PRINT'>> Inserting Data Into:bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\marieta\OneDrive\Desktop\My Datasets\erp\erp_px_cat_g1v2.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
);
SET @end_time = GETDATE();
PRINT'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'seconds';
PRINT '--------------------------------------------';


END TRY
BEGIN CATCH
PRINT'===============================================';
PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
PRINT'Error Message'+ ERROR_MESSAGE();
PRINT'Error Message'+ CAST(ERROR_NUMBER()AS NVARCHAR);
PRINT'Error Message'+ CAST(ERROR_STATE()AS NVARCHAR);
PRINT'================================================';
END CATCH
END
--- SQL runs the TRY block,and if it fails , it runs the CATCH block to handle the error.


