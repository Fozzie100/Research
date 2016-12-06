/*
Missing Index Details from RFK360_queries transformed.sql - LDNDCM05330V05B\LF6_MAIN2_DEV.JUNOOP_DEV (INTRANET\pullingp (297))
The Query Processor estimates that implementing the following index could improve the query cost by 19.0196%.
*/

/*
USE [JUNOOP_DEV]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [INTRANET\bakeran3].[account_risk_fact] ([account_key])
INCLUDE ([cob_date_key],[exposure_amount],[exposure_at_default_amount])
GO
*/
