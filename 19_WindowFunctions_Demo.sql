/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Ranking, Numbering, and Running Totals with Windowing Functions

EXAMPLES FOR STUDY

*****************************************************************************/



/* ✋🏻 Doorstop ✋🏻  */
RAISERROR ( N'Did you mean to run the whole thing?', 20, 1 ) WITH LOG ;
GO



/******************************************************************************
Set up sample data
*****************************************************************************/

USE master ;
GO

IF DB_ID ( 'TSQLSchool' ) IS NOT NULL DROP DATABASE TSQLSchool ;
GO

CREATE DATABASE TSQLSchool ;
GO

USE TSQLSchool ;
GO

--DROP IF EXISTS is SQL Server 2016 SP3+
DROP TABLE IF EXISTS dbo.doggos
GO

CREATE TABLE dbo.doggos
    (dogid INT IDENTITY,
     doggo VARCHAR(128) NOT NULL,
     age TINYINT NOT NULL,
     sex CHAR(1) NOT NULL,
     CONSTRAINT pk_doggos PRIMARY KEY CLUSTERED(dogid)) ;
GO


INSERT dbo.doggos(doggo, age, sex)
VALUES
    ('Mister', 10, 'M'), 
    ('Stormy', 3, 'M'), 
    ('Wendell', 5, 'M'),
    ('Kota', 10, 'F'),
    ('Fletcher', 4, 'M'),
    ('Scout', 2, 'F');
GO


/******************************************************************************
Let's run some queries!
*****************************************************************************/


--ROWNUMBER
--SQL Server 2008+ 
--https://docs.microsoft.com/en-us/sql/t-sql/functions/row-number-transact-sql

SELECT
    ROW_NUMBER () OVER (ORDER BY age DESC) AS rownum,
    doggo,
    age,
    sex
FROM dbo.doggos;
GO


--You must have an ORDER BY clause for row_number, 
--but it can be garbage 🗑 if you simply want arbitrary numbering
SELECT
    ROW_NUMBER () OVER (ORDER BY (SELECT 1/0) ) AS rownum,
    doggo,
    age,
    sex
FROM dbo.doggos;
GO


--We can partition! We can also use multiple columns for ordering
SELECT
    ROW_NUMBER () OVER ( PARTITION BY sex ORDER BY age DESC, doggo) AS rownum,
    sex,
    doggo,
    age
FROM dbo.doggos;
GO


--RANK and DENSE_RANK handle ties - compare
--SQL Server 2008+
SELECT
    RANK () OVER (ORDER BY age DESC) AS ranking,
    doggo,
    age,
    sex
FROM dbo.doggos;


SELECT
    DENSE_RANK () OVER (ORDER BY age DESC) AS denseranking,
    doggo,
    age,
    sex
FROM dbo.doggos;
GO

--We can partition as well when ranking
SELECT
    sex,
    DENSE_RANK () OVER (PARTITION BY sex ORDER BY age DESC) AS denseranking,
    doggo,
    age
FROM dbo.doggos;
GO




--AVG by sex
--We learned this in GROUP BY
SELECT 
    sex,
    AVG(age) AS WrongAvgDueToDataType,
    AVG(1.0 * age) AS AvgAgeBySex
FROM dbo.doggos
GROUP BY sex
GO

--What if we want to display the avg by gender for each row?
--WE CAN DO THAT
SELECT 
    sex,
    doggo,
    age,
    AVG(1.0 * age) OVER (PARTITION BY sex )  AS AvgAgeBySex,
    AVG(1.0 * age) OVER ( )  AS AvgAgeOverall
FROM dbo.doggos
ORDER BY sex;
GO

--let's add in median, why not?
--"PERCENTILE_CONT interpolates the appropriate value, 
--whether or not it exists in the data set, while PERCENTILE_DISC always returns an actual value from the set."
--SQL Server 2012+
--https://docs.microsoft.com/en-us/sql/t-sql/functions/percentile-disc-transact-sql

SELECT 
    sex,
    doggo,
    age,
    AVG(1.0 * age) OVER (PARTITION BY sex )  AS avgagebysex,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age ) OVER (partition by sex) AS medianagebysex,
    AVG(1.0 * age) OVER ( )  AS avgageoverall,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age ) OVER () AS medianageoverall
FROM dbo.doggos
ORDER BY sex;
GO


--max and count can use windows, as well
SELECT 
    sex,
    doggo,
    age,
    max(age) OVER ( PARTITION BY sex )  AS MaxAgeBySex,
    max(age) OVER ( )  AS MaxAgeOverall,
    count(age) OVER ( PARTITION BY sex )   AS CountWithThisSex,
    count(age) OVER ( )  AS CountOverall
FROM dbo.doggos
ORDER BY sex;
GO

--oh, let's talk running totals
--SUM with a window
--Look at the last two rows in this one, what happened?
SELECT 
    doggo,
    age,
    SUM(age) OVER (ORDER BY age) AS agerunningtotal,
    SUM(age) OVER () AS agetotal
FROM dbo.doggos
ORDER BY age;

--Compare
SELECT 
    dogid,
    doggo,
    age,
    SUM(age) OVER (ORDER BY dogid) AS agerunningtotal,
    SUM(age) OVER () AS agetotal
FROM dbo.doggos
ORDER BY dogid;
GO


--running total with partitions
SELECT 
    doggo,
    sex,
    age,
    SUM(age) OVER (PARTITION BY sex ORDER BY age) AS agerunningtotalforsex,
    SUM(age) OVER (PARTITION BY sex) AS agetotalforsex
FROM dbo.doggos
ORDER BY sex, age;
GO