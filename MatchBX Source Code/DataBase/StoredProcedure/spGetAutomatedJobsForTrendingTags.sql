--purpose: autosearch

--EXEC spGetAutomatedJobsForTrendingTags 0,0,'0','0',0,15000,'N',1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAutomatedJobsForTrendingTags')
DROP procedure spGetAutomatedJobsForTrendingTags
GO
CREATE PROCEDURE [spGetAutomatedJobsForTrendingTags]
(	 
	@searchText varchar(100)
)
AS
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
	--REPLACE(J.JobTitle,' ','') as JobTitlesearch ,
	j.JobTitle,
	J.JobStatus,
	j.jobid,	
	--REPLACE(TT.TrendingTagsIdList,' ','') as TrendingTagsIdListsearch ,
	ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList,
	ISNULL(JBT.JobId,0) AS PendingJobId	 		
INTO #temp
FROM Job J
LEFT JOIN JobTrendingTagsMapping JTM ON JTM.JobId = J.JobId
LEFT JOIN JobSkillsMapping JSM ON JSM.JobId = J.JobId
LEFT JOIN JobBidding JB ON JB.JobId = J.JobId AND ISNULL(JB.IsAccepted,'N') = 'Y'
LEFT JOIN #TrendingTagsAuto TT ON TT.JobId = J.JobId
LEFT JOIN #PendingJobs JBT ON JBT.JobId = J.JobId 
WHERE 
 J.IsActive = 'Y'

 if (@searchText = '')
  SELECT distinct top 10 JobTitle FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 ORDER BY JobTitle DESC

 else
  SELECT distinct top 10 JobTitle FROM #temp WHERE JobStatus IN ('P','B') AND PendingJobId = 0 and JobTitle  LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\'  
 or TrendingTagsIdList LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\' ORDER BY JobTitle DESC

drop table #TrendingTagsAuto

drop table #temp
		
		
END

--exec spGetAutomatedJobsForTrendingTags 'a'
