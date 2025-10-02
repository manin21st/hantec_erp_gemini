$PBExportHeader$w_imt_03560.srw
$PBExportComments$** L/C 현황
forward
global type w_imt_03560 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_03560
end type
type pb_2 from u_pic_cal within w_imt_03560
end type
end forward

global type w_imt_03560 from w_standard_print
integer width = 3803
integer height = 2420
string title = "L/C 현황"
boolean maxbox = true
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_03560 w_imt_03560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, bists, wansts, itnbr1, itnbr2, sgub, scvcod1, scvcod2, swagbn, ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
bists = trim(dw_ip.object.bists[1])
wansts = trim(dw_ip.object.wansts[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
sgub  = trim(dw_ip.object.sort[1])
scvcod1  = trim(dw_ip.object.cvcod1[1])
scvcod2  = trim(dw_ip.object.cvcod2[1])
swagbn   = trim(dw_ip.object.wagbn[1])
ssaupj   = dw_ip.object.saupj[1]

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = "."
if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = "ZZZZZZZZZZZZZZZ"

if bists = "Y" then //비용출력여부 'Y' : d_imt_03560_03 + d_imt_03560_02(Nested Report)
   if sgub = '1' then 
		dw_list.DataObject = 'd_imt_03560_04'
		dw_print.DataObject = 'd_imt_03560_04_p'
	else
		dw_list.DataObject = 'd_imt_03560_06'
		dw_print.DataObject = 'd_imt_03560_06'
   end if		
else                //비용출력여부 'N'
   if sgub = '1' then 
		dw_list.DataObject = 'd_imt_03560_03'
		dw_print.DataObject = 'd_imt_03560_03_p'
	else
		dw_list.DataObject = 'd_imt_03560_05'
		dw_print.DataObject = 'd_imt_03560_05_p'
   end if		
end if	
dw_print.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_list.SetRedraw(False)
dw_list.SetFilter("") //수량완료기준 => ALL

if wansts = "2" then  //수량완료기준 => 완료 : L/C OPEN 수량 = B/L 수량
   dw_list.SetFilter("polcdt_lcqty = polcdt_blqty")
elseif wansts = "3" then  //수량완료기준 => 미완료 : L/C OPEN 수량 <> B/L 수량
	dw_list.SetFilter("polcdt_lcqty <> polcdt_blqty")
end if	
dw_list.Filter( )

////미착품수량 = L/C OPEN수량 - B/L수량 으로 계산
//if dw_list.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2, scvcod1, scvcod2, &
//                    swagbn, ssaupj) <= 0 then
//	f_message_chk(50,'[L/C 현황]')
//	dw_ip.Setfocus()
//	dw_list.SetRedraw(True)
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2, scvcod1, scvcod2, &
                    swagbn, ssaupj) <= 0 then
	f_message_chk(50,'[L/C 현황]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_print.ShareData(dw_list)

dw_list.SetRedraw(True)

return 1
end function

on w_imt_03560.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_03560.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", f_afterday(f_today(), -60))
dw_ip.setitem(1, "edate", f_today())
end event

event resize;r_1.width = this.width - 60
r_1.height = this.height - r_1.y - 65
dw_list.width = this.width - 70
dw_list.height = this.height - dw_list.y - 70
end event

type dw_list from w_standard_print`dw_list within w_imt_03560
integer width = 3690
integer height = 1964
string dataobject = "d_imt_03560_03"
end type

type cb_print from w_standard_print`cb_print within w_imt_03560
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03560
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03560
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03560
end type

type dw_print from w_standard_print`dw_print within w_imt_03560
string dataobject = "d_imt_03560_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03560
integer x = 18
integer y = 52
integer width = 3808
integer height = 212
string dataobject = "d_imt_03560_01"
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
elseif this.GetColumnName() = "cvcod1" then 	
	i_rtn = f_get_name2("거래처", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod1[1] = s_cod
	this.object.cvcod1[1] = s_nam1
   return i_rtn	
elseif this.GetColumnName() = "cvcod2" then 	
	i_rtn = f_get_name2("거래처", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod2[1] = s_cod
	this.object.cvcod2[1] = s_nam1
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
elseif This.GetColumnName() = "cvcod1" then //거래처
	open(w_vndmst_popup)
	this.object.cvcod1[1] = gs_code
	this.object.cvnam1[1] = gs_codename	
elseif This.GetColumnName() = "cvcod2" then //거래처
	open(w_vndmst_popup)
	this.object.cvcod2[1] = gs_code
	this.object.cvnam2[1] = gs_codename		
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

type r_1 from w_standard_print`r_1 within w_imt_03560
integer width = 3698
end type

type r_2 from w_standard_print`r_2 within w_imt_03560
boolean visible = false
end type

type pb_1 from u_pic_cal within w_imt_03560
integer x = 1655
integer y = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_03560
integer x = 2112
integer y = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

