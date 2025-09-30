$PBExportHeader$w_itemas_popup5.srw
$PBExportComments$** 품목코드 조회 선택(품명,규격)완료처리된 품목
forward
global type w_itemas_popup5 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itemas_popup5
end type
end forward

global type w_itemas_popup5 from w_inherite_popup
integer x = 219
integer y = 588
integer width = 2286
integer height = 1504
boolean titlebar = false
rr_1 rr_1
end type
global w_itemas_popup5 w_itemas_popup5

on w_itemas_popup5.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itemas_popup5.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string swhere_clause, sold_sql, snew_sql
Long nRow

If gs_gubun = '%' Then
  IF gs_codename = "품명" THEN
	 swhere_clause =" AND ITDSC LIKE '"+ gs_code + "%' "
  ELSEIF gs_codename = "규격" THEN
	 swhere_clause =" AND ISPEC LIKE '"+ gs_code +"%' "
  ELSEIF gs_codename = "재질" THEN
	 swhere_clause =" AND JIJIL LIKE '"+ gs_code +"%' "
  ELSEIF gs_codename = "품번" THEN
	 swhere_clause =" AND ITNBR LIKE '"+ gs_code +"%' "
	END IF
Else
  IF gs_codename = "품명" THEN
	 swhere_clause =" AND ITDSC = '"+ gs_code +"' "
  ELSEIF gs_codename = "규격" THEN
	 swhere_clause =" AND ISPEC = '"+ gs_code +"' "
  ELSEIF gs_codename = "재질" THEN
	 swhere_clause =" AND JIJIL = '"+ gs_code +"' "
  ELSEIF gs_codename = "품번" THEN
	 swhere_clause =" AND ITNBR LIKE '"+ gs_code +"%' "
	END IF
End If

sold_sql = dw_1.Getsqlselect()
snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)
	
if dw_1.Retrieve() < 1 then 
	f_message_chk(33, "[자료확인]")
	setnull(gs_code)
	setnull(gs_codename)
	setnull(gs_gubun)
	Close(this)
	return 
end if	

nRow = dw_1.Find("useyn = '0'",1,dw_1.RowCount())
If nRow <=0 Then nRow = 1

dw_1.SelectRow(0,False)
dw_1.SelectRow(nRow,True)
dw_1.ScrollToRow(nRow)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup5
boolean visible = false
integer x = 297
integer y = 1728
integer width = 155
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_itemas_popup5
integer x = 2094
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup5
boolean visible = false
integer x = 1682
integer y = 1728
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_itemas_popup5
integer x = 1920
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
IF dw_1.GetItemString(ll_Row, "useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(ll_Row, "itnbr")
gs_codename= dw_1.GetItemString(ll_row,"itdsc")
gs_gubun= dw_1.GetItemString(ll_row,"ispec")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup5
integer x = 27
integer y = 172
integer width = 2222
integer height = 1304
integer taborder = 10
string dataobject = "d_itemas_popup5"
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

//IF dw_1.GetItemString(Row, "useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
IF dw_1.GetItemString(Row, "useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(Row, "itnbr")
gs_codename= dw_1.GetItemString(row,"itdsc")
gs_gubun= dw_1.GetItemString(row,"ispec")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup5
boolean visible = false
integer x = 722
integer y = 1732
integer width = 1001
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup5
integer x = 727
integer y = 1680
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup5
integer x = 923
integer y = 1640
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup5
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

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup5
boolean visible = false
integer x = 297
integer y = 1732
integer width = 425
boolean enabled = false
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup5
boolean visible = false
integer y = 1744
integer width = 251
long backcolor = 12632256
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_itemas_popup5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 168
integer width = 2245
integer height = 1316
integer cornerheight = 40
integer cornerwidth = 55
end type

