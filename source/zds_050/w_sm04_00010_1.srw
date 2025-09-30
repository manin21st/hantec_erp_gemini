$PBExportHeader$w_sm04_00010_1.srw
$PBExportComments$출하물량 접수
forward
global type w_sm04_00010_1 from w_inherite_popup
end type
type dw_3 from datawindow within w_sm04_00010_1
end type
type dw_lg from datawindow within w_sm04_00010_1
end type
type dw_insert from datawindow within w_sm04_00010_1
end type
type st_2 from statictext within w_sm04_00010_1
end type
type st_3 from statictext within w_sm04_00010_1
end type
type rr_2 from roundrectangle within w_sm04_00010_1
end type
type rr_1 from roundrectangle within w_sm04_00010_1
end type
end forward

global type w_sm04_00010_1 from w_inherite_popup
integer width = 2043
integer height = 1532
string title = "출하의뢰 접수"
boolean controlmenu = true
dw_3 dw_3
dw_lg dw_lg
dw_insert dw_insert
st_2 st_2
st_3 st_3
rr_2 rr_2
rr_1 rr_1
end type
global w_sm04_00010_1 w_sm04_00010_1

forward prototypes
public function integer wf_num (string arg_num)
public function integer wf_hkcd6 (integer li_filenum)
public function integer wf_hkcd2 (integer li_filenum)
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

public function integer wf_hkcd6 (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate
Long   nRow

dw_insert.Reset()
DO WHILE FileRead(li_FileNum, sLine) > 0
	sItnbr = ''
	sCvcod = ''

	/* 공장구분 - 거래처 */
	sTemp = Trim(Mid(sLine,17,2))	
	If IsNull(sTemp) Or sTemp = '' Or sTemp <> 'Y' Then Continue
	
	nRow = dw_insert.InsertRow(0)
	
	dw_insert.SetItem(nRow, "SEQ1", 		Trim(Mid(sLine,1 ,12)))
	dw_insert.SetItem(nRow, "SEQ2", 		Trim(Mid(sLine,13,4)))
	
	SELECT RFNA2 INTO :sCvcod FROM REFFPF WHERE RFCOD = '8I' AND RFGUB = :sTemp;
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

If dw_insert.Update() <> 1 Then
	RollBack;
	Return -1
End If

COMMIT;

return nRow
end function

public function integer wf_hkcd2 (integer li_filenum);String sLine, sItnbr, sCvcod, sTemp, sDate
Long   nRow
DataStore ds

SetPointer(HourGlass!)

sDate = dw_1.GetItemString(1, 'yymmdd')
If IsNull(sDate) Or sDate = '' then Return -1

/* HMC 주간 소요량 */
ds = create datastore
ds.dataobject = 'd_hkcd2'
ds.SetTransobject(sqlca)

DO WHILE FileRead(li_FileNum, sLine) > 0
	
	If sdate <> Trim(Mid(sLine,3 ,8)) Then Continue
	
	nRow = ds.InsertRow(0)
	
	sItnbr = ''
	sCvcod = ''
	
	ds.SetItem(nRow, "SEQ1", 		Trim(Mid(sLine,1 ,12)))
	ds.SetItem(nRow, "SEQ2", 		Trim(Mid(sLine,13,4)))
	/* 공장구분 - 거래처 */
	sTemp = Trim(Mid(sLine,17,2))
	
	SELECT RFNA2 INTO :sCvcod FROM REFFPF WHERE RFCOD = '8I' AND RFGUB = :sTemp;
	If IsNull(sCvcod) Or sCvcod = '' Then
		ds.Setitem(nRow, 'ERR_V', 'V')
	End If
	ds.SetItem(nRow, "SEQ3", 		Trim(Mid(sLine,17,2)))
	ds.SetItem(nRow, "CVCOD",		sCvcod)
	
	/* PART NO */
	sTemp = Trim(Mid(sLine,19,15))
	If IsNumber(Left(sTemp,1)) Then
		sTemp = Left(sTemp,5) + '-' + Mid(sTemp,6)
	End If
	
	ds.SetItem(nRow, "SEQ4", 		sTemp)
	
	SELECT ITNBR INTO :sItnbr FROM ITEMAS WHERE ITNBR = :sTemp;
	If IsNull(sItnbr) Or sItnbr = '' Then
		ds.Setitem(nRow, 'ERR_I', 'I')
	End If

	ds.SetItem(nRow, "SEQ5", 		wf_num(Trim(Mid(sLine,34,7))))
	ds.SetItem(nRow, "SEQ6", 		wf_num(Trim(Mid(sLine,41,7))))
	ds.SetItem(nRow, "SEQ7", 		wf_num(Trim(Mid(sLine,48,5))))
	ds.SetItem(nRow, "SEQ8", 		wf_num(Trim(Mid(sLine,53,5))))
	ds.SetItem(nRow, "SEQ9", 		wf_num(Trim(Mid(sLine,58,5))))
	ds.SetItem(nRow, "SEQ10",		wf_num(Trim(Mid(sLine,63,5))))
	ds.SetItem(nRow, "SEQ11",		wf_num(Trim(Mid(sLine,68,5))))
	ds.SetItem(nRow, "SEQ12",		wf_num(Trim(Mid(sLine,73,5))))
	ds.SetItem(nRow, "SEQ13",		wf_num(Trim(Mid(sLine,78,5))))
	ds.SetItem(nRow, "SEQ14",		wf_num(Trim(Mid(sLine,83,5))))
	ds.SetItem(nRow, "SEQ15",		wf_num(Trim(Mid(sLine,88,5))))
	ds.SetItem(nRow, "SEQ16",		wf_num(Trim(Mid(sLine,93,5))))
	ds.SetItem(nRow, "SEQ17",		wf_num(Trim(Mid(sLine,98,5))))
	ds.SetItem(nRow, "SEQ18",	   Dec(Mid(sLine,103,5)))
	ds.SetItem(nRow, "SEQ19",		Dec(Mid(sLine,109,5)))
	ds.SetItem(nRow, "SEQ20",		Dec(Mid(sLine,114,5)))
	ds.SetItem(nRow, "SEQ21",		Dec(Mid(sLine,119,5)))
	ds.SetItem(nRow, "SEQ22",		Dec(Mid(sLine,124,5)))
	ds.SetItem(nRow, "SEQ23",		Dec(Mid(sLine,129,5)))
	ds.SetItem(nRow, "SEQ24",		Dec(Mid(sLine,134,5)))
	ds.SetItem(nRow, "SEQ25",		Dec(Mid(sLine,139,5)))
	ds.SetItem(nRow, "SEQ26",		Dec(Mid(sLine,144,5)))
	ds.SetItem(nRow, "SEQ27",		Dec(Mid(sLine,149,5)))
	ds.SetItem(nRow, "SEQ28",		Dec(Mid(sLine,154,5)))
	ds.SetItem(nRow, "SEQ29",		Dec(Mid(sLine,159,6)))
	ds.SetItem(nRow, "SEQ30",		Dec(Mid(sLine,165,7)))
	ds.SetItem(nRow, "SEQ31",		Trim(Mid(sLine,172,1)))
LOOP

If ds.Update() <> 1 Then
	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return -1
End If

COMMIT;

destroy ds

return 1

end function

on w_sm04_00010_1.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.dw_lg=create dw_lg
this.dw_insert=create dw_insert
this.st_2=create st_2
this.st_3=create st_3
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.dw_lg
this.Control[iCurrent+3]=this.dw_insert
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_1
end on

on w_sm04_00010_1.destroy
call super::destroy
destroy(this.dw_3)
destroy(this.dw_lg)
destroy(this.dw_insert)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_3.SetTransObject(sqlca)
dw_lg.SetTransObject(sqlca)
dw_jogun.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)
dw_1.SetItem(1, 'yymmdd', gs_code)

/* User별 사업장 Setting Start */
String sSaupj

If f_check_saupj() = 1 Then
	dw_1.Modify("saupj.protect=1")
End If
dw_1.SetItem(1, 'saupj', sSaupj)
/* ---------------------- End  */

dw_jogun.Retrieve()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm04_00010_1
integer x = 37
integer y = 164
integer width = 1952
integer height = 1096
string dataobject = "d_sm04_00010_1_2"
end type

event dw_jogun::buttonclicked;call super::buttonclicked;String sCust, sCustName, sFileName, docname, named
Int    value

sCust = GetItemString(row, 'rfgub')
sCustName = GetItemString(row, 'rfna1')

sFileName = ProfileString("C:\erpman\pgm\MAINSYS.INI", "DAILY PLAN FILE", sCust, "")

value = GetFileOpenName(sCustName + " 열기", docname, named, "TXT", "Text Files (*.TXT),*.TXT,")
If value <> 1 Then Return

SetProfileString("C:\ERPMAN\PGM\MAINSYS.INI", "DAILY PLAN FILE", sCust, docname)
end event

type p_exit from w_inherite_popup`p_exit within w_sm04_00010_1
integer x = 1819
integer y = 0
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)

Close(Parent)
end event

event p_exit::ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_sm04_00010_1
boolean visible = false
integer x = 27
integer y = 1148
end type

type p_choose from w_inherite_popup`p_choose within w_sm04_00010_1
integer x = 1646
integer y = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_choose::clicked;String docname, sCust, sPlanDate, sWeekDate, sMsg, sCustName, sReturn, sDate, eDate, stemp, sLine, sModel
Int	 li_filenum, irtn
Long   nCnt, icust, ix, iy, irow, nfind
Dec	 nQty
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

sPlanDate	= Trim(dw_1.GetItemString(1,'yymmdd'))
If f_datechk(sPlanDate) <> 1 Then
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

If  MessageBox("자료생성", '출하의뢰 자료를 일괄생성합니다.', Exclamation!, OKCancel!, 1) = 2 Then Return

/* 고객별 출하의뢰 자료 생성 */
sMsg = ''
For icust = 1 to dw_jogun.RowCount()
	If Trim(dw_jogun.GetItemString(icust, 'chk')) <> 'Y' Then Continue
	
	sCust 	 = Trim(dw_jogun.GetItemString(icust, 'rfgub'))
	sCustName = Trim(dw_jogun.GetItemString(icust, 'rfna1'))
	
	If sCust <> '40' Then
		SELECT COUNT(*) INTO :nCnt
		  FROM SM04_DAILY_ITEM A, VNDMST V
		 WHERE A.SAUPJ = :sSaupj
			AND A.YYMMDD = :sPlanDate
			AND A.CVCOD = V.CVCOD
			AND V.OUTGU = :scust 
			AND A.CNFIRM IS NOT NULL;
		If nCnt > 0 Then
			sMsg += ( sCustName + ": 출하자료 존재" + "~r~n~r~n")
		End If
		

		/* 주간계획에서 생성하는 경우에는 생산계획수량만 CLEAR */
		UPDATE SM04_DAILY_ITEM A SET PROD_QTY = 0
			 WHERE A.SAUPJ = :sSaupj
				AND A.YYMMDD = :sPlanDate
				AND A.CNFIRM IS NULL
				AND EXISTS ( SELECT * FROM VNDMST V WHERE V.CVCOD = A.CVCOD AND V.OUTGU = :scust );	

		If sqlca.sqlcode <> 0 Then
			MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return
		End If
	Else
		/* 1차 벤더인 경우 고객구분이 현대이면서 중분류가 현대가 아닌자료만 해당 */
		SELECT COUNT(*) INTO :nCnt
		  FROM SM04_DAILY_ITEM A, VNDMST V
		 WHERE A.SAUPJ = :sSaupj
			AND A.YYMMDD = :sPlanDate
			AND A.CVCOD = V.CVCOD
			AND V.OUTGU = '1' 
			AND NVL(V.SAREA,0) <> '10'
			AND A.CNFIRM IS NOT NULL;
		If nCnt > 0 Then
			sMsg += ( sCustName + ": 출하자료 존재" + "~r~n~r~n")
		End If
		
		/* 기존 출하의뢰 내역 삭제 */
		UPDATE SM04_DAILY_ITEM A SET PROD_QTY = 0
			 WHERE A.SAUPJ = :sSaupj
				AND A.YYMMDD = :sPlanDate
				AND A.CNFIRM IS NULL
				AND EXISTS ( SELECT * FROM VNDMST V WHERE V.CVCOD = A.CVCOD AND V.OUTGU = '1' AND NVL(V.SAREA,0) <> '10' );
		If sqlca.sqlcode <> 0 Then
			MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return
		End If		
	End If
	
	COMMIT;
	
	// 주간계획 수립일자 조회
	SELECT MIN(WEEK_SDATE) INTO :sWeekDate FROM PDTWEEK 
	 WHERE WEEK_YEAR = SUBSTR(:sPlanDate,1,4) 
	   AND WEEK_YEAR_JUCHA = (SELECT WEEK_YEAR_JUCHA FROM PDTWEEK WHERE WEEK_SDATE <= :sPlanDate AND WEEK_EDATE >= :sPlanDate );
	
	Choose Case sCust
		/* 4륜차 */
		Case '1'
			DELETE FROM HKCD2;
			If sqlca.sqlcode <> 0 Then
				MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
				RollBack;
				Return
			End If
	
			w_mdi_frame.sle_msg.text = "C:\HKC\VAN\HKCD2.TXT" + " 에서 자료를 읽어옵니다.!!"
			SELECT COUNT(*) INTO :nCnt FROM HKCD2;
			
			If nCnt = 0 Then
				/* HMC 주간소요량 */
				docname = ProfileString("C:\erpman\pgm\MAINSYS.INI", "DAILY PLAN FILE", sCust, "NONE")
				If docname = 'NONE' Then
					dw_jogun.SetItem(icust,'bigo', '파일 미지정')			
				Else
//					docname = "C:\HKC\VAN\HKCD2.TXT"
					li_FileNum = FileOpen(docname)
					
					wf_hkcd2(li_FileNum)	
					
					FileClose(li_FileNum)
					sMsg += ( sCustName + ": " + sReturn + "~r~n~r~n" )
				End If
			Else
				sMsg += ( sCustName + ": 기생성 자료 존재" + "~r~n~r~n" )
			End If
			
			If docname <> 'NONE' Then
				
				iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
				If iRtn <> 1 Then
					RollBack;
					dw_jogun.SetItem(icust,'bigo', '생성실패')
				Else
					COMMIT;
					dw_jogun.SetItem(icust,'bigo', '정상완료')
				End If
			Else
				dw_jogun.SetItem(icust,'bigo', 'None')
			End If
		/* LG : 주간계획에서 생성한다 */
//		Case '2'
//			/* 기존자료 삭제 */
//			sDate = sPlanDate
//			eDate = f_afterday(sDate,2)
//			
//			DELETE FROM "SM02_WEEKPLAN_LG"
//				WHERE SAUPJ = :sSaupj AND YYMMDD BETWEEN :sDate AND :eDate;
//			If sqlca.sqlcode <> 0 Then
//				dw_jogun.SetItem(icust,'bigo', '삭제 실패')
//				RollBack;
//				Return
//			End If
//					
//			// Comma로 분리된 경우
//			dw_3.Reset()
//			docname = ProfileString("C:\erpman\pgm\MAINSYS.INI", "DAILY PLAN FILE", sCust, "NONE")
//			If docname = 'NONE' Then
//				dw_jogun.SetItem(icust,'bigo', '파일 미지정')			
//			Else
//	//			nCnt = dw_3.ImportFile("C:\ERPMAN\DATA\LG생산계획(주간).txt",2)
//				nCnt = dw_3.ImportFile(docname,2)
//				If nCnt <= 0 Then Return
//				
//				FOR IX = 3 TO 5
//					sTemp = f_afterday(sPlanDate, ix - 3)
//					If sDate > sTemp Then Continue
//					If eDate < sTemp Then Continue
//					
//					For iy = 1 To dw_3.RowCount()
//						nQty = dw_3.GetItemNumber(iy, 'n'+string(ix))
//						If IsNull(nQty) Then nQty = 0
//						
//						If nQty > 0 Then
//							sLine = Trim(dw_3.GetItemString(iy,'s1'))
//							sModel= Trim(dw_3.GetItemString(iy,'s4'))
//							
//							nFind = dw_lg.Find("line ='"+sLine+"' and yymmdd = '" + sTemp + "' and model = '" +sModel +"'", 1, dw_lg.RowCount())
//							If nFind > 0 Then
//								dw_lg.SetItem(nFind, 'planqty', dw_lg.GetItemNumber(nFind, 'planqty') + nQty)
//							Else
//								irow = dw_lg.InsertRow(0)
//								dw_lg.SetItem(irow, 'saupj',   sSaupj)
//								dw_lg.SetItem(irow, 'line',    dw_3.GetItemString(iy,'s1'))
//								dw_lg.SetItem(irow, 'yymmdd',  stemp)
//								dw_lg.SetItem(irow, 'model', 	 dw_3.GetItemString(iy,'s4'))
//								dw_lg.SetItem(irow, 'planqty', nQty)
//								dw_lg.SetItem(irow, 'cvcod',   'HQ11') // LG 전자 셋팅
//							End If
//						End If
//					Next
//				NEXT
//				
//				If dw_lg.Update() <> 1 Then
//					dw_jogun.SetItem(icust,'bigo', '저장 실패')
//					RollBack;
//					Return
//				End If
//	
//				COMMIT;
//				
//				iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
//				If iRtn <> 1 Then
//					RollBack;
//					dw_jogun.SetItem(icust,'bigo', '생성실패')
//				Else
//					COMMIT;
//					dw_jogun.SetItem(icust,'bigo', '정상완료')
//				End If
//			End If
//		/* CKD */
//		Case '8'
//			/* 기존자료 삭제 */
//			DELETE FROM "HKCD6";
//			If sqlca.sqlcode <> 0 Then
//				dw_jogun.SetItem(icust,'bigo', '삭제 실패')
//				RollBack;
//				Return
//			End If
//			
//			COMMIT;
//			
//			/* 일별·주간 납입지시,분납(변동),CKD */
////			docname = "C:\HKC\VAN\HKCD6.TXT"
//			docname = ProfileString("C:\erpman\pgm\MAINSYS.INI", "DAILY PLAN FILE", sCust, "NONE")
//			If docname = 'NONE' Then
//				dw_jogun.SetItem(icust,'bigo', '파일 미지정')			
//			Else
//				li_FileNum = FileOpen(docname)
//				
//				nCnt = wf_hkcd6(li_FileNum)	
//				
//				FileClose(li_FileNum)
//				If nCnt <= 0 Then Return
//	
//				iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
//				If iRtn <> 1 Then
//					RollBack;
//					dw_jogun.SetItem(icust,'bigo', '생성실패')
//				Else
//					COMMIT;
//					dw_jogun.SetItem(icust,'bigo', '정상완료')
//				End If
//			End If
		/* 수출/시판은 주문에서 생성 */
		Case '5', '6'
			iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
			If iRtn <> 1 Then
				RollBack;
				dw_jogun.SetItem(icust,'bigo', '생성실패')
			Else
				COMMIT;
				dw_jogun.SetItem(icust,'bigo', '정상완료')
			End If
		Case Else
			w_mdi_frame.sle_msg.text = sCustName +": 주간계획에서 자료를 읽어옵니다.!!"
			
			SELECT COUNT(*) INTO :nCnt FROM SM03_WEEKPLAN_ITEM
			 WHERE SAUPJ = :sSaupj
				AND YYMMDD = :sWeekDate
				AND CNFIRM IS NOT NULL;

			If nCnt > 0 Then
				iRtn = SQLCA.SM04_CREATE_DATA(sSaupj, sPlanDate, sCust)
				If iRtn <> 1 Then
					RollBack;
					dw_jogun.SetItem(icust,'bigo', '생성실패')
				Else
					COMMIT;
					dw_jogun.SetItem(icust,'bigo', '정상완료')
				End If
				
				dw_jogun.SetItem(icust,'bigo', '정상완료')
			Else
				dw_jogun.SetItem(icust,'bigo', '주간계획 미마감')
			End If
	End Choose
Next

return
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm04_00010_1
integer x = 46
integer y = 44
integer width = 1490
integer height = 84
string dataobject = "d_sm04_00010_1_1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::rowfocuschanged;//
end event

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm04_00010_1
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm04_00010_1
end type

type cb_return from w_inherite_popup`cb_return within w_sm04_00010_1
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm04_00010_1
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm04_00010_1
end type

type st_1 from w_inherite_popup`st_1 within w_sm04_00010_1
end type

type dw_3 from datawindow within w_sm04_00010_1
boolean visible = false
integer x = 233
integer y = 1172
integer width = 178
integer height = 144
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_03010_lg_2"
boolean border = false
boolean livescroll = true
end type

type dw_lg from datawindow within w_sm04_00010_1
boolean visible = false
integer x = 686
integer y = 1172
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_03010_lg"
boolean border = false
boolean livescroll = true
end type

type dw_insert from datawindow within w_sm04_00010_1
boolean visible = false
integer x = 1394
integer y = 160
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

type st_2 from statictext within w_sm04_00010_1
integer x = 64
integer y = 1304
integer width = 1797
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 고객구분이 현대자동차는 C:\HKC\VAN\HKCD2.TXT 파일을 지정합니다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm04_00010_1
boolean visible = false
integer x = 64
integer y = 1380
integer width = 1797
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 고객구분이 CKD는        C:\HKC\VAN\HKCD6.TXT 파일을 지정합니다."
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sm04_00010_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 156
integer width = 1975
integer height = 1116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm04_00010_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 27
integer y = 28
integer width = 1545
integer height = 108
integer cornerheight = 40
integer cornerwidth = 55
end type

