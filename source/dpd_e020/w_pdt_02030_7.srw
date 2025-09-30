$PBExportHeader$w_pdt_02030_7.srw
$PBExportComments$작업지시 결과요약
forward
global type w_pdt_02030_7 from window
end type
type dw_2 from datawindow within w_pdt_02030_7
end type
type rr_1 from roundrectangle within w_pdt_02030_7
end type
end forward

global type w_pdt_02030_7 from window
integer x = 46
integer y = 512
integer width = 3611
integer height = 1732
boolean titlebar = true
string title = "작업지시 요약 내역"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
rr_1 rr_1
end type
global w_pdt_02030_7 w_pdt_02030_7

type variables
String iSreturn, iSpordno
end variables

on w_pdt_02030_7.create
this.dw_2=create dw_2
this.rr_1=create rr_1
this.Control[]={this.dw_2,&
this.rr_1}
end on

on w_pdt_02030_7.destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

dw_2.settransobject(sqlca)
dw_2.retrieve(gs_sabu, gs_code)


end event

type dw_2 from datawindow within w_pdt_02030_7
integer x = 41
integer y = 28
integer width = 3511
integer height = 1560
integer taborder = 10
string dataobject = "d_pdt_02030_summ"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_02030_7
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 20
integer width = 3534
integer height = 1580
integer cornerheight = 40
integer cornerwidth = 55
end type

