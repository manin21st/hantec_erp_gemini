$PBExportHeader$w_pdt_06044_popup_001.srw
$PBExportComments$수리결과 추가 인원 등록
forward
global type w_pdt_06044_popup_001 from w_inherite_popup
end type
type p_1 from picture within w_pdt_06044_popup_001
end type
type p_2 from picture within w_pdt_06044_popup_001
end type
type p_3 from picture within w_pdt_06044_popup_001
end type
type p_4 from picture within w_pdt_06044_popup_001
end type
type rr_1 from roundrectangle within w_pdt_06044_popup_001
end type
end forward

global type w_pdt_06044_popup_001 from w_inherite_popup
integer width = 2578
integer height = 1492
string title = "추가 작업자 선택"
event ue_open ( )
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
rr_1 rr_1
end type
global w_pdt_06044_popup_001 w_pdt_06044_popup_001

type variables
gstr_array istr_str
end variables

event ue_open();dw_1.SetRedraw(False)
dw_1.Retrieve(istr_str.as_str[1], istr_str.as_str[2], istr_str.as_str[3], istr_str.as_str[4], istr_str.as_str[5])
dw_1.SetRedraw(True)
end event

event open;call super::open;istr_str = Message.PowerObjectParm

If IsValid(istr_str) = False Then Return

This.PostEvent('ue_open')

end event

on w_pdt_06044_popup_001.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.p_3
this.Control[iCurrent+4]=this.p_4
this.Control[iCurrent+5]=this.rr_1
end on

on w_pdt_06044_popup_001.destroy
call super::destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_06044_popup_001
boolean visible = false
integer y = 16
integer width = 91
integer height = 88
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_06044_popup_001
boolean visible = false
integer x = 841
boolean enabled = false
end type

event p_exit::clicked;call super::clicked;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//
//gs_code = String(dw_1.RowCount())
//Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_06044_popup_001
boolean visible = false
integer x = 494
boolean enabled = false
boolean originalsize = false
end type

type p_choose from w_inherite_popup`p_choose within w_pdt_06044_popup_001
boolean visible = false
integer x = 667
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_pdt_06044_popup_001
integer x = 41
integer y = 200
integer width = 2469
integer height = 1096
string dataobject = "d_pdt_06044_popup_001_01"
end type

event dw_1::rbuttondown;call super::rbuttondown;If row < 1 Then Return

Choose Case dwo.name
	Case 'empno'
		Open(w_sawon_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'empno'             , gs_code    )
		This.SetItem(row, 'empname'           , gs_codename)
		This.SetItem(row, 'p1_master_deptcode', gs_gubun   )
		This.SetItem(row, 'deptcode'          , f_get_name5('01', gs_gubun, ''))
			
End Choose
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_06044_popup_001
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_06044_popup_001
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_06044_popup_001
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_06044_popup_001
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_06044_popup_001
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_06044_popup_001
end type

type p_1 from picture within w_pdt_06044_popup_001
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 1806
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\추가_up.gif'
end event

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\추가_dn.gif'
end event

event clicked;Long   ll_in

ll_in = dw_1.InsertRow(0)

dw_1.SetItem(ll_in, 'mchrsl_wrkkum_sabu' , istr_str.as_str[1])
dw_1.SetItem(ll_in, 'mchrsl_wrkkum_sidat', istr_str.as_str[2])
dw_1.SetItem(ll_in, 'mchrsl_wrkkum_gubun', istr_str.as_str[3])
dw_1.SetItem(ll_in, 'mchrsl_wrkkum_mchno', istr_str.as_str[4])
dw_1.SetItem(ll_in, 'mchrsl_wrkkum_seq'  , istr_str.as_str[5])

dw_1.ScrollToRow(ll_in)
dw_1.SetColumn('empno')
dw_1.SetFocus()



end event

type p_2 from picture within w_pdt_06044_popup_001
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1979
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\삭제_up.gif'
end event

event clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

If MessageBox('삭제여부', '선택한 자료를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

String ls_sabu
String ls_sidat
String ls_gubun
String ls_mchno
String ls_seq
String ls_emp

ls_emp  = dw_1.GetItemString(row, 'empno' )
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	dw_1.DeleteRow(row)
Else
	ls_sabu  = dw_1.GetItemString(row, 'mchrsl_wrkkum_sabu' )
	ls_sidat = dw_1.GetItemString(row, 'mchrsl_wrkkum_sidat')
	ls_gubun = dw_1.GetItemString(row, 'mchrsl_wrkkum_gubun')
	ls_mchno = dw_1.GetItemString(row, 'mchrsl_wrkkum_mchno')
	ls_seq   = dw_1.GetItemString(row, 'mchrsl_wrkkum_seq'  )
	
	DELETE MCHRSL_WRKKUM
	 WHERE SABU  = :ls_sabu
	   AND SIDAT = :ls_sidat
		AND GUBUN = :ls_gubun
		AND MCHNO = :ls_mchno
		AND SEQ   = :ls_seq
		AND EMPNO = :ls_emp  ;
	If SQLCA.SQLCODE = 0 Then
		COMMIT USING SQLCA;
	Else
		ROLLBACK USING SQLCA;
		MessageBox('삭제실패', '자료 삭제 중 오류가 발생했습니다.')
	End If
End If

Parent.TriggerEvent('ue_open')
end event

type p_3 from picture within w_pdt_06044_popup_001
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2153
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\저장_up.gif'
end event

event clicked;dw_1.AcceptText()

Long   ll_cnt

ll_cnt = dw_1.RowCount()
If ll_cnt < 1 Then Return

If MessageBox('저작여부', '저장 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

Long   i

String ls_sabu
String ls_dat
String ls_gbn
String ls_mch
String ls_seq
String ls_emp

For i = 1 To ll_cnt
	ls_emp = dw_1.GetItemString(i, 'empno')
	If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
		MessageBox('사원확인', '사원을 선택하십시오.')
		dw_1.ScrollToRow(i)
		dw_1.SetColumn('empno')
		dw_1.SetFocus()
		Return
	End If
	
	ls_sabu = dw_1.GetItemString(i, 'mchrsl_wrkkum_sabu')
	If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then dw_1.SetItem(i, 'mchrsl_wrkkum_sabu', '1')
	
	ls_dat = dw_1.GetItemString(i, 'mchrsl_wrkkum_sidat')
	If Trim(ls_dat) = '' OR IsNull(ls_dat) Then
		MessageBox('등록자료 오류 - dat001', '자료 저장 중 오류가 발생했습니다.')
		Return
	End If
	
	ls_gbn = dw_1.GetItemString(i, 'mchrsl_wrkkum_gubun')
	If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then
		MessageBox('등록자료 오류 - gbn001', '자료 저장 중 오류가 발생했습니다.')
		Return
	End If
	
	ls_mch = dw_1.GetItemString(i, 'mchrsl_wrkkum_mchno')
	If Trim(ls_mch) = '' OR IsNull(ls_mch) Then
		MessageBox('등록자료 오류 - mch001', '자료 저장 중 오류가 발생했습니다.')
		Return
	End If
	
	ls_seq = dw_1.GetItemString(i, 'mchrsl_wrkkum_seq')
	If Trim(ls_seq) = '' OR IsNull(ls_seq) Then
		MessageBox('등록자료 오류 - seq001', '자료 저장 중 오류가 발생했습니다.')
		Return
	End If
	
Next

If dw_1.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	Messagebox('저장실패', '자료 저장 중 실패 했습니다.')
End If

		
		
end event

type p_4 from picture within w_pdt_06044_popup_001
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2327
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

gs_code = String(dw_1.RowCount())
Close(Parent)
end event

type rr_1 from roundrectangle within w_pdt_06044_popup_001
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 188
integer width = 2496
integer height = 1116
integer cornerheight = 40
integer cornerwidth = 55
end type

