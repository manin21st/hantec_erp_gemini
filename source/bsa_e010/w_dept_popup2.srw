$PBExportHeader$w_dept_popup2.srw
$PBExportComments$부서조회(p0_dept,상위부서로 조회)
forward
global type w_dept_popup2 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_dept_popup2
end type
end forward

global type w_dept_popup2 from w_inherite_popup
integer width = 2149
integer height = 1768
string title = "부서 조회 선택"
rr_1 rr_1
end type
global w_dept_popup2 w_dept_popup2

type variables
string out_store,hold_gu

end variables

on w_dept_popup2.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_dept_popup2.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;f_window_center_response(this)

dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_dept_popup2
integer x = 32
integer y = 12
integer width = 978
string dataobject = "d_dept_level2_popup"
end type

event dw_jogun::itemchanged;call super::itemchanged;Choose Case GetColumnName()
	Case 'dept'
		p_inq.PostEvent(Clicked!)
End Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_dept_popup2
integer x = 1929
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_dept_popup2
integer x = 1582
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sarea,sdept

sdept = Trim(dw_jogun.GetItemString(1,'dept'))
IF IsNull(sdept) Or sdept = '' THEN 	sdept = ""

dw_1.Retrieve(sdept+'%')
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_dept_popup2
integer x = 1755
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "deptcode")
gs_codename= dw_1.GetItemString(ll_row,"deptname2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_dept_popup2
integer x = 41
integer y = 180
integer width = 2043
integer height = 1476
integer taborder = 20
string dataobject = "d_dept_level3_popup"
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

gs_code= dw_1.GetItemString(Row, "deptcode")
gs_codename= dw_1.GetItemString(row,"deptname2")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_dept_popup2
boolean visible = false
integer x = 805
integer y = 1896
integer width = 1225
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_dept_popup2
boolean visible = false
integer x = 910
integer y = 1864
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_dept_popup2
boolean visible = false
integer x = 1541
integer y = 1864
boolean enabled = false
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_dept_popup2
boolean visible = false
integer x = 1234
integer y = 1864
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_dept_popup2
boolean visible = false
integer x = 603
integer y = 1896
integer width = 197
boolean enabled = false
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_dept_popup2
boolean visible = false
integer x = 274
integer y = 1908
integer width = 315
string text = "거래처코드"
end type

type rr_1 from roundrectangle within w_dept_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 172
integer width = 2066
integer height = 1492
integer cornerheight = 40
integer cornerwidth = 55
end type

