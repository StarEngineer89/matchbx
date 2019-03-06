--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	User details analytics

--EXEC spAnalyticsUsers

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAnalyticsUsers')
DROP procedure spAnalyticsUsers
GO
CREATE PROCEDURE [spAnalyticsUsers]
AS
BEGIN

SELECT 
    U.UserId,
    U.UserName,
    U.FullName,
    U.Email,
    U.IsActive,
    U.UserType,
    U.CreatedDate,
    U.ModifiedDate,
    U.BlockReason,
    '' AS 'Geography'
FROM Users U

		
END
GO



