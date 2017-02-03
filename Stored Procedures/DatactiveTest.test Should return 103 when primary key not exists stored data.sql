SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 103 when primary key not exists stored data]
AS
BEGIN
SET NOCOUNT ON


DECLARE @ret INT
DECLARE @sql VARCHAR(250)
DECLARE @table VARCHAR(128)
DECLARE @cons VARCHAR(128)
DECLARE @col VARCHAR(128)
DECLARE @version VARCHAR(10) = '0.0.0.123' 

SELECT TOP 1 @table = ccu.TABLE_NAME, @cons = ccu.CONSTRAINT_NAME, @col = ccu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu ON ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME AND ccu.TABLE_NAME = tc.TABLE_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY' AND ccu.TABLE_SCHEMA = 'dbo'
AND EXISTS ( SELECT 1 FROM sys.partitions AS p WHERE tc.TABLE_NAME = OBJECT_NAME(p.object_id) AND p.rows > 0)

SET @sql = 'ALTER TABLE dbo.' + @table + ' DROP CONSTRAINT ' + @cons
EXEC (@sql)

EXEC @ret = Datactive.CreateDataVersion @version = @version, @sha1 = '684asdf68168946as' -- varchar(10)

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data version creation failed' -- nvarchar(max)


SET @sql = 'ALTER TABLE dbo.' + @table + ' ADD CONSTRAINT ' + @cons + ' PRIMARY KEY CLUSTERED (' + @col + ')'
EXEC (@sql)

EXEC @ret = Datactive.HashMatch @version = @version 

EXEC tSQLt.AssertEquals @Expected = 103, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'PK validation failed' -- nvarchar(max)

  
END;









GO
