/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

GROUPING data (with a side of CASE)

HOMEWORK FILE

Documentation:
https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql
https://docs.microsoft.com/en-us/sql/t-sql/queries/select-having-transact-sql
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql


For best results,  work through this homework and test running the queries (learn by "doing" when you can)

Need some help?
	Join the SQL Community Slack group for discussion: https://t.co/w5LWUuDrqG
	Click the + next to 'Channels' and join #tsqlbeginners

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

Order the results by SUMOrderLines DESC
SELECT only the TOP 5 rows
The query should return 5 rows
*/













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

Get rid of the TOP 5, and now only return rows where SUMOrderLines > 375000 
Order the results by SUMOrderLines DESC

The query should return 3 rows
*/













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















/* 🌮🌮🌮🌮🌮 You're all done! Nice work!  🌮🌮🌮🌮🌮 */