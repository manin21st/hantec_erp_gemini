$PBExportHeader$w_bom_itnbr_kum.srw
$PBExportComments$대표품번의 하위품번 선택 popup
forward
global type w_bom_itnbr_kum from w_inherite_popup
end type
type rr_1 from roundrectangle within w_bom_itnbr_kum
end type
end forward

global type w_bom_itnbr_kum from w_inherite_popup
integer width = 3401
integer height = 1944
string title = "원자재 품번 선택"
rr_1 rr_1
end type
global w_bom_itnbr_kum w_bom_itnbr_kum

on w_bom_itnbr_kum.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_bom_itnbr_kum.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetItem(1, 'itnbr', gs_code)
dw_jogun.SetItem(1, 'itdsc', f_get_name5('13', gs_code, ''))

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_bom_itnbr_kum
integer x = 27
integer y = 24
integer width = 2066
string dataobject = "d_bom_itnbr_kum_001"
end type

event dw_jogun::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type p_exit from w_inherite_popup`p_exit within w_bom_itnbr_kum
integer x = 3168
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_bom_itnbr_kum
integer x = 2821
end type

event p_inq::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_itnbr

ls_itnbr = dw_jogun.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	MessageBox('대표품번 확인', '대표품번을 확인 하십시오.')
	Return
End If

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_itnbr)
dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_bom_itnbr_kum
integer x = 2994
end type

event p_choose::clicked;call super::clicked;Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_itnbr

ls_itnbr = dw_1.GetItemString(row, 'cinbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	MessageBox('원자재 품번 선택', '하위 품번을 선택 하십시오.')
	Return
End If

String ls_itdsc

ls_itdsc = dw_1.GetItemString(row, 'itdsc')
If Trim(ls_itdsc) = '' OR IsNull(ls_itdsc) Then
	MessageBox('원자재 품명 선택', '하위 품명을 선택하십시오')
	Return
End If

SetNull(gs_code)
SetNull(gs_codename)

gs_code     = ls_itnbr
gs_codename = ls_itdsc

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_bom_itnbr_kum
integer x = 41
integer y = 192
integer width = 3301
integer height = 1624
string dataobject = "d_bom_itnbr_kum"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::doubleclicked;call super::doubleclicked;p_choose.TriggerEvent('Clicked')
end event

type sle_2 from w_inherite_popup`sle_2 within w_bom_itnbr_kum
end type

type cb_1 from w_inherite_popup`cb_1 within w_bom_itnbr_kum
boolean visible = false
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_bom_itnbr_kum
boolean visible = false
boolean enabled = false
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_bom_itnbr_kum
boolean visible = false
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_bom_itnbr_kum
end type

type st_1 from w_inherite_popup`st_1 within w_bom_itnbr_kum
end type

type rr_1 from roundrectangle within w_bom_itnbr_kum
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 180
integer width = 3333
integer height = 1648
integer cornerheight = 40
integer cornerwidth = 55
end type

