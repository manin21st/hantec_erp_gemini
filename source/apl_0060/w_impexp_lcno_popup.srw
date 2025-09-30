$PBExportHeader$w_impexp_lcno_popup.srw
$PBExportComments$수입비용 물품대 입력시 L/C 번호 조회 선택
forward
global type w_impexp_lcno_popup from w_inherite_popup
end type
end forward

global type w_impexp_lcno_popup from w_inherite_popup
integer x = 1243
integer y = 940
integer width = 1413
integer height = 412
boolean titlebar = false
end type
global w_impexp_lcno_popup w_impexp_lcno_popup

on w_impexp_lcno_popup.create
call super::create
end on

on w_impexp_lcno_popup.destroy
call super::destroy
end on

event open;call super::open;if dw_1.Retrieve(gs_sabu, gs_code) < 1 then 
	f_message_chk(33, "[자료확인]")
	setnull(gs_code)
	Close(this)
	return 
end if

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_impexp_lcno_popup
integer x = 1399
integer y = 196
end type

type p_exit from w_inherite_popup`p_exit within w_impexp_lcno_popup
end type

type p_inq from w_inherite_popup`p_inq within w_impexp_lcno_popup
end type

type p_choose from w_inherite_popup`p_choose within w_impexp_lcno_popup
end type

type dw_1 from w_inherite_popup`dw_1 within w_impexp_lcno_popup
integer y = 20
integer width = 1385
integer height = 360
integer taborder = 10
string dataobject = "d_impexp_lcno_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "polcno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_impexp_lcno_popup
boolean visible = false
integer x = 782
integer y = 24
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_impexp_lcno_popup
integer x = 151
integer y = 500
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "polcno")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_impexp_lcno_popup
integer x = 489
integer y = 484
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_impexp_lcno_popup
boolean visible = false
integer x = 1879
integer y = 636
boolean default = false
end type

event cb_inq::clicked;//String scode,sname,sspec,sold_sql,swhere_clause,snew_sql,sgu
//Int    ipos
//
//dw_2.acceptText()
//sgu = dw_2.GetItemString(1,'ittyp')
//
//IF sgu ="" OR IsNull(sgu) THEN sgu ='%'
//
//IF IsNull(gs_code) THEN gs_code =""
//
//scode  = trim(sle_1.text)
//sname  = trim(sle_2.text)
//sspec  = trim(sle_3.text)
//
//IF IsNull(scode) THEN scode = ""
//IF IsNull(sname) THEN sname = ""
//IF IsNull(sspec) THEN sspec = ""
//
//sold_sql =  " SELECT ITNBR, ITDSC, ISPEC FROM ITEMAS WHERE GBWAN = 'Y' "  
//
//IF scode ="" AND sname ="" AND sspec = ""  THEN 
//	swhere_clause ="AND ITTYP LIKE'"+sgu+"'"
//	
//	snew_sql = sold_sql + swhere_clause
//	dw_1.SetSqlSelect(snew_sql)
//	
//	dw_1.Retrieve()
//	
//	dw_1.SelectRow(0,False)
//	dw_1.SelectRow(1,True)
//	dw_1.ScrollToRow(1)
//	dw_1.SetFocus()
//
//	RETURN
//END IF
//
//IF scode <> "" AND sname = "" AND sspec = "" THEN
//	scode = scode +'%'
//	swhere_clause ="AND ITNBR LIKE '"+ scode +"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode = "" AND sname <> "" AND sspec = "" THEN
//	sname = sname + '%'
//	swhere_clause ="AND ITDSC LIKE '"+ sname +"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode = "" AND sname = "" AND sspec <> "" THEN
//	sspec = sspec + '%'
//	swhere_clause ="AND ISPEC LIKE '"+ sspec +"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode <> "" AND sname <> "" AND sspec = "" THEN
//	scode = scode +'%'
//	sname = sname + '%'
//	swhere_clause ="AND ITNBR LIKE '"+ scode +"' AND ITDSC LIKE '"+sname+"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode <> "" AND sname = "" AND sspec <> "" THEN
//	scode = scode +'%'
//	sspec = sspec + '%'
//	swhere_clause ="AND ITNBR LIKE '"+ scode +"' AND ISPEC LIKE '"+sspec+"' AND ITTYP LIKE '"+sgu+"'"
//ELSEIF scode = "" AND sname <> "" AND sspec <> "" THEN
//	sname = sname + '%'
//	sspec = sspec + '%'
//	swhere_clause ="AND ITDSC LIKE '"+ sname +"' AND ISPEC LIKE '"+sspec+"' AND ITTYP LIKE '"+sgu+"'"
//END IF
//
//snew_sql = sold_sql + swhere_clause
//dw_1.SetSqlSelect(snew_sql)
//	
//IF dw_1.Retrieve() <= 0 THEN
//	f_message_chk(50,'')
//	sle_1.SetFocus()
//	Return
//END IF
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_impexp_lcno_popup
boolean visible = false
integer x = 357
integer y = 24
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_impexp_lcno_popup
boolean visible = false
integer x = 59
integer y = 36
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

