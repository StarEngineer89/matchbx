--Created by    :	Jomon Joseph
--Created Date  :	22-02-2019
--Purpose       :	To get gig details for Dashboard

--EXEC spGetDeclinedJobBiddingDetails 1161



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetDeclinedJobBiddingDetails')
DROP procedure spGetDeclinedJobBiddingDetails
GO
CREATE PROCEDURE [spGetDeclinedJobBiddingDetails]
(	
	@JobId int
)
AS
BEGIN
	SELECT 
	JB.JobBiddingId,
	JB.JobId,
	JB.BidAmount,
	JB.BidMessage,
	COALESCE(U.FullName,'@'+U.UserName) AS SeekerFullName,
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS SeekerProfilePic,	
	JB.UserId AS SeekerId,
	U.Email AS Email,
	CASE WHEN LEN(JB.BidMessage) > 50 THEN SUBSTRING(JB.BidMessage,0,50) + '...' ELSE JB.BidMessage END AS 'BidMessageDisplay'	
FROM JobBidding JB 
INNER JOIN Users U ON U.UserId = JB.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
WHERE JB.JobId = @JobId AND JB.IsActive = 'N'
END
GO






