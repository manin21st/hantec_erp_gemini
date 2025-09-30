$PBExportHeader$w_sal_05762.srw
$PBExportComments$전년대비 관할구역별 판매수량 현황
forward
global type w_sal_05762 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05762
end type
end forward

global type w_sal_05762 from w_standard_print
string title = "전년대비 관할구역별 판매수량 현황"
rr_1 rr_1
end type
global w_sal_05762 w_sal_05762

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear4, syear3, syear2, syear1, sIttyp, sItcls, txt_name

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear1  = dw_ip.GetItemString(1,'syear')
sIttyp  = dw_ip.GetItemString(1,'ittyp')
sItcls  = dw_ip.GetItemString(1,'itcls')
If IsNull(sIttyp) Then sIttyp = ''
If IsNull(sItcls) Then sItcls = ''

IF	IsNull(syear1) or syear1 = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

syear2 = String(long(syear1) -1 )

dw_print.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_print.retrieve(gs_sabu, syear1,syear2,sIttyp+'%', sItcls+'%',ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

dw_print.sharedata(dw_list)

txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//dw_list.Object.txt_ittyp.text = txt_name

txt_name = Trim(dw_ip.GetItemSTring(1,'itclsnm'))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//dw_list.Object.txt_itcls.text = txt_name
//
dw_print.SetRedraw(True)

Return 1
end function

on w_sal_05762.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05762.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syear',syymm)

end event

type p_preview from w_standard_print`p_preview within w_sal_05762
end type

type p_exit from w_standard_print`p_exit within w_sal_05762
end type

type p_print from w_standard_print`p_print within w_sal_05762
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05762
end type







type st_10 from w_standard_print`st_10 within w_sal_05762
end type



type dw_print from w_standard_print`dw_print within w_sal_05762
string dataobject = "d_sal_05762_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05762
integer x = 59
integer y = 24
integer width = 3415
integer height = 208
string dataobject = "d_sal_057622"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  sDateFrom , sDateTo, sPrtGbn
string  s_name,sIttyp,sItcls,get_nm,sItclsNm, sNull
String  sItemCls, sItemGbn, sItemClsName, sitnbr, sItdsc, sIspec, sPrtGb
Long    nRow, ix

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
	Case "lmsgu"
		dw_list.setredraw(false)
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		//분류구분별 데이타 윈도우 
		if sItemClsName = '1' then
			dw_list.dataobject = 'd_sal_05762_01'
			dw_print.dataobject = 'd_sal_05762_01_p'
			dw_list.settransobject(sqlca)
			dw_ip.setitem(1,'ittyp','')
			dw_ip.setitem(1,'itcls','')
			dw_ip.setitem(1,'itclsnm','')
		elseif sItemClsName = '2' then
			dw_list.dataobject = 'd_sal_05762'
			dw_print.dataobject = 'd_sal_05762_p'
			dw_list.settransobject(sqlca)
			dw_ip.setitem(1,'ittyp','')
			dw_ip.setitem(1,'itcls','')
			dw_ip.setitem(1,'itclsnm','')
		elseif sItemClsName = '3' then
			dw_list.dataobject = 'd_sal_05762_02'
			dw_list.settransobject(sqlca)
			dw_ip.setitem(1,'ittyp','')
			dw_ip.setitem(1,'itcls','')
			dw_ip.setitem(1,'itclsnm','')
		end if
		dw_print.settransobject(sqlca)
		dw_list.setredraw(true)
END Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sIttyp,ls_lmsgu
long nRow

str_itnct  lstr_sitnct

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

this.accepttext()
nRow = GetRow()
ls_lmsgu =dw_ip.getitemstring(1,'lmsgu')

Choose Case GetcolumnName() 
  Case "itcls","itclsnm"
	 gs_gubun = GetItemString(1,"ittyp")
	 
	 IF ls_lmsgu = '1' then	
		 Open(w_itnct_l_popup)
		 If IsNull(gs_code) Then Return 
	
		 SetItem(1,"itcls", gs_code)
		 SetItem(1,"itclsnm", gs_codename)
		 SetItem(1,"ittyp",  gs_gubun)
	elseif ls_lmsgu = '2' then
		OpenWithParm(w_ittyp_popup, '1')
		
		lstr_sitnct = Message.PowerObjectParm
	
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
		this.SetColumn('itcls')
		this.SetFocus()
	elseif ls_lmsgu = '3' then
		OpenWithParm(w_ittyp_popup3, '1')
		
		lstr_sitnct = Message.PowerObjectParm
	
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
		this.SetColumn('itcls')
		this.SetFocus()
	end if
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_05762
integer x = 151
integer y = 248
integer width = 4512
integer height = 2060
string dataobject = "d_sal_05762_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05762
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 244
integer width = 4539
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

