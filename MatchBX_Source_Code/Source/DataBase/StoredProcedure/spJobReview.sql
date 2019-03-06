--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	Manage jobs

--EXEC spJobReview 0,'0'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spJobReview')
DROP procedure spJobReview
GO
CREATE PROCEDURE [spJobReview]
(
	@JobCategoryId INT,
	@SortBy CHAR(1)
)
AS
BEGIN

SELECT COUNT(JobId) AS 'TotalJobs',UserId into #JobCompletedReview
FROM Job WHERE JobStatus = 'C' AND JobStatusSeeker = 'C' AND IsActive = 'Y' GROUP BY UserId

SELECT  j.jobid, TrendingTagsIdList= ISNULL(STUFF((
		SELECT  ', ' + a.Description
		FROM TrendingTags AS a
		INNER JOIN JobTrendingTagsMapping AS b
		ON a.TrendingTagsId = b.TrendingTagsId
		WHERE b.JobId = j.JobId
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, ''),'')
INTO #TrendingTagsAuto
FROM job AS j;

SELECT  j.jobid, SkillsList= ISNULL(STUFF((
		SELECT  ', ' + a.Description
		FROM Skills AS a
		INNER JOIN JobSkillsMapping AS b
		ON a.SkillsId = b.SkillsId
		WHERE b.JobId = j.JobId
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, ''),'')
INTO #SkillsAuto
FROM job AS j;

SELECT JobId,COUNT(JobId) AS NoOfDocuments INTO #JobDocuments
FROM JobDocuments GROUP BY JobId

SELECT 
    J.JobId,
	J.JobReferanceId,
	J.JobTitle,
	J.JobDescription,
	CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	JC.Category,	
	J.BudgetASP,
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
	J.UserId,
	U.Email,
	ISNULL(G.TotalJobs,0) AS JobsCompleted,
	ISNULL(ProfilePic,'/Content/images/user.png') AS ProfilePic,
	J.CreatedDate,
	CONVERT(nvarchar(15),J.CreatedDate,106) AS 'CreatedDateDisplay',
	DATEDIFF(d,J.CreatedDate,getdate()) AS PostedDays,
	TTA.TrendingTagsIdList,
	SA.SkillsList,
	ISNULL(JD.NoOfDocuments,0) AS NoOfDocuments
INTO #JobReview		
FROM Job J
INNER JOIN JobCategory JC ON JC.JobCategoryId = J.JobCategoryId
INNER JOIN Users U ON U.UserId = J.UserId 
LEFT JOIN #JobCompletedReview G ON G.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
LEFT JOIN #TrendingTagsAuto TTA ON TTA.JobId = J.JobId
LEFT JOIN #SkillsAuto SA ON SA.JobId = J.JobId
LEFT JOIN #JobDocuments JD ON JD.JobId = J.JobId
WHERE J.IsActive = 'N' AND J.JobStatus = 'R'			
AND (J.JobCategoryId = @JobCategoryId OR @JobCategoryId = 0)
ORDER BY  J.JobId ASC	

IF @SortBy = 'N'
BEGIN
	SELECT * FROM #JobReview ORDER BY CreatedDate DESC
END
ELSE
BEGIN
	SELECT * FROM #JobReview ORDER BY CreatedDate ASC
END

DROP TABLE #JobReview
DROP TABLE #JobDocuments

END
GO



