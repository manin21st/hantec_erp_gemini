$PBExportHeader$w_sm10_0053.srw
$PBExportComments$VAN 접수(M1 납기일수정)
forward
global type w_sm10_0053 from w_inherite
end type
type pb_1 from u_pic_cal within w_sm10_0053
end type
type pb_2 from u_pic_cal within w_sm10_0053
end type
end forward

global type w_sm10_0053 from w_inherite
string title = "MOBIS AUTO VAN 납품일 수정"
pb_1 pb_1
pb_2 pb_2
end type
global w_sm10_0053 w_sm10_0053

on w_sm10_0053.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_sm10_0053.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_input.SetItem(1, 'jisi_date', String(TODAY(), 'yyyymmdd'))
dw_input.SetItem(1, 'jisi_date2', String(TODAY(), 'yyyymmdd'))

end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", false) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("取消(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", true) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// 미리보기 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF변환
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true) //// 설정
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", true) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 true) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", true) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = true //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0053
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0053
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0053
end type

type st_1 from w_inherite`st_1 within w_sm10_0053
end type

type p_search from w_inherite`p_search within w_sm10_0053
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0053
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0053
end type

type p_mod from w_inherite`p_mod within w_sm10_0053
integer y = 3200
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   i
String ls_yodate

For i = 1 To dw_insert.RowCount()
	ls_yodate = dw_insert.GetItemString(i, 'yodate')
	If Trim(ls_yodate) = '' OR IsNull(ls_yodate) Then
		MessageBox('일자 입력', '납기일자를 입력 하십시오.')
		Return
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장', '자료가 저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('실패', '자료 저장 중 오류가 발생했습니다.')
End If
end event

type p_del from w_inherite`p_del within w_sm10_0053
integer y = 3200
end type

type p_inq from w_inherite`p_inq within w_sm10_0053
integer y = 3200
end type

event p_inq::clicked;call super::clicked;dw_input.AcceptText()

String ls_fac
String ls_itn
String ls_st
String ls_ed

ls_fac = dw_input.GetItemString(1, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = 'M1'

ls_itn = dw_input.GetItemString(1, 'itnbr')
If Trim(ls_itn) = '' OR IsNull(ls_itn) Then ls_itn = '%'

ls_st = dw_input.GetItemString(1, 'jisi_date')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '20000101'

ls_ed = dw_input.GetItemString(1, 'jisi_date2')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '29991231'

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	Return
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_saupj, ls_st, ls_ed, ls_itn, ls_fac)
dw_insert.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_sm10_0053
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0053
integer y = 3200
end type

type p_exit from w_inherite`p_exit within w_sm10_0053
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_sm10_0053
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0053
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0053
integer y = 56
integer width = 3488
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0053_1"
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0053
integer x = 37
integer y = 284
integer width = 3488
integer height = 1964
string dataobject = "d_sm10_0053_ckd_b"
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type cb_mod from w_inherite`cb_mod within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0053
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0053
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0053
end type

type r_head from w_inherite`r_head within w_sm10_0053
end type

type r_detail from w_inherite`r_detail within w_sm10_0053
end type

type pb_1 from u_pic_cal within w_sm10_0053
integer x = 809
integer y = 156
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pic_cal within w_sm10_0053
integer x = 1312
integer y = 156
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'jisi_date2', gs_code)

end event

