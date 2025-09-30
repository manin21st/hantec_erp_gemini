$PBExportHeader$w_ewol.srw
forward
global type w_ewol from w_inherite_popup
end type
type rr_1 from roundrectangle within w_ewol
end type
end forward

global type w_ewol from w_inherite_popup
integer width = 1033
integer height = 728
string title = "납품처재고 마감"
rr_1 rr_1
end type
global w_ewol w_ewol

on w_ewol.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ewol.destroy
call super::destroy
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_ewol
integer x = 265
integer y = 356
integer width = 498
integer height = 92
string dataobject = "d_ewol_001"
end type

event dw_jogun::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type p_exit from w_inherite_popup`p_exit within w_ewol
integer x = 800
integer y = 28
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::ue_lbuttondown;//
PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;//
PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_ewol
integer x = 453
integer y = 28
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_inq::ue_lbuttondown;//
PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event p_inq::ue_lbuttonup;//
PictureName = 'C:\erpman\image\생성_up.gif'
end event

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

If dw_jogun.RowCount() < 1 Then Return

String ls_ym

ls_ym = dw_jogun.GetItemString(1, 'd_yymm')
If Trim(ls_ym) = '' OR IsNull(ls_ym) Then
	MessageBox('기준 월 확인!', '기준 월을 입력 하십시오!', Information!)
	Return
End If

Long   ll_cnt
SELECT COUNT('X')
  INTO :ll_cnt
  FROM STOCK_NAPUM_EWOL
 WHERE SAUPJ = :gs_saupj
   AND YYMM  = :ls_ym
	AND EWOL  = 'A00' ;
If ll_cnt > 0 Then
	If MessageBox('기존 자료 확인!', '이미 자료가 생성되어 있습니다.~r~r~n~n기존 자료는 삭제 됩니다. 계속 하시겠습니까?', &
	              Question!, YesNo!, 2) <> 1 Then
		Return
	End If
	
	DELETE STOCK_NAPUM_EWOL
	 WHERE SAUPJ = :gs_saupj
	   AND YYMM  = :ls_ym
		AND EWOL  = 'A00' ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('기존자료 삭제 오류', '기존자료 삭제 중 오류가 발생했습니다.')
		Return
	End If
End If

INSERT INTO STOCK_NAPUM_EWOL
(SAUPJ, YYMM, EWOL, FACTORY, ITNBR, IQTY, OQTY, JQTY, AMT, CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, BIGO)
  SELECT SAUPJ, :ls_ym, 'A00', FACTORY, ITNBR, 0, 0, SUM(JEGO_QTY), 0,
  			TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), :gs_empno,
  			NULL, NULL, NULL,	'이월재고 생성'
    FROM STOCK_NAPUM
GROUP BY SAUPJ, FACTORY, ITNBR ;

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('생성 완료!', LEFT(ls_ym, 4) + '년' + RIGHT(ls_ym, 2) + '월의 이월 자료가 생성 되었습니다.')
Else
	MessageBox('SQLCA Err Information!!', SQLCA.SQLERRTEXT)
	ROLLBACK USING SQLCA; 
	MessageBox('생성 오류!', LEFT(ls_ym, 4) + '년' + RIGHT(ls_ym, 2) + '월의 이월 자료 생성 중 오류가 발생 했습니다.')
	Return
End If

end event

type p_choose from w_inherite_popup`p_choose within w_ewol
integer x = 626
integer y = 28
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event p_choose::ue_lbuttonup;//
PictureName = 'C:\erpman\image\삭제_up.gif'
end event

event p_choose::ue_lbuttondown;//
PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

event p_choose::clicked;call super::clicked;dw_jogun.AcceptText()

If dw_jogun.RowCount() < 1 Then Return

String ls_ym

ls_ym = dw_jogun.GetItemString(1, 'd_yymm')
If Trim(ls_ym) = '' OR IsNull(ls_ym) Then
	MessageBox('기준 월 확인!', '기준 월을 입력 하십시오!', Information!)
	Return
End If
	
DELETE STOCK_NAPUM_EWOL
 WHERE SAUPJ = :gs_saupj
	AND YYMM  = :ls_ym
	AND EWOL  = 'A00' ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('자료 삭제 오류', '자료 삭제 중 오류가 발생했습니다.')
	Return
End If

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('삭제 완료!', LEFT(ls_ym, 4) + '년' + RIGHT(ls_ym, 2) + '월의 자료가 삭제 되었습니다.')
Else
	ROLLBACK USING SQLCA; 
	MessageBox('자료 삭제 오류', '자료 삭제 중 오류가 발생했습니다.', Information!)
	Return
End If

end event

type dw_1 from w_inherite_popup`dw_1 within w_ewol
boolean visible = false
integer x = 32
integer y = 28
integer width = 142
integer height = 100
boolean enabled = false
boolean vscrollbar = false
boolean livescroll = false
end type

type sle_2 from w_inherite_popup`sle_2 within w_ewol
end type

type cb_1 from w_inherite_popup`cb_1 within w_ewol
end type

type cb_return from w_inherite_popup`cb_return within w_ewol
end type

type cb_inq from w_inherite_popup`cb_inq within w_ewol
end type

type sle_1 from w_inherite_popup`sle_1 within w_ewol
end type

type st_1 from w_inherite_popup`st_1 within w_ewol
end type

type rr_1 from roundrectangle within w_ewol
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 192
integer width = 951
integer height = 420
integer cornerheight = 40
integer cornerwidth = 55
end type

