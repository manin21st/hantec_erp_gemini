$PBExportHeader$w_pip5022.srw
$PBExportComments$** 퇴직금 계산
forward
global type w_pip5022 from w_inherite_multi
end type
type dw_main from datawindow within w_pip5022
end type
type dw_pay3month from datawindow within w_pip5022
end type
type dw_bonus1year from datawindow within w_pip5022
end type
type gb_6 from groupbox within w_pip5022
end type
type dw_ymd from datawindow within w_pip5022
end type
type dw_pay_to_retireamt from datawindow within w_pip5022
end type
type cb_process from commandbutton within w_pip5022
end type
type cbx_1 from checkbox within w_pip5022
end type
type cb_calc from commandbutton within w_pip5022
end type
type dw_empbasic from datawindow within w_pip5022
end type
type cb_appendpay from commandbutton within w_pip5022
end type
type cb_insertpay from commandbutton within w_pip5022
end type
type rb_1 from radiobutton within w_pip5022
end type
type rb_2 from radiobutton within w_pip5022
end type
type p_2 from uo_picture within w_pip5022
end type
type p_3 from uo_picture within w_pip5022
end type
type p_4 from uo_picture within w_pip5022
end type
type p_5 from uo_picture within w_pip5022
end type
type p_1 from uo_picture within w_pip5022
end type
type p_6 from uo_picture within w_pip5022
end type
type p_7 from uo_picture within w_pip5022
end type
type p_8 from uo_picture within w_pip5022
end type
type p_9 from uo_picture within w_pip5022
end type
type p_10 from uo_picture within w_pip5022
end type
type p_11 from uo_picture within w_pip5022
end type
type pb_1 from picturebutton within w_pip5022
end type
type pb_3 from picturebutton within w_pip5022
end type
type pb_2 from picturebutton within w_pip5022
end type
type pb_4 from picturebutton within w_pip5022
end type
type gb_4 from groupbox within w_pip5022
end type
type gb_5 from groupbox within w_pip5022
end type
type rr_1 from roundrectangle within w_pip5022
end type
type rr_2 from roundrectangle within w_pip5022
end type
type rr_3 from roundrectangle within w_pip5022
end type
type rr_4 from roundrectangle within w_pip5022
end type
end forward

global type w_pip5022 from w_inherite_multi
string title = "퇴직금 계산"
windowstate windowstate = maximized!
dw_main dw_main
dw_pay3month dw_pay3month
dw_bonus1year dw_bonus1year
gb_6 gb_6
dw_ymd dw_ymd
dw_pay_to_retireamt dw_pay_to_retireamt
cb_process cb_process
cbx_1 cbx_1
cb_calc cb_calc
dw_empbasic dw_empbasic
cb_appendpay cb_appendpay
cb_insertpay cb_insertpay
rb_1 rb_1
rb_2 rb_2
p_2 p_2
p_3 p_3
p_4 p_4
p_5 p_5
p_1 p_1
p_6 p_6
p_7 p_7
p_8 p_8
p_9 p_9
p_10 p_10
p_11 p_11
pb_1 pb_1
pb_3 pb_3
pb_2 pb_2
pb_4 pb_4
gb_4 gb_4
gb_5 gb_5
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_pip5022 w_pip5022

type variables
string	iv_empNo,       &
                iv_empName,   &
                iv_deptcode,  iv_gubn, &
                sfrom_ymd, sto_ymd, il_oldrettag, iRegbn

long          il_year,    il_month,     il_day,    il_workyear
long          il_addyear,    il_addmonth,     il_addday

int             ii_taxrate 
end variables

forward prototypes
public function integer wf_required_check (string as_dataobj, integer ai_row)
public function long wf_getday (string fromdate, string todate)
public function long wf_incomesub (integer arg_workyear)
public subroutine wf_get_bonus_1years (datetime arg_retiredate)
public function long wf_get_servicedays (datetime arg_enterdate, datetime arg_retiredate)
public subroutine wf_get_pay_3months (datetime arg_retiredate, long arg_month_term, string arg_jikjonggubn)
public function double wf_get_taxrate (long arg_taxamt)
end prototypes

public function integer wf_required_check (string as_dataobj, integer ai_row);string syymm
double  d_amt

IF as_dataObj = "d_pip5022_3" THEN   
	if dw_pay3month.accepttext() = -1 THEN RETURN -1

	syymm   = TRIM(dw_pay3month.GetItemString(ai_row, "workym"))
	d_amt   = dw_pay3month.GetItemnumber(ai_row, "supplyamt")
	
	IF syymm ="" OR IsNull(syymm) THEN
		MessageBox("확 인","년월을 입력하십시요!!")
      dw_pay3month.setrow(ai_row)
		dw_pay3month.SetColumn("workym")
		dw_pay3month.SetFocus()
		Return -1
	END IF
	IF d_amt =0 OR IsNull(d_amt) THEN
		MessageBox("확 인","금액 입력하십시요!!")
		dw_pay3month.setrow(ai_row)
		dw_pay3month.SetColumn("supplyamt")
		dw_pay3month.SetFocus()
		Return -1
	END IF	
ELSEIF as_dataObj = "d_pip5022_4" THEN   
	if dw_bonus1year.accepttext() = -1 THEN RETURN -1

	syymm   = TRIM(dw_bonus1year.GetItemString(ai_row, "workym"))
	d_amt   = dw_bonus1year.GetItemnumber(ai_row, "supplyamt")
	
	IF syymm ="" OR IsNull(syymm) THEN
		MessageBox("확 인","년월을 입력하십시요!!")
      dw_bonus1year.setrow(ai_row)
		dw_bonus1year.SetColumn("workym")
		dw_bonus1year.SetFocus()
		Return -1
	END IF
	IF d_amt =0 OR IsNull(d_amt) THEN
		MessageBox("확 인","금액 입력하십시요!!")
		dw_bonus1year.setrow(ai_row)
		dw_bonus1year.SetColumn("supplyamt")
		dw_bonus1year.SetFocus()
		Return -1
	END IF	
END IF

Return 1
end function

public function long wf_getday (string fromdate, string todate);String StartDate,EndDate
Long  sComDay,sDay

StartDate = Left(fromdate,4)+ '-' + Mid(fromdate,5,2) + '-' + Right(fromdate,2)
EndDate   = Left(todate,4)+ '-' + Mid(todate,5,2) + '-' + Right(todate,2)

sComDay   = DaysAfter(Date(StartDate),Date(EndDate))

sDay    = sComDay  + 1



Return sDay
end function

public function long wf_incomesub (integer arg_workyear);//  (((( 퇴직 소득 공제 계산 )))))
//     근속년수를 넘으면 + 1  ===> ex) 5년30일 근무 : 6년으로 계산....
//
//     5년이하               :   30만원 +  년수
//     5년초과 -- 10년이하   :  150만원 +  50만원 * (년수 -  5년)
//    10년초과 -- 20년이하   :  400만원 +  80만원 * (년수 - 10년)
//    20년초과               : 1200만원 + 120만원 * (년수 - 20년)
//====================================================================================

Integer baseYears
Long incomeSub, plusAmt, multiAmt
long ll_tjyear1, ll_tjyear1_1, ll_tjyear1amt, ll_tjyear11
long ll_tjyear2, ll_tjyear2_1, ll_tjyear2amt, ll_tjyear22
long ll_tjyear3, ll_tjyear3_1, ll_tjyear3amt, ll_tjyear33
long ll_tjyear4, ll_tjyear4_1, ll_tjyear4amt, ll_tjyear44

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),   /*퇴직소득근속년수별 공제*/
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear1, :ll_tjyear1_1, :ll_tjyear1amt, :ll_tjyear11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear2, :ll_tjyear2_1, :ll_tjyear2amt, :ll_tjyear22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );
		

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear3, :ll_tjyear3_1, :ll_tjyear3amt, :ll_tjyear33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '3' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear4, :ll_tjyear4_1, :ll_tjyear4amt, :ll_tjyear44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '4' );	


if arg_workyear >= ll_tjyear1 and arg_workyear <= ll_tjyear1_1 then
   plusAmt = ll_tjyear1amt
	multiAmt = ll_tjyear11
	baseYears = ll_tjyear1
elseif arg_workyear >= ll_tjyear2 and arg_workyear <= ll_tjyear2_1 then
   plusAmt = ll_tjyear2amt
	multiAmt = ll_tjyear22
	baseYears = ll_tjyear2
elseif arg_workyear >= ll_tjyear3 and arg_workyear <= ll_tjyear3_1 then
   plusAmt = ll_tjyear3amt
	multiAmt = ll_tjyear33
	baseYears = ll_tjyear3
elseif arg_workyear >= ll_tjyear4 and arg_workyear <= ll_tjyear4_1 then
   plusAmt = ll_tjyear4amt
	multiAmt = ll_tjyear44
	baseYears = ll_tjyear4
end if

incomeSub = plusAmt + multiAmt * ( arg_workyear - baseYears )

Return incomeSub
end function

public subroutine wf_get_bonus_1years (datetime arg_retiredate);//Datetime firstDate, l_date
long month, day, year, row, i, totPayAmt, ll_bonus_yn = 0
double lf_workrate = 0.0, lf_totrate = 0.0
string ym, s_jobdate, s_workym,e_workym

year = Year( Date(arg_retireDate) )
month = Month( Date(arg_retireDate) )
day = Day( Date(arg_retireDate) )


e_workym = string(year) + string(month,'00') 

if month = 12 then
		month = 1
	else
		year	= year - 1
		month = month + 1
	end if
	
s_workym = string(year) + string(month,'00')


//DECLARE CUR_JOBTAG CURSOR FOR
//SELECT	WORKYM, WORKRATE FROM P3_JOBTAG
//WHERE	COMPANYCODE	= :gs_company
//  AND PBTAG			= 'B'
//  AND WORKYM		<= :s_jobdate
//ORDER BY WORKYM DESC;
////////////////////////////////////////////////////////////////////////////////////
//                                                                           ///////
// 퇴직하기전  1년간  상여 현황                                           //////////
//                                                                           ///////
////////////////////////////////////////////////////////////////////////////////////

//ldt_ym = datetime(date( string(year) + "." + string(month) + "." + "01"))
ym = string(year) + string(month) 

SELECT	COUNT(*) INTO :ll_bonus_yn
FROM		P3_EDITDATA
WHERE	   WORKYM		= :ym
	AND	PBTAG			<> 'P'
	AND	EMPNO			= :iv_empno
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_get_bonus_1years(w_23220)", sqlca.sqlerrtext)
	return
end if

if ll_bonus_yn > 0 then
	s_jobdate = ym
else
	if month = 1 then
		month = 12
		year	= year - 1
	else
		month = month - 1
	end if
	
	s_jobdate = string(year) + string(month)

end if

//OPEN CUR_JOBTAG;
//FETCH CUR_JOBTAG INTO :s_workym, :lf_workrate;
//
//DO UNTIL sqlca.sqlcode <> 0
//	lf_totrate += lf_workrate
//	if lf_totrate > 600 then
//		MessageBox("wf_get_bonus_1years(w_23220)", "Data Error(P3_JOBTAG)")
//		return
//	elseif lf_totrate = 600 then
//		exit
//	end if
//	FETCH CUR_JOBTAG INTO :s_workym, :lf_workrate;
//LOOP
//
//CLOSE CUR_JOBTAG;

//year = year(date(left(s_workym, 4)+ "/" +mid(s_workym, 5,2) + "/01" ) )
//month = month(date(left(s_workym, 4)+ "/" +mid(s_workym, 5,2) + "/01"))
//firstDate = Datetime( Date( String(year) + "/" + String(month) + "/01") )
//l_date = f_lastday_month( arg_retireDate )

//row = dw_pay_to_retireamt.Retrieve(gs_company,iv_empNo, "B", firstDate, l_date)

row = dw_pay_to_retireamt.Retrieve(gs_company,iv_empNo, "B", s_workym, e_workym)

i = 1

double soamt
	

dw_bonus1year.SetRedraw ( false )
dw_bonus1year.reset()
DO Until  i > row
   ym = dw_pay_to_retireamt.GetItemstring(row - i + 1, "workym")
   totPayAmt = dw_pay_to_retireamt.GetItemNumber(row - i + 1, "totpayamt")
   dw_bonus1year.InsertRow(0)
   dw_bonus1year.SetItem(i, "companycode", gs_company)
   dw_bonus1year.SetItem(i, "empno", iv_empNo)
   dw_bonus1year.SetItem(i, "pbtag", "B")
   dw_bonus1year.SetItem(i, "workym", ym)
	
	select sum(nvl(bstotpayamt,0)) into :soamt
	from p8_eeditdata
	where compnaycode = :gs_company and
	      workym = :ym and
			pbtag = 'B' and
			empno = :iv_empNo;
	if sqlca.sqlcode <> 0 then
		soamt = 0
	end if
	
	if soamt > 0 then
   	totPayAmt = totPayAmt + soamt
		soamt = 0
	end if
   dw_bonus1year.SetItem(i, "supplyamt", totPayAmt)
	dw_bonus1year.SetItem(i, "todate", sto_ymd)
   i = i + 1
Loop

//dw_bonus1year.SetSort("workym D")
//dw_bonus1year.Sort()
dw_bonus1year.SetRedraw ( true )

Return

end subroutine

public function long wf_get_servicedays (datetime arg_enterdate, datetime arg_retiredate);////////////////////////////////////////////////////////////////////////////////////
//           근무일수 Return....                                                  //  
//           Error 시   -1  Return...........................                     //
////////////////////////////////////////////////////////////////////////////////////
Integer a_year, a_month, a_day, b_year, b_month, b_day, over_year
Long term, years, days, rtDays = 1, rday
Date init_date
String  branch, s_temp , s_lastday, sempno, frdate, todate, sildate
long dd
il_year = 0
il_month = 0
il_day = 0

sempno = dw_empbasic.getitemstring(1,'empno')

a_year  = Year(Date(arg_enterDate))
a_month = Month(Date(arg_enterDate))
a_day   = Day(Date(arg_enterDate))
b_year  = Year(Date(arg_retireDate))
b_month = Month(Date(arg_retireDate))
b_day   = Day(Date(arg_retireDate))

s_lastday = right(f_last_date(left(string(arg_retireDate,'yyyymmdd'),6)),2)

IF  arg_enterdate > arg_retiredate  Then
    MessageBox("wf_get_serviceYears()", "Error - 입사일자가 퇴직일자보다 큽니다!" &
                         , StopSign!, OK!)
    rtDays = -1
    Return rtDays
END IF


frdate = string(arg_enterdate,'YYYYMMDD')
todate = string(arg_retiredate,'YYYYMMDD')

rday = sqlca.fun_get_HJikDay(gs_company,sempno, frdate, todate, 'A');
if rday > 0 then
  sildate = f_afterday(todate, -rday)
  b_year  = long(left(sildate,4))
  b_month = long(mid(sildate,5,2))
  b_day   = long(right(sildate,2))
end if

dd = f_dayterm(frdate, todate) + 1

//// 총일수를 구하는 방법
//init_date = Date( String(b_year) + "/" + String(a_month) + "/" + String(a_day) )
//
//years = b_year - a_year
//days = DaysAfter( init_Date, Date(arg_retireDate) ) + 1
//IF (b_year = 1996) OR (b_year = 2004)  Then
//   IF  days = 366 Then
//       years = years + 1
//       days = 0
//   END IF
//ELSE
//   IF days = 365 Then
//      years = years + 1
//      days = 0
//   END IF
//END IF
//IF  days < 0  Then
//    years = years - 1
//    days  = DaysAfter(Date(String(b_year) + "/01/01"), Date(String(b_year) + "/12/31")) &
//            + days + 1
//END IF
//
//rtDays = (years * 365) + days 


il_day = b_day - a_day + 1 
if il_day < 0 then
	s_temp =	f_lastday_month(string(b_year) + string(b_month) + "01")
	il_day = integer(right(s_temp,2)) + b_day - a_day
	b_month = b_month - 1
else
	if il_day = integer(s_lastday) then
		il_day = il_day - (integer(s_lastday))
		b_month = b_month + 1
	end if
end if

//if il_day >= 1 then
////	b_month = b_month + 1
//	il_day = 0
//end if	

il_month = il_month + (b_month - a_month)
if il_month < 0 then
	il_month = (b_month + 12) - a_month
	b_year = b_year - 1
end if
il_year = b_year - a_year
  

// 근속년수를 산출한다
if (il_month > 0) or (il_day > 0) then
	il_workyear = il_year + 1
else
	il_workyear = il_year
end if


//자사기준 근속년수
long retireyear,addyear

SELECT "P3_RETIRERATE"."RETIREYEAR",   
       "P3_RETIRERATE"."ADDYEAR"  
 INTO  :retireyear , :addyear 		 
 FROM "P3_RETIRERATE"  
WHERE ( "P3_RETIRERATE"."COMPANYCODE" = :gs_company ) AND  
      ( "P3_RETIRERATE"."YEAR" = :il_year )   ;

IF sqlca.sqlcode <> 0 then
	retireyear = il_year
	addyear = 0
end if


if isnull(retireyear) then retireyear = il_year
if isnull(addyear) then addyear = 1

il_addyear = retireyear 
il_addmonth =  il_month 
il_addday   = il_day

il_day = dd

Return  rtDays

end function

public subroutine wf_get_pay_3months (datetime arg_retiredate, long arg_month_term, string arg_jikjonggubn);DATE last_date
long month, day, year, totpayamt, day_term, last_month,Temp_day , basepay , Sudang , i_day
string ym, ls_ym, s_ymd, s_tymd, smonth, sday, syear,sYearMonth,sYearMonthDay, sdate, edate
string retire_date,startdate, gijundate,endday, endyymm, sempno, smastersql,sqltext
int i ,End_i,exceptday, exceptday1,exceptday2,iRtnValue,k,workday, rtnvalue, kk
double i_excpt_amt,iBaseDay,soamt
string lastday, spaygubn
boolean ichk

if dw_empbasic.Accepttext() = -1 then return

sempno = dw_empbasic.Getitemstring(1,'empno')

select paygubn into :spaygubn
from p1_master
where companycode = :gs_company and
      empno = :sempno;

//퇴직전 3개월급여를 가져온다,
last_date = date(arg_retiredate)
retire_date = string(last_date,'YYYYMMDD') 
lastday = right(f_last_date(retire_date),2)
endyymm = left(retire_date,6)
endday = right(retire_date,2)

kk = 1
if right(f_last_date(endyymm),2) = endday then
	startdate = f_aftermonth(endyymm,-2) + '01'
else
   startdate = f_aftermonth(endyymm,-3) + endday             //퇴직일자기준 3개월전의 일자계산		
	ichk = false
	Do While ichk = false
	if f_datechk(startdate) = -1 then
		ichk = false	
		startdate = f_aftermonth(endyymm,-3) + string(long(endday)-kk)
		kk+=1
	else
		ichk = true
	end if
   Loop	

end if

//if endday > '20' then
//   gijundate =  f_aftermonth(endyymm,-2) + '20'
//	exceptday1 = f_dayterm(startdate,gijundate) + 1
//else
//	gijundate = f_aftermonth(endyymm, -3) + '20'
//	exceptday1 = f_dayterm(startdate, gijundate) + 1
//end if
//
//
//if endday >  '20' then
//	gijundate = endyymm + '21'
//	exceptday2 = f_dayterm(gijundate,retire_date) 
//else
//   gijundate = f_aftermonth(endyymm, -1) + '21'
//	exceptday2 = f_dayterm(gijundate, retire_date)
//end if

k = 4
if endday = lastday then 
	exceptday1 = 0
	exceptday2 = 0
	k = 3
end if
//
//sqltext = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,jhtgubn from p1_master'
//sqltext = sqltext + ' where (empno =' + "'"+ sEmpNo +"')" 
//
//sMasterSql = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,paygubn,consmatgubn,kmgubn,engineergubn from p1_master'
//sMasterSql = sMasterSql +' where (empno =' + "'"+ sEmpNo +"')"
//
for i = 1 to k
if i = 1  then
	sYearMonth = f_aftermonth(endyymm, -3)
	sYearMonthDay = f_last_date(sYearMonth)
	exceptday = f_dayterm(startdate,sYearMonthDay) + 1
	workday = exceptday
	sdate = startdate
	edate = sYearMonthDay
	if k = 3 then
		sYearMonth = f_aftermonth(endyymm, -2)
		workday = long(right(f_last_date(sYearMonth+'01'),2))		
		exceptday = 0		
		sdate = sYearMonth+'01'
		edate = f_last_date(sYearMonth)
	end if
elseif i = 2  then
	sYearMonth = f_aftermonth(endyymm, -2)
	if k = 3 then
		sYearMonth = f_aftermonth(endyymm,-1)
	end if
	sYearMonthDay = f_last_date(sYearMonth)
	exceptday = 0
	workday = f_dayterm(sYearMonth+'01',sYearMonthDay) + 1
   sdate = sYearMonth+'01'
	edate = sYearMonthDay
elseif i = 3  then
	sYearMonth = f_aftermonth(endyymm, -1)
	if k = 3 then
		sYearMonth = endyymm
	end if
	sYearMonthDay = f_last_date(sYearMonth)
	exceptday = 0
	workday = f_dayterm(sYearMonth+'01',sYearMonthDay) + 1
	sdate = sYearMonth+'01'
	edate = sYearMonthDay
elseif i = 4  then
	sYearMonth = endyymm
	sYearMonthDay = retire_date
	exceptday = f_dayterm(sYearMonth+'01',sYearMonthDay) + 1
	workday = exceptday
   sdate = sYearMonth+'01'
	edate = sYearMonthDay
end if


//rtnvalue = sqlca.sp_mkuntaetime_retire(sYearMonth, sqltext, gs_company, sdate, edate, '1')
//IF rtnValue <> 1 then
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text ='근태 집계 실패!!'
//else
//  commit;	
//END IF
//
//
//iRtnValue = sqlca.sp_calculation_retireamount(sYearMonth,sYearMonthDay,'P',100,sMasterSql,gs_company,exceptday);
//
//IF iRtnValue <> 1 then
//	MessageBox("확 인","급여 계산 실패!!")
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text =''
//	Return
//END IF
//commit;

if spaygubn = '3' then  //연봉직이면
    select yearamt into :Basepay
	 from p3_edityearpay
	 where yymm = (select max(yymm) from p3_edityearpay where yymm <= substr(:retire_date,1,6) and empno = :sempno ) and
	       empno = :sempno;
	 if IsNull(Basepay) then Basepay = 0
	 sudang = 0
	 Basepay = truncate(Basepay / 12, 0)
	 totpayamt = Basepay

else
	
	SELECT TOTPAYAMT,              BASEPAY ,        TOTPAYAMT - BASEPAY
    into  :totpayamt,            :Basepay,         :Sudang
	 FROM  P3_EDITDATA
	 WHERE WORKYM = :sYearMonth  AND  
			 PBTAG = 'P'  AND  
			 EMPNO = :sempno	;
	IF SQLCA.SQLCODE <> 0 THEN
		totpayamt = 0
		Basepay   = 0
		Sudang    = 0
	END IF	
	select nvl(bstotpayamt,0) into :soamt
	from p8_eeditdata
	where companycode = :gs_company and
	      workym = :sYearMonth and
			pbtag = 'P' and
			empno = :sempno;
	if sqlca.sqlcode <> 0 then
		soamt = 0
	end if
	if soamt > 0 then
		sudang = sudang + soamt
		totpayamt = totpayamt + soamt
	end if
	
end if

	dw_pay3month.InsertRow(0)
	if long(right(f_last_date(sYearMonth+'01'),2)) <> workday and i = 1 then
		sudang = round(sudang * workday / 30 ,0)
		basepay = round(basepay * workday / 30 ,0)
		totpayamt = round(totpayamt * workday / 30 ,0)
   end if	
	if spaygubn = '3' and i = 4 then
		basepay = round(basepay * workday / 30 ,0)
		totpayamt = round(totpayamt * workday / 30 ,0)
	end if	
	
	dw_pay3month.SetItem(i, "companycode", gs_company)
	dw_pay3month.SetItem(i, "empno", sempNo)
	dw_pay3month.SetItem(i, "pbtag", "P")
	dw_pay3month.SetItem(i, "workym", sYearMonth)
	dw_pay3month.SetItem(i, "supplyamt", totpayamt)
	dw_pay3month.SetItem(i, "basepay", basepay)
	dw_pay3month.SetItem(i, "sudang", sudang)
	dw_pay3month.SetItem(i, "workdd", workday)
	dw_pay3month.SetItem(i, "todate", sYearMonthDay)
	
//	month = month - 1
//	if month < 1 then 
//		year = year - 1
//		month = 12
//	end if

Next

//dw_pay3month.SetSort("workym D")
//dw_pay3month.Sort()
dw_pay3month.SetRedraw ( true )

Return


end subroutine

public function double wf_get_taxrate (long arg_taxamt);Integer taxRate
long addsubamt, outputtax
long ll_san1, ll_san1_1, ll_san1per, ll_san11, ll_san2, ll_san2_1, ll_san2per, ll_san22
long ll_san3, ll_san3_1, ll_san3per, ll_san33, ll_san4, ll_san4_1, ll_san4per, ll_san44

taxRate = 0
addsubamt = 0
outputtax = 0

/*소득세 속산법(과세표준 * 세율 - 누진공제 = 산출세액 )*/       /*과세표준(누진공제율)*/    
SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san1, :ll_san1_1, :ll_san1per, :ll_san11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '1');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san2, :ll_san2_1, :ll_san2per, :ll_san22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '2');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san3, :ll_san3_1, :ll_san3per, :ll_san33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '3');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san4, :ll_san4_1, :ll_san4per, :ll_san44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '4');
		
		
if arg_taxamt >= ll_san1 and arg_taxamt <  ll_san1_1 then
		outputtax = arg_taxamt * ll_san1per / 100 - ll_san11
		taxrate = ll_san1per
elseif arg_taxamt >= ll_san2 and  arg_taxamt < ll_san2_1 then
		outputtax = arg_taxamt * ll_san2per / 100 - ll_san22
		taxrate = ll_san2per
elseif arg_taxamt >= ll_san3 and  arg_taxamt < ll_san3_1 then
		outputtax = arg_taxamt * ll_san2per / 100 - ll_san33
		taxrate = ll_san3per
elseif	arg_taxamt >= ll_san4 and  arg_taxamt < ll_san4_1 then
		outputtax = arg_taxamt * ll_san2per / 100 - ll_san44
		taxrate = ll_san4per
end if



ii_taxrate = taxrate

Return outputtax

end function

on w_pip5022.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_pay3month=create dw_pay3month
this.dw_bonus1year=create dw_bonus1year
this.gb_6=create gb_6
this.dw_ymd=create dw_ymd
this.dw_pay_to_retireamt=create dw_pay_to_retireamt
this.cb_process=create cb_process
this.cbx_1=create cbx_1
this.cb_calc=create cb_calc
this.dw_empbasic=create dw_empbasic
this.cb_appendpay=create cb_appendpay
this.cb_insertpay=create cb_insertpay
this.rb_1=create rb_1
this.rb_2=create rb_2
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_5=create p_5
this.p_1=create p_1
this.p_6=create p_6
this.p_7=create p_7
this.p_8=create p_8
this.p_9=create p_9
this.p_10=create p_10
this.p_11=create p_11
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_4=create pb_4
this.gb_4=create gb_4
this.gb_5=create gb_5
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_pay3month
this.Control[iCurrent+3]=this.dw_bonus1year
this.Control[iCurrent+4]=this.gb_6
this.Control[iCurrent+5]=this.dw_ymd
this.Control[iCurrent+6]=this.dw_pay_to_retireamt
this.Control[iCurrent+7]=this.cb_process
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.cb_calc
this.Control[iCurrent+10]=this.dw_empbasic
this.Control[iCurrent+11]=this.cb_appendpay
this.Control[iCurrent+12]=this.cb_insertpay
this.Control[iCurrent+13]=this.rb_1
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.p_2
this.Control[iCurrent+16]=this.p_3
this.Control[iCurrent+17]=this.p_4
this.Control[iCurrent+18]=this.p_5
this.Control[iCurrent+19]=this.p_1
this.Control[iCurrent+20]=this.p_6
this.Control[iCurrent+21]=this.p_7
this.Control[iCurrent+22]=this.p_8
this.Control[iCurrent+23]=this.p_9
this.Control[iCurrent+24]=this.p_10
this.Control[iCurrent+25]=this.p_11
this.Control[iCurrent+26]=this.pb_1
this.Control[iCurrent+27]=this.pb_3
this.Control[iCurrent+28]=this.pb_2
this.Control[iCurrent+29]=this.pb_4
this.Control[iCurrent+30]=this.gb_4
this.Control[iCurrent+31]=this.gb_5
this.Control[iCurrent+32]=this.rr_1
this.Control[iCurrent+33]=this.rr_2
this.Control[iCurrent+34]=this.rr_3
this.Control[iCurrent+35]=this.rr_4
end on

on w_pip5022.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.dw_pay3month)
destroy(this.dw_bonus1year)
destroy(this.gb_6)
destroy(this.dw_ymd)
destroy(this.dw_pay_to_retireamt)
destroy(this.cb_process)
destroy(this.cbx_1)
destroy(this.cb_calc)
destroy(this.dw_empbasic)
destroy(this.cb_appendpay)
destroy(this.cb_insertpay)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_5)
destroy(this.p_1)
destroy(this.p_6)
destroy(this.p_7)
destroy(this.p_8)
destroy(this.p_9)
destroy(this.p_10)
destroy(this.p_11)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;//dw_pay3month.bringToTop = False        //  퇴직전 3개월 급여, 1년간 상여 DataWindow를 
//dw_bonus1year.bringToTop = False       //  dw_main의 밑으로 함.


dw_empbasic.SetTransObject(SQLCA)
dw_YMD.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)
dw_pay3month.SetTransObject(SQLCA)
dw_bonus1year.SetTransObject(SQLCA)
dw_pay_to_retireamt.SetTransObject(SQLCA)

dw_empbasic.InsertRow(0)
dw_ymd.InsertRow(0)
dw_main.InsertRow(0)

dw_empbasic.setfocus()

il_oldrettag = dw_ymd.getitemstring(1,'oldrettag')



end event

type p_delrow from w_inherite_multi`p_delrow within w_pip5022
boolean visible = false
integer x = 4005
integer y = 2644
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip5022
boolean visible = false
integer x = 3835
integer y = 2644
end type

type p_search from w_inherite_multi`p_search within w_pip5022
boolean visible = false
integer x = 3666
integer y = 2644
end type

type p_ins from w_inherite_multi`p_ins within w_pip5022
boolean visible = false
integer x = 4178
integer y = 2644
end type

type p_exit from w_inherite_multi`p_exit within w_pip5022
integer x = 4384
end type

type p_can from w_inherite_multi`p_can within w_pip5022
integer x = 4210
end type

event p_can::clicked;call super::clicked;setnull(iv_empname)
setnull(iv_empno)
setnull(iv_deptcode)

ib_any_typing = false

dw_empbasic.setredraw(false)
dw_ymd.setredraw(false)
dw_main.setredraw(false)
dw_pay3month.setredraw(false)
dw_bonus1year.setredraw(false)

dw_main.object.hday_t.visible = false
dw_main.object.hday.visible = false

dw_empbasic.RESET()
dw_ymd.RESET()
dw_main.RESET()
dw_pay3month.RESET()
dw_bonus1year.RESET()

dw_empbasic.InsertRow(0)
dw_ymd.InsertRow(0)
dw_main.InsertRow(0)

dw_empbasic.SetColumn("empname")
dw_empbasic.SetFocus()

dw_empbasic.setredraw(true)
dw_ymd.setredraw(true)
dw_main.setredraw(true)
dw_pay3month.setredraw(true)
dw_bonus1year.setredraw(true)

end event

type p_print from w_inherite_multi`p_print within w_pip5022
boolean visible = false
integer x = 4352
integer y = 2640
end type

type p_inq from w_inherite_multi`p_inq within w_pip5022
integer x = 3218
end type

event p_inq::clicked;call super::clicked;long month, row, i, day_term, month_term, last_month, yearcount, yearcnt
Integer rtdays, srate
double amount, ccc, pay, lastpay, ibday, isday, ijday,tongsang, tamt
String  ls_date, ls_date2, s_gtstart, s_gtstart1, s_gtend1, s_paydate, s_retiredate, s_date
string todate,frdate
string sempno,symd,sjikjonggubn,s_ymd, ls_saupcd
datetime retiredate, gtend,gtend1, gtstart, paydate, dt_enterdate

//IF dw_empBasic.RowCount() = 0 Then Return
dw_empbasic.accepttext()


sempno = trim(dw_empbasic.getitemstring(1, "empno"))
sjikjonggubn = dw_empbasic.getitemstring(1, "jikjonggubn")

IF sempNo = "" or isnull(sempno) Then  
	messagebox("확 인", "조회할 사원을 입력하세요.!!!")
   cb_cancel.TriggerEvent(clicked!)
   Return 1
END IF	

dw_ymd.accepttext()

symd = dw_ymd.getitemstring(1, "to_ymd")


IF symd = "" or isnull(symd) Then  
	messagebox("확 인", "계산할 기준일자를 입력하세요.!!!")
	dw_ymd.setcolumn("to_ymd")
	dw_ymd.setfocus()
   cb_cancel.TriggerEvent(clicked!)
   Return 1
END IF	


w_mdi_frame.sle_msg.text ="조회 중......"
SELECT To_Number("P0_SYSCNFG"."DATANAME")        /*퇴직소득세액공제*/       
into :srate
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
if IsNull(srate) then srate = 50

SELECT To_Number("P0_SYSCNFG"."DATANAME")  into :tamt
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
		( "P0_SYSCNFG"."LINENO" = '2' );
		
SELECT Saupcd INTO :ls_saupcd
  FROM p3_editdata E
 WHERE E.WORKYM = (Select MAX(E.WORKYM) FROM p3_editdata where empno = :sempno) AND
       E.EMPNO = :sempno;
IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN 
	SELECT D.saupcd INTO :ls_saupcd
	  FROM p1_master M, p0_Dept D
	 WHERE M.companycode = D.companycode AND
	       M.deptcode = D.deptcode AND
			 M.empno = :sempno;
	IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN ls_saupcd = '10'
END IF
		
if IsNull(tamt) then tamt = 120000		

row = dw_main.Retrieve(gs_company,sempNo,symd)
dw_pay3month.reset()
IF row = 0  Then
	dw_main.SetRedraw(false)	
   dw_main.InsertRow(1)                                    // 데이타가 없으면 InsertRow

	dw_main.SetRedraw(True)
   dw_main.setitem(1,'seackper', srate)
   dw_main.setitem(1,'tamt', tamt)
	//입사일 98.08 추가
	ls_date2 = dw_ymd.GetItemstring( 1, "from_ymd" )
	dt_enterdate = datetime(date(left(ls_date2, 4) + '.' + mid(ls_date2, 5, 2) + '.' + &
                           right(ls_date2, 2)))
	//퇴직전 3개월 급여
	ls_date = dw_ymd.GetItemstring( 1, "to_ymd" )
	retiredate = datetime(date(left(ls_date, 4) + '.' + mid(ls_date, 5, 2) + '.' + &
												right(ls_date, 2)))
			
	gtend  = retiredate
	
	s_gtend1 = string(gtend, 'yyyymmdd')
	gtstart = datetime(date(left(ls_date, 4) + '.01' + '.01' ))
	s_gtstart1 = string(gtstart, 'yyyymmdd')
	s_gtstart = left(ls_date, 4)
	retiredate = datetime(relativedate(date(retiredate),0))
	s_retiredate = string(retiredate, 'yyyymmdd')
	
	day_term = day(date(retiredate))
	month = Month( Date(retireDate) )
	
	last_month = month
			
	select add_months(:retiredate,-1)
		into :paydate
		from dual;
	
	s_paydate = string(paydate, 'yyyy.mm')
	
	s_date = f_last_date(left(s_retireDate,6) )
	
	month_term = 11
	
//	if integer(right(s_retireDate,2)) < 15 then 
//		select add_months(:gtend,-1)
//			into :gtend1
//			from dual;
//	else	
		gtend1 = gtend
//	end if	
	
	//if s_date = s_retiredate then
	//	month_term = 11
	//else
	// month_term = 12
	//end if
	
	IF  month <= month_term  Then
		 month = (month + 12) - month_term
	ELSE
		 month = month - month_term
	END IF
	  
	wf_get_pay_3months(gtend1,month_term,sjikjonggubn)
	
	//퇴직전 1년간 상여
	
	wf_get_bonus_1years(gtend )
	
	/*잔여 년차 가져오기*/

	Double  dYearAmt
//
//    select bday+addday into :ibday
//      from p4_yearlist
//     where companycode = :gs_company and
//           yymm = (select max(yymm) from p4_yearlist 
//                   where substr(yymm,1,4) = substr(:ls_date,1,4) and
//                         empno = :sEmpNo ) and
//           empno = :sEmpNo;  
//			  
//	select count(a.ktcode) into :isday
//	from p4_dkentae a, p0_attendance b
//	where a.companycode = :gs_company and
//	      a.empno = :sEmpNo and
//			a.ktcode = b.attendancecode and
//			b.attendancegubn = '2' and
//			a.kdate >= substr(:ls_date,1,4)+'0101' and
//			a.kdate <= :ls_date;
//			          
//	ijday = 0
//	ijday = ibday - isday
//	
//	tongsang = sqlca.fun_get_tongsangamt(sEmpNo);
//	dYearAmt = ijday * tongsang 

  select sum(totpayamt) into :dYearAmt
  from p3_editdata
  where substr(workym,1,4) = substr(:ls_date,1,4) and
        empno = :sEmpNo and
		  pbtag = 'Y';
		  
  if IsNull(dYearAmt) then dYearAmt = 0
  
	dYearAmt = round(dYearAmt / 12 * 3, -1)

	dw_main.SetItem( 1, "meanyearholidayamt", dYearAmt)
	
	/*3개월 월차 가져오기*/
//	Double dMonthamt
//	int cnt
//	
//	frdate = f_aftermonth(left(symd,6),-3) + right(symd,2)
//	
//	select count(a.*) into :cnt
//	from p4_dkentae a, p0_attendance b
//	where a.ktcode = b.allowancecode and
//	      b.allowancegubn = '1' and
//			a.kdate >= :frdate and
//			a.kdate <= :symd;
//			
//	if cnt > 0 then
//		cnt = 3 - cnt
//		if cnt < 0 then
//			cnt = 0
//		end if
//	else
//	   cnt = 3
//	end if
//	
//	dMonthamt = cnt * tongsang 
//	
//	dw_main.SetItem( 1, "meanmonthholidayamt", dMonthAmt)

	
	
	rtdays = wf_get_serviceDays(dt_enterdate , gtend )
	// 근무년수,근무일수 Setting
	if rtdays = 1 then
		dw_main.SetItem( 1, "serviceyears", il_year )
		dw_main.SetItem( 1, "servicemonths", il_month )
		dw_main.SetItem( 1, "servicedays", il_day )
		
//		dw_main.SetItem( 1, "addyears", il_addyear )
//		dw_main.SetItem( 1, "addmonths", il_addmonth )
		dw_main.SetItem( 1, "adddays", il_addday )
		
		dw_main.SetItem( 1, "workyear", il_workyear )
	end if
			
//	/* 퇴직전환금 Setting*/
//	SELECT SUM(nvl(retirefine,0) +nvl(SOGUBAMT,0))
//	   INTO :amount
//		FROM p3_pension
//		WHERE companycode = :gs_company and
//				empno = :sempno and retireseq = 0  and
//				workym <= substr(:ls_date,1,6) ;
//	IF SQLCA.SQLcode <> 0 Then
//		amount = 0
//	ELSE
//		IF IsNull(amount) THEN amount = 0
//	End IF
//	dw_main.SetItem( 1, "penretireturnsub", amount )
	
	dw_main.SetItem( 1, "penretireturnsub", 0 )
	
	sle_msg.text =""
	
	ib_any_typing = false
	
	iv_gubn = "2"
	
	//cb_process.TriggerEvent(clicked!)
	
	dw_ymd.accepttext()
	
	s_ymd = dw_ymd.getitemstring(1,"to_ymd")
	dw_ymd.Retrieve(gs_company,sempno,'%',s_ymd)
ELSE

	dw_pay3month.Retrieve(gs_company,sempNo,symd)

	
  	row = dw_bonus1year.Retrieve(gs_company,sempNo,symd)
	dw_main.setitem(1,'seackper', srate)
	sle_msg.text =""
	ib_any_typing = false  
	iv_gubn = "1"
	dw_main.accepttext()
	
	dw_ymd.setitem(1,"from_ymd",dw_main.getitemstring(1,"fromdate"))
//	dw_ymd.setitem(1,"oldrettag",dw_main.getitemstring(1,"oldrettag"))
	il_workyear = dw_main.getitemnumber(1,"workyear")
	if IsNull(il_workyear) then il_workyear = 0
	
	iv_empno    = dw_main.getitemString(1,"empno")
END IF   
dw_main.setitem(1,'saupcd', ls_saupcd)

end event

type p_del from w_inherite_multi`p_del within w_pip5022
boolean visible = false
integer x = 4142
integer y = 2488
boolean enabled = false
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event p_del::clicked;call super::clicked;Integer i, li_cnt, iretireseq
Double  dRetireAmount

IF	 MessageBox("삭제 확인", "전체를 삭제하시겠습니까? ", question!, yesno!, 2) = 2	THEN return

dw_main.AcceptText()
//dRetireAmount = dw_main.GetItemNumber(1,"penretireturnsub")
//iretireseq = dw_main.GetItemNumber(1,"retireseq")
//
//IF IsNull(dRetireAmount) THEN dRetireAmount = 0

dw_main.setredraw(false)
dw_main.deleterow(1)
dw_main.setredraw(true)

li_cnt = dw_pay3month.rowcount()

dw_pay3month.setredraw(false)
for i = 1 to li_cnt
	dw_pay3month.deleterow(1)
next
dw_pay3month.setredraw(true)

li_cnt = dw_bonus1year.rowcount()

dw_bonus1year.setredraw(false)
for i = 1 to li_cnt
	dw_bonus1year.deleterow(1)
next
dw_bonus1year.setredraw(true)



IF	dw_main.Update() > 0  Then
	IF dw_pay3month.Update() > 0 Then
		IF  dw_bonus1year.Update() > 0 Then
//			IF dRetireAmount <> 0 THEN
//				UPDATE "P3_PENSION"  
//     				SET "RETIRESEQ" = 0  
//   				WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
//         				( "P3_PENSION"."EMPNO" = :iv_empno ) AND  
//         				( "P3_PENSION"."RETIRESEQ" = :iretireseq) ;
//		
//			END IF
			COMMIT;
		ELSE
			RollBack;
			MessageBox("퇴직전 1년간 상여", "데이타윈도우 저장 에러!")
			return	
		END IF
	ELSE 
		RollBack;
		MessageBox("퇴직전 1년간 급여", "데이타윈도우 저장 에러!")
		return	
	END IF
ELSE
	ROLLBACK;
END IF

cb_cancel.TriggerEvent(clicked!)

end event

event p_del::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\전체삭제_dn.gif"
end event

event p_del::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\전체삭제_up.gif"
end event

type p_mod from w_inherite_multi`p_mod within w_pip5022
integer x = 3863
end type

event p_mod::clicked;call super::clicked;
int	ll_rowcnt, ll_loop, ll_row, i
long  ll_days

iv_gubn = "1"
iv_gubn = " "

  // 퇴직자가 아니면 저장을 하지 않음...............
//IF dw_empBasic.GetItemString(1, "servicekindcode") <> "3"  Then
//   MessageBox("확 인", "퇴직자가 아니므로 저장되지 않습니다!")
//   ib_any_typing = false
//   Return   
//END IF
Double  dRetireTotal,dIlsiAmt, dTaxPostAmt, dTaxIyunTaxAmt
Integer iCount

iRegbn  = dw_main.GetItemString(1,"pergbn")

if iRegbn <> '3' then
	dRetireTotal  = dw_main.GetitemNumber(1,"retiretotalamt")
	dIlsiAmt      = dw_main.GetitemNumber(1,"retilsiamt")
	dTaxPostamt   = dw_main.GetitemNumber(1,"taxpost_insamt")
	dTaxIyunTaxAmt    = dw_main.GetitemNumber(1,"resultincometax") + dw_main.GetitemNumber(1,"resultresidenttax")
	
	if IsNull(dRetireTotal) then dRetireTotal = 0
	if IsNull(dIlsiAmt) then dIlsiAmt = 0
	if IsNull(dTaxPostamt) then dTaxPostamt = 0
	if IsNull(dTaxIyunTaxAmt) then dTaxIyunTaxAmt = 0
	
	if dRetireTotal <> dIlsiAmt + dTaxPostamt then
		MessageBox('확인','퇴직금총계와 퇴직연금액 + 과세이연액이 다릅니다')
		return
	end if

	select count(*) into :iCount from P3_RETIRE_TAX_POSPONE where empno = :iv_empNo and dpno is not null;
	if sqlca.sqlcode <> 0 then
		iCount = 0
	else
		if IsNull(iCount) then iCount = 0
	end if
	if iCount = 0 then
		MessageBox('확인','과세이연계좌를 찾을 수 없습니다')
		return
	end if
end if

iF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_ymd.accepttext()

sfrom_ymd = dw_ymd.getitemstring(1,"from_ymd")
sto_ymd = dw_ymd.getitemstring(1,"to_ymd")
il_oldrettag = dw_ymd.getitemstring(1,"oldrettag")

IF  IsNull(dw_main.GetItemString(1, "empno"))  Then
    dw_main.SetItem(1, "empno", iv_empNo)
    dw_main.SetItem(1, "companycode", gs_company)
	 dw_main.SetItem(1, "fromdate", sfrom_ymd)
	 dw_main.SetItem(1, "todate", sto_ymd)	 
END IF
dw_main.SetItem(1, "oldrettag", il_oldrettag)	 

ll_row = dw_pay3month.RowCount()
FOR i = 1 to ll_row
	dw_pay3month.SetItem(i, "todate", sto_ymd)
NEXT	

ll_rowcnt = dw_bonus1year.RowCount()

FOR i = 1 to ll_rowcnt
	dw_bonus1year.SetItem(i, "todate", sto_ymd)
NEXT	


dw_main.SetItem(1, "realretirepay", dw_main.GetItemNumber(1, "cpu_realRetirePay"))

///*퇴직전환금 table에 갱신*/
//IF dw_main.GetItemNumber(1, "penretireturnsub") = 0 OR &
//			IsNull(dw_main.GetItemNumber(1, "penretireturnsub")) THEN
//ELSE
//	Integer iMaxSeq
//	
//	SELECT MAX(retireseq) 			INTO :iMaxSeq
//		FROM p3_pension
//		WHERE companycode = :gs_company and
//				empno = :iv_empNo and retireseq <> 0 and
//				workym <= substr(:sto_ymd,1,6)	;
//				
//	IF SQLCA.SQLCODE <> 0 THEN
//		iMaxSeq = 0
//	ELSE
//		IF IsNull(iMaxSeq) THEN iMaxSeq = 0
//	END IF
//	iMaxSeq = iMaxSeq + 1
//	
//	UPDATE "P3_PENSION"  
//		SET "RETIRESEQ" = :iMaxSeq  
//		WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
//				( "P3_PENSION"."EMPNO" = :iv_empno ) AND  
//				( "P3_PENSION"."RETIRESEQ" = 0  ) and
//				( "P3_PENSION"."WORKYM" <= substr(:sto_ymd,1,6))
//				;
//	
//END IF
//
//dw_main.SetItem(1, "retireseq", iMaxSeq)

IF  dw_main.Update() = 1  Then
	IF dw_pay3month.Update() = 1 Then
		IF  dw_bonus1year.Update() = 1 Then
   		COMMIT;
	   ELSE
       	RollBack;
         MessageBox("퇴직전 1년간 상여", "데이타윈도우 저장 에러!")
			return	
      END IF
	ELSE 
	  	RollBack;
      MessageBox("퇴직전 1년간 급여", "데이타윈도우 저장 에러!")
		 return	
   END IF
ELSE
    ROLLBACK;
    MessageBox("확인", "데이타윈도우 저장 에러!")
    return
END IF

Double dRetYunAmt, dTaxIyunAmt
//퇴직연금,과세이연 자료 생성
if iRegbn <> '3' then
	delete from P3_ACNT_RETIREYUNGUM where empno = :iv_empno and tag = '1';
	delete from P3_ACNT_RETIREIYUN where  empno = :iv_empno ;
	commit;
	
	if iRegbn = '1' then
		dRetYunAmt  = dIlsiAmt
		dTaxIyunAmt = dIlsiAmt
	elseif iRegbn = '4' then
		dRetYunAmt  = dIlsiAmt
		dTaxIyunAmt = dIlsiAmt + dTaxPostamt	
	end if
	
	insert into P3_ACNT_RETIREYUNGUM
		(empno,		tag,		accno,		yilsiamt,		ywonamt,			tilsiamt,			yilsipamt,			iyunamt )
	select :iv_empno,'1',	dpno,			:dRetYunAmt,	:dRetYunAmt,	:dRetYunAmt,		:dRetYunAmt,		:dTaxPostamt
		from p3_retire_tax_pospone
		where empno = :iv_empno ;
	commit;
		
	insert into P3_ACNT_RETIREIYUN
		( seq,		empno,		saupnm,		saupno,		accno,		rowamt,			nrowamt,		mdate,		edate,		iyunamt )
	select 1,      :iv_empno,	banknm,		banksano,	dpno,			:dTaxIyunAmt,	0,				postdate,	postmdate,	:dTaxIyunTaxAmt
	from p3_retire_tax_pospone
	where empno = :iv_empno ;
	commit;
else
	delete from P3_ACNT_RETIREYUNGUM where empno = :iv_empno and tag = '1';
	delete from P3_ACNT_RETIREIYUN where  empno = :iv_empno ;
	commit;	
end if
//

UPDATE "P1_RETIREAMT"  
		SET "JIKUMAMT" = (SELECT REALRETIREPAY FROM P3_RETIREMENTPAY 
                       WHERE COMPANYCODE = :gs_company and
                             EMPNO = :iv_empno and
                             TODATE  = substr(:sto_ymd,1,6))
		WHERE ( "P1_RETIREAMT"."COMPANYCODE" = :gs_company ) AND  
				( "P1_RETIREAMT"."EMPNO" = :iv_empno ) AND  
				( "P1_RETIREAMT"."YYMM" <= substr(:sto_ymd,1,6));
commit;

ib_any_typing =  False

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip5022
boolean visible = false
integer x = 480
integer y = 2908
end type

type st_window from w_inherite_multi`st_window within w_pip5022
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip5022
boolean visible = false
integer x = 3099
integer y = 2432
integer width = 279
integer taborder = 90
string text = "상여등록"
end type

event cb_append::clicked;
long		ll_insrow, ll_rowcnt, ll_row, i
string	ls_company, ls_pbtag, ls_empno

dw_empbasic.AcceptText( ) 
ll_rowcnt = dw_main.RowCount()
if ll_rowcnt < 1 then return

ls_company = dw_empbasic.GetItemString(1, "companycode")
ls_empno = dw_empbasic.GetItemString(1, "empno")

if isNull(ls_company) or isNull(ls_empno) then return


ll_row = dw_bonus1year.rowcount()

if ll_row > 0 then 
  FOR i=1 TO ll_row
     IF wf_required_check(dw_bonus1year.DataObject, i) = -1 THEN RETURN
  NEXT
end if

ll_insrow = dw_bonus1year.InsertRow(0)
dw_bonus1year.SetItem(ll_insrow, "companycode", ls_company)
dw_bonus1year.SetItem(ll_insrow, "empno", ls_empno)
dw_bonus1year.SetItem(ll_insrow, "pbtag", "B")
dw_bonus1year.scrolltorow(ll_insrow)
dw_bonus1year.setrow(ll_insrow)
dw_bonus1year.SetColumn("workym")
dw_bonus1year.SetFocus()

end event

type cb_exit from w_inherite_multi`cb_exit within w_pip5022
boolean visible = false
integer x = 2775
integer y = 2432
integer width = 274
integer taborder = 170
end type

type cb_update from w_inherite_multi`cb_update within w_pip5022
boolean visible = false
integer x = 1806
integer y = 2432
integer width = 274
integer taborder = 140
end type

event cb_update::clicked;call super::clicked;
int	ll_rowcnt, ll_loop, ll_row, i
long  ll_days

iv_gubn = "1"
cb_process.TriggerEvent(clicked!)
iv_gubn = " "

  // 퇴직자가 아니면 저장을 하지 않음...............
//IF dw_empBasic.GetItemString(1, "servicekindcode") <> "3"  Then
//   MessageBox("확 인", "퇴직자가 아니므로 저장되지 않습니다!")
//   ib_any_typing = false
//   Return   
//END IF

iF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_ymd.accepttext()

sfrom_ymd = dw_ymd.getitemstring(1,"from_ymd")
sto_ymd = dw_ymd.getitemstring(1,"to_ymd")
il_oldrettag = dw_ymd.getitemstring(1,"oldrettag")

IF  IsNull(dw_main.GetItemString(1, "empno"))  Then
    dw_main.SetItem(1, "empno", iv_empNo)
    dw_main.SetItem(1, "companycode", gs_company)
	 dw_main.SetItem(1, "fromdate", sfrom_ymd)
	 dw_main.SetItem(1, "todate", sto_ymd)	 
END IF
dw_main.SetItem(1, "oldrettag", il_oldrettag)	 

ll_row = dw_pay3month.RowCount()
FOR i = 1 to ll_row
	dw_pay3month.SetItem(i, "todate", sto_ymd)
NEXT	

ll_rowcnt = dw_bonus1year.RowCount()

FOR i = 1 to ll_rowcnt
	dw_bonus1year.SetItem(i, "todate", sto_ymd)
NEXT	

///*퇴직전환금 table에 갱신*/
//IF dw_main.GetItemNumber(1, "penretireturnsub") = 0 OR &
//			IsNull(dw_main.GetItemNumber(1, "penretireturnsub")) THEN
//ELSE
//	Integer iMaxSeq
//	
//	SELECT MAX(retireseq) 			INTO :iMaxSeq
//		FROM p3_pension
//		WHERE companycode = :gs_company and
//				empno = :iv_empNo and retireseq <> 0 and
//				workym <= substr(:sto_ymd,1,6)	;
//				
//	IF SQLCA.SQLCODE <> 0 THEN
//		iMaxSeq = 0
//	ELSE
//		IF IsNull(iMaxSeq) THEN iMaxSeq = 0
//	END IF
//	iMaxSeq = iMaxSeq + 1
//	
//	UPDATE "P3_PENSION"  
//		SET "RETIRESEQ" = :iMaxSeq  
//		WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
//				( "P3_PENSION"."EMPNO" = :iv_empno ) AND  
//				( "P3_PENSION"."RETIRESEQ" = 0  ) and
//				( "P3_PENSION"."WORKYM" <= substr(:sto_ymd,1,6))
//				;
//	
//END IF
//
//dw_main.SetItem(1, "retireseq", iMaxSeq)

IF  dw_main.Update() = 1  Then
	IF dw_pay3month.Update() = 1 Then
		IF  dw_bonus1year.Update() = 1 Then
   		COMMIT;
	   ELSE
       	RollBack;
         MessageBox("퇴직전 1년간 상여", "데이타윈도우 저장 에러!")
			return	
      END IF
	ELSE 
	  	RollBack;
      MessageBox("퇴직전 1년간 급여", "데이타윈도우 저장 에러!")
		 return	
   END IF
ELSE
    ROLLBACK;
    MessageBox("확인", "데이타윈도우 저장 에러!")
    return
END IF

UPDATE "P1_RETIREAMT"  
		SET "JIKUMAMT" = (SELECT REALRETIREPAY FROM P3_RETIREMENTPAY 
                       WHERE COMPANYCODE = :gs_company and
                             EMPNO = :iv_empno and
                             TODATE  = substr(:sto_ymd,1,6))
		WHERE ( "P1_RETIREAMT"."COMPANYCODE" = :gs_company ) AND  
				( "P1_RETIREAMT"."EMPNO" = :iv_empno ) AND  
				( "P1_RETIREAMT"."YYMM" <= substr(:sto_ymd,1,6));
commit;

ib_any_typing =  False

end event

type cb_insert from w_inherite_multi`cb_insert within w_pip5022
boolean visible = false
integer x = 3387
integer y = 2432
integer width = 279
integer taborder = 110
string text = "상여삭제"
end type

event cb_insert::clicked;call super::clicked;integer il_currow

	il_currow = dw_bonus1year.GetRow()
	IF il_currow <=0 Then Return

//	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
		
   dw_bonus1year.deleterow(il_currow)

//IF dw_empBasic.GetItemString(1, "servicekindcode") = "3"  Then
//
//   IF  dw_bonus1year.Update() > 0 Then
//		 sle_msg.text ="자료를 삭제하였습니다!!"
//	    COMMIT;
//   ELSE
//	    RollBack;
//	    MessageBox("퇴직전 1년간 상여", "데이타윈도우 저장 에러!")
//	    return	
//   END IF
//END IF
//

end event

type cb_delete from w_inherite_multi`cb_delete within w_pip5022
boolean visible = false
integer x = 2089
integer y = 2432
integer width = 393
integer taborder = 150
string text = "전체삭제(&A)"
end type

event cb_delete::clicked;call super::clicked;Integer i, li_cnt, iretireseq
Double  dRetireAmount

IF	 MessageBox("삭제 확인", "전체를 삭제하시겠습니까? ", question!, yesno!, 2) = 2	THEN return

dw_main.AcceptText()
//dRetireAmount = dw_main.GetItemNumber(1,"penretireturnsub")
//iretireseq = dw_main.GetItemNumber(1,"retireseq")
//
//IF IsNull(dRetireAmount) THEN dRetireAmount = 0

dw_main.setredraw(false)
dw_main.deleterow(1)
dw_main.setredraw(true)

li_cnt = dw_pay3month.rowcount()

dw_pay3month.setredraw(false)
for i = 1 to li_cnt
	dw_pay3month.deleterow(1)
next
dw_pay3month.setredraw(true)

li_cnt = dw_bonus1year.rowcount()

dw_bonus1year.setredraw(false)
for i = 1 to li_cnt
	dw_bonus1year.deleterow(1)
next
dw_bonus1year.setredraw(true)



IF	dw_main.Update() > 0  Then
	IF dw_pay3month.Update() > 0 Then
		IF  dw_bonus1year.Update() > 0 Then
//			IF dRetireAmount <> 0 THEN
//				UPDATE "P3_PENSION"  
//     				SET "RETIRESEQ" = 0  
//   				WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
//         				( "P3_PENSION"."EMPNO" = :iv_empno ) AND  
//         				( "P3_PENSION"."RETIRESEQ" = :iretireseq) ;
//		
//			END IF
			COMMIT;
		ELSE
			RollBack;
			MessageBox("퇴직전 1년간 상여", "데이타윈도우 저장 에러!")
			return	
		END IF
	ELSE 
		RollBack;
		MessageBox("퇴직전 1년간 급여", "데이타윈도우 저장 에러!")
		return	
	END IF
ELSE
	ROLLBACK;
END IF

cb_cancel.TriggerEvent(clicked!)

end event

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip5022
boolean visible = false
integer x = 686
integer y = 2432
integer width = 279
integer taborder = 80
end type

event cb_retrieve::clicked;long month, row, i, day_term, month_term, last_month, yearcount, yearcnt
Integer rtdays
double amount, ccc, pay, lastpay, ibday, isday, ijday,tongsang
String  ls_date, ls_date2, s_gtstart, s_gtstart1, s_gtend1, s_paydate, s_retiredate, s_date
string todate,frdate
string sempno,symd,sjikjonggubn,s_ymd
datetime retiredate, gtend,gtend1, gtstart, paydate, dt_enterdate

//IF dw_empBasic.RowCount() = 0 Then Return
dw_empbasic.accepttext()


sempno = trim(dw_empbasic.getitemstring(1, "empno"))
sjikjonggubn = dw_empbasic.getitemstring(1, "jikjonggubn")

IF sempNo = "" or isnull(sempno) Then  
	messagebox("확 인", "조회할 사원을 입력하세요.!!!")
   cb_cancel.TriggerEvent(clicked!)
   Return 1
END IF	

dw_ymd.accepttext()

symd = dw_ymd.getitemstring(1, "to_ymd")


IF symd = "" or isnull(symd) Then  
	messagebox("확 인", "계산할 기준일자를 입력하세요.!!!")
	dw_ymd.setcolumn("to_ymd")
	dw_ymd.setfocus()
   cb_cancel.TriggerEvent(clicked!)
   Return 1
END IF	


sle_msg.text ="조회 중......"


row = dw_main.Retrieve(gs_company,sempNo,symd)

IF row = 0  Then
	dw_main.SetRedraw(false)	
   dw_main.InsertRow(1)                                    // 데이타가 없으면 InsertRow

	dw_main.SetRedraw(True)

	//입사일 98.08 추가
	ls_date2 = dw_ymd.GetItemstring( 1, "from_ymd" )
	dt_enterdate = datetime(date(left(ls_date2, 4) + '.' + mid(ls_date2, 5, 2) + '.' + &
                           right(ls_date2, 2)))
	//퇴직전 12개월 급여
	ls_date = dw_ymd.GetItemstring( 1, "to_ymd" )
	retiredate = datetime(date(left(ls_date, 4) + '.' + mid(ls_date, 5, 2) + '.' + &
												right(ls_date, 2)))
			
	gtend  = retiredate
	
	s_gtend1 = string(gtend, 'yyyymmdd')
	gtstart = datetime(date(left(ls_date, 4) + '.01' + '.01' ))
	s_gtstart1 = string(gtstart, 'yyyymmdd')
	s_gtstart = left(ls_date, 4)
	retiredate = datetime(relativedate(date(retiredate),0))
	s_retiredate = string(retiredate, 'yyyymmdd')
	
	day_term = day(date(retiredate))
	month = Month( Date(retireDate) )
	
	last_month = month
			
	select add_months(:retiredate,-1)
		into :paydate
		from dual;
	
	s_paydate = string(paydate, 'yyyy.mm')
	
	s_date = f_last_date(left(s_retireDate,6) )
	
	month_term = 11
	
//	if integer(right(s_retireDate,2)) < 15 then 
//		select add_months(:gtend,-1)
//			into :gtend1
//			from dual;
//	else	
		gtend1 = gtend
//	end if	
	
	//if s_date = s_retiredate then
	//	month_term = 11
	//else
	// month_term = 12
	//end if
	
	IF  month <= month_term  Then
		 month = (month + 12) - month_term
	ELSE
		 month = month - month_term
	END IF
	  
	wf_get_pay_3months(gtend1,month_term,sjikjonggubn)
	
	//퇴직전 1년간 상여
	
	wf_get_bonus_1years(gtend )
	
	/*잔여 년차 가져오기*/

	Double  dYearAmt
//
//    select bday+addday into :ibday
//      from p4_yearlist
//     where companycode = :gs_company and
//           yymm = (select max(yymm) from p4_yearlist 
//                   where substr(yymm,1,4) = substr(:ls_date,1,4) and
//                         empno = :sEmpNo ) and
//           empno = :sEmpNo;  
//			  
//	select count(a.ktcode) into :isday
//	from p4_dkentae a, p0_attendance b
//	where a.companycode = :gs_company and
//	      a.empno = :sEmpNo and
//			a.ktcode = b.attendancecode and
//			b.attendancegubn = '2' and
//			a.kdate >= substr(:ls_date,1,4)+'0101' and
//			a.kdate <= :ls_date;
//			          
//	ijday = 0
//	ijday = ibday - isday
//	
//	tongsang = sqlca.fun_get_tongsangamt(sEmpNo);
//	dYearAmt = ijday * tongsang 

  select sum(totpayamt) into :dYearAmt
  from p3_editdata
  where substr(workym,1,4) = substr(:ls_date,1,4) and
        empno = :sEmpNo and
		  pbtag = 'Y';
		  
  if IsNull(dYearAmt) then dYearAmt = 0
  
	dYearAmt = round(dYearAmt / 12 * 3, -1)

	dw_main.SetItem( 1, "meanyearholidayamt", dYearAmt)
	
	/*3개월 월차 가져오기*/
//	Double dMonthamt
//	int cnt
//	
//	frdate = f_aftermonth(left(symd,6),-3) + right(symd,2)
//	
//	select count(a.*) into :cnt
//	from p4_dkentae a, p0_attendance b
//	where a.ktcode = b.allowancecode and
//	      b.allowancegubn = '1' and
//			a.kdate >= :frdate and
//			a.kdate <= :symd;
//			
//	if cnt > 0 then
//		cnt = 3 - cnt
//		if cnt < 0 then
//			cnt = 0
//		end if
//	else
//	   cnt = 3
//	end if
//	
//	dMonthamt = cnt * tongsang 
//	
//	dw_main.SetItem( 1, "meanmonthholidayamt", dMonthAmt)

	
	
	rtdays = wf_get_serviceDays(dt_enterdate , gtend )
	// 근무년수,근무일수 Setting
	if rtdays = 1 then
		dw_main.SetItem( 1, "serviceyears", il_year )
		dw_main.SetItem( 1, "servicemonths", il_month )
		dw_main.SetItem( 1, "servicedays", il_day )
		
//		dw_main.SetItem( 1, "addyears", il_addyear )
//		dw_main.SetItem( 1, "addmonths", il_addmonth )
//		dw_main.SetItem( 1, "adddays", il_addday )
		
		dw_main.SetItem( 1, "workyear", il_workyear )
	end if
			
//	/* 퇴직전환금 Setting*/
//	SELECT SUM(nvl(retirefine,0) +nvl(SOGUBAMT,0))
//	   INTO :amount
//		FROM p3_pension
//		WHERE companycode = :gs_company and
//				empno = :sempno and retireseq = 0  and
//				workym <= substr(:ls_date,1,6) ;
//	IF SQLCA.SQLcode <> 0 Then
//		amount = 0
//	ELSE
//		IF IsNull(amount) THEN amount = 0
//	End IF
//	dw_main.SetItem( 1, "penretireturnsub", amount )
	
	dw_main.SetItem( 1, "penretireturnsub", 0 )
	
	sle_msg.text =""
	
	ib_any_typing = false
	
	iv_gubn = "2"
	
	//cb_process.TriggerEvent(clicked!)
	
	dw_ymd.accepttext()
	
	s_ymd = dw_ymd.getitemstring(1,"to_ymd")
	dw_ymd.Retrieve(gs_company,sempno,'%',s_ymd)
ELSE

	dw_pay3month.Retrieve(gs_company,sempNo,symd)

	
  	row = dw_bonus1year.Retrieve(gs_company,sempNo,symd)
	
	sle_msg.text =""
	ib_any_typing = false  
	iv_gubn = "1"
	dw_main.accepttext()
	
	dw_ymd.setitem(1,"from_ymd",dw_main.getitemstring(1,"fromdate"))
//	dw_ymd.setitem(1,"oldrettag",dw_main.getitemstring(1,"oldrettag"))
	il_workyear = dw_main.getitemnumber(1,"workyear")
	if IsNull(il_workyear) then il_workyear = 0
	
	iv_empno    = dw_main.getitemString(1,"empno")
END IF   

end event

type st_1 from w_inherite_multi`st_1 within w_pip5022
boolean visible = false
integer x = 416
integer y = 3000
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip5022
boolean visible = false
integer x = 2491
integer y = 2432
integer width = 274
integer taborder = 160
end type

event cb_cancel::clicked;call super::clicked;setnull(iv_empname)
setnull(iv_empno)
setnull(iv_deptcode)

ib_any_typing = false

dw_empbasic.setredraw(false)
dw_ymd.setredraw(false)
dw_main.setredraw(false)
dw_pay3month.setredraw(false)
dw_bonus1year.setredraw(false)

dw_main.object.hday_t.visible = false
dw_main.object.hday.visible = false

dw_empbasic.RESET()
dw_ymd.RESET()
dw_main.RESET()
dw_pay3month.RESET()
dw_bonus1year.RESET()

dw_empbasic.InsertRow(0)
dw_ymd.InsertRow(0)
dw_main.InsertRow(0)

dw_empbasic.SetColumn("empname")
dw_empbasic.SetFocus()

dw_empbasic.setredraw(true)
dw_ymd.setredraw(true)
dw_main.setredraw(true)
dw_pay3month.setredraw(true)
dw_bonus1year.setredraw(true)

end event

type dw_datetime from w_inherite_multi`dw_datetime within w_pip5022
boolean visible = false
integer x = 3227
integer y = 3000
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip5022
boolean visible = false
integer x = 745
integer y = 3000
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip5022
boolean visible = false
integer x = 622
integer width = 2405
integer height = 172
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip5022
boolean visible = false
integer x = 3031
integer width = 608
integer height = 172
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip5022
boolean visible = false
integer x = 398
integer y = 2948
integer height = 148
end type

type dw_main from datawindow within w_pip5022
event ue_pressenter pbm_dwnprocessenter
integer x = 416
integer y = 672
integer width = 3442
integer height = 1016
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip5022_2"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;ib_any_typing = true

double Amount1, Amount2,Amount3
string l_gbn

//과세이연 작업으로 추가함  2012.12.20
If This.GetColumnName() ="pergbn" then
	
	iRegbn  =  this.GetText()		
	
	if iRegbn = '1' then
		this.SetItem(this.Getrow(),"retilsiamt",     this.GetItemNumber(this.GetRow(),"retiretotalamt"))	
		this.SetItem(this.Getrow(),"taxpost_insamt", 0)	
		this.SetItem(this.Getrow(),"taxpost_taxamt", this.GetitemNumber(this.Getrow(),"resultincometax") + this.GetitemNumber(this.Getrow(),"resultresidenttax"))	
	elseif iRegbn = '3' then
		this.SetItem(this.Getrow(),"retilsiamt",     0)	
		this.SetItem(this.Getrow(),"taxpost_insamt", 0)	
		this.SetItem(this.Getrow(),"taxpost_taxamt", 0)	
	else
		this.SetItem(this.Getrow(),"taxpost_taxamt", this.GetitemNumber(this.Getrow(),"resultincometax") + this.GetitemNumber(this.Getrow(),"resultresidenttax"))	
	end if
end if 

end event

event editchanged;ib_any_typing = true
end event

type dw_pay3month from datawindow within w_pip5022
event ue_pressenter pbm_dwnprocessenter
integer x = 402
integer y = 1704
integer width = 1559
integer height = 480
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip5022_3"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = true
end event

event itemchanged;String snull, sym,s_ymd,s_tymd,temp_ym1,temp_ym2,temp_ym3,temp_ym4, ym
Double totpayamt, subamt, realamt, dnull,basepay, Temp_day, sudang
Int il_currow,lReturnRow
long month, day, year, i_day

setnull(dnull)
SetNull(snull)

il_currow = this.getrow()

IF dwo.name ="workym" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	IF f_datechk(data+"01") = -1 THEN
		messagebox('확 인', '입력하신 년월을 확인하세요.!!')
		this.SetItem(il_currow,"workym",snull)
		this.SetItem(il_currow,"supplyamt",dnull)
		this.SetItem(il_currow,"basepay",dnull)
		this.SetItem(il_currow,"sudang",dnull)
		this.SetItem(il_currow,"workdd",dnull)
		this.Setrow(il_currow)
		this.Setfocus()
		Return 1
	ELSE
		lReturnRow = This.Find("workym = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 년월입니다.~r등록할 수 없습니다.")
			this.SetItem(il_currow,"workym",snull)
			this.SetItem(il_currow,"supplyamt",dnull)
			this.SetItem(il_currow,"basepay",dnull)
			this.SetItem(il_currow,"sudang",dnull)
			this.SetItem(il_currow,"workdd",dnull)
			RETURN  1	
		END IF
 
		dw_ymd.accepttext()
		sym = left(dw_ymd.getitemstring(1, "to_ymd"),6)
		
		year = long(left(dw_ymd.getitemstring(1, "to_ymd"),4))
		month = long(mid(dw_ymd.getitemstring(1, "to_ymd"),5,2))
		day = long(right(dw_ymd.getitemstring(1, "to_ymd"),2))
		
		month = month - 1
		if month < 1 then 
			year = year - 1
			month = 12
		end if
		temp_ym1 = string(year) + string(month) 
		
		month = month - 1
		if month < 1 then 
			year = year - 1
			month = 12
		end if
		temp_ym2 = string(year) + string(month) 
		
		month = month - 1
		if month < 1 then 
			year = year - 1
			month = 12
		end if
		temp_ym3 = string(year) + string(month) 
		
		IF data = sym THEN
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_ymd =  ym + "01"
			s_tymd =  dw_ymd.getitemstring(1, "to_ymd")
		ELSEIF data = temp_ym1 THEN
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_ymd =  ym + "01"
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_tymd =  ym + f_last_date(ym)
		ELSEIF data = temp_ym2 THEN
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_ymd =  ym + "01"
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_tymd =  ym + f_last_date(ym)	
		ELSEIF data = temp_ym3 THEN
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_ymd =  ym + string(day +1)
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_tymd =  ym + f_last_date(ym)	
		ELSE	
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_ymd =  ym + "01"
			ym =  string(Date( String(year) + "/" + String(month) + "/01"), "yyyymm")
			s_tymd =  ym + f_last_date(ym)	
		END IF	
		

		//일수계산
		i_day = wf_getday(s_ymd,s_tymd)
	
		SELECT P3_EDITDATA.TOTPAYAMT, P3_EDITDATA.BASEPAY ,P3_EDITDATA.TOTPAYAMT - P3_EDITDATA.BASEPAY
	    into  :totpayamt				 , :Basepay 			  ,:Sudang
		 FROM  P3_EDITDATA
		 WHERE P3_EDITDATA.COMPANYCODE = :gs_company  AND  
				 P3_EDITDATA.WORKYM = :ym  AND  
				 P3_EDITDATA.PBTAG = 'P'  AND  
				 P3_EDITDATA.EMPNO = :iv_empno	;
		IF SQLCA.SQLCODE <> 0 THEN
			totpayamt = 0
			Basepay   = 0
			Sudang    = 0
		END IF	
	
		IF data = temp_ym3 THEN
			Temp_day = i_day
			totpayamt = ROUND(totpayamt / 30 *	Temp_day ,0 )
			Basepay   = ROUND(Basepay / 30 *	Temp_day ,0 )
			Sudang    = ROUND(Sudang / 30 *	Temp_day ,0 )
			totpayamt  =  Basepay + Sudang
		END IF	
		
	   this.SetItem(il_currow,"supplyamt", totpayamt)
		this.SetItem(il_currow,"basepay",Basepay)
		this.SetItem(il_currow,"sudang",Sudang)
		this.SetItem(il_currow,"workdd",i_day)
	END IF
END IF

IF dwo.name ="basepay"  or dwo.name ="sudang" THEN
	this.accepttext()
	
	basepay = this.getitemnumber(row,"basepay")
	sudang = this.getitemnumber(row,"sudang")
	
	this.SetItem(il_currow,"supplyamt", basepay + sudang )
	 
END IF

end event

event itemerror;return 1
end event

type dw_bonus1year from datawindow within w_pip5022
event ue_pressenter pbm_dwnprocessenter
integer x = 2007
integer y = 1704
integer width = 1870
integer height = 480
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pip5022_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = true
end event

event itemchanged;String snull
double totbosamt, dnull
Int il_currow,lReturnRow, ii

SetNull(snull)
setnull(dnull)

il_currow = this.getrow()

IF dwo.name ="workym_1" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	IF f_datechk(data+"01") = -1 THEN
		messagebox('확 인', '입력하신 년월을 확인하세요.!!')
		this.SetItem(il_currow,"workym_1",snull)
		this.SetItem(il_currow,"supplyamt_1", dnull)
		this.Setfocus()
		Return 1
	ELSE
		lReturnRow = This.Find("workym = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 년월입니다.~r등록할 수 없습니다.")
			this.SetItem(il_currow,"workym_1",snull)
			this.SetItem(il_currow,"supplyamt_1", dnull)
			RETURN  1	
		END IF
		
		SELECT P3_EDITDATA.TOTPAYAMT
		  into :totbosamt
		  FROM P3_EDITDATA
		 WHERE P3_EDITDATA.COMPANYCODE = :gs_company  AND  
			  	 P3_EDITDATA.WORKYM = :data  AND  
				 P3_EDITDATA.PBTAG = 'B'  AND  
				 P3_EDITDATA.EMPNO = :iv_empno	;

		IF SQLCA.SQLCODE = 0 THEN 
			this.SetItem(il_currow,"supplyamt_1", totbosamt)
      ELSE
			this.SetItem(il_currow,"supplyamt_1", dnull)
      END IF	
	END IF
END IF

IF dwo.name ="workym_2" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	IF f_datechk(data+"01") = -1 THEN
		messagebox('확 인', '입력하신 년월을 확인하세요.!!')
		this.SetItem(row,"workym_2",snull)
		this.SetItem(row,"supplyamt_2", dnull)
		this.Setfocus()
		Return 1
	ELSE
		lReturnRow = This.Find("workym = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 년월입니다.~r등록할 수 없습니다.")
			this.SetItem(il_currow,"workym_2", snull)
			this.SetItem(il_currow,"supplyamt_2", dnull)
			RETURN  1	
		END IF

		SELECT P3_EDITDATA.TOTPAYAMT
		  into :totbosamt
		  FROM P3_EDITDATA
		 WHERE P3_EDITDATA.COMPANYCODE = :gs_company  AND  
			  	 P3_EDITDATA.WORKYM = :data  AND  
				 P3_EDITDATA.PBTAG = 'B'  AND  
				 P3_EDITDATA.EMPNO = :iv_empno	;

		IF SQLCA.SQLCODE = 0 THEN 
			this.SetItem(il_currow,"supplyamt_2", totbosamt)
      ELSE
			this.SetItem(il_currow,"supplyamt_2", dnull)
      END IF	
	END IF
END IF

end event

event itemerror;return 1
end event

type gb_6 from groupbox within w_pip5022
boolean visible = false
integer x = 2190
integer y = 2500
integer width = 526
integer height = 148
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
end type

type dw_ymd from datawindow within w_pip5022
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 453
integer y = 484
integer width = 2537
integer height = 88
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip5022_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemerror;Beep(1)
Return 1
end event

event itemchanged;string snull

setnull(snull)

//dw_main.SetRedraw(False)

if this.getcolumnname() = "to_ymd" then
	sto_ymd = this.gettext()
	if f_datechk(sto_ymd) = -1 then
		messagebox("확인", "정산기간을 확인하십시오")
		this.setitem(1,"to_ymd",snull)
		this.setcolumn("to_ymd")
		return
	end if
end if	
		
if this.getcolumnname() = "oldrettag" then
	il_oldrettag = this.gettext()
end if

//cb_retrieve.TriggerEvent(clicked!)
//dw_main.SetRedraw(true)
	

end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

string sempno , sname

dw_empbasic.AcceptText()
IF This.GetColumnName() = "to_ymd" THEN
	sempno = dw_empbasic.GetItemString(dw_empbasic.GetRow(),"empno")
	sname = dw_empbasic.GetItemString(dw_empbasic.GetRow(),"empname")
	muiltstr l_str_parms 
	l_str_parms.s[1] = sempno
   l_str_parms.s[2] = sname
	openwithparm(w_pip5022_popup, l_str_parms)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetItem(this.GetRow(),"from_ymd",Gs_code)
	this.SetItem(this.GetRow(),"to_ymd",Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF

end event

type dw_pay_to_retireamt from datawindow within w_pip5022
boolean visible = false
integer x = 457
integer y = 2504
integer width = 827
integer height = 172
boolean bringtotop = true
string dataobject = "d_pip5022_5"
boolean resizable = true
boolean livescroll = true
end type

type cb_process from commandbutton within w_pip5022
boolean visible = false
integer x = 1522
integer y = 2432
integer width = 274
integer height = 108
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&E)"
end type

event clicked;
double dailyPay, mean_yearAllow, mean_monthAllow, pay3month, bonus1year, wkamt, meanpay3 
double totServiceDays, taxableStandardAmt, tempAmount,tempAmount1, meanpay, yeartaxstandardamt,meanpay2
double pre_retiretotalAmt, pre_honorRetirePay, pre_incomeTaxPaid,pre_residentTaxPaid,tot_pen_amt 
Integer yearHoliday, li_workyear, s_years, s_months, s_days, scount, a_day
Real increaseRate
long daytot, ilday
string sdate

SetPointer(HourGlass!)
sle_msg.text = "퇴직금 계산중......"

// dw_main.AcceptText()  --> 입력된 datawindow 의 값을 읽는다
// (data를 수정후 tab 을 사용하지 않고 바로 "계산" button 을 click시 수정된 값이 안읽힌다)

dw_ymd.accepttext()
sto_ymd = dw_ymd.getitemstring(1,"to_ymd")
sfrom_ymd = dw_ymd.getitemstring(1,"from_ymd")
il_oldrettag = dw_ymd.getitemstring(1,'oldrettag')

sdate = left(sto_ymd,4) + right(sfrom_ymd,4)
ilday = f_dayterm(sdate , sto_ymd) + 1


SELECT count("P3_RETIREMENTPAY"."EMPNO")
  INTO :scount
  FROM "P3_RETIREMENTPAY"  
 WHERE ( "P3_RETIREMENTPAY"."COMPANYCODE" = :gs_company ) AND  
       ( "P3_RETIREMENTPAY"."EMPNO" = :iv_empNo ) AND  
       ( "P3_RETIREMENTPAY"."TODATE" <> :sto_ymd )   ;
		 
IF sqlca.sqlcode <> 0  or scount = 0 or isnull(scount) then		 
	IF dw_main.GetItemNumber(1, "serviceyears") <= 0  Then 
		MessageBox("계산대상오류", "Error! 근무년수가 퇴직계산 조건에 맞지 않습니다.")
		sle_msg.text = ""
		Return
	END IF
END IF	
//====================================================================================
//      누진 지급율 을  구한다......
//    wf_get_increaseRate(servicedays)  ==> return value : real type
//====================================================================================
//totServiceDays = dw_main.GetItemNumber(1, "serviceyears") * 365 + &
//                                  dw_main.GetItemNumber(1, "servicedays")
//increaseRate = wf_get_increaseRate(totServiceDays,dw_empbasic.GetItemDatetime(1,"retireDate")) 
//IF  increaseRate = -1  Then
//    SetMicroHelp(gw_mainframe, "퇴직금 계산(지급율 계산) Error!!!")
//    Return
//    increaseRate = 0
//END IF
//increaseRate = increaseRate + (totServiceDays / 365)    // 지급율에 근무년수를 더한다
dw_main.SetItem(1, "increaseRate",0)


//====================================================================================
//      퇴직급여 = 평균임금 * 근무일수
//          SetItem..................( retirementpay)
//====================================================================================
tempAmount = 0
string ll_indate, ll_enddate, ls_indate, ls_enddate
long ll_days

ll_indate = dw_ymd.GetItemstring( 1, "from_ymd" ) 
ll_enddate = dw_ymd.GetItemstring( 1, "to_ymd" )
//법정기준 
meanpay = dw_main.GetItemnumber( 1, "meanpay" )
if IsNull(meanpay) then meanpay = 0

ls_indate = left(ll_indate, 4) + "/" + mid(ll_indate, 5, 2) + "/" + right(ll_indate, 2)
ls_enddate = left(ll_enddate, 4) + "/" + mid(ll_enddate, 5, 2) + "/" + right(ll_enddate, 2)
ll_days = daysafter(date(ls_indate), date(ls_enddate)) + 1


s_years = dw_main.GetItemnumber( 1, "serviceyears" )
s_months = dw_main.GetItemnumber( 1, "servicemonths" )
s_days = dw_main.GetItemnumber( 1, "servicedays" )

if IsNull(s_years) then s_years = 0
if IsNull(s_months) then s_months = 0
if IsNull(s_days) then s_days = 0

if meanpay = 0 then
	tempAmount = 0 
else
	tempAmount = (meanpay * s_years) + ((meanpay / 12) * s_months) 
end if
tempAmount = Round(tempAmount,0) 

dw_main.SetItem(1, "retirementpay", tempAmount)

//자사기준

if il_oldrettag = '3' then/*임원 지급*/
	
	s_years = dw_main.GetItemnumber( 1, "serviceyears" )
	s_months = dw_main.GetItemnumber( 1, "servicemonths" )
	s_days = dw_main.GetItemnumber( 1, "servicedays" )
	
	if meanpay = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = ((meanpay * s_years) + ((meanpay / 12) * s_months) + ((meanpay / 365 ) * s_days)) * 3
	end if
	
	tempAmount1 = tempAmount1 + 5
	tempAmount1 = truncate((tempAmount1 / 10),0) * 10
	
	dw_main.SetItem(1, "retirementpay1", tempAmount1)   	
	dw_main.SetItem(1, "retirementpay", 0)
	dw_main.SetItem(1, "payrate", 0)
elseif il_oldrettag = '2' then/*정년퇴직*/	
	//지급율
	 string spayrate
	 long payrate
	 
    SELECT "P0_REF"."CODENM"  
    INTO :spayrate  
    FROM "P0_REF"  
   WHERE ( "P0_REF"."CODEGBN" = 'RT' ) AND  
         ( "P0_REF"."CODE" = '01' )   ;
	
	if spayrate = '' or isnull(spayrate) then
		payrate = 100
	else
		payrate = integer(spayrate)
	end if
	
	if sqlca.sqlcode <> 0 then
		payrate = 100
	end if	
	
	meanpay = dw_main.GetItemnumber( 1, "basepay" )
	if IsNull(meanpay) then meanpay = 0
	
   s_years = dw_main.GetItemnumber( 1, "serviceyears" )
	s_months = dw_main.GetItemnumber( 1, "servicemonths" )
	s_days = dw_main.GetItemnumber( 1, "servicedays" )
	if IsNull(s_years) then s_years = 0
	if IsNull(s_months) then s_months = 0
	if IsNull(s_days) then s_days = 0

	if meanpay = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = (meanpay * s_years) + ((meanpay / 12) * s_months) + ((meanpay / 365 ) * s_days)
	end if
	if tempAmount1 = 0 or payrate = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = (tempAmount1 * payrate / 100 ) + 5
	end if
	tempAmount1 = truncate((tempAmount1 / 10),0) * 10

	dw_main.SetItem(1, "retirementpay1", tempAmount1)
	dw_main.SetItem(1, "payrate", payrate)
	dw_main.SetItem(1, "retirementpay", 0)
	
elseif il_oldrettag = '1' then/*일반퇴직*/	
	//meanpay = dw_main.GetItemnumber( 1, "basepay" )
	if IsNull(meanpay) then meanpay = 0
	
	 s_years = dw_main.GetItemnumber( 1, "serviceyears" )
	s_months = dw_main.GetItemnumber( 1, "servicemonths" )
	s_days = dw_main.GetItemnumber( 1, "servicedays" )
	if IsNull(s_years) then s_years = 0
	if IsNull(s_months) then s_months = 0
	if IsNull(s_days) then s_days = 0
	
	
	if meanpay = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = truncate((meanpay * s_days / 365 ) * 30 ,0)
	end if

	tempAmount1 = truncate(tempAmount1,0)

	dw_main.SetItem(1, "retirementpay1", tempAmount1)
	dw_main.SetItem(1, "payrate", 0)
end if	

//====================================================================================
//     퇴직금총계 computed field (cpu_retireTotalAmt) 자동계산됨
//          SetItem..................
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_retireTotalAmt")
dw_main.SetItem(1, "retiretotalamt", tempAmount)

//====================================================================================
// 전근무지 총퇴직금(preretireTotalAmt), 명예퇴직수당(prehonorRetireAmt),
//               기납부 세액( preincomeTax, preresidentTax) 을 가져온다.
//  Table : pay_previousRetirementPay
//====================================================================================
SELECT p3_previousretirementpay.totalretireamt,
       p3_previousretirementpay.honorretirepay,
       p3_previousretirementpay.resultincometax,
       p3_previousretirementpay.resultresidenttax 
 INTO :pre_retireTotalAmt,
      :pre_honorRetirePay,
      :pre_incomeTaxPaid, 
      :pre_residentTaxPaid
 FROM  p3_previousretirementpay
 WHERE 	companycode = :gs_company and
 			p3_previousretirementpay.empno = :iv_empNo
USING SQLCA;

IF  SQLCA.SQLcode <> 0  Then
    pre_retireTotalAmt = 0
    pre_honorRetirePay = 0
    pre_incomeTaxPaid  = 0 
    pre_residentTaxPaid = 0
ELSE
	if IsNull(pre_retireTotalAmt)  then pre_retireTotalAmt  =0
	if IsNull(pre_honorRetirePay)  then pre_honorRetirePay  =0
	if IsNull(pre_incomeTaxPaid)   then pre_incomeTaxPaid   =0
	if IsNull(pre_residentTaxPaid) then pre_residentTaxPaid =0
END IF
dw_main.SetItem(1, "preretiretotalamt", pre_retireTotalAmt)

//====================================================================================
//     퇴직소득 수입금액 SetItem
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_retireincomeearnamt")
dw_main.SetItem(1, "retireincomeearnamt", tempAmount)

//====================================================================================
//    퇴직소득 특별공제 계산....
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "honorretirepay")
tempAmount = Truncate( ( tempAmount + pre_honorRetirePay ) * 0.75, 0 ) + &
                   Truncate( ( dw_main.GetItemNumber(1, "cpu_retireincomeearnamt") - &
                      dw_main.GetItemNumber(1, "honorretirepay") - &
                       pre_honorRetirePay ) * 0.5,  0 )          
dw_main.SetItem(1, "incomespecialsub", tempAmount)

//====================================================================================
//  (((( 퇴직 소득 공제 계산 )))))
//     근속년수계산  ===> ex) 5년30일 근무 : 6년으로 계산....
//   wf_incomeSub(totServiceDays)
//====================================================================================
dw_main.SetItem(1, "incomesub", wf_incomeSub(il_workyear))

//====================================================================================
//    퇴직소득 과세표준 SetItem...................
//====================================================================================
taxableStandardAmt = dw_main.GetItemNumber(1, "cpu_taxableStandardAmt")
dw_main.SetItem(1, "taxablestandardamt", taxableStandardAmt)

//====================================================================================
//    산출세액, 세율을 구함....... wf_get_taxRate(yeartaxstandardamt)
//    산출세액, 세율 SetItem..........
//------------------------------------------------------------------------------------
//    연평균과세표준 = 퇴직소득과세표준 / 근속년수
//    연평균산출세액 = wf_get_taxRate(연평균과세표준)
//    산출세액 = 연평균산출세액 * 근속년수
//====================================================================================
tempAmount = 0
if taxableStandardAmt = 0 or il_workyear = 0 then
	yeartaxstandardamt = 0
else
	yeartaxstandardamt = taxableStandardAmt / il_workyear
end if
tempAmount = wf_get_taxRate(yeartaxstandardamt)
tempAmount = tempAmount * il_workyear
dw_main.SetItem(1, "taxrate", ii_taxrate )
dw_main.SetItem(1, "outputtax", tempAmount)

//====================================================================================
//    결정세액 SetItem..............
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_resultIncomeTax")
dw_main.SetItem(1, "resultincometax", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_resultResidentTax")
dw_main.SetItem(1, "resultresidenttax", tempAmount)

//====================================================================================
//  가져온 기납부세액을 SetItem...
//====================================================================================
dw_main.SetItem(1, "preincometax", pre_incomeTaxPaid) 
dw_main.SetItem(1, "preresidenttax", pre_residentTaxPaid)

//====================================================================================
//     차감세액및 차감 퇴직급여, 차인 지급액 SetItem.....................
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_balanceIncomeTax")
dw_main.SetItem(1, "balanceincometax", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_balanceResidentTax")
dw_main.SetItem(1, "balanceresidenttax", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_balanceRetirePay")
dw_main.SetItem(1, "balanceretirepay", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_realRetirePay")
dw_main.SetItem(1, "realretirepay", tempAmount)

//====================================================================================
//     퇴직전환금 SetItem.....................
//====================================================================================
 double	ld_junamt
if iv_gubn = "2" then
	  SELECT SUM(NVL("P3_PENSION"."RETIREFINE",0) + NVL("P3_PENSION"."SOGUBAMT",0))    
		 INTO :ld_junamt  
		 FROM "P3_PENSION"  
		WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
				( "P3_PENSION"."EMPNO" = :iv_empno ) and 
				( "P3_PENSION"."FINETAG" <> 'Y')	;
				
	  SELECT sum("P3_RETIREMENTPAY"."PENRETIRETURNSUB")  
	    INTO :tot_pen_amt  
   	 FROM "P3_RETIREMENTPAY"  
	   WHERE ( "P3_RETIREMENTPAY"."COMPANYCODE" = :gs_company ) AND  
   	      ( "P3_RETIREMENTPAY"."EMPNO" = :iv_empno ) AND  
      	   ( "P3_RETIREMENTPAY"."TODATE" < :sto_ymd )  ;
	 IF ISNULL(tot_pen_amt ) THEN tot_pen_amt  =0
	 IF SQLCA.SQLCODE <> 0 THEN
		 tot_pen_amt  = 0
    END IF
	 ld_junamt = ld_junamt - tot_pen_amt 
	 
	 if isnull(ld_junamt) then
		 dw_main.SetItem(1, "penretireturnsub", 0)
	 else 
		 dw_main.SetItem(1, "penretireturnsub", ld_junamt)
	 end if
end if	 
//====================================================================================
//    iv_is_changed 를  True 로 해준다......
//====================================================================================
IF  dw_empBasic.GetItemString(1, "servicekindcode") = "3" Then
    ib_any_typing = True
Else
   ib_any_typing = False
END IF

sle_msg.text = "작업 완료"

////////////////////////////////////////////////////   end process




end event

type cbx_1 from checkbox within w_pip5022
boolean visible = false
integer x = 2222
integer y = 2548
integer width = 462
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12632256
string text = "전근무지등록"
end type

event clicked;//Open(w_pip5002)
//cbx_1.checked = false

end event

type cb_calc from commandbutton within w_pip5022
boolean visible = false
integer x = 978
integer y = 2432
integer width = 535
integer height = 108
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "평균임금계산(&A)"
end type

event clicked;
double dailyPay, mean_yearAllow, mean_monthAllow, pay3month,basepay3month, bonus1year, wkamt, meanpay3 
double totServiceDays, taxableStandardAmt, tempAmount, meanpay, yeartaxstandardamt,meanpay2,meanpay4
double pre_retiretotalAmt, pre_honorRetirePay, pre_incomeTaxPaid, pre_residentTaxPaid
Integer yearHoliday, li_workyear,s_years, s_months, s_days,s_addyears, s_addmonths, s_adddays,i
Real increaseRate
long daytot

SetPointer(HourGlass!)
sle_msg.text = "평균임금 계산중......"   

// 근속년수 미계산시 

s_years = dw_main.GetItemnumber( 1, "serviceyears" )
s_months = dw_main.GetItemnumber( 1, "servicemonths" )
s_days = dw_main.GetItemnumber( 1, "servicedays" )

//s_addyears = dw_main.GetItemnumber( 1, "addyears" )
//s_addmonths = dw_main.GetItemnumber( 1, "addmonths" )
//s_adddays = dw_main.GetItemnumber( 1, "adddays" )
//

IF s_years = 0 and s_months = 0 and s_days = 0 then
	cb_retrieve.TriggerEvent(Clicked!)
END IF	

// dw_main.AcceptText()  --> 입력된 datawindow 의 값을 읽는다
// (data를 수정후 tab 을 사용하지 않고 바로 "계산" button 을 click시 수정된 값이 안읽힌다) 
IF dw_pay3month.RowCount() > 0 Then
	dw_pay3month.accepttext()
	if dw_pay3month.rowcount() = 4 then
		for i = 1 to 4
			dw_pay3month.SetItem(i, "supplyamt3", dw_pay3month.getitemnumber(i,"supplyamt"))
		next	
	else
		for i = 1 to 3
			dw_pay3month.SetItem(i, "supplyamt3", dw_pay3month.getitemnumber(i,"supplyamt"))
		next	
	end if	
	
	pay3month = dw_pay3month.GetItemNumber(1, "cpu_totpay1")      //3개월 총급여
	
	basepay3month = dw_pay3month.GetItemNumber(1, "cpu_basepay")  //3개월 총 기본급
	daytot = dw_pay3month.GetItemNumber(1,'daytot')
	daytot = dw_pay3month.GetItemNumber(1,'worktot')  //3개월 일수
ELSE
	pay3month = 0
	daytot = 0
END IF
IF dw_bonus1year.RowCount() > 0 Then
   bonus1year = dw_bonus1year.GetItemNumber(1, "cpu_totbonus")
ELSE
   bonus1year = 0
END IF

IF IsNumber(String(pay3month)) = False  Then 
   pay3month = 0
END IF

IF IsNumber(String(basepay3month)) = False  Then 
   basepay3month = 0
END IF

IF IsNumber(String(bonus1year)) = False  Then
   bonus1year = 0
END IF

//====================================================================================
//       통상일급(dailyPay), 월평균월차(mean_monthHolidayAllow),
//       월평균년차(mean_yearHolidayAllow)   구함
//====================================================================================


mean_monthAllow = 0
mean_yearAllow = 0




//====================================================================================
//         평균임금 을 구함
//        3개월 평균급여 + 1년 평균상여 + 월평균연차 + 월평균월차 
//====================================================================================
	long day_term
	string startdate,enddate,retiredate
	double payamt, ld_yearholidayamt, ld_monthamt
	double	ld_cpu_totpay


	retiredate = dw_ymd.getitemstring(1,'to_ymd')
	startdate  = dw_pay3month.getitemstring(dw_pay3month.rowcount(),'workym')

	enddate = dw_pay3month.getitemstring(1,'workym')

	day_term = 	dw_pay3month.getitemnumber(dw_pay3month.rowcount(),'worktot')
   
	ld_yearholidayamt = dw_main.getItemnumber(1, 'meanyearholidayamt')
	ld_monthamt = dw_main.getItemnumber(1, 'meanmonthholidayamt')
   if IsNull(ld_yearholidayamt) then ld_yearholidayamt = 0
// ld_yearholidayamt = ld_yearholidayamt / 12
//	ld_monthamt = ld_monthamt / 3
             
//	dw_main.setitem(1,'yearamt', ld_yearholidayamt + ld_monthamt)
	
	meanpay2 = truncate(pay3month  / 3, 0)
	meanpay3 = truncate((bonus1year / 12 ) * 3, 0)
	meanpay4 = truncate(basepay3month / 3,0)
	
	meanpay = truncate(( pay3month + meanpay3 + ld_yearholidayamt ) / day_term ,0)
	
//end if  

dw_main.SetItem(1, "avgpayamt", pay3month)
dw_main.SetItem(1, "avgbosamt", meanpay3)

dw_main.SetItem(1, "wamt", meanpay2)
dw_main.SetItem(1, "bamt", meanpay3)
dw_main.SetItem(1, "basepay", meanpay4)

dw_main.SetItem(1, "meanpay", meanpay)

sle_msg.text = "평균임금 계산완료......"




end event

type dw_empbasic from datawindow within w_pip5022
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 398
integer y = 220
integer width = 2615
integer height = 268
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip5022_0"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sEmpNo,sEmpName

If dw_empbasic.GetColumnName() = "empname" Then
	sempname = this.GetText()
	
	IF sempname ="" OR IsNull(sempname) THEN RETURN 
	
	sempno = wf_exiting_data("empname",sempname,"1")
	IF IsNull(sempno) THEN
		Messagebox("확 인","등록되지 않은 사원이므로 조회할 수 없습니다!!")
		dw_empbasic.SetRedraw(False)
		dw_empbasic.Reset()
		dw_empbasic.InsertRow(0)
		dw_empbasic.SetColumn("empname")
		dw_empbasic.SetFocus()
		dw_empbasic.SetRedraw(True)
		Return 1
	END IF
   
	dw_empbasic.SetRedraw(False)
	dw_empbasic.Retrieve(gs_company,sempno,'%')
	dw_ymd.Retrieve(gs_company,sempno,'%',gs_today)
	dw_empbasic.SetRedraw(True)

ELSEIf dw_empbasic.GetColumnName() = "empno" Then

	sempno = this.GetText()
	
	IF sempno ="" OR IsNull(sempno) THEN RETURN
	
	IF IsNull(wf_exiting_data("empno",sempno,"1")) THEN
		Messagebox("확 인","등록되지 않은 사번이므로 조회할 수 없습니다!!")
		dw_empbasic.SetRedraw(False)
		dw_empbasic.Reset()
		dw_empbasic.InsertRow(0)
		dw_empbasic.SetColumn("empno")
		dw_empbasic.SetFocus()
		dw_empbasic.SetRedraw(True)
		Return 1
	END IF	
	dw_empbasic.SetRedraw(false)
	dw_empbasic.Retrieve(gs_company,sempno,'%')
	dw_ymd.Retrieve(gs_company,sempno,'%',gs_today)
	dw_empbasic.SetRedraw(True)
END IF

dw_ymd.setfocus()
dw_ymd.setcolumn("to_ymd")



end event

event itemerror;return 1
end event

event itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF This.GetColumnName() = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF

IF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event retrieveend;string ls_enterdate, ls_retiredate
Long row

row = dw_empbasic.GetRow()

If row > 0 Then								                      	
	iv_EmpNo = dw_empbasic.GetItemString(1, "empno")
	iv_EmpName = dw_empbasic.GetItemString(1, "empname")
	iv_deptcode = dw_empbasic.GetItemString(1, "deptcode")
   ls_enterdate =	dw_empbasic.GetItemString(1, "enterdate")
   
	IF IsNull(ls_enterdate) or ls_enterdate = ""  Then
      MessageBox("확 인", "입사일자가 없읍니다! 퇴직금계산 불가!", StopSign!, OK!)
   ELSE
      //==============================================================================
      //    퇴직일자가 없으면 현재 날짜 입력
      //==============================================================================
//      ls_retiredate = dw_empbasic.GetItemString(1, "retiredate")
//      IF IsNull(ls_retiredate) or ls_enterdate = ""  Then
//         dw_empbasic.SetItem(1, "retiredate", gs_today)
//      END IF
   END IF
END IF

end event

type cb_appendpay from commandbutton within w_pip5022
boolean visible = false
integer x = 82
integer y = 2432
integer width = 283
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "급여등록"
end type

event clicked;
long		ll_insrow, ll_rowcnt, ll_row, i
string	ls_company, ls_pbtag, ls_empno

dw_empbasic.AcceptText( ) 
ll_rowcnt = dw_main.RowCount()
if ll_rowcnt < 1 then return

ls_company = dw_empbasic.GetItemString(1, "companycode")
ls_empno = dw_empbasic.GetItemString(1, "empno")

if isNull(ls_company) or isNull(ls_empno) then return


ll_row = dw_pay3month.rowcount()

if ll_row > 0 then 
  FOR i=1 TO ll_row
     IF wf_required_check(dw_pay3month.DataObject, i) = -1 THEN RETURN
  NEXT
end if

ll_insrow = dw_pay3month.InsertRow(0)
dw_pay3month.SetItem(ll_insrow, "companycode", ls_company)
dw_pay3month.SetItem(ll_insrow, "empno", ls_empno)
dw_pay3month.SetItem(ll_insrow, "pbtag", "P")
dw_pay3month.scrolltorow(ll_insrow)
dw_pay3month.setrow(ll_insrow)
dw_pay3month.SetColumn("workym")
dw_pay3month.SetFocus()

end event

type cb_insertpay from commandbutton within w_pip5022
boolean visible = false
integer x = 375
integer y = 2432
integer width = 283
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "급여삭제"
end type

event clicked;integer il_currow

	il_currow = dw_pay3month.GetRow()
	IF il_currow <=0 Then Return

//	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
		
   dw_pay3month.deleterow(il_currow)

//IF dw_empBasic.GetItemString(1, "servicekindcode") = "3"  Then
//
//   IF  dw_pay3month.Update() > 0 Then
//		 sle_msg.text ="자료를 삭제하였습니다!!"
//	    COMMIT;
//   ELSE
//	    RollBack;
//	    MessageBox("퇴직전 1년간 급여", "데이타윈도우 저장 에러!")
//	    return	
//   END IF
//END IF
//

end event

type rb_1 from radiobutton within w_pip5022
integer x = 398
integer y = 80
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사번순"
boolean checked = true
end type

type rb_2 from radiobutton within w_pip5022
integer x = 704
integer y = 80
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "성명순"
end type

type p_2 from uo_picture within w_pip5022
boolean visible = false
integer x = 3707
integer y = 2428
integer width = 96
integer height = 68
boolean bringtotop = true
string picturename = "C:\Erpman\image\first.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;string scode,sname,sMin_name, is_empno

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")

	SELECT min("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)


end event

type p_3 from uo_picture within w_pip5022
boolean visible = false
integer x = 3822
integer y = 2428
integer width = 96
integer height = 68
boolean bringtotop = true
string picturename = "C:\Erpman\image\prior.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;string is_empno, scode,sname,sMax_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" < :sname	;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)

end event

type p_4 from uo_picture within w_pip5022
boolean visible = false
integer x = 3936
integer y = 2428
integer width = 96
integer height = 68
boolean bringtotop = true
string picturename = "C:\Erpman\image\next.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;string is_empno, scode,sname,sMin_name

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" > :sname	;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)





end event

type p_5 from uo_picture within w_pip5022
boolean visible = false
integer x = 4050
integer y = 2428
integer width = 96
integer height = 68
boolean bringtotop = true
string picturename = "C:\Erpman\image\last.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;string is_empno, scode,sname,sMax_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")

	SELECT Max("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT Max("P1_MASTER"."EMPNAME")  
		INTO :sMax_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)

end event

type p_1 from uo_picture within w_pip5022
integer x = 3109
integer y = 492
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\급여등록_up.gif"
end type

event clicked;call super::clicked;
long		ll_insrow, ll_rowcnt, ll_row, i
string	ls_company, ls_pbtag, ls_empno

dw_empbasic.AcceptText( ) 
ll_rowcnt = dw_main.RowCount()
if ll_rowcnt < 1 then return

ls_company = dw_empbasic.GetItemString(1, "companycode")
ls_empno = dw_empbasic.GetItemString(1, "empno")

if isNull(ls_company) or isNull(ls_empno) then return


ll_row = dw_pay3month.rowcount()

if ll_row > 0 then 
  FOR i=1 TO ll_row
     IF wf_required_check(dw_pay3month.DataObject, i) = -1 THEN RETURN
  NEXT
end if

ll_insrow = dw_pay3month.InsertRow(0)
dw_pay3month.SetItem(ll_insrow, "companycode", ls_company)
dw_pay3month.SetItem(ll_insrow, "empno", ls_empno)
dw_pay3month.SetItem(ll_insrow, "pbtag", "P")
dw_pay3month.scrolltorow(ll_insrow)
dw_pay3month.setrow(ll_insrow)
dw_pay3month.SetColumn("workym")
dw_pay3month.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\급여등록_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\급여등록_up.gif"
end event

type p_6 from uo_picture within w_pip5022
integer x = 3282
integer y = 492
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\급여삭제_up.gif"
end type

event clicked;call super::clicked;integer il_currow

	il_currow = dw_pay3month.GetRow()
	IF il_currow <=0 Then Return

//	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
		
   dw_pay3month.deleterow(il_currow)

//IF dw_empBasic.GetItemString(1, "servicekindcode") = "3"  Then
//
//   IF  dw_pay3month.Update() > 0 Then
//		 sle_msg.text ="자료를 삭제하였습니다!!"
//	    COMMIT;
//   ELSE
//	    RollBack;
//	    MessageBox("퇴직전 1년간 급여", "데이타윈도우 저장 에러!")
//	    return	
//   END IF
//END IF
//

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\급여삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\급여삭제_up.gif"
end event

type p_7 from uo_picture within w_pip5022
integer x = 3387
integer y = 24
integer width = 306
boolean bringtotop = true
string picturename = "C:\erpman\image\평균임금계산_up.gif"
end type

event clicked;call super::clicked;
double dailyPay, mean_yearAllow, mean_monthAllow, pay3month,basepay3month, bonus1year, wkamt, meanpay3 
double totServiceDays, taxableStandardAmt, tempAmount, meanpay, yeartaxstandardamt,meanpay2,meanpay4
double pre_retiretotalAmt, pre_honorRetirePay, pre_incomeTaxPaid, pre_residentTaxPaid
Integer yearHoliday, li_workyear,s_years, s_months, s_days,s_addyears, s_addmonths, s_adddays,i
Real increaseRate
long daytot

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "평균임금 계산중......"   

// 근속년수 미계산시 

s_years = dw_main.GetItemnumber( 1, "serviceyears" )
s_months = dw_main.GetItemnumber( 1, "servicemonths" )
s_days = dw_main.GetItemnumber( 1, "servicedays" )

//s_addyears = dw_main.GetItemnumber( 1, "addyears" )
//s_addmonths = dw_main.GetItemnumber( 1, "addmonths" )
//s_adddays = dw_main.GetItemnumber( 1, "adddays" )
//

IF s_years = 0 and s_months = 0 and s_days = 0 then
	cb_retrieve.TriggerEvent(Clicked!)
END IF	

// dw_main.AcceptText()  --> 입력된 datawindow 의 값을 읽는다
// (data를 수정후 tab 을 사용하지 않고 바로 "계산" button 을 click시 수정된 값이 안읽힌다) 
IF dw_pay3month.RowCount() > 0 Then
	dw_pay3month.accepttext()
	if dw_pay3month.rowcount() = 4 then
		for i = 1 to 4
			dw_pay3month.SetItem(i, "supplyamt3", dw_pay3month.getitemnumber(i,"supplyamt"))
		next	
	else
		for i = 1 to 3
			dw_pay3month.SetItem(i, "supplyamt3", dw_pay3month.getitemnumber(i,"supplyamt"))
		next	
	end if	
	
	pay3month = dw_pay3month.GetItemNumber(1, "cpu_totpay1")      //3개월 총급여
	
	basepay3month = dw_pay3month.GetItemNumber(1, "cpu_basepay")  //3개월 총 기본급
	daytot = dw_pay3month.GetItemNumber(1,'daytot')
	daytot = dw_pay3month.GetItemNumber(1,'worktot')  //3개월 일수
ELSE
	pay3month = 0
	daytot = 0
END IF
IF dw_bonus1year.RowCount() > 0 Then
   bonus1year = dw_bonus1year.GetItemNumber(1, "cpu_totbonus")
ELSE
   bonus1year = 0
END IF

IF IsNumber(String(pay3month)) = False  Then 
   pay3month = 0
END IF

IF IsNumber(String(basepay3month)) = False  Then 
   basepay3month = 0
END IF

IF IsNumber(String(bonus1year)) = False  Then
   bonus1year = 0
END IF

//====================================================================================
//       통상일급(dailyPay), 월평균월차(mean_monthHolidayAllow),
//       월평균년차(mean_yearHolidayAllow)   구함
//====================================================================================


mean_monthAllow = 0
mean_yearAllow = 0




//====================================================================================
//         평균임금 을 구함
//        3개월 평균급여 + 1년 평균상여 + 월평균연차 + 월평균월차 
//====================================================================================
	long day_term
	string startdate,enddate,retiredate
	double payamt, ld_yearholidayamt, ld_monthamt
	double	ld_cpu_totpay


	retiredate = dw_ymd.getitemstring(1,'to_ymd')
	startdate  = dw_pay3month.getitemstring(dw_pay3month.rowcount(),'workym')

	enddate = dw_pay3month.getitemstring(1,'workym')

	day_term = 	dw_pay3month.getitemnumber(dw_pay3month.rowcount(),'worktot')
   
	ld_yearholidayamt = dw_main.getItemnumber(1, 'meanyearholidayamt')
	ld_monthamt = dw_main.getItemnumber(1, 'meanmonthholidayamt')
   if IsNull(ld_yearholidayamt) then ld_yearholidayamt = 0
// ld_yearholidayamt = ld_yearholidayamt / 12
//	ld_monthamt = ld_monthamt / 3
             
//	dw_main.setitem(1,'yearamt', ld_yearholidayamt + ld_monthamt)
	
	meanpay2 = truncate(pay3month  / 3, 0)
	meanpay3 = truncate(bonus1year / 12 , 0)
	meanpay4 = truncate(basepay3month / 3,0)
	
	meanpay = truncate(( meanpay2 + meanpay3 ) / 365 ,0)
	
//end if  

dw_main.SetItem(1, "avgpayamt", pay3month)
dw_main.SetItem(1, "avgbosamt", bonus1year)

dw_main.SetItem(1, "wamt", meanpay2)
dw_main.SetItem(1, "bamt", meanpay3)
dw_main.SetItem(1, "basepay", meanpay4)

dw_main.SetItem(1, "meanpay", meanpay)

w_mdi_frame.sle_msg.text = "평균임금 계산완료......"




end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\평균임금계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\평균임금계산_up.gif"
end event

type p_8 from uo_picture within w_pip5022
integer x = 3689
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\처리_up.gif"
end type

event clicked;call super::clicked;
double dailyPay, mean_yearAllow, mean_monthAllow, pay3month, bonus1year, wkamt, meanpay3 , ld_rate
double totServiceDays, taxableStandardAmt, tempAmount,tempAmount1, meanpay, yeartaxstandardamt,meanpay2
double pre_retiretotalAmt, pre_honorRetirePay, pre_incomeTaxPaid,pre_residentTaxPaid,tot_pen_amt 
Integer yearHoliday, li_workyear, s_years, s_months, s_days, scount, a_day
Real increaseRate
long daytot, ilday
string sdate  , realredate, ls_jikjong

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "퇴직금 계산중......"

// dw_main.AcceptText()  --> 입력된 datawindow 의 값을 읽는다
// (data를 수정후 tab 을 사용하지 않고 바로 "계산" button 을 click시 수정된 값이 안읽힌다)

dw_ymd.accepttext()
sto_ymd = dw_ymd.getitemstring(1,"to_ymd")
sfrom_ymd = dw_ymd.getitemstring(1,"from_ymd")
il_oldrettag = dw_ymd.getitemstring(1,'oldrettag')

sdate = left(sto_ymd,4) + right(sfrom_ymd,4)
ilday = f_dayterm(sdate , sto_ymd) + 1


SELECT count("P3_RETIREMENTPAY"."EMPNO")
  INTO :scount
  FROM "P3_RETIREMENTPAY"  
 WHERE ( "P3_RETIREMENTPAY"."COMPANYCODE" = :gs_company ) AND  
       ( "P3_RETIREMENTPAY"."EMPNO" = :iv_empNo ) AND  
       ( "P3_RETIREMENTPAY"."TODATE" <> :sto_ymd )   ;
		 
IF sqlca.sqlcode <> 0  or scount = 0 or isnull(scount) then		 
	IF dw_main.GetItemNumber(1, "serviceyears") <= 0  Then 
		MessageBox("계산대상오류", "Error! 근무년수가 퇴직계산 조건에 맞지 않습니다.")
		sle_msg.text = ""
		Return
	END IF
END IF	
//====================================================================================
//      누진 지급율 을  구한다......
//    wf_get_increaseRate(servicedays)  ==> return value : real type
//====================================================================================
//totServiceDays = dw_main.GetItemNumber(1, "serviceyears") * 365 + &
//                                  dw_main.GetItemNumber(1, "servicedays")
//increaseRate = wf_get_increaseRate(totServiceDays,dw_empbasic.GetItemDatetime(1,"retireDate")) 
//IF  increaseRate = -1  Then
//    SetMicroHelp(gw_mainframe, "퇴직금 계산(지급율 계산) Error!!!")
//    Return
//    increaseRate = 0
//END IF
//increaseRate = increaseRate + (totServiceDays / 365)    // 지급율에 근무년수를 더한다
dw_main.SetItem(1, "increaseRate",0)


//====================================================================================
//      퇴직급여 = 평균임금 * 근무일수
//          SetItem..................( retirementpay)
//====================================================================================
tempAmount = 0
string ll_indate, ll_enddate, ls_indate, ls_enddate
long ll_days

ll_indate = dw_ymd.GetItemstring( 1, "from_ymd" ) 
ll_enddate = dw_ymd.GetItemstring( 1, "to_ymd" )
//법정기준 
meanpay = dw_main.GetItemnumber( 1, "meanpay" )
if IsNull(meanpay) then meanpay = 0

ls_indate = left(ll_indate, 4) + "/" + mid(ll_indate, 5, 2) + "/" + right(ll_indate, 2)
ls_enddate = left(ll_enddate, 4) + "/" + mid(ll_enddate, 5, 2) + "/" + right(ll_enddate, 2)
ll_days = daysafter(date(ls_indate), date(ls_enddate)) + 1


s_years = dw_main.GetItemnumber( 1, "serviceyears" )
s_months = dw_main.GetItemnumber( 1, "servicemonths" )
s_days = dw_main.GetItemnumber( 1, "servicedays" )

if IsNull(s_years) then s_years = 0
if IsNull(s_months) then s_months = 0
if IsNull(s_days) then s_days = 0

if meanpay = 0 then
	tempAmount = 0 
else
	tempAmount = (meanpay * s_years) + ((meanpay / 12) * s_months) 
end if
tempAmount = Round(tempAmount,0) 

dw_main.SetItem(1, "retirementpay", tempAmount)

//자사기준

if il_oldrettag = '3' then/*임원 지급*/
	
	s_years = dw_main.GetItemnumber( 1, "serviceyears" )
	s_months = dw_main.GetItemnumber( 1, "servicemonths" )
	s_days = dw_main.GetItemnumber( 1, "servicedays" )
	
	if meanpay = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = ((meanpay * s_years) + ((meanpay / 12) * s_months) + ((meanpay / 365 ) * s_days)) * 3
	end if
	
	tempAmount1 = tempAmount1 + 5
	tempAmount1 = truncate((tempAmount1 / 10),0) * 10
	
	dw_main.SetItem(1, "retirementpay1", tempAmount1)   	
	dw_main.SetItem(1, "retirementpay", 0)
	dw_main.SetItem(1, "payrate", 0)
elseif il_oldrettag = '2' then/*정년퇴직*/	
	//지급율
	 string spayrate
	 long payrate
	 
    SELECT "P0_REF"."CODENM"  
    INTO :spayrate  
    FROM "P0_REF"  
   WHERE ( "P0_REF"."CODEGBN" = 'RT' ) AND  
         ( "P0_REF"."CODE" = '01' )   ;
	
	if spayrate = '' or isnull(spayrate) then
		payrate = 100
	else
		payrate = integer(spayrate)
	end if
	
	if sqlca.sqlcode <> 0 then
		payrate = 100
	end if	
	
	meanpay = dw_main.GetItemnumber( 1, "basepay" )
	if IsNull(meanpay) then meanpay = 0
	
   s_years = dw_main.GetItemnumber( 1, "serviceyears" )
	s_months = dw_main.GetItemnumber( 1, "servicemonths" )
	s_days = dw_main.GetItemnumber( 1, "servicedays" )
	if IsNull(s_years) then s_years = 0
	if IsNull(s_months) then s_months = 0
	if IsNull(s_days) then s_days = 0

	if meanpay = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = (meanpay * s_years) + ((meanpay / 12) * s_months) + ((meanpay / 365 ) * s_days)
	end if
	if tempAmount1 = 0 or payrate = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = (tempAmount1 * payrate / 100 ) + 5
	end if
	tempAmount1 = truncate((tempAmount1 / 10),0) * 10

	dw_main.SetItem(1, "retirementpay1", tempAmount1)
	dw_main.SetItem(1, "payrate", payrate)
	dw_main.SetItem(1, "retirementpay", 0)
	
elseif il_oldrettag = '1' then/*일반퇴직*/	
	//meanpay = dw_main.GetItemnumber( 1, "basepay" )
	if IsNull(meanpay) then meanpay = 0
	
	 s_years = dw_main.GetItemnumber( 1, "serviceyears" )
	s_months = dw_main.GetItemnumber( 1, "servicemonths" )
	s_days = dw_main.GetItemnumber( 1, "servicedays" )
	if IsNull(s_years) then s_years = 0
	if IsNull(s_months) then s_months = 0
	if IsNull(s_days) then s_days = 0
	
	
	if meanpay = 0 then
		tempAmount1 = 0
	else
		tempAmount1 = meanpay * s_days 
	end if

	tempAmount1 = truncate(tempAmount1,0)

	dw_main.SetItem(1, "retirementpay1", tempAmount1)
	dw_main.SetItem(1, "payrate", 0)
end if	

//====================================================================================
//     퇴직금총계 computed field (cpu_retireTotalAmt) 자동계산됨
//          SetItem..................
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_retireTotalAmt")
dw_main.SetItem(1, "retiretotalamt", tempAmount)


//근속년수 확정 2014.0514 김홍군
//string 1(사번) 2(정산시작일), 3(정산종료일), 4(중간지급여부), 5(중간지급기산일)
//double 1(중간지급액), 2(근속년수), 3(근속월수), 4(근속일수)
muiltstr l_str_parms 
l_str_parms.s[1] = iv_empNo
l_str_parms.s[2] = sfrom_ymd
l_str_parms.s[3] = sto_ymd
l_str_parms.s[4] = 'N'
l_str_parms.s[5] = ''

l_str_parms.dc[1] = 0
l_str_parms.dc[2] = dw_main.GetItemNumber(1,"serviceyears")
l_str_parms.dc[3] = dw_main.GetItemNumber(1,"servicemonths")

l_str_parms.dc[4] = dw_main.GetItemNumber(1,"adddays")
//l_str_parms.dc[4] = dw_main.GetItemNumber(1,"servicedays")

openwithparm(w_pip5022_year, l_str_parms)
//근속년수 확정 2014.0514 김홍군



//====================================================================================
// 전근무지 총퇴직금(preretireTotalAmt), 명예퇴직수당(prehonorRetireAmt),
//               기납부 세액( preincomeTax, preresidentTax) 을 가져온다.
//  Table : pay_previousRetirementPay
//====================================================================================
SELECT p3_previousretirementpay.totalretireamt,
       p3_previousretirementpay.honorretirepay,
       p3_previousretirementpay.resultincometax,
       p3_previousretirementpay.resultresidenttax 
 INTO :pre_retireTotalAmt,
      :pre_honorRetirePay,
      :pre_incomeTaxPaid, 
      :pre_residentTaxPaid
 FROM  p3_previousretirementpay
 WHERE 	companycode = :gs_company and
 			p3_previousretirementpay.empno = :iv_empNo
USING SQLCA;

IF  SQLCA.SQLcode <> 0  Then
    pre_retireTotalAmt = 0
    pre_honorRetirePay = 0
    pre_incomeTaxPaid  = 0 
    pre_residentTaxPaid = 0
ELSE
	if IsNull(pre_retireTotalAmt)  then pre_retireTotalAmt  =0
	if IsNull(pre_honorRetirePay)  then pre_honorRetirePay  =0
	if IsNull(pre_incomeTaxPaid)   then pre_incomeTaxPaid   =0
	if IsNull(pre_residentTaxPaid) then pre_residentTaxPaid =0
END IF
dw_main.SetItem(1, "preretiretotalamt", pre_retireTotalAmt)

//====================================================================================
//     퇴직소득 수입금액 SetItem
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_retireincomeearnamt")
dw_main.SetItem(1, "retireincomeearnamt", tempAmount)

//====================================================================================
//    퇴직소득 특별공제 계산....
//====================================================================================
select to_number(dataname) / 100 into :ld_rate
from p0_syscnfg
where serial = 40  and lineno <> '00';
if IsNull(ld_rate) then ld_rate = 0.45

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "honorretirepay")
tempAmount = Truncate( ( tempAmount + pre_honorRetirePay ) * ld_rate, 0 ) + &
                   Truncate( ( dw_main.GetItemNumber(1, "cpu_retireincomeearnamt") - &
                      dw_main.GetItemNumber(1, "honorretirepay") - &
                       pre_honorRetirePay ) * ld_rate,  0 )          
dw_main.SetItem(1, "incomespecialsub", tempAmount)

//====================================================================================
//  (((( 퇴직 소득 공제 계산 )))))
//     근속년수계산  ===> ex) 5년30일 근무 : 6년으로 계산....
//   wf_incomeSub(totServiceDays)
//====================================================================================
dw_main.SetItem(1, "incomesub", wf_incomeSub(il_workyear))

//====================================================================================
//    퇴직소득 과세표준 SetItem...................
//====================================================================================
taxableStandardAmt = dw_main.GetItemNumber(1, "cpu_taxableStandardAmt")
dw_main.SetItem(1, "taxablestandardamt", taxableStandardAmt)

//====================================================================================
//    산출세액, 세율을 구함....... wf_get_taxRate(yeartaxstandardamt)
//    산출세액, 세율 SetItem..........
//------------------------------------------------------------------------------------
//    연평균과세표준 = 퇴직소득과세표준 / 근속년수
//    연평균산출세액 = wf_get_taxRate(연평균과세표준)
//    산출세액 = 연평균산출세액 * 근속년수
//====================================================================================
tempAmount = 0

if taxableStandardAmt = 0 or il_workyear = 0 then
	yeartaxstandardamt = 0
else
	yeartaxstandardamt = taxableStandardAmt 
	//yeartaxstandardamt = taxableStandardAmt / il_workyear
end if

//String sEnter,  sBase, sFdate, sTdate
//String  ls_str1,  ls_str2
//String  ls_arr1[], ls_arr2[]
//
//long vBefYear, vBefMonth,  vBefDay,  vBefWorkYears, vBefYear1
//long vBefMonth2012
//long vAftYear, vAftMonth,  vAftDay,  vAftWorkYears, vAftYear1
//long vAftYear2013, vAftMonth2013,  vAftDay2013, vAftAddMonth2013

  //근무년수를 별도 테이블 로 가져감.(2014.03.17)
long vAftWorkYears, vAftYears2013, vAftMonth2013,  vBefWorkYears, vBefMonth2012

select  nvl(c_workyear, 0),   nvl(d_workmon, 0),  nvl(d_workyear, 0),  nvl(e_workmon, 0), nvl(e_workyear,0)
	into  :vAftWorkYears,   :vBefMonth2012,	   :vBefWorkYears,		  :vAftMonth2013,	    :vAftYears2013
	from p3_retirementpay_year
	where empno = :iv_empno and fromdate = :sfrom_ymd and todate = :sto_ymd ;
if sqlca.sqlcode <> 0 then
	vAftWorkYears = 0
	vBefMonth2012 = 0
	vBefWorkYears = 0
	vAftMonth2013 = 0
	vAftYears2013 = 0
	messagebox('확인', '퇴직 근무년수 자료가 없습니다.')
	return
else
	if IsNull(vAftWorkYears) then vAftWorkYears = 0
	if IsNull(vBefMonth2012) then vBefMonth2012 = 0
	if IsNull(vBefWorkYears) then vBefWorkYears = 0
	if IsNull(vAftMonth2013) then vAftMonth2013 = 0
	if IsNull(vAftYears2013) then vAftYears2013 = 0
end if
dw_main.SetItem(1, "baseyear2012",  vBefWorkYears )
dw_main.SetItem(1, "basemon2012" , vBefMonth2012)
dw_main.SetItem(1, "baseyear2013",  vAftYears2013 )
dw_main.SetItem(1, "basemon2013" , vAftMonth2013)
 
 
//// sEnter = dw_empbasic.GetItemString(1, "enterdate")
//sEnter = dw_ymd.GetItemString(1, "from_ymd")
//sBase  = '20121231'
//
//sFdate =  dw_ymd.getitemstring(1,"from_ymd")
//sTdate =  dw_ymd.getitemstring(1,"to_ymd")
//
//select hr_fun_term_calc2(:sEnter, :sBase, '1'), hr_fun_term_calc2(:sEnter, :sBase, '2'), hr_fun_term_calc2(:sEnter, :sBase, '3')
//	into :vBefYear, :vBefMonth, :vBefDay
// 	from dual;
//
//vBefYear1 = 0
//
//if vBefMonth  > 0 then
//	vBefYear1 = 1
//elseif vBefMonth  = 0  and vBefDay >0  then
//	vBefYear1 = 1
//else	
//	vBefYear1 = 0
//end if 	
//
//vBefWorkYears = vBefYear + vBefYear1
//
//if vBefDay > 0 then
//	vBefMonth2012 = 1
//end if
//	
//dw_main.SetItem(1, "baseyear2012", vBefWorkYears )
//dw_main.SetItem(1, "basemon2012" , (vBefYear*12) + (vBefMonth+vBefMonth2012) )
//  
//select hr_fun_term_calc2(:sEnter, :sTdate, '1'), hr_fun_term_calc2(:sEnter, :sTdate, '2'), hr_fun_term_calc2(:sEnter, :sTdate, '3')
//	into :vAftYear, :vAftMonth, :vAftDay
// 	from dual;
//
//vAftYear1 = 0
//  
//if vAftMonth  > 0 then
//	vAftYear1 = 1
//elseif 	vAftMonth  = 0  and vAftDay >0  then
//	vAftYear1 = 1
//else	
//	vAftYear1 = 0
//end if 	
//
//vAftWorkYears = vAftYear + vAftYear1
//
//if vAftWorkYears = 0 then
//	vAftWorkYears = 1
//end if 
//dw_main.SetItem(1, "baseyear2013", vAftWorkYears - vBefWorkYears  )
//
////2013년 1월 1일 이후 근속년수 구하기
//select hr_fun_term_calc2('20130101', :sTdate, '1'), hr_fun_term_calc2('20130101', :sTdate, '2'), hr_fun_term_calc2('20130101', :sTdate, '3')
//		 into :vAftYear2013, :vAftMonth2013, :vAftDay2013
//		 from dual;
//	
//if vAftDay2013 > 0 then
//	vAftAddMonth2013 = 1	
//end if 
//dw_main.SetItem(1, "basemon2013" , (vAftYear2013*12) + (vAftMonth2013 + vAftAddMonth2013) )
/////////////////////////////////////////////////////////////////////////////////////

long  vTotBaseAmt , vYearStAmt
 
vTotBaseAmt = yeartaxstandardamt * (vBefWorkYears / vAftWorkYears ) ;
vYearStAmt   = vTotBaseAmt / vBefWorkYears

dw_main.SetItem(1, "baseamt2012",  vTotBaseAmt )
dw_main.SetItem(1, "abaseamt2012", vYearStAmt )
 
//소득세 속산법(과세표준 * 세율 - 누진공제 = 산출세액 ) 과세표준(누진공제율)
long  vBrate ,  vBefTax,  vAddYear , vAfterTax, vTempamt, vTaxcredit,  vChaamt, vArate

select  to_number(substr(dataname,19,3))
	into  :vBrate
  	from p0_syscnfg  
 	where sysgu = 'P' and serial = 98 and to_number(substr(dataname,1,9)) <= :vYearStAmt and to_number(substr(dataname,10,9)) > :vYearStAmt;
  
vBefTax = Truncate(vYearStAmt * vBrate/100,0) * vBefWorkYears
vBefTax = Truncate( vBefTax / 10 ,0) * 10 

dw_main.SetItem(1, "dbaseamt2012", Truncate(vYearStAmt * vBrate/100, 0))	
dw_main.SetItem(1, "ebaseamt2012", vBefTax)	
  
vAddYear = vAftWorkYears - vBefWorkYears 
  
if  vAddYear  = 0  then
	vAfterTax = 0
else
	vTotBaseAmt = yeartaxstandardamt * (vAddYear / vAftWorkYears ) 
	vYearStAmt = truncate(vTotBaseAmt / vAddYear,0) * 5
	
	dw_main.SetItem(1, "baseamt2013",  vTotBaseAmt )
	dw_main.SetItem(1, "abaseamt2013", truncate(vTotBaseAmt / vAddYear,0))
	dw_main.SetItem(1, "bbaseamt2013", vYearStAmt)
	
	select  to_number(substr(dataname,19,3)), to_number(substr(dataname,22,8))
		into  :vArate , :vChaamt
	  	from p0_syscnfg  
	 	where sysgu = 'P' and serial = 98 and to_number(substr(dataname,1,9))  <= :vYearStAmt and to_number(substr(dataname,10,9))  > :vYearStAmt;	
		
	//vAfterTax = Truncate( (vTotBaseAmt * 5 * vArate/ 100 ), 0) - vChaamt;
	vAfterTax = Truncate( (vYearStAmt * vArate/ 100 ), 0) - vChaamt;
	
 	dw_main.SetItem(1, "cbaseamt2013", vAfterTax)
   dw_main.SetItem(1, "dbaseamt2013", truncate(vAfterTax / 5,0))	  
   vAfterTax = truncate(vAfterTax / 5,0) * vAddYear
	vAfterTax = Truncate( vAfterTax / 10 ,0) * 10 
	
   dw_main.SetItem(1, "ebaseamt2013", vAfterTax)
	  
end if
  
tempAmount = vBefTax + vAfterTax
ii_taxrate = 0

dw_main.SetItem(1, "taxrate", ii_taxrate )
dw_main.SetItem(1, "outputtax", tempAmount)

//====================================================================================
//    결정세액 SetItem..............
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_resultIncomeTax")
dw_main.SetItem(1, "resultincometax", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_resultResidentTax")
dw_main.SetItem(1, "resultresidenttax", tempAmount)

//====================================================================================
//  가져온 기납부세액을 SetItem...
//====================================================================================
dw_main.SetItem(1, "preincometax", pre_incomeTaxPaid) 
dw_main.SetItem(1, "preresidenttax", pre_residentTaxPaid)

//====================================================================================
//     차감세액및 차감 퇴직급여, 차인 지급액 SetItem.....................
//====================================================================================
tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_resultincometax")
dw_main.SetItem(1, "balanceincometax", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_resultresidenttax")
dw_main.SetItem(1, "balanceresidenttax", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_balanceRetirePay")
dw_main.SetItem(1, "balanceretirepay", tempAmount)

tempAmount = 0
tempAmount = dw_main.GetItemNumber(1, "cpu_realRetirePay")
dw_main.SetItem(1, "realretirepay", tempAmount)

//====================================================================================
//     퇴직전환금 SetItem.....................
//====================================================================================
 double	ld_junamt
if iv_gubn = "2" then
	  SELECT SUM(NVL("P3_PENSION"."RETIREFINE",0) + NVL("P3_PENSION"."SOGUBAMT",0))    
		 INTO :ld_junamt  
		 FROM "P3_PENSION"  
		WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
				( "P3_PENSION"."EMPNO" = :iv_empno ) and 
				( "P3_PENSION"."FINETAG" <> 'Y')	;
				
	  SELECT sum("P3_RETIREMENTPAY"."PENRETIRETURNSUB")  
	    INTO :tot_pen_amt  
   	 FROM "P3_RETIREMENTPAY"  
	   WHERE ( "P3_RETIREMENTPAY"."COMPANYCODE" = :gs_company ) AND  
   	      ( "P3_RETIREMENTPAY"."EMPNO" = :iv_empno ) AND  
      	   ( "P3_RETIREMENTPAY"."TODATE" < :sto_ymd )  ;
	 IF ISNULL(tot_pen_amt ) THEN tot_pen_amt  =0
	 IF SQLCA.SQLCODE <> 0 THEN
		 tot_pen_amt  = 0
    END IF
	 ld_junamt = ld_junamt - tot_pen_amt 
	 
	 if isnull(ld_junamt) then
		 dw_main.SetItem(1, "penretireturnsub", 0)
	 else 
		 dw_main.SetItem(1, "penretireturnsub", ld_junamt)
	 end if
end if	 
//====================================================================================
//    iv_is_changed 를  True 로 해준다......
//====================================================================================
IF  dw_empBasic.GetItemString(1, "servicekindcode") = "3" Then
    ib_any_typing = True
Else
   ib_any_typing = False
END IF

iRegbn  = dw_main.GetItemString(1,"pergbn")

if iRegbn = '1' then
	dw_main.SetItem(1,"retilsiamt",     dw_main.GetItemNumber(1,"retiretotalamt"))	
	dw_main.SetItem(1,"taxpost_insamt", 0)	
	dw_main.SetItem(1,"taxpost_taxamt", dw_main.GetitemNumber(1,"resultincometax") + dw_main.GetitemNumber(1,"resultresidenttax"))	
elseif iRegbn = '3' then
	dw_main.SetItem(1,"retilsiamt",     0)	
	dw_main.SetItem(1,"taxpost_insamt", 0)
	dw_main.SetItem(1,"taxpost_taxamt", 0)	
else
	dw_main.SetItem(1,"taxpost_taxamt", dw_main.GetitemNumber(1,"resultincometax") + dw_main.GetitemNumber(1,"resultresidenttax"))	
end if


w_mdi_frame.sle_msg.text = "작업 완료"

////////////////////////////////////////////////////   end process




end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_9 from uo_picture within w_pip5022
integer x = 3753
integer y = 492
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\상여삭제_up.gif"
end type

event clicked;call super::clicked;integer il_currow

	il_currow = dw_bonus1year.GetRow()
	IF il_currow <=0 Then Return

//	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
		
   dw_bonus1year.deleterow(il_currow)

//IF dw_empBasic.GetItemString(1, "servicekindcode") = "3"  Then
//
//   IF  dw_bonus1year.Update() > 0 Then
//		 sle_msg.text ="자료를 삭제하였습니다!!"
//	    COMMIT;
//   ELSE
//	    RollBack;
//	    MessageBox("퇴직전 1년간 상여", "데이타윈도우 저장 에러!")
//	    return	
//   END IF
//END IF
//

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\상여삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\상여삭제_up.gif"
end event

type p_10 from uo_picture within w_pip5022
integer x = 3579
integer y = 492
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\상여등록_up.gif"
end type

event clicked;call super::clicked;
long		ll_insrow, ll_rowcnt, ll_row, i
string	ls_company, ls_pbtag, ls_empno

dw_empbasic.AcceptText( ) 
ll_rowcnt = dw_main.RowCount()
if ll_rowcnt < 1 then return

ls_company = dw_empbasic.GetItemString(1, "companycode")
ls_empno = dw_empbasic.GetItemString(1, "empno")

if isNull(ls_company) or isNull(ls_empno) then return


ll_row = dw_bonus1year.rowcount()

if ll_row > 0 then 
  FOR i=1 TO ll_row
     IF wf_required_check(dw_bonus1year.DataObject, i) = -1 THEN RETURN
  NEXT
end if

ll_insrow = dw_bonus1year.InsertRow(0)
dw_bonus1year.SetItem(ll_insrow, "companycode", ls_company)
dw_bonus1year.SetItem(ll_insrow, "empno", ls_empno)
dw_bonus1year.SetItem(ll_insrow, "pbtag", "B")
dw_bonus1year.scrolltorow(ll_insrow)
dw_bonus1year.setrow(ll_insrow)
dw_bonus1year.SetColumn("workym")
dw_bonus1year.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\상여등록_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\상여등록_up.gif"
end event

type p_11 from uo_picture within w_pip5022
integer x = 4037
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\전체삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\전체삭제_dn.gif"
end event

event clicked;call super::clicked;Integer i, li_cnt, iretireseq
Double  dRetireAmount

IF	 MessageBox("삭제 확인", "전체를 삭제하시겠습니까? ", question!, yesno!, 2) = 2	THEN return

dw_main.AcceptText()
//dRetireAmount = dw_main.GetItemNumber(1,"penretireturnsub")
//iretireseq = dw_main.GetItemNumber(1,"retireseq")
//
//IF IsNull(dRetireAmount) THEN dRetireAmount = 0

dw_main.setredraw(false)
dw_main.deleterow(1)
dw_main.setredraw(true)

li_cnt = dw_pay3month.rowcount()

dw_pay3month.setredraw(false)
for i = 1 to li_cnt
	dw_pay3month.deleterow(1)
next
dw_pay3month.setredraw(true)

li_cnt = dw_bonus1year.rowcount()

dw_bonus1year.setredraw(false)
for i = 1 to li_cnt
	dw_bonus1year.deleterow(1)
next
dw_bonus1year.setredraw(true)

IF	dw_main.Update() > 0  Then
	IF dw_pay3month.Update() > 0 Then
		IF  dw_bonus1year.Update() > 0 Then
			delete from P3_ACNT_RETIREYUNGUM where empno = :iv_empno and tag = '1';
			delete from P3_ACNT_RETIREIYUN where  empno = :iv_empno ;
			COMMIT;
		ELSE
			RollBack;
			MessageBox("퇴직전 1년간 상여", "데이타윈도우 삭제 에러!")
			return	
		END IF
	ELSE 
		RollBack;
		MessageBox("퇴직전 1년간 급여", "데이타윈도우 삭제 에러!")
		return	
	END IF
ELSE
	ROLLBACK;
END IF

cb_cancel.TriggerEvent(clicked!)

end event

type pb_1 from picturebutton within w_pip5022
integer x = 1129
integer y = 72
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\first.gif"
alignment htextalign = left!
end type

event clicked;string scode,sname,sMin_name, is_empno

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")

	SELECT min("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)


end event

type pb_3 from picturebutton within w_pip5022
integer x = 1248
integer y = 72
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;string is_empno, scode,sname,sMax_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" < :sname	;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)

end event

type pb_2 from picturebutton within w_pip5022
integer x = 1367
integer y = 72
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;string is_empno, scode,sname,sMin_name

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :is_empno  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :scode	;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" > :sname	;
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)





end event

type pb_4 from picturebutton within w_pip5022
integer x = 1486
integer y = 72
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\last.gif"
end type

event clicked;string is_empno, scode,sname,sMax_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_empbasic.getitemstring(1, "empno")

	SELECT Max("P1_MASTER"."EMPNO")  
		INTO :is_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(is_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_empbasic.GetItemString(1,"empname")
	
	SELECT Max("P1_MASTER"."EMPNAME")  
		INTO :sMax_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :is_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name;
	END IF
End If

dw_empbasic.SetRedraw(false)
dw_empbasic.Retrieve(gs_company,is_empno,'%')
dw_ymd.Retrieve(gs_company,is_empno,'%',gs_today)
dw_empbasic.SetRedraw(true)

cb_retrieve.TriggerEvent(clicked!)

end event

type gb_4 from groupbox within w_pip5022
integer x = 347
integer y = 20
integer width = 695
integer height = 168
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "정렬"
end type

type gb_5 from groupbox within w_pip5022
integer x = 1102
integer y = 20
integer width = 530
integer height = 164
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type rr_1 from roundrectangle within w_pip5022
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 334
integer y = 204
integer width = 2715
integer height = 400
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip5022
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 334
integer y = 648
integer width = 3621
integer height = 1568
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip5022
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 384
integer y = 1696
integer width = 1586
integer height = 496
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip5022
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1998
integer y = 1696
integer width = 1897
integer height = 496
integer cornerheight = 40
integer cornerwidth = 55
end type

