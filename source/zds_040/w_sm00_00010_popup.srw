$PBExportHeader$w_sm00_00010_popup.srw
$PBExportComments$년 판매계획 접수
forward
global type w_sm00_00010_popup from w_inherite_popup
end type
type st_2 from statictext within w_sm00_00010_popup
end type
type st_3 from statictext within w_sm00_00010_popup
end type
type rr_2 from roundrectangle within w_sm00_00010_popup
end type
end forward

global type w_sm00_00010_popup from w_inherite_popup
integer width = 2043
integer height = 1264
string title = "년 판매계획 생성"
st_2 st_2
st_3 st_3
rr_2 rr_2
end type
global w_sm00_00010_popup w_sm00_00010_popup

on w_sm00_00010_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.rr_2
end on

on w_sm00_00010_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_2)
end on

event open;call super::open;String sYear, sStrmm
Int    nChasu

syear = gs_code
nChasu = Dec(gs_gubun)

dw_1.SettransObject(Sqlca)
dw_jogun.SettransObject(Sqlca)

dw_jogun.InsertRow(0)

f_mod_saupj(dw_jogun, 'saupj')


SELECT MAX(STRMM) INTO :sStrmm FROM SM01_YEARPLAN 
 WHERE SABU = :gs_sabu 
	AND SAUPJ = :gs_saupj 
	AND YYYY = :syear
	AND CHASU = :nChasu;
If IsNull(sStrmm) Or sStrmm = '' Then
	MessageBox('확인','계획시작월을 지정하세요.!!')
End If
			
dw_jogun.SetItem(1, 'year',  sYear)
dw_jogun.SetItem(1, 'chasu', nChasu)
dw_jogun.SetItem(1, 'strmm', sStrmm)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm00_00010_popup
integer y = 28
integer width = 1746
integer height = 976
string dataobject = "d_sm00_00010_popup_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sCust, sYn, smm

Choose Case GetColumnName()
	Case 'strmm'
		smm = Trim(GetText())
		If len(smm) <> 2 Then
			MessageBox('확인','계획시작월은 2자리수로 지정하세요')
			Return 1
		End If
	Case 'cust'
		sCust = Trim(GetText())
		
		dw_1.Retrieve(sCust)
	Case 's1' // 현대 엔진 선택한 경우 기아/CKD/파워텍 동일 적용
		sYn = Trim(GetText())
		
		SetItem(row, 's7', sYn)
		SetItem(row, 's10', sYn)
	Case 's2' // 현대 미션a/t 선택한 경우 기아/CKD/파워텍 동일 적용
		sYn = Trim(GetText())
		
		SetItem(row, 's8', sYn)
		SetItem(row, 's11', sYn)
		SetItem(row, 's13', sYn)
	Case 's14' // 현대 미션m/t 선택한 경우 기아/CKD/파워텍 동일 적용
		sYn = Trim(GetText())
		
		SetItem(row, 's15', sYn)
		SetItem(row, 's16', sYn)
		SetItem(row, 's17', sYn)
	Case 's3' // 현대 의장 선택한 경우 기아/CKD/파워텍 동일 적용
		sYn = Trim(GetText())
		
		SetItem(row, 's9', sYn)
		SetItem(row, 's12', sYn)		
End Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_sm00_00010_popup
integer x = 1847
integer y = 4
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_sm00_00010_popup
boolean visible = false
integer x = 1650
integer y = 628
boolean enabled = false
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

event p_inq::clicked;String sYear, sCust, sCvcod, sToday, sCrtgb
String sChk[6], sCargbn1, sCargbn2
Long   ix
String sSaupj

If dw_jogun.AcceptText() <> 1 Then Return

sYear = trim(dw_jogun.getitemstring(1, 'year'))
If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_jogun.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('saupj')
	Return
End If

sCust = trim(dw_jogun.getitemstring(1, 'cust'))
If IsNull(sCust) Or sCust = '' Then
	f_message_chk(1400,'[고객구분]')
	Return
End If

IF MessageBox("확인", '기존 자료가 존재할 경우 삭제후 생성합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

sToday = f_today()

For ix = 1 To dw_1.RowCount()
	If dw_1.GetItemString(ix, 'chk') = 'N' Then Continue

	sCvcod = dw_1.GetItemString(ix, 'cvcod')

	/* 기존자료 삭제 - 차종,기종 */
//	DELETE FROM "SM01_YEARPLAN"
//	 WHERE SABU = :gs_sabu 
//		AND YYYY = :sYear
//		AND CVCOD = :sCvcod
//		AND GUBUN = :sCust
//		AND SAUPJ = :sSaupj;
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//		RollBack;
//		Return
//	End If
	
	// 단가마스터에 등록된 품목내역 조회
	INSERT INTO SM01_YEARPLAN
					( SABU, YYYY, CVCOD, ITNBR,    GUBUN, ITDSC, SAUPJ, PLAN_PRC,
					  QTY_01, QTY_02, QTY_03, QTY_04, QTY_05, QTY_06, QTY_07, QTY_08, QTY_09, QTY_10, QTY_11, QTY_12,
					  AMT_01, AMT_02, AMT_03, AMT_04, AMT_05, AMT_06, AMT_07, AMT_08, AMT_09, AMT_10, AMT_11, AMT_12 )
		SELECT DISTINCT :gs_sabu, :sYear, A.CVCOD, A.ITNBR, :sCust, I.ITDSC, :sSaupj, 0,
				 0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
		  FROM VNDDAN A, ITEMAS I 
		 WHERE A.CVCOD = :sCvcod 
		   AND A.START_DATE <= :sToday 
			AND A.END_DATE >= :sToday
			AND A.ITNBR = I.ITNBR
			AND I.USEYN = '0'
			AND I.ITTYP = '1'
			AND NOT EXISTS ( SELECT * FROM SM01_YEARPLAN B 
			                  WHERE B.SABU = :gs_sabu AND B.YYYY = :syear 
									  AND B.CVCOD = A.CVCOD
									  AND B.ITNBR = A.ITNBR 
									  AND B.SAUPJ = :sSaupj
									  AND B.GUBUN = :sCust );
	If sqlca.sqlcode <> 0 Then
		MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		Rollback;
		Return
	End If
  
	// 단가 저장
	UPDATE "SM01_YEARPLAN"
	  SET PLAN_PRC = fun_erp100000012_1(:sYear||'0101', CVCOD, ITNBR, '1')
	 WHERE SABU = :gs_sabu 
		AND YYYY = :sYear
		AND CVCOD = :sCvcod
		AND GUBUN = :sCust
		AND SAUPJ = :sSaupj;
	If sqlca.sqlcode <> 0 Then
		MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		Rollback;
		Return
	End IF
	
	COMMIT;
Next
	
MessageBox('확 인','생성되었습니다.!!')
end event

type p_choose from w_inherite_popup`p_choose within w_sm00_00010_popup
integer x = 1847
integer y = 216
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

event p_choose::clicked;String sYear, sCust, sCvcod, sToday, sCrtgb, sGubun, sStrmm
String sChk[17], sCargbn1, sCargbn2
Long   ix, iMax, nchasu
String sSaupj

If dw_jogun.AcceptText() <> 1 Then Return

sYear = trim(dw_jogun.getitemstring(1, 'year'))
If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

sStrmm = trim(dw_jogun.getitemstring(1, 'strmm'))
If f_datechk('2004'+sStrmm+'01') <> 1 Then
	f_message_chk(1400,'[계획시작월]')
	Return
End If

nchasu = dw_jogun.getitemnumber(1, 'chasu')
If IsNull(nchasu) Or nchasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_jogun.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('saupj')
	Return
End If

IF MessageBox("확인", '차종내역을 생성합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

sToday = f_today()

SetPointer(HourGlass!)

For ix = 1 To 17
	sChk[ix] = dw_jogun.GetItemString(1, 's'+string(ix))

	sCargbn1 = 'X'
	sCargbn2 = 'X'
	
	// 현대-엔진	==> 정규
	If ix = 1 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'E'
		sGubun   = '1'
	End If
	
	// 현대-미션(A/T)
	If ix = 2 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'T'
		sGubun   = '1'
	End If
	
	// 현대-의장
	If ix = 3 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'D'
		sGubun   = '1'
	End If
	
	// LG
	If ix = 4 And sChk[ix] = 'Y' Then
//		sCargbn1 = '0'		<== 기종으로 수립시 풀어줌
		sCargbn1 = '9'		// 품목별 계획수립시 풀어줌
		sCargbn2 = '9'
		sGubun   = '2'
	End If
	
	// 대림
	If ix = 5 And sChk[ix] = 'Y' Then
//		sCargbn1 = '1'	// 최초 대림 차종으로 전개하나 이후 품목(기타)으로 변경됨
		sCargbn1 = '9'
		sCargbn2 = '9'
		sGubun   = '3'
	End If
	
	// 기타
	If ix = 6 And sChk[ix] = 'Y' Then
		sCargbn1 = '9'
		sCargbn2 = '9'
		sGubun   = '9'
	End If
	
	// 기아-엔진	==> A/S
	If ix = 7 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'E'
		sGubun   = '7'
	End If
	
	// 기아-미션(A/T)
	If ix = 8 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'T'
		sGubun   = '7'
	End If
	
	// 기아-의장
	If ix = 9 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'D'
		sGubun   = '7'
	End If
	
	// CKD-엔진  : 	==> KD
	If ix = 10 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'E'
		sGubun   = '8'
	End If
	
	// CKD-미션(A/T)
	If ix = 11 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'T'
		sGubun   = '8'
	End If
	
	// CKD-의장
	If ix = 12 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'D'
		sGubun   = '8'
	End If

	// 파워텍-미션(A/T)
	If ix = 13 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'T'
		sGubun   = 'A'
	End If
	
	// 현대-미션(M/T)
	If ix = 14 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'M'
		sGubun   = '1'
	End If
	
	// 기아-미션(M/T)
	If ix = 15 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'M'
		sGubun   = '7'
	End If

	// CKD-미션(M/T) : CKD 는 차종구성을 별도로 하지 않고 현대차종을 따라간다 sCargbn1 = 'C' --> sCargbn1 = 'E' 변경
	If ix = 16 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'M'
		sGubun   = '8'
	End If

	// 파워텍-미션(M/T)
	If ix = 17 And sChk[ix] = 'Y' Then
		sCargbn1 = 'E'
		sCargbn2 = 'M'
		sGubun   = 'A'
	End If
	
	// 미지정시 skip
	If sCargbn1 = 'X' Then Continue
	
	sCrtgb = sCargbn1+sCargbn2
	
	// 기타인 경우 품목별 계획수립
	If sCargbn1 = '9' And sCargbn2 = '9' And ( sGubun = '2' Or sGubun = '3' Or sGubun = '9') Then	
		// lg/대림를 제외한 나머지는 99로 설정
		If sGubun <> '2' And sGubun <> '3' Then
			sGubun = '99'
		
			INSERT INTO SM01_YEARPLAN
							( SABU, YYYY, CVCOD, ITNBR,    GUBUN, ITDSC, SAUPJ, PLAN_PRC,
							  QTY_01, QTY_02, QTY_03, QTY_04, QTY_05, QTY_06, QTY_07, QTY_08, QTY_09, QTY_10, QTY_11, QTY_12,
							  AMT_01, AMT_02, AMT_03, AMT_04, AMT_05, AMT_06, AMT_07, AMT_08, AMT_09, AMT_10, AMT_11, AMT_12,
							  CHASU, STRMM)
				SELECT DISTINCT :gs_sabu, :sYear, A.CVCOD, A.ITNBR, :sGubun, I.ITDSC, :sSaupj, fun_erp100000012(:sYear||'0101', A.CVCOD, A.ITNBR),
						 0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,
						 :nChasu, :sStrmm
				  FROM CARBOM_VND A, ITEMAS I, VNDMST V 
				 WHERE A.CARGBN1 = :sCargbn1 AND A.CARGBN2 = :sCargbn2
					AND A.ITNBR = I.ITNBR
					AND I.USEYN = '0'
					AND I.ITTYP = '1'
					AND A.CVCOD = V.CVCOD
					AND V.OUTGU <> '2'
					AND V.OUTGU <> '3'
					AND NOT EXISTS ( SELECT * FROM SM01_YEARPLAN B 
											WHERE B.SABU = :gs_sabu AND B.YYYY = :syear 
											  AND B.CVCOD = A.CVCOD
											  AND B.ITNBR = A.ITNBR 
											  AND B.SAUPJ = :sSaupj
											  AND B.GUBUN = :sGubun
											  AND B.CHASU = :nChasu);
		Else
			INSERT INTO SM01_YEARPLAN
							( SABU, YYYY, CVCOD, ITNBR,    GUBUN, ITDSC, SAUPJ, PLAN_PRC,
							  QTY_01, QTY_02, QTY_03, QTY_04, QTY_05, QTY_06, QTY_07, QTY_08, QTY_09, QTY_10, QTY_11, QTY_12,
							  AMT_01, AMT_02, AMT_03, AMT_04, AMT_05, AMT_06, AMT_07, AMT_08, AMT_09, AMT_10, AMT_11, AMT_12,
							  CHASU, STRMM )
				SELECT DISTINCT :gs_sabu, :sYear, A.CVCOD, A.ITNBR, :sGubun, I.ITDSC, :sSaupj, fun_erp100000012(:sYear||'0101', A.CVCOD, A.ITNBR),
						 0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,
						 :nChasu, :sStrmm
				  FROM CARBOM_VND A, ITEMAS I, VNDMST V 
				 WHERE A.CARGBN1 = :sCargbn1 AND A.CARGBN2 = :sCargbn2
					AND A.ITNBR = I.ITNBR
					AND I.USEYN = '0'
					AND I.ITTYP = '1'
					AND A.CVCOD = V.CVCOD
					AND ( V.OUTGU = '2' OR V.OUTGU = '3' )
					AND NOT EXISTS ( SELECT * FROM SM01_YEARPLAN B 
											WHERE B.SABU = :gs_sabu AND B.YYYY = :syear 
											  AND B.CVCOD = A.CVCOD
											  AND B.ITNBR = A.ITNBR 
											  AND B.SAUPJ = :sSaupj
											  AND B.GUBUN = :sGubun
											  AND B.CHASU = :nChasu );			
		End If
		If sqlca.sqlcode <> 0 Then
			MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
			Rollback;
			Return
		End If
	Else
		// Max 값 
		SELECT MAX(BASE_SEQ) INTO :iMax FROM SM01_YEARPLAN_CAR WHERE SAUPJ = :sSaupj AND BASE_YEAR = :sYear AND CHASU = :nChasu;
		If IsNull(iMax) Then iMax = 0
		
		// 차종구성내역 생성 - 미션인 경우에는 계열/기종이 입력된 자료만 생성
		If sCargbn2 = 'T' Or sCargbn2 = 'M' Then
			INSERT INTO SM01_YEARPLAN_CAR
						( SAUPJ, BASE_YEAR, BASE_SEQ, CARCODE, CARSEQ, CARGBN1, CARGBN2,
						  YQTY01, YQTY02, YQTY03, YQTY04, YQTY05, YQTY06, YQTY07, YQTY08, YQTY09, YQTY10, YQTY11, YQTY12,
						  GUBUN, CHASU, STRMM )
				SELECT :sSaupj, :sYear, :imax + rownum, A.CARCODE, A.SEQ, A.CARGBN1, A.CARGBN2,
						 0,0,0,0,0,0,0,0,0,0,0,0, :sGubun, :nChasu, :sStrmm
				  FROM CARMST A 
				 WHERE A.CARGBN1 = :sCargbn1 AND A.CARGBN2 = :sCargbn2
			      AND A.SCD8D IS NOT NULL AND A.SCD8E IS NOT NULL
				   AND NOT EXISTS ( SELECT * FROM SM01_YEARPLAN_CAR B WHERE B.SAUPJ = :sSaupj AND B.BASE_YEAR = :syear
											  AND B.CARCODE = A.CARCODE
											  AND B.CARSEQ = A.SEQ
											  AND B.CARGBN1 = A.CARGBN1
											  AND B.CARGBN2 = A.CARGBN2
											  AND B.GUBUN = :sGubun
											  AND B.CHASU = :nChasu);
		Else
			INSERT INTO SM01_YEARPLAN_CAR
						( SAUPJ, BASE_YEAR, BASE_SEQ, CARCODE, CARSEQ, CARGBN1, CARGBN2,
						  YQTY01, YQTY02, YQTY03, YQTY04, YQTY05, YQTY06, YQTY07, YQTY08, YQTY09, YQTY10, YQTY11, YQTY12,
						  GUBUN, CHASU, STRMM )
				SELECT :sSaupj, :sYear, :imax + rownum, A.CARCODE, A.SEQ, A.CARGBN1, A.CARGBN2,
						 0,0,0,0,0,0,0,0,0,0,0,0, :sGubun, :nChasu, :sStrmm
				  FROM CARMST A WHERE A.CARGBN1 = :sCargbn1 AND A.CARGBN2 = :sCargbn2
				  AND NOT EXISTS ( SELECT * FROM SM01_YEARPLAN_CAR B WHERE B.SAUPJ = :sSaupj AND B.BASE_YEAR = :syear
											  AND B.CARCODE = A.CARCODE
											  AND B.CARSEQ = A.SEQ
											  AND B.CARGBN1 = A.CARGBN1
											  AND B.CARGBN2 = A.CARGBN2
											  AND B.GUBUN = :sGubun
											  AND B.CHASU = :nChasu);
		End If
		
		If sqlca.sqlcode <> 0 Then
			MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
			Rollback;
			Return
		End If
	End If
	
	COMMIT;
Next

MessageBox('확 인','생성되었습니다.!!')
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm00_00010_popup
boolean visible = false
integer x = 46
integer y = 1120
integer width = 1541
integer height = 980
string dataobject = "d_sm00_00010_popup_2"
end type

type sle_2 from w_inherite_popup`sle_2 within w_sm00_00010_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm00_00010_popup
boolean visible = false
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_sm00_00010_popup
boolean visible = false
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm00_00010_popup
boolean visible = false
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm00_00010_popup
end type

type st_1 from w_inherite_popup`st_1 within w_sm00_00010_popup
end type

type st_2 from statictext within w_sm00_00010_popup
integer x = 46
integer y = 1040
integer width = 1659
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "* 계획시작월이 M월로 지정된 경우 소요량 계산시 1월~~M-1월까지"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm00_00010_popup
integer x = 46
integer y = 1104
integer width = 1659
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "  실적을 집계하여 품목별 계획수량으로 집계합니다."
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sm00_00010_popup
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 1116
integer width = 1573
integer height = 996
integer cornerheight = 40
integer cornerwidth = 55
end type

