SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Datactive].[CreateDataVersion] (@version VARCHAR(10), @sha1 VARCHAR(128))
AS
SET NOCOUNT ON

BEGIN

DECLARE @ret INT 

IF @version IS NULL OR @sha1 IS NULL
	RETURN -1 --invalid parameter

IF EXISTS (SELECT 1 FROM Datactive.DataVersion AS dv WHERE dv.Version = @version OR dv.GitReference = @sha1)
	RETURN 188 --version already created

DECLARE @xml XML

EXEC @ret = Datactive.GenerateXML @data = @xml OUT

IF @ret <> 0
	RETURN @ret

INSERT INTO Datactive.DataVersion ( Version, GitReference, Created, Data )
VALUES (@version, @sha1, GETUTCDATE(), @xml)

RETURN 0

END


GO
