/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Table Valued Functions (with a bit of CROSS APPLY)

EXAMPLES FOR STUDY

Documentation:

https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/create-user-defined-functions-database-engine#Scalar
https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-functions-the-basics

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

--DROP IF EXISTS is SQL Server 2016 SP3
DROP TABLE IF EXISTS dbo.doggos, dbo.jobbos, dbo.doggoswithjobbos ;
GO

--Let's normalize this schema!
CREATE TABLE dbo.doggos
    (dogid INT IDENTITY,
     doggo VARCHAR(128) NOT NULL,
     CONSTRAINT pk_doggos PRIMARY KEY CLUSTERED(dogid)) ;
GO

CREATE TABLE dbo.jobbos
    (jobid INT IDENTITY,
     jobbo VARCHAR(128) NOT NULL,
     CONSTRAINT pk_jobbos PRIMARY KEY CLUSTERED(jobid)) ;
GO

CREATE TABLE dbo.doggoswithjobbos
    (dobbojobboid INT IDENTITY,
     dogid INT NOT NULL,
     jobid INT NOT NULL,
     CONSTRAINT pk_doggoswithjobbos PRIMARY KEY CLUSTERED(dobbojobboid),
     INDEX uq_dogid_jobid(dogid, jobid)) ;
GO

--And now, some foreign keys
ALTER TABLE dbo.doggoswithjobbos
ADD CONSTRAINT fk_doggoswithjobbos_dogid FOREIGN KEY(dogid)REFERENCES dbo.doggos(dogid) ;
GO

ALTER TABLE dbo.doggoswithjobbos
ADD CONSTRAINT fk_doggoswithjobbos_jobid FOREIGN KEY(jobid)REFERENCES dbo.jobbos(jobid) ;
GO

INSERT dbo.doggos(doggo)VALUES('Mister'), ('Stormy') ;
GO

INSERT dbo.jobbos(jobbo)
VALUES
    ('Tootstah'),
    ('Cuddler'),
    ('Patrollster'),
    ('Mushroom'),
    ('Best Fren') ;
GO

INSERT dbo.doggoswithjobbos(dogid, jobid)
VALUES
    (1, 1),
    (1, 3),
    (1, 5),
    (2, 2),
    (2, 4),
    (2, 5) ;

--Not very readable, is it?
SELECT * FROM dbo.doggoswithjobbos ;
GO


/******************************************************************************
Create some scalar UDFs

Scalar: returns one value
UDFs: user defined functions
*****************************************************************************/


--CREATE OR ALTER is SQL Server 2016 SP1+
--Before that you have DROP and you have CREATE

--Scalar UDF from last week
CREATE OR ALTER FUNCTION dbo.jobidtojobbo(@jobid INT)
RETURNS VARCHAR(128)
AS
    BEGIN
        DECLARE @jobbo VARCHAR(128) ;
        
        SELECT @jobbo=jobbo FROM dbo.jobbos WHERE jobid=@jobid ;

        RETURN @jobbo ;
    END ;
GO

--Single statement tvf
CREATE OR ALTER FUNCTION dbo.jobidtojobbo_tvf(@jobid INT)
RETURNS TABLE
AS
    RETURN
        SELECT jobbo FROM dbo.jobbos WHERE jobid=@jobid ;
GO


--Scalar UDF from last week
CREATE OR ALTER FUNCTION dbo.dogidtodoggo(@dogid INT)
RETURNS VARCHAR(128)
AS
    BEGIN
        DECLARE @doggo VARCHAR(128) ;

        SELECT @doggo=doggo FROM dbo.doggos WHERE dogid=@dogid ;

        RETURN @doggo ;
    END ;
GO

--Single statement tvf
CREATE OR ALTER FUNCTION dbo.dogidtodoggo_tvf(@dogid INT)
RETURNS TABLE
AS
    RETURN
        SELECT doggo FROM dbo.doggos WHERE dogid=@dogid ;
GO



/******************************************************************************
Example: UDF in SELECT and WHERE
*****************************************************************************/


--Scalar UDFs (from last week)
SELECT 
    dbo.dogidtodoggo ( dogid ) AS doggo, 
    dbo.jobidtojobbo ( jobid ) AS jobbo
FROM dbo.doggoswithjobbos
WHERE 
    dbo.dogidtodoggo ( dogid ) = 'Mister' ;
GO



--Hmm, I can't just swap in the TVF names?
--Well, I guess I have to think, then.
SELECT 
    dbo.dogidtodoggo_tvf ( dogid ) AS doggo, 
    dbo.jobidtojobbo_tvf ( jobid ) AS jobbo
FROM dbo.doggoswithjobbos
WHERE 
    dbo.dogidtodoggo_tvf ( dogid ) = 'Mister' ;
GO






--Compare estimated and actual

--TFV using subqueries
--This syntax is awkward, LOL
SELECT 
    (SELECT doggo FROM dbo.dogidtodoggo_tvf ( dogid )) AS doggo, 
    (SELECT jobbo FROM dbo.jobidtojobbo_tvf ( jobid )) AS jobbo
FROM dbo.doggoswithjobbos
WHERE
    (SELECT doggo FROM dbo.dogidtodoggo_tvf ( dogid )) = 'Mister';
GO


--Example with joins (no function at all)
SELECT 
    d.doggo, 
    j.jobbo
FROM dbo.doggoswithjobbos AS dwj
JOIN dbo.doggos AS d ON dwj.dogid = d.dogid
JOIN dbo.jobbos AS j ON dwj.jobid = j.jobid
WHERE 
    d.doggo = 'Mister' ;


--Compare that to this:
--We can use CROSS APPLY syntax with TVFs
--This gives us a way to join to these single statement TVFs in an efficient way
SELECT 
    d.doggo,
    j.jobbo
FROM dbo.doggoswithjobbos AS dwj
CROSS APPLY (SELECT doggo FROM dbo.dogidtodoggo_tvf ( dwj.dogid )) AS d 
CROSS APPLY (SELECT jobbo FROM dbo.jobidtojobbo_tvf ( dwj.jobid )) AS j
WHERE
    d.doggo = 'Mister';
GO

/* Docs on APPLY (introduced in SQL Server 2005):
https://docs.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql?view=sql-server-ver15#using-apply

For super nerdery...
Apply is a "correlated join", for more info see Paul White's answer here: https://dba.stackexchange.com/questions/75048/outer-apply-vs-left-join-performance
*/



/******************************************************************************
Example: UDF in GROUP BY
*****************************************************************************/

--Scalar UDFs from last week
SELECT 
    dbo.jobidtojobbo ( jobid ) AS jobbo,
    COUNT ( * ) AS doggocount
FROM dbo.doggoswithjobbos
GROUP BY dbo.jobidtojobbo ( jobid ) ;
GO

--Rewrite with the TVF....?
SELECT 
    (SELECT jobid FROM dbo.jobidtojobbo_tvf ( jobid )) AS jobbo,
    COUNT ( * ) AS doggocount
FROM dbo.doggoswithjobbos
GROUP BY (SELECT jobid FROM dbo.jobidtojobbo_tvf ( jobid )) ;
GO

--OK, well let's use CROSS APPLY
SELECT 
    j.jobbo,
    COUNT ( * ) AS doggocount
FROM dbo.doggoswithjobbos
CROSS APPLY (SELECT jobbo FROM dbo.jobidtojobbo_tvf ( jobid )) AS j
GROUP BY j.jobbo ;


--Compare to equivalent with no function
SELECT 
    j.jobbo,
    COUNT (*) AS doggocount
FROM dbo.doggoswithjobbos AS dwj
JOIN dbo.doggos AS d ON dwj.dogid = d.dogid
JOIN dbo.jobbos AS j ON dwj.jobid = j.jobid
GROUP BY j.jobbo ;
GO


/******************************************************************************
You can nest functions in different ways
Let's also compare something else while we show one form  of nesting:
    single statement vs multi-statement TVFs
*****************************************************************************/


--Single statement TVF (with nested TVF)
CREATE OR ALTER FUNCTION dbo.jobidtodoggos_tvf(@jobid INT)
RETURNS TABLE
AS
    RETURN
        --STRING_AGG is SQL Server 2017+
        SELECT STRING_AGG(CAST(d.doggo AS VARCHAR(MAX)), ',') AS doggos
        FROM dbo.doggoswithjobbos
        CROSS APPLY (SELECT doggo FROM dbo.dogidtodoggo_tvf(dogid) ) AS d
        WHERE jobid = @jobid;
GO

--multi-statement TVF (with nested TVF)
CREATE OR ALTER FUNCTION dbo.jobidtodoggos_mstvf(@jobid INT)
RETURNS @mytable TABLE (doggos NVARCHAR(MAX))
AS
    BEGIN
        INSERT @mytable (doggos)
        SELECT STRING_AGG(CAST(d.doggo AS VARCHAR(MAX)), ',') AS doggos
        FROM dbo.doggoswithjobbos
        CROSS APPLY (SELECT doggo FROM dbo.dogidtodoggo_tvf(dogid) ) AS d
        WHERE jobid = @jobid;
        
        RETURN;
    END
GO

--Compare and contrast estimated plans


SELECT
    j.jobbo AS jobbo,
    (SELECT doggos from dbo.jobidtodoggos_mstvf(jobid)) AS doggo_list
FROM dbo.jobbos AS j;


SELECT
    j.jobbo AS jobbo,
    (SELECT doggos from dbo.jobidtodoggos_tvf(jobid)) AS doggo_list
FROM dbo.jobbos AS j;


--Compare to:
SELECT 
    j.jobbo,
    STRING_AGG(d.doggo, ',') AS doggo_list
FROM dbo.doggoswithjobbos AS dwj
JOIN dbo.doggos AS d ON dwj.dogid = d.dogid
JOIN dbo.jobbos AS j ON dwj.jobid = j.jobid
GROUP BY j.jobbo ;
GO