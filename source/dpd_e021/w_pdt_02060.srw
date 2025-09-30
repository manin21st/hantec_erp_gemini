$PBExportHeader$w_pdt_02060.srw
$PBExportComments$**작업지시조정
forward
global type w_pdt_02060 from w_inherite
end type
type dw_head from datawindow within w_pdt_02060
end type
type tab_1 from tab within w_pdt_02060
end type
type tabpage_1 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_1
end type
type dw_momast from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_2 rr_2
dw_momast dw_momast
end type
type tabpage_2 from userobject within tab_1
end type
type cb_1 from commandbutton within tabpage_2
end type
type rr_3 from roundrectangle within tabpage_2
end type
type rr_5 from roundrectangle within tabpage_2
end type
type rr_4 from roundrectangle within tabpage_2
end type
type st_2 from statictext within tabpage_2
end type
type dw_poblkt from datawindow within tabpage_2
end type
type dw_estima from datawindow within tabpage_2
end type
type dw_morout from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_1 cb_1
rr_3 rr_3
rr_5 rr_5
rr_4 rr_4
st_2 st_2
dw_poblkt dw_poblkt
dw_estima dw_estima
dw_morout dw_morout
end type
type tabpage_3 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_3
end type
type dw_low from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_1 rr_1
dw_low dw_low
end type
type tabpage_4 from userobject within tab_1
end type
type dw_etc from u_key_enter within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_etc dw_etc
end type
type tab_1 from tab within w_pdt_02060
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_1 from datawindow within w_pdt_02060
end type
type p_low from uo_picture within w_pdt_02060
end type
type p_move from uo_picture within w_pdt_02060
end type
type p_1 from uo_picture within w_pdt_02060
end type
type cbx_1 from checkbox within w_pdt_02060
end type
type cbx_2 from checkbox within w_pdt_02060
end type
end forward

shared variables

end variables

global type w_pdt_02060 from w_inherite
integer height = 2436
string title = "작업지시조정"
dw_head dw_head
tab_1 tab_1
dw_1 dw_1
p_low p_low
p_move p_move
p_1 p_1
cbx_1 cbx_1
cbx_2 cbx_2
end type
global w_pdt_02060 w_pdt_02060

type variables

end variables

forward prototypes
public function integer wf_delete_chk (string ar_pordno)
public function integer wf_delete (string ar_pordno)
public function integer wf_required_chk_dtl ()
public subroutine wf_recheck ()
public subroutine wf_modify_check (long lgetrow)
public subroutine wf_reset ()
public function integer wf_cancel_check (string ar_pordno, string ar_msg)
end prototypes

public function integer wf_delete_chk (string ar_pordno);long  	get_count
string	status


//작업지시 승인여부 체크(승인은 삭제안되고 대기상태에서 삭제가능)
SELECT MATCHK
  INTO :status
  FROM MOMAST
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[작업지시 승인자료]')
	return -1 
else
	// 막음 LJJ
//	if status = '2' then 
//		messagebox("삭제불가", "작업지시 승인된 자료입니다. 대기상태만이 삭제가능합니다.!")
//		Return -1
//	end if	
end if	 

 //작업지시 대 수주 체크
SELECT COUNT(*)  
  INTO :get_count  
  FROM MOMORD  
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) AND  
		 ( HQTY   > 0 )   ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[작업지시 대 수주]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "수주에 연결된 자료가 할당수량이 존재합니다. 수주연결을 확인하세요!")
		Return -1
	end if	
end if	

//작업실적 체크
SELECT COUNT(*)  
  INTO :get_count  
  FROM SHPACT  
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[작업실적]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "작업실적 자료가 존재합니다. 작업실적을 확인하세요!")
		Return -1
	end if	
end if	

//할당 체크(수량이 있는 건수만) 
SELECT COUNT(*)  
  INTO :get_count  
  FROM HOLDSTOCK A
 WHERE ( A.SABU    = :gs_sabu  ) AND  ( A.PORDNO  = :ar_pordno ) AND 
       ( A.ISQTY   > 0   ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[할당]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "할당에 자료가 존재합니다. 할당을 확인하세요!")
		Return -1
	end if	
end if	

//입고 체크(IMHIST)
SELECT COUNT(*)  
  INTO :get_count  
  FROM IMHIST
 WHERE ( SABU    = :gs_sabu  ) AND
       ( IOGBN   = 'I10' ) AND
		 ( JAKJINO = :ar_pordno ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[입고]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "입고(IMHIST)에 자료가 존재합니다. 입고를 확인하세요!")
		Return -1
	end if	
end if	

SELECT COUNT(*) 
  INTO :get_count  
  FROM IMHIST A
 WHERE A.SABU    = :gs_sabu
   AND A.JAKJINO  = :ar_pordno 
   AND A.JNPCRT  = '002' ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[자재출고]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "창고이동(IMHIST)된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	

//외주발주인 경우 구매의뢰가 되었으면 삭제 못함 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[구매의뢰]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "구매 의뢰 검토된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//구매의뢰인 경우 의뢰가 되었으면 삭제 못함 - 범한추가 - 2001.07.21 - 송병호 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[구매의뢰]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "구매 의뢰 검토된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	


//외주발주인 경우 발주가 되었으면 삭제 못함 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[발주자료]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "발주된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//구매발주인 경우 발주가 되었으면 삭제 못함 - 범한추가 - 2001.07.21 - 송병호 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[발주자료]')
	return -1 
else
	if get_count > 0 then 
		messagebox("삭제불가", "발주된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	
		
return 1

end function

public function integer wf_delete (string ar_pordno);DELETE FROM "MOMORD"  
 WHERE ( "SABU" = :gs_sabu ) AND  
		 ( "PORDNO" = :ar_pordno )   ;

if sqlca.sqlcode < 0 then 
	messagebox("삭제실패", "삭제작업을 실패하였습니다. [작업지시 대 수주]", StopSign!)
   return -1
end if

DELETE FROM "MOROUT"  
 WHERE ( "MOROUT"."SABU" = :gs_sabu ) AND  
		 ( "MOROUT"."PORDNO" = :ar_pordno )   ;

if sqlca.sqlcode < 0 then 
	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		
	messagebox("삭제실패", "삭제작업을 실패하였습니다. [작업지시 공정상세]", StopSign!)
   return -1
end if

/* 작업지시 관련 인원 내역 */
DELETE FROM "MOROUT_ETC"  
 WHERE ( "MOROUT_ETC"."SABU" = :gs_sabu ) AND  
		 ( "MOROUT_ETC"."PORDNO" = :ar_pordno )   ;


DELETE FROM "HOLDSTOCK"  
 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND  
		 ( "HOLDSTOCK"."PORDNO" = :ar_pordno )   ;

if sqlca.sqlcode < 0 then 
	messagebox("삭제실패", "삭제작업을 실패하였습니다. [할당]", StopSign!)
   return -1
end if

DELETE FROM "ESTIMA"  
 WHERE ( "ESTIMA"."SABU" = :gs_sabu ) AND  
       ( "ESTIMA"."PORDNO" = :ar_pordno )   ;
		 
if sqlca.sqlcode < 0 then 
	messagebox("삭제실패", "삭제작업을 실패하였습니다. [외주발주]", StopSign!)
   return -1
end if

DELETE FROM "ESTIMA"  
 WHERE ( "ESTIMA"."SABU" = :gs_sabu ) AND  
       ( "ESTIMA"."GU_PORDNO" = :ar_pordno )   ;
		 
if sqlca.sqlcode < 0 then 
	messagebox("삭제실패", "삭제작업을 실패하였습니다. [구매의뢰]", StopSign!)
   return -1
end if

return 1
end function

public function integer wf_required_chk_dtl ();String sCvcod, sPordno, sOpseq, sIogbn, sPdtgu, snull, sItnbr, sPspec, &
		 sDepot, sDate, sFedat, sEstno, sJpno, sWidpt, sWiemp, sEmpno, sGiempno, sIpgo
string saccod, spdtbu, ssaupj, sbuseo, spdtmain, spdtemp
Decimal {3} dPrice, dPdqty, dSeq
Long i

Setnull(sNull)
sDate = f_today()

// 외주의뢰해야할 자료가 있는지 check하여 전표번호 채번
FOR i = 1 TO tab_1.tabpage_2.dw_morout.RowCount()
	
	// 수정불가 내역은 return
	if tab_1.tabpage_2.dw_morout.getitemstring(i,"mgbn") = 'N' then continue
	
	// 자료갱신(외주구분이 변경되고 외주로 변경된 내역이 있는 경우 */
	if tab_1.tabpage_2.dw_morout.getitemstring(i,"morout_purgc") <> tab_1.tabpage_2.dw_morout.getitemstring(i,"old_purgc") then
		if tab_1.tabpage_2.dw_morout.getitemstring(i,"morout_purgc") = 'Y' then
			
			/* 의뢰부서및 의뢰담당자는 환경설정에서 가져옴 */
			/* 외주의뢰부서 */
			select dataname
			  into :swidpt
			  from syscnfg
			 where sysgu = 'Y' and serial = '11' and lineno = '1';
			/* 외주의뢰담당자 */
			select dataname
			  into :swiemp
			  from syscnfg
			 where sysgu = 'Y' and serial = '11' and lineno = '2';			
			 
			/* 구매관리 담당자가 없는 경우 기본 담당자를 환경설정에서 가져옴 */
			select dataname
			  into :sgiempno
			  from syscnfg
			 where sysgu = 'Y' and serial = '18' and lineno = '1';			 

			dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')
			IF dSeq < 0		THEN
				ROLLBACK;
				f_message_chk(51,'')
				RETURN -1
			END IF
			COMMIT;
			////////////////////////////////////////////////////////////////////////
			sJpno  = sDate + string(dSeq, "0000")			
			
			Exit
		End if
	end if
Next


FOR i = 1 TO tab_1.tabpage_2.dw_morout.RowCount()
	
	sPordno = tab_1.tabpage_2.dw_morout.getitemstring(i, "momast_pordno")
	sPdtgu  = tab_1.tabpage_2.dw_morout.getitemstring(i, "momast_pdtgu")	
	sItnbr  = tab_1.tabpage_2.dw_morout.getitemstring(i, "momast_itnbr")	
	sPspec  = tab_1.tabpage_2.dw_morout.getitemstring(i, "momast_pspec")
	sIpgo   = tab_1.tabpage_2.dw_morout.getitemstring(i, "momast_ipchango")	
	dPdqty  = tab_1.tabpage_2.dw_morout.getitemDecimal(i, "momast_pdqty")	
	
	sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_opseq")
	sFedat  = tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_fedat")	
	dPrice  = tab_1.tabpage_2.dw_morout.getitemDecimal(i, "morout_wiunprc")	
	
   if isnull(tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wkctr')) or &
		tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wkctr') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 작업장]')
		tab_1.tabpage_2.dw_morout.ScrollToRow(i)
		tab_1.tabpage_2.dw_morout.SetColumn('morout_wkctr')
		tab_1.tabpage_2.dw_morout.SetFocus()
		return -1
   end if	
   if isnull(tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_jocod')) or &
		tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_jocod') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 작업장(조)]')
		tab_1.tabpage_2.dw_morout.ScrollToRow(i)
		tab_1.tabpage_2.dw_morout.SetColumn('morout_wkctr')
		tab_1.tabpage_2.dw_morout.SetFocus()
		return -1
   end if		
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") = 'Y' then
		if isnull(tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wicvcod')) or &
			tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wicvcod') = "" then
			f_message_chk(1400,'[ '+string(i)+' 행 외주처]')
			tab_1.tabpage_2.dw_morout.ScrollToRow(i)
			tab_1.tabpage_2.dw_morout.SetColumn('morout_wicvcod')
			tab_1.tabpage_2.dw_morout.SetFocus()
			return -1
		else
			sCvcod = tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wicvcod')
		end if			
	end if
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") = 'Y' then
		if isnull(tab_1.tabpage_2.dw_morout.GetItemdecimal(i,'morout_wiunprc')) or &
			tab_1.tabpage_2.dw_morout.GetItemDecimal(i,'morout_wiunprc') = 0 then
			f_message_chk(1400,'[ '+string(i)+' 행 외주단가]')
			tab_1.tabpage_2.dw_morout.ScrollToRow(i)
			tab_1.tabpage_2.dw_morout.SetColumn('morout_wiunprc')
			tab_1.tabpage_2.dw_morout.SetFocus()
		return -1
		end if			
	end if	
	
	// 수정불가 내역은 return
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "mgbn") = 'N' then continue	
	
	// 자료갱신(외주구분이 변경된 경우에만 처리한다 */
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") <> tab_1.tabpage_2.dw_morout.getitemstring(i, "old_purgc") then
		// 내작에서 외주로 변경된 경우
		// 1. Estima(구매의뢰를 생성한다)
		// 2. Holdstock(생산출고를 사급출고로 변경한다)
		if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") = 'Y' then
			sEstno = sJpno + String(i, '000')
				
			// 구매담당자 생성 
			sEtnull(sEmpno)			
			Select emp_id into :sEmpno from vndmst where cvcod = :sCvcod;
			if isnull( sEmpno ) then sEmpno = sGiempno
		
      	// 품목별 계정코드 가져오기 
 			saccod = sqlca.fun_get_itnacc(sitnbr, '5');			
			 
			// 생산팀을 기준으로 인사부서를 검색한 후 있으면 생산팀 부서로 사용하고 없으면 환경설정 이용
			Setnull(spdtbu)
			Select rfna3, rfna4 into :spdtbu, :ssaupj
			  from reffpf
			 where rfcod = '03' And rfgub = :sPdtgu;

			if isnull( spdtbu ) then
				sbuseo = spdtbu
			Else
				sbuseo = swidpt
			end if;

			if isnull( ssaupj ) then ssaupj = '1'

			// 인사부서를 기준으로 부서장을 검색한 후 있으면 의뢰담당자로 사용하고 없으면 환경설정 이용
			Setnull( spdtmain )
			Select empno into :spdtmain
			  from p0_dept
			 where deptcode = :sbuseo;

			if isnull( spdtmain ) then
				spdtemp = spdtbu;
			Else
				spdtemp = swiemp;
			end if;			 
			
			// 외주의뢰 생성
			INSERT INTO ESTIMA
			  (SABU,				ESTNO,			ESTGU,			ITNBR,			PSPEC,
			  	UNPRC,			CVCOD,			GUQTY,			VNQTY,			WIDAT,
				YODAT,			BLYND,			RDATE,			RDPTNO,			ORDER_NO,
				REMPNO,			SEMPNO,			PROJECT_NO,		ITGU,				PLNCRT,
				YONGDO,			IPDPT,			PRCGU,			TUNCU,			GURMKS,
				SAKGU,			CHOYO,			BALJUTIME,		OPSEQ,			SUIPGU,
				BALJPNO,			BALSEQ,			PORDNO,			AUTCRT,			CNVQTY,
				CNVART,			CNVFAT,			CNVPRC,        jestno,			yebi1,
				 yebi2,			saupj,			kumno,			mchno,			gubun,	seqno) 
			VALUES
			  (:gs_sabu,		:sEstno,			'3',				:sitnbr,			:sPspec,
				:dPrice,			:sCvcod,			:dpdqty,			:dpdqty,			:sDate,
				:sFedat,			'1',				:sDate,			:sbuseo,			null,
				:spdtemp,		:sEmpno,			null,				'6',				'1',
				'내작->외주',	:sIpgo,			'1',				'WON',			null,
				'N',				'N',				null,				:sOpseq,			'1',
				null,				0,					:sPordno,		'N',				:dpdqty,
				'*',				1,					:dPrice,   		null,				:saccod,
				 null,			:ssaupj,		null,				null,				null,		0);
				
			 if sqlca.sqlcode <> 0  then
				 Messagebox("외주의뢰", "외주의뢰 생성시 오류발생", stopsign!)
				 return -1
			 end if		
		
			// 공정의 발주예정번호 Move
			tab_1.tabpage_2.dw_morout.setitem(i, "morout_bajpno", sEstno)		
			
			/* 외주출고 에 대한 출고구분을 검색 (외주사급출고는 1개이어야 한다). */
			Select iogbn into :siogbn from iomatrix 
			 where sabu = '1' and autvnd = 'Y';	
			 if sqlca.sqlcode <> 0  then
				 Messagebox("사급구분", "사급구분 검색시 오류발생", stopsign!)
				 return -1
			 end if			 
	
			// 할당구분, 출고창고, 출고승인, 출고/출문구분 변경	
			 Update Holdstock
			 	 Set hold_gu 	= :siogbn,
				  	  out_store	= :sCvcod,
					  out_chk	= '2',
					  naougu		= '2'
			  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
			 if sqlca.sqlcode <> 0  then
				 Messagebox("사급출고", "사급출고 변경시 오류발생", stopsign!)
				 return -1
			 end if
	
		Else
		// 외주에서 내작로 변경된 경우
		// 1. Estima(구매의뢰를 삭제한다)
		// 2. Holdstock(사급출고를 생산출고로 변경한다)			
			 Delete From Estima 
			  where sabu  = :gs_sabu And pordno = :sPordno 
			  	 And Opseq = :sOpseq;
			 if sqlca.sqlcode <> 0  then
				 Messagebox("외주의뢰", "외주의뢰 삭제시 오류발생", stopsign!)
				 return -1
			 end if
			 
			// 공정의 발주예정번호 CLEAR
			tab_1.tabpage_2.dw_morout.setitem(i, "morout_bajpno", sNull)


			/* 생산출고 에 대한 출고구분을 검색 (생산자동출고는 1개이어야 한다). */
			Select iogbn into :siogbn from iomatrix 
			 where sabu = :gs_sabu and autpdt = 'Y';		
			 if sqlca.sqlcode <> 0  then
				 Messagebox("생산출고", "생산출고 검색시 오류발생", stopsign!)
				 return -1
			 end if
			 
			// 생산팀 기준으로 가상창고를 검색
			Select cvcod
			  into :sDepot
			  from vndmst
			 where jumaeip = :spdtgu and rownum = 1;			
			 if sqlca.sqlcode <> 0  then
				 Messagebox("창고코드", "창고코드 검색시 오류발생", stopsign!)
				 return -1
			 end if			 
			 
			// 할당구분, 출고창고, 출고승인, 출고/출문구분 변경	
			 Update Holdstock
			 	 Set hold_gu 	= :siogbn,
				  	  out_store	= :sDepot,
					  out_chk	= '1',
					  naougu		= '1'
			  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
			 if sqlca.sqlcode <> 0  then
				 Messagebox("생산출고", "생산출고 변경시 오류발생", stopsign!)
				 return -1
			 end if	  			 
		End if	
	end if
NEXT

return 1
end function

public subroutine wf_recheck ();// 작업지시 내역을 check하여 발주구분을 변경할 수 있는지 확인한다.
Long Lrow, Lcnt
String sOpseq, sPordno

for Lrow = 1 to tab_1.tabpage_2.dw_morout.rowcount()
	 sPordno = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "momast_pordno")
	 sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "morout_opseq")
	
	 // 구매의뢰 상태가 '1'인 경우에만 허용	
	 Lcnt = 0
	 Select count(*) into :Lcnt From Estima 
	  where sabu  = :gs_sabu And pordno = :sPordno 
	    And Opseq = :sOpseq   And blynd IN ('2', '3', '4');
	 if sqlca.sqlcode <> 0  then
		 Messagebox("수정여부", "구매의뢰 검색시 오류발생", stopsign!)
		 return
	 end if
	 if Lcnt > 0 then Continue
	 
//	 // 할당에 의한 출고내역이 없는 경우에만 가능
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Holdstock
//	  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq And isqty > 0;
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("수정여부", "할당내역 검색시 오류발생", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
//	 
//	 // 입출고 실적이 없는 경우에만 가능
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Imhist
//	  where sabu = :gs_sabu And Jakjino = :sPordno And (Opseq = :sOpseq Or Opseq = '9999');
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("수정여부", "입출고실적 검색시 오류발생", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
	 
	 // 작업실적이 없는 경우에만 가능	 	 
	 Lcnt = 0
	 Select count(*) into :Lcnt From Shpact
	  where sabu = :gs_sabu And Pordno = :sPordno And Opsno = :sOpseq;
	 if sqlca.sqlcode <> 0  then
		 Messagebox("수정여부", "작업실적 검색시 오류발생", stopsign!)
		 return
	 end if	  
	 if Lcnt > 0 then Continue	 	
	
	
	 tab_1.tabpage_2.dw_morout.setitem(lrow, "mgbn", 'Y')
	 p_mod.Enabled = TRUE
	 p_mod.PictureName = "C:\erpman\image\저장_up.gif"
Next


end subroutine

public subroutine wf_modify_check (long lgetrow);// 작업지시 내역을 check하여 발주구분을 변경할 수 있는지 확인한다.
Long Lrow, Lcnt
String sOpseq, sPordno


if Lgetrow < 1 then return
// 지시상태가 '1', '2'가 아니면 전체가 수정불가임
if tab_1.tabpage_1.dw_momast.getitemstring(Lgetrow, "momast_old_pdsts") = '1' or &
	tab_1.tabpage_1.dw_momast.getitemstring(Lgetrow, "momast_old_pdsts") = '2' Then
else
	return 
end if


for Lrow = 1 to tab_1.tabpage_2.dw_morout.rowcount()
	 sPordno = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "momast_pordno")
	 sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "morout_opseq")
	
	 // 구매의뢰 상태가 '1'인 경우에만 허용	
	 Lcnt = 0
	 Select count(*) into :Lcnt From Estima 
	  where sabu  = :gs_sabu And pordno = :sPordno 
	    And Opseq = :sOpseq   And blynd IN ('2', '3', '4');
	 if sqlca.sqlcode <> 0  then
		 Messagebox("수정여부", "구매의뢰 검색시 오류발생", stopsign!)
		 return
	 end if
	 if Lcnt > 0 then Continue
	 
//	 // 할당에 의한 출고내역이 없는 경우에만 가능
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Holdstock
//	  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq And isqty > 0;
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("수정여부", "할당내역 검색시 오류발생", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
//	 
//	 // 입출고 실적이 없는 경우에만 가능
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Imhist
//	  where sabu = :gs_sabu And Jakjino = :sPordno And (Opseq = :sOpseq Or Opseq = '9999');
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("수정여부", "입출고실적 검색시 오류발생", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
	 
	 // 작업실적이 없는 경우에만 가능	 	 
	 Lcnt = 0
	 Select count(*) into :Lcnt From Shpact
	  where sabu = :gs_sabu And Pordno = :sPordno And Opsno = :sOpseq;
	 if sqlca.sqlcode <> 0  then
		 Messagebox("수정여부", "작업실적 검색시 오류발생", stopsign!)
		 return
	 end if	  
	 if Lcnt > 0 then Continue	 	
	
	
	 tab_1.tabpage_2.dw_morout.setitem(lrow, "mgbn", 'Y')
	 p_mod.Enabled = TRUE  // 송 추가
	 p_mod.PictureName = "C:\erpman\image\저장_up.gif"	 
Next


end subroutine

public subroutine wf_reset ();rollback;

ib_any_typing =FALSE

tab_1.SelectTab(1)
tab_1.tabpage_1.dw_momast.DataObject = 'd_pdt_02061'
tab_1.tabpage_1.dw_momast.SetTransObject(sqlca)
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_2.dw_estima.ReSet()
tab_1.tabpage_2.dw_poblkt.ReSet()
tab_1.tabpage_3.dw_low.ReSet()
tab_1.tabpage_4.dw_etc.ReSet()

tab_1.tabpage_1.Enabled = TRUE
tab_1.tabpage_2.Enabled = TRUE
tab_1.tabpage_3.Enabled = FALSE

p_low.Enabled = FALSE
p_move.Enabled = FALSE
p_mod.Enabled = FALSE
p_del.Enabled = FALSE
p_inq.Enabled = TRUE

p_low.PictureName = "C:\erpman\image\하위작지확인_d.gif"
p_move.PictureName = "C:\erpman\image\하위작지이동_d.gif"
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
p_inq.PictureName = "C:\erpman\image\조회_up.gif"

dw_head.Reset()
dw_head.InsertRow(0)

dw_head.SetItem(1,'frdate',Left(f_today(),6) + '01')
dw_head.SetItem(1,'todate',f_today())
dw_head.SetItem(1,'dategu', '1')

f_child_saupj(dw_head,'pdtgu', gs_saupj)
String  ls_pdtgu
SELECT RFGUB INTO :ls_pdtgu FROM REFFPF
 WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :gs_saupj ;
dw_head.SetItem(1, 'pdtgu', ls_pdtgu)

dw_head.SetColumn('pordno')
dw_head.SetFocus()

end subroutine

public function integer wf_cancel_check (string ar_pordno, string ar_msg);long  	get_count
string	status


 //작업지시 대 수주 체크
SELECT COUNT(*)  
  INTO :get_count  
  FROM MOMORD  
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) AND  
		 ( HQTY   > 0 )   ;

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[작업지시 대 수주]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("취소불가", "수주에 연결된 자료가 할당수량이 존재합니다. 수주연결을 확인하세요!")
		Return -1
	end if	
end if	

//외주발주인 경우 구매의뢰가 되었으면 삭제 못함 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[구매의뢰]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("취소불가", "외주 의뢰 검토된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//구매의뢰인 경우 의뢰가 되었으면 삭제 못함 - 범한추가 - 2001.07.21 - 송병호 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[구매의뢰]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("취소불가", "구매 의뢰 검토된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	


//외주발주인 경우 발주가 되었으면 삭제 못함 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[발주자료]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("취소불가", "발주된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//구매발주인 경우 발주가 되었으면 삭제 못함 - 범한추가 - 2001.07.21 - 송병호 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[발주자료]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("취소불가", "발주된 자료입니다. 자료를 확인하세요!")
		Return -1
	end if	
end if	
		
return 1

end function

on w_pdt_02060.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.tab_1=create tab_1
this.dw_1=create dw_1
this.p_low=create p_low
this.p_move=create p_move
this.p_1=create p_1
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.p_low
this.Control[iCurrent+5]=this.p_move
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.cbx_2
end on

on w_pdt_02060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.tab_1)
destroy(this.dw_1)
destroy(this.p_low)
destroy(this.p_move)
destroy(this.p_1)
destroy(this.cbx_1)
destroy(this.cbx_2)
end on

event open;call super::open;dw_head.SetTransObject(sqlca)
tab_1.tabpage_1.dw_momast.SetTransObject(sqlca)
tab_1.tabpage_2.dw_morout.SetTransObject(sqlca)
tab_1.tabpage_2.dw_estima.SetTransObject(sqlca)
tab_1.tabpage_2.dw_poblkt.SetTransObject(sqlca)
tab_1.tabpage_3.dw_low.SetTransObject(sqlca)
tab_1.tabpage_4.dw_etc.SetTransObject(sqlca)

wf_reset()

dw_head.SetItem(1, "dategu", '1')

end event

type dw_insert from w_inherite`dw_insert within w_pdt_02060
boolean visible = false
integer x = 535
integer y = 2416
integer width = 320
integer height = 92
boolean enabled = false
boolean vscrollbar = true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;Long    Lrow, get_count
String  sOld_sts, sNew_sts, spordno

Lrow = this.getrow()

IF this.getcolumnname() = "momast_pdsts" THEN
   sold_sts = this.GetItemString(lrow, "old_pdsts")   
   spordno  = this.GetItemString(lrow, "momast_pordno")   
	
   sNew_sts = this.GetText() 

	IF sNew_sts = '3' OR sOld_sts = '3' THEN 
		MESSAGEBOX("확 인", "상태를 임의로 정상완료 시키거나 변경시킬 수  없습니다.")
		this.setitem(lrow, "momast_pdsts", sold_sts)
		return 1
	END IF	
	
	IF sNew_sts > '2' AND sNew_sts <> sOld_sts THEN 
		 SELECT SUM(ICOUNT)
		   INTO :get_count
			FROM
				( SELECT COUNT(*)  AS ICOUNT
					 FROM SHPACT_IPGO A    
					WHERE A.SABU   = :gs_sabu   AND  
							A.PORDNO = :spordno AND A.IOJPNO IS NULL
				  UNION ALL
				  SELECT COUNT(*)  AS ICOUNT
					 FROM SHPACT_IPGO A, IMHIST B   
					WHERE A.SABU   = :gs_sabu   AND  
							A.PORDNO = :spordno  AND A.IOJPNO IS NOT NULL AND
							A.SABU	= B.SABU		AND
							A.IOJPNO = B.IOJPNO  AND
							B.IO_DATE IS NULL ) ;
							
		if get_count > 0 then 
			MessageBox("확 인","입고예정된 자료가 존재합니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	
		
		get_count = 0
		// ESTIMA(구매의뢰)가 의뢰, 검토 이거나
		// POBLKT(발주품목정보) 발주상태가 진행('1')시에는  취소시킬 수 없음
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM ESTIMA  
		 WHERE SABU = :gs_sabu AND PORDNO = :spordno AND BLYND IN ('1', '2') ;

		if get_count > 0 then 
			MessageBox("확 인","구매의뢰상태가 의뢰, 검토인 자료입니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

		get_count = 0
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM POBLKT  
		 WHERE SABU = :gs_sabu AND PORDNO = :spordno AND BALSTS = '1' ;

		if get_count > 0 then 
			MessageBox("확 인","발주품목정보가 진행상태인 자료입니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

		get_count = 0
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM IMHIST
		 WHERE SABU = :gs_sabu AND INPCNF = 'I' AND JAKJINO = :sPordno AND IO_DATE IS NULL ;

		if get_count > 0 then 
			MessageBox("확 인","입고승인이 안된 자료가 있습니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

	END IF

END IF

	
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
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

type p_delrow from w_inherite`p_delrow within w_pdt_02060
boolean visible = false
integer x = 4174
integer y = 2468
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02060
boolean visible = false
integer x = 4000
integer y = 2468
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_02060
boolean visible = false
integer x = 4091
integer y = 2312
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02060
boolean visible = false
integer x = 4133
integer y = 2336
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_02060
boolean originalsize = true
end type

type p_can from w_inherite`p_can within w_pdt_02060
boolean originalsize = true
end type

event p_can::clicked;call super::clicked;wf_reset()


end event

type p_print from w_inherite`p_print within w_pdt_02060
boolean visible = false
integer x = 4265
integer y = 2312
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02060
integer x = 3749
end type

event p_inq::clicked;String	sPordno, sFrdate, sTodate, sPdtgu, splfrdate, spltodate


if tab_1.SelectedTab <> 1 then tab_1.SelectTab(1)
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_2.Enabled = FALSE

if dw_head.AcceptText() = -1 then return 
sPordno   = Trim(dw_head.getitemstring(1,"pordno"))
sFrdate   = dw_head.getitemstring(1,"frdate")
sTodate   = dw_head.getitemstring(1,"todate")
sPdtgu    = dw_head.getitemstring(1,"pdtgu")

if IsNull(sPordno) or sPordno = '' then
	sPordno = '%'
else
	sPordno = sPordno + '%'
end if

if IsNull(sFrdate) or sFrdate = '' then
	sFrdate = '11111111'
elseif f_datechk(sFrdate) = -1 then
	MessageBox("확인","날짜를 확인하세요.")
	dw_head.SetColumn('frdate')
	dw_head.SetFocus()
end if

if IsNull(sTodate) or sTodate = '' then
	sTodate = '99991231'
elseif f_datechk(sTodate) = -1 then
	MessageBox("확인","날짜를 확인하세요.")
	dw_head.SetColumn('todate')
	dw_head.SetFocus()
	return
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	MessageBox("확인","생산팀을 확인하세요.")
	dw_head.SetColumn('pdtgu')
	dw_head.SetFocus()
	return
end if

SetPointer(HourGlass!)

Choose Case tab_1.SelectedTab	
	Case 1
		if tab_1.tabpage_1.dw_momast.Retrieve(gs_sabu,sPordno,sFrdate,sTodate,sPdtgu, gs_saupj) <= 0 then
			f_message_chk(56,'[작업지시 조정]')
			p_del.Enabled = FALSe
			p_del.PictureName = "C:\erpman\image\삭제_d.gif"	
			tab_1.tabpage_2.Enabled = FALSE
		
			dw_head.SetColumn("pordno")
			dw_head.SetFocus()
			return
		end if
		
		p_mod.Enabled = FALSE
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		p_del.Enabled = TRUE
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
		p_low.Enabled = TRUE
		p_low.PictureName = "C:\erpman\image\하위작지확인_up.gif"
		
		this.Enabled = FALSE
		tab_1.tabpage_2.Enabled = TRUE
	// 작업공정만 조회시
	Case 2
		if tab_1.tabpage_2.dw_morout.Retrieve(gs_sabu,'%', sFrdate, sTodate, sPdtgu, gs_saupj) <= 0 then
			f_message_chk(56,'[작업지시 조정]')
			p_del.Enabled = FALSe
			p_del.PictureName = "C:\erpman\image\삭제_d.gif"	
			tab_1.tabpage_2.Enabled = FALSE
		
			dw_head.SetColumn("pordno")
			dw_head.SetFocus()
			return
		end if
		tab_1.tabpage_2.dw_morout.SetSort("morout_wkctr, morout_moseq")
		tab_1.tabpage_2.dw_morout.Sort()
		
		p_mod.Enabled = True
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		p_del.Enabled = false
		p_del.PictureName = "C:\erpman\image\삭제_d.gif"
		p_low.Enabled = false
		p_low.PictureName = "C:\erpman\image\하위작지확인_d.gif"
	Case 4
		// 기타일정 조회
		tab_1.tabpage_4.dw_etc.Retrieve(gs_sabu,sFrdate,sTodate,sPdtgu)
End Choose

ib_any_typing  = FALSE

end event

type p_del from w_inherite`p_del within w_pdt_02060
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long   		lrow, lFindrow, lCnt
string  		spordno, sformat
boolean		bErr=FALSE

//--------------------------------------------------------------------------------------------
// 작업지시마스타 탭이 선택되었을 때
if tab_1.SelectedTab = 1 then
	IF tab_1.tabpage_1.dw_momast.AcceptText() = -1 THEN RETURN 
	if tab_1.tabpage_1.dw_momast.rowcount() <= 0 then return 	
	
	SetPointer(HourGlass!)
	FOR lrow = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(lrow,'chk_flag') = 'N' then Continue
		lCnt ++
	NEXT
	
	if lCnt < 1 then 
		MessageBox("확인","처리 체크된 자료가 없습니다.")
		return
	end if
	
	sle_msg.text =	"작업지시 삭제여부 체크 中.............."
	FOR lrow = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(lrow,'chk_flag') = 'N' then Continue
		sPordno = tab_1.tabpage_1.dw_momast.getitemstring(lrow, 'momast_pordno' )
		sformat = left(spordno,2)+'-'+mid(spordno,3,5)+'-'+mid(spordno,8,3)+'-'+ mid(spordno,11)
		
		if wf_delete_chk(spordno) = -1 then
			tab_1.tabpage_1.dw_momast.SelectRow(0, FALSE)
			tab_1.tabpage_1.dw_momast.SelectRow(lrow,TRUE)
			tab_1.tabpage_1.dw_momast.ScrollToRow(lrow)
			sle_msg.text =	""	
			return 
		end if
	NEXT

	if f_msg_delete() = -1 then return
	
	sle_msg.text =	"작업지시 관련자료 삭제 中.............."	
	FOR lrow = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(lrow,'chk_flag') = 'N' then Continue
		sPordno = tab_1.tabpage_1.dw_momast.getitemstring(lrow, 'momast_pordno' )
		sformat = left(spordno,2)+'-'+mid(spordno,3,5)+'-'+mid(spordno,8,3)+'-'+ mid(spordno,11)

		if wf_delete(spordno) = -1 then 
			tab_1.tabpage_1.dw_momast.SelectRow(0, FALSE)
			tab_1.tabpage_1.dw_momast.SelectRow(lrow,TRUE)
			tab_1.tabpage_1.dw_momast.ScrollToRow(lrow)
			sle_msg.text =	""	
			rollback ;
			Return 
		END IF
	NEXT
	
	
	sle_msg.text =	"작업지시자료 삭제 中.............."	
	FOR lrow = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(lrow,'chk_flag') = 'N' then Continue
		tab_1.tabpage_1.dw_momast.DeleteRow(lrow)
		lrow = lrow - 1
	NEXT
		
	if tab_1.tabpage_1.dw_momast.Update() = 1 then
		sle_msg.text =	"자료를 삭제하였습니다!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		sle_msg.text =	""	
		messagebox("삭제실패", "자료를 삭제하는데 실패하였읍니다")
		return 
	end if	

	p_inq.TriggerEvent(Clicked!)

//--------------------------------------------------------------------------------------------
// 하위작지마스타 탭이 선택되었을 때
elseif tab_1.SelectedTab = 3 then
	IF tab_1.tabpage_3.dw_low.AcceptText() = -1 THEN RETURN 
	if tab_1.tabpage_3.dw_low.rowcount() <= 0 then return 	
	
	SetPointer(HourGlass!)
	FOR lrow = 1 TO tab_1.tabpage_3.dw_low.rowcount()
		if tab_1.tabpage_3.dw_low.getitemstring(lrow,'chk_flag') = 'N' then Continue
		lCnt ++
	NEXT
	
	if lCnt < 1 then 
		MessageBox("확인","처리 체크된 자료가 없습니다.")
		return
	end if
	
	sle_msg.text =	"작업지시 삭제여부 체크 中.............."	
	FOR lrow = 1 TO tab_1.tabpage_3.dw_low.rowcount()
		if tab_1.tabpage_3.dw_low.getitemstring(lrow,'chk_flag') = 'N' then Continue
		sPordno = tab_1.tabpage_3.dw_low.getitemstring(lrow, 'momast_pordno' )
		sformat = left(spordno,2)+'-'+mid(spordno,3,5)+'-'+mid(spordno,8,3)+'-'+ mid(spordno,11)
		
		if wf_delete_chk(spordno) = -1 then
			tab_1.tabpage_3.dw_low.SelectRow(0, FALSE)
			tab_1.tabpage_3.dw_low.SelectRow(lrow,TRUE)
			tab_1.tabpage_3.dw_low.ScrollToRow(lrow)
			sle_msg.text =	""	
			return 
		end if
	NEXT

	if f_msg_delete() = -1 then return
	
	sle_msg.text =	"작업지시 관련자료 삭제 中.............."	
	FOR lrow = 1 TO tab_1.tabpage_3.dw_low.rowcount()
		if tab_1.tabpage_3.dw_low.getitemstring(lrow,'chk_flag') = 'N' then Continue
		sPordno = tab_1.tabpage_3.dw_low.getitemstring(lrow, 'momast_pordno' )
		sformat = left(spordno,2)+'-'+mid(spordno,3,5)+'-'+mid(spordno,8,3)+'-'+ mid(spordno,11)

		if wf_delete(spordno) = -1 then 
			tab_1.tabpage_3.dw_low.SelectRow(0, FALSE)
			tab_1.tabpage_3.dw_low.SelectRow(lrow,TRUE)
			tab_1.tabpage_3.dw_low.ScrollToRow(lrow)
			sle_msg.text =	""	
			rollback ;
			Return 
		END IF
	NEXT
	
	
	sle_msg.text =	"작업지시자료 삭제 中.............."	
	FOR lrow = 1 TO tab_1.tabpage_3.dw_low.rowcount()
		if tab_1.tabpage_3.dw_low.getitemstring(lrow,'chk_flag') = 'N' then Continue
		sPordno = tab_1.tabpage_3.dw_low.getitemstring(lrow, 'momast_pordno' )
		sformat = left(spordno,2)+'-'+mid(spordno,3,5)+'-'+mid(spordno,8,3)+'-'+ mid(spordno,11)
		
		DELETE FROM "MOMAST"
		 WHERE "MOMAST"."SABU" = :gs_sabu AND "MOMAST"."PORDNO" = :sPordno ;
		
		if sqlca.sqlcode <> 0 then
			bErr = TRUE
			Exit
		end if
	NEXT
		
	if bErr = TRUE then
		MessageBox("삭제불가","작지번호: " + sformat + "의 관련자료를 삭제하는데 실패하였습니다.")
		lFindrow = tab_1.tabpage_3.dw_low.Find(" momast_pordno = '" + sPordno + "' ",1, &
																					tab_1.tabpage_3.dw_low.RowCount())
		if lFindrow > 0 then
			tab_1.tabpage_3.dw_low.SelectRow(0, FALSE)
			tab_1.tabpage_3.dw_low.SelectRow(lrow,TRUE)
			tab_1.tabpage_3.dw_low.ScrollToRow(lrow)
		end if
		sle_msg.text =	""	
		rollback ;
		Return 
	end if
	
	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
	
	sPordno = tab_1.tabpage_3.dw_low.getitemstring(1,"momast_pordno")
	tab_1.tabpage_3.dw_low.SetRedraw(FALSE)
	tab_1.tabpage_3.dw_low.Retrieve(gs_sabu,sPordno,'%','%','%')
	tab_1.tabpage_3.dw_low.SetRedraw(TRUE)
// 기타일정 탭이 선택되었을 때
elseif tab_1.SelectedTab = 4 then
	IF tab_1.tabpage_4.dw_etc.AcceptText() = -1 THEN RETURN 
	if tab_1.tabpage_4.dw_etc.rowcount() <= 0 then return 	
	
	lCnt= 0
	FOR lrow = 1 TO tab_1.tabpage_4.dw_etc.rowcount()
		if tab_1.tabpage_4.dw_etc.getitemstring(lrow,'chk') = 'N' then Continue
		lCnt ++
	NEXT
	
	if lCnt < 1 then 
		MessageBox("확인","처리 체크된 자료가 없습니다.")
		return
	end if
	
	if f_msg_delete() = -1 then return
	
	sle_msg.text =	"기타일정자료 삭제 中.............."	
	FOR lrow = 1 TO tab_1.tabpage_4.dw_etc.rowcount()
		if tab_1.tabpage_4.dw_etc.getitemstring(lrow,'chk') = 'N' then Continue
		tab_1.tabpage_4.dw_etc.DeleteRow(lrow)
		lrow = lrow - 1
	NEXT
		
	if tab_1.tabpage_4.dw_etc.Update() = 1 then
		sle_msg.text =	"자료를 삭제하였습니다!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		sle_msg.text =	""	
		messagebox("삭제실패", "자료를 삭제하는데 실패하였읍니다")
		return 
	end if
end if
end event

type p_mod from w_inherite`p_mod within w_pdt_02060
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;long k, iupdate
string spordno, snew_pdsts, sold_pdsts, sopseq

//--------------------------------------------------------------------------------------------
// 작업지시마스타 탭이 선택되었을 때
if tab_1.SelectedTab = 1 then
	if tab_1.tabpage_1.dw_momast.AcceptText() = -1 then return 
	if tab_1.tabpage_1.dw_momast.rowcount() <= 0 then	return 

	if f_msg_update() = -1 then return

	SetPointer(HourGlass!)
	w_mdi_frame.sle_msg.text = "작업지시마스타 저장 중.........."


	FOR k = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(k,'chk_flag') = 'N' then Continue
		
		sNew_pdsts = tab_1.tabpage_1.dw_momast.getitemstring(k,'momast_pdsts') 
		sOld_pdsts = tab_1.tabpage_1.dw_momast.getitemstring(k,'momast_old_pdsts') 
		sPordno 	  = tab_1.tabpage_1.dw_momast.getitemstring(k,'momast_pordno')  
		
		if sNew_pdsts <> sOld_pdsts and sNew_pdsts = '6' then
			DELETE FROM "MOMORD"  
			 WHERE ( "MOMORD"."SABU"   = :gs_sabu ) AND  
					 ( "MOMORD"."PORDNO" = :spordno ) AND  
					 ( "MOMORD"."HQTY"   = 0 )   ;
		
			if sqlca.sqlcode < 0 then
				rollback;
				w_mdi_frame.sle_msg.text = ''
				f_message_chk(32,'[작업지시 대 수주 삭제시]') 	
				return 
			end if	
	
			UPDATE "MOMORD"  
				SET "SQTY" = "HQTY", "UPD_USER" = :gs_userid  
			 WHERE ( "MOMORD"."SABU"   = :gs_sabu ) AND  
					 ( "MOMORD"."PORDNO" = :spordno ) AND  
					 ( "MOMORD"."HQTY"   > 0 )   ;
			
			if sqlca.sqlcode < 0 then
				rollback;
				w_mdi_frame.sle_msg.text = ''
				f_message_chk(32,'[작업지시 대 수주 수정시]') 	
				return 
			end if	
		end if
	NEXT

	if tab_1.tabpage_1.dw_momast.update() = -1 then
		rollback;
		w_mdi_frame.sle_msg.text = ''
		f_message_chk(32,'[자료저장]') 	
	else
		commit;
	end if

	w_mdi_frame.sle_msg.text = "자료저장을 완료하였습니다."

//--------------------------------------------------------------------------------------------
// 작업지시공정상세 탭이 선택되었을 때
elseif tab_1.SelectedTab = 2 then

	if tab_1.tabpage_1.dw_momast.AcceptText() = -1 then return
	if tab_1.tabpage_2.dw_morout.AcceptText() = -1 then return
	if tab_1.tabpage_2.dw_morout.RowCount() < 1 then return


	// Detail내역 check
	IF wf_required_chk_dtl() = -1 THEN 
		Rollback;
		RETURN
	End if

	if f_msg_update() = -1 then return
	
	SetPointer(HourGlass!)
	w_mdi_frame.sle_msg.text = "작업지시 공정상세정보 저장 중.........."
	
	if tab_1.tabpage_2.dw_morout.update() = -1 Then
		rollback;
		w_mdi_frame.sle_msg.text = ''
		f_message_chk(32,'[자료저장]') 	
		return
	else
		commit;
	end if
	
	sPordno = tab_1.tabpage_2.dw_morout.getitemstring(1, 'morout_pordno')
	sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(1, 'morout_opseq')		
		
	tab_1.tabpage_2.dw_estima.retrieve(gs_sabu,spordno, sopseq)
	tab_1.tabpage_2.dw_poblkt.retrieve(gs_sabu,spordno, sopseq)			

	w_mdi_frame.sle_msg.text = ''
	ib_any_typing =FALSE
	w_mdi_frame.sle_msg.text = "자료저장을 완료하였습니다."
	
	tab_1.selecttab(1)
	tab_1.selecttab(2)	
// 기타일정
elseif tab_1.SelectedTab = 4 then
	if tab_1.tabpage_4.dw_etc.AcceptText() = -1 then return

	if tab_1.tabpage_4.dw_etc.update() = -1 Then
		rollback;
		w_mdi_frame.sle_msg.text = ''
		f_message_chk(32,'[자료저장]') 	
		return
	else
		commit;
	end if
	
	ib_any_typing =FALSE
	w_mdi_frame.sle_msg.text = "자료저장을 완료하였습니다."
end if
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02060
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02060
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02060
integer x = 699
integer y = 2468
end type

type cb_del from w_inherite`cb_del within w_pdt_02060
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02060
end type

type cb_print from w_inherite`cb_print within w_pdt_02060
integer x = 1440
integer y = 2456
end type

type st_1 from w_inherite`st_1 within w_pdt_02060
end type

type cb_can from w_inherite`cb_can within w_pdt_02060
end type

type cb_search from w_inherite`cb_search within w_pdt_02060
integer x = 1783
integer y = 2440
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02060
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02060
end type

type dw_head from datawindow within w_pdt_02060
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 188
integer width = 3154
integer height = 136
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02060"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "pordno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "pordno", gs_code)

end if
end event

event itemchanged;String	sdata, snull, sdategu

Setnull(snull)

dw_head.AcceptText()
sdategu = dw_head.GetItemString(1, "dategu")

if sdategu = '1' then
	tab_1.tabpage_1.dw_momast.Dataobject = 'd_pdt_02061'
else
	tab_1.tabpage_1.dw_momast.Dataobject = 'd_pdt_02061_1'
end if
tab_1.tabpage_1.dw_momast.SetTransObject(sqlca)


if this.getcolumnname() = 'frdate' then
	sdata = this.gettext()
	
	if IsNull(sdata) or sdata = '' then return
	
	if f_datechk(sdata) = -1 then
		MessageBox("확인","날짜를 확인하세요.")
		this.SetItem(1,'frdate',snull)
		return 1
	end if


elseif this.getcolumnname() = 'todate' then
	sdata = this.gettext()
	
	if IsNull(sdata) or sdata = '' then return
	
	if f_datechk(sdata) = -1 then
		MessageBox("확인","날짜를 확인하세요.")
		this.SetItem(1,'todate',snull)
		return 1
	end if

end if

	
end event

type tab_1 from tab within w_pdt_02060
integer x = 27
integer y = 336
integer width = 4567
integer height = 1920
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanging;if oldindex = 1 and newindex = 2 then
	Long		lRow
	String	sPordno, sopseq

	// 작지마스타를 조회하지 않은 경우는 skip
	If this.tabpage_1.dw_momast.RowCount() <= 0 Then Return
	
	lRow = this.tabpage_1.dw_momast.GetSelectedRow(0)
	if lRow <= 0 then
		tab_1.tabpage_2.dw_morout.reset()
		tab_1.tabpage_2.dw_estima.reset()		
		tab_1.tabpage_2.dw_poblkt.reset()
	   MessageBox("확인","자료를 선택하세요.")
	   return 1
	end if
	
	SetPointer(HourGlass!)
	sPordno = this.tabpage_1.dw_momast.GetItemString(lRow,'momast_pordno')
	
	p_mod.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	if this.tabpage_2.dw_morout.Retrieve(gs_sabu,sPordno,'10000101','99991231') > 0 then
		wf_modify_check(lRow)
	end if
	
	p_low.Enabled = FALSE
	p_low.PictureName = "C:\erpman\image\하위작지확인_d.gif"		
	p_move.Enabled = FALSE
	p_move.PictureName = "C:\erpman\image\하위작지이동_d.gif"		
	p_del.Enabled = FALSE
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	
	if tab_1.tabpage_2.dw_morout.rowcount() > 0 then
		sPordno = tab_1.tabpage_2.dw_morout.getitemstring(1, 'morout_pordno')
		sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(1, 'morout_opseq')		
		
		tab_1.tabpage_2.dw_estima.retrieve(gs_sabu,spordno, sopseq)
		tab_1.tabpage_2.dw_poblkt.retrieve(gs_sabu,spordno, sopseq)		
	Else
		tab_1.tabpage_2.dw_estima.reset()
		tab_1.tabpage_2.dw_poblkt.reset()		
	End if
	
elseif newindex = 1 then
	p_low.Enabled = TRUE
	p_low.PictureName = "C:\erpman\image\하위작지확인_up.gif"			
	p_del.Enabled = TRUE
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"		
elseif newindex = 3 then
	p_mod.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"	
elseif newindex = 4 then
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
elseif oldindex = 2 then
	tab_1.tabpage_2.dw_morout.reset()
	tab_1.tabpage_2.dw_estima.reset()
	tab_1.tabpage_2.dw_poblkt.reset()	
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1808
long backcolor = 32106727
string text = "작지마스타"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_momast dw_momast
end type

on tabpage_1.create
this.rr_2=create rr_2
this.dw_momast=create dw_momast
this.Control[]={this.rr_2,&
this.dw_momast}
end on

on tabpage_1.destroy
destroy(this.rr_2)
destroy(this.dw_momast)
end on

type rr_2 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4485
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_momast from datawindow within tabpage_1
integer x = 37
integer y = 40
integer width = 4457
integer height = 1736
integer taborder = 30
string title = "none"
string dataobject = "d_pdt_02061"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;if row <= 0 then
	SelectRow(0,False)
else
	SelectRow(0, FALSE)
	SelectRow(row,TRUE)
end if
end event

event itemchanged;p_mod.Enabled = TRUE
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

Long   Lrow
String sdata, sprv, spordno

Lrow = getrow()

if getcolumnname() = 'momast_pdsts' then
	sPrv  = getitemstring(Lrow, "momast_pdsts")
	sData = gettext()
	sPordno = getitemstring(Lrow, "momast_pordno")
	
	if sData = '3' then
		Messagebox("지시상태", "정상완료는 시스템에서 제어합니다", stopsign!)
		setitem(Lrow, "momast_pdsts", sprv)
		return 1
	end if;
	
	if wf_cancel_check(spordno,'Y') = -1 then
		Messagebox("지시상태", "진행중인 자료를 먼저 정리하십시요.", stopsign!)
		setitem(Lrow, "momast_pdsts", sprv)
		return 1
	end if;		
end if
end event

event itemerror;return 1
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1808
long backcolor = 32106727
string text = "공정상세"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
cb_1 cb_1
rr_3 rr_3
rr_5 rr_5
rr_4 rr_4
st_2 st_2
dw_poblkt dw_poblkt
dw_estima dw_estima
dw_morout dw_morout
end type

on tabpage_2.create
this.cb_1=create cb_1
this.rr_3=create rr_3
this.rr_5=create rr_5
this.rr_4=create rr_4
this.st_2=create st_2
this.dw_poblkt=create dw_poblkt
this.dw_estima=create dw_estima
this.dw_morout=create dw_morout
this.Control[]={this.cb_1,&
this.rr_3,&
this.rr_5,&
this.rr_4,&
this.st_2,&
this.dw_poblkt,&
this.dw_estima,&
this.dw_morout}
end on

on tabpage_2.destroy
destroy(this.cb_1)
destroy(this.rr_3)
destroy(this.rr_5)
destroy(this.rr_4)
destroy(this.st_2)
destroy(this.dw_poblkt)
destroy(this.dw_estima)
destroy(this.dw_morout)
end on

type cb_1 from commandbutton within tabpage_2
integer x = 4091
integer width = 402
integer height = 92
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;String	sPordno, sFrdate, sTodate, sPdtgu, splfrdate, spltodate


//if tab_1.SelectedTab <> 1 then tab_1.SelectTab(1)
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_1.Enabled = FAlse

if dw_head.AcceptText() = -1 then return 
sPordno   = Trim(dw_head.getitemstring(1,"pordno"))
sFrdate   = dw_head.getitemstring(1,"frdate")
sTodate   = dw_head.getitemstring(1,"todate")
sPdtgu    = dw_head.getitemstring(1,"pdtgu")

if IsNull(sPordno) or sPordno = '' then
	sPordno = '%'
else
	sPordno = sPordno + '%'
end if

if IsNull(sFrdate) or sFrdate = '' then
	sFrdate = '11111111'
elseif f_datechk(sFrdate) = -1 then
	MessageBox("확인","날짜를 확인하세요.")
	dw_head.SetColumn('frdate')
	dw_head.SetFocus()
end if

if IsNull(sTodate) or sTodate = '' then
	sTodate = '99991231'
elseif f_datechk(sTodate) = -1 then
	MessageBox("확인","날짜를 확인하세요.")
	dw_head.SetColumn('todate')
	dw_head.SetFocus()
	return
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	MessageBox("확인","생산팀을 확인하세요.")
	dw_head.SetColumn('pdtgu')
	dw_head.SetFocus()
	return
end if

SetPointer(HourGlass!)

// 작업공정만 조회시
if tab_1.tabpage_2.dw_morout.Retrieve(gs_sabu,'%', sFrdate, sTodate, sPdtgu, gs_saupj) <= 0 then
	f_message_chk(56,'[작업지시 조정]')
	p_del.Enabled = FALSe
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"	
	tab_1.tabpage_2.Enabled = FALSE

	dw_head.SetColumn("pordno")
	dw_head.SetFocus()
	return
end if
tab_1.tabpage_2.dw_morout.SetSort("morout_wkctr, morout_moseq")
tab_1.tabpage_2.dw_morout.Sort()

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.Enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
p_low.Enabled = false
p_low.PictureName = "C:\erpman\image\하위작지확인_d.gif"

ib_any_typing  = FALSE

end event

type rr_3 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 96
integer width = 4512
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within tabpage_2
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2336
integer y = 1272
integer width = 1970
integer height = 496
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within tabpage_2
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 187
integer y = 1272
integer width = 1970
integer height = 496
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within tabpage_2
boolean visible = false
integer x = 293
integer y = 1208
integer width = 3301
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "#.Double Click시 공정수정, 추가, 삭제를 할 수 있읍니다. ( 단 공정실적이 있는 경우에는 조정할 수 없읍니다 )"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_poblkt from datawindow within tabpage_2
boolean visible = false
integer x = 2350
integer y = 1288
integer width = 1920
integer height = 468
integer taborder = 60
string title = "none"
string dataobject = "d_pdt_02066"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_estima from datawindow within tabpage_2
boolean visible = false
integer x = 215
integer y = 1288
integer width = 1920
integer height = 468
integer taborder = 60
string title = "none"
string dataobject = "d_pdt_02065"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_morout from datawindow within tabpage_2
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 37
integer y = 108
integer width = 4453
integer height = 1664
integer taborder = 30
string title = "none"
string dataobject = "d_pdt_02062"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;long    lrow, ireturn 
string  oldate, sdate, scode, sname, sname2, sjocod, sprvcode, sprvname, sprvjo, sPordno, sOpseq
dec {3} dprice, dPrvprc

Setnull(sJocod)

lrow = this.getrow()

if this.getcolumnname() = "morout_purgc" then
	if data = 'Y' then
		f_buy_unprc(	this.getitemstring(Lrow, "momast_itnbr"), &
		                    	this.getitemstring(Lrow, "momast_pspec"), &
						this.getitemstring(Lrow, "morout_opseq"), &
						sdate, sname, dPrice, sname2)
		this.setitem(Lrow, "morout_wicvcod", sdate)
		this.setitem(Lrow, "cvnas",   sname)
		this.setitem(Lrow, "morout_wiunprc", dprice)			
	else
		this.setitem(Lrow, "morout_wicvcod", sjocod)
		this.setitem(Lrow, "cvnas",   sjocod)
		this.setitem(Lrow, "morout_wiunprc", 0)	
	end if
elseif this.getcolumnname() = "morout_wkctr" then

	sprvcode = this.getitemstring(Lrow, "morout_wkctr")
	sprvname = this.getitemstring(Lrow, "wrkctr_wcdsc")	
	sprvjo	= this.getitemstring(Lrow, "morout_jocod")		
   scode = trim(this.gettext())
	
	ireturn = f_get_name2('작업장', 'Y', scode, sname, sname2) 
	this.setitem(lrow, "morout_wkctr", scode)
	this.setitem(lrow, "wrkctr_wcdsc", sname)
	if isnull(scode) or trim(sCode) = '' then
		this.setitem(Lrow, "morout_wkctr", sprvcode)
		this.setitem(Lrow, "wrkctr_wcdsc", sprvname)	
		this.setitem(Lrow, "morout_jocod", sprvjo)		
	Else
		select jocod into :sjocod from wrkctr where wkctr = :scode;
		if isnull(sJocod) or trim(sJocod) = '' then
			Messagebox("조", "작업장에 대한 조가 없읍니다", stopsign!)
			return 1
		end if
		this.setitem(Lrow, "morout_jocod", sjocod)
	End if
	return ireturn
elseif this.getcolumnname() = "morout_wicvcod" then
	sprvcode = this.getitemstring(Lrow, "morout_wicvcod")
	sprvname = this.getitemstring(Lrow, "cvnas")	
   scode = trim(this.gettext())
	ireturn = f_get_name2('V1', 'Y', scode, sname, sname2) 
	if ireturn = 0 then
		this.setitem(lrow, "morout_wicvcod", scode)
		this.setitem(lrow, "cvnas", sname)
	else
		this.setitem(lrow, "morout_wicvcod", sPrvcode)
		this.setitem(lrow, "cvnas", sPrvname)
	end if
	return ireturn	
elseif this.getcolumnname() = "morout_wiunprc" then
	dPrvprc = this.getitemdecimal(Lrow, "morout_wiunprc")	
	dPrice = dec(this.gettext())
	if isnull(dPrice) or dPrice = 0 then
		this.setitem(Lrow, "morout_wiunprc", dPrvprc)
		Messagebox("단가", "단가를 확인하십시요", stopsign!)
		return 1
	end if
// 작업자
elseif this.getcolumnname() = "morout_etc_inwon_nm" then
	sName = Trim(GetText())
	If MessageBox('확인','작업자를 변경하시겠습니까?', Information!, YesNo!, 1) = 2 Then Return 2
	
	sPordno = GetItemString(lrow, 'morout_pordno')
	sOpseq  = GetItemString(lrow, 'morout_opseq')
	sName2  = GetItemString(lrow, 'morout_wkctr')
	
	UPDATE MOROUT_ETC SET INWON_NM = :sName, WKCTR = :sName2
	 WHERE SABU = :gs_sabu
	   AND PORDNO = :sPordno
		AND OPSEQ = :sOpseq;

	COMMIT;
// 근무타입
elseif this.getcolumnname() = "morout_etc_kuntype" then
	sName = Trim(GetText())
	If MessageBox('확인','근무형태를 변경하시겠습니까?', Information!, YesNo!, 1) = 2 Then Return 2
	
	sPordno = GetItemString(lrow, 'morout_pordno')
	sOpseq  = GetItemString(lrow, 'morout_opseq')
	sName2  = GetItemString(lrow, 'morout_wkctr')
	
	UPDATE MOROUT_ETC SET KUNTYPE= :sName, WKCTR = :sName2
	 WHERE SABU = :gs_sabu
	   AND PORDNO = :sPordno
		AND OPSEQ = :sOpseq;

	COMMIT;
end if
end event

event itemerror;RETURN 1
end event

event rbuttondown;gs_code     = ''
gs_codename = ''
gs_gubun    = ''

if this.getcolumnname() = "morout_wkctr" then
   gs_code = this.gettext()
	open(w_workplace_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(this.getrow(), "morout_wkctr", gs_code)
	this.triggerevent(itemchanged!)
	setnull(gs_code)
	setnull(gs_codename)
elseif this.getcolumnname() = "morout_wicvcod" then
   gs_code = this.gettext()
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(this.getrow(), "morout_wicvcod", gs_code)
	this.triggerevent(itemchanged!)	
	setnull(gs_code)
	setnull(gs_codename)	
end if	
end event

event doubleclicked;//string sgubun,spordno
//long ll_row
//integer ii
//
//ll_row = getrow()
//if ll_row < 1 then return
//
//if getitemstring(Ll_row, "mgbn") = 'N' then
//	messagebox("공정조정", "공정내역을 수정할 수 없읍니다")
//	return
//end if
// 
//ii =  Messagebox("공정조정", "공정을 수정하시겠읍니까?" + '~n' + &
//     			                 "공정수정(예), 공정추가(아니오), 작업취소(취소)", question!, yesnocancel!)
//										 
//if ii = 1 then
//	gs_code 		= getitemstring(ll_row,"morout_pordno")
//	gs_codename	= getitemstring(ll_row,"morout_opseq")
//	spordno = gs_code
//	open(w_pdt_02050)
//	sgubun = message.stringparm
//	if sgubun = 'Y' then
//		retrieve(gs_sabu, spordno)
//		wf_recheck()
//   end if
//Elseif ii = 2 then
//	gs_code 		= getitemstring(ll_row,"morout_pordno")
//	spordno = gs_code
//	SetNull(gs_codename)
//	open(w_pdt_02050)
//	sgubun = message.stringparm
//	if sgubun = 'Y' then
//		retrieve(gs_sabu, spordno)
//		wf_recheck()
//   end if
//End if
end event

event getfocus;string spordno, sopseq
Long  Lrow

Lrow = getrow()
if Lrow > 0 then
	spordno = getitemstring(Lrow, "morout_pordno")
	sopseq  = getitemstring(Lrow, "morout_opseq")
	dw_estima.retrieve(gs_sabu, spordno, sopseq)
	dw_poblkt.retrieve(gs_sabu, spordno, sopseq)	
Else
	dw_estima.reset()
	dw_poblkt.reset()
End if
end event

event rowfocuschanged;string spordno, sopseq
Long  Lrow

Lrow = currentrow
if Lrow > 0 then
	spordno = getitemstring(Lrow, "morout_pordno")
	sopseq  = getitemstring(Lrow, "morout_opseq")
	dw_estima.retrieve(gs_sabu, spordno, sopseq)
	dw_poblkt.retrieve(gs_sabu, spordno, sopseq)	
Else
	dw_estima.reset()
	dw_poblkt.reset()
End if
end event

type tabpage_3 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 4530
integer height = 1808
boolean enabled = false
long backcolor = 32106727
string text = "하위작지마스타"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_low dw_low
end type

on tabpage_3.create
this.rr_1=create rr_1
this.dw_low=create dw_low
this.Control[]={this.rr_1,&
this.dw_low}
end on

on tabpage_3.destroy
destroy(this.rr_1)
destroy(this.dw_low)
end on

type rr_1 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4485
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_low from datawindow within tabpage_3
integer x = 37
integer y = 40
integer width = 4457
integer height = 1736
integer taborder = 60
string title = "none"
string dataobject = "d_pdt_02063"
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;if row <= 0 then
	SelectRow(0,False)
else
	SelectRow(0, FALSE)
	SelectRow(row,TRUE)
end if
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1808
long backcolor = 32106727
string text = "기타일정"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_etc dw_etc
end type

on tabpage_4.create
this.dw_etc=create dw_etc
this.Control[]={this.dw_etc}
end on

on tabpage_4.destroy
destroy(this.dw_etc)
end on

type dw_etc from u_key_enter within tabpage_4
integer x = 14
integer y = 76
integer width = 4384
integer height = 1720
integer taborder = 11
string dataobject = "d_pdt_02060_etc"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdt_02060
boolean visible = false
integer x = 2432
integer y = 2376
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02064"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_low from uo_picture within w_pdt_02060
boolean visible = false
integer x = 55
integer y = 24
integer width = 306
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\하위작지확인_d.gif"
end type

event clicked;call super::clicked;Long		lRow
String	sPordno

lRow = tab_1.tabpage_1.dw_momast.GetSelectedRow(0)
if lRow <= 0 then
	MessageBox("확인","자료를 선택하세요.")
	return
end if

sPordno = tab_1.tabpage_1.dw_momast.getitemstring(lRow,"momast_pordno")

tab_1.SelectTab(3)
tab_1.tabpage_1.dw_momast.ReSet()
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_1.Enabled = FALSE
tab_1.tabpage_2.Enabled = FALSE
tab_1.tabpage_3.Enabled = TRUE

SetPointer(HourGlass!)
tab_1.tabpage_3.dw_low.SetRedraw(FALSE)
if tab_1.tabpage_3.dw_low.Retrieve(gs_sabu,sPordno,'%','%','%') <= 0 then
	p_mod.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"	
	p_del.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\삭제_d.gif"		
	return
end if

tab_1.tabpage_3.dw_low.SetRedraw(TRUE)

ib_any_typing  = FALSE
p_mod.Enabled = FALSE
p_del.Enabled = TRUE
this.Enabled   = FALSE
p_move.Enabled = TRUE

p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"
this.PictureName   = "C:\erpman\image\하위작지확인_d.gif"
p_move.PictureName = "C:\erpman\image\하위작지이동_up.gif"



end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\하위작지확인_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\하위작지확인_dn.gif'
end event

type p_move from uo_picture within w_pdt_02060
boolean visible = false
integer x = 352
integer y = 24
integer width = 306
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\하위작지이동_d.gif"
end type

event clicked;call super::clicked;String	sFilter
Long		lRow


tab_1.SelectTab(1)
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_1.Enabled = TRUE
tab_1.tabpage_2.Enabled = TRUE
tab_1.tabpage_3.Enabled = FALSE



//--------------------------------------------------------------------------------------------
// 작지마스타 datawindow SQL조정후 조회
if tab_1.tabpage_3.dw_low.Rowcount() <= 0 then
	tab_1.tabpage_1.dw_momast.ReSet()
	
else
	tab_1.tabpage_1.dw_momast.DataObject = 'd_pdt_02064'
	tab_1.tabpage_1.dw_momast.SetTransObject(sqlca)

	sFilter = "( "
	FOR lRow = 1 TO tab_1.tabpage_3.dw_low.Rowcount()
		sFilter = sFilter + "momast_pordno = '" + &
					 tab_1.tabpage_3.dw_low.GetItemString(lRow,'momast_pordno') + "' or "
	NEXT
	
	if sFilter <> "( " then
		sFilter = Left(sFilter,Len(sFilter) - 3) + " )"
		tab_1.tabpage_1.dw_momast.SetFilter(sFilter)
		tab_1.tabpage_1.dw_momast.Filter()
	end if
	
	tab_1.tabpage_1.dw_momast.Retrieve()
end if

this.Enabled 	= FALSE
p_inq.Enabled = FALSE
p_mod.Enabled = FALSE
p_del.Enabled = TRUE

p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"
p_inq.PictureName   = "C:\erpman\image\조회_d.gif"
this.PictureName = "C:\erpman\image\하위작지이동_d.gif"


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\하위작지이동_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\하위작지이동_dn.gif'
end event

type p_1 from uo_picture within w_pdt_02060
boolean visible = false
integer x = 4448
integer y = 176
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\품목추가_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\품목추가_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\품목추가_dn.gif'
end event

event clicked;call super::clicked;String sMsg, sPdtgu

If dw_head.AcceptText() <> 1 Then Return
sPdtgu = Trim(dw_head.GetItemString(1, 'pdtgu'))
If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400,'[생산팀]')
	Return
End If

gs_gubun = sPdtgu
open(w_pdt_02060_1)
sMsg = message.stringparm
if sMsg = 'Y' then
	p_inq.TriggerEvent(Clicked!)
End if

SetNull(gs_code)			// 작업지시번호
SetNull(gs_codename)		// 공정코드
end event

type cbx_1 from checkbox within w_pdt_02060
integer x = 3616
integer y = 348
integer width = 489
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "작지 일괄 삭제"
end type

event clicked;Long ix
Dec  dSilQty

For ix = 1 To tab_1.tabpage_1.dw_momast.RowCount()
	dSilQty = tab_1.tabpage_1.dw_momast.GetItemNumber(ix, 'silqty')
	If dSilQty > 0 Then Continue
	
	If dSilQty = 0 Then
		tab_1.tabpage_1.dw_momast.SetItem(ix, 'chk_flag', 'Y')
	Else
		tab_1.tabpage_1.dw_momast.SetItem(ix, 'chk_flag', 'N')
	End If
Next

// 
tab_1.tabpage_1.dw_momast.SetFilter("pjt_no <> 'AUTO_CREATE' AND chk_flag = 'Y'")
tab_1.tabpage_1.dw_momast.Filter()
tab_1.tabpage_1.dw_momast.RowsDisCard(1, tab_1.tabpage_1.dw_momast.FilteredCount(), Filter!)

tab_1.tabpage_1.dw_momast.SetFilter("pjt_no <> 'AUTO_CREATE' ")
tab_1.tabpage_1.dw_momast.Filter()
end event

type cbx_2 from checkbox within w_pdt_02060
integer x = 4119
integer y = 348
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "일괄 강제완료"
end type

event clicked;Long ix
string sPordno

SetPointer(HourGlass!)

For ix = 1 To tab_1.tabpage_1.dw_momast.RowCount()
	// 상태가 지시인 경우만 강제완료 가능
	If tab_1.tabpage_1.dw_momast.GetItemString(ix, 'momast_pdsts') = '1' Then
		
		sPordno = tab_1.tabpage_1.dw_momast.getitemstring(ix, "momast_pordno")
	
		if wf_cancel_check(spordno,'N') = -1 then Continue
	
		tab_1.tabpage_1.dw_momast.SetItem(ix, 'momast_pdsts', '4')
	End If
Next
end event

