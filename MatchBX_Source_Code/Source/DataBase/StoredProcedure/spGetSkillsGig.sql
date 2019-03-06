--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkillsGig 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetSkillsGig')
DROP procedure spGetSkillsGig
GO
CREATE PROCEDURE [spGetSkillsGig]
(	 
	@JobCategoryId int	
)
AS
BEGIN

SELECT S.Description,S.SkillsId
FROM Skills S
INNER JOIN GigSkillsMapping JSM ON S.SkillsId = JSM.SkillsId
INNER JOIN Gig J ON J.GigId = JSM.GigId
WHERE (J.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND J.IsActive = 'Y' AND GigStatus = 'P' AND IsGigEnabled = 'Y'
GROUP BY S.Description,S.SkillsId
ORDER BY COUNT(S.SkillsId) DESC
		
END
GO



