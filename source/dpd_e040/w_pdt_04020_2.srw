$PBExportHeader$w_pdt_04020_2.srw
$PBExportComments$입고승인등록(제품 입고 승인 등록)
forward
global type w_pdt_04020_2 from window
end type
type p_del from picture within w_pdt_04020_2
end type
type cb_3 from commandbutton within w_pdt_04020_2
end type
type dw_conf from datawindow within w_pdt_04020_2
end type
type dw_pda from datawindow within w_pdt_04020_2
end type
type dw_imhist_in from datawindow within w_pdt_04020_2
end type
type dw_imhist from datawindow within w_pdt_04020_2
end type
type cb_2 from commandbutton within w_pdt_04020_2
end type
type pb_3 from u_pb_cal within w_pdt_04020_2
end type
type pb_2 from u_pb_cal within w_pdt_04020_2
end type
type pb_1 from u_pb_cal within w_pdt_04020_2
end type
type cbx_select from checkbox within w_pdt_04020_2
end type
type p_exit from uo_picture within w_pdt_04020_2
end type
type p_can from uo_picture within w_pdt_04020_2
end type
type p_mod from uo_picture within w_pdt_04020_2
end type
type p_inq from uo_picture within w_pdt_04020_2
end type
type p_search from uo_picture within w_pdt_04020_2
end type
type dw_list from u_d_select_sort within w_pdt_04020_2
end type
type cb_1 from commandbutton within w_pdt_04020_2
end type
type rb_2 from radiobutton within w_pdt_04020_2
end type
type rb_1 from radiobutton within w_pdt_04020_2
end type
type cb_cancel from commandbutton within w_pdt_04020_2
end type
type cb_retrieve from commandbutton within w_pdt_04020_2
end type
type cb_exit from commandbutton within w_pdt_04020_2
end type
type cb_save from commandbutton within w_pdt_04020_2
end type
type rr_1 from roundrectangle within w_pdt_04020_2
end type
type rr_2 from roundrectangle within w_pdt_04020_2
end type
type rr_3 from roundrectangle within w_pdt_04020_2
end type
type dw_1 from datawindow within w_pdt_04020_2
end type
end forward

shared variables

end variables

global type w_pdt_04020_2 from window
boolean visible = false
integer width = 4695
integer height = 2544
boolean titlebar = true
string title = "제품 입고 승인 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_del p_del
cb_3 cb_3
dw_conf dw_conf
dw_pda dw_pda
dw_imhist_in dw_imhist_in
dw_imhist dw_imhist
cb_2 cb_2
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
cbx_select cbx_select
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
p_search p_search
dw_list dw_list
cb_1 cb_1
rb_2 rb_2
rb_1 rb_1
cb_cancel cb_cancel
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_save cb_save
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_1 dw_1
end type
global w_pdt_04020_2 w_pdt_04020_2

type variables
char  ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String     is_ispec,  is_jijil 

String     is_pda
end variables

forward prototypes
public function integer wf_saupj_chk ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_create_saupj (ref string arg_sjpno)
public function integer wf_imhist_conf (string arg_jpno)
end prototypes

public function integer wf_saupj_chk ();dw_1.AcceptText()

String  ls_chl
ls_chl = dw_1.GetItemString(1, 'cvcod')
If Trim(ls_chl) = '' OR IsNull(ls_chl) Then
	MessageBox('확인', '출고처를 선택 하십시오')
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
ls_ip = dw_1.GetItemString(1, 'house')
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

dw_1.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
////////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

//sIOgubun = dw_1.GetItemString(1, "gubun")		// 수불구분
sIogubun = 'O05'

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

sDate = dw_1.GetItemString(1, "edate")				// 입고승인일을 기준으로 처리 함
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_1.GetItemString(1, "cvcod")   //출고처
sEmpno2 = '1173'  //출고담당자 - 김무성
sEmpno  = '2828'   //의뢰자 - 김동우
sDept   = '30050'    //의뢰부서 - 생산팀
sCvcod  = dw_1.GetItemString(1, "house")   //입고처
//sProject = dw_detail.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////
Long    ll_find
For lRow = 1 To dw_pda.RowCount()
	ll_find = dw_pda.Find("f_chk = 'Y'", lRow, dw_pda.RowCount())
	If ll_find < 1 Then Exit
	
	dOutQty = dw_pda.GetItemDecimal(ll_find, 'ipgoqty')
	sPspec = trim(dw_pda.GetItemString(ll_find, "pspec"))
	if sPspec = '' or isnull(sPspec) then sPspec = '.'
	
	If abs(dOutQty) > 0 Then
		////////////////////////////////////////////////////////////////////////////////
		// ** 입출고HISTORY 생성 **
		////////////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
		
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'001')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// 수불구분=요청구분
		
		/* 스캔list에 창고이동 전표번호 기록 ********************************/
		dw_pda.SetItem(ll_find, 'pdjpno', sJpno + string(lRowHist, "000"))
		/********************************************************************/
	
		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// 수불일자=출고일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_pda.GetItemString(ll_find, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // 사양
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "ioqty",	dOutQty) 	// 수불수량=출고수량
		dw_imhist.SetItem(lRowHist, "ioreqty",	dOutQty) 	// 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dOutQty) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// 공정코드
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// 수불승인자=담당자	
		dw_imhist.SetItem(lRowHist, "filsk",   dw_pda.GetItemString(ll_find, "itemas_filsk")) // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    dw_pda.GetItemString(ll_find, "itemas_itgu")) 	// 구입형태
      
		//유상웅  추가
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// 수불의뢰부서=할당.부서
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// 직접출고인 경우 '99999999' 셋팅
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_pda.GetItemString(ll_find, "lotno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  '')
		dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)
		
		dw_imhist.SetItem(lRowHist, "outchk",  'Y') 			// 출고의뢰완료
		
		// 창고이동 입고내역 생성
		IF sHouseGubun = 'Y'	and dOutQty > 0	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// 전표생성구분
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// 수불구분=창고이동입고구분
			
			/* 스캔list에 창고이동 전표번호 기록 ********************************/
			dw_pda.SetItem(ll_find, 'iojpno', sDate + string(dInSeq, "0000") + string(lRowHist_in, "000"))
			/********************************************************************/
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
			dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_pda.GetItemString(ll_find, "itnbr")) // 품번
			dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // 사양
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// 기준창고=입고처
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // 입고 창고의 부가 사업장 가져옮
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// 공정코드
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dOutQty) 	// 수불의뢰수량=출고수량		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dOutQty) 	// 합격수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_pda.GetItemString(ll_find, "itemas_filsk")) // 재고관리유무
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	'')
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_pda.GetItemString(ll_find, "lotno"))
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
			sItnbr  = dw_pda.GetItemString(ll_find, "itnbr")
			sStock  = dw_pda.GetItemString(ll_find, "itemas_filsk") // 재고관리유무
			sGrpno = dw_pda.GetItemString(ll_find, "grpno2")

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
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dOutQty) 	// 수불수량=입고수량
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// 수불승인여부
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// 수불승인여부

			End If
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_pda.GetItemString(ll_find, "itemas_itgu")) 	// 구입형태

			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // 입고전표번호=출고번호
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",  '')
		End If
	End If
	
	lRow = ll_find
Next

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
         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom
long		lRow, lRowHist, lRowHist_In
dec		dSeq, dOutQty,	dInSeq
String   sStock, sGrpno, sGubun

dw_1.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

//sIOgubun = dw_detail.GetItemString(1, "gubun")		// 수불구분
sIOgubun = 'O05'

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

sDate = dw_1.GetItemString(1, "sdate")				// 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_1.GetItemString(1, "cvcod")   //출고처
sEmpno2 = '1173'  //출고담당자 - 김무성
sEmpno  = '2828'   //의뢰자 - 김동우
sDept   = '30050'    //의뢰부서 - 생산팀
sCvcod  = dw_1.GetItemString(1, "house")   //입고처
//sProject = dw_detail.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

Long    ll_find
For lRow = 1 To dw_pda.RowCount()
	ll_find = dw_pda.Find("f_chk = 'Y'", lRow, dw_pda.RowCount())
	If ll_find < 1 Then Exit
	
	dOutQty = dw_pda.GetItemDecimal(ll_find, 'ipgoqty')
	sPspec = trim(dw_pda.GetItemString(ll_find, "pspec"))
	if sPspec = '' or isnull(sPspec) then sPspec = '.'
	
	If abs(dOutQty) > 0 Then
		////////////////////////////////////////////////////////////////////////////////
		// ** 입출고HISTORY 생성 **
		////////////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
		
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'001')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// 수불구분=요청구분
		
		/* 스캔list에 창고이동 전표번호 기록 ********************************/
		dw_pda.SetItem(ll_find, 'pdjpno', sJpno + string(lRowHist, "000"))
		/********************************************************************/
	
		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// 수불일자=출고일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_pda.GetItemString(ll_find, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // 사양
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "ioreqty",	dOutQty) 	// 수불의뢰수량=출고수량
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// 공정코드		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dOutQty) 	// 합격수량=출고수량	
		
		/* 출고자료를 입고 승인 처리 시 출고승인 처리
		dw_imhist.SetItem(lRowHist, "ioqty",	dOutQty) 	// 수불수량=출고수량	
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// 수불승인자=담당자	
		*/
		dw_imhist.SetItem(lRowHist, "ioqty",	0) 	// 수불수량=출고수량		
		dw_imhist.SetItem(lRowHist, "io_confirm",	'N')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	'')			// 수불승인일자=출고일자
		/*dw_imhist.SetItem(lRowHist, "io_empno",'')			// 수불승인자=담당자	출고승인자는 기입함 - 출고등록화면이기 때문임 */
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// 수불승인자=담당자	
		
		
		dw_imhist.SetItem(lRowHist, "filsk",   dw_pda.GetItemString(ll_find, "itemas_filsk")) // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    dw_pda.GetItemString(ll_find, "itemas_itgu")) 	// 구입형태
      
		//유상웅  추가
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// 수불의뢰부서=할당.부서
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// 직접출고인 경우 '99999999' 셋팅
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_pda.GetItemString(ll_find, "lotno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  '')
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
			
			/* 스캔list에 창고이동 전표번호 기록 ********************************/
			dw_pda.SetItem(ll_find, 'iojpno', sDate + string(dInSeq, "0000") + string(lRowHist_in, "000"))
			/********************************************************************/
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
			dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_pda.GetItemString(ll_find, "itnbr")) // 품번
			dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // 사양
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// 기준창고=입고처
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // 입고 창고의 부가 사업장 가져옮
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// 공정코드
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dOutQty) 	// 수불의뢰수량=출고수량		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dOutQty) 	// 합격수량=출고수량		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_pda.GetItemString(ll_find, "itemas_filsk")) // 재고관리유무
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	'')
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_pda.GetItemString(ll_find, "lotno"))
/* 창고 자동/수동 승인 여부 상관없이 수동승인 상태로 처리 - by shingoon 2015.12.22
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
*/
			//////////////////////////////////////////////////////////////////////////////////////////////////////	
			sItnbr  = dw_pda.GetItemString(ll_find, "itnbr")
			sStock  = dw_pda.GetItemString(ll_find, "itemas_filsk") // 재고관리유무
			sGrpno = dw_pda.GetItemString(ll_find, "grpno2")

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
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dOutQty) 	// 수불수량=입고수량
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// 수불승인여부
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// 수불승인여부

			End If
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_pda.GetItemString(ll_find, "itemas_itgu")) 	// 구입형태
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // 입고전표번호=출고번호
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no", '')
		End If
	End If
	lRow = ll_find
Next

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_conf (string arg_jpno);w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()
dw_conf.AcceptText()

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sCheck, sNull, sSalegu, ls_saupj
dec{3}	dQty
dec{5}   dPrice
long		lRow
String   ls_om7jpno, ls_007jpno, ls_err, ls_iojpno
Long ll_err

sHouse 	= dw_1.GetItemString(1, "house")
sDate  	= trim(dw_1.GetItemString(1, "edate"))
sEmpno 	= dw_1.GetItemString(1, "empno")
ls_saupj	= dw_1.GetItemString(1, "saupj")

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN -1
END IF

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[입고승인일]')
	dw_1.SetColumn("edate")
	dw_1.SetFocus()
	RETURN -1
END IF


IF rb_1.checked = true	THEN
	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[입고승인자]')
		dw_1.SetColumn("empno")
		dw_1.SetFocus()
		RETURN -1
	END IF
END IF

dw_conf.SetRedraw(False)
dw_conf.Retrieve('1', ls_saupj, arg_jpno)
dw_conf.SetRedraw(True)

IF dw_conf.RowCount() < 1	THEN	RETURN 0


SetNull(sNull)
////////////////////////////////////////////////////////

IF f_msg_update() = -1 	THEN	RETURN -1

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_conf.RowCount()

	dQty      = dw_conf.GetItemDecimal(lRow, "iosuqty")
	dPrice    = dw_conf.GetItemDecimal(lRow, "ioprc")
	sCheck    = dw_conf.GetItemString(lRow, "io_check")
	
	dw_conf.SetItem(lRow, "ioamt", 	 TRUNCATE(dQty * dPrice, 0))
	dw_conf.SetItem(lRow, "ioqty", 	 dQty)
	dw_conf.SetItem(lRow, "io_date",  sDate)
	dw_conf.SetItem(lRow, "io_empno", sEmpno)
		
//	//자동 수불 자료 처리 추가 2016.02.29 신동준
//	ls_iojpno = dw_list.GetItemString(lRow, "iojpno") /* I01, I03 전표번호 */
//	
//	SetNull(ls_om7jpno)
//	SetNull(ls_007jpno)
//	
//	/* 전표번호로 매입자료(I01, I03) -> 전표번호로 자동수불 출고(OM7) 전표번호 확인 - by shingoon 2016.02.27 */
//	SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :ls_iojpno ;
//	/* 자동수불 출고(OM7) -> 선택된 자동수불 입고(IM7) 전표번호 확인 - BY SHINGOON 2016.02.27 */
//	SELECT IOJPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'IM7' AND IP_JPNO = :ls_om7jpno ;
//	/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :sIojpno ;*/
//	
//	/* IM7자료 갱신 */
//	UPDATE IMHIST
//		SET IOQTY   = :dQty,   
//			 IO_DATE = :sDate
//	 WHERE SABU = :gs_sabu AND IOGBN = 'IM7' AND IOJPNO = :ls_007jpno ;
//	If SQLCA.SQLCODE <> 0 Then
//		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
//		ROLLBACK USING SQLCA;
//		MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20011]~r~n' + ls_err)
//		Return -1
//	End If
//	
//	/* IM7(자동수불 입고) 자료로 상대 출고자료(OM7)을 확인 - BY SHINGOON 2016.02.27 */
//	UPDATE IMHIST
//		SET IOQTY   = :dQty,   
//			 IO_DATE = :sDate
//	 WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IOJPNO = :ls_om7jpno;
//	If SQLCA.SQLCODE <> 0 Then
//		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
//		ROLLBACK USING SQLCA;
//		MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20013]~r~n' + ls_err)
//		Return -1
//	End If
	
	//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
	//검수일자에 승인일자를 move
	sSalegu = dw_conf.GetItemString(lRow, "salegu")
	IF sSalegu = 'Y' Then 
		dw_conf.SetItem(lRow, "yebi1",  sDate)
		dw_conf.Setitem(lRow, "dyebi3", TRUNCATE(dQty * dPrice, 0) * 0.1)
	END IF

NEXT


//////////////////////////////////////////////////////////////////////
If dw_pda.UPDATE() <> 1 Then
	ROLLBACK USING SQLCA;
	f_rollback()
	Return -1
End If

IF dw_conf.Update() <> 1 THEN
	ROLLBACK USING SQLCA;
	f_Rollback()
	Return -1
END IF

COMMIT USING SQLCA;

dw_conf.Reset()
//p_mod.enabled = false
//p_mod.picturename = "C:\erpman\image\저장_d.gif"
is_pda = 'N'

SetPointer(Arrow!)

Return 1

end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

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

///////////////////////////////////////////////////////////////////////////
dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)

p_can.TriggerEvent("clicked")

f_child_saupj(dw_1, 'pdtgu', gs_saupj)
end event

on w_pdt_04020_2.create
this.p_del=create p_del
this.cb_3=create cb_3
this.dw_conf=create dw_conf
this.dw_pda=create dw_pda
this.dw_imhist_in=create dw_imhist_in
this.dw_imhist=create dw_imhist
this.cb_2=create cb_2
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cbx_select=create cbx_select
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.p_search=create p_search
this.dw_list=create dw_list
this.cb_1=create cb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_cancel=create cb_cancel
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_1=create dw_1
this.Control[]={this.p_del,&
this.cb_3,&
this.dw_conf,&
this.dw_pda,&
this.dw_imhist_in,&
this.dw_imhist,&
this.cb_2,&
this.pb_3,&
this.pb_2,&
this.pb_1,&
this.cbx_select,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.p_search,&
this.dw_list,&
this.cb_1,&
this.rb_2,&
this.rb_1,&
this.cb_cancel,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_save,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.dw_1}
end on

on w_pdt_04020_2.destroy
destroy(this.p_del)
destroy(this.cb_3)
destroy(this.dw_conf)
destroy(this.dw_pda)
destroy(this.dw_imhist_in)
destroy(this.dw_imhist)
destroy(this.cb_2)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cbx_select)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.p_search)
destroy(this.dw_list)
destroy(this.cb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_cancel)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_1)
end on

event closequery;string s_frday, s_frtime

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
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type p_del from picture within w_pdt_04020_2
integer x = 4238
integer y = 16
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;/* 제품 입고 승인전 자료 삭제 기능 추가 - 2024.04.02 by dykim */
string ls_iochk, ls_pjtcd, ls_ipjpno, ls_barno
long ll_rcnt, i

If dw_list.AcceptText() = -1 Then
	Return
End if

ll_rcnt = dw_list.RowCount()

If ll_rcnt < 1 Then
	Return
End if

If f_msg_delete() = -1 Then Return
/* 삭제처리가 제대로 되지 않던점 수정 - 2024.05.03 by dykim */
For i = ll_rcnt To 1 STEP -1
	ls_iochk = dw_list.Object.io_check[i]
	If ls_iochk = 'Y' Then
		ls_pjtcd = dw_list.Object.pjt_cd[i]
		ls_ipjpno = dw_list.Object.ip_jpno[i]
		ls_barno = dw_list.Object.barno[i]
		
		DELETE FROM IMHIST
				 WHERE IOJPNO = :ls_ipjpno
				     AND PJT_CD = :ls_pjtcd;
		If SQLCA.SQLCODE < 0	Then
			Rollback;
			MessageBox('확인', '자료 삭제 중 오류가 발생했습니다.(1)')
			Return 
		End If					  
		
		/* 삭제처리한 자료는 PDA 입고자료도 삭제처리 */
		DELETE FROM POPMAN.PDA_JEPUMIPGO_SCAN@P_O_P
			      WHERE IOJPNO = :ls_ipjpno
					 AND CRT_NO = :ls_pjtcd
					 AND BARNO = :ls_barno;
		If SQLCA.SQLCODE < 0	Then
			Rollback;
			MessageBox('확인', '자료 삭제 중 오류가 발생했습니다.(2)')
			Return 
		End If	
		
		dw_list.DeleteRow(i)
	End If
Next

If dw_list.Update() = 1 Then
	commit ;
Else
	Rollback ;
	f_Rollback();
	Return 
End If	
end event

type cb_3 from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 457
integer y = 24
integer width = 411
integer height = 140
integer taborder = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "HY헤드라인M"
boolean enabled = false
string text = "삭제"
end type

event clicked;Long    ll_cnt
ll_cnt = dw_list.RowCount()

Long    ll_find
ll_find = dw_list.Find("io_check = 'Y'", 1, ll_cnt)
If ll_find < 1 Then
	MessageBox('확인', '선택된 행이 없습니다.')
	Return
End If

Long    i
String  ls_chk
String  ls_i11jpno
String  ls_o05jpno
For i = 1 To ll_cnt
	ll_find = dw_list.Find("io_check = 'Y'", i, ll_cnt)
	If ll_find < 1 Then Exit
	
	ls_i11jpno = dw_list.GetItemString(ll_find, 'iojpno') /* 제품창고 입고전표 */
	
	SELECT IP_JPNO INTO :ls_o05jpno FROM IMHIST
	 WHERE SABU = '1' AND IOJPNO = :ls_i11jpno ;
	 
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END INTO :ls_chk
	  FROM PDA_GET_IPGO_SCANLIST
	 WHERE PDJPNO = :ls_o05jpno AND IOJPNO = :ls_i11jpno ;
	If ls_chk = 'Y' Then
		UPDATE PDA_GET_IPGO_SCANLIST
			SET PDJPNO = NULL, IOJPNO = NULL
		 WHERE PDJPNO = :ls_o05jpno AND IOJPNO = :ls_i11jpno ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('확인', '자료 삭제 중 오류가 발생했습니다.(3)')
			Return
		End If
		
		DELETE FROM IMHIST
		 WHERE SABU = '1' AND IOJPNO = :ls_i11jpno ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('확인', '자료 삭제 중 오류가 발생했습니다.(1)')
			Return
		End If
		
		DELETE FROM IMHIST
		 WHERE SABU = '1' AND IOJPNO = :ls_o05jpno ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('확인', '자료 삭제 중 오류가 발생했습니다.(2)')
			Return
		End If
	End If
	
	i = ll_find
Next

COMMIT USING SQLCA;

MessageBox('확인', '삭제 되었습니다.')

p_inq.TriggerEvent(Clicked!)
end event

type dw_conf from datawindow within w_pdt_04020_2
boolean visible = false
integer x = 2560
integer y = 1748
integer width = 686
integer height = 400
integer taborder = 110
string title = "none"
string dataobject = "d_pdt_04020_conf"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_pda from datawindow within w_pdt_04020_2
boolean visible = false
integer x = 1669
integer y = 1604
integer width = 869
integer height = 556
integer taborder = 100
boolean titlebar = true
string title = "PDA 스캔 LIST"
string dataobject = "d_pda_ipgo_scanlist_010"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;This.SetTransObject(SQLCA)
end event

event buttonclicked;If row < 1 Then Return

Choose Case dwo.name
	Case 'b_conf'
		/* 생산출고자료, 제품창고입고자료 생성 처리 *******************************************/
		/* 입출고 창고 사업장 확인 */
		Integer  li_rtn
		li_rtn =  wf_saupj_chk()
		
		String   ls_jpno
		Choose Case li_rtn
			Case 0
				/* 입/출고창고의 사업장이 같을 경우 */
				IF wf_imhist_create(ls_jpno) = -1 THEN
					ROLLBACK USING SQLCA;
					RETURN
				END IF
			Case 1
				/* 입/출고창고의 사업장이 다를 경우 */
				IF wf_imhist_create_saupj(ls_jpno) = -1 THEN
					ROLLBACK USING SQLCA;
					RETURN
				END IF
			Case Else
				/* 오류 */
				Return
		End Choose
		
		If dw_pda.UPDATE() <= 0 Then
			ROLLBACK USING SQLCA;
			f_Rollback()
			Return
		End If

		IF dw_imhist.Update() <= 0		THEN
			ROLLBACK USING SQLCA;
			f_Rollback()
			RETURN
		END IF
		
		IF dw_imhist_in.Update() > 0		THEN
			COMMIT USING SQLCA;
		ELSE
			ROLLBACK USING SQLCA;
			f_Rollback()
			RETURN
		END IF
		/**************************************************************************************/
		
		/* 제품입고 승인 처리 *****************************************************************/
		If wf_imhist_conf(ls_jpno) < 1 Then
			ROLLBACK USING SQLCA;
			Return
		End If
		/**************************************************************************************/
		
		MessageBox("전표번호 확인", "전표번호 : " + left(ls_jpno, 8) + '-' + right(ls_jpno, 4) + "~r~r생성되었습니다.")	
End Choose

end event

type dw_imhist_in from datawindow within w_pdt_04020_2
boolean visible = false
integer x = 974
integer y = 1760
integer width = 686
integer height = 400
integer taborder = 110
string title = "none"
string dataobject = "d_pdt_04020_2_imhist"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_imhist from datawindow within w_pdt_04020_2
boolean visible = false
integer x = 261
integer y = 1752
integer width = 686
integer height = 400
integer taborder = 100
string title = "none"
string dataobject = "d_pdt_04020_2_imhist"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_2 from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 37
integer y = 24
integer width = 411
integer height = 140
integer taborder = 90
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "HY헤드라인M"
boolean enabled = false
string text = "To PDA"
end type

event clicked;String  ls_saupj
ls_saupj = dw_1.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('확인', '사업장을 선택 하십시오.')
	Return
End If

String  ls_house
ls_house = dw_1.GetItemString(1, 'house')
If Trim(ls_house) = '' Or IsNull(ls_house) Then
	MessageBox('확인', '입고창고를 선택 하십시오.')
	Return
End If

String  ls_cvcod
ls_cvcod = dw_1.GetItemString(1, 'cvcod')
If Trim(ls_cvcod) = '' Or IsNull(ls_cvcod) Then
	MessageBox('확인', '출고처를 선택 하십시오.')
	Return
End If

String  ls_date
ls_date = dw_1.GetItemString(1, 'edate')
If Trim(ls_date) = '' OR IsNull(ls_date) Then
	Messagebox('확인', '입고승인일을 입력 하십시오.')
	Return
End If

String  ls_emp
ls_emp = dw_1.GetItemString(1, 'empno')
If Trim(ls_emp) = '' Or IsNull(ls_emp) Then
	Messagebox('확인', '입고승인자를 입력 하십시오.')
	Return
End If

If MessageBox('확인', 'PDA 제품입고 스캔 자료를 불러오겠습니까?', Question!, YesNo!, 1) <> 1 Then Return

dw_pda.SetRedraw(False)
dw_pda.Retrieve()

dw_pda.X       = 238
dw_pda.Y       = 292
dw_pda.Width   = 4187
dw_pda.Height  = 1972
dw_pda.Visible = True

dw_pda.SetRedraw(True)

is_pda = 'Y' /* To PDA 버튼을 누르면 'Y' 저장버튼 눌러 자료 출고저장하면 'N' */
end event

type pb_3 from u_pb_cal within w_pdt_04020_2
integer x = 2208
integer y = 216
integer taborder = 40
end type

event clicked;call super::clicked;dw_1.Setcolumn('tdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'tdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_04020_2
integer x = 1774
integer y = 216
integer taborder = 30
end type

event clicked;call super::clicked;dw_1.Setcolumn('idate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'idate', gs_code)
end event

type pb_1 from u_pb_cal within w_pdt_04020_2
integer x = 3013
integer y = 216
integer taborder = 20
end type

event clicked;call super::clicked;dw_1.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'edate', gs_code)
end event

type cbx_select from checkbox within w_pdt_04020_2
integer x = 91
integer y = 420
integer width = 334
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;String  sStatus, sItnbr, sIspec, Sdatachk
Integer k, nRow
Double  dHoldQty,dIsQty, dJegoQty, dValidQty, dStkQty 

IF cbx_select.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

/* 입고 승인 처리 */
IF ic_status = '1' And sStatus = 'N' THEN
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,"io_check",sStatus)
	NEXT
ElseIF ic_status = '1' And sStatus = 'Y' THEN
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,"io_check",sStatus)
	NEXT
	
ELSE
/* 입고 승인 취소 */
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,"io_check",sStatus)
	NEXT	
END IF


end event

type p_exit from uo_picture within w_pdt_04020_2
integer x = 4411
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdt_04020_2
integer x = 4064
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sToday, sHouse
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "edate", sToday)

// 부가세 사업장 설정
//f_mod_saupj(dw_1, 'saupj')
dw_1.SetItem(1, 'saupj', gs_saupj)
f_child_saupj(dw_1,'house', gs_saupj)

//제품창고 지정
  SELECT CVCOD
    INTO :sHouse
	 FROM VNDMST
	WHERE CVGU      = '5'
     AND JUPROD    = '1'
     AND SOGUAN    = '1'
     AND JUMAECHUL = '2'
	  AND IPJOGUN   = :gs_saupj;
dw_1.SetItem(1, "house", sHouse)

dw_1.SetRedraw(true)

////////////////////////////////////////////////////////
p_mod.enabled = false
p_mod.picturename = "C:\erpman\image\저장_d.gif"

rb_1.checked = true
rb_1.TriggerEvent("clicked")
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_mod from uo_picture within w_pdt_04020_2
integer x = 3890
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_d.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


if dw_1.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

IF dw_list.RowCount() < 1	THEN	RETURN

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sCheck, sNull, sSalegu, ls_saupj
dec{3}	dQty
dec{5}   dPrice
long		lRow
String   ls_om7jpno, ls_007jpno, ls_err, ls_iojpno
Long ll_err

sHouse 	= dw_1.GetItemString(1, "house")
sDate  	= trim(dw_1.GetItemString(1, "edate"))
sEmpno 	= dw_1.GetItemString(1, "empno")
ls_saupj	= dw_1.GetItemString(1, "saupj")

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[입고승인일]')
	dw_1.SetColumn("edate")
	dw_1.SetFocus()
	RETURN
END IF


IF rb_1.checked = true	THEN
	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[입고승인자]')
		dw_1.SetColumn("empno")
		dw_1.SetFocus()
		RETURN
	END IF
END IF


SetNull(sNull)
////////////////////////////////////////////////////////

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_list.RowCount()

	dQty      = dw_list.GetItemDecimal(lRow, "iosuqty")
	dPrice    = dw_list.GetItemDecimal(lRow, "ioprc")
	sCheck    = dw_list.GetItemString(lRow, "io_check")

	if rb_1.checked then

		IF sCheck = 'Y'	THEN		// 승인
			dw_list.SetItem(lRow, "ioamt", 	 TRUNCATE(dQty * dPrice, 0))
			dw_list.SetItem(lRow, "ioqty", 	 dQty)
			dw_list.SetItem(lRow, "io_date",  sDate)
			dw_list.SetItem(lRow, "io_empno", sEmpno)
			
			//자동 수불 자료 처리 추가 2016.02.29 신동준
			ls_iojpno = dw_list.GetItemString(lRow, "iojpno") /* I01, I03 전표번호 */
			
			SetNull(ls_om7jpno)
			SetNull(ls_007jpno)
			
			/* 전표번호로 매입자료(I01, I03) -> 전표번호로 자동수불 출고(OM7) 전표번호 확인 - by shingoon 2016.02.27 */
			SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :ls_iojpno ;
			/* 자동수불 출고(OM7) -> 선택된 자동수불 입고(IM7) 전표번호 확인 - BY SHINGOON 2016.02.27 */
			SELECT IOJPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'IM7' AND IP_JPNO = :ls_om7jpno ;
			/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :sIojpno ;*/
			
			/* IM7자료 갱신 */
			UPDATE IMHIST
				SET IOQTY   = :dQty,   
					 IO_DATE = :sDate
			 WHERE SABU = :gs_sabu AND IOGBN = 'IM7' AND IOJPNO = :ls_007jpno ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20011]~r~n' + ls_err)
				Return -1
			End If
			
//			/* 매입자료(I01, I03)을 UPDATE처리 - by shingoon 2016.02.27 */
//			UPDATE IMHIST
//				SET IOQTY   = :dQty,   
//					 IO_DATE = :sDate
//			 WHERE SABU = :gs_sabu AND IOGBN IN ('I01', 'I03') AND IOJPNO = :ls_iojpno ;
//			If SQLCA.SQLCODE <> 0 Then
//				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
//				ROLLBACK USING SQLCA;
//				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20012]~r~n' + ls_err)
//				Return -1
//			End If
			
			/* IM7(자동수불 입고) 자료로 상대 출고자료(OM7)을 확인 - BY SHINGOON 2016.02.27 */
			UPDATE IMHIST
				SET IOQTY   = :dQty,   
					 IO_DATE = :sDate
			 WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IOJPNO = :ls_om7jpno;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20013]~r~n' + ls_err)
				Return -1
			End If
			
			//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
			//검수일자에 승인일자를 move
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sDate)
				dw_list.Setitem(lRow, "dyebi3", TRUNCATE(dQty * dPrice, 0) * 0.1)
	      END IF 		
		End if
	else
		IF sCheck = 'Y'	THEN		// 승인취소
			dw_list.SetItem(lRow, "ioamt", 	 0)
			dw_list.SetItem(lRow, "ioqty", 	 0)
			dw_list.SetItem(lRow, "io_date",  sNull)
			dw_list.SetItem(lRow, "io_empno", sNull)
			
			//자동 수불 자료 처리 추가 2016.02.29 신동준
			ls_iojpno = dw_list.GetItemString(lRow, "iojpno")
			
			SetNull(ls_om7jpno)
			SetNull(ls_007jpno)
			
			/* 선택된 자동수불 입고(IM7) 전표번호로 자동수불 출고(OM7) 전표번호 확인 - by shingoon 2016.02.27 */
			SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :ls_iojpno ;
			/* 자동수불 출고(OM7) 전표번호로 매입자료(I01, I03) 전표번호 확인 - BY SHINGOON 2016.02.27 */
			SELECT IOJPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :ls_om7jpno ;
			/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :sIojpno ;*/
			
			/* IM7자료 갱신 */
			UPDATE IMHIST
				SET IOQTY = 0, IO_DATE = NULL
			 WHERE SABU = :gs_sabu AND IOJPNO = :ls_iojpno ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20011]~r~n' + ls_err)
				Return -1
			End If
			
			/* IM7자료 갱신 대신 매입자료(I01, I03)을 UPDATE처리 - by shingoon 2016.02.27 */
			UPDATE IMHIST
				SET IOQTY = 0, IO_DATE = NULL
			 WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20012]~r~n' + ls_err)
				Return -1
			End If
			
			/* IM7(자동수불 입고) 자료로 상대 출고자료(OM7)을 확인 - BY SHINGOON 2016.02.27 */
			UPDATE IMHIST
				SET IOQTY   = 0,   
					 IO_DATE = NULL
			 WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20013]~r~n' + ls_err)
				Return -1
			End If

			//반대로 수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 검수일자 clear
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sNull)
				dw_list.Setitem(lRow, "dyebi3", 0)				
	      END IF 		
		End if
	END IF

NEXT


//////////////////////////////////////////////////////////////////////

IF dw_list.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	Return
END IF

dw_list.Reset()
p_mod.enabled = false
p_mod.picturename = "C:\erpman\image\저장_d.gif"


SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_pdt_04020_2
integer x = 3717
integer y = 16
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno, sCvcod, sItnbr, sBarno

if dw_1.accepttext() = -1 then return 

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))
sCvcod = Trim(dw_1.GetItemString(1, "cvcod"))
sItnbr = Trim(dw_1.GetItemString(1, "itnbr"))
sBarno = Trim(dw_1.GetItemString(1, "barno"))

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

if rb_1.checked then
	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[입고승인일]')
		dw_1.SetColumn("edate")
		dw_1.SetFocus()
		RETURN
	END IF
end if

IF isnull(sEmpno) or sEmpno = "" 	THEN
	IF ic_status = '1' THEN
		f_message_chk(30,'[승인자]')
		dw_1.SetColumn("empno")
		dw_1.SetFocus()
		RETURN
	ELSE
		sEmpno = '%' /* 입고승인취소에서는 승인자 필수입력값 해제하여 조회될 수 있도록 수정 */
	END IF
END IF

IF isnull(sidate) or sidate = "" 	THEN  sidate = '10000101'
IF isnull(stdate) or stdate = "" 	THEN  stdate = '99991231'
IF sidate > stdate 	THEN
	if rb_1.checked then
		f_message_chk(34,'[의뢰일자]')
		dw_1.SetColumn("idate")
		dw_1.SetFocus()
		RETURN
	else
		f_message_chk(34,'[의뢰일자]')
		dw_1.SetColumn("idate")
		dw_1.SetFocus()
		RETURN		
	end if
END IF

IF isnull(siogbn) or siogbn = "" 	THEN
	siogbn = '%'
END IF

If sCvcod = '' OR IsNull(sCvcod) Then sCvcod = '%'
If sItnbr = '' OR IsNull(sItnbr) Then sItnbr = '%'

/////////////////////////////////////////////////////
// 입고미승인 내역
/////////////////////////////////////////////////////
SetPointer(HourGlass!)

long	lRowCount

dw_list.SetRedraw(False)
dw_list.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_list.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_list.Filter( )

IF rb_1.checked  = true		THEN
	sGubun = 'N'
	sTitle = '[입고미승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siogbn, sidate, stdate, gs_saupj, sCvcod, sItnbr)
ELSE
	sGubun = 'Y'
	sTitle = '[입고승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno, gs_saupj, sCvcod, sItnbr)
END IF
dw_list.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF rb_2.checked = true THEN
	if not(IsNull(sBarno) or sBarno = "") then
		dw_list.SetFilter("barno = '" + sBarno + "'")
		dw_list.Filter()
	end if
END IF

p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_search from uo_picture within w_pdt_04020_2
boolean visible = false
integer x = 3173
integer y = 4
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Long i, lcount
string sinsdat, sio_date

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

IF rb_2.checked THEN 
	For i = 1 to lCount
		IF dw_list.GetItemString(i, 'outchk') = 'Y' then 
			dw_list.object.io_check[i] = "Y"
		END IF	
	Next	
ELSE
	For i = 1 to lCount
		sinsdat  = dw_list.GetItemString(i, 'insdat')  //검사일자
		sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
		
		IF sinsdat <= sio_date then 
			dw_list.object.io_check[i] = "Y"
		End if
	Next	
END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\button_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\button_up.gif"
end event

type dw_list from u_d_select_sort within w_pdt_04020_2
event ue_downenter pbm_dwnprocessenter
integer x = 46
integer y = 508
integer width = 4517
integer height = 1796
integer taborder = 20
string dataobject = "d_pdt_04020"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string scheck, siojpno, sinsdat, sio_date
long   lcount

IF this.GetColumnName() ="io_check"   THEN
	scheck = this.GetText()
	
	IF	scheck = 'N'	Then	RETURN 

	IF rb_2.checked THEN 
	
		siojpno = this.getitemstring(row, 'iojpno')
	
		SELECT COUNT(*)
		  INTO :lcount
		  FROM HOLDSTOCK  
		 WHERE SABU = :gs_sabu AND OUT_CHK = '2' AND 
				 HOLD_NO in ( SELECT HOLD_NO  FROM HOLDSTOCK_AUTO  
									WHERE SABU = :gs_sabu AND IOJPNO = :siojpno ) ;
	
		IF lcount > 0 then 
			messagebox("확 인", "송장발행된 자료는 승인취소 할 수 없습니다.")
			return 2
		end if
   ELSE
      sinsdat  = this.GetItemString(row, 'insdat')  //검사일자
      dw_1.accepttext()
      sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
		
		IF sinsdat > sio_date then 
			messagebox("확 인", "입고승인일을 확인하세요. 승인일자가 검사일자 보다 작을 수 없습니다.")
			return 1
		end if
	END IF
END IF

end event

event itemerror;Return 1
end event

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

type cb_1 from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 3776
integer y = 2472
integer width = 311
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄선택"
end type

event clicked;Long i, lcount
string sinsdat, sio_date

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

IF rb_2.checked THEN 
	For i = 1 to lCount
		IF dw_list.GetItemString(i, 'outchk') = 'Y' then 
			dw_list.object.io_check[i] = "Y"
		END IF	
	Next	
ELSE
	For i = 1 to lCount
		sinsdat  = dw_list.GetItemString(i, 'insdat')  //검사일자
		sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
		
		IF sinsdat <= sio_date then 
			dw_list.object.io_check[i] = "Y"
		End if
	Next	
END IF


end event

type rb_2 from radiobutton within w_pdt_04020_2
integer x = 4201
integer y = 296
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "승인취소"
end type

event clicked;string snull

setnull(snull)

ic_status = '2'

dw_1.Modify("edate.Visible= 0") 
dw_1.Modify("edate_s.Visible= 0") 
dw_1.Modify("edate_t.Visible= 0") 
dw_1.Modify("idate_t.text = '승인일자'")
dw_1.Modify("t_8.Visible= 0")
dw_1.Modify("barno_t.Visible=1")
dw_1.Modify("barno.Visible=1")

dw_list.DataObject = 'd_pdt_04022'
dw_list.SetTransObject(sqlca)


pb_1.visible = False

dw_1.setcolumn('house')
dw_1.setfocus()

//cb_2.Visible = False
//cb_3.Visible = False

p_del.enabled = false
p_del.picturename = "C:\erpman\image\삭제_d.gif"
end event

type rb_1 from radiobutton within w_pdt_04020_2
integer x = 4201
integer y = 208
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "입고승인"
boolean checked = true
end type

event clicked;
ic_status = '1'

dw_1.Modify("edate.Visible= 1") 
dw_1.Modify("edate_s.Visible= 1") 
dw_1.Modify("edate_t.Visible= 1") 
dw_1.Modify("idate_t.text = '의뢰일자'")
dw_1.Modify("t_8.Visible= 1") 
dw_1.Modify("barno_t.Visible=0")
dw_1.Modify("barno.Visible=0")
dw_1.setItem(1, "idate", left(is_today, 6) + '01')
dw_1.setItem(1, "tdate", is_today)

dw_list.DataObject = 'd_pdt_04020'
dw_list.SetTransObject(sqlca)
pb_1.visible = True

dw_1.setcolumn('house')
dw_1.setfocus()

//cb_2.Visible = True
//cb_3.Visible = True

p_del.enabled = true
p_del.picturename = "C:\erpman\image\삭제_up.gif"
end event

type cb_cancel from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 2135
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;string	sToday
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "edate", sToday)

dw_1.SetRedraw(true)

////////////////////////////////////////////////////////
cb_save.enabled = False
rb_1.checked = true
rb_1.TriggerEvent("clicked")
end event

type cb_retrieve from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 242
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno

if dw_1.accepttext() = -1 then return 

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

if rb_1.checked then
	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[입고승인일]')
		dw_1.SetColumn("edate")
		dw_1.SetFocus()
		RETURN
	END IF
end if

IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[승인자]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sidate) or sidate = "" 	THEN  sidate = '10000101'
IF isnull(stdate) or stdate = "" 	THEN  stdate = '99991231'
IF sidate > stdate 	THEN
	if rb_1.checked then
		f_message_chk(34,'[의뢰일자]')
		dw_1.SetColumn("idate")
		dw_1.SetFocus()
		RETURN
	else
		f_message_chk(34,'[의뢰일자]')
		dw_1.SetColumn("idate")
		dw_1.SetFocus()
		RETURN		
	end if
END IF

IF isnull(siogbn) or siogbn = "" 	THEN
	siogbn = '%'
END IF

/////////////////////////////////////////////////////
// 입고미승인 내역
/////////////////////////////////////////////////////
SetPointer(HourGlass!)

long	lRowCount

dw_list.SetRedraw(False)
dw_list.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_list.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_list.Filter( )

IF rb_1.checked  = true		THEN
	sGubun = 'N'
	sTitle = '[입고미승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siogbn, sidate, stdate)
ELSE
	sGubun = 'Y'
	sTitle = '[입고승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno)
END IF
dw_list.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

cb_save.enabled = true


end event

type cb_exit from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 2766
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;
close(parent)


end event

type cb_save from commandbutton within w_pdt_04020_2
boolean visible = false
integer x = 873
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "승인저장(&S)"
end type

event clicked;
if dw_1.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

IF dw_list.RowCount() < 1	THEN	RETURN

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sCheck, sNull, sSalegu
dec{3}	dQty
dec{5}   dPrice
long		lRow

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
sEmpno = dw_1.GetItemString(1, "empno")

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[입고승인일]')
	dw_1.SetColumn("edate")
	dw_1.SetFocus()
	RETURN
END IF


IF rb_1.checked = true	THEN
	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[입고승인자]')
		dw_1.SetColumn("empno")
		dw_1.SetFocus()
		RETURN
	END IF
END IF


SetNull(sNull)
////////////////////////////////////////////////////////

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_list.RowCount()

	dQty   = dw_list.GetItemDecimal(lRow, "iosuqty")
	dPrice = dw_list.GetItemDecimal(lRow, "ioprc")
	sCheck = dw_list.GetItemString(lRow, "io_check")

	if rb_1.checked then
		IF sCheck = 'Y'	THEN		// 승인
			dw_list.SetItem(lRow, "ioamt", 	 TRUNCATE(dQty * dPrice, 0))
			dw_list.SetItem(lRow, "ioqty", 	 dQty)
			dw_list.SetItem(lRow, "io_date",  sDate)
			dw_list.SetItem(lRow, "io_empno", sEmpno)

			//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
			//검수일자에 승인일자를 move
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sDate)
	      END IF 		
		End if
	else
		IF sCheck = 'Y'	THEN		// 승인취소
			dw_list.SetItem(lRow, "ioamt", 	 0)
			dw_list.SetItem(lRow, "ioqty", 	 0)
			dw_list.SetItem(lRow, "io_date",  sNull)
			dw_list.SetItem(lRow, "io_empno", sNull)

			//반대로 수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 검수일자 clear
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sNull)
	      END IF 		
		End if
	END IF

NEXT


//////////////////////////////////////////////////////////////////////

IF dw_list.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	Return
END IF

dw_list.Reset()
cb_save.enabled = False

SetPointer(Arrow!)

end event

type rr_1 from roundrectangle within w_pdt_04020_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4183
integer y = 180
integer width = 389
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_04020_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 180
integer width = 4128
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_pdt_04020_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 416
integer width = 4544
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from datawindow within w_pdt_04020_2
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 78
integer y = 192
integer width = 4014
integer height = 192
integer taborder = 10
string dataobject = "d_pdt_04020_2"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ud_downkey;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

if keydown(keydelete!) and this.getcolumnname() = 'iogbn' then
	string snull
	setnull(snull)
	setitem(1, "iogbn", snull)
end if
end event

event rbuttondown;string shouse, sPass, snull
SetNull(snull)
gs_code = ''
gs_codename = ''
gs_gubun = ''

this.accepttext() 
// 입고승인담당자
IF this.GetColumnName() = 'empno'	THEN
   gs_gubun = '2' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

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

ELSEIF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[출고처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "cvnas", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
	
END IF
end event

event itemerror;return 1
end event

event itemchanged;string	sCode, sName,	&
			sDate, sHouse, &
			sYN,	 sNull, sname2, sPass, ssaupj
int      ireturn 			
long     k

SetNull(sNull)

IF this.GetColumnName() = 'edate' THEN

	sDate = TRIM(this.gettext())
   if ic_status = '1' then 
		For k = 1 to dw_list.RowCount() 
			dw_list.object.io_check[k] = 'N'
		Next	
	end if
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고승인일]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'idate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "idate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'tdate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "tdate", sNull)
		return 1
	END IF
// 창고 -> 매출여부 확인
ELSEIF this.GetColumnName() = 'house' THEN

	sHouse = this.gettext()
	
	SELECT HOMEPAGE, DAJIGUN, IPJOGUN
	  INTO :sYN, :sPass, :ssaupj
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[창고]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		this.setitem(1, "saupj", sNull)		
		dw_list.reset()
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			this.setitem(1, "saupj", sNull)			
			dw_list.reset()
			return 1
      END IF		
	END IF
	
	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	this.setitem(1, "saupj", ssaupj)
	dw_list.reset()
	
// 입고승인담당자 
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
	
   ireturn = f_get_name2('입고승인자', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
	
elseif this.getcolumnname() = 'saupj' then 
	scode = this.GetText()								
	f_child_saupj(this, 'house', scode)
	f_child_saupj(this, 'pdtgu', scode)
	
	//SELECT CVCOD INTO :sHouse FROM VNDMST WHERE CVGU = '5' AND INGUAN = 'Y' AND IPJOGUN = :scode;
	SELECT MIN(CVCOD) INTO :sHouse FROM VNDMST WHERE CVGU = '5' AND JUPROD = '1' AND IPJOGUN = :scode;
	this.setitem(1, 'house', sHouse)
ELSEIF this.GetColumnName() = "cvcod" THEN
	scode = this.GetText()
	
	//ireturn = f_get_name2('V1', 'Y', scode, sname2, sname)
	
	SELECT CVNAS INTO :sname2
	  FROM VNDMST
	 WHERE CVCOD = :scode ;
	
	this.setitem(1, "cvcod", scode)	
	this.setitem(1, "cvnas", sname2)
	
//	//해당 거래처 품목확인 - 2007.10.18 by shingoon
//	If dw_insert.Rowcount() > 0 Then
//		If wf_itemchk(scode) < 0 Then
//			This.SetItem(1, 'cvcod', '')
//			This.SetItem(1, 'cvnas', '')
//			Return 2
//		End If
//	End If
	
	RETURN ireturn
END IF

end event

event losefocus;dw_1.accepttext()
end event

