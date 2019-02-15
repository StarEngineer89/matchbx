--Created by    :Sanu Mohan P
--Created Date  :7/10/2018 11:30:48 AM
--Purpose      :User skill mapping

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditUserSkillsMapping')
DROP procedure spAddEditUserSkillsMapping
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditUserSkillsMapping
(
@UserSkillsMappingId  int,
@UserId  int,
@SkillsId  int
)
AS
IF(@UserSkillsMappingId=0)
BEGIN
	INSERT  INTO UserSkillsMapping 
	(
	  UserId,
	  SkillsId
	)
	VALUES 
	(
	  @UserId,
	  @SkillsId
	)
    SELECT MAX(UserSkillsMappingId) AS UserSkillsMappingId  FROM UserSkillsMapping

END
ELSE
BEGIN
   UPDATE UserSkillsMapping SET
    UserId	=  @UserId,
    SkillsId	=  @SkillsId
    WHERE UserSkillsMappingId	=  @UserSkillsMappingId
   SELECT @UserSkillsMappingId as UserSkillsMappingId
END
GO
