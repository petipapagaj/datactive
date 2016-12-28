SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 0 when generating xml data]
AS
BEGIN
SET NOCOUNT ON 

	DECLARE @ret INT 
	EXEC @ret = Datactive.GenerateXML @data = NULL

	EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
	    @Actual = @ret, -- sql_variant
	    @Message = N'Generate xml data failed' -- nvarchar(max)
	
END;





GO
