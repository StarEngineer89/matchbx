--Created by    :	Sanu Mohan P
--Created Date  :	16-01-2019
--Purpose       :	To get gig details for profile
--EXEC spGetGigDetailsProfile 10,10



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetGigDetailsProfile')
DROP procedure spGetGigDetailsProfile
GO
CREATE PROCEDURE [spGetGigDetailsProfile]
(	
	@UserId int,
	@LoginUserId int
)
AS
IF(@UserId = @LoginUserId)
BEGIN
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
	FROM Job WHERE JobStatusSeeker = 'C' AND JobStatus = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #GigCompletedSeekerCategory
	FROM Job J 
	INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
	WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId	

	SELECT DISTINCT
		G.GigTitle,
		G.BudgetASP,
		G.Commission,
		G.TotalBudget,
		G.GigDescription,	
		G.GigDuration,	
		G.GigDuration AS GigDurationString,	
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
		ISNULL(S.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(GCS.TotalJobs,0) AS 'GigsCompleted',		
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		G.GigId,
		G.UserId,	
		G.GigStatus,
		CASE WHEN LEN(G.GigDescription) > 200 THEN SUBSTRING(G.GigDescription,0,200) + '...' ELSE G.GigDescription END AS 'GigDescriptionDisplay',		
		G.IsGigEnabled,
		G.JobCategoryId	
	FROM Gig G
	INNER JOIN Users U ON U.UserId = G.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedSeeker S ON S.JobSeekerId = G.UserId
	LEFT JOIN #GigCompletedSeekerCategory GCS ON GCS.JobSeekerId = G.UserId AND G.GigId = GCS.GigId
	LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId	
	WHERE 
	G.UserId = @UserId 
	AND G.IsActive = 'Y' AND G.GigStatus = 'P'
	ORDER BY G.GigId DESC
	
	drop table #JobCompletedSeeker

END
ELSE
BEGIN
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeekerDual
	FROM Job WHERE JobStatusSeeker = 'C' AND JobStatus = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #GigCompletedSeekerCategoryDual
	FROM Job J 
	INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
	WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId		

	SELECT DISTINCT
		G.GigTitle,
		G.BudgetASP,
		G.Commission,
		G.TotalBudget,
		G.GigDescription,	
		G.GigDuration,	
		G.GigDuration AS GigDurationString,	
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
		ISNULL(S.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(GCS.TotalJobs,0) AS 'GigsCompleted',	
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		G.GigId,
		G.UserId,	
		G.GigStatus,
		CASE WHEN LEN(G.GigDescription) > 200 THEN SUBSTRING(G.GigDescription,0,200) + '...' ELSE G.GigDescription END AS 'GigDescriptionDisplay',		
		G.IsGigEnabled,
		G.JobCategoryId	
	FROM Gig G
	INNER JOIN Users U ON U.UserId = G.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedSeekerDual S ON S.JobSeekerId = G.UserId
	LEFT JOIN #GigCompletedSeekerCategoryDual GCS ON GCS.JobSeekerId = G.UserId AND G.GigId = GCS.GigId
	LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId	
	WHERE 
	G.UserId = @UserId 
	AND G.IsActive = 'Y' AND G.GigStatus = 'P' AND G.IsGigEnabled = 'Y'
	ORDER BY G.GigId DESC
	
	drop table #JobCompletedSeekerDual
	drop table #GigCompletedSeekerCategoryDual
END
GO



