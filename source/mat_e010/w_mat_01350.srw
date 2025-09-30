$PBExportHeader$w_mat_01350.srw
$PBExportComments$입고 LOT라벨 등록
forward
global type w_mat_01350 from w_inherite
end type
type dw_ret from datawindow within w_mat_01350
end type
type cbx_1 from checkbox within w_mat_01350
end type
type pb_1 from u_pb_cal within w_mat_01350
end type
type pb_2 from u_pb_cal within w_mat_01350
end type
type cb_1 from commandbutton within w_mat_01350
end type
type dw_csv from datawindow within w_mat_01350
end type
type dw_hidden from datawindow within w_mat_01350
end type
type cb_2 from commandbutton within w_mat_01350
end type
type dw_prt from datawindow within w_mat_01350
end type
end forward

global type w_mat_01350 from w_inherite
integer width = 4672
integer height = 2464
string title = "입고 LOT라벨 등록"
dw_ret dw_ret
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
cb_1 cb_1
dw_csv dw_csv
dw_hidden dw_hidden
cb_2 cb_2
dw_prt dw_prt
end type
global w_mat_01350 w_mat_01350

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();Integer i
String  ls_iojpno, ls_prjpno, ls_lot, ls_coilno
Decimal ld_qty, ld_prqty, ld_sumqty

For i = 1 To dw_insert.RowCount()

	ls_iojpno = dw_insert.GetItemString(i, 'iojpno')	
//	If ld_sumqty > 0 And ls_prjpno <> ls_iojpno Then
//		// 단위수량/중량 합을 입고중량과 비교
//		If ld_prqty * 1.05 < ld_sumqty Or ld_prqty * 0.95 > ld_sumqty Then
//			MessageBox('확인', '입고수량과 단위수량/중량합이 허용범위 ±5%를 벗어납니다!')
//			dw_insert.ScrollToRow(i -1)
//			dw_insert.SetColumn('lot_qty')
//			dw_insert.SetFocus()
//			Return -1
//		End If
//		ld_sumqty = 0
//	End If

	ld_qty = dw_insert.GetItemNumber(i, 'lot_qty')
	If ld_qty <= 0 OR IsNull(ld_qty) Then Continue

	ls_lot = dw_insert.GetItemString(i, 'lotsno')
	If Trim(ls_lot) = '' OR IsNull(ls_lot) Then
		MessageBox('확인', 'LOT-NO가 지정되지 않았습니다!')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('lotsno')
		dw_insert.SetFocus()
		Return -1
	End If

//	ls_coilno = dw_insert.GetItemString(i, 'coilno')
//	If Trim(ls_coilno) = '' OR IsNull(ls_coilno) Then
//		MessageBox('확인', 'COIL-NO가 지정되지 않았습니다!')
//		dw_insert.ScrollToRow(i)
//		dw_insert.SetColumn('coilno')
//		dw_insert.SetFocus()
//		Return -1
//	End If

	ls_prjpno = ls_iojpno
	ld_prqty  = dw_insert.GetItemNumber(i, 'ioqty')
	ld_sumqty = ld_sumqty + ld_qty
Next

//If ld_sumqty > 0 Then
//	// 단위수량/중량 합을 입고중량과 비교
//	If ld_prqty * 1.05 < ld_sumqty Or ld_prqty * 0.95 > ld_sumqty Then
//		MessageBox('확인', '입고수량과 단위수량/중량합이 허용범위 ±5%를 벗어납니다!')
//		dw_insert.ScrollToRow(i -1)
//		dw_insert.SetColumn('lot_qty')
//		dw_insert.SetFocus()
//		Return -1
//	End If
//End If

Return 1
end function

event open;call super::open;This.TriggerEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_ret.SetTransObject(SQLCA)
dw_ret.InsertRow(0)

dw_prt.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

//dw_ret.SetItem(1, 'stdy', String(TODAY(), 'yyyymm') + '01')
dw_ret.SetItem(1, 'stdy', String(TODAY(), 'yyyymmdd'))
dw_ret.SetItem(1, 'eddy', String(TODAY(), 'yyyymmdd'))

//f_mod_saupj(dw_ret, 'saupj')
dw_ret.SetItem(1, 'saupj', gs_saupj)
end event

on w_mat_01350.create
int iCurrent
call super::create
this.dw_ret=create dw_ret
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_1=create cb_1
this.dw_csv=create dw_csv
this.dw_hidden=create dw_hidden
this.cb_2=create cb_2
this.dw_prt=create dw_prt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ret
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_csv
this.Control[iCurrent+7]=this.dw_hidden
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.dw_prt
end on

on w_mat_01350.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ret)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_1)
destroy(this.dw_csv)
destroy(this.dw_hidden)
destroy(this.cb_2)
destroy(this.dw_prt)
end on

type dw_insert from w_inherite`dw_insert within w_mat_01350
integer x = 37
integer y = 256
integer width = 4576
integer height = 1992
string title = "d_mat_01350_e"
string dataobject = "d_mat_01350_D"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

This.SelectRow(0, False)

If dw_ret.GetItemString(1, 'gbn') = 'I' Then
	f_setfocus_dw(This, row, 'lotsno')
Else
	f_setfocus_dw(This, row, 'f_chk')
End If

This.SelectRow(row, True)
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

Long		i
String		ls_iojpno

Choose Case dwo.name
	Case 'coilno'
		ls_iojpno = This.GetItemString(row, 'iojpno' )
		For i = 1 to This.RowCount()
			If ls_iojpno = This.GetItemString(i, 'iojpno' ) Then
				This.SetItem(i, 'coilno' , data)
			End If
		Next
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_mat_01350
boolean visible = false
integer x = 3753
integer y = 272
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mat_01350
boolean visible = false
integer x = 3579
integer y = 272
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mat_01350
boolean visible = false
integer x = 3566
integer y = 428
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mat_01350
integer x = 3561
integer y = 16
end type

event p_ins::clicked;call super::clicked;dw_insert.AcceptText()

Integer row
row = dw_insert.GetRow()
If row < 1 Then Return

If dw_ret.GetItemString(1, 'gbn') <> 'I' Then
	MessageBox('확인', '등록일 경우만 가능 합니다.')
	Return
End If

If dw_insert.RowsCopy(row, row, Primary!, dw_insert, row + 1, Primary!) <> 1 Then
	MessageBox('확인', 'Lot 추가 중 오류가 발생 했습니다.')
	Return
End If

f_setfocus_dw(dw_insert, row + 1, 'lotsno')

end event

type p_exit from w_inherite`p_exit within w_mat_01350
integer x = 4430
integer y = 16
end type

type p_can from w_inherite`p_can within w_mat_01350
integer x = 4256
integer y = 16
end type

type p_print from w_inherite`p_print within w_mat_01350
integer x = 4082
integer y = 16
end type

event p_print::clicked;call super::clicked;If dw_ret.GetItemString(1, 'gbn') <> 'D' Then
	MessageBox('확인', '삭제일 경우 가능 합니다.')
	Return
End If

String ls_iojpno[]
String ls_chk

Long   i
Long   ll_chk

ll_chk = 0

For i = 1 To dw_insert.RowCount()
	ls_chk = dw_insert.GetItemString(i, 'f_chk')
	If ls_chk = 'Y' Then
//		ls_iojpno[i] = dw_insert.GetItemString(i, 'imhist_iojpno')
		ls_iojpno[i] = dw_insert.GetItemString(i, 'imhist_lot_th_barno')
		ll_chk++
	End If
Next

If ll_chk < 1 Then
	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
	Return
End If

dw_prt.Retrieve(gs_sabu, ls_iojpno)
OpenWithParm(w_print_preview, dw_prt)

end event

type p_inq from w_inherite`p_inq within w_mat_01350
integer x = 3387
integer y = 16
end type

event p_inq::clicked;call super::clicked;dw_ret.AcceptText()

Integer row
row = dw_ret.GetRow()
If row < 1 Then Return

String  ls_saupj
ls_saupj = dw_ret.GetItemString(row, 'saupj')
If IsNull(ls_saupj) OR Trim(ls_saupj) = '' Then ls_saupj = '%'

String  ls_sdat
ls_sdat = dw_ret.GetItemString(row, 'stdy')
If IsNull(ls_sdat) OR Trim(ls_sdat) = '' Then
	MessageBox('확인', '시작일자를 입력 하십시오.')
	f_setfocus_dw(dw_ret, row, 'stdy')
	Return
End If

String  ls_edat
ls_edat = dw_ret.GetItemString(row, 'eddy')
If IsNull(ls_edat) OR Trim(ls_edat) = '' Then
	MessageBox('확인', '종료일자를 입력 하십시오.')
	f_setfocus_dw(dw_ret, row, 'eddy')
	Return
End If

String  ls_cvcod
ls_cvcod = dw_ret.GetItemString(row, 'tovnd')
If IsNull(ls_cvcod) Or Trim(ls_cvcod) = '' Then
//	ls_cvcod = '%'
	MessageBox('확인', '거래처를 입력 하십시오.')
	f_setfocus_dw(dw_ret, row, 'tovnd')
	Return
End If

String  ls_ittyp
ls_ittyp = dw_ret.GetItemString(row, 'ittyp')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_saupj, ls_sdat, ls_edat, ls_cvcod, ls_ittyp)
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_mat_01350
integer x = 3909
integer y = 16
end type

event p_del::clicked;call super::clicked;dw_insert.AcceptText()

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

If dw_ret.GetItemString(1, 'gbn') <> 'D' Then
//	MessageBox('확인', '삭제일 경우 가능 합니다.')
	li_cnt = dw_insert.GetSelectedRow(0)
	If li_cnt > 0 Then
		dw_insert.DeleteRow(li_cnt)
	End If	
	Return
End If


If f_msg_delete() = -1 Then Return

Integer li_find
li_find = dw_insert.Find("f_chk = 'Y'", 1, li_cnt)
If li_find < 1 Then
	MessageBox('확인', '선택 된 행이 없습니다.')
	Return
End If

Integer i
Integer l ; l = 0
String  ls_iojpno
String  ls_lotno, ls_barno
String  ls_err
Long    ll_err

For i = 1 To li_cnt
	If dw_insert.GetItemString(i, 'f_chk') = 'N' Then Continue
	
	ls_barno = dw_insert.GetItemString(i, 'imhist_lot_th_barno')
	
	DELETE FROM IMHIST_LOT_TH WHERE BARNO = :ls_barno ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Delete Err [' + String(ll_err) + ']', '삭제 중 오류가 발생 했습니다.[1]~r~n' + ls_err)
		Return
	End If

//	ls_iojpno = dw_insert.GetItemString(i, 'iojpno')
//	ls_lotno  = dw_insert.GetItemString(i, 'lotno' )
//
//	DELETE FROM IMHIST_LOT
//	 WHERE IOJPNO = :ls_iojpno AND LOTNO = :ls_lotno ;
//	If SQLCA.SQLCODE <> 0 Then
//		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
//		ROLLBACK USING SQLCA;
//		MessageBox('Delete Err [' + String(ll_err) + ']', '삭제 중 오류가 발생 했습니다.[1]~r~n' + ls_err)
//		Return
//	End If

Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('확인', '삭제 되었습니다.')
Else
	ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
	ROLLBACK USING SQLCA;
	MessageBox('Delete Err [' + String(ll_err) + ']', '삭제 중 오류가 발생 했습니다.[2]~r~n' + ls_err)
	Return
End If

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_mat_01350
integer x = 3735
integer y = 16
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

If dw_ret.GetItemString(1, 'gbn') <> 'I' Then
	MessageBox('확인', '등록일 때 가능 합니다.')
	Return
End If

If dw_insert.ModifiedCount() < 1 Then
	MessageBox('확인', '변경사항이 없습니다.')
	Return
End If

Integer li_cnt
li_cnt = dw_insert.RowCount()
If li_cnt < 1 Then Return

If wf_required_chk() <> 1 Then Return
If f_msg_update() = -1 Then Return

Integer i
Integer l ; l = 0
String  ls_err
String  ls_iojpno
String  ls_lot
String  ls_bigo, ls_date
Long    ll_qty
Long    ll_err
dwItemStatus l_sts


////////////////////////////////////////////////////////////////////////////////////////////
Integer	li_seqno
String	ls_jpno, ls_coilno, ls_today
String	ls_barno[]

For i = 1 To li_cnt
	ls_iojpno = dw_insert.GetItemString(i, 'iojpno')
	ls_lot    = dw_insert.GetItemString(i, 'lotsno')
	ls_date  = dw_insert.GetItemString(i, 'io_date')
	ls_bigo   = ''
	ll_qty    = dw_insert.GetItemNumber(i, 'lot_qty')
	ls_coilno = dw_insert.GetItemString(i, 'coilno')	

	If ll_qty > 0 Then
		l++
		If l = 1 Then
			// 바코드번호 채번
			ls_today = f_today()
			li_seqno = sqlca.fun_junpyo(gs_sabu, ls_today, 'B1')
			IF li_seqno <= 0 THEN
				ROLLBACK;
				f_message_chk(51,'')
				Return
			END IF			
			ls_jpno = ls_today + String(li_seqno,'0000')
			Commit;
		End If
		
//		ls_barno[l] = ls_jpno + String(l,'000')
		ls_barno[l] = ls_jpno + String(l,'0000')	/* 16자리 기준 */
		
		/* LOT자료 생성 */
		INSERT INTO IMHIST_LOT_TH (
		BARNO, IOJPNO, LOTNO, LOT_QTY, COILNO, BIGO, CRT_DATE, CRT_TIME, CRT_USER,	IO_DATE )
		VALUES (
		:ls_barno[l], :ls_iojpno, :ls_lot, :ll_qty, :ls_coilno, :ls_bigo, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), :gs_empno, :ls_date ) ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
			MessageBox('Insert Err [' + String(ll_err) + ']', '자료 생성 중 오류가 발생 했습니다.[1]~r~n' + ls_err)
			Return
		End If
	End If
Next

If l < 1 Then
	MessageBox('확인', '변경사항이 없습니다.')
	Return
End If

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('확인', '저장 되었습니다.')
Else
	ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
	ROLLBACK USING SQLCA;
	MessageBox('Commit Err [' + String(ll_err) + ']', '저장 중 오류가 발생 했습니다.[3]~r~n' + ls_err)
	Return
End If

// 바코드라벨 자동 출력
dw_prt.Retrieve(gs_sabu, ls_barno)
If cbx_1.Checked Then
	OpenWithParm(w_print_preview, dw_prt)
End If

ib_any_typing = False
p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_mat_01350
end type

type cb_mod from w_inherite`cb_mod within w_mat_01350
end type

type cb_ins from w_inherite`cb_ins within w_mat_01350
end type

type cb_del from w_inherite`cb_del within w_mat_01350
end type

type cb_inq from w_inherite`cb_inq within w_mat_01350
end type

type cb_print from w_inherite`cb_print within w_mat_01350
end type

type st_1 from w_inherite`st_1 within w_mat_01350
end type

type cb_can from w_inherite`cb_can within w_mat_01350
end type

type cb_search from w_inherite`cb_search within w_mat_01350
end type







type gb_button1 from w_inherite`gb_button1 within w_mat_01350
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_01350
end type

type dw_ret from datawindow within w_mat_01350
integer x = 37
integer y = 20
integer width = 2656
integer height = 212
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_01350_c"
boolean border = false
boolean livescroll = true
end type

event itemchanged;dw_insert.ReSet()

If row < 1 Then Return

String  ls_nam, ls_mod

Choose Case dwo.name
	Case 'tovnd'
		If IsNull(data) OR Trim(data) = '' Then
			This.SetItem(row, 'tovndnam', '')
			Return
		End If
		
		SELECT CVNAS INTO :ls_nam
		  FROM VNDMST
		 WHERE CVCOD = :data ;
		If SQLCA.SQLCODE <> 0 OR Trim(ls_nam) = '' OR IsNull(ls_nam) Then
			This.SetItem(row, 'tovnd'   , '')
			This.SetItem(row, 'tovndnam', '')
			MessageBox('확인', '등록된 고객사 코드가 아닙니다.')
			Return
		End If
		
		This.SetItem(row, 'tovndnam', ls_nam)
		
	Case 'gbn'
		ls_mod = GetItemString(row, 'ittyp')
		If data = 'I' Then
			dw_insert.DataObject = 'd_mat_01350_e'
			cbx_1.Visible = True

			cb_1.Text = '발주코일수 분할'
			If ls_mod = '3' Then
				cb_1.Visible = True
			Else
				cb_1.Visible = False
			End If
		Else
			dw_insert.DataObject = 'd_mat_01350_d'
			cb_1.Text = '기존재고 라벨출력'
			cb_1.Visible = True
			cbx_1.Visible = False
		End If
		
		dw_insert.SetTransObject(SQLCA)

	Case 'ittyp'
		If data = '3' Then
			MessageBox('확인', '원자재코일 라벨은 입고일보에서 발행가능합니다.')
			Return
		End If

//		ls_mod = GetItemString(row, 'gbn')
//		If data = '3' And ls_mod = 'I' Then
//			cb_1.Visible = True
//		Else
//			cb_1.Visible = False
//		End If
End Choose
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'tovnd'
		Open(w_vndmst_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(row, 'tovnd'   , gs_code    )
		This.SetItem(row, 'tovndnam', gs_codename)
		
End Choose
end event

type cbx_1 from checkbox within w_mat_01350
integer x = 2725
integer y = 168
integer width = 933
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "저장시 바코드라벨 자동 출력"
boolean checked = true
end type

type pb_1 from u_pb_cal within w_mat_01350
integer x = 1673
integer y = 32
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ret.SetColumn('stdy')
IF IsNull(gs_code) THEN Return
ll_row = dw_ret.GetRow()
If ll_row < 1 Then Return
dw_ret.SetItem(ll_row, 'stdy', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_01350
integer x = 2185
integer y = 32
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ret.SetColumn('eddy')
IF IsNull(gs_code) THEN Return
ll_row = dw_ret.GetRow()
If ll_row < 1 Then Return
dw_ret.SetItem(ll_row, 'eddy', gs_code)



end event

type cb_1 from commandbutton within w_mat_01350
boolean visible = false
integer x = 5152
integer y = 96
integer width = 590
integer height = 132
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
string text = "발주코일수 분할"
end type

event clicked;dw_insert.AcceptText()

Long		i, j, k, lrow, lcnt, lBalseq, lCoilCnt, lseq
String		sBaljpno, sToday
Decimal	dInqty


//--------------------------------------------------------------------------------------------------------------------
// 기존재고 라벨 발행 LOGIC
If dw_ret.GetItemString(1, 'gbn') <> 'I' Then
//	MessageBox('확인', '등록일 경우만 가능 합니다.')
	Open(w_mat_01350_imsi)              
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	
	SetPointer(HourGlass!)

	dw_hidden.reset()
	dw_hidden.ImportClipboard()
	
	dw_prt.reset()
	FOR k=1 TO dw_hidden.rowcount()
		if 	dw_hidden.getitemstring(k, 'f_chk') = 'Y' then 
			lrow = dw_prt.insertrow(0)	
			dw_prt.setitem(lrow, 'jijil',			dw_hidden.getitemstring(k, 'c_jijil' ))
			dw_prt.setitem(lrow, 'ispec',		string(dw_hidden.getitemnumber(k, 'thick' ))+'*'+string(dw_hidden.getitemnumber(k, 'width' )))
			dw_prt.setitem(lrow, 'lot_qty',		dw_hidden.getitemnumber(k, 'inqty' ))
			dw_prt.setitem(lrow, 'lotno',		dw_hidden.getitemstring(k, 'lotno' ))
			dw_prt.setitem(lrow, 'coilno',		dw_hidden.getitemstring(k, 'coilno' ))
			dw_prt.setitem(lrow, 'io_date', 	dw_hidden.getitemstring(k, 'indat' ))
			dw_prt.setitem(lrow, 'carcod',		dw_hidden.getitemstring(k, 'carcod' ))
			dw_prt.setitem(lrow, 'barno',		dw_hidden.getitemstring(k, 'c_barno' ))
			dw_prt.setitem(lrow, 'barno2',		dw_hidden.getitemstring(k, 'c_barno' ))
			dw_prt.setitem(lrow, 'barcode',	'*'+dw_hidden.getitemstring(k, 'c_barno' )+'*')
		end if	
	NEXT
	If dw_prt.rowcount() > 0 Then
		OpenWithParm(w_print_preview, dw_prt)
	End If
	dw_hidden.reset()
	Return
End If

lrow = dw_insert.GetRow()
If lrow < 1 Then Return

// 최대순번 채번
sToday = f_today()

SELECT TO_NUMBER(MAX(SUBSTR(LOTNO,9,3)))
   INTO :lseq
  FROM IMHIST_LOT_TH
WHERE LOTNO LIKE :sToday||'%';

If SQLCA.SQLCODE <> 0 Or IsNull(lseq) Then
	lseq = 0
End If

For i = 1 To dw_insert.RowCount()
	sBaljpno = dw_insert.GetItemString(i, 'baljpno')
	lBalseq  = dw_insert.GetItemNumber(i, 'balseq')
	lCoilCnt = dw_insert.GetItemNumber(i, 'poblkt_dyebi2')
	dInqty   = dw_insert.GetItemNumber(i, 'ioqty')
	
	k = 0
	For j = 1 To dw_insert.RowCount()
		If sBaljpno = dw_insert.GetItemString(j, 'baljpno') And &
			lBalseq  = dw_insert.GetItemNumber(j, 'balseq') Then
			k++
			i = j
		End If
	Next

	lseq++
	dw_insert.SetItem(i, 'lotsno', sToday+String(lseq,'000'))
	dw_insert.SetItem(i, 'lot_qty', Round(dInqty / (lCoilCnt * 2), 0))
	
	// 코일수 x 2등분 보다 추가된 행이 작은 경우만
	Do While k < lCoilCnt * 2
		If dw_insert.RowsCopy(i, i, Primary!, dw_insert, i + 1, Primary!) <> 1 Then
			MessageBox('확인', 'Lot 추가 중 오류가 발생 했습니다.')
			Return
		End If
		i++; k++; lseq++
		dw_insert.SetItem(i, 'lotsno', sToday+String(lseq,'000'))
		dw_insert.SetItem(i, 'lot_qty', Round(dInqty / (lCoilCnt * 2), 0))
	Loop
Next

 f_setfocus_dw(dw_insert, 1, 'lotsno')   

end event

type dw_csv from datawindow within w_mat_01350
boolean visible = false
integer x = 3867
integer y = 208
integer width = 736
integer height = 400
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_mat_01350_csv"
boolean border = false
boolean livescroll = true
end type

type dw_hidden from datawindow within w_mat_01350
boolean visible = false
integer x = 4727
integer y = 1008
integer width = 370
integer height = 316
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_mat_01350_imsi_1"
boolean border = false
boolean livescroll = true
end type

type cb_2 from commandbutton within w_mat_01350
integer x = 2720
integer y = 28
integer width = 608
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "LOT 일괄 지정"
end type

event clicked;If dw_ret.GetItemString(1, 'gbn') <> 'I' Then
	MessageBox('확인','등록 모드에서만 일괄 지정이 가능합니다!')
	Return
End If

If dw_insert.RowCount() < 1 Then
	MessageBox('확인','자료를 조회한 후 처리하십시오!')
	Return
End If

If MessageBox('확인','LOT No 및 수량을 입고일자/수량으로 일괄 지정합니다.~r~n계속 진행하시겠습니까?', Question!, Yesno!, 1) = 2 Then Return

Long		i 
String		sLotno

dw_insert.SetRedraw(False)
For i = 1 To dw_insert.RowCount()
	sLotno = Trim(dw_insert.GetItemString(i, 'lotsno'))
	If sLotno > '.' Then Continue
	
	dw_insert.SetItem(i, 'lotsno', dw_insert.GetItemString(i, 'io_date'))
	dw_insert.SetItem(i, 'lot_qty', dw_insert.GetItemNumber(i, 'ioqty'))
Next
dw_insert.SetRedraw(True)
end event

type dw_prt from datawindow within w_mat_01350
boolean visible = false
integer x = 3867
integer y = 96
integer width = 370
integer height = 316
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_mat_01350_label"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

