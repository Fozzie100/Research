
data _null_;

call symput ("months", put((intck('month','01Jan2005'd,today())),3.));
call symput("Date1",put(intnx("month",today(),-1,"e"),monyy5.));
run;

%let yyyymm=%sysfunc(putn("&end"d,yymmn6.));
%let date4=%sysfunc(intnx(month,"&sysdate"d,-1,b));
%let start= %sysfunc(putn(&date4,date9.));
%let date=%sysfunc(intnx(month,"&sysdate"d,-1,end));
%let end= %sysfunc(putn(&date,date9.));

%put &months;
%put &yyyymm;
%put &date1.;
%put &end;
%put &start;



data application;
set bpf.bpf_Appfile_&yyyymm.;
Industry_Code = put(MR_code,m2ifmt.)*1;
if prod_code IN ('MLTOPI','MLTOPO','MOTIBT') then industry_code = 22;
if exclude =0;
run;

		data first_pay;
		set eom.KNTRSKPF_&yyyymm. (keep=KRKNTN KRFBDT KRUPDT);
		/*KRFBDT first payment date yyyymmdd*/
		/*KRUPDT is open_date yyyymmdd*/

		format first_pay first_pay2 open_date_centrac date9.;
		first_pay=KRFBDT;/*rename and rerun*/
		first_pay2=intnx('months',first_pay,0);
		open_date_centrac=KRUPDT;
		run;

%macro delqn(yyyymm,monyy,s_date,e_date,i);

Proc sql;
create table coff as
select *,1 as coff_flag 
from jay.bpf_chgoff_data
where chargeoff_date <= &e_date.;
quit;

/* Merge Application Data with Performance data to bring in Account Open Month, Account Open Balance 
        and First Day of Payment */
proc sql;
Create table source_data as
	   Select a.Account_No
	        , a.ind_name
			, a.product_desc
			, a.Req_Loan_Amt
			, b.account_open_month
			, b.account_open_balance
			, c.first_pay
			, c.first_pay2
			, e.coff_flag
			, e.chargeoff_date
			, e.balance as chargeoff_balance
			, f.netbalance_finance_m&i. as Current_Balance
			, case when a.Industry_code = 50 then 'Motor'
			       when a.Industry_code in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22) then 'Retail'
				 else 'unknown' end as Division format $8.
            , case when b.product_code_group in ('FIXED TERM REVOLVING BNPL','LOAN BNPL','LOAN BNPL NIH') then 1
			     else 0 end as BNPL_Flag format 1.
            , intnx('month',c.first_pay,-1,'beginning') as Activation_date format monyy5.
		from  application as a 
		      left join pdata.vntg_account_details_book as b on compress(trim(a.Account_No)) = compress(trim(b.account_no)) 
			  left join first_pay as c on compress(trim(a.Account_No)) = compress(trim(c.krkntn)) 
			  left join coff as e on compress(trim(a.Account_No)) = compress(trim(e.account_no)) 
			  left join pdata.vntg_netbalance_finance_noyr as f on compress(trim(a.Account_No)) = compress(trim(f.account_no))
        where Bus_Decision = 'ACCEPT' and b.Account_open_month <> .;
quit;

/* This Macro Creates the Vintage Metrics for Non FP Account. The Following Metrics are created here
   		1. Original Balance of Vintage
   		2. Deliquency > 30 Days @ 3 and 6 MOB
		3. Deliquency > 90 Days @ 12 and 18 MOB
	    4. Charge off Metrics @ 12 / 24 / 36 MOB
*/

data Vntg_arrlvl_book_&monyy.;
set pdata.vntg_arrslvlgrip_book_noyr (keep = account_no arrears_level_m&i.);
run;

data Vntg_payplan_&monyy.;
set pdata.vntg_payplan_book_noyr (keep = account_no pay_plan_m&i.);
format _numeric_ bestx12.;
run;


/* New Bookings Amount and Accounts */

Proc Sql;
Create table drop_int.bpf_New_bookings_&yyyymm. as
   Select Division,Product_Desc,"&monyy." as Month
		 ,count(Account_No) as New_Booking_Accnts
		 ,Sum(Req_Loan_Amt) as New_Booking_Balance
   from Source_data where Account_Open_month between &s_date. and &e_date.
     group by Division,Product_Desc;
quit;
/* Create Source Data excluding RPs and STRPs */




proc sql;
Create table Source_data_&monyy. as 
   Select a.*,
	      intck('month',Activation_Date,&e_date.) as Month_on_book,
		  c.arrears_level_m&i. as Cyc_Level_&monyy.,
		  d.FP_Start_Date format monyy5.
   From Source_data as a 
        left join vntg_payplan_&monyy. as b on compress(trim(a.Account_No)) = compress(trim(b.account_no)) 
		left join Vntg_arrlvl_book_&monyy. as c on compress(trim(a.Account_No)) = compress(trim(c.account_no)) 
		left join jay.STRP_Final_2_&monyy. as d on compress(trim(a.Account_No)) = compress(trim(d.account_number)) 
   Where b.pay_plan_m&i. <> 2;  				
   /* Exclude Repayment Plans */
quit;


data Source2_data_&monyy.;
set Source_data_&monyy.;

if coff_flag = 1 then Cyc_Level_&monyy. = 99;

if FP_Start_Date = first_pay2 then delete;  					/* Exclude STRPs */
run;

proc sort data = Source2_data_&monyy.;
by Account_No Req_Loan_Amt;
run;

proc sort data = Source2_data_&monyy. nodupkey;
by Account_No ;
run;



/* Original Balance of Vintage */

proc sql;
Create table drop_int.bpf_Orig_Bal_&yyyymm. as                                   
  Select
		Division,Product_Desc,"&monyy." as Month
   		,sum(Req_Loan_Amt) as Orig_bal_Vntg
		,count(Account_No) as Total_Acnts
  from Source2_data_&monyy. where Activation_date between &s_date. and &e_date.
    group by division,Product_Desc;
quit;

/* Deliquency > 30 days @ 3 / 6 Mob */

proc sql;
Create table drop_int.bpf_delqn_30d_&yyyymm. as 
  Select 
	  	division,Product_Desc,"&monyy." as Month,
  		month_on_book,
		sum(Current_Balance) as Balance,
		count(Account_No) as Total_Acnts
  from Source2_data_&monyy. where month_on_book in (3,6) and cyc_level_&monyy. >= 2
	group by division,Product_Desc, month_on_book;
quit;

/* Deliquency > 90 days @ 12 / 18 Mob */

proc sql;
Create table drop_int.bpf_delqn_90d_&yyyymm. as 
  Select 
  		division,Product_Desc,"&monyy." as Month,
  		month_on_book,
		sum(Current_Balance) as Balance,
		count(Account_No) as Total_Acnts
  from Source2_data_&monyy. where month_on_book in (12,18) and cyc_level_&monyy. >= 4
   group by division,Product_Desc,month_on_book;
quit;

/* Create Charge off @ 12 / 24  / 26 MOB */

/* 
As per agreement with Group Risk, the metric is calculated on below assumptions
	1. Consider accounts which are charged off within first 12/24/36 months of booking
	2. Consider Date of First Installment instead of Account Open Date. This will factor in the BNPL products as well
	3. Consider Account Open Balance instead of Balance @ Charge off Point to calculate Metrics
*/

proc sql;
Create table Chgoff_12Mob_&monyy. as
	Select
 		  Division,Product_Desc,"&monyy." as Month
		 ,'Chgoff_12Mob' as Variable
		 ,sum(chargeoff_balance) as Amount
	  	 ,count(Account_No) as Account
   	from Source2_data_&monyy.
		 where Month_on_book = 12 and coff_flag = 1
    group by Division,Product_Desc;
quit;

proc sql;
Create table Chgoff_24Mob_&monyy. as
	Select
 		  Division,Product_Desc,"&monyy." as Month
		 ,'Chgoff_24Mob' as Variable
		 ,sum(chargeoff_balance) as Amount
	  	 ,count(Account_No) as Account
   	from Source2_data_&monyy.
		 where Month_on_book = 24 and coff_flag = 1
    group by Division,Product_Desc;
quit;

proc sql;
Create table Chgoff_36Mob_&monyy. as
	Select
 		  Division,Product_Desc,"&monyy." as Month
   	     ,'Chgoff_36Mob' as Variable
		 ,sum(chargeoff_balance) as Amount
	  	 ,count(Account_No) as Account
   	from Source2_data_&monyy.
		 where Month_on_book = 36 and coff_flag = 1
    group by Division,Product_Desc;
quit;

data drop_int.bpf_Chgoff_Summ_&yyyymm.;
length variable $40.;
set 	Chgoff_12Mob_&monyy.
		Chgoff_24Mob_&monyy.
		Chgoff_36Mob_&monyy.;	

run;
%mend delqn;

%delqn(&yyyymm.,&date1.,"&start."d,"&end."d,&months.);





