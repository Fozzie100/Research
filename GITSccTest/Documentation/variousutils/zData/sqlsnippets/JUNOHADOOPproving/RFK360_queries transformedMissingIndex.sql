USE [JUNOOP_DEV]
GO

/****** Object:  Index [cs_account_risk_fact]    Script Date: 09/12/2015 11:39:40 ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [cs_account_risk_fact] ON [INTRANET\bakeran3].[account_risk_fact]
(
	[cob_date_key],
	[account_key],
	[exposure_at_default_amount],
	[expected_loss_amount],
	[risk_tendency_amount],
	[loss_given_default],
	[net_drawn_balance_amount],
	[limit_amount],
	[exposure_amount]
)WITH (DROP_EXISTING = OFF)
GO


USE [JUNOOP_DEV]
GO

/****** Object:  Index [ix_account_risk_fact_cob_date_key_account_key_loss_given_default_inc_many]    Script Date: 09/12/2015 11:40:43 ******/
CREATE UNIQUE NONCLUSTERED INDEX [ix_account_risk_fact_cob_date_key_account_key_loss_given_default_inc_many] ON [INTRANET\bakeran3].[account_risk_fact]
(
	[cob_date_key] ASC,
	[account_key] ASC,
	[loss_given_default] ASC
)
INCLUDE ( 	[risk_tendency_amount],
	[expected_loss_amount],
	[exposure_at_default_amount],
	[exposure_amount],
	[net_drawn_balance_amount],
	[limit_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE [JUNOOP_DEV]
GO

/****** Object:  Index [pk_account_risk_fact_cob_date_key_account_key]    Script Date: 09/12/2015 11:41:08 ******/
ALTER TABLE [INTRANET\bakeran3].[account_risk_fact] ADD  CONSTRAINT [pk_account_risk_fact_cob_date_key_account_key] PRIMARY KEY CLUSTERED 
(
	[cob_date_key] ASC,
	[account_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO



/*
Missing Index Details from RFK360_queries transformed.sql - LDNDCM05330V05B\LF6_MAIN2_DEV.JUNOOP_DEV (INTRANET\pullingp (297))
The Query Processor estimates that implementing the following index could improve the query cost by 19.0196%.
*/
--- 1
DROP INDEX [INTRANET\bakeran3].[account_risk_fact].[ix_account_risk_fact_account_key]
USE [JUNOOP_DEV]
GO
CREATE NONCLUSTERED INDEX [ix_account_risk_fact_account_key]
ON [INTRANET\bakeran3].[account_risk_fact] ([account_key])
INCLUDE ([cob_date_key],[exposure_amount],[exposure_at_default_amount])
GO
--- 2
DROP INDEX [INTRANET\bakeran3].[account_team_relationship].[ix_account_team_relationship_role_code_team_key]
USE [JUNOOP_DEV]
GO
CREATE NONCLUSTERED INDEX [ix_account_team_relationship_role_code_team_key]
ON [INTRANET\bakeran3].[account_team_relationship] ([role_code], [team_key])

GO




