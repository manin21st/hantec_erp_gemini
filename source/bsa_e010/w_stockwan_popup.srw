$PBExportHeader$w_stockwan_popup.srw
$PBExportComments$LOT 재고 선택 POPUP
forward
global type w_stockwan_popup from w_inherite_popup
end type
type st_2 from statictext within w_stockwan_popup
end type
type rr_1 from roundrectangle within w_stockwan_popup
end type
end forward

global type w_stockwan_popup from w_inherite_popup
integer width = 3150
integer height = 2060
string title = "LOT 재고 선택 POPUP"
st_2 st_2
rr_1 rr_1
end type
global w_stockwan_popup w_stockwan_popup

type variables
datawindow dwname

String isDepot, isItnbr, isHoldNo, isjasa, issaupj, ischk
Dec{3}    idqty
end variables

on w_stockwan_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_stockwan_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;// 사용되는 프로그램
// 출고등록

F_Window_Center_Response(This)

dwname = message.powerobjectparm

isDepot = gs_gubun
isItnbr = gs_code
isHoldNo = gs_codename

// 수량체크 여부
If gs_docno = 'N' Then
	ischk    = 'N'
Else
	ischk    = 'Y'
End If

If IsNumber(gs_codename2) Then
	idQty = Dec(gs_codename2)
Else
	idQty = 0
End If

// 자사코드는 창고기준으로 선택
SELECT ipjogun INTO :issaupj
  FROM VNDMST
 WHERE ( CVCOD = :gs_gubun ) ;
		 
SELECT DATANAME
  INTO :isjasa
  FROM SYSCNFG, VNDMST
 WHERE SYSGU = 'C' and SERIAL = '4' and RFCOD = :issaupj
	AND DATANAME = CVCOD;

If idqty > 0 Then
	st_2.Visible = true
	st_2.text = '선택수량 : ' + string(idqty,'#,##0.000')
End If

dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

String sIttyp

select ittyp into :sittyp from itemas where itnbr = :isItnbr;
If sittyp = '1' or sittyp = '2' then
	dw_1.Object.jego_qty.format = "#,##0"
	dw_1.Object.choice_qty.format = "#,##0"
	dw_1.Object.sum_jegoqty.format = "#,##0"
	dw_1.Object.sum_qty.format = "#,##0"
End If

dw_1.Retrieve(gs_gubun, gs_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_stockwan_popup
integer x = 1111
integer y = 88
integer width = 1175
integer height = 80
string dataobject = "d_stockwan_popup_2"
end type

event dw_jogun::itemchanged;call super::itemchanged;//stock_lot_pspec

String sPspec

sPspec = GetText()

dw_1.SetFilter("stock_lot_pspec = '" + sPspec + "'")
dw_1.Filter()
end event

type p_exit from w_inherite_popup`p_exit within w_stockwan_popup
integer x = 2898
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_stockwan_popup
integer x = 2551
integer y = 28
end type

type p_choose from w_inherite_popup`p_choose within w_stockwan_popup
integer x = 2725
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long Lrow, Lgrow
Dec{3}  dQty, dChoiceQty
String  sCustNo

If dw_1.accepttext() <> 1 Then Return

// 선택수량이 0보다 큰경우
If idQty > 0.0 Then
	If dw_1.RowCount() > 0 Then
		dQty = dw_1.GetItemNumber(1, 'sum_qty')
	Else
		dQty = 0
	End If
	
	If ischk = 'Y' And idQty < dQty Then
		MessageBox('확 인','선택하신 수량과 다릅니다')
		Return
	End If
End If

dwname.setredraw(false)

If IsNull(isHoldNo) Then
	dwname.Reset()
Else
	dwname.SetFilter("hold_no = '" + isHoldNo + "'")
	dwname.Filter()
	dwname.RowsDiscard(1, dwname.RowCount(), Primary!)
End If

dQty = 0
For Lrow = 1 to dw_1.rowcount()
	
	 if dw_1.getitemstring(Lrow, "gbn") = 'N' then continue
	 dChoiceQty = dw_1.getitemdecimal(Lrow, "choice_qty")
	 If IsNull(dChoiceQty) Or dChoiceQty <= 0 Then Continue
	 
	 Lgrow =	dwname.insertrow(0)
	 dwname.setitem(Lgrow, "hold_no", 	isHoldNo)
	 dwname.setitem(Lgrow, "itnbr", 		isItnbr)
	 dwname.setitem(Lgrow, "pspec", 		dw_1.getitemstring(Lrow, "stock_lot_pspec"))	// 등급
	 dwname.setitem(Lgrow, "lotno", 		dw_1.getitemstring(Lrow, "stock_lot_lotno"))
	 dwname.setitem(Lgrow, "hold_qty", 	dChoiceQty)
	 
	 // 입고처를 찾지 못한경우 자사코드 입력
	 sCustNo = Trim(dw_1.getitemstring(Lrow, "cust_no"))
	 If IsNull(sCustNo) Or scustNo = '' Then sCustNo = isjasa
		
	 dwname.setitem(Lgrow, "cust_no",	sCustNo)		// 입고처(최초)
	 
	 // 선택수량
	 dQty += dChoiceQty
Next
dwname.setredraw(true)

gs_code = String(dQty)

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_stockwan_popup
integer x = 37
integer y = 200
integer width = 3063
integer height = 1764
string dataobject = "d_stockwan_popup_1"
end type

event dw_1::itemchanged;call super::itemchanged;Dec dJego, dQty

Choose case GetColumnName()
	Case 'gbn'
		If GetText() = 'Y' Then
			If isChk = 'Y' and idQty > 0 Then
				dJego = GetItemNumber(row, 'jego_qty')
				If idQty > dJego Then
					If dJego > 0 Then
						SetItem(row, 'choice_qty', GetItemNumber(row, 'jego_qty'))
					Else
						SetItem(row, 'choice_qty', 0)
					End If
				Else
					SetItem(row, 'choice_qty', idQty)
				End If
			Else
				If GetItemNumber(row, 'jego_qty') > 0 Then
					SetItem(row, 'choice_qty', GetItemNumber(row, 'jego_qty'))
				Else
					SetItem(row, 'choice_qty', 0)
				End If
			End If
		Else
			SetItem(row, 'choice_qty', 0)
		End If
	Case 'choice_qty'
		dQty = Dec(GetText())
		
		dJego = GetItemNumber(row, 'jego_qty')
		If dQty > dJego Then
			MessageBox('확 인','재고수량 이상으로 선택하실 수 없습니다.!!')
			Return 2
		End If
		
		If dQty > 0 Then
			SetItem(row, 'gbn','Y')
		Else
			SetItem(row, 'gbn','N')
		End If
End Choose
end event

event dw_1::ue_pressenter;//
end event

event dw_1::ue_key;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_stockwan_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_stockwan_popup
end type

type cb_return from w_inherite_popup`cb_return within w_stockwan_popup
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_stockwan_popup
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_stockwan_popup
end type

type st_1 from w_inherite_popup`st_1 within w_stockwan_popup
end type

type st_2 from statictext within w_stockwan_popup
boolean visible = false
integer x = 50
integer y = 92
integer width = 910
integer height = 88
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 33554432
long backcolor = 32106727
string text = "선택수량"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_stockwan_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 196
integer width = 3081
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

