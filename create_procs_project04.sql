DROP PROCEDURE IF EXISTS getDrinkTypeID
GO
-- getDrinkTypeID
CREATE PROCEDURE getDrinkTypeID
    @DTypeName varchar(50),
    @DTypeID int OUTPUT
AS
SET @DTypeID = (SELECT DrinkTypeID FROM DrinkType WHERE DrinkTypeName = @DTypeName)
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
    @CID int OUTPUT
AS
SET @CID = (SELECT CustomerID FROM Customer WHERE CustomerFname = @CFname and CustomerLname = @CLname)
GO

-- insertIntoDrink
CREATE PROCEDURE insertIntoDrink
    @DrinkTypeName varchar(25),
    @DrinkName varchar(25)
    AS
    DECLARE @DrinkTypeID INT
    EXEC getDrinkTypeID
        @DTypeName = @DrinkTypeName,
        @DTypeID = @DrinkTypeID OUTPUT
    IF (@DrinkTypeID IS NULL)
    BEGIN 
        PRINT '@DrinkTypeID cannot be NULL!';
        THROW 99999, '@DrinkTypeID did not return a proper value', 1;
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
--     @EmpFname varchar(25),
--     @EmpLname varchar(25),
--     @OrdTotal money
--     AS
--     DECLARE @CustID INT, @EmpID INT, @OrdDate DATE = GETDATE()
--     EXEC getCustomerID
--         @CFname = @CustFname,
--         @CLname = @CustLname,
--         @CID = @CustID OUTPUT
--     IF (@CustID IS NULL)
--     BEGIN 
--         PRINT '@CustID cannot be NULL!';
--         THROW 99999, '@CustID did not return a proper value', 1;
--     END
--     EXEC getEmployeeID
--         @EFname = @EmpFname,
--         @ELname = @EmpLname,
--         @EID = @EmpID OUTPUT
--     IF (@EmpID IS NULL)
--     BEGIN 
--         PRINT '@EmpID cannot be NULL!';
--         THROW 99999, '@EmpID did not return a proper value', 1;
--     END
--     BEGIN TRAN T1
--     INSERT INTO [ORDER] (CustomerID, EmployeeID, OrderDate, OrderTotal)
--         VALUES (@CustID, @EmpID, @OrdDate, @OrdTotal)
--     IF @@ERROR <> 0
--         BEGIN
--             PRINT 'Terminating...'
--             ROLLBACK TRAN T1
--         END
--     ELSE
--         COMMIT TRAN T1
-- GO

-- insertIntoDrinkOrder (needs getSizeID)
-- CREATE PROCEDURE insertIntoDrinkOrder
--     @DrinkName varchar(50),
--     @OrderID INT,
--     @Size varchar(25),
--     @Quantity INT
--     AS
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
