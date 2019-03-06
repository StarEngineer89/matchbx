--Created by    :Sanu Mohan P
--Created Date  :1/7/2019 3:06:14 PM
--Purpose      :Model,Business classes

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGigSubscription')
DROP procedure spAddEditGigSubscription
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGigSubscription
(
	@GigSubscriptionId  int,
	@GigId  int,
	@JobPosterId  int,
	@Description  nvarchar(max),
	@IsActive  char(1),
	@GigSubscriptionStatus  char(1),
	@JobCompletionDate	DATETIME,
	@Title nvarchar(200)
)
AS
IF(@GigSubscriptionId=0)
BEGIN
	INSERT  INTO GigSubscription 
	(
	  GigId,
	  JobPosterId,
	  Description,
	  IsActive,
	  GigSubscriptionStatus,
	  CreatedDate,
	  ModifiedDate,
	  JobCompletionDate,
	  Title
	)
	VALUES 
	(
	  @GigId,
	  @JobPosterId,
	  @Description,
	  @IsActive,
	  @GigSubscriptionStatus,
	  GETDATE(),
	  GETDATE(),
	  @JobCompletionDate,
	  @Title
	)
    SELECT MAX(GigSubscriptionId) AS GigSubscriptionId  FROM GigSubscription

END
ELSE
BEGIN
   UPDATE GigSubscription SET
    GigId	=  @GigId,
    JobPosterId	=  @JobPosterId,
    Description	=  @Description,
    IsActive	=  @IsActive,
    GigSubscriptionStatus	=  @GigSubscriptionStatus,
    JobCompletionDate    = @JobCompletionDate,
    ModifiedDate	= GETDATE(),
    Title = @Title
    WHERE GigSubscriptionId	=  @GigSubscriptionId
   SELECT @GigSubscriptionId as GigSubscriptionId
END
GO
