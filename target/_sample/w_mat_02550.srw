$PBExportHeader$w_mat_02550.srw
$PBExportComments$**입출고예정현황
forward
global type w_mat_02550 from w_standard_print
end type
end forward

global type w_mat_02550 from w_standard_print
integer width = 4635
integer height = 2452
string title = "입출고 예정현황"
end type
global w_mat_02550 w_mat_02550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string itnbr1, itnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

//if dw_list.Retrieve(gs_sabu, itnbr1, itnbr2) <= 0 then
//	f_message_chk(50,'[입출고 예정현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[입출고 예정현황]')
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_mat_02550.create
call super::create
end on

on w_mat_02550.destroy
call super::destroy
end on

type dw_list from w_standard_print`dw_list within w_mat_02550
integer y = 228
integer width = 4526
integer height = 2104
string dataobject = "d_mat_02550_02"
end type

type cb_print from w_standard_print`cb_print within w_mat_02550
end type

type cb_excel from w_standard_print`cb_excel within w_mat_02550
end type

type cb_preview from w_standard_print`cb_preview within w_mat_02550
end type

type cb_1 from w_standard_print`cb_1 within w_mat_02550
end type

type dw_print from w_standard_print`dw_print within w_mat_02550
string dataobject = "d_mat_02550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02550
integer y = 56
integer width = 4526
integer height = 140
string dataobject = "d_mat_02550_01"
end type

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "itnbr1" then
	i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return
elseif this.GetColumnName() = "itnbr2" then
	i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)

IF	this.getcolumnname() = "itnbr1"	THEN		
	open(w_itemas_popup)
	this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
	return
elseIF this.getcolumnname() = "itnbr2"	THEN		
	open(w_itemas_popup)
	this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
	return
END IF
end event

event dw_ip::ue_key;call super::ue_key;Long crow

SetNull(gs_code)
SetNull(gs_codename)
crow = this.GetRow()
IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "itnbr1"	THEN		
	   open(w_itemas_popup2)
	   this.SetItem(crow, "itnbr1", gs_code)
	   this.SetItem(crow, "itdsc1", gs_codename)
		return
   elseIF this.getcolumnname() = "itnbr2"	THEN		
	   open(w_itemas_popup2)
	   this.SetItem(crow, "itnbr2", gs_code)
	   this.SetItem(crow, "itdsc2", gs_codename)
		return
   END IF
END IF
end event

type r_1 from w_standard_print`r_1 within w_mat_02550
integer y = 224
integer width = 4534
integer height = 2112
end type

type r_2 from w_standard_print`r_2 within w_mat_02550
integer width = 4534
integer height = 148
end type

