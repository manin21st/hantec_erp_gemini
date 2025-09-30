$PBExportHeader$w_lc_detail_popup2.srw
$PBExportComments$** L/C 품목정보 조회 선택2(한개선택)
forward
global type w_lc_detail_popup2 from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_lc_detail_popup2
end type
type pb_2 from u_pb_cal within w_lc_detail_popup2
end type
type rr_1 from roundrectangle within w_lc_detail_popup2
end type
end forward

global type w_lc_detail_popup2 from w_inherite_popup
integer x = 23
integer y = 148
integer width = 3721
integer height = 2036
string title = "L/C 품목정보 조회 선택"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_lc_detail_popup2 w_lc_detail_popup2

on w_lc_detail_popup2.create
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

on w_lc_detail_popup2.destroy
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

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_lc_detail_popup2
integer x = 14
integer y = 32
integer width = 2414
integer height = 144
string dataobject = "d_lc_detail_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_lc_detail_popup2
integer x = 3502
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_lc_detail_popup2
integer x = 3154
integer y = 8
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
           "       NVL(B.LCQTY,0) - NVL(B.BLQTY,0) AS JANQTY, D.ITDSC, D.ISPEC, A.POMAGA, D.JIJIL"+&  
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
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_lc_detail_popup2
integer x = 3328
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
ELSEIF dw_1.GetItemString(ll_row, "polchd_pomaga") = 'Y' then
	Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
	return 
END IF

gs_code = dw_1.GetItemString(ll_Row, "polcdt_polcno")
gs_codename = dw_1.GetItemString(ll_Row, "polcdt_baljpno")
gs_gubun = string(dw_1.GetItemNumber(ll_Row, "polcdt_balseq"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_lc_detail_popup2
integer x = 23
integer y = 196
integer width = 3657
integer height = 1724
integer taborder = 20
string dataobject = "d_lc_detail_popup2"
boolean hscrollbar = true
end type

event dw_1::clicked;call super::clicked;If Row <= 0 then
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
//ELSEIF this.GetItemString(row, "polchd_pomaga") = 'Y' then
//	Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
//	return 
END IF

gs_code = dw_1.GetItemString(Row, "polcdt_polcno")
gs_codename = dw_1.GetItemString(Row, "polcdt_baljpno")
gs_gubun = string(dw_1.GetItemNumber(Row, "polcdt_balseq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_lc_detail_popup2
boolean visible = false
integer x = 1029
integer y = 2208
integer width = 1001
integer taborder = 60
end type

type cb_1 from w_inherite_popup`cb_1 within w_lc_detail_popup2
integer x = 1591
integer y = 2124
end type

type cb_return from w_inherite_popup`cb_return within w_lc_detail_popup2
integer x = 2213
integer y = 2124
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_lc_detail_popup2
integer x = 1902
integer y = 2124
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_lc_detail_popup2
boolean visible = false
integer x = 366
integer y = 2208
integer width = 425
integer taborder = 50
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_lc_detail_popup2
boolean visible = false
integer x = 96
integer y = 2228
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_lc_detail_popup2
integer x = 635
integer y = 56
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_Date', gs_code)
end event

type pb_2 from u_pb_cal within w_lc_detail_popup2
integer x = 1079
integer y = 56
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_Date', gs_code)
end event

type rr_1 from roundrectangle within w_lc_detail_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 192
integer width = 3671
integer height = 1736
integer cornerheight = 40
integer cornerwidth = 55
end type

