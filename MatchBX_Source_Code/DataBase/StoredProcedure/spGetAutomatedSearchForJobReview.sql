--Created by    :	Sanu Mohan P
--Created Date  :	26-10-2018
--Purpose       :	To get search results for job review

--EXEC spGetSkills 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAutomatedSearchForJobReview')
DROP procedure spGetAutomatedSearchForJobReview
GO
CREATE PROCEDURE [spGetAutomatedSearchForJobReview]
(	 
	@searchText varchar(100)
)
AS
BEGIN	

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
		ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList				
	INTO #temp
	FROM Job J
	LEFT JOIN JobTrendingTagsMapping JTM ON JTM.JobId = J.JobId
	LEFT JOIN JobSkillsMapping JSM ON JSM.JobId = J.JobId	
	LEFT JOIN #TrendingTagsAuto TT ON TT.JobId = J.JobId	
	WHERE J.IsActive = 'N' AND JobStatus = 'R'

	 if (@searchText = '')
	  SELECT distinct top 10 JobTitle FROM #temp WHERE JobStatus = 'R' ORDER BY JobTitle DESC

	 else
	  SELECT distinct top 10 JobTitle FROM #temp WHERE JobStatus = 'R' and JobTitle  LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\'  
	 or TrendingTagsIdList LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\' ORDER BY JobTitle DESC

	drop table #TrendingTagsAuto

	drop table #temp
		
END
GO