$PBExportHeader$wq18.srw
$PBExportComments$품질이력등록
forward
global type wq18 from w_inherite
end type
type rr_3 from roundrectangle within wq18
end type
type dw_list from datawindow within wq18
end type
type dw_jogun from datawindow within wq18
end type
type cb_1 from commandbutton within wq18
end type
type dw_copy from datawindow within wq18
end type
type rr_1 from roundrectangle within wq18
end type
type rr_2 from roundrectangle within wq18
end type
end forward

global type wq18 from w_inherite
string title = "품질 이력 등록"
rr_3 rr_3
dw_list dw_list
dw_jogun dw_jogun
cb_1 cb_1
dw_copy dw_copy
rr_1 rr_1
rr_2 rr_2
end type
global wq18 wq18

on wq18.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_list=create dw_list
this.dw_jogun=create dw_jogun
this.cb_1=create cb_1
this.dw_copy=create dw_copy
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_jogun
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.dw_copy
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on wq18.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.dw_list)
destroy(this.dw_jogun)
destroy(this.cb_1)
destroy(this.dw_copy)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_jogun.SetItem(1, 'sdate', String(TODAY(), 'yyyymm'+'01'))
dw_jogun.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))
dw_insert.SetItem(1, 'ins_emp', gs_empno)
dw_insert.SetItem(1, 'empname', f_get_name5('02', gs_empno, ''))

f_mod_saupj(dw_jogun, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within wq18
integer x = 64
integer y = 1560
integer width = 4503
integer height = 668
string dataobject = "dq18_003"
boolean border = false
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event dw_insert::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr'
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr', gs_code)
		This.SetItem(row, 'itdsc', f_get_name5('13', gs_code, ''))
		
	Case 'cvcod'
		gs_gubun = '4'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', f_get_name5('11', gs_code, ''))
		
	Case 'ins_emp'
		gs_gubun = gs_dept
		
		Open(w_sawon_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'ins_emp', gs_code)
		This.SetItem(row, 'empname', f_get_name5('02', gs_code, ''))
		
	Case 'respofc'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'respofc', gs_code)
		This.Setitem(row, 'ofcname', f_get_name5('11', gs_code, ''))
		
End Choose
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr'		
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itdsc', '')
			Return
		End If
		
		This.SetItem(row, 'itdsc', f_get_name5('13', data, ''))
		
	Case 'cvcod'		
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		
	Case 'ins_emp'		
		If Trim(data) = '' OR IsNull(data) Then 
			This.SetItem(row, 'empname', '')
			Return
		End If
		
		This.SetItem(row, 'empname', f_get_name5('02', data, ''))
		
	Case 'respofc'
		If Trim(data) = '' OR IsNull(data) Then
			This.Setitem(row, 'ofcname', '')
			Return
		End If
		
		This.Setitem(row, 'ofcname', f_get_name5('11', data, ''))
		
	Case 'jodesc'
		
End Choose
end event

type p_delrow from w_inherite`p_delrow within wq18
boolean visible = false
integer x = 5435
integer y = 120
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within wq18
boolean visible = false
integer x = 5262
integer y = 120
boolean enabled = false
end type

type p_search from w_inherite`p_search within wq18
boolean visible = false
integer x = 4914
integer y = 124
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within wq18
integer x = 3749
end type

event p_ins::clicked;call super::clicked;dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_insert.SetItem(1, 'ins_emp', gs_empno)
dw_insert.SetItem(1, 'empname', f_get_name5('02', gs_empno, ''))

dw_insert.SetFocus()

end event

type p_exit from w_inherite`p_exit within wq18
end type

type p_can from w_inherite`p_can within wq18
end type

event p_can::clicked;call super::clicked;dw_jogun.ReSet()
dw_jogun.InsertRow(0)

dw_list.ReSet()

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_jogun.SetItem(1, 'sdate', String(TODAY(), 'yyyymm'+'01'))
dw_jogun.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_jogun, 'saupj')


end event

type p_print from w_inherite`p_print within wq18
boolean visible = false
integer x = 5088
integer y = 124
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within wq18
integer x = 3575
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_st

ls_st = dw_jogun.GetItemString(row, 'sdate')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못 되었습니다.')
		dw_jogun.SetColumn('sdate')
		dw_jogun.SetFocus()
		Return
	End If
End If

String ls_ed

ls_ed = dw_jogun.GetItemString(row, 'edate')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못 되었습니다.')
		dw_jogun.SetColumn('edate')
		dw_jogun.SetFocus()
		Return
	End If
End If

String ls_saupj, ls_gubun

ls_saupj = dw_jogun.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj

ls_gubun = dw_jogun.GetItemString(row, 'gubun')
If Trim(ls_gubun) = '' OR IsNull(ls_gubun) Then ls_gubun = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, ls_st, ls_ed, ls_gubun)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then
	MessageBox('조회내용 확인', '조회된 내용이 없습니다.')
	Return
End If


end event

type p_del from w_inherite`p_del within wq18
end type

event p_del::clicked;call super::clicked;Long   row

row = dw_list.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

dw_list.DeleteRow(row)

If dw_list.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	p_inq.PostEvent('Clicked')
	ib_any_typing = False
Else
	ROLLBACK USING SQLCA;
	f_message_chk(31, '[삭제실패]')
	Return
End If



end event

type p_mod from w_inherite`p_mod within wq18
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

If f_msg_update() <> 1 Then Return

If dw_insert.GetItemStatus(row, 0, Primary!) = DataModified! Then
Else
	//발생번호 생성
	String ls_saupj
	
	ls_saupj = dw_jogun.GetItemString(1, 'saupj')
	If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj
	
	String ls_day
	
	ls_day = String(TODAY(), 'yyyymm')
	
	String ls_max
	
	SELECT MAX(TO_NUMBER(SUBSTR(CLAJPNO, 7, 4)))
	  INTO :ls_max
	  FROM QCHIST
	 WHERE CLAJPNO LIKE :ls_day||'%' ;
	
	Long   ll_max
	If Trim(ls_max) = '' OR IsNull(ls_max) Then
		ll_max = 1
	Else
		ll_max = Long(ls_max) + 1
	End If
	
	String ls_jpno
	
	ls_jpno = ls_day + String(ll_max, '0000')
	
	dw_insert.SetItem(row, 'clajpno', ls_jpno )
	dw_insert.SetItem(row, 'saupj'  , ls_saupj)
End If

//필수사항 확인
String ls_clajpno
ls_clajpno = dw_insert.GetItemString(row, 'clajpno')
If Trim(ls_clajpno) = '' OR IsNull(ls_clajpno) Then
	f_message_chk(1400, '[발생번호 생성]')
	Return
End If

String ls_cladate
ls_cladate = dw_insert.GetItemString(row, 'cladate')
If Trim(ls_cladate) = '' OR IsNull(ls_cladate) Then
	f_message_chk(1400, '[발생일자]')
	dw_insert.SetColumn('cladate')
	dw_insert.SetFocus()
	Return
End If

Long   ll_claqty
ll_claqty = dw_insert.GetItemNumber(row, 'claqty')
If ll_claqty < 1 OR IsNull(ll_claqty) Then
	f_message_chk(1400, '[발생수량]')
	dw_insert.SetColumn('claqty')
	dw_insert.SetFocus()
	Return
End If

String ls_cladesc
ls_cladesc = dw_insert.GetItemString(row, 'cladesc')
If Trim(ls_cladesc) = '' OR IsNull(ls_cladesc) Then
	f_message_chk(1400, '[발생내용]')
	dw_insert.SetColumn('cladesc')
	dw_insert.SetFocus()
	Return
End If

String ls_clagbn
ls_clagbn = dw_insert.GetItemString(row, 'clagbn')
If Trim(ls_clagbn) = '' OR IsNull(ls_clagbn) Then
	f_message_chk(1400, '[발생구분]')
	Return
End If

String ls_itnbr
ls_itnbr = dw_insert.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	f_message_chk(1400, '[품번]')
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	Return
End If

String ls_insemp
ls_insemp = dw_insert.GetItemString(row, 'ins_emp')
If Trim(ls_insemp) = '' OR IsNull(ls_insemp) Then
	f_message_chk(1400, '[등록자]')
	dw_insert.SetColumn('ins_emp')
	dw_insert.SetFocus()
	Return
End If

//String ls_cvcod
//ls_cvcod = dw_insert.GetItemString(row, 'cvcod')
//If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
//	f_message_chk(1400, '[발견부서]')
//	dw_insert.SetColumn('cvcod')
//	dw_insert.SetFocus()
//	Return
//End If

//저장
If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	p_inq.PostEvent('Clicked')
	ib_any_typing = False
Else
	ROLLBACK USING SQLCA;
	f_message_chk(32, '[저장실패]')
	Return
End If

end event

type cb_exit from w_inherite`cb_exit within wq18
end type

type cb_mod from w_inherite`cb_mod within wq18
end type

type cb_ins from w_inherite`cb_ins within wq18
end type

type cb_del from w_inherite`cb_del within wq18
end type

type cb_inq from w_inherite`cb_inq within wq18
end type

type cb_print from w_inherite`cb_print within wq18
end type

type st_1 from w_inherite`st_1 within wq18
end type

type cb_can from w_inherite`cb_can within wq18
end type

type cb_search from w_inherite`cb_search within wq18
end type







type gb_button1 from w_inherite`gb_button1 within wq18
end type

type gb_button2 from w_inherite`gb_button2 within wq18
end type

type rr_3 from roundrectangle within wq18
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 32
integer width = 3401
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within wq18
integer x = 55
integer y = 244
integer width = 4539
integer height = 1168
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "dq18_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

String ls_jpno

ls_jpno = This.GetItemString(currentrow, 'clajpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('발생번호 오류', '선택한 자료의 발생번호가 잘못 되었습니다.')
	Return
End If

dw_insert.Retrieve(ls_jpno)
end event

event retrieveend;If rowcount < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(1, 'clajpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('발생번호 오류', '선택한 자료의 발생번호가 잘못 되었습니다.')
	Return
End If

dw_insert.Retrieve(ls_jpno)
end event

event clicked;If row < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(row, 'clajpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('발생번호 오류', '선택한 자료의 발생번호가 잘못 되었습니다.')
	Return
End If

dw_insert.Retrieve(ls_jpno)
end event

type dw_jogun from datawindow within wq18
integer x = 91
integer y = 40
integer width = 3191
integer height = 136
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "dq18_001"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type cb_1 from commandbutton within wq18
integer x = 4114
integer y = 1428
integer width = 448
integer height = 124
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "내용복사"
end type

event clicked;If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.RowCount() < 1 Then
	MessageBox('복사 확인', '내용 복사할 대상이 없습니다.')
	Return
End If

String  ls_cladate
ls_cladate = dw_insert.GetItemString(1, 'cladate')
If Trim(ls_cladate) = '' OR IsNull(ls_cladate) Then
	MessageBox('자료 확인', '복사할 내용이 없습니다.')
	Return
End If

String  ls_itnbr
ls_itnbr = dw_insert.GetItemString(1, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	MessageBox('자료 확인', '복사할 내용이 없습니다.')
	Return
End If

dw_copy.ReSet()
If dw_insert.RowsCopy(1, 1, Primary!, dw_copy, 1, Primary!) <> 1 Then
	MessageBox('내용 복사', '내용 복사에 실패 했습니다.')
	Return
End If

String  ls_null
Long    ll_null
SetNull(ls_null)
SetNull(ll_null)
dw_copy.SetItem(1, 'clajpno', ls_null)
dw_copy.SetItem(1, 'fatype' , ls_null)
dw_copy.SetItem(1, 'claqty' , ll_null)

dw_insert.ReSet()
If dw_copy.RowsCopy(1, 1, Primary!, dw_insert, 1, Primary!) <> 1 Then
	MessageBox('내용 복사', '복사 처리 중 오류가 발생했습니다.')
	Return
End If

end event

type dw_copy from datawindow within wq18
boolean visible = false
integer x = 4101
integer y = 1300
integer width = 475
integer height = 108
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "내용 복사 용"
string dataobject = "dq18_003"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within wq18
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 1556
integer width = 4567
integer height = 708
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within wq18
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 232
integer width = 4571
integer height = 1192
integer cornerheight = 40
integer cornerwidth = 55
end type

