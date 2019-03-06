--Created by    :Sanu Mohan P
--Created Date  :6/25/2018 12:51:41 PM
--Purpose      :MatchBX

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditEmailPreference')
DROP procedure spAddEditEmailPreference
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditEmailPreference
(
@EmailPreferenceId  int,
@Description  nvarchar(2000)
)
AS
IF(@EmailPreferenceId=0)
BEGIN
	INSERT  INTO EmailPreference 
	(
	  Description
	)
	VALUES 
	(
	  @Description
	)
    SELECT MAX(EmailPreferenceId) AS EmailPreferenceId  FROM EmailPreference

END
ELSE
BEGIN
   UPDATE EmailPreference SET
    Description	=  @Description
    WHERE EmailPreferenceId	=  @EmailPreferenceId
   SELECT @EmailPreferenceId as EmailPreferenceId
END
GO
