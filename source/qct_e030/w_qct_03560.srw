$PBExportHeader$w_qct_03560.srw
$PBExportComments$** CLAIM원인별집계현황
forward
global type w_qct_03560 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_03560
end type
type pb_2 from u_pb_cal within w_qct_03560
end type
end forward

global type w_qct_03560 from w_standard_print
string title = "CLAIM 원인별 집계 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_03560 w_qct_03560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

dw_list.setredraw(false)
if dw_list.Retrieve(gs_sabu, sdate, edate) <= 0 then
	dw_list.setredraw(true)
	f_message_chk(50,'[CLAIM 원인별 집계 현황]')
	dw_ip.Setfocus()
//	return -1
end if

dw_list.setredraw(true)

dw_print.Retrieve(gs_sabu, sdate, edate)
dw_print.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")

return 1
end function

on w_qct_03560.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_03560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_03560
end type

type p_exit from w_standard_print`p_exit within w_qct_03560
end type

type p_print from w_standard_print`p_print within w_qct_03560
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03560
end type







type st_10 from w_standard_print`st_10 within w_qct_03560
end type



type dw_print from w_standard_print`dw_print within w_qct_03560
string dataobject = "d_qct_03560_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03560
integer x = 46
integer y = 72
integer width = 1321
integer height = 160
string dataobject = "d_qct_03560_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then //접수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then //접수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03560
string dataobject = "d_qct_03560_02"
end type

type pb_1 from u_pb_cal within w_qct_03560
integer x = 681
integer y = 96
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03560
integer x = 1147
integer y = 96
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

