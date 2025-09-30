$PBExportHeader$w_sal_06090_popup.srw
$PBExportComments$NEGO POPUP
forward
global type w_sal_06090_popup from window
end type
type cb_del from commandbutton within w_sal_06090_popup
end type
type cb_2 from commandbutton within w_sal_06090_popup
end type
type dw_insert from datawindow within w_sal_06090_popup
end type
type cb_1 from commandbutton within w_sal_06090_popup
end type
type dw_list from datawindow within w_sal_06090_popup
end type
type dw_disp from datawindow within w_sal_06090_popup
end type
type gb_1 from groupbox within w_sal_06090_popup
end type
end forward

global type w_sal_06090_popup from window
integer x = 187
integer y = 16
integer width = 3163
integer height = 2220
boolean titlebar = true
string title = "NEGO 반제 처리"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_del cb_del
cb_2 cb_2
dw_insert dw_insert
cb_1 cb_1
dw_list dw_list
dw_disp dw_disp
gb_1 gb_1
end type
global w_sal_06090_popup w_sal_06090_popup

type variables
String LsNgNo
end variables

on w_sal_06090_popup.create
this.cb_del=create cb_del
this.cb_2=create cb_2
this.dw_insert=create dw_insert
this.cb_1=create cb_1
this.dw_list=create dw_list
this.dw_disp=create dw_disp
this.gb_1=create gb_1
this.Control[]={this.cb_del,&
this.cb_2,&
this.dw_insert,&
this.cb_1,&
this.dw_list,&
this.dw_disp,&
this.gb_1}
end on

on w_sal_06090_popup.destroy
destroy(this.cb_del)
destroy(this.cb_2)
destroy(this.dw_insert)
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.dw_disp)
destroy(this.gb_1)
end on

event open;String sAcc,sGbn,sSaupNo,sSaupName
Double dAmount,dAmountF

dw_insert.SetTransObject(sqlca)
dw_insert.Reset()

dw_disp.SetTransObject(Sqlca)
dw_disp.Reset()
dw_disp.InsertRow(0)

/* Nego 조회 */
LsNgNo = gs_code
SELECT A.CVCOD,  B.CVNAS2,   A.NGAMT,   A.WAMT
  INTO :sSaupNo, :sSaupName, :dAmountF, :dAmount
  FROM EXPNEGOH A, VNDMST B
 WHERE A.SABU = :gs_sabu
   AND A.NGNO = :LsNgNo
	AND A.CVCOD = B.CVCOD;
If sqlca.sqlcode <> 0 Then
	f_message_chk(50,'')
	Close(This)
	Return
End If

// 반제 대상금액은 매출내역에서 조회한다
SELECT SUM(NGAMT), SUM(WAMT) INTO :dAmountF, :dAmount
  FROM KIF08OT1
  WHERE SABU = :gs_sabu
    AND NGNO = :LsNgNo;

/* 기존에 반제처리 전표 조회 */
dw_list.DataObject = 'd_sal_06090_popup4'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

IF dw_list.Retrieve(gs_sabu, LsNgNo) > 0 THEN
	sAcc      = dw_list.GetItemString(1,"accode")
	sSaupNo   = dw_list.GetItemString(1,"saupno")
	
	dAmount   = dw_list.GetItemNumber(1,"sum_amt")
	dAmountF  = dw_list.GetItemNumber(1,"sum_amtf")
	
	IF dw_list.GetItemString(1,"sang_gu") = 'Y' THEN
		sGbn = '1'
	ELSEIF dw_list.GetItemString(1,"ch_gu") = 'Y' THEN
		sGbn = '2'
	ELSEIF dw_list.GetItemString(1,"gbn1") = '5' THEN
		sGbn = '3'
	ELSE
		SetNull(sGbn)
	END IF
	
	cb_del.Enabled = True
ELSE
	SetNull(sAcc);		SetNull(sGbn);
	
	cb_del.Enabled = False
END IF
		
dw_disp.SetItem(1,"accode",   sAcc)		
dw_disp.SetItem(1,"gbn",      sGbn)		
dw_disp.SetItem(1,"saupno",   sSaupNo)
dw_disp.SetItem(1,"saupname", sSaupName)

dw_disp.SetItem(1,"amount",   dAmount)
dw_disp.SetItem(1,"amountf",  dAmountF)
end event

type cb_del from commandbutton within w_sal_06090_popup
integer x = 1893
integer y = 1944
integer width = 361
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;Long nRow

nRow  = dw_list.GetRow()
If nRow <=0 Then Return

IF MessageBox("삭 제","SEQ : " + String(nRow) + "번째  자료가 삭제됩니다." +"~n~n" +&
					"삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

/* EXPCOSTH DELETE */
If dw_list.DeleteRow(nRow) = 1 Then
	IF dw_list.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF
End If

COMMIT;
end event

type cb_2 from commandbutton within w_sal_06090_popup
integer x = 2295
integer y = 1944
integer width = 361
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;String   sAcCode,sProcGbn
Integer  iSelectRow,k,iRowCount,iCurRow

IF dw_disp.AcceptText() = -1 THEN Return
IF dw_list.AcceptText() = -1 THEN Return

sAcCode  = dw_disp.GetItemString(1,"accode")
sProcGbn = dw_disp.GetItemString(1,"gbn")
IF sAcCode = "" OR IsNull(sAcCode) THEN
	MessageBox('확 인','계정과목을 입력하십시요...')
	dw_disp.SetColumn("accode")
	dw_disp.SetFocus()
	Return
END IF

IF dw_list.DataObject = 'd_sal_06090_popup4' THEN						/*기존 자료 조회*/
	CloseWithReturn(w_sal_06090_popup,'1')
ELSE	
	IF dw_list.RowCount() > 0 THEN 
		IF sProcGbn = '1' THEN							/*반제*/
			iSelectRow = dw_list.GetItemNumber(1,"yescnt")	
			IF dw_disp.GetItemNumber(1,"amount") <> dw_list.GetItemNumber(1,"sum_chamt") THEN
				MessageBox('확 인','선택한 금액의 합이 다릅니다...금액을 확인하십시요...')
				Return
			END IF
		ELSE
			iSelectRow = dw_list.GetSelectedRow(0)
		END IF
		IF iSelectRow <=0 THEN
			MessageBox('확 인','자료를 선택하지 않았습니다...')
			Return
		END IF
		
		IF dw_insert.Retrieve( gs_sabu, LsNgNo) > 0 THEN							/*이전 자료 처리*/
			IF MessageBox("확 인","기존에 입력한 자료가 존재합니다...삭제하시겠습니까?",Question!,YesNo!) = 2 THEN
				dw_list.DataObject = 'd_sal_06090_popup4'
				dw_list.SetTransObject(Sqlca)
				
				dw_list.Retrieve(gs_sabu, LsNgNo)	
				Return
			ELSE
				/* 기존 자료 삭제 */
				iRowCount = dw_insert.RowCount()
				FOR k = iRowCount TO 1 STEP -1
					dw_insert.DeleteRow(k)
				NEXT
				IF dw_insert.Update() <> 1 THEN
					MessageBox('확 인','이전 자료 삭제를 실패하였습니다...')
					Rollback;
					Return
				END IF
				Commit;
			END IF
		END IF
		
		IF sProcGbn = '1' THEN													/*반제*/
			iRowCount = dw_list.RowCount()
			FOR k = 1 TO iRowCount
				IF dw_list.GetItemNumber(k,"camt") <> 0 THEN
					iCurRow = dw_insert.InsertRow(0)		
					
					dw_insert.SetItem(iCurRow,"sabu",   	'1')
					dw_insert.SetItem(iCurRow,"ngno",   	LsNgNo)
					dw_insert.SetItem(iCurRow,"seqno",   	iCurRow)
					dw_insert.SetItem(iCurRow,"accode",   	dw_disp.GetItemString(1,"accode"))					
					dw_insert.SetItem(iCurRow,"saupno",    dw_disp.GetItemString(1,"saupno"))
					dw_insert.SetItem(iCurRow,"crossno",   dw_list.GetItemString(k,"saupj")                         + &
																		dw_list.GetItemString(k,"acc_date") + &
																		dw_list.GetItemString(k,"upmu_gu")                       + &
																		String(dw_list.GetItemNumber(k,"jun_no"),'0000')         + &
																		String(dw_list.GetItemNumber(k,"lin_no"),'000')          + &
																		dw_list.GetItemString(k,"bal_date") + &
																		String(dw_list.GetItemNumber(k,"bjun_no"),'0000'))
					dw_insert.SetItem(iCurRow,"amount",   	dw_list.GetItemNumber(k,"camt"))
				END IF
			NEXT
		ELSE
			iCurRow = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(iCurRow,"sabu",   	'1')
			dw_insert.SetItem(iCurRow,"ngno",   	LsNgNo)
			dw_insert.SetItem(iCurRow,"seqno",   	iCurRow)
			dw_insert.SetItem(iCurRow,"accode",   	dw_disp.GetItemString(1,"accode"))
			dw_insert.SetItem(iCurRow,"saupno",    dw_list.GetItemString(iSelectRow,"saupno"))
			dw_insert.SetItem(iCurRow,"amount",   	dw_disp.GetItemNumber(1,"amount"))
			dw_insert.SetItem(iCurRow,"amounty",  	dw_disp.GetItemNumber(1,"amountf"))
		END IF
		
		IF dw_insert.Update() <> 1 THEN
			MessageBox('확 인','자료를 저장할 수 없습니다!!')
			Rollback;
			Return
		ELSE
			Commit;
			CloseWithReturn(w_sal_06090_popup,'1')				
		END IF
	ELSE
		CloseWithReturn(w_sal_06090_popup,'0')								/*처리 없슴*/
	END IF
END IF
end event

type dw_insert from datawindow within w_sal_06090_popup
boolean visible = false
integer x = 594
integer y = 1960
integer width = 974
integer height = 128
boolean titlebar = true
string title = "처리내역 저장"
string dataobject = "d_sal_06090_popup4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_sal_06090_popup
integer x = 2683
integer y = 1944
integer width = 361
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&X)"
end type

event clicked;close(parent)
end event

type dw_list from datawindow within w_sal_06090_popup
integer x = 41
integer y = 232
integer width = 3035
integer height = 1660
integer taborder = 20
string dataobject = "d_sal_06090_popup3"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
IF dw_disp.GetItemString(1,"gbn") <> '1' THEN
	IF Row <= 0 THEN Return
	
	this.SelectRow(0,  False)
	this.SelectRow(Row,True)
END IF
end event

event itemchanged;Dec dChamt, dAmount
Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'camt'
		dChamt = Dec(GetText())
		If IsNull(dChamt) Then dChamt = 0

		If GetItemNumber(nrow, 'remain') < dChamt Then
			MessageBox('확인','미반제액보다 큽니다.!!')
			SetItem(nrow, 'camt', 0)
			Return 1
		End If
		
		dAmount = dw_disp.GetItemNumber(1, 'amount')
		If GetItemNumber(nrow, 'sum_chamt') + dChamt > dAmount Then
			MessageBox('확인','반제액이 큽니다.!!')
			SetItem(nrow, 'camt', 0)
			Return 1
		End If
End Choose
end event

event itemerror;Return 1
end event

type dw_disp from datawindow within w_sal_06090_popup
integer x = 23
integer y = 8
integer width = 3067
integer height = 232
integer taborder = 10
string dataobject = "d_sal_06090_popup1"
boolean border = false
boolean livescroll = true
end type

event itemerror;Return 1
end event

event itemchanged;String sAccCode,sCrossGbn,sChGbn,sGbn1,sNull, sAccName, sCustNo

SetNull(sNull)

sCustNo = dw_disp.GetItemString(1, 'saupno')

IF this.GetColumnName() = "accode" THEN
	sAccCode = this.GetText()
	If sAccCode = '' OR IsNull(sAccCode) THEN Return
	
	SELECT "KFZ01OM0"."SANG_GU",  "KFZ01OM0"."CH_GU",  "KFZ01OM0"."GBN1", "KFZ01OM0"."ACC2_NM"
		INTO :sCrossGbn,   			:sChGbn,					:sGbn1 ,           :sAccName
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAccCode ) ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox('확 인','계정과목을 찾을 수 없습니다.자료를 확인하십시요...')
		this.SetItem(1,"accode",sNull)
		this.SetItem(1,"acname",sNull)
		Return 1
	END IF
	
	this.SetItem(1,"acname",sAccName)
	
	IF sCrossGbn = 'Y' THEN									/*반제대상*/
		this.SetItem(1,"gbn",   '1')
		
		dw_list.DataObject = 'd_sal_06090_popup3'
		dw_list.SetTransObject(Sqlca)
		dw_list.Retrieve(f_today(), sAccCode, sCustNo)
	ELSEIF sChGbn = 'Y' THEN
		this.SetItem(1,"gbn",   '2')						/*차입금 대상*/
		
		dw_list.DataObject = 'd_sal_06090_popup2'
		dw_list.SetTransObject(Sqlca)
		dw_list.Retrieve()
	ELSEIF sGbn1 = '5' THEN	
		this.SetItem(1,"gbn",   '3')						/*예적금 대상*/
		
		dw_list.DataObject = 'd_sal_06090_popup5'
		dw_list.SetTransObject(Sqlca)
		dw_list.Retrieve()
	ELSE
		MessageBox('확 인','보조 처리를 할 수 없습니다.계정과목을 확인하십시요...')
		this.SetItem(1,"accode",sNull)
		this.SetItem(1,"acname",sNull)
		Return 1
	END IF
END IF
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	Case "accode" 
   	Open(w_kfz01om0_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1, 'accode', gs_code)
		TriggerEvent(ItemChanged!)
//		SetItem(1, 'acname',	gs_codename)
End Choose
end event

type gb_1 from groupbox within w_sal_06090_popup
integer x = 1847
integer y = 1892
integer width = 1230
integer height = 188
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

