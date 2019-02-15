--Created by    :Sanu Mohan P
--Created Date  :6/25/2018 5:12:51 PM
--Purpose      :Trending Tags 

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditTrendingTags')
DROP procedure spAddEditTrendingTags
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditTrendingTags
(
	@TrendingTagsId  int,
	@Description  nvarchar(2000),
	@JobCategoryId  int,
	@TagType CHAR(1)
)
AS
IF(@TrendingTagsId=0)
BEGIN
	INSERT  INTO TrendingTags 
	(
	  Description,
	  JobCategoryId,
	  TagType
	)
	VALUES 
	(
	  @Description,
	  @JobCategoryId,
	  @TagType
	)
    SELECT MAX(TrendingTagsId) AS TrendingTagsId  FROM TrendingTags

END
ELSE
BEGIN
   UPDATE TrendingTags SET
    Description	=  @Description,
    JobCategoryId	=  @JobCategoryId,
    TagType = @TagType
    WHERE TrendingTagsId	=  @TrendingTagsId
   SELECT @TrendingTagsId as TrendingTagsId
END
GO
