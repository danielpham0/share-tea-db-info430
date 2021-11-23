USE INFO_430_Proj_04

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
    @DrinkName = 'Kiwi Fruit Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Fruit Tea',
    @DrinkName = 'Passionfruit, Orange, and Grapefruit Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Fruit Tea',
    @DrinkName = 'Wintermelon Tea'

EXEC insertIntoDrink
    @DrinkTypeName = 'Milk Tea',
    @DrinkName = 'Classic Milk Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Milk Tea',
    @DrinkName = 'Okinawa Milk Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Milk Tea',
    @DrinkName = 'Hokkaido Milk Tea'

EXEC insertIntoDrink
    @DrinkTypeName = 'Fresh Milk',
    @DrinkName = 'Fresh Milk Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Fresh Milk',
    @DrinkName = 'Matcha with Fresh Milk'
EXEC insertIntoDrink
    @DrinkTypeName = 'Fresh Milk',
    @DrinkName = 'Cocoa Lover'

EXEC insertIntoDrink
    @DrinkTypeName = 'Signature',
    @DrinkName = 'Lime Mojito'
EXEC insertIntoDrink
    @DrinkTypeName = 'Signature',
    @DrinkName = 'Mango Mojito'
EXEC insertIntoDrink
    @DrinkTypeName = 'Signature',
    @DrinkName = 'Peach Mojito'

EXEC insertIntoDrink
    @DrinkTypeName = 'Brewed Tea',
    @DrinkName = 'Classic Black Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Brewed Tea',
    @DrinkName = 'Classic Green Tea'
EXEC insertIntoDrink
    @DrinkTypeName = 'Brewed Tea',
    @DrinkName = 'Classic Oolong Tea'

EXEC insertIntoDrink
    @DrinkTypeName = 'Ice Blended',
    @DrinkName = 'Taro Ice Blended'
EXEC insertIntoDrink
    @DrinkTypeName = 'Ice Blended',
    @DrinkName = 'Matcha Red Bean Ice Blended'
EXEC insertIntoDrink
    @DrinkTypeName = 'Ice Blended',
    @DrinkName = 'Thai Tea Ice Blended'

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
    ('Kitchen Lead', 'The kitchen lead acts as the overseer of food preparation and cooking. They ensure that all staff are working efficiently. They maintain the cleanliness of workstations and monitor all supplies used.', 18.00),
    ('Barista', 'Preparing and serving hot and cold drinks such as coffee, tea, artisan and speciality beverages. Cleaning and sanitising work areas, utensils and equipment. Cleaning service and seating areas.', 15.00)

-- Populate Customer (this takes about 8mins)
-- Gets the first 2000 people from Peeps database // should swap to a insertIntoCustomer Proc, but need getGenderID
DECLARE @PersonID INT = 2000, @CustFname varchar(25), @CustLname varchar(25), @CustDOB DATE,
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