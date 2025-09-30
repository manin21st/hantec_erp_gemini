$PBExportHeader$w_qa01_00050.srw
$PBExportComments$** 출하검사등록
forward
global type w_qa01_00050 from w_inherite
end type
type cb_1 from commandbutton within w_qa01_00050
end type
type dw_ip from datawindow within w_qa01_00050
end type
type rb_insert from radiobutton within w_qa01_00050
end type
type rb_delete from radiobutton within w_qa01_00050
end type
type dw_imhist_out from datawindow within w_qa01_00050
end type
type p_list from uo_picture within w_qa01_00050
end type
type dw_imhist_nitem_out from datawindow within w_qa01_00050
end type
type dw_imhist_nitem_in from datawindow within w_qa01_00050
end type
type p_sort from picture within w_qa01_00050
end type
type cb_3 from commandbutton within w_qa01_00050
end type
type rr_3 from roundrectangle within w_qa01_00050
end type
type rr_1 from roundrectangle within w_qa01_00050
end type
end forward

global type w_qa01_00050 from w_inherite
integer width = 4722
integer height = 3728
string title = "출하검사 등록"
cb_1 cb_1
dw_ip dw_ip
rb_insert rb_insert
rb_delete rb_delete
dw_imhist_out dw_imhist_out
p_list p_list
dw_imhist_nitem_out dw_imhist_nitem_out
dw_imhist_nitem_in dw_imhist_nitem_in
p_sort p_sort
cb_3 cb_3
rr_3 rr_3
rr_1 rr_1
end type
global w_qa01_00050 w_qa01_00050

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" 

end prototypes

type variables
String ic_status 

str_qa01_00020 str_00020


string  is_syscnfg  //합불판정 방법(1:직접, 2;불량수량)

String      is_ispec, is_jijil
end variables

forward prototypes
public function integer wf_initial ()
public function integer wf_checkrequiredfield ()
public function integer wf_check ()
end prototypes

public function integer wf_initial ();string snull

setnull(snull)

dw_ip.setredraw(false)

dw_insert.reset()
dw_imhist_out.reset()

p_mod.enabled = false
p_del.enabled = false
dw_ip.enabled = TRUE
////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	then
	cb_3.Visible = true
ELSE
	cb_3.Visible = false
END IF
dw_ip.SetItem(1, "sdate", left(is_today,6)+'01')
dw_ip.SetItem(1, "edate", is_today)

dw_ip.SetItem(1, "insdate", is_today)

dw_ip.SetItem(1, "jpno",    sNull)
dw_ip.SetItem(1, "cvcod",  sNull)
dw_ip.SetItem(1, "cvnas",   sNull)
//dw_ip.SetItem(1, "empno",   gs_empno)
dw_ip.SetItem(1, "saupj",   gs_saupj)

dw_ip.setcolumn("sdate")
dw_ip.setfocus()

dw_ip.setredraw(true)

return  1
end function

public function integer wf_checkrequiredfield ();////////////////////////////////////////////////////////////////////////////
string	sQcDate, sIndate, 	&
			sGubun,		&
			sCrtDate, sCrtTime, sCrtUser,	&
			sConfirm,	&
			sVendor,		&
			sEmpno,		&
			sNull,	sSudat ,sIogbn, sQcgub, sItnbr, sDepotno, sCvcod, sSaupj, sEpno, sEpno1, sIojpno ,sDecision, sBulcod
long		lRow, lRowOut, lRowCount ,ll_cnt, lcnt, ll_err, ll_ioamt
dec {3}  dQty, dReqty, dFaqty, dSuqty
String		ls_err
decimal	dprc

SetNull(sNull)

sEmpno  = gs_empno

lRowCount = dw_insert.RowCount()
/*입고구분(iogbn) 이 외주입고이면 작업실적 전표번호를 생성 */
FOR	lRow = 1		TO		lRowCount
	
	sDecision = dw_insert.GetItemString(lRow, "decisionyn")
	IF sDecision = 'D'	THEN 
		dw_insert.SetItemStatus(lrow, 0, Primary!, NotModified!)
		CONTINUE /* 합불 미지정은 skip */	
	END IF
	
	sQcdate = dw_insert.GetItemString(lRow, "insdat")
	
	If sQcdate = '' Or isNull(sQcdate) Or f_datechk(sQcdate) < 1 Then
		f_message_chk(35 , '[검사일자]')
		dw_insert.SetFocus()
		dw_insert.ScrollTorow(lRow)
		dw_insert.SetColumn('insdat')
		RollBack;
		Return -1
	End if
	
	sIojpno = dw_insert.GetItemString(lRow, "iojpno")
	sIogbn = dw_insert.GetItemString(lRow, "iogbn")
	sSudat = dw_insert.GetItemString(lRow, "sudat")
	sItnbr = dw_insert.GetItemString(lRow, "itnbr")
	sDepotno = dw_insert.GetItemString(lRow, "depot_no")
	sCvcod = dw_insert.GetItemString(lRow, "cvcod")
	dQty = dw_insert.GetItemDecimal(lRow, "ioqty")
	dReqty = dw_insert.GetItemDecimal(lRow, "ioreqty")
	sQcgub = dw_insert.GetItemString(lRow, "qcgub")
	dFaqty = dw_insert.GetItemDecimal(lRow, "iofaqty")
	dSuqty = dw_insert.GetItemDecimal(lRow, "iosuqty")
	sCrtDate = f_today()
	sCrtTime = f_totime()
	sCrtUser = gs_empno
	sBulcod = dw_insert.GetItemString(lRow, "bulcod")
	sSaupj = dw_insert.GetItemString(lRow, "saupj")
	
	INSERT INTO IMHIST_O_QC
	(
	SABU, IOJPNO, IOGBN, SUDAT, ITNBR, DEPOT_NO, CVCOD, IOQTY, IOREQTY, INSDAT, INSEMP, QCGUB, IOFAQTY, IOSUQTY,
	CRT_DATE, CRT_TIME, CRT_USER, DECISIONYN, BULCOD, SAUPJ
	)
	VALUES
	(
	:gs_sabu, :sIojpno, :sIogbn, :sSudat, :sItnbr, :sDepotno, :sCvcod, :dQty, :dReqty, :sQcdate, :sEmpno, :sQcgub, :dFaqty, :dSuqty,
	:sCrtDate, :sCrtTime, :sCrtUser, :sDecision, :sBulcod, :sSaupj
	);
	
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Insert Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20013]~r~n' + ls_err)
		Return -1
	End If

Next


RETURN 1
end function

public function integer wf_check ();////////////////////////////////////////////////////////////////////////////
string		get_pdsts, sDecision, sdate1, sdate2, sempno, sinsemp
long		lRow, lRowCount, k, lcnt
Dec		dBadQty

lRowCount = dw_insert.RowCount()

FOR	lRow = 1		TO		lRowCount
	
	sDecision = dw_insert.GetItemString(lRow, "decisionyn")		

	IF sDecision = 'D'	THEN 
		CONTINUE /* 합불 미지정은 skip */	
	END IF

	k++
	sdate1 = trim(dw_insert.getitemstring(lrow,'sudat'))
	sdate2 = trim(dw_insert.getitemstring(lrow,'insdat'))
	if f_datechk(sdate2) = -1 then
		messagebox('확 인', '검사일자를 확인하세요!') 
		dw_insert.ScrollToRow(lRow)
		dw_insert.setcolumn("insdat")
		dw_insert.setfocus()
		return -1	
	end if
		
	if sdate1 > sdate2 then
		messagebox('확 인', '검사일자가 출고일자 이전일 수 없습니다!') 
		dw_insert.ScrollToRow(lRow)
		dw_insert.setcolumn("insdat")
		dw_insert.setfocus()
		return -1	
	end if

Next

if k < 1 then 
	messagebox('확 인', '처리할 자료를 선택하세요!') 
	dw_insert.setfocus()
	return -1
end if

RETURN 1
end function

on w_qa01_00050.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.dw_imhist_out=create dw_imhist_out
this.p_list=create p_list
this.dw_imhist_nitem_out=create dw_imhist_nitem_out
this.dw_imhist_nitem_in=create dw_imhist_nitem_in
this.p_sort=create p_sort
this.cb_3=create cb_3
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.rb_insert
this.Control[iCurrent+4]=this.rb_delete
this.Control[iCurrent+5]=this.dw_imhist_out
this.Control[iCurrent+6]=this.p_list
this.Control[iCurrent+7]=this.dw_imhist_nitem_out
this.Control[iCurrent+8]=this.dw_imhist_nitem_in
this.Control[iCurrent+9]=this.p_sort
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.rr_3
this.Control[iCurrent+12]=this.rr_1
end on

on w_qa01_00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.dw_imhist_out)
destroy(this.p_list)
destroy(this.dw_imhist_nitem_out)
destroy(this.dw_imhist_nitem_in)
destroy(this.p_sort)
destroy(this.cb_3)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;// datawindow initial value
dw_ip.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_imhist_out.settransobject(sqlca)

//합/불 판정
SELECT DATANAME  
  into :is_syscnfg
  FROM SYSCNFG   
 WHERE SYSGU  = 'Y' 
   AND SERIAL = 13 
   AND LINENO = '4' ;

if isnull(is_syscnfg) or is_syscnfg = '' or is_syscnfg = '1' then 
	is_syscnfg = '1' //사용자 직접 입력
else
	is_syscnfg = '2' //불량이 있는 경우 불량 판정 
end if

dw_imhist_nitem_out.settransobject(sqlca)
dw_imhist_nitem_in.settransobject(sqlca)

dw_ip.InsertRow(0)

// commandbutton function
p_can.TriggerEvent("clicked")

end event

type dw_insert from w_inherite`dw_insert within w_qa01_00050
integer x = 41
integer y = 256
integer width = 4544
integer height = 2012
integer taborder = 20
string dataobject = "d_qa01_00050_a_t"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;call super::itemchanged;String sData, sIttyp, sOpseq, sItnbr, sCvcod, sDecision ,sIojpno, snull
long	lRow ,ll_cnt, lcnt
dec {3}	dBadQty, dReQty, dQty, dCdqty, dSiqty, diopeqty, dGongqty
dec {3}  dgongprc

lRow = this.GetRow()

setnull(snull)
If this.GetColumnName() = 'decisionyn' then  //추가 조연구
	sDecision = GetText()
//	if ic_status = '1' then
		If sDecision = 'Y' or sDecision = 'N' Then
			if sDecision = 'Y' then 
				SetItem(lRow,"bulcod",snull)
				SetItem(lRow,"iosuqty",GetItemNumber(lRow,'ioqty'))
				SetItem(lRow,"iofaqty",0)
			else
				SetItem(lRow,"iosuqty",0)
				SetItem(lRow,"iofaqty",GetItemNumber(lRow,'ioqty'))				
			end if
		Else
			SetItem(lRow,"bulcod",snull)
			SetItem(lRow,"iosuqty",0)
			SetItem(lRow,"iofaqty",0)
		End If
//	end if
end if

If this.GetColumnName() = 'iofaqty' then
	dBadQty = Dec(GetText())
	dReQty = GetItemNumber(lRow,'ioqty')
	
	if dReQty - dBadQty < 0 then
		MessageBox('확인','불량수량 지정오류!!!')
		return 1
	end if
	
	SetItem(lRow,"iosuqty",dReQty - dBadQty)
end if
end event

event dw_insert::clicked;call super::clicked;//If ic_status = '2' Then
	If Row <= 0 then
		SelectRow(0,False)
	ELSE
		SelectRow(0, FALSE)
		SelectRow(Row,TRUE)
	END IF
//End if
end event

type p_delrow from w_inherite`p_delrow within w_qa01_00050
boolean visible = false
integer x = 4997
integer y = 192
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa01_00050
boolean visible = false
integer x = 4960
integer y = 188
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa01_00050
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa01_00050
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa01_00050
integer x = 4421
end type

event p_exit::clicked;CLOSE(PARENT)
end event

type p_can from w_inherite`p_can within w_qa01_00050
integer x = 4247
integer taborder = 60
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

type p_print from w_inherite`p_print within w_qa01_00050
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa01_00050
integer x = 3899
end type

event p_inq::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF dw_ip.AcceptText() = -1	THEN	RETURN
/////////////////////////////////////////////////////////////////////////
string	sDate, eDate, scvcod, ecvcod, sQcDate, sJpno, sEmpno, sroslt, ls_saupj, sitnbr

sDate = TRIM(dw_ip.GetItemString(1, "sdate"))
eDate = TRIM(dw_ip.GetItemString(1, "edate"))

sQcDate = TRIM(dw_ip.GetItemString(1, "insdate"))
//sEmpno  = dw_ip.GetItemString(1, "empno")
scvcod  = dw_ip.GetItemString(1, "cvcod")
ls_saupj  = TRIM(dw_ip.GetItemString(1, "saupj"))
sitnbr  = TRIM(dw_ip.GetItemString(1, "itnbr"))


IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[의뢰일자FROM]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	RETURN
END IF

IF isnull(eDate) or eDate = "" 	THEN
	f_message_chk(30,'[의뢰일자TO]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	RETURN
END IF

IF (isnull(sQcDate) or sQcDate = "" or f_datechk(sQcDate) = -1) and ic_status = '1'	THEN
	f_message_chk(30,'[검사일자]')
	dw_ip.SetColumn("insdate")
	dw_ip.SetFocus()
	RETURN
END IF

IF isnull(sempno) or sempno = "" 	THEN sempno = '%'
IF isnull(scvcod) or scvcod = "" 	THEN scvcod = '%'
IF isnull(ls_saupj) or ls_saupj = "" 	THEN ls_saupj = '%'

SetPointer(HourGlass!)	

//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	IF	dw_insert.Retrieve(gs_sabu, sdate, edate, scvcod, sempno, ls_saupj, sitnbr, sQcDate) <	1		THEN
		f_message_chk(50, '[검사의뢰내역]')
		dw_ip.setcolumn("sdate")
		dw_ip.setfocus()
		RETURN
	
	END IF
ELSE
	IF	dw_insert.Retrieve(gs_sabu, sdate, edate, scvcod, sempno, ls_saupj, sitnbr) <	1		THEN
		f_message_chk(50, '[검사결과내역]')
		dw_ip.setcolumn("sdate")
		dw_ip.setfocus()
		RETURN
	END IF

	p_del.enabled = true
	
END IF
//////////////////////////////////////////////////////////////////////////

dw_insert.SetFocus()
//dw_ip.enabled = false

p_mod.enabled = true
end event

type p_del from w_inherite`p_del within w_qa01_00050
boolean visible = false
integer x = 3899
integer y = 108
integer taborder = 50
end type

event p_del::clicked;call super::clicked;long ll_rowcnt, i
String ls_Decision

w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

if ic_status = '1' then return

if dw_insert.accepttext() = -1 then return 

ll_rowcnt = dw_insert.rowcount()

if ll_rowcnt < 1 then return 
if dw_insert.Find("decisionyn = 'D'", 1, ll_rowcnt) <= 0 then 
	messagebox("확 인", "삭제할 자료가 존재하지 않습니다.")
	return 
end if

IF f_msg_delete() = -1 THEN	RETURN

For i = ll_rowcnt To 1 Step -1
	ls_Decision = dw_insert.GetItemString(i, "decisionyn")
	
	If ls_Decision = "D" Then
		dw_insert.DeleteRow(i)
	End If
Next

IF dw_insert.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
END IF

COMMIT;

p_inq.TriggerEvent("clicked")
end event

type p_mod from w_inherite`p_mod within w_qa01_00050
integer x = 4073
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sNull, ls_Decision
long ll_rowcnt, ll_row, i
SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1		THEN	RETURN
IF dw_insert.AcceptText() = -1	THEN	RETURN

ll_rowcnt = dw_insert.RowCount()

IF ic_status = '1'	THEN
	IF wf_Check() = -1	THEN	return 
	
	IF f_msg_update() = -1 	THEN	RETURN

	IF wf_CheckRequiredField() = -1	THEN	
		rollback;
		RETURN
	end if
	
	commit;
	
ELSE
	IF f_msg_update() = -1 	THEN	RETURN
	
	ll_row = dw_insert.Find("decisionyn = 'D'", 1, ll_rowcnt)
	IF ll_row > 0	THEN 
		For i = ll_rowcnt To 1 Step -1
			ls_Decision = dw_insert.GetItemString(i, "decisionyn")
	
			If ls_Decision = "D" Then
				dw_insert.DeleteRow(i)
			End If
		Next
	end if
	
	IF dw_insert.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		return -1
	END IF

	commit;

END IF

/////////////////////////////////////////////////////////////////////////////
//rb_delete.Checked = True
//rb_delete.TriggerEvent(Clicked!)
p_inq.TriggerEvent("clicked")

SetPointer(Arrow!)
end event

type cb_exit from w_inherite`cb_exit within w_qa01_00050
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa01_00050
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa01_00050
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa01_00050
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa01_00050
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa01_00050
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qa01_00050
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa01_00050
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa01_00050
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qa01_00050
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa01_00050
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa01_00050
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa01_00050
end type

type gb_button2 from w_inherite`gb_button2 within w_qa01_00050
end type

type cb_1 from commandbutton within w_qa01_00050
boolean visible = false
integer x = 2267
integer y = 2344
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM사용내역 조회"
end type

type dw_ip from datawindow within w_qa01_00050
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 16
integer width = 2985
integer height = 228
integer taborder = 90
string title = "none"
string dataobject = "d_qa01_00050_1_t"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)

END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', data)
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		
End Choose
 
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', gs_codename)
	Case	'itnbr'
		gs_code = this.GetText()
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then 	return
	
		this.SetItem(1, "itnbr", gs_code)
End Choose
end event

type rb_insert from radiobutton within w_qa01_00050
integer x = 3063
integer y = 56
integer width = 229
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;ic_status = '1'

dw_insert.DataObject = 'd_qa01_00050_a_t'
dw_insert.SetTransObject(sqlca)

wf_initial()
end event

type rb_delete from radiobutton within w_qa01_00050
integer x = 3063
integer y = 136
integer width = 229
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = " "
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;ic_status = '2'

dw_insert.DataObject = 'd_qa01_00050_b_t'
dw_insert.SetTransObject(sqlca)

wf_initial()
end event

type dw_imhist_out from datawindow within w_qa01_00050
boolean visible = false
integer x = 165
integer y = 1696
integer width = 411
integer height = 432
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_out"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type p_list from uo_picture within w_qa01_00050
boolean visible = false
integer x = 5024
integer y = 212
integer width = 178
integer taborder = 50
boolean bringtotop = true
string picturename = "C:\erpman\image\검사이력보기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String scvcod, sItnbr

if dw_insert.getrow() > 0 then
	gs_code		= dw_insert.getitemstring(dw_insert.getrow(), "imhist_itnbr")
	gs_codename	= dw_insert.getitemstring(dw_insert.getrow(), "imhist_cvcod")
	open(w_qct_01040_1)
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\검사이력보기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\검사이력보기_up.gif"
end event

type dw_imhist_nitem_out from datawindow within w_qa01_00050
boolean visible = false
integer x = 4750
integer y = 624
integer width = 750
integer height = 300
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_nitem_out"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type dw_imhist_nitem_in from datawindow within w_qa01_00050
boolean visible = false
integer x = 4754
integer y = 1032
integer width = 741
integer height = 300
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_nitem_in"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type p_sort from picture within w_qa01_00050
boolean visible = false
integer x = 3735
integer y = 108
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

type cb_3 from commandbutton within w_qa01_00050
integer x = 3355
integer y = 152
integer width = 343
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄합격"
end type

event clicked;int li_row, i, lcnt
string snull, sInsdate

dw_ip.AcceptText()

SetNull(snull)

li_row = dw_insert.RowCount()

IF li_row <= 0 THEN
	IF ic_status = '1'	THEN
		f_message_chk(50, '[검사의뢰내역]')
	ELSE
		f_message_chk(50, '[검사결과내역]')
	END IF
ELSE
	For i = 1 to li_row
		dw_insert.SetItem(i, 'decisionyn', 'Y')
		
		if IsNull(Trim(dw_insert.GetItemString(i,"insdat"))) or &
			Trim(dw_insert.GetItemString(i,"insdat")) = '' then
			sInsdate = dw_ip.GetItemString(1, "insdate")
			If IsNull(sInsdate) or sInsdate = "" or f_datechk(sInsdate) = -1 Then
				dw_insert.SetItem(i,"insdat",f_today())
			Else
				dw_insert.SetItem(i,"insdat",sInsdate)
			End If
		End If
			
		dw_insert.SetItem(i,"bulcod",snull)
		dw_insert.SetItem(i,"iosuqty",dw_insert.GetItemNumber(i,'ioqty'))
		dw_insert.SetItem(i,"iofaqty",0)
	Next
	MessageBox("확인", "일괄처리가 완료되었습니다.")
END IF
end event

type rr_3 from roundrectangle within w_qa01_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 248
integer width = 4585
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_qa01_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3017
integer y = 20
integer width = 311
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

