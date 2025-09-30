$PBExportHeader$w_wflow_project_pop.srw
$PBExportComments$프로젝트 찾기
forward
global type w_wflow_project_pop from w_inherite_popup
end type
type rr_1 from roundrectangle within w_wflow_project_pop
end type
end forward

global type w_wflow_project_pop from w_inherite_popup
integer width = 1902
integer height = 1856
rr_1 rr_1
end type
global w_wflow_project_pop w_wflow_project_pop

on w_wflow_project_pop.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_wflow_project_pop.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.InsertRow(0)
dw_jogun.SetFocus()
dw_1.Retrieve('%', '%', '%')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_wflow_project_pop
integer x = 23
integer y = 32
integer width = 1321
integer height = 136
string dataobject = "dc_flow_project_find"
end type

type p_exit from w_inherite_popup`p_exit within w_wflow_project_pop
integer x = 1691
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
//SetNull(gs_codename)

Close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_wflow_project_pop
integer x = 1344
end type

event p_inq::clicked;call super::clicked;string ls_code, ls_name

dw_jogun.accepttext()
ls_code = dw_jogun.getitemstring(1, 'code')
ls_name = dw_jogun.getitemstring(1, 'name')
if isnull(ls_code) or ls_code = '' then
	ls_code = '%'
else
	ls_code = ls_code + '%'
end if
if isnull(ls_name) or ls_name = '' then
	ls_name = '%'
else
	ls_name = '%' + ls_name + '%'
end if

dw_1.Retrieve(ls_code, ls_name, ls_name)

end event

type p_choose from w_inherite_popup`p_choose within w_wflow_project_pop
integer x = 1518
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "proj_code")
gs_codename= dw_1.GetItemString(ll_row, "proj_name")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_wflow_project_pop
integer x = 37
integer y = 188
integer width = 1815
integer height = 1556
string dataobject = "ds_flow_project"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "proj_code")
gs_codename= dw_1.GetItemString(Row, "proj_name")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_wflow_project_pop
end type

type cb_1 from w_inherite_popup`cb_1 within w_wflow_project_pop
end type

type cb_return from w_inherite_popup`cb_return within w_wflow_project_pop
end type

type cb_inq from w_inherite_popup`cb_inq within w_wflow_project_pop
end type

type sle_1 from w_inherite_popup`sle_1 within w_wflow_project_pop
end type

type st_1 from w_inherite_popup`st_1 within w_wflow_project_pop
end type

type rr_1 from roundrectangle within w_wflow_project_pop
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 180
integer width = 1829
integer height = 1576
integer cornerheight = 40
integer cornerwidth = 55
end type

