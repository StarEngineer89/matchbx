
--Created by    :	Sanu Mohan P
--Created Date  :	09-07-2018
--Purpose       :	Load user profile details

--EXEC spLoadUserProfile 6

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadUserProfile')
DROP procedure spLoadUserProfile
GO
CREATE PROCEDURE [spLoadUserProfile]
(	 
	@UserId int	
)
AS
BEGIN

DECLARE @Rating TABLE
(
	Rating DECIMAL(18,2),
	RatingCount INT,
	UserId INT
)

IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND UserType = 1) -- Job Seeker
BEGIN
	INSERT INTO @Rating
	SELECT SUM(JobSeekerRating)/COUNT(JobSeekerRating),COUNT(JobSeekerRating),JobSeekerId FROM Job WHERE JobSeekerId = @UserId AND IsActive = 'Y'
	AND JobStatus = 'C'	
	GROUP BY JobSeekerId
END

IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND UserType = 2) -- Job Poster
BEGIN
	INSERT INTO @Rating
	SELECT SUM(JobPosterRating)/COUNT(JobPosterRating),COUNT(JobPosterRating),UserId FROM Job WHERE UserId = @UserId AND IsActive = 'Y'
	AND JobStatusSeeker = 'C'
	GROUP BY UserId	
END

IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND UserType = 3) -- Job Poster and Job Seeker
BEGIN
	DECLARE @JobPosterRating DECIMAL(18,3),@JobSeekerRating DECIMAL(18,3),@JobPosterRatingCnt INT,@JobSeekerRatingCnt INT
	SELECT @JobPosterRating = SUM(JobPosterRating),@JobPosterRatingCnt = COUNT(JobPosterRating) FROM Job WHERE UserId = @UserId AND IsActive = 'Y'
	AND JobStatusSeeker = 'C' 
	GROUP BY UserId
	SELECT @JobSeekerRating = SUM(JobSeekerRating),@JobSeekerRatingCnt = COUNT(JobSeekerRating) FROM Job WHERE JobSeekerId = @UserId AND IsActive = 'Y' 	
	AND JobStatus = 'C'
	GROUP BY JobSeekerId
	IF((ISNULL(@JobPosterRatingCnt,0) + ISNULL(@JobSeekerRatingCnt,0)) > 0)
	BEGIN
		INSERT INTO @Rating VALUES ((ISNULL(@JobPosterRating,0) + ISNULL(@JobSeekerRating,0))/(ISNULL(@JobPosterRatingCnt,0) + ISNULL(@JobSeekerRatingCnt,0)),(ISNULL(@JobPosterRatingCnt,0) + ISNULL(@JobSeekerRatingCnt,0)),@UserId)	
	END
	ELSE
	BEGIN
		INSERT INTO @Rating VALUES (0,0,@UserId)	
	END
END

SELECT 
	ISNULL(UP.UserProfileId,'') AS UserProfileId,
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
	ISNULL(UP.Bio,'') AS Bio,
	ISNULL(R.Rating,0) AS Rating,
	ISNULL(R.RatingCount,0) AS RatingCount,
	'@' + U.UserName AS UserName,
	U.FullName,
	U.UserId,
	U.UserType
FROM Users U 
LEFT JOIN UserProfile UP on UP.UserId = U.UserId
LEFT JOIN @Rating R ON R.UserId = U.UserId
WHERE U.UserId = @UserId
		
END
GO





