$PBExportHeader$w_mat_01520.srw
$PBExportComments$재검사 의뢰 현황
forward
global type w_mat_01520 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_01520
end type
type pb_2 from u_pb_cal within w_mat_01520
end type
type rr_1 from roundrectangle within w_mat_01520
end type
end forward

global type w_mat_01520 from w_standard_print
string title = "재검사 의뢰 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_mat_01520 w_mat_01520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, gub

if dw_ip.AcceptText() = -1 then return -1

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
gub = trim(dw_ip.object.gub[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

if sdate > edate then 
	f_message_chk(34,'[의뢰일자]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

//if dw_list.Retrieve(gs_sabu, sdate, edate, gub) <= 0 then
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, gub) <= 0 then
	f_message_chk(50,'[재검사 의뢰 현황]')
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_mat_01520.create
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

on w_mat_01520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, "sdate", left(f_today(), 6) + '01')
dw_ip.SetItem(1, "edate", f_today())
dw_ip.SetColumn("sdate")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_mat_01520
end type

type p_exit from w_standard_print`p_exit within w_mat_01520
end type

type p_print from w_standard_print`p_print within w_mat_01520
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_01520
end type







type st_10 from w_standard_print`st_10 within w_mat_01520
end type



type dw_print from w_standard_print`dw_print within w_mat_01520
string dataobject = "d_mat_01520_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_01520
integer x = 32
integer y = 24
integer width = 3136
integer height = 176
string dataobject = "d_mat_01520_a"
end type

event dw_ip::itemchanged;string snull, sdate

setnull(snull)

IF this.GetColumnName() ="sdate" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[의뢰일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="edate" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[의뢰일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_mat_01520
integer y = 224
integer width = 4553
integer height = 2096
string dataobject = "d_mat_01520_1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mat_01520
integer x = 667
integer y = 56
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_01520
integer x = 1115
integer y = 56
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_1 from roundrectangle within w_mat_01520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 212
integer width = 4571
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

