$PBExportHeader$w_kumno_kumgubn.srw
$PBExportComments$금형 분류코드 선택
forward
global type w_kumno_kumgubn from w_inherite_popup
end type
type rr_1 from roundrectangle within w_kumno_kumgubn
end type
end forward

global type w_kumno_kumgubn from w_inherite_popup
integer width = 1719
integer height = 1900
string title = "금형 분류코드 선택"
rr_1 rr_1
end type
global w_kumno_kumgubn w_kumno_kumgubn

on w_kumno_kumgubn.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kumno_kumgubn.destroy
call super::destroy
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_kumno_kumgubn
integer x = 32
integer y = 24
integer width = 1065
integer height = 152
string dataobject = "d_kumno_kumgubn_001"
end type

event dw_jogun::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type p_exit from w_inherite_popup`p_exit within w_kumno_kumgubn
integer x = 1504
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kumno_kumgubn
integer x = 1157
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_grp

ls_grp = dw_jogun.GetItemString(row, 'grpcod')
If Trim(ls_grp) = '' OR IsNull(ls_grp) Then
	ls_grp = '%'
Else
	ls_grp = ls_grp + '%'
End If

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_grp)
dw_1.SetRedraw(True)


end event

type p_choose from w_inherite_popup`p_choose within w_kumno_kumgubn
integer x = 1330
end type

event p_choose::clicked;call super::clicked;If dw_1.RowCount() < 1 Then Return

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

gs_code = dw_1.GetItemString(row, 'grpcod')
If Trim(gs_code) = '' OR IsNull(gs_code) Then
	MessageBox('분류코드선택', '분류코드를 선택하십시오')
	Return
End If

gs_codename = dw_1.GetItemString(row, 'grpnam')

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_kumno_kumgubn
integer x = 41
integer y = 204
integer width = 1623
integer height = 1568
string dataobject = "d_kumno_kumgubn_002"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::doubleclicked;call super::doubleclicked;If row < 1 Then Return

gs_code = This.GetItemString(row, 'grpcod')
If Trim(gs_code) = '' OR IsNull(gs_code) Then
	MessageBox('분류코드 확인', '분류코드를 선택하십시오.')
	Return
End If

gs_codename = This.GetItemString(row, 'grpnam')

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_kumno_kumgubn
end type

type cb_1 from w_inherite_popup`cb_1 within w_kumno_kumgubn
end type

type cb_return from w_inherite_popup`cb_return within w_kumno_kumgubn
end type

type cb_inq from w_inherite_popup`cb_inq within w_kumno_kumgubn
end type

type sle_1 from w_inherite_popup`sle_1 within w_kumno_kumgubn
end type

type st_1 from w_inherite_popup`st_1 within w_kumno_kumgubn
end type

type rr_1 from roundrectangle within w_kumno_kumgubn
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 192
integer width = 1650
integer height = 1596
integer cornerheight = 40
integer cornerwidth = 55
end type

