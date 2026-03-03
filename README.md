## SQL Server to PostgreSQL Data Migration with Validation

### Preface

This project demonstrates a controlled enterprise data migration from SQL Server to PostgreSQL with data quality validation and reconciliation.

The goal is to prove to stakeholders that migration can be completed without data loss, without corruption, and with verifiable accuracy before approval for production rollout.

#### Problem Statement

- The organization is facing:
- High SQL Server licensing costs
- Slower reporting query performance
- A strategic decision to migrate to cloud infrastructure (AWS + PostgreSQL)
- PostgreSQL is significantly cheaper and scalable

However, management will not approve migration until the Data Engineering team proves in UAT (User Acceptance Testing) that migration works perfectly.

#### What Does Success Look Like?
- All 4 tables successfully migrated to PostgreSQL
- No data loss
- All data quality checks pass

- Tables in Scope
    - Categories
    - Customers
    - Products
    - Suppliers

- Row Count Audit (SQL Server)

        - We first validate row counts in SQL Server.

        SELECT 
            'Categories' AS table_name,
            COUNT(*) AS total_rows
        FROM [TransactionDB_UAT].[dbo].[Categories]

        UNION ALL

        SELECT
            'Customers',
            COUNT(*)
        FROM [TransactionDB_UAT].[dbo].[Customers]

        UNION ALL

        SELECT
            'Products',
            COUNT(*)
        FROM [TransactionDB_UAT].[dbo].[Products]

        UNION ALL

        SELECT
            'Suppliers',
            COUNT(*)
        FROM [TransactionDB_UAT].[dbo].[Suppliers];

![Query](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/Query.png)
  
    - Total Rows Using CTE
        WITH sql_server_table_count AS (

        SELECT 'Categories' AS table_name, COUNT(*) AS total_rows
        FROM [TransactionDB_UAT].[dbo].[Categories]

        UNION ALL
        SELECT 'Customers', COUNT(*) FROM [TransactionDB_UAT].[dbo].[Customers]

        UNION ALL
        SELECT 'Products', COUNT(*) FROM [TransactionDB_UAT].[dbo].[Products]

        UNION ALL
        SELECT 'Suppliers', COUNT(*) FROM [TransactionDB_UAT].[dbo].[Suppliers]

        )

        SELECT FORMAT(SUM(total_rows), '#,0') AS grand_total_rows
        FROM sql_server_table_count;
      
![CTE](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/CTE.png)

- Result
1,055,008 rows


### This becomes our baseline for migration validation.

- What Good Data Quality Looks Like

        - Row count equals 1,055,008
        - No NULL values in required fields
        - No orphaned foreign keys
        - No negative numeric values
        - No future dates

- Post-Migration Validation

        - Row counts match between SQL Server and PostgreSQL
        - Data types match
        - No duplicated primary keys
        - Tables join correctly

- Data Architecture

        - Audit data (Before migration)
        - Extract from SQL Server
        - Transform data
        - Load into PostgreSQL
        - Validate results

![sqlserver-postfress.gif](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/sqlserver-postgres.gif)

### Tools & Technologies
    - SQL Server
    - PostgreSQL
    - Python
    - Jupyter Notebook
    - pyodbc
    - psycopg2
    - pandas
    - matplotlib

### Pseudocode
- High-Level

        - Audit SQL Server data
        - Extract data
        - Transform data
        - Load to PostgreSQL
        - Validate results
        - Generate validation report

- Low-Level

        - Create .env file
        - Load environment variables
        - Connect to SQL Server (pyodbc)
        - Connect to PostgreSQL (psycopg2)
        - For each table:
            - Get row count
            - Extract rows
            - Convert column names to lowercase
            - Convert data types
            - Create PostgreSQL table
            - Load data
            - Run post-migration checks
            - Generate validation report

Below are the data quality issues identified in SQL Server before migration (migrated as-is):

     - 4,514 customers with NULL names...
                     -- Count NULL names
                    SELECT COUNT(*) 
                    FROM [TransactionDB_UAT].[dbo].[Customers] 
                    WHERE CustomerName IS NULL;
                    -- NULL - 4,514
                    -- 4,514 customer records have missing names

    ![Customers with Null name.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/Customers%20with%20Null%20name.png)

             "We identified duplicate customer names and missing customer name values. Since CustomerName is not a unique identifier, CustomerID will be used for referential integrity and migration validation."
    - 8,844 emails with invalid email formats...

    ![Invalid email.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/Invalid%20email.png)

    - 775 prices contain negative prices - 775 products contain negative stock values — migrated as-is but flagged for business review.

    ![Product with negative price.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/product%20with%20negative%20price.png)

    - 1,467 products with negative stock...

    ![Product with negative stock.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/products%20with%20negative%20stocks.png)

    - 24,700 products with orphaned foreign keys...

    ![products with orphaned foreign key.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/products%20with%20orphaned%20foreign%20key.png)


    - 2,693 customers with future creations data later than current date...

    ![Customers with future dates.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/Customers%20with%20future%20dates.png)


## Design Decisions

    - Migration performed table-by-table to reduce memory pressure
    - Column names standardized to lowercase for PostgreSQL conventions
    - Data migrated as-is to preserve source-of-truth
    - Validation performed using row counts and primary key checks

Bar chart comparing row counts between SQL Server and PostgreSQL after migration.

![migration_validation_chart.png](https://github.com/adetonayusuf/sql-server-to-postgres-migration/blob/main/docs/migration_validation_chart.png)

### Outcome

Migration completed successfully

1,055,008 rows validated

100% reconciliation between source and target

Zero data loss

### Key Skills Demonstrated

- Data Engineering
- ETL Pipeline Design
- Data Validation & Reconciliation
- SQL Optimization
- Python Automation
- Cloud-ready Architecture
