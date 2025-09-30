$PBExportHeader$w_qct_03510.srw
$PBExportComments$** 생산팀별 크레임 현황
forward
global type w_qct_03510 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_03510
end type
type pb_2 from u_pb_cal within w_qct_03510
end type
type rr_2 from roundrectangle within w_qct_03510
end type
end forward

global type w_qct_03510 from w_standard_print
string title = "생산팀별 크레임 현황"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_qct_03510 w_qct_03510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, team1, team2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
team1 = trim(dw_ip.object.team1[1])
team2 = trim(dw_ip.object.team2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(team1) or team1 = "")  then team1 = "."
if (IsNull(team2) or team2 = "")  then team2 = "ZZZZZZ"

IF dw_print.Retrieve(gs_sabu, sdate, edate, team1, team2) <= 0 then
	f_message_chk(50,'[생산팀별 크레임 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
//	dw_print.insertrow(0)
	Return -1
END IF

dw_print.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_03510.create
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

on w_qct_03510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_03510
end type

type p_exit from w_standard_print`p_exit within w_qct_03510
end type

type p_print from w_standard_print`p_print within w_qct_03510
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03510
end type







type st_10 from w_standard_print`st_10 within w_qct_03510
end type



type dw_print from w_standard_print`dw_print within w_qct_03510
string dataobject = "d_qct_03510_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03510
integer x = 9
integer y = 24
integer width = 3003
integer height = 156
string dataobject = "d_qct_03510_01"
end type

event dw_ip::itemchanged;String s_cod

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
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03510
integer x = 64
integer y = 224
integer width = 4526
string dataobject = "d_qct_03510_02"
end type

type pb_1 from u_pb_cal within w_qct_03510
integer x = 608
integer y = 40
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03510
integer x = 1024
integer y = 40
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_2 from roundrectangle within w_qct_03510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 216
integer width = 4562
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

