select count(*) from [INTRANET\bakeran3].account_risk_fact
select count(*) from [INTRANET\bakeran3].account

select count(*) from [INTRANET\bakeran3].account_team_relationship

select count(*) from [INTRANET\bakeran3].v_industry_bic

select count(*) from [INTRANET\bakeran3].v_team_cth Table__8


USE JUNOOP_DEV
select count(*) from [INTRANET\bakeran3].party
select count(*) from [INTRANET\bakeran3].party_rating_relationship
select count(*) from [INTRANET\bakeran3].party_rating
select count(*) from [INTRANET\bakeran3].party_rating_role


exec sp_help '[INTRANET\bakeran3].[account_team_relationship]'

UPDATE STATISTICS [INTRANET\bakeran3].[party_rating_role];

select role_code, team_key, count(*) 
from [INTRANET\bakeran3].account_team_relationship
group by role_code, team_key