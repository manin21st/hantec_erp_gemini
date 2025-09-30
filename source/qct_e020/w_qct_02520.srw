$PBExportHeader$w_qct_02520.srw
$PBExportComments$** 개인별 제안실적 현황
forward
global type w_qct_02520 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_02520
end type
type pb_2 from u_pb_cal within w_qct_02520
end type
end forward

global type w_qct_02520 from w_standard_print
integer width = 4640
integer height = 2440
string title = "개인별 제안실적 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02520 w_qct_02520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, gu, emp1, emp2, jests, simdpt
string s_gu[3] = {"일반제안", "테마제안", "ALL"}, &
       s_jests[5] = {"제출", "채택", "실시", "미실시", "ALL"}
		 
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
gu    = trim(dw_ip.object.gu[1])
emp1  = trim(dw_ip.object.emp1[1])
emp2  = trim(dw_ip.object.emp2[1])
jests = trim(dw_ip.object.jests[1])
simdpt = trim(dw_ip.object.simdpt[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(simdpt) or simdpt = "")  then simdpt = "%"

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_list.object.txt_gu.text = s_gu[Integer(gu)]
dw_list.object.txt_jests.text = s_jests[Integer(jests)]

if gu = "3" then gu = "%"
if (IsNull(emp1) or emp1 = "")  then emp1 = "."
if (IsNull(emp2) or emp2 = "")  then emp2 = "ZZZZZZ"
if jests = "5" then jests = "%"

//if dw_list.Retrieve(gs_sabu, sdate, edate, gu, emp1, emp2, jests, simdpt) <= 0 then
//	f_message_chk(50,'[개인별 제안실적 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, gu, emp1, emp2, jests, simdpt) <= 0 then
	f_message_chk(50,'[개인별 제안실적 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_02520.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_02520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_02520
end type

type p_exit from w_standard_print`p_exit within w_qct_02520
end type

type p_print from w_standard_print`p_print within w_qct_02520
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_02520
end type







type st_10 from w_standard_print`st_10 within w_qct_02520
end type



type dw_print from w_standard_print`dw_print within w_qct_02520
string dataobject = "d_qct_02520_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_02520
integer x = 32
integer y = 0
integer width = 3854
integer height = 240
string dataobject = "d_qct_02520_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.getText())

if this.GetColumnName() = "sdate" then
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
elseif this.getcolumnname() = 'emp1' then 
	i_rtn = f_get_name2("사번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"emp1",s_cod)		
	this.setitem(1,"nam1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'emp2' then 
	i_rtn = f_get_name2("사번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"emp2",s_cod)		
	this.setitem(1,"nam2",s_nam1)
	return i_rtn
end if
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "emp1"	THEN		
   open(w_sawon_popup)
   this.SetItem(1, "emp1", gs_code)
   this.SetItem(1, "nam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "emp2" THEN		
   open(w_sawon_popup)
   this.SetItem(1, "emp2", gs_code)
   this.SetItem(1, "nam2", gs_codename)
	return
END IF
 
end event

type dw_list from w_standard_print`dw_list within w_qct_02520
integer width = 4567
string dataobject = "d_qct_02520_02"
end type

type pb_1 from u_pb_cal within w_qct_02520
integer x = 379
integer y = 64
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02520
integer x = 814
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

