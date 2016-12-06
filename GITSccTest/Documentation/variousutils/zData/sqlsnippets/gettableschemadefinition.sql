/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [RowId]
      ,[Run]
      ,[JobDefinitionCode]
      ,[Name]
      ,[Value]
  FROM [GRCR_DEV].[stg].[Control_File]
  where JobDefinitionCode = 'GRCR_Application_Input'
  order by Run

  select * from stg.GRCR_Application_input



  select * from loader.JobDefinition

   select * from loader.Job
      select * from loader.JobTask where TaskName = 'Is Application File Ready'
  select * from app.vwConfiguration


  SELECT	ROW_NUMBER() OVER(ORDER BY C.column_id) [ordinal]
		                                    ,C.name
		                                    ,C.is_nullable
		                                    ,CASE 
                                            WHEN C.max_length = -1 AND Ct.is_text_field = 1 THEN 2147483647 /* Largest value - Int32.MaxValue */
                                            WHEN Ct.is_text_field = 1 THEN c.max_length
	                                            ELSE 0 
	                                        END [max_length]
	                                        ,Ct.clr_type
                                    FROM	sys.tables AS Tb
                                    JOIN	sys.all_columns AS C ON Tb.object_id = C.object_id
                                    JOIN	sys.schemas AS S ON Tb.schema_id = S.schema_id
                                    LEFT 
                                    JOIN	config.CONFIG_DATA_TYPE AS Ct ON Ct.system_type_id = C.system_type_id
                                    WHERE	Tb.type = 'U'
                                    AND		S.name = PARSENAME('stg.GRCR_Application_input', 2)
                                    AND		Tb.name = PARSENAME('stg.GRCR_Application_input', 1)
                                    ORDER 
                                    BY		C.column_id; 