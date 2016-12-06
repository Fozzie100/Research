SELECT top 10
    OBJECT_NAME(A.[object_id]) as 'TableName', 
    B.[name] as 'IndexName', 
    A.[index_id], 
    A.[page_count], 
    A.[index_type_desc], 
    A.[avg_fragmentation_in_percent], 
    A.[fragment_count] 
FROM 
    sys.dm_db_index_physical_stats(db_id(),NULL,NULL,NULL,'LIMITED') A 
	INNER JOIN sys.indexes B 
	ON A.[object_id] = B.[object_id] and A.index_id = B.index_id  