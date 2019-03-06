--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get trending tags for landing page

--EXEC spGetTrendingTags 0,'G'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetTrendingTags')
DROP procedure spGetTrendingTags
GO
CREATE PROCEDURE [spGetTrendingTags]
(	 
	@JobCategoryId int,
	@FromPage char(1)	
)
AS
BEGIN

IF (@FromPage = '')
BEGIN
	SET @FromPage = 'J'
END

DECLARE @TrendingTags TABLE
(
	Description varchar(100),
	TrendingTagsId INT,
	Counts INT
)

IF(@FromPage = 'J' OR @FromPage = 'B')
BEGIN
	INSERT INTO @TrendingTags
	SELECT 
		Description ,
		JTM.TrendingTagsId,
		COUNT(JTM.TrendingTagsId)	
	FROM TrendingTags T
	INNER JOIN JobTrendingTagsMapping JTM ON T.TrendingTagsId = JTM.TrendingTagsId
	INNER JOIN Job J ON J.JobId = JTM.JobId
	WHERE (T.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND J.IsActive = 'Y' AND JobStatus IN ('P','B') AND T.TagType = 'S'
	AND J.JobCompletionDate > GETDATE()
	GROUP BY Description,JTM.TrendingTagsId
	ORDER BY COUNT(JTM.TrendingTagsId) DESC
END
IF(@FromPage = 'G' OR @FromPage = 'B')
BEGIN
	INSERT INTO @TrendingTags
	SELECT 
		T.Description,
		GTM.TrendingTagsId,
		COUNT(GTM.TrendingTagsId)	
	FROM TrendingTags T
	INNER JOIN GigTrendingTagsMapping GTM ON T.TrendingTagsId = GTM.TrendingTagsId
	INNER JOIN Gig G ON G.GigId = GTM.GigId
	WHERE (T.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND G.IsActive = 'Y' AND GigStatus = 'P' AND IsGigEnabled = 'Y' 
	AND T.TagType = 'S'
	GROUP BY Description,GTM.TrendingTagsId
	ORDER BY COUNT(GTM.TrendingTagsId) DESC
END

;WITH CTE AS
(SELECT ROW_NUMBER() OVER(PARTITION BY TrendingTagsId ORDER BY Counts DESC)Rnk,Description,TrendingTagsId,Counts FROM @TrendingTags)

SELECT TOP 10 * FROM CTE WHERE Rnk = 1 ORDER BY Counts DESC



END
GO



