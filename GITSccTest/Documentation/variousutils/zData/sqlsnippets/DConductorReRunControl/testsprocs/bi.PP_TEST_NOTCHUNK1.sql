
IF EXISTS (SELECT TOP 1 1 FROM sys.objects (NOLOCK) WHERE object_id = OBJECT_ID(N'[bi].[PP_TEST_NOTCHUNK1]'))
BEGIN
    DROP PROCEDURE [bi].[PP_TEST_NOTCHUNK1]
END



GO

CREATE PROCEDURE [bi].[PP_TEST_NOTCHUNK1]
(
	 @p_run int = 999
	
	 
	
)

AS



 BEGIN

 DECLARE @TEMP INT = 0

 DECLARE @ProcName sysname = coalesce ( app.sfnObjectName(@@PROCID),'PP_TEST_NOTCHUNK1');

		DECLARE @ProcMessage nvarchar(max) = 'EXEC ' + @ProcName + ' ,@p_run=' + coalesce(convert(varchar(99),@p_run),'NULL') 
		EXEC log.uspLogInsertDB  @p_LogCategory = 'PROC.BEGIN',@p_LogObject = @ProcName,@p_LogMessage = @ProcMessage,@p_LogLevel = 5,@p_Run = @p_Run
		WAITFOR DELAY '00:00:05';   -- wait 5 seconds

		EXEC log.uspLogInsertDB  @p_LogCategory = 'PROC.END',@p_LogObject = @ProcName,@p_LogMessage = 'End of procedure' ,@p_LogLevel = 5,@p_Run = @p_Run

 END
 GO