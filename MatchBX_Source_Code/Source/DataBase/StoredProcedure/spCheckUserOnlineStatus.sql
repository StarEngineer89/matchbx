--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkills 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spCheckUserOnlineStatus')
DROP procedure spCheckUserOnlineStatus
GO
CREATE PROCEDURE [spCheckUserOnlineStatus]
(	 
	@UserId int,
	@SendUserId int
)
AS
BEGIN

declare @IsMailSent int 
set @IsMailSent=(select top 1 IsMailSent from MatchBXMessage where [SendUserId ]=@UserId and ReceiverId=@SendUserId and ReadStatus=0)
select 
	top 1 L.*, 
	case when LogoutDate is null then 'Online' else 'Active '+dbo.fnChatTimeStamp(LogoutDate) end as IsOnline,
	@IsMailSent as IsMailSent,
	case when U.ProfilePic is null then '/Content/images/user.png' else U.ProfilePic end as ProfilePic 
from login L
left join UserProfile U on U.UserId=L.UserId
where L.UserId=@SendUserId order by LoginDate desc

END
GO