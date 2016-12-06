
-- do this for July 2015
 --select count(*) from dbo.N9DEBTP_201507			---- cnt=3559343  N9HOTX is account no
 --select count(*) from dbo.G1DEBTP_201507_SUBSET1	---- cnt=1202917
 --select count(*) from dbo.IMPAIR_BASE_201507	--- cnt=1257201


 select  top 1000 x.* from dbo.N9DEBTP_201507 x
 where not exists (select top 1 1 from dbo.IMP_STOCK_ACCT_JUL15 where Account_No = x.N9HOTX)



 0050220115869649 
 --
 -- SAS Code to  get the account in Recovery
 -- as 
 --
--create table RP_Final as 
--select account_no,division,NetBal_Fin_&monyy. as Account_Open_Balance 
--from Impair_Data_&monyy. 
--where impair_flag = 2 and coff_flag ne 1 and 
--account_no not in (select distinct account_no from ddata.imp_base_&premonyy. where impair_flag = 2); 


-- select count (*) from #inter3
 --drop table #inter3

                     select y.* 
                     into #inter3
                     from

                     (

                       select  x.*, 
                       CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
              WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
              WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other'
              ELSE 'Missing'  END AS Division,
              --,
                     tt.G1AIDX DateG1AIDX,
					 tt.G1UEDT DateG1UEDT
                    from dbo.N9DEBTP_201507 x
                     
                     INNER join 
                      (


                        select  zz.* 
                      from dbo.G1DEBTP_201507_SUBSET1 zz
                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
                     --AND run = 5005627
                     ) tt on tt.G1E5CD = x.N9E5CD
                       where x.N9ADCD = 'BPF'
                       --and x.run = 5005645
                     ) y
					 
					 
					 
		--select * from 	#inter3		where DateG1AIDX like '%JUL2015%'
		--							or DateG1UEDT like '%JUL2015%'
					 
					 
select 
tmp.ProductGroup, tmp.grip_arrears_level, 
tmp.coff_flag, 
cast(tmp.netbalance_finance_m127 as decimal(30,10) ) ENR,
tmp.Account_No,
--sum(cast(netbalance_finance_m127 as decimal(30,10) )) as ENR, 
------sum(cast(N9UOAM as decimal(30,10) )) as ENR1, 
--count(Account_No) as AccountsInENR, 
'31-JULY' as COBDATE 
into ##julFPAccs
from 
( 
select  -- base.*, 
base.grip_arrears_level,
base.coff_flag,
base.Account_No,
noyr.netbalance_finance_m127, 
fp.N9UOAM,
--fp.G1PAVC,
case 
when base.product_grp in (1,4) then 'Motor' 
when base.product_grp in (2,3) then 'Retail' 
else 'Unknown' 
end as ProductGroup 
-- from stg. BARCLAYCARD_IMPAIR_BASE base 
from dbo.IMPAIR_BASE_201507 base 
--from dbo.IMP_STOCK_ACCT_JUL15 base
INNER join #inter3 fp
    on base.account_no = fp.N9HOTX 
inner join dbo.VNTG_NETBALANCE_FINANCE_NOYR_201507 noyr -- select  top 1000 * from dbo.VNTG_NETBALANCE_FINANCE_NOYR_201507 where netbalance_finance_m128 <> ''
    on base.account_no = noyr.account_no 
where 1 = 1
and base.NetBalance is not null 
and base.NetBalance <>'' 
and base.impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
and base.in_scope = 1 
and base.coff_flag <> 1 
-- and base.run = 5000285 -- 2015-06-30 
--and base.run = 1104   -- BARCLAYCARD_IMP_STOCK_ACCT
--and noyr.Run = 1078 
 and noyr.netbalance_finance_m127 is not null 
 and noyr.netbalance_finance_m127 <> '' 
-- and base.account_open_month like '%JUN15%'
  --and ( fp.DateG1UEDT like '%JUL2015%' 
--  or  fp.DateG1AIDX like '%JUL2015%' 
 --)
) tmp 
where ProductGroup = 'Motor'
--order by ProductGroup

group by ProductGroup ,coff_flag ,grip_arrears_level 



-- find missing 
select top 10 *
from dbo.VNTG_NETBALANCE_FINANCE_NOYR_201507 noyr
WHERE isnumeric(noyr.netbalance_finance_m127)=1 and CONVERT(DECIMAL(38,10), isnull(noyr.netbalance_finance_m127,0)) between 86 and 87 -- ( 1057.18, 86.68)


-- account_no =0625150095521447


select count(*) from dbo.N9DEBTP_201507 
select count(*) from dbo.G1DEBTP_201507_SUBSET1

select top 100 * from dbo.N9DEBTP_201507 where N9HOTX = '0625150095521447'

select top 100 * from dbo.G1DEBTP_201507_SUBSET1
 where G1E5CD = '12000044389'
-- AND  noyr.Run = 1078 
