$PBExportHeader$w_inherite_popup.srw
$PBExportComments$조회 선택 계승윈도우
forward
global type w_inherite_popup from window
end type
type dw_jogun from datawindow within w_inherite_popup
end type
type p_exit from uo_picture within w_inherite_popup
end type
type p_inq from uo_picture within w_inherite_popup
end type
type p_choose from uo_picture within w_inherite_popup
end type
type dw_1 from u_d_popup_sort within w_inherite_popup
end type
type sle_2 from singlelineedit within w_inherite_popup
end type
type cb_1 from commandbutton within w_inherite_popup
end type
type cb_return from commandbutton within w_inherite_popup
end type
type cb_inq from commandbutton within w_inherite_popup
end type
type sle_1 from singlelineedit within w_inherite_popup
end type
type st_1 from statictext within w_inherite_popup
end type
end forward

global type w_inherite_popup from window
integer x = 1577
integer y = 224
integer width = 2331
integer height = 2044
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 32106727
dw_jogun dw_jogun
p_exit p_exit
p_inq p_inq
p_choose p_choose
dw_1 dw_1
sle_2 sle_2
cb_1 cb_1
cb_return cb_return
cb_inq cb_inq
sle_1 sle_1
st_1 st_1
end type
global w_inherite_popup w_inherite_popup

event open;f_window_center(this)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()


end event

on w_inherite_popup.create
this.dw_jogun=create dw_jogun
this.p_exit=create p_exit
this.p_inq=create p_inq
this.p_choose=create p_choose
this.dw_1=create dw_1
this.sle_2=create sle_2
this.cb_1=create cb_1
this.cb_return=create cb_return
this.cb_inq=create cb_inq
this.sle_1=create sle_1
this.st_1=create st_1
this.Control[]={this.dw_jogun,&
this.p_exit,&
this.p_inq,&
this.p_choose,&
this.dw_1,&
this.sle_2,&
this.cb_1,&
this.cb_return,&
this.cb_inq,&
this.sle_1,&
this.st_1}
end on

on w_inherite_popup.destroy
destroy(this.dw_jogun)
destroy(this.p_exit)
destroy(this.p_inq)
destroy(this.p_choose)
destroy(this.dw_1)
destroy(this.sle_2)
destroy(this.cb_1)
destroy(this.cb_return)
destroy(this.cb_inq)
destroy(this.sle_1)
destroy(this.st_1)
end on

event key;call super::key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose

If keyDown(keyQ!) And keyDown(keyAlt!) Then
	p_inq.TriggerEvent(Clicked!)
End If

If keyDown(keyV!) And keyDown(keyAlt!) Then
	p_choose.TriggerEvent(Clicked!)
End If

If keyDown(keyC!) And keyDown(keyAlt!) Then
	p_exit.TriggerEvent(Clicked!)
End If
end event

type dw_jogun from datawindow within w_inherite_popup
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 18
integer y = 168
integer width = 2245
integer height = 156
integer taborder = 10
string title = "none"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;Parent.event key(key, keyflags)
end event

type p_exit from uo_picture within w_inherite_popup
event ue_key pbm_keydown
integer x = 2089
integer y = 20
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_key;Parent.event key(key, keyflags)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_inq from uo_picture within w_inherite_popup
event ue_key pbm_keydown
integer x = 1742
integer y = 20
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_key;Parent.event key(key, keyflags)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type p_choose from uo_picture within w_inherite_popup
event ue_key pbm_keydown
integer x = 1915
integer y = 20
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event ue_key;Parent.event key(key, keyflags)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type dw_1 from u_d_popup_sort within w_inherite_popup
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 18
integer y = 348
integer width = 2245
integer height = 1580
integer taborder = 0
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;call super::ue_pressenter;
cb_1.TriggerEvent(Clicked!)
end event

event ue_key;Parent.event key(key, keyflags)
end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type sle_2 from singlelineedit within w_inherite_popup
integer x = 462
integer y = 2248
integer width = 1051
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
textcase textcase = upper!
end type

event getfocus;
f_toggle_kor(Handle(this))
end event

type cb_1 from commandbutton within w_inherite_popup
integer x = 937
integer y = 1996
integer width = 329
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&V)"
end type

event clicked;p_choose.TriggerEvent(clicked!)
end event

type cb_return from commandbutton within w_inherite_popup
integer x = 1573
integer y = 1996
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;p_exit.TriggerEvent(clicked!)
end event

type cb_inq from commandbutton within w_inherite_popup
integer x = 1257
integer y = 1996
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
boolean default = true
end type

event clicked;p_inq.TriggerEvent(clicked!)
end event

type sle_1 from singlelineedit within w_inherite_popup
integer x = 279
integer y = 2248
integer width = 178
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
textcase textcase = upper!
integer limit = 5
end type

event getfocus;
f_toggle_eng(Handle(this))
end event

type st_1 from statictext within w_inherite_popup
integer y = 2260
integer width = 279
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

