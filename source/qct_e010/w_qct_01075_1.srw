$PBExportHeader$w_qct_01075_1.srw
$PBExportComments$원자재 이상발생 현황-(요약/상세)
forward
global type w_qct_01075_1 from window
end type
type p_1 from uo_picture within w_qct_01075_1
end type
type tab_1 from tab within w_qct_01075_1
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tab_1 from tab within w_qct_01075_1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_qct_01075_1 from window
integer x = 256
integer y = 224
integer width = 3209
integer height = 2112
boolean titlebar = true
string title = "업체별 이상발생 현황"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
tab_1 tab_1
end type
global w_qct_01075_1 w_qct_01075_1

type variables

end variables

on w_qct_01075_1.create
this.p_1=create p_1
this.tab_1=create tab_1
this.Control[]={this.p_1,&
this.tab_1}
end on

on w_qct_01075_1.destroy
destroy(this.p_1)
destroy(this.tab_1)
end on

type p_1 from uo_picture within w_qct_01075_1
integer x = 2971
integer y = 12
integer width = 178
string pointer = "C:\erpman\cur\print.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;if tab_1.selectedtab =1 then
	if tab_1.tabpage_1.dw_1.rowcount() > 0 then 
		gi_page = tab_1.tabpage_1.dw_1.getitemdecimal(1, "gi_page")
		openwithparm(w_print_options, tab_1.tabpage_1.dw_1)
	else
		f_message_chk(50,'')
	end if
elseif tab_1.selectedtab = 2 then	
	if tab_1.tabpage_2.dw_2.rowcount() > 0 then 
		gi_page = tab_1.tabpage_2.dw_2.getitemdecimal(1, "gi_page")
		openwithparm(w_print_options, tab_1.tabpage_2.dw_2)	
	else
		f_message_chk(50,'')
	end if
else
	if tab_1.tabpage_3.dw_3.rowcount() > 0 then 
		gi_page = tab_1.tabpage_3.dw_3.getitemdecimal(1, "gi_page")
		openwithparm(w_print_options, tab_1.tabpage_3.dw_3)	
	else
		f_message_chk(50,'')
	end if
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\인쇄_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\인쇄_dn.gif'
end event

type tab_1 from tab within w_qct_01075_1
integer x = 14
integer y = 64
integer width = 3168
integer height = 1932
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	tab_1.tabpage_3.dw_3.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_3.dw_3.Object.jijil_tx.text =  sJijilText
End If
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3131
integer height = 1804
long backcolor = 32106727
string text = "집계"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Custom073!"
long picturemaskcolor = 553648127
dw_1 dw_1
end type

event constructor;dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code, gs_codename)
end event

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer x = 23
integer y = 16
integer width = 3081
integer height = 1760
integer taborder = 20
string dataobject = "d_qct_01075_1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3131
integer height = 1804
long backcolor = 32106727
string text = "요약"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "CheckDiff!"
long picturemaskcolor = 553648127
dw_2 dw_2
end type

event constructor;dw_2.settransobject(sqlca)
dw_2.retrieve(gs_sabu, gs_code, gs_codename)
end event

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer x = 18
integer y = 24
integer width = 3081
integer height = 1760
integer taborder = 30
string dataobject = "d_qct_01075_1_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3131
integer height = 1804
long backcolor = 32106727
string text = "상세"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Sort!"
long picturemaskcolor = 553648127
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

event constructor;dw_3.settransobject(sqlca)
dw_3.retrieve(gs_sabu, gs_code, gs_codename)
end event

type dw_3 from datawindow within tabpage_3
integer x = 23
integer y = 20
integer width = 3081
integer height = 1760
integer taborder = 50
string dataobject = "d_qct_01075_1_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

