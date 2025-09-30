$PBExportHeader$w_hold_popup.srw
$PBExportComments$** 할당번호 조회 선택
forward
global type w_hold_popup from w_inherite_popup
end type
end forward

global type w_hold_popup from w_inherite_popup
integer x = 133
integer y = 288
integer width = 3429
integer height = 1908
string title = "할당번호 선택"
end type
global w_hold_popup w_hold_popup

on w_hold_popup.create
call super::create
end on

on w_hold_popup.destroy
call super::destroy
end on

event open;call super::open;String s_param

dw_jogun.SetTransObject(SQLCA)
dw_jogun.ReSet()
dw_jogun.InsertRow(0)

s_param = Message.StringParm
s_param = trim(s_param)


if IsNull(s_param) or s_param = "" then
	dw_jogun.SetFocus()
else
	dw_jogun.object.pordno1[1] = Trim(Mid(s_param,1,16))
	dw_jogun.object.pordno2[1] = Trim(Mid(s_param,1,16))
	dw_jogun.object.itnbr1[1] = Trim(Mid(s_param,17,15))
	dw_jogun.object.itnbr2[1] = Trim(Mid(s_param,17,15))
	cb_inq.TriggerEvent(Clicked!)
end if	


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_hold_popup
integer x = 0
integer y = 36
integer height = 200
string dataobject = "d_hold_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_hold_popup
integer x = 3159
integer y = 36
end type

type p_inq from w_inherite_popup`p_inq within w_hold_popup
integer x = 2811
integer y = 36
end type

type p_choose from w_inherite_popup`p_choose within w_hold_popup
integer x = 2985
integer y = 36
end type

type dw_1 from w_inherite_popup`dw_1 within w_hold_popup
integer y = 236
integer width = 3337
integer height = 1416
integer taborder = 70
string dataobject = "d_hold_popup2"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::clicked;call super::clicked;if row < 1 then return
if this.object.sel[row] = "Y" then
	this.object.sel[row] = "N"
else	
   this.object.sel[row] = "Y"
end if	

this.ScrollToRow(row)


end event

event dw_1::rowfocuschanged;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_hold_popup
boolean visible = false
integer x = 658
integer width = 1138
integer taborder = 40
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_hold_popup
integer x = 2446
integer y = 1684
integer taborder = 50
end type

event cb_1::clicked;// Copy the data to the clipboard
gs_code = "Y"
dw_1.SaveAs("", Clipboard!, False)

Close(Parent)  

end event

type cb_return from w_inherite_popup`cb_return within w_hold_popup
integer x = 3077
integer y = 1684
integer taborder = 60
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_hold_popup
integer x = 2766
integer y = 1684
integer taborder = 30
boolean default = false
end type

event cb_inq::clicked;string pordno1, pordno2, itnbr1, itnbr2

dw_jogun.AcceptText()
pordno1 = Trim(dw_jogun.object.pordno1[1])
pordno2 = Trim(dw_jogun.object.pordno2[1])
itnbr1 = Trim(dw_jogun.object.itnbr1[1])
itnbr2 = Trim(dw_jogun.object.itnbr2[1])

if IsNull(pordno1) or pordno1 = "" THEN pordno1 = "."
if IsNull(pordno2) or pordno2 = "" THEN pordno2 = "ZZZZZZZZZZZZZZZZ"
if IsNull(itnbr1) or itnbr1 = "" THEN itnbr1 = "."
if IsNull(itnbr2) or itnbr2 = "" THEN itnbr2 = "ZZZZZZZZZZZZZZZ"

dw_1.SetReDraw(False)
dw_1.ReSet()
dw_1.SetReDraw(True)

dw_1.Retrieve(gs_sabu, pordno1, pordno2, itnbr1, itnbr2)
	
dw_1.SelectRow(0,False)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_hold_popup
boolean visible = false
integer x = 357
integer width = 302
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_hold_popup
boolean visible = false
integer x = 800
integer y = 1776
integer width = 315
string text = "A/S 센타"
end type

