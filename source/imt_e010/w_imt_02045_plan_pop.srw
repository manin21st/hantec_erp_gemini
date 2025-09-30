$PBExportHeader$w_imt_02045_plan_pop.srw
$PBExportComments$외주계획 직납처리
forward
global type w_imt_02045_plan_pop from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_imt_02045_plan_pop
end type
type rr_1 from roundrectangle within w_imt_02045_plan_pop
end type
end forward

global type w_imt_02045_plan_pop from w_inherite_popup
integer width = 2958
integer height = 1904
string title = "주간 계획 자료 선택"
boolean controlmenu = true
event ue_open ( )
pb_1 pb_1
rr_1 rr_1
end type
global w_imt_02045_plan_pop w_imt_02045_plan_pop

event ue_open();dw_jogun.SetItem(1, 'cvcod', gs_code)
dw_jogun.SetItem(1, 'cvnas', gs_codename)

Long   ll_dn
Date   ldt_mon

ll_dn = DayNumber(TODAY())
If ll_dn <> 2 Then
	If ll_dn = 1 Then
		ldt_mon = RelativeDate(TODAY(), -6)
	Else
		ldt_mon = RelativeDate(TODAY(), 2 - ll_dn)
	End If
Else
	ldt_mon = TODAY()
End If

String ls_monday
ls_monday = String(ldt_mon, 'yyyymmdd')

dw_jogun.SetItem(1, 'd_plan', ls_monday)
end event

on w_imt_02045_plan_pop.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_imt_02045_plan_pop.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imt_02045_plan_pop
integer x = 32
integer y = 32
integer width = 1765
integer height = 164
string dataobject = "d_imt_02045_plan_001"
end type

event dw_jogun::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type p_exit from w_inherite_popup`p_exit within w_imt_02045_plan_pop
integer x = 2725
integer y = 36
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imt_02045_plan_pop
integer x = 2377
integer y = 36
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_plan
ls_plan = dw_jogun.GetItemString(row, 'd_plan')
If Trim(ls_plan) = '' OR IsNull(ls_plan) Then
	MessageBox('계획일자 확인', '계획일자를 확인 하십시오.')
	dw_jogun.SetColumn('d_plan')
	dw_jogun.SetFocus()
	Return
End If

String ls_cvcod
ls_cvcod = dw_jogun.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('거래처 확인', '거래처를 확인 하십시오.')
	dw_jogun.SetColumn('d_plan')
	dw_jogun.SetFocus()
	Return
End If

dw_1.SetRedraw(False)
dw_1.Retrieve(gs_saupj, ls_plan, ls_cvcod)
dw_1.SetRedraw(True)
end event

type p_choose from w_inherite_popup`p_choose within w_imt_02045_plan_pop
integer x = 2551
integer y = 36
end type

event p_choose::clicked;call super::clicked;gs_gubun = dw_jogun.GetItemString(1, 'd_plan')
dw_1.SaveAs('', ClipBoard!, False)
Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_imt_02045_plan_pop
integer x = 41
integer y = 220
integer width = 2862
integer height = 1556
string dataobject = "d_imt_02045_plan_002"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::clicked;call super::clicked;This.SelectRow(0, False)
This.SelectRow(row, True)
end event

type sle_2 from w_inherite_popup`sle_2 within w_imt_02045_plan_pop
end type

type cb_1 from w_inherite_popup`cb_1 within w_imt_02045_plan_pop
end type

type cb_return from w_inherite_popup`cb_return within w_imt_02045_plan_pop
end type

type cb_inq from w_inherite_popup`cb_inq within w_imt_02045_plan_pop
end type

type sle_1 from w_inherite_popup`sle_1 within w_imt_02045_plan_pop
end type

type st_1 from w_inherite_popup`st_1 within w_imt_02045_plan_pop
end type

type pb_1 from u_pb_cal within w_imt_02045_plan_pop
integer x = 599
integer y = 68
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_jogun.SetColumn('d_plan')
IF IsNull(gs_code) THEN Return
ll_row = dw_jogun.GetRow()
If ll_row < 1 Then Return
dw_jogun.SetItem(ll_row, 'd_plan', gs_code)



end event

type rr_1 from roundrectangle within w_imt_02045_plan_pop
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 2894
integer height = 1584
integer cornerheight = 40
integer cornerwidth = 55
end type

