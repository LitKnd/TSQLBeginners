/******************************************************************************
Course videos: https://www.red-gate.com/hub/university/courses/t-sql/tsql-for-beginners
Course scripts: https://litknd.github.io/TSQLBeginners 

Stored Procedures

Homework

*****************************************************************************/

/* ✋🏻 Doorstop ✋🏻  */
RAISERROR ( N'Did you mean to run the whole thing?', 20, 1 ) WITH LOG ;
GO

USE WideWorldImporters;
GO


/* Q1

Create a procedure named dbo.MostRecentInvoiceIDForCustomerID with two parameters:

    @CustomerID INT,
    @InvoiceID INT OUTPUT

The query should return the most recent InvoiceID for that CustomerID based on the 
InvoiceDate column

Write code to execute the procedure and return the most recent InvoiceID for @CustomerID = 1

The result should be InvoiceID 70232

*/















/* Q2

This question builds on the prior question

Create a procedure named dbo.MostRecentInvoiceLinesForCustomerID with one parameter:
    @CustomerID INT

This procedure should call the dbo.MostRecentInvoiceIDForCustomerID procedure to get
    the most recent InvoiceID

It should then query the Sales.InvoiceLines table and return a dataset containing the
following columns:
    InvoiceID,
    InvoiceLineID,
    Description,
    Quantity,
    UnitPrice


Write code to execute dbo.MostRecentInvoiceIDForCustomerID and return the most recent dataset for CustomerID = 1

The result set should look like this:

InvoiceID	InvoiceLineID	Description	                            Quantity	UnitPrice
---------   -------------   ----------------------------------      --------    ---------
70232	    227357	        Tape dispenser (Black)	                50	        32.00
70232	    227358	        10 mm Double sided bubble wrap 20m	    20	        30.00
*/














