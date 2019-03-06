--Created by    :	Praveen K
--Created Date  :	22-01-2019
--Purpose       :	Cancel GIG Subscription

--EXEC spCancelGigSubscription

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spCancelGigSubscription')
DROP procedure spCancelGigSubscription
GO
CREATE PROCEDURE spCancelGigSubscription
( 	
	@GigId int,
	@GigSubscriptionId nvarchar(100)
)
AS
BEGIN	
	Update GigSubscription set GigSubscriptionStatus='R' where GigSubscriptionId=@GigSubscriptionId and GigId=@GigId;
	select @GigSubscriptionId from GigSubscription where GigSubscriptionId=@GigSubscriptionId;	
END
GO