USE INFO_430_Proj_04;

-- Populate Drink_Type
INSERT INTO DRINK_TYPE (DrinkTypeName, DrinkTypeDescription) VALUES 
    ('Fruit Tea', 'Fruit tea is an infusion made from cut pieces of fruit and plants, which can either be fresh or dried.'), 
    ('Milk Tea', 'A Taiwanese cold drink made with tea and sweetened milk or other flavorings, and usually with tapioca balls or “pearls”.'), 
    ('Fresh Milk', 'This is a bubble tea variant that has no tea in it, just fresh milk, often with brown sugar syrup and tapioca pearls.'), 
    ('Signature', 'Our specialty alcoholic drinks.'), 
    ('Brewed Tea', 'A hot drink made by infusing the dried crushed leaves of the tea plant in boiling water.'), 
    ('Ice Blended', 'Drinks with traditional flavors that are blended with ice to make a slush.');

-- Populate Drink
EXEC insertIntoDrink
    @DrinkTypeName = 'Fruit Tea',
    @DrinkName = 'Kiwi Fruit Tea',
    @DrinkCost = 4.50
EXEC insertIntoDrink
    @DrinkTypeName = 'Fruit Tea',
    @DrinkName = 'Passionfruit, Orange, and Grapefruit Tea',
    @DrinkCost = 4.75
EXEC insertIntoDrink
    @DrinkTypeName = 'Fruit Tea',
    @DrinkName = 'Wintermelon Tea',
    @DrinkCost = 5.25

EXEC insertIntoDrink
    @DrinkTypeName = 'Milk Tea',
    @DrinkName = 'Classic Milk Tea',
    @DrinkCost = 5.25
EXEC insertIntoDrink
    @DrinkTypeName = 'Milk Tea',
    @DrinkName = 'Okinawa Milk Tea',
    @DrinkCost = 5.75
EXEC insertIntoDrink
    @DrinkTypeName = 'Milk Tea',
    @DrinkName = 'Hokkaido Milk Tea',
    @DrinkCost = 5.75

EXEC insertIntoDrink
    @DrinkTypeName = 'Fresh Milk',
    @DrinkName = 'Fresh Milk Tea',
    @DrinkCost = 5
EXEC insertIntoDrink
    @DrinkTypeName = 'Fresh Milk',
    @DrinkName = 'Matcha with Fresh Milk',
    @DrinkCost = 5.75
EXEC insertIntoDrink
    @DrinkTypeName = 'Fresh Milk',
    @DrinkName = 'Cocoa Lover',
    @DrinkCost = 6

EXEC insertIntoDrink
    @DrinkTypeName = 'Signature',
    @DrinkName = 'Lime Mojito',
    @DrinkCost = 6.25
EXEC insertIntoDrink
    @DrinkTypeName = 'Signature',
    @DrinkName = 'Mango Mojito',
    @DrinkCost = 6.25
EXEC insertIntoDrink
    @DrinkTypeName = 'Signature',
    @DrinkName = 'Peach Mojito',
    @DrinkCost = 6.25

EXEC insertIntoDrink
    @DrinkTypeName = 'Brewed Tea',
    @DrinkName = 'Classic Black Tea',
    @DrinkCost = 4
EXEC insertIntoDrink
    @DrinkTypeName = 'Brewed Tea',
    @DrinkName = 'Classic Green Tea',
    @DrinkCost = 4.25
EXEC insertIntoDrink
    @DrinkTypeName = 'Brewed Tea',
    @DrinkName = 'Classic Oolong Tea',
    @DrinkCost = 4

EXEC insertIntoDrink
    @DrinkTypeName = 'Ice Blended',
    @DrinkName = 'Taro Ice Blended',
    @DrinkCost = 6
EXEC insertIntoDrink
    @DrinkTypeName = 'Ice Blended',
    @DrinkName = 'Matcha Red Bean Ice Blended',
    @DrinkCost = 6.50
EXEC insertIntoDrink
    @DrinkTypeName = 'Ice Blended',
    @DrinkName = 'Thai Tea Ice Blended',
    @DrinkCost = 6.25

-- Populate Topping_Type
INSERT INTO TOPPING_TYPE (ToppingTypeName, ToppingTypeDescription) VALUES 
    ('Jelly', 'A squishy topping, perfect for any fruit teas'),
    ('Pudding', 'A milky jello-y topping for a fun experience'),
    ('Boba', 'A tapioca ball meant to add a bouncey texture into your drink!'),
    ('Foam', 'An extra layer of fun on the top of your drink!'),
    ('Bean', 'A smart way to get protein into your drinks'),
    ('Drizzle', 'A splash of flavor to brighten up your drink')

INSERT INTO SIZE (SizeName, SizeDescription) VALUES 
    ('Small', '12oz'),
    ('Medium', '16oz'),
    ('Large', '24oz'),
    ('Jumbo', '36oz')

INSERT INTO GENDER (GenderName) VALUES 
    ('Male'), 
    ('Female'), 
    ('Non-binary'), 
    ('Transgender'),
    ('Intersex')

INSERT INTO STORE (StoreName, StoreAddress, StoreOpeningTime, StoreClosingTime) VALUES 
    ('ShareTea-01', '4730 University Way NE Suite #109-110, Seattle, WA 98105', '12PM', '10PM'),
    ('ShareTea-02', '530 Broadway, Seattle, WA 98122', '12PM', '8PM'),
    ('ShareTea-03', '1112 110th Ave NE #107, Bellevue, WA 98004', '12PM', '9PM'),
    ('ShareTea-04', '18931 Bothell Way NE #1, Bothell, WA 98011', '12PM', '8PM'),
    ('ShareTea-05', '4740 42nd Ave SW, Seattle, WA 98116', '12PM', '8PM'),
    ('ShareTea-06', '7425 166th Ave NE c140, Redmond, WA 98052', '12PM', '8PM'),
    ('ShareTea-07', '100 Andover Park W Suite 120, Tukwila, WA 98188', '12PM', '10PM'),
    ('ShareTea-08', '18505 Alderwood Mall Pkwy suite g, Lynnwood, WA 98037', '12PM', '9PM'),
    ('ShareTea-09', '135 4th St, San Francisco, CA 94103', '12PM', '8PM'),
    ('ShareTea-10', '865 Market St, San Francisco, CA 94103', '12PM', '7PM'),
    ('ShareTea-11', '220 Main St, San Mateo, CA 94401', '12PM', '7PM'),
    ('ShareTea-12', '1728 Hostetter Rd STE 30, San Jose, CA 95131', '12PM', '10PM')

INSERT INTO SHIFT_TYPE (ShiftTypeName, ShiftTypeDescription, ShiftTypeBeginTime, ShiftTypeEndTime) VALUES 
    ('Opening','The opening shift where staff will need to get the shop prepped for the day', '10AM', '2PM'),
    ('Midday','The midday shift where staff work through the afternoon rush', '2PM', '7PM'),
    ('Closing','The closing shift to meet the evening rush and clean up the store', '7PM', '11PM'),
    ('FullDay','Overseaing operations during operating hours for the full day', '12PM', '10PM')

INSERT INTO MEASUREMENT (MeasurementName) VALUES 
    ('Ounce'),
    ('Pounds'),
    ('Pints'),
    ('Quarts')

INSERT INTO INGREDIENT (IngredientName) VALUES
    ('Milk'),
    ('Black Tea'),
    ('Green Tea'),
    ('Oolong Tea'),
    ('Matcha'),
    ('Thai Tea'),
    ('Coffee'),
    ('Red Bean'),
    ('Wintermelon'),
    ('Kiwi'),
    ('Mango'),
    ('Peach'),
    ('Strawberry'),
    ('Lime'),
    ('Lemon'),
    ('Orange'),
    ('Grapefruit'),
    ('Passion Fruit'),
    ('Taro'),
    ('Lychee'),
    ('Ginger'),
    ('Honey'),
    ('Mint'),
    ('Cocoa'),
    ('Oreo'),
    ('Sugar'),
    ('Ice')

INSERT INTO ALLERGY (AllergyName, AllergyDescription) VALUES
    ('Dairy', 'milk, cream, butter, etc. I get it'), 
    ('Eggs', 'no eggs for you'),
    ('Kiwi', 'kiwi is also a bird'),
    ('Mango', 'they have hairy pits'),
    ('Peach', 'peach butt'),
    ('Strawberry', 'yummy'),
    ('Lime', 'sour'),
    ('Lemon', 'also sour'),
    ('Orange', 'not as sour'),
    ('Grapefruit', 'sour and bitter'),
    ('Taro', 'purple'),
    ('Lychee', 'cool-looking')

INSERT INTO EMPLOYEE_TYPE (EmployeeTypeName, EmployeeTypeDescription, WagePerHour) VALUES 
    ('Manager', 'The store manager is responsible for leading all team members in the efficient and profitable operation of a ShareTea store.', 20.00),
    ('Kitchen Lead 1', 'The kitchen lead acts as the overseer of food preparation and cooking. They ensure that all staff are working efficiently. They maintain the cleanliness of workstations and monitor all supplies used.', 18.00),
    ('Kitchen Lead 2', 'The kitchen lead acts as the overseer of food preparation and cooking. They ensure that all staff are working efficiently. They maintain the cleanliness of workstations and monitor all supplies used.', 18.00),
    ('Kitchen Lead 3', 'The kitchen lead acts as the overseer of food preparation and cooking. They ensure that all staff are working efficiently. They maintain the cleanliness of workstations and monitor all supplies used.', 18.00),
    ('Barista 1', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00),
    ('Barista 2', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00),
    ('Barista 3', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00),
    ('Barista 4', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00),
    ('Barista 5', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00),
    ('Barista 6', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00)

INSERT INTO TOPPING (ToppingName, ToppingTypeID, ToppingCost) VALUES 
    ('Jelly', 1, .50), ('Boba', 2, 1), ('Mini-Boba', 3, .75), 
    ('Pudding', 4, 1.25), ('Grass-Jelly', 5, .55);

-- Populate Customer (this takes about 8mins)
-- Gets the first 300 people from Peeps database // should swap to a insertIntoCustomer Proc, but need getGenderID
DECLARE @PersonID INT = 300, @CustFname varchar(25), @CustLname varchar(25), @CustDOB DATE,
    @GenderID INT, @GenderCount INT = (SELECT COUNT(*) FROM GENDER)
WHILE @PersonID > 0
BEGIN
    SET @CustFname = (SELECT CustomerFname FROM Peeps.dbo.tblCUSTOMER WHERE CustomerID = @PersonID)
    SET @CustLname = (SELECT CustomerLname FROM Peeps.dbo.tblCUSTOMER WHERE CustomerID = @PersonID)
    SET @CustDOB = (SELECT DateOfBirth FROM Peeps.dbo.tblCUSTOMER WHERE CustomerID = @PersonID)
    SET @GenderID = (SELECT @GenderCount * RAND() + 1)
    INSERT INTO CUSTOMER (GenderID, CustomerFname, CustomerLname, CustomerDOB) VALUES
        (@GenderID, @CustFname, @CustFname, @CustDOB)
    SET @PersonID = @PersonID - 1
END
GO

CREATE PROCEDURE WRAPPER_insertIntoEmployee
AS
DECLARE @EmpType_PK INT
DECLARE @Gender_PK INT
DECLARE @Store_COUNT INT = (SELECT COUNT(*) FROM STORE)
DECLARE @EmpType_COUNT INT = (SELECT COUNT(*) FROM EMPLOYEE_TYPE)
DECLARE @TOTAL_EMPS INT = (SELECT (@EmpType_COUNT * @Store_COUNT))
DECLARE @Gender_COUNT INT = (SELECT COUNT(*) FROM GENDER)
DECLARE @FName varchar(50), @LName varchar(50), @DOB Date, @ETName varchar(50), @GName varchar(50)

WHILE @TOTAL_EMPS > 0
    BEGIN
        SET @EmpType_PK = (SELECT (@TOTAL_EMPS % @EmpType_COUNT) + 1);
        SET @Gender_PK = (SELECT FLOOR(RAND()*(@Gender_COUNT-1+1))+1);
        SET @DOB = DATEADD(DAY, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((25 - 17) * 365))), CONVERT(date, DATEADD(YEAR, 1 - 17, GETDATE())));
        SET @FName = (SELECT CustomerFname FROM Peeps.dbo.tblCUSTOMER WHERE CustomerID = @TOTAL_EMPS);
        SET @LName = (SELECT CustomerLname FROM Peeps.dbo.tblCUSTOMER WHERE CustomerID = @TOTAL_EMPS);
        SET @ETName = (SELECT EmployeeTypeName FROM EMPLOYEE_TYPE WHERE EmployeeTypeID = @EmpType_PK);
        SET @GName = (SELECT GenderName FROM GENDER WHERE GenderID = @Gender_PK);

        EXEC insertIntoEmployee
        @FName = @FName,
        @LName  = @LName,
        @DOB  = @DOB,
        @EmployeeTypeName = @ETName,
        @GenderName = @GName

        SET @TOTAL_EMPS = @TOTAL_EMPS - 1;
    END
GO

EXEC WRAPPER_insertIntoEmployee

GO

-- POPULATE SHIFT_EMPLOYEE

CREATE PROCEDURE WRAPPER_insertIntoShiftEmployee
    @RUN INT
AS

DECLARE @E_PK INT, @S_PK INT, @ST_PK INT, @SH_PK INT
DECLARE @E_COUNT INT, @S_COUNT INT, @ST_COUNT INT, @SH_COUNT INT
DECLARE @E_Fname varchar(50), @E_Lname varchar(50), @E_DOB Date, @S_Name varchar(50), @ST_Name varchar(50), @SH_Date Date

SET @E_COUNT = (SELECT COUNT(*) FROM EMPLOYEE)
SET @SH_COUNT = (SELECT COUNT(*) FROM SHIFT)

WHILE @RUN > 0
BEGIN

SET @E_PK = (SELECT RAND() * @E_COUNT + 1)
SET @E_Fname = (SELECT EmployeeFName FROM EMPLOYEE WHERE EmployeeID = @E_PK)
SET @E_Lname = (SELECT EmployeeLName FROM EMPLOYEE WHERE EmployeeID = @E_PK)
SET @E_DOB = (SELECT EmployeeDOB FROM EMPLOYEE WHERE EmployeeID = @E_PK)

SET @SH_PK = (SELECT RAND() * @SH_COUNT + 1)
SET @SH_Date = (SELECT [DateTime] FROM SHIFT WHERE ShiftID = @SH_PK)
SET @ST_PK = (SELECT ShiftTypeID FROM SHIFT WHERE ShiftID = @SH_PK)
SET @ST_Name = (SELECT ShiftTypeName FROM SHIFT_TYPE WHERE ShiftTypeID = @ST_PK)
SET @S_PK = (SELECT StoreID FROM SHIFT WHERE ShiftID = @SH_PK)
SET @S_Name = (SELECT StoreName FROM STORE WHERE StoreID = @S_PK)

EXEC insertIntoShiftEmployee
    @FName = @E_Fname,
    @LName = @E_Lname,
    @DOB = @E_DOB,
    @StoreName = @S_Name,
    @ShiftTypeName = @ST_Name,
    @Date = @SH_Date

SET @RUN = @RUN - 1
END
GO

-- POPULATE DRINK_INGREDIENT
CREATE PROCEDURE WRAPPER_insertDrinkIngredient
    @RUN INT
AS

DECLARE @D_PK INT, @M_PK INT, @I_PK INT
DECLARE @D_COUNT INT, @M_COUNT INT, @I_COUNT INT
DECLARE @DName varchar(50), @MName varchar(50), @IName varchar(50), @Quantity decimal(7,2)

SET @D_COUNT = (SELECT COUNT(*) FROM DRINK)
SET @M_COUNT = (SELECT COUNT(*) FROM MEASUREMENT)
SET @I_COUNT = (SELECT COUNT(*) FROM INGREDIENT)

WHILE @RUN > 0
BEGIN

SET @D_PK = (SELECT RAND() * @D_COUNT + 1)
SET @DName = (SELECT DrinkName FROM DRINK WHERE DrinkID = @D_PK)

SET @M_PK = (SELECT RAND() * @M_COUNT + 1)
SET @MName = (SELECT MeasurementName FROM MEASUREMENT WHERE MeasurementID = @M_PK)

SET @I_PK = (SELECT RAND() * @I_COUNT + 1)
SET @IName = (SELECT IngredientName FROM INGREDIENT WHERE IngredientID = @I_PK)

SET @Quantity = (SELECT RAND() * (10-0.1+1) +0.1)

EXEC insertDrinkIngredient
    @D_Name = @DName,
    @M_Name = @MName,
    @I_Name = @IName,
    @Qty = @Quantity

SET @RUN = @RUN - 1

END

GO

EXEC WRAPPER_insertDrinkIngredient
    @RUN = 5000
GO

-- POPULATE INGREDIENT_ALLERGY
CREATE PROCEDURE WRAPPER_insertIngredientAllergy
    @RUN INT
AS

DECLARE @I_PK INT, @A_PK INT
DECLARE @I_COUNT INT, @A_COUNT INT
DECLARE @IName varchar(50), @AName varchar(50)

SET @I_COUNT = (SELECT COUNT(*) FROM INGREDIENT)
SET @A_COUNT = (SELECT COUNT(*) FROM ALLERGY)

WHILE @RUN > 0
BEGIN

SET @I_PK = (SELECT RAND() * @I_COUNT + 1)
SET @IName = (SELECT IngredientName FROM INGREDIENT WHERE IngredientID = @I_PK)

SET @A_PK = (SELECT RAND() * @A_COUNT + 1)
SET @AName = (SELECT AllergyName FROM ALLERGY WHERE AllergyID = @A_PK)

EXEC insertIngredientAllergy
    @I_Name = @IName,
    @A_Name = @AName

SET @RUN = @RUN - 1
END
GO

EXEC WRAPPER_insertIngredientAllergy
    @RUN = 5000
GO

-- cartWrapper
--   - RUN: Number of runs and number of times we process a cart
--   - DRINK_RUN: Number of drinks added to a cart per run
--   - TOPPING_RUN: Number of toppings per drink that was added
ALTER PROCEDURE cartWrapper
@RUN INT,
@DRINK_RUN INT,
@TOPPING_RUN INT
AS 
DECLARE @CustomerFname varchar(50), @CustomerLname varchar(50), @CustomerDOB DATE, @CustomerID INT,
    @EmployeeFname varchar(50), @EmployeeLname varchar(50), @EmployeeDOB DATE, @EmployeeID INT,
    @OrderDate DATETIME, @ToppingName varchar(50), @ToppingID INT, @Measurement varchar(50), 
    @MeasurementID INT, @ToppingQuantity DECIMAL(7,2), @DrinkName varchar(50), @DrinkID INT,
    @Size varchar(50), @SizeID INT, @DrinkQuantity INT, @DrinkCartID INT,
    @CustomerCount INT = (SELECT COUNT(*) FROM CUSTOMER),
    @EmployeeCount INT = (SELECT COUNT(*) FROM EMPLOYEE),
    @DrinkCount INT = (SELECT COUNT(*) FROM DRINK),
    @ToppingCount INT = (SELECT COUNT(*) FROM TOPPING),
    @SizeCount INT = (SELECT COUNT(*) FROM SIZE),
    @MeasurementCount INT = (SELECT COUNT(*) FROM MEASUREMENT),
    @T_RUN INT = @TOPPING_RUN,
    @D_RUN INT = @DRINK_RUN
-- EACH LOOP ACTS AS A CUSTOMER TRANSACTION, WHERE THEY ADD DRINKS, TOPPINGS FOR THOSE DRINKS, AND THEN CHECK OUT
WHILE @RUN > 0
BEGIN
    -- OUR CURRENT LOOP'S CUSTOMER
    SET @CustomerID = (SELECT RAND() * @CustomerCount + 1)
    SET @CustomerFname = (SELECT CustomerFname FROM CUSTOMER WHERE CustomerID = @CustomerID)
    SET @CustomerLname = (SELECT CustomerLname FROM CUSTOMER WHERE CustomerID = @CustomerID)
    SET @CustomerDOB = (SELECT CustomerDOB FROM CUSTOMER WHERE CustomerID = @CustomerID)
    -- EACH DRINK LOOP ADDS A DRINK TO THEIR CART
    WHILE @DRINK_RUN > 0
    BEGIN
        SET @DrinkID = (SELECT RAND() * @DrinkCount + 1)
        SET @DrinkName = (SELECT DrinkName FROM DRINK WHERE DrinkID = @DrinkID)
        SET @SizeID = (SELECT RAND() * @SizeCount + 1)
        SET @Size = (SELECT SizeName FROM SIZE WHERE SizeID = @SizeID)
        SET @DrinkQuantity = (SELECT RAND() * 5 + 1)
        EXEC insertIntoDrinkCart
            @CustomerFname = @CustomerFname,
            @CustomerLname = @CustomerLname,
            @CustomerDOB = @CustomerDOB,
            @DrinkName = @DrinkName,
            @Size = @Size,
            @Quantity = @DrinkQuantity
        SET @DrinkCartID = (SELECT MAX(DrinkCartID) FROM DRINK_CART WHERE CustomerID = @CustomerID)
        -- EACH LOOP ADDS A RANDOM TOPPING FOR THE DRINK THAT WAS CREATED
        WHILE @TOPPING_RUN > 0
        BEGIN
            -- SELECT * FROM TOPPING_CART
            SET @ToppingID = (SELECT RAND() * @ToppingCount + 1)
            SET @ToppingName = (SELECT ToppingName FROM TOPPING WHERE ToppingID = @ToppingID)
            SET @MeasurementID = (SELECT RAND() * @MeasurementCount + 1)
            SET @Measurement = (SELECT MeasurementName FROM MEASUREMENT WHERE MeasurementID = @MeasurementID)
            SET @ToppingQuantity = (SELECT RAND() * 5)
            EXEC insertIntoToppingCart
                @DrinkCartID = @DrinkCartID,
                @ToppingName = @ToppingName,
                @Measurement = @Measurement,
                @Quantity = @ToppingQuantity
            SET @TOPPING_RUN = @TOPPING_RUN - 1
        END
        SET @TOPPING_RUN = @T_RUN
        SET @DRINK_RUN = @DRINK_RUN - 1
    END
    SET @EmployeeID = (SELECT RAND() * @EmployeeCount + 1)
    SET @EmployeeFname = (SELECT EmployeeFname FROM EMPLOYEE WHERE EmployeeID = @EmployeeID)
    SET @EmployeeLname = (SELECT EmployeeLname FROM EMPLOYEE WHERE EmployeeID = @EmployeeID)
    SET @EmployeeDOB = (SELECT EmployeeDOB FROM EMPLOYEE WHERE EmployeeID = @EmployeeID)
    -- Gets a date within the past 5 years
    SET @OrderDate = (SELECT DATEADD(Day, -(RAND() * 1825), GETDATE()))
    EXEC processDrinkCart
        @CustomerFname = @CustomerFname,
        @CustomerLname = @CustomerLname,
        @CustomerDOB = @CustomerDOB,
        @EmployeeFname = @EmployeeFname,
        @EmployeeLname = @EmployeeLname,
        @EmployeeDOB = @EmployeeDOB,
        @OrderDate = @OrderDate
    SET @DRINK_RUN = @D_RUN
    SET @RUN = @RUN - 1
END
GO
EXEC cartWrapper
    @RUN = 1000,
    @DRINK_RUN = 3,
    @TOPPING_RUN = 2 

EXEC cartWrapper
    @RUN = 1000,
    @DRINK_RUN = 2,
    @TOPPING_RUN = 3

EXEC cartWrapper
    @RUN = 1000,
    @DRINK_RUN = 2,
    @TOPPING_RUN = 1
EXEC cartWrapper
    @RUN = 1000,
    @DRINK_RUN = 1,
    @TOPPING_RUN = 1
EXEC cartWrapper
    @RUN = 1000,
    @DRINK_RUN = 2,
    @TOPPING_RUN = 4


GO 

-- BULK INSERT INTO SHIFT DATA 
CREATE PROCEDURE bulkInsertShiftData
@Run int 
AS 
DECLARE @StoreCount INT = (SELECT COUNT(*) FROM STORE)
DECLARE @ShiftTypeCount INT = (SELECT COUNT(*) FROM SHIFT_TYPE)
DECLARE @ST_ID INT, @S_ID INT

DECLARE @Store varchar(50)
DECLARE @ShiftType varchar(50)
DECLARE @randomDate Datetime

WHILE @Run > 0
    BEGIN
        SET @S_ID = (SELECT RAND() * @StoreCount + 1)
        SET @Store =  (SELECT StoreName FROM STORE WHERE StoreID = @S_ID)
        SET @ST_ID = (SELECT RAND() * @ShiftTypeCount + 1)
        SET @ShiftType = (SELECT ShiftTypeName FROM SHIFT_TYPE WHERE ShiftTypeID = @ST_ID)
        SET @randomDate = CONVERT(DATE, DATEADD(day, (ABS(CHECKSUM(NEWID())) % 5000 * -1), GETDATE()))

        IF EXISTS (SELECT ShiftID FROM SHIFT WHERE StoreID = @S_ID AND [DateTime] = @randomDate AND ShiftTypeID = @ST_ID) 
            BEGIN
                SET @Run = @Run + 1;
            END 
        ELSE 
            BEGIN 
                EXEC insertShift
                @ShiftTypeName = @ShiftType,
                @StoreName = @Store,
                @Day = @randomDate;
            END

        SET @Run = @Run - 1
    END
GO 

-- Running with 3000 rows of inserts
EXEC bulkInsertShiftData 
@Run = 5000
GO 

EXEC WRAPPER_insertIntoShiftEmployee
    @RUN = 5000
GO