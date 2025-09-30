$PBExportHeader$w_sm30_3011_popup1.srw
$PBExportComments$주간 판매계획 접수
forward
global type w_sm30_3011_popup1 from w_inherite_popup
end type
type dw_insert from datawindow within w_sm30_3011_popup1
end type
type dw_upload from datawindow within w_sm30_3011_popup1
end type
type rr_2 from roundrectangle within w_sm30_3011_popup1
end type
type rr_3 from roundrectangle within w_sm30_3011_popup1
end type
end forward

global type w_sm30_3011_popup1 from w_inherite_popup
integer width = 1952
integer height = 1764
string title = "판매계획 접수"
boolean controlmenu = true
dw_insert dw_insert
dw_upload dw_upload
rr_2 rr_2
rr_3 rr_3
end type
global w_sm30_3011_popup1 w_sm30_3011_popup1

forward prototypes
public function integer wf_num (string arg_num)
public function integer wf_update_reffpf ()
public function integer wf_hkcd6 (integer li_filenum)
public function integer wf_ptec (string as_saupj, string as_ymd, string as_empno)
public subroutine wf_wk (string as_saupj, string as_ymd, string as_empno)
public subroutine wf_wp (string as_saupj, string as_ymd, string as_empno)
public subroutine wf_ws (string as_saupj, string as_ymd, string as_empno)
public subroutine wf_exp (string as_saupj, string as_ymd, string as_empno)
end prototypes

public function integer wf_num (string arg_num);Dec dNum
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

public function integer wf_update_reffpf ();long		lrow
string	srfgub, srfna3
for lrow=1 to dw_jogun.rowcount()
	if dw_jogun.getitemstring(lrow,'chk')='N' then continue
	if dw_jogun.getitemnumber(lrow,'rfna4')=99 then continue
	srfgub=dw_jogun.getitemstring(lrow,'rfgub')
	srfna3=trim(dw_jogun.getitemstring(lrow,'rfna3'))
	update reffpf set rfna3= :srfna3 where rfcod='5B' and rfgub= :srfgub ;
next

return 1     

end function

public function integer wf_hkcd6 (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate, sComp, sPlnt, sGate
Long   nRow, ix
String sFileName[2] = { "C:\HKC\VAN\HKCD6.TXT", "C:\HKC\VAN\HKCD8.TXT" }

dw_insert.Reset()

For ix = 1 To 2 
	li_FileNum = FileOpen(sFileName[ix])
	If li_fileNum = 1 Then
		DO WHILE FileRead(li_FileNum, sLine) > 0
			nRow = dw_insert.InsertRow(0)
			
			sItnbr = ''
			sCvcod = ''
			
			dw_insert.SetItem(nRow, "SEQ1", 		Trim(Mid(sLine,1 ,12)))
			dw_insert.SetItem(nRow, "SEQ2", 		Trim(Mid(sLine,13,4)))
			/* 공장구분 - 거래처 */
			sTemp = Trim(Mid(sLine,17,2))
			If IsNull(sTemp) Or sTemp = '' Or sTemp <> 'Y' Then Continue
			
			sComp = Trim(Mid(sLine,13,4))
			sPlnt = Trim(Mid(sLine,17,2))
			sGate = Trim(Mid(sLine,127,4))
			
			SELECT	fun_gate_cvcod(:sComp, :sPlnt, '', :sGate) INTO :sCvcod FROM DUAL;
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
		
		FileClose(li_FileNum)
	End If
Next

If dw_insert.Update() <> 1 Then
	RollBack;
	Return -1
End If

COMMIT;

return nRow
end function

public function integer wf_ptec (string as_saupj, string as_ymd, string as_empno);/* 파워텍 기존자료 삭제 */
DELETE FROM SM03_WEEKPLAN_ITEM_SALE
 WHERE SAUPJ  =  :as_saupj
   AND YYMMDD =  :as_ymd
	AND GUBUN  =  'HAN'
	AND EMPNO  =  :as_empno
	AND PLNT   IN ('T6', 'T7', 'T8', 'T9')      ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('기존자료 삭제', '파워텍 생성 자료 삭제 중 오류가 발생했습니다!~r~n~r~n전산실로 문의 하십시오!')
	Return -1
End If

/* 파워텍 담당자가 자료 생성할 경우 생성 */
String ls_na5
SELECT MAX(RFNA5)
  INTO :ls_na5
  FROM REFFPF
 WHERE RFCOD = '2A'
   AND RFNA2 = '201012' ;

If ls_na5 = as_empno Then
	INSERT INTO SM03_WEEKPLAN_ITEM_SALE
	(SAUPJ, YYMMDD, GUBUN, CVCOD, PLNT, ITNBR, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11,
		JQTY1, JQTY2, CHULHA_QTY, JAEGO, GATE, EMPNO, ITM_PRC)
	SELECT :as_saupj,
			 :as_ymd,
			 'HAN',
			 A.CVCOD,
			 A.FACTORY,
			 A.ITNBR,
			 0 AS QTY1,
			 0 AS QTY2,
			 0 AS QTY3,
			 0 AS QTY4,
			 0 AS QTY5,
			 0 AS QTY6,
			 0 AS QTY7,
			 0 AS QTY8,
			 0 AS QTY9,
			 0 AS QTY10,
			 0 AS QTY11,
			 //NVL(FUN_GET_STOCK_NAPUM(:as_saupj, A.FACTORY, A.ITNBR), 0)      AS JQTY1     ,
			 NVL(FUN_GET_STOCK_NAPUM('10', A.FACTORY, A.ITNBR), 0)      AS JQTY1     ,
			 NVL(FUN_GET_STOCK_MULU2(A.CVCOD  , A.FACTORY, A.ITNBR), 0)      AS JQTY2     ,
			 FUN_GET_PLNT_SALEQTY('1', :as_ymd, :as_ymd, A.FACTORY, A.ITNBR) AS CHULHA_QTY,
			 NVL(FUN_GET_STOCK_DEPOT(A.ITNBR, '.', :as_saupj, '1', '1'), 0)  AS JAEGO     ,
			 FUN_GET_NEWITS(A.FACTORY, A.ITNBR)                              AS GATE      ,
			 :as_empno,
			 FUN_VNDDAN_DANGA(:as_ymd, A.ITNBR, A.CVCOD) /* 생성시 단가 - BY SHINGOON 2009.01.16 */
     FROM VNDMRP_NEW A
    WHERE CVCOD = '201012' ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('파워텍 생성 실패', '파워텍 품목 생성은 실패 했습니다.')
		Return -1
	End If
	
	COMMIT USING SQLCA;
End If

Return 1
end function

public subroutine wf_wk (string as_saupj, string as_ymd, string as_empno);/* 위아광주 기존자료 삭제 */
DELETE FROM SM03_WEEKPLAN_ITEM_SALE
 WHERE SAUPJ  = :as_saupj
   AND YYMMDD = :as_ymd
	AND GUBUN  = 'HAN'
	AND EMPNO  = :as_empno
	AND PLNT   = 'WK'      ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('기존자료 삭제', '위아광주(WK) 생성 자료 삭제 중 오류가 발생했습니다!~r~n~r~n전산실로 문의 하십시오!')
	Return
End If

/* 위아광주 담당자가 자료 생성할 경우 생성 */
String ls_na5
SELECT RFNA5
  INTO :ls_na5
  FROM REFFPF
 WHERE RFCOD = '2A'
   AND RFGUB = 'WK' ;

If ls_na5 = as_empno Then
	INSERT INTO SM03_WEEKPLAN_ITEM_SALE
	(SAUPJ, YYMMDD, GUBUN, CVCOD, PLNT, ITNBR, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11, 
		JQTY1, JQTY2, CHULHA_QTY, JAEGO, GATE, EMPNO, ITM_PRC)
	SELECT :as_saupj,
			 :as_ymd,
			 'HAN',
			 '201015',
			 'WK',
			 A.ITNBR,
			 0 AS QTY1,
			 0 AS QTY2,
			 0 AS QTY3,
			 0 AS QTY4,
			 0 AS QTY5,
			 0 AS QTY6,
			 0 AS QTY7,
			 0 AS QTY8,
			 0 AS QTY9,
			 0 AS QTY10,
			 0 AS QTY11,
			 NVL(FUN_GET_STOCK_NAPUM('10', 'WK', A.ITNBR), 0)               AS JQTY1     ,
			 NVL(FUN_GET_STOCK_MULU2('201015', 'WK', A.ITNBR), 0)           AS JQTY2     ,
			 FUN_GET_PLNT_SALEQTY('1', :as_ymd, :as_ymd, 'WK', A.ITNBR)     AS CHULHA_QTY,
			 NVL(FUN_GET_STOCK_DEPOT(A.ITNBR, '.', :as_saupj, '1', '1'), 0) AS JAEGO     ,
			 FUN_GET_NEWITS('WK', A.ITNBR)                                  AS GATE      ,
			 :as_empno,
			 FUN_VNDDAN_DANGA(:as_ymd, A.ITNBR, '201015') /* 생성시 단가 - BY SHINGOON 2009.01.16 */
	  FROM VNDDAN A
	 WHERE ( A.CVCOD , A.ITNBR , A.START_DATE ) IN (  SELECT CVCOD, ITNBR, MAX(START_DATE)
																		 FROM VNDDAN
																		WHERE CVCOD = '201015'
																	GROUP BY CVCOD, ITNBR  )
		AND A.CVCOD = '201015' ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('위아광주 생성 실패', '위아광주 공장 품목생성은 실패 했습니다.')
		Return
	End If
	
	COMMIT USING SQLCA;
End If
end subroutine

public subroutine wf_wp (string as_saupj, string as_ymd, string as_empno);/* 위아포승 기존자료 삭제 */
DELETE FROM SM03_WEEKPLAN_ITEM_SALE
 WHERE SAUPJ  = :as_saupj
   AND YYMMDD = :as_ymd
	AND GUBUN  = 'HAN'
	AND EMPNO  = :as_empno
	AND PLNT   = 'WP'      ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('기존자료 삭제', '위아포승(WP) 생성 자료 삭제 중 오류가 발생했습니다!~r~n~r~n전산실로 문의 하십시오!')
	Return
End If

/* 위아포승 담당자가 자료 생성할 경우 생성 */
String ls_na5
SELECT RFNA5
  INTO :ls_na5
  FROM REFFPF
 WHERE RFCOD = '2A'
   AND RFGUB = 'WP' ;

If ls_na5 = as_empno Then
	INSERT INTO SM03_WEEKPLAN_ITEM_SALE
	(SAUPJ, YYMMDD, GUBUN, CVCOD, PLNT, ITNBR, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11,
		JQTY1, JQTY2, CHULHA_QTY, JAEGO, GATE, EMPNO, ITM_PRC)
	SELECT :as_saupj,
			 :as_ymd,
			 'HAN',
			 '201017',
			 'WP',
			 A.ITNBR,
			 0 AS QTY1,
			 0 AS QTY2,
			 0 AS QTY3,
			 0 AS QTY4,
			 0 AS QTY5,
			 0 AS QTY6,
			 0 AS QTY7,
			 0 AS QTY8,
			 0 AS QTY9,
			 0 AS QTY10,
			 0 AS QTY11,
			 NVL(FUN_GET_STOCK_NAPUM('10', 'WP', A.ITNBR), 0)               AS JQTY1     ,
			 NVL(FUN_GET_STOCK_MULU2('201017', 'WP', A.ITNBR), 0)           AS JQTY2     ,
			 FUN_GET_PLNT_SALEQTY('1', :as_ymd, :as_ymd, 'WP', A.ITNBR)     AS CHULHA_QTY,
			 NVL(FUN_GET_STOCK_DEPOT(A.ITNBR, '.', :as_saupj, '1', '1'), 0) AS JAEGO     ,
			 FUN_GET_NEWITS('WP', A.ITNBR)                                  AS GATE      ,
			 :as_empno,
			 FUN_VNDDAN_DANGA(:as_ymd, A.ITNBR, '201017') /* 생성시 단가 - BY SHINGOON 2009.01.16 */
	  FROM VNDDAN A
	 WHERE ( A.CVCOD , A.ITNBR , A.START_DATE ) IN (  SELECT CVCOD, ITNBR, MAX(START_DATE)
																		 FROM VNDDAN
																		WHERE CVCOD = '201017'
																	GROUP BY CVCOD, ITNBR  )
		AND A.CVCOD = '201017' ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('위아포승 생성 실패', '위아포승 공장 품목생성은 실패 했습니다.')
		Return
	End If
	
	COMMIT USING SQLCA;
End If
end subroutine

public subroutine wf_ws (string as_saupj, string as_ymd, string as_empno);/* 위아서산 기존자료 삭제 */
DELETE FROM SM03_WEEKPLAN_ITEM_SALE
 WHERE SAUPJ  = :as_saupj
   AND YYMMDD = :as_ymd
	AND GUBUN  = 'HAN'
	AND EMPNO  = :as_empno
	AND PLNT   = 'WS'      ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('기존자료 삭제', '위아서산(WS) 생성 자료 삭제 중 오류가 발생했습니다!~r~n~r~n전산실로 문의 하십시오!')
	Return
End If

/* 위아서산 담당자가 자료 생성할 경우 생성 */
String ls_na5
SELECT RFNA5
  INTO :ls_na5
  FROM REFFPF
 WHERE RFCOD = '2A'
   AND RFGUB = 'WS' ;

If ls_na5 = as_empno Then
	INSERT INTO SM03_WEEKPLAN_ITEM_SALE
	(SAUPJ, YYMMDD, GUBUN, CVCOD, PLNT, ITNBR, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11,
		JQTY1, JQTY2, CHULHA_QTY, JAEGO, GATE, EMPNO, ITM_PRC)
	SELECT :as_saupj,
			 :as_ymd,
			 'HAN',
			 '201016',
			 'WS',
			 A.ITNBR,
			 0 AS QTY1,
			 0 AS QTY2,
			 0 AS QTY3,
			 0 AS QTY4,
			 0 AS QTY5,
			 0 AS QTY6,
			 0 AS QTY7,
			 0 AS QTY8,
			 0 AS QTY9,
			 0 AS QTY10,
			 0 AS QTY11,
			 NVL(FUN_GET_STOCK_NAPUM('10', 'WS', A.ITNBR), 0)               AS JQTY1     ,
			 NVL(FUN_GET_STOCK_MULU2('201016', 'WS', A.ITNBR), 0)           AS JQTY2     ,
			 FUN_GET_PLNT_SALEQTY('1', :as_ymd, :as_ymd, 'WS', A.ITNBR)     AS CHULHA_QTY,
			 NVL(FUN_GET_STOCK_DEPOT(A.ITNBR, '.', :as_saupj, '1', '1'), 0) AS JAEGO     ,
			 FUN_GET_NEWITS('WS', A.ITNBR)                                  AS GATE      ,
			 :as_empno,
			 FUN_VNDDAN_DANGA(:as_ymd, A.ITNBR, '201016') /* 생성시 단가 - BY SHINGOON 2009.01.16 */
	  FROM VNDDAN A
	 WHERE ( A.CVCOD , A.ITNBR , A.START_DATE ) IN (  SELECT CVCOD, ITNBR, MAX(START_DATE)
																		 FROM VNDDAN
																		WHERE CVCOD = '201016'
																	GROUP BY CVCOD, ITNBR  )
		AND A.CVCOD = '201016' ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('위아서산 생성 실패', '위아서산 공장 품목생성은 실패 했습니다.')
		Return
	End If
	
	COMMIT USING SQLCA;
End If
end subroutine

public subroutine wf_exp (string as_saupj, string as_ymd, string as_empno);/* 수출자료 기존자료 삭제 */
DELETE FROM SM03_WEEKPLAN_ITEM_SALE
 WHERE SAUPJ  = :as_saupj
   AND YYMMDD = :as_ymd
	AND GUBUN  = 'EXP'
	AND EMPNO  = :as_empno
	AND PLNT   = '.'      ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('기존자료 삭제', '수출자료 생성 자료 삭제 중 오류가 발생했습니다!~r~n~r~n전산실로 문의 하십시오!')
	Return
End If

If as_empno <> '' Then
	INSERT INTO SM03_WEEKPLAN_ITEM_SALE
	(SAUPJ, YYMMDD, GUBUN, CVCOD, PLNT, ITNBR, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11, 
		JQTY1, JQTY2, CHULHA_QTY, JAEGO, GATE, EMPNO, ITM_PRC)
	SELECT :as_saupj,
             :as_ymd,
             'EXP',
             CVCOD,
             '.',
             A.ITNBR,
             0 AS QTY1,
             0 AS QTY2,
             0 AS QTY3,
             0 AS QTY4,
             MMQTY2 AS QTY5,
             0 AS QTY6,
             0 AS QTY7,
             0 AS QTY8,
             0 AS QTY9,
             0 AS QTY10,
             0 AS QTY11,
         	/*    
			NVL(FUN_GET_STOCK_NAPUM('10', 'WS', A.ITNBR), 0) AS JQTY1,
			NVL(FUN_GET_STOCK_MULU2('201016', 'WS', A.ITNBR), 0) AS JQTY2, 
			FUN_GET_PLNT_SALEQTY('1', :as_ymd, :as_ymd, '.', A.ITNBR) AS CHULHA_QTY,
			*/
             0 AS JQTY1     ,
             0 AS JQTY2     ,
             0 AS CHULHA_QTY,
             NVL(FUN_GET_STOCK_DEPOT(A.ITNBR, '.', :as_saupj, '1', '1'), 0) AS JAEGO     ,
             '.' AS GATE      ,
             :as_empno,
             FUN_VNDDAN_DANGA(:as_ymd, A.ITNBR, '201016') /* 생성시 단가 - BY SHINGOON 2009.01.16 */
      FROM SM01_MONPLAN_EX A
      WHERE NAPGI2 BETWEEN to_char(TO_DATE(:as_ymd)+26,'yyyymmdd') and to_char(TO_DATE(:as_ymd)+32,'yyyymmdd');
		
		
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('수출자료 생성 실패', '수출자료  품목생성은 실패 했습니다.')
		Return
	End If
	
	COMMIT USING SQLCA;
End If
end subroutine

on w_sm30_3011_popup1.create
int iCurrent
call super::create
this.dw_insert=create dw_insert
this.dw_upload=create dw_upload
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_insert
this.Control[iCurrent+2]=this.dw_upload
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_3
end on

on w_sm30_3011_popup1.destroy
call super::destroy
destroy(this.dw_insert)
destroy(this.dw_upload)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;string sYymmdd, sEmpno, sSaupj

dw_jogun.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_upload.SetTransObject(sqlca)

sYymmdd = gs_code
sEmpno = gs_codename
sSaupj = gs_codename2

dw_1.InsertRow(0)
dw_1.SetItem(1, 'yymmdd', sYymmdd)
dw_1.SetItem(1, 'empno', sEmpno )
dw_1.SetItem(1, 'saupj', sSaupj )

dw_jogun.Retrieve(1)
Long i
For i = 1 To dw_jogun.RowCount()
	dw_jogun.Object.sdate[i] = sYymmdd
Next

/* User별 사업장 Setting Start */
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
//End If
/* ---------------------- End  */

//dw_1.SetItem(1, 'saupj', gs_saupj)


dw_upload.Reset()
dw_upload.Retrieve(sSaupj, sYymmdd, sEmpno)

	


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm30_3011_popup1
integer x = 37
integer y = 212
integer width = 1774
integer height = 688
string dataobject = "d_sm30_3011_popup1_2"
end type

type p_exit from w_inherite_popup`p_exit within w_sm30_3011_popup1
integer x = 1733
integer y = 32
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

Close(Parent)
end event

event p_exit::ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_sm30_3011_popup1
boolean visible = false
integer x = 27
integer y = 2196
end type

type p_choose from w_inherite_popup`p_choose within w_sm30_3011_popup1
integer x = 1559
integer y = 32
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_choose::clicked;call super::clicked;String ls_saupj , ls_ymd ,ls_today , ls_sdate, ls_edate , ls_gubun ,ls_empno , ls_status
Long i

If dw_1.AcceptText() < 1 Then Return
If dw_jogun.AcceptText() < 1 Then Return

ls_ymd   = trim(dw_1.getitemstring(1, 'yymmdd'))
ls_empno = trim(dw_1.getitemstring(1, 'empno'))

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[계획일자]')
	Return
End If

/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

IF MessageBox("확인", '기존 생성된 자료가 있을 경우 삭제됩니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

ls_today = f_today()

SetPointer(HourGlass!)

If dw_jogun.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	return
else
	commit;
End if

If Trim(ls_empno) = '' or isNull(ls_empno) Then ls_empno = '%'

//sqlca.SP_SM03_WEEKPLAN(ls_saupj,ls_ymd,ls_empno,ls_status) ;
//If SQLCA.SQLCODE <> 0 Then
//	MessageBox('DataBase SQLCA Error', SQLCA.SQLERRTEXT + '~r~n' + 'Procedure Create Error!! 전산실에 문의하세요.')
//	Return
//End If
SQLCA.SP_SM03_WEEKPLAN_NEW(ls_saupj, ls_ymd, ls_empno, ls_status);

If ls_status = 'N' Then
	Messagebox('확인','프로시져 생성 에러!!  전산실에 문의하세요.')
	return
End If

dw_jogun.Retrieve(2)

end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm30_3011_popup1
integer x = 23
integer y = 24
integer width = 1545
integer height = 172
string dataobject = "d_sm30_3010_popup1_1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::rowfocuschanged;//
end event

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm30_3011_popup1
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm30_3011_popup1
end type

type cb_return from w_inherite_popup`cb_return within w_sm30_3011_popup1
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm30_3011_popup1
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm30_3011_popup1
end type

type st_1 from w_inherite_popup`st_1 within w_sm30_3011_popup1
end type

type dw_insert from datawindow within w_sm30_3011_popup1
boolean visible = false
integer x = 896
integer y = 116
integer width = 635
integer height = 100
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_hkcd6"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_upload from datawindow within w_sm30_3011_popup1
integer x = 37
integer y = 936
integer width = 1774
integer height = 688
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm30_3011_popup1_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_sm30_3011_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 1870
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm30_3011_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 932
integer width = 1870
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

