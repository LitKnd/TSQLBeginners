/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

CTEs, Subqueries, and Derived Tables: oh, my!

EXAMPLES FOR STUDY

Documentation:
https://docs.microsoft.com/en-us/sql/relational-databases/performance/subqueries
https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql


*****************************************************************************/

/* Doorstop */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO


/******************************************************************************
Set up sample data
*****************************************************************************/

USE master;
GO
IF DB_ID('TSQLSchool') IS NOT NULL
    DROP DATABASE TSQLSchool;
GO
CREATE DATABASE TSQLSchool;
GO
USE TSQLSchool;
GO


DROP TABLE IF EXISTS dbo.doggos;
GO

CREATE TABLE dbo.doggos
(
    doggo VARCHAR(128) NOT NULL,
    feels VARCHAR(128) NOT NULL,
    feelday DATE NOT NULL
);
GO

INSERT dbo.doggos
(
    doggo,
    feels,
    feelday
)
VALUES
('Freyja', 'Derp!', '2018-06-14'),
('Stormy', 'Loaf', '2018-06-14'),
('Freyja', 'Bamboozled', '2020-05-13'),
('Stormy', 'Tippy Taps', '2020-05-13'),
('Archie', 'Snoozy', '2020-05-12');
GO


--Stormy and Freyja have two rows each, Archie has one
SELECT *
FROM dbo.doggos
GO





-- I want to return all doggos with only their MOST RECENT feeling & feelday
-- Does this work?
SELECT doggo,
       feels,
       MAX(feelday) AS maxfeelday
FROM dbo.doggos AS d2
GROUP BY d2.doggo,
         feels
HAVING feelday = MAX(feelday);





--CTE, or "Common Table Expression"
--These start with "with"
--The statement before them in a batch must terminate with a ;
WITH maxfeels
AS (SELECT doggo,
           MAX(feelday) AS maxfeelday
    FROM dbo.doggos AS d2
    GROUP BY d2.doggo)
SELECT d1.doggo,
       d1.feels,
       d1.feelday
FROM dbo.doggos AS d1
    JOIN maxfeels
        ON d1.doggo = maxfeels.doggo
           AND d1.feelday = maxfeels.maxfeelday;
GO


--TWO CTEs. 
--Does the second add value in this case?
WITH maxfeels
AS (SELECT doggo,
           MAX(feelday) AS maxfeelday
    FROM dbo.doggos AS d2
    GROUP BY d2.doggo),
     feeldays
AS (SELECT d1.doggo,
           d1.feels,
           d1.feelday
    FROM dbo.doggos AS d1
        JOIN maxfeels
            ON /* I can join to the first CTE if I want! */
            d1.doggo = maxfeels.doggo
            AND d1.feelday = maxfeels.maxfeelday)
SELECT *
FROM feeldays;
GO



--Derived table
--This is a subquery who acts as a table in the JOIN!
SELECT d1.doggo,
       d1.feels,
       d1.feelday
FROM dbo.doggos AS d1
    JOIN
    (
        SELECT doggo,
               MAX(feelday) AS maxfeelday
        FROM dbo.doggos AS d2
        GROUP BY d2.doggo
    ) AS maxfeels
        ON d1.doggo = maxfeels.doggo
           AND d1.feelday = maxfeels.maxfeelday;
GO


--Correlated subquery
--This one is a subquery in the WHERE clause
--Inside the subquery, it joins back to another table
--(Does this really correlate in the execution plan?)
SELECT doggo,
       feels,
       feelday
FROM dbo.doggos AS d1
WHERE feelday =
(
    SELECT MAX(feelday) FROM dbo.doggos AS d2 WHERE d2.doggo = d1.doggo /* correlation from inner subquery to outer */
);
GO


--Subquery in the select
--This is a subquery that determines the value for a column for each row
--It can only return one value per row
--This example ALSO has a derived table
--This gets a less efficient plan than the others we've looked at so far
--Have fun creating different syntaxes!
SELECT feels.doggo,
       (
           SELECT feels
           FROM dbo.doggos AS d2
           WHERE d2.doggo = feels.doggo /* Correlates */
                 AND d2.feelday = feels.feelday /* Correlates */
       ) AS feels,
       feels.feelday
FROM
(
    SELECT doggo,
           MAX(feelday) AS feelday
    FROM dbo.doggos AS d1
    GROUP BY doggo
) AS feels;
GO