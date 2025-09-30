$PBExportHeader$w_about.srw
$PBExportComments$물류관리시스템정보
forward
global type w_about from window
end type
type cb_1 from commandbutton within w_about
end type
type mle_1 from multilineedit within w_about
end type
type st_4 from statictext within w_about
end type
type st_1 from statictext within w_about
end type
end forward

global type w_about from window
integer x = 1134
integer y = 728
integer width = 1166
integer height = 776
boolean titlebar = true
string title = "한국비디에스(주)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
cb_1 cb_1
mle_1 mle_1
st_4 st_4
st_1 st_1
end type
global w_about w_about

type variables

end variables

on w_about.create
this.cb_1=create cb_1
this.mle_1=create mle_1
this.st_4=create st_4
this.st_1=create st_1
this.Control[]={this.cb_1,&
this.mle_1,&
this.st_4,&
this.st_1}
end on

on w_about.destroy
destroy(this.cb_1)
destroy(this.mle_1)
destroy(this.st_4)
destroy(this.st_1)
end on

event open;
f_window_center(this)

If Gs_digital = 'D' then
	st_1.text = 'ERP-MAN [Digital]'
Else
	st_1.text = 'ERP-MAN [Enterprise]'
End if


end event

type cb_1 from commandbutton within w_about
integer x = 434
integer y = 572
integer width = 325
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인"
boolean default = true
end type

event clicked;
close(parent)


end event

type mle_1 from multilineedit within w_about
integer x = 101
integer y = 224
integer width = 992
integer height = 344
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
string text = "[Head Office]                   #4th Fi., Kyobojeungkwon Bldg.  44-31 Yoido-Dong               Youngdeungpo-Gu, Seoul, Korea   TEL:82-2-2126-8164             FAX:82-2-782-8140"
boolean border = false
boolean displayonly = true
end type

type st_4 from statictext within w_about
integer x = 101
integer y = 116
integer width = 992
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean enabled = false
string text = "Copyright 1998 - 2002 BDS Corp."
boolean focusrectangle = false
end type

type st_1 from statictext within w_about
integer x = 101
integer y = 48
integer width = 992
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
boolean enabled = false
string text = "ERPMAN"
boolean focusrectangle = false
end type

