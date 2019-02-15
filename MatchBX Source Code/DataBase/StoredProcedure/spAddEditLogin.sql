--Created by    :Sanu Mohan P
--Created Date  :6/20/2018 1:16:26 PM
--Purpose      :Add edit login

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditLogin')
DROP procedure spAddEditLogin
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditLogin
(
	@LoginId  int,
	@UserId  int,
	@LoginDate  datetime,	
	@IPAddress  nvarchar(200),
	@LogoutDate  datetime	,
	@HubId nvarchar(500)
)
AS
IF(@LoginId=0)
BEGIN
	INSERT  INTO Login 
	(
	  UserId,
	  LoginDate,	  
	  IPAddress,
	  LogoutDate,
	  HubId	 
	)
	VALUES 
	(
	  @UserId,
	  GETDATE(),	  
	  @IPAddress,
	  @LogoutDate,
	  @HubId	 
	)
    SELECT MAX(LoginId) AS LoginId  FROM Login

END
ELSE
BEGIN
   UPDATE Login SET
    UserId	=  @UserId,
    --LoginDate	=  @LoginDate,    
    --IPAddress	=  @IPAddress,
    LogoutDate	=  GETDATE()    
    WHERE LoginId	=  @LoginId
   SELECT @LoginId as LoginId
END
GO
