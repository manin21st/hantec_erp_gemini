$PBExportHeader$w_pdt_07200_5.srw
$PBExportComments$대체품목 조회화면
forward
global type w_pdt_07200_5 from window
end type
type dw_1 from datawindow within w_pdt_07200_5
end type
type rr_1 from roundrectangle within w_pdt_07200_5
end type
end forward

global type w_pdt_07200_5 from window
integer x = 197
integer y = 400
integer width = 3287
integer height = 1724
boolean titlebar = true
string title = "대체품목조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_07200_5 w_pdt_07200_5

on w_pdt_07200_5.create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_1,&
this.rr_1}
end on

on w_pdt_07200_5.destroy
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;dw_1.settransobject(sqlca)
dw_1.retrieve(gs_code)
SEtnull(gs_code)

f_window_center_response(this)

end event

type dw_1 from datawindow within w_pdt_07200_5
integer x = 32
integer y = 24
integer width = 3191
integer height = 1592
integer taborder = 1
string dataobject = "d_pdt_07200_5"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_07200_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 3241
integer height = 1620
integer cornerheight = 40
integer cornerwidth = 55
end type

