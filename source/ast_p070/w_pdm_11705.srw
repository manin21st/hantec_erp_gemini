$PBExportHeader$w_pdm_11705.srw
$PBExportComments$** 표준공정현황 - [금형/치공구별 설비현황]
forward
global type w_pdm_11705 from w_standard_print
end type
end forward

global type w_pdm_11705 from w_standard_print
string title = "표준공정현황 - [금형/치공구별 설비현황]"
end type
global w_pdm_11705 w_pdm_11705

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2

if dw_ip.AcceptText() = -1 then return -1

cod1 = trim(dw_ip.object.cod1[1])
cod2 = trim(dw_ip.object.cod2[1])

if (IsNull(cod1) or cod1 = "")  then cod1 = "."
if (IsNull(cod2) or cod2 = "")  then cod2 = "zzzzzzzzzzzzzzz"

if dw_print.Retrieve(cod1, cod2) <= 0 then
	f_message_chk(50, '')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_pdm_11705.create
call super::create
end on

on w_pdm_11705.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_pdm_11705
end type

type p_exit from w_standard_print`p_exit within w_pdm_11705
end type

type p_print from w_standard_print`p_print within w_pdm_11705
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11705
end type







type st_10 from w_standard_print`st_10 within w_pdm_11705
end type



type dw_print from w_standard_print`dw_print within w_pdm_11705
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11705
integer x = 50
integer y = 100
integer width = 709
integer height = 448
string dataobject = "d_pdm_11705_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'cod1' then   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cod1",s_cod)		
	this.setitem(1,"nam1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cod2' then   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cod2",s_cod)		
	this.setitem(1,"nam2",s_nam1)
	return i_rtn
end if	

end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cod1"	THEN		
	open(w_itemas_popup)
	this.SetItem(1, "cod1", gs_code)
	this.SetItem(1, "nam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cod2" THEN		
	open(w_itemas_popup)
	this.SetItem(1, "cod2", gs_code)
	this.SetItem(1, "nam2", gs_codename)
	return
END IF

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdm_11705
integer y = 16
string dataobject = "d_pdm_11705_02"
end type

