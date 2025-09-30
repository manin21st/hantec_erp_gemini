$PBExportHeader$w_zds_31930.srw
$PBExportComments$BOX 입고 등록
forward
global type w_zds_31930 from w_inherite
end type
type rr_1 from roundrectangle within w_zds_31930
end type
type dw_1 from datawindow within w_zds_31930
end type
end forward

global type w_zds_31930 from w_inherite
string title = "BOX입고 등록"
rr_1 rr_1
dw_1 dw_1
end type
global w_zds_31930 w_zds_31930

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

SetNull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
	If gs_code <> '%' Then
		dw_1.Modify('saupj.protect = 1')
		dw_1.Modify('saupj.background.color = 80859087')
	End If
End If

String  ls_name
SELECT CVNAS2
  INTO :ls_name
  FROM VNDMST
 WHERE CVCOD    = 'Z01'
	AND CVSTATUS = '0' ;

dw_1.SetItem(1, 'depot'  , 'Z01'                      )
dw_1.SetItem(1, 'depotnm', ls_name                    )
dw_1.SetItem(1, 'actdat' , String(TODAY(), 'yyyymmdd'))

dw_insert.SetRedraw(False)
dw_insert.Retrieve()
dw_insert.SetRedraw(True)
end event

on w_zds_31930.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_zds_31930.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
end on

type dw_insert from w_inherite`dw_insert within w_zds_31930
integer x = 46
integer y = 344
integer width = 4558
integer height = 1904
string dataobject = "d_zds_31930_002"
boolean border = false
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)
end event

type p_delrow from w_inherite`p_delrow within w_zds_31930
boolean visible = false
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;If MessageBox('삭제여부', '삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

dw_insert.AcceptText()

Integer cnt
cnt = dw_insert.RowCount()
If cnt < 1 Then Return

Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, cnt)
If li_find < 1 Then
	MessageBox('선택 확인', '선택 된 행이 없습니다.')
	Return
End If

SetNull(li_find)

Integer i
Long    ll_err
String  ls_saupj
String  ls_jpno
String  ls_err
For i = 1 To cnt
	li_find = dw_insert.Find("f_chk = 'Y'", i, cnt)
	If li_find < 1 Then Exit
	
	ls_saupj = dw_insert.GetItemString(li_find, 'saupj' )
	ls_jpno  = dw_insert.GetItemString(li_find, 'iojpno')
	
	DELETE FROM BOX_IO
	 WHERE SAUPJ = :ls_saupj AND IOJPNO = :ls_jpno ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Delete Error : ' + String(ll_err), '삭제 중 오류가 발생 했습니다.~r~n' + ls_err)
		Return
	End If
Next

COMMIT USING SQLCA;
MessageBox('삭제 확인', '삭제 되었습니다.')

p_inq.PostEvent('Clicked')
end event

type p_addrow from w_inherite`p_addrow within w_zds_31930
boolean visible = false
integer x = 3749
integer y = 284
end type

type p_search from w_inherite`p_search within w_zds_31930
boolean visible = false
integer y = 284
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_zds_31930
boolean visible = false
integer y = 284
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_zds_31930
end type

type p_can from w_inherite`p_can within w_zds_31930
end type

type p_print from w_inherite`p_print within w_zds_31930
boolean visible = false
integer y = 284
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_zds_31930
boolean visible = false
integer x = 3749
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_saupj
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

String  ls_st
String  ls_ed
ls_st = dw_1.GetItemString(row, 'actdat')
If Trim(ls_st) = '' OR IsNull(ls_st) Then 
	ls_st = '19000101'
	ls_ed = '21001231'
Else
	ls_ed = ls_st
End If

String  ls_cvcod
ls_cvcod = dw_1.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String  ls_fac
ls_fac = dw_1.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_saupj, ls_st, ls_ed, ls_cvcod, ls_fac)
dw_insert.SetRedraw(True)
	
ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_zds_31930
boolean visible = false
integer y = 284
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_zds_31930
integer x = 4096
end type

event p_mod::clicked;call super::clicked;dw_1.AcceptText()
dw_insert.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

Integer rt
rt = dw_insert.RowCount()
If rt < 1 Then Return

Integer li_find
li_find = dw_insert.Find("ioqty > 0", 1, rt)
If li_find < 1 Then Return

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

String  ls_dept
ls_dept = dw_1.GetItemString(row, 'depot')
If Trim(ls_dept) = '' OR IsNull(ls_dept) Then
	MessageBox('필수 확인', '창고(외주처)를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('depot')
	Return
End If

/* 입력된 코드값이 외주처인지 확인 */
/* 입력된 값이 외주처이면 거래처->한텍(입고), 한텍->외주처(출고) 자료를 생성 */
String  ls_chk
SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
  INTO :ls_chk
  FROM VNDMST
 WHERE CVCOD     = :ls_dept
   AND CVSTATUS  = '0'
   AND (OYJUGAYN = 'Y' OR OYJUYN = 'Y') ;

String  ls_dat
ls_dat = dw_1.GetItemString(row, 'actdat')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then
	MessageBox('필수 확인', '일자를 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('actdat')
	Return
End If

String  ls_gbn
ls_gbn = dw_1.GetItemString(row, 'gubun')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then ls_gbn = 'I'

String  ls_today
String  ls_tim
ls_today = String(TODAY(), 'yyyymmdd')
ls_tim   = String(TODAY(), 'hhmmss'  )

/*송장번호 채번*/
Long   ll_seq
ll_seq = SQLCA.FUN_JUNPYO(gs_sabu, ls_today, 'A4')
If ll_seq <= 0 Then
	f_message_chk(51, '')
	ROLLBACK USING SQLCA;
	Return
End If

COMMIT USING SQLCA;

SetNull(li_find)
Integer l ; l = 0
Integer i
Long    ll_qty
Long    ll_err
String  ls_bigo
String  ls_plt
String  ls_jpno
String  ls_err
For i = 1 To rt
	li_find = dw_insert.Find("ioqty > 0", i, rt)
	If li_find < 1 Then Exit
	
	l++
	ls_jpno = ls_today + String(ll_seq, '0000') + String(l, '000')
	
	ls_plt  = dw_insert.GetItemString(li_find, 'rfgub')
	ls_bigo = dw_insert.GetItemString(li_find, 'bigo' )
	ll_qty  = dw_insert.GetItemNumber(li_find, 'ioqty')
	
	INSERT INTO BOX_IO (
	SAUPJ, IOJPNO  , IO_DATE , IOGBN   , DEPOT   , CVCOD   , PLTCOD  , PLTQTY, IOQTY  , PRC      ,
	AMT  , CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, BIGO  , RE_DATE, HIST_JPNO)
	VALUES (
	:ls_saupj, :ls_jpno , :ls_dat, :ls_gbn  , :ls_dept, :ls_cvcod, :ls_plt, :ll_qty , :ll_qty, 0   ,
	0        , :ls_today, :ls_tim, :gs_empno, NULL    , NULL     , NULL   , :ls_bigo, :ls_dat, NULL) ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Insert Error Code - ' + String(ll_err), '자료 생성 중 오류가 발생 했습니다.~r~n' + ls_err)
		Return
	End If
	
	/* 창고 구분이 외주처이면 출고자료 생성 */
	If ls_chk = 'Y' Then
		l++
		ls_jpno = ls_today + String(ll_seq, '0000') + String(l, '000')
		
		INSERT INTO BOX_IO (
		SAUPJ, IOJPNO  , IO_DATE , IOGBN   , DEPOT   , CVCOD   , PLTCOD  , PLTQTY, IOQTY  , PRC      ,
		AMT  , CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, BIGO  , RE_DATE, HIST_JPNO)
		VALUES (
		:ls_saupj, :ls_jpno , :ls_dat, :ls_gbn  , :ls_dept, :ls_cvcod, :ls_plt, :ll_qty           , :ll_qty, 0   ,
		0        , :ls_today, :ls_tim, :gs_empno, NULL    , NULL     , NULL   , '외주처 자동 출고', :ls_dat, NULL) ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
			MessageBox('Insert Error Code - ' + String(ll_err), '자료 생성 중 오류가 발생 했습니다.~r~n' + ls_err)
			Return
		End If
	End If
	
	i = li_find
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '저장 되었습니다.')
	
	ib_any_typing = False
	
	dw_insert.SetRedraw(False)
	dw_insert.Retrieve()
	dw_insert.SetRedraw(True)
Else
	SetNull(ll_err) ; SetNull(ls_err)
	ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
	ROLLBACK USING SQLCA;
	MessageBox('Insert Error Code - ' + String(ll_err), '자료 생성 중 오류가 발생 했습니다.~r~n' + ls_err)
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_zds_31930
end type

type cb_mod from w_inherite`cb_mod within w_zds_31930
end type

type cb_ins from w_inherite`cb_ins within w_zds_31930
end type

type cb_del from w_inherite`cb_del within w_zds_31930
end type

type cb_inq from w_inherite`cb_inq within w_zds_31930
end type

type cb_print from w_inherite`cb_print within w_zds_31930
end type

type st_1 from w_inherite`st_1 within w_zds_31930
end type

type cb_can from w_inherite`cb_can within w_zds_31930
end type

type cb_search from w_inherite`cb_search within w_zds_31930
end type







type gb_button1 from w_inherite`gb_button1 within w_zds_31930
end type

type gb_button2 from w_inherite`gb_button2 within w_zds_31930
end type

type rr_1 from roundrectangle within w_zds_31930
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

type dw_1 from datawindow within w_zds_31930
integer x = 37
integer y = 24
integer width = 3328
integer height = 284
integer taborder = 10
string title = "none"
string dataobject = "d_zds_31930_001"
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
		dw_insert.DataObject = 'd_zds_31930_002'
		dw_insert.SetTransObject(SQLCA)
		
		p_delrow.Visible = False
		p_inq.Visible    = False
		
		dw_insert.SetRedraw(False)
		dw_insert.Retrieve()
		dw_insert.SetRedraw(True)
	Else
	//삭제
		dw_insert.DataObject = 'd_zds_31930_003'
		dw_insert.SetTransObject(SQLCA)
		p_delrow.Visible = True
		p_inq.Visible    = True
	End If
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

