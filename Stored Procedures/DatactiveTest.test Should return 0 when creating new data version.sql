SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 0 when creating new data version]
AS
BEGIN
SET NOCOUNT ON 

DECLARE @ret INT 
DECLARE @actual INT
DECLARE @version VARCHAR(5) = '0.1'

EXEC @ret = Datactive.CreateDataVersion @version = @version, @sha1 = '68486f4gh6f8684fgh'

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Creation of new data version failed' -- nvarchar(max)

SELECT @actual = COUNT(1) FROM Datactive.DataVersion AS dv WHERE dv.Version = @version

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @actual, -- sql_variant
    @Message = N'Data not in the table' -- nvarchar(max)

END;






GO
