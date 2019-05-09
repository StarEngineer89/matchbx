--Created by    :	Jomon Joseph
--Created Date  :	22-02-2019
--Purpose       :	To get gig details for Dashboard

--EXEC spGetJobBiddingDetails 4142



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetJobBiddingDetails')
DROP procedure spGetJobBiddingDetails
GO
CREATE PROCEDURE [spGetJobBiddingDetails]
(	
	@JobId int
)
AS
BEGIN
	SELECT 
		JB.JobBiddingId,
		JB.JobId,
		COALESCE(U.FullName,'@'+U.UserName) AS SeekerFullName,
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS SeekerProfilePic,
		JB.BidAmount,
		JB.BidDuration,
		JB.BidMessage,
		TD.TokenAddress,
		JB.UserId AS SeekerId,
		U.Email AS Email,
		CASE WHEN LEN(JB.BidMessage) > 50 THEN SUBSTRING(JB.BidMessage,0,50) + '...' ELSE JB.BidMessage END AS 'BidMessageDisplay'		
	FROM JobBidding JB
	INNER JOIN Users U ON JB.UserId = U.UserId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN TokenDistribution TD ON ISNULL(TD.JobBiddingId,0) = JB.JobBiddingId
	LEFT JOIN TransactionDetail TL ON TL.JobId = JB.JobId
	WHERE JB.JobId = @JobId AND JB.IsActive = 'Y' AND ISNULL(TL.TransactionDetailId,0) = 0
END
GO






