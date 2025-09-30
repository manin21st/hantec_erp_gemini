$PBExportHeader$w_sal_02020_1.srw
$PBExportComments$수주관리 :수주 진행 상세 조회
forward
global type w_sal_02020_1 from window
end type
type p_1 from uo_picture within w_sal_02020_1
end type
type dw_rtv from datawindow within w_sal_02020_1
end type
end forward

global type w_sal_02020_1 from window
integer x = 197
integer y = 364
integer width = 3351
integer height = 1712
boolean titlebar = true
string title = "수주 진행 상세 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
dw_rtv dw_rtv
end type
global w_sal_02020_1 w_sal_02020_1

on w_sal_02020_1.create
this.p_1=create p_1
this.dw_rtv=create dw_rtv
this.Control[]={this.p_1,&
this.dw_rtv}
end on

on w_sal_02020_1.destroy
destroy(this.p_1)
destroy(this.dw_rtv)
end on

event open;String  sMsgParm

dw_rtv.SetTransObject(SQLCA)
dw_rtv.Reset()

sMsgParm = Message.StringParm

IF dw_rtv.Retrieve(gs_sabu,sMsgParm) <=0 THEN
	f_message_chk(50,'[수주진행 상세]')
	CLOSE(w_sal_02020_1)
	Return
END IF

f_window_center_response(this)
end event

type p_1 from uo_picture within w_sal_02020_1
integer x = 3127
integer y = 12
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type dw_rtv from datawindow within w_sal_02020_1
integer x = 5
integer y = 156
integer width = 3319
integer height = 1444
string dataobject = "d_sal_02020_1"
boolean border = false
boolean livescroll = true
end type

