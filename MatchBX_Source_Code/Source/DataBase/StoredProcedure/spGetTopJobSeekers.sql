
--Created by    :	Sanu Mohan P
--Created Date  :	09-01-2019
--Purpose       :	To get top job seeker details

--EXEC spGetTopJobSeekers 0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetTopJobSeekers')
DROP procedure spGetTopJobSeekers
GO
CREATE PROCEDURE [spGetTopJobSeekers]
(	 
	@JobCategoryId int
)
AS
BEGIN

SELECT TOP 10	
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
	COUNT(J.JobId) AS 'NoOfJobs',
	G.UserId
FROM Gig G
INNER JOIN Users U ON U.UserId = G.UserId
INNER JOIN GigSubscription GS ON GS.GigId = G.GigId
INNER JOIN Job J ON J.GigSubscriptionId = GS.GigSubscriptionId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
WHERE (G.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
AND J.JobStatus = 'C' AND J.IsActive = 'Y' --AND G.IsActive = 'Y' AND G.IsGigEnabled = 'Y'
GROUP BY G.UserId,U.FullName,ProfilePic,U.UserName
order by COUNT(JobId) desc
		
END
GO



