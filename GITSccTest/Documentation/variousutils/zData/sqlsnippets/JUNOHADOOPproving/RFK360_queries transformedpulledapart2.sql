SET DATEFORMAT ymd

--QUERY 1
SELECT business_date.business_date,
	party.customer_system_reference,
	party_rating.code,
	--last_day(Add_months(business_date.business_date, -1)),
	EOMONTH(DATEADD(month, -1, business_date.business_date)),
	sum(account_risk_fact.exposure_at_default_amount),
	sum(account_risk_fact.exposure_amount),
	party.[key]
	,
	Account_Industry_BIC.lvl1_name
FROM [INTRANET\bakeran3].business_date 
INNER JOIN [INTRANET\bakeran3].account_risk_fact /*WITH( INDEX (ix_account_risk_fact_account_key) )*/ ON (account_risk_fact.cob_date_key=business_date.[key]) 
INNER JOIN [INTRANET\bakeran3].account ON (account.[key]=account_risk_fact.account_key)
INNER JOIN [INTRANET\bakeran3].v_industry_bic  Account_Industry_BIC ON (account.industry_key=Account_Industry_BIC.lvl4_key)
INNER JOIN [INTRANET\bakeran3].account_team_relationship ON (account.[key]=account_team_relationship.account_key)
INNER JOIN [INTRANET\bakeran3].v_team_cth Table__8 ON (account_team_relationship.team_key=Table__8.lvl4_key)
INNER JOIN [INTRANET\bakeran3].party ON (party.[key]=account.counterparty_key)
INNER JOIN [INTRANET\bakeran3].party_rating_relationship ON (party.[key]=party_rating_relationship.party_key)
INNER JOIN [INTRANET\bakeran3].party_rating ON (party_rating_relationship.rating_key=party_rating.[key])
INNER JOIN [INTRANET\bakeran3].party_rating_role ON (party_rating_relationship.role_key=party_rating_role.[key])
WHERE   party_rating_role.code = 'DG_PIT'
AND account_team_relationship.role_code = 'CRP'
--AND ( business_date.business_date >=to_date(last_day(Add_months(trunc({d '2015-09-30'} ,'month') ,-13))) 
AND business_date.business_date >= EOMONTH(DATEADD(month, -13, '2015-09-30'))
--and business_date.business_date <=last_day({d '2015-09-30'})  )
AND business_date.business_date <= EOMONTH('2015-09-30')
AND party_rating.code  NOT IN  ('23','22','0.1')
AND Table__8.lvl1_name IN  ( 'Larger Business SBU','Medium Business and Agriculture SBU','Specialist Products SBU','Scotland and Ireland SBU'  )
GROUP BY  business_date.business_date, 
	party.customer_system_reference, 
	party_rating.code, 
	--last_day(Add_months(business_date.business_date, -1)), 
	EOMONTH(DATEADD(month, -1, business_date.business_date)),
	party.[key]
	, 
	Account_Industry_BIC.lvl1_name