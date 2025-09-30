$PBExportHeader$w_qct_01040.srw
$PBExportComments$수입검사 등록
forward
global type w_qct_01040 from window
end type
type p_list from uo_picture within w_qct_01040
end type
type p_1 from uo_picture within w_qct_01040
end type
type p_exit from uo_picture within w_qct_01040
end type
type p_can from uo_picture within w_qct_01040
end type
type p_del from uo_picture within w_qct_01040
end type
type p_mod from uo_picture within w_qct_01040
end type
type p_inq from uo_picture within w_qct_01040
end type
type dw_imhist_out from datawindow within w_qct_01040
end type
type rb_delete from radiobutton within w_qct_01040
end type
type rb_insert from radiobutton within w_qct_01040
end type
type dw_detail from datawindow within w_qct_01040
end type
type dw_list from datawindow within w_qct_01040
end type
type rr_1 from roundrectangle within w_qct_01040
end type
type rr_2 from roundrectangle within w_qct_01040
end type
end forward

global type w_qct_01040 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "수입검사 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_list p_list
p_1 p_1
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
dw_imhist_out dw_imhist_out
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01040 w_qct_01040

type variables
char ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

string  is_syscnfg  //합불판정 방법(1:직접, 2;불량수량)
str_qct_01040 str_01040
String      is_ispec, is_jijil
end variables

forward prototypes
public function integer wf_waiju ()
public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun)
public function integer wf_imhist_delete ()
public function integer wf_initial ()
public subroutine wf_modify_gubun ()
public function integer wf_checkrequiredfield ()
public function integer wf_check ()
public function integer wf_update ()
end prototypes

public function integer wf_waiju ();/* 입력 수정인 경우에만 사용함 */
Long   Lrow,  lRowCount
String sIogbn, sWigbn, sError, sIojpno, sGubun

lRowCount = dw_list.rowcount()

For Lrow = 1 to lRowCount
	
	sGubun = dw_list.GetItemString(lRow, "gubun") 
	
	/* 입고형태가 외주인지 check	*/
	siogbn = dw_list.GetItemString(Lrow, "imhist_iogbn")	
	
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		f_message_chk(311,'[외주여부]')
		return -1
	end if

	/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 생성 
		-. 단 검사일자가 있는 경우에 한 함*/
	if sWigbn = 'Y' Then
		sError 	= 'X';
		sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")
		sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고1]')
			Rollback;
			return -1
		end if;		
		sError 	= 'X';
		sqlca.erp000000360(gs_sabu, sIoJpno, 'I', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고2]')
			Rollback;
			return -1
		end if;
	end if;		
Next

return 1
end function

public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// 기존의 작업실적 전표를 삭제한다.
// 구분 A = 신규입력, U = 삭제후 입력, D = 삭제
// 외주가공입고(공정이 9999가 아니면)인 경우에만 실적전표를 작성한다.
String sitnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
Decimal {3} dInqty, dGoqty

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("작업실적삭제", "작업실적 삭제를 실패하였읍니다", stopsign!)
		return -1	
	end if
end if

dInqty	 = dw_list.getitemdecimal(lrow, "imhist_iosuqty")							      // 실적수량
dGoqty	 = dw_list.getitemdecimal(lrow, "imhist_gongqty")	+ &
				dw_list.getitemdecimal(lrow, "imhist_iopeqty")									// 공제수량 -> 폐기수량

if sGubun = 'U' then
	Update Shpact
		Set roqty 	= :dInqty + dGoqty,
			 coqty 	= :dInqty,
			 peqty 	= :dGoqty,			 
			 ipgub   = :sVendor, 
			 upd_user   = :gs_userid 
	 Where sabu 	= :Gs_sabu And Pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("작업실적수정", "작업실적 수정를 실패하였읍니다", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then
	
	sShpJpno  = sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// 작업실적번호
	sitnbr	 =	dw_list.GetItemString(lRow, "imhist_itnbr") 							      // 품번
	sPspec	 =	dw_list.GetItemString(lRow, "imhist_pspec")					      // 사양
	select fun_get_pdtgu(:sitnbr, '1') into :sPdtgu from dual;				      // 생산팀
	sPordno	 = dw_list.getitemstring(lrow, "poblkt_pordno");				      // 작업지시번호	

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
	 
	// 최종공정이면 입고번호를 저장한다
	if sLastc = '3' or sLastc = '9' then
		sShpipno = sDate + string(dShpipgo, "0000") + string(LrowHist, '000')		// 작업실적에 의한 입고번호
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
		  PR_SHPJPNO, 		IPJPNO,           CRT_USER )
		VALUES
		( :gs_sabu,	   	:sShpjpno,			:sItnbr,				:sPspec,				null,
		  :sPdtgu,			null,					null,					:sEmpno,				:sDate,
		  0,					0,						0,						0,						0,
		  :sPordno,			'4',					'Y',					:dinqty + :dGoqty,0,
		  0,					:dGoqty,				:dInqty,				'외주',				'N',
		  '2',				substr(:sIojpno, 3, 10),				substr(:sIojpno, 3, 10),			
		  :sVendor,			null,
		  null,				:sOpseq,				:sLastc,				:sDe_Lastc,			'N',
		  :sIojpno,			:sShpipno,        :gs_userid );
		  
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업실적작성", "작업실적 작성을 실패하였읍니다", stopsign!)
		return -1
	End if	
	
	dw_list.SetItem(lRow, "imhist_jakjino", sPordno)		// 작업지시번호
	dw_list.SetItem(lRow, "imhist_jaksino", sShpjpno)	// 작업실적번호	
	
end if

return 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. 출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////
string	sJpno, snull, sstockgubun, saleyn, sIogbn, sError, sWigbn, siojpno, sOpseq
long		lRow
decimal {3} dbuqty, djoqty

setnull(snull)
lrow = dw_list.getrow()

if dw_list.getitemstring(lrow, "gubun") = 'N' then
	messagebox("확 인", "삭제할 수 없습니다. 자료를 확인하세요.")
	return -1
end if	

sJpno = dw_list.GetItemString(lrow, "imhist_iojpno")
sStockGubun  = dw_list.GetItemString(lRow, "imhist_filsk")			// 재고관리구분

DELETE FROM IMHIST  
 WHERE SABU    = :gs_sabu AND 
       IP_JPNO = :sJpno  AND
	  	 JNPCRT  = '008' ;

if sqlca.sqlcode < 0 then
	ROLLBACK;
	Messagebox("확 인", "수불내역 삭제시 오류 발생", information!)
	return -1
end if
	 
/* 불량및 조건부 내역을 check하여 수량이 있으면 불량내역도 삭제 */
dBuqty = dw_list.GetItemDecimal(lRow, "iocdqty_temp")				// 조건부수량
dJoqty = dw_list.GetItemDecimal(lRow, "iofaqty_temp")				// 불량수량	
If dBuqty > 0 or dJoqty > 0 then
	DELETE FROM "IMHFAT"  
	 WHERE "IMHFAT"."SABU" = :gs_sabu AND  
			 "IMHFAT"."IOJPNO" = :sJpno   ;
	if sqlca.sqlnrows < 1 then
		ROLLBACK;
		Messagebox("불량, 조건부내역", "불량내역 삭제시 오류 발생", information!)
		return -1
	end if
	
	DELETE FROM "IMHFAG"  
	 WHERE "IMHFAG"."SABU" = :gs_sabu AND  
			 "IMHFAG"."IOJPNO" = :sJpno   ;

	if sqlca.sqlcode < 0 then
		ROLLBACK;
		Messagebox("확 인", "조치내역 삭제시 오류 발생", information!)
		return -1
	end if
	
END IF

dw_list.setitem(lrow, "imhist_insdat", snull)
// 관리단위 기준
dw_list.SetItem(lRow, "imhist_iocdqty", 0)				// 조건부수량
dw_list.SetItem(lRow, "imhist_iofaqty", 0)				// 불량수량
dw_list.SetItem(lRow, "imhist_iosuqty", 0)				// 합격수량
dw_list.SetItem(lRow, "imhist_iopeqty", 0)				// 폐기수량
dw_list.SetItem(lRow, "imhist_iodeqty", 0)				// 파과수량
dw_list.SetItem(lRow, "imhist_silyoqty", 0)				// 시료수량
dw_list.SetItem(lRow, "imhist_gongqty", 0)				// 공제수량
dw_list.SetItem(lRow, "imhist_gongprc", 0)				// 공제단가
dw_list.SetItem(lRow, "imhist_decisionyn", snull)     // 합불판정
dw_list.SetItem(lRow, "imhist_jaksino",    snull)     // 작업실적번호 

// 발주단위 기준
dw_list.SetItem(lRow, "imhist_cnviocd", 0)				// 조건부수량
dw_list.SetItem(lRow, "imhist_cnviofa", 0)				// 불량수량
dw_list.SetItem(lRow, "imhist_cnviosu", 0)				// 합격수량
dw_list.SetItem(lRow, "imhist_cnviope", 0)				// 폐기수량
dw_list.SetItem(lRow, "imhist_cnviode", 0)				// 파괴수량
dw_list.SetItem(lRow, "imhist_cnvgong", 0)				// 공제수량

// 승인여부
saleyn 			= dw_list.GetItemString(lRow, "imhist_io_confirm")

if saleyn = 'Y' then // 자동승인전표인 경우
	dw_list.setitem(lrow, "imhist_ioqty", 0)
	dw_list.setitem(lrow, "imhist_ioamt", 0)			
	dw_list.SetItem(lRow, "imhist_io_date",  sNull)		// 수불승인일자=입고의뢰일자
	dw_list.SetItem(lRow, "imhist_io_empno", sNull)		// 수불승인자=NULL			
end if

// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// 입고번호
sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
IF sOpseq <> '9999' Then
	
	if wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sNull, 'D') = -1 then
		return -1
	end if
		  
END IF
			
/* 입고형태가 외주인지 check	*/
siogbn = dw_list.GetItemString(Lrow, "imhist_iogbn")	
Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	f_message_chk(311,'[외주여부]')
	return -1
end if

/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 생성 
	-. 단 검사일자가 있는 경우에 한 함*/
if sWigbn = 'Y' Then
	sError 	= 'X';
	sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")
	sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
	if sError = 'X' or sError = 'Y' then
		f_message_chk(41, '[외주자동출고]')
		Rollback;
		return -1
	end if;		
end if;		

RETURN 1
end function

public function integer wf_initial ();string snull

setnull(snull)

dw_detail.setredraw(false)

dw_list.reset()
dw_imhist_out.reset()

p_mod.enabled = false
p_del.enabled = false
dw_detail.enabled = TRUE
////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	then
	dw_detail.settaborder("insdate", 70)
	dw_detail.Modify("insdate_t.Visible= 1") 
	dw_detail.Modify("insdate.Visible= 1") 
	dw_detail.SetItem(1, "insdate", is_today)
	dw_detail.Modify("sdate_t.text= '입고일자'") 
	
	w_mdi_frame.sle_msg.text = "검사의뢰"
ELSE
	dw_detail.Modify("insdate_t.Visible= 0") 
	dw_detail.Modify("insdate.Visible= 0") 
	dw_detail.settaborder("insdate", 0)
	dw_detail.Modify("sdate_t.text= '검사일자'") 
	w_mdi_frame.sle_msg.text = "검사결과"
END IF
dw_detail.SetItem(1, "sdate", is_today)
dw_detail.SetItem(1, "edate", is_today)
dw_detail.SetItem(1, "jpno",    sNull)
dw_detail.SetItem(1, "fcvcod",  sNull)
dw_detail.SetItem(1, "tcvcod",  sNull)
dw_detail.SetItem(1, "fcvnm",   sNull)
dw_detail.SetItem(1, "tcvnm",   sNull)
dw_detail.SetItem(1, "empno",   sNull)

dw_detail.setcolumn("sdate")
dw_detail.setfocus()

dw_detail.setredraw(true)

return  1

end function

public subroutine wf_modify_gubun ();//////////////////////////////////////////////////////////////////////
// 1. 검사결과내역
//	2. 수불승인된 내역은 수정불가
//	3. 수불승인자 = NULL 인내역은 수정가능
//////////////////////////////////////////////////////////////////////
string	sConfirm, sEmpno
long		lRow 

FOR lRow = 1	TO		dw_list.RowCount()

	sConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
	sEmpno   = dw_list.GetItemString(lRow, "imhist_io_empno")
	dw_list.setitem(lrow, "iofaqty_temp", dw_list.getitemdecimal(lrow, "imhist_iofaqty"))
	dw_list.setitem(lrow, "iocdqty_temp", dw_list.getitemdecimal(lrow, "imhist_iocdqty"))
	dw_list.SetItem(lRow, "gubun", 'Y')	

	/* 수동 승인된 내역은 수정불가 */
	IF ( sConfirm = 'N' ) and	Not IsNull(sEmpno)	THEN
		dw_list.SetItem(lRow, "gubun", 'N')							// 수정불가
	END IF
	
	/* 특채요청된 내역은 수정불가 
		-. 특채요청은 검사이후에 발생함	*/
	IF dw_list.getitemdecimal(lrow, "imhist_tukqty") > 0 then
		dw_list.SetItem(lRow, "gubun", 'N')							// 수정불가
	END IF
		

NEXT

dw_list.accepttext()
end subroutine

public function integer wf_checkrequiredfield ();////////////////////////////////////////////////////////////////////////////
string	sQcDate, sIndate, 	&
			sGubun,		&
			sStockGubun,	sPordno, get_pdsts,	&
			sConfirm,	&
			sVendor,		&
			sEmpno,		&
			sNull,		sIogbn, sQcgub, sItnbr, sOpseq, sCvcod, sQcgub1, sEpno, sEpno1, sIojpno
long		lRow, lRowOut, lRowCount
dec {2}	 dOutSeq, dShpseq, dShpipgo
dec {3}  	dBadQty, dIocdQty,dQty,	dCnvqty	,  diopeqty, diodeqty, dCnvBad, dCnviocd, dcnviope, dcnviode
SetNull(sNull)

sQcDate = dw_detail.GetItemString(1, "insdate")
sEmpno  = dw_detail.GetItemString(1, "empno")

lRowCount = dw_list.RowCount()
/* 공정이 '9999'가 아니면 작업실적 전표번호를 생성 */
FOR	lRow = 1		TO		lRowCount
	
	sGubun = dw_list.GetItemString(lRow, "gubun")

	IF sGubun = 'N'	THEN 
		dw_list.SetItemStatus(lrow, 0, Primary!, NotModified!)
		CONTINUE /* 미검사내역은 skip */	
	END IF

	if dw_list.getitemstring(lrow, "imhist_opseq") <> '9999' then
		/* 작업실적 전표번호 */
		dShpSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'N1')
		IF dShpSeq < 1		THEN
			ROLLBACK;
			f_message_chk(51,'[작업실적번호]')
			RETURN -1
		END IF
		/* 작업실적에 의한 입고번호 */
		dShpipgo = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'C0')
		IF dShpipgo < 1	THEN
			ROLLBACK;
			f_message_chk(51,'[작업실적에 의한 입고번호]')
			RETURN -1
		END IF			
		Exit	
	End if
Next

COMMIT;

/* 수불구분 (구매입고후 자동출고)	*/
Select iogbn into :sIogbn from iomatrix where sabu = :gs_sabu and maiaut = 'Y';
If sqlca.sqlcode <> 0 then 
	f_message_chk(33,'[구매입고후 자동출고]')	
	return -1
end if

FOR lRow = 1	TO		lRowCount

		sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// 입고번호
		dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
		dIocdQty= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
		sStockGubun  = dw_list.GetItemString(lRow, "imhist_filsk")			// 재고관리구분
		
		sGubun = dw_list.GetItemString(lRow, "gubun")
		IF sGubun = 'N'	THEN CONTINUE /* 미검사내역은 skip */
		
		/* 검사내역 또는 담당자가 변경된 경우에는 단가마스터, 품목마스터의 검사구분을 update */
		sQcgub  	= dw_list.getitemstring(lrow, "save_gub")
		sQcgub1 	= dw_list.getitemstring(lrow, "imhist_qcgub")		
		sEpno  	= dw_list.getitemstring(lrow, "save_emp")
		sEpno1 	= dw_list.getitemstring(lrow, "imhist_insemp")
		if sQcgub <> sQcgub1 or sEpno <> sEpno1 then
			sItnbr = dw_list.getitemstring(lRow, "imhist_itnbr")
			sOpseq = dw_list.getitemstring(lRow, "imhist_opseq")			
			sCvcod = dw_list.getitemstring(lRow, "imhist_cvcod")
			
			Update danmst set qcgub = :sQcgub1, qcemp = :sEpno1
			 Where itnbr = :sItnbr And opseq = :sOpseq And cvcod = :sCvcod;
			 
			if sqlca.sqlnrows < 1 then
				Messagebox("단가마스터", "단가마스터의 검사변경이 안되었읍니다", stopsign!)
				rollback;
				return -1
			end if

			Update itemas Set qcgub  = :sQcgub1, qcemp = :sEpno1
			 Where itnbr = :sitnbr;
			 
			if sqlca.sqlnrows < 1 then
				Messagebox("품목마스터", "품목마스터의 검사변경이 안되었읍니다", stopsign!)
				rollback;
				return -1
			end if
			 
		end if
		
		IF dIocdQty + dBadQty > 0		THEN	
			dw_list.SetItem(lRow, "gubun", 'Y')
			gs_Code = dw_list.GetItemString(lRow, "imhist_iojpno")
			gi_Page = dBadQty
			
			str_01040.sabu 	= gs_sabu
			str_01040.iojpno	= dw_list.getitemstring(lRow, "imhist_iojpno")
			str_01040.itnbr	= dw_list.getitemstring(lRow, "imhist_itnbr")
			str_01040.itdsc	= dw_list.getitemstring(lRow, "itemas_itdsc")
			str_01040.ispec	= dw_list.getitemstring(lRow, "itemas_ispec")
			str_01040.ioqty	= dw_list.getitemDecimal(lRow, "imhist_ioreqty")
			str_01040.buqty	= dw_list.getitemDecimal(lRow, "imhist_iofaqty")
			str_01040.joqty	= dw_list.getitemDecimal(lRow, "imhist_iocdqty")
			str_01040.siqty	= dw_list.getitemDecimal(lRow, "siqty")
			str_01040.rowno	= lrow
			str_01040.dwname  = dw_list
			str_01040.gubun   = 'Y' //수입검사구분
			Openwithparm(w_qct_01050, str_01040)
		END IF
		
		dw_list.accepttext()
		dIocdQty= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
		diopeQty = dw_list.GetItemDecimal(lRow, "imhist_iopeqty")			// 폐기수량
		diodeQty = dw_list.GetItemDecimal(lRow, "imhist_iodeqty")			// 파괴수량
		sindate = dw_list.GetItemString(lRow, "imhist_sudat")
		
		// 발주단위 기준수량
		dCnvQty 	= dw_list.GetItemDecimal(lRow, "imhist_cnviore")				// 입고수량
		dCnvIocd = dw_list.GetItemDecimal(lRow, "imhist_cnviocd")				// 조건부수량
		dCnvBad  = dw_list.GetItemDecimal(lRow, "imhist_cnviofa")				// 불량수량
		dCnviope = dw_list.GetItemDecimal(lRow, "imhist_cnviope")				// 폐기수량
		dCnviode = dw_list.GetItemDecimal(lRow, "imhist_cnviode")				// 파괴수량
		
		dw_list.SetItem(lRow, "imhist_insdat",  sQcDate)			// 검사일자
		dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - diopeqty - diodeqty)	 // 합격 = 입고의뢰 - 불량(관리단위) - 폐기 - 파괴
		dw_list.SetItem(lRow, "imhist_cnviosu", dCnvQty - dCnvBad - dcnviope - dcnviode) // 합격 = 입고의뢰 - 불량(발주단위) - 폐기

		dw_list.SetItem(lRow, "imhist_silyoqty", &
		                      dw_list.GetItemDecimal(lRow, "siqty")) // 시료수량

		string	sVendorGubun, sSaleYN
		sVendor = dw_list.GetItemString(lRow, "imhist_depot_no")
		sSaleyn = dw_list.GetItemString(lRow, "imhist_io_confirm")
		
		IF sSaleYn = 'Y' or  sstockgubun = 'N' then  				// 수불자동승인인 경우 또는 재고관리 대상인 아닌것
			dw_list.SetItem(lRow, "imhist_io_date",  sQcDate)		// 수불승인일자=입고의뢰일자
			dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
			dw_list.setitem(lrow, "imhist_ioqty",  dQty - dBadqty - diopeqty - diodeqty)
			dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_list.getitemdecimal(lrow, "ioprc"), 0))
			//금액은 폐기수량을 빼지 않음
		END IF		 
		
	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' Then
		dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_list.getitemdecimal(lrow, "ioprc"), 0))
		if wf_shpact(Lrow, Lrow, sQcDate, dShpseq, sIojpno, sOpseq, dShpipgo, Sempno, sVendor, 'I') = -1 then
			rollback;
			return -1
		end if
			  
		CONTINUE

	END IF		

	/////////////////////////////////////////////////////////////////////////////////////
	// 출고전표 생성 : 전표생성구분('008')
	/////////////////////////////////////////////////////////////////////////////////////
	IF sStockGubun = 'N' then
		dOutSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'C0')
		IF dOutSeq < 0		THEN	
			rollback;
			f_Rollback()
			RETURN -1
		end if
	
		lRowOut = dw_imhist_out.InsertRow(0)
	
		dw_imhist_out.SetItem(lRowOut, "sabu",		gs_Sabu)
		dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// 전표생성구분
		dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// 입출고구분
		dw_imhist_out.SetItem(lRowOut, "iojpno", 	sQcDate + string(dOutSeq, "0000") + '001')
		dw_imhist_out.SetItem(lRowOut, "iogbn",   'O23') 			// 수불구분
		dw_imhist_out.SetItem(lRowOut, "sudat",	sQcDate)			// 수불일자=입고일자
		dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_list.GetItemString(lRow, "imhist_itnbr")) // 품번
		dw_imhist_out.SetItem(lRowOut, "pspec",	dw_list.GetItemString(lRow, "imhist_pspec")) // 사양
		dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// 공정순서
		dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// 기준창고=입고처
		dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// 거래처창고=입고처
		dw_imhist_out.SetItem(lRowOut, "ioqty",   dQty - dBadqty - diopeqty - diodeqty)			// 수불수량=입고수량
		dw_imhist_out.SetItem(lRowOut, "ioreqty",	dQty - dBadqty - diopeqty - diodeqty) 			// 수불의뢰수량=입고수량		
		dw_imhist_out.SetItem(lRowOut, "insdat",	sQcDate) 					// 검사일자=입고일자
		dw_imhist_out.SetItem(lRowOut, "iosuqty", dQty - dBadqty - diopeqty - diodeqty)			// 합격수량=입고수량

		dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// 수불승인자
		dw_imhist_out.SetItem(lRowOut, "io_confirm", 'Y')			// 수불승인여부
		dw_imhist_out.SetItem(lRowOut, "io_date", sQcDate)			// 수불승인일자=입고일자
		dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// 재고관리구분
		dw_imhist_out.SetItem(lRowOut, "bigo",  '구매입고 동시출고분')
		dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// 동시출고여부
		dw_imhist_out.SetItem(lRowOut, "ip_jpno", dw_list.GetItemString(lRow, "imhist_iojpno")) 					// 입고전표번호
		dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// 수불의뢰담당자=입고의뢰담당자

	END IF

NEXT


IF dw_list.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
	return -1
END IF

IF dw_imhist_out.Update() <> 1	THEN
	ROLLBACK;
	f_Rollback()
	return -1	
END IF

if wf_waiju() = -1 then 
	rollback;
	return -1
end if

	
RETURN 1
end function

public function integer wf_check ();////////////////////////////////////////////////////////////////////////////
string	sGubun,	sPordno, get_pdsts,	sDecision
long		lRow, lRowCount, k
Dec      dBadQty

lRowCount = dw_list.RowCount()

FOR	lRow = 1		TO		lRowCount
	
		sGubun = dw_list.GetItemString(lRow, "gubun")		

		IF sGubun = 'N'	THEN 
			CONTINUE /* 미검사내역은 skip */	
		END IF

      k++
		
		sdecision = dw_list.getitemstring(lrow, "imhist_decisionyn")
		
		if isnull(sdecision) or sdecision = '' then
			messagebox('확 인', '합불판정을 선택하세요!') 
			dw_list.ScrollToRow(lRow)
			dw_list.setcolumn("imhist_decisionyn")
			dw_list.setfocus()
			return -1
		//--불 합격 판정일 경우 - 불합격 수량이 존재해야 함.
		elseif sdecision = 'N' then 
			
			dBadQty = dw_list.GetItemDecimal(lRow, 'imhist_iofaqty')
			
			if dBadQty <= 0 then 
				MessageBox(' [불합격 판정!] ', '불합격 수량을 확인하세요! ',Information!)
				dw_list.ScrollToRow(lRow)
				dw_list.setcolumn("imhist_iofaqty")
				dw_list.SetRow(lRow)
				dw_list.setfocus()
				return -1
			end if
		end if	

		
		//발주에 작업지시 no가 있으면 작업지시를 읽어서 상태가 '1', '2' 인 자료만 들어올 수 있음
		sPordno = dw_list.getitemstring(lrow, 'poblkt_pordno')
		if not (sPordno = '' or isnull(sPordno)) then 
			SELECT "MOMAST"."PDSTS"  
			  INTO :get_pdsts  
			  FROM "MOMAST"  
			 WHERE ( "MOMAST"."SABU"   = :gs_sabu ) AND  
					 ( "MOMAST"."PORDNO" = :sPordno )   ;
					 
			if not (get_pdsts = '1' or get_pdsts = '2') then 
				messagebox("확 인", "수입검사 처리를 할 수 없습니다. " + "~n~n" + &
										  "작업지시에 지시상태가 지시/재생산지시만 수입검사가 가능합니다.")
				dw_list.ScrollToRow(lRow)
				dw_list.setfocus()
				return -1
			end if	
	
		end if
Next

if k < 1 then 
	messagebox('확 인', '처리할 자료를 선택하세요!') 
	dw_list.setfocus()
	return -1
end if

RETURN 1
end function

public function integer wf_update ();string	sStockGubun,	&
			sVendorGubun,	&
			sVendor,			&
			sJpno,			&
			sGubun,			&
			sNull, sconfirm, saleyn, sOpseq, sDecisionyn, sDecisionyn_temp
String   siogbn, sIojpno, sError, sWigbn				
long		lRow
dec{3}	dIocdQty, dIocdQty_Temp,		&
			dBadQty, dBadQty_Temp,		&
			dQty, dSpqty, diopeqty, diopeqty_temp, diodeqty, diodeqty_temp
dec{5}	dgongprc, dgongprc_Temp
			
SetNull(sNull)

FOR lRow = 1	TO		dw_list.RowCount()

		sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// 입고번호
		dQty 	   		= dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
		dIocdQty			= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
		dIocdQty_Temp 	= dw_list.GetItemDecimal(lRow, "iocdqty_temp")					// 조건부수량
		dBadQty 			= dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
		dBadQty_Temp 	= dw_list.GetItemDecimal(lRow, "iofaqty_temp")					// 불량수량
		diopeQty  		= dw_list.GetItemDecimal(lRow, "imhist_iopeqty")				// 폐기수량
		diopeQty_TEMP	= dw_list.GetItemDecimal(lRow, "iopeqty_temp")	   			// 폐기수량
		diodeQty  		= dw_list.GetItemDecimal(lRow, "imhist_iodeqty")				// 파괴수량
		diodeQty_TEMP	= dw_list.GetItemDecimal(lRow, "imhist_iodeqty_temp")	   			// 파괴수량

		dgongprc  		= dw_list.GetItemDecimal(lRow, "imhist_gongprc")
		dgongprc_TEMP	= dw_list.GetItemDecimal(lRow, "gongprc_temp")	
		
		sDecisionyn  	= dw_list.GetItemString(lRow, "imhist_decisionyn")	
		sDecisionyn_temp 	= dw_list.GetItemString(lRow, "decisionyn_temp")	
		
		IF (dIocdQty <> dIocdQty_temp) or (dBadQty <> dBadQty_Temp)	or &
			(dIopeQty <> dIopeQty_temp) or (dIodeQty <> dIodeQty_temp) or (dgongprc <> dBadQty_Temp) or &
  	      (sDecisionyn  <> sDecisionyn_Temp)		THEN	
			IF (dIocdQty <> dIocdQty_temp) or (dBadQty <> dBadQty_Temp)		THEN	
				gs_Code = dw_list.GetItemString(lRow, "imhist_iojpno")
				gi_Page = dBadQty
				
				str_01040.sabu 	= gs_sabu
				str_01040.iojpno	= dw_list.getitemstring(lRow, "imhist_iojpno")
				str_01040.itnbr	= dw_list.getitemstring(lRow, "imhist_itnbr")
				str_01040.itdsc	= dw_list.getitemstring(lRow, "itemas_itdsc")
				str_01040.ispec	= dw_list.getitemstring(lRow, "itemas_ispec")
				str_01040.ioqty	= dw_list.getitemDecimal(lRow, "imhist_ioreqty")
				str_01040.buqty	= dw_list.getitemDecimal(lRow, "imhist_iofaqty")
				str_01040.joqty	= dw_list.getitemDecimal(lRow, "imhist_iocdqty")
				str_01040.siqty	= dw_list.getitemDecimal(lRow, "imhist_silyoqty")
				str_01040.rowno	= lrow			
				str_01040.dwname  = dw_list
				str_01040.gubun   = 'Y' //수입검사구분
				Openwithparm(w_qct_01050, str_01040)			
         END IF 
			
			dw_list.accepttext()
			dIocdQty			= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
			dBadQty 			= dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
			
			if sDecisionyn = 'Y' then 
//				if dBadQty > 0 or dIocdQty > 0 then 
//					MessageBox(' [합격 판정!] ', '불량수량/조건부수량을 확인하세요! ',Information!)
//					dw_list.ScrollToRow(lRow)
//					dw_list.setcolumn("imhist_iofaqty")
//					dw_list.SetRow(lRow)
//					dw_list.setfocus()
//					return -1
//				end if
			elseif sDecisionyn = 'N' then 
				if dBadQty <= 0 then 
					MessageBox(' [불합격 판정!] ', '불량수량을 확인하세요! ',Information!)
					dw_list.ScrollToRow(lRow)
					dw_list.setcolumn("imhist_iofaqty")
					dw_list.SetRow(lRow)
					dw_list.setfocus()
					return -1
				end if
			end if 

			dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - dIopeqty - diodeqty)	// 합격 = 입고의뢰 - 불량

			// 출고전표번호 수정	
			sVendor = dw_list.GetItemString(lRow, "imhist_depot_no")
			sStockGubun  = dw_list.GetItemString(lRow, "imhist_filsk")			// 재고관리구분
			sJpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
			saleyn = dw_list.GetItemString(lRow, "imhist_io_confirm")
			
			// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
			// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
			sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
			IF sOpseq <> '9999' Then
				dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_list.getitemdecimal(lrow, "imhist_ioprc"),0))				
				CONTINUE		
			END IF					
			
			if saleyn = 'Y' then // 자동승인전표인 경우
				dw_list.setitem(lrow, "imhist_ioqty", dQty - dBadqty - dIopeqty - diodeqty)
				dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_list.getitemdecimal(lrow, "imhist_ioprc"), 0))
			end if

			if sstockgubun = 'N' then
			  UPDATE "IMHIST"  
			     SET "IOQTY"   = :dQty - :dBadqty - :dIopeqty - :diodeqty,   
         			"IOREQTY" = :dQty - :dBadqty - :dIopeqty - :diodeqty,   
			         "IOSUQTY" = :dQty - :dbadqty - :dIopeqty - :diodeqty,   
			         "UPD_USER" = :gs_userid 
				WHERE "SABU"    = :gs_sabu	AND
						"IP_JPNO" = :sJpno	AND
						"JNPCRT"  = '008' ;

				if sqlca.sqlcode < 0 then
					ROLLBACK;
					Messagebox("확 인", "수불자료 변경시 오류 발생", information!)
					return -1
				end if
			End if
	   ELSE
			dw_list.SetItemStatus(lrow, 0, Primary!, NotModified!)
		END IF
		
NEXT

IF dw_list.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
	return -1
END IF
	
if wf_waiju() = -1 then 
	ROLLBACK;
	return -1
end if

For Lrow = 1 to dw_list.rowcount()
	sVendor = dw_list.GetItemString(lRow, "imhist_depot_no")	
	sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// 입고번호	
	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' Then
		if wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sVendor, 'U') = -1 then
			rollback;
			return -1
		end if
	END IF						
Next

return 1
end function

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

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

// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist_out.settransobject(sqlca)

//합/불 판정
SELECT DATANAME  
  into :is_syscnfg
  FROM SYSCNFG   
 WHERE SYSGU  = 'Y' 
   AND SERIAL = 13 
   AND LINENO = '4' ;

if isnull(is_syscnfg) or is_syscnfg = '' or is_syscnfg = '1' then 
	is_syscnfg = '1' //사용자 직접 입력
else
	is_syscnfg = '2' //불량이 있는 경우 불량 판정 
end if

//dw_imhist.settransobject(sqlca)

dw_detail.InsertRow(0)

// commandbutton function
p_can.TriggerEvent("clicked")


end event

on w_qct_01040.create
this.p_list=create p_list
this.p_1=create p_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.dw_imhist_out=create dw_imhist_out
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_list,&
this.p_1,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.dw_imhist_out,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.dw_list,&
this.rr_1,&
this.rr_2}
end on

on w_qct_01040.destroy
destroy(this.p_list)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.dw_imhist_out)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
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

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

type p_list from uo_picture within w_qct_01040
integer x = 3721
integer y = 12
integer width = 178
integer taborder = 50
string picturename = "C:\erpman\image\검사이력보기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String scvcod, sItnbr

if dw_list.getrow() > 0 then
	gs_code		= dw_list.getitemstring(dw_list.getrow(), "imhist_itnbr")
	gs_codename	= dw_list.getitemstring(dw_list.getrow(), "imhist_cvcod")
	open(w_qct_01040_1)
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\검사이력보기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\검사이력보기_up.gif"
end event

type p_1 from uo_picture within w_qct_01040
boolean visible = false
integer x = 41
integer y = 8
integer width = 178
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event clicked;call super::clicked;gs_code = '수입검사 완료 통보'
//gs_codename = '품목명 :~r~n~r~n규격 :~r~n~r~n비고 :'
gs_codename = ''
//gs_gubun = 'w_qct_01040'
SetNull(gs_gubun)
Open(w_mail_insert)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

type p_exit from uo_picture within w_qct_01040
integer x = 4416
integer y = 12
integer width = 178
integer taborder = 90
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qct_01040
integer x = 4242
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_qct_01040
integer x = 4069
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

if dw_list.accepttext() = -1 then return 

if dw_list.rowcount() < 1 then return 
if dw_list.getrow() < 1 then 
	messagebox("확 인", "삭제할 자료를 선택하세요.")
   return 
end if

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	
	ROLLBACK;
	return 
END IF

IF dw_list.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
END IF

COMMIT;

p_inq.TriggerEvent("clicked")
	
	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_qct_01040
integer x = 3895
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sNull
SetPointer(HourGlass!)

IF dw_list.RowCount() < 1		THEN	RETURN
IF dw_list.AcceptText() = -1	THEN	RETURN

IF ic_status = '1'	THEN
	IF wf_Check() = -1	THEN	return 
	
	IF f_msg_update() = -1 	THEN	RETURN

	IF wf_CheckRequiredField() = -1	THEN	
		rollback;
		RETURN
	end if

	commit;
	
	p_1.TriggerEvent(Clicked!)
ELSE
	IF f_msg_update() = -1 	THEN	RETURN
	
	if wf_Update() = -1 then 
		rollback;
		return
	end if
	
	commit;

END IF

/////////////////////////////////////////////////////////////////////////////

p_can.TriggerEvent("clicked")

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_qct_01040
integer x = 3374
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF dw_detail.AcceptText() = -1	THEN	RETURN
/////////////////////////////////////////////////////////////////////////
string	sDate, eDate, scvcod, ecvcod, sQcDate, sJpno, sEmpno, sroslt

sDate = TRIM(dw_detail.GetItemString(1, "sdate"))
eDate = TRIM(dw_detail.GetItemString(1, "edate"))
sQcDate = TRIM(dw_detail.GetItemString(1, "insdate"))
sJpno   = Trim(dw_detail.GetItemString(1, "jpno"))
sEmpno  = dw_detail.GetItemString(1, "empno")
scvcod  = dw_detail.GetItemString(1, "fcvcod")
ecvcod  = dw_detail.GetItemString(1, "tcvcod")
sroslt  = trim(dw_detail.GetItemString(1, "roslt"))

IF isnull(sDate) or sDate = "" 	THEN
	IF ic_status = '1'	THEN
		f_message_chk(30,'[입고일자]')
	ELSE	
		f_message_chk(30,'[검사일자]')
	END IF
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF
IF isnull(eDate) or eDate = "" 	THEN
	IF ic_status = '1'	THEN
		f_message_chk(30,'[입고일자]')
	ELSE	
		f_message_chk(30,'[검사일자]')
	END IF
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

IF (isnull(sQcDate) or sQcDate = "") and ic_status = '1'	THEN
	f_message_chk(30,'[검사일자]')
	dw_detail.SetColumn("insdate")
	dw_detail.SetFocus()
	RETURN
END IF

// 전표번호
IF isnull(sJpno) or sJpno = "" 	THEN
	sJpno = '%'
ELSE
	sJpno = sJpno + '%'
END IF

IF isnull(sempno) or sempno = "" 	THEN sempno = '%'
IF isnull(scvcod) or scvcod = "" 	THEN scvcod = '.'
IF isnull(ecvcod) or Ecvcod = "" 	THEN ecvcod = 'zzzzzz'

SetPointer(HourGlass!)	

if isnull(sroslt) or sroslt = '' then 
	dw_list.setfilter("")
else
	dw_list.setfilter("morout_roslt = '"+ sroslt +" '")
end if
dw_list.Filter()

//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN	
	IF	dw_list.Retrieve(gs_Sabu, sJpno, sDate, edate, sEmpno, scvcod, ecvcod, is_syscnfg) <	1		THEN
		f_message_chk(50, '[검사의뢰내역]')
		dw_detail.setcolumn("sdate")
		dw_detail.setfocus()
		RETURN
	END IF
ELSE
	IF	dw_list.Retrieve(gs_Sabu, sDate, eDate, sEmpno, sjpno, scvcod, ecvcod, is_syscnfg) <	1		THEN
//		f_message_chk(50, '[검사결과내역]')
		dw_detail.setcolumn("sdate")
		dw_detail.setfocus()
		RETURN
	END IF

	wf_Modify_Gubun()
	p_del.enabled = true
	
END IF
//////////////////////////////////////////////////////////////////////////

dw_list.SetFocus()
dw_detail.enabled = false

p_mod.enabled = true


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type dw_imhist_out from datawindow within w_qct_01040
string tag = "seq =~' ~' "
boolean visible = false
integer x = 667
integer y = 2316
integer width = 494
integer height = 212
integer taborder = 100
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event updatestart;///* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
end event

type rb_delete from radiobutton within w_qct_01040
integer x = 4187
integer y = 260
integer width = 347
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = " "
long textcolor = 8388608
long backcolor = 33027312
string text = "검사결과"
end type

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_qct_01043'
dw_list.SetTransObject(sqlca)

wf_initial()


end event

type rb_insert from radiobutton within w_qct_01040
integer x = 4187
integer y = 188
integer width = 347
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "검사의뢰"
boolean checked = true
end type

event clicked;
ic_status = '1'

dw_list.DataObject = 'd_qct_01042'
dw_list.SetTransObject(sqlca)

wf_initial()


end event

type dw_detail from datawindow within w_qct_01040
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 160
integer width = 4091
integer height = 196
integer taborder = 10
string dataobject = "d_qct_01040"
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

event itemchanged;string	sDate, sNull, sjpno, sempno, scode, sname, sname2 
int      ireturn 

SetNull(sNull)

IF this.GetColumnName() = 'sdate' THEN
	sDate  = TRIM(this.gettext())
	
	if sDate = '' or isnull(sDate) then return 
	
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[시작일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN
	sDate  = TRIM(this.gettext())
	
	if sDate = '' or isnull(sDate) then return 
	
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[종료일자]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'insdate' THEN
	sDate  = TRIM(this.gettext())
	
	if sDate = '' or isnull(sDate) then return 
	
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[검사일자]')
		this.setitem(1, "insdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'jpno'	THEN

	sJpno = trim(this.GetText())
	
	if sJpno = '' or isnull(sJpno) then return 
	
	SELECT A.INSEMP, A.INSDAT
	  INTO :sEmpno, :sDate
	  FROM IMHIST A
	 WHERE A.SABU = :gs_Sabu			AND
	 		 A.IOJPNO like :sJpno||'%'		AND
			 A.JNPCRT = '007'  and rownum = 1;
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[입고번호]')
		this.setitem(1, "jpno", sNull)
		RETURN 1
	END IF

	if len(sJpno) = 12 and ic_status = '2' then 
		this.setitem(1, "empno", sempno)
		this.setitem(1, "edate", sdate)
		this.setitem(1, "sdate", sdate)
   end if	
ELSEIF this.GetcolumnName() = 'fcvcod'	THEN
	sCode = this.GetText()								
	if scode = '' or isnull(scode) then
   	this.setitem(1, "fcvnm", snull)	
		return 
	end if
	ireturn = f_get_name2('V0', 'N', sCode, sName, sName2)    //1이면 실패, 0이 성공	
	this.setitem(1, "fcvcod", scode)	
	this.setitem(1, "fcvnm", sname)	
	RETURN ireturn
ELSEIF this.GetcolumnName() = 'tcvcod'	THEN
	sCode = this.GetText()								
	if scode = '' or isnull(scode) then
   	this.setitem(1, "tcvnm", snull)	
		return 
	end if
	ireturn = f_get_name2('V0', 'N', sCode, sName, sName2)    //1이면 실패, 0이 성공	
	this.setitem(1, "tcvcod", scode)	
	this.setitem(1, "tcvnm", sname)	
	RETURN ireturn
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'jpno'	THEN

	gs_gubun = '007'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")

ELSEIF this.GetColumnName() = 'fcvcod'	THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"fcvcod",		gs_code)
	SetItem(1,"fcvnm",  gs_codename)
ELSEIF this.GetColumnName() = 'tcvcod'	THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"tcvcod",	gs_code)
	SetItem(1,"tcvnm",  gs_codename)
END IF
end event

type dw_list from datawindow within w_qct_01040
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 380
integer width = 4530
integer height = 1916
integer taborder = 30
string dataobject = "d_qct_01043"
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

event itemerror;RETURN 1
	
	
end event

event itemchanged;String sData, sIttyp, sOpseq, sItnbr, sCvcod, sDecision
long	lRow
dec {3}	dBadQty, dQty, dCdqty, dSiqty, diopeqty, diodeqty, dGongqty
dec {3}  dgongprc
lRow = this.GetRow()
this.accepttext()

IF this.GetColumnName() = 'imhist_iofaqty'	Then
	
	dBadQty = this.GetItemDecimal(lRow, "imhist_iofaqty")	
	
	if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
		this.setitem(Lrow, "imhist_cnviofa", dBadqty)
	elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
		this.setitem(Lrow, "imhist_cnviofa", Round(dBadqty / getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	else
		this.setitem(Lrow, "imhist_cnviofa", Round(dBadqty * getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	end if		
	
	dQty     = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dCdQty   = this.GetItemDecimal(lRow, "imhist_iocdqty")		
	diopeQty = this.GetItemDecimal(lRow, "imhist_iopeqty")
	diodeQty = this.GetItemDecimal(lRow, "imhist_iodeqty")
	
	IF dBadQty + dCdqty + diopeqty + diodeqty > dQty		THEN
		MessageBox("확인", "불량수량 + 조건부수량 + 폐기수량은 입고의뢰수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_cnviofa", 0)
		this.SetItem(lRow, "imhist_iofaqty", 0)
		this.SetItem(lRow, "imhist_gongqty", 0)
		this.SetItem(lRow, "imhist_gongprc", 0)
		this.SetItem(lRow, "imhist_cnvgong", 0)
		//합불판정
		if is_syscnfg = '2' then  //불량수량으로 처리시 
			this.SetItem(lRow, "imhist_decisionyn", '')
		end if
		RETURN 1
	END IF

	//합불판정
	if dbadqty > 0 and is_syscnfg = '2' then  //불량수량으로 처리시 
		this.SetItem(lRow, "imhist_decisionyn", 'N')
	end if
	
	// 불량수량이 0 이거나 공제수량보다 작을경우 공제수량도 0으로 한다.
	if dBadqty = 0 Or dBadqty < this.getitemdecimal(Lrow, "imhist_gongqty") then
		this.SetItem(lRow, "imhist_gongqty", 0)
		this.SetItem(lRow, "imhist_gongprc", 0)
		this.SetItem(lRow, "imhist_cnvgong", 0)		
	End if
	
elseIF this.GetColumnName() = 'imhist_iocdqty'	Then

	dQty    = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dBadQty = this.GetItemDecimal(lRow, "imhist_iofaqty")	
	dCdQty  = this.GetItemDecimal(lRow, "imhist_iocdqty")	
	diopeQty = this.GetItemDecimal(lRow, "imhist_iopeqty")
	diodeQty = this.GetItemDecimal(lRow, "imhist_iodeqty")
	
	if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
		this.setitem(Lrow, "imhist_cnviocd", dCdqty)
	elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
		this.setitem(Lrow, "imhist_cnviocd", Round(dCdqty / getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	else
		this.setitem(Lrow, "imhist_cnviocd", Round(dCdqty * getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	end if			

	IF dBadQty + dCdqty + diopeqty + diodeqty > dQty		THEN
		MessageBox("확인", "불량수량 + 조건부수량 + 폐기수량은 입고의뢰수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_cnviocd", 0)
		this.SetItem(lRow, "imhist_iocdqty", 0)
		RETURN 1
	END IF
// 폐기수량
elseIF this.GetColumnName() = 'imhist_iopeqty'	Then

	dQty    = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dBadQty = this.GetItemDecimal(lRow, "imhist_iofaqty")	
	dCdQty  = this.GetItemDecimal(lRow, "imhist_iocdqty")	
	diopeQty = this.GetItemDecimal(lRow, "imhist_iopeqty")
	diodeQty = this.GetItemDecimal(lRow, "imhist_iodeqty")
	
	if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
		this.setitem(Lrow, "imhist_cnviope", diopeQty)
	elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
		this.setitem(Lrow, "imhist_cnviope", Round(diopeQty / getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	else
		this.setitem(Lrow, "imhist_cnviope", Round(diopeQty * getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	end if			

	IF dBadQty + dCdqty + diopeqty + diodeqty > dQty		THEN
		MessageBox("확인", "불량수량 + 조건부수량 + 폐기수량은 입고의뢰수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_cnviope", 0)
		this.SetItem(lRow, "imhist_iopeqty", 0)
		RETURN 1
	END IF
// 파괴수량
elseIF this.GetColumnName() = 'imhist_iodeqty'	Then

	dQty    = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dBadQty = this.GetItemDecimal(lRow, "imhist_iofaqty")	
	dCdQty  = this.GetItemDecimal(lRow, "imhist_iocdqty")	
	diopeQty = this.GetItemDecimal(lRow, "imhist_iopeqty")
	diodeQty = this.GetItemDecimal(lRow, "imhist_iodeqty")
	
	if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
		this.setitem(Lrow, "imhist_cnviode", diodeQty)
	elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
		this.setitem(Lrow, "imhist_cnviode", Round(diodeQty / getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	else
		this.setitem(Lrow, "imhist_cnviode", Round(diodeQty * getitemdecimal(Lrow, "imhist_cnvfat"), 2))
	end if			

	IF dBadQty + dCdqty + diopeqty + diodeqty > dQty		THEN
		MessageBox("확인", "불량수량 + 조건부수량 + 폐기수량은 입고의뢰수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_cnviode", 0)
		this.SetItem(lRow, "imhist_iodeqty", 0)
		RETURN 1
	END IF
elseif this.getcolumnname() = 'imhist_qcgub' then /* 검사기준이 바뀌면 시료수량도 변경 */
	
	sdata = gettext()
	if sData = '1' then
		Messagebox("수입검사", "무검사는 선택할 수 없읍니다", stopsign!)
		this.setitem(lRow, "imhist_qcgub", '4')
			
		sData = '4'
		dQty    	= this.GetItemDecimal(lRow, "imhist_ioreqty")
		sIttyp	= this.getitemstring(lrow, "itemas_ittyp")
		dSiqty = sqlca.erp000000240(gs_sabu, sittyp, sData, dQty)
		
		this.setitem(lrow, "siqty", dSiqty)		
		
		
		return 1
	end if

	dQty    	= this.GetItemDecimal(lRow, "imhist_ioreqty")
	sIttyp	= this.getitemstring(lrow, "itemas_ittyp")
	dSiqty = sqlca.erp000000240(gs_sabu, sittyp, sData, dQty)
	
	this.setitem(lrow, "siqty", dSiqty)
	
Elseif this.getcolumnname() = 'imhist_gongqty' then /* 공제수량 - 불량수량 범위내에서만 입력가능함 */
	
	//공제단가, 수량 처리 
	dGongqty = dec(gettext())
	dBadqty  = this.getitemdecimal(Lrow, "imhist_iofaqty")
	
	If dGongqty > dBadqty Then
		MessageBox("공제수량", "공제수량은 불량수량 범위내에서만 입력이 가능합니다", stopsign!)
		this.SetItem(lRow, "imhist_gongqty", 0)
		this.SetItem(lRow, "imhist_gongprc", 0)
		this.SetItem(lRow, "imhist_cnvgong", 0)		
		Return 1		
	End if
	
	if dgongqty > 0 Then
		sitnbr = this.getitemstring(lrow, 'imhist_itnbr')
		scvcod = this.getitemstring(lrow, 'imhist_cvcod')
		
      SELECT NVL("DANMST"."GONPRC", 0)  
		  INTO :dgongprc
		  FROM "DANMST"  
		 WHERE ( "DANMST"."ITNBR" = :sitnbr ) AND  
				 ( "DANMST"."CVCOD" = :scvcod ) AND  
				 ( "DANMST"."OPSEQ" = :sopseq )   ;
		
		this.SetItem(lRow, "imhist_gongprc", dgongprc)
				
		if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
			this.setitem(Lrow, "imhist_cnvgong", dgongqty)
		elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
			this.setitem(Lrow, "imhist_cnvgong", Round(dgongqty / getitemdecimal(Lrow, "imhist_cnvfat"), 2))
		else
			this.setitem(Lrow, "imhist_cnvgong", Round(dgongqty * getitemdecimal(Lrow, "imhist_cnvfat"), 2))
		end if		
	else
		this.SetItem(lRow, "imhist_gongqty", 0)
		this.SetItem(lRow, "imhist_gongprc", 0)
		this.SetItem(lRow, "imhist_cnvgong", 0)
	end if	
elseif this.GetColumnName() = 'imhist_decisionyn' then  //추가 조연구
	
	sDecision = this.GetItemString(lRow,'imhist_decisionyn')
	
	if sDecision = 'N' then
		dBadQty = this.GetItemDecimal(lRow,'imhist_iofaqty')
		
		if dBadQty <= 0 then 
			MessageBox(' 확인! ', '불합격 판정일 경우 불합격 수량이 입력되어야 합니다. ', Information!)
			this.SetRow(lRow)
			this.SetColumn('imhist_iofaqty')
			Return 
		end if
	end if
	
end if
end event

event updatestart;///* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
end event

type rr_1 from roundrectangle within w_qct_01040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4133
integer y = 164
integer width = 448
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 372
integer width = 4558
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

