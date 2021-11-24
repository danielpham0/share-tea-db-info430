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
    WHERE C.CustomerDOB > DATEADD(YEAR, -18, GETDATE())
GROUP BY S.StudentID, S.StudentFname, S.StudentLname)
SELECT * FROM RankedCustomerOrders WHERE OrderPercentile BETWEEN 1 AND 20 ORDER BY OrderPercentile

-- Sort ordered drinks into cases based on number of toppings ordered and size
-- 1) Above 2 toppings and size large -- Extravagant
-- 2) Between 1 or 2 toppings and size large or medium -- Average
-- 4) No toppings and a size small or medium -- Frugal
-- 5) Other
SELECT (CASE
    WHEN ToppingCount > 2 AND SizeName = 'Large'
        THEN 'Extravagant'
    WHEN ToppingCount BETWEEN 1 AND 2 AND (Size = 'Large' or Size = 'Medium')
        THEN 'Average'
    WHEN ToppingCount < 1 AND (SizeName = 'Medium' or SizeName = 'Small')
        THEN 'Frugal'
    ELSE 'Other'
        END) AS LabelForDrinks, COUNT(*) AS NumberOfDrinks
FROM
(SELECT DO.DrinkOrderID, S.SizeName, COUNT(*) AS ToppingCount 
    FROM DRINK_ORDER DO 
    JOIN SIZE S ON DO.SizeID = S.SizeID
    JOIN DRINK_TOPPING_ORDER DTO on DO.DrinkOrderID = DTO.DrinkOrderID
    GROUP BY DO.DrinkOrderID) AS A
GROUP BY (CASE
    WHEN ToppingCount > 2 AND SizeName = 'Large'
        THEN 'Extravagant'
    WHEN ToppingCount BETWEEN 1 AND 2 AND (SizeName = 'Large' or SizeName = 'Medium')
        THEN 'Average'
    WHEN ToppingCount < 1 AND (SizeName = 'Medium' or SizeName = 'Small')
        THEN 'Frugal'
    ELSE 'Other'
        END)
GO 

-- How long is the average employee working each week and how much are they getting paid? - LAUREN 
-- *** NEED TO CHECK. WAITING FOR TABLES TO BE ALL POPULATED 
WITH 
CTE_EmployeeTotalHours (totalHours, EmployeeID) AS (
    SELECT SUM(ST.ShiftTypeEndTime - ST.ShiftTypeBeginTime) AS totalHours, E.EmployeeID
    FROM Employee E 
        JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = E.EmployeeID
        JOIN SHIFT S ON S.ShiftID = SE.ShiftID
        JOIN SHIFT_TYPE ST ON ST.ShiftTypeID = S.ShiftTypeID
    GROUP BY E.EmployeeID),
CTE_EmployeeTotalPayAndHours (totalPay, totalHours, EmployeeID) AS (
    SELECT (ETH.totalHours * ET.WagePerHour) AS totalPay, ETH.totalHours, E.EmployeeID
    FROM EMPLOYEE E 
        JOIN EMPLOYEE_TYPE ET ON ET.EmployeeTypeID = E.EmployeeTypeID
        JOIN CTE_EmployeeTotalHours ETH ON ETH.EmployeeID = E.EmployeeID 
    GROUP BY E.EmployeeID, ETH.totalHours
)
SELECT S.StoreID, ST.StoreName, AVG(ET.totalHours) AS AverageHours, AVG(ET.totalPay) AS AveragePay
FROM CTE_EmployeeTotalPayAndHours ET 
    JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = ET.EmployeeID
    JOIN SHIFT S ON S.ShiftID = SE.ShiftID
    JOIN STORE ST ON ST.StoreID = S.StoreID
GROUP BY S.StoreID, ST.StoreName 

-- For each employee in the barista employee type, what is the total amount of orders divided by the total hours worked, what is their average orders per hour. 

SELECT E.EmployeeID, E.EmployeeFName, E.EmployeeLName, ET.EmployeeTypeName, (COUNT(O.OrderID) / SUM(DATEDIFF(HOUR, ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime))) AS [Avg. Order Per Hour],
    RANK() OVER(PARTITION BY E.EmployeeID ORDER BY (COUNT(O.OrderID) / SUM(DATEDIFF(HOUR, ST.ShiftTypeBeginTime, ST.ShiftTypeEndTime))) DESC) EmpAvgOrderPHour_Rank
FROM EMPLOYEE E 
JOIN EMPLOYEE_TYPE ET ON ET.EmployeeTypeID = E.EmployeeTypeID
JOIN SHIFT_EMPLOYEE SE ON SE.EmployeeID = E.EmployeeID
JOIN SHIFT S ON S.ShiftID = SE.ShiftID
JOIN SHIFT_TYPE ST ON ST.ShiftTypeID = S.ShiftTypeID
JOIN ORDER O ON O.EmployeeID = E.EmployeeID
WHERE ET.EmployeeTypeName = "Barista" 
GROUP BY E.EmployeeID, E.EmployeeFName, E.EmployeeLName, ET.EmployeeTypeName
ORDER BY EmpAvgOrderPHour_Rank ASC
GO
