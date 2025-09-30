$PBExportHeader$w_pdm_11650.srw
$PBExportComments$** 수입단가 변동 예상 현황
forward
global type w_pdm_11650 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11650
end type
end forward

global type w_pdm_11650 from w_standard_print
string title = "수입단가 변동 예상 현황"
rr_1 rr_1
end type
global w_pdm_11650 w_pdm_11650

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_frittyp, s_toittyp, s_fritnbr, s_toitnbr
String  ls_porgu, ls_rfna1, ls_rfna2

if dw_ip.AcceptText() = -1 then return -1

s_frittyp  = dw_ip.GetItemString(1,'fr_ittyp')  
s_toittyp  = dw_ip.GetItemString(1,'to_ittyp')  
s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")
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

IF s_frittyp = "" OR IsNull(s_frittyp) THEN 
	s_frittyp = '1'
END IF
IF s_toittyp = "" OR IsNull(s_toittyp) THEN 
	s_toittyp = '9'
END IF
IF s_fritnbr = "" OR IsNull(s_fritnbr) THEN 
	s_fritnbr = '.'
END IF
IF s_toitnbr = "" OR IsNull(s_toitnbr) THEN 
	s_toitnbr = 'zzzzzzzzzzzzzzz'
END IF

if s_frittyp > s_toittyp then 
	f_message_chk(34,'[품목구분]')
	dw_ip.Setcolumn('fr_ittyp')
	dw_ip.SetFocus()
	return -1
end if	

if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(s_frittyp, s_toittyp,s_fritnbr,s_toitnbr, ls_porgu) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_pdm_11650.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

end event

type p_preview from w_standard_print`p_preview within w_pdm_11650
end type

type p_exit from w_standard_print`p_exit within w_pdm_11650
end type

type p_print from w_standard_print`p_print within w_pdm_11650
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11650
end type











type dw_print from w_standard_print`dw_print within w_pdm_11650
string dataobject = "d_pdm_11650_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11650
integer x = 59
integer y = 52
integer width = 3122
integer height = 316
string dataobject = "d_pdm_11650_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
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

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, snull
int     ireturn

setnull(snull)

IF this.GetColumnName() = "fr_ittyp"	THEN
	sitnbr = this.GetText()
	
   IF sitnbr = "" OR IsNull(sitnbr) THEN RETURN
	
	sitdsc = f_get_reffer('05', sitnbr)
	if isnull(sitdsc) or sitdsc = "" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'fr_ittyp', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() = "to_ittyp"	THEN
	sitnbr = this.GetText()
	
   IF sitnbr = "" OR IsNull(sitnbr) THEN RETURN
	
	sitdsc = f_get_reffer('05', sitnbr)
	if isnull(sitdsc) or sitdsc = "" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'to_ittyp', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
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
END IF
end event

type dw_list from w_standard_print`dw_list within w_pdm_11650
integer x = 73
integer y = 376
integer width = 4530
integer height = 1908
string dataobject = "d_pdm_11650"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdm_11650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 368
integer width = 4562
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

