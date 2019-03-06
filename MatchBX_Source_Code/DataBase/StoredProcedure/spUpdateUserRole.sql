--Created by    :	Jomon Joseph
--Created Date  :	13-11-2018
--Purpose       :	update user role



IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spUpdateUserRole')
DROP procedure spUpdateUserRole
GO
CREATE PROCEDURE [spUpdateUserRole]
(	 
	
	@UserId int,
	@UserType char(1)	 
)
AS
BEGIN
 update  Users set UserType=@UserType where UserId=@UserId
 select  @UserId
END