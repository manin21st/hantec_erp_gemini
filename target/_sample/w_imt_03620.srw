$PBExportHeader$w_imt_03620.srw
$PBExportComments$** 외자 납기별 품목리스트
forward
global type w_imt_03620 from w_standard_print
end type
type dw_1 from datawindow within w_imt_03620
end type
type pb_1 from u_pic_cal within w_imt_03620
end type
type pb_2 from u_pic_cal within w_imt_03620
end type
end forward

global type w_imt_03620 from w_standard_print
string title = "외자 납기별 품목 리스트"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_03620 w_imt_03620

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, scvcod1, scvcod2, sitnbr1, sitnbr2, sbaljpno1, sbaljpno2, sbalsts, &
       ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate   = trim(dw_ip.object.sdate[1])
edate   = trim(dw_ip.object.edate[1])
sitnbr1 = trim(dw_ip.object.itnbr1[1])
sitnbr2 = trim(dw_ip.object.itnbr2[1])
scvcod1 = trim(dw_ip.object.cvcod1[1])
scvcod2 = trim(dw_ip.object.cvcod2[1])
sbaljpno1 = trim(dw_ip.object.baljpno1[1])
sbaljpno2 = trim(dw_ip.object.baljpno2[1])
sbalsts = trim(dw_ip.object.balsts[1])
ssaupj = dw_ip.object.saupj[1]

if (IsNull(sdate)     or sdate = "")  then sdate = "11110101"
if (IsNull(edate)     or edate = "")  then edate = "99991231"

if (IsNull(scvcod1)   or scvcod1 = "")  then scvcod1 = "."
if (IsNull(scvcod2)   or scvcod2 = "")  then scvcod2 = "zzzzzzzzzzzzzzz"
if (IsNull(sitnbr1)   or sitnbr1 = "")  then sitnbr1 = "."
if (IsNull(sitnbr2)   or sitnbr2 = "")  then sitnbr2 = "zzzzzzzzzzzzzzz"
if (IsNull(sbaljpno1) or sbaljpno1 = "")  then sbaljpno1 = "."
if (IsNull(sbaljpno2) or sbaljpno2 = "")  then sbaljpno2 = "zzzzzzzzzzzzzzz"

//dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
//if dw_list.Retrieve(gs_sabu, sdate, edate, sitnbr1, sitnbr2, sbaljpno1, sbaljpno2, &
//                    scvcod1, scvcod2, sbalsts, ssaupj) <= 0 then
//	f_message_chk(50,'[외자 납기별 품목 리스트]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, sitnbr1, sitnbr2, sbaljpno1, sbaljpno2, &
                    scvcod1, scvcod2, sbalsts, ssaupj) <= 0 then
	f_message_chk(50,'[외자 납기별 품목 리스트]')
	dw_ip.Setfocus()
//	Return -1
END IF

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_print.ShareData(dw_list)

return 1
end function

on w_imt_03620.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
end on

on w_imt_03620.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)
dw_ip.setitem(1, "sdate", left(f_today(), 6)+'01')
dw_ip.setitem(1, "edate", f_today())
f_mod_saupj(dw_ip, 'saupj')
end event

event resize;call super::resize;dw_1.width = this.width - 70
end event

type dw_list from w_standard_print`dw_list within w_imt_03620
integer y = 400
integer width = 3489
integer height = 1964
string dataobject = "d_imt_03620_02"
end type

type cb_print from w_standard_print`cb_print within w_imt_03620
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03620
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03620
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03620
end type

type dw_print from w_standard_print`dw_print within w_imt_03620
string dataobject = "d_imt_03620_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03620
integer y = 56
integer width = 3489
integer height = 300
string dataobject = "d_imt_03620_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
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
elseif this.GetColumnName() = "itnbr1" then 	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itnbr2" then 	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itdsc1" then 	
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itdsc2" then 	
	s_nam1 = s_cod	
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
   return i_rtn	
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
end if


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if This.GetColumnName() = "itnbr1" then //품번
	open(w_itemas_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
elseif This.GetColumnName() = "itnbr2" then //품번
	open(w_itemas_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
elseif This.GetColumnName() = "cvcod1" then //거래처
	open(w_vndmst_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod1[1] = gs_code
	this.object.cvnam1[1] = gs_codename	
elseif This.GetColumnName() = "cvcod2" then //거래처
	open(w_vndmst_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod2[1] = gs_code
	this.object.cvnam2[1] = gs_codename		
elseif This.GetColumnName() = "baljpno1" then //발주번호
	open(w_poblkt_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.baljpno1[1] = gs_code
elseif This.GetColumnName() = "baljpno2" then //발주번호
	open(w_poblkt_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.baljpno2[1] = gs_code	
end if

end event

type r_1 from w_standard_print`r_1 within w_imt_03620
integer y = 396
end type

type r_2 from w_standard_print`r_2 within w_imt_03620
integer height = 308
end type

type dw_1 from datawindow within w_imt_03620
integer x = 37
integer y = 60
integer width = 3489
integer height = 96
integer taborder = 5
boolean bringtotop = true
string dataobject = "d_imt_03620_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_list.SetReDraw(False)
if gubun = "1" then //외자납기별품목리스트(발주번호별)
	dw_list.DataObject = "d_imt_03620_02"
	dw_print.DataObject = "d_imt_03620_02_p"
elseif gubun = "2" then	//외자납기별품목리스트(품목별)
	dw_list.DataObject = "d_imt_03630_02"
	dw_print.DataObject = "d_imt_03630_02_p"
end if	
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_list.ReSet()
dw_list.SetReDraw(True)

//p_print.Enabled =False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//p_preview.enabled = False
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

return
end event

type pb_1 from u_pic_cal within w_imt_03620
integer x = 663
integer y = 248
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

type pb_2 from u_pic_cal within w_imt_03620
integer x = 1106
integer y = 248
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

