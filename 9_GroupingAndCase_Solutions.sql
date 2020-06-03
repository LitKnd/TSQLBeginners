/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

GROUPING data (with a side of CASE)

SOLUTION FILE
*****************************************************************************/

/* Doorstop */
RAISERROR(N'Did you mean to run the whole thing?',20,1) WITH LOG;
GO

USE WideWorldImporters;
GO


/* 
Q1

Using the Sales.OrderLines table
Aggregate the average of the Quantity column for the entire table

SELECT one column:
    AvgQuantity returned with datatype NUMERIC(10,1)

Your calculation should be precise to one decimal point
Your query should return one row
*/

--Compare these two. Which one is correct?
SELECT 
    CAST(
        AVG(Quantity)
    as NUMERIC(10,1)) as AvgQuantity
FROM Sales.OrderLines;
GO
SELECT 
    CAST(
        AVG(
            CAST(Quantity as NUMERIC(10,1))
        )
    as NUMERIC(10,1)) as AvgQuantity
FROM Sales.OrderLines;
GO





/* 
Q2

Using the Application.People table
SELECT the count of all phone numbers in the table AND the count of unique phone numbers in the table

SELECT these columns:
    CountPhoneNumbers, the count of all the phone numbers (including duplicates), but NOT null phone numbers
    CountDistinctPhoneNumbers, the count of unique phone numbers in the table

Your query should return one row

Tips: 
      Our examples didn't show the easiest way to do this, but you can find it in the documentation 
        https://docs.microsoft.com/en-us/sql/t-sql/functions/count-transact-sql
*/

--COUNT(*) counts all rows, doesn't care about NULLS
--COUNT(columnname) returns the number of non-null values (ALL is implied)
--COUNT(DISTINCT columname) returns the number of unique non-null values
SELECT 
    COUNT(*) as CountAllRowsIncludingNULLS,
    COUNT(PhoneNumber) as CountPhoneNumbers,
    COUNT(DISTINCT PhoneNumber) as CountDistinctPhoneNumbers
FROM Application.People;
GO

--So the answer is:
SELECT 
    COUNT(ALL PhoneNumber) as CountPhoneNumbers,
    COUNT(DISTINCT PhoneNumber) as CountDistinctPhoneNumbers
FROM Application.People;
GO


/* 
Q3

Using the Sales.Orders table and Sales.OrderLines tables (inner join on OrderID)

Aggregate the SUM and MAX for (UnitPrice * Quantity) for all orders for the Customer
Then select the TOP 5 customers based on the SUM of (UnitPrice * Quantity)  for all their orders

SELECT these columns:
    Column 1: CustomerID
    Column 2: SUMOrderLines, 
        defined as the sum of (UnitPrice * Quantity) for every OrderLine for that customer
    Column 3: MAXOrderLines, 
        defined as the maximum of (UnitPrice * Quantity) for every OrderLine for that customer

Only return rows where the Order has OrderLines
Order the results by SUMOrderLines DESC
SELECT only the TOP 5 rows
The query should return 5 rows
*/


SELECT TOP 5
    o.CustomerID,
    SUM(ol.UnitPrice * ol.Quantity) as SUMOrderLines,
    MAX(ol.UnitPrice * ol.Quantity) as MAXOrderLines
FROM Sales.Orders as o 
JOIN Sales.OrderLines as ol on
    o.OrderID = ol.OrderID
GROUP BY 
    o.CustomerID
ORDER BY SUMOrderLines DESC;
GO


--This could also be written as...
SELECT TOP 5
    o.CustomerID,
    SUM(ol.UnitPrice * ol.Quantity) as SUMOrderLines,
    MAX(ol.UnitPrice * ol.Quantity) as MAXOrderLines
FROM Sales.Orders as o 
JOIN Sales.OrderLines as ol on
    o.OrderID = ol.OrderID
GROUP BY 
    o.CustomerID
ORDER BY SUM(ol.UnitPrice * ol.Quantity) DESC;
GO




/* 
Q4
This builds on the previous question, so take your query and modify it (or start fresh if you prefer)

Using the Sales.Orders table and Sales.OrderLines tables (inner join on OrderID)
    Add a join to Sales.Customers on CustomerID
    Add a join to Sales.CustomerCategories on CustomerCategoryID

Group at more than one level: CustomerCategoryName, then CustomerName

SELECT these columns:
    Column 1: CustomerCategoryName
    Column 2: CustomerName
    Column 3: SUMOrderLines, 
        defined as the sum of (UnitPrice * Quantity) for every OrderLine for that customer in that category
    Column 4: MAXOrderLines, 
        defined as the maximum of (UnitPrice * Quantity) for every OrderLine for that customer in that category

Only return rows where the Order has OrderLines

Get rid of the TOP 5, and now only return rows where SUMOrderLines > 375000 
Order the results by SUMOrderLines DESC

The query should return 3 rows
*/

SELECT 
    cc.CustomerCategoryName,
    c.CustomerName,
    SUM(ol.UnitPrice * ol.Quantity) as SUMOrderLines,
    MAX(ol.UnitPrice * ol.Quantity) as MAXOrderLines
FROM Sales.Orders as o 
JOIN Sales.OrderLines as ol on
    o.OrderID = ol.OrderID
JOIN Sales.Customers as c on
    o.CustomerID = c.CustomerID
JOIN Sales.CustomerCategories as cc on
    c.CustomerCategoryID = cc.CustomerCategoryID
GROUP BY 
    cc.CustomerCategoryName,
    c.CustomerName
HAVING SUM(ol.UnitPrice * ol.Quantity)  > 375000 
ORDER BY SUMOrderLines DESC;
GO




/* 
Q5

Using only the Application.People table

Return two columns: 
    FullName
    SalespersonType, a column defined as:
        When IsEmployee = 1 and IsSalesperson = 1, return "WWI Sales"
        When IsEmployee = 0 and IsSalesperson = 1, return "Customer Sales"
        When IsEmployee = 1 and IsSalesperson = 0, return "WWI Non-Sales"

Only return rows where IsSalesperson = 1 OR IsEmployee = 1

The query should return 19 rows
*/
SELECT 
    FullName,
    CASE IsEmployee WHEN 1 THEN 'WWI ' ELSE 'Customer ' END + 
        CASE IsSalesperson WHEN 1 THEN 'Sales' ELSE 'Non-Sales' END  
        AS SalespersonType
FROM Application.People
WHERE 
    IsSalesperson = 1
    OR IsEmployee = 1;
GO


/* 
Q6

Using the Sales.Orders table and Sales.Customers table
    (inner join on CustomerID)

Count the number of Orders which have a BackOrderID that is not null (and related calculations)

SELECT three columns:
    Column 1: CustomerName
    Column 2: [Number Backordered], 
        defined as the total number of rows in Sales.Orders for that customer where BackOrderID is not NULL
    Column 3: [Number NOT Backordered], 
        defined as the total number of rows in Sales.Orders for that customer where BackOrderID is NULL

Order the results by the Number Backordered DESC
The query should return 663 rows
*/

--This could be done with CASE
SELECT
    c.CustomerName,
    SUM ( CASE WHEN o.BackorderOrderID IS NULL THEN 0 ELSE 1 END ) as [Number Backordered],
    SUM ( CASE WHEN o.BackorderOrderID IS NULL THEN 1 ELSE 0 END ) as [Number NOT Backordered]
FROM Sales.Orders as o
JOIN Sales.Customers as c on
    o.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerName
ORDER BY [Number Backordered] DESC;

--This could be done even more simply with COUNT
SELECT
    c.CustomerName,
    COUNT(o.BackorderOrderID) as [Number Backordered],
    COUNT(*) - COUNT(o.BackorderOrderID) as [Number NOT Backordered]
FROM Sales.Orders as o
JOIN Sales.Customers as c on
    o.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerName
ORDER BY [Number Backordered] DESC;
GO




--Bonus: check if the result sets are identical (EXCEPT and INTERSECT)
SELECT
    c.CustomerName,
    SUM ( CASE WHEN o.BackorderOrderID IS NULL THEN 0 ELSE 1 END ) as [Number Backordered],
    SUM ( CASE WHEN o.BackorderOrderID IS NULL THEN 1 ELSE 0 END ) as [Number NOT Backordered]
FROM Sales.Orders as o
JOIN Sales.Customers as c on
    o.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerName

EXCEPT
--INTERSECT

SELECT
    c.CustomerName,
    COUNT(o.BackorderOrderID) as [Number Backordered],
    COUNT(*) - COUNT(o.BackorderOrderID) as [Number NOT Backordered]
FROM Sales.Orders as o
JOIN Sales.Customers as c on
    o.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerName
ORDER BY [Number Backordered] DESC;
GO

