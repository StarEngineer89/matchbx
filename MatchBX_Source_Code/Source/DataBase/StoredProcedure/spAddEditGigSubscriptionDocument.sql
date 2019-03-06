--Created by    :Sanu Mohan P
--Created Date  :1/7/2019 3:06:14 PM
--Purpose      :Model,Business classes

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGigSubscriptionDocument')
DROP procedure spAddEditGigSubscriptionDocument
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGigSubscriptionDocument
(
	@GigSubscriptionDocumentId  int,
	@DocumentName  nvarchar(1000),
	@GigSubscriptionId  int,
	@IsActive  char(1),
	@FileSize decimal(18,3)	
)
AS
IF(@GigSubscriptionDocumentId=0)
BEGIN
	INSERT  INTO GigSubscriptionDocument 
	(
	  DocumentName,
	  GigSubscriptionId,
	  IsActive,
	  FileSize,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @DocumentName,
	  @GigSubscriptionId,
	  @IsActive,
	  @FileSize,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(GigSubscriptionDocumentId) AS GigSubscriptionDocumentId  FROM GigSubscriptionDocument

END
ELSE
BEGIN
   UPDATE GigSubscriptionDocument SET
    DocumentName	=  @DocumentName,
    GigSubscriptionId	=  @GigSubscriptionId,
    IsActive	=  @IsActive,  
    FileSize	=  @FileSize, 
    ModifiedDate	=  GETDATE()
    WHERE GigSubscriptionDocumentId	=  @GigSubscriptionDocumentId
   SELECT @GigSubscriptionDocumentId as GigSubscriptionDocumentId
END
GO
