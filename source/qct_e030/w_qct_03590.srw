$PBExportHeader$w_qct_03590.srw
$PBExportComments$불만 및 서비스 LIST
forward
global type w_qct_03590 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_03590
end type
type pb_2 from u_pb_cal within w_qct_03590
end type
type rr_1 from roundrectangle within w_qct_03590
end type
end forward

global type w_qct_03590 from w_standard_print
integer width = 4640
integer height = 2440
string title = "불만 및 서비스 LIST"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_03590 w_qct_03590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate, ls_edate

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate = trim(dw_ip.object.sdate[1])
ls_edate = trim(dw_ip.object.edate[1])

if (IsNull(ls_sdate) or ls_sdate = "")  then ls_sdate = "10000101"
if (IsNull(ls_edate) or ls_edate = "")  then ls_edate = "99991231"

IF dw_print.Retrieve(gs_sabu, ls_sdate,  ls_edate) <= 0 then
	f_message_chk(50,'[불만 및 서비스 list]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)
dw_print.object.txt_ymd.text = String(ls_sdate, "@@@@.@@.@@") + " - " + String(ls_edate, "@@@@.@@.@@")

return 1
end function

on w_qct_03590.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qct_03590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_03590
end type

type p_exit from w_standard_print`p_exit within w_qct_03590
end type

type p_print from w_standard_print`p_print within w_qct_03590
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03590
end type







type st_10 from w_standard_print`st_10 within w_qct_03590
end type



type dw_print from w_standard_print`dw_print within w_qct_03590
string dataobject = "d_qct_03590_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03590
integer x = 494
integer y = 48
integer width = 1234
integer height = 152
string dataobject = "d_qct_03590_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String  s_cod
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03590
integer x = 512
integer y = 212
integer width = 3867
integer height = 2044
string dataobject = "d_qct_03590_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qct_03590
integer x = 1157
integer y = 72
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03590
integer x = 1559
integer y = 72
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 498
integer y = 200
integer width = 3913
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

