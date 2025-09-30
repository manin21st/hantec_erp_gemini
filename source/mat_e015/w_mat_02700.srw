$PBExportHeader$w_mat_02700.srw
$PBExportComments$**출고구분별 출고현황
forward
global type w_mat_02700 from w_standard_print
end type
end forward

global type w_mat_02700 from w_standard_print
boolean TitleBar=true
string Title="출고구분별 출고현황"
end type
global w_mat_02700 w_mat_02700

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_fyymm, s_tyymm, sittyp

if dw_ip.AcceptText() = -1 then
   dw_ip.SetFocus()
	return -1
end if	

sittyp  = trim(dw_ip.object.ittyp[1])
s_fyymm = trim(dw_ip.object.fr_yymm[1])
s_tyymm = trim(dw_ip.object.to_yymm[1])

if (IsNull(sittyp) or sittyp = "")  then 
	f_message_chk(30, "[품목구분]")
	dw_ip.SetColumn("ittyp")
	dw_ip.Setfocus()
	return -1
end if
if (IsNull(s_fyymm) or s_fyymm = "")  then 
	f_message_chk(30, "[출고기간 FROM]")
	dw_ip.SetColumn("fr_yymm")
	dw_ip.Setfocus()
	return -1
end if
if (IsNull(s_Tyymm) or s_Tyymm = "")  then 
	f_message_chk(30, "[출고기간 TO]")
	dw_ip.SetColumn("to_yymm")
	dw_ip.Setfocus()
	return -1
end if

if dw_list.Retrieve(sittyp, s_fyymm, s_tyymm) <= 0 then
	f_message_chk(50,'[품목/수불 구분별 출고현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_mat_02700.create
call super::create
end on

on w_mat_02700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1, "fr_yymm", left(f_today(), 6))
dw_ip.setitem(1, "to_yymm", left(f_today(), 6))
end event

type dw_ip from w_standard_print`dw_ip within w_mat_02700
int X=50
int Y=64
int Width=736
int Height=392
string DataObject="d_mat_02700"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText()) 

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "cvcod1" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)
	this.SetItem(1,"cvnam1",s_nam1)
	return i_rtn
elseif this.GetColumnName() = "cvcod2" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)
	this.SetItem(1,"cvnam2",s_nam1)
	return i_rtn
elseif this.GetColumnName() = "sitnbr" then
	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "eitnbr" then
	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	this.object.eitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "sitdsc" then
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "eitdsc" then
	s_nam1 = s_cod	
	i_rtn = f_get_name2("품명","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	this.object.eitdsr[1] = s_nam1
	return i_rtn	
end if
	


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return
ELSEIF this.getcolumnname() = "sitnbr"	THEN		
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "sitnbr", gs_code)
	this.SetItem(1, "sitdsc", gs_codename)
	return	
ELSEIF this.getcolumnname() = "eitnbr"	THEN		
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "eitnbr", gs_code)
	this.SetItem(1, "eitdsc", gs_codename)
	return		
END IF
end event

type dw_list from w_standard_print`dw_list within w_mat_02700
string DataObject="d_mat_02700_1"
end type

