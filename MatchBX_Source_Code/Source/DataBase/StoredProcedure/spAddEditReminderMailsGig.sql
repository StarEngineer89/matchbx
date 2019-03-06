--Created by    :Sanu Mohan P
--Created Date  :1/21/2019 3:56:26 PM
--Purpose      :Gig reminder mail

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditReminderMailsGig')
DROP procedure spAddEditReminderMailsGig
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditReminderMailsGig
(
	@ReminderMailsGigId  int,
	@GigId  int
)
AS
IF(@ReminderMailsGigId=0)
BEGIN
	INSERT  INTO ReminderMailsGig 
	(
	  GigId,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @GigId,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(ReminderMailsGigId) AS ReminderMailsGigId  FROM ReminderMailsGig

END
ELSE
BEGIN
   UPDATE ReminderMailsGig SET
    GigId	=  @GigId,    
    ModifiedDate	=  GETDATE()
    WHERE ReminderMailsGigId	=  @ReminderMailsGigId
   SELECT @ReminderMailsGigId as ReminderMailsGigId
END
GO
