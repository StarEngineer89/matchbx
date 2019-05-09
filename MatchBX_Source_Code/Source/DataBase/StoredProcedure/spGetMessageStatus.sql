--Created by    :	Praveen K
--Created Date  :	03-04-2019
--Purpose       :	Check message read status 

--EXEC spGetMessageStatus 2

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetMessageStatus')
DROP procedure spGetMessageStatus
GO
CREATE PROCEDURE spGetMessageStatus
(	 
	@UserId int		
)
AS
BEGIN
declare @MessageStatus char
set @MessageStatus='N'
if exists (select * from MatchBXMessage where ReceiverId=@UserId and ReadStatus=0 and ISNULL(JobId,0)=0 )
begin
set @MessageStatus='Y'
end

declare @ProjectMsgStatus char
set @ProjectMsgStatus='N'
if exists (select * from MatchBXMessage where ReceiverId=@UserId and ReadStatus=0 and JobId is not null and JobId <> 0 )
begin
set @ProjectMsgStatus='Y'
end

	SELECT
		@MessageStatus as MessageStatus,
		@ProjectMsgStatus as ProjectMsgStatus	
	
END
GO



