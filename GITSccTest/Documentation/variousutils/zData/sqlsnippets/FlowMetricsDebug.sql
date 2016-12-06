select   
 sum(cast(balance as decimal(30,10) )) as ENR , sum(cast(NetBalance as decimal(30,10) )) as ENR1 , count(Account_No) as AccountsInENR,'30-JUNE' as COBDATE
from 
(
  select  top 1 * from stg. BARCLAYCARD_IMPAIR_BASE
          where  
          NetBalance is not null and NetBalance <>''
          and impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
          and in_scope = 1 
          and  product_grp in (1,2,3,4) 
          and coff_flag <> 1
          and run = 5000285 -- 2015-06-30    
          ) tmp  -- group by impair_flag with rollup





		  
--impair_flag	Book
--1	Core Non-repayment                      
--2	Core Repayment                          
--3	Euro                                    
--4	HLC                                     
--5	Cetelem                                 
--6	Additional-rewrites                     
--7	Out-of_scope-other                      
--8	Core Charge Offs    

select top 100 * from stg. BARCLAYCARD_IMPAIR_BASE base

  select  base.Account_No, base.main_retailer_code, base.impair_flag, base.product_grp,
  base.first_date_payment, base.coff_flag, base.NetBalance, noyr.netbalance_finance
  ,
  Case  when base.product_grp in (1,4) then 'Motor'
          when base.product_grp in (2,3) then 'Retail'
       else 'unknown' end as Division
  --,
	 --  Case  when impair_flag = 8 then 1
  --                 else 0 end as chgoff_flag
  from stg.BARCLAYCARD_IMPAIR_BASE base (NOLOCK)
  left outer join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR(NOLOCK) noyr on base.account_no = noyr.account_no
          where  
          NetBalance is not null and NetBalance <>''
          --  and impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
		  and base.impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other', 'Core Charge Offs') 
          and in_scope = 1 
          and  product_grp in (1,2,3,4) 
          -- and coff_flag <> 1
          and base.run = 5000285 -- 2015-06-30     
           and noyr.Run = 1078 and noyr.netbalance_finance is not null and noyr.netbalance_finance <> '' 

		   --  where a.impair_flag in (1,2,7,8) and a.in_scope = 1 and a.product_grp in(1,2,3,4);
       





		  --Select a.Account_No,
    --      a.main_retailer_code,
    --   a.grip_arrears_level,
    --   a.impair_flag,
    --   a.product_grp,
    --   a.first_date_payment,a.coff_flag,
    --   b.netbalance_finance_m&loopval. as NetBal_Fin_&monyy.,     /* Pick Net Finance Balance */
    --   Case  when product_grp in (1,4) then 'Motor'
    --      when product_grp in (2,3) then 'Retail'
    --   else 'unknown' end as Division format $8.,
    --Case  when impair_flag = 8 then 1
    --               else 0 end as chgoff_flag format 1.
    --from  ddata.imp_base_&monyy. as a left join pdata.vntg_netbalance_finance_noyr as b on
    --    compress(trim(a.account_no)) = compress(trim(b.account_no))
    --         where a.impair_flag in (1,2,7,8)
			 -- and a.in_scope = 1 and a.product_grp in(1,2,3,4);

-- tables
--
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
			 
			 select * FROM #inter

			 SELECT top 100  KFP1ND
			   		   ,KFWFVA as Opening_Balance
        	           --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
                        --else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
                FROM dbo.KFDEBTP_201507_SUBSET1 f
				INNER JOIN dbo.KEDEBTP201507_SUBSET1 e
				on 
				
				where KFWTCF = 'ACCT01' and KFMISV ='TC' AS CYCLES
			 
			 
			 select top 10 * from dbo.KEDEBTP201507_SUBSET1
			 select top 10 * FROM dbo.KFDEBTP_201507_SUBSET1
			 select top 100 * from loader.Job(NOLOCK)
