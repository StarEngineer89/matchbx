--Created by    :	Sanu Mohan P
--Created Date  :	25-06-2018
--Purpose       :	To get job details for landing page

--EXEC spGetJobDetails 0,0,'0','0',0,15000,'N',0



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetJobDetails')
DROP procedure spGetJobDetails
GO
CREATE PROCEDURE [spGetJobDetails]
(	 
	@JobCategoryId int,
	@UserId int,
	@TrendingTagsIdList nvarchar(Max),
	@SkillsList nvarchar(Max),
	@MinBudget decimal(18,3),
	@MaxBudget decimal(18,3),
	@SortBy char(1),
	@JobSeekerId int 
)
AS
BEGIN

IF @MaxBudget = 0
BEGIN
	SET @MaxBudget = 10000000
END


SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
FROM Job WHERE JobStatus = 'C' AND IsActive = 'Y' GROUP BY UserId

SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
FROM Job WHERE JobStatusSeeker = 'C' AND IsActive = 'Y' AND JobSeekerId = @JobSeekerId GROUP BY JobSeekerId

SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobListPoster
FROM Job WHERE IsActive = 'Y' GROUP BY UserId

SELECT JobId into #PendingJobs FROM TransactionDetail WHERE ProcessType = 'D' GROUP BY JobId

SELECT  j.jobid, TrendingTagsIdList= STUFF((
    SELECT ', ' +  REPLACE(a.Description,'#','')
    FROM TrendingTags AS a
    INNER JOIN JobTrendingTagsMapping AS b
    ON a.TrendingTagsId = b.TrendingTagsId
    WHERE b.JobId = j.JobId
    FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
INTO #TrendingTags
FROM job AS j;

SELECT DISTINCT
	J.JobTitle,
	J.BudgetASP,
	J.Commission,
	J.TotalBudget,
	J.JobDescription,	
	CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,
	--COALESCE(S.TotalJobs,D.TotalJobs) AS 'JobsCompleted',
	ISNULL(D.TotalJobs,0) AS 'JobsCompleted',
	ISNULL(S.TotalJobs,0) AS 'JobsCompletedSeeker',
	ISNULL(P.TotalJobs,0) AS 'JobsListedPoster',
	ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
	J.JobId,
	J.UserId,
	ISNULL(JB.BidAmount,0) AS BidAmount,
	J.JobStatus,
	CASE WHEN LEN(J.JobDescription) > 200 THEN SUBSTRING(J.JobDescription,0,200) + '...' ELSE J.JobDescription END AS 'JobDescriptionDisplay',
	ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,
	ISNULL(JBT.JobId,0) AS PendingJobId	 	
INTO #temp
FROM Job J
INNER JOIN Users U ON U.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
LEFT JOIN #JobCompletedPoster D ON D.UserId = J.UserId
LEFT JOIN #JobListPoster P ON P.UserId = J.UserId
LEFT JOIN #JobCompletedSeeker S ON S.JobSeekerId = J.JobSeekerId
LEFT JOIN JobTrendingTagsMapping JTM ON JTM.JobId = J.JobId
LEFT JOIN JobSkillsMapping JSM ON JSM.JobId = J.JobId
LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
LEFT JOIN #PendingJobs JBT ON JBT.JobId = J.JobId 
LEFT JOIN #TrendingTags TT ON TT.JobId = J.JobId
WHERE (J.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
AND (J.UserId = @UserId OR (@UserId = 0))
AND (JTM.TrendingTagsId IN (SELECT CAST(Item AS integer) FROM SplitString(@TrendingTagsIdList,',')) OR @TrendingTagsIdList = '0')
AND (JSM.SkillsId IN (SELECT CAST(Item AS integer) FROM SplitString(@SkillsList,',')) OR @SkillsList = '0')
AND J.BudgetASP BETWEEN @MinBudget AND @MaxBudget
AND (J.JobSeekerId = @JobSeekerId AND JobStatusSeeker = 'C' OR (@JobSeekerId=0))
AND J.IsActive = 'Y' and DATEADD(d,1,J.JobCompletionDate) > GETDATE()

IF @SortBy = 'B'
BEGIN
	IF(@UserId <> 0 OR @JobSeekerId <> 0)
	BEGIN
		
		SELECT * FROM #temp ORDER BY BudgetASP DESC
	END
	ELSE
	BEGIN
		
		SELECT * FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY BudgetASP DESC
	END
END
ELSE
BEGIN
	IF(@UserId <> 0 OR @JobSeekerId <> 0)
	BEGIN
		SELECT * FROM #temp ORDER BY JobId DESC
	END
	ELSE
	BEGIN
		SELECT * FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY JobId DESC
	END
END

drop table #TrendingTags
drop table #JobCompletedPoster
drop table #JobCompletedSeeker
drop table #JobListPoster
drop table #temp
		
END
GO



