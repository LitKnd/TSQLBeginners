/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

JOINs: INNER, OUTER, FULL, CROSS

HOMEWORK FILE

For best results,  work through this homework and test running the queries (learn by "doing" when you can)

Need some help?
	Join the SQL Community Slack group for discussion: https://t.co/w5LWUuDrqG
	Click the + next to 'Channels' and join #tsqlbeginners

*****************************************************************************/


/* Doorstop */
RAISERROR(N'Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO


/******************************************************************************
Homework
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
Q1 
Return two columns: 
    StateProvinceName, CountryName

Return rows for all StateProvinces which have a related CountryID.


This should return 53 rows.
*/









/* 
Q2
Return two columns: 
    StateProvinceName, CountryName

Return rows for all Countries, with a related StateProvideName IF it exists.
The query should return 242 rows.

Write two versions of the query, one with a LEFT OUTER JOIN,
and one with a RIGHT OUTER JOIN
*/








/* 
Q3
Return one column: 
    CountryName

Return rows for all CountryNames which do NOT have a related row in StateProvinces.

The query should return 189 rows.
*/







/* 
Q4
Return one column: 
    CountryName

Return rows for a DISTINCT list of countries which DO have a related row in StateProvinces.
This should return one row.
*/







/* 
Q5
Return two columns: 
    CountryName, StateProvinceName
Return rows for all CountryNames and related StateProvinceNames
    even if the Country does not have a related StateProvince
    or even if the StateProvince does not have a related country
*/








/* 
Q6
Return three columns: CountryName, StateProvinceName, StateProvinceId
List every possible combination of:
      * CountryName
      * StateProvinceName, StateProvinceID

Order the results by:
    CountryName, StateProvinceName, StateProvinceID

Application.Countries has 190 rows,  Application.StateProvinces has 53 rows
So this should return 190 x 53 = 10070 rows
*/








/* 
Q7

SELECT four columns:
    Column 1: The CountryName for CountryID = 100
    Column 2: The LatestRecordedPopulation for CountryID = 100
    Column 3: The CountryName for the Country whose LatestRecordedPopulation 
              is less than, but closest to that of CountryID = 100
    Column 4: The LatestRecordedPopulation for the Country in Column 3 (next lowest population)

Return one row (where CountryID = 100).
Use a self-join to get this result.
*/









--Simple query to check your work on this problem
SELECT CountryID,
       CountryName,
       LatestRecordedPopulation
FROM Application.Countries
ORDER BY LatestRecordedPopulation DESC;
GO


