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

SQL Server → Python ETL → PostgreSQL → Validation Report

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

Low-Level

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

📊 Sample Output

Bar chart comparing row counts between SQL Server and PostgreSQL after migration.

/images/migration_validation_chart.png

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