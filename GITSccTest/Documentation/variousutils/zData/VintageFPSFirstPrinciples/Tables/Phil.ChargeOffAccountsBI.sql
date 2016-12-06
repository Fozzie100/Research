USE [BCARD_PROD]
GO

/****** Object:  Table [Phil].[ChargeOffAccountsBI]    Script Date: 19/04/2016 18:16:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Phil].[ChargeOffAccountsBI](
	[pkChargeOffAccountsBI] [int] IDENTITY(1,1) NOT NULL,
	[Anchordate] [date] NOT NULL,
	[PlanCreateDateCalculated] [date] NULL,
	[Division] [varchar](16) NULL,
	[Charge_OffBalance] [decimal](28, 8) NULL,
	[BookDate] [date] NULL,
	[MonthStart] [date] NULL,
	[Arrears_Level] [int] NULL,
	[AccountNumber] [varchar](64) NOT NULL,
	[RunChargeOff] [int] NOT NULL,
	[Datasource] [varchar](16) NOT NULL,
	[COBDateChargeOff] [date] NOT NULL,
	[Charge_OffDate] [date] NULL,
	[MOB] [int] NULL,
	[Metric] [varchar](128) NULL,
 CONSTRAINT [PK_ChargeOffAccountsBI] PRIMARY KEY CLUSTERED 
(
	[pkChargeOffAccountsBI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BCARD_PROD_Group1]
) ON [BCARD_PROD_Group1]

GO

SET ANSI_PADDING ON
GO

