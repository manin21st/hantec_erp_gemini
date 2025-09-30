$PBExportHeader$w_sal_02000.srw
$PBExportComments$수주 등록
forward
global type w_sal_02000 from w_inherite
end type
type rb_insert from radiobutton within w_sal_02000
end type
type rb_modify from radiobutton within w_sal_02000
end type
type p_3 from uo_picture within w_sal_02000
end type
type p_2 from uo_picture within w_sal_02000
end type
type p_4 from uo_picture within w_sal_02000
end type
type p_pan from uo_picture within w_sal_02000
end type
type p_6 from uo_picture within w_sal_02000
end type
type dw_suju_ins from datawindow within w_sal_02000
end type
type dw_yusin from datawindow within w_sal_02000
end type
type p_1 from uo_picture within w_sal_02000
end type
type pb_1 from u_pb_cal within w_sal_02000
end type
type dw_head from datawindow within w_sal_02000
end type
type rr_1 from roundrectangle within w_sal_02000
end type
type rr_2 from roundrectangle within w_sal_02000
end type
type rr_3 from roundrectangle within w_sal_02000
end type
type rr_4 from roundrectangle within w_sal_02000
end type
end forward

global type w_sal_02000 from w_inherite
integer height = 2496
string title = "수주 등록"
rb_insert rb_insert
rb_modify rb_modify
p_3 p_3
p_2 p_2
p_4 p_4
p_pan p_pan
p_6 p_6
dw_suju_ins dw_suju_ins
dw_yusin dw_yusin
p_1 p_1
pb_1 pb_1
dw_head dw_head
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sal_02000 w_sal_02000

type variables
String    sOrderGbn = 'S0', sCursor
String     isOrderYN, isAutoHaldang='N', isautoaccept='N'

/* 지시수량이상 수주수량 변경 password */
String sPassWord

/* 여신체크시점 */
String sSyscnfg_Yusin, is_gwgbn

//판매구분 
String is_jeongsang,is_chuga,is_cancel
//품번
string is_mitnbr

// m환산기준
Dec idMeter
end variables

forward prototypes
public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty)
public function integer wf_calc_napgi (integer nrow, double ditemqty)
public function integer wf_calc_yusin (string sordercust)
public function string wf_calculation_orderno (string sorderdate)
public subroutine wf_clear_item (integer icurrow)
public function integer wf_clear_orderno ()
public function integer wf_closeing_check (string sdate)
public function string wf_copy_offer (string arg_ofno, decimal arg_ofseq)
public function integer wf_cvcod (string arg_cvcod)
public function string wf_depotno (string oversea_gu)
public function string wf_get_empid (string scvcod, ref string arg_saupj)
public function string wf_getsqlsyntax ()
public function string wf_orderlimitamount_check ()
public function integer wf_replace_napgidate (string ssujudate)
public function integer wf_set_minqty (integer nrow)
public function double wf_valid_qty (string sdepotno, string sitnbr, string sispec)
public function long wf_suju_status (integer nrow)
public function string wf_autohaldang ()
public function integer wf_requiredchk (string sdwobject, integer icurrow)
public subroutine wf_init ()
public function integer wf_suju_create (string arg_cvcod, string arg_cv_order_no)
public function integer wf_calc_wamt ()
public function integer wf_catch_special_danga (integer nrow, ref double order_prc, ref double order_rate, string gbn)
end prototypes

public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty);/* 판매단가및 할인율 */
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
string sOrderDate, sCvcod, sOrderSpec, sSalegu, sOutgu, sCurr, sPriceGbn
int    iRtnValue = -1, iRtn
double ditemprice,ddcrate, dQtyPrice, dQtyRate

sOrderDate = dw_suju_ins.GetItemString(1,"order_date")
sCvcod 	  = dw_suju_ins.GetItemString(1,"cvcod")
sOrderSpec = dw_insert.GetItemString(nRow,"order_spec")
sCurr		  = dw_suju_ins.GetItemString(1,"curr")

If sCurr = 'WON' Then
   sPriceGbn  = '1'  //원화
Else
	sPriceGbn  = '2'  //외화
End If

/* 수량 */
IF IsNull(dItemQty) THEN dItemQty =0

/* 무상출고일 경우 */
sSalegu = dw_insert.GetItemString(nRow, 'amtgu')
If sSaleGu = 'N' Then
	dItemPrice = sqlca.Fun_Erp100000025(Itnbr,sOrderSpec, sOrderDate) 
	If IsNull(dItemPrice) Then dItemPrice = 0

	dw_insert.SetItem(nRow, 'order_prc', dItemPrice)
	dw_insert.SetItem(nRow, 'order_amt', TrunCate(dItemQty * dItemPrice,0))
	dw_insert.SetItem(nRow, 'dc_rate',   0)
	Return 0
End If
		
/* 수량이 0이상일 경우 수량base단가,할인율을 구한다 */
If dItemQty > 0 Then
	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, Itnbr, dItemQty, &
                                    sCurr, dQtyPrice, dQtyRate) 
End If

If IsNull(dQtyPrice) Then dQtyPrice = 0
If IsNull(dQtyRate)	Then dQtyRate = 0

/* 판매 기본단가,할인율를 구한다 */
iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sOrderDate, sCvcod, Itnbr, sOrderSpec, &
												sCurr,sPriceGbn, dItemPrice, dDcRate) 

/* 특출단가나 거래처단가일경우 수량별 할인율은 적용안함 */
If iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0

/* 기본할인율 적용단가 * 수량별 할인율 */
//If dQtyRate <> 0 Then
//	
//	dItemPrice = dItemPrice * (100 - dQtyRate)/100
//	
//	/* 수소점2자리 */
//	dItemPrice = Truncate(dItemPrice , 5) 
//	
//	/* 할인율 재계산 */
//   iRtn = sqlca.fun_erp100000014(itnbr,sOrderSpec, dItemPrice, sOrderDate, sCurr, sPriceGbn, dDcRate)
//	
//   If iRtn = -1 Then dDcRate = 0
//End If

If IsNull(dItemPrice) Then dItemPrice = 0
If IsNull(dDcRate) 	 Then dDcRate = 0

/* 단가 : 절삭 */
dItemPrice = truncate(dItemPrice,5)

Choose Case iRtnValue
	Case IS < 0 
		Wf_Clear_Item(nRow)
		f_message_chk(41,'[단가 계산]'+string(irtnvalue))
		Return 1
	Case Else		
		/* 거래처 할인율, 정책할인율, 품목마스타 단가 */
		If iRtnValue = 3 or iRtnValue = 4 or iRtnValue = 5 Then
			dw_insert.SetItem(nRow,"special_yn",'N')
		Else
			dw_insert.SetItem(nRow,"special_yn",'Y')   /* 특출 */	
		End If
		
		dw_insert.SetItem(nRow,"pricegbn",String(irtnvalue))
		
		/* 금액 계산 */
		dw_insert.SetItem(nRow,"dc_rate",	dDcRate)
//		dw_insert.SetItem(nRow,"order_prc",	dItemPrice)
//		dw_insert.SetItem(nRow,"order_amt", TrunCate(dItemQty * dItemPrice,0))
		dw_insert.SetItem(nRow,"itmprc",	dItemPrice)
		dw_insert.SetItem(nRow,"itmamt", TrunCate(dItemQty * dItemPrice,2))
End Choose

/* -------------------------------------- */
/* 수량(m) 계산                           */
/* -------------------------------------- */
Dec itmx, itmy
Double mqty

itmx = dw_insert.GetItemNumber(nRow, 'itmx')
itmy = dw_insert.GetItemNumber(nRow, 'itmy')
If IsNull(itmx) Then x = 0
If IsNull(itmy) Then y = 0

mqty = Round(itmx * itmy * dItemQty / idMeter,2)
dw_insert.SetItem(nRow, 'mqty', mqty)
/* -------------------------------------- */

Return iRtnValue
end function

public function integer wf_calc_napgi (integer nrow, double ditemqty);String sItemGbn,sSujuDate,sOrderSpec,sItem,sOverSea
String sDepotNo,sOrderDate

If dItemQty <= 0 Then Return 0

/*'완제품'일 경우 예상납기일자를 구한다 */
sItemGbn   = dw_insert.GetItemString(nRow,"itemas_ittyp")
//IF sItemGbn = '1'	 Or sItemGbn = '3' Or sItemGbn = '7' THEN
	sSuJuDate = dw_suju_ins.GetItemString(1,"order_date")
		
	sOrderSpec = dw_insert.GetItemString(nRow,"order_spec")
	IF sOrderSpec ="" OR IsNull(sOrderSpec) THEN sOrderSpec = '.'
		
	sItem = dw_insert.GetItemString(nRow,"itnbr")

   /* 창고 */
	sDepotNo = Trim(dw_insert.GetItemString(nRow,"depot_no"))
	If IsNull(sDepotNo) Or sDepotNo = '' Then	Return 0
		
	/* 예상납기 */
	sOrderDate = sqlca.Fun_Erp100000020(sSuJuDate,sDepotNo,sItem,sOrderSpec,dItemQty)
	IF Len(sOrderDate) = 8 THEN
		dw_insert.SetItem(nRow,"pre_napgi",sOrderDate)
	ELSE
		IF sOrderDate = 'pass' THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			f_message_chk(39,'[예상납기]')
		ELSEIF sOrderDate = 'error' THEN
			f_message_chk(39,'[재고] '+sOrderDate)
		END IF
//		dw_insert.SetItem(nRow,'order_qty',0)
//		dw_insert.SetItem(nRow,"order_amt",0)
		dw_insert.SetColumn("order_qty")
		SetFocus()
		Return 1
	END IF
//END IF

Return 0

end function

public function integer wf_calc_yusin (string sordercust);/* Return : 0(거래진행), 1(중지),2(종료) */
Double  dUseAmount,dMonthOrderAmount, dLimitAmount, dNapqty
string  sSujuYm,sNull, sCvstatus, sGumgu

SetPointer(HourGlass!)

SetNull(sNull)

SELECT "VNDMST"."CREDIT_LIMIT", Nvl("VNDMST"."CVSTATUS",'0'), "VNDMST"."GUMGU", "VNDMST"."NAPQTY"
  INTO :dLimitAmount, :sCvStatus, :sGumgu, :dNapQty
  FROM "VNDMST"  
 WHERE "VNDMST"."CVCOD" = :sOrderCust;
//
///* 거래상태 */
//If sCvStatus = '1' or sCvStatus = '2' Then Return Integer(sCvStatus)
//
IF SQLCA.SQLCODE <> 0 THEN	return -1

dw_suju_ins.SetItem(1,"gumgu",  sGumgu)
dw_suju_ins.SetItem(1,"napqty", dNapQty)

dw_yusin.SetItem(1,"standardlimitamt",dLimitAmount)

/*월의 수주금액(수주상태 = '진행',할당,완료,마감)*/
sSuJuYm = Left(dw_suju_ins.GetItemString(1,"order_date"),6)
SELECT SUM("SORDER"."ORDER_AMT")
  INTO :dMonthOrderAmount  
  FROM "SORDER"  
 WHERE ( "SORDER"."SABU" = :gs_sabu) AND 
       ( "SORDER"."ORD_OK_DATE" >= :sSuJuYm||'01' ) AND  
       ( "SORDER"."ORD_OK_DATE" <= :sSuJuYm||'31' ) AND  
 		 ( "SORDER"."CVCOD" = :sOrderCust ) AND 
		 ( "SORDER"."SUJU_STS" IN ( '2','5','6','7','8','9' ))  ;

IF IsNull(dMonthOrderAmount) THEN dMonthOrderAmount = 0
dw_yusin.Modify("month_t.text = '" + Right(sSujuYm,2) + "월수주누계'")
dw_yusin.SetItem(1,"monthorderamt",dMonthOrderAmount)

/* 기여신금액 */
dUseAmount = sqlca.Fun_Erp100000030(gs_sabu,sOrderCust,sSuJuYm,Is_today);

If sqlca.sqlcode <> 0 Then 
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Return -1
End If

IF dUseAmount = -1  THEN
	f_message_chk(41,'[기여신금액]')
	dw_suju_ins.SetItem(1,"cvcod",snull)
	dw_suju_ins.SetItem(1,"cvnas",snull)
	dw_yusin.SetItem(1,"standardlimitamt",0)
	Return -1
ELSE
	dw_yusin.SetItem(1,"useorderamt",dUseAmount)
END IF
	
Return 0
end function

public function string wf_calculation_orderno (string sorderdate);String  sOrderNo, stemp
Integer iMaxOrderNo, nLen

/* 수주번호 자동채번 여부에 따라 */
If isorderyn = 'Y' Then
	iMaxOrderNo = sqlca.fun_junpyo(gs_sabu,sOrderDate,sOrderGbn)
	IF iMaxOrderNo <= 0 THEN
		ROLLBACK;
		f_message_chk(51,'')
		SetNull(sOrderNo)
		Return sOrderNo
	END IF
	
	sOrderNo = sOrderDate + String(iMaxOrderNo,'000')
	Commit;
Else
	sOrderNo = Trim(dw_suju_ins.GetItemString(1,'order_no'))
	
	nLen = Len(sOrderNo)
	SELECT DISTINCT SUBSTR("SORDER"."ORDER_NO",1,LENGTH("SORDER"."ORDER_NO")-3)
     INTO :sOrderNo
     FROM "SORDER"
    WHERE ( "SORDER"."SABU" = :gs_sabu ) AND
	       ( SUBSTR("SORDER"."ORDER_NO",1,:nLen) = :sOrderNo)  AND
 			 ( LENGTH("SORDER"."ORDER_NO") = :nLen+3 );
			 
	IF SQLCA.SQLCODE = 0 and sqlca.sqlnrows >= 1 THEN
		SetNull(sOrderNo)
		f_message_chk(10001,'[수주번호오류]')
		Return sOrderNo
	END IF
End If

Return sOrderNo

end function

public subroutine wf_clear_item (integer icurrow);String sNull
Dec    dNull

SetNull(snull)
SetNull(dnull)

//dw_insert.SetItem(iCurRow,"order_no",snull)
dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec_code",snull)
dw_insert.SetItem(iCurRow,"itemas_unmsr",snull)
dw_insert.SetItem(iCurRow,"itemas_ittyp",snull)
dw_insert.SetItem(iCurRow,"dc_rate",        0)
dw_insert.SetItem(iCurRow,"order_prc",      0)
dw_insert.SetItem(iCurRow,"order_qty",      0)
dw_insert.SetItem(iCurRow,"order_amt",      0)
dw_insert.SetItem(iCurRow,"sum_validqty",0)
dw_insert.SetItem(iCurRow,"pre_napgi",snull)

dw_insert.SetItem(iCurRow,"itmprc",      0)
dw_insert.SetItem(iCurRow,"imtamt",      0)
dw_insert.SetItem(iCurRow,"uamt",        0)

dw_insert.SetItem(iCurRow,"itmx",        0)
dw_insert.SetItem(iCurRow,"itmy",        0)
dw_insert.SetItem(iCurRow,"itm_shtnm",   sNull)
dw_insert.SetItem(iCurRow,"seqno",		  dNull)
end subroutine

public function integer wf_clear_orderno ();/* 순번이 99초과시 초기화 */
Long k
String sNull

SetNull(sNull)

FOR k = dw_insert.Rowcount() TO 1 Step -1
   If dw_insert.GetItemStatus(k,0,Primary!) = NewModified! Or &
	    dw_insert.GetItemStatus(k,0,Primary!) = New! Then
		
		  dw_insert.SetItem(k,"suju_sts",   '1')
	    dw_insert.SetItem(k,"ord_ok_date",sNull)
		  dw_insert.SetItem(k,"order_no",   sNull)
	End If

NEXT

Return 0
end function

public function integer wf_closeing_check (string sdate);
Return 1
end function

public function string wf_copy_offer (string arg_ofno, decimal arg_ofseq);String sitnbr

  SELECT "OFDETL"."ITNBR"    INTO :sitnbr
    FROM "OFDETL",  "OFHEAD"  
   WHERE ( "OFDETL"."SABU" = "OFHEAD"."SABU" ) and  
         ( "OFDETL"."OFNO" = "OFHEAD"."OFNO" ) and
			( "OFDETL"."SABU" = :gs_sabu ) and
			( "OFDETL"."OFNO" = :arg_ofno ) and
			( "OFDETL"."OFSEQ"= :arg_ofseq) and
			( "OFDETL"."CFMDATE" IS NOT NULL );

If sqlca.sqlcode <> 0 Then
	f_message_chk(50,'[미승인자료]')
	Return 'ERROR'
End If

Return sItnbr
end function

public function integer wf_cvcod (string arg_cvcod);String sCustName, sEmpId, sCvstatus, sGumgu,  sArea, sSaupj, sCvgu
String chksarea, chksteam, sNull
Dec    dNapqty, dLimitAmount
Int    iReturn = 0

SetNull(sNull)

If Not IsNull(arg_cvcod) And Trim(arg_cvcod) <> '' Then
	SELECT "VNDMST"."CVNAS2", "VNDMST"."SALE_EMP",     "VNDMST"."CVSTATUS", "VNDMST"."GUMGU",
			 "VNDMST"."NAPQTY", "VNDMST"."CREDIT_LIMIT", "VNDMST"."SAREA", "SAREA"."SAUPJ",
			 "VNDMST"."CVGU"
	  INTO :sCustName, :sEmpId ,:sCvstatus, :sGumgu, :dNapqty, :dLimitAmount, :sArea, :sSaupj,
	       :sCvgu
	  FROM "VNDMST", "SAREA"
	 WHERE "VNDMST"."CVCOD" = :arg_cvcod AND 
			 "VNDMST"."SAREA" = "SAREA"."SAREA"(+);

	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox('확 인','거래처를 확인하십시요!!')
		iReturn = 1
	/* 부서일 경우 */
	ElseIf sCvgu = '4' Then
		iReturn = 0
	ElseIf Trim(sCvstatus ) = '1' Then
		MessageBox('확 인','거래중지된 거래처입니다')
		iReturn = 1
	ElseIf Trim(sCvstatus ) = '2' Then
		MessageBox('확 인','거래종료된 거래처입니다')
		iReturn = 1
	ELSEIF IsNull(sArea) Or Trim(sArea) = '' THEN
		MessageBox('확 인','관할구역이 등록되어있지 않습니다.!!')
		iReturn = 1
	/* User별 관할구역 Check */	
	ELSEIf f_check_sarea(chksarea, chksteam, sSaupj) = 1 And chksarea <> sarea Then
		f_message_chk(114,'')
		dw_suju_ins.SetItem(1,"cvcod",	snull)
		dw_suju_ins.SetItem(1,"cvnas",	snull)
		iReturn = 1
	End If
Else
	iReturn = 1
End If

If	iReturn = 0 Then
	dw_suju_ins.SetItem(1,"cvcod",  arg_cvcod)
	dw_suju_ins.SetItem(1,"cvnas",  sCustName)
//	dw_suju_ins.SetItem(1,"emp_id", sEmpId)
	dw_suju_ins.SetItem(1,"gumgu",  sGumgu)
	dw_suju_ins.SetItem(1,"napqty", dNapQty)
	dw_yusin.SetItem(1,"standardlimitamt",dLimitAmount)
	
	wf_calc_yusin(arg_cvcod)
	Return 1
Else
	dw_suju_ins.SetItem(1,"cvcod",	snull)
	dw_suju_ins.SetItem(1,"cvnas",	snull)
//	dw_suju_ins.SetItem(1,"emp_id",	snull)
	dw_suju_ins.SetItem(1,"gumgu",  	sNull)
	dw_suju_ins.SetItem(1,"napqty",  1)
	
	dw_yusin.SetItem(1,"standardlimitamt",0)
	dw_yusin.SetItem(1,"useorderamt",0)
	dw_yusin.SetItem(1,"monthorderamt",0)
			
	Return -1
End If
end function

public function string wf_depotno (string oversea_gu);string sDepotNo, sSaupj

// OVERSEA_GU 를 품목구분으로 변경한다
If IsNull(oversea_gu) Or oversea_gu = '' Then Return ''

//sDepotNo	= dw_suju_ins.GetItemString(1, 'depot_no')
sSaupj 	= dw_suju_ins.GetItemString(1, 'saupj')

//If IsNull(sDepotNo) Or Trim(sDepotNo) = '' Then
//	select min(cvcod )
//	  into :sDepotNo
//	  from vndmst
//	 where cvgu = '5' and
//			 juprod = '1' and       // 완제품
//			 ipjogun = :sSaupj and     
//			 juhandle = :oversea_gu ;
//End If

Choose Case oversea_gu
	Case '1','8'	// 완제품,가상품
		select min(cvcod )  into :sDepotNo
	     from vndmst
	    where cvgu = '5' and
			    juprod = '1' and
			    ipjogun = :sSaupj;
//		Case '2'	// 반제품
//		select min(cvcod )  into :sDepotNo
//	     from vndmst
//	    where cvgu = '5' and
//			    juprod = '2' and
//				 jumaechul = '2' and
//			    ipjogun = :sSaupj;
		Case Else	// 생산창고
		select min(cvcod )  into :sDepotNo
	     from vndmst
	    where cvgu = '5' and
			    juprod = '2' and
				 jumaechul = '1' and
			    ipjogun = :sSaupj;
End Choose

If IsNull(sDepotNo) Then 
	f_message_chk(1400,'[창고]')
	sDepotNo = ''
End If

Return sDepotNo

end function

public function string wf_get_empid (string scvcod, ref string arg_saupj);/* 거래처의 영업담당자 */
String sEmpId

SELECT "VNDMST"."SALE_EMP", "SAREA"."SAUPJ"
  INTO :sEmpId, :arg_saupj
  FROM "VNDMST", "SAREA"
 WHERE "VNDMST"."CVCOD" = :sCvcod AND
       "VNDMST"."SAREA" = "SAREA"."SAREA";

Return sEmpId
end function

public function string wf_getsqlsyntax ();Int     k , nRow
String sGetSqlSyntax,sSuJuOrderNo,sSuJuSts = '2'
Long   lSyntaxLength

sGetSqlSyntax = 'and (sorder.sabu = '+ "'" + gs_sabu + "'"+" ) and "
sGetSqlSyntax = 'and (sorder.suju_sts = '+ "'"+sSuJuSts+"'"+" ) and "

sGetSqlSyntax = sGetSqlSyntax + '('

nRow = dw_suju_ins.RowCount()
If nRow <= 0 Then Return ''

sSuJuOrderNo = Trim(dw_suju_ins.GetItemString(1,'order_no'))
If IsNull(sSujuOrderNo) or sSujuOrderNo = '' Then Return ''	

sGetSqlSyntax = sGetSqlSyntax + ' substr(sorder.order_no,1,length(sorder.order_no)-3) =' + "'"+ sSuJuOrderNo +"' "

sGetSqlSyntax = sGetSqlSyntax + ")"

Return sGetSqlSyntax
end function

public function string wf_orderlimitamount_check ();Long   ix
String sSts,sOrderFlag
Double  dAcceptAmount, dStandardLimitAmount
dwItemStatus l_status

/* 수주자동승인이 아닐경우 '접수' */
If isautoaccept = 'N' Then Return '1'

/* 승인한도 금액 */
dAcceptAmount = dw_yusin.GetItemNumber(1,'acceptlimitamt')

For ix = 1 To dw_insert.RowCount()
	l_status = dw_insert.GetItemStatus(ix, 0, Primary!)
	sSts = dw_insert.GetItemString(ix,'suju_sts')
	If sSts = '1' or sSts = '2' or sSts = '5' or sSts = '6' Then
     Choose Case l_status
	 	 Case datamodified!    // 기존금액이 변경된 경우 +new.amt - old.amt
			 dAcceptAmount -= (  dw_insert.GetItemNumber(ix,'order_amt') - dw_insert.GetItemNumber(ix,'order_amt',primary!,true))
		 Case NewModified!
			 dAcceptAmount -= dw_insert.GetItemNumber(ix,'order_amt')
	  End Choose
   End If
Next

dw_yusin.SetItem(1,'currentorderamt',dAcceptAmount)

IF isautoaccept = 'Y' THEN
	dw_yusin.AcceptText()
	
	dAcceptAmount = dw_yusin.GetItemNumber(1,"currentorderamt")    // 수주금액
	IF IsNull(dAcceptAmount) Then dAcceptAmount = 0
	
	/*여신체크시점 '수주승인' */
	IF sSyscnfg_Yusin = '1' THEN
		IF  dAcceptAmount  > 0 THEN
			sOrderFlag = '2'                      /* 승인 = 승인한도 >= 수주금액 */
		ELSE
			sOrderFlag = '3'                      /* 보류 = 승인한도 <  수주금액 */
		END IF
	/* 여신체크를 안할경우 자동승인 */
	ELSEIf sSyscnfg_Yusin = '4' Then
		sOrderFlag = '2'
	Else
		sOrderFlag = '2'
	END IF
	
	/* 승인한도가 없을경우 여신체크 안함 */
	dStandardLimitAmount = dw_yusin.GetItemNumber(1,'standardlimitamt') // 승인한도금액
	If IsNull(dStandardLimitAmount) Or dStandardLimitAmount = 0 Then
		sSyscnfg_Yusin = '4'
		sOrderFlag = '2'
	End If
ELSE
	sOrderFlag = '1'
END IF
		
Return sOrderFlag
end function

public function integer wf_replace_napgidate (string ssujudate);String  sItemGbn,sOrderSpec,sOrderDate,sItem,snull
Integer k
Double  dItemQty
string  soversea,sdepotno

FOR k = 1 TO dw_insert.RowCount()
	sItemGbn   = dw_insert.GetItemString(k,"itemas_ittyp")								/*품목구분*/
	sOrderSpec = dw_insert.GetItemString(k,"order_spec")								/*사양*/
	sItem      = dw_insert.GetItemString(k,"itnbr")
	dItemQty   = dw_insert.GetItemNumber(k,"order_qty")
	
	IF sOrderSpec ="" OR IsNull(sOrderSpec) THEN sOrderSpec = '.'		
	
	IF sItemGbn = '1'	 THEN										/*'완제품'일 경우*/
	   sOverSea = dw_insert.GetItemString(k,"itemas_ittyp")	
		sDepotNo = wf_DepotNo(sOverSea)		
		sOrderDate = sqlca.Fun_Erp100000020(sSuJuDate,sDepotNo,sItem,sOrderSpec,dItemQty)
		IF Len(sOrderDate) = 8 THEN
			dw_insert.SetItem(k,"pre_napgi",sOrderDate)
		ELSE
			IF sOrderDate = 'pass' THEN
				f_message_chk(41,'[예상납기]')
			ELSEIF sOrderDate = 'error' THEN
				f_message_chk(39,'[재고]')
			END IF
			dw_insert.SetItem(k,"pre_napgi",snull)
			Return -1
		END IF
	END IF
NEXT

Return 1
end function

public function integer wf_set_minqty (integer nrow);Dec dItemQty, nNapQty, dMinQty, dMaxQty

if nRow < 1 then return 0

/* 납품배수 */
nNapQty  = dw_suju_ins.GetItemNumber(1,'napqty')
dItemQty = dw_insert.GetItemNumber(nRow, 'order_qty')
dMaxQty  = dw_insert.GetItemNumber(nRow, 'maxqty')

/* 절대수량 계산 */
dMinQty = TrunCate(dItemQty * dMaxQty / 100,3)

If IsNull(nNapqty) Or nNapQty = 0 Then
Else
	dMinQty = truncate(dMinQty / nNapQty,0) * nNapQty
End If

If IsNull(dMinQty) Then dMinQty = 0

dw_insert.SetItem(nRow, 'minqty', dMinQty)

Return 0

end function

public function double wf_valid_qty (string sdepotno, string sitnbr, string sispec);/* 가용재고 */
Double dQty

SELECT NVL(SUM("STOCK"."VALID_QTY")  ,0)
  INTO :dQty  
  FROM "STOCK"  
 WHERE ( "STOCK"."DEPOT_NO" = :sDepotNo) AND
       ( "STOCK"."ITNBR" = :sItnbr) AND
       ( "STOCK"."PSPEC" = :sIspec );

Return dQty
end function

public function long wf_suju_status (integer nrow);Double dOrderQty, dHoldQty, dJisiQty, dProdQty, dInvQty, dIsQty
String pur_req_no, sAgrDat, sToday, sSujuSts, sOrderNo

/* 수주상태 확인 */
If nRow <=0  Or dw_insert.RowCount() < nRow Then Return -1

sToDay = f_today()

sSujuSts = dw_insert.GetItemString(nRow,'suju_sts')
Choose Case sSujuSts
	Case '1'
		Return 0				 // 접수 : 삭제 가능
	Case '3'              // 보류
		return -2
	Case '4','8','9'      // 취소,완료,마감 => 삭제불가,수정불가
		return -1
	Case Else		
		dOrderQty = dw_insert.GetItemNumber(nRow,"order_qty")	   /*수주수량 합*/
		IF IsNull(dOrderQty) THEN dOrderQty =0
		
		dHoldQty = dw_insert.GetItemNumber(nRow,"hold_qty")		/*할당수량 합*/
		IF IsNull(dHoldQty) THEN dHoldQty =0
		
		dInvQty = dw_insert.GetItemNumber(nRow,"invoice_qty")			/*송장수량 합*/
		IF IsNull(dInvQty) THEN dInvQty =0
		
		dJisiQty = dw_insert.GetItemNumber(nRow,"jisi_qty")		/*생산지시수량 합*/
		IF IsNull(dJisiQty) THEN dJisiQty =0
		
		dProdQty = dw_insert.GetItemNumber(nRow,"prod_qty")		/*생산입고수량 합*/
		IF IsNull(dProdQty) THEN dProdQty =0
		
		pur_req_no = Trim(dw_insert.GetItemString(nRow,"pur_req_no"))	/* 구매번호 */
		IF IsNull(pur_req_no) THEN pur_req_no = ''
		
		sAgrDat = Trim(dw_insert.GetItemString(nRow,"agrdat"))	/* 생산승인일자 */
		IF IsNull(sAgrDat) Or sAgrDat = '0' THEN sAgrDat = ''
				
		/* 생산진행중 */
		If (dJisiQty - dProdQty) <> 0 THEN
			Return Abs(dHoldQty + dJisiQty - dProdQty)
		/* 구매진행중 */
		ElseIf  pur_req_no <> '' Then
			Return dOrderQty
		/* 생산승인 */
//		ElseIf  dJisiQty = 0 and dProdQty = 0 and sAgrDat <> '' and sAgrDat < sToDay Then
		ElseIf  dJisiQty = 0 and dProdQty = 0 and sAgrDat <> '' Then
			Return dOrderQty
		/* 할당수량 존재 */
		ElseIF dHoldQty <> 0 Then 
			Return Abs(dHoldQty + dJisiQty - dProdQty)
		Else
			Return 0    /* 미진행(승인) */
		End If
End Choose
end function

public function string wf_autohaldang ();String  sSqlSyntax,sHoldNo,sOrderNo,sOrderDate,sIojpno, sMsg
String  sCvcod, sEmpId, sDirgb, ls_saupj
Integer iRtnValue, icnt
Dec	  dAcceptAmount

/* 여신금액 */
dAcceptAmount = dw_yusin.GetItemNumber(1,"currentorderamt")
IF IsNull(dAcceptAmount) Then dAcceptAmount = 0
	
ls_saupj = dw_suju_ins.GetItemString(1,"saupj")
	
///*할당자동여부*/
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)
//  INTO :sSyscnfg_Flag  
//  FROM "SYSCNFG"  
// WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 1) AND ("SYSCNFG"."LINENO" = '20' );
//
//IF SQLCA.SQLCODE <> 0 THEN
//	sSyscnfg_Flag = 'N'
//ELSE
//	IF sSyscnfg_Flag = "" OR IsNull(sSyscnfg_Flag) THEN sSyscnfg_Flag = 'N'
//END IF

/* 자동할당일 경우 */
IF isAutoHaldang = 'Y' THEN
	/* 여신체크가 할당인 경우 */
	If sSyscnfg_Yusin = '2' And dAcceptAmount  < 0 Then
		sMsg = '여신부족으로 할당되지 않습니다.!!'
		Return sMsg
	End If
	
	sSqlSynTax = Wf_GetSqlSyntax()

	iRtnValue = sqlca.fun_erp100000040(gs_sabu,'%',dw_suju_ins.GetItemString(1,"order_date"),sSqlSyntax)
	If   sqlca.sqlcode <> 0 Then
		sMsg = '자동할당을 실패하였습니다 ' + sqlca.sqlerrtext
		RollBack;
		Return sMsg
	End If
	
	IF iRtnValue = -1 THEN
		f_message_chk(39,'')
		ROLLBACK;
		Return ''
	ELSEIF iRtnValue = -2 THEN
		f_message_chk(41,'[할당]')
		Return ''
	ELSEIF iRtnValue = 0 THEN        /* 할당된 건수가 없을 경우 */
//		MessageBox('할당','할당된 건수가 없습니다! ')
		Return ''
	Else
//		MessageBox('할당','할당건수 ' + String(iRtnValue)+'건')
	END IF
Else
	Return ''
END IF

/* -----------------------------------------*/
/* 송장 발행                                */
/* -----------------------------------------*/
sOrderNo   = Trim(Trim(dw_suju_ins.GetItemString(1,'order_no')))
sOrderDate = dw_suju_ins.GetItemString(1,'order_date')

sDirgb = Trim(Trim(dw_suju_ins.GetItemString(1,'dirgb')))
If sDirgb <> 'D' Then 
	Commit;
	Return '' /* 직납이 아닌경우는 자동으로 송장 발행을 하지 않는다 */
End If

/* 매출마감시 송장 발행 안함 */
SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sOrderDate,1,6) )   ;

If iCnt >= 1 then
	COMMIT;
	sMsg = '매출마감되어 있습니다.!!'
	return sMsg
End if

/* 여신체크가 송장인 경우 */
If sSyscnfg_Yusin = '3' And dAcceptAmount  < 0 Then
	sMsg = '여신부족으로 송장발행되지 않습니다.!!'
	Return sMsg
End If
	
//IF MessageBox("확 인","출고송장을 발행하시겠습니까?",Question!,YesNo!) = 2 THEN Return ''
//
///* 할당번호 선택 */
//SELECT DISTINCT SUBSTR(HOLD_NO,1,12) INTO :sHoldNo
//  FROM HOLDSTOCK
// WHERE SUBSTR(ORDER_NO,1,LENGTH(ORDER_NO)-3) = :sOrderNo AND
//       OUT_CHK = '1';
//
//If sqlca.sqlcode <> 0 Then
//  f_message_chk(89,'[할당번호 오류]')
//  Return ''
//End If
//
//If IsNull(sHoldNo) Or sHoldNo = '' Then
//  f_message_chk(89,'[할당번호 미존재]')
//  Return ''
//End If
//
//sCvcod = Trim(dw_suju_ins.GetItemString(1,'cvcod')) // 의뢰부서 
//sEmpId = Trim(dw_suju_ins.GetItemString(1,'emp_id')) // 의뢰담당자
//sIojpno = sqlca.fun_erp100000070(gs_sabu,sHoldNo, sOrderDate,'',sCvcod,sEmpId)
//If sqlca.sqlcode <> 0 Then
//	MessageBox("Compile Error","Procedure[fun_erp100000070] invalid~r~n~r~n전산실로 연락하세요")
//	RollBack;
//	Return  ''
//End If
//
//If IsNull(sIojpno) or Trim(sIoJpNo) = '' Then
//	f_message_chk(41,'[송장발행]')
//	Return ''
//Else
//	MessageBox('확 인','송장출고 완료되었습니다.!!')
//END IF
//
COMMIT;

sMsg = '정상적으로 저장하였습니다.!!'

Return sMsg
end function

public function integer wf_requiredchk (string sdwobject, integer icurrow);String  sOrderDate,sOrderCust,sItem,sSpec,sDepotNo, sEmp_id
String  sSugugb, sHouseNo, sSaupj, sOutgu, sPangb, sDirgb, sCustNapgi, sCurr
Double  dQty,dPrc, dMinQty, dMaxQty
Dec     wrate

/* header 부문 */
IF sDwObject = 'd_sal_020001' THEN
	dw_suju_ins.SetFocus()
	
	sSaupj     = Trim(dw_suju_ins.GetItemString(1,"saupj"))
	
	sOrderDate = Trim(dw_suju_ins.GetItemString(1,"order_date"))
	sOrderCust = Trim(dw_suju_ins.GetItemString(1,"cvcod"))
	sSugugb    = Trim(dw_suju_ins.GetItemString(1,"sugugb"))
	sDirgb     = Trim(dw_suju_ins.GetItemString(1,"dirgb"))
	sEmp_id	  = Trim(dw_suju_ins.GetItemString(1,"emp_id"))
	sCurr	  = Trim(dw_suju_ins.GetItemString(1,"curr"))
	
	If IsNull(sHouseNo) Then sHouseNo = ''

//	sHouseNo   = Trim(dw_suju_ins.GetItemString(1,"house_no"))
//	sDepotNo   = Trim(dw_suju_ins.GetItemString(1,"depot_no"))
//	If IsNull(sDepotNo) Then sDepotNo = ''
	
	IF IsNull(sSaupj) OR sSaupj = ''  or ssaupj = '99' THEN
		f_message_chk(30,'[부가세사업장]')
		dw_suju_ins.SetColumn("saupj")
		Return -1
	END IF
	
	IF sOrderDate = "" OR IsNull(sOrderDate) THEN
		f_message_chk(30,'[수주일자]')
		dw_suju_ins.SetColumn("order_date")	
		Return -1
	END IF

	IF sCurr = "" OR IsNull(sCurr) THEN
		f_message_chk(30,'[통화단위]')
		dw_suju_ins.SetColumn("curr")	
		Return -1
	END IF
	
	IF sOrderCust = "" OR IsNull(sOrderCust) THEN
		f_message_chk(30,'[거래처]')
		dw_suju_ins.SetColumn("cvcod")
		Return -1
	END IF
	IF sSugugb = '' OR IsNull(sSugugb) THEN
		f_message_chk(30,'[수주구분]')
		dw_suju_ins.SetColumn("sugugb")
		Return -1
	END IF
	IF sDirgb = '' OR IsNull(sDirgb) THEN
		f_message_chk(30,'[직송구분]')
		dw_suju_ins.SetColumn("dirgb")
		Return -1
	END IF
	
//	IF sDepotNo = "" OR IsNull(sDepotNo) THEN
//		f_message_chk(30,'[출고창고]')
//		dw_suju_ins.SetColumn("depot_no")
//		Return -1
//	END IF
//	IF sHouseNo = "" OR IsNull(sHouseNo) THEN
//		f_message_chk(30,'[납품창고]')
//		dw_suju_ins.SetColumn("house_no")
//		Return -1
//	END IF
	
//	/* 직납인 경우 출고창고 = 납품창고 */
//	If sDirgb = 'D' Then
//		If sHouseNo <> sDepotNo Then
//			MessageBox('확인','출고창고와 납품창고가 일치하지 않습니다.!!')
//			Return -1
//		End If
//	Else
//		If sHouseNo = sDepotNo Then
//			MessageBox('확인','출고창고와 납품창고동일합니다.!!')
//			Return -1
//		End If
//	End If

	IF sEmp_id = "" OR IsNull(sEmp_id) THEN
		f_message_chk(30,'[영업담당자]')
		dw_suju_ins.SetColumn("emp_id")
		Return -1
	END IF	
	
	If sCurr = 'WON' Then
	Else
		select x.rstan
		  into :wrate
		  from ratemt x, reffpf y
		 where x.rcurr = y.rfgub(+) and
				 y.rfcod = '10' and
				 x.rdate = :sOrderDate and
				 x.rcurr = :scurr;
		
		IF wrate <= 0 OR IsNull(wrate) THEN
			f_message_chk(166,'[통화환율]')
			dw_suju_ins.SetColumn("curr")
			Return -1
		END IF
	End If

/* detail 부문 */
ELSEIF sDwObject = 'd_sal_020002' THEN
	dw_insert.SetFocus()
		
	sItem = dw_insert.GetItemString(iCurRow,"itnbr")
	sOutgu = dw_insert.GetItemString(iCurRow,"out_gu")
	sPangb = dw_insert.GetItemString(iCurRow,"pangb")
	dQty  = dw_insert.GetItemNumber(iCurRow,"order_qty")
	dPrc  = dw_insert.GetItemNumber(iCurRow,"order_prc")
	sSpec = dw_insert.GetItemString(iCurRow,"order_spec")
	sCustNapgi = dw_insert.GetItemString(iCurRow,"cust_napgi")
	sDirgb     = Trim(dw_suju_ins.GetItemString(1,"dirgb"))
	
	IF sItem = "" OR IsNull(sItem) THEN
		f_message_chk(30,'[품번]')
		dw_insert.SetColumn("itnbr")
		Return -1
	END IF
	
	IF dQty = 0 OR IsNull(dQty) THEN
		f_message_chk(30,'[수량]')
		dw_insert.SetColumn("order_qty")
		Return -1
	END IF

	IF sOutgu = "" OR IsNull(sOutgu) THEN
		f_message_chk(30,'[수불구분]')
		dw_insert.SetColumn("out_gu")
		Return -1
	END IF

	IF sCustNapgi = "" OR IsNull(sCustNapgi) THEN
		f_message_chk(30,'[납기요구일]')
		dw_insert.SetColumn("cust_napgi")
		Return -1
	END IF
	
	IF sSpec = "" OR IsNull(sSpec) THEN
		dw_insert.SetItem(iCurRow,'order_spec','.')
	END IF
	
	sHouseNo   = Trim(dw_insert.GetItemString(iCurRow,"house_no"))
	sDepotNo   = Trim(dw_insert.GetItemString(iCurRow,"depot_no"))
	If IsNull(sDepotNo) Then sDepotNo = ''
	IF sDepotNo = "" OR IsNull(sDepotNo) THEN
		f_message_chk(30,'[출고창고]')
		dw_insert.SetColumn("depot_no")
		Return -1
	END IF
	IF sHouseNo = "" OR IsNull(sHouseNo) THEN
		f_message_chk(30,'[납품창고]')
		dw_insert.SetColumn("house_no")
		Return -1
	END IF
	
	/* 직납인 경우 출고창고 = 납품창고 */
	If sDirgb = 'D' Then
		If sHouseNo <> sDepotNo Then
			MessageBox('확인','출고창고와 납품창고가 일치하지 않습니다.!!')
			Return -1
		End If
	Else
		If sHouseNo = sDepotNo Then
			MessageBox('확인','출고창고와 납품창고동일합니다.!!')
			Return -1
		End If
	End If
END IF

Return 1
end function

public subroutine wf_init ();string sDepotNo, sDate, sTime, sNextDate

rollback;

dw_suju_ins.SetRedraw(False)
dw_suju_ins.Reset()
dw_suju_ins.InsertRow(0)
dw_suju_ins.SetRedraw(True)

dw_yusin.SetRedraw(False)
dw_yusin.Reset()
dw_yusin.InsertRow(0)
dw_yusin.SetRedraw(True)

dw_insert.Reset()

/* User별 사업장 Setting */
setnull(gs_code)

sDate = sqlca.Fun_Erp100000050(gs_sabu, sordergbn, is_today, '1')
If f_datechk(sDate) <> 1 Then SetNull(sDate)

dw_suju_ins.SetItem(1,"order_date",sDate)

p_ins.Enabled = True
p_ins.PictureName = 'C:\erpman\image\행추가_up.gif'

/* 등록 */
IF sModStatus = 'I' THEN
	
	/* 수주번호 자동채번 여부 */
	select substr(dataname,1,1) into :isOrderYN
	  from syscnfg
	 where sysgu = 'S' and
			 serial = 6 and
			 lineno = 50;
	If IsNull(isOrderYN) Or sqlca.sqlcode <> 0 Then isOrderYN = 'Y'
	
	/* 수주일자 변경 불가 */
	dw_suju_ins.Modify('order_date.protect = 0')
//	dw_suju_ins.Modify('depot_no.protect = 0')
	dw_suju_ins.Modify('cvcod.protect = 0')
   dw_suju_ins.Modify('cvnas.protect = 0')
   dw_suju_ins.Modify('sugugb.protect = 0')
	dw_suju_ins.Modify('dirgb.protect = 0')
	dw_suju_ins.Modify('house_no.protect = 0')
	dw_suju_ins.Modify('oversea_gu.protect = 0')
	dw_suju_ins.Modify('curr.protect = 0')
//	dw_suju_ins.Modify('saupj.protect = 0')
	
	If isOrderYn = 'N' Then
		dw_suju_ins.Modify('order_no.protect = 0')
		dw_suju_ins.SetColumn("order_no")
	Else
		dw_suju_ins.Modify('order_no.protect = 1')
		
		dw_suju_ins.SetColumn("cvcod")
	End If
	
	p_inq.Enabled = False
	p_mod.Enabled = False
//	p_del.Enabled = False
	
	p_inq.PictureName = "C:\erpman\image\조회_d.gif"
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
//	p_del.PictureName = "C:\erpman\image\행삭제_d.gif"
	
	dw_head.Reset()
	dw_head.InsertRow(0)
ELSE
/* 수정 */
	dw_suju_ins.Modify('order_no.protect = 0')
	dw_suju_ins.Modify('order_date.protect = 1')
//	dw_suju_ins.Modify('depot_no.protect = 1')
	dw_suju_ins.Modify('cvcod.protect = 1')
	dw_suju_ins.Modify('cvnas.protect = 1')
	dw_suju_ins.Modify('sugugb.protect = 1')
	dw_suju_ins.Modify('dirgb.protect = 1')
	dw_suju_ins.Modify('house_no.protect = 1')
	dw_suju_ins.Modify('oversea_gu.protect = 0')
	dw_suju_ins.Modify('curr.protect = 0')
//	dw_suju_ins.Modify('saupj.protect = 1')

	dw_suju_ins.SetColumn("order_no")

	p_inq.Enabled = True
	p_mod.Enabled = True
	p_del.Enabled = True
	
	p_inq.PictureName = "C:\erpman\image\조회_up.gif"
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_del.PictureName = "C:\erpman\image\행삭제_up.gif"
	
	dw_head.Reset()
END IF

dw_suju_ins.SetFocus()

//f_mod_saupj(dw_suju_ins, 'saupj')
dw_suju_ins.SetItem(1, 'saupj', gs_saupj)

dw_suju_ins.SetItem(1, 'emp_id'  , gs_empno)
dw_suju_ins.SetItem(1, 'deptno'  , gs_dept )
dw_suju_ins.SetItem(1, 'deptname', f_get_name5('11', gs_dept, ''))

//f_child_saupj(dw_suju_ins, 'depot_no', gs_saupj)
//f_child_saupj(dw_suju_ins, 'house_no', gs_saupj)

/* 기준창고 선택 */
//sDepotNo = wf_DepotNo('1')

//dw_suju_ins.SetItem(1,"depot_no",	sDepotNo)     // 출고창고
//dw_suju_ins.SetItem(1,"house_no",	sDepotNo)     // 납품창고


ib_any_typing = False
end subroutine

public function integer wf_suju_create (string arg_cvcod, string arg_cv_order_no);return 1
end function

public function integer wf_calc_wamt ();/* ---------------------------------------- */
/* 품목별 원화금액,외화금액 계산-LOCAL      */
/* ---------------------------------------- */
dec 	 dItmamt, dItmprc, dOrderQty
dec    weigh
String sOrderDate, sCurr, sPriceGbn, sOrderNo
Dec {4} wrate,urate
Dec {2} dOrderPrc
String  weight
Long    nRow

sOrderNo   = Left(dw_suju_ins.GetItemString(1,"order_no"),12)
sOrderDate = dw_suju_ins.GetItemString(1,"order_date")
sCurr		  = dw_suju_ins.GetItemString(1,"curr")

If sCurr = 'WON' Then
	wrate = 1
	urate = 1
	weigh = 1
Else
	select x.rstan,x.usdrat, y.rfna2
	  into :wrate,:urate, :weight
	  from ratemt x, reffpf y
	 where x.rcurr = y.rfgub(+) and
			 y.rfcod = '10' and
			 x.rdate = :sOrderDate and
			 x.rcurr = :scurr;
	
	If IsNull(weight) Or weight = '' Then weight = '0'
	If IsNull(wrate)  Or wrate = 0  Then wrate = 0.0
	If IsNull(urate)  Or urate = 0  Then urate = 0.0
	
	weigh = Dec(weight)
End If

If IsNull(wrate) Or wrate = 0 Then wrate = 1
If IsNull(urate) Or urate = 0 Then urate = 1
If IsNull(weigh) Or weigh = 0 Then weigh = 1

For nRow = 1 To dw_insert.RowCount()
	dItmprc = dw_insert.GetItemNumber(nRow, 'itmprc')
	dItmamt = dw_insert.GetItemNumber(nRow, 'itmamt')
	dOrderQty = dw_insert.GetItemNumber(nRow, 'order_qty')
	
	dOrderPrc = Truncate((dItmprc * wrate)/weigh,2)
	dw_insert.SetItem(nRow,'order_prc', dOrderPrc)
	//dw_insert.SetItem(nRow,'order_amt',Truncate(dOrderQty * dOrderPrc,0))
	dw_insert.SetItem(nRow,'order_amt',Truncate((dItmamt * wrate)/weigh,0))
	
	dw_insert.SetItem(nRow,'uamt',Truncate((dItmamt * urate)/weigh,2))
Next

If dw_head.RowCount() > 0 Then
	dw_head.SetItem(1, 'sabu', gs_sabu)
	dw_head.SetItem(1, 'PINO', sOrderNo)
	dw_head.SetItem(1, 'CVCOD', dw_suju_ins.GetItemString(1,"cvcod"))
	dw_head.SetItem(1, 'PIGU', '2')
	dw_head.SetItem(1, 'PISTS', '2')
	dw_head.SetItem(1, 'PIDATE', sOrderDate)
	dw_head.SetItem(1, 'ORDCFDT', sOrderDate)
	dw_head.SetItem(1, 'LOCALYN', 'Y')
	dw_head.SetItem(1, 'CURR', scurr)
	dw_head.SetItem(1, 'WRATE', wrate)
	dw_head.SetItem(1, 'URATE', urate)
	dw_head.SetItem(1, 'WEIGHT', weigh)
	dw_head.SetItem(1, 'pono', dw_suju_ins.GetItemString(1,"cv_order_no"))
	dw_head.SetItem(1, 'deptcode', dw_suju_ins.GetItemString(1,"deptno"))
	dw_head.SetItem(1, 'emp_id', dw_suju_ins.GetItemString(1,"emp_id"))
	dw_head.SetItem(1, 'piamt', dw_insert.GetItemNumber(1,"sum_itmamt"))
	dw_head.SetItem(1, 'saupj', dw_suju_ins.GetItemString(1,"saupj"))
End If

Return 1

end function

public function integer wf_catch_special_danga (integer nrow, ref double order_prc, ref double order_rate, string gbn);/* ----------------------------------------------------- */
/* 특출일 경우 할인율과 단가 계산                        */
/* ----------------------------------------------------- */
string s_order_date,s_itnbr,s_ispec,s_curr,s_pricegbn, sSalegu,sOrderSpec
int irow,rtn

iRow = dw_suju_ins.GetRow()
If iRow <=0 Then Return 2

s_order_date = dw_suju_ins.GetItemString(iRow,'order_date')

s_itnbr      = dw_insert.GetItemString(nRow,'itnbr')
s_ispec      = dw_insert.GetItemString(nRow,'itemas_ispec')
sOrderSpec 	 = dw_insert.GetItemString(nRow,"order_spec")

s_curr		  = dw_suju_ins.GetItemString(1,"curr")

If s_curr = 'WON' Then
   s_pricegbn  = '1'  //원화
Else
	s_pricegbn  = '2'  //외화
End If

/* 무상출고일 경우 단가 0 */
sSalegu = dw_insert.GetItemString(nRow, 'amtgu')
If sSaleGu = 'N' Then
	order_prc  = 0
	order_rate = 0
	Return 1
End If

If IsNull(s_order_date) Or s_order_date = '' Then
   f_message_chk(40,'[수주일자]')
   Return -1
End If

If IsNull(s_itnbr) Or s_itnbr = '' Then
   f_message_chk(40,'[품번]')
   Return -1
End If

If gbn = '1' Then
	/* 단가 입력시 할인율 계산 */
   rtn = sqlca.fun_erp100000014(s_itnbr, sOrderSpec , order_prc,s_order_date,s_curr,s_pricegbn,order_rate)
   If rtn = -1 Then order_rate = 0
Else
	/* 할인율 입력시 단가계산 */
   rtn = sqlca.fun_erp100000015(s_itnbr, sOrderSpec ,s_order_date,s_curr,s_pricegbn,order_rate,order_prc)
   If rtn = -1 Then 	order_prc = 0
	
	/* 단가 : 절삭 */
	order_prc = Truncate(order_prc,0)
End If

/* 할증된 경우 할인율은 0 (ETC품목 적용)*/
If order_rate < 0 Then order_rate = 0

return 1
end function

on w_sal_02000.create
int iCurrent
call super::create
this.rb_insert=create rb_insert
this.rb_modify=create rb_modify
this.p_3=create p_3
this.p_2=create p_2
this.p_4=create p_4
this.p_pan=create p_pan
this.p_6=create p_6
this.dw_suju_ins=create dw_suju_ins
this.dw_yusin=create dw_yusin
this.p_1=create p_1
this.pb_1=create pb_1
this.dw_head=create dw_head
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_insert
this.Control[iCurrent+2]=this.rb_modify
this.Control[iCurrent+3]=this.p_3
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.p_4
this.Control[iCurrent+6]=this.p_pan
this.Control[iCurrent+7]=this.p_6
this.Control[iCurrent+8]=this.dw_suju_ins
this.Control[iCurrent+9]=this.dw_yusin
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.dw_head
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
this.Control[iCurrent+16]=this.rr_4
end on

on w_sal_02000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_insert)
destroy(this.rb_modify)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_4)
destroy(this.p_pan)
destroy(this.p_6)
destroy(this.dw_suju_ins)
destroy(this.dw_yusin)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.dw_head)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;string sYn,sDepotNo
String ls_filter

dw_suju_ins.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_yusin.SetTransObject(SQLCA)
dw_head.SetTransObject(SQLCA)

//수주 테이블의 출고구분에 대한 셋팅

//정상 order
is_jeongsang = '1'
//추가 order
is_chuga = '2'
//취소 order
is_cancel = '3'

//p_1.Visible = True

//20181029 한텍 요청 사항 사업장 강제로 장안으로 디폴트값 지정요청 HYKANG 20181029
gs_saupj = '20'

//f_mod_saupj(dw_suju_ins, 'saupj')
dw_suju_ins.SetItem(1, 'saupj', gs_saupj)

f_child_saupj(dw_insert, 'house_no', gs_saupj)
f_child_saupj(dw_insert, 'depot_no', gs_saupj)
f_child_saupj(dw_suju_ins, 'emp_id', gs_saupj)

/*여신체크 시점*/
sSyscnfg_Yusin = f_get_syscnfg('S',2,'10')
If 	IsNull(sSyscnfg_Yusin) Or sSyscnfg_Yusin = '' Then sSyscnfg_Yusin = '4'

/* 사전원가 조회버튼 활성화 여부 */
sYn = f_get_syscnfg('S',7,'10')
//If sYn = 'Y' Then
//	p_search.Visible = True
////	gb_4.width = 1673
//Else
//	p_search.Visible = False
////	gb_4.width = 1225
//End If
//
/* 품목입력시 커서위치 여부 - '1' : 품번, '2' : 품명 */
select substr(dataname,1,1) into :sCursor
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 12;

//그룹웨어 연동구분
Select dataname into :is_gwgbn
  from syscnfg
 where sysgu = 'W' and
       serial = 1 and
		 lineno = '4';

/*수주승인 자동여부*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)
  INTO :isautoaccept  
  FROM "SYSCNFG"  
 WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 1) AND ("SYSCNFG"."LINENO" = '10' );

IF SQLCA.SQLCODE <> 0 THEN
	isautoaccept = 'N'
ELSE
	IF isautoaccept = "" OR IsNull(isautoaccept) THEN isautoaccept = 'N'
END IF

/*할당자동여부*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)
  INTO :isAutoHaldang  
  FROM "SYSCNFG"  
 WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 1) AND ("SYSCNFG"."LINENO" = '20' );

IF SQLCA.SQLCODE <> 0 THEN
	isAutoHaldang = 'N'
ELSE
	IF isAutoHaldang = "" OR IsNull(isAutoHaldang) THEN isAutoHaldang = 'N'
END IF

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)

///* 기본창고 조회 */
//sDepotNo = wf_DepotNo('1')
//
///* 직납처리 */
dw_suju_ins.SetItem(1,"dirgb", 'D')
dw_suju_ins.SetItem(1,"emp_id",gs_empno)
dw_suju_ins.SetItem(1,"deptno",gs_dept)

select fun_get_cvnas(:gs_dept) Into :sDepotNo From dual ;

dw_suju_ins.SetItem(1,"deptname",sDepotNo)

end event

event key;Choose Case key
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyA!
		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyE!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_sal_02000
event ue_buttonclicked pbm_lbuttondown
integer x = 27
integer y = 632
integer width = 4571
integer height = 1632
integer taborder = 30
string dataobject = "d_sal_020002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_buttonclicked;/* -------------------------------------------------------- */
/* Clicked된 row,column 가져오기                            */
/* -------------------------------------------------------- */
string  ls_col,ls_colnm
int	  row,li_pos
Double  dItemQty, dInvQty

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
/* -------------------------------------------------------- */
string sItnbr,sSuju_sts

SetRow(row)

Choose Case ls_colnm
	Case 'special_yn'
		/* 완료,마감은 skip */
		sSuju_sts = GetItemString(row,'suju_sts')
		If sSuju_sts = '4' Or sSuju_sts = '8' Or sSuju_sts = '9' Then	Return

		/* 출고된건이 있으면 변경불가 */
		dInvQty = GetItemNumber(row, 'invoice_qty')
		If IsNull(dInvQty) Then dInvQty = 0
		
		If dInvQty > 0 Then Return
	
		If GetItemString(row,ls_colnm) = 'Y' then 
	     /* 판매단가및 할인율 */
		  sItnbr = Trim(GetItemString(row,'itnbr'))
		  If IsNull(sItnbr) Or sItnbr = '' Then Return
		  
			dItemQty = GetItemNumber(row,'order_qty')
			wf_calc_danga(row, sItnbr, dItemQty)
			
			SetItem(row,ls_colnm,'N')
			SetColumn('order_qty')
		Else
			SetItem(row,ls_colnm,'Y')
			SetColumn('order_prc')
		End If	
	Case 'special_spec'
		/* 완료,마감은 skip */
		sSuju_sts = GetItemString(row,'suju_sts')
		If sSuju_sts = '4' Or sSuju_sts = '8' Or sSuju_sts = '9' Then			Return
		
		If GetItemString(row,ls_colnm) = 'Y' then 
			SetItem(row,ls_colnm,'N')
		Else
			SetItem(row,ls_colnm,'Y')
		End If
		
      SetColumn('order_qty')
End Choose
end event

event dw_insert::itemerror;Return 1
end event

event dw_insert::itemchanged;String  sItnbr,sItDsc,sIspec,sItnbrUnit,sOrderDate,sSpecialYn,sItnbrGbn,sOrderSpec,&
		    sSuJuDate, snull, sOfNo, ls_bunbr
Double  dItemQty,dDcRate,dValidQty,dNewDcRate, dJisiQty, dItemPrice
Double  dItemWonPrc, dProcessQty, dItemOldQty, dHoldQty, dCancelQty,dOldCancelQty
Long    nRow,iRtnValue,iRowCount, ix, nNapQty
String  sOverSea,sDepotNo, lsItnbrYn, sSujuSts, sOrderNo, sRtn, sJijil, sOutgu, sJepumIo,sSalegu, sIspecCode, sPangb, sItmShtNm
Dec     dOfseq, dNull, dPackQty, dItmx, dItmy, dSeqno
String  sSaupj, sCvcod, sBunbr

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(dNull)

//if 	dw_INSERT.accepttext() = -1 then return 
dw_suju_ins.AcceptText()

nRow   = this.GETROW()
If nRow <= 0 Then Return

/* 수주상태 check */
dProcessQty = wf_suju_status(nRow)

Choose Case GetColumnName() 
	Case	"itnbr" 
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			If dProcessQty = 0 Or dProcessQty = -2 Then /* 접수,보류 */
				Wf_Clear_Item(nRow)
				Return
			End If
		END IF
		
		sSaupj = dw_suju_ins.getitemstring(1,'saupj')
		
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."UNMSR",
				 "ITEMAS"."ITTYP", "ITEMAS"."JIJIL", "ITEMAS"."ISPEC_CODE",
				 "ITEMAS"."PANGBN","ITEMAS"."PACKQTY", "ITEMAS"."ITM_WIDTH", "ITEMAS"."ITM_HEIGHT", "ITMSHT"."ITM_SHTNM"
		  INTO :sItDsc,   		 :sIspec, 		     :sItnbrUnit, 
				 :sItnbrGbn,		 :sJijil, 			  :sIspecCode,
				 :sPangb,			 :dPackQty,         :dItmx, :dItmy, :sItmShtNm
		  FROM "ITEMAS", "ITMSHT"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' AND	"ITEMAS"."GBWAN" = 'Y' 
		   AND "ITEMAS"."ITNBR" = "ITMSHT"."ITNBR"(+)
			AND :sSaupj          = "ITMSHT"."SAUPJ"(+);

		IF SQLCA.SQLCODE <> 0 THEN
			SetItem(nRow,"itnbr",   sNull)
			this.TriggerEvent(RbuttonDown!)
			Return 2
		END IF

		/* 입력가능여부 */
		SELECT DECODE(RFNA2,'N',RFNA2,'Y') INTO :lsItnbrYn
		  FROM REFFPF  
		 WHERE RFCOD = '05' AND     RFGUB <> '00' AND
		       RFGUB = :sItnbrGbn;
		
		If IsNull(lsItnbrYn) Then lsItnbrYn = 'Y'
//		If IsNull(lsItnbrYn) Then sItnbr = 'Y'
		
		If lsItnbrYn = 'N' Then
			f_message_chk(58,'')
			Wf_Clear_Item(nRow)
			Return 1
		End If
				
		SetItem(nRow,"itemas_itdsc",   sItDsc)
		SetItem(nRow,"itemas_ispec",   sIspec)
		SetItem(nRow,"itemas_ispec_code",   sIspecCode)
		SetItem(nRow,"itemas_jijil",   sJijil)
		SetItem(nRow,"itemas_unmsr",   sItnbrUnit)
		SetItem(nRow,"itemas_ittyp",   sItnbrGbn)
		
		SetItem(nRow,"itmx",   dItmx)
		SetItem(nRow,"itmy",   dItmy)
		SetItem(nRow,"itm_shtnm",   sItmShtNm)
		
		// 관리품번 min값을 설정
		sCvcod = dw_suju_ins.GetItemString(1, 'cust_no')
		If isNull(sCvcod) Or sCvcod = '' Then
			sCvcod = dw_suju_ins.GetItemString(1, 'cvcod')
		End IF
		
		select min(seqno) into :dseqno from itmbuy where itnbr = :sItnbr and cvcod = :sCvcod;
		select BUNBR into :sBunbr from itmbuy where itnbr = :sItnbr and cvcod = :sCvcod and seqno = :dseqno;
		SetItem(nRow, 'seqno', dSeqno)
		SetItem(nRow, 'bunbr', sBunbr)
		
		/* 판매구분이 Null이면 참조코드 '5B'를 검색하여 Random값을 Move */
		if Isnull( sPangb ) or trim( sPangb ) = '' then
			Select rfcod into :sPangb from reffpf where rfcod = '5B' and rfgub != '00' and rownum = 1;
			SetItem(nRow,"pangb", 			 sPangb)			
		Else
			SetItem(nRow,"pangb", 			 sPangb)
		End if
		
		/* 판매단가및 할인율 */
		dItemQty  = GetItemNumber(nRow,'order_qty')
		iRtnValue = wf_calc_danga(nRow, sItnbr, dItemQty)
		If iRtnValue =  1 Then Return 1
//		THIS.SetItem(nRow,"order_prc", iRtnValue)
		
		/* 창고 */
		sOverSea = Trim(dw_insert.GetItemString(nRow,"itemas_ittyp"))
		sDepotNo = wf_DepotNo(sOverSea)
		dw_insert.SetItem(nRow,"depot_no", sDepotNo)
		dw_insert.SetItem(nRow,"house_no", sDepotNo)
		
		/* 가용재고 */
		sOrderSpec = Trim(dw_insert.GetItemString(nRow,"order_spec"))
		dValidQty = wf_valid_qty(sDepotNo, sItnbr, sOrderSpec)
		dw_insert.SetItem(nRow,'sum_validqty',dValidQty)
		
		/* 예상납기일자 */
		dItemQty = GetItemNumber(nRow,'order_qty')
		iRtnValue = wf_calc_napgi(nRow,dItemQty)
		If iRtnValue <> 0 Then Return 1
		
		sle_msg.Text = '포장단위 수량 : ' + String(dPackQty)
		
		//SetColumn('order_qty')
	/* 품명 */
	Case "itemas_itdsc"
		sItDsc = trim(GetText())	
		IF sItDsc = ""	or	IsNull(sItDsc)	THEN
			If dProcessQty = 0 Or dProcessQty = -2 Then /* 접수,보류 */
				Wf_Clear_Item(nRow)
				If sCursor = '2' Then dw_insert.SetColumn('itemas_itdsc') else dw_insert.SetColumn('itnbr')
				Return
			End If
		END IF

		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If
		
		SetColumn('order_qty')
	/* 규격 */
	Case "itemas_ispec"
		sIspec = trim(GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			If dProcessQty = 0 Or dProcessQty = -2 Then /* 접수,보류 */
				Wf_Clear_Item(nRow)
				SetColumn("itemas_ispec")
				Return
			End If
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			SetColumn("itemas_ispec")
			Return 1
		End If
		
		SetColumn('order_qty')
	/* 규격코드 */
	Case "itemas_ispec_code"
		sIspeccode = trim(GetText())	
		IF sIspeccode = ""	or	IsNull(sIspeccode)	THEN
			If dProcessQty = 0 Or dProcessQty = -2 Then /* 접수,보류 */
				Wf_Clear_Item(nRow)
				SetColumn("itemas_ispec_code")
				Return
			End If
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			SetColumn("itemas_ispec_code")
			Return 1
		End If
		
		SetColumn('order_qty')

	/* 재질 */
	Case "itemas_jijil"
		sJijil = trim(GetText())	
		IF sJijil = ""	or	IsNull(sJijil)	THEN
			If dProcessQty = 0 Or dProcessQty = -2 Then /* 접수,보류 */
				Wf_Clear_Item(nRow)
				SetColumn("itemas_jijil")
				Return
			End If
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			SetColumn("itemas_jijil")
			Return 1
		End If
		
		SetColumn('order_qty')
	/* 사양 */
	Case 'order_spec'
		sOrderSpec = Trim(GetText())
		
		sDepotNo = Trim(dw_insert.GetItemString(nRow,"depot_no"))
		sItnbr    = Trim(dw_insert.GetItemString(nRow,"itnbr"))
		
		IF sOrderSpec = "" OR IsNull(sOrderSpec) THEN	
			dValidQty = wf_valid_qty(sDepotNo,sItnbr,'.')
			SetItem(nRow,'sum_validqty',dValidQty)
			SetItem(nRow,"order_spec",'.')
			Return 2
		End If
	
		/* 판매단가및 할인율 */
		dItemQty  = GetItemNumber(nRow,'order_qty')
		iRtnValue = wf_calc_danga(nRow, sItnbr, dItemQty)
		If iRtnValue =  1 Then Return 1
		
		/* 가용재고 */
		dValidQty = wf_valid_qty(sDepotNo,sItnbr,sOrderSpec)
		SetItem(nRow,'sum_validqty',dValidQty)
	/* 수량 */
	Case "order_qty"
		dItemQty    = Double(GetText())
		dItemOldQty = GetItemNumber(nRow,'order_qty')
		IF dItemQty = 0 OR IsNull(dItemQty) THEN 
			f_message_chk(93,'~r~n~r~n[취소작업은 수주승인화면에서 가능합니다]~r~n')
			SetItem(nRow,'order_qty',dItemOldQty)
			SetFocus()
			Return 1
		End If

		/* 납품배수 */
		nNapQty = dw_suju_ins.GetItemNumber(1,'napqty')
		If IsNull(nNapqty) Or nNapQty = 0 Then
		Else
			If Mod(dItemQty, nNapQty) <> 0 Then
				MessageBox('확 인','수량은 납품배수 범위내에서 가능합니다.!!')
				Return 2
			End If
		End If
				
		sSujuSts = GetItemString(nRow,'suju_sts')
		Choose Case sSujuSts
			Case '2','5','6','7'
				If dItemQty > GetItemNumber(nRow,'order_qty',Primary!,True) Then
					MessageBox('확 인',"승인된 품목은 수량을 상향조정하실 수 없습니다.")
					SetItem(nRow,'order_qty',dItemOldQty)
					SetFocus()
					Return 1
				End If

				/* 진행중일 경우 수량변경 : 할당+지시수량보다 커야함 */
				If dProcessQty > dItemQty Then 
					MessageBox('확 인',"기할당수량 및 작업지시수량보다 커야합니다.~n~n[진행중인 수량 : " +string(dProcessQty,'#,##0') + "]")
					SetItem(nRow,'order_qty',dItemOldQty)
					SetFocus()
					Return 1
				End If
				
				/* 수주수량이 지시수량보다 작을 경우 password를 입력받는다 */
				dJisiQty = GetItemNumber(nRow, 'jisi_qty')
				If dJisiQty > dItemQty Then
					MessageBox('확 인',"기할당수량 및 작업지시수량보다 커야합니다.~n~n[진행중인 수량 : " +string(dProcessQty,'#,##0') + "]")
					SetItem(nRow,'order_qty',dItemOldQty)
					SetFocus()
					Return 1
				End If
		End Choose
		
		/*'완제품'일 경우 예상납기일자를 구한다 */
		wf_calc_napgi(nRow,dItemQty)

		/* 수량base 판매단가및 할인율율 구한다 */
		sItnbr = GetItemString(nRow,'itnbr')
		
		/* 판매단가및 할인율 */
		iRtnValue = wf_calc_danga(nRow, sItnbr, dItemQty)
		If iRtnValue =  1 Then Return 1

		// 금액 재계산
		//SetItem(nRow,"itmamt",TrunCate(dItemQty * GetItemNumber(nRow,'itmprc'),2))
		
		wf_set_minqty(nRow)
	/* 단가 - 원화단가 */
	Case "order_prc"
		dItemPrice = Double(GetText())
		If IsNull(dItemPrice) Then dItemPrice = 0

		/* 단가 절삭 */
		dItemPrice = truncate(dItemPrice,0)
		
		/* 특출 할인율 계산 */
		dNewDcRate = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'1') <> 1 Then Return 2
		SetItem(nRow,"dc_rate",dNewDcRate)
		
		/* 금액 계산 */
		dItemQty = GetItemNumber(nRow,"order_qty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		SetItem(nRow,"pricegbn",'9')
		SetItem(nRow,"order_amt",TrunCate(dItemQty * dItemPrice,0))
		
		/* 단가 임의 수정시 */
		SetItem(nRow,"order_prc", dItemPrice)
		return 2
	/* 단가 - 외화단가 */
	Case "itmprc"
		dItemPrice = double(GetText())
		If IsNull(dItemPrice) Then dItemPrice = 0

		/* 단가 절삭 */
//		dItemPrice = round(dItemPrice,5)
		
		/* 특출 할인율 계산 */
		dNewDcRate = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'1') <> 1 Then Return 2
		SetItem(nRow,"dc_rate",dNewDcRate)
		
		/* 금액 계산 */
		dItemQty = GetItemNumber(nRow,"order_qty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		SetItem(nRow,"pricegbn",'9')
		SetItem(nRow,"itmamt",truncate(round(dItemQty,3) * round(dItemPrice,5),2))
		
		/* 단가 임의 수정시 */
		SetItem(nRow,"itmprc", round(dItemPrice,5))
		return 2
	/* 할인율 */
	Case "dc_rate"
		dNewDcRate = Double(GetText())
		If IsNull(dNewDcRate) Then dNewDcRate = 0
		
		/* 특출 할인율 계산 */
		dItemPrice = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'2') <> 1 Then Return 2
		SetItem(nRow,"order_prc",dItemPrice)
		
		/* 금액 계산 */
		dItemQty = GetItemNumber(nRow,"order_qty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		/* 할인율 임의 수정시 */
		SetItem(nRow,"pricegbn",'9')
		SetItem(nRow,"order_amt",TrunCate(dItemQty * dItemPrice,0))
	/* 요구납기 */
	Case "cust_napgi"
		sOrderDate = Trim(GetText())
		IF sOrderDate = "" OR IsNull(sOrderDate) THEN Return
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[요구납기]')
			SetItem(nRow,"cust_napgi",snull)
			Return 1
		END IF
	/* 절대수 */
	Case 'maxqty'
		dItemQty = Double(GetText())
		If IsNull(dItemQty) Or dItemQty > 100 Or dItemQty < 0 Then Return 2
		
		wf_set_minqty(nRow)
	/* 수불구분 */
	Case 'out_gu'
		sOutgu = GetText()
		
		SELECT JEPUMIO, SALEGU INTO :sJepumIo, :sSalegu FROM IOMATRIX
		 WHERE SABU = :gs_sabu AND
		       IOGBN = :sOutgu;
		
		If sJepumIo <> 'Y' Then
			MessageBox('확 인','수주관련구분만 가능합니다.!!')
			Return 2
		End If
		
		SetItem(nRow, 'amtgu', sSalegu)
		
		sItnbr    = Trim(dw_insert.GetItemString(nRow,"itnbr"))
		If Not IsNull(sItnbr) Then	
			/* 판매단가및 할인율 */
			dItemQty  = GetItemNumber(nRow,'order_qty')
			iRtnValue = wf_calc_danga(nRow, sItnbr, dItemQty)
			If iRtnValue =  1 Then Return 1
		End If
	/* 견적번호 */
	Case "ofno"
		sOfNo = Trim(GetText())
		IF sOfNo = "" OR IsNull(sOfNo) THEN 
			SetItem(nRow, "ofseq", dNull)
			RETURN
		End If
		
		dOfSeq = GetItemNumber(1, 'ofseq')
		If Not IsNull(dOfSeq) Then
			sItnbr = wf_copy_offer(sOfno, dOfSeq)
			If sItnbr = 'ERROR' Then
				SetItem(nRow, "ofno",  sNull)
				SetItem(nRow, "ofseq", dNull)
				Return 1
			Else
				SetColumn("itnbr")
				SetItem(nRow,"itnbr",  sItnbr)
				PostEvent(ItemChanged!)
			End If 
		End If
	/* 견적순번 */
	Case "ofseq"
		dOfSeq = Long(GetText())
		IF IsNull(dOfSeq) THEN RETURN
			
		sOfNo = GetItemString(1, 'ofno')
		If Not IsNull(sOfNo) Then
			sItnbr = wf_copy_offer(sOfno, dOfSeq)
			If sItnbr = 'ERROR' Then
				SetItem(nRow, "ofno",  sNull)
				SetItem(nRow, "ofseq", dNull)
				Return 1
			Else
				SetColumn("itnbr")
				SetItem(nRow,"itnbr",  sItnbr)
				PostEvent(ItemChanged!)
			End If 
		End If
	/* 판매구분 : '2'일 경우 특출 */
	Case 'pangb'
		If GetText() = '1' Then
			SetItem(nRow, 'special_yn', 'Y')
			Return
		End If
	Case 'seqno'
		// 관리품번 
		sCvcod = dw_suju_ins.GetItemString(1, 'cust_no')
		If isNull(sCvcod) Or sCvcod = '' Then
			sCvcod = dw_suju_ins.GetItemString(1, 'cvcod')
		End IF

		sItnbr = Trim(dw_insert.GetItemString(nRow,"itnbr"))
		select BUNBR into :sBunbr from itmbuy where itnbr = :sItnbr and cvcod = :sCvcod and seqno = :dseqno;
		SetItem(nRow, 'bunbr', sBunbr)		
END Choose

ib_any_typing = True
end event

event dw_insert::rbuttondown;Long nRow , i , ll_i = 0
String sItnbr, sNull, sCustno

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

str_code lst_code

sle_msg.text = ''
/* 수주상태 check */
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
	
		dw_suju_ins.AcceptText()
		gs_code = Trim(dw_suju_ins.Object.cvcod[1])
		gs_codename =Trim(dw_suju_ins.Object.cvnas[1])
		
		If isNull(gs_code) or gs_code = '' Then 
			Messagebox('확인','거래처를 선택하세요.')
			Return
		End iF
		
		Open(w_sal_02000_vnddan)
		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
		For i = nRow To UpperBound(lst_code.code) + nRow - 1
			ll_i++
			
			if i > nRow then p_ins.triggerevent("clicked")
			
			this.SetItem(i, "cvcod", gs_Code)
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next
	
	Case "itemas_itdsc"
		gs_gubun = '1'
		gs_codename = GetText()
		dw_suju_ins.AcceptText()
		sCustno = Trim(dw_suju_ins.GetItemString(1, 'cust_no'))
		If isNull(sCustno) Or sCustno = '' Then
			gs_codename2 = dw_suju_ins.GetItemString(1, 'cvcod')
		Else
			gs_codename2 = sCustno
		End If
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "itemas_ispec", "itemas_jijil"
		gs_gubun = '1'
		dw_suju_ins.AcceptText()
		sCustno = Trim(dw_suju_ins.GetItemString(1, 'cust_no'))
		If isNull(sCustno) Or sCustno = '' Then
			gs_codename2 = dw_suju_ins.GetItemString(1, 'cvcod')
		Else
			gs_codename2 = sCustno
		End If
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	/* 관리품번 순번 */
	Case "seqno"
		gs_code = getitemstring(nRow, 'itnbr')
		gs_codename = getitemstring(nRow, 'cvcod')
		
		Open(w_itmbuy_popup)
	
		IF isnull(gs_Code)  or  gs_Code = ''	then		return
		SetItem(nRow, "seqno", integer(gs_Code))
	/* 견적번호 */
	Case "ofno","ofseq"
		gs_gubun = '1'	/* 견적만 조회 */
		gs_code = '2'	/* 견적계산 완료된 자료 */
		Open(w_sal_01710)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		sItnbr = wf_copy_offer(gs_code, Long(gs_codename))
		If sItnbr = 'ERROR' Then
			SetItem(nRow, "ofno",  sNull)
			SetItem(nRow, "ofseq",  sNull)
			Return 1
		Else
			SetItem(nRow, "ofno",  gs_code)
			SetItem(nRow, "ofseq", Long(gs_codename))
			SetColumn("itnbr")
			SetItem(nRow,"itnbr",  sItnbr)
			PostEvent(ItemChanged!)
		End If 
END Choose
end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull
Integer nRow

setnull(gs_code)
setnull(snull)

nRow = this.GetRow()

IF 	keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(nRow,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
ELSEIF keydown(keyF3!) THEN
	IF This.GetColumnName() = "itnbr" Then
		gs_codename = dw_suju_ins.GetItemString(1,"cvcod")
		open(w_itmbuy2_popup)
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(nRow,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::editchanged;sle_msg.text = ''
end event

event dw_insert::ue_pressenter;String sItnbr
double dOrdQty

if getcolumnname() = "cust_napgi"   then
	if rowcount() = getrow() then
		dOrdQty = GetItemNumber(GetRow(),'order_qty')
		If Not IsNull(dOrdQty) and dOrdQty > 0  Then
			p_ins.postevent(clicked!)
			return 1
		End if
	end if
end if

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::rowfocuschanging;Long nRtn

nRtn = wf_suju_status(newrow)
If nRtn = -1 Or nRtn > 0 Then  /* 완료,마감, 진행 -> 삭제불가  */
   cb_del.Enabled = False
Else
	If nRtn <> 0 and rb_modify.Checked = True Then /* 수정모드일경우 삭제불가 => 취소작업으로 */
		cb_del.Enabled = False
	Else
		cb_del.Enabled = True
	End If
End If

end event

event dw_insert::itemfocuschanged;// itemchanged 에서 모품번으로 입력시 자품번을 셋팅
if not isnull(is_mitnbr) and trim(is_mitnbr) <> '' then
	this.accepttext()
	this.setitem(row,'itnbr',is_mitnbr)
	is_mitnbr = ''
end if

Choose Case GetColumnName()
	Case 'itemas_itdsc','itemas_ispec'
		f_toggle_eng(handle(this))
	Case 'order_memo'
		f_toggle_kor(handle(this))	
End Choose


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

event dw_insert::buttonclicked;

////기술내역 대신 생산조건 입력으로 변경
//string sOrderNo, sItnbr, sItdsc
//int    nRow,ix
//
//If dw_suju_ins.AcceptText() <> 1 Then Return
//
//nRow = dw_insert.GetRow()
//If nRow <= 0 Then Return
//
//sOrderNo = Trim(dw_insert.GetItemString(Row, 'order_no'))
//If IsNull(sOrderNo) Or sOrderNo = '' Then
//   f_message_chk(1400,'[자료저장후 등록하실 수 있습니다]')
//   Return 1
//End If
//
//sItnbr = Trim(dw_insert.GetItemString(Row, 'itnbr'))
//If IsNull(sItnbr) Or sItnbr = '' Then
//   f_message_chk(40,'[품번]')
//   Return 1
//End If
//
//sItdsc = Trim(dw_insert.GetItemString(Row, 'itemas_itdsc'))
// 
//gs_code  = sItnbr
//gs_codename  = sItdsc
//gs_gubun = sOrderNo
//
//Open(w_sal_02000_4)
//

end event

type p_delrow from w_inherite`p_delrow within w_sal_02000
boolean visible = false
integer x = 2889
integer y = 2700
integer taborder = 90
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_02000
boolean visible = false
integer x = 2715
integer y = 2700
integer taborder = 50
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_02000
integer x = 3401
integer taborder = 210
boolean originalsize = true
string picturename = "C:\erpman\image\상세입력_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세입력_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세입력_up.gif"
end event

event p_search::clicked;call super::clicked;if dw_suju_ins.getrow() > 0 then
	OpenWithParm(w_sal_02000_5, dw_head)
	If IsNull(gs_code) Or gs_code = '' then Return
end if
end event

type p_ins from w_inherite`p_ins within w_sal_02000
integer x = 3749
integer taborder = 40
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event p_ins::clicked;call super::clicked;Long   il_currow,nRtn, nSeq, nRow
string sDepotNo,sOrderNo, sItnbr

IF dw_insert.AcceptText() = -1 THEN RETURN

If Wf_RequiredChk(dw_suju_ins.DataObject,1) = -1 Then Return

il_currow = dw_insert.RowCount()
IF il_currow <=0 THEN

	nRtn = 1
	
	dw_suju_ins.Modify('cvcod.protect = 1')
	dw_suju_ins.Modify('cvnas.protect = 1')
	dw_suju_ins.Modify('order_date.protect = 1')
//	dw_suju_ins.Modify('depot_no.protect = 1')
	dw_suju_ins.Modify('sugugb.protect = 1')
	dw_suju_ins.Modify('dirgb.protect = 1')
	dw_suju_ins.Modify('house_no.protect = 1')
	dw_suju_ins.Modify('saupj.protect = 1')
	dw_suju_ins.Modify('oversea_gu.protect = 1')
	dw_suju_ins.Modify('curr.protect = 1')
ELSE
	nRtn = wf_requiredchk(dw_insert.DataObject,dw_insert.GetRow())
END IF

/*수주번호 채번*/
IF sModStatus = 'M' THEN
	sOrderNo = Mid(dw_suju_ins.GetItemString(1,"order_no"),1,11)

  IF sOrderNo = "" OR IsNull(sOrderNo) THEN
	  f_message_chk(51,'[수주번호]')
	  rollback;
	  Return
  End If
Else
	sOrderNo = ''
END IF

/* 수주번호 최대값 */
If dw_insert.Rowcount() > 0 Then
  nSeq = Long(dw_insert.GetItemString(1,'maxseq'))
  If IsNull(nSeq) or nSeq < 0 Then nSeq = 0 
End If

IF nRtn = 1 THEN
	il_currow = il_currow + 1
	
	/* 기획출고일경우 */
	dw_insert.InsertRow(il_currow)
	dw_insert.SetItem(il_currow,"sabu", gs_sabu)
	dw_insert.SetItem(il_currow,"cust_napgi",dw_suju_ins.GetItemString(1,"order_date"))
	dw_insert.SetItem(il_currow,"cvcod",     dw_suju_ins.GetItemString(1,"cvcod"))
	
	IF sModStatus = 'M' THEN
		nSeq += 1
		
		dw_insert.SetItem(il_currow,"order_date",dw_suju_ins.GetItemString(1,"order_date"))
		dw_insert.SetItem(il_currow,"order_no",sOrderNo+String(nSeq,'000'))
		dw_insert.SetItem(il_currow,"suju_sts", '1')
	End If
	
	dw_insert.ScrollToRow(il_currow)
	
	If sCursor = '2' Then dw_insert.SetColumn('itemas_itdsc') else dw_insert.SetColumn('itnbr')
	
	dw_insert.SetFocus()
	dw_insert.SetItemStatus(il_currow,0, Primary!, NotModified!)
	dw_insert.SetItemStatus(il_currow,0, Primary!, New!)
	
	p_mod.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
END IF
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

type p_exit from w_inherite`p_exit within w_sal_02000
integer taborder = 190
end type

type p_can from w_inherite`p_can within w_sal_02000
integer taborder = 170
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_sal_02000
boolean visible = false
integer x = 3168
integer y = 2440
integer taborder = 220
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\생산조건_up.gif"
end type

event p_print::clicked;call super::clicked;string sOrderNo, sItnbr, sItdsc
int    nRow,ix

If dw_suju_ins.AcceptText() <> 1 Then Return

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

sOrderNo = Trim(dw_insert.GetItemString(nRow, 'order_no'))
If IsNull(sOrderNo) Or sOrderNo = '' Then
   f_message_chk(1400,'[자료저장후 등록하실 수 있습니다]')
   Return 1
End If

sItnbr = Trim(dw_insert.GetItemString(nRow, 'itnbr'))
If IsNull(sItnbr) Or sItnbr = '' Then
   f_message_chk(40,'[품번]')
   Return 1
End If

sItdsc = Trim(dw_insert.GetItemString(nRow, 'itemas_itdsc'))
 
gs_code  = sItnbr
gs_codename  = sItdsc
gs_gubun = sOrderNo

Open(w_sal_02000_4)
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\발주처품목선택_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\발주처품목선택_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_02000
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String  sOrderNo,	sOrderDate,sNewOrderDate, sOverSeaGu
Double  dHoldQty,dJisiQty
Long    iPurCnt, nLen

If dw_suju_ins.AcceptText() <> 1 Then Return

sOrderNo = dw_suju_ins.GetItemString(1,"order_no")
IF sOrderNo ="" OR IsNull(sOrderNo) THEN
	f_message_chk(30,'[수주번호]')
	dw_suju_ins.SetColumn("order_no")
	dw_suju_ins.SetFocus()
	Return 
END IF

nLen = Len(sOrderNo)
				 
SetPointer(HourGlass!)
If dw_suju_ins.Retrieve(gs_sabu,sOrderNo, nLen) <=0 Then
	wf_init()
	Return
End If

If dw_head.Retrieve(gs_sabu,Left(sOrderNo,11)) <= 0 Then
	dw_head.InsertRow(0)
	dw_head.SetItem(1, 'sabu', gs_sabu)
	dw_head.SetItem(1, 'pino', Left(sOrderNo,11))
End If

wf_calc_yusin(dw_suju_ins.GetItemString(1,"cvcod"))          // 여신조회
commit;

IF dw_insert.Retrieve(gs_sabu,sOrderNo, nLen, idMeter) > 0 THEN
	/* 내수,수출 order */
	sOverSeaGu = Trim(dw_insert.GetItemString(1,"oversea_gu"))
	If sOverSeaGu <> '1' AND sOverSeaGu <> '3' Then
		f_message_chk(56,'~r~n~r~n[수출 ORDER는 수주등록에서 수정하실수 없습니다]')
		wf_init()
		Return
	End If
	
	/* 품목추가 여부 : 승인건이 있으면 추가 불가 */
	If dw_insert.GetItemNumber(1,'sujucnt') > 0 Then
		p_ins.Enabled = False
		p_ins.PictureName = "C:\erpman\image\행추가_d.gif"
	Else
		p_ins.Enabled = True
		p_ins.PictureName = "C:\erpman\image\행추가_up.gif"
	End If
	
	sOrderDate = dw_suju_ins.GetItemString(1,"order_date")
	
   /* 마감여부 check */
	sNewOrderDate = sqlca.Fun_Erp100000050(gs_sabu,sordergbn,sOrderDate,'1')
	IF sNewOrderDate <> sOrderDate THEN
		f_message_chk(60,'')
		p_ins.Enabled = False
		p_mod.Enabled = False
		p_del.Enabled = False
		
		p_ins.PictureName = "C:\erpman\image\행추가_d.gif"
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		p_del.PictureName = "C:\erpman\image\행삭제_d.gif"
	END IF

	dw_suju_ins.Modify('order_no.protect = 1')
	dw_suju_ins.Modify('cvcod.protect = 1')
	dw_suju_ins.Modify('cvnas.protect = 1')
	dw_suju_ins.Modify('saupj.protect = 1')
	dw_suju_ins.Modify('curr.protect = 1')
	
	dw_insert.ScrollToRow(1)
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	ib_any_typing = false
ELSE
	f_message_chk(50,'')
	dw_suju_ins.SetColumn("order_no")
	dw_suju_ins.SetFocus()
	Return
END IF

rb_modify.Checked = True
end event

type p_del from w_inherite`p_del within w_sal_02000
integer x = 3922
integer taborder = 150
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event p_del::clicked;call super::clicked;Long   nRow, nRtn
String sOrderNo, SITNBR, ls_blynd, SORD_NO, sSujuSts, sSkip='N', sOrdNo, sMsg
dwItemStatus l_status
Dec    dIsQty

nRow = dw_insert.GetRow()
IF nRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

sOrderNo = dw_insert.GetItemString(nRow, 'order_no')
sITNBR   = dw_insert.GetItemString(nRow, 'ITNBR')
sSujuSts = Trim(dw_insert.GetItemString(nRow,"suju_sts"))

/* 출고여부 확인 */
Long   ll_qty
SELECT SUM(NVL(IOQTY, 0))
  INTO :ll_qty
  FROM IMHIST
 WHERE SABU     = :gs_sabu
   AND ITNBR    = :sitnbr
	AND ORDER_NO = :sOrderNo ;
If ll_qty > 0 Then
	MessageBox('출고확인', '이미 출고등록된 자료입니다.~r~n출고자료 삭제 후 수주정보를 삭제 하십시오.')
	Return
End If

// 자동할당이면서 할당건수가 1건이면 삭제가능
If isAutoHaldang = 'Y' and sSujuSts = '6' Then
	sOrderNo = Trim(dw_insert.GetItemString(nRow,"order_no"))
	SELECT SUM(ISQTY) INTO :dIsQty FROM HOLDSTOCK WHERE SABU = :gs_sabu AND ORDER_NO = :sOrderNo;
	If dIsQty = 0 Then 
		sSkip = 'Y'
	End If
End If

If sSkip = 'N' Then
	nRtn = wf_suju_status(nRow)
	If nRtn = -1 Or nRtn > 0 or (nRtn <> 0 and rb_modify.Checked = True ) Then  /* 완료,마감, 진행 -> 삭제불가  */
		f_message_chk(57,'')
		dw_insert.SetRow(nRow)
		dw_insert.ScrollToRow(nRow)
		Return
	End If
End If

IF F_Msg_Delete() = -1 THEN Return

// 자동할당이면서 할당건수가 1건이면 삭제가능
If isAutoHaldang = 'Y' and sSujuSts = '6' Then
	
	SELECT SUM(ISQTY) INTO :dIsQty FROM HOLDSTOCK WHERE SABU = :gs_sabu AND ORDER_NO = :sOrderNo;
	If dIsQty = 0 Then 
		UPDATE HOLDSTOCK SET OUT_CHK = '3', CANCELQTY = HOLD_QTY WHERE SABU = :gs_sabu AND ORDER_NO = :sOrderNo;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return
		End If
	End If
End If
		
/* 자동 외주발주분 삭제 */
SORD_NO = MID(SORDERNO,1,11) + '%'
SELECT BLYND
  INTO :ls_blynd
  FROM ESTIMA
 WHERE ORDER_NO = :SORD_NO
   AND ITNBR    = :SITNBR
 USING SQLCA;
 IF SQLCA.SQLCODE = 0 AND ls_blynd = '1' THEN
	 DELETE FROM ESTIMA
		 WHERE ORDER_NO = :SORD_NO
			AND ITNBR    = :SITNBR
		 USING SQLCA;
		 
		 COMMIT USING SQLCA;
 ELSEIF SQLCA.SQLCODE = 0 AND (ls_blynd = '3' OR ls_blynd = '4') THEN
	 MESSAGEBOX("확인","이미 외주발주 및 발주취소가 되어 있는 품번 이므로 삭제 불가!", STOPSIGN!)
	 dw_insert.SetFocus()
	 Rollback Using sqlca;
	 RETURN  -1
 END IF

/* 수주 삭제 */
dw_insert.DeleteRow(nRow)

/* 수정일 경우 commit */
IF sModStatus = 'M' THEN
	If dw_insert.RowCount() > 0 Then
		p_mod.TriggerEvent(Clicked!)
		
		ib_any_typing = False
		w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'
		Return
	Else
		If dw_insert.Update() <> 1 Then
			RollBack;
			MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
			Return
		End If
		COMMIT;
		ib_any_typing = False
		w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'
		Return
	End If
//	 IF dw_insert.Update() <> 1 THEN
//		ROLLBACK;
//		Return
//	 END IF
//
//	/* 예약자료 삭제*/
//	DELETE FROM "SORDER_RSV"
//	 WHERE ( "SABU"     = :gs_sabu ) AND  
//			 ( "ORDER_NO" = :sOrderNo );
//			 
//	 COMMIT;
//	 
//	/* 자동 할당 */
//	sMsg = Wf_AutoHalDang()
//	
//	/* 미할당자료에 대해서 작지연결한다 */
//	sOrdNo = Left(sOrderNo,11)
//	SQLCA.ERP000000570(gs_sabu, sOrdNo);
//	If sqlca.sqlcode <> 0 Then
//		RollBack;
//		MessageBox('확 인','생산승인 작업을 실패하였습니다.!!')
//		Wf_Init()
//		Return
//	Else
//		COMMIT;
//	End If
END IF	
  
IF dw_insert.RowCount() <=0 THEN
	p_mod.Enabled = False	
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	Wf_Init()
ELSE
	IF nRow <> 1 THEN
		dw_insert.ScrollToRow(nRow -1)
	ELSE
		dw_insert.ScrollToRow(nRow)
	END IF
	
	wf_calc_yusin(dw_suju_ins.GetItemString(1,"cvcod"))
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
END IF

ib_any_typing = False
w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'

end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event p_del::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_mod from w_inherite`p_mod within w_sal_02000
integer x = 4096
integer taborder = 130
end type

event p_mod::clicked;call super::clicked;Long          nRtn,nCnt,nRCnt,k,nSeq, ix, nMax, ll_row
String        sOrderNo,sOrder_Flag,sOrderOkDate,sItnbr, sNull, sCvcod, sMsg, sOldFlag, Snew_spec
double        dOverAmount
String ls_gubun,ls_doccode,ls_custcd,ls_factory,ls_van_itnbr,ls_orderno, ls_oversea, ls_curr

dwItemStatus  dwSts

SetNull(sNull)
If dw_suju_ins.accepttext() <> 1 then Return
If dw_insert.accepttext()   <> 1 then Return

If f_IsChanged(dw_suju_ins) = False And f_IsChanged(dw_insert) = False then 
	w_mdi_frame.sle_msg.text ='변경된 자료가 없습니다!!'
	Return
End If

If Wf_RequiredChk(dw_suju_ins.DataObject,1) = -1 Then Return

IF F_Msg_Update() = -1 THEN Return

/* key check */
nCnt = dw_insert.RowCount()
FOR k = nCnt TO 1 Step -1
	dwSts = dw_insert.GetItemStatus(k,0,Primary!)
	If dwSts = New! Then
		dw_insert.DeleteRow(k)
		Continue
	End If

	sItnbr = Trim(dw_insert.GetItemString(k,'itnbr'))
	If sItnbr = '' Or IsNull(sItnbr) Then
		dw_insert.DeleteRow(k)
		Continue
	End If

	nRtn = Wf_RequiredChk(dw_insert.DataObject,k)
	IF nRtn = -1 THEN
		dw_insert.ScrollToRow(k)
		Return
	END IF
Next

nCnt = dw_insert.RowCount()
IF nCnt <=0 THEN 
	f_message_chk(83,'')
	Return
End If


/*수주승인여부 체크*/
sOrder_Flag = Trim(Wf_OrderLimitAmount_Check())			/*접수,진행,보류,에러*/
IF IsNull(sOrder_Flag) Or sOrder_Flag = ''  THEN
	MessageBox('확 인','수주상태가 확정되지 않았습니다')
	Return
End If

/* 등록이면서 그룹웨어연동일 경우 상태를 'A'로 설정한다 */
IF is_gwgbn = 'Y' And sModStatus = 'I' then
	sOldFlag = sOrder_Flag
	sOrder_Flag = 'A'
END IF

SetNull(sOrderOkDate)
Choose Case sOrder_Flag 
  Case '2'  /* 승인 */
	 sOrderOkDate = dw_suju_ins.GetItemString(1,"order_date")
  Case '3'  /* 보류 */
	  dOverAmount = dw_yusin.GetItemNumber(1,"currentorderamt") - dw_yusin.GetItemNumber(1,"acceptlimitamt")
    IF MessageBox("확  인","수주금액이 승인한도금액을 초과하였습니다." +"~n~n" +&
                  "신규자료는 보류상태로 저장됩니다.~n~n저장하시겠습니까?~n~n" +&
						"[초과금액 : " + String(dOverAmount,'###,##0') + "원]",Question!, YesNo!, 2) = 2 THEN RETURN
End Choose

/*수주번호 채번*/
IF sModStatus = 'I' THEN
	sOrderNo = Wf_Calculation_OrderNo(dw_suju_ins.GetItemString(1,"order_date"))
	If IsNull(sOrderNO) Then
		RollBack;
		Return
	End If
	
	dw_suju_ins.SetItem(1,"order_no",sOrderNo)
	MessageBox("확 인","채번된 수주번호는 "+sOrderNo+" 번 입니다!!")
ELSE
	sOrderNo = dw_suju_ins.GetItemString(1,"order_no")
END IF

IF sOrderNo = "" OR IsNull(sOrderNo) THEN
	rollback;
	f_message_chk(51,'[수주번호]')
	Return
End If

/* 수주번호 최대값 */
If dw_insert.Rowcount() > 0 Then
  nSeq = Long(dw_insert.GetItemString(1,'maxseq'))
  If IsNull(nSeq) or nSeq < 0 Then nSeq = 0
  
  SELECT TO_NUMBER(MAX(SUBSTR(ORDER_NO,-3,3))) INTO :nMax
    FROM SORDER_CHANGE
	WHERE SABU = :gs_sabu AND
	 		ORDER_NO LIKE :sOrderNo||'%';
	If IsNull(nMax) Then nMax = 0
	
	If nMax > nSeq Then	nSeq = nMax
End If

SetPointer(HourGlass!)
nRCnt = 0
FOR k = 1 TO dw_insert.Rowcount() 
	/* 기존 보류등 수주상태를 유지하기위해 신규만 상태를 반영한다 */
	dwSts = dw_insert.GetItemStatus(k,0,Primary!)
	If dwSts = NewModified! Then
		nSeq += 1
		If nSeq > 999 Then
			MessageBox('오류','수주번호 순번이 999번을 초과했습니다')
			RollBack;
			wf_clear_orderno()
			Return
		End If
	
    	dw_insert.SetItem(k,"sabu",       gs_sabu)
		dw_insert.SetItem(k,"suju_sts",   sOrder_Flag)
		dw_insert.SetItem(k,"ord_ok_date",sOrderOkDate)
		dw_insert.SetItem(k,"order_no",   sOrderNo+String(nSeq,'000'))
		
		dw_insert.SetItem(k,"sugugb",     trim(dw_suju_ins.GetItemString(1,"sugugb")))
		dw_insert.SetItem(k,"dirgb",      trim(dw_suju_ins.GetItemString(1,"dirgb")))
//		dw_insert.SetItem(k,"house_no",   trim(dw_suju_ins.GetItemString(1,"house_no")))
		dw_insert.SetItem(k,"saupj",     trim(dw_suju_ins.GetItemString(1,"saupj")))
//		dw_insert.SetItem(k,"depot_no",     trim(dw_suju_ins.GetItemString(1,"depot_no")))
	End If
	
	sCvcod = Trim(dw_suju_ins.GetItemString(1,"cvcod"))
	dw_insert.SetItem(k,"order_date", trim(dw_suju_ins.GetItemString(1,"order_date")))
	dw_insert.SetItem(k,"project_no", trim(dw_suju_ins.GetItemString(1,"project_no")))
	dw_insert.SetItem(k,"cvcod",      trim(dw_suju_ins.GetItemString(1,"cvcod")))
	dw_insert.SetItem(k,"cvpln",      trim(dw_suju_ins.GetItemString(1,"cvpln")))
	dw_insert.SetItem(k,"emp_id",     trim(dw_suju_ins.GetItemString(1,"emp_id")))
	
	// 자동승인인 경우 승인저장 한다
	If isautoaccept = 'Y' And dw_insert.GetItemString(k, 'suju_sts') = '1' Then
		dw_insert.SetItem(k,"suju_sts",   sOrder_Flag)
		dw_insert.SetItem(k,"ord_ok_date",sOrderOkDate)
	End If
		
	// 수입력 또는 van 자료를 구분하여 발주번호를 insert
	ls_gubun = dw_insert.getitemstring(k,'gubun')		
	If ls_gubun = 'H' Then
		dw_insert.SetItem(k,"cv_order_no",trim(dw_insert.GetItemString(k,"orderno")))
	Else	
		dw_insert.SetItem(k,"cv_order_no",trim(dw_suju_ins.GetItemString(1,"cv_order_no")))
	End if

	// Local 처리 추가 2004.07.21 LJJ
	 ls_oversea = dw_suju_ins.GetItemString(1,"oversea_gu")
	 ls_curr = dw_suju_ins.GetItemString(1,"curr")
	 
	If Not (isNull(ls_oversea) Or ls_oversea = '') Then
		dw_insert.SetItem(k,"oversea_gu", ls_oversea )
	End IF
	
	If Not(isNull(ls_curr) Or ls_curr = '') Then
		dw_insert.SetItem(k,"curr",  ls_curr )
	End IF

	dw_insert.SetItem(k,"project_no", trim(dw_suju_ins.GetItemString(1,"project_no")))
	dw_insert.SetItem(k,"deptno", trim(dw_suju_ins.GetItemString(1,"deptno")))
	dw_insert.SetItem(k,"cust_no", trim(dw_suju_ins.GetItemString(1,"cust_no")))
	
	nRCnt += 1
NEXT

// 원화금액 계산 -2004.07.22 ljj
If wf_calc_wamt() <> 1 Then REturn

If dw_head.Update() <> 1 Then
	RollBack;
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	Return
End If

If nRCnt > 0 Then
	For ix = 1 To 3
		IF dw_insert.Update() = 1 THEN Exit

		MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
		/* 오류발생(데드록)시 3번 update 시도 */
		If ix = 3 Then
			ROLLBACK;
			Return
		END IF
	Next
		
	COMMIT;
End If

/* 전자결제 상신 */

IF is_gwgbn = 'Y' And sModStatus = 'I' then
	gs_code  = "&SABU=1&ORDER_NO="+sOrderNo+"&SUJU_STS=A&RFCOD=47"		//수주번호
	gs_gubun = '0000000068'	//그룹웨어 문서번호
	SetNull(gs_codename)
	
	WINDOW LW_WINDOW
	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
	
	/* 결제상신하지 않을 경우 */
	If gs_code = 'N' or gs_code = 'C' Then		
		UPDATE SORDER
		   SET SUJU_STS = :sOldFlag
		 WHERE SABU = :gs_sabu
		   AND ORDER_NO LIKE :sOrderNo||'%'
			AND SUJU_STS = 'A';
		If sqlca.sqlcode <> 0 Then
			RollBack;
			MessageBox('확 인','결제정보 변경에 실패하였습니다.!!')
			Wf_Init()
			Return
		End If
	End If
END IF
	
/* 출고구분이 변경될 경우 할당테이블도 변경한다 */
UPDATE HOLDSTOCK A
	SET A.HOLD_GU = ( SELECT B.OUT_GU FROM SORDER B
							 WHERE B.SABU = A.SABU
								AND B.ORDER_NO = A.ORDER_NO )
 WHERE A.SABU = :gs_sabu
	AND HOLD_NO IN ( SELECT C.HOLD_NO
							 FROM HOLDSTOCK C, SORDER D
							WHERE C.SABU = D.SABU
							  AND C.ORDER_NO = D.ORDER_NO
							  AND C.ORDER_NO LIKE :sOrderNo||'%'
							  AND C.OUT_CHK = '1' 
							  AND C.HOLD_GU <> D.OUT_GU);
If sqlca.sqlcode <> 0 Then
	RollBack;
	MessageBox('확 인','출고구분변경 작업을 실패하였습니다.!!')
	Return
End If

/* 요구납기일이 변경되면 할당의 출고요청일자도 변경 - BY SHIGOON 2006.12.28 */
UPDATE HOLDSTOCK A
	SET A.RQDAT = ( SELECT B.CUST_NAPGI
	                  FROM SORDER B
						  WHERE B.SABU     = A.SABU
	                   AND B.ORDER_NO = A.ORDER_NO )
 WHERE A.SABU  =  :gs_sabu
	AND HOLD_NO IN ( SELECT C.HOLD_NO
							 FROM HOLDSTOCK C, SORDER D
							WHERE C.SABU     =    D.SABU
							  AND C.ORDER_NO =    D.ORDER_NO
							  AND C.ORDER_NO LIKE :sOrderNo||'%'
							  AND C.OUT_CHK  =    '1'
							  AND C.RQDAT    <>   D.CUST_NAPGI ) ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('확인', '요구납기일 변경작업 중 오류가 발생했습니다')
	wf_init()
	Return
End If

/* 자동 할당 */
sMsg = Wf_AutoHalDang()

/* 미할당자료에 대해서 작지연결한다 */
SQLCA.ERP000000570(gs_sabu, sOrderNo);
If sqlca.sqlcode <> 0 Then
	RollBack;
	MessageBox('확 인','생산승인 작업을 실패하였습니다.!!')
	Wf_Init()
	Return
Else
	COMMIT;
End If


Wf_Init()

If sMsg <> '' Then	MessageBox('확 인', sMsg)
end event

type cb_exit from w_inherite`cb_exit within w_sal_02000
integer x = 3077
integer y = 3124
end type

type cb_mod from w_inherite`cb_mod within w_sal_02000
integer x = 2043
integer y = 3124
integer taborder = 160
end type

type cb_ins from w_inherite`cb_ins within w_sal_02000
integer x = 357
integer y = 3124
integer taborder = 100
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02000
integer x = 2395
integer y = 3124
integer taborder = 180
end type

type cb_inq from w_inherite`cb_inq within w_sal_02000
integer x = 0
integer y = 3124
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_sal_02000
integer x = 704
integer y = 3132
integer width = 434
string text = "생산조건(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_02000
long backcolor = 32106727
end type

type cb_can from w_inherite`cb_can within w_sal_02000
integer x = 2747
integer y = 3124
integer taborder = 200
end type

type cb_search from w_inherite`cb_search within w_sal_02000
integer x = 1170
integer y = 3124
integer width = 434
integer taborder = 140
string text = "원가비교(&T)"
end type



type sle_msg from w_inherite`sle_msg within w_sal_02000
long backcolor = 32106727
end type

type gb_10 from w_inherite`gb_10 within w_sal_02000
long backcolor = 32106727
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02000
long backcolor = 32106727
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02000
long backcolor = 32106727
end type

type rb_insert from radiobutton within w_sal_02000
integer x = 50
integer y = 68
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;sModStatus = 'I'											/*등록*/

//p_1.Visible = True

Wf_Init()

end event

type rb_modify from radiobutton within w_sal_02000
integer x = 297
integer y = 68
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;
sModStatus = 'M'											/*수정*/

//p_1.Visible = False
Wf_Init()
end event

type p_3 from uo_picture within w_sal_02000
integer x = 4105
integer y = 192
integer width = 475
integer height = 100
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\거래처상세조회_up.gif"
end type

event clicked;call super::clicked;String sCust

If dw_suju_ins.AcceptText() <> 1 then Return

sCust = dw_suju_ins.GetItemString(1,"cvcod")

IF sCust = "" OR IsNull(sCust) THEN 
	f_message_chk(30,'[거래처]')
	dw_suju_ins.SetColumn("cvcod")
	dw_suju_ins.SetFocus()	
	Return
END IF

OpenWithParm(w_sal_02000_1,sCust)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\거래처상세조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\거래처상세조회_up.gif'
end event

type p_2 from uo_picture within w_sal_02000
integer x = 4105
integer y = 292
integer width = 475
integer height = 100
boolean bringtotop = true
string picturename = "C:\erpman\image\재고상세조회_up.gif"
end type

event clicked;call super::clicked;String  sItnbr,sSpec,sMsgRtn,sDepotNo,sOverSea_gu, sSujuSts
Integer iCurRow

If dw_insert.AcceptText() <> 1 Then Return

iCurRow = dw_insert.GetRow()
IF iCurRow <= 0 THEN RETURN

IF cb_del.Enabled = False THEN
	f_message_chk(56,'~r~r[진행중인 자료는 조회하실 수 없습니다.')
	Return
END IF

sSujuSts = dw_insert.GetItemString(iCurRow,"suju_sts")
If sSujuSts <> '1' and sSujuSts <> '3' Then
	f_message_chk(56,'~r~r[진행중인 자료는 조회하실 수 없습니다.')
	Return
End If

sItnbr = dw_insert.GetItemString(iCurRow,"itnbr")
sSpec  = dw_insert.GetItemString(iCurRow,"order_spec")
sOverSea_gu = dw_insert.GetItemString(iCurRow,"itemas_ittyp")

IF sItnbr = "" OR IsNull(sItnbr) THEN 
	sItnbr = ''
END IF

IF sSpec = "" OR IsNull(sSpec) THEN 
	sSpec = '.'
END IF

sDepotNo = wf_DepotNo(sOverSea_gu)
If IsNull(sDepotNo) Then sDepotNo = ' '

OpenWithParm(w_sal_02000_2,sItnbr+'|'+sSpec+'|'+sDepotNo)
sMsgRtn = Message.StringParm

IF sMsgRtn <> 'cancle' THEN
	dw_insert.SetItem(iCurRow,"itnbr",sMsgRtn)
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	
	dw_insert.TriggerEvent(ItemChanged!)
END IF

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\재고상세조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\재고상세조회_dn.gif'
end event

type p_4 from uo_picture within w_sal_02000
integer x = 4105
integer y = 392
integer width = 475
integer height = 100
boolean bringtotop = true
string picturename = "C:\erpman\image\수주진행조회_up.gif"
end type

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

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\수주진행조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\수주진행조회_dn.gif'
end event

type p_pan from uo_picture within w_sal_02000
integer x = 4105
integer y = 492
integer width = 475
integer height = 100
boolean bringtotop = true
string picturename = "C:\erpman\image\판매이력조회_up.gif"
end type

event clicked;String  sOrderNo
Integer iSelectedRow

iSelectedRow = dw_insert.GetRow()
IF iSelectedRow <=0 THEN 
	f_message_chk(36,'')
	RETURN
END IF

gs_gubun = '2'
gs_code = dw_insert.GetItemString(iSelectedRow,'itnbr')
Open(w_sal_01710)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\판매이력조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\판매이력조회_dn.gif'
end event

type p_6 from uo_picture within w_sal_02000
boolean visible = false
integer x = 2016
integer y = 44
integer width = 475
integer height = 100
boolean bringtotop = true
string picturename = "C:\erpman\image\여신상세조회_up.gif"
end type

event clicked;call super::clicked;String sCust,sSuJuYearMonth

dw_suju_ins.AcceptText()
sSuJuYearMonth = Left(Trim(dw_suju_ins.GetItemString(1,"order_date")),6)
sCust          = dw_suju_ins.GetItemString(1,"cvcod")

IF sSuJuYearMonth = "" OR IsNull(sSuJuYearMonth) THEN 
	f_message_chk(30,'[수주일자]')
	dw_suju_ins.SetColumn("order_date")
	dw_suju_ins.SetFocus()
	Return
END IF
IF sCust = "" OR IsNull(sCust) THEN 
	f_message_chk(30,'[거래처]')
	dw_suju_ins.SetColumn("cvcod")
	dw_suju_ins.SetFocus()	
	Return
END IF

OpenWithParm(w_sal_02000_3,sSuJuYearMonth+sCust)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\여신상세조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\여신상세조회_dn.gif'
end event

type dw_suju_ins from datawindow within w_sal_02000
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 200
integer width = 3890
integer height = 372
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_020001"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  sOrderNo, sOrderDate, sNewOrderDate, sCust, sCustName, sSuJuYm, snull, sDepotNo, sSaupj
Long    nRow, nLen, nCnt
string  sproject_prjnm,sproject_no, sCvStatus
		
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(snull)

nRow = GetRow()
If nRow <=0 Then Return

Choose Case GetColumnName() 
	/* 수주번호 */
	Case "order_no"
		sOrderNo = Trim(GetText())
		IF sOrderNo = "" OR IsNull(sOrderNo) THEN RETURN
		
		nLen = Len(sOrderNo)

		/* 등록일때 */
		If rb_insert.Checked = True Then
			SELECT DISTINCT SUBSTR("SORDER"."ORDER_NO",1,LENGTH("SORDER"."ORDER_NO")-3)
			  INTO :sOrderNo  
			  FROM "SORDER"
			 WHERE ( "SORDER"."SABU" = :gs_sabu ) AND
					 ( SUBSTR("SORDER"."ORDER_NO",1,:nLen) = :sOrderNo)  AND
					 ( LENGTH("SORDER"."ORDER_NO") = :nLen+3 );
				 
			IF SQLCA.SQLCODE = 0 OR sqlca.sqlnrows >= 1 THEN
				f_message_chk(10001,'[수주번호]')
				SetItem(nRow,'order_no',sNull)
				Return 1
			END IF
		Else
			p_inq.PostEvent(Clicked!)
		End If
	/* 수주일자 */
	Case "order_date"
		sOrderDate = Trim(GetText())
		IF sOrderDate ="" OR IsNull(sOrderDate) THEN RETURN
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[수주일자]')
			SetItem(1,"order_date",snull)
			Return 1
		ELSE		
			sNewOrderDate = sqlca.Fun_Erp100000050(gs_sabu,sordergbn,sOrderDate,'1')
			IF sNewOrderDate <> sOrderDate THEN
			  f_message_chk(60,sNewOrderDate)
			  SetItem(1,"order_date",sNewOrderDate)
			  Return 1
			END IF
			
			IF Wf_Replace_NapGiDate(sOrderDate) = -1 THEN
				SetItem(1,"order_date",sNewOrderDate)
				Return 1
			END IF
		END IF
	/* 거래선 */
	Case "cvcod"
		sCust = Trim(GetText())
		gs_gubun = '1'
		Post wf_cvcod(sCust)
	/* 거래선명 */
	Case "cvnas"
		sCustName = Trim(GetText())
		IF sCustName ="" OR IsNull(sCustName) THEN 
			Post wf_cvcod(sNull)
			Return
		End If

		SELECT MAX("VNDMST"."CVCOD"),   COUNT(*)
		  INTO :sCust, :nCnt
		  FROM "VNDMST", "SAREA"
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND
		       "VNDMST"."CVNAS2" like '%'||:sCustName||'%' AND
				 "VNDMST"."CVSTATUS" = '0';
	
		Choose Case nCnt
			Case 0
				gs_gubun = '1'
				Open(w_agent_popup)
				If gs_code = '' Or IsNull(gs_code) Then Return 1
			Case 1
				gs_code = sCust
			Case Else
				gs_codename = sCustName
				Open(w_vndmst_popup)
				If gs_code = '' Or IsNull(gs_code) Then Return 1
		End Choose
		
		Post wf_cvcod(gs_code)
	/* 프로젝트 */
	Case "project_no"
		sproject_no = Trim(GetText())
		IF sproject_no ="" OR IsNull(sproject_no) THEN
			SetItem(1,"prjnm",snull)
			Return
		END IF
	
	  sCust = GetItemString(1, 'cust_no')
//	  SELECT "PJTDES"  
//		 INTO :sproject_prjnm  
//		 FROM "VW_PROJECT" , "PROJECT"		 
//		WHERE ( "PJTNO" = :sproject_no ) AND
//				( "PROJECT"."CUST_NO" = :sCust )   ;
		SELECT "FLOW_PROJECT"."PROJ_CODE", "FLOW_PROJECT"."PROJ_NAME"   
		  INTO :sproject_no, :sproject_prjnm
		  FROM "FLOW_PROJECT"  
		 WHERE ( "FLOW_PROJECT"."PROJ_CODE" = :sproject_no );	
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(rbuttondown!)
			return 2
		End If
		
		SetItem(1,"prjnm",sproject_prjnm)
	/* 고객 번호 */
	Case "cust_no"
		sCust = Trim(GetText())
		IF sCust ="" OR IsNull(sCust) THEN
			setitem(1, 'cust_name', sNull)
			setitem(1, 'cust_no', sNull)
			Return 1
		End If
		
		SELECT "CUST_NAME"  INTO :sCustName
		  FROM "CUSTOMER"
		 WHERE "CUST_NO" = :sCust;
		
		IF SQLCA.SQLCODE = 0 THEN
			setitem(1, 'cust_name', left(sCustName, 20))
		Else
			setitem(1, 'cust_name', sNull)
			setitem(1, 'cust_no', sNull)
			Return 1
		End If
	/* 영업부서 */
   Case 'deptno'
		sCust = Trim(GetText())
		
		IF sCust ="" OR IsNull(sCust) THEN 
			this.SetItem(1,"deptname",sNull)
			RETURN
		END IF
		
		SELECT "VNDMST"."CVNAS2"  INTO :sCustName
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sCust  AND "VNDMST"."CVGU" = '4' ;
		
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptname",sCustName)
		ELSE
			this.TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN 
				this.SetItem(1,"deptno",snull)
				this.SetItem(1,"deptname",snull)
			END IF
			
			Return 1	
		END IF
	Case 'dirgb'
		If GetText() = 'D' Then
			SetItem(1, 'house_no', GetItemString(1, 'depot_no'))
		Else
			If GetItemString(1, 'depot_no') = GetItemString(1, 'house_no') Then
				sle_msg.Text = '출고창고와 납품창고를 다르게 지정하세요.!!'
//				MessageBox('확 인','출고창고와 납품창고를 다르게 지정하세요.!!')
				SetItem(1, 'house_no', sNull)
				Return
			End If
		End If
	/* 납품창고 선택 */
	Case "house_no"
		sDepotNo = GetText()
		IF sDepotNo = "" OR IsNull(sDepotNo) THEN RETURN
		
		SELECT "VNDMST"."IPJOGUN" INTO :sSaupj  
		  FROM "VNDMST"  
		 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[창고]')
			SetItem(1,"house_no",snull)
			Return 1
		END IF
	/* 출고창고 선택 */
	Case "depot_no"
		sDepotNo = GetText()
		IF 	sDepotNo = "" OR IsNull(sDepotNo) THEN RETURN
		
		SELECT "VNDMST"."IPJOGUN" INTO :sSaupj  
		  FROM "VNDMST"  
		 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' )   ;
			
		IF 	SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[창고]')
			SetItem(1,"depot_no",snull)
			Return 1
		END IF
		
		if  	this.GetItemString(1,"dirgb") = 'D'  then
			SetItem(1,"house_no",sDepotNo)
		End If 
	Case 'saupj'
		sSaupj = Trim(GetText())
		
//		f_child_saupj(dw_suju_ins, 'house_no', sSaupj)
//		f_child_saupj(dw_suju_ins, 'depot_no', sSaupj)
//		f_child_saupj(dw_suju_ins, 'emp_id', sSaupj)
		/*2016.01.27 신동준 변경*/
		f_child_saupj(dw_insert, 'house_no', sSaupj)
		f_child_saupj(dw_insert, 'depot_no', sSaupj)
	Case 'oversea_gu'
		If GetText() = '1' Then
			SetItem(1, 'curr', 'WON')
		Else
			SetItem(1, 'curr', sNull)
		End If
END Choose

ib_any_typing = True
end event

event itemerror;Return 1
end event

event itemfocuschanged;IF this.GetColumnName() ='cvpln' THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event rbuttondown;String sEmpId, sSaupj

SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()

	/* 수주번호 */
	Case "order_no"
		If rb_modify.Checked = True Then
			OpenWithParm(w_sorder_popup,'1')
			IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"order_no", Left(gs_code,len(gs_code)-3))
			p_inq.TriggerEvent(Clicked!)
		End If
	/* 거래처 */
	Case "cvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'cvcod', gs_code)
		TriggerEvent(ItemChanged!)
	/* 거래처명 */
	Case "cvnas"
		Open(w_vndmst_popup)
		
		IF gs_codename ="" OR IsNull(gs_codename) THEN RETURN 2
		
		SetItem(1,"cvnas",gs_codename)
		SetItem(1,"cvcod",gs_code)
		
		sEmpId = wf_get_empid(gs_code, sSaupj)
		SetItem(1,'emp_id', sEmpId)
		
		wf_calc_yusin(gs_code)
		
		SetColumn('cvpln')
	/* 거래처 임직원 */
	Case 'cvpln'
		gs_code = GetItemString(GetRow(),'cvcod')
		Open(w_custstaff_popup)
		
		IF gs_codename ="" OR IsNull(gs_codename) THEN RETURN 2
		
		SetItem(1,"cvpln",gs_codename)
		SetColumn('emp_id')
	/* 고객번호 */
	Case "cust_no"
		Open(w_vndmst_popup)
		//Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cust_no",  gs_code)
		SetItem(1,"cust_name",gs_codename)
	/* 영업부서 */
   Case "deptno"
		open(w_vndmst_4_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		
		SetItem(1, "deptno", gs_Code)
		SetItem(1, "deptname", gs_Codename)
	/* 프로젝트 */
   Case "project_no"
//		gs_gubun = '1'
//		Open(w_project_popup)
//		IF isnull(gs_Code)  or  gs_Code = ''	then  return
//		
//		SetItem(1, "project_no", gs_Code)
//		SetItem(1, "prjnm", gs_Codename)
		open(w_wflow_project_pop)
		if isnull(gs_code)  or  gs_code = ''	then	return
		this.setitem(1, "project_no", gs_code)		
		this.setitem(1, "prjnm", gs_Codename)
END Choose

end event

type dw_yusin from datawindow within w_sal_02000
boolean visible = false
integer x = 2496
integer y = 52
integer width = 562
integer height = 104
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_020003"
boolean border = false
boolean livescroll = true
end type

type p_1 from uo_picture within w_sal_02000
boolean visible = false
integer x = 3099
integer y = 24
integer width = 306
integer taborder = 230
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

type pb_1 from u_pb_cal within w_sal_02000
integer x = 791
integer y = 392
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_suju_ins.SetColumn('order_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_suju_ins.SetItem(1, 'order_date', gs_code)

end event

type dw_head from datawindow within w_sal_02000
boolean visible = false
integer x = 1527
integer y = 4
integer width = 686
integer height = 160
integer taborder = 220
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02000_52"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 44
integer width = 535
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4073
integer y = 180
integer width = 535
integer height = 428
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 180
integer width = 4037
integer height = 428
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sal_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 620
integer width = 4590
integer height = 1656
integer cornerheight = 40
integer cornerwidth = 55
end type

