/******************************************************************************
Course home: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
GitHub: https://github.com/LitKnd/TSQLBeginners

TSQL for Beginners

Topic 1: Hello, world: connecting in SSMS, connecting in Azure Data Studio, using databases, SELECT, aliasing. 
Bonus:   What does 'deprecated' mean?

SOLUTION FILE (no homework for Topic 1)
*****************************************************************************/

/* Doorstop */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO


/*******************************************************************************
Session Agenda:

	How the course will work
	Today's demos... Hello, world: connecting in SSMS / Connecting in Azure Data Studio, 
        using databases, SELECT, aliasing. 
	Bonus... what does 'deprecated' mean?

*******************************************************************************/


/*******************************************************************************
Things to do:
    1) Your homework for next session: TSQLforBeginners_Topic2_Homework.sql 
    2) Join the SQL Community Slack group for discussion https://t.co/w5LWUuDrqG
	   Click the + next to 'Channels' and join #tsqlbeginners

*******************************************************************************/




/*******************************************************************************
Demo: Connecting in SSMS / Connecting in Azure Data Studio
*******************************************************************************/




/******************************************************************************* 
Demo: Restore the sample database 
*******************************************************************************/


/* File download: https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0

    You want one file from this page: WideWorldImporters-Full.bak   (121 MB)
    Move the file into a directory where your SQL Server instance can read from it

    Note: The WideWorldImporters database is shared by Microsoft Corporation under the MIT License
        Microsoft SQL Server Sample Code

        Copyright (c) Microsoft Corporation

        All rights reserved.

        MIT License.

        Permission is hereby granted, free of charge, to any person obtaining a copy
         of this software and associated documentation files (the "Software"), to deal
         in the Software without restriction, including without limitation the rights
         to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
         copies of the Software, and to permit persons to whom the Software is
         furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in
         all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
         IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
         FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
         AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
         LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
         OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
         THE SOFTWARE.
*/

--Verify you're connected to a dedicated test instance
SELECT @@SERVERNAME AS WhereAmIConnected;
GO


--If the database exists, put it in an offline state and rollback any activity
USE master;
GO

IF DB_ID('WideWorldImporters') IS NOT NULL
    ALTER DATABASE WideWorldImporters SET OFFLINE WITH ROLLBACK IMMEDIATE;
GO

--Restore the database
/* EDIT DRIVE/FOLDER LOCATIONS AS NEEDED */
RESTORE DATABASE WideWorldImporters
FROM DISK = 'C:\MSSQL\BAK\WideWorldImporters-Full.bak'
WITH REPLACE,
     MOVE 'WWI_Primary'
     TO 'C:\MSSQL\DATA\WideWorldImporters.mdf',
     MOVE 'WWI_UserData'
     TO 'C:\MSSQL\DATA\WideWorldImporters_UserData.ndf',
     MOVE 'WWI_Log'
     TO 'C:\MSSQL\DATA\WideWorldImporters.ldf',
     MOVE 'WWI_InMemory_Data_1'
     TO 'C:\MSSQL\DATA\WideWorldImporters_InMemory_Data_1';
GO


/********************************************************************************
Quick quiz: 
Why bother with ALTER DATABASE SET OFFLINE WITH ROLLBACK IMMEDIATE?


*******************************************************************************/





/*******************************************************************************
Demo: Using databases 
********************************************************************************/


--From TSQL:
USE WideWorldImporters;
GO


--Shortcut in SSMS: CTRL + U
--If this shortcut doesn't work, you may be using a super old version of SSMS
--Update it here: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms




/********************************************************************************
Demo: SELECTing metadata 
********************************************************************************/


--Our first query: SELECT * FROM 

SELECT *
FROM sys.tables;





--GO is a batch separator
--This indicates the end of a group of code you'd like to execute together
SELECT *
FROM sys.tables;
GO

--Fun fact: GO is not part of T-SQL
--It is a command recognized by sql utiltilies (like SSMS) 
--to delimit groups of code to execute in a batch
--https://docs.microsoft.com/en-us/sql/t-sql/language-elements/sql-server-utilities-statements-go
--You can even change the batch separator (Tools ->  Options -> Query Execution)




--; is a polite way to end queries (and it's the ANSI standard- American National Standards Institute)
--In some situations you'll hit errors if you don't use a semicolon to terminate a query 
SELECT *
FROM sys.tables;
GO





/********************************************************************************
Quick quiz: 
Do you know of a scenario where you'll get an error if you don't use ";" to end a statement?
(If not, you will soon: we'll cover one in a later topic)


*******************************************************************************/










--"SELECT *" can get you in trouble
--It's a best practice to list the column names you need
--Bringing back extra columns can hurt query performance


--Demo: dragging table and object names over from Object Explorer
/*
SELECT
FROM  
;
GO
*/


--Limit this to columns I care about
--Brackets allow the use of spaces / special characters
--They prevent weird highlighting of keywords
--Compare:
SELECT [name],
       [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables;
GO


SELECT name,
       object_id,
       schema_id,
       type_desc
FROM sys.tables;
GO




--I can alias column names
--Bracket delimiters let me use spaces /special characters in my alias
--This is a very common way to alias columns for SQL Server:
SELECT [name] AS [👩 table name],
       [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables;
GO

--'AS' is not required to alias
--But it helps readability substantially
--Example: this works, but can sometimes confusing be
SELECT [name] [table name],
       [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables;
GO

--You will sometimes encounter this style of aliasing
--It is not ANSI compliant, which generally limits portability
SELECT [table name] = [name],
       [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables;
GO

--Deprecated pattern:
--Using a string as a column alias, like this:
--https://docs.microsoft.com/en-us/sql/database-engine/deprecated-database-engine-features-in-sql-server-2016
SELECT 'table name' = [name],
       [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables;
GO



--It can be handy to have a coding standard for TSQL for your team
--You'll see my preferences in this course, 
--and you will find your OWN preferences and style as you write more queries.





/********************************************************************************
Quick quiz: 
Why does this query return only three columns instead of four?

*******************************************************************************/
SELECT [name] [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables;
GO





--Turn off intellisense here --











/********************************************************************************
Quick quiz (3 questions) 

1) Will SQL Server run this query successfully with all columns aliased as the same thing?
*******************************************************************************/
SELECT [name] AS [foo],
       [object_id] AS [foo],
       [schema_id] AS [foo],
       [type_desc] AS [foo]
FROM sys.tables AS t;
GO





/********************************************************************************
2) Will SQL Server run this query successfully?
*******************************************************************************/
SELECT [name],
       [name],
       [name],
       [name],
       object_id AS name
FROM sys.tables AS t;
GO






/********************************************************************************
3) Will SQL Server run this query successfully?
*******************************************************************************/
SELECT [name] AS [foo],
       [foo] AS [foo2]
FROM sys.tables AS t;
GO









--Turn intellisense back on, if you want



-- you can also alias in your FROM
SELECT [name],
       [object_id],
       [schema_id],
       [type_desc]
FROM sys.tables AS t;
GO



--This is commonly done to specify 
--where a column comes from explicitly
--Compare these three queries
SELECT [sys].[tables].[name],
       [sys].[tables].[object_id],
       [sys].[tables].[schema_id],
       [sys].[tables].[type_desc]
FROM sys.tables;
GO

SELECT [tables].[name],
       [tables].[object_id],
       [tables].[schema_id],
       [tables].[type_desc]
FROM sys.tables;
GO

SELECT t.[name],
       t.[object_id],
       t.[schema_id],
       t.[type_desc]
FROM sys.tables AS t;
GO



/*  Note:  Three-part and four-part column references in SELECT list like this...

SELECT [sys].[tables].[name],
       [sys].[tables].[object_id],
       [sys].[tables].[schema_id],
       [sys].[tables].[type_desc]
FROM sys.tables;
GO

is also 'deprecated'
https://documentation.red-gate.com/codeanalysis/deprecated-syntax-rules/dep026


*/




/********************************************************************************
Quick quiz (2 questions) 

1) Can I combine aliases and full part names?
*******************************************************************************/
SELECT [sys].[tables].[name],
       t.[object_id],
       t.[schema_id],
       t.[type_desc]
FROM sys.tables AS t;
GO


/********************************************************************************
2) How about just not specifying the table/view when I have an alias?
*******************************************************************************/
SELECT [name],
       t.[object_id],
       t.[schema_id],
       t.[type_desc]
FROM sys.tables AS t;
GO



/*****************************************
That's the basics on connecting in SSMS, using databases, SELECT, aliasing. 
Questions before we set up the homework that you'll work on this week?
*****************************************/
