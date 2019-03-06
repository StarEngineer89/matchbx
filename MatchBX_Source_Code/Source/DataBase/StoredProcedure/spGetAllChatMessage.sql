--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkills 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAllChatMessage')
DROP procedure spGetAllChatMessage
GO
CREATE PROCEDURE [spGetAllChatMessage]
(	 
	@ReceiverId int,
	@SendUserId int
)
AS
BEGIN
declare @UnreadCount int

set @UnreadCount=(select Count(*) from MatchBXMessage where ReceiverId=@ReceiverId and ReadStatus=0)

select A.*,B.UserName as ReceiverName,  case when A.[SendUserId ]=@ReceiverId then B.UserName else C.UserName  end as SendUserName ,
--C.UserName as SendUserName,
	  case when A.[SendUserId ]=@ReceiverId then A.ReceiverId else A.[SendUserId ] end as NewSendUserId into #temp1
 from MatchBXMessage A 
left join Users B on A.ReceiverId =B.UserId
left join Users C on A.SendUserId=C.UserId
where (ReceiverId=@ReceiverId  or SendUserId=@ReceiverId) AND ISNULL(JobId,0) = 0

;with cteLogin as (

select A.*,ROW_NUMBER() over (partition by Userid order by loginid desc) row  from login A 

where LogoutDate is null 
 ) 
 select * into #tempLogin from cteLogin where row=1

;with cte as (

select A.*,ROW_NUMBER() over (partition by NewSendUserId     order by MatchBXMessageId desc) row  from #temp1 A 

where (ReceiverId=@ReceiverId  or SendUserId=@ReceiverId)
 ) 

select A.MatchBXMessageId,A.Message,case when( A.ReadStatus=0 and SendUserId=@ReceiverId) then 1 else A.ReadStatus end as ReadStatus ,A.ReceiverId, NewSendUserId as SendUserId,dbo.fnChatTimeStamp(A.CreatedDateTime) as CreatedDateTime,A.ReceiverName,A.SendUserName,
case when B.ProfilePic is null then '/Content/images/user.png' else B.ProfilePic end as ProfilePic ,L.HubId,@UnreadCount as UnreadCount,b.UserId
from cte A left join UserProfile B on A.NewSendUserId=B.UserId left join #tempLogin L on L.UserId=A.NewSendUserId where A.row=1 order by MatchBXMessageId desc

drop table #temp1	
END
GO