SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
 CREATE PROCEDURE [Datactive].[GenerateXML] (@data XML OUTPUT)
 AS
 BEGIN
 SET NOCOUNT ON


DECLARE @table VARCHAR(128);
DECLARE @pk VARCHAR(128);
DECLARE @core VARCHAR(max)
DECLARE @hashs TABLE (Tab VARCHAR(128), PK VARCHAR(128), md5 VARBINARY(128))
DECLARE @conversions TABLE (DataType VARCHAR(10), Characters int)


INSERT INTO @conversions ( DataType, Characters )
VALUES  ( 'bigint', 19),
		( 'int', 9),
		( 'float', 12),
		( 'tinyint', 2),
		( 'datetime', 19),
		( 'bit', 1)

DECLARE tableCursor CURSOR FAST_FORWARD READ_ONLY

FOR
    SELECT t.TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES AS t
    WHERE t.TABLE_SCHEMA = 'dbo' AND t.TABLE_TYPE = 'BASE TABLE' AND t.TABLE_NAME NOT LIKE '%deleted%'
	ORDER BY t.TABLE_NAME

OPEN tableCursor;

FETCH NEXT FROM tableCursor INTO @table;

WHILE @@FETCH_STATUS = 0
    BEGIN

		SELECT @core =
	     'SELECT '''+ @table + ''' as tab,'+ ISNULL(Col.COLUMN_NAME, 'NULL') +' as PK, master.sys.fn_repl_hash_binary( CONVERT( VARBINARY(MAX), '+
			STUFF((SELECT '+ ' + CASE WHEN c.DATA_TYPE = 'varchar' THEN '	ISNULL('+ c.COLUMN_NAME + ','''') ' WHEN c.DATA_TYPE IN ('varbinary') THEN 'CONVERT(VARCHAR(10), ISNULL(DATALENGTH( [' + c.COLUMN_NAME + '] ) ,''''))  ' ELSE 'CONVERT ( VARCHAR('+(SELECT DISTINCT CONVERT(VARCHAR(4),cv.Characters) FROM @conversions AS cv WHERE c.DATA_TYPE = cv.DataType)+'), ISNULL( [' + c.COLUMN_NAME + '] ,''''))'  END
					  FROM INFORMATION_SCHEMA.COLUMNS AS c 
					  WHERE t.TABLE_NAME = c.TABLE_NAME AND c.COLUMN_NAME NOT IN ( 'Created', 'Deleted', 'Updated', ISNULL(Col.COLUMN_NAME,''))
					  FOR XML PATH('')), 1, 1, '') 
			 + ' ) ) AS ColHash FROM dbo.' + t.TABLE_NAME
		FROM INFORMATION_SCHEMA.TABLES AS t
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab ON Tab.TABLE_NAME = t.TABLE_NAME AND Tab.TABLE_SCHEMA = t.TABLE_SCHEMA
		LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col ON Col.CONSTRAINT_NAME = Tab.CONSTRAINT_NAME AND Col.TABLE_NAME = Tab.TABLE_NAME 
		WHERE t.TABLE_NAME = @table AND t.TABLE_SCHEMA = 'dbo'

		IF @core  <> '' AND @core IS NOT NULL 
		INSERT @hashs (Tab, PK, md5 )
		EXEC (@core)

        FETCH NEXT FROM tableCursor INTO @table
    END;

CLOSE tableCursor
DEALLOCATE tableCursor

SELECT @data = (SELECT h.Tab [@table], h.PK, h.md5 
	FROM @hashs AS h
	FOR XML PATH('table'), ROOT('tables'))


END
GO
