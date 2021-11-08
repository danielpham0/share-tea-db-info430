-- CREATE DATABASE
Begin Try
    Use Master;
    If Exists(Select Name From SysDatabases Where Name = 'INFO_430_Proj_04')
    Begin
        Alter Database [INFO_430_Proj_04] set Single_user With Rollback Immediate;
        Drop Database INFO_430_Proj_04;
    End
    Create Database INFO_430_Proj_04;
End Try
Begin Catch
    Print Error_Number();
End Catch
go
Use INFO_430_Proj_04;

-- CREATE CUSTOMER TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'CUSTOMER')
BEGIN
   DROP TABLE CUSTOMER
END
CREATE TABLE [dbo].[CUSTOMER](
   [CustomerID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [CustomerFname] [varchar](25) NOT NULL,
   [CustomerLname] [varchar](25) NOT NULL,
   [CustomerDOB] [Date] NULL
) ON [PRIMARY]
GO
