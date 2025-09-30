$PBExportHeader$w_sal_02000_5.srw
$PBExportComments$수주 등록(거래처 상세 조회)
forward
global type w_sal_02000_5 from window
end type
type p_1 from uo_picture within w_sal_02000_5
end type
type cb_1 from commandbutton within w_sal_02000_5
end type
type dw_rtv from datawindow within w_sal_02000_5
end type
type rr_1 from roundrectangle within w_sal_02000_5
end type
end forward

global type w_sal_02000_5 from window
integer x = 270
integer y = 764
integer width = 2569
integer height = 1264
boolean titlebar = true
string title = "일반정보 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
cb_1 cb_1
dw_rtv dw_rtv
rr_1 rr_1
end type
global w_sal_02000_5 w_sal_02000_5

type variables
Datawindow	idw_dataobject
end variables

on w_sal_02000_5.create
this.p_1=create p_1
this.cb_1=create cb_1
this.dw_rtv=create dw_rtv
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.cb_1,&
this.dw_rtv,&
this.rr_1}
end on

on w_sal_02000_5.destroy
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.dw_rtv)
destroy(this.rr_1)
end on

event open;idw_dataobject = Message.PowerObjectParm
dw_rtv.dataobject = idw_dataobject.dataobject
idw_dataobject.sharedata(dw_rtv)

f_window_center_response(this)

end event

type p_1 from uo_picture within w_sal_02000_5
integer x = 2286
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type cb_1 from commandbutton within w_sal_02000_5
boolean visible = false
integer x = 2245
integer y = 60
integer width = 361
integer height = 108
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&C)"
boolean cancel = true
end type

event clicked;close(w_sal_02000_1)
end event

type dw_rtv from datawindow within w_sal_02000_5
integer x = 46
integer y = 200
integer width = 2423
integer height = 956
string dataobject = "d_sal_02000_52"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sal_02000_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 188
integer width = 2473
integer height = 984
integer cornerheight = 40
integer cornerwidth = 55
end type

