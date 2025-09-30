$PBExportHeader$w_sal_02650.srw
$PBExportComments$반품 제품 재 검사 집계 현황
forward
global type w_sal_02650 from w_standard_print
end type
type tab_1 from tab within w_sal_02650
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
type tab_1 from tab within w_sal_02650
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_sal_02650 from w_standard_print
string title = "반품 제품 재 검사 집계 현황"
boolean maxbox = true
tab_1 tab_1
end type
global w_sal_02650 w_sal_02650

type variables
datawindow dw_select
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear,steam, sarea, scvcod, sPrtgbn,ssaupj
string   tx_name

If dw_ip.accepttext() <> 1 Then Return -1

syear  = trim(dw_ip.getitemstring(1, 'syear'))
steam  = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea  = trim(dw_ip.getitemstring(1, 'areacode'))
scvcod = trim(dw_ip.getitemstring(1, 'custcode'))
sPrtgbn = trim(dw_ip.getitemstring(1, 'prtgbn'))
ssaupj = dw_ip.getitemstring(1,"saupj")

If IsNull(steam)  or steam = '' Then steam = '%'
If IsNull(sarea)  or sarea = '' Then sarea = '%'
If IsNull(scvcod) or scvcod = '' Then scvcod = '%'

IF	f_datechk(syear+'0101') = -1 then
	MessageBox("확인","기준년도를 확인하세요!")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'

//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

dw_select.Reset()
Choose Case tab_1.SelectedTab
	Case 1
		dw_select = tab_1.tabpage_1.dw_list_tab1
	Case 2
		dw_select = tab_1.tabpage_2.dw_list_tab2
	Case 3
		dw_select = tab_1.tabpage_3.dw_list_tab3		
End Choose		
dw_select.SetTransObject(sqlca)

dw_ip.setfocus()

//messagebox('','')
If dw_select.retrieve(gs_sabu, syear, steam , sarea , sCvcod ,ssaupj ) < 1	then
	f_message_chk(50,"")
	Return -1
End If

If dw_print.retrieve(gs_sabu, syear, steam , sarea , sCvcod ,ssaupj ) > 0 Then
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
//If tx_name = '' Then tx_name = '전체'
//tab_1.tabpage_1.dw_list_tab1.Object.txt_steam.text = tx_name
	
If sPrtGbn = '1' then
Else
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
//	If tx_name = '' Then tx_name = '전체'
//	tab_1.tabpage_1.dw_list_tab1.Object.txt_sarea.text = tx_name
End If

//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

Return 1


end function

on w_sal_02650.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_02650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open;call super::ue_open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syear',syymm)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

dw_select = Create datawindow       // 조회용 

/* User별 관할구역 Setting */
String sarea, steam , saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.SetItem(1, 'deptcode', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("deptcode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//	dw_ip.Modify("deptcode.background.color = 80859087")
//End If

f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'deptcode', gs_saupj) 

//관할 구역
f_child_saupj(dw_ip, 'areacode', gs_saupj) 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 



end event

type p_preview from w_standard_print`p_preview within w_sal_02650
end type

type p_exit from w_standard_print`p_exit within w_sal_02650
end type

type p_print from w_standard_print`p_print within w_sal_02650
end type

event p_print::clicked;Choose Case tab_1.SelectedTab
	Case 1
		IF tab_1.tabpage_1.dw_list_tab1.rowcount() > 0 then 
			gi_page = tab_1.tabpage_1.dw_list_tab1.GetItemNumber(1,"last_page")
		ELSE
			gi_page = 1
		END IF
		OpenWithParm(w_print_options, tab_1.tabpage_1.dw_list_tab1)
	Case 2
		IF tab_1.tabpage_2.dw_list_tab2.rowcount() > 0 then 
			gi_page = tab_1.tabpage_2.dw_list_tab2.GetItemNumber(1,"last_page")
		ELSE
			gi_page = 1
		END IF
		OpenWithParm(w_print_options, tab_1.tabpage_2.dw_list_tab2)
	Case 3
		IF tab_1.tabpage_3.dw_list_tab3.rowcount() > 0 then 
			gi_page = tab_1.tabpage_3.dw_list_tab3.GetItemNumber(1,"last_page")
		ELSE
			gi_page = 1
		END IF
		OpenWithParm(w_print_options, tab_1.tabpage_3.dw_list_tab3)	  
End Choose	  
end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_02650
end type







type st_10 from w_standard_print`st_10 within w_sal_02650
end type



type dw_print from w_standard_print`dw_print within w_sal_02650
string dataobject = "d_sal_02650_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02650
integer x = 46
integer y = 24
integer width = 2999
integer height = 372
string dataobject = "d_sal_02650_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName()
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
END Choose

end event

event dw_ip::itemchanged;String sNull, sIocustArea, sDept, sIocust, sIoCustName , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj

SetNull(sNull)

Choose Case  GetColumnName() 
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'deptcode',sDept)
	
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 

			Return 1
		END IF

	Case 'prtgbn'
		tab_1.SetRedraw(False)
		Choose Case GetText()
			Case '1'
						tab_1.tabpage_1.dw_list_tab1.DataObject = 'd_sal_02650'
						tab_1.tabpage_2.dw_list_tab2.DataObject = 'd_sal_026501'	
						dw_print.DataObject = 'd_sal_026501_p'
			Case '2'
						tab_1.tabpage_1.dw_list_tab1.DataObject = 'd_sal_026503'
						tab_1.tabpage_2.dw_list_tab2.DataObject = 'd_sal_026504'
						dw_print.DataObject = 'd_sal_026504_p'
			Case '3'
						tab_1.tabpage_1.dw_list_tab1.DataObject = 'd_sal_026505'
						tab_1.tabpage_2.dw_list_tab2.DataObject = 'd_sal_026506'
						dw_print.DataObject = 'd_sal_026506_p'
						
      End Choose
		tab_1.tabpage_1.dw_list_tab1.SetTransObject(sqlca)
		tab_1.tabpage_2.dw_list_tab2.SetTransObject(sqlca)
		tab_1.tabpage_3.dw_list_tab3.SetTransObject(sqlca)
		dw_print.SetTransObject(sqlca)
		tab_1.SetRedraw(True)
		
		/* 버튼 초기화 */
		p_print.Enabled =False
		p_print.PictureName = 'c:\erpman\image\인쇄_d.gif'
		p_preview.enabled = False
		p_preview.PictureName ='c:\erpman\image\미리보기_d.gif'
	case 'saupj ' 
		STRING ls_return, ls_sarea , ls_steam, scode 
		//사업장
		ls_saupj = gettext() 
		//거래처
		sCode 	= this.object.custcode[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 

		//관할 구역
		f_child_saupj(dw_ip, 'areacode', ls_saupj)
		ls_sarea = dw_ip.object.areacode[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'areacode', '')
		End if 
		//영업팀
		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
		ls_steam = dw_ip.object.deptcode[1] 
		ls_return = f_saupj_chk_t('2' , ls_steam ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'deptcode', '')
		End if 

End Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02650
boolean visible = false
integer x = 1152
integer y = 1580
integer width = 466
integer height = 280
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_02650
integer x = 50
integer y = 456
integer width = 4535
integer height = 1784
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
boolean powertips = true
boolean boldselectedtext = true
alignment alignment = right!
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

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4498
integer height = 1672
long backcolor = 32106727
string text = "발생 건수별 현황"
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
integer y = 4
integer width = 4498
integer height = 1664
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_02650"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
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

event itemerror;return 1
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4498
integer height = 1672
long backcolor = 32106727
string text = "재검사 수량별 현황"
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
integer width = 4498
integer height = 1672
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_026501"
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
integer width = 4498
integer height = 1672
long backcolor = 32106727
string text = "원인별 발생건수 현황"
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
integer width = 4503
integer height = 1668
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_026502"
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

