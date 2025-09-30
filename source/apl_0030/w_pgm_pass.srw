$PBExportHeader$w_pgm_pass.srw
$PBExportComments$프로그램 접근 암호
forward
global type w_pgm_pass from window
end type
type cb_2 from commandbutton within w_pgm_pass
end type
type cb_1 from commandbutton within w_pgm_pass
end type
type sle_pass from singlelineedit within w_pgm_pass
end type
type st_1 from statictext within w_pgm_pass
end type
type gb_2 from groupbox within w_pgm_pass
end type
type gb_1 from groupbox within w_pgm_pass
end type
end forward

global type w_pgm_pass from window
integer x = 1170
integer y = 728
integer width = 960
integer height = 488
boolean titlebar = true
string title = "작업접근 암호 확인"
windowtype windowtype = response!
long backcolor = 79741120
cb_2 cb_2
cb_1 cb_1
sle_pass sle_pass
st_1 st_1
gb_2 gb_2
gb_1 gb_1
end type
global w_pgm_pass w_pgm_pass

event open;Integer		li_ScreenH, li_ScreenW
Environment	le_Env

// 윈도우의 센터맞추기
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

this.Y = (li_ScreenH - this.Height) / 2
this.X = (li_ScreenW - this.Width) / 2

//f_window_center(this)
end event

on w_pgm_pass.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_pass=create sle_pass
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.sle_pass,&
this.st_1,&
this.gb_2,&
this.gb_1}
end on

on w_pgm_pass.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_pass)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type cb_2 from commandbutton within w_pgm_pass
integer x = 466
integer y = 244
integer width = 379
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소"
end type

event clicked;
CloseWithReturn(w_pgm_pass,"CANCEL")
end event

type cb_1 from commandbutton within w_pgm_pass
integer x = 87
integer y = 244
integer width = 379
integer height = 96
integer taborder = 20
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
String sPgm_Pass ,sIns_pass

sPgm_Pass = Message.StringParm

sIns_pass = Trim(sle_pass.text)

IF sIns_pass ="" OR IsNull(sIns_pass) THEN
	MessageBox("확 인","암호를 입력하세요!!",StopSign!)
	sle_pass.SetFocus()
	Return
END IF

IF sPgm_pass <> sIns_pass THEN
	Messagebox("확 인","암호가 틀렸습니다. 접근 암호를 확인 후 다시 입력하십시요!!")
	sle_pass.text =""
	sle_pass.SetFocus()
	Return
END IF

CloseWithReturn(w_pgm_pass,"OK")

end event

type sle_pass from singlelineedit within w_pgm_pass
integer x = 256
integer y = 68
integer width = 590
integer height = 80
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pgm_pass
integer x = 55
integer y = 80
integer width = 215
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean enabled = false
string text = "암 호"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_pgm_pass
integer x = 32
integer y = 192
integer width = 878
integer height = 188
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_pgm_pass
integer x = 32
integer y = 4
integer width = 878
integer height = 188
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
end type

