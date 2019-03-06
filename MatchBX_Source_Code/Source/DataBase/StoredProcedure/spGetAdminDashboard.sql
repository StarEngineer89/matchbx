--Created by    :	Sanu Mohan P
--Created Date  :	01-08-2018
--Purpose       :	To get details for admin dashboard

--EXEC spGetAdminDashboard 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetAdminDashboard')
DROP procedure spGetAdminDashboard
GO
CREATE PROCEDURE [spGetAdminDashboard]

AS
BEGIN
	SELECT 
		U.UserId,
		'@' + U.UserName AS UserName,
		U.FullName,
		U.Email,
		ISNULL(S.Description,'') AS Skills,
		CASE 
			WHEN U.UserType = 1 THEN 'Job Seeker'
			WHEN U.UserType = 2 THEN 'Job Poster'
			WHEN U.UserType = 3 THEN 'Dual'
		END AS Role,
		CASE 
			WHEN U.UserType = 1 THEN -1
			ELSE ISNULL(X.TotalJobs,0) END AS JobsListed,
		CASE 
			WHEN U.UserType = 2 THEN -1
			ELSE ISNULL(Y.TotalJobs,0) END AS JobsBidon,
		ISNULL(A.TotalJobs,0) + ISNULL(B.TotalJobs,0) AS JobsCompleted,	
		ISNULL(C.TotalJobs,0) + ISNULL(D.TotalJobs,0) AS JobsinProgress,
		CASE
			WHEN U.IsActive = 0 THEN 'UnBlock' ELSE 'Block' END AS UserStatus,
		U.VerifiedPartner
	FROM Users U
	LEFT JOIN UserSkillsMapping USM ON U.UserId = USM.UserId	
	LEFT JOIN Skills S ON S.SkillsId = USM.SkillsId
	LEFT JOIN (SELECT UserId,COUNT(UserId) AS 'TotalJobs' FROM Job WHERE IsActive = 'Y' AND JobStatus IN ('P','B') GROUP BY UserId) X ON X.UserId = U.UserId		
	LEFT JOIN (SELECT UserId,COUNT(UserId) AS 'TotalJobs' FROM JobBidding WHERE IsActive = 'Y' GROUP BY UserId) Y ON Y.UserId = U.UserId
	LEFT JOIN (SELECT UserId,COUNT(UserId) AS 'TotalJobs' FROM Job WHERE IsActive = 'Y' AND JobStatus = 'C' GROUP BY UserId) A ON A.UserId = U.UserId
	LEFT JOIN (SELECT JobSeekerId,COUNT(JobSeekerId) AS 'TotalJobs' FROM Job WHERE IsActive = 'Y' AND JobStatusSeeker = 'C' GROUP BY JobSeekerId) B ON B.JobSeekerId = U.UserId
	LEFT JOIN (SELECT UserId,COUNT(UserId) AS 'TotalJobs' FROM Job WHERE IsActive = 'Y' AND JobStatus = 'A' GROUP BY UserId) C ON C.UserId = U.UserId
	LEFT JOIN (SELECT JobSeekerId,COUNT(JobSeekerId) AS 'TotalJobs' FROM Job WHERE IsActive = 'Y' AND JobStatusSeeker = 'A' GROUP BY JobSeekerId) D ON D.JobSeekerId = U.UserId
END
GO



