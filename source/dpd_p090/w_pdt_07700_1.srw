$PBExportHeader$w_pdt_07700_1.srw
$PBExportComments$매입금액분석-품목별 매입금액 상세
forward
global type w_pdt_07700_1 from window
end type
type dw_1 from datawindow within w_pdt_07700_1
end type
type rr_1 from roundrectangle within w_pdt_07700_1
end type
end forward

global type w_pdt_07700_1 from window
integer x = 197
integer y = 400
integer width = 3287
integer height = 1736
boolean titlebar = true
string title = "품목별 매입금액 분석[상세]"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_07700_1 w_pdt_07700_1

on w_pdt_07700_1.create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_1,&
this.rr_1}
end on

on w_pdt_07700_1.destroy
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;String sParm, soption, ssdate, sedate, sgubun, sitnbr, swaigu, ssaupj

sParm = message.stringparm
//123456789 123456789 1234567890
//12000010120000131%321061110120

ssaupj  = gs_code 
sOption = mid(sParm, 1,   1)
swaigu  = mid(sParm, 2,   1)
ssDate  = mid(sParm, 3,   8)
seDate  = mid(sParm, 11,  8)
sgubun  = mid(sParm, 19,  1)
sitnbr  = mid(sParm, 20, 15)

// 검사일자, 승인일자 기준에 의하여 datawindow를 선정
if sOption = '1' then // 검사일자
   dw_1.dataobject = 'd_pdt_07700_3'
else
   dw_1.dataobject = 'd_pdt_07700_4'
end if

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, sSdate, sEdate, sGubun, sItnbr, swaigu, ssaupj)
end event

type dw_1 from datawindow within w_pdt_07700_1
integer x = 23
integer y = 16
integer width = 3232
integer height = 1616
integer taborder = 10
string dataobject = "d_pdt_07700_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pdt_07700_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 4
integer width = 3259
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

