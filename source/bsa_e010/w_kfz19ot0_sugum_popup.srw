$PBExportHeader$w_kfz19ot0_sugum_popup.srw
$PBExportComments$수금 반제전표 조회 POPUP
forward
global type w_kfz19ot0_sugum_popup from w_inherite_popup
end type
type st_2 from statictext within w_kfz19ot0_sugum_popup
end type
type st_amt from statictext within w_kfz19ot0_sugum_popup
end type
type rb_1 from radiobutton within w_kfz19ot0_sugum_popup
end type
type rb_2 from radiobutton within w_kfz19ot0_sugum_popup
end type
type cb_2 from commandbutton within w_kfz19ot0_sugum_popup
end type
type st_type from statictext within w_kfz19ot0_sugum_popup
end type
type st_cause from statictext within w_kfz19ot0_sugum_popup
end type
type rr_1 from roundrectangle within w_kfz19ot0_sugum_popup
end type
type rr_2 from roundrectangle within w_kfz19ot0_sugum_popup
end type
type rr_3 from roundrectangle within w_kfz19ot0_sugum_popup
end type
end forward

global type w_kfz19ot0_sugum_popup from w_inherite_popup
integer x = 443
integer y = 200
integer width = 3154
integer height = 2084
string title = "반제전표 조회 선택"
st_2 st_2
st_amt st_amt
rb_1 rb_1
rb_2 rb_2
cb_2 cb_2
st_type st_type
st_cause st_cause
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_kfz19ot0_sugum_popup w_kfz19ot0_sugum_popup

type variables
dec   id_amt    //총금액(공급가 + 부가세)
dec   id_type
dec   id_cause
end variables

on w_kfz19ot0_sugum_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_amt=create st_amt
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_2=create cb_2
this.st_type=create st_type
this.st_cause=create st_cause
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_amt
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_type
this.Control[iCurrent+7]=this.st_cause
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.rr_3
end on

on w_kfz19ot0_sugum_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_amt)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_2)
destroy(this.st_type)
destroy(this.st_cause)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;String sCvcod, sIpgumDate, sGubun
Dec    dsugumseq
Long   nCnt

sGubun = Message.StringParm	

dSugumSeq = Dec(gs_gubun)
//messagebox(gs_code, string(dsugumseq))
/* 상계거래처가 있을 경우는 해당거래처로 처리 */
SELECT NVL(CUST_NO,CVCOD), IPGUM_DATE, IPGUM_AMT INTO :sCvcod, :sIpgumDate, :id_amt
  FROM SUGUM
 WHERE SABU = :gs_sabu AND
       SUGUM_NO = :gs_code AND
		 SUGUM_SEQ = :dSugumSeq;
If sqlca.sqlcode <> 0 Then
	MessageBox('확 인','수금내역이 존재하지 않습니다.!!')
	Close(this)
	Return
End If

st_amt.text = string(id_amt, '###,###,###,##0')

///* 반제구분에 따라 */
If sgubun = '1' Then
	st_type.Visible = True
	st_cause.Visible = False

	id_type 	= id_amt
	id_cause	= 0
ElseIf sgubun = '2' Then
	st_type.Visible = False
	st_cause.Visible = True

	id_type 	= 0
	id_cause	= id_amt
Else
	st_type.Visible = True
	st_cause.Visible = True
	
	id_type 	= id_amt
	id_cause	= id_amt
End If

id_amt = id_type + id_cause

SELECT COUNT(*) INTO :nCnt
  FROM KIF04OT1
 WHERE SABU = :gs_sabu AND
       SUGUM_NO = :gs_code AND
		 SUGUM_SEQ = :dSugumSeq;

If nCnt > 0 Then
	rb_1.Checked = True
	rb_2.Checked = False
	
	rb_1.TriggerEvent(Clicked!)
Else
	rb_1.Checked = False
	rb_2.Checked = True
	
	rb_2.TriggerEvent(Clicked!)
End If
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 192
integer y = 2248
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_kfz19ot0_sugum_popup
integer x = 2935
integer y = 12
end type

event p_exit::clicked;call super::clicked;Long nCnt


SELECT COUNT(*) INTO :nCnt
  FROM KIF04OT1
 WHERE SABU = :gs_saupj AND
       SUGUM_NO = :gs_code AND
		 SUGUM_SEQ = to_number(:gs_gubun);
If nCnt <= 0 Then
	If MessageBox('확인','선택된 반제전표가 없습니다.!!~r~n~r~n종료하시겠습니까?',question!,yesno!, 2) = 1 Then
		gs_code =  'Y'
		Close(Parent)
		Return
	End If
	
	Return
Else
	gs_code =  'Y'
	Close(Parent)	
End If

end event

type p_inq from w_inherite_popup`p_inq within w_kfz19ot0_sugum_popup
integer x = 2587
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sCvcod, sIpgumDate, sAccCd1, SaCCcD2, sIpgumType, sIpgumCause, sSanggu1, sSanggu2, sDcgu1, sDcgu2, scust_no, scust_code
Dec    dsugumseq
Long   nCnt

If rb_1.Checked = True Then
	dSugumSeq = Dec(gs_gubun)
	
	dw_1.Retrieve(gs_saupj, gs_code, dsugumseq)
Else
	dSugumSeq = Dec(gs_gubun)
	
	SELECT CVCOD, IPGUM_DATE, IPGUM_TYPE, IPGUM_CAUSE, CUST_NO 
	  INTO :sCvcod, :sIpgumDate, :sIpgumType, :sIpgumCause, :sCust_no 
	  FROM SUGUM
	 WHERE SABU = :gs_sabu AND
			 SUGUM_NO = :gs_code AND
			 SUGUM_SEQ = :dSugumSeq;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확 인','수금내역이 존재하지 않습니다.!!')
		dw_1.Reset()
		Return
	End If
	
	// 외상매입 상계인 경우에는 외상매출처를 기준으로 한다.
	IF sIpgumType = '4' THEN
		IF ISNULL(SCUST_NO) OR TRIM(SCUST_NO) = '' THEN
			MESSAGEBOX("상계거래처", "상계거래처가 없읍니다", STOPSIGN!)
			RETURN
		END IF
		sCust_code = scust_no
	Else
		sCust_code = sCvcod
	END IF
	
	/* 계정코드 확인 */
	SetNull(sAccCd1)
	SetNull(sAccCd2)	
	SELECT RFNA2 INTO :sAccCd1 FROM REFFPF WHERE RFCOD = '38' AND RFGUB = :sIpgumType;	
	SELECT RFNA2 INTO :sAccCd2 FROM REFFPF WHERE RFCOD = '39' AND RFGUB = :sIpgumCause;
	
	// 입금형태
	SELECT SANG_GU, DC_GU INTO :sSanggu1, :sDcgu1 FROM KFZ01OM0 
	 WHERE ACC1_CD||ACC2_CD = :sAccCd1;	
	If IsNull(sSanggu1) Or sSAnggu1 = 'N' Then
		sAccCd1 = '...'
	End If
	
	// 입금사유
	SELECT SANG_GU, DC_GU INTO :sSanggu2, :sDcgu2 FROM KFZ01OM0 
	 WHERE ACC1_CD||ACC2_CD = :sAccCd2;	
	If IsNull(sSanggu2) Or sSAnggu2 = 'N' Then
		sAccCd2 = '...'
	End If	
	
	if sAccCd1 = '...' And sAccCd2 = '...' then
		MessageBox("상계처리", "상계처리 할 수 없읍니다", stopsign!)
		dw_1.reset()
		return
	End if
	
	dw_1.Retrieve(sIpgumDate, sAccCd1, sAccCd2, sCvcod, sCust_code)
End If

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_kfz19ot0_sugum_popup
integer x = 2761
integer y = 12
end type

event p_choose::clicked;call super::clicked;string ssaupj, sacc_date, supmu_gu, sjun_no, slin_no, sbal_date, sbjun_no, sCrossNo, sIpgumType, sIpgumCause, sSangcod, snici_name
dec    damt, dSugumSeq, dRemain, dCnt, dUseamt, dtype, dcause, dtotal
Int    iLen, ix

/* 반제전표 생성시 */
If rb_2.Checked = True Then
	dSugumSeq = Dec(gs_gubun)
	SELECT A.IPGUM_TYPE, A.IPGUM_CAUSE, B.SANGCOD
	  INTO :sIpgumType, :sIpgumCause, :sSangcod
	  FROM SUGUM A, KIF04OT0 B
    WHERE A.SABU      = B.SUBU(+) 
      AND A.SUGUM_NO  = B.SUGUM_NO(+)
      AND A.SUGUM_SEQ = B.SUGUM_SEQ(+) 
	   AND A.SABU      = :gs_saupj 
		AND A.SUGUM_NO  = :gs_code 
		AND A.SUGUM_SEQ = :dSugumSeq;
			 
	If sqlca.sqlcode <> 0 Then
		MessageBox('확 인','수금내역이 존재하지 않습니다.!!')
		Return
	End If
	
	dtotal = 0
	SELECT SUM(DAMOUNT) INTO :DTOTAL FROM KIF04OT1
	 WHERE SABU = :gs_saupj AND
			 SUGUM_NO = :gs_code AND
			 SUGUM_SEQ = :dSugumSeq;
	If sqlca.sqlcode <> 0 Then
		RollBack;
		MessageBox('확 인','반제내역 검색중 오류발생.!!')
		Return
	End If
	
	IF DTOTAL <> 0 THEN
		RollBack;
		MessageBox('확 인','반제내역이 존재하므로 삭제후 처리하세요.!!')
		Return				
	END IF
	
	dUseamt = id_amt
	For ix = 1 To dw_1.RowCount()
		If dw_1.GetItemNumber(ix,'camt') = 0 Then Continue
	
		damt      = dw_1.GetItemDecimal(ix, "sum_chamt")
		dtype     = dw_1.GetItemDecimal(ix, "sum_type")
		dcause    = dw_1.GetItemDecimal(ix, "sum_cause")
		IF id_amt > damt THEN
			MessageBox("확 인", "반제액이 계산서금액 보다 적으니 금액을 확인하세요!")
			return
		END IF
		
		IF id_type > dtype THEN
			MessageBox("확 인", "[사유]반제액이 계산서금액 보다 적으니 금액을 확인하세요!")
			return
		END IF		
		
		IF id_cause > dcause THEN
			MessageBox("확 인", "[형태]반제액이 계산서금액 보다 적으니 금액을 확인하세요!")
			return
		END IF
		
		sSaupj    = dw_1.GetItemString(ix, "saupj")
		snici_name    = dw_1.GetItemString(ix, "nici_name")		
		
		iLen      = len(sSaupj)
		if iLen < 1 then 
			MessageBox("확 인", "사업장을 확인하세요!")
			return
		elseif iLen = 1 then //사업장은 2자리 
			sSaupj = '0' + sSaupj
		end if
		
		sAcc_date = dw_1.GetItemString(ix, "acc_date")
		sUpmu_gu  = dw_1.GetItemString(ix, "upmu_gu")
		sJun_no   = string(dw_1.GetItemNumber(ix, "jun_no"), '0000')
		sLin_no   = string(dw_1.GetItemNumber(ix, "lin_no"), '000')
		sBal_date = dw_1.GetItemString(ix, "bal_date")
		sBjun_no  = string(dw_1.GetItemNumber(ix, "bjun_no"), '0000')
		
		sCrossNo = sSaupj + sAcc_date + sUpmu_gu + sJun_no + sLin_no + sBal_date + sBjun_no 
	
		dRemain	= dw_1.GetItemDecimal(ix, "camt")

		If dRemain <> 0 Then
			INSERT INTO "KIF04OT1"  
						( "SABU",   		"SUGUM_NO",   		"SUGUM_SEQ",   		"CROSSNO",   
						  "DAMOUNT",      "IPGUM_TYPE",   	
						  						"IPGUM_CAUSE",   	   
						  "CVCOD" )  
				VALUES( :gs_saupj,   	:gs_code,     	   :dSugumSeq,      	   :sCrossNo,   
						  :dRemain,	      Decode(:snici_name, '형태', :sIpgumType, 	null),   	
						  						Decode(:snici_name, '사유', :sIpgumCause, null),       
						  :sSangcod );

			If sqlca.sqlcode <> 0 Then
				RollBack;
				MessageBox('확 인','반제전표 생성시 오류입니다.!!')
				Return
			End If
		End If
	Next
	
	COMMIT;
End If

/* 반제전표 삭제시 */
If rb_1.Checked = True Then
	dCnt = dw_1.RowCount()
	
	For ix = dCnt To 1 Step -1
		 dw_1.DeleteRow(ix)
	Next
	
	IF dw_1.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF
	
	COMMIT;
End If

p_inq.TriggerEvent(Clicked!)
end event

type dw_1 from w_inherite_popup`dw_1 within w_kfz19ot0_sugum_popup
integer x = 23
integer width = 3077
integer height = 1612
integer taborder = 10
string dataobject = "dw_kfz19ot0_sugum_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::itemerror;call super::itemerror;Return 1
end event

event dw_1::itemchanged;call super::itemchanged;Dec dChamt
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
		
		If GetItemNumber(nrow, 'sum_chamt') + dChamt > id_amt Then
			MessageBox('확인','반제액이 수금액보다 큽니다.!!')
			SetItem(nrow, 'camt', 0)
			Return 1
		End If
End Choose

end event

event dw_1::ue_pressenter;
Return 0
end event

type sle_2 from w_inherite_popup`sle_2 within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 1147
integer y = 2168
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 2473
integer y = 2208
integer width = 302
integer taborder = 20
boolean enabled = false
string text = "저장(&S)"
end type

type cb_return from w_inherite_popup`cb_return within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 1170
integer y = 2248
integer width = 302
integer taborder = 30
boolean enabled = false
end type

event cb_return::clicked;
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 0
integer y = 2208
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 965
integer y = 2168
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_kfz19ot0_sugum_popup
boolean visible = false
integer y = 2212
end type

type st_2 from statictext within w_kfz19ot0_sugum_popup
integer x = 41
integer y = 208
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "수금 금액 : "
boolean focusrectangle = false
end type

type st_amt from statictext within w_kfz19ot0_sugum_popup
integer x = 361
integer y = 200
integer width = 631
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_kfz19ot0_sugum_popup
integer x = 2089
integer y = 212
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "반제전표 삭제"
end type

event clicked;dw_1.SetRedraw(false)
dw_1.DataObject = 'dw_kfz19ot0_sugum_popup1'
dw_1.SetTransObject(sqlca)

cb_inq.TriggerEvent(Clicked!)
dw_1.SetRedraw(True)

end event

type rb_2 from radiobutton within w_kfz19ot0_sugum_popup
integer x = 2597
integer y = 212
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "반제전표 선택"
boolean checked = true
end type

event clicked;dw_1.SetRedraw(false)
dw_1.DataObject = 'dw_kfz19ot0_sugum_popup'
dw_1.SetTransObject(sqlca)

cb_inq.TriggerEvent(Clicked!)

dw_1.SetRedraw(true)
end event

type cb_2 from commandbutton within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 2793
integer y = 2208
integer width = 302
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "종료(&X)"
end type

type st_type from statictext within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 1486
integer y = 224
integer width = 320
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "[형태반제]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_cause from statictext within w_kfz19ot0_sugum_popup
boolean visible = false
integer x = 1161
integer y = 224
integer width = 320
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "[사유반제]"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfz19ot0_sugum_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 336
integer width = 3090
integer height = 1636
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfz19ot0_sugum_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 172
integer width = 2007
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_kfz19ot0_sugum_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2048
integer y = 172
integer width = 1065
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

