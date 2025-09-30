$PBExportHeader$w_pdm_01370_popup.srw
$PBExportComments$** 용도별 단가 등록 PopUp
forward
global type w_pdm_01370_popup from w_inherite_popup
end type
type p_mod from uo_picture within w_pdm_01370_popup
end type
type p_del from uo_picture within w_pdm_01370_popup
end type
type p_1 from uo_picture within w_pdm_01370_popup
end type
type p_ins from uo_picture within w_pdm_01370_popup
end type
type rr_2 from roundrectangle within w_pdm_01370_popup
end type
end forward

global type w_pdm_01370_popup from w_inherite_popup
integer x = 1285
integer y = 148
integer width = 2784
integer height = 1488
string title = "MAKER별 단가 등록"
p_mod p_mod
p_del p_del
p_1 p_1
p_ins p_ins
rr_2 rr_2
end type
global w_pdm_01370_popup w_pdm_01370_popup

type variables
str_item str_dan
end variables

on w_pdm_01370_popup.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.p_del=create p_del
this.p_1=create p_1
this.p_ins=create p_ins
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.p_del
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_ins
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdm_01370_popup.destroy
call super::destroy
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_1)
destroy(this.p_ins)
destroy(this.rr_2)
end on

event open;call super::open;str_dan = Message.PowerObjectParm

p_inq.TriggerEvent("clicked")
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdm_01370_popup
boolean visible = false
integer x = 3095
integer y = 1076
integer width = 1467
integer height = 196
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_pdm_01370_popup
integer x = 2542
integer y = 12
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdm_01370_popup
boolean visible = false
integer x = 3095
integer y = 692
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;long count
String ls_sql

dw_1.Retrieve(str_dan.code, str_dan.name, str_dan.size, str_dan.jejos )
dw_1.ScrollToRow(1)

FOR count = 1 TO dw_1.RowCount()
	dw_1.SetItem(count, "rowcount", String(count))
	dw_1.SelectRow(count, False)
NEXT 


end event

type p_choose from w_inherite_popup`p_choose within w_pdm_01370_popup
boolean visible = false
integer x = 3095
integer y = 868
boolean enabled = false
end type

event p_choose::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//IF dw_1.getitemstring(ll_row, "cvstatus") = '1' and  li_use <> -1 then //거래중지
//   MessageBox("확 인", "거래중지인 자료는 선택할 수 없습니다.")
//   return
//END IF
//
//gs_gubun= dw_1.GetItemString(ll_Row, "cvgu")
//gs_code= dw_1.GetItemString(ll_Row, "cvcod")
//gs_codename= dw_1.GetItemString(ll_row,"cvnas2")
//
//Close(Parent)
//
end event

type dw_1 from w_inherite_popup`dw_1 within w_pdm_01370_popup
integer x = 27
integer y = 184
integer width = 2688
integer height = 1160
integer taborder = 40
string dataobject = "d_pdm_01370_popup"
boolean hscrollbar = true
end type

event dw_1::clicked;SelectRow(Row,False)
If Row > 1 Then
	p_del.enabled = true
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
End If
end event

event dw_1::rbuttondown;call super::rbuttondown;String ls_data

IF this.GetColumnName() = "mchno" Then  //설비
	gs_code = this.GetText()
	gs_codename = this.GetText()
	open(w_mchmst_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(row, "mchno", gs_code)
	this.SetItem(row, "mchnam", gs_codename)
	
ElseIF this.GetColumnName() = "kumno1" Then //금형

	gs_code = this.GetText()
	gs_codename = this.GetText()
	open(w_kummst_popup)
	if isnull(gs_code) or gs_code = "" then return

	Select KUMNAME
	into :ls_data
	From  KUMMST 
	WHERE KUMNO = :gs_code
	AND	GUBUN = 'M';

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","금형 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(row,'kumno1', '')
		this.SetItem(row, "kumname", '')
		Return 1
	End If

	this.SetItem(row, "kumno1", gs_code)
	this.SetItem(row, "kumname", gs_codename)

ElseIF this.GetColumnName() = "kumno2" Then //치공

	gs_code = this.GetText()
	gs_codename = this.GetText()
	open(w_kummst_popup)
	if isnull(gs_code) or gs_code = "" then return

	Select KUMNAME
	into :ls_data
	From  KUMMST 
	WHERE KUMNO = :gs_code
	AND	GUBUN = 'J';

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","치공구 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(row,'kumno2', '')
		this.SetItem(row, "jigname", '')
		Return 1
	End If

	this.SetItem(row, "kumno2", gs_code)
	this.SetItem(row, "jigname", gs_codename)

End If
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;SelectRow(currentrow,False)
end event

event dw_1::updatestart;call super::updatestart;//long		i, j
//String	ls_itnbr, ls_pspec, ls_opseq, ls_cvcod, ls_curren, ls_sdate, ls_edate
//
//For i = 1 To dw_1.RowCount()
//	
//	ls_itnbr  = dw_1.getItemString( i, "itnbr")
//	ls_pspec  = dw_1.getItemString( i, "pspec")
//	ls_opseq  = dw_1.getItemString( i, "opseq")
//	ls_cvcod  = dw_1.getItemString( i, "cvcod")
//	ls_curren = dw_1.getItemString( i, "curren")
//	ls_sdate  = dw_1.getItemString( i, "sdate")
//
//	For j= i+1 To dw_1.RowCount()
//		If dw_1.getItemString( j, "itnbr") = ls_itnbr and &
//			dw_1.getItemString( j, "pspec") = ls_pspec and &
//			dw_1.getItemString( j, "opseq") = ls_opseq and &
//			dw_1.getItemString( j, "cvcod") = ls_cvcod and &
//			dw_1.getItemString( j, "curren") = ls_curren Then
//	
//			SELECT TO_CHAR(TO_DATE(:ls_sdate,'YYYYMMDD') -1) 
//			INTO :ls_edate
//			FROM DUAL;
//			
//			dw_1.setItem(j, "edate", ls_edate)
//		End If
//	Next
//	
//Next
end event

event dw_1::itemchanged;call super::itemchanged;String ls_data, ls_data2
long ll_count

This.AcceptText()

If getColumnName() = 'mchno' Then
	
	ls_data2 = this.GetItemString(row, "mchno")

	Select MCHNAM
	into :ls_data
	From  MCHMST 
	WHERE MCHNO = :ls_data2;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","설비 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(row,'mchno', '')
		Return 1
	End If

	this.SetItem(row,'mchnam', ls_data)

ElseIf getColumnName() = 'kumno1' Then

	ls_data2 = this.GetItemString(row, "kumno1")

	Select KUMNAME
	into :ls_data
	From  KUMMST 
	WHERE KUMNO = :ls_data2
	AND	GUBUN = 'M';

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","금형 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(row,'kumno1', '')
		Return 1
	End If

	this.SetItem(row,'kumname', ls_data)

ElseIf getColumnName() = 'kumno2' Then

	ls_data2 = this.GetItemString(row, "kumno2")

	Select KUMNAME
	into :ls_data
	From  KUMMST 
	WHERE KUMNO = :ls_data2
	AND	GUBUN = 'J';

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","치공구 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(row,'kumno2', '')
		Return 1
	End If

	this.SetItem(row,'jigname', ls_data)

End If
end event

event dw_1::itemerror;call super::itemerror;return 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdm_01370_popup
integer x = 599
integer y = 2392
integer width = 1225
integer taborder = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdm_01370_popup
boolean visible = false
integer x = 718
integer y = 2344
integer taborder = 50
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_pdm_01370_popup
boolean visible = false
integer x = 1339
integer y = 2344
integer taborder = 70
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdm_01370_popup
boolean visible = false
integer x = 1029
integer y = 2344
integer taborder = 60
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdm_01370_popup
integer x = 398
integer y = 2392
integer width = 197
integer taborder = 20
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_pdm_01370_popup
integer x = 69
integer y = 2408
integer width = 315
string text = "거래처코드"
end type

type p_mod from uo_picture within w_pdm_01370_popup
integer x = 2176
integer y = 12
integer width = 178
integer height = 148
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;long		i, j
String	ls_itnbr, ls_pspec, ls_opseq, ls_cvcod, ls_curren, ls_sdate, ls_edate, ls_date

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_1.acceptText()

If dw_1.ModifiedCount() < 1 Then
	MessageBox("확인","변경된 값이 없습니다.")
	return
End If

For i = 1 To dw_1.RowCount()
	
	ls_itnbr  = dw_1.getItemString( i, "itnbr")
	ls_pspec  = dw_1.getItemString( i, "pspec")
	ls_opseq  = dw_1.getItemString( i, "opseq")
	ls_cvcod  = dw_1.getItemString( i, "cvcod")
	ls_curren = dw_1.getItemString( i, "curren")
	ls_date  = dw_1.getItemString( i, "sdate")

	For j= i+1 To dw_1.RowCount()
		If dw_1.getItemString( j, "itnbr") = ls_itnbr and &
			dw_1.getItemString( j, "pspec") = ls_pspec and &
			dw_1.getItemString( j, "opseq") = ls_opseq and &
			dw_1.getItemString( j, "cvcod") = ls_cvcod and &
			dw_1.getItemString( j, "curren") = ls_curren Then
			
			ls_sdate  = dw_1.getItemString( j, "sdate")
			
			If ls_sdate >= ls_date Then 
			
				SELECT TO_CHAR(TO_DATE(:ls_sdate,'YYYYMMDD') -1, 'YYYYMMDD')
				INTO :ls_edate
				FROM DUAL;
				
				If dw_1.getItemString( i, "edate") = '99999999' Then
					dw_1.setItem(i, "edate", ls_edate)
				End If
			Else
				SELECT TO_CHAR(TO_DATE(:ls_date,'YYYYMMDD') -1, 'YYYYMMDD')
				INTO :ls_edate
				FROM DUAL;
				
				If dw_1.getItemString( j, "edate") = '99999999' Then
					dw_1.setItem(j, "edate", ls_edate)
				End If
			
			End If
		End If
	Next
	
Next


if dw_1.Update() > 0 then 
  	COMMIT USING sqlca;														 
else
	ROLLBACK USING SQLCA;
	f_rollback()
	return
end if

p_inq.TriggerEvent(Clicked!)



end event

type p_del from uo_picture within w_pdm_01370_popup
integer x = 2359
integer y = 12
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;IF	MessageBox("삭제 확인", "삭제하시겠습니까? ", &
						         question!, yesno!, 2)  = 1		THEN
   SetPointer(HourGlass!)
	dw_1.DeleteRow(0)

   IF dw_1.Update() > 0	 THEN
   	COMMIT;
	ELSE
		ROLLBACK;
	END IF
END IF

p_inq.TriggerEvent("clicked")
end event

type p_1 from uo_picture within w_pdm_01370_popup
integer x = 4411
integer y = 8
integer width = 178
integer taborder = 130
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

type p_ins from uo_picture within w_pdm_01370_popup
integer x = 1993
integer y = 12
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;long count
String ls_max_toolseq

p_ins.enabled = true							
p_del.enabled = false
p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'

dw_1.InsertRow(0)

dw_1.SetItem(dw_1.rowCount(), "itnbr", str_dan.code)
dw_1.SetItem(dw_1.rowCount(), "opseq", str_dan.name)
dw_1.SetItem(dw_1.rowCount(), "gubun", '1')
dw_1.SetItem(dw_1.rowCount(), "cvcod", str_dan.size)
dw_1.SetItem(dw_1.rowCount(), "curren", str_dan.jejos)

FOR count = 1 TO dw_1.RowCount()
	dw_1.SetItem(count, "rowcount", String(count))
	dw_1.SelectRow(count,False)
NEXT 
end event

type rr_2 from roundrectangle within w_pdm_01370_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 172
integer width = 2715
integer height = 1188
integer cornerheight = 40
integer cornerwidth = 55
end type

