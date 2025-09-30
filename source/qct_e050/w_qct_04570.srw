$PBExportHeader$w_qct_04570.srw
$PBExportComments$** 제품별 A/S 현황
forward
global type w_qct_04570 from w_standard_dw_graph
end type
type dw_1 from u_key_enter within w_qct_04570
end type
end forward

global type w_qct_04570 from w_standard_dw_graph
string title = "제품별 A/S 현황"
dw_1 dw_1
end type
global w_qct_04570 w_qct_04570

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve4 ()
end prototypes

public function integer wf_retrieve ();string gubun
Integer i_rtn

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if

gubun = trim(dw_1.object.gubun[1])

if gubun = "1" then
   i_rtn = wf_retrieve1()
elseif gubun = "2" then
   i_rtn = wf_retrieve2()
elseif gubun = "3" then
   i_rtn = wf_retrieve3()
elseif gubun = "4" then
   i_rtn = wf_retrieve4()
end if	

return i_rtn

end function

public function integer wf_retrieve1 ();string sdate, edate, sitcls, eitcls, pym, cym

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
sitcls = trim(dw_ip.object.sitcls[1])
eitcls = trim(dw_ip.object.eitcls[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11111111"
if (IsNull(edate) or edate = "")  then edate = "99999999"
if (IsNull(sitcls) or sitcls = "")  then sitcls = "."
if (IsNull(eitcls) or eitcls = "")  then eitcls = "ZZZZZZZ"

cym = Mid(f_today(),1,6)
pym = f_aftermonth(cym, -6)

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@ - ") + String(edate,"@@@@.@@.@@") 
if dw_list.Retrieve(gs_sabu, sdate, edate, pym, cym, sitcls, eitcls) <= 0 then
	f_message_chk(50,'[제품별 A/S 현황]')
	dw_ip.Setfocus()
	dw_list.insertrow(0)
//	return -1
end if

return 1

end function

public function integer wf_retrieve2 ();string sdate, edate, itnbr1, itnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11111111"
if (IsNull(edate) or edate = "")  then edate = "99999999"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@ - ") + String(edate,"@@@@.@@.@@") 
if dw_list.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[제품별 A/S 불량 내역]')
	dw_ip.Setfocus()
	dw_list.insertrow(0)
//	return -1
end if

return 1
end function

public function integer wf_retrieve3 ();string sdate, edate, gubun, sitcls, eitcls

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
gubun = trim(dw_ip.object.gubun[1])
sitcls = trim(dw_ip.object.sitcls[1])
eitcls = trim(dw_ip.object.eitcls[1])

if (IsNull(gubun) or gubun = "")  then 
	f_message_chk(30,'[구분]')
	dw_ip.SetColumn("gubun")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(sdate) or sdate = "")  then sdate = "11111111"
if (IsNull(edate) or edate = "")  then edate = "99999999"
if (IsNull(sitcls) or sitcls = "")  then sitcls = "."
if (IsNull(eitcls) or eitcls = "")  then eitcls = "ZZZZ"

if gubun = "2" then     //제품군
	dw_list.DataObject = 'd_qct_04570_03'
elseif gubun = "3" then //시리즈
	dw_list.DataObject = 'd_qct_04570_04'
else                    //전체
	dw_list.DataObject = 'd_qct_04570_02'
end if

dw_list.SetTransObject(SQLCA)
dw_list.object.txt_ymd.text = String(trim(dw_ip.object.sdate[1]), "@@@@.@@.@@") + " - " + &
                              String(trim(dw_ip.object.edate[1]),"@@@@.@@.@@") 
if gubun = "3" then
   if dw_list.Retrieve(gs_sabu, sdate, edate, sitcls, eitcls) <= 0 then
	   f_message_chk(50,'[제품별 A/S 불량내역(그래프)]')
	   dw_ip.Setfocus()
		dw_list.insertrow(0)
//	   return -1
   end if
else
	if dw_list.Retrieve(gs_sabu, sdate, edate) <= 0 then
	   f_message_chk(50,'[제품별 A/S 불량내역(그래프)]')
	   dw_ip.Setfocus()
		dw_list.insertrow(0)
//	   return -1
   end if
end if
return 1
end function

public function integer wf_retrieve4 ();string gubun, sdate, edate, itnbr1, itnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gubun = trim(dw_ip.object.gubun[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if gubun = "1" then //대리점순
   dw_list.DataObject = "d_qct_04580_02"
else                //제품순
	dw_list.DataObject = "d_qct_04580_03"
end if
dw_list.SetTransObject(SQLCA)

if (IsNull(sdate) or sdate = "")  then sdate = "11111111"
if (IsNull(edate) or edate = "")  then edate = "99999999"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@ - ") + String(edate,"@@@@.@@.@@") 
if dw_list.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[제품별 A/S 불량 내역]')
	dw_ip.Setfocus()
	dw_list.insertrow(0)
//	return -1
end if

return 1
end function

on w_qct_04570.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_qct_04570.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.ReSet()
dw_1.InsertRow(0)
end event

type p_exit from w_standard_dw_graph`p_exit within w_qct_04570
end type

type p_print from w_standard_dw_graph`p_print within w_qct_04570
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_04570
end type

event p_retrieve::clicked;call super::clicked;string gubun

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if

gubun = trim(dw_1.object.gubun[1])

if gubun <> "3" then
   pb_color.Enabled =False
   pb_graph.Enabled =False
   pb_space.Enabled =False
   pb_title.Enabled =False
end if	
end event

type st_window from w_standard_dw_graph`st_window within w_qct_04570
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_04570
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_04570
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_04570
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_04570
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_04570
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_04570
integer x = 1883
integer y = 36
integer width = 2176
integer height = 208
integer taborder = 20
string dataobject = "d_qct_04550_01"
end type

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
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
	i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "itnbr2" then 
	i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
end if


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "sitcls" then //시리즈1
	open(w_itnct_popup)
	if isnull(gs_code) or gs_code = "" then return
   this.object.sitcls[1] = gs_code
elseif this.getcolumnname() = "eitcls" then //시리즈2
	open(w_itnct_popup)
	if isnull(gs_code) or gs_code = "" then return
   this.object.eitcls[1] = gs_code
elseif this.GetColumnName() = 'itnbr1' then
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"itnbr1",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'itnbr2' then
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"itnbr2",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	

end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_04570
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_04570
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_04570
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_04570
integer y = 196
integer height = 48
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_04570
integer x = 46
integer y = 280
integer height = 2044
string dataobject = "d_qct_04550_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_04570
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_04570
integer x = 27
integer y = 268
integer height = 2072
end type

type dw_1 from u_key_enter within w_qct_04570
integer y = 32
integer width = 1879
integer height = 208
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_04570_00"
boolean border = false
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //제품별A/S현황
	dw_ip.DataObject = "d_qct_04550_01"
	dw_list.DataObject = "d_qct_04550_02"
elseif gubun = "2" then	//제품별A/S불량내역
	dw_ip.DataObject = "d_qct_04560_01"
	dw_list.DataObject = "d_qct_04560_02"
elseif gubun = "3" then	//제품별A/S불량내역(그래프)
	dw_ip.DataObject = "d_qct_04570_01"
	dw_list.DataObject = "d_qct_04570_02"
elseif gubun = "4" then	//제품별불량원인현황
	dw_ip.DataObject = "d_qct_04580_01"
	dw_list.DataObject = "d_qct_04580_02"
end if	

dw_ip.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetReDraw(True)

dw_list.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

end event

