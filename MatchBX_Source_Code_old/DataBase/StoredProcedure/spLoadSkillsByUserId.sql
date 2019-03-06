
--Created by    :	Sanu Mohan P
--Created Date  :	09-07-2018
--Purpose       :	Load user skills for profile details

--EXEC spLoadSkillsByUserId 1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadSkillsByUserId')
DROP procedure spLoadSkillsByUserId
GO
CREATE PROCEDURE [spLoadSkillsByUserId]
(	 
	@UserId int	
)
AS
BEGIN

SELECT TOP 10
	 '#' + Description AS Description,
	 S.SkillsId
FROM Skills S
INNER JOIN JobSkillsMapping JSM ON S.SkillsId = JSM.SkillsId
INNER JOIN Job J ON J.JobId = JSM.JobId
WHERE J.JobSeekerId = @UserId and JobStatus = 'C'
GROUP BY S.Description,S.SkillsId
ORDER BY COUNT(S.SkillsId) DESC
		
END
GO






