$PBExportHeader$w_mat_02550.srw
$PBExportComments$**입출고예정현황
forward
global type w_mat_02550 from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_02550
end type
end forward

global type w_mat_02550 from w_standard_print
string title = "입출고 예정현황"
rr_1 rr_1
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
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mat_02550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_mat_02550
end type

type p_exit from w_standard_print`p_exit within w_mat_02550
end type

type p_print from w_standard_print`p_print within w_mat_02550
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_02550
end type







type st_10 from w_standard_print`st_10 within w_mat_02550
end type



type dw_print from w_standard_print`dw_print within w_mat_02550
string dataobject = "d_mat_02550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02550
integer x = 37
integer y = 12
integer width = 3515
integer height = 164
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

type dw_list from w_standard_print`dw_list within w_mat_02550
integer x = 50
integer y = 212
integer width = 4526
integer height = 2104
string dataobject = "d_mat_02550_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_mat_02550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 4553
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

