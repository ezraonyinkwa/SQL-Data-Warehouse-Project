/*
==============================================================================
Create Database 'DataWarehouse'
==============================================================================
Script Purpose :
      The script creates a new database named 'DataWarehouse' after checking if it already exists.If the databse exists,
      it is dropped and recreated.Additionally, the scripts sets up schemas: bronze , silver and gold.
WARNING:
        Running this script will drop the entire 'Datawarehouse' database if it exists.
        All data in the database will be permanently deleted.Proceed with caution ad ensure you
        have backups before running this script.
*/

USE master;
GO
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
      ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
      DROP DATABASE DataWarehouse
END;
GO
CREATE DATABASE DataWarehouse;

USE DataWarehouse; ---Switching into the new database

---Creating the Schemas
CREATE SCHEMA bronze;
GO --Separator
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
