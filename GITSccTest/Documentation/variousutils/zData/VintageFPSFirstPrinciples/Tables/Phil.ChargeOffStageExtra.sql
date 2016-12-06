USE [BCARD_PROD]
GO

/****** Object:  Table [Phil].[ChargeOffStageExtra]    Script Date: 19/04/2016 18:17:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Phil].[ChargeOffStageExtra](
	[pkChargeOffStageExtra] [int] IDENTITY(1,1) NOT NULL,
	[Run] [bigint] NOT NULL,
	[Account_no] [varchar](64) NOT NULL,
	[ChargeOff_Date] [date] NULL,
	[ChargeOff_Balance] [decimal](28, 8) NULL,
	[DataSource] [varchar](16) NOT NULL,
	[COBDate] [date] NOT NULL,
	[VntgNetBalFinanceRunIDChargeOffUpdate] [bigint] NULL,
 CONSTRAINT [PK_ChargeOffStageExtra] PRIMARY KEY CLUSTERED 
(
	[pkChargeOffStageExtra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BCARD_PROD_Group1]
) ON [BCARD_PROD_Group1]

GO

SET ANSI_PADDING ON
GO

