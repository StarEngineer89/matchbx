--Created by    :	Sanu Mohan P
--Created Date  :	27-07-2018
--Purpose       :	To get job details for dash board

--EXEC spGetJobDetailsForUser 2,'A'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetJobDetailsForUser')
DROP procedure spGetJobDetailsForUser
GO
CREATE PROCEDURE [spGetJobDetailsForUser]
(	 
	@UserId int,
	@JobStatus char(1)	
)
AS    
BEGIN

IF @JobStatus = 'P' --All listed jobs
BEGIN
	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPosterALL
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT JobId INTO #Transaction FROM JobTransactionHashLog WHERE Status = 'N' GROUP BY JobId HAVING COUNT(JobId) > 0

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(JB.BidAmount,0) AS BidAmount,		
		J.JobId,
		J.UserId,
		'P' AS UserRole,
		ISNULL(JB.BidMessage,'') AS BidMessage,
		J.JobStatus,
		J.JobCompletionDate,
		ISNULL(COALESCE(K.FullName,'@' + K.UserName),'') AS 'BidUserName',
		ISNULL(JB.UserId,0) AS 'BidUserId',
		ISNULL(UB.ProfilePic,'/Content/images/user.png') AS 'BidUserProfilePic',
		ISNULL(JB.JobBiddingId,0) AS JobBiddingId,
		ISNULL(TDP.TokenAddress,'') AS 'TokenAddressPoster',
		ISNULL(TDP.IsApproved,'') AS 'IsApprovedPoster',
		ISNULL(TDS.TokenAddress,'') AS 'TokenAddressSeeker',
		ISNULL(TDS.IsApproved,'') AS 'IsApprovedSeeker',
		CASE WHEN ISNULL(TD.IsApproved,'F') = 'N' THEN 'D' ELSE 'E' END AS 'CompletionStatus',
		CASE 
			WHEN ISNULL(TD.IsApproved,'F') IN ('F') THEN 'ACCEPT OFFER'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND ISNULL(TX.JobId,0) = 0 AND ISNULL(JB.IsPending,'N') = 'Y' THEN 'PENDING TRANSACTION'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND Hash = '' AND ISNULL(JB.IsPending,'N') = 'N' THEN 'ACCEPT OFFER'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND ISNULL(TX.JobId,0) <> 0 AND ISNULL(JB.IsPending,'N') = 'Y' THEN 'OFFER ACCEPTED'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND Hash <> '' AND ISNULL(JB.IsPending,'N') = 'N' THEN 'ACCEPT OFFER'
		END AS AcceptStatus,
		CASE 
			WHEN ISNULL(TD.IsApproved,'F') IN ('F') THEN 'Accept Offer'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND ISNULL(TX.JobId,0) = 0 AND ISNULL(JB.IsPending,'N') = 'Y' THEN 'Pending Transaction'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND Hash = '' AND ISNULL(JB.IsPending,'N') = 'N' THEN 'Accept Offer'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND ISNULL(TX.JobId,0) <> 0 AND ISNULL(JB.IsPending,'N') = 'Y' THEN 'Offer Accepted'
			WHEN ISNULL(TD.IsApproved,'F') = 'N' AND Hash <> '' AND ISNULL(JB.IsPending,'N') = 'N' THEN 'Accept Offer'
		END AS AcceptStatusHover			
		 --ISNULL(JB.IsPending,'N') 	
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedPosterALL D ON D.UserId = J.UserId
	LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsActive,'Y') = 'Y'
	LEFT JOIN TokenDistribution TDP ON TDP.UserId = U.UserId AND JB.JobBiddingId = TDP.JobBiddingId
	LEFT JOIN TokenDistribution TDS ON TDS.UserId = JB.UserId AND JB.JobBiddingId = TDS.JobBiddingId
	LEFT JOIN TransactionDetail TD ON TD.JobId = J.JobId AND TD.ProcessType = 'D' AND TD.IsApproved = 'N'
	LEFT JOIN Users K ON K.UserId = JB.UserId
	LEFT JOIN UserProfile UB ON UB.UserId = JB.UserId
	LEFT JOIN #Transaction TX ON TX.JobId = J.JobId
	WHERE J.UserId = @UserId AND J.JobStatus IN ('P','B') 
	AND J.IsActive = 'Y' --AND ISNULL(JB.IsActive,'Y') = 'Y'
	
	DROP TABLE #JobCompletedPosterALL
	DROP TABLE #Transaction
END
ELSE IF @JobStatus = 'C' --All completed jobs
BEGIN
	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPosterComp
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(U.FullName,'@'+U.UserName) AS 'PosterFullName',
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(JB.BidAmount,0) AS BidAmount,		
		J.JobId,
		J.UserId AS 'JobPosterId',
		ISNULL(J.JobSeekerId,0) AS 'JobSeekerId',
		'P' AS UserRole,
		ISNULL(COALESCE(US.FullName,'@'+US.UserName),'') AS 'SeekerFullName',
		ISNULL(J.GigSubscriptionId,0) AS GigSubscriptionId
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.UserId
	LEFT JOIN Users US ON US.UserId = J.JobSeekerId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedPosterComp D ON D.UserId = J.UserId
	LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
	WHERE J.UserId = @UserId AND JobStatus = @JobStatus
	AND J.IsActive = 'Y'

	UNION ALL

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(US.FullName,'@'+US.UserName) AS 'PosterFullName',
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(JB.BidAmount,0) AS BidAmount,		
		J.JobId,
		J.UserId AS 'JobPosterId',
		ISNULL(J.JobSeekerId,0) AS 'JobSeekerId',		
		'S' AS UserRole,
		ISNULL(COALESCE(U.FullName,'@'+U.UserName),'') AS 'SeekerFullName',
		ISNULL(J.GigSubscriptionId,0) AS GigSubscriptionId		
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.JobSeekerId
	INNER JOIN Users US ON US.UserId = J.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = US.UserId
	LEFT JOIN #JobCompletedPosterComp D ON D.UserId = J.UserId
	LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
	WHERE ISNULL(J.JobSeekerId,0) = @UserId AND J.JobStatusSeeker = @JobStatus
	AND J.IsActive = 'Y'
	
	DROP TABLE #JobCompletedPosterComp
END
ELSE IF @JobStatus = 'A' --Progress
BEGIN

	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(U.FullName,'@'+U.UserName) AS 'PosterFullName',
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(UPS.ProfilePic,'/Content/images/user.png') AS 'BidUserProfilePic',
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(JB.BidAmount,0) AS BidAmount,		
		J.JobId,
		J.UserId AS 'JobPosterId',
		ISNULL(J.JobSeekerId,0) AS 'JobSeekerId',
		'P' AS UserRole,
		ISNULL(COALESCE(US.FullName,'@'+US.UserName),'') AS 'SeekerFullName',
		JobStatusSeeker,
		JobStatus,
		--CASE WHEN JobStatusSeeker = 'C' AND ISNULL(TD.IsApproved,'N') = 'Y' THEN 'E' ELSE 'D' END AS 'CompletionStatus'
		CASE WHEN JobStatusSeeker = 'C' THEN 'E' ELSE 'D' END AS 'CompletionStatus',
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS 'JobPosterProfile',
		ISNULL(UPS.ProfilePic,'/Content/images/user.png') AS 'JobSeekerProfile',
		ISNULL(J.GigSubscriptionId,0) AS GigSubscriptionId		
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.UserId
	LEFT JOIN Users US ON US.UserId = J.JobSeekerId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN UserProfile UPS ON UPS.UserId = US.UserId
	LEFT JOIN #JobCompletedPoster D ON D.UserId = J.UserId
	LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
	LEFT JOIN Transactiondetail TD ON TD.JobId = JB.JobId AND TransactionType = 'A'
	WHERE J.UserId = @UserId AND (JobStatus = @JobStatus OR (JobStatus = 'A' AND JobStatusSeeker = 'C')) 
	AND J.IsActive = 'Y'

	UNION ALL

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(US.FullName,'@'+US.UserName) AS 'PosterFullName',
		ISNULL(UPS.ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS 'BidUserProfilePic',
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(JB.BidAmount,0) AS BidAmount,		
		J.JobId,
		J.UserId AS 'JobPosterId',
		ISNULL(J.JobSeekerId,0) AS 'JobSeekerId',
		'S' AS UserRole,
		COALESCE(U.FullName,'@'+U.UserName) AS 'SeekerFullName',
		JobStatusSeeker,
		JobStatus,
		'E' AS 'CompletionStatus',
		ISNULL(UPS.ProfilePic,'/Content/images/user.png') AS 'JobPosterProfile',
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS 'JobSeekerProfile',
		ISNULL(J.GigSubscriptionId,0) AS GigSubscriptionId
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.JobSeekerId
	LEFT JOIN Users US ON US.UserId = J.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN UserProfile UPS ON UPS.UserId = US.UserId
	LEFT JOIN #JobCompletedPoster D ON D.UserId = J.UserId
	LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
	WHERE ISNULL(J.JobSeekerId,0) = @UserId AND (JobStatusSeeker = @JobStatus OR (JobStatus = 'A' AND JobStatusSeeker = 'C'))
	AND J.IsActive = 'Y'
		
	DROP TABLE #JobCompletedPoster
END
ELSE IF @JobStatus = 'B' --Bid On
BEGIN

	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPosterBid
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(U.FullName,'@'+U.UserName) AS 'PosterFullName',
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
		ISNULL(JB.BidAmount,0) AS BidAmount,		
		J.JobId,
		J.UserId AS 'JobPosterId',
		ISNULL(J.JobSeekerId,0) AS 'JobSeekerId',
		'S' AS UserRole,
		ISNULL(COALESCE(US.FullName,'@'+US.UserName),'') AS 'SeekerFullName',
		ISNULL(JB.JobBiddingId,0) AS JobBiddingId,
		ISNULL(JB.IsPending,'N') AS IsPending
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.UserId
	INNER JOIN JobBidding JB ON JB.JobId = J.JobId
	INNER JOIN Users US ON US.UserId = JB.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedPosterBid D ON D.UserId = J.UserId	
	WHERE JB.UserId = @UserId AND (JobStatus = @JobStatus) AND J.IsActive = 'Y' AND JB.IsActive = 'Y'

	--UNION ALL

	--SELECT 
	--	J.JobTitle,
	--	J.BudgetASP,
	--	J.Commission,
	--	J.TotalBudget,
	--	J.JobDescription,	
	--	CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	--	COALESCE(US.FullName,'@'+US.UserName) AS 'PosterFullName',
	--	ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
	--	ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
	--	ISNULL(JB.BidAmount,0) AS BidAmount,		
	--	J.JobId,
	--	J.UserId AS 'JobPosterId',
	--	ISNULL(J.JobSeekerId,0) AS 'JobSeekerId',
	--	'S' AS UserRole,
	--	COALESCE(U.FullName,'@'+U.UserName) AS 'SeekerFullName'
	--FROM Job J
	--INNER JOIN Users U ON U.UserId = J.JobSeekerId
	--LEFT JOIN Users US ON US.UserId = J.UserId
	--LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	--LEFT JOIN #JobCompletedPoster D ON D.UserId = J.UserId
	--LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
	--WHERE ISNULL(J.JobSeekerId,0) = @UserId AND (JobStatusSeeker = @JobStatus)
	--AND J.IsActive = 'Y'
		
	DROP TABLE #JobCompletedPosterBid
END
ELSE IF @JobStatus = 'R' --Review
BEGIN

	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedReview
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT 
		J.JobTitle,
		J.BudgetASP,
		J.Commission,
		J.TotalBudget,
		J.JobDescription,	
		CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
		COALESCE(U.FullName,'@'+U.UserName) AS 'PosterFullName',
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		ISNULL(D.TotalJobs,0) AS 'JobsCompleted',				
		J.JobId,
		J.UserId AS 'JobPosterId',		
		'P' AS UserRole,		
		J.CreatedDate			
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.UserId	
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedReview D ON D.UserId = J.UserId
	LEFT JOIN SocialMediaShare SM ON SM.JobId = J.JobId	
	WHERE J.UserId = @UserId AND (JobStatus = @JobStatus) AND J.IsActive = 'N' 
		
	DROP TABLE #JobCompletedReview
END


END
GO



