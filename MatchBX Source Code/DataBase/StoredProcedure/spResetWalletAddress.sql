--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	User details analytics

--EXEC spResetWalletAddress

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spResetWalletAddress')
DROP procedure spResetWalletAddress
GO
CREATE PROCEDURE [spResetWalletAddress]
( 	
	@Address nvarchar(100),
	@UserId int	
)
AS
BEGIN	
	DELETE FROM TransactionDetail WHERE Address = @Address and ProcessType = 'A'
	EXEC spAddEditTransactionDetail 0,@UserId,0,'',0,'R','R','N',@Address,0		
	SELECT TransactionDetailId FROM TransactionDetail WHERE Address = @Address		
END
GO



