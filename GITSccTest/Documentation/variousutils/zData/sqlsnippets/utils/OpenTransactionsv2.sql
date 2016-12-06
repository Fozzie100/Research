select top 100 db.name, 
CASE database_transaction_type
WHEN 1 THEN 'Read/write transaction'
WHEN 2 THEN 'Read-only transaction'
WHEN 3 THEN 'System transaction'
END database_transaction_type,
CASE database_transaction_state
WHEN 1 THEN 'The transaction has not been initialized.'
WHEN 3 THEN 'The transaction has been initialized but has not generated any log records.'
WHEN 4 THEN 'The transaction has generated log records.'
WHEN 5 THEN 'The transaction has been prepared.'
WHEN 10 THEN 'The transaction has been committed.'
WHEN 11 THEN 'The transaction has been rolled back.'
WHEN 12 THEN 'The transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted'
END database_transaction_state,
sess.*, y.session_id, x.* 
from sys.dm_tran_database_transactions x
LEFT join sys.dm_tran_session_transactions y
on y.transaction_id = x.transaction_id
LEFT join sys.dm_exec_sessions sess
on sess.session_id = y.session_id
inner join sys.sysdatabases db
on db.dbid = x.database_id
order by database_transaction_log_bytes_used desc