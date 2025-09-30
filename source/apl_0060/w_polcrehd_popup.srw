$PBExportHeader$w_polcrehd_popup.srw
$PBExportComments$결제상환조회
forward
global type w_polcrehd_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_polcrehd_popup
end type
type pb_2 from u_pb_cal within w_polcrehd_popup
end type
type rr_1 from roundrectangle within w_polcrehd_popup
end type
end forward

global type w_polcrehd_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3209
integer height = 1956
string title = "상환번호 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_polcrehd_popup w_polcrehd_popup

on w_polcrehd_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_polcrehd_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_polcrehd_popup
integer x = 27
integer y = 32
integer width = 1490
integer height = 128
string dataobject = "d_polcrehd_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_polcrehd_popup
integer x = 2994
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_polcrehd_popup
integer x = 2647
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sFdate, sTdate

if dw_jogun.AcceptText() = -1 then return

sFdate = trim(dw_jogun.GetItemString(1, 'fdate'))
sTdate = trim(dw_jogun.GetItemString(1, 'tdate'))

IF sFdate = "" OR IsNull(sFdate) THEN
	sFdate = '10000101'
END IF

IF stdate = "" OR IsNull(stdate) THEN
	stdate = '99991231'
END IF

IF dw_1.Retrieve(gs_sabu, sfdate, stdate) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn(1)
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_polcrehd_popup
integer x = 2821
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "retno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_polcrehd_popup
integer x = 37
integer y = 196
integer width = 3127
integer height = 1644
string dataobject = "d_polcrehd_popup"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "retno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_polcrehd_popup
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_polcrehd_popup
integer x = 9
integer y = 2072
end type

type cb_return from w_inherite_popup`cb_return within w_polcrehd_popup
integer x = 631
integer y = 2072
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_polcrehd_popup
integer x = 320
integer y = 2072
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_polcrehd_popup
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_polcrehd_popup
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_polcrehd_popup
integer x = 686
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fdate', gs_code)
end event

type pb_2 from u_pb_cal within w_polcrehd_popup
integer x = 1152
integer y = 48
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('tdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'tdate', gs_code)
end event

type rr_1 from roundrectangle within w_polcrehd_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 192
integer width = 3150
integer height = 1660
integer cornerheight = 40
integer cornerwidth = 55
end type

