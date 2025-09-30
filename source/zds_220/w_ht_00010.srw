$PBExportHeader$w_ht_00010.srw
$PBExportComments$자동수불 중복출고 삭제
forward
global type w_ht_00010 from w_inherite
end type
type dw_1 from datawindow within w_ht_00010
end type
type dw_list from u_d_select_sort within w_ht_00010
end type
type rr_1 from roundrectangle within w_ht_00010
end type
type rr_2 from roundrectangle within w_ht_00010
end type
end forward

global type w_ht_00010 from w_inherite
string title = "중복출고 자료 삭제"
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_ht_00010 w_ht_00010

on w_ht_00010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_ht_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))
dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

event open;call super::open;This.TriggerEvent('ue_open')
end event

type dw_insert from w_inherite`dw_insert within w_ht_00010
integer x = 41
integer y = 1092
integer width = 4558
integer height = 1148
string dataobject = "d_ht_00010_edit"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

type p_delrow from w_inherite`p_delrow within w_ht_00010
boolean visible = false
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_ht_00010
boolean visible = false
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_ht_00010
boolean visible = false
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_ht_00010
boolean visible = false
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_ht_00010
end type

type p_can from w_inherite`p_can within w_ht_00010
end type

type p_print from w_inherite`p_print within w_ht_00010
boolean visible = false
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_ht_00010
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

String   ls_st
ls_st = dw_1.GetItemString(1, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('확인', '시작일을 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('d_st')
	Return
End If

If IsDate(LEFT(ls_st, 4) + '/' + MID(ls_st, 5, 2) + '/' + RIGHT(ls_st, 2)) = False Then
	MessageBox('확인', '시작일은 일자 형식이 아닙니다.')
	dw_1.SetFocus()
	dw_1.SetColumn('d_st')
	Return
End If

//String   ls_ed
//ls_ed = dw_1.GetItemString(1, 'd_ed')
//If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
//	MessageBox('확인', '시작일을 입력 하십시오.')
//	dw_1.SetFocus()
//	dw_1.SetColumn('d_ed')
//	Return
//End If
//
//If IsDate(LEFT(ls_ed, 4) + '/' + MID(ls_ed, 5, 2) + '/' + RIGHT(ls_ed, 2)) = False Then
//	MessageBox('확인', '시작일은 일자 형식이 아닙니다.')
//	dw_1.SetFocus()
//	dw_1.SetColumn('d_ed')
//	Return
//End If

String   ls_sit
ls_sit = dw_1.GetItemString(1, 'stit')
If Trim(ls_sit) = '' OR IsNull(ls_sit) Then ls_sit = '%'

//String   ls_eit
//ls_eit = dw_1.GetItemString(1, 'edit')
//If Trim(ls_eit) = '' OR IsNull(ls_eit) Then ls_eit = 'zzzzzzzzzz'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_sit)
//dw_list.Retrieve(ls_st, ls_ed, ls_sit, ls_eit)
dw_list.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_ht_00010
end type

event p_del::clicked;call super::clicked;Long    ll_cnt
ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long    ll_find
ll_find = dw_insert.Find("f_chk = 'Y'", 1, ll_cnt)
If ll_find < 1 Then Return

Long    i
For i = 1 To dw_insert.RowCount()
	ll_find = dw_insert.Find("f_chk = 'Y'", i, dw_insert.RowCount())
	If ll_find < 1 Then Exit
	
	dw_insert.DeleteRow(ll_find)
	i = ll_find - 1
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('확인', '삭제 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('확인', '자료 삭제 중 오류가 발생 했습니다.')
	Return
End If
end event

type p_mod from w_inherite`p_mod within w_ht_00010
boolean visible = false
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_ht_00010
end type

type cb_mod from w_inherite`cb_mod within w_ht_00010
end type

type cb_ins from w_inherite`cb_ins within w_ht_00010
end type

type cb_del from w_inherite`cb_del within w_ht_00010
end type

type cb_inq from w_inherite`cb_inq within w_ht_00010
end type

type cb_print from w_inherite`cb_print within w_ht_00010
end type

type st_1 from w_inherite`st_1 within w_ht_00010
end type

type cb_can from w_inherite`cb_can within w_ht_00010
end type

type cb_search from w_inherite`cb_search within w_ht_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_ht_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_ht_00010
end type

type dw_1 from datawindow within w_ht_00010
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 28
integer width = 2533
integer height = 180
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_ht_00010_ret"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'stit'
		If Trim(This.GetItemString(row, 'edit')) = '' OR IsNull(This.GetItemString(row, 'edit')) Then
			This.SetItem(row, 'edit', data)
		End If
		
	Case 'd_st'
		If Trim(This.GetItemString(row, 'd_ed')) = '' OR IsNull(This.GetItemString(row, 'd_ed')) Then
			This.SetItem(row, 'd_ed', data)
		End If
End Choose
end event

type dw_list from u_d_select_sort within w_ht_00010
integer x = 41
integer y = 232
integer width = 4558
integer height = 808
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_ht_00010_list"
boolean border = false
boolean hsplitscroll = true
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

String   ls_dat
String   ls_itn
String   ls_jno
String   ls_j[]
Long     ll_qty
ls_dat = This.GetItemString(currentrow, 'a_io_date')
ls_itn = This.GetItemString(currentrow, 'a_itnbr'  )
ls_jno = This.GetItemString(currentrow, 'iojpno'   ) + ';'
ll_qty = This.GetItemNumber(currentrow, 'a_ioqty'  )

Long     l ; l = 1
Long     ll_pos ; ll_pos = 1
Long     ll_st ; ll_st = 1
DO WHILE ll_pos > 0
	ll_pos  = POS(ls_jno, ';', ll_st)
	
	If ll_pos > 0 Then
		ls_j[l] = MID(ls_jno, ll_st, 15)
		
		ll_st = ll_pos	+ 1
		l++
	End If
LOOP

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_dat, ls_itn, ll_qty, ls_j)
dw_insert.SetRedraw(True)
end event

event clicked;call super::clicked;If row < 1 Then Return

String   ls_dat
String   ls_itn
String   ls_jno
String   ls_j[]
Long     ll_qty
ls_dat = This.GetItemString(row, 'a_io_date')
ls_itn = This.GetItemString(row, 'a_itnbr'  )
ls_jno = This.GetItemString(row, 'iojpno'   ) + ';'
ll_qty = This.GetItemNumber(row, 'a_ioqty'  )

Long     l ; l = 1
Long     ll_pos ; ll_pos = 1
Long     ll_st ; ll_st = 1
DO WHILE ll_pos > 0
	ll_pos  = POS(ls_jno, ';', ll_st)
	
	If ll_pos > 0 Then
		ls_j[l] = MID(ls_jno, ll_st, 15)
		
		ll_st = ll_pos	+ 1
		l++
	End If
LOOP

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_dat, ls_itn, ll_qty, ls_j)
dw_insert.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_ht_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 1084
integer width = 4576
integer height = 1164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_ht_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 224
integer width = 4576
integer height = 828
integer cornerheight = 40
integer cornerwidth = 55
end type

