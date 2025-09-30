$PBExportHeader$w_pdt_04030.srw
$PBExportComments$출고등록(기타)
forward
global type w_pdt_04030 from window
end type
type dw_lot from datawindow within w_pdt_04030
end type
type p_2 from uo_picture within w_pdt_04030
end type
type p_1 from uo_picture within w_pdt_04030
end type
type p_exit from uo_picture within w_pdt_04030
end type
type p_cancel from uo_picture within w_pdt_04030
end type
type p_delete from uo_picture within w_pdt_04030
end type
type p_save from uo_picture within w_pdt_04030
end type
type p_retrieve from uo_picture within w_pdt_04030
end type
type dw_print from datawindow within w_pdt_04030
end type
type cbx_1 from checkbox within w_pdt_04030
end type
type dw_imhist_in from datawindow within w_pdt_04030
end type
type rb_delete from radiobutton within w_pdt_04030
end type
type rb_insert from radiobutton within w_pdt_04030
end type
type dw_detail from datawindow within w_pdt_04030
end type
type gb_2 from groupbox within w_pdt_04030
end type
type rr_1 from roundrectangle within w_pdt_04030
end type
type dw_imhist from datawindow within w_pdt_04030
end type
type dw_list from datawindow within w_pdt_04030
end type
end forward

global type w_pdt_04030 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "출고 승인등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_lot dw_lot
p_2 p_2
p_1 p_1
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
dw_print dw_print
cbx_1 cbx_1
dw_imhist_in dw_imhist_in
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
gb_2 gb_2
rr_1 rr_1
dw_imhist dw_imhist
dw_list dw_list
end type
global w_pdt_04030 w_pdt_04030

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              // 시작일자
String     is_totime             // 시작시간
String     is_window_id          // 윈도우 ID
String     is_usegub             // 이력관리 여부

String     is_ispec ,  is_jijil
String     iSin_store            // 창고 이동시 입고 창고
String     is_store_gu           // 수불구분 => '창고이동' 일경우만 사용
end variables

forward prototypes
public subroutine wf_setqty ()
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
end prototypes

public subroutine wf_setqty ();long k, lcount
dec  djego_qty, dunqty

lcount = dw_list.rowcount()

FOR k = 1 TO lcount
	// lot관리품인 경우 출고수량을 셋팅하지 않는다
	If dw_list.getitemstring(k, 'lotgub') = 'Y' Then continue
	
	djego_qty = dw_list.GetItemDecimal(k, 'jego_qty') 
	dunqty    = dw_list.GetItemDecimal(k, 'unqty') 
	if djego_qty > 0 then 
		if djego_qty >= dunqty then 
			dw_list.SetItem(k, 'outqty', dunqty)
		else	
			dw_list.SetItem(k, 'outqty', djego_qty)
		end if
	end if
NEXT

end subroutine

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		* 등록모드
//		1. 출고수량 = 0		-> SKIP
//		2. 출고수량 > 0 인 것만 전표처리
//		3. 기출고수량 + 출고수량 = 요청수량 -> 촐고완료('Y')
//	
//////////////////////////////////////////////////////////////////
dec{3}	dOutQty, dIsQty, dQty, dTemp_OutQty
long		lRow,	lCount


FOR	lRow = 1		TO		dw_list.RowCount()

	dQty    = dw_list.GetItemDecimal(lRow, "qty")		// 출고요청수량
	dIsQty  = dw_list.GetItemDecimal(lRow, "isqty")		// 기출고수량	
	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")	// 출고수량

	IF ic_status = '1'	THEN
		IF dOutQty > 0		THEN
		
			lCount++

		END IF
	END IF

	
	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		if doutqty < 1 then
			f_message_chk(30, '[출고수량]')
			dw_list.setcolumn("outqty")
			dw_list.scrolltorow(lrow)
			dw_list.setfocus()
			return -1
		end if

		lCount++

	END IF

NEXT


////////////////////////////////////////////////////////////////////////
///// 입고 창고가 "서열 창고"인 경우만 자료체크 PASS(04.03.10 itkim ////
////////////////////////////////////////////////////////////////////////
IF (Isnull(is_store_gu) or is_store_gu = "") and iSin_store <> 'Z09' then	
	IF lCount < 1		THEN	
		MessageBox("확인", "출고자료가 없습니다.")
		RETURN -1
	END IF
END IF


RETURN 1
end function

public function integer wf_imhist_create (ref string arg_sjpno);///////////////////////////////////////////////////////////////////////
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '001'
///////////////////////////////////////////////////////////////////////
string	sJpno, sIOgubun,	&
			sDate, sTagbn, ssaupj, &
			sHouse, sEmpno, sRcvcod, sSaleyn, sinstore, snull, sOpseq, sQcgub, sLotgub, sHoldNo, sLotsno, sLoteno, &
			sStock, sInsQc, sGrpno, sgubun, sItnbr, scustom, scustno
long		lRow, lRowHist, lRowHist_In, ix
dec		dSeq, dOutQty,	dInSeq, dLotrow

dw_detail.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_list.GetItemString(1, "hold_gu")		// 요청구분 (출고의뢰번호별로 동일)

setnull(srcvcod)
SELECT AUTIPG, RCVCOD, TAGBN, NVL(IOYEA4,'N')
  INTO :sHouseGubun, :sRcvcod, :sTagbn, :sInsQc
  FROM IOMATRIX
 WHERE SABU = :gs_sabu		AND
 		 IOGBN = :sIOgubun ;

if sqlca.sqlcode <> 0 then
	f_message_chk(208, '[출고구분]')
end if

/* 창고이동 출고인 경우 상대 입고구분을 검색 */
if	sHousegubun = 'Y' then
	if isnull(srcvcod) or trim(srcvcod) = '' then
		f_message_chk(208, '[출고구분-창고이동입고]')	
		return -1
	end if
	
	//무검사 데이타 가져오기
   SELECT "SYSCNFG"."DATANAME"  
     INTO :sQcgub  
     FROM "SYSCNFG"  
    WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
          ( "SYSCNFG"."SERIAL" = 13 ) AND  
          ( "SYSCNFG"."LINENO" = '2' )   ;
	if sqlca.sqlcode <> 0 then
		sQcgub = '1'
	end if
	
	/* 단가마스터에 검사담당자가 없는 경우 환경설정에 있는 기본 검사담당자를 이용한다 */
	select dataname
	  into :scustom
	  from syscnfg
	 where sysgu = 'Y' and serial = '13' and lineno = '1';
	 
end if

sDate = dw_detail.GetItemString(1, "edate")				// 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  	= sDate + string(dSeq, "0000")
sHouse 	= dw_detail.GetItemString(1, "house")
sEmpno 	= dw_detail.GetItemString(1, "empno")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
Decimal LSqlcode

FOR lRow = 1	TO	dw_list.RowCount()

	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")
	IF dOutQty <= 0	THEN Continue

	sHoldNo = dw_list.GetItemString(lRow, "hold_no")
	
	sLotgub = dw_list.GetItemString(lRow, 'lotgub')
	If sLotgub = 'N' Then
		dLotRow = 1
	Else
		dw_lot.SetFilter("hold_no = '" + sHoldNo + "'")
		dw_lot.Filter()
	
		dLotRow = dw_lot.RowCount()
	End If
	
	For ix = 1 To dLotRow
		/* Lot 별 출고할경우와 그렇지 않은 경우 */
		If sLotgub = 'N' Then
			/* 출고수량 */
			dOutQty = dw_list.GetItemNumber(lRow,"outqty")
			If IsNull(dOutQty) Then dOutQty = 0
			
			SetNull(sLotsNo)
			SetNull(sLoteNo)
			SetNull(sCustNo)
		Else
			/* LOT별 출고수량 */
			dOutQty = dw_lot.GetItemNumber(ix,"hold_qty")
			If IsNull(dOutQty) Then dOutQty = 0
			
			sLotsNo = dw_lot.GetItemString(ix,"lotno")
			sLoteNo = ''
			sCustNo = dw_lot.GetItemString(ix,"cust_no")
		End If
		
		// 사업장은 창고기준을 
		SELECT HOMEPAGE, ipjogun
		  INTO :sSaleYN, :ssaupj
		  FROM VNDMST
		 WHERE ( CVCOD = :sHouse ) ;
			 
		////////////////////////////////////////////////////////////////////////////////
		// ** 입출고HISTORY 생성 **
		////////////////////////////////////////////////////////////////////////////////
	
		lRowHist = dw_imhist.InsertRow(0)
		
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'001')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// 수불구분=요청구분
	
		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// 수불일자=출고일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "pspec")) // 사양
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	dw_list.GetItemString(lRow, "in_store")) 	// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "cust_no",	sCustNo)
		dw_imhist.SetItem(lRowHist, "ioqty",	dOutQty) 	   // 수불수량=출고수량
		dw_imhist.SetItem(lRowHist, "ioreqty",	dOutQty) 	   // 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dOutQty) 	   // 합격수량=출고수량		
		sOpseq = dw_list.getitemstring(Lrow, "opseq")
		dw_imhist.SetItem(lRowHist, "opseq",	sopseq)			// 공정코드
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno)			// 수불승인자=담당자	
		dw_imhist.SetItem(lRowHist, "hold_no", dw_list.GetItemString(lRow, "hold_no")) 	   // 할당번호
		dw_imhist.SetItem(lRowHist, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
		dw_imhist.SetItem(lRowHist, "outchk",  dw_list.GetItemString(lRow, "hosts")) 			// 출고의뢰완료
		dw_imhist.SetItem(lRowHist, "pjt_cd",  dw_list.GetItemString(lRow, "pjtno"))        // 프로젝트No
		
		dw_imhist.SetItem(lRowHist, "facgbn",  dw_list.GetItemString(lRow, "hyebia1"))        // 공장
		
		dw_imhist.SetItem(lRowHist, "lotsno",  sLotsNo)			// LOt No
	   dw_imhist.SetItem(lRowHist, "saupj",   ssaupj)
		
		
//		/* 단가 SELECT 2004.02.07(외주 사급품(자재/반제품등)의 단가 및 출고 금액) */ 
//		string sitnbr, spsspec
//		long   lioprc, lioqty
//		sitnbr  = dw_list.GetItemString(lRow , "itnbr" )
//		spsspec = dw_list.GetItemString(lRow , "pspec" )
//		lioqty  = dw_list.GetItemDecimal(lRow, "outqty")
//		if sIOgubun='O06' then
//			select fun_danmst_danga(:sdate, :sitnbr, :spsspec)
//			  into :lioprc
//			from dual;
//			
//			dw_imhist.SetItem(lRowHist, "ioprc",  lioprc)
//			dw_imhist.SetItem(lRowHist, "ioamt",  lioqty * lioprc)
//		end if
	
		
		IF sHouseGubun = 'Y'	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// 전표생성구분
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// 수불구분=창고이동입고구분
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
			//iomatrix에 타계정 구분이 Y이면 입고품에 타계정품번을 셋팅
			if stagbn = 'Y' then 
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "ditnbr")) // 품번
				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_list.GetItemString(lRow, "dpspec")) // 사양
			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "itnbr")) // 품번
				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_list.GetItemString(lRow, "pspec")) // 사양
			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",dw_list.GetItemString(lRow, "in_store")) 	// 기준창고=입고처
			sInstore = dw_list.GetItemString(lRow, "in_store")
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",	sCustNo)
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	sOpseq)			// 공정코드
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dOutQty) 	   // 수불의뢰수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// 검사일자=출고일자	
			
			dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sQcgub)			// 검사방법
			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dOutQty) 	   // 합격수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",  sLotsNo)		   // LOt No
			dw_imHist_in.SetItem(lRowHist_in, "facgbn",  dw_list.GetItemString(lRow, "hyebia2"))		   // 공장
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
			// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
			Setnull(sSaleyn)
			SELECT HOMEPAGE, ipjogun
			  INTO :sSaleYN, :ssaupj
			  FROM VNDMST
			 WHERE ( CVCOD = :sinstore ) ;	
	      
			IF isnull(sSaleyn) or trim(ssaleyn) = '' then
				Ssaleyn = 'N'
			end if			 
			
			sItnbr  = dw_list.GetItemString(lRow, "itnbr")
			sStock  = dw_list.GetItemString(lRow, "itemas_filsk") // 재고관리유무
			sGrpno  = dw_list.GetItemString(lRow, "grpno2")        // 검사품구분
			 
			if isnull(sStock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then	
				sStock = 'Y'
			end if
			
			// 검사의뢰(수입검사)이면서 입고후 검사인 경우
			IF sInsQc = 'Y' and sGrpno = 'Y'	THEN			
				SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
				  INTO :sgubun,  :sempno    
				  FROM "ITEMAS"  
				 WHERE "ITEMAS"."ITNBR" = :sItnbr ;
				
				if sgubun = '' or isnull(sgubun) then		sGubun = '1'
								
				// 재고관리 하지 않을 경우 : 무검사, 검사담당자 없음				
				IF sStock = 'N'	THEN sGubun = '1'
				
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sGubun) // 무검사
				dw_imHist_in.SetItem(lRowHist_in, "gurdat",	sdate)  // 검사의뢰일자
				
				if sgubun = '1' then //무검사인 경우
					dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
					dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// 검사일자=출고일자
				else
					if sempno = '' or isnull(sempno) then
						dw_imHist_in.SetItem(lRowHist_in, "insemp",	scustom) // 기본검사 담당자
					else
						dw_imHist_in.SetItem(lRowHist_in, "insemp",	sempno)
					end if
					dw_imHist_in.SetItem(lRowHist_in, "insdat",	sNull)			// 검사일자
				end if				
			Else
				sgubun = '1'
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun)           // 무검사
				dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
			End If
			
			// 무검사이며 자동승인인 경우 승인내역 저장
			IF sgubun = '1' And sSaleYn = 'Y' then
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_list.GetItemDecimal(lRow, "outqty")) 	   // 수불수량=입고수량
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)	   	                           // 수불승인일자=입고의뢰일자
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		                              // 수불승인자=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			                        // 수불승인여부
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			                        // 수불승인여부				
			END IF
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				                              // 동시출고여부
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			                              // 수불의뢰담당자=담당자	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))             // 입고전표번호=출고번호
		END IF
	Next
NEXT

//-------------------------------------------------------------------//
if dw_list.update() = -1 then
	rollback;		
	LSqlcode = dec(sqlca.sqlcode)
	f_message_chk(LSqlcode,'[할당 자료저장]') 
	return -1
End if
Commit;
//-------------------------------------------------------------------//

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. 입출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////

dec{3}	dOutQty, dNotOutQty, dTempQty
string	sHist_Jpno, sIodate
long		lRow, lRowCount, i, k

lRowCount = dw_list.RowCount()

FOR lrow = 1 TO lRowCount
	 sHist_Jpno = dw_list.GetItemString(lrow, "imhist_iojpno")
	 sIoDate    = dw_list.GetItemString(lrow, "cndate")

	k ++	
	 
	if dw_list.getitemstring(lrow, "del") <> 'Y' then continue
	
	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
	if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
	   dw_list.GetItemString(lRow, "i_confirm") = 'N' then continue
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU" = :gs_sabu
	   and "IMHIST"."IOJPNO" = :sHist_Jpno   ;
//	messagebox('1', sqlca.sqlerrtext)  
	IF SQLCA.SQLNROWS < 1	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
	  
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU"    = :gs_sabu
	   and "IMHIST"."IP_JPNO" = :sHist_Jpno   
	   AND "IMHIST"."JNPCRT" = '011';

	IF SQLCA.SQLCODE < 0	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
		
	i ++	
Next
////////////////////////////////////////////////////////////////////////
IF i < 1 Then
	messagebox("확 인", "삭제 할 자료를 선택하세요.!")
	Return -1
END IF

if i = k then return -2  //전체 삭제되었으면 화면 reset

RETURN 1
end function

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* 수정모드
//		1. 입출고history -> 출고수량 update (출고수량을 변경할 경우에만)
//		2. 기출고수량 + 출고수량 = 요청수량 -> 촐고완료('Y')
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sGubun, siodate, sioyn
dec{3}	dOutQty, dTemp_OutQty
long		lRow, i, k

FOR	lRow = 1		TO		dw_list.RowCount()

   k++
	
	dOutQty      = dw_list.GetItemDecimal(lRow, "outqty")			// 출고수량(입출고history)
	dTemp_OutQty = dw_list.GetItemDecimal(lRow, "temp_outqty")	// 출고수량(입출고history)
	sHist_Jpno   = dw_list.GetItemString(lRow, "imhist_iojpno")
	sGubun		 = dw_list.GetItemString(lRow, "imhist_outchk")
	
	siodate = dw_list.GetItemString(lRow, "cndate")
	sioyn   = dw_list.GetItemString(lRow, "i_confirm")
	
	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
	if (not isnull(siodate)) AND sioyn = 'N' then continue
	
	IF dOutQty <> dTemp_OutQty		THEN

		  UPDATE "IMHIST"  
     		  SET "IOQTY" = :dOutQty,   
         		"IOREQTY" = :dOutQty,   
         		"IOSUQTY" = :dOutQty,   
         		"OUTCHK" = :sGubun,   
         		"UPD_USER" = :gs_userid  
   		WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
         		( "IMHIST"."IOJPNO" = :sHist_Jpno )   ;

		IF SQLCA.SQLNROWS <> 1	THEN
			ROLLBACK;
			f_Rollback();
			RETURN -1
		END IF

		//자동인 경우 입고수량에도 수량 변경
		IF sioyn = 'Y' and (not isnull(sIodate)) then 
		   UPDATE "IMHIST"  
			   SET "IOQTY"   = :dOutQty,   
					 "IOREQTY" = :dOutQty,   
					 "IOSUQTY" = :dOutQty,  
				 	 "UPD_USER" = :gs_userid  
			 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
					 ( "IMHIST"."IP_JPNO" = :sHist_Jpno )   AND
					 ( "IMHIST"."JNPCRT" = '011' ) ;		
		ELSE
		   UPDATE "IMHIST"  
			   SET "IOREQTY" = :dOutQty,   
					 "IOSUQTY" = :dOutQty,  
					 "UPD_USER" = :gs_userid  
			 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
					 ( "IMHIST"."IP_JPNO" = :sHist_Jpno )   AND
					 ( "IMHIST"."JNPCRT" = '011' ) ;		
		END IF
		
		IF SQLCA.SQLCODE < 0	THEN
			ROLLBACK;
			f_Rollback();
			RETURN -1
		END IF
		
	END IF
   i++
NEXT
if i < 1 then 
	messagebox("확 인", "입고자료가 승인처리 되어 있으므로 수정 할 수 없습니다." + &
	                    'N' + "입고 자료를 확인하세요!")
	return -1						  
elseif	k <> i then 
	messagebox("확 인", "입고자료가 일부 승인처리 되어 있으므로 일부만 수정 되었습니다." + &
	                    'N' + "입고 자료를 확인하세요!")
end if	

RETURN 1
end function

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()
dw_imhist_in.reset()

p_delete.enabled = false
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then
	// 등록시
	dw_detail.settaborder("out_jpno",  0)
	dw_detail.settaborder("EDATE", 10)
	dw_detail.settaborder("jpno",  20)
	dw_detail.settaborder("house", 40)
	dw_detail.settaborder("empno", 50)

	dw_detail.Modify("t_dsp_no.visible = 0")
	
	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_yno.visible = 1")
	dw_detail.Modify("t_dsp_chang.visible = 1")
	dw_detail.Modify("t_dsp_emp.visible = 1")
	
	dw_detail.setcolumn("JPNO")
	dw_detail.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "등록"
ELSE
	dw_detail.settaborder("out_jpno",  10)
	dw_detail.settaborder("EDATE", 0)
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("house", 0)
	dw_detail.settaborder("empno", 0)

   dw_detail.Modify("t_dsp_no.visible = 1")
	
	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_yno.visible = 0")
	dw_detail.Modify("t_dsp_chang.visible = 0")
	dw_detail.Modify("t_dsp_emp.visible = 0")

	dw_detail.setcolumn("OUT_JPNO")

	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

f_mod_saupj(dw_detail, 'saupj')

return  1

end function

event open; 
Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF


IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
ELSE	
	is_ispec = '규격'
	is_jijil = '재질'
END IF

//---------------------------------------------------------
//출고창고
datawindowchild state_child
integer rtncode

rtncode = dw_detail.GetChild("HOUSE", state_child)
IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 출고창고")
state_child.SetTransObject(SQLCA)
//state_child.Retrieve( gs_saupj, "2", gs_empno)
state_child.Retrieve( gs_saupj)

//---------------------------------------------------------
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

//dw_imhist.settransobject(sqlca)
is_Date = f_Today()


// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_pdt_04030.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.dw_lot=create dw_lot
this.p_2=create p_2
this.p_1=create p_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.dw_print=create dw_print
this.cbx_1=create cbx_1
this.dw_imhist_in=create dw_imhist_in
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.rr_1=create rr_1
this.dw_imhist=create dw_imhist
this.dw_list=create dw_list
this.Control[]={this.dw_lot,&
this.p_2,&
this.p_1,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.dw_print,&
this.cbx_1,&
this.dw_imhist_in,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.gb_2,&
this.rr_1,&
this.dw_imhist,&
this.dw_list}
end on

on w_pdt_04030.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lot)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.dw_print)
destroy(this.cbx_1)
destroy(this.dw_imhist_in)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.dw_imhist)
destroy(this.dw_list)
end on

event closequery;
string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_retrieve.TriggerEvent(Clicked!)
	Case KeyS!
		p_save.TriggerEvent(Clicked!)
	Case KeyD!
		p_delete.TriggerEvent(Clicked!)
	Case KeyC!
		p_cancel.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_lot from datawindow within w_pdt_04030
boolean visible = false
integer x = 14
integer y = 632
integer width = 2999
integer height = 640
integer taborder = 30
string title = "none"
string dataobject = "d_sal_02040_1"
boolean livescroll = true
end type

type p_2 from uo_picture within w_pdt_04030
integer x = 3515
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\재고선택_up.gif"
end type

event clicked;call super::clicked;//long lRow
//
//if dw_list.accepttext() = -1 then return 
//if dw_detail.accepttext() = -1 then return 
//if dw_list.rowcount() < 1 then return 
//
//lRow = dw_list.getrow()
//
//if lRow < 1 then 
//	messagebox('확 인', '조회할 자료를 선택하세요!')
//	return 
//end if
//
//gs_code = dw_list.getitemstring(lRow, 'itnbr')
//IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
//	f_message_chk(30,'[품번]')
//	dw_list.ScrollToRow(lRow)
//	dw_list.Setcolumn("itnbr")
//	dw_list.setfocus()
//	RETURN 
//END IF
//gs_gubun = dw_detail.getitemstring(1, 'house')
//
//// 코드명이 Y가 아니면 선택할 수 없고 조회만 'Y' 이면 선택할 수 있음
//gs_codename = 'N' 
//open(w_stock_popup)
//

/* 재고 선택 */
datawindow dwname	
Long nRow
Dec  dQty

If dw_list.accepttext() <> 1 Then Return
nRow = dw_list.GetSelectedRow(0)
If nRow <= 0 Then Return

dwname = dw_lot

gs_gubun = dw_detail.GetItemString(1, 'house')
gs_code  = dw_list.getitemstring(nRow, "itnbr")
gs_codename = dw_list.getitemstring(nRow, "hold_no")
gs_codename2 =  String(dw_list.getitemNumber(nRow, "unqty"))
gs_docno ='N'	// 수량 체크

openwithparm(w_stockwan_popup, dwname)
If IsNull(gs_code) Or Not IsNumber(gs_code) Then Return

dw_list.SetItem(nRow, 'outqty', Dec(gs_code))

setnull(gs_code)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고선택_up.gif"
end event

type p_1 from uo_picture within w_pdt_04030
integer x = 3337
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\출고증_up.gif"
end type

event clicked;call super::clicked;OPENSheet(W_MAT_03550, w_mdi_frame, 2, Layered!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\출고증_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\출고증_up.gif"
end event

type p_exit from uo_picture within w_pdt_04030
integer x = 4402
integer y = 8
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_cancel from uo_picture within w_pdt_04030
integer x = 4229
integer y = 8
integer width = 178
integer taborder = 80
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_delete from uo_picture within w_pdt_04030
integer x = 4055
integer y = 8
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 출고내역 삭제
//////////////////////////////////////////////////////////////////
int    ireturn 

SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

dw_list.setredraw(false)
ireturn = wf_Imhist_Delete()
	
IF iReturn = -1		THEN	
	rollback;
	dw_list.setredraw(true)
	RETURN
end if

COMMIT;

IF ireturn = -2 THEN 
   p_cancel.triggerevent(clicked!)
ELSE
	p_retrieve.triggerevent(clicked!)
END IF

dw_list.setredraw(true)
SetPointer(Arrow!)

end event

type p_save from uo_picture within w_pdt_04030
integer x = 3881
integer y = 8
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sArg_sdate
Decimal  dArg_dseq
sdate  = dw_detail.GetItemstring(1, "Edate")			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 
	

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_imhist_create(sArg_sdate) = -1 THEN
		ROLLBACK;
		RETURN
	END IF

	IF dw_imhist.Update() <= 0		THEN
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF
	
	IF dw_imhist_in.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF
	
	MessageBox("전표번호 확인", "전표번호 : " + left(sArg_sDate, 8)+ '-' + right(sArg_sDate,4)+		&
										 "~r~r생성되었습니다.")	
	
	if cbx_1.checked then 
		dw_print.setfilter("ioseq <> '999'")
		dw_print.filter()	
		dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate, gs_saupj)
		dw_print.print()
   end if      										 
/////////////////////////////////////////////////////////////////////////
//	1. 수정 : 할당TABLE(출고수량, 미출고수량, 완료구분)
//				 입출고HISTORY(출고수량)
/////////////////////////////////////////////////////////////////////////
ELSE

	IF wf_imhist_update() = -1 THEN
		ROLLBACK;
		RETURN
	else
		commit;
	END IF
	
END IF


////////////////////////////////////////////////////////////////////////
								 
p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_retrieve from uo_picture within w_pdt_04030
integer x = 3707
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;	
if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sOutJpno,	&
			sDate,		&
			sHouse, sEmpno,	&
			sNull
SetNull(sNull)

sDate    = TRIM(dw_detail.getitemstring(1, "edate"))
sJpno   	= TRIM(dw_detail.getitemstring(1, "jpno"))
sHouse  	= dw_detail.getitemstring(1, "house")
sEmpno  	= dw_detail.getitemstring(1, "empno")
sOutJpno = TRIM(dw_detail.getitemstring(1, "out_jpno"))

IF ic_status = '1'		THEN
	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[출고일자]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sJpno) or sJpno = "" 	THEN
		f_message_chk(30,'[의뢰번호]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sJpno) or sJpno = "" 	THEN sJpno = ''
		
	IF isnull(sHouse) or sHouse = "" 	THEN
		f_message_chk(30,'[출고창고]')
		dw_detail.SetColumn("house")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[담당자번호]')
		dw_detail.SetColumn("empno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sJpno = sJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sjpno, sHouse, gs_saupj) <	1		THEN
		f_message_chk(50, '[출고-기타]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		return
	END IF
     //--- 출고요청수량 확인...
     wf_setqty()
ELSE

	IF isnull(sOutJpno) or sOutJpno = "" 	THEN
		f_message_chk(30,'[출고번호]')
		dw_detail.SetColumn("out_jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sOutJpno = sOutJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sOutjpno) <	1		THEN
		f_message_chk(50, '[출고-기타]')
		dw_detail.setcolumn("out_jpno")
		dw_detail.setfocus()
		return
	END IF

	// 삭제모드에서만 삭제가능
	p_delete.enabled = true	
	
END IF


//////////////////////////////////////////////////////////////////////////

dw_detail.enabled = false


dw_list.SetColumn("outqty")
dw_list.SetFocus()
//cb_save.enabled = true

end event

type dw_print from datawindow within w_pdt_04030
boolean visible = false
integer x = 1317
integer y = 2324
integer width = 855
integer height = 104
boolean titlebar = true
string title = "기타출고 출력"
string dataobject = "d_mat_03550_02_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_pdt_04030
integer x = 3218
integer y = 236
integer width = 695
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출고증 자동출력 여부"
end type

type dw_imhist_in from datawindow within w_pdt_04030
boolean visible = false
integer x = 713
integer y = 2324
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type rb_delete from radiobutton within w_pdt_04030
integer x = 4274
integer y = 208
integer width = 242
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
end type

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_pdt_04032'
dw_list.SetTransObject(sqlca)
dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

wf_Initial()
end event

type rb_insert from radiobutton within w_pdt_04030
integer x = 3963
integer y = 208
integer width = 242
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;
ic_status = '1'	// 등록

dw_list.DataObject = 'd_pdt_04030'
dw_list.SetTransObject(sqlca)
dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

wf_Initial()
end event

type dw_detail from datawindow within w_pdt_04030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 12
integer width = 3141
integer height = 288
integer taborder = 10
string dataobject = "d_pdt_04031"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate, sDept, 		&
			sCode, sName, 		&
			sJpno, sHist_Jpno, 		&
			sHouse,sEmpno,				&
			sNull, sGubun, sname2, stagbn, spass
int      ireturn 			

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'edate' THEN
	sDate = trim(this.gettext())
	
	if isnull(sDate) or sDate = '' then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[출고일자]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'house' THEN
	sHouse = this.gettext()
	
	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고창고]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			return 1
      END IF		
	END IF

	SELECT A.EMPNO, B.EMPNAME INTO :sempno, :sname
		FROM DEPOT_EMP A, P1_MASTER B
		WHERE A.EMPNO = B.EMPNO
		AND	A.DEPOT_NO = :sHouse AND ROWNUM = 1;//AND A.OWNER = 'Y';
		
	If isNull(sempno) Or sempno = '' Then
		this.SetItem(1,"empno", '')
		this.SetItem(1,"name", '')
	Else
		this.SetItem(1,"empno", sempno)
		this.SetItem(1,"name", sname)
	End If

ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sname)
      return 
   end if
   this.accepttext()
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("확 인", "창고를 먼저 입력하세요")
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if
	
   ireturn = f_get_name2('출고승인자', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
	
ELSEIF this.getcolumnname() = "jpno"	then

	sJpno = TRIM(this.gettext())
	
	IF sJpno = '' or isnull(sJpno) THEN 
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
	   return 
	END IF	
		

  SELECT "HOLDSTOCK"."OUT_STORE", "HOLDSTOCK"."REQ_DEPT", 
  			"HOLDSTOCK"."HOLD_GU"  , "VNDMST"."CVNAS2", "IOMATRIX"."TAGBN", "HOLDSTOCK"."IN_STORE"
    INTO :sHouse, :sDept, :sGubun, :sName, :sTagbn, :iSin_store
    FROM "HOLDSTOCK",  		"VNDMST", 		"IOMATRIX" 
 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu )	AND
  		 ( "HOLDSTOCK"."HOLD_NO" like :sJpno||'%' )   AND
 		 ( "HOLDSTOCK"."REQ_DEPT" = "VNDMST"."CVCOD" ) AND
		 ( "HOLDSTOCK"."SABU"     = "IOMATRIX"."SABU" ) AND
		 ( "HOLDSTOCK"."HOLD_GU" = "IOMATRIX"."IOGBN" ) AND
		 ( "HOLDSTOCK"."PORDNO"   IS NULL )  AND 
		 ( "IOMATRIX"."JNPCRT" = '001' ) AND ROWNUM = 1 ;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고의뢰번호]')
		this.setitem(1, "jpno", sNull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if

	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		SetNull(sPass)
		this.SetItem(1, "house", snull)
//		f_message_chk(33,'[출고창고]')
//		this.setitem(1, "jpno", sNull)
//		this.SetItem(1, "dept",  snull)
//		this.SetItem(1, "deptname", snull)
//		this.SetItem(1, "hold_gu", snull)
//		this.setitem(1, "empno", sNull)
//		this.setitem(1, "name", sNull)
//		return 1
	Else
		this.SetItem(1, "house", sHouse)
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "jpno", sNull)
			this.SetItem(1, "house", snull)
			this.SetItem(1, "dept",  snull)
			this.SetItem(1, "deptname", snull)
			this.SetItem(1, "hold_gu", snull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			return 1
      END IF		
	END IF

   /* 수불구분이 "창고이동"이고, 입고창고가 "서열창고"일때 ==> 서열재고 관리를 위해...(2004.03.10 itkim add!!) */
   if sgubun = 'O05' and iSin_store = 'Z09' then
	   is_store_gu = sgubun
	else
		setnull(is_store_gu)
	end if
	
	
	this.SetItem(1, "dept",  sDept)
	this.SetItem(1, "deptname", sName)
	this.SetItem(1, "hold_gu", sgubun)	
	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	
	if sTagbn = 'Y' then 
		dw_list.DataObject = 'd_pdt_04030_1'
		dw_list.object.dispec_t.text = '타계정 대체 ' + is_ispec
		dw_list.object.djijil_t.text = '타계정 대체 ' + is_jijil
	else
		dw_list.DataObject = 'd_pdt_04030'
	end if	
   dw_list.SetTransObject(sqlca)
	
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
	
	this.Setcolumn("empno")
	this.SetFocus()
	
ELSEIF this.getcolumnname() = "out_jpno"	then
	
	sHist_Jpno = TRIM(this.GetText())
	
	IF sHist_Jpno = '' or isnull(sHist_Jpno) then 
		this.SetItem(1, "edate", snull)
		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
   END IF
	
  SELECT A.INSDAT,			// 출고일자
			A.IO_EMPNO,			// 담당자
			D.EMPNAME,			// 담당자명
			A.IOGBN,			   // 출고구분
  			A.DEPOT_NO,			// 출고창고
			SUBSTR(A.HOLD_NO, 1, 12), 
  			B.REQ_DEPT, 		// 요청부서
			C.CVNAS		
	 INTO :sDate,
			:sEmpno,
			:sName2,
			:sGubun,
			:sHouse,
			:sjpno, 
			:sDept,
			:sName
	 FROM IMHIST A, HOLDSTOCK B, VNDMST C, P1_MASTER D
	WHERE A.SABU = :gs_sabu AND
			A.IOJPNO LIKE :sHist_Jpno||'%' 	AND
			A.SABU = B.SABU	AND
			A.HOLD_NO = B.HOLD_NO	AND
			A.IO_EMPNO = D.EMPNO	(+) AND
			B.REQ_DEPT = C.CVCOD(+)	 	AND
			TRIM(A.JNPCRT) LIKE '001' AND ROWNUM = 1	;
	
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고번호]')
		this.setitem(1, "out_jpno", sNull)
		this.SetItem(1, "edate", snull)
		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		return 1
	end if

	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고창고]')
		this.setitem(1, "out_jpno", sNull)
		this.SetItem(1, "edate", snull)
		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "out_jpno", sNull)
			this.SetItem(1, "edate", snull)
			this.SetItem(1, "jpno",  snull)
			this.SetItem(1, "empno", snull)
			this.SetItem(1, "name", snull)
			this.SetItem(1, "house", snull)
			this.SetItem(1, "dept",  snull)
			this.SetItem(1, "deptname", snull)
			this.SetItem(1, "hold_gu", snull)
			return 1
      END IF		
	END IF

	this.SetItem(1, "edate", sDate)
	this.SetItem(1, "jpno",  sJpno)
	this.SetItem(1, "empno", sEmpno)
	this.SetItem(1, "name", sName2)
	this.SetItem(1, "house", sHouse)
	this.SetItem(1, "dept",  sDept)
	this.SetItem(1, "deptname", sName)
	this.SetItem(1, "hold_gu", sGubun)

  SELECT "IOMATRIX"."TAGBN"  
    INTO :stagbn
    FROM "IOMATRIX"  
   WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND  
         ( "IOMATRIX"."IOGBN" = :sgubun )   ;

	if sTagbn = 'Y' then 
		dw_list.DataObject = 'd_pdt_04032_1'
		dw_list.object.dispec_t.text = '타계정 대체 ' + is_ispec
		dw_list.object.djijil_t.text = '타계정 대체 ' + is_jijil
	else
		dw_list.DataObject = 'd_pdt_04032'
	end if	
   dw_list.SetTransObject(sqlca)
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
ElseIf This.GetColumnName() = 'saupj' Then
	String  ls_saupj
	ls_saupj = Trim(This.GetText())
	
	If Trim(ls_saupj) = '' Or IsNull(ls_saupj) Then ls_saupj = '%'
	
	f_child_saupj(This, 'house', ls_saupj)
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;string sPass, shouse

gs_gubun = ''
gs_code = ''
gs_codename = ''

// 출고승인담당자
IF this.GetColumnName() = 'empno'	THEN
	this.accepttext() 
   gs_gubun = '4' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code
	
	Open(w_depot_emp_popup)
	If Isnull(gs_code) or Trim(gs_code) = "" Then Return
   
   If isnull(shouse) or shouse = '' or shouse <> gs_gubun then 
		SELECT DAJIGUN
		  INTO :sPass
		  FROM VNDMST
		 WHERE CVCOD = :gs_gubun AND 
				 CVGU = '5'		  AND
				 CVSTATUS = '0' ;
		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[출고창고]')
			return 
		end if
	
		IF not (sPass ="" OR IsNull(sPass)) THEN
			OpenWithParm(W_PGM_PASS,spass)
			IF Message.StringParm = "CANCEL" THEN 
				return 
			END IF		
		END IF
   End if
	
	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno",gs_code)
	SetItem(1,"name",gs_codename)
// 출고의뢰번호
elseif this.getcolumnname() = "jpno" 	then
	open(w_haldang_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
   return 1	
// 출고번호
elseif this.getcolumnname() = "out_jpno" 	then
	gs_gubun = '001'
	open(w_chulgo_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "out_jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
end if

end event

type gb_2 from groupbox within w_pdt_04030
integer x = 3918
integer y = 152
integer width = 654
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_pdt_04030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 312
integer width = 4539
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_imhist from datawindow within w_pdt_04030
boolean visible = false
integer x = 3072
integer y = 624
integer width = 1189
integer height = 396
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_list from datawindow within w_pdt_04030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 324
integer width = 4507
integer height = 1880
integer taborder = 20
string dataobject = "d_pdt_04030"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sNull, sGub, sHouse, sLotgub
long		lRow
dec {3}	dOutQty, dNotOutQty, dStock, dTempQty
SetNull(sNull)

lRow  = this.GetRow()	

///////////////////////////////////////////////////////////////////////////
// 1. 출고수량 > 현재고 이면 ERROR
// 2. 출고수량 > 미출고량 이면 ERROR
///////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = "outqty" THEN

	dOutQty = dec(this.GetText())
	
	if isnull(dOutQty) or dOutQty = 0 then return 
	
	dStock  = this.GetItemDecimal(lRow, "jego_qty")
	dNOtOutQty = this.GetItemDecimal(lRow, "unqty")
   sHouse  = dw_detail.GetItemString(1, 'house')  	
	sLotgub = this.GetItemString(lrow, 'lotgub')
	
	// 재고 허용여부 창고별로 조회 
   SELECT KYUNGY INTO :sGub FROM VNDMST WHERE CVCOD = :sHouse ;

	IF ic_status = '2'	THEN
		dTempQty = this.GetItemDecimal(lRow, "temp_outqty")
		if isnull(dTempQty) then dTempQty = 0 
		dOutQty = dOutQty - dTempQty
	END IF
		
	IF sGub = 'N' then 
		IF dOutQty > dStock		THEN
			MessageBox("확인", "출고수량은 현재고보다 클 수 없습니다.")
			this.SetItem(lRow, "outqty", 0)
			RETURN 1
		END IF
	END IF

	IF dOutQty > dNotOutQty		THEN
		MessageBox("확인", "출고수량은 미출고수량보다 클 수 없습니다.")
		this.SetItem(lRow, "outqty", 0)
		RETURN 1
	END IF

	IF sLotGub = 'Y' then 
		MessageBox("확인", "LOT NO 관리품은 재고선택 버튼을 사용하세요")
		this.SetItem(lRow, "outqty", 0)
		RETURN 1
	END IF
END IF

end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 

IF ib_ItemError = true	THEN	
	ib_ItemError = false		
	RETURN 1
END IF



//	2) Required Column  에서 Error 발생시 

string	sColumnName
sColumnName = dwo.name + "_t.text"


w_mdi_frame.sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."

RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup3)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
END IF


// 거래처
IF this.GetColumnName() = 'cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"cvcod",gs_code)
	SetItem(lRow,"vndmst_cvnas2",gs_codename)

	this.TriggerEvent("itemchanged")
	
END IF


// 의뢰담당자
IF this.GetColumnName() = 'rempno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"rempno",gs_code)
//	SetItem(Row,"",gs_codename)

END IF


// 입고예정창고
IF this.GetColumnName() = 'ipdpt'	THEN

	Open(w_vndmst_45_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"ipdpt",gs_code)
	SetItem(lRow,"vndmst_cvnas",gs_codename)

END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

event clicked;if dw_list.Rowcount() < 0 then return

dw_list.selectrow(0, false)
dw_list.selectrow(row, true)
end event

