$PBExportHeader$w_haldang_popup_1.srw
$PBExportComments$출고의뢰(폐기)-할당내역조회
forward
global type w_haldang_popup_1 from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_haldang_popup_1
end type
type pb_2 from u_pb_cal within w_haldang_popup_1
end type
type rr_1 from roundrectangle within w_haldang_popup_1
end type
end forward

global type w_haldang_popup_1 from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3227
integer height = 2088
string title = "출고의뢰번호 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_haldang_popup_1 w_haldang_popup_1

on w_haldang_popup_1.create
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

on w_haldang_popup_1.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)


dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_haldang_popup_1
integer x = 0
integer y = 156
integer width = 3195
integer height = 148
string dataobject = "d_haldang_popup_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String snull

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = 'dept'	THEN // 부서

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",	gs_code)
	SetItem(1,"deptname", gs_codename)
END IF

end event

type p_exit from w_inherite_popup`p_exit within w_haldang_popup_1
integer x = 3003
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_haldang_popup_1
integer x = 2656
integer y = 12
end type

event p_inq::clicked;call super::clicked;
String sdatef,sdatet,sdept,shosts

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef = trim(dw_jogun.GetItemString(1,"fr_date"))
sdatet = trim(dw_jogun.GetItemString(1,"to_date"))
sdept  = trim(dw_jogun.GetItemString(1,"dept"))
shosts = dw_jogun.GetItemString(1,"hosts")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sdept = '' OR Isnull(sdept)	THEN
	sdept = '%'
END IF

IF shosts = '' OR Isnull(shosts)	THEN
	shosts = 'N'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, sdatef, sdatet, sdept, shosts) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_haldang_popup_1
integer x = 2830
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "holdstock_hold_no")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_haldang_popup_1
integer y = 320
integer width = 3159
integer height = 1652
string dataobject = "d_haldang_popup1_1"
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

gs_code= dw_1.GetItemString(Row, "holdstock_hold_no")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_haldang_popup_1
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_haldang_popup_1
integer x = 27
integer y = 2036
end type

type cb_return from w_inherite_popup`cb_return within w_haldang_popup_1
integer x = 649
integer y = 2036
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_haldang_popup_1
integer x = 338
integer y = 2036
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_haldang_popup_1
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_haldang_popup_1
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_haldang_popup_1
integer x = 608
integer y = 196
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_haldang_popup_1
integer x = 1070
integer y = 196
integer taborder = 30
boolean bringtotop = true
integer weight = 700
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_haldang_popup_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 316
integer width = 3177
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

