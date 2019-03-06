--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkills 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetSkills')
DROP procedure spGetSkills
GO
CREATE PROCEDURE [spGetSkills]
(	 
	@JobCategoryId int	
)
AS
BEGIN

SELECT S.Description,S.SkillsId
FROM Skills S
INNER JOIN JobSkillsMapping JSM ON S.SkillsId = JSM.SkillsId
INNER JOIN Job J ON J.JobId = JSM.JobId
WHERE (J.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND J.IsActive = 'Y' AND JobStatus IN ('P','B')
GROUP BY S.Description,S.SkillsId
ORDER BY COUNT(S.SkillsId) DESC
		
END
GO



