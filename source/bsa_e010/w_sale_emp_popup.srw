$PBExportHeader$w_sale_emp_popup.srw
$PBExportComments$영업담당자(입금) 선택 조회 POPUP
forward
global type w_sale_emp_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sale_emp_popup
end type
end forward

global type w_sale_emp_popup from w_inherite_popup
integer x = 1170
integer y = 412
integer width = 1179
integer height = 1796
string title = "영업 담당자 조회 선택"
rr_1 rr_1
end type
global w_sale_emp_popup w_sale_emp_popup

on w_sale_emp_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sale_emp_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;String sdepot

dw_1.SetTransObject(SQLCA)

dw_1.Retrieve()

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sale_emp_popup
integer x = 87
integer y = 1892
integer width = 123
end type

type p_exit from w_inherite_popup`p_exit within w_sale_emp_popup
integer x = 923
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sale_emp_popup
integer x = 576
integer y = 16
end type

event p_inq::clicked;call super::clicked;String scode

dw_1.Retrieve()

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_sale_emp_popup
integer x = 750
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

SetNull(gs_gubun)
gs_code = dw_1.GetItemString(ll_Row, "rfgub")
gs_codename = dw_1.GetItemString(ll_Row, "rfna1")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sale_emp_popup
integer x = 37
integer y = 188
integer width = 1051
integer height = 1468
integer taborder = 10
string dataobject = "d_sale_emp_popup"
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

SetNull(gs_gubun)
gs_code = dw_1.GetItemString(Row, "rfgub")
gs_codename = dw_1.GetItemString(Row, "rfna1")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sale_emp_popup
boolean visible = false
integer x = 453
integer y = 2000
integer width = 434
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_sale_emp_popup
boolean visible = false
integer x = 238
integer y = 1956
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sale_emp_popup
boolean visible = false
integer x = 850
integer y = 1956
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sale_emp_popup
boolean visible = false
integer x = 544
integer y = 1956
integer taborder = 30
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sale_emp_popup
boolean visible = false
integer x = 622
integer y = 1888
integer width = 197
integer taborder = 0
long backcolor = 1090519039
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_sale_emp_popup
boolean visible = false
integer x = 411
integer y = 1896
integer width = 155
boolean enabled = true
string text = "사원"
alignment alignment = right!
end type

type rr_1 from roundrectangle within w_sale_emp_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 180
integer width = 1074
integer height = 1484
integer cornerheight = 40
integer cornerwidth = 55
end type

