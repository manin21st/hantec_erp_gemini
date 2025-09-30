$PBExportHeader$w_imt_03055_popup.srw
$PBExportComments$L/C 완료처리(BL/인수증 내역 조회)
forward
global type w_imt_03055_popup from window
end type
type p_exit from uo_picture within w_imt_03055_popup
end type
type st_blno from statictext within w_imt_03055_popup
end type
type st_1 from statictext within w_imt_03055_popup
end type
type dw_1 from datawindow within w_imt_03055_popup
end type
type rr_3 from roundrectangle within w_imt_03055_popup
end type
type rr_4 from roundrectangle within w_imt_03055_popup
end type
end forward

global type w_imt_03055_popup from window
integer x = 247
integer y = 160
integer width = 3543
integer height = 1928
boolean titlebar = true
string title = "B/L(인수증) 내역 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
st_blno st_blno
st_1 st_1
dw_1 dw_1
rr_3 rr_3
rr_4 rr_4
end type
global w_imt_03055_popup w_imt_03055_popup

type variables
string islcno



end variables

on w_imt_03055_popup.create
this.p_exit=create p_exit
this.st_blno=create st_blno
this.st_1=create st_1
this.dw_1=create dw_1
this.rr_3=create rr_3
this.rr_4=create rr_4
this.Control[]={this.p_exit,&
this.st_blno,&
this.st_1,&
this.dw_1,&
this.rr_3,&
this.rr_4}
end on

on w_imt_03055_popup.destroy
destroy(this.p_exit)
destroy(this.st_blno)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;string sLocal_yn

st_blno.text = gs_code 

f_window_center_response(this)

SELECT "LOCALYN"  
  INTO :sLocal_yn
  FROM "POLCHD"  
 WHERE ( "POLCHD"."SABU"   = :gs_sabu ) AND  
       ( "POLCHD"."POLCNO" = :gs_code )   ;

if sLocal_yn = 'Y' then 
	dw_1.DataObject = 'd_imt_03055_popup'
else
	dw_1.DataObject = 'd_imt_03055_popup1'
end if

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code) 



end event

type p_exit from uo_picture within w_imt_03055_popup
integer x = 3310
integer width = 178
integer taborder = 110
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type st_blno from statictext within w_imt_03055_popup
integer x = 562
integer y = 60
integer width = 942
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_03055_popup
integer x = 242
integer y = 60
integer width = 302
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "L/C NO :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_imt_03055_popup
integer x = 27
integer y = 180
integer width = 3451
integer height = 1616
integer taborder = 10
string dataobject = "d_imt_03055_popup"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_3 from roundrectangle within w_imt_03055_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 12
integer width = 1586
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_imt_03055_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 168
integer width = 3474
integer height = 1636
integer cornerheight = 40
integer cornerwidth = 55
end type

