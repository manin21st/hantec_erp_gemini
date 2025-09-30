$PBExportHeader$w_stock_napum_ewol.srw
$PBExportComments$재고수정(월 수불내역 현황 재고표시 용)
forward
global type w_stock_napum_ewol from w_inherite_popup
end type
end forward

global type w_stock_napum_ewol from w_inherite_popup
integer width = 1230
integer height = 840
string title = "재고조정"
event ue_open ( )
end type
global w_stock_napum_ewol w_stock_napum_ewol

event ue_open();dw_jogun.InsertRow(0)

dw_jogun.SetItem(1, 'nowj'   , Double(gs_code))
dw_jogun.SetItem(1, 'ym'     , gs_gubun       )
dw_jogun.SetItem(1, 'factory', gs_codename    )
dw_jogun.SetItem(1, 'itnbr'  , gs_codename2   )
end event

on w_stock_napum_ewol.create
call super::create
end on

on w_stock_napum_ewol.destroy
call super::destroy
end on

event open;call super::open;This.TriggerEvent('ue_open')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_stock_napum_ewol
integer x = 46
integer y = 24
integer width = 933
integer height = 708
string dataobject = "d_stock_napum_ewol"
end type

event dw_jogun::itemchanged;call super::itemchanged;If row < 1 Then Return

Double ldb_now
Double ldb_fix
Double ldb_cal

This.AcceptText()

Choose Case dwo.name
	Case 'fixj'
		ldb_now = This.GetItemNumber(row, 'nowj')
		ldb_fix = This.GetItemNumber(row, 'fixj')
		
		ldb_cal = ldb_fix - ldb_now
		
		This.SetItem(row, 'calcj', ldb_cal)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_stock_napum_ewol
integer x = 1001
integer y = 184
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

type p_inq from w_inherite_popup`p_inq within w_stock_napum_ewol
boolean visible = false
integer x = 1531
integer y = 108
end type

type p_choose from w_inherite_popup`p_choose within w_stock_napum_ewol
integer x = 1001
integer y = 24
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::ue_lbuttondown;//
PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event p_choose::ue_lbuttonup;//
PictureName = 'C:\erpman\image\저장_up.gif'
end event

event p_choose::clicked;call super::clicked;If MessageBox('진행 여부', '재고 조정을 진행 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

dw_jogun.AcceptText()

Long   ll_jqty
String ls_saupj
String ls_yymm
String ls_fac
String ls_itn

ls_saupj = gs_saupj
ls_yymm  = gs_gubun
ls_fac   = gs_codename
ls_itn   = gs_codename2

  SELECT SUM(JQTY)
    INTO :ll_jqty
	 FROM STOCK_NAPUM_EWOL
	WHERE SAUPJ   = :ls_saupj
	  AND YYMM    = :ls_yymm
	  AND EWOL    = 'A00'
	  AND FACTORY = :ls_fac
	  AND ITNBR   = :ls_itn ;
	  
If SQLCA.SQLCODE <> 0 Then
	MessageBox('재고 생성여부 확인', '해당 월에 생성된 자료가 없습니다.')
	Return
End If

Long   ll_calj

ll_calj = dw_jogun.GetItemNumber(1, 'calcj')

Double ll_newj

If ll_calj > 0 Then
	ll_newj = ll_jqty + ll_calj
Else
	ll_newj = ll_jqty - (ll_calj * -1)
End If

UPDATE STOCK_NAPUM_EWOL
   SET JQTY = :ll_newj
 WHERE SAUPJ   = :ls_saupj
   AND YYMM    = :ls_yymm
	AND EWOL    = 'A00'
	AND FACTORY = :ls_fac
	AND ITNBR   = :ls_itn ;

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('자료 수정', '재고 조정이 완료 되었습니다.')
Else
	MessageBox('자료 수정 오류', '재고 조정 실패!')
	ROLLBACK USING SQLCA;
	Return
End If
end event

type dw_1 from w_inherite_popup`dw_1 within w_stock_napum_ewol
boolean visible = false
integer x = 1550
integer y = 276
integer width = 206
integer height = 144
end type

type sle_2 from w_inherite_popup`sle_2 within w_stock_napum_ewol
end type

type cb_1 from w_inherite_popup`cb_1 within w_stock_napum_ewol
end type

type cb_return from w_inherite_popup`cb_return within w_stock_napum_ewol
end type

type cb_inq from w_inherite_popup`cb_inq within w_stock_napum_ewol
end type

type sle_1 from w_inherite_popup`sle_1 within w_stock_napum_ewol
end type

type st_1 from w_inherite_popup`st_1 within w_stock_napum_ewol
end type

