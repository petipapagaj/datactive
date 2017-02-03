SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 103 when primary key not exists in database]
AS
BEGIN
SET NOCOUNT ON

DECLARE @sql VARCHAR(250)
DECLARE @ret INT

SELECT TOP 1 @sql = 'ALTER TABLE dbo.' + Col.TABLE_NAME + ' DROP CONSTRAINT ' + Col.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col ON Col.CONSTRAINT_NAME = Tab.CONSTRAINT_NAME AND Col.TABLE_NAME = Tab.TABLE_NAME
WHERE Constraint_Type = 'PRIMARY KEY'
AND Col.TABLE_SCHEMA = 'dbo'
AND EXISTS ( SELECT 1 FROM sys.partitions AS p WHERE Tab.TABLE_NAME = OBJECT_NAME(p.object_id) AND p.rows > 0)

EXEC (@sql)

EXEC @ret = Datactive.HashMatch

EXEC tSQLt.AssertEquals @Expected = 103, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'PK comparison went wrong in' -- nvarchar(max)

  
END;







GO
