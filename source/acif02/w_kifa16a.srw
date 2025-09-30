$PBExportHeader$w_kifa16a.srw
$PBExportComments$자동전표 관리 : 외자입고(품목상세)
forward
global type w_kifa16a from window
end type
type p_exit from uo_picture within w_kifa16a
end type
type dw_list from datawindow within w_kifa16a
end type
type rr_1 from roundrectangle within w_kifa16a
end type
end forward

global type w_kifa16a from window
integer x = 142
integer y = 128
integer width = 4027
integer height = 2224
boolean titlebar = true
string title = "외자입고 자료 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa16a w_kifa16a

on w_kifa16a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa16a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String sLcAndBl

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sLcAndBl = Message.StringParm

//this.Title = this.Title + '[계산서권번호 : '+sChkNo+' ]'

IF dw_list.Retrieve(Gs_Code,sLcAndBl) <=0 then
	F_MessageChk(14,'')
	Close(w_kifa16a)
	Return
END IF


	


end event

type p_exit from uo_picture within w_kifa16a
integer x = 3799
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Close(w_kifa16a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa16a
integer x = 50
integer y = 164
integer width = 3909
integer height = 1912
string dataobject = "d_kifa16a1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kifa16a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 152
integer width = 3931
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

