$PBExportHeader$w_pu90_00230.srw
$PBExportComments$업체별 마감 전 처리
forward
global type w_pu90_00230 from w_inherite
end type
type dw_cond from u_key_enter within w_pu90_00230
end type
type dw_list from u_d_popup_sort within w_pu90_00230
end type
type pb_1 from u_pb_cal within w_pu90_00230
end type
type pb_2 from u_pb_cal within w_pu90_00230
end type
type cbx_1 from checkbox within w_pu90_00230
end type
type rr_1 from roundrectangle within w_pu90_00230
end type
type rr_2 from roundrectangle within w_pu90_00230
end type
end forward

global type w_pu90_00230 from w_inherite
integer height = 2568
string title = "업체별 마감 전 처리"
dw_cond dw_cond
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
cbx_1 cbx_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pu90_00230 w_pu90_00230

type variables
String LsIoJpNo,LsSuBulDate
string  sCursor
end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();rollback;

dw_list.Reset()   // 출력물 

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

dw_insert.Reset()

//dw_cond.SetItem(1, "saupj", gs_saupj)

f_mod_saupj(dw_cond, 'saupj')

dw_cond.SetItem(1, "yyyymm", left(gs_today,6))
dw_cond.SetItem(1, "seq",    0)
dw_cond.SetItem(1, "sdate",  left(gs_today,4) + '0101')
dw_cond.SetItem(1, "edate", gs_today)
dw_cond.setitem(1, "gubun", '2')

dw_cond.enabled = true
p_inq.enabled = true
p_inq.picturename = "C:\erpman\image\조회_up.gif"

p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\저장_up.gif"

ib_any_typing = False
end subroutine

on w_pu90_00230.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_pu90_00230.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

dw_list.SetTransObject(SQLCA)

Wf_Init()


end event

type dw_insert from w_inherite`dw_insert within w_pu90_00230
integer x = 27
integer y = 364
integer width = 4539
integer height = 1960
integer taborder = 20
string dataobject = "d_pu90_00230_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;Return 1
end event

event dw_insert::itemchanged;String sNull
Setnull(sNull)

if this.getcolumnname() = 'gubun' then
	if gettext() = 'N' then
		this.setitem(row, "yebi1", snull)
	else
		this.setitem(row, "yebi1", dw_cond.GetitemString(1, "yyyymm"))
	end if
end if
end event

event dw_insert::clicked;call super::clicked;If row <= 0 then
	this.SelectRow(0,False)
	Return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF

end event

type p_delrow from w_inherite`p_delrow within w_pu90_00230
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pu90_00230
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pu90_00230
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pu90_00230
boolean visible = false
integer x = 3515
integer y = 4
integer height = 140
end type

event p_ins::clicked;call super::clicked;//Long nRow
//
//IF Wf_RequiredChk(1) = -1 THEN RETURN -1
//IF Wf_RequiredChk(2) = -1 THEN RETURN -1
//
//nRow = dw_insert.InsertRow(0)
//dw_insert.SetFocus()
//dw_insert.ScrollToRow(nRow)
//
//If sCursor = '1' Then
//  dw_insert.SetColumn('itnbr')
//Else
//  dw_insert.SetColumn('itemas_itdsc')
//End If
//
//// 구분 변경 불가
//dw_cond.Object.area_cd.protect = '1'
end event

type p_exit from w_inherite`p_exit within w_pu90_00230
end type

type p_can from w_inherite`p_can within w_pu90_00230
end type

event p_can::clicked;call super::clicked;rollback;

Wf_Init()

end event

type p_print from w_inherite`p_print within w_pu90_00230
integer x = 3401
end type

event p_print::clicked;call super::clicked;Long  iRowCount
string	sYearMonth, sscvcod,sgubun,tx_name1

if dw_cond.AcceptText() = -1 then return 

////////////////////////////////////////////////////////////////////////////

sgubun     	= dw_cond.GetItemString(1, "magbn")
sYearMonth 	= trim(dw_cond.GetItemString(1, "yyyymm"))
sScvcod	  	= trim(dw_cond.GetItemString(1, "scvcod"))

IF isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[마감년월]')
	dw_cond.SetColumn("yyyymm")
	dw_cond.SetFocus()
	RETURN
END IF

IF sScvcod = ''  or isNull(sScvcod) THEN
	f_message_chk(30,'[거래처]')
	dw_cond.SetColumn("scvcod")
	dw_cond.SetFocus()
	RETURN
END IF

IF MessageBox("확 인","거래내역을 출력하시겠습니까?",Question!,YesNo!) = 1 THEN 

	iRowCount = dw_list.Retrieve(gs_sabu,sYearMonth, sScvcod)
	
	If iRowCount > 0 Then
	  dw_list.object.datawindow.print.preview="yes"
	  gi_page = dw_list.GetItemNumber(1,"last_page")

     tx_name1 = Trim(dw_cond.Describe("Evaluate('LookUpDisplay(scvnas) ', 1)"))

     dw_list.Modify("tx_yymm.text = '"+Left(sYearMonth,4) + '.' + right(sYearMonth,2)+"'")
     dw_list.Modify("tx_cvcod.text = '"+tx_name1+"'")
	
	  OpenWithParm(w_print_options, dw_list)
   End If
END IF

end event

type p_inq from w_inherite`p_inq within w_pu90_00230
integer x = 3922
end type

event p_inq::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
string	sYearMonth, sDateFrom, sDateTo,	&
			sTitle,	sNull, sscvcod, sEcvcod, sError, smagam, sGubun, ssaupj, sEmpno
Double	diseq, dcnt
long		lRow, lRowCount
int		iSeq

if dw_cond.AcceptText() = -1 then return 

////////////////////////////////////////////////////////////////////////////

sgubun     	= dw_cond.GetItemString(1, "magbn")
sYearMonth 	= trim(dw_cond.GetItemString(1, "yyyymm"))
sDateFrom  	= trim(dw_cond.GetItemString(1, "sdate"))
sDateTo    	= trim(dw_cond.GetItemString(1, "edate"))
sScvcod	  	= trim(dw_cond.GetItemString(1, "scvcod"))
sEcvcod    	= trim(dw_cond.GetItemString(1, "ecvcod"))
iSeq		  	= dw_cond.GetItemNumber(1, "seq")

sSaupj     	= dw_cond.GetItemString(1, "saupj")
sEmpno     	= trim(dw_cond.GetItemString(1, "empno"))

IF 	isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[마감년월]')
	dw_cond.SetColumn("yyyymm")
	dw_cond.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or sEmpno = "" 		THEN	sEmpno = '%'
IF isnull(sEcvcod) or sEcvcod = "" 	THEN	sEcvcod = 'ZZZZZZ'

// 마감처리
IF 	isnull(sSaupj) or sSaupj = "" 	THEN
	f_message_chk(30,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	RETURN
END IF

IF 	f_datechk(sDateFrom) = -1 	THEN
	f_message_chk(30,'[마감시작일]')
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	RETURN
END IF

IF 	f_datechk(sDateTo) = -1 	THEN
	f_message_chk(30,'[마감종료일]')
	dw_cond.SetColumn("edate")
	dw_cond.SetFocus()
	RETURN
END IF
IF sScvcod = ''  or isNull(sScvcod) THEN
	f_message_chk(30,'[거래처]')
	dw_cond.SetColumn("scvcod")
	dw_cond.SetFocus()
	RETURN
END IF

if dw_insert.retrieve(gs_sabu, sYearmonth, sScvcod, sDatefrom , sDateTo, sSaupj) < 1 then
	f_message_chk(50, '[ 자료가 없습니다!! ]')
	return
end if

//dw_cond.enabled = false
//p_inq.enabled = false
//p_inq.picturename = "C:\erpman\image\조회_d.gif"
//
//p_mod.enabled = true
//p_mod.picturename = "C:\erpman\image\저장_up.gif"
//
//p_delrow.enabled = false
//p_delrow.picturename = "C:\erpman\image\행삭제_up.gif"
//
//p_del.enabled = false
//p_del.picturename = "C:\erpman\image\삭제_up.gif"

end event

type p_del from w_inherite`p_del within w_pu90_00230
boolean visible = false
integer x = 3712
integer y = 20
end type

event p_del::clicked;call super::clicked;//Long nRow, iCnt
//String sSudat
//
//nRow = dw_insert.GetRow()
//If nRow <= 0 Then Return
//
///* 매출마감시 송장 발행 안함 */
//sSudat = dw_cond.GetItemString(1, 'sudat')
//
//SELECT COUNT(*)  INTO :icnt
// FROM "JUNPYO_CLOSING"  
//WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
//		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;
//
//If iCnt >= 1 then
//	f_message_chk(60,'[매출마감]')
//	Return
//End if
//
//IF MessageBox("삭 제","출고송장 자료가 삭제됩니다." +"~n~n" +&
//           	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
//
//Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
//	Case New!,NewModified!
//		dw_insert.DeleteRow(nRow)
//	Case Else
//		dw_insert.DeleteRow(nRow)
//      If dw_insert.Update() <> 1 Then
//        RollBack;
//        Return
//      End If
//      Commit;
//END CHOOSE
//
//If dw_insert.RowCount() = 0 Then	p_can.TriggerEvent(Clicked!)
//	
//w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다.!!'
//ib_any_typing = False
//
end event

type p_mod from w_inherite`p_mod within w_pu90_00230
integer x = 4096
end type

event p_mod::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_insert.AcceptText() = -1		THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

if dw_insert.update() = 1 then
	commit;
	
	String ls_ymd
	String ls_sdt
	String ls_edt
	
	ls_ymd = dw_cond.GetItemString(1, 'yyyymm')
	ls_sdt = dw_cond.GetItemString(1, 'sdate' )
	ls_edt = dw_cond.GetItemString(1, 'edate' )
	
	dw_insert.ReSet()
	dw_cond.ReSet()
	
	dw_cond.InsertRow(0)
	
	f_mod_saupj(dw_cond, 'saupj')
	
	dw_cond.SetItem(1, 'yyyymm', ls_ymd)
	dw_cond.SetItem(1, 'seq'   , 0     )
	dw_cond.SetItem(1, 'sdate' , ls_sdt)
	dw_cond.SetItem(1, 'edate' , ls_edt)
	dw_cond.SetItem(1, 'gubun' , '2'   )
   
	ib_any_typing = False
else
	rollback;
	f_rollback()
	Return
end if

//p_can.TriggerEvent("clicked")
//SetPointer(Arrow!)
//
end event

type cb_exit from w_inherite`cb_exit within w_pu90_00230
integer x = 3255
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_pu90_00230
integer x = 2213
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_pu90_00230
integer x = 3360
integer y = 5000
integer taborder = 40
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_pu90_00230
integer x = 2560
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_pu90_00230
integer x = 3008
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_pu90_00230
integer x = 3936
integer y = 5000
integer width = 439
boolean enabled = false
string text = "송장출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_pu90_00230
end type

type cb_can from w_inherite`cb_can within w_pu90_00230
integer x = 2907
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_pu90_00230
integer x = 992
integer y = 2676
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pu90_00230
end type

type gb_button2 from w_inherite`gb_button2 within w_pu90_00230
end type

type dw_cond from u_key_enter within w_pu90_00230
event ue_key pbm_dwnkey
integer x = 59
integer y = 36
integer width = 3026
integer height = 212
integer taborder = 10
string dataobject = "d_pu90_00230_0"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
//ElseIf KeyDown(KeyEnter!) Then
//	If GetColumnName() = 'cvcod' Then
//		If dw_insert.rowcount() = 0 and rb_1.Checked = True Then
//		  p_ins.PostEvent(Clicked!)
//        Return 1
//	   End If
//	End If
END IF

end event

event itemerror;
Return 1
end event

event itemchanged;string	sNull, sDate, sYYMM, sYm, SMAGAM, sGubun, ssaupj, sScvcod,get_nm, s_name
long     get_seq, ireturn

SetNull(sNull)
sSaupj 	= dw_cond.GetItemString(1,'saupj')

IF this.GetColumnName() = 'yyyymm' THEN

	sDate  	= trim(this.GetItemString(1, "sdate"))
	sGubun 	= this.GetItemString(1, "magbn")
	
	sYm   		= trim(this.gettext())
	sYYMM 	= sYm + '01'
	IF 	f_datechk(sYYMM) = -1	then
		this.setitem(1, "yyyymm", sNull)
		return 1
	END IF
 
	
END IF

// 마감시작일
IF this.GetColumnName() = 'sdate' THEN

	sYYMM = trim(this.GetItemString(1, "yyyymm")) + '01'
	
	sDate = trim(this.gettext())
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
END IF

// 마감종료일
IF this.GetColumnName() = 'edate' THEN

	sDate = trim(this.gettext())
	
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
elseif getcolumnname() = 'saupj' then
	sdate = gettext()
	f_child_saupj(dw_cond, 'empno', sdate)
END IF


IF this.GetColumnName() = "scvcod" THEN
	sScvcod = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', sScvcod, get_nm, s_name)
	this.setitem(1, "scvcod", sScvcod)	
	this.setitem(1, "scvnas", get_nm)	
end if


end event

event rbuttondown;// 거래처
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'scvcod'	THEN
   gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"scvcod",gs_code)
	SetItem(1,"scvnas",gs_codename)
ELSEIF this.GetColumnName() = 'ecvcod'	THEN
   gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"ecvcod",gs_code)
END IF

end event

type dw_list from u_d_popup_sort within w_pu90_00230
boolean visible = false
integer x = 1216
integer y = 2444
integer width = 823
integer height = 116
integer taborder = 0
boolean enabled = false
boolean titlebar = true
string title = "마감전 처리"
string dataobject = "d_pu90_00230_p1"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

type pb_1 from u_pb_cal within w_pu90_00230
integer x = 2158
integer y = 52
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_pu90_00230
integer x = 2597
integer y = 52
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'edate', gs_code)

end event

type cbx_1 from checkbox within w_pu90_00230
integer x = 64
integer y = 280
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;long ix
String sStatus,sNull

Setnull(sNull)

IF This.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

dw_insert.setredraw(false)
For ix = 1 To dw_insert.RowCount()
    dw_insert.SetItem(ix,'gubun',sStatus)
	 
	if sStatus = 'N' then
		dw_insert.setitem(ix, "yebi1", snull)
	else
		dw_insert.setitem(ix, "yebi1", dw_cond.GetitemString(1, "yyyymm"))
	end if
Next
dw_insert.setredraw(true)
end event

type rr_1 from roundrectangle within w_pu90_00230
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 356
integer width = 4590
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu90_00230
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 24
integer width = 3086
integer height = 236
integer cornerheight = 40
integer cornerwidth = 46
end type

