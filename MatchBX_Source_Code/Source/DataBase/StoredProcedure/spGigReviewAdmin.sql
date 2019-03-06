
--Created by    :	Sanu Mohan P
--Created Date  :	11-02-2019
--Purpose       :	To get purchased review details

--EXEC spGigReviewAdmin 'N'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGigReviewAdmin')
DROP procedure spGigReviewAdmin
GO
CREATE PROCEDURE [spGigReviewAdmin]
(	 
	@SortBy CHAR(1)
)
AS
BEGIN	

	SELECT
		GR.GigId,
		GR.JobId,
		Review,
		GigReviewId,
		GR.CreatedDate,
		CONVERT(nvarchar(15),GR.CreatedDate,106) AS 'CreatedDateDisplay',
		JobSeekerRating,
		COALESCE(U.FullName,'@'+U.UserName) AS FullName,
		ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
		CAST(JobSeekerRating AS int) AS JobSeekerRatingInt,
		G.GigTitle,
		J.UserId,
		U.Email		
	into #temp	
	FROM GigReview GR
	INNER JOIN Job J ON GR.JobId = J.JobId
	INNER JOIN Users U ON U.UserId = J.UserId
	INNER JOIN Gig G ON G.GigId = GR.GigId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	WHERE GigReviewStatus = 'R'
	
	IF(@SortBy = 'N')
	BEGIN
		SELECT * FROM #temp ORDER BY GigReviewId DESC
	END
	ELSE
	BEGIN
		SELECT * FROM #temp
	END
	
	DROP TABLE #temp
END
GO



