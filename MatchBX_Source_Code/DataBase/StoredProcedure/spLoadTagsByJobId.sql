--Created by    :	Sanu Mohan P
--Created Date  :	29-06-2018
--Purpose       :	Load trending tags details for job on edit

--EXEC spLoadTagsByJobId 1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadTagsByJobId')
DROP procedure spLoadTagsByJobId
GO
CREATE PROCEDURE [spLoadTagsByJobId]
(	 
	@JobId int	
)
AS
BEGIN

SELECT 
	JTM.TrendingTagsId,
	T.Description
	--JobTrendingTagsMappingId
FROM JobTrendingTagsMapping JTM
INNER JOIN TrendingTags T ON JTM.TrendingTagsId = T.TrendingTagsId
WHERE JTM.JobId = @JobId
		
END
GO



