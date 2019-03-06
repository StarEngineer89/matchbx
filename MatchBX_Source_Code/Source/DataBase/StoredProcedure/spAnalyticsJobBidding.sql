--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	Job bidding details analytics

--EXEC spAnalyticsJobBidding

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAnalyticsJobBidding')
DROP procedure spAnalyticsJobBidding
GO
CREATE PROCEDURE [spAnalyticsJobBidding]
AS
BEGIN

SELECT 
    JB.JobBiddingId,
    JB.JobId,
    JB.UserId,
    JB.BidAmount,
    JB.BidMessage,
    JB.IsActive,
    JB.CreatedDate,
    JB.ModifiedDate,
    JB.IsAccepted
FROM JobBidding JB

		
END
GO



