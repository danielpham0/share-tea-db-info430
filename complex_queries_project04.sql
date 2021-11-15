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