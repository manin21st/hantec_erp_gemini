$PBExportHeader$w_sm10_0035_ckd.srw
$PBExportComments$CKD 일일발주 현황
forward
global type w_sm10_0035_ckd from w_inherite
end type
type dw_1 from datawindow within w_sm10_0035_ckd
end type
type p_xls from picture within w_sm10_0035_ckd
end type
type p_sort from picture within w_sm10_0035_ckd
end type
type rr_1 from roundrectangle within w_sm10_0035_ckd
end type
end forward

global type w_sm10_0035_ckd from w_inherite
integer width = 4672
integer height = 2752
string title = "CKD 일 발주 현황"
dw_1 dw_1
p_xls p_xls
p_sort p_sort
rr_1 rr_1
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
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_xls=create p_xls
this.p_sort=create p_sort
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_xls
this.Control[iCurrent+3]=this.p_sort
this.Control[iCurrent+4]=this.rr_1
end on

on w_sm10_0035_ckd.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_xls)
destroy(this.p_sort)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0035_ckd
integer x = 50
integer y = 316
integer width = 4512
integer height = 1932
string dataobject = "d_sm10_0035_ckd_hkmc"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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

type p_delrow from w_inherite`p_delrow within w_sm10_0035_ckd
boolean visible = false
integer x = 3858
integer y = 344
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0035_ckd
boolean visible = false
integer x = 3685
integer y = 344
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm10_0035_ckd
boolean visible = false
integer x = 3163
integer y = 344
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0035_ckd
boolean visible = false
integer x = 3511
integer y = 344
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm10_0035_ckd
integer x = 4366
integer y = 8
end type

type p_can from w_inherite`p_can within w_sm10_0035_ckd
integer x = 4192
integer y = 8
end type

event p_can::clicked;call super::clicked;p_xls.Enabled = False
p_sort.Enabled = False
p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
p_sort.PictureName = 'C:\erpman\image\정렬_d.gif'

dw_insert.ReSet()
dw_insert.SetTransObject(SQLCA)
end event

type p_print from w_inherite`p_print within w_sm10_0035_ckd
boolean visible = false
integer x = 3337
integer y = 344
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0035_ckd
integer x = 3671
integer y = 8
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_1.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_1.SetColumn('d_st')
		dw_1.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_1.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_1.SetColumn('d_ed')
		dw_1.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '시작일 보다 종료일이 빠릅니다.')
	dw_1.setColumn('d_st')
	dw_1.SetFocus()
	Return -1
End If

String ls_fac

ls_fac = dw_1.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) OR Trim(ls_fac) = '.' Then ls_fac = '%'

String ls_stit

ls_stit = dw_1.GetItemString(row, 'stit')
If Trim(ls_stit) = '' OR IsNull(ls_stit) Then ls_stit = '.'

String ls_edit

ls_edit = dw_1.GetItemString(row, 'edit')
If Trim(ls_edit) = '' OR IsNull(ls_edit) Then ls_edit = 'ZZZZZZZZZZZZZZZZZZZZ'

String ls_ckdgbn
ls_ckdgbn = dw_1.GetItemString(row, 'ckdgbn')

dw_insert.SetRedraw(False)

If ls_ckdgbn = 'H' OR ls_ckdgbn = 'G' Then
	dw_insert.Retrieve(ls_st, ls_ed, ls_fac, ls_stit, ls_edit)
Else
	dw_insert.Retrieve(ls_st, ls_ed, ls_stit, ls_edit)
End If

dw_insert.SetRedraw(True)

If dw_insert.RowCount() < 1 Then
	p_xls.Enabled = False
	p_sort.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
	p_sort.PictureName = 'C:\erpman\image\정렬_d.gif'
Else
	p_xls.Enabled = True
	p_sort.Enabled = True
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
	p_sort.PictureName = 'C:\erpman\image\정렬_up.gif'
End If
end event

type p_del from w_inherite`p_del within w_sm10_0035_ckd
boolean visible = false
integer x = 3845
integer y = 8
boolean enabled = false
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

type p_mod from w_inherite`p_mod within w_sm10_0035_ckd
integer x = 4018
integer y = 8
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
ls_gbn = dw_1.GetItemString(1, 'ckdgbn')
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

type cb_exit from w_inherite`cb_exit within w_sm10_0035_ckd
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0035_ckd
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0035_ckd
end type

type cb_del from w_inherite`cb_del within w_sm10_0035_ckd
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0035_ckd
end type

type cb_print from w_inherite`cb_print within w_sm10_0035_ckd
end type

type st_1 from w_inherite`st_1 within w_sm10_0035_ckd
end type

type cb_can from w_inherite`cb_can within w_sm10_0035_ckd
end type

type cb_search from w_inherite`cb_search within w_sm10_0035_ckd
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0035_ckd
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0035_ckd
end type

type dw_1 from datawindow within w_sm10_0035_ckd
integer x = 37
integer y = 40
integer width = 3397
integer height = 232
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0035_ckd_ret"
boolean border = false
boolean livescroll = true
end type

event constructor;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
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

type p_xls from picture within w_sm10_0035_ckd
integer x = 3845
integer y = 148
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
boolean focusrectangle = false
end type

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type p_sort from picture within w_sm10_0035_ckd
integer x = 3666
integer y = 148
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\정렬_d.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

type rr_1 from roundrectangle within w_sm10_0035_ckd
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 304
integer width = 4539
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

