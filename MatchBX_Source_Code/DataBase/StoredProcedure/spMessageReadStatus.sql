--Created by    :	Sanu Mohan P
--Created Date  :	03-08-2018
--Purpose       :	Manage jobs

--EXEC spMessageReadStatus 1,2,0

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spMessageReadStatus')
DROP procedure spMessageReadStatus
GO
CREATE PROCEDURE [spMessageReadStatus]
(
	@SendUserId  INT,
	@ReceiverId INT,
	@ReadStatus BIT
)
AS
BEGIN

	UPDATE MatchBXMessage SET ReadStatus = @ReadStatus WHERE SendUserId = @SendUserId  AND ReceiverId = @ReceiverId
	SELECT @ReceiverId 

END
GO



