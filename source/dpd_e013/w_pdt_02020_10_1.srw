$PBExportHeader$w_pdt_02020_10_1.srw
$PBExportComments$수주에 대한 작업지시 검색
forward
global type w_pdt_02020_10_1 from window
end type
type dw_2 from datawindow within w_pdt_02020_10_1
end type
type p_inq from uo_picture within w_pdt_02020_10_1
end type
type dw_1 from datawindow within w_pdt_02020_10_1
end type
type rr_1 from roundrectangle within w_pdt_02020_10_1
end type
type rr_2 from roundrectangle within w_pdt_02020_10_1
end type
end forward

global type w_pdt_02020_10_1 from window
integer x = 73
integer y = 716
integer width = 3808
integer height = 1184
boolean titlebar = true
string title = "수주검색"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
p_inq p_inq
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02020_10_1 w_pdt_02020_10_1

event open;dw_1.settransobject(sqlca)
dw_2.InsertRow(0)
dw_2.SetFocus()
end event

on w_pdt_02020_10_1.create
this.dw_2=create dw_2
this.p_inq=create p_inq
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.dw_2,&
this.p_inq,&
this.dw_1,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_02020_10_1.destroy
destroy(this.dw_2)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_2 from datawindow within w_pdt_02020_10_1
integer x = 50
integer y = 40
integer width = 1248
integer height = 108
integer taborder = 20
string title = "none"
string dataobject = "d_pdt_02020_10_2"
boolean border = false
boolean livescroll = true
end type

type p_inq from uo_picture within w_pdt_02020_10_1
integer x = 3584
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sno

IF dw_2.AcceptText() = -1 THEN Return

sNo = dw_2.GetItemString(1, 'ordno')

if dw_1.retrieve(gs_sabu, sNo) < 1 then
	Messagebox("작업지시내역", "작업지시내역이 없읍니다", stopsign!)
	dw_2.setfocus()
	return
end if
end event

type dw_1 from datawindow within w_pdt_02020_10_1
integer x = 37
integer y = 188
integer width = 3703
integer height = 876
integer taborder = 20
string dataobject = "d_pdt_02020_10_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_02020_10_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 20
integer width = 1326
integer height = 148
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02020_10_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 184
integer width = 3730
integer height = 888
integer cornerheight = 40
integer cornerwidth = 55
end type

