$PBExportHeader$w_st01_00015.srw
$PBExportComments$차종정보
forward
global type w_st01_00015 from w_inherite
end type
type dw_1 from u_key_enter within w_st01_00015
end type
type rr_1 from roundrectangle within w_st01_00015
end type
end forward

global type w_st01_00015 from w_inherite
string title = "차종정보 등록"
dw_1 dw_1
rr_1 rr_1
end type
global w_st01_00015 w_st01_00015

on w_st01_00015.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_st01_00015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)
end event

type dw_insert from w_inherite`dw_insert within w_st01_00015
integer x = 69
integer y = 320
integer width = 4448
integer height = 1940
string dataobject = "d_st01_00015_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::clicked;call super::clicked;
If row > 0 then
	selectrow(0,false)
	selectrow(row, true)
else
	selectrow(0,false)
end if
end event

type p_delrow from w_inherite`p_delrow within w_st01_00015
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;Long nRow, nCnt
String sCarcode, sCargbn1, sCargbn2
Int    iSeq

If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_insert.GetRow()
If nRow > 0 then
	sCarcode = dw_insert.GetItemString(nRow, 'carcode')
	sCargbn1 = dw_insert.GetItemString(nRow, 'cargbn1')
	sCargbn2 = dw_insert.GetItemString(nRow, 'cargbn2')
	iSeq     = dw_insert.GetItemNumber(nRow, 'seq')
	
	SELECT COUNT(*) INTO :nCnt FROM CARBOM
	 WHERE CARCODE = :sCarcode AND SEQ = :iSeq
	   AND CARGBN1 = :sCargbn1 AND CARGBN2 = :sCargbn2;
	If nCnt > 0 Then
		MessageBox('확 인','차종구성이 이미 되어 있어 삭제하실 수 없습니다.!!')
		Return
	End If
	
	If f_msg_delete() <> 1 Then	REturn
	
	dw_insert.DeleteRow(nRow)
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_st01_00015
integer x = 3749
end type

event p_addrow::clicked;String sCarCode, sCarGbn1, sCarGbn2
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sCarCode = Trim(dw_1.GetItemString(1, 'carcode'))
sCarGbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCarGbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))

// 차종
If sCargbn1 = 'E' Or sCargbn1 = 'C' Or sCargbn1 = '0' Or sCargbn1 = '1' Then
	If IsNull(sCarCode) Or sCarCode = '' Then
		f_message_chk(1400,'')
		Return
	End If
	
	nRow = dw_insert.InsertRow(0)
	dw_insert.SetItem(nRow, 'carcode', sCarCode)
	dw_insert.SetItem(nRow, 'cargbn1', sCargbn1)
	dw_insert.SetItem(nRow, 'cargbn2', sCargbn2)
	dw_insert.SetItem(nRow, 'engcd',   'N') // 적용제외 유무
	
	dMax = dw_insert.GetItemNumber(1, 'maxseq')
	If IsNull(dMax) then dMax = 0
	dMax += 1
	dw_insert.SetItem(nRow, 'seq', dMax)
End If

// Style Code
If sCargbn1 = '4' Then
	nRow = dw_insert.InsertRow(0)
	dw_insert.SetItem(nRow, 'seq', 1)
End If

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn(2)
	
end event

type p_search from w_inherite`p_search within w_st01_00015
boolean visible = false
integer x = 2898
integer y = 172
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_st01_00015
boolean visible = false
integer x = 3406
integer y = 212
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_st01_00015
end type

type p_can from w_inherite`p_can within w_st01_00015
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
dw_1.SetItem(1, 'carcode', sNull)
dw_1.SetItem(1, 'carNM', sNull)
end event

type p_print from w_inherite`p_print within w_st01_00015
boolean visible = false
integer x = 3072
integer y = 208
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_st01_00015
boolean visible = false
integer y = 208
end type

event p_inq::clicked;call super::clicked;String sGbn1, sGbn2, sCode

If dw_1.AcceptText() <> 1 Then Return

sGbn1	= Trim(dw_1.GetItemString(1,'cargbn1'))
sGbn2	= Trim(dw_1.GetItemString(1,'cargbn2'))
sCode	= Trim(dw_1.GetItemString(1,'carcode'))

Choose Case sGbn1
	// 현대/기아/CKD
	Case 'E', 'C'
		Choose Case sGbn2
			// 엔진
			Case 'E'
				dw_insert.DataObject = 'd_st01_00015_a'
			// 미션
			Case 'T','M'
				dw_insert.DataObject = 'd_st01_00015_b'
			// 의장
			Case 'D'
				dw_insert.DataObject = 'd_st01_00015_c'
			// 기종
			Case '9'
				dw_insert.DataObject = 'd_st01_00015_d'
		End Choose
	Case Else
		dw_insert.DataObject = 'd_st01_00015_d'
End Choose
dw_insert.SetTransObject(sqlca)

dw_insert.Retrieve(sCode, sGbn1, sGbn2)

end event

type p_del from w_inherite`p_del within w_st01_00015
boolean visible = false
integer x = 4114
integer y = 232
end type

type p_mod from w_inherite`p_mod within w_st01_00015
integer x = 4096
end type

event p_mod::clicked;Long ix, nrow

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.RowCount() <= 0 Then Return

If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

MessageBox('확 인','저장하였습니다.!!')

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_st01_00015
end type

type cb_mod from w_inherite`cb_mod within w_st01_00015
end type

type cb_ins from w_inherite`cb_ins within w_st01_00015
end type

type cb_del from w_inherite`cb_del within w_st01_00015
end type

type cb_inq from w_inherite`cb_inq within w_st01_00015
end type

type cb_print from w_inherite`cb_print within w_st01_00015
end type

type st_1 from w_inherite`st_1 within w_st01_00015
end type

type cb_can from w_inherite`cb_can within w_st01_00015
end type

type cb_search from w_inherite`cb_search within w_st01_00015
end type







type gb_button1 from w_inherite`gb_button1 within w_st01_00015
end type

type gb_button2 from w_inherite`gb_button2 within w_st01_00015
end type

type dw_1 from u_key_enter within w_st01_00015
integer x = 55
integer y = 56
integer width = 3159
integer height = 180
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_st01_00015_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;Long ix, nrow
String sCarcode, sCargbn1, sCargbn2, sCarnm, sTemp, sNull

SetNull(sNull)

Choose Case GetColumnName()
	Case 'cargbn1'
		sCargbn1 = GetText()
		
		// 차종이 아닌경우 '기타'로 설정
		If (sCargbn1 <> 'E' And sCargbn1 <> 'C' ) Then
			SetItem(1, 'cargbn2','9')
		Else
			SetItem(1, 'cargbn2','E')
		End If
		
		dw_insert.Reset()
		
		SetItem(1, 'carcode', sNull)
		SetItem(1, 'carnm', sNull)
	Case 'cargbn2'
		dw_insert.Reset()
		
		SetItem(1, 'carcode', sNull)
		SetItem(1, 'carnm', sNull)
	Case 'carcode'
		
		dw_insert.Reset()
		
		sCarCode = Trim(GetText())
		If IsNull(sCarCode) Or sCarCode = '' Then
			Return
		End If
		
		sCargbn1 = GetItemString(1, 'cargbn1')
		sCargbn2 = GetItemString(1, 'cargbn2')
		
		SELECT CARNM INTO :sCarnm  FROM CARHEAD
		 WHERE CARCODE = :sCarcode
		   AND CARGBN1 = :sCargbn1
			AND CARGBN2 = :sCargbn2;
		 
		If sqlca.sqlcode = 0 Then
			SetItem(1, 'carnm',   sCarNm)
			
			p_inq.PostEvent(Clicked!)
		Else
			MessageBox('확 인', '등록되지 않은 코드입니다.')
			Return 1
		End If
End Choose
end event

event rbuttondown;call super::rbuttondown;
Choose Case GetColumnName()
	Case 'carcode'
		gs_codename  = GetItemString(1, 'cargbn1')
		gs_codename2 = GetItemString(1, 'cargbn2')
		Open(w_carhead_popup)
		If isNull(gs_code) Then Return
		
		SetItem(1, 'carcode', gs_code)
		SetItem(1, 'cargbn1', gs_codename)
		SetItem(1, 'cargbn2', gs_codename2)
		TriggerEvent(ItemChanged!)
End Choose
end event

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_st01_00015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 312
integer width = 4471
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

