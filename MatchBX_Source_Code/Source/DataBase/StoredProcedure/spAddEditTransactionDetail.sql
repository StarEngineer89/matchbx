--Created by    :Sanu Mohan P
--Created Date  :8/13/2018 3:36:31 PM
--Purpose      :Transaction details

IF EXISTS (SELECT * FROM sys.procedures where schema_id = schema_id('dbo')and name=N'spAddEditTransactionDetail')
DROP procedure spAddEditTransactionDetail
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spAddEditTransactionDetail
(
	@TransactionDetailId  int,
	@UserId  int,
	@JobId  int,
	@Hash  nvarchar(max),
	@Amount  decimal(18,3),
	@TransactionType  char(1),
	@ProcessType  char(1),
	@IsApproved  char(1),
	@Address NVARCHAR(1000),
	@BurnPer DECIMAL(18,3)
)
AS
IF(@TransactionDetailId=0)
BEGIN
	IF (@ProcessType = 'A')
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM TransactionDetail WHERE UserId = @UserId AND Address = @Address AND ProcessType = 'A' AND IsApproved <> 'F' AND ProcessType <> 'R')
		BEGIN		
			INSERT  INTO TransactionDetail 
			(
			  UserId,
			  JobId,
			  Hash,
			  Amount,
			  TransactionType,
			  ProcessType,
			  IsApproved,
			  CreatedDate,
			  Address	  
			)
			VALUES 
			(
			  @UserId,
			  @JobId,
			  @Hash,
			  @Amount,
			  @TransactionType,
			  @ProcessType,
			  @IsApproved,
			  GETDATE(),
			  @Address
			)			
		END  
		ELSE
		BEGIN
			IF EXISTS(SELECT 1 FROM TransactionDetail WHERE UserId = @UserId AND Address = @Address AND ProcessType = 'A' AND IsApproved = 'Y')
			BEGIN
				UPDATE TransactionDetail SET IsApproved = 'N',ModifiedDate = GETDATE(),Hash = '' WHERE UserId = @UserId AND Address = @Address AND @ProcessType = 'A' AND IsApproved = 'Y'
			END
		END
	END	
	IF (@ProcessType = 'D') 
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM TransactionDetail WHERE UserId = @UserId AND JobId = @JobId AND ProcessType = 'D' AND IsApproved = 'N')
		BEGIN			
			INSERT  INTO TransactionDetail 
			(
			  UserId,
			  JobId,
			  Hash,
			  Amount,
			  TransactionType,
			  ProcessType,
			  IsApproved,
			  CreatedDate,
			  Address	  
			)
			VALUES 
			(
			  @UserId,
			  @JobId,
			  @Hash,
			  @Amount,
			  @TransactionType,
			  @ProcessType,
			  @IsApproved,
			  GETDATE(),
			  @Address
			)		
		END  
	END  
	IF (@ProcessType = 'C')  
	BEGIN 
	
		DECLARE @BurnAmt DECIMAL(18,3)
		SELECT @BurnAmt = ((@Amount * @BurnPer)/100)
		
		
		IF NOT EXISTS(SELECT 1 FROM TransactionDetail WHERE JobId = @JobId AND ProcessType = 'C')
		BEGIN		
			INSERT  INTO TransactionDetail 
			(
			  UserId,
			  JobId,
			  Hash,
			  Amount,
			  TransactionType,
			  ProcessType,
			  IsApproved,
			  CreatedDate,
			  Address	  
			)
			VALUES 
			(
			  @UserId,
			  @JobId,
			  @Hash,
			  (@Amount + @BurnAmt),
			  @TransactionType,
			  @ProcessType,
			  @IsApproved,
			  GETDATE(),
			  @Address
			)
				
			IF(@ProcessType = 'C')
			BEGIN
				DECLARE @SeekerId INT = (SELECT JobSeekerId FROM Job WHERE JobId = @JobId)
				INSERT  INTO TransactionDetail 
				(
				  UserId,
				  JobId,
				  Hash,
				  Amount,
				  TransactionType,
				  ProcessType,
				  IsApproved,
				  CreatedDate,
				  Address	  
				)
				VALUES 
				(
				  @SeekerId,
				  @JobId,
				  @Hash,
				  (@Amount - @BurnAmt),
				  'E',
				  @ProcessType,
				  @IsApproved,
				  GETDATE(),
				  @Address
				)
			END
		END
	END	   
	IF (@ProcessType = 'R') 
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM TransactionDetail WHERE Address = @Address AND ProcessType = 'R' AND IsApproved = 'N')
		BEGIN			
			INSERT  INTO TransactionDetail 
			(
			  UserId,
			  JobId,
			  Hash,
			  Amount,
			  TransactionType,
			  ProcessType,
			  IsApproved,
			  CreatedDate,
			  Address	  
			)
			VALUES 
			(
			  @UserId,
			  @JobId,
			  @Hash,
			  @Amount,
			  @TransactionType,
			  @ProcessType,
			  @IsApproved,
			  GETDATE(),
			  @Address
			)		
		END  
	END 
    SELECT MAX(TransactionDetailId) AS TransactionDetailId  FROM TransactionDetail
END
ELSE
BEGIN
   UPDATE TransactionDetail SET
    UserId	=  @UserId,
    JobId	=  @JobId,
    Hash	=  @Hash,
    Amount	=  @Amount,
    TransactionType	=  @TransactionType,
    ProcessType	=  @ProcessType,
    IsApproved	=  @IsApproved,   
    ModifiedDate	=  GETDATE()
    WHERE TransactionDetailId	=  @TransactionDetailId
   SELECT @TransactionDetailId as TransactionDetailId
END
GO
