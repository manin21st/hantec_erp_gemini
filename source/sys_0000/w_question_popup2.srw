$PBExportHeader$w_question_popup2.srw
$PBExportComments$����2
forward
global type w_question_popup2 from window
end type
type cb_4 from commandbutton within w_question_popup2
end type
type cb_3 from commandbutton within w_question_popup2
end type
type cb_2 from commandbutton within w_question_popup2
end type
type st_1 from statictext within w_question_popup2
end type
end forward

global type w_question_popup2 from window
integer x = 1134
integer y = 840
integer width = 1221
integer height = 372
boolean titlebar = true
string title = "�����Ͻʽÿ�"
windowtype windowtype = response!
long backcolor = 79741120
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
st_1 st_1
end type
global w_question_popup2 w_question_popup2

type variables

end variables

on w_question_popup2.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.st_1=create st_1
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_2,&
this.st_1}
end on

on w_question_popup2.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.st_1)
end on

event open;f_window_center(this)
end event

type cb_4 from commandbutton within w_question_popup2
integer x = 795
integer y = 172
integer width = 357
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;CloseWithReturn(parent, 4)
end event

type cb_3 from commandbutton within w_question_popup2
integer x = 425
integer y = 172
integer width = 357
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "PROGRAM(&P)"
end type

event clicked;CloseWithReturn(parent, 3)
end event

type cb_2 from commandbutton within w_question_popup2
integer x = 55
integer y = 172
integer width = 357
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ߺз�(&M)"
end type

event clicked;CloseWithReturn(parent, 2)
end event

type st_1 from statictext within w_question_popup2
integer x = 55
integer y = 60
integer width = 1166
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "������Ű���� �ϴ� �ڷḦ �����ϼ���!"
boolean focusrectangle = false
end type

