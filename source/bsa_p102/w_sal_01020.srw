$PBExportHeader$w_sal_01020.srw
$PBExportComments$영업현황
forward
global type w_sal_01020 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01020
end type
type rr_3 from roundrectangle within w_sal_01020
end type
end forward

global type w_sal_01020 from w_standard_print
string title = "영업현황"
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_01020 w_sal_01020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear1,syear2, sCvcodf, sCvcodt, sMax, sMin, sMaxName, sMinName,ls_sarea,ls_sale_emp,tx_name, ls_saupj

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear1  = trim(dw_ip.GetItemString(1,'syymm1'))
syear2  = trim(dw_ip.GetItemString(1,'syymm2'))
sCvcodf = trim(dw_ip.GetItemString(1,'custcode1'))
sCvcodt = trim(dw_ip.GetItemString(1,'custcode2'))
ls_sarea = trim(dw_ip.GetItemString(1,'sarea'))
ls_sale_emp = trim(dw_ip.GetItemString(1,'sale_emp'))
ls_saupj = trim(dw_ip.GetItemString(1,'saupj'))

IF	f_datechk(syear1+'01') <> 1 then
	f_message_chk(1400,'[기간]')
	dw_ip.setcolumn('syymm1')
	dw_ip.setfocus()
	Return -1
END IF

IF	f_datechk(syear2+'01') <> 1 then
	f_message_chk(1400,'[기간]')
	dw_ip.setcolumn('syymm2')
	dw_ip.setfocus()
	Return -1
END IF

if ls_sarea="" or isnull(ls_sarea) then ls_sarea='%'
if ls_sale_emp="" or isnull(ls_sale_emp) then ls_sale_emp='%'
if ls_saupj="" or isnull(ls_saupj) then ls_saupj='%'

select max(cvcod), min(cvcod)
  into :sMax, :sMin
  from vndmst
 where saleyn = 'Y' and
       cvgu = '1';

If IsNull(sCvcodf) Or sCvcodf = '' Then 
	sCvcodf = sMin
	
	select cvnas2 into :sMinName
	  from vndmst
	 where cvcod = :sCvcodf;
	 
	dw_ip.SetItem(1,'custcode1', sMin)
	dw_ip.SetItem(1,'custname1', sMinName)
End If

If IsNull(sCvcodt) Or sCvcodt = '' Then 
	sCvcodt = sMax
	
	select cvnas2 into :sMaxName
	  from vndmst
	 where cvcod = :sCvcodt;
	 
	dw_ip.SetItem(1,'custcode2', sMax)
	dw_ip.SetItem(1,'custname2', sMaxName)
End If
////////////////////////////////////////////////////////////////
dw_print.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(gs_sabu, syear1, syear2, sCvcodf, sCvcodt,ls_sarea,ls_sale_emp,ls_silgu, ls_saupj) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syymm1')
	dw_ip.setfocus()
	return -1
end if

 dw_print.sharedata(dw_list)
dw_print.Object.txt_cvcodf.text = dw_ip.GetItemString(1,'custname1')
dw_print.Object.txt_cvcodt.text = dw_ip.GetItemString(1,'custname2')

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sale_emp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sale_emp.text = '"+tx_name+"'")

dw_print.SetRedraw(True)

Return 1

end function

on w_sal_01020.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_sal_01020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;string sToday

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

sToday = Left(f_today(),6)

dw_ip.SetItem(1,'syymm1', sToday)
dw_ip.SetItem(1,'syymm2', sToday)


end event

type p_preview from w_standard_print`p_preview within w_sal_01020
end type

type p_exit from w_standard_print`p_exit within w_sal_01020
end type

type p_print from w_standard_print`p_print within w_sal_01020
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01020
end type







type st_10 from w_standard_print`st_10 within w_sal_01020
end type



type dw_print from w_standard_print`dw_print within w_sal_01020
string dataobject = "d_sal_010201_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01020
integer x = 46
integer y = 52
integer width = 3479
integer height = 176
string dataobject = "d_sal_01020"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sIocust, sNull, sIoCustName

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "custcode1"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname1",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"custname1",  sIoCustName)
		END IF
	/* 거래처명 */
	Case "custname1"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode1",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2"
		  INTO :sIoCust, :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custcode1",  sIoCust)
			SetItem(1,"custname1",  sIoCustName)
			Return
		END IF
	/* 거래처 */
	Case "custcode2"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname2",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"custname2",  sIoCustName)
		END IF
	/* 거래처명 */
	Case "custname2"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode2",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2"
		  INTO :sIoCust, :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custcode2",  sIoCust)
			SetItem(1,"custname2",  sIoCustName)
			Return
		END IF
	Case 'prtgbn'
		dw_list.SetRedraw(False)
		If GetText() = '1' Then
			dw_list.DataObject = 'd_sal_010201'
			dw_print.DataObject = 'd_sal_010201_p'
		Else
			dw_list.DataObject = 'd_sal_010202'
			dw_print.DataObject = 'd_sal_010202_p'
		End If
		dw_print.SetTransObject(sqlca)
		dw_list.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
End Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode1"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode1",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"custname1",  sIoCustName)
		END IF
	/* 거래처명 */
	Case "custname1"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode1",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"custname1",  sIoCustName)
		END IF
	/* 거래처 */
	Case "custcode2"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode2",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"custname2",  sIoCustName)
		END IF
	/* 거래처명 */
	Case "custname2"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode2",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"custname2",  sIoCustName)
		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_01020
integer y = 284
integer width = 4553
string dataobject = "d_sal_010201"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 36
integer width = 3529
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 276
integer width = 4581
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

