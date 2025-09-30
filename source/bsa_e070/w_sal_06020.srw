$PBExportHeader$w_sal_06020.srw
$PBExportComments$P/I 등록
forward
global type w_sal_06020 from w_inherite
end type
type tab_1 from tab within w_sal_06020
end type
type tabpage_1 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type dw_insert_1 from u_key_enter within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_1 rr_1
dw_insert_1 dw_insert_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type dw_insert_2 from u_key_enter within tabpage_2
end type
type dw_insert_2_fuso from u_key_enter within tabpage_2
end type
type ln_1 from line within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
dw_insert_2 dw_insert_2
dw_insert_2_fuso dw_insert_2_fuso
ln_1 ln_1
end type
type tabpage_3 from userobject within tab_1
end type
type rr_4 from roundrectangle within tabpage_3
end type
type dw_insert_3 from u_key_enter within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_4 rr_4
dw_insert_3 dw_insert_3
end type
type tabpage_4 from userobject within tab_1
end type
type rr_5 from roundrectangle within tabpage_4
end type
type cb_2 from commandbutton within tabpage_4
end type
type dw_insert_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
rr_5 rr_5
cb_2 cb_2
dw_insert_4 dw_insert_4
end type
type tab_1 from tab within w_sal_06020
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_key from datawindow within w_sal_06020
end type
type gb_3 from groupbox within w_sal_06020
end type
type rb_new from radiobutton within w_sal_06020
end type
type rb_upd from radiobutton within w_sal_06020
end type
type gb_4 from groupbox within w_sal_06020
end type
type cb_1 from commandbutton within w_sal_06020
end type
type cb_jego from commandbutton within w_sal_06020
end type
type p_suju from uo_picture within w_sal_06020
end type
type pb_1 from u_pb_cal within w_sal_06020
end type
type pb_3 from u_pb_cal within w_sal_06020
end type
type pb_4 from u_pb_cal within w_sal_06020
end type
type pb_5 from u_pb_cal within w_sal_06020
end type
type cb_ins_fuso from commandbutton within w_sal_06020
end type
type cb_del_fuso from commandbutton within w_sal_06020
end type
type rr_3 from roundrectangle within w_sal_06020
end type
end forward

global type w_sal_06020 from w_inherite
integer height = 2480
string title = "PROFORMA INVOICE 등록"
tab_1 tab_1
dw_key dw_key
gb_3 gb_3
rb_new rb_new
rb_upd rb_upd
gb_4 gb_4
cb_1 cb_1
cb_jego cb_jego
p_suju p_suju
pb_1 pb_1
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
cb_ins_fuso cb_ins_fuso
cb_del_fuso cb_del_fuso
rr_3 rr_3
end type
global w_sal_06020 w_sal_06020

type variables
boolean ib_cfm, ib_prt=false, ibci 
String  is_junpyo_gb, is_autohold
end variables

forward prototypes
public function integer wf_clear_item (integer nrow)
public function string wf_get_junpyo_no (string pidate, string sordergbn)
public function integer wf_catch_special (integer nrow, ref double piprc, ref double dc_rate, string gbn)
public function integer wf_calc_amt (integer nrow, double piprc, double piqty)
public function long wf_suju_cancel ()
public function integer wf_catch_danga (integer nrow, string itnbr, string sorderspec, long ditemqty)
public function integer wf_set_minqty (integer nrow)
public function long wf_suju_status (long nrow)
public function integer wf_calc_curr (integer row, string sdate, string scurr)
public function integer wf_copy_buyer (string cvcod, string pidate, string pigu, string pists)
public function integer wf_set_piamt ()
public function integer wf_autohaldang (string ssujuorderno)
public subroutine wf_protect_key (string gb)
public function long wf_suju_confirm ()
public function integer wf_check_key ()
public function integer wf_copy_last_buyer (string arg_cvcod)
public function integer wf_set_posheet (long ar_row, string ar_itemno)
end prototypes

public function integer wf_clear_item (integer nrow);String sNull
dec    dNull

SetNull(snull)
SetNull(dnull)

tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itnbr",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itdsc",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ispec",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ispec_code",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"jijil",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"order_spec",'.')
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itemas_unmsr",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piqty",dNull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"dc_rate",dNull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piprc",dNull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piamt",dNull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"cust_napgi",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"pre_napgi",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"seqno",dNull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itemno",dNull)

Return 1
end function

public function string wf_get_junpyo_no (string pidate, string sordergbn);String  sOrderNo
string  sMaxOrderNo

sMaxOrderNo = String(sqlca.fun_junpyo(gs_sabu,pidate,sOrderGbn),'000')

IF Double(sMaxOrderNo) <= 0 THEN
  f_message_chk(51,'')
  ROLLBACK;
  SetNull(sOrderNo)
  Return sOrderNo
END IF

sOrderNo = pidate + sMaxOrderNo

COMMIT;

Return sOrderNo
end function

public function integer wf_catch_special (integer nrow, ref double piprc, ref double dc_rate, string gbn);/* ----------------------------------------------------- */
/* 특출일 경우 할인율과 단가 계산                        */
/* ----------------------------------------------------- */
string s_pidate,s_itnbr,s_ispec,s_curr,s_pricegbn, sSaleGu
int irow,rtn
double d_danga,d_rate,d_amt

iRow = dw_key.GetRow()
If iRow <=0 Then Return 2

s_pidate = dw_key.GetItemString(iRow,'pidate')
s_itnbr  = tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'itnbr')
s_ispec  = tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'ispec')
s_curr   = dw_key.GetItemString(iRow,'curr')
If s_curr = 'WON' Then
   s_pricegbn  = '1'  //원화
Else
	s_pricegbn  = '2'  //외화
End If
		 
If IsNull(s_pidate) Or s_pidate = '' Then
   f_message_chk(40,'[발행일]')
   Return -1
End If
If IsNull(s_itnbr) Or s_itnbr = '' Then
   f_message_chk(40,'[품번]')
   Return -1
End If
If IsNull(s_curr) Or s_curr = '' Then
   f_message_chk(40,'[통화]')
   Return -1
End If

/* 무상출고일 경우 단가 0 */
sSalegu = tab_1.tabpage_2.dw_insert_2.GetItemString(nRow, 'amtgu')
If sSaleGu = 'N' Then
	piprc  = 0
	dc_rate = 0
	Return 1
End If

If gbn = '1' Then
	/* 단가 입력시 할인율 계산 */
   rtn = sqlca.fun_erp100000014(s_itnbr , '.' 	,piprc,s_pidate,s_curr,s_pricegbn,dc_rate)
   If rtn = -1 Then dc_rate = 0
Else
	/* 할인율 입력시 단가계산 */
   rtn = sqlca.fun_erp100000015(s_itnbr,  '.' , s_pidate,s_curr,s_pricegbn,dc_rate,piprc)
   If rtn = -1 Then 	piprc = 0
End If

/* 할증이면 할인율은 0 */
If dc_rate < 0 Then dc_rate = 0

return 1

end function

public function integer wf_calc_amt (integer nrow, double piprc, double piqty);/* ---------------------------------------- */
/* 품목별 금액,원화금액,외화금액 계산       */
/* ---------------------------------------- */
dec 	 piamt
dec    wrate,urate,weigh

wrate = dw_key.GetItemNumber(1,'wrate')
urate = dw_key.GetItemNumber(1,'urate')
weigh = dw_key.GetItemNumber(1,'weight')
If IsNull(wrate) Or wrate = 0 Then wrate = 1
If IsNull(urate) Or urate = 0 Then urate = 1
If IsNull(weigh) Or weigh = 0 Then weigh = 1

//piamt = piprc * piqty
//piamt = TrunCate(piamt,2)

piamt = piprc * piqty
piamt = TrunCate(Round(piprc,5) * Round(piqty,3),2)

tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'piamt',piamt)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'wamt',Truncate((piamt * wrate)/weigh,0))
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'uamt',Truncate((piamt * urate)/weigh,2))

Return 1

end function

public function long wf_suju_cancel ();/* ----------------------------------------------------------- */
/* 수주등록된 자료를 삭제하고 PI상태를 확정->견적으로 변경한다 */
/* ----------------------------------------------------------- */
Long   nCnt, nRow
String sPino, sCvcod, sNull, sOrderNo, sOrderMemo
Double dHoldQty, dIsQty

SetNull(sNull)
If dw_key.AcceptText() <> 1 Then Return -1

nCnt = tab_1.tabpage_2.dw_insert_2.RowCount() // 처리건수
If nCnt <= 0 Then 
	f_message_chk(83,'[품목정보]')
	Return 0
End If

nRow = dw_key.GetRow()
sPIno  = Trim(dw_key.GetItemString(nRow,'pino'))
sCvcod = Trim(dw_key.GetItemString(nRow,'cvcod'))
If IsNull(sPino) Or sPino = '' Then
   f_message_chk(1400,'[P/I NO]')
   Return 0
End If

sOrderNo = Left(Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(1,'sorder_order_no')),11)
If IsNull(sOrderNo) or sOrderNo = '' Then
   f_message_chk(94,'')
   Return 0
End If

If is_autohold = 'N' Then
	/* 수주가 할당되어있으면 취소 불가 */
	select nvl(sum(hold_qty),0) + ( nvl(sum(jisi_qty),0) - nvl(sum(prod_qty),0)) into :dHoldQty
	  from sorder
	 where sabu = :gs_sabu and
			 pino = :sPino;
	
	If dHoldQty > 0 Then
		f_message_chk(112,'')
		Return 0
	End If
Else
	/* 자동할당인 경우 출고의뢰되있으면 취소 불가 */
	select sum(invoice_qty) into :dHoldQty
	  from sorder
	 where sabu = :gs_sabu and
			 pino = :sPino;
	
	If dHoldQty > 0 Then
		f_message_chk(112,'')
		Return 0
	End If	
End If

IF MessageBox("수주취소","[수주번호:" +sOrderNo + "]으로 수주등록된 자료가 삭제됩니다." +"~n~n" +&
              "진행 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

						
/* 수주 확정 취소 처리 */
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'ordcfdt',sNull)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'pists','1')    // 수주 견적

tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'wamt',0)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'uamt',0)
		
If tab_1.tabpage_1.dw_insert_1.Update() <> 1 Then
   RollBack;
   f_message_chk(89,'[PI 헤더 저장 오류]')
	Return -1
End If

/* 자동할당인 경우 할당내역을 취소한다 */
If is_autohold = 'Y' Then
	SELECT SUM(ISQTY) INTO :dIsQty FROM HOLDSTOCK WHERE SABU = :gs_sabu AND ORDER_NO LIKE :sPino||'%';
	If IsNull(dIsqty ) Or dIsQty = 0 Then 
		UPDATE HOLDSTOCK SET OUT_CHK = '3', CANCELQTY = HOLD_QTY WHERE SABU = :gs_sabu AND ORDER_NO LIKE :sPino||'%';
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return -1
		End If
	Else
		rollback;
		MessageBox('확인','출고의뢰된 내역이 존재합니다.!!')
		Return -1
	End If
End If

DELETE FROM sorder
 where sabu = :gs_sabu and
       pino = :sPino and
		 suju_sts < '4';

If sqlca.sqlcode <> 0 OR sqlca.sqlnrows <= 0 Then
	RollBack;
	f_message_chk(160,'')
	Return -1
Else
	commit;
	Return 1
End If

end function

public function integer wf_catch_danga (integer nrow, string itnbr, string sorderspec, long ditemqty);string sOrderDate, sCvcod, sCurr, sPriceGbn, sSaleGu
int 	 irow, iRtnValue = -1
Double dItemPrice, dDcRate, dQtyPrice, dQtyRate

iRow = dw_key.RowCount()
If iRow <=0 Then Return -1

sOrderDate = dw_key.GetItemString(iRow,'pidate')
sCvcod  = dw_key.GetItemString(iRow,'cvcod')
sCurr   = dw_key.GetItemString(iRow,'curr')

If IsNull(sOrderDate) Or sOrderDate = '' Then
   f_message_chk(40,'[발행일]')
   Return 2
End If
If IsNull(sCvcod) Or sCvcod = '' Then
   f_message_chk(40,'[Buyer]')
   Return 2
End If

If IsNull(sCurr) Or sCurr = '' Then
   f_message_chk(40,'[통화]')
   Return 2
End If

/* 무상출고일 경우 단가 0 */
sSalegu = tab_1.tabpage_2.dw_insert_2.GetItemString(nRow, 'amtgu')
If sSaleGu = 'N' Then
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"dc_rate",dDcRate)
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piprc",	dItemPrice)
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itmprc",	dItemPrice)	
	Return 0
End If

If sCurr = 'WON' Then
   sPriceGbn  = '1'  //원화
Else
	sPriceGbn  = '2'  //외화
End If

/* 수량이 0이상일 경우 수량base단가,할인율을 구한다 */
If dItemQty > 0 Then
	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, Itnbr, dItemQty, &
                                      sCurr, dQtyPrice, dQtyRate) 
End If
If IsNull(dQtyPrice) Then dQtyPrice = 0
If IsNull(dQtyRate)	Then dQtyRate = 0

/* 판매 기본단가,할인율를 구한다 */
iRtnValue  = sqlca.Fun_Erp100000016( gs_sabu, sOrderDate, sCvcod,     Itnbr, sOrderSpec,&
												 sCurr,    sPriceGbn,  dItemPrice, dDcRate) 

/* 특출단가나 거래처단가일경우 수량별 할인율은 적용안함 */
If iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0

/* 수량별 할인율이 있을 경우 단가를 다시 계산한다 */
If dQtyRate <> 0 Then
	dDcRate += dQtyRate
   iRtnValue = sqlca.fun_erp100000015(itnbr, sOrderSpec, sOrderSpec, sCurr, sPriceGbn, dDcRate, dItemPrice)
End If
												
If IsNull(dItemPrice) Then dItemPrice = 0.0
If IsNull(dDcRate)  Then dDcRate = 0.0

Choose Case iRtnValue
	Case IS < 0 
		f_message_chk(41,'[단가 계산]'+string(irtnvalue))
		Return 1
	Case Else
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"dc_rate",dDcRate)
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piprc",	dItemPrice)
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itmprc",	dItemPrice)	
		
		/* 거래처 할인율, 정책할인율, 품목마스타 단가 */
		If iRtnValue = 3 or iRtnValue = 4 or iRtnValue = 5 Then
			tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"special_yn",'N')
		Else
			tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"special_yn",'Y')   /* 특출 */	
		End If
		
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"pricegbn",String(irtnvalue))
End Choose

return 0
end function

public function integer wf_set_minqty (integer nrow);Dec dItemQty, nNapQty, dMinQty, dMaxQty

/* 납품배수 */
nNapQty = dw_key.GetItemNumber(1,'napqty')
dItemQty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow, 'piqty')
dMaxQty  = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow, 'maxqty')

/* 절대수량 계산 */
dMinQty = TrunCate(dItemQty * dMaxQty / 100,3)

If IsNull(nNapqty) Or nNapQty = 0 Then
Else
	dMinQty = truncate(dMinQty / nNapQty,0) * nNapQty
End If

If IsNull(dMinQty) Then dMinQty = 0

tab_1.tabpage_2.dw_insert_2.SetItem(nRow, 'minqty', dMinQty)

Return 0

end function

public function long wf_suju_status (long nrow);Double dHoldQty, dJisiQty, dOrderQty, dProdQty, dCiQty
String sAgrDat, sCino
String sPino
Int	 iPiseq

/* 수주상태 확인 */
If nRow <=0  Or tab_1.tabpage_2.dw_insert_2.RowCount() < nRow Then Return -1

/* CI에 연결된 건은 삭제 불가 */
sPino  = tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'pino')
iPiseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,'piseq')

iBCi = False

SELECT MAX(CINO), SUM(CIQTY) INTO :sCino, :dCiQty
  FROM EXPCID
 WHERE SABU = :gs_sabu AND
       PINO = :sPino AND
		 PISEQ = :iPiseq;

If Not IsNull(sCino) Then
	w_mdi_frame.sle_msg.Text = '관련 C/I No. : ' + sCino
	iBCi = True
	Return dCiQty
Else
	iBCi = False
End If

Choose Case tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'sorder_suju_sts')
  Case '3'              // 보류
	 return -2
  Case '4','8','9'      // 취소,완료,마감 => 삭제불가,수정불가
	 return -1
  Case Else
    dOrderQty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,"sorder_order_qty")	/*수주수량 합*/
    IF IsNull(dOrderQty) THEN dOrderQty =0
		
    dHoldQty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,"sorder_hold_qty")		/*할당수량 합*/
    IF IsNull(dHoldQty) THEN dHoldQty =0
	
    dJisiQty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,"sorder_jisi_qty")		/*생산지시수량 합*/
    IF IsNull(dJisiQty) THEN dJisiQty =0
	
    dProdQty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,"sorder_prod_qty")		/*생산입고수량 합*/
    IF IsNull(dProdQty) THEN dProdQty =0
		
//    pur_req_no = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,"sorder_pur_req_no"))	/* 구매번호 */
//    IF IsNull(pur_req_no) THEN pur_req_no = ''

    sAgrDat = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,"sorder_agrdat"))	/* 생산승인일자 */
    IF IsNull(sAgrDat) Or sAgrDat = '0' THEN sAgrDat = ''
		
	IF dHoldQty <> 0 Then 
		Return Abs(dHoldQty + dJisiQty - dProdQty)
	ElseIf (dJisiQty - dProdQty) <> 0 THEN
		Return Abs(dHoldQty + dJisiQty - dProdQty)
	ElseIf  dJisiQty = 0 and dProdQty = 0 and sAgrDat <> '' Then
//		f_message_chk(57,'[생산승인된 자료입니다]')
		w_mdi_frame.sle_msg.text = '생산승인된 자료입니다.!!'
		Return dOrderQty
	Else
		Return 0    /* 미진행(승인) */
	End If
End Choose

end function

public function integer wf_calc_curr (integer row, string sdate, string scurr);Dec {4} wrate,urate
String  weight

select x.rstan,x.usdrat, y.rfna2
  into :wrate,:urate, :weight
  from ratemt x, reffpf y
 where x.rcurr = y.rfgub(+) and
       y.rfcod = '10' and
       x.rdate = :sdate and
       x.rcurr = :scurr;

If IsNull(weight) Or weight = '' Then weight = '0'
If IsNull(wrate)  Or wrate = 0  Then wrate = 0.0
If IsNull(urate)  Or urate = 0  Then urate = 0.0
dw_key.setitem(1, "curr", scurr)
tab_1.tabpage_1.dw_insert_1.SetItem(row,'wrate',wrate)
tab_1.tabpage_1.dw_insert_1.SetItem(row,'urate',urate)
tab_1.tabpage_1.dw_insert_1.SetItem(row,'weight',Double(weight)) /* 가중치 */

Return 0
end function

public function integer wf_copy_buyer (string cvcod, string pidate, string pigu, string pists);/* 동일한 바이어가 입력될 경우 최근의 기초자료를 복사한다 */
string max_pino,s_curr,sNull,sPiMaker, sOrigin, sPisangho, sPacking, sOldPiNo, saupj
String cvnas, areacd, semp_id, areacdnm, soutgu, sarea, arg_sarea, steam
Long   nRow,rtn
Dec    dNapQty

SELECT "VNDMST"."CVNAS2", "VNDMST"."AREACD", "VNDMST"."SALE_EMP", "SAREA"."SAUPJ",
       "AREA"."AREANM",   "VNDMST"."OUTGU",  "VNDMST"."NAPQTY", 	"VNDMST"."SAREA"
  INTO :cvnas, :areacd , :sEmp_id, :saupj, :areacdnm, :sOutgu, :dNapqty, :sarea
  FROM "VNDMST", "AREA", "SAREA"
 WHERE "VNDMST"."AREACD" = "AREA"."AREACD"(+) AND
		 "VNDMST"."SAREA"  = "SAREA"."SAREA"(+) AND
		 "VNDMST"."CVSTATUS" <> '2' AND
		 "VNDMST"."CVCOD" = :cvcod;

If Trim(cvnas) = '' Or IsNull(cvnas) Then
//	f_message_chk(50,'[BUYER]')
	dw_key.SetItem(1, 'cvcod', sNull)
	dw_key.SetItem(1, 'cvcodnm', sNull)
	Return -1
End If

/* User별 관할구역 권한 체크 */
If f_check_sarea(arg_sarea, steam, saupj)  = 1 And sarea <> arg_sarea Then
	f_message_chk(114,'')
	dw_key.SetItem(1, 'cvcod', sNull)
	dw_key.SetItem(1, 'cvcodnm', sNull)
	Return -1
End If

SELECT max("EXPPIH"."PINO" )
  INTO :max_pino  
  FROM "EXPPIH"  
 WHERE ( "EXPPIH"."SABU" = :gs_sabu ) AND  
		 ( "EXPPIH"."CVCOD" = :cvcod ) ;
			
SetNull(sNull)

If IsNull(max_pino) Or Trim(max_pino) = '' Then 
  SELECT "EXPPIH"."PIMAKER",   "EXPPIH"."ORIGIN",  "EXPPIH"."PISANGHO",  "EXPPIH"."PACKING"  
    INTO :sPiMaker,            :sOrigin,           :sPisangho,           :sPacking  
    FROM "EXPPIH"
   WHERE "EXPPIH"."PINO" = (select max("EXPPIH"."PINO" ) FROM "EXPPIH" )  ;

	nRow = dw_key.GetRow()
	dw_key.SetItem(nRow,'pimaker', sPiMaker)
	dw_key.SetItem(nRow,'origin',  sOrigin)
	dw_key.SetItem(nRow,'pisangho',sPisangho)
	dw_key.SetItem(nRow,'packing', sPacking)
	
	rtn = dw_key.SetItemStatus(nRow, 0,Primary!, NewModified!	)
	
	dw_key.SetFocus()
	dw_key.SetColumn('piattn')
Else
  sOldPiNo = Trim(dw_key.GetItemString(1,'pino'))
  If dw_key.Retrieve(gs_sabu,max_pino) <= 0 Then	  return 1

  nRow = dw_key.GetRow()
  If nRow <= 0 Then Return 1
  
	/* 자동채번일 경우 PI No를 삭제 */
	If is_junpyo_gb = 'Y' Then
		dw_key.SetItem(nRow,'pino',   sNull)
	Else
		dw_key.SetItem(nRow,'pino',   sOldPiNo)
	End If
  
	dw_key.SetItem(nRow,'pidate', pidate)
	dw_key.SetItem(nRow,'pigu',   pigu)
	dw_key.SetItem(nRow,'pists',  '1')
	dw_key.SetItem(nRow,'pono',   sNull)
	dw_key.SetItem(nRow,'shipsch',sNull)
	dw_key.SetItem(nRow,'shipreq',sNull)
	dw_key.SetItem(nRow,'invsch', sNull)
	dw_key.SetItem(nRow,'ordcfdt',sNull)
	dw_key.SetItem(nRow,'commission',  0)
	dw_key.SetItem(nRow,'piamt',  0)
	dw_key.SetItem(nRow,'ciamt',  0)
	dw_key.SetItem(nRow,'ngamt',  0)
	dw_key.SetItem(nRow,'wamt',   0)
	dw_key.SetItem(nRow,'uamt',   0)
  
  // 환율 계산
  s_curr = dw_key.GetItemString(nRow,'curr')
  If Not IsNull(s_curr) Then wf_calc_curr(nRow,pidate,s_curr)
  
  rtn = dw_key.SetItemStatus(nRow, 0,Primary!, NewModified!	)
End If

dw_key.SetItem(1, 'cvcodnm',cvnas)
//dw_key.SetItem(1, 'saupj',  saupj)

dw_key.SetItem(1,'areacd',areacd)
dw_key.SetItem(1,'emp_id',sEmp_Id)

If Trim(areacdnm) = '' Then 
	dw_key.SetItem(1,'areacd',sNull)
	dw_key.SetItem(1,'area_areanm',sNull)
Else
	dw_key.SetItem(1,'areacd',areacd)
	dw_key.SetItem(1,'area_areanm',areacdnm)
End If

/* 납품배수 */
dw_key.SetItem(nRow, 'napqty', dNapQty)
	
///* Local 업체일 경우 표시 */
//If sOutGu = '4' Then
//	dw_key.SetItem(1, 'localyn', 'Y')
//Else
//	dw_key.SetItem(1, 'localyn', 'N')
//End If

// Local은 수주등록에서 한다
dw_key.SetItem(1, 'localyn', 'N')

Return 1
end function

public function integer wf_set_piamt ();/* 수주header의 Pi 금액,원화금액 ,외화금액 설정 */
/* 단, 원화금액,외화금액은 확정시 계산된다 */
String sPiSts
Double dPiamt, dCharge, dChramt, dOrdPrc, dPiPrc, dPiWamt, dPiUamt, dChrWamt, dChrUamt
Double dPiDamt, dPiDWamt, dPiDUamt, weigh
dec {2}   wrate
dec {4}   urate
Long    ix

If tab_1.tabpage_1.dw_insert_1.RowCount() <= 0 Then Return 0

sPiSts = tab_1.tabpage_1.dw_insert_1.GetItemString(1,'pists')

/* 수출금액,원화금액,외화금액 계산 */
wrate = tab_1.tabpage_1.dw_insert_1.GetItemDecimal(1,'wrate')
urate = tab_1.tabpage_1.dw_insert_1.GetItemDecimal(1,'urate')
weigh = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'weight')
//If ( IsNull(wrate) Or wrate = 0 )  And ( IsNull(urate) Or urate = 0 ) Then
//	If sPists = '2' or sPists = '9' Then
//	  MessageBox('환 율','확정처리시 필요한 환율이 등록되어있지 않습니다.!!~r~n~r~n확정일자의 환율이 등록되어 있어야 합니다.')
//	  Return -1
//	End If
//End If

If IsNull(wrate) Or wrate = 0 Then wrate = 1
If IsNull(urate) Or urate = 0 Then urate = 1
If IsNull(weigh) Or weigh = 0 Then weigh = 1

/* Detail, charge 금액을 현재 환율로 재계산 */
For ix = 1 To tab_1.tabpage_2.dw_insert_2.RowCount() 
	dPiamt = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'piamt')
Next

For ix = 1 To tab_1.tabpage_3.dw_insert_3.RowCount() 
	dChramt = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'chramt')
Next

/* Pi header amt <= Pi detail + Charge amt */
If tab_1.tabpage_2.dw_insert_2.RowCount() > 0 then
  dPiDamt = tab_1.tabpage_2.dw_insert_2.GetItemNumber(1,'sum_piamt')
  If IsNull(dPiamt) Then dPiamt = 0 
Else
  dPiDamt = 0
End If

If tab_1.tabpage_3.dw_insert_3.RowCount() > 0 Then
  dChrAmt = tab_1.tabpage_3.dw_insert_3.GetItemNumber(1,'sum_chramt')
  If IsNull(dChrAmt) Then dChrAmt = 0  
Else
	dCharge = 0
End If

dPiamt  = dPiDamt  + dChrAmt  /* PI 외화금액 */

/* 상태가 접수나 보류 */
If sPists = '1' or sPists = '3' Then
  tab_1.tabpage_1.dw_insert_1.SetItem(1,'piamt',dPiamt)
Else
/* 상태가 확정일 경우 */
  tab_1.tabpage_1.dw_insert_1.SetItem(1,'piamt',dPiamt)

	/* Pi의 원화단가와 수주단가가 틀릴경우 수정 */
//	For ix = 1 To tab_1.tabpage_2.dw_insert_2.RowCount() 
//		dPiPrc = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'piprc') /* Pi 단가 */
//		dPiPrc = TrunCate((dPiPrc * wrate)/weigh,0) /* Pi 단가 => 원화단가 */
//		dOrdPrc = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'sorder_order_prc') /* 수주의 원화단가 */
//		If dPiPrc <> dOrdPrc Then
//			tab_1.tabpage_2.dw_insert_2.SetItem(ix,'sorder_order_prc',dPiPrc)
//		End If
//	Next
End If

Return 0


end function

public function integer wf_autohaldang (string ssujuorderno);String  sSqlSyntax
Double iRtnValue

ib_prt = False

IF is_autohold = 'Y' THEN
//	IF MessageBox("확 인","자동할당을 하시겠습니까?",Question!,YesNo!) = 2 THEN Return 0
	
	sSqlSynTax = ' and (sorder.suju_sts = '+ "'2'"+" ) and "
	sSqlSynTax = sSqlSynTax + ' sorder.sabu = ' + "'"+ gs_sabu +"' and "
	sSqlSynTax = sSqlSynTax + ' sorder.pino = ' + "'"+ sSuJuOrderNo +"' "

	iRtnValue = sqlca.fun_erp100000040(gs_sabu,'%',f_today(), sSqlSyntax)
	If sqlca.sqlcode <> 0 Then
		MessageBox(sqlca.sqlerrtext,'[자동할당을 실패하였습니다]')
//		MessageBox(string(sqlca.sqlcode),string(irtnvalue))
		RollBack;
		Return -1
	End If

	IF iRtnValue = -1 THEN
		ROLLBACK;
		f_message_chk(39,'')
		Return -1
	ELSEIF iRtnValue = -2 THEN
		rollback;
		f_message_chk(41,'[할당]')
		Return -1
	ELSEIF iRtnValue = 0 THEN        /* 할당된 건수가 없을 경우 */
		MessageBox('할당완료','할당된 자료가 없습니다.!! ')
		Return 0
	Else
		MessageBox('할당완료','할당건수 ' + String(iRtnValue))
		ib_prt = True  /* 할당현황 출력 */
	END IF
Else
	Return -1
END IF

Return 0

end function

public subroutine wf_protect_key (string gb);
string	sNull
SetNull(sNull)

tab_1.tabpage_1.dw_insert_1.SetRedraw(False)

ib_cfm = False
ib_any_typing = False
sle_msg.Text = ''

cb_search.Enabled = False

/* 구매발주 현황 Reset */
tab_1.tabpage_4.dw_insert_4.Reset()


Choose Case  gb 
	Case '수정'
		dw_key.Modify('pino.protect = 0')
		dw_key.Modify('pidate.protect = 0')
		dw_key.Modify('saupj.protect = 1')
			
		tab_1.tabpage_1.dw_insert_1.Reset()
		tab_1.tabpage_1.dw_insert_1.InsertRow(0)
		tab_1.tabpage_2.dw_insert_2.Reset()
		tab_1.tabpage_3.dw_insert_3.Reset()
		
		dw_key.SetFocus()
		dw_key.SetRow(1)
		
		dw_key.SetItem(dw_key.GetRow(),'pino','')	
		dw_key.SetColumn('pino')
		
		rb_upd.Checked = True
		tab_1.SelectedTab = 1
		tab_1.TriggerEvent(selectionchanged!)

		dw_key.SetItem(1, "cvcod", 	sNull)
		dw_key.SetItem(1, "cvcodnm", 	sNull)
	Case '신규'
		tab_1.tabpage_1.dw_insert_1.Reset()
		tab_1.tabpage_1.dw_insert_1.InsertRow(0)
		tab_1.tabpage_1.dw_insert_1.setitem(1, "sabu", gs_sabu)
		tab_1.tabpage_2.dw_insert_2.Reset()
		tab_1.tabpage_3.dw_insert_3.Reset()
		
		dw_key.SetFocus()
		dw_key.SetRow(1)
		dw_key.SetItem(dw_key.Getrow(), 'pino', '')
		dw_key.SetItem(dw_key.GetRow(),'pidate',is_today)
		
		If is_junpyo_gb = 'Y' Then // 자동채번 
			dw_key.Modify('pino.protect = 1')
		Else
			dw_key.Modify('pino.protect = 0')
		End If
		
		dw_key.Modify('saupj.protect = 0')
		dw_key.Modify('cvcod.protect = 0')
		dw_key.Modify('pidate.protect = 0')
		dw_key.Modify('localyn.protect = 0')
		
		If is_junpyo_gb = 'Y' Then // 자동채번 
			dw_key.SetColumn('pidate')
		Else
			dw_key.SetColumn('pino')
		End If
		
		rb_new.Checked = True
		
		tab_1.SelectedTab = 1
		tab_1.TriggerEvent(selectionchanged!)

		dw_key.SetItem(1, "cvcod", 	sNull)
		dw_key.SetItem(1, "cvcodnm", 	sNull)
Case '조회'
		dw_key.Modify('pino.protect = 1')
		dw_key.Modify('cvcod.protect = 1')
		dw_key.Modify('pidate.protect = 1')
		dw_key.Modify('localyn.protect = 1')
		
		rb_upd.Checked = True
		
		tab_1.SelectedTab = 1
		tab_1.PostEvent(selectionchanged!)
End Choose

tab_1.tabpage_1.dw_insert_1.SetRedraw(True)
end subroutine

public function long wf_suju_confirm ();string   sPino, cvcod, s_curr
Long     nRow, process_cnt, nInsCnt = 0
String   sOrdcfdt, sDepotNo, sMsg, sHouseNo
	 
If dw_key.AcceptText() <> 1 Then Return -1

process_cnt = tab_1.tabpage_2.dw_insert_2.RowCount() // 처리건수
If process_cnt <= 0 Then 
	f_message_chk(83,'[품목정보 추가]')
	Return 0
End If

nRow = dw_key.GetRow()
sPIno  = Trim(dw_key.GetItemString(nRow,'pino'))
cvcod = Trim(dw_key.GetItemString(nRow,'cvcod'))
If IsNull(sPino) Or sPino = '' Then
   f_message_chk(1400,'[P/I NO]')
   Return 0
End If

If f_ischanged(tab_1.tabpage_2.dw_insert_2) = True  Then
	MessageBox('확 인','변경된 정보를 저장후 확정하십시요!!2')
	Return 0
End If

If f_ischanged(tab_1.tabpage_3.dw_insert_3) = True Then
	MessageBox('확 인','변경된 정보를 저장후 확정하십시요!!3')
	Return 0
End If

If f_ischanged(tab_1.tabpage_1.dw_insert_1) = True Then
	MessageBox('확 인','변경된 정보를 저장후 확정하십시요!!1')
	Return 0
End If

gs_code = dw_key.GetItemString(1, 'saupj')
Open(w_cfm_input2)
sMsg = Message.StringParm
If sMsg = '' Then Return 0

sOrdcfdt = Left(sMsg,8) // 확정일 
sDepotNo = Mid(sMsg,9)  // 출고창고
sHouseNo = gs_gubun		// 납품창고

If IsNull(sOrdcfdt) Or sOrdcfdt = '' Then 
	Rollback;
	f_message_chk(1400,'[확정일]')
	Return 0
End If

If IsNull(sDepotNo) Or sDepotNo = '' Then 
  Rollback;
  f_message_chk(1400,'[출고창고]')
  Return 0
End If

Setpointer(HourGlass!)

/* 수주 확정 처리 */
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'ordcfdt',sOrdcfdt)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'pists','2')    // 수주 확정

s_curr = tab_1.tabpage_1.dw_insert_1.GetItemString(nRow,'curr')
wf_calc_curr(nRow,sOrdcfdt,s_curr) // 확정일로 환율 설정

/* 수출금액,원화금액,외화금액 계산 */
If wf_set_piamt() = -1 then
	RollBack;
   wf_protect_key('수정')
   Return -1
End If

If tab_1.tabpage_1.dw_insert_1.Update() <> 1 Then
   f_message_chk(89,'[일반정보 저장 오류]')
   RollBack;
   Return -1
End If

/* 수주 확정 */
Setpointer(HourGlass!)

/* 출고창고와 납품창고가 동일하면 직납, 다르면 이송으로 처리한다 */
If IsNull(sHouseNo) Or Trim(sHouseNo) = '' Then sHouseNo = sDepotNo

nInsCnt = sqlca.fun_erp100000080(gs_sabu, sPino, sOrdcfdt, String(sDepotNo,'@@@@@@') + String(sHouseNo,'@@@@@@'))
If sqlca.sqlcode <> 0 Then
	MessageBox(sqlca.sqlerrtext,'[수주확정을 실패하였습니다]')
	RollBack;
	Return -1
End If

Choose Case nInsCnt
	Case Is > 0 
		Commit;
		f_message_chk(202,"[처리건수 : "+string(nInsCnt) + "]")	
		
		wf_autohaldang(sPiNo) /* 자동할당 */
		
		/* 미할당자료에 대해서 작지연결한다 */
		SQLCA.ERP000000570(gs_sabu, spino);
		If sqlca.sqlcode <> 0 Then
			RollBack;
			MessageBox('확 인','생산승인 작업을 실패하였습니다.!!')
			Return -1
		Else
			COMMIT;
		End If

		Return 1
	Case 0
		Rollback;
		f_message_chk(57,"[PI 상태 확인: 견적]")

		Return -1
	Case -1
		RollBack;
		f_message_chk(89,'[수주확정시 오류]')

		Return -1
End Choose
end function

public function integer wf_check_key ();String sPiDate,sCurr,sPiSts

/* 일자 */
dw_key.SetFocus()
sPiDate = Trim(dw_key.GetItemString(dw_key.GetRow(),'pidate'))
If f_datechk(sPiDate) <> 1 Then
   f_message_chk(1400,'[발행일]')
	dw_key.SetColumn('pidate')
   Return -1
End If

/* 상태 */
sPists = Trim(dw_key.GetItemString(1,'pists'))
If IsNull(sPists) or sPists = '' Then
   f_message_chk(1400,'[상태]')
	dw_key.SetColumn('Pists')
   Return -1
End If

/* 담당자 */
sCurr = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(dw_key.GetRow(),'emp_id'))
If IsNull(scurr) Or scurr = '' Then
   f_message_chk(40,'[영업담당자]')
	tab_1.tabpage_1.dw_insert_1.SetFocus()
	tab_1.tabpage_1.dw_insert_1.SetColumn('emp_id')
   Return -1
End If

/* 통화단위 */
sCurr = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(dw_key.GetRow(),'curr'))
If IsNull(sCurr) or sCurr = '' Then
   f_message_chk(1400,'[통화단위]')
	tab_1.tabpage_1.dw_insert_1.SetFocus()
	tab_1.tabpage_1.dw_insert_1.SetColumn('curr')
   Return -1
End If

/* 선적요구일 */
sCurr = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(dw_key.GetRow(),'shipreq'))
If IsNull(scurr) Or scurr = '' Then
   f_message_chk(40,'[선적요구일]')
	tab_1.tabpage_1.dw_insert_1.SetFocus()
	tab_1.tabpage_1.dw_insert_1.SetColumn('shipreq')
   Return -1
End If



Return 1

end function

public function integer wf_copy_last_buyer (string arg_cvcod);/* 동일한 바이어가 입력될 경우 최근의 기초자료를 복사한다 */
string max_pino, sNull
String sValue[13]

SetNull(sNull)

SELECT max("EXPPIH"."PINO" )
  INTO :max_pino  
  FROM "EXPPIH"  
 WHERE ( "EXPPIH"."SABU" = :gs_sabu ) AND  
		 ( "EXPPIH"."FACTORY" = :arg_cvcod ) ;
			
If Not IsNull(max_pino) Then
	select pisangho, piaddr, pinotes, shipment, payment, origin, packing, validity, caseinfo, pimaker, deliterms,
	       terms, inspection
	  into :svalue[1],:svalue[2],:svalue[3],:svalue[4],:svalue[5],:svalue[6],:svalue[7],:svalue[8],:svalue[9],
	       :svalue[10],:svalue[11],:svalue[12],:svalue[13]
	  from exppih
	 where sabu = :gs_sabu
	   and pino = :max_pino;
		
	dw_key.SetItem(1, 'pisangho', svalue[1])
	dw_key.SetItem(1, 'piaddr', svalue[2])
	dw_key.SetItem(1, 'pinotes', svalue[3])
	dw_key.SetItem(1, 'shipment', svalue[4])
	dw_key.SetItem(1, 'payment', svalue[5])
	dw_key.SetItem(1, 'origin', svalue[6])
	dw_key.SetItem(1, 'packing', svalue[7])
	dw_key.SetItem(1, 'validity', svalue[8])
	dw_key.SetItem(1, 'caseinfo', svalue[9])
	dw_key.SetItem(1, 'pimaker', svalue[10])
	dw_key.SetItem(1, 'deliterms', svalue[11])
	dw_key.SetItem(1, 'terms', svalue[12])
	dw_key.SetItem(1, 'inspection', svalue[13])
End If

Return 1
end function

public function integer wf_set_posheet (long ar_row, string ar_itemno);string	sItnbr, sItDsc, sIspec, sUnmsr, sNapgi
decimal	dQty
integer	nRtn
double dioprc

IF ar_itemno = ""	or	IsNull(ar_itemno)	THEN
	Wf_Clear_Item(ar_row)
	tab_1.tabpage_2.dw_insert_2.SetColumn("itnbr")
	RETURN -1
END IF

SELECT "SM01_MONPLAN_EX"."ITNBR",  "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",    "ITEMAS"."UNMSR",
		 "SM01_MONPLAN_EX"."NAPGI1",   "SM01_MONPLAN_EX"."MMQTY1"
  INTO :sItnbr, 						  :sItDsc,   		    :sIspec, 		 		 :sUnmsr,
		 :sNapgi,            			 :dQty
  FROM "SM01_MONPLAN_EX",
  		 "ITEMAS"
 WHERE "SM01_MONPLAN_EX"."ITEMNO" = :ar_itemno
   AND "SM01_MONPLAN_EX"."ITNBR"  = "ITEMAS"."ITNBR";

IF SQLCA.SQLCODE <> 0 THEN
	Wf_Clear_Item(ar_row)
	tab_1.tabpage_2.dw_insert_2.SetColumn("itnbr")
	Return -1
END IF

tab_1.tabpage_2.dw_insert_2.setitem(ar_row, "itnbr", sItnbr)
tab_1.tabpage_2.dw_insert_2.setitem(ar_row, "itdsc", sItdsc)
tab_1.tabpage_2.dw_insert_2.setitem(ar_row, "ispec", sIspec)
tab_1.tabpage_2.dw_insert_2.setitem(ar_row, "itemas_unmsr", sUnmsr)

/* 단가 계산 */
nRtn = wf_catch_danga(ar_row, sItnbr, '.', dQty)
If nRtn = -1 Then 
	Wf_Clear_Item(ar_row)
	Return -1
End If

dioprc = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ar_row,"piprc")

tab_1.tabpage_2.dw_insert_2.SetItem(ar_row,"piqty",dQty)
tab_1.tabpage_2.dw_insert_2.SetItem(ar_row,"piamt",dioprc*dQty)
tab_1.tabpage_2.dw_insert_2.SetItem(ar_row,'cust_napgi',sNapgi)
tab_1.tabpage_2.dw_insert_2.SetColumn("piqty")

TriggerEvent(ItemChanged!)

return 1
end function

on w_sal_06020.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_key=create dw_key
this.gb_3=create gb_3
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.gb_4=create gb_4
this.cb_1=create cb_1
this.cb_jego=create cb_jego
this.p_suju=create p_suju
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.cb_ins_fuso=create cb_ins_fuso
this.cb_del_fuso=create cb_del_fuso
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_key
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.rb_new
this.Control[iCurrent+5]=this.rb_upd
this.Control[iCurrent+6]=this.gb_4
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_jego
this.Control[iCurrent+9]=this.p_suju
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.pb_3
this.Control[iCurrent+12]=this.pb_4
this.Control[iCurrent+13]=this.pb_5
this.Control[iCurrent+14]=this.cb_ins_fuso
this.Control[iCurrent+15]=this.cb_del_fuso
this.Control[iCurrent+16]=this.rr_3
end on

on w_sal_06020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_key)
destroy(this.gb_3)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.gb_4)
destroy(this.cb_1)
destroy(this.cb_jego)
destroy(this.p_suju)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.cb_ins_fuso)
destroy(this.cb_del_fuso)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;String sYn

dw_key.SetTransObject(sqlca)
dw_key.InsertRow(0)

tab_1.tabpage_1.dw_insert_1.SetTransObject(sqlca)
tab_1.tabpage_2.dw_insert_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_insert_3.SetTransObject(sqlca)
tab_1.tabpage_4.dw_insert_4.SetTransObject(sqlca)
tab_1.tabpage_1.dw_insert_1.ShareData(dw_key) 

tab_1.tabpage_2.dw_insert_2_fuso.SetTransObject(sqlca)

/* 전표 채번 구분 : 'Y'-자동채번,'N'-수입력*/
select substr(dataname,1,1) into :is_junpyo_gb
  from syscnfg
 where sysgu = 'S' and
       serial = 6 and
       lineno = 30;

/* 사전원가 조회버튼 활성화 여부 */
select substr(dataname,1,1) into :sYn
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 10;

If sYn = 'Y' Then
	cb_1.Visible = True
Else
	cb_1.Visible = False
End If

/*할당자동여부*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)
  INTO :is_autohold  
  FROM "SYSCNFG"  
 WHERE ("SYSCNFG"."SYSGU" = 'S') AND ("SYSCNFG"."SERIAL" = 1) AND ("SYSCNFG"."LINENO" = '50' )   ;

IF SQLCA.SQLCODE <> 0 THEN
	is_autohold = 'N'
ELSE
	IF is_autohold = "" OR IsNull(is_autohold) THEN is_autohold = 'N'
END IF

// 부가세 사업장 설정
	f_mod_saupj(dw_key, 'saupj')
	
wf_protect_key('신규')
end event

type dw_insert from w_inherite`dw_insert within w_sal_06020
boolean visible = false
integer x = 46
integer y = 2600
integer width = 229
integer height = 312
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_sal_06020
integer x = 229
integer y = 16
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\수주취소_d.gif"
end type

event p_delrow::clicked;call super::clicked;Long nRtn

ib_prt = False 

////If this.Text = '수주확정(&E)' Then
//	nRtn = wf_suju_confirm()
//	If nRtn > 0 Then
//		ib_cfm = True
//		rb_upd.Enabled = True
//		tab_1.SelectedTab = 1
//	End If
//Else
	nRtn = wf_suju_cancel()
//End If
//
If nRtn <> 0 THEN	
	wf_protect_key('신규')
   w_mdi_frame.sle_msg.Text = '작업 처리 완료되었습니다'
Else
	w_mdi_frame.sle_msg.Text = ''
End If

/* 할당현황을 인쇄시 */
//If ib_prt = True Then
//	MessageBox('할당완료','일일 할당제품 현황을 발행하세요!!~r~n~r~n할당현황을 발행하시지 않으면 할당이 취소됩니다!!')
//	open(w_sal_06650)
//End If

end event

event p_delrow::ue_lbuttondown;PictureName = "C:\erpman\image\수주취소_dn.gif"
end event

event p_delrow::ue_lbuttonup;PictureName = "C:\erpman\image\수주취소_up.gif"
end event

type p_addrow from w_inherite`p_addrow within w_sal_06020
boolean visible = false
integer x = 1522
integer y = 2572
boolean enabled = false
end type

event p_addrow::clicked;call super::clicked;//버튼명 재고조회


String  sItnbr,sSpec,sMsgRtn, sSujuSts
Integer iCurRow

If tab_1.SelectedTab <> 2 Then Return

tab_1.tabpage_2.dw_insert_2.SetFocus()
iCurRow = tab_1.tabpage_2.dw_insert_2.GetRow()
IF iCurRow <= 0 THEN RETURN
tab_1.tabpage_2.dw_insert_2.SetRow(iCurRow)

IF p_del.Enabled = False THEN
	f_message_chk(56,'~r~r[진행중인 자료는 조회하실 수 없습니다.')
	Return
END IF

//sSujuSts = tab_1.tabpage_2.dw_insert_2.GetItemString(iCurRow,"sorder_suju_sts")
//If IsNull(sSujusts) or Trim(sSujuSts) = '' Then sSujuSts = '1'
//If sSujuSts <> '1' and sSujuSts <> '3' Then
//	f_message_chk(56,'~r~r[진행중인 자료는 조회하실 수 없습니다.')
//	Return
//End If

If tab_1.tabpage_2.dw_insert_2.AcceptText() <> 1 Then Return

sItnbr = tab_1.tabpage_2.dw_insert_2.GetItemString(iCurRow,"itnbr")
sSpec  = tab_1.tabpage_2.dw_insert_2.GetItemString(iCurRow,"order_spec")

IF sItnbr = "" OR IsNull(sItnbr) THEN 
	f_message_chk(30,'[품번]')
	Return
END IF
IF sSpec = "" OR IsNull(sSpec) THEN 
	sSpec = '.'
END IF

OpenWithParm(w_sal_02000_2,sItnbr+'|'+sSpec+'|'+'')
sMsgRtn = Message.StringParm

//IF sMsgRtn <> 'cancle' THEN
//	tab_1.tabpage_2.dw_insert_2.SetItem(iCurRow,"itnbr",sMsgRtn)
//	tab_1.tabpage_2.dw_insert_2.SetColumn("itnbr")
//	tab_1.tabpage_2.dw_insert_2.SetFocus()
//	
//	TriggerEvent(ItemChanged!)
//END IF
//
end event

type p_search from w_inherite`p_search within w_sal_06020
integer x = 55
integer y = 16
boolean enabled = false
string picturename = "C:\erpman\image\수주확정_d.gif"
end type

event p_search::clicked;call super::clicked;Long nRtn

ib_prt = False 

//If this.Text = '수주확정(&E)' Then
	nRtn = wf_suju_confirm()
	If nRtn > 0 Then
		ib_cfm = True
		rb_upd.Enabled = True
		tab_1.SelectedTab = 1
	End If
//Else
//	nRtn = wf_suju_cancel()
//End If
//
If nRtn <> 0 THEN	
	wf_protect_key('신규')
   w_mdi_frame.sle_msg.Text = '작업 처리 완료되었습니다'
Else
	w_mdi_frame.sle_msg.Text = ''
End If

/* 할당현황을 인쇄시 */
//If ib_prt = True Then
//	MessageBox('할당완료','일일 할당제품 현황을 발행하세요!!~r~n~r~n할당현황을 발행하시지 않으면 할당이 취소됩니다!!')
//	open(w_sal_06650)
//End If

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\수주확정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\수주확정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06020
integer x = 3730
integer y = 16
end type

event p_ins::clicked;call super::clicked;String sShipreq,sItnbr,sOrder_spec,sPino,sCvcod
Long   nRow,nMax,ix,itemp,rowcnt

If dw_key.AcceptText() <> 1 Then Return
If wf_check_key() <> 1 Then Return

sCvcod = Trim(dw_key.GetItemString(1, "cvcod"))
	  
Choose Case tab_1.SelectedTab 
	Case 2
		nMax = 1
		rowcnt = tab_1.tabpage_2.dw_insert_2.RowCount()
		If rowcnt > 0 Then
			sItnbr = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(rowcnt,'itnbr'))
			If sItnbr = '' Or IsNull(sItnbr) Then
				f_message_chk(40,'[품번입력]')
				tab_1.tabpage_2.dw_insert_2.SetFocus()
				tab_1.tabpage_2.dw_insert_2.SetRow(rowcnt)
				tab_1.tabpage_2.dw_insert_2.SetColumn('itnbr')
				Return 1
			End If
		
//			sOrder_spec = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(rowcnt,'order_spec'))
//			If sOrder_spec = '' Or IsNull(sOrder_spec) Then
//				tab_1.tabpage_2.dw_insert_2.SetItem(rowcnt,'order_spec','.')
//			End If
		
			For ix = 1 To rowcnt
				itemp = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'piseq')
				nMax = Max(nMax,itemp)
			Next
			nMax = nMax + 1
		End If
		
		If rowcnt >= 999 Then
			MessageBox('확인','품목정보는 999개를 넘을 수 없습니다.!!')
			Return
		End If
		
		sPiNo    = tab_1.tabpage_1.dw_insert_1.GetItemString(1,'pino')
		sshipreq = tab_1.tabpage_1.dw_insert_1.GetItemString(1,'shipreq')
		
		nRow = tab_1.tabpage_2.dw_insert_2.InsertRow(0)
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'sabu', gs_sabu)
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'pino', sPino)
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'piseq',nMax)
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'cust_napgi',sshipreq) //요구납기
		tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'cvcod',sCvcod)
		tab_1.tabpage_2.dw_insert_2.SetFocus()
		tab_1.tabpage_2.dw_insert_2.ScrollToRow(nRow)
		tab_1.tabpage_2.dw_insert_2.SetRow(nRow)
		tab_1.tabpage_2.dw_insert_2.SetColumn('itnbr')
	Case 3
		nRow = tab_1.tabpage_3.dw_insert_3.InsertRow(0)
		
		sPiNo    = tab_1.tabpage_1.dw_insert_1.GetItemString(1,'pino')
		
		tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'sabu',gs_sabu)
		tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'pino',sPino)
End Choose

end event

type p_exit from w_inherite`p_exit within w_sal_06020
integer x = 4425
integer y = 16
end type

type p_can from w_inherite`p_can within w_sal_06020
integer x = 4251
integer y = 16
end type

event clicked;call super::clicked;wf_protect_key('신규')

//string	sNull
//SetNull(sNull)
//
//dw_key.SetItem(1, "cvcod", 	sNull)
//dw_key.SetItem(1, "cvcodnm", 	sNull)
//dw_key.SetItem(1, "saupj", 	sNull)
//
end event

type p_print from w_inherite`p_print within w_sal_06020
boolean visible = false
integer x = 1001
integer y = 2572
boolean enabled = false
end type

event p_print::clicked;call super::clicked;//버튼명 원가비교

string  s_pidate,s_cvcod
int     nRow,ix
dec {2} d_wrate

If tab_1.tabpage_1.dw_insert_1.AcceptText() <> 1 Then Return
If tab_1.tabpage_2.dw_insert_2.AcceptText() <> 1 Then Return

s_pidate = Trim(dw_key.GetItemString(dw_key.GetRow(),'pidate'))
If IsNull(s_pidate) Or s_pidate = '' Then
   f_message_chk(1400,'[발행일]')
   Return 1
End If

s_cvcod = Trim(dw_key.GetItemString(dw_key.GetRow(),'cvcod'))
If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(40,'[거래처]')
   Return 1
End If

gs_code  = Left(s_pidate,6)
gs_gubun = String(dw_key.GetItemNumber(dw_key.GetRow(),'wrate'))   // 환율
OpenWithParm(w_sal_02000_10,tab_1.tabpage_2.dw_insert_2)

end event

type p_inq from w_inherite`p_inq within w_sal_06020
integer x = 3557
integer y = 16
end type

event p_inq::clicked;call super::clicked;string spino, sPiSts
Long   nRow, ix, nRtn, nCnt, ncount, nRow2Count
dec    dInvQty, dCiQty

/* 신규이면 조회불가 */
If rb_new.Checked = True Then Return

If dw_key.AcceptText() <> 1 then Return
//
nRow  = tab_1.tabpage_1.dw_insert_1.GetRow()
If nRow <=0 Then Return
	  
spino = Trim(dw_key.GetItemString(nRow,'pino'))
If IsNull(spino) Or spino = '' Then
   f_message_chk(1400,'[P/I NO]')
	Return 1
End If

dw_key.Retrieve(gs_sabu,spino)
ncount = tab_1.tabpage_1.dw_insert_1.Retrieve(gs_sabu,spino)
If ncount <= 0 Then
	f_message_chk(50,'')
	wf_protect_key('신규')
	return
else
	if tab_1.tabpage_1.dw_insert_1.getitemstring(1, "exppih_sugugb") = 'Y' then
		MessageBox("대체P/I", "수출대체로 발생한P/I이므로 수정할 수 없읍니다", stopsign!)
		rb_new.triggerevent(clicked!)
		return
	End if
End If

//dw_key.ResetUpdate()
//tab_1.tabpage_1.dw_insert_1.ResetUpdate()
nRow2Count = tab_1.tabpage_2.dw_insert_2.Retrieve(gs_sabu,spino)  // 품목정보 조회

tab_1.tabpage_2.dw_insert_2_fuso.Retrieve(gs_sabu,spino)  // Fuso 업제 PO 정보 조회

string sCvcod, sItnbr

sCvcod = dw_key.GetItemString(1, "cvcod")
if nRow2Count > 0 then
	sItnbr = trim(tab_1.tabpage_2.dw_insert_2.GetItemString(1, "itnbr"))
end if
if isNull(sItnbr) then sItnbr = ""

if sCvcod = "205005" then
	tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("itnbr = '" + sItnbr + "'")
	tab_1.tabpage_2.dw_insert_2_fuso.Filter()
else
	tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("")
	tab_1.tabpage_2.dw_insert_2_fuso.Filter()
end if

tab_1.tabpage_3.dw_insert_3.Retrieve(gs_sabu,spino)  // Charge 조회

wf_protect_key('조회')
ib_any_typing = False

/* 수주 확정 여부 */
//SELECT DISTINCT SUBSTR(ORDER_NO,1,11) INTO :sOrderNo
 SELECT COUNT(*), SUM(INVOICE_QTY) INTO :nCnt, :dInvQty
  FROM SORDER
 WHERE SABU = :gs_sabu and
       PINO = :sPiNo and
		 SUJU_STS <> '4';


spists = dw_key.GetItemString(1,'pists') // 상태
If nCnt = 0 and ( spists = '1' Or spists = '3' ) Then     // 견적및 보류
	 p_search.Enabled = True	//수주확정버튼
	 p_delrow.Enabled = False	//수주취소버튼
    p_del.Enabled = True
	 p_search.PictureName = "C:\erpman\image\수주확정_up.gif"	//수주확정버튼
	 p_delrow.PictureName = "C:\erpman\image\수주취소_d.gif"	//수주취소버튼
    p_del.PictureName = "C:\erpman\image\삭제_up.gif"
Else
	If nCnt > 0 Then
		ib_cfm = True
//		p_search.Text = '수주취소(&E)'
		p_del.Enabled = False
	 	p_search.Enabled = False	//수주확정버튼
	 	p_delrow.Enabled = True	   //수주취소버튼
    	p_del.Enabled = False
	 	p_search.PictureName = "C:\erpman\image\수주확정_d.gif"	//수주확정버튼
	 	p_delrow.PictureName = "C:\erpman\image\수주취소_up.gif"	//수주취소버튼
    	p_del.PictureName = "C:\erpman\image\삭제_d.gif"

		/* 구매진행 현황 조회 */
		tab_1.tabpage_4.dw_insert_4.Retrieve(gs_sabu, sPino+'%')
		
		/* 자동할당이면서 출고의뢰된 내역이 없으면 수주취소 가능 */
		If is_autohold = 'Y' And dInvQty = 0 Then
			SELECT SUM(CIQTY) INTO :dCiqty FROM EXPCID WHERE SABU = :gs_sabu AND PINO = :sPino;
			If IsNull(dCiqty) Or dCiqty = 0 Then Return
		End If

		/* 수주진행중이 1건 이상이면 수주취소 불가 */
		For ix = 1 To tab_1.tabpage_2.dw_insert_2.RowCount()
			nRtn = wf_suju_status(ix)
			If nRtn > 0 Or nRtn = -1 Then
				p_delrow.Enabled = False	//수주취소버튼
				p_delrow.PictureName = "C:\erpman\image\수주취소_d.gif"	//수주취소버튼
				Return
			End If
		Next
		
		p_delrow.Enabled = True	//수주취소버튼
		p_delrow.PictureName = "C:\erpman\image\수주취소_up.gif"	//수주취소버튼
	/* ---------------------------------------  */
	Else
		f_message_chk(52,'[수주번호]')
		wf_protect_key('신규')
		p_search.Enabled = False	//수주확정버튼
	 	p_delrow.Enabled = False	//수주취소버튼
	 	p_search.PictureName = "C:\erpman\image\수주확정_d.gif"	//수주확정버튼
	 	p_delrow.PictureName = "C:\erpman\image\수주취소_d.gif"	//수주취소버튼
		return 
	End If
End If
end event

type p_del from w_inherite`p_del within w_sal_06020
integer x = 4078
integer y = 16
end type

event p_del::clicked;call super::clicked;string spino, pi_seq, s_chagu, sOrderNo,sOrderMemo, sNull
Long   nRtn, nRow, nCnt, ix

SetNull(sNull)

Choose Case tab_1.selectedtab
	Case 1                                // 일반정보 삭제
		nRow  = tab_1.tabpage_1.dw_insert_1.GetRow()
		If nRow <=0 Then Return
		
		spino = Trim(dw_key.GetItemString(nRow,'pino'))
		If IsNull(spino) Or spino = '' Then
			f_message_chk(1400,' P/I NO')
			Return 1
		End If
		
		IF MessageBox("삭 제",spino + "의 모든 자료가 삭제됩니다." +"~n~n" +&
							"삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
		
		tab_1.tabpage_1.dw_insert_1.DeleteRow(nRow)
		If tab_1.tabpage_1.dw_insert_1.Update() = 1 Then 
			delete exppid  where sabu = :gs_sabu and   pino = :spino ;
			If sqlca.sqlcode  = 0 Then 
				delete exppich   where sabu = :gs_sabu and   pino = :spino ;
				COMMIT;
				sle_msg.text ='자료를 삭제하였습니다!!'
			End If
			wf_protect_key('신규')
			Return
		End IF
		
		rollback;
		return
	Case 2                               // 품목정보 개별 삭제
		nRow  = tab_1.tabpage_2.dw_insert_2.GetRow()
		If nRow <=0 Then Return
		
		nRtn = wf_suju_status(nRow)
		If nRtn = -1 Or nRtn > 0 Then  /* 완료,마감, 진행 -> 삭제불가  */
			f_message_chk(57,'')
			dw_insert.SetRow(nRow)
			dw_insert.ScrollToRow(nRow)
			Return
		End If
		
		Choose Case tab_1.tabpage_2.dw_insert_2.GetItemStatus(nRow, 0, Primary!)
			/* 신규입력자료 삭제 */
			Case New!, NewModified!
				IF F_Msg_Delete() = -1 THEN Return
				
				tab_1.tabpage_2.dw_insert_2.DeleteRow(nRow)
				sle_msg.text ='자료를 삭제하였습니다!!'
				Return
			Case Else
				/* 수정자료 삭제 */
				/* 수주(sorder) 삭제 */
				nCnt = tab_1.tabpage_2.dw_insert_2.Rowcount()
				sOrderNo = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'sorder_order_no'))
				pi_seq = String((tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,'piseq')))

				IF MessageBox("삭 제","SEQ : " + pi_seq + "의  자료가 삭제됩니다." +"~n~n" +&
								  "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
					
				/* 수주확정안된 경우 exppid만 delete */
				If IsNull(sOrderNo) or sOrderNo = '' Then
					If tab_1.tabpage_2.dw_insert_2.DeleteRow(nRow) = 1 Then
						IF tab_1.tabpage_2.dw_insert_2.Update() <> 1 THEN
							ROLLBACK;
							Return
						END IF
					End If
					
					COMMIT;
				Else					
					/* 수주확정건이 1건이면 수주취소 */
					If nCnt = 1 Then 
						tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'ordcfdt',sNull)
						tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'pists','1')    // 수주 견적
					End If
				
					DELETE FROM sorder
					 where sabu = :gs_sabu and
							 order_no = :sOrderNo and
							 suju_sts < '4';

					If sqlca.sqlcode <> 0 Then
						RollBack;
						f_message_chk(160,'[수주번호 : ' + sOrderNo + ']')
						return
					End If
		
					tab_1.tabpage_2.dw_insert_2.DeleteRow(nRow)
				End If
			
				/* 수출금액,원화금액,외화금액 계산 */
				wf_set_piamt()
				IF tab_1.tabpage_2.dw_insert_2.Update() <> 1 THEN
					ROLLBACK;
					Return
				END IF
	
				If tab_1.tabpage_1.dw_insert_1.Update() = 1 Then 
					COMMIT;
				Else
					RollBack;
					f_message_chk(31,'')
					Return 
				End If
			End Choose
			
		/* 삭제후 header 재조회 */
		spino = Trim(dw_key.GetItemString(1,'pino'))
		If tab_1.tabpage_1.dw_insert_1.Retrieve(gs_sabu,spino) <= 0 Then
			f_message_chk(50,'')
			wf_protect_key('신규')
			return 
		End If
		
		sle_msg.text ='자료를 삭제하였습니다!!'
	Case 3                               // CHARGE 정보 개별 삭제
		nCnt  = tab_1.tabpage_3.dw_insert_3.RowCount()
		nRow  = tab_1.tabpage_3.dw_insert_3.GetRow()
		If nRow <=0 Then Return
		
		For ix = nCnt to 1 step -1
			spino   = Trim(tab_1.tabpage_3.dw_insert_3.GetItemString(ix,'pino'))
			s_chagu = Trim(tab_1.tabpage_3.dw_insert_3.GetItemSTring(ix,'chrgu'))
			
			Choose Case tab_1.tabpage_3.dw_insert_3.GetItemStatus(ix, 0, Primary!)
				/* 신규자료인 경우 키를 입력안하면 무조건 삭제 */
				Case New!,NewModified!
					If nRow = ix Then 
						tab_1.tabpage_3.dw_insert_3.DeleteRow(ix)
					ElseIf IsNull(s_chagu) or s_chagu = '' Then
						tab_1.tabpage_3.dw_insert_3.DeleteRow(ix)
					End If
					
					Return
				/* 기존자료인 경우 삭제하려는 Row만 삭제 */
				Case Else
					If nRow = ix Then
						/* Ci charge에서 사용중이면 삭제불가 */
						select count(*) into :ncnt
						  from expcich
						 where sabu = :gs_sabu and
								 pino = :sPino and
								 chrgu = :s_chagu;
						If nCnt > 0 Then
							MessageBox('확 인','Ci Charge에서 사용중인 자료는 삭제하실 수 없습니다')
							Return
						End If
						
						IF MessageBox("삭 제","SEQ : " + String(nRow) + "행의  자료가 삭제됩니다." +"~n~n" +&
						"삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
						
						If tab_1.tabpage_3.dw_insert_3.DeleteRow(ix) <> 1 Then
							RollBack;
							Return
						End If
					End If
			End Choose
		Next
	
		/* 수출금액,원화금액,외화금액 계산 */
		wf_set_piamt()
		IF tab_1.tabpage_3.dw_insert_3.Update() <> 1 THEN
			ROLLBACK;
			Return
		END IF
		
		If tab_1.tabpage_1.dw_insert_1.Update() = 1 Then 
			sle_msg.text ='자료를 삭제하였습니다!!'
			COMMIT;
			Return
		Else
			RollBack;
			f_message_chk(31,'')
			Return 
		End If
		
		sle_msg.text ='자료를 삭제하였습니다!!'
End Choose

end event

type p_mod from w_inherite`p_mod within w_sal_06020
integer x = 3904
integer y = 16
end type

event p_mod::clicked;call super::clicked;string  sPino,sPiDate,sItnbr,sChrgu,sOrderSpec,sCvcod,sPists,sCurr, sSugugb
Long    nRow,ix, nCnt, nLen
dec	  dPiQty, dPiamt
String  sSaupj, sPangb, sOutgu, sCustNapgi, sShipReq, sAmtgu

If dw_key.AcceptText() <> 1 Then Return
If tab_1.tabpage_1.dw_insert_1.AcceptText() <> 1 Then Return
If tab_1.tabpage_2.dw_insert_2.AcceptText() <> 1 Then Return
If tab_1.tabpage_3.dw_insert_3.AcceptText() <> 1 Then Return

//--------------------------------------------------------------  
nRow  = tab_1.tabpage_1.dw_insert_1.RowCount()
If nRow <=0 Then Return

If wf_check_key() <> 1 Then Return

sPiDate = Trim(dw_key.GetItemString(1,'pidate'))
sPists  = Trim(dw_key.GetItemString(1,'pists'))
sCurr   = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(1,'curr'))

/* 전표번호 채번(수주와 동일하게 채번) */
If rb_new.Checked = True  Then
	If is_junpyo_gb = 'Y' Then
		sPino = wf_get_junpyo_no(sPiDate, 'S0' )
		dw_key.SetItem(nRow,'sabu',gs_sabu)
		dw_key.SetItem(nRow,'pino',sPino)
	Else
		sPino = Trim(dw_key.GetItemString(1,'pino'))
			
		/* 기존 등록 유무 확인 */
		SELECT COUNT(PINO) INTO :nCnt FROM EXPPIH
		 WHERE SABU = :gs_sabu AND
			   PINO = :sPino;
			 
		If nCnt <> 0 Then
			nLen = Len(sPino)
			
			 SELECT COUNT(*) INTO :nCnt FROM SORDER
			  WHERE SABU = :gs_sabu AND
					  substr(ORDER_NO,1,:nLen) = :sPino and
					  LENGTH(ORDER_NO) = :nLen+3;
			If nCnt <> 0 Then
				f_message_chk(1,'[P/I No.]')
				SetNull(sPino)
				dw_key.SetItem(1,'pino',sPino)
				
				dw_key.SetFocus()
				dw_key.SetRow(nRow)
				dw_key.SetColumn('pino')
				Return
			End If
		End If
		
		dw_key.SetItem(nRow,'sabu',gs_sabu)
	End If
Else
	 sPino = Trim(dw_key.GetItemString(1,'pino'))
End If

If IsNull(sPino) Or sPino = '' Then
   f_message_chk(40,'[P/I No.]')
   Return 1
End If
tab_1.tabpage_1.dw_insert_1.setitem(1, "pino", spino)

sCvcod = Trim(dw_key.GetItemString(1,'cvcod'))
If IsNull(sCvcod) Or sCvcod = '' Then
   f_message_chk(40,'[거래처]')
   Return 1
End If
tab_1.tabpage_1.dw_insert_1.setitem(1, "cvcod", scvcod)

sSaupj = Trim(dw_key.GetItemString(1,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
   f_message_chk(40,'[부가사업장]')
   Return 1
End If
tab_1.tabpage_1.dw_insert_1.setitem(1, "saupj", ssaupj)
tab_1.tabpage_1.dw_insert_1.setitem(1, "pidate", spidate)

/* detail, charge 수출금액,원화금액,외화금액 계산 */
wf_set_piamt()

//-------------------------------------------------------------- 품번,spec,amt 입력확인
nRow  = tab_1.tabpage_2.dw_insert_2.RowCount()
tab_1.tabpage_2.dw_insert_2.SetFocus()
For ix = nRow To 1 Step -1
	Choose Case tab_1.tabpage_2.dw_insert_2.GetItemStatus(ix,0,Primary!)
		Case New!
			tab_1.tabpage_2.dw_insert_2.DeleteRow(ix)
			Continue
	End Choose
	
	sItnbr = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'itnbr'))
	If sItnbr = '' Or IsNull(sItnbr) Then
		tab_1.tabpage_2.dw_insert_2.DeleteRow(ix)
		Continue
	End If

	/* 필수체크 */
	sOrderSpec = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'order_spec'))
	If sOrderSpec = '' Or IsNull(sOrderSpec) Then
		f_message_chk(40,'[사양]')
		tab_1.tabpage_2.dw_insert_2.SetRow(ix)
		tab_1.tabpage_2.dw_insert_2.SetColumn('order_spec')
		Return
	End If
  
	dPiQty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'piqty')
	If dPiqty = 0 Or IsNull(dPiQty) Then
		f_message_chk(78,'')		
		tab_1.tabpage_2.dw_insert_2.SetRow(ix)
		tab_1.tabpage_2.dw_insert_2.SetColumn('piqty')
		Return
	End If

	////////////////////////////////////////////////////////////////////////
	// 유상인 경우만 금액 체크
	////////////////////////////////////////////////////////////////////////
	sAmtgu = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'amtgu'))
	
	dPiamt = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'piamt')
	If sAmtgu = 'Y' Then
		If dPiamt = 0 Or IsNull(dPiamt) Then
			f_message_chk(1400,'[금액]')		
			tab_1.tabpage_2.dw_insert_2.SetRow(ix)
			tab_1.tabpage_2.dw_insert_2.SetColumn('piamt')
			Return
		End If
	End If	
	
//	sPangb = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'pangb'))
//	If sPangb = '' Or IsNull(sPangb) Then
//		f_message_chk(40,'[판매구분]')
//		tab_1.tabpage_2.dw_insert_2.SetRow(ix)
//		tab_1.tabpage_2.dw_insert_2.SetColumn('pangb')
//		Return
//	End If
	
	sOutgu = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'out_gu'))
	If sOutgu = '' Or IsNull(sOutgu) Then
		f_message_chk(40,'[수불구분]')
		tab_1.tabpage_2.dw_insert_2.SetRow(ix)
		tab_1.tabpage_2.dw_insert_2.SetColumn('out_gu')
		Return
	End If
	
	/* 수주구분 */
	sSugugb = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'sugugb'))
	If IsNull(sSugugb) or sSugugb = '' Then
		f_message_chk(1400,'[수주구분]')
		tab_1.tabpage_2.dw_insert_2.SetRow(ix)
		tab_1.tabpage_2.dw_insert_2.SetColumn('sugugb')
		Return
	End If

	sCustNapgi = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'cust_napgi'))
	If sCustNapgi = '' Or IsNull(sCustNapgi) Then
		f_message_chk(40,'[요구납기]')
		tab_1.tabpage_2.dw_insert_2.SetRow(ix)
		tab_1.tabpage_2.dw_insert_2.SetColumn('cust_napgi')
		Return
	End If
Next

nRow  = tab_1.tabpage_2.dw_insert_2.RowCount()
For ix = 1 To nRow
	If tab_1.tabpage_2.dw_insert_2.GetItemStatus(ix,0,Primary!) = NewModified! Then
		tab_1.tabpage_2.dw_insert_2.SetItem(ix,'pino',sPino)
	End If
Next

If nRow > 0 Then
	IF tab_1.tabpage_2.dw_insert_2.Update() <> 1 THEN
		ROLLBACK;
		f_message_chk(32,'[품목정보]')
		Return
	END IF
End If

if sCvcod = "205005" then
	nRow  = tab_1.tabpage_2.dw_insert_2_fuso.RowCount()
	For ix = 1 To nRow
		If tab_1.tabpage_2.dw_insert_2_fuso.GetItemStatus(ix,0,Primary!) = NewModified! Then
			tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ix,'pino',sPino)
		End If
	Next
	
	If nRow > 0 Then
		IF tab_1.tabpage_2.dw_insert_2_fuso.Update() <> 1 THEN
			ROLLBACK;
			f_message_chk(32,'[PO정보]')
			Return
		END IF
	End If
end if

//--------------------------------------------------------------  charge 정보 저장
nRow  = tab_1.tabpage_3.dw_insert_3.RowCount()
For ix = nRow To 1 Step -1
  sChrgu = Trim(tab_1.tabpage_3.dw_insert_3.GetItemString(ix,'chrgu'))
  If IsNull(sChrgu) Or sChrgu = '' Then
    tab_1.tabpage_3.dw_insert_3.DeleteRow(ix)
	 continue
  End If
	
   tab_1.tabpage_3.dw_insert_3.SetItem(ix,'pino',sPino)
Next

IF tab_1.tabpage_3.dw_insert_3.Update() <> 1 THEN
	ROLLBACK;
	f_message_chk(32,'[비용정보]')
	Return
END IF

/* ------------------------------------------------ 일반정보 저장 */
IF tab_1.tabpage_1.dw_insert_1.Update() <> 1 THEN
   ROLLBACK;
	f_message_chk(32,'[일반정보]')
   Return
END IF

/* -------------------------------------------------------------- */

/* 수주 변경자료 수정 */
If sPists = '2' or sPists = '9' and tab_1.tabpage_2.dw_insert_2.RowCount() > 0 then
	String sOrdcfdt, sDepotNo, sHouseNo
	
	Setpointer(HourGlass!)
	
	sOrdcfdt = dw_key.GetItemString(1, 'ordcfdt')
	sDepotNo = tab_1.tabpage_2.dw_insert_2.GetItemString(1, 'sorder_depot_no')
	sHouseNo = tab_1.tabpage_2.dw_insert_2.GetItemString(1, 'sorder_house_no')
	nCnt = sqlca.fun_erp100000080(gs_sabu, sPino, sOrdcfdt, String(sDepotNo,'@@@@@@') + String(sHouseNo,'@@@@@@'))
	If sqlca.sqlcode <> 0 Then
		MessageBox(sqlca.sqlerrtext,'[수주확정을 실패하였습니다]')
		RollBack;
		Return -1
	End If
End If

COMMIT;

rb_upd.Checked = True
p_inq.TriggerEvent(Clicked!)

MessageBox('확 인','저장되었습니다.!!')

w_mdi_frame.sle_msg.text ='저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_06020
integer x = 3218
integer y = 2680
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_sal_06020
integer x = 2190
integer y = 2680
integer taborder = 90
end type

type cb_ins from w_inherite`cb_ins within w_sal_06020
integer x = 494
integer y = 2680
integer taborder = 50
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06020
integer x = 2533
integer y = 2680
integer taborder = 100
end type

type cb_inq from w_inherite`cb_inq within w_sal_06020
integer x = 146
integer y = 2680
end type

type cb_print from w_inherite`cb_print within w_sal_06020
integer x = 2414
integer y = 2536
end type

type st_1 from w_inherite`st_1 within w_sal_06020
end type

type cb_can from w_inherite`cb_can within w_sal_06020
integer x = 2875
integer y = 2680
integer taborder = 110
end type

type cb_search from w_inherite`cb_search within w_sal_06020
integer x = 1765
integer y = 2680
integer width = 416
boolean enabled = false
string text = "수주확정(&E)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06020
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06020
end type

type tab_1 from tab within w_sal_06020
integer x = 46
integer y = 420
integer width = 4571
integer height = 1868
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;if tab_1.selectedtab = 1 then 
	pb_3.visible = true 
	pb_4.visible = true 
	pb_5.visible = true 
else 
	pb_3.visible = false 
	pb_4.visible = false 
	pb_5.visible = false 
end if

if tab_1.selectedtab = 2 then
	string sCvcod
	sCvcod = dw_key.GetItemString(1, "cvcod")
	if sCvcod = "205005" then
		tab_1.tabpage_2.dw_insert_2_fuso.visible = true
		tab_1.tabpage_2.ln_1.visible = true
//		cb_ins_fuso.visible = true
//		cb_del_fuso.visible = true
		tab_1.tabpage_2.dw_insert_2.width = 3173
	else
		tab_1.tabpage_2.dw_insert_2_fuso.visible = false
		tab_1.tabpage_2.ln_1.visible = false
//		cb_ins_fuso.visible = false
//		cb_del_fuso.visible = false
		tab_1.tabpage_2.dw_insert_2.width = 4462
	end if
end if

If rb_upd.Enabled = True And ib_cfm = True Then         // 수정,확정
  Choose Case newindex 
	Case  1
	  p_inq.Enabled = False     //조회
	  p_ins.Enabled = False     //추가 
	  p_mod.Enabled = True      //저장
	  p_del.Enabled = False     //삭제
		
		p_suju.Visible = False
	Case  2
	  p_inq.Enabled = False     //조회

		/* 품목추가 여부 : 승인건이 있으면 추가 불가 */
		If tabpage_2.dw_insert_2.GetItemNumber(1,'sujucnt') > 0 Then
			p_ins.Enabled = False
		Else
			p_ins.Enabled = True
		End If
	
	  p_mod.Enabled = True      //저장
//	  p_del.Enabled = False     //삭제

    p_suju.Visible = True
	  Long nRtn
 
     If tab_1.tabpage_2.dw_insert_2.RowCount() > 0 Then
		 tab_1.tabpage_2.dw_insert_2.SetFocus()
	    tab_1.tabpage_2.dw_insert_2.ScrollToRow(1)
		 tab_1.tabpage_2.dw_insert_2.SetRow(1)

       nRtn = wf_suju_status(1)

       If nRtn = -1 Or nRtn > 0 Then  /* 완료,마감, 진행 -> 삭제불가  */
         p_del.Enabled = False
       Else
	      p_del.Enabled = True
       End If
	  End If
   Case 3
	  p_inq.Enabled = False     //조회
	  p_ins.Enabled = True      //추가 
	  p_mod.Enabled = True      //저장
	  p_del.Enabled = True      //삭제
		
		p_suju.Visible = False
  End Choose
Else
  p_inq.Enabled = True      //조회
  p_ins.Enabled = True      //추가 
  p_mod.Enabled = True      //저장
  p_del.Enabled = True      //삭제
	
	p_suju.Visible = False
End If

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4535
integer height = 1756
long backcolor = 32106727
string text = "일반정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_insert_1 dw_insert_1
end type

on tabpage_1.create
this.rr_1=create rr_1
this.dw_insert_1=create dw_insert_1
this.Control[]={this.rr_1,&
this.dw_insert_1}
end on

on tabpage_1.destroy
destroy(this.rr_1)
destroy(this.dw_insert_1)
end on

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 24
integer width = 4494
integer height = 1720
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert_1 from u_key_enter within tabpage_1
event ue_key pbm_dwnkey
integer x = 82
integer y = 28
integer width = 4402
integer height = 1708
integer taborder = 10
string dataobject = "d_sal_06020_h"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
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

event rbuttondown;Long nRow

SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)

nRow = GetRow()
Choose Case GetColumnName()
	Case 'areacd'
		open(w_nation_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		This.SetItem(nRow,'areacd',gs_code)
		This.SetItem(nRow,'area_areanm',gs_codename)
	Case 'deptcode'
		open(w_vndmst_4_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		This.SetItem(nRow,'deptcode',gs_code)
/* 영업담당자 */
//	Case 'emp_id'
//		Gs_Gubun = Trim(GetItemString(nRow,'deptcode'))
//		open(w_sawon_popup)
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		This.SetItem(nRow,'emp_id',gs_code)		
//		This.SetItem(nRow,'p1_master_empname',gs_codename)
	Case 'agent'
		gs_gubun = '2'
		open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		This.SetItem(nRow,'agent',gs_code)		
		This.SetItem(nRow,'vndmst_cvnas2',gs_codename)				
End Choose

end event

event itemchanged;Long   nRow
string sData,rData,sDate,sPiSangHo,sAddr,sNull

SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

sData = Trim(GetText())
Choose Case GetColumnName()
	Case 'areacd'
		select areanm into :rData from area where areacd = :sData ;
		If Trim(rData) = '' Then 
	      This.SetItem(1,'areacd',sNull)
	      This.SetItem(1,'area_areanm',sNull)
			Return 1
		Else	
	      This.SetItem(1,'area_areanm',rData)
      End If
	Case 'deptcode'
      select fun_get_dptno(:sData) into :rData from dual;
		If Trim(rData) = '' Then 
   		This.SetItem(nRow,'deptcode',sNull)
			Return 1
		Else	
   		This.SetItem(nRow,'deptcode',rData)
      End If		

	Case 'emp_id'   /* 담당자 입력시 기존 자사명,자사주소를 copy한다*/
//      select fun_get_empno(:sData) into :rData from dual;
//		If Trim(rData) = '' Or IsNull(rData) Then 
//		   This.SetItem(nRow,'emp_id',sNull)
//		   This.SetItem(nRow,'p1_master_empname',sNull)
//		   This.SetItem(nRow,'pisangho',sNull)
//		   This.SetItem(nRow,'piaddr',sNull)
//			Return 1
//		End If
		
//		This.SetItem(nRow,'p1_master_empname',rData)

		select pisangho,piaddr  into :sPisangHo, :sAddr from exppih
       where pino = ( select max(pino)  from exppih where emp_id = :sData );

		This.SetItem(nRow,'pisangho',sPisangho)
		This.SetItem(nRow,'piaddr',sAddr)
		Return
	Case 'agent'
      select fun_get_cvnas(:sData) into :rData from dual;
		If Trim(rData) = '' Then 
		   This.SetItem(nRow,'agent',sNull)
		   This.SetItem(nRow,'vndmst_cvnas2',sNull)
			Return 1
		Else	
		   This.SetItem(nRow,'vndmst_cvnas2',rData)
      End If		
	Case 'shipsch','invsch','shipreq'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
			SetItem(nRow, GetColumnName(), sNull)
	      Return 1
      END IF
	Case 'curr'
		sDate = dw_key.GetItemString(dw_key.GetRow(),'pidate')

      wf_calc_curr(nRow,sDate,sData)      // 환율 계산및 설정
End Choose

ib_any_typing = True

end event

event itemerror;return 1
end event

event ue_pressenter;Choose Case GetColumnName()
	Case'piattn','piaddr','pinotes'
	     return 0
	Case Else
        Send(Handle(this),256,9,0)
		  Return 1
End Choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4535
integer height = 1756
long backcolor = 32106727
string text = "품목정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_insert_2 dw_insert_2
dw_insert_2_fuso dw_insert_2_fuso
ln_1 ln_1
end type

on tabpage_2.create
this.rr_2=create rr_2
this.dw_insert_2=create dw_insert_2
this.dw_insert_2_fuso=create dw_insert_2_fuso
this.ln_1=create ln_1
this.Control[]={this.rr_2,&
this.dw_insert_2,&
this.dw_insert_2_fuso,&
this.ln_1}
end on

on tabpage_2.destroy
destroy(this.rr_2)
destroy(this.dw_insert_2)
destroy(this.dw_insert_2_fuso)
destroy(this.ln_1)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 24
integer width = 4494
integer height = 1720
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert_2 from u_key_enter within tabpage_2
event ue_key pbm_dwnkey
integer x = 37
integer y = 36
integer width = 4462
integer height = 1700
integer taborder = 10
string dataobject = "d_sal_06020_d"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;choose case key
	Case keyF1!
	   TriggerEvent(RbuttonDown!)
	case KeyEnter! 
		if this.getcolumnname() = "itemno" and this.rowcount() = this.getrow() and cb_ins.Enabled = True then
			cb_ins.postevent(clicked!)
			return 1
		end if
end choose
end event

event editchanged;ib_any_typing = True
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

event itemchanged;string sItnbr,sItdsc,sIspec,sUnmsr,sDepotNo_no,sNull,sOrderSpec, sItnbrGbn, sItnbrYn
Long   nRow,nRtn, iSeqNo
string s_pidate,s_cvcod,s_curr,s_pricegbn,s_pre_napgi
double d_danga,d_piamt,d_piqty,d_piprc,d_dc_rate,d_itmprc
Double dHoldQty, dItemQty, dItemOldQty, nNapQty, dPackQty
String sOutgu, sJepumio, sSalegu, sJijil, sIspecCode, sPangbn, sCvcod, sBudsc, sBunBr
Dec    dSeqno

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

/* 수주상태 check */
dHoldQty = wf_suju_status(nRow)

Choose Case GetColumnName()
	/* 품번 */
	Case   "itnbr"
		sItnbr = Trim(GetText())
		IF sItnbr = ""	or	IsNull(sItnbr)	THEN
			Wf_Clear_Item(nRow)
			SetColumn("itnbr")
			tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("itnbr = ''")
			tab_1.tabpage_2.dw_insert_2_fuso.Filter()
			RETURN 
		END IF
		
		SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",      "ITEMAS"."UNMSR",	 "ITEMAS"."ITTYP",
		       "ITEMAS"."JIJIL",   "ITEMAS"."ISPEC_CODE", "ITEMAS"."PANGBN",  "ITEMAS"."PACKQTY"
		  INTO :sItDsc,   		   :sIspec, 		     :sUnmsr,            :sItnbrGbn,
		       :sJijil,            :sIspecCode,        :sPangbn,				 :dPackQty
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' AND	"ITEMAS"."GBWAN" = 'Y' ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		/* 입력가능여부 */
		SELECT DECODE(RFNA2,'N',RFNA2,'Y') INTO :sItnbrYn
		  FROM REFFPF  
		 WHERE RFCOD = '05' AND     RFGUB <> '00' AND RFGUB = :sItnbrGbn;
		
		If IsNull(sItnbrYn) Then sItnbr = 'Y'
		
		If sItnbrYN = 'N' Then
			f_message_chk(58,'')
			Wf_Clear_Item(nRow)
			Return 1
		End If
		
		setitem(nRow, "itdsc", sItdsc)
		setitem(nRow, "ispec", sIspec)
		setitem(nRow, "ispec_code", sIspecCode)
		setitem(nRow, "jijil", sJijil)
		setitem(nRow, "itemas_unmsr", sUnmsr)
		setitem(nRow, "pangb", sPangbn)
		
		tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("itnbr = '" + data + "'")
		tab_1.tabpage_2.dw_insert_2_fuso.Filter()
		
		// 관리품번 min값을 설정
		sCvcod = dw_key.GetItemString(1, 'cvcod')
		select min(seqno) into :dseqno from itmbuy where itnbr = :sItnbr and cvcod = :sCvcod;
		SetItem(nRow, 'seqno', dSeqno)
		
		/* 단가 계산 */
		sOrderSpec = GetItemString(nRow,'order_spec')
		d_piqty	  = GetItemNumber(nRow,'piqty')
		nRtn = wf_catch_danga(nRow,sItnbr, sOrderSpec, d_piqty)
		If nRtn = -1 Then 
			Wf_Clear_Item(nRow)
			tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("itnbr = ''")
			tab_1.tabpage_2.dw_insert_2_fuso.Filter()
			Return 1
		End If
		
		SetItem(nRow,"piqty",0)
		SetItem(nRow,"piamt",0)
		SetItem(nRow,'pre_napgi','')
		
		sle_msg.Text = '포장단위 수량 : ' + String(dPackQty)
		
		SetColumn("piqty")
	/* 품명 */
	Case  "itdsc"
		sItdsc = Trim(GetText())
		IF sItdsc = ""	or	IsNull(sItdsc)	THEN
			Wf_Clear_Item(nRow)
			SetColumn("itdsc")
			RETURN 
		END IF
		
	  /* 품명으로 품번찾기 */
	  f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("itdsc")
			Return 1
		End If	
	
		SetColumn("piqty")
	/* 규격 */
	Case  "ispec"
		sIspec = trim(GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			Wf_Clear_Item(nRow)
			SetColumn("ispec")
			RETURN 
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("ispec")
			Return 1
		End If
		
		SetColumn('piqty')
	/* 재질 */
	Case  "jijil"
		sJijil = trim(GetText())	
		IF sJijil = ""	or	IsNull(sJijil)	THEN
			Wf_Clear_Item(nRow)
			SetColumn("jijil")
			RETURN 
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("jijil")
			Return 1
		End If
		
		SetColumn('piqty')
	/* 규격코드 */
	Case  "ispec_code"
		sIspeccode = trim(GetText())	
		IF sIspeccode = ""	or	IsNull(sIspeccode)	THEN
			Wf_Clear_Item(nRow)
			SetColumn("ispec_code")
			RETURN 
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			Wf_Clear_Item(nRow)
			this.SetColumn("ispec_code")
			Return 1
		End If
		
		SetColumn('piqty')
	/* 수량 */
	Case  "piqty"
		dItemQty    = Double(GetText())
		dItemOldQty = GetItemNumber(nRow,'piqty')
		IF dItemQty = 0 OR IsNull(dItemQty) THEN 
			f_message_chk(93,'~r~n~r~n[취소작업은 수주승인화면에서 가능합니다]~r~n')
			SetItem(nRow,'piqty',dItemOldQty)
			SetFocus()
			Return 1
		End If
		
		/* 납품배수 */
		nNapQty = dw_key.GetItemNumber(1,'napqty')
		If IsNull(nNapqty) Or nNapQty = 0 Then
		Else
			If Mod(dItemQty, nNapQty) <> 0 Then
				MessageBox('확 인','수량은 납품배수 범위내에서 가능합니다.!!')
				Return 2
			End If
		End If
		
		Choose Case GetItemString(nRow,'sorder_suju_sts')
			Case '2','5','6','7'
				If dItemQty > GetItemNumber(nRow,'piqty',Primary!,True) Then
					MessageBox('확 인',"승인된 품목은 수량을 상향조정하실 수 없습니다.")
					SetItem(nRow,'piqty',dItemOldQty)
					SetFocus()
					Return 1
				End If
		End Choose
		
		/* 진행중일 경우 수량변경 : 할당+지시수량보다 커야함 */
		If dHoldQty > dItemQty Then 
			MessageBox('확 인',"기할당수량 및 작업지시수량보다 커야합니다.~n~n[할당수량 : " +string(dHoldQty,'#,##0') + "]")
			SetItem(nRow,'piqty',dItemOldQty)
			SetFocus()
			Return 1
		End If
		/* ---------------------------- */
		SetItem(nRow,'piamt',0)
		SetItem(nRow,'pre_napgi','')
		
		s_pidate = dw_key.GetItemString(dw_key.GetRow(),'pidate')
		d_piqty  = Double(GetText())
		
		/* 단가 계산 */
		sItnbr     = GetItemString(nRow,'itnbr')
		sOrderSpec = GetItemString(nRow,'order_spec')
		If wf_catch_danga(nRow, sItnbr, sOrderSpec, d_piqty) = -1 Then 
			Wf_Clear_Item(nRow)
			Return 1
		End If
		
		d_danga  = GetItemNumber(nRow,'piprc')
		d_itmprc = GetItemNumber(nRow,'piprc')     // 품목단가
		If IsNull(d_danga) Then d_danga = 0.0 
		
		wf_calc_amt(nRow,d_danga,d_piqty)
		
		SetItem(nRow,'itmamt',TrunCate(d_itmprc * d_piqty,2))  // 품목금액
		
		Post wf_set_minqty(nRow)
	/* 사양 */
	Case 'order_spec'
		sOrderSpec = Trim(GetText())
		IF sOrderSpec = "" OR IsNull(sOrderSpec) THEN
			SetItem(nRow,"order_spec",'.')
			Return 2
		END IF
		
		/* 단가 계산 */
		sItnbr = GetItemString(nRow,'itnbr')
		d_piqty	  = GetItemNumber(nRow,'piqty')
		nRtn = wf_catch_danga(nRow,sItnbr, sOrderSpec, d_piqty)
		If nRtn = -1 Then 
			Wf_Clear_Item(nRow)
			Return 1
		End If
	/* 할인율 */
	Case  "dc_rate"                           // 할인율 변경시(특출일 경우만 가능)
		If iBCi Then
			MessageBox('확인','C/I 연결된 수주는 변경하실 수 없습니다.!!')
			Return 2
		End If
		
		d_piprc   = 0
		d_dc_rate = Double(GetText())
		
		wf_catch_special(nRow,d_piprc,d_dc_rate,'2')  // 특출 단가 계산
		SetItem(nRow,'piprc',d_piprc)
		
		d_piqty   = GetItemNumber(nRow,'piqty')

		wf_calc_amt(nRow,d_piprc,d_piqty)
		
		/* 할인율 임의 수정시 */
		SetItem(nRow,"pricegbn",'9')
	/* 단가 */
	Case  "piprc"                             // 단가변경시(특출일 경우만 가능)
		If iBCi Then
			MessageBox('확인','C/I 연결된 수주는 변경하실 수 없습니다.!!')
			Return 2
		End If
		
		d_piprc   = Double(GetText())
		d_dc_rate = 0
		
		wf_catch_special(nRow,d_piprc,d_dc_rate,'1')  // 특출 할인율 계산
		SetItem(nRow,'dc_rate',d_dc_rate)
		
		d_piqty   = GetItemNumber(nRow,'piqty')
		wf_calc_amt(nRow,d_piprc,d_piqty)
		
		/* 단가 임의 수정시 */
		SetItem(nRow,"pricegbn",'9')
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
		
		/* 무상출고일 경우 단가 0 */
		If sSaleGu = 'N' Then
			SetItem(nRow, 'piprc', 0)
			SetItem(nRow, 'piamt', 0)
			SetItem(nRow, 'dc_rate', 0)
		End If
	/* 절대수 */
	Case 'maxqty'
		dItemQty = Double(GetText())
		If IsNull(dItemQty) Or dItemQty > 100 Or dItemQty < 0 Then Return 2
		
		Post wf_set_minqty(nRow)
	/* 관리품번 순번 */
	Case "seqno"
		iSeqNo = Integer(GetText())
		If IsNull(iseqno) Then
			SetItem(nRow, "itemno", sNull)
			Return
		End If
		
		sItnbr = getitemstring(nRow, 'itnbr')
		sCvcod = dw_key.Getitemstring(1, 'cvcod')
				
	   SELECT A.BUNBR, A.BUDSC INTO :sBudsc FROM ITMBUY A  
       WHERE A.ITNBR = :sitnbr
         AND A.CVCOD = :sCvcod
			AND A.SEQNO = :iseqno;

		If sqlca.sqlcode = 0 Then
			SetItem(nRow, "itemno", sBunBr + ' ' +sBudsc)
			SetItem(nRow, "seqno",  iseqno)
		Else
			SetItem(nRow, "itemno", sNull)
			SetItem(nRow, "seqno",  sNull)
			Return 2
		End If
END Choose
end event

event rbuttondown;Integer nRow, iseqno
String  sCvcod, sCvcodnm, sItnbr, sBudsc, sBunBr, sBuyer

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	/* 품번 */
	Case "itnbr"

		IF MessageBox("선 택", "P/O정보를 조회 하시겠습니까?", Exclamation!, YesNo!, 2) = 1 THEN
			gs_gubun = Trim(dw_key.GetItemString(1, 'saupj'))
			gs_code = Trim(dw_key.GetItemString(1, 'cvcod'))
			gs_codename = Trim(dw_key.GetItemString(1, 'cvcodnm'))
			Open(w_exppo_popup)
			if Isnull(gs_code) or Trim(gs_code) = "" then return
			if this.Find("itemno='"+gs_code+"'", 1, this.rowcount()) > 0 then return
			
			THIS.SetItem(nRow, "itemno", gs_code)
			wf_set_posheet(nRow, Gs_code)
		ELSE
		  gs_gubun = '1'
		  Open(w_itemas_popup)
		  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
			
		  SetItem(nRow,"itnbr",gs_code)
		  TriggerEvent(ItemChanged!)
		END IF


	/* 규격 */
	Case "itdsc"
	  gs_gubun = '1'
	  dw_key.AcceptText()
	  gs_codename2 = dw_key.GetItemString(1, 'cvcod')
	  open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  SetColumn("itnbr")
	  SetFocus()
	
	  TriggerEvent(ItemChanged!)
	/* 사양 */
	Case "ispec"
	  gs_gubun = '1'
	  dw_key.AcceptText()
	  gs_codename2 = dw_key.GetItemString(1, 'cvcod')
	  open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  SetColumn("itnbr")
	  SetFocus()
		
	  TriggerEvent(ItemChanged!)
//	/* 관리품번 순번 */
//	Case "seqno"
//		sItnbr = getitemstring(nRow, 'itnbr')
//		sCvcod = dw_key.Getitemstring(1, 'cvcod')
//		
//		gs_code = sItnbr
//		gs_codename = sCvcod
//		Open(w_itmbuy_popup)
//	
//		IF isnull(gs_Code)  or  gs_Code = ''	then		return
//
//		iseqno = integer(gs_Code)
//		
//	   SELECT A.BUNBR, A.BUDSC INTO :sBunBr, :sBudsc FROM ITMBUY A  
//       WHERE A.ITNBR = :sitnbr
//         AND A.CVCOD = :sCvcod
//			AND A.SEQNO = :iseqno;
//			
//		SetItem(nRow, "itemno", sBunBr + ' ' + sBudsc)
//		SetItem(nRow, "seqno",  iseqno)
End Choose
end event

event itemerror;return 1
end event

event rowfocuschanging;Long nRtn

sle_msg.Text = ''

nRtn = wf_suju_status(newrow)

If nRtn = -1 Or nRtn > 0 Then  /* 완료,마감, 진행 -> 삭제불가  */
   cb_del.Enabled = False
Else
	cb_del.Enabled = True
End If
end event

event buttonclicked;String sItnbr

If row <= 0 Then Return 

sItnbr = Trim(GetItemString(row,'itnbr'))
If IsNull(sItnbr) Or sItnbr = '' then Return

/* 기술기준내역 조회 */
gs_gubun = 'N'
OpenWithParm(w_pdm_01285, sItnbr)
end event

event ue_pressenter;String sItnbr

/* 품번을 입력하면 수량으로 이동 */
If getcolumnname() = "itnbr"  then
	sItnbr = Trim(GetText())
	If IsNull(sItnbr) Or Trim(sItnbr) = '' Then
	Else
		SetColumn('piqty')
		Return
	End If
End If

Send(Handle(this),256,9,0)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then return

this.SelectRow(0, false)
this.SelectRow(currentrow, true)

string sCvcod, sPino, sItnbr
long lPiseq

sCvcod = dw_key.GetItemString(1, "cvcod")
sPino = this.GetItemString(currentrow, "pino")
if isNull(sPino) then sPino = ""
lPiseq = this.GetItemNumber(currentrow, "piseq")
if isNull(lPiseq) then lPiseq = 0
sItnbr = trim(this.GetItemString(currentrow, "itnbr"))
if isNull(sItnbr) then sItnbr = ""

if sCvcod = "205005" then
	tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("itnbr = '" + sItnbr + "'")
	tab_1.tabpage_2.dw_insert_2_fuso.Filter()
else
	tab_1.tabpage_2.dw_insert_2_fuso.SetFilter("")
	tab_1.tabpage_2.dw_insert_2_fuso.Filter()
end if
end event

event clicked;call super::clicked;this.SelectRow(0, false)
this.SetRow(row)
this.SelectRow(row, true)
end event

type dw_insert_2_fuso from u_key_enter within tabpage_2
integer x = 3232
integer y = 36
integer width = 1266
integer height = 1700
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_06020_d_fuso"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;if row <= 0 then return

long ll_qty_tmp, ll_old_qty

string sNull, sPino
long lNull, lRow, lPiseq

long i, ll_quantity

dwItemStatus lStatus

SetNull(sNull)
SetNull(lNull)
lRow = tab_1.tabpage_2.dw_insert_2.GetRow()
sPino = tab_1.tabpage_2.dw_insert_2.GetItemString(lRow, "pino")
if isNull(sPino) then sPino = ""
lPiseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(lRow, "piseq")
if isNull(lPiseq) then lPiseq = 0

if dwo.name = "qty" then
	ll_qty_tmp = this.GetItemNumber(row, "qty_tmp")
	ll_old_qty = this.GetItemNumber(row, "old_qty")
	lStatus = this.GetItemStatus(row, 0, Primary!)
	if long(data) <= 0 then
		this.SetItem(row, "qty", 0)
		if (lStatus = NewModified! or lStatus = DataModified!) and ll_old_qty = 0 then
			this.SetItem(row, "pino", sNull)
			this.SetItem(row, "piseq", lNull)
			this.SetItemStatus(row, 0, Primary!, NotModified!)
		end if
		
		ll_quantity = 0
		for i = 1 to this.RowCount()
			ll_quantity = ll_quantity + this.GetItemNumber(i, "qty")
		next
		tab_1.tabpage_2.dw_insert_2.SetItem(lRow, "piqty", ll_quantity)
		tab_1.tabpage_2.dw_insert_2.Event itemchanged(lRow, tab_1.tabpage_2.dw_insert_2.Object.piqty, string(ll_quantity))
		return 2
	elseif long(data) > ll_qty_tmp then
		MessageBox("확인", "PO의 남은 잔량보다 큰 수를 입력살 수 없습니다.")
		this.SetItem(row, "qty", ll_old_qty)
		this.SetItemStatus(row, 0, Primary!, NotModified!)
		return 2
	else
		this.SetItem(row, "pino", sPino)
		this.SetItem(row, "piseq", lPiseq)
		if ll_old_qty = 0 then
			this.SetItemStatus(row, 0, Primary!, NewModified!)
		end if
		ll_quantity = 0
		for i = 1 to this.RowCount()
			if i = row then
				ll_quantity = ll_quantity + long(data)
			else
				ll_quantity = ll_quantity + this.GetItemNumber(i, "qty")
			end if
		next
		tab_1.tabpage_2.dw_insert_2.SetItem(lRow, "piqty", ll_quantity)
		tab_1.tabpage_2.dw_insert_2.Event itemchanged(lRow, tab_1.tabpage_2.dw_insert_2.Object.piqty, string(ll_quantity))
	end if
end if
end event

event clicked;call super::clicked;if row <= 0 then return

dwItemStatus l_status

l_status = this.GetItemStatus(row, 0, Primary!)
end event

type ln_1 from line within tabpage_2
long linecolor = 28144969
integer linethickness = 4
integer beginx = 3223
integer beginy = 36
integer endx = 3223
integer endy = 1700
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4535
integer height = 1756
long backcolor = 32106727
string text = "CHARGE"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_insert_3 dw_insert_3
end type

on tabpage_3.create
this.rr_4=create rr_4
this.dw_insert_3=create dw_insert_3
this.Control[]={this.rr_4,&
this.dw_insert_3}
end on

on tabpage_3.destroy
destroy(this.rr_4)
destroy(this.dw_insert_3)
end on

type rr_4 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 24
integer width = 4494
integer height = 1720
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert_3 from u_key_enter within tabpage_3
integer x = 37
integer y = 36
integer width = 4466
integer height = 1692
integer taborder = 10
string dataobject = "d_sal_06020_ch"
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

event editchanged;ib_any_typing = True
end event

event itemerror;return 1
end event

event itemchanged;dec wrate,urate,weigh
Double dChrAmt
Long   nRow

nRow = GetRow()
/* 원화금액,외화금액 계산 */
Choose Case GetColumnName()
	Case 'chramt'
	  dChrAmt = Double(GetText())
	  If IsNull(dChrAmt) Then dChrAmt = 0
  	  If tab_1.tabpage_1.dw_insert_1.Rowcount() <= 0 Then Return

     wrate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'wrate')
     urate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'urate')
	  weigh = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'weight')
     If IsNull(wrate) Or wrate = 0 Then wrate = 1
     If IsNull(urate) Or urate = 0 Then urate = 1
     If IsNull(weigh) Or weigh = 0 Then weigh = 1
	  
	  SetItem(nRow,'wamt',TrunCate((dChrAmt * wrate)/weigh,0))
	  SetItem(nRow,'uamt',TrunCate((dChrAmt * urate)/weigh,2))
End Choose

end event

type tabpage_4 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 4535
integer height = 1756
long backcolor = 32106727
string text = "구매의뢰 현황"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
cb_2 cb_2
dw_insert_4 dw_insert_4
end type

on tabpage_4.create
this.rr_5=create rr_5
this.cb_2=create cb_2
this.dw_insert_4=create dw_insert_4
this.Control[]={this.rr_5,&
this.cb_2,&
this.dw_insert_4}
end on

on tabpage_4.destroy
destroy(this.rr_5)
destroy(this.cb_2)
destroy(this.dw_insert_4)
end on

type rr_5 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 24
integer width = 4494
integer height = 1720
integer cornerheight = 40
integer cornerwidth = 55
end type

type cb_2 from commandbutton within tabpage_4
boolean visible = false
integer x = 4101
integer y = 1564
integer width = 334
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "발주의뢰"
end type

event clicked;gs_code = dw_key.GetItemString(1,'pino')
open(w_sal_06020_popup)
end event

type dw_insert_4 from datawindow within tabpage_4
integer x = 37
integer y = 36
integer width = 4466
integer height = 1212
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_06020_gu"
boolean border = false
boolean livescroll = true
end type

type dw_key from datawindow within w_sal_06020
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 168
integer width = 4037
integer height = 224
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06020_key"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;string sdate,scurr,cvnas,sPino,s_pidate,s_pigu,s_pists,s_sareacd,s_sareacdnm, sData
string sNull, sCvcod
Long   nRow,nCnt

SetNull(sNull)
If rb_new.Checked <> True And rb_upd.Checked <> True Then
	f_message_chk(57,' 작업구분 선택')
	Return 2
End If

nRow = GetRow()
Choose Case GetColumnName()
	Case 'pino'
	  If rb_upd.Checked = True Then /* 수정일 경우 */
	    sPiNo = Trim(GetText())
	    IF sPino = "" OR IsNull(sPino) THEN RETURN

       SELECT COUNT(*)
         INTO :nCnt  
         FROM "EXPPIH"  
        WHERE ( "EXPPIH"."SABU" = :gs_sabu ) AND  
              ( "EXPPIH"."PINO" = :sPino ) AND
				  ( "EXPPIH"."LOCALYN" = 'N' ) ;

	    IF nCnt <=0 THEN
		   f_message_chk(33,'[P/I NO]')
         SetItem(nRow,'pino',sNull)
		   Return 1
	    ELSE
		   cb_inq.PostEvent(Clicked!)
	    END If
     End If
	/* 발행일*/
	Case 'pidate'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'[발행일자]')
      	SetItem(nRow,'pidate',sNull)
	      Return 1
      END IF

		// 환율 설정
		nRow  = tab_1.tabpage_1.dw_insert_1.GetRow()
		If nRow <= 0 Then return 0

		scurr = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(nRow,'curr'))
      
		wf_calc_curr(nRow,sDate,scurr)
		
		tab_1.tabpage_1.dw_insert_1.setitem(1, "pidate", sdate)
		SetItem(nRow,'pidate',sDate)
	Case 'ordcfdt'                    // 수주확정일
		sdate = Left(data,4) + Mid(data,5,2) + Right(data,2)
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	setcolumn('ordcfdt')
	      Return 1
      END IF
	/* 거래처 */
   Case 'cvcod'
		sData = Trim(GetText())

		//sCvcod = Trim(GetItemString(1, 'cvcod'))
		sCvcod = sData
		
		if sData = "205005" then
			tab_1.tabpage_2.dw_insert_2_fuso.visible = true
			tab_1.tabpage_2.ln_1.visible = true
//			cb_ins_fuso.visible = true
//			cb_del_fuso.visible = true
			tab_1.tabpage_2.dw_insert_2.width = 3173
		else
			tab_1.tabpage_2.dw_insert_2_fuso.visible = false
			tab_1.tabpage_2.ln_1.visible = false
//			cb_ins_fuso.visible = false
//			cb_del_fuso.visible = false
			tab_1.tabpage_2.dw_insert_2.width = 4462
		end if
		
		If IsNull(sCvcod) Or sCvcod = '' Then
			MessageBox('확인','Buyer를 먼저 선택하세요!!')
			Return 2
		End If
		
      SELECT "VNDMST"."CVNAS2"
		  INTO :cvnas
        FROM "VNDMST"
       WHERE "VNDMST"."CVSTATUS" <> '2' AND
		       "VNDMST"."CVCOD" = :sData;
				 
		If Trim(cvnas) = '' Or IsNull(cvnas) Then 
			this.SetItem(1, "cvcod", sNull)
			Return 1
		End if

		s_pidate = Trim(GetItemString(nrow,'pidate'))			
		s_pigu 	= Trim(GetItemString(nrow,'pigu'))			
		s_pists 	= Trim(GetItemString(nrow,'pists'))			
		
		wf_copy_buyer(sdata,s_pidate,s_pigu,s_pists)
		wf_copy_last_buyer(sdata)
	/* 최종출고처 */
   Case 'factory' 
		sData = Trim(GetText())

      SELECT "VNDMST"."CVNAS2"
		  INTO :cvnas
        FROM "VNDMST"
       WHERE "VNDMST"."CVSTATUS" <> '2' AND
		       "VNDMST"."CVCOD" = :sData;
				 
		If Trim(cvnas) = '' Or IsNull(cvnas) Then 
			this.SetItem(1, "custnm", sNull)
			Return 1
		End if
		
		this.SetItem(1, "custnm", cvnas)
		wf_copy_last_buyer(sdata)
/* 상태 */
	Case 'pists'
		string old_pists,new_pists
		
		old_pists = GetItemString(nrow,'pists',primary!,true)
		new_pists = GetText()
		
		If ib_cfm = True Then  old_pists = '2'

//    sle_msg.text = old_pists + ' => ' + new_pists
		
      Choose Case old_pists
			Case '1'
				If new_pists <> '3' and new_pists <> '1' Then Return 2
			Case '3'
				If new_pists <> '1' Then Return 2
			Case Else 
				Return 2
		End Choose
		
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string sData, sCvcod

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

sData = Trim(GetText())
Choose Case GetColumnName() 
	Case "pino" 
		If rb_upd.Checked = False Then Return 2// 수정일 경우만...

		gs_code = 'N'	// Direct 수출만 해당
    	Open(w_exppih_popup)
      If IsNull(gs_code) Then Return 1
		
		this.SetItem(1,"pino",gs_code)

		p_inq.PostEvent(Clicked!)
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	/* 최종출고처 */
	Case "factory"
		sCvcod = Trim(GetItemString(1, 'cvcod'))
		If IsNull(sCvcod) Or sCvcod = '' Then
			MessageBox('확인','Buyer를 먼저 선택하세요!!')
			Return 2
		End If
		
		gs_gubun = '2'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"factory",gs_code)
		SetItem(1,"custnm",gs_codename)
		
		wf_copy_last_buyer(sCvcod)
END Choose
end event

type gb_3 from groupbox within w_sal_06020
integer x = 119
integer y = 2616
integer width = 1573
integer height = 220
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_new from radiobutton within w_sal_06020
integer x = 4229
integer y = 200
integer width = 247
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
string text = "신규"
boolean checked = true
end type

event clicked;wf_protect_key('신규')

// 부가세 사업장 설정
//f_mod_saupj(dw_key, 'saupj')
end event

type rb_upd from radiobutton within w_sal_06020
integer x = 4229
integer y = 284
integer width = 247
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

event clicked;wf_protect_key('수정')

// 부가세 사업장 설정
//f_mod_saupj(dw_key, 'saupj')
end event

type gb_4 from groupbox within w_sal_06020
integer x = 1728
integer y = 2616
integer width = 1851
integer height = 220
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_1 from commandbutton within w_sal_06020
integer x = 1262
integer y = 2680
integer width = 407
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "원가비교(&T)"
end type

type cb_jego from commandbutton within w_sal_06020
integer x = 841
integer y = 2680
integer width = 407
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고조회(&W)"
end type

type p_suju from uo_picture within w_sal_06020
integer x = 4101
integer y = 388
integer width = 475
integer height = 100
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\수주진행조회_up.gif"
end type

event clicked;call super::clicked;String  sOrderNo
Integer iSelectedRow

iSelectedRow = tab_1.tabpage_2.dw_insert_2.GetRow()
IF iSelectedRow <=0 THEN 
	f_message_chk(36,'')
	RETURN
END IF

sOrderNo = tab_1.tabpage_2.dw_insert_2.GetItemString(iSelectedRow,'sorder_order_no')
If IsNull(sOrderNo) Then
	MessageBox('확 인','[수주번호를 찾을 수 없습니다]')
Else
	OpenWithParm(w_sal_02020_1,sOrderNo)
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\수주진행조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\수주진행조회_up.gif'
end event

type pb_1 from u_pb_cal within w_sal_06020
integer x = 2139
integer y = 196
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('pidate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'pidate', gs_code)

end event

type pb_3 from u_pb_cal within w_sal_06020
integer x = 1376
integer y = 916
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
tab_1.tabpage_1.dw_insert_1.SetColumn('shipreq')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
tab_1.tabpage_1.dw_insert_1.SetItem(1, 'shipreq', gs_code)

end event

type pb_4 from u_pb_cal within w_sal_06020
integer x = 1376
integer y = 1028
integer height = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
tab_1.tabpage_1.dw_insert_1.SetColumn('shipsch')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
tab_1.tabpage_1.dw_insert_1.SetItem(1, 'shipsch', gs_code)

end event

type pb_5 from u_pb_cal within w_sal_06020
integer x = 1376
integer y = 1140
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
tab_1.tabpage_1.dw_insert_1.SetColumn('invsch')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
tab_1.tabpage_1.dw_insert_1.SetItem(1, 'invsch', gs_code)

end event

type cb_ins_fuso from commandbutton within w_sal_06020
boolean visible = false
integer x = 3131
integer y = 396
integer width = 311
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가"
end type

event clicked;long ll_row, ll_r, ll_piseq
string ls_itnbr, ls_pino

SetNull(gs_code)

sle_msg.text = ''

if tab_1.tabpage_2.dw_insert_2.AcceptText() = -1 then return
ll_row = tab_1.tabpage_2.dw_insert_2.GetRow()
if ll_row <= 0 then return

ls_itnbr = trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ll_row, "itnbr"))
ls_pino = tab_1.tabpage_2.dw_insert_2.GetItemString(ll_row, "pino")
ll_piseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ll_row, "piseq")


str_code lst_code
Long i , ll_i = 0
Long ll_seq , ll_cnt=0

String  ls_null
		
SetNull(ls_null)

gs_code = ls_itnbr

Open(w_sal_06020_f_popup)

lst_code = Message.PowerObjectParm
IF isValid(lst_code) = False Then Return 
If UpperBound(lst_code.code) < 1 Then Return 

For i = 1 To UpperBound(lst_code.code)
	ll_r = tab_1.tabpage_2.dw_insert_2_fuso.InsertRow(0)
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "sabu", "1")
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "pino", ls_pino)
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "piseq", ll_piseq)
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "pono", lst_code.code[i])
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "poseq", lst_code.dgubun1[i])
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "qty", lst_code.dgubun2[i])
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "old_qty", lst_code.dgubun2[i])
	tab_1.tabpage_2.dw_insert_2_fuso.SetItem(ll_r, "qty_tmp", lst_code.dgubun2[i])
Next
end event

type cb_del_fuso from commandbutton within w_sal_06020
boolean visible = false
integer x = 3771
integer y = 396
integer width = 311
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제"
end type

event clicked;long ll_row
string ls_pino, ls_pono
long ll_piseq, ll_poseq

ll_row = tab_1.tabpage_2.dw_insert_2_fuso.GetRow()

if ll_row > 0 then
	ls_pino = tab_1.tabpage_2.dw_insert_2_fuso.GetItemString(ll_row, "pino")
	ll_piseq = tab_1.tabpage_2.dw_insert_2_fuso.GetItemNumber(ll_row, "piseq")
	ls_pono = tab_1.tabpage_2.dw_insert_2_fuso.GetItemString(ll_row, "pono")
	ll_poseq = tab_1.tabpage_2.dw_insert_2_fuso.GetItemNumber(ll_row, "poseq")
	tab_1.tabpage_2.dw_insert_2_fuso.deleterow(ll_row)
	
	delete from exppid_fuso
	 where sabu = '1'
	   and pino = :ls_pino
	   and piseq = :ll_piseq
	   and pono = :ls_pono
	   and poseq = :ll_poseq;
	
	IF sqlca.sqlcode <> 0 THEN
		ROLLBACK;
		f_message_chk(32,'[PO정보]')
		Return
	ELSE
		COMMIT;
	END IF
end if
end event

type rr_3 from roundrectangle within w_sal_06020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4082
integer y = 172
integer width = 498
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

