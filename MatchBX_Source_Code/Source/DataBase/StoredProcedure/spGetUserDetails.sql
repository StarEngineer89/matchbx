--Created by    :	Sanu Mohan P
--Created Date  :	26-07-2018
--Purpose       :	Load user details for Login 

--EXEC spGetUserDetails 'tom@lsg.com','qwertyui1!'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetUserDetails')
DROP procedure spGetUserDetails
GO
CREATE PROCEDURE [spGetUserDetails]
(	 
	@Email nvarchar(50),
	@Password nvarchar(50)		
)
AS
BEGIN
declare @MessageStatus char
set @MessageStatus='N'
if exists (select * from users U inner join MatchBXMessage M on U.UserId=M.ReceiverId and ReadStatus=0 and ISNULL(JobId,0)=0 where email = @Email AND cast(decryptbypassphrase('matchbox',Password) as nvarchar(200)) = @Password )
begin
set @MessageStatus='Y'
end

declare @ProjectMsgStatus char
set @ProjectMsgStatus='N'
if exists (select * from users U inner join MatchBXMessage M on U.UserId=M.ReceiverId and ReadStatus=0 and JobId is not null and JobId <> 0 where email = @Email AND cast(decryptbypassphrase('matchbox',Password) as nvarchar(200)) = @Password )
begin
set @ProjectMsgStatus='Y'
end

	SELECT
		U.UserId,	
		U.UserName,
		U.FullName,
		U.Email,
		U.IsActive,
		U.UserType,		
		cast(decryptbypassphrase('matchbox',Password) as nvarchar(200)) AS Password,
		ISNULL(U.BlockReason,0)	AS BlockReason,
		CASE WHEN ISNULL(X.ReceiverId,0) <> 0 THEN 'Y' ELSE 'N' END AS [NotificationStatus]		,
		@MessageStatus as MessageStatus,
		@ProjectMsgStatus as ProjectMsgStatus	
	FROM Users U
	LEFT JOIN (SELECT ReceiverId FROM MatchBXNotification WHERE ReadStatus = 0 GROUP BY ReceiverId HAVING COUNT(ReceiverId) > 0)X ON X.ReceiverId = U.UserId	 
	WHERE Email = @Email AND cast(decryptbypassphrase('matchbox',Password) as nvarchar(200)) = @Password	
	AND IsActive = 1	
END
GO



