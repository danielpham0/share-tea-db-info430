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

-- CREATE EMPLOYEE_TYPE TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'EMPLOYEE_TYPE')
BEGIN
   DROP TABLE EMPLOYEE_TYPE
END
CREATE TABLE [dbo].[EMPLOYEE_TYPE](
   [EmployeeTypeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [EmpoyeeTypeName] [varchar](25) NOT NULL,
   [EmployeeTypeDescription] [varchar](300) NOT NULL,
   [WagePerHour] [Decimal](19,4) NOT NULL
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

-- CREATE CUSTOMER TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'CUSTOMER')
BEGIN
   DROP TABLE CUSTOMER
END
CREATE TABLE [dbo].[CUSTOMER](
   [CustomerID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [GenderID] [int] NOT NULL FOREIGN KEY REFERENCES GENDER(GenderID),
   [CustomerFname] [varchar](25) NOT NULL,
   [CustomerLname] [varchar](25) NOT NULL,
   [CustomerDOB] [Date] NOT NULL
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

-- CREATE SIZE TABLE 
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'SIZE')
BEGIN
   DROP TABLE SIZE
END
CREATE TABLE [dbo].[SIZE](
   [SizeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [SizeName] [varchar](100) NOT NULL,
   [SizeDescription] [varchar](300) NULL
) ON [PRIMARY]
GO

-- CREATE MEASUREMENT TABLE 
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'MEASUREMENT')
BEGIN
   DROP TABLE MEASUREMENT
END
CREATE TABLE [dbo].[MEASUREMENT](
   [MeasurementID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [MeasurementName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO

-- CREATE ORDER TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'ORDER')
BEGIN
   DROP TABLE [ORDER]
END
CREATE TABLE [dbo].[ORDER](
   [OrderID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [CustomerID] int NOT NULL FOREIGN KEY REFERENCES CUSTOMER(CustomerID),
   [EmployeeID] int NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EmployeeID),
   [OrderDate] [Date] NOT NULL,
   OrderTotal money NOT NULL
) ON [PRIMARY]
GO

-- CREATE DRINK_ORDER TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK_ORDER')
BEGIN
   DROP TABLE DRINK_ORDER
END
CREATE TABLE [dbo].[DRINK_ORDER](
   [DrinkOrderID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [DrinkID] [int] NOT NULL FOREIGN KEY REFERENCES DRINK(DRINKID),
   [OrderID] [int] NOT NULL FOREIGN KEY REFERENCES [ORDER](OrderID),
   [SizeID] [int] NOT NULL FOREIGN KEY REFERENCES SIZE(SizeID),
   [Quantity] [int] NOT NULL
) ON [PRIMARY]
GO

-- CREATE INGREDIENT TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'INGREDIENT')
BEGIN
   DROP TABLE INGREDIENT
END
CREATE TABLE [dbo].[INGREDIENT](
   [IngredientID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [IngredientName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO

-- CREATE DRINK_INGREDIENT TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK_INGREDIENT')
BEGIN
   DROP TABLE DRINK_INGREDIENT
END
CREATE TABLE [dbo].[DRINK_INGREDIENT](
   [DrinkIngredientID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [DrinkID] [int] NOT NULL FOREIGN KEY REFERENCES DRINK(DrinkID),
   [MeasurementID] [int] NOT NULL FOREIGN KEY REFERENCES MEASUREMENT(MeasurementID),
   [IngredientID] [int] NOT NULL FOREIGN KEY REFERENCES INGREDIENT(IngredientID),
   [Quantity] [Decimal](7,2) NOT NULL
) ON [PRIMARY]
GO

-- CREATE ALLERGY TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'ALLERGY')
BEGIN
   DROP TABLE ALLERGY
END
CREATE TABLE [dbo].[ALLERGY](
   [AllergyID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [AllergyName] [varchar](100) NOT NULL,
   [AllergyDescription] [varchar](200) NULL
) ON [PRIMARY]
GO

-- CREATE INGREDIENT_ALLERGY TABLE
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'INGREDIENT_ALLERGY')
BEGIN
   DROP TABLE INGREDIENT_ALLERGY
END
CREATE TABLE [dbo].[INGREDIENT_ALLERGY](
   [IngredientAllergyID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [IngredientID] [int] NOT NULL FOREIGN KEY REFERENCES INGREDIENT(IngredientID),
   [AllergyID] [int] NOT NULL FOREIGN KEY REFERENCES ALLERGY(AllergyID)
) ON [PRIMARY]
GO

-- CREATE DRINK_TOPPING_ORDER TABLE 
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK_TOPPING_ORDER')
BEGIN
   DROP TABLE DRINK_TOPPING_ORDER
END
CREATE TABLE [dbo].[DRINK_TOPPING_ORDER](
   [DrinkToppingOrderID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [DrinkOrderID] [int] NOT NULL FOREIGN KEY REFERENCES DRINK_ORDER(DrinkOrderID),
   [MeasurementID] [int] NOT NULL FOREIGN KEY REFERENCES MEASUREMENT(MeasurementID),
   [Quantity] [Decimal](7,2) NOT NULL 
) ON [PRIMARY]
GO

-- CREATE TOPPING_TYPE TABLE 
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'TOPPING_TYPE')
BEGIN
   DROP TABLE TOPPING_TYPE
END
CREATE TABLE [dbo].[TOPPING_TYPE](
   [ToppingTypeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [ToppingTypeName] [varchar](100) NOT NULL,
   [ToppingTypeDescription] [varchar](300) NULL,
) ON [PRIMARY]
GO

-- CREATE TOPPING TABLE 
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'TOPPING')
BEGIN
   DROP TABLE TOPPING
END
CREATE TABLE [dbo].[TOPPING](
   [ToppingID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
   [ToppingTypeID] [int] NOT NULL FOREIGN KEY REFERENCES TOPPING_TYPE(ToppingTypeID),
   [ToppingName] [varchar](100) NOT NULL,
) ON [PRIMARY]
GO

-- CREATE DRINK_CART
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'DRINK_CART')
BEGIN
   DROP TABLE DRINK_CART
END
CREATE TABLE DRINK_CART(
    DrinkCartID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES CUSTOMER(CustomerID),
    DrinkID INT NOT NULL FOREIGN KEY REFERENCES DRINK(DrinkID),
    SizeID INT NOT NULL FOREIGN KEY REFERENCES Size(SizeID),
    Quantity INT NOT NULL
)
GO
-- CREATE TOPPING_CART
IF EXISTS (SELECT * FROM sys.sysobjects WHERE Name = 'TOPPING_CART')
BEGIN
   DROP TABLE TOPPING_CART
END
CREATE TABLE TOPPING_CART(
    ToppingCartID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    DrinkCartID INT NOT NULL FOREIGN KEY REFERENCES DRINK_CART(DrinkCartID),
    ToppingID INT NOT NULL FOREIGN KEY REFERENCES Topping(ToppingID),
    MeasurementID INT NOT NULL FOREIGN KEY REFERENCES Measurement(MeasurementID),
    Quantity DECIMAL(7,2) NOT NULL
)
GO