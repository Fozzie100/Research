USE [BCARD_PROD]
GO

/****** Object:  Table [Phil].[FPAccountsChargeOffBI]    Script Date: 19/04/2016 18:19:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Phil].[FPAccountsChargeOffBI](
	[pkFPAccountsChargeOffBI] [int] IDENTITY(1,1) NOT NULL,
	[Anchordate] [date] NOT NULL,
	[PlanCreateDateCalculated] [date] NULL,
	[Division] [varchar](16) NULL,
	[NetBalanceFinance] [decimal](28, 8) NULL,
	[MOBStartDate] [date] NULL,
	[MOBEndDate] [date] NULL,
	[MOBArrearsLevel] [int] NULL,
	[Arrears_Level] [int] NULL,
	[AccountNumber] [varchar](64) NOT NULL,
	[Datasource] [varchar](16) NOT NULL,
	[Charge_OffDate] [date] NULL,
	[MOB] [int] NULL,
	[Metric] [varchar](64) NULL,
 CONSTRAINT [PK_FPAccountsChargeOffBI] PRIMARY KEY CLUSTERED 
(
	[pkFPAccountsChargeOffBI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BCARD_PROD_Group1]
) ON [BCARD_PROD_Group1]

GO

SET ANSI_PADDING ON
GO

