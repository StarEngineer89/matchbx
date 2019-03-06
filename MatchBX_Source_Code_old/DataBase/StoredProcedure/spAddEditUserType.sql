--Created by    :Sanu Mohan P
--Created Date  :6/20/2018 3:09:17 PM
--Purpose      :Add edit user type

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditUserType')
DROP procedure spAddEditUserType
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditUserType
(
	@UserTypeId  int,
	@UserTypeFlag  char,
	@Description  nvarchar(200)
)
AS
IF(@UserTypeId=0)
BEGIN
	INSERT  INTO UserType 
	(
	  UserTypeFlag,
	  Description
	)
	VALUES 
	(
	  @UserTypeFlag,
	  @Description
	)
    SELECT MAX(UserTypeId) AS UserTypeId  FROM UserType

END
ELSE
BEGIN
   UPDATE UserType SET
    UserTypeFlag	=  @UserTypeFlag,
    Description	=  @Description
    WHERE UserTypeId	=  @UserTypeId
   SELECT @UserTypeId as UserTypeId
END
GO
