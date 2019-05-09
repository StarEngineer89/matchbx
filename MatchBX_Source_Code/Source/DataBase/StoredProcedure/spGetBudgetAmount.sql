--Created by    :	Sanu Mohan P
--Created Date  :	30-04-2019
--Purpose       :	Load budget amount or bid amount against job

--EXEC spGetBudgetAmount 322

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetBudgetAmount')
DROP procedure spGetBudgetAmount
GO
CREATE PROCEDURE [spGetBudgetAmount]
(	 
	@JobId INT	
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Job WHERE JobId = @JobId AND ISNULL(GigSubscriptionId,0) <> 0 )
	BEGIN
		SELECT BudgetASP AS BidAmount FROM Job WHERE JobId = @JobId
	END
	ELSE 
	BEGIN
		SELECT BidAmount FROM JobBidding WHERE JobId = @JobId AND IsAccepted = 'Y'
	END
END
GO



