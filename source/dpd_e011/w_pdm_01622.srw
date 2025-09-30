$PBExportHeader$w_pdm_01622.srw
$PBExportComments$납품 공장별 근무일력 관리
forward
global type w_pdm_01622 from w_inherite
end type
type rr_1 from roundrectangle within w_pdm_01622
end type
type dw_input from datawindow within w_pdm_01622
end type
type pb_1 from u_pb_cal within w_pdm_01622
end type
type pb_2 from u_pb_cal within w_pdm_01622
end type
type dw_list from u_d_popup_sort within w_pdm_01622
end type
type rr_3 from roundrectangle within w_pdm_01622
end type
type rr_2 from roundrectangle within w_pdm_01622
end type
end forward

global type w_pdm_01622 from w_inherite
string title = "납품 공장별 근무일력 관리"
rr_1 rr_1
dw_input dw_input
pb_1 pb_1
pb_2 pb_2
dw_list dw_list
rr_3 rr_3
rr_2 rr_2
end type
global w_pdm_01622 w_pdm_01622

on w_pdm_01622.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_input=create dw_input
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_list=create dw_list
this.rr_3=create rr_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_input
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.rr_3
this.Control[iCurrent+7]=this.rr_2
end on

on w_pdm_01622.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_input)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_list)
destroy(this.rr_3)
destroy(this.rr_2)
end on

event open;call super::open;string ls_today, ls_sdate, ls_edate

ls_today = f_today()

dw_input.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_input.InsertRow(0)
//ls_sdate = Mid(ls_today, 1, 6) + "01"
//ls_edate = f_last_date(ls_today)
SELECT TO_CHAR(TRUNC(SYSDATE, 'D') + 1, 'YYYYMMDD'),
       TO_CHAR(TRUNC(SYSDATE, 'D') + 7, 'YYYYMMDD')
  INTO :ls_sdate, :ls_edate
  FROM DUAL;

dw_input.SetItem(1, "sdate", ls_sdate)
dw_input.SetItem(1, "edate", ls_edate)

dw_list.retrieve(ls_sdate, ls_edate)

dw_list.SelectRow(0, false)
dw_list.SelectRow(1, true)

dw_list.event rowfocuschanged(1)
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01622
integer x = 1659
integer y = 292
integer width = 2926
integer height = 1908
string dataobject = "d_pdm_01622"
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01622
integer y = 3400
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01622
integer y = 3400
end type

type p_search from w_inherite`p_search within w_pdm_01622
integer y = 3400
end type

type p_ins from w_inherite`p_ins within w_pdm_01622
integer y = 3400
end type

type p_exit from w_inherite`p_exit within w_pdm_01622
end type

type p_can from w_inherite`p_can within w_pdm_01622
end type

event p_can::clicked;call super::clicked;string ls_today, ls_sdate, ls_edate

ls_sdate = Mid(ls_today, 1, 6) + "01"
ls_edate = f_last_date(ls_today)

dw_input.SetItem(1, "sdate", ls_sdate)
dw_input.SetItem(1, "edate", ls_edate)

dw_list.retrieve(ls_sdate, ls_edate)

dw_list.SelectRow(0, false)
dw_list.SelectRow(1, true)
dw_list.event rowfocuschanged(1)
end event

type p_print from w_inherite`p_print within w_pdm_01622
integer y = 3400
end type

type p_inq from w_inherite`p_inq within w_pdm_01622
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string ls_sdate, ls_edate, ls_pdtgu
long ll_row

dw_input.AcceptText()

ls_sdate = dw_input.GetItemString(1, "sdate")
ls_edate = dw_input.GetItemString(1, "edate")

ll_row = dw_list.GetRow()
ls_pdtgu = dw_list.GetItemString(ll_row, "rfgub")

dw_list.retrieve(ls_sdate, ls_edate)

dw_list.SelectRow(0, false)
dw_list.SelectRow(ll_row, true)

dw_insert.Retrieve(ls_sdate, ls_edate, ls_pdtgu)
end event

type p_del from w_inherite`p_del within w_pdm_01622
integer y = 3400
end type

type p_mod from w_inherite`p_mod within w_pdm_01622
integer x = 4096
end type

event p_mod::clicked;call super::clicked;If dw_insert.Update() = -1 Then
	rollback;
	return
Else
	commit;
	MessageBox('확인', '저장하였습니다.')
	p_inq.TriggerEvent(Clicked!)
End If
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01622
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01622
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01622
end type

type cb_del from w_inherite`cb_del within w_pdm_01622
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01622
end type

type cb_print from w_inherite`cb_print within w_pdm_01622
end type

type st_1 from w_inherite`st_1 within w_pdm_01622
end type

type cb_can from w_inherite`cb_can within w_pdm_01622
end type

type cb_search from w_inherite`cb_search within w_pdm_01622
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01622
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01622
end type

type rr_1 from roundrectangle within w_pdm_01622
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 44
integer width = 1577
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_input from datawindow within w_pdm_01622
integer x = 78
integer y = 96
integer width = 1467
integer height = 84
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01622_c"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_sdate, ls_edate, ls_pdtgu
long ll_row

ll_row = dw_list.GetRow()
ls_pdtgu = dw_list.GetItemString(ll_row, "rfgub")

if dwo.name = "sdate" then
	ls_sdate = data
	ls_edate = this.GetItemString(row, "edate")
elseif dwo.name = "edate" then
	ls_sdate = this.GetItemString(row, "sdate")
	ls_edate = data
end if

dw_list.retrieve(ls_sdate, ls_edate)

dw_list.SelectRow(0, false)
dw_list.SelectRow(ll_row, true)

dw_insert.Retrieve(ls_sdate, ls_edate, ls_pdtgu)
end event

type pb_1 from u_pb_cal within w_pdm_01622
integer x = 709
integer y = 104
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'sdate', gs_code)

string ls_sdate, ls_edate, ls_pdtgu
long ll_row

ll_row = dw_list.GetRow()
ls_pdtgu = dw_list.GetItemString(ll_row, "rfgub")

ls_sdate = gs_code
ls_edate = dw_input.GetItemString(1, "edate")

dw_list.retrieve(ls_sdate, ls_edate)

dw_list.SelectRow(0, false)
dw_list.SelectRow(ll_row, true)

dw_insert.Retrieve(ls_sdate, ls_edate, ls_pdtgu)
end event

type pb_2 from u_pb_cal within w_pdm_01622
integer x = 1170
integer y = 104
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'edate', gs_code)

string ls_sdate, ls_edate, ls_pdtgu
long ll_row

ll_row = dw_list.GetRow()
ls_pdtgu = dw_list.GetItemString(ll_row, "rfgub")

ls_sdate = dw_input.GetItemString(1, "sdate")
ls_edate = gs_code

dw_list.retrieve(ls_sdate, ls_edate)

dw_list.SelectRow(0, false)
dw_list.SelectRow(ll_row, true)

dw_insert.Retrieve(ls_sdate, ls_edate, ls_pdtgu)
end event

type dw_list from u_d_popup_sort within w_pdm_01622
integer x = 50
integer y = 292
integer width = 1541
integer height = 1908
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01622_1"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;string ls_sdate, ls_edate, ls_pdtgu

dw_input.AcceptText()

if currentrow > 0 then
	this.SelectRow(0, false)
	this.SelectRow(currentrow, true)

	ls_sdate = dw_input.GetItemString(1, "sdate")
	ls_edate = dw_input.GetItemString(1, "edate")
	ls_pdtgu = this.GetItemString(currentrow, "rfgub")
	
	dw_insert.Retrieve(ls_sdate, ls_edate, ls_pdtgu)
end if
end event

event clicked;call super::clicked;this.SelectRow(0, false)
this.SelectRow(row, true)
end event

type rr_3 from roundrectangle within w_pdm_01622
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1641
integer y = 284
integer width = 2962
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01622
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 284
integer width = 1577
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

