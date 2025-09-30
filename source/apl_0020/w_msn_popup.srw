$PBExportHeader$w_msn_popup.srw
$PBExportComments$로그인 화면 -권
forward
global type w_msn_popup from w_inherite_popup
end type
type mle_1 from multilineedit within w_msn_popup
end type
type rr_1 from roundrectangle within w_msn_popup
end type
end forward

global type w_msn_popup from w_inherite_popup
integer width = 1577
integer height = 1400
mle_1 mle_1
rr_1 rr_1
end type
global w_msn_popup w_msn_popup

on w_msn_popup.create
int iCurrent
call super::create
this.mle_1=create mle_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_msn_popup.destroy
call super::destroy
destroy(this.mle_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(Sqlca)

dw_1.Retrieve(gs_code)

mle_1.Text = dw_1.GetItemString(1, 'tab_msn_list')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_msn_popup
boolean visible = false
integer x = 46
integer y = 28
integer width = 73
integer height = 52
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_msn_popup
integer x = 1371
integer y = 28
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event p_exit::ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_msn_popup
boolean visible = false
integer x = 1024
integer y = 28
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_msn_popup
boolean visible = false
integer x = 1198
integer y = 28
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_msn_popup
integer y = 192
integer width = 1527
integer height = 188
string dataobject = "d_msn_popup"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;return 
end event

event dw_1::rowfocuschanged;Return 
end event

type sle_2 from w_inherite_popup`sle_2 within w_msn_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_msn_popup
end type

type cb_return from w_inherite_popup`cb_return within w_msn_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_msn_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_msn_popup
end type

type st_1 from w_inherite_popup`st_1 within w_msn_popup
end type

type mle_1 from multilineedit within w_msn_popup
integer x = 32
integer y = 396
integer width = 1490
integer height = 888
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rr_1 from roundrectangle within w_msn_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 388
integer width = 1509
integer height = 904
integer cornerheight = 40
integer cornerwidth = 55
end type

