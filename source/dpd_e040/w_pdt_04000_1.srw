$PBExportHeader$w_pdt_04000_1.srw
$PBExportComments$구매의뢰등록시 재고 및 입출고 현황조회
forward
global type w_pdt_04000_1 from window
end type
type dw_2 from datawindow within w_pdt_04000_1
end type
type dw_1 from datawindow within w_pdt_04000_1
end type
type gb_2 from groupbox within w_pdt_04000_1
end type
type gb_1 from groupbox within w_pdt_04000_1
end type
end forward

global type w_pdt_04000_1 from window
integer x = 9
integer y = 1068
integer width = 3621
integer height = 1112
boolean titlebar = true
string title = "재고 및 입출고 예정현황"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
dw_1 dw_1
gb_2 gb_2
gb_1 gb_1
end type
global w_pdt_04000_1 w_pdt_04000_1

on w_pdt_04000_1.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.dw_2,&
this.dw_1,&
this.gb_2,&
this.gb_1}
end on

on w_pdt_04000_1.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

Decimal {3} dJego

if dw_1.retrieve(gs_code) > 0 then
	dJego = dw_1.getitemdecimal(1, "compute_0003")
Else
	dJego = 0
End if
dw_2.retrieve(gs_sabu, gs_code, dJego)	
gb_1.text = '창고별 재고내역 [ ' + trim(gs_code) + ' - ' + trim(gs_codename) + ' ]'
gb_2.text = '입출고 예정현황 [ ' + trim(gs_code) + ' - ' + trim(gs_codename) + ' ]'
end event

type dw_2 from datawindow within w_pdt_04000_1
integer x = 1701
integer y = 60
integer width = 1865
integer height = 928
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_07100_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdt_04000_1
integer x = 14
integer y = 60
integer width = 1632
integer height = 928
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_07100_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_pdt_04000_1
integer x = 1682
integer width = 1906
integer height = 1004
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "입출고 예정현황"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_pdt_04000_1
integer width = 1664
integer height = 1004
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "창고별 재고내역"
borderstyle borderstyle = stylelowered!
end type

