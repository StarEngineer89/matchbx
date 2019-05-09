
--Purpose		: Create Table UserType
--Date			: 20 June 2018
--Created By	: Sanu Mohan

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserType'))
BEGIN

	CREATE TABLE [dbo].[UserType](
	[UserTypeId] [int] IDENTITY(1,1) NOT NULL,	
	[UserTypeFlag] [char](1) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	CONSTRAINT [UserTypeId] PRIMARY KEY CLUSTERED ([UserTypeId] ASC)) 

END


--Purpose		: Create Table User
--Date			: 20 June 2018
--Created By	: Sanu Mohan

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'Users'))
BEGIN

	CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,	
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,	
	[IsActive] [bit] NULL,	
	[UserType] [char](1) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL   
	
	CONSTRAINT [UserId] PRIMARY KEY CLUSTERED ([UserId] ASC))

END

--Purpose		: Create Table Login
--Date			: 20 June 2018
--Created By	: Sanu Mohan

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'Login'))
BEGIN

	CREATE TABLE [dbo].[Login](
	[LoginId] [int] IDENTITY(1,1) NOT NULL,	
	[UserId] [int],
	[LoginDate] [datetime],	
	[IPAddress] [nvarchar](100),
	[LogoutDate] [datetime]
	
	CONSTRAINT [LoginId] PRIMARY KEY CLUSTERED ([LoginId] ASC),
	CONSTRAINT [FK_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))
END

-- Created By  : Sanu Mohan P
-- Create Date : 20 June 2018
-- Purpose     : Create new table for Error Log

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'ErrorLog'))
BEGIN
   CREATE TABLE [dbo].ErrorLog(
	[ErrorLogId] [int] IDENTITY(1,1) NOT NULL,
	[ErrorDescription] [text] NOT NULL,
	[ErrorReportedOn] [datetime] NOT NULL,
	[ErrorStack] [text] NULL,
	[ErrorSource] [varchar](500) NULL,
	[ErrorMethod][varchar](500) NULL,
	[UserId] [int] NULL	
	
 CONSTRAINT [PK_ErrorLogId] PRIMARY KEY CLUSTERED ([ErrorLogId] ASC)) 

END

-- Created By  : Sanu Mohan P
-- Create Date : 22 June 2018
-- Purpose     : Create new table for JobCategory

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobCategory'))
BEGIN
   CREATE TABLE [dbo].JobCategory(
	[JobCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](100) NOT NULL	
	
 CONSTRAINT [PK_JobCategoryId] PRIMARY KEY CLUSTERED ([JobCategoryId] ASC)) 

END

-- Created By  : Sanu Mohan P
-- Create Date : 22 June 2018
-- Purpose     : Create new table for Job

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'Job'))
BEGIN
   CREATE TABLE [dbo].Job(
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[JobCategoryId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[JobTitle] [nvarchar](30) NOT NULL,
	[JobDescription] [nvarchar](max),
	[BudgetASP] [decimal](18,3),
	[Commission] [decimal](18,3),
	[TotalBudget] [decimal](18,3),
	[JobCompletionDate] [datetime],
	[IsActive] [char](1),
	[JobStatus] [char](1) 	
	
 CONSTRAINT [PK_JobId] PRIMARY KEY CLUSTERED ([JobId] ASC), 
 CONSTRAINT [FK_JobCategoryId] FOREIGN KEY  ([JobCategoryId]) REFERENCES JobCategory(JobCategoryId),
 CONSTRAINT [FK_Job_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 22 June 2018
-- Purpose     : Create new table for UserProfile

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserProfile'))
BEGIN
   CREATE TABLE [dbo].UserProfile(
	[UserProfileId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ProfilePic] [nvarchar](200) null,
	[Bio] [nvarchar](1000) null,
	[Rating] [decimal] null 	
	
 CONSTRAINT [PK_UserProfileId] PRIMARY KEY CLUSTERED ([UserProfileId] ASC),
 CONSTRAINT [FK_UserProfile_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 22 June 2018
-- Purpose     : Create new table for EmailPreference

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'EmailPreference'))
BEGIN
   CREATE TABLE [dbo].EmailPreference(
	[EmailPreferenceId] [int] IDENTITY(1,1) NOT NULL,	
	[Description] [nvarchar](1000) null	 	
	
 CONSTRAINT [PK_EmailPreferenceId] PRIMARY KEY CLUSTERED ([EmailPreferenceId] ASC))

END


-- Created By  : Sanu Mohan P
-- Create Date : 25 June 2018
-- Purpose     : Create new table for Skills

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'Skills'))
BEGIN
   CREATE TABLE [dbo].Skills(
	[SkillsId] [int] IDENTITY(1,1) NOT NULL,	
	[Description] [nvarchar](1000) null,
	[JobCategoryId] [int]	 	
	
 CONSTRAINT [PK_SkillsId] PRIMARY KEY CLUSTERED ([SkillsId] ASC),
 CONSTRAINT [FK_Skills_JobCategoryId] FOREIGN KEY  ([JobCategoryId]) REFERENCES JobCategory(JobCategoryId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 25 June 2018
-- Purpose     : Create new table for TrendingTags

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'TrendingTags'))
BEGIN
   CREATE TABLE [dbo].TrendingTags(
	[TrendingTagsId] [int] IDENTITY(1,1) NOT NULL,	
	[Description] [nvarchar](1000) null,
	[JobCategoryId] [int]	 	
	
 CONSTRAINT [PK_TrendingTagsId] PRIMARY KEY CLUSTERED ([TrendingTagsId] ASC),
 CONSTRAINT [FK_TrendingTags_JobCategoryId] FOREIGN KEY  ([JobCategoryId]) REFERENCES JobCategory(JobCategoryId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 27 June 2018
-- Purpose     : Create new table for JobTrendingTagsMapping

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobTrendingTagsMapping'))
BEGIN
   CREATE TABLE [dbo].JobTrendingTagsMapping(
	[JobTrendingTagsMappingId] [int] IDENTITY(1,1) NOT NULL,	
	[JobId] [int] null,
	[TrendingTagsId] [int]	 	
	
 CONSTRAINT [PK_JobTrendingTagsMappingId] PRIMARY KEY CLUSTERED ([JobTrendingTagsMappingId] ASC),
 CONSTRAINT [FK_JobTrendingTagsMapping_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId),
 CONSTRAINT [FK_JobTrendingTagsMapping_TrendingTagsId] FOREIGN KEY  ([TrendingTagsId]) REFERENCES TrendingTags(TrendingTagsId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 28 June 2018
-- Purpose     : Create new table for JobSkillsMapping

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobSkillsMapping'))
BEGIN
   CREATE TABLE [dbo].JobSkillsMapping(
	[JobSkillsMappingId] [int] IDENTITY(1,1) NOT NULL,	
	[JobId] [int] not null,
	[SkillsId] [int] not null	 	
	
 CONSTRAINT [PK_JobSkillsMappingId] PRIMARY KEY CLUSTERED ([JobSkillsMappingId] ASC),
 CONSTRAINT [FK_JobSkillsMapping_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId),
 CONSTRAINT [FK_JobSkillsMapping_SkillsId] FOREIGN KEY  ([SkillsId]) REFERENCES Skills(SkillsId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 28 June 2018
-- Purpose     : Create new table for JobDocuments

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobDocuments'))
BEGIN
   CREATE TABLE [dbo].JobDocuments(
	[JobDocumentsId] [int] IDENTITY(1,1) NOT NULL,	
	[DocumentName] [nvarchar](500) NOT NULL,
	[JobId] [int] not null,
	[IsActive] [char](1)
		 	
	
 CONSTRAINT [PK_JobDocumentsId] PRIMARY KEY CLUSTERED ([JobDocumentsId] ASC),
 CONSTRAINT [FK_JobDocuments_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId)) 

END

-- Created By  : Sanu Mohan P
-- Create Date : 04 July 2018
-- Purpose     : add column CreatedDate

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'CreatedDate' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD CreatedDate DATETIME
END

-- Created By  : Sanu Mohan P
-- Create Date : 04 July 2018
-- Purpose     : add column ModifiedDate

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ModifiedDate' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD ModifiedDate DATETIME
END

-- Created By  : Sanu Mohan P
-- Create Date : 04 July 2018
-- Purpose     : add column CreatedDate

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'CreatedDate' AND Object_ID = Object_ID(N'UserProfile')))
BEGIN	
    ALTER TABLE UserProfile ADD CreatedDate DATETIME
END

-- Created By  : Sanu Mohan P
-- Create Date : 04 July 2018
-- Purpose     : add column ModifiedDate

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ModifiedDate' AND Object_ID = Object_ID(N'UserProfile')))
BEGIN	
    ALTER TABLE UserProfile ADD ModifiedDate DATETIME
END


-- Created By  : Sanu Mohan P
-- Create Date : 04 July 2018
-- Purpose     : Create new table for JobBidding

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobBidding'))
BEGIN
   CREATE TABLE [dbo].JobBidding(
	[JobBiddingId] [int] IDENTITY(1,1) NOT NULL,	
	[JobId] [int] not null,
	[UserId] [int] not null,
	[BidAmount] [decimal](18,3),
	[BidMessage][nvarchar](1000),
	[IsActive][char](1),
	[CreatedDate][datetime],
	[ModifiedDate][datetime]	 	
	
 CONSTRAINT [PK_JobBiddingId] PRIMARY KEY CLUSTERED ([JobBiddingId] ASC),
 CONSTRAINT [FK_JobBidding_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId),
 CONSTRAINT [FK_JobBidding_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 10 July 2018
-- Purpose     : Create new table for UserSkillsMapping

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserSkillsMapping'))
BEGIN
   CREATE TABLE [dbo].UserSkillsMapping(
	[UserSkillsMappingId] [int] IDENTITY(1,1) NOT NULL,	
	[UserId] [int] not null,
	[SkillsId] [int] not null	 	
	
 CONSTRAINT [PK_UserSkillsMappingId] PRIMARY KEY CLUSTERED ([UserSkillsMappingId] ASC),
 CONSTRAINT [FK_UserSkillsMapping_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId),
 CONSTRAINT [FK_UserSkillsMapping_SkillsId] FOREIGN KEY  ([SkillsId]) REFERENCES Skills(SkillsId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 10 July 2018
-- Purpose     : add column JobSeekerId

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobSeekerId' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD JobSeekerId INT NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 10 July 2018
-- Purpose     : add constraint FK_Job_JobSeekerId

IF(EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobSeekerId' AND Object_ID = Object_ID(N'Job')))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_Job_JobSeekerId') 
	AND parent_object_id = OBJECT_ID(N'Job'))
	BEGIN
		ALTER TABLE Job ADD CONSTRAINT [FK_Job_JobSeekerId] FOREIGN KEY ([JobSeekerId]) REFERENCES Users(UserId)
	END
END

-- Created By  : Sanu Mohan P
-- Create Date : 19 July 2018
-- Purpose     : add column JobReferanceId

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobReferanceId' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD JobReferanceId VARCHAR(20) NOT NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 19 July 2018
-- Purpose     : add constraint UK_Job_JobReferanceId

IF(EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobReferanceId' AND Object_ID = Object_ID(N'Job')))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UK_Job_JobReferanceId]') 
      AND type in  (N'UQ') AND parent_object_id = OBJECT_ID(N'Job'))
	BEGIN
		ALTER TABLE Job ADD CONSTRAINT [UK_Job_JobReferanceId] UNIQUE (JobReferanceId)
	END
END

-- Created By  : Sanu Mohan P
-- Create Date : 19 July 2018
-- Purpose     : add column JobPosterRating

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobPosterRating' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD JobPosterRating DECIMAL(18,3) NULL 
END

-- Created By  : Sanu Mohan P
-- Create Date : 19 July 2018
-- Purpose     : add column JobSeekerRating

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobSeekerRating' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD JobSeekerRating DECIMAL(18,3) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 20 July 2018
-- Purpose     : add column JobStatusSeeker

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'JobStatusSeeker' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD JobStatusSeeker CHAR(1) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 20 July 2018
-- Purpose     : Create new table for JobLog

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobLog'))
BEGIN
   CREATE TABLE [dbo].JobLog(
	[JobLogId] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[JobCategoryId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[JobTitle] [nvarchar](30) NOT NULL,
	[JobDescription] [nvarchar](max),
	[BudgetASP] [decimal](18,3),
	[Commission] [decimal](18,3),
	[TotalBudget] [decimal](18,3),
	[JobCompletionDate] [datetime],
	[IsActive] [char](1),
	[JobStatus] [char](1),
	[JobStatusSeeker] [char](1),
	[CreatedDate] [DATETIME],
	[ModifiedDate] [DATETIME],
	[JobSeekerId]	[int],
	[JobReferanceId] [nvarchar](20) NOT NULL,
	[JobPosterRating] [decimal](18,3),
	[JobSeekerRating] [decimal](18,3),
	[JobVersion] [varchar](20) null,
	[Action] [char](1) null, 	
	
 CONSTRAINT [PK_JobLogId] PRIMARY KEY CLUSTERED ([JobLogId] ASC), 
 CONSTRAINT [FK_JobLog_JobCategoryId] FOREIGN KEY  ([JobCategoryId]) REFERENCES JobCategory(JobCategoryId),
 CONSTRAINT [FK_JobLog_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId),
 CONSTRAINT [FK_JobLog_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId),
 CONSTRAINT [FK_JobLog_JobSeekerId] FOREIGN KEY ([JobSeekerId]) REFERENCES Users(UserId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 26 July 2018
-- Purpose     : add column IsAccepted

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'IsAccepted' AND Object_ID = Object_ID(N'JobBidding')))
BEGIN	
    ALTER TABLE JobBidding ADD IsAccepted CHAR(1) NULL
END


-- Created By  : Sanu Mohan P
-- Create Date : 26 July 2018
-- Purpose     : Create new table for JobReferance

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobReferance'))
BEGIN
   CREATE TABLE [dbo].JobReferance(
	 JobReferanceId [int] IDENTITY(1,1) NOT NULL,
	 JobReferanceNo [int]
   	)

END

-- Created By  : Sanu Mohan P
-- Create Date : 27 July 2018
-- Purpose     : Create new table for MatchBXNotification

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'MatchBXNotification'))
BEGIN
   CREATE TABLE [dbo].MatchBXNotification(
	[MatchBXNotificationId] [int] IDENTITY(1,1) NOT NULL,	
	[SenderId] [int] not null,
	[ReceiverId] [int] not null,
	[Notification] [nvarchar](max),
	[ReadStatus] [bit]	 	
	
 CONSTRAINT [PK_MatchBXNotificationId] PRIMARY KEY CLUSTERED ([MatchBXNotificationId] ASC),
 CONSTRAINT [FK_MatchBXNotification_SenderId] FOREIGN KEY  ([SenderId]) REFERENCES Users(UserId),
 CONSTRAINT [FK_MatchBXNotification_ReceiverId] FOREIGN KEY  ([ReceiverId]) REFERENCES Users(UserId))

END


-- Created By  : Prazeed
-- Create Date : 27 July 2018
-- Purpose     : Create new table for MatchBXNotification

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'MatchBXMessage'))
BEGIN
   CREATE TABLE [dbo].MatchBXMessage(
	[MatchBXMessageId] [int] IDENTITY(1,1) NOT NULL,	
	[SendUserId ] [int] not null,
	[ReceiverId] [int] not null,
	[Message] text,
	[ReadStatus] [bit]	 	,
	[CreatedDateTime] [Datetime]
	
 CONSTRAINT [PK_MatchBXMessageId] PRIMARY KEY CLUSTERED ([MatchBXMessageId] ASC),
 CONSTRAINT [FK_MatchBXMessage_SenderId] FOREIGN KEY  ([SendUserId]) REFERENCES Users(UserId),
 CONSTRAINT [FK_MatchBXMessage_ReceiverId] FOREIGN KEY  ([ReceiverId]) REFERENCES Users(UserId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 31 July 2018
-- Purpose     : Create new table for SocialMediaShare

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'SocialMediaShare'))
BEGIN
   CREATE TABLE [dbo].SocialMediaShare(
	[SocialMediaShareId] [int] IDENTITY(1,1) NOT NULL,	
	[JobId] [int] not null,
	[UserId] [int] not null,
	[FBShare] [char](1),
	[TwitterShare] [char](1)
	
 CONSTRAINT [PK_SocialMediaShareId] PRIMARY KEY CLUSTERED ([SocialMediaShareId] ASC),
 CONSTRAINT [FK_SocialMediaShare_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId),
 CONSTRAINT [FK_SocialMediaShare_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 31 July 2018
-- Purpose     : Create new table for JobStatusMaster

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobStatusMaster'))
BEGIN
   CREATE TABLE [dbo].JobStatusMaster(
	[JobStatusMasterId] [int] IDENTITY(1,1) NOT NULL,	
	[JobStatusFlag] [char] (1),
	[StatusDescription] [nvarchar](20)	
	
 CONSTRAINT [PK_JobStatusMasterId] PRIMARY KEY CLUSTERED ([JobStatusMasterId] ASC))
END


-- Created By  : Sanu Mohan P
-- Create Date : 31 July 2018
-- Purpose     : Modify fullname column of Users

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'FullName' AND IS_NULLABLE = 'YES'))
BEGIN	
    ALTER TABLE Users ALTER COLUMN FullName nvarchar(100) NULL
END


-- Created By  : Sanu Mohan P
-- Create Date : 31 July 2018
-- Purpose     : Create new table for UserEmailPreferenceMapping

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserEmailPreferenceMapping'))
BEGIN
   CREATE TABLE [dbo].UserEmailPreferenceMapping(
	[UserEmailPreferenceMappingId] [int] IDENTITY(1,1) NOT NULL,	
	[UserId] [int] null,
	[EmailPreferenceId] [int] null,
	[CheckStatus] [bit]
	
 CONSTRAINT [PK_UserEmailPreferenceMappingId] PRIMARY KEY CLUSTERED ([UserEmailPreferenceMappingId] ASC),
 CONSTRAINT [FK_UserEmailPreferenceMapping_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId),
 CONSTRAINT [FK_UserEmailPreferenceMapping_EmailPreferenceId] FOREIGN KEY  ([EmailPreferenceId]) REFERENCES EmailPreference(EmailPreferenceId))
END


-- Created By  : Sanu Mohan P
-- Create Date : 01 Aug 2018
-- Purpose     : Create new table for UserBlocking

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserBlocking'))
BEGIN
   CREATE TABLE [dbo].UserBlocking(
	[UserBlockingId] [int] IDENTITY(1,1) NOT NULL,	
	[Reason] [nvarchar](500) null	
	
 CONSTRAINT [PK_UserBlockingId] PRIMARY KEY CLUSTERED ([UserBlockingId] ASC))
END

-- Created By  : Sanu Mohan P
-- Create Date : 01 Aug 2018
-- Purpose     : Add colum BlockReason to Users

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'BlockReason' AND Object_ID = Object_ID(N'Users')))
BEGIN	
    ALTER TABLE Users ADD BlockReason INT NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 04 Aug 2018
-- Purpose     : Add colum Filesize to JobDocuments

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'Filesize' AND Object_ID = Object_ID(N'JobDocuments')))
BEGIN	
    ALTER TABLE JobDocuments ADD Filesize float NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 04 Aug 2018
-- Purpose     : Modify password column of Users

IF(NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'Password' AND DATA_TYPE = 'varbinary'))
BEGIN	
	ALTER TABLE Users DROP COLUMN Password
    ALTER TABLE Users ADD Password VARBINARY(200)   
END

-- Created By  : Sanu Mohan P
-- Create Date : 07 Aug 2018
-- Purpose     : Create new table for Job cancelling

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobCancellation'))
BEGIN
   CREATE TABLE [dbo].JobCancellation(
	[JobCancellationId] [int] IDENTITY(1,1) NOT NULL,	
	[Reason] [nvarchar](500) null	
	
 CONSTRAINT [PK_JobCancellationId] PRIMARY KEY CLUSTERED ([JobCancellationId] ASC))
END


-- Created By  : Sanu Mohan P
-- Create Date : 07 Aug 2018
-- Purpose     : Add colum CancelReason to Job

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'CancelReason' AND Object_ID = Object_ID(N'Job')))
BEGIN	
    ALTER TABLE Job ADD CancelReason INT NULL
END


-- Created By  : Sanu Mohan P
-- Create Date : 07 Aug 2018
-- Purpose     : Add colum CancelReason to Job

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'CancelReason' AND Object_ID = Object_ID(N'JobLog')))
BEGIN	
    ALTER TABLE JobLog ADD CancelReason INT NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 08 Aug 2018
-- Purpose     : Add colum VerificationCode to Users

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'VerificationCode' AND Object_ID = Object_ID(N'Users')))
BEGIN	
    ALTER TABLE Users ADD VerificationCode NVARCHAR(500) NULL
END


-- Created By  : Sanu Mohan P
-- Create Date : 07 Aug 2018
-- Purpose     : Create new table for Token Distribution

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'TokenDistribution'))
BEGIN
   CREATE TABLE [dbo].TokenDistribution(
	[TokenDistributionId] [int] IDENTITY(1,1) NOT NULL,	
	[UserId] [int] not null,
	[TokenAddress] [nvarchar](1000),
	[JobBiddingId] [int],
	[IsApproved] char(1)	
	
 CONSTRAINT [PK_TokenDistributionId] PRIMARY KEY CLUSTERED ([TokenDistributionId] ASC),
 CONSTRAINT [FK_TokenDistribution_JobBiddingId] FOREIGN KEY  ([JobBiddingId]) REFERENCES JobBidding(JobBiddingId),
 CONSTRAINT [FK_TokenDistribution_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))
END

-- Created By  : Sanu Mohan P
-- Create Date : 10 Aug 2018
-- Purpose     : Add colum Header to MatchBXNotification

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'Header' AND Object_ID = Object_ID(N'MatchBXNotification')))
BEGIN	
    ALTER TABLE MatchBXNotification ADD Header NVARCHAR(100) NULL
END

-- Created By  : Prazeed
-- Create Date : 12 Aug 2018
-- Purpose     : Add colum HubId to login

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HubId' AND Object_ID = Object_ID(N'[login]')))
BEGIN	
    ALTER TABLE [login] ADD HubId NVARCHAR(500) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 13 Aug 2018
-- Purpose     : Create new table for TransactionDetail

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'TransactionDetail'))
BEGIN
   CREATE TABLE [dbo].TransactionDetail(
	[TransactionDetailId] [int] IDENTITY(1,1) NOT NULL,	
	[UserId] [int] not null,
	[JobId] [int] not null,
	[Hash] [nvarchar](max),
	[Amount] [decimal](18,3),
	[TransactionType] [char](1), -- S-Spent,E-Earnt,A-Agreement
	[ProcessType] [char](1), -- C-Job completion,S-Job share,A-Job accept
	[IsApproved] [char](1),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]	
	
 CONSTRAINT [PK_TransactionDetailId] PRIMARY KEY CLUSTERED ([TransactionDetailId] ASC),
 CONSTRAINT [FK_TransactionDetail_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId),
 CONSTRAINT [FK_TransactionDetail_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))
END

-- Created By  : Sanu Mohan P
-- Create Date : 14 Aug 2018
-- Purpose     : Create new table for ContractDetail

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'ContractDetail'))
BEGIN
   CREATE TABLE [dbo].ContractDetail(
	[ContractDetailId] [int] IDENTITY(1,1) NOT NULL,	
	[TokenAddress] [nvarchar](max),
	[EscrowAddress] [nvarchar](max),
	[TokenABI] [nvarchar](max),
	[EscrowABI] [nvarchar](max),
	[OwnerAddress] [nvarchar](max),
	[PrivateKeyHash] [nvarchar](max)
)
END

-- Created By  : Sanu Mohan P
-- Create Date : 21 Aug 2018
-- Purpose     : Add CreatedTime to MatchBXNotification

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'CreatedTime' AND Object_ID = Object_ID(N'[MatchBXNotification]')))
BEGIN	
    ALTER TABLE MatchBXNotification ADD CreatedTime DATETIME NULL
END

-- Created By  : Prazeed
-- Create Date : 28 Aug 2018
-- Purpose     : Add colum HubId to login

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'IsMailSent' AND Object_ID = Object_ID(N'[MatchBXMessage]')))
BEGIN	
    ALTER TABLE [MatchBXMessage] ADD IsMailSent int default 0
END

-- Created By  : Sanu Mohan P
-- Create Date : 28 Aug 2018
-- Purpose     : Add colum DeclineType to JobBidding

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DeclineType' AND Object_ID = Object_ID(N'[JobBidding]')))
BEGIN	
    ALTER TABLE [JobBidding] ADD DeclineType char(1) null
END

-- Created By  : Sanu Mohan P
-- Create Date : 24 Sep 2018
-- Purpose     : Drop foreign key for job id
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'.FK_TransactionDetail_JobId') AND parent_object_id = OBJECT_ID(N'.TransactionDetail'))
BEGIN
  ALTER TABLE [TransactionDetail] DROP CONSTRAINT [FK_TransactionDetail_JobId]
END

-- Created By  : Sanu Mohan P
-- Create Date : 28 Aug 2018
-- Purpose     : Add colum IsPending to JobBidding

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'IsPending' AND Object_ID = Object_ID(N'[JobBidding]')))
BEGIN	
    ALTER TABLE [JobBidding] ADD IsPending char(1) DEFAULT  'N'
END

-- Created By  : Sanu Mohan P
-- Create Date : 28 Aug 2018
-- Purpose     : Drop colum DeclineType to JobBidding

IF(EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DeclineType' AND Object_ID = Object_ID(N'[JobBidding]')))
BEGIN	
    ALTER TABLE [JobBidding] DROP COLUMN DeclineType 
END

-- Created By  : Sanu Mohan P
-- Create Date : 25 Sep 2018
-- Purpose     : Create new table for FailedTransactionDetail

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'FailedTransactionDetail'))
BEGIN
   CREATE TABLE [dbo].FailedTransactionDetail(
	[FailedTransactionDetailId] [int] IDENTITY(1,1) NOT NULL,	
	[UserId] [int] not null,
	[JobId] [int] not null,
	[Hash] [nvarchar](max),
	[Amount] [decimal](18,3),
	[TransactionType] [char](1), -- S-Spent,E-Earnt,A-Agreement
	[ProcessType] [char](1), -- C-Job completion,S-Job share,A-Job accept
	[IsApproved] [char](1),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		
 )
END

-- Created By  : Sanu Mohan P
-- Create Date : 26 Sept 2018
-- Purpose     : Add colum FeeAccount to ContractDetail

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'FeeAccount' AND Object_ID = Object_ID(N'[ContractDetail]')))
BEGIN	
    ALTER TABLE [ContractDetail] ADD FeeAccount NVARCHAR(100)
END

-- Created By  : Sanu Mohan P
-- Create Date : 26 Sept 2018
-- Purpose     : Add colum AmountToBurn to ContractDetail

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AmountToBurn' AND Object_ID = Object_ID(N'[ContractDetail]')))
BEGIN	
    ALTER TABLE [ContractDetail] ADD AmountToBurn INT 
END

-- Created By  : Sanu Mohan P
-- Create Date : 27 Sept 2018
-- Purpose     : Add colum Url to MatchBXNotification

IF(NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'Url' AND Object_ID = Object_ID(N'[MatchBXNotification]')))
BEGIN	
    ALTER TABLE [MatchBXNotification] ADD Url NVARCHAR(50) 
END

-- Created By  : Sanu Mohan P
-- Create Date : 03 Oct 2018
-- Purpose     : Modify JobTitle column of Job

IF (EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Job' AND COLUMN_NAME = 'JobTitle'))
BEGIN	
    ALTER TABLE Job ALTER COLUMN JobTitle nvarchar(200) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 03 Oct 2018
-- Purpose     : Modify JobTitle column of JobLog

IF (EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JobLog' AND COLUMN_NAME = 'JobTitle'))
BEGIN	
    ALTER TABLE JobLog ALTER COLUMN JobTitle nvarchar(200) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 08 Oct 2018
-- Purpose     : Add MessageType column to MatchBXMessage

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MatchBXMessage' AND COLUMN_NAME = 'MessageType'))
BEGIN	
    ALTER TABLE MatchBXMessage ADD MessageType CHAR(1) DEFAULT 'M'    
END

-- Created By  : Sanu Mohan P
-- Create Date : 08 Oct 2018
-- Purpose     : Add FileSize column to MatchBXMessage

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MatchBXMessage' AND COLUMN_NAME = 'FileSize'))
BEGIN	
    ALTER TABLE MatchBXMessage ADD FileSize float NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 08 Oct 2018
-- Purpose     : Add FileName column to MatchBXMessage

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MatchBXMessage' AND COLUMN_NAME = 'FileName'))
BEGIN	
    ALTER TABLE MatchBXMessage ADD FileName NVARCHAR(1000) NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 12 Oct 2018
-- Purpose     : Add BlockNumber column to ContractDetail

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ContractDetail' AND COLUMN_NAME = 'BlockNumberApproval'))
BEGIN	
    ALTER TABLE ContractDetail ADD BlockNumberApproval NVARCHAR(1000) NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 12 Oct 2018
-- Purpose     : Add BlockNumberDeposit column to ContractDetail

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ContractDetail' AND COLUMN_NAME = 'BlockNumberDeposit'))
BEGIN	
    ALTER TABLE ContractDetail ADD BlockNumberDeposit NVARCHAR(1000) NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 12 Oct 2018
-- Purpose     : Add Address column to ContractDetail

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TransactionDetail' AND COLUMN_NAME = 'Address'))
BEGIN	
    ALTER TABLE TransactionDetail ADD Address NVARCHAR(1000) NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 16 Oct 2018
-- Purpose     : Create new table for JobTransactionHashLog

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobTransactionHashLog'))
BEGIN
   CREATE TABLE [dbo].JobTransactionHashLog(
	[JobTransactionHashLogId] [int] IDENTITY(1,1) NOT NULL,		
	[JobId] [int] not null,
	[Hash] [nvarchar](max),	
	[Status] [char](1),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		
 )
END

-- Created By  : Sanu Mohan P
-- Create Date : 24 Oct 2018
-- Purpose     : Create new table for JobAudit

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobAudit'))
BEGIN
   CREATE TABLE [dbo].JobAudit(
	[JobAuditId] [int] IDENTITY(1,1) NOT NULL,		
	[JobId] [int] not null,
	[UserId] [int],	
	[Status] [char](1),
	[RejectReason] [int],
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		
 )
END

-- Created By  : Sanu Mohan P
-- Create Date : 31 Oct 2018
-- Purpose     : Create new table for ReminderMails

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'ReminderMails'))
BEGIN
   CREATE TABLE [dbo].ReminderMails(
	[ReminderMailsId] [int] IDENTITY(1,1) NOT NULL,		
	[JobId] [int] not null,	
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		
 )
END

-- Created By  : Sanu Mohan P
-- Create Date : 14 Nov 2018
-- Purpose     : Add TagType column to TrendingTags

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TrendingTags' AND COLUMN_NAME = 'TagType'))
BEGIN	
    ALTER TABLE TrendingTags ADD TagType CHAR(1) NULL  
END

---- Created By  : Sanu Mohan P
---- Create Date : 30 Nov 2018
---- Purpose     : Add IsReset column to TransactionDetail

--IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TransactionDetail' AND COLUMN_NAME = 'IsReset'))
--BEGIN	
--    ALTER TABLE TransactionDetail ADD IsReset CHAR(1) DEFAULT('N')  
--END

-- Created By  : Sanu Mohan P
-- Create Date : 07 January 2019
-- Purpose     : Create new table for Gig

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'Gig'))
BEGIN
   CREATE TABLE [dbo].Gig(
	[GigId] [int] IDENTITY(1,1) NOT NULL,
	[JobCategoryId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[GigTitle] [nvarchar](30) NOT NULL,
	[GigDescription] [nvarchar](max),
	[BudgetASP] [decimal](18,3),
	[Commission] [decimal](18,3),
	[TotalBudget] [decimal](18,3),
	[GigDuration] int,
	[IsActive] [char](1),
	[IsGigEnabled] [char](1),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]  	
	
 CONSTRAINT [PK_GigId] PRIMARY KEY CLUSTERED ([GigId] ASC), 
 CONSTRAINT [FK_Gig_JobCategoryId] FOREIGN KEY  ([JobCategoryId]) REFERENCES JobCategory(JobCategoryId),
 CONSTRAINT [FK_Gig_UserId] FOREIGN KEY  ([UserId]) REFERENCES Users(UserId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 07 January 2019
-- Purpose     : Create new table for GigTrendingTagsMapping

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigTrendingTagsMapping'))
BEGIN
   CREATE TABLE [dbo].GigTrendingTagsMapping(
	[GigTrendingTagsMappingId] [int] IDENTITY(1,1) NOT NULL,	
	[GigId] [int] null,
	[TrendingTagsId] [int],
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]	 	
	
 CONSTRAINT [PK_GigTrendingTagsMappingId] PRIMARY KEY CLUSTERED ([GigTrendingTagsMappingId] ASC),
 CONSTRAINT [FK_GigTrendingTagsMapping_GigId] FOREIGN KEY  ([GigId]) REFERENCES Gig(GigId),
 CONSTRAINT [FK_GigTrendingTagsMapping_TrendingTagsId] FOREIGN KEY  ([TrendingTagsId]) REFERENCES TrendingTags(TrendingTagsId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 07 January 2019
-- Purpose     : Create new table for GigSkillsMapping

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigSkillsMapping'))
BEGIN
   CREATE TABLE [dbo].GigSkillsMapping(
	[GigSkillsMappingId] [int] IDENTITY(1,1) NOT NULL,	
	[GigId] [int] not null,
	[SkillsId] [int] not null,
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]	 	
	
 CONSTRAINT [PK_GigSkillsMappingId] PRIMARY KEY CLUSTERED ([GigSkillsMappingId] ASC),
 CONSTRAINT [FK_GigSkillsMapping_GigId] FOREIGN KEY  ([GigId]) REFERENCES Gig(GigId),
 CONSTRAINT [FK_GigSkillsMapping_SkillsId] FOREIGN KEY  ([SkillsId]) REFERENCES Skills(SkillsId))

END


-- Created By  : Sanu Mohan P
-- Create Date : 07 January 2019
-- Purpose     : Create new table for GigDocuments

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigDocuments'))
BEGIN
   CREATE TABLE [dbo].GigDocuments(
	[GigDocumentsId] [int] IDENTITY(1,1) NOT NULL,	
	[DocumentName] [nvarchar](500) NOT NULL,
	[GigId] [int] not null,
	[IsActive] [char](1),
	[FileSize] [decimal] (18,3),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		 	
	
 CONSTRAINT [PK_GigDocumentsId] PRIMARY KEY CLUSTERED ([GigDocumentsId] ASC),
 CONSTRAINT [FK_GigDocuments_GigId] FOREIGN KEY  ([GigId]) REFERENCES Gig(GigId)) 

END

-- Created By  : Sanu Mohan P
-- Create Date : 07 January 2019
-- Purpose     : Create new table for GigSubscription

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigSubscription'))
BEGIN
   CREATE TABLE [dbo].GigSubscription(
	[GigSubscriptionId] [int] IDENTITY(1,1) NOT NULL,
	[GigId] [int] NOT NULL,
	[JobPosterId] [int] NOT NULL,
	[Description] [nvarchar] (max),	
	[IsActive] [char](1),
	[GigSubscriptionStatus] [char](1),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime] 	
	
 CONSTRAINT [PK_GigSubscriptionId] PRIMARY KEY CLUSTERED ([GigSubscriptionId] ASC), 
 CONSTRAINT [FK_GigSubscription_GigId] FOREIGN KEY  ([GigId]) REFERENCES Gig(GigId),
 CONSTRAINT [FK_GigSubscription_JobPosterId] FOREIGN KEY  ([JobPosterId]) REFERENCES Users(UserId))

END

-- Created By  : Sanu Mohan P
-- Create Date : 07 January 2019
-- Purpose     : Create new table for GigSubscriptionDocuments

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigSubscriptionDocument'))
BEGIN
   CREATE TABLE [dbo].GigSubscriptionDocument(
	[GigSubscriptionDocumentId] [int] IDENTITY(1,1) NOT NULL,	
	[DocumentName] [nvarchar](500) NOT NULL,
	[GigSubscriptionId] [int] not null,
	[IsActive] [char](1),
	[FileSize] [decimal] (18,3),
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		 	
	
 CONSTRAINT [PK_GigSubscriptionDocumentId] PRIMARY KEY CLUSTERED ([GigSubscriptionDocumentId] ASC),
 CONSTRAINT [FK_GigSubscriptionDocument_GigSubscriptionId] FOREIGN KEY  ([GigSubscriptionId]) REFERENCES GigSubscription(GigSubscriptionId)) 

END

-- Created By  : Sanu Mohan P
-- Create Date : 07 Jan 2019
-- Purpose     : Add TagType column to Gig

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Gig' AND COLUMN_NAME = 'GigStatus'))
BEGIN	
    ALTER TABLE Gig ADD GigStatus CHAR(1) NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 07 Jan 2019
-- Purpose     : Add TagType column to Gig

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Gig' AND COLUMN_NAME = 'CancelReason'))
BEGIN	
    ALTER TABLE Gig ADD CancelReason INT NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 09 Jan 2019
-- Purpose     : Add GigSubscriptionId column to Job

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Job' AND COLUMN_NAME = 'GigSubscriptionId'))
BEGIN	
    ALTER TABLE Job ADD GigSubscriptionId INT NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 09 Jan 2019
-- Purpose     : Add GigSubscriptionId column to JobLog

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JobLog' AND COLUMN_NAME = 'GigSubscriptionId'))
BEGIN	
    ALTER TABLE JobLog ADD GigSubscriptionId INT NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 15 Jan 2019
-- Purpose     : Add JobCompletionDate column to GigSubscription

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GigSubscription' AND COLUMN_NAME = 'JobCompletionDate'))
BEGIN	
    ALTER TABLE GigSubscription ADD JobCompletionDate DATETIME NULL  
END

-- Created By  : Sanu Mohan P
-- Create Date : 15 Jan 2019
-- Purpose     : add constraint FK_Job_GigSubscriptionId

IF(EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'GigSubscriptionId' AND Object_ID = Object_ID(N'Job')))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_Job_GigSubscriptionId') 
	AND parent_object_id = OBJECT_ID(N'Job'))
	BEGIN
		ALTER TABLE Job ADD CONSTRAINT [FK_Job_GigSubscriptionId] FOREIGN KEY ([GigSubscriptionId]) REFERENCES GigSubscription(GigSubscriptionId)
	END
END

-- Created By  : Sanu Mohan P
-- Create Date : 15 Jan 2019
-- Purpose     : Add GigSubscriptionId column to TokenDistribution

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TokenDistribution' AND COLUMN_NAME = 'GigSubscriptionId'))
BEGIN	
    ALTER TABLE TokenDistribution ADD GigSubscriptionId INT  
END

-- Created By  : Sanu Mohan P
-- Create Date : 15 Jan 2019
-- Purpose     : add constraint FK_TokenDistribution_GigSubscriptionId

IF(EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'GigSubscriptionId' AND Object_ID = Object_ID(N'TokenDistribution')))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_TokenDistribution_GigSubscriptionId') 
	AND parent_object_id = OBJECT_ID(N'TokenDistribution'))
	BEGIN
		ALTER TABLE TokenDistribution ADD CONSTRAINT [FK_TokenDistribution_GigSubscriptionId] FOREIGN KEY ([GigSubscriptionId]) REFERENCES GigSubscription(GigSubscriptionId)
	END
END

-- Created By  : Sanu Mohan P
-- Create Date : 16 Jan 2019
-- Purpose     : Add Title column to GigSubscription

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GigSubscription' AND COLUMN_NAME = 'Title'))
BEGIN	
    ALTER TABLE GigSubscription ADD Title NVARCHAR(30) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 18 Jan 2019
-- Purpose     : Add Deliverables column to Gig

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Gig' AND COLUMN_NAME = 'Deliverables'))
BEGIN	
    ALTER TABLE Gig ADD Deliverables NVARCHAR(Max) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 18 January 2019
-- Purpose     : Create new table for AjaxSession

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'AjaxSession'))
BEGIN
   CREATE TABLE [dbo].AjaxSession(
	[AjaxSessionId] [int] IDENTITY(1,1) NOT NULL,	
	[SessionString] [nvarchar](50) NOT NULL
					 		
 CONSTRAINT [PK_AjaxSessionId] PRIMARY KEY CLUSTERED ([AjaxSessionId] ASC))
END

-- Created By  : Sanu Mohan P
-- Create Date : 31 Oct 2018
-- Purpose     : Create new table for ReminderMailsGig

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'ReminderMailsGig'))
BEGIN
   CREATE TABLE [dbo].ReminderMailsGig(
	[ReminderMailsGigId] [int] IDENTITY(1,1) NOT NULL,		
	[GigId] [int] not null,	
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime]		
 )
END

-- Created By  : Sanu Mohan P
-- Create Date : 23 Jan 2019
-- Purpose     : Create new table for GigStatusMaster

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigStatusMaster'))
BEGIN
   CREATE TABLE [dbo].GigStatusMaster(
	[GigStatusMasterId] [int] IDENTITY(1,1) NOT NULL,	
	[GigStatusFlag] [char] (1),
	[StatusDescription] [nvarchar](20)	
	
 CONSTRAINT [PK_GigStatusMasterId] PRIMARY KEY CLUSTERED ([GigStatusMasterId] ASC))
END

-- Created By  : Sanu Mohan P
-- Create Date : 23 Jan 2019
-- Purpose     : Create new table for GigSubscriptionStatusMaster

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigSubscriptionStatusMaster'))
BEGIN
   CREATE TABLE [dbo].GigSubscriptionStatusMaster(
	[GigSubscriptionStatusMasterId] [int] IDENTITY(1,1) NOT NULL,	
	[GigSubscriptionStatusFlag] [char] (1),
	[StatusDescription] [nvarchar](20)	
	
 CONSTRAINT [PK_GigSubscriptionStatusMasterId] PRIMARY KEY CLUSTERED ([GigSubscriptionStatusMasterId] ASC))
END

-- Created By  : Sanu Mohan P
-- Create Date : 24 Jan 2019
-- Purpose     : Add UserId column to AjaxSession

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AjaxSession' AND COLUMN_NAME = 'UserId'))
BEGIN	
    ALTER TABLE AjaxSession ADD UserId INT
END

-- Created By  : Sanu Mohan P
-- Create Date : 28 Jan 2019
-- Purpose     : Modify GigTitle column of Gig

IF (EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Gig' AND COLUMN_NAME = 'GigTitle'))
BEGIN	
    ALTER TABLE Gig ALTER COLUMN GigTitle nvarchar(200) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 29 Jan 2019
-- Purpose     : Modify Title column of GigSubscription

IF (EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GigSubscription' AND COLUMN_NAME = 'Title'))
BEGIN	
    ALTER TABLE GigSubscription ALTER COLUMN Title nvarchar(200) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 06 February 2019
-- Purpose     : Create new table for GigReview

IF (NOT EXISTS (SELECT 1  FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'GigReview'))
BEGIN
   CREATE TABLE [dbo].GigReview(
	[GigReviewId] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[GigId] [int] NOT NULL,	
	[Review] [nvarchar] (1000),	
	[GigReviewStatus] [char](1),	
	[CreatedDate] [datetime],
	[ModifiedDate] [datetime] 	
	
 CONSTRAINT [PK_GigReviewId] PRIMARY KEY CLUSTERED ([GigReviewId] ASC), 
 CONSTRAINT [FK_GigReview_GigId] FOREIGN KEY  ([GigId]) REFERENCES Gig(GigId),
 CONSTRAINT [FK_GigReview_JobId] FOREIGN KEY  ([JobId]) REFERENCES Job(JobId))
END

-- Created By  : Sanu Mohan P
-- Create Date : 06 Feb 2019
-- Purpose     : Modify VerifiedPartner column of Users

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'VerifiedPartner'))
BEGIN	
    ALTER TABLE Users ADD VerifiedPartner CHAR(1) NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 14 Feb 2019
-- Purpose     : Modify MatchBXMessage column of JobId

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MatchBXMessage' AND COLUMN_NAME = 'JobId'))
BEGIN	
    ALTER TABLE MatchBXMessage ADD JobId INT NULL
END

-- Created By  : Praveen K
-- Create Date : 04 Mar 2019
-- Purpose     : Modify JobBidding column of BidDuration

IF (NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JobBidding' AND COLUMN_NAME = 'BidDuration'))
BEGIN	
    ALTER TABLE JobBidding ADD BidDuration INT NULL
END

-- Created By  : Sanu Mohan P
-- Create Date : 08 Oct 2018
-- Purpose     : Add MessageType column to MatchBXMessage

IF (EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MatchBXMessage' AND COLUMN_NAME = 'MessageType'))
BEGIN	
    ALTER TABLE MatchBXMessage ALTER COLUMN MessageType CHAR(2)   
END