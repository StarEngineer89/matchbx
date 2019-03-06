--Created by    :Sanu Mohan P
--Created Date  :6/29/2018 12:16:56 PM
--Purpose      :businee class

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobSkillsMapping')
DROP procedure spAddEditJobSkillsMapping
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobSkillsMapping
(
@JobSkillsMappingId  int,
@JobId  int,
@SkillsId  int
)
AS

IF(@JobSkillsMappingId=0)
BEGIN
	INSERT  INTO JobSkillsMapping 
	(
	  JobId,
	  SkillsId
	)
	VALUES 
	(
	  @JobId,
	  @SkillsId
	)
    SELECT MAX(JobSkillsMappingId) AS JobSkillsMappingId  FROM JobSkillsMapping

END
ELSE
BEGIN
   UPDATE JobSkillsMapping SET
    JobId	=  @JobId,
    SkillsId	=  @SkillsId
    WHERE JobSkillsMappingId	=  @JobSkillsMappingId
   SELECT @JobSkillsMappingId as JobSkillsMappingId
END


GO
