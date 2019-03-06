--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get Job bid details for landing page

--EXEC spLoadBidDetails 1,2

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadBidDetails')
DROP procedure spLoadBidDetails
GO
CREATE PROCEDURE [spLoadBidDetails]
(	 
	@JobId int,
	@UserId int	
)
AS
BEGIN

SELECT 
	JB.JobId,
	JB.UserId,
	JB.BidAmount,
	JB.BidMessage,
	JB.IsActive,
	JB.IsAccepted,
	JB.JobBiddingId,
	ISNULL(TD.TokenDistributionId,0) AS TokenDistributionId,
	ISNULL(IsPending,'N') AS IsPending
FROM JobBidding JB
LEFT JOIN TokenDistribution TD ON JB.JobBiddingId = TD.JobBiddingId
WHERE JB.JobId = @JobId AND JB.UserId = @UserId AND JB.IsActive = 'Y'
		
END
GO



