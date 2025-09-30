$PBExportHeader$w_sal_03590.srw
$PBExportComments$재고현황
forward
global type w_sal_03590 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_03590
end type
end forward

global type w_sal_03590 from w_standard_print
integer height = 2580
string title = "재고 현황"
rr_1 rr_1
end type
global w_sal_03590 w_sal_03590

type variables
str_itnct str_sitnct
String  sItnbrYN
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDepotNo, sIttyp, sItcls, sItnbr, sPspec, sItdsc, sIspec, sJijil, sIspecCode
String old_select, new_select, where_clause ,ls_gubun

If dw_ip.AcceptText() <> 1 Then Return -1

ls_gubun = dw_ip.getitemstring(1,'gubun')

sDepotNo = Trim(dw_ip.GetItemString(1,'depot_no'))
sIttyp   = Trim(dw_ip.GetItemString(1,'ittyp'))
sItcls   = Trim(dw_ip.GetItemString(1,'itcls'))
sItnbr   = Trim(dw_ip.GetItemString(1,'itnbr'))
sPspec   = Trim(dw_ip.GetItemString(1,'pspec'))
sItdsc   = Trim(dw_ip.GetItemString(1,'itdsc'))
sIspec   = Trim(dw_ip.GetItemString(1,'ispec'))
sJijil   = Trim(dw_ip.GetItemString(1,'jijil'))
sIspecCode   = Trim(dw_ip.GetItemString(1,'ispec_code'))

If IsNull(sItdsc) Then sItdsc = ''
If IsNull(sIspec) Then sIspec = ''
If IsNull(sJijil) Then sJijil = ''
If IsNull(sIspecCode) Then sIspecCode = ''
If IsNull(sPspec) Then sPspec = ''

if ls_gubun = '1' then
	/* 조건절 추가 */ 
	old_select = dw_print.GetSQLSelect()
	
	where_clause = ''
	
	where_clause += " and '" + gs_saupj +"'" +  " = z.saupj(+) "
	
	If Not ( IsNull(sDepotNo) or sDepotNo = '' ) Then where_clause += " and y.depot_no = '" + sDepotNo + "'"
	If Not ( IsNull(sIttyp) or sIttyp = '' ) Then where_clause += " and x.ittyp = '" + sIttyp + "'"
	If Not ( IsNull(sItcls) or sItcls = '' ) Then where_clause += " and x.itcls = '" + sItcls + "'"
	If Not ( IsNull(sItnbr) or sItnbr = '' ) Then where_clause += " and x.itnbr = '" + sItnbr + "'"
	
	
	where_clause += " and nvl(y.pspec,0) like '" + sPspec+'%' + "'"
	
	where_clause += " and nvl(x.itdsc,0) like '" + sItdsc+'%' + "'"
	where_clause += " and nvl(x.ispec,0) like '" + sIspec+'%' + "'"
	where_clause += " and nvl(x.jijil,0) like '" + sJijil+'%' + "'"
	where_clause += " and nvl(x.ispec_code,0) like '" + sIspecCode+'%' + "'"
	
	new_select = old_select + where_clause
	
	dw_print.SetSQLSelect(new_select)
	
	dw_print.Retrieve()
	dw_print.SetFocus()
	
	dw_print.SetSQLSelect(old_select)
elseif ls_gubun ='2' then
	if sDepotno = "" or isnull(sDepotno) then sDepotno = '%'
	if sitnbr = "" or isnull(sitnbr) then sitnbr = '%'
	if sittyp = "" or isnull(sittyp) then sittyp = '%'
	if sitcls = "" or isnull(sitcls) then sitcls = '%'
	
	if dw_print.retrieve(sDepotNo ,sItnbr,sittyp , sitcls ) < 1  then
		f_message_chk(300,'')
		dw_ip.setfocus()
		dw_ip.setcolumn('depot_no')
		return 1
	end if
	
	if dw_list.Dataobject = 'd_sal_035901' then
		dw_list.Sharedataoff()
		dw_list.SetTransObject(Sqlca)
		dw_list.Retrieve(sDepotNo ,sItnbr,sittyp , sitcls)
	End if 

end if

Return 1 
end function

on w_sal_03590.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_03590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;/* 품목입력시 부품 입력가능 여부 */
//select substr(dataname,1,1) into :sItnbrYN
//  from syscnfg
// where sysgu = 'S' and
//       serial = 7 and
//       lineno = 15;
			 

end event

event ue_open;call super::ue_open;dw_ip.InsertRow(0)
dw_ip.SetFocus()
dw_ip.SetColumn('itdsc')

//사업장
f_mod_saupj(dw_ip, 'saupj' )

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

end event

type p_preview from w_standard_print`p_preview within w_sal_03590
end type

type p_exit from w_standard_print`p_exit within w_sal_03590
end type

type p_print from w_standard_print`p_print within w_sal_03590
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03590
end type







type st_10 from w_standard_print`st_10 within w_sal_03590
end type



type dw_print from w_standard_print`dw_print within w_sal_03590
integer x = 3616
integer y = 40
boolean enabled = false
string dataobject = "d_sal_03590_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03590
integer width = 3109
integer height = 188
string dataobject = "d_sal_03590_01"
end type

event dw_ip::itemchanged;call super::itemchanged;string  s_name,sIttyp,sItcls,get_nm,sItclsNm, sNull ,ls_gubun
String  sItemCls, sItemGbn, sItemClsName, sitnbr, sItdsc, sIspec, sSaupj
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
  Case 'saupj'
		sSaupj = this.gettext()	
		//사업장
		f_mod_saupj(dw_ip, 'saupj' )
	
		//입고창고 
		f_child_saupj(dw_ip, 'depot', sSaupj)
  Case 'gubun'
		ls_gubun = this.gettext()
		
		dw_print.setredraw(false)
		if ls_gubun = '1' then
			dw_list.dataobject = 'd_sal_03590'
			dw_print.dataobject = 'd_sal_03590_p'
		elseif ls_gubun ='2' then
			dw_list.dataobject = 'd_sal_035901'
			dw_print.dataobject = 'd_sal_035901_p'
		end if
		dw_print.settransobject(sqlca)
		dw_print.setredraw(true)
		dw_print.Sharedata(dw_list)
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
		  TriggerEvent(RButtonDown!)
		  Return 2
	  ELSE
		  SetItem(1,"itclsnm",sItemClsName)
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
  	 SetItem(nRow,"pspec", '.')
 	 SetItem(nRow,"itclsnm", sItemClsName)
END Choose

end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
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
  Case "itnbr"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)
END Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_03590
integer y = 220
integer width = 4544
integer height = 2140
string dataobject = "d_sal_03590"
boolean border = false
end type

event dw_list::rbuttondown;call super::rbuttondown;/* -------------------------------------------------------- */
/* Clicked된 row,column 가져오기                            */
/* -------------------------------------------------------- */
string  ls_col,ls_colnm ,ls_gubun
Long	  nRow,li_pos 

if dw_ip.accepttext() <> 1 then return -1

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '1' then
	ls_col = this.GetObjectAtPointer() 
	
	if Len (ls_col) > 0 then
		li_pos = Pos (ls_col, '~t')
	
		if li_pos > 0 then
			nRow = Integer (Right (ls_col, Len (ls_col) - li_pos))
			ls_colnm = Trim(Left(ls_col,li_pos - 1))
		Else
			Return -1
		end if
	
		If nRow <= 0 Then Return -1
	End if
	/* -------------------------------------------------------- */
	String sDepotNo, sItnbr, sPspec
	
	SetNull(gs_gubun)
	SetNull(gs_code)
	SetNull(gs_codename)
	
	If nRow <= 0 Then Return -1
	
	/* 상세조회시 필요한 창고, 품번 */
	sDepotNo = Trim(GetItemString(nRow,'stock_depot_no'))
	sItnbr   = Trim(GetItemString(nRow,'itemas_itnbr'))
	sPspec   = Trim(GetItemString(nRow,'stock_pspec'))
	If IsNull(sPspec ) or sPspec = '' Then sPspec = '.'
	
	gs_code = sDepotNo
	gs_codename = sItnbr
	gs_gubun = sPspec
	
	Choose Case ls_colnm
		Case 'orderqty'
			openwithparm(w_sal_03590_1,'미처리량')
		Case 'holdqty'
			openwithparm(w_sal_03590_1,'할당수량')
		Case 'jisiqty'
			openwithparm(w_sal_03590_1,'지시수량')
		Case 'baljuqty'
			openwithparm(w_sal_03590_1,'발주수량')
		Case 'prodqty'
			openwithparm(w_sal_03590_1,'생산입고대기수량')
		Case 'insqty'
			openwithparm(w_sal_03590_1,'구매입고대기수량')
	End Choose
	
end if
return 1
end event

event dw_list::itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_sal_03590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 212
integer width = 4562
integer height = 2156
integer cornerheight = 40
integer cornerwidth = 55
end type

