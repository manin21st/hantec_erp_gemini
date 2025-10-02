$PBExportHeader$w_imt_03550.srw
$PBExportComments$** OPEN계획서
forward
global type w_imt_03550 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_03550
end type
type pb_2 from u_pic_cal within w_imt_03550
end type
end forward

global type w_imt_03550 from w_standard_print
string title = "OPEN 계획서"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_03550 w_imt_03550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, cvcod1, cvcod2, opensts, saupjang

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

saupjang = dw_ip.object.saupj[1]
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
opensts = trim(dw_ip.object.opensts[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"

if (IsNull(opensts) or opensts = "")  then 
	f_message_chk(30, "[상태구분]")
	dw_ip.SetColumn("opensts")
	dw_ip.Setfocus()
	return -1
end if	

dw_list.SetRedraw(False)

//금액합계는 CUMULATIVE SUM(누적합계)
//대미환산율 적용하여 US DOLLAR로 계산

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
CHOOSE CASE OPENSTS
		 CASE '1'
				dw_list.SetFilter("") //상태구분 => ALL
				dw_print.object.st_name.text = 'ALL'
		 CASE '2'
			   dw_list.SetFilter("poblkt_cnvqty <> lcoqty")
				dw_print.object.st_name.text = '진행중'
		 CASE '3'			
			   dw_list.SetFilter("poblkt_cnvqty = lcoqty")
				dw_print.object.st_name.text = 'OPEN완료'
END CHOOSE
dw_list.Filter( )

//if dw_list.Retrieve(gs_sabu, sdate, edate, cvcod1, cvcod2, saupjang) <= 0 then
//	f_message_chk(50,'[OPEN 계획서]')
//	dw_ip.Setfocus()
//	dw_list.SetRedraw(True)
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, cvcod1, cvcod2, saupjang) <= 0 then
	f_message_chk(50,'[OPEN 계획서]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.SetRedraw(True)

return 1
end function

on w_imt_03550.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_03550.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_ip.setitem(1, 'opensts', '1')
f_mod_saupj(dw_ip,'saupj')
end event

type dw_list from w_standard_print`dw_list within w_imt_03550
integer width = 3489
integer height = 1964
string dataobject = "d_imt_03550_02"
end type

type cb_print from w_standard_print`cb_print within w_imt_03550
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03550
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03550
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03550
end type

type dw_print from w_standard_print`dw_print within w_imt_03550
string dataobject = "d_imt_03550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03550
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_03550_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.gettext())

if this.getcolumnname() = 'cvcod1' then  //거래처(FROM) 
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1",s_cod)		
	this.setitem(1,"cvnam1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then //거래처(TO)  
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1",s_cod)		
	this.setitem(1,"cvnam1",s_nam1)
	return i_rtn
elseif this.GetColumnName() = "sdate" then 
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
end if

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
IF this.getcolumnname() = "cvcod1"	THEN //거래처(FROM)	
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN //거래처(TO)		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return
END IF
end event

event dw_ip::itemerror;return 1
end event

type r_1 from w_standard_print`r_1 within w_imt_03550
end type

type r_2 from w_standard_print`r_2 within w_imt_03550
end type

type pb_1 from u_pic_cal within w_imt_03550
integer x = 1760
integer y = 76
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

type pb_2 from u_pic_cal within w_imt_03550
integer x = 2245
integer y = 76
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

