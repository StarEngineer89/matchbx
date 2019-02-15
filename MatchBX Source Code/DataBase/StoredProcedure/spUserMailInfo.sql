--Created by    :	Sanu Mohan P
--Created Date  :	26-07-2018
--Purpose       :	Load user details for Login 

--EXEC spUserMailInfo 'nar@lsg.com','1234@Lsg'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUserMailInfo')
DROP procedure spUserMailInfo
GO
CREATE PROCEDURE [spUserMailInfo]
(	 
	@UserId INT	
)
AS
BEGIN
	SELECT		
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,
		U.Email			
	FROM Users U	
	WHERE UserId = 	@UserId
END
GO



