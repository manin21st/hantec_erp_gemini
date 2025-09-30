$PBExportHeader$w_pdm_t_10010.srw
$PBExportComments$ECO 현황
forward
global type w_pdm_t_10010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdm_t_10010
end type
type pb_2 from u_pb_cal within w_pdm_t_10010
end type
type rr_1 from roundrectangle within w_pdm_t_10010
end type
type rr_2 from roundrectangle within w_pdm_t_10010
end type
end forward

global type w_pdm_t_10010 from w_standard_print
string title = "ECO 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_t_10010 w_pdm_t_10010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_date_from, ls_date_to, ls_itnbr

dw_ip.AcceptText()

ls_date_from = dw_ip.GetItemString(1,'rec_datef')
ls_date_to = dw_ip.GetItemString(1,'rec_datet')
ls_itnbr = dw_ip.GetItemString(1,'itnbr')

IF ls_date_from = '' OR IsNull(ls_date_from) THEN ls_date_from = '.'
IF ls_date_to = '' OR IsNull(ls_date_to) THEN ls_date_to = 'zzzzzz'

if ls_itnbr = '' or isnull(ls_itnbr) then 
	ls_itnbr = '%'
//	f_message_chk(30,'  Part No')
//	dw_ip.setFocus()
//	dw_ip.setColumn("intbr")
//	return -1
end if

ls_itnbr = ls_itnbr + '%'
//IF dw_print.retrieve(ls_date_from, ls_date_to) = 0 THEN

IF dw_print.retrieve(ls_date_from, ls_date_to, ls_itnbr) = 0 THEN
	f_message_chk(50, '   ECO 현황')
	return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_pdm_t_10010.create
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

on w_pdm_t_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"rec_datef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"rec_datet", is_today)
dw_ip.SetFocus()
dw_ip.setColumn("rec_datef")
end event

type p_preview from w_standard_print`p_preview within w_pdm_t_10010
end type

type p_exit from w_standard_print`p_exit within w_pdm_t_10010
end type

type p_print from w_standard_print`p_print within w_pdm_t_10010
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_t_10010
end type







type st_10 from w_standard_print`st_10 within w_pdm_t_10010
end type



type dw_print from w_standard_print`dw_print within w_pdm_t_10010
string dataobject = "d_pdm_t_10010_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_t_10010
integer x = 91
integer y = 116
integer width = 3017
integer height = 88
string dataobject = "d_pdm_t_10010_h"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_data, ls_itnbr, ls_itdsc

if getColumnName() = 'itnbr' Then

	ls_data = GetText()
	
	Select itnbr, itdsc
	into :ls_itnbr, :ls_itdsc
	From ITEMAS
	WHERE itnbr = :ls_data ;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","Part No가 존재하지 않습니다.",Exclamation!)
		this.SetItem(1,'itnbr', '')
		this.SetItem(1,'itdsc', '')
		Return 1
	End If
	
	this.SetItem(1,'itnbr', ls_itnbr)
	this.SetItem(1,'itdsc', ls_itdsc)
	
	p_retrieve.PostEvent(clicked!)
End If
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

If GetColumnName() = 'itnbr' Then
	Open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	SetItem(1,'itnbr', gs_code)
	SetItem(1,'itdsc', gs_codename)
	
	p_retrieve.PostEvent(clicked!)
End If
end event

type dw_list from w_standard_print`dw_list within w_pdm_t_10010
integer x = 23
integer y = 328
integer width = 4544
string dataobject = "d_pdm_t_10010_d"
boolean border = false
end type

type pb_1 from u_pb_cal within w_pdm_t_10010
integer x = 722
integer y = 104
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('rec_datef')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'rec_datef', gs_code)

end event

type pb_2 from u_pb_cal within w_pdm_t_10010
integer x = 1166
integer y = 104
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('rec_datet')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'rec_datet', gs_code)

end event

type rr_1 from roundrectangle within w_pdm_t_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 50
integer y = 80
integer width = 3095
integer height = 156
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_t_10010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 324
integer width = 4576
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

