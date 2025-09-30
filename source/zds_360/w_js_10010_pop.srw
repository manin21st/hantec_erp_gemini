$PBExportHeader$w_js_10010_pop.srw
$PBExportComments$자산관리
forward
global type w_js_10010_pop from w_inherite_popup
end type
end forward

global type w_js_10010_pop from w_inherite_popup
integer width = 1321
integer height = 608
string title = "Excel Row Select"
end type
global w_js_10010_pop w_js_10010_pop

event open;//

f_window_center(this)

//dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)


end event

on w_js_10010_pop.create
call super::create
end on

on w_js_10010_pop.destroy
call super::destroy
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_js_10010_pop
boolean visible = false
integer x = 1152
integer y = 756
integer width = 96
integer height = 84
boolean enabled = false
boolean livescroll = false
end type

type p_exit from w_inherite_popup`p_exit within w_js_10010_pop
boolean visible = false
integer x = 1093
integer y = 608
boolean enabled = false
end type

type p_inq from w_inherite_popup`p_inq within w_js_10010_pop
boolean visible = false
integer x = 745
integer y = 608
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_js_10010_pop
boolean visible = false
integer x = 919
integer y = 608
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_js_10010_pop
integer x = 0
integer y = 0
integer width = 1312
integer height = 560
string dataobject = "d_js_10010_003"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::buttonclicked;call super::buttonclicked;This.AcceptText()

If row < 1 Then Return

Long   ll_data

SetNull(gs_code)

Choose Case dwo.name
	Case 'b_1'
		ll_data = This.GetItemNumber(row, 'line')
		If ll_data < 1 OR IsNull(ll_data) Then
			gs_code = 'x'
		Else
			gs_code = String(ll_data)
		End If
	Case 'b_2'
		gs_code = 'z'
End Choose

Close(Parent)
end event

event dw_1::rowfocuschanged;//

end event

type sle_2 from w_inherite_popup`sle_2 within w_js_10010_pop
end type

type cb_1 from w_inherite_popup`cb_1 within w_js_10010_pop
end type

type cb_return from w_inherite_popup`cb_return within w_js_10010_pop
end type

type cb_inq from w_inherite_popup`cb_inq within w_js_10010_pop
end type

type sle_1 from w_inherite_popup`sle_1 within w_js_10010_pop
end type

type st_1 from w_inherite_popup`st_1 within w_js_10010_pop
end type

