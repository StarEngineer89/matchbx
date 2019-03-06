--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetUserSkills 1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetUserSkills')
DROP procedure spGetUserSkills
GO
CREATE PROCEDURE [spGetUserSkills]
(	 
	@UserId int	
)
AS
BEGIN

SELECT 
	USM.SkillsId,
	S.Description,
	USM.UserSkillsMappingId
FROM UserSkillsMapping USM
INNER JOIN Skills S ON S.SkillsId = USM.SkillsId
WHERE USM.UserId = @UserId
		
END
GO



