--Created by    :	Sanu Mohan P
--Created Date  :	08-01-2019
--Purpose       :	Load gig details for edit

--EXEC spLoadGig 120

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadGig')
DROP procedure spLoadGig
GO
CREATE PROCEDURE [spLoadGig]
(	 
	@GigId int	
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
FROM Job WHERE JobStatusSeeker = 'C' AND JobStatus = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId

SELECT COUNT(JobId) AS 'TotalJobs',J.JobSeekerId AS 'UserId',GigId INTO #GigCompletedSeeker
FROM Job J
INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY J.JobSeekerId,GigId

select  Count(*) as SubscriedGigs,GigId  into #SubscriptionDetails from GigSubscription  where GigSubscriptionStatus='S' Group by GigId

select  Count(*) as ActiveGigs,GigId  into #ActiveOrderDetails from GigSubscription GS
left join Job J ON ISNULL(J.GigSubscriptionId,0) = GS.GigSubscriptionId
where GigSubscriptionStatus in ('A','J') AND ISNULL(J.JobStatus,'') <> 'C' Group by GigId

SELECT 
	G.GigId,
	G.JobCategoryId,
	G.GigTitle,
	G.GigDescription,
	G.BudgetASP,	
	G.Commission,
	G.TotalBudget,
	G.GigDuration,	
	G.CreatedDate,	
	CAST(DATEDIFF(d,G.CreatedDate,getdate()) AS Int) AS PostedDays,	
	CONVERT(nvarchar(15),COALESCE(G.ModifiedDate,G.CreatedDate),106) AS 'LastEdited',
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,
	UP.ProfilePic,	
	--J.JobReferanceId,
	JR.Category,
	G.UserId,
	G.GigStatus,
	ISNULL(JC.TotalJobs,0) AS 'JobsCompleted',
	ISNULL(GC.TotalJobs,0) AS 'GigsCompleted',
	ISNULL(SD.SubscriedGigs,0) as SubscriedGigs, 
	ISNULL( AD.ActiveGigs,0) as ActiveGigs,		
	G.Deliverables	
FROM Gig G 
INNER JOIN Users U ON U.UserId = G.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
INNER JOIN JobCategory JR ON JR.JobCategoryId = G.JobCategoryId
LEFT JOIN #JobCompletedSeeker JC ON JC.JobSeekerId = G.UserId
LEFT JOIN #GigCompletedSeeker GC ON GC.UserId = G.UserId AND GC.GigId = G.GigId
LEFT JOIN #SubscriptionDetails SD on SD.GigId=G.GigId
LEFT JOIN  #ActiveOrderDetails AD on AD.GigId=G.GigId
WHERE G.GigId = @GigId AND (G.IsActive = 'Y' OR (G.IsActive = 'N' AND G.GigStatus = 'R'))

drop table #JobCompletedSeeker
drop table #GigCompletedSeeker
drop table #SubscriptionDetails
drop table #ActiveOrderDetails
		
END
GO



