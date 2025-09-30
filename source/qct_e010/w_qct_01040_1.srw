$PBExportHeader$w_qct_01040_1.srw
$PBExportComments$수입검사이력
forward
global type w_qct_01040_1 from window
end type
type p_exit from uo_picture within w_qct_01040_1
end type
type dw_1 from datawindow within w_qct_01040_1
end type
type dw_2 from datawindow within w_qct_01040_1
end type
type rr_1 from roundrectangle within w_qct_01040_1
end type
end forward

global type w_qct_01040_1 from window
integer x = 640
integer y = 436
integer width = 3296
integer height = 1456
boolean titlebar = true
string title = "수입검사이력"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
end type
global w_qct_01040_1 w_qct_01040_1

on w_qct_01040_1.create
this.p_exit=create p_exit
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_1,&
this.dw_2,&
this.rr_1}
end on

on w_qct_01040_1.destroy
destroy(this.p_exit)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

String 	sgunsu
Integer	iGunsu

select dataname
  into :sGunsu
  from syscnfg
 where sysgu = 'Y' and serial = '20' and lineno = '1';
 
If isnull(sgunsu) then
	iGunsu = 10
end if

if isnull(igunsu) or igunsu < 1 then
	iGunsu = 10
end if

if dw_1.retrieve(gs_sabu, gs_codename, gs_code, igunsu) = 0 then
	Messagebox("검사이력", "검사이력이 없읍니다", stopsign!)
	Close(this)
	return
end if
dw_2.retrieve(gs_sabu, gs_codename, gs_code, igunsu)
end event

event close;setnull(gs_code)
setnull(gs_codename)
end event

type p_exit from uo_picture within w_qct_01040_1
integer x = 3045
integer y = 12
integer width = 178
integer taborder = 30
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

type dw_1 from datawindow within w_qct_01040_1
integer x = 64
integer y = 280
integer width = 3145
integer height = 1028
string dataobject = "d_qct_01040_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_2 from datawindow within w_qct_01040_1
integer x = 18
integer y = 12
integer width = 2903
integer height = 256
string dataobject = "d_qct_01040_11"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_qct_01040_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 272
integer width = 3177
integer height = 1052
integer cornerheight = 40
integer cornerwidth = 55
end type

