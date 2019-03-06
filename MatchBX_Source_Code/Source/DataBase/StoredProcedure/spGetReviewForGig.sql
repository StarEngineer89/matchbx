
--Created by    :	Sanu Mohan P
--Created Date  :	09-01-2019
--Purpose       :	To get review against a gig

--EXEC spGetReviewForGig 15

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetReviewForGig')
DROP procedure spGetReviewForGig
GO
CREATE PROCEDURE [spGetReviewForGig]
(	 
	@GigId int
)
AS
BEGIN

SELECT
	GigId,
	GR.JobId,
	Review,
	GigReviewId,
	GR.CreatedDate,
	CONVERT(nvarchar(15),GR.CreatedDate,106) AS 'CreatedDateDisplay',
	JobSeekerRating,
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,
	ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
	CAST(JobSeekerRating AS int) AS JobSeekerRatingInt
FROM GigReview GR
INNER JOIN Job J ON GR.JobId = J.JobId
INNER JOIN Users U ON U.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
WHERE GigId = @GigId AND GigReviewStatus = 'P'
		
END
GO



