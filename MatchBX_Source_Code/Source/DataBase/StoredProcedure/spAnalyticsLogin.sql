--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	Login details analytics

--EXEC spAnalyticsLogin

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAnalyticsLogin')
DROP procedure spAnalyticsLogin
GO
CREATE PROCEDURE [spAnalyticsLogin]
AS
BEGIN

SELECT 
    L.LoginId,
    L.UserId,
    L.LoginDate,
    L.IPAddress,
    L.LogoutDate
FROM Login L
		
END
GO



