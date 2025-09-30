$PBExportHeader$w_pdt_02000_a.srw
$PBExportComments$생산승인등록시 공정정보
forward
global type w_pdt_02000_a from window
end type
type st_2 from statictext within w_pdt_02000_a
end type
type st_1 from statictext within w_pdt_02000_a
end type
type dw_3 from datawindow within w_pdt_02000_a
end type
type dw_1 from datawindow within w_pdt_02000_a
end type
type dw_2 from datawindow within w_pdt_02000_a
end type
type rr_1 from roundrectangle within w_pdt_02000_a
end type
type rr_2 from roundrectangle within w_pdt_02000_a
end type
type rr_3 from roundrectangle within w_pdt_02000_a
end type
end forward

global type w_pdt_02000_a from window
integer x = 5
integer y = 304
integer width = 3753
integer height = 2072
boolean titlebar = true
string title = "생산승인 품목에 대한 공정 및 재고내역 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
st_2 st_2
st_1 st_1
dw_3 dw_3
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pdt_02000_a w_pdt_02000_a

type variables
String iSreturn, iSpordno
end variables

on w_pdt_02000_a.create
this.st_2=create st_2
this.st_1=create st_1
this.dw_3=create dw_3
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.st_2,&
this.st_1,&
this.dw_3,&
this.dw_1,&
this.dw_2,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_pdt_02000_a.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_3)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

decimal {3} djego

dw_2.retrieve(gs_code)

if dw_1.retrieve(gs_code) > 0 then
	dJego = dw_1.getitemdecimal(1, "compute_0003")
Else
	dJego = 0
End if
dw_3.retrieve(gs_sabu, gs_code, dJego)	
st_1.text = '창고별 재고내역 [ ' + trim(gs_codename) + ' ]'
st_2.text = '입출고 예정현황 [ ' + trim(gs_codename) + ' ]'	


end event

type st_2 from statictext within w_pdt_02000_a
integer x = 1856
integer y = 984
integer width = 1733
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "입출고 예정현황"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdt_02000_a
integer x = 55
integer y = 984
integer width = 1733
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "창고별 재고내역"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_pdt_02000_a
integer x = 1829
integer y = 1060
integer width = 1847
integer height = 900
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_07100_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_1 from datawindow within w_pdt_02000_a
integer x = 27
integer y = 1064
integer width = 1765
integer height = 896
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_07100_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_2 from datawindow within w_pdt_02000_a
integer x = 32
integer y = 36
integer width = 2222
integer height = 888
integer taborder = 10
string dataobject = "d_pdt_02000_4"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_02000_a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 28
integer width = 2245
integer height = 908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02000_a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 1052
integer width = 1778
integer height = 912
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_02000_a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1824
integer y = 1052
integer width = 1861
integer height = 912
integer cornerheight = 40
integer cornerwidth = 55
end type

