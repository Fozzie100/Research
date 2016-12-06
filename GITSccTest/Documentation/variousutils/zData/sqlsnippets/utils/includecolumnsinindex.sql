SELECT  DISTINCT TOP 10 T.Name 'Table Name',
        I.Name 'Index Name',
        I.type_desc 'Index Type',
        C.Name 'Included Column Name',
		C.column_id,
		IC.*

FROM sys.indexes I 
 INNER JOIN sys.index_columns IC 
  ON  I.object_id = IC.object_id AND I.index_id = IC.index_id 
 INNER JOIN sys.columns C 
  ON IC.object_id = C.object_id and IC.column_id = C.column_id 
 INNER JOIN sys.tables T 
  ON I.object_id = T.object_id 
WHERE I.Name  = 'CIX_ROWID_ACCOUNT_LINKING' --is_included_column = 1
ORDER BY T.Name, I.Name



sp_help 'ref.AtomValue'



sp_help 'stg.BARCLAYCARD_ACCOUNT_LINKING'