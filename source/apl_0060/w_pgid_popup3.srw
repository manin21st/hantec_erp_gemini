$PBExportHeader$w_pgid_popup3.srw
$PBExportComments$** 소분류메뉴 조회 선택
forward
global type w_pgid_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pgid_popup3
end type
end forward

global type w_pgid_popup3 from w_inherite_popup
integer x = 1408
integer y = 260
integer width = 2199
integer height = 1756
string title = "소분류 조회 선택"
rr_1 rr_1
end type
global w_pgid_popup3 w_pgid_popup3

on w_pgid_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pgid_popup3.destroy
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

type dw_jogun from w_inherite_popup`dw_jogun within w_pgid_popup3
boolean visible = false
integer x = 27
integer y = 1908
integer width = 224
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_pgid_popup3
integer x = 1979
integer y = 16
end type

event p_exit::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = string(dw_1.GetItemNumber(ll_Row, "main_id"))
gs_codename = string(dw_1.GetItemNumber(ll_Row, "sub1_id"))
gs_gubun = string(dw_1.GetItemNumber(ll_Row, "sub2_id"))

Close(Parent)

end event

type p_inq from w_inherite_popup`p_inq within w_pgid_popup3
boolean visible = false
integer x = 215
integer y = 1908
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_pgid_popup3
integer x = 1806
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = string(dw_1.GetItemNumber(ll_Row, "main_id"))
gs_codename = string(dw_1.GetItemNumber(ll_Row, "sub1_id"))
gs_gubun = string(dw_1.GetItemNumber(ll_Row, "sub2_id"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pgid_popup3
integer x = 32
integer y = 180
integer width = 2112
integer height = 1460
integer taborder = 10
string dataobject = "d_pgid_popup3"
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

gs_code = string(dw_1.GetItemNumber(Row, "main_id"))
gs_codename = string(dw_1.GetItemNumber(Row, "sub1_id"))
gs_gubun = string(dw_1.GetItemNumber(Row, "sub2_id"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pgid_popup3
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pgid_popup3
boolean visible = false
integer x = 402
integer y = 1848
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_pgid_popup3
boolean visible = false
integer x = 722
integer y = 1848
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pgid_popup3
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pgid_popup3
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_pgid_popup3
boolean visible = false
end type

type rr_1 from roundrectangle within w_pgid_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 176
integer width = 2130
integer height = 1472
integer cornerheight = 40
integer cornerwidth = 55
end type

