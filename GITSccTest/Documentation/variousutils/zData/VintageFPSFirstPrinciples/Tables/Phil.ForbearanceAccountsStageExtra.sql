USE [BCARD_PROD]
GO

/****** Object:  Table [Phil].[ForbearanceAccountsStageExtra]    Script Date: 19/04/2016 18:18:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Phil].[ForbearanceAccountsStageExtra](
	[pkForbearanceAccountsStageExtra] [int] IDENTITY(1,1) NOT NULL,
	[N9Run] [bigint] NULL,
	[COBdate] [date] NOT NULL,
	[AccountNumber] [varchar](64) NOT NULL,
	[PlanCreateDateRaw] [varchar](16) NULL,
	[DataSource] [varchar](16) NOT NULL,
	[NetBalanceFinance] [decimal](28, 8) NULL,
	[G1Run] [bigint] NULL,
	[TCRun] [bigint] NULL,
	[HistoricalRun] [bigint] NULL,
	[PlanCreateDateCalculated] [date] NULL,
	[Division] [varchar](16) NULL,
 CONSTRAINT [PK_ForbearanceAccountsStageExtra] PRIMARY KEY CLUSTERED 
(
	[pkForbearanceAccountsStageExtra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BCARD_PROD_Group1]
) ON [BCARD_PROD_Group1]

GO

SET ANSI_PADDING ON
GO

