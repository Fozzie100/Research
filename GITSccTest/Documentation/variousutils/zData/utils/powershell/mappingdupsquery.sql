


-- select top 1 * from mapping.Mapping (nolock) 
set nocount on
 if ( OBJECT_ID('tempdb..#mappingdups') IS NOT NULL)
 drop table #mappingdups

select MappingTypeKey, EntityTypeID, ValueStringChecksum, count(*) cnt 
into #mappingdups 
from mapping.Mapping (nolock) 
group by MappingTypeKey, EntityTypeID, ValueStringChecksum 
having count(*) > 1 

declare @cnt INT
select @cnt=  count(*) from #mappingdups

select top 10 convert(varchar(64), getdate()) + '. Top 10 of ' + convert(varchar(8), @cnt) + ' duplicates'  ReportDetails, z.MaxCreateDate, z.EntityTypeCode, z.EntityTypeID, z.MappingTypeKey, z.Duplicatevalue, z.cnt CountofDups
from
(
select y.*, ( SELECT TOP 1 mp.ValueString from mapping.Mapping (nolock) mp where mp.ValueStringChecksum = y.ValueStringChecksum  and mp.EntityTypeID = y.EntityTypeID 
and mp.MappingtypeKey = y.MappingTypeKey) Duplicatevalue, 
( SELECT TOP 1 MAX(mp.CreatedDate) from mapping.Mapping (nolock) mp where mp.ValueStringChecksum = y.ValueStringChecksum  and mp.EntityTypeID = y.EntityTypeID 
and mp.MappingtypeKey = y.MappingTypeKey) MaxCreateDate 
from 
( 
select m.*, et.EntityTypeCode 
from #mappingdups  m 
inner join entity.EntityType et 
on et.EntityTypeID = m.EntityTypeID 
) y 
) z
order by z.MaxCreateDate desc