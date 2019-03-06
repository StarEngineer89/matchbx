--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	Manage jobs

--EXEC spGigReview 0,'0'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGigReview')
DROP procedure spGigReview
GO
CREATE PROCEDURE [spGigReview]
(
	@JobCategoryId INT,
	@SortBy CHAR(1)
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId into #JobCompletedReview
FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY JobSeekerId

SELECT COUNT(JobId) AS 'TotalJobs',JobSeekerId,GigId into #GigCompletedReview
FROM Job J 
INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
WHERE JobStatus IN ('A','C') AND JobStatusSeeker IN ('A','C') AND J.IsActive = 'Y' GROUP BY JobSeekerId,GigId

SELECT  G.GigID, TrendingTagsIdList= ISNULL(STUFF((
		SELECT  ', ' + a.Description
		FROM TrendingTags AS a
		INNER JOIN GigTrendingTagsMapping AS b
		ON a.TrendingTagsId = b.TrendingTagsId
		WHERE b.GigID = G.GigID
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, ''),'')
INTO #TrendingTagsAuto
FROM Gig AS G;

SELECT  G.GigID, SkillsList= ISNULL(STUFF((
		SELECT  ', ' + a.Description
		FROM Skills AS a
		INNER JOIN GigSkillsMapping AS b
		ON a.SkillsId = b.SkillsId
		WHERE b.GigID = G.GigID
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, ''),'')
INTO #SkillsAuto
FROM Gig AS G;

SELECT GigID,COUNT(GigID) AS NoOfDocuments INTO #GigDocuments
FROM GigDocuments GROUP BY GigID

SELECT 
	GigTitle,
	GigDescription,
	GigDuration,
	G.GigId,
	DATEDIFF(D,G.CreatedDate,GETDATE()) AS 'PostedDays',
	BudgetASP,
	G.UserId,
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
	ISNULL(JR.TotalJobs,0) AS JobsCompleted,
	ISNULL(GR.TotalJobs,0) AS GigsCompleted,
	TTA.TrendingTagsIdList,
	SA.SkillsList,
	ISNULL(GD.NoOfDocuments,0) AS NoOfDocuments,
	G.CreatedDate,
	U.Email,
	CONVERT(nvarchar(15),G.CreatedDate,106) AS 'CreatedDateDisplay'
INTO #GigReview
FROM Gig G
INNER JOIN Users U ON U.UserId = G.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
LEFT JOIN #JobCompletedReview JR ON JR.JobSeekerId = G.UserId
LEFT JOIN #GigCompletedReview GR ON GR.JobSeekerId = G.UserId AND G.GigID = GR.GigID
LEFT JOIN #TrendingTagsAuto TTA ON TTA.GigID = G.GigID
LEFT JOIN #SkillsAuto SA ON SA.GigID = G.GigID
LEFT JOIN #GigDocuments GD ON GD.GigID = G.GigID
WHERE G.IsActive = 'N' AND G.GigStatus = 'R'
AND (G.JobCategoryId = @JobCategoryId OR @JobCategoryId = 0)
ORDER BY  G.GigID ASC	

IF @SortBy = 'N'
BEGIN
	SELECT * FROM #GigReview ORDER BY CreatedDate DESC
END
ELSE
BEGIN
	SELECT * FROM #GigReview ORDER BY CreatedDate ASC
END

DROP TABLE #GigReview
DROP TABLE #GigDocuments
DROP TABLE #GigCompletedReview
DROP TABLE #TrendingTagsAuto
DROP TABLE #SkillsAuto

END
GO



