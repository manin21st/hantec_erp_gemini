$PBExportHeader$w_han_01020.srw
$PBExportComments$설비별 가동률 / 설비종합효율
forward
global type w_han_01020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_01020
end type
type pb_2 from u_pb_cal within w_han_01020
end type
type dw_1 from datawindow within w_han_01020
end type
type st_1 from statictext within w_han_01020
end type
type st_2 from statictext within w_han_01020
end type
type dw_print2 from datawindow within w_han_01020
end type
type rr_1 from roundrectangle within w_han_01020
end type
end forward

global type w_han_01020 from w_standard_print
integer width = 4695
integer height = 3064
string title = "장비별 가동율/설비종합효율"
pb_1 pb_1
pb_2 pb_2
dw_1 dw_1
st_1 st_1
st_2 st_2
dw_print2 dw_print2
rr_1 rr_1
end type
global w_han_01020 w_han_01020

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_tot ()
public subroutine wf_blk (string as_st, string as_ed, string as_jocod, string as_stim, string as_etim)
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_gub

ls_gub = dw_ip.GetItemString(row, 'gubun')
If ls_gub = '1' Then
	dw_list.DataObject   = 'd_han_01020_004'
	dw_1.DataObject      = 'd_han_01020_005'
	dw_print.DataObject  = 'd_han_01020_004'
//	dw_print2.DataObject = 'd_han_01020_005p'
//	st_1.Visible       = True
//	st_2.Visible       = True
//	st_3.Visible       = True
	st_1.Text          = ''
	st_2.Text          = ''

	dw_ip.SetItem(1, 'jocod', '')

Else
	dw_list.DataObject   = 'd_han_01020_002'
	dw_1.DataObject      = 'd_han_01020_003'
	dw_print.DataObject  = 'd_han_01020_002'
//	dw_print2.DataObject = 'd_han_01020_003p'
//	st_1.Visible       = False
//	st_2.Visible       = False
//	st_3.Visible       = False
	st_1.Text          = ''
	st_2.Text          = ''
End If

dw_list.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
//dw_print2.SetTransObject(SQLCA)

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

If ls_gub = '2' Then
	String ls_jocod
	
	ls_jocod = dw_ip.GetItemString(row, 'jocod')
	If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
		MessageBox('블럭코드 확인', '블럭코드는 필수 항목 입니다.')
		dw_ip.SetColumn('jocod')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_stim

ls_stim = dw_ip.GetItemString(row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_ip.GetItemString(row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

If ls_gub = '2' Then

	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_jocod, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
	
	dw_list.ShareData(dw_print)
	
	If dw_list.RowCount() < 1 Then
		MessageBox('조회확인', '조회된 내역이 없습니다.')
		Return -1
	End If

	//블럭별 가동률/설비종합효율
	wf_blk(ls_st, ls_ed, ls_jocod, ls_stim, ls_etim)
	
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_jocod, ls_stim, ls_etim)
	dw_1.SetRedraw(True)
	
//	dw_print2.SetRedraw(False)
//	dw_print2.Retrieve(ls_st, ls_ed, ls_jocod, ls_stim, ls_etim)
//	dw_print2.SetRedraw(True)
	
	String ls_title
	
	ls_title = dw_ip.Describe("evaluate('lookupdisplay(jocod)',1)")
	
	dw_list.Modify("gr_1.Title = '" + ls_title + "'")
	dw_print.Modify("gr_1.Title = '" + ls_title + "'")
Else
	
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
	
	If dw_list.RowCount() < 1 Then
		MessageBox('조회확인', '조회된 내역이 없습니다.')
		Return -1
	End If
	
	dw_list.ShareData(dw_print)

	//전체 가동률/설비종합효율
	wf_tot()
	
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_1.SetRedraw(True)
	
//	dw_print2.SetRedraw(False)
//	dw_print2.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
//	dw_print2.SetRedraw(True)
End If

Return 1
end function

public subroutine wf_tot ();dw_ip.AcceptText()

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(1, 'd_st')
ls_ed = dw_ip.GetItemString(1, 'd_ed')

String ls_stim
String ls_etim

ls_stim = dw_ip.GetItemString(1, 'stim')
ls_etim = dw_ip.GetItemString(1, 'etim')

Double ldb_ga
/* 가동률 */
	SELECT ROUND((SUM(TOTIM) / SUM(BTIM)) * 100, 2) AS GRATE
	  INTO :ldb_ga
	  FROM (  SELECT A.JOCOD, A.MCHCOD, A.WKCTR,
                    CASE WHEN A.STIME < :ls_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END AS STDAT,
						  SUM(DISTINCT FUN_GET_POP_CALENDAR_FACTOR(A.STDAT, A.STIME, A.WKCTR)) AS BTIM,
						  SUM(DISTINCT A.TOTIM) AS TOTIM
					FROM SHPACT A, MCHMST B
				  WHERE A.SABU                   =       '1'
				    AND A.SHPJPNO                BETWEEN :ls_st||'.' AND :ls_ed||'Z'
					 AND A.STDAT||A.STIME         >=      :ls_st||:ls_stim
					 AND A.STDAT||A.STIME         <=      :ls_ed||:ls_etim
					 AND A.SIDAT||A.ETIME         >=      :ls_st||:ls_stim
					 AND A.SIDAT||A.ETIME         <=      :ls_ed||:ls_etim
					 AND NVL(A.MCHCOD, 'N')       <>      'REW-1'
					 AND A.SABU                   =       B.SABU
					 AND A.MCHCOD                 =       B.MCHNO
					 AND A.MCHCOD                 IS NOT NULL
					 AND NVL(B.PEDAT, 'ZZZZZZZZ') >       :ls_st
			  GROUP BY A.JOCOD, A.MCHCOD, A.WKCTR,
                    CASE WHEN A.STIME < :ls_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END ) ;

st_1.Text = '전체 가동률 : ' + String(ldb_ga) + ' %'

Double ldb_tot
/* 설비종합효율 */
// 설비종합효율 95% -> 100%로 변경 관리 - by shingoon 2009.04.20
//  SELECT ROUND((((SUM(A.BTIM1) - (SUM(A.BTIM1) - SUM(A.TOTIM1))) / SUM(A.BTIM1)) *
//			((SUM(A.SUB_CAL) / (SUM(A.BTIM2) - (SUM(A.BTIM2) - SUM(A.TOTIM2)))) * 0.95) *
//			(SUM(A.COQTY) / SUM(A.ROQTY))) * 100, 2) AS HRATE
  SELECT ROUND((((SUM(A.BTIM1) - (SUM(A.BTIM1) - SUM(A.TOTIM1))) / SUM(A.BTIM1)) *
			((SUM(A.SUB_CAL) / (SUM(A.BTIM2) - (SUM(A.BTIM2) - SUM(A.TOTIM2))))) *
			(SUM(A.COQTY) / SUM(A.ROQTY))) * 100, 2) AS HRATE
	 INTO :ldb_tot
	 FROM (/* 시간가동률 */
			   SELECT A.STDAT, A.JOCOD, B.JONAM, A.MCHCOD, C.MCHNAM,
						 SUM(A.BTIM) AS BTIM1, SUM(DISTINCT A.TOTIM) AS TOTIM1,
						 NULL AS BTIM2, 0 AS TOTIM2, 0 AS SUB_CAL, 0 AS COQTY, 0 AS ROQTY
				  FROM (  SELECT SABU, CASE WHEN STIME < :ls_stim THEN TO_CHAR(TO_DATE(STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE STDAT END AS STDAT,
									  JOCOD, MCHCOD, WKCTR, SUM(DISTINCT TOTIM) AS TOTIM,
									  SUM(DISTINCT DECODE(FUN_GET_POP_CALENDAR_FACTOR(STDAT, STIME, WKCTR), 0, NULL, FUN_GET_POP_CALENDAR_FACTOR(STDAT, STIME, WKCTR))) AS BTIM
								FROM SHPACT
							  WHERE SABU             =       '1'
							    AND SHPJPNO          BETWEEN :ls_st||'.' AND :ls_ed||'Z'
								 AND STDAT||STIME     >=      :ls_st||:ls_stim AND STDAT||STIME <= :ls_ed||:ls_etim
								 AND SIDAT||ETIME     >=      :ls_st||:ls_stim AND SIDAT||ETIME <= :ls_ed||:ls_etim
								 AND NVL(MCHCOD, 'N') <>      'REW-1'
						  GROUP BY SABU, CASE WHEN STIME < :ls_stim THEN TO_CHAR(TO_DATE(STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE STDAT END,
									  JOCOD, MCHCOD, WKCTR ) A,
						 JOMAST B,
						 MCHMST C
				 WHERE A.MCHCOD                 IS NOT NULL
					AND NVL(C.PEDAT, 'ZZZZZZZZ') > :ls_st
					AND A.JOCOD  = B.JOCOD
					AND A.SABU   = C.SABU
					AND A.MCHCOD = C.MCHNO
			 GROUP BY A.STDAT, A.JOCOD, B.JONAM, A.MCHCOD, C.MCHNAM, A.BTIM

			 UNION ALL

			 /* 성능가동률 */
				SELECT STDAT, JOCOD, JONAM, MCHCOD, MCHNAM, NULL AS BTIM1, 0 AS TOTIM1,
						 BTIM AS BTIM2, SUM(DISTINCT TOTIM) AS TOTIM2, SUM(SUB_CAL) AS SUB_CAL, 0 AS COQTY, 0 AS ROQTY
				  FROM (  SELECT DISTINCT A.STDAT, A.JOCOD, C.JONAM, A.MCHCOD, D.MCHNAM, A.TOTIM,
									  DECODE(A.BTIM, 0, NULL, A.BTIM) AS BTIM,
									  (A.ROQTY * (B.MCHR + B.MANHR)) / 60 AS SUB_CAL
								FROM (  SELECT SABU, CASE WHEN STIME < :ls_stim THEN TO_CHAR(TO_DATE(STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE STDAT END AS STDAT,
												   JOCOD, MCHCOD, WKCTR, TOTIM, ITNBR, OPSNO, ROQTY,
													FUN_GET_POP_CALENDAR_FACTOR(STDAT, STIME, WKCTR) AS BTIM
											 FROM SHPACT
											WHERE SABU             =       '1'
											  AND SHPJPNO          BETWEEN :ls_st||'.'      AND :ls_ed||'Z'
											  AND STDAT||STIME     >=      :ls_st||:ls_stim AND STDAT||STIME <= :ls_ed||:ls_etim
											  AND SIDAT||ETIME     >=      :ls_st||:ls_stim AND SIDAT||ETIME <= :ls_ed||:ls_etim
											  AND NVL(MCHCOD, 'N') <>      'REW-1' ) A,
									  ROUTNG B,
									  JOMAST C,
									  MCHMST D
							  WHERE A.MCHCOD IS NOT NULL
								 AND NVL(D.PEDAT, 'ZZZZZZZZ') > :ls_st
								 AND A.ITNBR  = B.ITNBR
								 AND A.OPSNO  = B.OPSEQ
								 AND A.JOCOD  = C.JOCOD
								 AND A.SABU   = D.SABU
								 AND A.MCHCOD = D.MCHNO
                         AND NOT EXISTS ( SELECT 'X' FROM KUMITEM_KUM
								                   WHERE KUMITEM_KUM.ITNBR = A.ITNBR
								                     AND KUMITEM_KUM.USEYN = 'N' )  )
  		    GROUP BY STDAT, JOCOD, JONAM, MCHCOD, MCHNAM, BTIM

			 UNION ALL

			 /* 양품률 */
				SELECT CASE WHEN A.STIME < :ls_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END AS STDAT,
						 A.JOCOD, C.JONAM, A.MCHCOD, D.MCHNAM, NULL AS BTIM1, 0 AS TOTIM1, NULL AS BTIM2, 0 AS TOTIM2, 0 AS SUB_CAL,
						 SUM(A.COQTY) AS COQTY, SUM(A.ROQTY) AS ROQTY
				  FROM SHPACT A,
						 ROUTNG B,
						 JOMAST C,
						 MCHMST D
				 WHERE A.SABU                   =       '1'
				   AND A.SHPJPNO                BETWEEN :ls_st||'.' AND :ls_ed||'Z'
					AND A.STDAT||A.STIME         >=      :ls_st||:ls_stim AND A.STDAT||A.STIME <= :ls_ed||:ls_etim
					AND A.SIDAT||A.ETIME         >=      :ls_st||:ls_stim AND A.SIDAT||A.ETIME <= :ls_ed||:ls_etim
					AND NVL(A.MCHCOD, 'N')       <>      'REW-1'
					AND A.ITNBR                  =       B.ITNBR
					AND A.OPSNO                  =       B.OPSEQ
					AND A.JOCOD                  =       C.JOCOD
					AND A.SABU                   =       D.SABU
					AND A.MCHCOD                 =       D.MCHNO
				   AND NVL(D.PEDAT, 'ZZZZZZZZ') >       :ls_st
			 GROUP BY CASE WHEN A.STIME < :ls_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END,
						 A.JOCOD, C.JONAM, A.MCHCOD, D.MCHNAM  ) A,
			GRP_SUM Z
   WHERE Z.SER > 0 AND Z.SER < 3
	  AND Z.SER = '2' ;

st_2.Text = '전체 설비종합효율 : ' + String(ldb_tot) + ' %'


end subroutine

public subroutine wf_blk (string as_st, string as_ed, string as_jocod, string as_stim, string as_etim);Double ldb_ga
/* 가동률 */
	SELECT ROUND((SUM(A.TOTIM) / SUM(A.BTIM)) * 100, 2) AS GRATE
	  INTO :ldb_ga
	  FROM (  SELECT A.MCHCOD, B.SPEC, A.WKCTR,
                    CASE WHEN A.STIME < :as_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END AS STDAT,
						  SUM(DISTINCT FUN_GET_POP_CALENDAR_FACTOR(A.STDAT, A.STIME, A.WKCTR)) AS BTIM,
						  SUM(DISTINCT A.TOTIM) AS TOTIM
					FROM SHPACT A,
						  MCHMST B
				  WHERE A.SABU                   =       '1'
				    AND A.SHPJPNO                BETWEEN :as_st||'.' AND :as_ed||'Z'
				    AND A.STDAT||A.STIME         >=      :as_st||:as_stim
					 AND A.STDAT||A.STIME         <=      :as_ed||:as_etim
					 AND A.SIDAT||A.ETIME         >=      :as_st||:as_stim
					 AND A.SIDAT||A.ETIME         <=      :as_ed||:as_etim
					 AND NVL(A.MCHCOD, 'N')       <>      'REW-1'
					 AND A.JOCOD                  =       :as_jocod
					 AND A.MCHCOD                 IS NOT NULL
					 AND NVL(B.PEDAT, 'ZZZZZZZZ') >       :as_st
					 AND A.SABU                   =       B.SABU
					 AND A.MCHCOD                 =       B.MCHNO
			  GROUP BY A.JOCOD, A.MCHCOD, B.SPEC, A.WKCTR,
                    CASE WHEN A.STIME < :as_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END ) A ;
			  
st_1.Text = as_jocod + '블럭 가동률 : ' + String(ldb_ga) + ' %'


Double ldb_tot
/* 설비종합효율 */
// 설비종합효율 95% -> 100%로 변경관리 - by shingoon 2009.04.20
//  SELECT ROUND((((SUM(A.BTIM1) - (SUM(A.BTIM1) - SUM(A.TOTIM1))) / SUM(A.BTIM1)) *
//			((SUM(A.SUB_CAL) / (SUM(A.BTIM2) - (SUM(A.BTIM2) - SUM(A.TOTIM2)))) * 0.95) *
//			(SUM(A.COQTY) / SUM(A.ROQTY))) * 100, 2) AS HRATE
  SELECT ROUND((((SUM(A.BTIM1) - (SUM(A.BTIM1) - SUM(A.TOTIM1))) / SUM(A.BTIM1)) *
			((SUM(A.SUB_CAL) / (SUM(A.BTIM2) - (SUM(A.BTIM2) - SUM(A.TOTIM2))))) *
			(SUM(A.COQTY) / SUM(A.ROQTY))) * 100, 2) AS HRATE
	 INTO :ldb_tot
	 FROM (/* 시간가동률 */
			   SELECT A.STDAT, A.JOCOD, B.JONAM, A.MCHCOD, C.MCHNAM,
						 SUM(A.BTIM) AS BTIM1, SUM(DISTINCT A.TOTIM) AS TOTIM1,
						 NULL AS BTIM2, 0 AS TOTIM2, 0 AS SUB_CAL, 0 AS COQTY, 0 AS ROQTY
				  FROM (  SELECT SABU, CASE WHEN STIME < :as_stim THEN TO_CHAR(TO_DATE(STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE STDAT END AS STDAT,
									  JOCOD, MCHCOD, WKCTR, SUM(DISTINCT TOTIM) AS TOTIM,
									  SUM(DISTINCT DECODE(FUN_GET_POP_CALENDAR_FACTOR(STDAT, STIME, WKCTR), 0, NULL, FUN_GET_POP_CALENDAR_FACTOR(STDAT, STIME, WKCTR))) AS BTIM
								FROM SHPACT
							  WHERE SABU             =       '1'
							    AND SHPJPNO          BETWEEN :as_st||'.'      AND :as_ed||'Z'
							    AND STDAT||STIME     >=      :as_st||:as_stim AND STDAT||STIME <= :as_ed||:as_etim
								 AND SIDAT||ETIME     >=      :as_st||:as_stim AND SIDAT||ETIME <= :as_ed||:as_etim
								 AND NVL(MCHCOD, 'N') <>      'REW-1'
						  GROUP BY SABU, CASE WHEN STIME < :as_stim THEN TO_CHAR(TO_DATE(STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE STDAT END,
									  JOCOD, MCHCOD, WKCTR ) A,
						 JOMAST B,
						 MCHMST C
				 WHERE A.JOCOD                  = :as_jocod
					AND A.MCHCOD                 IS NOT NULL
					AND NVL(C.PEDAT, 'ZZZZZZZZ') > :as_st
					AND A.JOCOD                  = B.JOCOD
					AND A.SABU                   = C.SABU
					AND A.MCHCOD                 = C.MCHNO
			 GROUP BY A.STDAT, A.JOCOD, B.JONAM, A.MCHCOD, C.MCHNAM, A.BTIM

			 UNION ALL

			 /* 성능가동률 */
				SELECT STDAT, JOCOD, JONAM, MCHCOD, MCHNAM, NULL AS BTIM1, 0 AS TOTIM1,
						 BTIM AS BTIM2, SUM(DISTINCT TOTIM) AS TOTIM2, SUM(SUB_CAL) AS SUB_CAL, 0 AS COQTY, 0 AS ROQTY
				  FROM (  SELECT DISTINCT A.STDAT, A.JOCOD, C.JONAM, A.MCHCOD, D.MCHNAM, A.TOTIM,
									  DECODE(A.BTIM, 0, NULL, A.BTIM) AS BTIM,
									  (A.ROQTY * (B.MCHR + B.MANHR)) / 60 AS SUB_CAL
								FROM (  SELECT SABU, CASE WHEN STIME < :as_stim THEN TO_CHAR(TO_DATE(STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE STDAT END AS STDAT,
												   JOCOD, MCHCOD, WKCTR, TOTIM, ITNBR, OPSNO, ROQTY,
													FUN_GET_POP_CALENDAR_FACTOR(STDAT, STIME, WKCTR) AS BTIM
											 FROM SHPACT
											WHERE SABU             =       '1'
											  AND SHPJPNO          BETWEEN :as_st||'.'      AND :as_ed||'Z'
											  AND STDAT||STIME     >=      :as_st||:as_stim AND STDAT||STIME <= :as_ed||:as_etim
											  AND SIDAT||ETIME     >=      :as_st||:as_stim AND SIDAT||ETIME <= :as_ed||:as_etim
											  AND NVL(MCHCOD, 'N') <>      'REW-1' ) A,
									  ROUTNG B,
									  JOMAST C,
									  MCHMST D
							  WHERE A.JOCOD                  = :as_jocod
								 AND A.MCHCOD                 IS NOT NULL
								 AND NVL(D.PEDAT, 'ZZZZZZZZ') > :as_st
								 AND A.ITNBR                  = B.ITNBR
								 AND A.OPSNO                  = B.OPSEQ
								 AND A.JOCOD                  = C.JOCOD
								 AND A.SABU                   = D.SABU
								 AND A.MCHCOD                 = D.MCHNO
                         AND NOT EXISTS ( SELECT 'X' FROM KUMITEM_KUM
								                   WHERE KUMITEM_KUM.ITNBR = A.ITNBR
								                     AND KUMITEM_KUM.USEYN = 'N' )  )
  		    GROUP BY STDAT, JOCOD, JONAM, MCHCOD, MCHNAM, BTIM

			 UNION ALL

			 /* 양품률 */
				SELECT CASE WHEN A.STIME < :as_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END AS STDAT,
						 A.JOCOD, C.JONAM, A.MCHCOD, D.MCHNAM, NULL AS BTIM1, 0 AS TOTIM1, NULL AS BTIM2, 0 AS TOTIM2, 0 AS SUB_CAL,
						 SUM(A.COQTY) AS COQTY, SUM(A.ROQTY) AS ROQTY
				  FROM SHPACT A,
						 ROUTNG B,
						 JOMAST C,
						 MCHMST D
				 WHERE A.SABU             =       '1'
				   AND A.SHPJPNO          BETWEEN :as_st||'.'      AND :as_ed||'Z'
					AND A.JOCOD            =       :as_jocod
					AND A.STDAT||A.STIME   >=      :as_st||:as_stim AND A.STDAT||A.STIME <= :as_ed||:as_etim
					AND A.SIDAT||A.ETIME   >=      :as_st||:as_stim AND A.SIDAT||A.ETIME <= :as_ed||:as_etim
					AND NVL(A.MCHCOD, 'N') <>      'REW-1'
					AND A.ITNBR            =       B.ITNBR
					AND A.OPSNO            =       B.OPSEQ
					AND A.JOCOD            =       C.JOCOD
					AND A.SABU             =       D.SABU
					AND A.MCHCOD           =       D.MCHNO
			 GROUP BY CASE WHEN A.STIME < :as_stim THEN TO_CHAR(TO_DATE(A.STDAT, 'YYYYMMDD') - 1, 'YYYYMMDD') ELSE A.STDAT END,
						 A.JOCOD, C.JONAM, A.MCHCOD, D.MCHNAM  ) A,
			GRP_SUM Z
   WHERE Z.SER > 0 AND Z.SER < 3
	  AND Z.SER = '2'
GROUP BY A.JOCOD,
 	      CASE Z.SER WHEN '2' THEN 'ZZZZ'
			  			  WHEN '1' THEN A.MCHCOD END,
			CASE Z.SER WHEN '2' THEN 'ZZZZ'
						  WHEN '1' THEN A.MCHNAM END ;

st_2.Text = as_jocod + '블럭 설비종합효율 : ' + String(ldb_tot) + ' %'
end subroutine

on w_han_01020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.dw_print2=create dw_print2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_print2
this.Control[iCurrent+7]=this.rr_1
end on

on w_han_01020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_print2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.Setitem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_ip.SetItem(1, 'stim', ls_st)
dw_ip.SetItem(1, 'etim', ls_ed)
end event

type p_xls from w_standard_print`p_xls within w_han_01020
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//

If this.Enabled Then wf_excel_down(dw_1)
end event

type p_sort from w_standard_print`p_sort within w_han_01020
integer x = 3547
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_01020
boolean visible = false
integer x = 3182
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_han_01020
end type

type p_print from w_standard_print`p_print within w_han_01020
boolean visible = false
integer x = 3365
end type

event p_print::clicked;//

//iF dw_print.rowcount() > 0 then 
//	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
//ELSE
//	gi_page = 1
//END IF
//OpenWithParm(w_print_options, dw_print)

dw_print.Print()
dw_print2.Print()


end event

type p_retrieve from w_standard_print`p_retrieve within w_han_01020
integer x = 4096
end type

event p_retrieve::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
//	p_print.Enabled     = False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
//
//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
//	p_print.Enabled     = True
//	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
//	p_preview.enabled = true
//	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_han_01020
end type



type dw_print from w_standard_print`dw_print within w_han_01020
integer x = 3767
integer y = 40
string dataobject = "d_han_01020_004"
end type

type dw_ip from w_standard_print`dw_ip within w_han_01020
integer x = 37
integer width = 3145
integer height = 184
string dataobject = "d_han_01020_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name		
	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_ed') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_st') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_01020
integer x = 55
integer y = 228
integer width = 4530
integer height = 1628
string dataobject = "d_han_01020_004"
end type

event dw_list::clicked;call super::clicked;String ls_dwo

ls_dwo = dwo.name

end event

type pb_1 from u_pb_cal within w_han_01020
integer x = 562
integer y = 60
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_ed') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If
end event

type pb_2 from u_pb_cal within w_han_01020
integer x = 1230
integer y = 60
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_st') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If


end event

type dw_1 from datawindow within w_han_01020
integer x = 55
integer y = 1868
integer width = 4530
integer height = 360
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01020_005"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type st_1 from statictext within w_han_01020
integer x = 3077
integer y = 248
integer width = 1504
integer height = 76
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_2 from statictext within w_han_01020
integer x = 3077
integer y = 336
integer width = 1504
integer height = 76
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 16777215
boolean focusrectangle = false
end type

type dw_print2 from datawindow within w_han_01020
boolean visible = false
integer x = 3918
integer y = 36
integer width = 128
integer height = 112
integer taborder = 130
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_han_01020_003"
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_han_01020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4567
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

