use GRCR_DEV
go

--select Account_No
--     , count(1) count_of
--from   GRCR_DEV.craig.source_data
--group  by Account_No
--having count(1) > 1
--order by 1 asc

--select top 10 *
--from   GRCR_DEV.craig.source_data
--where  Account_no like '0014510131672208'

--if object_id('craig.source_data_intermediate', 'U') is not null
--    drop table GRCR_DEV.craig.source_data_intermediate
--go

--select *
--into   GRCR_DEV.craig.source_data_intermediate
--from   ( select ROW_NUMBER() over(partition by Account_No order by Account_No, Req_Loan_Amt) rNum
--              , *
--         from   GRCR_DEV.craig.source_data as a
--       ) x 
--where  rNum = 1



---- Motor OK, Retail x
--declare @EDate date = '20150731'

--select a.Division
--     , SUM(a.Req_Loan_Amt) Orig_bal_Vntg
--     , COUNT(a.Account_No) Total_Acnts
--from   GRCR_DEV.craig.source_data_intermediate as a
--       left join GRCR_DEV.dbo.vntg_payplan_book_noyr as b on a.Account_No = b.account_no
--       left join GRCR_DEV.dbo.vntg_arrslvlgrip_book_noyr_m125_m129 as c on a.Account_No = c.account_no
--       left join GRCR_DEV.craig.STRP_Final2 as d on a.Account_No = d.N9HOTX
--where  a.activation_date between '20150701' and '20150731'
--       and b.pay_plan_m127 != 2
--       and isnull(try_convert(date, d.DateG1UEDT), '19000101') != isnull(first_payment_date, '19000101')
--group  by a.Division


--declare @Test table (Division varchar(50), Expected numeric, Actual numeric)

--insert into @Test 
--values ('Motor', 103282591,  103282591.00000000)
--     , ('Retail', 93138257,  93188625.00000000)

--select * 
--     , convert(money, (Expected - Actual)) Diff
--from @Test



select Division
     , CONVERT(VARCHAR, CONVERT(money, SUM(convert(numeric, Current_Balance))),1) Balance1
     , CONVERT(VARCHAR, CONVERT(money, SUM(b.Balance)), 1) Balance2
     , count(a.Account_No) count_of
     , Month_on_Book
from   GRCR_DEV.craig.source2_data a
       left join GRCR_DEV.dbo.JAY_BPF_CHGOFF_DATA b on a.Account_No = b.account_no
where  Month_on_Book in (3, 6) --and Cyc_Level >= 2
group by Division, Month_on_Book

select Division
     , CONVERT(VARCHAR, CONVERT(money, SUM(convert(numeric, Current_Balance))),1) Balance1
     , CONVERT(VARCHAR, CONVERT(money, SUM(b.Balance)), 1) Balance2
     , count(a.Account_No) count_of
     , Month_on_Book
from   GRCR_DEV.craig.source2_data a
       left join GRCR_DEV.dbo.JAY_BPF_CHGOFF_DATA b on a.Account_No = b.account_no
where  Month_on_Book in (12, 18) --and Cyc_Level >= 4
group by Division, Month_on_Book