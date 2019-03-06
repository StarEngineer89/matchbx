--Created by    :	Navya P Nair
--Created Date  :	03-08-2018
--Purpose       :	To get skills for landing page

--EXEC spGetAllSkills 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAllSkills')
DROP procedure spGetAllSkills
GO
CREATE PROCEDURE [spGetAllSkills]

AS
BEGIN

SELECT SkillsId,Description  FROM Skills 
		
END
GO



