--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spJobBidAccept 2,2,'D'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spJobBidAccept')
DROP procedure spJobBidAccept
GO
CREATE PROCEDURE [spJobBidAccept]
(	 
	@JobBiddingId int,
	@JobId int,
	@JobStatus char(1),
	@JobCompletionDate datetime	
)
AS
BEGIN
	IF @JobStatus = 'A'
	BEGIN
		DECLARE @BidUserId INT
		SELECT @BidUserId = UserId FROM JobBidding WHERE JobBiddingId = @JobBiddingId
		--UPDATE JobBidding SET IsAccepted = 'Y' WHERE JobBiddingId = @JobBiddingId
		UPDATE JobBidding SET IsPending = 'Y' WHERE JobBiddingId = @JobBiddingId
		--UPDATE JobBidding SET IsActive = 'N' WHERE JobId = @JobId AND JobBiddingId <> @JobBiddingId		
		--UPDATE Job SET JobStatus = 'A',JobSeekerId = @BidUserId,JobStatusSeeker='A' WHERE JobId = @JobId
		--UPDATE Job SET JobCompletionDate = @JobCompletionDate WHERE JobId = @JobId
		SELECT @JobBiddingId AS JobBiddingId
	END	
	ELSE
	BEGIN
		--UPDATE JobBidding SET IsActive = 'N',DeclineType = 'M' WHERE JobBiddingId = @JobBiddingId
		UPDATE JobBidding SET IsActive = 'N' WHERE JobBiddingId = @JobBiddingId
		SELECT @JobBiddingId AS JobBiddingId
	END	
END
GO



