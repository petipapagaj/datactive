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
DECLARE @sha1 VARCHAR(128) = '68486f4gh6f8684fgh'
EXEC @ret = Datactive.CreateDataVersion @version = @version, @sha1 = @sha1 

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Creation of new data version failed' -- nvarchar(max)

EXEC @ret = Datactive.CreateDataVersion @version = NULL, @sha1 = NULL

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Parameter null validation failed' -- nvarchar(max)

END;






GO
