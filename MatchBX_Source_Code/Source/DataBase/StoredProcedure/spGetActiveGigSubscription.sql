
--Created by    :	Sanu Mohan P
--Created Date  :	25-02-2019
--Purpose       :	To get subscription details against Gig

--EXEC spGetActiveGigSubscription 21

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetActiveGigSubscription')
DROP procedure spGetActiveGigSubscription
GO
CREATE PROCEDURE [spGetActiveGigSubscription]
(	 
	@GigId int
)
AS
BEGIN
	SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedPoster
	FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

	SELECT 
		GS.GigSubscriptionId,
		GS.GigId,
		ISNULL(J.JobId,0) AS JobId,
		GS.Title,
		GS.Description,
		GS.GigSubscriptionStatus,
		ISNULL(J.JobStatus,'') AS JobStatus,
		CASE WHEN GS.GigSubscriptionStatus = 'A' THEN 'Pending Payment' 
			 WHEN ISNULL(J.JobStatus,'') = 'B' THEN 'Pending Payment'
			 WHEN ISNULL(J.JobStatus,'') = 'A' THEN 'In Progress' END AS 'Status',
		COALESCE(U.FullName,'@'+U.UserName) AS PosterFullName,
		ISNULL(UP.ProfilePic,'/Content/images/user.png') AS PosterProfilePic,
		GS.JobPosterId,
		ISNULL(JCP.TotalJobs,0) AS 'JobsCompleted',
		GS.CreatedDate AS [PurchasedDate],
		CONVERT(NVARCHAR(20),GS.CreatedDate,106) AS [PurchasedDateDisplay],
		GS.JobCompletionDate,
		CONVERT(NVARCHAR(20),GS.JobCompletionDate,106) AS [JobCompletionDateDisplay],
		ISNULL(J.JobStatusSeeker,'') AS JobStatusSeeker	
	FROM GigSubscription GS
	INNER JOIN Gig G ON GS.GigId = G.GigId
	INNER JOIN Users U ON U.UserId = GS.JobPosterId
	LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
	LEFT JOIN Job J ON ISNULL(J.GigSubscriptionId,0) = GS.GigSubscriptionId
	LEFT JOIN #JobCompletedPoster JCP ON JCP.UserId = U.UserId
	WHERE GS.GigId = @GigId AND GigSubscriptionStatus IN ('A','J') AND ISNULL(J.JobStatus,'') <> 'C'

	DROP TABLE #JobCompletedPoster		
END
GO



