-- If the customer is below 21, do not allow them to order a specialty drink, as they are alcoholic. (DANIEL)
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