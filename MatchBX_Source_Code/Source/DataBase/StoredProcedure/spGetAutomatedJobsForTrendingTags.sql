--purpose: autosearch

--EXEC spGetAutomatedJobsForTrendingTags 0,0,'0','0',0,15000,'N',1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAutomatedJobsForTrendingTags')
DROP procedure spGetAutomatedJobsForTrendingTags
GO
CREATE PROCEDURE [spGetAutomatedJobsForTrendingTags]
(	 
	@searchText varchar(100),
	@FromPage char(1) 
)
AS
BEGIN
CREATE TABLE #Result1 (
[JobTitle] [nvarchar](30) NOT NULL,
[Type] [nvarchar](2)
)
IF(@FromPage='')
  BEGIN
  SET @FromPage='J'
  END
IF(@FromPage ='J' OR @FromPage ='B')
 BEGIN
 SELECT JobId into #PendingJobs FROM TransactionDetail WHERE ProcessType = 'D' GROUP BY JobId

SELECT  j.jobid, TrendingTagsIdList= STUFF((
    SELECT ', ' +  REPLACE(a.Description,'#','')
    FROM TrendingTags AS a
    INNER JOIN JobTrendingTagsMapping AS b
    ON a.TrendingTagsId = b.TrendingTagsId
    WHERE b.JobId = j.JobId
    FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
INTO #TrendingTagsAuto
FROM job AS j;



SELECT DISTINCT
    j.jobid,
	--REPLACE(J.JobTitle,' ','') as JobTitlesearch ,
	j.JobTitle,
	J.JobStatus,
		
	--REPLACE(TT.TrendingTagsIdList,' ','') as TrendingTagsIdListsearch ,
	ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,
	ISNULL(JBT.JobId,0) AS PendingJobId	 ,
	'J' as [Type]		
INTO #temp
FROM Job J
LEFT JOIN JobTrendingTagsMapping JTM ON JTM.JobId = J.JobId
LEFT JOIN JobSkillsMapping JSM ON JSM.JobId = J.JobId
LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
LEFT JOIN #TrendingTagsAuto TT ON TT.JobId = J.JobId
LEFT JOIN #PendingJobs JBT ON JBT.JobId = J.JobId 
WHERE 
 J.IsActive = 'Y' and DATEADD(d,1,J.JobCompletionDate) > GETDATE()

	if (@searchText = '')
		BEGIN
		INSERT INTO #Result1 
SELECT top 10 JobTitle,[Type] 
 FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY JobTitle DESC
		--SELECT distinct top 10 JobTitle,[Type] INTO #Result1   FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY JobTitle DESC
		END
	else
		BEGIN
			INSERT INTO #Result1 
SELECT top 10 JobTitle,[Type] 
		--SELECT distinct top 10 JobTitle,[Type]  INTO #Result1
		  FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 and 
		JobTitle  LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\'  
		or TrendingTagsIdList LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\' ORDER BY JobTitle DESC
		END
	drop table #TrendingTagsAuto
	drop table #temp
	--select * from #Result1
	--drop table #Result
		
 END

IF(@FromPage ='G' OR @FromPage ='B')
  BEGIN
  SELECT  G.GigId, TrendingTagsIdList= STUFF((
    SELECT ', ' +  REPLACE(a.Description,'#','')
    FROM TrendingTags AS a
    INNER JOIN GigTrendingTagsMapping AS b
    ON a.TrendingTagsId = b.TrendingTagsId
    WHERE b.GigId = G.GigId
    FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
INTO #TrendingTagsAuto1
FROM Gig AS G;



SELECT DISTINCT
	--REPLACE(J.JobTitle,' ','') as JobTitlesearch ,
	G.GigTitle ,
	G.GigStatus,
	G.GigId,	
	--REPLACE(TT.TrendingTagsIdList,' ','') as TrendingTagsIdListsearch ,
	ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList	,
	'G' as [Type]	
INTO #temp1
FROM Gig G
LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId
LEFT JOIN GigSkillsMapping GSM ON GSM.GigId = G.GigId
LEFT JOIN #TrendingTagsAuto1 TT ON TT.GigId = G.GigId
WHERE 
 G.IsActive = 'Y' AND G.GigStatus = 'P' and G.IsGigEnabled = 'Y'

 if (@searchText = '')
   BEGIN
   	INSERT INTO #Result1 
SELECT top 10 GigTitle,[Type] 
    --SELECT distinct top 10 GigTitle,[Type]  INTO #Result1 
	FROM #temp1 ORDER BY GigTitle DESC
   END
 

 else
   BEGIN
      	INSERT INTO #Result1 
SELECT top 10 GigTitle,[Type] 
    --SELECT distinct top 10 GigTitle,[Type]  INTO #Result1  
	FROM #temp1 WHERE GigTitle LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\'  
    or TrendingTagsIdList LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\' ORDER BY GigTitle DESC
   END
 

drop table #TrendingTagsAuto1

drop table #temp1
		
  END	

  SELECT TOP 10  JobTitle,[Type] FROM #Result1 order by  JobTitle 
  drop table #Result1

END

--exec spGetAutomatedJobsForTrendingTags 'T','B'
