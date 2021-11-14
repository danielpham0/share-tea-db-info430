-- Total order cost is a computed column (DANIEL) -- needs total drink cost to work properly
CREATE FUNCTION fn_TotalOrderCost (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT COALESCE(SUM(DO.TotalDrinkCost * DO.Quantity), 0.00)
                        FROM DRINK_ORDER DO
                        WHERE DO.OrderID = @PK)
RETURN @RET
END
GO
ALTER TABLE [Order]
ADD TotalOrderCost AS (dbo.fn_TotalOrderCost (OrderID))
GO
-- Total drink cost is a computed column (DANIEL) -- needs drink cost + topping cost 
-- question of where to put costs: size differences could make a difference as well
CREATE FUNCTION fn_TotalDrinkCost (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT COALESCE((D.DrinkCost + SUM(T.ToppingCost)), D.DrinkCost, SUM(T.ToppingCost), 0.00)
                        FROM DRINK_ORDER DO
                        JOIN DRINK D ON D.DrinkID = DO.DrinkID
                        JOIN DRINK_TOPPING_ORDER DTO ON DO.DrinkOrderID = DTO.DrinkOrderID
                        JOIN TOPPING T ON T.ToppingID = DTO.ToppingID
                        WHERE DO.DrinkOrderID = @PK)
RETURN @RET
END
GO
ALTER TABLE DRINK_ORDER
ADD TotalDrinkCost AS (dbo.fn_TotalDrinkCost (DrinkOrderID))
GO