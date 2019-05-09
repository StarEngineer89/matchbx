--Created by    :	Sanu Mohan P
--Created Date  :	29-06-2018
--Purpose       :	Load job details for edit

--EXEC spLoadJob 382

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadJob')
DROP procedure spLoadJob
GO
CREATE PROCEDURE [spLoadJob]
(	 
	@JobId int	
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
FROM Job WHERE JobStatus = 'C' AND IsActive = 'Y' GROUP BY UserId

SELECT COUNT(JobBiddingId) AS 'ActiveBids',JobId into #JobBidding FROM JobBidding WHERE IsActive='Y' GROUP BY JobId

SELECT 
	J.JobId,
	J.JobCategoryId,
	J.JobTitle,
	J.JobDescription,
	J.BudgetASP,	
	J.Commission,
	J.TotalBudget,
	J.JobCompletionDate,
	CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	J.CreatedDate,
	DATEDIFF(d,J.CreatedDate,getdate()) AS PostedDays,
	CONVERT(nvarchar(15),COALESCE(J.ModifiedDate,J.CreatedDate),106) AS 'LastEdited',
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,
	UP.ProfilePic,
	JC.TotalJobs AS 'JobsCompleted',
	J.JobReferanceId,
	JR.Category,
	J.UserId,
	J.JobStatus,
	J.BudgetASP AS 'BudgetASPString',
	CASE WHEN DATEDIFF(HOUR,DATEADD(d,1,J.JobCompletionDate),GETDATE()) > 0 THEN 'Y' ELSE 'N' END AS IsExpired,
	JB.ActiveBids
FROM Job J 
INNER JOIN Users U ON U.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
INNER JOIN JobCategory JR ON JR.JobCategoryId = J.JobCategoryId
LEFT JOIN #JobCompletedPoster JC ON JC.UserId = J.UserId
LEFT JOIN #JobBidding JB ON JB.JobId = J.JobId
WHERE J.JobId = @JobId AND (J.IsActive = 'Y' OR (J.IsActive = 'N' AND J.JobStatus = 'R'))

drop table #JobBidding
		
END
GO



