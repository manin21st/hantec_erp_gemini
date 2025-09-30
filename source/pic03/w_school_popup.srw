$PBExportHeader$w_school_popup.srw
$PBExportComments$** 학교 조회 선택
forward
global type w_school_popup from window
end type
type sle_find from singlelineedit within w_school_popup
end type
type st_1 from statictext within w_school_popup
end type
type cb_1 from commandbutton within w_school_popup
end type
type cb_return from commandbutton within w_school_popup
end type
type dw_1 from u_d_popup_sort within w_school_popup
end type
end forward

global type w_school_popup from window
integer x = 1925
integer y = 84
integer width = 1650
integer height = 1684
boolean titlebar = true
string title = "학교 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
sle_find sle_find
st_1 st_1
cb_1 cb_1
cb_return cb_return
dw_1 dw_1
end type
global w_school_popup w_school_popup

event open;f_Window_Center_Response(This)
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Retrieve("%")

sle_find.SetFocus()

end event

on w_school_popup.create
this.sle_find=create sle_find
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_return=create cb_return
this.dw_1=create dw_1
this.Control[]={this.sle_find,&
this.st_1,&
this.cb_1,&
this.cb_return,&
this.dw_1}
end on

on w_school_popup.destroy
destroy(this.sle_find)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_return)
destroy(this.dw_1)
end on

event key;choose case key
	case keyenter!
		sle_find.TriggerEvent(Modified!)
end choose

end event

type sle_find from singlelineedit within w_school_popup
integer x = 265
integer y = 32
integer width = 1344
integer height = 84
integer taborder = 10
integer textsize = -9
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

event getfocus;
f_toggle_kor(Handle(this))
end event

type st_1 from statictext within w_school_popup
integer x = 37
integer y = 48
integer width = 229
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
string text = "학교명"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_school_popup
integer x = 978
integer y = 1460
integer width = 293
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "schoolcode")
gs_codename = dw_1.GetItemString(ll_Row, "schoolname")

Close(Parent)


end event

type cb_return from commandbutton within w_school_popup
integer x = 1307
integer y = 1460
integer width = 293
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type dw_1 from u_d_popup_sort within w_school_popup
integer x = 37
integer y = 140
integer width = 1563
integer height = 1300
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_school_popup"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "schoolcode")
gs_codename = dw_1.GetItemString(Row, "schoolname")

Close(Parent)

end event

