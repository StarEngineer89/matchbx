--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkills 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetChatMessage')
DROP procedure spGetChatMessage
GO
CREATE PROCEDURE [spGetChatMessage]
(	 
	@ReceiverId int,
	@SendUserId int,
	@JobId INT
)
AS
BEGIN

DECLARE @IsOnline varchar(50)
DECLARE @Room int
----------assign room for chat----------------------------------
if(@ReceiverId<@SendUserId)
BEGIN
SET @Room=cast ((cast(@ReceiverId as varchar(50))+cast(@SendUserId as varchar(50)) )as int)
END
else
BEGIN
SET @Room=cast ((cast(@SendUserId as varchar(50))+cast(@ReceiverId as varchar(50)) )as int)
END
----------------------------------------------------------------
update MatchBXMessage set ReadStatus=1 where ReceiverId=@ReceiverId and [SendUserId ]=@SendUserId

set @IsOnline=(select top 1 case when LogoutDate is null then 'Online' else 'Active '+dbo.fnChatTimeStamp(LogoutDate) end as IsOnline from login where UserId=@SendUserId order by LoginDate desc)


select A.MatchBXMessageId,A.Message,A.ReadStatus,A.ReceiverId,A.SendUserId as SendUserId,dbo.fnChatTimeStamp(A.CreatedDateTime) CreatedDateTime,
B.UserName as ReceiverName,C.UserName as SendUserName,@IsOnline IsOnline  ,@Room RoomId,ISNULL(MessageType,'M') AS MessageType,
ISNULL(FileSize,0) AS FileSize,ISNULL(FileName,'') AS FileName,ISNULL(JobId,0) AS JobId
from MatchBXMessage A 
left join Users B on A.ReceiverId =B.UserId
left join Users C on A.SendUserId=C.UserId
where (ReceiverId=@ReceiverId or @ReceiverId=0 or SendUserId=@ReceiverId) and (SendUserId=@SendUserId or @SendUserId=0 or ReceiverId=@SendUserId)
and (ISNULL(JobId,0)= CASE WHEN @JobId = 0 THEN 0 ELSE @JobId END)
		
END
GO