--Created by    :	Jomon Joseph
--Created Date  :	22-02-2019
--Purpose       :	To get gig details for Dashboard

--EXEC spGetDashboardJobsBid 60,'2019-02-28 18:55:23.673'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetDashboardJobsBid')
DROP procedure spGetDashboardJobsBid
GO
CREATE PROCEDURE [spGetDashboardJobsBid]
(	
	@UserId int,
	@CurrentDate DATETIME
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

SELECT 
	J.JobId,
	JB.JobBiddingId,
	J.JobTitle,
	J.JobDescription,
	J.JobCompletionDate,
	CONVERT(NVARCHAR(20),J.JobCompletionDate,106) AS [JobCompletionDateDisplay],
	J.BudgetASP,
	J.Commission,
	J.TotalBudget,
	COALESCE(U.FullName,'@'+U.UserName) AS PosterFullName,	
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
	COALESCE(US.FullName,'@'+US.UserName) AS SeekerFullName,	
	ISNULL(UPS.ProfilePic,'/Content/images/user.png') AS SeekerProfilePic,
	ISNULL(JCP.TotalJobs,0) AS [JobsCompleted],
	J.UserId AS [JobPosterId],
	JB.BidAmount,
	JB.BidMessage,
	J.JobStatus,
	J.JobStatusSeeker,
	J.IsActive,
	ISNULL(JB.IsPending,'N') AS IsPending,
	ISNULL(TD.TransactionDetailId,0) AS TransactionDetailId,
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
	CASE WHEN LEN(JB.BidMessage) > 50 THEN SUBSTRING(JB.BidMessage,0,50) + '...' ELSE JB.BidMessage END AS 'BidMessageDisplay',
	CASE 
		WHEN J.JobStatus = 'B' AND JB.IsAccepted = 'N' AND ISNULL(JB.IsPending,'N') = 'N' THEN 'Bid'
		WHEN J.JobStatus = 'B' AND JB.IsAccepted = 'N' AND ISNULL(JB.IsPending,'N') = 'Y' THEN 'Pending Payment Confirmation'
		WHEN J.JobStatus = 'A' AND J.JobStatusSeeker = 'A' THEN 'Job in Progress'
		WHEN J.JobStatus = 'A' AND J.JobStatusSeeker = 'C' THEN 'Pending Client Review'
		WHEN J.JobStatus = 'C' AND J.JobStatusSeeker = 'C' AND ISNULL(TD.TransactionDetailId,0) = 0 THEN 'Payment Initiated'
		WHEN J.JobStatus = 'C' AND J.JobStatusSeeker = 'C' AND ISNULL(TD.TransactionDetailId,0) <> 0 THEN 'Job Completed'
	END AS [AllJobStatus]	
FROM JobBidding JB
INNER JOIN Job J ON J.JobId = JB.JobId 
INNER JOIN Users U ON U.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
INNER JOIN Users US ON US.UserId = JB.UserId
LEFT JOIN UserProfile UPS ON UPS.UserId = US.UserId
LEFT JOIN #JobCompletedPoster JCP ON JCP.UserId = J.UserId
LEFT JOIN TransactionDetail TD ON TD.JobId = J.JobId AND TransactionType = 'S' AND ProcessType = 'C' AND IsApproved = 'Y'
WHERE JB.UserId = @UserId AND J.IsActive = 'Y' AND JB.IsActive = 'Y'

DROP TABLE #JobCompletedPoster	
	
END
GO






