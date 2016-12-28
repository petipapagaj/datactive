SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 1 when parameter is invalid]
AS
BEGIN
SET NOCOUNT ON

DECLARE @ret INT

DECLARE @actual INT = (SELECT COUNT(1) FROM Datactive.DataVersion AS dv WHERE dv.Version = '0.0.1')

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @actual, -- sql_variant
    @Message = N'Data did not created in setup sp' -- nvarchar(max)

EXEC @ret = Datactive.CreateDataVersion @version = '0.0.1' -- varchar(10)

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data version creation did not failed for the same version' -- nvarchar(max)
  
END;





GO
