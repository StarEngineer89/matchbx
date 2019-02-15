--Created by    :	Sanu Mohan P
--Created Date  :	25-09-2018
--Purpose       :	To update completed transaction

--EXEC spUpdateCancelledTransaction 1347

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateCancelledTransaction')
DROP procedure spUpdateCancelledTransaction
GO
CREATE PROCEDURE [spUpdateCancelledTransaction]
(	 
	@JobId int	
)
AS
BEGIN	

	DECLARE @UserId INT,@Notification NVARCHAR(300),@JobSeekerName NVARCHAR(300),@NotificationSeeker NVARCHAR(300),@PosterName NVARCHAR(300),
	@JobTitle NVARCHAR(300),@SeekerId INT,@Url NVARCHAR(50)
	
	--Update TransactionDetail	
	UPDATE TransactionDetail SET IsApproved = 'C' WHERE JobId = @JobId AND ProcessType = 'D' AND IsApproved = 'N' AND Hash = ''
	
	--Update JobBidding
	UPDATE JobBidding SET IsActive  = 'N' WHERE JobId = @JobId AND ISNULL(IsPending,'N') <> 'Y'
	
	UPDATE JobBidding SET IsPending = 'N' WHERE JobId = @JobId AND ISNULL(IsPending,'N') = 'Y'	
	
	--Notification sending
	SELECT @UserId =UserId,@JobTitle = JobTitle FROM Job WHERE JobId = @JobId
	
	SET @Url = CAST('/Jobs/Details/' + CAST(@JobId AS NVARCHAR(50)) AS NVARCHAR(50))
	SET @Notification = 'Your transaction for ' + @JobTitle + ' has not completed yet. Please reapprove the offer'
	INSERT INTO MatchBXNotification VALUES (@UserId,@UserId,@Notification,0,'Transaction Pending',GETDATE(),@Url)			
			
END
GO



