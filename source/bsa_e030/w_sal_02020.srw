$PBExportHeader$w_sal_02020.srw
$PBExportComments$수주승인 처리
forward
global type w_sal_02020 from w_inherite
end type
type gb_2 from groupbox within w_sal_02020
end type
type gb_5 from groupbox within w_sal_02020
end type
type gb_4 from groupbox within w_sal_02020
end type
type rb_1 from radiobutton within w_sal_02020
end type
type rb_2 from radiobutton within w_sal_02020
end type
type cbx_1 from checkbox within w_sal_02020
end type
type cbx_2 from checkbox within w_sal_02020
end type
type cbx_3 from checkbox within w_sal_02020
end type
type dw_cust_lst from u_d_popup_sort within w_sal_02020
end type
type dw_ip from datawindow within w_sal_02020
end type
type st_msg from statictext within w_sal_02020
end type
type cbx_4 from checkbox within w_sal_02020
end type
type p_1 from uo_picture within w_sal_02020
end type
type p_2 from uo_picture within w_sal_02020
end type
type p_3 from uo_picture within w_sal_02020
end type
type pb_1 from u_pb_cal within w_sal_02020
end type
type pb_2 from u_pb_cal within w_sal_02020
end type
type rr_1 from roundrectangle within w_sal_02020
end type
type rr_2 from roundrectangle within w_sal_02020
end type
type rr_3 from roundrectangle within w_sal_02020
end type
end forward

global type w_sal_02020 from w_inherite
integer height = 3772
string title = "수주 승인 처리"
gb_2 gb_2
gb_5 gb_5
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
dw_cust_lst dw_cust_lst
dw_ip dw_ip
st_msg st_msg
cbx_4 cbx_4
p_1 p_1
p_2 p_2
p_3 p_3
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_02020 w_sal_02020

type variables


/* Multi Select */
boolean ib_down
long  il_sRow = 1
end variables

forward prototypes
public function string wf_orderlimitamount_check ()
public function string wf_getsqlsyntax ()
public function double wf_get_valid_cancel_qty (integer nrow)
public function integer wf_suju_sts (integer nrow)
public function integer wf_calc_danga (integer nrow)
public function integer wf_retrieve_detail (string scust, string sdate, string edate)
public subroutine wf_autohaldang ()
end prototypes

public function string wf_orderlimitamount_check ();String  sSyscnfg_Flag,sOrderFlag,sSyscnfg_Yusin

SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)  					/*여신체크 시점*/
	INTO :sSyscnfg_Yusin
   FROM "SYSCNFG"  
   WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 2) AND ("SYSCNFG"."LINENO" = '10' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	sSyscnfg_Yusin ='0'
ELSE
	IF sSyscnfg_Yusin = "" OR IsNull(sSyscnfg_Yusin) THEN sSyscnfg_Yusin = '0'
END IF

SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)  					/*수주승인 자동여부*/
	INTO :sSyscnfg_Flag  
   FROM "SYSCNFG"  
   WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 1) AND ("SYSCNFG"."LINENO" = '10' )   ;

IF SQLCA.SQLCODE <> 0 THEN
	sOrderFlag = 'N'
ELSE
	IF sSyscnfg_Flag = "" OR IsNull(sSyscnfg_Flag) THEN sOrderFlag = 'N'
END IF

IF sSyscnfg_Flag = 'Y' AND sSyscnfg_Yusin = '1' THEN			/*여신체크시점 '수주승인'이면*/
	sOrderFlag = '2'
ELSE
	sOrderFlag = '1'
END IF

Return sOrderFlag
end function

public function string wf_getsqlsyntax ();Int    row=0, nRow, nCnt=0
String sGetSqlSyntax,sSuJuOrderNo,sSuJuSts = '2'
Long   lSyntaxLength

sGetSqlSyntax = 'and (sorder.suju_sts = '+ "'"+sSuJuSts+"'"+" ) and "
	
sGetSqlSyntax = sGetSqlSyntax + '('

If dw_insert.AcceptText() <> 1 Then Return ''

/* 변경된 사항중 승인된 건만 할당 처리 */
nRow = dw_insert.RowCount()
DO WHILE row <= nRow
	row = dw_insert.GetNextModified(row, Primary!)
	IF row > 0 THEN
		If dw_insert.GetItemString(row,'suju_sts') <> '2' Then Continue
		
		sSuJuOrderNo = dw_insert.GetItemString(row,'order_no')
		sGetSqlSyntax = sGetSqlSyntax + ' (sorder.order_no =' + "'"+ sSuJuOrderNo +"')"+ ' OR'
		nCnt += 1
	ELSE
		row = nRow + 1
		Exit
	END IF
LOOP

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)
	
sGetSqlSyntax = sGetSqlSyntax + ")"

If nCnt <=0 Then 	Return ''

Return sGetSqlSyntax
end function

public function double wf_get_valid_cancel_qty (integer nrow);Double dOrderQty, dHoldQty, dJisiQty, dProdQty, dOrderPrc, dCanCelQty

/* 수주상태 확인 */
If nRow <=0  Or dw_insert.RowCount() < nRow Then Return 0

/* 분할일 경우 취소가능한 수량을 리턴하고 기타는 0을 리턴 */
dCanCelQty = 0

Choose Case dw_insert.GetItemString(nRow,'suju_sts')
  Case '5'
    dOrderQty = dw_insert.GetItemNumber(nRow,"order_qty")	/*수주수량 합*/
    IF IsNull(dOrderQty) THEN dOrderQty =0
	  
    dHoldQty = dw_insert.GetItemNumber(nRow,"hold_qty")		/*할당수량 합*/
    IF IsNull(dHoldQty) THEN dHoldQty =0
	
    dJisiQty = dw_insert.GetItemNumber(nRow,"jisi_qty")		/*생산지시수량 합*/
    IF IsNull(dJisiQty) THEN dJisiQty =0
	
    dProdQty = dw_insert.GetItemNumber(nRow,"prod_qty")		/*생산입고수량 합*/
    IF IsNull(dProdQty) THEN dProdQty =0

	 dCanCelQty = dOrderQty - dHoldQty -  dJisiQty + dProdQty
End Choose

/* 취소수량 반영 = 수주수량 - 취소 가능수량*/
If dCanCelQty > 0 Then
	dw_insert.SetItem(nRow,'order_qty',dOrderQty - dCanCelQty)
		
	dOrderPrc = dw_insert.GetItemNumber(nRow,"order_prc")	/* 수주단가 */
	IF IsNull(dOrderPrc) THEN dOrderPrc =0
	dw_insert.SetItem(nRow,'order_amt',TrunCate((dOrderQty - dCanCelQty)*dOrderPrc,0))
Else
	MessageBox('확 인','취소가능한 수량이 없습니다')
End If

Return dCanCelQty
end function

public function integer wf_suju_sts (integer nrow);Double dOrderQty, dHoldQty, dJisiQty, dProdQty
String sAgrDat, sToday

/* 수주상태 확인 */
If nRow <=0  Or dw_insert.RowCount() < nRow Then Return -1

sToDay = f_today()

Choose Case dw_insert.GetItemString(nRow,'suju_sts')
  Case '3'              // 보류
	 return -2
  Case '4','8','9'      // 취소,완료,마감 => 삭제불가,수정불가
	 return -1
  Case Else
    dOrderQty = dw_insert.GetItemNumber(nRow,"order_qty")	/*수주수량 합*/
    IF IsNull(dOrderQty) THEN dOrderQty =0
		
    dHoldQty = dw_insert.GetItemNumber(nRow,"hold_qty")		/*할당수량 합*/
    IF IsNull(dHoldQty) THEN dHoldQty =0
	
    dJisiQty = dw_insert.GetItemNumber(nRow,"jisi_qty")		/*생산지시수량 합*/
    IF IsNull(dJisiQty) THEN dJisiQty =0
	
    dProdQty = dw_insert.GetItemNumber(nRow,"prod_qty")		/*생산입고수량 합*/
    IF IsNull(dProdQty) THEN dProdQty =0
		
    sAgrDat = Trim(dw_insert.GetItemString(nRow,"agrdat"))	/* 생산승인일자 */
    IF IsNull(sAgrDat) Then  sAgrDat = ''

	IF dHoldQty <> 0 Then 
		f_message_chk(57,'[할당중인 자료입니다]')
		Return Abs(dHoldQty + dJisiQty - dProdQty)
	ElseIf (dHoldQty + dJisiQty - dProdQty) <> 0 THEN
		f_message_chk(57,'[생산지시중인 자료입니다]')
		Return Abs(dJisiQty - dProdQty)
//	ElseIf  dJisiQty = 0 and dProdQty = 0 and sAgrDat <> '' and sAgrDat < sToDay Then
	ElseIf  dJisiQty = 0 and dProdQty = 0 and sAgrDat > '0' Then
		f_message_chk(57,'[생산승인된 자료입니다]')
		Return dOrderQty
	Else
		Return 0    /* 미진행(승인) */
	End If
End Choose

Return 0
end function

public function integer wf_calc_danga (integer nrow);///* 판매단가및 할인율 */
///* --------------------------------------------------- */
///* 가격구분 : 2000.05.16('0' 추가됨)                   */
///* 0 - 수량별 할인율 등록 단가              		       */ 
///* 1 - 특별출하 거래처 등록 단가                       */ 
///* 2 - 이벤트 할인율 등록 단가                    	    */ 
///* 3 - 거래처별 제품단가 등록 단가                     */ 
///* 4 - 거래처별 할인율 등록 단가                       */ 
///* 5 - 품목마스타 등록 단가                  		    */ 
///* 9 - 미등록 단가                         		       */ 
///* --------------------------------------------------- */
//string sOrderDate, sCvcod, sItnbr, sOrderSpec
//int    iRtnValue = -1
//double ditemprice,ddcrate,dItemqty
//
//sOrderDate = dw_insert.GetItemString(nRow, "order_date")
//sCvcod 	  = dw_insert.GetItemString(nRow, "cvcod")
//sItnbr	  = dw_insert.GetItemString(nRow, "itnbr")
//sOrderSpec = dw_insert.GetItemString(nRow, "order_spec")
//
///* 수량 */
//dItemQty   = dw_insert.GetItemNumber(nRow,"order_qty")
//IF IsNull(dItemQty) THEN dItemQty =0
//
///* 수량이 0이상일 경우 수량base단가를 구한다 */
//If dItemQty > 0 Then
//	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, sItnbr, dItemQty, &
//                                    'WON', dItemPrice, dDcRate) 
//End If
//
///* 수량base단가가 없을경우 판매단가를 구한다 */
//If iRtnValue < 0 Then
//	iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sOrderDate, sCvcod, sItnbr, sOrderSpec, &
//													'WON','1', dItemPrice, dDcRate) 
//End If
//
//If IsNull(dItemPrice) Then dItemPrice = 0
//If IsNull(dDcRate) Then dDcRate = 0
//
///* 단가 : 절사한다 */
//dItemPrice = TrunCate(dItemPrice,0)
//
//Choose Case iRtnValue
//	Case IS < 0 
//		f_message_chk(41,'[단가 계산]'+string(irtnvalue))
//		Return 1
//	Case Else
//		dw_insert.SetItem(nRow,"dc_rate",	dDcRate)
//		dw_insert.SetItem(nRow,"order_prc",	dItemPrice)
//		
//		/* 거래처 할인율, 정책할인율, 품목마스타 단가 */
//		If iRtnValue = 3 or iRtnValue = 4 or iRtnValue = 5 Then
//			dw_insert.SetItem(nRow,"special_yn",'N')
//		Else
//			dw_insert.SetItem(nRow,"special_yn",'Y')   /* 특출 */	
//		End If
//		
//		dw_insert.SetItem(nRow,"pricegbn",String(irtnvalue))
//		
//		/* 금액 계산 */	
//		dw_insert.SetItem(nRow,"order_amt",TrunCate(dItemQty * dItemPrice,0))
//End Choose
//
Return 0
end function

public function integer wf_retrieve_detail (string scust, string sdate, string edate);String sSuJuSts,sSqlSynTax

sle_msg.text = ''
dw_insert.SetRedraw(False)

sSqlSyntax = 'SELECT "SORDER"."SABU",'+&  
				 ' 		"SORDER"."ORDER_NO",'+&
				 ' 		"SORDER"."ORDER_DATE",'+&   
				 ' 		"SORDER"."CVCOD",'+&  
				 '			fun_get_cvnas("SORDER"."CUST_NO") as cust_no,'+&
				 '			"SORDER"."OUT_GU",'+& 
				 '			"SORDER"."OVERSEA_GU",'+& 
				 '			"SORDER"."ITNBR",'+& 
				 '			"SORDER"."ORDER_QTY" as order_qty,'+&  
				 '			"SORDER"."ORDER_PRC",'+&  
				 '			"SORDER"."ORDER_AMT" as order_amt,'+&   
				 '			"SORDER"."DC_RATE",'+& 
				 '			"SORDER"."SUJU_STS",'+&
				 '			"SORDER"."HOLD_QTY",'+&  
				 '			"SORDER"."HOLD_DATE",'+& 
				 '			"SORDER"."PUR_REQ_NO",'+&  
				 '			"SORDER"."CRT_DATE",'+& 
				 '			"SORDER"."CRT_TIME",'+&
				 '			"SORDER"."CRT_USER",'+& 
				 '			"SORDER"."UPD_DATE",'+& 
				 '			"SORDER"."UPD_TIME",'+& 
				 '			"SORDER"."UPD_USER",'+& 
				 '			"ITEMAS"."ITDSC",'+&
				 '			"ITEMAS"."ISPEC",'+&
				 '			"ITEMAS"."JIJIL",'+&
				 '			"ITEMAS"."ISPEC_CODE",'+&
				 '			"SORDER"."ORDER_SPEC",'+&
				 '			"SORDER"."ORD_OK_DATE",'+&
				 '			"SORDER"."ORDER_MEMO",'+&
				 '      "SORDER"."JISI_QTY",  '+&
				 '      "SORDER"."PROD_QTY", '+&
				 '      "SORDER"."AGRDAT", '+&
				 '      "SORDER"."EMP_ID", '+&
				 '      "SORDER"."ORD_CANCEL_CAUSE", '+&
				 '      "SORDER"."SPECIAL_YN", '+&
				 '      "SORDER"."PRICEGBN" '+&
				 '	 FROM "SORDER","ITEMAS"'+&
				 '	WHERE ( "SORDER"."SABU" = "ITEMAS"."SABU" ) AND ( "SORDER"."ITNBR" = "ITEMAS"."ITNBR" ) ' 

sSqlSyntax = sSqlSyntax + "and (sorder.sabu ='"+gs_sabu+"') and (sorder.cvcod = '"+sCust+"')"
sSqlSyntax = sSqlSyntax + "and (sorder.oversea_gu in ( '1','3')) and (sorder.order_date >= '" + sdate+"') and (sorder.order_date <= '" +edate+"')"

IF cbx_1.Checked = True OR cbx_2.Checked = True OR cbx_3.Checked = True OR cbx_4.Checked = True THEN
	sSqlSyntax = sSqlSynTax + 'and ('
	
	IF cbx_1.Checked = True THEN
		sSuJuSts = '1'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts = '"+sSuJuSts+"') OR"
	END IF
	
	IF cbx_2.Checked = True THEN
		sSuJuSts = '2'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts = '"+sSuJuSts+"') OR"
	END IF
	
	IF cbx_3.Checked = True THEN
		sSuJuSts = '3'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts = '"+sSuJuSts+"') OR"
	END IF

	IF cbx_4.Checked = True THEN
		sSuJuSts = '5'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts = '"+sSuJuSts+"')"
	END IF
	
	IF Right(sSqlSyntax,2) = 'OR' THEN
		sSqlSyntax = Left(sSqlSyntax,Len(sSqlSyntax) - 2)
	END IF
	
	sSqlSyntax = sSqlSyntax + ")"
ELSE
	sSqlSyntax = sSqlSynTax + 'and ('
	
	IF cbx_1.Checked = False THEN
		sSuJuSts = '1'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts <> '"+sSuJuSts+"') AND"
	END IF
	
	IF cbx_2.Checked = False THEN
		sSuJuSts = '2'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts <> '"+sSuJuSts+"') AND"
	END IF
	
	IF cbx_3.Checked = False THEN
		sSuJuSts = '3'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts <> '"+sSuJuSts+"') AND"
	END IF

	IF cbx_4.Checked = False THEN
		sSuJuSts = '5'
		sSqlSyntax = sSqlSyntax + "(sorder.suju_sts <> '"+sSuJuSts+"') "
	END IF
	
	IF Right(sSqlSyntax,3) = 'AND' THEN
		sSqlSyntax = Left(sSqlSyntax,Len(sSqlSyntax) - 3)
	END IF
	
	sSqlSyntax = sSqlSyntax + ")"
END IF

//MESSAGEBOX('', sSqlSyntax)

dw_insert.SetSQLSelect(sSqlSyntax)

dw_insert.SetTransObject(SQLCA)
dw_insert.Modify( "DataWindow.Table.UpdateTable = ~"SORDER~"")

If dw_insert.Retrieve() > 0 Then 
	dw_insert.SetFocus()
	dw_insert.ScrollToRow(1)
	dw_insert.SelectRow(1,true)
End If
dw_insert.SetFilter(' remain_qty <>0')
dw_insert.Filter()
dw_insert.SetRedraw(True)

Return 1

end function

public subroutine wf_autohaldang ();String  sSyscnfg_Flag,sSqlSyntax, sOutGu, sOrderNo, sHoldNo, sCvcod, sempid, sIoJpno
Integer iRtnValue, nRow, row

/*할당자동여부*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1) 
  INTO :sSyscnfg_Flag  
  FROM "SYSCNFG"  
 WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 1) AND ("SYSCNFG"."LINENO" = '20' );
 
IF SQLCA.SQLCODE <> 0 THEN
	sSyscnfg_Flag = 'N'
ELSE
	IF sSyscnfg_Flag = "" OR IsNull(sSyscnfg_Flag) THEN sSyscnfg_Flag = 'N'
END IF

IF sSyscnfg_Flag = 'Y' THEN
	sSqlSynTax = Wf_GetSqlSyntax()
	If Trim(sSqlSynTax) = '' Or IsNull(sSqlSynTax) Then Return
	
	iRtnValue = sqlca.fun_erp100000040(gs_sabu,'%',is_today,sSqlSyntax)
	If sqlca.sqlcode <> 0 Then
		MessageBox(sqlca.sqlerrtext,'[자동할당을 실패하였습니다]')
		RollBack;
		Return 
	End If
	
	IF iRtnValue = -1 THEN
		f_message_chk(39,'')
		ROLLBACK;
		Return
	ELSEIF iRtnValue = -2 THEN
		f_message_chk(41,'[할당]')
		Return
	ELSEIF iRtnValue = 0 THEN        /* 할당된 건수가 없을 경우 */
		Return		
	END IF
Else
	Return
END IF

/* -----------------------------------------*/
/* 송장 발행                                */
/* -----------------------------------------*/
sOutGu = 'O02'

/* 송장자동 발행 여부 */
select autinv into :sSyscnfg_Flag 
  from iomatrix 
 where iogbn = 'O02';

If sSyscnfg_Flag <> 'Y' Then Return

IF MessageBox("확 인","출고송장을 발행하시겠습니까?",Question!,YesNo!) = 2 THEN Return

/* 변경된 사항중 할당된 건만 송장 발행 */
nRow = dw_insert.RowCount()
DO WHILE row <= nRow
	row = dw_insert.GetNextModified(row, Primary!)
	IF row > 0 THEN
		If dw_insert.GetItemString(row,'suju_sts') <> '2' Then Continue
		
		sOrderNo = Trim(dw_insert.GetItemString(row,'order_no'))
	
		/* 할당번호 선택 */
		SELECT DISTINCT SUBSTR(HOLD_NO,1,12) INTO :sHoldNo
		  FROM HOLDSTOCK
		 WHERE ORDER_NO = :sOrderNo AND
				 OUT_CHK = '1';
			
		If IsNull(sHoldNo) Or sHoldNo = '' Then	Continue
		
		/* 송장 발행 */
		sCvcod = Trim(dw_insert.GetItemString(1,'cvcod')) // 의뢰부서 
		sEmpId = Trim(dw_insert.GetItemString(1,'emp_id')) // 의뢰담당자
		sIojpno = sqlca.fun_erp100000070(gs_sabu, sHoldNo, is_today, sOutGu, sCvcod, sEmpId)
		
		If sqlca.sqlcode <> 0 Then
			RollBack;
			MessageBox("Compile Error","Procedure[fun_erp100000070] invalid~r~n~r~n전산실로 연락하세요")
			Return 
		End If
			
		If IsNull(sIojpno) or Trim(sIoJpNo) = '' Then
			RollBack;
			f_message_chk(41,'[송장발행]')
			Return
		END IF
		
		/* 여러수주 -> 할당 1건 -> 송장 1건으로 발행되므로 한번만 처리해준다 */
		Exit
	ELSE
		row = nRow + 1
		Exit
	END IF
LOOP

MessageBox('확 인','송장출고 완료되었습니다.!!')

COMMIT;
end subroutine

on w_sal_02020.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.dw_cust_lst=create dw_cust_lst
this.dw_ip=create dw_ip
this.st_msg=create st_msg
this.cbx_4=create cbx_4
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.gb_4
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cbx_2
this.Control[iCurrent+8]=this.cbx_3
this.Control[iCurrent+9]=this.dw_cust_lst
this.Control[iCurrent+10]=this.dw_ip
this.Control[iCurrent+11]=this.st_msg
this.Control[iCurrent+12]=this.cbx_4
this.Control[iCurrent+13]=this.p_1
this.Control[iCurrent+14]=this.p_2
this.Control[iCurrent+15]=this.p_3
this.Control[iCurrent+16]=this.pb_1
this.Control[iCurrent+17]=this.pb_2
this.Control[iCurrent+18]=this.rr_1
this.Control[iCurrent+19]=this.rr_2
this.Control[iCurrent+20]=this.rr_3
end on

on w_sal_02020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.dw_cust_lst)
destroy(this.dw_ip)
destroy(this.st_msg)
destroy(this.cbx_4)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;dw_cust_lst.SetTransObject(SQLCA)
dw_cust_lst.Reset()

dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Modify("sarea.DDDW.AllowEdit=Yes")

dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',f_today())

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("sarea.protect=1")
	//dw_ip.Modify("sarea.background.color = 80859087")
End If
dw_ip.SetItem(1, 'sarea', sarea)

rb_2.Checked = True

// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')
end event

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_sal_02020
event ue_lbuttondown pbm_lbuttondown
event ue_mousemove pbm_dwnmousemove
integer x = 41
integer y = 952
integer width = 4549
integer height = 1356
integer taborder = 30
string dataobject = "d_sal_020203"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_lbuttondown;/* -------------------------------------------------------- */
/* Clicked된 row,column 가져오기                            */
/* -------------------------------------------------------- */
string  ls_col,ls_colnm
int	  row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	li_pos = Pos (ls_col, '~t')

	if li_pos > 0 then
		row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If row <= 0 Then Return
End if


If ls_colnm = 'suju_sts' Then
	this.object.suju_sts.TabSequence = 10
Else
	this.object.suju_sts.TabSequence = 0
end If

end event

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;String  sSuJuStsOld,sSuJuStsNew,snull
Double  dValidQty
Integer nRow

SetNull(sNull)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return 

sSuJuStsOld = GetItemString(nRow,"suju_sts")

IF GetColumnName() ="suju_sts" THEN
	sSuJuStsNew = GetText()
	
	/* 분할일 경우 취소처리만 가능하고 사유입력 */
	If sSuJuStsOld = '5' Then
		If sSuJuStsNew <> '4' Then Return 2
		
		gs_gubun = sSuJuStsNew
		Open(w_sal_02020_2)
		IF Message.StringParm <> 'cancel' THEN
			dValidQty = wf_get_valid_cancel_qty(nRow)
			If dValidQty <= 0 Then Return 2
			
			Setitem(nRow,"ord_cancel_cause", gs_code)
			Filter()
		Else
			Return 2
		END IF
	Else
		Choose Case sSuJuStsNew 
			/* 진행중인 자료는 접수로 수정불가 */
			Case '1'
				If  wf_suju_sts(nRow) > 0 Then        Return 2
				
				Setitem(nRow,"ord_cancel_cause", sNull)
				SetItem(nRow,"ord_ok_date",sNull)
			/* 수주 상태 = 승인 */
			Case '2'
				Setitem(nRow,"ord_cancel_cause", sNull)
				SetItem(nRow,"ord_ok_date",GetItemString(nRow,"order_date"))
			/* 보류,취소 */
			Case '3','4'
				/* 진행중인 자료는 취소로 수정불가 */
				If  wf_suju_sts(nRow) > 0 Then        Return 2
				
				gs_gubun = sSuJuStsNew
				Open(w_sal_02020_2)
				IF Message.StringParm <> 'cancel' THEN
					Setitem(nRow,"ord_cancel_cause", gs_code)
				Else
					Return 2
				END IF
			/* 임의로 분할상태 이동 불가 */
			Case '5'
				Return 2
		END Choose
	End If
END IF

w_mdi_frame.sle_msg.Text = '변경된 사항이 있습니다. 저장하십시요.'

ib_any_typing = true
end event

event dw_insert::rowfocuschanged;/* -------------------------------------------------------- */
/* Multi Select                                             */
/* -------------------------------------------------------- */
int crow,fr_row,to_row,ix
int row ,nLastRow

row = currentrow

If row <=0 Then Return

If keydown(KeyControl!) Then
	If Keydown(KeyUpArrow!) Or Keydown(KeyDownArrow!) Then This.SelectRow(0,false)
		
	If IsSelected(row) Then
	  This.SelectRow(row,false)
   Else
	  This.SelectRow(row,True)
   end If
ElseIf keydown(keyShift!) Then
	This.SelectRow(0,false)
   If il_sRow < row Then
		fr_row  = il_sRow
		to_row  = row
	Else
		fr_row = row
		to_row = il_sRow
	End If

	For ix = fr_row To to_row
		This.SelectRow(ix,true)
	Next
//ElseIf Keydown(KeyLeftButton! ) Then
//   nLastRow = Long(This.Object.DataWindow.LastRowOnPage)
//   this.SelectRow(row,true)
//	If nLastRow = ( row - 1 ) Then
//	  Post ScrollToRow( nLastRow + 1)
//   End If	
Else
	This.SelectRow(0,false)
	This.SelectRow(row,true)
//	This.ScrollToRow(row)
	il_sRow = row
End If
/* -------------------------------------------------------- */
end event

event dw_insert::rbuttondown;Long   ix,nCnt, nRtn
string sRtn, sSujuSts, sOrderDate,sNull, sOrdCancelCause
Double dValidQty

SetNull(sNull)

Open(w_sal_02020_3)
sSujuSts = Message.StringParm

If sSujuSts = '0' Then Return
If IsNull(gs_gubun) or gs_gubun = '' Then Return

sSujuSts        = gs_gubun     /* 수주상태 */
sOrdCancelCause = gs_code      /* 수주취소사유 코드 */

/* 선택된 row만 처리 */

For ix = 1 To RowCount()
	If IsSelected(ix) and GetItemString(ix,'suju_sts') <> sSujuSts Then
	
		/* 수주상태가 분할일 경우 취소처리만 가능 */
		If GetItemString(ix,'suju_sts') = '5' Then
			If sSujuSts <> '4' Then Continue
			
			dValidQty = wf_get_valid_cancel_qty(ix)
			If dValidQty <= 0 Then continue
			
			Setitem(ix,"ord_cancel_cause",sOrdCancelCause)
		Else
			/* 진행중인 자료는 수정불가 */
			nRtn = wf_suju_sts(ix)
			If  nRtn > 0 Then    continue
			
			SetItem(ix,"suju_sts",sSujuSts)
			sOrderDate = GetItemString(ix,"order_date")
			Choose Case sSujuSts
				Case '1'
					SetItem(ix,"ord_ok_date",sNull)
				Case '2'
					SetItem(ix,"ord_ok_date",sOrderDate)
				Case '3', '4'
					Setitem(ix,"ord_cancel_cause",sOrdCancelCause)
				Case Else
					Continue
			End Choose
		End If		
		
		SelectRow(ix,False)
		nCnt += 1
	End If
Next

/* 취소된 수주를 화면에서 안보이도록 */
Filter()

If nCnt > 0 Then
	w_mdi_frame.sle_msg.Text = '자료가 처리되었습니다. 저장버튼을 누르세요.'
	ib_any_typing = True
Else
	w_mdi_frame.sle_msg.Text = '변경된 사항이 없습니다.'
End If

end event

event dw_insert::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

type p_delrow from w_inherite`p_delrow within w_sal_02020
boolean visible = false
integer x = 3863
integer y = 2788
end type

type p_addrow from w_inherite`p_addrow within w_sal_02020
boolean visible = false
integer x = 3689
integer y = 2788
end type

type p_search from w_inherite`p_search within w_sal_02020
boolean visible = false
integer x = 2994
integer y = 2788
end type

type p_ins from w_inherite`p_ins within w_sal_02020
boolean visible = false
integer x = 3515
integer y = 2788
end type

type p_exit from w_inherite`p_exit within w_sal_02020
end type

type p_can from w_inherite`p_can within w_sal_02020
end type

event p_can::clicked;call super::clicked;dw_ip.SetFocus()

dw_cust_lst.Reset()
dw_insert.Reset()

cbx_1.Checked = True
cbx_2.Checked = True
cbx_3.Checked = True
ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''

// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

end event

type p_print from w_inherite`p_print within w_sal_02020
boolean visible = false
integer x = 3168
integer y = 2788
end type

type p_inq from w_inherite`p_inq within w_sal_02020
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String sArea,sOut_gu , ls_sdate ,ls_edate , ls_cvcod , ls_saupj

If dw_ip.AcceptText() <> 1 Then Return 

sArea 		= Trim(dw_ip.GetItemString(1,'sarea'))
sOut_gu 	= Trim(dw_ip.GetItemString(1,'out_gu'))
ls_sdate 	= Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate 	= Trim(dw_ip.getitemstring(1,'edate'))
ls_cvcod 	= Trim(dw_ip.getitemstring(1,'cvcod'))
ls_saupj	= dw_ip.getitemstring(1,'saupj')

IF IsNull(sArea) THEN	sArea = ''
IF IsNull(sOut_gu) THEN	sOut_gu = ''
if ls_sdate = "" or isnull(ls_sdate) then ls_sdate = '10000101'
if ls_edate = "" or isnull(ls_edate) then ls_edate = '30000101'
if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'

IF dw_cust_lst.Retrieve(gs_sabu, ls_saupj, is_today, sArea+'%', sOut_gu+'%',ls_sdate ,ls_edate,ls_cvcod) > 0 THEN
	dw_cust_lst.SelectRow(0,False)
	dw_cust_lst.SelectRow(1,True)
	dw_cust_lst.ScrollToRow(1)
	
	Wf_Retrieve_Detail(dw_cust_lst.GetItemString(1,"cust"),ls_sdate,ls_edate)		
ELSE
	f_message_chk(50,'')
	dw_insert.Reset()
END IF

end event

type p_del from w_inherite`p_del within w_sal_02020
boolean visible = false
integer x = 4210
integer y = 2788
end type

type p_mod from w_inherite`p_mod within w_sal_02020
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Integer k,nCnt,nRow
String  sCvcod,sArea,sOut_gu ,ls_sdate ,ls_edate, ls_cvcod, ls_saupj

IF dw_insert.Accepttext() = -1 THEN 	RETURN

ls_saupj	= dw_ip.getitemstring(1,'saupj')

ncnt = dw_insert.RowCount()

If dw_insert.ModifiedCount() <= 0 Then
	w_mdi_frame.sle_msg.text = '변경된 사항이 없습니다.'
	Return
End If

IF f_msg_update() = -1 THEN RETURN

IF dw_insert.Update(True,False) > 0 THEN			
	COMMIT;
	ib_any_typing =False

	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"

ELSE
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

dw_insert.SetRedraw(False)

/* 할당 처리 */
Wf_AutoHalDang()

/* 할당처리후 Update 속성을 Clear */
dw_insert.ResetUpdate()

/* 저장후 조회 */
sArea  = dw_ip.GetItemString(1,'sarea')
ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))

If nCnt > 0 Then sCvcod = dw_insert.GetItemString(nCnt,'cvcod')
sOut_gu = Trim(dw_ip.GetItemString(1,'out_gu'))

IF sArea ="" OR IsNull(sArea) THEN	sArea = ''
IF sOut_gu ="" OR IsNull(sOut_gu) THEN	sOut_gu = ''
if ls_sdate = "" or isnull(ls_sdate) then ls_sdate = '10000101'
if ls_edate = "" or isnull(ls_edate) then ls_edate = '30000101'
if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'

IF dw_cust_lst.Retrieve(gs_sabu, ls_saupj, is_today,sArea+'%',sOut_gu+'%', ls_sdate, ls_edate, ls_cvcod) > 0 THEN
	
	nRow = dw_cust_lst.Find("cust = '" + sCvcod + "'",1,dw_cust_lst.RowCount())
   dw_cust_lst.SelectRow(0,False)
	If nRow > 0 Then
		dw_cust_lst.SelectRow(nRow,True)
		dw_cust_lst.ScrollToRow(nRow)
		If nCnt > 0 Then Wf_Retrieve_Detail(sCvcod,ls_sdate,ls_edate)
	Else
		dw_insert.reset()
   End IF
Else
	dw_insert.Reset()
END IF

dw_insert.SetRedraw(true)

end event

type cb_exit from w_inherite`cb_exit within w_sal_02020
integer x = 3387
integer y = 2640
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_sal_02020
integer x = 2693
integer y = 2640
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;//Integer k,nCnt,nRow
//String  sCvcod,sArea,sOut_gu ,ls_sdate ,ls_edate, ls_cvcod
//
//IF dw_insert.Accepttext() = -1 THEN 	RETURN
//
//ncnt = dw_insert.RowCount()
//
//If dw_insert.ModifiedCount() <= 0 Then
//	sle_msg.text = '변경된 사항이 없습니다.'
//	Return
//End If
//
//IF f_msg_update() = -1 THEN RETURN
//
//IF dw_insert.Update(True,False) > 0 THEN			
//	COMMIT;
//	ib_any_typing =False
//
//	sle_msg.text ="자료를 저장하였습니다!!"
//	st_msg.Text = ''
//ELSE
//	ROLLBACK;
//	ib_any_typing = True
//	Return
//END IF
//
//dw_insert.SetRedraw(False)
//
///* 할당 처리 */
//Wf_AutoHalDang()
//
///* 할당처리후 Update 속성을 Clear */
//dw_insert.ResetUpdate()
//
///* 저장후 조회 */
//sArea  = dw_ip.GetItemString(1,'sarea')
//ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
//ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
//ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))
//
//If nCnt > 0 Then sCvcod = dw_insert.GetItemString(nCnt,'cvcod')
//sOut_gu = Trim(dw_ip.GetItemString(1,'out_gu'))
//
//IF sArea ="" OR IsNull(sArea) THEN	sArea = ''
//IF sOut_gu ="" OR IsNull(sOut_gu) THEN	sOut_gu = ''
//if ls_sdate = "" or isnull(ls_sdate) then ls_sdate = '10000101'
//if ls_edate = "" or isnull(ls_edate) then ls_edate = '30000101'
//if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
//
//IF dw_cust_lst.Retrieve(gs_sabu,is_today,sArea+'%',sOut_gu+'%', ls_sdate, ls_edate, ls_cvcod) > 0 THEN
//	
//	nRow = dw_cust_lst.Find("cust = '" + sCvcod + "'",1,dw_cust_lst.RowCount())
//   dw_cust_lst.SelectRow(0,False)
//	If nRow > 0 Then
//		dw_cust_lst.SelectRow(nRow,True)
//		dw_cust_lst.ScrollToRow(nRow)
//		If nCnt > 0 Then Wf_Retrieve_Detail(sCvcod,ls_sdate,ls_edate)
//	Else
//		dw_insert.reset()
//   End IF
//Else
//	dw_insert.Reset()
//END IF
//
//dw_insert.SetRedraw(true)
//
end event

type cb_ins from w_inherite`cb_ins within w_sal_02020
integer x = 530
integer y = 2748
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02020
integer x = 2546
integer y = 2748
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02020
integer x = 311
integer y = 2640
end type

event cb_inq::clicked;call super::clicked;//String sArea,sOut_gu , ls_sdate ,ls_edate , ls_cvcod 
//
//If dw_ip.AcceptText() <> 1 Then Return 
//
//sArea = Trim(dw_ip.GetItemString(1,'sarea'))
//sOut_gu = Trim(dw_ip.GetItemString(1,'out_gu'))
//ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
//ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
//ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))
//
//IF IsNull(sArea) THEN	sArea = ''
//IF IsNull(sOut_gu) THEN	sOut_gu = ''
//if ls_sdate = "" or isnull(ls_sdate) then ls_sdate = '10000101'
//if ls_edate = "" or isnull(ls_edate) then ls_edate = '30000101'
//if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
//
//IF dw_cust_lst.Retrieve(gs_sabu, is_today, sArea+'%', sOut_gu+'%',ls_sdate ,ls_edate,ls_cvcod) > 0 THEN
//	dw_cust_lst.SelectRow(0,False)
//	dw_cust_lst.SelectRow(1,True)
//	dw_cust_lst.ScrollToRow(1)
//	
//	Wf_Retrieve_Detail(dw_cust_lst.GetItemString(1,"cust"),ls_sdate,ls_edate)		
//ELSE
//	f_message_chk(50,'')
//	dw_insert.Reset()
//END IF
//
end event

type cb_print from w_inherite`cb_print within w_sal_02020
integer x = 878
integer y = 2748
integer width = 567
boolean enabled = false
string text = "의뢰서출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_02020
end type

type cb_can from w_inherite`cb_can within w_sal_02020
integer x = 3040
integer y = 2640
end type

event cb_can::clicked;call super::clicked;//dw_ip.SetFocus()
//
//dw_cust_lst.Reset()
//dw_insert.Reset()
//
//cbx_1.Checked = True
//cbx_2.Checked = True
//cbx_3.Checked = True
//ib_any_typing = False
//
//st_msg.Text = ''
end event

type cb_search from w_inherite`cb_search within w_sal_02020
integer x = 2203
integer y = 2768
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02020
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02020
end type

type gb_2 from groupbox within w_sal_02020
integer x = 78
integer y = 808
integer width = 1289
integer height = 136
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "[수주 검색조건]"
end type

type gb_5 from groupbox within w_sal_02020
boolean visible = false
integer x = 2651
integer y = 2600
integer width = 1115
integer height = 168
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_sal_02020
boolean visible = false
integer x = 270
integer y = 2600
integer width = 421
integer height = 168
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_1 from radiobutton within w_sal_02020
integer x = 55
integer y = 80
integer width = 640
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "수주 미승인 거래처"
end type

event clicked;IF this.Checked = True THEN
	dw_cust_lst.DataObject = 'd_sal_020201'
	dw_cust_lst.SetTransObject(SQLCA)
	dw_cust_lst.Reset()	
END IF

//cb_inq.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_sal_02020
integer x = 55
integer y = 156
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "모든 거래처"
boolean checked = true
end type

event clicked;IF this.Checked = True THEN
	dw_cust_lst.DataObject = 'd_sal_020202'
	dw_cust_lst.SetTransObject(SQLCA)
	dw_cust_lst.Reset()
END IF

//cb_inq.TriggerEvent(Clicked!)
end event

type cbx_1 from checkbox within w_sal_02020
integer x = 146
integer y = 860
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "접수"
boolean checked = true
end type

event clicked;string ls_sdate ,ls_edate

if dw_ip.accepttext() <> 1 then return 

IF dw_cust_lst.GetSelectedRow(0) <=0 THEN RETURN

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))

Wf_Retrieve_Detail(dw_cust_lst.GetItemString(dw_cust_lst.GetSelectedRow(0),"cust"),ls_sdate,ls_edate)
end event

type cbx_2 from checkbox within w_sal_02020
integer x = 443
integer y = 860
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "승인"
boolean checked = true
end type

event clicked;string ls_sdate ,ls_edate

if dw_ip.accepttext() <> 1 then return

IF dw_cust_lst.GetSelectedRow(0) <=0 THEN RETURN

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))

Wf_Retrieve_Detail(dw_cust_lst.GetItemString(dw_cust_lst.GetSelectedRow(0),"cust"),ls_sdate,ls_edate)
end event

type cbx_3 from checkbox within w_sal_02020
integer x = 745
integer y = 860
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "보류"
boolean checked = true
end type

event clicked;string ls_sdate ,ls_edate

if dw_ip.accepttext() <> 1 then return

IF dw_cust_lst.GetSelectedRow(0) <=0 THEN RETURN

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))

Wf_Retrieve_Detail(dw_cust_lst.GetItemString(dw_cust_lst.GetSelectedRow(0),"cust"),ls_sdate,ls_edate)
end event

type dw_cust_lst from u_d_popup_sort within w_sal_02020
integer x = 41
integer y = 292
integer width = 4549
integer height = 452
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_020202"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;string ls_sdate ,ls_edate

IF row <=0 THEN RETURN

this.SelectRow(0,False)
this.SelectRow(Row,True)

w_mdi_frame.sle_msg.Text = ''

if dw_ip.accepttext() <> 1 then return

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))

Wf_Retrieve_Detail(this.GetItemString(row,"cust"),ls_sdate,ls_edate)									

end event

event dw_cust_lst::rowfocuschanged;call super::rowfocuschanged;w_mdi_frame.sle_msg.Text = ''

IF currentrow > 0 THEN
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	this.ScrollToRow(currentrow)
	
//	Wf_Retrieve_Detail(this.GetItemString(currentrow,"cust"))		
END IF
end event

type dw_ip from datawindow within w_sal_02020
event ue_processenter pbm_dwnprocessenter
integer x = 741
integer y = 68
integer width = 2624
integer height = 176
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_020204"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sOutgu , ls_cvcod , ls_cvnas ,snull , ls_sarea

setnull(snull)

Choose Case GetColumnName()
	Case 'out_gu'
		sOutgu = Gettext()
		
		dw_insert.SetRedraw(False)
//		If sOutGu = 'Y' Then
//			dw_insert.DataObject = 'd_sal_020203'
//		Else
//			dw_insert.DataObject = 'd_sal_020206'
//		End If
		dw_insert.SetTransObject(sqlca)
		
		dw_insert.SetRedraw(True)
	 Case "sdate"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "sdate", sNull)
			f_Message_Chk(35, '[수주일자 FROM]')
			return 1
	   end if
	 Case "edate"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "edate", sNull)
			f_Message_Chk(35, '[수주일자 TO]')
			return 1
	   end if
	Case 'sarea'
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
	/* 거래처 */
	Case "cvcod"
		ls_cvcod = this.GetText()
		IF ls_cvcod ="" OR IsNull(ls_cvcod) THEN
			this.SetItem(1,"cvnas",snull)
			Return
		END IF
		
		SELECT "CVNAS2" , "SAREA" 
			INTO :ls_cvnas , :ls_sarea
			FROM "VNDMST" 
			WHERE "VNDMST"."CVCOD" = :ls_cvcod   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"cvnas",  ls_cvnas)
			this.SetItem(1,"sarea",  ls_sarea)
		END IF
End Choose
end event

event rbuttondown;string ls_sarea , ls_cvcod ,ls_cvnas

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
/* 거래처 */
 Case "cvcod"
	gs_gubun = '1'
	Open(w_agent_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"cvcod",gs_code)
	
	SELECT "CVNAS2",	"SAREA"
		INTO :ls_cvnas,		:ls_sarea
	   FROM "VNDMST" 
   	WHERE "CVCOD" = :gs_code;
	IF SQLCA.SQLCODE = 0 THEN
	  this.SetItem(1,"cvnas",  ls_cvnas)
	  this.SetItem(1,"sarea",  ls_sarea)
	END IF

END Choose

end event

type st_msg from statictext within w_sal_02020
boolean visible = false
integer x = 759
integer y = 2676
integer width = 1829
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_4 from checkbox within w_sal_02020
integer x = 1006
integer y = 860
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "분할"
boolean checked = true
end type

event clicked;string ls_sdate ,ls_edate

if dw_ip.accepttext() <> 1 then return

IF dw_cust_lst.GetSelectedRow(0) <=0 THEN RETURN

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))

Wf_Retrieve_Detail(dw_cust_lst.GetItemString(dw_cust_lst.GetSelectedRow(0),"cust"),ls_sdate,ls_edate)
end event

type p_1 from uo_picture within w_sal_02020
integer x = 3415
integer y = 52
integer width = 475
integer height = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\여신상세조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\여신상세조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\여신상세조회_up.gif'
end event

event clicked;String  sCust,sSuJuYearMonth
Integer iSelectedRow

iSelectedRow = dw_cust_lst.GetSelectedRow(0)
IF iSelectedRow <=0 THEN 
	f_message_chk(36,'')
	RETURN
END IF

IF dw_cust_lst.GetItemString(iSelectedRow,"cvcod_gu") = '4' THEN			/*부서*/
	f_message_chk(56,'[거래처 여신]')
	RETURN
END IF

sCust          = dw_cust_lst.GetItemString(iSelectedRow,'cust')
sSuJuYearMonth = dw_cust_lst.GetItemString(iSelectedRow,'suju_ym') 

IF sSuJuYearMonth = "" OR IsNull(sSuJuYearMonth) THEN 
	f_message_chk(30,'[수주년월]')
	Return
END IF

IF sCust = "" OR IsNull(sCust) THEN 
	f_message_chk(30,'[거래처]')
	Return
END IF

OpenWithParm(w_sal_02000_3,sSuJuYearMonth+sCust)

end event

type p_2 from uo_picture within w_sal_02020
integer x = 3415
integer y = 148
integer width = 475
integer height = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\거래처상세조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\거래처상세조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\거래처상세조회_up.gif'
end event

event clicked;call super::clicked;String  sCust,sSuJuYearMonth
Integer iSelectedRow

iSelectedRow = dw_cust_lst.GetSelectedRow(0)
IF iSelectedRow <=0 THEN 
	f_message_chk(36,'')
	RETURN
END IF

sCust          = dw_cust_lst.GetItemString(iSelectedRow,'cust')

IF sCust = "" OR IsNull(sCust) THEN 
	f_message_chk(30,'[거래처]')
	Return
END IF

OpenWithParm(w_sal_02000_1,sCust)

end event

type p_3 from uo_picture within w_sal_02020
integer x = 3570
integer y = 816
integer width = 475
integer height = 96
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\수주진행조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\수주진행조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\수주진행조회_up.gif'
end event

event clicked;call super::clicked;String  sOrderNo
Integer iSelectedRow

iSelectedRow = dw_insert.GetRow()
IF iSelectedRow <=0 THEN 
	f_message_chk(36,'')
	RETURN
END IF

sOrderNo = dw_insert.GetItemString(iSelectedRow,'order_no')

OpenWithParm(w_sal_02020_1,sOrderNo)

end event

type pb_1 from u_pb_cal within w_sal_02020
integer x = 2245
integer y = 72
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02020
integer x = 2706
integer y = 72
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 36
integer width = 3877
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 284
integer width = 4571
integer height = 468
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 772
integer width = 4571
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

