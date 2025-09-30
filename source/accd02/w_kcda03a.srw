$PBExportHeader$w_kcda03a.srw
$PBExportComments$구분코드 현황 조회
forward
global type w_kcda03a from window
end type
type cb_1 from commandbutton within w_kcda03a
end type
type dw_1 from datawindow within w_kcda03a
end type
type cb_delete from commandbutton within w_kcda03a
end type
type gb_1 from groupbox within w_kcda03a
end type
end forward

global type w_kcda03a from window
integer x = 430
integer y = 188
integer width = 2807
integer height = 2004
boolean titlebar = true
string title = "구분 코드 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
cb_1 cb_1
dw_1 dw_1
cb_delete cb_delete
gb_1 gb_1
end type
global w_kcda03a w_kcda03a

type variables


end variables

event open;dw_1.settransobject(sqlca)

dw_1.retrieve()







end event

on w_kcda03a.create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.cb_delete=create cb_delete
this.gb_1=create gb_1
this.Control[]={this.cb_1,&
this.dw_1,&
this.cb_delete,&
this.gb_1}
end on

on w_kcda03a.destroy
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.cb_delete)
destroy(this.gb_1)
end on

type cb_1 from commandbutton within w_kcda03a
integer x = 1961
integer y = 1764
integer width = 352
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

on clicked;IF Messagebox("확인", "출력하시겠습니까?", question!, yesno!) = 2 THEN RETURN
	
dw_1.print()
end on

type dw_1 from datawindow within w_kcda03a
integer x = 23
integer y = 16
integer width = 2738
integer height = 1688
string dataobject = "dw_kcda03a_1"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

on clicked;long 		l_row
string	s_code

l_row = this.GetClickedRow()

IF l_row <= 0 	THEN
	RETURN
END IF

s_code = this.GetItemString(l_row, 1)

//OpenWithParm (wx_a_mpq_020, s_code)




end on

type cb_delete from commandbutton within w_kcda03a
integer x = 2341
integer y = 1764
integer width = 352
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

on clicked;CLOSE(PARENT)
end on

type gb_1 from groupbox within w_kcda03a
integer x = 1883
integer y = 1696
integer width = 878
integer height = 192
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65535
long backcolor = 12632256
borderstyle borderstyle = styleraised!
end type

