$PBExportHeader$w_zds_31910_repair.srw
$PBExportComments$용기 MASTER
forward
global type w_zds_31910_repair from w_inherite
end type
type dw_1 from datawindow within w_zds_31910_repair
end type
type dw_2 from datawindow within w_zds_31910_repair
end type
type rr_1 from roundrectangle within w_zds_31910_repair
end type
type rr_2 from roundrectangle within w_zds_31910_repair
end type
end forward

global type w_zds_31910_repair from w_inherite
string title = "용기 마스터 등록"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
end type
global w_zds_31910_repair w_zds_31910_repair

on w_zds_31910_repair.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_zds_31910_repair.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.InsertRow(0)

dw_insert.SetTransObject(SQLCA)
end event

type dw_insert from w_inherite`dw_insert within w_zds_31910_repair
integer x = 2121
integer y = 232
integer width = 2482
integer height = 2012
string dataobject = "d_zds_31910_repair_003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

//Choose Case dwo.name
//	Case 'f_chk'
//		Integer i
//		For i = 1 To This.RowCount()
//			This.SetItem(i, 'f_chk', 'N')
//		Next
//	Case 'bpcode'
//		Integer li_find
//		li_find = This.Find("bpcode = '" + data + "'", 1, This.RowCount() - 1)
//		If li_find < 1 Then Return
//		
//		MessageBox('중복 확인', '[' + data + '] 관리번호는 이미 등록 된 번호 입니다.')
//		Return 2
//End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)
end event

type p_delrow from w_inherite`p_delrow within w_zds_31910_repair
boolean visible = false
integer x = 3922
integer y = 168
end type

type p_addrow from w_inherite`p_addrow within w_zds_31910_repair
boolean visible = false
integer y = 168
end type

type p_search from w_inherite`p_search within w_zds_31910_repair
boolean visible = false
integer y = 168
end type

type p_ins from w_inherite`p_ins within w_zds_31910_repair
integer x = 3749
end type

event p_ins::clicked;call super::clicked;String  ls_code
ls_code = dw_2.GetItemString(dw_2.GetRow(), 'bpcode')
If Trim(ls_code) = '' Or IsNull(ls_code) Then
	Messagebox('확인', '대상 용기를 재 선택 하십시오.')
	Return
End If

Integer li_ins
li_ins = dw_insert.InsertRow(0)

dw_insert.SetItem(li_ins, 'sabu'  , gs_sabu )
dw_insert.SetItem(li_ins, 'saupj' , gs_saupj)
dw_insert.SetItem(li_ins, 'bpcode', ls_code )
dw_insert.SetItem(li_ins, 'repdat', String(TODAY(), 'yyyymmdd'))

dw_insert.SetFocus()
dw_insert.SetRow(li_ins)
dw_insert.SetColumn('repdat')
end event

type p_exit from w_inherite`p_exit within w_zds_31910_repair
end type

type p_can from w_inherite`p_can within w_zds_31910_repair
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
end event

type p_print from w_inherite`p_print within w_zds_31910_repair
boolean visible = false
integer y = 168
end type

type p_inq from w_inherite`p_inq within w_zds_31910_repair
integer x = 3575
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

If dw_1.GetRow() < 1 Then Return

String  ls_name
ls_name = dw_1.GetItemString(1, 'bpname')
If Trim(ls_name) = '' OR IsNull(ls_name) Then
	ls_name = '%'
Else
	ls_name = '%' + ls_name + '%'
End If

String  ls_code
ls_code = dw_1.GetItemString(1, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then ls_code = '%'

String  ls_item
ls_item = dw_1.GetItemString(1, 'itnbr')
If TriM(ls_item) = '' OR IsNull(ls_item) Then ls_item = '%'

dw_2.SetRedraw(False)
dw_2.Retrieve(ls_code, ls_item, ls_name)
dw_2.SetRedraw(True)


end event

type p_del from w_inherite`p_del within w_zds_31910_repair
integer x = 3922
end type

event p_del::clicked;call super::clicked;Long    ll_err
Long    l
Long    ll_fchk
Long    ll_get
String  ls_get[]
String  ls_err

For l = 1 To dw_insert.RowCount()
	ll_fchk = dw_insert.Find("f_chk = 'Y'", l, dw_insert.RowCount())
	If ll_fchk < 1 Then Exit
	
	ls_get[1] = dw_insert.GetItemString(ll_fchk, 'sabu'  )
	ls_get[2] = dw_insert.GetItemString(ll_fchk, 'saupj' )
	ls_get[3] = dw_insert.GetItemString(ll_fchk, 'bpcode')
	ll_get    = dw_insert.GetItemNumber(ll_fchk, 'seq'   )
	
	If IsNull(ll_get) Or ll_get = 0 Then
		dw_insert.DeleteRow(ll_fchk)
		l = ll_fchk
		l = l - 1
	Else
		DELETE FROM BP_MASTER_HIST
		 WHERE SABU = :ls_get[1] AND SAUPJ = :ls_get[2] AND BPCODE = :ls_get[3] AND SEQ = :ll_get ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
			MessageBox('DB Error Code - ' + String(ll_err), ls_err + '~r~n자료 삭제 중 오류가 발생 했습니다.(' + String(l) + ')')
			Return
		End If
	End If
Next

COMMIT USING SQLCA;
dw_insert.ResetUpdate()

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_get[1], ls_get[2], ls_get[3])
dw_insert.SetRedraw(True)

MessageBox('삭제 확인', '선택된 항목이 삭제 되었습니다.')
end event

type p_mod from w_inherite`p_mod within w_zds_31910_repair
integer x = 4096
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

Long    i
Long    ll_seq
String  ls_sabu
String  ls_saupj
String  ls_bpcod
String  ls_dup
DWItemStatus l_sts

For i = 1 To li_cnt
	l_sts = dw_insert.GetItemStatus(i, 0, Primary!)
	
	ls_sabu  = dw_insert.GetItemString(i, 'sabu'  )
	If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
		dw_insert.SetItem(i, 'sabu', gs_sabu)
		ls_sabu = gs_sabu
	End If
	
	ls_saupj = dw_insert.GetItemString(i, 'saupj' )
	If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
		dw_insert.SetItem(i, 'saupj', gs_saupj)
		ls_saupj = gs_saupj
	End If
	
	ls_bpcod = dw_insert.GetItemString(i, 'bpcode')
	If Trim(ls_bpcod) = '' OR IsNull(ls_bpcod) Then
		MessageBox('관리번호 확인', 'BOX/PLT 관리번호를 입력 하십시오.')
		dw_insert.SetRow(i)
		dw_insert.SetColumn('bpcode')
		Return
	End If
	
	Choose Case l_sts
		Case New!, NewModified!
			SELECT BP_MASTER_HIST_SEQ.NEXTVAL INTO :ll_seq FROM DUAL;
			dw_insert.SetItem(i, 'seq', ll_seq)
		Case DataModified!
	End Choose
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장 실패', '저장 중 오류가 발생했습니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_zds_31910_repair
end type

type cb_mod from w_inherite`cb_mod within w_zds_31910_repair
end type

type cb_ins from w_inherite`cb_ins within w_zds_31910_repair
end type

type cb_del from w_inherite`cb_del within w_zds_31910_repair
end type

type cb_inq from w_inherite`cb_inq within w_zds_31910_repair
end type

type cb_print from w_inherite`cb_print within w_zds_31910_repair
end type

type st_1 from w_inherite`st_1 within w_zds_31910_repair
end type

type cb_can from w_inherite`cb_can within w_zds_31910_repair
end type

type cb_search from w_inherite`cb_search within w_zds_31910_repair
end type







type gb_button1 from w_inherite`gb_button1 within w_zds_31910_repair
end type

type gb_button2 from w_inherite`gb_button2 within w_zds_31910_repair
end type

type dw_1 from datawindow within w_zds_31910_repair
integer x = 37
integer y = 12
integer width = 3191
integer height = 196
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_zds_31910_repair_001"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	sVendor, sVendorname, sNull

SetNull(sNull)

This.AcceptText()

// 거래처
IF this.GetColumnName() = 'cvcod'		THEN

	sVendor = this.gettext()
	If Trim(sVendor) = '' OR IsNull(sVendor) Then
		this.setitem(1, 'cvnas', sNull)
		Return
	End If
	
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor 	AND
	 		 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, "cvnas", sNull)
		return 1
	end if

	this.setitem(1, "cvnas", sVendorName)
	
End If
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// 전표번호
IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "cvcod",		gs_code)
	SetItem(1, "cvnas",gs_codename)

END IF


end event

type dw_2 from datawindow within w_zds_31910_repair
integer x = 46
integer y = 232
integer width = 2021
integer height = 2012
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_zds_31910_repair_002"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event retrieveend;If rowcount < 1 Then Return

String  ls_code
ls_code = This.GetItemString(1, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_sabu, gs_saupj, ls_code)
dw_insert.SetRedraw(True)
end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)

String  ls_code
ls_code = This.GetItemString(currentrow, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_sabu, gs_saupj, ls_code)
dw_insert.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_zds_31910_repair
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2107
integer y = 224
integer width = 2505
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_zds_31910_repair
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 2039
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

