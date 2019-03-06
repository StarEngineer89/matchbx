--Created by    :	Sanu Mohan P
--Created Date  :	09-08-2018
--Purpose       :	Job analytics

--EXEC spJobAnalytics

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spJobAnalytics')
DROP procedure spJobAnalytics
GO
CREATE PROCEDURE [spJobAnalytics]
AS
BEGIN
declare @JobpostersCount int
set @JobpostersCount=(select count(userid) from users where UserType in (2,3))

SELECT 
    J.JobId,
	J.JobReferanceId,
	J.JobTitle,
	CONVERT(nvarchar(15),J.JobCompletionDate,106) AS 'JobCompletionDateDisplay',
	J.JobCompletionDate,
	JC.Category,	
	J.BudgetASP,
	COALESCE(U.FullName,'@'+U.UserName) AS FullName,
	ISNULL(X.NoofBids,0) AS Bids,
	CONVERT(nvarchar(15),J.CreatedDate,106) AS 'CreatedDateDisplay',
	J.CreatedDate	,
	isnull(@JobpostersCount,0) as  TotalJobPosters
FROM Job J
INNER JOIN JobCategory JC ON JC.JobCategoryId = J.JobCategoryId
INNER JOIN Users U ON U.UserId = J.UserId 
LEFT JOIN (SELECT JB.JobId,COUNT(JB.JobId) [NoofBids] FROM JobBidding JB INNER JOIN Job J ON J.JobId = JB.JobId WHERE JB.IsActive = 'Y' 
			AND J.IsActive = 'Y' GROUP BY JB.JobId) X ON X.JobId = J.JobId
WHERE J.IsActive = 'Y'			
ORDER BY J.CreatedDate DESC
		
END
GO



