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