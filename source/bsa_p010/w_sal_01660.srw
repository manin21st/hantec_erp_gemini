$PBExportHeader$w_sal_01660.srw
$PBExportComments$계획대비 판매수량 현황
forward
global type w_sal_01660 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01660
end type
end forward

global type w_sal_01660 from w_standard_print
string title = "계획대비 주문수량 현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_sal_01660 w_sal_01660

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdatef, sDateT, sDate6, sDate3, sPdtGu, sIttyp, sItcls, sItgu
String sItnbr, tx_name, sDate, sPrtGbn
//messagebox('','')
If dw_ip.AcceptText() <> 1 Then Return -1

sDate     = Trim(dw_ip.GetItemString(1,"sdatef"))
sPdtGu    = Trim(dw_ip.GetItemString(1,"pdtgu"))
sIttyp    = Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls    = Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr    = Trim(dw_ip.GetItemString(1,"itnbr"))
sPrtgbn   = Trim(dw_ip.GetItemString(1,"prtgbn"))
sItgu	    = Trim(dw_ip.GetItemString(1,"itgu"))

If Isnull(sPdtGu) Then sPdtGu = ''
If Isnull(sIttyp) Then sIttyp = ''
If Isnull(sItcls) Then sItcls = ''
If Isnull(sItnbr) Then sItnbr = ''

IF sDate = "" OR IsNull(sDate) Or f_datechk(sDate+'01') <> 1 THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

select to_char(add_months(to_date(:sdate,'yyyymm'),-6),'yyyymm'),
       to_char(add_months(to_date(:sdate,'yyyymm'),-4),'yyyymm'),
       to_char(add_months(to_date(:sdate,'yyyymm'),-3),'yyyymm'),
		 to_char(add_months(to_date(:sdate,'yyyymm'),-1),'yyyymm')
  into :sDate6, :sDatef, :sDate3, :sdateT
  from dual;

/* 자료구분 */
Choose Case sPrtGbn
	Case '2'
		dw_print.SetFilter("sales_qty > plan_qty")
	Case Else
		dw_print.SetFilter("")
End Choose
dw_print.Filter()

IF dw_print.Retrieve(gs_sabu, sDate, sDate6, sDate3, sPdtGu+'%',sIttyp+'%',sItcls+'%',sItnbr+'%', sItgu) <= 0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('pdtgu')
	dw_ip.SetFocus()
	Return -1
End If

dw_print.ShareData(dw_list)
			
//IF dw_list.Retrieve(gs_sabu, sDate, sDate6, sDate3, sPdtGu+'%',sIttyp+'%',sItcls+'%',sItnbr+'%', sItgu) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('pdtgu')
//	dw_ip.SetFocus()
//	Return -1
//END IF

//If sPrtGbn = '2' Then
//	dw_list.Modify("prtgbn_t.text = '수주 > 계획'")
//Else
//	dw_list.Modify("prtgbn_t.text = '전체'")
//End If
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_pdtgu.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_ittyp.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_itcls.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_itdsc.text = '"+tx_name+"'")
//
//dw_list.Modify("tx_sdatef.text = '"+string(sdate,'@@@@.@@')+"'")

If sPrtGbn = '2' Then
	dw_print.Modify("prtgbn_t.text = '수주 > 계획'")
Else
	dw_print.Modify("prtgbn_t.text = '전체'")
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_itcls.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_itdsc.text = '"+tx_name+"'")

dw_print.Modify("tx_sdatef.text = '"+string(sdate,'@@@@.@@')+"'")

Return 1
end function

on w_sal_01660.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,"sdatef", Left(is_today,6))
//dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.Setfocus()
 
dw_ip.reset() 
dw_ip.insertrow(0)

end event

type p_preview from w_standard_print`p_preview within w_sal_01660
end type

type p_exit from w_standard_print`p_exit within w_sal_01660
end type

type p_print from w_standard_print`p_print within w_sal_01660
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01660
end type

event p_retrieve::clicked;call super::clicked;//
end event











type dw_print from w_standard_print`dw_print within w_sal_01660
string dataobject = "d_sal_01660_P"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01660
integer x = 46
integer y = 24
integer width = 3017
integer height = 452
string dataobject = "d_sal_01660_01"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sNull,sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sJijil, sIspeccode
String  sItemCls, sItemGbn, sItemClsName
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	/* 생산팀 */
	Case "pdtgu"
		SetItem(nRow,'ittyp',sNull)
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
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
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
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
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
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
		
		SetItem(nRow,"pdtgu", sPdtgu)
		SetItem(nRow,"ittyp", sIttyp)
		SetItem(nRow,"itdsc", sItdsc)
		SetItem(nRow,"ispec", sIspec)
		SetItem(nRow,"itcls", sItcls)
		SetItem(nRow,"itclsnm", sItemClsName)
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())	
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
		sIspec = trim(GetText())	
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
		/* 자료구분 */
		Choose Case GetText()
			Case '2'
				dw_list.SetFilter("sales_qty > plan_qty")
				dw_list.Modify("prtgbn_t.text = '수주 > 계획'")
			Case Else
				dw_list.SetFilter("")
				dw_list.Modify("prtgbn_t.text = '전체'")
		End Choose
		dw_list.Filter()
END Choose

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",   str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",   str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr",gs_code)
		SetFocus()
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
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

type dw_list from w_standard_print`dw_list within w_sal_01660
integer x = 59
integer y = 504
integer width = 4521
integer height = 1812
string dataobject = "d_sal_01660"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_01660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 500
integer width = 4553
integer height = 1828
integer cornerheight = 40
integer cornerwidth = 55
end type

