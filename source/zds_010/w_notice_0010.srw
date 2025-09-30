$PBExportHeader$w_notice_0010.srw
$PBExportComments$공지사항
forward
global type w_notice_0010 from w_inherite
end type
type dw_1 from u_key_enter within w_notice_0010
end type
type dw_list from datawindow within w_notice_0010
end type
type rr_1 from roundrectangle within w_notice_0010
end type
type rr_2 from roundrectangle within w_notice_0010
end type
type rr_3 from roundrectangle within w_notice_0010
end type
type mle_1 from multilineedit within w_notice_0010
end type
end forward

global type w_notice_0010 from w_inherite
integer width = 4667
integer height = 2492
string title = "공지사항"
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
mle_1 mle_1
end type
global w_notice_0010 w_notice_0010

on w_notice_0010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_3
this.Control[iCurrent+6]=this.mle_1
end on

on w_notice_0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.mle_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)

dw_1.SetItem(1, 'beforedate', '1')
dw_1.SetItem(1, 'saupj', gs_saupj)
dw_1.SetItem(1, 'title', '')


p_ins.TriggerEvent(Clicked!) //추가버튼
p_inq.TriggerEvent(Clicked!) //조회버튼
end event

event key;// 상속 안받음  
end event

type dw_insert from w_inherite`dw_insert within w_notice_0010
integer x = 2048
integer y = 244
integer width = 2569
integer height = 2028
string dataobject = "d_notice_e_30"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::clicked;call super::clicked;//
//If row > 0 then
//	selectrow(0,false)
//	selectrow(row, true)
//else
//	selectrow(0,false)
//end if
end event

type p_delrow from w_inherite`p_delrow within w_notice_0010
boolean visible = false
integer x = 4357
integer y = 256
boolean enabled = false
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

type p_addrow from w_inherite`p_addrow within w_notice_0010
boolean visible = false
integer x = 4183
integer y = 256
boolean enabled = false
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

type p_search from w_inherite`p_search within w_notice_0010
boolean visible = false
integer x = 3813
integer y = 268
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_notice_0010
integer x = 3735
end type

event p_ins::clicked;call super::clicked;dw_insert.reset()
dw_insert.InsertRow(0)

dw_insert.SetItem(1, 'chg_id', gs_saupj)
dw_insert.SetItem(1, 'cre_id', gs_empno)
dw_insert.SetItem(1, 'cre_dt', f_today()+f_totime())


mle_1.text = ''	
end event

type p_exit from w_inherite`p_exit within w_notice_0010
end type

type p_can from w_inherite`p_can within w_notice_0010
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()


p_inq.TriggerEvent(Clicked!) //조회버튼

mle_1.text = ''	
p_ins.TriggerEvent(Clicked!) //추가버튼
end event

type p_print from w_inherite`p_print within w_notice_0010
boolean visible = false
integer x = 3995
integer y = 264
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_notice_0010
integer x = 3557
end type

event p_inq::clicked;call super::clicked;String sbeforedate, ssaupj, stitle, sfrom, sto

If dw_1.AcceptText() <> 1 Then Return

sbeforedate	= Trim(dw_1.GetItemString(1,'beforedate'))
ssaupj	= Trim(dw_1.GetItemString(1,'saupj'))
stitle	= Trim(dw_1.GetItemString(1,'title'))

If sbeforedate = '0' Then
	sfrom = '20110101'
Else
	sfrom = f_aftermonth(Left(f_today(),6),-integer(sbeforedate)) + '01'	
End if

sto = f_today()

If IsNull(stitle) OR stitle = '' Then 
	stitle = '%'
Else
	stitle = stitle + '%'
End if

dw_list.Retrieve(sfrom, sto, stitle, ssaupj)

end event

type p_del from w_inherite`p_del within w_notice_0010
integer x = 4091
end type

event p_del::clicked;call super::clicked;
If f_msg_delete() <> 1 Then	REturn

dw_insert.DeleteRow(dw_insert.GetRow())

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If
Commit;

mle_1.text = ''
	
p_can.TriggerEvent(Clicked!) //취소버튼
p_ins.TriggerEvent(Clicked!) //추가버튼
end event

type p_mod from w_inherite`p_mod within w_notice_0010
integer x = 3913
end type

event p_mod::clicked;Long ix, nrow, lno
String ls_no

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.RowCount() <= 0 Then Return

dw_insert.SetItem(dw_insert.Getrow(), 'content', mle_1.text)
ls_no = dw_insert.GetItemString(dw_insert.Getrow(), 'no')

IF IsNull(ls_no) or ls_no = '' then
	select nvl(max(to_number(no)),0)+1 into :lno 
	from erp_notice;
	
	dw_insert.SetItem(dw_insert.Getrow(), 'no', String(lno))
End if	

If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

MessageBox('확 인','저장하였습니다.!!')

ib_any_typing = False


p_inq.TriggerEvent(Clicked!) //조회버튼
end event

type cb_exit from w_inherite`cb_exit within w_notice_0010
end type

type cb_mod from w_inherite`cb_mod within w_notice_0010
end type

type cb_ins from w_inherite`cb_ins within w_notice_0010
end type

type cb_del from w_inherite`cb_del within w_notice_0010
end type

type cb_inq from w_inherite`cb_inq within w_notice_0010
end type

type cb_print from w_inherite`cb_print within w_notice_0010
end type

type st_1 from w_inherite`st_1 within w_notice_0010
end type

type cb_can from w_inherite`cb_can within w_notice_0010
end type

type cb_search from w_inherite`cb_search within w_notice_0010
end type







type gb_button1 from w_inherite`gb_button1 within w_notice_0010
end type

type gb_button2 from w_inherite`gb_button2 within w_notice_0010
end type

type dw_1 from u_key_enter within w_notice_0010
integer x = 55
integer y = 68
integer width = 3378
integer height = 136
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_notice_c_10"
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

type dw_list from datawindow within w_notice_0010
integer x = 59
integer y = 252
integer width = 1893
integer height = 2036
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_notice_e_10"
boolean border = false
boolean livescroll = true
end type

event clicked;
if row < 1 then return 
if this.rowcount() < 1 then return 

If row > 0 then
	selectrow(0,false)
	selectrow(row, true)
else
	selectrow(0,false)
end if

If dw_insert.Retrieve(This.GetItemString(row, 'no')) > 0	 Then
	mle_1.text = dw_insert.GetItemString(1, 'content')
	
	dw_insert.SetItem(1, 'up_id', gs_empno)
	dw_insert.SetItem(1, 'up_dt', f_today()+f_totime())
End if
end event

event itemerror;Return 1
end event

event rowfocuschanged;if currentrow < 1 then return 
if this.rowcount() < 1 then return 
end event

type rr_1 from roundrectangle within w_notice_0010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2025
integer y = 236
integer width = 2606
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_notice_0010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 236
integer width = 1952
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_notice_0010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 36
integer width = 3406
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

type mle_1 from multilineedit within w_notice_0010
integer x = 2487
integer y = 520
integer width = 2066
integer height = 1548
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
boolean autovscroll = true
integer limit = 1000
integer tabstop[] = {0}
boolean hideselection = false
end type

