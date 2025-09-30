$PBExportHeader$w_qct_04690.srw
$PBExportComments$**불량원인별 A/S 현황
forward
global type w_qct_04690 from w_standard_dw_graph
end type
type dw_1 from u_key_enter within w_qct_04690
end type
end forward

global type w_qct_04690 from w_standard_dw_graph
string title = "불량원인별 A/S 현황"
dw_1 dw_1
end type
global w_qct_04690 w_qct_04690

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve1 ()
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
end if	

return i_rtn

end function

public function integer wf_retrieve2 ();string ym1, ym2, itnbr, itdsc

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym1 = trim(dw_ip.object.ym1[1])
ym2 = trim(dw_ip.object.ym2[1])
itnbr = trim(dw_ip.object.itnbr[1])
itdsc = trim(dw_ip.object.itdsc[1])

if IsNull(itnbr) or itnbr = "" or IsNull(itdsc) or itdsc = "" then 
   f_message_chk(30, "[품번]")
   dw_ip.SetColumn("itnbr")
	dw_ip.SetFocus()
	return -1
end if	

if (IsNull(ym1) or ym1 = "")  then ym1 = "100001"
if (IsNull(ym2) or ym2 = "")  then ym2 = "999912"

dw_list.object.txt_ym.text = String(ym1,"@@@@년@@월") + " - " + String(ym2,"@@@@년@@월")
dw_list.object.txt_itnbr.text = itnbr + " " + itdsc

if dw_list.Retrieve(gs_sabu, ym1, ym2, itnbr) <= 0 then
	f_message_chk(50,'[불량원인별 A/S 추이도]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_retrieve1 ();string sdate, edate, ascau, itnbr1, itnbr2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
ascau = trim(dw_ip.object.ascau[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

if (IsNull(ascau) or ascau = "")  then 
	ascau = "%"
else
	ascau = ascau + "%"
end if	

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@ - ") + String(edate,"@@@@.@@.@@") 
dw_list.object.txt_itnbr.text = itnbr1 + " - " + itnbr2
if dw_list.Retrieve(gs_sabu, sdate, edate, ascau, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[불량원인별 A/S 현황]')
	dw_ip.Setfocus()
	dw_list.insertrow(0)
//	return -1
end if

return 1
end function

on w_qct_04690.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_qct_04690.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.ReSet()
dw_1.InsertRow(0)
end event

type p_exit from w_standard_dw_graph`p_exit within w_qct_04690
end type

type p_print from w_standard_dw_graph`p_print within w_qct_04690
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_04690
end type

event p_retrieve::clicked;call super::clicked;string gubun

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if

gubun = trim(dw_1.object.gubun[1])

if gubun <> "2" then
   pb_color.Enabled =False
   pb_graph.Enabled =False
   pb_space.Enabled =False
   pb_title.Enabled =False
end if	
end event

type st_window from w_standard_dw_graph`st_window within w_qct_04690
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_04690
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_04690
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_04690
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_04690
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_04690
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_04690
integer x = 1070
integer y = 12
integer width = 2798
integer height = 236
string dataobject = "d_qct_04590_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
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
elseif (this.GetColumnName() = "itnbr1") Then //품번
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn	
elseif (this.GetColumnName() = "itnbr2") Then //품번
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn	
elseif this.GetColumnName() = "ym1" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[시작년월]")
		this.object.ym1[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "ym2" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[끝년월]")
		this.object.ym2[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "itnbr" then 
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	return i_rtn
end if

return
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "itnbr" then //품번
	open(w_itemas_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
   this.object.itnbr[1] = gs_code
   this.object.itdsc[1] = gs_codename
elseif	this.getcolumnname() = "itnbr1" then //품번
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.itnbr1[1] = gs_code
   this.object.itdsc1[1] = gs_codename
elseif	this.getcolumnname() = "itnbr2" then //품번
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.itnbr2[1] = gs_code
   this.object.itdsc2[1] = gs_codename
end if	


end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_04690
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_04690
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_04690
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_04690
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_04690
integer y = 260
integer width = 4562
string dataobject = "d_qct_04590_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_04690
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_04690
integer y = 248
end type

type dw_1 from u_key_enter within w_qct_04690
integer x = 18
integer y = 16
integer width = 1070
integer height = 224
integer taborder = 5
boolean bringtotop = true
string dataobject = "d_qct_04690_00"
boolean border = false
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //불량원인별A/S현황
	dw_ip.DataObject = "d_qct_04590_01"
	dw_list.DataObject = "d_qct_04590_02"
elseif gubun = "2" then	//불량원인별A/S추이현황
	dw_ip.DataObject = "d_qct_04690_01"
	dw_list.DataObject = "d_qct_04690_02"
end if	

dw_ip.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetReDraw(True)

dw_list.SetTransObject(SQLCA)
dw_list.ReSet()
dw_list.SetReDraw(True)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

return
end event

