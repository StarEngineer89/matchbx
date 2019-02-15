--Created by    :Navya P Nair
--Created Date  :7/25/2018 2:12:07 PM
--Purpose      :Delete job

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spDeleteJob')
DROP procedure spDeleteJob
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spDeleteJob
(
	@JobId  int,
	@IsActive  char(1)
)
AS
BEGIN

	 Update Job set IsActive=@IsActive where JobId=@JobId
	 SELECT JobId as JobId FROM Job
	 
END




