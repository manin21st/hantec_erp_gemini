$PBExportHeader$w_vndmst_4_popup.srw
$PBExportComments$** 부서 조회 선택
forward
global type w_vndmst_4_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_vndmst_4_popup
end type
end forward

global type w_vndmst_4_popup from w_inherite_popup
integer width = 1577
integer height = 1932
string title = "부서 조회 선택"
boolean controlmenu = true
rr_1 rr_1
end type
global w_vndmst_4_popup w_vndmst_4_popup

on w_vndmst_4_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_vndmst_4_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;
dw_1.Retrieve()
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_vndmst_4_popup
boolean visible = false
integer x = 0
integer y = 2168
integer width = 1298
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_vndmst_4_popup
integer x = 1371
integer y = 16
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_vndmst_4_popup
boolean visible = false
integer x = 439
integer y = 2228
end type

type p_choose from w_inherite_popup`p_choose within w_vndmst_4_popup
integer x = 1198
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
ELSE
	IF dw_1.GetItemString(ll_row,"cvstatus") = '2' THEN
		MessageBox("확 인","사용되지 않는 부서입니다!!")
		Return
	END IF
END IF

gs_code = dw_1.GetItemString(ll_Row, "cvcod")
gs_codename = dw_1.GetItemString(ll_Row, "cvnas2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_vndmst_4_popup
integer x = 23
integer y = 192
integer width = 1509
integer height = 1608
integer taborder = 10
string dataobject = "d_vndmst_4_popup"
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
ELSE
	IF dw_1.GetItemString(row,"cvstatus") = '2' THEN
		MessageBox("확 인","사용되지 않는 부서입니다!!")
		Return
	END IF
END IF

gs_code = dw_1.GetItemString(Row, "cvcod")
gs_codename = dw_1.GetItemString(Row, "cvnas2")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_vndmst_4_popup
boolean visible = false
integer y = 2304
integer width = 713
end type

type cb_1 from w_inherite_popup`cb_1 within w_vndmst_4_popup
integer x = 370
integer y = 2008
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_vndmst_4_popup
integer x = 681
integer y = 2008
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_vndmst_4_popup
integer x = 677
integer y = 2212
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_vndmst_4_popup
boolean visible = false
integer y = 2304
end type

type st_1 from w_inherite_popup`st_1 within w_vndmst_4_popup
boolean visible = false
integer y = 2316
end type

type rr_1 from roundrectangle within w_vndmst_4_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 188
integer width = 1527
integer height = 1628
integer cornerheight = 40
integer cornerwidth = 55
end type

