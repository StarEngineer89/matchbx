--Created by    :	Sanu Mohan P
--Created Date  :	14-08-2018
--Purpose       :	Job details analytics

--EXEC spAnalyticsJobDetail

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAnalyticsJobDetail')
DROP procedure spAnalyticsJobDetail
GO
CREATE PROCEDURE [spAnalyticsJobDetail]
AS
BEGIN

SELECT 
    J.JobId,
    J.JobCategoryId,
    J.UserId,
    J.JobTitle,
    J.JobDescription,
    J.BudgetASP AS 'AXPComp',
    J.Commission AS 'ComComp',
    J.TotalBudget,
    J.JobCompletionDate,
    J.IsActive,
    J.JobStatus,
    J.CreatedDate,
    J.ModifiedDate,
    J.JobSeekerId,
    J.JobReferanceId,
    J.JobPosterRating,
    J.JobSeekerRating,
    J.JobStatusSeeker,
    J.CancelReason,
    JC.Category AS 'JobCategory',
    COALESCE(U.FullName,'@'+U.UserName) AS Poster,    
    J.Commission AS 'ComComp',		
    J.BudgetASP AS 'AXPComp'
FROM Job J
INNER JOIN JobCategory JC ON JC.JobCategoryId = J.JobCategoryId
INNER JOIN Users U ON U.UserId = J.UserId
		
END
GO



