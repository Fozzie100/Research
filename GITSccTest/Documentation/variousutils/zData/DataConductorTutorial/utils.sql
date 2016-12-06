select * from app.vwConfiguration


select * from loader.Job where JobDefinitionCode like '%Application%'
select * from loader.JobDefinition
where JobDefinitionCode like '%Application%'

select * from [stg].[GRCR_Application_input]

where T_70264_MSOOUT_OVERALLDSNDTE IS NOT NULL

ALTER TABLE stg.GRCR_Application_input ALTER COLUMN T_70264_MSOOUT_OVERALLDSNDTE INT ;
GO

ALTER TABLE stg.GRCR_Application_input drop column T_70264_MSOOUT_OVERALLDSNDTE

ALTER TABLE stg.GRCR_Application_input ADD T_70264_MSOOUT_OVERALLDSNDTE DATE NULL


select * from stg.GRCR_Application_input