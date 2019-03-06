--Created by    :Sanu Mohan P
--Created Date  :10/31/2018 12:24:13 PM
--Purpose      :ReminderMails

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditReminderMails')
DROP procedure spAddEditReminderMails
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditReminderMails
(
	@ReminderMailsId  int,
	@JobId  int
)
AS
IF(@ReminderMailsId=0)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM ReminderMails WHERE JobId = @JobId)
	BEGIN
		INSERT INTO ReminderMails 
		(
		  JobId,
		  CreatedDate,
		  ModifiedDate
		)
		VALUES 
		(
		  @JobId,
		  GETDATE(),
		  GETDATE()
		)
		SELECT MAX(ReminderMailsId) AS ReminderMailsId  FROM ReminderMails
    END
    ELSE
    BEGIN
		UPDATE ReminderMails SET ModifiedDate = GETDATE() WHERE JobId = @JobId
		SELECT MAX(ReminderMailsId) AS ReminderMailsId  FROM ReminderMails WHERE JobId = @JobId
    END
END
GO
