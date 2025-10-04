$PBExportHeader$w_sal_02040.srw
$PBExportComments$출고송장 등록
forward
global type w_sal_02040 from w_inherite
end type
type rb_1 from radiobutton within w_sal_02040
end type
type rb_2 from radiobutton within w_sal_02040
end type
type cbx_select from checkbox within w_sal_02040
end type
type dw_cond from u_key_enter within w_sal_02040
end type
type cbx_all from checkbox within w_sal_02040
end type
type dw_list from datawindow within w_sal_02040
end type
type st_2 from statictext within w_sal_02040
end type
type st_list from statictext within w_sal_02040
end type
type st_haldang from statictext within w_sal_02040
end type
type pb_1 from u_pb_cal within w_sal_02040
end type
type rr_1 from roundrectangle within w_sal_02040
end type
type rr_2 from roundrectangle within w_sal_02040
end type
type rr_3 from roundrectangle within w_sal_02040
end type
type rr_4 from roundrectangle within w_sal_02040
end type
type dw_lot from datawindow within w_sal_02040
end type
type dw_head from u_key_enter within w_sal_02040
end type
type dw_hold from datawindow within w_sal_02040
end type
type dw_haldang_list from datawindow within w_sal_02040
end type
type dw_imhist from u_d_popup_sort within w_sal_02040
end type
type dw_haldang from u_d_popup_sort within w_sal_02040
end type
type dw_print from datawindow within w_sal_02040
end type
type dw_print1 from datawindow within w_sal_02040
end type
type cbx_move from checkbox within w_sal_02040
end type
type dw_autoimhist from datawindow within w_sal_02040
end type
end forward

global type w_sal_02040 from w_inherite
integer width = 4677
integer height = 2832
string title = "출고의뢰등록(내수)"
rb_1 rb_1
rb_2 rb_2
cbx_select cbx_select
dw_cond dw_cond
cbx_all cbx_all
dw_list dw_list
st_2 st_2
st_list st_list
st_haldang st_haldang
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
dw_lot dw_lot
dw_head dw_head
dw_hold dw_hold
dw_haldang_list dw_haldang_list
dw_imhist dw_imhist
dw_haldang dw_haldang
dw_print dw_print
dw_print1 dw_print1
cbx_move cbx_move
dw_autoimhist dw_autoimhist
end type
global w_sal_02040 w_sal_02040

type variables
String LsIoJpNo,LsSuBulDate
String sSyscnfg_Yusin, sMinus, sValidMinus

String     is_gwgbn           // 그룹웨어 연동여부

Transaction SQLCA1				// 그룹웨어 접속용
String     isHtmlNo = '00024'	// 그룹웨어 문서번호
end variables

forward prototypes
public function integer wf_check_yusin (integer nrow, string smsg)
public function integer wf_delete_imhist ()
public function decimal wf_calc_jego (integer nrow)
public function integer wf_create_imhist ()
public subroutine wf_init ()
public function integer wf_calc_danga (integer nrow, string itnbr, string sorderspec)
public function integer wf_create_gwdoc (string jpno)
public function integer wf_add_haldang (string arg_orderno, decimal arg_outqty)
public function string wf_automove (integer arg_rownum, datawindow arg_imhistdw, string arg_date)
end prototypes

public function integer wf_check_yusin (integer nrow, string smsg);String sCvcod
Double dUseAmount, dStdAmt, dSumAmount

/* 여신금액 체크 */
If nRow <= 0 Then Return 0
If dw_haldang.RowCount() <= 0 Then Return 0

If ssyscnfg_yusin = '3' And nRow > 0 Then
	sCvcod = Trim(dw_haldang.GetItemString(1,"sorder_cvcod"))
	dUseAmount = sqlca.Fun_Erp100000030(gs_sabu,sCvcod, Left(is_today,6),Is_today);
	If sqlca.sqlcode <> 0 Then 
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Return -1
	End If
	
	dStdAmt = dw_haldang_list.GetItemNumber(nRow, 'credit_limit')
	If IsNull(dStdAmt) then dStdAmt = 0
	
	dSumAmount = dw_haldang.GetItemNumber(1, 'sum_amount')
	If IsNull(dSumAmount) then dSumAmount = 0
	
	If dStdAmt > 0 And ( dStdAmt - dUseAmount - dSumAmount < 0 ) Then
		If sMsg = 'Y' Then f_message_chk(133,'[초과금액 :' + String(Abs(dStdAmt - dUseAmount - dSumAmount),'#,##0')+ ']')
		Return 0
	End If
	
	sle_msg.Text = '여신금액 : ' + String(dStdAmt) + ' 기여신 : ' + string(duseamount) + ' 할당 : ' + string(dsumamount)
End If

Return 1
end function

public function integer wf_delete_imhist ();Long   iRowCount,k,iImhistRow,iAryCnt, nCnt, dInvQty
String sHoldNo,sSelectedOrder[], sIoJpNo, sIpno, sOutNo

sle_msg.text =""

If dw_imhist.Rowcount() <= 0 Then Return -1

iRowCount = dw_imhist.GetItemNumber(1,"yescount")
IF iRowCount <=0 THEN
	f_message_chk(36,'')
	Return -1
END IF

IF MessageBox("확 인","송장 취소 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

iAryCnt = 1

/* 출고확인 처리된 송장은 취소 불가 */
sIoJpNo = Left(Trim(dw_imhist.GetItemString(1,'iojpno')),12)
select count(io_date) into :nCnt
	from imhist
 where sabu = :gs_sabu and 
		 iojpno like :sIoJpNo||'%' and
		 io_date is not null AND
       iogbn = 'O04';

If nCnt > 0 Then
	RollBack;
	f_message_chk(57,'[제품출고 확인완료]')
	wf_init()
	Return -1
End If

iImhistRow = dw_imhist.RowCount()
For k = iImhistRow TO 1 STEP -1
	IF dw_imhist.GetItemString(k,"flag_choice") = 'Y' THEN
		
		SetNull(sIpNo)
		SetNull(sOutNo)
		
		/* 삭제할 전표번호 */
		sIoJpNo = Trim(dw_imhist.GetItemString(k,'iojpno'))
		
		/* 거래명세표 번호 삭제 */
		DELETE FROM IMHEAD
		 WHERE SABU = :gs_sabu AND
				 IOJP = :sIojpno;

		IF SQLCA.sqlcode <> 0	THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			ROLLBACK;
			f_Rollback();
			RETURN -1
		END IF		
		
		/* 할당번호가 없을 경우 이동입고->이동출고 전표를 찾는다 */
		sHoldNo = Trim(dw_imhist.GetItemString(k,"hold_no"))
		If IsNull(sHoldNo) Or sHoldNo = '' Then
			
			sIpNo = Trim(dw_imhist.GetItemString(k,"ip_jpno"))
			/* 이동입고전표에서 이동출고번호를 찾는다 */
			SELECT IP_JPNO INTO :sOutNo
			  FROM IMHIST
			 WHERE SABU = :gs_sabu AND
			       IOJPNO = :sIpNo;

			If sqlca.sqlcode <> 0 Or IsNull(sOutNo) Then
				ROLLBACK;
				f_message_chk(52,'[이동출고번호를 찾을 수 없습니다.!!]')
				Return -1
			End If
		
			/* 이동출고전표에서 할당번호를 찾는다 */
			SELECT HOLD_NO INTO :sHoldNo
			  FROM IMHIST
			 WHERE SABU = :gs_sabu AND
			       IOJPNO = :sOutNo;

			If sqlca.sqlcode <> 0 Or IsNull(sHoldNo) Then
				ROLLBACK;
				f_message_chk(52,'[할당번호를 찾을 수 없습니다.!!]')
				Return -1
			End If
		End If

		/* 분할출고된 경우 out_chk = '2' */
		select count( distinct substr(iojpno,1,12) ) into :dInvQty
		  from imhist
		 where sabu = :gs_sabu and
				 hold_no = :sHoldNo;
		If IsNull(dInvQty) Or dInvQty <= 0 Then 
			ROLLBACK;
			f_message_chk(32,'[취소할 송장이 없습니다]'+string(dinvqty))
			Return -1
		End If
		
		/* 직송 입고/출고전표 삭제 */
		DELETE FROM IMHIST 
		 WHERE SABU = :gs_sabu AND
				 IOJPNO IN ( :sIpno, :sOutNo );

		IF SQLCA.sqlcode <> 0	THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			ROLLBACK;
			f_Rollback();
			RETURN -1
		END IF
			
		/* 할당->송장 분할여부에 따라 */
		If dInvQty = 1 Then
			/* 출고승인을 '할당'으로 */
			UPDATE "HOLDSTOCK"
				SET "OUT_CHK" = '1'
			 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND ( "HOLDSTOCK"."HOLD_NO" = :sHoldNo );
		ElseIf dInvQty > 1 Then
			/* 출고승인을 '출고진행중'으로 */
			UPDATE "HOLDSTOCK"
				SET "OUT_CHK" = '2'
			 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND ( "HOLDSTOCK"."HOLD_NO" = :sHoldNo );
		End If
		
		/*울산이동출고자료 삭제 */
		/*2016.01.21 신동준*/
		/* 자동수불용 수불구분 변경(IM7, OM7) - BY SHINGOON 2016.02.26 */
		String ls_ipjpno
		ls_ipjpno = dw_imhist.GetItemString(k, 'ip_jpno')
		IF IsNull(ls_ipjpno) = False Then
			String ls_IM7jpno
			
			SELECT IP_JPNO
			INTO :ls_IM7jpno
			FROM IMHIST
			WHERE IOGBN = 'IM7'
				AND IOJPNO = :ls_ipjpno;
			
			DELETE FROM IMHIST WHERE IOGBN = 'IM7' AND IOJPNO = :ls_ipjpno;
			DELETE FROM IMHIST WHERE IOGBN = 'OM7' AND IOJPNO = :ls_IM7jpno;
		End If
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(32,'[송장취소 오류]')
			ROLLBACK;
			Return -1
		ELSE
			dw_imhist.DeleteRow(k)
		END IF

	END IF
Next

IF dw_imhist.Update() <> 1 THEN											/*입출고 저장*/
	ROLLBACK;
	Return -1
END IF
COMMIT;

Return 1

end function

public function decimal wf_calc_jego (integer nrow);/* 현재 데이타원도우상에서 재고 수량 */
String sItnbr ,sIspec
double dJegoQty, dChoiceQty
Long   ix

If nRow > dw_haldang.RowCount() Then Return 0

sItnbr = Trim(dw_haldang.GetItemString(nRow,'itnbr'))
sIspec = Trim(dw_haldang.GetItemString(nRow,'pspec'))
dJegoQty = dw_haldang.GetItemNumber(nRow,'jego_qty')

For ix = 1 To dw_haldang.RowCount()
	If dw_haldang.GetItemString(ix, 'flag_choice') <> 'Y' Then Continue
	If ix = nRow Then continue
	
	If sItnbr = Trim(dw_haldang.GetItemString(ix,'itnbr')) and &
	   sIspec = Trim(dw_haldang.GetItemString(ix,'pspec')) then
		
		dJegoQty -= dw_haldang.GetItemNumber(ix,'valid_qty')
	End If
Next

Return dJegoQty

end function

public function integer wf_create_imhist ();Integer iFunctionValue, iRowCount, k, iMaxIoNo, iCurRow, iAryCnt, hrow=0, Inrow, OutRow, ix
String  sCvcod, sArea, sSaupj, sDirgb, sHoldNo, sNewHoldNo, sNewHoldSeq
Decimal {5}  dOrdPrc, dValQty, dOrdAmt, dOrdQty, dVatAmt, dChkvat, dChkqty, dRstvat
Dec {4} dUrate, dWeight

String sQcgub, sNull, sOutIoNo, sInIoNo, sHoldGu, sItnbr, sPspec, sInStore, sOutStore
String sCustNapgi, sNaougu, sOrderNo, sAuto, sNappum, sIogbn, sLotsNo, sLoteNo, sLotChul
Long   dLotRow

SetNull(sNull)

If dw_haldang.RowCount() <= 0 Then Return -1

dw_insert.Reset()

sDirgb  = Trim(dw_cond.GetItemSTring(1,"dirgb"))

LsSuBulDate = Trim(dw_cond.GetItemString(1,'sudat'))

If f_datechk(LsSuBulDate) <> 1 Then
  f_message_chk(1200,'[발행일자]')
	Return -1
End If

///* 자동수불용 송장번호 채번 - by shingoon 2016.02.26 */
///* 수불 발생순서를 정렬하기 위함 - 입고->출고 */
//Integer li_seq
//li_seq = SQLCA.FUN_JUNPYO(gs_sabu, LsSuBulDate, 'C0')
//If li_seq < 0 Then
//	RollBack;
//	Return -1
//End If
//Commit;

/* 판매출고 송장번호 채번 */
iMaxIoNo = sqlca.fun_junpyo(gs_sabu,LsSuBulDate, 'C0')
IF iMaxIoNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
commit;
LsIoJpNo = LsSuBulDate + String(iMaxIoNo,'0000')

/* 이송인 경우 할당번호를 채번한다 */
If 	sDirGb = 'N' Then
	iMaxIoNo = sqlca.fun_junpyo(gs_sabu,LsSuBulDate, 'B0')		/* 할당번호 채번 */
	IF iMaxIoNo <= 0 THEN
		f_message_chk(51,'')
		ROLLBACK;
		Return -1
	END IF
	commit;
	
	sNewHoldNo = LsSuBulDate + String(iMaxIoNo,'0000')
End If

dw_imhist.Reset()
iAryCnt = 1

/* 거래처및 관할구역,검수구분(0:무검수,1:검수) */
sCvcod = dw_haldang.GetItemString(1, "sorder_cvcod")
SELECT "VNDMST"."SAREA", "VNDMST"."GUMGU"   INTO :sArea, :sNappum
  FROM "VNDMST"  
 WHERE "VNDMST"."CVCOD" = :sCvcod;

If IsNull(sNappum) Then sNappum = 'N'

/* 이동출고인 경우 */
If sDirgb = 'Y' Or sDirgb = 'N' Then
	/* 무검사 데이타 가져오기 */
   SELECT "SYSCNFG"."DATANAME"  
     INTO :sQcgub  
     FROM "SYSCNFG"  
    WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
          ( "SYSCNFG"."SERIAL" = 13 ) AND  
          ( "SYSCNFG"."LINENO" = '2' )   ;
	if sqlca.sqlcode <> 0 then
		sQcgub = '1'
	end if
End If

For k = 1 TO dw_haldang.RowCount()
	IF dw_haldang.GetItemString(k,"flag_choice") <> 'Y' THEN CONTINUE

	sSaupj   = Trim(dw_haldang.GetItemSTring(k,"saupj"))
	sOrderNo = Trim(dw_haldang.GetItemString(k,"order_no"))
	sIogbn 	= Trim(dw_haldang.GetItemString(k,"hold_gu"))

	sHoldGu = dw_haldang.GetItemString(k, "hold_gu")
	sItnbr  = dw_haldang.GetItemString(k, "itnbr")
	
	sOutStore = dw_haldang.GetItemString(k, "depot_no")	/* 출고창고 */
	sInStore  = dw_haldang.GetItemString(k, "house_no")	/* 납품창고 */
	
	sCustNapgi  = dw_haldang.GetItemString(k, "cust_napgi")
	sNaougu  = dw_haldang.GetItemString(k, "naougu")
	
	/* 출고단가 */
	dOrdPrc = dw_haldang.GetItemNumber(k,"sorder_order_prc")
	If IsNull(dOrdPrc) Then dOrdPrc = 0

	/* LOT 관리유무 : 출고의뢰시 LOT는 미선택 한다 */
	sLotChul = Trim(dw_haldang.GetItemString(k, "lotgub"))
	If Isnull(sLotChul) Or sLotChul <> 'Y' Then sLotChul = 'N'

	/* 출고시 lot no를 선택하지 하지 않고 승인시 lot 선택한다 */
	If sLotChul = 'Y' Then
		sLotChul = 'N'
	End If
		
	If sLotChul = 'N' Then
		dLotRow = 1
	Else
		sHoldNo = dw_haldang.GetItemString(k, "hold_no")
		dw_lot.SetFilter("hold_no = '" + sHoldNo + "'")
		dw_lot.Filter()
	
		dLotRow = dw_lot.RowCount()
	End If
	
	For ix = 1 To dLotRow

		/* Lot 별 출고할경우와 그렇지 않은 경우 */
		If sLotChul = 'N' Then
			/* 출고수량 */
			dValQty = dw_haldang.GetItemNumber(k,"choice_qty")
			If IsNull(dValQty) Then dValQty = 0
			
			sLotsNo = dw_haldang.GetItemString(k,"lotsno")
			sLoteNo = dw_haldang.GetItemString(k,"loteno")
			
//			sLotsNo  = '.'
					
			sPspec  = dw_haldang.GetItemString(k, "pspec")	// 등급
		Else
			/* LOT별 출고수량 */
			dValQty = dw_lot.GetItemNumber(ix,"hold_qty")
			If IsNull(dValQty) Then dValQty = 0
			
			sLotsNo = dw_lot.GetItemString(ix,"lotno")
			sLoteNo = ''
			
			sPspec = Trim(dw_lot.GetItemString(ix, 'pspec'))	// 등급
			If IsNull(sPspec) Or sPspec = '' Then sPspec = '.'
		End If
	
		/* 부가세 : 수주에 부가세가 포함될 경우 수량base로 배부하며 기타는 0.1을 곱해 계산한다 
			단 수주에 부가세가 입력된 경우에 미출고수량이 0인 경우에는 현재 발행된 부가세를 제외한 금액을
			입력한다. */
		dChkVat = 0
		dVatAmt = dw_haldang.GetItemNumber(k,"vatamt")
		dChkVat = dw_haldang.GetItemNumber(k,"vatamt")		
		If IsNull(dVatAmt) Then dVatAmt = 0
		If dVatAmt <> 0 Then
			dOrdQty = dw_haldang.GetItemNumber(k,"order_qty")
			dVatAmt = Truncate(dVatAmt / dOrdQty * dValQty, 0)
		Else
			/* Local 인 경우는 부가세 없음 */
			If Trim(dw_haldang.GetItemString(k,"sorder_oversea_gu"))  = '3' Then
				dVatAmt = 0
			Else
				dVatAmt = TrunCate(dOrdPrc * dValQty * 0.1, 0)
			End If
		End If
		
		SetNull(sInIoNo)
	
		/* 직송/이동출고인 경우 */
		Inrow  = 0
		OutRow = 0
		If sDirgb = 'Y' Or sDirgb = 'N' Then
			/* --------------------------------- */
			/* 창고이동 출고 전표 생성 			 */
			/* --------------------------------- */
			OutRow = dw_imhist.InsertRow(0)
			
			dw_imhist.SetItem(OutRow, "sabu",		gs_sabu)
			dw_imhist.SetItem(OutRow, "jnpcrt",		'004')		// 전표생성구분
			dw_imhist.SetItem(OutRow, "inpcnf",    'O')			// 입출고구분
			
			sOutIoNo = LsIoJpNo + String(OutRow,'000')			/* 출고 전표 번호 */
			dw_imhist.SetItem(OutRow, "iojpno", 	sOutIoNo	)
	
			/* 부서이동출고일경우 */
			If sIogbn = 'O31' Then
				dw_imhist.SetItem(OutRow, "iogbn",     'O31')
			Else
				dw_imhist.SetItem(OutRow, "iogbn",     'O05')
			End If
		
			dw_imhist.SetItem(OutRow, "sudat",		LsSuBulDate) // 수불일자=출고일자
			dw_imhist.SetItem(OutRow, "itnbr",		sItnbr) 		 // 품번
			dw_imhist.SetItem(OutRow, "pspec",		sPspec) 		 // 사양
			dw_imhist.SetItem(OutRow, "depot_no",	sOutStore)	 // 출고창고
					
			dw_imhist.SetItem(OutRow, "ioqty",		dValQty) 	 // 수불수량=출고수량
			dw_imhist.SetItem(OutRow, "ioreqty",	dValQty) 	 // 수불의뢰수량=출고수량
			dw_imhist.SetItem(OutRow, "insdat",		LsSuBulDate) // 검사일자=출고일자	
			dw_imhist.SetItem(OutRow, "iosuqty",	dValQty) 	 // 합격수량=출고수량
			
			dw_imhist.SetItem(OutRow, "ioprc",		 dOrdPrc )
			dw_imhist.SetItem(OutRow, "ioamt",		 TrunCate(dOrdPrc * dValQty,0))
			
			dw_imhist.SetItem(OutRow, "opseq",	   '9999')			// 공정코드
			dw_imhist.SetItem(OutRow, "io_confirm",'Y')				// 수불승인여부
			dw_imhist.SetItem(OutRow, "io_date",	LsSuBulDate)	// 수불승인일자=출고일자	
			dw_imhist.SetItem(OutRow, "ioreemp",	dw_haldang.GetItemString(k,"emp_id"))
			
			dw_imhist.SetItem(OutRow, "filsk",    dw_haldang.GetItemString(k,"itemas_filsk")) /* 재고관리구분 */
			dw_imhist.SetItem(OutRow, "botimh",	  'N')				// 동시출고여부
			dw_imhist.SetItem(OutRow, "itgu",     dw_haldang.GetItemString(k,"itemas_itgu"))  /* 구입형태 */
			dw_imhist.SetItem(OutRow, "outchk",   'N') 				// 출고의뢰완료
			dw_imhist.SetItem(OutRow, "pjt_cd",	  dw_haldang.GetItemString(k,"sorder_project_no")) /* 프로젝트 번호 */
			dw_imhist.SetItem(OutRow, "saupj",	  sSaupj)	/* 부가사업장 */
			
			/* 이송인 경우 이동출고 전표에 해당 할당번호를 입력 */
			dw_imhist.SetItem(OutRow, 'hold_no', dw_haldang.GetItemString(k, "hold_no"))
			
			/* 부서이동출고일경우 수주번호 */
			If sIogbn = 'O31' Then
				dw_imhist.SetItem(OutRow, "cvcod",	  sCvcod)
				dw_imhist.SetItem(OutRow, "order_no", sOrderNo)
			Else
				dw_imhist.SetItem(OutRow, "cvcod",	  sInStore) 	// 거래처창고=입고처
				dw_imhist.SetItem(OutRow, "field_cd", sOrderNo)		/* 수주번호 */
			End If
			
		
			/* --------------------------------- */
			/* 창고이동 입고 전표 생성 			 */
			/* --------------------------------- */
			InRow = dw_imhist.InsertRow(0)						
			
			dw_imhist.SetItem(InRow, "sabu",		gs_sabu)
			dw_imhist.SetItem(InRow, "jnpcrt",	'004')			// 전표생성구분
			dw_imhist.SetItem(InRow, "inpcnf",   'I')				// 입출고구분
	
			sInIoNo = LsIoJpNo+String(InRow,'000')					/* 입고 전표 번호 */
			dw_imhist.SetItem(InRow, "iojpno", 	sInIoNo	)
	
			/* 부서이동출고일경우 수불구분 */
			If sIogbn = 'O31' Then
				dw_imhist.SetItem(InRow, "iogbn",    'I31')
			Else
				dw_imhist.SetItem(InRow, "iogbn",    'I11')
			End If
			
			dw_imhist.SetItem(InRow, "sudat",	 LsSuBulDate)	// 수불일자=출고일자
			dw_imhist.SetItem(InRow, "itnbr",	 sItnbr ) 		// 품번
			dw_imhist.SetItem(InRow, "pspec",	 sPspec ) 		// 사양		
			dw_imhist.SetItem(InRow, "depot_no", sInStore) 		// 기준창고=입고창고
			dw_imhist.SetItem(InRow, "cvcod",	 sOutStore) 	// 거래처창고=출고창고
			dw_imhist.SetItem(InRow, "opseq",	 '9999')			// 공정코드	
			dw_imhist.SetItem(InRow, "ioreqty",	 dValQty) 		// 수불의뢰수량=출고수량
			
			dw_imhist.SetItem(InRow, "ioprc",	 dOrdPrc )
			dw_imhist.SetItem(InRow, "ioamt",	 TrunCate(dOrdPrc * dValQty,0))
			
			dw_imhist.SetItem(InRow, "insdat",	 LsSuBulDate)	// 검사일자=출고일자	
			dw_imhist.SetItem(InRow, "qcgub",	 sQcgub)			// 검사방법=> 무검사
			dw_imhist.SetItem(InRow, "iosuqty",	 dValQty) 		// 합격수량=출고수량		
			dw_imhist.SetItem(InRow, "filsk",    dw_haldang.GetItemString(k,"itemas_filsk")) // 재고관리유무
			dw_imhist.SetItem(InRow, "io_confirm", 'Y')			// 수불승인여부	
			dw_imhist.SetItem(InRow, "ioqty",  	 dValQty) 		// 수불수량=입고수량
			dw_imhist.SetItem(InRow, "io_date",  LsSuBulDate)	// 수불승인일자=입고의뢰일자
			dw_imhist.SetItem(InRow, "io_empno", sNull)			// 수불승인자=NULL
			dw_imhist.SetItem(InRow, "botimh",	'N')				// 동시출고여부
			dw_imhist.SetItem(InRow, "itgu",     dw_haldang.GetItemString(k,"itemas_itgu")) 	// 구입형태
			dw_imhist.SetItem(InRow, "ioredept", dw_haldang.GetItemString(k,"sorder_deptno"))	// 수불의뢰부서=수주영업부서
			dw_imhist.SetItem(InRow, "ioreemp",	 dw_haldang.GetItemString(k,"emp_id"))			// 수불의뢰담당자=담당자	
	
			dw_imhist.SetItem(InRow, "ip_jpno",  sOutIoNo)											   // 입고전표번호=출고번호
			dw_imhist.SetItem(InRow, "saupj",    sSaupj)		/* 부가사업장 */
	
	//			dw_imhist.SetItem(InRow, "lclgbn",    'V')	           	/* 일반매출(내수)는 V , 일반매출(수출)는 L */
	//
			/* 이송인 경우 납품창고 기준으로 할당생성 ,부서이동출고일 경우는 생성안함 */
			If sDirgb = 'N' And sIogbn <> 'O31'	Then
				sHoldNo = dw_haldang.GetItemString(k, "hold_no")
			
				hrow = dw_insert.InsertRow(0)
				sNewHoldSeq = sNewHoldNo + String(hrow,'000')		/* 할당 번호 */
				
				dw_insert.SetItem(hRow, "sabu",			gs_sabu)
				dw_insert.SetItem(hRow, "hold_no",		sNewHoldSeq)
				dw_insert.SetItem(hRow, "hold_date",	LsSubulDate)
				dw_insert.SetItem(hRow, "hold_gu",		sHoldgu)
				dw_insert.SetItem(hRow, "itnbr",			sItnbr)
				dw_insert.SetItem(hRow, "pspec",			sPspec)
				dw_insert.SetItem(hRow, "hold_qty",		dValQty)
				dw_insert.SetItem(hRow, "addqty",		0)
				dw_insert.SetItem(hRow, "isqty",			0)
				dw_insert.SetItem(hRow, "unqty",			0)
				dw_insert.SetItem(hRow, "hold_store",	sNull)
				dw_insert.SetItem(hRow, "out_store",	sInStore)
				dw_insert.SetItem(hRow, "req_dept",		sCvcod)
				dw_insert.SetItem(hRow, "rqdat",			sCustNapgi)
				dw_insert.SetItem(hRow, "isdat",			sNull)
				dw_insert.SetItem(hRow, "order_no",		sNull)
				dw_insert.SetItem(hRow, "out_chk",		'1')
				dw_insert.SetItem(hRow, "cancelqty",	0)
				dw_insert.SetItem(hRow, "in_store",		sInStore)
				dw_insert.SetItem(hRow, "hosts",			'N')
				dw_insert.SetItem(hRow, "naougu",		sNaougu)
				dw_insert.SetItem(hRow, "opseq",			'9999')
				dw_insert.SetItem(hRow, "pjt_cd",		sOrderNo)	/* 수주번호 */
			End If
		End If
	
		/* 직송과 직납 또는 이송후 납품인 경우만 판매출고 전표를 생성한다 */
		If sDirgb = 'Y' Or sDirgb = 'D' Or sDirgb = 'S' Then
			/* 납품창고 기준으로 수불구분에 따른 출고전표 생성 */
			iCurRow = dw_imhist.InsertRow(0)
			
			dw_imhist.SetItem(iCurRow,"sabu",       gs_sabu)
			
			sOutIoNo = LsIoJpNo + String(iCurRow,'000')
						
			dw_imhist.SetItem(iCurRow,"iojpno", 	 sOutIoNo)
			
			dw_imhist.SetItem(iCurRow,"iogbn",      sHoldGu)
			dw_imhist.SetItem(iCurRow,"sudat",      LsSuBulDate)
			dw_imhist.SetItem(iCurRow,"itnbr",      sItnbr)
			dw_imhist.SetItem(iCurRow,"itemas_itdsc",dw_haldang.GetItemString(k,"itemas_itdsc"))
			dw_imhist.SetItem(iCurRow,"itemas_ispec",dw_haldang.GetItemString(k,"itemas_ispec"))
			
			dw_imhist.SetItem(iCurRow,"pspec",      sPspec)
			
			dw_imhist.SetItem(iCurRow,"depot_no",   dw_haldang.GetItemString(k,"in_store"))
			dw_imhist.SetItem(iCurRow,"cvcod",	    dw_haldang.GetItemString(k,"sorder_cvcod"))
	
			dw_imhist.SetItem(iCurRow,"sarea",	    sArea)
			
			/* 단가 및 금액 */
			dw_imhist.SetItem(iCurRow,"ioprc",		 dw_haldang.GetItemNumber(k,"sorder_order_prc"))
			dw_imhist.SetItem(iCurRow,"ioamt",		 TrunCate(dOrdPrc * dValQty,0))
			
			/* 외화 단가 및 금액 처리 2004.07.22 ljj */
			dw_imhist.SetItem(iCurRow,"yebi2",	    dw_haldang.GetItemString(k,"sorder_head_curr"))	// 통화단위
			dw_imhist.SetItem(iCurRow,"dyebi1",		 dw_haldang.GetItemNumber(k,"sorder_head_wrate"))  // 원화환율
			dw_imhist.SetItem(iCurRow,"dyebi2",		 dw_haldang.GetItemNumber(k,"sorder_itmprc"))		// 외화단가
			dw_imhist.SetItem(iCurRow,"foramt",		 TrunCate(dw_haldang.GetItemNumber(k,"sorder_itmprc") * dValQty,2)) // 외화금액
			
			// 미화금액
			dUrate  = dw_haldang.GetItemNumber(k,"sorder_head_urate")
			dWeight = dw_haldang.GetItemNumber(k,"sorder_head_weight")
			If IsNull(dUrate) Or dUrate = 0 Then dUrate = 1
			If IsNull(dWeight) Or dWeight = 0 Then dWeight = 1
			dw_imhist.SetItem(iCurRow,"foruamt",	 Truncate((dw_imhist.GetITEMnUMBER(icurrow, 'foramt') * dUrate )/dWeight,2))
	
			/* 일반매출(내수)는 V , 일반매출(수출)는 L */
			If Trim(dw_haldang.GetItemString(k,"sorder_oversea_gu"))  = '3' Then
				dw_imhist.SetItem(iCurRow, "lclgbn",    'L')
			Else
				dw_imhist.SetItem(iCurRow, "lclgbn",    'V')
			End If

			dw_imhist.SetItem(iCurRow,"insdat",     LsSuBulDate)
			dw_imhist.SetItem(iCurRow,"ioreqty",	 dValQty)
			dw_imhist.SetItem(iCurRow,"iosuqty",	 dValQty)
			If sDirgb = 'D' Or sDirgb = 'S'  Then	/* 직납인 경우만 할당번호 입력 */
				dw_imhist.SetItem(iCurRow,"hold_no",	 dw_haldang.GetItemString(k,"hold_no"))
			End If
			
			/* 이송후 출하일 경우 수주번호를 pjt_cd */
			If sDirgb = 'S' Then
				dw_imhist.SetItem(iCurRow,"order_no",	 dw_haldang.GetItemString(k,"pjt_cd"))
			Else
				dw_imhist.SetItem(iCurRow,"order_no",	 dw_haldang.GetItemString(k,"order_no"))
			End If
	
			dw_imhist.SetItem(iCurRow,"filsk",   	 dw_haldang.GetItemString(k,"itemas_filsk")) /* 재고관리구분 */
			dw_imhist.SetItem(iCurRow,"itgu",	    dw_haldang.GetItemString(k,"itemas_itgu"))  /* 구입형태 */
			dw_imhist.SetItem(iCurRow,"bigo",	    dw_haldang.GetItemString(k,"sorder_order_memo"))
			dw_imhist.SetItem(iCurRow,"pjt_cd",	    dw_haldang.GetItemString(k,"sorder_project_no")) /* 프로젝트 번호 */
			dw_imhist.SetItem(iCurRow,"outchk",	    'N')
			dw_imhist.SetItem(iCurRow,"jnpcrt",	    '004')	/* 전표생성구분 */
	
			dw_imhist.SetItem(iCurRow,"ioredept",	 dw_haldang.GetItemString(k,"sorder_deptno"))
			dw_imhist.SetItem(iCurRow,"ioreemp",	 dw_haldang.GetItemString(k,"emp_id"))
			dw_imhist.SetItem(iCurRow,"opseq",	    '9999')
			dw_imhist.SetItem(iCurRow,"facgbn",	    '.')	// 공장구분
			dw_imhist.SetItem(iCurRow,"gungbn",	    'D')		// 주야구분
			dw_imhist.SetItem(iCurRow,"saupj",	    sSaupj)	/* 부가사업장 */
			dw_imhist.SetItem(iCurRow,"ip_jpno",    sInIoNo)
	
			/* 수주에 Vat금액이 입력된 경우 현재의 송장수량이 최종인 경우 기 발행된 부가세 금액의 잔액을
				직접 입력한다. */ 
			dChkqty = 0
			dRstVat = 0
			if dChkVat > 0 then
				Select order_qty - (invoice_qty + :dvalqty) into :dchkqty  From sorder
				 Where sabu = :gs_sabu And order_no = :sOrderNo;
				If dchkqty <= 0 then
					Select sum(dyebi3) into :dRstvat From Imhist
					 Where sabu = :gs_sabu And order_no = :sOrderNo And iogbn = :sholdGu;
					if IsNull(dRstVat) then dRstVat = 0
					dVatamt = dChkVat - dRstVat
				end if
			End if
			dw_imhist.SetItem(iCurRow,"dyebi3",	    dVatAmt)/* 부가세 */
	
			/* 이송후 직납인 경우 제외 */
			If sDirgb <> 'S' Then
				dw_imhist.SetItem(iCurRow,"lotsno",		 sLotsNo)
				dw_imhist.SetItem(iCurRow,"loteno",		 sLoteNo)
			End If
	
	//			/* 직송인 경우 이동출고/입고 전표에 해당 판매출고번호를 입력 */
	//			If sDirgb = 'Y' Then
	//				dw_imhist.SetItem(OutRow, 'ip_jpno', sOutIoNo)
	//				dw_imhist.SetItem(InRow,  'ip_jpno', sOutIoNo)
	//			End If
						
			/* 자동승인여부 */
			sAuto = Trim(dw_haldang.GetItemString(k,"email"))
			If IsNull(sAuto) Or sAuto = '' Then sAuto = 'N'
			
			If sAuto = 'Y' Then
				dw_imhist.SetItem(iCurRow,"ioqty",		 dValQty)
				dw_imhist.SetItem(iCurRow,"io_date",    LsSuBulDate)
				dw_imhist.SetItem(iCurRow,"io_empno",	 dw_haldang.GetItemString(k,"emp_id"))
				dw_imhist.SetItem(iCurRow, "io_confirm",'Y')
				
				/* 검수일자 사용안할 경우, 수출일 경우 */
				If sNappum = 'N'  Then
					dw_imhist.SetItem(iCurRow,"yebi1",   LsSuBulDate)
				End If
			Else
				dw_imhist.SetItem(iCurRow,"ioqty",		 0)
				dw_imhist.SetItem(iCurRow,"io_date",    sNull)
				dw_imhist.SetItem(iCurRow,"io_empno",	 sNull)
				
				dw_imhist.SetItem(iCurRow, "io_confirm",'N')
			End If
		End If
		
		/* ----------------------------------------------------- */
		/* 울산이동출고 처리 2016.01.21 신동준 			 */
		/* 울산이동출고가 체크 되어있고 사업장이 장안일경우 실행 			 */
		/* ---------------------------------------------------- */		
//		If cbx_move.Checked = True And  sSaupj = '20' Then		
		If cbx_move.Checked = True Then
			String ls_autojpno
//			ls_autojpno = wf_automove(iCurRow, dw_imhist, LsSuBulDate, li_seq)
			ls_autojpno = wf_automove(iCurRow, dw_imhist, LsSuBulDate)
			If ls_autojpno <> '-1' Then
				dw_imhist.SetItem(iCurRow, "ip_jpno",	  ls_autojpno)
			End If
		End If

		iAryCnt = iAryCnt + 1
	Next	/* Lot 별 재고 관리시 */
	
	/* 할당상태변경 */
	dw_haldang.SetItem(k,'out_chk', '2')		/* 출고의뢰 */		
	
Next

// 헤더정보를 저장
dw_head.SetItem(1, 'sabu', gs_sabu)
dw_head.SetItem(1, 'hold_no', LsIoJpNo)

/* 할당 저장 */
IF dw_haldang.Update() = 1 Then
Else
	ROLLBACK;
	Messagebox("할당저장", "할당저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
	Return -1
End If

/*울산이동출고 저장*/
If cbx_move.Checked = True And  sSaupj = '20' Then
	IF dw_autoimhist.Update() = 1 Then
	Else
		ROLLBACK;
		Messagebox("입출고저장", "울산이동출고 저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
		Return -1
	End If
End If

IF dw_imhist.Update() = 1 Then
Else
	ROLLBACK;
	Messagebox("입출고저장", "입출고저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
	Return -1
End If

If dw_head.Update() <> 1 Then
  	f_message_chk(41,string(sqlca.sqlcode)+sqlca.sqlerrtext)
  	rollback;
  	Return -1
END IF

/* 이동출고시 할당 */
If dw_insert.RowCount() > 0 Then
	IF dw_insert.Update() <> 1 THEN
	   Messagebox("이동 출고 할당저장", "이동출고할당저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
		ROLLBACK;
		Return -1
	End If
End If

/* 거래명세표 번호 출력 */
sqlca.ERP000000580(gs_sabu, LsIoJpNo)
IF sqlca.sqlcode <> 0 Then
	f_message_chk(32,'')
	ROLLBACK;
	Return -1
END IF
COMMIT;

If MessageBox('거래명세표 출력', '거래명세표를 출력 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then
Else
	String ls_jpno
	ls_jpno = LsIoJpNo
	dw_print.Retrieve(ls_jpno)
	OpenWithParm(w_print_options, dw_print)
	
	MessageBox('출고전표 출력', '출고전표를 출력합니다.')
	dw_print1.Retrieve(ls_jpno)
	
	String ls_carno, ls_name
	ls_carno = dw_cond.GetItemString(1, 'carno')
	If Trim(ls_carno) = '' OR IsNull(ls_carno) Then
	Else
		SELECT RFNA1
		  INTO :ls_name
        FROM REFFPF
       WHERE RFCOD = '2R'
         AND RFGUB = :ls_carno;
		dw_print1.Modify("carno1.Text = '" + ls_carno + "'")
		dw_print1.Modify("carno2.Text = '" + ls_carno + "'")
		dw_print1.Modify("carno3.Text = '" + ls_carno + "'")
		dw_print1.Modify("name1.Text = '" + ls_name + "'")
		dw_print1.Modify("name2.Text = '" + ls_name + "'")
		dw_print1.Modify("name3.Text = '" + ls_name + "'")
	End If	
	
	OpenWithParm(w_print_options, dw_print1)
	
//	OpenWithParm(w_print_preview, dw_print)
End If

//테스트후 사용 
////IMHIST내역 조회(G/W연동)
//IF dw_hold.retrieve(gs_sabu, LsIoJpNo, gs_saupj) > 0 THEN
//	// 구매의뢰 연동시
//	IF is_gwgbn = 'Y' then
//		wf_create_gwdoc(LsIoJpNo)	
//	End If
//END IF

/* 송장처리 완료된 경우 발행 여부에 따라 출고송장을 출력한다*/
//cb_print.TriggerEvent(Clicked!)

Return 1
end function

public subroutine wf_init ();String sNull

SetNull(sNull)

rollback;

dw_imhist.Reset()
dw_haldang.Reset()
dw_insert.Reset()   // 출력물 

dw_head.Reset()
dw_head.InsertRow(0)

dw_cond.SetItem(1, "sudat", is_today)

dw_cond.Modify('depot_no.protect = 0')
dw_cond.Modify('iogbn.protect = 0')

IF sModStatus = 'I' THEN
	st_list.Text = '할당 내역'
	st_haldang.Text = '할당현황'
	
	p_print.Enabled = True
	dw_haldang.Visible = True

	p_search.Enabled = False
	p_search.PictureName = 'C:\erpman\image\저장_d.gif'
	
	dw_cond.Modify('iojpno.protect = 1')

	dw_cond.SetFocus()
	dw_cond.SetColumn("saupj")
ELSE
	st_list.Text = '송장 내역'
	st_haldang.Text = '송장현황'
	
	p_print.Enabled = False
	dw_imhist.Visible  = True
	dw_haldang.Visible = False

	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\저장_up.gif'
	
	dw_cond.Modify('iojpno.protect = 0')

	dw_cond.SetFocus()
	dw_cond.SetColumn("iojpno")
END IF

/* 할당현항,송장현황 데이타원도우 */
String sParsal

dw_haldang_list.SetRedraw(False)
If sModStatus = 'I' Then
	/* 분할출고 여부 */
//	select substr(dataname,1,1) into :sParsal
//	  from syscnfg
//	 where sysgu = 'S' and
//			 serial = 7 and
//			 lineno = 15;
//	If IsNull(sParsal) Then sParsal = 'N'
//	
//	If sParsal = 'Y' Then
//		dw_haldang.Modify('valid_qty.protect = 0')
//	Else
//		dw_haldang.Modify('valid_qty.protect = 1')
//	End If

	dw_haldang_list.Reset()
	dw_haldang_list.DataObject = 'd_sal_020404'
	dw_haldang_list.SetTransObject(sqlca)
Else
	dw_haldang_list.Reset()
	dw_haldang_list.DataObject = 'd_sal_020405'
	dw_haldang_list.SetTransObject(sqlca)
End If
dw_haldang_list.SetRedraw(True)

dw_cond.SetItem(1, 'dirgb',  'D')
dw_cond.SetItem(1, 'iojpno',  sNull)
dw_cond.SetItem(1, 'cvcod',   sNull)
dw_cond.SetItem(1, 'vndname', sNull)

/* 송장번호,수불일자 clear */
SetNull(LsIoJpNo)
SetNull(LsSubulDate)

ib_any_typing = False
end subroutine

public function integer wf_calc_danga (integer nrow, string itnbr, string sorderspec);/* 판매단가및 할인율 */
/* --------------------------------------------------- */
/* 가격구분 : 2000.05.16('0' 추가됨)                   */
/* 0 - 수량별 할인율 등록 단가              		       */ 
/* 1 - 특별출하 거래처 등록 단가                       */ 
/* 2 - 이벤트 할인율 등록 단가                    	    */ 
/* 3 - 거래처별 제품단가 등록 단가                     */ 
/* 4 - 거래처별 할인율 등록 단가                       */ 
/* 5 - 품목마스타 등록 단가                  		    */ 
/* 9 - 미등록 단가                         		       */ 
/* --------------------------------------------------- */
string sOrderDate, sCvcod,  sSalegu, sOutgu 
int    iRtnValue = -1, iRtn
double ditemprice,ddcrate, dQtyPrice, dQtyRate,dItemQty

sOrderDate 	= dw_cond.GetItemString(1,"sudat")
sCvcod 	  	= dw_haldang.GetItemString(nRow,"sorder_cvcod")

dItemQty		= dw_haldang.GetItemDecimal(nRow,"valid_qty")
/* 수량 */
IF 	IsNull(dItemQty) THEN dItemQty =0


/* 무상출고일 경우 */
//sSalegu 	= dw_haldang.GetItemString(nRow, 'amtgu')
//If 	sSaleGu = 'N' Then
//	dItemPrice = sqlca.Fun_Erp100000025(Itnbr,sOrderSpec, sOrderDate) 
//	If 	IsNull(dItemPrice) Then dItemPrice = 0
//
//	dw_haldang.SetItem(nRow, 'sorder_order_prc', dItemPrice)
//	Return 0
//End If
		
/* 수량이 0이상일 경우 수량base단가,할인율을 구한다 */
If 	dItemQty > 0 Then
	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, Itnbr, dItemQty, &
                                    'WON', dQtyPrice, dQtyRate) 
End If

If 	IsNull(dQtyPrice) 	Then dQtyPrice = 0
If 	IsNull(dQtyRate)		Then dQtyRate = 0

/* 판매 기본단가,할인율를 구한다 */
iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sOrderDate, sCvcod, Itnbr, sOrderSpec, &
												'WON','1', dItemPrice, dDcRate) 

/* 특출단가나 거래처단가일경우 수량별 할인율은 적용안함 */
If 	iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0

/* 기본할인율 적용단가 * 수량별 할인율 */
If 	dQtyRate <> 0 Then
	
	dItemPrice = dItemPrice * (100 - dQtyRate)/100
	
	/* 수소점2자리 */
	dItemPrice = Truncate(dItemPrice , 2) 
	
	/* 할인율 재계산 */
   	iRtn = sqlca.fun_erp100000014(itnbr,sOrderSpec, dItemPrice, sOrderDate, 'WON', '1', dDcRate)
   	If 	iRtn = -1 Then dDcRate = 0
End If

If 	IsNull(dItemPrice) 	Then dItemPrice = 0
If 	IsNull(dDcRate) 	 	Then dDcRate = 0

/* 단가 : 절삭 */
dItemPrice = truncate(dItemPrice,0)

Choose Case iRtnValue
	Case IS < 0 
		f_message_chk(41,'[단가 계산]'+string(irtnvalue))
		Return 1
	Case Else
		dw_haldang.SetItem(nRow,"sorder_order_prc",	dItemPrice)
		
End Choose

Return 0
end function

public function integer wf_create_gwdoc (string jpno);String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue,b
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html,j, loops
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus
long ll_FLength, dgwSeq, lRow, bytes_read
dec  lvalue

// HTML 문서를 읽어들인다
ll_FLength = FileLength("EAFolder_00024.html")
li_FileNum = FileOpen("EAFolder_00024.html", StreamMode!)

IF ll_FLength < 32767 THEN
    loops = 1
ELSE
	IF Mod(ll_FLength, 32765) = 0 THEN
		loops = ll_FLength / 32765
	ELSE
		loops = (ll_FLength / 32765) + 1
	END IF
END IF

FOR j = 1 to loops
	bytes_read = FileRead(li_FileNum, b)
	scall = scall + b
NEXT	
		
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 존재하지 않습니다.!!')
	Return -1
End If

// 그룹웨어 문서 번호 
select gwno into :sGwNo
  from imhead where sabu =: gs_sabu and iojp like :jpno||'%';
  
// 그룹웨어 연동시 문서번호 채번...필요한 경우 함
If IsNull(sGwNo) Or Trim(sGwNo) = '' Then
	sDate  = f_today() //'20050501'
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[전자결재]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// 반복행을 찾는다
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')
If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail에 대해서 반복해서 값을 setting한다
	ix = 1
	do 
		nPos = Pos(sRepeat, '(_SEQ_)') 
		sValue = Trim(dw_hold.GetItemString(ix,'hold_seq'))
		If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, sValue)	
		
		nPos = Pos(sDetRow, '(_ITNBR_)')
		sValue = Trim(dw_hold.GetItemString(ix,'holdstock_itnbr'))
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_ITDSC_)')
		sValue = Trim(dw_hold.GetItemString(ix,'itemas_itdsc'))
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue )
		
		nPos = Pos(sDetRow, '(_ISPEC_)')
		sValue = Trim(dw_hold.GetItemString(ix,'itemas_ispec'))
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_SHTNM_)')
		sValue = Trim(dw_hold.GetItemString(ix,'shtnm'))
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_LOT_)')
		sValue = Trim(dw_hold.GetItemString(ix,'imhist_lotsno'))
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, sValue)
		
		nPos = Pos(sDetRow, '(_QTY_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, String(dw_hold.GetItemNumber(ix,'isqty'),'#,##0.00'))
		
		nPos = Pos(sDetRow, '(_BQTY_)')  
		lvalue = 0
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, string(lvalue,'#,##0.00'))
		
		nPos = Pos(sDetRow, '(_BG_)')
		sValue = ''
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 6, sValue)
		
		sDetail = sDetail + sDetRow
		ix = ix + 1
	loop while (ix <= dw_hold.RowCount() )

	sCall = sHeader + sDetail + sFooter
End If

// Detail외 매크로 내역을 치환한다
nPos = Pos(sCall, '(_IOGBN_)')
sValue = Trim(dw_hold.GetItemString(1,'gubun'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)
		
nPos = Pos(sCall, '(_IOJPNO_)')
sValue = Trim(dw_hold.GetItemString(1,'hold_no'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)

nPos = Pos(sCall, '(_HDATE_)')
sValue = Trim(dw_hold.GetItemString(1,'holdstock_hold_date'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_CY_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_cv'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 6, sValue)

nPos = Pos(sCall, '(_VESSEL_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_vessel'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)

nPos = Pos(sCall, '(_REQCOD_)')
sValue = Trim(dw_hold.GetItemString(1,'vndmst_req_cvnas'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)


nPos = Pos(sCall, '(_RQDAT_)')
sValue = Trim(dw_hold.GetItemString(1,'holdstock_rqdat'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)


nPos = Pos(sCall, '(_CNTRNO_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_cntrno'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)


nPos = Pos(sCall, '(_CVCOD_)')
sValue = Trim(dw_hold.GetItemString(1,'vndmst_hold_cvnas'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)


nPos = Pos(sCall, '(_ORDNO_)')
sValue = Trim(dw_hold.GetItemString(1,'holdstock_order_no'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_EBOXYN_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_eboxyn'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)

nPos = Pos(sCall, '(_SEALNO_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_sealno'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)

nPos = Pos(sCall, '(_INSYN_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_insyn'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_BIGO_)')
sValue = Trim(dw_hold.GetItemString(1,'holdhead_bigo'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 8, sValue)

nPos = Pos(sCall, '(_PDATA_)')
sValue = '(일반 : ' + String(dw_hold.GetItemNumber(1,'holdhead_pan01')) + ')  (훈증 : ' + String(dw_hold.GetItemNumber(1,'holdhead_pan02')) + ') (회수 : ' + String(dw_hold.GetItemNumber(1,'holdhead_pan03')) + ')'
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)
///////////////////////////////////////////////

If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 생성되지 않았습니다.!!')
	Return -1
End If

//EAERPHTML에 등록되었는지 확인
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// 기존 미상신 내역이 있으면 삭제
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// 그룹웨어 EAERPHTML TABLE에 기안내용을 INSERT한다
	INSERT INTO EAERPHTML
			  ( CSCODE, KEY1,  ERPEMPCODE, GWDOCGUBUN, SENDINGGUBUN, HTMLCONTENT, STATUS)
	 VALUES ( 'BDS',  :sGWno, Lower(:gs_userid),:isHtmlNo,    '1',   :sCall, '0') using sqlca1;
	If sqlca1.sqlcode <> 0 Then
		MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
		RollBack USING SQLCA1;
		Return -1
	End If
	
	COMMIT USING SQLCA1;
Else
	MessageBox('확인','기상신된 내역입니다.!!')
	Return 0
End If

// 기안서 상신
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//그룹웨어 문서번호
SetNull(gs_codename)		 			//제목입력받음(erptitle)
Open(w_groupware_browser)

//EAERPHTML에 상신되었는지 확인
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00024_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('결재상신','결재가 상신되었습니다.')
Else
	MessageBox('결재상신','결재가 상신되지 않았습니다.')
	Return -1
End If

// 그룹웨어 문서번호를 테이블에 저장한다
update imhead
   set gwno = :sGWno
 where sabu =: gs_sabu 
   and iojp like :jpno||'%';
commit;  
  
w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
end function

public function integer wf_add_haldang (string arg_orderno, decimal arg_outqty);///* 주문수량을 초과하는 출고시 할당량 추가 - 2006.11.03 - 송병호 */
//decimal	dvalidqty, dgapqty
//
//select unqty+addqty into :dvalidqty from holdstock
// where sabu = :gs_sabu and order_no = :arg_orderno ;
//
//if sqlca.sqlcode = 0 then
//
//	dgapqty = dvalidqty - arg_outqty
//	if dgapqty < 0 then
//		update holdstock set addqty = addqty - :dgapqty
//		 where sabu = :gs_sabu and order_no = :arg_orderno ;
//		
//
//		
//		If dItemQty > lOldQty Then
//			MessageBox('확 인','[출고수량은 할당잔량 이상으로 할 수 없습니다]~r~n~r~n'+'할당잔량 = ' + string(loldqty))
//			Return 1
//		End If
//
//
return 1
end function

public function string wf_automove (integer arg_rownum, datawindow arg_imhistdw, string arg_date);/*출고처리시 자동으로 장안에서 출고처리, 울산에서 입고처리 하기위한 함수, 입고 전표번호를 리턴한다.
   장안에서 일반출고할 행을 가져와서 자동출고 처리한다.
	arg_rownum : 복사할 행
	arg_imhistdw : 복사할 데이터 윈도우
	arg_date : 출고일자*/

If IsNull(arg_date) Or arg_date = '' Then
	MessageBox('확인', '출고일자를 확인해 주십시요. (automove)')
	Return '-1'
End If
	
String ls_chulStock, ls_chIogbn, ls_chIojpno //출고처리 변수
String ls_ipStock, ls_ipIogbn, ls_ipIojpno //입고처리 변수
Int li_seq, li_chRow, li_ipRow

String ls_cvgu, ls_ipjogun, ls_jumaechul, ls_juhandle, ls_soguan

ls_chulStock = arg_imhistdw.GetItemString(arg_rownum, 'depot_no')

SELECT CVGU, IPJOGUN, JUMAECHUL, JUHANDLE, SOGUAN
INTO :ls_cvgu, :ls_ipjogun, :ls_jumaechul, :ls_juhandle, :ls_soguan
FROM VNDMST
WHERE CVCOD = :ls_chulStock
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('출고오류', '울산이동출고 창고조회 오류 1')
    Return '-1'
End If

//출고창고의 사업장이 울산일경우 울산이동출고처리 하지 않는다.
If ls_ipjogun = '10' Then
	Return '-1'
End If

SELECT CVCOD
INTO :ls_ipStock
FROM VNDMST
WHERE NVL(CVGU, '.') LIKE NVL(:ls_cvgu, '%')
    AND NVL(IPJOGUN, '.') = '10'
    AND NVL(JUMAECHUL, '.') LIKE NVL(:ls_jumaechul, '%')
    AND NVL(JUHANDLE, '.') LIKE NVL(:ls_juhandle, '%')
    AND NVL(SOGUAN, '.') LIKE NVL(:ls_soguan, '%')
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('출고오류', '울산이동출고 창고조회 오류 2')
    Return '-1'
End If

//SELECT CVCOD
//INTO :ls_ipStock
//FROM VNDMST
//WHERE CVGU = '5'
//    AND IPJOGUN = '10'
//    AND JUMAECHUL = '2'    
//    AND JUHANDLE = '1'
//    AND SOGUAN = '1';
//	 
//IF SQLCA.SQLCODE <> 0 THEN
//	MessageBox('출고오류', '울산이동출고 창고조회 오류')
//	Return '-1'
//End If
	 
//ls_chulStock = 'Z07'	//장안 제품창고 (자동 출고창고)
//ls_ipStock = 'Z01' //울산 제품창고 (자동 입고창고)

//공장간 이동입,출고 수불구분
/* 자동수불용 수불구분 변경(IM7, OM7) - BY SHINGOON 2016.02.26 */
ls_chIogbn = 'OM7'
ls_ipIogbn = 'IM7'

li_seq = SQLCA.FUN_JUNPYO(gs_sabu, arg_date, 'C0')
If li_seq < 0 Then
	RollBack;
	Return '-1'
End If
Commit;

String ls_pspec, ls_itnbr, ls_opseq, ls_ioreemp, ls_filsk, ls_itgu, ls_pjtcd
Double ld_ioqty

ls_pspec = trim(arg_imhistdw.GetItemString(arg_rownum, 'pspec'))
If ls_pspec = '' Or isnull(ls_pspec) Then ls_pspec = '.'

ls_itnbr = arg_imhistdw.GetItemString(arg_rownum, 'itnbr')
ld_ioqty = arg_imhistdw.GetItemNumber(arg_rownum, 'ioqty')
ls_opseq = arg_imhistdw.GetitemString(arg_rownum, 'opseq')
ls_ioreemp = arg_imhistdw.GetitemString(arg_rownum, 'ioreemp')
ls_filsk = arg_imhistdw.GetitemString(arg_rownum, 'filsk')
ls_itgu = arg_imhistdw.GetitemString(arg_rownum, 'itgu')
ls_pjtcd = arg_imhistdw.GetitemString(arg_rownum, 'pjt_cd')

//앞의 자료를 울산출고 자료로 만들어 준다.
arg_imhistdw.SetItem(arg_rownum, 'saupj', '10')
arg_imhistdw.SetItem(arg_rownum, 'depot_no', ls_ipStock)

//자동입고 처리
li_ipRow = dw_autoimhist.InsertRow(0)

ls_ipIojpno = arg_date + String(li_seq, '0000') + String(li_ipRow, '000')

dw_autoimhist.SetItem(li_ipRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_ipRow, 'jnpcrt', '001')		//전표생성구분
dw_autoimhist.SetItem(li_ipRow, 'inpcnf', 'I')		//입출고 구분
dw_autoimhist.SetItem(li_ipRow, 'iojpno', ls_ipIojpno)	
dw_autoimhist.SetItem(li_ipRow, 'iogbn', ls_ipIogbn)		//수불구분

dw_autoimhist.SetItem(li_ipRow, 'sudat', arg_date)	//출고일자
dw_autoimhist.SetItem(li_ipRow, 'itnbr', ls_itnbr)		//품번
dw_autoimhist.SetItem(li_ipRow, 'pspec', ls_pspec)		//사양

dw_autoimhist.SetItem(li_ipRow, 'depot_no', ls_ipStock)		//입고창고
dw_autoimhist.SetItem(li_ipRow, 'cvcod', ls_chulStock)		//출고창고
dw_autoimhist.SetItem(li_ipRow, 'ioreqty', ld_ioqty)		//출고의뢰수량
dw_autoimhist.SetItem(li_ipRow, 'opseq', ls_opseq)
dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)		//검사일자
dw_autoimhist.SetItem(li_ipRow, 'iosuqty', ld_ioqty)		//합격수량

dw_autoimhist.SetItem(li_ipRow, 'ioqty', ld_ioqty)		//출고수량
dw_autoimhist.SetItem(li_ipRow, 'io_confirm', 'Y') //수불승인여부
dw_autoimhist.SetItem(li_ipRow, 'io_date', arg_date) //수불승인일자
dw_autoimhist.SetItem(li_ipRow, 'ioreemp', ls_ioreemp)

dw_autoimhist.SetItem(li_ipRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_ipRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_ipRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_ipRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)

String ls_ipSaupj
select ipjogun into :ls_ipSaupj from vndmst where cvcod = :ls_ipStock;  // 출고 창고의 부가 사업장 가져옮
dw_autoimhist.SetItem(li_ipRow, 'saupj', ls_ipSaupj)

dw_autoimhist.SetItem(li_ipRow, 'bigo', '자동입고(울산이동)')

//자동출고 처리
li_chRow = dw_autoimhist.InsertRow(0)

ls_chIojpno = arg_date + String(li_seq, '0000') + String(li_chRow, '000')

/* 상대전표번호 입력 ********************************************/
dw_autoimhist.SetItem(li_ipRow, 'ip_jpno', ls_chIojpno)
/****************************************************************/

dw_autoimhist.SetItem(li_chRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_chRow, 'jnpcrt', '001')		//전표생성구분
dw_autoimhist.SetItem(li_chRow, 'inpcnf', 'O')		//입출고 구분
dw_autoimhist.SetItem(li_chRow, 'iojpno', ls_chIojpno)	
dw_autoimhist.SetItem(li_chRow, 'iogbn', ls_chIogbn)		//수불구분

dw_autoimhist.SetItem(li_chRow, 'sudat', arg_date)	//출고일자
dw_autoimhist.SetItem(li_chRow, 'itnbr', ls_itnbr)		//품번
dw_autoimhist.SetItem(li_chRow, 'pspec', ls_pspec)		//사양

dw_autoimhist.SetItem(li_chRow, 'depot_no', ls_chulStock)		//출고창고
dw_autoimhist.SetItem(li_chRow, 'cvcod', ls_ipStock)		//입고창고
dw_autoimhist.SetItem(li_chRow, 'ioreqty', ld_ioqty)		//출고의뢰수량
dw_autoimhist.SetItem(li_chRow, 'opseq', ls_opseq)
dw_autoimhist.SetItem(li_chRow, 'insdat', arg_date)		//검사일자
dw_autoimhist.SetItem(li_chRow, 'iosuqty', ld_ioqty)		//합격수량

dw_autoimhist.SetItem(li_chRow, 'ioqty', ld_ioqty)		//출고수량
dw_autoimhist.SetItem(li_chRow, 'io_confirm', 'Y') //수불승인여부
dw_autoimhist.SetItem(li_chRow, 'io_date', arg_date) //수불승인일자
dw_autoimhist.SetItem(li_chRow, 'ioreemp', ls_ioreemp)

dw_autoimhist.SetItem(li_chRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_chRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_chRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_chRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_chRow, 'bigo', '자동출고(울산이동)')

String ls_chSaupj
select ipjogun into :ls_chSaupj from vndmst where cvcod = :ls_chulStock;  // 출고 창고의 부가 사업장 가져옮
dw_autoimhist.SetItem(li_chRow, 'saupj', ls_chSaupj)

Return ls_ipIojpno
end function

on w_sal_02040.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_select=create cbx_select
this.dw_cond=create dw_cond
this.cbx_all=create cbx_all
this.dw_list=create dw_list
this.st_2=create st_2
this.st_list=create st_list
this.st_haldang=create st_haldang
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_lot=create dw_lot
this.dw_head=create dw_head
this.dw_hold=create dw_hold
this.dw_haldang_list=create dw_haldang_list
this.dw_imhist=create dw_imhist
this.dw_haldang=create dw_haldang
this.dw_print=create dw_print
this.dw_print1=create dw_print1
this.cbx_move=create cbx_move
this.dw_autoimhist=create dw_autoimhist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.cbx_select
this.Control[iCurrent+4]=this.dw_cond
this.Control[iCurrent+5]=this.cbx_all
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_list
this.Control[iCurrent+9]=this.st_haldang
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
this.Control[iCurrent+13]=this.rr_3
this.Control[iCurrent+14]=this.rr_4
this.Control[iCurrent+15]=this.dw_lot
this.Control[iCurrent+16]=this.dw_head
this.Control[iCurrent+17]=this.dw_hold
this.Control[iCurrent+18]=this.dw_haldang_list
this.Control[iCurrent+19]=this.dw_imhist
this.Control[iCurrent+20]=this.dw_haldang
this.Control[iCurrent+21]=this.dw_print
this.Control[iCurrent+22]=this.dw_print1
this.Control[iCurrent+23]=this.cbx_move
this.Control[iCurrent+24]=this.dw_autoimhist
end on

on w_sal_02040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_select)
destroy(this.dw_cond)
destroy(this.cbx_all)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.st_list)
destroy(this.st_haldang)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_lot)
destroy(this.dw_head)
destroy(this.dw_hold)
destroy(this.dw_haldang_list)
destroy(this.dw_imhist)
destroy(this.dw_haldang)
destroy(this.dw_print)
destroy(this.dw_print1)
destroy(this.cbx_move)
destroy(this.dw_autoimhist)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

dw_imhist.SetTransObject(SQLCA)

dw_haldang.SetTransObject(SQLCA)
dw_haldang_list.SetTransObject(SQLCA)

dw_head.SetTransObject(SQLCA)
dw_head.InsertRow(0)

dw_hold.SetTransObject(SQLCA)
/* 이송일 경우 할당하기 위해 */
dw_insert.SetTransObject(SQLCA)

/*울산이동출고용*/
dw_autoimhist.SetTransObject(SQLCA)

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

cbx_select.Checked = True

//그룹웨어 연동구분
Select dataname into :is_gwgbn
  from syscnfg
 where sysgu = 'W' and
       serial = 1 and
		 lineno = '41';
//is_gwgbn = 'Y'		 
If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server 접속
	SQLCA1 = Create Transaction
	
	select dataname into	 :ls_dbms     from syscnfg where sysgu = 'W' and serial = '6' and lineno = '1';
	select dataname into	 :ls_database from syscnfg where sysgu = 'W' and serial = '6' and lineno = '2';
	select dataname into	 :ls_id	 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '3';
	select dataname into	 :ls_pwd 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '4';
	select dataname into	 :ls_host 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '5';
	select dataname into	 :ls_port 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '6';
	
	ls_conn_str = "DBMSSOCN,"+ls_host+","+ls_port 
	
	SetNull(ls_reg_cnn)
	RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", ls_host, RegString!, ls_reg_cnn) 
	
	If Trim(Upper(ls_conn_str)) <> Trim(Upper(ls_reg_cnn)) Or &
		( ls_reg_cnn =""  Or isNull(ls_reg_cnn) )  Then
		RegistrySet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", & 
						ls_host, RegString!, ls_conn_str)
	End If
	
	SQLCA1.DBMS = ls_dbms
	SQLCA1.Database = ls_database
	SQLCA1.LogPass = ls_pwd
	SQLCA1.ServerName = ls_host
	SQLCA1.LogId =ls_id
	SQLCA1.AutoCommit = False
	SQLCA1.DBParm = ""
	
	CONNECT USING SQLCA1;
	If sqlca1.sqlcode <> 0 Then
		messagebox(string(sqlca1.sqlcode),sqlca1.sqlerrtext)
		MessageBox('확 인','그룹웨어 연동을 할 수 없습니다.!!')
		is_gwgbn = 'N'
	End If
End If

Wf_Init()
//20181029 한텍 요청 사항 사업장 강제로 장안으로 디폴트값 지정요청 HYKANG 20181029
gs_saupj = '20'

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_cond.Modify("sarea.protect=1")
	dw_cond.Modify("sarea.background.color = 80859087")
Else
	dw_cond.Modify("sarea.protect=0")
	dw_cond.Modify("sarea.background.color '"+String(Rgb(255,255,255))+"'")
End If

//// 부가세 사업장 설정
//f_mod_saupj(dw_cond, 'saupj')
dw_cond.SetItem(1, 'saupj', gs_saupj)

dw_cond.SetItem(1, 'sarea', sarea)
	
/*여신체크 시점*/
sSyscnfg_Yusin = f_get_syscnfg('S',2,'10')
If IsNull(sSyscnfg_Yusin) Or sSyscnfg_Yusin = '' Then sSyscnfg_Yusin = '4'

/* 가용재고가 '-'일경우 출고처리 여부 */
sValidMinus = f_get_syscnfg('S',1,'75')
If IsNull(sValidMinus) Or sValidMinus = '' Then sValidMinus = 'Y'

f_child_saupj(dw_cond, 'sarea', gs_saupj)
f_child_saupj(dw_cond, 'depot_no', gs_saupj)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02040
boolean visible = false
integer x = 1595
integer y = 12
integer width = 649
integer height = 128
integer taborder = 0
boolean enabled = false
boolean titlebar = true
string title = "이송출고시 할당내역"
string dataobject = "d_sal_020303"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

type p_delrow from w_inherite`p_delrow within w_sal_02040
boolean visible = false
integer x = 1070
integer y = 2752
integer taborder = 60
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_02040
boolean visible = false
integer x = 864
integer y = 2748
integer taborder = 40
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_02040
integer x = 4091
integer y = 32
integer taborder = 130
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event p_search::clicked;call super::clicked;If dw_imhist.AcceptText() <> 1 Then Return

If f_msg_update() <> 1 Then Return

If dw_imhist.Update() <> 1 Then
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	RollBack;
	Return
End If

String ls_ipjpno
Int li_row, li_i
Double ld_qty

li_row = dw_imhist.RowCount()

For li_i = 1 To li_row
	ls_ipjpno = dw_imhist.GetItemString(li_i, 'ip_jpno')
	ld_qty = dw_imhist.GetItemNumber(li_i, 'vqty')
	
	IF IsNull(ls_ipjpno) = False Then
		String ls_IM2jpno
		
		SELECT IP_JPNO
		INTO :ls_IM2jpno
		FROM IMHIST
		WHERE IOGBN = 'IM2'
			AND IOJPNO = :ls_ipjpno;
		
		UPDATE IMHIST
			SET IOQTY = :ld_qty,
				   IOREQTY = :ld_qty,
				   IOSUQTY = :ld_qty
		WHERE IOGBN = 'IM2' 
			AND IOJPNO = :ls_ipjpno;
			
		UPDATE IMHIST		 
			SET IOQTY = :ld_qty,
				   IOREQTY = :ld_qty,
				   IOSUQTY = :ld_qty 
		WHERE IOGBN = 'OM6' AND IOJPNO = :ls_IM2jpno;
	End If	
Next

COMMIT;

MessageBox('확 인','저장하였습니다.!!')
end event

type p_ins from w_inherite`p_ins within w_sal_02040
boolean visible = false
integer x = 3506
integer y = 76
integer taborder = 30
boolean enabled = false
string picturename = "C:\erpman\image\재고선택_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\재고선택_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\재고선택_up.gif"
end event

event p_ins::clicked;call super::clicked;datawindow dwname	
Long nRow
Dec  dQty

If dw_haldang.accepttext() <> 1 Then Return
nRow = dw_haldang.GetSelectedRow(0)
If nRow <= 0 Then Return

dwname = dw_lot

gs_gubun = dw_cond.GetItemString(1, 'depot_no')
gs_code  = dw_haldang.getitemstring(nRow, "itnbr")
gs_codename = dw_haldang.getitemstring(nRow, "hold_no")
gs_codename2 = string(dw_haldang.getitemNumber(nRow, "valid_qty"))

openwithparm(w_stockwan_popup, dwname)
If IsNull(gs_code) Or Not IsNumber(gs_code) Then Return

dw_haldang.SetItem(nRow, 'choice_qty', Dec(gs_code))
dw_haldang.SetItem(nRow, 'flag_choice', 'Y')

setnull(gs_code)
end event

type p_exit from w_inherite`p_exit within w_sal_02040
integer y = 32
integer taborder = 120
end type

type p_can from w_inherite`p_can within w_sal_02040
integer x = 4265
integer y = 32
integer taborder = 110
end type

event p_can::clicked;call super::clicked;rollback;

Wf_Init()
end event

type p_print from w_inherite`p_print within w_sal_02040
boolean visible = false
integer x = 3342
integer y = 56
integer taborder = 140
string picturename = "C:\erpman\image\일괄발행_up.gif"
end type

event p_print::clicked;call super::clicked;Long ix, nCnt, nPrs = 0, nRow, iy, sRow
String sGbn, sDirgb, sJepumIo, sSalegu, sCvcod, sNull, sSudat, sFrDate, sToDate
Dec    dUseAmount, dStdAmt, dSumAmount

SetNull(sNull)

If rb_1.Checked = False Then Return

dw_list.Reset()

If dw_cond.AcceptText() <> 1 Then Return
If dw_haldang_list.RowCount() <= 0 Then Return

sGbn 		= Trim(dw_cond.GetItemString(1,"iogbn"))
sDirgb   	= Trim(dw_cond.GetItemSTring(1,"dirgb"))

sSudat = dw_cond.GetItemString(1,'sudat')
IF 	f_datechk(sSudat) <> 1 THEN
  	f_message_chk(30,'[발행일자]')
  	dw_cond.SetColumn("sudat")
  	dw_cond.SetFocus()
  	Return
END IF

/* 매출마감시 송장 발행 안함 */
SELECT COUNT(*)  INTO :ncnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;

If nCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
	
cbx_select.Checked = True	/* 품목전체 선택 */

If sGbn = 'N' then
	/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
	sJepumIo = 'Y%'
	sSaleGu  = 'N%'
Else
	/* 판매출고 : 매출여부('Y') */
	sJepumIo = '%'
	sSaleGu  = 'Y%'
End If

IF MessageBox("확 인","송장 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

/* 선택된 거래처만 발행함 */
dw_haldang.SetRedraw(False)
For ix = 1 To dw_haldang_list.RowCount()
	If dw_haldang_list.GetItemString(ix, 'chk') <> 'Y' Then Continue

	/* 검색조건 : 당월분일 경우 요구납기일이 발행월에 해당되는 수주만 조회 */
	If dw_cond.GetItemSTring(1,"chk") = 'Y' Then
		sFrDate = Left(sSudat,6) + '01'
	Else
		sFrdate = '19000101'
	End If
	sTodate = sSudat
	
	/* 할당현황 조회 */
	sCvcod   = Trim(dw_haldang_list.GetItemSTring(ix,"cvcod"))
	nCnt = dw_haldang.Retrieve(gs_sabu, sCvcod, sJepumIo, sSaleGu, sDirgb, sFrDate, sToDate)
	If nCnt <= 0 Then Continue

	/* 할당내용중 재고가 있는 품목만 선택 */
	cbx_select.TriggerEvent(Clicked!)
	
	/* 선택된 품목이 없으면 skip */
	nCnt = dw_haldang.GetItemNumber(1,"yescount")
	IF nCnt <=0 Then Continue
	
	/* 여신금액 체크 */
	If ssyscnfg_yusin = '3' Then
		sCvcod = Trim(dw_haldang.GetItemString(1,"sorder_cvcod"))
		dUseAmount = sqlca.Fun_Erp100000030(gs_sabu,sCvcod, Left(is_today,6),Is_today);
		If sqlca.sqlcode <> 0 Then 
			MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
			Return -1
		End If
		
		dStdAmt = dw_haldang_list.GetItemNumber(ix, 'credit_limit')
		If IsNull(dStdAmt) then dStdAmt = 0

		/* 여신금액이 초과할 경우 품목을 하나씩 제거한다 */
		nRow = dw_haldang.RowCount()
		For iy = nRow To 1 Step -1
			/* 출고금액 */
			dSumAmount = dw_haldang.GetItemNumber(1, 'sum_amount')
			If IsNull(dSumAmount) then dSumAmount = 0

			If dStdAmt > 0 And ( dStdAmt - dUseAmount - dSumAmount < 0 ) Then
				If dw_haldang.GetItemString(iy, 'flag_choice') = 'Y' Then
					dw_haldang.SetItem(iy,'flag_choice', 'N')

					/* 신용체크 걸린 거래처, 품목 */
					sRow = dw_list.InsertRow(0)
					dw_list.SetItem(sRow, 'cvcod',  sCvcod)
					dw_list.SetItem(sRow, 'cvnas',  dw_haldang_list.GetItemString(ix, 'cvnas2'))
					dw_list.SetItem(sRow, 'hold_no', dw_haldang.GetItemString(iy, 'hold_no'))
					dw_list.SetItem(sRow, 'itnbr', dw_haldang.GetItemString(iy, 'itnbr'))
					dw_list.SetItem(sRow, 'itdsc', dw_haldang.GetItemString(iy, 'itemas_itdsc'))
					dw_list.SetItem(sRow, 'ispec', dw_haldang.GetItemString(iy, 'itemas_ispec'))
					dw_list.SetItem(sRow, 'jijil', dw_haldang.GetItemString(iy, 'itemas_jijil'))
					dw_list.SetItem(sRow, 'valid_qty', dw_haldang.GetItemNumber(iy, 'valid_qty'))
					dw_list.SetItem(sRow, 'ordamt', dw_haldang.GetItemNumber(iy, 'ordamt'))
					Continue
				End If
			Else
				Exit
			End If
		Next

	End If
	
	/* 선택된 품목이 존재할 경우만 발행 */
	If dw_haldang.GetItemNumber(1, 'yescount') > 0 Then
		IF Wf_Create_Imhist() <> 1 THEN 
			dw_haldang.SetRedraw(True)
			RETURN
		End If
		
		nPrs += 1
	End If
Next
dw_haldang.SetRedraw(True)

/* 여신부족업체 list 인쇄 */
IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_list)
END IF

/* 처리후 할당현황을 재조회한다 */
dw_haldang.Reset()
dw_imhist.Reset()
p_inq.TriggerEvent(Clicked!)


sle_msg.text = String(nPrs) +'건의 자료를 처리하였습니다!!'
ib_any_typing = False
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\일괄발행_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\일괄발행_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_02040
integer x = 3739
integer y = 32
end type

event p_inq::clicked;call super::clicked;String sJepumIo, sSaleGu, sGbn, sCvcod, sCvcodNm, sArea, sGwNo
String sSuDat, sIoDate, sSaupj, sDirgb, sDepotNo

If dw_cond.AcceptText() <> 1 Then Return

sSuDat 	= Trim(dw_cond.GetItemSTring(1,"sudat"))
sCvcod 	= Trim(dw_cond.GetItemSTring(1,"cvcod"))
sArea  	= Trim(dw_cond.GetItemSTring(1,"sarea"))
sSaupj  	= Trim(dw_cond.GetItemSTring(1,"saupj"))
sDirgb  	= Trim(dw_cond.GetItemSTring(1,"dirgb"))
sDepotNo  = Trim(dw_cond.GetItemSTring(1,"depot_no"))

If 	IsNull(sCvcod) or sCvcod = '' then sCvcod = ''
If 	IsNull(sArea)  or sArea = ''  then sArea = ''
If 	IsNull(sDepotNo) or sDepotNo = '' then sDepotNo = ''

sGbn = Trim(dw_cond.GetItemString(1,"iogbn"))
If sGbn = 'N' then
	/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
	sJepumIo = 'Y'
	sSaleGu  = 'N'
ElseIf sGbn = 'Y' then
	/* 판매출고 : 매출여부('Y') */
	sJepumIo = ''
	sSaleGu  = 'Y'
Else
	sJepumIo = 'Y'
	sSaleGu  = ''
End If

dw_haldang.Reset()
dw_imhist.Reset()
p_mod.Enabled = True

/*송장 처리*/
IF	sModStatus = 'I' THEN
//	If	IsNull(sDepotNo) Or sDepotNo = '' Then
//		f_message_chk(30,'출고창고')
//		Return
//	End If
	
	/* -- 창고 재고 허용여부 -- */
//	select substr(kyungy,1,1) into :sMinus
//	  from vndmst
//	 where cvcod = :sDepotNo;
//	
//	If	IsNull(sMinus) Then sMinus = 'N'
	
	If	IsNull(sSaupj) Or sSaupj = '' Then
		f_message_chk(30,'부가사업장')
		Return
	End If

	IF	dw_haldang_list.Retrieve(gs_sabu, sArea+'%', sCvcod+'%', sJepumIo+'%', sSaleGu+'%', sSaupj, sDirgb, sDepotNo+'%') <=0 THEN
		f_message_chk(50,'')
		dw_haldang.Reset()
		dw_cond.Setfocus()
		Return
	ELSE
		dw_imhist.Reset()		
		dw_haldang_list.SetFocus()
	END IF
ELSE
	/*송장 취소*/
	LsIoJpNo    = Left(dw_cond.GetItemString(1,"iojpno"),12)
	
	/*송장번호를 입력하는 경우 */
	If Not IsNull(LsIoJpno) Then
		select distinct x.sudat, x.cvcod , y.jepumio, y.salegu, x.io_date, x.saupj,
		                v.cvnas2, v.sarea
		  into :sSudat, :sCvcod, :sJePumIo, :sSaleGu, :sIoDate, :sSaupj, :scvcodnm, :sarea
	    from imhist x, iomatrix y, vndmst v
		 where x.iogbn = y.iogbn and
		       x.cvcod = v.cvcod and
		       x.sabu = :gs_sabu and
		       x.iojpno like :LsIoJpno||'%' and
				 y.jepumio = 'Y';

		dw_cond.SetItem(1,'sudat',   sSudat)
		dw_cond.SetItem(1,'sarea',   sArea)
		dw_cond.SetItem(1,'cvcod',   sCvcod)
		dw_cond.SetItem(1,'vndname', sCvcodnm)
		dw_cond.SetItem(1,'iogbn',   sSalegu)
		dw_cond.SetItem(1,'saupj',   sSaupj)
//		dw_cond.SetItem(1,'depot_no',   sDepotNo)
		IF dw_imhist.Retrieve(gs_sabu, sSuDat, sCvcod+'%', LsIoJpNo, sJepumIo+'%', sSaleGu+'%') <=0 THEN
			f_message_chk(50,'')
			dw_cond.Setfocus()
			Return
		ELSE
			dw_haldang_list.Reset()
			dw_imhist.SetFocus()
		END IF
		
//		/* 제품출고 확인 된 경우 취소 불가 */
//		If IsNull(sIoDate) or Trim(sIoDate) = '' Then
//			p_mod.Enabled = True
//		Else
//			MessageBox('확 인','출고확인 처리된 송장입니다.~r~n~r~n송장취소는 불가능합니다')
//			p_mod.Enabled = False
//		End If
	Else
//		If IsNull(sDepotNo) Or sDepotNo = '' Then
//			f_message_chk(30,'출고창고')
//			Return
//		End If
		
		If IsNull(sSaupj) Or sSaupj = '' Then
			f_message_chk(30,'부가사업장')
			Return
		End If
	
		/*송장번호를 입력하지않는 경우 송장리스트를 조회*/
		If sDirgb = 'S' Then sDirgb = 'N'
	
		IF dw_haldang_list.Retrieve(gs_sabu, sSudat, sArea+'%', sCvcod+'%', sJepumIo+'%', sSaleGu+'%', sSaupj, sDirgb, sDepotNo+'%') <=0 THEN
			f_message_chk(50,'')
			dw_imhist.Reset()
			dw_cond.Setfocus()
			Return
		ELSE
			dw_haldang.Reset()
			dw_haldang_list.SetFocus()
		END IF
  End If
END IF

dw_cond.Modify('depot_no.protect = 1')
dw_cond.Modify('iogbn.protect = 1')

dw_head.Reset()
dw_head.InsertRow(0)

ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_sal_02040
boolean visible = false
integer x = 1390
integer y = 2632
integer taborder = 100
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_02040
integer x = 3918
integer y = 32
integer taborder = 80
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;string sSudat,sGbn,sJepumIo,sSaleGu, sNull
Int    iCnt
Long   lCnt

If dw_cond.AcceptText() <> 1 Then Return
If dw_head.AcceptText() <> 1 Then Return
If dw_haldang.AcceptText() <> 1 Then Return
If dw_imhist.AcceptText() <> 1 Then Return

SetNull(sNull)

sSudat = dw_cond.GetItemString(1,'sudat')
IF f_datechk(sSudat) <> 1 THEN
  f_message_chk(30,'[발행일자]')
  dw_cond.SetColumn("sudat")
  dw_cond.SetFocus()
  Return
END IF

IF rb_1.Checked = True THEN
	If dw_haldang.AcceptText() <> 1 Then Return
	
	/* 매출마감시 송장 발행 안함 */
	SELECT COUNT(*)  INTO :icnt
	 FROM "JUNPYO_CLOSING"  
	WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
			( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
			( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;
	
	If iCnt >= 1 then
		f_message_chk(60,'[매출마감]')
		Return
	End if

	If dw_haldang.RowCount() <= 0 Then Return
	
	/* 선택된 품목이 없으면 skip */
	lCnt = dw_haldang.GetItemNumber(1,"sum_choiceqty")
	IF lCnt <=0 THEN
		f_message_chk(36,STRING(lCnt))
		Return -1
	END IF
	
	/* 여신금액 체크 */
	If wf_check_yusin(dw_haldang_list.GetRow(), 'Y') <> 1 Then		Return

	/* 포장정보 확인 */
//	If IsNull(dw_head.GetItemString(1, 'eboxyn')) Or Trim(dw_head.GetItemString(1, 'eboxyn')) = '' Then
//		f_message_chk(1400,'수출BOX')
//		Return -1
//	End If
//	If IsNull(dw_head.GetItemString(1, 'insyn')) Or Trim(dw_head.GetItemString(1, 'insyn')) = '' Then
//		f_message_chk(1400,'성적서발행')
//		Return -1
//	End If
//	If IsNull(dw_head.GetItemString(1, 'sgbn')) Or Trim(dw_head.GetItemString(1, 'sgbn')) = '' Then
//		f_message_chk(1400,'세관신고여부')
//		Return -1
//	End If
	
	IF MessageBox("확 인","송장 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

	IF Wf_Create_Imhist() <> 1 THEN RETURN
	
	dw_haldang.Reset()
	dw_imhist.Reset()
	dw_autoimhist.Reset()
ELSE
	IF Wf_Delete_Imhist() <> 1 THEN RETURN
	
	dw_haldang.Reset()
	dw_imhist.Reset()
	dw_autoimhist.Reset()
	
	dw_cond.SetItem(1,'iojpno',sNull)
	dw_cond.SetItem(1,'sarea',sNull)
	dw_cond.SetItem(1,'cvcod',sNull)
	dw_cond.SetItem(1,'vndname',sNull)	
END IF

dw_head.Reset()
dw_head.InsertRow(0)

p_inq.TriggerEvent(Clicked!) // 할당 list 조회
sle_msg.text = '자료를 처리하였습니다!!'
ib_any_typing = False
end event

event p_mod::ue_lbuttondown;PictureName = 'C:\erpman\image\처리_dn.gif'
end event

event p_mod::ue_lbuttonup;PictureName = 'C:\erpman\image\처리_up.gif'
end event

type cb_exit from w_inherite`cb_exit within w_sal_02040
integer y = 2808
end type

type cb_mod from w_inherite`cb_mod within w_sal_02040
integer y = 2808
end type

type cb_ins from w_inherite`cb_ins within w_sal_02040
integer x = 320
integer y = 2700
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02040
integer x = 1189
integer y = 2704
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02040
integer y = 2808
end type

type cb_print from w_inherite`cb_print within w_sal_02040
integer y = 2808
end type

type st_1 from w_inherite`st_1 within w_sal_02040
end type

type cb_can from w_inherite`cb_can within w_sal_02040
integer y = 2768
end type

type cb_search from w_inherite`cb_search within w_sal_02040
integer x = 677
integer y = 2712
boolean enabled = false
end type





type gb_10 from w_inherite`gb_10 within w_sal_02040
integer x = 14
integer y = 3008
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02040
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02040
end type

type rb_1 from radiobutton within w_sal_02040
integer x = 55
integer y = 68
integer width = 229
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "발행"
boolean checked = true
end type

event clicked;sModStatus = 'I'

Wf_Init()


end event

type rb_2 from radiobutton within w_sal_02040
integer x = 293
integer y = 68
integer width = 229
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "취소"
end type

event clicked;sModStatus = 'C'

Wf_Init()

cbx_select.Checked = False
end event

type cbx_select from checkbox within w_sal_02040
boolean visible = false
integer x = 4247
integer y = 752
integer width = 334
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;
// 보다테크는 전체선택 할 수 없다
RETURN

//String  sStatus, sItnbr, sIspec, Sdatachk
//Integer k, nRow
//Double  dHoldQty,dIsQty, dJegoQty, dValidQty, dStkQty 
//
//IF cbx_select.Checked = True THEN
//	sStatus = 'Y'
//ELSE
//	sStatus = 'N'
//END IF
//
///* 송장 처리 */
//IF sModStatus = 'I' And sStatus = 'N' THEN
//	FOR k = 1 TO dw_haldang.RowCount()
//		dw_haldang.SetItem(k,"flag_choice",sStatus)
//	NEXT
//ElseIF sModStatus = 'I' And sStatus = 'Y' THEN
//	Select dataname
//	  Into :Sdatachk
//	  From syscnfg
//	 Where sysgu='S' and serial='1' and lineno='90' 
//	 Using sqlca;
//	   /* 시스템으로 처리(김익태) */
//		IF gs_today <= Sdatachk Then	
//			FOR k = 1 TO dw_haldang.RowCount()
//				dw_haldang.SetItem(k,"flag_choice",sStatus)
//			NEXT
//		ELSE
//			/* 재고 Minus 허용함 */
//			If sMinus = 'Y' Then
//				For k = 1 To dw_haldang.RowCount()
//					dw_haldang.SetItem(k,"flag_choice", sStatus)
//				Next
//			Else
//				/* 재고 Minus 허용안할경우 */
//				
//				/* 품번별 소트 */
//				dw_haldang.SetSort('hold_date a, itnbr a, pspec a, hold_no a')
//				dw_haldang.Sort()
//			
//				nRow = dw_haldang.RowCount()
//				FOR k = 1 TO nRow
//					If sItnbr <> Trim(dw_haldang.GetItemString(k,'itnbr')) or &
//						sIspec <> Trim(dw_haldang.GetItemString(k,'pspec')) then
//						
//						sItnbr = Trim(dw_haldang.GetItemString(k,'itnbr'))
//						sIspec = Trim(dw_haldang.GetItemString(k,'pspec'))
//						
//						dJegoQty = dw_haldang.GetItemNumber(k,'jego_qty')
//						IF IsNull(dJegoQty) THEN dJegoQty =0
//					End If
//					
//					/* 재고가 없을경우 발행불가 */
//					IF dJegoQty <= 0 THEN
//						dw_haldang.SetItem(k,"flag_choice",'N')
//					ELSE
//						dStkQty = dw_haldang.GetItemNumber(k,"stock_valid_qty")	/* 가용재고 */
//						IF IsNull(dStkQty) THEN dStkQty = 0
//		
//						dValidQty = dw_haldang.GetItemNumber(k,"valid_qty")	/* 출고요청수량 */
//						IF IsNull(dValidQty) THEN dValidQty =0
//					
//						/* 출고수량이 재고수량보다 적어야 가능함 */
//						IF dValidQty > 0 And dValidQty <= dJegoQty THEN
//							dw_haldang.SetItem(k,"flag_choice",'Y')
//							dJegoQty -= dValidQty
//						ELSE
//							dw_haldang.SetItem(k,"flag_choice",'N')
//						END IF
//					END IF
//					sle_msg.Text = string(k)+'/'+string(nRow) + ' 처리중...'
//				NEXT
//			End If
//		END IF	
//ELSE
///* 송장 취소 */
//	FOR k = 1 TO dw_imhist.RowCount()
//		dw_imhist.SetItem(k,"flag_choice",sStatus)
//	NEXT	
//END IF
//
//sle_msg.Text = ''
end event

type dw_cond from u_key_enter within w_sal_02040
event ue_key pbm_dwnkey
integer x = 37
integer y = 272
integer width = 2011
integer height = 460
integer taborder = 20
string dataobject = "d_sal_020401"
boolean border = false
end type

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;call super::itemchanged;String sNull, sIojpno, sIoConFirm,sSudate, sIoDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'depot_no', sSaupj)
		f_child_saupj(this, 'sarea', sSaupj)
	Case "iojpno"
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
		SELECT DISTINCT "IMHIST"."IO_DATE", "SAUPJ" INTO :sIoDate, :sSaupj
		  FROM "IMHIST", "IOMATRIX"
		 WHERE ( TRIM("IMHIST"."SABU") = :gs_sabu ) AND 
				 ( "IMHIST"."IOJPNO" LIKE :sIoJpNo||'%' ) AND
				 ( "IMHIST"."IOGBN" = "IOMATRIX"."IOGBN" ) AND
				 ( "IOMATRIX"."JEPUMIO" = 'Y' ) AND
				 ( "IMHIST"."JNPCRT" ='004');
	
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			SetItem(1, 'saupj', sSaupj)
			cb_inq.TriggerEvent(Clicked!)
		END IF
	Case "sudat"
		sSuDate = Trim(this.GetText())
	
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[발행일자]')
			this.SetItem(1,"sudat",snull)
			Return 1
		END IF
	/* 관할구역 */
	Case 'sarea'
		SetItem(1,'cvcod',sNull)
		SetItem(1,'vndname',sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vndname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,"vndname",	scvnas)
		END IF
	/* 거래처명 */
	Case "vndname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"vndname", scvnas)
			Return 1
		END IF
	Case 'dirgb'
		dw_haldang_list.SetRedraw(False)
		dw_haldang.SetRedraw(False)
			
		/* 송장발행일 경우 */
		If rb_1.Checked = True Then		
			If GetText() = 'S' Then
				dw_haldang_list.DataObject = 'd_sal_020406'	/* 이송후 직납 */
				dw_haldang.DataObject = 'd_sal_020407'
			Else
				dw_haldang_list.DataObject = 'd_sal_020404'
				dw_haldang.DataObject = 'd_sal_020403'
			End If
		Else		
			If GetText() = 'S' Then
				dw_haldang_list.DataObject = 'd_sal_020408'	/* 이송후 직납 */
			Else
				dw_haldang_list.DataObject = 'd_sal_020405'
			End If
		End If
		dw_haldang_list.SetTransObject(sqlca)
		dw_haldang.SetTransObject(sqlca)

		dw_haldang_list.SetRedraw(True)
		dw_haldang.SetRedraw(True)
	Case 'chk'
		// 발행일 경우만 해당
		If rb_1.Checked Then
			If GetText() = 'Y' Then
				dw_haldang_list.DataObject = 'd_sal_020404'
			Else
				dw_haldang_list.DataObject = 'd_sal_020404_1'
			End If
			dw_haldang_list.SetTransObject(sqlca)
			dw_haldang.Reset()
		Else
			Return 2
		End If
END Choose
end event

event rbuttondown;String sIogbn,sArea

SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	Case "iojpno"
		sIoGbn = Trim(GetItemString(1,'iogbn'))
		If sIoGbn = 'Y' Then
			gs_gubun = '004'        //판매출고
		ElseIf sIoGbn = 'N' Then
			gs_gubun = '001'        //무상출고
		Else
			gs_gubun = 'ALL'
		End If
		
		gs_codename = 'B'  /* 출고확인 전/후 */
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"iojpno",Left(gs_code,12))
		SetFocus()
		PostEvent(ItemChanged!)
	/* 거래처 */
	Case "cvcod", "vndname"
		gs_gubun = '1'
		If GetColumnName() = "vndname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

type cbx_all from checkbox within w_sal_02040
boolean visible = false
integer x = 4347
integer y = 248
integer width = 238
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "일괄"
end type

event clicked;String  sStatus
Integer k

IF cbx_all.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

/* 송장 처리 */
IF sModStatus = 'I' THEN
	FOR k = 1 TO dw_haldang_list.RowCount()
		dw_haldang_list.SetItem(k,"chk",sStatus)
	NEXT	
ELSE

END IF
end event

type dw_list from datawindow within w_sal_02040
boolean visible = false
integer x = 622
integer y = 4
integer width = 978
integer height = 100
integer taborder = 150
boolean bringtotop = true
boolean titlebar = true
string title = "여신부족 업체 LIST"
string dataobject = "d_sal_020409"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sal_02040
integer x = 87
integer y = 212
integer width = 315
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "[검색조건]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_list from statictext within w_sal_02040
integer x = 87
integer y = 772
integer width = 347
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "[송장 내역]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_haldang from statictext within w_sal_02040
integer x = 2304
integer y = 208
integer width = 315
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "[할당현황]"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_sal_02040
integer x = 713
integer y = 284
integer width = 82
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('sudat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'sudat', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 228
integer width = 2039
integer height = 528
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 800
integer width = 4585
integer height = 1508
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2089
integer y = 228
integer width = 2528
integer height = 532
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sal_02040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 36
integer width = 535
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_lot from datawindow within w_sal_02040
boolean visible = false
integer x = 37
integer y = 1168
integer width = 1472
integer height = 528
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02040_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_head from u_key_enter within w_sal_02040
boolean visible = false
integer x = 50
integer y = 2036
integer width = 4549
integer height = 432
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_020304"
borderstyle borderstyle = stylelowered!
end type

event itemchanged;call super::itemchanged;String sCvcod, scvnas, sarea, steam, sSaupj, sName1, snull

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "frcust"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'frcust', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas2",	scvnas)
		END IF
End Choose
end event

event rbuttondown;call super::rbuttondown;string sArea,sCvcod, sCvcodNm, sDepotNo, sJuhaldle
Long   nRow

SetNull(Gs_Code)
SetNull(Gs_Gubun)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 거래처 */
	Case "frcust"
		Open(w_vndmst_popup)		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"frcust",gs_code)
		SetItem(1,"cvnas2",gs_codename)
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

type dw_hold from datawindow within w_sal_02040
boolean visible = false
integer x = 2245
integer y = 28
integer width = 1015
integer height = 108
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sal_02040_10"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_haldang_list from datawindow within w_sal_02040
integer x = 2098
integer y = 260
integer width = 2487
integer height = 496
integer taborder = 50
string dataobject = "d_sal_020404"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;//IF currentrow > 0 THEN
//	this.SelectRow(0,False)
//	this.SelectRow(currentrow,True)
//	this.ScrollToRow(currentrow)
//END IF
end event

event doubleclicked;//String sJepumIo,sSaleGu,sGbn,sCvcod, sCvcodNm, sSuDat, sIojpno, sArea, sDirgb, sFrdate, sTodate, sMaxdate, sHoldNo
//Long   nRow
//
//IF Row <=0 THEN RETURN
//
//nRow = GetRow()
//
//this.SelectRow(0,False)
//this.SelectRow(Row,True)
//
//sCvcod   = Trim(This.GetItemSTring(Row,"cvcod"))
//sCvcodNm = Trim(This.GetItemSTring(Row,"cvnas2"))
//sDirgb   = Trim(dw_cond.GetItemSTring(1,"dirgb"))
//sSuDat   = Trim(dw_cond.GetItemString(1,"sudat"))
//  
//sGbn = Trim(dw_cond.GetItemString(1,"iogbn"))
//If sGbn = 'N' then
///* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
//	sJepumIo = 'Y%'
//	sSaleGu  = 'N%'
//Else
///* 판매출고 : 매출여부('Y') */
//	sJepumIo = '%'
//	sSaleGu  = 'Y%'
//End If
//	
///*송장 처리*/
//IF sModStatus = 'I' THEN
//	/* 검색조건 : 당월분일 경우 요구납기일이 발행월에 해당되는 수주만 조회 */
//	If 	dw_cond.GetItemSTring(1,"chk") = 'Y' Then
//		sFrDate 	= Left(sSudat,6) + '01'
//		sMaxDate	= Left(sSudat,6) + '99'
//	Else
//		sFrdate = '19000101'
//		sMaxDate	='99999999'
//	End If
//	sTodate = sSudat
//	
//	sHoldNo  = Trim(This.GetItemSTring(Row,"hold_no"))
//	
//	IF dw_haldang.Retrieve(gs_sabu,sCvcod,sJepumIo,sSaleGu, sDirgb, sFrdate, sMAxdate, sHoldNo+'%') <=0 THEN 
//		f_message_chk(50,'')
//		dw_cond.Setfocus()
//		Return
//	ELSE
//		dw_imhist.Reset()
//	END IF
//Else
//	/* 송장취소 */
//  sIoJpNo = Trim(This.GetItemString(Row,"iojpno"))	
//	sArea = Trim(This.GetItemString(Row,"sarea"))
//	
//	IF dw_imhist.Retrieve(gs_sabu,sSuDat, sCvcod, sIoJpNo, sJepumIo, sSaleGu) <=0 THEN 
//		f_message_chk(50,'')
//		dw_cond.Setfocus()
//		Return
//	ELSE
//		dw_haldang.Reset()
//	END IF
//	
//	dw_cond.SetItem(1,'iojpno',sIoJpNo)
//	dw_cond.SetItem(1,'sarea',sArea)
//	dw_cond.SetItem(1,'cvcod',sCvcod)
//	dw_cond.SetItem(1,'vndname',sCvcodNm)
//End If
//
//ib_any_typing = False
//cbx_select.TriggerEvent(Clicked!)
end event

event clicked;String sJepumIo,sSaleGu,sGbn,sCvcod, sCvcodNm, sSuDat, sIojpno, sArea, sDirgb, sFrdate, sTodate, sMaxdate, sHoldNo
String sjpno, sGwNo, sGwStatus, sDepot, sreqdept
Long   nRow

nRow = row
IF nRow <=0 THEN RETURN

this.SelectRow(0,False)
this.SelectRow(nRow,True)

sCvcod   = Trim(This.GetItemSTring(nRow,"cvcod"))
sCvcodNm = Trim(This.GetItemSTring(nRow,"cvnas2"))
sDirgb   = Trim(dw_cond.GetItemSTring(1,"dirgb"))
sSuDat   = Trim(dw_cond.GetItemString(1,"sudat"))
//sDepot   = Trim(dw_cond.GetItemString(1,"depot_no"))
sGbn 		= Trim(dw_cond.GetItemString(1,"iogbn"))

If IsNull(sDepot) Or sDepot = '' Then sDepot = ''

If sGbn = 'N' then
/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
	sJepumIo = 'Y%'
	sSaleGu  = 'N%'
ElseIf sgbn = 'Y' then
/* 판매출고 : 매출여부('Y') */
	sJepumIo = '%'
	sSaleGu  = 'Y%'
Else
	sJepumIo = 'Y'
	sSaleGu  = '%'
End If

/*송장 처리*/
IF sModStatus = 'I' THEN
	If dw_cond.GetItemSTring(1,"chk") = 'N' Then
		sFrdate = '19000101'
		sMaxDate	='99999999'
	Else
		sFrdate  = GetItemString(nRow, 'hold_date')
		sMaxDate = GetItemString(nRow, 'hold_date')
	End If

	sReqdept = Trim(This.GetItemSTring(nRow,"req_dept"))
	
	sTodate = sSudat
	
	sHoldNo  = Trim(This.GetItemSTring(nRow,"hold_no"))
	If IsNull(sHoldNo) Or sHoldNo = '' Then sHoldNo = ''
	
	IF dw_haldang.Retrieve(gs_sabu,sCvcod,sJepumIo,sSaleGu, sDirgb, sFrdate, sMAxdate, sHoldNo+'%', sDepot+'%', sReqDept) <=0 THEN 
		f_message_chk(50,'')
		dw_cond.Setfocus()
		Return
	ELSE
		dw_imhist.Reset()
	END IF
	
	dw_head.Reset()
	dw_head.InsertRow(0)
Else
	sjpno = Trim(This.GetItemString(nRow,"iojpno"))	

	/* 송장취소 */
  	sIoJpNo = Trim(This.GetItemString(nRow,"iojpno"))	
	sArea = Trim(This.GetItemString(nRow,"sarea"))
	
	IF dw_imhist.Retrieve(gs_sabu,sSuDat, sCvcod, sIoJpNo, sJepumIo, sSaleGu) <=0 THEN 
		f_message_chk(50,'')
		dw_cond.Setfocus()
		Return
	ELSE
		dw_haldang.Reset()
	END IF
		
	If dw_head.Retrieve(gs_sabu, sIoJpNo) <= 0 Then
		dw_head.InsertRow(0)
		dw_head.SEtitem(1, 'sabu', gs_sabu)
		dw_head.SEtitem(1, 'hold_no', sIoJpNo)
	End If
End If

ib_any_typing = False
cbx_select.TriggerEvent(Clicked!)
end event

type dw_imhist from u_d_popup_sort within w_sal_02040
integer x = 46
integer y = 836
integer width = 4549
integer height = 1448
integer taborder = 70
string dataobject = "d_sal_020402"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event itemchanged;call super::itemchanged;Long   nRow
String sAuto, sOutStore, sNappum, sCvcod, sMsg=''
Dec    dVqty, dQty, dIoqty
Decimal {5}  dPrc

nRow = GetRow()
If nRow <= 0 Then Return

/* 창고자동승인 여부 */
sOutStore = GetItemString(nRow, 'depot_no')
select email into :sAuto from vndmst where cvcod = :sOutStore;
If IsNull(sAuto) Or sAuto = '' Then sAuto = 'N'

// 검수여부
sCvcod = GetItemString(nRow, 'cvcod')
SELECT "VNDMST"."GUMGU"   INTO :sNappum  FROM "VNDMST"  WHERE "VNDMST"."CVCOD" = :sCvcod;
If IsNull(sNappum) Then sNappum = 'N'
		
Choose Case GetColumnName()
	// 삭제 자료 선택
	Case 'flag_choice'
		If sAuto = 'N' Then	// 창고 수동승인인 경우
			If GetItemString(nRow, 'io_date') > '' Then
				sMsg = '승인 처리된 내역입니다'
			End If
			
			
		Else	// 자동승인인 경우
			If sNappum = 'Y' Then	// 납품검수업체인 경우
				If GetItemString(nRow, 'yebi1') > '' Then
					sMsg = '검수 처리된 내역입니다'
				End If
			Else	// 미검수업체인 경우
				If GetItemString(nRow, 'yebi4') > '' Then
					sMsg = '매출 확정처리된 내역입니다'
				End If				
			End If
			
			
			
		End If
		
		If sMsg > '' Then
			MessageBox('확 인',sMsg)
			Return 2
		End If
	// 수량조정시
	Case 'vqty'
		dVqty = Dec(GetText())
		
		dQty = GetItemNumber(nRow, 'ioreqty', Primary!, True)
		If dVqty > dQty Then
			MessageBox('확 인', '출고수량이상으로 조정하실 수 없습니다')
			Return 2
		End If

		If dVqty <= 0 Then
			MessageBox('확 인', '0 이하로 조정하실 수 없습니다')
			Return 2
		End If
				
		If sAuto = 'N' Then	// 창고 수동승인인 경우
			If GetItemString(nRow, 'io_date') > '' Then
				sMsg = '승인 처리된 내역입니다'
			Else
				dQty   = dVqty	// 의뢰수량
				dIoqty = 0		// 승인수량
			End If
		Else	// 자동승인인 경우
			If sNappum = 'Y' Then	// 납품검수업체인 경우
				If GetItemString(nRow, 'yebi1') > '' Then
					sMsg = '검수 처리된 내역입니다'
				End If
			Else	// 미검수업체인 경우
				If GetItemString(nRow, 'yebi4') > '' Then
					sMsg = '매출 확정처리된 내역입니다'
				End If				
			End If
			
			dQty   = dVqty	// 의뢰수량
			dIoqty = dVqty	// 승인수량
		End If
		
		If sMsg > '' Then
			MessageBox('확 인',sMsg)
			Return 2
		Else
			// 수량조정
			SetItem(nRow, 'ioreqty', dQty)
			SetItem(nRow, 'iosuqty', dIoQty)
			SetItem(nRow, 'ioqty',   dIoQty)
			
			// 금액계산
			dPrc = GetItemNumber(nRow, 'ioprc')
			SetItem(nRow, 'ioamt',  truncate(dqty * dPrc + 0.0000001 ,0))
			SetItem(nRow, 'foramt', truncate(dqty * GetItemNumber(nRow, 'dyebi2') + 0.0000001 ,2))
			
			If GetItemString(nRow, 'lclgbn') = 'L' Then
				SetItem(nRow, 'dyebi3', 0)
			Else
				SetItem(nRow, 'dyebi3', truncate(dqty * dPrc * 0.1 + 0.0000001 ,0))
			End If
		End If
		
		If dVqty > 0 Then
			SetItem(nRow, 'flag_choice', 'Y')
		Else
			SetItem(nRow, 'flag_choice', 'N')
		End If
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

type dw_haldang from u_d_popup_sort within w_sal_02040
integer x = 50
integer y = 832
integer width = 4553
integer height = 1448
integer taborder = 90
string dataobject = "d_sal_020403"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemerror;Return 1
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event itemchanged;Long 	 nRow, nHRow, iRtnValue
Double lOldQty, dItemQty, nNapQty, dValidQty, dJegoQty
String   sItnbr, sPspec, sDepot, sAuto

nRow = GetRow()
If nRow <= 0 Then Return

sle_msg.Text = ''
sItnbr  = GetItemString(nRow,'itnbr')
		
Choose Case GetColumnName()
	Case 'flag_choice'
		dValidQty = GetItemNumber(nRow,"valid_qty")
		IF IsNull(dValidQty) THEN dValidQty =0
		
		dJegoQty = wf_calc_Jego(nRow)
		IF IsNull(dJegoQty) THEN dJegoQty =0

		If GetText() = 'Y' Then
			
			/* -- 창고 재고 허용여부 -- */
			sDepot = GetItemString(nRow, 'depot_no')
			select substr(kyungy,1,1) into :sMinus
			  from vndmst
			 where cvcod = :sDepot;
			
			If	IsNull(sMinus) Then sMinus = 'N'

			If sMinus = 'Y' Then
				Return
			Else
				IF dValidQty > dJegoQty THEN
			           MessageBox('확 인', sItnbr + ' [출고수량은 재고수량 이상으로 할 수 없습니다]~r~n~r~n'+ &
						  '재고수량 = ' + string(dJegoQty))
					sle_msg.Text = '재고수량이 부족합니다.!!'
					SetItem(nRow,"flag_choice", 'N')
					Return 2
				END IF
			End If
		End If
	/* 사양 변경*/
	Case 'pspec'
		sPspec = GetText()
		sItnbr  = GetItemString(nRow,'itnbr')
		If Not IsNull(sItnbr) Then	
			/* 판매단가및 할인율 */
			iRtnValue = wf_calc_danga(nRow, sItnbr,sPspec)
			If 	iRtnValue =  1 Then 			Return 1
			SetItem(nRow,"flag_choice", 'Y')
		End If		
	/* 출고수량 분할*/
	Case 'choice_qty'
		dItemQty = Long(GetText())
		If 	dItemQty < 0 Then
			MessageBox('확 인','[출고수량은 0이하로 할 수 없습니다]')
			Return 1
		End If
		
		lOldQty = GetItemNumber(nRow, 'valid_qty', Primary!, True)
		sle_msg.text = '할당잔량 = ' + string(loldqty)
		
		If dItemQty > lOldQty Then
			/* 자동추가할당 허용여부 - 2006.11.03 - 송병호 */
			select dataname into :sAuto from syscnfg
			 where sysgu = 'S' and serial = 1 and lineno = '91' ;
			if sAuto = 'Y' then
			else
				MessageBox('확 인','[출고수량은 할당잔량 이상으로 할 수 없습니다]~r~n~r~n'+'할당잔량 = ' + string(loldqty))
				Return 1
			end if
		End If
		
		nHRow 	= dw_haldang_list.GetSelectedRow(0)
		If 	nHRow > 0 Then
			/* 납품배수 */
			nNapQty = dw_haldang_list.GetItemNumber(nHrow,'napqty')
			If IsNull(nNapqty) Or nNapQty = 0 Then
			Else
				If Mod(dItemQty, nNapQty) <> 0 Then
					MessageBox('확 인','수량은 납품배수 범위내에서 가능합니다.!!~n~n납품배수 : ' +string(nNapqty)+'배수')
					Return 2
				End If
			End If
		End If
		
		SetItem(nRow, 'flag_choice', 'Y')
End Choose
end event

event clicked;call super::clicked;if row < 0 then
	dw_haldang.selectrow(0, false)
Else
	dw_haldang.selectrow(0, false)
	dw_haldang.selectrow(row, true)
End If
end event

event buttonclicked;call super::buttonclicked;datawindow dwname	
Long nRow
Dec  dQty

If dw_haldang.accepttext() <> 1 Then Return
//nRow = dw_haldang.GetSelectedRow(0)
nRow = row
If nRow <= 0 Then Return

If GetItemString(nRow, 'lotgub') = 'Y' Then
	dwname = dw_lot
	
	gs_gubun = dw_haldang.GetItemString(nRow, 'depot_no')
	gs_code  = dw_haldang.getitemstring(nRow, "itnbr")
	gs_codename = dw_haldang.getitemstring(nRow, "hold_no")
	gs_codename2 = string(dw_haldang.getitemNumber(nRow, "valid_qty"))
	
	openwithparm(w_stockwan_popup, dwname)
	If IsNull(gs_code) Or Not IsNumber(gs_code) Then Return
	
	dw_haldang.SetItem(nRow, 'choice_qty', Dec(gs_code))
	dw_haldang.SetItem(nRow, 'flag_choice', 'Y')
	
	setnull(gs_code)

End If

end event

type dw_print from datawindow within w_sal_02040
boolean visible = false
integer x = 1349
integer y = 116
integer width = 165
integer height = 104
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02610_r1_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_print1 from datawindow within w_sal_02040
boolean visible = false
integer x = 1157
integer y = 124
integer width = 169
integer height = 104
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_chul_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cbx_move from checkbox within w_sal_02040
integer x = 626
integer y = 116
integer width = 462
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "울산이동출고"
boolean checked = true
end type

type dw_autoimhist from datawindow within w_sal_02040
boolean visible = false
integer x = 1303
integer y = 1292
integer width = 2830
integer height = 328
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_020403_auto"
boolean resizable = true
boolean border = false
end type

