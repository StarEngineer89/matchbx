
--Created by    :	Sanu Mohan P
--Created Date  :	25-02-2019
--Purpose       :	To get subscription details against Gig

--EXEC spGetGigSubscription 39

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetGigSubscription')
DROP procedure spGetGigSubscription
GO
CREATE PROCEDURE [spGetGigSubscription]
(	 
	@GigId int
)
AS
BEGIN
	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
	FROM Job WHERE JobStatus = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT 
		GS.GigSubscriptionId,
		GS.GigId,
		COALESCE(U.FullName,'@'+U.UserName) AS PosterFullName,
		ISNULL(ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
		ISNULL(JCP.TotalJobs,0) AS 'JobsCompleted',
		GS.CreatedDate,
		GS.JobCompletionDate,
		CONVERT(nvarchar(15),GS.CreatedDate,106) AS 'SubscribedDateDisplay',
		CONVERT(nvarchar(15),GS.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		GS.Title,
		GS.Description,
		GS.JobPosterId	
	FROM GigSubscription GS
	INNER JOIN Gig G ON GS.GigId = G.GigId
	INNER JOIN Users U ON U.UserId = GS.JobPosterId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedPoster JCP ON JCP.UserId = U.UserId
	WHERE GS.GigId = @GigId AND GS.IsActive = 'Y' AND GS.GigSubscriptionStatus = 'S'

	drop table #JobCompletedPoster		
END
GO



