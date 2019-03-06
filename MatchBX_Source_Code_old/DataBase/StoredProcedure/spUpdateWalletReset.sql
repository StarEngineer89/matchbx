--Created by    :	Sanu Mohan P
--Created Date  :	26-07-2018
--Purpose       :	Load user details for Login 

--EXEC spUpdateWalletReset 'nar@lsg.com','1234@Lsg'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateWalletReset')
DROP procedure spUpdateWalletReset
GO
CREATE PROCEDURE [spUpdateWalletReset]
(	 
	@Address NVARCHAR(1000)	
)
AS
BEGIN
	UPDATE TransactionDetail SET IsApproved = 'Y',ModifiedDate = GETDATE() WHERE Address = @Address AND TransactionType = 'R'
END
GO



