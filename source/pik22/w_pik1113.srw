$PBExportHeader$w_pik1113.srw
$PBExportComments$** 년차일수 계산
forward
global type w_pik1113 from w_inherite_multi
end type
type dw_cond from u_key_enter within w_pik1113
end type
type uo_progress from u_progress_bar within w_pik1113
end type
type pb_1 from picturebutton within w_pik1113
end type
type pb_2 from picturebutton within w_pik1113
end type
type dw_total from u_d_select_sort within w_pik1113
end type
type dw_personal from u_d_select_sort within w_pik1113
end type
type dw_error from u_d_select_sort within w_pik1113
end type
type st_2 from statictext within w_pik1113
end type
type st_3 from statictext within w_pik1113
end type
type st_4 from statictext within w_pik1113
end type
type rr_1 from roundrectangle within w_pik1113
end type
type rr_3 from roundrectangle within w_pik1113
end type
type rr_4 from roundrectangle within w_pik1113
end type
type rr_5 from roundrectangle within w_pik1113
end type
end forward

global type w_pik1113 from w_inherite_multi
string title = "년차 일수 생성"
dw_cond dw_cond
uo_progress uo_progress
pb_1 pb_1
pb_2 pb_2
dw_total dw_total
dw_personal dw_personal
dw_error dw_error
st_2 st_2
st_3 st_3
st_4 st_4
rr_1 rr_1
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
end type
global w_pik1113 w_pik1113

type variables
String               sProcDate,sGetSysDept,sProcDept,li_Gijunday
DataWindow   dw_Process
Integer             il_RowCount, li_level, li_totalday, iYearCnt
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public subroutine wf_create_error (string sempno, string sflag)
public function integer wf_enabled_chk (string sempno, string senterdate)
public function integer wf_calc_useday (string sempno)
public subroutine wf_setsqlsyntax ()
public function string wf_proceduresql ()
public function integer wf_calc_totalday (string sempno, string senterdate, string skmgu)
public function integer wf_calc_iwolday (string sempno)
end prototypes

public function integer wf_requiredchk (integer ll_row);

sProcDate= dw_cond.GetItemString(ll_row,"kdate")
li_totalday = dw_cond.GetItemNumber(ll_row,"totalday")

IF sProcDate = "" OR IsNull(sProcDate) THEN
	MessageBox("확 인","처리년월은 필수입력입니다!!")
	dw_cond.SetColumn("kdate")
	dw_cond.SetFocus()
	Return -1
END IF

IF li_totalday = 0 OR IsNull(li_totalday) THEN
	MessageBox("확 인","총일수는 필수입력입니다!!")
	dw_cond.SetColumn("totalday")
	dw_cond.SetFocus()
	Return -1
END IF


Return 1
end function

public subroutine wf_create_error (string sempno, string sflag);Int    il_CurRow
String sEmpName 

il_CurRow = dw_error.InsertRow(0)
dw_error.SetItem(il_CurRow,"empno",sempno)

SELECT "P1_MASTER"."EMPNAME"  
	INTO :sEmpName  
   FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."EMPNO" = :sEmpno ) AND  
         ( "P1_MASTER"."COMPANYCODE" = :gs_company )   ;

dw_error.SetItem(il_CurRow,"empname",sEmpName)

IF sflag = 'KUNTAE' THEN
	dw_error.SetItem(il_CurRow,"errtext",'근태자료 없슴')
END IF


end subroutine

public function integer wf_enabled_chk (string sempno, string senterdate);Int il_Count
String sDate 
Date   dDate

dDate = RelativeDate(Date(Left(sProcDate,4)+".01.01"),-1)
sDate = String(dDate,'yyyymmdd')

SELECT COUNT("P4_DKENTAE"."EMPNO")
	INTO :il_Count  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" <= :sDate )   ;
IF il_Count <=0 OR IsNull(il_Count) THEN
	Wf_Create_Error(sEmpNo,'KUNTAE')
	Return -1
END IF

Return 1
end function

public function integer wf_calc_useday (string sempno);double iUseDay,iUseDay2
/*년차사용일수 집계*/ 

if iYearCnt <> 1 then

SELECT count("P4_DKENTAE"."KTCODE")  
  INTO :iUseDay  
  FROM "P4_DKENTAE",   
 		 "P0_ATTENDANCE"  
 WHERE ( "P4_DKENTAE"."KTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) AND
		 ( ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND
		   ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND 
		   ( substr("P4_DKENTAE"."KDATE",1,4) = substr(:sProcDate,1,4) ) AND  
			( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '2' ) )  ;
			
	IF SQLCA.SQLCODE <> 0 THEN
		iUseDay = 0
	ELSEIF IsNull(iUseDay) THEN 
		iUseDay = 0
	END IF			

else
	SELECT count("P4_DKENTAE"."KTCODE")  
   INTO :iUseDay2  
  FROM "P4_DKENTAE",   
 		 "P0_ATTENDANCE"  
 WHERE ( "P4_DKENTAE"."KTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) AND
		 ( ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND
		   ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND 
		   ( substr("P4_DKENTAE"."KDATE",1,4) = substr(:sProcDate,1,4) ) AND  
			( "P4_DKENTAE"."KDATE" >= :li_Gijunday ) and
			( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '6' ) )  ;
end if
		
	IF SQLCA.SQLCODE <> 0 THEN
		iUseDay2 = 0
	ELSEIF IsNull(iUseDay2) THEN 
		iUseDay2 = 0
	END IF
	
iUseDay = iUseDay + iUseDay2*0.5

return iUseDay
end function

public subroutine wf_setsqlsyntax ();
Int    k  
String sGetSqlSyntax,sEmpNo,sProcPos
Long   lSyntaxLength

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")

IF sProcPos = 'T' or sProcPos = 'D' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

dw_insert.DataObject ='d_pik1113_3'
dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

sGetSqlSyntax = dw_insert.GetSqlSelect()

sGetSqlSyntax = sGetSqlSyntax + "where ("

dw_Process.AcceptText()

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' empno =' + "'"+ sEmpNo +"'"+ ' or'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

sGetSqlSyntax = sGetSqlSyntax + ' and (companycode = ' + "'" + gs_company +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' and (yymm = ' + "'" + left(sprocdate,6) +"'"+")"

dw_insert.SetSQLSelect(sGetSqlSyntax)






end subroutine

public function string wf_proceduresql ();
Int    k 
String sGetSqlSyntax,sEmpNo,sProcPos,sSpace,sJikGbn,ls_date
Long   lSyntaxLength

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")


IF sProcPos = 'T' OR sProcPos = 'D' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF sProcDept ="" OR IsNull(sProcDept) THEN
	sProcDept ='%'
END IF

sGetSqlSyntax = 'select empno,deptcode,enterdate,retiredate,kmgubn,jikjonggubn from p1_master'

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' WHERE ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.empno =' + "'"+ sEmpNo +"')"+ ' OR'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"


Return sGetSqlSynTax


end function

public function integer wf_calc_totalday (string sempno, string senterdate, string skmgu);/******************************************************************************************/
/***    2.2. 발생일수 = 																						*/
/***             근태코드의 근태구분이 '4'(근태계산코드)이고 일근태의 일자가 					*/
/***             '(처리년도 - 1)+'01' ~ (처리년도 - 1)+'12' '인 근태일수의 합(A)    	   */
/***         IF A = 0 THEN 발생일수 = 10																	*/
/***         ELSE 																								*/
/***            총근무일수(B) = '관리직'이면 달력FILE에서 휴일을 제외한 일자의 합			*/
/***                            '생산직'이면 달력FILE에서 월~금의 합								*/
/***                            (화면에서 입력)															*/
/***            IF B * 0.1 >  A THEN 발생일수 = 8														*/
/***                       <= A THEN 발생일수 = 0														*/
/******************************************************************************************/

String sBefYearMD,sYearMBefD
Int    il_Count,il_Count2,iTotalDay,iBalDay, iBalDay2, dd, kmonth ,gijunmonth  



/*처리년도 - 1 +'01' */  
sBefYearMD = String(Long(Left(sProcDate,4)) - 1) + '01'

/*처리년도 - 1 + '12'*/
sYearMBefD = String(Long(Left(sProcDate,4)) - 1) + '12'

if iYearCnt >= 1 AND string(long(left(senterdate,4))+2) <= left(sProcDate,4)  then
	
                                                   /*무단결근일수*/
  select count(p4_dkentae.kdate)     INTO :il_Count 
	from p4_dkentae, p0_attendance
	where p4_dkentae.companycode = :gs_company and
	      p4_dkentae.empno = :sEmpNo and
			p4_dkentae.kdate between :sBefYearMD and :sYearMBefD and   
			p4_dkentae.ktcode = p0_attendance.attendancecode and
	      p0_attendance.attendancegubn = '4';
	

	IF SQLCA.SQLCODE <> 0 THEN
		il_Count = 0
	ELSE
		IF IsNull(il_Count) THEN il_Count =0
	END IF


	il_Count2 = sqlca.fun_get_hjikday(gs_company,sEmpNo,sBefYearMD+'01',sYearMBefD+'31','A');
	
	IF IsNull(il_Count2) THEN il_Count2 =0


	il_Count = il_Count + il_Count2

/* 개인별 Total 일수*/

dd = daysafter(date(left(senterdate,4) + "/" + mid(senterdate,5,2) + "/" + right(senterdate,2)),date(left(sYearMBefD,4) + "/12/31"))

	IF il_Count = 0 THEN
		iBalDay = 10 
		IF il_Count <> 0 AND iBalDay <> 0 THEN
			IF li_TotalDay * 0.05 >= il_Count THEN 
				iBalDay = 9
			ELSEIF  li_TotalDay * 0.1 >= il_Count THEN 
				iBalDay = 8
			ELSE
				iBalDay = 0
			END IF
		END IF	
	ELSE
		IF ( dd - il_Count) / li_totalday >= 0.950 then
			iBalDay = 9 
		ELSEIF ( dd - il_Count) / li_totalday >= 0.900 then
			iBalDay = 8 
		ELSE
			iBalDay = 0
		END IF	
	END IF

else                                             //작년에 입사한자(1년차) 만일년의 근태평가
	sBefYearMD = senterdate
	sYearMBefD = sYearMBefD+'31'
	
	select count(p4_dkentae.kdate)     INTO :il_Count 
	from p4_dkentae, p0_attendance
	where p4_dkentae.companycode = :gs_company and
	      p4_dkentae.empno = :sEmpNo and
			p4_dkentae.kdate between :sBefYearMD and :sYearMBefD and   
			p4_dkentae.ktcode = p0_attendance.attendancecode and
	      p0_attendance.attendancegubn = '4';
	
   IF SQLCA.SQLCODE <> 0 THEN
	  il_Count = 0
	ELSE
		IF IsNull(il_Count) THEN il_Count =0
	END IF

   il_Count2 = sqlca.fun_get_hjikday(gs_company,sEmpNo,sBefYearMD,sYearMBefD,'H');
	
	IF IsNull(il_Count2) THEN il_Count2 =0


	il_Count = il_Count + il_Count2

                                //일요일이 아니고 휴일구분이 근무일('0')인 날짜
     	SELECT COUNT("P4_CALENDAR"."CLDATE")  
      	INTO :iTotalDay  
    	FROM "P4_CALENDAR"  
   	WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
        		( "P4_CALENDAR"."HDAYGUBN" = '0' ) AND  
				( "P4_CALENDAR"."DAYGUBN" <> '1') AND
		      ( "P4_CALENDAR"."CLDATE" between :sBefYearMD and :sYearMBefD )   ;
				
		IF SQLCA.SQLCODE <> 0 THEN
			iTotalDay =0
		ELSE
			IF IsNull(iTotalDay) THEN iTotalDay =0
		END IF
		
	if right(senterdate,2) = '01' then
		gijunmonth = 13 - long(mid(senterdate,5,2))
	else
		gijunmonth = 12 - long(mid(senterdate,5,2))
	end if                      
		
	if il_Count = 0 then
	   iBalDay =  round(gijunmonth / 12  * 10, 0)  
   else               	
		IF iTotalDay * 0.05 > il_Count THEN 
			iBalDay = round(gijunmonth / 12  * 9, 0)  
		ELSEIF iTotalDay * 0.1 > il_Count THEN 
			iBalDay = round(gijunmonth / 12 * 8, 0)  			
		ELSE 
			iBalDay = 0
		END IF			
  end if
  	
end if

Return iBalDay
end function

public function integer wf_calc_iwolday (string sempno);/******************************************************************************************/
/***    2.1. 이월일수 =  																						*/
/***             년차 table의 전년도 + 처리월  (적치일수) 											*/
/******************************************************************************************/

String sBefYearMonth  
Int    iCalcVal,iBefDay,iUseday, iKDay  

sBefYearMonth = String(Long(Left(sProcDate,4)) - 1) + Mid(sProcDate,5,2)	/*전년도+처리월*/

	
  SELECT NVL("P4_YEARLIST"."YDAY",0)  
	INTO :iBefDay 
   FROM "P4_YEARLIST"  
   WHERE ( "P4_YEARLIST"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_YEARLIST"."EMPNO" = :sEmpNo ) AND  
         ( "P4_YEARLIST"."YYMM" = :sBefYearMonth )   ;
	
			
IF SQLCA.SQLCODE = 0 THEN
	IF IsNull(iBefDay) THEN iBefDay =0
ELSEIF SQLCA.SQLCODE = -1 THEN
	iBefDay = 0
ELSEIF SQLCA.SQLCODE = 100 THEN
	iBefDay = 0
END IF

iCalcVal = iBefDay 


Return iCalcVal



end function

on w_pik1113.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.uo_progress=create uo_progress
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_total=create dw_total
this.dw_personal=create dw_personal
this.dw_error=create dw_error
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.uo_progress
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_total
this.Control[iCurrent+6]=this.dw_personal
this.Control[iCurrent+7]=this.dw_error
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.rr_4
this.Control[iCurrent+14]=this.rr_5
end on

on w_pik1113.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.uo_progress)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_total)
destroy(this.dw_personal)
destroy(this.dw_error)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
end on

event open;call super::open;string sDeptName, syear, sabu
    
dw_total.SetTransObject(SQLCA)        
dw_personal.SetTransObject(SQLCA) 
dw_error.SetTransObject(SQLCA) 
dw_insert.SetTransObject(SQLCA) 

dw_cond.SetTransObject(SQLCA) 
dw_cond.Reset()
dw_cond.InsertRow(0)


pb_1.picturename = "C:\erpman\Image\next.gif"
pb_2.picturename = "C:\erpman\Image\prior.gif"

syear = string(integer(left(gs_today,4)) - 1)

//총근로일수
SELECT count("P4_CALENDAR"."CLDATE" )  
  INTO :li_totalday  
  FROM "P4_CALENDAR"  
 WHERE ( SUBSTR("P4_CALENDAR"."CLDATE",1,4) = :syear ) AND  
       ( "P4_CALENDAR"."HDAYGUBN" = '0' )   ;
		 
if isnull(li_totalday) then li_totalday= 0
		 
if sqlca.sqlcode <> 0 then
	li_totalday = 0 
end if

// 부서코드
SELECT "P0_SYSCNFG"."DATANAME"  														/*근태 담당부서*/
	INTO :sGetSysDept  
   FROM "P0_SYSCNFG"  
   WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "P0_SYSCNFG"."SERIAL" = 1 ) AND  
         ( "P0_SYSCNFG"."LINENO" = '1' )   ;
			
IF IsNull(sGetSysDept) THEN sGetSysDept =" "

//부서level check	
SELECT "P0_DEPT"."DEPT_LEVEL"  
  INTO :li_level
  FROM "P0_DEPT"  
 WHERE "P0_DEPT"."DEPTCODE" = :gs_dept   ;
	
IF SQLCA.SQLCODE <> 0 THEN	
	 li_level = 3
END IF	

IF gs_dept = sGetSysDept THEN
	dw_cond.SetItem(1,"proc_pos",'T')
	dw_cond.Modify("proc_pos.protect = 0")
ELSE
	dw_cond.SetItem(1,"proc_pos",'D')
	dw_cond.SetItem(1,"deptcode",gs_dept)

	SELECT "DEPTNAME2"	INTO :sDeptName
		FROM "P0_DEPT"
		WHERE "P0_DEPT"."DEPTCODE" =:gs_dept;
		
	dw_cond.SetItem(1,"p0_dept_deptname2",sDeptName)
	
	dw_cond.Modify("proc_pos.protect = 1")
	dw_cond.Modify("deptcode.protect = 1")
END IF

f_set_saupcd(dw_cond, 'sabu', '1')
is_saupcd = gs_saupcd

dw_cond.SetItem(1,"kdate",gs_today)
dw_cond.SetItem(1,"totalday",li_totalday)
dw_cond.SetColumn("kdate")
dw_cond.SetFocus()

uo_progress.Hide()

end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1113
boolean visible = false
integer x = 3602
integer y = 2936
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1113
boolean visible = false
integer x = 3429
integer y = 2936
end type

type p_search from w_inherite_multi`p_search within w_pik1113
boolean visible = false
integer x = 2907
integer y = 2936
end type

type p_ins from w_inherite_multi`p_ins within w_pik1113
boolean visible = false
integer x = 3255
integer y = 2936
end type

type p_exit from w_inherite_multi`p_exit within w_pik1113
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pik1113
integer x = 4242
end type

event p_can::clicked;call super::clicked;uo_progress.Hide()

w_mdi_frame.sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

dw_cond.SetItem(1,"proc_pos",'T')
end event

type p_print from w_inherite_multi`p_print within w_pik1113
boolean visible = false
integer x = 3081
integer y = 2936
end type

type p_inq from w_inherite_multi`p_inq within w_pik1113
integer x = 3895
end type

event p_inq::clicked;call super::clicked;String sProcPos, sdeptcode, sdept, sadddeptcode, sabu, sKunmu
Int    MonthCnt,k,il_RtvRow, iyear

dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

w_mdi_frame.sle_msg.text ='자료 조회 중......'

sdept = dw_cond.getitemstring(1,"deptcode")
sProcPos = dw_cond.getitemstring(1,"proc_pos")
sKunmu = trim(dw_cond.GetitemString(1,'kunmu'))

IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

sabu = dw_cond.GetItemString(1,"sabu")
if IsNull(sabu) or sabu = '' then
	messagebox("확인","사업장을 확인하십시요!")
	dw_cond.setcolumn('sabu')
	dw_cond.setfocus()
	w_mdi_frame.sle_msg.text=''
	return
end if


IF sdept = '' or isnull(sdept) then sdept = '%'
sProcDept = sdept
IF li_level = 3 then
	sdeptcode = sdept
	sadddeptcode = '%'
ELSE
	sadddeptcode = sdept
	sdeptcode = '%'
END IF

dw_total.SetRedraw(False)
IF dw_total.Retrieve(sProcDate,sdeptcode, sadddeptcode, sabu, sKunmu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_cond.SetFocus()
	w_mdi_frame.sle_msg.text=''
	Return
ELSE
	il_RtvRow = dw_total.RowCount()
	w_mdi_frame.sle_msg.text='조회완료!'
END IF

//FOR k = il_RtvRow TO 1 STEP -1
//	iYearCnt  = dw_total.GetItemNumber(k,"year_cnt")
//	iMonthCnt = dw_total.GetItemNumber(k,"month_cnt")
//	
//	IF iYearCnt <=0 OR iMonthCnt > 0 THEN
//		dw_total.DeleteRow(k)
//	END IF
//NEXT

dw_total.SetRedraw(True)


IF sProcPos = 'T' or sProcPos = 'D' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF


//iyear = dw_process.getitemNumber(1,'year_cnt')



end event

type p_del from w_inherite_multi`p_del within w_pik1113
boolean visible = false
integer x = 3776
integer y = 2936
end type

type p_mod from w_inherite_multi`p_mod within w_pik1113
integer x = 4069
end type

event p_mod::clicked;call super::clicked;Int    il_meterPosition,k,il_SearchRow,il_RetrieveRow,il_CurRow
String sProcPos,sEmpNo,sDeptCode,sEnterDate,sKmGbn,sLevelCode,sSalary,sGradeCode,sAddeptCode,sabu
Int    il_BefCount
double iIwolDay,iTotalDay,iGunDay,iRemainDay,iSaveDay,iPayDay,iYearDay,iUseDay,iUseDay1
string sMasterSql,sRtnValue

dw_error.Reset()

// 월마감작업후 월근태 집계처리 못함
string ls_flag

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = substr(:sprocdate,1,6) ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	


dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_cond.AcceptText()
sabu = dw_cond.GetItemString(1,'sabu')
sProcPos = dw_cond.GetItemString(1,"proc_pos")


IF sProcPos = 'T' or  sProcPos = 'D' THEN										//전체,부서
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE																						//개인
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF il_RowCount <=0 THEN 
	MessageBox("확 인","처리할 자료가 없습니다!!")
	Return
END IF

/* 처리년월의 년차자료가 있는지 확인*/
SELECT Count("YYMM")
	INTO :il_BefCount
   FROM "P4_YEARLIST"
   WHERE ("COMPANYCODE" = :gs_company) and  "YYMM" = substr(:sProcDate,1,6) ;
	
IF SQLCA.SQLCODE = 0 AND il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "이전 년차 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF
IF sProcPos = 'T' THEN
//	DELETE  FROM "P4_YEARLIST"
//   WHERE ("COMPANYCODE" = :gs_company) and  "YYMM" = substr(:sProcDate,1,6) ;
	
	DELETE FROM p4_yearlist
   WHERE (p4_yearlist.companycode = :gs_company ) and
         (p4_yearlist.yymm = substr(:sProcDate,1,6)) and
         (p4_yearlist.empno in (select p1_master.empno 
                                from p1_master, p0_dept 
                                where p1_master.companycode = p0_dept.companycode  and
                                      p1_master.deptcode = p0_dept.deptcode and
                                      p0_dept.saupcd = :sabu));
	commit;
END IF	

wf_SetSqlSyntax()

sMasterSql = wf_ProcedureSql()

w_mdi_frame.sle_msg.text = '년차 계산 중......'
SetPointer(HourGlass!)

sRtnValue = sqlca.sp_create_yearlist(gs_company,sMasterSql,Left(sProcDate,4)+'0101',Left(sProcDate,4)+'1231',left(sProcdate,6));
		  
IF Left(sRtnValue,2) <> 'OK' then
	MessageBox("확 인","년차계산 실패!!"+"["+sRtnValue+"]")
	Rollback;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
	Return
ELSE
	commit;
	dw_error.Retrieve()
END IF		  


SetPointer(Arrow!) 
w_mdi_frame.sle_msg.text ='년차 계산 완료!!'
end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1113
boolean visible = false
integer x = 905
integer y = 2588
end type

type st_window from w_inherite_multi`st_window within w_pik1113
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pik1113
boolean visible = false
integer x = 1595
integer y = 2668
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pik1113
boolean visible = false
integer x = 3488
integer y = 2668
integer taborder = 100
end type

type cb_update from w_inherite_multi`cb_update within w_pik1113
boolean visible = false
integer x = 2784
integer y = 2668
integer taborder = 80
end type

event cb_update::clicked;call super::clicked;/******************************************************************************************/
/*** 년차 계산	 																									*/
/*** - 이전 자료를 삭제한 후 계산 한다.																	*/
/*** 1. 처리일자를 입력받아서 처리하며 계산일자는 처리일자 한다.                 			*/
/*** 2. 일수 계산							 																		*/
/***    2.1. 이월일수 =  	  																					*/
/***             '년차 table의 전년도 + 처리월'의 (발생일수-사용일수-지급일수)		   	*/
/***                             																			*/	
/***    2.2. 발생일수 = 																						*/
/***             근태코드의 근태구분이 '4'(근태계산코드)이고 월근태의 일자가 					*/
/***             '(처리년도 - 1)+'01' ~ (처리년도 - 1)+'12' '인 근태일수의 합(A)        	*/
/***         IF A = 0 THEN 발생일수 = 10																	*/
/***         ELSE 																								*/
/***            총근무일수(B) = '관리직'이면 달력FILE에서 휴일을 제외한 일자의 합			*/
/***                            '생산직'이면 달력FILE에서 월~금의 합								*/
/***                            (화면에서 입력)															*/
/***            IF B * 0.1 >  A THEN 발생일수 = 8														*/
/***                       <= A THEN 발생일수 = 0														*/
/***    2.3. 누적일수 = 근속년수 - 1																		*/
/***    2.4. 년차일수 = 이월일수 + 발생일수 + 누적일수												*/
/***    2.5. 사용일수 = 0																						*/
/***    2.6. 잔여일수 = 년차일수 - 사용일수     														*/
/***    2.7. 적치일수 = 0																						*/
/***    2.8. 지급일수 = 0																						*/
/***    2.9. 사용기간(FROM) = 처리년도 + '0101'															*/	
/***         사용기간(TO)   = 처리년도 + '1231'															*/
/***    2.10. 생성일자 = SYSTEM DATE																			*/
/******************************************************************************************/

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRow,il_CurRow
String sProcPos,sEmpNo,sDeptCode,sEnterDate,sKmGbn,sLevelCode,sSalary,sGradeCode,sAddeptCode,sabu
Int    il_BefCount
double iIwolDay,iTotalDay,iGunDay,iRemainDay,iSaveDay,iPayDay,iYearDay,iUseDay,iUseDay1
string sMasterSql,sRtnValue

dw_error.Reset()

// 월마감작업후 월근태 집계처리 못함
string ls_flag

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = substr(:sprocdate,1,6) ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	


dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_cond.AcceptText()
sabu = dw_cond.GetItemString(1,'sabu')
sProcPos = dw_cond.GetItemString(1,"proc_pos")


IF sProcPos = 'T' or  sProcPos = 'D' THEN										//전체,부서
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE																						//개인
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF il_RowCount <=0 THEN 
	MessageBox("확 인","처리할 자료가 없습니다!!")
	Return
END IF

/* 처리년월의 년차자료가 있는지 확인*/
SELECT Count("YYMM")
	INTO :il_BefCount
   FROM "P4_YEARLIST"
   WHERE ("COMPANYCODE" = :gs_company) and  "YYMM" = substr(:sProcDate,1,6) ;
	
IF SQLCA.SQLCODE = 0 AND il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "이전 년차 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF
IF sProcPos = 'T' THEN
//	DELETE  FROM "P4_YEARLIST"
//   WHERE ("COMPANYCODE" = :gs_company) and  "YYMM" = substr(:sProcDate,1,6) ;
	
	DELETE FROM p4_yearlist
   WHERE (p4_yearlist.companycode = :gs_company ) and
         (p4_yearlist.yymm = substr(:sProcDate,1,6)) and
         (p4_yearlist.empno in (select p1_master.empno 
                                from p1_master, p0_dept 
                                where p1_master.companycode = p0_dept.companycode  and
                                      p1_master.deptcode = p0_dept.deptcode and
                                      p0_dept.saupcd = :sabu));
	commit;
END IF	

wf_SetSqlSyntax()

sMasterSql = wf_ProcedureSql()

sle_msg.text = '년차 계산 중......'
SetPointer(HourGlass!)

//sRtnValue = sqlca.sp_create_yearlist(gs_company,sMasterSql,Left(sProcDate,4)+'0101',Left(sProcDate,4)+'1231',left(sProcdate,6));
//		  
//IF Left(sRtnValue,2) <> 'OK' then
//	MessageBox("확 인","년차계산 실패!!"+"["+sRtnValue+"]")
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text =''
//	Return
//ELSE
//	dw_error.Retrieve()
//END IF		  
//
//
////dw_insert.SetTransObject(SQLCA)
//dw_insert.Modify( "DataWindow.Table.UpdateTable = ~"P4_YEARLIST~"")
//dw_insert.Retrieve()
//il_RetrieveRow = dw_insert.RowCount() 											//이전 처리 건수
//
//
//
//uo_progress.Show()
//
//iSaveDay   = 0																			/*적치일수*/
//	
//FOR k = 1 TO il_RowCount
//	
//	sEmpNo     = dw_Process.GetItemString(k,"empno")
//	sDeptCode  = dw_Process.GetItemString(k,"deptcode")
//	sEnterDate = dw_Process.GetItemString(k,"enterdate")
//	sKmGbn     = dw_Process.GetItemString(k,"kmgubn")
//	iYearCnt   = dw_Process.GetItemNumber(k,"year_cnt")
//
//	sLevelCode = dw_Process.GetItemString(k, "levelcode")
//	sSalary    = dw_Process.GetItemString(k, "salary")
//	sGradeCode = dw_Process.GetItemString(k, "gradecode")
//	sAddeptCode = dw_Process.GetItemString(k, "adddeptcode")
//	
//	
//	IF IsNull(iYearCnt) THEN iYearCnt =0
//	
//	il_meterPosition = (k/ il_RowCount) * 100
//	uo_progress.uf_set_position (il_meterPosition)		  
//	
//
//	//iIwolDay   = Wf_Calc_IwolDay(sEmpNo)										/*이월일수*/
//	iIwolDay = 0
//	iTotalDay  = Wf_Calc_TotalDay(sEmpNo,sEnterDate,sKmGbn)				/*발생일수*/
//	iTotalDay = iTotalDay + 1                                         /*rememberday*/
//	if long(left(senterdate,4))+3 <= long(left(sProcDate,4))  then
//	iGunDay    = iYearCnt - 1														/*누적일수*/
//	if iGunDay < 0 or iTotalDay = 0 then iGunday = 0
//   end if
//	iYearDay   = iIwolDay + iTotalDay + iGunDay								/*년차일수*/ 
//	iUseDay    = wf_calc_useday(sEmpNo)											/*사용일수*/	
//	iRemainDay = iYearDay - iUseDay                                	/*잔여일수*/ 
//	
//	iPayDay    = iRemainDay      			         							/*지급일수*/
//	iSaveDay   = 0        							         		         /*적치일수*/
//	
//	
//	IF il_RetrieveRow > 0 THEN
//		il_SearchRow = dw_insert.Find("companycode = '"+gs_company+"' and empno ='"+sEmpNo+"'",1,il_RetrieveRow)
//		IF il_SearchRow > 0 THEN
//			dw_insert.DeleteRow(il_SearchRow)	
//		END IF
//	END IF
//	
//	il_CurRow = dw_insert.InsertRow(dw_insert.RowCount() + 1)
//	IF iYearDay > 0 THEN
//		dw_insert.SetItem(il_CurRow,"companycode",gs_company) 
//		dw_insert.SetItem(il_CurRow,"deptcode",   sDeptCode)
//		dw_insert.SetItem(il_CurRow,"empno",      sEmpNo)
//		dw_insert.SetItem(il_CurRow,"yymm",       Left(sProcDate,6))
//		dw_insert.SetItem(il_CurRow,"yday",       iIwolDay)
//		dw_insert.SetItem(il_CurRow,"bday",       iTotalDay)
//		dw_insert.SetItem(il_CurRow,"jday",       iRemainDay)
//		dw_insert.SetItem(il_CurRow,"cday",       iSaveDay)
//		dw_insert.SetItem(il_CurRow,"sday",       iUseDay)
//		dw_insert.SetItem(il_CurRow,"kday",       iPayDay)
//		dw_insert.SetItem(il_CurRow,"kdate",      Left(sProcDate,4)+'0101')
//		dw_insert.SetItem(il_CurRow,"kdateto",    Left(sProcDate,4)+'1231')		
//	
//		dw_insert.SetItem(il_CurRow,"adddeptcode",sAddeptCode)
//		dw_insert.SetItem(il_CurRow,"levelcode",  sLevelCode)
//		dw_insert.SetItem(il_CurRow,"salary",     sSalary)
//		dw_insert.SetItem(il_CurRow,"gradecode",  sGradeCode)
//		dw_insert.SetItem(il_CurRow,"addday",    	iGunDay)
//		dw_insert.SetItem(il_CurRow,"yearday",    iYearDay)
//		dw_insert.SetItem(il_CurRow,"createdate", gs_today)
//	END IF	
//NEXT
//
//IF dw_insert.Update() <> 1 THEN
//	MessageBox("확 인","년차 저장 실패!!")
//	ROLLBACK;
//	Return
//END IF
//
//COMMIT;
//
//uo_progress.Hide()

SetPointer(Arrow!) 
sle_msg.text ='년차 계산 완료!!'

end event

type cb_insert from w_inherite_multi`cb_insert within w_pik1113
boolean visible = false
integer x = 1961
integer y = 2668
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1113
boolean visible = false
integer x = 1243
integer y = 2660
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1113
boolean visible = false
integer x = 2418
integer y = 2668
integer taborder = 50
end type

event cb_retrieve::clicked;call super::clicked;String sProcPos, sdeptcode, sdept, sadddeptcode, sabu
Int    MonthCnt,k,il_RtvRow, iyear

dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

sle_msg.text ='자료 조회 중......'

sdept = dw_cond.getitemstring(1,"deptcode")
sProcPos = dw_cond.getitemstring(1,"proc_pos")

sabu = dw_cond.GetItemString(1,"sabu")
if IsNull(sabu) or sabu = '' then
	messagebox("확인","사업장을 확인하십시요!")
	dw_cond.setcolumn('sabu')
	dw_cond.setfocus()
	return
end if


IF sdept = '' or isnull(sdept) then sdept = '%'
sProcDept = sdept
IF li_level = 3 then
	sdeptcode = sdept
	sadddeptcode = '%'
ELSE
	sadddeptcode = sdept
	sdeptcode = '%'
END IF

dw_total.SetRedraw(False)
IF dw_total.Retrieve(sProcDate,sdeptcode, sadddeptcode, sabu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_cond.SetFocus()
	Return
ELSE
	il_RtvRow = dw_total.RowCount()
END IF

//FOR k = il_RtvRow TO 1 STEP -1
//	iYearCnt  = dw_total.GetItemNumber(k,"year_cnt")
//	iMonthCnt = dw_total.GetItemNumber(k,"month_cnt")
//	
//	IF iYearCnt <=0 OR iMonthCnt > 0 THEN
//		dw_total.DeleteRow(k)
//	END IF
//NEXT

dw_total.SetRedraw(True)
sle_msg.text =''

IF sProcPos = 'T' or sProcPos = 'D' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF


//iyear = dw_process.getitemNumber(1,'year_cnt')



end event

type st_1 from w_inherite_multi`st_1 within w_pik1113
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1113
boolean visible = false
integer x = 3122
integer y = 2668
integer taborder = 90
end type

event cb_cancel::clicked;call super::clicked;
uo_progress.Hide()

sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

dw_cond.SetItem(1,"proc_pos",'T')
end event

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1113
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1113
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1113
boolean visible = false
integer x = 2350
integer y = 2608
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1113
boolean visible = false
integer x = 1184
integer y = 2608
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1113
boolean visible = false
end type

type dw_cond from u_key_enter within w_pik1113
event ue_key pbm_dwnkey
integer x = 567
integer y = 12
integer width = 2967
integer height = 288
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik1113_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String sDeptCode,sDeptName,sProcGbn,snull, syear

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "kdate" THEN
	sProcDate = Trim(this.GetText())
	
	IF sProcDate = "" OR IsNull(sProcDate) THEN RETURN
	
	IF f_datechk(sProcDate) = -1 THEN
		MessageBox("확 인","유효한 날짜가 아닙니다!!")
		dw_cond.SetItem(1,"kdate",snull)
		Return 1
	ELSE
		syear = string(integer(left(sProcDate,4)) - 1)
		
		//총근로일수
		SELECT count("P4_CALENDAR"."CLDATE" )  
		  INTO :li_totalday  
		  FROM "P4_CALENDAR"  
		 WHERE ( SUBSTR("P4_CALENDAR"."CLDATE",1,4) = :syear ) AND  
				 ( "P4_CALENDAR"."HDAYGUBN" = '0' )   ;
				 
		if isnull(li_totalday) then li_totalday= 0
				 
		if sqlca.sqlcode <> 0 then
			li_totalday = 0 
		end if
		
		dw_cond.SetItem(1,"totalday",li_totalday)
	END IF
END IF

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"p0_dept_deptname2",snull)
		sProcDept = '%'
	//	Return
	END IF

	SELECT "P0_DEPT"."DEPTNAME"  
   	INTO :sDeptName
   	FROM "P0_DEPT"  
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P0_DEPT"."DEPTCODE" = :sDeptCode )   ;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"p0_dept_deptname2",sDeptName)
	ELSE
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return 1
	END IF
	
END IF
p_inq.TriggerEvent(Clicked!)
end event

event getfocus;this.AcceptText()
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd

IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"p0_dept_deptname2",gs_codename)
END IF

p_inq.TriggerEvent(Clicked!)
end event

event losefocus;dw_cond.accepttext()

IF dw_personal.RowCount() > 0 THEN
	dw_cond.SetItem(1,"proc_pos",'P')
ELSE
	sprocdept = dw_cond.Getitemstring(1,"deptcode")	
	IF sProcDept ="" or isnull(sprocdept) THEN
		dw_cond.SetItem(1,"proc_pos",'T')
	ELSE
		dw_cond.SetItem(1,"proc_pos",'D')
	END IF
END IF

end event

type uo_progress from u_progress_bar within w_pik1113
integer x = 2839
integer y = 2212
integer width = 1083
integer height = 76
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type pb_1 from picturebutton within w_pik1113
integer x = 1527
integer y = 636
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sKmGbn,sEnterDate,sDeptCode,sLevelCode, sSalary, sGradeCode, sAddDeptCode
Long rowcnt , totRow , sRow ,gRow 
int i

totRow =dw_total.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_total.getselectedrow(gRow)
	IF sRow > 0 THEN
		sEmpNo     = dw_total.GetItemString(sRow, "empno")
      sEmpName   = dw_total.GetItemString(sRow, "empname")
		sDeptCode  = dw_total.GetItemString(sRow, "deptcode") 
	   sKmGbn     = dw_total.GetItemString(sRow, "kmgubn")
	   iYearCnt   = dw_total.GetItemNumber(sRow, "year_cnt")
	   sEnterDate = dw_total.GetItemString(sRow, "enterDate")
		
	   sLevelCode = dw_total.GetItemString(sRow, "levelcode")
		sSalary    = dw_total.GetItemString(sRow, "salary")
		sGradeCode = dw_total.GetItemString(sRow, "gradecode")
		sAddDeptCode = dw_total.GetItemString(sRow, "adddeptcode")
		
		
		
		rowcnt = dw_personal.RowCount() + 1
		
		dw_personal.insertrow(rowcnt)
      dw_personal.setitem(rowcnt, "empname",  sEmpName)
		dw_personal.setitem(rowcnt, "empno",    sEmpNo)
		dw_personal.setitem(rowcnt, "kmgubn",   sKmGbn)
		dw_personal.setitem(rowcnt, "deptcode", sDeptCode)
		dw_personal.setitem(rowcnt, "year_cnt", iYearCnt)
		dw_personal.setitem(rowcnt, "enterdate",sEnterDate)
		
		dw_personal.setitem(rowcnt, "levelcode",sLevelCode)
		dw_personal.setitem(rowcnt, "salary",sSalary)
		dw_personal.setitem(rowcnt, "gradecode",sGradeCode)
		dw_personal.setitem(rowcnt, "adddeptcode",sAddDeptCode)
		
		dw_total.deleterow(sRow)
		gRow = sRow -1
	ELSE
		Exit
	END IF
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_cond.SetItem(1,"proc_pos",'P')
ELSE
	IF sProcDept ="%" THEN
		dw_cond.SetItem(1,"proc_pos",'T')
	ELSE
		dw_cond.SetItem(1,"proc_pos",'D')
	END IF
END IF
end event

type pb_2 from picturebutton within w_pik1113
integer x = 1527
integer y = 752
integer width = 101
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sKmGbn,sEnterDate,sDeptCode,sLevelCode ,sSalary,sGradeCode,sAddDeptCode
Long rowcnt , totRow , sRow ,gRow
int i

totRow =dw_personal.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_personal.getselectedrow(gRow)
	IF sRow > 0 THEN
   	sEmpNo     = dw_personal.GetItemString(sRow, "empno")
 	   sEmpName   = dw_personal.GetItemString(sRow, "empname")
	   sKmGbn     = dw_personal.GetItemString(sRow, "kmgubn")
		sDeptCode  = dw_personal.GetItemString(sRow, "deptcode")
	   iYearCnt   = dw_personal.GetItemNumber(sRow, "year_cnt")
	   sEnterDate = dw_personal.GetItemString(sRow, "enterDate")
		
		sLevelCode = dw_personal.GetItemString(sRow, "levelcode")
		sSalary    = dw_personal.GetItemString(sRow, "salary")
		sGradeCode = dw_personal.GetItemString(sRow, "gradecode")
		sAddDeptCode = dw_personal.GetItemString(sRow, "adddeptcode")
		
		rowcnt = dw_total.RowCount() + 1
	
		dw_total.insertrow(rowcnt)
		dw_total.setitem(rowcnt, "empname", sEmpName)
		dw_total.setitem(rowcnt, "empno",   sEmpNo)
		dw_total.setitem(rowcnt, "kmgubn",   sKmGbn)
		dw_total.setitem(rowcnt, "deptcode", sDeptCode)
		dw_total.setitem(rowcnt, "year_cnt", iYearCnt)
		dw_total.setitem(rowcnt, "enterdate",sEnterDate)
	
   	dw_total.setitem(rowcnt, "levelcode",sLevelCode)
		dw_total.setitem(rowcnt, "salary",sSalary)
		dw_total.setitem(rowcnt, "gradecode",sGradeCode)
		dw_total.setitem(rowcnt, "adddeptcode",sAddDeptCode)
	
		dw_personal.deleterow(sRow)
		gRow = sRow -1
	ELSE
		Exit
	END IF
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_cond.SetItem(1,"proc_pos",'P')
ELSE
	IF sProcDept ="%" THEN
		dw_cond.SetItem(1,"proc_pos",'T')
	ELSE
		dw_cond.SetItem(1,"proc_pos",'D')
	END IF
END IF
end event

type dw_total from u_d_select_sort within w_pik1113
integer x = 672
integer y = 388
integer width = 791
integer height = 1764
integer taborder = 40
string dataobject = "d_pik1113_2tot"
boolean hscrollbar = false
boolean border = false
boolean livescroll = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_personal from u_d_select_sort within w_pik1113
integer x = 1701
integer y = 388
integer width = 791
integer height = 1764
integer taborder = 30
string dataobject = "d_pik1113_2per"
boolean hscrollbar = false
boolean border = false
boolean livescroll = false
end type

event clicked;call super::clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_error from u_d_select_sort within w_pik1113
integer x = 2647
integer y = 388
integer width = 1189
integer height = 1764
integer taborder = 20
string dataobject = "d_pik1113_4"
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type st_2 from statictext within w_pik1113
integer x = 709
integer y = 332
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pik1113
integer x = 1742
integer y = 332
integer width = 160
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "개인"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pik1113
integer x = 2688
integer y = 332
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "오류자"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pik1113
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 576
integer y = 304
integer width = 3346
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1113
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 654
integer y = 356
integer width = 823
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pik1113
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1682
integer y = 356
integer width = 823
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pik1113
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2633
integer y = 356
integer width = 1207
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

