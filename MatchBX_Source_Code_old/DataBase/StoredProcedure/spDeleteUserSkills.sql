--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	To delete user skills

--EXEC spDeleteUserSkills 26,'3,5'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spDeleteUserSkills')
DROP procedure spDeleteUserSkills
GO
CREATE PROCEDURE [spDeleteUserSkills]
(	 
	@UserId int,
	@SkillsList nvarchar(Max)
)
AS
BEGIN
	DELETE FROM UserSkillsMapping WHERE UserId = @UserId 
	AND SkillsId IN (SELECT CAST(Item AS integer) FROM SplitString(@SkillsList,','))
	
	select @UserId as UserId
END
GO



