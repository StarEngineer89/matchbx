--Created by    :	Sanu Mohan P
--Created Date  :	20-01-2019
--Purpose       :	Reminder mails gig

--EXEC spReviewReminderMailsGig 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spReviewReminderMailsGig')
DROP procedure spReviewReminderMailsGig
GO
CREATE PROCEDURE [spReviewReminderMailsGig]

AS
BEGIN
	SELECT
		GigTitle,
		J.GigId,
		CONVERT(NVARCHAR(15),J.CreatedDate,106) AS 'CreatedDateDisplay',
		(SELECT TOP 1 Email = ISNULL(STUFF((
		SELECT  ', ' + a.Email
		FROM Users AS a		
		WHERE a.UserType = 4 AND IsActive = 1
		FOR XML PATH, TYPE).value(N'.[1]', N'varchar(max)'), 1, 2, ''),'')
	FROM Users AS j) AS Email
	FROM Gig J
	LEFT JOIN ReminderMailsGig RM ON RM.GigId = J.GigId
	WHERE IsActive = 'N' and GigStatus = 'R'
	AND CASE 
		WHEN ISNULL(RM.GigId,0) = 0 THEN DATEDIFF(HOUR,J.CreatedDate,GETDATE()) ELSE 
		DATEDIFF(HOUR,RM.ModifiedDate,GETDATE())END > 24
END
GO



