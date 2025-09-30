$PBExportHeader$wq19.srw
$PBExportComments$고객불만등록
forward
global type wq19 from w_inherite
end type
type dw_list from datawindow within wq19
end type
type dw_jogun from datawindow within wq19
end type
type rr_2 from roundrectangle within wq19
end type
type rr_1 from roundrectangle within wq19
end type
type rr_3 from roundrectangle within wq19
end type
end forward

global type wq19 from w_inherite
string title = "고객 불만 등록"
dw_list dw_list
dw_jogun dw_jogun
rr_2 rr_2
rr_1 rr_1
rr_3 rr_3
end type
global wq19 wq19

on wq19.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_jogun=create dw_jogun
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_jogun
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_3
end on

on wq19.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_jogun)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_jogun.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_jogun.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_jogun, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within wq19
integer x = 50
integer y = 1420
integer width = 4539
integer height = 816
string dataobject = "dq19_003"
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
		
	Case 'snddpt'
		gs_gubun = '4'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'snddpt' , gs_code)
		This.SetItem(row, 'sndname', f_get_name5('11', gs_code, ''))
		
	Case 'sndemp'
		gs_gubun = gs_dept
		
		Open(w_sawon_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'sndemp' , gs_code)
		This.SetItem(row, 'empname', f_get_name5('02', gs_code, ''))
		
	Case 'cust_no'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cust_no', gs_code)
		This.Setitem(row, 'cvnas'  , f_get_name5('11', gs_code, ''))

	Case 'chaemp'
		gs_gubun = gs_dept
		
		Open(w_sawon_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'chaemp' , gs_code)
		This.SetItem(row, 'chaname', f_get_name5('02', gs_code, ''))
		
	Case 'joddpt'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'joddpt' , gs_code)
		This.Setitem(row, 'jodname', f_get_name5('11', gs_code, ''))
		
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
		
	Case 'snddpt'		
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'sndname', '')
			Return
		End If
		
		This.SetItem(row, 'sndname', f_get_name5('11', data, ''))
		
	Case 'sndemp'		
		If Trim(data) = '' OR IsNull(data) Then 
			This.SetItem(row, 'empname', '')
			Return
		End If
		
		This.SetItem(row, 'empname', f_get_name5('02', data, ''))
		
	Case 'cust_no'
		If Trim(data) = '' OR IsNull(data) Then
			This.Setitem(row, 'cvnas', '')
			Return
		End If
		
		This.Setitem(row, 'cvnas', f_get_name5('11', data, ''))
	
	Case 'chaemp'		
		If Trim(data) = '' OR IsNull(data) Then 
			This.SetItem(row, 'chaname', '')
			Return
		End If
		
		This.SetItem(row, 'chaname', f_get_name5('02', data, ''))
		
	Case 'joddpt'
		If Trim(data) = '' OR IsNull(data) Then
			This.Setitem(row, 'jodname', '')
			Return
		End If
		
		This.Setitem(row, 'jodname', f_get_name5('11', data, ''))
		
End Choose
end event

type p_delrow from w_inherite`p_delrow within wq19
boolean visible = false
integer x = 3008
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within wq19
boolean visible = false
integer x = 2834
boolean enabled = false
end type

type p_search from w_inherite`p_search within wq19
boolean visible = false
integer x = 2487
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within wq19
integer x = 3749
end type

event p_ins::clicked;call super::clicked;dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within wq19
end type

type p_can from w_inherite`p_can within wq19
end type

event p_can::clicked;call super::clicked;dw_jogun.ReSet()
dw_jogun.InsertRow(0)

dw_list.ReSet()

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_jogun.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_jogun.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_jogun, 'saupj')
end event

type p_print from w_inherite`p_print within wq19
boolean visible = false
integer x = 2661
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within wq19
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

String ls_saupj

ls_saupj = dw_jogun.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, ls_st, ls_ed)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then
	MessageBox('조회내용 확인', '조회된 내용이 없습니다.')
	Return
End If


end event

type p_del from w_inherite`p_del within wq19
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

type p_mod from w_inherite`p_mod within wq19
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
	
	SELECT MAX(SUBSTR(CL_JPNO, 7, 3))
	  INTO :ls_max
	  FROM CUST_COMPLAINT
	 WHERE CL_JPNO LIKE :ls_day||'%' ;
	
	Long   ll_max
	If Trim(ls_max) = '' OR IsNull(ls_max) Then
		ll_max = 1
	Else
		ll_max = Long(ls_max) + 1
	End If
	
	String ls_jpno
	
	ls_jpno = ls_day + String(ll_max, '000')
	
	dw_insert.SetItem(row, 'cl_jpno', ls_jpno )
	dw_insert.SetItem(row, 'saupj'  , ls_saupj)
End If

//필수사항 확인
String ls_cljpno
ls_cljpno = dw_insert.GetItemString(row, 'cl_jpno')
If Trim(ls_cljpno) = '' OR IsNull(ls_cljpno) Then
	f_message_chk(1400, '[관리번호]')
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

String ls_clrdat
ls_clrdat = dw_insert.GetItemString(row, 'clrdat')
If Trim(ls_clrdat) = '' OR IsNull(ls_clrdat) Then
	f_message_chk(1400, '[발생일자]')
	dw_insert.SetColumn('clrdat')
	dw_insert.SetFocus()
	Return
End If

String ls_snddpt
ls_snddpt = dw_insert.GetItemString(row, 'snddpt')
If Trim(ls_snddpt) = '' OR IsNull(ls_snddpt) Then
	f_message_chk(1400, '[접수부서]')
	dw_insert.SetColumn('snddpt')
	dw_insert.SetFocus()
	Return
End If

String ls_cwhere
ls_cwhere = dw_insert.GetItemString(row, 'cwhere')
If Trim(ls_cwhere) = '' OR IsNull(ls_cwhere) Then
	f_message_chk(1400, '[발생장소]')
	dw_insert.SetColumn('cwhere')
	dw_insert.SetFocus()
	Return
End If

String ls_wongu
ls_wongu = dw_insert.GetItemString(row, 'wongu')
If Trim(ls_wongu) = '' OR IsNull(ls_wongu) Then
	f_message_chk(1400, '[원인구분]')
	dw_insert.SetColumn('wongu')
	dw_insert.SetFocus()
	Return
End If

String ls_wontxt
ls_wontxt = dw_insert.GetItemString(row, 'wontxt')
If Trim(ls_wontxt) = '' OR IsNull(ls_wontxt) Then
	f_message_chk(1400, '[불만내용]')
	dw_insert.SetColumn('wontxt')
	dw_insert.SetFocus()
	Return
End If

String ls_joddpt
ls_joddpt = dw_insert.GetItemString(row, 'joddpt')
If Trim(ls_joddpt) = '' OR IsNull(ls_joddpt) Then
	f_message_chk(1400, '[귀책처]')
	dw_insert.SetColumn('joddpt')
	dw_insert.SetFocus()
	Return
End If

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

type cb_exit from w_inherite`cb_exit within wq19
end type

type cb_mod from w_inherite`cb_mod within wq19
end type

type cb_ins from w_inherite`cb_ins within wq19
end type

type cb_del from w_inherite`cb_del within wq19
end type

type cb_inq from w_inherite`cb_inq within wq19
end type

type cb_print from w_inherite`cb_print within wq19
end type

type st_1 from w_inherite`st_1 within wq19
end type

type cb_can from w_inherite`cb_can within wq19
end type

type cb_search from w_inherite`cb_search within wq19
end type







type gb_button1 from w_inherite`gb_button1 within wq19
end type

type gb_button2 from w_inherite`gb_button2 within wq19
end type

type dw_list from datawindow within wq19
integer x = 55
integer y = 244
integer width = 4539
integer height = 1128
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "dq19_002"
boolean border = false
boolean livescroll = true
end type

event clicked;If row < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(row, 'cl_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('발생번호 오류', '선택한 자료의 발생번호가 잘못 되었습니다.')
	Return
End If

dw_insert.Retrieve(ls_jpno)
end event

event constructor;This.SetTransObject(SQLCA)
end event

event retrieveend;If rowcount < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(1, 'cl_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('발생번호 오류', '선택한 자료의 발생번호가 잘못 되었습니다.')
	Return
End If

dw_insert.Retrieve(ls_jpno)
end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

String ls_jpno

ls_jpno = This.GetItemString(currentrow, 'cl_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('발생번호 오류', '선택한 자료의 발생번호가 잘못 되었습니다.')
	Return
End If

dw_insert.Retrieve(ls_jpno)
end event

type dw_jogun from datawindow within wq19
integer x = 55
integer y = 40
integer width = 2199
integer height = 136
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "dq19_001"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type rr_2 from roundrectangle within wq19
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 232
integer width = 4571
integer height = 1152
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within wq19
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 1408
integer width = 4567
integer height = 840
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within wq19
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 32
integer width = 2281
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

