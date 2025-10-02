$PBExportHeader$w_pdm_30000.srw
$PBExportComments$단가마스타에 등록안된 품목 조회
forward
global type w_pdm_30000 from w_standard_print
end type
end forward

global type w_pdm_30000 from w_standard_print
string title = "단가 마스타에 등록 안된 품목 조회"
end type
global w_pdm_30000 w_pdm_30000

type variables
Datastore ds_list, ds_list2    //ds_list => 생산bom, ds_list2 => 기술bom

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sittyp, sitcls, sfitnbr, stitnbr 
String ls_porgu, ls_rfna1, ls_rfna2

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sittyp  = dw_ip.GetItemString(1,"ittyp")
sitcls  = dw_ip.GetItemString(1,"fitcls")
sfitnbr = dw_ip.GetItemString(1,"fr_itnbr")
stitnbr = dw_ip.GetItemString(1,"to_itnbr")

//조회 조건에서 사업장 추가 시작
ls_porgu = dw_ip.getItemString(1, "porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
AND "REFFPF"."RFGUB" = :ls_porgu;

if ls_porgu ='%' Then
	dw_print.object.t_100.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_100.text = ls_rfna1
End If
//조회 조건에서 사업장 추가 끝

IF sittyp = "" OR IsNull(sittyp) THEN
	sittyp = '%'
end if	

IF sitcls = "" OR IsNull(sitcls) THEN
	sitcls = '%'
else
	sitcls = sitcls + '%'
end if	

IF sfitnbr ="" OR IsNull(sfitnbr) THEN
	sfitnbr = '.'
END IF
IF stitnbr ="" OR IsNull(stitnbr) THEN
	stitnbr = 'zzzzzzzzzzzzzzz'
END IF

if sfitnbr > stitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

String ls_itgu
ls_itgu = dw_ip.GetItemString(1, 'guout')
If Trim(ls_itgu) = '' OR IsNull(ls_itgu) Then ls_itgu = '%'

SetPointer(HourGlass!)

IF dw_print.Retrieve(sittyp,sitcls,sfitnbr,stitnbr, ls_porgu, ls_itgu) <=0 THEN
	f_message_chk(50,"")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1


end function

on w_pdm_30000.create
call super::create
end on

on w_pdm_30000.destroy
call super::destroy
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

end event

type dw_list from w_standard_print`dw_list within w_pdm_30000
integer y = 296
integer height = 1964
string dataobject = "d_pdm_30000_1"
end type

type cb_print from w_standard_print`cb_print within w_pdm_30000
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_30000
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_30000
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_30000
end type

type dw_print from w_standard_print`dw_print within w_pdm_30000
string dataobject = "d_pdm_30000_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_30000
integer y = 56
integer height = 200
string dataobject = "d_pdm_30000"
end type

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct

this.accepttext()
if this.GetColumnName() = 'fitcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"fclsnm", lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	


end event

event dw_ip::ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
Return 1
end event

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, sdate, sNull
int     ireturn

setnull(sNull)

IF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = 'fitcls' then
	sItnbr = this.GetText()
   this.accepttext()	
	sispec = this.getitemstring(1, 'ittyp')
	
	ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fitcls", sitnbr)	
	this.setitem(1, "fclsnm", sitdsc)	
	RETURN ireturn
END IF
end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"to_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

type r_1 from w_standard_print`r_1 within w_pdm_30000
integer y = 292
end type

type r_2 from w_standard_print`r_2 within w_pdm_30000
integer height = 208
end type

