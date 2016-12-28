SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Datactive].[CreateDataVersion] (@version VARCHAR(10)) --TC build number or something
AS
SET NOCOUNT ON

BEGIN

IF @version IS NULL OR EXISTS (SELECT 1 FROM Datactive.DataVersion AS dv WHERE dv.Version = @version)
	RETURN 1 --invalid parameter

DECLARE @xml XML

EXEC Datactive.GenerateXML @data = @xml OUT


INSERT INTO Datactive.DataVersion ( Version, Created, Data )
VALUES (@version, GETUTCDATE(), @xml)

RETURN 0

END
GO
