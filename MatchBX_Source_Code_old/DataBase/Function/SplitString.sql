IF EXISTS (SELECT 1 FROM   sys.objects WHERE  object_id = OBJECT_ID(N'[dbo].[SplitString]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION [dbo].[SplitString]
GO
CREATE FUNCTION SplitString
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item int
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT      
      
	  SET @StartIndex = 1
	  IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
	  BEGIN
			SET @Input = @Input + @Character
	  END
 
	  WHILE CHARINDEX(@Character, @Input) > 0
	  BEGIN
			SET @EndIndex = CHARINDEX(@Character, @Input)
           
			INSERT INTO @Output(Item)
			SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
			SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
	  END
	 
      RETURN
END
GO








