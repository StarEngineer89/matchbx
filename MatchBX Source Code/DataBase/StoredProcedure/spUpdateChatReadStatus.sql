--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetSkills 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateChatReadStatus')
DROP procedure spUpdateChatReadStatus
GO
CREATE PROCEDURE [spUpdateChatReadStatus]
(	 
	@ReceiverId int,
	@SendUserId int
)
AS
BEGIN


update MatchBXMessage set ReadStatus=1 where ReceiverId=@ReceiverId and [SendUserId ]=@SendUserId

select top 1 * from MatchBXMessage 
END
GO