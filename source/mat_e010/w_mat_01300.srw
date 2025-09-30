$PBExportHeader$w_mat_01300.srw
$PBExportComments$구매기타입고 의뢰등록
forward
global type w_mat_01300 from window
end type
type pb_1 from u_pb_cal within w_mat_01300
end type
type p_print from uo_picture within w_mat_01300
end type
type p_exit from uo_picture within w_mat_01300
end type
type p_cancel from uo_picture within w_mat_01300
end type
type p_delete from uo_picture within w_mat_01300
end type
type p_save from uo_picture within w_mat_01300
end type
type p_inq from uo_picture within w_mat_01300
end type
type p_delrow from uo_picture within w_mat_01300
end type
type p_addrow from uo_picture within w_mat_01300
end type
type dw_imhist_out from datawindow within w_mat_01300
end type
type rb_delete from radiobutton within w_mat_01300
end type
type rb_insert from radiobutton within w_mat_01300
end type
type dw_detail from datawindow within w_mat_01300
end type
type gb_2 from groupbox within w_mat_01300
end type
type rr_1 from roundrectangle within w_mat_01300
end type
type dw_hidden from datawindow within w_mat_01300
end type
type dw_list from datawindow within w_mat_01300
end type
end forward

global type w_mat_01300 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "구매기타의뢰 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_open ( )
pb_1 pb_1
p_print p_print
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_inq p_inq
p_delrow p_delrow
p_addrow p_addrow
dw_imhist_out dw_imhist_out
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
gb_2 gb_2
rr_1 rr_1
dw_hidden dw_hidden
dw_list dw_list
end type
global w_mat_01300 w_mat_01300

type variables
boolean ib_ItemError, ib_changed
char ic_status
string is_Last_Jpno, is_Date, is_itnbr

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_qccheck         //검사수정여부
String     is_gubun
String     is_cnvart
end variables

forward prototypes
public function integer wf_waiju (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun)
public function integer wf_imhist_create_waiju ()
public function integer wf_imhist_delete ()
public function integer wf_imhist_update_waiju ()
public function integer wf_imhist_update ()
public function integer wf_update_gubun ()
public function integer wf_initial ()
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_create (ref string rsdate, ref decimal rdseq)
public function integer wf_cnvfat (long lrow, string arg_itnbr)
public function integer wf_dan (long lrow, string sitnbr, string arg_pspec, string sopseq)
end prototypes

event ue_open();// 환경설정에서 검사구분수정여부를 검색
select dataname
  into :is_qccheck
  from syscnfg
 where sysgu = 'Y' and serial = '24' and lineno = '1';
 
if sqlca.sqlcode <> 0 then
	is_qccheck = 'N'
end if

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
// 전표생선구분은 '007'(단 발주번호가 없음)
///////////////////////////////////////////////////////////////////////////////////

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist_out.settransobject(sqlca)
dw_hidden.settransobject(sqlca)
dw_detail.InsertRow(0)
is_Date = f_Today()

//rb_insert.TriggerEvent("clicked")
rb_insert.PostEvent(Clicked!)
end event

public function integer wf_waiju (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// 기존의 작업실적 전표를 삭제한다.
// 구분 A = 신규입력, U = 삭제후 입력, D = 삭제
// 외주가공입고(공정이 9999가 아니면)인 경우에만 실적전표를 작성한다.
String sitnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
Decimal {3} dInqty
String ls_iojpno

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno And sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("작업실적삭제", "작업실적 삭제를 실패하였읍니다", stopsign!)
		return -1	
	end if
end if

if sGubun = 'U' then
	
	dInqty	 = dw_list.getitemdecimal(lrow, "imhist_ioreqty")							      // 실적수량	
	
	Update Shpact
		Set roqty 	= :dInqty,
			 coqty 	= :dInqty,
			 ipgub   = :sVendor, 
			 upd_user = :gs_userid
	 Where sabu 	= :gs_sabu And Pr_shpjpno = :sIojpno And sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("작업실적수정", "작업실적 수정를 실패하였읍니다", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then
	
	sShpJpno  = sDate + string(dShpSeq, "0000") + string(Lrow, '000')		// 작업실적번호
	sitnbr	 =	dw_list.GetItemString(lRow, "itnbr") 							      // 품번
	sPspec	 =	dw_list.GetItemString(lRow, "imhist_pspec")					      // 사양
	select fun_get_pdtgu(:sitnbr, '1') into :sPdtgu from dual;				      // 생산팀
	sPordno	 = dw_list.getitemstring(lrow, "imhist_jakjino");				      // 작업지시번호	
	dInqty	 = dw_list.getitemdecimal(lrow, "imhist_ioreqty")							      // 실적수량	

	Setnull(sLastc)
	Setnull(sDe_Lastc)
	Setnull(sshpipno)
	Select Lastc, De_opseq Into :sLastc, :sDe_opseq From morout
	 Where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업공정", "작업공정 검색이 실패하였읍니다", stopsign!)
		return -1
	End if
	
	Select Lastc Into :sDe_lastc From morout
	 Where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sDe_Opseq;
	 
	// 최종공정이면 입고번호를 저장한다(외주실적은 4로 표시)
	if sLastc = '3' or sLastc = '9' then
		sShpipno = sDate + string(dShpipgo, "0000") + string(Lrow, '000')		// 작업실적에 의한 입고번호
	end if
	
	INSERT INTO SHPACT
		( SABU,				SHPJPNO,				ITNBR,				PSPEC,				WKCTR, 
		  PDTGU, 			MCHCOD, 				JOCOD, 				OPEMP, 				SIDAT, 
		  INWON,				TOTIM, 				STIME, 				ETIME, 				NTIME, 
		  PORDNO, 			SIGBN, 				PURGC, 				ROQTY, 				FAQTY, 
		  SUQTY, 			PEQTY, 				COQTY, 				PE_BIGO, 			JI_GU, 
		  INSGU, 			LOTSNO,	 									LOTENO,
		  IPGUB, 			PEDAT, 
		  PEDPTNO, 			OPSNO,				LASTC, 				DE_LASTC, 			DE_CONFIRM, 
		  PR_SHPJPNO, 		IPJPNO,           CRT_USER)
		VALUES
		( :gs_sabu,		:sShpjpno,			:sItnbr,				:sPspec,				null,
		  :sPdtgu,			null,					null,					:sEmpno,				:sDate,
		  0,					0,						0,						0,						0,
		  :sPordno,			'4',					'Y',					:dinqty,				0,
		  0,					0,						:dInqty,				null,					'N',
		  '2',				substr(:sIojpno, 3, 10),				substr(:sIojpno, 3, 10),
		  :sVendor,			null,
		  null,				:sOpseq,				:sLastc,				:sDe_Lastc,			'N',
		  :sIojpno,			:sShpipno,        :gs_userid );
		  	  
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업실적작성", "작업실적 작성을 실패하였읍니다", stopsign!)
		return -1
	End if	
	ls_iojpno	=  dw_list.getitemstring(lRowHist, "imhist_iojpno");				      // 입출고 전표번호.
	UPDATE IMHIST SET  JAKSINO = :sShpjpno
	where SABU = :gs_sabu AND IOJPNO = :ls_iojpno;
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업실적", "작업실적 UPDATE를 실패하였읍니다", stopsign!)
		return -1
	End if	
	
	Commit;
	
end if

Return 1
end function

public function integer wf_imhist_create_waiju ();///////////////////////////////////////////////////////////////////////
//	* 입고실적및 외주 자동불출후 생산실적 작성
///////////////////////////////////////////////////////////////////////
string	sDate, 		&
			sEmpno,		&
			sVendor,		&
			sGubun,		&
			sQcGubun,	&
			sQcEmpno, sNull, sIojpno, sOpseq
long		lRow, lRowHist, lRowOut
dec {2}	dShpSeq, dShpipgo
SetNull(sNull)

sDate  = trim(dw_detail.GetItemString(1, "sdate"))				// 입고의뢰일자
/* 공정이 '9999'가 아니면 작업실적 전표번호를 생성(무검사 자료가 있는 경우에만) */
FOR	lRow = 1		TO		dw_list.RowCount()
		if dw_list.getitemstring(lrow, "imhist_opseq") <> '9999' AND &
			dw_list.getitemstring(lrow, "qcgubun") = '1' And &
			dw_list.getitemdecimal(lrow, "imhist_ioreqty") > 0 then			
			/* 작업실적 전표번호 */
			dShpSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'N1')
			IF dShpSeq < 1		THEN
				ROLLBACK;
				f_message_chk(51,'[작업실적번호]')
				RETURN -1
			END IF
			/* 작업실적에 의한 입고번호 */
			dShpipgo = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
			IF dShpipgo < 1	THEN
				ROLLBACK;
				f_message_chk(51,'[작업실적에 의한 입고번호]')
				RETURN -1
			END IF			
			Exit	
		End if
Next

sEmpno = dw_detail.GetItemString(1, "empno")				// 입고의뢰자
sGubun = dw_detail.GetItemString(1, "gubun")

FOR	lRow = 1		TO		dw_list.RowCount()
	/////////////////////////////////////////////////////////////////////////
	//																							  //	
	// ** 입출고HISTORY 생성 **														  //	
	//																							  //
	/////////////////////////////////////////////////////////////////////////
	lRowHist++
	
	if dw_list.getitemdecimal(lrow, "imhist_ioreqty") = 0 then continue

	sQcGubun 	= dw_list.GetItemString(lRow, "qcgubun")
	sQcEmpno		= dw_list.GetItemString(lRow, "empno")
	sVendor		= dw_list.GetItemString(lRow, "imhist_cvcod")
	sIojpno     = dw_list.GetItemString(lRow, "imhist_iojpno")
	sOpseq      = dw_list.GetItemString(lRow, "imhist_opseq")

	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	IF sOpseq <> '9999' And sQcgubun = '1' THEN
		if wf_waiju(Lrow, Lrowhist, sDate, dShpseq, sIojpno, sOpseq, dShpipgo, Sempno, sVendor, 'I') = -1 then
			return -1
		end if
				  
		CONTINUE

	END IF

NEXT

RETURN 1
end function

public function integer wf_imhist_delete ();string	sHist_jpno, sWigbn, sError, sgubun, sOpseq, sNull, sqcgubun, sBlno, smagub
long		lRow, lRowCount, i, k

Setnull(sNull)


lRowCount = dw_list.RowCount()

/* 입고형태가 외주인지 check	*/
sGubun = dw_detail.GetItemString(1, "gubun")	
Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sGubun;
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	f_message_chk(311,'[외주여부]')
	return -1
end if

FOR  lRow = lRowCount 	TO		1		STEP  -1
	i++
	if dw_list.getitemstring(lrow, "del") <> 'Y' then continue

	/* 검사 또는 승인된 자료는 삭제불가 */
	if dw_list.getitemstring(lrow, "updategubun") = 'N' then continue
		
	sHist_Jpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
	
	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sQcGubun  =  dw_list.GetItemString(lRow, "qcgubun")
	sOpseq    =  dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' and sqcgubun = '1' THEN
		
		if wf_waiju(Lrow, 0, sNull, 0, sHist_jpno, sOpseq, 0, snull, sNull, 'D') = -1 then
			return -1
		end if
		
	
	END IF			

	if dw_list.getitemstring(lrow, "imhist_filsk") = 'N' then
	  DELETE FROM "IMHIST"  
   	WHERE ( "IMHIST"."SABU" = :gs_sabu ) 	AND  
        		( "IMHIST"."IP_JPNO" = :sHist_Jpno )  AND
				( "IMHIST"."JNPCRT"  = '008' ) ;
		if SQLCA.SQLCODE < 0 then
			Rollback;
			MessageBox('삭제확인', '자동출고된 전표삭제를 실패하였습니다.')
			return -1
		end if;
	end if
	

	/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 삭제
		-. 단 검사일자가 있는 경우에 한 함*/
	if sWigbn = 'Y' Then
		sError = 'X';
		sqlca.erp000000360(gs_sabu, sHist_Jpno, 'D', sError);	/* 삭제 */
		if sError = 'X' or sError = 'Y' then
			Rollback;
			f_message_chk(41, '[외주자동출고]')
			return -1
		end if;
	end if;	
	
	dw_list.DeleteRow(lRow)
	k++
NEXT

IF k < 1 Then
	messagebox("확 인", "삭제 할 자료를 선택하세요.!")
	Return -1
END IF

if i = k then return -2  //전체 삭제되었으면 화면 reset

RETURN 1
end function

public function integer wf_imhist_update_waiju ();//////////////////////////////////////////////////////////////////
//
//		* 수정모드
//		1. 생산실적 작성
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sHouse, sDate, sNull, sQcgubun, sOpseq
long		lRow

Setnull(sNull)

dw_list.accepttext()

FOR	lRow = 1		TO		dw_list.RowCount()

	/* 검사 또는 승인된 자료는 삭제불가 */
	if dw_list.getitemstring(lrow, "updategubun") = 'N' then continue

	sHist_Jpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
	sHouse		= dw_list.GetItemString(lRow, "imhist_depot_no")
	sDate			= dw_list.GetItemString(lRow, "imhist_sudat")
	sQcgubun		= dw_list.GetItemString(lRow, "qcgubun")	
	
	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' then
		
		if sQcgubun = '1' then
    		if wf_waiju(Lrow, 0, sDate, 0, sHist_jpno, sOpseq, 0, snull, sHouse, 'U') = -1 then
		   	return -1
   		end if			
		end if
		
	END IF 
	
NEXT

RETURN 1

end function

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* 수정모드
//		1. 입출고history -> 입고수량 update (입고수량을 변경할 경우에만)
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sHouse, sDate, sNull, sQcgubun, sSaleYn, sStockgubun, sOpseq, sVendor
String	sWigbn, sError, sGubun
String   sTemp_depot, sTemp_qcgub
dec{3}	dInQty, dTemp_Qty, dCinqty 
long		lRow, lCount

sGubun = dw_detail.GetItemString(1, "gubun")

Setnull(sNull)

lcount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount 

	/* 검사 또는 승인된 자료는 삭제불가 */
	if dw_list.getitemstring(lrow, "updategubun") = 'N' then continue

	dcinQty     = dw_list.GetItemDecimal(lRow, "imhist_cnviore")
	//의뢰수량
	dINQty      = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")			
	if isnull(dinqty) then dinqty = 0
	
	//창고 (2001.7.21 수정 옥준철 : 입고창고는 1개)
	sHouse		= dw_detail.GetItemString(1, "in_house")
   //검사구분 	
	sQcgubun		= dw_list.GetItemString(lRow, "qcgubun")	
	sHist_Jpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
	
	sDate			= dw_list.GetItemString(lRow, "imhist_sudat")
	sStockgubun	= dw_list.GetItemString(lRow, "imhist_filsk")
	
	// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
	SELECT HOMEPAGE
	  INTO :sSaleYN
	  FROM VNDMST
	 WHERE ( CVCOD = :sHouse ) ;	
	if sstockgubun = 'N' then ssaleyn = 'Y'
	
	// 단, 공정외주인 경우에는 무조건 수동승인 2000/10/24 추가
	if dw_list.GetItemString(lRow, "imhist_opseq") <> '9999' then
		ssaleyn = 'N'
	end if//2000/10/24 추가
	
	dw_list.SetItem(lRow, "imhist_io_confirm", ssaleyn)	// 수불승인여부	

	IF sQcGubun = '1'		THEN										// 검사구분=무검사일 경우
		dw_list.SetItem(lRow, "imhist_insdat",sDate)			// 검사일자=입고의뢰일자
		dw_list.SetItem(lRow, "empno",snull)      			// 검사담당자=null
		dw_list.SetItem(lRow, "imhist_iosuqty",dw_list.GetItemDecimal(lRow, "imhist_ioreqty"))	// 합격수량=입고수량(관리단위)
		dw_list.SetItem(lRow, "imhist_cnviosu",dw_list.GetItemDecimal(lRow, "imhist_cnviore"))	// 합격수량=입고수량(발주단위)
		dw_list.SetItem(lRow, "decisionyn", 'Y')		// 합격처리
	ELSE
		dw_list.SetItem(lRow, "imhist_insdat",snull)			// 검사일자=입고의뢰일자
		dw_list.SetItem(lRow, "imhist_iosuqty",0)				// 합격수량=입고수량(관리단위)
		dw_list.SetItem(lRow, "imhist_cnviosu",0)				// 합격수량=입고수량(발주단위)
		dw_list.SetItem(lRow, "decisionyn", snull)		   // 합불판정 null
	END IF
	
	IF sSaleYn = 'Y' and sQcGubun = '1'	then
		// 무검사이고 수불자동승인인 경우 또는 재고관리 대상인 아닌것
		dw_list.SetItem(lRow, "imhist_io_date",  sDate)		// 수불승인일자=입고의뢰일자
		dw_list.SetItem(lRow, "imhist_io_empno", sNull)		// 수불승인자=NULL
		dw_list.SetItem(lRow, "imhist_ioqty", dw_list.GetItemDecimal(lRow, "imhist_ioreqty")) 	// 수불수량=입고수량
		dw_list.SetItem(lRow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") * dw_list.GetItemDecimal(lRow, "imhist_ioprc"), 0))	// 수불금액=입고단가		
   ELSE
		dw_list.SetItem(lRow, "imhist_io_date",  sNull)		// 수불승인일자=입고의뢰일자
		dw_list.SetItem(lRow, "imhist_io_empno", sNull)		// 수불승인자=NULL
		dw_list.SetItem(lRow, "imhist_ioqty", 0)  // 수불수량=입고수량				
		dw_list.SetItem(lRow, "imhist_ioamt", 0)  // 수불수량=입고수량						
	END IF
	

	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' then
		
		if sQcgubun = '1' then
			dw_list.SetItem(lRow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") * dw_list.GetItemDecimal(lRow, "imhist_ioprc"), 0))	// 수불금액=입고단가		
		end if
		
		Continue

	END IF 

	// 무검사이고 자동승인이고 재고관리가 아닌 경우
	IF sSaleYn = 'Y' and sQcGubun = '1'	and sStockGubun = 'N' then

	  UPDATE "IMHIST"  
		  SET "DEPOT_NO" = :sHouse,
				"IOQTY"   = :dInQty,    
				"IOREQTY" = :dInQty,
				"IOSUQTY" = :dInQty,  
				"UPD_USER" = :gs_userid
		WHERE ( "IMHIST"."SABU" = :gs_sabu ) 	AND  
				( "IMHIST"."IP_JPNO" = :sHist_Jpno )  AND
				( "IMHIST"."JNPCRT"  = '008' ) ;
		
		IF SQLCA.SQLNROWS < 1	THEN
			ROLLBACK;
			messagebox('확인', '상대 출고전표 저장 실패!')
			RETURN -1
		END IF
	END IF
	
NEXT

RETURN 1

end function

public function integer wf_update_gubun ();long		lRow, lCount
string	sQcgubun, sQcdate, sIoConfirm, sIoDate, sMagub, sBlno

string   sittyp, sitcls, scvcod, sitnbr, sPspec

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

if ic_status <> '1' then
		
	FOR  lRow = 1	TO	lCount
		// 검사구분, 검사일자입력시 수정불가
		sQcgubun = dw_list.GetItemString(lRow, "qcgubun")
		sQcdate  = dw_list.GetItemString(lRow, "imhist_insdat")
		
		dw_list.SetItem(lRow, "updategubun", 'Y')

	   if sMagub = 'Y' then 
			dw_list.SetItem(lRow, "blmagub", 'Y')
	   end if
		
		IF sQcgubun > '1'	THEN
			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
		END IF
		
		// 수불승인여부, 수불일자입력시 수정불가
		sIoConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
		sIoDate    = dw_list.GetItemString(lRow, "imhist_io_date")
		IF sIoConfirm = 'N'	THEN
			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
		END IF
		
		// 외주인 경우 생산입고CHECK
		IF dw_list.getitemstring(LRow, "shpgu") = 'N' then
			dw_list.SetItem(lRow, "updategubun", 'N')			
		end if
	
		dw_list.setitem(lRow, "qcsugbn", is_qccheck)		// 검사구분 수정여부
	NEXT
END IF

RETURN 1


end function

public function integer wf_initial ();String sIogbn, sMaigbn, sNull, sLocal, ssaupj

Setnull(sNull)

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist_out.reset()

p_save.enabled = false
p_delete.enabled = false
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

dw_detail.Object.saupj.protect 	= 0
dw_detail.Object.gubun.protect 	= 0
dw_detail.Object.empno.protect 	= 0
dw_detail.Object.in_house.protect = 0
dw_detail.Object.vendor.protect 	= 0
dw_detail.Object.jpno.protect 		= 0

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// 등록시
	dw_detail.settaborder("jpno",      0)
	dw_detail.settaborder("sdate",    10)
	dw_detail.settaborder("saupj",    20)
	dw_detail.settaborder("empno",    30)
	dw_detail.settaborder("gubun",    40)
	dw_detail.settaborder("vendor",   50)
	dw_detail.settaborder("in_house", 60)
	
	Select l_saupj into :ssaupj from login_t
	 Where l_userid = :gs_userid;
	
	// 구매입고 형태의 수불구분중에서 임의의 코드를 Default로 Setting(국내구매만 선택)
	Select a.iogbn, a.maigbn, a.ioyea2 into :sIogbn, :sMaigbn, :sLocal
	  From Iomatrix a
	 Where a.iogbn = 
		  (Select Min(iogbn) 
			  from iomatrix where sabu = :gs_sabu and jnpcrt = '007' and maigbn = '1');

	dw_detail.setcolumn("empno")
	dw_detail.SetItem(1, "sdate", is_Date)
	dw_detail.setitem(1, "gubun", siogbn)
	dw_detail.setitem(1, "maigbn", smaigbn)
//	dw_detail.setitem(1, "saupj", ssaupj)	

	dw_list.SetTransObject(sqlca)

	w_mdi_frame.sle_msg.text = "등록"

ELSE
	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("sdate", 0)
	dw_detail.settaborder("saupj", 0)	
	dw_detail.settaborder("empno", 0)
	dw_detail.settaborder("gubun", 0)
	dw_detail.settaborder("vendor", 0)
	dw_detail.settaborder("in_house", 0)
	
	dw_detail.setcolumn("JPNO")

	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

//사업장
f_mod_saupj(dw_detail, 'saupj' )

ssaupj = dw_detail.GetItemString(1, 'saupj')
//입고창고 
f_child_saupj(dw_detail, 'in_house', ssaupj )

return  1

end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 입고수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sCode, sQcgub, get_nm, spordno, get_pdsts, slotgub, sLotno
dec{3}	dQty 
dec{5}   dPrice
long		lRow, lcount

if dw_list.accepttext() = -1 then return -1

FOR	lRow = 1		TO		dw_list.RowCount()

		sCode = dw_list.GetitemString(lRow, "itnbr")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			MessageBox("품번", "품번등록은 필수입니다", stopsign!)
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("itnbr")
			dw_list.setfocus()
			RETURN -1
		END IF		
			
		sCode = dw_list.GetitemString(lRow, "imhist_pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			dw_list.Setitem(lRow, "imhist_pspec", '.')
		END IF

		sLotgub = Trim(dw_list.GetitemString(lRow, "lotgub"))
		If IsNull(sLotgub) Or sLotgub = '' Then sLotgub = 'N'
		
		sLotNo = Trim(dw_list.GetitemString(lRow, "lotsno"))
		If IsNull(sLotNo) Or sLotNo = '' Then sLotNo = ''
		If sLotgub = 'Y' And sLotNo = '' Then
			MessageBox("LOT NO", "LOT NO는 필수입니다", stopsign!)
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("lotsno")
			dw_list.setfocus()
			RETURN -1
		End If
		
		dQty = dw_list.getitemdecimal(lrow, "imhist_ioreqty")
		IF IsNull(dQty)  or  dQty = 0		THEN
			f_message_chk(30,'[입고수량]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioreqty")
			dw_list.setfocus()
			RETURN -1
		END IF
		
		dPrice = dw_list.GetitemDecimal(lRow, "imhist_ioprc")
		IF IsNull(dPrice)	or dPrice <= 0	THEN
			f_message_chk(30,'[입고단가]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioprc")
			dw_list.setfocus()
			RETURN -1
		END IF		

		/* 검사품목인 경우에만 check */
		if dw_list.getitemstring(lrow, "qcgubun") > '1' then
			sCode = dw_list.GetitemString(lRow, "empno")
			IF IsNull(scode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[검사담당자]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("empno")
				dw_list.setfocus()
				RETURN -1
			END IF

			sCode = dw_list.GetitemString(lRow, "imhist_gurdat")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				dw_list.setitem(Lrow, "imhist_gurdat", f_today())
			END IF
		End if
NEXT

RETURN 1

end function

public function integer wf_imhist_create (ref string rsdate, ref decimal rdseq);///////////////////////////////////////////////////////////////////////
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '007'
///////////////////////////////////////////////////////////////////////
string	sJpno, 		&
			sin_house,	&		
			ssaupj,		&
			sDate, 		&
			sVendor,		&
			sSaleYn,		&
			sGubun,		&
			sQcGubun,	&
			sQcEmpno,	&
			sStockGubun,	&
			sNull, sMaigbn, sIogbn, sDeptcode, sIojpno, sOpseq, sempno , sItnbr, sLotsNo, scustNo
long		lRow, lRowOut
long 		dSeq, dOutSeq 
SetNull(sNull)

dw_detail.AcceptText()

sDate  = trim(dw_detail.GetItemString(1, "sdate"))				// 입고의뢰일자
IF IsNull(sdate)	or   trim(sdate) = ''	THEN
	f_message_chk(30,'[입고의뢰일자]')
   return -1
END IF	

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[입고의뢰번호]')
	RETURN -1
END IF
rSdate = sDate
rDseq	 = dseq

/* 재고 미관리 대상이 있는지 검색하여 있으면 수불구분및 전표번호를 생성 */
FOR	lRow = 1		TO		dw_list.RowCount()
		if dw_list.getitemstring(lrow, "imhist_filsk") = 'N' then
			/* 전표번호 */
			dOutSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
			IF dOutSeq < 1		THEN
				ROLLBACK;
				f_message_chk(51,'[자동출고번호]')
				RETURN -1
			END IF
			/* 수불구분	*/
			Select iogbn into :sIogbn from iomatrix where maiaut = 'Y' ;
			If sqlca.sqlcode <> 0 then
				ROLLBACK;
				f_message_chk(41,'[수불구분]')
				return -1
			end if
			Exit	
		End if
Next

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  	 = sDate + string(dSeq, "0000")

dw_detail.SetItem(1, "jpno", 	sJpno)	
sEmpno 	 = dw_detail.GetItemString(1, "empno")				// 입고의뢰자
sGubun 	 = dw_detail.GetItemString(1, "gubun")
ssaupj 	 = dw_detail.GetItemString(1, "saupj")
svendor 	 = dw_detail.GetItemString(1, "vendor")
sin_house = dw_detail.GetItemString(1, "in_house")

/* 신규입력자료를 위한 clear */
dw_imhist_out.reset()

FOR	lRow = 1		TO		dw_list.RowCount()
	/////////////////////////////////////////////////////////////////////////
	//																							  //	
	// ** 입출고HISTORY 생성 **														  //	
	//																							  //
	/////////////////////////////////////////////////////////////////////////

	if dw_list.getitemdecimal(lrow, "imhist_ioreqty") = 0 then continue

	sQcGubun 	= dw_list.GetItemString(lRow, "qcgubun")
	sQcEmpno		= dw_list.GetItemString(lRow, "empno")
	sStockGubun = dw_list.GetItemString(lRow, "imhist_filsk")
	
 
	dw_list.SetItem(lrow, "imhist_sabu",		gs_sabu)
	dw_list.SetItem(lrow, "jnpcrt",	'007')			// 전표생성구분
	dw_list.SetItem(lrow, "inpcnf",  'I')				// 입출고구분
	sIojpno = sJpno + string(lrow, "000")
	dw_list.SetItem(lrow, "imhist_iojpno", 	sIojpno)
	dw_list.SetItem(lrow, "imhist_iogbn",   sGubun) 			// 수불구분=입고구분

	dw_list.SetItem(lrow, "imhist_sudat",	sDate)			// 수불일자=현재일자
	dw_list.SetItem(lrow, "imhist_depot_no", sin_house) 		// 기준창고=입고처======
	dw_list.SetItem(lrow, "imhist_cvcod",	svendor) 		// 거래처창고=거래처
	dw_list.SetItem(lrow, "imhist_cust_no",svendor) 		// 거래처창고=거래처
	dw_list.SetItem(lrow, "imhist_yebi2",	'WON') 	   // 통화단위

	select deptcode into :sdeptcode from p1_master where empno = :sempno;
	dw_list.SetItem(lrow, "imhist_ioredept",	sDeptcode)	// 수불의뢰부서
	dw_list.SetItem(lrow, "imhist_ioreemp",	sEmpno)			// 수불의뢰담당자=입고의뢰자
    
	//부가 사업장  
	dw_list.SetItem(lrow, "imhist_saupj",	ssaupj)	

	// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
	// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
	SELECT HOMEPAGE
	  INTO :sSaleYN
	  FROM VNDMST
	 WHERE ( CVCOD = :sIn_house ) ;	
	 
	// 재고관리 대상이 아니면 자동승인
	if sstockgubun = 'N' then ssaleyn = 'Y'
	
	// 단, 공정외주인 경우에는 무조건 수동승인 
	if dw_list.GetItemString(lRow, "imhist_opseq") <> '9999' then
		ssaleyn = 'N'
	end if
	
	dw_list.SetItem(lrow, "imhist_io_confirm", sSaleYn)			// 수불승인여부

	IF sQcGubun = '1'		THEN										// 검사구분=무검사일 경우
		dw_list.SetItem(lrow, "imhist_insdat",sDate)			// 검사일자=입고의뢰일자
		dw_list.SetItem(lrow, "empno",snull)			// 검사담당자=null
		dw_list.SetItem(lrow, "imhist_iosuqty",dw_list.GetItemDecimal(lRow, "imhist_ioreqty"))	// 합격수량=입고수량(관리단위)
		dw_list.SetItem(lrow, "imhist_cnviosu",dw_list.GetItemDecimal(lRow, "imhist_ioreqty"))	// 합격수량=입고수량(발주단위)
		dw_list.SetItem(lrow, "decisionyn", 'Y')		// 합격처리
	END IF
	
	IF sQcgubun = '1' And sSaleYn = 'Y' then // 무검사이고 수불자동승인인 경우 또는 재고관리 대상인 아닌것
		dw_list.SetItem(lrow, "imhist_io_confirm", sSaleYn)	// 수불승인여부	
		dw_list.SetItem(lrow, "imhist_ioqty", dw_list.GetItemDecimal(lRow, "imhist_ioreqty")) 	// 수불수량=입고수량
		dw_list.SetItem(lrow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") &
		                  * dw_list.GetItemDecimal(lRow, "imhist_ioprc"), 0))	// 수불금액=입고단가
		dw_list.SetItem(lrow, "imhist_io_date",  sDate)		// 수불승인일자=입고의뢰일자
		dw_list.SetItem(lrow, "imhist_io_empno", sNull)		// 수불승인자=NULL
	END IF

	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' And sQcgubun = '1' THEN
		
		dw_list.SetItem(lrow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") * dw_list.GetItemDecimal(lRow, "imhist_ioprc"), 0))	// 수불금액=입고단가
					  
		CONTINUE

	END IF
	
	/////////////////////////////////////////////////////////////////////////////////////
	// 출고전표 생성 : 전표생성구분('008')
	/////////////////////////////////////////////////////////////////////////////////////
	IF (sQcgubun = '1' And sSaleYn = 'Y') and sstockgubun = 'N' then 

		lRowOut = dw_imhist_out.InsertRow(0)
	
		dw_imhist_out.SetItem(lRowOut, "sabu",		gs_sabu)
		dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// 전표생성구분
		dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// 입출고구분
		dw_imhist_out.SetItem(lRowOut, "iojpno", 	sDate+string(dOutSeq, "0000")+string(lRowout, "000"))
		dw_imhist_out.SetItem(lRowOut, "iogbn",   siogbn) 			// 수불구분
		dw_imhist_out.SetItem(lRowOut, "sudat",	sDate)			// 수불일자=현재일자
		dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist_out.SetItem(lRowOut, "pspec",	dw_list.GetItemString(lRow, "imhist_pspec"))//사양
		dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// 공정순서
		dw_imhist_out.SetItem(lRowOut, "depot_no",sin_house) 		// 기준창고=입고처
		dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// 거래처창고=입고처
		dw_imhist_out.SetItem(lRowOut, "ioqty",   dw_list.GetItemDecimal(lRow, "imhist_ioreqty"))		// 수불수량=입고수량
		dw_imhist_out.SetItem(lRowOut, "ioprc",	0)	
		dw_imhist_out.SetItem(lRowOut, "ioreqty",	dw_list.GetItemDecimal(lRow, "imhist_ioreqty")) 	// 수불의뢰수량=입고수량		
		dw_imhist_out.SetItem(lRowOut, "insdat",	sDate) 			// 검사일자=입고의뢰일자
		dw_imhist_out.SetItem(lRowOut, "iosuqty", dw_list.GetItemDecimal(lRow, "imhist_ioreqty"))		// 합격수량=입고수량

		dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// 수불승인자
		dw_imhist_out.SetItem(lRowOut, "io_confirm", sSaleYn)		// 수불승인여부
		dw_imhist_out.SetItem(lRowOut, "io_date", sDate)			// 수불승인일자=입고일자
		dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// 재고관리구분
		dw_imhist_out.SetItem(lRowOut, "bigo",  '구매입고 동시출고분')
		dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// 동시출고여부
		dw_imhist_out.SetItem(lRowOut, "ip_jpno", sJpno + string(lrow, "000")) // 입고전표번호
		dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// 수불의뢰담당자=입고의뢰담당자
	END IF

NEXT

RETURN 1
end function

public function integer wf_cnvfat (long lrow, string arg_itnbr);Decimal {5} dCnvfat, dPrice

// 품목마스터의 conversion factor를 검색
dCnvfat = 1
Select nvl(cnvfat, 1)
  into :dCnvfat
  From Itemas
 Where itnbr = :arg_itnbr;
 
If isnull(dCnvfat) or dCnvfat = 0 or is_gubun = 'N' then
	dCnvfat = 1
end if

dPrice = dw_list.getitemdecimal(Lrow, "unprc")
dw_list.setitem(Lrow, "poblkt_cnvprc", dPrice)

if dCnvfat = 1 then
	dw_list.setitem(Lrow, "poblkt_cnvart", '*')
else	
	dw_list.setitem(Lrow, "poblkt_cnvart", is_cnvart)	
end if

dw_list.setitem(Lrow, "poblkt_cnvfat", dCnvfat)

// 변환계수 변환에 따른 내역 변경(수량, 단가, 금액)
if dw_list.getitemdecimal(Lrow, "poblkt_cnvfat") = 1 then
	dw_list.setitem(Lrow, "poblkt_cnvqty", dw_list.getitemdecimal(Lrow, "balqty"))		
elseif dw_list.getitemstring(Lrow, "poblkt_cnvart") = '/' then
	dw_list.setitem(Lrow, "poblkt_cnvqty", round(dw_list.getitemdecimal(Lrow, "balqty") / dCnvfat, 3))
else
	dw_list.setitem(Lrow, "poblkt_cnvqty", round(dw_list.getitemdecimal(Lrow, "balqty") * dCnvfat, 3))
end if

if dw_list.getitemdecimal(Lrow, "poblkt_cnvfat") = 1  then
	dw_list.setitem(Lrow, "poblkt_cnvamt", round(dw_list.getitemdecimal(Lrow, "poblkt_cnvqty") * &
																  dw_list.getitemdecimal(Lrow, "poblkt_cnvprc"), 2))			
elseif dw_list.getitemstring(Lrow, "poblkt_cnvart") = '/' then
	dw_list.setitem(Lrow, "unprc",  round(dw_list.getitemdecimal(Lrow, "poblkt_cnvprc") / dCnvfat,  5))
	dw_list.setitem(Lrow, "poblkt_cnvamt", round(dw_list.getitemdecimal(Lrow, "poblkt_cnvqty") * &
																  dw_list.getitemdecimal(Lrow, "poblkt_cnvprc"), 2))	
else
	dw_list.setitem(Lrow, "unprc",  round(dw_list.getitemdecimal(Lrow, "poblkt_cnvprc") * dCnvfat,  5))
	dw_list.setitem(Lrow, "poblkt_cnvamt", round(dw_list.getitemdecimal(Lrow, "poblkt_cnvqty") * &
																  dw_list.getitemdecimal(Lrow, "poblkt_cnvprc"), 2))
end if
 
Return 0
end function

public function integer wf_dan (long lrow, string sitnbr, string arg_pspec, string sopseq);// 구매단가 구하기

string scvcod, scvnas, stuncu
decimal {3} dunprc

if isnull( sopseq ) or trim( sopseq ) = '' then 
	sopseq = '9999'
End if
f_buy_unprc(sitnbr, arg_pspec,  sopseq, scvcod, scvnas, dunprc, stuncu)


dw_list.setitem(Lrow, "imhist_ioprc", dunprc)

return 1
end function

event open;Integer  li_idx

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

PostEvent('ue_open') 
end event

on w_mat_01300.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_1=create pb_1
this.p_print=create p_print
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_inq=create p_inq
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.dw_imhist_out=create dw_imhist_out
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.rr_1=create rr_1
this.dw_hidden=create dw_hidden
this.dw_list=create dw_list
this.Control[]={this.pb_1,&
this.p_print,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_inq,&
this.p_delrow,&
this.p_addrow,&
this.dw_imhist_out,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.gb_2,&
this.rr_1,&
this.dw_hidden,&
this.dw_list}
end on

on w_mat_01300.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.p_print)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_inq)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.dw_imhist_out)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.dw_hidden)
destroy(this.dw_list)
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
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_1 from u_pb_cal within w_mat_01300
integer x = 2112
integer y = 28
integer taborder = 20
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type p_print from uo_picture within w_mat_01300
integer x = 3013
integer y = 4
integer width = 306
integer taborder = 100
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

event clicked;call super::clicked;//발주처 품목선택	-버턴명
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, Srow, sopseq, sdEmpno, sdGubun, sin_house, sio_gub
int    k, lRow
Decimal {5} ddata

IF dw_detail.AcceptText() = -1	THEN	RETURN

ls_Saupj = dw_detail.GetItemString(1, "saupj"   )
sCvcod 	= dw_detail.getitemstring(1, "vendor"  )
gs_gubun = dw_detail.getitemstring(1, "empno"   )
sin_house= dw_detail.getitemstring(1, "in_house")
sio_gub  = dw_detail.getitemstring(1, "gubun"   )

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[입고처]')
	dw_detail.SetColumn("vendor")
	dw_detail.SetFocus()
	RETURN
END IF

// 입고담당자
IF IsNull(gs_gubun)	or   trim(gs_gubun) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고담당자]')
	dw_detail.Setcolumn("empno")
	dw_detail.setfocus()
	RETURN 
END IF

// 입고창고
IF IsNull(sin_house)	or   trim(sin_house) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고창고]')
	dw_detail.Setcolumn("in_house")
	dw_detail.setfocus()
	RETURN 
END IF


// 입고 구분
IF IsNull(sio_gub)	or   trim(sio_gub) = ''	THEN
	sio_gub = '%'
ELSE
	if sio_gub = 'I01' then      // 구매입고
		sio_gub = '1' 
	elseif sio_gub = 'I03' then  // 외주입고
	   sio_gub     = '2' 
	end if
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code  = sCvcod
gs_gubun = sio_gub
open(w_vnditem_popup3)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		lRow = dw_list.insertrow(0)

		dw_list.setitem(lRow, "imhist_sabu", gs_sabu)

      sitem  = dw_hidden.getitemstring(k, 'poblkt_itnbr' )
		sopseq = dw_hidden.getitemstring(k, "opseq")
		if isnull( sopseq ) or trim( sopseq ) = '' then 
			sopseq = '9999'
		End if
		
		dw_list.setitem(lRow, 'itnbr', sitem)
		dw_list.setitem(lRow, 'imhist_opseq', sopseq)
		dw_list.setitem(lRow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_list.setitem(lRow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_list.setitem(lRow, 'itemas_jijil', dw_hidden.getitemstring(k, 'itemas_jijil' ))

	SELECT "DANMST"."QCEMP", "DANMST"."QCGUB"  
	  INTO :sdEmpno, :sdGubun  
	  FROM "DANMST"  
	 WHERE ( "DANMST"."ITNBR" = :sitem  ) AND  
			 ( "DANMST"."CVCOD" = :scvcod ) AND
			 ( "DANMST"."OPSEQ" = :sopseq ) ;

		f_buy_unprc(sitem, '.' , sopseq, scvcod, scvnas, ddata, stuncu)
		dw_list.setitem(Lrow, "imhist_ioprc", ddata)
		
		dw_list.setitem(lRow, 'qcgubun', sdGubun)
		dw_list.setitem(lRow, 'empno'  , sdEmpno)
		
	end if	
NEXT
dw_hidden.reset()
dw_list.ScrollToRow(lRow)
dw_list.setrow(lRow)
dw_list.SetColumn("imhist_ioreqty")
dw_list.SetFocus()


end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\발주처품목선택_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\발주처품목선택_up.gif"
end event

type p_exit from uo_picture within w_mat_01300
integer x = 4402
integer y = 4
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

type p_cancel from uo_picture within w_mat_01300
integer x = 4229
integer y = 4
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

type p_delete from uo_picture within w_mat_01300
integer x = 4055
integer y = 4
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
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
String sError, sGubun, sIojpno, sWigbn
int    ireturn 

SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

ireturn = wf_Imhist_Delete()

IF ireturn  = -1		THEN	RETURN

IF dw_list.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
	return 
END IF

Commit;

IF ireturn = -2 THEN 
   p_cancel.triggerevent(clicked!)
END IF

end event

type p_save from uo_picture within w_mat_01300
integer x = 3881
integer y = 4
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

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 입고수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
string sdate, sWigbn, sError, sIojpno, sGubun
long	 lRow
dec	 dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 

IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	
	IF wf_imhist_create(sdate, dseq) < 0 THEN RETURN 

	IF dw_list.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF

	IF dw_imhist_out.Update() <> 1	THEN
		ROLLBACK;
		f_Rollback()
		RETURN		
	END IF
	
	/* 입고형태가 외주인지 check	*/
	sGubun = dw_detail.GetItemString(1, "gubun")	
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sGubun;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		f_message_chk(311,'[외주여부]')
		return 
	end if
	
	/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 생성 
		-. 단 검사일자가 있는 경우에 한 함*/
	if sWigbn = 'Y' Then
		sError 	= 'X';
		dw_detail.accepttext()
		sIojpno = dw_detail.GetItemString(1, "jpno")
		sqlca.erp000000360(gs_sabu, sIoJpno, 'I', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고]')
			Rollback;
			return 
		end if;
	end if;	

	IF wf_imhist_create_waiju() <> 1 THEN return

	Commit;

	MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
										 "~r~r생성되었습니다.")

/////////////////////////////////////////////////////////////////////////
//	1. 수정 
/////////////////////////////////////////////////////////////////////////
ELSE

	IF wf_imhist_update() = -1	THEN RETURN

	IF dw_list.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		return 
	END IF
	
	/* 입고형태가 외주인지 check	*/
	sGubun = dw_detail.GetItemString(1, "gubun")	
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sGubun;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		f_message_chk(311,'[외주여부]')
		return -1
	end if

	/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 삭제및생성 
		-. 단 검사일자가 있는 경우에 한 함*/
	if sWigbn = 'Y' Then 
		sError 	= 'X';
		dw_detail.accepttext()
		sIojpno = dw_detail.GetItemString(1, "jpno")
		sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);	/* 삭제 */
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고]')
			Rollback;
			return -1
		end if;
		sqlca.erp000000360(gs_sabu, sIoJpno, 'I', sError);	/* 생성 */
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고]')
			Rollback;
			return -1
		end if;		
	end if;

	IF wf_imhist_update_waiju() <> 1 THEN return

	Commit;

END IF

////////////////////////////////////////////////////////////////////////

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)

end event

type p_inq from uo_picture within w_mat_01300
integer x = 3707
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;//retrievrow 에 error 발생할 경우를 대비하여( 두번연속 클릭못하게 하기위함 )
This.Enabled = False

if dw_detail.Accepttext() = -1	then 	return

string  	sGubun,		&
			ssaupj,		&
			sJpno,		&
			sDate,		&
			sEmpno,		&
			sNull,	smaigbn, svendor, sin_house, swaigu, ls_saupj
long		lRow 

SetNull(sNull)

sJpno  		 = dw_detail.getitemstring(1, "jpno")
sgubun  		 = dw_detail.getitemstring(1, "gubun")
ls_saupj		 = dw_detail.getitemstring(1, "saupj")

If IsNull(ls_saupj) or ls_saupj = "" then
	ls_saupj = "%"
End If

SetPointer(HourGlass!)  
dw_list.setredraw(false)
//////////////////////////////////////////////////////////////////////////	
// 수정
//////////////////////////////////////////////////////////////////////////	

IF isnull(sJpno) or sJpno = "" 	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고번호]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	This.Enabled = True
	RETURN
END IF

sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	dw_list.setredraw(true)
	f_message_chk(50, '[입고내역]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN
END IF

wf_Update_Gubun()
p_delete.enabled = true
select waigu into :swaigu from iomatrix where sabu = :gs_sabu and iogbn = :sgubun;
//외주인 경우에만 작업지시번호, 공정을 Open
if sWaigu = 'Y' then
	dw_list.object.imhist_jakjino.protect = '0'
	dw_list.object.imhist_opseq.protect = '0'
Else
	dw_list.object.imhist_jakjino.protect = '1'
	dw_list.object.imhist_opseq.protect = '1'	
End if

dw_list.setredraw(true)
//////////////////////////////////////////////////////////////////////////
//dw_detail.enabled = false

dw_detail.Object.saupj.protect 	= 1
dw_detail.Object.gubun.protect 	= 1
dw_detail.Object.empno.protect 	= 1
dw_detail.Object.in_house.protect = 1
dw_detail.Object.vendor.protect 	= 1
dw_detail.Object.jpno.protect 		= 1

dw_list.SetFocus()
p_save.enabled = true
This.Enabled = True

SetPointer(Arrow!)
end event

type p_delrow from uo_picture within w_mat_01300
integer x = 3511
integer y = 4
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;Long Lrow

Lrow = dw_list.getrow()
if Lrow < 1 then return

if Messagebox("행삭제", "삭제하시겠읍니까?", question!, yesno!) = 1 then
	dw_list.deleterow(Lrow)
End if
end event

type p_addrow from uo_picture within w_mat_01300
integer x = 3337
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event clicked;call super::clicked;Long lrow
//최초에만 Check함
if dw_list.rowcount() > 0 then 
	Lrow = dw_list.insertrow(0)	
	dw_list.scrolltorow(Lrow)
	dw_list.setrow(Lrow)
	dw_list.setcolumn("itnbr")
	dw_list.setfocus()
	return
End if

if dw_detail.Accepttext() = -1	then 	return

string  	sGubun,		&
			ssaupj,		&
			sDate,		&
			sEmpno,		&
			sNull,	smaigbn, svendor, sin_house, swaigu

SetNull(sNull)

sEmpno 		 = dw_detail.GetItemstring(1, "empno")
sSaupj 		 = dw_detail.getitemstring(1, "saupj")
sGubun 		 = dw_detail.getitemstring(1, "gubun")
svendor 		 = dw_detail.getitemstring(1, "vendor")
sin_house	 = dw_detail.getitemstring(1, "in_house")
sDate =  trim(dw_detail.GetItemString(1, "sdate"))


//////////////////////////////////////////////////////////////////////////
IF isnull(sDate) or sDate = "" 	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	This.Enabled = True
	RETURN
END IF

// 사업장
IF IsNull(ssaupj)	or   trim(ssaupj) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[사업장]')
	dw_detail.Setcolumn("saupj")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF		

// 입고담당자
IF IsNull(sEmpno)	or   trim(sEmpno) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고담당자]')
	dw_detail.Setcolumn("empno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

// 입고구분
IF IsNull(sgubun)	or   trim(sgubun) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고구분]')
	dw_detail.Setcolumn("gubun")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF	

// 거래처
IF IsNull(svendor)	or   trim(svendor) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[거래처]')
	dw_detail.Setcolumn("vendor")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

// 입고창고
IF IsNull(sin_house)	or   trim(sin_house) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고창고]')
	dw_detail.Setcolumn("in_house")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

select waigu into :swaigu from iomatrix where sabu = :gs_sabu and iogbn = :sgubun;

//외주인 경우에만 작업지시번호, 공정을 Open
if sWaigu = 'Y' then
	dw_list.object.imhist_jakjino.protect = '0'
	dw_list.object.imhist_opseq.protect = '0'	
Else
	dw_list.object.imhist_jakjino.protect = '1'
	dw_list.object.imhist_opseq.protect = '1'	
End if
	
//////////////////////////////////////////////////////////////////////////
dw_detail.enabled = false
dw_list.insertrow(0)
dw_list.SetFocus()
p_save.enabled = true

end event

type dw_imhist_out from datawindow within w_mat_01300
boolean visible = false
integer x = 2354
integer y = 2348
integer width = 494
integer height = 360
boolean titlebar = true
string dataobject = "d_pdt_imhist"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

type rb_delete from radiobutton within w_mat_01300
integer x = 4270
integer y = 188
integer width = 242
integer height = 72
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

dw_list.setredraw(false)

wf_Initial()

p_inq.enabled = True
p_addrow.enabled   = False
p_delrow.enabled   = False

dw_list.object.t_11.visible = '1'
//dw_list.object.t_12.visible = '1'
dw_list.object.updategubun.visible = '1'
dw_list.object.del.visible = '1'
dw_list.SetTransObject(SQLCA)

dw_list.setredraw(true)


end event

type rb_insert from radiobutton within w_mat_01300
integer x = 3895
integer y = 188
integer width = 242
integer height = 72
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

dw_list.setredraw(False)

wf_Initial()

p_inq.enabled      = False
p_addrow.enabled   = True
p_delrow.enabled   = True

dw_list.object.t_11.visible = '0'
//dw_list.object.t_12.visible = '0'
dw_list.object.updategubun.visible = '0'
dw_list.object.del.visible = '0'

dw_list.setredraw(true)


end event

type dw_detail from datawindow within w_mat_01300
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 24
integer width = 2917
integer height = 260
integer taborder = 10
string dataobject = "d_mat_01300"
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

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 입고승인담당자
IF this.GetColumnName() = 'empno'	THEN
   gs_gubun = '1' 
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
	SetItem(1,"empname",gs_codename)
ELSEIF this.GetColumnName() = 'jpno'	THEN
	gs_gubun = '007'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")
// 거래처
ELSEIF this.GetColumnName() = 'vendor'	THEN

	string	sCheck, sIogbn
	sIogbn = THIS.getitemstring(1, "gubun")

	if sIogbn = "" or isnull(sIogbn) then 
		messagebox('확 인', '입고구분을 먼저 입력하세요!')
		this.setitem(1, 'vendor', siogbn)
		this.setitem(1, 'vendorname', siogbn)
		return 1
	end if

	/* 관련처 기준 검색 */
	SELECT RELCOD INTO :SCHECK FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	    
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case scheck  //관련처코드(1:창고, 2:부서, 3:거래처, 4:창고+부서, 5:ALL)
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case else
					f_message_chk(208,'[거래처]')
					this.setitem(1, 'vendor', "")
					this.setitem(1, 'vendorname', "")
				   return 1
	End choose

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	this.SetItem(1, "vendor", gs_code)
	this.SetItem(1, "vendorname", gs_codename)
	this.TriggerEvent("itemchanged")
	
END IF


end event

event itemchanged;string	scode, sName1,	sname2, sNull, sjpno, sdate, scust, sempno, sgubun,  &
         scustname, sempname, s_today, soldcode, sBalgu, sWaigu, ssaupj, sin_store, sbalno, sblno, slcno
int      ireturn, get_count 
			
SetNull(sNull)

// 입고의뢰일자
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고의뢰일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
//////////////////////////////////////////////////////////////////////////
// 담당자
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "empno" THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empname', snull)
      return 
   end if
	sname2 = '%'
   ireturn = f_get_name2('입고의뢰자', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empname', sname1)
   return ireturn 
	
//////////////////////////////////////////////////////////////////////////
// 거래처
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "vendor" THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'vendorname', snull)
      return 
   end if
   ireturn = f_get_name2('V1', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, 'vendor', scode)
	this.setitem(1, 'vendorname', sname1)
   return ireturn 	
	
//////////////////////////////////////////////////////////////////////////
// 전표번호
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'jpno'	THEN

	sJpno = TRIM(this.GetText())

	IF sJPno = '' or isnull(sJpno) then 
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.setitem(1, "gubun",   sNull)		
		this.SetItem(1, "vendor",  sNull)
		this.SetItem(1, "vendorname", sNull)
		return 
   END IF
	
	SELECT A.SUDAT,  A.CVCOD,   A.IOREEMP,
			 A.IOGBN,  A.BALJPNO, A.POBLNO, A.POLCNO, 
			 B.CVNAS2, D.EMPNAME, A.SAUPJ, A.DEPOT_NO
	  INTO :sDate, :sCust, :sEmpno, 
	  		 :sGubun, :sBalno, :sBlno, :sLcno,  
	  		 :sCustName, :sEmpName, :sSaupj, :sin_store
	  FROM IMHIST A, VNDMST B, P1_MASTER D
	 WHERE A.CVCOD    = B.CVCOD(+)	AND
			 A.IOREEMP  = D.EMPNO(+)	AND
	 		 A.SABU = :gs_sabu			AND
	 		 A.IOJPNO like :sJpno||'%'		AND
			 A.JNPCRT LIKE '007'  and rownum = 1;
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[입고번호]')
		this.setitem(1, "jpno", sNull)
		RETURN 1
	END IF
	
	If isnull(sBalno) or trim(sBalno) = '' then
	Else
		MessageBox("구매입고", "구매입고의뢰 등록으로 작성된 자료입니다" + '~n' + &
									  "구매입고의뢰 등록에서 수정하시기 바랍니다", information!)
		this.setitem(1, "jpno", sNull)
		RETURN 1
	END IF		

	this.SetItem(1, "sdate",   sDate)
	this.SetItem(1, "empno",	sEmpno)
	this.SetItem(1, "empname", sEmpname)
	this.SetItem(1, "vendor",  sCust)
	this.setitem(1, "gubun",   sgubun)
	this.setitem(1, "saupj",   ssaupj)
	this.setitem(1, "in_house",   sin_store)	
	this.SetItem(1, "vendorname", sCustName)	
	
	dw_list.SetTransObject(sqlca)
ELSEIF this.GetColumnName() = 'saupj'	THEN
	scode = TRIM(this.GetText())
	//입고창고 
	f_child_saupj(this, 'in_house', scode )
	
END IF



end event

type gb_2 from groupbox within w_mat_01300
integer x = 3849
integer y = 140
integer width = 718
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_mat_01300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 292
integer width = 4503
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_hidden from datawindow within w_mat_01300
boolean visible = false
integer x = 219
integer y = 576
integer width = 1842
integer height = 548
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_vnditem_popup3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_mat_01300
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 78
integer y = 304
integer width = 4475
integer height = 1904
integer taborder = 20
string dataobject = "d_mat_01303"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;long	iRow

iRow = this.GetRow()

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

setnull(gs_code)

IF keydown(keyF3!) THEN
	IF This.GetColumnName() = "itnbr" Then
		gs_codename = dw_detail.GetItemString(1,"vendor")
		open(w_itmbuy2_popup)
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(iRow,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF
end event

event itemchanged;dec {3}  dQty,  dCinqty, dtemp, DtEMP1, dInqty
long		lRow, ireturn 
string	scvcod, sVendorName, 	&
			sQcGubun, sQcEmpno,		&
			sItem,	sNull, sDate, sGubun, sWigbn, sKumno, sitdsc, sspec, sjijil, sfilsk, sname, sspec_code, &
			sqcgub,  sqcemp, sitgu, ls_pspec, sopseq, slotgub
decimal  maprc
SetNull(sNull)

lRow  = this.GetRow()	

this.accepttext()

scvcod = dw_detail.getitemstring(1, 'vendor')

IF this.GetColumnName() = 'itnbr'	THEN
	sItem = trim(THIS.GETTEXT())								
	ireturn = f_get_name4_sale('품번', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
 	ib_changed = true
	is_itnbr   = sitem

	this.SetItem(lRow, "itemas_itdsc", sName)
	this.SetItem(lRow, "itemas_ispec", sSpec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	
	if not isnull(sitem) then 
//		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
//		
//		IF sqcgub = '' or isNull(sqcgub) THEN
//			sqcgub = '1'
//			sqcemp = ''
//		END IF

		// 구매기타는 무조건 무검사품
		sqcgub = '1'
		sqcemp = ''

		this.SetItem(lRow, "qcgubun", sqcgub)
		this.SetItem(lRow, "empno", sqcemp)
		
		Select filsk, itgu, lotgub into :sfilsk, :sitgu, :slotgub from itemas
		 where itnbr = :sitem;
		 
		this.setitem(Lrow, "imhist_filsk", sfilsk)
		this.setitem(Lrow, "imhist_itgu", sitgu)
		this.setitem(Lrow, "lotgub", slotgub)
   end if	
	
	sopseq 	= getitemstring(Lrow, "imhist_opseq")
	ls_pspec 	= getitemstring(Lrow, "imhist_pspec")
	wf_dan(Lrow, sitem, ls_pspec, sopseq)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name4_sale('품명', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgubun", sqcgub)
		this.SetItem(lRow, "empno", sqcemp)
   end if		
	
	sopseq = getitemstring(Lrow, "imhist_opseq")
	ls_pspec 	= getitemstring(Lrow, "imhist_pspec")
	wf_dan(Lrow, ls_pspec, sitem, sopseq)	
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name4_sale('규격', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
   this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgubun", sqcgub)
		this.SetItem(lRow, "empno", sqcemp)
   end if
	
	sopseq 	= getitemstring(Lrow, "imhist_opseq")
	ls_pspec 	= getitemstring(Lrow, "imhist_pspec")
	wf_dan(Lrow, sitem, ls_pspec,  sopseq)	
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name4_sale('재질', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgubun", sqcgub)
		this.SetItem(lRow, "empno", sqcemp)
   end if
	
	sopseq = getitemstring(Lrow, "imhist_opseq")
	ls_pspec 	= getitemstring(Lrow, "imhist_pspec")
	wf_dan(Lrow, sitem, ls_pspec, sopseq)	
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sspec_code = trim(this.GetText())
	ireturn = f_get_name4_sale('규격코드', 'Y', sitEM, sname, sspec, sJijil, sspec_code) 
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sJijil)
	this.SetItem(lRow, "itemas_ispec_code", sSpec_code)
	if not isnull(sitem) then 
		F_GET_QC('2', sitem, scvcod, '9999', sqcgub, sqcemp)
		this.SetItem(lRow, "qcgubun", sqcgub)
		this.SetItem(lRow, "empno", sqcemp)
   end if		
	RETURN ireturn

ELSEIF this.GetColumnName() = "imhist_jakjino"	THEN
	sItem = gettext()
	sitdsc = getitemstring(Lrow, "itnbr")
	Select itnbr, purgc into :sname, :sjijil from momast
	 Where sabu = :gs_sabu and pordno = :sitem;
	
	if sqlca.sqlcode <> 0 or sname <> sitdsc then
		Messagebox("작업지시번호", "작업지시번호가 부정확하거나 품번이 틀립니다", stopsign!)
		setitem(Lrow, "imhist_jakjino", snull)
		setitem(Lrow, "imhist_opseq",   snull)		
		return 1
	End if
	
	if sjijil = 'Y' then
		setitem(Lrow, "imhist_opseq", '9999')		
	Else
		setitem(Lrow, "imhist_opseq", sNull)
	End if
	
ELSEIF this.GetColumnName() = "imhist_opseq"	THEN
	
	sItem = gettext()
	sjijil = getitemstring(Lrow, "imhist_jakjino")	
	
	if sitem = '9999' then 
		Select purgc into :sspec from momast
		 Where sabu = :gs_sabu and pordno = :sjijil;
		if sspec = 'N' then
			Messagebox("외주", "해당작업지시는 전체외주로 되어있지 않읍니다", stopsign!)
			setitem(Lrow, "imhist_opseq", sNull)
			return 1
		Else
			return
		end if
	End if
	
	Select opdsc into :sname from morout
	 Where sabu = :gs_sabu and pordno = :sjijil and opseq = :sitem;
	
	if sqlca.sqlcode <> 0 then
		Messagebox("작업공정", "공정이 부정확합니다", stopsign!)
		setitem(Lrow, "imhist_opseq", sNull)
		setitem(Lrow, "routng_opdsc", sNull)		
		return 1
	End if	
	
	setitem(Lrow, "routng_opdsc", sname)

ELSEIF this.GetColumnName() = "imhist_ioreqty" then
	
	dInqty = dec(this.GetText())
	this.setitem(Lrow, "imhist_cnviore", dinqty)
	
// 검사요청일(수정시)
ELSEIF this.GetColumnName() = 'imhist_gurdat' THEN
	sDate  = this.gettext()

	IF sDate = '' or isnull(sdate) then return 

	IF f_datechk(sDate) = -1 	then
		this.setitem(lRow, "imhist_gurdat", sNull)
		return 1
	END IF
// 검사구분
ELSEIF this.GetColumnName() = 'qcgubun' THEN
	sDate  = this.gettext()
	
	if sDate = '1' then 
   	this.setitem(lRow, "empno", sNull)
		this.setitem(lRow, "imhist_gurdat", sNull)
	else
		this.setitem(lRow, "imhist_gurdat", is_today)
	end if	
ELSEIF this.GetColumnName() = 'kumno' THEN
	sKumno  = trim(this.gettext())
	
	IF sKumno = '' OR Isnull(sKumno) then return 
	
   SELECT KUMNAME  
     INTO :sVendorName 
     FROM KUMMST  
    WHERE SABU  = :gs_sabu
      AND KUMNO = :sKumno   ;
	 		 
	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[금형번호]')		
		this.SEtItem(lRow, "kumno", sNull)
	   return 1
	END IF
ELSEIF this.GetColumnName() = 'imhist_pspec' THEN
	ls_pspec  = trim(this.gettext())

	IF ls_pspec = '' OR Isnull(ls_pspec) then return

   	maprc = sqlca.fun_danmst_danga10( dw_detail.GetItemString(1,'sdate'), dw_list.GetItemString( row, 'imhist_cvcod'), + &
	                       dw_list.GetItemString( row, 'itnbr'), ls_pspec)

	IF maprc <>  0	THEN
		this.SetItem(lRow, "imhist_ioprc", maprc )
	   return 1
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

event rbuttondown;long	lRow
lRow  = this.GetRow()	

String sitnbr

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")

//작업지시번호	
ELSEIF this.getcolumnname() = "imhist_jakjino"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(Lrow, "imhist_jakjino", gs_code)	
	this.TriggerEvent("itemchanged")
// 금형번호 */
ELSEIF this.GetColumnName() = "kumno" THEN 
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		SetItem(lRow,'kumno', gs_code)
END IF



end event

event editchanged;dec{3} dQty
dec{5} dPrice
long	lRow

lRow = this.GetRow()

// 입고수량
IF this.getcolumnname() = "imhist_ioreqty"		THEN

	this.AcceptText()
	dQty   = this.getitemdecimal(lRow, "imhist_ioreqty") 
	dPrice = this.getitemdecimal(lRow, "imhist_ioprc")
	
   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		

ELSEIF this.getcolumnname() = "imhist_ioprc"		THEN
	this.AcceptText()
	dQty   = this.getitemdecimal(lRow, "imhist_ioreqty") 
	dPrice = this.getitemdecimal(lRow, "imhist_ioprc")
	
   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
END IF

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

event itemfocuschanged;If ib_changed = True Then
	this.setItem( row, 'itnbr', is_itnbr)
	ib_changed = False
	return
End If
end event

