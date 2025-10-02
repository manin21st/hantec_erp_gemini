$PBExportHeader$w_imt_02640.srw
$PBExportComments$** 업체별 불량율 현황/불량율관리대장/불량발생현황 및 조치현황
forward
global type w_imt_02640 from w_standard_print
end type
type ddlb_dwchoice from dropdownlistbox within w_imt_02640
end type
type pb_1 from u_pic_cal within w_imt_02640
end type
type pb_2 from u_pic_cal within w_imt_02640
end type
end forward

global type w_imt_02640 from w_standard_print
integer width = 5541
string title = "업체별 불량율 현황/불량율 관리대장/불량발생및 조치현황"
ddlb_dwchoice ddlb_dwchoice
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_02640 w_imt_02640

forward prototypes
public function integer wf_retrieve_02650 ()
public function integer wf_retrieve_02660 ()
public function integer wf_retrieve_02640 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve_02650 ();String s_frdate, s_todate, cvcod1, cvcod2, emp1, emp2
double drate

dw_ip.AcceptText()

s_frdate = trim(dw_ip.GetItemString(1, "fr_date"))
s_todate = trim(dw_ip.GetItemString(1, "to_date"))
cvcod1 = trim(dw_ip.GetItemString(1, "cvcod1"))
cvcod2 = trim(dw_ip.GetItemString(1, "cvcod2"))
emp1 = trim(dw_ip.GetItemString(1, "emp1"))
emp2 = trim(dw_ip.GetItemString(1, "emp2"))

IF s_frdate = "" OR IsNull(s_frdate) THEN s_frdate = '10000101'
IF s_todate = "" OR IsNull(s_todate) THEN s_todate = '99991231'
if IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
if IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
if IsNull(emp1) or emp1 = "" then emp1 = "."
if IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

if s_frdate > s_todate then 
	f_message_chk(34,'[기준일자]')
	dw_ip.Setcolumn('fr_date')
	dw_ip.SetFocus()
	return -1
end if	

drate = dw_ip.GetItemDecimal(1, "nrate")

IF IsNull(drate) THEN 
	f_message_chk(30,'[불량율]')
	dw_ip.Setcolumn('nrate')
	dw_ip.SetFocus()
	return -1
END IF

IF dw_list.Retrieve(gs_sabu, s_frdate,s_todate, drate, cvcod1, cvcod2, emp1, emp2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('fr_date')
	dw_ip.Setfocus()
	return -1
End if
return 1

end function

public function integer wf_retrieve_02660 ();String  s_frvndcod, s_tovndcod, s_frdate, s_todate, s_gub, emp1, emp2

dw_ip.AcceptText()

s_frdate = trim(dw_ip.GetItemString(1, "fr_date"))
s_todate = trim(dw_ip.GetItemString(1, "to_date"))
emp1 = trim(dw_ip.GetItemString(1, "emp1"))
emp2 = trim(dw_ip.GetItemString(1, "emp2"))

IF s_frdate = "" OR IsNull(s_frdate) THEN s_frdate = '10000101'
IF s_todate = "" OR IsNull(s_todate) THEN s_todate = '99991231'
if IsNull(emp1) or emp1 = "" then emp1 = "."
if IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

if s_frdate > s_todate then 
	f_message_chk(34,'[기간]')
	dw_ip.Setcolumn('fr_date')
	dw_ip.SetFocus()
	return -1
end if	

s_gub = dw_ip.GetItemString(1, "gub")

IF s_gub = '3' then   // A/S 인 경우
	s_frvndcod = dw_ip.GetItemString(1, "fr_custno")
   s_tovndcod = dw_ip.GetItemString(1, "to_custno")
	IF s_frvndcod = "" OR IsNull(s_frvndcod) THEN 
		s_frvndcod = '.'
	END IF
	IF s_tovndcod = "" OR IsNull(s_tovndcod) THEN 
		s_tovndcod = 'ZZZZZZZZZZ'
	END IF
	
	if s_frvndcod > s_tovndcod then 
		f_message_chk(34,'[고객번호]')
		dw_ip.Setcolumn('fr_custno')
		dw_ip.SetFocus()
		return -1
	end if	
	
   dw_list.DataObject ="d_imt_02660_2" 
   dw_list.SetTransObject(SQLCA)

	IF dw_list.Retrieve(gs_sabu, s_frdate,s_todate, s_frvndcod,s_tovndcod) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setcolumn('fr_date')
		dw_ip.Setfocus()
		return -1
	end if
ELSE
	s_frvndcod = dw_ip.GetItemString(1, "cvcod1")
   s_tovndcod = dw_ip.GetItemString(1, "cvcod2")
	IF s_frvndcod = "" OR IsNull(s_frvndcod) THEN 
		s_frvndcod = '.'
	END IF
	IF s_tovndcod = "" OR IsNull(s_tovndcod) THEN 
		s_tovndcod = 'ZZZZZZ'
	END IF
	
	if s_frvndcod > s_tovndcod then 
		f_message_chk(34,'[거래처]')
		dw_ip.Setcolumn('cvcod1')
		dw_ip.SetFocus()
		return -1
	end if	
	
   dw_list.DataObject ="d_imt_02660_1" 
   dw_list.SetTransObject(SQLCA)
	
	IF dw_list.Retrieve(gs_sabu, s_frdate,s_todate, s_frvndcod,s_tovndcod, s_gub, emp1, emp2) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setcolumn('fr_date')
		dw_ip.Setfocus()
		return -1
	end if
END IF

return 1

end function

public function integer wf_retrieve_02640 ();String  s_frdate, s_todate, srate, cvcod1, cvcod2, emp1, emp2
double drate
string DWfilter

dw_ip.AcceptText()

s_frdate = trim(dw_ip.GetItemString(1, "fr_date"))
s_todate = trim(dw_ip.GetItemString(1, "to_date"))
cvcod1 = trim(dw_ip.GetItemString(1, "cvcod1"))
cvcod2 = trim(dw_ip.GetItemString(1, "cvcod2"))
emp1 = trim(dw_ip.GetItemString(1, "emp1"))
emp2 = trim(dw_ip.GetItemString(1, "emp2"))

if IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
if IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
if IsNull(emp1) or emp1 = "" then emp1 = "."
if IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[검사일자]')
	dw_ip.Setcolumn('fr_date')
	dw_ip.SetFocus()
	return -1
end if	

drate = dw_ip.GetItemDecimal(1, "nrate")

IF IsNull(drate) THEN 
	f_message_chk(30,'[불량율]')
	dw_ip.Setcolumn('nrate')
	dw_ip.SetFocus()
	return -1
else
	srate = string(drate)
END IF

//불량율이 조건보다 적으면 조회되지 않게 함....
//dw_list.setredraw(false)
dw_print.SetFilter('')
dw_print.Filter( )

IF dw_print.Retrieve(gs_sabu, s_frdate,s_todate, cvcod1, cvcod2, emp1, emp2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('fr_date')
	dw_ip.Setfocus()
//   dw_list.setredraw(true)
	return -1
Else
	dWfilter = "fail_rate >= NUMBER('" + srate +"')" 
	dw_print.SetFilter(DWfilter)
	dw_print.Filter( )
   if dw_print.rowcount() < 1 then 
		f_message_chk(50,'')
		dw_ip.Setcolumn('fr_date')
		dw_ip.Setfocus()
		//dw_list.setredraw(true)
		return -1
	else
		dw_print.ShareData(dw_list)
	end if
End if

//dw_list.setredraw(true)
return 1



end function

public function integer wf_retrieve ();long ireturn

if ddlb_dwchoice.text = '업체별 불량율 현황' then
	ireturn = wf_retrieve_02640()
elseif ddlb_dwchoice.text = '불량율 관리대장' then
	ireturn = wf_retrieve_02650()	
elseif ddlb_dwchoice.text = '불량발생및 조치현황' then
	ireturn = wf_retrieve_02660()	
end if

return ireturn
end function

on w_imt_02640.create
int iCurrent
call super::create
this.ddlb_dwchoice=create ddlb_dwchoice
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_dwchoice
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
end on

on w_imt_02640.destroy
call super::destroy
destroy(this.ddlb_dwchoice)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;ddlb_dwchoice.text = '업체별 불량율 현황'
dw_ip.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_ip.setitem(1, 'to_date', f_today() )
dw_ip.Setfocus()


end event

type dw_list from w_standard_print`dw_list within w_imt_02640
integer width = 3489
integer height = 1964
string dataobject = "d_imt_02640_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_02640
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02640
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02640
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02640
end type

type dw_print from w_standard_print`dw_print within w_imt_02640
string dataobject = "d_imt_02640_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02640
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_02640_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string  snull, sdate, s_cod, s_nam1, s_nam2
Integer i_rtn
int     ireturn
double  drate
setnull(snull)

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[검사일자 FROM]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[검사일자 TO]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "nrate"	THEN
	drate = Double(this.GetText())
	
	if drate = 0 or isnull(drate) then	return 

  	IF drate > 100	then
      messagebox('확인', '불량율이 100%를 넘을 수 없습니다.')
		this.setitem(1, "nrate", 0)
		return 1
	END IF
ELSEIF this.GetColumnName() = "fr_custno"	THEN
   s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("C0", "Y", s_cod, s_nam1, s_nam2)
	this.object.fr_custno[1] = s_cod
	this.object.fr_custnm[1] = s_nam1
	return i_rtn
ELSEIF this.GetColumnName() = "to_custno"	THEN
   s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("C0", "Y", s_cod, s_nam1, s_nam2)
	this.object.to_custno[1] = s_cod
	this.object.to_custnm[1] = s_nam1
	return i_rtn
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "cvcod1" then
	open(w_vndmst_popup)
	this.object.cvcod1[1] = gs_code
elseif this.GetColumnName() = "cvcod2" then
	open(w_vndmst_popup)
	this.object.cvcod2[1] = gs_code
elseif this.GetColumnName() = "fr_custno" then
	open(w_cust_popup)
	this.object.fr_custno[1] = gs_code
	this.object.fr_custnm[1] = gs_codename
elseif this.GetColumnName() = "to_custno" then
	open(w_cust_popup)
	this.object.to_custno[1] = gs_code
	this.object.to_custnm[1] = gs_codename
end if	
end event

type r_1 from w_standard_print`r_1 within w_imt_02640
end type

type r_2 from w_standard_print`r_2 within w_imt_02640
end type

type ddlb_dwchoice from dropdownlistbox within w_imt_02640
boolean visible = false
integer x = 3013
integer y = 112
integer width = 667
integer height = 336
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
boolean vscrollbar = true
string item[] = {"업체별 불량율 현황","불량율 관리대장","불량발생및 조치현황"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_ip.setredraw(false)

Choose case index
		 case 1		// 업체등급표
				dw_ip.dataobject 	 = 'd_imt_02640_a'
				dw_list.dataobject = 'd_imt_02640_1'
		 case 2		// 업체별 납기율 현황
				dw_ip.dataobject 	 = 'd_imt_02650_a'
				dw_list.dataobject = 'd_imt_02650_1'			
		 case 3		// 납기관리대장
				dw_ip.dataobject 	 = 'd_imt_02660_a'
				dw_list.dataobject = 'd_imt_02660_1'
End choose

dw_ip.settransobject(sqlca)		
dw_ip.insertrow(0)
dw_ip.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_ip.setitem(1, 'to_date', f_today() )
dw_list.settransobject(sqlca)
dw_ip.setredraw(True)

dw_ip.setfocus()

//p_print.Enabled =False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//cb_ruler.Enabled = false
//p_preview.enabled = False
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//ddlb_zoom.text = '100'
//cb_ruler.text = '여백ON'

end event

type pb_1 from u_pic_cal within w_imt_02640
integer x = 704
integer y = 72
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_02640
integer x = 1179
integer y = 72
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'to_date', gs_code)



end event

