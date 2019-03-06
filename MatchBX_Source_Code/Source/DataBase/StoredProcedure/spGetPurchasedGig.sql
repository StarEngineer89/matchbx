
--Created by    :	Sanu Mohan P
--Created Date  :	11-02-2019
--Purpose       :	To get purchased review details

--EXEC spGetPurchasedGig 2

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetPurchasedGig')
DROP procedure spGetPurchasedGig
GO
CREATE PROCEDURE [spGetPurchasedGig]
(	 
	@UserId int
)
AS
BEGIN

	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
	FROM Job WHERE JobStatusSeeker = 'C' AND JobStatus = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #GigCompletedSeekerCategory
	FROM Job J 
	INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
	WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId

	SELECT
		GS.GigId,
		GS.GigSubscriptionId,
		G.GigTitle,
		G.GigDescription,
		G.GigDuration,
		G.BudgetASP,
		G.Commission,
		G.TotalBudget,
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,
		ISNULL(S.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(GCS.TotalJobs,0) AS 'GigsCompleted',
		CONVERT(NVARCHAR(10),G.GigDuration) AS GigDurationString
	FROM GigSubscription GS
	INNER JOIN Job J ON ISNULL(J.GigSubscriptionId,0) = GS.GigSubscriptionId
	INNER JOIN Gig G ON G.GigId = GS.GigId
	INNER JOIN Users U ON U.UserId = G.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedSeeker S ON S.JobSeekerId = G.UserId
	LEFT JOIN #GigCompletedSeekerCategory GCS ON GCS.JobSeekerId = G.UserId AND G.GigId = GCS.GigId
	WHERE J.UserId = @UserId AND JobStatus IN ('A','C')	
	ORDER BY GS.GigSubscriptionId
	
	DROP TABLE #JobCompletedSeeker
	DROP TABLE #GigCompletedSeekerCategory	 
END
GO



