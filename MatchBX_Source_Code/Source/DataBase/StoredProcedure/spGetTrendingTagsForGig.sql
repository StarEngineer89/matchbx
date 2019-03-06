--Created by    :	Sanu Mohan P
--Created Date  :	09-01-2019
--Purpose       :	To get trending tags for landing page gig

--EXEC spGetTrendingTagsForGig 0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetTrendingTagsForGig')
DROP procedure spGetTrendingTagsForGig
GO
CREATE PROCEDURE [spGetTrendingTagsForGig]
(	 
	@JobCategoryId int	
)
AS
BEGIN

SELECT TOP 10
	T.Description,
	GTM.TrendingTagsId	
FROM TrendingTags T
INNER JOIN GigTrendingTagsMapping GTM ON T.TrendingTagsId = GTM.TrendingTagsId
INNER JOIN Gig G ON G.GigId = GTM.GigId
WHERE (T.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND G.IsActive = 'Y' AND GigStatus = 'P' AND IsGigEnabled = 'Y' 
AND T.TagType = 'S'
GROUP BY Description,GTM.TrendingTagsId
ORDER BY COUNT(GTM.TrendingTagsId) DESC
		
END
GO



