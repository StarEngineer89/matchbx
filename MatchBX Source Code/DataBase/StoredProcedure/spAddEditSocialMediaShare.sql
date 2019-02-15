--Created by    :Sanu Mohan P
--Created Date  :7/31/2018 11:29:35 AM
--Purpose      :Social media share

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditSocialMediaShare')
DROP procedure spAddEditSocialMediaShare
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditSocialMediaShare
(
@SocialMediaShareId  int,
@JobId  int,
@UserId  int,
@FBShare  char(1),
@TwitterShare  char(1)
)
AS
IF(@SocialMediaShareId=0)
BEGIN
	INSERT  INTO SocialMediaShare 
	(
	  JobId,
	  UserId,
	  FBShare,
	  TwitterShare
	)
	VALUES 
	(
	  @JobId,
	  @UserId,
	  @FBShare,
	  @TwitterShare
	)
    SELECT MAX(SocialMediaShareId) AS SocialMediaShareId  FROM SocialMediaShare

END
ELSE
BEGIN
   UPDATE SocialMediaShare SET
    JobId	=  @JobId,
    UserId	=  @UserId,
    FBShare	=  @FBShare,
    TwitterShare	=  @TwitterShare
    WHERE SocialMediaShareId	=  @SocialMediaShareId
   SELECT @SocialMediaShareId as SocialMediaShareId
END
GO
