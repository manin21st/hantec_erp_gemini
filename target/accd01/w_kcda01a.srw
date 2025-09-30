$PBExportHeader$w_kcda01a.srw
$PBExportComments$계정과목 일괄 복사
forward
global type w_kcda01a from window
end type
type p_exit from uo_picture within w_kcda01a
end type
type p_mod from uo_picture within w_kcda01a
end type
type p_inq from uo_picture within w_kcda01a
end type
type sle_gaejname from singlelineedit within w_kcda01a
end type
type sle_gaej2 from singlelineedit within w_kcda01a
end type
type st_2 from statictext within w_kcda01a
end type
type st_1 from statictext within w_kcda01a
end type
type sle_gaej1 from singlelineedit within w_kcda01a
end type
type dw_1 from datawindow within w_kcda01a
end type
end forward

global type w_kcda01a from window
integer x = 59
integer y = 48
integer width = 4498
integer height = 2400
boolean titlebar = true
string title = "계정과목조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
p_exit p_exit
p_mod p_mod
p_inq p_inq
sle_gaejname sle_gaejname
sle_gaej2 sle_gaej2
st_2 st_2
st_1 st_1
sle_gaej1 sle_gaej1
dw_1 dw_1
end type
global w_kcda01a w_kcda01a

on w_kcda01a.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_inq=create p_inq
this.sle_gaejname=create sle_gaejname
this.sle_gaej2=create sle_gaej2
this.st_2=create st_2
this.st_1=create st_1
this.sle_gaej1=create sle_gaej1
this.dw_1=create dw_1
this.Control[]={this.p_exit, &
this.p_mod, &
this.p_inq, &
this.sle_gaejname, &
this.sle_gaej2, &
this.st_2, &
this.st_1, &
this.sle_gaej1, &
this.dw_1}
end on

on w_kcda01a.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.sle_gaejname)
destroy(this.sle_gaej2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_gaej1)
destroy(this.dw_1)
end on

event open;
F_Window_Center_Response(this)
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
sle_gaej1.SetFocus()
end event

event resize;
dw_1.width = this.width - 110
dw_1.height = this.height - dw_1.y - 100

p_inq.x = this.width - p_inq.width - p_mod.width - p_exit.width - 80
p_mod.x = this.width - p_mod.width - p_exit.width - 60
p_exit.x = this.width - p_exit.width - 40
end event

type p_exit from uo_picture within w_kcda01a
integer x = 4250
integer y = 32
integer width = 178
integer taborder = 70
string picturename = "btn_close_up.gif"
end type

event clicked;
Close(Parent)
end event

type p_mod from uo_picture within w_kcda01a
integer x = 4060
integer y = 32
integer width = 178
integer taborder = 60
string picturename = "btn_save_up.gif"
end type

event clicked;
IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","자료 저장 실패 !!")
	ROLLBACK;
	RETURN
END IF
commit;
P_inq.TriggerEvent(Clicked!)
end event

type p_inq from uo_picture within w_kcda01a
integer x = 3870
integer y = 32
integer width = 178
integer taborder = 40
string picturename = "btn_query_up.gif"
end type

event clicked;
String ls_gaejung1,ls_name

ls_gaejung1 = sle_gaej1.text + "%"
ls_name     = "%" + Trim(sle_gaejname.text) + "%"

dw_1.Reset()
IF dw_1.Retrieve(ls_gaejung1,ls_name) <= 0 THEN
	MessageBox("확 인","조회된 자료가 없습니다.!!!")
	Return
ELSE
	dw_1.SetTabOrder("acc1_cd",0)
	dw_1.SetTabOrder("acc2_cd",0)
END IF
end event

type sle_gaejname from singlelineedit within w_kcda01a
integer x = 750
integer y = 44
integer width = 1051
integer height = 68
integer taborder = 30
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_gaej2 from singlelineedit within w_kcda01a
integer x = 635
integer y = 44
integer width = 91
integer height = 68
integer taborder = 20
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_kcda01a
integer x = 585
integer y = 48
integer width = 46
integer height = 72
integer textsize = -12
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_kcda01a
integer x = 64
integer y = 52
integer width = 329
integer height = 60
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
string text = "계정코드"
boolean focusrectangle = false
end type

type sle_gaej1 from singlelineedit within w_kcda01a
integer x = 402
integer y = 44
integer width = 178
integer height = 68
integer taborder = 10
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 5
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kcda01a
integer x = 46
integer y = 140
integer width = 4343
integer height = 2048
integer taborder = 50
string dataobject = "dw_kcda01a_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemfocuschanged;
Long wnd
wnd = Handle(this)

IF dwo.name ="acc1_nm" OR dwo.name = "acc2_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event
