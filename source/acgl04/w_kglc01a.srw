$PBExportHeader$w_kglc01a.srw
$PBExportComments$미승인 전표 상세 조회
forward
global type w_kglc01a from window
end type
type p_exit from uo_picture within w_kglc01a
end type
type dw_2 from datawindow within w_kglc01a
end type
type dw_disp from datawindow within w_kglc01a
end type
type rr_1 from roundrectangle within w_kglc01a
end type
end forward

global type w_kglc01a from window
integer x = 169
integer y = 148
integer width = 4498
integer height = 2300
boolean titlebar = true
string title = "미승인전표 상세 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_2 dw_2
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglc01a w_kglc01a

event open;String ls_colx

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu, lstr_jpra.bjunno)

dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu, lstr_jpra.bjunno)

//h split scrollbar
ls_colx = dw_2.Object.kfz12ot0_vatamt.x

// Set the position of the horizontal split scroll point.
dw_2.Object.datawindow.horizontalscrollsplit = ls_colx

end event

on w_kglc01a.create
this.p_exit=create p_exit
this.dw_2=create dw_2
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_2,&
this.dw_disp,&
this.rr_1}
end on

on w_kglc01a.destroy
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kglc01a
integer x = 4274
integer y = 12
integer width = 178
integer taborder = 1
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

type dw_2 from datawindow within w_kglc01a
integer x = 32
integer y = 216
integer width = 4398
integer height = 1924
string dataobject = "dw_kglc01a2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event buttonclicked;
//IF dwo.name = 'dcb_detail' THEN					/*적요내역 버튼 클릭시*/
//
//	lstr_jpra.saupjang = this.GetItemString(this.GetRow(),"kfz12ot0_saupj")
//	lstr_jpra.baldate  = this.GetItemString(this.GetRow(),"kfz12ot0_bal_date")
//	lstr_jpra.upmugu   = this.GetItemString(this.GetRow(),"kfz12ot0_upmu_gu")	
//	lstr_jpra.bjunno   = this.GetItemNumber(this.GetRow(),"kfz12ot0_bjun_no")
//	lstr_jpra.sortno   = this.GetItemNumber(this.GetRow(),"kfz12ot0_lin_no")	
//	Open(W_Kglb04)			
//END IF
end event

type dw_disp from datawindow within w_kglc01a
integer x = 14
integer y = 4
integer width = 3003
integer height = 200
string dataobject = "dw_kglc01a1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglc01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 208
integer width = 4425
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

