/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Introducing SELECTs and Aliasing


SAMPLE SOLUTIONS
*****************************************************************************/


/* ✋🏻 Doorstop ✋🏻  */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO



/* 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮
Homework - WITH SOLUTIONS 
🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 🌮 */

USE WideWorldImporters;
GO


/* 
T2.Q1 

Write a query that SELECTS all the rows from Application.People
Return all columns in the table
    Use a "worst practice" to SELECT every column in the table

GO
*/

--Talk through the query 
SELECT *
FROM Application.People;
GO



/********************************************************************************
Discussion: 
Look at the execution plan (CTRL+M for "actual" execution plan)
Execution plans are a map of how the query is run behind the scenes

You don't need to use these while you are learning TSQL! 
I will show them sometimes when discussing solutions simply to talk about how queries work
And maybe someday you will use these, seeing them as you learn makes them less mysterious

What are those Compute Scalars for?
And how can we learn more about them?
*******************************************************************************/












--Can we see what's in those Compute Scalars?
EXEC sp_help 'Application.People';
GO

SELECT name,
       definition,
       is_persisted
FROM sys.computed_columns AS cc
WHERE cc.object_id = OBJECT_ID('Application.People');
GO


--An advanced aside about persisted computed columns
--Compare with and without the trace flag (176 is 2016+)
--To nerd out on this, see Paul White's article:
--https://sqlperformance.com/2017/05/sql-plan/properly-persisted-computed-columns
SELECT SearchName
FROM Application.People
OPTION (QUERYTRACEON 176);
GO









/* 
T2.Q2


Write a query that SELECTS all the rows from Application.People
Return rows for ONLY three columns:
    FullName 
    PreferredName
    EmailAddress  - alias as: Email
GO
*/

SELECT FullName,
       PreferredName,
       EmailAddress AS [Email]
FROM Application.People;
GO


--Look at the plan. Why is it different from the plan when we were doing "select *"?
--Big picture takeaway: selecting only the columns you need changes how the query is run
--This can help performance in many ways, especially as your queries grow more complex






/* 
T2.Q3

Write a query that SELECTS all the rows from Application.People
Return rows for ONLY three columns:
    FullName 
    PreferredName
    EmailAddress  - alias as: Email
Return ONLY rows where Email has not been entered (NULL)
GO
*/


--IS NULL
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE EmailAddress IS NULL;
GO





/********************************************************************************
Quick quiz: 
Why does this not return any rows?
Look at the plan.
Is there a way to make it return rows?
*******************************************************************************/
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE EmailAddress = NULL;
GO









--If you change the ANSI_NULLS setting to OFF,
--The equality comparison works the same way as the IS NULL syntax
--But don't do this! It is deprecated.

--Run these queries as a single batch (in Azure Data Studio it resets your sessions ANSI_NULL setting automatically after execution!)
SET ANSI_NULLS OFF;

SELECT FullName,
    PreferredName,
    EmailAddress AS Email
FROM Application.People
WHERE EmailAddress IS NULL;

SELECT FullName,
    PreferredName,
    EmailAddress AS Email
FROM Application.People
WHERE EmailAddress = NULL; /* Will only match NULLs with ANSI_NULLS set to OFF (deprecated) */

--Back to the right setting:
SET ANSI_NULLS ON;
GO





/* 
T2.Q4

Write a query that SELECTS all the rows from Application.People
Return rows for ONLY three columns:
    FullName 
    PreferredName
    EmailAddress  - alias as: Email
Return ONLY rows where PreferredName is Agrita 
GO
*/
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName = N'Agrita';
GO



/********************************************************************************
Discussion: What's with that N? 
Look at the data type for PreferredName

N'Agrita' indicates unicode / NVARCHAR data type for that string
Sometimes data type mismatches can make huge differences in performance
*******************************************************************************/

EXEC sp_help 'Application.People';
GO





/* 
T2.Q5

Write a query that SELECTS all the rows from Application.People
Return rows for ONLY three columns:
    FullName 
    PreferredName
    EmailAddress  - alias as: Email
Return ONLY rows where PreferredName starts with the letter A 
GO
*/

SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName LIKE N'A%';
GO















/* 
T2.Q6

Write a query that SELECTS all the rows from Application.People
Return rows for ONLY three columns:
    FullName 
    PreferredName
    EmailAddress  - alias as: Email
Return ONLY rows where PreferredName starts with the LOWERCASE letter 'a'  
GO
*/

--Try this, does it work?
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName LIKE 'a%';
GO




--Column level collation
EXEC sp_help 'Application.People';
GO
--Latin1_General_100_CI_AS



--My instance level collation
SELECT SERVERPROPERTY('collation');
GO
--SQL_Latin1_General_CP1_CS_AS



--Decoding a collation
SELECT name,
       description
FROM fn_helpcollations()
WHERE name = 'SQL_Latin1_General_CP1_CS_AS';
GO



--You can specify collation in a query
--If we want to run a case sensitive comparison...
--Look at the plan - what is it having to do to accomplish this?
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName COLLATE SQL_Latin1_General_CP1_CS_AS LIKE N'a%';
GO




/* 
T2.Q7

Write a query that SELECTS all the rows from Application.People
Return rows for ONLY three columns:
    FullName 
    PreferredName
    EmailAddress  - alias as: Email
Return ONLY rows where PreferredName contains 'y' or 'Y' anywhere in the string
    AND the email address contains a space
Order the results by EmailAddress Ascending
GO
*/

SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName LIKE N'%y%' /* Since the column is case-insensitive, i don't need collate */
      AND EmailAddress LIKE N'% %'
ORDER BY EmailAddress ASC;
GO



--You can order by a column alias
--ASC is the default and is not required to be stated
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName LIKE N'%y%'
      AND EmailAddress LIKE N'% %'
ORDER BY Email;
GO

--Although you can use a number in ORDER BY
--which refers to column position, this is an anti-pattern
SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName LIKE N'%y%'
      AND EmailAddress LIKE N'% %'
ORDER BY 3;
GO




/* 
T2.Q8

Write a query that SELECTS all the rows from Application.People
Return rows for ONLY two columns:
    FullName 
    The length (number of characters in) the FullName column, 
        as calculated by the LEN() SQL Server function
        https://docs.microsoft.com/en-us/sql/t-sql/functions/len-transact-sql?view=sql-server-2017
        alias as: Len Full Name
Order the results by the length of FullName, Descending
Return only 10 rows 

Do NOT use SET ROWCOUNT -- instead do everything in a single TSQL statement
GO
*/


SELECT TOP 10
       FullName,
       LEN(FullName) AS [Len Full Name]
FROM Application.People
ORDER BY LEN(FullName) DESC;
GO

--This syntax is SQL Server 2012+
SELECT FullName,
       LEN(FullName) AS [Len Full Name]
FROM Application.People
ORDER BY LEN(FullName) DESC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
GO


--Look at the execution plans
--The way you write your syntax doesn't dictate how the query is executed behind the scenes
--The database engine may choose the same "plan" to execute two queries written in different ways!




/* 
T2.Q9

Write a query that SELECTS all the rows from Application.People
Just like Q8...
Return rows for ONLY two columns:
    FullName 
    The length (number of characters in) the FullName column, 
        as calculated by the LEN() SQL Server function
        https://docs.microsoft.com/en-us/sql/t-sql/functions/len-transact-sql?view=sql-server-2017
        alias as: Len Full Name
Order the results by the length of FullName, Descending
Return only 10 rows 

EXCEPT this time...
    Return rows ONLY #11 - 20 (as ordered by description above)

Do NOT use the TOP keyword, do not use ROW_NUMBER(), and do not use SET ROWCOUNT
GO
*/

SELECT FullName,
       LEN(FullName) AS [Len Full Name]
FROM Application.People
ORDER BY LEN(FullName) DESC /* repeats function in ORDER BY */
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
GO

SELECT FullName,
       LEN(FullName) AS [Len Full Name]
FROM Application.People
ORDER BY [Len Full Name] DESC /* uses column name in ORDER BY */
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
GO

SELECT FullName,
       LEN(FullName) AS [Len Full Name]
FROM Application.People
ORDER BY 2 DESC /* Uses column numeric position in ORDER BY (tacky!) */
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
GO



--Discussion: why would you ever need to do a query like this in the real world?





/********************************************************************************
Discussion....
Will this syntax work?
Why, or why not?
*******************************************************************************/

SELECT FullName,
       PreferredName,
       EmailAddress AS Email
FROM Application.People
WHERE PreferredName LIKE N'%y%'
      AND Email LIKE N'% %'
ORDER BY PreferredName;
GO


