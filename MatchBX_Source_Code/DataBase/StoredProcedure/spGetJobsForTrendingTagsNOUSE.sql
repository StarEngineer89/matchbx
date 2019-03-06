--Created by    :	Sanu Mohan P
--Created Date  :	27-06-2018
--Purpose       :	To get jobs against trending tags and job category

--EXEC spGetJobsForTrendingTags 0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetJobsForTrendingTags')
DROP procedure spGetJobsForTrendingTags
GO
CREATE PROCEDURE [spGetJobsForTrendingTags]
(	 
	@JobCategoryId int,
	@TrendingTagsId int	
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompleted
FROM Job WHERE JobStatus = 'C' GROUP BY UserId

SELECT 
	Description ,	
FROM TrendingTags T
INNER JOIN JobTrendingTagsMapping JTM ON T.TrendingTagsId = JTM.TrendingTagsId
INNER JOIN Job J ON J.JobId = JTM.JobId
WHERE (JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
		
END
GO



