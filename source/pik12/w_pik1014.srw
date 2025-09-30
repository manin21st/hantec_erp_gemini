$PBExportHeader$w_pik1014.srw
$PBExportComments$** 월근태 집계
forward
global type w_pik1014 from w_inherite_multi
end type
type gb_7 from groupbox within w_pik1014
end type
type dw_cond from u_key_enter within w_pik1014
end type
type uo_progress from u_progress_bar within w_pik1014
end type
type dw_insert_mkt from datawindow within w_pik1014
end type
type cbx_1 from checkbox within w_pik1014
end type
type cbx_2 from checkbox within w_pik1014
end type
type dw_insert_mkd from datawindow within w_pik1014
end type
type dw_error from u_d_select_sort within w_pik1014
end type
type dw_personal from u_d_select_sort within w_pik1014
end type
type dw_total from u_d_select_sort within w_pik1014
end type
type p_5 from picture within w_pik1014
end type
type p_4 from picture within w_pik1014
end type
type st_2 from statictext within w_pik1014
end type
type st_3 from statictext within w_pik1014
end type
type st_4 from statictext within w_pik1014
end type
type pb_1 from picturebutton within w_pik1014
end type
type pb_2 from picturebutton within w_pik1014
end type
type rr_2 from roundrectangle within w_pik1014
end type
type rr_3 from roundrectangle within w_pik1014
end type
type rr_4 from roundrectangle within w_pik1014
end type
type rr_5 from roundrectangle within w_pik1014
end type
end forward

global type w_pik1014 from w_inherite_multi
integer height = 2548
string title = "월근태 집계"
gb_7 gb_7
dw_cond dw_cond
uo_progress uo_progress
dw_insert_mkt dw_insert_mkt
cbx_1 cbx_1
cbx_2 cbx_2
dw_insert_mkd dw_insert_mkd
dw_error dw_error
dw_personal dw_personal
dw_total dw_total
p_5 p_5
p_4 p_4
st_2 st_2
st_3 st_3
st_4 st_4
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
end type
global w_pik1014 w_pik1014

type variables
String               sProcDate,sProcDept, sStartDate, sEndDate,&
                         sfromDate, stoDate
DataWindow   dw_Process
Integer             il_RowCount

end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function double wf_conv_hhmm (double dtime)
public function integer wf_create_mkt ()
public subroutine wf_create_error (string sempno, string sflag)
public subroutine wf_setsqlsyntax ()
public function integer wf_enabled_chk (string sempno, string sflag)
public subroutine wf_get_mkunday (string sempno, ref integer immuseday, ref integer imyuseday, ref integer imsuseday)
public subroutine wf_get_dkentae (integer ll_row, string sempno, ref integer ijtcnt, ref integer ijkcnt, ref integer ioccnt, ref double djktime, ref double djttime, ref double docsiltime, ref double dkltime, ref double dyjtime, ref double dyktime, ref double dhyjtime, ref double dhcytime, ref double dhkltime, ref double djhtime, ref integer imchday, ref double dyhtime, ref double dhkltime2, ref double dhkltime3)
public function integer wf_create_mkd ()
public subroutine wf_calc_day (integer ll_row, string sempno, ref integer immpayday, ref integer imspayday, ref integer imwpayday, ref integer imjanday, ref integer iyjanday)
public function string wf_proceduresql (string flag, string gubn)
public subroutine wf_reset ()
public function integer w_hujikday (string sktcode, string sempno, integer prow)
end prototypes

public function integer wf_requiredchk (integer ll_row);String sProcGbn,sProcPos

sProcDate= dw_cond.GetItemString(ll_row,"kdate")

IF sProcDate = "" OR IsNull(sProcDate) THEN
	MessageBox("확 인","처리년월은 필수입력입니다!!")
	dw_cond.SetColumn("kdate")
	dw_cond.SetFocus()
	Return -1
END IF

sStartDate= dw_cond.GetItemString(ll_row,"start_ymd")
sEndDate= dw_cond.GetItemString(ll_row,"end_ymd")

IF sStartDate = "" OR IsNull(sStartDate)  OR &
	sEndDate = "" OR IsNull(sEndDate)  THEN
	MessageBox("확 인","관리직 처리기간은 필수입력입니다!!")
	dw_cond.SetColumn("start_date")
	dw_cond.SetFocus()
	Return -1
END IF

sfromDate= dw_cond.GetItemString(ll_row,"from_ymd")
stoDate= dw_cond.GetItemString(ll_row,"to_ymd")

IF sfromDate = "" OR IsNull(sfromDate)  OR &
	stoDate = "" OR IsNull(stoDate)  THEN
	MessageBox("확 인","기능직 처리기간은 필수입력입니다!!")
	dw_cond.SetColumn("sfrom_date")
	dw_cond.SetFocus()
	Return -1
END IF
Return 1
end function

public function double wf_conv_hhmm (double dtime);/*분이 60을 넘을 경우 시간에 add 처리*/

Int iMM
//Int iHH,iMM
//
//iHH = Integer(Left(String(dTime,'00.00'),2))								/*시간*/
//iMM = Integer(Mid(String(dTime,'00.00'),4,2))								/*분*/
//	
//IF iMM >= 60 THEN
//	iMM = iMM - 60
//	iHH = iHH + 1
//	dTime = Round(((iHH * 100) + iMM)/100,2) 
//END IF

iMM   = Mod(dTime,60)
dTime = Truncate(dTime / 60,0)

dTime = (dTime + (iMM / 100))

Return dTime
	
end function

public function integer wf_create_mkt ();/*****************************************************************************************/
/*** 월근태를 집계한다.(선택한 자료의 일근태자료를 읽어서 월근태를 계산한다.)				  */
/***   - 이전 자료를 삭제한 후 다시 생성한다.														  */
/***   - 월근태코드내역(p4_mkuntaeday)이 없으면 먼저 처리한 후 작업한다.					  */
/*** 1. 월근태 내역을 계산 한다.(일근태기준,60분으로 계산)예)2.3 => 2시간 30분			  */
/***   - 지각시간 : 일근태의 지각시간을 누적한다.													  */
/***   - 근로시간 : 일근태의 근로시간을 누적한다.													  */
/***   - 연장시간(150%) : 일근태의 연장시간을 누적한다.											  */
/***   - 특근연장(200%) : 일근태의 휴일연장시간을 누적한다.										  */
/***   - 특근철야(250%) : 일근태의 휴일철야시간을 누적한다.										  */
/***   - 휴일근로 : 일근태의 휴일근로시간을 누적한다.												  */
/***   - 평일야간 : 일근태의 야간시간을 누적한다.													  */
/*****************************************************************************************/

Int      il_meterPosition,k,il_CurRow,il_retrieveRow,il_SearchRow
String   sEmpNo,sDeptCode,sPrtDept
Double   dMJkTime,			&
			dMJtTime,			&
			dMOcSilTime,		&
			dMKlTime,			&
			dMYjTime,			&
			dMJhTime,			&
			dMHYjTime,			&
			dMHCyTime,			&
			dMHKlTime,			&
			dMYkTime,			&
			dMYhTime,			&
			dMHKlTime2,			&
			dMHKlTime3			/*지각,조퇴,외출,근로,연장,휴일연장,휴일철야,휴일근로,평일야간,유급휴무일(시간)*/
Int      iJtCnt,	   iJkCnt,		iOcCnt					/*조퇴횟수,지각,외출*/
Int      iMMUseDay,  iMYUseDay,  iMSUseDay, iMChDay	/*월차사용,년차,생리,출근일수*/
Int      iMMPayDay,	iMSPayDay,	iMWPayDay				/*월차지급,생리,주차*/
Int      iMJanDay,   iYJanDay									/*잔여월차,잔여년차*/

sle_msg.text = '월근태 집계 중......'

wf_SetSqlSyntax()

dw_insert_mkt.SetTransObject(SQLCA)
dw_insert_mkt.Modify( "DataWindow.Table.UpdateTable = ~"P4_MKUNTAETIME~"")

il_RetrieveRow = dw_insert_mkt.Retrieve() 											/*이전 처리 건수*/

SetPointer(HourGlass!)

uo_progress.Show()

FOR k = 1 TO il_RowCount
	
	sEmpNo    = dw_Process.GetItemString(k,"empno")
		
	il_meterPosition = (k/ il_RowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)		
		
	IF il_RetrieveRow > 0 THEN
		il_SearchRow = dw_insert_mkt.Find("companycode = '"+gs_company+"' and empno ='"+sEmpNo+"'",1,il_RetrieveRow)
		IF il_SearchRow > 0 THEN
			dw_insert_mkt.DeleteRow(il_SearchRow)	
		END IF
	END IF
	
	IF wf_enabled_chk(sEmpNo,'MKT') = -1 THEN CONTINUE

	/*소속부서,출력부서 구하기*/
		SELECT "P4_DKENTAE"."DEPTCODE",   "P4_DKENTAE"."PRTDEPT"  
			INTO :sDeptCode,   				 :sPrtDept  
		   FROM "P4_DKENTAE"  
   		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         		( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         		( "P4_DKENTAE"."KDATE" = (SELECT MAX("KDATE")
															FROM "P4_DKENTAE"
															WHERE "P4_DKENTAE"."COMPANYCODE" = :gs_company AND
																	"P4_DKENTAE"."EMPNO" = :sEmpNo  AND
																	"P4_DKENTAE"."KDATE" >= :sStartDate AND
																	"P4_DKENTAE"."KDATE" <= :sEndDate) )   ;

	Wf_Get_dKentae(k,sEmpNo,iJtCnt,iJkCnt,iOcCnt,dMJkTime,dMJtTime,dMOcSilTime,dMKlTime,dMYjTime,dMYkTime,dMHYjTime,dMHCyTime,dMHKlTime,dMJhTime,iMChDay,dMYhTime,dMHKlTime2,dMHKlTime3)
	Wf_Get_MKunDay(sEmpNo,iMMUseDay,iMYUseDay,iMSUseDay)
	Wf_Calc_Day(k,sEmpNo,iMMPayDay,iMSPayDay,iMWPayDay,iMJanDay, iYJanDay)
	
	il_CurRow = dw_insert_mkt.InsertRow(0)
		
	dw_insert_mkt.SetItem(il_CurRow,"companycode",gs_company)
	dw_insert_mkt.SetItem(il_CurRow,"deptcode",   sDeptCode)
	dw_insert_mkt.SetItem(il_CurRow,"empno",      sEmpNo)
	dw_insert_mkt.SetItem(il_CurRow,"myymm",      sProcDate)
	
	dw_insert_mkt.SetItem(il_CurRow,"mjkcnt",       iJkCnt)					/*지각횟수*/
	dw_insert_mkt.SetItem(il_CurRow,"mjkgtime",     dMJkTime)				/*지각시간*/
	dw_insert_mkt.SetItem(il_CurRow,"mjtcnt",       iJtCnt)					/*조퇴횟수*/
	dw_insert_mkt.SetItem(il_CurRow,"mjtgktime",    dMJtTime)				/*조퇴시간*/
	dw_insert_mkt.SetItem(il_CurRow,"moccnt",       iOcCnt)					/*외출횟수*/
	dw_insert_mkt.SetItem(il_CurRow,"mocggtime",    dMOcSilTime)			/*외출시간*/
	dw_insert_mkt.SetItem(il_CurRow,"mklgtime",     dMKlTime)				/*근로*/
	dw_insert_mkt.SetItem(il_CurRow,"mjhtime",      dMJhTime)				/*등교시간*/
	dw_insert_mkt.SetItem(il_CurRow,"myjgtime150",  dMYjTime)				/*연장*/
	dw_insert_mkt.SetItem(il_CurRow,"mhkyjgtime200",dMHYjTime)				/*휴일연장*/
	dw_insert_mkt.SetItem(il_CurRow,"mkcygtime250", dMHCyTime)				/*휴일철야*/
	dw_insert_mkt.SetItem(il_CurRow,"mhkgtime1",    dMHKlTime)				/*휴일근로*/
	dw_insert_mkt.SetItem(il_CurRow,"mhkgtime2",    dMHKlTime2)				/*무휴근로*/
	dw_insert_mkt.SetItem(il_CurRow,"mhkgtime3",    dMHKlTime3)				/*공휴근로*/
	dw_insert_mkt.SetItem(il_CurRow,"mykgtimeg",    dMYkTime)				/*평일야간*/
	
	dw_insert_mkt.SetItem(il_CurRow,"mwchdayu",    iMMUseDay)				/*월차사용*/
	dw_insert_mkt.SetItem(il_CurRow,"mychdayu",    iMYUseDay)				/*년차사용*/
	dw_insert_mkt.SetItem(il_CurRow,"msridayu",    iMSUseDay)				/*생리사용*/
	
	dw_insert_mkt.SetItem(il_CurRow,"mwchday",     iMMPayDay)				/*월차지급*/
	dw_insert_mkt.SetItem(il_CurRow,"mychday",     0)							/*년차지급*/
	dw_insert_mkt.SetItem(il_CurRow,"msriday",     iMSPayDay)				/*생리지급*/
	dw_insert_mkt.SetItem(il_CurRow,"mchday",      iMChDay)					/*실출근일수*/
	
	dw_insert_mkt.SetItem(il_CurRow,"mjuhuday",    iMWPayDay)				/*주휴일수*/
	dw_insert_mkt.SetItem(il_CurRow,"myhtime",     dMYhTime)					/*유급휴일일수(시간)*/
	
	dw_insert_mkt.SetItem(il_CurRow,"mjanmthday",  iMJanDay)					/*잔여월차*/
	dw_insert_mkt.SetItem(il_CurRow,"mjanyearday", iYJanDay)					/*잔여년차*/
	dw_insert_mkt.SetItem(il_CurRow,"prtdept",     sPrtDept)
NEXT

IF dw_insert_mkt.Update() <> 1 THEN
	MessageBox("확 인","월근태 저장 실패!!")
	ROLLBACK;
	Return -1
END IF

COMMIT;

uo_progress.Hide()

SetPointer(Arrow!)
sle_msg.text ='월근태 집계 완료!!'

Return 1
end function

public subroutine wf_create_error (string sempno, string sflag);Int    il_CurRow,il_SearchRow
String sEmpName

il_SearchRow = dw_error.Find("empno ='"+sEmpNo+"'",1,dw_error.RowCount())

IF il_SearchRow > 0 THEN Return
	
il_CurRow = dw_error.InsertRow(0)
dw_error.SetItem(il_CurRow,"empno",sempno)

SELECT "P1_MASTER"."EMPNAME"  
	INTO :sEmpName  
   FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."EMPNO" = :sEmpno ) AND  
         ( "P1_MASTER"."COMPANYCODE" = :gs_company )   ;

dw_error.SetItem(il_CurRow,"empname",sEmpName)

IF sflag ='KUNTAE' THEN
	dw_error.SetItem(il_CurRow,"errtext",'일근태자료 없슴')
ELSEIF sflag = 'MGYL' THEN
	dw_error.SetItem(il_CurRow,"errtext",'미결자료 있슴')
END IF
end subroutine

public subroutine wf_setsqlsyntax ();
Int    k 
String sGetSqlSyntax,sEmpNo,sProcPos
Long   lSyntaxLength

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")

IF sProcPos = 'T' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

dw_insert_mkt.DataObject ='d_pik10144'
dw_insert_mkt.SetTransObject(SQLCA)
dw_insert_mkt.Reset()
	
sGetSqlSyntax = dw_insert_mkt.GetSqlSelect()
	
sGetSqlSyntax = sGetSqlSyntax + "WHERE ("
	
dw_Process.AcceptText()
	
FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' "P4_MKUNTAETIME"."EMPNO" =' + "'"+ sEmpNo +"'"+ ' OR'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"
	
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_MKUNTAETIME"."COMPANYCODE" = ' + "'" + gs_company +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_MKUNTAETIME"."MYYMM" = ' + "'" + sprocdate +"'"+")"

dw_insert_mkt.SetSQLSelect(sGetSqlSyntax)	



end subroutine

public function integer wf_enabled_chk (string sempno, string sflag);/************************************************************************************/
/* 처리할 자료 중 일근태가 없는 자료 체크															*/
/************************************************************************************/

Int il_Count =0,il_Mgyl_Cnt = 0

IF sflag ='MKD' THEN												/*월근태코드내역*/
	SELECT COUNT("P4_DKENTAE"."DEPTCODE")
		INTO :il_Mgyl_Cnt
   	FROM "P4_DKENTAE"  
  		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
        		( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
	         ( SUBSTR("P4_DKENTAE"."KDATE",1,6) = :sProcDate ) AND
				(("P4_DKENTAE"."KTCODE" IS NOT NULL) AND
				("P4_DKENTAE"."KTCODE" <> ' ')) AND
				("P4_DKENTAE"."KJGUBN1" = 'N') ;
	IF il_Mgyl_Cnt > 0 AND Not IsNull(il_Mgyl_Cnt) THEN				/*미결자료 ERROR*/
		wf_create_error(sEmpNo,'MGYL')
	END IF			
	
ELSEIF sflag = 'MKT' THEN										/*월근태*/
	SELECT COUNT("P4_DKENTAE"."EMPNO")  
		INTO :il_Count  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
				( SUBSTR("P4_DKENTAE"."KDATE",1,6) = :sProcDate )   ;
	IF il_Count <=0 OR IsNull(il_Count) THEN							/*일근태 자료 없으면 ERROR*/
		wf_create_error(sEmpNo,'KUNTAE')
		Return -1
	END IF
		
	SELECT COUNT("P4_DKENTAE"."EMPNO")  								/*미결자료 있으면*/
		INTO :il_Mgyl_Cnt
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
				( SUBSTR("P4_DKENTAE"."KDATE",1,6) = :sProcDate ) AND
				( "P4_DKENTAE"."KJGUBN2" = 'N') ;
	IF il_Mgyl_Cnt > 0 AND Not IsNull(il_Mgyl_Cnt) THEN				/*미결자료 ERROR*/
		wf_create_error(sEmpNo,'MGYL')
	END IF			
END IF

Return 1
end function

public subroutine wf_get_mkunday (string sempno, ref integer immuseday, ref integer imyuseday, ref integer imsuseday);

/*월차사용일수*/
SELECT SUM(NVL("P4_MKUNTAEDAY"."MDAY",0))  
	INTO :iMMUseDay  
   FROM "P4_MKUNTAEDAY",   "P0_ATTENDANCE"  
   WHERE ( "P4_MKUNTAEDAY"."MKTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
         ( ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MKUNTAEDAY"."EMPNO" = :sEmpNo ) AND  
         ( "P4_MKUNTAEDAY"."MYYMM" = :sProcDate ) AND  
         ( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '1' ) )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMMUseDay =0
ELSE
	IF IsNull(iMMUseDay) THEN iMMUseDay =0
END IF

/*년차사용일수*/
SELECT SUM(NVL("P4_MKUNTAEDAY"."MDAY",0))  
	INTO :iMYUseDay  
   FROM "P4_MKUNTAEDAY",   "P0_ATTENDANCE"  
   WHERE ( "P4_MKUNTAEDAY"."MKTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
         ( ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MKUNTAEDAY"."EMPNO" = :sEmpNo ) AND  
         ( "P4_MKUNTAEDAY"."MYYMM" = :sProcDate ) AND  
         ( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '2' ) )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMYUseDay =0
ELSE
	IF IsNull(iMYUseDay) THEN iMYUseDay =0
END IF

/*생리사용일수*/
SELECT SUM(NVL("P4_MKUNTAEDAY"."MDAY",0))  
	INTO :iMSUseDay  
   FROM "P4_MKUNTAEDAY",   "P0_ATTENDANCE"  
   WHERE ( "P4_MKUNTAEDAY"."MKTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
         ( ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MKUNTAEDAY"."EMPNO" = :sEmpNo ) AND  
         ( "P4_MKUNTAEDAY"."MYYMM" = :sProcDate ) AND  
         ( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '3' ) )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMSUseDay =0
ELSE
	IF IsNull(iMSUseDay) THEN iMSUseDay =0
END IF



end subroutine

public subroutine wf_get_dkentae (integer ll_row, string sempno, ref integer ijtcnt, ref integer ijkcnt, ref integer ioccnt, ref double djktime, ref double djttime, ref double docsiltime, ref double dkltime, ref double dyjtime, ref double dyktime, ref double dhyjtime, ref double dhcytime, ref double dhkltime, ref double djhtime, ref integer imchday, ref double dyhtime, ref double dhkltime2, ref double dhkltime3);String sJikJongGbn,sEnterDate,sOutDate,sJtGbn,sJhGbn,sJhtGbn,sSilOutDate,ssatdate
Double dDkgTime

sJikJongGbn = dw_Process.GetItemString(ll_row,"jikjonggubn")
sEnterDate  = dw_Process.GetItemString(ll_row,"enterdate")
sOutDate    = dw_Process.GetItemString(ll_row,"retiredate")
sJhGbn      = dw_Process.GetItemString(ll_row,"jhgubn")
sJhtGbn     = dw_Process.GetItemString(ll_row,"jhtgubn")

IF sOutDate = "" OR IsNull(sOutDate) THEN
	sSilOutDate = '99999999'
ELSE
	sSilOutDate = sOutDate
END IF
SELECT "P1_MASTER"."SERVICEKINDCODE"											/*재직구분*/
	INTO :sJtGbn  
   FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_MASTER"."EMPNO" = :sEmpNo )   ;
			
/*지각관련*/
 SELECT COUNT("P4_DKENTAE"."JKGUBN"),   
 		  SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."JKGTIME",0),'00.00'),1,3)) * 60 +
		  TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."JKGTIME",0),'00.00'),5,2)))
 	INTO :ijkcnt,								 :djktime
	FROM "P4_DKENTAE"
	WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			("P4_DKENTAE"."JKGUBN" = '1') AND
			("P4_DKENTAE"."KJGUBN2" = 'Y') ;
IF SQLCA.SQLCODE <> 0 THEN
	iJkCnt =0
	dJkTime =0
ELSE
	IF IsNull(iJkCnt) THEN iJkCnt =0
	IF IsNull(dJkTime) THEN 
		dJkTime =0
	ELSE
		dJkTime = Wf_Conv_HhMm(dJkTime)
	END IF
END IF

/*외출관련*/
SELECT COUNT("P4_DKENTAE"."OCCNT"),   
		 SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."OCGGTIME",0),'00.00'),1,3)) * 60 +
		  TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."OCGGTIME",0),'00.00'),5,2)))
	INTO :iOcCnt,							  :dOcSilTime
	FROM "P4_DKENTAE"
	WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			( "P4_DKENTAE"."OCCNT" <> 0) AND
			("P4_DKENTAE"."KJGUBN2" = 'Y');
IF SQLCA.SQLCODE <> 0 THEN
	iOcCnt =0
	dOcSilTime =0
ELSE
	IF IsNull(iOcCnt) THEN iOcCnt =0
	IF IsNull(dOcSilTime) THEN 
		dOcSilTime =0
	ELSE
		dOcSilTime = Wf_Conv_HhMm(dOcSilTime)
	END IF
END IF

/*조퇴관련*/
SELECT	COUNT("P4_DKENTAE"."JTGUBN"),   
			SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."JTGKTIME",0),'00.00'),1,3)) * 60 +
		  TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."JTGKTIME",0),'00.00'),5,2)))
	INTO  :iJtCnt,						 		  :dJtTime
	FROM "P4_DKENTAE"
	WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			( "P4_DKENTAE"."JTGUBN" = '1') AND
			("P4_DKENTAE"."KJGUBN2" = 'Y') ;
IF SQLCA.SQLCODE <> 0 THEN
	iJtCnt =0
	dJtTime =0
ELSE
	IF IsNull(iJtCnt) THEN iJtCnt =0
	IF IsNull(dJtTime) THEN 
		dJtTime =0
	ELSE
		dJtTime = Wf_Conv_HhMm(dJtTime)
	END IF
END IF

/*휴일근로,무휴근로,공휴근로*/
IF sJikJongGbn = '1' THEN									/*관리직 계산 않함*/
	dHKlTime  = 0
	dHKlTime2 = 0
	dHKlTime3 = 0						
ELSE
	SELECT  SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME",0),'00.00'),1,3)) * 60 +
			  TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME",0),'00.00'),5,2))),   
			  SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME2",0),'00.00'),1,3)) * 60 +
			  TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME2",0),'00.00'),5,2))),   
			  SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME3",0),'00.00'),1,3)) * 60 +
			  TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME3",0),'00.00'),5,2)))
	INTO :dHKlTime,						:dHKlTime2,						:dHKlTime3						
	FROM "P4_DKENTAE"  
	WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
			( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
			( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			("P4_DKENTAE"."KJGUBN2" = 'Y')  ;		
	IF SQLCA.SQLCODE <> 0 THEN
		dHKlTime  = 0
		dHKlTime2 = 0
		dHKlTime3 = 0						
	ELSE
		IF IsNull(dHKlTime) THEN	dHKlTime = 0
		IF IsNull(dHKlTime2) THEN	dHKlTime2 = 0
		IF IsNull(dHKlTime3) THEN	dHKlTime3 = 0

		/*휴일구분별 휴일 계산 추가해야함.99.03.31*/
		dHKlTime  = Wf_Conv_HhMm(dHKlTime)								/*휴일근로*/
		dHKlTime2 = Wf_Conv_HhMm(dHKlTime2)								/*무휴근로*/
		dHKlTime3 = Wf_Conv_HhMm(dHKlTime3)								/*공휴근로*/
	END IF
END IF

/*연장,야간,휴일연장,휴일철야,등교,*/
/*시.분 => 분으로 변환하여 SUM*/ 
SELECT SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."YJGTIME",0),'00.00'),1,3)) * 60 +
		 TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."YJGTIME",0),'00.00'),5,2))),   
		 SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKYJGTIME",0),'00.00'),1,3)) * 60 +
		 TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKYJGTIME",0),'00.00'),5,2))),   
       SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKCYGTIME",0),'00.00'),1,3)) * 60 +
		 TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKCYGTIME",0),'00.00'),5,2))),	
//		 SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME",0),'00.00'),1,3)) * 60 +
//		 TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."HKGTIME",0),'00.00'),5,2))),   
       SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."YKGTIME",0),'00.00'),1,3)) * 60 +
		 TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."YKGTIME",0),'00.00'),5,2))),
		 SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."DKGTIME",0),'00.00'),1,3)) * 60 +
		 TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."DKGTIME",0),'00.00'),5,2)))
	INTO :dYjTime,										:dHYjTime,   
        :dHCyTime,									
//		  :dHKlTime,   
        :dYkTime,										:dDkgTime
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			("P4_DKENTAE"."KJGUBN2" = 'Y')  ;
IF SQLCA.SQLCODE <> 0 THEN
	dYjTime = 0
	dYkTime = 0
	dHYjTime =0
	dHCyTime =0
	dJhTime  =0
	dDkgTime =0
ELSE
	IF IsNull(dYjTime) THEN								/*연장*/
		dYjTime = 0
	ELSE
		dYjTime = Wf_Conv_HhMm(dYjTime)
	END IF
	
	IF IsNull(dYkTime) THEN								/*평일야간*/
		dYkTime = 0
	ELSE
		dYkTime = Wf_Conv_HhMm(dYkTime)
	END IF
	
	IF IsNull(dHYjTime) THEN							/*휴일연장*/
		dHYjTime = 0
	ELSE
		dHYjTime = Wf_Conv_HhMm(dHYjTime)
	END IF
	
	IF IsNull(dHCyTime) THEN							/*휴일철야*/
		dHCyTime = 0
	ELSE
		dHCyTime = Wf_Conv_HhMm(dHCyTime)
	END IF
	
	IF IsNull(dDkgTime) THEN							/*등교시간*/
		dJhTime = 0
	ELSE
		dJhTime = Wf_Conv_HhMm(dDkgTime)
	END IF

	IF sJikJongGbn = '1' THEN							/*관리직 계산 않함*/
		dYjTime = 0
		dYkTime = 0
		dHYjTime =0
		dHCyTime =0
	END IF
END IF

IF sJikJongGbn = '1'  THEN							/*관리직 아님*/
	SELECT SUM(NVL("P4_DKENTAE"."KLGTIME",0))  
		INTO :dKlTime
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
				( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
	      	( "P4_DKENTAE"."KDATE" <= :senddate ) AND
				("P4_DKENTAE"."KJGUBN2" = 'Y')  ;	
	IF IsNull(dKlTime) THEN															/*근로*/
		dKlTime = 0
	END IF
	
ELSE
	SELECT SUM(TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."KLGTIME",0),'00.00'),1,3)) * 60 +
		 		TO_NUMBER(SUBSTR(TO_CHAR(NVL("P4_DKENTAE"."KLGTIME",0),'00.00'),5,2)))  
	INTO :dKlTime
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			("P4_DKENTAE"."KJGUBN2" = 'Y')  ;	
	IF IsNull(dKlTime) THEN															/*근로*/
		dKlTime = 0
	END IF
	
	/* IF sJhGbn ='Y' AND sJhtGbn ='Y' THEN							/*등교시간*/		
		dKlTime = dKlTime - dDkgTime										/*근로시간 = 근로 - 등교*/
	END IF*/

	dKlTime = Wf_Conv_HhMm(dKlTime)
END IF

Integer iTotalDay,iJtDay

/*출근일수*/
SELECT COUNT("P4_DKENTAE"."KDATE")											/*전체일수*/
	INTO :iTotalDay
	FROM "P4_DKENTAE"
	WHERE ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			("P4_DKENTAE"."KJGUBN2" = 'Y') AND
			(("P4_DKENTAE"."CKTIME" <> 0 ) AND
			( "P4_DKENTAE"."TKTIME" <> 0)) ;
IF SQLCA.SQLCODE <> 0 THEN
	iTotalDay = 0
ELSE
	IF IsNull(iTotalDay) THEN iTotalDay =0
END IF

SELECT COUNT("P4_DKENTAE"."KDATE")											/*훈련(4시간)이수*/
	INTO :iJtDay
	FROM "P4_DKENTAE"
	WHERE ( "P4_DKENTAE"."COMPANYCODE" = :Gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND
			("P4_DKENTAE"."KJGUBN2" = 'Y') AND
			(("P4_DKENTAE"."KTCODE" is not null) AND
			("P4_DKENTAE"."KTCODE" <> ' ') AND
			( "P4_DKENTAE"."JTGUBN" = '1')) ;
IF SQLCA.SQLCODE <> 0 THEN
	iJtDay = 0
ELSE
	IF IsNull(iJtDay) THEN iJtDay =0
END IF			

iMchDay = iTotalDay - iJtDay

/* 생산직 유급휴일일수 계산  근로시간 add, 유급일수 */
IF sJikJongGbn = '2'  THEN
		
	String Ikmgubn
	Double dPayTime,dFrom,dTo
	Int iMM	
	
	DECLARE cur_calendar2 CURSOR FOR 					/*월 중 '공휴일,지정휴일,생산토요휴무'을 select*/ 
		SELECT "P4_CALENDAR"."CLDATE"  
			FROM "P4_CALENDAR"  
			WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
					( "P4_CALENDAR"."CLDATE"      >= :sstartdate ) AND  
					( "P4_CALENDAR"."CLDATE"      <= :senddate ) AND  
					( "P4_CALENDAR"."CLDATE" < :sSilOutDate ) and
					( "P4_CALENDAR"."CLDATE" >= :sEnterDate ) AND
					( "P4_CALENDAR"."DAYGUBN" <> '1' ) AND
					( "P4_CALENDAR"."HDAYGUBN" = '3' OR "P4_CALENDAR"."HDAYGUBN"= '4' OR 
						"P4_CALENDAR"."HDAYGUBN"= '6'	)
			ORDER BY "P4_CALENDAR"."CLDATE" ASC;
	OPEN cur_calendar2;

	DO WHILE TRUE
		FETCH cur_calendar2 INTO :sSatDate;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
			// 각근무일구분에 의해 시간 계산
			SELECT "P4_PERKUNMU"."KMGUBN"  
				INTO :Ikmgubn  
				FROM "P4_PERKUNMU"  
				WHERE ( "P4_PERKUNMU"."COMPANYCODE" = :gs_company ) AND  
						( "P4_PERKUNMU"."EMPNO" = :sEmpno ) AND  
						( "P4_PERKUNMU"."KDATE" = :sSatDate )   ;
			// 출근 ,퇴근시간 계산 
			SELECT NVL("P4_KUNMU"."FROMTIME",0)  					/*근무일 table의 from시간(출근)*/
				INTO :dFrom  
				FROM "P4_KUNMU"  
				WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
						( "P4_KUNMU"."KMGUBN" = :Ikmgubn ) AND  
						( "P4_KUNMU"."CTGUBN" = '1' )   ;
			IF SQLCA.SQLCODE <> 0 THEN
				dFrom =0
			ELSE
				IF IsNull(dFrom) THEN dFrom =0
			END IF
		
			SELECT NVL("P4_KUNMU"."TOTIME",0)  					/*근무일 table의 to시간(퇴근)*/
				INTO :dTo  
				FROM "P4_KUNMU"  
				WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
							( "P4_KUNMU"."KMGUBN" = :Ikmgubn ) AND  
							( "P4_KUNMU"."CTGUBN" = '2' )   ;
			IF SQLCA.SQLCODE <> 0 THEN
				dTo =0
			ELSE
				IF IsNull(dTo) THEN dTo =0
			END IF
			
			SELECT SUM(NVL("P4_KUNMU"."GBUN",0))  
				INTO :dPayTime  
				FROM "P4_KUNMU"  
				WHERE ( "P4_KUNMU"."COMPANYCODE" = :gs_company ) AND  
				 	   ( "P4_KUNMU"."KMGUBN" = :Ikmgubn ) AND  
						( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400)  >= :dFrom ) AND  
						( DECODE("P4_KUNMU"."FTIMEGUBN",'1',"P4_KUNMU"."FROMTIME","P4_KUNMU"."FROMTIME" + 2400) < :dTo ) AND 
						( "P4_KUNMU"."KHGUBN" = '1' )  ;
			IF SQLCA.SQLCODE <> 0 THEN
				dPayTime =0
			ELSE
				IF IsNull(dPayTime) THEN dPayTime =0
			END IF
	
			iMM   = Mod(dPayTime,60)
			dPayTime = Truncate(dPayTime / 60,0)

			dPayTime = (dPayTime + (iMM / 100))
			
			dYhTime = dYhTime + dPayTime
			dKlTime = dKlTime + dPayTime
	LOOP
	CLOSE cur_calendar2;
END IF



end subroutine

public function integer wf_create_mkd ();/*****************************************************************************************/
/*** 월근태코드내역을 집계한다.(선택한 자료의 일근태자료를 읽어서 근태일수를 계산한다.   */
/*** - 이전 자료를 삭제한 후 다시 생성한다.															  */
/*** - 일근태 table에 근태코드가 있는 자료만 처리한다.											  */
/*****************************************************************************************/

Int    il_meterPosition,k,il_CurRow,il_CurCnt
String sEmpNo,sDeptCode,sKtCode,sPrtDept
Long   lMDay

sle_msg.text = '월근태코드내역 집계 중......'

SetPointer(HourGlass!)

uo_progress.Show()

dw_insert_mkd.Reset()

FOR k = 1 TO il_RowCount
	
	sEmpNo    = dw_Process.GetItemString(k,"empno")

	il_meterPosition = (k/ il_RowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)		
	
	IF Wf_Enabled_chk(sEmpNo,'MKD') = -1 THEN CONTINUE
	
	DELETE FROM "P4_MKUNTAEDAY"  
   	WHERE ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P4_MKUNTAEDAY"."EMPNO" = :sEmpNo ) AND  
         	( "P4_MKUNTAEDAY"."MYYMM" = :sProcDate )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인",dw_Process.GetItemString(k,"empname")+" 이전 자료 삭제 실패!!",StopSign!)
		ROLLBACK;
		sle_msg.text = '월근태코드내역 집계 실패!!'
		Return -1
	END IF
	
	//시스템 환경변수에서 무급휴직코드,유급휴직코드  읽어오기
	string ls_KTCode1 , ls_KTCode2 
	
	SELECT nvl(max(decode("SYSCNFG"."LINENO",'1',"SYSCNFG"."DATANAME")),'') as gubn1,
   	    nvl(max(decode("SYSCNFG"."LINENO",'2',"SYSCNFG"."DATANAME")),'') as gubn2	
    INTO :ls_ktcode1 , :ls_ktcode2	  
    FROM "P0_SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "SYSCNFG"."SERIAL" = '30' ) ;
	
	DECLARE cursor_kuntae CURSOR FOR  
  		SELECT "P4_DKENTAE"."KTCODE", COUNT(*)  
   	FROM "P4_DKENTAE"  
  		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
        		( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
	         ( "P4_DKENTAE"."KDATE" >= :sStartDate ) AND
				( "P4_DKENTAE"."KDATE" <= :sEndDate ) AND
				(("P4_DKENTAE"."KTCODE" IS NOT NULL) AND
				("P4_DKENTAE"."KTCODE" <> ' ')) AND
				("P4_DKENTAE"."KJGUBN1" = 'Y')
		GROUP BY "P4_DKENTAE"."KTCODE","P4_DKENTAE"."DEPTCODE"
		ORDER BY "P4_DKENTAE"."KTCODE";
	OPEN cursor_kuntae;
	
	il_CurCnt = 1
	
	DO WHILE TRUE
		FETCH cursor_kuntae INTO :sKtCode,		:lMDay;
		IF SQLCA.SQLCODE <> 0 THEN EXIT

		IF IsNull(lMDay) THEN lMDay =0
		
		il_CurRow = dw_insert_mkd.InsertRow(0)
		
		dw_insert_mkd.SetItem(il_CurRow,"companycode",gs_company)
		
		/*소속부서,출력부서 구하기*/
		SELECT "P4_DKENTAE"."DEPTCODE",   "P4_DKENTAE"."PRTDEPT"  
			INTO :sDeptCode,   				 :sPrtDept  
		   FROM "P4_DKENTAE"  
   		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         		( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
         		( "P4_DKENTAE"."KDATE" = (SELECT MAX("KDATE")
															FROM "P4_DKENTAE"
															WHERE "P4_DKENTAE"."COMPANYCODE" = :gs_company AND
																	"P4_DKENTAE"."EMPNO" = :sEmpNo  AND
																	"P4_DKENTAE"."KDATE" >= :sStartDate AND
																	"P4_DKENTAE"."KDATE" <= :sEndDate	)   ;


      // 무급,유급휴직일수 재계산(휴일, 일료일등 일근태가 없는날도 휴직일사이에 있으면  //
		//              				휴직일수에 포함한다 )				                      //
		
		IF sKtCode = ls_KTCode1 OR sKtCode = ls_KTCode2 THEN
			lMDay=w_hujikday(sKtCode,sEmpNo,k)
		END IF	

		dw_insert_mkd.SetItem(il_CurRow,"deptcode",   sDeptCode)
		dw_insert_mkd.SetItem(il_CurRow,"empno",      sEmpNo)
		dw_insert_mkd.SetItem(il_CurRow,"myymm",      sProcDate)
		dw_insert_mkd.SetItem(il_CurRow,"mktcode",    sKtCode)
		dw_insert_mkd.SetItem(il_CurRow,"mday",       lMDay)
		dw_insert_mkd.SetItem(il_CurRow,"prtdept",    sPrtDept)
		
		il_CurCnt = il_CurCnt + 1
	LOOP
	CLOSE cursor_kuntae;
	
NEXT

IF dw_insert_mkd.Update() <> 1 THEN
	MessageBox("확 인","월근태 코드내역 저장 실패!!")
	ROLLBACK;
	sle_msg.text = '월근태코드내역 집계 실패!!'
	Return -1
END IF

COMMIT;

uo_progress.Hide()

SetPointer(Arrow!)
sle_msg.text ='월근태코드 집계 완료!!'

Return 1
end function

public subroutine wf_calc_day (integer ll_row, string sempno, ref integer immpayday, ref integer imspayday, ref integer imwpayday, ref integer imjanday, ref integer iyjanday);String sEnterDate,sOutDate,sSex,sJtGbn,sSilOutDate
Int    iNoPayDay,	iMYBDay,iMUseDay

iMYBDay = 0
iMUseDay = 0

sEnterDate    = dw_Process.GetItemString(ll_row,"enterdate")
sOutDate      = dw_Process.GetItemString(ll_row,"retiredate")
IF sOutDate = "" OR IsNull(sOutDate) THEN
	sSilOutDate = '99999999'
ELSE
	sSilOutDate = sOutDate
END IF

/*생리지급*/
SELECT SUBSTR("P1_MASTER"."RESIDENTNO2",1,1),"P1_MASTER"."SERVICEKINDCODE"
	INTO :sSex,											:sJtGbn  
   FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_MASTER"."EMPNO" = :sEmpNo )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMSPayDay =0
ELSE
	IF sSex = '1' THEN iMSPayDay = 0
	
	IF sSex = '2' THEN
		IF sJtGbn = '1' AND sstartdate > sEnterDate THEN		/*재직자 and 당월이전입사자*/
			iMSPayDay = 1
		ELSE
			iMSPayDay = 0
		END IF	
		IF sJtGbn = '3' AND senddate < sSilOutDate THEN	/*퇴사자 and 당월이후퇴사자*/	
			iMSPayDay = 1	
		ELSE
			iMSPayDay = 0
		END IF
	END IF
END IF

/*월차지급*/
SELECT SUM(NVL("P4_MKUNTAEDAY"."MDAY",0))  				/*월근태코드집계에 '무급근태' 유무 체크*/
	INTO :iNoPayDay  
   FROM "P4_MKUNTAEDAY",   "P0_ATTENDANCE"  
   WHERE ( "P4_MKUNTAEDAY"."MKTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
         ( ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MKUNTAEDAY"."EMPNO" = :sEmpNo ) AND  
         ( "P4_MKUNTAEDAY"."MYYMM" = :sProcDate ) AND  
         ( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '4' ) )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iNoPayDay =0
ELSE
	IF IsNull(iNoPayDay) THEN iNoPayDay =0	
END IF

IF iNoPayDay = 0 THEN
	IF sstartdate >= sEnterDate THEN			/*당월이전 입사자*/
		iMMPayDay = 1
	ELSE
		iMMPayDay =0
	END IF
ELSE
	iMMPayDay =0
END IF

/*주차지급*/
String sSunDay, sJikjongGubn,sDayGbn

sJikjongGubn  = dw_Process.GetItemString(ll_row,"JikjongGubn")

if sJikjongGubn = '2' then
	
	DECLARE cur_calendar CURSOR FOR  
		SELECT "P4_CALENDAR"."CLDATE"  
			FROM "P4_CALENDAR"  
			WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
					( "P4_CALENDAR"."CLDATE"   >= :sstartdate ) AND  
					( "P4_CALENDAR"."CLDATE"   <= :senddate ) AND  	
					( "P4_CALENDAR"."DAYGUBN" = '1' )  AND
					("P4_CALENDAR"."CLDATE" <= :sSilOutDate ) AND
					("P4_CALENDAR"."CLDATE" >= :sEnterDate)
			ORDER BY "P4_CALENDAR"."CLDATE" ASC;
			
	OPEN cur_calendar;
	
	iMWPayDay =0
	
	DO WHILE TRUE
		FETCH cur_calendar INTO :sSunDay;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
		
		SELECT "P4_CALENDAR"."DAYGUBN" 									/*요일구분=월요일(2)*/ 
    		INTO :sDayGbn  
    		FROM "P4_CALENDAR"  
   		WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
         		( "P4_CALENDAR"."CLDATE" = :sEnterDate )   ;

		sFromDate = String(RelativeDate(Date(String(sSunDay,"@@@@.@@.@@")),-6),'yyyymmdd') 

		IF sEnterDate >= sFromDate AND sEnterDate <= sSunDay AND sDayGbn <> '2' THEN
			CONTINUE
		END IF
		
		SELECT COUNT("P4_DKENTAE"."KDATE")  				/*일근태에 '무급근태' 유무 체크*/
			INTO :iNoPayDay  
			FROM "P4_DKENTAE",   "P0_ATTENDANCE"  
			WHERE ( "P4_DKENTAE"."KTCODE" = "P0_ATTENDANCE"."ATTENDANCECODE" ) and  
					( ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
					( "P4_DKENTAE"."EMPNO" = :sEmpNo ) AND  
					(( "P4_DKENTAE"."KDATE" >= :sFromDate ) AND  
					( "P4_DKENTAE"."KDATE" <= :sSunDay )) AND
					( "P0_ATTENDANCE"."ATTENDANCEGUBN" = '4' ) )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			iNoPayDay =0
		ELSE
			IF IsNull(iNoPayDay) THEN iNoPayDay =0	
		END IF
					
		IF iNoPayDay = 0 THEN
			iMWPayDay = iMWPayDay + 1
		END IF
	LOOP
	CLOSE cur_calendar;
else
	iMWPayDay= 0
end if	

/*잔여월차 : 처리년월의 월차 table에서 a = '이월 + 발생 - (처리년월의 사용일수)'*/
/*   a가 2보다 크거나 같으면 2, 아니면 a */
SELECT NVL("P4_MONTHLIST"."YDAY",0) + NVL("P4_MONTHLIST"."BDAY",0)			/*이월 + 발생*/  
	INTO :iMYBDay  
   FROM "P4_MONTHLIST"  
   WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MONTHLIST"."YYMM" = :sProcDate ) AND  
         ( "P4_MONTHLIST"."EMPNO" = :sEmpno )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMYBDay = 0
ELSE
	IF IsNull(iMYBDay) THEN iMYBDay = 0
END IF

SELECT COUNT("P4_DKENTAE"."KTCODE")														/*사용일수*/  
	INTO :iMUseDay  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND  
         ( "P4_DKENTAE"."KDATE" >= :sstartdate ) AND  
			( "P4_DKENTAE"."KDATE" <= :senddate ) AND 
         ( "P4_DKENTAE"."KTCODE" = '05' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMUseDay = 0
ELSE
	IF IsNull(iMUseDay) THEN iMUseDay = 0
END IF

IF iMYBDay - iMUseDay >= 2 THEN							/*잔여월차 = 이월 + 발생 - 사용*/
	iMJanDay = 2
ELSE
	iMJanDay = iMYBDay - iMUseDay
END IF

/*잔여 년차 계산*/
/*  처리년월로 년차 table의 자료 선택(처리년월보다 작거나 같은 max(적용시작일자)값)의 */
/*             '이월 + 발생 - 지급일수' 구함(a)*/
/*  b = 년차의 처리년월의 사용기간 from부터 처리년월의 마지막일자까지의 일근태 사용일수*/
/*  잔여년차 = a - b */
SELECT NVL("P4_YEARLIST"."YDAY",0) + NVL("P4_YEARLIST"."BDAY",0) - NVL("P4_YEARLIST"."KDAY",0)  
	INTO :iMYBDay  
   FROM "P4_YEARLIST"  
   WHERE ( "P4_YEARLIST"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_YEARLIST"."EMPNO" = :sEmpNo ) AND
			( "P4_YEARLIST"."KDATE" = (SELECT MAX("KDATE")
													FROM "P4_YEARLIST"
													WHERE "P4_YEARLIST"."EMPNO" = :sEmpNo and
															"P4_YEARLIST"."YYMM" <= :sProcDate));
IF SQLCA.SQLCODE <> 0 THEN
	iMYBDay = 0
ELSE
	IF IsNull(iMYBDay) THEN iMYBDay = 0
END IF

SELECT COUNT("P4_DKENTAE"."KTCODE")														/*사용일수*/  
	INTO :iMUseDay  
   FROM "P4_DKENTAE"  
   WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_DKENTAE"."EMPNO" = :sEmpno ) AND  
         ( "P4_DKENTAE"."KDATE" >= (SELECT MAX("KDATE")
													FROM "P4_YEARLIST"
													WHERE "P4_YEARLIST"."EMPNO" = :sEmpNo and
															"P4_YEARLIST"."YYMM" <= :sProcDate)) AND
			( "P4_DKENTAE"."KDATE" <= senddate ) AND  
         ( "P4_DKENTAE"."KTCODE" = '07' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMUseDay = 0
ELSE
	IF IsNull(iMUseDay) THEN iMUseDay = 0
END IF

iYJanDay = iMYBDay - iMUseDay



end subroutine

public function string wf_proceduresql (string flag, string gubn);
Int    k 
String sGetSqlSyntax,sEmpNo,sProcPos
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

IF flag = 'CODE' THEN
	sGetSqlSyntax = 'select empno,retiredate from p1_master'
ELSEIF flag = 'TIME' THEN
	sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,jhtgubn from p1_master'
ELSEIF flag = 'MONTH' THEN
	sGetSqlSyntax = 'select empno,deptcode,enterdate,retiredate from p1_master'
ELSEIF flag = 'YEAR' THEN
	sGetSqlSyntax = 'select empno,deptcode,enterdate,retiredate,kmgubn,jikjonggubn from p1_master'
END IF

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' where ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (empno =' + "'"+ sEmpNo +"')"+ ' or'
	
NEXT
lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ') and  (jikjonggubn =' + "'"+ gubn +"')"

sGetSqlSyntax = sGetSqlSyntax 

Return sGetSqlSynTax


end function

public subroutine wf_reset ();string Last_day, sabu

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()
dw_insert_mkt.Reset()

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)

/* 대상기간(관리직,생산직) */
 sprocdate = f_aftermonth(left(f_today(),6),-1)
 string sdata1, sdata2

 SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
   INTO :sdata1,      :sdata2  
   FROM "P0_REF"  
  WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
        ( "P0_REF"."CODE" = substr(:sprocdate,5,2) )   ;

		                                            
																  /* 직종구분 '1' = 관리직 */																  
sStartDate = left(sprocdate,4)+ mid(sdata1,5,4)   

if mid(sprocdate,5,2) = '01' and left(sdata1,4) < mid(sdata1,10,4) then
	sStartdate = string(long(left(sStartdate,4)) - 1) + right(sStartdate,4)
end if

sEndDate   = left(sprocdate,4)+ mid(sdata1,14,4)
if right(sEndDate,4) = '0228' or right(sEndDate,4) = '0229' then /*2월은 윤년 여부를 따져서 28/29일로 변환*/
	if mod(long(left(sEndDate,4)),4) = 0 then
		sEndDate = left(sEndDate,4) + '0229'
	else
		sEndDate = left(sEndDate,4) + '0228'		
	end if
end if
                                                 /* 직종구분 '2' = 생산직 */
sFromDate = left(sprocdate,4)+ mid(sdata2,5,4)  
if mid(sprocdate,5,2) = '01' and left(sdata2,4) < mid(sdata2,10,4) then
	sFromDate = string(long(left(sFromDate,4)) - 1) + right(sFromDate,4)
end if

sToDate   = left(sprocdate,4)+ mid(sdata2,14,4)
if right(sToDate,4) = '0228' or right(sToDate,4) = '0229' then /*2월은 윤년 여부를 따져서 28/29일로 변환*/
	if mod(long(left(sToDate,4)),4) = 0 then
		sToDate = left(sToDate,4) + '0229'
	else
		sToDate = left(sToDate,4) + '0228'		
	end if
end if

dw_cond.SetItem(1,"kdate",f_aftermonth(left(f_today(),6),-1))
dw_cond.SetItem(1,"start_ymd",sStartDate)
dw_cond.SetItem(1,"from_ymd",sFromDate)
dw_cond.SetItem(1,"end_ymd",sEndDate)
dw_cond.SetItem(1,"to_ymd",sToDate)

select saupcd into :sabu
from p0_dept
where deptcode = :gs_dept;

dw_cond.SetColumn("kdate")
dw_cond.SetFocus()
dw_cond.SetRedraw(True)

uo_progress.Hide()


end subroutine

public function integer w_hujikday (string sktcode, string sempno, integer prow);//무급휴직일수, 유급휴직일수 재계산
 	string sDateFrom , sDateTo, ls_HujikFrom, ls_HujikTo, wDateFrom , wDateTo, ls_RetireDate
	long lMDay		  
	
	sDateFrom = sstartdate		
	sDateTo = senddate
	
  //퇴직일자
  	ls_RetireDate = dw_Process.GetItemString(pRow,"RetireDate")
	
  //휴직이력 Table에서 개인별 휴직일From, To일
  
   DECLARE Cursor_HujikHst CURSOR FOR  
 	 SELECT "P4_HUJIKHST"."FDATE", "P4_HUJIKHST"."TDATE" 
      FROM "P4_HUJIKHST"  
     WHERE ( "P4_HUJIKHST"."COMPANYCODE" = :gs_company ) AND  
           ( "P4_HUJIKHST"."EMPNO" = :sEmpno ) AND  
			  ( "P4_HUJIKHST"."FDATE" <= :sDateTo ) AND  
           ( "P4_HUJIKHST"."TDATE" >= :sDateFrom ) AND
           ( "P4_HUJIKHST"."HUJIKGUBN" = :sKTcode ) 
	  ORDER BY "P4_HUJIKHST"."FDATE"	 ;
	  OPEN  Cursor_HujikHst	;
	  lMDay = 0
	  DO WHILE TRUE
			FETCH Cursor_HujikHst INTO :ls_HujikFrom, :ls_HujikTo ; 
		
	   	IF SQLCA.SQLCODE <> 0 THEN EXIT
			 
			IF ls_HujikFrom >=  sDateFrom THEN 
		      wDateFrom= ls_HujikFrom 	
	      ELSE		
		      wDateFrom= sDateFrom	
         END IF
  			
		   IF ls_HujikTo <=  sDateTo THEN 
		      wDateTo= ls_HujikTo 
		   ELSE		
	         wDateTo= sDateTo	
		   END IF	
			
			//휴직기간에 퇴사한경우
			IF ls_RetireDate <> '' OR NOT IsNull(ls_RetireDate) THEN
				IF wDateFrom >  ls_RetireDate THEN CONTINUE
				
   			IF ls_RetireDate <=  wDateTo THEN 
	   	      wDateTo= ls_RetireDate
   		   END IF	
			END IF		
			
			lMDay =lMDay + daysafter(DATE(STRING(wDateFrom,"@@@@.@@.@@")),DATE(STRING(wDateTo,"@@@@.@@.@@"))) +1			 
			
     LOOP
	  CLOSE Cursor_HujikHst	;
  			

	 RETURN lMDay

end function

on w_pik1014.create
int iCurrent
call super::create
this.gb_7=create gb_7
this.dw_cond=create dw_cond
this.uo_progress=create uo_progress
this.dw_insert_mkt=create dw_insert_mkt
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.dw_insert_mkd=create dw_insert_mkd
this.dw_error=create dw_error
this.dw_personal=create dw_personal
this.dw_total=create dw_total
this.p_5=create p_5
this.p_4=create p_4
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_7
this.Control[iCurrent+2]=this.dw_cond
this.Control[iCurrent+3]=this.uo_progress
this.Control[iCurrent+4]=this.dw_insert_mkt
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cbx_2
this.Control[iCurrent+7]=this.dw_insert_mkd
this.Control[iCurrent+8]=this.dw_error
this.Control[iCurrent+9]=this.dw_personal
this.Control[iCurrent+10]=this.dw_total
this.Control[iCurrent+11]=this.p_5
this.Control[iCurrent+12]=this.p_4
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.pb_1
this.Control[iCurrent+17]=this.pb_2
this.Control[iCurrent+18]=this.rr_2
this.Control[iCurrent+19]=this.rr_3
this.Control[iCurrent+20]=this.rr_4
this.Control[iCurrent+21]=this.rr_5
end on

on w_pik1014.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_7)
destroy(this.dw_cond)
destroy(this.uo_progress)
destroy(this.dw_insert_mkt)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.dw_insert_mkd)
destroy(this.dw_error)
destroy(this.dw_personal)
destroy(this.dw_total)
destroy(this.p_5)
destroy(this.p_4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
end on

event open;call super::open;
dw_total.SetTransObject(SQLCA)
dw_personal.SetTransObject(SQLCA)
dw_error.SetTransObject(SQLCA)
dw_insert_mkt.SetTransObject(SQLCA)
dw_insert_mkd.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)

wf_reset()

f_set_saupcd(dw_cond, 'sabu', '1')
is_saupcd = gs_saupcd


end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1014
boolean visible = false
integer x = 3639
integer y = 3032
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1014
boolean visible = false
integer x = 3465
integer y = 3032
end type

type p_search from w_inherite_multi`p_search within w_pik1014
boolean visible = false
integer x = 3986
integer y = 3032
end type

type p_ins from w_inherite_multi`p_ins within w_pik1014
boolean visible = false
integer x = 3291
integer y = 3032
end type

type p_exit from w_inherite_multi`p_exit within w_pik1014
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pik1014
integer x = 4242
end type

event p_can::clicked;call super::clicked;
uo_progress.Hide()

w_mdi_frame.sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()


IF sProcDept ="%" THEN
	dw_cond.SetItem(1,"proc_pos",'T')
ELSE
	dw_cond.SetItem(1,"proc_pos",'D')
END IF
end event

type p_print from w_inherite_multi`p_print within w_pik1014
boolean visible = false
integer x = 3118
integer y = 3032
end type

type p_inq from w_inherite_multi`p_inq within w_pik1014
integer x = 3895
end type

event p_inq::clicked;call super::clicked;String sProcPos,sfdate1, sfdate2, stdate1, stdate2, sabu, sJikjong, sKunmu

dw_cond.AcceptText()
IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

dw_cond.AcceptText()
sProcPos = dw_cond.GetItemString(1,"proc_pos")
sProcDept= dw_cond.GetItemString(1,"deptcode")

sfdate1= dw_cond.GetItemString(1,"start_ymd")
stdate1= dw_cond.GetItemString(1,"end_ymd")

sfdate2= dw_cond.GetItemString(1,"from_ymd")
stdate2= dw_cond.GetItemString(1,"to_ymd")

sabu = trim(dw_cond.GetItemString(1, "sabu"))
sJikjong = trim(dw_cond.GetItemString(1,"Jikjong"))
sKunmu = trim(dw_cond.GetItemString(1,"Kunmu"))

IF sJikjong = '' OR IsNull(sJikjong) THEN sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
if IsNull(sabu) or sabu = '' then sabu = '%'
IF sProcDept ="" OR IsNull(sProcDept) THEN sProcDept ='%'

dw_total.Reset()
dw_personal.Reset()
dw_error.Reset()

IF dw_total.Retrieve(sProcDept,sfdate1, stdate1, sfdate2, stdate2, sabu, sJikjong, sKunmu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_cond.SetFocus()
	Return
END IF

IF sProcPos = 'T' THEN
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF






end event

type p_del from w_inherite_multi`p_del within w_pik1014
boolean visible = false
integer x = 3813
integer y = 3032
end type

type p_mod from w_inherite_multi`p_mod within w_pik1014
integer x = 4069
end type

event p_mod::clicked;call super::clicked;/******************************************************************************************/
/*** 월근태 집계(처리선택된 자료의 근태자료를 읽어서 아래 사항을 갱신한다)				*/

/******************************************************************************************/
String  sProcPos, ls_flag,sMasterSql,sGubn,srtnvalue1,srtnvalue2,sayymm
String mflag, yflag, sabu
Integer iRtnValue1,iErrorCnt,iRtnValue2

dw_error.Reset()

dw_cond.AcceptText()
sabu = dw_cond.GetitemString(1,'sabu')
IF ISNULL(sabu) OR sabu = '' THEN sabu = '10'

if right(sEndDate,4) = '0229' or right(sToDate,4) = '0229' then
	if MessageBox('확인','집계기간 종료일이 29일입니다. 계속 실행하시겠습니까?', &
	              Question!,YesNo!,1) = 2 then
		return
	end if
end if

// 월마감작업후 월근태 집계처리 못함
SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and
  		  myymm = :sprocdate and
		  saupcd = :sabu;
if ls_flag = '1' then
	messagebox("확인","마감이 되었으므로 처리할 수 없습니다.!!")
	return
end if	

IF dw_cond.GetRow() > 0 THEN
	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
END IF

sProcPos = dw_cond.GetItemString(1,"proc_pos")
sGubn = dw_cond.GetItemString(1,"updategubn")

IF sProcPos = 'T' OR sProcPos = 'D' THEN										//전체,부서
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

IF cbx_1.Checked = False AND cbx_2.Checked = False THEN
	MessageBox("확 인","작업구분을 선택하십시요!!")
	Return
END IF

//if messagebox("확인","월차를 생성하시겠습니까?",Question!,YesNo!) = 2 then
//	mflag = 'N'
//else
//	mflag = 'Y'
//end if
//if mflag = 'Y' then
//sayymm = f_aftermonth(sprocdate, -1)
//sMasterSql = wf_ProcedureSql('MONTH','1')   //관리직처리
//	
//sRtnValue1 = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,sstartdate,senddate);
////sRtnValue1 = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,'','');	
//sMasterSql = wf_ProcedureSql('MONTH','2')   //생산직처리
//	
//sRtnValue2 = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,sfromdate,stodate);
////sRtnValue1 = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,'','');
//IF Left(sRtnValue1,2) <> 'OK' or Left(sRtnValue2,2) <> 'OK' then
//	w_mdi_frame.sle_msg.text = '월차생성실패'
//	Rollback;
//	SetPointer(Arrow!)
//ELSE
//   w_mdi_frame.sle_msg.text = '월차생성완료!!'
//END IF		  
//
//end if

//if messagebox("확인","년차를 생성하시겠습니까?",Question!,YesNo!) = 2 then
//	yflag = 'N'
//else
//	yflag = 'Y'
//end if
//if yflag = 'Y' then	
//	
//IF sProcPos = 'T' THEN
//	
//	DELETE FROM p4_yearlist
//   WHERE (p4_yearlist.companycode = :gs_company ) and
//         (p4_yearlist.yymm = substr(:sProcDate,1,6)) and
//         (p4_yearlist.empno in (select p1_master.empno 
//                                from p1_master, p0_dept 
//                                where p1_master.companycode = p0_dept.companycode  and
//                                      p1_master.deptcode = p0_dept.deptcode and
//                                      p0_dept.saupcd like :sabu));
//	commit;
//END IF		
//
//sMasterSql = wf_ProcedureSql('YEAR','1')   //관리직처리
//	
////sRtnValue1 = sqlca.sp_create_yearlist(gs_company,sMasterSql,Left(sProcDate,4)+'0101',Left(sProcDate,4)+'1231',sProcdate);
//sRtnValue1 = sqlca.sp_create_yearlist(gs_company,sMasterSql,'','',sProcdate);	
//sMasterSql = wf_ProcedureSql('YEAR','2')   //생산직처리
//	
////sRtnValue2 = sqlca.sp_create_yearlist(gs_company,sMasterSql,Left(sProcDate,4)+'0101',Left(sProcDate,4)+'1231',sProcdate);
//sRtnValue2 = sqlca.sp_create_yearlist(gs_company,sMasterSql,'','',sProcdate);
//
//IF Left(sRtnValue1,2) <> 'OK' or Left(sRtnValue2,2) <> 'OK' then
//	sle_msg.text = '년차생성실패'
//	Rollback;
//	SetPointer(Arrow!)
//ELSE
//   sle_msg.text = '년차생성완료!!'
//END IF		  
//
//end if


IF cbx_1.Checked = True THEN
//	IF wf_create_mkd() = -1 THEN RETURN
	w_mdi_frame.sle_msg.text = '월근태코드내역 집계 중......'
	SetPointer(HourGlass!)
/* 기존 ERROR 내용 삭제 */	
   DELETE FROM "P4_TMP_CALCULATION" WHERE  "GUBN" = 'MD' OR  "GUBN" = 'MT' ;
	COMMIT ;
	
	sMasterSql = wf_ProcedureSql('CODE','1')   //관리직처리
	
	iRtnValue1 = sqlca.sp_summary_mkuntaeday(sprocdate,sMasterSql,gs_company,sstartdate,senddate,sgubn);
	
	sMasterSql = wf_ProcedureSql('CODE','2')   //생산직처리
	
	iRtnValue2 = sqlca.sp_summary_mkuntaeday(sprocdate,sMasterSql,gs_company,sfromdate,stodate,sgubn);
	
	IF iRtnValue1 = 0 then
		MessageBox("근태코드집계 처리","작업 PROCESS를 찾을 수 없습니다(관리직)!!")
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	ELSEIF iRtnValue1 = -1 THEN
		MessageBox("확 인","근태코드내역 집계 실패!!(관리직)")
		Rollback;
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	END IF
	IF iRtnValue2 = 0 then
		MessageBox("근태코드집계 처리","작업 PROCESS를 찾을 수 없습니다(생산직)!!")
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	ELSEIF iRtnValue2 = -1 THEN
		MessageBox("확 인","근태코드내역 집계 실패!!(생산직)")
		Rollback;
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	END IF

	commit;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='월근태내역 집계 완료!!'
	
	iErrorCnt = dw_error.Retrieve()
END IF

IF cbx_2.Checked = True THEN
//	IF wf_create_mkt() = -1 THEN RETURN


	w_mdi_frame.sle_msg.text = '월근태시간 집계 중......'
	SetPointer(HourGlass!)
	
	sMasterSql = wf_ProcedureSql('TIME','1') //관리직처리
	
	iRtnValue1 = sqlca.sp_summary_mkuntaetime(sprocdate,sMasterSql,gs_company,sstartdate,senddate,sgubn);
	
	sMasterSql = wf_ProcedureSql('TIME','2') //생산직처리
	
	iRtnValue2 = sqlca.sp_summary_mkuntaetime(sprocdate,sMasterSql,gs_company,sfromdate,stodate,sgubn);
	
	IF iRtnValue1 = 0 then
		MessageBox("근태시간집계 처리","작업 PROCESS를 찾을 수 없습니다!!(관리직)")
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	ELSEIF iRtnValue1 = -1 THEN
		MessageBox("확 인","근태시간 집계 실패!!(관리직)")
		Rollback;
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	END IF
	IF iRtnValue2 = 0 then
		MessageBox("근태시간집계 처리","작업 PROCESS를 찾을 수 없습니다!!(생산직)")
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	ELSEIF iRtnValue2 = -1 THEN
		MessageBox("확 인","근태시간 집계 실패!!(생산직)")
		Rollback;
		SetPointer(Arrow!)
		sle_msg.text =''
//		Return
	END IF

	commit;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='월근태시간 집계 완료!!'
	
	IF iErrorCnt <=0 THEN
		dw_error.Retrieve()
	END IF
END IF

w_mdi_frame.sle_msg.text ='월근태 처리 완료!!'

end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1014
boolean visible = false
integer x = 1175
integer y = 2748
end type

type st_window from w_inherite_multi`st_window within w_pik1014
boolean visible = false
integer x = 2263
integer y = 3224
end type

type cb_append from w_inherite_multi`cb_append within w_pik1014
boolean visible = false
integer x = 1115
integer y = 3024
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pik1014
boolean visible = false
integer taborder = 50
end type

type cb_update from w_inherite_multi`cb_update within w_pik1014
boolean visible = false
integer x = 2482
end type

event cb_update::clicked;///******************************************************************************************/
///*** 월근태 집계(처리선택된 자료의 근태자료를 읽어서 아래 사항을 갱신한다)				*/
//
///******************************************************************************************/
//String  sProcPos, ls_flag,sMasterSql,sGubn,srtnvalue1,srtnvalue2,sayymm
//String mflag, yflag, sabu
//Integer iRtnValue1,iErrorCnt,iRtnValue2
//
//dw_error.Reset()
//
//// 월마감작업후 월근태 집계처리 못함
//SELECT "P4_MFLAG"."GUBN"  
//  INTO :ls_flag  
//  FROM "P4_MFLAG" 
//  where companycode= :gs_company and myymm = :sprocdate;
//if ls_flag = '1' then
//	messagebox("확인","마감이 되었으므로 처리할 수 없습니다.!!")
//	return
//end if	
//
//dw_cond.AcceptText()
//IF dw_cond.GetRow() > 0 THEN
//	IF wf_requiredchk(dw_cond.Getrow()) = -1 THEN RETURN
//END IF
//
//dw_cond.AcceptText()
//sProcPos = dw_cond.GetItemString(1,"proc_pos")
//sGubn = dw_cond.GetItemString(1,"updategubn")
//sabu = dw_cond.GetitemString(1,'sabu')
//
//IF sProcPos = 'T' OR sProcPos = 'D' THEN										//전체,부서
//	dw_Process = dw_total
//	il_RowCount = dw_total.RowCount()
//ELSE																						//개인
//	dw_Process = dw_personal
//	il_RowCount = dw_personal.RowCount()
//END IF
//
//IF il_RowCount <=0 THEN 
//	MessageBox("확 인","처리할 자료가 없습니다!!")
//	Return
//END IF
//
//IF cbx_1.Checked = False AND cbx_2.Checked = False THEN
//	MessageBox("확 인","작업구분을 선택하십시요!!")
//	Return
//END IF
//
//if messagebox("확인","월차를 생성하시겠습니까?",Question!,YesNo!) = 2 then
//	mflag = 'N'
//else
//	mflag = 'Y'
//end if
//if mflag = 'Y' then
//sayymm = f_aftermonth(sprocdate, -1)
//sMasterSql = wf_ProcedureSql('MONTH','1')   //관리직처리
//	
//sRtnValue1 = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,sstartdate,senddate);
//	
//sMasterSql = wf_ProcedureSql('MONTH','2')   //생산직처리
//	
//sRtnValue2 = sqlca.sp_create_monthlist(gs_company,sprocdate,sayymm,sMasterSql,sfromdate,stodate);
//
//IF Left(sRtnValue1,2) <> 'OK' or Left(sRtnValue2,2) <> 'OK' then
//	sle_msg.text = '월차생성실패'
//	Rollback;
//	SetPointer(Arrow!)
//ELSE
//   sle_msg.text = '월차생성완료!!'
//END IF		  
//
//end if
//
////if messagebox("확인","년차를 생성하시겠습니까?",Question!,YesNo!) = 2 then
////	yflag = 'N'
////else
////	yflag = 'Y'
////end if
////if yflag = 'Y' then	
////	
////IF sProcPos = 'T' THEN
////	
////	DELETE FROM p4_yearlist
////   WHERE (p4_yearlist.companycode = :gs_company ) and
////         (p4_yearlist.yymm = substr(:sProcDate,1,6)) and
////         (p4_yearlist.empno in (select p1_master.empno 
////                                from p1_master, p0_dept 
////                                where p1_master.companycode = p0_dept.companycode  and
////                                      p1_master.deptcode = p0_dept.deptcode and
////                                      p0_dept.saupcd like :sabu));
////	commit;
////END IF		
////
////sMasterSql = wf_ProcedureSql('YEAR','1')   //관리직처리
////	
////sRtnValue1 = sqlca.sp_create_yearlist(gs_company,sMasterSql,Left(sProcDate,4)+'0101',Left(sProcDate,4)+'1231',sProcdate);
////	
////sMasterSql = wf_ProcedureSql('YEAR','2')   //생산직처리
////	
////sRtnValue2 = sqlca.sp_create_yearlist(gs_company,sMasterSql,Left(sProcDate,4)+'0101',Left(sProcDate,4)+'1231',sProcdate);
////
////IF Left(sRtnValue1,2) <> 'OK' or Left(sRtnValue2,2) <> 'OK' then
////	sle_msg.text = '년차생성실패'
////	Rollback;
////	SetPointer(Arrow!)
////ELSE
////   sle_msg.text = '년차생성완료!!'
////END IF		  
//
////end if
//
//
//IF cbx_1.Checked = True THEN
////	IF wf_create_mkd() = -1 THEN RETURN
//	sle_msg.text = '월근태코드내역 집계 중......'
//	SetPointer(HourGlass!)
///* 기존 ERROR 내용 삭제 */	
//   DELETE FROM "P4_TMP_CALCULATION" WHERE  "GUBN" = 'MD' OR  "GUBN" = 'MT' ;
//	COMMIT ;
//	
//	sMasterSql = wf_ProcedureSql('CODE','1')   //관리직처리
//	
//	iRtnValue1 = sqlca.sp_summary_mkuntaeday(sprocdate,sMasterSql,gs_company,sstartdate,senddate,sgubn);
//	
//	sMasterSql = wf_ProcedureSql('CODE','2')   //생산직처리
//	
//	iRtnValue2 = sqlca.sp_summary_mkuntaeday(sprocdate,sMasterSql,gs_company,sfromdate,stodate,sgubn);
//	
//	IF iRtnValue1 = 0 then
//		MessageBox("근태코드집계 처리","작업 PROCESS를 찾을 수 없습니다(관리직)!!")
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	ELSEIF iRtnValue1 = -1 THEN
//		MessageBox("확 인","근태코드내역 집계 실패!!(관리직)")
//		Rollback;
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	END IF
//	IF iRtnValue2 = 0 then
//		MessageBox("근태코드집계 처리","작업 PROCESS를 찾을 수 없습니다(생산직)!!")
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	ELSEIF iRtnValue2 = -1 THEN
//		MessageBox("확 인","근태코드내역 집계 실패!!(생산직)")
//		Rollback;
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	END IF
//
//	commit;
//	SetPointer(Arrow!)
//	sle_msg.text ='월근태내역 집계 완료!!'
//	
//	iErrorCnt = dw_error.Retrieve()
//END IF
//
//IF cbx_2.Checked = True THEN
////	IF wf_create_mkt() = -1 THEN RETURN
//
//
//	sle_msg.text = '월근태시간 집계 중......'
//	SetPointer(HourGlass!)
//	
//	sMasterSql = wf_ProcedureSql('TIME','1') //관리직처리
//	
//	iRtnValue1 = sqlca.sp_summary_mkuntaetime(sprocdate,sMasterSql,gs_company,sstartdate,senddate,sgubn);
//	
//	sMasterSql = wf_ProcedureSql('TIME','2') //생산직처리
//	
//	iRtnValue2 = sqlca.sp_summary_mkuntaetime(sprocdate,sMasterSql,gs_company,sfromdate,stodate,sgubn);
//	
//	IF iRtnValue1 = 0 then
//		MessageBox("근태시간집계 처리","작업 PROCESS를 찾을 수 없습니다!!(관리직)")
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	ELSEIF iRtnValue1 = -1 THEN
//		MessageBox("확 인","근태시간 집계 실패!!(관리직)")
//		Rollback;
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	END IF
//	IF iRtnValue2 = 0 then
//		MessageBox("근태시간집계 처리","작업 PROCESS를 찾을 수 없습니다!!(생산직)")
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	ELSEIF iRtnValue2 = -1 THEN
//		MessageBox("확 인","근태시간 집계 실패!!(생산직)")
//		Rollback;
//		SetPointer(Arrow!)
//		sle_msg.text =''
////		Return
//	END IF
//
//	commit;
//	SetPointer(Arrow!)
//	sle_msg.text ='월근태시간 집계 완료!!'
//	
//	IF iErrorCnt <=0 THEN
//		dw_error.Retrieve()
//	END IF
//END IF
//
//sle_msg.text ='월근태 처리 완료!!'
//
end event

type cb_insert from w_inherite_multi`cb_insert within w_pik1014
boolean visible = false
integer x = 1481
integer y = 3024
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1014
boolean visible = false
integer x = 763
integer y = 3024
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1014
boolean visible = false
integer x = 2117
integer taborder = 20
end type

type st_1 from w_inherite_multi`st_1 within w_pik1014
boolean visible = false
integer x = 101
integer y = 3224
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1014
boolean visible = false
integer taborder = 40
end type

event cb_cancel::clicked;call super::clicked;//
//uo_progress.Hide()
//
//sle_msg.text =""
//
//dw_total.Reset()
//dw_personal.Reset()
//dw_error.Reset()
//
//
//IF sProcDept ="%" THEN
//	dw_cond.SetItem(1,"proc_pos",'T')
//ELSE
//	dw_cond.SetItem(1,"proc_pos",'D')
//END IF
end event

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1014
boolean visible = false
integer x = 2912
integer y = 3224
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1014
boolean visible = false
integer x = 430
integer y = 3224
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1014
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1014
boolean visible = false
integer x = 704
integer y = 2972
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1014
boolean visible = false
integer x = 82
integer y = 3172
end type

type gb_7 from groupbox within w_pik1014
boolean visible = false
integer x = 2021
integer y = 2884
integer width = 960
integer height = 276
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
string text = "작업구분"
end type

type dw_cond from u_key_enter within w_pik1014
event ue_keydown pbm_dwnkey
integer x = 357
integer y = 64
integer width = 3525
integer height = 360
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik10141"
boolean border = false
end type

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;
String ls_ProcDate,sDayGbn,sHDayGbn,sDeptCode,sDeptName,sProcGbn,snull

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "kdate" THEN
	sprocdate = Trim(this.GetText())
	
	IF sprocdate = "" OR IsNull(sprocdate) THEN Return
	
	IF f_datechk(sprocdate + '01') = -1 THEN
		MessageBox("확 인","유효한 날짜가 아닙니다!!")
		dw_cond.SetItem(1,"kdate",snull)
		Return 1
	END IF

	string sdata1, sdata2

	  SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
   INTO :sdata1,      :sdata2  
   FROM "P0_REF"  
  WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
        ( "P0_REF"."CODE" = substr(:sprocdate,5,2) )   ;

		                                            
																  /* 직종구분 '1' = 관리직 */																  
sStartDate = left(sprocdate,4)+ mid(sdata1,5,4)   

if mid(sprocdate,5,2) = '01' and left(sdata1,4) < mid(sdata1,10,4) then
	sStartdate = string(long(left(sStartdate,4)) - 1) + right(sStartdate,4)
end if

sEndDate   = left(sprocdate,4)+ mid(sdata1,14,4)
if right(sEndDate,4) = '0228' or right(sEndDate,4) = '0229' then /*2월은 윤년 여부를 따져서 28/29일로 변환*/
	if mod(long(left(sEndDate,4)),4) = 0 then
		sEndDate = left(sEndDate,4) + '0229'
	else
		sEndDate = left(sEndDate,4) + '0228'		
	end if
end if

                                                 /* 직종구분 '2' = 생산직 */
sFromDate = left(sprocdate,4)+ mid(sdata2,5,4)  
if mid(sprocdate,5,2) = '01' and left(sdata2,4) < mid(sdata2,10,4) then
	sFromDate = string(long(left(sFromDate,4)) - 1) + right(sFromDate,4)
end if

sToDate   = left(sprocdate,4)+ mid(sdata2,14,4)
if right(sToDate,4) = '0228' or right(sToDate,4) = '0229' then /*2월은 윤년 여부를 따져서 28/29일로 변환*/
	if mod(long(left(sToDate,4)),4) = 0 then
		sToDate = left(sToDate,4) + '0229'
	else
		sToDate = left(sToDate,4) + '0228'		
	end if
end if

dw_cond.SetItem(1,"start_ymd",sStartDate)
dw_cond.SetItem(1,"from_ymd",sFromDate)
dw_cond.SetItem(1,"end_ymd",sEndDate)
dw_cond.SetItem(1,"to_ymd",sToDate)
END IF

//IF this.GetColumnName() = "proc_pos" THEN
//	sProcGbn = this.GetText()
//	
//	this.SetItem(1,"deptcode",snull)
//	this.SetItem(1,"deptname2",snull)
//
//END IF

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"deptname2",snull)
		Return
	END IF
	
	SELECT "P0_DEPT"."DEPTNAME"  
   	INTO :sDeptName  
   	FROM "P0_DEPT"  
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P0_DEPT"."DEPTCODE" = :sDeptCode );
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"deptname2",sDeptName)
	ELSE
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"deptname2",snull)
		Return 1
	END IF
END IF


p_inq.Triggerevent(Clicked!)

return 

end event

event getfocus;this.AcceptText()
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"deptname2",gs_codename)	
END IF

p_inq.Triggerevent(Clicked!)
end event

type uo_progress from u_progress_bar within w_pik1014
integer x = 2496
integer y = 2236
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_insert_mkt from datawindow within w_pik1014
boolean visible = false
integer x = 105
integer y = 2740
integer width = 1033
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "월근태 저장"
string dataobject = "d_pik10144"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type cbx_1 from checkbox within w_pik1014
boolean visible = false
integer x = 2167
integer y = 2956
integer width = 667
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "월근태코드내역 집계"
boolean checked = true
end type

event clicked;
dw_error.Reset()
end event

type cbx_2 from checkbox within w_pik1014
boolean visible = false
integer x = 2162
integer y = 3052
integer width = 667
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "월근태자료 집계"
boolean checked = true
end type

event clicked;dw_error.Reset()
end event

type dw_insert_mkd from datawindow within w_pik1014
boolean visible = false
integer x = 105
integer y = 2844
integer width = 1029
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "월근태코드내역 저장"
string dataobject = "d_pik10145"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_error from u_d_select_sort within w_pik1014
integer x = 2446
integer y = 544
integer width = 1179
integer height = 1664
integer taborder = 0
string dataobject = "d_pik10143"
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_personal from u_d_select_sort within w_pik1014
integer x = 1495
integer y = 544
integer width = 791
integer height = 1664
integer taborder = 0
string dataobject = "d_pik10142"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_total from u_d_select_sort within w_pik1014
integer x = 462
integer y = 544
integer width = 800
integer height = 1664
integer taborder = 0
string dataobject = "d_pik10142"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type p_5 from picture within w_pik1014
boolean visible = false
integer x = 3767
integer y = 2592
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String sEmpNo,sEmpName,sKmGbn,sJikGbn,sEnterDate,sOutDate,sJhGbn,sJhtGbn
Long rowcnt , totRow , sRow ,gRow
int i

//dw_personal.reset()
totRow =dw_total.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_total.getselectedrow(gRow)
	IF sRow > 0 THEN
		sEmpNo   = dw_total.GetItemString(sRow, "empno")
		sEmpName = dw_total.GetItemString(sRow, "empname")
		sKmGbn   = dw_total.GetItemString(sRow, "kmgubn")
		sJikGbn  = dw_total.GetItemString(sRow, "jikjonggubn")
		sEnterDate = dw_total.GetItemString(sRow, "enterdate")
		sOutDate   = dw_total.GetItemString(sRow, "retiredate")
		sJhGbn     = dw_total.GetItemString(sRow, "jhgubn")
		sJhtGbn    = dw_total.GetItemString(sRow, "jhtgubn")
		
		rowcnt = dw_personal.RowCount() + 1
		dw_personal.insertrow(rowcnt)
      dw_personal.setitem(rowcnt, "empname",     sEmpName)
		dw_personal.setitem(rowcnt, "empno",       sEmpNo)
		dw_personal.setitem(rowcnt, "kmgubn",      sKmGbn)
		dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
		dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
		dw_personal.setitem(rowcnt, "retiredate",  sOutDate)
		dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
		dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)

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

type p_4 from picture within w_pik1014
boolean visible = false
integer x = 3767
integer y = 2700
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String sEmpNo,sEmpName,sKmGbn,sJikGbn,sEnterDate,sOutDate,sJhGbn,sJhtGbn
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
		sJikGbn  = dw_personal.GetItemString(sRow, "jikjonggubn")
		sEnterDate = dw_personal.GetItemString(sRow, "enterdate")
		sOutDate   = dw_personal.GetItemString(sRow, "retiredate")
		sJhGbn     = dw_personal.GetItemString(sRow, "jhgubn")
		sJhtGbn    = dw_personal.GetItemString(sRow, "jhtgubn")
		
		rowcnt = dw_total.RowCount() + 1
		dw_total.insertrow(rowcnt)
      dw_total.setitem(rowcnt, "empname",     sEmpName)
		dw_total.setitem(rowcnt, "empno",       sEmpNo)
		dw_total.setitem(rowcnt, "kmgubn",      sKmGbn)
		dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
		dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
		dw_total.setitem(rowcnt, "retiredate",  sOutDate)
		dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
		dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)

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

type st_2 from statictext within w_pik1014
integer x = 498
integer y = 488
integer width = 146
integer height = 48
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

type st_3 from statictext within w_pik1014
integer x = 1527
integer y = 488
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

type st_4 from statictext within w_pik1014
integer x = 2473
integer y = 488
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

type pb_1 from picturebutton within w_pik1014
integer x = 1326
integer y = 840
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

event clicked;String sEmpNo,sEmpName,sKmGbn,sJikGbn,sEnterDate,sOutDate,sJhGbn,sJhtGbn
Long rowcnt , totRow , sRow ,gRow
int i

//dw_personal.reset()
totRow =dw_total.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_total.getselectedrow(gRow)
	IF sRow > 0 THEN
		sEmpNo   = dw_total.GetItemString(sRow, "empno")
		sEmpName = dw_total.GetItemString(sRow, "empname")
		sKmGbn   = dw_total.GetItemString(sRow, "kmgubn")
		sJikGbn  = dw_total.GetItemString(sRow, "jikjonggubn")
		sEnterDate = dw_total.GetItemString(sRow, "enterdate")
		sOutDate   = dw_total.GetItemString(sRow, "retiredate")
		sJhGbn     = dw_total.GetItemString(sRow, "jhgubn")
		sJhtGbn    = dw_total.GetItemString(sRow, "jhtgubn")
		
		rowcnt = dw_personal.RowCount() + 1
		dw_personal.insertrow(rowcnt)
      dw_personal.setitem(rowcnt, "empname",     sEmpName)
		dw_personal.setitem(rowcnt, "empno",       sEmpNo)
		dw_personal.setitem(rowcnt, "kmgubn",      sKmGbn)
		dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
		dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
		dw_personal.setitem(rowcnt, "retiredate",  sOutDate)
		dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
		dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)

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

type pb_2 from picturebutton within w_pik1014
integer x = 1326
integer y = 944
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
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;String sEmpNo,sEmpName,sKmGbn,sJikGbn,sEnterDate,sOutDate,sJhGbn,sJhtGbn
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
		sJikGbn  = dw_personal.GetItemString(sRow, "jikjonggubn")
		sEnterDate = dw_personal.GetItemString(sRow, "enterdate")
		sOutDate   = dw_personal.GetItemString(sRow, "retiredate")
		sJhGbn     = dw_personal.GetItemString(sRow, "jhgubn")
		sJhtGbn    = dw_personal.GetItemString(sRow, "jhtgubn")
		
		rowcnt = dw_total.RowCount() + 1
		dw_total.insertrow(rowcnt)
      dw_total.setitem(rowcnt, "empname",     sEmpName)
		dw_total.setitem(rowcnt, "empno",       sEmpNo)
		dw_total.setitem(rowcnt, "kmgubn",      sKmGbn)
		dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
		dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
		dw_total.setitem(rowcnt, "retiredate",  sOutDate)
		dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
		dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)

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

type rr_2 from roundrectangle within w_pik1014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 366
integer y = 436
integer width = 3346
integer height = 1888
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 448
integer y = 508
integer width = 827
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pik1014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1486
integer y = 508
integer width = 814
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pik1014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2432
integer y = 508
integer width = 1207
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

