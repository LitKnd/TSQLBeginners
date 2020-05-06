/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

JOINs: INNER, OUTER, FULL, CROSS

SOLUTION FILE
*****************************************************************************/


/* Doorstop */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO


/******************************************************************************
Homework with Solutions
*****************************************************************************/

USE WideWorldImporters;
GO

--The questions in this homework refer to two tables:
EXEC sp_help 'Application.StateProvinces';
GO
EXEC sp_help 'Application.Countries';
GO

--Join column: CountryID


/* 
T3.Q1 
Return two columns: 
    StateProvinceName, CountryName

Return rows for all StateProvinces which have a related CountryID.

This should return 53 rows.
*/

--INNER JOIN: return all matching rows
SELECT p.StateProvinceName,
       c.CountryName
FROM Application.StateProvinces AS p
    INNER JOIN Application.Countries AS c
        ON c.CountryID = p.CountryID;
GO

--INNER is the default, and is often omitted
SELECT p.StateProvinceName,
       c.CountryName
FROM Application.StateProvinces AS p
    JOIN Application.Countries AS c
        ON c.CountryID = p.CountryID;


/*
Demo:
What if we reverse the order in which we list the tables? 
Does it change the way the query is run behind the scenes?
*/
SELECT p.StateProvinceName,
       c.CountryName
FROM Application.Countries AS c
    JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO



/* 
T3.Q2
Return two columns: 
    StateProvinceName, CountryName

Return rows for all Countries, with a related StateProvinceName IF it exists.
The query should return 242 rows.

Write two versions of the query, one with a LEFT OUTER JOIN,
and one with a RIGHT OUTER JOIN
*/



--LEFT OUTER: return all the rows in the "LEFT" table (Application.Countries)
--add matching rows in the "RIGHT" table (Application.StateProvinces) when possible
SELECT p.StateProvinceName,
       c.CountryName
FROM Application.Countries AS c
    LEFT OUTER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO

--RIGHT OUTER: return all the rows in the "RIGHT" table (Application.Countries)
--add matching rows in the "LEFT" table (Application.StateProvinces) when possible
SELECT p.StateProvinceName,
       c.CountryName
FROM Application.StateProvinces AS p
    RIGHT OUTER JOIN Application.Countries AS c
        ON c.CountryID = p.CountryID;
GO

--OUTER is optional, and is often omitted
SELECT p.StateProvinceName,
       c.CountryName
FROM Application.StateProvinces AS p
    RIGHT JOIN Application.Countries AS c
        ON c.CountryID = p.CountryID;
GO



/* 
T3.Q3
Return one column: 
    CountryName

Return rows for all CountryNames which do NOT have a related row in StateProvinces.

The query should return 189 rows.
*/

--Pattern: OUTER JOIN + WHERE clause filter

/*
https://www.microsoftpressstore.com/articles/article.aspx?p=2201633&seqNum=3

Logical Query Processing Order

    FROM

    WHERE

    GROUP BY

    HAVING

    SELECT

    ORDER BY

*/

SELECT c.CountryName, c.CountryID
FROM Application.Countries AS c
--LEFT OUTER: Return all rows in the "LEFT" table (Application.Countries)
--add matching rows in the "RIGHT" table (Application.StateProvinces) when possible
    LEFT OUTER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID
--WHERE clause only includes rows which don't have an Application.StateProvinces.CountryID
WHERE p.CountryID IS NULL


--This can be written with a RIGHT outer join as well
SELECT c.CountryName
FROM Application.StateProvinces AS p
    RIGHT OUTER JOIN Application.Countries AS c
        ON c.CountryID = p.CountryID
WHERE p.StateProvinceID IS NULL;
GO



--Discussion: This rewrite of putting the "IS NULL" in the OUTER JOIN itself does NOT work
--Tip: the 'United States' is the only country with related State Provinces, so if it's in the list this did NOT work
SELECT c.CountryName, c.CountryID
FROM Application.Countries AS c
    LEFT OUTER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID
        and p.CountryID IS NULL;
GO

--Similarly....
SELECT c.CountryName, c.CountryID
FROM Application.Countries AS c
    LEFT OUTER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID
        and c.CountryID <> p.CountryID;
GO


/* 
T3.Q4
Return one column: 
    CountryName

Return rows for a DISTINCT list of countries which DO have a related row in StateProvinces.
This should return one row.
*/
SELECT DISTINCT
       c.CountryName
FROM Application.Countries AS c
    INNER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID;
GO


/* 
T3.Q5
Return two columns: 
    CountryName, StateProvinceName
Return rows for all CountryNames and related StateProvinceNames
    even if the Country does not have a related StateProvince
    or even if the StateProvince does not have a related country
*/

/* Order of the tables specified does not matter */
SELECT c.CountryName,
       p.StateProvinceName
FROM Application.Countries AS c
    FULL OUTER JOIN Application.StateProvinces AS p
        ON c.CountryID = p.CountryID
ORDER BY c.CountryName,
         p.StateProvinceName,
         p.StateProvinceID;
GO





/* 
T3.Q6
Return three columns: CountryName, StateProvinceName, StateProvinceId
List every possible combination of:
      * CountryName
      * StateProvinceName, StateProvinceID

Order the results by:
    CountryName, StateProvinceName, StateProvinceID

Application.Countries has 190 rows,  Application.StateProvinces has 53 rows
So this should return 190 x 53 = 10070 rows
*/
SELECT c.CountryName,
       p.StateProvinceName,
       p.StateProvinceID
FROM Application.Countries AS c
    CROSS JOIN Application.StateProvinces AS p
ORDER BY c.CountryName,
         p.StateProvinceName,
         p.StateProvinceID;
GO


/* 
T3.Q7

SELECT four columns:
    Column 1: The CountryName for CountryID = 100
    Column 2: The LatestRecordedPopulation for CountryID = 100
    Column 3: The CountryName for the Country whose LatestRecordedPopulation 
              is less than, but closest to that of CountryID = 100
    Column 4: The LatestRecordedPopulation for the Country in Column 3 (next lowest population)

Return one row (where CountryID = 100).
Use a self-join to get this result.
*/
SELECT TOP 1
       c1.CountryName,
       c1.LatestRecordedPopulation,
       c2.CountryName,
       c2.LatestRecordedPopulation
FROM Application.Countries AS c1
    JOIN Application.Countries AS c2
        ON c2.LatestRecordedPopulation < c1.LatestRecordedPopulation
WHERE c1.CountryID = 100
ORDER BY c2.LatestRecordedPopulation DESC;
GO


--Simple query to check your work
SELECT CountryID,
       CountryName,
       LatestRecordedPopulation
FROM Application.Countries
ORDER BY LatestRecordedPopulation DESC;
GO


