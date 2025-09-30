$PBExportHeader$w_pdm_01285.srw
$PBExportComments$기술 내역
forward
global type w_pdm_01285 from window
end type
type p_exit from uo_picture within w_pdm_01285
end type
type p_save from uo_picture within w_pdm_01285
end type
type dw_list from datawindow within w_pdm_01285
end type
type dw_ip from datawindow within w_pdm_01285
end type
type str_offer_rex from structure within w_pdm_01285
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

global type w_pdm_01285 from window
integer x = 430
integer y = 600
integer width = 1289
integer height = 1044
boolean titlebar = true
string title = "기술 내역 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_save p_save
dw_list dw_list
dw_ip dw_ip
end type
global w_pdm_01285 w_pdm_01285

type variables
string ls_itnbr
end variables

on w_pdm_01285.create
this.p_exit=create p_exit
this.p_save=create p_save
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.Control[]={this.p_exit,&
this.p_save,&
this.dw_list,&
this.dw_ip}
end on

on w_pdm_01285.destroy
destroy(this.p_exit)
destroy(this.p_save)
destroy(this.dw_list)
destroy(this.dw_ip)
end on

event open;f_window_center(this)

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

ls_itnbr = Message.StringParm	

IF gs_gubun = 'N' then 
	p_save.enabled = false
	p_save.PictureName = "C:\erpman\image\저장_d.gif"
else
	p_save.enabled = true
	p_save.PictureName = "C:\erpman\image\저장_up.gif"
END IF

IF dw_ip.Retrieve(ls_itnbr)  < 1 then 
	messagebox('확인', '품번을 확인하세요!')
	p_exit.TriggerEvent(Clicked!)
	return 
END IF

IF dw_list.Retrieve(ls_itnbr) < 1 THEN 
   dw_list.insertrow(0) 
   dw_list.setitem(1, 'itnbr', ls_itnbr)
	dw_list.setfocus()
END IF



end event

type p_exit from uo_picture within w_pdm_01285
integer x = 1079
integer y = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

type p_save from uo_picture within w_pdm_01285
integer x = 914
integer y = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;if dw_list.update() = 1 then
   COMMIT;
else
	ROLLBACK;
   f_rollback()
end if



end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

type dw_list from datawindow within w_pdm_01285
integer x = 9
integer y = 460
integer width = 1243
integer height = 492
integer taborder = 30
string dataobject = "d_pdm_01285"
boolean border = false
end type

type dw_ip from datawindow within w_pdm_01285
integer x = 18
integer y = 172
integer width = 1243
integer height = 304
string dataobject = "d_pdm_01286"
boolean border = false
boolean livescroll = true
end type

