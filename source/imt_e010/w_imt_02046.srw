$PBExportHeader$w_imt_02046.srw
$PBExportComments$** 임의 발주
forward
global type w_imt_02046 from w_inherite
end type
type dw_1 from datawindow within w_imt_02046
end type
type cbx_1 from checkbox within w_imt_02046
end type
type dw_hidden from datawindow within w_imt_02046
end type
type pb_1 from u_pb_cal within w_imt_02046
end type
type pb_2 from u_pb_cal within w_imt_02046
end type
type rr_1 from roundrectangle within w_imt_02046
end type
type rr_2 from roundrectangle within w_imt_02046
end type
end forward

global type w_imt_02046 from w_inherite
integer height = 2468
string title = "소모품 발주등록"
dw_1 dw_1
cbx_1 cbx_1
dw_hidden dw_hidden
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_02046 w_imt_02046

type variables
boolean  ib_changed
char ic_status
sTring is_gubun, is_cnvart
String is_pspec, is_jijil, is_itnbr

String   is_gwgbn   // 그룹웨어 연동여부
Transaction SQLCA1				// 그룹웨어 접속용
String     isHtmlNo = '00022'	// 그룹웨어 문서번호
end variables

forward prototypes
public function integer wf_required_chk (integer i)
public function integer wf_cnvfat (long lrow, string arg_itnbr)
public subroutine wf_reset ()
public function integer wf_create_gwdoc ()
public function integer wf_ret_head (string arg_baljpno)
end prototypes

public function integer wf_required_chk (integer i);/* 품번 */
IF isnull(dw_insert.getitemstring(i, "itnbr")) or &
	trim(dw_insert.getitemstring(i, "itnbr")) = '' then
	f_message_chk(30, '[품번]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("itnbr")
	dw_insert.setfocus()
	return -1
END IF

/* 사양 		*/
if isnull(dw_insert.getitemstring(i, "pspec")) or &
   trim(dw_insert.getitemstring(i, "pspec")) = '' then
	dw_insert.setitem(i, "pspec", '.')
end if

/* 부가사업장 */
IF isnull(dw_insert.getitemstring(i, "saupj")) or &
	trim(dw_insert.getitemstring(i, "saupj")) = '' then
	f_message_chk(30, '[사업장]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("saupj")
	dw_insert.setfocus()
	return -1
END IF

//IF isnull(dw_insert.getitemstring(i, "rdptno")) or &
//	trim(dw_insert.getitemstring(i, "rdptno")) = '' then
//	f_message_chk(30, '[의뢰부서]')
//	dw_insert.scrolltorow(i)
//	dw_insert.setcolumn("rdptno")
//	dw_insert.setfocus()
//	return -1
//END IF

if ISNULL(dw_insert.getitemdecimal(i, "balqty")) OR &
   dw_insert.getitemdecimal(i, "balqty") < 1 then
	f_message_chk(30, '[발주수량]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("balqty")
	dw_insert.setfocus()
	return -1
end if

/* 0일 때도 등록이 되도록 변경 '23.07.17 BY BHKIM
if ISNULL(dw_insert.getitemdecimal(i, "unprc")) OR &
	dw_insert.getitemdecimal(i, "unprc") <= 0 then
	f_message_chk(30, '[발주단가]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("unprc")
	dw_insert.setfocus()
	return -1
end if
*/
if ISNULL(dw_insert.getitemdecimal(i, "unprc")) OR &
	dw_insert.getitemdecimal(i, "unprc") < 0 then
	f_message_chk(30, '[발주단가]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("unprc")
	dw_insert.setfocus()
	return -1
end if

/* 통화단위 */
IF isnull(dw_insert.getitemstring(i, "poblkt_tuncu")) or &
	trim(dw_insert.getitemstring(i, "poblkt_tuncu")) = '' then
	f_message_chk(30, '[통화단위]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("poblkt_tuncu")
	dw_insert.setfocus()
	return -1
ELSE	
	IF dw_insert.getitemstring(i, "poblkt_tuncu") <> &
	   dw_insert.getitemstring(1, "poblkt_tuncu") THEN
		MessageBox('확 인', "통화단위를 확인하세요!")
		dw_insert.scrolltorow(i)
		dw_insert.setcolumn("poblkt_tuncu")
		dw_insert.setfocus()
		return -1
   END IF
END IF

/* 공정순서 */
IF isnull(dw_insert.getitemstring(i, "poblkt_opseq")) or &
	trim(dw_insert.getitemstring(i, "poblkt_opseq")) = '' then
	f_message_chk(30, '[공정순서]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("poblkt_opseq")
	dw_insert.setfocus()
	return -1
END IF

/* 납기예정일 */
IF isnull(dw_insert.getitemstring(i, "nadat")) or &
	trim(dw_insert.getitemstring(i, "nadat")) = '' then
	f_message_chk(30, '[납기예정일]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("nadat")
	dw_insert.setfocus()
	return -1
END IF

/* 계정코드 */
IF isnull(dw_insert.getitemstring(i, "accod")) or &
	trim(dw_insert.getitemstring(i, "accod")) = '' then
	f_message_chk(30, '[계정코드]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("accod")
	dw_insert.setfocus()
	return -1
END IF

/* 입고예정창고 */
IF isnull(dw_insert.getitemstring(i, "poblkt_ipdpt")) or &
	trim(dw_insert.getitemstring(i, "poblkt_ipdpt")) = '' then
	f_message_chk(30, '[입고예정창고]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("poblkt_ipdpt")
	dw_insert.setfocus()
	return -1
END IF

// 금액은 수정가능함
//dw_insert.setitem(i, "unamt", dw_insert.getitemnumber(i, 'cunamt'))

/* 납기예정일 */
IF dw_insert.getitemstring(i, 'opt')  = 'N' then
	dw_insert.setitem(i, "poblkt_gudat", dw_insert.getitemstring(i, 'nadat'))
	dw_insert.setitem(i, "fnadat", dw_insert.getitemstring(i, 'nadat'))
END IF

Return 1
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

dPrice = dw_insert.getitemdecimal(Lrow, "unprc")
dw_insert.setitem(Lrow, "poblkt_cnvprc", dPrice)

if dCnvfat = 1 then
	dw_insert.setitem(Lrow, "poblkt_cnvart", '*')
else	
	dw_insert.setitem(Lrow, "poblkt_cnvart", is_cnvart)	
end if

dw_insert.setitem(Lrow, "poblkt_cnvfat", dCnvfat)

// 변환계수 변환에 따른 내역 변경(수량, 단가, 금액)
if dw_insert.getitemdecimal(Lrow, "poblkt_cnvfat") = 1 then
	dw_insert.setitem(Lrow, "poblkt_cnvqty", dw_insert.getitemdecimal(Lrow, "balqty"))		
elseif dw_insert.getitemstring(Lrow, "poblkt_cnvart") = '/' then
	dw_insert.setitem(Lrow, "poblkt_cnvqty", round(dw_insert.getitemdecimal(Lrow, "balqty") / dCnvfat, 3))
else
	dw_insert.setitem(Lrow, "poblkt_cnvqty", round(dw_insert.getitemdecimal(Lrow, "balqty") * dCnvfat, 3))
end if

if dw_insert.getitemdecimal(Lrow, "poblkt_cnvfat") = 1  then
	dw_insert.setitem(Lrow, "poblkt_cnvamt", round(dw_insert.getitemdecimal(Lrow, "poblkt_cnvqty") * &
																  dw_insert.getitemdecimal(Lrow, "poblkt_cnvprc"), 2))			
elseif dw_insert.getitemstring(Lrow, "poblkt_cnvart") = '/' then
	dw_insert.setitem(Lrow, "unprc",  round(dw_insert.getitemdecimal(Lrow, "poblkt_cnvprc") / dCnvfat,  5))
	dw_insert.setitem(Lrow, "poblkt_cnvamt", round(dw_insert.getitemdecimal(Lrow, "poblkt_cnvqty") * &
																  dw_insert.getitemdecimal(Lrow, "poblkt_cnvprc"), 2))	
else
	dw_insert.setitem(Lrow, "unprc",  round(dw_insert.getitemdecimal(Lrow, "poblkt_cnvprc") * dCnvfat,  5))
	dw_insert.setitem(Lrow, "poblkt_cnvamt", round(dw_insert.getitemdecimal(Lrow, "poblkt_cnvqty") * &
																  dw_insert.getitemdecimal(Lrow, "poblkt_cnvprc"), 2))
end if
 
Return 0
end function

public subroutine wf_reset ();string sbalemp
string	sdeptcode, sdeptname
string	sdepot

dw_1.setredraw(false)
dw_insert.setredraw(false)

select deptcode, fun_get_dptno(deptcode)
  into :sdeptcode, :sdeptname
  from p1_master
 where empno = :gs_empno ;
 
dw_1.accepttext()

if dw_1.rowcount() > 0 then 
	sbalemp = dw_1.getitemstring(1, 'bal_empno') 
else
  SELECT "SYSCNFG"."DATANAME"  
    INTO :sBalemp  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
         ( "SYSCNFG"."SERIAL" = 14 ) AND  
         ( "SYSCNFG"."LINENO" = '3' )   ;
  if sqlca.sqlcode <> 0 then 
	  setnull(sBalemp)  
  else	  
     if len(sbalemp) > 6 then setnull(sBalemp)  
  end if
end if

dw_1.SetTabOrder('baljpno', 10)
dw_1.SetTabOrder('cvcod', 40)
dw_1.SetTabOrder('balgu', 0)
dw_1.SetTabOrder('bal_suip', 70)

dw_1.reset()
dw_insert.reset()

Ic_status = '1'
dw_1.insertrow(0)
dw_1.setitem(1, "sabu" , gs_sabu)
dw_1.setitem(1, "bal_empno" , sbalemp)
dw_1.Setitem(1, 'baldate', f_today())
dw_1.Setitem(1, 'bcvcod', sdeptcode)		// 발주부서

dw_1.setitem(1, "rdptno" , sdeptcode)		// 구매의뢰부서
dw_1.setitem(1, "dptnm" , sdeptname)

/*User별 사업장 선택 */
//f_mod_saupj(dw_1, 'saupj')
dw_1.SetItem(1, 'saupj', gs_saupj)

/*사업장별 담당자선택*/
f_child_saupj(dw_1,'bal_empno',gs_Saupj)

/*사업장별 창고선택*/
f_child_saupj(dw_1,'ipdpt',gs_Saupj)

/* mro 창고 */
//select cvcod into :sdepot from vndmst
// where cvgu = '5' and deptcode = :sdeptcode and juprod = 'Z' ;
SELECT CVCOD
  INTO :sdepot
  FROM VNDMST
 WHERE CVGU = '5'
   AND JUMAECHUL = '9';

if sqlca.sqlcode = 0 then
	dw_1.setitem(1,'ipdpt',sdepot)
end if

dw_1.SetFocus()

p_search.enabled = false
p_print.enabled = true

p_search.PictureName = "C:\erpman\image\특기사항등록_d.gif"
p_print.PictureName = "C:\erpman\image\발주처품목선택_up.gif"

dw_1.setredraw(true)
dw_insert.setredraw(true)
end subroutine

public function integer wf_create_gwdoc ();String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus, sCurr, sDisCurr
long   ll_FLength, dgwSeq, lRow
Dec    dTotAmt, dUnprc, dVnQty, dAmt

// HTML 문서를 읽어들인다
ll_FLength = FileLength("EAFolder_00022.html")
li_FileNum = FileOpen("EAFolder_00022.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 존재하지 않습니다.!!')
	Return -1
End If

// 그룹웨어 문서 번호 
sGwNo = dw_1.GetItemString(1, 'gwno')

sDate = dw_1.GetItemSTring(1,'baldate')
sDate = f_today()

// 그룹웨어 연동시 문서번호 채번...필요한 경우 함
If IsNull(sGwNo) Then
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[전자결재]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
Else
	Return 1
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// 반복행을 찾는다
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')
If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail에 대해서 반복해서 값을 setting한다
	ix = 1
	dTotAmt = 0
	do 
	
		// 원화금액으로 환산하여 총금액을 산출
		dVnQty = dw_insert.GetItemNumber(ix,'balqty')
		dUnPrc = dw_insert.GetItemNumber(ix,'unprc')
		sCurr  = dw_insert.GetItemString(ix, 'poblkt_tuncu')
		sDisCurr = dw_insert.Describe("evaluate('lookupdisplay(poblkt_tuncu)'," + string(ix) + ")")
		
		SELECT erp000000090(:sDate, :sCurr, :dUnPrc * :dVnQty, '2','3', 'Y') INTO :dAmt FROM DUAL;
		If IsnUll(dAmt) Then dAmt = 0
		dTotAmt = dTotAmt + dAmt
		
		nPos = Pos(sRepeat, '(_ROW_)')  
		If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, string(ix))	
		
		nPos = Pos(sDetRow, '(_IDTSC_)')
		sValue = dw_insert.GetItemString(ix,'itemas_itdsc')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_ISPEC_)')
		sValue = dw_insert.GetItemString(ix,'itemas_ispec')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue )
		
		nPos = Pos(sDetRow, '(_UNMSR_)')
		sValue = dw_insert.GetItemString(ix,'itemas_pumsr')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_QTY_)')
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, String(dw_insert.GetItemNumber(ix,'balqty'),'#,##0.00'))
		
		nPos = Pos(sDetRow, '(_PRC_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, sDisCurr + String(dw_insert.GetItemNumber(ix,'unprc'),'#,##0.00'))
		
		nPos = Pos(sDetRow, '(_AMT_)')  
		sValue  = String( dw_insert.GetItemNumber(ix,'balqty') * dw_insert.GetItemNumber(ix,'unprc') , '#,##0.00')
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, sValue)
		
		nPos = Pos(sDetRow, '(_ITNBR_)')
		sValue = dw_insert.GetItemString(ix,'itnbr')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)

		nPos = Pos(sDetRow, '(_CVNAS_)')
		sValue = dw_1.GetItemString(1,'vndmst_cvnas2')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
					
		sDetail = sDetail + sDetRow

		ix = ix + 1
	loop while (ix <= dw_insert.RowCount() )

	sCall = sHeader + sDetail + sFooter
End If

// Detail외 매크로 내역을 치환한다
nPos = Pos(sCall, '(_SDATE_)')
sValue = String(sDate,'@@@@.@@.@@')
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_ESTNO_)')
sValue = sEstNo
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

//nPos = Pos(sCall, '(_DEPT_NAME_)')
//sValue = Trim(dw_detail.GetItemString(1,'deptname'))
//If IsnUll(sValue) Then sValue = ''
//If nPos > 0 Then sCall = Replace(sCall, nPos, 13, sValue)

nPos = Pos(sCall, '(_YODAT_)')
sValue = Trim(dw_insert.GetItemString(1,'nadat'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_TOTAMT_)')  
sValue  = String( dTotAmt , '#,##0.00')
If nPos > 0 Then sCall = Replace(sCall, nPos, 10, sValue)
		
///////////////////////////////////////////////

If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 생성되지 않았습니다.!!')
	Return -1
End If

//EAERPHTML에 등록되었는지 확인
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// 기존 미상신 내역이 있으면 삭제
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// 그룹웨어 EAERPHTML TABLE에 기안내용을 INSERT한다
	INSERT INTO EAERPHTML
			  ( CSCODE, KEY1,  ERPEMPCODE, GWDOCGUBUN, SENDINGGUBUN, HTMLCONTENT, STATUS)
	 VALUES ( 'BDS',  :sGWno, Lower(:gs_userid),:isHtmlNo,    '1',   :sCall, '0') using sqlca1;
	If sqlca1.sqlcode <> 0 Then
		MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
		RollBack USING SQLCA1;
		Return -1
	End If
	
	COMMIT USING SQLCA1;
Else
	MessageBox('확인','기상신된 내역입니다.!!')
	Return 0
End If
 
// 기안서 상신
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//그룹웨어 문서번호
SetNull(gs_codename)		 			//제목입력받음(erptitle)
Open(w_groupware_browser)

//EAERPHTML에 상신되었는지 확인
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00022_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('결재상신','결재가 상신되었습니다.')
Else
	MessageBox('결재상신','결재가 상신되지 않았습니다.')
	Return -1
End If

// 그룹웨어 문서번호를 구매의뢰 테이블에 저장한다
dw_1.SetItem(1, 'web', '0')
dw_1.SetItem(1, 'gwno', sGwno)

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
end function

public function integer wf_ret_head (string arg_baljpno);dw_1.retrieve(gs_sabu, arg_baljpno)

p_inq.triggerevent(clicked!)

// 사업장, 입고예정창고
IF dw_insert.RowCount() > 0		THEN
	dw_1.SetItem(1, "ipdpt", dw_insert.GetItemString(1, "poblkt_ipdpt"))
END IF

dw_1.SetItem(1, 'saupj', gs_saupj)

return 1
end function

on w_imt_02046.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.dw_hidden=create dw_hidden
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_hidden
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_imt_02046.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.dw_hidden)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent('ue_open')
end event

event key;call super::key;// Page Up & Page Down & Home & End Key 사용 정의
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

event ue_open;call super::ue_open;
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

//IF ScNVGU = 'Y' THEN
//	dw_insert.dataobject = 'd_imt_02045_1_1'
//else
//	dw_insert.dataobject = 'd_imt_02045_1'
//end if

dw_1.SetTransObject(Sqlca)
dw_insert.SetTransObject(Sqlca)

// 전자결재 여동유무(발주검토)
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_gwgbn
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'W' ) AND  
		 ( "SYSCNFG"."SERIAL" = 1 ) AND  
		 ( "SYSCNFG"."LINENO" = '31' );
If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server 접속
	SQLCA1 = Create Transaction
	
	select dataname into	 :ls_dbms     from syscnfg where sysgu = 'W' and serial = '6' and lineno = '1';
	select dataname into	 :ls_database from syscnfg where sysgu = 'W' and serial = '6' and lineno = '2';
	select dataname into	 :ls_id	 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '3';
	select dataname into	 :ls_pwd 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '4';
	select dataname into	 :ls_host 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '5';
	select dataname into	 :ls_port 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '6';
	
	ls_conn_str = "DBMSSOCN,"+ls_host+","+ls_port 
	
	SetNull(ls_reg_cnn)
	RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", ls_host, RegString!, ls_reg_cnn) 
	
	If Trim(Upper(ls_conn_str)) <> Trim(Upper(ls_reg_cnn)) Or &
		( ls_reg_cnn =""  Or isNull(ls_reg_cnn) )  Then
		RegistrySet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", & 
						ls_host, RegString!, ls_conn_str)
	End If
	
	SQLCA1.DBMS = ls_dbms
	SQLCA1.Database = ls_database
	SQLCA1.LogPass = ls_pwd
	SQLCA1.ServerName = ls_host
	SQLCA1.LogId =ls_id
	SQLCA1.AutoCommit = False
	SQLCA1.DBParm = ""
	
	CONNECT USING SQLCA1;
	If sqlca1.sqlcode <> 0 Then
		messagebox(string(sqlca1.sqlcode),sqlca1.sqlerrtext)
		MessageBox('확 인','그룹웨어 연동을 할 수 없습니다.!!')
		is_gwgbn = 'N'
	End If
End If

wf_reset()
end event

event closequery;call super::closequery;// 그룹웨어 접속정보 해제
If is_gwgbn = 'Y' Then
	disconnect	using	sqlca1 ;
	destroy	sqlca1
End If
end event

type dw_insert from w_inherite`dw_insert within w_imt_02046
integer x = 37
integer y = 480
integer width = 4576
integer height = 1788
integer taborder = 20
string dataobject = "d_imt_02046_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String sData, sPrvdata, sNull, sName, sItem, sSpec, scvnas, stuncu, saccod, &
       sjijil, sispec_code, sProject, scode, scvcod, get_nm, get_nm2 , sDate, sittyp, sDepot
Decimal {5} dPrvdata, dData, dunprc, dunqty, djego
Long lrow
Integer ireturn
String	ls_pspec, sItgu

Lrow = this.getrow()

Setnull(sNull)

// 입고창고
sDepot = Trim(dw_1.GetItemString(1, 'ipdpt'))

IF this.GetColumnName() = "itnbr"	THEN
	sitem = trim(this.GetText())

	ls_pspec = this.Getitemstring(Lrow, "pspec")
	
	SELECT ITDSC, ISPEC, JIJIL, ITTYP INTO :sname, :sspec, :sjijil, :sittyp FROM ITEMAS WHERE ITNBR = :sitem;
	If sqlca.sqlcode = 0 Then
		ireturn = 0
	Else
		Return 2
	End If
	
	If sIttyp <> '5' And sIttyp <> '6' Then
		MessageBox('확인','저장품 및 SPARE PART만 등록가능합니다.!!')
		Return 2
	End If
	
 	ib_changed = true
	is_itnbr   = sitem

	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	
	scvcod 	= dw_1.GetItemString(1,"cvcod")
	
//	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)
	f_get_mro_price(sitem, scvcod, ddata)
	
	this.setitem(Lrow, "unprc", dData)
	
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "poblkt_tuncu", 'WON')
	else
		this.setitem(Lrow, "poblkt_tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

  	if sitem = '' or isnull(sitem) then 
		this.setitem(lrow, "accod", sNull)
	else
		SELECT FUN_GET_ITNACC(ITNBR, DECODE(ITGU,'6','5','4')),
		       fun_get_totstock_qty(:sdepot, :sitem, '.', '9999', '1')
		  INTO :sAccod, :djego FROM ITEMAS WHERE ITNBR = :sItem;
		
		this.setitem(lrow, "accod",    sAccod)
		this.setitem(lrow, "jego_qty", dJego)
  	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "pspec"	THEN	
	if isnull( gettext() ) or trim( gettext() ) ='' then
		setitem(Lrow, "pspec", '.')
		return 2
	End if
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	
	ls_pspec = this.Getitemstring(Lrow, "pspec")
	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)
	this.setitem(Lrow, "unprc", dData)
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "poblkt_tuncu", 'WON')
	else
		this.setitem(Lrow, "poblkt_tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

   if sitem = '' or isnull(sitem) then 
		this.setitem(lrow, "accod", sNull)
	else	
		SELECT FUN_GET_ITNACC(ITNBR, DECODE(ITGU,'6','5','4')) INTO :sAccod FROM ITEMAS WHERE ITNBR = :sItem;
		this.setitem(lrow, "accod", sAccod)
   end if
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sSPEC = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	
	ls_pspec = this.Getitemstring(Lrow, "pspec")
	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)	
	this.setitem(Lrow, "unprc", dData)
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "poblkt_tuncu", 'WON')
	else
		this.setitem(Lrow, "poblkt_tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

   if sitem = '' or isnull(sitem) then 
		this.setitem(lrow, "accod", sNull)
	else	
		SELECT FUN_GET_ITNACC(ITNBR, DECODE(ITGU,'6','5','4')) INTO :sAccod FROM ITEMAS WHERE ITNBR = :sItem;
		this.setitem(lrow, "accod", sAccod)
   end if
	
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	
	ls_pspec = this.Getitemstring(Lrow, "pspec")
	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)	
	this.setitem(Lrow, "unprc", dData)
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "poblkt_tuncu", 'WON')
	else
		this.setitem(Lrow, "poblkt_tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

   if sitem = '' or isnull(sitem) then 
		this.setitem(lrow, "accod", sNull)
	else	
		SELECT FUN_GET_ITNACC(ITNBR, DECODE(ITGU,'6','5','4')) INTO :sAccod FROM ITEMAS WHERE ITNBR = :sItem;
		this.setitem(lrow, "accod", sAccod)
   end if
	
	RETURN ireturn	
	
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sispec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	
	ls_pspec = this.Getitemstring(Lrow, "pspec")
	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)	
	this.setitem(Lrow, "unprc", dData)
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "poblkt_tuncu", 'WON')
	else
		this.setitem(Lrow, "poblkt_tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

   if sitem = '' or isnull(sitem) then 
		this.setitem(lrow, "accod", sNull)
	else	
		SELECT FUN_GET_ITNACC(ITNBR, DECODE(ITGU,'6','5','4')) INTO :sAccod FROM ITEMAS WHERE ITNBR = :sItem;
		this.setitem(lrow, "accod", sAccod)
   end if
	
	RETURN ireturn	
	
/* 입고예정창고 */
ELSEIF this.GetColumnName() = "poblkt_ipdpt" THEN
	scvcod = this.GetText()
	
	IF scvcod ="" OR IsNull(scvcod) THEN 
		this.SetItem(lrow,"vndmst_cvnas",snull)
		RETURN
	END IF
	
	SELECT "VNDMST"."CVNAS"   
	  INTO :sname
	  FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :scvcod AND "VNDMST"."CVGU" = '5' AND
	       "VNDMST"."CVSTATUS" = '0' ;
	 
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(lrow,"vndmst_cvnas",sName)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(lrow,"poblkt_ipdpt",snull)
			this.SetItem(lrow,"vndmst_cvnas2",snull)
		END IF
		
		Return 1	
	END IF
	
ELSEif this.getcolumnname() = 'nadat' then
	scvcod = TRIM(this.GetText())	
	if isnull(scvcod) or trim(scvcod) ='' or f_datechk(scvcod) = -1 then
		Messagebox("확인", "유효한 일자를 입력하십시요", stopsign!)
		dw_insert.setitem(lrow, "nadat", snull)
		dw_insert.SetColumn('nadat')
		dw_insert.SetFocus()
		return 1		
	end if	
ELSEif this.getcolumnname() = 'balsts' then
	sPrvdata = this.getitemstring(lrow, 'balsts')
	sData = gettext()
	if sData = '2' then
		f_message_chk(304, '[발주상태]')
		setitem(lrow, "balsts", sPrvdata)
		return 1
	end if
ELSEif getcolumnname() = 'balqty' then
	dPrvdata = getitemdecimal(lrow, 'balqty')
	dData = Dec(gettext())
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
	
	/* 금액계산 */
	Setitem(lrow, "unamt", Truncate(dData * getitemdecimal(Lrow, "unprc"),0))
											 
	// 변환계수에 의한 수량변환
	if getitemdecimal(Lrow, "poblkt_cnvfat") = 1  then
		setitem(Lrow, "poblkt_cnvqty", dData)
	elseif getitemstring(Lrow, "poblkt_cnvart") = '/' then
		if dData = 0 then
			setitem(Lrow, "poblkt_cnvqty", 0)
		Else
			setitem(Lrow, "poblkt_cnvqty", round(dData / getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
		End if
	else
		setitem(Lrow, "poblkt_cnvqty", round(dData * getitemdecimal(Lrow, "poblkt_cnvfat"), 3))
	end if
	
	Setitem(lrow, "poblkt_cnvamt", getitemdecimal(Lrow, "poblkt_cnvprc") * &
											 getitemdecimal(Lrow, "poblkt_cnvqty"))
ELSEif getcolumnname() = 'unprc' then
	dPrvdata = getitemdecimal(lrow, 'unprc')
	dData = Dec(gettext())
	if dData <= 0 then
		f_message_chk(30, '[발주단가]')
		setitem(lrow, "unprc", dPrvdata)
		return 1
	end if	
	
	/* 금액계산 */
	Setitem(lrow, "unamt", Truncate(dData * getitemdecimal(Lrow, "balqty"),0))
	
	// 변환계수에 의한 단가변환
	if getitemdecimal(Lrow, "poblkt_cnvfat") = 1   then
		setitem(Lrow, "poblkt_cnvprc", dData)
	elseif getitemstring(Lrow, "poblkt_cnvart") = '/'  then
		IF ddata = 0 then
			setitem(Lrow, "poblkt_cnvprc", 0)			
		else
			setitem(Lrow, "poblkt_cnvprc", ROUND(dData * getitemdecimal(Lrow, "poblkt_cnvfat"),5))
		end if
	else
		setitem(Lrow, "poblkt_cnvprc", ROUND(dData / getitemdecimal(Lrow, "poblkt_cnvfat"),5))
	end if
	setitem(Lrow, "poblkt_cnvamt", Round(getitemdecimal(Lrow, "poblkt_cnvqty") * &
													 getitemdecimal(Lrow, "poblkt_cnvprc"), 2))
/* 금액을 입력하는경우 단가를 재계산 한다 */
ELSEif getcolumnname() = 'unamt' then
	dPrvdata = getitemdecimal(lrow, 'unamt')
	dData = Dec(gettext())
	if dData <= 0 then
		f_message_chk(30, '[발주금액]')
		setitem(lrow, "unamt", dPrvdata)
		return 1
	end if	
	
	/* 단가 계산 */
	dunqty = getitemdecimal(lrow, 'balqty')
	If dunqty > 0 then
		dunprc = round(dData / dunqty,5)
	Else
		dunprc = 0
	End If
	SetItem(lrow, 'unprc', dunprc)
	
	// 변환계수에 의한 단가변환
	if getitemdecimal(Lrow, "poblkt_cnvfat") = 1   then
		setitem(Lrow, "poblkt_cnvprc", dunprc)
	elseif getitemstring(Lrow, "poblkt_cnvart") = '/'  then
		IF ddata = 0 then
			setitem(Lrow, "poblkt_cnvprc", 0)			
		else
			setitem(Lrow, "poblkt_cnvprc", ROUND(dunprc * getitemdecimal(Lrow, "poblkt_cnvfat"),5))
		end if
	else
		setitem(Lrow, "poblkt_cnvprc", ROUND(dunprc / getitemdecimal(Lrow, "poblkt_cnvfat"),5))
	end if
	setitem(Lrow, "poblkt_cnvamt", Round(getitemdecimal(Lrow, "poblkt_cnvqty") * &
													 getitemdecimal(Lrow, "poblkt_cnvprc"), 2))
ELSEif getcolumnname() = 'poblkt_opseq' then
	sitem = getitemString(lrow, 'itnbr')
	sdata = getitemString(lrow, 'poblkt_opseq')
	
	Select opdsc into :sName from routng where itnbr = :sitem and opseq = :sData;
	if sqlca.sqlcode <> 0  then
		setitem(lrow, "poblkt_opseq", '9999')
		setitem(lrow, "routng_opdsc", snull)
		return 1
	else
		setitem(lrow, "routng_opdsc", sName)
	end if
ELSEIF this.GetColumnName() = 'rdptno' THEN

	sitem = this.gettext()
	
   ireturn = f_get_name2('부서', 'Y', sitem, sname, sspec )	 
	this.setitem(lrow, "rdptno", sitem)
	this.setitem(lrow, "dptnm", sName)
   return ireturn 	 
	
ELSEIF this.getcolumnname() = "project_no"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
	SELECT "VW_PROJECT"."SABU"  
     INTO :sCode
     FROM "VW_PROJECT"  
    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
          ( "VW_PROJECT"."PJTNO" = :sProject )   ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[프로젝트 번호]')
		this.setitem(lRow, "project_no", sNull)
	   return 1
	END IF
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

	gs_gubun = '5'
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	
	SetColumn("itnbr")
	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
END IF

// 입고창고
IF this.GetColumnName() = 'poblkt_ipdpt'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"poblkt_ipdpt", gs_code)
	SetItem(lRow,"vndmst_cvnas", gs_codename)

	this.TriggerEvent("itemchanged")
END IF

// 공정
IF this.GetColumnName() = 'poblkt_opseq'	THEN

	sItnbr = this.getitemstring(lrow, "itnbr")
	openwithparm(w_routng_popup, sitnbr)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(lRow,"poblkt_opseq",gs_codename)
	SetItem(lRow,"vndmst_cvnas",gs_gubun)
	this.TriggerEvent("itemchanged")

// 부서
ELSEIF this.GetColumnName() = 'rdptno'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lrow,"rdptno",gs_code)
	SetItem(lrow,"dptnm",gs_codename)
ELSEIF this.GetColumnName() = "seqno" THEN
   this.accepttext()
   dw_1.accepttext()
	gs_code = this.getitemstring(lrow, 'itnbr')
	gs_codename = dw_1.getitemstring(1, 'cvcod')
	
	Open(w_itmbuy_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then		return
	this.SetItem(lrow, "seqno", integer(gs_Code))
elseif this.getcolumnname() = "project_no" 	then
	gs_gubun = '1'
	open(w_project_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(lRow, "project_no", gs_code)
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

event dw_insert::ue_key;call super::ue_key;str_itnct str_sitnct
string snull
Integer	nRow

setnull(gs_code)
setnull(snull)

nRow 	=  this.GetRow()
IF keydown(keyF3!) THEN
	IF This.GetColumnName() = "itnbr" Then
		gs_codename = dw_1.GetItemString(1,"cvcod")
		open(w_itmbuy2_popup)
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(nRow,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;If ib_changed = True Then
	this.setItem( row, 'itnbr', is_itnbr)
	ib_changed = False
	return
End If
end event

type p_delrow from w_inherite`p_delrow within w_imt_02046
boolean visible = false
integer x = 800
integer y = 2464
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_imt_02046
boolean visible = false
integer x = 613
integer y = 2452
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_imt_02046
integer x = 4233
integer y = 268
integer width = 306
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

type p_ins from w_inherite`p_ins within w_imt_02046
integer x = 3744
integer y = 12
end type

event p_ins::clicked;call super::clicked;Long Lrow, i

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if isnull(dw_1.getitemstring(1, "baldate")) or &
   Trim(dw_1.getitemstring(1, "baldate")) = '' then
	f_message_chk(30, '[발주일자]')
	dw_1.setcolumn("baldate")
	dw_1.setfocus()
	return
end if

if isnull(dw_1.getitemstring(1, "cvcod")) or &
   Trim(dw_1.getitemstring(1, "cvcod")) = '' then
	f_message_chk(30, '[발주처]')
	dw_1.setcolumn("cvcod")
	dw_1.setfocus()
	return
end if

if isnull(dw_1.getitemstring(1, "bal_empno")) or &
   Trim(dw_1.getitemstring(1, "bal_empno")) = '' then
	f_message_chk(30, '[발주담당자]')
	dw_1.setcolumn("bal_empno")
	dw_1.setfocus()
	return
end if

//////////////////////////////////////////////////////////////////////////////////////////////
string	sSaupj, sIpdpt , ls_plncrt

sSaupj 	= dw_1.GetItemString(1, "saupj")
sIpdpt 	= dw_1.GetItemString(1, "ipdpt")
ls_plncrt	= dw_1.GetItemString(1, "plncrt")

IF IsNull(sSaupj)	OR ssaupj = '99'	THEN
	f_message_chk(30, '[사업장]')
	dw_1.setcolumn("saupj")
	dw_1.setfocus()
	return
end if

IF IsNull(sIpdpt)		THEN
	f_message_chk(30, '[입고예정창고]')
	dw_1.setcolumn("ipdpt")
	dw_1.setfocus()
	return
end if

//////////////////////////////////////////////////////////////////////////////////////////////
FOR 	i = 1 TO dw_insert.RowCount()
	 	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

Lrow = dw_insert.insertrow(0)

dw_insert.setitem(lrow, "sabu",  gs_sabu)
dw_insert.setitem(lrow, "saupj", sSaupj)
dw_insert.setitem(lrow, "poblkt_ipdpt", sIpdpt)

dw_insert.setitem(lrow, "pomast_plncrt", ls_plncrt)

if 	lrow = 1 then 
	dw_insert.setitem(lrow, "balseq", 1)
else
	dw_insert.setitem(lrow, "balseq", dw_insert.getitemnumber(lrow - 1, "balseq") + 1 )
end if
if 	lrow > 1 then 
   	dw_insert.setitem(lrow, 'nadat', dw_insert.getitemstring(1, 'nadat'))
   	dw_insert.setitem(lrow, 'poblkt_tuncu', dw_insert.getitemstring(1, 'poblkt_tuncu'))
end if

dw_insert.setcolumn("itemas_itdsc")

// 연산자에 대한 자료 저장
if 	is_gubun = 'Y' then
	dw_insert.SetItem(lRow, "poblkt_cnvart", is_cnvart)
else
	dw_insert.SetItem(lRow, "poblkt_cnvart", '*')
end if

dw_insert.Scrolltorow(Lrow)
dw_insert.setrow(Lrow)
dw_insert.SetColumn('itnbr')
dw_insert.setfocus()

end event

type p_exit from w_inherite`p_exit within w_imt_02046
integer y = 12
end type

type p_can from w_inherite`p_can within w_imt_02046
integer y = 12
end type

event p_can::clicked;call super::clicked;/*사업장별 담당자선택*/
f_child_saupj(dw_1,'bal_empno',gs_Saupj)

/*사업장별 창고선택*/
f_child_saupj(dw_1,'ipdpt',gs_Saupj)

wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02046
integer x = 3922
integer y = 272
integer width = 306
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

event p_print::clicked;call super::clicked;//발주처 품목선택	-버턴명
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot, sempno
int    k, iRow
Decimal {5} ddata, djego

IF dw_1.AcceptText() = -1	THEN	RETURN

ls_Saupj 	= dw_1.GetItemString(1, "saupj")
sCvcod 	   = dw_1.getitemstring(1, "cvcod")
sempno	   = dw_1.getitemstring(1, "bal_empno")
sdepot      = dw_1.getitemstring(1, "ipdpt")

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[발주처]')
	dw_1.SetColumn("cvcod")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[발주담당자]')
	dw_1.SetColumn("bal_empno")
	dw_1.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code = sCvcod
open(w_mroitem_popup)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		iRow = dw_insert.insertrow(0)

		dw_insert.setitem(iRow, "sabu", gs_sabu)
		dw_insert.setitem(iRow, "saupj", ls_saupj)  //-- 사업장.
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
		
		//f_buy_unprc(sitem, '.' , '9999', scvcod, scvnas, ddata, stuncu)
		f_get_mro_price(sitem, scvcod, ddata)
		
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

		SELECT FUN_GET_ITNACC(ITNBR, DECODE(ITGU,'6','5','4')),
		       fun_get_totstock_qty(:sdepot, :sitem, '.', '9999', '1')
		  INTO :sAccod, :djego FROM ITEMAS WHERE ITNBR = :sItem;

		dw_insert.setitem(iRow, "accod",    sAccod)
		dw_insert.setitem(iRow, "jego_qty", djego)
		dw_insert.SetItem(iRow, "poblkt_ipdpt", sdepot)
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

type p_inq from w_inherite`p_inq within w_imt_02046
integer x = 3570
integer y = 12
end type

event p_inq::clicked;call super::clicked;string s_balju, sSaupj
long   lcount

if dw_1.AcceptText() = -1 then return 

s_balju = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(s_balju) or s_balju = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
   cb_search.enabled = false
	return
end if

if dw_1.Retrieve(gs_sabu, s_balju) <= 0 then 
	f_message_chk(50,'')
	wf_reset()
	return 
end if

// 사업장 변경
sSaupj = dw_1.GetItemString(1, 'saupj')
//f_child_saupj(dw_1, 'ipdpt', ssaupj)

if dw_insert.Retrieve(gs_sabu, s_balju) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return 
end if

IF dw_1.getitemstring(1, 'bal_suip') = '1' then 
   SELECT COUNT(*) into :lcount FROM IMHIST
	 WHERE SABU = :gs_sabu AND BALJPNO = :s_balju ;
ELSE
   SELECT COUNT(*) into :lcount FROM POLCDT
	 WHERE SABU = :gs_sabu AND BALJPNO = :s_balju ;
END IF

IF lcount > 0 then 
	dw_1.SetTabOrder('cvcod', 0)
	dw_1.SetTabOrder('balgu', 0)
	dw_1.SetTabOrder('bal_suip', 0)
//	dw_1.Object.cvcod.Background.Color= 79741120
//	dw_1.Object.balgu.Background.Color= 79741120
//	dw_1.Object.bal_suip.Background.Color= 79741120
END IF

Ic_status = '2'

dw_1.SetTabOrder('baljpno', 0)
//dw_1.Object.baljpno.Background.Color= 79741120

ib_any_typing = FALSE
p_search.enabled = true
p_print.enabled = false

p_search.PictureName = "C:\erpman\image\특기사항등록_up.gif"
p_print.PictureName = "C:\erpman\image\발주처품목선택_d.gif"

end event

type p_del from w_inherite`p_del within w_imt_02046
integer x = 3922
integer y = 12
end type

event p_del::clicked;call super::clicked;Long Lrow, irow, irow2, i
String sBaljpno

Lrow = dw_insert.getrow()

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

If dw_insert.getitemdecimal(Lrow, "rcqty")  > 0 or &
   dw_insert.getitemdecimal(Lrow, "lcoqty") > 0 then
	Messagebox("삭제", "이미 진행된 자료입니다", stopsign!)
	return
End if

if ic_status = '2' then 
	irow = dw_insert.getrow() - 1
	irow2 = dw_insert.getrow() + 1
	if irow > 0 then   
		FOR i = 1 TO irow
			IF wf_required_chk(i) = -1 THEN RETURN
		NEXT
	end if	
	
	FOR i = irow2 TO dw_insert.RowCount()
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
	
	if dw_insert.rowcount() > 1 then 
		if MessageBox("삭 제","삭제 하시겠습니까?",Question!, YesNo!, 2) <> 1 then return
	else
		if MessageBox("삭 제", "마지막 자료를 삭제하시면 발주에 모든 자료가 삭제됩니다. ~n~n" + &
							  "삭제 하시겠습니까?",Question!, YesNo!, 2) <> 1 then return
	end if	
	
	dw_insert.SetRedraw(FALSE)
	dw_insert.DeleteRow(Lrow)
	
	sBaljpno = trim(dw_1.getitemstring(1, "baljpno"))
	FOR i = 1 TO dw_insert.RowCount()
		dw_insert.setitem(i, "baljpno", sBaljpno)
	NEXT
	if dw_insert.Update() = 1 then
		if dw_insert.rowcount() < 1 then 
			DELETE FROM PORMKS  WHERE SABU = :gs_sabu AND BALJPNO =  :sbaljpno   ;
			DELETE FROM POMAST  WHERE SABU = :gs_sabu AND BALJPNO =  :sbaljpno   ;
			if sqlca.sqlcode <> 0 then 
				rollback ;
				messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
				wf_reset()
				dw_insert.SetRedraw(TRUE)
				return 
			end if	
			commit ;
			wf_reset()
			sle_msg.text =	"자료를 삭제하였습니다!!"	
			ib_any_typing = false
			dw_insert.SetRedraw(TRUE)
			return 
		end if	
		sle_msg.text =	"자료를 삭제하였습니다!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		wf_reset()
	end if	
	
	dw_insert.SetRedraw(TRUE)
else
	dw_insert.DeleteRow(Lrow)
end if
end event

type p_mod from w_inherite`p_mod within w_imt_02046
integer x = 4096
integer y = 12
end type

event p_mod::clicked;call super::clicked;string sdate, sBaljpno, get_nm, ls_rdptno
Int i, dseq, li_row

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

ls_rdptno = dw_1.getItemString(1,'rdptno')

If ls_rdptno = '' or IsNull(ls_rdptno) Then
	f_message_chk(30, '[ 구매의뢰 부서 ]')
	dw_1.setcolumn("rdptno")
	dw_1.setfocus()
	return
Else
	FOR li_row = 1 to dw_insert.RowCount()
      dw_insert.SetItem(li_row, 'rdptno', ls_rdptno)
	NEXT
End If

if 	isnull(dw_1.getitemstring(1, "baldate")) or &
   	Trim(dw_1.getitemstring(1, "baldate")) = '' then
	f_message_chk(30, '[발주일자]')
	dw_1.setcolumn("baldate")
	dw_1.setfocus()
	return
end if

if 	isnull(dw_1.getitemstring(1, "cvcod")) or &
   	Trim(dw_1.getitemstring(1, "cvcod")) = '' then
	f_message_chk(30, '[발주처]')
	dw_1.setcolumn("cvcod")
	dw_1.setfocus()
	return
end if

/* 일반사항 check */
if ic_status = '1' then 
	if cbx_1.checked = false then 
 		sBaljpno = trim(dw_1.getitemstring(1, "baljpno"))
		if isnull(sbaljpno) or sBaljpno = '' then
			f_message_chk(30, '[발주번호]')
			dw_1.setcolumn("baljpno")
			dw_1.setfocus()
			return
		end if
	else
		sDate  = trim(dw_1.GetItemString(1, "baldate"))				// 발주일자
		
		dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'K0')
		if dSeq = -1 then 
			rollback;
			f_message_chk(51, '')
			return 
		end if
		Commit;
		sBaljpno = sDate + String(dseq, '0000')
		
	   SELECT "POMAST"."SABU"  
  	  	  INTO :get_nm  
   	 	  FROM "POMAST"  
	       WHERE ( "POMAST"."SABU" = :gs_sabu ) AND ( "POMAST"."BALJPNO" = :sBaljpno )   ;

      if sqlca.sqlcode = 0 then 
			rollback;
			f_message_chk(51, '')
			return 
      end if			
      dw_1.setitem(1, "baljpno", sBaljpno)
	end if
end if

//////////////////////////////////////////////////////////////////////////////////
string	sSaupj, sIpdpt
dec		dRcqty, dLcqty
sSaupj = dw_1.GetItemString(1, "saupj")
sIpdpt = dw_1.GetItemString(1, "ipdpt")

IF IsNull(sSaupj)		THEN
	f_message_chk(30, '[사업장]')
	dw_1.setcolumn("saupj")
	dw_1.setfocus()
	return
end if

IF 	IsNull(sIpdpt)		THEN
	f_message_chk(30, '[입고예정창고]')
	dw_1.setcolumn("ipdpt")
	dw_1.setfocus()
	return
end if

FOR i = 1 TO dw_insert.RowCount()
	
	dRcqty = dw_insert.GetItemDecimal(i, "rcqty")
	dLcqty = dw_insert.GetItemDecimal(i, "lcoqty")
	
	IF dRcqty > 0  or  dLcqty > 0		THEN
	ELSE
		dw_insert.SetItem(i, "saupj", sSaupj)
 		dw_insert.SetItem(i, "poblkt_ipdpt", sIpdpt)
	END IF
	
	IF wf_required_chk(i) = -1 THEN RETURN
	
NEXT
//////////////////////////////////////////////////////////////////////////////////
if f_msg_update() = -1 then return

sBaljpno = trim(dw_1.getitemstring(1, "baljpno"))
FOR i = 1 TO dw_insert.RowCount()
   dw_insert.setitem(i, "baljpno", sBaljpno)
NEXT

// 구매의뢰 연동시
IF is_gwgbn = 'Y' then
	wf_create_gwdoc()
End If

if dw_1.update() = 1 then
	if dw_insert.update() = 1 then
		messagebox("저장완료", "자료가 저장되었습니다!!")
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		return 
   end if	
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

//if ic_status = '1' then 
//	Ic_status = '2'
//	dw_1.SetTabOrder('baljpno', 0)
//	cb_search.enabled = true
//	cb_print.enabled = false
//end if

wf_reset()
ib_any_typing = FALSE
end event

type cb_exit from w_inherite`cb_exit within w_imt_02046
end type

type cb_mod from w_inherite`cb_mod within w_imt_02046
end type

type cb_ins from w_inherite`cb_ins within w_imt_02046
end type

type cb_del from w_inherite`cb_del within w_imt_02046
end type

type cb_inq from w_inherite`cb_inq within w_imt_02046
end type

type cb_print from w_inherite`cb_print within w_imt_02046
end type

type st_1 from w_inherite`st_1 within w_imt_02046
integer x = 23
end type

type cb_can from w_inherite`cb_can within w_imt_02046
end type

type cb_search from w_inherite`cb_search within w_imt_02046
integer x = 2130
integer y = 0
integer width = 869
integer height = 168
integer taborder = 100
boolean enabled = false
string text = "특기사항등록"
end type

type dw_datetime from w_inherite`dw_datetime within w_imt_02046
integer x = 2866
end type

type sle_msg from w_inherite`sle_msg within w_imt_02046
integer x = 375
end type



type gb_button1 from w_inherite`gb_button1 within w_imt_02046
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02046
end type

type dw_1 from datawindow within w_imt_02046
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 168
integer width = 3035
integer height = 288
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02046_a"
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

event itemchanged;string snull, sbaljno, get_nm, s_date, s_empno, s_name
int    ireturn, li_row 

setnull(snull)

IF this.GetColumnName() ="baljpno" THEN
	sbaljno = trim(this.GetText())
	
	IF	Isnull(sbaljno)  or  sbaljno = ''	Then
		wf_reset()
		RETURN 
   END IF

  SELECT "POMAST"."BGUBUN"  
    INTO :get_nm  
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :sbaljno ) AND
			( "POMAST"."BALGU" = '9' );

	IF SQLCA.SQLCODE = 0 then 
		IF get_nm = '2' then 
			p_inq.PostEvent(Clicked!)
//			Post wf_ret_head(sbaljno)
		ELSE
			MessageBox("확 인", "소모품 발주에서 등록된 발주가 아닙니다. 발주번호를 확인하세요.!")
			wf_reset()
			RETURN 1
		END IF
	END IF
ELSEIF	this.getcolumnname() = "baldate"		THEN
   s_date = trim(this.gettext())
	
	if s_date = '' or isnull(s_date) then return 
	
	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[발주일자]')
		this.setitem(1, "baldate", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "plnopn"		THEN
   s_date = trim(this.gettext())
	
	if s_date = '' or isnull(s_date) then return 
	
	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[L/C OPEN 계획일]')
		this.setitem(1, "plnopn", sNull)
		return 1
	END IF
//ELSEIF	this.getcolumnname() = "bal_empno"		THEN
//	s_empno = this.gettext()
// 
//   IF s_empno = "" OR IsNull(s_empno) THEN RETURN
//	
//	s_name = f_get_reffer('43', s_empno)
//	if isnull(s_name) or s_name="" then
//		f_message_chk(33,'[발주담당자]')
//		this.SetItem(1,'bal_empno', snull)
//		return 1
//   end if	
ELSEIF this.GetColumnName() = "cvcod" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod", s_empno)	
	this.setitem(1, "vndmst_cvnas2", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "bal_suip" THEN
	s_empno = this.GetText()
   if s_empno = '1' then 
		this.setitem(1, "plnbnk", snull)	
		this.setitem(1, "plnopn", snull)	
	end if	
ElseIf this.GetColumnName() = 'rdptno' THEN
	s_empno = this.gettext()
   ireturn = f_get_name2('부서', 'Y', s_empno, get_nm, s_name )	 
	this.setitem(1, "rdptno", s_empno)
	this.setitem(1, "dptnm", get_nm)
	
	FOR li_row = 1 to dw_insert.RowCount()
      dw_insert.SetItem(li_row, 'rdptno',s_empno )
	NEXT
	
	RETURN ireturn
ElseIf GetColumnName() = 'saupj' THEN
	s_date = GetText()
	/*사업장별 담당자선택*/
	f_child_saupj(dw_1,'bal_empno',s_date)

	/*사업장별 창고선택*/
	f_child_saupj(dw_1,'ipdpt',s_date)
	
	
	SetItem(1,"bal_empno",snull)
	SetItem(1,"ipdpt",snull)
END IF	

end event

event itemerror;return 1
end event

event rbuttondown;String sNull

setnull(gs_code); setnull(gs_gubun); setnull(gs_codename); setnull(snull)

IF this.GetColumnName() = "baljpno" THEN
	gs_code  = '9'	// mro
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_poblkt_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
   this.setitem(1, 'baljpno', gs_code)
   p_inq.TriggerEvent(Clicked!)
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
	this.SetItem(1, "vndmst_cvnas2", gs_Codename)
ELSEIF this.GetColumnName() = 'rdptno'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"rdptno",gs_code)
	SetItem(1,"dptnm",gs_codename)
	THIS.TriggerEvent(ItemChanged!)
END IF
end event

event editchanged;ib_any_typing =True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount, ireturn

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
end event

type cbx_1 from checkbox within w_imt_02046
integer x = 4233
integer y = 196
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
boolean enabled = false
string text = "자동채번"
boolean checked = true
end type

type dw_hidden from datawindow within w_imt_02046
boolean visible = false
integer x = 9
integer y = 8
integer width = 1957
integer height = 168
boolean bringtotop = true
string dataobject = "d_mroitem_popup"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_imt_02046
integer x = 709
integer y = 256
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('baldate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'baldate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_02046
boolean visible = false
integer x = 3488
integer y = 256
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('plnopn')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'plnopn', gs_code)



end event

type rr_1 from roundrectangle within w_imt_02046
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3849
integer y = 176
integer width = 759
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_02046
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 472
integer width = 4590
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

