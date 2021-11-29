USE INFO_430_Proj_04
GO

-- Sort ordered drinks into cases based on number of toppings ordered and size
-- 1) Above 2 toppings and size large -- Extravagant
-- 2) Between 1 or 2 toppings and size large or medium -- Average
-- 4) No toppings and a size small or medium -- Frugal
-- 5) Other

CREATE VIEW vwDrinksByToppingCountAndSize
AS
SELECT (CASE
    WHEN ToppingCount >= 3 AND SizeName = 'Large'
        THEN 'Extravagant'
    WHEN ToppingCount BETWEEN 2 AND 3 AND (SizeName = 'Large' or SizeName = 'Medium')
        THEN 'Average'
    WHEN ToppingCount <= 1 AND (SizeName = 'Medium' or SizeName = 'Small')
        THEN 'Frugal'
    ELSE 'Other'
        END) AS LabelForDrinks, COUNT(*) AS NumberOfDrinks
FROM
(SELECT DO.DrinkOrderID, S.SizeName, COUNT(DTO.ToppingID) AS ToppingCount 
    FROM DRINK_ORDER DO 
    JOIN SIZE S ON DO.SizeID = S.SizeID
    LEFT JOIN DRINK_TOPPING_ORDER DTO on DO.DrinkOrderID = DTO.DrinkOrderID
    GROUP BY DO.DrinkOrderID, S.SizeName) AS A
GROUP BY (CASE
    WHEN ToppingCount >= 3 AND SizeName = 'Large'
        THEN 'Extravagant'
    WHEN ToppingCount BETWEEN 2 AND 3 AND (SizeName = 'Large' or SizeName = 'Medium')
        THEN 'Average'
    WHEN ToppingCount <= 1 AND (SizeName = 'Medium' or SizeName = 'Small')
        THEN 'Frugal'
    ELSE 'Other'
        END)
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