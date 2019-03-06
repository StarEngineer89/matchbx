--Created by    :	Sanu Mohan P
--Created Date  :	09-01-2019
--Purpose       :	Load trending tags details for gig on edit

--EXEC spLoadTagsByGigId 8

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadTagsByGigId')
DROP procedure spLoadTagsByGigId
GO
CREATE PROCEDURE [spLoadTagsByGigId]
(	 
	@GigId int	
)
AS
BEGIN

SELECT 
	GTM.TrendingTagsId,
	T.Description
	--JobTrendingTagsMappingId
FROM GigTrendingTagsMapping GTM
INNER JOIN TrendingTags T ON GTM.TrendingTagsId = T.TrendingTagsId
WHERE GTM.GigId = @GigId
		
END
GO



