$PBExportHeader$w_bomchk.srw
forward
global type w_bomchk from w_inherite
end type
type dw_1 from datawindow within w_bomchk
end type
end forward

global type w_bomchk from w_inherite
string title = "생산BOM 적용여부"
dw_1 dw_1
end type
global w_bomchk w_bomchk

on w_bomchk.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_bomchk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;p_inq.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_bomchk
integer x = 1467
integer y = 196
integer width = 3145
integer height = 2056
string dataobject = "d_bomchk_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type p_delrow from w_inherite`p_delrow within w_bomchk
boolean visible = false
integer x = 3113
integer y = 32
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   ll_find

ll_find = dw_insert.FIND("chk = 'Y'", 1, ll_cnt)
If ll_find < 1 Then Return

If f_msg_delete() < 1 Then Return

Long   i

For i = 1 To ll_cnt
	i = dw_insert.FIND("chk = 'Y'", i, dw_insert.RowCount())
	If i < 1 Then Exit
	
	dw_insert.DeleteRow(i)
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	ib_any_typing = False
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '삭제 오류 발생')
	Return
End If
end event

type p_addrow from w_inherite`p_addrow within w_bomchk
boolean visible = false
integer x = 2021
integer y = 32
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_bomchk
boolean visible = false
integer x = 2386
integer y = 28
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_bomchk
boolean visible = false
integer x = 1847
integer y = 32
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_bomchk
end type

type p_can from w_inherite`p_can within w_bomchk
end type

type p_print from w_inherite`p_print within w_bomchk
boolean visible = false
integer x = 2560
integer y = 28
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_bomchk
boolean visible = false
integer x = 2935
integer y = 28
boolean enabled = false
end type

event p_inq::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Retrieve()
dw_1.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_bomchk
end type

event p_del::clicked;call super::clicked;dw_insert.AcceptText()

Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() < 1 Then Return

Long   i

String ls_pin
String ls_cin

For i = 1 To ll_cnt
	ls_pin = dw_insert.GetItemString(i, 'pinbr')
	If Trim(ls_pin) = '' OR IsNull(ls_pin) Then
		MessageBox('공백확인', '상위품번란에 공백을 입력하실 수 없습니다.')
		dw_insert.SetColumn('pinbr')
		dw_insert.SetRow(i)
		dw_insert.SetFocus()
		Return
	End If
	
	ls_cin = dw_insert.GetItemString(i, 'cinbr')
	If Trim(ls_cin) = '' OR IsNull(ls_cin) Then
		MessageBox('공백확인', '하위품번란에 공백을 입력하실 수 없습니다.')
		dw_insert.SetColumn('cinbr')
		dw_insert.SetRow(i)
		dw_insert.SetFocus()
		Return
	End If
Next

Long   ll_find

ll_find = dw_insert.FIND("chk = 'Y'", 1, ll_cnt)
If ll_find < 1 Then Return

SetNull(i)

For i = 1 To ll_cnt
	i = dw_insert.FIND("chk = 'Y'", i, dw_insert.RowCount())
	If i < 1 Then Exit
	
	dw_insert.DeleteRow(i)
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	ib_any_typing = False
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '저장 오류 입니다.')
	Return
End If
end event

type p_mod from w_inherite`p_mod within w_bomchk
boolean visible = false
integer x = 3282
integer y = 36
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() < 1 Then Return

Long   i

String ls_pin
String ls_cin

For i = 1 To ll_cnt
	ls_pin = dw_insert.GetItemString(i, 'pinbr')
	If Trim(ls_pin) = '' OR IsNull(ls_pin) Then
		MessageBox('공백확인', '상위품번란에 공백을 입력하실 수 없습니다.')
		dw_insert.SetColumn('pinbr')
		dw_insert.SetRow(i)
		dw_insert.SetFocus()
		Return
	End If
	
	ls_cin = dw_insert.GetItemString(i, 'cinbr')
	If Trim(ls_cin) = '' OR IsNull(ls_cin) Then
		MessageBox('공백확인', '하위품번란에 공백을 입력하실 수 없습니다.')
		dw_insert.SetColumn('cinbr')
		dw_insert.SetRow(i)
		dw_insert.SetFocus()
		Return
	End If
Next

Long   ll_find

ll_find = dw_insert.FIND("chk = 'Y'", 1, ll_cnt)
If ll_find < 1 Then Return

SetNull(i)

For i = 1 To ll_cnt
	i = dw_insert.FIND("chk = 'Y'", i, dw_insert.RowCount())
	If i < 1 Then Exit
	
	dw_insert.DeleteRow(i)
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	ib_any_typing = False
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '저장 오류 입니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_bomchk
end type

type cb_mod from w_inherite`cb_mod within w_bomchk
end type

type cb_ins from w_inherite`cb_ins within w_bomchk
end type

type cb_del from w_inherite`cb_del within w_bomchk
end type

type cb_inq from w_inherite`cb_inq within w_bomchk
end type

type cb_print from w_inherite`cb_print within w_bomchk
end type

type st_1 from w_inherite`st_1 within w_bomchk
end type

type cb_can from w_inherite`cb_can within w_bomchk
end type

type cb_search from w_inherite`cb_search within w_bomchk
end type

type gb_button1 from w_inherite`gb_button1 within w_bomchk
end type

type gb_button2 from w_inherite`gb_button2 within w_bomchk
end type

type dw_1 from datawindow within w_bomchk
integer x = 23
integer y = 196
integer width = 1417
integer height = 2056
integer taborder = 120
boolean bringtotop = true
string dataobject = "d_bomchk_001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)

end event

event clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)

String ls_itn

ls_itn = This.GetItemString(row, 'pinbr')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_itn)
dw_insert.SetRedraw(True)
end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

String ls_itn

ls_itn = This.GetItemString(currentrow, 'pinbr')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_itn)
dw_insert.SetRedraw(True)
end event

event retrieveend;If rowcount < 1 Then Return

Long   row

row = This.GetRow()
If row < 1 Then Return

String ls_itn

ls_itn = This.GetItemString(row, 'pinbr')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_itn)
dw_insert.SetRedraw(True)
end event

