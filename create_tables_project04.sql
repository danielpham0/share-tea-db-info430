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

-- CREATE ORDER TABLE (NEEDS CUSTOMER TABLE)
-- IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'ORDER')
-- BEGIN
--    DROP TABLE ORDER
-- END
-- CREATE TABLE [dbo].[ORDER](
--    [OrderID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
--    [CustomerID] int NOT NULL FOREIGN KEY REFERENCES CUSTOMER(CustomerID),
--    [EmployeeID] int NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EmployeeID),
--    [OrderDate] [Date] NOT NULL,
--    OrderTotal money NOT NULL
-- ) ON [PRIMARY]
-- GO

-- CREATE DRINK TYPE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK_TYPE')
BEGIN
   DROP TABLE DRINK_TYPE
END
CREATE TABLE [dbo].[DRINK_TYPE](
   [DrinkTypeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [DrinkTypeName] [varchar](50) NOT NULL,
   [DrinkTypeDescription] [varchar](500) NULL
) ON [PRIMARY]
GO

-- CREATE DRINK TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK')
BEGIN
   DROP TABLE DRINK
END
CREATE TABLE [dbo].[DRINK](
   [DrinkID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [DrinkTypeID] [int] NOT NULL FOREIGN KEY REFERENCES DRINK_TYPE(DrinkTypeID),
   [DrinkName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO

-- CREATE DRINK_ORDER TABLE (NEEDS SIZE TABLE)
-- IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK_ORDER')
-- BEGIN
--    DROP TABLE DRINK_ORDER
-- END
-- CREATE TABLE [dbo].[DRINK_ORDER](
--    [DrinkOrderID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
--    [DrinkID] [int] NOT NULL FOREIGN KEY REFERENCES DRINK(DRINKID),
--    [OrderID] [int] NOT NULL FOREIGN KEY REFERENCES ORDER(OrderID),
--    [SizeID] [int] NOT NULL FOREIGN KEY REFERENCES SIZE(SizeID),
-- ) ON [PRIMARY]
-- GO