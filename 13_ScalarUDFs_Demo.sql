/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Scalar User Defined Functions (UDFs)

EXAMPLES FOR STUDY

Documentation:

https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/create-user-defined-functions-database-engine#Scalar
https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-functions-the-basics

*****************************************************************************/

/* ✋🏻 Doorstop ✋🏻  */
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

--DROP IF EXISTS is SQL Server 2016 SP3
DROP TABLE IF EXISTS dbo.doggos,
                     dbo.jobbos,
                     dbo.doggoswithjobbos;
GO

--Let's normalize this schema!
CREATE TABLE dbo.doggos
(
    dogid INT IDENTITY,
    doggo VARCHAR(128) NOT NULL,
    CONSTRAINT pk_doggos
        PRIMARY KEY CLUSTERED (dogid)
);
GO

CREATE TABLE dbo.jobbos
(
    jobid INT IDENTITY,
    jobbo VARCHAR(128) NOT NULL,
    CONSTRAINT pk_jobbos
        PRIMARY KEY CLUSTERED (jobid)
);
GO

CREATE TABLE dbo.doggoswithjobbos
(
    dobbojobboid INT IDENTITY,
    dogid INT NOT NULL,
    jobid INT NOT NULL,
    CONSTRAINT pk_doggoswithjobbos
        PRIMARY KEY CLUSTERED (dobbojobboid),
    INDEX uq_dogid_jobid (dogid, jobid)
);
GO

--And now, some foreign keys
ALTER TABLE dbo.doggoswithjobbos
ADD CONSTRAINT fk_doggoswithjobbos_dogid
    FOREIGN KEY (dogid)
    REFERENCES dbo.doggos (dogid);
GO

ALTER TABLE dbo.doggoswithjobbos
ADD CONSTRAINT fk_doggoswithjobbos_jobid
    FOREIGN KEY (jobid)
    REFERENCES dbo.jobbos (jobid);
GO

INSERT dbo.doggos
(
    doggo
)
VALUES
('Mister'),
('Stormy');
GO

INSERT dbo.jobbos
(
    jobbo
)
VALUES
('Tootstah'),
('Cuddler'),
('Patrollster'),
('Mushroom'),
('Best Fren');
GO

INSERT dbo.doggoswithjobbos
(
    dogid,
    jobid
)
VALUES
(1, 1),
(1, 3),
(1, 5),
(2, 2),
(2, 4),
(2, 5);

--Not very readable, is it?
SELECT *
FROM dbo.doggoswithjobbos;
GO


/******************************************************************************
Create some scalar UDFs

Scalar: returns one value
UDFs: user defined functions
*****************************************************************************/


--CREATE OR ALTER is SQL Server 2016 SP1+
--Before that you have DROP and you have CREATE :)
CREATE OR ALTER FUNCTION dbo.jobidtojobbo
(
    @jobid INT
)
RETURNS VARCHAR(128)
AS
BEGIN
    DECLARE @jobbo VARCHAR(128);

    SELECT @jobbo = jobbo
    FROM dbo.jobbos
    WHERE jobid = @jobid;

    RETURN @jobbo;
END;
GO

CREATE OR ALTER FUNCTION dbo.dogidtodoggo
(
    @dogid INT
)
RETURNS VARCHAR(128)
AS
BEGIN
    DECLARE @doggo VARCHAR(128);

    SELECT @doggo = doggo
    FROM dbo.doggos
    WHERE dogid = @dogid;

    RETURN @doggo;
END;
GO



/******************************************************************************
Example: UDF in SELECT and WHERE
*****************************************************************************/

SELECT dbo.dogidtodoggo(dogid) AS doggo,
       dbo.jobidtojobbo(jobid) AS jobbo
FROM dbo.doggoswithjobbos;
GO

--Look at estimated plan and actual plan
SELECT dbo.dogidtodoggo(dogid) AS doggo,
       dbo.jobidtojobbo(jobid) AS jobbo
FROM dbo.doggoswithjobbos
WHERE dbo.dogidtodoggo(dogid) = 'Mister';


--Compare to:
SELECT d.doggo,
       j.jobbo
FROM dbo.doggoswithjobbos AS dwj
    JOIN dbo.doggos AS d
        ON dwj.dogid = d.dogid
    JOIN dbo.jobbos AS j
        ON dwj.jobid = j.jobid
WHERE d.doggo = 'Mister';
GO



/******************************************************************************
Example: UDF in GROUP BY
*****************************************************************************/

--Look at estimated plan and actual plan
SELECT dbo.jobidtojobbo(jobid) AS jobbo,
       COUNT(*) AS doggocount
FROM dbo.doggoswithjobbos
GROUP BY dbo.jobidtojobbo(jobid);
GO

--Compare to:
SELECT j.jobbo,
       COUNT(*) AS doggocount
FROM dbo.doggoswithjobbos AS dwj
    JOIN dbo.doggos AS d
        ON dwj.dogid = d.dogid
    JOIN dbo.jobbos AS j
        ON dwj.jobid = j.jobid
GROUP BY j.jobbo;
GO


/******************************************************************************
Example:NESTED UDF
(This kind of hurt me to write because of the problems with scalar UDFs, but it was also fun in a way.)
*****************************************************************************/
CREATE OR ALTER FUNCTION dbo.jobidtodoggos
(
    @jobid INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @doggos VARCHAR(MAX);

    --STRING_AGG is SQL Server 2017+
    SELECT @doggos = STRING_AGG(CAST((dbo.dogidtodoggo(dogid)) AS VARCHAR(MAX)), ',')
    FROM dbo.doggoswithjobbos
    WHERE jobid = @jobid;

    RETURN @doggos;
END;
GO

--Look at estimated plan
--Acronym: RBAR - Row By Agonizing Row
SELECT dbo.jobidtojobbo(jobid) AS jobbo,
       dbo.jobidtodoggos(jobid) AS doggo_list
FROM dbo.jobbos;
GO


--Compare to:
SELECT j.jobbo,
       STRING_AGG(d.doggo, ',') AS doggo_list
FROM dbo.doggoswithjobbos AS dwj
    JOIN dbo.doggos AS d
        ON dwj.dogid = d.dogid
    JOIN dbo.jobbos AS j
        ON dwj.jobid = j.jobid
GROUP BY j.jobbo;
GO