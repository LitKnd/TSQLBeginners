/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Ranking, Numbering, and Running Totals with Windowing Functions

HOMEWORK FILE
*****************************************************************************/


/* ✋🏻 Doorstop ✋🏻  */
RAISERROR ( N'Did you mean to run the whole thing?', 20, 1 ) WITH LOG ;
GO



USE WideWorldImporters ;
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

Tip: I used a derived table in my sample solution
*/















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

Tip: I used a derived table in my sample solution

*/












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













/* Q5

Note: we're using a differen t table in this one...

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

Tip: I used a CTE in my sample solution
*/




















