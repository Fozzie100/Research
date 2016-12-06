
--
-- get list of missing runs for which a notification item has been generated 
-- for the particular entity, BUT which has not made it onto the SCD dimension table
-- i.e. bi.CounterpartyIDAttrSCD.
-- Then run the wrapper:
-- i.e. exec bi.uspLoadDimensionDataWrapper @p_run=76
select distinct run 
from changenotification.Item i (nolock) 
INNER JOIN entity.EntityType t (nolock) ON t.EntityTypeID = i.EntityTypeId 
AND t.EntityTypeCode = 'ApplicationIdAttr' 
LEFT JOIN bi.ApplicationIdSCD c (nolock) ON c.ApplicationIdAttrKeyID = i.EntityKey 
WHERE c.ApplicationIdAttrKeyID IS NULL 
-- Run=76
-- select * from entity.EntityType where EntityTypeCode like 'Applic%'

select distinct run 
from changenotification.Item i (nolock) 
INNER JOIN entity.EntityType t (nolock) ON t.EntityTypeID = i.EntityTypeId 
AND t.EntityTypeCode = 'ActiveAccountStartDateAttr' 
LEFT JOIN bi.ActiveAccountStartDateAttrSCD c (nolock) ON c.ActiveAccountStartDateAttrKeyID = i.EntityKey 
WHERE c.ActiveAccountStartDateAttrKeyID IS NULL 
--  76

select distinct run 
from changenotification.Item i (nolock) 
INNER JOIN entity.EntityType t (nolock) ON t.EntityTypeID = i.EntityTypeId 
AND t.EntityTypeCode = 'ActiveAccountEndDateAttr'
LEFT JOIN bi.ActiveAccountEndDateAttrSCD c (nolock) ON c.ActiveAccountEndDateAttrKeyID = i.EntityKey 
WHERE c.ActiveAccountEndDateAttrKeyID is NULL
-- null


select distinct run 
from changenotification.Item i (nolock) 
INNER JOIN entity.EntityType t (nolock) ON t.EntityTypeID = i.EntityTypeId 
AND t.EntityTypeCode = 'OriginalAccountStartDateAttr'
LEFT JOIN bi.OriginalAccountStartDateAttrSCD c (nolock) ON c.OriginalAccountStartDateAttrKeyID = i.EntityKey 
WHERE c.OriginalAccountStartDateAttrKeyID is NULL
-- 76

select distinct run 
from changenotification.Item i (nolock) 
INNER JOIN entity.EntityType t (nolock) ON t.EntityTypeID = i.EntityTypeId 
AND t.EntityTypeCode = 'LogicalAccountPurgeDateAttr'
LEFT JOIN bi.UniDateSCD c (nolock) ON c.UniDateAttrKeyID = i.EntityKey 
WHERE c.UniDateAttrKeyID is NULL
-- null
-- 'OriginalAccountStartDateAttr','ActiveAccountStartDateAttr','ActiveAccountEndDateAttr','LogicalAccountPurgeDateAttr'

-- now run wrapper to move data from entities to bi dimension tables
exec bi.uspLoadDimensionDataWrapper @p_run=76

-- ApplicationIDAttr - missing bi. dimension table runs
--10
--13
--14
--171
--179
--223
--226
-- exec bi.uspLoadDimensionDataWrapper @p_run=226