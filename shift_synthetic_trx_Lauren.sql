
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

-- get Shift Type ID 
EXEC getShiftTypeID
@ShiftTypeName = @STName,
@STID = @STypeID OUTPUT 

IF @STypeID IS NULL 
    BEGIN
        PRINT 'Shift Type does not exist';
        THROW 55555, 'shift type ID is null', 11;
    END 

BEGIN TRAN T1 
    INSERT INTO SHIFT(ShiftTypeID, StoreID, [DateTime])
    VALUES (@STypeID, @StoreID, @shiftDate)

    IF @@ERROR <> 0 
        BEGIN 
            PRINT 'failed to insert into shift';
            ROLLBACK TRAN T1
        END 
    ELSE 
        COMMIT TRAN T1 
GO 

-- creating synthethic transaction to insert shift data 
CREATE PROCEDURE bulkInsertShiftData
@Run int 
AS 
DECLARE @StoreCount INT = (SELECT COUNT(*) FROM STORE)
DECLARE @ShiftTypeCount INT = (SELECT COUNT(*) FROM SHIFT_TYPE)

DECLARE @StoreID int
DECLARE @ShiftTypeID int
DECLARE @randomDate Datetime

WHILE @Run > 0
    BEGIN
        SET @StoreID = (SELECT RAND() * @StoreCount +1)
        SET @ShiftTypeID = (SELECT RAND() * @ShiftTypeCount + 1)
        SET @randomDate = CONVERT(DATE, DATEADD(day, (ABS(CHECKSUM(NEWID())) % 3650 * -1), GETDATE()))

        INSERT INTO SHIFT (ShiftTypeID, StoreID, [DateTime])
        VALUES (@ShiftTypeID, @StoreID, @randomDate)

        SET @Run = @Run - 1
    END
GO 

-- Running with 10 rows of inserts
EXEC dbo.bulkInsertShiftData 
@Run = 10

-- checking my work
SELECT * FROM SHIFT