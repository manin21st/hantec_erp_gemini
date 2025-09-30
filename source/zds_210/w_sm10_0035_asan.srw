$PBExportHeader$w_sm10_0035_asan.srw
$PBExportComments$VAN 접수(CKD미납 납기일 수정) - 아산
forward
global type w_sm10_0035_asan from w_inherite
end type
type dw_1 from datawindow within w_sm10_0035_asan
end type
type pb_1 from u_pb_cal within w_sm10_0035_asan
end type
type pb_2 from u_pb_cal within w_sm10_0035_asan
end type
type dw_2 from datawindow within w_sm10_0035_asan
end type
type pb_3 from u_pb_cal within w_sm10_0035_asan
end type
type cb_1 from commandbutton within w_sm10_0035_asan
end type
type cb_2 from commandbutton within w_sm10_0035_asan
end type
type st_2 from statictext within w_sm10_0035_asan
end type
type st_3 from statictext within w_sm10_0035_asan
end type
type p_xls from picture within w_sm10_0035_asan
end type
type p_sort from picture within w_sm10_0035_asan
end type
type rr_1 from roundrectangle within w_sm10_0035_asan
end type
end forward

global type w_sm10_0035_asan from w_inherite
integer width = 4663
integer height = 2596
string title = "아산CKD VAN 납품일 수정"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
pb_3 pb_3
cb_1 cb_1
cb_2 cb_2
st_2 st_2
st_3 st_3
p_xls p_xls
p_sort p_sort
rr_1 rr_1
end type
global w_sm10_0035_asan w_sm10_0035_asan

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

on w_sm10_0035_asan.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.pb_3=create pb_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_2=create st_2
this.st_3=create st_3
this.p_xls=create p_xls
this.p_sort=create p_sort
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.p_xls
this.Control[iCurrent+11]=this.p_sort
this.Control[iCurrent+12]=this.rr_1
end on

on w_sm10_0035_asan.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.pb_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.p_xls)
destroy(this.p_sort)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))



end event

type dw_insert from w_inherite`dw_insert within w_sm10_0035_asan
integer x = 50
integer y = 300
integer width = 4512
integer height = 1948
string dataobject = "d_sm10_0030_asan_002"
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

event dw_insert::itemchanged;call super::itemchanged;This.AcceptText()

String ls_base

ls_base = dw_2.GetItemString(1, 'd_base')
If Trim(ls_base) = '' OR IsNull(ls_base) Then
	MessageBox('수정일 확인', '수정일을 입력 하십시오.')
	dw_2.SetColumn('d_base')
	dw_2.SetFocus()
	Return -1
End If

Choose Case dwo.name
	Case 'chk'
		If data = 'Y' Then
//			This.SetItem(row, 'ord_han', This.GetItemString(row, 'order_date_hantec'))
			This.SetItem(row, 'podate', ls_base)
		Else
			If Trim(This.GetItemString(row, 'podate')) = '' OR IsNull(This.GetItemString(row, 'podate')) Then
				Return
			Else
//				This.SetItem(row, 'order_date_hantec', This.GetItemString(row, 'ord_han'))
				This.SetItem(row, 'podate', '')
			End If
		End If
		
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0035_asan
boolean visible = false
integer x = 3858
integer y = 344
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0035_asan
boolean visible = false
integer x = 3685
integer y = 344
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm10_0035_asan
boolean visible = false
integer x = 3163
integer y = 344
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0035_asan
boolean visible = false
integer x = 3511
integer y = 344
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm10_0035_asan
integer x = 4366
integer y = 44
end type

type p_can from w_inherite`p_can within w_sm10_0035_asan
integer x = 4192
integer y = 44
end type

event p_can::clicked;call super::clicked;p_xls.Enabled = False
p_sort.Enabled = False
p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
p_sort.PictureName = 'C:\erpman\image\정렬_d.gif'

dw_insert.ReSet()
dw_insert.SetTransObject(SQLCA)
end event

type p_print from w_inherite`p_print within w_sm10_0035_asan
boolean visible = false
integer x = 3337
integer y = 344
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0035_asan
integer x = 3671
integer y = 44
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_st

ls_st = dw_1.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		Messagebox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_1.SetColumn('d_st')
		dw_1.SetFocus()
		Return
	End If
End If

String ls_ed

ls_ed = dw_1.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		Messagebox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_1.SetColumn('d_ed')
		dw_1.SetFocus()
		Return
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '시작일 보다 종료일이 빠릅니다.')
	dw_1.SetColumn('d_st')
	dw_1.SetFocus()
	Return
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_st, ls_ed)
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

type p_del from w_inherite`p_del within w_sm10_0035_asan
integer x = 3845
integer y = 44
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

type p_mod from w_inherite`p_mod within w_sm10_0035_asan
integer x = 4018
integer y = 44
end type

event p_mod::clicked;call super::clicked;Long   ll_cnt 

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() <> 1 Then Return

Long   i
String ls_ord_h

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

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장 실패', '자료 저장 중 오류가 발생했습니다.')
	Return
End If

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0035_asan
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0035_asan
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0035_asan
end type

type cb_del from w_inherite`cb_del within w_sm10_0035_asan
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0035_asan
end type

type cb_print from w_inherite`cb_print within w_sm10_0035_asan
end type

type st_1 from w_inherite`st_1 within w_sm10_0035_asan
end type

type cb_can from w_inherite`cb_can within w_sm10_0035_asan
end type

type cb_search from w_inherite`cb_search within w_sm10_0035_asan
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0035_asan
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0035_asan
end type

type dw_1 from datawindow within w_sm10_0035_asan
integer x = 37
integer y = 32
integer width = 1280
integer height = 180
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0030_asan_001"
boolean border = false
boolean livescroll = true
end type

event constructor;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
end event

type pb_1 from u_pb_cal within w_sm10_0035_asan
integer x = 690
integer y = 76
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'd_st', gs_code)

end event

type pb_2 from u_pb_cal within w_sm10_0035_asan
integer x = 1134
integer y = 76
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'd_ed', gs_code)

end event

type dw_2 from datawindow within w_sm10_0035_asan
integer x = 1998
integer y = 32
integer width = 672
integer height = 180
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0030_asan_003"
boolean border = false
boolean livescroll = true
end type

event constructor;This.InsertRow(0)

This.SetItem(1, 'd_base', String(RelativeDate(TODAY(), 1), 'yyyymmdd'))
end event

type pb_3 from u_pb_cal within w_sm10_0035_asan
integer x = 2533
integer y = 76
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('d_base')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'd_base', gs_code)

end event

type cb_1 from commandbutton within w_sm10_0035_asan
integer x = 1312
integer y = 44
integer width = 114
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "▼"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   i
	
dw_2.AcceptText()

String ls_base

ls_base = dw_2.GetItemString(1, 'd_base')
If Trim(ls_base) = '' OR IsNull(ls_base) Then
	MessageBox('수정일 확인', '수정일을 입력 하십시오.')
	dw_2.SetColumn('d_base')
	dw_2.SetFocus()
	Return -1
End If
	
For i = 0 To ll_cnt
	i = dw_insert.GetSelectedRow(i - 1)
	If i < 1 Then Return
	
	dw_insert.SetItem(i, 'chk', 'Y')

	//dw_insert.SetItem(i, 'ord_han', dw_insert.GetItemString(i, 'order_date_hantec'))
	//dw_insert.SetItem(i, 'order_date_hantec', ls_base)
	
	dw_insert.SetItem(i, 'gujb_date', dw_insert.GetItemString(i, 'podate'))
	dw_insert.SetItem(i, 'podate', ls_base)
Next
end event

type cb_2 from commandbutton within w_sm10_0035_asan
integer x = 1312
integer y = 132
integer width = 114
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "▽"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   i

For i = 1 To ll_cnt	
	dw_insert.SetItem(i, 'chk', 'N')	
	
	
	//If Trim(dw_insert.GetItemString(i, 'ord_han')) = '' OR IsNull(dw_insert.GetItemString(i, 'ord_han')) Then
	//	Continue ;
	//Else
	//	dw_insert.SetItem(i, 'order_date_hantec', dw_insert.GetItemString(i, 'ord_han'))
	//	dw_insert.SetItem(i, 'ord_han', '')
	//End If
	
	If Trim(dw_insert.GetItemString(i, 'gujb_date')) = '00000000' OR IsNull(dw_insert.GetItemString(i, 'gujb_date')) Then
		Continue ;
	Else
		dw_insert.SetItem(i, 'podate', dw_insert.GetItemString(i, 'gujb_date'))
		dw_insert.SetItem(i, 'gujb_date', '')
	End If
	
Next
end event

type st_2 from statictext within w_sm10_0035_asan
integer x = 1435
integer y = 56
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "일괄선택"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm10_0035_asan
integer x = 1435
integer y = 148
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "일괄해제"
boolean focusrectangle = false
end type

type p_xls from picture within w_sm10_0035_asan
integer x = 3415
integer y = 40
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

type p_sort from picture within w_sm10_0035_asan
integer x = 3237
integer y = 40
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

type rr_1 from roundrectangle within w_sm10_0035_asan
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 288
integer width = 4539
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

