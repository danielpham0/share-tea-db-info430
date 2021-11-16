USE INFO_430_Proj_04

-- Populate Customer
INSERT INTO CUSTOMER (CustomerFname, CustomerLname, CustomerDOB)
    SELECT TOP 20000 CustomerFname, CustomerLname, DateOfBirth
    FROM Peeps.dbo.tblCUSTOMER

-- Populate Drink_Type
INSERT INTO DRINK_TYPE (DrinkTypeName, DrinkTypeDescription) VALUES 
    ('Fruit Tea', 'Fruit tea is an infusion made from cut pieces of fruit and plants, which can either be fresh or dried.'), 
    ('Milk Tea', 'A Taiwanese cold drink made with tea and sweetened milk or other flavorings, and usually with tapioca balls or “pearls”.'), 
    ('Fresh Milk', 'This is a bubble tea variant that has no tea in it, just fresh milk, often with brown sugar syrup and tapioca pearls.'), 
    ('Signature', 'Our specialty alcoholic drinks.'), 
    ('Brewed Tea', 'A hot drink made by infusing the dried crushed leaves of the tea plant in boiling water.'), 
    ('Ice Blended', 'Drinks with traditional flavors that are blended with ice to make a slush.');

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
    ('Transgender'), 
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

-- Didn't finish bc laptop is dying :(
INSERT INTO ALLERGY (AllergyName, AllergyDescription) VALUES
    ('Dairy', 'milk, butter, etc. I get it'), 
    ('Eggs', 'no eggs for you'),
    ('Kiwi', 'kiwi is also a bird'),
    ('Mango', 'they have hairy pits'),
    ('Peach', 'peach butt'),
    ('Strawberry', 'yummy'),
    ('Lime'),
    ('Lemon'),
    ('Orange'),
    ('Grapefruit'),
    ('Taro'),
    ('Lychee')