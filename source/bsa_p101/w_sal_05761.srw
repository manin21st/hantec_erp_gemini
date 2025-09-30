$PBExportHeader$w_sal_05761.srw
$PBExportComments$전년대비 판매수량 추이도
forward
global type w_sal_05761 from w_standard_dw_graph
end type
end forward

global type w_sal_05761 from w_standard_dw_graph
string title = "전년 대비 판매수량 추이도"
end type
global w_sal_05761 w_sal_05761

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear4, syear3, syear2, syear1, sIttyp, sItcls, txt_name

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear1  = dw_ip.GetItemString(dw_ip.GetRow(),'syear')
sIttyp  = dw_ip.GetItemString(dw_ip.GetRow(),'ittyp')
sItcls  = dw_ip.GetItemString(dw_ip.GetRow(),'itcls')
If IsNull(sIttyp) Then sIttyp = ''
If IsNull(sItcls) Then sItcls = ''

IF	IsNull(syear1) or syear1 = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

syear2 = String(long(syear1) -1 )
syear3 = String(long(syear2) -1 )
syear4 = String(long(syear3) -1 )

dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

dw_list.Modify("gr_1.Series='" + syear1+ "," + syear2+ "," + syear3+ "," + syear4+ "'")

If dw_list.retrieve(gs_sabu, syear1,syear2,syear3,syear4, sIttyp+'%', sItcls+'%',ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_ittyp.text = txt_name

txt_name = Trim(dw_ip.GetItemSTring(1,'itclsnm'))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_itcls.text = txt_name

dw_list.SetRedraw(True)

Return 1
end function

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syear',syymm)


end event

on w_sal_05761.create
call super::create
end on

on w_sal_05761.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_sal_05761
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05761
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05761
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05761
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05761
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05761
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05761
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05761
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05761
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05761
integer x = 23
integer width = 2779
integer height = 208
string dataobject = "d_sal_057622"
end type

event dw_ip::rbuttondown;String sIttyp,ls_lmsgu
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

event dw_ip::itemchanged;String  sDateFrom , sDateTo, sPrtGbn ,ls_lmsgu
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
			dw_list.dataobject = 'd_sal_05761_01'
			dw_list.settransobject(sqlca)
			dw_ip.setitem(1,'ittyp','')
			dw_ip.setitem(1,'itcls','')
			dw_ip.setitem(1,'itclsnm','')
		elseif sItemClsName = '2' then
			dw_list.dataobject = 'd_sal_05761'
			dw_list.settransobject(sqlca)
			dw_ip.setitem(1,'ittyp','')
			dw_ip.setitem(1,'itcls','')
			dw_ip.setitem(1,'itclsnm','')
		elseif sItemClsName = '3' then
			dw_list.dataobject = 'd_sal_05761_02'
			dw_list.settransobject(sqlca)
			dw_ip.setitem(1,'ittyp','')
			dw_ip.setitem(1,'itcls','')
			dw_ip.setitem(1,'itclsnm','')
		end if
		dw_list.setredraw(true)
END Choose


end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05761
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05761
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05761
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05761
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05761
string dataobject = "d_sal_05761_01"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05761
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05761
end type

