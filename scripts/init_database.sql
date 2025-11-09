USE master;

CREATE DATABASE DataWarehouse;

USE DataWarehouse; ---Switching into the new database

---Creating the Schemas
CREATE SCHEMA bronze;
GO --Separator
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
