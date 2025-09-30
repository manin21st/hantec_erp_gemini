$PBExportHeader$w_sal_05730.srw
$PBExportComments$거래처별 판매순위 현황
forward
global type w_sal_05730 from w_standard_print
end type
type tab_1 from tab within w_sal_05730
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
type tab_1 from tab within w_sal_05730
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_sal_05730 from w_standard_print
string title = "거래처별 판매순위 현황"
tab_1 tab_1
end type
global w_sal_05730 w_sal_05730

type variables
datawindow dw_select
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,txt_name, sIttyp, sItcls, sItnbr, sPrtGbn, sCvgu
Long   ix, nRtn

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls      = Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
sPrtGbn     = Trim(dw_ip.GetItemString(1,"prtgbn"))
sCvgu       = Trim(dw_ip.GetItemString(1,"cvgu"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[수불기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[수불기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = ''
IF sItcls = "" OR IsNull(sItcls) THEN sItcls = ''
IF sItnbr = "" OR IsNull(sItnbr) THEN sItnbr = ''
IF sCvgu  = "0" OR IsNull(sCvgu) THEN sCvgu = ''

//////////////////////////////////// dw 선택및 트랜젝션 연결
Choose Case tab_1.SelectedTab
	Case 1
		dw_select = tab_1.tabpage_1.dw_list_tab1
	   dw_print.dataObject="d_sal_05730_03_p"
   Case 2
		dw_select = tab_1.tabpage_2.dw_list_tab2
	   dw_print.dataObject="d_sal_05730_02_p"
   Case 3
		dw_select = tab_1.tabpage_3.dw_list_tab3		
      dw_print.dataObject="d_sal_05730_01_p"   
End Choose		
dw_select.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

dw_print.SetRedraw(False)
Choose Case tab_1.SelectedTab
	Case 1,2
		nRtn = dw_print.retrieve(gs_sabu,sIttyp+'%',sItcls+'%',sItnbr+'%',sFrom,sTo)
	Case 3
		nRtn = dw_print.retrieve(gs_sabu,sIttyp+'%',sItcls+'%',sItnbr+'%',sFrom,sTo, sCvgu+'%')
End Choose

If nRtn < 1 Then
	f_message_chk(50,"")
	dw_print.SetRedraw(True)
	Return -1
End If

dw_print.sharedata(dw_select)

/* 순위 결정 */
If sPrtGbn = '1' Then
	dw_print.SetSort('qty D')
	dw_print.Sort()
Else
	dw_print.SetSort('amt D')
	dw_print.Sort()
End If

For ix = 1 To dw_print.RowCount()
	dw_print.SetItem(ix,'rank',ix)
Next

// title 년월 설정
txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_print.Object.txt_ittyp.text = txt_name

txt_name = Trim(dw_ip.GetItemSTring(1,'itclsnm'))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_print.Object.txt_itcls.text = txt_name

txt_name = Trim(dw_ip.GetItemSTring(1,'itdsc'))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_print.Object.txt_itnbr.text = txt_name

dw_print.SetRedraw(True)

Return 1
end function

on w_sal_05730.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_05730.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)

dw_ip.setitem(1,'sdatef',left(f_today(),6)+ '01')
dw_ip.setitem(1,'sdatet',left(f_today(),8))
dw_select = Create datawindow       // 조회용 


end event

type p_preview from w_standard_print`p_preview within w_sal_05730
end type

type p_exit from w_standard_print`p_exit within w_sal_05730
end type

type p_print from w_standard_print`p_print within w_sal_05730
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
END CHOOSE

end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_05730
end type







type st_10 from w_standard_print`st_10 within w_sal_05730
end type



type dw_print from w_standard_print`dw_print within w_sal_05730
string dataobject = "d_sal_05730_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05730
integer x = 23
integer y = 24
integer width = 3858
integer height = 416
integer taborder = 70
string dataobject = "d_sal_05730_04"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
  Case "itcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
/* ---------------------------------------- */
  Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)
END Choose
end event

event dw_ip::itemchanged;String  sDateFrom , sDateTo, sPrtGbn, sjijil, sispeccode
string  s_name,sIttyp,sItcls,get_nm,sItclsNm, sNull
String  sItemCls, sItemGbn, sItemClsName, sitnbr, sItdsc, sIspec, sPrtGb
Long    nRow, ix

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom+'01') = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo+'01') = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 this.TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 this.SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* 품번 */
	  Case	"itnbr" 
		 sItnbr = Trim(this.GetText())
		 IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		
		 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM"
			INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName
			FROM "ITEMAS","ITNCT"
		  WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				  "ITEMAS"."ITNBR" = :sItnbr AND
				  "ITEMAS"."USEYN" = '0' ;
	
		 IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		 END IF
		
		 SetItem(nRow,"ittyp", sIttyp)
		 SetItem(nRow,"itdsc", sItdsc)
		 SetItem(nRow,"ispec", sIspec)
		 SetItem(nRow,"itcls", sItcls)
		 SetItem(nRow,"itclsnm", sItemClsName)
	/* 품명 */
	 Case "itdsc"
		 sItdsc = trim(this.GetText())	
		 IF sItdsc ="" OR IsNull(sItdsc) THEN
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
			 SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		 
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		 If IsNull(sItnbr ) Then
			 Return 1
		 ElseIf sItnbr <> '' Then
			 SetItem(nRow,"itnbr",sItnbr)
			 SetColumn("itnbr")
			 SetFocus()
			 TriggerEvent(ItemChanged!)
			 Return 1
		 ELSE
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
			 SetItem(nRow,'ispec',sNull)
			 SetColumn("itdsc")
			 Return 1
		End If	
	/* 규격 */
	Case "ispec"
		sIspec = trim(this.GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
	
	  /* 규격으로 품번찾기 */
	  f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("ispec")
			Return 1
	  End If
	Case 'prtgbn'
		sPrtGbn = Trim(GetText())
		/* 순위 결정 */
		If sPrtGbn = '1' Then
			dw_select.SetSort('qty D')
			dw_select.Sort()
		Else
			dw_select.SetSort('amt D')
			dw_select.Sort()
		End If
		
		For ix = 1 To dw_select.RowCount()
			dw_select.SetItem(ix,'rank',ix)
		Next
END Choose
end event

event dw_ip::ue_key;call super::ue_key;string sCol

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3)
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	

end event

type dw_list from w_standard_print`dw_list within w_sal_05730
boolean visible = false
integer x = 1056
integer y = 1532
integer width = 585
integer height = 344
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_05730
integer x = 78
integer y = 464
integer width = 2990
integer height = 1856
integer taborder = 60
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

event selectionchanged;If newindex = 3 Then
//	dw_ip.Object.gb_cvgu.visible = 1
//	dw_ip.Object.cvgu.visible = 1
Else
//	dw_ip.Object.gb_cvgu.visible = 0
	dw_ip.Object.cvgu.visible = 0
End If
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2953
integer height = 1744
long backcolor = 32106727
string text = "영업팀별 현황"
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
integer width = 2789
integer height = 1936
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05730_03"
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
integer width = 2953
integer height = 1744
long backcolor = 32106727
string text = "관할구역별 현황"
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
integer width = 2789
integer height = 1748
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05730_02"
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
integer width = 2953
integer height = 1744
long backcolor = 32106727
string text = "거래처별 현황"
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
integer width = 2789
integer height = 1936
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05730_01"
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

