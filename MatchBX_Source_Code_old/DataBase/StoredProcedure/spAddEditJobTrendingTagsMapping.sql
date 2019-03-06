--Created by    :Sanu Mohan P
--Created Date  :6/29/2018 12:16:56 PM
--Purpose      :businee class

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobTrendingTagsMapping')
DROP procedure spAddEditJobTrendingTagsMapping
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobTrendingTagsMapping
(
@JobTrendingTagsMappingId  int,
@JobId  int,
@TrendingTagsId  int
)
AS

IF(@JobTrendingTagsMappingId=0)
BEGIN
	INSERT  INTO JobTrendingTagsMapping 
	(
	  JobId,
	  TrendingTagsId
	)
	VALUES 
	(
	  @JobId,
	  @TrendingTagsId
	)
    SELECT MAX(JobTrendingTagsMappingId) AS JobTrendingTagsMappingId  FROM JobTrendingTagsMapping

END
ELSE
BEGIN
   UPDATE JobTrendingTagsMapping SET
    JobId	=  @JobId,
    TrendingTagsId	=  @TrendingTagsId
    WHERE JobTrendingTagsMappingId	=  @JobTrendingTagsMappingId
   SELECT @JobTrendingTagsMappingId as JobTrendingTagsMappingId
END


GO
