$PBExportHeader$w_sal_05685.srw
$PBExportComments$년도별 월별 판매수량 현황
forward
global type w_sal_05685 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05685
end type
end forward

global type w_sal_05685 from w_standard_print
integer height = 2452
string title = "년도별 월별 판매수량 현황"
rr_1 rr_1
end type
global w_sal_05685 w_sal_05685

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIttyp, sItcls, tx_name
String sFRom, sTo,sMsg, sModString
Long   ix, iy, iz, nRow
Double dAmt[13]

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls      = Trim(dw_ip.GetItemString(1,"itcls"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If Isnull(sIttyp) Then sIttyp = ''
If Isnull(sItcls) Then sItcls = ''

SetPointer(HourGlass!)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

IF dw_print.Retrieve(gs_sabu, sFrom+'01', sTo+'12', sIttyp+'%',sItcls+'%',ls_silgu) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
else
	dw_print.sharedata(dw_list)
END IF

/* 합계 계산 */
For ix = Long(sFrom) To Long(sTo)
	dAmt = { 0,0,0,0,0,0,0,0,0,0,0,0,0 }	
	
	/* 년도별 합계 */
	For iz = 1 To dw_print.RowCount()
		If String(ix) = dw_print.GetItemString(iz,'year') Then
			For iy = 1 To 13
				dAmt[iy] += dw_print.GetItemNumber(iz, 'qty'+string(iy))
			Next
		End If
	Next
	
	nRow = dw_print.InsertRow(0)
	dw_print.SetItem(nRow,'titnm','합  계')
	dw_print.SetItem(nRow,'year', String(ix))
	
	For iy = 1 To 13
		dw_print.SetItem(nRow,'qty'+String(iy), dAmt[iy])	
	Next
Next

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_itcls.text = '"+tx_name+"'")

dw_print.GroupCalc()
Return 1
end function

on w_sal_05685.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05685.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", Left(is_today,4))
dw_ip.SetItem(1,"sdatet", Left(is_today,4))

end event

type p_preview from w_standard_print`p_preview within w_sal_05685
end type

type p_exit from w_standard_print`p_exit within w_sal_05685
end type

type p_print from w_standard_print`p_print within w_sal_05685
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05685
end type











type dw_print from w_standard_print`dw_print within w_sal_05685
string dataobject = "d_sal_056851_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05685
integer x = 27
integer y = 24
integer width = 3881
integer height = 160
string dataobject = "d_sal_056853"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sNull, sIttyp, sItcls,sDateFrom, sPrtgbn
String  sItemCls, sItemGbn, sItemClsName
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		
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
	/* 자료구분 */
	Case 'prtgbn'
		sPrtGbn = this.GetText()
		
		dw_list.SetRedraw(False)
		IF sPrtGbn = '0' THEN													/* 제품군 */
			dw_list.DataObject = 'd_sal_056852'
		ELSEIF sPrtGbn = '1' THEN												/* 시리즈 */
			dw_list.DataObject = 'd_sal_056851'
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.SetRedraw(True)
END Choose

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
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
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

type dw_list from w_standard_print`dw_list within w_sal_05685
integer x = 46
integer y = 200
integer width = 4535
integer height = 2108
string dataobject = "d_sal_056851"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05685
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 4562
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 55
end type

