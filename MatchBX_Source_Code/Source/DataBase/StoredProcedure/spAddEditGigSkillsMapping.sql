--Created by    :Sanu Mohan P
--Created Date  :1/7/2019 3:06:14 PM
--Purpose      :Model,Business classes

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditGigSkillsMapping')
DROP procedure spAddEditGigSkillsMapping
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditGigSkillsMapping
(
	@GigSkillsMappingId  int,
	@GigId  int,
	@SkillsId  int,
	@CreatedDate  datetime,
	@ModifiedDate  datetime
)
AS
IF(@GigSkillsMappingId=0)
BEGIN
	INSERT  INTO GigSkillsMapping 
	(
	  GigId,
	  SkillsId,
	  CreatedDate,
	  ModifiedDate
	)
	VALUES 
	(
	  @GigId,
	  @SkillsId,
	  GETDATE(),
	  GETDATE()
	)
    SELECT MAX(GigSkillsMappingId) AS GigSkillsMappingId  FROM GigSkillsMapping

END
ELSE
BEGIN
   UPDATE GigSkillsMapping SET
    GigId	=  @GigId,
    SkillsId	=  @SkillsId,    
    ModifiedDate	=  GETDATE()
    WHERE GigSkillsMappingId	=  @GigSkillsMappingId
   SELECT @GigSkillsMappingId as GigSkillsMappingId
END
GO
