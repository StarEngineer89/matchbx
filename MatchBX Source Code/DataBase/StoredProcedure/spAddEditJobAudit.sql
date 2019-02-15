--Created by    :Sanu Mohan P
--Created Date  :10/24/2018 5:37:00 PM
--Purpose      :Job audit table

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobAudit')
DROP procedure spAddEditJobAudit
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobAudit
(
	@JobAuditId  int,
	@JobId  int,
	@UserId  int,
	@Status  char,
	@RejectReason  int,
	@CreatedDate  datetime,
	@ModifiedDate  datetime
)
AS
IF(@JobAuditId=0)
BEGIN
	INSERT  INTO JobAudit 
	(
	  JobId,
	  UserId,
	  Status,
	  RejectReason,
	  CreatedDate
	  --ModifiedDate
	)
	VALUES 
	(
	  @JobId,
	  @UserId,
	  @Status,
	  @RejectReason,
	  GETDATE()
	  --@ModifiedDate
	)
    SELECT MAX(JobAuditId) AS JobAuditId  FROM JobAudit

END
ELSE
BEGIN
   UPDATE JobAudit SET
    JobId	=  @JobId,
    UserId	=  @UserId,
    Status	=  @Status,
    RejectReason	=  @RejectReason,
    --CreatedDate	=  @CreatedDate,
    ModifiedDate	=  GETDATE()
    WHERE JobAuditId	=  @JobAuditId
   SELECT @JobAuditId as JobAuditId
END
GO
