$PBExportHeader$w_exppo_popup.srw
$PBExportComments$PO SHEET 조회 선택 (한텍추가)
forward
global type w_exppo_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_exppo_popup
end type
end forward

global type w_exppo_popup from w_inherite_popup
integer x = 5
integer y = 240
integer width = 2834
integer height = 1760
string title = "PO Sheet 선택"
rr_1 rr_1
end type
global w_exppo_popup w_exppo_popup

type variables
boolean ib_down
long  il_sRow = 1
String   isSaupj,  isexplcno, isCvcod
end variables

on w_exppo_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_exppo_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;f_window_center_response(this)

dw_1.SetTransObject(Sqlca)

dw_jogun.InsertRow(0)
dw_jogun.SetItem(1, 'cvcod', gs_code)
dw_jogun.SetItem(1, 'cvnas', gs_codename)
dw_jogun.SetItem(1, 'yymm', left(f_today(),6))

p_inq.PostEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_exppo_popup
integer y = 24
integer width = 1861
integer height = 140
string dataobject = "d_exppo_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_exppo_popup
integer x = 2546
integer y = 12
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_exppo_popup
integer x = 2199
integer y = 12
end type

event p_inq::clicked;call super::clicked;string syymm, scvcod

IF dw_jogun.AcceptText() = -1 THEN Return 

syymm = trim(dw_jogun.GetItemString(1,'yymm'))
If f_datechk(syymm+'01') <> 1 Then
	f_message_chk(35,'')
	return 1
End If

scvcod = trim(dw_jogun.GetItemString(1,'cvcod'))

String ls_saupj
If IsNull(gs_gubun) Or Trim(gs_gubun) = '' Then
	ls_saupj = gs_saupj
Else
	ls_saupj = gs_gubun
End If

dw_1.Retrieve(ls_saupj, syymm, scvcod, '%')
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_exppo_popup
integer x = 2373
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "itemno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_exppo_popup
integer x = 32
integer y = 192
integer width = 2715
integer height = 1440
integer taborder = 30
string dataobject = "d_exppo_popup2"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

cb_1.TriggerEvent(Clicked!)
end event

event dw_1::rowfocuschanged;int crow,fr_row,to_row,ix

If currentrow <=0 Then Return

If keydown(KeyControl!) Then
	If Keydown(KeyUpArrow!) Or Keydown(KeyDownArrow!) Then This.SelectRow(0,false)
		
	If IsSelected(currentrow) Then
	  This.SelectRow(currentrow,false)
   Else
	  This.SelectRow(currentrow,True)
   end If
ElseIf keydown(keyShift!) Then
	This.SelectRow(0,false)
   If il_sRow < currentrow Then
		fr_row  = il_sRow
		to_row  = currentrow
	Else
		fr_row = currentrow
		to_row = il_sRow
	End If

	For ix = fr_row To to_row
		This.SelectRow(ix,true)
	Next
Else
	This.SelectRow(0,false)
	This.SelectRow(currentrow,true)
	il_sRow = currentrow
End If
end event

type sle_2 from w_inherite_popup`sle_2 within w_exppo_popup
boolean visible = false
integer x = 1006
integer width = 1138
boolean enabled = false
string text = "*"
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_exppo_popup
boolean visible = false
integer y = 1836
integer taborder = 40
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_exppo_popup
boolean visible = false
integer x = 1559
integer y = 1836
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_exppo_popup
boolean visible = false
integer x = 1248
integer y = 1836
integer taborder = 50
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_exppo_popup
boolean visible = false
integer x = 704
integer y = 1888
integer width = 471
long backcolor = 16777215
boolean enabled = false
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_exppo_popup
boolean visible = false
integer x = 46
integer y = 1904
integer width = 672
long textcolor = 128
string text = "Proforma Invoice No."
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_exppo_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 180
integer width = 2752
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

