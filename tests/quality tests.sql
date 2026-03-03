-- Prodcts with Negative Stocks

SELECT COUNT(*) AS negative_stock_count
FROM Products
WHERE StockQuantity < 0;

-- Details of the negative stocks
SELECT ProductID,
       ProductName,
       StockQuantity
FROM Products
WHERE StockQuantity < 0
ORDER BY StockQuantity ASC;


-- Prodcts with Negative Price

SELECT COUNT(*) AS product_negative_price
FROM Products
WHERE UnitPrice < 0;

-- Details of the negative price
SELECT ProductID,
       ProductName,
       UnitPrice
FROM Products
WHERE UnitPrice < 0
ORDER BY UnitPrice ASC;

-- Products with orphaned foreign keys
SELECT COUNT(*)
FROM Products p
LEFT JOIN Suppliers s
    ON p.SupplierID = s.SupplierID
WHERE s.SupplierID IS NULL;

-- Number of customers with Null Names
SELECT COUNT(*)
FROM Customers
WHERE CustomerName IS NULL;


-- No of customers with future dates
SELECT COUNT(*) AS future_dated_customers
FROM Customers
WHERE CreatedDate > GETDATE();


-- Details of customers with future dates
SELECT CustomerID,
       CustomerName,
       CreatedDate
FROM Customers
WHERE CreatedDate > GETDATE()
ORDER BY CreatedDate DESC;











