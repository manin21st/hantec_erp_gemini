$PBExportHeader$w_level_salary_popup.srw
$PBExportComments$** 급호 조회 선택
forward
global type w_level_salary_popup from w_inherite_popup
end type
type dw_level from datawindow within w_level_salary_popup
end type
type rr_1 from roundrectangle within w_level_salary_popup
end type
end forward

global type w_level_salary_popup from w_inherite_popup
integer x = 2011
integer y = 4
integer width = 1934
integer height = 2372
string title = "급호 조회 선택"
boolean controlmenu = true
dw_level dw_level
rr_1 rr_1
end type
global w_level_salary_popup w_level_salary_popup

event key;call super::key;String slevel

choose case key
	case keyenter!		
		dw_1.Retrieve(gs_company,dw_level.GetItemString(1,"levelcode"))
end choose
end event

event open;call super::open;dw_level.SetTransObject(SQLCA)
dw_level.Reset()
dw_level.Insertrow(0)

dw_level.SetItem(1,"levelcode",gs_code)
 

dw_1.Retrieve(gs_company,gs_code, gs_codename)
SetNull(gs_code)
SetNull(gs_codename)

dw_1.SetFocus()
end event

on w_level_salary_popup.create
int iCurrent
call super::create
this.dw_level=create dw_level
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_level
this.Control[iCurrent+2]=this.rr_1
end on

on w_level_salary_popup.destroy
call super::destroy
destroy(this.dw_level)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_level_salary_popup
boolean visible = false
integer x = 0
integer y = 2644
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_level_salary_popup
integer x = 1701
integer y = 40
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_level_salary_popup
boolean visible = false
integer x = 1723
integer y = 2496
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_level_salary_popup
integer x = 1522
integer y = 40
integer taborder = 20
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "levelcode")
gs_codename = dw_1.GetItemString(ll_Row, "salary")

Close(Parent)



end event

type dw_1 from w_inherite_popup`dw_1 within w_level_salary_popup
integer x = 27
integer y = 228
integer width = 1847
integer height = 2028
string dataobject = "d_level_salary_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE
   dw_1.setfocus()
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

gs_code = dw_1.GetItemString(Row, "levelcode")
gs_codename = dw_1.GetItemString(Row, "salary")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_level_salary_popup
boolean visible = false
integer y = 2552
end type

type cb_1 from w_inherite_popup`cb_1 within w_level_salary_popup
boolean visible = false
integer x = 498
integer y = 2444
end type

type cb_return from w_inherite_popup`cb_return within w_level_salary_popup
boolean visible = false
integer x = 1134
integer y = 2444
end type

type cb_inq from w_inherite_popup`cb_inq within w_level_salary_popup
boolean visible = false
integer x = 818
integer y = 2444
end type

type sle_1 from w_inherite_popup`sle_1 within w_level_salary_popup
boolean visible = false
integer y = 2552
end type

type st_1 from w_inherite_popup`st_1 within w_level_salary_popup
boolean visible = false
integer y = 2564
end type

type dw_level from datawindow within w_level_salary_popup
integer x = 27
integer y = 24
integer width = 946
integer height = 192
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_level_salary_popup_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_level_salary_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 224
integer width = 1874
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 46
end type

