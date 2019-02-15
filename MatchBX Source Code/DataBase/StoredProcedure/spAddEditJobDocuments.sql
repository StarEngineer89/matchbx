--Created by    :Sanu Mohan P
--Created Date  :6/29/2018 12:16:56 PM
--Purpose      :businee class

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobDocuments')
DROP procedure spAddEditJobDocuments
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobDocuments
(
@JobDocumentsId  int,
@DocumentName  nvarchar(1000),
@JobId  int,
@IsActive  char,
@Filesize float
)
AS
IF(@JobDocumentsId=0)
BEGIN
	INSERT  INTO JobDocuments 
	(
	  DocumentName,
	  JobId,
	  IsActive,
	  Filesize
	)
	VALUES 
	(
	  @DocumentName,
	  @JobId,
	  @IsActive,
	  @Filesize
	)
    SELECT MAX(JobDocumentsId) AS JobDocumentsId  FROM JobDocuments

END
ELSE
BEGIN
   UPDATE JobDocuments SET
    DocumentName	=  @DocumentName,
    JobId	=  @JobId,
    IsActive	=  @IsActive,
    Filesize = @Filesize
    WHERE JobDocumentsId	=  @JobDocumentsId
   SELECT @JobDocumentsId as JobDocumentsId
END
GO
