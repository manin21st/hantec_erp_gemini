$PBExportHeader$w_imt_08000.srw
$PBExportComments$자재사용현황
forward
global type w_imt_08000 from w_standard_print
end type
end forward

global type w_imt_08000 from w_standard_print
string title = "자재 사용 현황"
end type
global w_imt_08000 w_imt_08000

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string syyyy, sitcls, sitnbr1, sitnbr2
int    i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

syyyy   = trim(dw_ip.getitemstring(1, 'yyyy'))
sitcls  = dw_ip.getitemstring(1, 'fitcls')
sitnbr1 = dw_ip.getitemstring(1, 'itnbr1')
sitnbr2 = dw_ip.getitemstring(1, 'itnbr2')

if IsNull(syyyy) or syyyy = "" then
	f_message_chk(30, "[기준년도]")
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
end if

if isnull(sitcls)  or trim(sitcls)  = '' then sitcls = '%'
if isnull(sitnbr1) or trim(sitnbr1) = '' then sitnbr1 = '.'
if isnull(sitnbr2) or trim(sitnbr2) = '' then sitnbr2 = 'ZZZZZZZZZZZZZZZZz'

//IF dw_list.retrieve(syyyy, sitcls, sitnbr1, sitnbr2) <= 0 THEN
//   f_message_chk(50,'[자재 사용 현황]')
//	dw_ip.setfocus()
//	Return -1
//END IF

IF dw_print.retrieve(syyyy, sitcls, sitnbr1, sitnbr2) <= 0 THEN
   f_message_chk(50,'[자재 사용 현황]')
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1


end function

on w_imt_08000.create
call super::create
end on

on w_imt_08000.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1, "yyyy", left(f_today(), 4))
end event

type dw_list from w_standard_print`dw_list within w_imt_08000
integer width = 3489
integer height = 1964
string dataobject = "d_imt_08000_01"
end type

type cb_print from w_standard_print`cb_print within w_imt_08000
end type

type cb_excel from w_standard_print`cb_excel within w_imt_08000
end type

type cb_preview from w_standard_print`cb_preview within w_imt_08000
end type

type cb_1 from w_standard_print`cb_1 within w_imt_08000
end type

type dw_print from w_standard_print`dw_print within w_imt_08000
integer x = 4219
integer y = 180
string dataobject = "d_imt_08000_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_08000
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_08000_02"
end type

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2
Integer i_rtn

if this.getcolumnname() = 'itnbr1' then 
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itdsc1' then 
	s_nam1 = Trim(this.GetText())
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr2' then 
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itdsc2' then 
	s_nam1 = Trim(this.GetText())
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct


SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "itnbr1"	THEN 
   gs_gubun = '3'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return 
   this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
ELSEIF this.getcolumnname() = "itnbr2"	THEN 
   gs_gubun = '3'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return 
   this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
ELSEIF this.GetColumnName() = 'fitcls' then

	this.accepttext()
	sIttyp = '3'
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
END IF
end event

event dw_ip::itemerror;return 1
end event

type r_1 from w_standard_print`r_1 within w_imt_08000
end type

type r_2 from w_standard_print`r_2 within w_imt_08000
end type

