--Created by    :Sanu Mohan P
--Created Date  :6/25/2018 12:51:41 PM
--Purpose      :MatchBX

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditUserProfile')
DROP procedure spAddEditUserProfile
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditUserProfile
(
@UserProfileId  int,
@UserId  int,
@ProfilePic  nvarchar(400),
@Bio  nvarchar(2000),
@Rating  decimal(9)
)
AS
IF(@UserProfileId=0)
BEGIN
	INSERT  INTO UserProfile 
	(
	  UserId,
	  ProfilePic,
	  Bio,
	  Rating,
	  CreatedDate
	)
	VALUES 
	(
	  @UserId,
	  CASE WHEN @ProfilePic = '' THEN NULL ELSE @ProfilePic END,	  
	  @Bio,
	  @Rating,
	  GETDATE()
	)
    SELECT MAX(UserProfileId) AS UserProfileId  FROM UserProfile

END
ELSE
BEGIN
   UPDATE UserProfile SET
    UserId	=  @UserId,
    ProfilePic	=  CASE WHEN @ProfilePic = '' THEN NULL ELSE @ProfilePic END,
    Bio	=  @Bio,
    Rating	=  @Rating,
    ModifiedDate = GETDATE()
    WHERE UserProfileId	=  @UserProfileId
   SELECT @UserProfileId as UserProfileId
END
GO
