SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [DatactiveTest].[test Should return 2 when table not exists in stored data]
AS
BEGIN
SET NOCOUNT ON

DECLARE @ret INT

CREATE TABLE dbo.dummy684684dsa83 (ID INT PRIMARY KEY, Something int)
INSERT INTO dbo.dummy684684dsa83 VALUES (1,1)

EXEC @ret = Datactive.HashMatch

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Table validation failed' -- nvarchar(max)

  
END;






GO
