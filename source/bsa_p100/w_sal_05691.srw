$PBExportHeader$w_sal_05691.srw
$PBExportComments$년도별 판매실적 현황(제품별)
forward
global type w_sal_05691 from w_standard_print
end type
type tab_1 from tab within w_sal_05691
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
type tab_1 from tab within w_sal_05691
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
type st_1 from statictext within w_sal_05691
end type
type ddlb_syear from dropdownlistbox within w_sal_05691
end type
type st_4 from statictext within w_sal_05691
end type
type sle_years from singlelineedit within w_sal_05691
end type
type rr_1 from roundrectangle within w_sal_05691
end type
end forward

global type w_sal_05691 from w_standard_print
string title = "년도별 판매실적 현황(제품별)"
tab_1 tab_1
st_1 st_1
ddlb_syear ddlb_syear
st_4 st_4
sle_years sle_years
rr_1 rr_1
end type
global w_sal_05691 w_sal_05691

type variables
datawindow dw_select
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear[5]            // 5개년으로 제한
string   frmm,tomm,steam,sarea,cvcod,pdtgu,itcls,itclsnm
string   tx_steam,tx_sarea,tx_cvcod,tx_pdtgu,tx_itcls,stemp
int      rtn,ix,ii
String   sMod[], sPrtGbn
String   sItnbr, tx_itnbr

If dw_ip.accepttext() <> 1 Then Return -1

syear[1] = Trim(ddlb_syear.Text)
steam    = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea    = trim(dw_ip.getitemstring(1, 'areacode'))
cvcod    = trim(dw_ip.getitemstring(1, 'custcode'))
pdtgu    = trim(dw_ip.getitemstring(1, 'pdtgu'))
itcls    = trim(dw_ip.getitemstring(1, 'itcls'))
sItnbr   = trim(dw_ip.getitemstring(1, 'itnbr'))
sPrtGbn  = trim(dw_ip.getitemstring(1, 'prtgbn'))
stemp    = Trim(sle_years.Text)

For ix = 2 To 5
   ii = Pos(stemp,',')
	If Len(stemp) = 0 Then Exit
	
	If ii > 0 Then 
		syear[ix] = Left(stemp,ii - 1 )
	   stemp = Mid(stemp,ii+1)
   Else		
      ix = 5		
		syear[ix] = stemp
	End If	

   IF	f_datechk(syear[ix]+'0101') = -1 then
      f_message_chk(42,"비교년도 : YYYY")
      sle_years.setfocus()
      REturn -1
   END IF
Next

If IsNull(steam)  Then steam = ''
If IsNull(sarea)  Then sarea = ''
If IsNull(cvcod)  Then cvcod = ''
If IsNull(pdtgu)  Then pdtgu = ''
If IsNull(itcls)  Then itcls = ''
If IsNull(sItnbr)  Then sItnbr = ''

IF	f_datechk(syear[1]+'0101') = -1 then
	MessageBox("확인","기준년도를 확인하세요!")
	ddlb_syear.setfocus()
	Return -1
END IF

////////////////////////////////// dw 선택및 트랜젝션 연결
Choose Case tab_1.SelectedTab
	Case 1
		dw_select = tab_1.tabpage_1.dw_list_tab1
	   dw_print.DataObject = "d_sal_05691_p"
   Case 2
		dw_select = tab_1.tabpage_2.dw_list_tab2
	   dw_print.DataObject = "d_sal_05692_p"
   Case 3
		dw_select = tab_1.tabpage_4.dw_list_tab4
	   dw_print.DataObject = "d_sal_0569201_p" 
   Case 4
		dw_select = tab_1.tabpage_3.dw_list_tab3
      dw_print.DataObject = "d_sal_05693_p"   
End Choose		
dw_select.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

/* 성장율 기준 */
If sPrtGbn = '1' Then // 금액
	sMod[1] = 'if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt1 [0] /  sales_amt1 [-1],0)'
	sMod[2] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt2 [0] /  sales_amt2 [-1],0)"
	sMod[3] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt3 [0] /  sales_amt3 [-1],0)"
	sMod[4] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt4 [0] /  sales_amt4 [-1],0)"
	sMod[5] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt5 [0] /  sales_amt5 [-1],0)"
	sMod[6] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt6 [0] /  sales_amt6 [-1],0)"
	sMod[7] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt7 [0] /  sales_amt7 [-1],0)"
	sMod[8] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt8 [0] /  sales_amt8 [-1],0)"
	sMod[9] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt9 [0] /  sales_amt9 [-1],0)"
	sMod[10] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt10 [0] /  sales_amt10 [-1],0)"
	sMod[11] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt11 [0] /  sales_amt11 [-1],0)"
	sMod[12] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt12 [0] /  sales_amt12 [-1],0)"
	sMod[13] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_amt13 [0] /  sales_amt13 [-1],0)"
Else
	sMod[1] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty1 [0] /  sales_qty1 [-1],0)"
	sMod[2] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty2 [0] /  sales_qty2 [-1],0)"
	sMod[3] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty3 [0] /  sales_qty3 [-1],0)"
	sMod[4] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty4 [0] /  sales_qty4 [-1],0)"
	sMod[5] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty5 [0] /  sales_qty5 [-1],0)"
	sMod[6] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty6 [0] /  sales_qty6 [-1],0)"
	sMod[7] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty7 [0] /  sales_qty7 [-1],0)"
	sMod[8] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty8 [0] /  sales_qty8 [-1],0)"
	sMod[9] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty9 [0] /  sales_qty9 [-1],0)"
	sMod[10] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty10 [0] /  sales_qty10 [-1],0)"
	sMod[11] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty11 [0] /  sales_qty11 [-1],0)"
	sMod[12] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty12 [0] /  sales_qty12 [-1],0)"
	sMod[13] = "if(gb[0] = gb[-1] and itdsc[0] = itdsc[-1], sales_qty13 [0] /  sales_qty13 [-1],0)"
End If
	
For ix = 1 To 13
	dw_select.Modify("rate"+string(ix)+".Expression='" + sMod[ix] + "'" )
Next

dw_print.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

Choose Case tab_1.SelectedTab
	Case 1
		rtn = dw_print.retrieve(gs_sabu, syear[1],syear[2],syear[3],syear[4],syear[5],&
		                         steam+'%',sarea+'%',cvcod+'%',pdtgu+'%','%',ls_silgu)
	Case 2
		rtn = dw_print.retrieve(gs_sabu, syear[1],syear[2],syear[3],syear[4],syear[5],&
		                         steam+'%',sarea+'%',cvcod+'%',pdtgu+'%',itcls+'%',ls_silgu)
   Case 3
		rtn = dw_print.retrieve(gs_sabu, syear[1],syear[2],syear[3],syear[4],syear[5],&
		                         steam+'%',sarea+'%',cvcod+'%',pdtgu+'%',itcls+'%',ls_silgu)
	Case 4
		rtn = dw_print.retrieve(gs_sabu, syear[1],syear[2],syear[3],syear[4],syear[5],&
		                         steam+'%',sarea+'%',cvcod+'%',pdtgu+'%',itcls+'%', sItnbr+'%',ls_silgu)
End Choose		

if rtn < 1	then
	f_message_chk(50,"")
	ddlb_syear.setfocus()
	dw_print.SetRedraw(True)
	return -1
end if

 dw_print.sharedata(dw_select)
 
// title 년월 설정
tx_steam = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
tx_sarea = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
tx_cvcod  = trim(dw_ip.getitemstring(1, 'custname'))
tx_itcls  = trim(dw_ip.getitemstring(1, 'itclsnm'))
tx_itnbr  = trim(dw_ip.getitemstring(1, 'itdsc'))

If tx_steam = '' Then tx_steam = '전체'
If tx_sarea = '' Then tx_sarea = '전체'
If tx_pdtgu = '' Then tx_pdtgu = '전체'
If IsNull(tx_cvcod) Or tx_cvcod = '' Then tx_cvcod = '전체'
If IsNull(tx_itcls) Or tx_itcls = '' Then tx_itcls = '전체'
If IsNull(tx_itnbr) Or tx_itnbr = '' Then tx_itnbr = '전체'

dw_print.Object.tx_steam.text = tx_steam
dw_print.Object.tx_sarea.text = tx_sarea
dw_print.Object.tx_cvcod.text = tx_cvcod
dw_print.Object.tx_pdtgu.text = tx_pdtgu
dw_print.Object.tx_itcls.text = tx_itcls

If tab_1.SelectedTab = 4 Then
	dw_print.Object.tx_itnbr.text = tx_itnbr
End If

If sPrtGbn = '1' Then
	dw_print.Object.txt_rate.text = '성장율기준 : 금액'
Else
	dw_print.Object.txt_rate.text = '성장율기준 : 수량'
End If

dw_print.SetRedraw(True)

Return 1
end function

on w_sal_05691.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.st_1=create st_1
this.ddlb_syear=create ddlb_syear
this.st_4=create st_4
this.sle_years=create sle_years
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_syear
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.sle_years
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_05691.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.st_1)
destroy(this.ddlb_syear)
destroy(this.st_4)
destroy(this.sle_years)
destroy(this.rr_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
ddlb_syear.Text = syymm


dw_select = Create datawindow       // 조회용 


end event

type p_preview from w_standard_print`p_preview within w_sal_05691
integer taborder = 20
string picturename = "c:\erpman\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_05691
integer taborder = 70
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_05691
integer taborder = 30
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

type p_retrieve from w_standard_print`p_retrieve within w_sal_05691
integer taborder = 10
string picturename = "c:\erpman\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_05691
end type



type dw_print from w_standard_print`dw_print within w_sal_05691
string dataobject = "d_sal_05691_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05691
integer x = 64
integer y = 20
integer width = 3392
integer height = 288
integer taborder = 90
string dataobject = "d_sal_05691_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sIttyp
long nRow
string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
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
		If IsNull(sItemGbn) Or sItemGbn = '' then sItemGbn = '1'
		
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
			If IsNull(sItemGbn) Or sItemGbn = '' then sItemGbn = '1'
			
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

type dw_list from w_standard_print`dw_list within w_sal_05691
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

type tab_1 from tab within w_sal_05691
integer x = 82
integer y = 424
integer width = 4507
integer height = 1872
integer taborder = 40
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
		dw_ip.Modify('itcls.protect = 1')
		dw_ip.Modify('itnbr.protect = 1')
		dw_ip.Modify('itdsc.protect = 1')
		dw_ip.Modify('ispec.protect = 1')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(192,192,192))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(192,192,192))+"'")
	Case 2
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify('itnbr.protect = 0')
		dw_ip.Modify('itdsc.protect = 0')
		dw_ip.Modify('ispec.protect = 0')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(255,255,255))+"'")
	Case 3
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify('itnbr.protect = 0')
		dw_ip.Modify('itdsc.protect = 0')
		dw_ip.Modify('ispec.protect = 0')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(255,255,255))+"'")
	Case 4 
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify('itnbr.protect = 0')
		dw_ip.Modify('itdsc.protect = 0')
		dw_ip.Modify('ispec.protect = 0')
//		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itnbr.background.color = '"+String(Rgb(255,255,0))+"'")
//		dw_ip.Modify("itdsc.background.color = '"+String(Rgb(255,255,255))+"'")
//		dw_ip.Modify("ispec.background.color = '"+String(Rgb(255,255,255))+"'")
End Choose		

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4471
integer height = 1760
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
integer width = 4471
integer height = 1764
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05691"
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
integer width = 4471
integer height = 1760
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
integer width = 4471
integer height = 1676
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05692"
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
integer width = 4471
integer height = 1760
long backcolor = 32106727
string text = "소분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
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
integer width = 4466
integer height = 1672
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_0569201"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4471
integer height = 1760
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
integer width = 4471
integer height = 1676
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05693"
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

type st_1 from statictext within w_sal_05691
integer x = 64
integer y = 328
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "* 기준년도"
boolean focusrectangle = false
end type

type ddlb_syear from dropdownlistbox within w_sal_05691
integer x = 384
integer y = 320
integer width = 370
integer height = 852
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean allowedit = true
boolean vscrollbar = true
string item[] = {"1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_sal_05691
integer x = 786
integer y = 328
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "비교년도"
boolean focusrectangle = false
end type

type sle_years from singlelineedit within w_sal_05691
integer x = 1070
integer y = 320
integer width = 663
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event getfocus;sle_msg.Text = '비교년도는 콤마(,) 구분자로 4개까지 입력가능합니다.!!'
end event

type rr_1 from roundrectangle within w_sal_05691
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 412
integer width = 4544
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

