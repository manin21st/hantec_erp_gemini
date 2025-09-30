$PBExportHeader$w_sal_02660.srw
$PBExportComments$ ** 제품가격리스트
forward
global type w_sal_02660 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02660
end type
end forward

global type w_sal_02660 from w_standard_print
string title = "제품 가격 리스트"
rr_1 rr_1
end type
global w_sal_02660 w_sal_02660

type variables
str_itnct lstr_sitnct
String   SqlSyntax
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaleGu,sIttyp,sItcls,tx_name,sNull
String sPdtgu, sItnbr,sItdsc,sIspec,sAllYn,where_clause,mod_string,rc, sUseYn, sSaupj

If dw_ip.AcceptText() <> 1 Then Return -1

sSalegu 	= Trim(dw_ip.GetItemString(1,"salegu"))
sPdtgu  	= Trim(dw_ip.GetItemString(1,"pdtgu"))
sIttyp  		= Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls  		= Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr  	= Trim(dw_ip.GetItemString(1,"itnbr"))
sItdsc  	= Trim(dw_ip.GetItemString(1,"itdsc"))
sIspec  	= Trim(dw_ip.GetItemString(1,"ispec"))
sAllYn  	= Trim(dw_ip.GetItemString(1,"allyn"))
sUseYn  	= Trim(dw_ip.GetItemString(1,"useyn"))
sSaupj  	= Trim(dw_ip.GetItemString(1,"saupj"))

if 	IsNull(sSalegu) or sSalegu = '' then
	f_message_chk(30,'[판매구분]')
	dw_ip.setfocus()
	return -1
end if

If Isnull(sIttyp) or sIttyp = '' Then
	f_message_chk(30,'[품목구분]')
	dw_ip.setfocus()
	return -1
End if

If Isnull(sPdtgu) Then sPdtgu = ''
If Isnull(sItcls) Then sItcls = ''
If Isnull(sItnbr) or sItnbr = ''  	Then sItnbr = ''
If Isnull(sItdsc) or sItdsc = ''  	Then sItdsc = ''
If Isnull(sIspec) or sIspec = '' 	Then sIspec = ''
If Isnull(sAllYn) or sAllYn = ''  	Then sAllYn = 'Y'
If Isnull(sUseYn) or sUseYn = ''  or sUseYn = '3' Then sUseYn = ''

dw_print.SetFilter("")
dw_print.Filter()
IF 	dw_print.Retrieve(ssaupj, sSaleGu,spdtgu+'%', sIttyp,sItcls+'%',sItnbr+'%',sItdsc+'%',sIspec+'%', sUseYn+'%') <=0 THEN
	f_message_chk(50,'')
   	dw_ip.setcolumn('salegu')
	dw_ip.SetFocus()
	Return -1
else
	dw_print.sharedata(dw_list)
END IF

If sAllYn = 'N' Then
	dw_print.SetFilter('saleprc = 0')
	dw_print.Filter()
End If

If 	dw_print.RowCount() <= 0 Then
	f_message_chk(50,'')
   	dw_ip.setcolumn('salegu')
	dw_ip.SetFocus()
	Return -1
END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(useyn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_useyn.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_itclsnm.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02660.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_02660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_sal_02660
end type

type p_exit from w_standard_print`p_exit within w_sal_02660
end type

type p_print from w_standard_print`p_print within w_sal_02660
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02660
end type











type dw_print from w_standard_print`dw_print within w_sal_02660
string dataobject = "d_sal_02660_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02660
integer x = 59
integer y = 28
integer width = 3529
integer height = 408
string dataobject = "d_sal_02660_01"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sDateFrom,sDateTo,sSaleGu,snull
string  s_name,sPdtgu, sIttyp,sItcls,get_nm,sItclsNm,sIspec

SetNull(snull)

Choose Case GetColumnName() 
/* 생산팀 */
 Case 'pdtgu'
   This.setitem(1, 'itcls', snull)
   This.setitem(1, 'itclsnm', snull)	
   This.setitem(1, 'itnbr', snull)
   This.setitem(1, 'itdsc', snull)
	This.setitem(1, 'ispec', snull)
/* 품목구분 */
 Case 'ittyp'
   This.setitem(1, 'itcls', snull)
   This.setitem(1, 'itclsnm', snull)	
   This.setitem(1, 'itnbr', snull)
   This.setitem(1, 'itdsc', snull)
	This.setitem(1, 'ispec', snull)
/* 품목분류 */
 Case "itcls"
   This.setitem(1, 'itnbr', snull)
   This.setitem(1, 'itdsc', snull)
	This.setitem(1, 'ispec', snull)
	
	s_name = Trim(this.gettext())
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
   IF s_name = "" OR IsNull(s_name) THEN 	
     This.setitem(1, 'itclsnm', snull)
	  RETURN 
	END IF
	
   SELECT "ITNCT"."TITNM"
     INTO :get_nm
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
          ( "ITNCT"."ITCLS" = :s_name ) ;

   IF SQLCA.SQLCODE <> 0 THEN
	  this.TriggerEvent(rbuttondown!)
	  if isnull(lstr_sitnct.s_Ittyp) or lstr_sitnct.s_Ittyp = "" then 
	    This.setitem(1, 'itcls', snull)
	    This.setitem(1, 'itclsnm', snull)
		 RETURN 1
     else
	    this.SetItem(1,"ittyp",lstr_sitnct.s_Ittyp)
		 this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
		 this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
       Return 1			
     end if
   ELSE
	  this.SetItem(1, 'ittyp',sIttyp)
	  This.setitem(1, 'itclsnm', get_nm)
   END IF	
/* 품번 */
Case 'itnbr'
	s_name = trim(this.GetText())
	IF s_name = '' or	IsNull(s_name)	THEN
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF
	
	SELECT "ITEMAS"."ITDSC","ITEMAS"."ISPEC", "ITEMAS"."ITTYP",
	       "ITEMAS"."ITCLS","ITNCT"."TITNM"
	  INTO :get_nm, :sIspec, :sIttyp, :sItcls, :sItclsNm
	  FROM "ITEMAS"  ,"ITNCT"
	 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
	       "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
	       "ITEMAS"."ITNBR" = :s_name ;
	
	IF sqlca.sqlcode <> 0 THEN
		f_message_chk(33, "[품번]" )
		this.setitem(1, "itnbr", snull)
		this.setitem(1, "itdsc", snull)
		this.setitem(1, "ispec", snull)
		RETURN 1
	ELSE
		this.setitem(1, "itdsc", get_nm)
		this.setitem(1, "ittyp", sIttyp)
		this.setitem(1, "itcls", sItcls)
		this.setitem(1, "itclsnm", sItclsnm)
		this.setitem(1, "ispec", sIspec)
	END IF
END Choose
end event

event dw_ip::rbuttondown;String sittyp

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)


if this.GetColumnName() = 'itcls' Or this.GetColumnName() = 'itclsnm' then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if

If this.GetColumnName() = 'itnbr' then
	Gs_gubun = Trim(GetItemString(GetRow(),'ittyp'))
	If Gs_gubun = '' Or IsNull(Gs_gubun) Then Gs_gubun = '1'
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
   TriggerEvent(ItemChanged!)
End If

end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

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

type dw_list from w_standard_print`dw_list within w_sal_02660
integer x = 78
integer y = 444
integer width = 4512
integer height = 1852
string dataobject = "d_sal_02660"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_02660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 440
integer width = 4539
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

