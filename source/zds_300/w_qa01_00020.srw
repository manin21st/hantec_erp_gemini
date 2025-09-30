$PBExportHeader$w_qa01_00020.srw
$PBExportComments$** 입하품질검사
forward
global type w_qa01_00020 from w_inherite
end type
type cb_1 from commandbutton within w_qa01_00020
end type
type dw_ip from datawindow within w_qa01_00020
end type
type rb_insert from radiobutton within w_qa01_00020
end type
type rb_delete from radiobutton within w_qa01_00020
end type
type dw_imhist_out from datawindow within w_qa01_00020
end type
type p_list from uo_picture within w_qa01_00020
end type
type dw_imhist_nitem_out from datawindow within w_qa01_00020
end type
type dw_imhist_nitem_in from datawindow within w_qa01_00020
end type
type p_sort from picture within w_qa01_00020
end type
type cb_2 from commandbutton within w_qa01_00020
end type
type cb_3 from commandbutton within w_qa01_00020
end type
type rr_3 from roundrectangle within w_qa01_00020
end type
type rr_1 from roundrectangle within w_qa01_00020
end type
end forward

global type w_qa01_00020 from w_inherite
integer width = 4672
integer height = 3260
string title = "수입검사 등록"
cb_1 cb_1
dw_ip dw_ip
rb_insert rb_insert
rb_delete rb_delete
dw_imhist_out dw_imhist_out
p_list p_list
dw_imhist_nitem_out dw_imhist_nitem_out
dw_imhist_nitem_in dw_imhist_nitem_in
p_sort p_sort
cb_2 cb_2
cb_3 cb_3
rr_3 rr_3
rr_1 rr_1
end type
global w_qa01_00020 w_qa01_00020

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" 

end prototypes

type variables
String ic_status 

str_qa01_00020 str_00020


string  is_syscnfg  //합불판정 방법(1:직접, 2;불량수량)

String      is_ispec, is_jijil
end variables

forward prototypes
public subroutine wf_modify_gubun ()
public function integer wf_imhist_create_nitem ()
public function integer wf_imhist_delete_nitem (long arg_row)
public function integer wf_waiju ()
public function integer wf_update ()
public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun)
public function integer wf_initial ()
public function integer wf_imhfat_create (string arg_iojpno, string arg_bulcod, decimal arg_bulqty)
public function integer wf_imhist_delete (integer ar_row)
public function integer wf_checkrequiredfield ()
public function integer wf_check ()
end prototypes

public subroutine wf_modify_gubun ();//////////////////////////////////////////////////////////////////////
// 1. 검사결과내역
//	2. 수불승인된 내역은 수정불가
//	3. 수불승인자 = NULL 인내역은 수정가능
//////////////////////////////////////////////////////////////////////
string	sConfirm, sEmpno
long		lRow 

FOR lRow = 1	TO		dw_insert.RowCount()

	sConfirm = dw_insert.GetItemString(lRow, "imhist_io_confirm")
	sEmpno   = dw_insert.GetItemString(lRow, "imhist_io_empno")
//	dw_insert.setitem(lrow, "iofaqty_temp", dw_insert.getitemdecimal(lrow, "imhist_iofaqty"))
//	dw_insert.setitem(lrow, "iocdqty_temp", dw_insert.getitemdecimal(lrow, "imhist_iocdqty"))
	dw_insert.SetItem(lRow, "gubun", 'Y')	

	/* 수동 승인된 내역은 수정불가 */
	IF ( sConfirm = 'N' ) and	Not IsNull(sEmpno)	THEN
		dw_insert.SetItem(lRow, "gubun", 'N')							// 수정불가
	END IF
	
	/* 특채요청된 내역은 수정불가 
		-. 특채요청은 검사이후에 발생함	*/
	IF dw_insert.getitemdecimal(lrow, "imhist_tukqty") > 0 then
		dw_insert.SetItem(lRow, "gubun", 'N')							// 수정불가
	END IF
		

NEXT

dw_insert.accepttext()
end subroutine

public function integer wf_imhist_create_nitem ();///////////////////////////////////////////////////////////////////////
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
			sGubun ,    &
			sSaleYn,		&
			sQcGubun,	&
			sQcEmpno,	&
			sStockGubun,	&
			sNull, sMaigbn,sIogbn_in, sIogbn, sDeptcode, sIojpno, sOpseq, &
			sLcno, sLocal, sitnbr, sitnbr_in, sjnpcrt, sjnpcrt_in, sdepot_in, sinjpno
long		lRow, lRowOut, lRowIn 
long 		dSeq, dOutSeq, dInSeq 
SetNull(sNull)

dw_insert.AcceptText()

////////////////////////////////////////////////////////////////////////
dw_imhist_nitem_out.reset()
dw_imhist_nitem_in.reset()

siogbn	 = 'O25'		// 품목대체출고
sjnpcrt	 = '001'
sIogbn_in = 'I13'		// 품목대체입고
sjnpcrt_in= '011'


FOR lRow = 1 TO dw_insert.RowCount()
	if dw_insert.GetItemString(lRow, "gubun") = 'N' then continue
	
	// 상품인 자료만 처리
	sitnbr = dw_insert.GetItemString(lRow, "imhist_itnbr")
	select itnbryd into :sitnbr_in from item_rel
	 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
	if sqlca.sqlcode <> 0 then continue

	
	sDate = dw_insert.GetItemString(lRow, "imhist_insdat")
	dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dSeq < 1		THEN
		ROLLBACK;
		f_message_chk(51,'[품목대체출고 전표번호]')	
		RETURN -1
	END IF
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 1		THEN
		ROLLBACK;
		f_message_chk(51,'[품목대체입고 전표번호]')
		RETURN -1
	END IF

	sJpno  = sDate + string(dSeq, "0000")

	lRowOut = dw_imhist_nitem_out.InsertRow(0)

	sEmpno  = dw_insert.GetItemString(lRow, "imhist_io_empno")				// 입고의뢰자
	sVendor = dw_insert.GetItemString(lRow, "imhist_depot_no")
	sinjpno = dw_insert.GetItemString(lRow, "imhist_iojpno")

	dw_imhist_nitem_out.SetItem(lRowOut, "sabu",		gs_sabu)
	dw_imhist_nitem_out.SetItem(lRowOut, "jnpcrt",	sjnpcrt)
	dw_imhist_nitem_out.SetItem(lRowOut, "inpcnf",  'O')
	dw_imhist_nitem_out.SetItem(lRowOut, "iojpno",  sJpno+string(lRowOut, "000"))
	dw_imhist_nitem_out.SetItem(lRowOut, "iogbn",   siogbn)
	dw_imhist_nitem_out.SetItem(lRowOut, "sudat",	sDate)
	dw_imhist_nitem_out.SetItem(lRowOut, "itnbr",	sitnbr)
	dw_imhist_nitem_out.SetItem(lRowOut, "pspec",	'.')
	dw_imhist_nitem_out.SetItem(lRowOut, "opseq",	'9999')

	dw_imhist_nitem_out.SetItem(lRowOut, "depot_no", svendor)

	SELECT MIN(CVCOD) INTO :sdepot_in FROM VNDMST
	 WHERE CVGU = '5' AND SOGUAN = '1' ;
	if sqlca.sqlcode <> 0 then	sdepot_in = 'Z01'		// 영업창고
	
	dw_imhist_nitem_out.SetItem(lRowOut, "cvcod",	sdepot_in)
	dw_imhist_nitem_out.SetItem(lRowOut, "ioqty",  	dw_insert.GetItemDecimal(lRow, "imhist_iosuqty"))
	dw_imhist_nitem_out.SetItem(lRowOut, "ioprc",	0)
	dw_imhist_nitem_out.SetItem(lRowOut, "ioreqty",	dw_insert.GetItemDecimal(lRow, "imhist_iosuqty"))
	dw_imhist_nitem_out.SetItem(lRowOut, "insdat",	sDate)
	dw_imhist_nitem_out.SetItem(lRowOut, "iosuqty",	dw_insert.GetItemDecimal(lRow, "imhist_iosuqty"))

	dw_imhist_nitem_out.SetItem(lRowOut, "io_empno",sNull)
	dw_imhist_nitem_out.SetItem(lRowOut, "io_confirm", sSaleYn)
	dw_imhist_nitem_out.SetItem(lRowOut, "io_date",	sDate)
	dw_imhist_nitem_out.SetItem(lRowOut, "filsk", 	'N')
	dw_imhist_nitem_out.SetItem(lRowOut, "bigo",  	'구매입고 상품 자동 출고')
	dw_imhist_nitem_out.SetItem(lRowOut, "botimh",	'Y')
	dw_imhist_nitem_out.SetItem(lRowOut, "ip_jpno",	sinjpno)
	dw_imhist_nitem_out.SetItem(lRowOut, "ioreemp",	sEmpno)
	select deptcode into :sdeptcode from p1_master where empno = :sempno;
	dw_imhist_nitem_out.SetItem(lRowOut, "ioredept",sDeptcode)
	dw_imhist_nitem_out.SetItem(lRowOut, "saupj",	dw_insert.GetitemString(lRow, "imhist_saupj"))	
	

	/////////////////////////////////////////////////////////////////////////////////////
	// 입고전표 생성
	/////////////////////////////////////////////////////////////////////////////////////
	lRowIn = dw_imhist_nitem_in.InsertRow(0)

	dw_imhist_nitem_in.SetItem(lRowIn, "sabu",		gs_sabu)
	dw_imhist_nitem_in.SetItem(lRowIn, "jnpcrt",		sjnpcrt_in)
	dw_imhist_nitem_in.SetItem(lRowIn, "inpcnf",  	'I')
	dw_imhist_nitem_in.SetItem(lRowIn, "iojpno", 	sDate+string(dInSeq, "0000")+string(lRowIn, "000"))
	dw_imhist_nitem_in.SetItem(lRowIn, "iogbn",   	siogbn_in)
	dw_imhist_nitem_in.SetItem(lRowIn, "sudat",		sDate)
	dw_imhist_nitem_in.SetItem(lRowIn, "itnbr",		sitnbr_in)
	dw_imhist_nitem_in.SetItem(lRowIn, "pspec",		'.')
	dw_imhist_nitem_in.SetItem(lRowIn, "opseq",		'9999')
	dw_imhist_nitem_in.SetItem(lRowIn, "depot_no",	sdepot_in)
	dw_imhist_nitem_in.SetItem(lRowIn, "cvcod",		sdepot_in)
	dw_imhist_nitem_in.SetItem(lRowIn, "ioqty",   	dw_insert.GetItemDecimal(lRow, "imhist_iosuqty"))
	dw_imhist_nitem_in.SetItem(lRowIn, "ioprc",		0)
	dw_imhist_nitem_in.SetItem(lRowIn, "ioreqty",	dw_insert.GetItemDecimal(lRow, "imhist_iosuqty"))
	dw_imhist_nitem_in.SetItem(lRowIn, "insdat",		sDate)
	dw_imhist_nitem_in.SetItem(lRowIn, "iosuqty", 	dw_insert.GetItemDecimal(lRow, "imhist_iosuqty"))

	dw_imhist_nitem_in.SetItem(lRowIn, "io_empno",	sNull)
	dw_imhist_nitem_in.SetItem(lRowIn, "io_confirm", sSaleYn)
	dw_imhist_nitem_in.SetItem(lRowIn, "io_date", 	sDate)
	dw_imhist_nitem_in.SetItem(lRowIn, "filsk", 		'N')
	dw_imhist_nitem_in.SetItem(lRowIn, "bigo",  		'구매입고 상품 자동 입고')
	dw_imhist_nitem_in.SetItem(lRowIn, "ip_jpno", 	sJpno + string(lRowOut, "000"))
	dw_imhist_nitem_in.SetItem(lRowIn, "ioreemp", 	sEmpno)
	dw_imhist_nitem_in.SetItem(lRowIn, "ioredept",	sDeptcode)
	dw_imhist_nitem_in.SetItem(lRowIn, "saupj",		dw_insert.GetitemString(lRow, "imhist_saupj"))	
NEXT

dw_imhist_nitem_out.accepttext()
dw_imhist_nitem_in.accepttext()

IF dw_imhist_nitem_out.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
	RETURN -1
END IF

IF dw_imhist_nitem_in.Update() <> 1	THEN
	ROLLBACK;
	f_Rollback()
	RETURN -1	
END IF

RETURN 1
end function

public function integer wf_imhist_delete_nitem (long arg_row);long		lrow
string	sitnbr, sitnbryd, siojpno, soutjpno, sinjpno

if arg_row < 1 then return 1

// 상품인 자료만 처리
sitnbr = dw_insert.GetItemString(arg_row, "imhist_itnbr")
select itnbryd into :sitnbryd from item_rel
 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
if sqlca.sqlcode <> 0 then return 1

siojpno = dw_insert.getitemstring(arg_row,'imhist_iojpno')


///1.상품출고삭제////////////////////////////////////////////////////////
select iojpno into :soutjpno from imhist
 where sabu = :gs_sabu and ip_jpno = :siojpno 
	and iogbn = 'O25' and saupj = :gs_saupj ;
	
if sqlca.sqlcode = 0 then
	delete from imhist
	 where sabu = :gs_sabu and iojpno = :soutjpno and saupj = :gs_saupj ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','출고전표번호: '+soutjpno+' 삭제 실패!!!')
		return -1
	end if
end if


///2.제품입고삭제////////////////////////////////////////////////////////
select iojpno into :sinjpno from imhist
 where sabu = :gs_sabu and ip_jpno = :soutjpno 
	and iogbn = 'I13' and saupj = :gs_saupj ;
	
if sqlca.sqlcode = 0 then
	delete from imhist
	 where sabu = :gs_sabu and iojpno = :sinjpno and saupj = :gs_saupj ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','입고전표번호: '+sinjpno+' 삭제 실패!!!')
		return -1
	end if
end if

return 1
end function

public function integer wf_waiju ();/* 입력 수정인 경우에만 사용함 */
Long   Lrow,  lRowCount
String sIogbn, sWigbn, sError, sIojpno, sGubun, ls_chk

lRowCount = dw_insert.rowcount()

For Lrow = 1 to lRowCount
	
	sGubun = dw_insert.GetItemString(Lrow, "gubun")
	IF sGubun = 'N'	THEN CONTINUE /* 미검사내역은 skip */

	/* 입고형태가 외주인지 check	*/
	siogbn = dw_insert.GetItemString(Lrow, "imhist_iogbn")	
	
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
		sIojpno	= dw_insert.getitemstring(Lrow, "imhist_iojpno")
		
		/* 자동수불 자료인지 확인 - BY SHINGOON 2016.05.19 */
		SELECT IOGBN INTO :ls_chk FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
		/* 수불구분이 상이하면 전표번호 다시 가져오기 - 자동수불 자료일 경우 ls_chk값은 [IM7]로 처리 */
		/* 예시 - 자동수불 자료일 경우 (sIogbn='I01' or sIogbn='I03') 이고 ls_chk='IM7'
		          자동수불 자료가 아닐 경우 (sIogbn='I01' or sIogbn='I03') 이고 (ls_chk='I01' or ls_chk='I03') */
		If sIogbn <> ls_chk Then
			SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* 자동수불 입고(IM7)로 자동수불 출고(OM7) 전표번호 확인 */
			SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* 자동수불 출고(OM7)로 구매/외주입고(I01/I03) 전표번호 확인 */
			If Trim(sIojpno) = '' Or IsNull(sIojpno) Then
				MessageBox('확인', '자동수불 자료에 대한 구매/외주입고 전표번호를 찾을 수 없습니다.')
				ROLLBACK USING SQLCA;
				Return -1
			End If
		End If
		
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

public function integer wf_update ();string	sStockGubun,	&
			sVendorGubun,	&
			sVendor,			&
			sJpno,			&
			sGubun,			&
			sNull, sconfirm, saleyn, sOpseq, sDecisionyn, sDecisionyn_temp
String   siogbn, sIojpno, sError, sWigbn
long		lRow ,ll_cnt, lCnt
dec{3}	dIocdQty, dIocdQty_Temp,		&
			dBadQty, dBadQty_Temp,		&
			dQty, dSpqty, diopeqty, diopeqty_temp
dec{5}	dgongprc, dgongprc_Temp
			
SetNull(sNull)

FOR lRow = 1	TO		dw_insert.RowCount()

		sIojpno = dw_insert.GetItemString(lRow, "imhist_iojpno")				// 입고번호
		dQty 	   		= dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
		dIocdQty			= dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
		dIocdQty_Temp 	= dw_insert.GetItemDecimal(lRow, "iocdqty_temp")					// 조건부수량
		dBadQty 			= dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
		dBadQty_Temp 	= dw_insert.GetItemDecimal(lRow, "iofaqty_temp")					// 불량수량
		diopeQty  		= dw_insert.GetItemDecimal(lRow, "imhist_iopeqty")				// 폐기수량
		diopeQty_TEMP	= dw_insert.GetItemDecimal(lRow, "iopeqty_temp")	   			// 폐기수량
		diopeQty  		= dw_insert.GetItemDecimal(lRow, "imhist_iopeqty")				// 폐기수량
		diopeQty_TEMP	= dw_insert.GetItemDecimal(lRow, "iopeqty_temp")	   			// 폐기수량

		dgongprc  		= dw_insert.GetItemDecimal(lRow, "imhist_gongprc")
		dgongprc_TEMP	= dw_insert.GetItemDecimal(lRow, "gongprc_temp")	
		
		sDecisionyn  	= dw_insert.GetItemString(lRow, "imhist_decisionyn")	
		sDecisionyn_temp 	= dw_insert.GetItemString(lRow, "decisionyn_temp")
		
		IF (dIocdQty <> dIocdQty_temp) or (dBadQty <> dBadQty_Temp)	or &
			(dIopeQty <> dIopeQty_temp) or (dgongprc <> dBadQty_Temp) or &
  	      (sDecisionyn  <> sDecisionyn_Temp)		THEN	
//			IF (dIocdQty <> dIocdQty_temp) or (dBadQty <> dBadQty_Temp)		THEN	
//				gs_Code = dw_insert.GetItemString(lRow, "imhist_iojpno")
//				gi_Page = dBadQty
//				
//				str_01040.sabu 	= gs_sabu
//				str_01040.iojpno	= dw_insert.getitemstring(lRow, "imhist_iojpno")
//				str_01040.itnbr	= dw_insert.getitemstring(lRow, "imhist_itnbr")
//				str_01040.itdsc	= dw_insert.getitemstring(lRow, "itemas_itdsc")
//				str_01040.ispec	= dw_insert.getitemstring(lRow, "itemas_ispec")
//				str_01040.ioqty	= dw_insert.getitemDecimal(lRow, "imhist_ioreqty")
//				str_01040.buqty	= dw_insert.getitemDecimal(lRow, "imhist_iofaqty")
//				str_01040.joqty	= dw_insert.getitemDecimal(lRow, "imhist_iocdqty")
//				str_01040.siqty	= dw_insert.getitemDecimal(lRow, "imhist_silyoqty")
//				str_01040.rowno	= lrow			
//				str_01040.dwname  = dw_insert
//				str_01040.gubun   = 'Y' //수입검사구분
//				Openwithparm(w_qct_01050, str_01040)			
//         END IF 
      
		IF sDecisionyn  <> sDecisionyn_Temp	THEN
			
			If dw_insert.GetItemString(lRow, "imhist_bigo") = '' Or &
				isNull(dw_insert.GetItemString(lRow, "imhist_bigo")) Then
				
				MessageBox('확인','합불판정 변경사유를 등록하세요.')
				Return -1
			End If
			
			str_00020.sabu 	= gs_sabu
			str_00020.iojpno	= dw_insert.GetItemString(lRow, "imhist_iojpno")
			str_00020.itnbr	= dw_insert.GetItemString(lRow, "imhist_itnbr")
			str_00020.itdsc	= dw_insert.GetItemString(lRow, "itemas_itdsc")
			str_00020.ispec	= dw_insert.GetItemString(lRow, "itemas_ispec")
			str_00020.ioqty	= dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")
			str_00020.buqty	= dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")
			str_00020.siqty	= dw_insert.GetitemDecimal(lRow, "siqty")
			str_00020.rowno	= lRow
			//str_00020.dwname  = dw_list
			str_00020.gubun   = 'Y' //수입검사구분
	
			Openwithparm(w_qa01_00021, str_00020)
		End If
		
		Select Count(*) Into :ll_cnt
		  From imhfat
		 Where sabu = '1'
			And iojpno = :sIojpno ;
			
			
		If ll_cnt > 0 Then
			dw_insert.Object.imhist_iofaqty[lRow] = dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")
			dw_insert.Object.imhist_iopeqty[lRow] = 0
			dw_insert.SetItem(lRow, "imhist_decisionyn", 'N')
				
		Else
			dw_insert.Object.imhist_iofaqty[lRow] = 0
			dw_insert.SetItem(lRow, "imhist_decisionyn", 'Y')
			  
		End if
			
   //================================================================


			
			dw_insert.accepttext()
//			dIocdQty			= dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
//			dBadQty 			= dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
//			
//			if sDecisionyn = 'Y' then 
//				if dBadQty > 0 or dIocdQty > 0 then 
//					MessageBox(' [합격 판정!] ', '불량수량/조건부수량을 확인하세요! ',Information!)
//					dw_insert.ScrollToRow(lRow)
//					dw_insert.setcolumn("imhist_iofaqty")
//					dw_insert.SetRow(lRow)
//					dw_insert.setfocus()
//					return -1
//				end if
//			elseif sDecisionyn = 'N' then 
//				if dBadQty <= 0 then 
//					MessageBox(' [불합격 판정!] ', '불량수량을 확인하세요! ',Information!)
//					dw_insert.ScrollToRow(lRow)
//					dw_insert.setcolumn("imhist_iofaqty")
//					dw_insert.SetRow(lRow)
//					dw_insert.setfocus()
//					return -1
//				end if
//			end if 

			dw_insert.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - dIopeqty)	// 합격 = 입고의뢰 - 불량

			// 출고전표번호 수정	
			sVendor = dw_insert.GetItemString(lRow, "imhist_depot_no")
			sStockGubun  = dw_insert.GetItemString(lRow, "imhist_filsk")			// 재고관리구분
			sJpno  = dw_insert.GetItemString(lRow, "imhist_iojpno")
			saleyn = dw_insert.GetItemString(lRow, "imhist_io_confirm")
			
			// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
			// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
			sOpseq = dw_insert.GetItemString(lRow, "imhist_opseq")
			IF sOpseq <> '9999' Then
				dw_insert.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_insert.getitemdecimal(lrow, "imhist_ioprc"),0))				
				CONTINUE		
			END IF					
			
			if saleyn = 'Y' then // 자동승인전표인 경우
				dw_insert.setitem(lrow, "imhist_ioqty", dQty - dBadqty - dIopeqty)
				dw_insert.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_insert.getitemdecimal(lrow, "imhist_ioprc"), 0))
			end if

			if sstockgubun = 'N' then
			  UPDATE "IMHIST"  
			     SET "IOQTY"   = :dQty - :dBadqty - :dIopeqty,   
         			"IOREQTY" = :dQty - :dBadqty - :dIopeqty,   
			         "IOSUQTY" = :dQty - :dbadqty - :dIopeqty,   
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
			dw_insert.SetItemStatus(lrow, 0, Primary!, NotModified!)
		END IF
		
NEXT

IF dw_insert.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
	return -1
END IF


if wf_waiju() = -1 then 
	ROLLBACK;
	f_Rollback()
	return -1
end if

For Lrow = 1 to dw_insert.rowcount()
	sVendor = dw_insert.GetItemString(lRow, "imhist_depot_no")	
	sIojpno = dw_insert.GetItemString(lRow, "imhist_iojpno")				// 입고번호	
	// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
	// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
	sOpseq = dw_insert.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' Then
		if wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sVendor, 'U') = -1 then
			rollback;
			return -1
		end if
	END IF						
Next

return 1
end function

public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// 기존의 작업실적 전표를 삭제한다.
// 구분 A = 신규입력, U = 삭제후 입력, D = 삭제
// 외주가공입고(공정이 9999가 아니면)인 경우에만 실적전표를 작성한다.
String sitnbr, sup_itnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
String swkctr ,sjocod ,sittyp ,sipgub
Decimal {3} dInqty, dGoqty

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업실적삭제", "작업실적 삭제를 실패하였읍니다", stopsign!)
		return -1	
	end if
end if

dInqty	 = dw_insert.getitemdecimal(lrow, "imhist_iosuqty")							      // 실적수량
dGoqty	 = dw_insert.getitemdecimal(lrow, "imhist_gongqty")	+ &
				dw_insert.getitemdecimal(lrow, "imhist_iopeqty")									// 공제수량 -> 폐기수량

if sGubun = 'U' then
	
	Update Shpact
		Set roqty 	= :dInqty + dGoqty,
			 coqty 	= :dInqty,
			 peqty 	= :dGoqty,			 
			 ipgub   = :sVendor, 
			 upd_user   = :gs_userid 
	 Where sabu 	= :Gs_sabu And Pr_shpjpno = :sIojpno and sigbn = '4';
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업실적수정", "작업실적 수정를 실패하였읍니다", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then

	sShpJpno  = sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// 작업실적번호
	sitnbr	 =	dw_insert.GetItemString(lRow, "imhist_itnbr") 							      // 품번
	sPspec	 =	dw_insert.GetItemString(lRow, "imhist_pspec")					      // 사양
	sPordno	 = dw_insert.getitemstring(lrow, "poblkt_pordno")				      // 작업지시번호	
   
	Setnull(sLastc)
	Setnull(sDe_Lastc)
	Setnull(sshpipno)

	SELECT A.ITNBR ,   A.WKCTR, A.LASTC  , B.JOCOD ,A.OPSEQ    
	  Into :sup_itnbr, :swkctr, :slastc , :sjocod ,:sde_opseq 
	  FROM ROUTNG A, WRKCTR B 
	 WHERE A.WKCTR = B.WKCTR
	   AND A.WAI_ITNBR = :sitnbr ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox('확인','외주공정 데이타가 없습니다.'+&
		          '~n~r~n~r외주실적을 작성할 수 없습니다. 표준공정데이타를 확인하세요.')
		Rollback;
		Return -1
	End If
	
	// 생산팀 가져오기 
	SELECT PDTGU , ITTYP into :spdtgu , :sittyp 
	  FROM ITEMAS 
	 WHERE ITNBR = :sup_itnbr ;
   
	If sittyp = '1' Then // 완제품 일때 
		SELECT MIN(CVCOD) into :sipgub FROM VNDMST WHERE CVGU = '5' AND JUPROD = '1' ;
	Else                 // 반제품 일때 
		SELECT MIN(CVCOD) into :sipgub FROM VNDMST WHERE CVGU = '5' AND JUPROD = '2' AND JUMAEIP = :spdtgu ;
		
	End If
		  
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
		  PR_SHPJPNO, 		IPJPNO,           CRT_USER,
		  STDAT     ,     RSSET ,           RSMAN    ,        RSMCH    ,        SILGBN  )
		VALUES
		( :gs_sabu,		:sShpjpno,			   :sup_itnbr,	  	   :sPspec,				:swkctr,
		  :sPdtgu,			null,					:sjocod,			   :sEmpno,		      :sDate,
		  0,					0,						0,						0,						0,
		  :sPordno,			'4',					'Y',					:dinqty,				0,
		  0,					0,						:dInqty,				'품질',				'N',
		  '2',				substr(:sIojpno, 3, 10),				substr(:sIojpno, 3, 10),
		  :sipgub,			null,
		  null,				:sde_opseq,			:sLastc,				:sDe_Lastc,			'N',
		  :sIojpno,			:sShpipno,        :gs_userid  ,
		  :sDate ,        0 ,               0 ,               0 ,               '2' );
		  
	
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
//		MessageBox("SQL ERROR", SQLCA.SQLERRTXT, stopsign!)
		MessageBox("작업실적작성", "작업실적 작성을 실패하였읍니다", stopsign!)
		return -1
	End if	
	
	dw_insert.SetItem(lRow, "imhist_jakjino", sPordno)		// 작업지시번호
	dw_insert.SetItem(lRow, "imhist_jaksino", sShpjpno)	// 작업실적번호	
	
end if

return 1
end function

public function integer wf_initial ();string snull

setnull(snull)

dw_ip.setredraw(false)

dw_insert.reset()
dw_imhist_out.reset()

p_mod.enabled = false
p_del.enabled = false
dw_ip.enabled = TRUE
////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	then
//	dw_ip.settaborder("insdate", 70)
	//dw_ip.Modify("t_8.Visible= 1") 
	//dw_ip.Modify("insdate_t.Visible= 1") 
//	dw_ip.Modify("insdate.Visible= 1") 
	
//	dw_ip.Modify("insdate_from.Visible= 0") 
//	dw_ip.Modify("insdate_to.Visible= 0") 
//	dw_ip.Modify("t_9.Visible= 0") 
	
//	dw_ip.SetItem(1, "insdate", is_today)
//	dw_ip.Modify("insdate_t.text= '입하일자'") 
	
//	w_mdi_frame.sle_msg.text = "검사의뢰"
	cb_3.Visible = true
ELSE
	//dw_ip.Modify("t_8.Visible= 0") 
	//dw_ip.Modify("insdate_t.Visible= 0") 
//	dw_ip.Modify("insdate.Visible= 0")
//	
//	dw_ip.Modify("insdate_from.Visible= 1") 
//	dw_ip.Modify("insdate_to.Visible= 1") 
//	dw_ip.Modify("t_9.Visible= 1") 
//	
//	dw_ip.settaborder("insdate", 0)
//	dw_ip.Modify("insdate_t.text= '검사일자'") 
//	w_mdi_frame.sle_msg.text = "검사결과"
	cb_3.Visible = false
END IF
dw_ip.SetItem(1, "sdate", left(is_today,6)+'01')
dw_ip.SetItem(1, "edate", is_today)

dw_ip.SetItem(1, "insdate", is_today)

dw_ip.SetItem(1, "jpno",    sNull)
dw_ip.SetItem(1, "cvcod",  sNull)
dw_ip.SetItem(1, "cvnas",   sNull)
//dw_ip.SetItem(1, "empno",   gs_empno)
dw_ip.SetItem(1, "saupj",   gs_saupj)

dw_ip.setcolumn("sdate")
dw_ip.setfocus()

dw_ip.setredraw(true)

return  1
end function

public function integer wf_imhfat_create (string arg_iojpno, string arg_bulcod, decimal arg_bulqty);long	lcnt

select count(*) into :lcnt from imhist
 where sabu = '1' and iojpno = :arg_iojpno ;

if lcnt > 0 then
	insert into imhfat
	( sabu,			iojpno,			bulcod,			
	  balgu,			jogu,	  			bulqty	)
	values
	( '1',			:arg_iojpno,	:arg_bulcod,
	  '1',			'N',				:arg_bulqty  ) ;
	  
	if sqlca.sqlcode <> 0 then return -1
end if

return 1
end function

public function integer wf_imhist_delete (integer ar_row);///////////////////////////////////////////////////////////////////////
//
//	1. 출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////
string	sJpno, snull, sstockgubun, saleyn, sIogbn, sError, sWigbn, siojpno, sOpseq ,siogbn_t
string sItnbr, ls_o25jpno, ls_i13jpno
long		lRow, lCnt
decimal {3} dbuqty, djoqty

setnull(snull)
lrow = ar_row

If dw_insert.isSelected(lrow) = False Then 
	MessageBox('확인','삭제할 행을 선택하세요')
	Return -1
End If

if dw_insert.getitemstring(lrow, "gubun") = 'N' then
	messagebox("확 인", "삭제할 수 없습니다. 자료를 확인하세요.")
	return -1
end if	

if dw_insert.getitemstring(lrow, "imhist_sarea") = 'Y' then
	messagebox("확 인", "입고대사 확인된 자료는 삭제할 수 없습니다.~n먼저 입고대사 확인 취소 하십시오.")
	return -1
end if	

sJpno = dw_insert.GetItemString(lrow, "imhist_iojpno")  //자동수불 처리된 입고자료일 경우 자동수불입고 전표번호 임 - BY SHINGOON 2016.02.27

String ls_om7jpno, ls_insdat, ls_insemp, ls_007jpno, ls_conf, ls_err
Long   ll_err
/* 자동수불입고(IM7)로 자동수불출고(OM7) 전표번호 확인 - BY SHINGOON 2016.02.27 */
SELECT IP_JPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sJpno ;
/* 자동수불출고(OM7)로 매입자료(I01, I03) 전표번호 확인 - BY SHINGOON 2016.02.27 */
SELECT IP_JPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno ;
/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE IOGBN = 'OM7' AND IP_JPNO = :sJpno;*/
If Trim(ls_007jpno) = '' Or IsNull(ls_007jpno) Then ls_007jpno = sJpno
/* 구매/외주 입고 자료의 제품창고 승인여부 확인 - BY SHINGOON 2018.03.28 */
SELECT CASE WHEN NVL(IO_EMPNO, '.') <> '.' THEN 'Y' ELSE 'N' END INTO :ls_conf FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno;
If ls_conf = 'Y' Then
	MessageBox('확인', '이미 제품입고 승인 처리된 내역입니다.~r~n제품입고 승인 취소 후 검사내역을 취소하시기 바랍니다.')
	Return -1
End If

sStockGubun  = dw_insert.GetItemString(lRow, "imhist_filsk")			// 재고관리구분

DELETE FROM IMHIST  
 WHERE SABU    = :gs_sabu AND 
       /*IP_JPNO = :sJpno  AND*/
		 IP_JPNO = :ls_007jpno AND
	  	 JNPCRT  = '008' ;

if sqlca.sqlcode < 0 then
	ROLLBACK;
	Messagebox("확 인", "수불내역 삭제시 오류 발생", information!)
	return -1
end if
	 
/* 불량및 조건부 내역을 check하여 수량이 있으면 불량내역도 삭제 */
dBuqty = dw_insert.GetItemDecimal(lRow, "iocdqty_temp")				// 조건부수량
dJoqty = dw_insert.GetItemDecimal(lRow, "iofaqty_temp")				// 불량수량	
If dBuqty > 0 or dJoqty > 0 then
	
	DELETE FROM "IMHFAT"  
	 WHERE "IMHFAT"."SABU" = :gs_sabu AND "IMHFAT"."IOJPNO" = :ls_007jpno ;  
/*			 "IMHFAT"."IOJPNO" = :sJpno   ;*/
//	if sqlca.sqlnrows < 1 then
	If sqlca.sqlcode <> 0 then
		messagebox(String(sqlca.sqlcode), sqlca.sqlerrtext)
		ROLLBACK;
		Messagebox("확인", "불량내역 삭제시 오류 발생", information!)
		return -1
	end if
	
//	DELETE FROM "IMHFAG"  
//	 WHERE "IMHFAG"."SABU" = :gs_sabu AND  
//			 "IMHFAG"."IOJPNO" = :sJpno   ;
//
//	if sqlca.sqlcode < 0 then
//		ROLLBACK;
//		Messagebox("확 인", "조치내역 삭제시 오류 발생", information!)
//		return -1
//	end if
	
END IF

dw_insert.setitem(lrow, "imhist_insdat", snull)
dw_insert.setitem(lrow, "imhist_tukemp", snull)
// 관리단위 기준
dw_insert.SetItem(lRow, "imhist_iocdqty", 0)				// 조건부수량
dw_insert.SetItem(lRow, "imhist_iofaqty", 0)				// 불량수량
dw_insert.SetItem(lRow, "imhist_iosuqty", 0)				// 합격수량
dw_insert.SetItem(lRow, "imhist_iopeqty", 0)				// 폐기수량
dw_insert.SetItem(lRow, "imhist_silyoqty", 0)				// 시료수량
dw_insert.SetItem(lRow, "imhist_gongqty", 0)				// 공제수량
dw_insert.SetItem(lRow, "imhist_gongprc", 0)				// 공제단가
dw_insert.SetItem(lRow, "imhist_decisionyn", snull)     // 합불판정
dw_insert.SetItem(lRow, "imhist_jaksino",    snull)     // 작업실적번호 

// 발주단위 기준
dw_insert.SetItem(lRow, "imhist_cnviocd", 0)				// 조건부수량
dw_insert.SetItem(lRow, "imhist_cnviofa", 0)				// 불량수량
dw_insert.SetItem(lRow, "imhist_cnviosu", 0)				// 합격수량
dw_insert.SetItem(lRow, "imhist_cnviope", 0)				// 폐기수량
dw_insert.SetItem(lRow, "imhist_cnvgong", 0)				// 공제수량

// 승인여부
saleyn = dw_insert.GetItemString(lRow, "imhist_io_confirm")

if saleyn = 'Y' then // 자동승인전표인 경우
	dw_insert.setitem(lrow, "imhist_ioqty", 0)
	dw_insert.setitem(lrow, "imhist_ioamt", 0)			
	dw_insert.SetItem(lRow, "imhist_io_date",  sNull)		// 수불승인일자=입고의뢰일자
	dw_insert.SetItem(lRow, "imhist_io_empno", sNull)		// 수불승인자=NULL			
end if


/*장안이동출고자료 승인처리 */
/*2016.01.21 신동준*/
/* 입고전표번호 변경으로 로직 수정 - BY SHINGOON 2016.02.27 
   입고전표번호가 매입자료(I01, I03)의 전표번호가 아니라 자동수불입고 전표번호(IM7)로 처리됨 - BY SHINGOON 2016.02.27 */
IF IsNull(sJpno) = False Then
	ls_insdat = dw_insert.GetItemString(lRow, "imhist_insdat")				// 검사 일자
	ls_insemp = dw_insert.GetItemString(lRow, "imhist_insemp")				// 검사담당자
	
	/* 매입자료(I01, I03)자료 갱신 - BY SHINGOON 2016.02.27 */
	UPDATE IMHIST
		SET IOQTY = 0, IO_DATE = NULL, IOSUQTY = 0, INSDAT = NULL
	 WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20011]~r~n' + ls_err)
		Return -1
	End If
	
	/* 자동수불출고(OM7)자료 갱신 - BY SHINGOON 2016.02.27 */
	UPDATE IMHIST
		SET IOQTY = 0, IO_DATE = NULL, IOREQTY = 0, IOSUQTY = 0, INSDAT = NULL, INSEMP = NULL
	 WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20012]~r~n' + ls_err)
		Return -1
	End If
	
	/* 입고 품번이 품번대체 수불도 발생하는지 조회 2023.07.19 by dykim */
	
	sItnbr = dw_insert.GetItemString(lRow, "imhist_itnbr")
	
	SELECT COUNT('X')
	   INTO  :lCnt
	  FROM REFFPF 
	WHERE RFCOD = '1K'
	    AND RFNA1 = :sItnbr;
		 
	If lCnt > 0 Then
		/* 선택된 자동수불 입고(IM7) 전표번호로 품목대체 출고(O25) 전표번호 확인 2023.07.19 by dykim */
		SELECT IOJPNO INTO :ls_o25jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'O25' AND IP_JPNO = :sJpno;
		/* 품목대체 출고(O25) 전표번호로 품목대체 입고(I13) 전표번호 확인 2023.07.19 by dykim */
		SELECT IOJPNO INTO :ls_i13jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'I13' AND IP_JPNO = :ls_o25jpno;
				
		If Trim(ls_o25jpno) = '' or isNull(ls_o25jpno) or Trim(ls_i13jpno) = '' or isNull(ls_i13jpno) Then
		else
			UPDATE IMHIST
			      SET IOQTY   = 0,   
					  IO_DATE = NULL,
					  IOREQTY = 0,   
					  IOSUQTY = 0,
					  INSDAT = NULL,							
					  INSEMP = NULL,
					  UPD_USER = :gs_userid,
					  DECISIONYN = NULL,
					  IO_CONFIRM = 'N'
			WHERE SABU = :gs_sabu AND IOJPNO = :ls_o25jpno AND IOGBN = 'O25';
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20013]~r~n' + ls_err)
				Return -1
			End If
					
			UPDATE IMHIST
			      SET IOQTY   = 0,   
					  IO_DATE = NULL,
					  IOREQTY = 0,   
					  IOSUQTY = 0,   
					  IOPRC = 0,
					  IOAMT = 0,
					  INSDAT = NULL,							
					  INSEMP = NULL,
					  UPD_USER = :gs_userid,
					  DECISIONYN = NULL,
					  IO_CONFIRM = 'N'
			WHERE SABU = :gs_sabu AND IOJPNO = :ls_i13jpno AND IOGBN = 'I13';
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20014]~r~n' + ls_err)
				Return -1
			End If
		End if
	End If
End If

// 외주가공인 경우에는 생산실적 전표를 작성한다.
// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
/*sIojpno = dw_insert.GetItemString(lRow, "imhist_iojpno")// 입고번호
sOpseq = dw_insert.GetItemString(lRow, "imhist_opseq")
siogbn_t = dw_insert.GetItemString(lRow, "imhist_iogbn")*/
SELECT OPSEQ, IOGBN INTO :sOpseq, :siogbn_t FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno ;
IF siogbn_t = 'I03' Then

	/*if wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sNull, 'D') = -1 then*/
	if wf_shpact(Lrow, Lrow, snull, 0, ls_007jpno, sOpseq, 0, sNull, sNull, 'D') = -1 then
		return -1
	end if
	
END IF
			
/* 입고형태가 외주인지 check	*/
/*siogbn = dw_insert.GetItemString(Lrow, "imhist_iogbn")
Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;*/
Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn_t;
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	f_message_chk(311,'[외주여부]')
	return -1
end if

String  ls_chk
/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 생성 
	-. 단 검사일자가 있는 경우에 한 함*/
if sWigbn = 'Y' Then
	sError 	= 'X';
	/*sIojpno	= dw_insert.getitemstring(Lrow, "imhist_iojpno")
		
	/* 자동수불 자료인지 확인 - BY SHINGOON 2016.05.19 */
	SELECT IOGBN INTO :ls_chk FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
	/* 수불구분이 상이하면 전표번호 다시 가져오기 - 자동수불 자료일 경우 ls_chk값은 [IM7]로 처리 */
	/* 예시 - 자동수불 자료일 경우 (sIogbn='I01' or sIogbn='I03') 이고 ls_chk='IM7'
				 자동수불 자료가 아닐 경우 (sIogbn='I01' or sIogbn='I03') 이고 (ls_chk='I01' or ls_chk='I03') */
	If sIogbn <> ls_chk Then
		SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* 자동수불 입고(IM7)로 자동수불 출고(OM7) 전표번호 확인 */
		SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* 자동수불 출고(OM7)로 구매/외주입고(I01/I03) 전표번호 확인 */
		If Trim(sIojpno) = '' Or IsNull(sIojpno) Then
			MessageBox('확인', '자동수불 자료에 대한 구매/외주입고 전표번호를 찾을 수 없습니다.')
			ROLLBACK USING SQLCA;
			Return -1
		End If
	End If*/
	
	//sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
	sqlca.erp000000360(gs_sabu, ls_007jpno, 'D', sError);
	if sError = 'X' or sError = 'Y' then
		f_message_chk(41, '[외주자동출고]~r~n' + sqlca.sqlerrtext)
		Rollback;
		return -1
	end if;		
end if;	


///상품출고-제품입고 전표삭제////////////////////////////////////////////////
wf_imhist_delete_nitem(lrow)


RETURN 1
end function

public function integer wf_checkrequiredfield ();////////////////////////////////////////////////////////////////////////////
string	sQcDate, sIndate, 	&
			sGubun,		&
			sStockGubun,	sPordno, get_pdsts,	&
			sConfirm,	&
			sVendor,		&
			sEmpno,		&
			sNull,		swaiju_gb ,sIogbn, sQcgub, sItnbr, sOpseq, sCvcod, sQcgub1, sEpno, sEpno1, sIojpno ,sDecision
long		lRow, lRowOut, lRowCount ,ll_cnt, lcnt, ll_err, ll_ioamt, lCnt2
dec {2}	dOutSeq, dShpseq, dShpipgo
dec {3}  dBadQty, dIocdQty,dQty,	dCnvqty	,  diopeqty,dCnvBad, dCnviocd, dcnviope
string	sitnbr_t, scvcod_t, sbulcod, sinsemp
String   ls_om7jpno, ls_insdat, ls_insemp, ls_007jpno, ls_err, ls_o25jpno, ls_i13jpno
decimal	dprc

SetNull(sNull)

sEmpno  = dw_ip.GetItemString(1, "empno")

lRowCount = dw_insert.RowCount()
/*입고구분(iogbn) 이 외주입고이면 작업실적 전표번호를 생성 */
FOR	lRow = 1		TO		lRowCount
	
	sGubun = dw_insert.GetItemString(lRow, "gubun")
	IF sGubun = 'N'	THEN 
		dw_insert.SetItemStatus(lrow, 0, Primary!, NotModified!)
		CONTINUE /* 미검사내역은 skip */	
	END IF
	
	sQcdate = dw_insert.GetItemString(lRow, "imhist_insdat")
	
   If sQcdate = '' Or isNull(sQcdate) Or f_datechk(sQcdate) < 1 Then
		f_message_chk(35 , '[검사일자]')
		dw_insert.SetFocus()
		dw_insert.ScrollTorow(lRow)
		dw_insert.SetColumn('imhist_insdat')
		Return -1
	End if
	
	if dw_insert.getitemstring(lrow, "imhist_iogbn") = 'I03' then  // 외주입고인  경우 
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

/* 자동수불로 인해 구매/외주입고 자료가 아닌 자동수불입고 자료를 가지고 검사 처리 - BY SHINGOON 2016.02.27 */
FOR lRow = 1	TO		lRowCount
	sIojpno      = dw_insert.GetItemString(lRow, "imhist_iojpno")				// 입고번호 - 자동수불 입고자료의 전표 번호임 - BY SHINGOON 2016.02.27
	dQty 	       = dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
	dIocdQty     = dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
	dBadQty      = dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
	sStockGubun  = dw_insert.GetItemString(lRow, "imhist_filsk")			// 재고관리구분
	sDecision    = dw_insert.GetItemString(lRow,'imhist_decisionyn')
	sGubun       = dw_insert.GetItemString(lRow, "gubun")
	sOpseq 		 = dw_insert.GetItemString(lRow, "imhist_opseq")
	
	sQcdate = dw_insert.GetItemString(lRow, "imhist_insdat")
		
	IF sGubun = 'N'	THEN CONTINUE /* 미검사내역은 skip */
		
	If sQcdate = '' Or isNull(sQcdate) Or f_datechk(sQcdate) < 1 Then
		f_message_chk(35 , '[검사일자]')
		dw_insert.SetFocus()
		dw_insert.ScrollTorow(lRow)
		dw_insert.SetColumn('imhist_insdat')
		Return -1
	End if
	

   //================================================================
	// 불량현상이 두개 이상인 경우 불량수량만 지정하고 불량현상 지정안함 
	sbulcod = dw_insert.GetItemString(lRow,'bulcod')
	if isnull(sbulcod) or sbulcod = '' then
		IF dIocdQty + dBadQty > 0		THEN	
			gs_Code = dw_insert.GetItemString(lRow, "imhist_iojpno") // 입고번호 - 자동수불 입고자료의 전표 번호임 - BY SHINGOON 2016.02.27
			gi_Page = dBadQty
			
			str_00020.sabu 	= gs_sabu
			str_00020.iojpno	= gs_Code//dw_insert.getitemstring(lRow, "imhist_iojpno")
			str_00020.itnbr	= dw_insert.getitemstring(lRow, "imhist_itnbr")
			str_00020.itdsc	= dw_insert.getitemstring(lRow, "itemas_itdsc")
			str_00020.ispec	= dw_insert.getitemstring(lRow, "itemas_ispec")
			str_00020.ioqty	= dw_insert.getitemDecimal(lRow, "imhist_ioreqty")
			str_00020.buqty	= dw_insert.getitemDecimal(lRow, "imhist_iofaqty")
			str_00020.joqty	= dw_insert.getitemDecimal(lRow, "imhist_iocdqty")
			str_00020.siqty	= dw_insert.getitemDecimal(lRow, "siqty")
			str_00020.rowno	= lrow
			str_00020.dwname  = dw_insert
			str_00020.gubun   = 'Y' //수입검사구분
			Openwithparm(w_qa01_00021, str_00020)
		END IF
	end if
		
   //================================================================
		
	dw_insert.accepttext()
	dIocdQty= dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// 조건부수량
	dBadQty = dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// 불량수량
	diopeQty = dw_insert.GetItemDecimal(lRow, "imhist_iopeqty")			// 폐기수량
	sindate = dw_insert.GetItemString(lRow, "imhist_sudat")
		
	// 발주단위 기준수량
	dCnvQty 	= dw_insert.GetItemDecimal(lRow, "imhist_cnviore")				// 입고수량
	dCnvIocd = dw_insert.GetItemDecimal(lRow, "imhist_cnviocd")				// 조건부수량
	dCnvBad  = dw_insert.GetItemDecimal(lRow, "imhist_cnviofa")				// 불량수량
	dCnviope = dw_insert.GetItemDecimal(lRow, "imhist_cnviope")				// 폐기수량		
	   
//	dw_insert.SetItem(lRow, "imhist_qcgub",  '2')			// 검사구분은 무조건 2로 Setting
		
	dw_insert.SetItem(lRow, "imhist_insdat",  sQcDate)			// 검사일자
	dw_insert.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - diopeqty)	 // 합격 = 입고의뢰 - 불량(관리단위) - 폐기
	dw_insert.SetItem(lRow, "imhist_cnviosu", dCnvQty - dCnvBad - dcnviope) // 합격 = 입고의뢰 - 불량(발주단위) - 폐기

	dw_insert.SetItem(lRow, "imhist_silyoqty", &
		                      dw_insert.GetItemDecimal(lRow, "siqty")) // 시료수량

	string	sVendorGubun, sSaleYN
	sVendor = dw_insert.GetItemString(lRow, "imhist_depot_no")
	sSaleyn = dw_insert.GetItemString(lRow, "imhist_io_confirm")
	If IsNull(sSaleyn) OR Trim(sSaleyn) = '' Then sSaleyn = 'N'

	/////////////////////////////////////////////////////////////////////////////////
	// 입고금액 계산 - 2003.12.17 - 송병호	
	sitnbr_t = dw_insert.GetItemString(lRow, "imhist_itnbr")
	scvcod_t = dw_insert.GetItemString(lRow, "imhist_cvcod")
	dprc = dw_insert.GetItemDecimal(lRow, "ioprc")
//	dprc = sqlca.fun_erp100000012_1(sQcDate,scvcod_t,sitnbr_t,'1')

//	select fun_erp100000012_1(:sQcDate,:scvcod_t,:sitnbr_t,'1') 
//	  into :dprc
//	  from dual ;	
	/////////////////////////////////////////////////////////////////////////////////
	

	IF sSaleYn = 'Y' or  sstockgubun = 'N' then  				// 수불자동승인인 경우 또는 재고관리 대상인 아닌것
		dw_insert.SetItem(lRow, "imhist_io_date",  sQcDate)		// 수불승인일자=입고의뢰일자
		dw_insert.SetItem(lRow, "imhist_io_empno", sNull)			// 수불승인자=NULL
		dw_insert.setitem(lrow, "imhist_ioqty",  dQty - dBadqty - diopeqty)
		dw_insert.setitem(lrow, "ioprc", dprc)
		dw_insert.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dprc, 0))
		//금액은 폐기수량을 빼지 않음
	END IF		 	
	
	/*장안이동출고자료 승인처리 */
	/*2016.01.21 신동준*/
	/* 자동수불 자료일 경우 IM7(자동수불 입고)로 검사자료 처리 - by shingoon 2016.02.27 */
	IF IsNull(sIojpno) = False Then
		ls_insdat = dw_insert.GetItemString(lRow, "imhist_insdat")				// 검사 일자
		ls_insemp = dw_insert.GetItemString(lRow, "imhist_insemp")				// 검사담당자
		
		ll_ioamt = TRUNCATE((dQty - dBadqty) * dprc, 0)
		
		/* 선택된 자동수불 입고(IM7) 전표번호로 자동수불 출고(OM7) 전표번호 확인 - by shingoon 2016.02.27 */
		SELECT IP_JPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
		/* 자동수불 출고(OM7) 전표번호로 매입자료(I01, I03) 전표번호 확인 - BY SHINGOON 2016.02.27 */
		SELECT IP_JPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno ;
		/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :sIojpno ;*/
		
		
		If Trim(ls_om7jpno) = '' Or IsNull(ls_om7jpno) Or Trim(ls_007jpno) = '' OR IsNull(ls_007jpno) Then
		Else
			/* IM7자료 갱신 */
			UPDATE IMHIST
				SET IOQTY   = DECODE(:sSaleYn, 'Y', :dQty - :dBadqty - :dIopeqty, 0),   
					 IO_DATE = DECODE(:sSaleYn, 'Y', :ls_insdat, NULL),
					 IOREQTY = :dQty - :dBadqty - :dIopeqty,   
					 IOSUQTY = :dQty - :dbadqty - :dIopeqty,   
					 INSDAT = :ls_insdat,							
					 INSEMP = :ls_insemp,
					 UPD_USER = :gs_userid
			 WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20011]~r~n' + ls_err)
				Return -1
			End If
			
			/* IM7자료 갱신 대신 매입자료(I01, I03)을 UPDATE처리 - by shingoon 2016.02.27 */
			UPDATE IMHIST
				SET IOQTY   = DECODE(:sSaleYn, 'Y', :dQty - :dBadqty - :dIopeqty, 0),   
					 IO_DATE = DECODE(:sSaleYn, 'Y', :ls_insdat, NULL),
					 IOREQTY = :dQty - :dBadqty - :dIopeqty,   
					 IOSUQTY = :dQty - :dbadqty - :dIopeqty,   
					 IOAMT = :ll_ioamt,
					 INSDAT = :ls_insdat,							
					 INSEMP = :ls_insemp,
					 UPD_USER = :gs_userid
			 WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20012]~r~n' + ls_err)
				Return -1
			End If
			
			/* IM7(자동수불 입고) 자료로 상대 출고자료(OM7)을 확인 - BY SHINGOON 2016.02.27 */
			UPDATE IMHIST
				SET IOQTY   = DECODE(:sSaleYn, 'Y', :dQty - :dBadqty - :dIopeqty, 0),   
					 IO_DATE = DECODE(:sSaleYn, 'Y', :ls_insdat, NULL),
					 IOREQTY = :dQty - :dBadqty - :dIopeqty,   
					 IOSUQTY = :dQty - :dbadqty - :dIopeqty,   
					 INSDAT = :ls_insdat,							
					 INSEMP = :ls_insemp,
					 UPD_USER = :gs_userid
			 WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20013]~r~n' + ls_err)
				Return -1
			End If
			
			/* 품번대체 자료는 구매입고 등록(SCM) 메뉴에서 생성됨  */
			/* 입고 품번이 품번대체 수불도 발생하는지 조회 2023.07.19 by dykim */
			SELECT COUNT('X')
			   INTO  :lCnt2
			  FROM REFFPF 
			WHERE RFCOD = '1K'
			    AND RFNA1 = :sitnbr_t;
		 
			If lCnt2 > 0 Then
				/* 선택된 자동수불 입고(IM7) 전표번호로 품목대체 출고(O25) 전표번호 확인 2023.07.19 by dykim */
				SELECT IOJPNO INTO :ls_o25jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'O25' AND IP_JPNO = :sIojpno;
				/* 품목대체 출고(O25) 전표번호로 품목대체 입고(I13) 전표번호 확인 2023.07.19 by dykim */
				SELECT IOJPNO INTO :ls_i13jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'I13' AND IP_JPNO = :ls_o25jpno;
				
				If Trim(ls_o25jpno) = '' or isNull(ls_o25jpno) or Trim(ls_i13jpno) = '' or isNull(ls_i13jpno) Then
				else
					UPDATE IMHIST
					      SET IOQTY   = :dQty - :dBadqty - :dIopeqty,   
							  IO_DATE = :ls_insdat,
							  IOREQTY = :dQty - :dBadqty - :dIopeqty,   
							  IOSUQTY = :dQty - :dbadqty - :dIopeqty,
							  INSDAT = :ls_insdat,							
							  INSEMP = :ls_insemp,
							  UPD_USER = :gs_userid,
							  DECISIONYN = 'Y',
							  IO_CONFIRM = 'Y'
					WHERE SABU = :gs_sabu AND IOJPNO = :ls_o25jpno AND IOGBN = 'O25';
					If SQLCA.SQLCODE <> 0 Then
						ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
						ROLLBACK USING SQLCA;
						MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20014]~r~n' + ls_err)
						Return -1
					End If
					
					UPDATE IMHIST
					      SET IOQTY   = :dQty - :dBadqty - :dIopeqty,   
							  IO_DATE = :ls_insdat,
							  IOREQTY = :dQty - :dBadqty - :dIopeqty,   
							  IOSUQTY = :dQty - :dbadqty - :dIopeqty,   
							  IOPRC = :dprc,
							  IOAMT = :ll_ioamt,
							  INSDAT = :ls_insdat,							
							  INSEMP = :ls_insemp,
							  UPD_USER = :gs_userid,
							  DECISIONYN = 'Y',
							  IO_CONFIRM = 'Y'
					WHERE SABU = :gs_sabu AND IOJPNO = :ls_i13jpno AND IOGBN = 'I13';
					If SQLCA.SQLCODE <> 0 Then
						ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
						ROLLBACK USING SQLCA;
						MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[-20015]~r~n' + ls_err)
						Return -1
					End If
				End if
			End If
		End If
	End If
	

	
	// 외주가공인 경우에는 생산실적 전표를 작성한다.
	
	swaiju_gb = dw_insert.GetItemString(lRow, "imhist_iogbn")
	IF swaiju_gb = 'I03' and sOpseq <> '9999' Then
		dw_insert.setitem(lrow, "ioprc", dprc)
		dw_insert.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dprc, 0))
		
		if wf_shpact(Lrow, Lrow, sQcDate, dShpseq, sIojpno, sOpseq, dShpipgo, Sempno, sVendor, 'I') = -1 then
			rollback;
			return -1
		end if
			  
		CONTINUE
      
	END IF		


	/////////////////////////////////////////////////////////////////////////////////////
	// 출고전표 생성 : 전표생성구분('008')
	/////////////////////////////////////////////////////////////////////////////////////
	IF sStockGubun = 'N' then   // 재고관리 안하면 출고전표 생성 
		dOutSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'C0')
		IF dOutSeq < 0		THEN	
			
			rollback;
			f_Rollback()
			RETURN -1
		end if

		lRowOut = dw_imhist_out.InsertRow(0)
		
		If swaiju_gb = 'I09' Then  /// mro 입고 시 재고관리 안하면 자동 출고 
		
			dw_imhist_out.SetItem(lRowOut, "sabu",		gs_Sabu)
			dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// 전표생성구분
			dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// 입출고구분
			dw_imhist_out.SetItem(lRowOut, "iojpno", 	sQcDate + string(dOutSeq, "0000") + '000')
			dw_imhist_out.SetItem(lRowOut, "iogbn",   'O81') 			// 수불구분
			dw_imhist_out.SetItem(lRowOut, "sudat",	sQcDate)			// 수불일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_insert.GetItemString(lRow, "imhist_itnbr")) // 품번
			dw_imhist_out.SetItem(lRowOut, "pspec",	dw_insert.GetItemString(lRow, "imhist_pspec")) // 사양
			dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// 공정순서
			dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// 기준창고=입고처
			dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// 거래처창고=입고처
			dw_imhist_out.SetItem(lRowOut, "ioqty",   dQty - dBadqty - diopeqty)			// 수불수량=입고수량
			dw_imhist_out.SetItem(lRowOut, "ioreqty",	dQty - dBadqty - diopeqty) 			// 수불의뢰수량=입고수량		
			dw_imhist_out.SetItem(lRowOut, "insdat",	sQcDate) 					// 검사일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "iosuqty", dQty - dBadqty - diopeqty)			// 합격수량=입고수량
	
			dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// 수불승인자
			dw_imhist_out.SetItem(lRowOut, "io_confirm", 'Y')			// 수불승인여부
			dw_imhist_out.SetItem(lRowOut, "io_date", sQcDate)			// 수불승인일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// 재고관리구분
			dw_imhist_out.SetItem(lRowOut, "bigo", 'MRO구매입고 동시출고분')
			dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// 동시출고여부
			dw_imhist_out.SetItem(lRowOut, "ip_jpno", dw_insert.GetItemString(lRow, "imhist_iojpno")) 					// 입고번호 - 자동수불 입고자료의 전표 번호임 - BY SHINGOON 2016.02.27
			dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// 수불의뢰담당자=입고의뢰담당자

	Else
			dw_imhist_out.SetItem(lRowOut, "sabu",		gs_Sabu)
			dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// 전표생성구분
			dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// 입출고구분
			dw_imhist_out.SetItem(lRowOut, "iojpno", 	sQcDate + string(dOutSeq, "0000") + '000')
			dw_imhist_out.SetItem(lRowOut, "iogbn",   sIogbn) 			// 수불구분
			dw_imhist_out.SetItem(lRowOut, "sudat",	sQcDate)			// 수불일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_insert.GetItemString(lRow, "imhist_itnbr")) // 품번
			dw_imhist_out.SetItem(lRowOut, "pspec",	dw_insert.GetItemString(lRow, "imhist_pspec")) // 사양
			dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// 공정순서
			dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// 기준창고=입고처
			dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// 거래처창고=입고처
			dw_imhist_out.SetItem(lRowOut, "ioqty",   dQty - dBadqty - diopeqty)			// 수불수량=입고수량
			dw_imhist_out.SetItem(lRowOut, "ioreqty",	dQty - dBadqty - diopeqty) 			// 수불의뢰수량=입고수량		
			dw_imhist_out.SetItem(lRowOut, "insdat",	sQcDate) 					// 검사일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "iosuqty", dQty - dBadqty - diopeqty)			// 합격수량=입고수량
	
			dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// 수불승인자
			dw_imhist_out.SetItem(lRowOut, "io_confirm", 'Y')			// 수불승인여부
			dw_imhist_out.SetItem(lRowOut, "io_date", sQcDate)			// 수불승인일자=입고일자
			dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// 재고관리구분
			dw_imhist_out.SetItem(lRowOut, "bigo",  '구매입고 동시출고분')
			dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// 동시출고여부
			dw_imhist_out.SetItem(lRowOut, "ip_jpno", dw_insert.GetItemString(lRow, "imhist_iojpno")) 					// 입고번호 - 자동수불 입고자료의 전표 번호임 - BY SHINGOON 2016.02.27
			dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// 수불의뢰담당자=입고의뢰담당자


		End If

	END IF

NEXT

IF dw_insert.Update() <> 1		THEN
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
	f_Rollback()
	return -1
end if


// IMHFAT 등록 ============================================================
FOR lRow = 1	TO		lRowCount
	sIojpno      = dw_insert.GetItemString(lRow, "imhist_iojpno")				// 입고번호 - 자동수불 입고자료의 전표 번호임 - BY SHINGOON 2016.02.27
	/* 입고수량으로 처리 시 부적합 현황에 입고수량이 나타나게됨. - by shingoon 2008.08.08 */
	//dQty 	       = dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")				// 입고수량
	dQty         = dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")          //불량수량
	sDecision    = dw_insert.GetItemString(lRow,'imhist_decisionyn')
	sGubun       = dw_insert.GetItemString(lRow, "gubun")
		
	IF sGubun = 'N'	THEN CONTINUE /* 미검사내역은 skip */
	If dQty < 1 Then Continue /* 불량수량이 0인 내역은 Skip - by shingoon 2008.08.08 */
	if sDecision = 'N' then 
		sbulcod = dw_insert.GetItemString(lRow,'bulcod')
		if isnull(sbulcod) or sbulcod = '' then
			select count(*) into :ll_cnt from imhfat
			 where sabu = :gs_sabu and iojpno = :sIojpno ;
			if ll_cnt = 0 then
				messagebox('확인','불량현상을 지정하세요!!!')
				dw_insert.ScrollTorow(lRow)
				dw_insert.SetColumn('bulcod')
				Return -1
			else
				CONTINUE
			end if
		End if
			
		wf_imhfat_create(sIojpno,sbulcod,dQty)

//		str_00020.sabu 	= gs_sabu
//		str_00020.iojpno	= dw_insert.GetItemString(lRow, "imhist_iojpno")
//		str_00020.itnbr	= dw_insert.GetItemString(lRow, "imhist_itnbr")
//		str_00020.itdsc	= dw_insert.GetItemString(lRow, "itemas_itdsc")
//		str_00020.ispec	= dw_insert.GetItemString(lRow, "itemas_ispec")
//		str_00020.ioqty	= dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")
//		str_00020.buqty	= dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")
//		str_00020.siqty	= dw_insert.GetitemDecimal(lRow, "siqty")
//		str_00020.rowno	= lRow
//		str_00020.gubun   = 'Y' //수입검사구분
//
//		Openwithparm(w_qa01_00021, str_00020)

	end if

NEXT

RETURN 1
end function

public function integer wf_check ();////////////////////////////////////////////////////////////////////////////
string	sGubun,	sPordno, get_pdsts,	sDecision, sdate1, sdate2, sempno, sinsemp
long		lRow, lRowCount, k, lcnt
Dec      dBadQty

lRowCount = dw_insert.RowCount()

FOR	lRow = 1		TO		lRowCount
	
		sGubun = dw_insert.GetItemString(lRow, "gubun")		

		IF sGubun = 'N'	THEN 
			CONTINUE /* 미검사내역은 skip */	
		END IF

      k++

		sdecision = dw_insert.getitemstring(lrow, "imhist_decisionyn")
		
		if isnull(sdecision) or sdecision = '' then
			messagebox('확 인', '합불판정을 선택하세요!') 
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_decisionyn")
			dw_insert.setfocus()
			return -1
	
		end if	

		sdate1 = trim(dw_insert.getitemstring(lrow,'imhist_sudat'))
		sdate2 = trim(dw_insert.getitemstring(lrow,'imhist_insdat'))
		if f_datechk(sdate2) = -1 then
			messagebox('확 인', '검사일자를 확인하세요!') 
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_insdat")
			dw_insert.setfocus()
			return -1	
		end if
		
		if sdate1 > sdate2 then
			messagebox('확 인', '검사일자가 입하일자 이전일 수 없습니다!') 
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_insdat")
			dw_insert.setfocus()
			return -1	
		end if
		
		sempno = trim(dw_insert.getitemstring(lrow,'imhist_insemp'))
		if sempno = '' or isnull(sempno) then
			messagebox('확 인', '수입검사 담당자를 입력 하십시오!')
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_insemp")
			dw_insert.setfocus()
			return -1
		end if
//		
//		SELECT COUNT('X'), MAX(RFNA3)
//		  INTO :lcnt     , :sinsemp
//		  FROM REFFPF
//		 WHERE SABU  = '1' AND RFCOD = '45' AND RFGUB <> '00'	AND RFNA2 =  '2'
//		   AND RFGUB = :sempno ;
//		if lcnt < 1 then
//			messagebox('확 인', '수입검사 담당자가 아닙니다!')
//			dw_insert.ScrollToRow(lRow)
//			dw_insert.setcolumn("imhist_insemp")
//			dw_insert.setfocus()
//			return -1
//		end if
		
		//발주에 작업지시 no가 있으면 작업지시를 읽어서 상태가 '1', '2' 인 자료만 들어올 수 있음
		sPordno = dw_insert.getitemstring(lrow, 'poblkt_pordno')
		if not (sPordno = '' or isnull(sPordno)) then 
			SELECT "MOMAST"."PDSTS"  
			  INTO :get_pdsts  
			  FROM "MOMAST"  
			 WHERE ( "MOMAST"."SABU"   = :gs_sabu ) AND  
					 ( "MOMAST"."PORDNO" = :sPordno )   ;
					 
			if not (get_pdsts = '1' or get_pdsts = '2') then 
				messagebox("확 인", "수입검사 처리를 할 수 없습니다. " + "~n~n" + &
										  "작업지시에 지시상태가 지시/재생산지시만 수입검사가 가능합니다.")
				dw_insert.ScrollToRow(lRow)
				dw_insert.setfocus()
				return -1
			end if	
	
		end if
Next

if k < 1 then 
	messagebox('확 인', '처리할 자료를 선택하세요!') 
	dw_insert.setfocus()
	return -1
end if

RETURN 1
end function

on w_qa01_00020.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.dw_imhist_out=create dw_imhist_out
this.p_list=create p_list
this.dw_imhist_nitem_out=create dw_imhist_nitem_out
this.dw_imhist_nitem_in=create dw_imhist_nitem_in
this.p_sort=create p_sort
this.cb_2=create cb_2
this.cb_3=create cb_3
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.rb_insert
this.Control[iCurrent+4]=this.rb_delete
this.Control[iCurrent+5]=this.dw_imhist_out
this.Control[iCurrent+6]=this.p_list
this.Control[iCurrent+7]=this.dw_imhist_nitem_out
this.Control[iCurrent+8]=this.dw_imhist_nitem_in
this.Control[iCurrent+9]=this.p_sort
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.rr_1
end on

on w_qa01_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.dw_imhist_out)
destroy(this.p_list)
destroy(this.dw_imhist_nitem_out)
destroy(this.dw_imhist_nitem_in)
destroy(this.p_sort)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;// datawindow initial value
dw_ip.settransobject(sqlca)
dw_insert.settransobject(sqlca)
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

dw_imhist_nitem_out.settransobject(sqlca)
dw_imhist_nitem_in.settransobject(sqlca)

dw_ip.InsertRow(0)

// commandbutton function
p_can.TriggerEvent("clicked")

end event

type dw_insert from w_inherite`dw_insert within w_qa01_00020
integer x = 41
integer y = 256
integer width = 4544
integer height = 2012
integer taborder = 20
string dataobject = "d_qa01_00020_a_t_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;call super::itemchanged;String sData, sIttyp, sOpseq, sItnbr, sCvcod, sDecision ,sIojpno, snull
long	lRow ,ll_cnt, lcnt
dec {3}	dBadQty, dReQty, dQty, dCdqty, dSiqty, diopeqty, dGongqty
dec {3}  dgongprc

lRow = this.GetRow()

setnull(snull)
If this.GetColumnName() = 'imhist_decisionyn' then  //추가 조연구
	sDecision = GetText()
//	if ic_status = '1' then
		If sDecision = 'Y' or sDecision = 'N' Then
						
			SELECT COUNT('X')
			  INTO :lcnt
			  FROM REFFPF
			 WHERE SABU = '1' AND RFCOD = '45' AND RFGUB <> '00' AND RFNA2 = '2' AND RFGUB = :gs_empno ;
			if lcnt < 1 then
				messagebox('확 인', '수입검사 담당자가 아닙니다!')
				return 1
			end if
			
			SetItem(lRow,"gubun",'Y')
			if IsNull(Trim(GetItemString(lRow,"imhist_insdat"))) or &
				Trim(GetItemString(lRow,"imhist_insdat")) = '' then SetItem(lRow,"imhist_insdat",f_today())
			
			SetItem(lRow,"imhist_tukemp",gs_empno)
			
			if sDecision = 'Y' then 
				SetItem(lRow,"bulcod",snull)
				SetItem(lRow,"imhist_iosuqty",GetItemNumber(lRow,'imhist_ioreqty'))
				SetItem(lRow,"imhist_iofaqty",0)
			else
				SetItem(lRow,"imhist_iosuqty",0)
				SetItem(lRow,"imhist_iofaqty",GetItemNumber(lRow,'imhist_ioreqty'))				
			end if
		Else
			SetItem(lRow,"gubun",'N')
			SetItem(lRow,"imhist_insdat",snull)
			SetItem(lRow,"imhist_tukemp",snull)
			SetItem(lRow,"bulcod",snull)
			SetItem(lRow,"imhist_iosuqty",0)
			SetItem(lRow,"imhist_iofaqty",0)
		End If
//	end if
end if

If this.GetColumnName() = 'imhist_iofaqty' then
	dBadQty = Dec(GetText())
	dReQty = GetItemNumber(lRow,'imhist_ioreqty')
	
	if dReQty - dBadQty < 0 then
		MessageBox('확인','불량수량 지정오류!!!')
		return 1
	end if
	
	SetItem(lRow,"imhist_iosuqty",dReQty - dBadQty)
end if
end event

event dw_insert::clicked;call super::clicked;//If ic_status = '2' Then
	If Row <= 0 then
		SelectRow(0,False)
	ELSE
		SelectRow(0, FALSE)
		SelectRow(Row,TRUE)
	END IF
//End if
end event

event dw_insert::buttonclicked;call super::buttonclicked;String ls_path, ls_filename

if row <= 0 then return

Choose Case dwo.name
	Case 'b_view'
		ls_filename = this.getitemstring(row,'poblkt_hist_filename')
		if isnull(ls_filename) or ls_filename = '' then return
		
		
		// 환경설정 - 공통관리 - SCM 연동관리
		select dataname into :ls_path from syscnfg
		 where sysgu = 'C' and serial = 12 and lineno = '2' ;
		
		ls_path = ls_path+ls_filename
		ShellExecuteA(0, "open", ls_path , "", "", 1) // 파일 자동 실행 
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_qa01_00020
boolean visible = false
integer x = 4997
integer y = 192
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa01_00020
boolean visible = false
integer x = 4960
integer y = 188
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa01_00020
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa01_00020
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa01_00020
integer x = 4421
end type

event p_exit::clicked;CLOSE(PARENT)
end event

type p_can from w_inherite`p_can within w_qa01_00020
integer x = 4247
integer taborder = 60
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

type p_print from w_inherite`p_print within w_qa01_00020
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa01_00020
integer x = 3726
end type

event p_inq::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF dw_ip.AcceptText() = -1	THEN	RETURN
/////////////////////////////////////////////////////////////////////////
string	sDate, eDate, scvcod, ecvcod, sQcDate, sJpno, sEmpno, sroslt, ls_saupj, sitnbr

sDate = TRIM(dw_ip.GetItemString(1, "sdate"))
eDate = TRIM(dw_ip.GetItemString(1, "edate"))

sQcDate = TRIM(dw_ip.GetItemString(1, "insdate"))
//sJpno   = Trim(dw_ip.GetItemString(1, "jpno"))
sEmpno  = dw_ip.GetItemString(1, "empno")
scvcod  = dw_ip.GetItemString(1, "cvcod")
ls_saupj  = TRIM(dw_ip.GetItemString(1, "saupj"))
sitnbr  = TRIM(dw_ip.GetItemString(1, "itnbr"))
//ecvcod  = dw_ip.GetItemString(1, "tcvcod")
//sroslt  = trim(dw_ip.GetItemString(1, "roslt"))


IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[의뢰일자FROM]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	RETURN
END IF

IF isnull(eDate) or eDate = "" 	THEN
	f_message_chk(30,'[의뢰일자TO]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	RETURN
END IF

IF (isnull(sQcDate) or sQcDate = "") and ic_status = '1'	THEN
	f_message_chk(30,'[검사일자]')
	dw_ip.SetColumn("insdate")
	dw_ip.SetFocus()
	RETURN
END IF

//// 전표번호
//IF isnull(sJpno) or sJpno = "" 	THEN
//	sJpno = '%'
//ELSE
//	sJpno = sJpno + '%'
//END IF

IF isnull(sempno) or sempno = "" 	THEN sempno = '%'
IF isnull(scvcod) or scvcod = "" 	THEN scvcod = '%'
IF isnull(ls_saupj) or ls_saupj = "" 	THEN ls_saupj = '%'

SetPointer(HourGlass!)	

//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	IF	dw_insert.Retrieve(gs_sabu, sdate, edate, scvcod, sempno, ls_saupj, sitnbr) <	1		THEN
		f_message_chk(50, '[검사의뢰내역]')
		dw_ip.setcolumn("sdate")
		dw_ip.setfocus()
		RETURN
	
	END IF
ELSE
	IF	dw_insert.Retrieve(gs_sabu, sdate, edate, scvcod, sempno, ls_saupj, sitnbr) <	1		THEN
		f_message_chk(50, '[검사결과내역]')
		dw_ip.setcolumn("sdate")
		dw_ip.setfocus()
		RETURN
	END IF

	wf_Modify_Gubun()
	p_del.enabled = true
	
END IF
//////////////////////////////////////////////////////////////////////////

dw_insert.SetFocus()
//dw_ip.enabled = false

p_mod.enabled = true
end event

type p_del from w_inherite`p_del within w_qa01_00020
integer x = 4073
integer taborder = 50
end type

event p_del::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

if dw_insert.accepttext() = -1 then return 

if dw_insert.rowcount() < 1 then return 
if dw_insert.getrow() < 1 then 
	messagebox("확 인", "삭제할 자료가 존재하지 않습니다.")
   return 
end if

IF f_msg_delete() = -1 THEN	RETURN
Long i
For i = 1 To dw_insert.RowCount()
	If dw_insert.isSelected(i) Then
		IF wf_Imhist_Delete(i) = -1		THEN	// 상품출고-제품입고 삭제 포함 - 2003.12.08 - 송병호
			ROLLBACK;
			return 
		END IF
	End If
Next

IF dw_insert.Update() <> 1		THEN
	ROLLBACK;
	f_Rollback()
END IF

COMMIT;

p_inq.TriggerEvent("clicked")
end event

type p_mod from w_inherite`p_mod within w_qa01_00020
integer x = 3899
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sNull
SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1		THEN	RETURN
IF dw_insert.AcceptText() = -1	THEN	RETURN

IF ic_status = '1'	THEN
	IF wf_Check() = -1	THEN	return 
	
	IF f_msg_update() = -1 	THEN	RETURN

	IF wf_CheckRequiredField() = -1	THEN	
		
		rollback;
		RETURN
	end if

	///상품출고-제품입고////////////////////////////////////////////////
//	IF wf_imhist_create_nitem() < 0 THEN RETURN 
	
	commit;
	
ELSE
	IF f_msg_update() = -1 	THEN	RETURN
	
	if wf_Update() = -1 then 
		rollback;
		return
	end if
	
	commit;

END IF

/////////////////////////////////////////////////////////////////////////////
//rb_delete.Checked = True
//rb_delete.TriggerEvent(Clicked!)
p_inq.TriggerEvent("clicked")

SetPointer(Arrow!)
end event

type cb_exit from w_inherite`cb_exit within w_qa01_00020
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa01_00020
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa01_00020
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa01_00020
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa01_00020
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa01_00020
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qa01_00020
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa01_00020
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa01_00020
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qa01_00020
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa01_00020
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa01_00020
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa01_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_qa01_00020
end type

type cb_1 from commandbutton within w_qa01_00020
boolean visible = false
integer x = 2267
integer y = 2344
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM사용내역 조회"
end type

type dw_ip from datawindow within w_qa01_00020
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 16
integer width = 2985
integer height = 228
integer taborder = 90
string title = "none"
string dataobject = "d_qa01_00020_1_t_new"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)

END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', data)
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		
End Choose
 
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', gs_codename)
	Case	'itnbr'
		gs_code = this.GetText()
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then 	return
	
		this.SetItem(1, "itnbr", gs_code)
End Choose
end event

type rb_insert from radiobutton within w_qa01_00020
integer x = 3063
integer y = 56
integer width = 229
integer height = 68
boolean bringtotop = true
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
ic_status = '1'

dw_insert.DataObject = 'd_qa01_00020_a_t_new'
dw_insert.SetTransObject(sqlca)

wf_initial()
end event

type rb_delete from radiobutton within w_qa01_00020
integer x = 3063
integer y = 136
integer width = 229
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = " "
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;ic_status = '2'

//dw_insert.DataObject = 'd_qa01_00020_b_t_new'
dw_insert.DataObject = 'd_qa01_00020_b_t'
dw_insert.SetTransObject(sqlca)

wf_initial()
end event

type dw_imhist_out from datawindow within w_qa01_00020
boolean visible = false
integer x = 165
integer y = 1696
integer width = 411
integer height = 432
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_out"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type p_list from uo_picture within w_qa01_00020
boolean visible = false
integer x = 5024
integer y = 212
integer width = 178
integer taborder = 50
boolean bringtotop = true
string picturename = "C:\erpman\image\검사이력보기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String scvcod, sItnbr

if dw_insert.getrow() > 0 then
	gs_code		= dw_insert.getitemstring(dw_insert.getrow(), "imhist_itnbr")
	gs_codename	= dw_insert.getitemstring(dw_insert.getrow(), "imhist_cvcod")
	open(w_qct_01040_1)
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\검사이력보기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\검사이력보기_up.gif"
end event

type dw_imhist_nitem_out from datawindow within w_qa01_00020
boolean visible = false
integer x = 4750
integer y = 624
integer width = 750
integer height = 300
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_nitem_out"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type dw_imhist_nitem_in from datawindow within w_qa01_00020
boolean visible = false
integer x = 4754
integer y = 1032
integer width = 741
integer height = 300
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_nitem_in"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type p_sort from picture within w_qa01_00020
boolean visible = false
integer x = 3735
integer y = 108
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

type cb_2 from commandbutton within w_qa01_00020
integer x = 3355
integer y = 16
integer width = 343
integer height = 132
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
string text = "검사성적서"
end type

event clicked;Long	lrow

lrow = dw_insert.getrow()
if lrow <= 0 then
	messagebox('확인', '입고 내역을 선택하세요')
	return
end if

gs_gubun = 'Y'
gs_code = dw_insert.getitemstring(lrow, 'imhist_iojpno')
//검사구분선택: 수입검사(2), 자주검사(5) , 공정검사(6)
gs_codename  = '2'
gs_codename3 = dw_insert.getitemstring(lrow, 'imhist_itnbr')
open(w_qa06_00060_popup)

end event

type cb_3 from commandbutton within w_qa01_00020
integer x = 3355
integer y = 152
integer width = 343
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄합격"
end type

event clicked;int li_row, i, lcnt
string snull

SetNull(snull)

li_row = dw_insert.RowCount()

IF li_row <= 0 THEN
	IF ic_status = '1'	THEN
		f_message_chk(50, '[검사의뢰내역]')
	ELSE
		f_message_chk(50, '[검사결과내역]')
	END IF
ELSE
	For i = 1 to li_row
		dw_insert.SetItem(i, 'imhist_decisionyn', 'Y')
		SELECT COUNT('X')
		  INTO :lcnt
		  FROM REFFPF
		 WHERE SABU = '1' AND RFCOD = '45' AND RFGUB <> '00' AND RFNA2 = '2' AND RFGUB = :gs_empno ;
		
		if lcnt < 1 then
			messagebox('확 인', '수입검사 담당자가 아닙니다!')
			return 1
		end if
			
		dw_insert.SetItem(i,"gubun",'Y')
		if IsNull(Trim(dw_insert.GetItemString(i,"imhist_insdat"))) or &
			Trim(dw_insert.GetItemString(i,"imhist_insdat")) = '' then dw_insert.SetItem(i,"imhist_insdat",f_today())
			
		dw_insert.SetItem(i,"imhist_tukemp",gs_empno)
			
		dw_insert.SetItem(i,"bulcod",snull)
		dw_insert.SetItem(i,"imhist_iosuqty",dw_insert.GetItemNumber(i,'imhist_ioreqty'))
		dw_insert.SetItem(i,"imhist_iofaqty",0)
	Next
	MessageBox("확인", "일괄처리가 완료되었습니다.")
END IF
end event

type rr_3 from roundrectangle within w_qa01_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 248
integer width = 4585
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_qa01_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3017
integer y = 20
integer width = 311
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

