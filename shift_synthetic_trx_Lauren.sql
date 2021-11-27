
-- getStoreID
CREATE PROCEDURE getStoreID
    @StoreName varchar(100),
    @SID int OUTPUT
AS
SET @SID = (SELECT StoreID FROM STORE WHERE StoreName = @StoreName)
GO

-- getShiftTypeID 
CREATE PROCEDURE getShiftTypeID
    @ShiftTypeName varchar(100),
    @STID int OUTPUT
AS
SET @STID = (SELECT ShiftTypeID FROM SHIFT_TYPE WHERE ShiftTypeName = @ShiftTypeName)
GO

-- INSERT SHIFT
CREATE PROCEDURE insertShiftID
    @STName varchar(100),
    @SName varchar(100),
    @shiftDate dateTime
AS
DECLARE @STypeID int, @StoreID int 

-- get store ID 
EXEC getStoreID
@StoreName = @SName,
@SID = @StoreID OUTPUT 

IF @StoreID IS NULL 
    BEGIN
        PRINT 'storeName does not exist';
        THROW 55555, 'store ID is null', 11;
    END 
GO 

-- INSERT SHIFT 
CREATE PROCEDURE insertShift
@ShiftTypeName varchar(50),
@StoreName varchar(50),
@Day date 
AS 
DECLARE @ShiftTypeID int, @StoreID int 

EXEC getShiftTypeID
    @STypeName = @ShiftTypeName,
    @STID = @ShiftTypeID OUTPUT
IF (@ShiftTypeID IS NULL)
BEGIN 
    PRINT 'Could not find a ShiftType ID from parameters!';
    THROW 99999, '@ShiftTypeID returned null value.', 1;
END

EXEC getStoreID
    @SName = @StoreName,
    @SID = @StoreID OUTPUT
IF (@StoreID IS NULL)
BEGIN 
    PRINT 'Could not find a Store ID from parameters!';
    THROW 99999, '@StoreID returned null value.', 1;
END

BEGIN TRAN T1
    INSERT INTO SHIFT(ShiftTypeID, StoreID, [DateTime])
    VALUES (@ShiftTypeID, @StoreID, @Day)
    IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRAN T1 
        END 
    ELSE 
        COMMIT TRAN T1 

GO 

-- creating synthethic transaction to insert shift data 
ALTER PROCEDURE bulkInsertShiftData
@Run int 
AS 
DECLARE @StoreCount INT = (SELECT COUNT(*) FROM STORE)
DECLARE @ShiftTypeCount INT = (SELECT COUNT(*) FROM SHIFT_TYPE)

DECLARE @Store varchar(50)
DECLARE @ShiftType varchar(50)
DECLARE @randomDate Datetime

WHILE @Run > 0
    BEGIN
        SET @Store =  (SELECT StoreName FROM STORE WHERE StoreID = ROUND(RAND() * @StoreCount +1, 0))
        SET @ShiftType = (SELECT ShiftTypeName FROM SHIFT_TYPE WHERE ShiftTypeID = ROUND(RAND() * @ShiftTypeCount +1, 0))
        SET @randomDate = CONVERT(DATE, DATEADD(day, (ABS(CHECKSUM(NEWID())) % 3650 * -1), GETDATE()))

        EXEC insertShift
        @ShiftTypeName = @ShiftType,
        @StoreName = @Store,
        @Day = @randomDate

        SET @Run = @Run - 1
    END
GO 

-- Running with 3000 rows of inserts
EXEC dbo.bulkInsertShiftData 
@Run = 3000

-- checking my work
SELECT * FROM SHIFT