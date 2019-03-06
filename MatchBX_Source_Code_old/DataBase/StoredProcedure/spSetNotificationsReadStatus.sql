--Created by    :	Sanu Mohan P
--Created Date  :	27-09-2018
--Purpose       :	To set notification status read

--EXEC spSetNotificationsReadStatus 2

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spSetNotificationsReadStatus')
DROP procedure spSetNotificationsReadStatus
GO
CREATE PROCEDURE [spSetNotificationsReadStatus]
(	 
	@ReceiverId int	
)
AS
BEGIN
	UPDATE MatchBXNotification SET ReadStatus = 1 WHERE ReceiverId = @ReceiverId
	SELECT @ReceiverId AS ReceiverId
END
GO



