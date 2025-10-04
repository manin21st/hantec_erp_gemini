$PBExportHeader$w_imt_03640.srw
$PBExportComments$** 기타 자재 현황표
forward
global type w_imt_03640 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_03640
end type
type pb_2 from u_pb_cal within w_imt_03640
end type
type rr_2 from roundrectangle within w_imt_03640
end type
end forward

global type w_imt_03640 from w_standard_print
integer height = 2548
string title = "기타 자재 현황표"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_imt_03640 w_imt_03640

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, scvcod1, scvcod2, sdptno1, sdptno2, sbalsts, ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
scvcod1 = trim(dw_ip.object.cvcod1[1])
scvcod2 = trim(dw_ip.object.cvcod2[1])
sdptno1 = trim(dw_ip.object.dptno1[1])
sdptno2 = trim(dw_ip.object.dptno2[1])
sbalsts = trim(dw_ip.object.balsts[1])
ssaupj = dw_ip.object.saupj[1]

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = '.'
if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = 'ZZZZZZZZZZZZz'
if (IsNull(sdptno1) or sdptno1 = "")  then sdptno1 = '.'
if (IsNull(sdptno2) or sdptno2 = "")  then sdptno2 = 'ZZZZZZZZZZZZz'

IF dw_print.Retrieve(gs_sabu, sdate, edate, scvcod1, scvcod2, sdptno1, sdptno2, &
                    sbalsts, ssaupj) <= 0 then
	f_message_chk(50,'[기타 자재 현황표]')
	dw_ip.Setfocus()
	Return -1
END IF

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_print.ShareData(dw_list)

return 1
end function

on w_imt_03640.create
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

on w_imt_03640.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", left(f_today(), 6) + '01')
dw_ip.setitem(1, "edate", f_today())
f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_imt_03640
end type

type p_exit from w_standard_print`p_exit within w_imt_03640
end type

type p_print from w_standard_print`p_print within w_imt_03640
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03640
end type







type st_10 from w_standard_print`st_10 within w_imt_03640
end type



type dw_print from w_standard_print`dw_print within w_imt_03640
integer x = 3781
integer y = 116
string dataobject = "d_imt_03640_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03640
integer x = 9
integer y = 32
integer width = 3904
integer height = 204
string dataobject = "d_imt_03640_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
int    i_rtn

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
	i_rtn = f_get_name2("V1", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod1[1] = s_cod
	this.object.cvnam1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "cvcod2" then 	
	i_rtn = f_get_name2("V1", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod2[1] = s_cod
	this.object.cvnam2[1] = s_nam1
   return i_rtn		
elseif this.GetColumnName() = "dptno1" then 	
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.dptno1[1] = s_cod
	this.object.dptnm1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "dptno2" then 	
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.dptno2[1] = s_cod
	this.object.dptnm2[1] = s_nam1
   return i_rtn		
end if


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if This.GetColumnName() = "cvcod1" then //거래처
   gs_gubun = '1'
	open(w_vndmst_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod1[1] = gs_code
	this.object.cvnam1[1] = gs_codename	
elseif This.GetColumnName() = "cvcod2" then //거래처
   gs_gubun = '1'
	open(w_vndmst_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod2[1] = gs_code
	this.object.cvnam2[1] = gs_codename		
elseif This.GetColumnName() = "dptno1" then 
	open(w_vndmst_4_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.dptno1[1] = gs_code
	this.object.dptnm1[1] = gs_codename
elseif This.GetColumnName() = "dptno2" then 
	open(w_vndmst_4_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.dptno2[1] = gs_code
	this.object.dptnm2[1] = gs_codename
end if

end event

type dw_list from w_standard_print`dw_list within w_imt_03640
integer x = 46
integer y = 264
integer width = 4535
integer height = 2136
string dataobject = "d_imt_03640_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_03640
integer x = 645
integer y = 128
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

type pb_2 from u_pb_cal within w_imt_03640
integer x = 1083
integer y = 128
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

type rr_2 from roundrectangle within w_imt_03640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 256
integer width = 4562
integer height = 2160
integer cornerheight = 40
integer cornerwidth = 55
end type

