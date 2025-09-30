$PBExportHeader$w_qct_01100_01.srw
$PBExportComments$이상발생시 사용내역 조회
forward
global type w_qct_01100_01 from window
end type
type p_print from uo_picture within w_qct_01100_01
end type
type p_exit from uo_picture within w_qct_01100_01
end type
type dw_1 from datawindow within w_qct_01100_01
end type
type rr_1 from roundrectangle within w_qct_01100_01
end type
end forward

global type w_qct_01100_01 from window
integer x = 96
integer y = 136
integer width = 4393
integer height = 2152
boolean titlebar = true
string title = "BOM사용내역 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_print p_print
p_exit p_exit
dw_1 dw_1
rr_1 rr_1
end type
global w_qct_01100_01 w_qct_01100_01

event open;String sitnbr

sitnbr = message.stringparm
dw_1.settransobject(sqlca)

IF f_change_name('1') = 'Y' then 
	string is_ispec, is_jijil
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_1.object.ispec_t.text = is_ispec
	dw_1.object.jijil_t.text = is_jijil
END IF

if dw_1.Retrieve(sitnbr) < 1 then //자료 없을 때
   MessageBox("사용내역", "해당 품목에 대한 사용내역이 없읍니다!")
//	close(this)
//	return
end if

end event

on w_qct_01100_01.create
this.p_print=create p_print
this.p_exit=create p_exit
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_print,&
this.p_exit,&
this.dw_1,&
this.rr_1}
end on

on w_qct_01100_01.destroy
destroy(this.p_print)
destroy(this.p_exit)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type p_print from uo_picture within w_qct_01100_01
integer x = 3995
integer y = 4
integer width = 178
integer taborder = 10
string pointer = "c:\ERPMAN\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;openwithparm(w_print_options, dw_1)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_exit from uo_picture within w_qct_01100_01
integer x = 4169
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\close.cur"
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

type dw_1 from datawindow within w_qct_01100_01
integer x = 46
integer y = 168
integer width = 4279
integer height = 1836
string dataobject = "d_qct_01100_03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_qct_01100_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 160
integer width = 4306
integer height = 1856
integer cornerheight = 40
integer cornerwidth = 55
end type

