$PBExportHeader$w_pu05_00030.srw
$PBExportComments$** 외주불출(외주발주검토) 처리
forward
global type w_pu05_00030 from w_inherite
end type
type dw_1 from datawindow within w_pu05_00030
end type
type cbx_1 from checkbox within w_pu05_00030
end type
type dw_hidden from datawindow within w_pu05_00030
end type
type rb_delete from radiobutton within w_pu05_00030
end type
type rb_insert from radiobutton within w_pu05_00030
end type
type dw_pomast from datawindow within w_pu05_00030
end type
type dw_poblkt from datawindow within w_pu05_00030
end type
type dw_imhist_waiju_out from datawindow within w_pu05_00030
end type
type dw_imhist_waiju_in from datawindow within w_pu05_00030
end type
type dw_bom from datawindow within w_pu05_00030
end type
type pb_cal from u_pb_cal within w_pu05_00030
end type
type dw_print from datawindow within w_pu05_00030
end type
type rr_1 from roundrectangle within w_pu05_00030
end type
type rr_2 from roundrectangle within w_pu05_00030
end type
type rr_3 from roundrectangle within w_pu05_00030
end type
end forward

global type w_pu05_00030 from w_inherite
integer width = 4672
integer height = 3816
string title = "외주불출"
dw_1 dw_1
cbx_1 cbx_1
dw_hidden dw_hidden
rb_delete rb_delete
rb_insert rb_insert
dw_pomast dw_pomast
dw_poblkt dw_poblkt
dw_imhist_waiju_out dw_imhist_waiju_out
dw_imhist_waiju_in dw_imhist_waiju_in
dw_bom dw_bom
pb_cal pb_cal
dw_print dw_print
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pu05_00030 w_pu05_00030

type variables
char ic_status
sTring is_gubun, is_cnvart

String is_pspec, is_jijil, is_colname
end variables

forward prototypes
public function integer wf_cnvfat (long lrow, string arg_itnbr)
public subroutine wf_reset ()
public function integer wf_required_chk (integer i)
public function integer wf_required_chk ()
public function integer wf_balju ()
public function integer wf_delete_waiju_jaje (string arg_baljpno, decimal arg_balseq)
public function integer wf_create_waiju_jaje ()
public function integer wf_update_waiju_jaje ()
end prototypes

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

dPrice = dw_insert.getitemdecimal(Lrow, "unprc")
dw_insert.setitem(Lrow, "cnvprc", dPrice)

if dCnvfat = 1 then
	dw_insert.setitem(Lrow, "cnvart", '*')
else	
	dw_insert.setitem(Lrow, "cnvart", is_cnvart)	
end if

dw_insert.setitem(Lrow, "cnvfat", dCnvfat)

// 변환계수 변환에 따른 내역 변경(수량, 단가, 금액)
if dw_insert.getitemdecimal(Lrow, "cnvfat") = 1 then
	dw_insert.setitem(Lrow, "cnvqty", dw_insert.getitemdecimal(Lrow, "balqty"))		
elseif dw_insert.getitemstring(Lrow, "cnvart") = '/' then
	dw_insert.setitem(Lrow, "cnvqty", round(dw_insert.getitemdecimal(Lrow, "balqty") / dCnvfat, 3))
else
	dw_insert.setitem(Lrow, "cnvqty", round(dw_insert.getitemdecimal(Lrow, "balqty") * dCnvfat, 3))
end if

if dw_insert.getitemdecimal(Lrow, "cnvfat") = 1  then
	dw_insert.setitem(Lrow, "cnvamt", round(dw_insert.getitemdecimal(Lrow, "cnvqty") * &
																  dw_insert.getitemdecimal(Lrow, "cnvprc"), 2))			
elseif dw_insert.getitemstring(Lrow, "cnvart") = '/' then
	dw_insert.setitem(Lrow, "unprc",  round(dw_insert.getitemdecimal(Lrow, "cnvprc") / dCnvfat,  5))
	dw_insert.setitem(Lrow, "cnvamt", round(dw_insert.getitemdecimal(Lrow, "cnvqty") * &
																  dw_insert.getitemdecimal(Lrow, "cnvprc"), 2))	
else
	dw_insert.setitem(Lrow, "unprc",  round(dw_insert.getitemdecimal(Lrow, "cnvprc") * dCnvfat,  5))
	dw_insert.setitem(Lrow, "cnvamt", round(dw_insert.getitemdecimal(Lrow, "cnvqty") * &
																  dw_insert.getitemdecimal(Lrow, "cnvprc"), 2))
end if
 
Return 0
end function

public subroutine wf_reset ();dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_pomast.reset()
dw_poblkt.reset()

if Ic_status = '1' then
	dw_1.dataobject = 'd_pu05_00030_1'
	dw_insert.dataobject = 'd_pu05_00030_a_t'
else
	dw_1.dataobject = 'd_pu05_00030_2'
	dw_insert.dataobject = 'd_pu05_00030_b'
end if
dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
	
dw_1.insertrow(0)
if Ic_status = '1' then
	dw_1.setitem(1, "sabu" , gs_sabu)
//	dw_1.setitem(1, "bal_empno" , gs_empno)
//	dw_1.setitem(1, "empname" , f_get_name5("02",gs_empno,""))
	dw_1.Setitem(1, 'baldate', f_today())
	dw_1.setitem(1, "saupj" , gs_saupj)
end if	
dw_1.SetFocus()
ib_any_typing = false
dw_1.Enabled = true

dw_1.setredraw(true)
dw_insert.setredraw(true)

/*사업장별 담당자선택*/
f_child_saupj(dw_1,'bal_empno',gs_Saupj)

end subroutine

public function integer wf_required_chk (integer i);/* 품번 */
IF isnull(dw_insert.getitemstring(i, "itnbr")) or &
	trim(dw_insert.getitemstring(i, "itnbr")) = '' then
	f_message_chk(30, '[품번]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("itnbr")
	dw_insert.setfocus()
	return -1
END IF

if ISNULL(dw_insert.getitemdecimal(i, "unprc")) OR &
	dw_insert.getitemdecimal(i, "unprc") <= 0 then
	f_message_chk(30, '[발주단가]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("unprc")
	dw_insert.setfocus()
	return -1
end if

/* 납기예정일 */
IF isnull(dw_insert.getitemstring(i, "gudat")) or &
	trim(dw_insert.getitemstring(i, "gudat")) = '' then
	f_message_chk(30, '[입고요구일]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("gudat")
	dw_insert.setfocus()
	return -1
END IF

Return 1
end function

public function integer wf_required_chk ();long	i, lrow

FOR lrow = 1 TO dw_insert.rowcount()

	if ISNULL(dw_insert.getitemdecimal(lrow, "balqty")) OR &
		dw_insert.getitemdecimal(lrow, "balqty") < 1 then continue
	i++
NEXT

if i = 0 then
	messagebox('확인','발주수량을 지정하십시오')
	return -1
end if
	

FOR lrow = 1 TO dw_insert.rowcount()
	
	if ISNULL(dw_insert.getitemdecimal(lrow, "balqty")) OR &
		dw_insert.getitemdecimal(lrow, "balqty") < 1 then continue
	
	/* 품번 */
	IF isnull(dw_insert.getitemstring(lrow, "itnbr")) or &
		trim(dw_insert.getitemstring(lrow, "itnbr")) = '' then
		f_message_chk(30, '[품번]')
		dw_insert.scrolltorow(lrow)
		dw_insert.setcolumn("itnbr")
		dw_insert.setfocus()
		return -1
	END IF
	
	if ISNULL(dw_insert.getitemdecimal(lrow, "unprc")) OR &
		dw_insert.getitemdecimal(lrow, "unprc") <= 0 then
		f_message_chk(30, '[발주단가]')
		dw_insert.scrolltorow(lrow)
		dw_insert.setcolumn("unprc")
		dw_insert.setfocus()
		return -1
	end if
	
	/* 납기예정일 */
	IF isnull(dw_insert.getitemstring(lrow, "gudat")) or &
		trim(dw_insert.getitemstring(lrow, "gudat")) = '' then
		f_message_chk(30, '[입고요구일]')
		dw_insert.scrolltorow(lrow)
		dw_insert.setcolumn("gudat")
		dw_insert.setfocus()
		return -1
	END IF
NEXT

Return 1
end function

public function integer wf_balju ();////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 발주처리
string	sdate, ssidt, sempno, sdeptno, sittyp, syymm, scvcod, sbaljpno, sitnbr, sdepot, spdtgu
long		lrow1, lrow2, lrow3, lins1, lins2, lfrow, lcnt
integer	i, dseq

sdate = trim(dw_1.getitemstring(1,'baldate'))
sempno= trim(dw_1.getitemstring(1,"bal_empno"))
scvcod= dw_1.getitemstring(1,"cvcod")

// 외주발주부서
//SELECT DEPTCODE INTO :sdeptno FROM P1_MASTER WHERE EMPNO = :sempno ;			 
SELECT DATANAME INTO :sdeptno FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 11 AND LINENO = 1;

dw_pomast.reset()
dw_poblkt.reset()
setpointer(hourglass!)

dseq = SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'K0')
if dseq = -1 then 
	rollback;
	f_message_chk(51, '')
	return -1
end if
Commit;
sbaljpno = sdate + string(dseq, '0000')

dw_pomast.insertrow(0)
dw_pomast.setitem(1,'sabu',gs_sabu)
dw_pomast.setitem(1,'baljpno',sbaljpno)
dw_pomast.setitem(1,'bal_empno',sempno)
dw_pomast.setitem(1,'baldate',sdate)
dw_pomast.setitem(1,'balgu','3') // 생산용(계획)
dw_pomast.setitem(1,'cvcod',scvcod)
dw_pomast.setitem(1,'bal_suip','1')
dw_pomast.setitem(1,'saupj',gs_saupj)

dw_1.setitem(1,'baljpno',sbaljpno)

FOR lrow2 = 1 TO dw_insert.rowcount()
	if isnull(dw_insert.getitemnumber(lrow2,'balqty')) or &
		dw_insert.getitemnumber(lrow2,'balqty') <= 0 then continue
	
	sitnbr = dw_insert.getitemstring(lrow2,'itnbr')

	// 입고예정창고 지정 - 2004.01.05
	select pdtgu into :spdtgu from itemas
	 where itnbr = :sitnbr ;
	if isnull(spdtgu) or spdtgu = '' then
		spdtgu = '1'
	end if

	
	// 생산팀 지정된 자재 창고 => 입고는 생산창고
	//select cvcod into :sdepot from vndmst where cvgu = '5' and jumaeip = :spdtgu and soguan = '3' and rownum = 1 ;
	select cvcod into :sdepot from vndmst where cvgu = '5' and juprod = '2' and jumaeip = :spdtgu and jumaechul = '1' and rownum = 1 ;
	if sqlca.sqlcode <> 0 then sdepot = 'Z30'
	
	lins2 = dw_poblkt.insertrow(0)
	i++
	dw_poblkt.setitem(lins2,'sabu',gs_sabu)
	dw_poblkt.setitem(lins2,'baljpno',sbaljpno)
	dw_poblkt.setitem(lins2,'balseq',i)
	dw_poblkt.setitem(lins2,'saupj',gs_saupj)
	dw_poblkt.setitem(lins2,'itnbr',sitnbr)
	dw_poblkt.setitem(lins2,'balqty',dw_insert.getitemnumber(lrow2,'balqty'))
	dw_poblkt.setitem(lins2,'balsts','1')
	dw_poblkt.setitem(lins2,'poblkt_tuncu','WON')
	dw_poblkt.setitem(lins2,'unprc',dw_insert.getitemnumber(lrow2,'unprc'))
	dw_poblkt.setitem(lins2,'unamt',dw_insert.getitemnumber(lrow2,'cunamt'))
	dw_poblkt.setitem(lins2,'poblkt_gudat',dw_insert.getitemstring(lrow2,'gudat'))
	dw_poblkt.setitem(lins2,'nadat',dw_insert.getitemstring(lrow2,'gudat'))
	dw_poblkt.setitem(lins2,'rdptno',sdeptno)
	dw_poblkt.SetItem(lins2,'poblkt_ipdpt',sdepot)
	dw_poblkt.SetItem(lins2,'accod',dw_insert.getitemstring(lrow2,'accod'))
	dw_poblkt.SetItem(lins2,'crt_user',gs_empno)
NEXT

if dw_pomast.update() = 1 then
	if dw_poblkt.update() <> 1 then
		rollback ;
		messagebox("저장실패", "발주처리를 실패하였읍니다 [POBLKT]")
		return -1
   end if
else
	rollback ;
	messagebox("저장실패", "발주처리를 실패하였읍니다 [POMAST]")
	return -1
end if

commit ;

return 1
end function

public function integer wf_delete_waiju_jaje (string arg_baljpno, decimal arg_balseq);string	siojpno

select iojpno into :siojpno from imhist
 where sabu = :gs_sabu and baljpno = :arg_baljpno and balseq = :arg_balseq 
   and iogbn = 'O06' ;

if sqlca.sqlcode = 0 then

//	/////////////////////////////////////////////////////////////////
//	delete from imhist
//	 where sabu = :gs_sabu and ip_jpno = :siojpno and iogbn = 'I12' ;
//	if sqlca.sqlcode <> 0 then
//		rollback ;
//		messagebox('확인','생산부품입고 삭제 실패!!!')
//		return -1
//	end if

//	/////////////////////////////////////////////////////////////////
//	delete from imhist
//	 where sabu = :gs_sabu and baljpno = :arg_baljpno and balseq = :arg_balseq
//		and iogbn = 'O03' ;
//	if sqlca.sqlcode <> 0 then
//		rollback ;
//		messagebox('확인','생산부품입고 삭제 실패!!!')
//		return -1
//	end if

	/////////////////////////////////////////////////////////////////
	delete from imhist
	 where sabu = :gs_sabu and baljpno = :arg_baljpno and balseq = :arg_balseq
		and iogbn = 'O06' ;
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox('확인','생산부품출고 삭제 실패!!!')
		return -1
	end if
	
end if
	
return 1
end function

public function integer wf_create_waiju_jaje ();///////////////////////////////////////////////////////////////////////
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '001'
///////////////////////////////////////////////////////////////////////
dec		ld_Seq, ld_InSeq, dqtypr, ld_outqty
long		i, lrow, lfrow1, lvlno, lprlvl, lrowcnt, lrow2, lrowcnt2, lrow3, ll_row, ll_row_in
string	sitnbr, srinbr, skinbr, scinbr, sdepot_out, sdepot_in, ls_Jpno, ls_Jpno_in
string	spdtgu, sittyp, ls_date, slastc, sCvcod

dw_imhist_waiju_out.Reset()
dw_imhist_waiju_in.Reset()

If dw_poblkt.AcceptText() <> 1 Then Return -1
If dw_poblkt.RowCount() < 1 Then Return -1

SetNull(ls_Jpno)
SetNull(ls_Jpno_in)

ls_date = trim(dw_1.getitemstring(1,'baldate'))
scvcod  = dw_1.getitemstring(1,'cvcod')

setpointer(hourglass!)
//////////////////////////////////////////////////////////////////////////////////////
ld_Seq = SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'C0')			
If ld_Seq < 0	Then	
	Rollback;
	RETURN -1
End If			
COMMIT;
ls_Jpno  = ls_date + String(ld_Seq, "0000")

ld_InSeq = SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'C0')
If ld_InSeq < 0 Then	
	Rollback;
	RETURN -1
End If
COMMIT;
ls_Jpno_in  = ls_date + String(ld_inSeq, "0000")


//////////////////////////////////////////////////////////////////////////////////////
For i = 1 To dw_poblkt.rowcount()
	
	// 가공품-품번
	sitnbr = dw_poblkt.getitemstring(i,'itnbr')
	
	srinbr = sitnbr
	slastc = '9'
	
//	select a.itnbr, a.lastc into :srinbr, :slastc 
//	  from routng a, itemas i 
//	 where a.wai_itnbr = :sitnbr 
//	   and a.purgc = 'Y' and a.itnbr = i.itnbr
//		and i.useyn = '0'	and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then continue
	
	if slastc <> '1' and slastc <> '9' then continue  // 최초공정, 최초최종공정이 아니면 제외

	// 소재불출내역 생성
	DECLARE erp_create_pstruc_to_soje PROCEDURE FOR erp_create_pstruc_to_soje(:srinbr);
	EXECUTE erp_create_pstruc_to_soje;
	
	lrowcnt = dw_bom.retrieve(srinbr)
	if lrowcnt < 1 then continue
	
	// 가공품-생산팀
	select pdtgu into :spdtgu from itemas
	 where itnbr = :srinbr ;
	if isnull(spdtgu) or spdtgu = '' then spdtgu = '1'

	// 출고창고는 생산 창고
	select min(cvcod) into :sdepot_in from vndmst where cvgu = '5' and juprod = '2' and ipjogun = :gs_saupj and
			 jumaechul = '1';
	if isnull(sdepot_in) or sdepot_in = '' then sdepot_in = 'Z30'


	/////////////////////////////////////////////////////////////////////////////
	FOR lrow = 1 TO lrowcnt
		lvlno  = dw_bom.getitemnumber(lrow,'lvlno')
		scinbr = dw_bom.getitemstring(lrow,'cinbr')
		sittyp = dw_bom.getitemstring(lrow,'ittyp')
		dqtypr = dw_bom.getitemnumber(lrow,'qtypr')
		
		if sitnbr = scinbr then continue	 // 발주품목 skip
		if dw_bom.getitemstring(lrow,'is_skip') = 'Y' then continue
		
		// 단단계 내역만 
		if lvlno <> 1 Then Continue
		
		// 유상사급 제외
		if dw_bom.getitemstring(lrow,'sagub') = 'Y' then continue

		// 가상품 제외
		if dw_bom.getitemstring(lrow,'ittyp') = '8' then continue
		
//		/* 품목구분이 원재료-단조품(3),가공품(4),조립품(5),철재료(6) */
//		if sittyp = '3' or sittyp = '4' or sittyp = '5' or sittyp = '6' then
//			if dw_bom.getitemstring(lrow,'useyn') <> '0' then continue
//			
//			lrowcnt2 = lrow - 1
//			FOR lrow2 = lrowcnt2 TO 1 STEP -1
//				lprlvl = dw_bom.getitemnumber(lrow2,'lvlno')
//				if lprlvl < lvlno then
//					dqtypr = dqtypr * dw_bom.getitemnumber(lrow2,'qtypr')
//					lvlno  = lprlvl
//				end if
//			NEXT
//
//			/* ittyp=3,4,5,6 하위레벨 skip 지정 */
//			skinbr = scinbr
//			FOR lrow3 = lrow TO lrowcnt
//				if lrow3 > lrowcnt then exit
//				lfrow1 = dw_bom.find("pinbr='"+skinbr+"'",lrow3,lrowcnt)
//				if lfrow1 > 0 then
//					lrow3 = lfrow1
//					dw_bom.setitem(lfrow1,'is_skip','Y')
//					skinbr = dw_bom.getitemstring(lfrow1,'cinbr')
//				else
//					exit
//				end if
//			NEXT
//		end if
//
//		
//		// 자재-생산팀
//		select pdtgu into :spdtgu from itemas
//		 where itnbr = :scinbr ;
//		if isnull(spdtgu) or spdtgu = '' then spdtgu = '1'
	
		// 자재창고
//		select cvcod into :sdepot_out from vndmst
//		 where cvgu = '5' and jumaeip = :spdtgu and soguan = '3' and rownum = 1 ;
//		if isnull(sdepot_out) or sdepot_out = '' then sdepot_out = 'Z03'
		
		ld_outqty = dqtypr * dw_poblkt.Object.balqty[i] // 출고 및 입고수량
		
		
		////////////////////////////////////////////////////////////////////////////////
		// ** 출고 HISTORY 생성 **
		////////////////////////////////////////////////////////////////////////////////
		ll_row = dw_imhist_waiju_out.InsertRow(0)

		dw_imhist_waiju_out.Object.sabu[ll_row]	   =	gs_sabu
		dw_imhist_waiju_out.Object.jnpcrt[ll_row]	   = '002'			                           // 전표생성구분
		dw_imhist_waiju_out.Object.inpcnf[ll_row]    = 'O'				                           // 입출고구분
		dw_imhist_waiju_out.Object.iojpno[ll_row] 	= ls_Jpno + String(ll_row, "000") 
		dw_imhist_waiju_out.Object.iogbn[ll_row]     = 'O06'   											// 수불구분=요청구분
		dw_imhist_waiju_out.Object.sudat[ll_row]	   = ls_date			                        // 수불일자=출고일자
		dw_imhist_waiju_out.Object.itnbr[ll_row]	   = scinbr									         // 품번
		dw_imhist_waiju_out.Object.pspec[ll_row]	   = '.'										         // 사양
		dw_imhist_waiju_out.Object.depot_no[ll_row]  = sdepot_in                              // 기준창고=출고창고
		dw_imhist_waiju_out.Object.cvcod[ll_row]	   = scvcod	                              // 거래처창고=입고처
		dw_imhist_waiju_out.Object.ioqty[ll_row]	   = ld_outqty 	                           // 수불수량=출고수량
		dw_imhist_waiju_out.Object.ioreqty[ll_row]	= ld_outqty	                              // 수불의뢰수량=출고수량		
		dw_imhist_waiju_out.Object.insdat[ll_row]	   = ls_date			                        // 검사일자=출고일자	
		dw_imhist_waiju_out.Object.iosuqty[ll_row]	= ld_outqty                               // 합격수량=출고수량		
		dw_imhist_waiju_out.Object.opseq[ll_row]	   = '9999'                                	// 공정코드
		dw_imhist_waiju_out.Object.ip_jpno[ll_row]   = ''			 	                           // 할당번호
		dw_imhist_waiju_out.Object.filsk[ll_row]     = 'Y'												   // 재고관리유무
		dw_imhist_waiju_out.Object.botimh[ll_row]	   = 'N'                         				// 동시출고여부
		dw_imhist_waiju_out.Object.ioredept[ll_row]  = gs_dept      									// 수불의뢰부서=할당.부서
		dw_imhist_waiju_out.Object.io_confirm[ll_row]= 'Y'		                              	// 수불승인여부
		dw_imhist_waiju_out.Object.io_date[ll_row]	= ls_date			                        // 수불승인일자=출고일자	
		dw_imhist_waiju_out.Object.io_empno[ll_row]  = gs_empno			                        // 수불승인자=담당자	
		dw_imhist_waiju_out.Object.outchk[ll_row]    = 'Y'                              			// 출고의뢰완료
		dw_imhist_waiju_out.Object.baljpno[ll_row]   = dw_poblkt.Object.baljpno[i]      			// 출고의뢰완료
		dw_imhist_waiju_out.Object.balseq[ll_row]    = dw_poblkt.Object.balseq[i]       			// 출고의뢰완료
		dw_imhist_waiju_out.Object.bigo[ll_row]    	= "외주불출에 의한 생산부품출고"
		
//		dw_imhist_waiju_out.Object.sabu[ll_row]	   =	gs_sabu
//		dw_imhist_waiju_out.Object.jnpcrt[ll_row]	   = '002'			                           // 전표생성구분
//		dw_imhist_waiju_out.Object.inpcnf[ll_row]    = 'O'				                           // 입출고구분
//		dw_imhist_waiju_out.Object.iojpno[ll_row] 	= ls_Jpno + String(ll_row, "000") 
//		dw_imhist_waiju_out.Object.iogbn[ll_row]     = 'O03'   											// 수불구분=요청구분
//		dw_imhist_waiju_out.Object.sudat[ll_row]	   = ls_date			                        // 수불일자=출고일자
//		dw_imhist_waiju_out.Object.itnbr[ll_row]	   = scinbr									         // 품번
//		dw_imhist_waiju_out.Object.pspec[ll_row]	   = '.'										         // 사양
//		dw_imhist_waiju_out.Object.depot_no[ll_row]  = sdepot_out                              // 기준창고=출고창고
//		dw_imhist_waiju_out.Object.cvcod[ll_row]	   = sdepot_in	                              // 거래처창고=입고처
//		dw_imhist_waiju_out.Object.ioqty[ll_row]	   = ld_outqty 	                           // 수불수량=출고수량
//		dw_imhist_waiju_out.Object.ioreqty[ll_row]	= ld_outqty	                              // 수불의뢰수량=출고수량		
//		dw_imhist_waiju_out.Object.insdat[ll_row]	   = ls_date			                        // 검사일자=출고일자	
//		dw_imhist_waiju_out.Object.iosuqty[ll_row]	= ld_outqty                               // 합격수량=출고수량		
//		dw_imhist_waiju_out.Object.opseq[ll_row]	   = '9999'                                	// 공정코드
//		dw_imhist_waiju_out.Object.ip_jpno[ll_row]   = ''			 	                           // 할당번호
//		dw_imhist_waiju_out.Object.filsk[ll_row]     = 'N'												   // 재고관리유무
//		dw_imhist_waiju_out.Object.botimh[ll_row]	   = 'N'                         				// 동시출고여부
//		dw_imhist_waiju_out.Object.ioredept[ll_row]  = gs_dept      									// 수불의뢰부서=할당.부서
//		dw_imhist_waiju_out.Object.io_confirm[ll_row]= 'Y'		                              	// 수불승인여부
//		dw_imhist_waiju_out.Object.io_date[ll_row]	= ls_date			                        // 수불승인일자=출고일자	
//		dw_imhist_waiju_out.Object.io_empno[ll_row]  = gs_empno			                        // 수불승인자=담당자	
//		dw_imhist_waiju_out.Object.outchk[ll_row]    = 'Y'                              			// 출고의뢰완료
//		dw_imhist_waiju_out.Object.baljpno[ll_row]   = dw_poblkt.Object.baljpno[i]      			// 출고의뢰완료
//		dw_imhist_waiju_out.Object.balseq[ll_row]    = dw_poblkt.Object.balseq[i]       			// 출고의뢰완료
//		dw_imhist_waiju_out.Object.bigo[ll_row]    	= "외주불출에 의한 생산부품출고"
//		
//		
//		////////////////////////////////////////////////////////////////////////////////
//		// ** 입고 HISTORY 생성 **
//		////////////////////////////////////////////////////////////////////////////////
//	
//		ll_row_in = dw_imhist_waiju_in.InsertRow(0)						
//				
//		dw_imhist_waiju_in.Object.sabu[ll_row_in]     = gs_sabu
//		dw_imhist_waiju_in.Object.jnpcrt[ll_row_in] 	 = '011'			                    				// 전표생성구분
//		dw_imhist_waiju_in.Object.inpcnf[ll_row_in]   = 'I'				                    			// 입출고구분
//		dw_imhist_waiju_in.Object.iojpno[ll_row_in] 	 = ls_Jpno_in +  string(ll_row_in, "000") 
//		dw_imhist_waiju_in.Object.iogbn[ll_row_in]    = 'I12'	                       					// 수불구분=창고이동입고구분
//		dw_imhist_waiju_in.Object.sudat[ll_row_in]	 = ls_date			                 				// 수불일자=출고일자
//		dw_imhist_waiju_in.Object.itnbr[ll_row_in]    = scinbr  												// 품번
//		dw_imhist_waiju_in.Object.pspec[ll_row_in]    = '.'  													// 사양
//		dw_imhist_waiju_in.Object.depot_no[ll_row_in] = sdepot_in                        			// 기준창고=입고처
//		dw_imhist_waiju_in.Object.cvcod[ll_row_in]	 = sdepot_out 			              				// 거래처창고=출고창고
//		dw_imhist_waiju_in.Object.opseq[ll_row_in]	 = '9999'			                 				// 공정코드
//		dw_imhist_waiju_in.Object.ioreqty[ll_row_in]	 = ld_outqty                       				// 수불의뢰수량=출고수량		
//		dw_imhist_waiju_in.Object.insdat[ll_row_in]	 = ls_date			                 				// 검사일자=출고일자	
//		dw_imhist_waiju_in.Object.qcgub[ll_row_in]	 = '1'			                 					// 검사방법=> 무검사
//		dw_imhist_waiju_in.Object.iosuqty[ll_row_in]	 = ld_outqty                       				// 합격수량=출고수량		
//		dw_imhist_waiju_in.Object.filsk[ll_row_in]    = 'N'													// 재고관리유무
//		dw_imhist_waiju_in.Object.io_confirm[ll_row_in]  = 'Y'						                  // 수불승인여부
//		dw_imhist_waiju_in.Object.ioqty[ll_row_in]    = ld_outqty                           		// 수불수량=입고수량
//		dw_imhist_waiju_in.Object.io_date[ll_row_in]  = ls_date		                        		// 수불승인일자=입고의뢰일자
//		dw_imhist_waiju_in.Object.io_empno[ll_row_in] = gs_empno		                        		// 수불승인자=NULL
//		dw_imhist_waiju_in.Object.botimh[ll_row_in]	 = 'N'				                        	// 동시출고여부
//		dw_imhist_waiju_in.Object.ioredept[ll_row_in] = gs_dept												// 수불의뢰부서=할당.부서
//		dw_imhist_waiju_in.Object.ioreemp[ll_row_in]	 = gs_empno	                        			// 수불의뢰담당자=담당자	
//		dw_imhist_waiju_in.Object.ip_jpno[ll_row_in]  = ls_Jpno + String(ll_row, "000")        	// 입고전표번호=출고번호
//		dw_imhist_waiju_in.Object.bigo[ll_row]    	 = "외주불출에 의한 생산부품입고"

	NEXT	
NEXT

if dw_imhist_waiju_out.update() = 1 then
	if dw_imhist_waiju_in.update() <> 1 then
		rollback ;
		messagebox("저장실패", "생산부품출고를 실패하였읍니다 [IMHIST]")
		return -1
   end if
else
	rollback ;
	messagebox("저장실패", "생산부품입고를 실패하였읍니다 [IMHIST]")
	return -1
end if

commit ;

RETURN 1
end function

public function integer wf_update_waiju_jaje ();long		lrow
string	sbaljpno, siojpno
decimal	dbalqty, dtmpqty, dbalseq

dw_insert.accepttext()

FOR lrow = 1 TO dw_insert.rowcount()
	sbaljpno = dw_insert.getitemstring(lrow,'baljpno')
	dbalseq	= dw_insert.getitemnumber(lrow,'balseq')
	dbalqty	= dw_insert.getitemnumber(lrow,'balqty')
	dtmpqty	= dw_insert.getitemnumber(lrow,'tmpqty')
	
	if dbalqty = dtmpqty then continue  // 변경사항 없으면 continue

	dw_insert.setitem(lrow,'tmpqty',dbalqty)
	
	select iojpno into :siojpno from imhist
	 where sabu = :gs_sabu and baljpno = :sbaljpno and balseq = :dbalseq
	   and iogbn = 'O06' ;

	if sqlca.sqlcode = 0 then
		/////////////////////////////////////////////////////////////////
		update imhist
			set ioqty = :dbalqty, iosuqty = :dbalqty, ioreqty = :dbalqty
		 where sabu = :gs_sabu and baljpno = :sbaljpno and balseq = :dbalseq
			and iogbn = 'O06' ;
		if sqlca.sqlcode <> 0 then
			rollback ;
			messagebox('확인','부품출고(외주) 갱신 실패!!!')
			return -1
		end if

//		/////////////////////////////////////////////////////////////////
//		update imhist
//			set ioqty = :dbalqty, iosuqty = :dbalqty, ioreqty = :dbalqty
//		 where sabu = :gs_sabu and ip_jpno = :siojpno and iogbn = 'I12' ;
//		if sqlca.sqlcode <> 0 then
//			rollback ;
//			messagebox('확인','생산부품입고 갱신 실패!!!')
//			return -1
//		end if
//
//		/////////////////////////////////////////////////////////////////
//		update imhist
//			set ioqty = :dbalqty, iosuqty = :dbalqty, ioreqty = :dbalqty
//		 where sabu = :gs_sabu and baljpno = :sbaljpno and balseq = :dbalseq
//			and iogbn = 'O03' ;
//		if sqlca.sqlcode <> 0 then
//			rollback ;
//			messagebox('확인','생산부품입고 갱신 실패!!!')
//			return -1
//		end if

	end if
NEXT

commit ;

return 1
end function

on w_pu05_00030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.dw_hidden=create dw_hidden
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_pomast=create dw_pomast
this.dw_poblkt=create dw_poblkt
this.dw_imhist_waiju_out=create dw_imhist_waiju_out
this.dw_imhist_waiju_in=create dw_imhist_waiju_in
this.dw_bom=create dw_bom
this.pb_cal=create pb_cal
this.dw_print=create dw_print
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_hidden
this.Control[iCurrent+4]=this.rb_delete
this.Control[iCurrent+5]=this.rb_insert
this.Control[iCurrent+6]=this.dw_pomast
this.Control[iCurrent+7]=this.dw_poblkt
this.Control[iCurrent+8]=this.dw_imhist_waiju_out
this.Control[iCurrent+9]=this.dw_imhist_waiju_in
this.Control[iCurrent+10]=this.dw_bom
this.Control[iCurrent+11]=this.pb_cal
this.Control[iCurrent+12]=this.dw_print
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
end on

on w_pu05_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.dw_hidden)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_pomast)
destroy(this.dw_poblkt)
destroy(this.dw_imhist_waiju_out)
destroy(this.dw_imhist_waiju_in)
destroy(this.dw_bom)
destroy(this.pb_cal)
destroy(this.dw_print)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;
///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 구매의뢰 -> 발주확정 연산자를 환경설정에서 검색함 */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '4';
 
If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
End if
is_cnvart = sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

is_gubun = sCnvgu

dw_1.settransobject(sqlca)
dw_bom.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_pomast.settransobject(sqlca)
dw_poblkt.settransobject(sqlca)
dw_imhist_waiju_out.settransobject(sqlca)
dw_imhist_waiju_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

rb_insert.checked = true
rb_insert.triggerevent(clicked!)
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pu05_00030
integer x = 37
integer y = 280
integer width = 4553
integer height = 1936
integer taborder = 20
string dataobject = "d_pu05_00030_a_t"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String sData, sPrvdata, sNull, sName, sItem, sSpec, scvnas, stuncu, saccod, &
       sjijil, sispec_code, sProject, scode, scvcod, get_nm, get_nm2 
Decimal {5} dPrvdata, dData
Long lrow ,ll_cnt
Integer ireturn

Lrow = this.getrow()

Setnull(sNull)

IF this.GetColumnName() = "itnbr"	THEN
	sitem = trim(this.GetText())
	
	ll_cnt = 0 
	
//	Select Count(*) Into :ll_cnt
//	  From ROUTNG
//	 Where wai_itnbr = :sitem ;
//		
//	If ll_cnt < 1 Or isNull(ll_cnt) Then
//		MessageBox('확인','외주공정에 속하지 않은 품번입니다. 외주발주을 할 수 없습니다.')
//		this.setitem(lrow, "itnbr", sNull)
//		this.setitem(lrow, "itemas_itdsc", sNull)
//		Return 1
//	End If
	
	ireturn = f_get_name4('품번', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	

	
	f_buy_unprc(sitem, '.','9999', scvcod, scvnas, ddata, stuncu)
	this.setitem(Lrow, "unprc", dData)
	this.setitem(Lrow, "cvcod", scvcod)
	this.setitem(Lrow, "cvnas", scvnas)
	
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "tuncu", 'WON')
	else
		this.setitem(Lrow, "tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

   if sitem = '' or isnull(sitem) then 
		this.setitem(lrow, "accod", sNull)
	else	
		sAccod = SQLCA.FUN_GET_ITNACC(sitem, '5') ;
		this.setitem(lrow, "accod", sAccod)
   end if
	
//   SELECT "ROUTNG"."ITNBR"||' / '||"ROUTNG"."OPDSC"
//     INTO :get_nm
//     FROM "ROUTNG"
//    WHERE ( "ROUTNG"."WAI_ITNBR" = :sitem ) AND ROWNUM = 1   ;
//   
//	this.setitem(lrow, "opdsc", get_nm)
			
	RETURN ireturn

ELSEif this.getcolumnname() = 'nadat' then
	scvcod = TRIM(this.GetText())	
	if isnull(scvcod) or trim(scvcod) ='' or f_datechk(scvcod) = -1 then
		Messagebox("확인", "유효한 일자를 입력하십시요", stopsign!)
		dw_insert.setitem(lrow, "nadat", snull)
		dw_insert.SetColumn('nadat')
		dw_insert.SetFocus()
		return 1		
	end if	

ELSEif getcolumnname() = 'balqty' then
	dData = Dec(gettext())
	
	// 등록인 경우 return
	If rb_insert.Checked Then
		If dData <= 0 Then
			SetItem(lrow, 'gudat', sNull)
		Else
			sCode = dw_1.GetItemString(1, 'baldate')
			SetItem(lrow, 'gudat', f_afterday(scode,3))
		End If
		
		Return 
	End If
	
	dPrvdata = getitemdecimal(lrow, 'balqty')
	
	if dData < getitemdecimal(lrow, "rcqty") or &
	   dData < getitemdecimal(lrow, "lcoqty") then
		f_message_chk(305, '[발주수량]')
		setitem(lrow, "balqty", dPrvdata)
		return 1
	end if
	if dData < 1 then
		f_message_chk(30, '[발주수량]')
		setitem(lrow, "balqty", dPrvdata)
		return 1
	end if		
	
	// 변환계수에 의한 수량변환
	if getitemdecimal(Lrow, "cnvfat") = 1  then
		setitem(Lrow, "cnvqty", dData)
	elseif getitemstring(Lrow, "cnvart") = '/' then
		if dData = 0 then
			setitem(Lrow, "cnvqty", 0)
		Else
			setitem(Lrow, "cnvqty", round(dData / getitemdecimal(Lrow, "cnvfat"), 3))
		End if
	else
		setitem(Lrow, "cnvqty", round(dData * getitemdecimal(Lrow, "cnvfat"), 3))
	end if
	
	Setitem(lrow, "cnvamt", getitemdecimal(Lrow, "cnvprc") * &
											 getitemdecimal(Lrow, "cnvqty"))
ELSEif getcolumnname() = 'unprc' then
	dPrvdata = getitemdecimal(lrow, 'unprc')
	dData = Dec(gettext())
	if dData <= 0 then
		f_message_chk(30, '[발주단가]')
		setitem(lrow, "unprc", dPrvdata)
		return 1
	end if	
	
	// 등록인 경우 return
	If rb_insert.Checked Then Return 
	
	// 변환계수에 의한 단가변환
	if getitemdecimal(Lrow, "cnvfat") = 1   then
		setitem(Lrow, "cnvprc", dData)
	elseif getitemstring(Lrow, "cnvart") = '/'  then
		IF ddata = 0 then
			setitem(Lrow, "cnvprc", 0)			
		else
			setitem(Lrow, "cnvprc", ROUND(dData * getitemdecimal(Lrow, "cnvfat"),5))
		end if
	else
		setitem(Lrow, "cnvprc", ROUND(dData / getitemdecimal(Lrow, "cnvfat"),5))
	end if
	setitem(Lrow, "cnvamt", Round(getitemdecimal(Lrow, "cnvqty") * &
													 getitemdecimal(Lrow, "cnvprc"), 2))
	

End if
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Long Lrow
String sitnbr

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lrow = this.getrow()

// 품번
IF this.GetColumnName() = 'itnbr' or this.GetColumnName() = 'itemas_itdsc' Or &
   this.GetColumnName() = 'itemas_ispec'  THEN

	open(w_itemas_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	
	SetColumn("itnbr")
	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
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

event dw_insert::ue_pressenter;if this.getcolumnname() = 'cvcod' and this.getrow() = this.rowcount() then
	p_ins.postevent(clicked!)
end if

Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;is_colname = this.getcolumnname()
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(currentrow,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pu05_00030
boolean visible = false
integer x = 795
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pu05_00030
boolean visible = false
integer x = 567
integer y = 2408
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pu05_00030
boolean visible = false
integer x = 1184
integer y = 2444
integer width = 306
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\특기사항등록_d.gif"
end type

event p_search::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if	

open(w_imt_02041)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\특기사항등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\특기사항등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pu05_00030
integer x = 3557
integer y = 36
boolean originalsize = true
string picturename = "C:\erpman\image\출고증_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\출고증_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\출고증_up.gif"
end event

event p_ins::clicked;call super::clicked;String ls_balju

ls_balju = trim(dw_1.Object.baljpno[1])
If IsNull(ls_balju) Or ls_balju = '' Then Return

If dw_print.Retrieve(gs_sabu, ls_balju) > 0 Then
	iF dw_print.rowcount() > 0 then 
		gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
	ELSE
		gi_page = 1
	END IF
	OpenWithParm(w_print_options, dw_print)
End If

end event

type p_exit from w_inherite`p_exit within w_pu05_00030
integer x = 4425
integer y = 40
end type

type p_can from w_inherite`p_can within w_pu05_00030
integer x = 4251
integer y = 40
end type

event p_can::clicked;call super::clicked;rb_insert.checked = true
rb_insert.triggerevent(clicked!)
end event

type p_print from w_inherite`p_print within w_pu05_00030
boolean visible = false
integer x = 1600
integer y = 2360
integer width = 306
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

event p_print::clicked;call super::clicked;//발주처 품목선택	-버턴명
string sopt, scvcod, sitem, stuncu, scvnas, saccod, spspec='.', sopseq='9999'
int    k, iRow
Decimal {5} ddata


IF dw_1.AcceptText() = -1	THEN	RETURN

sCvcod = dw_1.getitemstring(1, "cvcod")
gs_gubun = dw_1.getitemstring(1, "bal_empno")

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[발주처]')
	dw_1.SetColumn("cvcod")
	dw_1.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code = sCvcod
open(w_vnditem_popup2)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if sopt = 'Y' then 
		iRow = dw_insert.insertrow(0)

		dw_insert.setitem(iRow, "sabu", gs_sabu)
		if iRow = 1 then 
			dw_insert.setitem(iRow, "balseq", 1)
		else
			dw_insert.setitem(iRow, "balseq", dw_insert.getitemnumber(iRow - 1, "balseq") + 1 )
		end if
      sitem = 	dw_hidden.getitemstring(k, 'poblkt_itnbr' )
		dw_insert.setitem(irow, 'itnbr', sitem)
		dw_insert.setitem(irow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(irow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
//		dw_insert.setitem(irow, 'pspec', dw_hidden.getitemstring(k, 'poblkt_pspec' ))
		
		f_buy_unprc(sitem, '.', sopseq, scvcod, scvnas, ddata, stuncu)
		dw_insert.setitem(irow, "unprc", ddata)
		
		if isnull(stuncu) or trim(stuncu) = '' then
			dw_insert.setitem(irow, "poblkt_tuncu", 'WON')
		else
			dw_insert.setitem(irow, "poblkt_tuncu", stuncu)
		end if
		if irow > 1 then 
			dw_insert.setitem(irow, 'nadat', dw_insert.getitemstring(1, 'nadat'))
		end if
		
		// 연산자에 대한 자료 저장
		if is_gubun = 'Y' then
			dw_insert.SetItem(iRow, "poblkt_cnvart", is_cnvart)
		else
			dw_insert.SetItem(iRow, "poblkt_cnvart", '*')
		end if
		
		wf_cnvfat(irow, sitem)
		
		sAccod = SQLCA.FUN_GET_ITNACC(sitem, '4') ;
		dw_insert.setitem(iRow, "accod", sAccod)
		
	end if	
NEXT
dw_hidden.reset()
dw_insert.ScrollToRow(iRow)
dw_insert.setrow(iRow)
dw_insert.SetColumn("balqty")
dw_insert.SetFocus()

ib_any_typing = true
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\발주처품목선택_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\발주처품목선택_up.gif"
end event

type p_inq from w_inherite`p_inq within w_pu05_00030
integer x = 3730
integer y = 40
end type

event p_inq::clicked;call super::clicked;String	ls_balju, ls_cvcod

If dw_1.AcceptText() = -1 Then Return 

If ic_status = '1' Then
	ls_cvcod = trim(dw_1.Object.cvcod[1])
	
	If ls_cvcod = '' or isNull(ls_cvcod) Then
		f_message_chk(30,'[업체코드]')
		dw_1.SetFocus()
		dw_1.SetColumn('cvcod')
		Return
	End If
	
	If dw_insert.Retrieve(ls_cvcod) < 1 Then 
		f_message_chk(50,'')
		dw_1.Setcolumn('cvcod')
		dw_1.SetFocus()
		Return
	End If
	
Else
	ls_balju = trim(dw_1.Object.baljpno[1])
	
	If ls_balju = '' or isNull(ls_balju) Then
		f_message_chk(30,'[발주번호]')
		dw_1.SetFocus()
		dw_1.SetColumn(1)
		Return
	End If
	
	If dw_insert.Retrieve(gs_sabu, ls_balju) < 1 Then 
		f_message_chk(50,'')
		dw_1.Setcolumn('baljpno')
		dw_1.SetFocus()
		Return
	End If
End If
end event

type p_del from w_inherite`p_del within w_pu05_00030
integer x = 4078
integer y = 40
end type

event p_del::clicked;call super::clicked;Long   ll_row, ll_r , ll_r2 , i
String ls_mod , ls_new , ls_Baljpno, sitnbr
Dec    ld_balqty , ld_rcqty, ld_balseq 

If dw_insert.AcceptText() = -1 Then Return
If dw_1.AcceptText() = -1 Then Return 

ll_row = dw_insert.getrow()
If ll_row < 1 Then Return

ld_rcqty = dw_insert.Object.rcqty[ll_row]
If ld_rcqty  > 0 Then
	Messagebox("삭제", "이미 진행된 자료입니다", stopsign!)
	Return
End if

If ic_status = '1' Then
	dw_insert.DeleteRow(ll_row)
Else
	sitnbr = dw_insert.getitemstring(ll_row,'itnbr')
	If dw_insert.rowcount() > 1 Then 
		If MessageBox("삭 제","품번 : "+sitnbr+" 를 삭제 하시겠습니까?",Question!, YesNo!, 2) <> 1 Then Return
	Else
		If MessageBox("삭 제", "마지막 자료를 삭제하시면 발주에 모든 자료가 삭제됩니다. ~n~n" + &
							  "삭제 하시겠습니까?",Question!, YesNo!, 2) <> 1 Then Return
	End If	
	
	dw_insert.SetRedraw(FALSE)
	
	
	///////////////////////////////////////////////////////////////////////////
	// 외주발주에 의한 부품입출고 삭제
	ls_Baljpno = dw_insert.getitemstring(ll_row,'baljpno')
	ld_balseq  = dw_insert.getitemnumber(ll_row,'balseq')
	
	if wf_delete_waiju_jaje(ls_Baljpno,ld_balseq) = -1 then return
	
	
	dw_insert.DeleteRow(ll_row)
	
	if dw_insert.Update() = 1 then
		if dw_insert.rowcount() < 1 then 
			DELETE FROM PORMKS  WHERE SABU = :gs_sabu AND BALJPNO =  :ls_Baljpno   ;
			DELETE FROM POMAST  WHERE SABU = :gs_sabu AND BALJPNO =  :ls_Baljpno   ;
		
			if sqlca.sqlcode <> 0 then 
				rollback ;
				messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
				p_inq.triggerevent(clicked!)
				dw_insert.SetRedraw(TRUE)
				return 
			end if	
			commit ;
			
			dw_insert.SetRedraw(TRUE)
			sle_msg.text =	"자료를 삭제하였습니다!!"	
			p_can.triggerevent(clicked!)
			return 
		end if	
		sle_msg.text =	"자료를 삭제하였습니다!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		p_inq.triggerevent(clicked!)
	end if	
	
	dw_insert.SetRedraw(TRUE)
end if
end event

type p_mod from w_inherite`p_mod within w_pu05_00030
integer x = 3904
integer y = 40
end type

event p_mod::clicked;call super::clicked;String ls_mod ,ls_new 
String ls_date, ls_Baljpno,ls_cvcod , ls_empno ,ls_get_nm
Dec    ld_rcqty
Long   i, ll_seq ,ll_dseq

If dw_insert.AcceptText() = -1 Then Return 
if dw_1.AcceptText() = -1 Then Return 
If dw_insert.rowcount() < 1 Then Return 

ls_date  = Trim(dw_1.Object.baldate[1])
ls_empno = Trim(dw_1.Object.bal_empno[1])
ls_baljpno = Trim(dw_1.Object.baljpno[1])

If ic_status = '1' Then
	If ls_date = '' Or isNull(ls_date) Or f_datechk(ls_date) < 1 Then
		f_message_chk(30, '[발주일자]')
		dw_1.setcolumn("baldate")
		dw_1.setfocus()
		Return
	End If
	If ls_empno = '' Or isNull(ls_empno) Then
		f_message_chk(30, '[발주담당자]')
		dw_1.setcolumn("bal_empno")
		dw_1.setfocus()
		Return
	End If

	IF wf_required_chk() = -1 THEN RETURN

	If f_msg_Update() < 1 Then Return
	if wf_balju() = -1 then return
	
	// 외주발주에 의한 부품입출고 생성
	if wf_create_waiju_jaje() = -1 then return
	
	ls_Baljpno = dw_poblkt.GetItemString(1, 'baljpno')
	
	If messagebox('확인','외주 발주처리를 완료하였습니다.~r~n반출증을 인쇄하시겠습니까?', Information!, YesNo!) = 1 Then
		p_ins.TriggerEvent(Clicked!)
	End If
	
	p_can.TriggerEvent(Clicked!)	
Else
	
	If ls_baljpno = '' Or isNull(ls_baljpno) Then
		f_message_chk(30, '[발주번호]')
		dw_1.setcolumn("baljpno")
		dw_1.setfocus()
		Return
	End If
	
	
//	Select Sum(rcqty) Into :ld_rcqty
//	  From poblkt
//	 Where sabu = :gs_sabu And baljpno = :ls_baljpno ;
//	 
//	If SQLCA.SQLCODE <> 0 Then 
//		f_message_chk(51, '')
//		Return
//	End If
//	
//	If ld_rcqty > 0 Then
//		MessageBox('확인','이미 진행중인 발주입니다. 수정 불가능합니다.')
//		Return
//	End If
	
	FOR i = 1 TO dw_insert.RowCount()
		dw_insert.Object.unamt[i] = dw_insert.Object.cunamt[i]
		dw_insert.Object.upd_user[i] = gs_empno
	Next
	dw_insert.AcceptText()
	
	For i=1 To dw_insert.RowCount()
		IF wf_required_chk(i) = -1 THEN RETURN		
	NEXT
	
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('DB-ERROR-3','POBLKT UPDATE ERROR')
		Return
	Else
		Commit;
	End If
	
	// 외주발주에 의한 부품입출고 갱신
	if wf_update_waiju_jaje() = -1 then return
	
	messagebox('확인','자료를 저장하였습니다.')
End if

//wf_reset()
ib_any_typing = FALSE
end event

type cb_exit from w_inherite`cb_exit within w_pu05_00030
integer x = 2162
integer y = 2712
end type

type cb_mod from w_inherite`cb_mod within w_pu05_00030
integer x = 407
integer y = 2696
end type

type cb_ins from w_inherite`cb_ins within w_pu05_00030
integer x = 59
integer y = 2692
end type

type cb_del from w_inherite`cb_del within w_pu05_00030
integer x = 754
integer y = 2700
end type

type cb_inq from w_inherite`cb_inq within w_pu05_00030
integer x = 1102
integer y = 2704
end type

type cb_print from w_inherite`cb_print within w_pu05_00030
integer x = 1449
integer y = 2708
end type

type st_1 from w_inherite`st_1 within w_pu05_00030
integer x = 23
end type

type cb_can from w_inherite`cb_can within w_pu05_00030
integer x = 1801
integer y = 2716
end type

type cb_search from w_inherite`cb_search within w_pu05_00030
integer x = 2533
integer y = 2716
integer width = 434
integer height = 168
integer taborder = 100
boolean enabled = false
string text = "특기사항등록"
end type

type dw_datetime from w_inherite`dw_datetime within w_pu05_00030
integer x = 2866
end type

type sle_msg from w_inherite`sle_msg within w_pu05_00030
integer x = 375
end type



type gb_button1 from w_inherite`gb_button1 within w_pu05_00030
end type

type gb_button2 from w_inherite`gb_button2 within w_pu05_00030
end type

type dw_1 from datawindow within w_pu05_00030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 12
integer width = 2510
integer height = 252
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pu05_00030_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String ls_col ,ls_cod , ls_cvnas 
Long   ll_cnt ,ll_row

AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "is_new"
		If ls_cod = '1' Then
			wf_reset()
		End If
		SetColumn(1)
	Case "baljpno"
		IF	Isnull(ls_cod)  or  ls_cod = ''	Then
			wf_reset()
			
		Else
			dw_1.Retrieve(gs_sabu,ls_cod)
			dw_1.Enabled = False
   	END IF
		Return
	Case "baldate"
		If ls_cod = '' or isNull(ls_cod) Or f_dateChk(ls_cod) < 1 then
			f_message_chk(35,'[발주일자]')
			Return 1
		End If
		
	Case "cvcod" 
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[거래처]')
			SetColumn(ls_col)
			Return 1
		End If
		Select cvnas 
		  Into :ls_cvnas 
		  From vndmst
		  Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.vndmst_cvnas2[GetRow()] = ""
			Return 1
		End If
		
		This.Object.vndmst_cvnas2[GetRow()] = ls_cvnas
		
		p_inq.triggerevent(clicked!)
		
//	Case "bal_empno"
//									
//		String ls_name ,ls_name2
//		f_get_name2('사번', 'Y', ls_cod, ls_name, ls_name2)    //1이면 실패, 0이 성공	
//	
//		this.setitem(1, 'bal_empno', ls_cod)
//		this.setitem(1, 'empname', ls_name)
		
End Choose


	

end event

event itemerror;return 1
end event

event rbuttondown;String sNull

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)

IF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_pu05_00030_popup01)
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
   this.setitem(1, 'baljpno', gs_code)
	
	If dw_insert.Retrieve(gs_sabu, gs_code) < 1 Then 
		Setcolumn('baljpno')
		SetFocus()
		Return
	Else
		This.Enabled = False
	End If
	
   THIS.TriggerEvent(ItemChanged!)
   return 1 
ELSEIF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "vndmst_cvnas2", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
//	this.SetItem(1, "vndmst_cvnas2", gs_Codename)
	
//ELSEIF this.GetColumnName() = 'bal_empno'	THEN
//	Open(w_sawon_popup)
//	if Isnull(gs_code) or Trim(gs_code) = "" then return
//	SetItem(1,"bal_empno",gs_code)
//	this.TriggerEvent("itemchanged")
END IF


end event

event editchanged;ib_any_typing =True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)

RETURN 1
end event

type cbx_1 from checkbox within w_pu05_00030
boolean visible = false
integer x = 1170
integer y = 2376
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "자동채번"
boolean checked = true
end type

type dw_hidden from datawindow within w_pu05_00030
boolean visible = false
integer x = 41
integer y = 2300
integer width = 494
integer height = 316
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_delete from radiobutton within w_pu05_00030
integer x = 2606
integer y = 148
integer width = 242
integer height = 52
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

dw_insert.setredraw(False)
wf_reset()
dw_insert.setredraw(true)

pb_cal.Visible = False
end event

type rb_insert from radiobutton within w_pu05_00030
integer x = 2606
integer y = 64
integer width = 242
integer height = 52
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

dw_insert.setredraw(False)
wf_reset()
dw_insert.setredraw(true)

pb_cal.Visible = True
end event

type dw_pomast from datawindow within w_pu05_00030
boolean visible = false
integer x = 4791
integer y = 996
integer width = 864
integer height = 232
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "POMAST"
string dataobject = "d_pu01_00030_pomast"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_poblkt from datawindow within w_pu05_00030
boolean visible = false
integer x = 4786
integer y = 708
integer width = 832
integer height = 260
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "POBLKT"
string dataobject = "d_pu01_00030_poblkt"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist_waiju_out from datawindow within w_pu05_00030
boolean visible = false
integer x = 4110
integer y = 2576
integer width = 1609
integer height = 360
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_waiju_out"
string dataobject = "d_pdt_imhist"
boolean resizable = true
boolean livescroll = true
end type

type dw_imhist_waiju_in from datawindow within w_pu05_00030
boolean visible = false
integer x = 4091
integer y = 2956
integer width = 1609
integer height = 360
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_waiju_in"
string dataobject = "d_pdt_imhist"
boolean resizable = true
boolean livescroll = true
end type

type dw_bom from datawindow within w_pu05_00030
boolean visible = false
integer x = 4123
integer y = 2288
integer width = 937
integer height = 244
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "BOM"
string dataobject = "d_pu01_00010_b"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_cal from u_pb_cal within w_pu05_00030
integer x = 855
integer y = 44
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('baldate')
IF IsNull(gs_code) THEN Return
If dw_1.Object.baldate.protect = '1' Or dw_1.Object.baldate.TabSequence = '0' Then Return

dw_1.SetItem(1, 'baldate', gs_code)
end event

type dw_print from datawindow within w_pu05_00030
boolean visible = false
integer x = 2994
integer y = 104
integer width = 224
integer height = 132
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_pu05_00030_p1"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pu05_00030
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1115
integer y = 2352
integer width = 443
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu05_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 272
integer width = 4581
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pu05_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2546
integer y = 12
integer width = 338
integer height = 240
integer cornerheight = 40
integer cornerwidth = 46
end type

