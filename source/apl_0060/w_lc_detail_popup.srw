$PBExportHeader$w_lc_detail_popup.srw
$PBExportComments$** L/C 품목정보 조회 선택(일괄선택)
forward
global type w_lc_detail_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_lc_detail_popup
end type
type pb_2 from u_pb_cal within w_lc_detail_popup
end type
type rr_1 from roundrectangle within w_lc_detail_popup
end type
end forward

global type w_lc_detail_popup from w_inherite_popup
integer x = 23
integer y = 148
integer width = 3771
integer height = 2040
string title = "L/C 품목정보 조회 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_lc_detail_popup w_lc_detail_popup

on w_lc_detail_popup.create
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

on w_lc_detail_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())

IF Gs_gubun = 'LOCAL' THEN 
	dw_jogun.SetItem(1, 'local_gub', 'Y')
END IF
dw_jogun.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_lc_detail_popup
integer x = 14
integer y = 20
integer width = 2427
string dataobject = "d_lc_detail_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_lc_detail_popup
integer x = 3575
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_lc_detail_popup
integer x = 3227
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sbuyer,sdatef,sdatet, sold_sql, swhere_clause, snew_sql, sLocal

if dw_jogun.AcceptText() = -1 then return 

sdatef = TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet = TRIM(dw_jogun.GetItemString(1,"to_date"))

sLocal = TRIM(dw_jogun.GetItemString(1,"local_gub"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[수주일자]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF
			
sold_sql = "SELECT B.POLCNO, C.ITNBR, C.PSPEC, B.BALJPNO, B.BALSEQ, B.LCQTY, B.BLQTY, B.LCPRC, "+&  
           "       NVL(B.LCQTY,0) - NVL(B.BLQTY,0) AS JANQTY, D.ITDSC, D.ISPEC, 'N' AS OPT, A.POMAGA,  "+&  
           "       D.JIJIL, A.POCURR, C.SAUPJ, D.ISPEC_CODE, C.BALQTY, C.UNAMT "+&  
			  "  FROM POLCHD A, POLCDT B, POBLKT C, ITEMAS D " + & 
		     " WHERE A.SABU = B.SABU AND A.POLCNO = B.POLCNO AND " + & 
			  "		 B.SABU = C.SABU AND B.BALJPNO = C.BALJPNO AND B.BALSEQ = C.BALSEQ AND " + & 
			  "		 C.ITNBR = D.ITNBR(+) AND A.SABU = '"+ gs_sabu +"' "

IF sdatef ="" OR IsNull(sdatef) THEN
	swhere_clause = " "
ELSE
	swhere_clause = " AND A.OPNDAT >= '"+sdatef+"'"
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
ELSE
	swhere_clause = swhere_clause + " AND A.OPNDAT <= '"+sdatet+"'"
END IF

IF sLocal = 'Y' THEN
	swhere_clause = swhere_clause + " AND A.LOCALYN = 'Y'"
ELSEIF sLocal = 'N' THEN
	swhere_clause = swhere_clause + " AND A.LOCALYN = 'N'"
END IF

snew_sql = sold_sql + swhere_clause

dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_lc_detail_popup
integer x = 3401
integer y = 12
end type

event p_choose::clicked;call super::clicked;gs_code = 'Y'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_lc_detail_popup
integer x = 27
integer y = 184
integer width = 3698
integer height = 1716
integer taborder = 20
string dataobject = "d_lc_detail_popup1"
boolean hscrollbar = true
end type

event dw_1::clicked;call super::clicked;//If Row <= 0 then
//	dw_1.SelectRow(0,False)
//	b_flag =True
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	
//	b_flag = False
//END IF
//
//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "saledt")
//gs_codename= string(dw_1.GetItemNumber(Row, "saleno"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;return 1
end event

event dw_1::itemchanged;/* 잔량이 없는 경우에는 선택할 수 없음 */
if isnull(this.GetItemDecimal(row, "janqty")) or this.GetItemDecimal(row, "janqty") = 0 then
	Messagebox("확 인", "잔량이 없는 경우 선택할 수 없읍니다", stopsign!)
	this.setitem(row, "opt", 'N')
	return 1
elseif this.GetItemString(row, "polchd_pomaga") = 'Y' then
	Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
	this.setitem(row, "opt", 'N')
	return 1
end if
end event

event dw_1::itemerror;return 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_lc_detail_popup
boolean visible = false
integer x = 1015
integer y = 204
integer width = 1001
integer taborder = 60
end type

type cb_1 from w_inherite_popup`cb_1 within w_lc_detail_popup
integer x = 1874
integer y = 2148
end type

type cb_return from w_inherite_popup`cb_return within w_lc_detail_popup
integer x = 2496
integer y = 2148
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_lc_detail_popup
integer x = 2185
integer y = 2148
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_lc_detail_popup
boolean visible = false
integer x = 352
integer y = 204
integer width = 425
integer taborder = 50
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_lc_detail_popup
boolean visible = false
integer x = 82
integer y = 224
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_lc_detail_popup
integer x = 640
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_lc_detail_popup
integer x = 1074
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_lc_detail_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 180
integer width = 3717
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

