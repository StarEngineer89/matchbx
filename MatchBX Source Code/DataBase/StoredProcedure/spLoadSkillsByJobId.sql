--Created by    :	Sanu Mohan P
--Created Date  :	29-06-2018
--Purpose       :	Load skill details for job on edit

--EXEC spLoadSkillsByJobId 1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadSkillsByJobId')
DROP procedure spLoadSkillsByJobId
GO
CREATE PROCEDURE [spLoadSkillsByJobId]
(	 
	@JobId int	
)
AS
BEGIN

SELECT 
	JSM.SkillsId,
	S.Description
	--JobSkillsMappingId
FROM JobSkillsMapping JSM
INNER JOIN Skills S ON JSM.SkillsId = S.SkillsId
WHERE JSM.JobId = @JobId
		
END
GO



