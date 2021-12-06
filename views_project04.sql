USE INFO_430_Proj_04
GO

-- Get the top 1 to 20 percentile of customers for customers, 
-- above the age of 18, based on the total number of orders they have made.
CREATE VIEW vwDrinksByRankCustomerOrders
AS
WITH 
RankedCustomerOrders(CustomerID, Fname, Lname, OrderCount, OrderPercentile)
AS (SELECT C.CustomerID, C.CustomerFname, C.CustomerLname,
    COUNT(*) as OrderCount,
    NTILE(100) OVER (ORDER BY COUNT(*) DESC) as OrderPercentile
FROM CUSTOMER C
    JOIN [ORDER] O on C.CustomerID = O.CustomerID
    WHERE C.CustomerDOB < DATEADD(YEAR, -18, GETDATE())
GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname)
SELECT * FROM RankedCustomerOrders WHERE OrderPercentile BETWEEN 1 AND 20
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

-- What months are the busiest in terms of the number of customer orders?

CREATE VIEW vwNumOrdersByMonth
AS
SELECT StoreName, (CASE
    WHEN MONTH(OrderDate) = 1
        THEN 'January'
    WHEN MONTH(OrderDate) = 2
        THEN 'February'
    WHEN MONTH(OrderDate) = 3
        THEN 'March'
    WHEN MONTH(OrderDate) = 4
        THEN 'April'
    WHEN MONTH(OrderDate) = 5
        THEN 'May'
    WHEN MONTH(OrderDate) = 6
        THEN 'June'
    WHEN MONTH(OrderDate) = 7
        THEN 'July'
    WHEN MONTH(OrderDate) = 8
        THEN 'August'
    WHEN MONTH(OrderDate) = 9
        THEN 'September'
    WHEN MONTH(OrderDate) = 10
        THEN 'October'
    WHEN MONTH(OrderDate) = 11
        THEN 'November'
    ELSE 'December'
        END) AS Month, COUNT(*) AS NumberOfOrders
FROM [ORDER] O
JOIN EMPLOYEE E ON E.EmployeeID = O.EmployeeID
JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = E.EmployeeID
JOIN SHIFT S ON S.ShiftID = SE.ShiftID
JOIN STORE ST ON ST.StoreID = S.StoreID
GROUP BY StoreName, (CASE
    WHEN MONTH(OrderDate) = 1
        THEN 'January'
    WHEN MONTH(OrderDate) = 2
        THEN 'February'
    WHEN MONTH(OrderDate) = 3
        THEN 'March'
    WHEN MONTH(OrderDate) = 4
        THEN 'April'
    WHEN MONTH(OrderDate) = 5
        THEN 'May'
    WHEN MONTH(OrderDate) = 6
        THEN 'June'
    WHEN MONTH(OrderDate) = 7
        THEN 'July'
    WHEN MONTH(OrderDate) = 8
        THEN 'August'
    WHEN MONTH(OrderDate) = 9
        THEN 'September'
    WHEN MONTH(OrderDate) = 10
        THEN 'October'
    WHEN MONTH(OrderDate) = 11
        THEN 'November'
    ELSE 'December'
        END)
GO