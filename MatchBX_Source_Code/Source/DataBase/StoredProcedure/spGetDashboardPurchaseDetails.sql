--Created by    :	Jomon Joseph
--Created Date  :	22-02-2019
--Purpose       :	To get gig details for Dashboard

--EXEC spGetDashboardPurchaseDetails 0,2,'0','0',0,15000,'N'



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetDashboardPurchaseDetails')
DROP procedure spGetDashboardPurchaseDetails
GO
CREATE PROCEDURE [spGetDashboardPurchaseDetails]
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
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId
	
	SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #JobCompletedGig
	FROM Job J 
	INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
	WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId

	SELECT  G.Gigid, TrendingTagsIdList= STUFF((
	SELECT ', ' +  REPLACE(a.Description,'#','')
	FROM TrendingTags AS a
	INNER JOIN GigTrendingTagsMapping AS b
	ON a.TrendingTagsId = b.TrendingTagsId
	WHERE B.GigId = G.GigId
	FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
	INTO #TrendingTags
	FROM Gig AS G;
	
    --select a.*, b.GigSubscribed into #tempGigSubscription from GigSubscription a inner join  ( select c.GigId, COUNT(c.GigId) as GigSubscribed, max(c.GigSubscriptionId) as GigSubscriptionId
	--from GigSubscription as c group by c.GigId,c.Jobposterid  )b 
    --on a.GigSubscriptionId = b.GigSubscriptionId and a.GigSubscriptionId = b.GigSubscriptionId

	select * into #tempTransactionDetail from TransactionDetail where TransactionType='D'	
	--select * from #tempGigSubscription

	SELECT DISTINCT
	    G.GigId,
		GS.GigSubscriptionId,
		ISNULL(J.JobId,0) as JobId,
		G.GigTitle,
		G.BudgetASP,
		G.Commission,
		G.TotalBudget,
		G.GigDescription,	
		G.GigDuration,	
		G.GigDuration AS GigDurationString,	
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
		ISNULL(S.TotalJobs,0) AS 'JobsCompleted',
		--ISNULL(GCS.TotalJobs,0) AS 'GigsCompleted',	
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
		
		G.UserId,	
		G.GigStatus,
		CASE WHEN LEN(G.GigDescription) > 200 THEN SUBSTRING(G.GigDescription,0,200) + '...' ELSE G.GigDescription END AS 'GigDescriptionDisplay',
		ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,
		G.IsGigEnabled,
		G.JobCategoryId,
		
		GS.Title ,
		GS.GigSubscriptionStatus,
		CASE WHEN LEN(GS.Description) > 200 THEN SUBSTRING(GS.Description,0,200) + '...' ELSE GS.Description END AS 'GigSubscriptionDisplay',
		GS.Description as  [Description],
		--GS.GigSubscribed,
		ISNULL(U.VerifiedPartner,'N') as VerifiedPartner,
	
		ISNULL(T.TransactionDetailId,0) as TransactionDetailId,T.IsApproved,T.TransactionType,
		ISNULL(TD.TokenAddress,'') AS TokenAddress,
		COALESCE(UPP.FullName,'@'+UPP.UserName) AS PosterFullName,	
		ISNULL(USP.ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
		J.JobStatus,
		J.JobStatusSeeker,
		JCG.TotalJobs AS 'GigSubscribed'	
	INTO #temp
	FROM Gig G	
	
	INNER JOIN GigSubscription as GS on G.GigId=GS.GigId
	LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId
	LEFT JOIN GigSkillsMapping GSM ON GSM.GigId = G.GigId
	LEFT JOIN #TrendingTags TT ON TT.GigId = G.GigId
	INNER JOIN Users U ON U.UserId = G.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN #JobCompletedSeeker S ON S.JobSeekerId = G.UserId
	LEFT JOIN TokenDistribution TD ON ISNULL(TD.GigSubscriptionId,0) = GS.GigSubscriptionId
	LEFT JOIN Users UPP ON UPP.UserId = GS.JobPosterId
	LEFT JOIN UserProfile USP ON USP.UserId = UPP.UserId
	
	left join Job as J on J.GigSubscriptionId=GS.GigSubscriptionId
    left join #tempTransactionDetail as T on J.JobId=T.JobId
    LEFT JOIN #JobCompletedGig JCG ON JCG.JobSeekerId = G.UserId AND G.GigId = JCG.GigId
	
	WHERE (G.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
	AND (G.UserId <> @UserId OR (@UserId = 0))
	AND (GTM.TrendingTagsId IN (SELECT CAST(Item AS integer) FROM SplitString(@TrendingTagsIdList,',')) OR @TrendingTagsIdList = '0')
	AND (GSM.SkillsId IN (SELECT CAST(Item AS integer) FROM SplitString(@SkillsList,',')) OR @SkillsList = '0')
	AND G.BudgetASP BETWEEN @MinBudget AND @MaxBudget
	AND G.IsActive = 'Y' AND G.IsGigEnabled = 'Y' AND G.GigStatus = 'P'
	AND GS.JobPosterId=@UserId OR (@UserId = 0)

	IF @SortBy = 'H'
	BEGIN
		SELECT * FROM #temp   ORDER BY BudgetASP DESC	  
	END
	ELSE
	BEGIN
		SELECT * FROM #temp  ORDER BY BudgetASP ASC
	END

	drop table #TrendingTags

	drop table #temp	
	--drop table #tempGigSubscription
	drop table #tempTransactionDetail 
	
	
	
END
GO






