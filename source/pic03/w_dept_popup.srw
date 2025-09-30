$PBExportHeader$w_dept_popup.srw
$PBExportComments$** 부서 조회 선택
forward
global type w_dept_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_dept_popup
end type
type rb_3 from radiobutton within w_dept_popup
end type
type rb_2 from radiobutton within w_dept_popup
end type
type rb_1 from radiobutton within w_dept_popup
end type
type gb_1 from groupbox within w_dept_popup
end type
end forward

global type w_dept_popup from w_inherite_popup
integer x = 1883
integer y = 4
integer width = 1938
integer height = 2368
boolean controlmenu = true
rr_1 rr_1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
end type
global w_dept_popup w_dept_popup

type variables
String   sFlag
end variables

event open;call super::open;String schadae

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

dw_1.SetFocus()
end event

on w_dept_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_3
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_dept_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_dept_popup
boolean visible = false
integer x = 0
integer y = 2312
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_dept_popup
integer x = 1719
integer y = 12
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_dept_popup
boolean visible = false
integer x = 1966
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_dept_popup
integer x = 1545
integer y = 12
integer taborder = 20
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "deptcode")
gs_codename = dw_1.GetItemString(ll_Row, "deptname2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_dept_popup
integer x = 46
integer y = 168
integer width = 1824
integer height = 2080
string dataobject = "d_dept_popup"
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
ELSE
	IF dw_1.GetItemString(row,"usetag") = '0' THEN
		MessageBox("확 인","사용되지 않는 부서입니다!!")
		Return
	END IF
END IF

gs_code = dw_1.GetItemString(Row, "deptcode")
gs_codename = dw_1.GetItemString(Row, "deptname2")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_dept_popup
boolean visible = false
integer y = 2300
end type

type cb_1 from w_inherite_popup`cb_1 within w_dept_popup
boolean visible = false
integer y = 2312
end type

type cb_return from w_inherite_popup`cb_return within w_dept_popup
boolean visible = false
integer y = 2312
end type

type cb_inq from w_inherite_popup`cb_inq within w_dept_popup
boolean visible = false
integer y = 2312
end type

type sle_1 from w_inherite_popup`sle_1 within w_dept_popup
boolean visible = false
integer y = 2300
end type

type st_1 from w_inherite_popup`st_1 within w_dept_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_dept_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 160
integer width = 1856
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 46
end type

type rb_3 from radiobutton within w_dept_popup
integer x = 1038
integer y = 60
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전채"
end type

event clicked;sFlag = '%'

dw_1.Retrieve(gs_company,sflag)
end event

type rb_2 from radiobutton within w_dept_popup
integer x = 581
integer y = 60
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "미사용"
end type

event clicked;sFlag = '0'

dw_1.Retrieve(gs_company,sflag)
end event

type rb_1 from radiobutton within w_dept_popup
integer x = 183
integer y = 60
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사용"
boolean checked = true
end type

event clicked;sFlag = '1'

dw_1.Retrieve(gs_company,sflag)
end event

type gb_1 from groupbox within w_dept_popup
integer x = 59
integer width = 1326
integer height = 152
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "사용구분"
end type

