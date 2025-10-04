$PBExportHeader$w_imt_03570.srw
$PBExportComments$** B/L 현황
forward
global type w_imt_03570 from w_standard_print
end type
type dw_1 from datawindow within w_imt_03570
end type
type pb_1 from u_pb_cal within w_imt_03570
end type
type pb_2 from u_pb_cal within w_imt_03570
end type
type rr_1 from roundrectangle within w_imt_03570
end type
end forward

global type w_imt_03570 from w_standard_print
string title = "B/L 현황"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_03570 w_imt_03570

type variables
String     is_RateGub       //환율 사용여부(1:일일,2:예측)            

end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
end prototypes

public function integer wf_retrieve ();string  gubun
integer i_rtn

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

gubun = trim(dw_1.object.gubun[1])

if gubun = "1" then
	i_rtn  = wf_retrieve1()
elseif gubun = "2" then
	i_rtn  = wf_retrieve2()
elseif gubun = "3" then
	i_rtn  = wf_retrieve3()
end if

return i_rtn
end function

public function integer wf_retrieve1 ();string sdate, edate, bists, itnbr1, itnbr2, cvcod1, cvcod2, ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
bists = trim(dw_ip.object.bists[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
ssaupj = dw_ip.object.saupj[1]

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZZZZZZZZZZ"

if (IsNull(bists) or bists = "")  then 
	f_message_chk(30, "[비용출력여부]")
	dw_ip.SetColumn("bists")
	dw_ip.Setfocus()
	return -1
end if	

if bists = "Y" then 
	dw_list.DataObject = 'd_imt_03570_04'
	dw_print.DataObject = 'd_imt_03570_04'
else
	dw_list.DataObject = 'd_imt_03570_03'
	dw_print.DataObject = 'd_imt_03570_03_p'
end if	

dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

if bists = "Y" then 
	if dw_print.Retrieve(gs_sabu, sdate, edate, cvcod1, cvcod2, ssaupj) <= 0 then
		f_message_chk(50,'[B/L 현황]')
		dw_ip.Setfocus()
		return -1
	end if
else
	if dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2, cvcod1, cvcod2, ssaupj) <= 0 then
		f_message_chk(50,'[B/L 현황]')
		dw_ip.Setfocus()
		return -1
	end if
end if	

dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve2 ();string sdate, edate, cvcod1, cvcod2,  ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	


sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
ssaupj = dw_ip.object.saupj[1]


if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
if dw_print.Retrieve(gs_sabu, sdate, edate, is_today, is_rategub, cvcod1, cvcod2, ssaupj) <= 0 then
   	f_message_chk(50,'[미통관 현황]')
		dw_ip.Setfocus()
	   return -1
end if
dw_print.ShareData(dw_list)
return 1
end function

public function integer wf_retrieve3 ();string sdate, edate, cvcod1, cvcod2,  ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
ssaupj = dw_ip.object.saupj[1]

if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
if dw_print.Retrieve(gs_sabu, sdate, edate, cvcod1, cvcod2, ssaupj) <= 0 then
   	f_message_chk(50,'[통관내역 현황]')
		dw_ip.Setfocus()
	   return -1
end if
dw_print.ShareData(dw_list)
return 1
end function

on w_imt_03570.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_imt_03570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_ip.SetItem(1, 'sdate', Left(is_today,6) + '01')
dw_ip.SetItem(1, 'edate', is_today)
f_mod_saupj(dw_ip, 'saupj')
// 환경설정에서 환율사용여부 검색
SELECT DATANAME
  INTO :is_RateGub
  FROM SYSCNFG  
 WHERE SYSGU = 'Y' AND SERIAL = 27 AND  LINENO = '1'   ;

if sqlca.sqlcode <> 0 then is_RateGub = '2'

end event

type p_preview from w_standard_print`p_preview within w_imt_03570
integer x = 4069
end type

type p_exit from w_standard_print`p_exit within w_imt_03570
integer x = 4416
end type

type p_print from w_standard_print`p_print within w_imt_03570
integer x = 4242
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03570
integer x = 3895
end type







type st_10 from w_standard_print`st_10 within w_imt_03570
end type



type dw_print from w_standard_print`dw_print within w_imt_03570
integer x = 3794
integer y = 128
string dataobject = "d_imt_03570_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03570
integer y = 60
integer width = 3735
integer height = 248
integer taborder = 20
string dataobject = "d_imt_03570_01"
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

return
end event

event dw_ip::itemerror;return 1
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
end if

end event

type dw_list from w_standard_print`dw_list within w_imt_03570
integer x = 55
integer y = 328
integer width = 4521
integer height = 1980
string dataobject = "d_imt_03570_03"
boolean border = false
end type

type dw_1 from datawindow within w_imt_03570
integer x = 46
integer y = 32
integer width = 3735
integer height = 84
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_03570_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //B/L현황
   dw_ip.DataObject = "d_imt_03570_01"
	dw_list.DataObject = "d_imt_03570_03"
	dw_print.DataObject = "d_imt_03570_03_p"
elseif gubun = "2" then	//미통관현황표
	dw_ip.DataObject = "d_imt_03610_01"
	dw_list.DataObject = "d_imt_03610_02"
	dw_print.DataObject = "d_imt_03610_02_p"
elseif gubun = "3" then // 통관내역 현황
	dw_ip.DataObject = "d_imt_03610_03"
	dw_list.DataObject = "d_imt_03570_05"
	dw_print.DataObject = "d_imt_03570_05_p"
end if	
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'sdate', Left(is_today,6) + '01')
dw_ip.SetItem(1, 'edate', is_today)
f_mod_saupj(dw_ip,'saupj')
dw_ip.SetReDraw(True)
dw_list.SetReDraw(True)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'


end event

type pb_1 from u_pb_cal within w_imt_03570
integer x = 654
integer y = 204
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

type pb_2 from u_pb_cal within w_imt_03570
integer x = 1111
integer y = 204
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

type rr_1 from roundrectangle within w_imt_03570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 324
integer width = 4544
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

