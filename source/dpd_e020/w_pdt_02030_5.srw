$PBExportHeader$w_pdt_02030_5.srw
$PBExportComments$반제품 자동계산내역에 대한 결과 조회
forward
global type w_pdt_02030_5 from window
end type
type dw_2 from datawindow within w_pdt_02030_5
end type
type rr_1 from roundrectangle within w_pdt_02030_5
end type
end forward

global type w_pdt_02030_5 from window
integer x = 425
integer y = 592
integer width = 2949
integer height = 1068
boolean titlebar = true
string title = "자동 작업지시 계산내역 결과"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
rr_1 rr_1
end type
global w_pdt_02030_5 w_pdt_02030_5

type variables
String iSreturn, iSpordno
end variables

on w_pdt_02030_5.create
this.dw_2=create dw_2
this.rr_1=create rr_1
this.Control[]={this.dw_2,&
this.rr_1}
end on

on w_pdt_02030_5.destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

dw_2.settransobject(sqlca)
dw_2.retrieve(gs_sabu, gs_code)


end event

type dw_2 from datawindow within w_pdt_02030_5
integer x = 37
integer y = 28
integer width = 2857
integer height = 916
integer taborder = 10
string dataobject = "d_pdt_02030_5"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_02030_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 20
integer width = 2880
integer height = 936
integer cornerheight = 40
integer cornerwidth = 55
end type

