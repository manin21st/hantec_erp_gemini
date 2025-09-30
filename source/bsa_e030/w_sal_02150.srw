$PBExportHeader$w_sal_02150.srw
$PBExportComments$작업지시 취소요청 등록
forward
global type w_sal_02150 from w_inherite
end type
type dw_ip from u_key_enter within w_sal_02150
end type
type rb_insert from radiobutton within w_sal_02150
end type
type rb_update from radiobutton within w_sal_02150
end type
type pb_1 from u_pb_cal within w_sal_02150
end type
type pb_2 from u_pb_cal within w_sal_02150
end type
type rr_1 from roundrectangle within w_sal_02150
end type
type rr_2 from roundrectangle within w_sal_02150
end type
end forward

global type w_sal_02150 from w_inherite
string title = "작업지시 취소요청 등록"
dw_ip dw_ip
rb_insert rb_insert
rb_update rb_update
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02150 w_sal_02150

on w_sal_02150.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rb_insert=create rb_insert
this.rb_update=create rb_update
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rb_insert
this.Control[iCurrent+3]=this.rb_update
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_sal_02150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rb_insert)
destroy(this.rb_update)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_ip.InsertRow(0)
dw_ip.SetItem(1,'sdatef',left(is_today,6) + '01')
dw_ip.SetItem(1,'sdatet',is_today)

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
End If

dw_ip.SetItem(1, 'areacode', sarea)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02150
integer x = 32
integer y = 336
integer width = 4567
integer height = 1972
integer taborder = 30
string dataobject = "d_sal_02150"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;Return 1
end event

event dw_insert::itemchanged;String sNull ,ls_gubun
Double dOrdCancelQty, dJisiQty, dProdQty, dIpQty
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

if dw_ip.accepttext() <> 1 then return 

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '1' then
	Choose Case GetColumnName()
		Case 'ord_cancel_qty'
			dOrdCancelQty = Double(GetText())
			
			dJisiQty = GetItemNumber(nRow,'sorder_jisi_qty')
			dProdQty = GetItemNumber(nRow,'sorder_prod_qty')
			
			If dOrdCancelQty > dJisiQty - dProdQty Then
				MessageBox('확  인','취소요청 가능한 수량을 초과하였습니다.!!~r~r' + &
										  "[취소수량 <= 지시수량 - 생산입고 - 진행수량]입니다.")
				Return 2
			End If
			
			SetItem(nRow,'sabu', gs_sabu)
			SetItem(nRow,'order_no', GetItemString(nRow,'sorder_order_no'))
			If dOrdCancelQty = 0 or IsNull(dOrdCancelQty) Then
				SetItem(nRow,'ord_cancel_date', sNull)
				SetItem(nRow,'ord_cancel_qty', 0)
			Else
				SetItem(nRow,'ord_cancel_date', is_today)
			End If
	End Choose
end if


end event

type p_delrow from w_inherite`p_delrow within w_sal_02150
integer x = 3867
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_02150
integer x = 3694
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_02150
integer x = 2999
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_02150
integer x = 3520
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_02150
boolean originalsize = true
end type

type p_can from w_inherite`p_can within w_sal_02150
boolean originalsize = true
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sal_02150
integer x = 3173
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_02150
integer x = 3922
boolean originalsize = true
end type

event p_inq::clicked;call super::clicked;String sFrom, sTo, sCust, sOrderNo, sarea , ls_gubun
Long ix

If dw_ip.AcceptText() <> 1 Then Return -1

dw_insert.reset()

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sCust       = dw_ip.GetItemString(1,"custcode")
sArea       = dw_ip.GetItemString(1,"areacode")
sOrderNo    = dw_ip.GetItemString(1,"order_no")
ls_gubun    = dw_ip.GetItemString(1,"gubun")

IF sFrom = "" OR IsNull(sFrom) Or sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sCust = "" OR IsNull(sCust) THEN sCust = ''
IF sArea = "" OR IsNull(sArea) THEN sArea = ''
IF sOrderNo = "" OR IsNull(sOrderNo) THEN sOrderNo = ''

dw_insert.SetRedraw(False)

if ls_gubun = '1' then
	/* 등록일 경우 취소요청안된 건만 filtering */
	If rb_insert.Checked Then 
		dw_insert.SetFilter('isnull(ord_cancel_date)')
	Else
		dw_insert.SetFilter('not isnull(ord_cancel_date)')
	End If
	dw_insert.Filter()

//IF dw_insert.RowCount() <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	dw_insert.SetRedraw(True)
//	Return -1
//END IF

	dw_insert.Retrieve(gs_sabu,sFrom, sTo, sArea+'%', sCust+'%', sOrderNo+'%')
	
	/* 조회후 row의 상태를 new!로 변경한다 */
	For ix = 1 To dw_insert.RowCount()
		sOrderNo = Trim(dw_insert.GetItemString(ix,'order_no'))
		If IsNull(sOrderNo) or sOrderNo = '' Then
			dw_insert.SetItemStatus(ix,0,Primary!, New!)
		End If
	Next
	
elseif ls_gubun = '2' then
	If rb_insert.Checked Then 
		dw_insert.SetFilter('isnull(order_no)')
	Else
		dw_insert.SetFilter('not isnull(order_no)')
	End If
	dw_insert.Filter()
	
  if dw_insert.Retrieve(gs_sabu,sFrom, sTo, sArea+'%', sCust+'%', sOrderNo+'%') < 1 then
	  if rb_insert.checked = true then
		  messagebox('확인','생산승인된 사항이 없습니다.')
	  elseif rb_update.checked = true then  
		  messagebox('확인','생산승인 취소요청된 사항이 없습니다.')
	  end if
	  dw_insert.SetRedraw(True)
	  dw_ip.SetColumn("sdatef")
	  dw_ip.SetFocus()
	  Return -1
	END IF
end if
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sal_02150
integer x = 4215
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_02150
integer x = 4096
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;string ls_gubun ,ls_order_no ,ls_chk , ls_date
Long nCnt, ix ,i
Double dOrdCancelQty
dwItemStatus l_status

If dw_insert.AcceptText() <> 1 Then Return
If dw_ip.AcceptText() <> 1 Then Return

if dw_insert.rowcount() < 1 then return
ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '1' then
	ncnt = dw_insert.RowCount()
	If nCnt <= 0 then Return
	
	/* 기존자료의 취소수량이 0이면 삭제한다 */
	For ix = ncnt to 1 Step -1
		dOrdCancelQty = dw_insert.GetItemNumber(ix,'ord_cancel_qty')
		If IsNull(dOrdCancelQty) Then dOrdCancelQty = 0
		If dOrdCancelQty > 0 Then continue
		
		l_status = dw_insert.GetItemStatus(ix, 0, Primary!)
		If l_status = DataModified! Then
			dw_insert.DeleteRow(ix)
		End If
	Next
	
	/* 저장 */
	If dw_insert.update() > 0 then
		commit using sqlca;
	Else
		rollback using sqlca ;
		f_message_chk(160,'')
		return
	End if
cb_inq.TriggerEvent(Clicked!)
elseif ls_gubun = '2' then
	ls_date = f_today()
  if rb_insert.checked = true then	
	for i = 1 to dw_insert.rowcount()
		ls_chk = dw_insert.getitemstring(i,'chk')
		
		if ls_chk = 'Y' then
			ls_order_no = dw_insert.getitemstring(i,'sorder_order_no')
			
			INSERT INTO SORD_CANCEL_REQ (SABU , ORDER_NO ,ORD_CANCEL_QTY,ORD_CANCEL_DATE)
			VALUES (:gs_sabu , :ls_order_no, 0 ,:ls_date ) ;
		end if
	next
	
  elseif rb_update.checked = true then
	for i = 1 to dw_insert.rowcount()
		ls_chk = dw_insert.getitemstring(i,'chk')
		
		if ls_chk = 'Y' then
			ls_order_no = dw_insert.getitemstring(i,'sorder_order_no')
			
			DELETE FROM SORD_CANCEL_REQ 
			WHERE  SABU = :gs_sabu  AND ORDER_NO = :ls_order_no ;
		end if
	next
	
  end if	
  Commit ;
  dw_insert.reset()
end if

sle_msg.Text = '자료를 저장하였습니다'

end event

type cb_exit from w_inherite`cb_exit within w_sal_02150
integer x = 4489
integer y = 5000
integer height = 88
end type

type cb_mod from w_inherite`cb_mod within w_sal_02150
integer x = 3735
integer y = 5000
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_sal_02150
integer x = 1595
integer y = 2432
integer taborder = 60
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02150
integer x = 1358
integer y = 2364
integer taborder = 90
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02150
integer x = 3387
integer y = 5000
end type

type cb_print from w_inherite`cb_print within w_sal_02150
integer x = 1097
integer y = 2440
integer taborder = 100
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_02150
end type

type cb_can from w_inherite`cb_can within w_sal_02150
integer x = 4119
integer y = 5000
end type

type cb_search from w_inherite`cb_search within w_sal_02150
integer x = 2103
integer y = 2360
integer taborder = 110
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02150
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02150
end type

type dw_ip from u_key_enter within w_sal_02150
integer y = 24
integer width = 3104
integer height = 272
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_021501"
boolean border = false
end type

event itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1 , ls_gubun
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

SetNull(snull)

Choose Case GetColumnName() 
  Case 'gubun'
	  ls_gubun = this.gettext()
	  
	  dw_insert.setredraw(false)
	  if ls_gubun = '1' then
		  dw_insert.dataobject = 'd_sal_02150'
	  elseif ls_gubun = '2' then
		  dw_insert.dataobject = 'd_sal_021502'
	  end if

	  dw_insert.settransobject(sqlca)
	  dw_insert.setredraw(true)
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[수주기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[수주기간]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "deptcode"
	SetItem(1,'areacode',sNull)
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
/* 관할구역 */
 Case "areacode"
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)

	sarea = this.GetText()
	IF sarea = "" OR IsNull(sarea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sarea   ;
		
   SetItem(1,'deptcode',steam)
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"areacode",   sarea)
			SetItem(1,"custname",	scvnas)
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"areacode",   sarea)
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			Return 1
		END IF
END Choose

end event

event itemerror;return 1
end event

event rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
	Case "order_no" 
		OpenWithParm(w_sorder_popup,'1')
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"order_no",Left(gs_code,14))
END Choose

end event

type rb_insert from radiobutton within w_sal_02150
integer x = 3163
integer y = 84
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;dw_insert.Reset()
sle_msg.text = ''
end event

type rb_update from radiobutton within w_sal_02150
integer x = 3163
integer y = 176
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "수정"
end type

event clicked;dw_insert.Reset()
sle_msg.text = ''
end event

type pb_1 from u_pb_cal within w_sal_02150
integer x = 690
integer y = 68
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02150
integer x = 1152
integer y = 68
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 324
integer width = 4594
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3118
integer y = 28
integer width = 329
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

