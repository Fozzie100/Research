select 
[FILE_SIZE_MB] = 
SUM(convert(decimal(12,2),round(a.size/128.000,2))), 
[SPACE_USED_MB] = 
SUM(convert(decimal(12,2),round(fileproperty(a.name,'SpaceUsed')/128.000,2))), 
[FREE_SPACE_MB] = 
SUM(convert(decimal(12,2),round((a.size-fileproperty(a.name,'SpaceUsed'))/128.000,2))) , 
[FREE_SPACE_INPERCENT] = 
SUM(convert(decimal(12,2),round((a.size-fileproperty(a.name,'SpaceUsed'))/128.000,2)))/SUM(convert(decimal(12,2),round(a.size/128.000,2)))*100, 
[USAGE_SPACE_INPERCENT] = 
100-SUM(convert(decimal(12,2),round((a.size-fileproperty(a.name,'SpaceUsed'))/128.000,2)))/SUM(convert(decimal(12,2),round(a.size/128.000,2)))*100, 
ISNULL(GROUPNAME,'LOGFILE') As FILEGROUP_NAME 
from 
dbo.sysfiles a left outer join sysfilegroups b on a.groupid = b.groupid 
group by groupname 