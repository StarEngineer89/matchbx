--Created by    :	Praveen K
--Created Date  :	02-05-2019
--Purpose       :	To get Job and JobPoster Details

--EXEC spGetJobAndPosterDetails 301,143


IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spGetJobAndPosterDetails')
DROP procedure spGetJobAndPosterDetails
GO
CREATE PROCEDURE spGetJobAndPosterDetails
(	
	@JobId int,
	@UserId int
)
AS
BEGIN

SELECT 
	J.*, 
	COALESCE(U.FullName, '@'+U.UserName) AS FullName,
	U.Email
FROM Job J
CROSS JOIN (SELECT * FROM Users WHERE UserId=@UserId) U
WHERE JobId=@JobId
	
END
GO






