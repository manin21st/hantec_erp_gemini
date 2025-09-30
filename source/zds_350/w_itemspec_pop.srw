$PBExportHeader$w_itemspec_pop.srw
$PBExportComments$품목선택 팝업(bom)
forward
global type w_itemspec_pop from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itemspec_pop
end type
end forward

global type w_itemspec_pop from w_inherite_popup
integer width = 2903
integer height = 2024
rr_1 rr_1
end type
global w_itemspec_pop w_itemspec_pop

on w_itemspec_pop.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itemspec_pop.destroy
call super::destroy
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_itemspec_pop
integer x = 37
integer y = 32
integer width = 1042
integer height = 192
string dataobject = "d_itemspec_pop_001"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

Choose Case dwo.name
	Case 'itnbr'
		gs_gubun = '3'
		
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr', gs_code)
		
End Choose
end event

event dw_jogun::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type p_exit from w_inherite_popup`p_exit within w_itemspec_pop
integer x = 2656
integer y = 56
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemspec_pop
integer x = 2309
integer y = 56
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_itnbr

ls_itnbr = dw_jogun.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_itnbr)
dw_1.SetRedraw(True)
end event

type p_choose from w_inherite_popup`p_choose within w_itemspec_pop
integer x = 2482
integer y = 56
end type

event p_choose::clicked;call super::clicked;Long   ll_cnt

ll_cnt = dw_1.RowCount()
If ll_cnt < 1 Then Return

Long   i

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(gs_codename2)

For i = 0 To ll_cnt
	i = dw_1.GetSelectedRow(i)
	If i < 1 Then Exit
	
	gs_code     = dw_1.GetItemString(i, 'pstruc_pinbr')
	gs_codename = dw_1.GetItemString(i, 'itemas_itnbr')
	
Next

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_itemspec_pop
integer x = 50
integer y = 252
integer width = 2798
integer height = 1648
string dataobject = "d_itemspec_pop_002"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::doubleclicked;call super::doubleclicked;p_choose.TriggerEvent('Clicked')
end event

type sle_2 from w_inherite_popup`sle_2 within w_itemspec_pop
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemspec_pop
end type

type cb_return from w_inherite_popup`cb_return within w_itemspec_pop
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemspec_pop
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemspec_pop
end type

type st_1 from w_inherite_popup`st_1 within w_itemspec_pop
end type

type rr_1 from roundrectangle within w_itemspec_pop
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 2830
integer height = 1672
integer cornerheight = 40
integer cornerwidth = 55
end type

