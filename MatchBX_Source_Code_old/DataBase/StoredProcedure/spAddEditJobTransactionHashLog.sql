--Created by    :Sanu Mohan P
--Created Date  :10/16/2018 6:58:12 PM
--Purpose      :To store trabsaction hash 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobTransactionHashLog')
DROP procedure spAddEditJobTransactionHashLog
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobTransactionHashLog
(
	@JobTransactionHashLogId  int,
	@JobId  int,
	@Hash  nvarchar(max),
	@Status  char(1)
)
AS
IF(@JobTransactionHashLogId=0)
BEGIN
IF NOT EXISTS(SELECT 1 FROM JobTransactionHashLog WHERE Hash = @Hash)
BEGIN
	INSERT  INTO JobTransactionHashLog 
	(
	  JobId,
	  Hash,
	  Status,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @JobId,
	  @Hash,
	  @Status,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(JobTransactionHashLogId) AS JobTransactionHashLogId  FROM JobTransactionHashLog
END

END
ELSE
BEGIN
   UPDATE JobTransactionHashLog SET
    JobId	=  @JobId,
    Hash	=  @Hash,
    Status	=  @Status,
    --CreatedDate	=  @CreatedDate,
    ModifiedDate	=  GETDATE()
    WHERE JobTransactionHashLogId	=  @JobTransactionHashLogId
   SELECT @JobTransactionHashLogId as JobTransactionHashLogId
END
GO
