$PBExportHeader$w_kifa05a.srw
$PBExportComments$자동전표 관리 : 수금(수금 상세)
forward
global type w_kifa05a from window
end type
type p_exit from uo_picture within w_kifa05a
end type
type dw_list from datawindow within w_kifa05a
end type
type rr_1 from roundrectangle within w_kifa05a
end type
end forward

global type w_kifa05a from window
integer x = 110
integer y = 172
integer width = 4599
integer height = 2224
boolean titlebar = true
string title = "수금 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa05a w_kifa05a

on w_kifa05a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa05a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String sSugumNo

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sSugumNo = Gs_Code

//this.Title = this.Title + '[계산서권번호 : '+sChkNo+' ]'

IF dw_list.Retrieve(sSugumNo) <=0 then
	F_MessageChk(14,'')
	Close(w_kifa05a)
	Return
END IF


	


end event

type p_exit from uo_picture within w_kifa05a
integer x = 4384
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;close(w_kifa05a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa05a
integer x = 64
integer y = 168
integer width = 4475
integer height = 1920
integer taborder = 10
string dataobject = "d_kifa05a1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kifa05a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 156
integer width = 4507
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

