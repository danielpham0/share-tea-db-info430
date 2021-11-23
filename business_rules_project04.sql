USE INFO_430_Proj_04;

-- If the customer is below 21, do not allow them to order a specialty drink, as they are alcoholic. (DANIEL)
-- Cannot add to the person's drink order if so.
CREATE FUNCTION dbo.fn_checkAgeForAlchol()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM CUSTOMER C
                JOIN [ORDER] O on C.CustomerID = O.CustomerID
                JOIN DRINK_ORDER DO on DO.OrderID = O.DrinkOrderID
                JOIN DRINK D on DO.DrinkID = D.DrinkID
                JOIN DRINK_TYPE DT on D.DrinkTypeID = DT.DrinkTypeID
            WHERE DT.DrinkTypeName = 'Signature'
            AND C.CustomerDOB > DATEADD(YEAR, -21, GETDATE()))
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE DrinkOrder with nocheck
ADD CONSTRAINT CK_AgeForAlcohol
CHECK(dbo.fn_checkAgeForAlchol() = 0)
GO

-- If the customer has a listed allergy, do not allow them to order a drink with that allergy. (DANIEL)
-- needs to be tested 100%
CREATE FUNCTION dbo.fn_checkAllergy()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM DRINK_ORDER DO
                JOIN DRINK D on DO.DrinkID = D.DrinkID
                JOIN DRINK_INGREDIENT DI on D.DrinkID = DI.DrinkID
                JOIN INGREDIENT I on DI.IngredientID = I.IngredientID
                JOIN INGREDIENT_ALLERGY IA on I.IngredientID = IA.IngredientIA
                -- Gets allergies from ingredients
                JOIN ALLERGY AllergyFromIngredient on IA.AllergyID = AllergyFromIngredient.AllergyID
                JOIN [ORDER] O on DO.OrderID = O.DrinkOrderID
                JOIN CUSTOMER C on O.CustomerID = C.CustomerID
                JOIN CUSTOMER_ALLERGY CA on C.CustomerID = CA.CustomerID
                -- Gets allergies from customer
                JOIN ALLERGY AllergyFromCustomer on CA.AllergyID = AllergyFromCustomer.AllergyID
            -- Check if there is an instance where the two are the same
            WHERE AllergyFromIngredient.AllergyName = AllergyFromCustomer.AllergyName)
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE DrinkOrder with nocheck
ADD CONSTRAINT CK_AgeForAlcohol
CHECK(dbo.fn_checkAgeForAlchol() = 0)
GO 

-- Employee must be older than 16 to work
CREATE FUNCTION dbo.fn_checkEmployeeMinimumAge()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM Employee E 
            -- Check if employee birthday is more than 16 years before today's date. 
            WHERE E.EmployeeDOB <= DATEADD(YEAR, -16, GETDATE())) 
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE Employee
ADD CONSTRAINT CK_EmployeeMinimumAge
CHECK(dbo.fn_checkEmployeeMinimumAge() = 0)
GO

-- EmployeeTypeWagePerHour cannot be lower than $15/hour  
CREATE FUNCTION dbo.fn_checkEmployeeMinimumWage()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM EMPLOYEE_TYPE ET
            -- Check if employee wage is at least 15 dollars an hour. 
            WHERE ET.WagePerHour >= 15) 
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE EMPLOYEE_TYPE
ADD CONSTRAINT CK_EmployeeMinimumWage
CHECK(dbo.fn_checkEmployeeMinimumWage() = 0)
GO

-- A small drink cannot have any more than 3 toppings
CREATE FUNCTION dbo.fn_checkNumToppingsSmall()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT DO.DrinkOrderID, COUNT(DrinkToppingOrderID)
            FROM DRINK_ORDER DO 
            JOIN DRINK_ORDER_TOPPING DOT ON DOT.DrinkOrderID = DO.DrinkOrderID
            GROUP BY DrinkOrderID
            HAVING COUNT(DrinkToppingOrderID) > 3)
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE DRINK_ORDER_TOPPING
ADD CONSTRAINT CK_NumToppingsSmall
CHECK(dbo.fn_checkNumToppingsSmall() = 0)
GO

-- OrderDate cannot be more than GETDATE()
CREATE FUNCTION dbo.fn_checkOrderDate()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM [ORDER]
            WHERE OrderDate > GETDATE())
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE [ORDER]
ADD CONSTRAINT CK_OrderDate
CHECK(dbo.fn_checkOrderDate() = 0)