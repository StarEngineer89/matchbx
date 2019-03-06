--Created by    :	Sanu Mohan P
--Created Date  :	26-06-2018
--Purpose       :	To get skills for landing page

--EXEC spGetMailInfo 1357

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetMailInfo')
DROP procedure spGetMailInfo
GO
CREATE PROCEDURE [spGetMailInfo]
(	 
	@JobId int	
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Job WHERE JobId = @JobId AND ISNULL(GigSubscriptionId,0) = 0)
	BEGIN
		SELECT
			U.FullName,
			US.UserName,
			J.JobTitle,
			J.JobId,
			U.Email,
			JB.BidAmount
		FROM Job J
		INNER JOIN JobBidding JB ON JB.JobId = J.JobId AND JB.UserId = J.JobSeekerId
		INNER JOIN Users U ON U.UserId = J.JobSeekerId
		INNER JOIN Users US ON US.UserId = J.UserId
		WHERE J.JobId = @JobId
	END
	ELSE
	BEGIN
		SELECT
			U.FullName,
			US.UserName,
			J.JobTitle,
			J.JobId,
			U.Email,
			J.BudgetASP AS 'BidAmount'
		FROM Job J
		INNER JOIN GigSubscription GS ON GS.GigSubscriptionId = J.GigSubscriptionId
		INNER JOIN Users U ON U.UserId = J.JobSeekerId
		INNER JOIN Users US ON US.UserId = J.UserId
		WHERE J.JobId = @JobId
	END		
END
GO



