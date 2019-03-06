
--Created by    :	Sanu Mohan P
--Created Date  :	25-06-2018
--Purpose       :	To get top job poster details

--EXEC spGetTopJobPosters 0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetTopJobPosters')
DROP procedure spGetTopJobPosters
GO
CREATE PROCEDURE [spGetTopJobPosters]
(	 
	@JobCategoryId int
)
AS
BEGIN

SELECT TOP 10	
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,	
	ISNULL(UP.ProfilePic,'/Content/images/user.png') AS ProfilePic,
	COUNT(JobId) AS 'NoOfJobs',
	J.UserId	
FROM Job J
INNER JOIN Users U ON U.UserId = J.UserId
LEFT JOIN UserProfile UP ON UP.UserId = U.UserId
WHERE (J.JobCategoryId = @JobCategoryId OR (@JobCategoryId = 0))
AND J.JobStatus = 'C' AND J.IsActive = 'Y' AND ISNULL(VerifiedPartner,'N') = 'N'
GROUP BY J.UserId,U.FullName,ProfilePic,U.UserName
order by COUNT(JobId) desc
		
END
GO



