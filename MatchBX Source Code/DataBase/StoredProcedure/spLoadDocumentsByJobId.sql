--Created by    :	Sanu Mohan P
--Created Date  :	29-06-2018
--Purpose       :	Load job documents for job on edit

--EXEC spLoadDocumentsByJobId 1119

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadDocumentsByJobId')
DROP procedure spLoadDocumentsByJobId
GO
CREATE PROCEDURE [spLoadDocumentsByJobId]
(	 
	@JobId int	
)
AS
BEGIN

SELECT 
	JD.DocumentName,
	JD.JobDocumentsId,
	JD.JobId,
	JD.Filesize		
FROM JobDocuments JD
WHERE JD.JobId = @JobId AND IsActive = 'Y'
		
END
GO



