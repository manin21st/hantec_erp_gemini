$PBExportHeader$w_pip2014.srw
$PBExportComments$** 년월차수당계산
forward
global type w_pip2014 from w_inherite_standard
end type
type dw_update from datawindow within w_pip2014
end type
type dw_1 from datawindow within w_pip2014
end type
type st_10 from statictext within w_pip2014
end type
type st_9 from statictext within w_pip2014
end type
type st_8 from statictext within w_pip2014
end type
type dw_personal from u_d_select_sort within w_pip2014
end type
type dw_total from u_d_select_sort within w_pip2014
end type
type pb_2 from picturebutton within w_pip2014
end type
type pb_1 from picturebutton within w_pip2014
end type
type uo_progress from u_progress_bar within w_pip2014
end type
type sle_end from singlelineedit within w_pip2014
end type
type st_5 from statictext within w_pip2014
end type
type st_4 from statictext within w_pip2014
end type
type sle_start from singlelineedit within w_pip2014
end type
type p_compute from picture within w_pip2014
end type
type rr_1 from roundrectangle within w_pip2014
end type
type rr_2 from roundrectangle within w_pip2014
end type
type rr_4 from roundrectangle within w_pip2014
end type
type ln_3 from line within w_pip2014
end type
type rr_5 from roundrectangle within w_pip2014
end type
type rr_6 from roundrectangle within w_pip2014
end type
type rr_7 from roundrectangle within w_pip2014
end type
type dw_ip from u_key_enter within w_pip2014
end type
type dw_err from u_d_select_sort within w_pip2014
end type
end forward

global type w_pip2014 from w_inherite_standard
string title = "년차수당계산"
boolean resizable = false
event ue_process pbm_custom04
dw_update dw_update
dw_1 dw_1
st_10 st_10
st_9 st_9
st_8 st_8
dw_personal dw_personal
dw_total dw_total
pb_2 pb_2
pb_1 pb_1
uo_progress uo_progress
sle_end sle_end
st_5 st_5
st_4 st_4
sle_start sle_start
p_compute p_compute
rr_1 rr_1
rr_2 rr_2
rr_4 rr_4
ln_3 ln_3
rr_5 rr_5
rr_6 rr_6
rr_7 rr_7
dw_ip dw_ip
dw_err dw_err
end type
global w_pip2014 w_pip2014

type variables
DataWindow dw_Process

Integer           il_RowCount,iAry_EditChild =0
String             Is_PbTag = 'P'
Double          Id_NoTax_Sub = 0                     //비과세공제
end variables

forward prototypes
public function string wf_proceduresql ()
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

event open;call super::open;
//dw_datetime.SetTransObject(SQLCA)
//dw_datetime.Reset()
//dw_datetime.InsertRow(0)
 
dw_total.settransobject(SQLCA)
dw_personal.settransobject(SQLCA)
dw_err.settransobject(SQLCA)

dw_insert.settransobject(SQLCA)

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

uo_progress.Hide()

dw_ip.SetItem(1,"workmonth",String(Left(gs_today,6)))
dw_ip.SetItem(1,"target",'1')
dw_ip.SetColumn('workmonth')
dw_ip.SetItem(1,"yearvac",'1')
dw_ip.SetItem(1,"monthvac",'0')
dw_ip.SetItem(1,"employ",'0')
dw_ip.SetItem(1,"taxcal",'0')

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

dw_ip.SetFocus()
dw_err.reset()

pb_1.picturename ="C:\erpman\Image\next.gif"
pb_2.picturename = "C:\erpman\Image\prior.gif"




end event

on w_pip2014.create
int iCurrent
call super::create
this.dw_update=create dw_update
this.dw_1=create dw_1
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.dw_personal=create dw_personal
this.dw_total=create dw_total
this.pb_2=create pb_2
this.pb_1=create pb_1
this.uo_progress=create uo_progress
this.sle_end=create sle_end
this.st_5=create st_5
this.st_4=create st_4
this.sle_start=create sle_start
this.p_compute=create p_compute
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_4=create rr_4
this.ln_3=create ln_3
this.rr_5=create rr_5
this.rr_6=create rr_6
this.rr_7=create rr_7
this.dw_ip=create dw_ip
this.dw_err=create dw_err
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_update
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_10
this.Control[iCurrent+4]=this.st_9
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.dw_personal
this.Control[iCurrent+7]=this.dw_total
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.uo_progress
this.Control[iCurrent+11]=this.sle_end
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.sle_start
this.Control[iCurrent+15]=this.p_compute
this.Control[iCurrent+16]=this.rr_1
this.Control[iCurrent+17]=this.rr_2
this.Control[iCurrent+18]=this.rr_4
this.Control[iCurrent+19]=this.ln_3
this.Control[iCurrent+20]=this.rr_5
this.Control[iCurrent+21]=this.rr_6
this.Control[iCurrent+22]=this.rr_7
this.Control[iCurrent+23]=this.dw_ip
this.Control[iCurrent+24]=this.dw_err
end on

on w_pip2014.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_update)
destroy(this.dw_1)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.dw_personal)
destroy(this.dw_total)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.uo_progress)
destroy(this.sle_end)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_start)
destroy(this.p_compute)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_4)
destroy(this.ln_3)
destroy(this.rr_5)
destroy(this.rr_6)
destroy(this.rr_7)
destroy(this.dw_ip)
destroy(this.dw_err)
end on

type p_mod from w_inherite_standard`p_mod within w_pip2014
boolean visible = false
integer x = 2542
integer y = 2372
end type

type p_del from w_inherite_standard`p_del within w_pip2014
boolean visible = false
integer x = 2715
integer y = 2372
end type

type p_inq from w_inherite_standard`p_inq within w_pip2014
integer x = 3922
end type

event p_inq::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String sYymm, sjjgubn, sKunmu, sSaup

dw_total.Reset()
dw_personal.Reset()
dw_err.Reset()

if dw_ip.Accepttext() = -1 then return -1

sYymm  = trim(dw_ip.GetItemString(1,"workmonth"))
sjjgubn = dw_ip.GetItemString(1,"jikjong")
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))
sSaup = trim(dw_ip.GetItemString(1,"saup"))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
if sjjgubn = '' or isnull(sjjgubn) then sjjgubn = "%"
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

IF sYymm = "" OR IsNull(sYymm) THEN
	MessageBox("확 인","처리년월을 입력하세요!!")
	dw_ip.SetColumn('workmonth')
	dw_ip.SetFocus()
	Return
END IF
//MessageBox('확인하여 보거라!!',Gs_Company+','+sYymm+','+sjjgubn+','+sSaup+','+sKunmu)
IF dw_total.Retrieve(Gs_Company,sYymm, sjjgubn, sSaup, sKunmu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_ip.SetColumn('workmonth')
	dw_ip.SetFocus()
	Return
END IF


end event

type p_print from w_inherite_standard`p_print within w_pip2014
boolean visible = false
integer x = 1842
integer y = 2372
end type

type p_can from w_inherite_standard`p_can within w_pip2014
integer x = 4270
end type

type p_exit from w_inherite_standard`p_exit within w_pip2014
integer x = 4443
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

type p_ins from w_inherite_standard`p_ins within w_pip2014
boolean visible = false
integer x = 2021
integer y = 2372
end type

type p_search from w_inherite_standard`p_search within w_pip2014
boolean visible = false
integer x = 1664
integer y = 2372
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip2014
boolean visible = false
integer x = 2194
integer y = 2372
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip2014
boolean visible = false
integer x = 2368
integer y = 2372
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip2014
boolean visible = false
integer x = 1399
integer y = 2368
end type

type st_window from w_inherite_standard`st_window within w_pip2014
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip2014
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip2014
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip2014
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip2014
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip2014
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip2014
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip2014
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip2014
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip2014
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip2014
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip2014
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip2014
boolean visible = false
end type

type dw_update from datawindow within w_pip2014
boolean visible = false
integer x = 1417
integer y = 2720
integer width = 837
integer height = 100
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "년차일수갱신"
string dataobject = "d_pip2014_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_1 from datawindow within w_pip2014
boolean visible = false
integer x = 466
integer y = 2728
integer width = 837
integer height = 100
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "년차수당계산"
string dataobject = "d_pip2014_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type st_10 from statictext within w_pip2014
integer x = 2432
integer y = 444
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

type st_9 from statictext within w_pip2014
integer x = 1509
integer y = 444
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

type st_8 from statictext within w_pip2014
integer x = 512
integer y = 444
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

type dw_personal from u_d_select_sort within w_pip2014
integer x = 1477
integer y = 496
integer width = 827
integer height = 1696
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip2014_1"
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

type dw_total from u_d_select_sort within w_pip2014
integer x = 471
integer y = 496
integer width = 827
integer height = 1696
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pip2014_1"
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

type pb_2 from picturebutton within w_pip2014
integer x = 1335
integer y = 912
integer width = 101
integer height = 88
integer taborder = 60
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

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sAddDeptCode,sDeptCode,&
		 sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate , sKdate, sKdateTo
Long   totRow , sRow,rowcnt
int    sYDay, sBDay ,sSDay ,sJDay,	sCDay, sKDay,sAddDay,sYearDay
int i

totrow =dw_personal.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_personal.GetItemString(sRow, "empno")
   sEmpName     = dw_personal.GetItemString(sRow, "empname")
	sEnterDate   = dw_personal.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_personal.GetItemString(sRow, "retiredate")
//	sLevel       = dw_personal.GetItemString(sRow, "levelcode")
//	sSalary      = dw_personal.GetItemString(sRow, "salary")
	sAddDeptCode = dw_personal.GetItemString(sRow, "adddeptcode")
//	sDeptCode    = dw_personal.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_personal.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_personal.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_personal.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_personal.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_personal.GetItemString(sRow, "jikjonggubn")

	sYDay        = dw_personal.GetItemNumber(sRow, "yday")
	sBDay        = dw_personal.GetItemNumber(sRow, "bday")
	sSDay        = dw_personal.GetItemNumber(sRow, "sday")
	sJDay        = dw_personal.GetItemNumber(sRow, "jday")
	sCDay        = dw_personal.GetItemNumber(sRow, "cday")
	sKDay        = dw_personal.GetItemNumber(sRow, "kday")
//	sAddDay      = dw_personal.GetItemNumber(sRow, "addday")
//	sYearDay     = dw_personal.GetItemNumber(sRow, "yearday")	
//	sKdate       = dw_personal.GetItemString(sRow, "kdate")	
//	sKdateTo     = dw_personal.GetItemString(sRow, "kdateto")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_total.setitem(rowcnt, "retiredate",  sRetireDate)
//	dw_total.setitem(rowcnt, "levelcode",   sLevel)
//	dw_total.setitem(rowcnt, "salary",      sSalary)
	dw_total.setitem(rowcnt, "adddeptcode", sAddDeptCode)
//	dw_total.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_total.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_total.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_total.setitem(rowcnt, "yday", sYDay)
	dw_total.setitem(rowcnt, "bday", sBDay)
	dw_total.setitem(rowcnt, "sday", sSDay)
	dw_total.setitem(rowcnt, "jday", sJDay)
	dw_total.setitem(rowcnt, "cday", sCDay)
	dw_total.setitem(rowcnt, "kday", sKDay)
//	dw_total.setitem(rowcnt, "addday", sAddDay)
//	dw_total.setitem(rowcnt, "yearday", sYearDay)
//	dw_total.setitem(rowcnt, "kdate", sKdate)
//	dw_total.setitem(rowcnt, "kdateto", sKdateTo)
	
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_ip.SetItem(1,"target",'2')
ELSE
	dw_ip.SetItem(1,"target",'1')
END IF	
end event

type pb_1 from picturebutton within w_pip2014
integer x = 1335
integer y = 812
integer width = 101
integer height = 88
integer taborder = 60
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

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sAddDeptCode,sDeptCode,&
       sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate,sKdate, sKdateTo
Long   totRow , sRow,rowcnt 
int    sYDay, sBDay ,sSDay ,sJDay,	sCDay, sKDay,sAddDay,sYearDay
int    i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_total.GetItemString(sRow, "empno")
   sEmpName     = dw_total.GetItemString(sRow, "empname")
	sEnterDate   = dw_total.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_total.GetItemString(sRow, "retiredate")
//	sLevel       = dw_total.GetItemString(sRow, "levelcode")
//	sSalary      = dw_total.GetItemString(sRow, "salary")
	sAddDeptCode = dw_total.GetItemString(sRow, "AddDeptCode")
//	sDeptCode    = dw_total.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_total.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_total.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_total.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_total.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_total.GetItemString(sRow, "jikjonggubn")
	
	sYDay        = dw_total.GetItemNumber(sRow, "yday")
	sBDay        = dw_total.GetItemNumber(sRow, "bday")
	sSDay        = dw_total.GetItemNumber(sRow, "sday")
	sJDay        = dw_total.GetItemNumber(sRow, "jday")
	sCDay        = dw_total.GetItemNumber(sRow, "cday")
	sKDay        = dw_total.GetItemNumber(sRow, "kday")
//	sAddDay      = dw_total.GetItemNumber(sRow, "addday")
//	sYearDay     = dw_total.GetItemNumber(sRow, "yearday")
//	sKdate       = dw_total.GetItemString(sRow, "kdate")	
//	sKdateTo     = dw_total.GetItemString(sRow, "kdateto")		
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname",     sEmpName)
	dw_personal.setitem(rowcnt, "empno",       sEmpNo)
	dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_personal.setitem(rowcnt, "retiredate",  sRetireDate)
//	dw_personal.setitem(rowcnt, "levelcode",   sLevel)
//	dw_personal.setitem(rowcnt, "salary",      sSalary)
	dw_personal.setitem(rowcnt, "AddDeptCode", sAddDeptCode)
//	dw_personal.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_personal.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_personal.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_personal.setitem(rowcnt, "yday", sYDay)
	dw_personal.setitem(rowcnt, "bday", sBDay)
	dw_personal.setitem(rowcnt, "sday", sSDay)
	dw_personal.setitem(rowcnt, "jday", sJDay)
	dw_personal.setitem(rowcnt, "cday", sCDay)
	dw_personal.setitem(rowcnt, "kday", sKDay)
//	dw_personal.setitem(rowcnt, "addday", sAddDay)
//	dw_personal.setitem(rowcnt, "yearday", sYearDay)
//	dw_personal.setitem(rowcnt, "kdate", sKdate)
//	dw_personal.setitem(rowcnt, "kdateto", sKdateTo)	
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_ip.SetItem(1,"target",'2')
ELSE
	dw_ip.SetItem(1,"target",'1')
END IF	
end event

type uo_progress from u_progress_bar within w_pip2014
integer x = 2734
integer y = 2256
integer width = 1083
integer height = 72
integer taborder = 70
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type sle_end from singlelineedit within w_pip2014
integer x = 3543
integer y = 240
integer width = 279
integer height = 56
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type st_5 from statictext within w_pip2014
integer x = 3305
integer y = 248
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "완료시간"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pip2014
integer x = 3305
integer y = 144
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "시작시간"
boolean focusrectangle = false
end type

type sle_start from singlelineedit within w_pip2014
integer x = 3543
integer y = 136
integer width = 279
integer height = 56
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type p_compute from picture within w_pip2014
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4096
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

event clicked;w_mdi_frame.sle_msg.text =""

String  sYearMonth,sYearMonthDay, syymm,goyong,taxyn,pbtag,ymgubn
Integer iPayRate,il_RetrieveRow,il_meterPosition,il_currow,il_SearchRow,il_BefCount =0,k,il_UpdateRow
integer iRtnValue

/*인사 마스타 자료*/
String  Master_EmpNo,   Master_EmpName,sMasterSql

/*년차 계산 flag*/
String  Except_sUseGbn 

sYearMonth    = trim(dw_ip.GetItemString(1,"workmonth"))
syymm         = trim(dw_ip.GetItemString(1,"workmonth"))

if Right(syymm,2) <> '12' then
  if messagebox("확인","12월이 아닌데도 작업하시겠습니까?",Question!,YesNo!) = 2 then return
end if;

IF dw_ip.GetItemString(1,'target') = '1' THEN
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
/* 처리년월의 년차자료가 있는지 확인*/
SELECT Count("WORKYM")
	INTO :il_BefCount
   FROM "P3_YEARAMT"
   WHERE ("COMPANYCODE" = :gs_company) and  "YYMM" = :sYearMonth ;
IF SQLCA.SQLCODE = 0 AND il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "이전 년차 계산 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF
w_mdi_frame.sle_msg.text = '년차 계산 중......'
SetPointer(HourGlass!)

sle_start.text = String(Now(),'hh:mm:ss AM/PM')

sMasterSql = wf_ProcedureSql()
	
if dw_ip.GetItemString(1,"employ") = '1' then
   goyong = 'Y'
else
   goyong = 'N'
end if
if dw_ip.GetItemString(1,"taxcal") = '1' then
   taxyn = 'Y'
else
	taxyn = 'N'
end if
if dw_ip.GetItemString(1,"yearvac") = '1' then
	pbtag = 'Y'
	ymgubn = '1'
elseif dw_ip.GetItemString(1,"monthvac") = '1' then
	pbtag = 'M'
	ymgubn = '2'
end if
iRtnValue = sqlca.sp_calculation_yearamt(gs_company, sYearMonth,pbtag,sMasterSql,ymgubn,goyong,taxyn);

IF iRtnValue <> 1 then
	MessageBox("확 인","계산 실패!!")
	Rollback;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
	Return
END IF
commit;

//dw_update.reset()
//
////il_UpdateRow = dw_update.Retrieve(gs_company,sYymm)
///* 전체 자료처리시 삭제*/
//IF rb_all.Checked = True THEN
//	DELETE FROM "P3_YEARAMT"  
//   WHERE ( "P3_YEARAMT"."COMPANYCODE" = :gs_company ) AND  
//         ( "P3_YEARAMT"."YYMM" = :sYearMonth)  ;
//	COMMIT;		
//END IF	
//SetPointer(HourGlass!)
//
//sle_start.text = String(Now(),'hh:mm:ss AM/PM')
//
//wf_SqlSyntax(sYearMonth)
//
//dw_insert.SetTransObject(SQLCA)
//dw_insert.Modify( "DataWindow.Table.UpdateTable = ~"P3_YEARAMT~"")
//
//il_RetrieveRow = dw_insert.Retrieve() 											//이전 처리 건수
//
//uo_progress.Show()
//
//FOR k = 1 TO il_RowCount
//	Master_EmpNo   	      = dw_Process.GetItemString(k,"empno")
//	Master_EmpName		      = dw_Process.GetItemString(k,"empname") 
//	
//	//지급일수 계산
//	Str_Yearamt.YDay        = dw_Process.GetItemNumber(k, "yday")     /* 이월일수  */
//	Str_Yearamt.BDay        = dw_Process.GetItemNumber(k, "bday")     /* 발생일수  */
// 	Str_Yearamt.SDay        = dw_Process.GetItemNumber(k, "sday")	   /* 사용일수  */
//	Str_Yearamt.JDay        = dw_Process.GetItemNumber(k, "jday")		/* 잔여일수  */
//	Str_Yearamt.CDay        = dw_Process.GetItemNumber(k, "cday")	   /* 적치일수  */
// 	Str_Yearamt.KDay        = dw_Process.GetItemNumber(k, "kday")		/* 지급일수  */
//	Str_Yearamt.AddDay      = dw_Process.GetItemNumber(k, "addday")   /* 누적일수  */
//	Str_Yearamt.YearDay     = dw_Process.GetItemNumber(k, "yearday")	/* 년차일수  */
//	Str_Yearamt.Kdate       = dw_Process.GetItemString(k, "kdate")		/* 사용기간(From)  */
//	Str_Yearamt.KdateTo     = dw_Process.GetItemString(k, "kdateto")	/* 사용기간(To)  */
//	
//	//년차사용일수 재계산
//	//Str_Yearamt.SDay = wf_calc_useday(Master_EmpNo,sYearMonth)
//	
//	//지급일수 
//	//Str_Yearamt.KDay = (Str_Yearamt.YDay + Str_Yearamt.BDay + Str_Yearamt.AddDay ) - Str_Yearamt.SDay
//	
//	il_meterPosition = (k/ il_RowCount) * 100
//	uo_progress.uf_set_position (il_meterPosition)	
//	
//	IF il_RetrieveRow > 0 THEN															/*이전자료 삭제*/
//		il_SearchRow = dw_insert.Find("empno = '"+Master_EmpNo+"'",1,il_RetrieveRow)
//		IF il_SearchRow > 0 THEN
//			dw_insert.DeleteRow(il_SearchRow)	
//		END IF
//	END IF
//
//	
//   IF Wf_Personal_Read(Master_EmpNo) = -1 THEN CONTINUE						/*개인별 급여자료*/ 
//	
//	Wf_calc_amt(k,Master_EmpNo,sYearMonth)											/*년차 계산*/ 
//	
//	IF Str_YearAMt.NetPayAmt > 10 THEN
//		il_CurRow = dw_insert.InsertRow(dw_insert.RowCount() + 1)
//		
//		Wf_Insert_YearAmt(k,il_Currow,Master_EmpNo,sYearMonth)
//	END IF
//	/*일수 갱신*/
//	
//	//IF il_UpdateRow > 0 THEN															/*이전자료 삭제*/
//	//	il_SearchRow = dw_update.Find("empno = '"+Master_EmpNo+"'",1,il_UpdateRow)
//	//	IF il_SearchRow > 0 THEN
//	//		dw_update.setitem(il_SearchRow,"sday",Str_Yearamt.SDay )	
//	//		dw_update.setitem(il_SearchRow,"jday",Str_Yearamt.JDay )	
//	//		dw_update.setitem(il_SearchRow,"cday",Str_Yearamt.CDay )	
//	//		dw_update.setitem(il_SearchRow,"kday",Str_Yearamt.KDay )	
//	//	END IF
//	//END IF
//	
//NEXT
//
//IF dw_insert.Update() <> 1 THEN
//	MessageBox("확 인","자료 저장을 실패하였습니다(금액)!!")
//	Rollback;
//	Return
//ELSE
//	//IF dw_update.Update() <> 1 THEN
//	//	MessageBox("확 인","자료 저장을 실패하였습니다(일수)!!")
//	//	Rollback;
//	//	Return
//	//END IF
//END IF
//COMMIT;
//
//uo_progress.Hide()
//
w_mdi_frame.sle_msg.text = '계산 완료!!'
SetPointer(Arrow!)

sle_end.text = String(Now(),'hh:mm:ss AM/PM')
end event

type rr_1 from roundrectangle within w_pip2014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 366
integer y = 32
integer width = 3534
integer height = 340
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip2014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 398
integer y = 408
integer width = 3479
integer height = 1828
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip2014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3255
integer y = 92
integer width = 617
integer height = 244
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_3 from line within w_pip2014
integer linethickness = 1
integer beginx = 3538
integer beginy = 296
integer endx = 3822
integer endy = 296
end type

type rr_5 from roundrectangle within w_pip2014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 457
integer y = 464
integer width = 855
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip2014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1463
integer y = 464
integer width = 855
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip2014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2391
integer y = 464
integer width = 1440
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from u_key_enter within w_pip2014
event ue_key pbm_dwnkey
integer x = 389
integer y = 76
integer width = 2862
integer height = 264
integer taborder = 11
string title = "none"
string dataobject = "d_pip2014_5"
boolean border = false
end type

event ue_key;IF KeyDown(KeyF1!) THEN
	TriggerEvent(RButtonDown!)
END IF
end event

event itemchanged;call super::itemchanged;//String  sEmpNo,SetNull,sEmpName

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF GetColumnName() = "yearvac" and GetItemString(1,"yearvac") = '0' then
	dw_total.DataObject  = "d_pip2014_1" 
	dw_personal.DataObject  = "d_pip2014_1" 
	dw_total.Settransobject(sqlca)
	dw_personal.Settransobject(sqlca)
	p_inq.Triggerevent(Clicked!)
	if GetItemString(1,"monthvac") = '1' then
		SetItem(1,"monthvac",'0')
	end if
END IF

IF GetColumnName() = "monthvac" and GetItemString(1,"monthvac") = '0' then
	dw_total.DataObject  = "d_pip2014_1m" 
	dw_personal.DataObject  = "d_pip2014_1m" 
	dw_total.Settransobject(sqlca)
	dw_personal.Settransobject(sqlca)
	p_inq.Triggerevent(Clicked!)
	if GetItemString(1,"yearvac") = '1' then
		SetItem(1,"yearvac",'0')
	end if
END IF

IF GetColumnName() = "taxcal" and GetItemString(1,"taxcal") = '0' then
	if GetItemString(1,"yearvac") = '1' then
		SetItem(1,"monthvac",'0')
	elseif GetItemString(1,"yearvac") = '0' then
		SetItem(1,"yearvac",'1')
	end if
END IF

IF dwo.Name = "saup" OR dwo.Name = "jikjong" OR dwo.Name = "kunmu" then &
	p_inq.Triggerevent(Clicked!)
end event

type dw_err from u_d_select_sort within w_pip2014
integer x = 2400
integer y = 496
integer width = 1426
integer height = 1696
integer taborder = 11
string dataobject = "d_pip2014_2"
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

