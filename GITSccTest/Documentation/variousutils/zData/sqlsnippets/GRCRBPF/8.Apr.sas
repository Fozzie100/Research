%let month=%sysfunc(putn("&end"d,yymmn6.));
%put &month;

/*This section of code puts the historical balance table in a more user friendly format*/

 proc contents data = pdata.vntg_bal_book_noyr
             out = Bal_contents
             noprint;
run;
Data fields;
set bal_contents;
monthval = input (substr(scan(name, 4, "_"), 2, 4), 8.);
run;
proc sql;
select max (monthval) into: monthval from fields;
quit;
%put &monthval;

%let monthfield = mth_end_bal_m%sysfunc(compress(&monthval.));
Data Balances (keep = account_no month balance) ;
format month date9.;
set pdata.vntg_bal_book_noyr ;
Array Bal {&monthval.} mth_end_bal_m1-&monthfield.;
do i = 1 to &monthval.;
 month = intnx ("month", "31Jan2005"d, i-1, "end");
		balance = bal {i};
    output;
end;
if balance = . then delete ;
run;
/*Extracts out the APR and open dates*/
proc sql ;
create table testing_apr as
		select t1.krkntn			as account_no
				,t1.krmrpr			as apr
				,t1.krupdt			as open_date
				,t1.krantk			as active_cards
				,t1.KRSFNR
				,t2.division_type
from centrac.KNTRSKPF_&month. t1 left outer join
		pdata.vntg_account_details_book t2 on t1.krkntn = t2.account_no ;
quit ;
/*creates an open month variable to make the summary easier later on*/
data testing_apr2 ;
set testing_apr ;
open_month = put(open_date,yymmn6.) ;
run ;
/*join live table to apr's*/
proc sql ;
create table stock_apr as
	select t1.*
			,t2.apr
			,t2.division_type
from Balances t1 left outer join testing_apr2 t2 	
	on t1.account_no = t2.account_no
where Balance > 0 ;
quit ;

/*Creates a summary stock table*/
proc tabulate data = stock_apr out = drop_int.bpf_stock_apr_summary_&month. ;
class month division_type ;
var apr ;
table division_type,apr*mean,month ;
run ;


/*Generates an APR opens summary*/

proc tabulate data = testing_apr2 out =drop_int.bpf_opens_apr_summary_&month. ;
class open_month division_type ;
var apr ;
table division_type,apr*mean,open_month ;
run ;



