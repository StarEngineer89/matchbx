--Created by    :	Sanu Mohan P
--Created Date  :	10-08-2018
--Purpose       :	To get notifications

--EXEC spGetNotifications 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetNotifications')
DROP procedure spGetNotifications
GO
CREATE PROCEDURE [spGetNotifications]
(	 
	@ReceiverId int	
)
AS
BEGIN

	SELECT 
		MN.MatchBXNotificationId,
		MN.Notification,
		MN.ReadStatus,
		MN.ReceiverId,
		MN.SenderId,
		COALESCE(US.FullName,'@'+US.UserName) AS SenderFullName,
		COALESCE(UR.FullName,'@'+UR.UserName) AS ReceiverFullName,
		MN.Header,
		dbo.fnChatTimeStamp(MN.CreatedTime) AS CreatedTimeDisplay,
		Url
	FROM MatchBXNotification MN
	INNER JOIN Users US ON US.UserId = MN.SenderId
	INNER JOIN Users UR ON UR.UserId = MN.ReceiverId
	WHERE ReceiverId = @ReceiverId
	ORDER BY CreatedTime DESC
		
END
GO



