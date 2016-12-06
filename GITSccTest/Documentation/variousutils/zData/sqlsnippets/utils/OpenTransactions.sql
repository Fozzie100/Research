select top 100 sess.*, y.session_id, x.* 
from sys.dm_tran_database_transactions x
inner join sys.dm_tran_session_transactions y
on y.transaction_id = x.transaction_id
inner join sys.dm_exec_sessions sess
on sess.session_id = y.session_id
order by database_transaction_log_bytes_used desc