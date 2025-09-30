$PBExportHeader$w_sm04_00010.srw
$PBExportComments$출하물량 접수
forward
global type w_sm04_00010 from w_inherite
end type
type dw_ip from u_key_enter within w_sm04_00010
end type
type rb_1 from radiobutton within w_sm04_00010
end type
type rb_2 from radiobutton within w_sm04_00010
end type
type dw_update from datawindow within w_sm04_00010
end type
type dw_reffpf from datawindow within w_sm04_00010
end type
type dw_jego from datawindow within w_sm04_00010
end type
type pb_1 from u_pb_cal within w_sm04_00010
end type
type cb_1 from commandbutton within w_sm04_00010
end type
type rr_1 from roundrectangle within w_sm04_00010
end type
type rr_3 from roundrectangle within w_sm04_00010
end type
end forward

global type w_sm04_00010 from w_inherite
integer height = 2564
string title = "출하물량 접수"
dw_ip dw_ip
rb_1 rb_1
rb_2 rb_2
dw_update dw_update
dw_reffpf dw_reffpf
dw_jego dw_jego
pb_1 pb_1
cb_1 cb_1
rr_1 rr_1
rr_3 rr_3
end type
global w_sm04_00010 w_sm04_00010

type variables
// 공장구분
DataWindowChild idw_plnt
end variables

forward prototypes
public function decimal wf_num (string arg_num)
public function integer wf_hkcd6 (integer li_filenum)
public function integer wf_imhist ()
public function integer wf_gingub (integer li_filenum)
public function integer wf_hkcd2 (integer li_filenum)
public function string wf_dayname (string arg_date)
public function integer wf_jego (integer arg_row)
public function integer wf_update ()
public function string wf_hkcp5 (integer li_filenum)
public function integer wf_danga (integer nrow)
end prototypes

public function decimal wf_num (string arg_num);Dec dNum
String sChk

Choose Case Right(arg_num,1)
	Case '{'
		sChk = '0'
	Case 'A'
		sChk = '1'
	Case 'B'
		sChk = '2'
	Case 'C'
		sChk = '3'
	Case 'D'
		sChk = '4'
	Case 'E'
		sChk = '5'
	Case 'F'
		sChk = '6'
	Case 'G'
		sChk = '7'
	Case 'H'
		sChk = '8'
	Case 'I'
		sChk = '9'
	Case Else
		sChk = '0'
End Choose

dNum = Dec(Left(arg_num, Len(arg_num) -1) + sChk)

Return dNum
end function

public function integer wf_hkcd6 (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate
Long   nRow

dw_insert.Reset()
DO WHILE FileRead(li_FileNum, sLine) > 0
		
	nRow = dw_insert.InsertRow(0)
	
	sItnbr = ''
	sCvcod = ''
	
	dw_insert.SetItem(nRow, "SEQ1", 		Trim(Mid(sLine,1 ,12)))
	dw_insert.SetItem(nRow, "SEQ2", 		Trim(Mid(sLine,13,4)))
	/* 공장구분 - 거래처 */
	sTemp = Trim(Mid(sLine,17,2))
	
	SELECT RFNA2 INTO :sCvcod FROM REFFPF WHERE RFCOD = '8I' AND RFGUB = :sTemp;
	If IsNull(sCvcod) Or sCvcod = '' Then
		dw_insert.Setitem(nRow, 'ERR_V', 'V')
	End If
	dw_insert.SetItem(nRow, "SEQ3", 		Trim(Mid(sLine,17,2)))
	dw_insert.SetItem(nRow, "CVCOD",		sCvcod)
	
	/* PART NO */
	sTemp = Trim(Mid(sLine,19,15))
	If IsNumber(Left(sTemp,1)) Then
		sTemp = Left(sTemp,5) + '-' + Mid(sTemp,6)
	End If
	
	dw_insert.SetItem(nRow, "SEQ4", 		sTemp)
	
	SELECT ITNBR INTO :sItnbr FROM ITEMAS WHERE ITNBR = :sTemp;
	dw_insert.SetItem(nRow, "ITNBR", 		sTemp)
	
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		dw_insert.Setitem(nRow, 'ERR_I', 'I')
//	End If
	
	dw_insert.SetItem(nRow, "SEQ5", 		Trim(Mid(sLine,34,1)))
	dw_insert.SetItem(nRow, "SEQ6", 		Trim(Mid(sLine,35,11)))
	dw_insert.SetItem(nRow, "SEQ7", 		wf_num(Trim(Mid(sLine,46,7))))
	dw_insert.SetItem(nRow, "SEQ8", 		wf_num(Trim(Mid(sLine,53,10))))
	dw_insert.SetItem(nRow, "SEQ9", 		Trim(Mid(sLine,63,8)))
	dw_insert.SetItem(nRow, "SEQ10",		Trim(Mid(sLine,71,1)))
	dw_insert.SetItem(nRow, "SEQ11",		Trim(Mid(sLine,72,2)))
	dw_insert.SetItem(nRow, "SEQ12",		Trim(Mid(sLine,74,2)))
	dw_insert.SetItem(nRow, "SEQ13",		Trim(Mid(sLine,76,6)))
	dw_insert.SetItem(nRow, "SEQ14",		Trim(Mid(sLine,82,15)))
	dw_insert.SetItem(nRow, "SEQ15",		Trim(Mid(sLine,97,5)))
	dw_insert.SetItem(nRow, "SEQ16",		Trim(Mid(sLine,102,15)))
	dw_insert.SetItem(nRow, "SEQ17",		Trim(Mid(sLine,117,10)))
	dw_insert.SetItem(nRow, "SEQ18",		Trim(Mid(sLine,127,4)))
	dw_insert.SetItem(nRow, "SEQ19",		Trim(Mid(sLine,131,3)))
LOOP

return 1
end function

public function integer wf_imhist ();////Integer iFunctionValue, iRowCount, k, iMaxIoNo, iCurRow, iAryCnt, hrow=0, Inrow, OutRow
////String  sCvcod, sArea, sSaupj, sDirgb, sHoldNo, sNewHoldNo, sNewHoldSeq
////Decimal {5}  dOrdPrc, dValQty, dOrdAmt, dOrdQty, dVatAmt, dChkvat, dChkqty, dRstvat
////
////String sQcgub, sNull, sOutIoNo, sInIoNo, sHoldGu, sItnbr, sPspec, sInStore, sOutStore
////String sCustNapgi, sNaougu, sOrderNo, sAuto, sNappum, sIogbn
//
//
//SetNull(sNull)
//
//If dw_insert.RowCount() <= 0 Then Return -1
//
//LsSuBulDate = Trim(dw_ip.GetItemString(1,'order_date'))
//
//If f_datechk(LsSuBulDate) <> 1 Then
//  f_message_chk(1200,'[발행일자]')
//	Return -1
//End If
//
///* 판매출고 송장번호 채번 */
//iMaxIoNo = sqlca.fun_junpyo(gs_sabu,LsSuBulDate, 'C0')
//IF iMaxIoNo <= 0 THEN
//	f_message_chk(51,'')
//	ROLLBACK;
//	Return -1
//END IF
//commit;
//LsIoJpNo = LsSuBulDate + String(iMaxIoNo,'0000')
//
//
//dw_imhist.Reset()
//iAryCnt = 1
//
///* 거래처및 관할구역,검수구분(0:무검수,1:검수) */
//sCvcod = dw_insert.GetItemString(1, "sorder_cvcod")
//SELECT "VNDMST"."SAREA", "VNDMST"."GUMGU"   INTO :sArea, :sNappum
//  FROM "VNDMST"  
// WHERE "VNDMST"."CVCOD" = :sCvcod;
//
//If IsNull(sNappum) Then sNappum = 'N'
//
//
//For k = 1 TO dw_insert.RowCount()
//	IF dw_insert.GetItemString(k,"flag_choice") = 'Y' THEN
//
//		sSaupj   = Trim(dw_insert.GetItemSTring(k,"saupj"))
//		sOrderNo = Trim(dw_insert.GetItemString(k,"order_no"))
//		sIogbn 	= Trim(dw_insert.GetItemString(k,"hold_gu"))
//			
//		/* 출고단가 */
//		dOrdPrc = dw_insert.GetItemNumber(k,"sorder_order_prc")
//		If IsNull(dOrdPrc) Then dOrdPrc = 0
//
//		/* 출고수량 */
//		dValQty = dw_insert.GetItemNumber(k,"valid_qty")
//		If IsNull(dValQty) Then dValQty = 0
//		
//		/* 부가세 : 수주에 부가세가 포함될 경우 수량base로 배부하며 기타는 0.1을 곱해 계산한다 
//			단 수주에 부가세가 입력된 경우에 미출고수량이 0인 경우에는 현재 발행된 부가세를 제외한 금액을
//			입력한다. */
//		dChkVat = 0
//		dVatAmt = dw_insert.GetItemNumber(k,"vatamt")
//		dChkVat = dw_insert.GetItemNumber(k,"vatamt")		
//		If IsNull(dVatAmt) Then dVatAmt = 0
//		If dVatAmt <> 0 Then
//			dOrdQty = dw_insert.GetItemNumber(k,"order_qty")
//			dVatAmt = Truncate(dVatAmt / dOrdQty * dValQty, 0)
//		Else
//			dVatAmt = TrunCate(dOrdPrc * dValQty * 0.1, 0)
//		End If
//
//		sHoldGu = dw_insert.GetItemString(k, "hold_gu")
//		sItnbr  = dw_insert.GetItemString(k, "itnbr")
//		sPspec  = dw_insert.GetItemString(k, "pspec")
//		sOutStore = dw_insert.GetItemString(k, "depot_no")	/* 출고창고 */
//		sInStore  = dw_insert.GetItemString(k, "house_no")	/* 납품창고 */
//		
//		sCustNapgi  = dw_insert.GetItemString(k, "cust_napgi")
//		sNaougu  = dw_insert.GetItemString(k, "naougu")		
//		
//		SetNull(sInIoNo)
//
//		/* 직송과 직납 또는 이송후 납품인 경우만 판매출고 전표를 생성한다 */
//		If sDirgb = 'Y' Or sDirgb = 'D' Or sDirgb = 'S' Then
//			/* 납품창고 기준으로 수불구분에 따른 출고전표 생성 */
//			iCurRow = dw_imhist.InsertRow(0)
//			
//			dw_imhist.SetItem(iCurRow,"sabu",       gs_sabu)
//			
//			sOutIoNo = LsIoJpNo + String(iCurRow,'000')
//						
//			dw_imhist.SetItem(iCurRow,"iojpno", 	 sOutIoNo)
//			
//			dw_imhist.SetItem(iCurRow,"iogbn",      sHoldGu)
//			dw_imhist.SetItem(iCurRow,"sudat",      LsSuBulDate)
//			dw_imhist.SetItem(iCurRow,"itnbr",      sItnbr)
//			dw_imhist.SetItem(iCurRow,"itemas_itdsc",dw_insert.GetItemString(k,"itemas_itdsc"))
//			dw_imhist.SetItem(iCurRow,"itemas_ispec",dw_insert.GetItemString(k,"itemas_ispec"))
//			
//			dw_imhist.SetItem(iCurRow,"pspec",      sPspec)
//			
//			dw_imhist.SetItem(iCurRow,"depot_no",   dw_insert.GetItemString(k,"in_store"))
//			dw_imhist.SetItem(iCurRow,"cvcod",	    dw_insert.GetItemString(k,"sorder_cvcod"))
//
//			dw_imhist.SetItem(iCurRow,"sarea",	    sArea)
//			
//			/* 단가 및 금액 */
//			dw_imhist.SetItem(iCurRow,"ioprc",		 dw_insert.GetItemNumber(k,"sorder_order_prc"))
//			dw_imhist.SetItem(iCurRow,"ioamt",		 TrunCate(dOrdPrc * dValQty,0))
//			
//			dw_imhist.SetItem(iCurRow,"insdat",     LsSuBulDate)
//			dw_imhist.SetItem(iCurRow,"ioreqty",	 dValQty)
//			dw_imhist.SetItem(iCurRow,"iosuqty",	 dValQty)
//			If sDirgb = 'D' Or sDirgb = 'S'  Then	/* 직납인 경우만 할당번호 입력 */
//				dw_imhist.SetItem(iCurRow,"hold_no",	 dw_insert.GetItemString(k,"hold_no"))
//			End If
//			
//			/* 이송후 출하일 경우 수주번호를 pjt_cd */
//			If sDirgb = 'S' Then
//				dw_imhist.SetItem(iCurRow,"order_no",	 dw_insert.GetItemString(k,"pjt_cd"))
//			Else
//				dw_imhist.SetItem(iCurRow,"order_no",	 dw_insert.GetItemString(k,"order_no"))
//			End If
//
//			dw_imhist.SetItem(iCurRow,"filsk",   	 dw_insert.GetItemString(k,"itemas_filsk")) /* 재고관리구분 */
//			dw_imhist.SetItem(iCurRow,"itgu",	    dw_insert.GetItemString(k,"itemas_itgu"))  /* 구입형태 */
//			dw_imhist.SetItem(iCurRow,"bigo",	    dw_insert.GetItemString(k,"sorder_order_memo"))
//			dw_imhist.SetItem(iCurRow,"pjt_cd",	    dw_insert.GetItemString(k,"sorder_project_no")) /* 프로젝트 번호 */
//			dw_imhist.SetItem(iCurRow,"outchk",	    'N')
//			dw_imhist.SetItem(iCurRow,"jnpcrt",	    '004')	/* 전표생성구분 */
//	
//			dw_imhist.SetItem(iCurRow,"ioredept",	 dw_insert.GetItemString(k,"sorder_deptno"))
//			dw_imhist.SetItem(iCurRow,"ioreemp",	 dw_insert.GetItemString(k,"emp_id"))
//			dw_imhist.SetItem(iCurRow,"opseq",	    '9999')
//			dw_imhist.SetItem(iCurRow,"saupj",	    sSaupj)	/* 부가사업장 */
//			dw_imhist.SetItem(iCurRow,"ip_jpno",    sInIoNo)
//
//
//			dw_imhist.SetItem(iCurRow,"dyebi3",	    dVatAmt)/* 부가세 */
//
//						
//			/* 자동승인여부 */
//			sAuto = Trim(dw_insert.GetItemString(k,"email"))
//			If IsNull(sAuto) Or sAuto = '' Then sAuto = 'N'
//			
//			If sAuto = 'Y' Then
//				dw_imhist.SetItem(iCurRow,"ioqty",		 dValQty)
//				dw_imhist.SetItem(iCurRow,"io_date",    LsSuBulDate)
//				dw_imhist.SetItem(iCurRow,"io_empno",	 dw_insert.GetItemString(k,"emp_id"))
//				
//				/* 검수일자 사용안할 경우, 수출일 경우 */
//				If sNappum = 'N'  Then
//					dw_imhist.SetItem(iCurRow,"yebi1",   LsSuBulDate)
//				End If
//			Else
//				dw_imhist.SetItem(iCurRow,"ioqty",		 0)
//				dw_imhist.SetItem(iCurRow,"io_date",    sNull)
//				dw_imhist.SetItem(iCurRow,"io_empno",	 sNull)
//			End If
//		End If
//
//		iAryCnt = iAryCnt + 1
//
//		/* 할당상태변경 */
//		dw_insert.SetItem(k,'out_chk', '2')		/* 출고의뢰 */
//	END IF
//Next
//
//
//IF dw_imhist.Update() = 1 Then
//Else
//	ROLLBACK;
//	Messagebox("입출고저장", "입출고저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
//	Return -1
//End If
//
//
///* 거래명세표 번호 출력 */
////sqlca.ERP000000580(gs_sabu, LsIoJpNo)
////IF sqlca.sqlcode <> 0 Then
////	f_message_chk(32,'')
////	ROLLBACK;
////	Return -1
////END IF
//
//COMMIT;
//
//
Return 1
end function

public function integer wf_gingub (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate
Long   nRow

dw_insert.Reset()
DO WHILE FileRead(li_FileNum, sLine) > 0
	

	nRow = dw_insert.InsertRow(0)
	
	sItnbr = ''
	sCvcod = ''
	
	dw_insert.SetItem(nRow, "SEQ1", 		Trim(Mid(sLine,1 ,4)))
	dw_insert.SetItem(nRow, "SEQ2", 		Trim(Mid(sLine,5,2)))
	/* 공장구분 - 거래처 */
	sTemp = Trim(Mid(sLine,7,2))
	
	SELECT RFNA2 INTO :sCvcod FROM REFFPF WHERE RFCOD = '8I' AND RFGUB = :sTemp;
	If IsNull(sCvcod) Or sCvcod = '' Then
		dw_insert.Setitem(nRow, 'ERR_V', 'V')
	End If
	
	dw_insert.SetItem(nRow, "SEQ3", 		Trim(Mid(sLine,7,2)))
//	dw_insert.SetItem(nRow, "CVCOD",		sCvcod)
	
	/* PART NO */
	sTemp = Trim(Mid(sLine,9,15))
	If IsNumber(Left(sTemp,1)) Then
		sTemp = Left(sTemp,5) + '-' + Mid(sTemp,6)
	End If
	
	dw_insert.SetItem(nRow, "SEQ4", 		sTemp)
	
//	SELECT ITNBR INTO :sItnbr FROM ITEMAS WHERE ITNBR = :sTemp;
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		dw_insert.Setitem(nRow, 'ERR_I', 'I')
//	End If
	
	dw_insert.SetItem(nRow, "SEQ5", 		Trim(Mid(sLine,24,8)))
	dw_insert.SetItem(nRow, "SEQ6", 		Trim(Mid(sLine,32,2)))
	dw_insert.SetItem(nRow, "SEQ7", 		Trim(Mid(sLine,34,2)))
	
	dw_insert.SetItem(nRow, "SEQ8", 		wf_num(Trim(Mid(sLine,36,9))))
	dw_insert.SetItem(nRow, "SEQ9", 		Trim(Mid(sLine,45,11)))
	dw_insert.SetItem(nRow, "SEQ10",		Trim(Mid(sLine,56,8)))
	dw_insert.SetItem(nRow, "SEQ11",		Trim(Mid(sLine,64,1)))
LOOP

return 1
end function

public function integer wf_hkcd2 (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate
Long   nRow
DataStore ds

SetPointer(HourGlass!)

/* HMC 주간 소요량 */
ds = create datastore
ds.dataobject = 'd_hkcd2'
ds.SetTransobject(sqlca)

DO WHILE FileRead(li_FileNum, sLine) > 0
		
	nRow = ds.InsertRow(0)
	
	sItnbr = ''
	sCvcod = ''
	
	ds.SetItem(nRow, "SEQ1", 		Trim(Mid(sLine,1 ,12)))
	ds.SetItem(nRow, "SEQ2", 		Trim(Mid(sLine,13,4)))
	/* 공장구분 - 거래처 */
	sTemp = Trim(Mid(sLine,17,2))
	
	SELECT RFNA2 INTO :sCvcod FROM REFFPF WHERE RFCOD = '8I' AND RFGUB = :sTemp;
	If IsNull(sCvcod) Or sCvcod = '' Then
		ds.Setitem(nRow, 'ERR_V', 'V')
	End If
	ds.SetItem(nRow, "SEQ3", 		Trim(Mid(sLine,17,2)))
	ds.SetItem(nRow, "CVCOD",		sCvcod)
	
	/* PART NO */
	sTemp = Trim(Mid(sLine,19,15))
	If IsNumber(Left(sTemp,1)) Then
		sTemp = Left(sTemp,5) + '-' + Mid(sTemp,6)
	End If
	
	ds.SetItem(nRow, "SEQ4", 		sTemp)
	
	SELECT ITNBR INTO :sItnbr FROM ITEMAS WHERE ITNBR = :sTemp;
	If IsNull(sItnbr) Or sItnbr = '' Then
		ds.Setitem(nRow, 'ERR_I', 'I')
	End If
	
	ds.SetItem(nRow, "SEQ5", 		wf_num(Trim(Mid(sLine,34,7))))
	ds.SetItem(nRow, "SEQ6", 		wf_num(Trim(Mid(sLine,41,7))))
	ds.SetItem(nRow, "SEQ7", 		wf_num(Trim(Mid(sLine,48,5))))
	ds.SetItem(nRow, "SEQ8", 		wf_num(Trim(Mid(sLine,53,5))))
	ds.SetItem(nRow, "SEQ9", 		wf_num(Trim(Mid(sLine,58,5))))
	ds.SetItem(nRow, "SEQ10",		wf_num(Trim(Mid(sLine,63,5))))
	ds.SetItem(nRow, "SEQ11",		wf_num(Trim(Mid(sLine,68,5))))
	ds.SetItem(nRow, "SEQ12",		wf_num(Trim(Mid(sLine,73,5))))
	ds.SetItem(nRow, "SEQ13",		wf_num(Trim(Mid(sLine,78,5))))
	ds.SetItem(nRow, "SEQ14",		wf_num(Trim(Mid(sLine,83,5))))
	ds.SetItem(nRow, "SEQ15",		wf_num(Trim(Mid(sLine,88,5))))
	ds.SetItem(nRow, "SEQ16",		wf_num(Trim(Mid(sLine,93,5))))
	ds.SetItem(nRow, "SEQ17",		wf_num(Trim(Mid(sLine,98,5))))
	ds.SetItem(nRow, "SEQ18",	   Dec(Mid(sLine,103,5)))
	ds.SetItem(nRow, "SEQ19",		Dec(Mid(sLine,108,5)))
	ds.SetItem(nRow, "SEQ20",		Dec(Mid(sLine,113,5)))
	ds.SetItem(nRow, "SEQ21",		Dec(Mid(sLine,118,5)))
	ds.SetItem(nRow, "SEQ22",		Dec(Mid(sLine,123,5)))
	ds.SetItem(nRow, "SEQ23",		Dec(Mid(sLine,128,5)))
	ds.SetItem(nRow, "SEQ24",		Dec(Mid(sLine,133,5)))
	ds.SetItem(nRow, "SEQ25",		Dec(Mid(sLine,138,5)))
	ds.SetItem(nRow, "SEQ26",		Dec(Mid(sLine,143,5)))
	ds.SetItem(nRow, "SEQ27",		Dec(Mid(sLine,148,5)))
	ds.SetItem(nRow, "SEQ28",		Dec(Mid(sLine,153,5)))
	ds.SetItem(nRow, "SEQ29",		Dec(Mid(sLine,158,6)))
	ds.SetItem(nRow, "SEQ30",		Dec(Mid(sLine,164,7)))
	ds.SetItem(nRow, "SEQ31",		Trim(Mid(sLine,171,1)))
LOOP

If ds.Update() <> 1 Then
	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return -1
End If

COMMIT;

destroy ds

return 1

end function

public function string wf_dayname (string arg_date);string sDaygubn

SELECT DAYGUBN INTO :sDaygubn FROM P4_CALENDAR WHERE CLDATE = :arg_date;

Choose Case sDaygubn
	Case '1'
		Return '일'
	Case '2'
		Return '월'
	Case '3'
		Return '화'
	Case '4'
		Return '수'
	Case '5'
		Return '목'
	Case '6'
		Return '금'
	Case '7'
		Return '토'
End Choose

Return ''
end function

public function integer wf_jego (integer arg_row);String sItnbr
Dec    dJego, dVjego, dqty, dvqty, dprodqty, dTemp
Long   ix, nEnd, iy

If arg_row <= 0 Then Return 1

sItnbr = Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

dw_jego.Retrieve(gs_sabu, sItnbr)

If dw_jego.RowCount() > 0 Then
	dJego		= dw_jego.GetItemNumber(1, 'jego')
	If IsNull(dJego) Then dJego = 0
Else
	dJego	= 0
End If

dVjego		= dw_insert.GetItemNumber(arg_row, 'jego_qty')
dprodqty    = dw_insert.GetItemNumber(arg_row, 'jprod_qty')

// 재고
dw_insert.Modify("t_jego.text ='"    +string(djego,  '#,##0') +"'")
//dw_insert.Modify("t_vjego.text ='"   +string(dVjego, '#,##0') +"'")
dw_insert.Modify("t_jprod_qty.text ='"   +string(dprodqty, '#,##0') +"'")

If dw_ip.GetItemString(1, 'cust') = '1' Then
	nEnd = 15
Else
	nEnd = 15
End If 

For ix = 1 To nEnd
	/* 품목별 */
	dQty = 0
	For iy = 1 To dw_insert.RowCount()
		If sItnbr = Trim(dw_insert.GetItemString(iy, 'itnbr')) Then
			dTemp = dw_insert.GetItemNumber(iy, 'iqty'+string(ix))
			If IsNull(dTemp) Then dTemp = 0
			dQty += dTemp
		End If
	Next
	dJego  = dJego  - dQty
	
	/* 납품장소별 */
	dvqty  = dw_insert.GetItemNumber(arg_row, 'iqty'+string(ix))
	
	dvJego = dvJego + dw_insert.GetItemNumber(arg_row, 'iqty'+string(ix)) // 출하물량   +
	dvJego = dvJego - dw_insert.GetItemNumber(arg_row, 'pqty'+string(ix)) // 생산예정량 -
	
	dw_insert.Modify("t_jego"  + string(ix) + ".text ='"   +string(dvJego,  '#,##0 ') +"'")
Next

return 1
end function

public function integer wf_update ();// 주간부품 소요량 update
String sCust, sOrderDate, sToday, sDate, sCVcod, sItnbr
Long	 ix, nfind, nrow, ncnt
Dec	 dDanga, dqty1, dqty2, dqty3, dqty4, dqty5, dqty6,dqty7
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return -1

sOrderDate = Trim(dw_ip.GetItemString(1, 'order_date'))
sCust		  = Trim(dw_ip.GetItemString(1, 'cust'))

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

dw_update.DataObject = 'd_sm04_00010_3'
dw_update.SetTransObject(sqlca)

/* 기존자료 삭제 */
SELECT COUNT(*) INTO :nCnt 
 FROM SM04_DAILY_ITEM 
WHERE SAUPJ = :sSaupj AND YYMMDD = :sOrderDate AND GUBUN = '1' AND CNFIRM IS NOT NULL;
If nCnt > 0 Then
	MessageBox('확 인','출하의뢰된 내역이 존재합니다.!!')
	Return -1
End If

// 단가 기준일
sToday = sOrderDate

DELETE FROM SM04_DAILY_ITEM WHERE SAUPJ = :sSaupj AND YYMMDD = :sOrderDate AND GUBUN = '1' AND CNFIRM IS NULL;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	ROLLBACK;
	Return -1
End If

For ix = 1 to dw_insert.RowCount()	
	If dw_insert.GetItemString(ix, 'err_v') = 'V' Or dw_insert.GetItemString(ix, 'err_i') = 'I' Then
	Else
		sCvcod = dw_insert.GetItemString(ix, 'cvcod')
		sItnbr = dw_insert.GetItemString(ix, 'seq4')
		
		/* 중복되는 거래처/품번을 찾는다 */
		nFind = dw_update.Find("cvcod = '" + scvcod +"' and itnbr = '"+sItnbr +"'", 1, dw_update.RowCount())
		If nFind = 0 Then
			nRow = dw_update.InsertRow(0)
		
			dw_update.SetItem(nRow, 'saupj',   sSaupj)
			dw_update.SetItem(nRow, 'yymmdd', sOrderDate)
			dw_update.SetItem(nRow, 'gubun',  '1')
			dw_update.SetItem(nRow, 'cvcod',  dw_insert.GetItemString(ix, 'cvcod'))
			dw_update.SetItem(nRow, 'itnbr',  dw_insert.GetItemString(ix, 'seq4'))
			
			select fun_erp100000012_1(:sToday, :sCvcod, :sItnbr, '1') into :ddanga from dual;
			//dDanga = SQLCA.fun_erp100000012_1(sToday, sCvcod, sItnbr, '1')
			If IsNull(dDanga) Then dDanga = 0
			
			dw_update.SetItem(nRow, 'ITM_PRC',  dDanga)
			dw_update.SetItem(nRow, 'ITM_QTY1',  dw_insert.GetItemNumber(ix, 'seq18'))
			dw_update.SetItem(nRow, 'ITM_QTY2',  dw_insert.GetItemNumber(ix, 'seq19'))
			dw_update.SetItem(nRow, 'ITM_QTY3',  dw_insert.GetItemNumber(ix, 'seq20'))
			dw_update.SetItem(nRow, 'ITM_QTY4',  dw_insert.GetItemNumber(ix, 'seq21'))
			dw_update.SetItem(nRow, 'ITM_QTY5',  dw_insert.GetItemNumber(ix, 'seq22'))
			dw_update.SetItem(nRow, 'ITM_QTY6',  dw_insert.GetItemNumber(ix, 'seq23'))
			dw_update.SetItem(nRow, 'ITM_QTY7',  dw_insert.GetItemNumber(ix, 'seq24'))
		Else
			nRow = nFind

			dQty1 = dw_update.GetItemNumber(nRow, 'ITM_QTY1')
			dQty2 = dw_update.GetItemNumber(nRow, 'ITM_QTY2')
			dQty3 = dw_update.GetItemNumber(nRow, 'ITM_QTY3')
			dQty4 = dw_update.GetItemNumber(nRow, 'ITM_QTY4')
			dQty5 = dw_update.GetItemNumber(nRow, 'ITM_QTY5')
			dQty6 = dw_update.GetItemNumber(nRow, 'ITM_QTY6')
			dQty7 = dw_update.GetItemNumber(nRow, 'ITM_QTY7')
			If IsNull(dQty1) Then dQty1 = 0
			If IsNull(dQty2) Then dQty2 = 0
			If IsNull(dQty3) Then dQty3 = 0
			If IsNull(dQty4) Then dQty4 = 0
			If IsNull(dQty5) Then dQty5 = 0
			If IsNull(dQty6) Then dQty6 = 0
			If IsNull(dQty7) Then dQty7 = 0
			
			dw_update.SetItem(nRow, 'ITM_QTY1',  dQty1 + dw_insert.GetItemNumber(ix, 'seq18'))
			dw_update.SetItem(nRow, 'ITM_QTY2',  dQty2 + dw_insert.GetItemNumber(ix, 'seq19'))
			dw_update.SetItem(nRow, 'ITM_QTY3',  dQty3 + dw_insert.GetItemNumber(ix, 'seq20'))
			dw_update.SetItem(nRow, 'ITM_QTY4',  dQty4 + dw_insert.GetItemNumber(ix, 'seq21'))
			dw_update.SetItem(nRow, 'ITM_QTY5',  dQty5 + dw_insert.GetItemNumber(ix, 'seq22'))
			dw_update.SetItem(nRow, 'ITM_QTY6',  dQty6 + dw_insert.GetItemNumber(ix, 'seq23'))
			dw_update.SetItem(nRow, 'ITM_QTY7',  dQty7 + dw_insert.GetItemNumber(ix, 'seq24'))
		End If
	End If
Next

If dw_update.Update() <> 1 Then
	RollBack;
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	Return -1
End If

COMMIT;

Return 0
end function

public function string wf_hkcp5 (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate, sOrderDate
Long   nRow
String sSaupj

sOrderDate = dw_ip.GetItemString(1, 'order_date')


/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return "생성된 자료 없습"
End If

SetPointer(HourGlass!)

dw_update.Reset()
DO WHILE FileRead(li_FileNum, sLine) > 0
	
	If sOrderDate <> Trim(Mid(sLine,3 ,8)) Then Continue
	If Trim(Mid(sLine,20 ,1)) = 'H' Then Continue
	
	nRow = dw_update.InsertRow(0)
	
	sItnbr = ''
	sCvcod = ''
	
	dw_update.SetItem(nRow, "S1", 		Trim(Mid(sLine,3 ,8)))
	
	/* 공장구분 - 거래처 */
	sTemp = Trim(Mid(sLine,21,2))
	
	dw_update.SetItem(nRow, "S2", 		Trim(Mid(sLine,21,2)))

	dw_update.SetItem(nRow, "S3", 		string(nrow))	// 일련번호
	dw_update.SetItem(nRow, "S4", 		Trim(Mid(sLine,27,2)))	// Name code
	dw_update.SetItem(nRow, "S5", 		Trim(Mid(sLine,29,7)))	// Style code
	dw_update.SetItem(nRow, "S6", 		Trim(Mid(sLine,36,10)))	// Model Name
	dw_update.SetItem(nRow, "S7", 		Trim(Mid(sLine,46,20)))	// style name
	dw_update.SetItem(nRow, "N1", 		wf_num(Trim(Mid(sLine,66,5)))) // 재고
	dw_update.SetItem(nRow, "N2", 		wf_num(Trim(Mid(sLine,71,5)))) // 전일실적
	dw_update.SetItem(nRow, "N3", 		dec(Trim(Mid(sLine,76,5)))) // D
	dw_update.SetItem(nRow, "N4", 		dec(Trim(Mid(sLine,81,5)))) // D+1
	dw_update.SetItem(nRow, "N5", 		dec(Trim(Mid(sLine,86,5)))) // D+2
	dw_update.SetItem(nRow, "outqty",	dec(Trim(Mid(sLine,76,5)))) // D
LOOP

If dw_update.Update() <> 1 Then
	RollBack;
	dw_update.Reset()
	Return "생성된 자료 없습"
End If

insert into sm04_daily_item
  ( saupj, yymmdd, gubun, cvcod, itnbr, itm_prc, itm_qty1, itm_qty2, itm_qty3, itm_qty4, itm_qty5, itm_qty6, itm_qty7, vndstk, jprod_qty )
	select :sSaupj, :sOrderDate, '1', z.rfna2, y.itnbr, fun_erp100000012_1(:sOrderDate,z.rfna2, y.itnbr,'1') as prc,
			 sum(x.outqty * y.usage) as qty,
			 sum(x.n4 * y.usage) , sum(x.n5 * y.usage) ,0,0,0,0,
			 y.tmcd,
			 sum(x.n2 * y.usage)
	  from hkcp5 x,
			( SELECT A.CARCODE, NVL(A.TMCD,'.') AS TMCD, B.ITNBR, B.USAGE
				 FROM CARMST A, CARBOM B
				WHERE A.CARGBN1 = '4'
				  AND A.CARCODE = B.CARCODE
				  AND A.SEQ = B.SEQ ) y,
			 reffpf z
	 where x.s1 = :sOrderDate
		and x.s5 = y.carcode
		and z.rfcod = '8I'
		and z.rfgub = x.s2
	 group by z.rfna2, y.itnbr, y.tmcd;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	ROLLBACK;
	return "비정상 완료-생성자료 없슴"
End If

COMMIT;

If dw_update.RowCount() > 0 Then
	return "정상 완료"
Else
	return "정상 완료-생성자료 없슴"
End If
end function

public function integer wf_danga (integer nrow);String sCvcod, sItnbr, stoday
Dec	 dDanga

If nRow <= 0 Then Return 1

sToday	= f_today()
sCvcod	= Trim(dw_insert.GetItemString(nRow, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(nRow, 'itnbr'))

select fun_erp100000012_1(:sToday, :sCvcod, :sItnbr, '1') into :dDanga from dual;
//dDanga = SQLCA.fun_erp100000012_1(sToday, sCVCOD, sITNBR, '1')
If IsNull(dDanga) Then dDanga = 0

//dw_insert.Setitem(nRow, 'sprc', dDanga)

Return 0


end function

on w_sm04_00010.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_update=create dw_update
this.dw_reffpf=create dw_reffpf
this.dw_jego=create dw_jego
this.pb_1=create pb_1
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_update
this.Control[iCurrent+5]=this.dw_reffpf
this.Control[iCurrent+6]=this.dw_jego
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_3
end on

on w_sm04_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_update)
destroy(this.dw_reffpf)
destroy(this.dw_jego)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_reffpf.SetTransObject(sqlca)

dw_jego.SetTransObject(sqlca)

dw_update.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

// 공장구분
dw_ip.GetChild('plnt', idw_plnt)
idw_plnt.SetTransObject(SQLCA)
idw_plnt.Retrieve()

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

f_mod_saupj(dw_ip, 'saupj')

dw_ip.SetItem(1, 'order_date', f_today())

dw_reffpf.retrieve()
end event

type dw_insert from w_inherite`dw_insert within w_sm04_00010
integer x = 41
integer y = 276
integer width = 4535
integer height = 1984
integer taborder = 160
string dataobject = "d_sm04_00010_6"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;String sNull, sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, get_nm
Long	 nRow, nFind
Int	 iReturn

setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		If sItnbr > '' Then
			nFind = This.Find("itnbr = '"+sitnbr+"'",1, this.Rowcount())
			If nFind <> nRow And nFind > 0 Then
				MessageBox('확인','동일한 품목이 등록되있습니다!')
				Return 1
			End If
		End If
		
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itemas_itdsc", sitdsc)	
		
		Post wf_danga(nrow)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS2"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'cvnas', get_nm)
			
			Post wf_danga(nrow)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case Else
		Post wf_jego(nrow)
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(lrow,"itnbr",gs_code)
		
		TriggerEvent(Itemchanged!)
//		this.SetItem(lrow,"itemas_itdsc",gs_codename)
		
//		Post wf_danga(lrow)
		
//		Return 1
	Case 'cvcod'
		gs_code = GetText()

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(lrow, "cvcod", gs_Code)
		this.SetItem(lrow, "cvnas", gs_Codename)
		
		Post wf_danga(lrow)
End Choose
end event

event dw_insert::rowfocuschanged;if currentrow > 0 then
	selectrow(0,false)
	selectrow(currentrow, true)
else
	selectrow(0,TRUE)
end if

Post wf_jego(currentrow)
end event

event dw_insert::clicked;call super::clicked;if row > 0 then
	selectrow(0,false)
	selectrow(row, true)
	SetRow(row)
else
	selectrow(0,TRUE)
end if

Post wf_jego(row)
end event

type p_delrow from w_inherite`p_delrow within w_sm04_00010
integer x = 3918
integer taborder = 90
end type

event p_delrow::clicked;call super::clicked;String sOrderDate, sPlnt, svndstk, sItnbr, sCvcod, sGidate, host_jpno, sHoldNo, sCust
Long ix,iy, nCnt, nUpd=0, host_iono, host_seqno, NROW
Boolean bOk = False
Dec	 dIqty, dPqty, dOldIQty, dOldPqty, dDqty1, dDqty2, dOldDD1, dOldDD2
String sSaupj

If dw_insert.AcceptText() <> 1 Then Return
ix = dw_insert.GetRow()
If ix <= 0 Then Return

If f_msg_delete() <> 1 Then Return

// 기준일자
sOrderDate = Trim(dw_ip.GetItemString(1, 'order_date'))
sCust 	  = dw_ip.GetItemString(1, 'cust')

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

sPlnt		= Trim(dw_insert.GetItemString(ix, 'plnt'))
svndstk	= Trim(dw_insert.GetItemString(ix, 'vndstk'))
sItnbr	= Trim(dw_insert.GetItemString(ix, 'itnbr'))
sCvcod	= Trim(dw_insert.GetItemString(ix, 'cvcod'))


DELETE FROM SM04_DAILY_ITEM
 WHERE SAUPJ = :sSaupj
	AND YYMMDD >= :sOrderDate
	AND CVCOD = :sCvcod
	AND ITNBR = :sItnbr
	AND PLNT = :sPlnt
	AND VNDSTK = :sVndstk
	AND GUBUN = :sCust
	AND ISQTY = 0;

If SQLCA.SQLCODE <> 0 Then
	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return
End If

COMMIT;

MessageBox('확인', '삭제하였습니다.!!')

p_inq.TriggerEvent(Clicked!)

ib_any_typing = FALSE
end event

type p_addrow from w_inherite`p_addrow within w_sm04_00010
integer x = 3744
integer taborder = 80
end type

event p_addrow::clicked;call super::clicked;String sYymm, sCust, sGate, scvcod
Long	 nRow, dMax

If dw_ip.AcceptText() <> 1 Then Return

sYymm = Trim(dw_ip.GetItemString(1, 'order_date'))
scust = Trim(dw_ip.GetItemString(1, 'cust'))
sGate = Trim(dw_ip.GetItemString(1, 'plnt'))

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

If IsNull(scust) Or scust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

If IsNull(sGate) Or sGate = '' Then
	f_message_chk(1400,'[공장]')
	Return
End If

select rfna2 into :scvcod from reffpf where rfcod = '8I' and rfgub = :sGate;

If IsNull(scvcod) Or scvcod = '' Then
	f_message_chk(1400,'[공장-거래처]')
	Return
End If

nRow = dw_insert.InsertRow(0)

//dw_insert.SetItem(nRow, 'sabu', 	 gs_sabu)
//dw_insert.SetItem(nRow, 'yymmdd', sYymm)
//dw_insert.SetItem(nRow, 'gubun',  scust)
dw_insert.SetItem(nRow, 'vndstk', sgate)
dw_insert.SetItem(nRow, 'cvcod',  scvcod)
dw_insert.SetItem(nRow, 'plnt',  sgate)

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('cvcod')
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_sm04_00010
integer x = 3323
integer taborder = 140
string picturename = "C:\erpman\image\자료생성_up.gif"
end type

event p_search::clicked;//String sYymm
//Long   nCnt
//
//If dw_ip.AcceptText() <> 1 Then Return
//
//syymm = trim(dw_ip.getitemstring(1, 'order_date'))
//If IsNull(syymm) Or sYymm = '' Then
//	f_message_chk(1400,'[기준일자]')
//	Return
//End If
//
//gs_code = sYymm
//Open(w_sm04_00010_1)
//
//
//

String docname, sCust, sPlanDate, sWeekDate, sMsg, sCustName, sReturn, sDate, eDate, stemp, sLine, sModel
Int	 li_filenum, irtn
Long   nCnt, icust, ix, iy, irow, nfind
Dec	 nQty
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return

sPlanDate	= Trim(dw_ip.GetItemString(1,'order_date'))
If f_datechk(sPlanDate) <> 1 Then
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

If  MessageBox("자료생성", '주간계획으로부터 출하의뢰 자료를 일괄생성합니다.', Exclamation!, OKCancel!, 1) = 2 Then Return

/* 고객별 출하의뢰 자료 생성 */
sMsg = ''

// 주간계획 수립일자 조회
SELECT MIN(WEEK_SDATE) INTO :sWeekDate FROM PDTWEEK 
 WHERE WEEK_YEAR = SUBSTR(:sPlanDate,1,4) 
	AND WEEK_YEAR_JUCHA IN (SELECT WEEK_YEAR_JUCHA FROM PDTWEEK WHERE WEEK_SDATE <= :sPlanDate AND WEEK_LDATE >= :sPlanDate );
		
w_mdi_frame.sle_msg.text = sCustName +": 주간계획에서 자료를 읽어옵니다.!!"
			
SELECT COUNT(*) INTO :nCnt FROM SM03_WEEKPLAN_ITEM
 WHERE SAUPJ = :sSaupj
	AND YYMMDD = :sWeekDate
	AND CNFIRM IS NOT NULL;

//MESSAGEBOX(SSAUPJ, SWEEKDATE)

// 고객구분 'A' :GMDAT
sCust = 'A'

If nCnt > 0 Then
	iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
	If iRtn <> 1 Then
		RollBack;
		MessageBox('확인', '생성실패')
	Else
		COMMIT;
		MessageBox('확인', '정상완료')
	End If
Else
	MessageBox('확인', '주간계획 미마감')
End If
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\자료생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\자료생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm04_00010
boolean visible = false
integer taborder = 60
end type

type p_exit from w_inherite`p_exit within w_sm04_00010
integer taborder = 130
end type

type p_can from w_inherite`p_can within w_sm04_00010
integer taborder = 120
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
end event

type p_print from w_inherite`p_print within w_sm04_00010
boolean visible = false
integer x = 3122
integer taborder = 150
end type

type p_inq from w_inherite`p_inq within w_sm04_00010
integer x = 3570
integer taborder = 30
end type

event p_inq::clicked;String sDate, scust, sCvcod, sItnbr, sDays, sGate, sGrpNam, sPlnt
Long ix, iplngbn
String sSaupj

sDate = Trim(dw_ip.GetItemString(1, 'order_date'))
sCust = Trim(dw_ip.GetItemString(1, 'cust'))
sCvcod = Trim(dw_ip.GetItemString(1, 'cvcod'))
//sGate = Trim(dw_ip.GetItemString(1, 'gate'))
sGate = Trim(dw_ip.GetItemString(1, 'plnt'))
iPlngbn = dw_ip.GetItemNumber(1, 'plngbn')

If IsNull(sCvcod) Then sCvcod = ''
If IsNull(sGate) Then sGate = ''
If IsNull(sCust) Then sCust = ''

If IsNull(sDate) Or sDate = '' Then
	f_message_chk(1400,'[등록일자]')
	Return
End If

If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

sGrpNam = Trim(dw_ip.GetItemString(1, 'grpnam'))
If IsNull(sGrpNam) Then sGrpNam = ''

//dw_insert.SetFilter("")
//
//// 현대인 경우 1차 벤더 제외
//If sCust = '1' Then
//	dw_insert.SetFilter("sarea = '10'")
//End If
//
//// 1차 벤더인 경우 
//If sCust = '40' Then
//	sCust = '1'
//	dw_insert.SetFilter("sarea <> '10'")
//End If
//
//dw_insert.Filter()

If dw_insert.Retrieve(sSaupj, sDate, scust+'%', iPlngbn, sCvcod+'%', sGrpNam+'%', sGate+'%') <= 0 Then
	f_message_chk(50,'')
	Return
End If

// 일자 셋팅
//dw_insert.Object.t_d0.text = Mid(sdate,5,2)+'.'+Right(sDate,2)
//dw_insert.Object.t_dm0.text = wf_dayname(sdate)

sDays = f_afterday(sdate,1)
dw_insert.Object.t_d1.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm1.text = wf_dayname(sDays)

sDays = f_afterday(sdate,2)
dw_insert.Object.t_d2.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm2.text = wf_dayname(sDays)

sDays = f_afterday(sdate,3)
dw_insert.Object.t_d3.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm3.text = wf_dayname(sDays)

sDays = f_afterday(sdate,4)
dw_insert.Object.t_d4.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm4.text = wf_dayname(sDays)

sDays = f_afterday(sdate,5)
dw_insert.Object.t_d5.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm5.text = wf_dayname(sDays)

sDays = f_afterday(sdate,6)
dw_insert.Object.t_d6.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm6.text = wf_dayname(sDays)

sDays = f_afterday(sdate,7)
dw_insert.Object.t_d7.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm7.text = wf_dayname(sDays)

sDays = f_afterday(sdate,8)
dw_insert.Object.t_d8.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm8.text = wf_dayname(sDays)

sDays = f_afterday(sdate,9)
dw_insert.Object.t_d9.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm9.text = wf_dayname(sDays)

sDays = f_afterday(sdate,10)
dw_insert.Object.t_d10.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm10.text = wf_dayname(sDays)

sDays = f_afterday(sdate,11)
dw_insert.Object.t_d11.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm11.text = wf_dayname(sDays)

sDays = f_afterday(sdate,12)
dw_insert.Object.t_d12.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm12.text = wf_dayname(sDays)

sDays = f_afterday(sdate,13)
dw_insert.Object.t_d13.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm13.text = wf_dayname(sDays)

sDays = f_afterday(sdate,14)
dw_insert.Object.t_d14.text = Mid(sDays,5,2)+'.'+Right(sDays,2)
dw_insert.Object.t_dm14.text = wf_dayname(sDays)
end event

type p_del from w_inherite`p_del within w_sm04_00010
boolean visible = false
integer taborder = 110
end type

type p_mod from w_inherite`p_mod within w_sm04_00010
integer x = 4091
integer taborder = 100
end type

event p_mod::clicked;String sOrderDate, sPlnt, svndstk, sItnbr, sCvcod, sGidate, host_jpno, sHoldNo, sCust
Long ix,iy, nCnt, nUpd=0, host_iono, host_seqno, NROW
Boolean bOk = False, bdOk = False
Dec	 dIqty, dPqty, dOldIQty, dOldPqty, dDqty1, dDqty2, dOldDD1, dOldDD2
String sSaupj

If dw_insert.AcceptText() <> 1 Then Return
If f_msg_update() <> 1 Then Return

// 기준일자
sOrderDate = Trim(dw_ip.GetItemString(1, 'order_date'))

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
	sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
	If IsNull(sCvcod) Or sCvcod = '' Then
		dw_insert.DeleteRow(ix)
		continue
	End If
	If IsNull(sItnbr) Or sItnbr = '' Then
		dw_insert.DeleteRow(ix)
		continue
	End If
Next
	
/* 전표번호 생성 */
host_iono = 0;
host_iono = sqlca.fun_junpyo(gs_sabu, sOrderDate, 'S1')
if host_iono < 1 then
	return -1
end if

commit;

host_jpno 	= sOrderDate +string(host_iono,'0000');
host_seqno	= 0;
	
For ix = 1 To dw_insert.RowCount()
	If dw_insert.GetItemStatus(ix, 0, Primary!) = DataModified! Or dw_insert.GetItemStatus(ix, 0, Primary!) = NewModified!  Then
		sCust = dw_ip.GetItemString(1, 'cust')
		bOk  = False
		bdOk = False
		
		// 3일치에 대한 계획만 수정가능
		For iy = 1 To 3
			dOldIQty = 0
			dOldPqty = 0
			dIqty		= 0
			dPqty		= 0
		
			If dw_insert.GetItemStatus(ix, 'pqty'+string(iy), Primary!) = DataModified! Or dw_insert.GetItemStatus(ix, 'pqty'+string(iy), Primary!) = NewModified! Then
				bOk = True
			End If
			If dw_insert.GetItemStatus(ix, 'iqty'+string(iy), Primary!) = DataModified! Or dw_insert.GetItemStatus(ix, 'iqty'+string(iy), Primary!) = NewModified! Then
				bOk = True
			End If

			
			// D일자의 계획이 변경된 경우
			If iy = 1 Then
				If dw_insert.GetItemStatus(ix, 'ddqty1', Primary!) = DataModified! Or dw_insert.GetItemStatus(ix, 'ddqty1', Primary!) = NewModified! Then
					bdOk = True
				End If
				If dw_insert.GetItemStatus(ix, 'ddqty2', Primary!) = DataModified! Or dw_insert.GetItemStatus(ix, 'ddqty2', Primary!) = NewModified! Then
					bdOk = True
				End If
				
				dDqty1 = dw_insert.GetItemNumber(ix, 'ddqty1')
				dDqty2 = dw_insert.GetItemNumber(ix, 'ddqty2')
			Else
				dDqty1 = 0
				dDqty2 = 0
			End If
			
			// 수정사항이 존재할 경우
			If bOk Or bdOk Then
				nUpd ++
				
				sPlnt		= Trim(dw_insert.GetItemString(ix, 'plnt'))
				svndstk	= Trim(dw_insert.GetItemString(ix, 'vndstk'))
				sItnbr	= Trim(dw_insert.GetItemString(ix, 'itnbr'))
				sCvcod	= Trim(dw_insert.GetItemString(ix, 'cvcod'))
			
				dIqty		= dw_insert.GetItemNumber(ix, 'iqty'+string(iy))
				dPqty		= dw_insert.GetItemNumber(ix, 'pqty'+string(iy))

				// D일자의 계획 = 주간 + 야간
				If iy = 1 Then
					dIqty = dDQty1 + dDqty2
				Else
					dDqty1 = dIqty
					dDqty2 = 0
				End If
				
				// 당일만 수정한경우는 skip
				If iy > 1 And bOk = False Then Continue
				
				// 기준일자
				sGidate = f_afterday(sOrderDate, iy - 1)
				
				SELECT COUNT(*) INTO :nCnt FROM SM04_DAILY_ITEM
				 WHERE SAUPJ = :sSaupj
				   AND YYMMDD = :sGidate
					AND CVCOD = :sCvcod
					AND ITNBR = :sItnbr
					AND PLNT = :sPlnt
					AND VNDSTK = :sVndstk
					AND GUBUN = :sCust;

				// 임의로 등록된 수량외
				SELECT SUM(ITM_QTY1), SUM(PROD_QTY), SUM(ITM_QTY2), SUM(ITM_QTY3)
				  INTO :dOldIQty, :dOldPqty, :dOldDD1, :dOldDD2 
				  FROM SM04_DAILY_ITEM
				 WHERE SAUPJ = :sSaupj
				   AND YYMMDD = :sGidate
					AND CVCOD = :sCvcod
					AND ITNBR = :sItnbr
					AND PLNT = :sPlnt
					AND VNDSTK = :sVndstk
					AND GUBUN = :sCust;
//					AND GUBUN <> '4';

				If IsNull(dOldIQty) Then dOldIQty = 0
				If IsNull(dOldPqty) Then dOldPqty = 0
				If IsNull(dOldDD1) Then dOldDD1 = 0
				If IsNull(dOldDD2) Then dOldDD2 = 0
								
				If nCnt > 0  Then
					UPDATE SM04_DAILY_ITEM
					   SET ITM_QTY1 = :dIqty, 
						    ITM_QTY2 = :dDqty1,
							 ITM_QTY3 = :dDqty2
//						    PROD_QTY = :dPqty
					 WHERE SAUPJ = :sSaupj
						AND YYMMDD = :sGidate
						AND CVCOD = :sCvcod
						AND ITNBR = :sItnbr
						AND PLNT = :sPlnt
						AND VNDSTK = :sVndstk
						AND GUBUN = :sCust;
				Else
					host_seqno += 1
					sHoldNo = host_jpno + String(host_seqno,'000')
					INSERT INTO SM04_DAILY_ITEM
							  ( SAUPJ,    YYMMDD,   GUBUN,    CVCOD,    ITNBR,    
							    ITM_PRC, 
								 ITM_QTY1, ITM_QTY2, ITM_QTY3,  ITM_QTY4, ITM_QTY5, ITM_QTY6, ITM_QTY7, 
								 CNFIRM,   VNDSTK,   JPROD_QTY, ORDER_NO, PROD_QTY, PLNT,
								 OUT_CHK,  ISQTY,    HOLD_NO)
					 VALUES ( :sSaupj, :sGidate, :sCust, 		:sCvcod,   :sItnbr,
					          fun_erp100000012_1(to_char(sysdate,'yyyymmdd'), :sCvcod, :sItnbr, '1') ,
					          :dIqty,   :dDqty1,   :dDqty2,         0,        0,        0,        0,
								 'N',      :sVndstk, 0,         NULL,     :dPqty,   :sPlnt,
								 '1',	     0,        :sHoldNo);
				End If
				If SQLCA.SQLCODE <> 0 Then
					MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
					RollBack;
					Return
				End If
			End If
		Next
	End If
Next

If nUpd > 0 Then
	COMMIT;
	
	MessageBox('확인', '저장하였습니다.!!')
	
	p_inq.TriggerEvent(Clicked!)
End If

ib_any_typing = FALSE
end event

type cb_exit from w_inherite`cb_exit within w_sm04_00010
end type

type cb_mod from w_inherite`cb_mod within w_sm04_00010
end type

type cb_ins from w_inherite`cb_ins within w_sm04_00010
end type

type cb_del from w_inherite`cb_del within w_sm04_00010
end type

type cb_inq from w_inherite`cb_inq within w_sm04_00010
end type

type cb_print from w_inherite`cb_print within w_sm04_00010
end type

type st_1 from w_inherite`st_1 within w_sm04_00010
end type

type cb_can from w_inherite`cb_can within w_sm04_00010
end type

type cb_search from w_inherite`cb_search within w_sm04_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_sm04_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_sm04_00010
end type

type dw_ip from u_key_enter within w_sm04_00010
integer x = 69
integer y = 56
integer width = 3191
integer height = 188
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sm04_00010_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sDate, s_cvcod, get_nm, snull, sGrpNam

SetNull(sNull)

Choose Case GetColumnName()
	Case 'order_date'
		sDate = Trim(GetText())
		If f_datechk(sDate) <> 1 Then
			MessageBox('확 인','일자를 확인하세요.!!')
			Return 2
		End If
	Case 'cust'
		sDate = Trim(GetText())
		
		idw_plnt.SetFilter("rfna3 = '" + sDate +"'")
		idw_plnt.Filter()
		SetItem(1, 'plnt', idw_plnt.GetItemSTring(1, 'rfgub'))
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case 'gbn'
		If GetText() = '1' Then // 납품장소별
			If GetItemString(1, 'cust') = '1' Then
				dw_insert.SetSort('plnt , itnbr ')
			Else
				dw_insert.SetSort('cvcod , itnbr ')
			End If
		Else
			dw_insert.SetSort('itnbr')
		End If
		dw_insert.Sort()
	Case 'grpnam'
		sGrpNam = Trim(GetText())
		
		SetItem(1, 'gate', sNull)
		
		// 공정조회
		datawindowchild dwc
		getchild("gate", dwc)
		dwc.settransobject(sqlca)
		
		If IsNull(sGrpnam) Or sGrpnam = '' Then
			dwc.SetFilter("")
		Else
			dwc.SetFilter("grpnam = '" + sGrpnam + "'")
		End If
		dwc.Filter()
		dwc.Retrieve()
//		dw_insert.settransobject(sqlca)
//		dwc.insertrow(0)
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;
Choose Case GetColumnName()
	Case 'cvcod'
		gs_code = GetText()
		gs_gubun = GetItemString(1, 'cust')		// 고객구분 
		
		Open(w_agent_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(1, "cvcod", gs_Code)
		this.SetItem(1, "cvnas", gs_Codename)
End Choose
end event

type rb_1 from radiobutton within w_sm04_00010
boolean visible = false
integer x = 1883
integer y = 104
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "발주자료"
boolean checked = true
end type

event clicked;dw_insert.DataObject = 'd_hkcd6'
dw_insert.SetTransObject(sqlca)
end event

type rb_2 from radiobutton within w_sm04_00010
boolean visible = false
integer x = 2281
integer y = 100
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "긴급발주"
end type

event clicked;dw_insert.DataObject = 'd_gingub'
dw_insert.SetTransObject(sqlca)
end event

type dw_update from datawindow within w_sm04_00010
boolean visible = false
integer x = 2743
integer y = 36
integer width = 306
integer height = 216
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_hkcp5"
boolean border = false
boolean livescroll = true
end type

type dw_reffpf from datawindow within w_sm04_00010
boolean visible = false
integer x = 2546
integer y = 100
integer width = 411
integer height = 104
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dd_reffpf_5b"
boolean border = false
boolean livescroll = true
end type

type dw_jego from datawindow within w_sm04_00010
boolean visible = false
integer x = 73
integer y = 2348
integer width = 1307
integer height = 164
integer taborder = 170
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm04_00010_4"
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_sm04_00010
integer x = 731
integer y = 60
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('order_date')
IF IsNull(gs_code) THEN Return 
dw_ip.SetItem(1, 'order_date', gs_code)

end event

type cb_1 from commandbutton within w_sm04_00010
integer x = 4160
integer y = 180
integer width = 402
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "정렬"
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

type rr_1 from roundrectangle within w_sm04_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 36
integer width = 3246
integer height = 220
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sm04_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 272
integer width = 4544
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 46
end type

