--Created by    :Sanu Mohan P
--Created Date  :6/20/2018 7:41:16 PM
--Purpose      :Add edit error log

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditErrorLog')
DROP procedure spAddEditErrorLog
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditErrorLog
(
	@ErrorLogId  int,
	@ErrorDescription  text,
	@ErrorReportedOn  datetime,
	@ErrorStack  text,
	@ErrorSource  varchar(500),
	@ErrorMethod  varchar(500),
	@UserId  int
)
AS
IF(@ErrorLogId=0)
BEGIN
	INSERT  INTO ErrorLog 
	(
	  ErrorDescription,
	  ErrorReportedOn,
	  ErrorStack,
	  ErrorSource,
	  ErrorMethod,
	  UserId
	)
	VALUES 
	(
	  @ErrorDescription,
	  @ErrorReportedOn,
	  @ErrorStack,
	  @ErrorSource,
	  @ErrorMethod,
	  @UserId
	)
    SELECT MAX(ErrorLogId) AS ErrorLogId  FROM ErrorLog

END
ELSE
BEGIN
   UPDATE ErrorLog SET
    ErrorDescription	=  @ErrorDescription,
    ErrorReportedOn	=  @ErrorReportedOn,
    ErrorStack	=  @ErrorStack,
    ErrorSource	=  @ErrorSource,
    ErrorMethod	=  @ErrorMethod,
    UserId	=  @UserId
    WHERE ErrorLogId	=  @ErrorLogId
   SELECT @ErrorLogId as ErrorLogId
END
GO
