--Created by    :	Sanu Mohan P
--Created Date  :	10-01-2019
--Purpose       :	To get search results for gig review

--EXEC spGetAutomatedSearchForGigReview 'N'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAutomatedSearchForGigReview')
DROP procedure spGetAutomatedSearchForGigReview
GO
CREATE PROCEDURE [spGetAutomatedSearchForGigReview]
(	 
	@searchText varchar(100)
)
AS
BEGIN	

	SELECT  G.GigId, TrendingTagsIdList= STUFF((
		SELECT ', ' +  REPLACE(a.Description,'#','')
		FROM TrendingTags AS a
		INNER JOIN GigTrendingTagsMapping AS b
		ON a.TrendingTagsId = b.TrendingTagsId
		WHERE b.GigId = G.GigId
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, '')
	INTO #TrendingTagsAuto
	FROM Gig AS G;


	SELECT DISTINCT
		--REPLACE(J.JobTitle,' ','') as JobTitlesearch ,
		G.GigTitle,
		G.GigStatus,
		G.GigId,	
		--REPLACE(TT.TrendingTagsIdList,' ','') as TrendingTagsIdListsearch ,
		ISNULL(TT.TrendingTagsIdList,'') AS TrendingTagsIdList				
	INTO #temp
	FROM Gig G
	LEFT JOIN GigTrendingTagsMapping GTM ON GTM.GigId = G.GigId
	LEFT JOIN GigSkillsMapping GSM ON GSM.GigId = G.GigId
	LEFT JOIN #TrendingTagsAuto TT ON TT.GigId = G.GigId
	WHERE G.IsActive = 'N' AND G.GigStatus = 'R'

	 if (@searchText = '')
	  SELECT distinct top 10 GigTitle FROM #temp WHERE GigStatus = 'R' ORDER BY GigTitle DESC

	 else
	  SELECT distinct top 10 GigTitle FROM #temp WHERE GigStatus = 'R' and GigTitle  LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\'  
	 or TrendingTagsIdList LIKE LTRIM(RTRIM('%'+@searchText+'%')) ESCAPE '\' ORDER BY GigTitle DESC

	drop table #TrendingTagsAuto

	drop table #temp
		
END
GO