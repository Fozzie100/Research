select top 100 * from dbo.SDS_IF023_APP_PhilP

select top 100 * from [dbo].[SDS_IF023_RES4_PhilP]

select top 100 * from [dbo].[SDS_IF023_RES1_PhilP]

sp_help 'dbo.SDS_IF023_APP_PhilP'

 CREATE CLUSTERED INDEX IX_CLI_SDS_IF023_APP_PhilP_ApplicationID 
    ON dbo.SDS_IF023_APP_PhilP (Application_ID);


	 CREATE CLUSTERED INDEX IX_CLI_SDS_IF023_RES4_PhilP_ApplicationID 
    ON dbo.SDS_IF023_RES4_PhilP (Application_ID);


	 CREATE CLUSTERED INDEX IX_CLI_SDS_IF023_RES1_PhilP_ApplicationID 
    ON dbo.SDS_IF023_RES1_PhilP (Application_ID);



	--
	select top 100 x.Application_ID, x.Audit_TimestampMax
from 
(
select Application_ID, MAX(Audit_Timestamp) Audit_TimestampMax
from [dbo].[SDS_IF023_APP_PhilP](nolock) 
where 1 = 1
and Run=  25270 
group by Application_ID
) x
where not exists (select top 1 1 from [dbo].[SDS_IF023_RES4_PhilP](nolock)  z where z.Application_ID = x.Application_ID and z.Audit_Timestamp = x.Audit_TimestampMax and Run=25271)
or  not exists (select top 1 1 from [dbo].[SDS_IF023_RES1_PhilP](nolock)  z where z.Application_ID = x.Application_ID and z.Audit_Timestamp = x.Audit_TimestampMax and Run=25273)




rollback