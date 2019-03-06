IF EXISTS (SELECT 1 FROM   sys.objects WHERE  object_id = OBJECT_ID(N'[dbo].[fnChatTimeStamp]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION [dbo].[fnChatTimeStamp]
GO
CREATE FUNCTION fnChatTimeStamp
(    
      @DateTime datetime
)
returns varchar(100)
AS
BEGIN
      DECLARE @TimeStamp varchar(100)

	 SET @TimeStamp=( SELECT CASE WHEN   datediff(minute, @DateTime, getdate()) <120 THEN  cast ( datediff(minute, @DateTime, getdate()) as varchar(10))+' mins ago'
            WHEN   datediff(HOUR, @DateTime, getdate()) < 24   THEN  cast ( datediff(HOUR, @DateTime, getdate()) as varchar(10))+' hours ago'
			WHEN   datediff(DAY, @DateTime, getdate()) <  14   THEN  cast ( datediff(DAY, @DateTime, getdate()) as varchar(10)) +' days ago'
			WHEN   datediff(WEEK, @DateTime, getdate()) <  8   THEN  cast ( datediff(WEEK, @DateTime, getdate()) as varchar(10)) +' weeks ago'
			WHEN   datediff(WEEK, @DateTime, getdate()) <  112  THEN  cast ( datediff(MONTH, @DateTime, getdate()) as varchar(10)) +' months ago'
			ELSE  cast (datediff(YEAR, @DateTime, getdate()) as varchar(10)) +' Years ago' end as ChatTimeStamp)
	 
    return  @TimeStamp
END
GO

