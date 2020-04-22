# TSQL for Beginners

## Jump to Section

* [Course Summary](#course-summary)
* [Audience](#audience)
* [Videos](#videos)
* [Course Slack Discussion](#course-slack-discussion)
* [Pre-requisites](#pre-requisites)
* [Session Overview](#session-overview)
  * [Introducing SELECTs and Aliasing](#introducing-selects-and-aliasing)
  * [Get started with JOINs](#get-started-with-joins)
  * [Learn GROUP BY and CASE](#learn-group-by-and-case)
  * [CTEs, Subqueries, Derived Tables, Oh My!](#ctes-subqueries-derived-tables-oh-my)
  * [Oh No, it’s Scalar User Defined Functions](#oh-no-its-scalar-user-defined-functions)
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

* Follow along with the introductory demo using [1_SelectAndAlias_Demo.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/1_SelectAndAlias_Demo.sql)
* Try your hand at the homework for next session using [2_SelectAndAlias_Homework.sql](https://github.com/LitKnd/TSQLBeginners/blob/master/2_SelectAndAlias_Homework.sql)

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

### Get started with JOINs

*Releasing April 29, 2020* 

We cover sample solutions for 'SELECTS and Aliasing', then introduce inner joins outer joins (left, right, full), cross joins.

### Learn GROUP BY and CASE
*Releasing May 6, 2020* 

We through sample solutions for JOINs, then introduce GROUP BY clauses and CASE statements.

### CTEs, Subqueries, Derived Tables, Oh My!
*Releasing May 13, 2020*

We'll go through sample solutions for the GROUP BY and CASE homework, then dig into differnet ways to nest/combine queries in your queries: Common Table Expressions, Subqueries, and Derived Tables

### Oh No, it's Scalar User Defined Functions

*Releasing May 20, 2020*

We'll talk through sample solutions for the previous week, then give an introduction to making code reusable using functions. We'll include big-picture information on why functions are controversial in SQL Server and how to be successful with them.

### Table Valued Functions and a little CROSS APPLY

*Releasing May 27, 2020*

We'll chat through solutions for the scalar function homework, then TVFs puts the "fun" in functions. No, really, they do!

### Ranking, Numbering, and Running Totals with Windowing Functions

*Releasing June 3, 2020*

We'll wrap up our discussion of functions by working through the homework, then it's time for another favorite: Windowing Functions!

### Stored Procedures
*Releasing June 10, 2020* 

In our last session, we'll go through our homework on window functions, then do a gentle final introduction to Stored Procedures. No homework this session, just ideas on how to move forward with your learning from here.
