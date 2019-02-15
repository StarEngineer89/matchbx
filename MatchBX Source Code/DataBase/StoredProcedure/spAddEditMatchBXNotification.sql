--Created by    :Sanu Mohan P
--Created Date  :7/27/2018 4:46:52 PM
--Purpose      :MatchBX notifications

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditMatchBXNotification')
DROP procedure spAddEditMatchBXNotification
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditMatchBXNotification
(
	@MatchBXNotificationId  int,
	@SenderId  int,
	@ReceiverId  int,
	@Notification  nvarchar(max),
	@ReadStatus  bit,
	@Header nvarchar(max),
	@Url NVARCHAR(50)
)
AS
IF(@MatchBXNotificationId=0)
BEGIN
	INSERT  INTO MatchBXNotification 
	(
	  SenderId,
	  ReceiverId,
	  Notification,
	  ReadStatus,
	  Header,
	  CreatedTime,
	  Url
	)
	VALUES 
	(
	  @SenderId,
	  @ReceiverId,
	  @Notification,
	  @ReadStatus,
	  @Header,
	  GETDATE(),
	  @Url
	)
    SELECT MAX(MatchBXNotificationId) AS MatchBXNotificationId  FROM MatchBXNotification

END
ELSE
BEGIN
   UPDATE MatchBXNotification SET
    SenderId	=  @SenderId,
    ReceiverId	=  @ReceiverId,
    Notification	=  @Notification,
    ReadStatus	=  @ReadStatus,
    Header	=	@Header,
    Url = @Url
    WHERE MatchBXNotificationId	=  @MatchBXNotificationId
   SELECT @MatchBXNotificationId as MatchBXNotificationId
END
GO
