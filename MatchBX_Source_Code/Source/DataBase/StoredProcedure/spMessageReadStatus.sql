--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	Manage jobs

--EXEC spMessageReadStatus 2,1,1

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spMessageReadStatus')
DROP procedure spMessageReadStatus
GO
CREATE PROCEDURE [spMessageReadStatus]
(
	@SendUserId  INT,
	@ReceiverId INT,
	@ReadStatus BIT,
	@JobId INT
)
AS
BEGIN

	UPDATE MatchBXMessage SET ReadStatus = @ReadStatus WHERE SendUserId = @ReceiverId  AND ReceiverId = @SendUserId AND ISNULL(JobId,0)=@JobId
	SELECT @ReceiverId 

END
GO



