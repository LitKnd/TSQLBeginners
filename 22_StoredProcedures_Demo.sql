/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Stored Procedures

EXAMPLES FOR STUDY

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
BEGIN
    ALTER DATABASE TSQLSchool SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TSQLSchool
END
GO

CREATE DATABASE TSQLSchool;
GO

USE TSQLSchool;
GO

--DROP IF EXISTS is SQL Server 2016 SP3+
DROP TABLE IF EXISTS dbo.doggos,
                     dbo.jobbos,
                     dbo.doggoswithjobbos;
GO

CREATE TABLE dbo.doggos
(
    dogid INT IDENTITY,
    doggo VARCHAR(128) NOT NULL,
    age TINYINT NOT NULL,
    sex CHAR(1) NOT NULL,
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
    doggo,
    age,
    sex
)
VALUES
('Mister', 10, 'M'),
('Stormy', 3, 'M'),
('Wendell', 5, 'M'),
('Kota', 10, 'F'),
('Fletcher', 4, 'M'),
('Fletcher', 1, 'F'),
('Scout', 2, 'F');
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
('Best Fren'),
('Gymster');
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
(2, 5),
(3, 2),
(3, 3),
(3, 5),
(4, 2),
(4, 5),
(5, 2),
(5, 3),
(5, 5),
(6, 5),
(6, 6),
(7, 1);
GO


/******************************************************************************
Why use stored procedures?

    * Batch multiple statements (including modifications)
    * Return data in a variety of ways (datasets, output parameters)
    * Parameterize and modularize code, make TSQL reusable
    * Handle errors, return a status value

We are just going to scratch the surface
*****************************************************************************/

--CREATE OR ALTER starts with SQL Server 2016 SP1.
--Procedures can return a dataset
CREATE OR ALTER PROCEDURE dbo.doginfofordoggo @doggo VARCHAR(128)
AS
SELECT dogid,
       sex,
       age
FROM dbo.doggos
WHERE doggo = @doggo;
GO

--This uses 'position' to supply a value for the parameter
EXEC dbo.doginfofordoggo 'Wendell';
GO

--This explicitly names the parameter and assigns a value
EXEC dbo.doginfofordoggo @doggo = 'Mister';
GO

--This explicitly names the parameter and assigns a value
EXEC dbo.doginfofordoggo @doggo = 'Fletcher';
GO





/******************************************************************************
PARAMETERS - INPUT & OUTPUT
*****************************************************************************/


--Procedures can also return OUTPUT parameters
--This can be useful if we're looking to output single values

--This procedure has one input parameter and three output parameters
CREATE OR ALTER PROCEDURE dbo.doginfofordoggo
    @doggo VARCHAR(128),
    @dogid INT OUTPUT,
    @sex CHAR(1) OUTPUT,
    @age TINYINT OUTPUT
AS
SELECT @dogid = dogid,
       @sex = sex,
       @age = age
FROM dbo.doggos
WHERE doggo = @doggo;
GO


--Using the output parameters...
--Note: look at the data. What happened here? There is more than one Fletcher!
DECLARE @dogidOUTPUT INT,
        @sexOUTPUT CHAR(1),
        @ageOUTPUT TINYINT;

EXEC dbo.doginfofordoggo @doggo = 'Fletcher',
                         @dogid = @dogidOUTPUT OUT,
                         @sex = @sexOUTPUT OUT,
                         @age = @ageOUTPUT OUT;

SELECT @dogidOUTPUT as dogidOUTPUT,
       @sexOUTPUT as sexOUTPUT,
       @ageOUTPUT as ageOUTPUT;
GO


--Here is a procedure that gets scalar values from a sub-procedure via OUTPUT parameters
--It then uses those values in another query to return a dataset
CREATE OR ALTER PROCEDURE dbo.jobboandinfofordoggo @doggo VARCHAR(128)
AS
DECLARE @dogidOUTPUT INT,
        @sexOUTPUT CHAR(1),
        @ageOUTPUT TINYINT;

EXEC dbo.doginfofordoggo @doggo = @doggo,
                         @dogid = @dogidOUTPUT OUT,
                         @sex = @sexOUTPUT OUT,
                         @age = @ageOUTPUT OUT;

SELECT dogid,
       @sexOUTPUT AS sex,
       @ageOUTPUT AS age,
       j.jobbo
FROM dbo.doggoswithjobbos AS dwj
    JOIN dbo.jobbos AS j
        ON dwj.jobid = j.jobid
WHERE dogid = @dogidOUTPUT;
GO

EXEC dbo.jobboandinfofordoggo @doggo = 'Scout';
GO
EXEC dbo.jobboandinfofordoggo @doggo = 'Stormy';
GO





/******************************************************************************
PASSING DATASETS BETWEEN PROCEDURES (one example)
*****************************************************************************/

--What if we want to use a dataset returned by a procedure in another procedure?
--This procedure returns a dataset
CREATE OR ALTER PROCEDURE dbo.doggosbyage @age TINYINT
AS
SELECT dogid,
       doggo,
       sex
FROM dbo.doggos
WHERE age = @age
GO

--It may return one row
EXEC dbo.doggosbyage @age = 2;
GO

--Or multiple rows
EXEC dbo.doggosbyage @age = 10;
GO


--This procedure calls dbo.doggosbyage, puts the data in a temporary table
--And then runs a query using that temporary table
CREATE OR ALTER PROCEDURE dbo.doginfoandjobsbyage @age TINYINT
AS
CREATE TABLE #doggos
(
    dogid INT,
    doggo VARCHAR(128) NOT NULL,
    sex CHAR(1) NOT NULL
);

--INSERT ... EXEC puts the dataset from the procedure into a table
--In this case it's a temporary table
INSERT #doggos
(
    dogid,
    doggo,
    sex
)
EXEC dbo.doggosbyage @age;

SELECT d.dogid,
       d.doggo,
       d.sex,
       j.jobbo
FROM #doggos AS d
    JOIN dbo.doggoswithjobbos AS dwj
        ON d.dogid = dwj.dogid
    JOIN dbo.jobbos AS j
        ON j.jobid = dwj.jobid;
GO

EXEC dbo.doginfoandjobsbyage @age = 2;
GO



/******************************************************************************
IF BRANCHING - ONE EXAMPLE
*****************************************************************************/


CREATE OR ALTER PROCEDURE dbo.IfIfIf @doggo VARCHAR(128)
AS
IF @doggo IS NULL
BEGIN
    SELECT 'All doggo branch' AS col1,
           doggo
    FROM dbo.doggos;

END
ELSE IF @doggo = 'Mister'
    SELECT 'Mister branch' AS col1,
           d.age,
           j.jobbo
    FROM dbo.doggos AS d
        JOIN dbo.doggoswithjobbos AS dwj
            ON d.dogid = dwj.dogid
        JOIN dbo.jobbos AS j
            ON dwj.jobid = j.jobid
    WHERE d.doggo = @doggo;


ELSE
    SELECT 'ELSE branch' AS col1;
GO

EXEC dbo.IfIfIf @doggo = NULL;
GO

EXEC dbo.IfIfIf @doggo = 'Mister';
GO

EXEC dbo.IfIfIf @doggo = 'Whatever';
GO