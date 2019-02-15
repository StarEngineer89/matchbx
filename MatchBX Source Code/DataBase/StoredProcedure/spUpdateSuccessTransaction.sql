--Created by    :	Sanu Mohan P
--Created Date  :	25-09-2018
--Purpose       :	To update completed transaction

--EXEC spUpdateSuccessTransaction 1347

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateSuccessTransaction')
DROP procedure spUpdateSuccessTransaction
GO
CREATE PROCEDURE [spUpdateSuccessTransaction]
(	 
	@JobId int,
	@Hash NVARCHAR(1000)	
)
AS
BEGIN	

	DECLARE @UserId INT,@Notification NVARCHAR(300),@JobSeekerName NVARCHAR(300),@NotificationSeeker NVARCHAR(300),@PosterName NVARCHAR(300),
	@JobTitle NVARCHAR(300),@SeekerId INT,@Url NVARCHAR(50)
	
	--Update TransactionDetail
	UPDATE TransactionDetail SET IsApproved = 'Y',Hash = @Hash WHERE JobId = @JobId AND IsApproved = 'N'
	
	--UPDATE TransactionDetail SET IsApproved = 'E' WHERE Hash <> @Hash AND JobId = @JobId
	
	UPDATE JobTransactionHashLog SET Status = 'F' WHERE Hash <> @Hash AND JobId = @JobId
	UPDATE JobTransactionHashLog SET Status = 'Y' WHERE Hash = @Hash AND JobId = @JobId
	
	--Get userid
	SELECT @SeekerId = UserId FROM JobBidding WHERE JobId = @JobId AND ISNULL(IsPending,'N') = 'Y'
	
	--Update Job
	UPDATE Job SET JobStatus = 'A',JobSeekerId = @SeekerId ,JobStatusSeeker='A' WHERE JobId = @JobId
	
	--Update JobBidding
	UPDATE JobBidding SET IsAccepted = 'Y' WHERE JobId = @JobId AND ISNULL(IsPending,'N') = 'Y'
	
	UPDATE JobBidding SET IsActive  = 'N' WHERE JobId = @JobId AND ISNULL(IsPending,'N') <> 'Y'	
	
	--Notification 
	SELECT @UserId =J.UserId,@JobSeekerName = U.UserName,@PosterName = US.FullName,@JobTitle = JobTitle
	FROM Job J
	INNER JOIN Users U ON U.UserId = J.JobSeekerId 
	INNER JOIN Users US ON US.UserId = J.UserID
	WHERE JobId = @JobId
	
	SET @Url = CAST('/Jobs/Details/' + CAST(@JobId AS NVARCHAR(50)) AS NVARCHAR(50))
	
	SET @Notification = 'Good news! Your payment has gone through and funds are now held in escrow.' + @JobSeekerName + ' has been notified and can now start work.'
	INSERT INTO MatchBXNotification VALUES (@UserId,@UserId,@Notification,0,'Transaction Confirmed',GETDATE(),@Url)
	
	SET @NotificationSeeker = @PosterName + ' has accepted your bid for job ' + @JobTitle	
	INSERT INTO MatchBXNotification VALUES (@UserId,@SeekerId,@NotificationSeeker,0,'Bid accepted',GETDATE(),@Url)		
			
END
GO



