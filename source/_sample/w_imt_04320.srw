$PBExportHeader$w_imt_04320.srw
$PBExportComments$수입진행 현황
forward
global type w_imt_04320 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_04320
end type
type pb_2 from u_pb_cal within w_imt_04320
end type
type rr_2 from roundrectangle within w_imt_04320
end type
end forward

global type w_imt_04320 from w_standard_print
string title = "수입진행 현황"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_imt_04320 w_imt_04320

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve2 ()
end prototypes

public function integer wf_retrieve ();string  gubun
integer i_rtn 

i_rtn = wf_retrieve2()

return i_rtn
end function

public function integer wf_retrieve2 ();string sdate, edate, cvcod1, cvcod2, itnbr1, itnbr2, slocal

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
sLocal = dw_ip.object.local_yn[1]

if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "zzzzzzzzzzzzzzz"
if (IsNull(sdate) or sdate = "")  then 
	sdate = "11110101"
elseif f_datechk(sdate) = -1 then
	return -1
end if	
if (IsNull(edate) or edate = "")  then 
	edate = "99991231"
elseif f_datechk(edate) = -1 then
	return -1
end if	

if sLocal = 'Y' then 
	dw_list.DataObject = "d_imt_04320_1"
	dw_print.DataObject = "d_imt_04320_1"
elseif sLocal = 'N' then 
	dw_list.DataObject = "d_imt_04320_2"
	dw_print.DataObject = "d_imt_04320_2"
else
	dw_list.DataObject = "d_imt_04320_3"
	dw_print.DataObject = "d_imt_04320_3_p"
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
	
//if dw_list.Retrieve(gs_sabu, cvcod1, cvcod2, sdate, edate, itnbr1, itnbr2) <= 0 then
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, cvcod1, cvcod2, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[수입진행 현황]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_imt_04320.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_imt_04320.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_imt_04320
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_imt_04320
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_imt_04320
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04320
integer x = 3909
end type







type st_10 from w_standard_print`st_10 within w_imt_04320
end type



type dw_print from w_standard_print`dw_print within w_imt_04320
integer x = 3982
integer y = 192
string dataobject = "d_imt_04320_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04320
integer x = 14
integer y = 32
integer width = 3703
integer height = 212
integer taborder = 20
string dataobject = "d_imt_04320"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.gettext())

if this.getcolumnname() = 'itnbr1' then //품번(FROM)  
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"itnbr1",s_cod)		
	this.setitem(1,"itdsc1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'itnbr2' then //품번(TO)  
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"itnbr2",s_cod)		
	this.setitem(1,"itdsc2",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'itdsc1' then //품번(FROM)  
	i_rtn = f_get_name2("품명", "N", s_nam1, s_cod, s_nam2)
	this.setitem(1,"itnbr1",s_nam1)		
	this.setitem(1,"itdsc1",s_cod)
	return i_rtn
elseif this.getcolumnname() = 'itdsc2' then //품번(FROM)  
	i_rtn = f_get_name2("품명", "N", s_nam1, s_cod, s_nam2)
	this.setitem(1,"itnbr2",s_nam1)		
	this.setitem(1,"itdsc2",s_cod)
	return i_rtn
elseif this.getcolumnname() = 'cvcod1' then //거래처코드(FROM)  
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1",s_cod)		
	this.setitem(1,"cvnam1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then //거래처코드(TO)  
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod2",s_cod)		
	this.setitem(1,"cvnam2",s_nam1)
	return i_rtn
elseif this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

return
end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
IF this.getcolumnname() = "itnbr1"	THEN //품번(FROM)		
   gs_gubun = '3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
	return
ELSEIF this.getcolumnname() = "itnbr2"	THEN //품번(TO)		
   gs_gubun = '3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod1"	THEN //거래처코드(FROM)		
   gs_gubun = '2'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN //거래처코드(TO)		
   gs_gubun = '2'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return	
END IF

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "itnbr1"	THEN //품번(FROM)		
	   open(w_itemas_popup2)
		this.SetItem(1, "itnbr1", gs_code)
	   this.SetItem(1, "itdsc1", gs_codename)
		return
   ELSEIF this.getcolumnname() = "itnbr2" THEN //품번(TO)		
	   open(w_itemas_popup2)
		this.SetItem(1, "itnbr2", gs_code)
	   this.SetItem(1, "itdsc2", gs_codename)
		return
   END IF
END IF  
end event

type dw_list from w_standard_print`dw_list within w_imt_04320
integer x = 32
integer y = 272
integer width = 4558
integer height = 2032
string dataobject = "d_imt_04320_3"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_04320
integer x = 599
integer y = 44
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04320
integer x = 1042
integer y = 44
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_2 from roundrectangle within w_imt_04320
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 268
integer width = 4581
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

