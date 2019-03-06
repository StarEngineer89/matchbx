--Created by    :	Sanu Mohan P
--Created Date  :	08-01-2019
--Purpose       :	Load gig documents for gig on edit

--EXEC spLoadDocumentsByGigId 1119

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadDocumentsByGigId')
DROP procedure spLoadDocumentsByGigId
GO
CREATE PROCEDURE [spLoadDocumentsByGigId]
(	 
	@GigId int	
)
AS
BEGIN

SELECT 
	GD.DocumentName,
	GD.GigDocumentsId,
	GD.GigId,
	GD.Filesize		
FROM GigDocuments GD
WHERE GD.GigId = @GigId AND IsActive = 'Y'
		
END
GO



