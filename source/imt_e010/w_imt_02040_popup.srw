$PBExportHeader$w_imt_02040_popup.srw
$PBExportComments$** 발주수정(L/C, B/L, 입고조회)
forward
global type w_imt_02040_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_imt_02040_popup
end type
type dw_3 from datawindow within w_imt_02040_popup
end type
type dw_4 from datawindow within w_imt_02040_popup
end type
type st_2 from statictext within w_imt_02040_popup
end type
type st_3 from statictext within w_imt_02040_popup
end type
type st_4 from statictext within w_imt_02040_popup
end type
type dw_5 from datawindow within w_imt_02040_popup
end type
type rr_1 from roundrectangle within w_imt_02040_popup
end type
end forward

global type w_imt_02040_popup from w_inherite_popup
integer x = 567
integer y = 200
integer width = 3182
integer height = 2104
string title = "품목별 발주 진행 정보"
boolean controlmenu = true
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
st_2 st_2
st_3 st_3
st_4 st_4
dw_5 dw_5
rr_1 rr_1
end type
global w_imt_02040_popup w_imt_02040_popup

type variables

end variables

on w_imt_02040_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.dw_5=create dw_5
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.dw_5
this.Control[iCurrent+8]=this.rr_1
end on

on w_imt_02040_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.dw_5)
destroy(this.rr_1)
end on

event open;call super::open;dw_5.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)

string  is_pspec , is_jijil, is_baljpno
Int     ii_balseq

is_baljpno = gs_code   // 발주번호 
ii_balseq = integer(gs_gubun)   // 발주항번 

dw_5.retrieve (gs_sabu,  is_baljpno , ii_balseq )
dw_2.retrieve (gs_sabu,  is_baljpno , ii_balseq )
dw_3.retrieve (gs_sabu,  is_baljpno , ii_balseq )
dw_4.retrieve (gs_sabu,  is_baljpno , ii_balseq )

IF f_change_name('1') = 'Y' then 
	is_pspec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_5.object.ispec_t.text = is_pspec
	dw_5.object.jijil_t.text = is_jijil
END IF


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imt_02040_popup
boolean visible = false
integer x = 2926
integer y = 1564
integer width = 197
end type

type p_exit from w_inherite_popup`p_exit within w_imt_02040_popup
integer x = 2939
integer y = 12
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_imt_02040_popup
boolean visible = false
integer x = 2821
integer y = 1872
end type

type p_choose from w_inherite_popup`p_choose within w_imt_02040_popup
boolean visible = false
integer x = 2994
integer y = 1872
end type

type dw_1 from w_inherite_popup`dw_1 within w_imt_02040_popup
boolean visible = false
integer x = 78
integer y = 48
integer width = 2619
integer height = 304
boolean enabled = false
boolean vscrollbar = false
end type

type sle_2 from w_inherite_popup`sle_2 within w_imt_02040_popup
integer x = 603
integer y = 3436
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_imt_02040_popup
integer x = 1993
integer y = 3436
integer taborder = 0
end type

type cb_return from w_inherite_popup`cb_return within w_imt_02040_popup
integer x = 2629
integer y = 3436
integer taborder = 0
end type

type cb_inq from w_inherite_popup`cb_inq within w_imt_02040_popup
integer x = 2313
integer y = 3436
integer taborder = 0
end type

type sle_1 from w_inherite_popup`sle_1 within w_imt_02040_popup
integer x = 421
integer y = 3436
integer taborder = 0
end type

type st_1 from w_inherite_popup`st_1 within w_imt_02040_popup
integer x = 142
integer y = 3436
end type

type dw_2 from datawindow within w_imt_02040_popup
integer x = 91
integer y = 352
integer width = 3008
integer height = 476
boolean bringtotop = true
string dataobject = "d_imt_02040_popup2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_imt_02040_popup
integer x = 91
integer y = 908
integer width = 3008
integer height = 476
boolean bringtotop = true
string dataobject = "d_imt_02040_popup3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_4 from datawindow within w_imt_02040_popup
integer x = 91
integer y = 1476
integer width = 3008
integer height = 476
boolean bringtotop = true
string dataobject = "d_imt_02040_popup4"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_imt_02040_popup
integer x = 87
integer y = 300
integer width = 453
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[ L/C 현황 ]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_imt_02040_popup
integer x = 87
integer y = 852
integer width = 699
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[ B/L && 인수중 현황 ]"
boolean focusrectangle = false
end type

type st_4 from statictext within w_imt_02040_popup
integer x = 87
integer y = 1420
integer width = 480
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[ 입고 현황 ]"
boolean focusrectangle = false
end type

type dw_5 from datawindow within w_imt_02040_popup
integer x = 37
integer y = 8
integer width = 2592
integer height = 280
boolean bringtotop = true
string dataobject = "d_imt_02040_popup1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_imt_02040_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 288
integer width = 3049
integer height = 1684
integer cornerheight = 40
integer cornerwidth = 55
end type

