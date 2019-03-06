--Created by    :	Sanu Mohan P
--Created Date  :	08-01-2019
--Purpose       :	To get gig details for dash board

--EXEC spGetGigDetailsForUser 60

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetGigDetailsForUser')
DROP procedure spGetGigDetailsForUser
GO
CREATE PROCEDURE [spGetGigDetailsForUser]
(	 
	@UserId int	
)
AS    
BEGIN
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #JobCompleted
	FROM Job J 
	INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
	WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId

	SELECT  
		G.GigTitle,
		G.GigId,
		GS.GigSubscriptionId,
		G.GigDescription,
		G.BudgetASP,
		G.UserId,
		G.Commission,
		G.TotalBudget,
		G.IsGigEnabled,
		G.GigDuration,	
		COALESCE(U.FullName,'@'+U.UserName) AS SeekerFullName,
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS SeekerProfilePic,
		CASE WHEN G.UserId = @UserId THEN 'C' ELSE 'S' END AS 'Role',
		G.GigStatus,
		G.IsActive,
		GS.GigSubscriptionId,
		GS.JobPosterId,
		GS.Description,
		GS.GigSubscriptionStatus,
		GS.CreatedDate,	
		COALESCE(UU.FullName,'@'+UU.UserName) AS PosterFullName,
		ISNULL(UPP.ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
		TD.TokenAddress,
		ISNULL(J.JobId,0) AS 'JobId',
		GS.Title,
		G.Deliverables,
		CONVERT(nvarchar(15),GS.CreatedDate,106) AS 'SubscribedDateDisplay',
		JC.TotalJobs AS 'JobsCompleted',
		CONVERT(nvarchar(15),GS.JobCompletionDate,106) AS 'JobCompletionDateDisplay'	 		
	FROM Gig G
	INNER JOIN Users U on G.UserId = U.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN GigSubscription GS ON GS.GigId = G.GigId
	LEFT JOIN Users UU ON UU.UserId = GS.JobPosterId
	LEFT JOIN UserProfile UPP ON UPP.UserId = UU.UserId
	LEFT JOIN TokenDistribution TD ON TD.GigSubscriptionId = GS.GigSubscriptionId
	LEFT JOIN Job J ON J.GigSubscriptionId = GS.GigSubscriptionId
	LEFT JOIN #JobCompleted JC ON JC.JobSeekerId = G.UserId AND G.GigId = JC.GigId	
	WHERE G.UserId = @UserId 

	UNION ALL

	SELECT  
		G.GigTitle,
		G.GigId,
		GS.GigSubscriptionId,
		G.GigDescription,
		G.BudgetASP,
		G.UserId,
		G.Commission,
		G.TotalBudget,
		G.IsGigEnabled,
		G.GigDuration,	
		COALESCE(U.FullName,'@'+U.UserName) AS SeekerFullName,
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS SeekerProfilePic,
		CASE WHEN G.UserId = @UserId THEN 'C' ELSE 'S' END AS 'Role',
		G.GigStatus,
		G.IsActive,
		GS.GigSubscriptionId,
		GS.JobPosterId,
		GS.Description,
		GS.GigSubscriptionStatus,
		GS.CreatedDate,	
		COALESCE(UU.FullName,'@'+UU.UserName) AS PosterFullName,
		ISNULL(UPP.ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
		TD.TokenAddress,
		ISNULL(J.JobId,0) AS 'JobId',
		GS.Title,
		G.Deliverables,
		CONVERT(nvarchar(15),GS.CreatedDate,106) AS 'SubscribedDateDisplay',
		JC.TotalJobs AS 'JobsCompleted',
		CONVERT(nvarchar(15),GS.JobCompletionDate,106) AS 'JobCompletionDate'			 				 				 
	FROM Gig G
	INNER JOIN Users U on G.UserId = U.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN GigSubscription GS ON GS.GigId = G.GigId
	LEFT JOIN Users UU ON UU.UserId = GS.JobPosterId
	LEFT JOIN UserProfile UPP ON UPP.UserId = UU.UserId
	LEFT JOIN TokenDistribution TD ON TD.GigSubscriptionId = GS.GigSubscriptionId
	LEFT JOIN Job J ON J.GigSubscriptionId = GS.GigSubscriptionId
	LEFT JOIN #JobCompleted JC ON JC.JobSeekerId = G.UserId AND G.GigId = JC.GigId
	WHERE GS.JobPosterId = @UserId

END




