USE INFO_430_Proj_04
GO

-- For each store, what drinks are the most popular?

CREATE VIEW vwPopularDrinksByStore
AS
SELECT DO.DrinkID, D.DrinkName, S.StoreName, COUNT(DO.OrderID) AS NumOrders,
DENSE_RANK() OVER (PARTITION BY S.StoreName ORDER BY COUNT(DO.OrderID) DESC) AS DenseRankDrinkPopularity
FROM STORE S
    JOIN SHIFT SH ON S.StoreID = SH.StoreID
    JOIN SHIFT_EMPLOYEE SE ON SH.ShiftID = SE.ShiftID
    JOIN EMPLOYEE E ON SE.EmployeeID = E.EmployeeID
    JOIN [ORDER] O ON E.EmployeeID = O.EmployeeID
    JOIN DRINK_ORDER DO ON O.OrderID = DO.OrderID
    JOIN DRINK D ON DO.DrinkID = D.DrinkID
GROUP BY DO.DrinkID, D.DrinkName, S.StoreName
GO

-- For each store, what toppings are the most popular?

CREATE VIEW vwPopularToppingsByStore
AS
SELECT DTO.ToppingID, T.ToppingName, S.StoreName, COUNT(DTO.DrinkOrderID) AS NumDrinkOrders,
DENSE_RANK() OVER (PARTITION BY S.StoreName ORDER BY COUNT(DTO.DrinkOrderID) DESC) AS DenseRankToppingPopularity
FROM STORE S
    JOIN SHIFT SH ON S.StoreID = SH.StoreID
    JOIN SHIFT_EMPLOYEE SE ON SH.ShiftID = SE.ShiftID
    JOIN EMPLOYEE E ON SE.EmployeeID = E.EmployeeID
    JOIN [ORDER] O ON E.EmployeeID = O.EmployeeID
    JOIN DRINK_ORDER DO ON O.OrderID = DO.OrderID
    JOIN DRINK_TOPPING_ORDER DTO ON DO.DrinkOrderID = DTO.DrinkOrderID
    JOIN TOPPING T ON DTO.ToppingID = T.ToppingID
GROUP BY DTO.ToppingID, T.ToppingName, S.StoreName
GO