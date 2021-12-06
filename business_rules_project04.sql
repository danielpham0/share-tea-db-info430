USE INFO_430_Proj_04;
GO

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
                JOIN DRINK_ORDER DO on DO.OrderID = O.OrderID
                JOIN DRINK D on DO.DrinkID = D.DrinkID
                JOIN DRINK_TYPE DT on D.DrinkTypeID = DT.DrinkTypeID
            WHERE DT.DrinkTypeName = 'Signature'
            AND C.CustomerDOB > DATEADD(YEAR, -21, GETDATE()))
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE DRINK_ORDER with nocheck
ADD CONSTRAINT CK_AgeForAlcohol
CHECK(dbo.fn_checkAgeForAlchol() = 0)
GO 

-- The number of employees for a morning shift cannot exceed 4 after 2018 at the ShareTea-04 branch
CREATE FUNCTION dbo.fn_checkMorningShift()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM SHIFT S
                JOIN SHIFT_TYPE ST ON S.ShiftTypeID = ST.ShiftTypeID
                JOIN STORE STO ON STO.StoreID = S.StoreID
            WHERE ST.ShiftTypeName = 'Morning' AND S.TotalEmpShift > 4
                AND YEAR(S.[DateTime]) > 2018 AND STO.StoreName = 'ShareTea-04')
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE SHIFT with nocheck
ADD CONSTRAINT CK_MorningShift
CHECK(dbo.fn_checkMorningShift() = 0)
GO 

-- Employee must be older than 16 to work
CREATE FUNCTION dbo.fn_checkEmployeeMinimumAge()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM Employee E 
            -- Check if employee birthday is more than 16 years before today's date. 
            WHERE E.EmployeeDOB <= DATEADD(YEAR, -16, GETDATE())) 
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE Employee
ADD CONSTRAINT CK_EmployeeMinimumAge
CHECK(dbo.fn_checkEmployeeMinimumAge() = 0)
GO

-- EmployeeTypeWagePerHour cannot be lower than $15/hour  
CREATE FUNCTION dbo.fn_checkEmployeeMinimumWage()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM EMPLOYEE_TYPE ET
            -- Check if employee wage is at least 15 dollars an hour. 
            WHERE ET.WagePerHour >= 15) 
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE EMPLOYEE_TYPE
ADD CONSTRAINT CK_EmployeeMinimumWage
CHECK(dbo.fn_checkEmployeeMinimumWage() = 0)
GO

-- A small drink cannot have any more than 3 toppings
CREATE FUNCTION dbo.fn_checkNumToppingsSmall()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT DO.DrinkOrderID, COUNT(DrinkToppingOrderID)
            FROM DRINK_ORDER DO 
            JOIN DRINK_TOPPING_ORDER DTO ON DTO.DrinkOrderID = DO.DrinkOrderID
            JOIN SIZE S ON S.SizeID = DO.SizeID
            WHERE S.SizeName = 'Small'
            GROUP BY DO.DrinkOrderID
            HAVING COUNT(DrinkToppingOrderID) > 3)
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE DRINK_TOPPING_ORDER
ADD CONSTRAINT CK_NumToppingsSmall
CHECK(dbo.fn_checkNumToppingsSmall() = 0)
GO

-- OrderDate cannot be more than GETDATE()
CREATE FUNCTION dbo.fn_checkOrderDate()
RETURNS INTEGER
AS 
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM [ORDER]
            WHERE OrderDate > GETDATE())
            BEGIN
                SET @RET = 1
            END
RETURN @RET
END
GO
ALTER TABLE [ORDER]
ADD CONSTRAINT CK_OrderDate
CHECK(dbo.fn_checkOrderDate() = 0)
GO

-- ShiftTypeBeginTime cannot be before StoreOpeningTime

CREATE FUNCTION dbo.fn_checkBeginTime()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM SHIFT_TYPE ST
            JOIN SHIFT SH ON ST.ShiftTypeID = SH.ShiftTypeID
            JOIN STORE S ON SH.StoreID = S.StoreID
            WHERE ST.ShiftTypeBeginTime < S.StoreOpeningTime)
    BEGIN
        SET @RET = 1
    END
RETURN @RET
END
GO
ALTER TABLE SHIFT_TYPE
ADD CONSTRAINT CK_BeginTime
CHECK(dbo.fn_checkBeginTime() = 0)
GO

-- ShiftTypeEndTime cannot be after StoreClosingTime

CREATE FUNCTION dbo.fn_checkEndTime()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
            FROM SHIFT_TYPE ST
            JOIN SHIFT SH ON ST.ShiftTypeID = SH.ShiftTypeID
            JOIN STORE S ON SH.StoreID = S.StoreID
            WHERE ST.ShiftTypeEndTime > S.StoreClosingTime)
    BEGIN
        SET @RET = 1
    END
RETURN @RET
END
GO
ALTER TABLE SHIFT_TYPE
ADD CONSTRAINT CK_EndTime
CHECK(dbo.fn_checkEndTime() = 0)
GO