
select CYCLES.Opening_Balance, base.NetBalance, y.*,  r.TCQCND , co.KEUYCT chargeoffdate, co.KEWTCF chargeoffamount, co.KEP1ND, cycles.KFP1ND
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
					 inner join 
					 (select TCE5CD
        					,TCQCND
							 from  dbo.TCDEBTP_201507_SUBSET1) r
					on r.TCE5CD = y.N9E5CD
					inner join (
					SELECT KFP1ND
			   		   ,KFWFVA as Opening_Balance
        	           --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
                       -- else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
                FROM dbo.KFDEBTP_201507_SUBSET1 
				where KFWTCF = 'ACCT01' /*and KFMISV ='TC'*/
				) AS CYCLES
                ON r.TCQCND = CYCLES.KFP1ND
				inner join 

				(
				Select KEP1ND, KEUYCT, KEWTCF
				FROM dbo.KEDEBTP201507_SUBSET1


				) co
				on co.KEP1ND = r.TCQCND
				and co.KEWTCF = 'ACCT01'
	inner join  dbo.IMPAIR_BASE_201507 base
	on base.Account_No = y.N9HOTX
	where y.N9HOTX in ( '0414710106945219', '0414710121934206', '0475230081700626'
	, '0900870077671003', '0953480101569680', '0414710114998929')
	or y.N9HOTX like  '140035010931482%'
	 or y.N9HOTX like '140057009783791%'
	 or y.N9HOTX like '170068009582033%'



	select top 100 * from dbo.KFDEBTP_201507_SUBSET1 where KFP1ND = '2000549727'
	select top 100 * from dbo.KEDEBTP201507_SUBSET1 where KEP1ND = '2000549727'
	select top 100 * from dbo.G1DEBTP_201507_SUBSET1 where G1E5CD = '2000549727'
	select top 100 * from dbo.N9DEBTP_201507 where N9E5CD = '2000549727'

	select top 100 * from dbo.IMPAIR_BASE_201507 where Account_No = '0900870077671003'

	CREATE INDEX Idx1 ON dbo.KEDEBTP201507_SUBSET1(KEP1ND);
	CREATE INDEX Idx2 ON dbo.KFDEBTP_201507_SUBSET1 (KFP1ND);
	CREATE INDEX Idx3 ON dbo.TCDEBTP_201507_SUBSET1 (TCE5CD)
	CREATE INDEX Idx4 ON dbo.IMPAIR_BASE_201507 (Account_No)


	select  top 10 * from dbo.BPFWH_APPFILE_JUL2015

	select * from dbo.KEDEBTP201507_SUBSET1 where  KEP1ND = '1000576722'
	and KEWTCF = 'ACCT01'

	select TCE5CD
        					,TCQCND
							 from  dbo.TCDEBTP_201507_SUBSET1
							 where TCE5CD = '1000058012'



	SELECT KFP1ND
			   		   ,KFWFVA as Opening_Balance
        	           --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
                       -- else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
                FROM dbo.KFDEBTP_201507_SUBSET1 
				where KFWTCF = 'ACCT01' and KFP1ND = '1000576722'



					---select top 100 * from dbo.KFDEBTP_201507_SUBSET1