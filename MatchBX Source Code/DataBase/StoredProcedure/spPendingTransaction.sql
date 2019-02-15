--Created by    :	Sanu Mohan P
--Created Date  :	24-Sep-2018
--Purpose       :	To get pending transaction details

--EXEC spPendingTransaction 1344

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spPendingTransaction')
DROP procedure spPendingTransaction
GO
CREATE PROCEDURE [spPendingTransaction]
(
	@JobId int	
)
AS
BEGIN
	SELECT 
		JobTitle,
		COALESCE(U.FullName,'@'+U.UserName) AS 'BidUserName',
		ISNULL(IsPending,'N') AS IsPending,
		JB.BidAmount
	FROM JobBidding JB 
	LEFT JOIN TransactionDetail TD ON JB.JobId = TD.JobId
	LEFT JOIN Job J ON J.Jobid = TD.JobId
	LEFT JOIN Users U ON U.UserId = JB.UserId
	WHERE ISNULL(IsPending,'N') = 'Y' AND TD.ProcessType = 'D'
	AND JB.JobId = @JobId
END
GO



