/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Scalar User Defined Functions (UDFs)

SOLUTION FILE
*****************************************************************************/


/* Doorstop */
RAISERROR(N'Did you mean to run the whole thing?',20,1) WITH LOG;
GO

USE WideWorldImporters;
GO


--Run this to simplify execution plans
--https://littlekendra.com/2017/01/26/whats-that-garbage-in-my-execution-plan-dear-sql-dba-episode-26/
DROP SECURITY POLICY IF EXISTS [Application].[FilterCustomersBySalesTerritoryRole];
GO

/* 
Q1

Script out the definition of the function [Website].[CalculateCustomerPrice] to a new window

(This is a function that ships with the WideWorldImporters database)

Can you see why this would need to execute once per row?

*/



/* Demo: against a SQL Server 2019+ instance run:


SELECT definition, is_inlineable
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('Website.CalculateCustomerPrice')

Documentation on which functions are "inlinable" here: https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/scalar-udf-inlining?view=sql-server-ver15

*/


/* 
Q2

Write a query using the [Website].[CalculateCustomerPrice] function in the WHERE clause:

Using the Sales.Invoices, Sales.InvoiceLines and Sales.Customers tables

Return one column: [Count Over 1K], defined as the count of rows where...

The [Website].[CalculateCustomerPrice] function returns a price > 1000 for:
    That Customer.CustomerId, InvoiceLines.StockItemID, and the hardcoded date 2016-04-01

This should return one row.


Note: this query is an example of when 'observer' effect can be very noticable
This takes 14-18 seconds for me if run without actual plans enabled in SSMS
If I enable actual execution plans, it takes ~1 minute 17 seconds
*/
SELECT COUNT ( * ) AS [Count Over 1K]
FROM Sales.Invoices AS i
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID=il.InvoiceID
JOIN Sales.Customers AS c
    ON i.CustomerID=c.CustomerID
WHERE [Website].[CalculateCustomerPrice] ( c.CustomerID, il.StockItemID, '2016-04-01' ) >1000 ;
GO

/* 
Q3

Build on the query in the previous question...

Write a query using the [Website].[CalculateCustomerPrice] in multiple parts of the query.

Using the Sales.Invoices, Sales.InvoiceLines and Sales.Customers tables

Return three columns: 
    CustomerName (from Sales.Customers)
    CustomerPrice, defined as the calculation from [Website].[CalculateCustomerPrice] for...
        That Customer, The StockItemID on that InvoiceLines item, and the hardcoded date 2016-04-01
    InvoiceLineCount, the count of InvoiceLines for that customer at that price

Return only rows where the [Website].[CalculateCustomerPrice] function returns a price > 1000 for:
    That Customer.CustomerId, InvoiceLines.StockItemID, and the hardcoded date 2016-04-01

Group the rows by:
    CustomerName (from Sales.Customers)
    CustomerPrice (as defined above)

Order the rows by CustomerPrice DESC

This should return 532 rows.

*/
SELECT
    c.CustomerName,
    [Website].[CalculateCustomerPrice] ( i.CustomerID, il.StockItemID, '2016-04-01') AS CustomerPrice,
    COUNT ( il.InvoiceLineID ) AS InvoiceLineCount
FROM Sales.Invoices AS i
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID=il.InvoiceID
JOIN Sales.Customers AS c
    ON i.CustomerID=c.CustomerID
WHERE [Website].[CalculateCustomerPrice] ( i.CustomerID, il.StockItemID,'2016-04-01') >1000
GROUP BY c.CustomerName,
         [Website].[CalculateCustomerPrice] ( i.CustomerID, il.StockItemID,'2016-04-01')
ORDER BY CustomerPrice DESC ;
GO


/* 
Q4

This query uses the same tables as the previous two questions, it may be useful to copy and paste your FROM/JOINs

Write a query that validates the Sales.InvoiceLines.UnitPrice column

Using the Sales.Invoices, Sales.InvoiceLines and Sales.Customers tables

Return one column: 
    InvoiceLineId

Return only rows where 
    The UnitPrice for that row does NOT equal:
    The calculation returned by [Website].[CalculateCustomerPrice]  for that Customer, That StockItemID, and that InvoiceDate

This should return zero rows


*/
SELECT
    il.InvoiceLineID
FROM Sales.Invoices AS i
JOIN Sales.InvoiceLines AS il
    ON i.InvoiceID=il.InvoiceID
JOIN Sales.Customers AS c
    ON i.CustomerID=c.CustomerID
WHERE 
    [Website].[CalculateCustomerPrice] ( i.CustomerID, il.StockItemID, i. InvoiceDate ) 
        <>
     il.UnitPrice;
GO


/* 
Q5  

This one is a 3 parter: write a function, write a query using the function, write the equivalent query NOT using the function.

Part 1:
    Write a scalar user defined TSQL function named dbo.InvoiceCount
        Takes an integer parameter for CustomerID
        Returns an integer
        Counts the number of invoices in the Sales.Invoices table for that CustomerID
        Returns the count of those invoices

Part 2:
    Write a query with the function
        Using the Sales.Customers table and dbo.InvoiceCount() 
        Query returns the top 10 rows based on the InvoiceCount for that CustomerID (using the function)
        Returns two columns:
            CustomerName
            InvoiceCount, defined as the count of invoices for that customer as determined by dbo.InvoiceCount() 

Part 3:
    Write an equivalent query that doesn't use dbo.InvoiceCount() 
        Instead, use both the Sales.Customers and Sales.Invoices tables
*/
CREATE OR ALTER FUNCTION dbo.InvoiceCount(@CustomerID INT)
RETURNS INT
AS
    BEGIN
        DECLARE @InvoiceCOUNT INT ;

        SELECT @InvoiceCOUNT=COUNT ( * )
        FROM Sales.Invoices
        WHERE CustomerID=@CustomerID ;

        RETURN @InvoiceCOUNT ;
    END ;
GO

SELECT TOP 10
    CustomerName,
    dbo.InvoiceCount(CustomerID) AS InvoiceCount
FROM Sales.Customers
ORDER BY dbo.InvoiceCount(CustomerID) DESC;
GO

SELECT TOP 10
    CustomerName,
    COUNT(*) AS InvoiceCount
FROM Sales.Customers AS c
JOIN Sales.Invoices AS i ON
    c.CustomerID = i.CustomerID
GROUP BY c.CustomerName
ORDER BY COUNT(*)  DESC;
GO



/* 

This one is also a 3 parter: write a function, write a query using the function, write the equivalent query NOT using the function.


Part 1:
    Write a scalar user defined TSQL function named dbo.Initials that doesn't do data access
        Takes a parameter @FullName, NVARCHAR(100)
        Returns CHAR(4)
        Create the function WITH SCHEMABINDING
        Determines and returns the initials for the FullName and returns them in the format: F.L.

        Some built in functions that may be helpful determining the initials:
             LEFT ( character_expression , integer_expression )  
             SUBSTRING ( expression , start , length ) 
             CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] )

    Keep this simple and assume:
        * You only care about returning two initials for any name
        * There is only one space in FullName, and it is between the first name and last name
        * Do not worry about capitalization, return the initials as they are in FullName


Part 2:
    Write a query with the function
        Using the Application.People table and dbo.Initials()
        Returns two columns:
            FullName
            Initials, defined as the initials for that fullname calculated by dbo.Initials() 

Part 3:
    Write an equivalent query that doesn't use dbo.Initials()
        Instead, calculate the initials for each fullname in the query itself using only built-in functions

*/

--v1
CREATE OR ALTER FUNCTION dbo.Initials(@FullName NVARCHAR(100))
RETURNS CHAR(4)
WITH SCHEMABINDING
AS
    BEGIN
        DECLARE
            @FirstLetter CHAR(1),
            @SecondLetter CHAR(1) ;

        /* LEFT ( character_expression , integer_expression )   */
        SELECT @FirstLetter = LEFT (@FullName, 1) ;
                        
        /* SUBSTRING ( expression , start , length )   */
        /* CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] ) */
        SELECT @SecondLetter= SUBSTRING ( @FullName, CHARINDEX (  ' ', @FullName ) + 1, 1 ) ;

        RETURN @FirstLetter + N'.' +  @SecondLetter + N'.'  ;
    END ;
GO

--Look at estimated plan
SELECT 
    FullName,
    dbo.Initials(FullName) AS Initials
FROM Application.People;
GO

--v2
CREATE OR ALTER FUNCTION dbo.Initials(@FullName NVARCHAR(100))
RETURNS CHAR(4)
WITH SCHEMABINDING
AS
    BEGIN
        DECLARE
            @FirstLetter CHAR(1),
            @SecondLetter CHAR(1) ;

        --combined these into one assignment
        SELECT @FirstLetter = LEFT (@FullName, 1),
            @SecondLetter= SUBSTRING ( @FullName, CHARINDEX (  ' ', @FullName ) + 1, 1 ) ;

        RETURN @FirstLetter + N'.' +  @SecondLetter + N'.'  ;
    END ;
GO

--Look at estimated plan
SELECT 
    FullName,
    dbo.Initials(FullName) AS Initials
FROM Application.People;
GO


--v3
CREATE OR ALTER FUNCTION dbo.Initials(@FullName NVARCHAR(100))
RETURNS CHAR(4)
WITH SCHEMABINDING
AS
    BEGIN
        --or how about...
        RETURN  LEFT (@FullName, 1) + N'.' + 
            SUBSTRING ( @FullName, CHARINDEX (  ' ', @FullName ) + 1, 1 ) + N'.'  ;

    END ;
GO

--Look at estimated plan
SELECT 
    FullName,
    dbo.Initials(FullName) AS Initials
FROM Application.People;
GO

--Compare to
SELECT 
    FullName,
    LEFT (FullName, 1) + N'.' + SUBSTRING ( FullName, CHARINDEX (  ' ', FullName ) + 1, 1 ) + N'.'  AS Initials
FROM Application.People;
GO