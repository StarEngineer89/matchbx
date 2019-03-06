--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get trending tags for landing page

--EXEC spGetTrendingTags 0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetTrendingTags')
DROP procedure spGetTrendingTags
GO
CREATE PROCEDURE [spGetTrendingTags]
(	 
	@JobCategoryId int	
)
AS
BEGIN

SELECT TOP 10
	Description ,
	JTM.TrendingTagsId	
FROM TrendingTags T
INNER JOIN JobTrendingTagsMapping JTM ON T.TrendingTagsId = JTM.TrendingTagsId
INNER JOIN Job J ON J.JobId = JTM.JobId
WHERE (T.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND J.IsActive = 'Y' AND JobStatus IN ('P','B') AND T.TagType = 'S'
GROUP BY Description,JTM.TrendingTagsId
ORDER BY COUNT(JTM.TrendingTagsId) DESC
		
END
GO



