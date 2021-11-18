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

-- insertIntoDrink
CREATE PROCEDURE insertIntoDrink
    @DrinkTypeName varchar(25),
    @DrinkName varchar(25)
    AS
    DECLARE @DrinkTypeID INT
    IF @DrinkTypeName IS NULL OR @DrinkName IS NULL
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
    INSERT INTO DRINK (DrinkTypeID, DrinkName)
        VALUES (@DrinkTypeID, @DrinkName)
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Terminating...'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- do we need a cart? -- we want to process all at the same time
-- for all toppings in drink_topping_order, we need the drink_order id
-- for all drinks in drink_order we need an order id
-- to handle that all at the same time, we need a cart for each drink before the drink is committed to drink_order
-- and we need a cart for each person's drink_order before it's fully committed to order
-- NOTE: the following will be inserts that assume we have an id - this will make our job easier if we do implement cart

-- insertIntoOrder (needs getEmployeeID and to deal with OrderTotal through computed column)
-- CREATE PROCEDURE insertIntoOrder
--     @CustFname varchar(25),
--     @CustLname varchar(25),
--     @CustDOB date,
--     @EmpFname varchar(25),
--     @EmpLname varchar(25),
--     @EmpDOB date,
--     @OrdDate DATE
--     AS
--     IF @CustFname IS NULL OR @CustLname IS NULL OR @CustDOB IS NULL OR @EmpFname IS NULL OR @EmpLname IS NULL OR
--         @EmpDOB IS NULL OR @OrdDate IS NULL
--     BEGIN 
--         PRINT 'Parameters for insert order cannot be null.';
--         THROW 99999, 'Parameters for insertion were null', 1;
--     END
--     DECLARE @CustID INT, @EmpID INT
--     EXEC getCustomerID
--         @CFname = @CustFname,
--         @CLname = @CustLname,
--         @CDOB = @CustDOB,
--         @CID = @CustID OUTPUT
--     IF (@CustID IS NULL)
--     BEGIN 
--         PRINT '@CustID cannot be NULL!';
--         THROW 99999, '@CustID did not return a proper value', 1;
--     END
--     EXEC getEmployeeID
--         @EFname = @EmpFname,
--         @ELname = @EmpLname,
--         @EDOB = @EmpDOB,
--         @EID = @EmpID OUTPUT
--     IF (@EmpID IS NULL)
--     BEGIN 
--         PRINT '@EmpID cannot be NULL!';
--         THROW 99999, '@EmpID did not return a proper value', 1;
--     END
--     BEGIN TRAN T1
--     INSERT INTO [ORDER] (CustomerID, EmployeeID, OrderDate)
--         VALUES (@CustID, @EmpID, @OrdDate)
--     IF @@ERROR <> 0
--         BEGIN
--             PRINT 'Terminating...'
--             ROLLBACK TRAN T1
--         END
--     ELSE
--         COMMIT TRAN T1
-- GO
-- Synthetic transaction procedure for insertIntoOrderWrapper (needs insertIntoOrder to work)
-- CREATE PROCEDURE insertIntoOrderWrapper
-- @RUN INT
-- AS
-- DECLARE @CustID INT, @CustFname varchar(25), @CustLname varchar(25), 
--     @EmpID INT, @EmpFname varchar(25), @EmpLname varchar(25), @OrdDate DATE, 
--     @CustomerCount INT = (SELECT COUNT(*) FROM CUSTOMER), 
--     @EmployeeCount INT = (SELECT COUNT(*) FROM EMPLOYEE)
-- WHILE @Run > 0
-- BEGIN
--     SET @CustID = (SELECT RAND() * @CustomerCount + 1)
--     SET @CustFname = (SELECT CustomerFname FROM CUSTOMER WHERE CustomerID = @CustID)
--     SET @CustLname = (SELECT CustomerLname FROM CUSTOMER WHERE CustomerID = @CustID)
--     SET @CustDOB = (SELECT CustomerDOB FROM CUSTOMER WHERE CustomerID = @CustID)
--     SET @EmpID = (SELECT RAND() * @EmployeeCount + 1)
--     SET @EmpFname = (SELECT EmployeeFname FROM EMPLOYEE WHERE EmployeeID = @EmpID)
--     SET @EmpLname = (SELECT EmployeeLname FROM EMPLOYEE WHERE EmployeeID = @EmpID)
--     SET @EmpDOB = (SELECT CustomerDOB FROM CUSTOMER WHERE CustomerID = @CustID)
--     -- Gets a date within the past 5 years
--     SET @OrdDate = (SELECT DATEADD(Day, -(RAND() * 1825), GETDATE()))
--     EXEC insertIntoOrder
--         @CustFname = @CustFname,
--         @CustLname = @CustLname,
--         @CustDOB = @CustDOB,
--         @EmpFname = @EmpFname,
--         @EmpLname = @EmpLname,
--         @EmpDOB = @EmpDOB,
--         @OrdDate = @OrdDate
--     SET @RUN = @RUN - 1
-- END
-- GO
-- insertIntoDrinkOrder (needs getSizeID)
-- CREATE PROCEDURE insertIntoDrinkOrder
--     @DrinkName varchar(50),
--     @OrderID INT,
--     @Size varchar(25),
--     @Quantity INT
--     AS
--     IF @DrinkName IS NULL OR @OrderID IS NULL OR @Size IS NULL OR @Quantity IS NULL
--     BEGIN 
--         PRINT 'Parameters for insert order cannot be null.';
--         THROW 99999, 'Parameters for insertion were null', 1;
--     END
--     DECLARE @DrinkID INT, @SizeID INT
--     EXEC getDrinkID
--         @DName = @DrinkName,
--         @DID = @DrinkID OUTPUT
--     IF (@DrinkID IS NULL)
--     BEGIN 
--         PRINT '@DrinkID cannot be NULL!';
--         THROW 99999, '@DrinkID did not return a proper value', 1;
--     END
--     EXEC getSizeID
--         @SName = @Size,
--         @SID = @SizeID OUTPUT
--     IF (@SizeID IS NULL)
--     BEGIN 
--         PRINT '@SizeID cannot be NULL!';
--         THROW 99999, '@SizeID did not return a proper value', 1;
--     END
--     BEGIN TRAN T1
--     INSERT INTO [DRINK_ORDER] (DrinkID, OrderID, SizeID, Quantity)
--         VALUES (@DrinkID, @OrderID, @SizeID, @Quantity)
--     IF @@ERROR <> 0
--         BEGIN
--             PRINT 'Terminating...'
--             ROLLBACK TRAN T1
--         END
--     ELSE
--         COMMIT TRAN T1
-- GO

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

    IF ERROR <> 0
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

    IF ERROR <> 0
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
    @ToppingTypeName varchar(100), 
    @TID int OUTPUT
AS
DECLARE @TTID int 

EXEC getToppingTypeID
@ToppingTypeName = @ToppingTypeName,
@TID = @TTID OUTPUT 
IF @TTID IS NULL 
    BEGIN
        PRINT 'topping type does not exist';
        THROW 55555, 'topping type id is null', 11;
    END 

SET @TID = (SELECT ToppingID FROM TOPPING WHERE ToppingName = @ToppingName AND ToppingTypeID = @TTID)
GO

-- INSERT TOPPING (Lauren)
CREATE PROCEDURE insertToppingID
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
            THROW 55555, 'failed to insert values', 11; 
        END 
    ELSE 
        COMMIT T1 

-- Insert Shift (Lauren)
