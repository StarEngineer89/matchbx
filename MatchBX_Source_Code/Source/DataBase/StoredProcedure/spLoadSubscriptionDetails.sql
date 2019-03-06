--Created by    :	Sanu Mohan P
--Created Date  :	17-01-2019
--Purpose       :	To get subscription details for edit

--EXEC spLoadSubscriptionDetails 52

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spLoadSubscriptionDetails')
DROP procedure spLoadSubscriptionDetails
GO
CREATE PROCEDURE [spLoadSubscriptionDetails]
(	 
	@GigSubscriptionId int
)
AS
BEGIN
	
	SELECT GigSubscriptionId,COUNT(GigSubscriptionId) AS 'NoofDocuments' INTO #GigDocument
	FROM GigSubscriptionDocument WHERE IsActive = 'Y' GROUP BY GigSubscriptionId
	
	SELECT
	 G.GigId,
	 G.UserId,
	 GS.GigSubscriptionId,
	 GS.Description,
	 GS.Title,
	 GS.GigSubscriptionStatus,
	 GS.JobPosterId,
	 G.GigTitle,
	 G.GigDescription,
	 G.BudgetASP,
	 G.Commission,
	 G.TotalBudget,
	 G.GigDuration,
	 ISNULL(GD.NoofDocuments,0) AS NoofDocuments,
	 GS.JobCompletionDate,
	 CONVERT(nvarchar(15),GS.JobCompletionDate,103) AS 'JobCompletionDateDisplay'
	FROM GigSubscription GS
	INNER JOIN Gig G ON GS.GigId = G.GigId
	LEFT JOIN #GigDocument GD ON GD.GigSubscriptionId = GS.GigSubscriptionId
	WHERE GS.GigSubscriptionId = @GigSubscriptionId		
END
GO



