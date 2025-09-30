$PBExportHeader$w_sal_05800.srw
$PBExportComments$인당 매출금액 현황(월,분기)
forward
global type w_sal_05800 from w_standard_print
end type
type tab_1 from tab within w_sal_05800
end type
type tabpage_1 from userobject within tab_1
end type
type dw_list_tab1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_list_tab1 dw_list_tab1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_list_tab2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_list_tab2 dw_list_tab2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_list_tab3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_list_tab3 dw_list_tab3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_list_tab4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_list_tab4 dw_list_tab4
end type
type tab_1 from tab within w_sal_05800
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_sal_05800 from w_standard_print
string title = "인당 매출금액 현황"
tab_1 tab_1
end type
global w_sal_05800 w_sal_05800

type variables
datawindow dw_select
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syymm,pyymm,steam
string   tx_steam
int      rtn

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syymm  = trim(dw_ip.getitemstring(1, 'syymm'))
steam  = trim(dw_ip.getitemstring(1, 'steam'))

If IsNull(steam)  Then steam = ''

IF	f_datechk(syymm+'0101') = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	Return -1
END IF

////////////////////////////////// dw 선택및 트랜젝션 연결
Choose Case tab_1.SelectedTab
	Case 1
		dw_select = tab_1.tabpage_1.dw_list_tab1
	   dw_print.dataObject= "d_sal_05800_p" 
   Case 2
		dw_select = tab_1.tabpage_2.dw_list_tab2
	   dw_print.dataObject= "d_sal_05810" 
   Case 3
		dw_select = tab_1.tabpage_3.dw_list_tab3
	   dw_print.dataObject= "d_sal_05820"   
   Case 4
		dw_select = tab_1.tabpage_4.dw_list_tab4
      dw_print.dataObject= "d_sal_05830"    
End Choose		
dw_select.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
//////////////////////////////////////////////////////////////
dw_print.SetRedraw(False)

pyymm = String(Long(syymm) - 1,'0000')

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

Choose Case tab_1.SelectedTab
	Case 1,2
		rtn = dw_print.Retrieve(gs_sabu, pyymm, syymm, steam+'%',ls_silgu)
	Case 3,4
		rtn = dw_print.Retrieve(gs_sabu, pyymm, syymm, steam+'%',ls_silgu)    //영업팀별
End Choose		

if rtn < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('steam')
	dw_ip.setfocus()
	dw_select.SetRedraw(True)
	return -1
end if

 dw_print.sharedata(dw_list)
tx_steam = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steam) ', 1)"))
If tx_steam = '' Then tx_steam = '전체'
//dw_select.Object.tx_steamnm.text = tx_steam
//
dw_print.SetRedraw(True)

Return 1


end function

on w_sal_05800.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_05800.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syymm',syymm)

dw_select = Create datawindow       // 조회용 


end event

type p_preview from w_standard_print`p_preview within w_sal_05800
end type

type p_exit from w_standard_print`p_exit within w_sal_05800
end type

type p_print from w_standard_print`p_print within w_sal_05800
end type

event p_print::clicked;gi_page = 1
	
CHOOSE CASE tab_1.selectedtab
	CASE 1
		If tab_1.tabpage_1.dw_list_tab1.rowcount() > 0 then
			gi_page = tab_1.tabpage_1.dw_list_tab1.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_1.dw_list_tab1)
		End If
	CASE 2
		IF tab_1.tabpage_2.dw_list_tab2.rowcount() > 0 then
			gi_page = tab_1.tabpage_2.dw_list_tab2.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_2.dw_list_tab2)
		End If
	CASE 3
		IF tab_1.tabpage_3.dw_list_tab3.rowcount() > 0 then
			gi_page = tab_1.tabpage_3.dw_list_tab3.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_3.dw_list_tab3)
		End If
	CASE 4
		IF tab_1.tabpage_4.dw_list_tab4.rowcount() > 0 then
			gi_page = tab_1.tabpage_4.dw_list_tab4.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_4.dw_list_tab4)
		End If
END CHOOSE

end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_05800
end type







type st_10 from w_standard_print`st_10 within w_sal_05800
end type



type dw_print from w_standard_print`dw_print within w_sal_05800
string dataobject = "d_sal_05800_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05800
integer x = 37
integer y = 24
integer width = 1573
integer height = 132
string dataobject = "d_sal_05800_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

IF dwo.name ="itcls" THEN
	OPEN(w_itemas_popup2)
	
   dw_ip.SetItem(1,"itcls",gs_code)
	dw_ip.SetItem(1,"itclsnm",gs_codename)
End If

end event

event dw_ip::itemchanged;string itclsnm,itcls,s_itnbr, s_itdsc, s_ispec

If dwo.Name = 'itcls' then
	s_itnbr = trim(data)
   
	f_get_name2('품번', 'N', s_itnbr, s_itdsc, s_ispec)
	
	this.setitem(1, "itclsnm", s_itdsc)	

End If	
end event

type dw_list from w_standard_print`dw_list within w_sal_05800
boolean visible = false
integer x = 1861
integer y = 1044
integer width = 466
integer height = 280
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_05800
integer x = 46
integer y = 220
integer width = 4562
integer height = 2044
integer taborder = 30
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
alignment alignment = right!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4526
integer height = 1932
long backcolor = 32106727
string text = "관할구역별(월)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab1 dw_list_tab1
end type

on tabpage_1.create
this.dw_list_tab1=create dw_list_tab1
this.Control[]={this.dw_list_tab1}
end on

on tabpage_1.destroy
destroy(this.dw_list_tab1)
end on

type dw_list_tab1 from datawindow within tabpage_1
event u_key pbm_dwnkey
integer width = 4530
integer height = 1952
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05800"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4526
integer height = 1932
long backcolor = 32106727
string text = "관할구역별(분기)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab2 dw_list_tab2
end type

on tabpage_2.create
this.dw_list_tab2=create dw_list_tab2
this.Control[]={this.dw_list_tab2}
end on

on tabpage_2.destroy
destroy(this.dw_list_tab2)
end on

type dw_list_tab2 from datawindow within tabpage_2
event u_key pbm_dwnkey
integer width = 4530
integer height = 1932
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05810"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4526
integer height = 1932
long backcolor = 32106727
string text = "영업팀별(월)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab3 dw_list_tab3
end type

on tabpage_3.create
this.dw_list_tab3=create dw_list_tab3
this.Control[]={this.dw_list_tab3}
end on

on tabpage_3.destroy
destroy(this.dw_list_tab3)
end on

type dw_list_tab3 from datawindow within tabpage_3
event u_key pbm_dwnkey
integer width = 4526
integer height = 1932
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05820"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4526
integer height = 1932
long backcolor = 32106727
string text = "영업팀별(분기)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab4 dw_list_tab4
end type

on tabpage_4.create
this.dw_list_tab4=create dw_list_tab4
this.Control[]={this.dw_list_tab4}
end on

on tabpage_4.destroy
destroy(this.dw_list_tab4)
end on

type dw_list_tab4 from datawindow within tabpage_4
event u_key pbm_dwnkey
integer width = 4526
integer height = 1932
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05830"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

