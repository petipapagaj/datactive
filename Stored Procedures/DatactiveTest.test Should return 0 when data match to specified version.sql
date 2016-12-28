SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 0 when data match to specified version]
AS
BEGIN
SET NOCOUNT ON 

DECLARE @version VARCHAR(5) = '0.0.1'
DECLARE @ret INT
DECLARE @actual INT = (SELECT COUNT(1) FROM Datactive.DataVersion AS dv WHERE dv.Version = @version)

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @actual, -- sql_variant
    @Message = N'Data did not created in setup sp' -- nvarchar(max)


EXEC @ret = Datactive.HashMatch @version = @version

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Data does not match' -- nvarchar(max)
 

  
END




GO
