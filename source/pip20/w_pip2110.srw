$PBExportHeader$w_pip2110.srw
$PBExportComments$** 상여 계산
forward
global type w_pip2110 from w_inherite_standard
end type
type dw_ip from u_key_enter within w_pip2110
end type
type st_13 from statictext within w_pip2110
end type
type st_12 from statictext within w_pip2110
end type
type st_10 from statictext within w_pip2110
end type
type p_compute from picture within w_pip2110
end type
type st_2 from statictext within w_pip2110
end type
type dw_cond1 from u_key_enter within w_pip2110
end type
type dw_personal from u_d_select_sort within w_pip2110
end type
type dw_total from u_d_select_sort within w_pip2110
end type
type pb_2 from picturebutton within w_pip2110
end type
type pb_1 from picturebutton within w_pip2110
end type
type uo_progress from u_progress_bar within w_pip2110
end type
type dw_cond from u_key_enter within w_pip2110
end type
type rr_2 from roundrectangle within w_pip2110
end type
type rr_1 from roundrectangle within w_pip2110
end type
type rr_4 from roundrectangle within w_pip2110
end type
type rr_6 from roundrectangle within w_pip2110
end type
type rr_7 from roundrectangle within w_pip2110
end type
type rr_8 from roundrectangle within w_pip2110
end type
type dw_err from u_d_select_sort within w_pip2110
end type
end forward

global type w_pip2110 from w_inherite_standard
string title = "상여 계산"
boolean resizable = false
event ue_process pbm_custom04
dw_ip dw_ip
st_13 st_13
st_12 st_12
st_10 st_10
p_compute p_compute
st_2 st_2
dw_cond1 dw_cond1
dw_personal dw_personal
dw_total dw_total
pb_2 pb_2
pb_1 pb_1
uo_progress uo_progress
dw_cond dw_cond
rr_2 rr_2
rr_1 rr_1
rr_4 rr_4
rr_6 rr_6
rr_7 rr_7
rr_8 rr_8
dw_err dw_err
end type
global w_pip2110 w_pip2110

type variables
DataWindow dw_Process

Integer           il_RowCount,iAry_EditChild = 1
String             Is_PbTag , Is_PbName
Double          Id_NoTax_Sub = 0                     //비과세공제

Integer           Ii_year[]
Integer           Ii_rate[]
Double           Ii_amount[]
Long              iTotalMonth
Double           lipayamt
string           iagoday    //전달 상여지급일
string           igijunday  //상여지급일 기준 6개월전일(야금의 기준일)
integer          itotalday  //6개월전(기준일) 부터 상여지급일까지의 일수
double           irate      //지급율

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
end variables

forward prototypes
public subroutine wf_magamcheck ()
public function string wf_proceduresql ()
public subroutine wf_sqlsyntax (string sym)
end prototypes

event ue_process;//String sbef_worktag
//Int i,rt,il_rowCount,il_meterPosition
//
//sle_start.text = string(now())
//
//mm = integer(mid(em_date.text,6,2))
//
//swork_ym = Left(em_date.text,4)+Right(em_date.text,2)
//startdate = Left(em_date.text,4)+Right(em_date.text,2) + "01"
//enddate = Left(em_date.text,4)+Right(em_date.text,2)  + STRING(idd_dd[mm])
//
//// 입력받은 년월의 급여편집자료가 있는지 확인
//SELECT DISTINCT workym 
//	INTO :sbef_worktag
//   FROM p3_editdata
//   WHERE (companycode = :gs_company) and  workym = :swork_ym AND pbtag = :iv_pbtag ;
//
//If (sqlca.sqlcode = 0) then              //작업년월의 자료가 이미 존재한다는 의미
//	IF messagebox ("자료존재", "재작업을 하시겠읍니까?",exclamation!,yesno!,2) = 1 THEN
//   ELSE
//      em_date.setfocus()
//      return
//   END IF
//END IF
//
//string ls_job
//
//setpointer(hourglass!)
//
//SELECT worktag
//    INTO :ls_job  
//    FROM "P3_JOBTAG"  
//   WHERE ( "P3_JOBTAG"."COMPANYCODE" = :gs_company ) AND  
//         ( "P3_JOBTAG"."WORKYM" = :swork_ym ) AND  
//         ( "P3_JOBTAG"."PBTAG" = 'P' )   ;
//if ls_job  = 'Y' then
//	messagebox ( "주의", "작업이 완료되었습니다.!")
//	return
//end if
//
//i = 0
//wrtcnt = 0
//
//uo_progress.Show()
//
//if rb_all.checked then     //작업대상(전체)
//	dw_1.setredraw(false)
//   if wf_editdata_delete_f() = false then return      //해당년월의 자료를 모두 삭제한다
//
//	il_rowCount = dw_1.RowCount()
//	
//	for i = 1 to il_rowCount
//		
//		il_meterPosition = (i/ il_rowCount) * 100
//		uo_progress.uf_set_position (il_meterPosition)
//	
//		iv_empno = dw_1.getitemstring(i, "empno")
//      iv_empname = dw_1.getitemstring(i, "empname")
//		
//      PN = PN1
//      ED = ED1
//
//		dw_saving.reset()
//		dw_pension.reset()
//
//      wf_except_data()            //급여예외자료 check
//
//      if (iv_userec = "N") then  CONTINUE              //강제제외자면 skip
//
//      //개인별 급여자료 처리 
//      IF wf_personal_read() = -1 THEN CONTINUE
//			
//		//지급부분 계산 
//		wf_monthchg_data('1')
//		
//      //공제부분 계산 : 세금계산 포함
//		wf_sub_calculation()
// 		// 급여편집 자료에 계산된 자료를 WRITE 한다
//		if wf_editdata_insert() = 1 then
//			commit;
//     	else
//        	rollback;
//	   end if
//	next	
//	dw_1.setredraw(true)
//else                      //작업대상(일부)
//	
//	il_rowCount = dw_2.RowCount()
//	for i = 1 to il_rowCount
//		
//		il_meterPosition = (i/ il_rowCount) * 100
//		uo_progress.uf_set_position (il_meterPosition)
//		
//		iv_empno = dw_2.getitemstring(i, "empno")
//      iv_empname = dw_2.getitemstring(i, "empname")
//
//		dw_saving.reset()
//		dw_pension.reset()
//
//		//급여대상자를 삭제한다
//      if wf_editdata_delete_p() = false then CONTINUE
//    
//      PN = PN1
//      ED = ED1
//   
//   	wf_except_data()           //급여예외자료 check
//
//      if (iv_userec = "N") then CONTINUE  //강제제외자면 skip 
//
//      //개인별 급여자료 처리 
//      wf_personal_read()           	  
//		
//		//지급부분 계산 
//		wf_monthchg_data('1')
//		
//      //공제부분 계산 : 세금계산 포함
//		wf_sub_calculation()
// 		// 급여편집 자료에 계산된 자료를 WRITE 한다
//		 
//		if wf_editdata_insert() = 1 then
//			commit;
//     	else
//        	rollback;
//	   end if
//   next	
//end if
//
//f_insa_static(gs_company,swork_ym) 
//
//uo_progress.Hide()
//
//setpointer(arrow!)
//sle_end.text = string(now())
//messagebox("작업완료 !!", "작업이 완료되었습니다.(" + string(wrtcnt, "####") + "건)")
//
//
end event

public subroutine wf_magamcheck ();String sPayMagamGbn, sworkym, sSaup

dw_ip.Accepttext()

sworkym = left(dw_ip.GetitemString(1,'workdate'),6)
sSaup = dw_ip.GetItemString(1,'saup')
IF ISNULL(sSaup) OR sSaup = '' THEN sSaup = '10'

SELECT "P8_PAYFLAG"."CLYN"  		INTO :sPayMagamGbn  
	FROM "P8_PAYFLAG"
   WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :Gs_Company ) AND  
         ( "P8_PAYFLAG"."CLYEARMM" = :sworkym) AND
			( "P8_PAYFLAG"."CLGUBN" = :is_Pbtag ) AND
			( "P8_PAYFLAG"."SAUPCD" = :sSaup );
			
IF SQLCA.SQLCODE <> 0 THEN
	sPayMagamGbn = 'N'
ELSE
	IF IsNull(sPayMaGamGbn) THEN sPayMagamGbn = 'N'
END IF

IF sPayMagamGbn = 'Y' THEN
	MessageBox("확 인","이미 마감 처리되었습니다. 마감 취소 후 작업하세요!!")
	p_compute.Enabled = False
	p_compute.PictureName = "C:\erpman\image\계산_d.gif"

ELSE
   p_compute.Enabled = True
	p_compute.PictureName = "C:\erpman\image\계산_up.gif"
END IF



end subroutine

public function string wf_proceduresql ();
Int    k 
String sGetSqlSyntax,sEmpNo
Long   lSyntaxLength

sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,paygubn,consmatgubn,kmgubn,engineergubn from p1_master'

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' where ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (empno =' + "'"+ sEmpNo +"')"+ ' or'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

Return sGetSqlSynTax


end function

public subroutine wf_sqlsyntax (string sym);Int    k 
String sGetSqlSyntax,sEmpNo
Long   lSyntaxLength

sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,paygubn,servicekindcode,levelcode from p1_master'

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' where ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (empno =' + "'"+ sEmpNo +"')"+ ' or'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

//Return sGetSqlSynTax


end subroutine

event open;call super::open;
ib_any_typing=False

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

dw_datetime.SetTransObject(SQLCA)
dw_datetime.Reset()
dw_datetime.InsertRow(0)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.Insertrow(0)

dw_cond1.SetTransObject(SQLCA)
dw_cond1.Reset()
int k
IF dw_cond1.Retrieve() <= 0 then
	FOR k = 1 TO 9
		dw_cond1.Insertrow(0)
	NEXT	
END IF	

dw_total.settransobject(SQLCA)
dw_personal.settransobject(SQLCA)
dw_err.settransobject(SQLCA)


uo_progress.Hide()

dw_ip.SetItem(1,'workdate', f_today())
dw_ip.SetItem(1,'workym', left(f_today(),6))

dw_ip.object.target[1] = '1'

p_inq.TriggerEvent(Clicked!)

dw_ip.SetFocus()
dw_ip.SetColumn('workdate')

dw_err.reset()

pb_1.picturename = "C:\erpman\Image\next.gif"
pb_2.picturename = "C:\erpman\Image\prior.gif"

//pb_1.picturename = "C:\erpman\Image\next_1.bmp"
//pb_2.picturename = "C:\erpman\Image\prior_1.bmp"
end event

on w_pip2110.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.st_13=create st_13
this.st_12=create st_12
this.st_10=create st_10
this.p_compute=create p_compute
this.st_2=create st_2
this.dw_cond1=create dw_cond1
this.dw_personal=create dw_personal
this.dw_total=create dw_total
this.pb_2=create pb_2
this.pb_1=create pb_1
this.uo_progress=create uo_progress
this.dw_cond=create dw_cond
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_4=create rr_4
this.rr_6=create rr_6
this.rr_7=create rr_7
this.rr_8=create rr_8
this.dw_err=create dw_err
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.st_13
this.Control[iCurrent+3]=this.st_12
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.p_compute
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.dw_cond1
this.Control[iCurrent+8]=this.dw_personal
this.Control[iCurrent+9]=this.dw_total
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.uo_progress
this.Control[iCurrent+13]=this.dw_cond
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_1
this.Control[iCurrent+16]=this.rr_4
this.Control[iCurrent+17]=this.rr_6
this.Control[iCurrent+18]=this.rr_7
this.Control[iCurrent+19]=this.rr_8
this.Control[iCurrent+20]=this.dw_err
end on

on w_pip2110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_10)
destroy(this.p_compute)
destroy(this.st_2)
destroy(this.dw_cond1)
destroy(this.dw_personal)
destroy(this.dw_total)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.uo_progress)
destroy(this.dw_cond)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_4)
destroy(this.rr_6)
destroy(this.rr_7)
destroy(this.rr_8)
destroy(this.dw_err)
end on

type p_mod from w_inherite_standard`p_mod within w_pip2110
boolean visible = false
integer x = 2459
integer y = 2376
end type

type p_del from w_inherite_standard`p_del within w_pip2110
boolean visible = false
integer x = 2633
integer y = 2376
end type

type p_inq from w_inherite_standard`p_inq within w_pip2110
integer x = 4037
end type

event p_inq::clicked;call super::clicked;String  sStartDate,sEndDate,sFromDate,sToDate, sSaup, sJikjong, sKunmu
Integer iRateUp2,iRateDown2

w_mdi_frame.sle_msg.text =""

dw_personal.Reset()
dw_err.Reset()

dw_ip.AcceptText()
dw_cond.AcceptText()

sEndDate = trim(dw_ip.GetItemString(1,"workdate"))
sSaup			= trim(dw_ip.GetItemString(1,"saup")) 
sJikjong		= trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu		= trim(dw_ip.GetItemString(1,"kunmu"))

IF sSaup = '' OR IsNull(sSaup) THEN	sSaup = '%'
IF sJikjong = '' or isnull(sJikjong) THEN	sJikjong = '%'
IF sKunmu = '' OR ISNULL(sKunmu) THEN sKunmu = '%'

IF sEndDate ="" OR IsNull(sEndDate) THEN
	MessageBox("확 인","작업기준일자를 입력하세요!!")
	dw_ip.SetFocus()
	dw_ip.SetColumn('workdate')
	Return
END IF
sStartDate = Left(sEndDate,6) + '01'

iRateUp2   = dw_cond.GetItemNumber(1,"rateup2")
iRateDown2 = dw_cond.GetItemNumber(1,"rateup2")

IF IsNull(iRateUp2) THEN iRateUp2 =0
IF IsNull(iRateDown2) THEN iRateDown2 =0

IF iRateUp2 = 0 AND iRateDown2 = 0 THEN
	MessageBox("확 인","당월 상여 지급율을 입력하세요!!")
	dw_cond.SetColumn("rateup2")
	dw_cond.SetFocus()
	Return
END IF

IF dw_total.Retrieve(Gs_Company,sStartDate,sEndDate,/*sFromDate,sToDate,*/ sSaup, sJikjong, sKunmu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_ip.SetColumn('workdate')	
	dw_ip.SetFocus()
	Return
END IF

wf_magamcheck()
end event

type p_print from w_inherite_standard`p_print within w_pip2110
boolean visible = false
integer x = 1760
integer y = 2376
end type

type p_can from w_inherite_standard`p_can within w_pip2110
boolean visible = false
integer x = 2807
integer y = 2376
end type

type p_exit from w_inherite_standard`p_exit within w_pip2110
integer x = 4393
end type

type p_ins from w_inherite_standard`p_ins within w_pip2110
boolean visible = false
integer x = 1938
integer y = 2376
end type

type p_search from w_inherite_standard`p_search within w_pip2110
boolean visible = false
integer x = 1582
integer y = 2376
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip2110
boolean visible = false
integer x = 2112
integer y = 2376
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip2110
boolean visible = false
integer x = 2286
integer y = 2376
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip2110
boolean visible = false
integer x = 1317
integer y = 2372
end type

type st_window from w_inherite_standard`st_window within w_pip2110
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip2110
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip2110
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip2110
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip2110
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip2110
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip2110
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip2110
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip2110
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip2110
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip2110
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip2110
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip2110
boolean visible = false
end type

type dw_ip from u_key_enter within w_pip2110
integer x = 27
integer y = 172
integer width = 1038
integer height = 608
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip2110_7"
boolean border = false
end type

event itemchanged;call super::itemchanged;if AcceptText() = -1 then return -1

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if dwo.Name = 'workdate' or dwo.Name = 'saup' or dwo.Name = 'jikjong' or dwo.Name = 'kunmu' then
	p_inq.TriggerEvent(Clicked!)
end if
end event

type st_13 from statictext within w_pip2110
integer x = 3410
integer y = 412
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

type st_12 from statictext within w_pip2110
integer x = 2368
integer y = 416
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

type st_10 from statictext within w_pip2110
integer x = 1221
integer y = 416
integer width = 146
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

type p_compute from picture within w_pip2110
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4215
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\Image\계산_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\계산_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\계산_up.gif"
end event

event clicked;String  sYearMonth,sStandardYearMonthDay, smonth, taxyn, goyongyn,sMasterSql,iRtnValue
Integer il_RetrieveRow,il_meterPosition,il_currow,il_SearchRow,il_BefCount =0,k
double iPayRate,srate
/*인사 마스타 자료*/
String  Master_EmpNo,   Master_EmpName, Master_EnterDate

/*급여 계산 flag*/
String  Except_sUseGbn

dw_err.Reset()

dw_ip.AcceptText()
dw_cond.AcceptText()

Is_PbTag= dw_cond.getitemstring(1,"pbtag")
smonth  = string(dw_cond.getitemNumber(1,"applymonth"))
taxyn   = dw_cond.getitemstring(1,"taxyn")
goyongyn = dw_cond.getitemstring(1,"empyn")
srate = dw_cond.getitemNumber(1,"rateup2")
sYearMonth = dw_ip.getitemstring(1,"workym")

sStandardYearMonthDay =  dw_ip.object.workdate[1]

IF dw_ip.object.target[1] = '1' THEN
	dw_Process = dw_Total
	il_RowCount = dw_Total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF il_RowCount <=0 THEN
	MessageBox("확 인","처리 선택한 자료가 없습니다!!")
	Return
END IF

wf_SqlSyntax(sYearMonth)
	
//dw_insert.SetTransObject(SQLCA)
//dw_insert.Modify( "DataWindow.Table.UpdateTable = ~"P3_EDITDATA~"")
//	
/* 처리년월의 상여자료가 있는지 확인*/
SELECT Count("WORKYM")
	INTO :il_BefCount
   FROM "P3_EDITDATA"
   WHERE "WORKYM" = :sYearMonth AND "PBTAG" = :Is_PbTag;
IF SQLCA.SQLCODE = 0 AND il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "이전 상여 계산 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF

//Wf_Get_Year_Amt()													/*입력한 근속년수별 지급율,일정액*/

w_mdi_frame.sle_msg.text = '상여 계산 중......'
SetPointer(HourGlass!)
//uo_progress.Show()
sMasterSql = wf_ProcedureSql()

dw_cond1.AcceptText()
IF dw_cond1.ModifiedCount() > 0 THEN
	IF MessageBox('지급률 변경','지급률 및 지급액이 변경되었습니다.~r~r~n변경된 내역을 적용하시겠습니까?'&
						,Question!,YesNo!) = 1 THEN
		int i
		string year,amt,rate
		For i=1 to dw_cond1.RowCount()
			year = string(dw_cond1.object.year[i])
			year = fill('0',2 - len(year)) + year
			rate = string(dw_cond1.object.rate[i])
			rate = fill('0',3 - len(rate)) + rate
			amt =  string(dw_cond1.object.amt[i])
			amt = fill('0',7 - len(amt)) + amt

			dw_cond1.object.dataname[i] = year + rate + amt
		Next
		
		dw_cond1.update()
		commit;
	END IF
END IF
															
iRtnValue = sqlca.sp_calculation_bonasamount(gs_company,sYearMonth,sStandardYearMonthDay,is_pbtag,&
                                             srate,sMasterSql,taxyn,goyongyn,smonth);

IF iRtnValue <> '1' then
	MessageBox("확 인","상여 계산 실패!! ~r~n"+sqlca.SQLErrText)
	Rollback;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
	Return
END IF
commit;

uo_progress.Hide()
w_mdi_frame.sle_msg.text = '상여 계산 완료!!'
SetPointer(Arrow!)
end event

type st_2 from statictext within w_pip2110
integer x = 96
integer y = 1380
integer width = 581
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "근속년수별지급율"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_cond1 from u_key_enter within w_pip2110
integer x = 64
integer y = 1440
integer width = 969
integer height = 756
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip2110_6"
boolean border = false
end type

type dw_personal from u_d_select_sort within w_pip2110
integer x = 2313
integer y = 468
integer width = 923
integer height = 1680
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip2110_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_total from u_d_select_sort within w_pip2110
integer x = 1152
integer y = 468
integer width = 923
integer height = 1680
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip2110_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type pb_2 from picturebutton within w_pip2110
integer x = 2162
integer y = 924
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
		 sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sKmgubn,sEngineergubn
Long   totRow , sRow,rowcnt
int i

totrow =dw_personal.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_personal.GetItemString(sRow, "empno")
   sEmpName     = dw_personal.GetItemString(sRow, "empname")
	sEnterDate   = dw_personal.GetItemString(sRow, "enterdate")
	sGrade       = dw_personal.GetItemString(sRow, "gradecode")
	sLevel       = dw_personal.GetItemString(sRow, "levelcode")
	sSalary      = dw_personal.GetItemString(sRow, "salary")
	sProjectDept = dw_personal.GetItemString(sRow, "projectcode")
	sDeptCode    = dw_personal.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_personal.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_personal.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_personal.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_personal.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_personal.GetItemString(sRow, "jikjonggubn")
	sKmgubn      = dw_personal.GetItemString(sRow, "kmgubn")
	sEngineergubn  = dw_personal.GetItemString(sRow, "engineergubn")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_total.setitem(rowcnt, "gradecode",   sGrade)
	dw_total.setitem(rowcnt, "levelcode",   sLevel)
	dw_total.setitem(rowcnt, "salary",      sSalary)
	dw_total.setitem(rowcnt, "projectcode", sProjectDept)
	dw_total.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_total.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_total.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
	dw_total.setitem(rowcnt, "kmgubn", sKmgubn)
	dw_total.setitem(rowcnt, "engineergubn", sEngineergubn)
	
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_ip.object.target[1]='2'
ELSE
	dw_ip.object.target[1]='1'
END IF	
end event

type pb_1 from picturebutton within w_pip2110
integer x = 2162
integer y = 792
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
       sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sKmgubn,sEngineergubn
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_total.GetItemString(sRow, "empno")
   sEmpName     = dw_total.GetItemString(sRow, "empname")
	sEnterDate   = dw_total.GetItemString(sRow, "enterdate")
	sGrade       = dw_total.GetItemString(sRow, "gradecode")
	sLevel       = dw_total.GetItemString(sRow, "levelcode")
	sSalary      = dw_total.GetItemString(sRow, "salary")
	sProjectDept = dw_total.GetItemString(sRow, "projectcode")
	sDeptCode    = dw_total.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_total.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_total.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_total.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_total.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_total.GetItemString(sRow, "jikjonggubn")
	sKmgubn      = dw_total.GetItemString(sRow, "kmgubn")
	sEngineergubn  = dw_total.GetItemString(sRow, "engineergubn")
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname",     sEmpName)
	dw_personal.setitem(rowcnt, "empno",       sEmpNo)
	dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_personal.setitem(rowcnt, "gradecode",   sGrade)
	dw_personal.setitem(rowcnt, "levelcode",   sLevel)
	dw_personal.setitem(rowcnt, "salary",      sSalary)
	dw_personal.setitem(rowcnt, "projectcode", sProjectDept)
	dw_personal.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_personal.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_personal.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
	dw_personal.setitem(rowcnt, "kmgubn", sKmgubn)
	dw_personal.setitem(rowcnt, "engineergubn", sEngineergubn)
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_ip.object.target[1]='2'
ELSE
	dw_ip.object.target[1]='1'
END IF	
end event

type uo_progress from u_progress_bar within w_pip2110
integer x = 3483
integer y = 228
integer width = 1083
integer height = 72
integer taborder = 40
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_cond from u_key_enter within w_pip2110
integer x = 27
integer y = 792
integer width = 1047
integer height = 572
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip2110_3"
boolean border = false
end type

event itemchanged;String snull

SetNull(snull)

IF dwo.name = "taxyn" THEN
	IF data ="" OR IsNull(data) THEN Return
	
	IF data <> 'Y' AND data <> 'N' THEN
		MessageBox("확 인","Y 또는 N을 입력하십시요!!")
		this.SetItem(1,"taxyn",snull)
		this.SetFocus()
		Return 1
	END IF
END IF
end event

event itemerror;Return 1
end event

type rr_2 from roundrectangle within w_pip2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 9
integer y = 160
integer width = 1083
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pip2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 1400
integer width = 1024
integer height = 804
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1088
integer y = 332
integer width = 3483
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1147
integer y = 436
integer width = 937
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2304
integer y = 436
integer width = 937
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_8 from roundrectangle within w_pip2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3351
integer y = 436
integer width = 1161
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_err from u_d_select_sort within w_pip2110
integer x = 3360
integer y = 468
integer width = 1102
integer height = 1680
integer taborder = 11
string dataobject = "d_pip2110_2"
boolean hscrollbar = false
boolean border = false
end type

event clicked;call super::clicked;string objname, obj

obj = getobjectatpointer()
objname = f_get_token(obj, '~t')
choose case objname
	case 'p1_master_empno_t'
		setsort('#1 a')
		sort()
	case 'p1_master_empname_t'
		setsort('#2 a')
		sort()
end choose
end event

