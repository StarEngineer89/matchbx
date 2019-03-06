--Created by    :	Praveen K
--Created Date  :	15-01-2019
--Purpose       :	Accept/Decline GIG Subscription

--EXEC spAcceptOrDeclineGigSubscription

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAcceptOrDeclineGigSubscription')
DROP procedure spAcceptOrDeclineGigSubscription
GO
CREATE PROCEDURE spAcceptOrDeclineGigSubscription
( 	
	@GigId int,
	@GigSubscriptionId nvarchar(100),
	@GigSubscriptionStatus nvarchar(100)
)
AS
BEGIN	
	Update GigSubscription set GigSubscriptionStatus=@GigSubscriptionStatus where GigSubscriptionId=@GigSubscriptionId and GigId=@GigId;
	select @GigSubscriptionId from GigSubscription where GigSubscriptionId=@GigSubscriptionId;	
END
GO