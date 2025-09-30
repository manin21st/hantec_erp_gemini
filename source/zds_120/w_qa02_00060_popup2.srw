$PBExportHeader$w_qa02_00060_popup2.srw
$PBExportComments$** 매입 클레임 처리
forward
global type w_qa02_00060_popup2 from window
end type
type p_exit from uo_picture within w_qa02_00060_popup2
end type
type p_save from uo_picture within w_qa02_00060_popup2
end type
type dw_ip from datawindow within w_qa02_00060_popup2
end type
type str_offer_rex from structure within w_qa02_00060_popup2
end type
end forward

type str_offer_rex from structure
	string		offno
	string		rcdat
	double		offamt
	double		foramt
	double		wonamt
	boolean		flag
end type

global type w_qa02_00060_popup2 from window
integer x = 430
integer y = 600
integer width = 1650
integer height = 1208
boolean titlebar = true
string title = "매입 클레임 확정 금액"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_save p_save
dw_ip dw_ip
end type
global w_qa02_00060_popup2 w_qa02_00060_popup2

type variables
string ls_itnbr
end variables

on w_qa02_00060_popup2.create
this.p_exit=create p_exit
this.p_save=create p_save
this.dw_ip=create dw_ip
this.Control[]={this.p_exit,&
this.p_save,&
this.dw_ip}
end on

on w_qa02_00060_popup2.destroy
destroy(this.p_exit)
destroy(this.p_save)
destroy(this.dw_ip)
end on

event open;f_window_center(this)

dw_ip.settransobject(sqlca)

if dw_ip.retrieve(gs_saupj,gs_code) < 1 then return
dw_ip.setitem(1,'cnfamt',dec(gs_codename))

setnull(gs_code)
setnull(gs_codename)
end event

type p_exit from uo_picture within w_qa02_00060_popup2
integer x = 1408
integer y = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;gs_codename = '0'
close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

type p_save from uo_picture within w_qa02_00060_popup2
integer x = 1243
integer y = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event clicked;call super::clicked;dw_ip.accepttext()

gs_code = 'OK'
gs_codename = string(dw_ip.getitemnumber(1,'cnfamt'))
close(parent)
end event

type dw_ip from datawindow within w_qa02_00060_popup2
integer x = 18
integer y = 172
integer width = 1591
integer height = 904
string dataobject = "d_qa02_00060_popup2"
boolean border = false
boolean livescroll = true
end type

