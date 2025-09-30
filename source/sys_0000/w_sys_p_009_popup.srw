$PBExportHeader$w_sys_p_009_popup.srw
$PBExportComments$** 프로그램 사용내역 조회 출력 PopUp
forward
global type w_sys_p_009_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sys_p_009_popup
end type
end forward

global type w_sys_p_009_popup from w_inherite_popup
integer x = 960
integer y = 236
integer width = 2098
integer height = 1756
string title = "Program 조회 선택"
rr_1 rr_1
end type
global w_sys_p_009_popup w_sys_p_009_popup

on w_sys_p_009_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sys_p_009_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_1.Retrieve()
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sys_p_009_popup
boolean visible = false
integer x = 288
integer y = 1868
integer width = 512
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_sys_p_009_popup
integer x = 1874
integer y = 12
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sys_p_009_popup
boolean visible = false
integer x = 786
integer y = 1908
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_sys_p_009_popup
integer x = 1701
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "winid")
gs_codename = dw_1.GetItemString(ll_Row, "winname")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sys_p_009_popup
integer x = 37
integer y = 184
integer width = 1998
integer height = 1456
integer taborder = 10
string dataobject = "d_sys_p_009_popup"
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

gs_code = dw_1.GetItemString(Row, "winid")
gs_codename = dw_1.GetItemString(Row, "winname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sys_p_009_popup
boolean visible = false
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_sys_p_009_popup
boolean visible = false
integer x = 946
integer y = 1900
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sys_p_009_popup
boolean visible = false
integer x = 1266
integer y = 1900
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sys_p_009_popup
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sys_p_009_popup
boolean visible = false
integer taborder = 0
end type

type st_1 from w_inherite_popup`st_1 within w_sys_p_009_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_sys_p_009_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 2016
integer height = 1476
integer cornerheight = 40
integer cornerwidth = 55
end type

