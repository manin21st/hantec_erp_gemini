$PBExportHeader$w_sal_04530.srw
$PBExportComments$ ===>수금 총 회전일 현황
forward
global type w_sal_04530 from w_standard_print
end type
type tab_1 from tab within w_sal_04530
end type
type tabpage_4 from userobject within tab_1
end type
type dw_list_tab4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_list_tab4 dw_list_tab4
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
type tab_1 from tab within w_sal_04530
tabpage_4 tabpage_4
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type rr_1 from roundrectangle within w_sal_04530
end type
end forward

global type w_sal_04530 from w_standard_print
string title = "총회전일 현황"
tab_1 tab_1
rr_1 rr_1
end type
global w_sal_04530 w_sal_04530

type variables
datawindow dw_select
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_syear,s_pyear, s_steam,s_sarea, s_cvcod, sPrtGbn,sMagam, sMisugu
int      rtn,ix,ii

////////////////////////////////////////////// 검색조건 check
If dw_ip.accepttext() <> 1 Then Return -1

s_syear   = trim(dw_ip.getitemstring(1, 'syear'))
s_steam   = trim(dw_ip.getitemstring(1, 'steam'))
s_sarea   = trim(dw_ip.getitemstring(1, 'sarea'))
s_cvcod   = trim(dw_ip.getitemstring(1, 'cvcod'))
sPrtGbn   = trim(dw_ip.getitemstring(1, 'prtgbn'))
sMisugu   = trim(dw_ip.getitemstring(1, 'misugu'))

If IsNull(s_syear)  Then s_syear = ''
If IsNull(s_sarea)  Then s_sarea = ''
If IsNull(s_steam)  Then s_steam = ''
If IsNull(s_cvcod)  Then s_cvcod = ''

IF	f_datechk(s_syear+'0101') = -1 then
	MessageBox("확인","기준년도를 확인하세요!")
	dw_ip.SetFocus()
	dw_ip.SetColumn('syear')
	Return -1
END IF

s_pyear = String(Integer(s_syear)-1,'0000')

////////////////////////////////// dw 선택및 트랜젝션 연결
Choose Case tab_1.SelectedTab
	Case 1
		dw_select = tab_1.tabpage_4.dw_list_tab4
	Case 2
		dw_select = tab_1.tabpage_1.dw_list_tab1
	Case 3
		dw_select = tab_1.tabpage_2.dw_list_tab2
	Case 4
		dw_select = tab_1.tabpage_3.dw_list_tab3
End Choose		
dw_select.SetTransObject(sqlca)
//////////////////////////////////////////////////////////////
dw_select.SetRedraw(False)

dw_select.SetFilter('')
dw_select.Filter()

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

Choose Case tab_1.SelectedTab
	Case 1
		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, sMisugu,ls_silgu) // 전체
		dw_print.retrieve(gs_sabu, s_pyear, s_syear, sMisugu,ls_silgu)
	Case 2
		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', sMisugu,ls_silgu) // 영업팀별
		dw_print.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', sMisugu,ls_silgu)
	Case 3
		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', s_sarea+'%', sMisugu,ls_silgu) //관할구역
		dw_print.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', s_sarea+'%', sMisugu,ls_silgu)
	Case 4
		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', s_sarea+'%', s_cvcod+'%', sMisugu,ls_silgu) //거래처
		dw_print.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', s_sarea+'%', s_cvcod+'%', sMisugu,ls_silgu)
End Choose

If rtn < 1	then
	f_message_chk(50,"")
	dw_select.SetRedraw(True)
	return -1
end if

/* 거래처일 경우 */
If tab_1.SelectedTab = 4 and sPrtGbn = 'Y' Then
	dw_select.SetFilter("outgu = '1' or outgu = '2'")
	dw_print.SetFilter("outgu = '1' or outgu = '2'")
Else
	dw_select.SetFilter("")
	dw_print.SetFilter("")
End If
dw_select.Filter()	
dw_print.Filter()	

/* 최종마감년월 확인 */
  SELECT MAX("JUNPYO_CLOSING"."JPDAT"  )
    INTO :sMagam
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) ;

If IsNull(sMagam) Or sMagam = '' Then sMagam = ''
dw_select.Modify("txt_magam.text = '최종마감년월 : "+String(sMagam,'@@@@.@@') + "'")
dw_print.Modify("txt_magam.text = '최종마감년월 : "+String(sMagam,'@@@@.@@') + "'")

dw_select.SetRedraw(True)

Return 1

//Choose Case tab_1.SelectedTab
//	Case 1
//		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, sMisugu,ls_silgu) // 전체
//	Case 2
//		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', sMisugu,ls_silgu) // 영업팀별
//	Case 3
//		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', s_sarea+'%', sMisugu,ls_silgu) //관할구역
//	Case 4
//		rtn = dw_select.retrieve(gs_sabu, s_pyear, s_syear, s_steam+'%', s_sarea+'%', s_cvcod+'%', sMisugu,ls_silgu) //거래처
//End Choose
//
//If rtn < 1	then
//	f_message_chk(50,"")
//	dw_select.SetRedraw(True)
//	return -1
//end if
//
///* 거래처일 경우 */
//If tab_1.SelectedTab = 4 and sPrtGbn = 'Y' Then
//	dw_select.SetFilter("outgu = '1' or outgu = '2'")
//Else
//	dw_select.SetFilter("")
//End If
//dw_select.Filter()	
//
///* 최종마감년월 확인 */
//  SELECT MAX("JUNPYO_CLOSING"."JPDAT"  )
//    INTO :sMagam
//    FROM "JUNPYO_CLOSING"  
//   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//         ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) ;
//
//If IsNull(sMagam) Or sMagam = '' Then sMagam = ''
//dw_select.Modify("txt_magam.text = '최종마감년월 : "+String(sMagam,'@@@@.@@') + "'")
//
//dw_select.SetRedraw(True)
//
//Return 1
end function

on w_sal_04530.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_04530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.rr_1)
end on

event open;call super::open;string sDate

sDate = f_today()
dw_ip.SetItem(1,'syear',left(sDate,4))

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, "steam", sarea)
	dw_ip.Modify("steam.protect=1")
	dw_ip.Modify("steam.background.color = 80859087")
	
	dw_ip.SetItem(1, "sarea", sarea)
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If

dw_select = Create datawindow       // 조회용 

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

end event

type p_preview from w_standard_print`p_preview within w_sal_04530
end type

type p_exit from w_standard_print`p_exit within w_sal_04530
end type

type p_print from w_standard_print`p_print within w_sal_04530
end type

event p_print::clicked;CHOOSE CASE tab_1.selectedtab
	CASE 2
		IF tab_1.tabpage_1.dw_list_tab1.rowcount() > 0 then 	gi_page = tab_1.tabpage_1.dw_list_tab1.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_1.dw_list_tab1)
	CASE 3
		IF tab_1.tabpage_2.dw_list_tab2.rowcount() > 0 then 	gi_page = tab_1.tabpage_2.dw_list_tab2.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_2.dw_list_tab2)
	CASE 4
		IF tab_1.tabpage_3.dw_list_tab3.rowcount() > 0 then 	gi_page = tab_1.tabpage_3.dw_list_tab3.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_3.dw_list_tab3)
	CASE 1
		IF tab_1.tabpage_4.dw_list_tab4.rowcount() > 0 then 	gi_page = tab_1.tabpage_4.dw_list_tab4.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_4.dw_list_tab4)
END CHOOSE


end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_04530
end type







type st_10 from w_standard_print`st_10 within w_sal_04530
end type



type dw_print from w_standard_print`dw_print within w_sal_04530
string dataobject = "d_sal_045303_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04530
integer x = 69
integer y = 32
integer width = 3237
integer height = 296
integer taborder = 50
string dataobject = "d_sal_04530_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case 'prtgbn'
		dw_select.SetRedraw(False)
		If Trim(GetText()) = 'Y' Then
			dw_select.SetFilter("outgu = '1' or outgu = '2'")
		Else
			dw_select.SetFilter("")
		End If
		dw_select.Filter()
		dw_select.SetRedraw(True)
	/* 영업팀 */
	Case "steam"
		SetItem(1,"sarea",sNull)
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvnas2",sNull)
	/* 관할구역 */
	Case "sarea"
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvnas2",sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod",  sNull)
			SetItem(1, "cvnas2", snull)
			Return 1
		ELSE
			SetItem(1,"steam",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvnas2",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvnas2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvnas2", snull)
			Return 1
		ELSE
			SetItem(1,"steam",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcod", sCvcod)
			SetItem(1,"cvnas2", scvnas)
			Return 1
		END IF
End Choose
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvnas2"
		gs_gubun = '1'
		If GetColumnName() = "cvnas2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04530
boolean visible = false
integer x = 928
integer y = 2228
integer width = 585
integer height = 344
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_04530
event create ( )
event destroy ( )
integer x = 96
integer y = 364
integer width = 4480
integer height = 1936
integer taborder = 70
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
tabpage_4 tabpage_4
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_4=create tabpage_4
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_4,&
this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_4)
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;If newindex = 4 Then
	dw_ip.Object.prtgbn.visible = '1'
Else
	dw_ip.Object.prtgbn.visible = '0'
End If
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4443
integer height = 1824
long backcolor = 32106727
string text = "전체 현황"
long tabtextcolor = 33554432
long tabbackcolor = 80859087
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
integer width = 4443
integer height = 1820
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_045303"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4443
integer height = 1824
long backcolor = 32106727
string text = "영업팀별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 80859087
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
integer width = 4443
integer height = 1824
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_04530"
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

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4443
integer height = 1824
long backcolor = 32106727
string text = "관할구역별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 80859087
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
integer width = 4443
integer height = 1824
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_045301"
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

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4443
integer height = 1824
long backcolor = 32106727
string text = "거래처별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 80859087
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
integer width = 4443
integer height = 1828
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_045302"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sal_04530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 352
integer width = 4512
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

