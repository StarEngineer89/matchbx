--Created by    :	Jomon Joseph
--Created Date  :	22-02-2019
--Purpose       :	To get gig details for Dashboard

--EXEC spGetDashboardJobs 2,'2019-02-28 12:20:27.453'



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetDashboardJobs')
DROP procedure spGetDashboardJobs
GO
CREATE PROCEDURE [spGetDashboardJobs]
(	
	@UserId int,
	@CurrentDate DATETIME
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

SELECT JobId,COUNT(JobId) AS TotalJobs INTO #ActiveBids FROM JobBidding 
WHERE IsActive = 'Y' AND IsAccepted = 'N' AND IsPending = 'N' GROUP BY JobId

SELECT JobId,COUNT(JobId) AS TotalJobs INTO #DeclinedBids FROM JobBidding 
WHERE IsActive = 'N' AND IsAccepted = 'N' AND IsPending = 'N' GROUP BY JobId

SELECT 
	J.JobId,
	U.UserId AS JobPosterId,
	COALESCE(U.FullName,'@'+U.UserName) AS PosterFullName,
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
	J.JobTitle,
	J.JobCompletionDate,
	CONVERT(NVARCHAR(60),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	BudgetASP,
	Commission,
	TotalBudget,
	J.JobDescription,
	ISNULL(JCP.TotalJobs,0) AS 'JobsCompleted',
	J.JobStatus,
	J.JobStatusSeeker,
	J.IsActive,
	CASE WHEN J.JobStatus IN ('P','B') THEN
		CASE WHEN DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),@CurrentDate) > 0 THEN 'Y' ELSE 'N' END 
	ELSE
		CASE WHEN DATEDIFF(HOUR,J.JobCompletionDate,@CurrentDate) > 0 THEN 'Y' ELSE 'N' END END
	 AS [IsExpired],
	CASE WHEN J.JobStatus IN ('P','B') THEN	
	CASE WHEN DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),@CurrentDate) > 0 THEN 'Job Expired' ELSE
		CASE WHEN  (DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),@CurrentDate) * -1)/24 = 0 
			 THEN  CONVERT(NVARCHAR(10),(DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),@CurrentDate) * -1)%24) + ' Hours'
			 ELSE CONVERT(NVARCHAR(10),(DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),@CurrentDate) * -1)/24) + ' Days, ' +
			 CONVERT(NVARCHAR(10),(DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),@CurrentDate) * -1)%24) + ' Hours' END END
	ELSE	
	CASE WHEN DATEDIFF(HOUR,J.JobCompletionDate,@CurrentDate) > 0 THEN 'Job Expired' ELSE
		CASE WHEN  (DATEDIFF(HOUR,J.JobCompletionDate,@CurrentDate) * -1)/24 = 0 
			 THEN  CONVERT(NVARCHAR(10),(DATEDIFF(HOUR,J.JobCompletionDate,@CurrentDate) * -1)%24) + ' Hours'
			 ELSE CONVERT(NVARCHAR(10),(DATEDIFF(HOUR,J.JobCompletionDate,@CurrentDate) * -1)/24) + ' Days, ' +
			 CONVERT(NVARCHAR(10),(DATEDIFF(HOUR,J.JobCompletionDate,@CurrentDate) * -1)%24) + ' Hours' END
	END END AS [TimeRemaining],
	COALESCE(COALESCE(US.FullName,USB.FullName),'@'+COALESCE(US.UserName,USB.UserName)) AS SeekerFullName,
	COALESCE(ISNULL(USP.ProfilePic,'/Content/images/user.png'),ISNULL(USBP.ProfilePic,'/Content/images/user.png')) AS SeekerProfilePic,
	COALESCE(JB.BidAmount,JBS.BidAmount) AS BidAmount,
	COALESCE(JB.BidMessage,JBS.BidMessage) AS BidMessage,
	ISNULL(COALESCE(JBS.UserId,JB.UserId),0) AS SeekerId,
	ISNULL(JBS.JobBiddingId,0) AS JobBiddingId, 
	CASE 
		WHEN J.JobStatus = 'R'THEN 'Pending Admin Approval'
		WHEN J.JobStatus IN ('P','B') AND ISNULL(JB.JobBiddingId,0) = 0 THEN 'Posted'
		WHEN J.JobStatus = 'B' AND ISNULL(JB.JobBiddingId,0) <> 0 THEN 'Pending Payment Confirmation'
		WHEN J.JobStatus = 'A' AND J.JobStatusSeeker = 'A' THEN 'Job in Progress'
		WHEN J.JobStatus = 'A' AND J.JobStatusSeeker = 'C' THEN 'Job Pending Review'	
		WHEN J.JobStatus = 'C' AND J.JobStatusSeeker = 'C' THEN 'Job Completed'	
	END AS [AllJobStaus],
	ISNULL(AB.TotalJobs,0) AS ActiveBids,
	ISNULL(DB.TotalJobs,0) AS DeclinedBids,
	ISNULL(JB.JobBiddingId,0) AS 'PendingBid'			  
FROM Job J
INNER JOIN Users U ON U.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
LEFT JOIN #JobCompletedPoster JCP ON JCP.UserId = J.UserId
LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND IsPending = 'Y' AND IsAccepted = 'N'
LEFT JOIN JobBidding JBS ON JBS.JobId = J.JobId AND JBS.IsPending = 'Y' AND JBS.IsAccepted = 'Y'
LEFT JOIN Users US ON US.UserId = JB.UserId
LEFT JOIN UserProfile USP ON USP.UserId = US.UserId
LEFT JOIN Users USB ON USB.UserId = JBS.UserId
LEFT JOIN UserProfile USBP ON USBP.UserId = USB.UserId
LEFT JOIN #ActiveBids AB ON AB.JobId = J.JobId
LEFT JOIN #DeclinedBids DB ON DB.JobId = J.JobId
WHERE J.UserId = @UserId AND (J.IsActive	= 'Y' OR (J.IsActive = 'N' AND J.JobStatus = 'R'))
AND ISNULL(J.GigSubscriptionId,0) = 0

DROP TABLE #JobCompletedPoster	
	
	
END
GO






