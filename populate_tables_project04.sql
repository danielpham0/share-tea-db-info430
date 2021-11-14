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