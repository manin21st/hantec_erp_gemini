$PBExportHeader$w_itemas_popup6.srw
$PBExportComments$** 품목코드 조회 선택(품명,규격)전체품목
forward
global type w_itemas_popup6 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itemas_popup6
end type
end forward

global type w_itemas_popup6 from w_inherite_popup
integer x = 183
integer y = 512
integer width = 2322
integer height = 1528
boolean titlebar = false
rr_1 rr_1
end type
global w_itemas_popup6 w_itemas_popup6

on w_itemas_popup6.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itemas_popup6.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string swhere_clause, sold_sql, snew_sql
Long nRow

If gs_gubun = '%' Then
  IF gs_codename = "품명" THEN
	 swhere_clause =" WHERE ITDSC LIKE '"+ gs_code + "%' "
  ELSEIF gs_codename = "규격" THEN
	 swhere_clause =" WHERE ISPEC LIKE '"+ gs_code +"%' "
  ELSEIF gs_codename = "재질" THEN
	 swhere_clause =" WHERE JIJIL LIKE '"+ gs_code +"%' "
  END IF
Else
  IF gs_codename = "품명" THEN
	 swhere_clause =" WHERE ITDSC = '"+ gs_code +"' "
  ELSEIF gs_codename = "규격" THEN
	 swhere_clause =" WHERE ISPEC = '"+ gs_code +"' "
  ELSEIF gs_codename = "재질" THEN
	 swhere_clause =" WHERE JIJIL = '"+ gs_code +"' "
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

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup6
boolean visible = false
integer x = 389
integer y = 1608
integer width = 137
integer height = 84
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_itemas_popup6
integer x = 2130
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup6
boolean visible = false
integer x = 713
integer y = 1568
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_itemas_popup6
integer x = 1957
integer y = 12
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

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup6
integer x = 32
integer y = 184
integer width = 2254
integer height = 1312
integer taborder = 10
string dataobject = "d_itemas_popup6"
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

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup6
boolean visible = false
integer x = 27
integer y = 1552
integer width = 1001
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup6
integer x = 1312
integer y = 1560
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup6
integer x = 923
integer y = 1640
end type

