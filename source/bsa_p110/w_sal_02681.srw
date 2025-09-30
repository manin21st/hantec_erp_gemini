$PBExportHeader$w_sal_02681.srw
$PBExportComments$단가이력 현황
forward
global type w_sal_02681 from w_standard_print
end type
end forward

global type w_sal_02681 from w_standard_print
string title = "단가이력현황"
end type
global w_sal_02681 w_sal_02681

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,txt_name, sIttyp, sItcls, sItnbr
Long   ix, nRtn

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls      = Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[매출기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[매출기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = ''
IF sItcls = "" OR IsNull(sItcls) THEN sItcls = ''
IF sItnbr = "" OR IsNull(sItnbr) THEN sItnbr = ''

If dw_list.retrieve(gs_sabu, sFrom, sTo, sIttyp+'%',sItcls+'%',sItnbr+'%') < 1 Then
	f_message_chk(50,"")
	dw_list.SetRedraw(True)
	Return -1
End If

// title 년월 설정
txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_ittyp.text = txt_name

txt_name = Trim(dw_ip.GetItemSTring(1,'itclsnm'))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_itcls.text = txt_name

txt_name = Trim(dw_ip.GetItemSTring(1,'itdsc'))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_itnbr.text = txt_name

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_02681.create
call super::create
end on

on w_sal_02681.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1,'sdatef',left(f_today(),6) +'01')
dw_ip.setitem(1,'sdatet',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_02681
string picturename = "c:\erpman\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_02681
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_02681
string picturename = "c:\erpman\image\인쇄_d.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02681
string picturename = "c:\erpman\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_02681
end type



type dw_print from w_standard_print`dw_print within w_sal_02681
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02681
integer x = 46
integer y = 20
integer width = 727
string dataobject = "d_sal_02681_01"
end type

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
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[매출기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[매출기간]')
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

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_02681
string dataobject = "d_sal_02681"
end type

