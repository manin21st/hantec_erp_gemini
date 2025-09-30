$PBExportHeader$w_depot_emp_popup.srw
$PBExportComments$** 창고 담당자 조회 선택
forward
global type w_depot_emp_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_depot_emp_popup
end type
end forward

global type w_depot_emp_popup from w_inherite_popup
integer x = 1170
integer y = 412
integer width = 1659
integer height = 1896
string title = "창고별 담당자 조회 선택"
rr_1 rr_1
end type
global w_depot_emp_popup w_depot_emp_popup

on w_depot_emp_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_depot_emp_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;String sdepot

f_window_center_response(this)

dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

IF IsNull(gs_gubun) THEN gs_gubun ="1"
IF IsNull(gs_code) or gs_code ="" THEN 
   sdepot = '%'
	dw_jogun.object.depot.protect = '0'
ELSE
	sdepot = gs_code
	dw_jogun.object.depot.protect = '1'
END IF

dw_jogun.setitem(1, 'depot', gs_code)
dw_jogun.setitem(1, 'gub', gs_gubun)

if gs_gubun = '1' then //입고 의뢰자
	dw_1.DataObject = 'd_depot_emp_popup1'
elseif gs_gubun = '2' then //입고 승인
	dw_1.DataObject = 'd_depot_emp_popup2'
elseif gs_gubun = '3' then //출고 의뢰자
	dw_1.DataObject = 'd_depot_emp_popup3'
else
	dw_1.DataObject = 'd_depot_emp_popup4'
end if

dw_1.SetTransObject(SQLCA)

dw_1.Retrieve(sdepot)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_depot_emp_popup
integer x = 27
integer y = 36
integer width = 960
integer height = 136
string dataobject = "d_depot_emp_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_depot_emp_popup
integer x = 1454
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_depot_emp_popup
integer x = 1106
integer y = 24
end type

event p_inq::clicked;call super::clicked;String scode

if dw_jogun.accepttext() = -1 then return 

scode = dw_jogun.getitemstring(1, 'depot')

if scode = '' or isnull(scode) then scode = '%' 

dw_1.Retrieve(scode)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_depot_emp_popup
integer x = 1280
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun = dw_1.GetItemString(ll_Row, "depot_no")
gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "p1_master_empname")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_depot_emp_popup
integer x = 37
integer y = 188
integer width = 1577
integer height = 1592
integer taborder = 20
string dataobject = "d_depot_emp_popup1"
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

gs_gubun = dw_1.GetItemString(Row, "depot_no")
gs_code = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "p1_master_empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_depot_emp_popup
boolean visible = false
integer x = 434
integer width = 434
end type

type cb_1 from w_inherite_popup`cb_1 within w_depot_emp_popup
integer x = 489
integer y = 2048
end type

type cb_return from w_inherite_popup`cb_return within w_depot_emp_popup
integer x = 1102
integer y = 2048
end type

type cb_inq from w_inherite_popup`cb_inq within w_depot_emp_popup
integer x = 795
integer y = 2048
end type

type sle_1 from w_inherite_popup`sle_1 within w_depot_emp_popup
boolean visible = false
integer x = 238
integer width = 197
long backcolor = 1090519039
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_depot_emp_popup
boolean visible = false
integer x = 50
integer width = 155
boolean enabled = true
string text = "사원"
alignment alignment = right!
end type

type rr_1 from roundrectangle within w_depot_emp_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 184
integer width = 1595
integer height = 1600
integer cornerheight = 40
integer cornerwidth = 55
end type

