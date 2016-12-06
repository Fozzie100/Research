-- tables
--  select top 100 * from stg.[N9DEBTP]
-- debt_eom.n9debtp_&yyyymm
-- debt_eom.G1DEBTP_&yyyymm
-- debt_eom.TCDEBTP_&yyyymm
-- debt_eom.KFDEBTP_&yyyymm
-- debt_eom.KEDEBTP_&yyyymm.

--tables
--
-- GRCR_DEV
--[dbo].[N9DEBTP_201507]
--[dbo].[G1DEBTP_201507_SUBSET1]
--[dbo].[TCDEBTP_201507_SUBSET1]
--[dbo].[KFDEBTP_201507_SUBSET1]
--[dbo].[KEDEBTP201507_SUBSET1]



USE GRCR_DEV
                     select top 100 j.CobDate, x.* 
                      from stg.KEDEBTP x
                     inner join loader.JobRun jr
                     on jr.Run = x.Run
                     inner join loader.Job j
                     on j.JobId = jr.JobId
                     where j.CobDate = '30 Jun 2015'

USE GRCR_DEV
                       select top 100000000  x.* 
                      from [dbo].[G1DEBTP_201507_SUBSET1] x
                     --inner join loader.JobRun jr
                     --on jr.Run = x.Run
                     --inner join loader.Job j
                     --on j.JobId = jr.JobId
                     --where j.CobDate = '30 Jun 2015'
                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0


                     select y.* into #inter from

                     (

                       select  x.*, 
                       CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
              WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
              WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other'
              ELSE 'Missing'  END AS Division,
                       tt.*
                     from [dbo].[N9DEBTP_201507] x
                     
                     INNER join 
                      (

                        select  zz.* 
                      from [dbo].[G1DEBTP_201507_SUBSET1] zz
                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
                     ) tt on tt.G1E5CD = x.N9E5CD
                       where x.N9ADCD = 'BPF'
                     ) y
                     inner join [dbo].[TCDEBTP_201507_SUBSET1] TC
                     on TC.TCE5CD = y.N9E5CD
                     
                      select top 100 * FROM #inter --group by division
					  select top 1000 * FROM #inter2  where Division  <> 'Motor' and Division <> 'Retail'
					  and DateG1UEDT like '%JUN2015%' 
					  where  1 = 1
					  -- and dateG1AIDX like '%JUN2015%' --group by division
					  and DateG1UEDT like '%JUN2015%' --group by division


					   select top 100 * FROM dbo.KFDEBTP_201507_SUBSET1
					   select top 100 * from  dbo.KEDEBTP201507_SUBSET1
                     SELECT top 100  KFP1ND
                                      ,KFWFVA as Opening_Balance
                         --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
                        --else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
                FROM dbo.KFDEBTP_201507_SUBSET1 f
                           INNER JOIN dbo.KEDEBTP201507_SUBSET1 e
                           on 
                           
                           where KFWTCF = 'ACCT01' and KFMISV ='TC' AS CYCLES
                     


					 --drop table #inter2

                     select y.* 
                     into #inter2
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
                    from [stg].[N9DEBTP] x
                     
                     INNER join 
                      (


                        select  zz.* 
                      from [stg].[G1DEBTP] zz
                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
                     AND run = 5005627
                     ) tt on tt.G1E5CD = x.N9E5CD
                       where x.N9ADCD = 'BPF'
                       and x.run = 5005645
                     ) y
--                     ) tmp
                     
                     
                     
                     inner join [dbo].[TCDEBTP_201507_SUBSET1] TC
                     on TC.TCE5CD = y.N9E5CD
                     
                      select * FROM #inter2 where N9HOTX not in (SELECT N9HOTX from #inter)
                      select * FROM #inter2 where N9HOTX in (SELECT N9HOTX from #inter)
                      select * FROM #inter where N9HOTX not in (SELECT N9HOTX from #inter2)
                      select * FROM #inter where N9HOTX in (SELECT N9HOTX from #inter2)

                      EXCEPT 
                      SELECT * FROM #inter
                            --group by division

                     SELECT top 100  KFP1ND
                                      ,KFWFVA as Opening_Balance
                         --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
                        --else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
                FROM dbo.KFDEBTP_201507_SUBSET1 f
                           INNER JOIN dbo.KEDEBTP201507_SUBSET1 e
                           on 
                           
                           where KFWTCF = 'ACCT01' and KFMISV ='TC' AS CYCLES
                     














                      select ',''' + N9HOTX + ''''

                      FROM #inter2 --group by division


select top 100 * from stg.BARCLAYCARD_IMPAIR_BASE where coff_flag <> '1' and  coff_flag <> '0'

select COUNT(*) from stg.BARCLAYCARD_IMPAIR_BASE where run = 5000285 and account_no in (select N9HOTX from #inter)
select COUNT(*) from [stg].[BARCLAYCARD_IMP_STOCK_ACCT] where run = 1104 and account_no in (select N9HOTX from #inter)

select * from loader.JobRun jr INNER JOIN loader.Job j on jr.JobId = j.JobId where jr.run in (5000554,5000610,1104)

--
-- start of query analysis
--
select * from #inter2 where N9HOTX = '0930810092322798'


where N9HOTX in
(
'436210122315384',
'414710104756311',
'1206490104778690',
'166810095251585',
'1700200101051570',
'9020690089877570',
'930810092322798',
'9020010107134970',
'9020990104495840',
'1400400080342840'

)



select * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
where run =1078
and account_no in 
(
'0436210122315384',
'0414710104756311',
'1206490104778694',
'0166810095251585',
'1700200101051578',
'9020690089877570',
'0930810092322798',
'9020010107134971',
'9020990104495840',
'1400400080342849'
)
select top 100 * from stg.BARCLAYCARD_IMPAIR_BASE
where run = 5000285
and Account_No in ('9020990104495840', '9020690089877570')




select ProductGroup, grip_arrears_level, 
coff_flag, 
sum(cast(netbalance_finance as decimal(30,10) )) as ENR, 
-- sum(cast(N9UOAM as decimal(30,10) )) as ENR1NOTREQUIRED, 
--sum(cast(G1PAVC as decimal(30,10) )) as ENR2, 
count(Account_No) as AccountsInENR, 
'30-JUNE' as COBDATE
--,tmp.DateG1AIDX
--,tmp.N9HOTX
--,DATENAME(mm, tmp.DateG1AIDX) mthName
, count(*) cnt
from 
( 
select  -- base.*, 
base.grip_arrears_level,
base.coff_flag,
base.Account_No,
noyr.netbalance_finance, 
fp.N9UOAM,
fp.DateG1AIDX,
fp.N9HOTX,
--fp.G1PAVC,
case 
when product_grp in (1,4) then 'Motor' 
when product_grp in (2,3) then 'Retail' 
else 'Unknown' 
end as ProductGroup 
from stg.BARCLAYCARD_IMPAIR_BASE base 
-- from stg.BARCLAYCARD_IMP_STOCK_ACCT base 
INNER join #inter2 fp
    on base.account_no = fp.N9HOTX 
left join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
    on base.account_no = noyr.account_no 
where 1 = 1
and NetBalance is not null 
and NetBalance <>'' 
-- and impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
and in_scope = 1 
and coff_flag <> 1 
and base.run = 5000285 -- 2015-06-30 
-- and base.run = 1104   -- BARCLAYCARD_IMP_STOCK_ACCT
and noyr.Run = 1078 
and noyr.netbalance_finance is not null 
and noyr.netbalance_finance <> '' 
 -- and base.account_open_month like '%JUN15%'
  --and ( fp.DateG1UEDT like '%JUN2015%'   --- or fp.DateG1AIDX like '%JUN2015%'
  -- )
 and fp.DateG1UEDT like '%JUN2015%'
) tmp 
group by ProductGroup ,coff_flag ,grip_arrears_level   -- , tmp.DateG1AIDX, tmp.N9HOTX

-- select top 100 * from stg.BARCLAYCARD_IMP_STOCK_ACCT
-- select top 100 * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR 

-- select * from stg.BARCLAYCARD_IMPAIR_BASE


select  base.*, 
noyr.netbalance_finance,
--fp.N9UOAM,
--fp.G1PAVC,
case 
when product_grp in (1,4) then 'Motor' 
when product_grp in (2,3) then 'Retail' 
else null 
end as ProductGroup 
from stg. BARCLAYCARD_IMPAIR_BASE base 
--INNER join #inter2 fp
--    on base.account_no = fp.N9HOTX 
left outer join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
    on base.account_no = noyr.account_no 
where NetBalance is not null 
and NetBalance <>'' 
and impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
and in_scope = 1 
-- and coff_flag <> 1 
and base.run = 5000285 -- 2015-06-30 
and noyr.Run = 1078 
and noyr.netbalance_finance is not null 
and noyr.netbalance_finance <> '' 
and isnumeric(noyr.netbalance_finance)=1 and CONVERT(DECIMAL(38,10), isnull(noyr.netbalance_finance,0)) = 95.34

select top 10 *
from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
WHERE isnumeric(noyr.netbalance_finance)=1 and CONVERT(DECIMAL(38,10), isnull(noyr.netbalance_finance,0)) = 95.34
AND  noyr.Run = 1078 



                        select  * 
                      from [stg].[N9DEBTP] x
                     INNER join 
					  [stg].[G1DEBTP] zz
					  ON x.N9E5CD = zz.G1E5CD
                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
                     AND zz.run = 5005627
					 and x.Run =5005645
					   and ( G1UEDT like '%JUN2015%' ) 
					   
					   
					   
					    and ( fp.DateG1UEDT like '%JUN2015%' 
  or fp.DateG1AIDX like '%JUN2015%' )
  or G1AIDX like '%JUN2015%' )

