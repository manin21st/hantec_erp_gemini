$PBExportHeader$w_pdt_04035_han6.srw
$PBExportComments$품목대체출고등록(공장품번->제품품번)
forward
global type w_pdt_04035_han6 from w_inherite
end type
type dw_detail from datawindow within w_pdt_04035_han6
end type
type dw_list from datawindow within w_pdt_04035_han6
end type
type dw_hidden from datawindow within w_pdt_04035_han6
end type
type dw_imhist from datawindow within w_pdt_04035_han6
end type
type dw_imhist_in from datawindow within w_pdt_04035_han6
end type
type dw_print from datawindow within w_pdt_04035_han6
end type
type dw_prt from datawindow within w_pdt_04035_han6
end type
type cbx_2 from checkbox within w_pdt_04035_han6
end type
type cbx_1 from checkbox within w_pdt_04035_han6
end type
type rb_delete from radiobutton within w_pdt_04035_han6
end type
type rb_insert from radiobutton within w_pdt_04035_han6
end type
type p_1 from uo_picture within w_pdt_04035_han6
end type
type p_3 from picture within w_pdt_04035_han6
end type
type gb_2 from groupbox within w_pdt_04035_han6
end type
type rr_1 from roundrectangle within w_pdt_04035_han6
end type
end forward

global type w_pdt_04035_han6 from w_inherite
integer width = 4654
integer height = 2424
string title = "품목대체 출고등록(공장품번)"
dw_detail dw_detail
dw_list dw_list
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
gb_2 gb_2
rr_1 rr_1
end type
global w_pdt_04035_han6 w_pdt_04035_han6

type variables
boolean ib_ItemError
char ic_status,   ic_yn    //타계정 사용여부(Y:사용)
string is_Last_Jpno, is_Date
datawindowchild dws
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_dup_chk ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
public function integer wf_item (string sitem, string sspec, long lrow)
end prototypes

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sLotgub, sLotNo
dec		dQty
long		lRow, lCount

lCount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount

	// 품번
	sItem = dw_list.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[품번]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("itnbr")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	// 출고요청수량	
	dQty = dw_list.getitemdecimal(lrow, "outqty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[출고수량]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("outqty")
		dw_list.setfocus()
		RETURN -1
	END IF

	// LOT 여부 체크
   sLotgub = Trim(dw_list.GetitemString(lRow, "lotgub"))
	sLotNo  = Trim(dw_list.GetitemString(lRow, "lotsno"))
	If IsNull(sLotgub) Or sLotgub = '' Then sLotgub  = 'N'

	If sLotgub = 'Y' And (IsNull(sLotNo) Or sLotNo = '' ) Then
		f_message_chk(30,'[LOT NO]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("lotsno")
		dw_list.setfocus()
		RETURN -1
	End If
	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 -> 행추가된 data의 의뢰번호 : 최종순번 + 1 ->SETITEM
	// 2. 전표번호가 NULL 인것만 최종순번 + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_list.GetitemString(lRow, "imhist_iojpno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_list.SetItem(lRow, "imhist_iojpno", is_Last_Jpno)
		END IF
	END IF

NEXT

RETURN 1
end function

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind
//
//FOR k = dw_list.rowcount() TO 1 step - 1
//   sfind = dw_list.getitemstring(k, 'sfind')
//
//	lReturnRow = dw_list.Find("sfind = '"+sfind+"' ", 1, dw_list.RowCount())
//	
//	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
//		f_message_chk(37,'[품번/사양]')
//		dw_list.Setrow(k)
//		dw_list.Setcolumn('pspec')
//		dw_list.setfocus()
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

dw_detail.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_detail.GetItemString(1, "gubun")		// 수불구분 - 품목대체 O25

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

sDate = dw_detail.GetItemString(1, "sdate")				// 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_detail.GetItemString(1, "house")   //창고
sEmpno2 = dw_detail.GetItemString(1, "empno2")  //출고담당자
sEmpno  = dw_detail.GetItemString(1, "empno")   //의뢰자
sDept   = dw_detail.GetItemString(1, "dept")    //의뢰부서
sCvcod  = dw_detail.GetItemString(1, "cvcod")   //입고처
sProject = dw_detail.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_list.RowCount()

	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")

	IF abs(dOutQty) > 0		THEN

		////////////////////////////////////////////////////////////////////////////////
		// ** 입출고HISTORY 생성 **
		////////////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
		
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'039')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// 수불구분=요청구분
	
		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// 수불일자=출고일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // 품번

		sPspec = trim(dw_list.GetItemString(lRow, "pspec"))
		if sPspec = '' or isnull(sPspec) then sPspec = '.'
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // 사양
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// 수불수량=출고수량
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// 공정코드
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// 수불승인자=담당자	
		dw_imhist.SetItem(lRowHist, "filsk",   'Y') // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    '5') 	// 구입형태
      
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// 수불의뢰부서=할당.부서
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// 직접출고인 경우 '99999999' 셋팅
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_list.GetItemString(lRow, "lotsno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  sProject)
		dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)

	
		// 품목대체 입고내역 생성
		IF sHouseGubun = 'Y'	and dOutQty > 0	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",		'040')			// 전표생성구분
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// 수불구분=창고이동입고구분
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
			dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "ditnbr")) // 대체품번
			dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // 사양
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// 기준창고=입고처
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // 입고 창고의 부가 사업장 가져옮
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// 공정코드		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   'Y') // 재고관리유무			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_list.GetItemString(lRow, "lotsno"))

			dw_imHist_in.SetItem(lRowHist_in, "qcgub",	'1') // 무검사
			dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
			dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// 검사일자=출고일자

			dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_list.GetItemDecimal(lRow, "outqty")) 	// 수불수량=입고수량
			dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
			dw_imhist_in.SetItem(lRowHist_in, "io_empno", sEmpno2)
			dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'Y')			// 수불승인여부
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    '5') 	// 구입형태

			dw_imHist_in.SetItem(lRowHist_in, "ioredept",sDept)		// 수불의뢰부서=할당.부서
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // 입고전표번호=출고번호
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
string	sHist_Jpno, sIodate, sDelgub, syebi5
long		lRow, lRowCount, i, k

lRowCount = dw_list.RowCount()

FOR lrow = 1 TO lRowCount
	 sHist_Jpno = dw_list.GetItemString(lrow, "imhist_iojpno")
	 sIoDate    = dw_list.GetItemString(lrow, "cndate")
	 sDelgub    = dw_list.GetItemString(lrow, "opt")

   if sDelgub = 'N' then continue

	k ++	
	
	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
	if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
	   dw_list.GetItemString(lRow, "i_confirm") = 'N' then continue

	if not isnull(dw_list.GetItemString(lRow, "yebi5")) then continue
		
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
	   AND "IMHIST"."JNPCRT"  = '039';

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

lcount = dw_list.RowCount()

FOR	lRow = 1		TO	lcount

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

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()

//cb_save.enabled = false
p_del.enabled = false
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then
	// 등록시
	dw_detail.settaborder("jpno",   0)
	dw_detail.settaborder("sdate",  10)
	dw_detail.settaborder("HOUSE",  20)
	dw_detail.settaborder("PROJECT",30)
	dw_detail.settaborder("empno2", 40)
	dw_detail.settaborder("empno",  50)
//	dw_detail.settaborder("GUBUN",  60)
//	dw_detail.settaborder("cvcod",  70)

	dw_detail.Modify("t_dsp_no.visible = 0")
	
	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_chang.visible = 1")
	dw_detail.Modify("t_dsp_gbn.visible = 1")
	dw_detail.Modify("t_dsp_demp.visible = 1")
	dw_detail.Modify("t_dsp_emp.visible = 1")
//	dw_detail.Modify("t_dsp_cust.visible = 1")

	dw_detail.setcolumn("HOUSE")
	dw_detail.SetItem(1, "sdate", is_Date)
	if dws.rowcount() > 0 then
//		dw_detail.setitem(1, "gubun",  dws.getitemstring(1, "iogbn"))
//		dw_detail.SetItem(1, "check", dws.getitemstring(1, "naougu"))
		dw_detail.setitem(1, "gubun",  'O25')
		dw_detail.SetItem(1, "check", '1')
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
	dw_detail.settaborder("jpno",   10)
//	dw_detail.settaborder("GUBUN",  0)
	dw_detail.settaborder("sDATE",  0)
	dw_detail.settaborder("PROJECT",0)
	dw_detail.settaborder("HOUSE",  0)
	dw_detail.settaborder("empno",   0)
	dw_detail.settaborder("empno2",   0)
//	dw_detail.settaborder("cvcod",   0)

   dw_detail.Modify("t_dsp_no.visible = 1")
	
	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_chang.visible = 0")
	dw_detail.Modify("t_dsp_gbn.visible = 0")
	dw_detail.Modify("t_dsp_demp.visible = 0")
	dw_detail.Modify("t_dsp_emp.visible = 0")
//	dw_detail.Modify("t_dsp_cust.visible = 0")

	dw_detail.setcolumn("JPNO")

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

dw_detail.setfocus()

f_mod_saupj(dw_detail, 'saupj')

//출고창고 
String  ls_saupj
ls_saupj = dw_detail.GetItemString(1, 'saupj')
f_child_saupj(dw_detail, 'house', '%')

dw_detail.setredraw(true)

return  1

end function

public function integer wf_item (string sitem, string sspec, long lrow);String  sname, sitgu, snull, sispec, sfilsk, sdepot, sjijil, sSpec_code, slotgub, sGrpno2
Decimal {3} dJegoqty, dvalidqty, dqty

Setnull(sNull)

IF sspec = '' OR ISNULL(sspec) then sspec = '.'

sdepot = dw_detail.getitemstring(1, 'house')

SELECT A.ITDSC, A.ISPEC, A.ITGU, A.FILSK, A.JIJIL, A.ISPEC_CODE, A.LOTGUB, B.GRPNO2
  INTO :sName, :sIspec, :sItgu, :sFilsk, :sjijil, :sspec_code, :sLotgub, :sGrpno2
  FROM ITEMAS A, ITEMAS_INSPECTION B
 WHERE A.ITNBR = B.ITNBR AND A.ITNBR = :sItem 	AND	 A.USEYN = '0'  ;                   
 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[품번]')
	dw_list.setitem(lRow, "itnbr", sNull)	
	dw_list.SetItem(lRow, "itdsc", sNull)
	dw_list.SetItem(lRow, "ispec", sNull)
	dw_list.SetItem(lRow, "jijil", sNull)
	dw_list.SetItem(lRow, "ispec_code", sNull)
	dw_list.SetItem(lRow, "itemas_filsk", sNull)
	dw_list.SetItem(lRow, "itemas_itgu",  sNull)
	dw_list.SetItem(lRow, "lotgub",  sNull)
	dw_list.SetItem(lRow, "grpno2",  sNull)
	dw_list.setitem(lrow, "jego_qty", 0)
	dw_list.setitem(lrow, "valid_qty", 0)
	dw_list.setitem(lrow, "jego_temp", 0)
	RETURN 1
END IF

dw_list.SetItem(lRow, "itdsc", sName)
dw_list.SetItem(lRow, "ispec", sIspec)
dw_list.SetItem(lRow, "jijil", sjijil)
dw_list.SetItem(lRow, "ispec_code", sspec_code)
dw_list.SetItem(lRow, "itemas_itgu",  sitgu)
dw_list.SetItem(lRow, "itemas_filsk", sfilsk)
dw_list.SetItem(lRow, "lotgub", sLotgub)
dw_list.SetItem(lRow, "grpno2", sGrpno2)

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

dw_list.setitem(lrow, "jego_qty", dJegoqty)
dw_list.setitem(lrow, "valid_qty", dvalidqty)
dw_list.setitem(lrow, "jego_temp", dqty)
 	
return 0
end function

event open;call super::open;// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_detail.getchild("gubun", dws)
dws.settransobject(sqlca)
dws.retrieve(gs_sabu, '001')

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")
p_print.Visible = False

end event

on w_pdt_04035_han6.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_list=create dw_list
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
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_hidden
this.Control[iCurrent+4]=this.dw_imhist
this.Control[iCurrent+5]=this.dw_imhist_in
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.dw_prt
this.Control[iCurrent+8]=this.cbx_2
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.rb_delete
this.Control[iCurrent+11]=this.rb_insert
this.Control[iCurrent+12]=this.p_1
this.Control[iCurrent+13]=this.p_3
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.rr_1
end on

on w_pdt_04035_han6.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_list)
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
destroy(this.gb_2)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_pdt_04035_han6
boolean visible = false
integer x = 2336
integer y = 2360
integer width = 87
integer height = 72
end type

type p_delrow from w_inherite`p_delrow within w_pdt_04035_han6
integer x = 3547
end type

event p_delrow::clicked;call super::clicked;
long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N' 가 아닌 경우)*/
if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
	dw_list.GetItemString(lRow, "i_confirm") <> 'N' then 
	messagebox("확 인", "입고자료가 승인처리 되어 있으므로 삭제 할 수 없습니다." + &
							  '~n' + "입고 자료를 확인하세요!")
	return 
end if	

// 자료가 없으면 HEAD사항을 수정할 수 없음
dw_list.DeleteRow(lRow)

if dw_list.rowcount() < 1 then
	dw_detail.enabled = true
end if


end event

type p_addrow from w_inherite`p_addrow within w_pdt_04035_han6
integer x = 3374
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

//////////////////////////////////////////////////////////
string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
         sRelcod, sNaougu, scvcod 
long		lRow

sDate    = TRIM(dw_detail.GetItemString(1, "sdate"))
sHouse   = dw_detail.GetItemString(1, "house")
sProject = dw_detail.GetItemString(1, "project")
sEmpno2  = dw_detail.GetItemString(1, "empno2")
sEmpno   = dw_detail.GetItemString(1, "empno")
sDept 	= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")
sCheck   = dw_detail.GetItemString(1, "check")
scvcod   = dw_detail.GetItemString(1, "cvcod")

// 출고일
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[출고일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// 출고창고
IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[출고창고]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sempno2) or sempno2 = "" 	THEN
	f_message_chk(30,'[출고담당자]')
	dw_detail.SetColumn("empno2")
	dw_detail.SetFocus()
	RETURN
END IF

// 요청자
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[요청자]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF
// 요청부서
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[요청부서]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF
// 수불구분
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[수불구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
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
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
end if 
if isnull(sRelcod) or trim(sRelcod) = '' then
	f_message_chk(208,'[입고처]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
end if

// 입고처
IF isnull(scvcod) or scvcod = "" 	THEN
	f_message_chk(30,'[입고처]')
	dw_detail.SetColumn("cvcod")
	dw_detail.SetFocus()
	RETURN
END IF

///////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

//dw_list.SetItem(lRow, "sabu",     gs_sabu)
//dw_list.SetItem(lRow, "hold_date", sDate)
//dw_list.SetItem(lRow, "req_dept",  sDept)
//dw_list.SetItem(lRow, "wiemp",     sEmpno)
//dw_list.SetItem(lRow, "hold_gu",   sGubun)
//dw_list.SetItem(lRow, "out_store", sHouse)
//dw_list.SetItem(lRow, "naougu",	  sCheck)
//dw_list.SetItem(lRow, "pjtno",	  sProject)
//dw_list.SetItem(lRow, "pspec",	  '.')
//
// 자료가 한건이라도 있으면 HEAD사항은 수정할 수 없음
dw_detail.enabled = False

dw_list.setrow(Lrow)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

type p_search from w_inherite`p_search within w_pdt_04035_han6
boolean visible = false
integer x = 4992
integer y = 380
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdt_04035_han6
boolean visible = false
integer x = 4832
integer y = 204
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_04035_han6
integer x = 4434
end type

type p_can from w_inherite`p_can within w_pdt_04035_han6
integer x = 4261
end type

event p_can::clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_print from w_inherite`p_print within w_pdt_04035_han6
boolean visible = false
integer x = 4823
integer y = 372
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_04035_han6
integer x = 3739
boolean enabled = false
string picturename = "C:\erpman\image\조회_d.gif"
end type

event p_inq::clicked;call super::clicked;
if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

sJpno = dw_detail.getitemstring(1, "jpno")

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[출고번호]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	messagebox("확인","해당자료가 없습니다.")
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	return
end if

is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "imhist_iojpno")

dw_detail.enabled = false

p_del.enabled = true
p_del.PictureName = 'c:\erpman\image\삭제_up.gif'

dw_list.SetColumn("itnbr")
dw_list.SetFocus()
//cb_save.enabled = true
end event

type p_del from w_inherite`p_del within w_pdt_04035_han6
integer x = 4087
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

type p_mod from w_inherite`p_mod within w_pdt_04035_han6
integer x = 3913
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sArg_sdate, sJpno

IF	wf_CheckRequiredField() = -1	THEN	RETURN 
If wf_dup_chk() = -1 then return 
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
	
//	if cbx_1.checked then 
//		dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate, gs_saupj)
//		dw_print.print()
//	ElseIf cbx_2.Checked Then
//		dw_prt.retrieve(gs_sabu, sArg_sdate)
//		dw_prt.print()
//   end if
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

type cb_exit from w_inherite`cb_exit within w_pdt_04035_han6
end type

type cb_mod from w_inherite`cb_mod within w_pdt_04035_han6
end type

type cb_ins from w_inherite`cb_ins within w_pdt_04035_han6
end type

type cb_del from w_inherite`cb_del within w_pdt_04035_han6
end type

type cb_inq from w_inherite`cb_inq within w_pdt_04035_han6
end type

type cb_print from w_inherite`cb_print within w_pdt_04035_han6
end type

type st_1 from w_inherite`st_1 within w_pdt_04035_han6
end type

type cb_can from w_inherite`cb_can within w_pdt_04035_han6
end type

type cb_search from w_inherite`cb_search within w_pdt_04035_han6
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_04035_han6
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_04035_han6
end type

type dw_detail from datawindow within w_pdt_04035_han6
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 9
integer y = 16
integer width = 3063
integer height = 312
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_04035_han6"
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
		AND	A.DEPOT_NO = :sHouse;
		//AND A.OWNER = 'Y'
		
	If isNull(sempno) Or sempno = '' Then
		this.SetItem(1,"empno2", '')
		this.SetItem(1,"empnm2", '')
	Else
		this.SetItem(1,"empno2", sempno)
		this.SetItem(1,"empnm2", sname)
	End If
	
	// 2017.09.05- 품목대체는 출고창고=입고창고 동일하게 지정
	this.setitem(1, "cvcod", sHouse)
	
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
//	if sGubun = 'O06' or sGubun = 'O11' then
//		p_print.Visible = True
//	else
//		p_print.Visible = False
//	end if
//	old_Gubun = this.getitemstring(1, 'gubun')
	// 요청구분에 대한 관련처코드
	Setnull(sRelcod)
	Setnull(sNaougu)
	select relcod, naougu, tagbn into :sRelcod, :sNaougu, :sTagbn from iomatrix 
	 where sabu = :gs_sabu and iogbn = :sGubun;
//
//	IF sTagbn = 'Y' then
//		ic_yn = 'Y'
////		MessageBox("확 인", "타계정 대체는 출고의뢰에서 사용하세요!", StopSign!)
//		this.setitem(1, 'gubun', old_gubun)
//		return 1
//	ELSE
//		ic_yn = 'N'
//	END IF
//	
//	this.setitem(1, "cvcod", sNull)
//	this.setitem(1, 'cvnas', sNull)		
//
//	if  isnull(sNaougu) or trim(sNaougu) = '' or &
//		(sNaougu <> '1' and sNaougu <> '2') then
//		f_message_chk(208,'[출고,출문구분]')
//		dw_detail.SetColumn("gubun")
//		dw_detail.SetFocus()
//		RETURN 1
//	end if 
//	if isnull(sRelcod) or trim(sRelcod) = '' then
//		f_message_chk(208,'[입고처]')
//		dw_detail.SetColumn("gubun")
//		dw_detail.SetFocus()
//		RETURN 1
//	end if	
	
	this.setitem(1, "check", sNaougu)

ELSEIF this.GetColumnName() = "cvcod" THEN
   
	string	sChk, sgbn1, sgbn2, sgbn3, sgbn4, sgbn5 

	sgubun = dw_detail.getitemstring(1, "gubun")
	
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
	
	IF Len(sJpno) <> 12 THEN sJpno = 'X'
	
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
				TRIM(A.JNPCRT) LIKE '039' AND
	             NVL(A.CRT_USER,'.') <> 'SYSTEM' AND  
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
	
//	select tagbn into :sTagbn from iomatrix where sabu = :gs_sabu and iogbn = :sGubun; 
//
//	IF sTagbn = 'Y' then
//		ic_yn = 'Y'
//		MessageBox("확 인", "타계정 대체는 출고의뢰에서 사용가능합니다.", StopSign!)
//		return 1
//	ELSE
//		ic_yn = 'N'
//	END IF

	p_inq.PostEvent(Clicked!)
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
	sgubun = dw_detail.getitemstring(1, "gubun")

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
	gs_gubun = '039'
	open(w_chulgo_popup3_ht2)
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

type dw_list from datawindow within w_pdt_04035_han6
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 340
integer width = 4553
integer height = 1872
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdt_04035_han6_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
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
	TriggerEvent(Rbuttondown!)
	
//	sItem  = trim(this.GetText())
//	spspec = this.getitemstring(lrow, "pspec")
//	ireturn = wf_item(sitem, sPspec, lrow)
//	RETURN ireturn
//
ELSEIF this.GetColumnName() = "outqty" THEN

	dOutQty = dec(this.GetText())
	if isnull(dOutQty) or dOutQty = 0 then return 

	dStock  = this.GetItemDecimal(lRow, "jego_qty")
	
   sHouse  = dw_detail.GetItemString(1, 'house')  	

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
	sHouse  = dw_detail.GetItemString(1, 'house')
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
	  
	dw_list.setitem(lrow, "jego_qty",  dJegoqty)
	dw_list.setitem(lrow, "valid_qty", dvalidqty)
	dw_list.setitem(lrow, "jego_temp", dqty)
END IF

end event

event itemerror;RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long		lRow
string		sitdsc, sispec

lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itmspec_popup2)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr", gs_code)
	
	SELECT ITDSC, ISPEC INTO :sitdsc, :sispec FROM ITEMAS WHERE ITNBR = :gs_code ;

	SetItem(lRow,"itdsc", sitdsc)
	SetItem(lRow,"ispec", sispec)	
	SetItem(lRow,"ditnbr",gs_codename)


END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

type dw_hidden from datawindow within w_pdt_04035_han6
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

type dw_imhist from datawindow within w_pdt_04035_han6
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

type dw_imhist_in from datawindow within w_pdt_04035_han6
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

type dw_print from datawindow within w_pdt_04035_han6
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

type dw_prt from datawindow within w_pdt_04035_han6
boolean visible = false
integer x = 4809
integer y = 1788
integer width = 439
integer height = 256
integer taborder = 120
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_pdt_04035_02_p2"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cbx_2 from checkbox within w_pdt_04035_han6
boolean visible = false
integer x = 3433
integer y = 180
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
long backcolor = 32106727
string text = "거래명세표"
end type

type cbx_1 from checkbox within w_pdt_04035_han6
boolean visible = false
integer x = 3433
integer y = 244
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
long backcolor = 32106727
string text = "출고증"
end type

type rb_delete from radiobutton within w_pdt_04035_han6
integer x = 4288
integer y = 208
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
long backcolor = 32106727
string text = "수정"
end type

event clicked;ic_status = '2'
ic_yn = 'N'

dw_list.DataObject = 'd_pdt_04035_han6_2'
dw_list.SetTransObject(SQLCA)

dw_list.Object.opt.Visible = True
dw_list.Object.opt_t.Visible = True

p_1.enabled = false

wf_Initial()


end event

type rb_insert from radiobutton within w_pdt_04035_han6
integer x = 3927
integer y = 208
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
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;ic_status = '1'	// 등록
ic_yn = 'N'

dw_list.DataObject = 'd_pdt_04035_han6_1'
dw_list.SetTransObject(SQLCA)

dw_list.Object.opt.Visible = false
dw_list.Object.opt_t.Visible = false

p_1.enabled = true

wf_Initial()


end event

type p_1 from uo_picture within w_pdt_04035_han6
boolean visible = false
integer x = 4818
integer y = 524
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\재고선택_up.gif"
end type

event clicked;call super::clicked;if dw_detail.enabled then

	p_addrow.triggerevent(clicked!)
	
	string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
				sRelcod, sNaougu, scvcod 
	long		lRow
	
	sDate    = TRIM(dw_detail.GetItemString(1, "sdate"))
	sHouse   = dw_detail.GetItemString(1, "house")
	sEmpno2  = dw_detail.GetItemString(1, "empno2")
	sEmpno   = dw_detail.GetItemString(1, "empno")
	sDept 	= dw_detail.GetItemString(1, "dept")
	sGubun 	= dw_detail.GetItemString(1, "gubun")
	sCheck   = dw_detail.GetItemString(1, "check")
	scvcod   = dw_detail.GetItemString(1, "cvcod")
	
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
	
	dw_list.deleterow(dw_list.getrow())
	
end if

datawindow dwname	

dw_detail.accepttext()
dwname = dw_list
gs_code = dw_detail.getitemstring(1, "house")

openwithparm(w_pdt_04037, dwname)

setnull(gs_code)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고선택_up.gif"
end event

type p_3 from picture within w_pdt_04035_han6
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 4987
integer y = 528
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

sJpno   = dw_detail.GetItemString(1, "jpno")

if dw_list.RowCount() > 0 then
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

type gb_2 from groupbox within w_pdt_04035_han6
integer x = 3840
integer y = 156
integer width = 754
integer height = 148
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_pdt_04035_han6
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 332
integer width = 4576
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

