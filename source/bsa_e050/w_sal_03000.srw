$PBExportHeader$w_sal_03000.srw
$PBExportComments$제품 출고 승인등록
forward
global type w_sal_03000 from w_inherite
end type
type dw_cond from u_key_enter within w_sal_03000
end type
type rb_1 from radiobutton within w_sal_03000
end type
type rb_2 from radiobutton within w_sal_03000
end type
type dw_imhist_n from u_d_popup_sort within w_sal_03000
end type
type dw_imhist_y from u_d_popup_sort within w_sal_03000
end type
type dw_cond2 from datawindow within w_sal_03000
end type
type st_2 from statictext within w_sal_03000
end type
type st_3 from statictext within w_sal_03000
end type
type pb_1 from u_pb_cal within w_sal_03000
end type
type pb_2 from u_pb_cal within w_sal_03000
end type
type pb_3 from u_pb_cal within w_sal_03000
end type
type dw_lot from datawindow within w_sal_03000
end type
type p_bar from uo_picture within w_sal_03000
end type
type dw_imhist_in from datawindow within w_sal_03000
end type
type rr_1 from roundrectangle within w_sal_03000
end type
type rr_2 from roundrectangle within w_sal_03000
end type
type rr_3 from roundrectangle within w_sal_03000
end type
type rr_4 from roundrectangle within w_sal_03000
end type
end forward

global type w_sal_03000 from w_inherite
string title = "제품 출고 승인등록"
dw_cond dw_cond
rb_1 rb_1
rb_2 rb_2
dw_imhist_n dw_imhist_n
dw_imhist_y dw_imhist_y
dw_cond2 dw_cond2
st_2 st_2
st_3 st_3
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
dw_lot dw_lot
p_bar p_bar
dw_imhist_in dw_imhist_in
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sal_03000 w_sal_03000

type variables
String  sQtyModified, is_DepotNo


end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function string wf_saleconfirm (string scino)
public function integer wf_retrieve_imhist (string sfrom, string sto)
public function integer wf_delete_dup (ref datawindow dwo)
public subroutine wf_init ()
public function integer wf_select_lot (integer ar_row)
public function integer wf_create_ipgo ()
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sOutDate,sCvpln,sFromDate,sToDate,sDepot, sSaupJ

If dw_cond.AcceptText() <> 1 Then Return -1
If dw_cond2.AcceptText() <> 1 Then Return -1

sOutDate  = dw_cond.GetItemSTring(1,"out_date")
sCvpln    = dw_cond.GetItemSTring(1,"cvpln")
sFromDate = dw_cond2.GetItemSTring(1,"invoice_fdate")
sToDate   = dw_cond2.GetItemSTring(1,"invoice_tdate")
sDepot    = dw_cond2.GetItemSTring(1,"depot")
sSaupj    = dw_cond2.GetItemSTring(1,"saupj")

IF sModStatus = 'I' THEN
	IF sOutDate = "" OR IsNull(sOutDate) THEN
		f_message_chk(30,'[출고일자]')
		dw_cond.SetColumn("out_date")
		dw_cond.SetFocus()
		Return -1
	END IF
	IF sCvpln = "" OR IsNull(sCvpln) THEN
		f_message_chk(30,'[출고담당자]')
		dw_cond.SetColumn("cvpln")
		dw_cond.SetFocus()
		Return -1
	END IF
END IF

dw_cond2.SetFocus()
IF sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_cond2.SetColumn("saupj")
	Return -1
END IF

IF sFromDate = "" OR IsNull(sFromDate) THEN
	f_message_chk(30,'[송장일자]')
	dw_cond2.SetColumn("invoice_fdate")
	Return -1
END IF

IF sToDate = "" OR IsNull(sToDate) THEN
	f_message_chk(30,'[송장일자]')
	dw_cond2.SetColumn("invoice_tdate")
	Return -1
END IF

IF sDepot = "" OR IsNull(sDepot) THEN
	f_message_chk(30,'[창고]')
	dw_cond2.SetColumn("depot")
	Return -1
END IF

Return 1
end function

public function string wf_saleconfirm (string scino);String sLocalyn, SaleConfirm

/* 매출확정일 (1:면장(계산서),2:출고,3:B/L) */
SELECT RTRIM(LOCALYN) INTO :sLocalyn
  FROM EXPCIH
 WHERE SABU = :gs_sabu AND
       CINO = :sCino;

If IsNull(sLocalYn) Then sLocalYn = 'N'

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

If IsNull(SaleConfirm) Then	SaleConfirm = '1'

Return SaleConfirm
end function

public function integer wf_retrieve_imhist (string sfrom, string sto);String  sIoGbn,sIoConFirmGbn,sInpCrt,sSqlSynTax,sSynTaxN,sSynTaxY,sDepotNo, sArea, sSaupj, sSaleGu, sLocalyn
Integer iRtvRowN,iRtvRowY

If dw_cond2.AcceptText() <> 1 Then Return -1

sSalegu = dw_cond2.GetItemString(1, 'salegu')
sLocalYn = dw_cond2.GetItemString(1, 'LocalYn')

If sSalegu = '2' Then	/* 수출 DIRECT */
	If sLocalYn = 'N' Then
		sSqlSyntax = "SELECT DISTINCT IMHIST.SABU, " +&
						 "			IMHIST.INV_NO AS IOJPNO, " +&
						 "			IMHIST.CVCOD ," +&
						 "			IMHIST.IOGBN ," +&
						 "			VNDMST.CVNAS2, " +&
						 "			IMHIST.IO_DATE, " +&
						 "			'' AS DUP, FUN_GET_CVNAS(IMHIST.CUST_NO) AS CUSTNM " +&
						 "	 FROM IMHIST,  VNDMST " +&
						 "	 WHERE ( imhist.cvcod = vndmst.cvcod (+)) and " + &
						 "	 NOT EXISTS (SELECT 'X' FROM IMHIST_DAECHE WHERE IMHIST.SABU   = IMHIST_DAECHE.SABU AND " + &
						 "												IMHIST.IOJPNO = IMHIST_DAECHE.IOJPNO ) and " + &
						 "        ( imhist.jnpcrt ='014' ) and " + &
						 "        ( imhist.inv_no is not null ) "
	Else
		sSqlSyntax = "SELECT DISTINCT IMHIST.SABU, " +&
						 "			SUBSTR(IMHIST.IOJPNO,1,12) AS IOJPNO, " +&
						 "			IMHIST.CVCOD ," +&
						 "			IMHIST.IOGBN ," +&
						 "			VNDMST.CVNAS2, " +&
						 "			IMHIST.IO_DATE, " +&
						 "			'' AS DUP, FUN_GET_CVNAS(IMHIST.CUST_NO) AS CUSTNM " +&
						 "	 FROM IMHIST,  VNDMST " +&
						 "	 WHERE ( imhist.cvcod = vndmst.cvcod (+)) and " + &
						 "        ( imhist.jnpcrt ='014' ) and " + &
						 "        ( imhist.inv_no is null ) "		
	End If

Else	/* 내수 */
	sSqlSyntax = "SELECT DISTINCT IMHIST.SABU, " +&
					 "			SUBSTR(IMHIST.IOJPNO,1,12) AS IOJPNO, " +&
					 "			IMHIST.CVCOD ," +&
					 "			IMHIST.IOGBN ," +&
					 "			VNDMST.CVNAS2, " +&
					 "			IMHIST.IO_DATE, " +&
					 "			'' AS DUP, FUN_GET_CVNAS(IMHIST.CUST_NO) AS CUSTNM " +&
					 "	 FROM IMHIST,  VNDMST " +&
					 "	 WHERE ( imhist.cvcod = vndmst.cvcod (+)) and " + &
					 "        ( imhist.jnpcrt ='004' or imhist.jnpcrt = '044' or imhist.jnpcrt = '046' ) "

End If

/* 출고구분 */
sIoGbn = Trim(dw_cond2.GetItemString(1,'iogbn'))
If IsNull(sIoGbn) Or sIoGbn = '' Then
	sSqlSyntax = sSqlSyntax + "and (imhist.iogbn in ( select iogbn from iomatrix where sabu = '" + gs_sabu + "' and iosp = 'O' and (jepumio = 'Y' or salegu = 'Y' or iogbn = 'O22' or iogbn = 'OM3' ) ) ) "
Else
	sSqlSyntax = sSqlSyntax + "and (imhist.iogbn = '"+sIoGbn+"') "
End If

sDepotNo = dw_cond2.GetItemString(1,'depot')
sSqlSyntax = sSqlSyntax + "and (imhist.depot_no = '"+sDepotNo+"') "

/* 사업장 */
sSaupj = dw_cond2.GetItemString(1,'saupj')
sSqlSyntax = sSqlSyntax + "and (imhist.saupj = '"+sSaupj+"') "

/* 관할구역 */
sArea = Trim(dw_cond2.GetItemString(1,'sarea'))
If IsNull(sArea) or sArea = '' Then
Else
  sSqlSyntax = sSqlSyntax + "and (vndmst.sarea = '"+sArea+"') "
End If

/* Reset DataWindow */
dw_imhist_y.Reset()
dw_imhist_n.Reset()

If rb_1.Checked = True Then
	/*미확인 송장*/
	sIoConFirmGbn = 'N'
	sSynTaxN = sSqlSyntax + "and (imhist.sabu ='"+gs_sabu+"') and (imhist.sudat >= '"+sFrom+"') and (imhist.sudat <= '"+sTo+"')"
	sSynTaxN = sSynTaxN + "and ( ( IMHIST.IO_DATE is NULL ) OR ( IMHIST.IO_DATE =  ''   ) ) "
	
	dw_imhist_n.SetRedraw(False)

//	messagebox('', ssyntaxn)
	
	dw_imhist_n.SetSQLSelect(sSynTaxN)
	dw_imhist_n.SetTransObject(SQLCA)
	
	iRtvRowN = dw_imhist_n.Retrieve()

	/* 중복송장 제외 */
	wf_delete_dup(dw_imhist_n)

	dw_imhist_n.SetRedraw(True)
Else
	/*확인 송장*/
	sIoConFirmGbn = 'Y'
	
	/* 검수일자 사용여부에 따라 */
	sSynTaxY = sSqlSyntax + "and (imhist.sabu ='"+gs_sabu+"') and (imhist.io_date >= '"+sFrom+"') and (imhist.io_date <= '"+sTo+"')"
	
	dw_imhist_y.SetRedraw(False)
	
	dw_imhist_y.SetSQLSelect(sSynTaxY)
	dw_imhist_y.SetTransObject(SQLCA)
	
	iRtvRowY = dw_imhist_y.Retrieve()
	
	/* 중복송장 제외 */
	wf_delete_dup(dw_imhist_y)
	
	dw_imhist_y.SetRedraw(True)
End If

dw_insert.Reset()

IF sModStatus = 'I' THEN
	Return iRtvRowN
ELSE
	Return iRtvRowY
END IF

end function

public function integer wf_delete_dup (ref datawindow dwo);/* 중복된 송장은 제외한다 */
Long nRowCnt, ix,iy

nRowCnt = dwo.RowCount()
If nRowCnt <= 1 Then Return 0

For ix = 1 To nRowcnt - 1
	If dwo.GetItemString(ix,'iojpno') = dwo.GetItemString(ix+1,'iojpno') Then
		dwo.SetItem(ix+1,'dup','Y')
	End If
Next
	
For ix = nRowCnt To 1 Step -1
	If dwo.GetItemString(ix,'dup') = 'Y' Then
		dwo.DeleteRow(ix)
	End If
Next

Return 0
end function

public subroutine wf_init ();string sNull, sSalegu

SetNull(sNull)
rollback;

sSalegu = dw_cond2.GetItemString(1, 'salegu')

dw_cond2.SetItem(1,"depot",is_DepotNo)
dw_cond2.SetItem(1,"invoice_fdate", left(is_today,6)+'01')
dw_cond2.SetItem(1,"invoice_tdate", is_today)
  
/* 출고확인 */
If rb_1.Checked = True Then
  dw_cond.Object.out_date_t.text = '출고일자'
  dw_cond2.Object.fdate_t.text    = '송장일자'
  dw_cond.SetItem(1,"out_date",is_today)

  
  dw_cond.Object.out_date_t.Visible = True
  dw_cond.Object.out_date.Visible = True
  dw_cond.Object.t_1.Visible = True
  
	If sSalegu = '1' Then
	  dw_insert.DataObject = 'd_sal_030007'
	else
		dw_insert.DataObject = 'd_sal_030009'
	end if
	
  dw_insert.SetTransObject(sqlca)
Else
/* 출고확인 취소 */
  dw_cond.Object.out_date_t.text = ''
  dw_cond2.Object.fdate_t.text    = '출고일자'
  dw_cond.SetItem(1,"out_date",sNull)
  
  dw_cond.Object.out_date_t.Visible = False
  dw_cond.Object.out_date.Visible = False
  dw_cond.Object.t_1.Visible = False

  If sSalegu = '1' Then
	dw_insert.DataObject = 'd_sal_030008'
	Else
		dw_insert.DataObject = 'd_sal_030008_1'
	End If
  dw_insert.SetTransObject(sqlca)
End If

dw_cond.SetColumn("cvpln")
dw_cond.SetFocus()

dw_imhist_n.Reset()
dw_imhist_y.Reset()

dw_insert.Reset()

/* 수량 변경여부 */
If sqtymodified = 'Y' and sModStatus = 'I' Then
	dw_insert.Modify('choiceqty.protect = 0')
Else
	dw_insert.Modify('choiceqty.protect = 1')
End If

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\처리_up.gif"
end subroutine

public function integer wf_select_lot (integer ar_row);datawindow dwname	
String sIojpno, sNull
Long nRow, nIns, ix, nCnt
Dec  dQty

If dw_insert.accepttext() <> 1 Then Return -1

nRow = ar_row
If nRow <= 0 Then Return -1

SetNull(sNull)

If dw_insert.GetItemString(nRow, 'lotgub') = 'Y' Then
	dwname = dw_lot
	
	gs_gubun = dw_insert.GetItemString(nRow, 'depot_no')
	gs_code  = dw_insert.getitemstring(nRow, "itnbr")
	gs_codename = dw_insert.getitemstring(nRow, "iojpno")
	sIojpno     = dw_insert.getitemstring(nRow, "iojpno")
	gs_codename2 = string(dw_insert.getitemNumber(nRow, "old_ioreqty"))
	
	openwithparm(w_stockwan_popup, dwname)
	If IsNull(gs_code) Or Not IsNumber(gs_code) Then Return 1

	// 기존 선택자료 삭제
	nCnt = dw_insert.RowCount()
	For ix = nCnt To 1 Step -1
		If dw_insert.GetItemString(ix, 'ip_jpno') = sIojpno Then
			dw_insert.RowsDiscard(ix, ix, Primary!)
			Continue
		End If
	Next
//	dw_insert.SetFilter("chk = 'N' and Not isnull(ip_jpno) and ip_jpno = '" + sIojpno + "'")
//	dw_insert.Filter()
//	dw_insert.RowsDiscard(1, dw_insert.FilteredCount(), Filter!)
//	dw_insert.SetFilter("")
//	dw_insert.Filter()

	dw_lot.SetFilter("hold_no = '" + sIojpno +"'")
	dw_lot.Filter()
	
	Choose Case dw_lot.RowCount() 
		Case 0
			dw_insert.SetItem(nRow, 'choiceqty', 0)
			dw_insert.SetItem(nRow, 'lotsno',    dw_insert.getitemstring(nRow, 'old_lotsno'))
			dw_insert.SetItem(nRow, 'pspec',     dw_insert.getitemstring(nRow, 'old_pspec'))
		Case 1
			dw_insert.SetItem(nRow, 'choiceqty', 		dw_lot.getitemnumber(1, 'hold_qty'))
			dw_insert.SetItem(nRow, 'imhist_lotsno',  dw_lot.getitemstring(1, 'lotno'))
			dw_insert.SetItem(nRow, 'pspec',     		dw_lot.getitemstring(1, 'pspec'))
		Case is >1
			dw_insert.SetItem(nRow, 'choiceqty', 		dw_lot.getitemnumber(1, 'hold_qty'))
			dw_insert.SetItem(nRow, 'imhist_lotsno',  dw_lot.getitemstring(1, 'lotno'))
			dw_insert.SetItem(nRow, 'pspec',     		dw_lot.getitemstring(1, 'pspec'))
			
			nIns = nRow
			For ix = 2 To dw_lot.RowCount()
				dw_insert.RowsCopy(nRow, nRow, Primary!, dw_insert, nIns+1, Primary!)
				nIns = nIns + 1

				dw_insert.SetItem(nIns, 'choiceqty', 		dw_lot.getitemnumber(ix, 'hold_qty'))
				dw_insert.SetItem(nIns, 'imhist_lotsno',  dw_lot.getitemstring(ix, 'lotno'))
				dw_insert.SetItem(nIns, 'pspec',     		dw_lot.getitemstring(ix, 'pspec'))
				dw_insert.SetItem(nIns, 'ip_jpno',    		sIojpno)
				dw_insert.SetItem(nIns, 'chk',     			'N')
			Next
			
			// 금액 재계산
			For ix = nRow To nIns
				dw_insert.SetItem(ix, 'ioamt',	truncate((dw_insert.getitemnumber(ix, 'ioamt')/dw_insert.getitemnumber(ix, 'ioreqty'))*dw_insert.getitemnumber(ix,'choiceqty'),0))
				dw_insert.SetItem(ix, 'foramt',	truncate((dw_insert.getitemnumber(ix, 'foramt')/dw_insert.getitemnumber(ix, 'ioreqty'))*dw_insert.getitemnumber(ix,'choiceqty'),2))
				dw_insert.SetItem(ix, 'foruamt',	truncate((dw_insert.getitemnumber(ix, 'foruamt')/dw_insert.getitemnumber(ix, 'ioreqty'))*dw_insert.getitemnumber(ix,'choiceqty'),2))
				dw_insert.SetItem(ix, 'ioreqty',	dw_insert.getitemnumber(ix,'choiceqty'))
				dw_insert.SetItem(ix, 'iosuqty',	dw_insert.getitemnumber(ix,'choiceqty'))
			Next
	End Choose
	
	setnull(gs_code)
End If

return 1
end function

public function integer wf_create_ipgo ();///////////////////////////////////////////////////////////////////////
// 재투입인 경우 생산창고 입고 전표 생성
///////////////////////////////////////////////////////////////////////

string	sJpno, sIOgubun,	sDate, sTagbn, sEmpno2, sDept, &
         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom
long		lRow, lRowHist, lRowHist_In
dec		dSeq, dOutQty,	dInSeq
String   sStock, sGrpno, sGubun, sHouseYn

/* Save Data window Clear */
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sDate = dw_cond.GetItemString(1, "out_date")				// 출고일자

////////////////////////////////////////////////////////////////////////
sHouse  = dw_cond2.GetItemString(1, "depot")   //창고
sEmpno2 = dw_cond.GetItemString(1, "cvpln")  //출고담당자

// 입고전표번호
dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
IF dInSeq < 0		THEN	
	rollback;
	RETURN -1
end if
COMMIT;
		 
//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_insert.RowCount()

	dOutQty = dw_insert.GetItemDecimal(lRow, "choiceqty")

	// 출고전표 승인
	dw_insert.SetItem(lRow,"ioqty",     dw_insert.GetitemNumber(lRow,"choiceqty"))
	dw_insert.SetItem(lRow,"io_date",   sdate)
	dw_insert.SetItem(lRow,"io_empno",  sEmpno2)
	
	// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
	// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
	sCvcod = dw_insert.GetItemString(lRow, 'cvcod')
	Setnull(sSaleyn)
	SELECT HOMEPAGE
	  INTO :sSaleYN
	  FROM VNDMST
	 WHERE CVCOD = :sCvcod ;	

	IF isnull(sSaleyn) or trim(ssaleyn) = '' then
		Ssaleyn = 'N'
	end if
			
	//////////////////////////////////////////////////////////////////////////////////////////////////////	
	lRowHist_In = dw_imhist_in.InsertRow(0)						
	
	dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
	dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'045')			// 전표생성구분
	dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
	dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
	dw_imHist_in.SetItem(lRowHist_in, "iogbn",   'I11') 		// 수불구분=창고이동입고구분

	dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
	dw_imHist_in.SetItem(lRowHist_in, "itnbr", 	dw_insert.GetItemString(lRow, "itnbr")) // 품번
	dw_imHist_in.SetItem(lRowHist_in, "pspec", 	dw_insert.GetItemString(lRow, "pspec")) // 사양
	dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// 기준창고=입고처
	
	select ipjogun into :sSaupj
	  from vndmst where cvcod = :sCvcod;  // 입고 창고의 부가 사업장 가져옮
	
	dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
	
	
	dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
	dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// 공정코드

	dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dOutQty) 	// 수불의뢰수량=출고수량		

	dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dOutQty) 	// 합격수량=출고수량		
	dw_imHist_in.SetItem(lRowHist_in, "filsk",   'Y') // 재고관리유무	
	dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_insert.GetItemString(lRow, "imhist_lotsno"))
			
			
	sItnbr  = dw_insert.GetItemString(lRow, "itnbr")

	sgubun = '1'
	dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun) // 무검사
	dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
	dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)

	//////////////////////////////////////////////////////////////////////////////////////////////////////

	// 무검사이며 자동승인인 경우 승인내역 저장
	IF sgubun = '1' And sSaleYn = 'Y' then
		dw_imhist_in.SetItem(lRowHist_in, "ioqty", dOutQty) 	// 수불수량=입고수량
		dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
		dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
		dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// 수불승인여부
	ELSE
		dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// 수불승인여부
	End If
	
	dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
	dw_imHist_in.SetItem(lRowHist_in, "itgu",    '5') 	// 구입형태

	dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
	dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", dw_insert.GetItemString(lRow, "iojpno"))  // 입고전표번호=출고번호
NEXT

RETURN lRowHist_In
end function

on w_sal_03000.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_imhist_n=create dw_imhist_n
this.dw_imhist_y=create dw_imhist_y
this.dw_cond2=create dw_cond2
this.st_2=create st_2
this.st_3=create st_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.dw_lot=create dw_lot
this.p_bar=create p_bar
this.dw_imhist_in=create dw_imhist_in
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_imhist_n
this.Control[iCurrent+5]=this.dw_imhist_y
this.Control[iCurrent+6]=this.dw_cond2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_3
this.Control[iCurrent+12]=this.dw_lot
this.Control[iCurrent+13]=this.p_bar
this.Control[iCurrent+14]=this.dw_imhist_in
this.Control[iCurrent+15]=this.rr_1
this.Control[iCurrent+16]=this.rr_2
this.Control[iCurrent+17]=this.rr_3
this.Control[iCurrent+18]=this.rr_4
end on

on w_sal_03000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_imhist_n)
destroy(this.dw_imhist_y)
destroy(this.dw_cond2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.dw_lot)
destroy(this.p_bar)
destroy(this.dw_imhist_in)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;/* 수량조정 여부 */
select substr(dataname,1,1) into :sQtyModified
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 20;

/* 창고(영업,완제품) Defalut */
SELECT MIN("VNDMST"."CVCOD") INTO :is_DepotNo
  FROM "VNDMST"  
 WHERE ( "VNDMST"."CVGU" = '5' ) AND  
       ( "VNDMST"."JUPROD" = '1' ) AND  
       ( "VNDMST"."SOGUAN" = '1' ) AND
      ( "VNDMST"."JUHANDLE" = '1' ) AND
	 ( "VNDMST"."IPJOGUN" = :gs_saupj ) ;

dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

dw_imhist_n.SetTransObject(SQLCA)

dw_imhist_y.SetTransObject(SQLCA)
dw_imhist_in.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

/* 출고 담당자 Filtering */
DataWindowChild state_child
integer rtncode

//출고 담당자
rtncode 	= dw_cond.GetChild('cvpln', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('26',gs_saupj)

// 창고설정
f_child_saupj(dw_cond2, 'depot', gs_saupj)

//관할 구역
f_child_saupj(dw_cond2, 'sarea', gs_saupj)

dw_cond2.SetTransObject(SQLCA)
dw_cond2.InsertRow(0)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_cond2.Modify("sarea.protect=1")
	dw_cond2.Modify("sarea.background.color = 80859087")
End If
dw_cond2.SetItem(1, 'saupj', saupj)
dw_cond2.SetItem(1, 'sarea', sarea)
	
rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

// 부가세 사업장 설정
f_mod_saupj(dw_cond2, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_sal_03000
integer x = 37
integer y = 1024
integer width = 4544
integer height = 1296
integer taborder = 60
string dataobject = "d_sal_030007"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;double dchoiceQty, dIoreqty, dIoprc, dVatAmt

Choose Case GetColumnName()
	Case 'choiceqty'
		dChoiceqty = Double(GetText())
		If IsNull(dChoiceqty) Or dChoiceqty <= 0 Then Return 2
		
		dIoreqty = GetItemNumber(row,'ioreqty')
		If dIoreqty < dChoiceqty Then Return 2
		
		/* 부가세 */
//		dVatAmt = dw_insert.GetItemNumber(row,"vatamt")
		dVatAmt = dw_insert.GetItemNumber(row,"dyebi3")
		If IsNull(dVatAmt) Then dVatAmt = 0

		If dVatAmt <> 0 and dIoreqty <> dChoiceqty Then
			dVatAmt = Truncate(dVatAmt / dIoreqty * dChoiceqty,0)
			SetItem(row, 'dyebi3', dVatAmt)
		End If
		
		dIoprc = GetItemNumber(row,'ioprc')
		SetItem(row,'ioamt',dChoiceqty * dIoprc )
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

event dw_insert::constructor;call super::constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

event dw_insert::clicked;call super::clicked;if this.Rowcount() = 0 then return

this.SelectRow(0, false)
this.SelectRow(row, true)
end event

event dw_insert::buttonclicked;call super::buttonclicked;Post wf_select_lot(row)
end event

type p_delrow from w_inherite`p_delrow within w_sal_03000
boolean visible = false
integer x = 1792
integer y = 2576
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_03000
boolean visible = false
integer x = 1618
integer y = 2576
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_03000
boolean visible = false
integer x = 1106
integer y = 2572
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sal_03000
boolean visible = false
integer x = 1445
integer y = 2576
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_03000
integer x = 4434
integer y = 28
end type

type p_can from w_inherite`p_can within w_sal_03000
integer x = 4261
integer y = 28
end type

event p_can::clicked;call super::clicked;String sNull

SetNull(sNull)

dw_imhist_y.Reset()
dw_imhist_n.Reset()

dw_insert.Reset()

end event

type p_print from w_inherite`p_print within w_sal_03000
boolean visible = false
integer x = 1280
integer y = 2572
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_03000
integer x = 3913
integer y = 28
end type

event p_inq::clicked;call super::clicked;Integer iRowCount
integer msgok

msgok = Message.WordParm

IF dw_cond.AcceptText() = -1 THEN RETURN
IF dw_cond2.AcceptText() = -1 THEN RETURN

IF Wf_RequiredChk(1) = -1 THEN RETURN

iRowCount = Wf_Retrieve_ImHist(dw_cond2.GetItemString(1,"invoice_fdate"),&
										           dw_cond2.GetItemString(1,"invoice_tdate"))

IF iRowCount = 0 THEN
	If msgok <> 1 Then f_message_chk(50,'')
	Return
END IF
end event

type p_del from w_inherite`p_del within w_sal_03000
boolean visible = false
integer x = 1966
integer y = 2588
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_03000
integer x = 4087
integer y = 28
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String  snull,sout_date,scvpln,sCheckNo, sDeny, sInvNo, sYebi, sPassWord, sSaledt, sIogbn, sIojpno
String  Sittyp, Sold_spec, sCurr, SaleConfirm, sLocalyn, sNappum, sJpno, sMaxIojpno, sipno, sLotsNo
Long    k, nRow, nRtn, rtncode, nCnt = 0, dCiSeq, nCiRow, nSkipCnt=0, nMax, ix, iy, nTot, nfind
DataWindowChild state_child
Dec	  dWrate = 0;

SetNull(snull)

IF dw_insert.RowCount() <= 0 THEN RETURN
If dw_insert.AcceptText() <> 1 Then return
If dw_cond.AcceptText() <> 1 Then Return

SetPointer(HourGlass!)

/* 출고 확인 */
/************************************ 등 록 ******************************************/
If sModStatus = 'I' THEN
	nRow       = dw_imhist_n.GetRow()

	sout_date  = dw_cond.GetItemString(1,"out_date")
	scvpln     = dw_cond.GetItemString(1,"cvpln")
	
	If f_datechk(sout_date) <> 1 Then
		f_message_chk(30,'[출고일자]')
		Return 1
	End If

	// 수출인 경우만 체크
	If dw_cond2.GetItemString(1, 'salegu') = '2' Then
		If dw_insert.GetItemNumber(1,'sum_yoqty') <> dw_insert.GetItemNumber(1,'sum_choiceqty') Then
			MessageBox('확인','의뢰수량과 요청수량이 다릅니다.!!')
			Return
		End If
	End If
	
	// Lot No 체크
	For iy = 1 To dw_insert.RowCount()
		sLotsno = Trim(dw_insert.getItemString(iy,'imhist_lotsno'))
		If dw_insert.GetItemString(iy,'lotgub') = 'Y' Then
			If IsNull(sLotsNo) Or sLotsNo = '' Or sLotsNo = '.' Then
				MessageBox('확인','LOT NO를 선택하세요.!!')
				Return
			End If
		End If
	Next
	
	// 신규생성된 내역에 대해서 전표번호를 채번한다
	sMaxIojpno = dw_insert.GetItemString(1, 'max_iojpno')
	sJpno		  = Left(smaxiojpno,12)
	nMax       = Dec(Mid(smaxIojpno,13,3))
	
	For ix = 1 To dw_insert.RowCount()
		If dw_insert.GetItemString(ix, 'chk') = 'N' Then
			nMax = nMax + 1
			dw_insert.SetItem(ix, 'iojpno', sJpno + string(nmax,'000'))
		End If
	Next
	
	/* 환율 확인 */
	sInvNo = dw_insert.GetItemString(1,"inv_no")
	If Not IsNull(sInvNo) Then
		sCurr = dw_insert.GetItemString(1,"yebi2")
		
		select x.rstan
	     into :dWrate
	     from ratemt x
		 where x.rdate = :sout_date and
				 x.rcurr = :scurr;
		
		If 	IsNull(dWrate) Or dWrate = 0 Then
			f_message_chK(166,sCurr)
			return
		End If
	End If
	
	/* 출고승인시 password */
	SetNull(sPassWord)
	select rtrim(dataname) into :sPassWord
	  from syscnfg
	 where sysgu = 'S' and
			 serial = 7 and
			 lineno = 70;
			 
	If Not IsNull(sPassWord) Then
		OpenWithParm(w_pgm_pass, sPassWord)
		sPassWord = Message.StringParm
		If 	sPassWord <> 'OK' Then
			Return 1
		End If
	End If

	/* 수출일 경우 CI 확정처리 */
	sInvNo = dw_insert.GetItemString(1,"inv_no")
	If Not IsNull(sInvNo) Then
		SaleConfirm = wf_saleconfirm(sInvNo)

		/* lot 내역을 선저장한다 */
		IF dw_insert.Update() = 1 THEN 	
		Else
		  Rollback;
		  f_message_chk(89,'')
		  wf_init()
		  Return
		End If

		If	SaleConfirm = '2' Then
			UPDATE EXPCIH
				SET OUTCFDT = :sout_date,
				    SALEDT  = :sout_date,
					 CISTS	= '2'
			 WHERE SABU = :gs_sabu AND
					 CINO = :sInvNo ;
		Else
			UPDATE EXPCIH
				SET OUTCFDT = :sout_date,
					 CISTS	= '2'
			 WHERE SABU = :gs_sabu AND
					 CINO = :sInvNo ;
		End If
		If sqlca.sqlcode <> 0 Or sqlca.sqlnrows <= 0 Then
			messagebox(string(sqlca),sqlca.sqlerrtext)
			RollBack;
			f_message_chk(57,'매출일자가 존재하거나 관련자료가 없습니다.!!')
			wf_init()
			Return
		End If
		
		/* 처리건수 */
		nCnt = sqlca.sqlnrows
	/* 내수일경우 */
	Else
		nSkipCnt = 0
		
		// 재투입인 경우 입고전표를 생성한다
		If dw_insert.GetItemString(1, 'iogbn') = 'OM3' Then
			nCnt = wf_create_ipgo()
			If nCnt <= 0 Then		Return
		Else
			FOR k= 1 TO dw_insert.RowCount()
				/* 출하통제대상일 경우 skip */
				sDeny = dw_insert.GetItemString(k, 'yebi2')
				If sDeny = 'N' Then	
					nSkipCnt += 1
					Continue
				End If
						
				dw_insert.SetItem(k,"ioqty",     dw_insert.GetitemNumber(k,"choiceqty"))
				dw_insert.SetItem(k,"io_date",   sOut_Date)
				dw_insert.SetItem(k,"io_empno",  scvpln)
	
				/* 검수일자 사용안할 경우, 수출일 경우 */
				sNappum = dw_insert.GetItemString(k, 'gumgu')
				If IsNull(sNappum) Then sNappum = 'N'
				
				If sNappum = 'N' Or Not IsNull(sInvNo) Then
					dw_insert.SetItem(k,"imhist_yebi1",   sOut_Date)
				End If
				
				nCnt += 1
			Next
		End If
	End If

	/* 미확인 송장 -> 확인 송장 */
	dw_imhist_n.SetItem(nRow,'io_date',sOut_Date)
	If 	nCnt > 0 and nSkipCnt = 0 Then
		nRtn = dw_imhist_n.RowsMove(nRow, nRow, Primary!, dw_imhist_y, 9999, Primary!)
	ElseIf nCnt > 0 and nSkipCnt > 0 Then
	   	nRtn = dw_imhist_n.RowsCopy(nRow, nRow, Primary!, dw_imhist_y, 9999, Primary!)
		MessageBox('확 인','일부 출하거부 품목이 존재합니다.!!')
	Else
		MessageBox('확 인','출하거부 품목이 존재합니다.!!')
	End If
	
   rtncode = dw_imhist_y.GetChild('iogbn', state_child)
	state_child.SetTransObject(sqlca)
	state_child.Retrieve()
	
	/* 수출일 경우 Return */
	If Not IsNull(sInvNo) Then
		commit;
		
		dw_insert.Reset()
		sle_msg.text = '자료를 처리하였습니다!!'
		
		Return
	End If
	
	
/* 출고 취소 */
/************************************ 취소 ******************************************/
Else
	nRow = dw_imhist_y.GetRow()
	string	sSalegu
	sSalegu = dw_cond2.GetItemString(1,"salegu")
	
	If f_msg_delete() <> 1 Then Return
	
	FOR k= 1 TO dw_insert.RowCount()
		sCheckNo = Trim(dw_insert.GetItemString(k,'checkno'))
		sYebi    = Trim(dw_insert.GetItemString(k,'imhist_yebi1'))
		sIogbn   = Trim(dw_insert.GetItemString(k,'iogbn'))
		
		If IsNull(sCheckNo) Or sCheckNo = '' Then
		  dw_insert.SetItem(k,"ioqty",     0)
		  dw_insert.SetItem(k,"io_date",   snull)
		  dw_insert.SetItem(k,"io_empno",  snull)
		  
			/* 검수일자 사용안할 경우 : 내수만 해당된 */
			IF sSalegu = '1'	THEN
				sNappum = dw_insert.GetItemString(k, 'gumgu')
			END IF
			
			If IsNull(sNappum) Then sNappum = 'N'
			
			If sNappum = 'N' Then
				dw_insert.SetItem(k,"imhist_yebi1",   sNull)
			Else
				If dw_cond2.GetItemString(1,"salegu") = '1' Then
				   If Not IsNull(sYebi) Then
					   Rollback;
					   f_message_chk(57,'[검수확인된 자료가 존재합니다')
					   Return
				   Else
				  	   dw_insert.SetItem(k,"imhist_yebi1",   sNull)
					   Continue
				   End If
				End If
			End If
		End If
		
		// 재투입인 경우 입고전표 삭제
		If sIogbn = 'OM3' Then
			sIojpno = Trim(dw_insert.GetItemString(k,'iojpno'))
			
			/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
			if not isnull(dw_insert.GetItemString(k, "cndate")) AND 	dw_insert.GetItemString(k, "i_confirm") = 'N' then
			else
				DELETE FROM "IMHIST"  
				 WHERE "IMHIST"."SABU"    = :gs_sabu
					and "IMHIST"."IP_JPNO" = :sIojpno   
					AND "IMHIST"."JNPCRT"  = '045';
			
				IF SQLCA.SQLCODE < 0	THEN
					ROLLBACK;
					f_Rollback();
					RETURN -1
				END IF
			end if
		End If
	NEXT
	
	/* Lot 선택한 내역을 삭제한다 -------------------------- */
	nTot = dw_insert.RowCount()
	For iy = ntot To 1 Step -1
		sIpNo = dw_insert.GetItemString(iy, 'ip_jpno')
		If sIpNo > '' Then
			nFind = dw_insert.Find("iojpno = '"+sipno + "'", 1, dw_insert.RowCount())
			If nFind > 0 Then
				dw_insert.SetItem(nFind, 'ioreqty', dw_insert.GetItemNumber(nFind, 'ioreqty') + dw_insert.GetItemNumber(iy, 'ioreqty'))
				dw_insert.DeleteRow(iy)
			Else
				MessageBox('확인','이전 전표번호를 찾을 수 없습니다')
				Return
			End If
		End If
	Next
	For iy = 1 To dw_insert.RowCount()
		dw_insert.SetItem(iy, 'ioamt',	truncate((dw_insert.getitemnumber(iy, 'ioamt')  /dw_insert.getitemnumber(iy, 'choiceqty'))*dw_insert.getitemnumber(iy,'ioreqty'),0))
		dw_insert.SetItem(iy, 'foramt',	truncate((dw_insert.getitemnumber(iy, 'foramt') /dw_insert.getitemnumber(iy, 'choiceqty'))*dw_insert.getitemnumber(iy,'ioreqty'),2))
		dw_insert.SetItem(iy, 'foruamt',	truncate((dw_insert.getitemnumber(iy, 'foruamt')/dw_insert.getitemnumber(iy, 'choiceqty'))*dw_insert.getitemnumber(iy,'ioreqty'),2))
		dw_insert.SetItem(iy, 'iosuqty',	dw_insert.getitemnumber(iy,'ioreqty'))
		
		// 연구소 샘플,재투입인 경우 lot no를 지우지 않는다
		sIogbn = dw_insert.GetItemString(iy, 'iogbn')
		If sIogbn <> 'O22' And sIogbn <> 'OM3' Then
			dw_insert.SetItem(iy, 'imhist_lotsno',  '.')
		End If
	Next
	/* --------------------------------------------------- */
	
	/* 확인 송장 -> 미확인 송장 */	
	dw_imhist_y.RowsMove(nRow, nRow, Primary!, dw_imhist_n, 9999, Primary!)
   rtncode = dw_imhist_n.GetChild('iogbn', state_child)
	state_child.SetTransObject(sqlca)
	state_child.Retrieve()

	/* 수출일 경우 CI 확정취소 */
	sInvNo = dw_insert.GetItemString(1,"inv_no")
	If Not IsNull(sInvNo) Then
		/* 면장등록 확인 */
		select COUNT(*) into :nCnt
		  from EXPCIH
		 where sabu = :gs_sabu and
				 cino = :sInvNo AND
				 expno is not null;
		If nCnt > 0  Then
			RollBack;
			MessageBox('확 인','면장(계산서)등록된 매출은 출고취소를 할 수 없습니다.!!')
			wf_init()
			Return
		End If

		select COUNT(*) into :nCnt
		  from EXPNEGOD
		 where sabu = :gs_sabu and
				 cino = :sInvNo and
				 datagu = '1';

		If nCnt > 0  Then
			RollBack;
			MessageBox('확 인','Nego된 매출은 출고취소를 할 수 없습니다.!!')
			wf_init()
			Return
		End If

		SaleConfirm = wf_saleconfirm(sInvNo)
		
		/* 실적기준이 출고일 경우만 매출일자 삭제 */
		If SaleConfirm = '2' Then
			UPDATE EXPCIH
				SET OUTCFDT = NULL,
					 SALEDT  = NULL,
					 CISTS	= '3'
			 WHERE SABU = :gs_sabu AND
					 CINO = :sInvNo;
		Else
			UPDATE EXPCIH
				SET OUTCFDT = NULL,
					 CISTS	= '3'
			 WHERE SABU = :gs_sabu AND
					 CINO = :sInvNo ;
		End If
		
		If sqlca.sqlnrows <> 1 Then
			RollBack;
			f_message_chk(57,'매출일자가 존재하거나 관련자료가 없습니다.!!')
			wf_init()
			Return
		End If
	End If
END IF

IF dw_insert.Update(True, False) = 1 THEN 	
	IF dw_imhist_in.Update(True, False) = 1 THEN 	
	Else
	  Rollback;
	  f_message_chk(89,'')
	  wf_init()
	  Return
	End If
Else
  Rollback;
  f_message_chk(89,'')
  wf_init()
  Return
End If

commit;

dw_insert.Reset()
dw_imhist_in.Reset()
dw_insert.ResetUpdate()
dw_imhist_in.ResetUpdate()

sle_msg.text = '자료를 처리하였습니다!!'
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_sal_03000
integer x = 3214
integer y = 2584
integer taborder = 100
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_03000
integer x = 2519
integer y = 2584
integer taborder = 80
boolean enabled = false
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_sal_03000
integer x = 498
integer y = 2564
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_03000
integer x = 2062
integer y = 2572
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_03000
integer x = 119
integer y = 2584
integer taborder = 70
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_03000
integer x = 846
integer y = 2564
integer width = 567
boolean enabled = false
string text = "의뢰서출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_03000
end type

type cb_can from w_inherite`cb_can within w_sal_03000
integer x = 2866
integer y = 2584
integer taborder = 90
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_03000
integer x = 1477
integer y = 2560
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_03000
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_03000
end type

type dw_cond from u_key_enter within w_sal_03000
integer x = 18
integer y = 208
integer width = 1554
integer height = 220
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_030001"
boolean border = false
end type

event itemchanged;string sNull,sOutDate

SetNull(snull)

IF this.GetColumnName() = "out_date" THEN
	sOutDate = Trim(this.GetText())
	IF sOutDate = "" OR IsNull(sOutDate) THEN RETURN
	
	IF f_datechk(sOutDate) = -1 THEN
		f_message_chk(35,'[출고일자]')
		this.SetItem(1,"out_date",snull)
		Return 1
	END IF
END IF

end event

event itemerror;
Return 1
end event

event rbuttondown;//SetNull(Gs_Code)
//SetNull(Gs_CodeName)
//
//IF this.GetColumnName() ="cvpln" THEN
//	Open(w_sawon_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"cvpln",gs_code)
//	this.TriggerEvent(ItemChanged!)
//	Return
//END IF
end event

type rb_1 from radiobutton within w_sal_03000
integer x = 114
integer y = 36
integer width = 215
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
string text = "처리"
boolean checked = true
end type

event clicked;sModStatus = 'I'

Wf_Init()
end event

type rb_2 from radiobutton within w_sal_03000
integer x = 361
integer y = 36
integer width = 219
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
string text = "취소"
end type

event clicked;
sModStatus = 'C'

Wf_Init()
end event

type dw_imhist_n from u_d_popup_sort within w_sal_03000
integer x = 37
integer y = 452
integer width = 2254
integer height = 532
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_030002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;int  nCnt,ix

/* 출고의뢰 */
IF Row <=0 THEN RETURN

IF sModStatus = 'C' THEN RETURN

Selectrow(0,False)
SelectRow(row,True)

/* 수불승인여부 (io_confirm) 제외 */
nCnt = dw_insert.Retrieve(this.GetItemString(row,"sabu"),this.GetItemString(row,"iojpno"))

For ix = 1 To nCnt
	dw_insert.SetItem(ix,'choiceqty',dw_insert.GetItemNumber(ix,'ioreqty'))
Next

end event

type dw_imhist_y from u_d_popup_sort within w_sal_03000
integer x = 2327
integer y = 452
integer width = 2254
integer height = 532
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_030003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;String sCheckNo
Long   nCnt ,ix,nChk=0

IF Row <=0 THEN RETURN

IF sModStatus = 'I' THEN RETURN

Selectrow(0,False)
SelectRow(row,True)
/* 수불승인여부 (io_confirm) 제외 */
nCnt = dw_insert.Retrieve(GetItemString(row,"sabu"),GetItemString(row,"iojpno"))

For ix = 1 To nCnt
	dw_insert.SetItem(ix,'choiceqty',dw_insert.GetItemNumber(ix,'ioqty'))
	
	sCheckNo = dw_insert.GetItemString(ix,'checkno')
	If IsNull(sCheckNo) Or sCheckNo = '' Then
	Else
		nChk += 1
	End If
	
	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N' 가 아닌 경우)*/
	If dw_cond2.GetItemString(1, 'salegu') = '1' Then
		if not isnull(dw_insert.GetItemString(ix, "cndate")) AND dw_insert.GetItemString(ix, "i_confirm") = 'N' then 
			messagebox("확 인", "입고자료가 승인처리 되어 있으므로 삭제 할 수 없습니다." + &
									  '~n' + "입고 자료를 확인하세요!")
			p_mod.Enabled = False
			p_mod.PictureName = 'C:\erpman\image\처리_d.gif'
			return
		end if
	End If
Next

If nChk > 0 Then
	If nChk = nCnt Then
	  MessageBox('확 인','세금계산서가 발행완료된 송장입니다.')
	  p_mod.Enabled = False
	  p_mod.PictureName = 'C:\erpman\image\처리_d.gif'
   Else
     MessageBox('확 인','일부 송장은 세금계산서가 발행완료되어있습니다.')
	  p_mod.Enabled = False
	  p_mod.PictureName = 'C:\erpman\image\처리_d.gif'
	End If
Else
	p_mod.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\처리_up.gif'
End If

end event

type dw_cond2 from datawindow within w_sal_03000
event ue_pressenter pbm_dwnprocessenter
integer x = 1559
integer y = 204
integer width = 3049
integer height = 228
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_030005"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string sfromdate, sNull, stodate, sLocalYn, sSalegu, sSaupj
DataWindowChild state_child
integer rtncode

setnull(sNull)

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		// 창고설정
		f_child_saupj(dw_cond2, 'depot', sSaupj)
		
		//관할 구역
		f_child_saupj(dw_cond2, 'sarea', sSaupj)
		
		//출고 담당자
		rtncode 	= dw_cond.GetChild('cvpln', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('26',sSaupj)
		
		dw_cond.SetItem(1, 'cvpln', snull)
	Case "invoice_fdate"
		sFromDate = Trim(GetText())
	
		IF f_datechk(sFromDate) = -1 THEN
			f_message_chk(35,'[송장일자]')
			SetItem(1,"invoice_fdate",snull)
			Return 1
		END IF
	Case "invoice_tdate"
		sToDate = Trim(GetText())
		
		IF f_datechk(sToDate) = -1 THEN
			f_message_chk(35,'[송장일자]')
			SetItem(1,"invoice_tdate",snull)
			Return 1
		END IF
	Case "salegu"
		sLocalYn = GetItemString(1, 'localyn')
		
		dw_insert.SetRedraw(False)
		If GetText() = '1' Or sLocalYn = 'Y' Then	/* 내수 Or Local 수출 */
			dw_insert.DataObject = 'd_sal_030007'
		Else
			dw_insert.DataObject = 'd_sal_030009'
		End If
		dw_insert.SetTransObject(sqlca)
		
		dw_insert.Modify("ispec_t.text = '" + f_change_name('2') + "'" )
		dw_insert.Modify("jijil_t.text = '" + f_change_name('3') + "'" )
		dw_insert.SetRedraw(True)
	Case "localyn"
		sSalegu = GetItemString(1, 'Salegu')
		
		If sSalegu = '2' Then
			dw_insert.SetRedraw(False)
			If GetText() = 'Y'  Then	/* 내수 Or Local 수출 */
				dw_insert.DataObject = 'd_sal_030007'
			Else
				dw_insert.DataObject = 'd_sal_030009'
			End If
			dw_insert.SetTransObject(sqlca)
			dw_insert.Modify("ispec_t.text = '" + f_change_name('2') + "'" )
			dw_insert.Modify("jijil_t.text = '" + f_change_name('3') + "'" )
			dw_insert.SetRedraw(True)
		End If
END Choose
end event

event itemerror;return 1
end event

type st_2 from statictext within w_sal_03000
integer x = 32
integer y = 164
integer width = 329
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
string text = "[처리조건]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_03000
integer x = 1586
integer y = 164
integer width = 329
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
string text = "[검색조건]"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_sal_03000
integer x = 1445
integer y = 268
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('out_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'out_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_03000
integer x = 2235
integer y = 316
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond2.SetColumn('invoice_fdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond2.SetItem(1, 'invoice_fdate', gs_code)

end event

type pb_3 from u_pb_cal within w_sal_03000
integer x = 2656
integer y = 316
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond2.SetColumn('invoice_tdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond2.SetItem(1, 'invoice_tdate', gs_code)

end event

type dw_lot from datawindow within w_sal_03000
boolean visible = false
integer x = 2030
integer y = 484
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02040_1"
boolean border = false
boolean livescroll = true
end type

type p_bar from uo_picture within w_sal_03000
integer x = 3483
integer y = 40
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\barcode.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

setnull(gs_code)
//gs_code = '1'
//바코드 출력 선택 WINDOW OPEN
//open(w_adt_00370)
end event

type dw_imhist_in from datawindow within w_sal_03000
boolean visible = false
integer x = 2181
integer y = 24
integer width = 686
integer height = 164
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sal_03000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 8
integer width = 645
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_03000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 440
integer width = 2272
integer height = 552
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_03000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2318
integer y = 440
integer width = 2272
integer height = 552
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sal_03000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 1016
integer width = 4571
integer height = 1316
integer cornerheight = 40
integer cornerwidth = 55
end type

