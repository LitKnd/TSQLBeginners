/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

CTEs, Subqueries, and Derived Tables: oh, my!

SOLUTION FILE
*****************************************************************************/


/* ✋🏻 Doorstop ✋🏻  */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO

USE WideWorldImporters;
GO

--Run this to simplify execution plans
--https://littlekendra.com/2017/01/26/whats-that-garbage-in-my-execution-plan-dear-sql-dba-episode-26/
DROP SECURITY POLICY IF EXISTS [Application].[FilterCustomersBySalesTerritoryRole];
GO

/******************************************************************************

The first four questions challenge you to write the SAME query four different ways

*****************************************************************************/

/* 
Q1
Using the Applications.Countries and Applications.StateProvinces tables

Return a distinct list of CountryNames for countries which DO have a related row in StateProvinces

Return one column: CountryName

USE an IN clause with a subquery in your WHERE clause
Do not use DISTINCT or EXISTS, do not use a CTE or a derived table

This should return one row.
*/
SELECT c.CountryName
FROM Application.Countries AS c
WHERE CountryID IN
      (
          SELECT CountryID FROM Application.StateProvinces
      );

--Compare the plan to:
SELECT DISTINCT
       c.CountryName
FROM Application.Countries AS c
    INNER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO





/* 
Q2
Using the Applications.Countries and Applications.StateProvinces tables

Return a distinct list of CountryNames for countries which DO have a related row in StateProvinces

Return one column: CountryName

Join to a derived table to get back the DISTINCT list of CountryIDs which are in Applications.StateProvinces
Do not use IN
Use DISTINCT only inside the derived table definition, do not use a CTE.

This should return one row.
*/
SELECT c.CountryName
FROM Application.Countries AS c
    JOIN
    (SELECT DISTINCT CountryID FROM Application.StateProvinces) AS sp
        ON c.CountryID = sp.CountryID

--Compare the plan to:
SELECT DISTINCT
       c.CountryName
FROM Application.Countries AS c
    INNER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO

--What if we didn't use DISTINCT?
SELECT c.CountryName
FROM Application.Countries AS c
    JOIN
    (SELECT CountryID FROM Application.StateProvinces) AS sp
        ON c.CountryID = sp.CountryID


/* 
Q3
Using the Applications.Countries and Applications.StateProvinces tables

Return a distinct list of CountryNames for countries which DO have a related row in StateProvinces

Return one column: CountryName

Join to a cte to get back the DISTINCT list of CountryIDs which are in Applications.StateProvinces
Do not use IN
Only use DISTINCT inside the cte definition, do not use a derived table

This should return one row.
*/

WITH sp
AS (SELECT DISTINCT
           CountryID
    FROM Application.StateProvinces)
SELECT c.CountryName
FROM Application.Countries AS c
    JOIN sp
        ON c.CountryID = sp.CountryID;


--Compare the plan to:
SELECT DISTINCT
       c.CountryName
FROM Application.Countries AS c
    INNER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO



/* 
Q4
Using the Applications.Countries and Applications.StateProvinces tables

Return a distinct list of CountryNames for countries which DO have a related row in StateProvinces

Return one column:  CountryName

USE an EXISTS with a correlated subquery in your WHERE clause
Do not use DISTINCT or IN, do not use a CTE or a derived table.

This should return one row.
*/
SELECT c.CountryName
FROM Application.Countries AS c
WHERE EXISTS
(
    SELECT 1
    FROM Application.StateProvinces AS p
    WHERE c.CountryID = p.CountryID
);

--Compare the plan to:
SELECT DISTINCT
       c.CountryName
FROM Application.Countries AS c
    INNER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO

/* Question: is this really a "correlated" or "repeating" subquery? */


--Weird trick: run the whole query
--Then run only : SELECT 1/0
--Why does the whole query work?!?!
SELECT c.CountryName
FROM Application.Countries AS c
WHERE EXISTS
(
    SELECT 1/0
    FROM Application.StateProvinces AS p
    WHERE c.CountryID = p.CountryID
);



/* 
Q5  & Q6
Using the Sales.Orders, Sales.Customers, and Sales.Cities tables...

Return 4 columns:
    CityID
    CityName
    CustomerCount - defined as the count of unique customers in that CityID
    OrderCount - defined as the count of unique OrderIDs for Customers whose DeliveryCityID matches that CityID

Only return rows for CityIDs having > 1 CustomerID
Do return 

Write this query two ways:
Q5 First, with two CTES:
        One CTE queries the OrderCount for the DeliveryCityID
        Another CTE queries the CityID, CityName, and CustomerCount for CityIDs with > 1 CustomerID
        Join the two CTEs to get the results
Q6 Next, rewrite this with derived tables instead of CTES:
        One derived table queries the OrderCount for the DeliveryCityID
        Another derived table queries the CityID, CityName, and CustomerCount for CityIDs with > 1 CustomerID
        Join the two derived tables to get the results

Each query should return 8 rows
*/


WITH orders
AS (SELECT sc.DeliveryCityID,
           COUNT(OrderID) AS OrderCount
    FROM Sales.Orders AS so
        JOIN Sales.Customers AS sc
            ON so.CustomerID = sc.CustomerID
    GROUP BY sc.DeliveryCityID),
     deliverycities
AS (SELECT ct.CityID,
           ct.CityName,
           COUNT(c.CustomerID) AS CustomerCount
    FROM Sales.Customers AS c
        JOIN Application.Cities AS ct
            ON c.DeliveryCityID = ct.CityID
    GROUP BY ct.CityID,
             ct.CityName
    HAVING COUNT(c.CustomerID) > 1)
SELECT deliverycities.CityID,
       deliverycities.CityName,
       deliverycities.CustomerCount,
       orders.OrderCount
FROM deliverycities
    LEFT OUTER JOIN orders
        ON deliverycities.CityID = orders.DeliveryCityID
ORDER BY CustomerCount DESC;
GO


SELECT deliverycities.CityID,
       deliverycities.CityName,
       deliverycities.CustomerCount,
       orders.OrderCount
FROM
(
    SELECT ct.CityID,
           ct.CityName,
           COUNT(c.CustomerID) AS CustomerCount
    FROM Sales.Customers AS c
        JOIN Application.Cities AS ct
            ON c.DeliveryCityID = ct.CityID
    GROUP BY ct.CityID,
             ct.CityName
    HAVING COUNT(c.CustomerID) > 1
) AS deliverycities
    LEFT OUTER JOIN
    (
        SELECT sc.DeliveryCityID,
               COUNT(OrderID) AS OrderCount
        FROM Sales.Orders AS so
            JOIN Sales.Customers AS sc
                ON so.CustomerID = sc.CustomerID
        GROUP BY sc.DeliveryCityID
    ) AS orders
        ON deliverycities.CityID = orders.DeliveryCityID
ORDER BY CustomerCount DESC;
GO


/* 
Q7 - Q9
Using only the Sales.Customers table

Return one column: CustomerName

Return the CustomerName(s) for the customer(s) who have the maximum CreditLimit in Sales.Customers

Write the query multiple ways:

Q7 using a subquery in the WHERE clause
Q8 using one CTE
Q9 using a derived table
*/


--using a subquery in the WHERE clause
SELECT CustomerName
FROM Sales.Customers
WHERE CreditLimit =
(
    SELECT MAX(CreditLimit) FROM Sales.Customers
)
GO

SELECT CustomerName
FROM Sales.Customers
WHERE CreditLimit IN /* This implies more than one row, 
            and it's a MAX, which will only return one row -- 
            but this still works. */
      (
          SELECT MAX(CreditLimit) FROM Sales.Customers
      );
GO

--Q8 using one CTE
WITH maxcred
AS (SELECT MAX(CreditLimit) AS limit
    FROM Sales.Customers)
SELECT c.CustomerName
FROM Sales.Customers AS c
    JOIN maxcred
        ON maxcred.limit = c.CreditLimit;
GO

--Q9 using a derived table
SELECT c.CustomerName
FROM Sales.Customers AS c
    JOIN
    (SELECT MAX(CreditLimit) AS limit FROM Sales.Customers) AS maxcred
        ON maxcred.limit = c.CreditLimit;
GO

