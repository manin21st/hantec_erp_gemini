$PBExportHeader$w_is_10010.srw
$PBExportComments$평가항목 기준등록
forward
global type w_is_10010 from w_inherite
end type
type dw_1 from datawindow within w_is_10010
end type
type st_2 from statictext within w_is_10010
end type
type st_3 from statictext within w_is_10010
end type
type st_4 from statictext within w_is_10010
end type
type st_5 from statictext within w_is_10010
end type
type rr_1 from roundrectangle within w_is_10010
end type
type rr_2 from roundrectangle within w_is_10010
end type
type rr_3 from roundrectangle within w_is_10010
end type
type rr_4 from roundrectangle within w_is_10010
end type
end forward

global type w_is_10010 from w_inherite
string title = "평가항목 기준등록"
dw_1 dw_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_is_10010 w_is_10010

on w_is_10010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_4
end on

on w_is_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

type dw_insert from w_inherite`dw_insert within w_is_10010
integer x = 1765
integer y = 220
integer width = 2834
integer height = 2032
string dataobject = "d_is_10010_003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_is_10010
integer x = 3895
end type

event p_delrow::clicked;call super::clicked;Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

dw_insert.DeleteRow(row)

If dw_insert.UPDATE() = 1 Then
	MessageBox('삭제', '삭제 되었습니다.')
Else
	MessageBox('삭제', '삭제 중 오류가 발생했습니다.')
	ib_any_typing = False
	Return
End If

ib_any_typing = False

end event

type p_addrow from w_inherite`p_addrow within w_is_10010
integer x = 3721
end type

event p_addrow::clicked;call super::clicked;Long   ll_ins
ll_ins = dw_insert.InsertRow(0)

dw_insert.SetColumn('rfgub')
dw_insert.SetFocus()
dw_insert.SetRow(ll_ins)

String ls_rfcod
ls_rfcod = dw_1.GetItemString(dw_1.GetRow(), 'rfcod')
dw_insert.SetItem(ll_ins, 'rfcod', ls_rfcod)
end event

type p_search from w_inherite`p_search within w_is_10010
integer x = 1531
integer y = 36
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_search::ue_lbuttondown;//
PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_search::ue_lbuttonup;//
PictureName = "C:\erpman\image\저장_up.gif"
end event

event p_search::clicked;call super::clicked;Long   i
String ls_rfcod

If f_msg_update() <> 1 Then Return

For i = 1 To dw_1.RowCount()
	ls_rfcod = dw_1.GetItemString(i, 'rfcod')
	If Trim(ls_rfcod) = '' OR IsNull(ls_rfcod) Then
		MessageBox('분류코드', '분류코드는 필수입니다.~r~n값을 입력하십시오.')
		dw_1.SetColumn('rfcod')
		dw_1.SetFocus()
		Return
	End If
Next

If dw_1.UPDATE() = 1 Then
	MessageBox('저장', '자료가 저장되었습니다.')
Else
	MessageBox('저장', '자료 저장 중 오류가 발생했습니다.')
	ib_any_typing = False
	Return
End If

ib_any_typing = False
end event

type p_ins from w_inherite`p_ins within w_is_10010
integer x = 1175
integer y = 36
end type

event p_ins::clicked;call super::clicked;Long   ll_ins
ll_ins = dw_1.InsertRow(0)

dw_1.SetColumn('rfcod')
dw_1.SetFocus()
dw_1.SetRow(ll_ins)

dw_1.SetItem(ll_ins, 'rfgub', '000')
end event

type p_exit from w_inherite`p_exit within w_is_10010
integer x = 4416
end type

type p_can from w_inherite`p_can within w_is_10010
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_1.ReSet()
dw_insert.ReSet()

dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_is_10010
boolean visible = false
integer x = 3026
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_is_10010
integer x = 3547
end type

event p_inq::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Retrieve()
dw_1.SetRedraw(True)

If dw_1.RowCount() < 1 Then
	MessageBox('조회', '조회된 자료가 없습니다.')
	ib_any_typing = False
	Return
End If

ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_is_10010
integer x = 1353
integer y = 36
end type

event p_del::clicked;call super::clicked;Long   row

row = dw_1.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

dw_1.DeleteRow(row)

If dw_1.UPDATE() = 1 Then
	MessageBox('삭제', '삭제 되었습니다.')
Else
	MessageBox('삭제', '삭제 중 오류가 발생했습니다.')
	ib_any_typing = False
	Return
End If

ib_any_typing = False
end event

type p_mod from w_inherite`p_mod within w_is_10010
integer x = 4069
end type

event p_mod::clicked;call super::clicked;Long   i
String ls_rfcod
String ls_rfgub

If f_msg_update() <> 1 Then Return

For i = 1 To dw_insert.RowCount()
	ls_rfcod = dw_insert.GetItemString(i, 'rfcod')
	If Trim(ls_rfcod) = '' OR IsNull(ls_rfcod) Then
		MessageBox('분류코드', '분류코드는 필수입니다.~r~n값을 입력하십시오.')
		dw_insert.SetColumn('rfcod')
		dw_insert.SetFocus()
		Return
	End If
	
	ls_rfgub = dw_insert.GetItemString(i, 'rfgub')
	If Trim(ls_rfgub) = '' OR IsNull(ls_rfgub) Then
		MessageBox('관리코드', '관리코드는 필수입니다.~r~n값을 입력하십시오.')
		dw_insert.SetColumn('rfgub')
		dw_insert.SetFocus()
		Return
	End If
Next

If dw_insert.UPDATE() = 1 Then
	MessageBox('저장', '자료가 저장되었습니다.')
Else
	MessageBox('저장', '자료 저장 중 오류가 발생했습니다.')
	ib_any_typing = False
	Return
End If

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_is_10010
end type

type cb_mod from w_inherite`cb_mod within w_is_10010
end type

type cb_ins from w_inherite`cb_ins within w_is_10010
end type

type cb_del from w_inherite`cb_del within w_is_10010
end type

type cb_inq from w_inherite`cb_inq within w_is_10010
end type

type cb_print from w_inherite`cb_print within w_is_10010
end type

type st_1 from w_inherite`st_1 within w_is_10010
end type

type cb_can from w_inherite`cb_can within w_is_10010
end type

type cb_search from w_inherite`cb_search within w_is_10010
end type







type gb_button1 from w_inherite`gb_button1 within w_is_10010
end type

type gb_button2 from w_inherite`gb_button2 within w_is_10010
end type

type dw_1 from datawindow within w_is_10010
integer x = 50
integer y = 220
integer width = 1659
integer height = 2036
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_is_10010_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)

end event

event clicked;If row < 1 Then Return

String ls_rfcod

ls_rfcod = This.GetItemString(row, 'rfcod')
If Trim(ls_rfcod) = '' OR IsNull(ls_rfcod) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_rfcod)
dw_insert.SetRedraw(True)

end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event retrieveend;If rowcount < 1 Then Return

String ls_rfcod

ls_rfcod = This.GetItemString(1, 'rfcod')
If Trim(ls_rfcod) = '' OR IsNull(ls_rfcod) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_rfcod)
dw_insert.SetRedraw(True)

end event

type st_2 from statictext within w_is_10010
integer x = 1033
integer y = 48
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 32106727
string text = "분류"
boolean focusrectangle = false
end type

type st_3 from statictext within w_is_10010
integer x = 1033
integer y = 112
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 32106727
string text = "코드"
boolean focusrectangle = false
end type

type st_4 from statictext within w_is_10010
integer x = 2231
integer y = 48
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 32106727
string text = "분류"
boolean focusrectangle = false
end type

type st_5 from statictext within w_is_10010
integer x = 2231
integer y = 112
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 32106727
string text = "코드"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_is_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 1751
integer y = 208
integer width = 2862
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_is_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 208
integer width = 1687
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_is_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1015
integer y = 28
integer width = 709
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_is_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2213
integer y = 28
integer width = 709
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

