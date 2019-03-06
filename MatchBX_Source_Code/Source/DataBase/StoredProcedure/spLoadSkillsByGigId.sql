--Created by    :	Sanu Mohan P
--Created Date  :	08-01-2019
--Purpose       :	Load skill details for Gig on edit

--EXEC spLoadSkillsByGigId 2

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadSkillsByGigId')
DROP procedure spLoadSkillsByGigId
GO
CREATE PROCEDURE [spLoadSkillsByGigId]
(	 
	@GigId int	
)
AS
BEGIN

SELECT 
	GSM.SkillsId,
	S.Description
	--JobSkillsMappingId
FROM GigSkillsMapping GSM
INNER JOIN Skills S ON GSM.SkillsId = S.SkillsId
WHERE GSM.GigId = @GigId
		
END
GO



