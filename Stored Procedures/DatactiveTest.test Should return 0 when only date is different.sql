SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 0 when only date is different]
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
WHERE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES AS t WHERE t.TABLE_SCHEMA = 'dbo' AND t.TABLE_NAME = OBJECT_NAME(p.object_id) 
				AND EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = 'datetime' AND c.TABLE_NAME = t.TABLE_NAME ))
AND p.rows > 0


SELECT TOP 1 @col = c.COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = 'datetime' AND c.TABLE_NAME = @table

SET @sql = 'UPDATE dbo.' + @table + ' SET ' + @col + ' = GETDATE()'

EXEC (@sql)

EXEC @ret = Datactive.HashMatch


EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data does not match' -- nvarchar(max)
 


  
END;






GO
