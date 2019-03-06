--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	Manage jobs

--EXEC spReviewReminderMails 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spReviewReminderMails')
DROP procedure spReviewReminderMails
GO
CREATE PROCEDURE [spReviewReminderMails]

AS
BEGIN
	SELECT
		JobTitle,
		J.JobId,
		CONVERT(NVARCHAR(15),J.CreatedDate,106) AS 'CreatedDateDisplay',
		(SELECT TOP 1 Email = ISNULL(STUFF((
		SELECT  ', ' + a.Email
		FROM Users AS a		
		WHERE a.UserType = 4 AND IsActive = 1
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, ''),'')
	FROM Users AS j) AS Email
	FROM Job J
	LEFT JOIN ReminderMails RM ON RM.JobId = J.JobId
	WHERE IsActive = 'N' and JobStatus = 'R'
	AND CASE 
		WHEN ISNULL(RM.JobID,0) = 0 THEN DATEDIFF(HOUR,J.CreatedDate,GETDATE()) ELSE 
		DATEDIFF(HOUR,RM.ModifiedDate,GETDATE())END > 24
END
GO



