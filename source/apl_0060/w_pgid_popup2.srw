$PBExportHeader$w_pgid_popup2.srw
$PBExportComments$** 중분류메뉴 조회 선택
forward
global type w_pgid_popup2 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pgid_popup2
end type
end forward

global type w_pgid_popup2 from w_inherite_popup
integer width = 1861
integer height = 1768
string title = "중분류 조회 선택"
rr_1 rr_1
end type
global w_pgid_popup2 w_pgid_popup2

on w_pgid_popup2.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pgid_popup2.destroy
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

type dw_jogun from w_inherite_popup`dw_jogun within w_pgid_popup2
boolean visible = false
integer x = 0
integer y = 2412
integer width = 384
end type

type p_exit from w_inherite_popup`p_exit within w_pgid_popup2
integer x = 1646
integer y = 24
boolean originalsize = true
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pgid_popup2
integer x = 763
integer y = 2252
end type

type p_choose from w_inherite_popup`p_choose within w_pgid_popup2
integer x = 1472
integer y = 24
boolean originalsize = true
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = string(dw_1.GetItemNumber(ll_Row, "main_id"))
gs_codename = string(dw_1.GetItemNumber(ll_Row, "sub1_id"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pgid_popup2
integer x = 46
integer y = 208
integer width = 1765
integer height = 1460
integer taborder = 10
string dataobject = "d_pgid_popup2"
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

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pgid_popup2
boolean visible = false
integer x = 585
integer y = 2480
end type

type cb_1 from w_inherite_popup`cb_1 within w_pgid_popup2
integer x = 919
integer y = 2388
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_pgid_popup2
integer x = 485
integer y = 2356
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_pgid_popup2
integer x = 832
integer y = 2420
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pgid_popup2
boolean visible = false
integer x = 402
integer y = 2480
end type

type st_1 from w_inherite_popup`st_1 within w_pgid_popup2
boolean visible = false
integer x = 123
integer y = 2492
end type

type rr_1 from roundrectangle within w_pgid_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 1787
integer height = 1480
integer cornerheight = 40
integer cornerwidth = 55
end type

