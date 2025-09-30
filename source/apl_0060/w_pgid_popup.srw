$PBExportHeader$w_pgid_popup.srw
$PBExportComments$** 대분류메뉴 조회 선택
forward
global type w_pgid_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pgid_popup
end type
end forward

global type w_pgid_popup from w_inherite_popup
integer width = 1522
integer height = 1748
string title = "대분류 조회 선택"
rr_1 rr_1
end type
global w_pgid_popup w_pgid_popup

on w_pgid_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pgid_popup.destroy
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

type dw_jogun from w_inherite_popup`dw_jogun within w_pgid_popup
boolean visible = false
integer x = 105
integer y = 2056
integer width = 334
integer height = 100
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_pgid_popup
integer x = 1326
integer y = 16
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pgid_popup
integer x = 613
integer y = 1972
end type

type p_choose from w_inherite_popup`p_choose within w_pgid_popup
integer x = 1152
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = string(dw_1.GetItemnumber(ll_Row, "main_id"))
//gs_codename = dw_1.GetItemString(ll_Row, "sub2_name")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pgid_popup
integer x = 46
integer y = 188
integer width = 1435
integer height = 1456
integer taborder = 10
string dataobject = "d_pgid_popup"
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

gs_code = string(dw_1.GetItemNumber(Row, "main_id"))
//gs_codename = dw_1.GetItemString(Row, "sub2_name")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pgid_popup
boolean visible = false
integer y = 2224
end type

type cb_1 from w_inherite_popup`cb_1 within w_pgid_popup
integer x = 576
integer y = 2132
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_pgid_popup
integer x = 960
integer y = 2052
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_pgid_popup
integer x = 718
integer y = 1896
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pgid_popup
boolean visible = false
integer y = 2224
end type

type st_1 from w_inherite_popup`st_1 within w_pgid_popup
boolean visible = false
integer y = 2236
end type

type rr_1 from roundrectangle within w_pgid_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 180
integer width = 1454
integer height = 1472
integer cornerheight = 40
integer cornerwidth = 55
end type

