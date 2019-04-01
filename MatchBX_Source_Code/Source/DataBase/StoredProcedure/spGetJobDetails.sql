--Created by    :	Sanu Mohan P
--Created Date  :	25-06-2018
--Purpose       :	To get job details for landing page

--EXEC spGetJobDetails 0,0,'0','0',0,0,'N',0,'B'


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
	@JobSeekerId int,
	@FromPage char(1) 
)
AS
BEGIN

CREATE TABLE #Result (
[JobId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[JobTitle] [nvarchar](MAX) NOT NULL,
[BudgetASP] [decimal](18,3),
[Commission] [decimal](18,3),
[TotalBudget] [decimal](18,3),
[JobDescription] [nvarchar](max),
JobCompletionDateDisplay [nvarchar](100),
FullName [nvarchar](100),
JobsCompleted [int],
JobsCompletedSeeker [int],
JobsListedPoster [int],
GigsCompleted [int],
ProfilePic [nvarchar](max),
BidAmount decimal(18,2),
JobStatus [nvarchar](2),
JobDescriptionDisplay [nvarchar](max),
TrendingTagsIdList [nvarchar](max),
PendingJobId [int],
[CreatedDate] [datetime],
CssClass [nvarchar](MAX),
[Type] [nvarchar](2),
RedirectUrl [nvarchar](MAX),
VerifiedPartner CHAR(1)
)
DECLARE @BaseCss varchar(80)='col-md-12 home_user_box_1_bg bg_color_comen clearfix verified_partner_bg'
IF(@FromPage='')
  BEGIN
  SET @FromPage='J'
  END
IF(@FromPage ='J' OR @FromPage ='B')
BEGIN
       IF @MaxBudget = 0
       BEGIN
              SET @MaxBudget = 10000000
       END


       SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
       FROM Job WHERE JobStatus = 'C' AND IsActive = 'Y' AND ISNULL(GigSubscriptionId,0) = 0 GROUP BY UserId

       SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeeker
       FROM Job WHERE JobStatusSeeker = 'C' AND IsActive = 'Y' AND JobSeekerId = @JobSeekerId GROUP BY JobSeekerId

       SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobListPoster
       FROM Job WHERE IsActive = 'Y' AND ISNULL(GigSubscriptionId,0) = 0 GROUP BY UserId

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
           J.JobId,
              J.UserId,
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
              0 as GigsCompleted,
              ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
              ISNULL(JB.BidAmount,0) AS BidAmount,
              J.JobStatus,
              CASE WHEN LEN(J.JobDescription) > 200 THEN SUBSTRING(J.JobDescription,0,200) + '...' ELSE J.JobDescription END AS 'JobDescriptionDisplay',
              ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,
              ISNULL(JBT.JobId,0) AS PendingJobId      ,
              J.CreatedDate, @BaseCss as CssClass, --CONCAT(@BaseCss,' ','divjob_box') as     CssClass,
              'J' as [Type],
              CONCAT('/Jobs/Details/',  J.JobId) as RedirectUrl,
              U.VerifiedPartner
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
       AND ISNULL(J.GigSubscriptionId,0) = 0

       IF @SortBy = 'B'
       BEGIN
              IF(@UserId <> 0 OR @JobSeekerId <> 0)
              BEGIN
                     
              INSERT INTO #Result  SELECT * FROM #temp ORDER BY BudgetASP DESC
              END
              ELSE
              BEGIN
                     
              INSERT INTO #Result SELECT * FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY BudgetASP DESC
              END
       END
       ELSE
       BEGIN
              IF(@UserId <> 0 OR @JobSeekerId <> 0)
              BEGIN
              INSERT INTO #Result SELECT * FROM #temp ORDER BY JobId DESC
              END
              ELSE
              BEGIN
              INSERT INTO #Result SELECT * FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY JobId DESC
              END
       END

       drop table #TrendingTags
       drop table #JobCompletedPoster
       drop table #JobCompletedSeeker
       drop table #JobListPoster
       drop table #temp
END
IF(@FromPage ='G' OR @FromPage ='B')
BEGIN
       IF @MaxBudget = 0
       BEGIN
              SET @MaxBudget = 10000000
       END           
       
       SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedSeekerCatgory
       FROM Job WHERE JobStatusSeeker = 'C' AND JobStatus = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId
       
       SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #GigCompletedSeekerCategory
       FROM Job J 
       INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
       WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId

       SELECT  G.Gigid, TrendingTagsIdList= STUFF((
       SELECT ', ' +  REPLACE(a.Description,'#','')
       FROM TrendingTags AS a
       INNER JOIN GigTrendingTagsMapping AS b
       ON a.TrendingTagsId = b.TrendingTagsId
       WHERE B.GigId = G.GigId
       FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
       INTO #TrendingTagsCategory
       FROM Gig AS G;
       
       SELECT DISTINCT
           G.GigId AS JobId,
              G.UserId,     
              G.GigTitle AS JobTitle,
              G.BudgetASP,
              G.Commission,
              G.TotalBudget,
              G.GigDescription AS JobDescription,      
              --G.GigDuration AS 'JobCompletionDate',  
              G.GigDuration AS 'JobCompletionDateDisplay',    
              COALESCE(U.FullName,'@'+U.UserName) AS FullName,       
              ISNULL(S.TotalJobs,0) AS 'JobsCompleted',
              0 as JobsCompletedSeeker,
              0 as JobsListedPoster,
              ISNULL(GCS.TotalJobs,0) AS 'GigsCompleted',     
              ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
              0 as BidAmount,
              G.GigStatus AS JobStatus,
              CASE WHEN LEN(G.GigDescription) > 200 THEN SUBSTRING(G.GigDescription,0,200) + '...' ELSE G.GigDescription END AS 'JobDescriptionDisplay',
              ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,              
              0 as PendingJobId ,
              G.CreatedDate,
              @BaseCss as CssClass, --CONCAT(@BaseCss,' ','divgig_box') as     CssClass,
              'G' as [Type],
              CONCAT('/Gigs/Details/', G.GigId ,'?subid=0') as RedirectUrl,
              U.VerifiedPartner
       INTO #tempCategory
       FROM Gig G
       INNER JOIN Users U ON U.UserId = G.UserId
       LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
       LEFT JOIN #JobCompletedSeekerCatgory S ON S.JobSeekerId = G.UserId
       LEFT JOIN #GigCompletedSeekerCategory GCS ON GCS.JobSeekerId = G.UserId AND G.GigId = GCS.GigId
       LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId
       LEFT JOIN GigSkillsMapping GSM ON GSM.GigId = G.GigId
       LEFT JOIN #TrendingTagsCategory TT ON TT.GigId = G.GigId
       WHERE (G.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
       AND (G.UserId = @UserId OR (@UserId = 0))
       AND (GTM.TrendingTagsId IN (SELECT CAST(Item AS integer) FROM SplitString(@TrendingTagsIdList,',')) OR @TrendingTagsIdList = '0')
       AND (GSM.SkillsId IN (SELECT CAST(Item AS integer) FROM SplitString(@SkillsList,',')) OR @SkillsList = '0')
       AND G.BudgetASP BETWEEN @MinBudget AND @MaxBudget
       AND G.IsActive = 'Y' AND G.IsGigEnabled = 'Y' AND G.GigStatus = 'P'



       IF @SortBy = 'H'
       BEGIN
       INSERT INTO #Result  SELECT * FROM #tempCategory ORDER BY BudgetASP DESC    
       END
       ELSE
       BEGIN
       INSERT INTO #Result  SELECT * FROM #tempCategory ORDER BY BudgetASP ASC
       END

       drop table #TrendingTagsCategory
       drop table #JobCompletedSeekerCatgory
       drop table #GigCompletedSeekerCategory
       drop table #tempCategory   
END    
   --  IF(@SortDate<>0)
         -- BEGIN
         --    select * from #Result where CreatedDate>convert(datetime,@SortDate,103)
         -- END
   --  ELSE
         --BEGIN
         IF @SortBy = 'H'
          BEGIN
           select ROW_NUMBER ( ) OVER (ORDER BY BudgetASP DESC) AS [Rownumber], * from #Result
		   
              --drop table #Result
          END
		 ELSE IF @SortBy = 'L'
          BEGIN
           select ROW_NUMBER ( ) OVER (ORDER BY BudgetASP ASC) AS [Rownumber], * from #Result
		  
              --drop table #Result
          END
          ELSE
          BEGIN
           select ROW_NUMBER ( ) OVER (ORDER BY createddate DESC) AS [Rownumber], * from #Result
		 
           --drop table #Result
          END
         drop table #Result
          --END

       
        
              --drop table #Result
       --IF(@FromPage ='J')
       -- BEGIN
       --     drop table #TrendingTags
       --     drop table #JobCompletedPoster
       --     drop table #JobCompletedSeeker
       --     drop table #JobListPoster
       --     drop table #temp
       --     PRINT 'J'
       --     select * from #Result
       --     drop table #Result
       -- END
       --ELSE IF(@FromPage ='G')
       -- BEGIN
       --     drop table #TrendingTagsCategory
       --     drop table #JobCompletedSeekerCatgory
       --     drop table #GigCompletedSeekerCategory
       --     drop table #tempCategory
       --     PRINT 'G'
       --     select * from #Result
       --     drop table #Result
       -- END
       -- ELSE IF(@FromPage ='B')
       -- BEGIN
       --    drop table #TrendingTags
       --     drop table #JobCompletedPoster
       --     drop table #JobCompletedSeeker
       --     drop table #JobListPoster
       --     drop table #temp
       --     drop table #TrendingTagsCategory
       --    drop table #JobCompletedSeekerCatgory
       --     drop table #GigCompletedSeekerCategory
       --     drop table #tempCategory
       --     PRINT 'B'
       --     select * from #Result
       --     drop table #Result
       -- END
END

