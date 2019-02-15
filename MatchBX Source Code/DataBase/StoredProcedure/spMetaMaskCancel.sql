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
	UPDATE JobBidding SET IsPending = 'N' WHERE JobId = @JobId	
	DELETE FROM TransactionDetail WHERE JobId = @JobId AND ProcessType = 'D'
	SELECT @JobId AS JobId	
END
GO



