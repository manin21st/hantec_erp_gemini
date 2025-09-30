$PBExportHeader$w_qct_03580.srw
$PBExportComments$불만 접수 대장
forward
global type w_qct_03580 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_03580
end type
type pb_2 from u_pb_cal within w_qct_03580
end type
type rr_2 from roundrectangle within w_qct_03580
end type
end forward

global type w_qct_03580 from w_standard_print
integer width = 4640
integer height = 2440
string title = "불만 접수 대장"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_qct_03580 w_qct_03580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdate, edate, ls_cl_jpno1 , ls_cl_jpno2

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

sdate = Trim(dw_ip.object.sdate[1])
edate = Trim(dw_ip.object.edate[1])
ls_cl_jpno1 = Trim(dw_ip.object.cl_jpno1[1])
ls_cl_jpno2 = Trim(dw_ip.object.cl_jpno2[1])

if IsNull(sdate) or sdate = "" then sdate = "10000101"
if IsNull(edate) or edate = "" then edate = "99991231"
if IsNull(ls_cl_jpno1) or ls_cl_jpno1 = "" then ls_cl_jpno1='.'
if IsNull(ls_cl_jpno2) or ls_cl_jpno2 = "" then ls_cl_jpno2='zzzzzzzzzzzz'

IF dw_print.Retrieve(gs_sabu, sdate, edate, ls_cl_jpno1, ls_cl_jpno2) <= 0 then
	f_message_chk(50,'[불만 접수 대장]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)
dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

return 1
end function

on w_qct_03580.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_qct_03580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_03580
end type

type p_exit from w_standard_print`p_exit within w_qct_03580
end type

type p_print from w_standard_print`p_print within w_qct_03580
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03580
end type







type st_10 from w_standard_print`st_10 within w_qct_03580
end type



type dw_print from w_standard_print`dw_print within w_qct_03580
string dataobject = "d_qct_03580_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03580
integer y = 52
integer width = 2725
integer height = 204
string dataobject = "d_qct_03580_01"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if (this.GetColumnName() = "cl_jpno1") Then 
	open(w_claimno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cl_jpno1[1] = gs_code
elseif (this.GetColumnName() = "cl_jpno2") Then 
	open(w_claimno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cl_jpno2[1] = gs_code 
end if
end event

event dw_ip::itemchanged;call super::itemchanged;string s_cod

s_cod = Trim(this.gettext())

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
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03580
integer x = 59
integer y = 280
integer width = 4530
integer height = 1972
string dataobject = "d_qct_03580_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qct_03580
integer x = 640
integer y = 96
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03580
integer x = 1079
integer y = 96
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_2 from roundrectangle within w_qct_03580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 272
integer width = 4562
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

