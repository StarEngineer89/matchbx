--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spUpdateFailedTransaction 1347

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateFailedTransaction')
DROP procedure spUpdateFailedTransaction
GO
CREATE PROCEDURE [spUpdateFailedTransaction]
(	 
	@JobId int,
	@Hash NVARCHAR(1000)	
)
AS
BEGIN
	
	--Update failed Transaction
	UPDATE TransactionDetail SET IsApproved = 'F',Hash = @Hash WHERE JobId = @JobId AND IsApproved = 'N'
	
	--Check for other active transaction against the JobId
	IF NOT EXISTS(SELECT 1 FROM TransactionDetail WHERE JobId = @JobId AND ProcessType = 'D' AND IsApproved IN ('C','N'))
	BEGIN
		--InActive all other offers against the job
		UPDATE JobBidding SET IsActive  = 'N' WHERE JobId = @JobId AND ISNULL(IsPending,'N') <> 'Y'
		
		--Revert the accepted job offer
		UPDATE JobBidding SET IsPending = 'N' WHERE JobId = @JobId AND ISNULL(IsPending,'N') <> 'Y'	
		
		--Insertion into failed transaction
		INSERT INTO FailedTransactionDetail (UserId,JobId,Hash,Amount,TransactionType,ProcessType,IsApproved,CreatedDate,ModifiedDate)
		(SELECT UserId,JobId,Hash,Amount,TransactionType,ProcessType,IsApproved,CreatedDate,ModifiedDate FROM TransactionDetail WHERE  JobId = @JobId 
		AND ProcessType = 'D')
		
		--Notification send
		DECLARE @UserId INT,@JobTitle NVARCHAR(200),@Notification NVARCHAR(300),@Url NVARCHAR(50)	
		SELECT @UserId =UserId,@JobTitle = JobTitle FROM Job WHERE JobId = @JobId
		
		SET @Url = CAST('/Jobs/Details/' + CAST(@JobId AS NVARCHAR(50)) AS NVARCHAR(50))
		SET @Notification = 'Your transaction for ' + @JobTitle + ' has failed and your job has been relisted.'
		INSERT INTO MatchBXNotification VALUES (@UserId,@UserId,@Notification,0,'Transaction Failed',GETDATE(),@Url)
	END
		
	--DELETE FROM TransactionDetail WHERE JobId = @JobId AND ProcessType = 'D'		
END
GO



