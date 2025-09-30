$PBExportHeader$w_sal_06870.srw
$PBExportComments$수주품 vs 견적원가 비교서
forward
global type w_sal_06870 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06870
end type
end forward

global type w_sal_06870 from w_standard_print
string title = "수주 vs 견적원가 비교표"
rr_1 rr_1
end type
global w_sal_06870 w_sal_06870

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate ,ls_edate , ls_sarea ,ls_cvcod ,ls_order_no ,ls_sitcls ,ls_titcls ,ls_itnbr

if dw_ip.accepttext() <> 1 then return -1

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))
ls_sarea = Trim(dw_ip.getitemstring(1,'sarea'))
ls_order_no = Trim(dw_ip.getitemstring(1,'order_no'))
ls_sitcls = Trim(dw_ip.getitemstring(1,'sitcls'))
ls_titcls = Trim(dw_ip.getitemstring(1,'titcls'))
ls_itnbr = Trim(dw_ip.getitemstring(1,'itnbr'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[수주일자 FROM]')
	dw_ip.setfocus()
	dw_ip.setcolumn('sdate')
	return -1
end if
if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[수주일자 TO]')
	dw_ip.setfocus()
	dw_ip.setcolumn('edate')
	return -1
end if

if ls_sarea = "" or isnull(ls_sarea) then ls_sarea = '%'
if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
if ls_order_no = "" or isnull(ls_order_no) then ls_order_no = '%'
if ls_sitcls = "" or isnull(ls_sitcls) then ls_sitcls = '.'
if ls_titcls = "" or isnull(ls_titcls) then ls_titcls = 'zzzzzzzzzzzzzzzz'
if ls_itnbr = "" or isnull(ls_itnbr) then ls_itnbr = '%'

if dw_list.retrieve(gs_sabu,ls_sdate,ls_edate,ls_sarea,ls_cvcod,ls_order_no,ls_sitcls,ls_titcls,ls_itnbr) < 1 then
	f_message_chk(300,'')
	dw_ip.setfocus()
	dw_ip.setcolumn('sdate')
	return -1
end if

//dw_list.object.tx_sdate.text = left(ls_sdate,4) + '.' + mid(ls_sdate,5,2) + '.' + mid(ls_sdate,7,2)
//dw_list.object.tx_edate.text = left(ls_edate,4) + '.' + mid(ls_edate,5,2) + '.' + mid(ls_edate,7,2)
//
return 1

end function

on w_sal_06870.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06870.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_ip.settransobject(sqlca)
//dw_ip.insertrow(0)

dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',f_today())

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If
dw_ip.SetItem(1, 'sarea', sarea)


end event

type p_preview from w_standard_print`p_preview within w_sal_06870
end type

type p_exit from w_standard_print`p_exit within w_sal_06870
end type

type p_print from w_standard_print`p_print within w_sal_06870
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06870
end type







type st_10 from w_standard_print`st_10 within w_sal_06870
end type



type dw_print from w_standard_print`dw_print within w_sal_06870
string dataobject = "d_sal_06870_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06870
integer x = 46
integer y = 24
integer width = 2990
integer height = 364
string dataobject = "d_sal_06870_01"
end type

event dw_ip::itemchanged;String  ls_sdate ,ls_edate ,ls_sarea , ls_cvcod ,ls_cvnas ,ls_order_no , ls_sitcls,ls_titcls ,ls_stitnm ,ls_ttitnm
String  ls_itnbr , ls_itdsc ,ls_ispec ,ls_jijil , snull, steam, sSaupj, sName1 , ls_ispeccode

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdate"
	ls_sdate = Trim(this.GetText())
	IF ls_sdate ="" OR IsNull(ls_sdate) THEN RETURN
	
	IF f_datechk(ls_sdate) = -1 THEN
		f_message_chk(35,'[수주일자 FROM]')
		this.SetItem(1,"sdate",snull)
		Return 1
	END IF
 Case "edate"
	ls_edate = Trim(this.GetText())
	IF ls_edate ="" OR IsNull(ls_edate) THEN RETURN
	
	IF f_datechk(ls_edate) = -1 THEN
		f_message_chk(35,'[수주일자 TO]')
		this.SetItem(1,"edate",snull)
		Return 1
	END IF
/* 관할구역 */
 Case "sarea"
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvnas",sNull)
	
/* 거래처 */
	Case "cvcod"
		ls_cvcod = Trim(GetText())
		IF ls_cvcod ="" OR IsNull(ls_cvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', ls_cvcod, ls_cvnas, ls_sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas", ls_cvnas)
			SetItem(1,"sarea", ls_sarea)	
		END IF
   /* 품목분류 */
	Case "sitcls"
		SetItem(1,'stitnm',sNull)
		
		ls_sitcls = Trim(GetText())
		IF ls_sitcls = "" OR IsNull(ls_sitcls) THEN 		RETURN
		
		SELECT "ITNCT"."TITNM" 
		  INTO :ls_stitnm  
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITCLS" = :ls_sitcls )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			SetItem(1,"stitnm",ls_stitnm)
		END IF
	 /* 품목분류 */
	Case "titcls"
		SetItem(1,'ttitnm',sNull)
		
		ls_titcls = Trim(GetText())
		IF ls_titcls = "" OR IsNull(ls_titcls) THEN 		RETURN
		
		SELECT "ITNCT"."TITNM" 
		  INTO :ls_ttitnm  
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITCLS" = :ls_titcls )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			SetItem(1,"stitnm",ls_ttitnm)
		END IF
	/* 품번 */
	Case	"itnbr" 
		ls_itnbr = Trim(GetText())
		IF ls_itnbr ="" OR IsNull(ls_itnbr) THEN
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			Return
		END IF
		
		SELECT "ITDSC","ISPEC","JIJIL"
		  INTO :ls_itdsc, :ls_ispec ,:ls_jijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :ls_itnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(1,"itdsc", ls_itdsc)
		SetItem(1,"ispec", ls_ispec)
		SetItem(1,"jijil", ls_jijil)
	/* 품명 */
	Case "itdsc"
		ls_itdsc = trim(GetText())	
		IF ls_itdsc ="" OR IsNull(ls_itdsc) THEN
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', ls_itnbr, ls_itdsc, ls_ispec, ls_jijil, ls_ispeccode)
		If IsNull(ls_itnbr ) Then
			Return 1
		ElseIf ls_itnbr <> '' Then
			SetItem(1,"itnbr",ls_itnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
	/* 규격 */
	Case "ispec"
		ls_ispec = trim(GetText())	
		IF ls_ispec = ""	or	IsNull(ls_ispec)	THEN
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4('규격', 'Y', ls_itnbr, ls_itdsc, ls_ispec, ls_jijil, ls_ispeccode)
		If IsNull(ls_itnbr ) Then
			Return 1
		ElseIf ls_itnbr <> '' Then
			SetItem(1,"itnbr",ls_itnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			SetColumn("ispec")
			Return 1
		End If
	Case "jijil"
		ls_jijil = trim(GetText())	
		IF ls_jijil = ""	or	IsNull(ls_jijil)	THEN
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			Return
		END IF
		
		/* 재질으로 품번찾기 */
		f_get_name4('재질', 'Y', ls_itnbr, ls_itdsc, ls_ispec, ls_jijil, ls_ispeccode)
		If IsNull(ls_itnbr ) Then
			Return 1
		ElseIf ls_itnbr <> '' Then
			SetItem(1,"itnbr",ls_itnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(1,'itnbr',sNull)
			SetItem(1,'itdsc',sNull)
			SetItem(1,'ispec',sNull)
			SetItem(1,'jijil',sNull)
			SetColumn("jijil")
			Return 1
		End If
END Choose

end event

event dw_ip::rbuttondown;str_itnct str_sitnct

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose Case this.getcolumnname()
  Case "order_no" 
		OpenWithParm(w_sorder_popup,'1')
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"order_no",Left(gs_code,14))
  Case "cvcod", "cvnas"
		gs_gubun = '1'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
  Case "sitcls"
		OpenWithParm(w_ittyp_popup, '1')
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"sitcls",str_sitnct.s_sumgub)
		SetItem(1,"stitnm", str_sitnct.s_titnm)
		
		SetColumn('titcls')
  Case "titcls"
		OpenWithParm(w_ittyp_popup, '1')
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"titcls",str_sitnct.s_sumgub)
		SetItem(1,"ttitnm", str_sitnct.s_titnm)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec" , "jijil"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr",gs_code)
		SetFocus()
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
End Choose
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06870
integer x = 55
integer y = 412
integer width = 4526
integer height = 1880
string dataobject = "d_sal_06870"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06870
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 408
integer width = 4558
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

