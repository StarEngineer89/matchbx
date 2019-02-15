--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spCheckApprovedAmount 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spCheckApprovedAmount')
DROP procedure spCheckApprovedAmount
GO
CREATE PROCEDURE [spCheckApprovedAmount]
(	 
	@UserId int	
)
AS
BEGIN	
	
	SELECT ISNULL(SUM(ISNULL(Amount,0)),0) + (ISNULL(SUM(ISNULL(Amount,0)),0)*3/100) AS Amount
	FROM TransactionDetail WHERE ProcessType = 'D' and IsApproved = 'N' and UserId = @UserId
			
END
GO



