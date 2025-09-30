$PBExportHeader$w_employee1_saup_popup.srw
$PBExportComments$** 사원 조회 선택(동명이인)
forward
global type w_employee1_saup_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_employee1_saup_popup
end type
end forward

global type w_employee1_saup_popup from w_inherite_popup
integer x = 1120
integer y = 112
integer width = 2359
integer height = 1620
string title = "사원 조회 선택(동명이인)"
boolean controlmenu = true
rr_1 rr_1
end type
global w_employee1_saup_popup w_employee1_saup_popup

event open;call super::open;String sname

sname= message.stringparm

setnull(gs_code)
setnull(gs_codename)

dw_1.Retrieve(gs_company,sname + '%', gs_gubun)
dw_1.Setfocus()

end event

on w_employee1_saup_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_employee1_saup_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_employee1_saup_popup
boolean visible = false
integer x = 0
integer y = 2344
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_employee1_saup_popup
integer x = 2153
integer y = 8
integer taborder = 20
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_employee1_saup_popup
boolean visible = false
integer x = 1723
integer y = 2196
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_employee1_saup_popup
integer x = 1979
integer y = 8
integer taborder = 10
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)


end event

type dw_1 from w_inherite_popup`dw_1 within w_employee1_saup_popup
integer x = 32
integer y = 164
integer width = 2281
integer height = 1356
string dataobject = "d_employee1_popup"
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

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_employee1_saup_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_employee1_saup_popup
boolean visible = false
end type

type cb_return from w_inherite_popup`cb_return within w_employee1_saup_popup
boolean visible = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_employee1_saup_popup
boolean visible = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_employee1_saup_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_employee1_saup_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_employee1_saup_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 160
integer width = 2304
integer height = 1368
integer cornerheight = 40
integer cornerwidth = 46
end type

