SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatactiveTest].[setup] AS
BEGIN
SET NOCOUNT ON 

DECLARE @version VARCHAR(5) = '0.0.1'

EXEC Datactive.CreateDataVersion @version = @version, @sha1 = '684sdfg684268dfa6846'


RETURN 0
END

GO
