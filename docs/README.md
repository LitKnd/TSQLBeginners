# TSQL for Beginners

## Jump to Section

* [Course Summary](#course-summary)
* [Audience](#audience)
* [Videos](#videos)
* [Course Slack Discussion](#course-slack-discussion)
* [Pre-requisites](#pre-requisites)
* [Session Overview](#session-overview)
  * [Introducing SELECTs and Aliasing](#introducing-selects-and-aliasing)
  * [Solutions for SELECT Homework and Introduction to JOINs](#solutions-for-select-homework-and-introduction-to-joins)
  * [Solutions for JOINs Homework and Learn GROUP BY and CASE](#solutions-for-joins-homework-and-learn-group-by-and-case)
  * [Solutions for Group By and CASE; then CTEs, Subqueries, Derived Tables, Oh My!](#solutions-for-group-by-and-case-then-ctes-subqueries-derived-tables-oh-my)
  * [Oh No, it’s Scalar User Defined Functions](#solutions-for-ctes-and-friends-then-oh-no-its-scalar-user-defined-functions)
  * [Table Valued Functions and a little CROSS APPLY](#table-valued-functions-and-a-little-cross-apply)
  * [Ranking, Numbering, and Running Totals with Windowing Functions](#ranking-numbering-and-running-totals-with-windowing-functions)
  * [Stored Procedures](#stored-procedures)

## Course Summary

This free course introduces you to the Transact SQL language implemented in SQL Server and takes you from newbie to a master of SELECT statements. Each session of the course features a demo introducing a subject and a homework assignment to try on your own. The following session covers sample solutions for the homework previously assigned, then introduces a new subject with more homework.

The course covers:

* SELECT statements and aliasing tables
* Using WHERE clauses and JOINs
* Aggregating data using GROUP BY and CASE statements
* Common Table Expressions, Subqueries, and Derived tables
* Scalar and Table Valued User Defined Functions
* An introduction to Stored Procedures

## Audience

This course is intended for anyone who wants to learn TSQL. This could be database administrators, developers, business analysts, students, IT support staff, or anyone who is interested to learn a programming language where they can work with sets of data.

## Videos

Live classes will air each Wednesday on [YouTube](https://www.youtube.com/redgate), generally at 3PM British Summer Time / 10AM Eastern. 

Recordings will automagically appear [in this Redgate University Community Circle Course](https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners)

## Course Slack Discussion

Need some help with your homework, or just want to chat with others in the course? You can use this Slack channel to chat while attending a course live, or afterward anytime -- don't worry if you have joined the course late, just start where you are.

1. Join the SQL Community Slack group for discussion: [https://t.co/w5LWUuDrqG](https://t.co/w5LWUuDrqG)
1. Click the + next to 'Channels' and join #tsqlbeginners

## Pre-requisites

To get started with the course, you will need to have a couple of applications installed. The course doesn't show how to install these tools, but jumps right in under the assumption that you have already installed them successfully.

- Microsoft SQL Server Developer Edition, which is [free from Microsoft](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
  * **Windows**: You probably want to click 'Download now' under where it says 'Developer'
  * **Mac**: You probably want to click "Choose your installation setup" under "Docker", which will eventually take you to this Quickstart page on how to [Run SQL Server container images with Docker](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker)
- Either [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) or [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) (both of which are free as well). Most demos will be shown in Azure Data Studio.
  * **Windows**: Take your pick of either.
  * **Mac**: You want Azure Data Studio (SSMS is Windows-only)
  * If using Azure Data Studio, it is very helpful to add the 'SSMS Keymap' extension by Kevin Cunnane. Here is [how to install that](https://www.bobpusateri.com/archive/2018/12/getting-ssms-keyboard-shortcuts-in-azure-data-studio/).

## Session Overview

### Introducing SELECTs and Aliasing

We cover: Getting going in SQL Server Management Studio or in Azure Data Studio. Using databases. SELECT statements and aliasing. 
Bonus topic: What does 'deprecated' mean?

**Follow along with the introductory demo** using [1_SelectAndAlias_Demo.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/1_SelectAndAlias_Demo.sql)

**Tackle the homework for next session** using [2_SelectAndAlias_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/2_SelectAndAlias_Homework.sql)

Video timeline:
* [00:22](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=22s) Course Syllabus
* [02:10](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=130s) Notes on what to install to follow along
* [07:00](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=420s) Basics on using SQL Server Management Studio (SSMS)
* [08:00](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=480s) Info about the RAISERROR command I use at the top of the scripts
* [09:49](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=589s) Using the RESTORE DATABASE script
* [16:11](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=971s) Azure Data Studio (ADS) – why you might want to use this and comparing ADS to SSMS
* [17:44](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1064s) Explanation of ‘USE’ and discussion of the concept of “using a database”
* [20:24](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1224s) Running our first SELECT statement
* [22:24](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1344s) Brief overview of schemas
* [23:15](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1395s) Discussion of GO batch separator
* [25:30](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1530s) Discussion of semi-colon terminators
* [27:34](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1654s) Why “SELECT
*” is an anti-pattern
* [32:05](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=1925s) A brief return to SSMS to demo dragging object names and column names over from Object Explorer (this doesn’t work in Azure Data Studio, but it does have good object auto-completion for typing)
* [35:28](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=2128s) What square[brackets\] do around object names, and how they can allow you to use special characters (with a “stupid pet trick” demo of how to create a database with a space as its name)
* [39:00](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=2340s) Example of using a column alias with ‘AS’
* [40:48](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=2448s) Discussion of when you want to use a column alias and why
* [41:20](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=2480s) Demo of aliasing without the word ‘AS’ – and a warning of how this can be done accidentally
* [43:09](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=2589s) Demo of aliasing with reversed order and “=” (and a little discussion of ANSI compliance)
* [47:43](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=2863s) A quick step through of the “quiz” questions in the demo file
* [51:17](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=3077s) Demo of aliasing a table, and comparing three and two part names
* [53:30](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=3210s) Recap of the “quiz” questions on table name aliasing
* [56:08](https://www.youtube.com/watch?v=-_8nSjbGQUY&t=3368s) Brief introduction of next week’s homework

### Solutions for SELECT Homework and Introduction to JOINs

We cover sample solutions for 'SELECTS and Aliasing', then introduce inner joins outer joins (left, right, full), cross joins.

**Sample solutions for 'SELECTS and Aliasing'** are in [3_SelectAndAlias_Solutions.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/3_SelectAndAlias_Solutions.sql)

**Follow along with the demo** using [4_Joins_DiagramsForHomework.ipynb](https://github.com/LitKnd/TSQLBeginners/blob/master/4_Joins_DiagramsForHomework.ipynb) -- this is a Jupyter notebook file which will open in Azure Data Studio

**Try your hand at the homework** with [5_Joins_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/5_Joins_Homework.sql)

Video timeline:

* [00:52](https://www.youtube.com/watch?v=r61wTGxcjP0&t=52s) Overview of the course files on GitHub
* [01:30](https://www.youtube.com/watch?v=r61wTGxcjP0&t=90s) View of the Azure Data Studio Jupyter notebook as it displays in GitHub
* [03:25](https://www.youtube.com/watch?v=r61wTGxcjP0&t=205s) Using the WideWorldImporters database
* [03:40](https://www.youtube.com/watch?v=r61wTGxcjP0&t=220s) Solution to Question 1 in 2\_SelectAndAlias\_Solutions.sql
* [05:11](https://www.youtube.com/watch?v=r61wTGxcjP0&t=311s) What execution plans are and why I'm showing you some
* [08:40](https://www.youtube.com/watch?v=r61wTGxcjP0&t=520s) the sp\_help procedure, and why it's useful
* [10:00](https://www.youtube.com/watch?v=r61wTGxcjP0&t=600s) Computed Columns
* [12:30](https://www.youtube.com/watch?v=r61wTGxcjP0&t=750s) Solution to Question 2 in 2\_SelectAndAlias\_Solutions.sql
* [15:25](https://www.youtube.com/watch?v=r61wTGxcjP0&t=925s) Solution to Question 3 in 2\_SelectAndAlias\_Solutions.sql (and the controversy of NULLS, with an overview of NVARCHAR for good measure)
* [22:54](https://www.youtube.com/watch?v=r61wTGxcjP0&t=1374s) ANSI NULLS and why you shouldn't turn it off
* [24:44](https://www.youtube.com/watch?v=r61wTGxcjP0&t=1484s) Solution to Question 4 in 2\_SelectAndAlias\_Solutions.sql
* [28:00](https://www.youtube.com/watch?v=r61wTGxcjP0&t=1680s) Solution to Question 5 in 2\_SelectAndAlias\_Solutions.sql
* [30:23](https://www.youtube.com/watch?v=r61wTGxcjP0&t=1823s) Solution to Question 6 in 2\_SelectAndAlias\_Solutions.sql and a discussion of collation
* [37:31](https://www.youtube.com/watch?v=r61wTGxcjP0&t=2251s) Solution to Question 7 in 2\_SelectAndAlias\_Solutions.sql and an intro to ORDER BY
* [41:52](https://www.youtube.com/watch?v=r61wTGxcjP0&t=2512s) Solution to Question 8 in 2\_SelectAndAlias\_Solutions.sql with intro to OFFSET and FETCH
* [44:19](https://www.youtube.com/watch?v=r61wTGxcjP0&t=2659s) Demo that your TSQL syntax generally doesn't determine a specific execution plan
* [46:19](https://www.youtube.com/watch?v=r61wTGxcjP0&t=2779s) Solution to Question 9 in 2\_SelectAndAlias\_Solutions.sql
* [49:40](https://www.youtube.com/watch?v=r61wTGxcjP0&t=2980s) Review of where column aliases DON'T work
* [51:22](https://www.youtube.com/watch?v=r61wTGxcjP0&t=3082s) JOINs discussion begins here!
* [53:00](https://www.youtube.com/watch?v=r61wTGxcjP0&t=3180s) Overview of the joins sample database and an explanation of the Jupyter notebook
* [54:50](https://www.youtube.com/watch?v=r61wTGxcjP0&t=3290s) INNER join: matching rows from both tables
* [59:37](https://www.youtube.com/watch?v=r61wTGxcjP0&t=3577s) LEFT OUTER join: rows from the 'left' table with matching rows from the 'right' table when present
* [01:01:48](https://www.youtube.com/watch?v=r61wTGxcjP0&t=3708s) RIGHT OUTER join: rows from the 'right' table with matching rows from the 'left' table when present
* [01:04:44](https://www.youtube.com/watch?v=r61wTGxcjP0&t=3884s) FULL OUTER join: return all rows from each 'side', matching where possible
* [01:07:18](https://www.youtube.com/watch?v=r61wTGxcjP0&t=4038s) Simplify our data a bit, and then CROSS JOIN
* [01:09:40](https://www.youtube.com/watch?v=r61wTGxcjP0&t=4180s) Recap of the joins and info about homework for next time

### Solutions for JOINs Homework and Learn GROUP BY and CASE

We step through sample solutions for JOINs homework, then introduce GROUP BY clauses and CASE statements.

**Sample solutions for JOINs homework** are in [6_Joins_Solutions.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/6_Joins_Solutions.sql)

**Follow along with the demo** using [7_GroupingAndCase_DiagramsForHomework.ipynb](https://github.com/LitKnd/TSQLBeginners/blob/master/7_GroupingAndCase_DiagramsForHomework.ipynb) -- this is a Jupyter notebook file which will open in Azure Data Studio

**Try your hand at the homework** with [8_GroupingAndCase_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/8_GroupingAndCase_Homework.sql)

Video timeline:


 *  [00:00](https://www.youtube.com/watch?v=iPBNS_3639s&t=0s) Showing the scripts covered in the syllabus 
 *  [01:40](https://www.youtube.com/watch?v=iPBNS_3639s&t=100s) Recapping the tables used in the homework in 6\_Joins\_Solutions.sql and how to know which join columns to use on tables 
 *  [06:40](https://www.youtube.com/watch?v=iPBNS_3639s&t=400s) Solution to Question 1 in 6\_Joins\_Solutions.sql 
 *  [11:16](https://www.youtube.com/watch?v=iPBNS_3639s&t=676s) Solution to Question 2 in 6\_Joins\_Solutions.sql (left and right outer joins) 
 *  [15:20](https://www.youtube.com/watch?v=iPBNS_3639s&t=920s) Solution to Question 3 in 6\_Joins\_Solutions.sql 
 *  [23:50](https://www.youtube.com/watch?v=iPBNS_3639s&t=1430s) Solution to Question 4 in 6\_Joins\_Solutions.sql 
 *  [15:22](https://www.youtube.com/watch?v=iPBNS_3639s&t=922s) Solution to Question 5 in 6\_Joins\_Solutions.sql 
 *  [27:00](https://www.youtube.com/watch?v=iPBNS_3639s&t=1620s) Solution to Question 6 in 6\_Joins\_Solutions.sql 
 *  [18:18](https://www.youtube.com/watch?v=iPBNS_3639s&t=1098s) Solution to Question 7 in 6\_Joins\_Solutions.sql 
 *  [33:30](https://www.youtube.com/watch?v=iPBNS_3639s&t=2010s) Introduction to GROUP BY and Case begins with an overview of logical processing order 
 *  [33:50](https://www.youtube.com/watch?v=iPBNS_3639s&t=2030s) Setting up the same table in 7\_GroupingAndCase\_DiagramsForHomework.ipynb (a Jupyter notebook you can open and use in Azure Data Studio) 
 *  [35:48](https://www.youtube.com/watch?v=iPBNS_3639s&t=2148s) GROUP BY and COUNT() 
 *  [37:55](https://www.youtube.com/watch?v=iPBNS_3639s&t=2275s) GROUP BY and MAX() 
 *  [39:07](https://www.youtube.com/watch?v=iPBNS_3639s&t=2347s) GROUP BY and MIN() 
 *  [40:25](https://www.youtube.com/watch?v=iPBNS_3639s&t=2425s) GROUP BY and AVG() with a discussion of rounding INTs 
 *  [43:09](https://www.youtube.com/watch?v=iPBNS_3639s&t=2589s) GROUP BY and HAVING 
 *  [46:40](https://www.youtube.com/watch?v=iPBNS_3639s&t=2800s) CASE - the "CASE colname when" syntax 
 *  [49:16](https://www.youtube.com/watch?v=iPBNS_3639s&t=2956s) CASE - the "CASE WHEN condition" syntax 
 *  [50:31](https://www.youtube.com/watch?v=iPBNS_3639s&t=3031s) CASE - the "CASE WHEN condition" syntax with compound logic in the condition, with an example of concatenation and notes on NULL's impact on combining strings 
 *  [53:23](https://www.youtube.com/watch?v=iPBNS_3639s&t=3203s) Combining GROUP BY and CASE 
 *  [55:53](https://www.youtube.com/watch?v=iPBNS_3639s&t=3353s) Brief overview of homework

### Solutions for GROUP BY and CASE; then CTEs, Subqueries, Derived Tables, Oh My!

We'll go through sample solutions for the GROUP BY and CASE homework, then dig into differnet ways to nest/combine queries in your queries: Common Table Expressions, Subqueries, and Derived Tables

**Sample solutions** are in [8_GroupingAndCase_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/8_GroupingAndCase_Homework.sql)

**Follow along with the demo** using [9_GroupingAndCase_Solutions.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/9_GroupingAndCase_Solutions.sql)

**Try your hand at the homework** with [11_CTEsSubqueriesDerivedTables_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/11_CTEsSubqueriesDerivedTables_Homework.sql)

Video timeline: 
 *  [00:20](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=20s) Accidental demo of a bug in Azure Data Studio where a connection "goes bad" 
 *  [07:08](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=428s) Solution to Q1 from 9\_GroupingAndCase\_Solutions.sql with a discussion of data types and the AVG function 
 *  [10:30](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=630s) Solution to Q2 from 9\_GroupingAndCase\_Solutions.sql - discussion of COUNT ALL vs COUNT DISTINCT 
 *  [14:06](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=846s) Solution to Q3 from 9\_GroupingAndCase\_Solutions.sql - discussion showing that multiple syntaxes can result in the same query execution plan being used behind the scenes 
 *  [18:16](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=1096s) Solution to Q4 from 9\_GroupingAndCase\_Solutions.sql - discussion of HAVING clauses 
 *  [21:05](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=1265s) Solution to Q5 form 9\_GroupingAndCase\_Solutions.sql - working with CASE 
 *  [24:29](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=1469s) Solution to Q6 from 9\_GroupingAndCase\_Solutions.sql - which solution do you like better? Comparing a CASE solution and a COUNT solution 
 *  [28:28](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=1708s) Bonus topic - using EXCEPT and INTERSECT to compare result sets from different ways to write a query 
 *  [31:43](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=1903s) Demo on CTEs, Subqueries, and Derived tables begin: setting up sample data 
 *  [34:00](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=2040s) An example problem query -- why HAVING isn't enough and we need to get more complex 
 *  [36:21](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=2181s) Introduction to Common Table Expressions (CTEs) 
 *  [40:03](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=2403s) More with CTEs: you may use multiples, and they may refer to a prior CTE \*[41:50](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=2510s) Derived table example 
 *  [43:43](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=2623s) Correlated subquery example 
 *  [47:54](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=2874s) Subquery in the select example 
 *  [51:40](https://www.youtube.com/watch?v=CF4NAcXuvgQ&t=3100s) Setup for next week's homework, 11\_CTEsSubqueriesDerivedTables\_Homework.sql

### Solutions for CTEs and Friends, then Oh No, it's Scalar User Defined Functions

This time, we talk through sample solutions for the previous week, then give an introduction to making code reusable using functions. We'll include big-picture information on why functions are controversial in SQL Server and how to be successful with them.

**Sample solutions** are in [11_CTEsSubqueriesDerivedTables_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/11_CTEsSubqueriesDerivedTables_Homework.sql)

**Follow along with the demo** using [12_CTEsSubqueriesDerivedTables_Solutions.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/12_CTEsSubqueriesDerivedTables_Solutions.sql)

**Try your hand at the homework** with [13_ScalarUDFs_Demo.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/13_ScalarUDFs_Demo.sql)

### Table Valued Functions and a little CROSS APPLY

*Releasing May 27, 2020*

We'll chat through solutions for the scalar function homework, then TVFs puts the "fun" in functions. No, really, they do!

### Ranking, Numbering, and Running Totals with Windowing Functions

*Releasing June 3, 2020*

We'll wrap up our discussion of functions by working through the homework, then it's time for another favorite: Windowing Functions!

### Stored Procedures
*Releasing June 10, 2020* 

In our last session, we'll go through our homework on window functions, then do a gentle final introduction to Stored Procedures. No homework this session, just ideas on how to move forward with your learning from here.
