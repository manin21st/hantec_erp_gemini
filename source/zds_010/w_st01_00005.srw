$PBExportHeader$w_st01_00005.srw
$PBExportComments$차종정보
forward
global type w_st01_00005 from w_inherite
end type
type dw_1 from u_key_enter within w_st01_00005
end type
type rr_1 from roundrectangle within w_st01_00005
end type
end forward

global type w_st01_00005 from w_inherite
string title = "차종코드 등록"
dw_1 dw_1
rr_1 rr_1
end type
global w_st01_00005 w_st01_00005

on w_st01_00005.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_st01_00005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)

p_inq.PostEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_st01_00005
integer x = 69
integer y = 248
integer width = 4448
integer height = 2012
string dataobject = "d_st01_00005_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

type p_delrow from w_inherite`p_delrow within w_st01_00005
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;Long nRow, nCnt, ix
String sCarcode, sCargbn1, sCargbn2
Int    iSeq

If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_insert.GetRow()
If nRow > 0 then
	sCarcode = dw_insert.GetItemString(nRow, 'carcode')
	sCargbn1 = dw_insert.GetItemString(nRow, 'cargbn1')
	sCargbn2 = dw_insert.GetItemString(nRow, 'cargbn2')
	
	SELECT COUNT(*) INTO :nCnt FROM CARMST WHERE CARCODE = :sCarcode AND CARGBN1 = :sCargbn1 AND CARGBN2 = :sCargbn2;
	If nCnt > 0 Then
		MessageBox('확 인','차종정보가 구성되어 삭제하실 수 없습니다.!!')
		Return
	End If
	
	If f_msg_delete() <> 1 Then	REturn
	
	dw_insert.DeleteRow(nRow)
	nCnt = dw_insert.RowCount()
	For ix = nCnt To 1 Step -1
		sCarcode = Trim(dw_insert.GetItemString(ix, 'carcode'))
		If IsNull(sCarcode) Or sCarcode = '' Then
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

type p_addrow from w_inherite`p_addrow within w_st01_00005
integer x = 3749
end type

event p_addrow::clicked;String sCarCode, sCarGbn1, sCarGbn2, sCarnm
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sCarGbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCarGbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'cargbn1', sCargbn1)
dw_insert.SetItem(nRow, 'cargbn2', sCargbn2)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('carcode')
	
end event

type p_search from w_inherite`p_search within w_st01_00005
boolean visible = false
integer x = 2898
integer y = 172
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_st01_00005
boolean visible = false
integer x = 3406
integer y = 212
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_st01_00005
end type

type p_can from w_inherite`p_can within w_st01_00005
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
dw_1.SetItem(1, 'carcode', sNull)
dw_1.SetItem(1, 'carNM', sNull)
end event

type p_print from w_inherite`p_print within w_st01_00005
boolean visible = false
integer x = 3072
integer y = 208
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_st01_00005
boolean visible = false
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sGbn1, sGbn2

If dw_1.AcceptText() <> 1 Then Return

sGbn1	= Trim(dw_1.GetItemString(1,'cargbn1'))
sGbn2	= Trim(dw_1.GetItemString(1,'cargbn2'))

dw_insert.Retrieve(sGbn1, sGbn2)

If sGbn1 = 'E' Then
	dw_insert.Object.carcode_t.text	=	'차종코드'
	dw_insert.Object.carnm_t.text	=	'차종명'
Else
	dw_insert.Object.carcode_t.text	=	'기종코드'
	dw_insert.Object.carnm_t.text	=	'기종명'	
End If

end event

type p_del from w_inherite`p_del within w_st01_00005
boolean visible = false
integer x = 4114
integer y = 232
end type

type p_mod from w_inherite`p_mod within w_st01_00005
integer x = 4096
end type

event p_mod::clicked;Long ix, nrow, nCnt
String sCarcode

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.RowCount() <= 0 Then Return

nCnt = dw_insert.RowCount()
For ix = nCnt To 1 Step -1
	sCarcode = Trim(dw_insert.GetItemString(ix, 'carcode'))
	If IsNull(sCarcode) Or sCarcode = '' Then
		dw_insert.DeleteRow(ix)
	End If
Next
	
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

MessageBox('확 인','저장하였습니다.!!')

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_st01_00005
end type

type cb_mod from w_inherite`cb_mod within w_st01_00005
end type

type cb_ins from w_inherite`cb_ins within w_st01_00005
end type

type cb_del from w_inherite`cb_del within w_st01_00005
end type

type cb_inq from w_inherite`cb_inq within w_st01_00005
end type

type cb_print from w_inherite`cb_print within w_st01_00005
end type

type st_1 from w_inherite`st_1 within w_st01_00005
end type

type cb_can from w_inherite`cb_can within w_st01_00005
end type

type cb_search from w_inherite`cb_search within w_st01_00005
end type







type gb_button1 from w_inherite`gb_button1 within w_st01_00005
end type

type gb_button2 from w_inherite`gb_button2 within w_st01_00005
end type

type dw_1 from u_key_enter within w_st01_00005
boolean visible = false
integer x = 55
integer y = 56
integer width = 978
integer height = 160
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_st01_00005_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;Long ix, nrow
String sCarcode, sCargbn1, sCargbn2, sCarnm, sTemp

Choose Case GetColumnName()
	Case 'cargbn1'
		sCargbn1 = Trim(GetText())
		
		// 차종이 아닌경우 '기타'로 설정
		If sCargbn1 <> 'E' Then
			SetItem(1, 'cargbn2','9')
		Else
			SetItem(1, 'cargbn2','E')
		End If
End Choose

p_inq.PostEvent(Clicked!)
end event

event rbuttondown;call super::rbuttondown;
Choose Case GetColumnName()
	Case 'carcode'
		Open(w_carmst_popup)
		If isNull(gs_code) Then Return
		
		SetItem(1, 'carcode', gs_code)
		TriggerEvent(ItemChanged!)
End Choose
end event

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_st01_00005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 236
integer width = 4471
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

