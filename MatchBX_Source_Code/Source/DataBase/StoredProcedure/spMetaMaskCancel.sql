--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	User details analytics

--EXEC spMetaMaskCancel

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spMetaMaskCancel')
DROP procedure spMetaMaskCancel
GO
CREATE PROCEDURE [spMetaMaskCancel]
( 
	@JobId int	
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Job WHERE JobId = 3086 AND ISNULL(GigSubscriptionId,0) = 0)
	BEGIN		
		UPDATE JobBidding SET IsPending = 'N' WHERE JobId = @JobId	
		DELETE FROM TransactionDetail WHERE JobId = @JobId AND ProcessType = 'D'
		SELECT @JobId AS JobId	
	END
	ELSE
	BEGIN
		DELETE FROM TransactionDetail WHERE JobId = @JobId AND ProcessType = 'D'
		DELETE FROM Job WHERE JobID = @JobId
		SELECT @JobId AS JobId
	END
END
GO



