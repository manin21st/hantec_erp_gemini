$PBExportHeader$w_sys_dept_popup.srw
$PBExportComments$** �μ� ��ȸ ����
forward
global type w_sys_dept_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sys_dept_popup
end type
end forward

global type w_sys_dept_popup from w_inherite_popup
integer width = 1504
integer height = 1764
string title = "�μ� ��ȸ ����"
rr_1 rr_1
end type
global w_sys_dept_popup w_sys_dept_popup

on w_sys_dept_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sys_dept_popup.destroy
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

type dw_jogun from w_inherite_popup`dw_jogun within w_sys_dept_popup
integer x = 654
integer y = 1788
integer width = 55
integer height = 36
end type

type p_exit from w_inherite_popup`p_exit within w_sys_dept_popup
integer x = 1275
integer y = 12
end type

event clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sys_dept_popup
boolean visible = false
integer x = 1111
integer y = 1780
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_sys_dept_popup
integer x = 1102
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
ELSE
	IF dw_1.GetItemString(ll_row,"cvstatus") = '2' THEN
		MessageBox("Ȯ ��","������ �ʴ� �μ��Դϴ�!!")
		Return
	END IF
END IF

gs_code = dw_1.GetItemString(ll_Row, "cvcod")
gs_codename = dw_1.GetItemString(ll_Row, "cvnas2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sys_dept_popup
integer x = 37
integer y = 188
integer width = 1413
integer height = 1456
integer taborder = 10
string dataobject = "d_sys_dept_popup"
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
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
ELSE
	IF dw_1.GetItemString(row,"cvstatus") = '2' THEN
		MessageBox("Ȯ ��","������ �ʴ� �μ��Դϴ�!!")
		Return
	END IF
END IF

gs_code = dw_1.GetItemString(Row, "cvcod")
gs_codename = dw_1.GetItemString(Row, "cvnas2")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sys_dept_popup
boolean visible = false
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_sys_dept_popup
boolean visible = false
integer x = 325
integer y = 1808
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sys_dept_popup
boolean visible = false
integer x = 635
integer y = 1808
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sys_dept_popup
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sys_dept_popup
boolean visible = false
integer taborder = 0
end type

type st_1 from w_inherite_popup`st_1 within w_sys_dept_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_sys_dept_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 176
integer width = 1431
integer height = 1476
integer cornerheight = 40
integer cornerwidth = 55
end type

