SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 104 when data is different in integer field]
AS
BEGIN
SET NOCOUNT ON

DECLARE @table VARCHAR(128)
DECLARE @pk VARCHAR(128)
DECLARE @sql VARCHAR(250)
DECLARE @col VARCHAR(128)
DECLARE @ret INT

SELECT TOP 1 @table = OBJECT_NAME(p.object_id)
FROM sys.partitions AS p
WHERE EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = 'int' AND c.TABLE_NAME = OBJECT_NAME(p.object_id) AND c.TABLE_SCHEMA = 'dbo')
AND p.rows > 0



SELECT @pk = ccu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu ON ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME AND ccu.TABLE_NAME = tc.TABLE_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY' AND ccu.TABLE_NAME = @table

SELECT TOP 1 @col = c.COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = 'int' AND c.TABLE_NAME = @table 

SET @sql = 'UPDATE dbo.' + @table + ' SET ' + @col + ' = 23452 WHERE ' + @pk + ' = (SELECT TOP 1 '+ @pk +' FROM dbo.'+ @table +')' 

EXEC (@sql)

EXEC @ret = Datactive.HashMatch

EXEC tSQLt.AssertEquals @Expected = 104, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data validation failed' -- nvarchar(max)



  
END;





GO
