SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 2 when table not exists in current database]
AS
BEGIN
SET NOCOUNT ON

DECLARE @ret INT
DECLARE @table VARCHAR(128)

SELECT TOP 1 @table = OBJECT_NAME(p.object_id)
FROM sys.partitions AS p
WHERE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES AS t WHERE t.TABLE_SCHEMA = 'dbo' AND t.TABLE_NAME = OBJECT_NAME(p.object_id) AND EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.DATA_TYPE = 'varchar' AND c.TABLE_NAME = t.TABLE_NAME ))
AND p.rows > 0

DECLARE @sql VARCHAR(250) = 'DELETE FROM dbo.' + @table

EXEC (@sql)

EXEC @ret = Datactive.HashMatch

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Table comparison went fine' -- nvarchar(max)

	  
END;





GO
