$PBExportHeader$w_sal_05650.srw
$PBExportComments$월별 수주 대 판매현황
forward
global type w_sal_05650 from w_standard_print
end type
type tab_1 from tab within w_sal_05650
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
type tabpage_4 from userobject within tab_1
end type
type dw_list_tab4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_list_tab4 dw_list_tab4
end type
type tabpage_3 from userobject within tab_1
end type
type dw_list_tab3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_list_tab3 dw_list_tab3
end type
type tab_1 from tab within w_sal_05650
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
type rr_1 from roundrectangle within w_sal_05650
end type
end forward

global type w_sal_05650 from w_standard_print
string title = "월별 수주 대 판매현황"
tab_1 tab_1
rr_1 rr_1
end type
global w_sal_05650 w_sal_05650

type variables
datawindow dw_select
str_itnct str_sitnct
end variables

forward prototypes
public function string wf_aftermonth (string syymm, integer n)
public function integer wf_retrieve ()
end prototypes

public function string wf_aftermonth (string syymm, integer n);string stemp

stemp = f_aftermonth(syymm,n)
stemp = Mid(stemp,1,4) + '.' + Right(stemp,2)

return stemp

end function

public function integer wf_retrieve ();string	syymm, steam, sarea, sCvcod, pdtgu,itcls,itclsnm,stemp, sItnbr
string   tx_steam,tx_sarea,tx_pdtgu, tx_custname, tx_itnbr
int      rtn

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syymm   = trim(dw_ip.getitemstring(1, 'syymm'))
steam   = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea   = trim(dw_ip.getitemstring(1, 'areacode'))
pdtgu   = trim(dw_ip.getitemstring(1, 'pdtgu'))
itcls   = trim(dw_ip.getitemstring(1, 'itcls'))
itclsnm = trim(dw_ip.getitemstring(1, 'itclsnm'))
sItnbr  = trim(dw_ip.getitemstring(1, 'itnbr'))
tx_itnbr = trim(dw_ip.getitemstring(1, 'itdsc'))

sCvcod = trim(dw_ip.getitemstring(1, 'custcode'))
tx_custname = trim(dw_ip.getitemstring(1, 'custname'))

If IsNull(steam)  Then steam = ''
If IsNull(sarea)  Then sarea = ''
If IsNull(pdtgu)  Then pdtgu = ''
If IsNull(itcls)  Then itcls = ''
If IsNull(sitnbr)  Then sitnbr = ''
If IsNull(sCvcod)  Then sCvcod = ''
If IsNull(itclsnm)  Then itclsnm = '전체'
If IsNull(tx_custname)  Then tx_custname = '전체'
If IsNull(tx_itnbr)  Then tx_itnbr = '전체'

IF	f_datechk(syymm+'01') = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	Return -1
END IF

////////////////////////////////// dw 선택및 트랜젝션 연결
Choose Case tab_1.SelectedTab
	Case 1
		dw_select = tab_1.tabpage_1.dw_list_tab1
	   dw_print.dataObject = "d_sal_05650_p"             
   Case 2
		dw_select = tab_1.tabpage_2.dw_list_tab2
	   dw_print.dataObject = "d_sal_05650_02_p"              
   Case 3
		dw_select = tab_1.tabpage_4.dw_list_tab4
	   dw_print.dataObject = "d_sal_0566001_p"              
   Case 4 
		dw_select = tab_1.tabpage_3.dw_list_tab3
      dw_print.dataObject = "d_sal_05650_04_p"             
End Choose		
dw_select.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
//////////////////////////////////////////////////////////////
dw_print.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

Choose Case tab_1.SelectedTab
	Case 1
		rtn = dw_print.retrieve(gs_sabu, syymm, steam+'%', sarea+'%', sCvcod+'%',ls_silgu)
	Case 2
		rtn = dw_print.retrieve(gs_sabu, syymm, steam+'%', sarea+'%', sCvcod+'%',pdtgu+'%',itcls+'%',ls_silgu)
	Case 3
		rtn = dw_print.retrieve(gs_sabu, syymm, steam+'%', sarea+'%', sCvcod+'%',pdtgu+'%',itcls+'%',ls_silgu)
	Case 4
		rtn = dw_print.retrieve(gs_sabu, syymm, steam+'%', sarea+'%', sCvcod+'%',pdtgu+'%',itcls+'%', sItnbr+'%',ls_silgu)
End Choose		

If rtn < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('areacode')
	dw_ip.setfocus()
	dw_select.SetRedraw(True)
	return -1
end if
 
dw_print.sharedata(dw_select)

// title 년월 설정
tx_steam = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
tx_sarea = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If tx_steam = '' Then tx_steam = '전체'
If tx_sarea = '' Then tx_sarea = '전체'
If tx_pdtgu = '' Then tx_pdtgu = '전체'

dw_print.Object.tx_steam.text = tx_steam
dw_print.Object.tx_sarea.text = tx_sarea
dw_print.Object.tx_pdtgu.text = tx_pdtgu
dw_print.Object.tx_itcls.text = itclsnm
dw_print.Object.tx_cvcod.text = tx_custname

If tab_1.SelectedTab = 4 Then
	dw_print.Object.tx_itnbr.text = tx_itnbr
End If

dw_select.Object.st_m11.text = wf_aftermonth(syymm,-11)
dw_select.Object.st_m10.text = wf_aftermonth(syymm,-10)
dw_select.Object.st_m9.text = wf_aftermonth(syymm,-9)
dw_select.Object.st_m8.text = wf_aftermonth(syymm,-8)
dw_select.Object.st_m7.text = wf_aftermonth(syymm,-7)
dw_select.Object.st_m6.text = wf_aftermonth(syymm,-6)
dw_select.Object.st_m5.text = wf_aftermonth(syymm,-5)
dw_select.Object.st_m4.text = wf_aftermonth(syymm,-4)
dw_select.Object.st_m3.text = wf_aftermonth(syymm,-3)
dw_select.Object.st_m2.text = wf_aftermonth(syymm,-2)
dw_select.Object.st_m1.text = wf_aftermonth(syymm,-1)
dw_select.Object.st_m0.text = wf_aftermonth(syymm,0)

dw_print.Object.st_m11.text = wf_aftermonth(syymm,-11)
dw_print.Object.st_m10.text = wf_aftermonth(syymm,-10)
dw_print.Object.st_m9.text = wf_aftermonth(syymm,-9)
dw_print.Object.st_m8.text = wf_aftermonth(syymm,-8)
dw_print.Object.st_m7.text = wf_aftermonth(syymm,-7)
dw_print.Object.st_m6.text = wf_aftermonth(syymm,-6)
dw_print.Object.st_m5.text = wf_aftermonth(syymm,-5)
dw_print.Object.st_m4.text = wf_aftermonth(syymm,-4)
dw_print.Object.st_m3.text = wf_aftermonth(syymm,-3)
dw_print.Object.st_m2.text = wf_aftermonth(syymm,-2)
dw_print.Object.st_m1.text = wf_aftermonth(syymm,-1)
dw_print.Object.st_m0.text = wf_aftermonth(syymm,0)

dw_print.SetRedraw(True)

Return 1


end function

on w_sal_05650.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_05650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.rr_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),6)
dw_ip.SetItem(1,'syymm',syymm)
dw_select = Create datawindow       // 조회용 
end event

type p_preview from w_standard_print`p_preview within w_sal_05650
string picturename = "c:\erpman\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_05650
integer taborder = 70
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_05650
string picturename = "c:\erpman\image\인쇄_d.gif"
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
	CASE 4
		IF tab_1.tabpage_3.dw_list_tab3.rowcount() > 0 then
			gi_page = tab_1.tabpage_3.dw_list_tab3.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_3.dw_list_tab3)
		End If
	CASE 3
		IF tab_1.tabpage_4.dw_list_tab4.rowcount() > 0 then
			gi_page = tab_1.tabpage_4.dw_list_tab4.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_4.dw_list_tab4)
		End If
END CHOOSE
end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_05650
string picturename = "c:\erpman\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_05650
end type



type dw_print from w_standard_print`dw_print within w_sal_05650
string dataobject = "d_sal_05650_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05650
integer x = 59
integer y = 164
integer width = 4448
integer height = 196
string dataobject = "d_sal_05650_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sIoCustName,sIoCustArea,sDept, sPrtGbn, sIttyp
long ll_page

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	Case "itcls"
		
		if tab_1.selectedtab = 3 then
			OpenWithParm(w_ittyp_popup3, '1')
		else
			OpenWithParm(w_ittyp_popup, '1')
		end if
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	Case "itclsnm"
	   if tab_1.selectedtab = 3 then
			OpenWithParm(w_ittyp_popup3, '1')
		else
			OpenWithParm(w_ittyp_popup, '1')
		end if
		
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",   str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",   str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr",gs_code)
		SetFocus()
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
END Choose


end event

event dw_ip::itemchanged;String sNull, sIocustarea, sDept, sIocust, siocustname, sitemgbn, sittyp, sjijil, sispeccode
String sItemclsname, sPdtgu, sItemcls, sitnbr, sitcls, sitdsc, sispec

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
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
			Return
		END IF
	/* 생산팀 */
	Case "pdtgu"
		SetItem(1,'ittyp',sNull)
		SetItem(1,'itcls',sNull)
		SetItem(1,'itclsnm',sNull)
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'ispec',sNull)
	/* 품목구분 */
	Case "ittyp"
		SetItem(1,'itcls',sNull)
		SetItem(1,'itclsnm',sNull)
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'ispec',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(1,'itclsnm',sNull)
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'ispec',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM" ,"ITNCT"."PDTGU"
			  INTO :sItemClsName  , :sPdtgu
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"pdtgu",sPdtgu)
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'ispec',sNull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
			sItemGbn = GetItemString(1,"ittyp")
			IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
				SELECT "ITNCT"."ITCLS","ITNCT"."PDTGU"
				  INTO :sItemCls, :sPdtgu
				  FROM "ITNCT"  
				 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
				IF SQLCA.SQLCODE <> 0 THEN
					TriggerEvent(RButtonDown!)
					Return 2
				ELSE
					SetItem(1,"pdtgu",sPdtgu)
					SetItem(1,"itcls",sItemCls)
			END IF
		END IF
	/* 품번 */
	Case	"itnbr" 
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
				 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
		  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
		  FROM "ITEMAS","ITNCT"
		 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				 "ITEMAS"."ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(1,"pdtgu", sPdtgu)
		SetItem(1,"ittyp", sIttyp)
		SetItem(1,"itdsc", sItdsc)
		SetItem(1,"ispec", sIspec)
		SetItem(1,"itcls", sItcls)
		SetItem(1,"itclsnm", sItemClsName)
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())	
		IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(1,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(1,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetColumn("ispec")
			Return 1
		End If
End Choose

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
//		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	

end event

type dw_list from w_standard_print`dw_list within w_sal_05650
boolean visible = false
integer x = 928
integer y = 2228
integer width = 466
integer height = 280
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_05650
integer x = 78
integer y = 396
integer width = 4485
integer height = 1896
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean raggedright = true
boolean boldselectedtext = true
alignment alignment = right!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
end on

event selectionchanged;Choose Case tab_1.SelectedTab
	Case 1
		dw_ip.Modify('pdtgu.protect = 1')
		dw_ip.Modify('itcls.protect = 1')
		dw_ip.Modify('itnbr.protect = 1')
		dw_ip.Modify('itdsc.protect = 1')
		dw_ip.Modify('ispec.protect = 1')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("pdtgu.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(192,192,192))+"'")
	Case 2
		dw_ip.Modify('pdtgu.protect = 0')
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify('itnbr.protect = 1')
		dw_ip.Modify('itdsc.protect = 1')
		dw_ip.Modify('ispec.protect = 1')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("pdtgu.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(255,255,255))+"'")
	Case 3
		dw_ip.Modify('pdtgu.protect = 0')
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify('itnbr.protect = 1')
		dw_ip.Modify('itdsc.protect = 1')
		dw_ip.Modify('ispec.protect = 1')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("pdtgu.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(255,255,255))+"'")
	Case 4 
		dw_ip.Modify('pdtgu.protect = 0')
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify('itnbr.protect = 0')
		dw_ip.Modify('itdsc.protect = 0')
		dw_ip.Modify('ispec.protect = 0')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("pdtgu.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(255,255,255))+"'")
End Choose		

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4448
integer height = 1784
long backcolor = 32106727
string text = "대분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
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
integer width = 4448
integer height = 1788
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_05650"
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
integer x = 18
integer y = 96
integer width = 4448
integer height = 1784
long backcolor = 32106727
string text = "중분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
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
integer width = 4453
integer height = 1688
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_05650_02"
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
integer width = 4448
integer height = 1784
long backcolor = 32106727
string text = "소분류별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
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
integer width = 4453
integer height = 1684
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_0566001"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4448
integer height = 1784
long backcolor = 32106727
string text = "제품별 현황"
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
event u_key pbm_dwnkey
integer y = -12
integer width = 4448
integer height = 1696
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_05650_04"
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

type rr_1 from roundrectangle within w_sal_05650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 384
integer width = 4517
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

