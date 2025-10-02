$PBExportHeader$w_imt_03510.srw
$PBExportComments$** 외자진행현황
forward
global type w_imt_03510 from w_standard_print
end type
type dw_1 from datawindow within w_imt_03510
end type
type rb_1 from radiobutton within w_imt_03510
end type
type st_1 from statictext within w_imt_03510
end type
type rb_2 from radiobutton within w_imt_03510
end type
type rb_3 from radiobutton within w_imt_03510
end type
type rb_4 from radiobutton within w_imt_03510
end type
type pb_d_imt_03510_01_s from u_pic_cal within w_imt_03510
end type
type pb_d_imt_03510_01_e from u_pic_cal within w_imt_03510
end type
type pb_d_imt_03520_01_s from u_pic_cal within w_imt_03510
end type
type pb_d_imt_03520_01_e from u_pic_cal within w_imt_03510
end type
type pb_d_imt_03530_01_s from u_pic_cal within w_imt_03510
end type
type pb_d_imt_03530_01_e from u_pic_cal within w_imt_03510
end type
end forward

global type w_imt_03510 from w_standard_print
integer width = 3822
string title = "외자진행현황"
dw_1 dw_1
rb_1 rb_1
st_1 st_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
pb_d_imt_03510_01_s pb_d_imt_03510_01_s
pb_d_imt_03510_01_e pb_d_imt_03510_01_e
pb_d_imt_03520_01_s pb_d_imt_03520_01_s
pb_d_imt_03520_01_e pb_d_imt_03520_01_e
pb_d_imt_03530_01_s pb_d_imt_03530_01_s
pb_d_imt_03530_01_e pb_d_imt_03530_01_e
end type
global w_imt_03510 w_imt_03510

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve1 ()
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
	i_rtn = wf_retrieve1()
elseif gubun = "2" or gubun = '4' then
	i_rtn = wf_retrieve2()
elseif gubun = "3" then
	i_rtn = wf_retrieve3()
end if	

return i_rtn
end function

public function integer wf_retrieve2 ();string sdate, edate, cvcod1, cvcod2, balsts

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
balsts = trim(dw_ip.object.balsts[1])

if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
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
	
if (IsNull(balsts) or balsts = "")  then 
	f_message_chk(30, "[완료구분]")
	dw_ip.SetColumn("balsts")
	dw_ip.Setfocus()
	return -1
end if	

dw_print.SetFilter("")    //완료구분 => ALL
dw_print.Filter( )

if rb_1.checked then //전체
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("poblkt_balsts = '2' or poblkt_balsts = '4'")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("poblkt_balsts = '1' or poblkt_balsts = '3'")
		dw_print.Filter( )
	end if	
elseif rb_2.checked then //BL 까지	
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' ) and (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' ) and (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter(" (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	end if	
elseif rb_3.checked then //LC 까지	
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' )" + & 
		                   "and isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' )" + & 
		                   "and isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter("isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	end if	
else   //PO만
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' )" + & 
		                   "and isnull(polcbl_poblno) and  isnull(polcdt_polcno) ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' )" + & 
		                   "and isnull(polcbl_poblno) and  isnull(polcdt_polcno) ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter("isnull(polcdt_polcno) ")
		dw_print.Filter( )
	end if	
end if	

//발주일반정보(POMAST)에서 수입구분(BAL_SUIP)이 외자('2')인 것만 출력
//구분 : 발주일반정보(POMAST)의 발주작성구분(PLNCRT) => '1':정규, '2':추가
//완료구분 : 발주 품목정보(POBLKT)의 발주상태(BALSTS)
//           완료 => '2':완료, '4':취소
//           미완료 => '1':정상, '3':보류

if dw_print.Retrieve(gs_sabu, cvcod1, cvcod2, sdate, edate) <= 0 then
	f_message_chk(50,'[외자진행현황-[거래처별]]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

public function integer wf_retrieve1 ();string sdate, edate, itnbr1, itnbr2, balsts

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
balsts = trim(dw_ip.object.balsts[1])

if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

if (IsNull(balsts) or balsts = "")  then 
	f_message_chk(30, "[완료구분]")
	dw_ip.SetColumn("balsts")
	dw_ip.Setfocus()
	return -1
end if	

dw_print.SetFilter("")    //완료구분 = ALL
dw_print.Filter( )

if rb_1.checked then //전체
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("poblkt_balsts = '2' or poblkt_balsts = '4'")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("poblkt_balsts = '1' or poblkt_balsts = '3'")
		dw_print.Filter( )
	end if	
elseif rb_2.checked then //BL 까지	
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' ) and (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' ) and (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter(" (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	end if	
elseif rb_3.checked then //LC 까지	
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' )" + & 
		                   "and isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' )" + & 
		                   "and isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter("isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	end if	
else   //PO만
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' )" + & 
		                   "and isnull(polcbl_poblno) and  isnull(polcdt_polcno) ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' )" + & 
		                   "and isnull(polcbl_poblno) and  isnull(polcdt_polcno) ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter("isnull(polcdt_polcno) ")
		dw_print.Filter( )
	end if	
end if	

//발주일반정보(POMAST)에서 수입구분(BAL_SUIP)이 외자('2')인 것만 출력
//구분 : 발주일반정보(POMAST)의 발주작성구분(PLNCRT) => '1':정규, '2':추가
//완료구분 : 발주 품목정보(POBLKT)의 발주상태(BALSTS)
//           완료 => '2':완료, '4':취소
//           미완료 => '1':정상, '3':보류

if dw_print.Retrieve(gs_sabu, itnbr1, itnbr2, sdate, edate) <= 0 then
	f_message_chk(50,'[외자진행현황-[품목별]]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)	
end if

return 1
end function

public function integer wf_retrieve3 ();string sdate, edate, cvcod1, cvcod2, balsts

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
balsts = trim(dw_ip.object.balsts[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "0"
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"

if (IsNull(balsts) or balsts = "")  then 
	f_message_chk(30, "[완료구분]")
	dw_ip.SetColumn("balsts")
	dw_ip.Setfocus()
	return -1
end if	

dw_print.SetFilter("") //완료구분 => ALL
dw_print.Filter( )

if rb_1.checked then //전체
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("poblkt_balsts = '2' or poblkt_balsts = '4'")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("poblkt_balsts = '1' or poblkt_balsts = '3'")
		dw_print.Filter( )
	end if	
elseif rb_2.checked then //BL 까지	
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' ) and (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' ) and (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter(" (polcbl_poblno > '.' or insdat > '.') ")
		dw_print.Filter( )
	end if	
elseif rb_3.checked then //LC 까지	
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' )" + & 
		                   "and isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' )" + & 
		                   "and isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter("isnull(polcbl_poblno) and  polcdt_polcno > '.' ")
		dw_print.Filter( )
	end if	
else   //PO만
	if balsts = "2" then     //완료구분 = 완료
		dw_print.SetFilter("( poblkt_balsts = '2' or poblkt_balsts = '4' )" + & 
		                   "and isnull(polcbl_poblno) and  isnull(polcdt_polcno) ")
		dw_print.Filter( )
	elseif balsts = "3" then //완료구분 = 미완료
		dw_print.SetFilter("( poblkt_balsts = '1' or poblkt_balsts = '3' )" + & 
		                   "and isnull(polcbl_poblno) and  isnull(polcdt_polcno) ")
		dw_print.Filter( )
	else	
		dw_print.SetFilter("isnull(polcdt_polcno) ")
		dw_print.Filter( )
	end if	
end if	
//발주일반정보(POMAST)에서 수입구분(BAL_SUIP)이 외자('2')인 것만 출력
//구분 : 발주일반정보(POMAST)의 발주작성구분(PLNCRT) => '1':정규, '2':추가
//완료구분 : 발주 품목정보(POBLKT)의 발주상태(BALSTS)
//           완료 => '2':완료, '4':취소
//           미완료 => '1':정상, '3':보류

if dw_print.Retrieve(gs_sabu, sdate, edate, cvcod1, cvcod2) <= 0 then
	f_message_chk(50,'[외자진행현황-[납기일자별]]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

on w_imt_03510.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.pb_d_imt_03510_01_s=create pb_d_imt_03510_01_s
this.pb_d_imt_03510_01_e=create pb_d_imt_03510_01_e
this.pb_d_imt_03520_01_s=create pb_d_imt_03520_01_s
this.pb_d_imt_03520_01_e=create pb_d_imt_03520_01_e
this.pb_d_imt_03530_01_s=create pb_d_imt_03530_01_s
this.pb_d_imt_03530_01_e=create pb_d_imt_03530_01_e
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.pb_d_imt_03510_01_s
this.Control[iCurrent+8]=this.pb_d_imt_03510_01_e
this.Control[iCurrent+9]=this.pb_d_imt_03520_01_s
this.Control[iCurrent+10]=this.pb_d_imt_03520_01_e
this.Control[iCurrent+11]=this.pb_d_imt_03530_01_s
this.Control[iCurrent+12]=this.pb_d_imt_03530_01_e
end on

on w_imt_03510.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.pb_d_imt_03510_01_s)
destroy(this.pb_d_imt_03510_01_e)
destroy(this.pb_d_imt_03520_01_s)
destroy(this.pb_d_imt_03520_01_e)
destroy(this.pb_d_imt_03530_01_s)
destroy(this.pb_d_imt_03530_01_e)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_ip.setitem(1, 'balsts', '1')
end event

type dw_list from w_standard_print`dw_list within w_imt_03510
integer y = 396
integer width = 3602
integer height = 1964
string dataobject = "d_imt_03510_02"
end type

type cb_print from w_standard_print`cb_print within w_imt_03510
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03510
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03510
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03510
end type

type dw_print from w_standard_print`dw_print within w_imt_03510
string dataobject = "d_imt_03510_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03510
integer width = 3602
integer height = 296
integer taborder = 20
string dataobject = "d_imt_03510_01"
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
	open(w_itemas_popup)
   this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
	return
ELSEIF this.getcolumnname() = "itnbr2"	THEN //품번(TO)		
	open(w_itemas_popup)
   this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod1"	THEN //거래처코드(FROM)		
	open(w_vndmst_popup)
   this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN //거래처코드(TO)		
	open(w_vndmst_popup)
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

type r_1 from w_standard_print`r_1 within w_imt_03510
integer y = 392
integer width = 3610
end type

type r_2 from w_standard_print`r_2 within w_imt_03510
integer width = 3610
integer height = 312
end type

type dw_1 from datawindow within w_imt_03510
integer x = 37
integer y = 56
integer width = 3602
integer height = 120
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_03510_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //외자진행현황(품목별)
   dw_ip.DataObject = "d_imt_03510_01"
	pb_d_imt_03510_01_s.Visible = True
	pb_d_imt_03510_01_e.Visible = True
	pb_d_imt_03520_01_s.Visible = False
	pb_d_imt_03520_01_e.Visible = False
	pb_d_imt_03530_01_s.Visible = False
	pb_d_imt_03530_01_e.Visible = False
	dw_list.DataObject = "d_imt_03510_02"
   dw_print.DataObject = "d_imt_03510_02_p"
elseif gubun = "2" then	//외자진행현황(거래처별)
   dw_ip.DataObject = "d_imt_03520_01"
	pb_d_imt_03510_01_s.Visible = False
	pb_d_imt_03510_01_e.Visible = False
	pb_d_imt_03520_01_s.Visible = True
	pb_d_imt_03520_01_e.Visible = True
	pb_d_imt_03530_01_s.Visible = False
	pb_d_imt_03530_01_e.Visible = False
	dw_list.DataObject = "d_imt_03520_02"
	dw_print.DataObject = "d_imt_03520_02_p"
elseif gubun = "3" then	//외자진행현황(납기일자별)
   dw_ip.DataObject = "d_imt_03530_01"
	pb_d_imt_03510_01_s.Visible = False
	pb_d_imt_03510_01_e.Visible = False
	pb_d_imt_03520_01_s.Visible = False
	pb_d_imt_03520_01_e.Visible = False
	pb_d_imt_03530_01_s.Visible = True
	pb_d_imt_03530_01_e.Visible = True
	dw_list.DataObject = "d_imt_03530_02"
	dw_print.DataObject = "d_imt_03530_02_p"
elseif gubun = "4" then	
   dw_ip.DataObject = "d_imt_03520_01"
	pb_d_imt_03510_01_s.Visible = False
	pb_d_imt_03510_01_e.Visible = False
	pb_d_imt_03520_01_s.Visible = True
	pb_d_imt_03520_01_e.Visible = True
	pb_d_imt_03530_01_s.Visible = False
	pb_d_imt_03530_01_e.Visible = False
	dw_list.DataObject = "d_imt_03535_02"
   dw_print.DataObject = "d_imt_03535_02_p"
end if	
dw_ip.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_list.ReSet()
dw_ip.InsertRow(0)
dw_ip.setitem(1, 'balsts', '1')
dw_ip.SetReDraw(True)
//dw_list.SetReDraw(True)
return
end event

type rb_1 from radiobutton within w_imt_03510
integer x = 2505
integer y = 100
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = " 전체 "
boolean checked = true
end type

type st_1 from statictext within w_imt_03510
integer x = 2235
integer y = 100
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_imt_03510
integer x = 3072
integer y = 100
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = " B/L "
end type

type rb_3 from radiobutton within w_imt_03510
integer x = 2775
integer y = 100
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = " L/C "
end type

type rb_4 from radiobutton within w_imt_03510
integer x = 3310
integer y = 100
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = " P.O "
end type

type pb_d_imt_03510_01_s from u_pic_cal within w_imt_03510
integer x = 622
integer y = 260
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_imt_03510_01_e from u_pic_cal within w_imt_03510
integer x = 1152
integer y = 260
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_imt_03520_01_s from u_pic_cal within w_imt_03510
boolean visible = false
integer x = 750
integer y = 260
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_imt_03520_01_e from u_pic_cal within w_imt_03510
boolean visible = false
integer x = 1216
integer y = 260
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_imt_03530_01_s from u_pic_cal within w_imt_03510
boolean visible = false
integer x = 800
integer y = 196
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_imt_03530_01_e from u_pic_cal within w_imt_03510
boolean visible = false
integer x = 1285
integer y = 196
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

