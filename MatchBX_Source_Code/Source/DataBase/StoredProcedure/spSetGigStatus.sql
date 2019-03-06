--Created by    :	Praveen K
--Created Date  :	14-001-2019
--Purpose       :	Enable/disable GIG

--EXEC spSetGigStatus

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spSetGigStatus')
DROP procedure spSetGigStatus
GO
CREATE PROCEDURE spSetGigStatus
( 	
	@GigId int,
	@Status nvarchar(100)
)
AS
BEGIN	
	Update Gig set IsGigEnabled=@Status where GigId=@GigId;
	select GigId from Gig where GigId=@GigId;	
END
GO



