$PBExportHeader$w_sal_06000.srw
$PBExportComments$환율등록
forward
global type w_sal_06000 from w_inherite
end type
type pb_1 from u_pic_cal within w_sal_06000
end type
end forward

global type w_sal_06000 from w_inherite
integer width = 6158
integer height = 3880
string title = "환율 등록"
pb_1 pb_1
end type
global w_sal_06000 w_sal_06000

on w_sal_06000.create
int iCurrent
call super::create
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
end on

on w_sal_06000.destroy
call super::destroy
destroy(this.pb_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_input.InsertRow(0)
TriggerEvent('ue_open')


end event

event ue_open;call super::ue_open;ib_any_typing =False
dw_input.SetItem(1,'date', f_today())
cb_inq.Post PostEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_append;call super::ue_append;p_inq.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 true) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = true //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_06000
integer y = 3628
end type

type sle_msg from w_inherite`sle_msg within w_sal_06000
integer y = 3444
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06000
integer y = 3444
end type

type st_1 from w_inherite`st_1 within w_sal_06000
integer y = 3416
end type

type p_search from w_inherite`p_search within w_sal_06000
integer y = 3448
end type

type p_addrow from w_inherite`p_addrow within w_sal_06000
integer y = 3448
end type

type p_delrow from w_inherite`p_delrow within w_sal_06000
integer y = 3448
end type

type p_mod from w_inherite`p_mod within w_sal_06000
integer y = 3448
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type p_del from w_inherite`p_del within w_sal_06000
integer y = 3448
end type

event p_del::clicked;call super::clicked;/*-------------------------*/
/* 통화 개별 단위 삭제     */
/*-------------------------*/

string sdate,scurr
int    row

IF dw_input.AcceptText() = -1 THEN Return

sdate = Trim(dw_input.GetItemString(1, 'date'))

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()
	scurr = dw_insert.GetItemSTring(row,'rcurr')
   IF MessageBox("삭 제",String(sdate, '@@@@.@@.@@') + "의 " + scurr +"가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
   cb_inq.PostEvent(Clicked!)
End If

end event

type p_inq from w_inherite`p_inq within w_sal_06000
integer y = 3448
end type

event p_inq::clicked;call super::clicked;string sdate

IF dw_input.AcceptText() = -1 THEN Return

sdate = Trim(dw_input.GetItemString(1, 'date'))

If sdate = '' Or IsNull(sdate) Then Return

If f_datechk(sdate) = -1 Then
   f_message_chk(40,'[일자/ 오류]')
	dw_input.SetFocus()
	Return
End If

If dw_insert.Retrieve(sdate) > 0 Then	
	dw_input.Enabled = False
Else
	sle_msg.Text = '조회된 건수가 없습니다.!!'
End If



end event

type p_print from w_inherite`p_print within w_sal_06000
integer y = 3448
end type

type p_can from w_inherite`p_can within w_sal_06000
integer y = 3448
end type

event p_can::clicked;call super::clicked;dw_input.Enabled = True
dw_input.SetFocus()

dw_insert.Reset()

end event

type p_exit from w_inherite`p_exit within w_sal_06000
integer y = 3448
end type

type p_ins from w_inherite`p_ins within w_sal_06000
integer y = 3448
end type

event p_ins::clicked;call super::clicked;string sdate
int    rcnt,row

IF dw_input.AcceptText() = -1 THEN Return

sdate = Trim(dw_input.GetItemString(1, 'date'))
If f_datechk(sdate) = -1 Then
   f_message_chk(40,'[일자 오류]')
	Return
End If

// 일자 setting후 New! 상태로...
row = dw_insert.InsertRow(0)
dw_insert.SetItem(row,'rdate',sdate)
dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(row)
dw_insert.SetColumn('rcurr')

dw_input.Enabled = False   // 추가중 일자변경 불가
end event

type p_new from w_inherite`p_new within w_sal_06000
integer y = 3448
end type

type dw_input from w_inherite`dw_input within w_sal_06000
integer y = 56
integer width = 3489
integer height = 144
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06000_1"
end type

type cb_delrow from w_inherite`cb_delrow within w_sal_06000
boolean visible = false
integer y = 3464
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_06000
boolean visible = false
integer y = 3464
end type

type dw_insert from w_inherite`dw_insert within w_sal_06000
integer y = 252
integer taborder = 20
string dataobject = "d_sal_06000"
end type

event dw_insert::itemchanged;String sCurr
Long   nRow, cRow , ll_count ,i , ll_rstan 
Double dRstan, dUsd

nRow = GetRow()
If nRow <= 0 Then Return

sCurr = GetItemString(nRow, 'rcurr')

Choose Case GetColumnName()
	/* 기준환율 */
	Case 'rstan'
		dRstan = Double(GetText())
		
		/* 대미환산율 계산 */
		If sCurr = 'USD' Then
			ll_count = this.rowcount()
			
			for i = 1 to ll_count
				ll_rstan = this.getitemnumber(i,'rstan')
				this.setitem(i,'usdrat',round(ll_rstan/drstan,4))
			next
			SetItem(nRow, 'usdrat',1)
		Else
			cRow = Find("rcurr = 'USD'",1, RowCount())
			If cRow > 0 Then
				dUsd = GetItemNumber(cRow, 'rstan')
				If IsNull(dUsd) Then dUsd = 0
				
				If dUsd > 0 Then SetItem(nRow, 'usdrat', Round(dRstan/dUsd,4))
			End If
		End If
End Choose
end event

event dw_insert::itemerror;Return 1
end event

type cb_mod from w_inherite`cb_mod within w_sal_06000
boolean visible = false
integer y = 3464
end type

type cb_ins from w_inherite`cb_ins within w_sal_06000
boolean visible = false
integer y = 3464
end type

type cb_del from w_inherite`cb_del within w_sal_06000
boolean visible = false
integer y = 3464
end type

type cb_inq from w_inherite`cb_inq within w_sal_06000
boolean visible = false
integer y = 3464
end type

type cb_print from w_inherite`cb_print within w_sal_06000
boolean visible = false
integer y = 3452
end type

type cb_can from w_inherite`cb_can within w_sal_06000
boolean visible = false
integer y = 3464
end type

type cb_search from w_inherite`cb_search within w_sal_06000
boolean visible = false
integer y = 3448
end type

type gb_10 from w_inherite`gb_10 within w_sal_06000
integer y = 3444
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06000
integer y = 3444
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06000
integer y = 3444
end type

type r_head from w_inherite`r_head within w_sal_06000
integer height = 156
end type

type r_detail from w_inherite`r_detail within w_sal_06000
integer y = 240
end type

type pb_1 from u_pic_cal within w_sal_06000
integer x = 617
integer y = 92
integer width = 78
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'date', gs_code)

end event

