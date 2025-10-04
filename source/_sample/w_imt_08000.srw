$PBExportHeader$w_imt_08000.srw
$PBExportComments$자재사용현황
forward
global type w_imt_08000 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_08000
end type
end forward

global type w_imt_08000 from w_standard_print
string title = "자재 사용 현황"
rr_1 rr_1
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
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_08000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "yyyy", left(f_today(), 4))
end event

type p_preview from w_standard_print`p_preview within w_imt_08000
end type

type p_exit from w_standard_print`p_exit within w_imt_08000
end type

type p_print from w_standard_print`p_print within w_imt_08000
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_08000
end type







type st_10 from w_standard_print`st_10 within w_imt_08000
end type



type dw_print from w_standard_print`dw_print within w_imt_08000
integer x = 4219
integer y = 180
string dataobject = "d_imt_08000_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_08000
integer x = 32
integer y = 28
integer width = 3854
integer height = 140
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

type dw_list from w_standard_print`dw_list within w_imt_08000
integer x = 32
integer y = 196
integer width = 4581
integer height = 2108
string dataobject = "d_imt_08000_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_08000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 184
integer width = 4608
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

