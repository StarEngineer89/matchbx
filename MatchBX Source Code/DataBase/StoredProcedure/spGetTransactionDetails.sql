--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	Load user transaction details

--EXEC spGetTransactionDetails 2

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetTransactionDetails')
DROP procedure spGetTransactionDetails
GO
CREATE PROCEDURE [spGetTransactionDetails]
(	 
	@UserId int		
)
AS
BEGIN
	SELECT
	U.UserId,
	U.UserType,
	ISNULL(S.Spent,0) AS Spent,
	ISNULL(E.Earnt,0) AS Earnt
	FROM Users U 
	LEFT JOIN TransactionDetail TD ON TD.UserId = U.UserId AND TransactionType <> 'A'
	LEFT JOIN(SELECT SUM(Amount) AS Spent,UserId FROM Transactiondetail WHERE UserId = @UserId AND TransactionType = 'S' AND IsApproved = 'Y' GROUP BY UserId) S ON S.UserId = TD.UserId
	LEFT JOIN(SELECT SUM(Amount) AS Earnt,UserId FROM Transactiondetail WHERE UserId = @UserId AND TransactionType = 'E' AND IsApproved = 'Y' GROUP BY UserId) E ON E.UserId = TD.UserId
	WHERE U.UserId = @UserId 
	--AND IsApproved = 'Y'	
	GROUP BY U.UserId,U.UserType,S.Spent,E.Earnt	
END
GO



