$PBExportHeader$w_sal_06100.srw
$PBExportComments$출고송장 발행(수출)
forward
global type w_sal_06100 from w_inherite
end type
type rb_1 from radiobutton within w_sal_06100
end type
type rb_2 from radiobutton within w_sal_06100
end type
type st_2 from statictext within w_sal_06100
end type
type st_haldang from statictext within w_sal_06100
end type
type st_list from statictext within w_sal_06100
end type
type pb_1 from u_pic_cal within w_sal_06100
end type
type rr_4 from roundrectangle within w_sal_06100
end type
type dw_haldang_list from datawindow within w_sal_06100
end type
type dw_lot from u_d_popup_sort within w_sal_06100
end type
type dw_haldang from u_d_popup_sort within w_sal_06100
end type
type dw_1 from datawindow within w_sal_06100
end type
type dw_print from datawindow within w_sal_06100
end type
type r_haldang_list from rectangle within w_sal_06100
end type
end forward

global type w_sal_06100 from w_inherite
integer width = 4704
integer height = 2776
string title = "출하 지시(수출)"
rb_1 rb_1
rb_2 rb_2
st_2 st_2
st_haldang st_haldang
st_list st_list
pb_1 pb_1
rr_4 rr_4
dw_haldang_list dw_haldang_list
dw_lot dw_lot
dw_haldang dw_haldang
dw_1 dw_1
dw_print dw_print
r_haldang_list r_haldang_list
end type
global w_sal_06100 w_sal_06100

type variables
String LsIoJpNo,LsSuBulDate
end variables

forward prototypes
public function integer wf_delete_imhist ()
public subroutine wf_init ()
public function integer wf_create_imhist ()
public function string wf_depotno (string oversea_gu)
public subroutine wf_lotins (string scino)
public function integer wf_proc_new (string arg_sabu, string arg_cino, string arg_saledt, string arg_cists)
public function integer wf_ins_lot (string siojpno, string sitnbr, decimal dioqty, string spec)
public function integer wf_chulgo_print (string arg_iojpno)
end prototypes

public function integer wf_delete_imhist ();String sCino, sHoldNo, sDelIoJpNo
Long   nCnt, ix
Dec    dInvQty

sle_msg.text =""

If dw_haldang.Rowcount() <= 0 Then Return -1

IF MessageBox("확 인","송장 취소 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)
sCino = Trim(dw_haldang.GetItemString(1,'cino'))

///* 출고확인 처리된 송장은 취소 불가 */
//
//
//select count(io_date) into :nCnt
//	from imhist
// where sabu = :gs_sabu and 
//		 inv_no = :sCino and
//		 io_date is not null;
//
//If nCnt > 0 Then
//	RollBack;
//	f_message_chk(57,'[제품출고 확인완료]')
//	wf_init()
//	Return -1
//End If
//
//
///* 출고의뢰 -> CI 접수 */
//

UPDATE EXPCIH
   SET CISTS = '1'
 WHERE SABU = :gs_sabu AND
       CINO = :sCino;

If sqlca.sqlcode <> 0 Or sqlca.sqlnrows <> 1 then
	RollBack;
	MessageBox(sqlca.sqlerrtext,'[출고의뢰된 건수가 없습니다.]')
	Return -1
End If


For ix = 1 To dw_haldang.RowCount()
	sHoldNo = dw_haldang.GetItemString(ix, 'hold_no')
	
	/* 삭제할 전표번호 */
	SELECT IOJPNO
	INTO :sDelIoJpNo
	FROM IMHIST
	WHERE SABU = :gs_sabu AND HOLD_NO = :sHoldNo;
		
//	/* LOT번호 삭제 */
//
//	DELETE FROM HOLDSTOCK_LOTNO
//	WHERE OJPNO = :sDelIoJpNo;
//	
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

	/* 출고 의뢰 출고 취소 */
	If dInvQty = 1 Then
		UPDATE HOLDSTOCK
			SET OUT_CHK = '1',
				 HOSTS = 'N'
		 WHERE SABU = :gs_sabu AND
				 HOLD_NO = :sHoldNo ;
				 
		If sqlca.sqlcode <> 0 Or sqlca.sqlnrows < 1 then
			RollBack;
			MessageBox(sqlca.sqlerrtext,'[출고의뢰된 건수가 없습니다.]')
			Return -1
		End If
	End If
Next

/* 수불삭제 */
DELETE FROM "IMHIST"  
 WHERE "IMHIST"."INV_NO" = :sCino;

If sqlca.sqlcode <> 0 Then
	Rollback;
	f_message_chk(39,'[출고 취소]')
	Return -1
End If

COMMIT;

Return 1

end function

public subroutine wf_init ();rollback;

dw_haldang.Reset()
dw_insert.Reset()   // 출력물 

dw_input.SetItem(1,"sudat",is_today)
dw_input.Modify('iogbn.protect = 0')

IF sModStatus = 'I' THEN
	st_list.Text = '출하의뢰 현황'
	st_haldang.Text = '출하의뢰 현황'
	
	dw_input.Modify('iojpno.protect = 1')
	dw_input.Modify('saupj.protect = 0')

	dw_input.SetFocus()
	dw_input.SetColumn("cvcod")
	
	dw_haldang.Modify('ciqty.visible = 1')
	dw_haldang.Modify('ciprc.visible = 1')
	dw_haldang.Modify('ciamt.visible = 1')
	dw_haldang.Modify('sum_ciamt.visible = 1')
	
	dw_haldang.Modify('imhist_ioreqty.visible = 0')
	dw_haldang.Modify('imhist_dyebi2.visible = 0')
	dw_haldang.Modify('imhist_foramt.visible = 0')
	dw_haldang.Modify('sum_foramt.visible = 0')
	
	
//	dw_haldang.Modify('ciprc.visible = 1')
//	dw_haldang.Modify('ciamt.visible = 1')

ELSE
	st_list.Text = '송장 현황'
	st_haldang.Text = '송장 현황'
	
	dw_input.Modify('iojpno.protect = 0')
	dw_input.Modify('saupj.protect = 0')
   dw_input.SetFocus()
	dw_input.SetColumn("iojpno")

	dw_haldang.Modify('ciqty.visible = 0')
	dw_haldang.Modify('ciprc.visible = 0')
	dw_haldang.Modify('ciamt.visible = 0')
	dw_haldang.Modify('sum_ciamt.visible = 0')
	
	dw_haldang.Modify('imhist_ioreqty.visible = 1')
	dw_haldang.Modify('imhist_dyebi2.visible = 1')
	dw_haldang.Modify('imhist_foramt.visible = 1')
	dw_haldang.Modify('sum_foramt.visible = 1')
	
	
//	dw_haldang.Modify('ciprc.visible = 0')
//	dw_haldang.Modify('ciamt.visible = 0')

END IF

/* 출하의뢰현항,송장현황 데이타원도우 */
String sParsal

dw_haldang_list.SetRedraw(False)
If sModStatus = 'I' Then
	/* 분할출고 여부 */
	select substr(dataname,1,1) into :sParsal
	  from syscnfg
	 where sysgu = 'S' and
			 serial = 7 and
			 lineno = 15;
	If IsNull(sParsal) Then sParsal = 'N'
	
	/* 수출은 분할출고 제외 */
	//sParsal = 'N'
	
	If sParsal = 'Y' Then
		dw_haldang.Modify('valid_qty.protect = 0')
	Else
		dw_haldang.Modify('valid_qty.protect = 1')
	End If

	dw_haldang_list.Reset()
	dw_haldang_list.DataObject = 'd_sal_061002'
	dw_haldang_list.SetTransObject(sqlca)
Else
	dw_haldang_list.Reset()
	dw_haldang_list.DataObject = 'd_sal_061004'
	dw_haldang_list.SetTransObject(sqlca)
End If
dw_haldang_list.SetRedraw(True)

/* 송장번호,수불일자 clear */
SetNull(LsIoJpNo)
SetNull(LsSubulDate)

ib_any_typing = False
end subroutine

public function integer wf_create_imhist ();If dw_haldang.RowCount() <= 0 Then Return -1

String sCurr, sCino, sCists, sLocalyn, SaleConfirm, sSaledt, sOutCfdt, sItnbr
dec	 dWrate, dUrate
Long   nInsCnt, nRow,nrtn
Double dCiqty, dHoldQty, dEmailCnt

sle_msg.text =""

LsSuBulDate = Trim(dw_input.GetItemString(1,'sudat'))

If f_datechk(LsSuBulDate) <> 1 Then
	f_message_chk(1200,'[발행일자]')
	Return -1
End If

dCiqty = dw_haldang.GetItemNumber(1, 'sum_ciqty')
If IsNull(dCiqty) Then dCiqty = 0

dHoldqty = dw_haldang.GetItemNumber(1, 'sum_holdqty')
If IsNull(dHoldqty) Then dHoldqty = 0

If dCiQty > dHoldQty Then
	MessageBox('확 인','출고 의뢰 수량이 부족합니다.!!')
	Return -1
End If

IF MessageBox("확 인","출하 지시를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

/* 환율 확인 */
nRow = dw_haldang_list.GetSelectedRow(0)
If nRow <= 0 Then Return -1

sCurr = dw_haldang_list.GetItemString(nRow,"curr")

// 주석이 달려 있어 환율 적용 되지 않고 있었음.
// 주석 해제 하고 환율 적용되도록 함 BY SHJEON 20130809
select x.rstan,x.usdrat
  into :dWrate, :dUrate
 from ratemt x
 where x.rdate = :LsSuBulDate and
		 x.rcurr = :scurr;

If IsNull(dWrate) Or dWrate = 0 Then
	f_message_chK(166,sCurr)
	return -1
End If

If IsNull(dWrate) Or dWrate = 0 Then dWrate = 1
If IsNull(dUrate) Or dUrate = 0 Then dUrate = 1

sCino = dw_haldang.GetItemString(1,'cino')

/* 출고확정일 (1:면장(계산서),2:출고,3:B/L) */
sLocalYn = dw_haldang_list.GetItemString(nRow,"localyn")
If sLocalYn = 'Y' Then
	select substr(dataname,1,1) into :SaleConfirm
	  from syscnfg
	 where sysgu = 'S' and
			 serial = 8 and
			 lineno = 15;
Else
	select substr(dataname,1,1) into :SaleConfirm
	  from syscnfg
	 where sysgu = 'S' and
			 serial = 8 and
			 lineno = 10;
End If
If SaleConfirm <> '2' Then	SaleConfirm = '1'

/* 창고자동출고 여부 */
dEmailCnt = dw_haldang.GetItemNumber(1,'sum_email')
If IsNull(dEmailCnt) Then dEmailCnt = 0

SetNull(sOutCfDt)
SetNull(sSaleDt)

If dEmailCnt = dw_haldang.RowCount() Then
	sCists 	= '2'				/* 출고승인 */
	sOutCfdt = LsSuBulDate	/* 출고일자 */	
Else
	sCists = '3'	/* 출고의뢰 */
End If

// 매출기준이 출고일 경우 매출일자에 출고일자를 입력
if saleconfirm = '2' then
	ssaledt = lssubuldate  /* 매출일자 */
	UPDATE EXPCIH
		SET CISTS   = :sCists,
			 WRATE   = :dWrate,
			 URATE   = :dUrate,
			 OUTCFDT = :sOutcfdt,
			 SALEDT  = :ssaledt
	 WHERE SABU = :gs_sabu AND
			 CINO = :sCino;
Else
	UPDATE EXPCIH
		SET CISTS   = :sCists,
			 WRATE   = :dWrate,
			 URATE   = :dUrate,
			 OUTCFDT = :sOutcfdt 
	 WHERE SABU = :gs_sabu AND
			 CINO = :sCino;				
End if

If sqlca.sqlcode <> 0 then
	MessageBox(sqlca.sqlerrtext,'[출하지시 처리된 건수가 없습니다.]')
	RollBack;
	Return -1
End If

/* 출하지시 처리 */
nInsCnt = wf_proc_new(gs_sabu, sCino, LsSuBulDate , sCists)
///nInsCnt = sqlca.fun_erp100000090(gs_sabu, sCino, LsSuBulDate , sCists)
//If sqlca.sqlcode <> 0 Then
//	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
if isnull(nInsCnt) then
	MessageBox(sqlca.sqlerrtext,'[출하지시에 실패하였습니다.!!]')
	RollBack;
	nrtn = -1
ElseIf nInsCnt = 0 Then
	MessageBox(sqlca.sqlerrtext,'[출하지시된 건수가 없습니다.]')
	RollBack;
	nrtn = -1
End If

/* 출고의뢰시 오류 발생할 경우 처리 */
if nrtn = -1 then
	/* 실적기준이 출고일 경우에만 매출일자를 삭제한다 */
	if saleconfirm = '2' then
		update expcih
		   set cists = '1',
			    outcfdt = null,
				 saledt  = null
		 where sabu = :gs_sabu and cino = :scino;
   else
		update expcih
		   set cists = '1',
			    outcfdt = null
		 where sabu = :gs_sabu and cino = :scino;
	end if
	
	if sqlca.sqlcode <> 0 then
		messagebox(sqlca.sqlerrtext, '전산실에 연락바랍니다')
		rollback;
		return -1
	end if
	
	commit;
	
	return -1
else
	commit;
	f_message_chk(202, "[처리건수 : " + string(ninscnt) + "]")
	
//	wf_lotins(sCino)
	return 1
	
end if

Return 1
end function

public function string wf_depotno (string oversea_gu);string sDepotNo, sSaupj

If IsNull(oversea_gu) Or oversea_gu = '' Then Return ''

//sDepotNo	= dw_input.GetItemString(1, 'depot_no')
sSaupj 	= dw_input.GetItemString(1, 'saupj')

//If 	IsNull(sDepotNo) Or Trim(sDepotNo) = '' Then
	select min(cvcod )
	  into :sDepotNo
	  from vndmst
	 where cvgu = '5' and
			 juprod = '1' and
			 ipjogun = :sSaupj;
//End If

If 	IsNull(sDepotNo) Then 
	f_message_chk(1400,'[창고]')
	sDepotNo = ''
End If

Return sDepotNo

end function

public subroutine wf_lotins (string scino);Long lrow, i = 1, j, lrowcount, lfoundrow
String sIojp = '.', sLot, siojpno, sitnbr
Double odQty, dQty, dTqty, dLotqty, dTotlotqty, dioreqty

DECLARE CUR_GET_IMHIST CURSOR FOR
SELECT IOJPNO, ITNBR, IOREQTY
FROM IMHIST
WHERE INV_NO = :scino
ORDER BY INV_SEQ;

OPEN CUR_GET_IMHIST;

DO
	FETCH CUR_GET_IMHIST INTO :siojpno, :sitnbr, :dioreqty;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	/*품번별 LOTNO선입선출에 의한 출고수량 등록*/
	DECLARE CUR_GET_QTY CURSOR FOR
	SELECT LOTSNO, SUM(IOQTY)
	FROM IMHIST 
	WHERE  ITNBR = :sItnbr
	AND IOGBN = 'I1A'
	GROUP BY  LOTSNO;

	OPEN CUR_GET_QTY;

	DO
	
		FETCH CUR_GET_QTY INTO :sLot, :dQty;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
	
		SELECT SUM(IOQTY)
		INTO :oDqTY
		FROM HOLDSTOCK_LOTNO
		WHERE LOTNO = :sLot
		AND ITNBR = :sItnbr;
	
		If IsNull(oDqty) Then oDqty = 0

		dTqty = dQty - oDqTY
		If dTqty <= 0 Then continue
	
		If dTqty >= dioreqty Then 
			lrow = dw_lot.insertrow(0)
			dw_lot.setitem(lrow,'ijpno',sIojp)
			dw_lot.setitem(lrow,'ojpno',siojpno)
			dw_lot.setitem(lrow,'seq',i)
			dw_lot.setitem(lrow,'itnbr',sItnbr)
			dw_lot.setitem(lrow,'lotno',sLot)
			dw_lot.setitem(lrow,'ioqty',dioreqty)
			dw_lot.setitem(lrow,'barid','')
			
			if dw_lot.update() = 1 then
				commit;
			else
				rollback;
			end if
	
			exit
		Else
			lrow = dw_lot.insertrow(0)
			dw_lot.setitem(lrow,'ijpno',sIojp)
			dw_lot.setitem(lrow,'ojpno',siojpno)
			dw_lot.setitem(lrow,'seq',i)
			dw_lot.setitem(lrow,'itnbr',sItnbr)
			dw_lot.setitem(lrow,'lotno',sLot)
			dw_lot.setitem(lrow,'ioqty',dTqty)
			dw_lot.setitem(lrow,'barid','')
			
			i++
		End If		
		dioreqty = dioreqty - dTqty
		dQty = 0;	dTqty = 0
	
	LOOP WHILE TRUE 
	
	CLOSE CUR_GET_QTY;
LOOP WHILE TRUE

CLOSE CUR_GET_IMHIST;


end subroutine

public function integer wf_proc_new (string arg_sabu, string arg_cino, string arg_saledt, string arg_cists);string sItnbr,	sOrderSpec, sCvcod, 	sCino, sExplcNo, sSaupj, sCurr, sHoldNo, sOutStore, sOrderNo	
string sIogbn, sIoConfirm, sIoDate, sIoJpNo, ls_iojpno
double k, dCiseq, dHoldQty, dIoprc, dIoamt, dIoqty,	dIoSuQty, nInsCnt, Cal_JunpyoNo, Cal_JunpyoSeq, weight  			
decimal{3} dCiqty, dSumHoldQty, dOutqty		 
decimal{2} dWamt, dWrate, dSumAmt
decimal{5} dCiprc, dreqty, dValQty

/* 출고전표번호 */
Cal_JunpyoNo  = sqlca.fun_junpyo(arg_sabu, arg_saledt, 'C0')
IF Cal_JunPyoNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1;
END IF;
COMMIT;
	
/* Commerical Invoice Cursor */
DECLARE c1 CURSOR FOR
SELECT EXPCID.ITNBR, EXPCID.ORDER_SPEC,
			EXPCIH.CVCOD, EXPCID.CIQTY,
			EXPCID.CIPRC, EXPCIH.WRATE, EXPCID.CINO,
			EXPCID.CISEQ, EXPCIH.EXPLCNO,	EXPCID.WAMT,
			EXPCIH.SAUPJ, EXPCIH.CURR
FROM EXPCID, EXPCIH, VNDMST
WHERE 	EXPCIH.SABU = EXPCID.SABU
AND 		EXPCIH.CINO = EXPCID.CINO
AND		EXPCIH.CVCOD = VNDMST.CVCOD
AND		EXPCIH.SABU = :arg_sabu
AND		EXPCIH.CINO = :arg_cino;

OPEN c1;

DO
	FETCH c1 INTO :sItnbr, :sOrderSpec, :sCvcod, :dCiqty, :dCiprc,
						 :dWrate,	:sCino, :dCiseq, :sExplcNo, :dWamt, :sSaupj, :sCurr;
	
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	dSumHoldQty = 0;
	/* 환율가중치 */
	SELECT TO_NUMBER(Y.RFNA2)
	INTO :weight
	FROM REFFPF Y
	WHERE Y.RFGUB(+) = :sCurr
	AND	Y.RFCOD = '10';
	
	IF SQLCA.SQLCODE <> 0 THEN
		weight = 1
	END IF
		
	/* 원화단가 계산 */
	If weight <> 0 Then
		dIoPrc = Truncate(dCiprc * dWrate / weight, 0)
	End If
	dSumAmt = 0;
	dSumHoldQty = 0;
	/*  출고될 수량이 없으면 Exit */
	If dCiqty > 0 Then

		SELECT Z.HOLD_NO, Z.HOLD_QTY - Z.ISQTY - Z.CANCELQTY, Z.OUT_STORE, Y.ORDER_NO, Z.HOLD_GU
		INTO :sHoldNo, :dHoldQty, :sOutStore, :sOrderNo, :sIogbn
		FROM EXPCID X, SORDER Y, HOLDSTOCK Z
		WHERE 	X.SABU = :arg_sabu 
		AND 		X.CINO = :arg_cino
		AND		X.CISEQ = :dCiseq
		AND		X.PINO = Y.PINO
		AND		X.PISEQ = Y.PISEQ
		AND		X.ITNBR = Y.ITNBR
		AND		X.ORDER_SPEC = Y.ORDER_SPEC
		AND		Y.SABU = Z.SABU 
		AND		Y.ORDER_NO = Z.ORDER_NO
		AND		Z.HOSTS = 'N';
		
		If ISNULL(dHoldQty) then 
			dHoldQty = 0
		end if
			
		/* 출고의뢰 상태는 할당(Holdstock)에 출고수량이 Update가 안되기 때문에
			의뢰상태에 있는 수량을 Sum하여 할당미출고 수량에서 Minus처리한다 */
		dreqty = 0
			
		Select sum(ioreqty) 
		into :dreqty 
		from imhist
		Where sabu = :arg_sabu 
		and hold_no = :sHoldno 
		and io_date is null;
		
		if ISNULL(dreqty) then 
			dreqty = 0
		end if
		
		dHoldqty = dHoldqty - dreqty
			
		/* 수불수량 */
		If dCiqty > dHoldQty Then
			dOutQty = dHoldQty
			dCiqty  = dCiqty - dHoldQty
		Else
			dOutQty = dCiqty
			dCiqty  = 0
		End If;
			
		dIoAmt = Truncate(dIoPrc * dOutQty,0)
		/* 출고자동여부에 따라 */
		If Arg_cists = '2' then
			dIoQty = dOutQty
			sIoConfirm = 'Y'
			sIoDate	= arg_saledt
			dIoSuQty = dOutQty
		Else
			dIoQty = 0
			sIoConfirm = 'N'
			SETNULL(sIoDate)
			dIoSuQty = 0
		End If;
		/* 할당번호로 IMHIST UPDATE */
		
		string sData, sFilter, sPspec
		long i
		
		dw_1.setredraw(false)
		sFilter = "itnbr = '" + sItnbr + "'"
		dw_1.setfilter(sFilter)
		dw_1.filter()
		dw_1.setredraw(true)
		if dw_1.rowcount() > 0 then
			for i = 1 to dw_1.rowcount()
				/* 출고수량 */
				dValQty = dw_1.GetItemNumber(i,"qty")
				If IsNull(dValQty) Then dValQty = 0
					
				sPspec  = dw_1.GetItemString(i, "pspec")
				
				nInsCnt = nInsCnt + 1
				Cal_JunpyoSeq = Cal_JunpyoSeq + 1
				sIojpNo = arg_saledt + STRING(Cal_JunPyoNo,'0000') + STRING(Cal_JunPyoSeq,'000')
				
				//wf_ins_lot(sIojpNo, sItnbr, dValQty, sPspec)			/* LOTNO 부여*/		
				
				INSERT INTO "IMHIST"
							 ( "SABU",               "IOJPNO",             "IOGBN",              "SUDAT",
								"ITNBR",              "PSPEC",              "OPSEQ",              "DEPOT_NO",
								"CVCOD",              "SAREA",              "PDTGU",              "CUST_NO",
								"IOQTY",              "IOPRC",              "IOAMT",              "IOREQTY",
								"INSDAT",             "INSEMP",             "QCGUB",              "IOFAQTY",
								"IOPEQTY",            "IOSPQTY",            "IOCDQTY",            "IOSUQTY",
								"IO_CONFIRM",         "IO_DATE",            "IO_EMPNO",           "LOTSNO",
								"LOTENO",             "HOLD_NO",            "ORDER_NO",           "INV_NO",
								"INV_SEQ",            "FILSK",              "BALJPNO",            "BALSEQ",
								"POLCNO",             "POBLNO",             "POBLSQ",             "BIGO",
								"BOTIMH",             "IP_JPNO",            "ITGU",               "SICDAT",
								"MAYYMM",             "INPCNF",             "JAKJINO",            "JAKSINO",
								"JNPCRT",             "OUTCHK",             "MAYYSQ",             "IOREDEPT",
								"IOREEMP",            "DCRATE",             "JUKSDAT",            "JUKEDAT",
								"PRVPRC",             "AFTPRC",             "SILQTY",             "SILAMT",
								"GURDAT",             "TUKDAT",             "TUKEMP",             "TUKQTY",
								"TUKSUDAT",           "CRT_USER",			  "YEBI1",					"SAUPJ",
								"YEBI2",              "DYEBI1",             "DYEBI2",					"FORAMT",			"LCLGBN" )
					 VALUES ( :arg_sabu,        :sIojpNo, 		        :sIogbn,             :arg_saledt,
									:sItnbr,              :sPspec,           '9999',               :sOutStore,
									:sCvcod,           null,	                   null,                 null,
									:dIoQty,             :dIoprc,               :dIoamt,               :dValQty,
									 null,                  null,                 null,                 0,
									 0,                      0,                    0,                    :dValQty,
									 :sIoConfirm,     :sIoDate,	           '',                   '',
									 '',                      :sHoldNo,            :sOrderNo,    :sCino,
									 :dCiseq,           'Y',                  '',                   0,
									 :sExplcno,        '',                   0,                    '',
									 '',                      '',                  '',                   '',
									 '',                      'O',                 '',                  '',
									 '014',                'N',	              0,                    '',
									 '',                      0,                   '',                  '',
									 0,                     0,                   0 ,                  0,
									 '',                      '',                  '',                  0,
									 '',                      null,          		  null,					  :gs_saupj,
								  :sCurr,              :dWrate,              :dCiprc,				  trunc(:dciprc * :dioqty, 2),		'L' );
									 
					if SQLCA.SQLCODE <> 0 then
						Messagebox("입출고저장", "입출고저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
						ROLLBACK;
						Return -1
					ELSE
						K++
					end if
				NEXT
			else
				nInsCnt = nInsCnt + 1
				Cal_JunpyoSeq = Cal_JunpyoSeq + 1
				sIojpNo = arg_saledt + STRING(Cal_JunPyoNo,'0000') + STRING(Cal_JunPyoSeq,'000')
				
				//wf_ins_lot(sIojpNo, sItnbr, dValQty, sOrderSpec)			/* LOTNO 부여*/		
				
				INSERT INTO "IMHIST"
							 ( "SABU",               "IOJPNO",             "IOGBN",              "SUDAT",
								"ITNBR",              "PSPEC",              "OPSEQ",              "DEPOT_NO",
								"CVCOD",              "SAREA",              "PDTGU",              "CUST_NO",
								"IOQTY",              "IOPRC",              "IOAMT",              "IOREQTY",
								"INSDAT",             "INSEMP",             "QCGUB",              "IOFAQTY",
								"IOPEQTY",            "IOSPQTY",            "IOCDQTY",            "IOSUQTY",
								"IO_CONFIRM",         "IO_DATE",            "IO_EMPNO",           "LOTSNO",
								"LOTENO",             "HOLD_NO",            "ORDER_NO",           "INV_NO",
								"INV_SEQ",            "FILSK",              "BALJPNO",            "BALSEQ",
								"POLCNO",             "POBLNO",             "POBLSQ",             "BIGO",
								"BOTIMH",             "IP_JPNO",            "ITGU",               "SICDAT",
								"MAYYMM",             "INPCNF",             "JAKJINO",            "JAKSINO",
								"JNPCRT",             "OUTCHK",             "MAYYSQ",             "IOREDEPT",
								"IOREEMP",            "DCRATE",             "JUKSDAT",            "JUKEDAT",
								"PRVPRC",             "AFTPRC",             "SILQTY",             "SILAMT",
								"GURDAT",             "TUKDAT",             "TUKEMP",             "TUKQTY",
								"TUKSUDAT",           "CRT_USER",			  "YEBI1",					"SAUPJ",
								 "YEBI2",              "DYEBI1",             "DYEBI2",					"FORAMT",		"LCLGBN" )
					 VALUES ( :arg_sabu,        :sIojpNo, 		        :sIogbn,             :arg_saledt,
									:sItnbr,              :sOrderSpec,           '9999',               :sOutStore,
									:sCvcod,           null,	                   null,                 null,
									:dIoQty,             :dIoprc,               :dIoamt,               :dOutQty,
									 null,                  null,                 null,                 0,
									 0,                      0,                    0,                    :dIoSuQty,
									 :sIoConfirm,     :sIoDate,	           '',                   '',
									 '',                      :sHoldNo,            :sOrderNo,    :sCino,
									 :dCiseq,           'Y',                  '',                   0,
									 :sExplcno,        '',                   0,                    '',
									 '',                      '',                  '',                   '',
									 '',                      'O',                 '',                  '',
									 '014',                'N',	              0,                    '',
									 '',                      0,                   '',                  '',
									 0,                     0,                   0 ,                  0,
									 '',                      '',                  '',                  0,
									 '',                      null,          		  null,					  :gs_saupj,
						  :sCurr,              :dWrate,              :dCiprc,				  trunc(:dciprc * :dioqty, 2), 'L' );
									 
					if SQLCA.SQLCODE <> 0 then
						Messagebox("입출고저장", "입출고저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
						ROLLBACK;
						Return -1
					ELSE
						K++
					end if
			end if
				
			/* 할당TABLE UPDATE */
			UPDATE HOLDSTOCK
			SET OUT_CHK = '2'
			WHERE SABU = :arg_sabu 
			AND	 HOLD_NO  = :sHoldNo;
				
			IF SQLCA.SQLCODE <> 0 THEN
				Messagebox("출고 등록저장", "출고 등록저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
				rollback;
				return -1
			else
				K++
			end if
				
			/* 할당수량,금액 누적 */
			dSumAmt	= dSumAmt + dIoAmt
			dSumHoldQty = dSumHoldQty + dOutqty
			if ISNULL(dSumAmt) then 
				dSumAmt = 0 
			end if
			if ISNULL(dSumHoldQty) then 
				dSumHoldQty = 0 
			end if
	 END IF
LOOP WHILE TRUE

CLOSE c1;

IF K > 0 THEN
	COMMIT;
	ls_iojpno = Left(sIojpno,12)	
	//출고전표 출력 - 2006.12.08 - 송병호
	wf_chulgo_print(ls_iojpno)

ELSE
	ROLLBACK;
END IF

Return nInsCnt


end function

public function integer wf_ins_lot (string siojpno, string sitnbr, decimal dioqty, string spec);Long lrow, i = 1, j, lrowcount, lfoundrow
String sIojp = '.', sLot
Double odQty, dQty, dTqty, dLotqty, dTotlotqty

/*품번별 LOTNO선입선출에 의한 출고수량 등록*/
DECLARE CUR_GET_QTY CURSOR FOR
SELECT LOTSNO, SUM(IOQTY)
FROM IMHIST 
WHERE ITNBR = :sItnbr
AND IOGBN = 'I1A'
AND PSPEC = :spec
GROUP BY  LOTSNO;

OPEN CUR_GET_QTY;

DO	
	FETCH CUR_GET_QTY INTO :sLot, :dQty;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	SELECT SUM(IOQTY)
	INTO :oDqTY
	FROM HOLDSTOCK_LOTNO
	WHERE LOTNO = :sLot
	AND ITNBR = :sItnbr;
	
	If IsNull(oDqty) Then oDqty = 0

	dTqty = dQty - oDqTY
	If dTqty <= 0 Then continue
	
	If dTqty >= dIoqty Then 
		lrow = dw_lot.insertrow(0)
		dw_lot.setitem(lrow,'ijpno',sIojp)
		dw_lot.setitem(lrow,'ojpno',siojpno)
		dw_lot.setitem(lrow,'seq',i)
		dw_lot.setitem(lrow,'itnbr',sItnbr)
		dw_lot.setitem(lrow,'lotno',sLot)
		dw_lot.setitem(lrow,'ioqty',dIoqty)
		dw_lot.setitem(lrow,'barid','')
		
		if dw_lot.update() = 1 then
			commit;
		else
			rollback;
		end if

		exit
	Else
		lrow = dw_lot.insertrow(0)
		dw_lot.setitem(lrow,'ijpno',sIojp)
		dw_lot.setitem(lrow,'ojpno',siojpno)
		dw_lot.setitem(lrow,'seq',i)
		dw_lot.setitem(lrow,'itnbr',sItnbr)
		dw_lot.setitem(lrow,'lotno',sLot)
		dw_lot.setitem(lrow,'ioqty',dTqty)
		dw_lot.setitem(lrow,'barid','')
		
		i++
	End If		
	dIoqty = dIoqty - dTqty
	dQty = 0;	dTqty = 0

LOOP WHILE TRUE 

CLOSE CUR_GET_QTY;		

RETURN 1
end function

public function integer wf_chulgo_print (string arg_iojpno);// 전표번호 자릿수 확인
if len(arg_iojpno) < 12 then return -1


string	ls_jpno
decimal	dqty


//----------------------------------------------------------------------------------------------
// 출고수량이 있는 경우에만 출력
ls_jpno = LEFT(arg_iojpno, 12)

select sum(ioreqty) into :dqty from imhist
 where sabu = :gs_sabu and iojpno like :ls_jpno||'%' ;
if isnull(dqty) or dqty = 0 then
	return -1
end if
//----------------------------------------------------------------------------------------------

If MessageBox('확인', '출고전표를 출력 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then
Else
	dw_print.Retrieve(ls_jpno)
	
	String ls_name
	ls_name = f_get_name5('02', gs_empno, '')
	
	dw_print.Modify("t_name.Text = '" + ls_name + "'")
	
	/* 프린터 미리보기 또는 프린터 설정 창이 뜬 후 종료(닫기)버튼을 누르면 출력되지 말아야 함. - 2006.12.13 by shingoon */
	OpenWithParm(w_print_options, dw_print)
	Long   ll_rtn
	ll_rtn = Message.DoubleParm
	
	If ll_rtn < 1 Then Return -1
	
//	dw_print.Modify("t_text.Text = '- 업 체 용 -'")
//	dw_print.Print()
//	dw_print.Modify("t_text.text= '- 고객지원팀 용 -'")
//	dw_print.Print()
End If

return 1
end function

on w_sal_06100.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_2=create st_2
this.st_haldang=create st_haldang
this.st_list=create st_list
this.pb_1=create pb_1
this.rr_4=create rr_4
this.dw_haldang_list=create dw_haldang_list
this.dw_lot=create dw_lot
this.dw_haldang=create dw_haldang
this.dw_1=create dw_1
this.dw_print=create dw_print
this.r_haldang_list=create r_haldang_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_haldang
this.Control[iCurrent+5]=this.st_list
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rr_4
this.Control[iCurrent+8]=this.dw_haldang_list
this.Control[iCurrent+9]=this.dw_lot
this.Control[iCurrent+10]=this.dw_haldang
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.dw_print
this.Control[iCurrent+13]=this.r_haldang_list
end on

on w_sal_06100.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_2)
destroy(this.st_haldang)
destroy(this.st_list)
destroy(this.pb_1)
destroy(this.rr_4)
destroy(this.dw_haldang_list)
destroy(this.dw_lot)
destroy(this.dw_haldang)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.r_haldang_list)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_input.SetTransObject(SQLCA)
dw_input.InsertRow(0)

dw_haldang.SetTransObject(SQLCA)
dw_haldang_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* 출고 담당자 Filtering */
DataWindowChild state_child
integer rtncode

rtncode 	= dw_input.GetChild('crt_user', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 출고 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('26',gs_saupj)

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

Wf_Init()

// 부가세 사업장 설정
//f_mod_saupj(dw_input, 'saupj')
dw_input.SetItem(1, 'saupj', gs_saupj)

// 창고설정
f_child_saupj(dw_input, 'depot_no', gs_saupj)

///* 기본창고 조회 */
String sDepotNo
sDepotNo = wf_DepotNo('1')
dw_input.SetItem(1,"depot_no",sDepotNo)

dw_input.SetItem(1,'crt_user',gs_empno)


end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event resize;r_haldang_list.width = this.width - 2253
dw_haldang_list.width = this.width - 2263

r_detail.width = this.width - 64
r_detail.height = this.height - r_detail.y - 65
dw_haldang.width = this.width - 74
dw_haldang.height = this.height - dw_haldang.y - 70
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", false) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = false //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_06100
integer x = 2597
integer y = 3004
end type

type sle_msg from w_inherite`sle_msg within w_sal_06100
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06100
end type

type st_1 from w_inherite`st_1 within w_sal_06100
end type

type p_search from w_inherite`p_search within w_sal_06100
integer x = 2665
integer y = 2996
end type

type p_addrow from w_inherite`p_addrow within w_sal_06100
integer x = 3168
integer y = 3088
end type

type p_delrow from w_inherite`p_delrow within w_sal_06100
integer x = 3346
integer y = 3088
boolean originalsize = false
end type

type p_mod from w_inherite`p_mod within w_sal_06100
boolean visible = true
integer x = 4078
integer width = 178
integer height = 144
string picturename = "..\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;string sSudat,sGbn,sJepumIo,sSaleGu, sNull
Long   Lrow

If dw_input.AcceptText() <> 1 Then Return

SetNull(sNull)

sSudat = dw_input.GetItemString(1,'sudat')
IF f_datechk(sSudat) <> 1 THEN
  f_message_chk(30,'[발행일자]')
  dw_input.SetColumn("sudat")
  dw_input.SetFocus()
  Return
END IF

IF rb_1.Checked = True THEN
	If dw_haldang.AcceptText() <> 1 Then Return
	
	For Lrow = 1 to dw_haldang.rowcount()
		 If dw_haldang.getitemdecimal(Lrow, "ciqty") > dw_haldang.getitemdecimal(Lrow, "hold_qty") then
			 MessageBox("출하의뢰수량", "송장수량이 출하의뢰수량보다 큽니다", stopsign!)
			 dw_haldang.selectrow(Lrow, True)
			 dw_haldang.scrolltorow(Lrow)
		 End if		
	NExt
	
	IF Wf_Create_Imhist() <> 1 THEN RETURN
	
	dw_haldang.Reset()
	p_inq.TriggerEvent(Clicked!) // 출하의뢰 list 조회 
ELSE
	IF Wf_Delete_Imhist() <> 1 THEN RETURN
	
	dw_haldang.Reset()
	
	dw_input.SetItem(1,'iojpno',sNull)
	dw_input.SetItem(1,'sarea',sNull)
	dw_input.SetItem(1,'cvcod',sNull)
	dw_input.SetItem(1,'vndname',sNull)
	p_inq.TriggerEvent(Clicked!) // 출하의뢰 list 조회
END IF

sle_msg.text = '자료를 처리하였습니다!!'
ib_any_typing = False
end event

event p_mod::ue_lbuttondown;PictureName = "..\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "..\image\처리_up.gif"
end event

type p_del from w_inherite`p_del within w_sal_06100
integer x = 3611
integer y = 2964
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_06100
integer x = 3899
integer y = 2964
end type

event p_inq::clicked;call super::clicked;String sJepumIo,sSaleGu,sGbn,sCvcod, sCvcodNm, sArea, sSuDat, sIoDate, sSaupj, sDepotNo

If dw_input.AcceptText() <> 1 Then Return

sSaupj = Trim(dw_input.GetItemSTring(1,"saupj"))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	Return
End If

sSuDat = Trim(dw_input.GetItemSTring(1,"sudat"))
sCvcod = Trim(dw_input.GetItemSTring(1,"cvcod"))
If IsNull(sCvcod) or sCvcod = '' then sCvcod = '%'

sDepotNo = Trim(dw_input.GetItemSTring(1,"depot_no"))
If IsNull(sDepotNo) Or sDepotNo = '' Then
	f_message_chk(1400,'[출고창고]')
	Return
End If

sGbn = Trim(dw_input.GetItemString(1,"iogbn"))
//유무상 구분을 조건에서 제외
sJepumIo = '%'
sSaleGu  = '%'

p_mod.Enabled = True

IF dw_haldang_list.Retrieve(gs_sabu,sCvcod,sJepumIo,sSaleGu, sSaupj, sDepotNo) <=0 THEN
	f_message_chk(50,'')
	dw_1.Reset()
	dw_haldang.Reset()
	dw_input.Setfocus()
	Return
ELSE
	dw_1.Reset()
	dw_haldang.Reset()
	dw_haldang_list.SetFocus()
END IF

dw_input.Modify('iogbn.protect = 1')
dw_input.Modify("iogbn.background.color = 80859087")

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sal_06100
integer x = 2839
integer y = 2964
boolean enabled = false
end type

type p_can from w_inherite`p_can within w_sal_06100
integer x = 4256
integer y = 2964
end type

event p_can::clicked;call super::clicked;rollback;

Wf_Init()
end event

type p_exit from w_inherite`p_exit within w_sal_06100
integer x = 4434
integer y = 2964
end type

type p_ins from w_inherite`p_ins within w_sal_06100
integer x = 3141
integer y = 2964
boolean enabled = false
end type

type p_new from w_inherite`p_new within w_sal_06100
integer x = 1929
integer y = 3148
end type

type dw_input from w_inherite`dw_input within w_sal_06100
event ue_key pbm_dwnkey
integer y = 280
integer width = 2158
integer height = 352
integer taborder = 10
string dataobject = "d_sal_061001"
end type

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String sNull, sIojpno, sIoConFirm, sSudate, sIoDate, SDepotNo
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

accepttext()

Choose Case GetColumnName() 
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		IF sModStatus = 'I' THEN
			f_child_saupj(this, 'sarea', sSaupj)
			f_child_saupj(this, 'depot_no', sSaupj)
		ELSE
			f_child_saupj(this, 'sarea', '%')
			f_child_saupj(this, 'depot_no', '%')
		END IF
		
		sDepotNo = wf_DepotNo('1')
		setitem(1, "depot_no", sDepotNo)		
	Case "iojpno"
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
		SELECT DISTINCT "IMHIST"."IO_DATE"   INTO :sIoDate
		  FROM "IMHIST"  
		WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
				 ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
					( "IMHIST"."JNPCRT" ='014');
	
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
	//		IF Not IsNull(sIoDate) THEN
	//			f_message_chk(59,'[출고 확인]')
	//			this.SetItem(1,"iojpno",snull)
	//			Return 1
	//		END IF
			
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
	
			sName1 = '2'
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

		sName1 = '2'
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
END Choose
end event

event rbuttondown;String sIogbn

SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
  Case "iojpno"
		sIoGbn = Trim(GetItemString(1,'iogbn'))
		If sIoGbn = 'Y' Then
	    gs_gubun = '014'        //판매출고
		Else
		  gs_gubun = '001'        //무상출고
		End If
		
	  gs_codename = 'B'  /* 출고확인 전/후 */
	  Open(w_imhist_02040_popup)
	
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	  SetItem(1,"iojpno",Left(gs_code,12))
	  cb_inq.PostEvent(Clicked!)
	/* 거래처 */
	Case "cvcod", "vndname"
		gs_gubun = '2'
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

type cb_delrow from w_inherite`cb_delrow within w_sal_06100
boolean visible = false
integer x = 1966
integer y = 3164
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_06100
boolean visible = false
integer x = 1655
integer y = 3164
end type

type dw_insert from w_inherite`dw_insert within w_sal_06100
boolean visible = false
integer x = 974
integer y = 2996
integer width = 818
integer height = 100
integer taborder = 0
boolean titlebar = true
string title = "출고송장 발행"
boolean minbox = true
boolean maxbox = true
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

type cb_mod from w_inherite`cb_mod within w_sal_06100
boolean visible = false
integer x = 1902
integer y = 3004
integer taborder = 70
boolean enabled = false
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_sal_06100
boolean visible = false
integer x = 46
integer y = 2676
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06100
boolean visible = false
integer x = 914
integer y = 2680
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06100
boolean visible = false
integer x = 114
integer y = 2992
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_06100
boolean visible = false
integer x = 453
integer y = 2992
integer width = 439
boolean enabled = false
string text = "송장출력(&P)"
end type

type cb_can from w_inherite`cb_can within w_sal_06100
boolean visible = false
integer x = 2249
integer y = 3004
integer taborder = 80
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_06100
boolean visible = false
integer x = 402
integer y = 2688
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_sal_06100
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06100
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06100
end type

type r_head from w_inherite`r_head within w_sal_06100
integer y = 224
integer width = 2167
integer height = 412
end type

type r_detail from w_inherite`r_detail within w_sal_06100
integer y = 672
integer width = 4585
integer height = 1636
end type

type rb_1 from radiobutton within w_sal_06100
integer x = 55
integer y = 68
integer width = 247
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

type rb_2 from radiobutton within w_sal_06100
integer x = 302
integer y = 68
integer width = 247
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
end event

type st_2 from statictext within w_sal_06100
integer x = 82
integer y = 204
integer width = 302
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33028087
string text = "[검색조건]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_haldang from statictext within w_sal_06100
integer x = 2290
integer y = 204
integer width = 434
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33028087
string text = "[출하의뢰현황]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_list from statictext within w_sal_06100
integer x = 78
integer y = 656
integer width = 494
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33028087
string text = "[출하의뢰현황]"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pic_cal within w_sal_06100
integer x = 1806
integer y = 308
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('sudat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'sudat', gs_code)

end event

type rr_4 from roundrectangle within w_sal_06100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 32
integer width = 535
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_haldang_list from datawindow within w_sal_06100
integer x = 2226
integer y = 256
integer width = 2386
integer height = 372
integer taborder = 30
string dataobject = "d_sal_061002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;String sCino

IF Row <=0 THEN RETURN
SelectRow(0,False)
SelectRow(Row,True)

If dw_input.AcceptText() <> 1 Then Return

sCino    = Trim(GetItemSTring(Row,"cino"))
	
IF dw_haldang.Retrieve(gs_sabu, sCino) <=0 THEN 
	f_message_chk(50,'')
	dw_input.Setfocus()
	Return
END IF

ib_any_typing = False


end event

event rowfocuschanged;IF currentrow > 0 THEN
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	this.ScrollToRow(currentrow)
END IF
end event

type dw_lot from u_d_popup_sort within w_sal_06100
boolean visible = false
integer x = 2770
integer y = 104
integer width = 1262
integer height = 1092
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_020410"
boolean border = false
end type

event clicked;call super::clicked;Long lRow 

lRow = row
if lRow <= 0 then return

dw_lot.selectrow(0, false)
dw_lot.selectrow(lRow, true)
end event

event dberror;call super::dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)

RETURN 1
end event

type dw_haldang from u_d_popup_sort within w_sal_06100
integer x = 37
integer y = 712
integer width = 4576
integer height = 1588
integer taborder = 40
string dataobject = "d_sal_061006"
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
string sconemp

sconemp = dw_input.object.crt_user[1]

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',sconemp)
		Case DataModified!
			This.SetItem(ix,'upd_user',sconemp)
	End Choose
Next
end event

event itemchanged;call super::itemchanged;Long 	nRow
Long 	lOldQty, lQty

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* 출고수량 분할*/
	Case 'valid_qty'
		lQty = Long(GetText())
		If lQty <= 0 Then
			MessageBox('확 인','[출고수량은 0이하로 할 수 없습니다]')
			Return 1
		End If
		
		lOldQty = GetItemNumber(nRow, 'valid_qty', Primary!, True)
		sle_msg.text = '할당잔량 = ' + string(loldqty)
		
		If lQty > lOldQty Then
			MessageBox('확 인','[출고수량은 할당잔량 이상으로 할 수 없습니다]~r~n~r~n'+'할당잔량 = ' + string(loldqty))
			Return 1
		End If
		
	Case 'flag_choice'
		IF rb_1.Checked = True THEN
			This.SetItem(nRow, 'hold_qty', This.GetItemNumber(nRow, 'ciqty'))
		End IF
End Choose
end event

event constructor;call super::constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

event rbuttondown;call super::rbuttondown;Long nRow
 
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = row
If nRow <= 0 Then Return

/*
Choose Case GetColumnName()
	/* LOTNO */
	Case "lotsno"
		gs_code = GetItemString(nRow,'itnbr')
		Open(w_lotno_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"lotsno",gs_code)
End Choose
*/
end event

event doubleclicked;call super::doubleclicked;/*
if row <= 0 then return

string sCvcod, sItnbr, sParm
double dRest, dPcnt, dTot = 0
str_02040 str_pspec
long lnewrow, i, j, lend, lfoundrow

dPcnt = double(object.pcnt[row])
if dPcnt <= 0 then return

sCvcod = object.cvcod[row]
sItnbr = object.itnbr[row]
dRest = object.rest_qty[row]

sParm = sCvcod + ',' + sItnbr + ',' + string(dRest) + ',' + string(dPcnt) + ','

openwithparm(w_sal_06100_p_pspec, sParm)

str_pspec = Message.PowerObjectParm

if isvalid(str_pspec) then
	lend = dw_1.RowCount() + 1
	lfoundrow = 1
	lfoundrow = dw_1.find("itnbr = '" + sItnbr + "'", lfoundrow, lend)

	DO WHILE lfoundrow > 0
		dw_1.deleterow(lfoundrow)
        	lfoundrow++
        	lfoundrow = dw_1.find("itnbr = '" + sItnbr + "'", lfoundrow, lend)
	LOOP
	
	for i = 1 to upperbound(str_pspec.sitnbr)
		if str_pspec.dqty[i] > 0 then
			lnewrow = dw_1.insertrow(0)
			dw_1.setitem(lnewrow,'itnbr',str_pspec.sitnbr[i])
			dw_1.setitem(lnewrow,'pspec',str_pspec.spspec[i])
			dw_1.setitem(lnewrow,'qty',str_pspec.dqty[i]) 
			dTot = dTot + str_pspec.dqty[i]
		end if
	next
	setitem(row,'choice_qty',dTot)
	setItem(row,"flag_choice", 'Y')
end if
*/
end event

type dw_1 from datawindow within w_sal_06100
boolean visible = false
integer x = 1431
integer y = 1364
integer width = 1440
integer height = 660
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sal_06100_popup2"
boolean border = false
boolean livescroll = true
end type

type dw_print from datawindow within w_sal_06100
boolean visible = false
integer x = 1449
integer y = 1380
integer width = 686
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06100_chul_p_new"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type r_haldang_list from rectangle within w_sal_06100
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 33028087
integer x = 2222
integer y = 224
integer width = 2395
integer height = 412
end type

