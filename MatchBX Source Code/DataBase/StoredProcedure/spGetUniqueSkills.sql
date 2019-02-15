--Created by    :Jomon
--Created Date  :11/30/2018 05:00 PM
--Purpose      :MatchBX

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetUniqueSkills')
DROP procedure spGetUniqueSkills
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spGetUniqueSkills

AS
WITH SKILLCTE AS
(
    SELECT SkillsId,Description,JobCategoryId,ROW_NUMBER()  OVER(Partition by Description ORDER BY Description) AS Row_Number  
FROM Skills 
)

select * from SKILLCTE  where Row_Number=1

GO
