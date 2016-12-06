USE GRCR_DEV
GO



select *
from   loader.Job J
       join loader.JobRun JR ON J.JobId = JR.JobId
where  JobDefinitionCode like 'BARCLAYCARD%'


-- All data is supposed to be for 31 Jul 2015
if not exists (select 1 from sys.schemas where name like 'craig')
begin
    execute sys.sp_executesql N'create schema [craig] authorization [dbo]'
end
go


-- Create vntg_account_details_book table to mimic code behaviour for non_FP_vintage_code_final
if object_id('craig.[vntg_account_details_book]', 'U') is not null
    drop table GRCR_DEV.craig.[vntg_account_details_book]
go

SELECT LTRIM(RTRIM([Account_No])) [Account_No]
     , [Account_Open_Month]
     , [Account_Open_Balance]
into   GRCR_DEV.craig.[vntg_account_details_book]
FROM   [BCARD_SIT].[stg].[BARCLAYCARD_VNTG_ACCOUNT_DETAILS_BOOK] 
WHERE  [Run] = 24
       AND LEN(LTRIM(RTRIM([Account_No]))) > 0
       AND LEN(LTRIM(RTRIM([Account_Open_Month]))) > 0
go


-- Create [application] table to mimic code behaviour for non_FP_vintage_code_final
if object_id('craig.[application]', 'U') is not null
    drop table GRCR_DEV.craig.[application]
go

select LTRIM(RTRIM([Account_No])) [Account_No]
     , CONVERT(decimal(28, 8), A.Req_Loan_Amt) Req_Loan_Amt
     , case when A.Ind_Code = 50 then 'Motor'
            when A.Ind_Code in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22) then 'Retail'
       else 'unknown' 
       end as Division
     , CCNRefNo
into   GRCR_DEV.craig.[application]
from   [BCARD_SIT].[stg].[BARCLAYCARD_BPF_APPLICATION] A
where  A.[Run] = 5 -- 2015-07-31
       AND LEN(LTRIM(RTRIM(A.[Account_No]))) > 0
       AND BUS_Decision = 'ACCEPT' -- Craig OT 2015-10-23 Added in BUS_Decision predicate.
go


-- Create [first_pay] table to mimic code behaviour for non_FP_vintage_code_final
if object_id('craig.first_pay', 'U') is not null
    drop table GRCR_DEV.craig.first_pay
go
select ltrim(rtrim(krkntn)) Account_No
     , nullif(try_convert(date, krupdt), '19000101') open_date
     , nullif(try_convert(date, krfbdt), '19000101') first_payment_date
     , datediff(month, try_convert(date, krupdt), nullif(try_convert(date, krfbdt), '19000101')) first_payment_months
     , dateadd(month, -1,  nullif(try_convert(date, krfbdt), '19000101')) activation_date
into   GRCR_DEV.craig.first_pay
from   GRCR_DEV.dbo.KNTRSKPF
where  LEN(LTRIM(RTRIM(krkntn))) > 0

---################
-- Get the correct month column for the vntg_netbalance_finance_noyr table as create the column as current_balance for ease of use.
if object_id('craig.vntg_netbalance_finance_noyr', 'U') is not null
    drop table GRCR_DEV.craig.vntg_netbalance_finance_noyr
go

declare @GlueDate1 date = '20041201'
      , @MonthColumnToSelect nvarchar(3)

--select DATEDIFF(month, @GlueDate1, '20150731') month1
--     , DATEDIFF(month, @GlueDate2, '20150731') month2
--     , DATEDIFF(month, @GlueDate3, '20150731') month3
     
select @MonthColumnToSelect = DATEDIFF(month, @GlueDate1, '20150731')

declare @SQLSyntax nvarchar(max)
DECLARE @CrLf CHAR(1) = CHAR(10) + CHAR(13)
DECLARE @NewLine NCHAR(7) = '     , '

select @SQLSyntax = CONCAT( 'SELECT LTRIM(RTRIM(account_no)) Account_No', @CrLf
                          , @NewLine, 'netbalance_finance_m', DATEDIFF(month, @GlueDate1, '20150731'), ' Current_Balance', @CrLf
                          , 'INTO   GRCR_DEV.craig.vntg_netbalance_finance_noyr', @CrLf
                          , 'FROM   GRCR_DEV.dbo.VNTG_NETBALANCE_FINANCE_NOYR_201507', @CrLf
                          , 'WHERE  LEN(LTRIM(RTRIM(netbalance_finance_m', @MonthColumnToSelect, '))) > 0'
                          )

EXECUTE sys.sp_executesql @SQLSyntax
GO


-- Get STRP_Final2
if object_id('craig.STRP_Final2', 'U') is not null
    drop table GRCR_DEV.craig.STRP_Final2
go


select y.* 
into   GRCR_DEV.craig.STRP_Final2
from ( select  x.*
            ,  CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail' 
                     WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor' 
                     WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other' 
                  ELSE 'Missing'  
               END AS Division
            , tt.G1AIDX DateG1AIDX
            , tt.G1UEDT DateG1UEDT 
       from   GRCR_DEV.dbo.N9DEBTP_201507 x 
              INNER join ( select  zz.*
                           from GRCR_DEV.dbo.G1DEBTP_201507_SUBSET1 zz 
                           where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0 
                           --AND run = 5005627 
                         ) tt on tt.G1E5CD = x.N9E5CD 
       where x.N9ADCD = 'BPF' 
--and x.run = 5005645 
) y 


if object_id('craig.coff', 'U') is not null
    drop table GRCR_DEV.craig.coff
go

-- Get coff
select x.N9ADCD PortFolio
     , LTRIM(RTRIM(x.N9HOTX)) Account_No
     , y.KFWFVA balance
     , nullif(TRY_CONVERT(DATE, y.KEUYCT), '19000101') chargeoff_date
     , CAST(1 AS BIT) coff_flag
into   GRCR_DEV.craig.coff
from   GRCR_DEV.dbo.N9DEBTP_201507 x
       join ( select top 100 *
              from   GRCR_DEV.dbo.KFDEBTP_201507_SUBSET1 A 
                     left join GRCR_DEV.dbo.KEDEBTP201507_SUBSET1 b on a.KFP1ND = b.KEP1ND
              where  a.KFWTCF like 'ACCT01'     
                     and b.KEWTCF like 'ACCT01'               
            ) y on x.N9E5CD = y.KFP1ND

go


-- Get source_data

if object_id('craig.source_data', 'U') is not null
    drop table GRCR_DEV.craig.source_data
go

select a.*
     , b.Account_Open_Balance
     , b.Account_Open_Month
     , c.activation_date
     , c.first_payment_date
     , c.first_payment_months
     , c.open_date
     , e.balance
     , e.chargeoff_date
     , e.coff_flag
     , e.PortFolio
     , f.Current_Balance
into   GRCR_DEV.craig.source_data
from   GRCR_DEV.craig.[application] A
       LEFT JOIN GRCR_DEV.craig.vntg_account_details_book B ON A.[Account_No] = B.Account_No
       LEFT JOIN GRCR_DEV.craig.first_pay c ON A.[Account_No] = C.Account_No
       LEFT JOIN GRCR_DEV.craig.coff E ON A.Account_No = e.Account_No
       LEFT JOIN GRCR_DEV.craig.vntg_netbalance_finance_noyr f ON A.[Account_No] = f.Account_No

go 
IF NOT EXISTS (SELECT top 1 1 FROM sys.indexes WHERE name='ix_source_data_account_no' AND object_id = OBJECT_ID('GRCR_DEV.craig.source_data'))
	create nonclustered index ix_source_data_account_no
		on GRCR_DEV.craig.source_data (Account_No)
go
IF NOT EXISTS (SELECT top 1 1 FROM sys.indexes WHERE name='ix_vntg_payplan_book_noyr_account_no_pay_plan_m127' AND object_id = OBJECT_ID('GRCR_DEV.dbo.vntg_payplan_book_noyr'))
create nonclustered index ix_vntg_payplan_book_noyr_account_no_pay_plan_m127
    on GRCR_DEV.dbo.vntg_payplan_book_noyr (Account_No, pay_plan_m127)
go

IF NOT EXISTS (SELECT top 1 1 FROM sys.indexes WHERE name='ix_vntg_arrslvlgrip_book_noyr_account_no' AND object_id = OBJECT_ID('GRCR_DEV.dbo.vntg_arrslvlgrip_book_noyr_m125_m129'))
create nonclustered index ix_vntg_arrslvlgrip_book_noyr_account_no
    on GRCR_DEV.dbo.vntg_arrslvlgrip_book_noyr_m125_m129 (Account_No)
go


-- Get no dupes
if object_id('craig.source_data_intermediate', 'U') is not null
    drop table GRCR_DEV.craig.source_data_intermediate
go

select *
into   GRCR_DEV.craig.source_data_intermediate
from   ( select ROW_NUMBER() over(partition by Account_No order by Account_No, Req_Loan_Amt) rNum
              , *
         from   GRCR_DEV.craig.source_data as a
       ) x 
where  rNum = 1

if object_id('craig.source2_data', 'U') is not null
    drop table GRCR_DEV.craig.source2_data
go

declare @EDate date = '20150731'


select a.*
     , DATEDIFF(month, a.activation_date, @EDate) Month_on_Book
     , c.arrears_level_m127 Cyc_Level
     , d.DateG1UEDT FP_Start_Date1
     , d.DateG1AIDX FP_Start_Date2
into   GRCR_DEV.craig.source2_data
from   GRCR_DEV.craig.source_data_intermediate as a
       left join GRCR_DEV.dbo.vntg_payplan_book_noyr as b on a.Account_No = b.account_no
       left join GRCR_DEV.dbo.vntg_arrslvlgrip_book_noyr_m125_m129 as c on a.Account_No = c.account_no
       left join GRCR_DEV.craig.STRP_Final2 as d on a.Account_No = d.N9HOTX
where  b.pay_plan_m127 != 2
       and isnull(try_convert(date, d.DateG1UEDT), '19000101') != isnull(first_payment_date, '19000101')

	   -- (2001417 row(s) affected)
	   select count(*) from  GRCR_DEV.craig.source2_data


