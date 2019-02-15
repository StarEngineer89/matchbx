--Created by    :	Sanu Mohan P
--Created Date  :	31-07-2018
--Purpose       :	To get job share details

--EXEC spGetShareDetails 4

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetShareDetails')
DROP procedure spGetShareDetails
GO
CREATE PROCEDURE [spGetShareDetails]
(	 
	@JobId int,
	@UserId int
)
AS
BEGIN

SELECT 
	S.FBShare,
	S.TwitterShare,
	S.JobId,
	S.UserId,
	S.SocialMediaShareId 
FROM SocialMediaShare S
WHERE S.JobId = @JobId AND S.UserId = @UserId

END
GO



