$PBExportHeader$w_qct_03610.srw
$PBExportComments$Claim 및 무상서비스 원인별 현황
forward
global type w_qct_03610 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_03610
end type
type pb_2 from u_pb_cal within w_qct_03610
end type
type rr_1 from roundrectangle within w_qct_03610
end type
end forward

global type w_qct_03610 from w_standard_print
integer width = 4640
integer height = 2440
string title = "claim 및 무상서비스 원인별 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_03610 w_qct_03610

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate, ls_edate

if dw_ip.AcceptText() = -1 then return -1


ls_sdate = trim(dw_ip.GetItemString(1,'sdate'))
ls_edate = trim(dw_ip.GetItemString(1,'edate'))



if isnull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if isnull(ls_edate) or ls_edate = "" then ls_edate = '99991231'

//dw_list.object.txt_date.text = string( ls_sdate, '@@@@.@@.@@') + '-' + string( ls_edate, '@@@@.@@.@@') 

IF dw_print.Retrieve(gs_sabu,  ls_sdate, ls_edate) <= 0 then 
	f_message_chk(50,"[ Claim 및 무상 서비스 원인별 현황 ]")
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_03610.create
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

on w_qct_03610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_03610
end type

type p_exit from w_standard_print`p_exit within w_qct_03610
end type

type p_print from w_standard_print`p_print within w_qct_03610
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03610
end type







type st_10 from w_standard_print`st_10 within w_qct_03610
end type



type dw_print from w_standard_print`dw_print within w_qct_03610
string dataobject = "d_qct_03610_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03610
integer x = 224
integer y = 48
integer width = 1275
integer height = 136
string dataobject = "d_qct_03610_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())


if this.getcolumnname() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 TO]")
		this.object.edate[1] = ""
		return 1
	end if
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03610
integer x = 238
integer y = 196
integer width = 4123
integer height = 2056
string dataobject = "d_qct_03610_02"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_qct_03610
integer x = 901
integer y = 68
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03610
integer x = 1335
integer y = 68
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03610
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 224
integer y = 192
integer width = 4178
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

