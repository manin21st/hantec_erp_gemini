$PBExportHeader$w_adt_00290_popup.srw
$PBExportComments$작업지시 등록(ADT)
forward
global type w_adt_00290_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_adt_00290_popup
end type
type pb_2 from u_pb_cal within w_adt_00290_popup
end type
type rr_1 from roundrectangle within w_adt_00290_popup
end type
end forward

global type w_adt_00290_popup from w_inherite_popup
integer width = 2715
integer height = 2052
string title = "주간계획(계산용) 선택 POPUO"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_adt_00290_popup w_adt_00290_popup

on w_adt_00290_popup.create
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

on w_adt_00290_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.ReSet()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'sdate', left(f_today(), 6) + '01')
dw_jogun.setitem(1, 'edate', f_today())

//입고창고 
f_child_saupj(dw_jogun, 'pdtgu', gs_saupj)
dw_jogun.SetItem(1, 'pdtgu', gs_gubun)

dw_jogun.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_adt_00290_popup
integer width = 1947
string dataobject = "d_adt_00290_popup_1"
end type

type p_exit from w_inherite_popup`p_exit within w_adt_00290_popup
integer x = 2501
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_adt_00290_popup
integer x = 2153
end type

event p_inq::clicked;call super::clicked;string sdate, edate, spdtgu

if dw_jogun.accepttext() = -1 then return 

spdtgu = trim(dw_jogun.object.pdtgu[1])
If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400,'[생산팀]')
	Return
End If

sdate = trim(dw_jogun.object.sdate[1])
edate = trim(dw_jogun.object.edate[1])

if IsNull(sdate) or sdate = "" THEN sdate = "10000101"
if IsNull(edate) or edate = "" THEN edate = "99991231"

dw_1.Retrieve(gs_sabu, spdtgu, sdate, edate)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_adt_00290_popup
integer x = 2327
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

If dw_1.GetItemString(ll_Row, "status") = '3' Or dw_1.GetItemString(ll_Row, "status") = '2' Then
	MessageBox("확 인", "지시나 취소된 내역은 선택하실 수 없습니다 !")
	return
END IF

gs_code= dw_1.GetItemString(ll_Row, "master_no")
gs_gubun= dw_1.GetItemString(ll_Row, "pdtgu")
gs_codename= dw_1.GetItemString(ll_Row, "sdate")
gs_codename2= dw_1.GetItemString(ll_Row, "edate")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_adt_00290_popup
integer width = 2651
string dataobject = "d_adt_00290_popup_2"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
	MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
	return
END IF

If dw_1.GetItemString(Row, "status") = '3' Or dw_1.GetItemString(Row, "status") = '2' Then
	MessageBox("확 인", "지시나 취소된 내역은 선택하실 수 없습니다 !")
	return
END IF	

gs_code= dw_1.GetItemString(Row, "master_no")
gs_gubun = dw_1.GetItemString(Row, "pdtgu")
gs_codename = dw_1.GetItemString(Row, "sdate")
gs_codename2 = dw_1.GetItemString(Row, "edate")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_adt_00290_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_adt_00290_popup
end type

type cb_return from w_inherite_popup`cb_return within w_adt_00290_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_adt_00290_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_adt_00290_popup
end type

type st_1 from w_inherite_popup`st_1 within w_adt_00290_popup
end type

type pb_1 from u_pb_cal within w_adt_00290_popup
integer x = 1339
integer y = 188
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_adt_00290_popup
integer x = 1838
integer y = 188
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_adt_00290_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 332
integer width = 2674
integer height = 1616
integer cornerheight = 40
integer cornerwidth = 55
end type

