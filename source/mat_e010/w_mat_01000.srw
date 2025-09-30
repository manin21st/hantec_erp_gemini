$PBExportHeader$w_mat_01000.srw
$PBExportComments$구매발주입고 의뢰등록
forward
global type w_mat_01000 from window
end type
type p_bar from uo_picture within w_mat_01000
end type
type pb_1 from u_pb_cal within w_mat_01000
end type
type p_search from uo_picture within w_mat_01000
end type
type p_exit from uo_picture within w_mat_01000
end type
type p_can from uo_picture within w_mat_01000
end type
type p_del from uo_picture within w_mat_01000
end type
type p_mod from uo_picture within w_mat_01000
end type
type p_inq from uo_picture within w_mat_01000
end type
type cb_1 from commandbutton within w_mat_01000
end type
type cb_delete from commandbutton within w_mat_01000
end type
type cb_cancel from commandbutton within w_mat_01000
end type
type rb_delete from radiobutton within w_mat_01000
end type
type rb_insert from radiobutton within w_mat_01000
end type
type dw_detail from datawindow within w_mat_01000
end type
type cb_save from commandbutton within w_mat_01000
end type
type cb_exit from commandbutton within w_mat_01000
end type
type cb_retrieve from commandbutton within w_mat_01000
end type
type dw_list from datawindow within w_mat_01000
end type
type rr_1 from roundrectangle within w_mat_01000
end type
type rr_2 from roundrectangle within w_mat_01000
end type
type rr_3 from roundrectangle within w_mat_01000
end type
type dw_imhist from datawindow within w_mat_01000
end type
type dw_imhist_out from datawindow within w_mat_01000
end type
type dw_lot from u_key_enter within w_mat_01000
end type
type dw_bond from datawindow within w_mat_01000
end type
end forward

global type w_mat_01000 from window
integer width = 4658
integer height = 2532
boolean titlebar = true
string title = "구매입고의뢰 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_open ( )
p_bar p_bar
pb_1 pb_1
p_search p_search
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
cb_1 cb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_imhist dw_imhist
dw_imhist_out dw_imhist_out
dw_lot dw_lot
dw_bond dw_bond
end type
global w_mat_01000 w_mat_01000

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_RateGub       //환율 사용여부(1:일일,2:예측)            

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_qccheck         //검사수정여부
String     is_cnvart             //변환연산자
String     is_gubun             //변환계수사용여부
string     is_ispec, is_jijil  //규격, 재질명

String     is_outgu            // 외주 월 발주 여부
long		  il_count
DataStore ds_bond
end variables

forward prototypes
public function integer wf_waiju (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun)
public function integer wf_imhist_update_waiju ()
public function integer wf_checkrequiredfield ()
public function integer wf_danmst ()
public function integer wf_imhist_create (ref string rsdate, ref decimal rdseq)
public function integer wf_imhist_create_waiju ()
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_rate_chk ()
public function integer wf_set_janqty (long ar_row, string ar_gubun)
public function integer wf_update_gubun ()
public function integer wf_calc_amount ()
public function integer wf_initial ()
public function integer wf_select_qty (integer ar_row)
end prototypes

event ue_open();// 환경설정에서 검사구분수정여부를 검색
select dataname
  into :is_qccheck
  from syscnfg
 where sysgu = 'Y' and serial = '24' and lineno = '1';
 
if sqlca.sqlcode <> 0 then
	is_qccheck = 'N'
end if

// 환경설정에서 환율사용여부 검색
SELECT DATANAME
  INTO :is_RateGub
  FROM SYSCNFG  
 WHERE SYSGU = 'Y' AND SERIAL = 27 AND  LINENO = '1'   ;

if sqlca.sqlcode <> 0 then is_RateGub = '2'

if is_rategub <> '1' and is_rategub <> '2' then
	is_rategub = '2'
end if

///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 구매의뢰 -> 발주확정 연산자를 환경설정에서 검색함 */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '4';
If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '/'
End if
is_cnvart = sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if
is_gubun = sCnvgu

IF scnvgu = 'Y' THEN
	dw_list.dataobject = 'd_mat_01001_1'
else
	dw_list.dataobject = 'd_mat_01001'
end if

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
// 전표생선구분은 '007'
///////////////////////////////////////////////////////////////////////////////////

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_out.settransobject(sqlca)
dw_detail.insertrow(0)
dw_detail.SetFocus()

is_Date = f_Today()

IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
ELSE	
	is_ispec = '규격'
	is_jijil = '재질'
END IF

// Defalut 작업자
dw_detail.SetItem(1, 'empno', gs_empno)
dw_detail.SetItem(1, 'empname', gs_username)


// 보세창고용 
//ds_bond = CREATE DATASTORE
//ds_bond.DataObject = 'd_bondhst'
dw_bond.SetTransObject(sqlca)


// commandbutton function
rb_insert.TriggerEvent("clicked")
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
	
	sShpJpno  	= sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// 작업실적번호
	sitnbr	 		=	dw_list.GetItemString(lRow, "itnbr") 							      // 품번
	sPspec	 	=	dw_list.GetItemString(lRow, "poblkt_pspec")					      // 사양
	select fun_get_pdtgu(:sitnbr, '1') into :sPdtgu from dual;				      // 생산팀
	sPordno	 	= dw_list.getitemstring(lrow, "poblkt_pordno");				      // 작업지시번호	
	dInqty	 		= dw_list.getitemdecimal(lrow, "inqty")							      // 실적수량	

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
	
	ls_iojpno	=  dw_imhist.getitemstring(lRowHist, "iojpno");				      // 입출고 전표번호.
	UPDATE IMHIST SET JAKJINO = :sPordno , JAKSINO = :sShpjpno
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

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 입고수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sCode, sQcgub, get_nm, spordno, get_pdsts, sBaljpno
dec{3}	dQty, dBalQty, dBalseq
dec{5}   dPrice
long		lRow, lcount, ix


FOR	lRow = 1		TO		dw_list.RowCount()

	IF ic_status = '1'	THEN		
		
		If dw_list.getitemdecimal(lrow, "inqty") = 0 then
			continue
		end if
		
		lcount ++

		dPrice = dw_list.GetitemDecimal(lRow, "unprc")
		IF IsNull(dPrice)	or dPrice <= 0	THEN
			f_message_chk(30,'[입고단가]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("unprc")
			dw_list.setfocus()
			RETURN -1
		END IF
		
		sCode = dw_list.GetitemString(lRow, "poblkt_pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			dw_list.Setitem(lRow, "poblkt_pspec", '.')
		END IF

		sCode = dw_list.GetitemString(lRow, "vendor")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[입고처]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("vendor")
			dw_list.setfocus()
			RETURN -1
		END IF

		sqcgub = dw_list.getitemstring(lrow, "qcgubun") 
      SELECT SABU  
		  INTO :get_nm  
		  FROM REFFPF  
		 WHERE SABU = '1' AND  RFCOD = '08' AND  RFGUB = :sqcgub ;

      IF sqlca.sqlcode <> 0 then 
			f_message_chk(33,'[검사구분]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("qcgubun")
			dw_list.setfocus()
			RETURN -1
		END IF		

		/* 검사품목인 경우에만 check */
		if dw_list.getitemstring(lrow, "qcgubun") > '1' then 
			dw_list.SetItem(lRow, "qcdate", dw_detail.GetItemString(1, "sdate"))
			
			sCode = dw_list.GetitemString(lRow, "empno")
			IF IsNull(scode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[검사담당자]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("empno")
				dw_list.setfocus()
				RETURN -1
			END IF		
		end if
		
		//발주에 작업지시 no가 있으면 작업지시를 읽어서 상태가 '1', '2' 인 자료만 들어올 수 있음
		sPordno = dw_list.getitemstring(lrow, 'poblkt_pordno')
		if not (sPordno = '' or isnull(sPordno)) then 
			SELECT "MOMAST"."PDSTS"  
			  INTO :get_pdsts  
			  FROM "MOMAST"  
			 WHERE ( "MOMAST"."SABU"   = :gs_sabu ) AND  
					 ( "MOMAST"."PORDNO" = :sPordno )   ;
					 
//			if not (get_pdsts = '1' or get_pdsts = '2' ) then 
			if not (get_pdsts = '1' or get_pdsts = '2' or get_pdsts = '3') then 
				messagebox("확 인", "입고의뢰 처리를 할 수 없습니다. " + "~n~n" + &
										  "작업지시에 지시상태가 지시/재생산지시만 입고의뢰가 가능합니다.")
				dw_list.ScrollToRow(lrow)
   			dw_list.Setcolumn("inqty")
				dw_list.setfocus()
				return -1							  
			end if	
	
		end if
		
		/* Lot관리 */
		If dw_list.getitemstring(lrow, "itemas_lotgub") = 'Y' then 
			sBaljpno = dw_list.GetItemString(lRow, 'baljpno')
			dBalseq	= dw_list.GetItemNumber(lRow, 'balseq')
			
			// 해당되는 발주번호로 필터링한다
			dw_lot.SetFilter("chk = 'Y' and baljpno = '" + sBaljpno + "' and balseq = "+string(dbalseq))
			dw_lot.Filter()
			
			For ix = 1 To dw_lot.RowCount()
				sCode = dw_lot.GetitemString(ix, "lotsno")
				IF IsNull(sCode)	or   trim(sCode) = ''	THEN
					f_message_chk(30,'[LOT NO]')
					dw_lot.ScrollToRow(ix)
					dw_lot.Setcolumn("lotsno")
					dw_lot.setfocus()
					RETURN -1
				END IF
			Next		
		End If	
	END IF
	
	// 조회후 수정
	IF ic_status = '2'	THEN
			
		sCode = dw_list.GetitemString(lRow, "imhist_depot_no")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[입고처]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_depot_no")
			dw_list.setfocus()
			RETURN -1
		END IF

		dQty = dw_list.getitemdecimal(lrow, "imhist_ioreqty")
		IF IsNull(dQty)  or  dQty = 0		THEN
			f_message_chk(30,'[입고수량]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioreqty")
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
				f_message_chk(30,'[검사요청일]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("imhist_gurdat")
				dw_list.setfocus()
				RETURN -1
			END IF
		End if	

		lcount ++		
		
	END IF

NEXT


if lcount <= 0 then 
	f_message_chk(30,'[입고수량]')
	return -1
end if	

RETURN 1

end function

public function integer wf_danmst ();string	sItem, 		&
			sCust,		&
			sCustName,	&
			sIndate,		&
			sRedate,		&
			sCustom,		&	
			sNull, sGrpno
long		lRow
int		iCount

SetPointer(HourGlass!)
/* 단가마스터에 검사담당자가 없는 경우 환경설정에 있는 기본 검사담당자를 이용한다 */
Setnull(sNull)
select dataname
  into :scustom
  from syscnfg
 where sysgu = 'Y' and serial = '13' and lineno = '1';

if sqlca.sqlcode <> 0 then
	f_message_chk(207,'[검사담당자]') 	
end if

SELECT 	to_char(SYSDATE, 'hh24')
  INTO	:sIndate
  FROM 	DUAL;

IF sIndate < '12'	THEN
	iCount = 1
ELSE
	iCount = 2
END IF

sRedate = f_afterday(f_today(), iCount)

FOR  lRow = 1	TO		dw_list.RowCount()

	string	sEmpno, sGubun, sStock, sOpseq
	sItem  = dw_list.GetItemString(lRow, "itnbr")
	sCust  = dw_list.GetItemString(lRow, "cvcod")
	sStock = dw_list.GetItemString(lRow, "itemas_filsk")
	sOpseq = dw_list.GetItemString(lRow, "opseq")
	
  SELECT "DANMST"."QCEMP",   
         "DANMST"."QCGUB"  
    INTO :sEmpno,   
         :sGubun  
    FROM "DANMST"  
   WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
         ( "DANMST"."CVCOD" = :sCust ) AND ("DANMST"."OPSEQ" = :sOpseq )  ;
			
//	IF SQLCA.SQLCODE <> 0	THEN
	IF IsNull(sGubun) Or Trim(sGubun) = ''	THEN
		SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
        INTO :sgubun,  :sempno    
        FROM "ITEMAS"  
       WHERE "ITEMAS"."ITNBR" = :sitem ;
		
		if sgubun = '' or isnull(sgubun) then
			sGubun = '1'
			dw_list.SetItem(lRow, "qcgubun", sGubun)		// 무검사
		else
			dw_list.SetItem(lRow, "qcgubun", sgubun)		// 까다로운 검사
		end if
		if sgubun = '1' then //무검사인 경우
			dw_list.SetItem(lRow, "empno", sNull) 
		else
			if sempno = '' or isnull(sempno) then 
				dw_list.SetItem(lRow, "empno", scustom) // 기본검사 담당자		
			else
				dw_list.SetItem(lRow, "empno", sempno)	
			end if
		end if		
	ELSE
		IF Isnull(sGubun)		THEN	sGubun = '1'
		dw_list.SetItem(lRow, "qcgubun", sGubun)
		
		If sGubun = '1' then
			dw_list.SetItem(lRow, "empno", 	sNull)		
		Else
			If Isnull(sEmpno) or Trim(sEmpno) = '' then
				dw_list.SetItem(lRow, "empno", 	sCustom)
			else
				dw_list.SetItem(lRow, "empno", 	sEmpno)				
			end if
		End if
	END IF

	// 재고관리 하지 않을 경우 : 무검사, 검사담당자 없음
	if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then
		sStock = 'Y'
	end if
	dw_list.setitem(lRow, "itemas_filsk", sStock)
	IF sStock = 'N'	THEN	
		dw_list.SetItem(lRow, "qcgubun", '1')
		dw_list.Setitem(lrow, "empno", snull)
	End if

	// 입고후 검사품인 경우에는 무검사이면서 수정못함
	sGrpno = dw_list.GetItemString(lRow, "itemas_inspection_grpno2")
	IF sGrpno = 'Y'	THEN	
		dw_list.SetItem(lRow, "qcgubun", '1')
		dw_list.Setitem(lrow, "empno", snull)
		dw_list.setitem(lrow, "qcsugbn", 'N')
	Else
		// 검사요구일자는 무검사 이면 null 
		IF sStock = 'N' or sgubun = '1'	THEN	
			dw_list.SetItem(lRow, "qcdate", sNull)
		ELSE
			dw_list.SetItem(lRow, "qcdate", sRedate)
		END IF
		
		dw_list.setitem(lrow, "qcsugbn", is_qccheck)		// 검사구분 수정여부	
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
			sBalno, 		&
			sBlno,		&		
			sEmpno,		&
			sDate, 		&
			sVendor,		&
			sSaleYn,		&
			sGubun,		&
			sQcGubun,	&
			sQcEmpno,	&
			sStockGubun,	&
			sNull, sMaigbn, sIogbn, sDeptcode, sIojpno, sOpseq, &
			sLcno, sLocal, ls_host_gubun, ls_pordno, ls_opseq,  &
			sQcgub, sLotgub // 입고후 검사 여부 (ADT)
long		lRow, lRowHist, lRowOut, nrowcnt
long 		dSeq, dOutSeq, ix, iy
dec {2}	ld_inqty, ld_coqty
double   dLot // 최소 Lot Size (ADT)
Dec	   dInqty, dreqty
String 	sBalJpno
Dec		dBalseq

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
		if dw_list.getitemstring(lrow, "itemas_filsk") = 'N' then
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

/* ------------------------------------------- */
/* 수입인 경우 보세창고에서 (-)자료를 생성한다 */
/* ------------------------------------------- */
Int       dBonSeq
String    sBondNo

dw_bond.Reset()

dBonSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'Y5')

IF dBonSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[보세창고 출고번호]')
	RETURN -1
END IF

COMMIT;

sBondNo 	 = sDate + string(dBonSeq, "0000")

////////////////////////////////////////////////////////////////////////
sJpno  	 = sDate + string(dSeq, "0000")

dw_detail.SetItem(1, "jpno", 	sJpno)	
sEmpno = dw_detail.GetItemString(1, "empno")				// 입고의뢰자
sBalno = dw_detail.GetItemString(1, "balno")
sBlno  = dw_detail.GetItemString(1, "blno")
slcno  = dw_detail.GetItemString(1, "lcno")
sGubun = dw_detail.GetItemString(1, "gubun")

/* 신규입력자료를 위한 clear */
dw_imhist.reset()
dw_imhist_out.reset()

FOR	lRow = 1		TO		dw_list.RowCount()
	if dw_list.getitemdecimal(lrow, "inqty") = 0 then continue
	
	sBaljpno = dw_list.GetItemString(lRow, 'baljpno')
	dBalseq	= dw_list.GetItemNumber(lRow, 'balseq')
	sLotgub  = dw_list.GetItemString(lRow, 'itemas_lotgub')
	
	If sLotgub = 'Y' Then
		// 해당되는 발주번호로 필터링한다
		dw_lot.SetFilter("chk = 'Y' and baljpno = '" + sBaljpno + "' and balseq = "+string(dbalseq))
		dw_lot.Filter()
		nRowCnt = dw_lot.RowCount()
	Else
		nRowCnt = 1
	End If
	
	For ix = 1 To nrowCnt
		/////////////////////////////////////////////////////////////////////////
		//																							  //	
		// ** 입출고HISTORY 생성 **														  //	
		//																							  //
		/////////////////////////////////////////////////////////////////////////
		If sLotgub = 'Y' Then
			dInQty = dw_lot.GetItemNumber(ix, 'ioreqty')
		Else
			dInQty = dw_list.GetItemNumber(lRow, 'inqty')
		End If
		
		if dInQty <= 0 then continue
		
		lRowHist = dw_imhist.InsertRow(0)
		
		sQcGubun 	= dw_list.GetItemString(lRow, "qcgubun")
		sQcEmpno		= dw_list.GetItemString(lRow, "empno")
		sStockGubun = dw_list.GetItemString(lRow, "itemas_filsk")
		sVendor		= dw_list.GetItemString(lRow, "vendor")
		
		Select maigbn, ioyea2 into :sMaigbn, :slocal from iomatrix
		 where sabu = :gs_sabu and iogbn = :sgubun;
		
		
		//전공정 실적 환경이 'Y'인경우 전공정 실적 Check하여 Imhist와 MOROUT, SHPACT에 
		//반영되지 않도록 함.
		select dataname
		into :ls_host_gubun
		from syscnfg
		where sysgu = 'Y' and serial = '25' and lineno = '4';
		
		ls_pordno = dw_list.GetItemString(lRow, "pordno")
		sOpseq = dw_list.GetItemString(lRow, "opseq")
		
		If ls_host_gubun = 'Y' And sOpseq <> '9999' Then
			
			Select COQTY, OPSEQ INTO :ld_coqty, :ls_opseq
			From Morout
			Where sabu = :gs_sabu
			and   pordno = :ls_pordno
			and   de_opseq = :sOpseq;
			
			If sqlca.sqlcode = 0 and ld_coqty < ld_inqty Then 
				 MessageBox('확인',"작업지시번호 '" + ls_pordno + "'의 '"+ ls_opseq + "' 공정 실적이~r입력되지 않았습니다.") 
				 continue
			End If
		End If
			
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'007')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'I')				// 입출고구분
		sIojpno = sJpno + string(lRowHist, "000")
		dw_imhist.SetItem(lRowHist, "iojpno", 	sIojpno)
		dw_imhist.SetItem(lRowHist, "iogbn",   sGubun) 			// 수불구분=입고구분
	
		dw_imhist.SetItem(lRowHist, "sudat",	sDate)			// 수불일자=현재일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "poblkt_pspec"))	//사양
		dw_imhist.SetItem(lRowHist, "opseq",	dw_list.GetItemString(lRow, "opseq")) // 공정순서
		dw_imhist.SetItem(lRowHist, "depot_no",sVendor) 		// 기준창고=입고처
		dw_imhist.SetItem(lRowHist, "cvcod",	dw_list.GetItemString(lRow, "cvcod")) 		// 거래처창고=거래처
		dw_imhist.SetItem(lRowHist, "cust_no",	dw_list.GetItemString(lRow, "cvcod")) 		// 거래처창고=거래처
		dw_imhist.SetItem(lRowHist, "ioprc",	dw_list.GetItemDecimal(lRow, "unprc")) 	// 수불단가=입고단가
		dw_imhist.SetItem(lRowHist, "ioreqty",	dInQty) 												// 수불의뢰수량=입고수량(관리단위)
		dw_imhist.SetItem(lRowHist, "cnviore",	dInQty) 												// 수불의뢰수량=입고수량(발주단위)		
	
		dw_imhist.SetItem(lRowHist, "yebi2",	dw_list.GetItemString(lRow, "tuncu")) 	   // 통화단위
		dw_imhist.SetItem(lRowHist, "dyebi1",	dw_list.GetItemDecimal(lRow, "trate")) 	// 적용환율
		dw_imhist.SetItem(lRowHist, "dyebi2",	dw_list.GetItemDecimal(lRow, "funprc")) 	// 외화단가
		dw_imhist.SetItem(lRowHist, "dyebi3",	dw_list.GetItemDecimal(lRow, "prate")) 	// 관세율 + 수입비용율
	
		dw_imhist.SetItem(lRowHist, "qcgub",	sQcGubun) 		// 검사구분= 단가마스타
		dw_imhist.SetItem(lRowHist, "insemp",	sQcEmpno) 		// 검사담당자=단가마스타
		dw_imhist.SetItem(lRowHist, "filsk",   sStockGubun) 	// 재고관리유무
	
		dw_imhist.SetItem(lRowHist, "baljpno", dw_list.getitemstring(lrow, "baljpno"))			// 발주번호
		dw_imhist.SetItem(lRowHist, "balseq",  dw_list.GetItemNumber(lRow, "balseq"))
		dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
		select deptcode into :sdeptcode from p1_master where empno = :sempno;
		dw_imhist.SetItem(lRowHist, "ioredept",	sDeptcode)	// 수불의뢰부서
		dw_imhist.SetItem(lRowHist, "ioreemp",	sEmpno)			// 수불의뢰담당자=입고의뢰자
		 
		//부가 사업장  
		dw_imhist.SetItem(lRowHist, "saupj",	dw_list.GetitemString(lRow, "poblkt_saupj"))	
		//LOT 
		If sLotgub = 'Y' Then
			dw_imhist.SetItem(lRowHist, "lotsno",	dw_lot.GetitemString(ix, "lotsno"))
			dw_imhist.SetItem(lRowHist, "loteno",	dw_lot.GetitemString(ix, "loteno"))
		End If
	
		//입고후 검사품 유무
		dw_imhist.SetItem(lRowHist, "yebi3",	dw_list.GetItemString(lRow, "itemas_inspection_grpno2"))
	
		// 발주단위 및 변환계수
		dw_imhist.SetItem(lRowHist, "cnvfat",  dw_list.getitemdecimal(lrow, "poblkt_cnvfat"))			
		dw_imhist.SetItem(lRowHist, "cnvart",  dw_list.GetItemstring(lRow, "poblkt_cnvart"))
		
		// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
		// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
		SELECT HOMEPAGE
		  INTO :sSaleYN
		  FROM VNDMST
		 WHERE ( CVCOD = :sVendor ) ;	
		 
		// 재고관리 대상이 아니면 자동승인
		if sstockgubun = 'N' then ssaleyn = 'Y'
		
		// 단, 공정외주인 경우에는 무조건 수동승인 
		if dw_list.GetItemString(lRow, "opseq") <> '9999' then
			ssaleyn = 'N'
		end if
		
		dw_imhist.SetItem(lRowHist, "io_confirm", sSaleYn)			// 수불승인여부
	
		dw_imhist.SetItem(lRowHist, "gurdat",	dw_list.GetItemString(lRow, "qcdate"))		// 검사요청일
		dw_imhist.SetItem(lRowHist, "jakjino", dw_list.GetItemString(lRow, "pordno"))		// 작업지시번호
	
		IF sMaigbn	= '2'		then /*외자인 경우 */
			IF sLocal = '1' THEN //수입
				dw_imhist.SetItem(lRowHist, "polcno",dw_list.GetItemString(lRow, "polcbl_polcno"))
				dw_imhist.SetItem(lRowHist, "poblno",dw_list.GetItemString(lRow, "polcbl_poblno"))
				dw_imhist.SetItem(lRowHist, "poblsq",dw_list.GetItemNumber(lRow, "pobseq"))
			ELSE  //LOCAL
				dw_imhist.SetItem(lRowHist, "polcno",dw_list.GetItemString(lRow, "polcdt_polcno"))
			END IF
		END IF

		/* ------------------------------------------- */
		/* 수입인 경우 보세창고에서 (-)자료를 생성한다 */
		/* ------------------------------------------- */
		IF sMaigbn	= '2'	AND sLocal = '1' THEN //수입
			iy = dw_bond.InsertRow(0)
			
			dw_bond.SetItem(iy, 'sabu', gs_sabu)
			dw_bond.SetItem(iy, 'bondjpno', sBondNo + string(iy, "000"))
			dw_bond.SetItem(iy, 'iogbn', 'O')
			dw_bond.SetItem(iy, 'itnbr', dw_list.GetItemString(lRow, "itnbr"))
			dw_bond.SetItem(iy, 'pspec', dw_list.GetItemString(lRow, "poblkt_pspec"))
			dw_bond.SetItem(iy, 'ipdat', sDate)
			dw_bond.SetItem(iy, 'bondcd', '.')
			dw_bond.SetItem(iy, 'bondqty', dInQty)
			dw_bond.SetItem(iy, 'iojpno', sIojpno)
		End If
		/* ------------------------------------------- */
		
		IF sQcGubun = '1'		THEN										// 검사구분=무검사일 경우
			dw_imhist.SetItem(lRowHist, "insdat",sDate)			// 검사일자=입고의뢰일자
			dw_imhist.SetItem(lRowHist, "insemp",snull)			// 검사담당자=null
			dw_imhist.SetItem(lRowHist, "iosuqty",dInQty)	// 합격수량=입고수량(관리단위)
			dw_imhist.SetItem(lRowHist, "cnviosu",dInQty)	// 합격수량=입고수량(발주단위)
			dw_imhist.SetItem(lRowHist, "decisionyn", 'Y')		// 합격처리
		END IF
		
		IF sQcgubun = '1' And sSaleYn = 'Y' then // 무검사이고 수불자동승인인 경우 또는 재고관리 대상인 아닌것
			dw_imhist.SetItem(lRowHist, "io_confirm", sSaleYn)	// 수불승인여부	
			dw_imhist.SetItem(lRowHist, "ioqty", dInQty) 	// 수불수량=입고수량
			dw_imhist.SetItem(lRowHist, "ioamt", Truncate(dInQty &
									* dw_list.GetItemDecimal(lRow, "unprc"), 0))	// 수불금액=입고단가
			dw_imhist.SetItem(lRowHist, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
			dw_imhist.SetItem(lRowHist, "io_empno", sNull)		// 수불승인자=NULL
		END IF
	
		// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
		// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
		sOpseq = dw_list.GetItemString(lRow, "opseq")
		IF sOpseq <> '9999' And sQcgubun = '1' THEN
			
			dw_imhist.SetItem(lRowHist, "ioamt", Truncate(dInQty * dw_list.GetItemDecimal(lRow, "unprc"), 0))	// 수불금액=입고단가
						  
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
			dw_imhist_out.SetItem(lRowOut, "pspec",	dw_list.GetItemString(lRow, "poblkt_pspec"))//사양
			dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// 공정순서
			dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// 기준창고=입고처
			dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// 거래처창고=입고처
			dw_imhist_out.SetItem(lRowOut, "ioqty",   dInQty)		// 수불수량=입고수량
			dw_imhist_out.SetItem(lRowOut, "ioprc",	0)	
			dw_imhist_out.SetItem(lRowOut, "ioreqty",	dInQty) 	// 수불의뢰수량=입고수량		
			dw_imhist_out.SetItem(lRowOut, "insdat",	sDate) 			// 검사일자=입고의뢰일자
			dw_imhist_out.SetItem(lRowOut, "iosuqty", dInQty)		// 합격수량=입고수량
	
			dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// 수불승인자
			dw_imhist_out.SetItem(lRowOut, "io_confirm", sSaleYn)		// 수불승인여부
			dw_imhist_out.SetItem(lRowOut, "io_date", sDate)			// 수불승인일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// 재고관리구분
			dw_imhist_out.SetItem(lRowOut, "bigo",  '구매입고 동시출고분')
			dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// 동시출고여부
			dw_imhist_out.SetItem(lRowOut, "ip_jpno", sJpno + string(lRowHist, "000")) // 입고전표번호
			dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// 수불의뢰담당자=입고의뢰담당자
			If sLotgub = 'Y' Then
				dw_imhist_out.SetItem(lRowOut, "lotsno",	dw_lot.GetitemString(ix, "lotsno"))
				dw_imhist_out.SetItem(lRowOut, "loteno",	dw_lot.GetitemString(ix, "loteno"))
			End If
			
			//부가 사업장  
			dw_imhist_out.SetItem(lRowOut, "saupj",	dw_list.GetitemString(lRow, "poblkt_saupj"))	
		END IF
	Next
NEXT

RETURN 1
end function

public function integer wf_imhist_create_waiju ();///////////////////////////////////////////////////////////////////////
//	* 입고실적및 외주 자동불출후 생산실적 작성
///////////////////////////////////////////////////////////////////////
string	sDate, 		&
			sEmpno,		&
			sVendor,		&
			sGubun,		&
			sQcGubun,	&
			sQcEmpno, sNull, sIojpno, sOpseq,ls_host_gubun, ls_pordno, ls_opseq, ls_opseq_prv
long		lRow, lRowHist, lRowOut
dec {2}	dShpSeq, dShpipgo, ld_inqty, ld_coqty
SetNull(sNull)

sDate  = trim(dw_detail.GetItemString(1, "sdate"))				// 입고의뢰일자
/* 공정이 '9999'가 아니면 작업실적 전표번호를 생성(무검사 자료가 있는 경우에만) */
FOR	lRow = 1		TO		dw_list.RowCount()
		if dw_list.getitemstring(lrow, "opseq") <> '9999' AND &
			dw_list.getitemstring(lrow, "qcgubun") = '1' And &
			dw_list.getitemdecimal(lrow, "inqty") > 0 then			
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
	
	if dw_list.getitemdecimal(lrow, "inqty") = 0 then continue

	sQcGubun 	= dw_list.GetItemString(lRow, "qcgubun")
	sQcEmpno	= dw_list.GetItemString(lRow, "empno")
	sVendor		= dw_list.GetItemString(lRow, "vendor")
	sIojpno     	= dw_imhist.GetItemString(lRowHist, "iojpno")
	sOpseq      	= dw_imhist.GetItemString(lRowHist, "opseq")

	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_list.GetItemString(lRow, "opseq")
	IF sOpseq <> '9999' And sQcgubun = '1' THEN
		
		//전공정 실적 환경이 'Y'인경우 전공정 실적 Check하여 Imhist와 MOROUT, SHPACT에 
		//반영되지 않도록 함.
		select dataname
		into :ls_host_gubun
		from syscnfg
		where sysgu = 'Y' and serial = '25' and lineno = '4';
		
		ls_pordno = dw_list.GetItemString(lRow, "pordno")
		ld_inqty =  dw_list.getitemdecimal(lrow, "inqty")
		ls_opseq =  dw_list.GetItemString(lRow, "opseq")
		
		If ls_host_gubun = 'Y' Then
			
			Select COQTY, OPSEQ INTO :ld_coqty, :ls_opseq_prv
			From Morout
			Where sabu     = :gs_sabu
			and   pordno   = :ls_pordno
			and   de_opseq = :ls_opseq;
			
			If sqlca.sqlcode = 0 and ld_coqty < ld_inqty Then 
//				 MessageBox('확인',"작업지시번호 '" + ls_pordno + "'의 '"+ ls_opseq_prv + "' 공정 실적이~r입력되지 않았습니다.") 
				 continue
			End If
		End If
		
		il_count = il_count + 1
		
		if 	wf_waiju(Lrow, Lrowhist, sDate, dShpseq, sIojpno, sOpseq, dShpipgo, Sempno, sVendor, 'I') = -1 then
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

sBlno  = dw_detail.GetItemString(1, "blno")

if not (sBlno = '' or isnull(sBlno)) then 
   SELECT "POLCBL"."MAGYEO"  
     INTO :sMagub
     FROM "POLCBL"  
    WHERE ( "POLCBL"."SABU"   = :gs_sabu ) AND  
          ( "POLCBL"."POBLNO" = :sBlno ) AND ROWNUM = 1  ;

  if sMagub = 'Y' then 
	  MessageBox("확 인", "B/L 마감된 자료는 삭제할 수 없습니다. 자료를 확인하세요!")
	  return -1
  end if	  
end if


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

	// 보세창고 출고내역 삭제
	if not (sBlno = '' or isnull(sBlno)) then 
		DELETE FROM "BONDHST"
		 WHERE ( "BONDHST"."SABU" = :gs_sabu ) 	AND  
				( "BONDHST"."IOJPNO" = :sHist_Jpno )  AND
				( "BONDHST"."IOGBN"  = 'O' );
		if SQLCA.SQLCODE < 0 then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			Rollback;
			MessageBox('삭제확인', '보세창고 출고내역 전표삭제를 실패하였습니다.')
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

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* 수정모드
//		1. 입출고history -> 입고수량 update (입고수량을 변경할 경우에만)
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sHouse, sDate, sNull, sQcgubun, sSaleYn, sStockgubun, sOpseq, sVendor
String	sWigbn, sError, sGubun, sBlno
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
	dTemp_Qty   = dw_list.GetItemDecimal(lRow, "temp_qty")	
	if isnull(dinqty) then dinqty = 0
	if isnull(dTemp_Qty) then dTemp_Qty = 0
	
	//창고 (2001.7.21 수정 옥준철 : 입고창고는 1개)
	//sHouse		= dw_list.GetItemString(lRow, "imhist_depot_no")
	sHouse		= dw_detail.GetItemString(1, "in_house")
	sTemp_depot = dw_list.GetItemString(lRow, "temp_depot")
   //검사구분 	
	sQcgubun		= dw_list.GetItemString(lRow, "qcgubun")	
	sTemp_Qcgub	= dw_list.GetItemString(lRow, "temp_qcgub")	

//	sLotno     	= dw_list.GetItemString(lRow, "lotsno")
//	sTemp_Lots 	= dw_list.GetItemString(lRow, "temp_lots")
//	sMakeLot   	= dw_list.GetItemString(lRow, "loteno")
//	sTemp_Lote 	= dw_list.GetItemString(lRow, "temp_lote")
//	if isnull(sLotno) then sLotno = ''
//	if isnull(sTemp_Lots) then sTemp_Lots = ''
//	if isnull(sMakeLot) then sMakeLot = ''
//	if isnull(sTemp_Lote) then sTemp_Lote = ''
	
   if dINqty = dTemp_qty and shouse = stemp_depot and sqcgubun = stemp_qcgub THEN continue 
	
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
			dw_imhist.SetItem(lRow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") * dw_list.GetItemDecimal(lRow, "imhist_unprc"), 0))	// 수불금액=입고단가		
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
	
	// 보세창고 출고내역 수정
	sBlno		= dw_detail.GetItemString(1, "blno")
	If Not IsNull(sBlno) Then
	  UPDATE "BONDHST"  
		  SET "BONDQTY"   = :dInQty
		WHERE ( "BONDHST"."SABU" = :gs_sabu ) 	AND  
				( "BONDHST"."IOJPNO" = :sHist_Jpno )  AND
				( "BONDHST"."IOGBN"  = 'O' ) ;
		
		IF SQLCA.SQLNROWS < 1	THEN
			ROLLBACK;
			messagebox('확인', '보세창고 출고전표 저장 실패!')
			RETURN -1
		END IF
	End If
NEXT

RETURN 1

end function

public function integer wf_rate_chk ();string s_today
long   get_count
 
s_today  = dw_detail.getitemstring(1, 'sdate')	

IF is_RateGub = '1' then  
	 SELECT COUNT(*)
		INTO :get_count
		FROM RATEMT  
	  WHERE RDATE = :s_today  ;	
	if get_count < 1 then 		
		messagebox("확 인", "일일 환율을 먼저 입력해야 합니다.")
		return -1
	end if	
ELSE
	SELECT COUNT(*)
	  INTO :get_count
	  FROM EXCHRATE_FORECAST
	 WHERE BASE_YYMM = SUBSTR(:s_today, 1, 6) ;
	
	if get_count < 1 then 		
		messagebox("확 인", "예측 환율을 먼저 입력해야 합니다.")
		return -1
	end if	
END IF

RETURN 1
end function

public function integer wf_set_janqty (long ar_row, string ar_gubun);///////////////////////////////////////////////////////////////////////////////////////////
// 2000/03/30 유상웅 - 변환 계수 사용시만 사용함  
// 발주단위에 잔량과 발주단위 입고 수량이 같은 경우 입고수량 잔량을 변환하여 셋팅한다.
// 발주입고인 경우는 발주품목정보에 변환발주수량 - (변환검사대기 + 변환합격수량) 수량을 SET 
// B/L 입고인 경우는 B/L번호로 발주번호를 찾아서 발주에 다른 B/L을 찾아서 모두 입고되었는지
//            여부를 체크하여 마지막이면 위에 방법으로 수량을 SETTING
// Argument => ar_Gubun이 '1'이면 발주 '2'이면 수불임
///////////////////////////////////////////////////////////////////////////////////////////

dw_detail.Accepttext()

string  	sMaigbn, sGubun, sLocal 
Dec{3}   dcnvjan, dcnvqty, djanqty, dqty, dTEMP_QTY  

SetPointer(HourGlass!)  

sGubun = dw_detail.getitemstring(1, "gubun")

Select maigbn, ioyea2 into :sMaigbn, :sLocal from iomatrix
 where sabu = :gs_sabu and iogbn = :sGubun;
 
if sqlca.sqlcode <> 0 then
	Messagebox("입고구분", "입고구분이 부정확합니다")
	return -1
end if;

IF ar_gubun = '1'	THEN		//발주에서 입고의뢰시 
	dcnvJan = dw_list.GetItemDecimal(ar_row, 'cnv_balju')   //변환발주 or B/L 잔량
	dJanqty = dw_list.GetItemDecimal(ar_row, 'balju')       //발주 or B/L 잔량

	IF sMaigbn = '1'	THEN		// 내자입고(수입아님)
		dw_list.setitem(ar_row, "inqty", djanqty)
	ELSE
   	dcnvqty = dw_list.GetItemDecimal(ar_row, 'cnv_janqty')   //변환발주 잔량
   	dqty    = dw_list.GetItemDecimal(ar_row, 'janqty')       //발주 잔량
		
		if dcnvjan = dcnvqty then 
   		dw_list.setitem(ar_row, "inqty", dqty)
		else
			return 0
		end if
	END IF
ELSE //입고자료 수정시
	dcnvJan = dw_list.GetItemDecimal(ar_row, 'cnv_balju')   //변환발주 or B/L 잔량
	dJanqty = dw_list.GetItemDecimal(ar_row, 'balju')       //발주 or B/L 잔량

   dtemp_qty = dw_list.GetItemDecimal(ar_row, "TEMP_QTY")   //입고의뢰 수량(입고기준)
	IF sMaigbn = '1'	THEN		// 내자입고(수입아님)
		dw_list.setitem(ar_row, "imhist_ioreqty", djanqty + dtemp_qty)
	ELSE
   	dcnvqty = dw_list.GetItemDecimal(ar_row, 'cnv_janqty')   //변환발주 잔량
   	dqty    = dw_list.GetItemDecimal(ar_row, 'janqty')       //발주 잔량

		
		if dcnvjan = dcnvqty then 
   		dw_list.setitem(ar_row, "imhist_ioreqty", dqty  + dtemp_qty)
		else
			return 0
		end if
	END IF
	
END IF
SetPointer(Arrow!)
return 1
end function

public function integer wf_update_gubun ();long		lRow, lCount
string	sQcgubun, sQcdate, sIoConfirm, sIoDate, sMagub, sBlno

string   sittyp, sitcls, scvcod, sitnbr, sPspec

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

if ic_status <> '1' then
	
	sBlno  = dw_detail.GetItemString(1, "blno")
	if not (sBlno = '' or isnull(sBlno)) then 
		SELECT "POLCBL"."MAGYEO"  
		  INTO :sMagub
		  FROM "POLCBL"  
		 WHERE ( "POLCBL"."SABU"   = :gs_sabu ) AND  
				 ( "POLCBL"."POBLNO" = :sBlno ) AND ROWNUM = 1  ;
	

	   if sMagub = '' OR ISNULL(sMagub) then sMagub = 'N'

		if sMagub = 'Y' then 
		   MessageBox("확 인", "B/L 마감된 자료는 입고수량을 변경할 수 없습니다.")
	   end if
	end if
	
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
ELSE
	FOR  lRow = 1	TO	lCount
		// 변환계수를 변환('*'인 경우 '/'로, '/'인 경우 '*'로 (단 * and 1이면 동일))
		if is_gubun = 'Y' then
			if dw_list.getitemstring(Lrow, "poblkt_cnvart") = '*' and &
				dw_list.getitemdecimal(Lrow, "poblkt_cnvfat") = 1   then
				dw_list.setitem(Lrow, "poblkt_cnvart", '*')				
			elseif dw_list.getitemstring(Lrow, "poblkt_cnvart") = '*' then
				dw_list.setitem(Lrow, "poblkt_cnvart", '/')
			else
				dw_list.setitem(Lrow, "poblkt_cnvart", '*')
			end if	
		else
				dw_list.setitem(Lrow, "poblkt_cnvart", '*')			
		end if
		
		If dw_list.getitemstring(Lrow, "poblkt_cnvart") = '*' OR &
			dw_list.getitemstring(Lrow, "poblkt_cnvart") = '/' THEN
		ELSE
			dw_list.setitem(Lrow, "poblkt_cnvart", '*')
		END IF
		
		IF dw_list.getitemdecimal(Lrow, "poblkt_cnvfat") = 0  OR &
			ISNULL(dw_list.getitemdecimal(Lrow, "poblkt_cnvfat"))  THEN
			dw_list.setitem(Lrow, "poblkt_cnvfat", 1)			
		End if

	NEXT
	

END IF
	
RETURN 1
end function

public function integer wf_calc_amount ();long	lRow, lRowcount

lRowcount = dw_list.RowCount()

FOR lRow = 1 TO lRowcount

	dw_list.SetItem(lRow, "inamt", 	&
								 dw_list.GetItemDecimal(lRow, "inqty") *		&
								 dw_list.GetItemDecimal(lRow, "unprc") )

NEXT

RETURN 1
end function

public function integer wf_initial ();String sIogbn, sMaigbn, sNull, sLocal

Setnull(sNull)

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()
dw_imhist.Visible = false
dw_imhist_out.reset()
dw_lot.reset()

p_mod.enabled = false
p_mod.picturename = "C:\erpman\image\저장_d.gif"
p_del.enabled = false
p_del.picturename = "C:\erpman\image\삭제_d.gif"
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

dw_detail.Object.saupj.protect 	= 0
dw_detail.Object.gubun.protect 	= 0
dw_detail.Object.lcno.protect 		= 0
dw_detail.Object.empno.protect 	= 0
dw_detail.Object.in_house.protect = 0
dw_detail.Object.vendor.protect 	= 0
dw_detail.Object.jpno.protect 		= 0

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// 등록시
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("sDATE", 10)
   dw_detail.settaborder("balno", 20)
	dw_detail.settaborder("gubun", 30)
	dw_detail.settaborder("empno", 40)
	dw_detail.settaborder("blno",  50)
	dw_detail.settaborder("lcno",  60)

//   dw_detail.Object.jpno.Background.Color= 79741120
//
//   dw_detail.Object.sdate.Background.Color= 12639424
//   dw_detail.Object.empno.Background.Color= 65535
//   dw_detail.Object.gubun.Background.Color= 16777215
//   dw_detail.Object.balno.Background.Color= 65535
//   dw_detail.Object.blno.Background.Color= 65535
//   dw_detail.Object.lcno.Background.Color= 65535
	
	// 구매입고 형태의 수불구분중에서 임의의 코드를 Default로 Setting
	Select a.iogbn, a.maigbn, a.ioyea2 into :sIogbn, :sMaigbn, :sLocal
	  From Iomatrix a
	 Where a.iogbn = 
		  (Select Min(iogbn) 
			  from iomatrix where sabu = :gs_sabu and jnpcrt = '007');

	dw_detail.setcolumn("empno")
	dw_detail.SetItem(1, "sdate", is_Date)
	dw_detail.setitem(1, "gubun", siogbn)
	dw_detail.setitem(1, "maigbn", smaigbn)

	IF sMaigbn = '1'	THEN
		IF is_gubun = 'Y' THEN
			dw_list.DataObject = 'd_mat_01001_1'
      ELSE
			dw_list.DataObject = 'd_mat_01001'
		END IF
		dw_detail.SetItem(1, "blno", sNull)
		dw_detail.settaborder("blno",  0)
		dw_detail.settaborder("lcno",  0)
		dw_detail.settaborder("balno", 20)

	ELSE
		IF sLocal = '1' THEN 
			IF is_gubun = 'Y' THEN
				dw_list.DataObject = 'd_mat_01002_1'
			ELSE
				dw_list.DataObject = 'd_mat_01002'
			END IF
			dw_detail.SetItem(1, "balno", sNull)
			dw_detail.SetItem(1, "vendor", sNull)
			dw_detail.SetItem(1, "vendorname", snull)
			dw_detail.settaborder("blno",  50)
			dw_detail.settaborder("lcno",  0)
			dw_detail.settaborder("balno", 0)

		ELSE
			IF is_gubun = 'Y' THEN
				dw_list.DataObject = 'd_mat_01005_1'
			ELSE
				dw_list.DataObject = 'd_mat_01005'
			END IF
			dw_detail.SetItem(1, "balno", sNull)
			dw_detail.SetItem(1, "vendor", sNull)
			dw_detail.SetItem(1, "vendorname", snull)
			dw_detail.settaborder("lcno",  60)
			dw_detail.settaborder("blno",  0)
			dw_detail.settaborder("balno", 0)

		END IF
	END IF
	
	dw_list.SetTransObject(sqlca)

	w_mdi_frame.sle_msg.text = "등록"

ELSE
	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("sDATE", 0)
	dw_detail.settaborder("empno", 0)
	dw_detail.settaborder("gubun", 0)
	dw_detail.settaborder("balno", 0)
	dw_detail.settaborder("blno",  0)
	dw_detail.settaborder("lcno",  0)

//   dw_detail.Object.jpno.Background.Color= 65535
//
//   dw_detail.Object.sdate.Background.Color= 79741120
//   dw_detail.Object.empno.Background.Color= 79741120
//   dw_detail.Object.gubun.Background.Color= 79741120
//   dw_detail.Object.balno.Background.Color= 79741120
//   dw_detail.Object.blno.Background.Color= 79741120
//   dw_detail.Object.lcno.Background.Color= 79741120
	
	dw_detail.setcolumn("JPNO")

	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

//사업장
f_mod_saupj(dw_detail, 'saupj' )

//입고창고 
f_child_saupj(dw_detail, 'in_house','%' )

return  1

end function

public function integer wf_select_qty (integer ar_row);String sBaljpno, ls_pordno, ls_gbn, scode,slocal
Dec    dBalseq, dSumQty, dQty
Dec    dBalrate, ld_ioreqty, dtemp
Long   nRow

If dw_lot.RowCount() > 0 Then
	sBaljpno	= dw_lot.GetItemString(ar_row, 'baljpno')
	dBalseq	= dw_lot.GetItemNumber(ar_row, 'balseq')
	dSumQty  = dw_lot.GetItemNumber(ar_row, 'sum_qty')
	
	dw_list.AcceptText()
	
//	nRow = dw_list.Find("baljpno = '" + sBaljpno + "' and balseq =" + string(dbalseq),1 ,dw_list.RowCount())
	nRow = dw_list.GetRow()
	
	If nRow > 0 Then
		dw_list.SetItem(nRow, 'inqty', dSumQty)
		
		// 입고수량 > 입고잔량 이면 ERROR(신규입력시)
		dQty     = dw_list.GetItemDecimal(nRow, "balju")
		dBalRate = dw_list.GetItemDecimal(nRow, "itemas_balrate")
		ls_pordno = dw_list.GetItemString(nRow, "poblkt_pordno")
		
		if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100
		
		ls_gbn   = dw_detail.getitemstring(1, 'gubun')	
	
		Select maigbn, ioyea2 into :sCode, :sLocal from iomatrix
		 where sabu = :gs_sabu and iogbn = :ls_gbn;
		
		//입고 형태가 내자인 경우만..
		If sCode = '1' Then
			ld_ioreqty = dw_list.GetItemDecimal(nRow, "ioreqty")
			dtemp	= dQty - ld_ioreqty
		End If
		
		IF dSumQty > truncate(dQty * dBalRate / 100, 3)	THEN
			MessageBox("확인", "입고수량" + string(dSumQty, '#,##0.000') + " 은 발주(B/L)잔량" &
								  + string(dqty, '#,##0.000') +  "* 허용률  보다 클 수 없습니다.")
			dw_list.SetItem(nRow, "cinqty", 	0)
			dw_list.SetItem(nRow, "inqty", 	0)
			dw_lot.SetItem(ar_row, 'ioreqty', 0)
			dw_list.Setfocus()
			RETURN 1
		//입고 수량이 발주수량 - 검사대기 수량보다 크면 ERROR(등록시)
		ELSEIF dSumQty > truncate(dtemp, 3)	and ls_pordno <> '' and not (isnull(ls_pordno)) THEN
			MessageBox("확인", "입고수량 " + string(dSumQty, '#,##0.000') + " 은 발주수량 - 검사대기수량 " + string(dtemp, '#,##0.000') &
								  + " 보다 클 수 없습니다.")
			dw_list.SetItem(nRow, "cinqty", 	0)
			dw_list.SetItem(nRow, "inqty", 	0)
			dw_lot.SetItem(ar_row, 'ioreqty', 0)
			dw_list.Setfocus()
			RETURN 1
		ELSE
			if dw_list.getitemdecimal(nRow, "poblkt_cnvfat") = 1 then
				dw_list.setitem(nRow, "cinqty", dSumQty)
			Elseif dw_list.getitemstring(nRow, "poblkt_cnvart") = '*' then
				dw_list.setitem(nRow, "cinqty", Round(dSumQty / dw_list.getitemdecimal(nRow, "poblkt_cnvfat"), 3))
			else
				dw_list.setitem(nRow, "cinqty", Round(dSumQty * dw_list.getitemdecimal(nRow, "poblkt_cnvfat"), 3))
			end if
		END IF
		
		//dw_list.SetItem(nRow, "inamt", Truncate(dSumQty * dw_list.getitemdecimal(nRow, "unprc"), 0))
		
		dw_list.SetItem(nRow, "inamt", Truncate(dSumQty * (dw_list.getitemdecimal(nRow, "balamt") / dw_list.getitemdecimal(nRow, "balqty")), 0))
	Else
		Return 0
	End If
End If

Return 0
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

on w_mat_01000.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_bar=create p_bar
this.pb_1=create pb_1
this.p_search=create p_search
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_imhist=create dw_imhist
this.dw_imhist_out=create dw_imhist_out
this.dw_lot=create dw_lot
this.dw_bond=create dw_bond
this.Control[]={this.p_bar,&
this.pb_1,&
this.p_search,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.cb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.dw_list,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.dw_imhist,&
this.dw_imhist_out,&
this.dw_lot,&
this.dw_bond}
end on

on w_mat_01000.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_bar)
destroy(this.pb_1)
destroy(this.p_search)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_imhist)
destroy(this.dw_imhist_out)
destroy(this.dw_lot)
destroy(this.dw_bond)
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

DESTROY ds_bond
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type p_bar from uo_picture within w_mat_01000
boolean visible = false
integer x = 3227
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\barcode.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

setnull(gs_code)
if dw_detail.accepttext() = -1 then return 
gs_code = dw_detail.GetItemString(1, 'jpno')

//바코드 출력 선택 WINDOW OPEN
open(w_mat_01000_barcode)
end event

event ue_lbuttondown;call super::ue_lbuttondown;//PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;//PictureName = "C:\erpman\image\재고조회_up.gif"
end event

type pb_1 from u_pb_cal within w_mat_01000
integer x = 782
integer y = 284
integer taborder = 20
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type p_search from uo_picture within w_mat_01000
integer x = 4064
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\재고조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long lRow

if dw_list.accepttext() = -1 then return 
if dw_list.rowcount() < 1 then return 

lRow = dw_list.getrow()

if lRow < 1 then 
	messagebox('확 인', '조회할 자료를 선택하세요!')
	return 
end if

gs_code = dw_list.getitemstring(lRow, 'itnbr')

IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
	f_message_chk(30,'[품번]')
	dw_list.ScrollToRow(lRow)
	dw_list.Setcolumn("itnbr")
	dw_list.setfocus()
	RETURN 
END IF

if ic_status = '1' then 
	gs_gubun = dw_list.getitemstring(lRow, 'vendor')
else
	gs_gubun = dw_list.getitemstring(lRow, 'imhist_depot_no')
end if
// 코드명이 Y가 아니면 선택할 수 없고 조회만 'Y' 이면 선택할 수 있음
gs_codename = 'N' 
open(w_stock_popup)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고조회_up.gif"
end event

type p_exit from uo_picture within w_mat_01000
integer x = 4411
integer y = 24
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

type p_can from uo_picture within w_mat_01000
integer x = 4238
integer y = 24
integer width = 178
integer taborder = 70
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

type p_del from uo_picture within w_mat_01000
integer x = 3886
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
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
   p_can.triggerevent(clicked!)
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_mat_01000
integer x = 3712
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

il_count = 0

IF dw_list.RowCount() < 1			THEN 	RETURN 
//IF dw_imhist.RowCount() < 1			THEN 	RETURN 
//IF dw_imhist.AcceptText() <> 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 입고수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
string sdate, sWigbn, sError, sIojpno, sGubun, ls_iojpno, sChk, sJpno
long	 lRow, ll_cnt, i
dec	 dSeq, dQty

IF	wf_CheckRequiredField() = -1		THEN	RETURN 

IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
		
	// 입고창고 일괄변경  2004.03.11 주석처리(주석 풀지 말것! => 아님 나한테 탄핵됨.)
//	FOR lRow = 1  TO  dw_list.RowCount()
//		dw_list.SetItem(lRow, "vendor", dw_detail.GetItemString(1, "in_house"))
//	NEXT
	
	IF wf_imhist_create(sdate, dseq) < 0 THEN RETURN 
					
	IF dw_imhist.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF

	IF dw_imhist_out.Update() <> 1	THEN
		ROLLBACK;
		f_Rollback()
		RETURN		
	END IF

	If dw_bond.RowCount() > 0 Then
		IF dw_bond.Update() <> 1 THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			ROLLBACK;
			f_Rollback()
			RETURN -1
		END IF
	End If
	
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
		messagebox(siojpno,sqlca.sqlerrtext)
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고]')
			Rollback;
			return 
		end if;
		
		IF wf_imhist_create_waiju() <> 1 THEN return
	end if;	

	Commit;
	
	MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
										 "~r~r생성되었습니다.")

	//바코드 출력 선택 WINDOW OPEN
//	gs_code = sDate +string(dSeq,"0000")
//	open(w_mat_01000_barcode)

//	gs_gubun = sDate+ string(dSeq,"0000")
//	
//	gs_code = 'w_mat_01000'
//	gs_codename = '구매입고의뢰 등록'
//	gs_codename2 = "요청하신 내역이 입고 되었습니다."
//	For i = 1 To dw_list.RowCount()
//		dQty = dw_list.GetItemNumber(i, 'inqty')
//		If dQty <= 0 Then Continue
//		
//		gs_codename2 += ( '~r~n~r~n' + dw_list.GetItemString(i, 'itemas_itdsc') + '    입고수량 : ' + string(dqty,'#,##0.00') )
//	Next
//						
//	Open(w_mailsend_popup2)
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

p_can.TriggerEvent("clicked")	
//p_inq.TriggerEvent(Clicked!)
dw_imhist.Visible = false
SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_mat_01000
integer x = 3534
integer y = 24
integer width = 183
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//retrievrow 에 error 발생할 경우를 대비하여( 두번연속 클릭못하게 하기위함 )
This.Enabled = False
dw_imhist.Visible = false

if dw_detail.Accepttext() = -1	then 	return

string  	sGubun,		&
			sBalno,		&
			sBlno,		&
			sJpno,		&
			sDate,		&
			sEmpno,		&
			sNull,	smaigbn, sLcno, sLocal, ls_saupj
long		lRow 

SetNull(sNull)

sEmpno 	= dw_detail.GetItemstring(1, "empno")
sGubun 	= dw_detail.getitemstring(1, "gubun")
sBalno 	= dw_detail.getitemstring(1, "balno")
sBlno	 	= dw_detail.getitemstring(1, "blno")
slcno	 	= dw_detail.getitemstring(1, "lcno")
sJpno  	= dw_detail.getitemstring(1, "jpno")
ls_saupj	= dw_detail.getitemstring(1, "saupj")

Select maigbn, ioyea2 into :sMaigbn, :sLocal from iomatrix
 where sabu = :gs_sabu and iogbn = :sGubun;
 
if sqlca.sqlcode <> 0 then
	Messagebox("입고구분", "입고구분이 부정확합니다")
	This.Enabled = True
	return
end if;

sDate =  trim(dw_detail.GetItemString(1, "sdate"))

SetPointer(HourGlass!)  
dw_list.setredraw(false)
//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	IF isnull(sDate) or sDate = "" 	THEN
		dw_list.setredraw(true)
		f_message_chk(30,'[입고의뢰일자]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
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
	
	IF sMaigbn = '1'		THEN		// 내자입고(수입아님)
	
		IF isnull(sBalno) or sBalno = "" 	THEN
			dw_list.setredraw(true)
			f_message_chk(30,'[발주번호]')
			dw_detail.SetColumn("balno")
			dw_detail.SetFocus()
			This.Enabled = True
			RETURN
		END IF
		
		IF	dw_list.Retrieve(gs_sabu, sBalno, sdate, is_rategub, ls_saupj) <	1		THEN
			dw_list.setredraw(true)
			f_message_chk(50, '[입고의뢰내역]')
			dw_detail.setcolumn("balno")
			dw_detail.setfocus()
			This.Enabled = True
			RETURN
		END IF

	ELSE
	   IF sLocal = '1' THEN 
			IF isnull(sBlno) or sBlno = "" 	THEN
				dw_list.setredraw(true)
				f_message_chk(30,'[B/L NO]')
				dw_detail.SetColumn("blno")
				dw_detail.SetFocus()
				This.Enabled = True
				RETURN
			END IF
			
			IF WF_RATE_CHK() = -1 THEN 
				This.Enabled = True
				RETURN 
			END IF
			
			IF	dw_list.Retrieve(gs_sabu, sBlno, sdate, is_rategub, ls_saupj ) <	1		THEN
				dw_list.setredraw(true)
				f_message_chk(50, '[입고의뢰내역]')
				dw_detail.setcolumn("blno")
				dw_detail.setfocus()
				This.Enabled = True
				RETURN
			END IF
	   ELSE
			IF isnull(slcno) or slcno = "" 	THEN
				dw_list.setredraw(true)
				f_message_chk(30,'[L/C NO]')
				dw_detail.SetColumn("lcno")
				dw_detail.SetFocus()
				This.Enabled = True
				RETURN
			END IF
			
			IF WF_RATE_CHK() = -1 THEN 
				This.Enabled = True
				RETURN 
			END IF
			
			IF	dw_list.Retrieve(gs_sabu, slcno, sdate, is_rategub, ls_saupj ) <	1		THEN
				dw_list.setredraw(true)
				f_message_chk(50, '[입고의뢰내역]')
				dw_detail.setcolumn("lcno")
				dw_detail.setfocus()
				This.Enabled = True
				RETURN
			END IF
		END IF

//		wf_Calc_Amount()
		
	END IF
	
	// 검사구분, 검사담당자
	IF wf_Danmst() = -1	THEN
		This.Enabled = True
		dw_list.setredraw(true)
		RETURN
	END IF	

	wf_Update_Gubun()
	
	
//////////////////////////////////////////////////////////////////////////	
// 수정
//////////////////////////////////////////////////////////////////////////	
ELSE
	
	IF isnull(sJpno) or sJpno = "" 	THEN
		dw_list.setredraw(true)
		f_message_chk(30,'[입고번호]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		This.Enabled = True
		RETURN
	END IF

	sJpno = sJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sjpno, ls_saupj) <	1		THEN
		dw_list.setredraw(true)
		f_message_chk(50, '[입고내역]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		This.Enabled = True
		RETURN
	END IF
	wf_Update_Gubun()
	p_del.enabled = true
	p_del.picturename = "C:\erpman\image\삭제_up.gif"
END IF
dw_list.setredraw(true)


//////////////////////////////////////////////////////////////////////////
// 사업장, 입고창고
//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	dw_detail.SetItem(1, "saupj", 	dw_list.GetItemString(1, "poblkt_saupj"))
	dw_detail.SetItem(1, "in_house", dw_list.GetItemString(1, "vendor"))
ELSE
	dw_detail.SetItem(1, "saupj", 	dw_list.GetItemString(1, "imhist_saupj"))
	dw_detail.SetItem(1, "in_house", dw_list.GetItemString(1, "imhist_depot_no"))
END IF

//////////////////////////////////////////////////////////////////////////
//dw_detail.enabled = false

dw_detail.Object.saupj.protect 	= 1
dw_detail.Object.gubun.protect 	= 1
dw_detail.Object.lcno.protect 		= 1
dw_detail.Object.empno.protect 	= 1
dw_detail.Object.in_house.protect = 1
dw_detail.Object.vendor.protect 	= 1
dw_detail.Object.jpno.protect 		= 1

dw_list.SetFocus()
p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\저장_up.gif"

This.Enabled = True

SetPointer(Arrow!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cb_1 from commandbutton within w_mat_01000
boolean visible = false
integer x = 3813
integer y = 2376
integer width = 421
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고조회"
end type

event clicked;long lRow

if dw_list.accepttext() = -1 then return 
if dw_list.rowcount() < 1 then return 

lRow = dw_list.getrow()

if lRow < 1 then 
	messagebox('확 인', '조회할 자료를 선택하세요!')
	return 
end if

gs_code = dw_list.getitemstring(lRow, 'itnbr')

IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
	f_message_chk(30,'[품번]')
	dw_list.ScrollToRow(lRow)
	dw_list.Setcolumn("itnbr")
	dw_list.setfocus()
	RETURN 
END IF

if ic_status = '1' then 
	gs_gubun = dw_list.getitemstring(lRow, 'vendor')
else
	gs_gubun = dw_list.getitemstring(lRow, 'imhist_depot_no')
end if
// 코드명이 Y가 아니면 선택할 수 없고 조회만 'Y' 이면 선택할 수 있음
gs_codename = 'N' 
open(w_stock_popup)
end event

type cb_delete from commandbutton within w_mat_01000
boolean visible = false
integer x = 722
integer y = 2956
integer width = 347
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제(&D)"
end type

event clicked;//////////////////////////////////////////////////////////////////
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
   cb_cancel.triggerevent(clicked!)
END IF

end event

type cb_cancel from commandbutton within w_mat_01000
boolean visible = false
integer x = 2459
integer y = 3040
integer width = 347
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type rb_delete from radiobutton within w_mat_01000
integer x = 4315
integer y = 300
integer width = 242
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;ic_status = '2'

dw_list.setredraw(false)

wf_Initial()

IF is_gubun = 'Y' THEN
	dw_list.dataobject = 'd_mat_01003_1'
else
	dw_list.dataobject = 'd_mat_01003'
end if

dw_list.SetTransObject(SQLCA)

dw_list.setredraw(true)


end event

type rb_insert from radiobutton within w_mat_01000
integer x = 4315
integer y = 224
integer width = 242
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;
ic_status = '1'	// 등록

dw_list.setredraw(False)

wf_Initial()

dw_list.setredraw(true)


end event

type dw_detail from datawindow within w_mat_01000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 69
integer y = 200
integer width = 4137
integer height = 176
integer taborder = 10
string dataobject = "d_mat_01000"
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
	SetItem(1,"in_house",gs_gubun)
ELSEIF this.GetColumnName() = 'jpno'	THEN
	gs_gubun = '007'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")
ELSEif this.getcolumnname() = 'balno' then
	
	SetNull(gs_gubun)
	open(w_poblkt_popup)
	setitem(1, "balno", Trim(left(gs_code, 12)))
	this.TriggerEvent("itemchanged")	
ELSEif this.getcolumnname() = 'blno' then
	open(w_bl_popup3)
	setitem(1, "blno", gs_code)
	this.TriggerEvent("itemchanged")	
ELSEIF this.GetColumnName() = 'lcno'	THEN
	gs_gubun = 'LOCAL' 
	Open(w_lc_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	THIS.SetItem(1,"lcno",	gs_code)
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = 'vendor'	THEN
   gs_gubun = '1'
	open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	this.SetItem(1, "vendor", gs_code)
	this.SetItem(1, "vendorname", gs_codename)
	this.TriggerEvent("itemchanged")	
END IF


end event

event itemchanged;string	scode, sName1,	sname2, sNull, sjpno, sdate, scust, sempno, sgubun, sbalno, sblno, &
         scustname, sempname, s_today, soldcode, sBalgu, sWaigu, sLocal, sLcno, sBalempno
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
	
// 입고창고
ELSEIF this.GetColumnName() = "saupj" THEN
//	scode = this.GetText()								
//
//	f_child_saupj(dw_detail, 'in_house',scode )
	
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
ELSEIF this.GetColumnName() = 'gubun'	THEN

	sName1   = gettext()
	is_outgu = sname1
   sOldCode = this.getitemstring(1, 'gubun')	
	
	Select maigbn, ioyea2 into :sCode, :sLocal from iomatrix
	 where sabu = :gs_sabu and iogbn = :sName1;

	dw_detail.setitem(1, "maigbn", sCode)
	IF sCode = '1'	THEN
		IF is_gubun = 'Y' THEN
			dw_list.dataobject = 'd_mat_01001_1'
		else
			dw_list.dataobject = 'd_mat_01001'
		end if		
		this.SetItem(1, "blno", sNull)
		this.SetItem(1, "lcno", sNull)
		this.settaborder("blno",  0)
		this.settaborder("lcno",  0)
		this.settaborder("balno", 40)
		this.Object.blno.visible = False
		this.Object.lcno.visible = False
		this.Object.balno.visible = True
		this.Object.t_bal.text = "발주번호"
	ELSE
	    s_today  = this.getitemstring(1, 'sdate')	
		
      IF is_RateGub = '1' then  
			 SELECT COUNT(*)
				INTO :get_count
				FROM RATEMT  
			  WHERE RDATE = :s_today  ;	
			if get_count < 1 then 		
				messagebox("확 인", "일일 환율을 먼저 입력해야 합니다.")
				this.SetItem(1, "gubun", sOldcode)
				return 1
			end if	
      ELSE
			SELECT COUNT(*)
			  INTO :get_count
			  FROM EXCHRATE_FORECAST
			 WHERE BASE_YYMM = SUBSTR(:s_today, 1, 6) ;
			
			if get_count < 1 then 		
				messagebox("확 인", "예측 환율을 먼저 입력해야 합니다.")
				this.SetItem(1, "gubun", sOldcode)
				return 1
			end if	
      END IF
		
      IF sLocal = '1' THEN //수입입고 
		
			IF is_gubun = 'Y' THEN
				dw_list.dataobject = 'd_mat_01002_1'
			else
				dw_list.dataobject = 'd_mat_01002'
			end if		
			this.SetItem(1, "balno", sNull)
			this.SetItem(1, "lcno", sNull)
			this.SetItem(1, "vendor", sNull)
			this.SetItem(1, "vendorname", snull)
			this.settaborder("blno",  50)
			this.settaborder("balno", 0)
			this.Object.blno.visible = True
			this.Object.lcno.visible = False
			this.Object.balno.visible = False
			this.Object.t_bal.text = "B/L No"
      ELSE
			IF is_gubun = 'Y' THEN
				dw_list.dataobject = 'd_mat_01005_1'
			else
				dw_list.dataobject = 'd_mat_01005'
			end if		
			
			this.SetItem(1, "balno", sNull)
			this.SetItem(1, "blno", sNull)
			this.SetItem(1, "vendor", sNull)
			this.SetItem(1, "vendorname", snull)
			this.settaborder("blno",  0)
			this.settaborder("balno", 0)
			this.settaborder("lcno", 60)
			this.Object.blno.visible = False
			this.Object.lcno.visible = True
			this.Object.balno.visible = False
			this.Object.t_bal.text = "L/C No"
      END IF
	END IF
	
//	dw_list.object.ispec_t.text = is_ispec
//	dw_list.object.jijil_t.text = is_jijil
	dw_list.SetTransObject(sqlca)
	
//////////////////////////////////////////////////////////////////////////
// 전표번호
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'jpno'	THEN

	sJpno = TRIM(this.GetText())

	IF sJPno = '' or isnull(sJpno) then 
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "balno",	sNull)
		this.SetItem(1, "blno", 	sNull)
		this.SetItem(1, "lcno", 	sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "vendor",  sNull)
		this.setitem(1, "gubun",   sNull)
		this.SetItem(1, "vendorname", sNull)
		return 
   END IF
	
	SELECT A.SUDAT,  A.CVCOD,   A.IOREEMP,
			 A.IOGBN,  A.BALJPNO, A.POBLNO, A.POLCNO, 
			 B.CVNAS2, D.EMPNAME
	  INTO :sDate, :sCust, :sEmpno, 
	  		 :sGubun, :sBalno, :sBlno, :sLcno,  
	  		 :sCustName, :sEmpName 
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
	
	// 발주번호가 없으면 구매기타입고로 등록된 자료임
	if IsNull(sbalno) or Trim(sBalno) = '' then
		MessageBox("구매기타입고", "구매기타입고로 등록된 자료입니다" + '~n'  + &
											"구매기타입고 프로그램에서 수정하십시요", information!)
		this.setitem(1, "jpno", sNull)											
		return 1		
	End if

	this.SetItem(1, "sdate",   sDate)
	this.SetItem(1, "balno",	sBalno)
	this.SetItem(1, "blno", 	sBlno)
	this.SetItem(1, "lcno", 	slcno)
	this.SetItem(1, "empno",	sEmpno)
	this.SetItem(1, "empname", sEmpname)
	this.SetItem(1, "vendor",  sCust)
	this.setitem(1, "gubun",   sgubun)
	
	Select maigbn, ioyea2 into :sCode, :sLocal from iomatrix
	 where sabu = :gs_sabu and iogbn = :sGubun;
	 
	if sqlca.sqlcode <> 0 then
		Messagebox("입고구분", "입고구분이 부정확합니다")
		return
	end if;	 
	
	IF scode = '1'	THEN	
		this.SetItem(1, "vendorname", sCustName)
		IF is_gubun = 'Y' THEN
			dw_list.DataObject = 'd_mat_01003_1'
		else
			dw_list.DataObject = 'd_mat_01003'
		end if		
	ELSE
		if slocal = '1' then 
			this.SetItem(1, "vendor", 		sNull)
			this.SetItem(1, "vendorname", sNull)
			IF is_gubun = 'Y' THEN
				dw_list.DataObject = 'd_mat_01004_1'
			else
				dw_list.DataObject = 'd_mat_01004'
			end if		
		else
			this.SetItem(1, "vendor", 		sNull)
			this.SetItem(1, "vendorname", sNull)
			IF is_gubun = 'Y' THEN
				dw_list.DataObject = 'd_mat_01006_1'
			else
				dw_list.DataObject = 'd_mat_01006'
			end if		
		end if		
	END IF
	dw_list.SetTransObject(sqlca)

////////////////////////////////////////////////////////////////////////////
//	* 발주번호 확인
////////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'balno'	THEN

	sBalno = this.GetText()
	SELECT A.BAL_SUIP, A.cvcod, B.CVNAS, A.BALGU, A.BAL_EMPNO
	  INTO :sGubun, :scust, :sCustName, :sBalgu, :sBalempno
	  FROM POMAST A, VNDMST B
	 WHERE A.SABU = :gs_sabu		AND
	 		 A.BALJPNO = :sBalno	   AND
 			 A.CVCOD = B.CVCOD(+)	;
	
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[발주번호]')
		this.setitem(1, "balno", sNull)
		this.SetItem(1, "vendor", sNull)
		this.SetItem(1, "vendorname", sNull)	
		RETURN 1
	END IF

	IF sGubun = '2'	THEN
		MessageBox("확인", "외자 발주번호는 입력할 수 없습니다.")
		this.setitem(1, "balno", sNull)
		this.SetItem(1, "vendor", sNull)
		this.SetItem(1, "vendorname", sNull)
		RETURN 1
	END IF
	
	//발주구분이 = 외주(3)인 경우에 iomatrix의 수불구분이 외주로 표시되어 있지 않으면 error
	if sBalgu   = '3' then
	   sOldCode = this.getitemstring(1, 'gubun')				
		select waigu into :sWaigu from iomatrix where sabu = '1' and iogbn = :sOldCode;		
		if sWaigu = 'Y' then
		Else
			MessageBox("확인", "외주발주 이므로 외주입고,외주가공중에서 선택하십시요.")
			this.setitem(1, "balno", sNull)
			this.SetItem(1, "vendor", sNull)
			this.SetItem(1, "vendorname", sNull)
			RETURN 1						
		end if
	End if

	/* 사번, 이름 */
	String Srfna3, srfna1, Sname
	Select rfna3, rfna1  
	  Into :Srfna3, :srfna1
	  From reffpf
	 where rfcod ='43'
		and rfgub <> '00'
		and rfgub = :sBalempno ;
	
	Select empname
	  Into :Sname
	  From p1_master
	 Where empno = :Srfna3 ;
			
		
	if sBalgu   = '1' Or sbalgu = '9' then	
		this.SetItem(1, "vendor", sCust)
		this.SetItem(1, "vendorname", sCustName)
		
		this.SetItem(1, "empno"  , Srfna3)
		this.SetItem(1, "empname", Srfna1)
	Else
		this.SetItem(1, "vendor", sCust)
		this.SetItem(1, "vendorname", sCustName)
	End If

////////////////////////////////////////////////////////////////////////////
//	* BL 번호 확인
////////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'blno'	THEN

	sBlno = this.GetText()
	
	if sBlno = '' or isnull(sblno) then return 
	
	SELECT SABU
	  INTO :sGubun
	  FROM POLCBL
	 WHERE SABU = :gs_sabu	AND
	 		 POBLNO = :sBlno	
 GROUP BY SABU ;
	
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[B/L번호]')
		this.setitem(1, "blno", sNull)
		RETURN 1
	END IF
//L/C NO 체크 	
ELSEIF this.GetColumnName() = 'lcno'	THEN

	slcno = this.GetText()
	
	if slcno = '' or isnull(slcno) then return 
	
   SELECT LOCALYN
     INTO :sgubun
     FROM POLCHD  
    WHERE SABU    = :gs_sabu
	   AND POLCNO  = :slcno  ;

	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[L/C 번호]')
		this.setitem(1, "lcno", sNull)
		RETURN 1
	ELSE
		IF sgubun <> 'Y' THEN 
			MessageBox('확 인', 'LOCAL L/C만 입력가능합니다. 자료를 확인하세요!')
			this.setitem(1, "lcno", sNull)
			RETURN 1
		END IF
 	END IF
	
END IF



end event

type cb_save from commandbutton within w_mat_01000
boolean visible = false
integer x = 361
integer y = 2956
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

event clicked;SetPointer(HourGlass!)

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
	
	// 입고창고 일괄변경
	FOR lRow = 1  TO  dw_list.RowCount()
		dw_list.SetItem(lRow, "vendor", dw_detail.GetItemString(1, "in_house"))
	NEXT
	
	IF wf_imhist_create(sdate, dseq) < 0 THEN RETURN 

	IF dw_imhist.Update() <> 1		THEN
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

cb_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)

end event

type cb_exit from commandbutton within w_mat_01000
event key_in pbm_keydown
boolean visible = false
integer x = 2825
integer y = 3040
integer width = 347
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_mat_01000
boolean visible = false
integer y = 2956
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;//retrievrow 에 error 발생할 경우를 대비하여( 두번연속 클릭못하게 하기위함 )
This.Enabled = False

if dw_detail.Accepttext() = -1	then 	return

string  	sGubun,		&
			sBalno,		&
			sBlno,		&
			sJpno,		&
			sDate,		&
			sEmpno,		&
			sNull,	smaigbn, sLcno, sLocal 
long		lRow 

SetNull(sNull)

sEmpno = dw_detail.GetItemstring(1, "empno")
sGubun = dw_detail.getitemstring(1, "gubun")
sBalno = dw_detail.getitemstring(1, "balno")
sBlno	 = dw_detail.getitemstring(1, "blno")
slcno	 = dw_detail.getitemstring(1, "lcno")
sJpno  = dw_detail.getitemstring(1, "jpno")

Select maigbn, ioyea2 into :sMaigbn, :sLocal from iomatrix
 where sabu = :gs_sabu and iogbn = :sGubun;
 
if sqlca.sqlcode <> 0 then
	Messagebox("입고구분", "입고구분이 부정확합니다")
	This.Enabled = True
	return
end if;

sDate =  trim(dw_detail.GetItemString(1, "sdate"))

SetPointer(HourGlass!)  
dw_list.setredraw(false)
//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	IF isnull(sDate) or sDate = "" 	THEN
		dw_list.setredraw(true)
		f_message_chk(30,'[입고의뢰일자]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
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

	IF sMaigbn = '1'		THEN		// 내자입고(수입아님)
	
		IF isnull(sBalno) or sBalno = "" 	THEN
			dw_list.setredraw(true)
			f_message_chk(30,'[발주번호]')
			dw_detail.SetColumn("balno")
			dw_detail.SetFocus()
			This.Enabled = True
			RETURN
		END IF
		
		IF	dw_list.Retrieve(gs_sabu, sBalno, sdate, is_rategub ) <	1		THEN
			dw_list.setredraw(true)
			f_message_chk(50, '[입고의뢰내역]')
			dw_detail.setcolumn("balno")
			dw_detail.setfocus()
			This.Enabled = True
			RETURN
		END IF

	ELSE
	   IF sLocal = '1' THEN 
			IF isnull(sBlno) or sBlno = "" 	THEN
				dw_list.setredraw(true)
				f_message_chk(30,'[B/L NO]')
				dw_detail.SetColumn("blno")
				dw_detail.SetFocus()
				This.Enabled = True
				RETURN
			END IF
			
			IF WF_RATE_CHK() = -1 THEN 
				This.Enabled = True
				RETURN 
			END IF
			
			IF	dw_list.Retrieve(gs_sabu, sBlno, sdate, is_rategub ) <	1		THEN
				dw_list.setredraw(true)
				f_message_chk(50, '[입고의뢰내역]')
				dw_detail.setcolumn("blno")
				dw_detail.setfocus()
				This.Enabled = True
				RETURN
			END IF
	   ELSE
			IF isnull(slcno) or slcno = "" 	THEN
				dw_list.setredraw(true)
				f_message_chk(30,'[L/C NO]')
				dw_detail.SetColumn("lcno")
				dw_detail.SetFocus()
				This.Enabled = True
				RETURN
			END IF
			
			IF WF_RATE_CHK() = -1 THEN 
				This.Enabled = True
				RETURN 
			END IF
			
			IF	dw_list.Retrieve(gs_sabu, slcno, sdate, is_rategub ) <	1		THEN
				dw_list.setredraw(true)
				f_message_chk(50, '[입고의뢰내역]')
				dw_detail.setcolumn("lcno")
				dw_detail.setfocus()
				This.Enabled = True
				RETURN
			END IF
		END IF

//		wf_Calc_Amount()
		
	END IF
	
	// 검사구분, 검사담당자
	IF wf_Danmst() = -1	THEN
		This.Enabled = True
		dw_list.setredraw(true)
		RETURN
	END IF	

	wf_Update_Gubun()
	
	
//////////////////////////////////////////////////////////////////////////	
// 수정
//////////////////////////////////////////////////////////////////////////	
ELSE
	
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
	cb_delete.enabled = true
END IF
dw_list.setredraw(true)


//////////////////////////////////////////////////////////////////////////
// 사업장, 입고창고
//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	dw_detail.SetItem(1, "saupj", 	dw_list.GetItemString(1, "poblkt_saupj"))
	dw_detail.SetItem(1, "in_house", dw_list.GetItemString(1, "vendor"))
ELSE
	dw_detail.SetItem(1, "saupj", 	dw_list.GetItemString(1, "imhist_saupj"))
	dw_detail.SetItem(1, "in_house", dw_list.GetItemString(1, "imhist_depot_no"))
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.enabled = false

dw_list.SetFocus()
cb_save.enabled = true
This.Enabled = True

SetPointer(Arrow!)
end event

type dw_list from datawindow within w_mat_01000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 416
integer width = 4503
integer height = 1016
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mat_01001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;dec {2}	  dBalRate
dec {3}  dQty,  dCinqty, dtemp, DtEMP1, dInqty, ld_ioreqty
long		lRow, ireturn
Decimal  maprc
string	sVendor, sVendorName, 	&
			sQcGubun, sQcEmpno,		&
			sItem,	sNull, sDate, sGubun, sWigbn, sKumno, ls_pspec, ls_pordno, ls_gbn, scode, slocal
SetNull(sNull)

lRow  = this.GetRow()	

/* 입고형태가 외주인지 check	*/
if lrow > 0  and ic_status = '2' and getcolumnname() = 'qcgubun' then
	sItem = this.getitemstring(lrow, "qcgubun")
	sGubun = dw_detail.GetItemString(1, "gubun")	
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sGubun;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		f_message_chk(311,'[외주여부]')
		return -1
	end if
	if sWigbn = 'Y' then
		Messagebox("검사구분", "외주인 경우 검사구분은 수정할 수 없읍니다!" + '~n' + &
									  "삭제후 재 입력 하십시요", stopsign!)
		dw_list.setitem(Lrow, "qcgubun", sitem)
		return 1
	end if
end if

this.accepttext()

// 입고수량 > 입고잔량 이면 ERROR(신규입력시)
IF this.GetColumnName() = "inqty" then
	
	dInqty   = dec(this.GetText())
	dQty     = this.GetItemDecimal(lRow, "balju")
	dBalRate = this.GetItemDecimal(lRow, "itemas_balrate")
	ls_pordno = this.GetItemString(lRow, "poblkt_pordno")
	
   if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100
   
	ls_gbn   = dw_detail.getitemstring(1, 'gubun')	

	Select maigbn, ioyea2 into :sCode, :sLocal from iomatrix
	 where sabu = :gs_sabu and iogbn = :ls_gbn;
	
	//입고 형태가 내자인 경우만..
	If sCode = '1' Then
		ld_ioreqty = this.GetItemDecimal(lRow, "ioreqty")
		dtemp	= dQty - ld_ioreqty
	End If
	
	IF dInqty > truncate(dQty * dBalRate / 100, 3)	THEN
		MessageBox("확인", "입고수량" + string(dinqty, '#,##0.000') + " 은 발주(B/L)잔량" &
		                 + string(dqty, '#,##0.000') +  "* 허용률  보다 클 수 없습니다.")
		this.SetItem(lRow, "cinqty", 	0)
		this.SetItem(lRow, "inqty", 	0)
		this.Setfocus()
		RETURN 1
	//입고 수량이 발주수량 - 검사대기 수량보다 크면 ERROR(등록시)
	ELSEIF dInqty > truncate(dtemp, 3)	and ls_pordno <> '' and not (isnull(ls_pordno)) THEN
		MessageBox("확인", "입고수량 " + string(dinqty, '#,##0.000') + " 은 발주수량 - 검사대기수량 " + string(dtemp, '#,##0.000') &
		                 + " 보다 클 수 없습니다.")
		this.SetItem(lRow, "cinqty", 	0)
		this.SetItem(lRow, "inqty", 	0)
		this.Setfocus()
		RETURN 1
	ELSE
		if getitemdecimal(lrow, "poblkt_cnvfat") = 1 then
			this.setitem(Lrow, "cinqty", dinqty)
		Elseif getitemstring(Lrow, "poblkt_cnvart") = '*' then
			this.setitem(Lrow, "cinqty", Round(dinqty / getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
		else
			this.setitem(Lrow, "cinqty", Round(dinqty * getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
		end if
	END IF
	
	// 금액계산
	this.SetItem(Lrow, "inamt", Truncate(dinqty * (getitemdecimal(Lrow, "balamt") / getitemdecimal(Lrow, "balqty")), 0))
ElseIF this.GetColumnName() = "cinqty" then
	
	dcInqty = dec(this.GetText())

	dQty   = this.GetItemDecimal(lRow, "cnv_balju")
	dBalRate = this.GetItemDecimal(lRow, "itemas_balrate")
	
   if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100

	IF dcInqty > truncate(dQty * dBalRate / 100, 3)	THEN
		MessageBox("확인", "입고수량은 발주(B/L)잔량 * 허용률 보다 클 수 없습니다.")
		this.SetItem(lRow, "inqty", 	0)
		this.SetItem(lRow, "cinqty", 	0)
		this.Setfocus()
		RETURN 1
	//발주단위 => 이전 입고 + 현재 입고분 = 발주수량 인 경우  입고기준수량을 강제로 맞춰줌
	ELSEIF dcInqty = dQty AND is_gubun = 'Y' THEN 
		ireturn = wf_set_janqty(lRow, '1')
		
	   if ireturn = -1 then 
			this.SetItem(lRow, "cinqty", 	0)
			this.SetItem(lRow, "inqty", 	0)
			this.Setfocus()
			RETURN 1
		elseif ireturn = 0 then 
			if getitemdecimal(lrow, "poblkt_cnvfat") = 1 then
				this.setitem(Lrow, "inqty", dcinqty)
			elseif getitemstring(Lrow, "poblkt_cnvart") = '*' then
				this.setitem(Lrow, "inqty", Round(dcInqty * getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
			else
				this.setitem(Lrow, "inqty", Round(dcinqty / getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
			end if	
      end if			
	ELSE
		if getitemdecimal(lrow, "poblkt_cnvfat") = 1 then
			this.setitem(Lrow, "inqty", dcinqty)
		elseif getitemstring(Lrow, "poblkt_cnvart") = '*' then
			this.setitem(Lrow, "inqty", Round(dcInqty * getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
		else
			this.setitem(Lrow, "inqty", Round(dcinqty / getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
		end if	
	END IF	
// 입고수량 > 입고잔량 이면 ERROR(수정시)
ELSEIF this.GetColumnName() = "imhist_ioreqty" then
	
	dInqty = dec(this.GetText())
	dQty   = this.GetItemDecimal(lRow, "balju")
	dTemp  = this.GetItemDecimal(lRow, "temp_qty")
	dTemp1 = this.GetItemDecimal(lRow, "temp_qty1")

	dBalRate = this.GetItemDecimal(lRow, "itemas_balrate")
   if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100

	IF dInqty > truncate((dQty + dTemp) * dBalRate / 100, 3)	THEN
		MessageBox("확인", "수정 할 입고수량은 (발주(B/L)잔량 + 입고수량) * 허용률  보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_cnviore", dtemp1)
		this.SetItem(lRow, "imhist_ioreqty", dtemp)
		RETURN 1
	ELSE
		if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
			this.setitem(Lrow, "imhist_cnviore", dinqty)
		elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
			this.setitem(Lrow, "imhist_cnviore", Round(dinqty / getitemdecimal(Lrow, "imhist_cnvfat"), 3))
		else
			this.setitem(Lrow, "imhist_cnviore", Round(dinqty * getitemdecimal(Lrow, "imhist_cnvfat"), 3))
		end if	
	END IF

ELSEIF this.GetColumnName() = "imhist_cnviore" then
	
	dCinqty = dec(this.GetText())
	
	dQty    = this.GetItemDecimal(lRow, "cnv_balju")
	dTemp   = this.GetItemDecimal(lRow, "temp_qty")	
	dTemp1  = this.GetItemDecimal(lRow, "temp_qty1")		
	
	dBalRate = this.GetItemDecimal(lRow, "itemas_balrate")
   if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100

	IF dcInqty > truncate((dQty + dTemp1) * dBalRate / 100, 3)	THEN
		MessageBox("확인", "수정 할 입고수량은 (발주(B/L)잔량 + 입고수량) * 허용률  보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_ioreqty", dtemp)
		this.SetItem(lRow, "imhist_cnviore", dtemp1)
		RETURN 1
	//발주단위 => 이전 입고 + 현재 입고분 = 발주수량 인 경우  입고기준수량을 강제로 맞춰줌
	ELSEIF dcInqty = dQty + dTemp1 AND is_gubun = 'Y' THEN  
		ireturn = wf_set_janqty(lRow, '2')
		
	   if ireturn = -1 then 
			this.SetItem(lRow, "imhist_ioreqty", dtemp)
			this.SetItem(lRow, "imhist_cnviore", dtemp1)
			this.Setfocus()
			RETURN 1
		elseif ireturn = 0 then 
			if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
				this.setitem(Lrow, "imhist_ioreqty", dcinqty)	
			elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
				this.setitem(Lrow, "imhist_ioreqty", Round(dcinqty * getitemdecimal(Lrow, "imhist_cnvfat"), 3))
			else
				this.setitem(Lrow, "imhist_ioreqty", Round(dcinqty / getitemdecimal(Lrow, "imhist_cnvfat"), 3))
			end if	
      end if			
	ELSE
		if getitemdecimal(lrow, "imhist_cnvfat") = 1 then
			this.setitem(Lrow, "imhist_ioreqty", dcinqty)	
		elseif getitemstring(Lrow, "imhist_cnvart") = '*' then
			this.setitem(Lrow, "imhist_ioreqty", Round(dcinqty * getitemdecimal(Lrow, "imhist_cnvfat"), 3))
		else
			this.setitem(Lrow, "imhist_ioreqty", Round(dcinqty / getitemdecimal(Lrow, "imhist_cnvfat"), 3))
		end if	
	END IF	
	
//////////////////////////////////////////////////////////////////////////
// 입고처(신규입력시)
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "vendor" THEN
	
	sVendor = this.GetText()								
   SELECT CVNAS
     INTO :sVendorName
     FROM VNDMST 
    WHERE CVCOD = :sVendor 	AND
	 		 CVGU  = '5' 	AND
			 CVSTATUS = '0' ;
			  
	IF sqlca.sqlcode = 100 	THEN
		this.SEtItem(lRow, "vendor", sNull)
		this.setitem(lRow, 'vendorname', sNull)
	   return 1
	ELSE
		this.setitem(lRow, 'vendorname', sVendorName)
   END IF
// 입고처(수정시)
ELSEIF this.GetColumnName() = "imhist_depot_no" THEN
	
	sVendor = this.GetText()								
   SELECT CVNAS
     INTO :sVendorName
     FROM VNDMST 
    WHERE CVCOD = :sVendor AND
	 		 CVGU IN ('4','5') ;
	 		 
	IF sqlca.sqlcode = 100 	THEN
		this.SEtItem(lRow, "imhist_depot_no", sNull)
	   return 1
	ELSE
		this.setitem(lRow, 'vendorname', sVendorName)
   END IF
// 검사요청일(신규입력시)
ELSEIF this.GetColumnName() = 'qcdate' THEN
	sDate  = this.gettext()
	
	IF sDate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1 then
		this.setitem(lRow, "qcdate", sNull)
		return 1
	END IF
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
		if ic_status = '1' then //등록시 
			this.setitem(lRow, "qcdate", sNull)
		else
			this.setitem(lRow, "imhist_gurdat", sNull)
		end if
	else
		if ic_status = '1' then //등록시 
			this.setitem(lRow, "qcdate", is_today)
		else
			this.setitem(lRow, "imhist_gurdat", is_today)
		end if
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
ELSEIF this.GetColumnName() = 'poblkt_pspec' THEN
	ls_pspec  = trim(this.gettext())
	
	IF ls_pspec = '' OR Isnull(ls_pspec) then return 
	
   	maprc = sqlca.fun_danmst_danga10( dw_detail.GetItemString(1,'sdate'), dw_list.GetItemString( row, 'cvcod'), + &
	                       dw_list.GetItemString( row, 'itnbr'), ls_pspec)
		 		 
	IF maprc <>  0	THEN
		this.SetItem(lRow, "unprc", maprc )
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

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 입고처(입력시 창고)
IF this.GetColumnName() = 'vendor'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"vendor",		gs_code)
	SetItem(lRow,"vendorname", gs_codename)
	this.TriggerEvent("itemchanged")

// 입고처(수정시 창고)
ELSEIF this.GetColumnName() = 'imhist_depot_no'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"imhist_depot_no", gs_code)
	SetItem(lRow,"vendorname", gs_codename)
//	this.TriggerEvent("itemchanged")

	/* 금형번호 */
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

//// 입고수량
//IF this.getcolumnname() = "inqty"		THEN
//
//	this.AcceptText()
//	dQty   = this.getitemdecimal(lRow, "inqty") 
//	dPrice = this.getitemdecimal(lRow, "unprc")
//	
//   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
//
//ELSEIF this.getcolumnname() = "imhist_ioreqty"		THEN
//
//	this.AcceptText()
//	dQty   = this.getitemdecimal(lRow, "imhist_ioreqty") 
//	dPrice = this.getitemdecimal(lRow, "imhist_ioprc")
//	
//   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
//
//ELSE
IF this.getcolumnname() = "unprc"		THEN
	this.AcceptText()
	dQty   = this.getitemdecimal(lRow, "inqty") 
	dPrice = this.getitemdecimal(lRow, "unprc")
	
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

event doubleclicked;//string sdate
//Decimal dseq
//
//IF RowCount() < 1			THEN 	RETURN 
//IF dw_detail.AcceptText() = -1	THEN	RETURN
//IF AcceptText() = -1		THEN	RETURN
//
//If rb_delete.Checked Then Return
//
//IF	wf_CheckRequiredField() = -1		THEN	RETURN 
//
//IF wf_imhist_create(sdate, dseq) < 0 THEN RETURN
//
//if dw_imhist.RowCount() > 0 then
//	dw_imhist.SetRow(1)
//	dw_imhist.SetColumn('lotsno')	
//	dw_imhist.SetFocus()
//end if
end event

event rowfocuschanged;//Long nRow, ix
//String sBaljpno
//Dec    dBalseq, dBalju, dLot, dJan
//
//nRow = GetRow()
//If currentrow <= 0 Then Return
//
//// 등록일 경우만 해당
//If ic_status <> '1' Then Return
//
//sBaljpno = GetItemString(currentrow, 'baljpno')
//dBalseq = GetItemNumber(currentrow, 'balseq')
//
//dw_lot.SetFilter("baljpno = '" + sBaljpno + "' and balseq = " + string(dbalseq))
//dw_lot.filter()
//
//If dw_lot.RowCount() <= 0 Then
//	dBalju =GetItemNumber(currentrow, 'balju')
//	dLot = GetItemNumber(currentrow, 'itemas_minqt')
//	If IsnUll(dLot) Or dLot = 0 Then dLot = dBalju
//	
//	dJan = dBalju
//	Do
//		// 잔량이 lot size보다 작을 경우
//		If dLot > dJan Then	dLot = dJan
//		
//		ix = dw_lot.InsertRow(0)
//		dw_lot.SetItem(ix, 'baljpno', sBaljpno)
//		dw_lot.SetItem(ix, 'balseq', dBalseq)
//		dw_lot.SetItem(ix, 'ioreqty', dLot)
//		
//		dJan = dJan - dLot
//	Loop While ( dJan > 0 )
//End If
end event

event clicked;Long nRow, ix
String sBaljpno
Dec    dBalseq, dBalju, dLot, dJan

nRow = row
If nRow <= 0 Then
	SelectRow(0,false)
	Return
Else
	SelectRow(0,false)
	SelectRow(nRow,true)
End If

// 등록일 경우만 해당
If ic_status <> '1' Then Return

sBaljpno = GetItemString(nRow, 'baljpno')
dBalseq = GetItemNumber(nRow, 'balseq')

dw_lot.SetFilter("baljpno = '" + sBaljpno + "' and balseq = " + string(dbalseq))
dw_lot.filter()

If dw_lot.RowCount() <= 0 Then
	dBalju =GetItemNumber(nRow, 'balju')
	dLot = GetItemNumber(nRow, 'itemas_minqt')
	If IsnUll(dLot) Or dLot = 0 Then dLot = dBalju
	
	dJan = dBalju
	Do
		// 잔량이 lot size보다 작을 경우
		If dLot > dJan Then	dLot = dJan
		
		ix = dw_lot.InsertRow(0)
		dw_lot.SetItem(ix, 'baljpno', sBaljpno)
		dw_lot.SetItem(ix, 'balseq', dBalseq)
		dw_lot.SetItem(ix, 'ioreqty', dLot)
		
		dJan = dJan - dLot
	Loop While ( dJan > 0 )
End If
end event

type rr_1 from roundrectangle within w_mat_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 184
integer width = 4197
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_mat_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4256
integer y = 184
integer width = 325
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_mat_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 408
integer width = 4526
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_imhist from datawindow within w_mat_01000
boolean visible = false
integer x = 498
integer y = 28
integer width = 2784
integer height = 144
boolean bringtotop = true
boolean titlebar = true
string title = "Lot Size별 입고내역 작성"
string dataobject = "d_pdt_imhist"
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

type dw_imhist_out from datawindow within w_mat_01000
boolean visible = false
integer x = 576
integer y = 816
integer width = 471
integer height = 248
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

type dw_lot from u_key_enter within w_mat_01000
integer x = 59
integer y = 1440
integer width = 3246
integer height = 812
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mat_01000_1"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;Post wf_select_qty(row)
end event

event buttonclicked;call super::buttonclicked;Long nRow, nFind

nFind = dw_list.GetSelectedRow(0)
If nFind <= 0 Then Return

If row <= 0 Then Return

If dwo.name = 'b_1' Then
	nRow = dw_lot.InsertRow(9999)
	dw_lot.SetItem(nRow, 'baljpno', dw_list.GetItemString(nFind, 'baljpno'))
	dw_lot.SetItem(nRow, 'balseq',  dw_list.GetItemNumber(nFind, 'balseq'))
End If

If dwo.name = 'b_2' Then
	SetItem(row, 'chk','N')
	wf_select_qty(row)
	DeleteRow(row)
End If
end event

type dw_bond from datawindow within w_mat_01000
boolean visible = false
integer y = 764
integer width = 2921
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_bondhst"
boolean border = false
boolean livescroll = true
end type

