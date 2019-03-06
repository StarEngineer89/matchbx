--Created by    :Sanu Mohan P
--Created Date  :6/20/2018 1:16:54 PM
--Purpose      :Add edit users

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditUsers')
DROP procedure spAddEditUsers
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditUsers
(
	@UserId  int,
	@UserName  nvarchar(200),
	@Password  nvarchar(200),
	@FullName  nvarchar(200),
	@Email  nvarchar(200),
	@IsActive  bit,
	@UserType  char(1),
	@VerifiedPartner char(1),
	@CreatedDate  datetime,
	@ModifiedDate  datetime,
	@RetMsg nvarchar(500) output,
	@BlockReason int,
	@VerificationCode nvarchar(500)
)
AS

--IF(@UserId=0)
--BEGIN
--	IF EXISTS(SELECT 1 FROM Users WHERE UserName = @UserName)
--	BEGIN
--		SET @RetMsg = 'User name already exists'
--		RETURN
--	END
--END
--ELSE
--BEGIN
--	IF EXISTS(SELECT 1 FROM Users WHERE UserName = @UserName AND UserId <> @UserId)
--	BEGIN
--		SET @RetMsg = 'User name already exists'
--		RETURN
--	END
--END

IF(@UserId=0)
BEGIN
	
	INSERT  INTO Users 
	(	 
	  UserName,
	  Password,
	  FullName,	  
	  Email,
	  IsActive,
	  UserType,
	  CreatedDate,
	  BlockReason,
	  VerificationCode,
	  VerifiedPartner
	)
	VALUES 
	(	  
	  @UserName,
	  encryptbypassphrase('matchbox',cast(@Password as varbinary(200))),	  
	  --@FullName,
	  CASE WHEN @FullName = '' THEN NULL ELSE @FullName END,
	  @Email,
	  @IsActive,
	  @UserType,
	  GETDATE(),
	  @BlockReason,
	  @VerificationCode,
	  'N'	  
	)
    SELECT MAX(UserId) AS UserId  FROM Users

END
ELSE
BEGIN
   UPDATE Users SET    
    UserName	=  @UserName,
    Password	=  encryptbypassphrase('matchbox',cast(@Password as varbinary(200))),    
    --FullName	=  @FullName,
    FullName = CASE WHEN @FullName = '' THEN NULL ELSE @FullName END,
    Email	=  @Email,
    IsActive	=  @IsActive,
    UserType	=  @UserType,    
    ModifiedDate	=  GETDATE(),
    BlockReason = @BlockReason,
    VerificationCode = @VerificationCode,
    VerifiedPartner = @VerifiedPartner
	WHERE UserId = @UserId
   SELECT @UserId as UserId
END
GO
