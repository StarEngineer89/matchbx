--Created by    :Sanu Mohan P
--Created Date  :1/7/2019 3:06:15 PM
--Purpose      :Model,Business classes

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGigTrendingTagsMapping')
DROP procedure spAddEditGigTrendingTagsMapping
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGigTrendingTagsMapping
(
	@GigTrendingTagsMappingId  int,
	@GigId  int,
	@TrendingTagsId  int,
	@CreatedDate  datetime,
	@ModifiedDate  datetime
)
AS
IF(@GigTrendingTagsMappingId=0)
BEGIN
	INSERT  INTO GigTrendingTagsMapping 
	(
	  GigId,
	  TrendingTagsId,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @GigId,
	  @TrendingTagsId,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(GigTrendingTagsMappingId) AS GigTrendingTagsMappingId  FROM GigTrendingTagsMapping

END
ELSE
BEGIN
   UPDATE GigTrendingTagsMapping SET
    GigId	=  @GigId,
    TrendingTagsId	=  @TrendingTagsId,   
    ModifiedDate	=  GETDATE()
    WHERE GigTrendingTagsMappingId	=  @GigTrendingTagsMappingId
   SELECT @GigTrendingTagsMappingId as GigTrendingTagsMappingId
END
GO
