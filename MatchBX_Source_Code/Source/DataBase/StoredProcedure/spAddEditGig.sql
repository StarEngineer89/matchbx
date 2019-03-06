--Created by    :Sanu Mohan P
--Created Date  :1/7/2019 3:06:14 PM
--Purpose      :Model,Business classes

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGig')
DROP procedure spAddEditGig
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGig
(
	@GigId  int,
	@JobCategoryId  int,
	@UserId  int,
	@GigTitle  nvarchar(200),
	@GigDescription  nvarchar(max),
	@BudgetASP  decimal(18,3),
	@Commission  decimal(18,3),
	@TotalBudget  decimal(18,3),
	@GigDuration  int,
	@IsActive  char(1),
	@IsGigEnabled  char(1),	
	@GigStatus char(1),
	@CancelReason int,
	@Deliverables nvarchar(max),
	@WithTransaction char(1) 
)
AS
IF(@GigId=0)
BEGIN
	INSERT  INTO Gig 
	(
	  JobCategoryId,
	  UserId,
	  GigTitle,
	  GigDescription,
	  BudgetASP,
	  Commission,
	  TotalBudget,
	  GigDuration,
	  IsActive,
	  IsGigEnabled,
	  CreatedDate,
	  ModifiedDate,
	  GigStatus,
	  CancelReason,
	  Deliverables	  
	)
	VALUES 
	(
	  @JobCategoryId,
	  @UserId,
	  @GigTitle,
	  @GigDescription,
	  @BudgetASP,
	  @Commission,
	  @TotalBudget,
	  @GigDuration,
	  @IsActive,
	  @IsGigEnabled,
	  GETDATE(),
	  GETDATE(),
	  @GigStatus,
	  @CancelReason,
	  @Deliverables
	)
    SELECT MAX(GigId) AS GigId  FROM Gig

END
ELSE
BEGIN
   UPDATE Gig SET
    JobCategoryId	=  @JobCategoryId,
    UserId	=  @UserId,
    GigTitle	=  @GigTitle,
    GigDescription	=  @GigDescription,
    BudgetASP	=  @BudgetASP,
    Commission	=  @Commission,
    TotalBudget	=  @TotalBudget,
    GigDuration	=  @GigDuration,
    IsActive	=  @IsActive,
    IsGigEnabled	=  @IsGigEnabled,   
    ModifiedDate	=  GETDATE(),
    GigStatus = @GigStatus,
    CancelReason = @CancelReason,
    Deliverables = @Deliverables
    WHERE GigId	=  @GigId
    
    IF(ISNULL(@WithTransaction,'N') = 'Y')
	BEGIN
		Delete from GigTrendingTagsMapping where GigId=@GigId
		Delete from GigSkillsMapping where GigId=@GigId
	END
    
   SELECT @GigId as GigId
END
GO
