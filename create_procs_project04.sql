Use INFO_430_Proj_04;
DROP PROCEDURE IF EXISTS getDrinkTypeID, getDrinkID, getCustomerID, insertIntoDrink
GO
-- getDrinkTypeID
CREATE PROCEDURE getDrinkTypeID
    @DTypeName varchar(50),
    @DTypeID int OUTPUT
AS
SET @DTypeID = (SELECT DrinkTypeID FROM DRINK_TYPE WHERE DrinkTypeName = @DTypeName)
GO

-- getDrinkID
CREATE PROCEDURE getDrinkID
    @DName varchar(50),
    @DID int OUTPUT
AS
SET @DID = (SELECT DrinkID FROM Drink WHERE DrinkName = @DName)
GO

-- getCustomerID
CREATE PROCEDURE getCustomerID
    @CFname varchar(50),
    @CLname varchar(50),
    @CDOB date,
    @CID int OUTPUT
AS
SET @CID = (SELECT CustomerID FROM Customer WHERE CustomerFname = @CFname and CustomerLname = @CLname and CustomerDOB = @CDOB)
GO

-- getSizeID
CREATE PROCEDURE getSizeID
    @SName varchar(50),
    @SID int OUTPUT
AS
SET @SID = (SELECT SizeID FROM SIZE WHERE SizeName = @SName)
GO

-- getEmployeeID
CREATE PROCEDURE getEmployeeID
    @EFname varchar(50),
    @ELname varchar(50),
    @EDOB date,
    @EID int OUTPUT
AS
SET @EID = (SELECT EmployeeID FROM EMPLOYEE WHERE EmployeeFName = @EFName AND EmployeeLName = @ELName AND EmployeeDOB = @EDOB)
GO

-- getStoreID
CREATE PROCEDURE getStoreID
    @SName varchar(50),
    @SID int OUTPUT
AS
SET @SID = (SELECT StoreID FROM STORE WHERE StoreName = @SName)
GO

-- getEmployeeTypeID
CREATE PROCEDURE getEmployeeTypeID
    @ETypeName varchar(50),
    @ETID int OUTPUT
AS
SET @ETID = (SELECT EmployeeTypeID FROM EMPLOYEE_TYPE WHERE EmployeeTypeName = @ETypeName)
GO

-- getGenderID
CREATE PROCEDURE getGenderID
    @GName varchar(50),
    @GID int OUTPUT
AS
SET @GID = (SELECT GenderID FROM GENDER WHERE GenderName = @GName)
GO

-- getShiftTypeID
CREATE PROCEDURE getShiftTypeID
    @STypeName varchar(50),
    @STID int OUTPUT
AS
SET @STID = (SELECT ShiftTypeID FROM SHIFT_TYPE WHERE ShiftTypeName = @STypeName)
GO

-- getShiftID
CREATE PROCEDURE getShiftID
    @STypeID int, 
    @StoreID int, 
    @ShiftDate datetime, 
    @SID int OUTPUT
AS
SET @SID = (SELECT ShiftID FROM SHIFT WHERE ShiftTypeID = @STypeID AND StoreID = @StoreID AND [DateTime] = @ShiftDate)
GO

-- insertIntoEmployee
CREATE PROCEDURE insertIntoEmployee
    @FName varchar(100),
    @LName varchar(100),
    @DOB date,
    @EmployeeTypeName varchar(50),
    @GenderName varchar (50)
    AS
    DECLARE @EmployeeTypeID INT
    DECLARE @GenderID INT
    IF @EmployeeTypeName IS NULL OR @FName IS NULL OR @LName IS NULL OR @DOB IS NULL OR @GenderName IS NULL
    BEGIN 
        PRINT 'Parameters for insert Employee cannot be null.';
        THROW 99999, 'Parameters for insertion were null', 1;
    END

    EXEC getEmployeeTypeID
        @ETypeName = @EmployeeTypeName,
        @ETID = @EmployeeTypeID OUTPUT
    IF (@EmployeeTypeID IS NULL)
    BEGIN 
        PRINT 'Could not find a EmployeeType ID from parameters!';
        THROW 99999, '@EmployeeTypeID returned null value.', 1;
    END

    EXEC getGenderID
        @GName = @GenderName,
        @GID = @GenderID OUTPUT
    IF (@GenderID IS NULL)
    BEGIN 
        PRINT 'Could not find a Gender ID from parameters!';
        THROW 99999, '@GenderID returned null value.', 1;
    END
    
    BEGIN TRAN T1
    INSERT INTO EMPLOYEE (EmployeeTypeID, GenderID, EmployeeFName, EmployeeLName, EmployeeDOB)
        VALUES (@EmployeeTypeID, @GenderID, @FName, @LName, @DOB)
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- insertIntoShiftEmployee
CREATE PROCEDURE insertIntoShiftEmployee
    @FName varchar(100),
    @LName varchar(100),
    @DOB date,
    @StoreName varchar(50),
    @ShiftTypeName varchar (50),
    @Date datetime
    AS
    DECLARE @EmployeeID INT
    DECLARE @ShiftID INT
    DECLARE @Store_ID INT
    DECLARE @ShiftTypeID INT
    IF @StoreName IS NULL OR @FName IS NULL OR @LName IS NULL OR @DOB IS NULL OR @ShiftTypeName IS NULL OR @Date IS NULL
    BEGIN 
        PRINT 'Parameters for insert ShiftEmployee cannot be null.';
        THROW 99999, 'Parameters for insertion were null', 1;
    END

    EXEC getEmployeeID
        @EFname = @FName,
        @ELname = @LName,
        @EDOB = @DOB, 
        @EID = @EmployeeID OUTPUT
    IF (@EmployeeID IS NULL)
    BEGIN 
        PRINT 'Could not find a Employee ID from parameters!';
        THROW 99999, '@EmployeeID returned null value.', 1;
    END

    EXEC getShiftTypeID
        @STypeName = @ShiftTypeName,
        @STID = @ShiftTypeID OUTPUT
    IF (@ShiftTypeID IS NULL)
    BEGIN 
        PRINT 'Could not find a ShiftType ID from parameters!';
        THROW 99999, '@ShiftTypeID returned null value.', 1;
    END

    EXEC getStoreID
        @SName = @StoreName,
        @SID = @Store_ID OUTPUT
    IF (@Store_ID IS NULL)
    BEGIN 
        PRINT 'Could not find a Store ID from parameters!';
        THROW 99999, '@Store_ID returned null value.', 1;
    END

    EXEC getShiftID
        @STypeID = @ShiftTypeID,
        @StoreID = @Store_ID,
        @ShiftDate = @Date,
        @SID = @ShiftID OUTPUT
    IF (@ShiftID IS NULL)
    BEGIN 
        PRINT 'Could not find a Shift ID from parameters!';
        THROW 99999, '@ShiftID returned null value.', 1;
    END
    
    BEGIN TRAN T1
    INSERT INTO SHIFT_EMPLOYEE (EmployeeID, ShiftID)
        VALUES (@EmployeeID, @ShiftID)
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- insertIntoDrink
CREATE PROCEDURE insertIntoDrink
    @DrinkTypeName varchar(25),
    @DrinkName varchar(25),
    @DrinkCost money
    AS
    DECLARE @DrinkTypeID INT
    IF @DrinkTypeName IS NULL OR @DrinkName IS NULL OR @DrinkCost IS NULL
    BEGIN 
        PRINT 'Parameters for insert drink cannot be null.';
        THROW 99999, 'Parameters for insertion were null', 1;
    END
    EXEC getDrinkTypeID
        @DTypeName = @DrinkTypeName,
        @DTypeID = @DrinkTypeID OUTPUT
    IF (@DrinkTypeID IS NULL)
    BEGIN 
        PRINT 'Could not find a Drink ID from parameters!';
        THROW 99999, '@DrinkTypeID returned null value.', 1;
    END
    BEGIN TRAN T1
    INSERT INTO DRINK (DrinkTypeID, DrinkName, DrinkCost)
        VALUES (@DrinkTypeID, @DrinkName, @DrinkCost)
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- getMeasurementID
CREATE PROCEDURE getMeasurementID
    @MName varchar(50),
    @MID int OUTPUT
AS
SET @MID = (SELECT MeasurementID FROM MEASUREMENT WHERE MeasurementName = @MName)
GO

-- getIngredientID
CREATE PROCEDURE getIngredientID
    @IName varchar(50),
    @IID int OUTPUT
AS
SET @IID = (SELECT IngredientID FROM INGREDIENT WHERE IngredientName = @IName)
GO

-- getAllergyID
CREATE PROCEDURE getAllergyID
    @AName varchar(50),
    @AID int OUTPUT
AS
SET @AID = (SELECT AllergyID FROM ALLERGY WHERE AllergyName = @AName)
GO

-- insertDrinkIngredient
CREATE PROCEDURE insertDrinkIngredient
    @D_Name varchar(50),
    @M_Name varchar(50),
    @I_Name varchar(50),
    @Qty decimal(7,2)
AS
DECLARE @D_ID int, @M_ID int, @I_ID int

-- Check Parameters
IF @D_Name IS NULL OR @M_Name IS NULL OR @I_Name IS NULL OR @Qty IS NULL
BEGIN 
    PRINT 'Parameters cannot be null.';
    THROW 99999, 'Parameters for insertion were null', 1;
END

EXEC getDrinkID
    @DName = @D_Name,
    @DID = @D_ID OUTPUT

    IF @D_ID IS NULL
        BEGIN
            PRINT '@D_ID cannot be NULL';
            THROW 99999, 'NULL value not allowed', 1;
        END

EXEC getMeasurementID
    @MName = @M_Name,
    @MID = @M_ID OUTPUT

    IF @M_ID IS NULL
        BEGIN
            PRINT '@M_ID cannot be NULL';
            THROW 99999, 'NULL value not allowed', 1;
        END

EXEC getIngredientID
    @IName = @I_Name,
    @IID = @I_ID OUTPUT

    IF @I_ID IS NULL
        BEGIN
            PRINT '@I_ID cannot be NULL';
            THROW 99999, 'NULL value not allowed', 1;
        END

BEGIN TRAN T1
    INSERT INTO DRINK_INGREDIENT (DrinkID, MeasurementID, IngredientID, Quantity)
    VALUES (@D_ID, @M_ID, @I_ID, @Qty)

    IF @@ERROR <> 0
        BEGIN
            PRINT 'There has been an error when inserting. Now terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- insertIngredientAllergy
CREATE PROCEDURE insertIngredientAllergy
    @I_Name varchar(50),
    @A_Name varchar(50)
AS
DECLARE @I_ID int, @A_ID int

-- Check Parameters
IF @I_Name IS NULL OR @A_Name IS NULL
BEGIN 
    PRINT 'Parameters cannot be null.';
    THROW 99999, 'Parameters for insertion were null', 1;
END

EXEC getIngredientID
    @IName = @I_Name,
    @IID = @I_ID OUTPUT

    IF @I_ID IS NULL
        BEGIN
            PRINT '@I_ID cannot be NULL';
            THROW 99999, 'NULL value not allowed', 1;
        END

EXEC getAllergyID
    @AName = @A_Name,
    @AID = @A_ID OUTPUT

    IF @A_ID IS NULL
        BEGIN
            PRINT '@A_ID cannot be NULL';
            THROW 99999, 'NULL value not allowed', 1;
        END

BEGIN TRAN T1
    INSERT INTO INGREDIENT_ALLERGY (IngredientID, AllergyID)
    VALUES (@I_ID, @A_ID)

    IF @@ERROR <> 0
        BEGIN
            PRINT 'There has been an error when inserting. Now terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- getToppingTypeID
CREATE PROCEDURE getToppingTypeID
    @ToppingTypeName varchar(100),
    @TID int OUTPUT
AS
SET @TID = (SELECT ToppingTypeID FROM TOPPING_TYPE WHERE ToppingTypeName = @ToppingTypeName)
GO

-- getToppingID 
CREATE PROCEDURE getToppingID
    @ToppingName varchar(100),
    @TID int OUTPUT
AS
SET @TID = (SELECT ToppingID FROM TOPPING WHERE ToppingName = @ToppingName)
GO

-- INSERT TOPPING 
CREATE PROCEDURE insertTopping
    @ToppingName varchar(100),
    @ToppingTypeName varchar(100),
    @ToppingTypeDescription varchar(300)
AS
DECLARE @TTID int 

BEGIN TRAN T1 
    INSERT INTO TOPPING_TYPE(ToppingTypeName, ToppingTypeDescription)
    VALUES (@ToppingName, @ToppingTypeName)

    SET @TTID = SCOPE_IDENTITY()


    INSERT INTO TOPPING(ToppingTypeID, ToppingName)
    VALUES (@TTID, @ToppingName)
    IF @@ERROR <> 0 
            BEGIN 
                PRINT 'failed to insert';
                -- THROW 55555, 'failed to insert values', 11; 
                ROLLBACK TRAN T1
            END 
        ELSE 
            COMMIT TRAN T1 
GO 

-- Insert Shift 
CREATE PROCEDURE insertShift
@ShiftTypeName varchar(50),
@StoreName varchar(50),
@Day date 
AS 
DECLARE @ShiftTypeID int, @StoreID int 

EXEC getShiftTypeID
    @STypeName = @ShiftTypeName,
    @STID = @ShiftTypeID OUTPUT
IF (@ShiftTypeID IS NULL)
BEGIN 
    PRINT 'Could not find a ShiftType ID from parameters!';
    THROW 99999, '@ShiftTypeID returned null value.', 1;
END

EXEC getStoreID
    @SName = @StoreName,
    @SID = @StoreID OUTPUT
IF (@StoreID IS NULL)
BEGIN 
    PRINT 'Could not find a Store ID from parameters!';
    THROW 99999, '@StoreID returned null value.', 1;
END

BEGIN TRAN T1
    INSERT INTO SHIFT(ShiftTypeID, StoreID, [DateTime])
    VALUES (@ShiftTypeID, @StoreID, @Day)
    IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRAN T1 
        END 
    ELSE 
        COMMIT TRAN T1 

GO

-- CART PROCEDURES

-- insertIntoDrinkCart
CREATE PROCEDURE insertIntoDrinkCart
    @CustomerFname varchar(25),
    @CustomerLname varchar(25),
    @CustomerDOB DATE,
    @DrinkName varchar(25),
    @Size varchar(25),
    @Quantity INT
    AS
    DECLARE @CustomerID INT, @DrinkID INT, @SizeID INT
    -- CHECK PARAMETERS
    IF @CustomerFname IS NULL OR @CustomerLname IS NULL OR @CustomerDOB IS NULL 
        OR @DrinkName IS NULL OR @Size IS NULL OR @Quantity IS NULL
    BEGIN 
        PRINT 'Parameters for insert drink cannot be null.';
        THROW 99999, 'Parameters for insertion were null', 1;
    END
    -- FIND CUSTOMER ID
    EXEC getCustomerID
        @CFname = @CustomerFname,
        @CLname = @CustomerLname,
        @CDOB = @CustomerDOB,
        @CID = @CustomerID OUTPUT
    IF (@CustomerID IS NULL)
    BEGIN 
        PRINT 'Could not find a CustomerID from parameters!';
        THROW 99999, '@CustomerID returned null value.', 1;
    END
    -- FIND DRINK ID
    EXEC getDrinkID
        @DName = @DrinkName,
        @DID = @DrinkID OUTPUT
    IF (@DrinkID IS NULL)
    BEGIN 
        PRINT 'Could not find a DrinkID from parameters!';
        THROW 99999, '@DrinkID returned null value.', 1;
    END
    -- FIND SIZE ID
    EXEC getSizeID
        @SName = @Size,
        @SID = @SizeID OUTPUT
    IF (@SizeID IS NULL)
    BEGIN 
        PRINT 'Could not find a SizeID from parameters!';
        THROW 99999, '@SizeID returned null value.', 1;
    END
    -- INSERT INTO DRINK_CART
    BEGIN TRAN T1
    INSERT INTO DRINK_CART (CustomerID, DrinkID, SizeID, Quantity)
        VALUES (@CustomerID, @DrinkID, @SizeID, @Quantity)
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO
-- insertIntoToppingCart
CREATE PROCEDURE insertIntoToppingCart
    @DrinkCartID INT,
    @ToppingName varchar(25),
    @Measurement varchar(25),
    @Quantity DECIMAL(7,2)
    AS
    DECLARE @ToppingID INT, @MeasurementID INT
    -- CHECK PARAMETERS
    IF @DrinkCartID IS NULL OR @ToppingName IS NULL OR @Measurement IS NULL 
        OR @Quantity IS NULL
    BEGIN 
        PRINT 'Parameters for insert drink cannot be null.';
        THROW 99999, 'Parameters for insertion were null', 1;
    END
    -- GET TOPPING ID
    EXEC getToppingID
        @ToppingName = @ToppingName,
        @TID = @ToppingID OUTPUT
    IF (@ToppingID IS NULL)
    BEGIN 
        PRINT 'Could not find a ToppingID from parameters!';
        THROW 99999, '@ToppingID returned null value.', 1;
    END
    -- GET MEASUREMENT ID
    EXEC getMeasurementID
        @MName = @Measurement,
        @MID = @MeasurementID OUTPUT
    IF (@MeasurementID IS NULL)
    BEGIN 
        PRINT 'Could not find a MeasurementID from parameters!';
        THROW 99999, '@MeasurementID returned null value.', 1;
    END
    -- INSERT INTO TOPPING CART
    BEGIN TRAN T1
    INSERT INTO TOPPING_CART (DrinkCartID, ToppingID, MeasurementID, Quantity)
        VALUES (@DrinkCartID, @ToppingID, @MeasurementID, @Quantity)
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- processDrinkCart
CREATE PROCEDURE processDrinkCart
    @CustomerFname varchar(25),
    @CustomerLname varchar(25),
    @CustomerDOB DATE,
    @EmployeeFname varchar(25),
    @EmployeeLname varchar(25),
    @EmployeeDOB DATE,
    @OrderDate DATE
    AS
    DECLARE @CustomerID INT, @EmployeeID INT, @OrderID INT, @DrinkCartID INT, @DrinkOrderID INT,
        @DrinkID INT, @SizeID INT, @DrinkQuantity INT, @ToppingQuantity DECIMAL(7,2), @ToppingCartID INT,
        @ToppingID INT, @MeasurementID INT
    -- CHECK PARAMETERS
    IF @CustomerFname IS NULL OR @CustomerLname IS NULL OR @CustomerDOB IS NULL
    BEGIN 
        PRINT 'Parameters for insert drink cannot be null.';
        THROW 99999, 'Parameters for insertion were null', 1;
    END
    -- GET CUSTOMER ID
    EXEC getCustomerID
        @CFname = @CustomerFname,
        @CLname = @CustomerLname,
        @CDOB = @CustomerDOB,
        @CID = @CustomerID OUTPUT
    IF (@CustomerID IS NULL)
    BEGIN 
        PRINT 'Could not find a CustomerID from parameters!';
        THROW 99999, '@CustomerID returned null value.', 1;
    END
    -- DON'T CREATE NEW ORDER IF THERE IS NOTHING FOR THEM IN DRINK_CART
    IF NOT EXISTS (SELECT * FROM DRINK_CART WHERE CustomerID = @CustomerID)
    BEGIN
        RETURN
    END
    -- GET EMPLOYEE ID
    EXEC getEmployeeID
        @EFname = @EmployeeFname,
        @ELname = @EmployeeLname,
        @EDOB = @EmployeeDOB,
        @EID = @EmployeeID OUTPUT
    IF (@EmployeeID IS NULL)
    BEGIN 
        PRINT 'Could not find a EmployeeID from parameters!';
        THROW 99999, '@EmployeeID returned null value.', 1;
    END
    -- BEGIN THE PROCESSING
    BEGIN TRANSACTION T1
        -- CREATE A NEW ORDER AND RECORD THE ORDER ID
        BEGIN TRANSACTION T2
        INSERT INTO [ORDER] (CustomerID, EmployeeID, OrderDate) VALUES (@CustomerID, @EmployeeID, @OrderDate)
        SET @OrderID = (SELECT SCOPE_IDENTITY())
        IF (@OrderID IS NULL)
        BEGIN 
            PRINT 'Could not find a OrderID from parameters!';
            THROW 99999, '@OrderID returned null value.', 1;
        END
        COMMIT TRANSACTION T2
        -- CREATE A TABLE VARIABLE FOR THE CUSTOMER'S DRINKS
        BEGIN TRANSACTION T3
        DECLARE @CustomerDrinks TABLE(PKID INT IDENTITY(1,1) primary key, DrinkCartID int not null, CustomerID int not null, 
            DrinkID int not null, SizeID int not null, Quantity int not null)
        INSERT INTO @CustomerDrinks SELECT DrinkCartID, CustomerID, DrinkID, SizeID, Quantity 
            FROM DRINK_CART WHERE CustomerID = @CustomerID
        COMMIT TRANSACTION T3
        -- LOOP THROUGH EACH ONE OF THE CUSTOMER'S DRINKS
        BEGIN TRAN T4
        WHILE (SELECT COUNT(*) FROM @CustomerDrinks) > 0
            BEGIN
                SET @DrinkCartID = (SELECT TOP 1 DrinkCartID FROM @CustomerDrinks)
                SET @DrinkID = (SELECT DrinkID FROM @CustomerDrinks WHERE DrinkCartID = @DrinkCartID)
                SET @SizeID = (SELECT SizeID FROM @CustomerDrinks WHERE DrinkCartID = @DrinkCartID)
                SET @DrinkQuantity = (SELECT Quantity FROM @CustomerDrinks WHERE DrinkCartID = @DrinkCartID)
                -- INSERT INTO DRINK ORDER TABLE FOR THE CURRENT DRINK
                BEGIN TRAN T4_INNER
                INSERT INTO DRINK_ORDER(DrinkID, OrderID, SizeID, Quantity) VALUES (@DrinkID, @OrderID, @SizeID, @DrinkQuantity)
                SET @DrinkOrderID = (SELECT SCOPE_IDENTITY())
                IF (@DrinkOrderID IS NULL)
                BEGIN 
                    PRINT 'Could not find a DrinkOrderID from parameters!';
                    THROW 99999, '@DrinkOrderID returned null value.', 1;
                END
                COMMIT TRAN T4_INNER
                -- CREATE TABLE VARIABLE FOR EACH TOPPING FOR THE CURRENT DRINK
                BEGIN TRAN T4_INNER_2
                DECLARE @DrinkToppings TABLE(PKID INT IDENTITY(1,1) primary key, ToppingCartID int not null, DrinkCartID int not null, 
                    ToppingID int not null, MeasurementID int not null, Quantity DECIMAL(7,2) not null)
                INSERT INTO @DrinkToppings SELECT ToppingCartID, DrinkCartID, ToppingID, MeasurementID, Quantity 
                    FROM TOPPING_CART WHERE DrinkCartID = @DrinkCartID
                COMMIT TRAN T4_INNER_2
                -- LOOP THROUGH EACH TOPPING
                BEGIN TRAN T4_INNER_3
                WHILE (SELECT COUNT(*) FROM @DrinkToppings) > 0
                    BEGIN
                        SET @ToppingCartID = (SELECT TOP 1 ToppingCartID FROM @DrinkToppings)
                        SET @ToppingID = (SELECT ToppingID FROM @DrinkToppings WHERE ToppingCartID = @ToppingCartID)
                        SET @MeasurementID = (SELECT MeasurementID FROM @DrinkToppings WHERE ToppingCartID = @ToppingCartID)
                        SET @ToppingQuantity = (SELECT Quantity FROM @DrinkToppings WHERE ToppingCartID = @ToppingCartID)
                        -- INSERT THE TOPPING INTO DRINK TOPPING ORDER TABLE
                        BEGIN TRAN T4_INNER_3_INNER
                        INSERT INTO DRINK_TOPPING_ORDER(DrinkOrderID, ToppingID, MeasurementID, Quantity) 
                            VALUES (@DrinkOrderID, @ToppingID, @MeasurementID, @ToppingQuantity)
                        DELETE FROM @DrinkToppings WHERE ToppingCartID = @ToppingCartID
                        COMMIT TRAN T4_INNER_3_INNER
                    END
                COMMIT TRAN T4_INNER_3
                -- CLEAN UP THIS CURRENT DRINK AND TOPPINGS FOR THIS CURRENT DRINK
                BEGIN TRAN T4_INNER_3
                DELETE FROM TOPPING_CART WHERE DrinkCartID = @DrinkCartID
                DELETE FROM @CustomerDrinks WHERE DrinkCartID = @DrinkCartID
                COMMIT TRAN T4_INNER_3
            END
        COMMIT TRAN T4
        -- CLEAN UP DRINK_CART FOR THIS CUSTOMER
        BEGIN TRAN T5
        DELETE FROM DRINK_CART WHERE CustomerID = @CustomerID
        COMMIT TRAN T5
    IF @@ERROR <>0 OR @@TRANCOUNT <> 1
        BEGIN 
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO 
