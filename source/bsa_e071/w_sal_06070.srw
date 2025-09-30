$PBExportHeader$w_sal_06070.srw
$PBExportComments$수출면장등록
forward
global type w_sal_06070 from w_inherite
end type
type dw_key from datawindow within w_sal_06070
end type
type gb_4 from groupbox within w_sal_06070
end type
type gb_3 from groupbox within w_sal_06070
end type
type rb_new from radiobutton within w_sal_06070
end type
type rb_upd from radiobutton within w_sal_06070
end type
type dw_saleh from datawindow within w_sal_06070
end type
type ds_print from datawindow within w_sal_06070
end type
type pb_1 from u_pb_cal within w_sal_06070
end type
type pb_2 from u_pb_cal within w_sal_06070
end type
type pb_3 from u_pb_cal within w_sal_06070
end type
type rr_1 from roundrectangle within w_sal_06070
end type
type rr_2 from roundrectangle within w_sal_06070
end type
end forward

global type w_sal_06070 from w_inherite
integer height = 3084
string title = "수출면장등록"
dw_key dw_key
gb_4 gb_4
gb_3 gb_3
rb_new rb_new
rb_upd rb_upd
dw_saleh dw_saleh
ds_print ds_print
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_06070 w_sal_06070

type variables
string is_exvnd,is_exvndnm
end variables

forward prototypes
public function string wf_get_junpyo_no (string pidate)
public function integer wf_select_cino (integer row, string cino)
public function integer wf_select_lcno (integer row, string lcno)
public function integer wf_calc_curr (integer nrow, string sdate, string scurr)
public function integer wf_calc_expamt (double dexpamt)
public function integer wf_update_fob ()
public function string wf_saleconfirm (string sexpgu)
public function integer wf_calc_checkno (string sabu, string sdate)
public subroutine wf_init ()
public function integer wf_create_saleh ()
public subroutine wf_protect_key (boolean gb)
end prototypes

public function string wf_get_junpyo_no (string pidate);String  sOrderNo,sOrderGbn
string  sMaxOrderNo

sOrderGbn = 'X3'     // 채번 

sMaxOrderNo = String(sqlca.fun_junpyo(gs_sabu,pidate,sOrderGbn),'000')

IF double(sMaxOrderNo) <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = pidate + sMaxOrderNo

COMMIT;

Return sOrderNo
end function

public function integer wf_select_cino (integer row, string cino);string s_cino,s_cvcodnm,s_curr,s_expno, sLocalYn, sExpGu, sCists,sCurr, sOutCfdt, sSaledt, SaleConfirm
dec {2} dExpAmt,d_wamt,d_uamt,wrate,urate,weight, dfobamt, dfobamtw
Long   ix,nPos,nRow

SELECT "EXPCIH"."CINO",fun_get_cvnas("EXPCIH"."CVCOD"),"EXPCIH"."EXPNO",
		 "EXPCIH"."EXPAMT","EXPCIH"."CURR","EXPCIH"."WAMT",  "EXPCIH"."UAMT",
		 NVL("EXPCIH"."LOCALYN",'N'), "EXPCIH"."CISTS", "EXPCIH"."CURR", "EXPCIH"."OUTCFDT",
		 "EXPCIH"."WRATE", "EXPCIH"."URATE", "EXPCIH"."FOBAMT", "EXPCIH"."FOBAMTW", "EXPCIH"."SALEDT"
  INTO :s_cino ,:s_cvcodnm, :s_expno,
		 :dExpAmt, :s_curr, :d_wamt, :d_uamt, :sLocalYn, :sCiSts, :sCurr, :sOutCfdt, :wrate, :urate,
		 :dFobamt, :dfobamtw, :sSaledt
  FROM "EXPCIH"
 WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
		 ( "EXPCIH"."CINO" = :cino );

If sqlca.sqlcode <> 0 Then 
   f_message_chk(98,'[C/I NO]')
	Return 1
End If

/* 세금계산서일 경우 Local Invoice만 가능 */
sExpGu = dw_key.GetItemString(1,'expgu')
If sExpgu = '2' And ( sLocalYn = 'N' Or sCiSts = '1' ) Then
	MessageBox('확 인','Local Invoice가 아니거나 출고확정되지 않았습니다!!')
	Return 1
End If

SaleConfirm = wf_SaleConfirm(sExpgu)

/* 면장일 경우 출고확정 자료만 가능 */
If saleconfirm = '1' and ( IsNull(sOutCfdt) Or Trim(sOutCfdt) = '' ) Then
	f_message_chk(33,'[출고확정되지 않은 자료입니다]')
	REturn 1
End If

If Not IsNull(s_expno) and Trim(s_expno) > '' Then
	f_message_chk(97,'[수출면장 번호 : ' + s_expno + ' ]')
	REturn 1
End If

If IsNull(dExpAmt) Or dExpAmt = 0 Then
	f_message_chk(308,'')
	REturn 1
End If

If IsNull(s_cino)    Then s_cino = ''
If IsNull(s_cvcodnm) Then s_cvcodnm = ''
If IsNull(s_curr)    Then s_curr = ''
If IsNull(dExpAmt)   Then dExpAmt = 0.0
If IsNull(d_wamt)    Then d_wamt = 0.0
If IsNull(d_uamt)    Then d_uamt = 0.0

nPos = dw_insert.Find("cino = '" + s_cino + "'", 1, dw_insert.RowCount())
If nPos > 0 Then
	f_message_chk(37,'')
	Return 1
End If

dw_insert.SetItem(row,'sabu',gs_sabu)
dw_insert.SetItem(row,'cino',s_cino)
dw_insert.SetItem(row,'cvcodnm',s_cvcodnm)
dw_insert.SetItem(row,'curr',s_curr)
dw_insert.SetItem(row,'expamt',dExpAmt)
dw_insert.SetItem(row,'fobamt', dfobAmt)
dw_insert.SetItem(row,'fobamtw',dfobAmtw)
dw_insert.SetItem(row,'saledt',sSaledt)

nRow = dw_key.RowCount()
If nRow > 0 Then 
	/* 반품처리시 환율은 매출환율로 계산 */
	If sExpgu = '4' Then
	Else
		wrate = dw_key.GetItemNumber(nRow,'wrate')
		urate = dw_key.GetItemNumber(nRow,'urate')
	End If
	
	Weight = dw_key.GetItemNumber(nRow,'weight')
	If IsNull(wrate) or wrate = 0 Then wrate = 1
	If IsNull(urate) or urate = 0 Then urate = 1
	If IsNull(Weight) or Weight = 0 Then Weight = 1

	/* CI의 원화금액,미화금액이 없을경우 (매출확정전) 면장환율로 계산한다 */
	If IsNull(d_wamt ) or d_wamt = 0 Then
		d_wamt = TrunCate(Round((dExpAmt * wrate)/weight,2),0)
	End If
	
	If IsNull(d_uamt ) or d_uamt = 0 Then
		d_uamt = TrunCate(Round((dExpAmt * urate)/weight,2),2)
	End If
	
	dw_insert.SetItem(row,'wamt',d_wamt)
	dw_insert.SetItem(row,'uamt',d_uamt)
	
	If sExpgu = '4' Then
		dw_key.SetItem(nRow, 'wrate', Wrate)
		dw_key.SetItem(nRow, 'urate', Urate)
		dw_key.SetItem(nRow, 'wamt',  d_wamt)
		dw_key.SetItem(nRow, 'uamt',  d_uamt)
	End If
End If

dw_insert.SetItemStatus(row, 0, Primary!, DataModified!)
dw_insert.SetItemStatus(row, 0, Primary!, NotModified!)

Return 0
end function

public function integer wf_select_lcno (integer row, string lcno);string s_lcno,s_cvcodnm,s_banklcno
dec {2} lcamt
  
  SELECT "EXPLC"."EXPLCNO",   
         "EXPLC"."BANKLCNO",   
         "EXPLC"."LCAMT",
         FUN_GET_CVNAS("EXPLC"."CVCOD" ) AS CVCODNM  
	 INTO :s_lcno, :s_banklcno ,:lcamt,:s_cvcodnm
    FROM "EXPLC"  
   WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
         ( "EXPLC"."EXPLCNO" = :lcno )   ;

dw_key.SetItem(row,'explcno',s_lcno)

If Len(Trim(s_lcno)) <= 0 Or IsNull(s_lcno) Then    REturn 1

Return 0
end function

public function integer wf_calc_curr (integer nrow, string sdate, string scurr);Double    dExpAmt
Dec {2}   wrate
Dec {4}   urate
String    weight

select x.rstan,x.usdrat, y.rfna2
  into :wrate,:urate, :weight
  from ratemt x, reffpf y
 where x.rcurr = y.rfgub(+) and
       y.rfcod = '10' and
       x.rdate = :sdate and
       x.rcurr = :scurr;

If IsNull(weight) Or weight = '' Then weight = '0'
If IsNull(wrate) Or wrate = 0 Then wrate = 0.0
If IsNull(urate) Or wrate = 0 Then urate = 0.0
		 
dw_key.SetItem(nRow,'wrate',wrate)
dw_key.SetItem(nRow,'urate',urate)
dw_key.SetItem(nRow,'weight',Double(weight))

/* 수출금액 */
dExpAmt = dw_key.GetItemNumber(nRow,'expamt')
If IsNull(dExpAmt) Then dExpamt = 0

wf_calc_expamt(dExpamt)

Return 0

end function

public function integer wf_calc_expamt (double dexpamt);/* 수출금액 -> 원화금액,미화금액 */
Long   nRow
Double wrate,urate, weight

nRow = dw_key.RowCount()
If nRow <= 0 Then Return 1

wrate = dw_key.GetItemNumber(nRow,'wrate')
urate = dw_key.GetItemNumber(nRow,'urate')
Weight = dw_key.GetItemNumber(nRow,'weight')
If IsNull(wrate) or wrate = 0 Then wrate = 1
If IsNull(urate) or urate = 0 Then urate = 1
If IsNull(Weight) or Weight = 0 Then Weight = 1

dw_key.SetItem(nRow,'wamt',TrunCate((dExpAmt * wrate)/weight,0))
dw_key.SetItem(nRow,'uamt',TrunCate((dExpAmt * urate)/weight,2))

Return 1
end function

public function integer wf_update_fob ();/* ---------------------------------------------------- */
/* FOB을 CI금액에 따라 배분한다  			              */
/* ---------------------------------------------------- */
Long   ix
Dec {2} dFobamt, dfobamtw, dsumamtd, dsumforamtd,dSumAmtWd,dSumTotAmt, dUamt, dDivRate
Dec {2} dFobAmtWd, dFobAmtd

If dw_key.AcceptText() <> 1 Then Return -1
If dw_insert.AcceptText() <> 1 Then Return -1
If dw_insert.RowCount() <= 0 Then Return 0

dw_key.SetFocus()

/* 배분할 FOB금액 */
dFobAmt  = dw_key.GetItemNumber(1,'fobamt')
dFobAmtW = dw_key.GetItemNumber(1,'fobamtw')

If IsNull(dFobAmt)  Then dFobAmt = 0
If IsNull(dFobAmtW) Then dFobAmtW = 0

dSumAmtd = 0
dSumAmtWd = 0

dSumTotAmt = dw_insert.GetItemNumber(1,'uamt_a')
If IsNull(dSumTotAmt) Or dSumTotAmt = 0 Then Return 0

For ix = 1 To dw_insert.RowCount()
	dUamt = dw_insert.GetItemNumber(ix,'uamt')
	If IsNull(dUamt) or dUamt = 0 Then 
		dFobAmtd  = 0
		dFobAmtWd = 0
	Else
		/* 수출비용 배분율 계산 */
		dDivRate  = dUamt / dSumTotAmt
		
		/*배분된 금액 */
		dFobAmtWd = TrunCate(dFobAmtW * dDivRate,2)	/* 원화 */
		dSumAmtWd += dFobAmtWd
		
		dFobAmtd = TrunCate(dFobAmt * dDivRate,2)/* 미화 */
		dSumAmtd += dFobAmtd
		
		/* 끝전 처리 */
		If ix = dw_insert.RowCount() Then  
			dFobAmtWd += Round( dFobAmtW - dSumAmtWd ,2)
			dFobAmtd  += Round( dFobAmt  - dSumAmtd ,2)
		End If
	End If
	
	dw_insert.SetItem(ix,'fobamt',    dFobAmtd)
	dw_insert.SetItem(ix,'fobamtw',   dFobAmtWd)
Next

Return 0
end function

public function string wf_saleconfirm (string sexpgu);String SaleConfirm

/* --------------------------------------------- */
/* 매출확정일 여부 (1:면장,2:출고,3:b/l,4:임의)  */
/* --------------------------------------------- */
If sExpgu = '2' Then	/* Local일 경우 */
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

If IsNull(SaleConfirm) Or SaleConfirm = '' Then SaleConfirm = '2'

Return SaleConfirm
end function

public function integer wf_calc_checkno (string sabu, string sdate);integer	nMAXNO

SELECT NVL(seqno, 0)
  INTO :nMAXNO
  FROM checkno
 WHERE ( sabu = :gs_sabu ) AND
		 ( base_yymm = :sdate ) for update;
		
Choose Case sqlca.sqlcode 
  Case is < 0 
			return -1
  Case 100 
    nMAXNO = 1

    INSERT INTO checkno ( sabu,base_yymm, seqno )
        VALUES ( :gs_sabu, :sDate, :nMaxNo ) ;  
  Case 0
	 nMAXNO = nMAXNO + 1

	 UPDATE checkno
   	 SET seqno = :nMAXNO
	  WHERE ( sabu = :gs_sabu ) AND
			  ( base_yymm = :sDate );
END Choose

If sqlca.sqlcode <> 0 Then	Return -1

RETURN nMAXNO
end function

public subroutine wf_init ();rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)      // 신규입력받을 수 있도록 상태 변환
dw_key.SetFocus()

dw_key.SetItem(1,'expdt', is_today)
dw_key.SetColumn('expdt')
dw_key.Modify("expgu.protect = 0")
dw_key.Modify("cvcod.protect = 0")


p_del.Enabled = True
p_mod.Enabled = True
p_ins.Enabled = True
//p_print.Enabled = True
p_search.Enabled = True

p_del.PictureName = "C:\erpman\image\삭제_up.gif"
p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
//p_print.PictureName = "C:\erpman\image\계산서발행_up.gif"
p_search.PictureName = "C:\erpman\image\면장삭제_up.gif"

ib_any_typing = False

end subroutine

public function integer wf_create_saleh ();/* 세금계산서를 발행 한다 */
Long    nRow,iMaxSaleNo,iMaxCheckNo,nRowCnt,ix,iy,nCnt, nTotal
string  sCvcod,sPum,sFrdate, sIspec, sCino, sExpNo
double  dGonAmt,dVatAmt,dIoPrc,dIoqty,dSum_GonAmt,dSum_vatamt
string  sCustName, sCustSano, sCustUpTae, sCustUpjong, sCustOwner
String  sTaxGu, sCustResident, sCustAddr, sCustGbn  ,sSkipCust, sExpLcNo
String  sCheckNo, sSaupj, SaleConfirm, sExpgu

sle_msg.Text = ''

If dw_key.AcceptText() <> 1 Then Return -1
							 
sFrdate = dw_key.GetItemString(1,'exppmtdt')
sCvcod  = dw_key.GetItemString(1,'cvcod')
sExpgu  = dw_key.GetItemString(1,'expgu')

IF MessageBox("확  인","세금계산서가 발행됩니다." +"~n~n" +&
                       "발행 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

SetPointer(HourGlass!)

/* Local일 경우 */
SaleConfirm = wf_SaleConfirm('2')

//p_print.Enabled = False
//p_print.PictureName = "C:\erpman\image\계산서발행_d.gif"

/* Agent 정보 확인 */
SELECT "VNDMST"."CVNAS",         "VNDMST"."SANO", 		 		"VNDMST"."UPTAE",   
		 "VNDMST"."JONGK",  		   "VNDMST"."OWNAM",				"VNDMST"."RESIDENT",   
		 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' '),"VNDMST"."CVGU",
		 "VNDMST"."TAX_GU"
  INTO :sCustName,   			  :sCustSano,   					:sCustUpTae,
		 :sCustUpjong,   			  :sCustOwner,   					:sCustResident,
		 :sCustAddr,   													:sCustGbn,
		 :sTaxGu
  FROM "VNDMST"  
 WHERE "VNDMST"."CVCOD" = :sCvcod;

w_mdi_frame.sle_msg.Text = sCustName + ' 처리중...'
	
/* 세금계산서의 거래처정보 미등록시 제외 */
If ( IsNull(sCustSano) or Trim(sCustSano) = '' ) and & 
	( IsNull(sCustResident) or Trim(sCustResident) = '' ) Then
	
	sSkipCust += ('['+sCvcod+': ' + Trim(sCustName) + ']' + '~r~n' )

	MessageBox('거래처정보 미비로 발행되지 않은 거래처입니다', &
	           sSkipCust+'~r~n ')
	
	Return -1
End If

/* 거래처명,업태,업종,주소 */
If ( IsNull(sCustName)   or Trim(sCustName)   = '' )   Or &
	( IsNull(sCustUpTae)  or Trim(sCustUpTae)  = ''  )  Or &
	( IsNull(sCustUpjong) or Trim(sCustUpjong) = ''  )  Or &
	( IsNull(sCustAddr)   or Trim(sCustAddr)   = ''  )  Then 
	
	sSkipCust += ('['+sCvcod+': ' + Trim(sCustName) + ']' + '~r~n')
	
	MessageBox('거래처정보 미비로 발행되지 않은 거래처입니다', &
	           sSkipCust+'~r~n ')
	
	Return -1
End If
	
/* 전표번호 채번 */
iMaxSaleNo = sqlca.fun_junpyo(gs_sabu,sFrdate,'G0')
IF iMaxSaleNo <= 0 THEN
	f_message_chk(51,'')
	rollback;
	Return 1
END IF
commit;

/* 계산서 일련번호 채번 */
iMaxCheckNo = wf_calc_checkno(gs_sabu, Left(sFrDate,6))
IF iMaxCheckNo <= 0 Or iMaxCheckNo > 9999 THEN
	f_message_chk(51,'일련번호')
	rollback;
	Return 1
END IF
commit;

nRow = dw_saleh.InsertRow(0)
dw_saleh.SetItem(nRow,"sabu",     gs_sabu)
dw_saleh.SetItem(nRow,"saledt",   sFrDate)
dw_saleh.SetItem(nRow,"saleno",   iMaxSaleNo)

/* 계산서 권번 */
sCheckNo = Left(sFrdate,6)+ Trim(String(iMaxCheckNo,'0000'))
dw_saleh.SetItem(nrow,"checkno",  sCheckNo )
dw_saleh.SetItem(nRow,'cvcod',    sCvcod)
dw_saleh.SetItem(nRow,"sano",     sCustSano)
dw_saleh.SetItem(nRow,"cvnas",    sCustName)
dw_saleh.SetItem(nRow,"ownam",    sCustOwner)
dw_saleh.SetItem(nRow,"resident", sCustresident)
dw_saleh.SetItem(nRow,"uptae",    sCustUptae)
dw_saleh.SetItem(nRow,"jongk",    sCustUpjong)
dw_saleh.SetItem(nRow,"addr1",    sCustAddr)
dw_saleh.SetItem(nRow,'autobal_yn','M') /* 자동발행 여부 */

dw_saleh.SetItem(nRow,'tax_no','23') /* 영세율 세금계산서 */
dw_saleh.SetItem(nRow,'expgu','2')   /* 수출 */

sExpLcNo  = dw_key.GetItemString(1,'explcno')
dw_saleh.SetItem(nRow,'lcno',sExpLcNo)

dw_saleh.SetItem(nRow,'for_amt',  dw_key.GetItemNumber(1,'expamt')) /* 수출금액 */
dw_saleh.SetItem(nRow,'exchrate', dw_key.GetItemNumber(1,'wrate'))  /* 적용환율 */

dGonAmt = dw_key.GetItemNumber(1,'wamt') /* 공급가액 */
dVatAmt = 0 /* 부가세액 */

/* 품목 */
sCino = dw_insert.GetItemString(1,'cino')
sSaupj = dw_insert.GetItemString(1,'saupj')

SELECT FUN_GET_ITNCT(Y.ITTYP, SUBSTR(Y.ITCLS,1,2)) INTO :sPum
  FROM EXPCID X, ITEMAS Y
 WHERE X.ITNBR = Y.ITNBR AND
 		 X.SABU = :gs_sabu AND
		 X.CINO = :sCino AND
		 ROWNUM = 1;
		 
nTotal = 0
For ix = 1 To dw_insert.RowCount()
	sCino = dw_insert.GetItemString(ix,'cino')
	
	SELECT COUNT(*) INTO :nCnt FROM EXPCID
	 WHERE SABU = :gs_sabu AND
	 		 CINO = :sCino;
	If IsNull(nCnt) Then nCnt = 0
	
	nTotal += nCnt
	
	/* 계산서 권번을 C/I HEADER 저장 */
	dw_insert.SetItem(ix, 'checkno', sCheckNo)
	If SaleConfirm = '1' and sExpgu <> '4' Then	/* 반품계산서는 제외 */
		dw_insert.SetItem(ix, 'saledt', sFrDate)
	End If
Next

sPum    += ( ' 외 ' + string(nTotal - 1) )

dw_saleh.SetItem(nRow,'saupj',  sSaupj)
dw_saleh.SetItem(nRow,'gon_amt',dGonAmt)
dw_saleh.SetItem(nRow,'vat_amt',dVatAmt)
			
dw_saleh.SetItem(nRow,'mmdd1',Mid(sFrdate,5))
dw_saleh.Setitem(nRow,'pum1',sPum)
dw_saleh.SetItem(nRow,'gonamt1',dGonAmt)
dw_saleh.SetItem(nRow,'vatamt1',dVatAmt)

dw_saleh.SetItem(nRow,'chysgu','0')     /* 청구 */

dw_saleh.SetItem(nRow,'salegu','1')     /* 일반계산서 */

/* 세금계산서 저장 */
IF dw_saleh.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF

/* 세금계산서 번호 저장 */
IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF

COMMIT;

IF MessageBox("확  인","세금계산서를 출력하시겠습니까?" ,Question!, YesNo!, 2) = 2 THEN RETURN 0
							  
/* 출력 */
If ds_print.Retrieve(gs_sabu, sFrDate,iMaxSaleNo, sSaupj) > 0 Then
	gi_page = ds_print.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, ds_print)
Else
	f_message_chk(300,'')
	Return -1
End If
	
f_message_chk(202,'')
sle_msg.Text = '세금계산서 발행완료 되었습니다.!!'

Return 0
end function

public subroutine wf_protect_key (boolean gb);dw_key.SetRedraw(False)

If gb = True then       // protect 설정
   dw_key.Modify('expno.protect = 0')         // 수정일 경우
Else
   dw_key.Modify('expno.protect = 1')        // 신규일 경우
End If

dw_key.Modify('expgu.protect = 0')

dw_key.SetRedraw(True)

end subroutine

on w_sal_06070.create
int iCurrent
call super::create
this.dw_key=create dw_key
this.gb_4=create gb_4
this.gb_3=create gb_3
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.dw_saleh=create dw_saleh
this.ds_print=create ds_print
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_key
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.rb_new
this.Control[iCurrent+5]=this.rb_upd
this.Control[iCurrent+6]=this.dw_saleh
this.Control[iCurrent+7]=this.ds_print
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
end on

on w_sal_06070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_key)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.dw_saleh)
destroy(this.ds_print)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_key.SetTransObject(sqlca)
dw_key.InsertRow(0)

dw_insert.SetTransObject(sqlca)
dw_saleh.SetTransObject(sqlca)
ds_print.SetTransObject(sqlca)

/* Default 수출자 */
select x.rfna2 ,y.cvnas2 into :is_exvnd , :is_exvndnm
  from reffpf x, vndmst y
 where x.rfcod = 'AD' and
       x.rfgub = :gs_sabu and
		 x.rfna2 = y.cvcod;

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_sal_06070
integer x = 37
integer y = 1140
integer width = 4549
integer height = 1184
integer taborder = 20
string dataobject = "d_sal_06070_h"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;String sData, sExpgu
Long   nRow
Int    rtn, ix

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName()
	Case 'cino'
		/* 수출구분이 세금계산서일 경우 local Invoice만 가져온다 */
		sExpgu = dw_key.GetItemString(1,'expgu')
		If sExpgu = '2' Then
			gs_code  = 'Y' // Local
			gs_gubun = 'A' // 매출확정
		/* 수출반품 */
		ElseIf sExpgu = '4' Then
			gs_code = 'RETURNS'
			gs_gubun = 'N'	/* 확정여부 */
		Else
			gs_code  = 'N' // Direct
			gs_gubun = 'A' // 매출여부
		End If
		
		Open(w_expci_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1
		
		RETURN wf_select_cino(nRow,gs_code)
End Choose

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sData
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName()
	Case 'cino'
      sData = Trim(GetText())
		If IsNull(sData) Or sData = '' Then Return 1
		
		Return wf_select_cino(nrow,sData)
End Choose

end event

event dw_insert::editchanged;ib_any_typing =True
end event

type p_delrow from w_inherite`p_delrow within w_sal_06070
integer x = 2629
integer y = 2600
end type

type p_addrow from w_inherite`p_addrow within w_sal_06070
integer x = 2240
integer y = 2592
end type

type p_search from w_inherite`p_search within w_sal_06070
integer x = 3895
integer y = 12
string picturename = "C:\erpman\image\면장삭제_up.gif"
end type

event p_search::clicked;call super::clicked;string s_expno, sExpgu, sNull, SaleConfirm
int    nRow,ix

nRow  = dw_key.GetRow()
If nRow <=0 Then Return

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

s_expno = Trim(dw_key.GetItemString(nRow,'expno'))
If IsNull(s_expno) Or s_expno = '' Then Return

/* 수출구분 */
sExpgu = dw_key.GetItemString(nrow,'expgu')

IF MessageBox("삭 제",s_expno + "의 모든 자료가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
dw_key.DeleteRow(0)
If dw_key.Update() <> 1 Then 
	RollBack ;
	Return
End If

SetNull(sNull)

/* --------------------------------------------- */
/* 매출확정일 여부 (1:면장,2:출고,3:b/l,4:임의)  */
/* --------------------------------------------- */
SaleConfirm = wf_SaleConfirm(sExpgu)

nRow = dw_insert.RowCount()
If nRow > 0 Then 
   For ix = 1 To nRow
		dw_insert.SetItem(ix, 'expno',  sNull)
		dw_insert.SetItem(ix, 'fobamt',  0)
		dw_insert.SetItem(ix, 'fobamtw', 0)
		
		Choose Case sExpgu 
			Case '2'
				continue
			Case '4'
				dw_insert.SetItem(ix, 'saledt', sNull)
			Case	Else
				If SaleConfirm = '1' Then
					dw_insert.SetItem(ix, 'saledt', sNull)
				End If				
		End Choose
	Next
	
	If dw_insert.Update() <> 1 Then
		Rollback;
		f_message_chk(32,'[마감년월을 확인하세요]')
		wf_init()
		Return
	End If
End IF

COMMIT;

sle_msg.text ='자료를 삭제하였습니다!!'

wf_init()
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\면장삭제_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\면장삭제_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06070
integer x = 3547
integer y = 12
end type

event p_ins::clicked;call super::clicked;Long   nRow
string s_cino,s_expdt, sExpgu, sCvcod

If dw_key.AcceptText() <> 1 then Return
If dw_insert.AcceptText() <> 1 then Return

nRow = dw_insert.RowCount()
If nRow > 0 Then
  s_cino = Trim(dw_insert.GetItemString(nRow,'cino'))

  If IsNull(s_cino) Or s_cino = '' Then
     f_message_chk(1400,'[C/I No.]')
	  dw_insert.Setfocus()
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('cino')
     Return
  End If
End If

dw_key.Setfocus()
dw_key.SetRow(1)
s_expdt = dw_key.GetItemString(1,'expdt')
If IsNull(s_expdt) Or s_expdt = '' Then
	f_message_chk(40,'[일자]')
	dw_key.SetColumn('expdt')
	Return
End If

sExpgu = dw_key.GetItemString(1,'expgu')
If IsNull(s_expdt) Or s_expdt = '' Then
	f_message_chk(40,'[수출구분]')
	dw_key.SetColumn('expgu')
	Return
End If

sCvcod = dw_key.GetItemString(1,'cvcod')
If IsNull(sCvcod) Or sCvcod = '' Then
	f_message_chk(40,'[Buyer]')
	dw_key.SetColumn('cvcod')
	Return
End If

/* 수출구분 변경 불가 */
dw_key.Modify("expgu.protect = 1")
dw_key.Modify("cvcod.protect = 1")

/* 수출반품은 1건만 입력가능 */
If sExpgu = '4' And dw_insert.RowCount() > 0 Then
	MessageBox('확 인','계산서/반품은 Invoice 1건만 등록가능합니다.')
	Return
End IF

nRow = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetRow(nRow)
dw_insert.SetColumn('cino')

end event

type p_exit from w_inherite`p_exit within w_sal_06070
integer x = 4416
integer y = 12
end type

type p_can from w_inherite`p_can within w_sal_06070
integer x = 4242
integer y = 12
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_sal_06070
boolean visible = false
integer x = 2766
integer y = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\계산서발행_up.gif"
end type

event p_print::clicked;call super::clicked;String sExpGu, sCheckNo, sCino, sSaleConfirm, picnm
Long	 ix

/* 수출구분 */
sExpgu = Trim(dw_key.GetItemString(1,'expgu'))
picnm  = This.PictureName
If picnm = 'C:\erpman\image\계산서발행_up.gif' Then
	/* 영세율/수출반품일 경우 계산서 발행 */
	If sExpgu = '2' Or sExpgu = '4' Then
		If wf_create_saleh() <> 0 Then
			MessageBox('확 인','계산서 발행에 실패하였습니다!!')
			wf_init()
			Return
		End If
	Else
		MessageBox('확 인','LOCAL수출만 계산서 발행이 가능합니다.!!')
	End If
Else
	SetPointer(HourGlass!)
	
	If dw_insert.RowCount() > 0 Then
		/* 계산서 취소일 경우 */
		sCheckNo = dw_insert.GetItemString(1,'checkno')
		
		/* 계산서 삭제 */
		DELETE FROM "SALEH"
		 WHERE ( "SALEH"."SABU" = :gs_sabu ) AND  
				 ( "SALEH"."CHECKNO" = :sCheckNo ) AND
				 ( "SALEH"."BAL_DATE" is null );
	
		If sqlca.sqlcode <> 0 Then
			RollBack;
			MessageBox('오류','[SALEH Delete Error: checkno] '+ sCheckNo)
			Return
		End If
		
		/* CI UPDATE */
		sSaleConfirm = wf_SaleConfirm('2')
		
		For ix = 1 To dw_insert.RowCount()
			sCino = dw_insert.GetItemString(ix, 'cino')
			/* Local이면서 계산서 기준일 경우 매출 확정, 단 반품인 경우는 제외 */
			If sSaleConfirm = '1' and sExpgu <> '4' Then
				update expcih a
					set a.checkno = NULL,
					    a.saledt = NULL
				 where a.sabu = :gs_sabu and
						 a.cino = :sCino;
			Else
				update expcih a
					set a.checkno = NULL
				 where a.sabu = :gs_sabu and
						 a.cino = :sCino;
			End If
			If sqlca.sqlcode <> 0 Then
				RollBack;
				MessageBox('오류','[EXPCIH UPDATE Error: cino] '+ sCino)
				Return
			End If	
		Next
		
		COMMIT;
		This.PictureName = 'C:\erpman\image\계산서발행_up.gif'
	End If
End If

//p_inq.TriggerEvent(Clicked!)
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\계산서발행_up.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\계산서발행_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_06070
integer x = 3374
integer y = 12
end type

event p_inq::clicked;call super::clicked;string s_expno, sExpgu, sCheckNo, sCino
Long   nRow, ix, nCntExp

If rb_new.Checked = True Then Return  //신규이면 조회불가

If dw_key.AcceptText() <> 1 Then Return

nRow  = dw_key.RowCount()
If nRow <=0 Then Return
	  
s_expno = Trim(dw_key.GetItemString(nRow,'expno'))
If IsNull(s_expno) Or s_expno = '' Then
   f_message_chk(1400,' 수출번호')
	Return 1
End If

If dw_key.Retrieve(gs_sabu,s_expno) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
	rb_upd.TriggerEvent(Clicked!)
	return
End If

dw_insert.Retrieve(gs_sabu,s_expno)

/* 계산서일 경우 건별 삭제 불가 */
sExpgu = Trim(dw_key.GetItemString(nRow,'expgu'))

SetNull(sCheckNo)
For ix = 1 To dw_insert.RowCount()
	sCheckNo = dw_insert.GetItemString(ix,'checkno')
	If Not IsNull(sCheckNo) Then Exit
Next

/* 세금계산서 일 경우 */
If sExpGu = '2' Or sExpGu = '4' Then
	If Not IsNull(sCheckNo) Then
		p_search.Enabled = False
		p_mod.Enabled = False
		p_del.Enabled = False
		
		/* 수출일 경우 수출매출 Interface 확인 */
		SELECT COUNT(*) INTO :nCntExp
		  FROM KIF05OT0
		 WHERE CINO IN ( 	SELECT CINO
								  FROM EXPCIH
								 WHERE CHECKNO = :sCheckNo );

//		p_print.Text = '계산서취소(&P)'

		If nCntExp > 0 Then
			p_print.Enabled = False
		Else

			p_print.Enabled = True
		End If
	Else
		p_search.Enabled = True
		p_mod.Enabled = True
		p_del.Enabled = True
		p_print.Enabled = True
	End If
Else
	/* 회계전송된 자료가 있으면 저장,삭제 불가 */
	For ix = 1 To dw_insert.RowCount()
		sCino = dw_insert.GetItemString(ix, 'kif05ot0_cino')
		If Not IsNull(sCino) Then
			p_mod.Enabled = False
			p_ins.Enabled = False
			p_del.Enabled = False
			p_search.Enabled = False
			p_print.Enabled = False
			
			sle_msg.Text = '회계전송처리된 자료입니다.!!'
			Exit
		End if
	Next
End If

wf_protect_key(false)

/* 수출구분 변경 불가 */
dw_key.Modify('expgu.protect = 1')

dw_key.SetRedraw(True)

ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_sal_06070
integer x = 4069
integer y = 12
end type

event p_del::clicked;call super::clicked;string s_cino,s_expno, sExpgu, snull, SaleConfirm
int    nRow

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

SetNull(sNull)

s_expno = Trim((dw_key.GetItemString(1,'expno')))
s_cino  = Trim((dw_insert.GetItemString(nRow,'cino')))
If IsNull(s_cino) Or s_cino = '' Then 
	dw_insert.Deleterow(nrow)
	return
End If
	
IF MessageBox("삭 제","CI No. " + s_cino + "의  자료가 삭제됩니다." +"~n~n" +&
           	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN


/* 수출구분 */
sExpgu = dw_key.GetItemString(1,'expgu')

/* 매출 확정일 */
SaleConfirm = wf_SaleConfirm(sExpgu)

dw_insert.SetItem(nRow, 'expno'  , sNull)
dw_insert.SetItem(nRow, 'fobamt' , 0)
dw_insert.SetItem(nRow, 'fobamtw', 0)

If SaleConfirm = '1' Or sExpgu = '4' Then
	dw_insert.SetItem(nRow, 'saledt'  , sNull)
End If

If dw_insert.Update() <> 1 Then
	Rollback;
	f_message_chk(32,'[EXPCIH]')
	wf_init()
	Return
End If

COMMIT;

dw_insert.Retrieve(gs_sabu,s_expno)

sle_msg.text ='자료를 삭제하였습니다!!'
end event

type p_mod from w_inherite`p_mod within w_sal_06070
integer x = 3721
integer y = 12
end type

event p_mod::clicked;call super::clicked;string s_expno,s_cino, sExpdt, sExppmtdt, sCurr, sExpgu, SaleConfirm, sexppmtno 
Long   nRow,ix,i_piseq
Double dWrate, dUrate
Dec {2} dExpamt, dExpamtA

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* -------------------- */
/* 수출면장 헤더 저장   */
/* -------------------- */
nRow  = dw_key.GetRow()
If nRow <=0 Then Return

/* 수출구분 */
sExpgu = dw_key.GetItemString(nrow,'expgu')
If IsNull(sExpgu) Or sExpgu = '' Then
	f_message_chk(57,'[수출구분]')
	dw_key.SetFocus()
	dw_key.SetColumn('expgu')
	Return
End If

/* 수출면장번호 - 수출면장 구분이 면장일때만 필수 */
sexppmtno = dw_key.GetItemString(nrow,'exppmtno')
If IsNull(sExppmtno) Or sExpgu = '' Then
	f_message_chk(40,'[수출면장]')
	dw_key.SetFocus()
	dw_key.SetColumn('exppmtno')
	Return
End If

dw_key.SetFocus()

/* 일자 확인 */
sExpdt = dw_key.GetItemString(nrow,'expdt')
If f_datechk(sExpdt) <> 1 Then
	f_message_chk(40,'[수출일자]')
	dw_key.SetColumn('expdt')
	Return
End If

/* 통화단위 */
sCurr = Trim(dw_key.GetItemString(nrow,'curr'))
If IsNull(sCurr) or sCurr = '' Then
	f_message_chk(40,'[통화단위]')
	dw_key.SetColumn('curr')
	Return
End If

/* 원화환율 */
dWrate = dw_key.GetItemNumber(1,'wrate')
If IsNull(dWrate) or dWrate = 0 Then
	f_message_chk(40,'[원화환율]')
	dw_key.SetColumn('wrate')
	Return
End If

/* 미화환율 */
dUrate = dw_key.GetItemNumber(1,'urate')
If IsNull(dUrate) or dUrate = 0 Then
	f_message_chk(40,'[미화환율]')
	dw_key.SetColumn('urate')
	Return
End If

/* 면장금액 check */
dExpamt = dw_key.GetItemNumber(1,'expamt')
If IsNull(dExpamt) Then dExpamt = 0

If dw_insert.RowCount() > 0 Then
	dExpamtA = dw_insert.GetItemNumber(1,'expamt_a')
	If IsNull(dExpamtA) Then dExpamtA = 0
End If

// 고산화학 : 2002.05.08
//If dExpAmt <> dExpAmtA Then
//	MessageBox('확 인','면장금액과 송장금액이 서로 틀립니다')
//	dw_key.SetColumn('expamt')
//	Return
//End if
	
For ix = 1 To dw_insert.RowCount()
	If sCurr <> dw_insert.GetItemString(ix,'curr') Then
		MessageBox('확 인','통화단위가 서로 틀립니다')
		dw_insert.ScrollToRow(ix)
		Return
	End if
Next

SetPointer(HourGlass!)

/* 실적이 면장기준일 경우 면장 */
sExppmtdt = Trim(dw_key.GetItemString(1,'exppmtdt'))

/* 매출 확정일 */
SaleConfirm = wf_SaleConfirm(sExpgu)

If SaleConfirm = '1' Then
	If f_datechk(sExppmtdt) <> 1 Then 
		f_message_chk(57,'[수출면장일자]')
		dw_key.SetFocus()
		dw_key.SetColumn('exppmtdt')
		Return
	End If
End If

/* 전표번호 채번 */
If rb_new.Checked = True  Then
   s_expno = wf_get_junpyo_no(sExpdt)
   dw_key.SetItem(nRow,'sabu',gs_sabu)
   dw_key.SetItem(nRow,'expno',s_expno)
Else
   s_expno = Trim(dw_key.GetItemString(nRow,'expno'))	
End If

If IsNull(s_expno) Or s_expno = '' Then
	f_message_chk(57,'[수출면장번호]')
	dw_key.SetFocus()
	dw_key.SetColumn('expno')
	Return
End If

wf_protect_key(false)

rb_upd.Checked = True

/* -------------------- */
/* C.Invoice header저장 */
/* -------------------- */
nRow  = dw_insert.RowCount()
For ix = 1 To nRow
	s_cino  = Trim(dw_insert.GetItemString(ix,'cino'))
	If s_cino = '' Or IsNull(s_cino) Then
		f_message_chk(40,'['+ string(ix) + ' C/I NO 입력]')
      dw_insert.SetFocus()
		dw_insert.SetRow(ix)
		dw_insert.SetColumn('cino')
		Return 
	End If

	Choose Case sExpgu 
		Case '2'	/* Local */
			dw_insert.SetItem(ix, 'expno',  s_expno)
		Case '4'	/* 반품 */
			dw_insert.SetItem(ix, 'expno',  s_expno)
			dw_insert.SetItem(ix, 'saledt', sExppmtdt)
			dw_insert.SetItem(ix, 'shipdat', sExppmtdt)
		Case Else
			If SaleConfirm = '1' Then
				dw_insert.SetItem(ix, 'expno',  s_expno)
				dw_insert.SetItem(ix, 'saledt', sExppmtdt)
			Else
				dw_insert.SetItem(ix, 'expno',  s_expno)
			End If
	End Choose
Next

IF dw_key.Update() <> 1 THEN
   ROLLBACK;
	f_message_chk(32,sqlca.sqlerrtext)
   Return
END IF

/* CI에 fob실적 배분 */
If wf_update_fob() <> 0 Then
	rollback;
	f_message_chk(32,sqlca.sqlerrtext)
	Return
End If

/* FOB실적 저장 */
IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	f_message_chk(32,sqlca.sqlerrtext)
	Return -1
END IF

COMMIT;

/* 저장후 조회 */
rb_upd.Checked = True
p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_06070
integer x = 3104
integer y = 2860
integer taborder = 120
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_06070
integer x = 1605
integer y = 2860
integer taborder = 50
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_06070
integer x = 462
integer y = 2860
integer width = 361
integer taborder = 40
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06070
integer x = 2400
integer y = 2860
integer taborder = 70
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06070
integer x = 101
integer y = 2860
integer taborder = 30
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_06070
integer x = 850
integer y = 2860
integer width = 517
integer taborder = 80
boolean enabled = false
string text = "계산서발행(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_06070
end type

type cb_can from w_inherite`cb_can within w_sal_06070
integer x = 2752
integer y = 2860
integer taborder = 90
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_06070
integer x = 1957
integer y = 2860
integer width = 425
integer taborder = 60
boolean enabled = false
string text = "면장삭제(&W)"
end type





type gb_10 from w_inherite`gb_10 within w_sal_06070
integer y = 2784
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06070
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06070
end type

type dw_key from datawindow within w_sal_06070
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 18
integer y = 176
integer width = 4608
integer height = 944
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06070"
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

event itemchanged;String sDate, sNull, sExpno, sExpGu, sCurr
Long   nRow,nCnt
Double dExpAmt, dWamt, dUamt, wrate,urate,Weight
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

If rb_new.Checked <> True And rb_upd.Checked <> True Then
	f_message_chk(57,'[작업구분 선택]')
	Return 2
End If

SetNull(sNull)
nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'expno'
	  sExpno = Trim(GetText())
	  IF sExpno = "" OR IsNull(sExpno) THEN RETURN

     SELECT COUNT(*)
       INTO :nCnt  
       FROM "EXPORT"
      WHERE ( "EXPORT"."SABU" = :gs_sabu ) AND  
            ( "EXPORT"."EXPNO" = :sExpno );
		
	  IF nCnt <=0 THEN
		 f_message_chk(33,'[수출면장번호]')
       SetItem(nRow,'expno',sNull)
		 Return 1
	  ELSE
		 p_inq.TriggerEvent(Clicked!)
	  END If
	/* 접수일자 */
	Case 'expdt'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      SetItem(nRow,'expdt',sNull)
	    Return 1
    END IF

	/* 수출구분 */
   Case 'expgu'
		sExpGu = Trim(GetText())
		
		/* 수출면장일 경우 수출자 입력 */
		If sExpGu = '1' Then
			SetItem(nRow,'exvnd',is_ExVnd)
			SetItem(nRow,'exvndnm',is_ExVndnm)
		Else
			SetItem(nRow,'exvnd',sNull)
			SetItem(nRow,'exvndnm',sNull)
		End If
		
		/* 계산서일경우 */
		If sExpgu = '2' Then
			Modify("exppmtdt_t.text = '계산서일자'")
		ElseIf sExpgu = '4' Then
			Modify("exppmtdt_t.text = '반품일자'")
		Else
			Modify("exppmtdt_t.text = '면장일자'")
		End If
	/* Buyer */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
//			SetItem(1,"saupj",   	ssaupj)
//			SetItem(1,"deptcode",   steam)
//			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	Case 'exvnd','shvnd','gwvnd'  // 거래처
   	select fun_get_cvnas(:data) into :scvnas from dual;
		If Trim(scvnas) = '' Then 
			SetNull(scvnas)
			This.SetItem(1,GetColumnName(), scvnas)
			This.SetItem(1,GetColumnName()+'nm', scvnas)
			Return 2
		Else	
	      This.SetItem(1,GetColumnName()+'nm', scvnas)
      End If
/* 면장일자 */
	Case 'exppmtdt'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
			SetItem(nRow,'exppmtdt',sNull)
      	setcolumn(GetColumnName())
	    Return 1
    END IF
		
    /* 환율 */
    sCurr = Trim(GetItemString(1,'curr'))
	 wf_calc_curr(nRow,sDate,sCurr)
/* 통화단위 */
  Case 'curr'
		sCurr = Trim(GetText())
		
		sDate = Trim(GetItemString(nRow,'exppmtdt'))
		wf_calc_curr(nRow,sDate,sCurr)
		
/* LC접수번호 */
	Case 'explcno'
		gs_code = Trim(GetText())
   	If wf_select_lcno(nRow,gs_code) = 1 Then
			f_message_chk(33,'')
			return 1
		End If
/* 수출금액 */
	Case 'expamt'
		dExpAmt = Double(GetText())
		If IsNull(dExpAmt) or dExpamt = 0 Then
			SetItem(nRow,'wamt',0)
			SetItem(nRow,'uamt',0)
		End If
		
      wf_calc_expamt(dExpAmt)
/* 원화금액 => 원화환율 */
   Case 'wamt'
		dWamt = Double(GetText())
		dExpamt = GetItemNumber(nRow,'expamt')
		Weight = GetItemNumber(nRow,'weight')
		If IsNull(weight) or weight = 0 Then weight = 1
		
		If Not IsNull(dExpamt) and dExpamt <> 0 Then
		  wrate = Round(( dWamt * Weight ) / dExpamt,2)
	   Else
		  wrate = 0
	   End If
		
		SetItem(nRow,'wrate',wrate)
/* 미화금액 => 미화환율 */
   Case 'uamt'
		dUamt = Double(GetText())
		dExpamt = GetItemNumber(nRow,'expamt')
		Weight = GetItemNumber(nRow,'weight')
		If IsNull(weight) or weight = 0 Then weight = 1
		
		If Not IsNull(dExpamt) and dExpamt <> 0 Then
		  urate = Round(( dUamt * Weight ) / dExpamt,4)
	   Else
		  urate = 0
	   End If
		
		SetItem(nRow,'urate',urate)
/* 원화환율 => 원화금액 */
   Case 'wrate'
		wrate = Double(GetText())
		dExpamt = GetItemNumber(nRow,'expamt')
		Weight = GetItemNumber(nRow,'weight')
		If IsNull(weight) or weight = 0 Then weight = 1
		
		dWamt = TrunCate((dExpAmt * wrate)/weight,0)
		
		SetItem(nRow,'wamt',dWamt)
/* 미화환율 => 미화금액 */
   Case 'urate'
		urate = Double(GetText())
		dExpamt = GetItemNumber(nRow,'expamt')
		Weight = GetItemNumber(nRow,'weight')
		If IsNull(weight) or weight = 0 Then weight = 1
		
		dUamt = TrunCate((dExpAmt * urate)/weight,2)
		
		SetItem(nRow,'uamt',dUamt)
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string s_colnm
Long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

s_colnm = GetColumnName() 
Choose Case s_colnm
	Case "expno"                              // lc 접수번호 선택 popup 
		If rb_upd.Checked = False Then Return // 수정일 경우만...
		
   	Open(w_export_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"expno",gs_code)
		p_inq.TriggerEvent(Clicked!)
	Case "exvnd" ,"shvnd","gwvnd"      // 거래처 선택
   	Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,s_colnm,gs_code)
		SetItem(1,s_colnm+'nm',gs_codename)
	Case "explcno"                              // lc 접수번호 선택 popup 
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		wf_select_lcno(1,gs_code)
	/* 거래처 */
	Case "cvcod"
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose

end event

type gb_4 from groupbox within w_sal_06070
boolean visible = false
integer x = 1541
integer y = 2796
integer width = 1966
integer height = 220
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type gb_3 from groupbox within w_sal_06070
boolean visible = false
integer x = 46
integer y = 2796
integer width = 1349
integer height = 220
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type rb_new from radiobutton within w_sal_06070
integer x = 73
integer y = 72
integer width = 247
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
string text = "신규"
end type

event clicked;If This.Checked = True Then
   wf_protect_key(false)

	dw_key.SetRedraw(False)
   dw_key.Reset()
   dw_key.InsertRow(0)
   dw_insert.Reset()
	
	dw_key.SetFocus()
	dw_key.SetRow(1)

   dw_key.SetItem(1,'exvnd',is_exvnd)
   dw_key.SetItem(1,'exvndnm',is_exvndnm)
   dw_key.SetItem(dw_key.GetRow(),'expdt','')	
	dw_key.SetColumn('expdt')

	dw_key.SetRedraw(True)
	
//	p_print.text = '계산서발행(&P)'
End If

end event

type rb_upd from radiobutton within w_sal_06070
integer x = 325
integer y = 72
integer width = 247
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
string text = "수정"
end type

event clicked;If This.Checked = True Then
   wf_protect_key(true)

	dw_key.SetRedraw(False)	
   dw_key.Reset()
   dw_key.InsertRow(0)

   dw_insert.Reset()
	
	dw_key.SetFocus()
	dw_key.SetRow(1)

   dw_key.SetItem(1,'exvnd',is_exvnd)
   dw_key.SetItem(1,'exvndnm',is_exvndnm)
   dw_key.SetItem(dw_key.GetRow(),'expno','')	
	dw_key.SetColumn('expno')
	dw_key.SetRedraw(True)
	
//	p_print.text = '계산서발행(&P)'
End If

end event

type dw_saleh from datawindow within w_sal_06070
boolean visible = false
integer x = 27
integer y = 2720
integer width = 1842
integer height = 104
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "세금계산서"
string dataobject = "d_sal_020602"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type ds_print from datawindow within w_sal_06070
boolean visible = false
integer x = 631
integer y = 2500
integer width = 1842
integer height = 104
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "세금계산서 출력양식(건별)"
string dataobject = "d_sal_05030_list"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_sal_06070
integer x = 2199
integer y = 220
integer width = 73
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('expdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'expdt', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06070
integer x = 818
integer y = 312
integer width = 78
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('exppmtdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'exppmtdt', gs_code)

end event

type pb_3 from u_pb_cal within w_sal_06070
integer x = 3058
integer y = 220
integer width = 73
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('duedat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'duedat', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 44
integer width = 558
integer height = 108
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_06070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 1128
integer width = 4571
integer height = 1204
integer cornerheight = 40
integer cornerwidth = 55
end type

