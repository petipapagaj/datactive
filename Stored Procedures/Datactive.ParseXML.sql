SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Datactive].[ParseXML] (@Data XML)
AS
BEGIN
	SET NOCOUNT ON 

	SELECT ca.tabs.value('@table', 'varchar(128)'),
			ca.tabs.value('PK[1]', 'varchar(128)'),
			ca.tabs.value('md5[1]', 'varchar(128)')
	FROM @Data.nodes('//table') ca (tabs)


RETURN 0

END
GO
