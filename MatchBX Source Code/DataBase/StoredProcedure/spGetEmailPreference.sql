--Created by    :	Sanu Mohan P
--Created Date  :	01-08-2018
--Purpose       :	To get email preference for users

--EXEC spGetEmailPreference 1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetEmailPreference')
DROP procedure spGetEmailPreference
GO
CREATE PROCEDURE [spGetEmailPreference]
(	 
	@UserId int	
)
AS
BEGIN

SELECT
	UEM.UserEmailPreferenceMappingId,
	UEM.EmailPreferenceId,
	UEM.CheckStatus,
	EP.Description
FROM UserEmailPreferenceMapping UEM
INNER JOIN EmailPreference EP ON EP.EmailPreferenceId = UEM.EmailPreferenceId 
WHERE UserId = @UserId
		
END
GO



