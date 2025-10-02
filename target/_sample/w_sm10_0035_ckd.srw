$PBExportHeader$w_sm10_0035_ckd.srw
$PBExportComments$CKD 일일발주 현황
forward
global type w_sm10_0035_ckd from w_inherite
end type
end forward

global type w_sm10_0035_ckd from w_inherite
string title = "CKD 일 발주 현황"
end type
global w_sm10_0035_ckd w_sm10_0035_ckd

forward prototypes
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

on w_sm10_0035_ckd.create
call super::create
end on

on w_sm10_0035_ckd.destroy
call super::destroy
end on

event open;call super::open;dw_input.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_input.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", true) //// 삭제
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
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
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
m_main2.m_window.m_del.enabled = true  //// 삭제
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

type cb_exit from w_inherite`cb_exit within w_sm10_0035_ckd
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0035_ckd
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0035_ckd
end type

type st_1 from w_inherite`st_1 within w_sm10_0035_ckd
integer y = 3400
end type

type p_search from w_inherite`p_search within w_sm10_0035_ckd
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0035_ckd
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0035_ckd
end type

type p_mod from w_inherite`p_mod within w_sm10_0035_ckd
integer y = 3200
end type

event p_mod::clicked;call super::clicked;Long   ll_cnt 

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() <> 1 Then Return

//Long   i
//String ls_ord_h
//
//For i = 1 To ll_cnt
//	ls_ord_h = dw_insert.GetItemString(i, 'order_date_hantec')
//	If Trim(ls_ord_h) = '' OR IsNull(ls_ord_h) Then
//		MessageBox('한텍납품일', '한텍납품일을 입력 하십시오.')
//		dw_insert.SetColumn('order_date_hantec')
//		dw_insert.SetRow(i)
//		dw_insert.SetFocus()
//		dw_insert.ScrollToRow(i)
//		Return
//	End If
//Next

/* 취소 선택된 자료 확인 - 2013.10.02 by shingoon */
String  ls_gbn
String  ls_col1
String  ls_col2
String  ls_col3
ls_gbn = dw_input.GetItemString(1, 'ckdgbn')
Choose Case ls_gbn
	Case 'H' //현대기아
		ls_gbn  = 'HKM'
		ls_col1 = 'mitnbr'
		ls_col2 = 'pdno'
	Case 'G' //글로비스
		ls_gbn  = 'GLO'
		ls_col1 = 'mitnbr'
		ls_col2 = 'orderno'
	Case 'M' //모비스
		ls_gbn  = 'MOB'
		ls_col1 = 'van_mobis_ckd_b_itnbr'
		ls_col2 = 'van_mobis_ckd_b_balno'
		ls_col3 = 'van_mobis_ckd_b_balseq'
	Case 'P' //파워텍
		ls_gbn  = 'PTC'
		ls_col1 = 'itnbr'
		ls_col2 = 'order_no'
	Case 'W' //위아
		ls_gbn  = 'WIA'
		ls_col1 = 'van_mobis_ckd_b_itnbr'
		ls_col2 = 'van_mobis_ckd_b_balno'
		ls_col3 = 'van_mobis_ckd_b_balseq'
End Choose

Integer i
Integer li_find
String  ls_itnbr
String  ls_ordno
String  ls_ordsq
String  ls_dup
String  ls_err
Long    ll_err
For i = 1 To ll_cnt
	li_find = dw_insert.Find("f_cancel = 'Y'", i, ll_cnt)
	If li_find < 1 Then Exit
		
	Choose Case ls_gbn
		Case 'WIA', 'MOB'
			ls_itnbr = dw_insert.GetItemString(li_find, ls_col1)
			ls_ordno = dw_insert.GetItemString(li_find, ls_col2)
			ls_ordsq = dw_insert.GetItemString(li_find, ls_col3)
		Case 'HKM', 'GLO', 'PTC'
			ls_itnbr = dw_insert.GetItemString(li_find, ls_col1)
			ls_ordno = dw_insert.GetItemString(li_find, ls_col2)
			ls_ordsq = '0'
	End Choose
	
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	  INTO :ls_dup
	  FROM VAN_CKD_CANCEL
	 WHERE GBN = :ls_gbn AND ITNBR = :ls_itnbr AND ORDNO = :ls_ordno AND ORDSQ = :ls_ordsq ;
	
	If ls_dup = 'Y' Then
		UPDATE VAN_CKD_CANCEL
		   SET STS = 'Y'
		 WHERE GBN = :ls_gbn AND ITNBR = :ls_itnbr AND ORDNO = :ls_ordno AND ORDSQ = :ls_ordsq ;
	Else
		INSERT INTO VAN_CKD_CANCEL ( GBN, ITNBR, ORDNO, ORDSQ, STS )
		VALUES ( :ls_gbn, :ls_itnbr, :ls_ordno, :ls_ordsq, 'Y' ) ;
	End If
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('취소 처리 오류 - ' + String(ll_err), ls_err)
		Return
	End If
	
	i = li_find
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장 실패', '자료 저장 중 오류가 발생했습니다.')
	Return
End If
	
end event

type p_del from w_inherite`p_del within w_sm10_0035_ckd
integer y = 3200
end type

event p_del::clicked;call super::clicked;dw_insert.AcceptText()

If f_msg_delete() <> 1 Then Return

String ls_chk
Long   i

For i = 1 To dw_insert.RowCount()
	ls_chk = dw_insert.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		dw_insert.DeleteRow(i)	
		i = i - 1
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('삭제', '삭제 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('실패', '삭제 중 오류가 발생 했습니다.')
	Return
End If
end event

type p_inq from w_inherite`p_inq within w_sm10_0035_ckd
integer y = 3200
end type

event p_inq::clicked;call super::clicked;dw_input.AcceptText()

Long   row

row = dw_input.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_input.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_input.SetColumn('d_st')
		dw_input.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_input.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_input.SetColumn('d_ed')
		dw_input.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '시작일 보다 종료일이 빠릅니다.')
	dw_input.setColumn('d_st')
	dw_input.SetFocus()
	Return -1
End If

String ls_fac

ls_fac = dw_input.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) OR Trim(ls_fac) = '.' Then ls_fac = '%'

String ls_stit

ls_stit = dw_input.GetItemString(row, 'stit')
If Trim(ls_stit) = '' OR IsNull(ls_stit) Then ls_stit = '.'

String ls_edit

ls_edit = dw_input.GetItemString(row, 'edit')
If Trim(ls_edit) = '' OR IsNull(ls_edit) Then ls_edit = 'ZZZZZZZZZZZZZZZZZZZZ'

String ls_ckdgbn
ls_ckdgbn = dw_input.GetItemString(row, 'ckdgbn')

dw_insert.SetRedraw(False)

If ls_ckdgbn = 'H' OR ls_ckdgbn = 'G' Then
	dw_insert.Retrieve(ls_st, ls_ed, ls_fac, ls_stit, ls_edit)
Else
	dw_insert.Retrieve(ls_st, ls_ed, ls_stit, ls_edit)
End If

dw_insert.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_sm10_0035_ckd
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0035_ckd
integer y = 3200
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
dw_insert.SetTransObject(SQLCA)
end event

type p_exit from w_inherite`p_exit within w_sm10_0035_ckd
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_sm10_0035_ckd
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0035_ckd
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0035_ckd
integer x = 32
integer y = 52
integer width = 3397
integer height = 232
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0035_ckd_ret"
end type

event constructor;dw_input.SetTransObject(SQLCA)
dw_input.InsertRow(0)
end event

event itemchanged;
If row < 1 Then Return

String	sckd

Choose Case dwo.name
	Case 'stit'
		If Trim(This.GetItemString(row, 'edit')) = '' OR IsNull(This.GetItemString(row, 'edit')) Then
			This.SetItem(row, 'edit', data)
		End If
		
	Case 'd_st'
		If Trim(This.GetItemString(row, 'd_ed')) = '' OR IsNull(This.GetItemString(row, 'd_ed')) Then
			This.SetItem(row, 'd_ed', data)
		End If
		
	Case 'ckdgbn'
		sckd = data
		if sckd = 'H' then //현대기아
			dw_insert.dataobject = 'd_sm10_0035_ckd_hkmc'
		elseif sckd = 'M' then //모비스
			dw_insert.dataobject = 'd_sm10_0035_ckd_mobis'
		elseif sckd = 'G' then //글로비스
			dw_insert.dataobject = 'd_sm10_0035_ckd_globis'
		elseif sckd = 'W' then //위아
			dw_insert.dataobject = 'd_sm10_0035_ckd_wia'
		elseif sckd = 'P' then //파워텍
			dw_insert.dataobject = 'd_sm10_0035_ckd_ptc'
		end if
		dw_insert.settransobject(sqlca)

End Choose
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0035_ckd
integer x = 37
integer y = 328
integer width = 3489
integer height = 1964
string dataobject = "d_sm10_0035_ckd_hkmc"
end type

event dw_insert::constructor;call super::constructor;dw_insert.SetTransObject(SQLCA)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dw_insert::clicked;call super::clicked;//This.SelectRow(0, False)
//This.SelectRow(row, True)

f_multi_select(this)
end event

event dw_insert::itemchanged;call super::itemchanged;//This.AcceptText()
//
//String ls_base
//
//ls_base = dw_2.GetItemString(1, 'd_base')
//If Trim(ls_base) = '' OR IsNull(ls_base) Then
//	MessageBox('수정일 확인', '수정일을 입력 하십시오.')
//	dw_2.SetColumn('d_base')
//	dw_2.SetFocus()
//	Return -1
//End If
//
//Choose Case dwo.name
//	Case 'chk'
//		If data = 'Y' Then
//			This.SetItem(row, 'ord_han', This.GetItemString(row, 'order_date_hantec'))
//			This.SetItem(row, 'order_date_hantec', ls_base)
//		Else
//			If Trim(This.GetItemString(row, 'ord_han')) = '' OR IsNull(This.GetItemString(row, 'ord_han')) Then
//				Return
//			Else
//				This.SetItem(row, 'order_date_hantec', This.GetItemString(row, 'ord_han'))
//				This.SetItem(row, 'ord_han', '')
//			End If
//		End If
//		
//End Choose
end event

type cb_mod from w_inherite`cb_mod within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0035_ckd
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0035_ckd
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0035_ckd
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0035_ckd
end type

type r_head from w_inherite`r_head within w_sm10_0035_ckd
boolean visible = false
integer y = 3152
end type

type r_detail from w_inherite`r_detail within w_sm10_0035_ckd
integer y = 324
end type

