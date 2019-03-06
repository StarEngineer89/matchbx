--Created by    :Sanu Mohan P
--Created Date  :6/25/2018 12:51:41 PM
--Purpose      :MatchBX

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditJobCategory')
DROP procedure spAddEditJobCategory
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditJobCategory
(
@JobCategoryId  int,
@Category  nvarchar(200)
)
AS
IF(@JobCategoryId=0)
BEGIN
	INSERT  INTO JobCategory 
	(
	  Category
	)
	VALUES 
	(
	  @Category
	)
    SELECT MAX(JobCategoryId) AS JobCategoryId  FROM JobCategory

END
ELSE
BEGIN
   UPDATE JobCategory SET
    Category	=  @Category
    WHERE JobCategoryId	=  @JobCategoryId
   SELECT @JobCategoryId as JobCategoryId
END
GO
