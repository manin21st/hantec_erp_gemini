$PBExportHeader$w_sm01_03010.srw
$PBExportComments$주간 판매계획 접수
forward
global type w_sm01_03010 from w_inherite
end type
type dw_1 from u_key_enter within w_sm01_03010
end type
type dw_3 from datawindow within w_sm01_03010
end type
type dw_lg from datawindow within w_sm01_03010
end type
type rr_1 from roundrectangle within w_sm01_03010
end type
type rr_2 from roundrectangle within w_sm01_03010
end type
type cbx_1 from checkbox within w_sm01_03010
end type
type cb_1 from commandbutton within w_sm01_03010
end type
end forward

global type w_sm01_03010 from w_inherite
string title = "주간 판매계획 접수"
dw_1 dw_1
dw_3 dw_3
dw_lg dw_lg
rr_1 rr_1
rr_2 rr_2
cbx_1 cbx_1
cb_1 cb_1
end type
global w_sm01_03010 w_sm01_03010

type variables
// 공장구분
DataWindowChild idw_plnt
end variables

forward prototypes
public function integer wf_danga (integer nrow)
end prototypes

public function integer wf_danga (integer nrow);String sToday, sCvcod, sItnbr, sSpec
Double dItemPrice, dDcRate
Int    iRtnValue

sToday = f_today()

sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sSpec  = '.'

iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sToday, sCvcod, sItnbr, sSpec, 'WON','1', dItemPrice, dDcRate)
If IsNull(dItemPrice) Then dItemPrice = 0

dw_insert.SetItem(nRow, 'itm_prc', dItemPrice)

return 1
end function

on w_sm01_03010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.dw_lg=create dw_lg
this.rr_1=create rr_1
this.rr_2=create rr_2
this.cbx_1=create cbx_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_lg
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cb_1
end on

on w_sm01_03010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.dw_lg)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.cbx_1)
destroy(this.cb_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_lg.SetTransObject(sqlca)

string sdate

SELECT min(week_sdate) into :sdate FROM pdtweek where week_sdate <= to_char(sysdate, 'yyyymmdd') and week_edate >= to_char(sysdate, 'yyyymmdd');

// 공장구분
dw_1.GetChild('plnt', idw_plnt)
idw_plnt.SetTransObject(SQLCA)
idw_plnt.Retrieve()

dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)

f_mod_saupj(dw_1, 'saupj')

dw_1.setitem(1, 'yymm', sdate)
dw_1.setitem(1, 'gidate', is_today)

dw_1.TriggerEvent(ItemChanged!)
end event

type dw_insert from w_inherite`dw_insert within w_sm01_03010
integer x = 69
integer y = 312
integer width = 4535
integer height = 1948
integer taborder = 140
string dataobject = "d_sm01_03010_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec  dmmqty, davg
Long nJucha, ix, nRow
Int  ireturn
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, snull, get_nm

setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
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
			this.setitem(nrow, 'vndmst_cvnas2', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS2"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'vndmst_cvnas2', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
		
		Post wf_danga(nrow)
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
		gs_gubun = '1'
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
		this.SetItem(lrow, "vndmst_cvnas2", gs_Codename)
		
		Post wf_danga(lrow)
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sm01_03010
integer x = 3922
integer taborder = 70
end type

event p_delrow::clicked;call super::clicked;Long nRow, ix
String sCust, sCvcod, sItnbr, sItdsc

If dw_insert.AcceptText() <> 1 Then Return

scust = Trim(dw_1.GetItemString(1, 'cust'))

//If scust = '8' Then
//	MessageBox('확 인','CKD 자료는 삭제하실 수 없습니다.!!')
//	Return
//End If


If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
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
End If

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

Commit;

p_inq.TriggerEvent(Clicked!)
end event

type p_addrow from w_inherite`p_addrow within w_sm01_03010
integer x = 3749
integer taborder = 60
end type

event p_addrow::clicked;String sYymm, sCust, sSaupj, sPlnt, sNull
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

SetNull(sNull)

sYymm  = Trim(dw_1.GetItemString(1, 'yymm'))
sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))
sCust  = Trim(dw_1.GetItemString(1, 'cust'))
sPlnt  = Trim(dw_1.GetItemString(1, 'plnt'))

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[사업장]')
	Return
End If

If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

If IsNull(sPlnt) Or sPlnt = '' Then
	f_message_chk(1400,'[공장]')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'saupj',  gs_saupj)
dw_insert.SetItem(nRow, 'yymmdd', sYymm)
//dw_insert.SetItem(nRow, 'gubun',  '3')		// 임의 등록
dw_insert.SetItem(nRow, 'gubun',  scust)
dw_insert.SetItem(nRow, 'plnt',  splnt)
dw_insert.SetItem(nRow, 'gate',  splnt)
dw_insert.SetItem(nRow, 'cvcod', dw_1.GetItemString(1, 'cvcod'))
dw_insert.SetItem(nRow, 'vndmst_cvnas2', dw_1.GetItemString(1, 'cvnas'))
dw_insert.SetItem(nRow, 'cnfirm', sNull)

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

end event

type p_search from w_inherite`p_search within w_sm01_03010
integer x = 2976
integer y = 76
integer taborder = 120
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;String sYymm, sdate, edate, sCust, sCvcod, sGidate, sPlnt
Long   nCnt
Int	 ijucha, iRtn, ilsu
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

sCust = trim(dw_1.getitemstring(1, 'cust'))
If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))

syymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ilsu = 0

// VAN에서 읽어올 경우
If sCust = '1' Then
	sGidate = trim(dw_1.getitemstring(1, 'gidate'))
	If IsNull(sGidate) Or sGidate = '' Then
		f_message_chk(1400,'[VAN 기준일자]')
		Return
	End If
	
	ilsu = f_dayterm(sGidate, syymm)
End If

/* 주차 */
select week_sdate, week_ldate, mon_jucha into :sdate, :edate, :ijucha from pdtweek where week_sdate = :syymm;

SELECT COUNT(*) INTO :nCnt FROM SM03_WEEKPLAN_ITEM WHERE SAUPJ = :sSaupj AND YYMMDD = :syymm AND CNFIRM IS NOT NULL;

If nCnt > 0 Then
	MessageBox('확 인','주간 판매계획이 확정되었습니다.!!')
	Return
End If

If MessageBox('확인','기존계획은 삭제됩니다.!!~r~n계속하시겠습니까?',Information!, YesNo!) = 2 Then Return

// VAN에서 읽어올 경우
If sCust = '1' Then
	//프로시저 선언
//	Messagebox(syymm, string(ilsu))
	
	DECLARE SM03_CREATE_DATA_GMDAT procedure for SM03_CREATE_DATA_GMDAT(:sSaupj, :syymm, :sCust, :sCvcod, :ilsu) ;
	Execute SM03_CREATE_DATA_GMDAT;
	
	FETCH SM03_CREATE_DATA_GMDAT INTO :iRtn;
	Choose Case iRtn
		Case 1
			MessageBox('확인', '정상 완료')
		Case -1
			MessageBox('확인', '삭제 실패')
		Case -2
			MessageBox('확인', '자료생성 실패')
	End Choose
	
	COMMIT;
	
	close SM03_CREATE_DATA_GMDAT ;
End If

// 수주에서 읽어올 경우(시판)
If sCust = '6' Then
	/* 소요량 전개된 자료도 삭제 */
	DELETE FROM "SM03_WEEKPLAN_ITEM" A
		WHERE A.SAUPJ = :sSaupj
		  AND A.YYMMDD = :sYymm
		  AND A.GUBUN = :sCust;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인', '삭제 실패')
		RollBack;
		Return
	End If
	 
	INSERT INTO SM03_WEEKPLAN_ITEM
	  ( SAUPJ, YYMMDD, GUBUN, CVCOD, ITNBR, ITM_PRC,
		 ITM_QTY1, ITM_QTY2, ITM_QTY3, ITM_QTY4, ITM_QTY5, ITM_QTY6, ITM_QTY7, 
		 CNFIRM, SANGYN, 
		 QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, PACKQTY, GATE, PLNT )
		SELECT :sSaupj, :SYYMM, '6', B.CVCOD, B.ITNBR, 
			 AVG(B.SPRC) AS SPRC,
			 SUM(DECODE(B.CHA, 1, B.QTY, 0)) AS ITM_QTY1,
			 SUM(DECODE(B.CHA, 2, B.QTY, 0)) AS ITM_QTY2,
			 SUM(DECODE(B.CHA, 3, B.QTY, 0)) AS ITM_QTY3,
			 SUM(DECODE(B.CHA, 4, B.QTY, 0)) AS ITM_QTY4,
			 SUM(DECODE(B.CHA, 5, B.QTY, 0)) AS ITM_QTY5,
			 SUM(DECODE(B.CHA, 6, B.QTY, 0)) AS ITM_QTY6,
			 SUM(DECODE(B.CHA, 7, B.QTY, 0)) AS ITM_QTY7,
			 NULL, NULL,
			 SUM(DECODE(B.CHA, 1, B.QTY, 0)) AS QTY1,
			 SUM(DECODE(B.CHA, 2, B.QTY, 0)) AS QTY2,
			 SUM(DECODE(B.CHA, 3, B.QTY, 0)) AS QTY3,
			 SUM(DECODE(B.CHA, 4, B.QTY, 0)) AS QTY4,
			 SUM(DECODE(B.CHA, 5, B.QTY, 0)) AS QTY5,
			 SUM(DECODE(B.CHA, 6, B.QTY, 0)) AS QTY6,
			 SUM(DECODE(B.CHA, 7, B.QTY, 0)) AS QTY7,
			 0 AS PACKQTY,
			 'Z1' AS GATE,
			 'Z1' AS PLNT
	  FROM ( SELECT A.CVCOD, A.ITNBR, A.ORDER_PRC AS SPRC, A.ORDER_QTY - A.OUT_QTY AS QTY, A.CUST_NAPGI AS NAPGI,
					  TO_DATE(A.CUST_NAPGI,'YYYYMMDD') - TO_DATE(:SYYMM,'YYYYMMDD')+1 AS CHA
				FROM SORDER A
			  WHERE A.SABU = :gs_sabu
				 AND A.CUST_NAPGI BETWEEN :sDate AND :eDate
				 AND A.SUJU_STS IN ( '2', '5','6','7' )
				 AND A.SAUPJ = :sSaupj
			  ) B
	 GROUP BY B.CVCOD, B.ITNBR;

	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		MessageBox('확인', '자료생성 실패')
		RollBack;
		Return
	End If

	COMMIT;
	
	MessageBox('확인', '정상 완료')
End If

// KD,AS인 경우
If sCust = '7' Or sCust = '8' Then
	sPlnt = trim(dw_1.getitemstring(1, 'plnt'))
	If IsNull(sPlnt) Or sPlnt = '' Then
		f_message_chk(1400,'[공장]')
		Return
	End If
	
	/* 기존내역  삭제 */
	DELETE FROM "SM03_WEEKPLAN_ITEM" A
		WHERE A.SAUPJ = :sSaupj
		  AND A.YYMMDD = :sYymm
		  AND A.GUBUN  = :sCust
		  AND A.PLNT   = :sPlnt;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인', '삭제 실패')
		RollBack;
		Return
	End If
	 
	// 공장별 재고내역에서 해당 품목을 읽어온다
	INSERT INTO SM03_WEEKPLAN_ITEM
	  ( SAUPJ, YYMMDD, GUBUN, CVCOD, ITNBR, ITM_PRC,
		 ITM_QTY1, ITM_QTY2, ITM_QTY3, ITM_QTY4, ITM_QTY5, ITM_QTY6, ITM_QTY7,
		 CNFIRM, SANGYN,
		 QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, PACKQTY, GATE, PLNT )
	 SELECT :gs_saupj, :syymm, :sCust, B.RFNA2, A.ITNBR, fun_erp100000012_1(:SYYMM, B.RFNA2, A.ITNBR, '1'),
	        0,0,0,0,0,0,0,
	        NULL, NULL,
	        0,0,0,0,0,0,0, A.PACKQTY, A.PLNT, A.PLNT
	   FROM STOCK_NAPUM A, REFFPF B
	  WHERE A.PLNT = :sPlnt
	    AND A.PLNT = B.RFGUB
	    AND B.RFCOD = '8I';

	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		MessageBox('확인', '자료생성 실패')
		RollBack;
		Return
	End If

	COMMIT;
	
	MessageBox('확인', '정상 완료')	
End If

// 생성된 내역 조회
p_inq.TriggerEvent(Clicked!)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm01_03010
boolean visible = false
integer x = 4425
integer y = 220
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm01_03010
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_sm01_03010
integer taborder = 100
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()

end event

type p_print from w_inherite`p_print within w_sm01_03010
boolean visible = false
integer x = 1861
integer y = 80
integer taborder = 130
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

event p_print::clicked;String syymm
Int    ix
String sSaupj

syymm = trim(dw_1.getitemstring(1, 'yymm'))

If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

IF MessageBox("확인", '기종별 계획에 대한 소요량을 계산합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_sm01_03010_3'
dw_insert.SetTransObject(sqlca)
cbx_1.Checked = True

/* 차종별 */
DELETE FROM "SM03_WEEKPLAN_ITEM"
	WHERE SAUPJ = :sSaupj
	  AND YYMMDD = :sYymm
	  AND GUBUN  = '2';
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	RollBack;
	Return
End If

INSERT INTO "SM03_WEEKPLAN_ITEM"
		( "SAUPJ", 				  "YYMMDD",             "GUBUN",						 "CVCOD",              "ITNBR",
		  "ITM_PRC",
		  "ITM_QTY1",             "ITM_QTY2",              "ITM_QTY3",
		  "ITM_QTY4",             "ITM_QTY5",              "ITM_QTY6",              "ITM_QTY7" )
SELECT :sSaupj,					X.YYMM, 					'2',						X.CVCOD, X.ITNBR, 0 AS SPRC,
	   SUM(S1QTY) AS S1QTY,	   SUM(S2QTY) AS S2QTY,	   SUM(S3QTY) AS S3QTY,
	   SUM(S4QTY) AS S4QTY,	   SUM(S5QTY) AS S5QTY,	   SUM(S6QTY) AS S6QTY, SUM(S7QTY) AS S7QTY
  FROM ( SELECT :SYYMM AS YYMM,
			 B.CVCOD,
			 A.ITNBR,
			 0 AS SPRC,
			 ROUND(A.S1QTY * B.USAGE /100,0) AS S1QTY,
			 ROUND(A.S2QTY * B.USAGE /100,0) AS S2QTY,
			 ROUND(A.S3QTY * B.USAGE /100,0) AS S3QTY,
			 ROUND(A.S4QTY * B.USAGE /100,0) AS S4QTY,
			 ROUND(A.S5QTY * B.USAGE /100,0) AS S5QTY,
			 ROUND(A.S6QTY * B.USAGE /100,0) AS S6QTY,
			 ROUND(A.S7QTY * B.USAGE /100,0) AS S7QTY
	  FROM ( SELECT B.ITNBR,
					 SUM(A.S1QTY * B.USAGE) AS S1QTY,
					 SUM(A.S2QTY * B.USAGE) AS S2QTY,
					 SUM(A.S3QTY * B.USAGE) AS S3QTY,
					 SUM(A.S4QTY * B.USAGE) AS S4QTY,
					 SUM(A.S5QTY * B.USAGE) AS S5QTY,
					 SUM(A.S6QTY * B.USAGE) AS S6QTY,
					 SUM(A.S7QTY * B.USAGE) AS S7QTY
			  FROM SM03_WEEKPLAN_CAR A, CARBOM B
			 WHERE A.SAUPJ = :sSaupj AND A.YYMMDD = :SYYMM
				AND A.CARCODE = B.CARCODE
				AND A.CARSEQ  = B.SEQ
			 GROUP BY B.ITNBR ) A,
			  ITMBUY B
	 WHERE A.ITNBR = B.ITNBR  ) X
  GROUP BY X.YYMM, X.CVCOD, X.ITNBR;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	RollBack;
	Return
End If

COMMIT;

dw_insert.Retrieve(sSaupj, syymm, '2')

/* 판매 기본단가,할인율를 구한다 */
For ix = 1 To dw_insert.RowCount()
	wf_danga(ix)
Next

If dw_insert.Update() <> 1 Then
	RollBack;
End If

COMMIT;

dw_insert.SetRedraw(True)
end event

type p_inq from w_inherite`p_inq within w_sm01_03010
integer x = 3570
end type

event p_inq::clicked;String syymm, scust, sDate, edate, sCvcod, sSarea
String sSaupj, sGrpnam, sPlnt

If dw_1.AcceptText() <> 1 Then Return

syymm = trim(dw_1.getitemstring(1, 'yymm'))
scust = trim(dw_1.getitemstring(1, 'cust'))
sCvcod= trim(dw_1.getitemstring(1, 'cvcod'))
sSarea= trim(dw_1.getitemstring(1, 'sarea'))
sGrpnam = trim(dw_1.getitemstring(1, 'grpnam'))
sPlnt = trim(dw_1.getitemstring(1, 'plnt'))

If IsNull(sCvcod) Then sCvcod = ''
If IsNull(sSarea) Then sSarea = ''
If IsNull(sGrpnam) Then sGrpnam = ''
If IsNull(sPlnt) Then sPlnt = ''

If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;

/* lg인 경우 */
If cbx_1.Checked = TRUE And sCust = '2' Then
	If dw_insert.Retrieve(sSaupj, sdate, edate) <= 0 Then
		f_message_chk(50,'')
	End If
Else
	If dw_insert.Retrieve(sSaupj, syymm, sCust+'%', '%', sSarea+'%', sPlnt+'%') <= 0 Then
		f_message_chk(50,'')
	End If
End If
end event

type p_del from w_inherite`p_del within w_sm01_03010
boolean visible = false
integer x = 4206
integer y = 232
integer taborder = 90
end type

type p_mod from w_inherite`p_mod within w_sm01_03010
integer x = 4096
integer taborder = 80
end type

event p_mod::clicked;Long ix, nRow
String sCust, sItnbr, sCvcod, sPlnt, sGate

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

/* 품목별 계획일 경우 체크 */
scust = Trim(dw_1.GetItemString(1, 'cust'))

nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
	sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
	sPlnt  = Trim(dw_insert.GetItemString(ix, 'plnt'))
	sGate  = Trim(dw_insert.GetItemString(ix, 'gate'))
	
	If IsNull(sCvcod) Or sCvcod = '' Then
		f_message_chk(1400,'[거래처]')
		Return
	End If
	If IsNull(sItnbr) Or sItnbr = '' Then
		f_message_chk(1400,'[품번]')
		Return
	End If

	If IsNull(sPlnt) Or sPlnt = '' Then
		sPlnt = '.'
		dw_insert.SetItem(ix, 'plnt', '.')
	End If
	If IsNull(sGate) Or sGate = '' Then
		dw_insert.SetItem(ix, 'gate', sCvcod)
	End If
Next

If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;
ib_any_typing = false

MessageBox('확 인','저장하였습니다')
end event

type cb_exit from w_inherite`cb_exit within w_sm01_03010
end type

type cb_mod from w_inherite`cb_mod within w_sm01_03010
end type

type cb_ins from w_inherite`cb_ins within w_sm01_03010
end type

type cb_del from w_inherite`cb_del within w_sm01_03010
end type

type cb_inq from w_inherite`cb_inq within w_sm01_03010
end type

type cb_print from w_inherite`cb_print within w_sm01_03010
end type

type st_1 from w_inherite`st_1 within w_sm01_03010
end type

type cb_can from w_inherite`cb_can within w_sm01_03010
end type

type cb_search from w_inherite`cb_search within w_sm01_03010
end type







type gb_button1 from w_inherite`gb_button1 within w_sm01_03010
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_03010
end type

type dw_1 from u_key_enter within w_sm01_03010
integer x = 78
integer y = 60
integer width = 2757
integer height = 192
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm01_03010_1"
boolean border = false
end type

event itemchanged;String sDate, sNull, s_cvcod,get_nm, sSaupj, sPlnt
Long   nCnt

SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 판매계획은 월요일부터 생성가능합니다.!!')
			Return 1
			Return
		End If
		
		/* 사업장 체크 */
		sSaupj= Trim(GetItemString(1, 'saupj'))
		If IsNull(sSaupj) Or sSaupj = '' Then
			f_message_chk(1400, '[사업장]')
			SetFocus()
			SetColumn('saupj')
			Return 1
		End If

		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			SELECT COUNT(*) INTO :nCnt FROM SM03_WEEKPLAN_ITEM WHERE SAUPJ = :sSaupj AND YYMMDD = :sDate AND CNFIRM IS NOT NULL;
			If nCnt > 0 Then
				MessageBox('확 인','주간 판매계획이 마감처리 되어있습니다.!!')
				p_search.Enabled = False
//				p_print.Enabled = False
				p_mod.Enabled = False
				p_addrow.Enabled = False
				p_delrow.Enabled = False
//				p_del.Enabled = False
				p_search.PictureName = 'C:\erpman\image\생성_d.gif'
//				p_print.PictureName = 'C:\erpman\image\소요량계산_d.gif'
				p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
				p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
				p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
//				p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
			Else
				p_search.Enabled = True
//				p_print.Enabled = True
				p_mod.Enabled = True
				p_addrow.Enabled = True
				p_delrow.Enabled = True
//				p_del.Enabled = True
				p_search.PictureName = 'C:\erpman\image\생성_up.gif'
//				p_print.PictureName = 'C:\erpman\image\소요량계산_up.gif'
				p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
				p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
				p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
//				p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
			End If
		End If
	// 고객구분
	Case 'cust'
		sDate = Trim(GetText())
		
		idw_plnt.SetFilter("rfna3 = '" + sDate +"'")
		idw_plnt.Filter()
		//SetItem(1, 'plnt', idw_plnt.GetItemSTring(1, 'rfgub'))
		SetItem(1, 'plnt', sNull)
	Case 'plnt'
		sPlnt = this.GetText()								
		
		If sPlnt = '.' or sPlnt = 'Z1' Then
			p_inq.PostEvent(Clicked!)
		End If
		
		if sPlnt = "" or sPlnt = "." or isnull(sPlnt) then 
			this.setitem(1, 'cvcod', snull)
			return 
		end if
		
		SELECT a.rfna2 , v.cvnas2
		  INTO :s_cvcod, :get_nm  
		  FROM reffpf a , vndmst v
		 WHERE a.sabu = '1'
		   and a.rfcod = '8I'
			and a.rfgub = :sPlnt
			and a.rfna2 = v.cvcod(+);
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvcod', s_cvcod)
			this.setitem(1, 'cvnas', get_nm)
		else
			return 1
		end if
		
		p_inq.PostEvent(Clicked!)
	Case 'cvcod'
		s_cvcod = Trim(GetText())
		
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if	
End Choose
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_code = this.GetText()
	IF Gs_code ="" OR IsNull(gs_code) THEN 
		gs_code =""
	END IF
	
//	gs_gubun = '2'
	Open(w_vndmst_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  
		this.SetItem(lrow, "cvcod", snull)
		this.SetItem(lrow, "cvnas", snull)
   	return
   ELSE
		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
			f_message_chk(37,'[거래처]') 
			this.SetItem(lRow, "cvcod", sNull)
		   this.SetItem(lRow, "cvnas", sNull)
			RETURN  1
		END IF
   END IF	

	this.SetItem(lrow, "cvcod", gs_Code)
	this.SetItem(lrow, "cvnas", gs_Codename)
END IF

end event

type dw_3 from datawindow within w_sm01_03010
boolean visible = false
integer x = 901
integer y = 316
integer width = 1189
integer height = 108
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_03010_lg_2"
boolean border = false
boolean livescroll = true
end type

type dw_lg from datawindow within w_sm01_03010
boolean visible = false
integer x = 2107
integer y = 328
integer width = 1134
integer height = 100
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_03010_lg"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sm01_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 296
integer width = 4558
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm01_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 40
integer width = 2912
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_1 from checkbox within w_sm01_03010
boolean visible = false
integer x = 3703
integer y = 400
integer width = 795
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품목별 주간계획(가전) 확인"
end type

event clicked;String syymm, sCust, sDate, eDate, sCvcod, sSaupj

syymm  = trim(dw_1.getitemstring(1, 'yymm'))
sCust  = trim(dw_1.getitemstring(1, 'cust'))
sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
If IsNull(sCvcod) Then sCvcod = ''

If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

If This.Checked = false Then
	dw_insert.DataObject = 'd_sm01_03010_3'
	dw_insert.SetTransObject(sqlca)
	
	If dw_insert.Retrieve(sSaupj, syymm, sCust, sCvcod+'%') <= 0 Then
		f_message_chk(50,'')
	End If	
Else
	dw_insert.DataObject = 'd_sm01_03010_lg_1'
	dw_insert.SetTransObject(sqlca)
	
	select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;
	
	If dw_insert.Retrieve(sSaupj, sDate, eDate) <= 0 Then
		f_message_chk(50,'')
	End If
End If
end event

type cb_1 from commandbutton within w_sm01_03010
boolean visible = false
integer x = 3223
integer y = 172
integer width = 402
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
end type

event clicked;String sYymm, sdate, edate, sCust, sCvcod, sGidate, sPlnt
Long   nCnt
Int	 ijucha, iRtn, ilsu
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

sCust = trim(dw_1.getitemstring(1, 'cust'))
If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))

syymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ilsu = 0

// VAN에서 읽어올 경우
If sCust = '1' Then
	sGidate = trim(dw_1.getitemstring(1, 'gidate'))
	If IsNull(sGidate) Or sGidate = '' Then
		f_message_chk(1400,'[VAN 기준일자]')
		Return
	End If
	
	ilsu = f_dayterm(sGidate, syymm)
End If

messagebox('ilsu',string(ilsu))
end event

