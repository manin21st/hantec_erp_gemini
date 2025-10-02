$PBExportHeader$w_sal_06041.srw
$PBExportComments$수출창고 이동출고
forward
global type w_sal_06041 from w_inherite
end type
type dw_hidden from datawindow within w_sal_06041
end type
type dw_imhist from datawindow within w_sal_06041
end type
type dw_imhist_in from datawindow within w_sal_06041
end type
type dw_print from datawindow within w_sal_06041
end type
type dw_prt from datawindow within w_sal_06041
end type
type cbx_2 from checkbox within w_sal_06041
end type
type cbx_1 from checkbox within w_sal_06041
end type
type rb_delete from radiobutton within w_sal_06041
end type
type rb_insert from radiobutton within w_sal_06041
end type
type p_1 from uo_picture within w_sal_06041
end type
type p_3 from picture within w_sal_06041
end type
type cb_1 from commandbutton within w_sal_06041
end type
type cb_2 from commandbutton within w_sal_06041
end type
type cb_3 from commandbutton within w_sal_06041
end type
type gb_2 from groupbox within w_sal_06041
end type
end forward

global type w_sal_06041 from w_inherite
integer width = 4878
integer height = 2732
string title = "수출이동출고(한텍-운송중)"
dw_hidden dw_hidden
dw_imhist dw_imhist
dw_imhist_in dw_imhist_in
dw_print dw_print
dw_prt dw_prt
cbx_2 cbx_2
cbx_1 cbx_1
rb_delete rb_delete
rb_insert rb_insert
p_1 p_1
p_3 p_3
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
gb_2 gb_2
end type
global w_sal_06041 w_sal_06041

type variables
boolean ib_ItemError
char ic_status,   ic_yn    //타계정 사용여부(Y:사용)
string is_Last_Jpno, is_Date
datawindowchild dws, dws1
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_dup_chk ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_create_saupj (ref string arg_sjpno)
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
public function integer wf_item (string sitem, string sspec, long lrow)
public function integer wf_saupj_chk ()
end prototypes

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sLotgub, sLotNo
dec		dQty
long		lRow, lCount

lCount = dw_insert.RowCount()

FOR	lRow = 1		TO		lCount

	// 품번
	sItem = dw_insert.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[품번]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("itnbr")
		dw_insert.setfocus()
		RETURN -1
	END IF
	
	// 출고요청수량	
	dQty = dw_insert.getitemdecimal(lrow, "outqty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[출고수량]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("outqty")
		dw_insert.setfocus()
		RETURN -1
	END IF

	// LOT 여부 체크
   sLotgub = Trim(dw_insert.GetitemString(lRow, "lotgub"))
	sLotNo  = Trim(dw_insert.GetitemString(lRow, "lotsno"))
	If IsNull(sLotgub) Or sLotgub = '' Then sLotgub  = 'N'

	If sLotgub = 'Y' And (IsNull(sLotNo) Or sLotNo = '' ) Then
		f_message_chk(30,'[LOT NO]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("lotsno")
		dw_insert.setfocus()
		RETURN -1
	End If
	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 -> 행추가된 data의 의뢰번호 : 최종순번 + 1 ->SETITEM
	// 2. 전표번호가 NULL 인것만 최종순번 + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_insert.GetitemString(lRow, "imhist_iojpno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_insert.SetItem(lRow, "imhist_iojpno", is_Last_Jpno)
		END IF
	END IF

NEXT

RETURN 1
end function

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind
//
//FOR k = dw_insert.rowcount() TO 1 step - 1
//   sfind = dw_insert.getitemstring(k, 'sfind')
//
//	lReturnRow = dw_insert.Find("sfind = '"+sfind+"' ", 1, dw_insert.RowCount())
//	
//	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
//		f_message_chk(37,'[품번/사양]')
//		dw_insert.Setrow(k)
//		dw_insert.Setcolumn('pspec')
//		dw_insert.setfocus()
//		RETURN  -1
//	END IF
//NEXT

return 1
end function

public function integer wf_imhist_create (ref string arg_sjpno);///////////////////////////////////////////////////////////////////////
//
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '001'
//
///////////////////////////////////////////////////////////////////////

string	sJpno, sIOgubun,	sDate, sTagbn, sEmpno2, sDept, &
         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom
long		lRow, lRowHist, lRowHist_In
dec		dSeq, dOutQty,	dInSeq
String   sStock, sGrpno, sGubun

dw_input.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_input.GetItemString(1, "gubun")		// 수불구분

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
if sHousegubun = 'Y' then
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

sDate = dw_input.GetItemString(1, "sdate")				// 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_input.GetItemString(1, "house")   //창고
sEmpno2 = dw_input.GetItemString(1, "empno2")  //출고담당자
sEmpno  = dw_input.GetItemString(1, "empno")   //의뢰자
sDept   = dw_input.GetItemString(1, "dept")    //의뢰부서
sCvcod  = dw_input.GetItemString(1, "cvcod")   //입고처
sProject = dw_input.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_insert.RowCount()

	dOutQty = dw_insert.GetItemDecimal(lRow, "outqty")

	IF abs(dOutQty) > 0		THEN

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
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // 품번

		sPspec = trim(dw_insert.GetItemString(lRow, "pspec"))
		if sPspec = '' or isnull(sPspec) then sPspec = '.'
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // 사양
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불수량=출고수량
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// 공정코드
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// 수불승인자=담당자	
		dw_imhist.SetItem(lRowHist, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
      
		//유상웅  추가
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// 수불의뢰부서=할당.부서
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// 직접출고인 경우 '99999999' 셋팅
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  sProject)
		dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)
		
// 	dw_imhist.SetItem(lRowHist, "outchk",  'Y') 			// 출고의뢰완료
		
		// 창고이동 입고내역 생성
		IF sHouseGubun = 'Y'	and dOutQty > 0	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// 전표생성구분
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// 수불구분=창고이동입고구분
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
         //iomatrix에 타계정 구분이 Y이면 입고품에 타계정품번을 셋팅
//			if stagbn = 'Y' then 
//				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "ditnbr")) // 품번
//				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_insert.GetItemString(lRow, "dpspec")) // 사양
//			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "itnbr")) // 품번
				dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // 사양
//			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// 기준창고=입고처
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // 입고 창고의 부가 사업장 가져옮
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// 공정코드
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))
			// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
			// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
			Setnull(sSaleyn)
			SELECT HOMEPAGE
			  INTO :sSaleYN
			  FROM VNDMST
			 WHERE CVCOD = :sCvcod ;	

			IF isnull(sSaleyn) or trim(ssaleyn) = '' then
				Ssaleyn = 'N'
			end if
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////	
			sItnbr  = dw_insert.GetItemString(lRow, "itnbr")
			sStock  = dw_insert.GetItemString(lRow, "itemas_filsk") // 재고관리유무
			sGrpno = dw_insert.GetItemString(lRow, "grpno2")

			if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then	sStock = 'Y'
				
			// 수입검사 의뢰이면서 입고후 검사품인 경우
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
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun) // 무검사
				dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
				dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)
			End If
			//////////////////////////////////////////////////////////////////////////////////////////////////////

			// 무검사이며 자동승인인 경우 승인내역 저장
			IF sgubun = '1' And sSaleYn = 'Y' then
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불수량=입고수량
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// 수불승인여부
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// 수불승인여부

			End If
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태

//			dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_insert.GetItemString(lRow, "holdstock_req_dept"))		// 수불의뢰부서=할당.부서
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // 입고전표번호=출고번호
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",    dw_insert.GetItemString(lRow, "cust_no"))
		END IF
	END IF
NEXT

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_create_saupj (ref string arg_sjpno);///////////////////////////////////////////////////////////////////////
//
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '001'
// 4. 입/출고 창고의 사업장이 다를경우 입고 승인 처리 시 입/출고 재고 소진 처리
// 5. 출고 창고 재고 소진도 입고 승인 시점에 소진
///////////////////////////////////////////////////////////////////////

string	sJpno, sIOgubun,	sDate, sTagbn, sEmpno2, sDept, &
         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom, sOutSaupj
long		lRow, lRowHist, lRowHist_In
dec		dSeq, dOutQty,	dInSeq
String   sStock, sGrpno, sGubun

dw_input.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_input.GetItemString(1, "gubun")		// 수불구분

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
if sHousegubun = 'Y' then
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

sDate = dw_input.GetItemString(1, "sdate")				// 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_input.GetItemString(1, "house")   //창고
sEmpno2 = dw_input.GetItemString(1, "empno2")  //출고담당자
sEmpno  = dw_input.GetItemString(1, "empno")   //의뢰자
sDept   = dw_input.GetItemString(1, "dept")    //의뢰부서
sCvcod  = dw_input.GetItemString(1, "cvcod")   //입고처
sProject = dw_input.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_insert.RowCount()

	dOutQty = dw_insert.GetItemDecimal(lRow, "outqty")

	IF abs(dOutQty) > 0		THEN

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
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // 품번

		sPspec = trim(dw_insert.GetItemString(lRow, "pspec"))
		if sPspec = '' or isnull(sPspec) then sPspec = '.'
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // 사양
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// 공정코드		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량	
		
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불수량=출고수량	
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// 수불승인자=담당자
		
		
		dw_imhist.SetItem(lRowHist, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
      
		//유상웅  추가
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// 수불의뢰부서=할당.부서
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// 직접출고인 경우 '99999999' 셋팅
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  sProject)
		//dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)
		SELECT IPJOGUN
		   INTO :sOutSaupj
		  FROM VNDMST
		WHERE CVGU = '5'
		    AND CVSTATUS = '0'
		    AND CVCOD = :sHouse; /*출고창고의 부가사업장을 가져오도록 수정 2023.08.09 by dykim*/
		
		dw_imHist.SetItem(lRowHist, "saupj", sOutSaupj)
		
// 	dw_imhist.SetItem(lRowHist, "outchk",  'Y') 			// 출고의뢰완료
		
		// 창고이동 입고내역 생성
		IF sHouseGubun = 'Y'	and dOutQty > 0	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// 전표생성구분
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// 수불구분=창고이동입고구분
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
         //iomatrix에 타계정 구분이 Y이면 입고품에 타계정품번을 셋팅
//			if stagbn = 'Y' then 
//				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "ditnbr")) // 품번
//				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_insert.GetItemString(lRow, "dpspec")) // 사양
//			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "itnbr")) // 품번
				dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // 사양
//			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// 기준창고=입고처
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // 입고 창고의 부가 사업장 가져옮
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// 공정코드
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))
			// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
			// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
			Setnull(sSaleyn)
			SELECT HOMEPAGE
			  INTO :sSaleYN
			  FROM VNDMST
			 WHERE CVCOD = :sCvcod ;	

			IF isnull(sSaleyn) or trim(ssaleyn) = '' then
				Ssaleyn = 'N'
			end if
			//////////////////////////////////////////////////////////////////////////////////////////////////////	
			sItnbr  = dw_insert.GetItemString(lRow, "itnbr")
			sStock  = dw_insert.GetItemString(lRow, "itemas_filsk") // 재고관리유무
			sGrpno = dw_insert.GetItemString(lRow, "grpno2")

			if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then	sStock = 'Y'
				
			// 수입검사 의뢰이면서 입고후 검사품인 경우
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
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun) // 무검사
				dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
				dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)
			End If
			//////////////////////////////////////////////////////////////////////////////////////////////////////

			// 무검사이며 자동승인인 경우 승인내역 저장
			IF sgubun = '1' And sSaleYn = 'Y' then
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불수량=입고수량
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// 수불승인여부
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// 수불승인여부

			End If
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태

//			dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_insert.GetItemString(lRow, "holdstock_req_dept"))		// 수불의뢰부서=할당.부서
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // 입고전표번호=출고번호
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",    dw_insert.GetItemString(lRow, "cust_no"))
		END IF
	END IF
NEXT

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. 입출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////

dec		dOutQty, dNotOutQty, dTempQty
string	sHist_Jpno, sIodate, sDelgub, syebi5, sItnbr, sField_cd
long		lRow, lRowCount, lCnt, i, k

lRowCount = dw_insert.RowCount()

FOR lrow = 1 TO lRowCount
	 sHist_Jpno = dw_insert.GetItemString(lrow, "imhist_iojpno")
	 sIoDate    = dw_insert.GetItemString(lrow, "cndate")
	 sDelgub    = dw_insert.GetItemString(lrow, "opt")
	 sItnbr     = dw_insert.GetItemString(lrow, "itnbr")
	 sField_cd  = dw_insert.GetItemString(lrow, "field_cd")

   if sDelgub = 'N' then continue
	
	select COUNT('X')
	  into :lCnt
	  from imhist
	 where iogbn = 'O05'
	   and depot_no = 'ZZZ'
	   and field_cd = :sField_cd
	   and itnbr = :sItnbr;
	
	if lCnt > 0 then
		MessageBox("롹인", "'" + sField_cd + "' P/I의 '" + sItnbr + "' 품목 중 수출국으로 출고된 이력이 있습니다.")
		RETURN -1
	end if

	k ++	
	
	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
	if not isnull(dw_insert.GetItemString(lRow, "cndate")) AND &
	   dw_insert.GetItemString(lRow, "i_confirm") = 'N' then continue

	if not isnull(dw_insert.GetItemString(lRow, "yebi5")) then continue
		
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU" = :gs_sabu
	   and "IMHIST"."IOJPNO" = :sHist_Jpno   ;
	  
	IF SQLCA.SQLNROWS < 1	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
	  
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU"    = :gs_sabu
	   and "IMHIST"."IP_JPNO" = :sHist_Jpno   
	   AND "IMHIST"."JNPCRT"  = '011';

	IF SQLCA.SQLCODE < 0	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
		
	i ++	
Next
////////////////////////////////////////////////////////////////////////

if k < 1 then 
	messagebox("확 인", "삭제자료를 선택 후 삭제 하십시요!")
	return -1						  
end if

if i < 1 then 
	messagebox("확 인", "입고자료가 승인처리 되어 있으므로  삭제 할 수 없습니다." + &
	                    '~n' + "입고 자료를 확인하세요!")
	return -1						  
elseif	k <> i then 
	messagebox("확 인", "입고자료가 일부 승인처리 되어 있으므로 일부만 삭제 되었습니다." + &
	                    '~n' + "입고 자료를 확인하세요!")
end if	

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
dec		dOutQty, dTemp_OutQty
long		lRow, i, k, lCount

lcount = dw_insert.RowCount()

FOR	lRow = 1		TO	lcount

   k++
	
	dOutQty      = dw_insert.GetItemDecimal(lRow, "outqty")			// 출고수량(입출고history)
	dTemp_OutQty = dw_insert.GetItemDecimal(lRow, "temp_outqty")	// 출고수량(입출고history)
	sHist_Jpno   = dw_insert.GetItemString(lRow, "imhist_iojpno")
	sGubun		 = dw_insert.GetItemString(lRow, "imhist_outchk")
	
	siodate = dw_insert.GetItemString(lRow, "cndate")
	sioyn   = dw_insert.GetItemString(lRow, "i_confirm")
	
	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
	if (not isnull(siodate)) AND sioyn = 'N' then continue
	
	IF dOutQty <> dTemp_OutQty		THEN

		  UPDATE "IMHIST"  
     		  SET "IOQTY"   = :dOutQty,   
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

public function integer wf_initial ();string sCvnas

dw_input.setredraw(false)
dw_input.reset()
dw_insert.reset()

//cb_save.enabled = false
p_del.enabled = false
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

dw_input.enabled = TRUE

dw_input.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then
	// 등록시
	dw_input.settaborder("jpno",   0)
	dw_input.settaborder("sdate",  10)
	dw_input.settaborder("HOUSE",  20)
	dw_input.settaborder("PROJECT",30)
	dw_input.settaborder("empno2", 40)
	dw_input.settaborder("empno",  50)
	dw_input.settaborder("GUBUN",  60)
	dw_input.settaborder("cvcod",  70)

	dw_input.Modify("t_dsp_no.visible = 0")
	
	dw_input.Modify("t_dsp_date.visible = 1")
	dw_input.Modify("t_dsp_chang.visible = 1")
	dw_input.Modify("t_dsp_gbn.visible = 1")
	dw_input.Modify("t_dsp_demp.visible = 1")
	dw_input.Modify("t_dsp_emp.visible = 1")
	dw_input.Modify("t_dsp_cust.visible = 1")

	dw_input.setcolumn("HOUSE")
	dw_input.SetItem(1, "sdate", is_Date)
	if dws.rowcount() > 0 then
		dw_input.setitem(1, "gubun",  dws.getitemstring(1, "iogbn"))
		dw_input.SetItem(1, "check", dws.getitemstring(1, "naougu"))
	end if

	p_inq.enabled = false
	p_inq.PictureName = 'c:\erpman\image\조회_d.gif'
	
	p_addrow.enabled = true
	p_addrow.PictureName = 'c:\erpman\image\행추가_up.gif'
	
	p_delrow.enabled = true
	p_delrow.PictureName = 'c:\erpman\image\행삭제_up.gif'
	
	p_3.enabled = false
	p_3.PictureName = 'c:\erpman\image\인쇄_d.gif'
	
	w_mdi_frame.sle_msg.text = "등록"

ELSE
	dw_input.settaborder("jpno",   10)
	dw_input.settaborder("GUBUN",  0)
	dw_input.settaborder("sDATE",  0)
	dw_input.settaborder("PROJECT",0)
	dw_input.settaborder("HOUSE",  0)
	dw_input.settaborder("empno",   0)
	dw_input.settaborder("empno2",   0)
	dw_input.settaborder("cvcod",   0)

   dw_input.Modify("t_dsp_no.visible = 1")
	
	dw_input.Modify("t_dsp_date.visible = 0")
	dw_input.Modify("t_dsp_chang.visible = 0")
	dw_input.Modify("t_dsp_gbn.visible = 0")
	dw_input.Modify("t_dsp_demp.visible = 0")
	dw_input.Modify("t_dsp_emp.visible = 0")
	dw_input.Modify("t_dsp_cust.visible = 0")

	dw_input.setcolumn("JPNO")

	p_inq.enabled = true
	p_inq.PictureName = 'c:\erpman\image\조회_up.gif'
	
	p_addrow.enabled = false
	p_addrow.PictureName = 'c:\erpman\image\행추가_d.gif'
	
	p_delrow.enabled = false
	p_delrow.PictureName = 'c:\erpman\image\행삭제_d.gif'
	
	w_mdi_frame.sle_msg.text = "삭제"
	
	p_3.enabled = true
	p_3.PictureName = 'c:\erpman\image\인쇄_up.gif'
	
END IF

dw_input.setfocus()

f_mod_saupj(dw_input, 'saupj')

//출고창고 
String  ls_saupj
ls_saupj = dw_input.GetItemString(1, 'saupj')
f_child_saupj(dw_input, 'house', '%')
f_child_saupj(dw_input, 'cvcod', '%')

dw_input.SetItem(1, "gubun", 'O05')
p_print.Visible = False
cbx_1.Visible = False
cbx_2.Visible = False

select cvnas into :sCvnas from vndmst 
 where cvcod = 'ZZZ';

ic_yn = 'N'

dw_input.setitem(1, "cvcod", 'ZZZ')
dw_input.setitem(1, 'cvnas', sCvnas)	

dw_input.setredraw(true)

return  1

end function

public function integer wf_item (string sitem, string sspec, long lrow);String  sname, sitgu, snull, sispec, sfilsk, sdepot, sjijil, sSpec_code, slotgub, sGrpno2
Decimal {3} dJegoqty, dvalidqty, dqty

Setnull(sNull)

IF sspec = '' OR ISNULL(sspec) then sspec = '.'

sdepot = dw_input.getitemstring(1, 'house')

SELECT A.ITDSC, A.ISPEC, A.ITGU, A.FILSK, A.JIJIL, A.ISPEC_CODE, A.LOTGUB, B.GRPNO2
  INTO :sName, :sIspec, :sItgu, :sFilsk, :sjijil, :sspec_code, :sLotgub, :sGrpno2
  FROM ITEMAS A, ITEMAS_INSPECTION B
 WHERE A.ITNBR = B.ITNBR AND A.ITNBR = :sItem 	AND	 A.USEYN = '0'  ;                   
 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[품번]')
	dw_insert.setitem(lRow, "itnbr", sNull)	
	dw_insert.SetItem(lRow, "itdsc", sNull)
	dw_insert.SetItem(lRow, "ispec", sNull)
	dw_insert.SetItem(lRow, "jijil", sNull)
	dw_insert.SetItem(lRow, "ispec_code", sNull)
	dw_insert.SetItem(lRow, "itemas_filsk", sNull)
	dw_insert.SetItem(lRow, "itemas_itgu",  sNull)
	dw_insert.SetItem(lRow, "lotgub",  sNull)
	dw_insert.SetItem(lRow, "grpno2",  sNull)
	dw_insert.setitem(lrow, "jego_qty", 0)
	dw_insert.setitem(lrow, "valid_qty", 0)
	dw_insert.setitem(lrow, "jego_temp", 0)
	RETURN 1
END IF

dw_insert.SetItem(lRow, "itdsc", sName)
dw_insert.SetItem(lRow, "ispec", sIspec)
dw_insert.SetItem(lRow, "jijil", sjijil)
dw_insert.SetItem(lRow, "ispec_code", sspec_code)
dw_insert.SetItem(lRow, "itemas_itgu",  sitgu)
dw_insert.SetItem(lRow, "itemas_filsk", sfilsk)
dw_insert.SetItem(lRow, "lotgub", sLotgub)
dw_insert.SetItem(lRow, "grpno2", sGrpno2)

/* 재고정보 : lot관리안하는 경우만*/
If sLotgub = 'N' Then
	SELECT NVL(A.JEGO_QTY, 0), NVL(A.VALID_QTY,0), 
			 A.JEGO_QTY + ( A.JISI_QTY + A.PROD_QTY  + A.BALJU_QTY + A.POB_QC_QTY +  
								 A.INS_QTY  + A.GI_QC_QTY + A.GITA_IN_QTY ) 
							- ( A.HOLD_QTY + A.ORDER_QTY + A.MFGCNF_QTY ) 
	 INTO :dJegoqty, :dvalidqty, :dqty
	 FROM STOCK A
	WHERE A.DEPOT_NO = :SDEPOT 
	  AND A.ITNBR    = :SITEM
	  AND A.PSPEC    = :SSPEC; 
End If

dw_insert.setitem(lrow, "jego_qty", dJegoqty)
dw_insert.setitem(lrow, "valid_qty", dvalidqty)
dw_insert.setitem(lrow, "jego_temp", dqty)
 	
return 0
end function

public function integer wf_saupj_chk ();dw_input.AcceptText()

String  ls_chl
ls_chl = dw_input.GetItemString(1, 'house')
If Trim(ls_chl) = '' OR IsNull(ls_chl) Then
	MessageBox('확인', '출고창고를 선택 하십시오')
	Return -1
End If

/* 출고창고 사업장 확인 */
String  ls_csaupj
SELECT IPJOGUN
  INTO :ls_csaupj
  FROM VNDMST
 WHERE CVGU = '5' AND CVCOD = :ls_chl ;
If Trim(ls_csaupj) = '' Or IsNull(ls_csaupj) Then
	MessageBox('확인', '출고창고의 지정된 사업장 정보를 알 수 없습니다.~r~n관리자에게 문의 바랍니다.')
	Return -1
End If

String  ls_ip
ls_ip = dw_input.GetItemString(1, 'cvcod')
If Trim(ls_ip) = '' OR IsNull(ls_ip) Then
	MessageBox('확인', '입고처를 선택 하십시오')
	Return -1
End If

/* 입고창고 사업장 확인 */
String  ls_isaupj
SELECT IPJOGUN
  INTO :ls_isaupj
  FROM VNDMST
 WHERE CVGU = '5' AND CVCOD = :ls_ip ;
If Trim(ls_isaupj) = '' Or IsNull(ls_isaupj) Then
	ls_isaupj = ls_csaupj /* 개발팀(기술연구소)에서 거래처로 출고처리 하는 경우가 있음. - by shingoon 2015/12/31 */
//	MessageBox('확인', '입고창고의 지정된 사업장 정보를 알 수 없습니다.~r~n관리자에게 문의 바랍니다.')
//	Return -1
End If

/* 사업장 비교 */
If ls_csaupj <> ls_isaupj Then
	/* 사업장이 다를경우 */
	Return 1
Else
	/* 같은 사업장일 경우 */
	Return 0
End If



end function

event open;call super::open;// datawindow initial value
dw_input.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_input.getchild("gubun", dws)
dws.settransobject(sqlca)
dws.retrieve(gs_sabu, '001')

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")

string sNull, sRelcod, sNaougu, sTagbn, sCvnas
SetNull(sNull)
dw_input.SetItem(1, "gubun", 'O05')
p_print.Visible = False
cbx_1.Visible = False
cbx_2.Visible = False

// 요청구분에 대한 관련처코드
Setnull(sRelcod)
Setnull(sNaougu)
select relcod, naougu, tagbn into :sRelcod, :sNaougu, :sTagbn from iomatrix 
 where sabu = '1' and iogbn = 'O05';

select cvnas into :sCvnas from vndmst 
 where cvcod = 'ZZZ';

ic_yn = 'N'

dw_input.setitem(1, "cvcod", 'ZZZ')
dw_input.setitem(1, 'cvnas', sCvnas)	

dw_input.setitem(1, "check", sNaougu)
end event

on w_sal_06041.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
this.dw_imhist=create dw_imhist
this.dw_imhist_in=create dw_imhist_in
this.dw_print=create dw_print
this.dw_prt=create dw_prt
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.p_1=create p_1
this.p_3=create p_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
this.Control[iCurrent+2]=this.dw_imhist
this.Control[iCurrent+3]=this.dw_imhist_in
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_prt
this.Control[iCurrent+6]=this.cbx_2
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.rb_delete
this.Control[iCurrent+9]=this.rb_insert
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.p_3
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.cb_3
this.Control[iCurrent+15]=this.gb_2
end on

on w_sal_06041.destroy
call super::destroy
destroy(this.dw_hidden)
destroy(this.dw_imhist)
destroy(this.dw_imhist_in)
destroy(this.dw_print)
destroy(this.dw_prt)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.p_1)
destroy(this.p_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)

end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)

end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)

end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)

end event

event ue_print;call super::ue_print;p_3.TriggerEvent(Clicked!)

end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("取消(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", false) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", false) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", false) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", true) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", true) //// 미리보기 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", false) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", false)  //// PDF변환
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", false) //// 설정
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", true) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", true) //// 미리보기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", false) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", false)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", false)
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = true  //// 출력
m_main2.m_window.m_preview.enabled = true //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_06041
end type

type sle_msg from w_inherite`sle_msg within w_sal_06041
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06041
end type

type st_1 from w_inherite`st_1 within w_sal_06041
end type

type p_search from w_inherite`p_search within w_sal_06041
integer y = 260
end type

type p_addrow from w_inherite`p_addrow within w_sal_06041
integer x = 3383
end type

event p_addrow::clicked;call super::clicked;IF dw_input.AcceptText() = -1	THEN	RETURN

//////////////////////////////////////////////////////////
string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
         sRelcod, sNaougu, scvcod 
long		lRow

sDate    = TRIM(dw_input.GetItemString(1, "sdate"))
sHouse   = dw_input.GetItemString(1, "house")
sProject = dw_input.GetItemString(1, "project")
sEmpno2  = dw_input.GetItemString(1, "empno2")
sEmpno   = dw_input.GetItemString(1, "empno")
sDept 	= dw_input.GetItemString(1, "dept")
sGubun 	= dw_input.GetItemString(1, "gubun")
sCheck   = dw_input.GetItemString(1, "check")
scvcod   = dw_input.GetItemString(1, "cvcod")

// 출고일
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[출고일자]')
	dw_input.SetColumn("sdate")
	dw_input.SetFocus()
	RETURN
END IF

// 출고창고
IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[출고창고]')
	dw_input.SetColumn("house")
	dw_input.SetFocus()
	RETURN
END IF

IF isnull(sempno2) or sempno2 = "" 	THEN
	f_message_chk(30,'[출고담당자]')
	dw_input.SetColumn("empno2")
	dw_input.SetFocus()
	RETURN
END IF

// 요청자
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[요청자]')
	dw_input.SetColumn("empno")
	dw_input.SetFocus()
	RETURN
END IF
// 요청부서
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[요청부서]')
	dw_input.SetColumn("dept")
	dw_input.SetFocus()
	RETURN
END IF
// 수불구분
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[수불구분]')
	dw_input.SetColumn("gubun")
	dw_input.SetFocus()
	RETURN
END IF

// 요청구분에 대한 관련처코드
Setnull(sRelcod)
Setnull(sNaougu)
select relcod, naougu into :sRelcod, :sNaougu from iomatrix 
 where sabu = :gs_sabu and iogbn = :sGubun;
if  isnull(sNaougu) or trim(sNaougu) = '' or &
	(sNaougu <> '1' and sNaougu <> '2') then
	f_message_chk(208,'[출고,출문구분]')
	dw_input.SetColumn("gubun")
	dw_input.SetFocus()
	RETURN
end if 
if isnull(sRelcod) or trim(sRelcod) = '' then
	f_message_chk(208,'[입고처]')
	dw_input.SetColumn("gubun")
	dw_input.SetFocus()
	RETURN
end if

// 입고처
IF isnull(scvcod) or scvcod = "" 	THEN
	f_message_chk(30,'[입고처]')
	dw_input.SetColumn("cvcod")
	dw_input.SetFocus()
	RETURN
END IF

IF gs_saupj = '%' THEN
	gs_code = '10'
ELSE
	gs_code = gs_saupj
END IF

open(w_exppid_popup_agent)

string  s_cino,s_pino,s_itnbr,s_itdsc,s_ispec,s_order_spec, sPono, sOrderNo, sJijil, sIspecCode
double  d_piqty,d_piamt,d_piprc,d_ioqty,d_itmprc,d_itmamt,d_jqty
long    nrow,RowCnt,itemp,ix,l_piseq,l_ciseq,ll_found
int     rtn

datastore ds_multi
ds_multi = Create Datastore

/* P/I기준으로 읽어올 경우 : ClipBoard의 내용을 copy한다 */
ds_multi.DataObject = 'd_exppid_popup_agent'
rtn = ds_multi.ImportClipBoard()

/* key check */
If rtn <=0 Then 
	f_message_chk(50,'')
	Return 0
End If

rowcnt = dw_insert.RowCount()

For ix = 1 To rtn
	s_pino   = ds_multi.GetItemString(ix,"pino")
	l_piseq  = ds_multi.GetItemNumber(ix,"piseq")
	s_itnbr  = ds_multi.GetItemString(ix,"itnbr")
	s_itdsc  = ds_multi.GetItemString(ix,"itdsc")
	s_ispec  = ds_multi.GetItemString(ix,"ispec")
	sJijil   = ds_multi.GetItemString(ix,"jijil")
	sispecCode  = ds_multi.GetItemString(ix,"ispec_code")
	s_order_spec = ds_multi.GetItemString(ix,"order_spec")
	
	select sum(ioqty)
	  into :d_ioqty
	  from imhist
	 where iogbn = 'O05'
	   and cvcod = 'ZZZ'
	   and field_cd = :s_pino
	   and itnbr = :s_itnbr;
	
	if isNull(d_ioqty) then d_ioqty = 0
	
	d_piqty  = ds_multi.GetItemNumber(ix,"piqty") - d_ioqty
	
	if d_piqty <= 0 then
		MessageBox('확인', '해당 P/I 수량은 모두 출고 완료 되었습니다.')
		Return 0
	end if
	d_piprc  = ds_multi.GetItemNumber(ix,"piprc")
	d_piamt  = ds_multi.GetItemNumber(ix,"piamt")
	d_itmprc = ds_multi.GetItemNumber(ix,"itmprc")
	d_itmamt = ds_multi.GetItemNumber(ix,"itmamt")

	sPono  	= ds_multi.GetItemString(ix,"pono")
	
//	
//	ll_found = tab_1.tabpage_2.dw_insert_2.Find("pino = '" + s_pino + "' and piseq = " + string(l_piseq),1,tab_1.tabpage_2.dw_insert_2.RowCount())	
//	If ll_found > 0 Then Continue
	
	nRow = dw_insert.InsertRow(0)
	dw_insert.SetItem(nRow, 'itnbr', s_itnbr)
	wf_item(s_itnbr, '.', nRow)
	d_jqty = dw_insert.GetItemNumber(nRow, "jego_qty")
	if isNull(d_jqty) then d_jqty = 0
	dw_insert.SetItem(nRow, 'field_cd', s_pino)
	if d_piqty <= d_jqty then
		dw_insert.SetItem(nRow, 'outqty', d_piqty)
	elseif d_jqty >= 0 then
		dw_insert.SetItem(nRow, 'outqty', d_jqty)
	else
		dw_insert.SetItem(nRow, 'outqty', 0)
	end if
Next
end event

type p_delrow from w_inherite`p_delrow within w_sal_06041
integer x = 3557
end type

event p_delrow::clicked;call super::clicked;
long	lrow
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N' 가 아닌 경우)*/
if not isnull(dw_insert.GetItemString(lRow, "cndate")) AND &
	dw_insert.GetItemString(lRow, "i_confirm") <> 'N' then 
	messagebox("확 인", "입고자료가 승인처리 되어 있으므로 삭제 할 수 없습니다." + &
							  '~n' + "입고 자료를 확인하세요!")
	return 
end if	

/* 운송장번호가 연결된 경우 삭제 불가 */
if not isnull(dw_insert.GetItemString(lRow, "yebi5"))  then 
	messagebox("확 인", "운송장내역이 등록되어있습니다" + &
							  '~n' + "운송장 자료를 확인하세요!")
	return 
end if	

// 자료가 없으면 HEAD사항을 수정할 수 없음
dw_insert.DeleteRow(lRow)

if dw_insert.rowcount() < 1 then
	dw_input.enabled = true
end if


end event

type p_mod from w_inherite`p_mod within w_sal_06041
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_input.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1		THEN	RETURN

string	sArg_sdate, sJpno

//dw_input.GetItemString(1, "sdate")
//dw_input.GetItemString(1, "house")
//dw_input.GetItemString(1, "gubun")
//dw_input.GetItemString(1, "cvcod")

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
IF	wf_CheckRequiredField() = -1		THEN	RETURN 

If wf_dup_chk() = -1 then return 

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	Integer li_rtn
	li_rtn =  wf_saupj_chk()
	Choose Case li_rtn
		Case 0
			/* 입/출고창고의 사업장이 같을 경우 */
			IF wf_imhist_create(sArg_sdate) = -1 THEN
				ROLLBACK;
				RETURN
			END IF
		Case 1
			/* 입/출고창고의 사업장이 다를 경우 */
			IF wf_imhist_create_saupj(sArg_sdate) = -1 THEN
				ROLLBACK;
				RETURN
			END IF
		Case Else
			/* 오류 */
			Return
	End Choose

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
		dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate, gs_saupj)
		dw_print.print()
	ElseIf cbx_2.Checked Then
		dw_prt.retrieve(gs_sabu, sArg_sdate)
		dw_prt.print()
   end if
ELSE

	IF wf_imhist_update() = -1 THEN
		ROLLBACK;
		RETURN
	else
		commit;
	END IF
			
END IF

////////////////////////////////////////////////////////////////////////
								 
p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_del from w_inherite`p_del within w_sal_06041
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN

SetPointer(HourGlass!)

IF wf_Imhist_Delete() = -1		THEN	
	rollback;
	RETURN
end if

COMMIT;

p_can.TriggerEvent("clicked")
	
	

end event

type p_inq from w_inherite`p_inq within w_sal_06041
integer x = 3749
boolean enabled = false
string picturename = "C:\erpman\image\조회_d.gif"
end type

event p_inq::clicked;call super::clicked;
if dw_input.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

sJpno   	= dw_input.getitemstring(1, "jpno")

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[출고번호]')
	dw_input.SetColumn("jpno")
	dw_input.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_insert.Retrieve(gs_sabu, sjpno) <	1		THEN
	messagebox("확인","해당자료가 없습니다.")
	dw_input.setcolumn("jpno")
	dw_input.setfocus()
	return
end if

is_Last_Jpno = dw_insert.GetItemString(dw_insert.RowCount(), "imhist_iojpno")

dw_input.enabled = false

p_del.enabled = true
p_del.PictureName = 'c:\erpman\image\삭제_up.gif'

dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()
//cb_save.enabled = true
end event

type p_print from w_inherite`p_print within w_sal_06041
integer x = 3195
integer y = 252
boolean enabled = false
end type

type p_can from w_inherite`p_can within w_sal_06041
end type

event p_can::clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_exit from w_inherite`p_exit within w_sal_06041
end type

type p_ins from w_inherite`p_ins within w_sal_06041
integer y = 260
boolean enabled = false
end type

type p_new from w_inherite`p_new within w_sal_06041
end type

type dw_input from w_inherite`dw_input within w_sal_06041
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 56
integer width = 4742
integer height = 312
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06041"
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate,  sDate2, sDept, sName, sProject, old_gubun,	&
			sGubun, sHouse, sCheck, sNull, sRelcod, sNaougu, sEmpno, sEmpnm, sTagbn, spass
string   scode, sname1, get_dept, get_deptnm, sname2, sEmpno2, sEmpnm2, scvcod, scvnas, sIpjogun
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[출고일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'house' THEN
	sHouse = trim(this.gettext())
	
	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고창고]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno2", sNull)
		this.setitem(1, "empnm2", sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno2", sNull)
			this.setitem(1, "empnm2", sNull)
			return 1
      END IF		
	END IF

	this.setitem(1, "empno2", sNull)
	this.setitem(1, "empnm2", sNull)

	SELECT A.EMPNO, B.EMPNAME INTO :sempno, :sname
		FROM DEPOT_EMP A, P1_MASTER B
		WHERE A.EMPNO = B.EMPNO
		AND	A.DEPOT_NO = :sHouse
		AND   A.REPRE = 'Y'; /* 대표 담당자가 셋팅되도록 수정 - 2024.04.02 by dykim */
		//AND A.OWNER = 'Y'
		
	If isNull(sempno) Or sempno = '' Then
		this.SetItem(1,"empno2", '')
		this.SetItem(1,"empnm2", '')
	Else
		this.SetItem(1,"empno2", sempno)
		this.SetItem(1,"empnm2", sname)
	End If
	
ELSEIF this.GetColumnName() = "empno2" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empnm2', sname)
      return 
   end if
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("확 인", "창고를 먼저 입력하세요")
		this.setitem(1, "empno2", sNull)
		this.setitem(1, "empnm2", sNull)
		this.setcolumn('house')
		this.setfocus()
		return 1
	end if
	
   ireturn = f_get_name2('출고승인자', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno2', scode)
	this.setitem(1, 'empnm2', sname)
   return ireturn 
	
ELSEIF this.GetColumnName() = 'empno' THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empnm', sNull)
      return 
   end if
   ireturn = f_get_name2('사번', 'Y', scode, sname1, shouse)    //1이면 실패, 0이 성공	
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empnm', sname1)
	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :get_dept, :get_deptnm  
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		this.setitem(1, 'dept', get_dept)
		this.setitem(1, 'deptname', get_deptnm)
	END IF	
   return ireturn 
ELSEif this.getcolumnname() = 'gubun' then
	sGubun = this.gettext()
	if sGubun = 'O06' or sGubun = 'O11' then
		p_print.Visible = True
	else
		p_print.Visible = False
	end if
	old_Gubun = this.getitemstring(1, 'gubun')
	// 요청구분에 대한 관련처코드
	Setnull(sRelcod)
	Setnull(sNaougu)
	select relcod, naougu, tagbn into :sRelcod, :sNaougu, :sTagbn from iomatrix 
	 where sabu = :gs_sabu and iogbn = :sGubun;

	IF sTagbn = 'Y' then
		ic_yn = 'Y'
		MessageBox("확 인", "타계정 대체는 출고의뢰에서 사용하세요!", StopSign!)
		this.setitem(1, 'gubun', old_gubun)
		return 1
	ELSE
		ic_yn = 'N'
	END IF
	
	this.setitem(1, "cvcod", sNull)
	this.setitem(1, 'cvnas', sNull)		

	if  isnull(sNaougu) or trim(sNaougu) = '' or &
		(sNaougu <> '1' and sNaougu <> '2') then
		f_message_chk(208,'[출고,출문구분]')
		dw_input.SetColumn("gubun")
		dw_input.SetFocus()
		RETURN 1
	end if 
	if isnull(sRelcod) or trim(sRelcod) = '' then
		f_message_chk(208,'[입고처]')
		dw_input.SetColumn("gubun")
		dw_input.SetFocus()
		RETURN 1
	end if	
	
	this.setitem(1, "check", sNaougu)

ELSEIF this.GetColumnName() = "cvcod" THEN
   
	string	sChk, sgbn1, sgbn2, sgbn3, sgbn4, sgbn5 

	sgubun = dw_input.getitemstring(1, "gubun")
	
	if sgubun = '' or isnull(sgubun) then 
		messagebox("확 인", "수불구분을 먼저 입력하세요!")
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, 'cvnas', sNull)		
		this.setcolumn('gubun')
		this.setfocus()
		return 1
	end if
	
	/* 관련처 기준 검색 */
	SELECT RELCOD INTO :sChk FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sGubun;
	    
	sCode  = this.GetText()						
	if sCode = "" or isnull(sCode) then 
		this.setitem(1, 'cvnas', snull)
		return 
	end if
	
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case schk
			 case '1'
					sgbn1 = '5'; sgbn2 = '5'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '2'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '4'; sgbn4 = '4'; sgbn5 = '4'
			 case '3'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '9'; sgbn4 = '9'; sgbn5 = '9'
			 case '4'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '5'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '4'; sgbn4 = '5'; sgbn5 = '9'
			 case else
					f_message_chk(208,'[입고처]')
					this.setitem(1, "cvcod", sNull)
					this.setitem(1, 'cvnas', sNull)		
				   return 1
	End choose

	SELECT "CVNAS2", NVL("IPJOGUN", '10')
	  INTO :sName, :sIpjogun
	  FROM "VNDMST" 
	 WHERE "CVCOD" = :sCode  AND
			 "CVGU"  IN (:sgbn1, :sgbn2, :sgbn3, :sgbn4, :sgbn5) ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[입고처]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, 'cvnas', sNull)		
	   return 1
	ELSE
		this.setitem(1, 'cvnas', sName)
		This.SetItem(1, 'saupj', sIpjogun)
	END IF
	
ELSEIF this.getcolumnname() = "jpno"	then
	string	sJpno
	sJpno = this.gettext() 
	
	  SELECT A.INSDAT,						// 출고일자
				A.IO_EMPNO,			         // 출고담당자
				FUN_GET_EMPNO(A.IO_EMPNO),	// 출고담당자명
				A.IOGBN,			            // 출고구분
				A.DEPOT_NO,			         // 출고창고
				A.IOREDEPT, 	            // 요청부서
				FUN_GET_DPTNO(A.IOREDEPT), // 부서명
				A.IOREEMP,		            // 요청자
				FUN_GET_EMPNO(A.IOREEMP), 	// 요청자명
            A.PJT_CD,                  // 프로젝트 번호
            B.NAOUGU,
            A.CVCOD,                   // 입고처 코드
				FUN_GET_CVNAS(A.CVCOD)     // 입고처명
		 INTO :sDate,   :sEmpno2, :sEmpnm2,  :sGubun, :sHouse, :sDept, :sName, 
				:sEmpno,  :sEmpnm,  :sProject, :sCheck ,:sCvcod, :sCvnas   	
		 FROM IMHIST A, IOMATRIX B 
		WHERE A.SABU   = :gs_sabu AND
				A.IOJPNO LIKE :sJpno||'%' 	AND
				TRIM(A.JNPCRT) LIKE '001' AND
				A.GURDAT = '99999999' AND   //직접출고시 검사요청일에 '99999999' 저장
				A.CVCOD = 'ZZZ' AND
            A.SABU   = B.SABU AND
            A.IOGBN  = B.IOGBN AND 
				ROWNUM = 1    	;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고번호]')
		this.setitem(1, "jpno",     sNull)
		this.setitem(1, "sdate",    sNull)
		this.setitem(1, "dept",     sNull)
		this.setitem(1, "deptname", sNull)
		this.setitem(1, "empno", 	 sNull)
		this.setitem(1, "empnm",    sNull)
		this.setitem(1, "empno2", 	 sNull)
		this.setitem(1, "empnm2",    sNull)
		this.setitem(1, "gubun",    sNull)
		this.setitem(1, "house",    sNull)
		this.setitem(1, "check",    sNull)
		this.setitem(1, "project",  sNull)
		this.setitem(1, "cvcod",    sNull)
		this.setitem(1, "cvnas",    sNull)
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
		this.setitem(1, "jpno",     sNull)
		this.setitem(1, "sdate",    sNull)
		this.setitem(1, "dept",     sNull)
		this.setitem(1, "deptname", sNull)
		this.setitem(1, "empno", 	 sNull)
		this.setitem(1, "empnm",    sNull)
		this.setitem(1, "empno2", 	 sNull)
		this.setitem(1, "empnm2",    sNull)
		this.setitem(1, "gubun",    sNull)
		this.setitem(1, "house",    sNull)
		this.setitem(1, "check",    sNull)
		this.setitem(1, "project",  sNull)
		this.setitem(1, "cvcod",    sNull)
		this.setitem(1, "cvnas",    sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "jpno",     sNull)
			this.setitem(1, "sdate",    sNull)
			this.setitem(1, "dept",     sNull)
			this.setitem(1, "deptname", sNull)
			this.setitem(1, "empno", 	 sNull)
			this.setitem(1, "empnm",    sNull)
			this.setitem(1, "empno2", 	 sNull)
			this.setitem(1, "empnm2",    sNull)
			this.setitem(1, "gubun",    sNull)
			this.setitem(1, "house",    sNull)
			this.setitem(1, "check",    sNull)
			this.setitem(1, "project",  sNull)
			this.setitem(1, "cvcod",    sNull)
			this.setitem(1, "cvnas",    sNull)
			return 1
      END IF		
	END IF

	this.setitem(1, "sdate",    sDate)	
	this.setitem(1, "empno2", 	 sEmpno2)	
	this.setitem(1, "empnm2",   sempnm2)	
	this.setitem(1, "gubun",    sGubun)	
	this.setitem(1, "house",    sHouse)		
	this.setitem(1, "dept", 	 sDept)	
	this.setitem(1, "deptname", sName)	
	this.setitem(1, "empno", 	 sEmpno)	
	this.setitem(1, "empnm",    sempnm)	
	this.setitem(1, "project",  sProject)		
	this.setitem(1, "check",    sCheck)		
	this.setitem(1, "cvcod",    scvcod)
	this.setitem(1, "cvnas",    scvnas)
	
	select tagbn into :sTagbn from iomatrix where sabu = :gs_sabu and iogbn = :sGubun; 

	IF sTagbn = 'Y' then
		ic_yn = 'Y'
		MessageBox("확 인", "타계정 대체는 출고의뢰에서 사용가능합니다.", StopSign!)
		return 1
	ELSE
		ic_yn = 'N'
	END IF
	p_inq.TriggerEvent(Clicked!)
ELSEIF this.getcolumnname() = "project"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
	SELECT "VW_PROJECT"."SABU"  
     INTO :sCode
     FROM "VW_PROJECT"  
    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
          ( "VW_PROJECT"."PJTNO" = :sProject )   ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[프로젝트 번호]')
		this.setitem(1, "project", sNull)
	   return 1
	END IF

ElseIf This.GetColumnName() = 'saupj' Then
	//출고창고 
	String  ls_saupj
	ls_saupj = Trim(This.GetText())
	f_child_saupj(This, 'house', ls_saupj)
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 부서
IF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",gs_code)
	SetItem(1,"deptname",gs_codename)

elseIF this.GetColumnName() = "empno" THEN
   
	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
   this.triggerEvent(itemchanged!)	
elseIF this.GetColumnName() = 'empno2'	THEN
	this.accepttext() 
   gs_gubun = '4' 
	gs_code = this.getitemstring(1, 'house')
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno2",gs_code)
	SetItem(1,"empnm2",gs_codename)
ELSEIF this.GetColumnName() = 'cvcod'	THEN

	string	sCheck, sgubun
	sgubun = dw_input.getitemstring(1, "gubun")

	if sgubun = '' or isnull(sgubun) then 
		messagebox("확 인", "수불구분을 먼저 입력하세요!")
		this.setcolumn('gubun')
		this.setfocus()
		return 1
	end if

	/* 관련처 기준 검색 */
	SELECT RELCOD INTO :SCHECK FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sgubun;
	    
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case scheck
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
					open(w_vndmst_popup)
	End choose

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	SetItem(1,"cvcod",gs_code)
	this.TriggerEvent("itemchanged")
elseif this.getcolumnname() = "jpno" 	then
	gs_gubun = '001'
	open(w_chulgo_popup3_ht1)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
elseif this.getcolumnname() = "project" 	then
	gs_gubun = '1'
	open(w_project_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "project", gs_code)
end if


end event

type cb_delrow from w_inherite`cb_delrow within w_sal_06041
boolean visible = false
integer x = 3918
integer y = 916
end type

event cb_delrow::clicked;call super::clicked;p_delrow.TriggerEvent(Clicked!)

end event

type cb_addrow from w_inherite`cb_addrow within w_sal_06041
boolean visible = false
integer x = 3589
integer y = 912
end type

event cb_addrow::clicked;call super::clicked;p_addrow.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_06041
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 404
integer width = 4742
integer height = 1964
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_06041_2"
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

event itemchanged;string	sItem, sName, sSpec, sCode, sHouse, sIogbn, sNull, spspec, sGub, sJijil, sSpec_code,sLotNo, sLotgub
long		lRow
dec{3}	dOutQty, dStock, dTempQty, djegoqty, dvalidqty, dqty
integer  ireturn
SetNull(sNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = 'itnbr'	THEN
	sItem  = trim(this.GetText())
	spspec = this.getitemstring(lrow, "pspec")
	ireturn = wf_item(sitem, sPspec, lrow)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name3('품명', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name3('규격', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name3('재질', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sspec_code = trim(this.GetText())
	ireturn = f_get_name3('규격코드', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "pspec"	THEN
	spspec = trim(this.GetText())
	sitem = this.getitemstring(lrow, "itnbr")
	IF sitem = '' OR ISNULL(sitem) then return 
	wf_item(sitem, sPspec, lrow)
ELSEIF this.GetColumnName() = "outqty" THEN

	dOutQty = dec(this.GetText())
	if isnull(dOutQty) or dOutQty = 0 then return 

	dStock  = this.GetItemDecimal(lRow, "jego_qty")
	
   sHouse  = dw_input.GetItemString(1, 'house')  	

	// 재고 허용여부 창고별로 조회 
   SELECT KYUNGY INTO :sGub FROM VNDMST WHERE CVCOD = :sHouse ;

	IF sGub = 'N' then 
		IF ic_status = '2'	THEN
			dTempQty = this.GetItemDecimal(lRow, "temp_outqty")
			dOutQty = dOutQty - dTempQty
		END IF
			
		IF dOutQty > dStock		THEN
			MessageBox("확인", "출고수량은 현재고보다 클 수 없습니다.")
			this.SetItem(lRow, "outqty", 0)
			RETURN 1
		END IF
	END IF
// Lot No 입력시
ELSEIF this.GetColumnName() = "lotsno" THEN
	sLotNo = Trim(GetText())
	sItem  = this.getitemstring(lrow, "itnbr")
	spspec = this.getitemstring(lrow, "pspec")
	sHouse  = dw_input.GetItemString(1, 'house')
	sLotgub = this.getitemstring(lrow, "lotgub")
	
	If IsnUll(sItem) Or Trim(sItem) = '' Then
		MessageBox("확인", "품번을 먼저 지정하세요.!!")
		this.SetItem(lRow, "itnbr", 0)
		RETURN 1
	END IF

	If sLotgub <> 'Y' Then
		MessageBox("확인", "LOT NO관리품번이 아닙니다.!!")
		this.SetItem(lRow, "itnbr", 0)
		RETURN 1
	END IF
	
	SELECT NVL(A.JEGO_QTY, 0), NVL(A.VALID_QTY,0), 
			 A.JEGO_QTY + ( A.JISI_QTY + A.PROD_QTY  + A.BALJU_QTY + A.POB_QC_QTY +  
								 A.INS_QTY  + A.GI_QC_QTY + A.GITA_IN_QTY ) 
							- ( A.HOLD_QTY + A.ORDER_QTY + A.MFGCNF_QTY ) 
	 INTO :dJegoqty, :dvalidqty, :dqty
	 FROM STOCK_LOT_VIEW A
	WHERE A.DEPOT_NO = :sHouse 
	  AND A.ITNBR    = :SITEM
	  AND A.PSPEC    = :spspec
	  AND A.LOTNO    = :sLotno; 
	  
	dw_insert.setitem(lrow, "jego_qty",  dJegoqty)
	dw_insert.setitem(lrow, "valid_qty", dvalidqty)
	dw_insert.setitem(lrow, "jego_temp", dqty)
END IF

end event

event itemerror;RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

type cb_mod from w_inherite`cb_mod within w_sal_06041
boolean visible = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_06041
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_sal_06041
boolean visible = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06041
boolean visible = false
end type

type cb_print from w_inherite`cb_print within w_sal_06041
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_sal_06041
boolean visible = false
end type

type cb_search from w_inherite`cb_search within w_sal_06041
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_sal_06041
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06041
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06041
end type

type r_head from w_inherite`r_head within w_sal_06041
integer width = 4750
integer height = 320
end type

type r_detail from w_inherite`r_detail within w_sal_06041
integer y = 400
integer width = 4750
end type

type dw_hidden from datawindow within w_sal_06041
boolean visible = false
integer x = 1006
integer y = 1340
integer width = 1317
integer height = 168
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_sal_06041
boolean visible = false
integer x = 96
integer y = 2328
integer width = 494
integer height = 212
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_imhist_in from datawindow within w_sal_06041
boolean visible = false
integer x = 713
integer y = 2332
integer width = 494
integer height = 212
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_print from datawindow within w_sal_06041
boolean visible = false
integer x = 1317
integer y = 2336
integer width = 855
integer height = 104
integer taborder = 140
boolean bringtotop = true
boolean titlebar = true
string title = "직접출고 출력"
string dataobject = "d_pdt_04035_02_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_prt from datawindow within w_sal_06041
boolean visible = false
integer x = 3849
integer y = 1804
integer width = 686
integer height = 400
integer taborder = 120
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_pdt_04035_02_p2"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cbx_2 from checkbox within w_sal_06041
integer x = 3561
integer y = 228
integer width = 393
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "거래명세표"
end type

type cbx_1 from checkbox within w_sal_06041
integer x = 3561
integer y = 288
integer width = 288
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "출고증"
end type

type rb_delete from radiobutton within w_sal_06041
integer x = 4416
integer y = 252
integer width = 242
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "수정"
end type

event clicked;ic_status = '2'
ic_yn = 'N'

dw_insert.DataObject = 'd_sal_06041_2'
dw_insert.SetTransObject(SQLCA)

dw_insert.Object.opt.Visible = True
dw_insert.Object.opt_t.Visible = True

p_1.enabled = false

wf_Initial()


end event

type rb_insert from radiobutton within w_sal_06041
integer x = 4055
integer y = 252
integer width = 242
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "등록"
boolean checked = true
end type

event clicked;ic_status = '1'	// 등록
ic_yn = 'N'

dw_insert.DataObject = 'd_sal_06041_1'
dw_insert.SetTransObject(SQLCA)

dw_insert.Object.opt.Visible = false
dw_insert.Object.opt_t.Visible = false

p_1.enabled = true

wf_Initial()


end event

type p_1 from uo_picture within w_sal_06041
boolean visible = false
integer x = 3301
integer y = 80
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\재고선택_up.gif"
end type

event clicked;call super::clicked;if dw_input.enabled then

	p_addrow.triggerevent(clicked!)
	
	string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
				sRelcod, sNaougu, scvcod 
	long		lRow
	
	sDate    = TRIM(dw_input.GetItemString(1, "sdate"))
	sHouse   = dw_input.GetItemString(1, "house")
	sEmpno2  = dw_input.GetItemString(1, "empno2")
	sEmpno   = dw_input.GetItemString(1, "empno")
	sDept 	= dw_input.GetItemString(1, "dept")
	sGubun 	= dw_input.GetItemString(1, "gubun")
	sCheck   = dw_input.GetItemString(1, "check")
	scvcod   = dw_input.GetItemString(1, "cvcod")
	
	if isnull(sdate)   or trim(sdate)   = '' or &
		isnull(shouse)  or trim(shouse)  = '' or &
		isnull(sempno2) or trim(sempno2) = '' or &
		isnull(sempno)  or trim(sempno)  = '' or &
		isnull(sdept)   or trim(sdept)   = '' or &
		isnull(sgubun)  or trim(sgubun)  = '' or &
		isnull(scheck)  or trim(scheck)  = '' or &
		isnull(scvcod)  or trim(scvcod)  = '' Then 
		return
	end if
	
	dw_insert.deleterow(dw_insert.getrow())
	
end if

datawindow dwname	

dw_input.accepttext()
dwname = dw_insert
gs_code = dw_input.getitemstring(1, "house")

openwithparm(w_pdt_04037, dwname)

setnull(gs_code)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고선택_up.gif"
end event

type p_3 from picture within w_sal_06041
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3968
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\인쇄_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\인쇄_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\인쇄_up.gif'
end event

event clicked;String sJpno
Long   ll_msg

sJpno   = dw_input.GetItemString(1, "jpno")

if dw_insert.RowCount() > 0 then
	if cbx_1.checked then 	
			dw_print.retrieve(gs_sabu, sJpno, sJpno, gs_saupj)
			dw_print.print()
	end if
	If cbx_2.Checked Then
			dw_prt.retrieve(gs_sabu, sJpno)
			dw_prt.print()
	end if
else
	MessageBox("인쇄확인", "조회 후 인쇄하시기 바랍니다.")	
end if
end event

type cb_1 from commandbutton within w_sal_06041
integer x = 3310
integer y = 84
integer width = 311
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고선택"
end type

event clicked;p_1.TriggerEvent(Clicked!)

end event

type cb_2 from commandbutton within w_sal_06041
integer x = 3634
integer y = 84
integer width = 311
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행추가"
end type

event clicked;p_addrow.TriggerEvent(Clicked!)
end event

type cb_3 from commandbutton within w_sal_06041
integer x = 3959
integer y = 84
integer width = 311
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행삭제"
end type

event clicked;p_delrow.TriggerEvent(Clicked!)
end event

type gb_2 from groupbox within w_sal_06041
integer x = 3968
integer y = 200
integer width = 754
integer height = 148
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
end type

