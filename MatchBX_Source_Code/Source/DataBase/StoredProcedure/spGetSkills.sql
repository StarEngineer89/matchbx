--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkills 1,B

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetSkills')
DROP procedure spGetSkills
GO
CREATE PROCEDURE [spGetSkills]
(	 
	@JobCategoryId int,
	@FromPage char(1)	
)
AS
BEGIN
IF (@FromPage = '')
BEGIN
	SET @FromPage = 'J'
END

DECLARE @TopSkills TABLE
(
	Description varchar(100),
	SkillsId INT
	
)
IF(@FromPage ='J' OR @FromPage ='B' )
BEGIN
    INSERT INTO @TopSkills
	SELECT S.Description,S.SkillsId
	FROM Skills S
	INNER JOIN JobSkillsMapping JSM ON S.SkillsId = JSM.SkillsId
	INNER JOIN Job J ON J.JobId = JSM.JobId
	WHERE (J.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND J.IsActive = 'Y' AND JobStatus IN ('P','B')
	GROUP BY S.Description,S.SkillsId
	ORDER BY COUNT(S.SkillsId) DESC
END
ELSE IF(@FromPage ='G' OR @FromPage ='B')
BEGIN
    INSERT INTO @TopSkills
	SELECT S.Description,S.SkillsId
	FROM Skills S
	INNER JOIN GigSkillsMapping JSM ON S.SkillsId = JSM.SkillsId
	INNER JOIN Gig J ON J.GigId = JSM.GigId
	WHERE (J.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0)) AND J.IsActive = 'Y' AND GigStatus = 'P' AND IsGigEnabled = 'Y'
	GROUP BY S.Description,S.SkillsId
	ORDER BY COUNT(S.SkillsId) DESC
END
	;WITH CTE AS
(SELECT ROW_NUMBER() OVER(PARTITION BY SkillsId ORDER BY SkillsId DESC)Rnk,Description,SkillsId FROM @TopSkills)

 SELECT TOP 10 * FROM CTE WHERE Rnk = 1 ORDER BY SkillsId DESC
END
GO



