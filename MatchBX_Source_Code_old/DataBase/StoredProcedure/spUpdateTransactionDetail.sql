--Created by    :	Sanu Mohan P
--Created Date  :	29-08-2018
--Purpose       :	Update transaction details

--EXEC spUpdateTransactionDetail

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateTransactionDetail')
DROP procedure spUpdateTransactionDetail
GO
CREATE PROCEDURE [spUpdateTransactionDetail]
( 
	@JobId int,
	@Hash nvarchar(200)	
)
AS
BEGIN		
	UPDATE TransactionDetail SET Hash = @Hash WHERE JobId = @JobId AND ISNULL(ProcessType,'A') = 'A'		
	SELECT @JobId AS JobId	
END
GO



