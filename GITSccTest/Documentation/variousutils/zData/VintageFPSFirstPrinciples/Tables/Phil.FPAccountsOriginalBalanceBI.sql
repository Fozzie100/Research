

USE [BCARD_PROD]
GO

/****** Object:  Table [Phil].[FPAccountsBI]    Script Date: 20/04/2016 16:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Phil].[FPAccountsOriginalBalanceBI](
	[pkFPAccountsOriginalBalanceBI] [int] IDENTITY(1,1) NOT NULL,
	[Anchordate] [date] NOT NULL,
	[PlanCreateDateCalculated] [date] NULL,
	[Division] [varchar](16) NULL,
	[NetBalanceFinance] [decimal](28, 8) NULL,
	[AccountNumber] [varchar](64) NOT NULL,
	[Datasource] [varchar](16) NOT NULL,
	[Metric] [varchar](64) NULL,
	[Account_Open_Balance] [decimal](28, 8) NULL,
 CONSTRAINT [PK_pkFPAccountsOriginalBalanceBI] PRIMARY KEY CLUSTERED 
(
	[pkFPAccountsOriginalBalanceBI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BCARD_PROD_Group1]
) ON [BCARD_PROD_Group1]

GO

SET ANSI_PADDING ON
GO

