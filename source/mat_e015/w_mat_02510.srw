$PBExportHeader$w_mat_02510.srw
$PBExportComments$** 출고현황-[PROJECT No 별]
forward
global type w_mat_02510 from w_standard_print
end type
end forward

global type w_mat_02510 from w_standard_print
string title = "출고 현황-[PROJECT No 별]"
end type
global w_mat_02510 w_mat_02510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, spjtno, epjtno //iogbn, depot, scvcod1, scvcod2, sitnbr1, sitnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
spjtno = trim(dw_ip.object.fr_pjtno[1])
epjtno = trim(dw_ip.object.to_pjtno[1])
//iogbn = trim(dw_ip.object.iogbn[1])
//depot = trim(dw_ip.object.depot[1])
//scvcod1 = trim(dw_ip.object.cvcod1[1])
//scvcod2 = trim(dw_ip.object.cvcod2[1])
//sitnbr1 = trim(dw_ip.object.sitnbr[1])
//sitnbr2 = trim(dw_ip.object.eitnbr[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(spjtno) or spjtno = "")  then spjtno = "."
if (IsNull(epjtno) or epjtno = "")  then epjtno = "zzzzzzzzzzzzzzzzzzzz"
//if (IsNull(iogbn) or iogbn = "")  then iogbn = '%' 
//
//if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = '.' 
//if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = 'ZZZZZZ' 
//if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = '.' 
//if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = 'ZZZZZZ' 

//if (IsNull(depot) or depot = "")  then 
//	f_message_chk(30, "[기준창고]")
//	dw_ip.SetColumn("depot")
//	dw_ip.Setfocus()
//	return -1
//end if

//dw_list.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

//if dw_list.Retrieve(gs_sabu, sdate, edate, spjtno, epjtno) <= 0 then
//	f_message_chk(50,'[출고현황-PROJECT No 별]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, spjtno, epjtno) <= 0 then
	f_message_chk(50,'[출고현황-PROJECT No 별]')
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

dw_print.ShareData(dw_list)

return 1
end function

on w_mat_02510.create
call super::create
end on

on w_mat_02510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", left(f_today(), 6)+'01')
dw_ip.setitem(1, "edate", f_today())
end event

type p_preview from w_standard_print`p_preview within w_mat_02510
end type

type p_exit from w_standard_print`p_exit within w_mat_02510
end type

type p_print from w_standard_print`p_print within w_mat_02510
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_02510
end type







type st_10 from w_standard_print`st_10 within w_mat_02510
end type



type dw_print from w_standard_print`dw_print within w_mat_02510
string dataobject = "d_mat_02510_02"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02510
integer x = 37
integer y = 0
integer width = 3643
integer height = 296
string dataobject = "d_mat_02510_01"
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

type dw_list from w_standard_print`dw_list within w_mat_02510
string dataobject = "d_mat_02510_02"
end type

