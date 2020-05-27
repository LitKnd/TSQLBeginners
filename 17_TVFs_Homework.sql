/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Table Valued Functions (with a bit of CROSS APPLY)

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

/* 
T7.Q1  

This one has multiple parts: 
    1) write a single statement table valued function (TVF)
       2) write two queries using the TVF function, each in a different way:
            a) Using a subquery in the select for the TVF
            b) Using a cross apply for the TVF

Part 1:
    Write a single-statement table valued TSQL function named dbo.InvoiceCountTVF* 
        Takes an integer parameter for CustomerID
        Returns a one column table
        Counts the number of invoices in the Sales.Invoices table for that CustomerID
        Returns the count of those invoices

* Sorry, bad naming convention, you used dbo.InvoiceCount() for a scalar UDF in the last exercise, though
We're using a different name in case you want to compare them at the same time.

Part 2:
    Write a query using the table valued function
        Using the Sales.Customers table and dbo.InvoiceCountTVF() 
        Query returns the top 10 rows based on the InvoiceCount for that CustomerID (using the function)
        Returns two columns:
            CustomerName
            InvoiceCount, defined as the count of invoices for that customer as determined by dbo.InvoiceCountTVF() 
           2a) Use a subquery in the select for the TVF
           2b) Use a cross apply for the TVF

*/














/* 

This one has multiple parts (same pattern as last question)
    1) write a single statement table valued function (TVF)
       2) write two queries using the TVF function, each in a different way:
            a) Using a subquery in the select for the TVF
            b) Using a cross apply for the TVF


Part 1:
    Write a scalar user defined TSQL function named dbo.InitialsTVF* that doesn't do data access
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

* Sorry, bad naming convention, you used dbo.Initials() for a scalar UDF in the last exercise, though
We're using a different name in case you want to compare them at the same time.



Part 2:
    Write a query with the function
        Using the Application.People table and dbo.InitialsTVF()
        Returns two columns:
            FullName
            Initials, defined as the initials for that fullname calculated by dbo.InitialsTVF() 
        2a) Use a subquery in the select for the TVF
        2b) Use a cross apply for the TVF


*/















/*
T7.Q3
 
Table valued functions can take multiple paramaters, and return more than one column
Also, some built in Dynamic Management Views are TVFs

Let's use one of those!
    https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-index-physical-stats-transact-sql

Using the built in sys.dm_db_index_physical_stats function 
joined to the build in sys.objects table on object_id

Return five columns:
    name - object name, from sys.objects
    avg_fragmentation_in_percent, from sys.dm_db_index_physical_stats
    avg_page_space_used_in_percent, from sys.dm_db_index_physical_stats
    page_count, from sys.dm_db_index_physical_stats

Return rows...
    For the current database only
    For all tables
    For all partitions (this is one of the parameters for sys.dm_db_index_physical_stats, use NULL for all)
    In 'detailed' mode for sys.dm_db_index_physical_stats
    index_id = 1 (clustered indexes only)
    index_level = 0 (leaf of the indexes)

*/











/*
T7.Q4 Two parter - write a TVF, then use it in a query

Q4 a)
    Create a single statement table valued function named dbo.CustomersByStateAndCountry

    The function should take two parameters. Figure out the best data types for them by looking at the column types
    in the tables involved in the query*
        @StateProvinceCode 
        @CountryName

    * I know it's a drag, but in real life this is something you always have to do

    The query in the function should use inner joins on four tables*
        Sales.Customers
        Application.Cities
        Application.StateProvinces
        Application.Countries

    * Yep, gotta figure out the join columns too!

    Return only rows where StateProvinceCode = @StateProvinceCode AND CountryName = @CountryName ;

Q4 b) Write a query that selects all columns and rows from dbo.CustomersByStateAndCountry()
    For the StateProvinceCode 'WA' and the CountryName 'United States'

    This should return 17 rows
*/













/*
T7.Q5 This builds on the previous question and is a THREE parter (but not too hard if you finished that one)
This is the same as the previous question but...

Q5 a)
    Name the single statement TVF CustomersByStateOrCountry (or, not and)
    This time allow  @StateProvinceCode OR @CountryName to be provided

Q5 b)
   Write a query that selects all columns and rows from dbo.CustomersByStateOrCountry()
    For the StateProvinceCode 'WA' and CountryName null

    This should return 17 rows

Q5 c)
   Write a query that selects all columns and rows from dbo.CustomersByStateOrCountry()
    For the StateProvinceCode null and CountryName 'United States'

    This should return 663 rows

*/















