--Created by    :Sanu Mohan P
--Created Date  :6/25/2018 12:51:41 PM
--Purpose      :MatchBX

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditSkills')
DROP procedure spAddEditSkills
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditSkills
(
@SkillsId  int,
@Description  nvarchar(2000),
@JobCategoryId  int
)
AS
IF(@SkillsId=0)
BEGIN
	INSERT  INTO Skills 
	(
	  Description,
	  JobCategoryId
	)
	VALUES 
	(
	  @Description,
	  @JobCategoryId
	)
    SELECT MAX(SkillsId) AS SkillsId  FROM Skills

END
ELSE
BEGIN
   UPDATE Skills SET
    Description	=  @Description,
    JobCategoryId	=  @JobCategoryId
    WHERE SkillsId	=  @SkillsId
   SELECT @SkillsId as SkillsId
END
GO
