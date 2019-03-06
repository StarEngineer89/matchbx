--Created by    :	Praveen K
--Created Date  :	07-02-2019
--Purpose       :	To get verified partners

--EXEC spGetVerifiedPartners 0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetVerifiedPartners')
DROP procedure spGetVerifiedPartners
GO
CREATE PROCEDURE [spGetVerifiedPartners]
(	 
	@JobCategoryId int
)
AS
BEGIN

SELECT TOP 10	
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
	--COUNT(GigId) AS 'NoOfGigs',
	U.UserId
FROM Users U
	--INNER JOIN Users U ON U.UserId = G.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
WHERE 
	--(G.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
	--AND G.GigStatus = 'P' AND G.IsActive = 'Y'
	U.VerifiedPartner = 'Y'
--GROUP BY G.UserId,U.FullName,ProfilePic,U.UserName
--ORDER BY COUNT(GigId) desc
	

END
GO