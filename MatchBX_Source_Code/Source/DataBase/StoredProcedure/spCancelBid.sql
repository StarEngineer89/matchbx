--Created by    :	Praveen K
--Created Date  :	01-03-2019
--Purpose       :	Cancel Bid

--EXEC spCancelBid 3292

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spCancelBid')
DROP procedure spCancelBid
GO
CREATE PROCEDURE spCancelBid
( 	
	@JobBiddingId int
)
AS
BEGIN	
	Update JobBidding set IsActive='N' where JobBiddingId=@JobBiddingId;
	select * from JobBidding where JobBiddingId=@JobBiddingId;	
END
GO



