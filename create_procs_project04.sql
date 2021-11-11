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

-- do we need a cart? -- we want to process all at the same time
-- insertCart --> processCart (takes in person name and deals with their current cart)

-- insertIntoOrder (needs getEmployeeID)

-- insertDrinkOrder (needs getOrderID?, needs getSizeID)


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
