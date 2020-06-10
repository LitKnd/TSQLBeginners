/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Ranking, Numbering, and Running Totals with Windowing Functions

SOLUTION FILE
*****************************************************************************/


/* ✋🏻 Doorstop ✋🏻  */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO



USE WideWorldImporters;
GO

/* Q1

Using the Sales.CustomerTransactions and Sales.Customers tables
    joined on CustomerID


Select four columns:
    CustomerName
    TransactionDate
    TransactionAmount
    RunningTotalByDate, defined as:
        A running total of the TransactionAmount 
        for that CustomerID 
        by TransactionDate Ascending

Return rows only for CustomerID 1057

The query should return 36 rows
*/
SELECT c.CustomerName,
       ct.TransactionDate,
       ct.TransactionAmount,
       SUM(ct.TransactionAmount) OVER (PARTITION BY ct.CustomerID ORDER BY ct.TransactionDate ASC) AS RunningTotalByDate
FROM Sales.CustomerTransactions AS ct
    JOIN Sales.Customers AS c
        ON ct.CustomerID = c.CustomerID
WHERE c.CustomerID = 1057;



--Since we are returning this for only one customer, do we need the "partition by"?
SELECT c.CustomerName,
       ct.TransactionDate,
       ct.TransactionAmount,
       SUM(ct.TransactionAmount) OVER (ORDER BY ct.TransactionDate ASC) AS RunningTotalByDate
FROM Sales.CustomerTransactions AS ct
    JOIN Sales.Customers AS c
        ON ct.CustomerID = c.CustomerID
WHERE c.CustomerID = 1057;
GO




/* Q2

Using the Sales.CustomerTransactions and Sales.Customers tables
    joined on CustomerID


Select four columns:
    TransactionRank, defined as:
        The DENSE_RANK of the row, 
        based on TransactionAmount 
        (highest TransactionAmount in the whole table = #1, etc)
    CustomerName
    TransactionDate
    TransactionAmount

Return only the TOP 10 ranked TransactionAmounts for all time
Make sure the query allows for more than 10 rows to come back if there are ties
*/

--We can *try* this...
SELECT DENSE_RANK() OVER (ORDER BY ct.TransactionAmount DESC) AS TransactionRank,
       c.CustomerName,
       ct.TransactionDate,
       ct.TransactionAmount
FROM Sales.CustomerTransactions AS ct
    JOIN Sales.Customers AS c
        ON ct.CustomerID = c.CustomerID
WHERE DENSE_RANK() OVER (ORDER BY ct.TransactionAmount DESC) <= 10;
GO

--But...
--Msg 4108, Level 15, State 1, Line 85
--Windowed functions can only appear in the SELECT or ORDER BY clauses.


--The wording in this problem could be misunderstood (easily, words are hard)
--If we want to include ranks 1-10, then we do not want to use TOP with TIES

--TOP WITH TIES handles ties *for last place*
--But what if we had a lot of ties for rank #2, for example? We might not get many ranks
SELECT TOP 10 WITH TIES
       DENSE_RANK() OVER (ORDER BY ct.TransactionAmount DESC) AS TransactionRank,
       c.CustomerName,
       ct.TransactionDate,
       ct.TransactionAmount
FROM Sales.CustomerTransactions AS ct
    JOIN Sales.Customers AS c
        ON ct.CustomerID = c.CustomerID
ORDER BY TransactionRank ASC;


--This will show us ranks 1-10, no matter where the ties may be
SELECT *
FROM
(
    SELECT DENSE_RANK() OVER (ORDER BY ct.TransactionAmount DESC) AS TransactionRank,
           c.CustomerName,
           ct.TransactionDate,
           ct.TransactionAmount
    FROM Sales.CustomerTransactions AS ct
        JOIN Sales.Customers AS c
            ON ct.CustomerID = c.CustomerID
) AS t
WHERE t.TransactionRank <= 10
ORDER BY t.TransactionRank;


--You could also write this with a CTE
WITH t
AS (SELECT DENSE_RANK() OVER (ORDER BY ct.TransactionAmount DESC) AS TransactionRank,
           c.CustomerName,
           ct.TransactionDate,
           ct.TransactionAmount
    FROM Sales.CustomerTransactions AS ct
        JOIN Sales.Customers AS c
            ON ct.CustomerID = c.CustomerID)
SELECT *
FROM t
WHERE t.TransactionRank <= 10
ORDER BY TransactionRank;



/* Q3
This is similar to the previous question, however...
    You need to return an additional column, TransactionYear, and...
    You are returning the top 10 ranked transactions for *each* year 
    which has rows in the CustomerTransactions table

Using the Sales.CustomerTransactions and Sales.Customers tables
    joined on CustomerID

Select five columns:
    TransactionYear, defined as:
        The year of the TransactionDate (use the built in YEAR() function)
    TransactionRank, defined as:
        The DENSE_RANK of the row for the year of that TransactionDate, 
        based on TransactionAmount 
        (highest TransactionAmount in the whole table = #1, etc)
    CustomerName
    TransactionDate
    TransactionAmount

Return only the TOP 10 ranked TransactionAmounts for each year
Make sure the query allows for more than 10 rows to come back for each year if there are ties

*/


SELECT *
FROM
(
    SELECT YEAR(ct.TransactionDate) AS TransactionYear,
           DENSE_RANK() OVER (PARTITION BY YEAR(ct.TransactionDate)
                              ORDER BY ct.TransactionAmount DESC
                             ) AS TransactionRank,
           c.CustomerName,
           ct.TransactionDate,
           ct.TransactionAmount
    FROM Sales.CustomerTransactions AS ct
        JOIN Sales.Customers AS c
            ON ct.CustomerID = c.CustomerID
) AS t
WHERE t.TransactionRank <= 10
ORDER BY t.TransactionYear,
         t.TransactionRank;
GO

--this could also be written with a CTE
with t as (
    SELECT YEAR(ct.TransactionDate) AS TransactionYear,
           DENSE_RANK() OVER (PARTITION BY YEAR(ct.TransactionDate)
                              ORDER BY ct.TransactionAmount DESC
                             ) AS TransactionRank,
           c.CustomerName,
           ct.TransactionDate,
           ct.TransactionAmount
    FROM Sales.CustomerTransactions AS ct
        JOIN Sales.Customers AS c
            ON ct.CustomerID = c.CustomerID
) 
SELECT *
FROM t
WHERE t.TransactionRank <= 10
ORDER BY t.TransactionYear,
         t.TransactionRank;
GO




/* Q4
Using the Sales.CustomerTransactions and Sales.Customers tables
    joined on CustomerID

Select six columns:
    CustomerName
    Median, defined as...
        The median AmountExcludingTax for that CustomerID
        Use PERCENTILE_CONT(0.5) to calculate the median
    Average, defined as...
        The average AmountExcludingTax for that CustomerID
    Maxmimum, defined as
        The maximum AmountExcludingTax for that CustomerID
    Minimum, defined as
        The minimum AmountExcludingTax for that CustomerID
    TransactionCount, defined as
        The count of rows for that CustomerID

Return only one row per CustomerID
Order the results by the Median (as defined above) descending

The query should return 263 rows
*/

SELECT DISTINCT
       c.CustomerName,
       PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ct.AmountExcludingTax) OVER (PARTITION BY ct.CustomerID) AS [Median],
       AVG(ct.AmountExcludingTax) OVER (PARTITION BY ct.CustomerID) AS [Average],
       MAX(ct.AmountExcludingTax) OVER (PARTITION BY ct.CustomerID) AS [Maximum],
       MIN(ct.AmountExcludingTax) OVER (PARTITION BY ct.CustomerID) AS [Minimum],
       COUNT(ct.CustomerID) OVER (PARTITION BY ct.CustomerID) AS [TransactionCount]
FROM Sales.CustomerTransactions AS ct
    JOIN Sales.Customers AS c
        ON ct.CustomerID = c.CustomerID
ORDER BY Median DESC;
GO





/* Q5
Table change!
Using the Sales.Customers and Sales.Invoices tables
    joined on CustomerID


Select three columns:
    RankByInvoiceCount, defined as...
        The RANK() of the customer based on the count of invoices
        Highest number of invoices should have RankByInvoiceCount = 1
    CustomerName
    InvoiceCount, defined as...
        The count of invoices for that CustomerName

Return only rows where RankByInvoiceCount < 11
Order the results by RankByInvoiceCount
*/


--USE RANK to rank customers by invoice count
--I defend my use of SELECT * in this particular scenario
--(But feel free too argue with me! )
WITH invoicecounts
AS (SELECT c.CustomerName,
           COUNT(*) AS InvoiceCount
    FROM Sales.Customers AS c
        JOIN Sales.Invoices AS si
            ON c.CustomerID = si.CustomerID
    GROUP BY c.CustomerName),
     rankbyinvoicecounts
AS (SELECT RANK() OVER (ORDER BY ic.InvoiceCount DESC) AS RankByInvoiceCount,
           ic.CustomerName,
           ic.InvoiceCount
    FROM invoicecounts AS ic)
SELECT *
FROM rankbyinvoicecounts
WHERE RankByInvoiceCount < 11
ORDER BY RankByInvoiceCount;
GO
