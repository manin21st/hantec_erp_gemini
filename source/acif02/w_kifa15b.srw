$PBExportHeader$w_kifa15b.srw
$PBExportComments$자동전표 관리 : NEGO(상세조회)
forward
global type w_kifa15b from window
end type
type dw_head from datawindow within w_kifa15b
end type
type tab_nego from tab within w_kifa15b
end type
type tabpage_ipgum from userobject within tab_nego
end type
type rr_1 from roundrectangle within tabpage_ipgum
end type
type dw_ipgum from datawindow within tabpage_ipgum
end type
type tabpage_ipgum from userobject within tab_nego
rr_1 rr_1
dw_ipgum dw_ipgum
end type
type tabpage_nglst from userobject within tab_nego
end type
type rr_2 from roundrectangle within tabpage_nglst
end type
type dw_nego from datawindow within tabpage_nglst
end type
type tabpage_nglst from userobject within tab_nego
rr_2 rr_2
dw_nego dw_nego
end type
type tabpage_gita from userobject within tab_nego
end type
type rr_3 from roundrectangle within tabpage_gita
end type
type dw_gita from datawindow within tabpage_gita
end type
type tabpage_gita from userobject within tab_nego
rr_3 rr_3
dw_gita dw_gita
end type
type tabpage_bill from userobject within tab_nego
end type
type rr_4 from roundrectangle within tabpage_bill
end type
type dw_bill from datawindow within tabpage_bill
end type
type tabpage_bill from userobject within tab_nego
rr_4 rr_4
dw_bill dw_bill
end type
type tab_nego from tab within w_kifa15b
tabpage_ipgum tabpage_ipgum
tabpage_nglst tabpage_nglst
tabpage_gita tabpage_gita
tabpage_bill tabpage_bill
end type
end forward

global type w_kifa15b from window
integer x = 219
integer y = 188
integer width = 4197
integer height = 2092
boolean titlebar = true
string title = "NEGO전표 처리(상세 조회)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_head dw_head
tab_nego tab_nego
end type
global w_kifa15b w_kifa15b

on w_kifa15b.create
this.dw_head=create dw_head
this.tab_nego=create tab_nego
this.Control[]={this.dw_head,&
this.tab_nego}
end on

on w_kifa15b.destroy
destroy(this.dw_head)
destroy(this.tab_nego)
end on

event open;String   sNgNo,sCurr,sSonIkGbn
Double   dWeight

F_Window_Center(This)

sNgNo     = Message.StringParm
sSonIkGbn = Gs_Gubun

dw_head.SetTransObject(SQLCA)
dw_head.Reset()
dw_head.Retrieve(sNgNo)
sCurr = dw_head.GetItemString(1,"icurr")

SELECT to_number("REFFPF"."RFNA2")      INTO :dWeight  
	FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = '10' ) AND  
         ( "REFFPF"."RFGUB" = :sCurr ) ;

tab_nego.tabpage_ipgum.dw_ipgum.SetTransObject(Sqlca)
tab_nego.tabpage_nglst.dw_nego.SetTransObject(Sqlca)
tab_nego.tabpage_gita.dw_gita.SetTransObject(Sqlca)
tab_nego.tabpage_bill.dw_bill.SetTransObject(Sqlca)

tab_nego.tabpage_ipgum.dw_ipgum.Reset()
tab_nego.tabpage_nglst.dw_nego.Reset()
tab_nego.tabpage_gita.dw_gita.Reset()
tab_nego.tabpage_bill.dw_bill.Reset()

tab_nego.tabpage_ipgum.dw_ipgum.Retrieve(sNgNo)
tab_nego.tabpage_nglst.dw_nego.Retrieve(sNgNo,dWeight,sCurr,sSonIkGbn)
tab_nego.tabpage_gita.dw_gita.Retrieve(sNgNo)
tab_nego.tabpage_bill.dw_bill.Retrieve(sNgNo)

end event

type dw_head from datawindow within w_kifa15b
integer x = 37
integer width = 4110
integer height = 204
string dataobject = "d_kifa15b1"
boolean border = false
boolean livescroll = true
end type

type tab_nego from tab within w_kifa15b
integer x = 41
integer y = 192
integer width = 4110
integer height = 1772
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_ipgum tabpage_ipgum
tabpage_nglst tabpage_nglst
tabpage_gita tabpage_gita
tabpage_bill tabpage_bill
end type

on tab_nego.create
this.tabpage_ipgum=create tabpage_ipgum
this.tabpage_nglst=create tabpage_nglst
this.tabpage_gita=create tabpage_gita
this.tabpage_bill=create tabpage_bill
this.Control[]={this.tabpage_ipgum,&
this.tabpage_nglst,&
this.tabpage_gita,&
this.tabpage_bill}
end on

on tab_nego.destroy
destroy(this.tabpage_ipgum)
destroy(this.tabpage_nglst)
destroy(this.tabpage_gita)
destroy(this.tabpage_bill)
end on

type tabpage_ipgum from userobject within tab_nego
integer x = 18
integer y = 96
integer width = 4073
integer height = 1660
long backcolor = 32106727
string text = "입금내역"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_ipgum dw_ipgum
end type

on tabpage_ipgum.create
this.rr_1=create rr_1
this.dw_ipgum=create dw_ipgum
this.Control[]={this.rr_1,&
this.dw_ipgum}
end on

on tabpage_ipgum.destroy
destroy(this.rr_1)
destroy(this.dw_ipgum)
end on

type rr_1 from roundrectangle within tabpage_ipgum
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 12
integer width = 4050
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ipgum from datawindow within tabpage_ipgum
integer x = 27
integer y = 24
integer width = 4023
integer height = 1612
integer taborder = 20
string dataobject = "d_kifa15b2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_nglst from userobject within tab_nego
integer x = 18
integer y = 96
integer width = 4073
integer height = 1660
long backcolor = 32106727
string text = "외상매출금 내역"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_nego dw_nego
end type

on tabpage_nglst.create
this.rr_2=create rr_2
this.dw_nego=create dw_nego
this.Control[]={this.rr_2,&
this.dw_nego}
end on

on tabpage_nglst.destroy
destroy(this.rr_2)
destroy(this.dw_nego)
end on

type rr_2 from roundrectangle within tabpage_nglst
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 12
integer width = 4050
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_nego from datawindow within tabpage_nglst
integer x = 27
integer y = 24
integer width = 4027
integer height = 1612
integer taborder = 20
string dataobject = "d_kifa15b3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_gita from userobject within tab_nego
integer x = 18
integer y = 96
integer width = 4073
integer height = 1660
long backcolor = 32106727
string text = "수출제비용"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_gita dw_gita
end type

on tabpage_gita.create
this.rr_3=create rr_3
this.dw_gita=create dw_gita
this.Control[]={this.rr_3,&
this.dw_gita}
end on

on tabpage_gita.destroy
destroy(this.rr_3)
destroy(this.dw_gita)
end on

type rr_3 from roundrectangle within tabpage_gita
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 12
integer width = 4050
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_gita from datawindow within tabpage_gita
integer x = 27
integer y = 20
integer width = 4023
integer height = 1616
integer taborder = 20
string dataobject = "d_kifa15b4"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_bill from userobject within tab_nego
integer x = 18
integer y = 96
integer width = 4073
integer height = 1660
long backcolor = 32106727
string text = "받을어음"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_bill dw_bill
end type

on tabpage_bill.create
this.rr_4=create rr_4
this.dw_bill=create dw_bill
this.Control[]={this.rr_4,&
this.dw_bill}
end on

on tabpage_bill.destroy
destroy(this.rr_4)
destroy(this.dw_bill)
end on

type rr_4 from roundrectangle within tabpage_bill
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 12
integer width = 4050
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_bill from datawindow within tabpage_bill
integer x = 32
integer y = 24
integer width = 4014
integer height = 1612
integer taborder = 30
string title = "none"
string dataobject = "d_kifa15b5"
boolean border = false
boolean livescroll = true
end type

