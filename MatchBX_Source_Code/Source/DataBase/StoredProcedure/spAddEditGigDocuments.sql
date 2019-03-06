--Created by    :Sanu Mohan P
--Created Date  :1/7/2019 3:06:14 PM
--Purpose      :Model,Business classes

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGigDocuments')
DROP procedure spAddEditGigDocuments
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGigDocuments
(
	@GigDocumentsId  int,
	@DocumentName  nvarchar(1000),
	@GigId  int,
	@IsActive  char(1),
	@FileSize decimal(18,3)	
)
AS
IF(@GigDocumentsId=0)
BEGIN
	INSERT  INTO GigDocuments 
	(
	  DocumentName,
	  GigId,
	  IsActive,
	  FileSize,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @DocumentName,
	  @GigId,
	  @IsActive,
	  @FileSize,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(GigDocumentsId) AS GigDocumentsId  FROM GigDocuments

END
ELSE
BEGIN
   UPDATE GigDocuments SET
    DocumentName	=  @DocumentName,
    GigId	=  @GigId,
    IsActive	=  @IsActive, 
    FileSize	=  @FileSize,  
    ModifiedDate	=  GETDATE()
    WHERE GigDocumentsId	=  @GigDocumentsId
   SELECT @GigDocumentsId as GigDocumentsId
END
GO
