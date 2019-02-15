--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	User details analytics

--EXEC spUpdateApprovalTransaction

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateApprovalTransaction')
DROP procedure spUpdateApprovalTransaction
GO
CREATE PROCEDURE [spUpdateApprovalTransaction]
( 
	@UserId int,
	@Address nvarchar(100)	
)
AS
BEGIN			
	DELETE FROM TransactionDetail WHERE UserId = @UserId AND Address = @Address
	SELECT @UserId AS UserId	
END
GO



