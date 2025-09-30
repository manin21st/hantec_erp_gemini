$PBExportHeader$w_circle_popup.srw
$PBExportComments$** 동호회 조회
forward
global type w_circle_popup from w_inherite_popup
end type
type sle_find from singlelineedit within w_circle_popup
end type
type st_2 from statictext within w_circle_popup
end type
type rr_1 from roundrectangle within w_circle_popup
end type
end forward

global type w_circle_popup from w_inherite_popup
integer x = 1925
integer y = 84
integer width = 1664
integer height = 1680
string title = "동호회 조회 선택"
boolean controlmenu = true
sle_find sle_find
st_2 st_2
rr_1 rr_1
end type
global w_circle_popup w_circle_popup

on w_circle_popup.create
int iCurrent
call super::create
this.sle_find=create sle_find
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_find
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_circle_popup.destroy
call super::destroy
destroy(this.sle_find)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;sle_find.SetFocus()

dw_1.Retrieve("%")

end event

event key;call super::key;choose case key
	case keyenter!
		sle_find.TriggerEvent(Modified!)
end choose

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_circle_popup
boolean visible = false
integer x = 0
integer y = 1920
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_circle_popup
integer x = 1440
integer y = 8
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_circle_popup
boolean visible = false
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_circle_popup
integer x = 1266
integer y = 8
integer taborder = 20
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "circlecode")
gs_codename = dw_1.GetItemString(ll_Row, "circlename")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_circle_popup
integer x = 27
integer y = 180
integer width = 1577
integer height = 1380
string dataobject = "d_circle_popup"
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

gs_code = dw_1.GetItemString(Row, "circlecode")
gs_codename = dw_1.GetItemString(Row, "circlename")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_circle_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_circle_popup
boolean visible = false
end type

type cb_return from w_inherite_popup`cb_return within w_circle_popup
boolean visible = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_circle_popup
boolean visible = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_circle_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_circle_popup
boolean visible = false
end type

type sle_find from singlelineedit within w_circle_popup
integer x = 320
integer y = 52
integer width = 846
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event getfocus;
f_toggle_kor(Handle(this))
end event

event modified;string sname

sname = Trim(sle_find.Text)

IF IsNull(sname) THEN
	sname =""
END IF

IF dw_1.Retrieve('%' + sname + '%') <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	sle_find.SetFocus()
	Return
END IF
end event

type st_2 from statictext within w_circle_popup
integer x = 37
integer y = 68
integer width = 297
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "동호회명"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_circle_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 164
integer width = 1595
integer height = 1416
integer cornerheight = 40
integer cornerwidth = 46
end type

