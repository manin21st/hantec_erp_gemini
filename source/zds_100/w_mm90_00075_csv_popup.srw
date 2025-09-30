$PBExportHeader$w_mm90_00075_csv_popup.srw
$PBExportComments$협력사 재고생성 popup
forward
global type w_mm90_00075_csv_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_mm90_00075_csv_popup
end type
end forward

global type w_mm90_00075_csv_popup from w_inherite_popup
integer width = 2930
integer height = 1028
rr_1 rr_1
end type
global w_mm90_00075_csv_popup w_mm90_00075_csv_popup

type variables
String	is_saupj
DataWindowChild	idwc_child
end variables

on w_mm90_00075_csv_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mm90_00075_csv_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;is_saupj = gs_gubun

dw_jogun.SetTransObject(sqlca) 
dw_jogun.GetChild('werks', idwc_child)  //해당사업장의 관련 납품공장 코드 dddw 
idwc_child.SetTransObject(SQLCA) 
idwc_child.Retrieve(is_saupj)

dw_jogun.InsertRow(0)
dw_jogun.SetItem(1, 'werks', gs_code)
if is_saupj = '10' then	//울산공장
	dw_jogun.SetItem(1, 'com_cd', 'K1H')
	dw_jogun.SetItem(1, 'vend_cd', 'P655')
	dw_jogun.SetItem(1, 'end_ch_nm', '황성환/과장')
	dw_jogun.SetItem(1, 'end_ch_tel', '010-7499-8317')
end if

dw_jogun.SetFocus()

SetNull(gs_gubun)
SetNull(gs_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mm90_00075_csv_popup
integer x = 69
integer y = 244
integer width = 2720
integer height = 652
string dataobject = "d_mm90_00075_csv_popup_1"
end type

type p_exit from w_inherite_popup`p_exit within w_mm90_00075_csv_popup
integer x = 2656
integer y = 56
end type

event p_exit::clicked;call super::clicked;
gs_gubun = 'N'

Close(Parent)

end event

type p_inq from w_inherite_popup`p_inq within w_mm90_00075_csv_popup
boolean visible = false
integer x = 2309
integer y = 56
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_mm90_00075_csv_popup
integer x = 2482
integer y = 56
end type

event p_choose::clicked;call super::clicked;String	ls_Depot, ls_sdate, ls_comcd, ls_werks, ls_vendcd
Long		ll_row, ll_insrow, ll_jego, ll_maxseq

if dw_jogun.AcceptText() = -1 then return -1 
 
ls_comcd = Trim(dw_jogun.GetItemString(1, 'com_cd'))
ls_werks = Trim(dw_jogun.GetItemString(1, 'werks'))
ls_vendcd = Trim(dw_jogun.GetItemString(1, 'vend_cd'))

if ls_comcd = '' or IsNull(ls_comcd) then
	f_message_chk(200, '[법인코드]')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('com_cd')
	return -1
end if

if ls_werks = '' or IsNull(ls_werks) then
	f_message_chk(200, '[공장]')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('werks')
	return -1
end if


if ls_vendcd = '' or IsNull(ls_vendcd) then
	f_message_chk(200, '[업체코드]')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('vend_cd')
	return -1
end if


dw_jogun.SaveAs("", Clipboard!, False)

gs_gubun = 'Y'

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mm90_00075_csv_popup
boolean visible = false
integer x = 434
integer y = 0
integer width = 411
integer height = 140
boolean enabled = false
end type

type sle_2 from w_inherite_popup`sle_2 within w_mm90_00075_csv_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_mm90_00075_csv_popup
end type

type cb_return from w_inherite_popup`cb_return within w_mm90_00075_csv_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_mm90_00075_csv_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_mm90_00075_csv_popup
end type

type st_1 from w_inherite_popup`st_1 within w_mm90_00075_csv_popup
end type

type rr_1 from roundrectangle within w_mm90_00075_csv_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 2798
integer height = 680
integer cornerheight = 40
integer cornerwidth = 55
end type

