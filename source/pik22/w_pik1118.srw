$PBExportHeader$w_pik1118.srw
$PBExportComments$** 월차 생성
forward
global type w_pik1118 from w_inherite_multi
end type
type dw_cond from u_key_enter within w_pik1118
end type
type uo_progress from u_progress_bar within w_pik1118
end type
type dw_update from datawindow within w_pik1118
end type
type pb_1 from picturebutton within w_pik1118
end type
type pb_2 from picturebutton within w_pik1118
end type
type dw_total from u_d_select_sort within w_pik1118
end type
type dw_personal from u_d_select_sort within w_pik1118
end type
type dw_error from u_d_select_sort within w_pik1118
end type
type st_2 from statictext within w_pik1118
end type
type st_3 from statictext within w_pik1118
end type
type st_4 from statictext within w_pik1118
end type
type rr_1 from roundrectangle within w_pik1118
end type
type rr_3 from roundrectangle within w_pik1118
end type
type rr_4 from roundrectangle within w_pik1118
end type
type rr_5 from roundrectangle within w_pik1118
end type
end forward

global type w_pik1118 from w_inherite_multi
string title = "월차 일수 생성"
dw_cond dw_cond
uo_progress uo_progress
dw_update dw_update
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
global w_pik1118 w_pik1118

type variables
String               sProcDate ,sNextDate,sGetSysDept,sProcDept
DataWindow   dw_Process
Integer             il_RowCount, li_level
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_enabled_chk (string sempno, string senterdate)
public subroutine wf_create_error (string sempno, string sflag)
public subroutine wf_setsqlsyntax ()
public function string wf_proceduresql ()
public function double wf_calc_useday (string sempno, string sdate, string tdate)
end prototypes

public function integer wf_requiredchk (integer ll_row);

sProcDate= dw_cond.GetItemString(ll_row,"kdate")

IF sProcDate = "" OR IsNull(sProcDate) THEN
	MessageBox("확 인","처리년월은 필수입력입니다!!")
	dw_cond.SetColumn("kdate")
	dw_cond.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_enabled_chk (string sempno, string senterdate);Int il_Count
String sDate
Date   dDate

dDate = RelativeDate(Date(Left(sProcDate,4)+"."+Mid(sEnterDate,5,2)+"."+Right(sEnterDate,2)),-1)
sDate = String(dDate,'yyyymmdd')

SELECT COUNT("P4_DKENTAE"."EMPNO")
	INTO :il_Count  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KTCODE" <= :sDate )   ;
IF il_Count <=0 OR IsNull(il_Count) THEN
	Wf_Create_Error(sEmpNo,'KUNTAE')
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
ELSEIF	sflag = 'MUDAN' THEN
	dw_error.SetItem(il_CurRow,"errtext",'결근자료 있음')
ELSEIF	sflag = 'RETIRE' THEN
	dw_error.SetItem(il_CurRow,"errtext",'퇴사자')
ELSEIF	sflag = 'IMPSA' THEN
	dw_error.SetItem(il_CurRow,"errtext",'당월 입사자')	
	
END IF


end subroutine

public subroutine wf_setsqlsyntax ();
Int    k 
String sGetSqlSyntax,sEmpNo,sProcPos
Long   lSyntaxLength

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")

IF sProcPos = 'T' OR  sProcPos = 'D'  THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF right(sprocdate,2) = "12" THEN
	sNextdate = string(integer(left(sprocdate,4)) + 1) + "01"
ELSE
	sNextdate = left(sprocdate,4) + string(integer(right(sprocdate,2))+ 1, "00")
END IF	

dw_insert.DataObject ='d_pik1118_5'
dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

sGetSqlSyntax = dw_insert.GetSqlSelect()

sGetSqlSyntax = sGetSqlSyntax + "where ("

dw_Process.AcceptText()

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' "p4_monthlist"."empno" =' + "'"+ sEmpNo +"'"+ ' or'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

sGetSqlSyntax = sGetSqlSyntax + ' and ("p4_monthlist"."companycode" = ' + "'" + gs_company +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' and ("p4_monthlist"."yymm" = ' + "'" + sNextdate +"'"+")"

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

sGetSqlSyntax = 'select empno,deptcode,enterdate,retiredate from p1_master'

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

public function double wf_calc_useday (string sempno, string sdate, string tdate);/******************************************************************************************/
/***    2.1.2 사용일수 =  																						*/
/***              처리년월의 1일부터 말일까지의 월차사용일수                     			*/
/******************************************************************************************/

dec iCalcVal, iCalcVal1

SELECT count("P4_DKENTAE"."KTCODE")
  INTO :iCalcVal 
  FROM "P4_DKENTAE",  
       "P0_ATTENDANCE"     
 WHERE ("P4_DKENTAE"."KTCODE" ="P0_ATTENDANCE"."ATTENDANCECODE") and  
       (( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
       ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND  
       ( "P4_DKENTAE"."KDATE" >= :sdate ) AND  
       ( "P4_DKENTAE"."KDATE" <= :tdate ) AND  
       ( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '1' ) )   ;

IF SQLCA.SQLCODE = 0 THEN
	IF IsNull(iCalcVal) THEN iCalcVal = 0
ELSEIF SQLCA.SQLCODE = -1 THEN
	iCalcVal = 0
ELSEIF SQLCA.SQLCODE = 100 THEN
	iCalcVal = 0
END IF

SELECT count("P4_DKENTAE"."KTCODE")
  INTO :iCalcVal1 
  FROM "P4_DKENTAE",  
       "P0_ATTENDANCE"     
 WHERE ("P4_DKENTAE"."KTCODE" ="P0_ATTENDANCE"."ATTENDANCECODE") and  
       (( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
       ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND  
       ( "P4_DKENTAE"."KDATE" >= :sdate ) AND  
       ( "P4_DKENTAE"."KDATE" <= :tdate ) AND  
       ( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '5' ) )   ;

IF SQLCA.SQLCODE = 0 THEN
	IF IsNull(iCalcVal) THEN iCalcVal = 0
ELSEIF SQLCA.SQLCODE = -1 THEN
	iCalcVal = 0
ELSEIF SQLCA.SQLCODE = 100 THEN
	iCalcVal = 0
END IF

iCalcVal = iCalcVal + iCalcVal1 * 0.5

Return iCalcVal


end function

on w_pik1118.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.uo_progress=create uo_progress
this.dw_update=create dw_update
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
this.Control[iCurrent+3]=this.dw_update
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.dw_total
this.Control[iCurrent+7]=this.dw_personal
this.Control[iCurrent+8]=this.dw_error
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_3
this.Control[iCurrent+14]=this.rr_4
this.Control[iCurrent+15]=this.rr_5
end on

on w_pik1118.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.uo_progress)
destroy(this.dw_update)
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

event open;call super::open;string sDeptName, sabu

dw_total.SetTransObject(SQLCA)   
dw_personal.SetTransObject(SQLCA)        
dw_error.SetTransObject(SQLCA)        
dw_insert.SetTransObject(SQLCA)
dw_update.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

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

dw_cond.SetItem(1,"kdate",Left(gs_today,6))
dw_cond.SetColumn("kdate")
dw_cond.SetFocus()

pb_1.picturename = "C:\erpman\Image\next.gif"
pb_2.picturename ="C:\erpman\Image\prior.gif"


uo_progress.Hide()



end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1118
boolean visible = false
integer x = 4082
integer y = 3012
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1118
boolean visible = false
integer x = 3909
integer y = 3012
end type

type p_search from w_inherite_multi`p_search within w_pik1118
boolean visible = false
integer x = 3387
integer y = 3012
end type

type p_ins from w_inherite_multi`p_ins within w_pik1118
boolean visible = false
integer x = 3735
integer y = 3012
end type

type p_exit from w_inherite_multi`p_exit within w_pik1118
integer x = 4421
end type

type p_can from w_inherite_multi`p_can within w_pik1118
integer x = 4247
end type

event p_can::clicked;call super::clicked;uo_progress.Hide()

w_mdi_frame.sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

dw_cond.SetItem(1,"proc_pos",'T')
end event

type p_print from w_inherite_multi`p_print within w_pik1118
boolean visible = false
integer x = 3561
integer y = 3012
end type

type p_inq from w_inherite_multi`p_inq within w_pik1118
integer x = 3899
end type

event p_inq::clicked;String sProcPos, sdeptcode, sadddeptcode,sdept, sabu,agoym, sKunmu
Int    iYearCnt,iMonthCnt,k,il_RtvRow

dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

w_mdi_frame.sle_msg.text ='자료 조회 중......'
dw_total.SetRedraw(False)

sdept = dw_cond.getitemstring(1,"deptcode")
sProcPos = dw_cond.getitemstring(1,"proc_pos")
sKunmu = trim(dw_cond.GetitemString(1,'kunmu'))

IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

sabu = dw_cond.GetItemString(1,"sabu")
if IsNull(sabu) or sabu = '' then
	messagebox("확인","사업장을 확인하십시요!")
	dw_cond.setcolumn('sabu')
	dw_cond.setfocus()
	w_mdi_frame.sle_msg.text =''
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

agoym = f_aftermonth(sProcdate,-1)		
IF dw_total.Retrieve(agoym+'20', sdeptcode, sadddeptcode, sabu, sKunmu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_cond.SetFocus()
	w_mdi_frame.sle_msg.text =''
	Return
ELSE
	il_RtvRow = dw_total.RowCount()
	w_mdi_frame.sle_msg.text ='조회완료!'
END IF

dw_total.SetRedraw(True)
//w_mdi_frame.sle_msg.text =''

IF sProcPos = 'T' OR sProcPos = 'D' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF






end event

type p_del from w_inherite_multi`p_del within w_pik1118
boolean visible = false
integer x = 4256
integer y = 3012
end type

type p_mod from w_inherite_multi`p_mod within w_pik1118
integer x = 4073
end type

event p_mod::clicked;call super::clicked;/******************************************************************************************/
/*** 월차 마감 계산																								*/
/*** - 이전 자료를 삭제한 후 계산 한다.	 																*/
/*** 1. 처리년월을 입력받아서 처리   																		*/
/*** 2. 처리년월의 데이타																						*/
/*** 	  2.1 일수 계산																							*/
/***    	2.1.1 처리년월의 지급일수를 계산한다.(수당지급안함 : 지급일수 = 0)					*/	
/*** 	  2.2 사용일수 = 처리년월의 1일부터 말일까지의 월차사용일수 누적                    */
/*** 3. 처리년월+1 의 데이타																					*/
/*** 	  3.1 일수 계산																							*/
/***    3.1.1 이월일수 = 0																						*/
/***    3.2. 발생일수(당월에 만근시 익월에 생성) = 													*/
/***             근태코드의 근태구분이 '4'(무급근태)이고 일근태의 일자가 						*/
/***             (처리년월+ "01"  ~ 처리년월 + "말일") 인 근태일수의 합(A)						*/
/***         IF A = 0 THEN 발생일수 = 1																	*/
/***         ELSE 																								*/
/***            발생일수 = 0																					*/

/******************************************************************************************/

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRowInsert,il_RetrieveRowUpdate,il_CurRow,iYearCnt
String sProcPos,sEmpNo,sDeptCode,sEnterDate,sKmGbn,sRetireDate,agoym, sayymm,sdate,edate
string sMasterSql,sRtnValue
Int    iCurRow, kkk
double iyday, ibday, isday, ijday, icday, ikday ,iNoPayDay ,immpayday
double ayday, abday, asday, ajday, acday, akday
String sdata1, sdata2, sstartdate, senddate
dw_error.Reset() 

// 월마감작업후 월차마감계산 집계처리 못함
string ls_flag

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = :sprocdate ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	


dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")

IF sProcPos = 'T' OR sProcPos = 'D'  THEN										//전체,부서
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

wf_SetSqlSyntax()

 SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
   INTO :sdata2,      :sdata1  
   FROM "P0_REF"  
  WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
        ( "P0_REF"."CODE" = substr(:sprocdate,5,2) )   ;
		  
sStartDate = left(sprocdate,4)+ mid(sdata1,5,4)   

if mid(sprocdate,5,2) = '01' and left(sdata1,4) < mid(sdata1,10,4) then
	sStartdate = string(long(left(sStartdate,4)) - 1) + right(sStartdate,4)
end if

sEndDate   = left(sprocdate,4)+ mid(sdata1,14,4)

sayymm = f_aftermonth(sprocdate, -1)
SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
   INTO :sdata2,      :sdata1  
   FROM "P0_REF"  
  WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
        ( "P0_REF"."CODE" = substr(:sayymm,5,2) )   ;
		  
w_mdi_frame.sle_msg.text = '월차계산 중......'
SetPointer(HourGlass!)

sMasterSql = wf_ProcedureSql()

sRtnValue = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,sStartdate,sEndDate);
		  
IF Left(sRtnValue,2) <> 'OK' then
	MessageBox("확 인","월차계산 실패!!"+"["+sRtnValue+"]")
	Rollback;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
	Return
ELSE
	dw_error.Retrieve()
END IF

		  
//sdate = left(sdata2,8)  
//if mid(sdate,5,2) = '01' then
//	sdate = string(long(left(sdate,4)) - 1) + right(sdate,4)
//end if
//
//edate   = left(sprocdate,4)+ mid(sdata2,14,4)
//
//dw_insert.SetTransObject(SQLCA)
//dw_insert.Modify( "DataWindow.Table.UpdateTable = ~"P4_MONTHLIST~"")
//
//il_RetrieveRowUpdate = dw_update.Retrieve(gs_company,sprocdate)			//처리월의 월차건수 
//
//il_RetrieveRowInsert = dw_insert.Retrieve(gs_company,sprocdate) 			//다음월의 처리 건수
//
//w_mdi_frame.sle_msg.text = '월차 계산 중......'
//SetPointer(HourGlass!)
//
//
//uo_progress.Show()
//
////delete from "P4_TMP_CALCULATION" ;
////commit;
//
//dw_update.AcceptText()	
//FOR k = 1 TO il_RowCount
//	sEmpNo     = dw_Process.GetItemString(k,"empno")
//	sDeptCode  = dw_Process.GetItemString(k,"deptcode")
//	sEnterDate = dw_Process.GetItemString(k,"enterdate")
//	sRetireDate= dw_Process.GetItemString(k,"retiredate")						/*퇴사일자*/
//	IF IsNull(sRetireDate) OR sRetireDate = '' THEN
//		sRetireDate = '00000000'	
//	END IF
//	
//	il_meterPosition = (k/ il_RowCount) * 100
//	uo_progress.uf_set_position (il_meterPosition)		
//	
//
//	/* 발생일수를 계산*/	
//	SELECT Count("P4_DKENTAE"."KTCODE") /*일근태코드집계에 '무급근태' 유무 체크*/
//		INTO :iNoPayDay
//		FROM "P4_DKENTAE", "P0_ATTENDANCE"  
//		WHERE ( "P4_DKENTAE"."KTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
//				( ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
//				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
//				( "P4_DKENTAE"."KDATE" >= :sdate ) AND  
//   			( "P4_DKENTAE"."KDATE" <= :edate ) AND  
//				( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '4' ) )   ;
//				
//	IF SQLCA.SQLCODE <> 0 THEN
//		iNoPayDay =0
//	ELSE
//		IF IsNull(iNoPayDay) THEN iNoPayDay =0	
//	END IF
//	IF iNoPayDay = 0 THEN
//		IF sProcDate > Left(sEnterDate,6) THEN			/*당월이전 입사자*/
//			iMMPayDay = 1
//		ELSEIF Left(sEnterDate,6) = sProcDate AND Right(sEnterDate,2) = '01' THEN	/*당월입사 and 1일입사*/
//			iMMPayDay = 1
//		ELSE
//			wf_create_error(sEmpNo, 'IMPSA')
//			iMMPayDay =0
//		END IF
//	ELSE
//			wf_create_error(sEmpNo, 'MUDAN')
//		iMMPayDay =0
//	END IF
//	
//	IF Left(sProcDate,6) = Left(sRetireDate,6) AND Right(sRetireDate,2) <> right(f_last_date(sProcDate),2) THEN
//		/*당월 퇴사자이고 말일퇴사자가 아닌경우*/
//			wf_create_error(sEmpNo, 'RETIRE')
//		iMMPayDay = 0	
//	END IF
//	if iMMPayDay = 1 then ibday = 1
//	 
//	isDay  = wf_calc_useday(sEmpNo,sstartdate, senddate)							/*사용일수*/
//	sProcdate = left(senddate,6)
//	agoym = f_aftermonth(sProcdate,-1)	
//	
//	  SELECT "P4_MONTHLIST"."YDAY",   
//         "P4_MONTHLIST"."BDAY",   
//         "P4_MONTHLIST"."SDAY",   
//         "P4_MONTHLIST"."JDAY",   
//         "P4_MONTHLIST"."CDAY",   
//         "P4_MONTHLIST"."KDAY"  
//    INTO :ayday,   
//         :abday,   
//         :asday,   
//         :ajday,   
//         :acday,   
//         :akday  
//    FROM "P4_MONTHLIST"  
//   WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
//         ( "P4_MONTHLIST"."YYMM" = :agoym  ) AND  
//         ( "P4_MONTHLIST"."EMPNO" = :sEmpNo ) ;
//
//	
//	if sqlca.sqlcode <> 0 then
//		ayday = 0
//		abday = 0
//		asday = 0
//		ajday = 0
//		acday = 0
//		akday = 0
//	end if
//	
////	/* 처리년월의 사용일수,잔여일수,적치일수,지급일수를 계산*/	
//	IF il_RetrieveRowUpdate > 0 THEN
//		il_SearchRow = dw_update.Find("empno ='"+sEmpNo+"'",1,il_RetrieveRowUpdate)
//		IF il_SearchRow > 0 THEN	
////			iyday = dw_update.getitemnumber(il_SearchRow,"yday")  //이월일수
////			ibday = dw_update.getitemnumber(il_SearchRow,"bday")  //발생일수
//					
//			ijday = acday + ibday - isday 
//			ikday = 0
//			dw_update.SetItem(il_CurRow,"companycode",gs_company)
//	   	dw_update.SetItem(il_CurRow,"deptcode",   sDeptCode)
//		   dw_update.SetItem(il_CurRow,"empno",      sEmpNo)
//			dw_update.SetItem(il_CurRow,"yymm",       sProcDate)
//			dw_update.setitem(il_SearchRow,"yday",acday)  //이월일수
//			dw_update.setitem(il_SearchRow,"bday",ibday)
//			dw_update.setitem(il_SearchRow,"sday",isday)  //사용일수
//			dw_update.setitem(il_SearchRow,"jday",ibday - isday)  //잔여일수
//			dw_update.setitem(il_SearchRow,"cday",ijday)  //적치일수
//			dw_update.setitem(il_SearchRow,"kday",ijday)		 //지급일수
//		   KKK = 1
//		ELSE
//			IF isday <> 0 THEN
//				iCurRow = dw_update.InsertRow(0)
//				dw_update.SetItem(iCurRow,"companycode",gs_company)
//				dw_update.SetItem(iCurRow,"deptcode",   sDeptCode)
//				dw_update.SetItem(iCurRow,"empno",      sEmpNo)
//				dw_update.SetItem(iCurRow,"yymm",       sProcDate)
//				dw_update.SetItem(iCurRow,"bday",       0)
//				dw_update.SetItem(iCurRow,"cday",       ajday - isday)
//				dw_update.setitem(iCurRow,"sday",  isday)  //사용일수
//				dw_update.SetItem(iCurRow,"jday",       ibday - isday) //잔여일수
//	         KKK = 1
//			END IF
//			icday  = 0
//		END IF	
//	ELSE
//		IF isday <> 0 THEN
//			iCurRow = dw_update.InsertRow(0)
//			dw_update.SetItem(iCurRow,"companycode",gs_company)
//			dw_update.SetItem(iCurRow,"deptcode",   sDeptCode)
//			dw_update.SetItem(iCurRow,"yymm",       sProcDate)
//			dw_update.SetItem(iCurRow,"empno",      sEmpNo)
//			dw_update.SetItem(iCurRow,"yymm",       sProcDate)
//			dw_update.SetItem(iCurRow,"bday",       0)
//			dw_update.SetItem(iCurRow,"cday",       0)
//			dw_update.setitem(iCurRow,"sday",  isday)  //사용일수
//			dw_update.SetItem(iCurRow,"jday",       0 - isday) //잔여일수
//			icday  = 0
//		   KKK = 1
//		END IF
//	END IF
//
//	il_SearchRow = dw_insert.Find("empno ='"+sEmpNo+"' and yymm = '"+sprocdate+"'",1,dw_insert.RowCount())
//	IF il_SearchRow > 0 THEN
//		dw_insert.DeleteRow(il_SearchRow)	
//   END IF
//		IF KKK <> 1 THEN
//		IF sEnterDate <= sProcDate+'31' AND Left(sProcDate,6) <> Left(sRetireDate,6)  THEN			/*당월 퇴사자가 아니면*/
//			il_CurRow = dw_update.InsertRow(dw_update.RowCount() + 1)
//			
//			dw_update.SetItem(il_CurRow,"companycode",gs_company)
//			dw_update.SetItem(il_CurRow,"deptcode",   sDeptCode)
//			dw_update.SetItem(il_CurRow,"empno",      sEmpNo)
//			dw_update.SetItem(il_CurRow,"yymm",       sProcDate)
//			dw_update.SetItem(il_CurRow,"yday",       acday)
//			dw_update.SetItem(il_CurRow,"bday",       ibday)
//			dw_update.SetItem(il_CurRow,"jday",       ibday - isday )
//			dw_update.SetItem(il_CurRow,"sday",       isday)
//			dw_update.SetItem(il_CurRow,"cday",       acday + ibday - isday)
//		   dw_update.SetItem(il_CurRow,"kday",       acday + ibday - isday)
//    	END IF
//    END IF
//		
//	
//   kkk =0
//NEXT
//
//	IF dw_update.Update() <> 1  THEN
//		MessageBox("확 인","월차 저장 실패!!")
//		ROLLBACK;
//		Return
//	END IF
//
//COMMIT;
//
//uo_progress.Hide()
//
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ='월차 계산 완료!!'

end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1118
boolean visible = false
integer x = 3493
integer y = 2540
integer width = 919
integer height = 328
boolean titlebar = true
string title = "월차생성"
string dataobject = "d_pik1118_5"
end type

type st_window from w_inherite_multi`st_window within w_pik1118
boolean visible = false
integer y = 2900
end type

type cb_append from w_inherite_multi`cb_append within w_pik1118
boolean visible = false
integer x = 1966
integer y = 2568
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pik1118
boolean visible = false
integer x = 3163
integer y = 2660
integer taborder = 100
end type

type cb_update from w_inherite_multi`cb_update within w_pik1118
boolean visible = false
integer x = 2459
integer y = 2660
integer taborder = 80
end type

event cb_update::clicked;call super::clicked;/******************************************************************************************/
/*** 월차 마감 계산																								*/
/*** - 이전 자료를 삭제한 후 계산 한다.	 																*/
/*** 1. 처리년월을 입력받아서 처리   																		*/
/*** 2. 처리년월의 데이타																						*/
/*** 	  2.1 일수 계산																							*/
/***    	2.1.1 처리년월의 지급일수를 계산한다.(수당지급안함 : 지급일수 = 0)					*/	
/*** 	  2.2 사용일수 = 처리년월의 1일부터 말일까지의 월차사용일수 누적                    */
/*** 3. 처리년월+1 의 데이타																					*/
/*** 	  3.1 일수 계산																							*/
/***    3.1.1 이월일수 = 0																						*/
/***    3.2. 발생일수(당월에 만근시 익월에 생성) = 													*/
/***             근태코드의 근태구분이 '4'(무급근태)이고 일근태의 일자가 						*/
/***             (처리년월+ "01"  ~ 처리년월 + "말일") 인 근태일수의 합(A)						*/
/***         IF A = 0 THEN 발생일수 = 1																	*/
/***         ELSE 																								*/
/***            발생일수 = 0																					*/

/******************************************************************************************/

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRowInsert,il_RetrieveRowUpdate,il_CurRow,iYearCnt
String sProcPos,sEmpNo,sDeptCode,sEnterDate,sKmGbn,sRetireDate,agoym, sayymm,sdate,edate
string sMasterSql,sRtnValue
Int    iCurRow, kkk
double iyday, ibday, isday, ijday, icday, ikday ,iNoPayDay ,immpayday
double ayday, abday, asday, ajday, acday, akday
String sdata1, sdata2, sstartdate, senddate
dw_error.Reset() 

// 월마감작업후 월차마감계산 집계처리 못함
string ls_flag

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and myymm = :sprocdate ;
if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월 입니다.!!")
	return
end if	


dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")

IF sProcPos = 'T' OR sProcPos = 'D'  THEN										//전체,부서
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

wf_SetSqlSyntax()

 SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
   INTO :sdata2,      :sdata1  
   FROM "P0_REF"  
  WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
        ( "P0_REF"."CODE" = substr(:sprocdate,5,2) )   ;
		  
sStartDate = left(sdata2,8)  
if mid(sStartDate,5,2) = '01' then
	sStartdate = string(long(left(sStartdate,4)) - 1) + right(sStartdate,4)
end if

sEndDate   = left(sprocdate,4)+ mid(sdata2,14,4)

sayymm = f_aftermonth(sprocdate, -1)
SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
   INTO :sdata2,      :sdata1  
   FROM "P0_REF"  
  WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
        ( "P0_REF"."CODE" = substr(:sayymm,5,2) )   ;
		  
sle_msg.text = '월차계산 중......'
SetPointer(HourGlass!)

sMasterSql = wf_ProcedureSql()

sRtnValue = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,sStartdate,sEndDate);
		  
IF Left(sRtnValue,2) <> 'OK' then
	MessageBox("확 인","월차계산 실패!!"+"["+sRtnValue+"]")
	Rollback;
	SetPointer(Arrow!)
	sle_msg.text =''
	Return
ELSE
	dw_error.Retrieve()
END IF		  

		  
//sdate = left(sdata2,8)  
//if mid(sdate,5,2) = '01' then
//	sdate = string(long(left(sdate,4)) - 1) + right(sdate,4)
//end if
//
//edate   = left(sprocdate,4)+ mid(sdata2,14,4)
//
//dw_insert.SetTransObject(SQLCA)
//dw_insert.Modify( "DataWindow.Table.UpdateTable = ~"P4_MONTHLIST~"")
//
//il_RetrieveRowUpdate = dw_update.Retrieve(gs_company,sprocdate)			//처리월의 월차건수 
//
//il_RetrieveRowInsert = dw_insert.Retrieve(gs_company,sprocdate) 			//다음월의 처리 건수
//
//sle_msg.text = '월차 계산 중......'
//SetPointer(HourGlass!)
//
//
//uo_progress.Show()
//
////delete from "P4_TMP_CALCULATION" ;
////commit;
//
//dw_update.AcceptText()	
//FOR k = 1 TO il_RowCount
//	sEmpNo     = dw_Process.GetItemString(k,"empno")
//	sDeptCode  = dw_Process.GetItemString(k,"deptcode")
//	sEnterDate = dw_Process.GetItemString(k,"enterdate")
//	sRetireDate= dw_Process.GetItemString(k,"retiredate")						/*퇴사일자*/
//	IF IsNull(sRetireDate) OR sRetireDate = '' THEN
//		sRetireDate = '00000000'	
//	END IF
//	
//	il_meterPosition = (k/ il_RowCount) * 100
//	uo_progress.uf_set_position (il_meterPosition)		
//	
//
//	/* 발생일수를 계산*/	
//	SELECT Count("P4_DKENTAE"."KTCODE") /*일근태코드집계에 '무급근태' 유무 체크*/
//		INTO :iNoPayDay
//		FROM "P4_DKENTAE", "P0_ATTENDANCE"  
//		WHERE ( "P4_DKENTAE"."KTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
//				( ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
//				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
//				( "P4_DKENTAE"."KDATE" >= :sdate ) AND  
//   			( "P4_DKENTAE"."KDATE" <= :edate ) AND  
//				( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '4' ) )   ;
//				
//	IF SQLCA.SQLCODE <> 0 THEN
//		iNoPayDay =0
//	ELSE
//		IF IsNull(iNoPayDay) THEN iNoPayDay =0	
//	END IF
//	IF iNoPayDay = 0 THEN
//		IF sProcDate > Left(sEnterDate,6) THEN			/*당월이전 입사자*/
//			iMMPayDay = 1
//		ELSEIF Left(sEnterDate,6) = sProcDate AND Right(sEnterDate,2) = '01' THEN	/*당월입사 and 1일입사*/
//			iMMPayDay = 1
//		ELSE
//			wf_create_error(sEmpNo, 'IMPSA')
//			iMMPayDay =0
//		END IF
//	ELSE
//			wf_create_error(sEmpNo, 'MUDAN')
//		iMMPayDay =0
//	END IF
//	
//	IF Left(sProcDate,6) = Left(sRetireDate,6) AND Right(sRetireDate,2) <> right(f_last_date(sProcDate),2) THEN
//		/*당월 퇴사자이고 말일퇴사자가 아닌경우*/
//			wf_create_error(sEmpNo, 'RETIRE')
//		iMMPayDay = 0	
//	END IF
//	if iMMPayDay = 1 then ibday = 1
//	 
//	isDay  = wf_calc_useday(sEmpNo,sstartdate, senddate)							/*사용일수*/
//	sProcdate = left(senddate,6)
//	agoym = f_aftermonth(sProcdate,-1)	
//	
//	  SELECT "P4_MONTHLIST"."YDAY",   
//         "P4_MONTHLIST"."BDAY",   
//         "P4_MONTHLIST"."SDAY",   
//         "P4_MONTHLIST"."JDAY",   
//         "P4_MONTHLIST"."CDAY",   
//         "P4_MONTHLIST"."KDAY"  
//    INTO :ayday,   
//         :abday,   
//         :asday,   
//         :ajday,   
//         :acday,   
//         :akday  
//    FROM "P4_MONTHLIST"  
//   WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
//         ( "P4_MONTHLIST"."YYMM" = :agoym  ) AND  
//         ( "P4_MONTHLIST"."EMPNO" = :sEmpNo ) ;
//
//	
//	if sqlca.sqlcode <> 0 then
//		ayday = 0
//		abday = 0
//		asday = 0
//		ajday = 0
//		acday = 0
//		akday = 0
//	end if
//	
////	/* 처리년월의 사용일수,잔여일수,적치일수,지급일수를 계산*/	
//	IF il_RetrieveRowUpdate > 0 THEN
//		il_SearchRow = dw_update.Find("empno ='"+sEmpNo+"'",1,il_RetrieveRowUpdate)
//		IF il_SearchRow > 0 THEN	
////			iyday = dw_update.getitemnumber(il_SearchRow,"yday")  //이월일수
////			ibday = dw_update.getitemnumber(il_SearchRow,"bday")  //발생일수
//					
//			ijday = acday + ibday - isday 
//			ikday = 0
//			dw_update.SetItem(il_CurRow,"companycode",gs_company)
//	   	dw_update.SetItem(il_CurRow,"deptcode",   sDeptCode)
//		   dw_update.SetItem(il_CurRow,"empno",      sEmpNo)
//			dw_update.SetItem(il_CurRow,"yymm",       sProcDate)
//			dw_update.setitem(il_SearchRow,"yday",acday)  //이월일수
//			dw_update.setitem(il_SearchRow,"bday",ibday)
//			dw_update.setitem(il_SearchRow,"sday",isday)  //사용일수
//			dw_update.setitem(il_SearchRow,"jday",ibday - isday)  //잔여일수
//			dw_update.setitem(il_SearchRow,"cday",ijday)  //적치일수
//			dw_update.setitem(il_SearchRow,"kday",ijday)		 //지급일수
//		   KKK = 1
//		ELSE
//			IF isday <> 0 THEN
//				iCurRow = dw_update.InsertRow(0)
//				dw_update.SetItem(iCurRow,"companycode",gs_company)
//				dw_update.SetItem(iCurRow,"deptcode",   sDeptCode)
//				dw_update.SetItem(iCurRow,"empno",      sEmpNo)
//				dw_update.SetItem(iCurRow,"yymm",       sProcDate)
//				dw_update.SetItem(iCurRow,"bday",       0)
//				dw_update.SetItem(iCurRow,"cday",       ajday - isday)
//				dw_update.setitem(iCurRow,"sday",  isday)  //사용일수
//				dw_update.SetItem(iCurRow,"jday",       ibday - isday) //잔여일수
//	         KKK = 1
//			END IF
//			icday  = 0
//		END IF	
//	ELSE
//		IF isday <> 0 THEN
//			iCurRow = dw_update.InsertRow(0)
//			dw_update.SetItem(iCurRow,"companycode",gs_company)
//			dw_update.SetItem(iCurRow,"deptcode",   sDeptCode)
//			dw_update.SetItem(iCurRow,"yymm",       sProcDate)
//			dw_update.SetItem(iCurRow,"empno",      sEmpNo)
//			dw_update.SetItem(iCurRow,"yymm",       sProcDate)
//			dw_update.SetItem(iCurRow,"bday",       0)
//			dw_update.SetItem(iCurRow,"cday",       0)
//			dw_update.setitem(iCurRow,"sday",  isday)  //사용일수
//			dw_update.SetItem(iCurRow,"jday",       0 - isday) //잔여일수
//			icday  = 0
//		   KKK = 1
//		END IF
//	END IF
//
//	il_SearchRow = dw_insert.Find("empno ='"+sEmpNo+"' and yymm = '"+sprocdate+"'",1,dw_insert.RowCount())
//	IF il_SearchRow > 0 THEN
//		dw_insert.DeleteRow(il_SearchRow)	
//   END IF
//		IF KKK <> 1 THEN
//		IF sEnterDate <= sProcDate+'31' AND Left(sProcDate,6) <> Left(sRetireDate,6)  THEN			/*당월 퇴사자가 아니면*/
//			il_CurRow = dw_update.InsertRow(dw_update.RowCount() + 1)
//			
//			dw_update.SetItem(il_CurRow,"companycode",gs_company)
//			dw_update.SetItem(il_CurRow,"deptcode",   sDeptCode)
//			dw_update.SetItem(il_CurRow,"empno",      sEmpNo)
//			dw_update.SetItem(il_CurRow,"yymm",       sProcDate)
//			dw_update.SetItem(il_CurRow,"yday",       acday)
//			dw_update.SetItem(il_CurRow,"bday",       ibday)
//			dw_update.SetItem(il_CurRow,"jday",       ibday - isday )
//			dw_update.SetItem(il_CurRow,"sday",       isday)
//			dw_update.SetItem(il_CurRow,"cday",       acday + ibday - isday)
//		   dw_update.SetItem(il_CurRow,"kday",       acday + ibday - isday)
//    	END IF
//    END IF
//		
//	
//   kkk =0
//NEXT
//
//	IF dw_update.Update() <> 1  THEN
//		MessageBox("확 인","월차 저장 실패!!")
//		ROLLBACK;
//		Return
//	END IF
//
//COMMIT;
//
//uo_progress.Hide()
//
SetPointer(Arrow!)
sle_msg.text ='월차 계산 완료!!'

end event

type cb_insert from w_inherite_multi`cb_insert within w_pik1118
boolean visible = false
integer x = 2331
integer y = 2568
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1118
boolean visible = false
integer x = 2757
integer y = 2568
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1118
boolean visible = false
integer x = 2094
integer y = 2660
integer taborder = 50
end type

event cb_retrieve::clicked;call super::clicked;String sProcPos, sdeptcode, sadddeptcode,sdept, sabu,agoym
Int    iYearCnt,iMonthCnt,k,il_RtvRow

dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

sle_msg.text ='자료 조회 중......'
dw_total.SetRedraw(False)

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
agoym = f_aftermonth(sProcdate,-1)		
IF dw_total.Retrieve(agoym+'20', sdeptcode, sadddeptcode, sabu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_cond.SetFocus()
	sle_msg.text =''
	Return
ELSE
	il_RtvRow = dw_total.RowCount()
	sle_msg.text ='조회완료!'
END IF

dw_total.SetRedraw(True)
sle_msg.text =''

IF sProcPos = 'T' OR sProcPos = 'D' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF






end event

type st_1 from w_inherite_multi`st_1 within w_pik1118
boolean visible = false
integer y = 2900
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1118
boolean visible = false
integer x = 2798
integer y = 2660
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

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1118
boolean visible = false
integer y = 2900
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1118
boolean visible = false
integer y = 2900
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1118
boolean visible = false
integer x = 2025
integer y = 2600
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1118
boolean visible = false
integer x = 1554
integer y = 2508
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1118
boolean visible = false
integer y = 2848
end type

type dw_cond from u_key_enter within w_pik1118
event ue_key pbm_dwnkey
integer x = 585
integer y = 28
integer width = 2501
integer height = 288
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik1118_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;
Return 1
end event

event itemchanged;
String snull,sDeptName,sDeptCode

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "kdate" THEN
	sProcDate = Trim(this.GetText())
	
	IF sProcDate = "" OR IsNull(sProcDate) THEN RETURN
	
	IF f_datechk(sProcDate+'01') = -1 THEN
		MessageBox("확 인","유효한 날짜가 아닙니다!!")
		dw_cond.SetItem(1,"kdate",snull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"p0_dept_deptname2",snull)
		sProcDept = '%'
		Return
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
	sProcDept = dw_cond.getitemstring(1,"deptcode")
	IF sProcDept =""  OR  isnull(sProcDept) THEN
		dw_cond.SetItem(1,"proc_pos",'T')

	ELSE
		dw_cond.SetItem(1,"proc_pos",'D')
	END IF
END IF

end event

type uo_progress from u_progress_bar within w_pik1118
integer x = 2853
integer y = 2224
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_update from datawindow within w_pik1118
boolean visible = false
integer x = 101
integer y = 2496
integer width = 1851
integer height = 336
boolean bringtotop = true
boolean titlebar = true
string title = "월차내역"
string dataobject = "d_pik1118_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type pb_1 from picturebutton within w_pik1118
integer x = 1531
integer y = 644
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

event clicked;String sEmpNo,sEmpName,sKmGbn,sEnterDate,sDeptCode
Long rowcnt , totRow , sRow ,gRow
int i

totRow =dw_total.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_total.getselectedrow(gRow)
	IF sRow > 0 THEN
		sEmpNo   = dw_total.GetItemString(sRow, "empno")
   	sEmpName = dw_total.GetItemString(sRow, "empname")
		sKmGbn   = dw_total.GetItemString(sRow, "kmgubn")
		sEnterDate = dw_total.GetItemString(sRow, "enterDate")
		sDeptCode  = dw_total.GetItemString(sRow,"deptcode")

		rowcnt = dw_personal.RowCount() + 1
		
		dw_personal.insertrow(rowcnt)
      dw_personal.setitem(rowcnt, "empname",  sEmpName)
		dw_personal.setitem(rowcnt, "empno",    sEmpNo)
		dw_personal.setitem(rowcnt, "kmgubn",   sKmGbn)
		dw_personal.setitem(rowcnt, "enterdate",sEnterDate)
		dw_personal.setitem(rowcnt, "deptcode",sDeptCode)
		
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

type pb_2 from picturebutton within w_pik1118
integer x = 1531
integer y = 776
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

event clicked;String sEmpNo,sEmpName,sKmGbn,sEnterDate
Long rowcnt , totRow , sRow ,gRow
int i

totRow =dw_personal.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_personal.getselectedrow(gRow)
	IF sRow > 0 THEN
		sEmpNo   = dw_personal.GetItemString(sRow, "empno")
   	sEmpName = dw_personal.GetItemString(sRow, "empname")
		sKmGbn   = dw_personal.GetItemString(sRow, "kmgubn")
		sEnterDate = dw_personal.GetItemString(sRow, "enterDate")

		rowcnt = dw_total.RowCount() + 1
		
		dw_total.insertrow(rowcnt)
      dw_total.setitem(rowcnt, "empname",  sEmpName)
		dw_total.setitem(rowcnt, "empno",    sEmpNo)
		dw_total.setitem(rowcnt, "kmgubn",   sKmGbn)
		dw_total.setitem(rowcnt, "enterdate",sEnterDate)
	
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

type dw_total from u_d_select_sort within w_pik1118
integer x = 667
integer y = 412
integer width = 791
integer height = 1764
integer taborder = 40
string dataobject = "d_pik1118_2"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_personal from u_d_select_sort within w_pik1118
integer x = 1701
integer y = 412
integer width = 791
integer height = 1764
integer taborder = 30
string dataobject = "d_pik1118_2"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_error from u_d_select_sort within w_pik1118
integer x = 2647
integer y = 412
integer width = 1184
integer height = 1764
integer taborder = 20
string dataobject = "d_pik1118_3"
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type st_2 from statictext within w_pik1118
integer x = 709
integer y = 360
integer width = 137
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
boolean focusrectangle = false
end type

type st_3 from statictext within w_pik1118
integer x = 1728
integer y = 360
integer width = 155
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
boolean focusrectangle = false
end type

type st_4 from statictext within w_pik1118
integer x = 2674
integer y = 360
integer width = 224
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
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pik1118
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 594
integer y = 332
integer width = 3310
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1118
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 654
integer y = 380
integer width = 823
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pik1118
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1682
integer y = 380
integer width = 823
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pik1118
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2633
integer y = 380
integer width = 1207
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type

