$PBExportHeader$w_dm01_00010.srw
$PBExportComments$출고송장 등록
forward
global type w_dm01_00010 from w_inherite
end type
type rb_1 from radiobutton within w_dm01_00010
end type
type rb_2 from radiobutton within w_dm01_00010
end type
type cbx_select from checkbox within w_dm01_00010
end type
type dw_cond from u_key_enter within w_dm01_00010
end type
type dw_haldang_list from datawindow within w_dm01_00010
end type
type cbx_all from checkbox within w_dm01_00010
end type
type dw_list from datawindow within w_dm01_00010
end type
type st_2 from statictext within w_dm01_00010
end type
type st_list from statictext within w_dm01_00010
end type
type st_haldang from statictext within w_dm01_00010
end type
type rb_napip from radiobutton within w_dm01_00010
end type
type rb_chul from radiobutton within w_dm01_00010
end type
type gb_1 from groupbox within w_dm01_00010
end type
type rr_1 from roundrectangle within w_dm01_00010
end type
type rr_2 from roundrectangle within w_dm01_00010
end type
type rr_3 from roundrectangle within w_dm01_00010
end type
type rr_4 from roundrectangle within w_dm01_00010
end type
type rb_can from radiobutton within w_dm01_00010
end type
type pb_1 from u_pb_cal within w_dm01_00010
end type
type dw_haldang from u_d_popup_sort within w_dm01_00010
end type
type dw_imhist from u_d_popup_sort within w_dm01_00010
end type
end forward

global type w_dm01_00010 from w_inherite
integer height = 2712
string title = "출고의뢰등록(계획)"
rb_1 rb_1
rb_2 rb_2
cbx_select cbx_select
dw_cond dw_cond
dw_haldang_list dw_haldang_list
cbx_all cbx_all
dw_list dw_list
st_2 st_2
st_list st_list
st_haldang st_haldang
rb_napip rb_napip
rb_chul rb_chul
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
rb_can rb_can
pb_1 pb_1
dw_haldang dw_haldang
dw_imhist dw_imhist
end type
global w_dm01_00010 w_dm01_00010

type variables
String LsIoJpNo,LsSuBulDate
String sSyscnfg_Yusin, sMinus, sValidMinus
end variables

forward prototypes
public function integer wf_check_yusin (integer nrow, string smsg)
public subroutine wf_init ()
public function integer wf_danga (integer nrow)
public function integer wf_create_imhist ()
public function integer wf_delete_imhist ()
public function decimal wf_calc_jego (integer nrow)
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

public subroutine wf_init ();String sNull

SetNull(sNull)

rollback;

dw_imhist.Reset()
dw_haldang.Reset()
dw_insert.Reset()   // 출력물 

dw_cond.SetItem(1, "sudat", is_today)

dw_cond.Modify('depot_no.protect = 0')
dw_cond.Modify('iogbn.protect = 0')

IF sModStatus = 'I' THEN
	st_list.Text = '[품목현황]'
	st_haldang.Text = '[출하의뢰현황]'
	
	p_print.Enabled = True
	dw_haldang.Visible = True

	p_search.Enabled = False
	p_search.PictureName = 'C:\erpman\image\저장_d.gif'
	
	dw_cond.Modify('iojpno.protect = 1')

	dw_cond.SetFocus()
	dw_cond.SetColumn("saupj")
	
//	gb_1.Visible = True
//	rb_napip.Visible = True
//	rb_chul.Visible = True
//	rb_can.Visible = True
ELSE
	st_list.Text = '송장 현황'
	st_haldang.Text = '송장 현황'
	
	p_print.Enabled = False
	dw_imhist.Visible  = True
	dw_haldang.Visible = False

	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\저장_up.gif'
	
	dw_cond.Modify('iojpno.protect = 0')

	dw_cond.SetFocus()
	dw_cond.SetColumn("iojpno")
	
//	gb_1.Visible = False
//	rb_napip.Visible = False
//	rb_chul.Visible = False
//	rb_can.Visible = False
END IF

/* 할당현항,송장현황 데이타원도우 */
String sParsal

dw_haldang_list.SetRedraw(False)
If sModStatus = 'I' Then
	dw_haldang_list.Reset()
	If rb_napip.Checked Then
		dw_haldang_list.DataObject = 'd_dm01_00010_1'
		dw_haldang.DataObject 		= 'd_dm01_00010_2'
	Else
//		dw_haldang_list.DataObject = 'd_sal_020404'
		dw_haldang_list.DataObject = 'd_dm01_00010_3'
		dw_haldang.DataObject 		= 'd_dm01_00010_4'
	End If
	dw_haldang_list.SetTransObject(sqlca)
	dw_haldang.SetTransObject(sqlca)
Else
	dw_haldang_list.Reset()
	dw_haldang_list.DataObject = 'd_dm01_00010_5'
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

public function integer wf_danga (integer nrow);String sCvcod, sItnbr, stoday, sfilsk, sitgu, sDitnbr
Dec	 dDanga

If nRow <= 0 Then Return 1

sToday	= f_today()
sCvcod	= Trim(dw_haldang.GetItemString(nRow, 'cvcod'))
sItnbr	= Trim(dw_haldang.GetItemString(nRow, 'itnbr'))

SELECT fun_erp100000012_1(:sToday, :sCVCOD, :sITNBR, '1') INTO :dDanga FROM DUAL;

//dDanga = SQLCA.fun_erp100000012_1(sToday, sCVCOD, sITNBR, '1')
If IsNull(dDanga) Then dDanga = 0

SELECT FILSK, ITGU INTO :sfilsk, :sitgu FROM ITEMAS WHERE ITNBR = :sItnbr;

dw_haldang.Setitem(nRow, 'prc', dDanga)
dw_haldang.Setitem(nRow, 'itemas_filsk', sfilsk)
dw_haldang.Setitem(nRow, 'itemas_itgu', sitgu)

// 대체 품번을 찾는다
SELECT ITNBR INTO :sDitnbr FROM ITEM_REL WHERE ITNBRMD = :sItnbr;

dw_haldang.Setitem(nRow, 'ditnbr', sDitnbr)

Return 0


end function

public function integer wf_create_imhist ();Long iFunctionValue, iRowCount, k, iMaxIoNo, iCurRow, iAryCnt, hrow=0, Inrow, OutRow, nRowCnt
String  sCvcod, sSaupj, sDirgb, sHoldNo, sNewHoldSeq
Decimal {5}  dOrdPrc, dValQty, dOrdAmt, dOrdQty, dVatAmt, dChkvat, dChkqty, dRstvat, dSangprc

String sQcgub, sNull, sOutIoNo, sInIoNo, sHoldGu, sItnbr, sPspec, sInStore, sOutStore
String sCustNapgi, sNaougu, sOrderNo, sAuto, sNappum, sIogbn, sDitnbr, sDittyp
String sTaOutIogbn, sTaInIogbn, sHousegubun, sTagbn, sTaOutJpno, sTaOutStore, sTaInJpno, sChk

SetNull(sNull)

If dw_haldang.RowCount() <= 0 Then Return -1

dw_insert.Reset()

sDirgb  = Trim(dw_cond.GetItemSTring(1,"dirgb"))
sChk	  = Trim(dw_cond.GetItemSTring(1,"chk"))		// 주야구분
LsSuBulDate = Trim(dw_cond.GetItemString(1,'sudat'))

If f_datechk(LsSuBulDate) <> 1 Then
	f_message_chk(1200,'[출하일자]')
	Return -1
End If

/* 판매출고 송장번호 채번 */
iMaxIoNo = sqlca.fun_junpyo(gs_sabu,LsSuBulDate, 'C0')
IF iMaxIoNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
commit;
LsIoJpNo = LsSuBulDate + String(iMaxIoNo,'0000')

dw_imhist.Reset()
iAryCnt = 1

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


/* 타계정에 대한 출고/입고 수불구분 */
sTaOutIogbn = 'O25'

setnull(sTaInIogbn)
SELECT RCVCOD, TAGBN
  INTO :sTaInIogbn, :sTagbn
  FROM IOMATRIX
 WHERE SABU = :gs_sabu		AND
		 IOGBN = :sTaOutIogbn ;
		  
If sqlca.sqlcode <> 0 then
	f_message_chk(208, '[출고구분]')
	RollBack;
	Return -1
End If
			
sSaupj   = Trim(dw_cond.GetItemSTring(1,"saupj"))
sIogbn 	= 'O02'	// 판매출고

sOutStore = dw_cond.GetItemString(1, "depot_no")	/* 출고창고 */
sInStore  = dw_cond.GetItemString(1, "depot_no")	/* 납품창고 */

/* 창고자동승인 여부 */
select email into :sAuto from vndmst where cvcod = :sOutStore;
If IsNull(sAuto) Or sAuto = '' Then sAuto = 'N'

/* 출하처리인 경우만 */
If rb_napip.Checked Or rb_chul.Checked Then
	nRowCnt = dw_haldang.RowCount()
	For k = nRowCnt TO 1 Step -1
		/* 거래처및 관할구역,검수구분(0:무검수,1:검수) */
		sCvcod = Trim(dw_haldang.GetItemString(K, "cvcod"))
		If IsNull(sCvcod) Or sCvcod = '' Then
			// 취소전표가 아니면 업체코드 체크하며 취소전표인 경우에는 거래처가 없어도 저장하게 수정
			If dw_haldang.GetItemString(k,"out_chk") <> '3' Then
				f_message_chk(1400,'[거래처]')
				Return -1
			End If
		End If
		
		SELECT "VNDMST"."GUMGU"   INTO :sNappum
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sCvcod;
		
		If IsNull(sNappum) Then sNappum = 'N'

		/* 처리가능한 카드인지 확인한다 */
		If rb_napip.Checked Then
			sDitnbr = Trim(dw_haldang.GetItemString(k,"ditnbr"))
			
			/* 타계정품번이 존재하는 경우 AS품(중간품) 여부 확인 */
			If sDitnbr > '' Then
				SELECT ITTYP INTO :sDittyp FROM ITEMAS WHERE ITNBR = :sDitnbr;		
				If sDittyp <> '1' And sDittyp <> '2' Then	CONTINUE
				
				sHouseGubun = 'Y'
				
				// 타계정 대체 출고 창고
				If sDittyp = '1' Then
					sTaOutStore = sOutStore
				End If
				If sDittyp = '2' Then
					select cvcod into :sTaOutStore from vndmst where cvgu = '5' and jumaechul = '1' and jumaeip = :sDittyp;
				End If
			Else
				sHouseGubun = 'N'
			End If
		Else
			sHouseGubun = 'N'
		End If
		
		sDittyp = dw_haldang.GetItemString(k, 'ittyp')
		
		IF dw_haldang.GetItemString(k,"flag_choice") = 'Y' And dw_haldang.GetItemnumber(k,"valid_qty") > 0 THEN
	
			sOrderNo = Trim(dw_haldang.GetItemString(k,"order_no"))
	
			/* 출고단가 */
			dOrdPrc = dw_haldang.GetItemNumber(k,"prc")
			If IsNull(dOrdPrc) Then dOrdPrc = 0
	
			/* 출고수량 */
			dValQty = dw_haldang.GetItemNumber(k,"valid_qty")
			If IsNull(dValQty) Then dValQty = 0
			
			sHoldGu = sIogbn
			sItnbr  = Trim(dw_haldang.GetItemString(k, "itnbr"))
			sPspec  = '.'
					
			SetNull(sInIoNo)
	
			/* 판매출고 전표를 생성한다 */
			iCurRow = dw_imhist.InsertRow(0)
			
			dw_imhist.SetItem(iCurRow,"sabu",       gs_sabu)
			
			sOutIoNo = LsIoJpNo + String(iCurRow,'000')
			dw_imhist.SetItem(iCurRow,"iojpno", 	 sOutIoNo)
			
			dw_imhist.SetItem(iCurRow,"iogbn",      sHoldGu)
			dw_imhist.SetItem(iCurRow,"sudat",      LsSuBulDate)
			dw_imhist.SetItem(iCurRow,"itnbr",      sItnbr)
			
			dw_imhist.SetItem(iCurRow,"pspec",      sPspec)
			
			Choose Case sDittyp
				Case '1','8' // 완제품, 가상품
					dw_imhist.SetItem(iCurRow,"depot_no",   sInStore)
				Case '2' // 반제품
					dw_imhist.SetItem(iCurRow,"depot_no",   'Z02')
				Case Else
					dw_imhist.SetItem(iCurRow,"depot_no",   'Z30')
			End Choose
			
			dw_imhist.SetItem(iCurRow,"cvcod",	    trim(dw_haldang.GetItemString(k,"cvcod")))
	
			dw_imhist.SetItem(iCurRow,"sarea",	    'N') // 납입카드 대사 확인 유무
			
			/* 단가 및 금액 */
			dw_imhist.SetItem(iCurRow,"ioprc",		 dOrdPrc)
			dw_imhist.SetItem(iCurRow,"ioamt",		 TrunCate(dOrdPrc * dValQty,0))
			
			dw_imhist.SetItem(iCurRow,"insdat",     LsSuBulDate)
			dw_imhist.SetItem(iCurRow,"ioreqty",	 dValQty)
			dw_imhist.SetItem(iCurRow,"iosuqty",	 dValQty)
			
			dw_imhist.SetItem(iCurRow,"hold_no",	 sNull)	// 할당번호 null
			
			dw_imhist.SetItem(iCurRow,"pjt_cd",		 trim(dw_haldang.GetItemString(k,"hold_no")))	// 출하의뢰번호
			
			dw_imhist.SetItem(iCurRow,"order_no",	 trim(dw_haldang.GetItemString(k,"order_no")))
	
			dw_imhist.SetItem(iCurRow,"filsk",   	 dw_haldang.GetItemString(k,"itemas_filsk")) /* 재고관리구분 */
			dw_imhist.SetItem(iCurRow,"itgu",	    dw_haldang.GetItemString(k,"itemas_itgu"))  /* 구입형태 */
			dw_imhist.SetItem(iCurRow,"bigo",	    sNull)

			dw_imhist.SetItem(iCurRow,"outchk",	    'N')
			dw_imhist.SetItem(iCurRow,"jnpcrt",	    '004')	/* 전표생성구분 */

			dw_imhist.SetItem(iCurRow,"opseq",	    '9999')
			dw_imhist.SetItem(iCurRow,"saupj",	    sSaupj)	/* 부가사업장 */
	
			dw_imhist.SetItem(iCurRow,"loteno",    trim(dw_haldang.GetItemString(k,"loteno")))		 // LOT NO
			dw_imhist.SetItem(iCurRow,"lotsno",    trim(dw_haldang.GetItemString(k,"lotsno")))		 // LOT NO

			dw_imhist.SetItem(iCurRow,"dyebi3",	    0) /* 부가세 */
			
			If sAuto = 'Y' Then
				dw_imhist.SetItem(iCurRow,"ioqty",		 dValQty)
				dw_imhist.SetItem(iCurRow,"io_date",    LsSuBulDate)
				dw_imhist.SetItem(iCurRow,"io_empno",	 gs_empno)
				
				/* 검수일자 사용안할 경우 */
				If sNappum = 'N'  Then
					dw_imhist.SetItem(iCurRow,"yebi1",   LsSuBulDate)
					dw_imhist.SetItem(iCurRow,"io_confirm", 'Y')
				Else
					dw_imhist.SetItem(iCurRow,"yebi1",   sNull)
					dw_imhist.SetItem(iCurRow,"io_confirm", 'N')
				End If
			Else
				dw_imhist.SetItem(iCurRow,"ioqty",		 0)
				dw_imhist.SetItem(iCurRow,"io_date",    sNull)
				dw_imhist.SetItem(iCurRow,"io_empno",	 sNull)
			End If
			
			dw_imhist.SetItem(iCurRow,"facgbn",		trim(dw_haldang.GetItemString(k,"plnt")))	// 고객구분
			dw_imhist.SetItem(iCurRow,"gungbn",		dw_cond.GetItemString(1,"chk")) 					// 오전/오후 출차 구분
	
			// 납입카드인 경우
			If rb_napip.Checked Or rb_can.Checked Then
				//dw_imhist.SetItem(iCurRow,"field_cd",	sDitnbr) // 대체 품번
				dw_imhist.SetItem(iCurRow,"field_cd",    trim(dw_haldang.GetItemString(k,"cv_order_no"))) // 발주번호 
				dw_imhist.SetItem(iCurRow,"yebi3",		  'H')	// 고객구분-현대
			Else
				dw_imhist.SetItem(iCurRow,"yebi3",		trim(dw_haldang.GetItemString(k,"gubun")))	// 고객구분
			End If
			
			dw_imhist.SetItem(iCurRow, 'dyebi1', 1)			// 외화환율
			dw_imhist.SetItem(iCurRow, 'dyebi2', dOrdPrc)	// 외화단가
			dw_imhist.SetItem(iCurRow, 'foramt', TrunCate(dOrdPrc * dValQty,0))	// 외화금액
			dw_imhist.SetItem(iCurRow, 'yebi2', 'WON')		// 통화단위
			dw_imhist.SetItem(iCurRow, 'lclgbn', 'V')			// 내수/LOCAL
			
			/* 출고단가 */
			dSangprc = dw_haldang.GetItemNumber(k,"sangprc")
			If IsNull(dSangprc) Then dSangprc = 0
			dw_imhist.SetItem(iCurRow, 'pacprc', dSangprc)
			
			/* -------- 타계정 출고인 경우 ---------- */
			IF sHouseGubun = 'Y'		THEN
				iCurRow = dw_imhist.InsertRow(0)
				
				dw_imhist.SetItem(iCurRow, "sabu",		gs_sabu)
				dw_imhist.SetItem(iCurRow, "jnpcrt",	'004')			// 전표생성구분
				dw_imhist.SetItem(iCurRow, "inpcnf",   'O')				// 입출고구분
				
				sTaOutJpno = LsIoJpNo + String(iCurRow,'000')
				dw_imhist.SetItem(iCurRow, "iojpno", 	sTaOutJpno)
				dw_imhist.SetItem(iCurRow, "iogbn",   	sTaOutIogbn) 			// 수불구분=요청구분
				dw_imhist.SetItem(iCurRow, "sudat",		LsSuBulDate)			// 수불일자=출고일자
				dw_imhist.SetItem(iCurRow, "itnbr",		sDitnbr) 				// 타계정 품번
				dw_imhist.SetItem(iCurRow, "pspec",		'.')
				dw_imhist.SetItem(iCurRow, "depot_no",	sTaOutStore)			// 출고창고
				dw_imhist.SetItem(iCurRow, "cvcod",		sInStore) 				// 입고창고
				dw_imhist.SetItem(iCurRow, "ioqty",		dValQty) 				// 수불수량=출고수량
				dw_imhist.SetItem(iCurRow, "ioreqty",	dValQty) 				// 수불의뢰수량=출고수량		
				dw_imhist.SetItem(iCurRow, "insdat",	LsSuBulDate)			// 검사일자=출고일자	
				dw_imhist.SetItem(iCurRow, "iosuqty",	dValQty) 				// 합격수량=출고수량		
				dw_imhist.SetItem(iCurRow, "opseq",		'9999')					// 공정코드
				dw_imhist.SetItem(iCurRow, "io_confirm",	'Y')					// 수불승인여부
				dw_imhist.SetItem(iCurRow, "io_date",	LsSuBulDate)			// 수불승인일자=출고일자	
				dw_imhist.SetItem(iCurRow, "io_empno", gs_empno)				// 수불승인자=담당자	
				dw_imhist.SetItem(iCurRow, "hold_no",  sNull) 					// 할당번호
				dw_imhist.SetItem(iCurRow, "botimh",	'N')						// 동시출고여부
				dw_imhist.SetItem(iCurRow, "filsk",    dw_haldang.GetItemString(k,"itemas_filsk"))  // 재고관리유무
				dw_imhist.SetItem(iCurRow, "itgu",     dw_haldang.GetItemString(k,"itemas_itgu")) 	// 구입형태
				dw_imhist.SetItem(iCurRow, "outchk",   'Y')	 					// 출고의뢰완료
				dw_imhist.SetItem(iCurRow, "pjt_cd",   sNull)					// 프로젝트No
				dw_imHist.SetItem(iCurRow, "ip_jpno",  sOutIoNo)  				// 입고전표번호=출고번호
				dw_imHist.SetItem(iCurRow, "saupj", 	sSaupj)
				
				// 타계정 입고 전표
				iCurRow = dw_imhist.InsertRow(0)						
				
				dw_imhist.SetItem(iCurRow, "sabu",		gs_sabu)
				dw_imHist.SetItem(iCurRow, "jnpcrt",	'004')			// 전표생성구분
				dw_imHist.SetItem(iCurRow, "inpcnf",   'I')				// 입출고구분
				
				sTaInJpno = LsIoJpNo + String(iCurRow,'000')
				dw_imHist.SetItem(iCurRow, "iojpno", 	sTaInJpno)
				dw_imHist.SetItem(iCurRow, "iogbn",    sTaInIogbn) 		// 수불구분=창고이동입고구분
				dw_imHist.SetItem(iCurRow, "sudat",		LsSuBulDate)		// 수불일자=출고일자
				dw_imHist.SetItem(iCurRow, "itnbr", 	sItnbr) 				// 타계정 품번
				dw_imHist.SetItem(iCurRow, "pspec", 	'.') 					// 사양
				dw_imHist.SetItem(iCurRow, "depot_no", sInStore)		 	// 기준창고=입고처
				dw_imHist.SetItem(iCurRow, "cvcod",		sTaOutStore) 		// 거래처창고=출고창고
				dw_imhist.SetItem(iCurRow, "opseq",		'9999')				// 공정코드
				dw_imHist.SetItem(iCurRow, "ioreqty",	dValQty) 			// 수불의뢰수량=출고수량		
				dw_imHist.SetItem(iCurRow, "insdat",	LsSuBulDate)		// 검사일자=출고일자	
				dw_imHist.SetItem(iCurRow, "qcgub",		sQcgub)				// 검사방법=> 무검사
				dw_imHist.SetItem(iCurRow, "iosuqty",	dValQty) 			// 합격수량=출고수량		
				dw_imHist.SetItem(iCurRow, "filsk",    dw_haldang.GetItemString(k,"itemas_filsk")) 	// 재고관리유무
				
				// 타계정은 무조건 승인
				dw_imhist.SetItem(iCurRow, "io_confirm", 'Y')	 		// 수불승인여부
				dw_imhist.SetItem(iCurRow, "ioqty",    dValQty) 		// 수불수량=입고수량
				dw_imhist.SetItem(iCurRow, "io_date",  LsSuBulDate)	// 수불승인일자=입고의뢰일자
				dw_imhist.SetItem(iCurRow, "io_empno", sNull)	 		// 수불승인자=NULL
				dw_imHist.SetItem(iCurRow, "botimh",	'N')				// 동시출고여부
				dw_imHist.SetItem(iCurRow, "itgu",    '5')		 	 	// 구입형태
				dw_imHist.SetItem(iCurRow, "ioredept", sNull)		 // 수불의뢰부서=할당.부서
				dw_imHist.SetItem(iCurRow, "ioreemp",	gs_empno)	 // 수불의뢰담당자=담당자	
				dw_imHist.SetItem(iCurRow, "ip_jpno",  sOutIoNo) 	 // 입고전표번호=출고번호
				dw_imHist.SetItem(iCurRow, "saupj", 	sSaupj)
			End If
			/* ----- 타계정 출고 끝 -------- */
			
			iAryCnt = iAryCnt + 1
	
			/* 할당상태변경 */
			dw_haldang.SetItem(k,'out_chk', '2')	/* 출고의뢰 */
//			dw_haldang.SetItem(k,'isqty', dw_haldang.GetItemNumber(k, 'isqty') + dValQty)	/* 출하수량 */
//			
//			If sChk = 'N' Then	// 야간인 경우
//				dw_haldang.SetItem(k,'itm_qty4', dw_haldang.GetItemNumber(k, 'itm_qty4') + dValQty)
//			Else
//				dw_haldang.SetItem(k,'itm_qty5', dw_haldang.GetItemNumber(k, 'itm_qty5') + dValQty)
//			End If
		END IF
		
		/* 행추가로 인한 경우는 삭제한다*/
		If dw_haldang.GetItemStatus(k, 0, Primary!) = NewModified! Then
			dw_haldang.RowsDisCard(k,k, Primary!)
		End If
	Next
End if

/* 할당 저장 */
IF dw_haldang.Update() = 1 Then
Else
	ROLLBACK;
	Messagebox("할당저장", "할당저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
	Return -1
End If

/* 출하처리인 경우만 */
If rb_napip.Checked Or rb_chul.Checked Then
	IF dw_imhist.Update() = 1 Then
	Else
		Messagebox("입출고저장", "입출고저장시 오류발생" + '~n' + string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext, stopsign!)
		ROLLBACK;
		
		Return -1
	End If
End If

COMMIT;

Return 1
end function

public function integer wf_delete_imhist ();Long   iRowCount,k,iImhistRow,iAryCnt, nCnt, dInvQty
String sHoldNo,sSelectedOrder[], sIoJpNo, sIpno, sOutNo
String sSaupj

sle_msg.text =""

If dw_imhist.Rowcount() <= 0 Then Return -1

iRowCount = dw_imhist.GetItemNumber(1,"yescount")
IF iRowCount <=0 THEN
	f_message_chk(36,'')
	Return -1
END IF

/* 사업장 체크 */
sSaupj= Trim(dw_cond.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_cond.SetFocus()
	dw_cond.SetColumn('saupj')
	Return -1
End If

IF MessageBox("확 인","출고 취소 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

iAryCnt = 1

///* 출고확인 처리된 송장은 취소 불가 */
//sIoJpNo = Left(Trim(dw_imhist.GetItemString(1,'iojpno')),12)
//select count(io_date) into :nCnt
//	from imhist
// where sabu = :gs_sabu and 
//		 iojpno like :sIoJpNo||'%' and
//		 io_date is not null AND
//       iogbn = 'O04';
//
//If nCnt > 0 Then
//	RollBack;
//	f_message_chk(57,'[제품출고 확인완료]')
//	wf_init()
//	Return -1
//End If

//iImhistRow = dw_imhist.RowCount()
//For k = iImhistRow TO 1 STEP -1
//	IF dw_imhist.GetItemString(k,"flag_choice") = 'Y' THEN
//		
//		SetNull(sIpNo)
//		SetNull(sOutNo)
//		
//		/* 삭제할 전표번호 */
//		sIoJpNo = Trim(dw_imhist.GetItemString(k,'iojpno'))
//		
////		/* 거래명세표 번호 삭제 */
////		DELETE FROM IMHEAD
////		 WHERE SABU = :gs_sabu AND
////				 IOJP = :sIojpno;
////
////		IF SQLCA.sqlcode <> 0	THEN
////			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
////			ROLLBACK;
////			f_Rollback();
////			RETURN -1
////		END IF		
//		
//		/* 할당번호가 없을 경우 이동입고->이동출고 전표를 찾는다 */
//		sHoldNo = Trim(dw_imhist.GetItemString(k,"hold_no"))
//		If IsNull(sHoldNo) Or sHoldNo = '' Then
//			
//			sIpNo = Trim(dw_imhist.GetItemString(k,"ip_jpno"))
//			/* 이동입고전표에서 이동출고번호를 찾는다 */
//			SELECT IP_JPNO INTO :sOutNo
//			  FROM IMHIST
//			 WHERE SABU = :gs_sabu AND
//			       IOJPNO = :sIpNo;
//
//			If sqlca.sqlcode <> 0 Or IsNull(sOutNo) Then
//				ROLLBACK;
//				f_message_chk(52,'[이동출고번호를 찾을 수 없습니다.!!]')
//				Return -1
//			End If
//		
//			/* 이동출고전표에서 할당번호를 찾는다 */
//			SELECT HOLD_NO INTO :sHoldNo
//			  FROM IMHIST
//			 WHERE SABU = :gs_sabu AND
//			       IOJPNO = :sOutNo;
//
//			If sqlca.sqlcode <> 0 Or IsNull(sHoldNo) Then
//				ROLLBACK;
//				f_message_chk(52,'[할당번호를 찾을 수 없습니다.!!]')
//				Return -1
//			End If
//		End If
//
//
//
//		/* 분할출고된 경우 out_chk = '2' */
//		select count( distinct substr(iojpno,1,12) ) into :dInvQty
//		  from imhist
//		 where sabu = :gs_sabu and
//				 hold_no = :sHoldNo;
//		If IsNull(dInvQty) Or dInvQty <= 0 Then 
//			ROLLBACK;
//			f_message_chk(32,'[취소할 송장이 없습니다]'+string(dinvqty))
//			Return -1
//		End If
//		
//		/* 직송 입고/출고전표 삭제 */
//		DELETE FROM IMHIST 
//		 WHERE SABU = :gs_sabu AND
//				 IOJPNO IN ( :sIpno, :sOutNo );
//
//		IF SQLCA.sqlcode <> 0	THEN
//			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//			ROLLBACK;
//			f_Rollback();
//			RETURN -1
//		END IF
//			
//		/* 할당->송장 분할여부에 따라 */
//		If dInvQty = 1 Then
//			/* 출고승인을 '할당'으로 */
//			UPDATE "HOLDSTOCK"
//				SET "OUT_CHK" = '1'
//			 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND ( "HOLDSTOCK"."HOLD_NO" = :sHoldNo );
//		ElseIf dInvQty > 1 Then
//			/* 출고승인을 '출고진행중'으로 */
//			UPDATE "HOLDSTOCK"
//				SET "OUT_CHK" = '2'
//			 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND ( "HOLDSTOCK"."HOLD_NO" = :sHoldNo );
//		End If
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			f_message_chk(32,'[송장취소 오류]')
//			ROLLBACK;
//			Return -1
//		ELSE
//			dw_imhist.DeleteRow(k)
//		END IF
//
//	END IF
//Next

iImhistRow = dw_imhist.RowCount()
For k = iImhistRow TO 1 STEP -1
	IF dw_imhist.GetItemString(k,"flag_choice") = 'Y' THEN
		
		SetNull(sIpNo)
		SetNull(sOutNo)
		
		/* 삭제할 전표번호 */
		sIoJpNo = Trim(dw_imhist.GetItemString(k,'iojpno'))
				
		// 타계정 전표 삭제
		DELETE FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND SAUPJ = :sSaupj;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return -1
		End If

		/* 할당번호가 없을 경우 이동입고->이동출고 전표를 찾는다 */
		sHoldNo = Trim(dw_imhist.GetItemString(k,"pjt_cd"))

		/* 분할출고된 경우 out_chk = '2' */
		select count( distinct substr(iojpno,1,12) ) into :dInvQty
		  from imhist
		 where sabu = :gs_sabu and
				 pjt_cd = :sHoldNo;
		If IsNull(dInvQty) Then dInvQty = 0
		
//		If IsNull(dInvQty) Or dInvQty <= 0 Then 
//			ROLLBACK;
//			f_message_chk(32,'[취소할 송장이 없습니다]'+string(dinvqty))
//			Return -1
//		End If
			
		/* 할당->송장 분할여부에 따라 */
		If rb_napip.Checked Or rb_chul.Checked Then
			If rb_napip.Checked Then
				If dInvQty = 1 Then
					/* 출고승인을 '할당'으로 */
					UPDATE "MWAPI_ERP"
						SET "OUT_CHK" = '1'
					 WHERE ( "MWAPI_ERP"."SAUPJ" = :sSaupj ) AND ( "MWAPI_ERP"."HOLD_NO" = :sHoldNo );
				ElseIf dInvQty > 1 Then
					/* 출고승인을 '출고진행중'으로 */
					UPDATE "MWAPI_ERP"
						SET "OUT_CHK" = '2'
					 WHERE ( "MWAPI_ERP"."SAUPJ" = :gs_sabu ) AND ( "MWAPI_ERP"."HOLD_NO" = :sHoldNo );
				End If
			Else
				If dInvQty = 1 Then
					/* 출고승인을 '할당'으로 */
					UPDATE "SM04_DAILY_ITEM"
						SET "OUT_CHK" = '1'
					 WHERE ( "SM04_DAILY_ITEM"."SAUPJ" = :sSaupj ) AND ( "SM04_DAILY_ITEM"."HOLD_NO" = :sHoldNo );
				ElseIf dInvQty > 1 Then
					/* 출고승인을 '출고진행중'으로 */
					UPDATE "SM04_DAILY_ITEM"
						SET "OUT_CHK" = '2'
					 WHERE ( "SM04_DAILY_ITEM"."SAUPJ" = :gs_sabu ) AND ( "SM04_DAILY_ITEM"."HOLD_NO" = :sHoldNo );
				End If
			End If
			
			IF SQLCA.SQLCODE <> 0 THEN
				f_message_chk(32,'[송장취소 오류]')
				ROLLBACK;
				Return -1
			ELSE
				dw_imhist.DeleteRow(k)
			END IF
		Else
			dw_imhist.DeleteRow(k)
		End If
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

on w_dm01_00010.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_select=create cbx_select
this.dw_cond=create dw_cond
this.dw_haldang_list=create dw_haldang_list
this.cbx_all=create cbx_all
this.dw_list=create dw_list
this.st_2=create st_2
this.st_list=create st_list
this.st_haldang=create st_haldang
this.rb_napip=create rb_napip
this.rb_chul=create rb_chul
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rb_can=create rb_can
this.pb_1=create pb_1
this.dw_haldang=create dw_haldang
this.dw_imhist=create dw_imhist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.cbx_select
this.Control[iCurrent+4]=this.dw_cond
this.Control[iCurrent+5]=this.dw_haldang_list
this.Control[iCurrent+6]=this.cbx_all
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_list
this.Control[iCurrent+10]=this.st_haldang
this.Control[iCurrent+11]=this.rb_napip
this.Control[iCurrent+12]=this.rb_chul
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
this.Control[iCurrent+16]=this.rr_3
this.Control[iCurrent+17]=this.rr_4
this.Control[iCurrent+18]=this.rb_can
this.Control[iCurrent+19]=this.pb_1
this.Control[iCurrent+20]=this.dw_haldang
this.Control[iCurrent+21]=this.dw_imhist
end on

on w_dm01_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_select)
destroy(this.dw_cond)
destroy(this.dw_haldang_list)
destroy(this.cbx_all)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.st_list)
destroy(this.st_haldang)
destroy(this.rb_napip)
destroy(this.rb_chul)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rb_can)
destroy(this.pb_1)
destroy(this.dw_haldang)
destroy(this.dw_imhist)
end on

event open;call super::open;dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

dw_imhist.SetTransObject(SQLCA)

dw_haldang.SetTransObject(SQLCA)
dw_haldang_list.SetTransObject(SQLCA)

/* 이송일 경우 할당하기 위해 */
dw_insert.SetTransObject(SQLCA)

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

cbx_select.Checked = True

Wf_Init()

f_mod_saupj(dw_cond, 'saupj')

dw_cond.SetItem(1, 'depot_no', 'Z01')

/*여신체크 시점*/
//sSyscnfg_Yusin = f_get_syscnfg('S',2,'10')
If IsNull(sSyscnfg_Yusin) Or sSyscnfg_Yusin = '' Then sSyscnfg_Yusin = '4'

/* 가용재고가 '-'일경우 출고처리 여부 */
sValidMinus = f_get_syscnfg('S',1,'75')
If IsNull(sValidMinus) Or sValidMinus = '' Then sValidMinus = 'Y'


end event

type dw_insert from w_inherite`dw_insert within w_dm01_00010
boolean visible = false
integer x = 73
integer y = 2900
integer width = 187
integer height = 184
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

type p_delrow from w_inherite`p_delrow within w_dm01_00010
boolean visible = false
integer x = 1070
integer y = 2752
integer taborder = 90
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_dm01_00010
boolean visible = false
integer x = 2990
integer y = 28
integer taborder = 70
boolean enabled = false
end type

event p_addrow::clicked;call super::clicked;
If rb_1.Checked And rb_napip.Checked Then
	dw_haldang.InsertRow(0)
Else
	MessageBox('확 인','납입카드에서만 추가하실 수 있습니다.!!')
	Return
End If
end event

type p_search from w_inherite`p_search within w_dm01_00010
integer x = 4087
integer y = 32
integer taborder = 160
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_search::clicked;call super::clicked;If dw_imhist.AcceptText() <> 1 Then Return

If f_msg_update() <> 1 Then Return

If dw_imhist.Update() <> 1 Then
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	RollBack;
	Return
End If

COMMIT;

MessageBox('확 인','저장하였습니다.!!')
end event

type p_ins from w_inherite`p_ins within w_dm01_00010
boolean visible = false
integer x = 2784
integer y = 36
integer taborder = 60
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_dm01_00010
integer y = 32
integer taborder = 150
end type

type p_can from w_inherite`p_can within w_dm01_00010
integer x = 4265
integer y = 32
integer taborder = 140
end type

event p_can::clicked;call super::clicked;rollback;

Wf_Init()
end event

type p_print from w_inherite`p_print within w_dm01_00010
boolean visible = false
integer x = 2386
integer y = 32
integer taborder = 170
boolean enabled = false
string picturename = "C:\erpman\image\일괄발행_up.gif"
end type

event p_print::clicked;call super::clicked;//Long ix, nCnt, nPrs = 0, nRow, iy, sRow
//String sGbn, sDirgb, sJepumIo, sSalegu, sCvcod, sNull, sSudat, sFrDate, sToDate
//Dec    dUseAmount, dStdAmt, dSumAmount
//
//SetNull(sNull)
//
//If rb_1.Checked = False Then Return
//
//dw_list.Reset()
//
//If dw_cond.AcceptText() <> 1 Then Return
//If dw_haldang_list.RowCount() <= 0 Then Return
//
//sGbn 		= Trim(dw_cond.GetItemString(1,"iogbn"))
//sDirgb   = Trim(dw_cond.GetItemSTring(1,"dirgb"))
//
//sSudat = dw_cond.GetItemString(1,'sudat')
//IF f_datechk(sSudat) <> 1 THEN
//  f_message_chk(30,'[발행일자]')
//  dw_cond.SetColumn("sudat")
//  dw_cond.SetFocus()
//  Return
//END IF
//
///* 매출마감시 송장 발행 안함 */
//SELECT COUNT(*)  INTO :ncnt
// FROM "JUNPYO_CLOSING"  
//WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
//		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;
//
//If nCnt >= 1 then
//	f_message_chk(60,'[매출마감]')
//	Return
//End if
//	
//cbx_select.Checked = True	/* 품목전체 선택 */
//
//If sGbn = 'N' then
//	/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
//	sJepumIo = 'Y%'
//	sSaleGu  = 'N%'
//Else
//	/* 판매출고 : 매출여부('Y') */
//	sJepumIo = '%'
//	sSaleGu  = 'Y%'
//End If
//
//IF MessageBox("확 인","송장 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN
//
///* 선택된 거래처만 발행함 */
//dw_haldang.SetRedraw(False)
//For ix = 1 To dw_haldang_list.RowCount()
//	If dw_haldang_list.GetItemString(ix, 'chk') <> 'Y' Then Continue
//
//	/* 검색조건 : 당월분일 경우 요구납기일이 발행월에 해당되는 수주만 조회 */
//	If dw_cond.GetItemSTring(1,"chk") = 'Y' Then
//		sFrDate = Left(sSudat,6) + '01'
//	Else
//		sFrdate = '19000101'
//	End If
//	sTodate = sSudat
//	
//	/* 할당현황 조회 */
//	sCvcod   = Trim(dw_haldang_list.GetItemSTring(ix,"cvcod"))
//	nCnt = dw_haldang.Retrieve(gs_sabu, sCvcod, sJepumIo, sSaleGu, sDirgb, sFrDate, sToDate)
//	If nCnt <= 0 Then Continue
//
//	/* 할당내용중 재고가 있는 품목만 선택 */
//	cbx_select.TriggerEvent(Clicked!)
//	
//	/* 선택된 품목이 없으면 skip */
//	nCnt = dw_haldang.GetItemNumber(1,"yescount")
//	IF nCnt <=0 Then Continue
//	
//	/* 여신금액 체크 */
//	If ssyscnfg_yusin = '3' Then
//		sCvcod = Trim(dw_haldang.GetItemString(1,"sorder_cvcod"))
//		dUseAmount = sqlca.Fun_Erp100000030(gs_sabu,sCvcod, Left(is_today,6),Is_today);
//		If sqlca.sqlcode <> 0 Then 
//			MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//			Return -1
//		End If
//		
//		dStdAmt = dw_haldang_list.GetItemNumber(ix, 'credit_limit')
//		If IsNull(dStdAmt) then dStdAmt = 0
//
//		/* 여신금액이 초과할 경우 품목을 하나씩 제거한다 */
//		nRow = dw_haldang.RowCount()
//		For iy = nRow To 1 Step -1
//			/* 출고금액 */
//			dSumAmount = dw_haldang.GetItemNumber(1, 'sum_amount')
//			If IsNull(dSumAmount) then dSumAmount = 0
//
//			If dStdAmt > 0 And ( dStdAmt - dUseAmount - dSumAmount < 0 ) Then
//				If dw_haldang.GetItemString(iy, 'flag_choice') = 'Y' Then
//					dw_haldang.SetItem(iy,'flag_choice', 'N')
//
//					/* 신용체크 걸린 거래처, 품목 */
//					sRow = dw_list.InsertRow(0)
//					dw_list.SetItem(sRow, 'cvcod',  sCvcod)
//					dw_list.SetItem(sRow, 'cvnas',  dw_haldang_list.GetItemString(ix, 'cvnas2'))
//					dw_list.SetItem(sRow, 'hold_no', dw_haldang.GetItemString(iy, 'hold_no'))
//					dw_list.SetItem(sRow, 'itnbr', dw_haldang.GetItemString(iy, 'itnbr'))
//					dw_list.SetItem(sRow, 'itdsc', dw_haldang.GetItemString(iy, 'itemas_itdsc'))
//					dw_list.SetItem(sRow, 'ispec', dw_haldang.GetItemString(iy, 'itemas_ispec'))
//					dw_list.SetItem(sRow, 'jijil', dw_haldang.GetItemString(iy, 'itemas_jijil'))
//					dw_list.SetItem(sRow, 'valid_qty', dw_haldang.GetItemNumber(iy, 'valid_qty'))
//					dw_list.SetItem(sRow, 'ordamt', dw_haldang.GetItemNumber(iy, 'ordamt'))
//					Continue
//				End If
//			Else
//				Exit
//			End If
//		Next
//
//	End If
//	
//	/* 선택된 품목이 존재할 경우만 발행 */
//	If dw_haldang.GetItemNumber(1, 'yescount') > 0 Then
//		IF Wf_Create_Imhist() <> 1 THEN 
//			dw_haldang.SetRedraw(True)
//			RETURN
//		End If
//		
//		nPrs += 1
//	End If
//Next
//dw_haldang.SetRedraw(True)
//
///* 여신부족업체 list 인쇄 */
//IF dw_list.rowcount() > 0 then 
//	gi_page = dw_list.GetItemNumber(1,"last_page")
//	OpenWithParm(w_print_options, dw_list)
//END IF
//
///* 처리후 할당현황을 재조회한다 */
//dw_haldang.Reset()
//dw_imhist.Reset()
//p_inq.TriggerEvent(Clicked!)
//
//
//sle_msg.text = String(nPrs) +'건의 자료를 처리하였습니다!!'
//ib_any_typing = False
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\일괄발행_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\일괄발행_up.gif"
end event

type p_inq from w_inherite`p_inq within w_dm01_00010
integer x = 3735
integer y = 32
integer taborder = 40
end type

event p_inq::clicked;call super::clicked;String sJepumIo, sSaleGu, sGbn, sCvcod, sCvcodNm, sArea, sGate, sBhgb, sChk
String sSuDat, sIoDate, sSaupj, sDirgb, sDepotNo, sTemp, sHoldNo, sCust, sItnbr
Long   nCnt, nMaxcrsq, ix, nRow
Int    iMaxIoNo

If dw_cond.AcceptText() <> 1 Then Return

sSuDat = Trim(dw_cond.GetItemSTring(1,"sudat"))
sCvcod = Trim(dw_cond.GetItemSTring(1,"cvcod"))
sArea  = Trim(dw_cond.GetItemSTring(1,"sarea"))
sSaupj  = Trim(dw_cond.GetItemSTring(1,"saupj"))
sDirgb  = Trim(dw_cond.GetItemSTring(1,"dirgb"))
sDepotNo  = Trim(dw_cond.GetItemSTring(1,"depot_no"))
sCust  = Trim(dw_cond.GetItemSTring(1,"cust_no"))
sItnbr  = Trim(dw_cond.GetItemSTring(1,"itnbr"))
sChk  = Trim(dw_cond.GetItemSTring(1,"chk"))

If IsNull(sCvcod) or sCvcod = '' then sCvcod = ''
If IsNull(sArea)  or sArea = ''  then sArea = ''
If IsNull(sCust)  or sCust = ''  then sCust = ''
If IsNull(sItnbr)  or sItnbr = ''  then sItnbr = ''

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_cond.SetFocus()
	dw_cond.SetColumn('saupj')
	Return -1
End If

sGbn = Trim(dw_cond.GetItemString(1,"iogbn"))
If sGbn = 'N' then
	/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
	sJepumIo = 'Y'
	sSaleGu  = 'N'
Else
	/* 판매출고 : 매출여부('Y') */
	sJepumIo = ''
	sSaleGu  = 'Y'
End If

dw_haldang.Reset()
dw_imhist.Reset()
p_mod.Enabled = True

/*송장 처리*/
IF sModStatus = 'I' THEN
	If IsNull(sDepotNo) Or sDepotNo = '' Then
		f_message_chk(30,'출고창고')
		Return
	End If
	
	/* 재고 허용여부 */
	select substr(kyungy,1,1) into :sMinus
	  from vndmst
	 where cvcod = :sDepotNo;
	
	If IsNull(sMinus) Then sMinus = 'N'
	
	If IsNull(sSaupj) Or sSaupj = '' Then
		f_message_chk(30,'사업장')
		Return
	End If

	// 납입카드인 경우 납입내역을 최신 정보로 갱신한다.
	If rb_napip.Checked Or rb_can.Checked Then
		// Profile Rapdos
		transaction sqlca1
		datastore   ds_mwapi, ds_mwerp
		
		sqlca1 = create transaction
		ds_mwapi = create datastore
		ds_mwerp = create datastore
		
		SQLCA1.DBMS = "ODBC"
		SQLCA1.AutoCommit = False
		SQLCA1.DBParm = "ConnectString='DSN=rapdosapi;UID=;PWD='"

		CONNECT USING SQLCA1;
		IF sqlca1.sqlcode <> 0 THEN
			MessageBox ("Cannot Connect to Database!", string(sqlca1.sqlcode) + '~n' + sqlca1.sqlerrtext)
//			Return
		Else
	
			ds_mwapi.DataObject = 'd_mwapi'
			ds_mwerp.DataObject = 'd_mwapi_erp'
			ds_mwapi.SetTransObject(sqlca1)
			ds_mwerp.SetTransObject(sqlca)
			
			
			// erp의 최종순번을 가져온다
			select max(crsq) into :nMaxcrsq
			  from mwapi_erp
			 where saupj = :sSaupj and crdt = :sSuDat using sqlca;
			If IsNull(nMaxcrsq) Then nMaxcrsq = 0
			
			ds_mwapi.Retrieve(sSuDat, nMaxcrsq)
			
			If ds_mwapi.RowCount() > 0 Then
				/* 출하의뢰 번호 채번 */
				iMaxIoNo = sqlca.fun_junpyo(gs_sabu,sSuDat, 'S1')
				IF iMaxIoNo <= 0 THEN
					f_message_chk(51,'')
					ROLLBACK;
					Return -1
				END IF
				commit;
				LsIoJpNo = sSuDat + String(iMaxIoNo,'0000')
	
	//			nCnt = ds_mwapi.RowsCopy(1, ds_mwapi.RowCount(), Primary!, ds_mwerp, 1, Primary!)
				
				// 품번 변환
				For ix = 1 To ds_mwapi.RowCount()
					
					If ix >= 1000 Then Exit
					
					nRow = ds_mwerp.InsertRow(0)
					
					sHoldNo = LsIoJpNo + String(nRow,'000')
					sBhgb = ds_mwapi.GetItemString(ix, "BHGB")
					
					ds_mwerp.SetItem(nrow,"CRDT",   ds_mwapi.GetItemString(ix, "CRDT"))
					ds_mwerp.SetItem(nrow,"CRSQ",   ds_mwapi.GetItemNumber(ix, "CRSQ"))
					ds_mwerp.SetItem(nrow,"INGB",   ds_mwapi.GetItemString(ix, "INGB"))
					ds_mwerp.SetItem(nrow,"COMP",   ds_mwapi.GetItemString(ix, "COMP"))
					ds_mwerp.SetItem(nrow,"VDCD",   ds_mwapi.GetItemString(ix, "VDCD"))
					ds_mwerp.SetItem(nrow,"PLNT",   Trim(ds_mwapi.GetItemString(ix, "PLNT")))
					ds_mwerp.SetItem(nrow,"PTNO",   ds_mwapi.GetItemString(ix, "PTNO"))
					ds_mwerp.SetItem(nrow,"SERI",   ds_mwapi.GetItemNumber(ix, "SERI"))
					ds_mwerp.SetItem(nrow,"ODNO",   ds_mwapi.GetItemString(ix, "ODNO"))
					ds_mwerp.SetItem(nrow,"ODSQ",   ds_mwapi.GetItemNumber(ix, "ODSQ"))
					ds_mwerp.SetItem(nrow,"ODQT",   ds_mwapi.GetItemNumber(ix, "ODQT"))
					ds_mwerp.SetItem(nrow,"JAQT",   ds_mwapi.GetItemNumber(ix, "JAQT"))
					If sBhgb = 'C' Then
						ds_mwerp.SetItem(nrow,"NPQT",   ds_mwapi.GetItemNumber(ix, "NPQT") * -1)
					Else
						ds_mwerp.SetItem(nrow,"NPQT",   ds_mwapi.GetItemNumber(ix, "NPQT"))
					End If
					ds_mwerp.SetItem(nrow,"NPPR",   ds_mwapi.GetItemNumber(ix, "NPPR"))
					ds_mwerp.SetItem(nrow,"NIDT",   ds_mwapi.GetItemString(ix, "NIDT"))
					ds_mwerp.SetItem(nrow,"NITM",   ds_mwapi.GetItemString(ix, "NITM"))
					ds_mwerp.SetItem(nrow,"NPDT",   ds_mwapi.GetItemString(ix, "NPDT"))
					ds_mwerp.SetItem(nrow,"NPTM",   ds_mwapi.GetItemString(ix, "NPTM"))
					ds_mwerp.SetItem(nrow,"DCDT",   ds_mwapi.GetItemString(ix, "DCDT"))
					ds_mwerp.SetItem(nrow,"DCTM",   ds_mwapi.GetItemString(ix, "DCTM"))
					ds_mwerp.SetItem(nrow,"CANO",   ds_mwapi.GetItemString(ix, "CANO"))
					ds_mwerp.SetItem(nrow,"DEGB",   ds_mwapi.GetItemString(ix, "DEGB"))
					ds_mwerp.SetItem(nrow,"SJGB",   ds_mwapi.GetItemString(ix, "SJGB"))
					ds_mwerp.SetItem(nrow,"BPGB",   ds_mwapi.GetItemString(ix, "BPGB"))
					ds_mwerp.SetItem(nrow,"CSGB",   ds_mwapi.GetItemString(ix, "CSGB"))
					ds_mwerp.SetItem(nrow,"CPGB",   ds_mwapi.GetItemString(ix, "CPGB"))
					ds_mwerp.SetItem(nrow,"CAUS",   ds_mwapi.GetItemString(ix, "CAUS"))
					ds_mwerp.SetItem(nrow,"CDGB",   ds_mwapi.GetItemString(ix, "CDGB"))
					sGate = Trim(ds_mwapi.GetItemString(ix, "GATE"))
					If IsNull(sGate) Or sGate = '' Then sGate = '.'
					ds_mwerp.SetItem(nrow,"GATE",   sGate)
					ds_mwerp.SetItem(nrow,"CARC",   ds_mwapi.GetItemString(ix, "CARC"))
					ds_mwerp.SetItem(nrow,"LOCT",   ds_mwapi.GetItemString(ix, "LOCT"))
					ds_mwerp.SetItem(nrow,"FROD",   ds_mwapi.GetItemString(ix, "FROD"))
					ds_mwerp.SetItem(nrow,"TOOD",   ds_mwapi.GetItemString(ix, "TOOD"))
					ds_mwerp.SetItem(nrow,"BHDT",   ds_mwapi.GetItemString(ix, "BHDT"))
					ds_mwerp.SetItem(nrow,"PRDT",   ds_mwapi.GetItemString(ix, "PRDT"))
					ds_mwerp.SetItem(nrow,"BHGB",   ds_mwapi.GetItemString(ix, "BHGB"))
					ds_mwerp.SetItem(nrow,"OUT_CHK",'1')
					ds_mwerp.SetItem(nrow,"ISQTY",  0)
					ds_mwerp.SetItem(nrow,"SAUPJ",  sSaupj)
					ds_mwerp.SetItem(nrow,"HOLD_NO",sHoldNo)
	
					sTemp = ds_mwerp.GetItemString(nrow,'ptno')
					If IsNumber(Left(sTemp,1)) Then
						sTemp = Left(sTemp,5)+'-'+Mid(sTemp,6)
						ds_mwerp.SetItem(nrow, 'ptno', sTemp)
					End If
				Next
				
				If ds_mwerp.Update() <> 1 Then
					MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
					RollBack using sqlca;
				End If
				
				COMMIT USING SQLCA;
			End If
		End If
		
		Destroy ds_mwapi
		Destroy ds_mwerp
		DISCONNECT USING SQLCA1;
	End If
	
	IF dw_haldang_list.Retrieve(sSaupj, sSuDat, sCust+'%', sChk) <=0 THEN
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
//	If Not IsNull(LsIoJpno) Then
//		select distinct x.sudat, x.cvcod , y.jepumio, y.salegu, x.io_date, x.saupj,
//		                v.cvnas2, v.sarea, x.depot_no
//		  into :sSudat, :sCvcod, :sJePumIo, :sSaleGu, :sIoDate, :sSaupj, :scvcodnm, :sarea,
//		       :sdepotno
//	    from imhist x, iomatrix y, vndmst v
//		 where x.iogbn = y.iogbn and
//		       x.cvcod = v.cvcod and
//		       x.sabu = :gs_sabu and
//		       x.iojpno like :LsIoJpno||'%' and
//				 y.jepumio = 'Y';
//
//		dw_cond.SetItem(1,'sudat',   sSudat)
//		dw_cond.SetItem(1,'sarea',   sArea)
//		dw_cond.SetItem(1,'cvcod',   sCvcod)
//		dw_cond.SetItem(1,'vndname', sCvcodnm)
//		dw_cond.SetItem(1,'iogbn',   sSalegu)
//		dw_cond.SetItem(1,'saupj',   sSaupj)
//		dw_cond.SetItem(1,'depot_no',   sDepotNo)
//		IF dw_imhist.Retrieve(gs_sabu, sSuDat, sCvcod+'%', LsIoJpNo, sJepumIo+'%', sSaleGu+'%') <=0 THEN
//			f_message_chk(50,'')
//			dw_cond.Setfocus()
//			Return
//		ELSE
//			dw_haldang_list.Reset()
//			dw_imhist.SetFocus()
//		END IF
//		
//		/* 제품출고 확인 된 경우 취소 불가 */
//		If IsNull(sIoDate) or Trim(sIoDate) = '' Then
//			p_mod.Enabled = True
//		Else
//			MessageBox('확 인','출고확인 처리된 송장입니다.~r~n~r~n송장취소는 불가능합니다')
//			p_mod.Enabled = False
//		End If
//	Else
		If IsNull(sDepotNo) Or sDepotNo = '' Then
			f_message_chk(30,'출고창고')
			Return
		End If
		
		If IsNull(sSaupj) Or sSaupj = '' Then
			f_message_chk(30,'부가사업장')
			Return
		End If
	
		/*송장번호를 입력하지않는 경우 송장리스트를 조회*/
		If sDirgb = 'S' Then sDirgb = 'N'
	
		IF dw_haldang_list.Retrieve(gs_sabu, sSudat, sCvcod+'%', sJepumIo+'%', sSaleGu+'%', sSaupj, sItnbr+'%', schk) <=0 THEN
			f_message_chk(50,'')
			dw_imhist.Reset()
			dw_cond.Setfocus()
			Return
		ELSE
			dw_haldang.Reset()
			dw_haldang_list.SetFocus()
		END IF
//  End If
END IF

dw_cond.Modify('depot_no.protect = 1')
dw_cond.Modify('iogbn.protect = 1')

ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_dm01_00010
boolean visible = false
integer x = 1390
integer y = 2632
integer taborder = 130
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_dm01_00010
integer x = 3913
integer y = 32
integer taborder = 110
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;string sSudat,sGbn,sJepumIo,sSaleGu, sNull
Int    iCnt

If dw_cond.AcceptText() <> 1 Then Return
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
	iCnt = dw_haldang.GetItemNumber(1,"yescount")
	IF iCnt <=0 THEN
		f_message_chk(36,'')
		Return -1
	END IF
	
	IF MessageBox("확 인","출하 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

	IF Wf_Create_Imhist() <> 1 THEN RETURN
	
	dw_haldang.Reset()
   dw_imhist.Reset()
ELSE
	IF Wf_Delete_Imhist() <> 1 THEN RETURN
	
	dw_haldang.Reset()
   dw_imhist.Reset()
	
	dw_cond.SetItem(1,'iojpno',sNull)
	dw_cond.SetItem(1,'sarea',sNull)
	dw_cond.SetItem(1,'cvcod',sNull)
	dw_cond.SetItem(1,'vndname',sNull)	
END IF

p_inq.TriggerEvent(Clicked!) // 할당 list 조회
sle_msg.text = '자료를 처리하였습니다!!'
ib_any_typing = False
end event

event p_mod::ue_lbuttondown;PictureName = 'C:\erpman\image\처리_dn.gif'
end event

event p_mod::ue_lbuttonup;PictureName = 'C:\erpman\image\처리_up.gif'
end event

type cb_exit from w_inherite`cb_exit within w_dm01_00010
integer y = 2808
end type

type cb_mod from w_inherite`cb_mod within w_dm01_00010
integer y = 2808
end type

type cb_ins from w_inherite`cb_ins within w_dm01_00010
integer x = 320
integer y = 2700
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_dm01_00010
integer x = 1189
integer y = 2704
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_dm01_00010
integer y = 2808
end type

type cb_print from w_inherite`cb_print within w_dm01_00010
integer y = 2808
end type

type st_1 from w_inherite`st_1 within w_dm01_00010
end type

type cb_can from w_inherite`cb_can within w_dm01_00010
integer y = 2768
end type

type cb_search from w_inherite`cb_search within w_dm01_00010
integer x = 677
integer y = 2712
boolean enabled = false
end type





type gb_10 from w_inherite`gb_10 within w_dm01_00010
integer x = 14
integer y = 3008
end type

type gb_button1 from w_inherite`gb_button1 within w_dm01_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_dm01_00010
end type

type rb_1 from radiobutton within w_dm01_00010
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

cbx_select.Checked = True
cbx_select.Visible = True
end event

type rb_2 from radiobutton within w_dm01_00010
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
cbx_select.Visible = False
end event

type cbx_select from checkbox within w_dm01_00010
integer x = 4247
integer y = 844
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

event clicked;String  sStatus, sItnbr, sIspec 
Integer k, nRow
Double  dHoldQty,dIsQty, dJegoQty, dValidQty, dStkQty 

IF cbx_select.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

/* 송장 처리 */
IF sModStatus = 'I' And sStatus = 'N' THEN
	FOR k = 1 TO dw_haldang.RowCount()
		dw_haldang.SetItem(k,"flag_choice",sStatus)
	NEXT
ElseIF sModStatus = 'I' And sStatus = 'Y' THEN
	/* 재고 Minus 허용함 */
	If sMinus = 'Y' Then
		For k = 1 To dw_haldang.RowCount()
			dw_haldang.SetItem(k,"flag_choice", sStatus)
		Next
	Else
		/* 재고 Minus 허용안할경우 */
		
		/* 품번별 소트 */
		dw_haldang.SetSort('itnbr a, pspec a, hold_no a')
		dw_haldang.Sort()
	
		nRow = dw_haldang.RowCount()
		FOR k = 1 TO nRow
			If sItnbr <> Trim(dw_haldang.GetItemString(k,'itnbr')) or &
				sIspec <> Trim(dw_haldang.GetItemString(k,'pspec')) then
				
				sItnbr = Trim(dw_haldang.GetItemString(k,'itnbr'))
				sIspec = Trim(dw_haldang.GetItemString(k,'pspec'))
				
				dJegoQty = dw_haldang.GetItemNumber(k,'jego_qty')
				IF IsNull(dJegoQty) THEN dJegoQty =0
			End If
			
			/* 재고가 없을경우 발행불가 */
			IF dJegoQty <= 0 THEN
				dw_haldang.SetItem(k,"flag_choice",'N')
			ELSE
				dStkQty = dw_haldang.GetItemNumber(k,"stock_valid_qty")	/* 가용재고 */
				IF IsNull(dStkQty) THEN dStkQty = 0

				dValidQty = dw_haldang.GetItemNumber(k,"valid_qty")	/* 출고요청수량 */
				IF IsNull(dValidQty) THEN dValidQty =0
			
				/* 출고수량이 재고수량보다 적어야 가능함 */
				IF dValidQty > 0 And dValidQty <= dJegoQty THEN
					dw_haldang.SetItem(k,"flag_choice",'Y')
					dJegoQty -= dValidQty
				ELSE
					dw_haldang.SetItem(k,"flag_choice",'N')
				END IF
			END IF
			sle_msg.Text = string(k)+'/'+string(nRow) + ' 처리중...'
		NEXT
	End If
ELSE
/* 송장 취소인 경우 전체선택 불가 */
//	FOR k = 1 TO dw_imhist.RowCount()
//		dw_imhist.SetItem(k,"flag_choice",sStatus)
//	NEXT	
END IF

sle_msg.Text = ''
end event

type dw_cond from u_key_enter within w_dm01_00010
event ue_key pbm_dwnkey
integer x = 37
integer y = 344
integer width = 2153
integer height = 448
integer taborder = 50
string dataobject = "d_dm01_00010_a"
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
String sitnbr, sitdsc, sispec, sjijil, sispec_code
Int    ireturn

SetNull(snull)

Choose Case GetColumnName() 
	Case "iojpno"
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
		SELECT DISTINCT "IMHIST"."IO_DATE", "SAUPJ" INTO :sIoDate, :sSaupj
		  FROM "IMHIST", "IOMATRIX"
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
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
			SetItem(1,"saupj",   ssaupj)
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
			SetItem(1,"saupj",   ssaupj)
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
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
				
		RETURN ireturn
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
		Else
			gs_gubun = '001'        //무상출고
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
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"itnbr",gs_code)
		this.SetItem(1,"itdsc",gs_codename)
				
		Return 1
END Choose
end event

type dw_haldang_list from datawindow within w_dm01_00010
integer x = 2231
integer y = 272
integer width = 2373
integer height = 540
integer taborder = 80
string dataobject = "d_dm01_00010_1"
boolean hscrollbar = true
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

event doubleclicked;String sJepumIo,sSaleGu,sGbn,sCvcod, sCvcodNm, sSuDat, sIojpno, sArea, sDirgb, sFrdate, sTodate, sMaxdate, schk
String sPlnt, sSaupj, sItnbr
Long   nRow

IF Row <=0 THEN RETURN

nRow = GetRow()

this.SelectRow(0,False)
this.SelectRow(Row,True)

sPlnt 	= Trim(This.GetItemSTring(Row,"plnt"))
sCvcod   = Trim(This.GetItemSTring(Row,"cvcod"))
sCvcodNm = Trim(This.GetItemSTring(Row,"cvnas2"))
sDirgb   = Trim(dw_cond.GetItemSTring(1,"dirgb"))
sSuDat   = Trim(dw_cond.GetItemString(1,"sudat"))
sSaupj	= Trim(dw_cond.GetItemString(1, 'saupj'))
sItnbr	= Trim(dw_cond.GetItemString(1, 'itnbr'))
sChk		= Trim(dw_cond.GetItemString(1, 'chk'))

If IsNull(sItnbr) Or sItnbr = '' Then sItnbr = ''

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_cond.SetFocus()
	dw_cond.SetColumn('saupj')
	Return -1
End If

sGbn = Trim(dw_cond.GetItemString(1,"iogbn"))
If sGbn = 'N' then
/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
	sJepumIo = 'Y%'
	sSaleGu  = 'N%'
Else
/* 판매출고 : 매출여부('Y') */
	sJepumIo = '%'
	sSaleGu  = 'Y%'
End If
	
/*송장 처리*/
IF sModStatus = 'I' THEN
	IF dw_haldang.Retrieve(sSaupj, sSuDat, sCvcod, sPlnt, sChk) <=0 THEN 
		f_message_chk(50,'')
		dw_cond.Setfocus()
		Return
	ELSE
		dw_imhist.Reset()
	END IF
Else
	/* 송장취소 */
   sIoJpNo = Trim(This.GetItemString(Row,"iojpno"))	
	sArea   = Trim(This.GetItemString(Row,"sarea"))
//	Messagebox(schk, splnt)
	IF dw_imhist.Retrieve(gs_sabu,sSuDat, sCvcod, sIoJpNo, sJepumIo, sSaleGu, sItnbr+'%', sChk, splnt) <=0 THEN 
		f_message_chk(50,'')
		dw_cond.Setfocus()
		Return
	ELSE
		dw_haldang.Reset()
	END IF
	
	dw_cond.SetItem(1,'iojpno',sIoJpNo)
	dw_cond.SetItem(1,'sarea',sArea)
	dw_cond.SetItem(1,'cvcod',sCvcod)
	dw_cond.SetItem(1,'vndname',sCvcodNm)
End If

ib_any_typing = False
cbx_select.TriggerEvent(Clicked!)
end event

type cbx_all from checkbox within w_dm01_00010
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

type dw_list from datawindow within w_dm01_00010
boolean visible = false
integer x = 1728
integer y = 2684
integer width = 1051
integer height = 104
integer taborder = 180
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

type st_2 from statictext within w_dm01_00010
integer x = 87
integer y = 220
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

type st_list from statictext within w_dm01_00010
integer x = 87
integer y = 860
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
string text = "[품목현황]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_haldang from statictext within w_dm01_00010
integer x = 2304
integer y = 220
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
long backcolor = 32106727
string text = "[출하의뢰현황]"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_napip from radiobutton within w_dm01_00010
integer x = 640
integer y = 76
integer width = 334
integer height = 60
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "납입카드"
boolean checked = true
end type

event clicked;dw_haldang_list.DataObject = 'd_dm01_00010_1'
dw_haldang.DataObject 		= 'd_dm01_00010_2'

dw_haldang_list.SetTransObject(sqlca)
dw_haldang.SetTransObject(sqlca)
end event

type rb_chul from radiobutton within w_dm01_00010
integer x = 1390
integer y = 76
integer width = 320
integer height = 60
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "출하의뢰"
end type

event clicked;dw_haldang_list.DataObject = 'd_dm01_00010_3'
dw_haldang.DataObject 		= 'd_dm01_00010_4'

dw_haldang_list.SetTransObject(sqlca)
dw_haldang.SetTransObject(sqlca)
end event

type gb_1 from groupbox within w_dm01_00010
integer x = 608
integer y = 16
integer width = 1161
integer height = 160
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
end type

type rr_1 from roundrectangle within w_dm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 236
integer width = 2171
integer height = 584
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_dm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 924
integer width = 4585
integer height = 1408
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_dm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2222
integer y = 236
integer width = 2395
integer height = 580
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_dm01_00010
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

type rb_can from radiobutton within w_dm01_00010
integer x = 1038
integer y = 72
integer width = 338
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "취소카드"
end type

event clicked;dw_haldang_list.DataObject = 'd_dm01_00010_7'
dw_haldang.DataObject 		= 'd_dm01_00010_8'

dw_haldang_list.SetTransObject(sqlca)
dw_haldang.SetTransObject(sqlca)
end event

type pb_1 from u_pb_cal within w_dm01_00010
integer x = 727
integer y = 356
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_cond.SetColumn('sudat')
IF IsNull(gs_code) THEN Return 
dw_cond.SetItem(1, 'sudat', gs_code)

end event

type dw_haldang from u_d_popup_sort within w_dm01_00010
event ue_processenter pbm_dwnprocessenter
integer x = 41
integer y = 932
integer width = 4562
integer height = 1392
integer taborder = 120
string dataobject = "d_dm01_00010_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

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

event updatestart;//Long ix
//
//For ix = 1 To This.RowCount()
//	Choose Case GetItemStatus(ix,0,Primary!)
//		Case NewModified!
//			This.SetItem(ix,'crt_user',gs_userid)
//		Case DataModified!
//			This.SetItem(ix,'upd_user',gs_userid)
//	End Choose
//Next
end event

event itemchanged;Long 	 nRow, nHRow
Double lOldQty, dItemQty, nNapQty, dValidQty, dJegoQty
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, get_nm, sfilsk, sitgu
Int    ireturn

nRow = GetRow()
If nRow <= 0 Then Return

sle_msg.Text = ''
		
Choose Case GetColumnName()
	Case 'flag_choice'
		dValidQty = GetItemNumber(nRow,"valid_qty")
		IF IsNull(dValidQty) THEN dValidQty =0
		
		dJegoQty = wf_calc_Jego(nRow)
		IF IsNull(dJegoQty) THEN dJegoQty =0

		If GetText() = 'Y' Then
			If sMinus = 'Y' Then
				Return
			Else
				IF dValidQty > dJegoQty THEN
					sle_msg.Text = '재고수량이 부족합니다.!!'
					SetItem(nRow,"flag_choice", 'N')
					Return 2
				END IF
			End If
		End If
	/* 출고수량 분할*/
	Case 'valid_qty'
		dItemQty = Long(GetText())
		If dItemQty <= 0 Then
			MessageBox('확 인','[출고수량은 0이하로 할 수 없습니다]')
			Return 1
		End If
		
		lOldQty = GetItemNumber(nRow, 'valid_qty', Primary!, True)
		sle_msg.text = '할당잔량 = ' + string(loldqty)
		
//		If dItemQty > lOldQty Then
//			MessageBox('확 인','[출고수량은 할당잔량 이상으로 할 수 없습니다]~r~n~r~n'+'할당잔량 = ' + string(loldqty))
//			Return 1
//		End If
//		
//		nHRow = dw_haldang_list.GetSelectedRow(0)
//		If nHRow > 0 Then
//			/* 납품배수 */
//			nNapQty = dw_haldang_list.GetItemNumber(nHrow,'napqty')
//			If IsNull(nNapqty) Or nNapQty = 0 Then
//			Else
//				If Mod(dItemQty, nNapQty) <> 0 Then
//					MessageBox('확 인','수량은 납품배수 범위내에서 가능합니다.!!~n~n납품배수 : ' +string(nNapqty)+'배수')
//					Return 2
//				End If
//			End If
//		End If
		
//		SetItem(nRow, 'flag_choice', 'N')
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itemas_itdsc", sitdsc)	
		
		Post wf_danga(nrow)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
//			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS2"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
//			this.setitem(nrow, 'cvnas', get_nm)
			
			Post wf_danga(nrow)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
End Choose
end event

event clicked;call super::clicked;

If row > 0 then
	selectrow(0,false)
	selectrow(row, true)
else
	selectrow(0,false)
end if
end event

event rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(lrow,"itnbr",gs_code)
		this.SetItem(lrow,"itemas_itdsc",gs_codename)
		
		Post wf_danga(lrow)
		
		Return 1
	Case 'cvcod'
		gs_code = GetText()

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(lrow, "cvcod", gs_Code)
//		this.SetItem(lrow, "cvnas", gs_Codename)
		
		Post wf_danga(lrow)
End Choose
end event

type dw_imhist from u_d_popup_sort within w_dm01_00010
integer x = 41
integer y = 932
integer width = 4562
integer height = 1392
integer taborder = 100
string dataobject = "d_dm01_00010_6"
boolean vscrollbar = true
boolean border = false
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

messagebox('', sqlerrtext)

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
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

