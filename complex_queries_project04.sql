USE INFO_430_Proj_04;

-- Get the top 1 to 20 percentile of customers for customers, 
-- above the age of 18, based on the total number of orders they have made. (DANIEL)
WITH 
RankedCustomerOrders(CustomerID, Fname, Lname, OrderCount, OrderPercentile)
AS (SELECT C.CustomerID, C.CustomerFname, C.CustomerLname,
    COUNT(*) as OrderCount,
    NTILE(100) OVER (ORDER BY COUNT(*) DESC) as OrderPercentile
FROM CUSTOMER C
    JOIN [ORDER] O on C.CustomerID = O.CustomerID
    WHERE C.CustomerDOB < DATEADD(YEAR, -18, GETDATE())
GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname)
SELECT * FROM RankedCustomerOrders WHERE OrderPercentile BETWEEN 1 AND 20 ORDER BY OrderPercentile

-- Sort ordered drinks into cases based on number of toppings ordered and size
-- 1) Above 2 toppings and size large -- Extravagant
-- 2) Between 1 or 2 toppings and size large or medium -- Average
-- 4) No toppings and a size small or medium -- Frugal
-- 5) Other

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

-- How long is the average employee working at each store each week and what is the average pay per week? 
WITH 
CTE_EmployeeShiftHours (shiftHours, EmployeeID) AS (
    SELECT DATEDIFF(HOUR,  ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime) AS shiftHour, E.EmployeeID
    FROM Employee E 
        JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = E.EmployeeID
        JOIN SHIFT S ON S.ShiftID = SE.ShiftID
        JOIN SHIFT_TYPE ST ON ST.ShiftTypeID = S.ShiftTypeID
    GROUP BY E.EmployeeID, ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime),
CTE_EmployeeTotalHours (totalHours, EmployeeID) AS (
    SELECT SUM(shiftHours) AS totalHours, EmployeeID
    FROM CTE_EmployeeShiftHours 
    GROUP BY EmployeeID 
),
CTE_EmployeeTotalPayAndHours (totalPay, totalHours, EmployeeID) AS (
    SELECT (ETH.totalHours * ET.WagePerHour) AS totalPay, ETH.totalHours, E.EmployeeID
    FROM EMPLOYEE E 
        JOIN EMPLOYEE_TYPE ET ON ET.EmployeeTypeID = E.EmployeeTypeID
        JOIN CTE_EmployeeTotalHours ETH ON ETH.EmployeeID = E.EmployeeID 
    GROUP BY E.EmployeeID, ETH.totalHours, ET.WagePerHour
)
SELECT S.StoreID, ST.StoreName, AVG(ET.totalHours) AS AverageHours, AVG(ET.totalPay) AS AveragePay
FROM CTE_EmployeeTotalPayAndHours ET 
    JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = ET.EmployeeID
    JOIN SHIFT S ON S.ShiftID = SE.ShiftID
    JOIN STORE ST ON ST.StoreID = S.StoreID
GROUP BY S.StoreID, ST.StoreName 
ORDER BY S.StoreID

-- For each employee in the barista employee type, what is the total amount of orders divided by the total hours worked, what is their average orders per hour. 

SELECT E.EmployeeID, E.EmployeeFName, E.EmployeeLName, ET.EmployeeTypeName, (COUNT(O.OrderID) / SUM(DATEDIFF(HOUR, ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime))) AS [Avg. Order Per Hour],
    RANK() OVER(PARTITION BY E.EmployeeID ORDER BY (COUNT(O.OrderID) / SUM(DATEDIFF(HOUR, ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime))) DESC) EmpAvgOrderPHour_Rank
FROM EMPLOYEE E 
JOIN EMPLOYEE_TYPE ET ON ET.EmployeeTypeID = E.EmployeeTypeID
JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = E.EmployeeID
JOIN SHIFT S ON S.ShiftID = SE.ShiftID
JOIN SHIFT_TYPE ST ON ST.ShiftTypeID = S.ShiftTypeID
JOIN [ORDER] O ON O.EmployeeID = E.EmployeeID
WHERE ET.EmployeeTypeName = 'Barista'
GROUP BY E.EmployeeID, E.EmployeeFName, E.EmployeeLName, ET.EmployeeTypeName
ORDER BY EmpAvgOrderPHour_Rank ASC
GO

-- For each store, what drinks are the most popular?
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

-- What are the top 3 drink and boba combinations for each month across all shareTea locations 
SELECT MONTH(O.OrderDate) AS [Month],  D.DrinkName, T.ToppingName, COUNT(DTO.DrinkToppingOrderID) AS countDrinks,
RANK() OVER (ORDER BY COUNT(DTO.DrinkToppingOrderID) DESC) AS DenseRankDrinkPopularity
INTO #TempDrinkPopularityMonth
FROM DRINK_TOPPING_ORDER DTO 
    JOIN DRINK_ORDER DO ON DO.DrinkOrderID = DTO.DrinkOrderID
    JOIN [ORDER] O ON  O.OrderID = DO.OrderID 
    JOIN TOPPING T ON T.ToppingID = DTO.ToppingID 
    JOIN DRINK D ON D.DrinkID = DO.DrinkID 
GROUP BY DTO.DrinkToppingOrderID, D.DrinkName, T.ToppingName, MONTH(O.OrderDate)
SELECT * 
FROM #TempDrinkPopularityMonth
WHERE DenseRankDrinkPopularity < 4
ORDER BY [Month]

-- In each season, what times of the day are the busiest in terms of the number of customer orders for each store?  (for increased staffing? ) (JONATHAN)
SELECT StoreName, (CASE
    WHEN MONTH(OrderDate) <= 2 OR MONTH(OrderDate) = 12
        THEN 'Winter'
    WHEN MONTH(OrderDate) <= 5 AND MONTH(OrderDate) >= 3
        THEN 'Spring'
    WHEN MONTH(OrderDate) <= 8 AND MONTH(OrderDate) >= 6
        THEN 'Summer'
    ELSE 'Fall'
        END) AS Season, DATEPART(HOUR, OrderDate) AS TimeOfDay, COUNT(*) AS NumberOfOrders
FROM [ORDER] O
JOIN EMPLOYEE E ON E.EmployeeID = O.EmployeeID
JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = E.EmployeeID
JOIN SHIFT S ON S.ShiftID = SE.ShiftID
JOIN STORE ST ON ST.StoreID = S.StoreID
GROUP BY StoreName, (CASE
    WHEN MONTH(OrderDate) <= 2 OR MONTH(OrderDate) = 12
        THEN 'Winter'
    WHEN MONTH(OrderDate) <= 5 AND MONTH(OrderDate) >= 3
        THEN 'Spring'
    WHEN MONTH(OrderDate) <= 8 AND MONTH(OrderDate) >= 6
        THEN 'Summer'
    ELSE 'Fall'
        END), TimeOfDay
ORDER BY NumberOfOrders DESC
GO
