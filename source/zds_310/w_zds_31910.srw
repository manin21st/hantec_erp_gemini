$PBExportHeader$w_zds_31910.srw
$PBExportComments$용기 MASTER
forward
global type w_zds_31910 from w_inherite
end type
type dw_1 from datawindow within w_zds_31910
end type
type cb_1 from commandbutton within w_zds_31910
end type
type cb_2 from commandbutton within w_zds_31910
end type
type cb_3 from commandbutton within w_zds_31910
end type
type dw_img from datawindow within w_zds_31910
end type
type dw_itm from datawindow within w_zds_31910
end type
type dw_file from datawindow within w_zds_31910
end type
type rr_1 from roundrectangle within w_zds_31910
end type
end forward

global type w_zds_31910 from w_inherite
string title = "용기 마스터 등록"
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
dw_img dw_img
dw_itm dw_itm
dw_file dw_file
rr_1 rr_1
end type
global w_zds_31910 w_zds_31910

on w_zds_31910.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.dw_img=create dw_img
this.dw_itm=create dw_itm
this.dw_file=create dw_file
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.dw_img
this.Control[iCurrent+6]=this.dw_itm
this.Control[iCurrent+7]=this.dw_file
this.Control[iCurrent+8]=this.rr_1
end on

on w_zds_31910.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.dw_img)
destroy(this.dw_itm)
destroy(this.dw_file)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.InsertRow(0)

dw_insert.SetTransObject(SQLCA)
dw_img.SeTtransObject(SQLCA)
dw_itm.SeTtransObject(SQLCA)
dw_file.SeTtransObject(SQLCA)
end event

type dw_insert from w_inherite`dw_insert within w_zds_31910
integer x = 46
integer y = 232
integer width = 4558
integer height = 2012
string dataobject = "d_zds_31910_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'f_chk'
		Integer i
		For i = 1 To This.RowCount()
			This.SetItem(i, 'f_chk', 'N')
		Next
	Case 'bpcode'
		Integer li_find
		li_find = This.Find("bpcode = '" + data + "'", 1, This.RowCount() - 1)
		If li_find < 1 Then Return
		
		MessageBox('중복 확인', '[' + data + '] 관리번호는 이미 등록 된 번호 입니다.')
		Return 2
End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type p_delrow from w_inherite`p_delrow within w_zds_31910
boolean visible = false
integer x = 3922
integer y = 168
end type

type p_addrow from w_inherite`p_addrow within w_zds_31910
boolean visible = false
integer y = 168
end type

type p_search from w_inherite`p_search within w_zds_31910
boolean visible = false
integer y = 168
end type

type p_ins from w_inherite`p_ins within w_zds_31910
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Integer li_ins
li_ins = dw_insert.InsertRow(0)

dw_insert.SetItem(li_ins, 'sabu' , gs_sabu )
dw_insert.SetItem(li_ins, 'saupj', gs_saupj)

dw_insert.SetFocus()
dw_insert.SetRow(li_ins)
dw_insert.SetColumn('bpcode')
end event

type p_exit from w_inherite`p_exit within w_zds_31910
end type

type p_can from w_inherite`p_can within w_zds_31910
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
end event

type p_print from w_inherite`p_print within w_zds_31910
boolean visible = false
integer y = 168
end type

type p_inq from w_inherite`p_inq within w_zds_31910
integer x = 3575
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

If dw_1.GetRow() < 1 Then Return

String  ls_name
ls_name = dw_1.GetItemString(1, 'bpname')
If Trim(ls_name) = '' OR IsNull(ls_name) Then
	ls_name = '%'
Else
	ls_name = '%' + ls_name + '%'
End If

String  ls_cvcod
ls_cvcod = dw_1.GetItemString(1, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then	ls_cvcod = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_cvcod, ls_name)
dw_insert.SetRedraw(True)


end event

type p_del from w_inherite`p_del within w_zds_31910
integer x = 3922
end type

event p_del::clicked;call super::clicked;Long    ll_err
Integer l
Integer li_fchk
String  ls_get[]
String  ls_err
DWItemStatus l_stts

For l = 1 To dw_insert.RowCount()
	li_fchk = dw_insert.Find("f_chk = 'Y'", l, dw_insert.RowCount())
	If li_fchk < 1 Then Exit
	
	ls_get[1] = dw_insert.GetItemString(li_fchk, 'sabu'  )
	ls_get[2] = dw_insert.GetItemString(li_fchk, 'saupj' )
	ls_get[3] = dw_insert.GetItemString(li_fchk, 'bpcode')
	
	l_stts = dw_insert.GetItemStatus(l, 0, Primary!)
	If l_stts = New! OR l_stts = NewModified! Then
		dw_insert.DeleteRow(li_fchk)
		li_fchk = li_fchk - 1
		l = li_fchk
	Else
		DELETE FROM BP_MASTER
		 WHERE SABU = :ls_get[1] AND SAUPJ = :ls_get[2] AND BPCODE = :ls_get[3] ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
			MessageBox('DB Error Code - ' + String(ll_err), ls_err + '~r~n자료 삭제 중 오류가 발생 했습니다.(' + String(l) + ')')
			Return
		End If
	End If
Next

COMMIT USING SQLCA;
dw_insert.ResetUpdate()
MessageBox('삭제 확인', '선택된 항목이 삭제 되었습니다.')
end event

type p_mod from w_inherite`p_mod within w_zds_31910
integer x = 4096
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

Integer i
String  ls_sabu
String  ls_saupj
String  ls_bpcod
String  ls_dup
DWItemStatus l_sts

For i = 1 To li_cnt
	l_sts = dw_insert.GetItemStatus(i, 0, Primary!)
	
	ls_sabu  = dw_insert.GetItemString(i, 'sabu'  )
	If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
		dw_insert.SetItem(i, 'sabu', gs_sabu)
		ls_sabu = gs_sabu
	End If
	
	ls_saupj = dw_insert.GetItemString(i, 'saupj' )
	If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
		dw_insert.SetItem(i, 'saupj', gs_saupj)
		ls_saupj = gs_saupj
	End If
	
	ls_bpcod = dw_insert.GetItemString(i, 'bpcode')
	If Trim(ls_bpcod) = '' OR IsNull(ls_bpcod) Then
		MessageBox('관리번호 확인', 'BOX/PLT 관리번호를 입력 하십시오.')
		dw_insert.SetRow(i)
		dw_insert.SetColumn('bpcode')
		Return
	End If
	
	Choose Case l_sts
		Case New!, NewModified!
			//중복확인
			SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
			  INTO :ls_dup
			  FROM BP_MASTER
			 WHERE SABU = :ls_sabu AND SAUPJ = :ls_saupj AND BPCODE = :ls_bpcod ;
			If ls_dup = 'Y' Then
				MessageBox('중복확인', '[행 : ' + String(i) + ']~r~n' + '[관리번호 : ' + ls_bpcod + ']~r~n' + '는(은) 이미 등록 된 관리번호 입니다.')
				dw_insert.SetRow(i)
				dw_insert.SetColumn('bpcode')
				Return
			End If
		Case DataModified!
	End Choose
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장 실패', '저장 중 오류가 발생했습니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_zds_31910
end type

type cb_mod from w_inherite`cb_mod within w_zds_31910
end type

type cb_ins from w_inherite`cb_ins within w_zds_31910
end type

type cb_del from w_inherite`cb_del within w_zds_31910
end type

type cb_inq from w_inherite`cb_inq within w_zds_31910
end type

type cb_print from w_inherite`cb_print within w_zds_31910
end type

type st_1 from w_inherite`st_1 within w_zds_31910
end type

type cb_can from w_inherite`cb_can within w_zds_31910
end type

type cb_search from w_inherite`cb_search within w_zds_31910
end type







type gb_button1 from w_inherite`gb_button1 within w_zds_31910
end type

type gb_button2 from w_inherite`gb_button2 within w_zds_31910
end type

type dw_1 from datawindow within w_zds_31910
integer x = 37
integer y = 12
integer width = 2208
integer height = 196
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_zds_31910_001"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	sVendor, sVendorname, sNull

SetNull(sNull)

This.AcceptText()

// 거래처
IF this.GetColumnName() = 'cvcod'		THEN

	sVendor = this.gettext()
	If Trim(sVendor) = '' OR IsNull(sVendor) Then
		this.setitem(1, 'cvnas', sNull)
		Return
	End If
	
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor 	AND
	 		 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, "cvnas", sNull)
		return 1
	end if

	this.setitem(1, "cvnas", sVendorName)
	
End If
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// 전표번호
IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "cvcod",		gs_code)
	SetItem(1, "cvnas",gs_codename)

END IF


end event

type cb_1 from commandbutton within w_zds_31910
integer x = 2450
integer y = 32
integer width = 389
integer height = 132
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사진(SKETCH)"
end type

event clicked;Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, dw_insert.RowCount())
If li_find < 1 Then
	MessageBox('선택확인', '선택 된 항목이 없습니다.')
	Return
End If

String  ls_sabu
ls_sabu = dw_insert.GetItemString(li_find, 'sabu')
If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SABU)')
	Return
End If

String  ls_saupj
ls_saupj = dw_insert.GetItemString(li_find, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SAUPJ)')
	Return
End If

String  ls_code
ls_code = dw_insert.GetItemString(li_find, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then
	MessageBox('필수 확인', '관리코드 값이 누락 되었습니다.(BPCODE)')
	Return
End If

String  ls_type
ls_type = dw_insert.GetItemString(li_find, 'filetype')
If Trim(ls_type) = '' OR IsNull(ls_type) Then ls_type = '/'

dw_insert.Enabled = False
dw_img.Visible    = True

dw_img.InsertRow(0)

//등록된 확장자가 없으면 파일을 불러오지 않음.
If ls_type = '/' Then Return

Blob lbl_img
//SQLCA.AutoCommit = True
SELECTBLOB SKETCH
      INTO :lbl_img
	   FROM BP_MASTER
	  WHERE SABU   = :ls_sabu
	    AND SAUPJ  = :ls_saupj
		 AND BPCODE = :ls_code ;
//SQLCA.AutoCommit = False

Long    ll_filelen
//파일의 크기를 구한다.
ll_filelen = Len(lbl_img)

If DirectoryExists('C:\ERPMAN\doc') = False Then
	CreateDirectory('C:\ERPMAN\doc')
End If

If DirectoryExists('C:\ERPMAN\doc\sales') = False Then
	CreateDirectory('C:\ERPMAN\doc\sales')
End If

//파일 용량이 0이면 Open하지 않음.
If ll_filelen < 1 Then Return

If FileExists('C:\ERPMAN\doc\sales\' + ls_code + '.' + ls_type) Then
	FileDelete('C:\ERPMAN\doc\sales\' + ls_code + '.' + ls_type)
End If

Integer li_filenum
//저장할 파일을 스트림모드로 먼저 연다
li_filenum = FileOpen('C:\ERPMAN\doc\sales\' + ls_code + '.' + ls_type, StreamMode!, Write!, LockWrite!, Replace!)

FileWriteEx(li_filenum, lbl_img)

FileClose(li_FileNum)

If dw_img.Retrieve(ls_sabu, ls_saupj, ls_code) < 1 Then
	dw_img.InsertRow(0)
End If
end event

type cb_2 from commandbutton within w_zds_31910
integer x = 2839
integer y = 32
integer width = 293
integer height = 132
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "첨부파일"
end type

event clicked;Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, dw_insert.RowCount())
If li_find < 1 Then
	MessageBox('선택확인', '선택 된 항목이 없습니다.')
	Return
End If

String  ls_sabu
ls_sabu = dw_insert.GetItemString(li_find, 'sabu')
If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SABU)')
	Return
End If

String  ls_saupj
ls_saupj = dw_insert.GetItemString(li_find, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SAUPJ)')
	Return
End If

String  ls_code
ls_code = dw_insert.GetItemString(li_find, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then
	MessageBox('필수 확인', '관리코드 값이 누락 되었습니다.(BPCODE)')
	Return
End If

dw_insert.Enabled = False
dw_file.Visible   = True

dw_file.SetRedraw(False)
dw_file.Retrieve(ls_sabu, ls_saupj, ls_code)
dw_file.SetRedraw(True)
end event

type cb_3 from commandbutton within w_zds_31910
integer x = 3131
integer y = 32
integer width = 293
integer height = 132
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "관련품번"
end type

event clicked;Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, dw_insert.RowCount())
If li_find < 1 Then
	MessageBox('선택확인', '선택 된 항목이 없습니다.')
	Return
End If

String  ls_sabu
ls_sabu = dw_insert.GetItemString(li_find, 'sabu')
If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SABU)')
	Return
End If

String  ls_saupj
ls_saupj = dw_insert.GetItemString(li_find, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SAUPJ)')
	Return
End If

String  ls_code
ls_code = dw_insert.GetItemString(li_find, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then
	MessageBox('필수 확인', '관리코드 값이 누락 되었습니다.(BPCODE)')
	Return
End If

dw_insert.Enabled = False
dw_itm.Visible    = True

dw_itm.SetRedraw(False)
dw_itm.Retrieve(ls_sabu, ls_saupj, ls_code)
dw_itm.SetRedraw(True)
end event

type dw_img from datawindow within w_zds_31910
boolean visible = false
integer x = 1170
integer y = 292
integer width = 1586
integer height = 1492
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "사진(SKETCH)"
string dataobject = "d_zds_31910_002_img"
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;If row < 1 Then Return

Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, dw_insert.RowCount())
If li_find < 1 Then
	MessageBox('선택확인', '선택 된 항목이 없습니다.')
	Return
End If

String  ls_sabu
ls_sabu = dw_insert.GetItemString(li_find, 'sabu')
If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SABU)')
	Return
End If

String  ls_saupj
ls_saupj = dw_insert.GetItemString(li_find, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SAUPJ)')
	Return
End If

String  ls_code
ls_code = dw_insert.GetItemString(li_find, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then
	MessageBox('필수 확인', '관리코드 값이 누락 되었습니다.(BPCODE)')
	Return
End If

Choose Case dwo.name
	Case 'b_up'
		Int    li_rtn
		String ls_path
		String ls_file
		
		li_rtn = GetFileOpenName('파일 위치', ls_path, ls_file, 'Image', ' Graphic Files (*.bmp;*.gif;*.jpg;*.jpeg),*.bmp;*.gif;*.jpg;*.jpeg')
		
		If li_rtn < 0 Then
			MessageBox('파일 확인', '파일을 다시 선택 하십시오.')
			ChangeDirectory('C:\erpman\')
			Return
		End If
		
		If li_rtn = 0 Then
			ChangeDirectory('C:\erpman\')
			Return
		End If
		
		ChangeDirectory('C:\erpman\')
		
		SetPointer(HOURGLASS!)

		Integer li_filenum, li_loops, i
		Long ll_len, ll_read, ll_new_pos
		Blob lb_tot_b, blob_temp, total_blob, blank_blob
		
		//파일의 크기를 구한다.
		ll_len = FileLength(ls_path)
		
		//저장할 파일을 스트림모드로 먼저 연다
		li_filenum = FileOpen(ls_path, STREAMMODE!, READ!, LOCKREAD!)
		
		FileReadEx(li_filenum, blob_temp)
		total_blob = blob_temp
		
		FileClose(li_filenum)
		
		SQLCA.AutoCommit = True
		
		//업데이트
		UPDATEBLOB BP_MASTER
				 SET SKETCH = :total_blob
		     WHERE SABU   = :ls_sabu
			    AND SAUPJ  = :ls_saupj
				 AND BPCODE = :ls_code
		USING SQLCA;
		
		SQLCA.AutoCommit = False
		
		SetPointer(Arrow!)
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('파일저장 실패', '이미지 저장 중 오류가 발생 했습니다.')
			Return
		End If
		
		//파일확장자 저장
		UPDATE BP_MASTER
		   SET FILETYPE = REVERSE(SUBSTR(REVERSE(:ls_file), 1, INSTR(REVERSE(:ls_file), '.') - 1))
		 WHERE SABU   = :ls_sabu
		   AND SAUPJ  = :ls_saupj
			AND BPCODE = :ls_code ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('파일확장자 저장 실패', '파일정보 저장 중 오류가 발생 했습니다.')
			Return
		End If
		
		COMMIT USING SQLCA;
		
		Blob lbl_sel
		SELECTBLOB SKETCH
		      INTO :lbl_sel
			   FROM BP_MASTER
 			  WHERE SABU   = :ls_sabu
				 AND SAUPJ  = :ls_saupj
				 AND BPCODE = :ls_code ;
		Long    ll_filelen
		//파일의 크기를 구한다.
		ll_filelen = Len(lbl_sel)
		
		If DirectoryExists('C:\ERPMAN\doc') = False Then
			CreateDirectory('C:\ERPMAN\doc')
		End If
		
		If DirectoryExists('C:\ERPMAN\doc\sales') = False Then
			CreateDirectory('C:\ERPMAN\doc\sales')
		End If
		
		//파일 용량이 0이면 Open하지 않음.
		If ll_filelen < 1 Then Return
		
		String ls_ftype
		SELECT REVERSE(SUBSTR(REVERSE(:ls_file), 1, INSTR(REVERSE(:ls_file), '.') - 1))
		  INTO :ls_ftype
		  FROM DUAL;
		
		If FileExists('C:\ERPMAN\doc\sales\' + ls_code + '.' + ls_ftype) Then
			FileDelete('C:\ERPMAN\doc\sales\' + ls_code + '.' + ls_ftype)
		End If
		
		SetNull(li_filenum)
		//저장할 파일을 스트림모드로 먼저 연다
		li_filenum = FileOpen('C:\ERPMAN\doc\sales\' + ls_code + '.' + ls_ftype, StreamMode!, Write!, LockWrite!, Replace!)
		
		FileWriteEx(li_filenum, lbl_sel)
		
		FileClose(li_FileNum)
		
		dw_img.Retrieve(ls_sabu, ls_saupj, ls_code)
		
		MessageBox('파일등록', '이미지가 등록 되었습니다.')
		
//	Case 'b_del'
//		Blob imagedata
//		imagedata = Blob(Space(0))
//		
//		SQLCA.AutoCommit = True
//		
//		//업데이트
//		UPDATEBLOB BP_MASTER
//				 SET SKETCH = NULL
//		     WHERE SABU   = :ls_sabu
//			    AND SAUPJ  = :ls_saupj
//				 AND BPCODE = :ls_code
//		USING SQLCA;
//		
//		SQLCA.AutoCommit = False
//		
//		SetPointer(Arrow!)
//		If SQLCA.SQLCODE <> 0 Then
//			String ls_err ; Long ll_err
//			ls_err = SQLCA.SQLERRTEXT ; ll_err = SQLCA.SQLDBCODE
//			ROLLBACK USING SQLCA;
//			MessageBox('파일삭제 실패 [' + String(ll_err) + ']', '이미지 삭제 중 오류가 발생 했습니다.~r~n' + ls_err)
//			Return
//		End If
//		
//		//파일확장자 저장
//		UPDATE BP_MASTER
//		   SET FILETYPE = NULL
//		 WHERE SABU   = :ls_sabu
//		   AND SAUPJ  = :ls_saupj
//			AND BPCODE = :ls_code ;
//		If SQLCA.SQLCODE <> 0 Then
//			ROLLBACK USING SQLCA;
//			MessageBox('파일확장자 삭제 실패', '파일정보 삭제 중 오류가 발생 했습니다.')
//			Return
//		End If
//		
//		COMMIT USING SQLCA;
//		MessageBox('파일등록', '이미지가 등록 되었습니다.')
	Case 'b_cls'
		This.Visible = False
		dw_insert.Enabled = True
		This.ReSet()
End Choose

end event

type dw_itm from datawindow within w_zds_31910
boolean visible = false
integer x = 1170
integer y = 396
integer width = 1806
integer height = 1492
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "관련품번"
string dataobject = "d_zds_31910_002_itm"
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, dw_insert.RowCount())
If li_find < 1 Then
	MessageBox('선택확인', '선택 된 항목이 없습니다.')
	Return
End If

String  ls_sabu
ls_sabu = dw_insert.GetItemString(li_find, 'sabu')
If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SABU)')
	Return
End If

String  ls_saupj
ls_saupj = dw_insert.GetItemString(li_find, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SAUPJ)')
	Return
End If

String  ls_code
ls_code = dw_insert.GetItemString(li_find, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then
	MessageBox('필수 확인', '관리코드 값이 누락 되었습니다.(BPCODE)')
	Return
End If

Choose Case dwo.name
	Case 'b_ins'
		Integer li_ins
		li_ins = This.InsertRow(0)
		
		This.SetItem(li_ins, 'sabu'  , ls_sabu )
		This.SetItem(li_ins, 'saupj' , ls_saupj)
		This.SetItem(li_ins, 'bpcode', ls_code )
	Case 'b_up'
		Integer i
		String  ls_key[]
		String  ls_chk
		DWItemStatus l_sts
		For i = 1 To This.RowCount()
			l_sts = This.GetItemStatus(i, 0, Primary!)
			If l_sts = New! OR l_sts = NewModified! Then
				ls_key[1] = This.GetItemString(i, 'sabu'  )
				ls_key[2] = This.GetItemString(i, 'saupj' )
				ls_key[3] = This.GetItemString(i, 'bpcode')
				ls_key[4] = This.GetItemString(i, 'itnbr' )
				
				/* DB중복 확인 */
				SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
				  INTO :ls_chk
				  FROM BP_MASTER_ITEM
				 WHERE SABU = :ls_key[1] AND SAUPJ = :ls_key[2] AND BPCODE = :ls_key[3] AND ITNBR = :ls_key[4] ;
				If ls_chk = 'Y' Then
					MessageBox('중복 확인', '이미 등록 된 자료 입니다.')
					This.SetRow(i)
					This.SetColumn('itnbr')
					Return
				End If
			End If
		Next
		
		If This.UPDATE() = 1 Then
			COMMIT USING SQLCA;
			MessageBox('저장확인', '관련품번이 등록 되었습니다.')
		Else
			ROLLBACK USING SQLCA;
			MessageBox('저장실패', '관련품번 등록 중 오류가 발생했습니다.')
			Return
		End If
	Case 'b_del'
		Long    ll_err
		Integer l
		Integer li_fchk
		String  ls_get[]
		String  ls_err
		DWItemStatus l_stts
		For l = 1 To This.RowCount()
			li_fchk = This.Find("f_chk = 'Y'", l, This.RowCount())
			If li_fchk < 1 Then Exit
			
			ls_get[1] = This.GetItemString(l, 'sabu'  )
			ls_get[2] = This.GetItemString(l, 'saupj' )
			ls_get[3] = This.GetItemString(l, 'bpcode')
			ls_get[4] = This.GetItemString(l, 'itnbr' )
			
			l_stts = This.GetItemStatus(l, 0, Primary!)
			If l_stts = New! OR l_stts = NewModified! Then
				This.DeleteRow(l)
				l = l - 1
			Else
				DELETE FROM BP_MASTER_ITEM
				 WHERE SABU = :ls_get[1] AND SAUPJ = :ls_get[2] AND BPCODE = :ls_get[3] AND ITNBR = :ls_get[4] ;
				If SQLCA.SQLCODE <> 0 Then
					ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
					ROLLBACK USING SQLCA;
					MessageBox('DB Error Code - ' + String(ll_err), ls_err + '~r~n자료 삭제 중 오류가 발생 했습니다.(' + String(l) + ')')
					Return
				End If
			End If
		Next
		
		COMMIT USING SQLCA;
		MessageBox('삭제 확인', '선택된 항목이 삭제 되었습니다.')
		
		dw_insert.SetRedraw(False)
		dw_insert.Retrieve(ls_get[1], ls_get[2], ls_get[3])
		dw_insert.SetRedraw(True)
	Case 'b_cls'
		This.Visible      = False
		dw_insert.Enabled = True
End Choose

end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'itnbr'
		If Trim(data) = '' Or IsNulL(data) Then
			This.SetItem(row, 'itdsc', '')
			Return
		End If
		
		String  ls_name
		SELECT ITDSC
		  INTO :ls_name
		  FROM ITEMAS
		 WHERE ITNBR = :data ;
		If Trim(ls_name) = '' OR IsNull(ls_name) OR SQLCA.SQLCODE <> 0 Then
			MessageBox('품번확인', '등록 된 품번이 아닙니다.')
			Return
		End If
		
		This.SetItem(row, 'itdsc', ls_name)
End Choose
end event

type dw_file from datawindow within w_zds_31910
boolean visible = false
integer x = 1170
integer y = 500
integer width = 1518
integer height = 864
integer taborder = 140
boolean bringtotop = true
boolean titlebar = true
string title = "첨부파일"
string dataobject = "d_zds_31910_002_file"
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, dw_insert.RowCount())
If li_find < 1 Then
	MessageBox('선택확인', '선택 된 항목이 없습니다.')
	Return
End If

String  ls_sabu
ls_sabu = dw_insert.GetItemString(li_find, 'sabu')
If Trim(ls_sabu) = '' OR IsNull(ls_sabu) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SABU)')
	Return
End If

String  ls_saupj
ls_saupj = dw_insert.GetItemString(li_find, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '필수 Key값이 누락 되었습니다.(SAUPJ)')
	Return
End If

String  ls_code
ls_code = dw_insert.GetItemString(li_find, 'bpcode')
If Trim(ls_code) = '' OR IsNull(ls_code) Then
	MessageBox('필수 확인', '관리코드 값이 누락 되었습니다.(BPCODE)')
	Return
End If

Choose Case dwo.name
	Case 'b_ins'
//		Integer li_ins
//		li_ins = This.InsertRow(0)
//		
//		This.SetItem(li_ins, 'sabu'  , ls_sabu )
//		This.SetItem(li_ins, 'saupj' , ls_saupj)
//		This.SetItem(li_ins, 'bpcode', ls_code )
		
		Int    li_rtn
		String ls_path
		String ls_file
		
		li_rtn = GetFileOpenName('Select File', ls_path, ls_file, 'Files', 'All Files (*.*), *.*')
		
		If li_rtn < 0 Then
			MessageBox('파일 확인', '파일을 다시 선택 하십시오.')
			ChangeDirectory('C:\erpman\')
			Return
		End If
		
		If li_rtn = 0 Then
			ChangeDirectory('C:\erpman\')
			Return
		End If
		
		ChangeDirectory('C:\erpman\')
		
		SetPointer(HOURGLASS!)
		
		/* 파일업로드 PK 생성 */
		INSERT INTO BP_MASTER_FILE (SABU, SAUPJ, BPCODE, SER)
		SELECT A.SABU, A.SAUPJ, A.BPCODE, NVL(B.SER, 0) + 1 SER
		 FROM BP_MASTER A,
				( SELECT SABU, SAUPJ, BPCODE, MAX(SER) SER FROM BP_MASTER_FILE GROUP BY SABU, SAUPJ, BPCODE ) B
		WHERE A.SABU = :ls_sabu  AND A.SAUPJ = :ls_saupj  AND A.BPCODE = :ls_code
		  AND A.SABU = B.SABU(+) AND A.SAUPJ = B.SAUPJ(+) AND A.BPCODE = B.BPCODE(+) ;
		If SQLCA.SQLCODE = 0 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
			MessageBox('처리 오류', '업로드 자료 생성 중 오류가 발생 했습니다.')
			Return
		End If
		
		String  ls_ser
		SELECT MAX(SER)
		  INTO :ls_ser
		  FROM BP_MASTER_FILE
		 WHERE SABU = :ls_sabu  AND SAUPJ = :ls_saupj  AND BPCODE = :ls_code ;

		Integer li_filenum, li_loops, i
		Long ll_len, ll_read, ll_new_pos
		Blob lb_tot_b, blob_temp, total_blob, blank_blob
		
		//파일의 크기를 구한다.
		ll_len = FileLength(ls_path)
		
		//저장할 파일을 스트림모드로 먼저 연다
		li_filenum = FileOpen(ls_path, STREAMMODE!, READ!, LOCKREAD!)
		
		FileReadEx(li_filenum, blob_temp)
		total_blob = blob_temp
		
		FileClose(li_filenum)
		
		SQLCA.AutoCommit = True
		
		//업데이트
		UPDATEBLOB BP_MASTER_FILE
				 SET FILEBLOB = :total_blob
		     WHERE SABU     = :ls_sabu
			    AND SAUPJ    = :ls_saupj
				 AND BPCODE   = :ls_code
				 AND SER      = :ls_ser
		USING SQLCA;
		
		SQLCA.AutoCommit = False
		
		SetPointer(Arrow!)
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('파일저장 실패', '첨부파일 저장 중 오류가 발생 했습니다.')
			Return
		End If
		
		//파일확장자 저장
		UPDATE BP_MASTER_FILE
		   SET FILETYPE = REVERSE(SUBSTR(REVERSE(:ls_file), 1, INSTR(REVERSE(:ls_file), '.') - 1)),
			    FILENAME = :ls_file,
				 FILEPATH = :ls_path
		 WHERE SABU   = :ls_sabu
		   AND SAUPJ  = :ls_saupj
			AND BPCODE = :ls_code
			AND SER    = :ls_ser ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('파일확장자 저장 실패', '파일정보 저장 중 오류가 발생 했습니다.')
			Return
		End If
		
		COMMIT USING SQLCA;
		
		dw_file.Retrieve(ls_sabu, ls_saupj, ls_code)
		
		MessageBox('파일등록', '첨부파일이 등록 되었습니다.')
	Case 'b_up'
	Case 'b_del'
		Long    ll_err
		Integer l
		Integer li_fchk
		String  ls_get[]
		String  ls_err
		DWItemStatus l_stts
		For l = 1 To This.RowCount()
			li_fchk = This.Find("f_chk = 'Y'", l, This.RowCount())
			If li_fchk < 1 Then Exit
			
			ls_get[1] = This.GetItemString(l, 'sabu'  )
			ls_get[2] = This.GetItemString(l, 'saupj' )
			ls_get[3] = This.GetItemString(l, 'bpcode')
			ls_get[4] = This.GetItemString(l, 'ser'   )
			
			l_stts = This.GetItemStatus(l, 0, Primary!)
			If l_stts = New! OR l_stts = NewModified! Then
				This.DeleteRow(l)
				l = l - 1
			Else
				DELETE FROM BP_MASTER_FILE
				 WHERE SABU = :ls_get[1] AND SAUPJ = :ls_get[2] AND BPCODE = :ls_get[3] AND SER = :ls_get[4] ;
				If SQLCA.SQLCODE <> 0 Then
					ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
					ROLLBACK USING SQLCA;
					MessageBox('DB Error Code - ' + String(ll_err), ls_err + '~r~n자료 삭제 중 오류가 발생 했습니다.(' + String(l) + ')')
					Return
				End If
			End If
		Next
		
		COMMIT USING SQLCA;
		
		dw_file.Retrieve(ls_get[1], ls_get[2], ls_get[3])
		
		MessageBox('삭제 확인', '선택된 항목이 삭제 되었습니다.')
	Case 'b_cls'
		This.Visible      = False
		dw_insert.Enabled = True
End Choose

end event

type rr_1 from roundrectangle within w_zds_31910
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 4576
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

