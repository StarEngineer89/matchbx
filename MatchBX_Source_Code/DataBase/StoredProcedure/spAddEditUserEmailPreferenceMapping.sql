--Created by    :Sanu Mohan P
--Created Date  :7/31/2018 5:22:24 PM
--Purpose      :Email preference mapping

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditUserEmailPreferenceMapping')
DROP procedure spAddEditUserEmailPreferenceMapping
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditUserEmailPreferenceMapping
(
	@UserEmailPreferenceMappingId  int,
	@UserId  int,
	@EmailPreferenceId  int,
	@CheckStatus bit
)
AS
IF(@UserEmailPreferenceMappingId=0)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM UserEmailPreferenceMapping WHERE UserId = @UserId AND EmailPreferenceId = @EmailPreferenceId)
	BEGIN
		INSERT  INTO UserEmailPreferenceMapping 
		(
		  UserId,
		  EmailPreferenceId,
		  CheckStatus
		)
		VALUES 
		(
		  @UserId,
		  @EmailPreferenceId,
		  @CheckStatus
		)
		SELECT MAX(UserEmailPreferenceMappingId) AS UserEmailPreferenceMappingId  FROM UserEmailPreferenceMapping
    END
    ELSE
    BEGIN
		UPDATE UserEmailPreferenceMapping SET CheckStatus = @CheckStatus WHERE UserId = @UserId AND EmailPreferenceId = @EmailPreferenceId 
		SELECT MAX(UserEmailPreferenceMappingId) AS UserEmailPreferenceMappingId  FROM UserEmailPreferenceMapping
    END

END
ELSE
BEGIN
   UPDATE UserEmailPreferenceMapping SET
    UserId	=  @UserId,
    EmailPreferenceId	=  @EmailPreferenceId,
    CheckStatus = @CheckStatus
    WHERE UserEmailPreferenceMappingId	=  @UserEmailPreferenceMappingId
   SELECT @UserEmailPreferenceMappingId as UserEmailPreferenceMappingId
END
GO
