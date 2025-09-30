$PBExportHeader$w_pdt_formula.srw
$PBExportComments$Spare Part & 유류품 공식
forward
global type w_pdt_formula from window
end type
type p_1 from uo_picture within w_pdt_formula
end type
type st_8 from statictext within w_pdt_formula
end type
type st_6 from statictext within w_pdt_formula
end type
type st_7 from statictext within w_pdt_formula
end type
type st_5 from statictext within w_pdt_formula
end type
type st_4 from statictext within w_pdt_formula
end type
type st_1 from statictext within w_pdt_formula
end type
type st_3 from statictext within w_pdt_formula
end type
type st_2 from statictext within w_pdt_formula
end type
type rr_1 from roundrectangle within w_pdt_formula
end type
end forward

global type w_pdt_formula from window
integer x = 219
integer y = 512
integer width = 2638
integer height = 1132
boolean titlebar = true
string title = "자동의뢰생성 공식"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
st_8 st_8
st_6 st_6
st_7 st_7
st_5 st_5
st_4 st_4
st_1 st_1
st_3 st_3
st_2 st_2
rr_1 rr_1
end type
global w_pdt_formula w_pdt_formula

on w_pdt_formula.create
this.p_1=create p_1
this.st_8=create st_8
this.st_6=create st_6
this.st_7=create st_7
this.st_5=create st_5
this.st_4=create st_4
this.st_1=create st_1
this.st_3=create st_3
this.st_2=create st_2
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.st_8,&
this.st_6,&
this.st_7,&
this.st_5,&
this.st_4,&
this.st_1,&
this.st_3,&
this.st_2,&
this.rr_1}
end on

on w_pdt_formula.destroy
destroy(this.p_1)
destroy(this.st_8)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.rr_1)
end on

type p_1 from uo_picture within w_pdt_formula
integer x = 2363
integer y = 884
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'c:\erpman\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'c:\erpman\image\닫기_dn.gif'
end event

type st_8 from statictext within w_pdt_formula
integer x = 759
integer y = 668
integer width = 695
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "/ 3 * 증감율 + 수명"
boolean focusrectangle = false
end type

type st_6 from statictext within w_pdt_formula
integer x = 165
integer y = 580
integer width = 2295
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "(1) 적정재고 = (돌발고장수량 + 설비1대당 동일부품수량 + 사용수량)         "
boolean focusrectangle = false
end type

type st_7 from statictext within w_pdt_formula
integer x = 165
integer y = 772
integer width = 1111
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "(2) 의뢰량 = 적정재고 - 현재고 "
boolean focusrectangle = false
end type

type st_5 from statictext within w_pdt_formula
integer x = 50
integer y = 468
integer width = 809
integer height = 84
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "Spare Part 계산공식"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pdt_formula
integer x = 165
integer y = 308
integer width = 2117
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "(3) 유류 구매 의뢰량 = 적정재고 - 현재고 "
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdt_formula
integer x = 165
integer y = 140
integer width = 2117
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "(1) 자동발주예정량 = 의뢰일자 ~~ 일수 간 사용예정인 주유량."
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_formula
integer x = 165
integer y = 220
integer width = 2117
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "(2) 적정재고 =  안전재고(Min) + ( 자동발주예정량 * 증감율 ) "
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_formula
integer x = 46
integer y = 44
integer width = 649
integer height = 76
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "유류품 계산공식 "
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_formula
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 8
integer width = 2523
integer height = 856
integer cornerheight = 40
integer cornerwidth = 55
end type

