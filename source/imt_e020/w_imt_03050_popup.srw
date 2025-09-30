$PBExportHeader$w_imt_03050_popup.srw
$PBExportComments$B/L¸¶°¨(¼öÀÔºñ¿ë Á¶È¸)
forward
global type w_imt_03050_popup from window
end type
type rr_3 from roundrectangle within w_imt_03050_popup
end type
type p_exit from uo_picture within w_imt_03050_popup
end type
type dw_2 from datawindow within w_imt_03050_popup
end type
type st_blno from statictext within w_imt_03050_popup
end type
type st_1 from statictext within w_imt_03050_popup
end type
type dw_1 from datawindow within w_imt_03050_popup
end type
type rr_4 from roundrectangle within w_imt_03050_popup
end type
type rr_44 from roundrectangle within w_imt_03050_popup
end type
end forward

global type w_imt_03050_popup from window
integer x = 247
integer y = 48
integer width = 3529
integer height = 1992
boolean titlebar = true
string title = "B/L ¼öÀÔºñ¿ë Á¶È¸"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
rr_3 rr_3
p_exit p_exit
dw_2 dw_2
st_blno st_blno
st_1 st_1
dw_1 dw_1
rr_4 rr_4
rr_44 rr_44
end type
global w_imt_03050_popup w_imt_03050_popup

type variables
string islcno
string is_pspec, is_jijil

end variables

on w_imt_03050_popup.create
this.rr_3=create rr_3
this.p_exit=create p_exit
this.dw_2=create dw_2
this.st_blno=create st_blno
this.st_1=create st_1
this.dw_1=create dw_1
this.rr_4=create rr_4
this.rr_44=create rr_44
this.Control[]={this.rr_3,&
this.p_exit,&
this.dw_2,&
this.st_blno,&
this.st_1,&
this.dw_1,&
this.rr_4,&
this.rr_44}
end on

on w_imt_03050_popup.destroy
destroy(this.rr_3)
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.st_blno)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.rr_4)
destroy(this.rr_44)
end on

event open;st_blno.text = gs_code 

F_WINDOW_CENTER_response(this)

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code) 
dw_2.settransobject(sqlca)
dw_2.retrieve(gs_sabu, gs_code) 


end event

type rr_3 from roundrectangle within w_imt_03050_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 12
integer width = 1586
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_exit from uo_picture within w_imt_03050_popup
integer x = 3310
integer width = 178
integer taborder = 110
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\´Ý±â_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\´Ý±â_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\´Ý±â_up.gif"
end event

type dw_2 from datawindow within w_imt_03050_popup
integer x = 32
integer y = 1212
integer width = 3438
integer height = 644
string dataobject = "d_imt_03050_popup2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_blno from statictext within w_imt_03050_popup
integer x = 549
integer y = 56
integer width = 841
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_03050_popup
integer x = 283
integer y = 56
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long backcolor = 33027312
boolean enabled = false
string text = "B/L NO :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_imt_03050_popup
integer x = 32
integer y = 172
integer width = 3438
integer height = 988
string dataobject = "d_imt_03050_popup"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_4 from roundrectangle within w_imt_03050_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 160
integer width = 3474
integer height = 1008
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_44 from roundrectangle within w_imt_03050_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 1192
integer width = 3474
integer height = 676
integer cornerheight = 40
integer cornerwidth = 55
end type

