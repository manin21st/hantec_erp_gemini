$PBExportHeader$w_imt_03710.srw
$PBExportComments$** 단가마스타 대 B/L 마감 단가 비교
forward
global type w_imt_03710 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_03710
end type
type pb_2 from u_pic_cal within w_imt_03710
end type
end forward

global type w_imt_03710 from w_standard_print
string title = "B/L마감 단가 비교"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_03710 w_imt_03710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, itnbr1, itnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

//if dw_list.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_imt_03710.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_03710.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", LEFT(f_today(), 6) + '01' )
dw_ip.setitem(1, "edate", f_today())
end event

type dw_list from w_standard_print`dw_list within w_imt_03710
integer width = 3489
integer height = 1964
string dataobject = "d_imt_03710_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_03710
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03710
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03710
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03710
end type

type dw_print from w_standard_print`dw_print within w_imt_03710
integer x = 4169
integer y = 184
string dataobject = "d_imt_03710_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03710
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_03710_a"
end type

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

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
elseif this.GetColumnName() = "itnbr1" then 	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itdsc1" then 	
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
   return i_rtn	
elseif this.GetColumnName() = "itnbr2" then 	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itdsc2" then 	
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
   return i_rtn		
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if This.GetColumnName() = "itnbr1" then //품번
	open(w_itemas_popup)
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
elseif This.GetColumnName() = "itnbr2" then //품번
	open(w_itemas_popup)
	this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
end if

end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if keydown(keyF2!) THEN	
	if This.GetColumnName() = "itnbr1" then //품번
		open(w_itemas_popup2)
		this.object.itnbr1[1] = gs_code
		this.object.itdsc1[1] = gs_codename
	elseif This.GetColumnName() = "itnbr2" then //품번
		open(w_itemas_popup2)
		this.object.itnbr2[1] = gs_code
		this.object.itdsc2[1] = gs_codename
	end if
end if	
end event

type r_1 from w_standard_print`r_1 within w_imt_03710
end type

type r_2 from w_standard_print`r_2 within w_imt_03710
end type

type pb_1 from u_pic_cal within w_imt_03710
integer x = 704
integer y = 112
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

type pb_2 from u_pic_cal within w_imt_03710
integer x = 1134
integer y = 112
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

