--Created by    :Sanu Mohan P
--Created Date  :8/8/2018 7:03:00 PM
--Purpose      :

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditTokenDistribution')
DROP procedure spAddEditTokenDistribution
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditTokenDistribution
(
	@TokenDistributionId  int,
	@UserId  int,
	@TokenAddress  nvarchar(2000),
	@IsApproved  char,
	@JobBiddingId int,
	@GigSubscriptionId int
)
AS

IF(@JobBiddingId = 0)
BEGIN
	SET @JobBiddingId = null
END

IF(@GigSubscriptionId = 0)
BEGIN
	SET @GigSubscriptionId = null
END

IF(@TokenDistributionId=0)
BEGIN
	INSERT  INTO TokenDistribution 
	(
	  UserId,
	  TokenAddress,
	  IsApproved,
	  JobBiddingId,
	  GigSubscriptionId
	)
	VALUES 
	(
	  @UserId,
	  @TokenAddress,
	  @IsApproved,
	  @JobBiddingId,
	  @GigSubscriptionId
	)
    SELECT MAX(TokenDistributionId) AS TokenDistributionId  FROM TokenDistribution

END
ELSE
BEGIN
   UPDATE TokenDistribution SET
    UserId	=  @UserId,
    TokenAddress	=  @TokenAddress,
    IsApproved	=  @IsApproved,
    JobBiddingId = @JobBiddingId,
    GigSubscriptionId = @GigSubscriptionId
    WHERE TokenDistributionId	=  @TokenDistributionId
   SELECT @TokenDistributionId as TokenDistributionId
END
GO
