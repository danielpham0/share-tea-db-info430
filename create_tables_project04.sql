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

-- CREATE EMPLOYEE_TYPE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'EMPLOYEE_TYPE')
BEGIN
   DROP TABLE EMPLOYEE_TYPE
END
CREATE TABLE [dbo].[EMPLOYEE_TYPE](
   [EmployeeTypeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [EmpoyeeTypeName] [varchar](25) NOT NULL,
   [EmployeeTypeDescription] [varchar](300) NOT NULL,
   [WagePerHour] [Decimal(19,4)] NOT NULL
) ON [PRIMARY]
GO

-- CREATE GENDER TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'GENDER')
BEGIN
   DROP TABLE GENDER
END
CREATE TABLE [dbo].[GENDER](
   [GenderID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [GenderName] [varchar](25) NOT NULL
) ON [PRIMARY]
GO

-- CREATE STORE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'STORE')
BEGIN
   DROP TABLE STORE
END
CREATE TABLE [dbo].[STORE](
   [StoreID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [StoreName] [varchar](100) NOT NULL,
   [StoreAddress] [varchar](300) NOT NULL,
   [StoreOpeningTime] [Time] NOT NULL,
   [StoreClosingTime] [Time] NOT NULL
) ON [PRIMARY]
GO

-- CREATE SHIFT_TYPE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'SHIFT_TYPE')
BEGIN
   DROP TABLE SHIFT_TYPE
END
CREATE TABLE [dbo].[SHIFT_TYPE](
   [ShiftTypeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [ShiftTypeName] [varchar](100) NOT NULL,
   [ShiftTypeDescription] [varchar](300) NOT NULL,
   [ShiftTypeBeginTime] [Time] NOT NULL,
   [ShiftTypeEndTime] [Time] NOT NULL
) ON [PRIMARY]
GO

-- CREATE SHIFT TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'SHIFT')
BEGIN
   DROP TABLE SHIFT
END
CREATE TABLE [dbo].[SHIFT](
   [ShiftID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [ShiftTypeID] [int] NOT NULL FOREIGN KEY REFERENCES SHIFT_TYPE(ShiftTypeID),
   [StoreID] [int] NOT NULL FOREIGN KEY REFERENCES STORE(StoreID),
   [DateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO

-- CREATE EMPLOYEE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'EMPLOYEE')
BEGIN
   DROP TABLE EMPLOYEE
END
CREATE TABLE [dbo].[EMPLOYEE](
   [EmployeeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [EmployeeTypeID] [int] NOT NULL FOREIGN KEY REFERENCES EMPLOYEE_TYPE(EmployeeTypeID),
   [GenderID] [int] NOT NULL FOREIGN KEY REFERENCES GENDER(GenderID),
   [EmployeeFName] [varchar](100) NOT NULL,
   [EmployeeLName] [varchar](100) NOT NULL,
   [EmployeeDOB] [date] NOT NULL,
) ON [PRIMARY]
GO

-- CREATE SHIFT_EMPLOYEE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'SHIFT_EMPLOYEE')
BEGIN
   DROP TABLE SHIFT_EMPLOYEE
END
CREATE TABLE [dbo].[SHIFT_EMPLOYEE](
   [ShiftEmployeeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [ShiftID] [int] NOT NULL FOREIGN KEY REFERENCES SHIFT(ShiftID),
   [EmployeeID] [int] NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EmployeeID)
) ON [PRIMARY]
GO