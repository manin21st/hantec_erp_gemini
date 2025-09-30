$PBExportHeader$w_sal_02000_1.srw
$PBExportComments$수주 등록(거래처 상세 조회)
forward
global type w_sal_02000_1 from window
end type
type p_1 from uo_picture within w_sal_02000_1
end type
type cb_1 from commandbutton within w_sal_02000_1
end type
type dw_rtv from datawindow within w_sal_02000_1
end type
type rr_1 from roundrectangle within w_sal_02000_1
end type
end forward

global type w_sal_02000_1 from window
integer x = 270
integer y = 764
integer width = 3045
integer height = 792
boolean titlebar = true
string title = "거래처 상세 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
cb_1 cb_1
dw_rtv dw_rtv
rr_1 rr_1
end type
global w_sal_02000_1 w_sal_02000_1

on w_sal_02000_1.create
this.p_1=create p_1
this.cb_1=create cb_1
this.dw_rtv=create dw_rtv
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.cb_1,&
this.dw_rtv,&
this.rr_1}
end on

on w_sal_02000_1.destroy
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.dw_rtv)
destroy(this.rr_1)
end on

event open;String  sMsgParm,sCust

dw_rtv.SetTransObject(SQLCA)
dw_rtv.Reset()

sCust = Message.StringParm

IF dw_rtv.Retrieve(sCust) <=0 THEN
	f_message_chk(50,'[거래처 상세 정보]')
	CLOSE(w_sal_02000_1)
	Return
END IF

f_window_center_response(this)


end event

type p_1 from uo_picture within w_sal_02000_1
integer x = 2798
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type cb_1 from commandbutton within w_sal_02000_1
boolean visible = false
integer x = 2505
integer y = 1396
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

type dw_rtv from datawindow within w_sal_02000_1
integer x = 46
integer y = 212
integer width = 2926
integer height = 460
string dataobject = "d_sal_02000_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sal_02000_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 188
integer width = 2971
integer height = 496
integer cornerheight = 40
integer cornerwidth = 55
end type

