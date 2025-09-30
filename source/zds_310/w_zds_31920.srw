$PBExportHeader$w_zds_31920.srw
$PBExportComments$PLT 입출고
forward
global type w_zds_31920 from w_inherite
end type
type dw_1 from datawindow within w_zds_31920
end type
type rr_1 from roundrectangle within w_zds_31920
end type
end forward

global type w_zds_31920 from w_inherite
integer width = 4667
integer height = 2596
string title = "PLT 입출고"
dw_1 dw_1
rr_1 rr_1
end type
global w_zds_31920 w_zds_31920

on w_zds_31920.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_zds_31920.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')

end event

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
		dw_1.Modify("saupj.background.color = 80859087")
   End if
End If
end event

type dw_insert from w_inherite`dw_insert within w_zds_31920
integer x = 46
integer y = 344
integer width = 4558
integer height = 1904
string dataobject = "d_zds_31920_002"
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_zds_31920
boolean visible = false
integer x = 3355
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_zds_31920
boolean visible = false
integer x = 3182
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_zds_31920
boolean visible = false
integer x = 2487
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_zds_31920
boolean visible = false
integer x = 3749
integer y = 200
end type

event p_ins::clicked;call super::clicked;Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_saupj
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '사업장을 확인 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

String  ls_cvcod
ls_cvcod = dw_1.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('필수 확인', '거래처를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('cvcod')
	Return
End If

String  ls_fac
ls_fac = dw_1.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('필수 확인', '공장을 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('factory')
	Return
End If

String  ls_dept
ls_dept = dw_1.GetItemString(row, 'depot')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('필수 확인', '처리부서를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('depot')
	Return
End If

String  ls_dat
ls_dat = dw_1.GetItemString(row, 'actdat')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('필수 확인', '일자를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('actdat')
	Return
End If

String  ls_gbn
ls_gbn = dw_1.GetItemString(row, 'gubun')

Integer li_ins
li_ins = dw_insert.InsertRow(0)

dw_insert.SetItem(li_ins, 'sabu'   , gs_sabu )
dw_insert.SetItem(li_ins, 'saupj'  , ls_saupj)
dw_insert.SetItem(li_ins, 'cvcod'  , ls_cvcod)
dw_insert.SetItem(li_ins, 'depot'  , ls_dept )
dw_insert.SetItem(li_ins, 'actdat' , ls_dat  )
dw_insert.SetItem(li_ins, 'factory', ls_fac  )
dw_insert.SetItem(li_ins, 'gubun'  , ls_gbn  )
end event

type p_exit from w_inherite`p_exit within w_zds_31920
end type

type p_can from w_inherite`p_can within w_zds_31920
end type

event p_can::clicked;call super::clicked;dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetItem(1, 'saupj' , gs_saupj                   )
dw_1.SetItem(1, 'actdat', String(TODAY(), 'yyyymmdd'))

dw_insert.DataObject = 'd_zds_31920_002'
dw_insert.SetTransObject(SQLCA)
end event

type p_print from w_inherite`p_print within w_zds_31920
boolean visible = false
integer x = 2661
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_zds_31920
integer x = 3749
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Integer li_row
li_row = dw_1.GetRow()
If li_row < 1 Then Return

String  ls_gbn
ls_gbn = dw_1.GetItemString(li_row, 'gbn')
If ls_gbn = '1' Then
	dw_insert.SetRedraw(False)
	dw_insert.Retrieve()
	dw_insert.SetRedraw(True)
ElseIf ls_gbn = '2' Then
	String  ls_saupj
	String  ls_cvcod
	String  ls_fac
	String  ls_dat
	String  ls_gubun
	ls_gubun = dw_1.GetItemString(li_row, 'gubun'  )
	ls_saupj = dw_1.GetItemString(li_row, 'saupj'  )
	ls_cvcod = dw_1.GetItemString(li_row, 'cvcod'  )
	ls_fac   = dw_1.GetItemString(li_row, 'factory')
	ls_dat   = dw_1.GetItemString(li_row, 'actdat' )
	
	If Trim(ls_gubun) = '' OR IsNull(ls_gubun) Then ls_gubun = '%'
	If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'
	If Trim(ls_fac)   = '' OR IsNull(ls_fac)   Then ls_fac   = '%'
	If Trim(ls_dat)   = '' OR IsNull(ls_dat)   Then ls_dat   = '%'
	
	dw_insert.SetRedraw(False)
	dw_insert.Retrieve(ls_gubun, ls_saupj, ls_cvcod, ls_fac, ls_dat)
	dw_insert.SetRedraw(True)
End If
end event

type p_del from w_inherite`p_del within w_zds_31920
end type

event p_del::clicked;call super::clicked;Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_gbn
ls_gbn = dw_1.GetItemString(row, 'gbn')
If ls_gbn = '1' Then Return

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, li_cnt)
If li_find < 1 Then
	MessageBox('선택대상', '선택된 항목이 없습니다.')
	Return
End If

SetNull(li_find)

Integer i
String  ls_sabu
String  ls_jpno
String  ls_err
Integer li_err
For i = 1 To li_cnt
	li_find = dw_insert.Find("f_chk = 'Y'", i, li_cnt)
	If li_find < 1 Then Exit
	
	ls_sabu = dw_insert.GetItemString(li_find, 'sabu'  )
	ls_jpno = dw_insert.GetItemString(li_find, 'iojpno')
	
	DELETE BP_IMHIST
	 WHERE SABU = :ls_sabu AND IOJPNO = :ls_jpno ;
	If SQLCA.SQLCODE <> 0 Then
		li_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('DB Delete Error [' + String(li_err) + ']', '삭제 중 오류가 발생했습니다.~r~n' + ls_err)
		Return
	End If
Next

COMMIT USING SQLCA;
MessageBox('삭제확인', '삭제 되었습니다.')

p_inq.TriggerEvent('Clicked')
end event

type p_mod from w_inherite`p_mod within w_zds_31920
end type

event p_mod::clicked;call super::clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_saupj
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('필수 확인', '사업장을 확인 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

String  ls_cvcod
ls_cvcod = dw_1.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('필수 확인', '거래처를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('cvcod')
	Return
End If

String  ls_fac
ls_fac = dw_1.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('필수 확인', '공장을 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('factory')
	Return
End If

String  ls_dept
ls_dept = dw_1.GetItemString(row, 'depot')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('필수 확인', '창고를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('depot')
	Return
End If

String  ls_dat
ls_dat = dw_1.GetItemString(row, 'actdat')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('필수 확인', '일자를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('actdat')
	Return
End If

String  ls_gbn
ls_gbn = dw_1.GetItemString(row, 'gubun')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then
	MessageBox('구분 확인', '처리구분을 확인 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('gubun')
	Return
End If

dw_insert.AcceptText()

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

Integer li_find
li_find = dw_insert.Find("ioqty > 0", 1, li_cnt)
If li_find < 1 Then
	MessageBox('출고 대상 확인', '출고 수량이 기입된 항목이 없습니다.')
	Return
End If

String  ls_jpdat
ls_jpdat = String(TODAY(), 'yyyymmdd')

String  ls_max
SELECT MAX(SUBSTR(IOJPNO, 9, 3))
  INTO :ls_max
  FROM BP_IMHIST
 WHERE SABU = :gs_sabu AND IOJPNO LIKE :ls_jpdat||'%' ;
If Trim(ls_max) = '' OR IsNull(ls_max) Then
	ls_max = '001'
Else
	ls_max = String(Long(ls_max) + 1, '000')
End If

Integer i
Integer l ; l = 0
Long    ll_qty
Long    ll_prc
Long    ll_err
String  ls_err
String  ls_jpno
String  ls_bpcod
String  ls_bigo
For i = 1 To li_cnt
	ll_qty = dw_insert.GetItemNumber(i, 'ioqty')
	If ll_qty < 1 OR IsNull(ll_qty) Then Continue
	
	l++
	
	ls_bpcod = dw_insert.GetItemString(i, 'bpcode')
	ls_jpno  = ls_jpdat + ls_max + String(l, '0000')
	ls_bigo  = dw_insert.GetItemString(i, 'bigo')
	
	INSERT INTO BP_IMHIST (
	SABU, IOJPNO, GUBUN, ACTDAT, CVCOD, FACTORY, DEPOT, BPCODE, IOQTY, UNPRC, BIGO, SAUPJ )
	VALUES (
	:gs_sabu, :ls_jpno, :ls_gbn, :ls_dat, :ls_cvcod, :ls_fac, :ls_dept, :ls_bpcod, :ll_qty, :ll_prc, :ls_bigo, :ls_saupj ) ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Insert fail - Error Code : ' + String(ll_err), '자료 저장 중 오류가 발생 했습니다.~r~n' + ls_err)
		Return
	End If
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('저장성공', '저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장 중 오류가 발생 했습니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_zds_31920
end type

type cb_mod from w_inherite`cb_mod within w_zds_31920
end type

type cb_ins from w_inherite`cb_ins within w_zds_31920
end type

type cb_del from w_inherite`cb_del within w_zds_31920
end type

type cb_inq from w_inherite`cb_inq within w_zds_31920
end type

type cb_print from w_inherite`cb_print within w_zds_31920
end type

type st_1 from w_inherite`st_1 within w_zds_31920
end type

type cb_can from w_inherite`cb_can within w_zds_31920
end type

type cb_search from w_inherite`cb_search within w_zds_31920
end type







type gb_button1 from w_inherite`gb_button1 within w_zds_31920
end type

type gb_button2 from w_inherite`gb_button2 within w_zds_31920
end type

type dw_1 from datawindow within w_zds_31920
integer x = 37
integer y = 24
integer width = 3328
integer height = 284
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_zds_31920_001"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String	sVendor, sVendorname, sNull

SetNull(sNull)

This.AcceptText()

// 거래처
If This.GetColumnName() = 'cvcod' Then
	sVendor = data
	If Trim(sVendor) = '' OR IsNull(sVendor) Then
		this.setitem(1, 'cvnas', sNull)
		Return
	End If
	
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD    = :sVendor
 	   AND CVSTATUS = '0' ;
	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33, '[거래처]')
		This.SetItem(1, 'cvcod', sNull)
		This.SetItem(1, 'cvnas', sNull)
		Return 1
	End If

	This.SetItem(1, 'cvnas', sVendorName)
	
ElseIf This.GetColumnName() = 'depot' Then
	sVendor = data
	If Trim(sVendor) = '' OR IsNull(sVendor) Then
		This.SetItem(1, 'depotnm', sNull)
		Return
	End If
	
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD    = :sVendor
 	   AND CVSTATUS = '0' ;
	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33, '[창고]')
		This.SetItem(1, 'depot'  , sNull)
		This.SetItem(1, 'depotnm', sNull)
		Return 1
	End If

	This.SetItem(1, 'depotnm', sVendorName)
	
ElseIf This.GetColumnName() = 'gbn' Then
	//등록
	If data = '1' Then
		dw_insert.DataObject = 'd_zds_31920_002'
	Else
	//삭제
		dw_insert.DataObject = 'd_zds_31920_004'
	End If
	dw_insert.SetTransObject(SQLCA)
End If
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "cvcod",		gs_code)
	SetItem(1, "cvnas",gs_codename)
ElseIf This.GetColumnName() = 'depot' Then
   gs_gubun = '5' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "depot",		gs_code)
	SetItem(1, "depotnm",gs_codename)
END IF


end event

type rr_1 from roundrectangle within w_zds_31920
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 336
integer width = 4576
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

