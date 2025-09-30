$PBExportHeader$w_pdm_t_10080.srw
$PBExportComments$** 고객 제품명 현황
forward
global type w_pdm_t_10080 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_t_10080
end type
end forward

global type w_pdm_t_10080 from w_standard_print
string title = "고객 제품명 현황"
rr_1 rr_1
end type
global w_pdm_t_10080 w_pdm_t_10080

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIttyp, sItcls, sItnbr, tx_name,sUseYn, stitcls, ls_porgu, ls_cvcod1, ls_cvcod2

If dw_ip.AcceptText() <> 1 Then Return -1
sIttyp  		= Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls  		= Trim(dw_ip.GetItemString(1,"itcls"))
stItcls 		= Trim(dw_ip.GetItemString(1,"titcls"))
sItnbr  	= Trim(dw_ip.GetItemString(1,"itnbr"))
sUseYn  	= Trim(dw_ip.GetItemString(1,"useyn"))
ls_porgu	= dw_ip.GetItemString(1,"porgu")
ls_cvcod1 = dw_ip.GetItemString(1,"cvcod1")
ls_cvcod2 = dw_ip.GetItemString(1,"cvcod2")

If Isnull(sIttyp) or sIttyp = '' Then
	f_message_chk(30,'[품목구분]')
	dw_ip.setfocus()
	dw_ip.setColumn('ittyp')
	return -1
End if

If 	Isnull(sItcls) Then sItcls = '.'
If 	Isnull(stItcls) Then 
	stItcls = 'zzzzzzz'
else
	stItcls = stItcls + 'zzzzzzz'
end if

If 	Isnull(sItnbr) 			Then sItnbr = ''
If 	Isnull(suseyn) or sUseyn = '3' 		Then sUseYn = ''
If 	Isnull(ls_cvcod1) Then ls_cvcod1 = '.'
If 	Isnull(ls_cvcod2) Then ls_cvcod2 = 'ZZZZZ'


dw_print.settransobject(sqlca)

IF 	dw_print.Retrieve(ls_porgu,sIttyp, sItcls, stitcls, sItnbr+'%',sUseYn+'%',ls_cvcod1, ls_cvcod2) <=0 THEN
	f_message_chk(50,'')
   	dw_ip.setcolumn('itcls')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
Return 1
end function

on w_pdm_t_10080.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_t_10080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'porgu')

end event

type p_preview from w_standard_print`p_preview within w_pdm_t_10080
end type

type p_exit from w_standard_print`p_exit within w_pdm_t_10080
end type

type p_print from w_standard_print`p_print within w_pdm_t_10080
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_t_10080
end type











type dw_print from w_standard_print`dw_print within w_pdm_t_10080
string dataobject = "d_pdm_t_10080_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_t_10080
integer x = 105
integer y = 48
integer width = 3401
integer height = 308
string dataobject = "d_pdm_t_10080_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  snull
string  s_name,sIttyp,sItcls,get_nm,sItclsNm,sIspec, sGbn, ls_data,ls_cvnas2

SetNull(snull)

sGbn 	= this.GetItemString(1,"gbn")

Choose Case this.GetColumnName() 
/* 품목구분 */
 	Case 'ittyp'
   		This.setitem(1, 'itcls', snull)
   		This.setitem(1, 'titcls', snull)
   		This.setitem(1, 'itclsnm', snull)	
   		This.setitem(1, 'itnbr', snull)
   		This.setitem(1, 'itdsc', snull)
		This.setitem(1, 'ispec', snull)
	
/* 품번 */
	Case 'itnbr'
		If 	sGbn	= '2' 	then						// 자사 기준만 해당..		
			s_name = trim(this.GetText())
			IF 	s_name = '' or	IsNull(s_name)	THEN
				this.setitem(1, "itdsc", snull)	
				this.setitem(1, "ispec", snull)	
				RETURN 
			END IF
		
			SELECT 	"ITEMAS"."ITDSC","ITEMAS"."ISPEC", "ITEMAS"."ITTYP",
							"ITEMAS"."ITCLS","ITNCT"."TITNM"
				INTO	:get_nm, :sIspec, :sIttyp, :sItcls, :sItclsNm
				FROM "ITEMAS"  ,"ITNCT"
				WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
						"ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
						"ITEMAS"."ITNBR" = :s_name ;
		
			IF 	sqlca.sqlcode <> 0 THEN
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
		End If	
/* 품번 표시기준   1:모기업 , 2:자사  */
 	Case 'gbn'
		
		s_name = trim(this.GetText())
		dw_list.setredraw(false)
		if 	s_name = '1' then    // 모기업.
			dw_list.dataobject 	= 'd_pdm_t_10080_3'
			dw_print.dataobject 	= 'd_pdm_t_10080_p3'
		elseif s_name = '2' then // 자사. 
			dw_list.dataobject 	= 'd_pdm_t_10080_2'
			dw_print.dataobject 	= 'd_pdm_t_10080_p'
		end if
		
		dw_list.Settransobject(sqlca)
		dw_print.Settransobject(sqlca)	
		dw_print.ShareData(dw_list)	
		
		dw_list.setredraw(true)

END Choose

if getColumnName() = 'cvcod1' Then
	ls_data = GetText()

	Select cvnas2
	into :ls_cvnas2
	From VNDMST 
	WHERE CVCOD = :ls_data;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","거래처 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(1,'cvcod1', '')
		Return 1
	End If

	this.SetItem(1,'cvnam1', ls_cvnas2)
	
ELSEIf getColumnName() = 'cvcod2'  Then

	ls_data = GetText()

	Select cvnas2
	into :ls_cvnas2
	From VNDMST 
	WHERE CVCOD = :ls_data;
	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","거래처 코드가 존재하지 않습니다.",Exclamation!)
		Return 1
	END IF
		
	this.SetItem(1,'cvnam2', ls_cvnas2)
	
End If
end event

event dw_ip::rbuttondown;String sittyp, sGbn

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)


sGbn 	= this.GetItemString(1,"gbn")

if this.GetColumnName() = 'itcls'  then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   	lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls'  then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   	lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)
elseIf this.GetColumnName() = 'itnbr' then
	If 	sGbn	= '2' 	then						// 자사 기준만 해당..		
		Gs_gubun = Trim(GetItemString(GetRow(),'ittyp'))
		If Gs_gubun = '' Or IsNull(Gs_gubun) Then Gs_gubun = '1'
		open(w_itemas_popup)
		
		if gs_code = "" or isnull(gs_code) then return 
			
		this.setitem(1, 'itnbr', gs_code)
			TriggerEvent(ItemChanged!)
	End If
Elseif this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
   if gs_code = '' or isnull(gs_code) then return 	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
   if gs_code = '' or isnull(gs_code) then return 	
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
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

type dw_list from w_standard_print`dw_list within w_pdm_t_10080
integer x = 119
integer y = 384
integer width = 4325
integer height = 1888
string dataobject = "d_pdm_t_10080_2"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdm_t_10080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 364
integer width = 4347
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

