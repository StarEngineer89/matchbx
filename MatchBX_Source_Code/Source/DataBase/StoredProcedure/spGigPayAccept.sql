--Created by    :	Sanu Mohan P
--Created Date  :	16-01-2019
--Purpose       :	Gig payment 

--EXEC spGigPayAccept 2,2,'D'

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGigPayAccept')
DROP procedure spGigPayAccept
GO
CREATE PROCEDURE [spGigPayAccept]
(	 
	@GigSubscriptionId int,
	@Status char(1)		
)
AS
BEGIN

	IF(@Status = 'A')
	BEGIN
		DECLARE @JobRefId INT,@Action char(1),@JobReferanceId NVARCHAR(20),@JobId INT	
		
		--Creating job
		
		SELECT @JobRefId = JobReferanceNo FROM JobReferance WHERE JobReferanceId = 1
		SELECT @JobReferanceId = 'JOB'+ CAST((@JobRefId) AS NVARCHAR(20))
		UPDATE JobReferance SET JobReferanceNo = @JobRefId + 1  WHERE JobReferanceId = 1
		
		IF NOT EXISTS(SELECT 1 FROM Job WHERE ISNULL(GigSubscriptionId,0) = @GigSubscriptionId)
		BEGIN
			INSERT INTO Job 
			(	JobCategoryId,			UserId,				JobTitle,		JobDescription,		BudgetASP,			Commission,		TotalBudget,	

				JobCompletionDate,		IsActive,			JobStatus,		CreatedDate,		ModifiedDate,		JobSeekerId,	JobReferanceId,

				JobStatusSeeker,		GigSubscriptionId
			)
			SELECT 
				G.JobCategoryId,		GS.JobPosterId,		GS.Title,		GS.Description,		G.BudgetASP,		G.Commission,	G.BudgetASP + G.Commission,

				GS.JobCompletionDate,	'N',				'B',			GETDATE(),			GETDATE(),			NULL,		@JobReferanceId,
				
				NULL,					GS.GigSubscriptionId
			FROM GigSubscription GS
			INNER JOIN Gig G ON GS.GigId = G.GigId
			WHERE GS.GigSubscriptionId = @GigSubscriptionId
		END		
		
		SELECT JobId FROM Job where GigSubscriptionId = @GigSubscriptionId
	END
	ELSE
	BEGIN
		UPDATE GigSubscription SET GigSubscriptionStatus = 'R' WHERE GigSubscriptionId = @GigSubscriptionId
		SELECT 0 AS JobId
	END
	
END
GO



