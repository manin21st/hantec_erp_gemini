$PBExportHeader$w_getblob.srw
forward
global type w_getblob from window
end type
type uo_3d_meter from u_progress_bar_blob within w_getblob
end type
type st_5 from statictext within w_getblob
end type
type st_3 from statictext within w_getblob
end type
type st_1 from statictext within w_getblob
end type
type sle_6 from singlelineedit within w_getblob
end type
end forward

global type w_getblob from window
integer x = 1024
integer y = 904
integer width = 1632
integer height = 572
boolean titlebar = true
string title = "내려받기"
windowtype windowtype = popup!
long backcolor = 80269524
string pointer = "HourGlass!"
event ue_getblob pbm_custom01
event ue_postopen ( )
uo_3d_meter uo_3d_meter
st_5 st_5
st_3 st_3
st_1 st_1
sle_6 sle_6
end type
global w_getblob w_getblob

type variables
int ii_cnt
end variables

event ue_postopen;this.SetPosition(TopMost!)
end event

on w_getblob.create
this.uo_3d_meter=create uo_3d_meter
this.st_5=create st_5
this.st_3=create st_3
this.st_1=create st_1
this.sle_6=create sle_6
this.Control[]={this.uo_3d_meter,&
this.st_5,&
this.st_3,&
this.st_1,&
this.sle_6}
end on

on w_getblob.destroy
destroy(this.uo_3d_meter)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.sle_6)
end on

event open;setpointer(HourGlass!)

this.PostEvent('ue_postopen')
//this.SetPosition(TopMost!)
end event

type uo_3d_meter from u_progress_bar_blob within w_getblob
event destroy ( )
integer x = 41
integer y = 276
integer width = 1573
integer taborder = 10
end type

on uo_3d_meter.destroy
call u_progress_bar_blob::destroy
end on

type st_5 from statictext within w_getblob
integer x = 50
integer y = 28
integer width = 1550
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 128
long backcolor = 80269524
boolean enabled = false
boolean focusrectangle = false
end type

type st_3 from statictext within w_getblob
integer x = 46
integer y = 392
integer width = 677
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 80269524
boolean enabled = false
string text = "잠시 기다려 주십시요....."
boolean focusrectangle = false
end type

type st_1 from statictext within w_getblob
integer x = 50
integer y = 108
integer width = 1550
integer height = 148
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 128
long backcolor = 80269524
boolean enabled = false
boolean focusrectangle = false
end type

type sle_6 from singlelineedit within w_getblob
integer x = 357
integer y = 1292
integer width = 603
integer height = 68
integer taborder = 20
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
end type

