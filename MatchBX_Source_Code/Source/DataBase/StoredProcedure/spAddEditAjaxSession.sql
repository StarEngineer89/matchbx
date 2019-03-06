--Created by    :Sanu Mohan P
--Created Date  :1/18/2019 12:24:47 PM
--Purpose      :Model Business layer 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditAjaxSession')
DROP procedure spAddEditAjaxSession
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditAjaxSession
(
	@AjaxSessionId  int,
	@SessionString  nvarchar(100),
	@UserId INT
)
AS
IF(@AjaxSessionId=0)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM AjaxSession WHERE UserId = @UserId)
	BEGIN 
		INSERT  INTO AjaxSession 
		(
		  SessionString,
		  UserId
		)
		VALUES 
		(
		  @SessionString,
		  @UserId
		)
		SELECT MAX(AjaxSessionId) AS AjaxSessionId  FROM AjaxSession 
    END
    ELSE
    BEGIN
		UPDATE AjaxSession SET SessionString = @SessionString WHERE UserId = @UserId
		SELECT MAX(AjaxSessionId) AS AjaxSessionId  FROM AjaxSession
    END

END
ELSE
BEGIN
   UPDATE AjaxSession SET
    SessionString	=  @SessionString
    WHERE AjaxSessionId	=  @AjaxSessionId
   SELECT @AjaxSessionId as AjaxSessionId
END
GO
