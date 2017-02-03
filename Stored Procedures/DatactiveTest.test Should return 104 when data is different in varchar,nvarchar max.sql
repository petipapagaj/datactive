SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 104 when data is different in varchar,nvarchar max]
AS
BEGIN

SET NOCOUNT ON 

DECLARE @table VARCHAR(128)
DECLARE @pk VARCHAR(128)
DECLARE @sql VARCHAR(max)
DECLARE @col VARCHAR(128)
DECLARE @ret INT
DECLARE @datalength TABLE (Tab VARCHAR(128), PK VARCHAR(128), Col VARCHAR(128), PKVal BIGINT, Length INT)

DECLARE ColumnCursor CURSOR FAST_FORWARD READ_ONLY 
FOR 
	SELECT c.TABLE_NAME, c.COLUMN_NAME, cons.COLUMN_NAME AS PK
	FROM INFORMATION_SCHEMA.COLUMNS AS c 
	INNER JOIN (
				SELECT ccu.TABLE_NAME, ccu.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
				INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu ON ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
				WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY' 
			) cons ON c.TABLE_NAME = cons.TABLE_NAME
	WHERE (c.DATA_TYPE = 'varchar' OR c.DATA_TYPE = 'nvarchar') AND c.CHARACTER_MAXIMUM_LENGTH = -1 AND c.TABLE_SCHEMA = 'dbo'
	AND EXISTS (SELECT 1 FROM sys.partitions AS p WHERE c.TABLE_NAME = OBJECT_NAME(p.object_id) AND p.rows > 0)

OPEN ColumnCursor

FETCH NEXT FROM ColumnCursor INTO @table, @col, @pk

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @sql = 'SELECT ''' + @table + ''' as tab, '''+@col+''' as col, ''' + @pk + ''' as pk, '+@pk+' as pkval, ca.lens FROM dbo.' + @table + ' t CROSS APPLY (SELECT DATALENGTH('+ @col + ')) ca (lens) WHERE ca.lens = (SELECT MAX(DATALENGTH(tt.'+ @col +')) FROM dbo.'+ @table+' tt WHERE tt.'+ @col +' IS NOT NULL)' 

	INSERT INTO @datalength ( Tab, Col, PK, PKVal, Length )
	EXEC (@sql)

    FETCH NEXT FROM ColumnCursor INTO @table, @col, @pk
END

CLOSE ColumnCursor
DEALLOCATE ColumnCursor


SELECT @sql = 'UPDATE dbo.' +  d.Tab + ' SET ' + d.Col + ' = ''BEGINTHERAWTEXT''+'+ d.col + '+''ENDRAWTEXT'' WHERE ' + d.PK + ' = ' + CAST(d.PKVal AS VARCHAR(19))
FROM @datalength AS d 
WHERE d.Length = (SELECT MAX(DISTINCT dd.Length) FROM @datalength AS dd)

EXEC (@sql)

EXEC @ret = Datactive.HashMatch

EXEC tSQLt.AssertEquals @Expected = 104, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data validation failed' -- nvarchar(max)
  
END


GO
