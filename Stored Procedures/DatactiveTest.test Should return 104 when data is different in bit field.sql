SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 104 when data is different in bit field]
AS
BEGIN
SET NOCOUNT ON

DECLARE @table VARCHAR(128)
DECLARE @pk VARCHAR(128)
DECLARE @sql VARCHAR(250)
DECLARE @col VARCHAR(128)
DECLARE @ret INT
DECLARE @type VARCHAR(10) = 'bit'
DECLARE @pkTable TABLE (PK BIGINT, Value bit)
DECLARE @FieldValue VARCHAR(1) 
DECLARE @PKValue VARCHAR(19)

SELECT TOP 1 @table = OBJECT_NAME(p.object_id)
FROM sys.partitions AS p
WHERE EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = @type AND c.TABLE_NAME = OBJECT_NAME(p.object_id) AND c.TABLE_SCHEMA = 'dbo')
AND p.rows > 0

IF @table IS NULL
	RETURN 0 --no bit field in database


SELECT @pk = ccu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu ON ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME AND ccu.TABLE_NAME = tc.TABLE_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY' AND ccu.TABLE_NAME = @table

SELECT TOP 1 @col = c.COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = @type AND c.TABLE_NAME = @table 

SET @sql = 'SELECT TOP 1 ' + @pk + ', '+ @col +' FROM ' + @table + ' WHERE ' + @col + '  IS NOT NULL'
INSERT INTO @pkTable ( PK, Value )
EXEC (@sql)

SELECT @PKValue = pt.PK, @FieldValue = CASE pt.Value WHEN 0 THEN 1 WHEN 1 THEN 0 END FROM @pkTable AS pt

SET @sql = 'UPDATE dbo.' + @table + ' SET ' + @col + ' = '+ @FieldValue +' WHERE ' + @pk + ' = ' + @PKValue 
EXEC (@sql)

IF @@ROWCOUNT = 0
	EXEC tSQLt.Fail @Message0 = N'Wrong test implementation' -- nvarchar(max)

EXEC @ret = Datactive.HashMatch

EXEC tSQLt.AssertEquals @Expected = 104, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data validation failed' -- nvarchar(max)



  
END;










GO
