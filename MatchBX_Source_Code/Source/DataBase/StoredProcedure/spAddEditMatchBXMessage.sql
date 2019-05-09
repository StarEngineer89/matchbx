--Created by    :Prazeed
--Created Date  :7/21/2018 3:24:43 PM
--Purpose      :Messgae

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditMatchBXMessage')
DROP procedure spAddEditMatchBXMessage
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditMatchBXMessage
(
@MatchBXMessageId  int,
@SendUserId  int,
@ReceiverId  int,
@Message  nvarchar(1000),
@ReadStatus  bit,
@IsMailSent int,
@MessageType char(2),
@FileSize FLOAT,
@FileName NVARCHAR(1000),
@JobId INT
)
AS
IF(@MatchBXMessageId=0)
BEGIN
	INSERT  INTO MatchBXMessage 
	(
	  SendUserId,
	  ReceiverId,
	  Message,
	  ReadStatus,
	  CreatedDatetime,
	  MessageType,
	  FileSize,
	  FileName,
	  JobId
	)
	VALUES 
	(
	  @SendUserId,
	  @ReceiverId,
	  @Message,
	  @ReadStatus,
	  GETDATE(),
	  @MessageType,
	  @FileSize,
	  @FileName,
	  @JobId
	)
    SELECT MAX(MatchBXMessageId) AS MatchBXMessageId  FROM MatchBXMessage

END
ELSE
BEGIN
   UPDATE MatchBXMessage SET
    --SendUserId	=  @SendUserId,
    --ReceiverId	=  @ReceiverId,
    --Message	=  @Message,
    ReadStatus	=  @ReadStatus,
	IsMailSent=@IsMailSent
    WHERE MatchBXMessageId	=  @MatchBXMessageId
   SELECT @MatchBXMessageId as MatchBXMessageId
END
GO