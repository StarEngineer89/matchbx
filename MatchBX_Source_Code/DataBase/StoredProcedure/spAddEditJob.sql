--Created by    :Sanu Mohan P
--Created Date  :7/25/2018 2:12:07 PM
--Purpose      :Add edit job

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJob')
DROP procedure spAddEditJob
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJob
(
	@JobId  int,
	@JobCategoryId  int,
	@UserId  int,
	@JobTitle  nvarchar(200),
	@JobDescription  nvarchar(2000),
	@BudgetASP  decimal(18,3),
	@Commission  decimal(18,3),
	@TotalBudget  decimal(18,3),
	@JobCompletionDate  datetime,
	@IsActive  char(1),
	@JobStatus  char(1),	
	@JobSeekerId  int,	
	@JobPosterRating  DECIMAL(18,3),
	@JobSeekerRating  DECIMAL(18,3),
	@JobStatusSeeker  char(1),
	@CancelReason int,
	@WithTransaction char(1)
)
AS
DECLARE @Action char(1),@JobReferanceId NVARCHAR(20)
SET @Action='I'
IF(@JobId=0)
BEGIN
	DECLARE @JobRefId INT
	SELECT @JobRefId = JobReferanceNo FROM JobReferance WHERE JobReferanceId = 1
	SELECT @JobReferanceId = 'JOB'+ CAST((@JobRefId) AS NVARCHAR(20))		
	
	INSERT  INTO Job 
	(
	  JobCategoryId,
	  UserId,
	  JobTitle,
	  JobDescription,
	  BudgetASP,
	  Commission,
	  TotalBudget,
	  JobCompletionDate,
	  IsActive,
	  JobStatus,
	  CreatedDate,	  
	  JobSeekerId,
	  JobReferanceId,
	  JobPosterRating,
	  JobSeekerRating,
	  JobStatusSeeker,
	  CancelReason
	)
	VALUES 
	(
	  @JobCategoryId,
	  @UserId,
	  @JobTitle,
	  @JobDescription,
	  @BudgetASP,
	  @Commission,
	  @TotalBudget,
	  @JobCompletionDate,
	  @IsActive,
	  @JobStatus,
	  GETDATE(),	 
	  Case When @JobSeekerId=0 Then null ELSE @JobSeekerId END ,
	  @JobReferanceId,
	  @JobPosterRating,
	  @JobSeekerRating,
	  Case When @JobStatusSeeker = '' Then null ELSE @JobStatusSeeker END,
	  @CancelReason 	  
	)
    SELECT @JobId =MAX(JobId) FROM Job    
    UPDATE JobReferance SET JobReferanceNo = @JobRefId + 1  WHERE JobReferanceId = 1

END
ELSE
BEGIN
   UPDATE Job SET
    JobCategoryId	=  @JobCategoryId,
    UserId	=  @UserId,
    JobTitle	=  @JobTitle,
    JobDescription	=  @JobDescription,
    BudgetASP	=  @BudgetASP,
    Commission	=  @Commission,
    TotalBudget	=  @TotalBudget,
    JobCompletionDate	=  @JobCompletionDate,
    IsActive	=  @IsActive,
    JobStatus	=  @JobStatus,   
    ModifiedDate	=  GETDATE(),
    JobSeekerId	=  Case When @JobSeekerId=0 Then null ELSE @JobSeekerId END ,   
    JobPosterRating	=  @JobPosterRating,
    JobSeekerRating	=  @JobSeekerRating,
    JobStatusSeeker	=  Case When @JobStatusSeeker = '' Then null ELSE @JobStatusSeeker END,
    CancelReason = @CancelReason
    WHERE JobId	=  @JobId
	
	IF(ISNULL(@WithTransaction,'N') = 'Y')
	BEGIN
		Delete from JobTrendingTagsMapping where JobId=@JobId
		Delete from JobSkillsMapping where JobId=@JobId
	END

   SELECT @JobId as JobId
SET @Action='U'
SELECT @JobReferanceId = JobReferanceId FROM Job WHERE JobId = @JobId
END
INSERT INTO JobLog
  (
	  JobId,
	  JobCategoryId,
	  UserId,
	  JobTitle,
	  JobDescription,
	  BudgetASP,
	  Commission,
	  TotalBudget,
	  JobCompletionDate,
	  IsActive,
	  JobStatus,
	  CreatedDate,
	  ModifiedDate,
	  JobSeekerId,
	  JobReferanceId,
	  JobPosterRating,
	  JobSeekerRating,
	  JobStatusSeeker,
	  Action,
	  CancelReason
	)
	VALUES 
	(
	  @JobId,
	  @JobCategoryId,
	  @UserId,
	  @JobTitle,
	  @JobDescription,
	  @BudgetASP,
	  @Commission,
	  @TotalBudget,
	  @JobCompletionDate,
	  @IsActive,
	  @JobStatus,
	  GETDATE(),
	  GETDATE(),
	  Case When @JobSeekerId=0 Then null ELSE @JobSeekerId END ,
	  @JobReferanceId,
	  @JobPosterRating,
	  @JobSeekerRating,
	  Case When @JobStatusSeeker = '' Then null ELSE @JobStatusSeeker END, 	
	  @Action,
	  @CancelReason
	)
	 SELECT MAX(JobId) as JobId FROM Job
GO
