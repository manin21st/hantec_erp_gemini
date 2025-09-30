$PBExportHeader$w_lc_popup.srw
$PBExportComments$L/C번호 조회
forward
global type w_lc_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_lc_popup
end type
type pb_2 from u_pb_cal within w_lc_popup
end type
type rr_1 from roundrectangle within w_lc_popup
end type
type rr_3 from roundrectangle within w_lc_popup
end type
end forward

global type w_lc_popup from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3392
integer height = 2116
string title = "L/C번호 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_3 rr_3
end type
global w_lc_popup w_lc_popup

on w_lc_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_3
end on

on w_lc_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'fdate', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'tdate', f_today())

IF Gs_gubun = 'LOCAL' THEN 
	dw_jogun.SetItem(1, 'sgubun', 'Y')
END IF
	
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)



end event

type dw_jogun from w_inherite_popup`dw_jogun within w_lc_popup
integer x = 14
integer y = 36
integer width = 2473
integer height = 248
string dataobject = "d_lc_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_lc_popup
integer x = 3026
integer y = 84
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_lc_popup
integer x = 2679
integer y = 84
end type

event p_inq::clicked;call super::clicked;String sGubun, sFdate, sTdate, smagbn, sSaupj

if dw_jogun.AcceptText() = -1 then return

sGubun = dw_jogun.GetItemString(1, 'sgubun')
sFdate = trim(dw_jogun.GetItemString(1, 'fdate'))
sTdate = trim(dw_jogun.GetItemString(1, 'tdate'))
sMagbn = trim(dw_jogun.GetItemString(1, 'magbn'))
sSaupj = trim(dw_jogun.GetItemString(1, 'saupj'))

IF sFdate = "" OR IsNull(sFdate) THEN
	sFdate = '10000101'
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	sSaupj = '%'
END IF

IF sFdate = "" OR IsNull(sFdate) THEN
	sFdate = '10000101'
END IF

dw_1.SetRedraw(FALSE)

IF sGubun = 'Y' THEN
	dw_1.SetFilter("localyn ='Y'")
ELSEIF sGubun = 'N' THEN
	dw_1.SetFilter("localyn ='N'")
ELSE
	dw_1.SetFilter("")
END IF
dw_1.Filter()

IF dw_1.Retrieve(gs_sabu, sfdate, stdate, sMagbn, sSaupj) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn(1)
	dw_jogun.SetFocus()
	dw_1.SetRedraw(true)
	Return
END IF
dw_1.SetRedraw(true)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_lc_popup
integer x = 2853
integer y = 84
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "polcno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_lc_popup
integer x = 32
integer y = 312
integer width = 3296
integer height = 1676
string dataobject = "d_lc_popup1"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "polcno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_lc_popup
boolean visible = false
integer x = 1106
integer y = 2296
integer width = 1001
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_lc_popup
integer x = 1015
integer y = 2244
end type

type cb_return from w_inherite_popup`cb_return within w_lc_popup
integer x = 1637
integer y = 2244
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_lc_popup
integer x = 1326
integer y = 2244
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_lc_popup
boolean visible = false
integer x = 443
integer y = 2296
integer width = 425
boolean enabled = false
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_lc_popup
boolean visible = false
integer x = 174
integer y = 2316
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_lc_popup
integer x = 1829
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fdate', gs_code)
end event

type pb_2 from u_pb_cal within w_lc_popup
integer x = 2295
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('tdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'tdate', gs_code)
end event

type rr_1 from roundrectangle within w_lc_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 308
integer width = 3333
integer height = 1688
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_lc_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2510
integer y = 44
integer width = 841
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

