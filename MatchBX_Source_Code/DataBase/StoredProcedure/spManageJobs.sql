--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	Manage jobs

--EXEC spManageJobs

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spManageJobs')
DROP procedure spManageJobs
GO
CREATE PROCEDURE [spManageJobs]
AS
BEGIN

SELECT 
    J.JobId,
	J.JobReferanceId,
	J.JobTitle,
	CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	JC.Category,
	S.Description,
	CASE
		WHEN J.JobStatus = 'P' THEN 'Listed'
		WHEN J.JobStatus = 'B' THEN 'Bid on'
		WHEN J.JobStatus = 'A' THEN 'In Progress'
		WHEN J.JobStatus = 'C' THEN 'Completed'
	END AS [JobStatus],
	J.BudgetASP,
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,
	ISNULL(X.NoofBids,0) AS Bids,
	J.UserId,
	U.Email		
FROM Job J
INNER JOIN JobCategory JC ON JC.JobCategoryId = J.JobCategoryId
LEFT JOIN JobSkillsMapping JSM ON JSM.JobId = J.JobId
LEFT JOIN Skills S ON S.SkillsId = JSM.SkillsId
INNER JOIN Users U ON U.UserId = J.UserId 
LEFT JOIN (SELECT JB.JobId,COUNT(JB.JobId) [NoofBids] FROM JobBidding JB INNER JOIN Job J ON J.JobId = JB.JobId WHERE JB.IsActive = 'Y' 
			AND J.IsActive = 'Y' GROUP BY JB.JobId) X ON X.JobId = J.JobId
WHERE J.IsActive = 'Y'			
--ORDER BY J.CreatedDate DESC
ORDER BY  J.JobId ASC	

END
GO



