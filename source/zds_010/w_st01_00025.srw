$PBExportHeader$w_st01_00025.srw
$PBExportComments$차종구성
forward
global type w_st01_00025 from w_inherite
end type
type rb_item from radiobutton within w_st01_00025
end type
type rb_car from radiobutton within w_st01_00025
end type
type dw_3 from u_key_enter within w_st01_00025
end type
type gb_1 from groupbox within w_st01_00025
end type
type dw_insert2 from u_key_enter within w_st01_00025
end type
type dw_1 from u_key_enter within w_st01_00025
end type
type dw_2 from u_key_enter within w_st01_00025
end type
end forward

global type w_st01_00025 from w_inherite
string title = "차종구성 등록"
string pointer = "SizeWE!"
rb_item rb_item
rb_car rb_car
dw_3 dw_3
gb_1 gb_1
dw_insert2 dw_insert2
dw_1 dw_1
dw_2 dw_2
end type
global w_st01_00025 w_st01_00025

forward prototypes
public function integer wf_set_datawinow ()
public function integer wf_insert_gita (string arg_carcode, integer arg_seq, string arg_cargbn1, string arg_cargbn2, string arg_itnbr)
end prototypes

public function integer wf_set_datawinow ();String sCargbn1, sCargbn2, sItnbr
Long   nRow

If dw_3.AcceptText() <> 1 Then Return -1

sCargbn1	= dw_3.GetItemString(1, 'cargbn1')
sCargbn2	= dw_3.GetItemString(1, 'cargbn2')

// 품목별 차종등록인 경우
If rb_item.Checked Then		
	// 현대/lg/대림인 경우
	If sCargbn1 = 'E' Or sCargbn1 = 'C' Or sCargbn1 = '0' Or sCargbn1 = '1' Then	
		dw_1.Visible = False
		dw_2.Visible = True
		
		dw_insert.Visible  = False
		dw_insert2.Visible = True
	// 기타인 경우
	ElseIf sCargbn1 = '9'  Then
		dw_1.Visible = False
		dw_2.Visible = True
		
		dw_insert.Visible  = True
		dw_insert2.Visible = False
	End If
	
	nRow = dw_2.GetSelectedRow(0)
	If nRow > 0 Then
		sItnbr	= dw_2.GetItemString(nRow, 'itnbr')
		dw_insert2.Retrieve(sCargbn1, sCargbn2, sItnbr)
	Else
		dw_insert2.Reset()
	End If
End If


// 차종별 품목등록인 경우
If rb_car.Checked Then
	dw_1.Visible = True
	dw_2.Visible = False

	dw_insert.Visible  = True
	dw_insert2.Visible = False
	
	// 미션인 경우 계열/기종 미입력된 자료는 조회하지 않는다
	If sCargbn2 = 'T' Or sCargbn2 = 'M' Then
		dw_1.SetFilter("not ( ISNULL( snm8e ) or ISNULL( snm8e ) )")
	Else
		dw_1.SetFilter("")
	End If
		
	dw_1.Retrieve(sCargbn1, sCargbn2)
End If

Return 0
end function

public function integer wf_insert_gita (string arg_carcode, integer arg_seq, string arg_cargbn1, string arg_cargbn2, string arg_itnbr);Long	 nRow

// 품목별 차종등록인 경우 제외
If rb_car.Checked Then Return -1

If dw_insert.AcceptText() <> 1 Then Return -1

// 기존자료 저장
p_mod.TriggerEvent(Clicked!)

// 조회
dw_insert.Retrieve(arg_carcode, arg_seq, arg_cargbn1, arg_cargbn2)

nRow = dw_insert.Find("itnbr = '" + arg_itnbr +"'", 1, dw_insert.RowCount())
If nRow > 0 Then
//	MessageBox('확 인','기등록된 품번입니다.!!')
	dw_insert.SetRow(nRow)
	dw_insert.ScrollToRow(nRow)
	dw_insert.SelectRow(0,false)
	dw_insert.SelectRow(nRow,true)
	Return -1
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'carcode', arg_carcode)
dw_insert.SetItem(nRow, 'seq',     arg_seq)
dw_insert.SetItem(nRow, 'cargbn1', arg_cargbn1)
dw_insert.SetItem(nRow, 'cargbn2', arg_cargbn2)
dw_insert.SetItem(nRow, 'itnbr',   arg_itnbr)

dw_insert.SelectRow(0,false)
dw_insert.SelectRow(nRow,true)
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('usage')
dw_insert.SetFocus()

Return 1
end function

on w_st01_00025.create
int iCurrent
call super::create
this.rb_item=create rb_item
this.rb_car=create rb_car
this.dw_3=create dw_3
this.gb_1=create gb_1
this.dw_insert2=create dw_insert2
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_item
this.Control[iCurrent+2]=this.rb_car
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_insert2
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_2
end on

on w_st01_00025.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_item)
destroy(this.rb_car)
destroy(this.dw_3)
destroy(this.gb_1)
destroy(this.dw_insert2)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)

dw_3.InsertRow(0)

dw_1.Retrieve('E','E')
dw_2.Retrieve()

Post wf_set_datawinow()
end event

type dw_insert from w_inherite`dw_insert within w_st01_00025
boolean visible = false
integer x = 1778
integer y = 376
integer width = 2825
integer height = 1876
integer taborder = 160
string dataobject = "d_st01_00025_4"
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;call super::itemchanged;string  snull, sitnbr, sitdsc, sispec, sjijil, sispec_code
integer ireturn
long    lrow

lrow = this.getrow()

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())

	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	RETURN ireturn
END IF
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(lrow,"itnbr",gs_code)
	this.SetItem(lrow,"itdsc",gs_codename)
	Return 1
END IF
end event

event dw_insert::buttonclicked;call super::buttonclicked;//업체별 할당량 입력
string sItnbr, sItdsc, sCargbn1
Long   nRow
st_carmst lstcmt

sCargbn1 = dw_3.GetItemString(1, 'cargbn1')

/* 기타인 경우 */
If sCargbn1 = '9' Then
	lstcmt.carcode = GetItemString(Row, 'carcode')
	lstcmt.seq		= GetItemNumber(Row, 'seq')
	lstcmt.cargbn1 = GetItemString(Row, 'cargbn1')
	lstcmt.cargbn2 = GetItemString(Row, 'cargbn2')
	lstcmt.itnbr	= GetItemString(row, 'itnbr')
Else
	nRow = dw_1.GetSelectedRow(0)
	If nRow <= 0 Then Return
	
	lstcmt.carcode = dw_1.GetItemString(nRow, 'carcode')
	lstcmt.seq		= dw_1.GetItemNumber(nRow, 'seq')
	lstcmt.cargbn1 = dw_1.GetItemString(nRow, 'cargbn1')
	lstcmt.cargbn2 = dw_1.GetItemString(nRow, 'cargbn2')
	lstcmt.itnbr	= GetItemString(row, 'itnbr')
End If

OpenWithParm(w_st01_00020_popup, lstcmt)
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	SelectRow(0, false)
	SelectRow(row, true)
	SetRow(row)
Else
	SelectRow(0, false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_st01_00025
integer x = 3922
integer taborder = 90
end type

event p_delrow::clicked;call super::clicked;Long nRow, nCnt, ix
String sItnbr

// 품목별 차종등록인 경우 제외
If rb_item.Checked Then Return

nRow = dw_insert.GetRow()
If nRow > 0 then
	If f_msg_delete() <> 1 Then	REturn
	
	dw_insert.DeleteRow(nRow)
	nCnt = dw_insert.RowCount()
	For ix = nCnt To 1 Step -1
		sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
		If IsNull(sItnbr) Or sItnbr = '' Then
			dw_insert.DeleteRow(ix)
		End If
	Next
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_st01_00025
integer x = 3749
integer taborder = 80
end type

event p_addrow::clicked;String sCarCode, sCarGbn1, sCarGbn2, sItnbr
Long	 nRow, dSeq

// 품목별 차종등록인 경우 제외
If rb_item.Checked Then Return

If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_1.GetSelectedRow(0)
If nRow <= 0 Then Return

sCarCode = Trim(dw_1.GetItemString(nRow, 'carcode'))
dSeq     = dw_1.GetItemNumber(nrow, 'seq')
sCargbn1 = Trim(dw_1.GetItemString(nRow, 'cargbn1'))
sCargbn2 = Trim(dw_1.GetItemString(nRow, 'cargbn2'))

If IsNull(sCarCode) Or sCarCode = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_insert.RowCount()
If nRow > 0 Then
	sItnbr = Trim(dw_insert.GetItemString(nRow, 'itnbr'))
	If IsNull(sItnbr) Or sItnbr = '' Then
		f_message_chk(1400,'[제품코드]')
		Return
	End If
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'carcode', sCarCode)
dw_insert.SetItem(nRow, 'seq',     dseq)
dw_insert.SetItem(nRow, 'cargbn1', sCargbn1)
dw_insert.SetItem(nRow, 'cargbn2', sCargbn2)
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

end event

type p_search from w_inherite`p_search within w_st01_00025
boolean visible = false
integer y = 76
integer taborder = 140
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_st01_00025
boolean visible = false
integer x = 3447
integer y = 68
integer taborder = 70
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_st01_00025
integer taborder = 130
end type

type p_can from w_inherite`p_can within w_st01_00025
integer taborder = 120
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
dw_insert2.Reset()

end event

type p_print from w_inherite`p_print within w_st01_00025
boolean visible = false
integer x = 3072
integer y = 88
integer taborder = 150
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_st01_00025
boolean visible = false
integer x = 3259
integer y = 92
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_st01_00025
boolean visible = false
integer x = 2674
integer y = 92
integer taborder = 110
end type

type p_mod from w_inherite`p_mod within w_st01_00025
integer x = 4096
integer taborder = 100
end type

event p_mod::clicked;Long ix, nCnt, nRow
String sItnbr, sCargbn1, sCargbn2, sCarcode, sGubun
Dec    dSeq, dUsage, dMax

SetPointer(HourGlass!)

If dw_3.AcceptText() <> 1 Then Return

sGubun = dw_3.GetItemString(1, 'cargbn1')

// 품목별 차종등록인 경우
If rb_item.Checked And sGubun <> '9' Then
	If dw_insert2.AcceptText() <> 1 Then Return
	
	If dw_insert2.RowCount() <= 0 Then Return	

	nRow = dw_2.GetSelectedRow(0)
	If nRow <= 0 Then REturn
	
	sItnbr = dw_2.GetItemString(nRow, 'itnbr')
	
	For ix = 1 To dw_insert2.RowCount()
		sCarcode = dw_insert2.GetItemString(ix, 'carcode')
		dseq		= dw_insert2.GetItemNumber(ix, 'seq')
		sCargbn1	= dw_insert2.GetItemString(ix, 'cargbn1')
		sCargbn2 = dw_insert2.GetItemString(ix, 'cargbn2')
		dUsage   = dw_insert2.GetItemNumber(ix, 'usage')
		If IsNull(dUsage) Then dUsage = 0
		
		DELETE FROM CARBOM
		 WHERE CARCODE = :sCarcode AND SEQ = :dSeq AND ITNBR = :sItnbr AND CARGBN1 = :sCargbn1 AND CARGBN2 = :sCargbn2;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
			ROLLBACK;
			return
		End If
		
		SELECT MAX(SEQ) INTO :dMax FROM CARBOM
		 WHERE CARCODE = :sCarcode AND SEQ = :dSeq AND CARGBN1 = :sCargbn1 AND CARGBN2 = :sCargbn2;
		If IsNull(dMax) Then dMax = 0
		
		If dUsage <> 0 Then
			INSERT INTO CARBOM ( CARCODE, SEQ, CARGBN1, CARGBN2, ITNBR, USAGE)
			 VALUES ( :sCarcode, :dseq, :scargbn1, :scargbn2, :sItnbr, :dusage );
			If SQLCA.SQLCODE <> 0 Then
				MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
				ROLLBACK;
				return
			End If
		End If
	Next
	COMMIT;
	
	MessageBox('확인','저장하였습니다')
	
	Return
End If

// 차종별 품목등록인 경우/품목별 차종등록인데 기타인 경우
If rb_car.Checked Or sGubun = '9' Then
	If dw_1.AcceptText() <> 1 Then Return
	If dw_insert.AcceptText() <> 1 Then Return
	
	If dw_1.Update() <> 1 Then
		RollBack;
		Return
	End If
		
	If dw_insert.RowCount() > 0 Then		
		nCnt = dw_insert.RowCount()
		For ix = nCnt To 1 Step -1
			sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
			If IsNull(sItnbr) Or sItnbr = '' Then
				dw_insert.DeleteRow(ix)
			End If
			
			dUsage = dw_insert.GetItemNumber(ix, 'usage')
			If IsNull(dUsage) Or dUsage = 0 Then
				dw_insert.DeleteRow(ix)
			End If
		Next
		
		If dw_insert.Update() <> 1 Then
			RollBack;
			Return
		End IF	
	End If
	
	COMMIT;
	MessageBox('확인','저장하였습니다')
End If

end event

type cb_exit from w_inherite`cb_exit within w_st01_00025
end type

type cb_mod from w_inherite`cb_mod within w_st01_00025
end type

type cb_ins from w_inherite`cb_ins within w_st01_00025
end type

type cb_del from w_inherite`cb_del within w_st01_00025
end type

type cb_inq from w_inherite`cb_inq within w_st01_00025
end type

type cb_print from w_inherite`cb_print within w_st01_00025
end type

type st_1 from w_inherite`st_1 within w_st01_00025
end type

type cb_can from w_inherite`cb_can within w_st01_00025
end type

type cb_search from w_inherite`cb_search within w_st01_00025
end type







type gb_button1 from w_inherite`gb_button1 within w_st01_00025
end type

type gb_button2 from w_inherite`gb_button2 within w_st01_00025
end type

type rb_item from radiobutton within w_st01_00025
integer x = 128
integer y = 76
integer width = 494
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품목별 차종등록"
boolean checked = true
end type

event clicked;Post wf_set_datawinow()
end event

type rb_car from radiobutton within w_st01_00025
integer x = 727
integer y = 76
integer width = 494
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차종별 품목등록"
end type

event clicked;Post wf_set_datawinow()
end event

type dw_3 from u_key_enter within w_st01_00025
integer x = 69
integer y = 192
integer width = 3835
integer height = 144
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_st01_00025_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;Long ix, nrow
String sCarcode, sCargbn1, sCargbn2, sCarnm, sTemp, sNull

SetNull(sNull)

Choose Case GetColumnName()
	Case 'cargbn1'
		sCargbn1 = GetText()
		
		// 차종이 아닌경우 '기타'로 설정
		If ( sCargbn1 <> 'E' And sCargbn1 <> 'C' ) Then
			SetItem(1, 'cargbn2','9')
		Else
			SetItem(1, 'cargbn2','E')
		End If
End Choose

Post wf_set_datawinow()
end event

type gb_1 from groupbox within w_st01_00025
integer x = 69
integer y = 8
integer width = 1248
integer height = 156
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "작업구분"
end type

type dw_insert2 from u_key_enter within w_st01_00025
integer x = 1778
integer y = 376
integer width = 2825
integer height = 1876
integer taborder = 60
string dataobject = "d_st01_00025_3"
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;call super::itemchanged;String sItnbr, sCargbn1, sCargbn2, sCarcode
Long   nRow, dseq, dMax
Dec    dUsage

//nRow = dw_2.GetSelectedRow(0)
//If nRow <= 0 Then REturn
//
//sItnbr = dw_2.GetItemString(nRow, 'itnbr')
//sCarcode = GetItemString(row, 'carcode')
//dseq		= GetItemNumber(row, 'seq')
//sCargbn1	= GetItemString(row, 'cargbn1')
//sCargbn2 = GetItemString(row, 'cargbn2')
//dUsage   = GetItemNumber(row, 'usage')
//If IsNull(dUsage) Then dUsage = 0
//
//DELETE FROM CARBOM
// WHERE CARCODE = :sCarcode AND SEQ = :dSeq AND ITNBR = :sItnbr AND CARGBN1 = :sCargbn1 AND CARGBN2 = :sCargbn2;
//If SQLCA.SQLCODE <> 0 Then
//	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
//	ROLLBACK;
//	return
//End If
//
//SELECT MAX(SEQ) INTO :dMax FROM CARBOM
// WHERE CARCODE = :sCarcode AND SEQ = :dSeq AND CARGBN1 = :sCargbn1 AND CARGBN2 = :sCargbn2;
//If IsNull(dMax) Then dMax = 0
//
//INSERT INTO CARBOM ( CARCODE, SEQ, CARGBN1, CARGBN2, ITNBR, USAGE)
// VALUES ( :sCarcode, :dseq, :scargbn1, :scargbn2, :sItnbr, :dusage );
//If SQLCA.SQLCODE <> 0 Then
//	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
//	ROLLBACK;
//	return
//End If
//
//COMMIT;

end event

event buttonclicked;call super::buttonclicked;//업체별 할당량 입력
string sItnbr, sItdsc
Long   nRow
st_carmst lstcmt

nRow = dw_2.GetSelectedRow(0)
If nRow <= 0 Then Return

lstcmt.carcode = GetItemString(row, 'carcode')
lstcmt.seq		= GetItemNumber(row, 'seq')
lstcmt.cargbn1 = GetItemString(row, 'cargbn1')
lstcmt.cargbn2 = GetItemString(row, 'cargbn2')
lstcmt.itnbr	= dw_2.GetItemString(nRow, 'itnbr')

OpenWithParm(w_st01_00020_popup, lstcmt)
end event

event clicked;call super::clicked;
If row > 0 Then
	SelectRow(0, false)
	SelectRow(row, true)
	SetRow(row)
Else
	SelectRow(0, false)
End If
end event

type dw_1 from u_key_enter within w_st01_00025
boolean visible = false
integer x = 69
integer y = 376
integer width = 1701
integer height = 1876
integer taborder = 30
string dataobject = "d_st01_00020_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String sCode, sCargbn1, sCargbn2
Long   dSeq

If row > 0 Then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	sCode = GetItemString(row, 'carcode')
	sCargbn1= GetItemString(row, 'cargbn1')
	sCargbn2= GetItemString(row, 'cargbn2')
	dSeq  = GetItemNumber(row, 'seq')
	
//	p_mod.TriggerEvent(Clicked!)
	
	dw_insert.Retrieve(sCode, dSeq, sCargbn1, sCargbn2)
Else
	This.SelectRow(0, FALSE)
End If
end event

event rowfocuschanged;call super::rowfocuschanged;String sCode, sCargbn1, sCargbn2
Long   dSeq

If currentrow > 0 Then
	This.SelectRow(0, FALSE)
	This.SelectRow(currentrow, TRUE)
	sCode = GetItemString(currentrow, 'carcode')
	sCargbn1= GetItemString(currentrow, 'cargbn1')
	sCargbn2= GetItemString(currentrow, 'cargbn2')
	dSeq  = GetItemNumber(currentrow, 'seq')
	
//	p_mod.TriggerEvent(Clicked!)
	
	dw_insert.Retrieve(sCode, dSeq, sCargbn1, sCargbn2)
Else
	This.SelectRow(0, FALSE)
End If
end event

type dw_2 from u_key_enter within w_st01_00025
integer x = 69
integer y = 376
integer width = 1701
integer height = 1876
integer taborder = 40
string dataobject = "d_st01_00025_2"
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;//String sCargbn1, sCargbn2, sItnbr
//
//If row > 0 Then
//	This.SelectRow(0, FALSE)
//	This.SelectRow(row, TRUE)
//	
//	sCargbn1	= dw_3.GetItemString(1, 'cargbn1')
//	sCargbn2	= dw_3.GetItemString(1, 'cargbn2')
//	sItnbr = GetItemString(row, 'itnbr')
//	
//	// 기타인 경우 INSERTROW
//	If sCargbn1 = '9' Then
//		Post wf_insert_gita('......', 1, sCargbn1, sCargbn2, sItnbr)
//	Else
//		// 미션인 경우 계열/기종 미입력된 자료는 조회하지 않는다
//		If sCargbn2 = 'T' Or sCargbn2 = 'M' Then
//			dw_insert2.SetFilter("not ( ISNULL( scd8e ) or ISNULL( scd8e ) )")
//		Else
//			dw_insert2.SetFilter("")
//		End If
//		dw_insert2.Filter()
//		dw_insert2.Retrieve(sCargbn1, sCargbn2, sItnbr)
//	End If
//Else
//	This.SelectRow(0, FALSE)
//End If
end event

event rowfocuschanged;call super::rowfocuschanged;String sCargbn1, sCargbn2, sItnbr

If currentrow > 0 Then
	This.SelectRow(0, FALSE)
	This.SelectRow(currentrow, TRUE)
	
	sCargbn1	= dw_3.GetItemString(1, 'cargbn1')
	sCargbn2	= dw_3.GetItemString(1, 'cargbn2')
	sItnbr = GetItemString(currentrow, 'itnbr')
	
	// 기타인 경우 INSERTROW
	If sCargbn1 = '9' Then
		Post wf_insert_gita('......', 1, sCargbn1, sCargbn2, sItnbr)
	Else
		// 미션인 경우 계열/기종 미입력된 자료는 조회하지 않는다
		If sCargbn2 = 'T' Or sCargbn2 = 'M' Then
			dw_insert2.SetFilter("not ( ISNULL( scd8e ) or ISNULL( scd8e ) )")
		Else
			dw_insert2.SetFilter("")
		End If
		dw_insert2.Filter()
		dw_insert2.Retrieve(sCargbn1, sCargbn2, sItnbr)
	End If
Else
	This.SelectRow(0, FALSE)
End If
end event

