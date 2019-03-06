--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	To get email preference details

--EXEC spGetEmailNotifications 2,'2'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetEmailNotifications')
DROP procedure spGetEmailNotifications
GO
CREATE PROCEDURE [spGetEmailNotifications]
(	 
	@UserId int,
	@EmailPreferenceIdList nvarchar(50)
)
AS
BEGIN

DECLARE @Status int = 1
IF EXISTS (SELECT 1 FROM UserEmailPreferenceMapping WHERE UserId = @UserId)
BEGIN
	IF EXISTS(SELECT 1 FROM UserEmailPreferenceMapping WHERE UserId = @UserId AND EmailPreferenceId IN (SELECT CAST(Item AS integer) FROM SplitString(@EmailPreferenceIdList,',')) AND CheckStatus = 1)
	BEGIN
		SELECT @Status AS Status
	END
	ELSE
	BEGIN
		SET @Status = 0
		SELECT @Status AS Status
	END
END
ELSE
BEGIN
	SELECT @Status AS Status
END
		
END
GO



