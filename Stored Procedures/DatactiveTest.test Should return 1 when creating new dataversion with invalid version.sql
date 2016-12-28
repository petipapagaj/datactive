SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 1 when creating new dataversion with invalid version]
AS
BEGIN
SET NOCOUNT ON

DECLARE @ret INT 
DECLARE @version VARCHAR(4) = '0.1'

EXEC @ret = Datactive.CreateDataVersion @version = @version

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Creation of new data version failed' -- nvarchar(max)

EXEC @ret = Datactive.CreateDataVersion @version = @version

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Should be add unique data version' -- nvarchar(max)

END;




GO
