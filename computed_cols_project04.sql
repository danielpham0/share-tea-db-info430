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

-- Total employees working in a shift
CREATE FUNCTION fn_TotalEmpShift (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT (COUNT(SE.EmployeeID)) 
                        FROM SHIFT S 
                        JOIN SHIFT_EMPLOYEE SE ON SE.ShiftID = S.ShiftID
                        WHERE SE.ShiftID = @PK
                        GROUP BY SE.ShiftID)
RETURN @RET
END
GO
ALTER TABLE [SHIFT]
ADD TotalEmpShift AS (dbo.fn_TotalEmpShift (ShiftID))
GO

-- Total number of drinks ordered by a customer
CREATE FUNCTION fn_TotalDrinksCustomer (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT (COUNT(DO.DrinkOrderID)) 
                        FROM CUSTOMER C 
                        JOIN [ORDER] O ON O.CustomerID = C.CustomerID
                        JOIN DRINK_ORDER DO ON DO.OrderID = O.OrderID
                        WHERE O.CustomerID = @PK
                        GROUP BY O.CustomerID)
RETURN @RET
END
GO
ALTER TABLE [CUSTOMER]
ADD TotalDrinksCustomer AS (dbo.fn_TotalDrinksCustomer (CustomerID))
GO

-- Total hours worked by an employee
CREATE FUNCTION fn_TotalHoursEmployee (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT (SUM(DATEDIFF(HOUR, ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime)))
                    FROM EMPLOYEE E
                    JOIN SHIFT_EMPLOYEE SE ON E.EmployeeID = SE.EmployeeID
                    JOIN SHIFT SH ON SE.ShiftID = SH.ShiftID
                    JOIN SHIFT_TYPE ST ON SH.ShiftTypeID = ST.ShiftTypeID
                    WHERE E.EmployeeID = @PK
                    GROUP BY E.EmployeeID)
RETURN @RET
END
GO
ALTER TABLE EMPLOYEE
ADD TotalHoursWorked AS (dbo.fn_TotalHoursEmployee (EmployeeID))
GO

-- Total ingredients in each drink
CREATE FUNCTION fn_TotalIngredientsDrink (@PK INT)
RETURNS INT
AS 
BEGIN
DECLARE @RET INT = (SELECT (COUNT(DI.IngredientID))
                    FROM DRINK_INGREDIENT DI
                    WHERE DI.DrinkID = @PK
                    GROUP BY DI.DrinkID)
RETURN @RET
END
GO
ALTER TABLE DRINK
ADD TotalIngredients AS (dbo.fn_TotalIngredientsDrink (DrinkID))
GO