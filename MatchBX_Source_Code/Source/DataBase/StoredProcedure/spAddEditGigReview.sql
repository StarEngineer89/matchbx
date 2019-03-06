--Created by    :Sanu Mohan P
--Created Date  :2/6/2019 5:58:59 PM
--Purpose      :Gig review

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGigReview')
DROP procedure spAddEditGigReview
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGigReview
(
	@GigReviewId  int,
	@JobId  int,
	@GigId  int,
	@Review  nvarchar(2000),
	@GigReviewStatus  char(1)
)
AS
IF(@GigReviewId=0)
BEGIN
	INSERT  INTO GigReview 
	(
	  JobId,
	  GigId,
	  Review,
	  GigReviewStatus,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @JobId,
	  @GigId,
	  @Review,
	  @GigReviewStatus,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(GigReviewId) AS GigReviewId  FROM GigReview

END
ELSE
BEGIN
   UPDATE GigReview SET
    JobId	=  @JobId,
    GigId	=  @GigId,
    Review	=  @Review,
    GigReviewStatus	=  @GigReviewStatus,    
    ModifiedDate	=  GETDATE()
    WHERE GigReviewId	=  @GigReviewId
   SELECT @GigReviewId as GigReviewId
END
GO
