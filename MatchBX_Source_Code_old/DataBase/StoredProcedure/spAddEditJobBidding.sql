--Created by    :Sanu Mohan P
--Created Date  :7/4/2018 1:20:17 PM
--Purpose      :Sp creation

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobBidding')
DROP procedure spAddEditJobBidding
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobBidding
(
	@JobBiddingId	int,
	@JobId	int,
	@UserId	int,
	@BidAmount	decimal(18,3),
	@BidMessage	nvarchar(1000),
	@IsActive	char(1),
	@IsAccepted char(1)	
)
AS
IF(@JobBiddingId=0)
BEGIN
	INSERT  INTO JobBidding 
	(		
		JobId,
		UserId,
		BidAmount,
		BidMessage,
		IsActive,
		CreatedDate,
		IsAccepted		
	)
	VALUES 
	(
		@JobId,
		@UserId,
		@BidAmount,
		@BidMessage,
		@IsActive,
		GETDATE(),
		@IsAccepted
	)
    SELECT MAX(JobBiddingId) AS JobBiddingId  FROM JobBidding

END
ELSE
BEGIN
   UPDATE JobBidding SET
   JobId = @JobId,
   UserId = @UserId,
   BidAmount = @BidAmount,
   BidMessage = @BidMessage,
   IsActive = @IsActive,
   ModifiedDate = GETDATE(),
   IsAccepted = @IsAccepted   
   WHERE JobBiddingId = @JobBiddingId

   SELECT @JobBiddingId as JobBiddingId
END
GO
