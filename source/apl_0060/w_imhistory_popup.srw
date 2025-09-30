$PBExportHeader$w_imhistory_popup.srw
$PBExportComments$** 전표이력 조회 선택
forward
global type w_imhistory_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_imhistory_popup
end type
type pb_2 from u_pb_cal within w_imhistory_popup
end type
type rr_1 from roundrectangle within w_imhistory_popup
end type
end forward

global type w_imhistory_popup from w_inherite_popup
integer x = 133
integer y = 124
integer width = 3232
integer height = 2076
string title = "전표 이력 조회 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imhistory_popup w_imhistory_popup

on w_imhistory_popup.create
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

on w_imhistory_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.setitem(1, 'gub', gs_code )
dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imhistory_popup
integer x = 46
integer y = 28
integer width = 2112
integer height = 160
string dataobject = "d_imhistory_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_imhistory_popup
integer x = 3022
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imhistory_popup
integer x = 2674
integer y = 16
end type

event p_inq::clicked;call super::clicked;
String sdatef,sdatet

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef = TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet = TRIM(dw_jogun.GetItemString(1,"to_date"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu,sdatef,sdatet, gs_code) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_imhistory_popup
integer x = 2848
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "iojpno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_imhistory_popup
integer x = 50
integer y = 216
integer width = 3122
integer height = 1700
string dataobject = "d_imhistory_popup1"
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

gs_code= dw_1.GetItemString(Row, "iojpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_imhistory_popup
boolean visible = false
integer x = 933
integer y = 2092
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_imhistory_popup
integer x = 590
integer y = 2044
end type

type cb_return from w_inherite_popup`cb_return within w_imhistory_popup
integer x = 1211
integer y = 2044
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_imhistory_popup
integer x = 901
integer y = 2044
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_imhistory_popup
boolean visible = false
integer x = 270
integer y = 2092
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imhistory_popup
boolean visible = false
integer y = 2112
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_imhistory_popup
integer x = 526
integer y = 64
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_imhistory_popup
integer x = 965
integer y = 64
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_imhistory_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 212
integer width = 3141
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

