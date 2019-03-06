--Created by    :	Praveen K
--Created Date  :	06-02-2019
--Purpose       :	Verify Partner

--EXEC spVerifyPartner

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spVerifyPartner')
DROP procedure spVerifyPartner
GO
CREATE PROCEDURE spVerifyPartner
( 	
	@UserId int,
	@VerifiedPartner nvarchar(100)
)
AS
BEGIN	
	Update Users set VerifiedPartner=@VerifiedPartner where UserId=@UserId;
	select UserId from Users where UserId=@UserId;	
END
GO



