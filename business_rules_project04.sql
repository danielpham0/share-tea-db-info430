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
            AND C.DOB > DATEADD(YEAR, -21, GETDATE()))
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