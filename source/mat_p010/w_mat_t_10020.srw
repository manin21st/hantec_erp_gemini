$PBExportHeader$w_mat_t_10020.srw
$PBExportComments$자재 불출 할당 현황
forward
global type w_mat_t_10020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_t_10020
end type
type pb_2 from u_pb_cal within w_mat_t_10020
end type
type rr_1 from roundrectangle within w_mat_t_10020
end type
type rr_2 from roundrectangle within w_mat_t_10020
end type
end forward

global type w_mat_t_10020 from w_standard_print
string title = "자재불출할당현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_t_10020 w_mat_t_10020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, cod, ls_saupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
ls_saupj = trim(dw_ip.object.saupj[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(ls_saupj) or ls_saupj = "")  then ls_saupj = "%"

IF dw_print.Retrieve(gs_sabu, sdate, edate, ls_saupj) <= 0 then
	f_message_chk(50,"[자재 불출 할당 현황]")
	dw_list.Reset()
	dw_ip.Setfocus()
	dw_print.insertrow(0)
END IF

dw_print.object.txt_date.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
dw_print.ShareData(dw_list)

return 1
end function

on w_mat_t_10020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_mat_t_10020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', left(is_today,6) + '01')
dw_ip.setitem(1, 'edate', is_today)

end event

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'saupj' )
end event

type p_preview from w_standard_print`p_preview within w_mat_t_10020
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_mat_t_10020
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_mat_t_10020
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_t_10020
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_mat_t_10020
end type



type dw_print from w_standard_print`dw_print within w_mat_t_10020
string dataobject = "d_mat_t_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_t_10020
integer x = 55
integer y = 48
integer width = 2263
integer height = 112
string dataobject = "d_mat_t_10020_h"
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

type dw_list from w_standard_print`dw_list within w_mat_t_10020
integer x = 46
integer y = 208
integer width = 4530
integer height = 2104
boolean bringtotop = true
string dataobject = "d_mat_t_10020_d"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mat_t_10020
integer x = 1833
integer y = 56
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_t_10020
integer x = 2327
integer y = 56
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_1 from roundrectangle within w_mat_t_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 40
integer width = 2437
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_t_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 200
integer width = 4553
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

