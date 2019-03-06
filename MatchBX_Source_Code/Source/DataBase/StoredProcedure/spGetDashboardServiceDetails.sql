--Created by    :	Jomon Joseph
--Created Date  :	22-02-2019
--Purpose       :	To get gig details for Dashboard

--EXEC spGetDashboardServiceDetails 0,0,'0','0',0,15000,'N'



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetDashboardServiceDetails')
DROP procedure spGetDashboardServiceDetails
GO
CREATE PROCEDURE [spGetDashboardServiceDetails]
(	 
	@JobCategoryId int,
	@UserId int,
	@TrendingTagsIdList nvarchar(Max),
	@SkillsList nvarchar(Max),
	@MinBudget decimal(18,3),
	@MaxBudget decimal(18,3),
	@SortBy char(1)	
)
AS
BEGIN

IF @MaxBudget = 0
BEGIN
	SET @MaxBudget = 10000000
END		
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #GigCompletedSeeker
	FROM Job J 
	INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
	WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId

	SELECT  G.Gigid, TrendingTagsIdList= STUFF((
	SELECT ', ' +  REPLACE(a.Description,'#','')
	FROM TrendingTags AS a
	INNER JOIN GigTrendingTagsMapping AS b
	ON a.TrendingTagsId = b.TrendingTagsId
	WHERE B.GigId = G.GigId
	FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
	INTO #TrendingTags
	FROM Gig AS G;

	select  Count(*) as SubscriedGigs,GigId  into #SubscriptionDetails from GigSubscription   where GigSubscriptionStatus='S' Group by GigId

	select  Count(*) as ActiveGigs,GigId  into #ActiveOrderDetails from GigSubscription GS
	left join Job J ON ISNULL(J.GigSubscriptionId,0) = GS.GigSubscriptionId
	where GigSubscriptionStatus in ('A','J') AND ISNULL(J.JobStatus,'') <> 'C' Group by GigId

	select count(*) as CompletedGigs,G.GigId Into #GigCompletedDetails from Job as J inner join 
	GigSubscription as G on J.GigSubscriptionId=G.GigSubscriptionId where Isnull(J.GigSubscriptionId,0)>0  and J.JobStatus='C' Group by G.GigId

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
		ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,
		G.IsGigEnabled,
		G.JobCategoryId,
			ISNULL(SD.SubscriedGigs,0) as SubscriedGigs, 
			ISNULL( AD.ActiveGigs,0) as ActiveGigs,	
			ISNULL(GCD.CompletedGigs,0) as CompletedGigs
	INTO #temp
	FROM Gig G
	INNER JOIN Users U ON U.UserId = G.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedSeeker S ON S.JobSeekerId = G.UserId
	LEFT JOIN #GigCompletedSeeker GCS ON GCS.JobSeekerId = G.UserId AND G.GigId = GCS.GigId
	LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId
	LEFT JOIN GigSkillsMapping GSM ON GSM.GigId = G.GigId
	LEFT JOIN #TrendingTags TT ON TT.GigId = G.GigId
	LEFT JOIN #SubscriptionDetails SD on SD.GigId=G.GigId
	LEFT JOIN  #ActiveOrderDetails AD on AD.GigId=G.GigId
	LEFT JOIN  #GigCompletedDetails GCD on GCD.GigId=G.GigId
	WHERE (G.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
	AND (G.UserId = @UserId OR (@UserId = 0))
	AND (GTM.TrendingTagsId IN (SELECT CAST(Item AS integer) FROM SplitString(@TrendingTagsIdList,',')) OR @TrendingTagsIdList = '0')
	AND (GSM.SkillsId IN (SELECT CAST(Item AS integer) FROM SplitString(@SkillsList,',')) OR @SkillsList = '0')
	AND G.BudgetASP BETWEEN @MinBudget AND @MaxBudget
	AND (G.IsActive	= 'Y' OR (G.IsActive = 'N' AND G.GigStatus = 'R') OR G.GigStatus = 'P') --AND G.IsGigEnabled = 'Y' 

	IF @SortBy = 'H'
	BEGIN
		SELECT * FROM #temp ORDER BY BudgetASP DESC	
	END
	ELSE
	BEGIN
		SELECT * FROM #temp ORDER BY BudgetASP ASC
	END

	drop table #TrendingTags
	drop table #JobCompletedSeeker
	drop table #GigCompletedSeeker
	drop table #temp	
	Drop table  #SubscriptionDetails
	Drop table  #ActiveOrderDetails
	Drop table  #GigCompletedDetails
END
GO






