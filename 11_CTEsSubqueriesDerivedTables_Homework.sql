/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

CTEs, Subqueries, and Derived Tables: oh, my!

HOMEWORK FILE
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








/* 
Q4
Using the Applications.Countries and Applications.StateProvinces tables

Return a distinct list of CountryNames for countries which DO have a related row in StateProvinces

Return one column:  CountryName

USE an EXISTS with a correlated subquery in your WHERE clause
Do not use DISTINCT or IN, do not use a CTE or a derived table.

This should return one row.
*/









/* 
Q5 & Q6
Using the Sales.Orders, Sales.Customers, and Sales.Cities tables...

Return 4 columns:
    CityID
    CityName
    CustomerCount - defined as the count of unique customers in that CityID
    OrderCount - defined as the count of unique OrderIDs for Customers whose DeliveryCityID matches that CityID

Only return rows for CityIDs having > 1 CustomerID
Do return 

Write this query two ways:
T5.Q5 First, with two CTES:
        One CTE queries the OrderCount for the DeliveryCityID
        Another CTE queries the CityID, CityName, and CustomerCount for CityIDs with > 1 CustomerID
        Join the two CTEs to get the results
T5.Q6 Next, rewrite this with derived tables instead of CTES:
        One derived table queries the OrderCount for the DeliveryCityID
        Another derived table queries the CityID, CityName, and CustomerCount for CityIDs with > 1 CustomerID
        Join the two derived tables to get the results

Each query should return 8 rows
*/














/* 
Q7, Q8, Q9
Using only the Sales.Customers table

Return one column: CustomerName

Return the CustomerName(s) for the customer(s) who have the maximum CreditLimit in Sales.Customers

Write the query multiple ways:
    Q7 using a subquery in the WHERE clause
    Q8 using one CTE
    Q9 using a derived table
*/

--Q7 using a subquery in the WHERE clause







--Q8 using one CTE







--Q9 using a derived table







