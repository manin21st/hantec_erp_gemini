$PBExportHeader$w_dan_item_popup.srw
$PBExportComments$거래처별 품목조회
forward
global type w_dan_item_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_dan_item_popup
end type
end forward

global type w_dan_item_popup from w_inherite_popup
integer width = 3429
string title = "거래처별 품목 선택"
rr_1 rr_1
end type
global w_dan_item_popup w_dan_item_popup

on w_dan_item_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_dan_item_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'cvcod', gs_code)
dw_jogun.SetItem(1, 'cvnas', gs_codename)

p_inq.TriggerEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_dan_item_popup
integer y = 20
integer width = 1618
string dataobject = "d_dan_item_popup_001"
end type

type p_exit from w_inherite_popup`p_exit within w_dan_item_popup
integer x = 3205
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_dan_item_popup
integer x = 2857
integer y = 24
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_cvcod

ls_cvcod = dw_jogun.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('거래처 확인', '거래처가 잘못 되었습니다.')
	Return
End If

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_cvcod)
dw_1.SetRedraw(True)

If dw_1.RowCount() < 1 Then Return


end event

type p_choose from w_inherite_popup`p_choose within w_dan_item_popup
integer x = 3031
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long   row

row = dw_1.GetRow()
If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)

gs_code = dw_1.GetItemString(row, 'danmst_itnbr')

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_dan_item_popup
integer x = 37
integer y = 200
integer width = 3346
integer height = 1728
string dataobject = "d_dan_item_popup_002"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::doubleclicked;call super::doubleclicked;p_choose.TriggerEvent(Clicked!)
end event

type sle_2 from w_inherite_popup`sle_2 within w_dan_item_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_dan_item_popup
end type

type cb_return from w_inherite_popup`cb_return within w_dan_item_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_dan_item_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_dan_item_popup
end type

type st_1 from w_inherite_popup`st_1 within w_dan_item_popup
end type

type rr_1 from roundrectangle within w_dan_item_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 188
integer width = 3374
integer height = 1756
integer cornerheight = 40
integer cornerwidth = 55
end type

