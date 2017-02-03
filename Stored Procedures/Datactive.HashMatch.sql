SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Datactive].[HashMatch] (@version VARCHAR(10) = NULL, @showObjects BIT = 0)
AS
SET NOCOUNT ON

BEGIN

DECLARE @CurrentXML XML
DECLARE @StoredXML XML
DECLARE @diff INT = 0
DECLARE @objects TABLE (Object VARCHAR(256))
DECLARE @ret INT 

SELECT TOP 1 @StoredXML = dv.Data 
FROM Datactive.DataVersion AS dv
WHERE @version IS NULL OR dv.Version = @version
ORDER BY dv.Created DESC

IF @@ROWCOUNT = 0
	RETURN -1 --invalid parameter

EXEC @ret = Datactive.GenerateXML @data = @CurrentXML OUT

IF @ret <> 0
	RETURN @ret --internal error

DECLARE @CurrentData Datactive.HashVersion
DECLARE @StoredData Datactive.HashVersion

INSERT INTO @StoredData ( TableName, PK, md5 )
EXEC Datactive.ParseXML @StoredXML

INSERT INTO @CurrentData ( TableName, PK, md5 )
EXEC Datactive.ParseXML @CurrentXML

INSERT INTO @objects ( Object )
SELECT ISNULL(cd.TableName, sd.TableName) 
FROM (SELECT DISTINCT cd.TableName FROM @CurrentData AS cd) AS cd
FULL OUTER JOIN (SELECT DISTINCT sd.TableName FROM @StoredData AS sd) AS sd ON sd.TableName = cd.TableName
WHERE cd.TableName IS NULL OR sd.TableName IS NULL 

IF @@ROWCOUNT > 0
BEGIN
	IF @showObjects = 1
		SELECT DISTINCT o.Object FROM @objects AS o
	
	RETURN 102 --table mismatch
END



INSERT INTO @objects ( Object )
SELECT ISNULL(cd.TableName, sd.TableName) 
FROM (SELECT DISTINCT cd.TableName, cd.PK FROM @CurrentData AS cd) AS cd
FULL OUTER JOIN (SELECT DISTINCT sd.TableName, sd.PK FROM @StoredData AS sd) AS sd ON sd.PK = cd.PK AND sd.TableName = cd.TableName
WHERE cd.PK IS NULL OR sd.PK IS NULL 



IF @@ROWCOUNT > 0
BEGIN
	IF @showObjects = 1
		SELECT DISTINCT o.Object FROM @objects AS o
	

	RETURN 103 --pk mismatch
END


INSERT INTO @objects ( Object )
SELECT ISNULL(cd.TableName, sd.TableName) 
FROM @CurrentData AS cd
FULL OUTER JOIN @StoredData AS sd ON sd.TableName = cd.TableName AND sd.PK = cd.PK AND sd.md5 = cd.md5
WHERE cd.md5 IS NULL OR sd.md5 IS NULL 


IF @@ROWCOUNT > 0
BEGIN
	IF @showObjects = 1
		SELECT DISTINCT o.Object FROM @objects AS o
	
	RETURN 104 --data mismatch
END

IF @showObjects = 1
	SELECT 'N/A' AS object

RETURN 0

END





GO
