$PBExportHeader$w_imt_02045.srw
$PBExportComments$** ���� ����
forward
global type w_imt_02045 from w_inherite
end type
type dw_1 from datawindow within w_imt_02045
end type
type cbx_1 from checkbox within w_imt_02045
end type
type dw_hidden from datawindow within w_imt_02045
end type
type pb_1 from u_pb_cal within w_imt_02045
end type
type pb_2 from u_pb_cal within w_imt_02045
end type
type cb_1 from commandbutton within w_imt_02045
end type
type dw_hidden2 from datawindow within w_imt_02045
end type
type dw_imhist from datawindow within w_imt_02045
end type
type cb_2 from commandbutton within w_imt_02045
end type
type dw_hidden3 from datawindow within w_imt_02045
end type
type cb_3 from commandbutton within w_imt_02045
end type
type dw_hidden4 from datawindow within w_imt_02045
end type
type st_2 from statictext within w_imt_02045
end type
type rr_1 from roundrectangle within w_imt_02045
end type
type rr_2 from roundrectangle within w_imt_02045
end type
end forward

global type w_imt_02045 from w_inherite
integer width = 4667
integer height = 2624
string title = "���ǹ���"
dw_1 dw_1
cbx_1 cbx_1
dw_hidden dw_hidden
pb_1 pb_1
pb_2 pb_2
cb_1 cb_1
dw_hidden2 dw_hidden2
dw_imhist dw_imhist
cb_2 cb_2
dw_hidden3 dw_hidden3
cb_3 cb_3
dw_hidden4 dw_hidden4
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_02045 w_imt_02045

type prototypes
function LONG ImmGetContext( long handle ) LIBRARY "IMM32.DLL"
function LONG ImmSetConversionStatus( long hIMC, long fFlag, long l ) &
                              LIBRARY "IMM32.DLL"
function LONG ImmReleaseContext( long handle, long hIMC )  &
                              LIBRARY "IMM32.DLL"
end prototypes

type variables
boolean  ib_changed
char ic_status
sTring is_gubun, is_cnvart
String is_pspec, is_jijil, is_itnbr

String   is_gwgbn   // �׷���� ��������
Transaction SQLCA1				// �׷���� ���ӿ�
String     isHtmlNo = '00022'	// �׷���� ������ȣ
end variables

forward prototypes
public function integer wf_required_chk (integer i)
public function integer wf_cnvfat (long lrow, string arg_itnbr)
public subroutine wf_reset ()
public function integer wf_create_gwdoc ()
public function integer wf_ret_head (string arg_baljpno)
public function integer wf_imhist_create ()
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_itemchk (string as_cvcod)
public function integer wf_balju_cnt (string arg_yymmdd, string arg_date, string arg_cvcod, string arg_itnbr)
public function integer wf_bal_delete (string as_saupj, string as_yymmdd, string as_cvcod, string as_itnbr, string as_baljpno)
end prototypes

public function integer wf_required_chk (integer i);/* ǰ�� */
IF isnull(dw_insert.getitemstring(i, "itnbr")) or &
	trim(dw_insert.getitemstring(i, "itnbr")) = '' then
	f_message_chk(30, '[ǰ��]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("itnbr")
	dw_insert.setfocus()
	return -1
END IF

/* ��� 		*/
if isnull(dw_insert.getitemstring(i, "pspec")) or &
   trim(dw_insert.getitemstring(i, "pspec")) = '' then
	dw_insert.setitem(i, "pspec", '.')
end if

/* �ΰ������ */
IF isnull(dw_insert.getitemstring(i, "saupj")) or &
	trim(dw_insert.getitemstring(i, "saupj")) = '' then
	f_message_chk(30, '[�����]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("saupj")
	dw_insert.setfocus()
	return -1
END IF

//IF isnull(dw_insert.getitemstring(i, "rdptno")) or &
//	trim(dw_insert.getitemstring(i, "rdptno")) = '' then
//	f_message_chk(30, '[�Ƿںμ�]')
//	dw_insert.scrolltorow(i)
//	dw_insert.setcolumn("rdptno")
//	dw_insert.setfocus()
//	return -1
//END IF

if ISNULL(dw_insert.getitemdecimal(i, "balqty")) OR &
   dw_insert.getitemdecimal(i, "balqty") < 1 then
	f_message_chk(30, '[���ּ���]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("balqty")
	dw_insert.setfocus()
	return -1
end if

if ISNULL(dw_insert.getitemdecimal(i, "unprc")) then
//OR &
//	dw_insert.getitemdecimal(i, "unprc") <= 0 then
	f_message_chk(30, '[���ִܰ�]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("unprc")
	dw_insert.setfocus()
	return -1
end if

/* ��ȭ���� */
IF isnull(dw_insert.getitemstring(i, "poblkt_tuncu")) or &
	trim(dw_insert.getitemstring(i, "poblkt_tuncu")) = '' then
	f_message_chk(30, '[��ȭ����]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("poblkt_tuncu")
	dw_insert.setfocus()
	return -1
ELSE	
	IF dw_insert.getitemstring(i, "poblkt_tuncu") <> &
	   dw_insert.getitemstring(1, "poblkt_tuncu") THEN
		MessageBox('Ȯ ��', "��ȭ������ Ȯ���ϼ���!")
		dw_insert.scrolltorow(i)
		dw_insert.setcolumn("poblkt_tuncu")
		dw_insert.setfocus()
		return -1
   END IF
END IF

/* �������� */
IF isnull(dw_insert.getitemstring(i, "poblkt_opseq")) or &
	trim(dw_insert.getitemstring(i, "poblkt_opseq")) = '' then
	f_message_chk(30, '[��������]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("poblkt_opseq")
	dw_insert.setfocus()
	return -1
END IF

/* ���⿹���� */
IF isnull(dw_insert.getitemstring(i, "nadat")) or &
	trim(dw_insert.getitemstring(i, "nadat")) = '' then
	f_message_chk(30, '[���⿹����]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("nadat")
	dw_insert.setfocus()
	return -1
END IF

/* �����ڵ� */
IF isnull(dw_insert.getitemstring(i, "accod")) or &
	trim(dw_insert.getitemstring(i, "accod")) = '' then
	f_message_chk(30, '[�����ڵ�]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("accod")
	dw_insert.setfocus()
	return -1
END IF

/* �԰���â�� */
IF isnull(dw_insert.getitemstring(i, "poblkt_ipdpt")) or &
	trim(dw_insert.getitemstring(i, "poblkt_ipdpt")) = '' then
	f_message_chk(30, '[�԰���â��]')
	dw_insert.scrolltorow(i)
	dw_insert.setcolumn("poblkt_ipdpt")
	dw_insert.setfocus()
	return -1
END IF

// �ݾ��� ����������
//dw_insert.setitem(i, "unamt", dw_insert.getitemnumber(i, 'cunamt'))

/* ���⿹���� */
IF dw_insert.getitemstring(i, 'opt')  = 'N' then
	dw_insert.setitem(i, "poblkt_gudat", dw_insert.getitemstring(i, 'nadat'))
	dw_insert.setitem(i, "fnadat", dw_insert.getitemstring(i, 'nadat'))
END IF

Return 1
end function

public function integer wf_cnvfat (long lrow, string arg_itnbr);Decimal {5} dCnvfat, dPrice

// ǰ�񸶽����� conversion factor�� �˻�
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

// ��ȯ��� ��ȯ�� ���� ���� ����(����, �ܰ�, �ݾ�)
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

dw_1.accepttext()
 
if dw_1.rowcount() > 0 then 
	sbalemp = dw_1.getitemstring(1, 'bal_empno') 
else
  SELECT "SYSCNFG"."DATANAME"  
    INTO :sBalemp  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
         ( "SYSCNFG"."SERIAL" = 14 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
  if sqlca.sqlcode <> 0 then 
	  setnull(sBalemp)  
  else	  
     if len(sbalemp) > 6 then setnull(sBalemp)  
  end if
end if

dw_1.SetTabOrder('baljpno', 10)
dw_1.SetTabOrder('cvcod', 40)
dw_1.SetTabOrder('balgu', 50)
dw_1.SetTabOrder('bal_suip', 70)

dw_1.reset()
dw_insert.reset()

Ic_status = '1'
dw_1.insertrow(0)
dw_1.setitem(1, "sabu" , gs_sabu)
dw_1.setitem(1, "bal_empno" , sbalemp)
//dw_1.Setitem(1, 'baldate', f_today())

///*User�� ����� ���� */
//f_mod_saupj(dw_1, 'saupj')
dw_1.SetItem(1, 'saupj', gs_saupj)

///*����庰 ����ڼ���*/
f_child_saupj(dw_1,'bal_empno',gs_Saupj)

String ls_emp
SELECT RFGUB
  INTO :ls_emp
  FROM REFFPF
 WHERE RFCOD =  '43'
   AND RFGUB <> '00'
   AND RFNA3 =  :gs_empno ;
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	dw_1.SetItem(1, 'bal_empno', '05')
	String ls_dept
	String ls_deptnm
	SELECT DEPTCODE, FUN_GET_CVNAS(DEPTCODE)
	  INTO :ls_dept, :ls_deptnm
	  FROM P1_MASTER
	 WHERE EMPNO = ( SELECT RFNA3 FROM REFFPF WHERE RFCOD = '43' AND RFGUB = '05' ) ;
	dw_1.SetItem(1, 'rdptno', ls_dept)
	dw_1.SetItem(1, 'dptnm' , ls_deptnm)	
Else
	dw_1.SetItem(1, 'bal_empno', ls_emp)
	dw_1.SetItem(1, 'rdptno', gs_dept)
   dw_1.SetItem(1, 'dptnm', f_get_name5('01', gs_dept, ''))
End If

/*����庰 â����*/
f_child_saupj(dw_1,'ipdpt',gs_Saupj)


// ���� �԰�â��� ����â��� ���
//select cvcod into :sdepot from vndmst    where cvgu = '5' and jumaechul = '1'  and ipjogun = :gs_saupj and rownum = 1 ;
//dw_1.SetItem(1, 'ipdpt', sdepot)

dw_1.SetFocus()

p_search.enabled = false
p_print.enabled = true

p_search.PictureName = "C:\erpman\image\Ư����׵��_d.gif"
p_print.PictureName = "C:\erpman\image\����óǰ����_up.gif"

dw_1.setredraw(true)
dw_insert.setredraw(true)
end subroutine

public function integer wf_create_gwdoc ();String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus, sCurr, sDisCurr
long   ll_FLength, dgwSeq, lRow
Dec    dTotAmt, dUnprc, dVnQty, dAmt

// HTML ������ �о���δ�
ll_FLength = FileLength("EAFolder_00022.html")
li_FileNum = FileOpen("EAFolder_00022.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('Ȯ ��','HTML ������ �������� �ʽ��ϴ�.!!')
	Return -1
End If

// �׷���� ���� ��ȣ 
sGwNo = dw_1.GetItemString(1, 'gwno')

sDate = dw_1.GetItemSTring(1,'baldate')
sDate = f_today()

// �׷���� ������ ������ȣ ä��...�ʿ��� ��� ��
If IsNull(sGwNo) Then
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[���ڰ���]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
Else
	Return 1
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// �ݺ����� ã�´�
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')
If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail�� ���ؼ� �ݺ��ؼ� ���� setting�Ѵ�
	ix = 1
	dTotAmt = 0
	do 
	
		// ��ȭ�ݾ����� ȯ���Ͽ� �ѱݾ��� ����
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

// Detail�� ��ũ�� ������ ġȯ�Ѵ�
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
	MessageBox('Ȯ ��','HTML ������ �������� �ʾҽ��ϴ�.!!')
	Return -1
End If

//EAERPHTML�� ��ϵǾ����� Ȯ��
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// ���� �̻�� ������ ������ ����
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// �׷���� EAERPHTML TABLE�� ��ȳ����� INSERT�Ѵ�
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
	MessageBox('Ȯ��','���ŵ� �����Դϴ�.!!')
	Return 0
End If
 
// ��ȼ� ���
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//�׷���� ������ȣ
SetNull(gs_codename)		 			//�����Է¹���(erptitle)
Open(w_groupware_browser)

//EAERPHTML�� ��ŵǾ����� Ȯ��
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00022_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('������','���簡 ��ŵǾ����ϴ�.')
Else
	MessageBox('������','���簡 ��ŵ��� �ʾҽ��ϴ�.')
	Return -1
End If

// �׷���� ������ȣ�� �����Ƿ� ���̺� �����Ѵ�
dw_1.SetItem(1, 'web', '0')
dw_1.SetItem(1, 'gwno', sGwno)

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
end function

public function integer wf_ret_head (string arg_baljpno);dw_1.retrieve(gs_sabu, arg_baljpno)

p_inq.triggerevent(clicked!)

// �����, �԰���â��
IF dw_insert.RowCount() > 0		THEN
	dw_1.SetItem(1, "ipdpt", dw_insert.GetItemString(1, "poblkt_ipdpt"))
END IF

dw_1.SetItem(1, 'saupj', gs_saupj)

return 1
end function

public function integer wf_imhist_create ();return 1
/////////////////////////////////////////////////////////////////////////
////
////	* ��ϸ��
////	1. �����HISTORY ����
////	2. ��ǥä������ = 'C0'
//// 3. ��ǥ�������� = '001'
//// => (����) ������ ���ֻ�� �ڵ� ó��
////
/////////////////////////////////////////////////////////////////////////
//
//string	sJpno, sIOgubun,	sDate, sTagbn, sEmpno2, sDept, &
//         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom
//long		lRow, lRowHist, lRowHist_In
//dec		dSeq, dOutQty,	dInSeq
//String   sStock, sGrpno, sGubun
//
//dw_1.AcceptText()
//dw_imhist.reset()
//
//Setnull(sNull)
////////////////////////////////////////////////////////////////////////////////////////
//string	sHouseGubun, sIngubun
//
//sIOgubun = "O06"		// ���ұ���(���ֻ�����)
//
//setnull(srcvcod)
//SELECT AUTIPG, RCVCOD, TAGBN, NVL(IOYEA4,'N')
//  INTO :sHouseGubun, :sRcvcod, :sTagbn, :sInsQc
//  FROM IOMATRIX
// WHERE SABU = :gs_sabu		AND
// 		 IOGBN = :sIOgubun ;
//		  
//if sqlca.sqlcode <> 0 then
//	f_message_chk(208, '[�����]')
//end if
///* â���̵� ����� ��� ��� �԰����� �˻� */
//if sHousegubun = 'Y' then
//	if isnull(srcvcod) or trim(srcvcod) = '' then
//		f_message_chk(208, '[�����-â���̵��԰�]')	
//		return -1
//	end if
//	//���˻� ����Ÿ ��������
//   SELECT "SYSCNFG"."DATANAME"  
//     INTO :sQcgub  
//     FROM "SYSCNFG"  
//    WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
//          ( "SYSCNFG"."SERIAL" = 13 ) AND  
//          ( "SYSCNFG"."LINENO" = '2' )   ;
//	if sqlca.sqlcode <> 0 then
//		sQcgub = '1'
//	end if
//	
//	/* �ܰ������Ϳ� �˻����ڰ� ���� ��� ȯ�漳���� �ִ� �⺻ �˻����ڸ� �̿��Ѵ� */
//	select dataname
//	  into :scustom
//	  from syscnfg
//	 where sysgu = 'Y' and serial = '13' and lineno = '1';
//end if
//
//sDate = dw_1.GetItemString(1, "baldate")				// �������
//dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
//IF dSeq < 0		THEN	
//	rollback;
//	RETURN -1
//end if
//
//COMMIT;
//
//////////////////////////////////////////////////////////////////////////
//sJpno   = sDate + string(dSeq, "0000")
//sHouse  = dw_1.GetItemString(1, "ipdpt")  //���â��
//sEmpno2 = gs_empno  								//�������
//sEmpno  = gs_empno   							//�Ƿ���
//sDept   = dw_1.GetItemString(1, "rdptno") //�Ƿںμ�
//sCvcod  = dw_1.GetItemString(1, "cvcod")  //�԰�ó
//
//IF sHouseGubun = 'Y'		THEN	
//	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
//	IF dInSeq < 0		THEN	
//		rollback;
//		RETURN -1
//	end if
//	COMMIT;
//
//END IF
//
////////////////////////////////////////////////////////////////////////////////////////
//
//FOR	lRow = 1		TO		dw_list.RowCount()
//
//	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")
//
//	IF abs(dOutQty) > 0		THEN
//
//		////////////////////////////////////////////////////////////////////////////////
//		// ** �����HISTORY ���� **
//		////////////////////////////////////////////////////////////////////////////////
//		lRowHist = dw_imhist.InsertRow(0)
//		
//		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
//		dw_imhist.SetItem(lRowHist, "jnpcrt",	'001')			// ��ǥ��������
//		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// �������
//		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
//		dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// ���ұ���=��û����
//	
//		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// ��������=�������
//		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // ǰ��
//
//		sPspec = trim(dw_list.GetItemString(lRow, "pspec"))
//		if sPspec = '' or isnull(sPspec) then sPspec = '.'
//		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // ���
//		
//		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// ����â��=���â��
//		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// �ŷ�óâ��=�԰�ó
//		dw_imhist.SetItem(lRowHist, "ioqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=������
//		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		
//		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// �˻�����=�������	
//		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
//		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// �����ڵ�
//		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
//		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// ���ҽ�������=�������	
//		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// ���ҽ�����=�����	
//		dw_imhist.SetItem(lRowHist, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // ����������
//		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
//		dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
//      
//		//�����  �߰�
//		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// �����Ƿںμ�=�Ҵ�.�μ�
//		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
//		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// ��������� ��� '99999999' ����
//		
//		dw_imHist.SetItem(lRowHist, "lotsno",	dw_list.GetItemString(lRow, "lotsno"))
//
//		dw_imHist.SetItem(lRowHist, "pjt_cd",	  sProject)		// 
//		dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)
//		
//// 	dw_imhist.SetItem(lRowHist, "outchk",  'Y') 			// ����ǷڿϷ�
//		
//		// â���̵� �԰��� ����
//		IF sHouseGubun = 'Y'	and dOutQty > 0	THEN
//			
//			lRowHist_In = dw_imhist_in.InsertRow(0)						
//			
//			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
//			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// ��ǥ��������
//			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// �������
//			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
//			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// ���ұ���=â���̵��԰���
//	
//			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// ��������=�������
//         //iomatrix�� Ÿ���� ������ Y�̸� �԰�ǰ�� Ÿ����ǰ���� ����
////			if stagbn = 'Y' then 
////				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "ditnbr")) // ǰ��
////				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_list.GetItemString(lRow, "dpspec")) // ���
////			else	
//				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "itnbr")) // ǰ��
//				dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // ���
////			end if
//			
//			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// ����â��=�԰�ó
//			
//			select ipjogun into :sSaupj
//			  from vndmst where cvcod = :sCvcod;  // �԰� â���� �ΰ� ����� ������
//			
//			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
//			
//			
//			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// �ŷ�óâ��=���â��
//			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// �����ڵ�
//		
//			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		
//
//			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
//			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // ����������
//			
//			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
//			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_list.GetItemString(lRow, "lotsno"))
//			// ���ҽ��ο��δ� �ش� â���� ���ο��θ� �������� �Ѵ�
//			// �� ������ ����� �ƴ� ���� �ڵ�����'Y'���� ����
//			Setnull(sSaleyn)
//			SELECT HOMEPAGE
//			  INTO :sSaleYN
//			  FROM VNDMST
//			 WHERE CVCOD = :sCvcod ;	
//
//			IF isnull(sSaleyn) or trim(ssaleyn) = '' then
//				Ssaleyn = 'N'
//			end if
//			
//			//////////////////////////////////////////////////////////////////////////////////////////////////////	
//			sItnbr  = dw_list.GetItemString(lRow, "itnbr")
//			sStock  = dw_list.GetItemString(lRow, "itemas_filsk") // ����������
//			sGrpno = dw_list.GetItemString(lRow, "grpno2")
//
//			if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then	sStock = 'Y'
//				
//			// ���԰˻� �Ƿ��̸鼭 �԰��� �˻�ǰ�� ���
//			IF sInsQc = 'Y' and sGrpno = 'Y'	THEN			
//				SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
//				  INTO :sgubun,  :sempno    
//				  FROM "ITEMAS"  
//				 WHERE "ITEMAS"."ITNBR" = :sItnbr ;
//				
//				if sgubun = '' or isnull(sgubun) then		sGubun = '1'
//								
//				// ������ ���� ���� ��� : ���˻�, �˻����� ����				
//				IF sStock = 'N'	THEN sGubun = '1'
//				
//				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sGubun) // ���˻�
//				dw_imHist_in.SetItem(lRowHist_in, "gurdat",	sdate)  // �˻��Ƿ�����
//				
//				if sgubun = '1' then //���˻��� ���
//					dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
//					dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// �˻�����=�������
//				else
//					if sempno = '' or isnull(sempno) then
//						dw_imHist_in.SetItem(lRowHist_in, "insemp",	scustom) // �⺻�˻� �����
//					else
//						dw_imHist_in.SetItem(lRowHist_in, "insemp",	sempno)
//					end if
//					dw_imHist_in.SetItem(lRowHist_in, "insdat",	sNull)			// �˻�����
//				end if
//			Else
//				sgubun = '1'
//				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun) // ���˻�
//				dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
//				dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)
//			End If
//			//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//			// ���˻��̸� �ڵ������� ��� ���γ��� ����
//			IF sgubun = '1' And sSaleYn = 'Y' then
//				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_list.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=�԰����
//				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
//				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
//				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// ���ҽ��ο���
//			ELSE
//				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// ���ҽ��ο���
//
//			End If
//			
//			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// ���������
//			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
//
////			dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_list.GetItemString(lRow, "holdstock_req_dept"))		// �����Ƿںμ�=�Ҵ�.�μ�
//			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
//			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // �԰���ǥ��ȣ=����ȣ
//			
//			dw_imHist_in.SetItem(lRowHist_in, "cust_no",    dw_list.GetItemString(lRow, "cust_no"))
//		END IF
//	END IF
//NEXT
//
//arg_sJpno = sJpno
//
//RETURN 1
end function

public function integer wf_imhist_delete ();return 1
/////////////////////////////////////////////////////////////////////////
////
////	1. �����HISTORY ����
////
/////////////////////////////////////////////////////////////////////////
//
//dec		dOutQty, dNotOutQty, dTempQty
//string	sHist_Jpno, sIodate, sDelgub, syebi5
//long		lRow, lRowCount, i, k
//
//lRowCount = dw_list.RowCount()
//
//FOR lrow = 1 TO lRowCount
//	 sHist_Jpno = dw_list.GetItemString(lrow, "imhist_iojpno")
//	 sIoDate    = dw_list.GetItemString(lrow, "cndate")
//	 sDelgub    = dw_list.GetItemString(lrow, "opt")
//
//   if sDelgub = 'N' then continue
//
//	k ++	
//	
////	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
////	if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
////	   dw_list.GetItemString(lRow, "i_confirm") = 'N' then continue
//
////	if not isnull(dw_list.GetItemString(lRow, "yebi5")) then continue
//		
//   DELETE FROM "IMHIST"  
//	 WHERE "IMHIST"."SABU" = :gs_sabu
//	   and "IMHIST"."IOJPNO" = :sHist_Jpno   ;
//	  
//	IF SQLCA.SQLNROWS < 1	THEN
//		ROLLBACK;
//		f_Rollback();
//		RETURN -1
//	END IF			  
//	  
//   DELETE FROM "IMHIST"  
//	 WHERE "IMHIST"."SABU"    = :gs_sabu
//	   and "IMHIST"."IP_JPNO" = :sHist_Jpno   
//	   AND "IMHIST"."JNPCRT"  = '011';
//
//	IF SQLCA.SQLCODE < 0	THEN
//		ROLLBACK;
//		f_Rollback();
//		RETURN -1
//	END IF			  
//		
//	i ++	
//Next
//////////////////////////////////////////////////////////////////////////
//
//if k < 1 then 
//	messagebox("Ȯ ��", "�����ڷḦ ���� �� ���� �Ͻʽÿ�!")
//	return -1						  
//end if
//
////if i < 1 then 
////	messagebox("Ȯ ��", "�԰��ڷᰡ ����ó�� �Ǿ� �����Ƿ�  ���� �� �� �����ϴ�." + &
////	                    '~n' + "�԰� �ڷḦ Ȯ���ϼ���!")
////	return -1						  
////elseif	k <> i then 
////	messagebox("Ȯ ��", "�԰��ڷᰡ �Ϻ� ����ó�� �Ǿ� �����Ƿ� �Ϻθ� ���� �Ǿ����ϴ�." + &
////	                    '~n' + "�԰� �ڷḦ Ȯ���ϼ���!")
////end if	
//
//RETURN 1
end function

public function integer wf_imhist_update ();return 1
////////////////////////////////////////////////////////////////////
////
////		* �������
////		1. �����history -> ������ update (�������� ������ ��쿡��)
////		2. �������� + ������ = ��û���� -> �Ͱ�Ϸ�('Y')
////	
////////////////////////////////////////////////////////////////////
//string	sHist_Jpno, sGubun, siodate, sioyn
//dec		dOutQty, dTemp_OutQty
//long		lRow, i, k, lCount
//
//lcount = dw_list.RowCount()
//
//FOR	lRow = 1		TO	lcount
//
//   k++
//	
//	dOutQty      = dw_list.GetItemDecimal(lRow, "outqty")			// ������(�����history)
//	dTemp_OutQty = dw_list.GetItemDecimal(lRow, "temp_outqty")	// ������(�����history)
//	sHist_Jpno   = dw_list.GetItemString(lRow, "imhist_iojpno")
//	sGubun		 = dw_list.GetItemString(lRow, "imhist_outchk")
//	
//	siodate = dw_list.GetItemString(lRow, "cndate")
//	sioyn   = dw_list.GetItemString(lRow, "i_confirm")
//	
//	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
//	if (not isnull(siodate)) AND sioyn = 'N' then continue
//	
//	IF dOutQty <> dTemp_OutQty		THEN
//
//		  UPDATE "IMHIST"  
//     		  SET "IOQTY"   = :dOutQty,   
//         		"IOREQTY" = :dOutQty,   
//         		"IOSUQTY" = :dOutQty,   
//         		"OUTCHK" = :sGubun,  
//					"UPD_USER" = :gs_userid    
//   		WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
//         		( "IMHIST"."IOJPNO" = :sHist_Jpno )   ;
//
//		IF SQLCA.SQLNROWS <> 1	THEN
//			ROLLBACK;
//			f_Rollback();
//			RETURN -1
//		END IF
//		
//		//�ڵ��� ��� �԰�������� ���� ����
//		IF sioyn = 'Y' and (not isnull(sIodate)) then 
//		   UPDATE "IMHIST"  
//			   SET "IOQTY"   = :dOutQty,   
//					 "IOREQTY" = :dOutQty,   
//					 "IOSUQTY" = :dOutQty,  
//					 "UPD_USER" = :gs_userid  
//			 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
//					 ( "IMHIST"."IP_JPNO" = :sHist_Jpno )   AND
//					 ( "IMHIST"."JNPCRT" = '011' ) ;		
//		ELSE
//		   UPDATE "IMHIST"  
//			   SET "IOREQTY" = :dOutQty,   
//					 "IOSUQTY" = :dOutQty,  
// 					 "UPD_USER" = :gs_userid  
//			 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
//					 ( "IMHIST"."IP_JPNO" = :sHist_Jpno )   AND
//					 ( "IMHIST"."JNPCRT" = '011' ) ;		
//		END IF
//		
//		IF SQLCA.SQLCODE < 0	THEN
//			ROLLBACK;
//			f_Rollback();
//			RETURN -1
//		END IF
//	END IF
//   i++
//NEXT
//
//if i < 1 then 
//	messagebox("Ȯ ��", "�԰��ڷᰡ ����ó�� �Ǿ� �����Ƿ� ���� �� �� �����ϴ�." + &
//	                    'N' + "�԰� �ڷḦ Ȯ���ϼ���!")
//	return -1						  
//elseif	k <> i then 
//	messagebox("Ȯ ��", "�԰��ڷᰡ �Ϻ� ����ó�� �Ǿ� �����Ƿ� �Ϻθ� ���� �Ǿ����ϴ�." + &
//	                    'N' + "�԰� �ڷḦ Ȯ���ϼ���!")
//end if	
//
//RETURN 1
end function

public function integer wf_itemchk (string as_cvcod);Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return -1

Long   i
Long   ll_chk
String ls_itnbr

For i = 1 To ll_cnt
	ls_itnbr = dw_insert.GetItemString(i, 'itnbr')
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM VNDDAN
	 WHERE CVCOD = :as_cvcod
	   AND ITNBR = :ls_itnbr ;
	If ll_chk < 1 OR IsNull(ll_chk) Then
		MessageBox('�ŷ�ó Ȯ��', '�ش� �ŷ�ó�� ǰ���� �ƴմϴ�.')
		Return -1
	End If
	
Next

Return 0

end function

public function integer wf_balju_cnt (string arg_yymmdd, string arg_date, string arg_cvcod, string arg_itnbr);integer	lcnt

select count(*) into :lcnt from pomast a, poblkt b
 where a.sabu = :gs_sabu and a.cvcod = :arg_cvcod and a.balgu = '3' and a.docno = :arg_yymmdd
	and a.sabu = b.sabu and a.baljpno = b.baljpno and b.nadat = :arg_date
	and b.itnbr = :arg_itnbr and b.balsts <> '4' ;

return lcnt
end function

public function integer wf_bal_delete (string as_saupj, string as_yymmdd, string as_cvcod, string as_itnbr, string as_baljpno);//
DELETE FROM POMAST
 WHERE BALJPNO = :as_baljpno ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	Return -1
End If

DELETE FROM POBLKT
 WHERE BALJPNO = :as_baljpno ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	Return -1
End If

UPDATE PU03_WEEKPLAN
	SET BALJPNO = NULL, WEBCNF = NULL
 WHERE SABU   = :as_saupj
	AND YYMMDD = :as_yymmdd
	AND WAIGB  = '2'
	AND CVCOD  = :as_cvcod
	AND ITNBR  = :as_itnbr ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	Return -1
End If

COMMIT USING SQLCA;

Return 0

end function

on w_imt_02045.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.dw_hidden=create dw_hidden
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_1=create cb_1
this.dw_hidden2=create dw_hidden2
this.dw_imhist=create dw_imhist
this.cb_2=create cb_2
this.dw_hidden3=create dw_hidden3
this.cb_3=create cb_3
this.dw_hidden4=create dw_hidden4
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_hidden
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_hidden2
this.Control[iCurrent+8]=this.dw_imhist
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.dw_hidden3
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.dw_hidden4
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
end on

on w_imt_02045.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.dw_hidden)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_1)
destroy(this.dw_hidden2)
destroy(this.dw_imhist)
destroy(this.cb_2)
destroy(this.dw_hidden3)
destroy(this.cb_3)
destroy(this.dw_hidden4)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent('ue_open')
end event

event key;call super::key;// Page Up & Page Down & Home & End Key ��� ����
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
// ���ִ��� ��뿡 ���� ȭ�� ����
sTring sCnvgu, sCnvart

/* �����Ƿ� -> ����Ȯ�� �����ڸ� ȯ�漳������ �˻��� */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '4';
If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
End if
is_cnvart = sCnvart

/* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

is_gubun = sCnvgu

IF ScNVGU = 'Y' THEN
	dw_insert.dataobject = 'd_imt_02045_1_1'
else
	dw_insert.dataobject = 'd_imt_02045_1'
end if

dw_1.SetTransObject(Sqlca)
dw_imhist.SetTransObject(Sqlca)
dw_insert.SetTransObject(Sqlca)

// ���ڰ��� ��������(���ְ���)
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_gwgbn
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'W' ) AND  
		 ( "SYSCNFG"."SERIAL" = 1 ) AND  
		 ( "SYSCNFG"."LINENO" = '31' );
If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server ����
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
		MessageBox('Ȯ ��','�׷���� ������ �� �� �����ϴ�.!!')
		is_gwgbn = 'N'
	End If
End If

wf_reset()
end event

event closequery;call super::closequery;// �׷���� �������� ����
If is_gwgbn = 'Y' Then
	disconnect	using	sqlca1 ;
	destroy	sqlca1
End If
end event

type dw_insert from w_inherite`dw_insert within w_imt_02045
integer x = 37
integer y = 484
integer width = 4567
integer height = 1784
integer taborder = 20
string dataobject = "d_imt_02045_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;String sData, sPrvdata, sNull, sName, sItem, sSpec, scvnas, stuncu, saccod, &
       sjijil, sispec_code, sProject, scode, scvcod, get_nm, get_nm2 , sDate, sDepot
Decimal {5} dPrvdata, dData, dunprc, dunqty, dJego
Long lrow
Integer ireturn
String	ls_pspec, sItgu, sIttyp

Lrow = this.getrow()

Setnull(sNull)

// �԰�â��
sDepot = Trim(dw_1.GetItemString(1, 'ipdpt'))

IF 	this.GetColumnName() = "itnbr"	THEN
	sitem = trim(this.GetText())

	//����ó
	scvcod = dw_1.GetItemString(1, 'cvcod')
	If Trim(scvcod) = '' OR IsNull(scvcod) Then
		MessageBox('����ó Ȯ��', '����ó�� �ʼ� �Է� �Դϴ�.')
		Return
	End If
	
	Long ll_cnt
	SELECT COUNT('X')
	  INTO :ll_cnt
	  FROM DANMST
	 WHERE ITNBR = :sitem
	   AND CVCOD = :scvcod
		AND OPSEQ = '9999' ;
	If ll_cnt < 1 Then
		MessageBox('�ܰ� �� ��� ǰ��', '�ش� ǰ���� ����/���� �ܰ��� ��� ���� �ʾҽ��ϴ�.')
		This.SetItem(Lrow, 'itnbr', '')
		Return 1
	End If

	ls_pspec = this.Getitemstring(Lrow, "pspec")
	
//	ireturn = f_get_name6('ǰ��', 'Y', sitEM, sname, sspec, sJijil, sispec_code) 
	ireturn = f_get_name4('ǰ��', 'Y', sitEM, sname, sspec, sJijil, sispec_code) 
	
//	// ��ű�� ����
//	SELECT ITTYP INTO :sittyp FROM ITEMAS WHERE ITNBR = :sItem AND USEYN = '0';
//	If sIttyp = 'A' Then
//		MessageBox('Ȯ��', '����ǰ�� �Է��Ͻ� �� �����ϴ�.!!')
//		Return 2
//	End If
	
 	ib_changed = true
	is_itnbr   = sitem

	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	
	if isnull(GetItemString(lrow, 'nadat')) or trim(GetItemString(lrow, 'nadat')) = '' then
		this.setitem(lrow, "nadat", dw_1.GetItemString(1, 'baldate'))
	end if
	
//	scvcod 	= dw_1.GetItemString(1,"cvcod")
	
	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)
	this.setitem(Lrow, "unprc", dData)
	
	if isnull(stuncu) or trim(stuncu) = '' then
		this.setitem(Lrow, "poblkt_tuncu", 'WON')
	else
		this.setitem(Lrow, "poblkt_tuncu", stuncu)
	end if
	
	wf_cnvfat(Lrow, sitem)

  	if 	sitem = '' or isnull(sitem) then 
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
	ireturn = f_get_name4('ǰ��', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
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
	ireturn = f_get_name4('�԰�', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
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
	ireturn = f_get_name4('����', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
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
	ireturn = f_get_name4('�԰��ڵ�', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
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
	
/* �԰���â�� */
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
		Messagebox("Ȯ��", "��ȿ�� ���ڸ� �Է��Ͻʽÿ�", stopsign!)
		dw_insert.setitem(lrow, "nadat", snull)
		dw_insert.SetColumn('nadat')
		dw_insert.SetFocus()
		return 1		
	end if	
ELSEif this.getcolumnname() = 'balsts' then
	sPrvdata = this.getitemstring(lrow, 'balsts')
	sData = gettext()
	if sData = '2' then
		f_message_chk(304, '[���ֻ���]')
		setitem(lrow, "balsts", sPrvdata)
		return 1
	end if
ELSEif getcolumnname() = 'balqty' then
	dPrvdata = getitemdecimal(lrow, 'balqty')
	dData = Dec(gettext())
	if dData < getitemdecimal(lrow, "rcqty") or &
	   dData < getitemdecimal(lrow, "lcoqty") then
		f_message_chk(305, '[���ּ���]')
		setitem(lrow, "balqty", dPrvdata)
		return 1
	end if
	if dData < 1 then
		f_message_chk(30, '[���ּ���]')
		setitem(lrow, "balqty", dPrvdata)
		return 1
	end if		
	
	/* �ݾװ�� */
	Setitem(lrow, "unamt", Round(dData * getitemdecimal(Lrow, "unprc"),1))
											 
	// ��ȯ����� ���� ������ȯ
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
	if dData < 0 then
		f_message_chk(30, '[���ִܰ�]')
		setitem(lrow, "unprc", dPrvdata)
		return 1
	end if	
	
	/* �ݾװ�� */
	Setitem(lrow, "unamt", Round(dData * getitemdecimal(Lrow, "balqty"),1))
	
	// ��ȯ����� ���� �ܰ���ȯ
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
/* �ݾ��� �Է��ϴ°�� �ܰ��� ���� �Ѵ� */
ELSEif getcolumnname() = 'unamt' then
	dPrvdata = getitemdecimal(lrow, 'unamt')
	dData = Dec(gettext())
	if dData <= 0 then
		f_message_chk(30, '[���ֱݾ�]')
		setitem(lrow, "unamt", dPrvdata)
		return 1
	end if	
	
	/* �ܰ� ��� */
	dunqty = getitemdecimal(lrow, 'balqty')
	If dunqty > 0 then
		dunprc = round(dData / dunqty,5)
	Else
		dunprc = 0
	End If
	SetItem(lrow, 'unprc', dunprc)
	
	// ��ȯ����� ���� �ܰ���ȯ
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
	
   ireturn = f_get_name2('�μ�', 'Y', sitem, sname, sspec )	 
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
		f_message_chk(33, '[������Ʈ ��ȣ]')
		this.setitem(lRow, "project_no", sNull)
	   return 1
	END IF
	
ElseIf This.GetColumnName() = 'yebi1' Then
	String ls_chk, ls_value
	ls_value = Trim(This.GetText())
	
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	  INTO :ls_chk
	  FROM REFFPF
	 WHERE SABU = :gs_sabu AND RFCOD = '2A' AND RFGUB = :ls_value ;
	If ls_chk <> 'Y' Then
		MessageBox('Ȯ��', '��ϵ� ���� �ڵ尡 �ƴմϴ�.')
		This.SetFocus()
		This.SetColumn('yebi1')
		Return 1
	End If
//ELSEIF this.getcolumnname() = "pspec"	then // Maker�� �ܰ� ljj
//	sitem = this.Getitemstring(Lrow, "itnbr")
//
//	ls_pspec = trim(this.GetText())
//	If IsNull(ls_pspec) Or Trim(ls_pspec) = '' Then ls_pspec = '.'
//	
// 	ib_changed = true
//	is_itnbr   = sitem
//	
//	scvcod 	= dw_1.GetItemString(1,"cvcod")
//	
//	f_buy_unprc(sitem, ls_pspec, '9999', scvcod, scvnas, ddata, stuncu)
//	this.setitem(Lrow, "unprc", dData)
//	
//	if isnull(stuncu) or trim(stuncu) = '' then
//		this.setitem(Lrow, "poblkt_tuncu", 'WON')
//	else
//		this.setitem(Lrow, "poblkt_tuncu", stuncu)
//	end if
//	
//	wf_cnvfat(Lrow, sitem)


//	sItem 	= GetItemString(Lrow,'itnbr')	
//	sspec 	= GetText()
//	
//	scvcod 	= dw_1.GetItemString(1,"cvcod")
//	sDate		= dw_1.GetItemString(1,"baldate")
//	
//	If IsNull(sspec) Or Trim(sspec) = '' Then sspec = '.'
//	If 	Not IsNull(sItem) Then	
//		/* ��纰 ���Դܰ�*/
//		SELECT Fun_danmst_danga10(:sDate, :scvcod, :sitem, :sspec) INTO :dData FROM DUAL;
//		this.setitem(Lrow, "unprc", dData)
//		
//		// ��ü���ֿ����ܰ� ����
//		wf_cnvfat(Lrow, sitem)	
//	End If
End if
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Long Lrow
String sitnbr, sIttyp

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lrow = this.getrow()

// ǰ��
IF this.GetColumnName() = 'itnbr' or this.GetColumnName() = 'itemas_itdsc' Or &
   this.GetColumnName() = 'itemas_ispec'  THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

//	// ��ű�� ����
//	SELECT ITTYP INTO :sittyp FROM ITEMAS WHERE ITNBR = :gs_code AND USEYN = '0';
//	If sIttyp = 'A' Then
//		MessageBox('Ȯ��', '����ǰ�� �Է��Ͻ� �� �����ϴ�.!!')
//		Return 2
//	End If
	
	SetColumn("itnbr")
	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
END IF

// �԰�â��
IF this.GetColumnName() = 'poblkt_ipdpt'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"poblkt_ipdpt", gs_code)
	SetItem(lRow,"vndmst_cvnas", gs_codename)

	this.TriggerEvent("itemchanged")
END IF

// ����
IF this.GetColumnName() = 'poblkt_opseq'	THEN

	sItnbr = this.getitemstring(lrow, "itnbr")
	openwithparm(w_routng_popup, sitnbr)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(lRow,"poblkt_opseq",gs_codename)
	SetItem(lRow,"vndmst_cvnas",gs_gubun)
	this.TriggerEvent("itemchanged")

// �μ�
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

event dw_insert::updatestart;/* Update() function ȣ��� user ���� */
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

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(currentrow,true)
Else
	this.SelectRow(0,false)
End If
end event

event dw_insert::clicked;call super::clicked;string snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// ǰ��
IF dwo.name = 'cspec' THEN
//	open(w_itemas_popup)
//	if Isnull(gs_code) or Trim(gs_code) = "" then 
//		this.setitem(row,'cspec',snull)
//		this.setitem(row,'project_no',snull)
//		return
//	end if
//
//	this.setitem(row,'cspec',gs_codename+'  '+gs_gubun)
//	this.setitem(row,'project_no',gs_code)
ElseIf dwo.name = 'itnbr' Then
	//ǰ���� Ŭ���� �ϸ� �������� �ڵ� ��ȯ - by shingoon 2006.12.29
	u_hangle o_hangle
	o_hangle = Create u_hangle
	
	o_hangle.uf_hangul_off(This)
END IF

end event

event dw_insert::getfocus;call super::getfocus;//�������� �ڵ� ��ȯ - by shingoon 2006.12.29
u_hangle o_hangle
o_hangle = Create u_hangle

o_hangle.uf_hangul_off(This)
end event

type p_delrow from w_inherite`p_delrow within w_imt_02045
boolean visible = false
integer x = 800
integer y = 2464
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_imt_02045
boolean visible = false
integer x = 613
integer y = 2452
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_imt_02045
integer x = 4233
integer y = 268
integer width = 306
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\Ư����׵��_d.gif"
end type

event p_search::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[���ֹ�ȣ]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if

open(w_imt_02041)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\Ư����׵��_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\Ư����׵��_up.gif"
end event

type p_ins from w_inherite`p_ins within w_imt_02045
integer x = 3447
integer y = 12
end type

event p_ins::clicked;call super::clicked;Long Lrow, i

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if isnull(dw_1.getitemstring(1, "baldate")) or &
   Trim(dw_1.getitemstring(1, "baldate")) = '' then
	f_message_chk(30, '[��������]')
	dw_1.setcolumn("baldate")
	dw_1.setfocus()
	return
end if

if isnull(dw_1.getitemstring(1, "cvcod")) or &
   Trim(dw_1.getitemstring(1, "cvcod")) = '' then
	f_message_chk(30, '[����ó]')
	dw_1.setcolumn("cvcod")
	dw_1.setfocus()
	return
end if

if isnull(dw_1.getitemstring(1, "bal_empno")) or &
   Trim(dw_1.getitemstring(1, "bal_empno")) = '' then
	f_message_chk(30, '[���ִ����]')
	dw_1.setcolumn("bal_empno")
	dw_1.setfocus()
	return
end if

//////////////////////////////////////////////////////////////////////////////////////////////
string	sSaupj, sIpdpt , ls_plncrt
sSaupj 	= dw_1.GetItemString(1, "saupj")
sIpdpt 	= dw_1.GetItemString(1, "ipdpt")
ls_plncrt	= dw_1.GetItemString(1, "plncrt")

IF 	IsNull(sSaupj)	OR ssaupj = '99'	THEN
	f_message_chk(30, '[�����]')
	dw_1.setcolumn("saupj")
	dw_1.setfocus()
	return
end if

IF 	IsNull(sIpdpt)		THEN
	f_message_chk(30, '[�԰���â��]')
	dw_1.setcolumn("ipdpt")
	dw_1.setfocus()
	return
end if

//////////////////////////////////////////////////////////////////////////////////////////////
//���� �� �ʼ� Ȯ�� - by shingoon 2006.12.27
//FOR 	i = 1 TO dw_insert.RowCount()
//	 	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT

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
if lrow > 1 then 
   dw_insert.setitem(lrow, 'nadat', dw_insert.getitemstring(1, 'nadat'))
   dw_insert.setitem(lrow, 'poblkt_tuncu', dw_insert.getitemstring(1, 'poblkt_tuncu'))
end if

dw_insert.setcolumn("itemas_itdsc")

// �����ڿ� ���� �ڷ� ����
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

type p_exit from w_inherite`p_exit within w_imt_02045
integer y = 12
end type

type p_can from w_inherite`p_can within w_imt_02045
integer y = 12
end type

event p_can::clicked;call super::clicked;/*����庰 ����ڼ���*/
f_child_saupj(dw_1,'bal_empno',gs_Saupj)

/*����庰 â����*/
f_child_saupj(dw_1,'ipdpt',gs_Saupj)

wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02045
integer x = 3621
integer y = 12
integer width = 306
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\����óǰ����_up.gif"
end type

event p_print::clicked;call super::clicked;//����ó ǰ����	-���ϸ�
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot, sempno
int    k, iRow
Decimal {5} ddata, djego

IF dw_1.AcceptText() = -1	THEN	RETURN

ls_Saupj 	= dw_1.GetItemString(1, "saupj")
sCvcod 	   = dw_1.getitemstring(1, "cvcod")
sempno    = dw_1.getitemstring(1, "bal_empno")
sdepot      = dw_1.getitemstring(1, "ipdpt")

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[����ó]')
	dw_1.SetColumn("cvcod")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[���ִ����]')
	dw_1.SetColumn("bal_empno")
	dw_1.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod;

gs_code = sCvcod
//gs_gubun = 'X' // ����ǰ�� ����
open(w_vnditem_popup2)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		iRow = dw_insert.insertrow(0)

		dw_insert.setitem(iRow, "sabu", gs_sabu)
		dw_insert.setitem(iRow, "saupj", ls_saupj)  //-- �����.
		if iRow = 1 then 
			dw_insert.setitem(iRow, "balseq", 1)
		else
			dw_insert.setitem(iRow, "balseq", dw_insert.getitemnumber(iRow - 1, "balseq") + 1 )
		end if
      	sitem = 	dw_hidden.getitemstring(k, 'poblkt_itnbr' )
		dw_insert.setitem(irow, 'itnbr', sitem)
		dw_insert.setitem(irow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(irow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(irow, 'carcode',      dw_hidden.getitemstring(k, 'carcode' ))
		
		f_buy_unprc(sitem, '.' , '9999', scvcod, scvnas, ddata, stuncu)
		dw_insert.setitem(irow, "unprc", ddata)
		
		if isnull(stuncu) or trim(stuncu) = '' then
			dw_insert.setitem(irow, "poblkt_tuncu", 'WON')
		else
			dw_insert.setitem(irow, "poblkt_tuncu", stuncu)
		end if
//		if irow > 1 then 
//			dw_insert.setitem(irow, 'nadat', dw_insert.getitemstring(1, 'nadat'))
//		end if
		
		// �����ڿ� ���� �ڷ� ����
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
		dw_insert.setitem(iRow, "nadat", dw_1.GetItemString(1, 'baldate'))
	end if	
NEXT
dw_hidden.reset()
dw_insert.ScrollToRow(iRow)
dw_insert.setrow(iRow)
dw_insert.SetColumn("balqty")
dw_insert.SetFocus()

ib_any_typing = true
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\����óǰ����_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\����óǰ����_up.gif"
end event

type p_inq from w_inherite`p_inq within w_imt_02045
integer x = 3273
integer y = 12
end type

event p_inq::clicked;call super::clicked;string s_balju, sSaupj
long   lcount

if dw_1.AcceptText() = -1 then return 

s_balju = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(s_balju) or s_balju = "" then
	f_message_chk(30,'[���ֹ�ȣ]')
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

String  ls_emp
String  ls_dpt
ls_emp = dw_1.GetItemString(1, 'bal_empno')
ls_dpt = dw_1.GetItemString(1, 'ipdpt')

// ����� ����
sSaupj = dw_1.GetItemString(1, 'saupj')
//f_child_saupj(dw_1, 'ipdpt', ssaupj)

/*����庰 ����ڼ���*/
f_child_saupj(dw_1,'bal_empno',sSaupj)
/*����庰 â����*/
f_child_saupj(dw_1,'ipdpt',sSaupj)

dw_1.SetItem(1, 'bal_empno', ls_emp)
dw_1.SetItem(1, 'ipdpt', ls_dpt)

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

p_search.PictureName = "C:\erpman\image\Ư����׵��_up.gif"
p_print.PictureName = "C:\erpman\image\����óǰ����_d.gif"

end event

type p_del from w_inherite`p_del within w_imt_02045
integer y = 12
end type

event p_del::clicked;call super::clicked;Long Lrow, irow, irow2, i
String sBaljpno, sEono, sEodate

Lrow = dw_insert.getrow()

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

If dw_insert.getitemdecimal(Lrow, "rcqty")  > 0 or &
   dw_insert.getitemdecimal(Lrow, "lcoqty") > 0 then
	Messagebox("����", "�̹� ����� �ڷ��Դϴ�", stopsign!)
	return
End if

String ls_bal
ls_bal = dw_insert.GetItemString(Lrow, 'baljpno')
Long   ll_seq, ll_cnt
ll_seq = dw_insert.GetItemNumber(Lrow, 'balseq' )
SELECT COUNT('X')
  INTO :ll_cnt
  FROM POBLKT_HIST
 WHERE BALJPNO = :ls_bal
   AND BALSEQ  = :ll_seq ;
If ll_cnt > 0 Then
	MessageBox('���ó�� �ڷ� [SCM]', '�ش� ���� ���� �̹� ���ó�� �Ǿ����ϴ�.~r~n���ó�� ��� �� ���� ���� �մϴ�!')
	Return
End If

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
		if MessageBox("�� ��","���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) <> 1 then return
	else
		if MessageBox("�� ��", "������ �ڷḦ �����Ͻø� ���ֿ� ��� �ڷᰡ �����˴ϴ�. ~n~n" + &
							  "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) <> 1 then return
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
				messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
				wf_reset()
				dw_insert.SetRedraw(TRUE)
				return 
			end if	
			commit ;
			wf_reset()
			sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
			ib_any_typing = false
			dw_insert.SetRedraw(TRUE)
			return 
		end if	
		sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
		wf_reset()
	end if	
	
	dw_insert.SetRedraw(TRUE)
else
	dw_insert.DeleteRow(Lrow)
end if
end event

type p_mod from w_inherite`p_mod within w_imt_02045
integer y = 12
end type

event p_mod::clicked;call super::clicked;string sdate, sBaljpno, get_nm, ls_rdptno
string seono,seodate
Int i, dseq, li_row
long lins

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

ls_rdptno = dw_1.getItemString(1,'rdptno')

If ls_rdptno = '' or IsNull(ls_rdptno) Then
	f_message_chk(30, '[ �����Ƿ� �μ� ]')
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
	f_message_chk(30, '[��������]')
	dw_1.setcolumn("baldate")
	dw_1.setfocus()
	return
end if

if 	isnull(dw_1.getitemstring(1, "cvcod")) or &
   	Trim(dw_1.getitemstring(1, "cvcod")) = '' then
	f_message_chk(30, '[����ó]')
	dw_1.setcolumn("cvcod")
	dw_1.setfocus()
	return
end if

/* �Ϲݻ��� check */
if ic_status = '1' then 
	if cbx_1.checked = false then 
 		sBaljpno = trim(dw_1.getitemstring(1, "baljpno"))
		if isnull(sbaljpno) or sBaljpno = '' then
			f_message_chk(30, '[���ֹ�ȣ]')
			dw_1.setcolumn("baljpno")
			dw_1.setfocus()
			return
		end if
	else
		sDate  = trim(dw_1.GetItemString(1, "baldate"))				// ��������
		
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
	f_message_chk(30, '[�����]')
	dw_1.setcolumn("saupj")
	dw_1.setfocus()
	return
end if

IF 	IsNull(sIpdpt)		THEN
	f_message_chk(30, '[�԰���â��]')
	dw_1.setcolumn("ipdpt")
	dw_1.setfocus()
	return
end if

String  ls_ckd
String  ls_ordno
FOR i = 1 TO dw_insert.RowCount()
	
	dRcqty = dw_insert.GetItemDecimal(i, "rcqty")
	dLcqty = dw_insert.GetItemDecimal(i, "lcoqty")
	
	IF dRcqty > 0  or  dLcqty > 0		THEN
	ELSE
		dw_insert.SetItem(i, "saupj", sSaupj)
 		dw_insert.SetItem(i, "poblkt_ipdpt", sIpdpt)
	END IF
	
	/* CKD���ָ� SCM���� ���� ��� CKD�� OEM���� �������� ���� - BY SHINGOON 2013.12.04 */
	/* SCM���ó������ ORDER_NO�� NULL�̸� OEM����, NULL�� �ƴϸ� CKD���ַ� ������ */
	ls_ckd = dw_insert.GetItemString(i, 'poblkt_estgu')
	If ls_ckd = 'C' Then
		ls_ordno = dw_insert.GetItemString(i, 'poblkt_bigo')
		dw_insert.SetItem(i, 'poblkt_order_no', ls_ordno)
	End If
	/************************************************************************************/
	IF wf_required_chk(i) = -1 THEN RETURN
	
NEXT
//////////////////////////////////////////////////////////////////////////////////
if f_msg_update() = -1 then return

sBaljpno = trim(dw_1.getitemstring(1, "baljpno"))
FOR i = 1 TO dw_insert.RowCount()
	dw_insert.setitem(i, "baljpno", sBaljpno)
NEXT

// �����Ƿ� ������
//IF is_gwgbn = 'Y' then
//	wf_create_gwdoc()
//End If

if dw_1.update() = 1 then
	if dw_insert.update() = 1 then
		// ������ ���ֻ��ó�� - 2007.02.05 - �ۺ�ȣ(����)
//		IF wf_imhist_create(sArg_sdate) = -1 THEN
//			ROLLBACK;
//			RETURN
//		END IF
		messagebox("����Ϸ�", "�ڷᰡ ����Ǿ����ϴ�!!")
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
		return 
   end if	
else
	rollback ;
	messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
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

type cb_exit from w_inherite`cb_exit within w_imt_02045
end type

type cb_mod from w_inherite`cb_mod within w_imt_02045
end type

type cb_ins from w_inherite`cb_ins within w_imt_02045
end type

type cb_del from w_inherite`cb_del within w_imt_02045
end type

type cb_inq from w_inherite`cb_inq within w_imt_02045
end type

type cb_print from w_inherite`cb_print within w_imt_02045
end type

type st_1 from w_inherite`st_1 within w_imt_02045
integer x = 23
end type

type cb_can from w_inherite`cb_can within w_imt_02045
end type

type cb_search from w_inherite`cb_search within w_imt_02045
integer x = 2130
integer y = 0
integer width = 91
integer height = 168
integer taborder = 100
boolean enabled = false
string text = "Ư����׵��"
end type

type dw_datetime from w_inherite`dw_datetime within w_imt_02045
integer x = 2866
end type

type sle_msg from w_inherite`sle_msg within w_imt_02045
integer x = 375
end type



type gb_button1 from w_inherite`gb_button1 within w_imt_02045
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02045
end type

type dw_1 from datawindow within w_imt_02045
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 168
integer width = 4142
integer height = 288
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02045_a"
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
         ( "POMAST"."BALJPNO" = :sbaljno )   ;

	IF SQLCA.SQLCODE = 0 then 
		IF get_nm = '2' then 
			p_inq.PostEvent(Clicked!)
//			Post wf_ret_head(sbaljno)			
		ELSE
			MessageBox("Ȯ ��", "���� ���ֿ��� ��ϵ� ���ְ� �ƴմϴ�. ���ֹ�ȣ�� Ȯ���ϼ���.!")
			wf_reset()
			RETURN 1
		END IF
	END IF
ELSEIF	this.getcolumnname() = "baldate"		THEN
   s_date = trim(this.gettext())
	
	if s_date = '' or isnull(s_date) then return 
	
	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[��������]')
		this.setitem(1, "baldate", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "plnopn"		THEN
   s_date = trim(this.gettext())
	
	if s_date = '' or isnull(s_date) then return 
	
	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[L/C OPEN ��ȹ��]')
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
//		f_message_chk(33,'[���ִ����]')
//		this.SetItem(1,'bal_empno', snull)
//		return 1
//   end if	
ELSEIF this.GetColumnName() = "cvcod" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod", s_empno)	
	this.setitem(1, "vndmst_cvnas2", get_nm)
	
	//�ش� �ŷ�ó ǰ��Ȯ�� - 2007.10.18 by shingoon
	If dw_insert.Rowcount() > 0 Then
		If wf_itemchk(s_empno) < 0 Then
			This.SetItem(1, 'cvcod', '')
			This.SetItem(1, 'vndmst_cvnas2', '')
			Return 2
		End If
	End If
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "bal_suip" THEN
	s_empno = this.GetText()
   if s_empno = '1' then 
		this.setitem(1, "plnbnk", snull)	
		this.setitem(1, "plnopn", snull)	
	end if	
ElseIf this.GetColumnName() = 'rdptno' THEN
	s_empno = this.gettext()
   ireturn = f_get_name2('�μ�', 'Y', s_empno, get_nm, s_name )	 
	this.setitem(1, "rdptno", s_empno)
	this.setitem(1, "dptnm", get_nm)
	
	FOR li_row = 1 to dw_insert.RowCount()
      dw_insert.SetItem(li_row, 'rdptno',s_empno )
	NEXT
	
	RETURN ireturn
ElseIf GetColumnName() = 'saupj' THEN
	s_date = GetText()
	/*����庰 ����ڼ���*/
	f_child_saupj(dw_1,'bal_empno',s_date)

	/*����庰 â����*/
	f_child_saupj(dw_1,'ipdpt',s_date)
	
	
	SetItem(1,"bal_empno",snull)
	SetItem(1,"ipdpt",snull)
ElseIf GetColumnName() = 'balgu' THEN
//	If GetText() = '3' Then
//		MessageBox('Ȯ ��','���ִ� �����Ͻ� �� �����ϴ�')
//		Return 2
//	End If
END IF	

end event

event itemerror;return 1
end event

event rbuttondown;String sNull

setnull(gs_code); setnull(gs_gubun); setnull(gs_codename); setnull(snull)

IF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //�������û��� => 1:�Ƿ�
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
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:����,4:�μ�,5:â��   
      f_message_chk(70, '[����ó]')
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

type cbx_1 from checkbox within w_imt_02045
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
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "�ڵ�ä��"
boolean checked = true
end type

type dw_hidden from datawindow within w_imt_02045
boolean visible = false
integer x = 9
integer y = 8
integer width = 325
integer height = 168
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_imt_02045
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

type pb_2 from u_pb_cal within w_imt_02045
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

type cb_1 from commandbutton within w_imt_02045
integer x = 2779
integer y = 16
integer width = 485
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "HyperLink!"
string text = "�������� ����"
end type

event clicked;//����ó ǰ����	-���ϸ�
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot, sempno, sEcoil, sEspec, sIojpno
int    k, iRow
Decimal {5} ddata, djego
decimal	dcoilprc

IF dw_1.AcceptText() = -1	THEN	RETURN

ls_Saupj 	= dw_1.GetItemString(1, "saupj")
sCvcod 	   = dw_1.getitemstring(1, "cvcod")
sempno    = dw_1.getitemstring(1, "bal_empno")
sdepot      = dw_1.getitemstring(1, "ipdpt")

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[����ó]')
	dw_1.SetColumn("cvcod")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[���ִ����]')
	dw_1.SetColumn("bal_empno")
	dw_1.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod;

gs_code = sCvcod
open(w_imt_02045_coil_pop)
if Isnull(gs_code) or Trim(gs_code) = "" then return

sEcoil = gs_code
sEspec = gs_codename
sIojpno = gs_codename2
dcoilprc= Dec(gs_gubun)		// �����ϴܰ�

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

SetPointer(HourGlass!)

dw_hidden2.reset()
dw_hidden2.ImportClipboard()

FOR k=1 TO dw_hidden2.rowcount()
	sopt = dw_hidden2.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		iRow = dw_insert.insertrow(0)

		dw_insert.setitem(iRow, "sabu", gs_sabu)
		dw_insert.setitem(iRow, "saupj", ls_saupj)  //-- �����.
		if iRow = 1 then 
			dw_insert.setitem(iRow, "balseq", 1)
		else
			dw_insert.setitem(iRow, "balseq", dw_insert.getitemnumber(iRow - 1, "balseq") + 1 )
		end if
      	sitem = 	dw_hidden2.getitemstring(k, 'poblkt_itnbr' )
		dw_insert.setitem(irow, 'itnbr', sitem)
		dw_insert.setitem(irow, 'itemas_itdsc', dw_hidden2.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(irow, 'itemas_ispec', dw_hidden2.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(irow, 'balqty',      dw_hidden2.getitemnumber(k, 'balqty' ))
		
		f_buy_unprc(sitem, '.' , '9999', scvcod, scvnas, ddata, stuncu)
		dw_insert.setitem(irow, "unprc", ddata)
		dw_insert.setitem(irow, "unamt", ddata * dw_hidden2.getitemnumber(k, 'balqty' ))
		
		if isnull(stuncu) or trim(stuncu) = '' then
			dw_insert.setitem(irow, "poblkt_tuncu", 'WON')
		else
			dw_insert.setitem(irow, "poblkt_tuncu", stuncu)
		end if
//		if irow > 1 then 
//			dw_insert.setitem(irow, 'nadat', dw_insert.getitemstring(1, 'nadat'))
//		end if
		
		// �����ڿ� ���� �ڷ� ����
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
		dw_insert.setitem(iRow, "nadat", dw_1.GetItemString(1, 'baldate'))

		dw_insert.setitem(iRow, "gu_pordno", sIojpno)
		dw_insert.setitem(iRow, "dyebi1", dcoilprc)		// �����ϴܰ� ����
		dw_insert.setitem(iRow, "project_no", sEcoil)
		dw_insert.setitem(iRow, "cspec", sEspec)
	end if	
NEXT
dw_hidden2.reset()
dw_insert.ScrollToRow(iRow)
dw_insert.setrow(iRow)
dw_insert.SetColumn("balqty")
dw_insert.SetFocus()

ib_any_typing = true
end event

type dw_hidden2 from datawindow within w_imt_02045
boolean visible = false
integer x = 361
integer y = 8
integer width = 325
integer height = 168
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_imt_02045_coil_pop2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_imt_02045
boolean visible = false
integer x = 471
integer y = 52
integer width = 773
integer height = 144
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Lot Size�� �԰��� �ۼ�"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event updatestart;/* Update() function ȣ��� user ���� */
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

type cb_2 from commandbutton within w_imt_02045
integer x = 2290
integer y = 16
integer width = 485
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "HyperLink!"
string text = "CKD ���� ����"
end type

event clicked;//����ó ǰ����	-���ϸ�
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot, sempno
string sEcoil, sEspec, sIojpno, sOrdate, sOrdno
int    k, iRow
Decimal {5} ddata, djego
LONG	 lfind

IF dw_1.AcceptText() = -1	THEN	RETURN

ls_Saupj = dw_1.GetItemString(1, "saupj")
sCvcod 	= dw_1.getitemstring(1, "cvcod")
sempno   = dw_1.getitemstring(1, "bal_empno")
sdepot   = dw_1.getitemstring(1, "ipdpt")

//IF isnull(sCvcod) or sCvcod = "" 	THEN
//	f_message_chk(30,'[����ó]')
//	dw_1.SetColumn("cvcod")
//	dw_1.SetFocus()
//	RETURN
//END IF

IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[���ִ����]')
	dw_1.SetColumn("bal_empno")
	dw_1.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod;

gs_code = sCvcod
open(w_imt_02045_ckd_pop)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden3.reset()
dw_hidden3.ImportClipboard()

FOR k=1 TO dw_hidden3.rowcount()
	sopt = dw_hidden3.getitemstring(k, 'opt')
	if sopt = 'Y' then 
		sOrdno = dw_hidden3.getitemstring(k, 'orderno')
		lfind = dw_insert.Find("poblkt_order_no='"+sOrdno+"'", 1, dw_insert.rowcount())
		if lfind > 0 then Continue
		
		iRow = dw_insert.insertrow(0)

		dw_insert.setitem(iRow, "sabu", gs_sabu)
		dw_insert.setitem(iRow, "saupj", ls_saupj)  //-- �����.
		if iRow = 1 then 
			dw_insert.setitem(iRow, "balseq", 1)
		else
			dw_insert.setitem(iRow, "balseq", dw_insert.getitemnumber(iRow - 1, "balseq") + 1 )
		end if
      sitem = 	dw_hidden3.getitemstring(k, 'itnbr' )
		dw_insert.setitem(irow, 'itnbr', sitem)
		dw_insert.setitem(irow, 'itemas_itdsc', dw_hidden3.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(irow, 'itemas_ispec', dw_hidden3.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(irow, 'poblkt_order_no',  sOrdno)
		dw_insert.setitem(irow, 'poblkt_bigo',  sOrdno)
		dw_insert.setitem(irow, 'balqty',      dw_hidden3.getitemnumber(k, 'order_qty' ))
		dw_insert.setitem(irow, 'yebi1',      dw_hidden3.getitemstring(k, 'factory' ))
		
		f_buy_unprc(sitem, '.' , '9999', scvcod, scvnas, ddata, stuncu)
		dw_insert.setitem(irow, "unprc", ddata)
		dw_insert.setitem(irow, "unamt", Truncate(Round(ddata * dw_hidden3.getitemnumber(k, 'order_qty' ), 2),0))
		
		if isnull(stuncu) or trim(stuncu) = '' then
			dw_insert.setitem(irow, "poblkt_tuncu", 'WON')
		else
			dw_insert.setitem(irow, "poblkt_tuncu", stuncu)
		end if
//		if irow > 1 then 
//			dw_insert.setitem(irow, 'nadat', dw_insert.getitemstring(1, 'nadat'))
//		end if
		
		// �����ڿ� ���� �ڷ� ����
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
		
		/* CKD������ �䱸���⿡ ���� ������ �䱸����� -2 �� */
		/* CKD������ �䱸���⿡ ���� ������ �䱸����� 0 �Ϸ� ����(����ȣ����) - BY SHINGOON 2009.05.25 */
		/* CKD������ �䱸���⿡ ���� ������ �䱸����� -3 �Ϸ� ����(������,����ȣ) - BY SHJONE 2011.01.28 */
		/* CKD������ �䱸���⿡ ���� ������ �䱸����� 0 �Ϸ� ����(��ȫ������) - BY SHINGOON 2013.12.04 */
		sOrdate = dw_hidden3.GetItemString(k, 'order_date')
		/*dw_insert.setitem(iRow, "nadat", f_afterday(sOrdate, -2))*/
		/*dw_insert.setitem(iRow, "nadat", f_afterday(sOrdate, 0))*/
		/*dw_insert.setitem(iRow, "nadat", f_afterday(sOrdate, -3))*/
		dw_insert.setitem(iRow, "nadat", f_afterday(sOrdate, 0))
		
		dw_insert.setitem(iRow, "poblkt_estgu", 'C') //ckd���ֿ� ������ �߰� - by shingoon 2009.12.01

	end if	
NEXT
dw_hidden3.reset()
dw_insert.ScrollToRow(iRow)
dw_insert.setrow(iRow)
dw_insert.SetColumn("balqty")
dw_insert.SetFocus()

ib_any_typing = true
end event

type dw_hidden3 from datawindow within w_imt_02045
boolean visible = false
integer x = 722
integer y = 8
integer width = 325
integer height = 168
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_imt_02045_ckd_pop2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_imt_02045
integer x = 1801
integer y = 16
integer width = 485
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "HyperLink!"
string text = "����ǰ�� ����"
end type

event clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_saupj
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('����� Ȯ��', '������� Ȯ�� �Ͻʽÿ�.')
	Return
End If

String ls_baldate
ls_baldate = dw_1.GetItemString(row, 'baldate')
If Trim(ls_baldate) = '' OR IsNull(ls_baldate) Then
	MessageBox('�������� Ȯ��', '�������ڸ� Ȯ�� �Ͻʽÿ�.')
	dw_1.SetColumn('baldate')
	dw_1.SetFocus()
	Return
End If

String ls_balemp
ls_balemp = dw_1.GetItemString(row, 'bal_empno')
If Trim(ls_balemp) = '' OR IsNull(ls_balemp) Then
	MessageBox('���ִ���� Ȯ��', '���� ����ڸ� �Է� �Ͻʽÿ�.')
	dw_1.SetColumn('bal_empno')
	dw_1.SetFocus()
	Return
End If

String ls_cvcod
ls_cvcod = dw_1.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('����ó Ȯ��', '����ó�� Ȯ�� �Ͻʽÿ�.')
	dw_1.SetColumn('cvcod')
	dw_1.SetFocus()
	Return 
End If

String ls_ipdpt
ls_ipdpt = dw_1.GetItemString(row, 'ipdpt')
If Trim(ls_ipdpt) = '' OR IsNull(ls_ipdpt) Then
	MessageBox('�԰�â�� Ȯ��', '�԰�â�� Ȯ�� �Ͻʽÿ�.')
	dw_1.SetColumn('ipdpt')
	dw_1.SetFocus()
	Return
End If

String ls_rdpt
ls_rdpt = dw_1.GetItemString(row, 'rdptno')
If Trim(ls_rdpt) = '' OR IsNull(ls_rdpt) Then ls_rdpt = gs_dept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

gs_code     = ls_cvcod
gs_codename = dw_1.GetItemString(row, 'vndmst_cvnas2')

Open(w_imt_02045_plan_pop)

If Trim(gs_gubun) = '' OR IsNull(gs_gubun) Then
	MessageBox('�ְ���ȹ ������ Ȯ��', '�ְ���ȹ �������� Ȯ�� �Ͻʽÿ�.')
	Return
End If

SetPointer(HourGlass!)

dw_hidden4.ReSet()
dw_hidden4.ImportClipBoard()

Long   i
Long   ll_ins
Long   ii
Long   ll_qty01
Long   ll_qty02
Long   ll_qty03
Long   ll_qty04
Long   ll_qty05
Long   ll_qty06
Long   ll_qty07
Long   ll_jego
String ls_chk
String ls_itnbr
String ls_plan01
String ls_plan02
String ls_plan03
String ls_plan04
String ls_plan05
String ls_plan06
String ls_plan07
String ls_cvnas
String ls_unit
String ls_accod
String ls_itdsc
String ls_ispec
String ls_jijil
String ls_bal
Double ldb_prc

ls_plan01 = gs_gubun
ls_plan02 = f_afterday(gs_gubun, 1)
ls_plan03 = f_afterday(gs_gubun, 2)
ls_plan04 = f_afterday(gs_gubun, 3)
ls_plan05 = f_afterday(gs_gubun, 4)
ls_plan06 = f_afterday(gs_gubun, 5)
ls_plan07 = f_afterday(gs_gubun, 6)

ii = 0

For i = 1 To dw_hidden4.RowCount()
	ls_chk = dw_hidden4.GetItemString(i, 'chk')
	
	ls_itnbr = dw_hidden4.GetItemString(i, 'itnbr'  )
	ls_accod = dw_hidden4.GetItemString(i, 'accod'  )
	ls_bal   = dw_hidden4.GetItemString(i, 'baljpno')
	ldb_prc  = dw_hidden4.GetItemNumber(i, 'unprc'  )
	ll_qty01 = dw_hidden4.GetItemNumber(i, 'qty_01' )
	ll_qty02 = dw_hidden4.GetItemNumber(i, 'qty_02' )
	ll_qty03 = dw_hidden4.GetItemNumber(i, 'qty_03' )
	ll_qty04 = dw_hidden4.GetItemNumber(i, 'qty_04' )
	ll_qty05 = dw_hidden4.GetItemNumber(i, 'qty_05' )
	ll_qty06 = dw_hidden4.GetItemNumber(i, 'qty_06' )
	ll_qty07 = dw_hidden4.GetItemNumber(i, 'qty_07' )
	
	SELECT CUNIT
	  INTO :ls_unit
	  FROM DANMST
	 WHERE ITNBR = :ls_itnbr
	   AND CVCOD = :ls_cvcod
		AND SLTCD = 'Y' ;
	If Trim(ls_unit) = '' OR IsNull(ls_unit) Then ls_unit = 'WON'
	
	SELECT ITDSC    , ISPEC    , JIJIL
	  INTO :ls_itdsc, :ls_ispec, :ls_jijil
	  FROM ITEMAS
	 WHERE ITNBR = :ls_itnbr ;
	If Trim(ls_ispec) = '' OR IsNull(ls_ispec) Then ls_ispec = '.'
	If Trim(ls_jijil) = '' OR IsNull(ls_jijil) Then ls_jijil = ''
	
	If ls_chk = 'Y' Then
		/* ���ֳ��� ���� */
		If wf_bal_delete(ls_saupj, gs_gubun, ls_cvcod, ls_itnbr, ls_bal) < 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('�� ���� ����', '�� ���� ���� ����')
			Return
		End If
		
		If ll_qty01 > 0 AND wf_balju_cnt(gs_gubun, ls_plan01, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty01          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty01)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan01         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan01         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
		If ll_qty02 > 0 AND wf_balju_cnt(gs_gubun, ls_plan02, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty02          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty02)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan02         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan02         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
		If ll_qty03 > 0 AND wf_balju_cnt(gs_gubun, ls_plan03, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty03          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty03)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan03         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan03         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
		If ll_qty04 > 0 AND wf_balju_cnt(gs_gubun, ls_plan04, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty04          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty04)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan04         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan04         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
		If ll_qty05 > 0 AND wf_balju_cnt(gs_gubun, ls_plan05, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty05          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty05)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan05         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan05         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
		If ll_qty06 > 0 AND wf_balju_cnt(gs_gubun, ls_plan06, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty06          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty06)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan06         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan06         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
		If ll_qty07 > 0 AND wf_balju_cnt(gs_gubun, ls_plan07, ls_cvcod, ls_itnbr) = 0 Then
			ll_ins = dw_insert.InsertRow(0)
			ii++
					
			dw_insert.SetItem(ll_ins, 'sabu'         , gs_sabu           )  //ȸ����α���
			dw_insert.SetItem(ll_ins, 'saupj'        , ls_saupj          )  //�����
			dw_insert.SetItem(ll_ins, 'itnbr'        , ls_itnbr          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_itdsc' , ls_itdsc          )  //ǰ��
			dw_insert.SetItem(ll_ins, 'itemas_ispec' , ls_ispec          )  //���
			dw_insert.SetItem(ll_ins, 'itemas_jijil' , ls_jijil          )  //����
			dw_insert.SetItem(ll_ins, 'balseq'       , ii                )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balqty'       , ll_qty07          )  //���ּ���
			dw_insert.SetItem(ll_ins, 'balsts'       , '1'               )  //���ֻ���
			dw_insert.SetItem(ll_ins, 'poblkt_tuncu' , ls_unit           )  //ȭ�����
			dw_insert.SetItem(ll_ins, 'unprc'        , ldb_prc           )  //�ܰ�
			dw_insert.SetItem(ll_ins, 'unamt'        , ldb_prc * ll_qty07)  //�ݾ�
			dw_insert.SetItem(ll_ins, 'poblkt_gudat' , ls_plan07         )  //�԰�䱸��
			dw_insert.SetItem(ll_ins, 'nadat'        , ls_plan07         )  //���⿹����
			dw_insert.SetItem(ll_ins, 'poblkt_ipdpt' , ls_ipdpt          )  //�԰���â��
			dw_insert.SetItem(ll_ins, 'accod'        , ls_accod          )  //�����ڵ�
			dw_insert.SetItem(ll_ins, 'yebi1'        , '.'               )  //�����ڵ�
			//�����ڿ� ���� �ڷ� ����
			If is_gubun = 'Y' Then
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', is_cnvart)
			Else
				dw_insert.SetItem(ll_ins, 'poblkt_cnvart', '*'      )
			End If

			SELECT FUN_GET_TOTSTOCK_QTY(:ls_ipdpt, :ls_itnbr, '.', '9999', '1')
			  INTO :ll_jego 
			  FROM DUAL ;
			dw_insert.SetItem(ll_ins, 'jego_qty', ll_jego)  //���
			dw_insert.SetItem(ll_ins, 'rdptno'  , ls_rdpt)  //�����Ƿںμ�
			
			wf_cnvfat(ll_ins, ls_itnbr)
		End If
			
	End If
Next

/* ���ֹ�ȣ ���� */
Long   ll_seq
ll_seq = SQLCA.FUN_JUNPYO(gs_sabu, ls_baldate, 'K0')
If ll_seq = -1 Then
	ROLLBACK USING SQLCA;
	f_message_chk(51, '')
	Return
End If

COMMIT USING SQLCA;

String ls_baljpno
ls_baljpno = ls_baldate + String(ll_seq, '0000')

Long   ll_bal
SELECT COUNT('X')
  INTO :ll_bal
  FROM POMAST
 WHERE BALJPNO = :ls_baljpno ;
If ll_bal > 0 Then
	f_message_chk(51, '[���ֹ�ȣ �ߺ�]')
	Return
End If

dw_1.SetItem(1, 'baljpno', ls_baljpno)

Long   l

For l = 1 To dw_insert.RowCount()
	dw_insert.SetItem(l, 'baljpno', ls_baljpno)
Next

SetNull(ls_chk)
SetNull(l)

String ls_web
ls_web = f_today() + ' ' + f_totime()

For l = 1 To dw_hidden4.RowCount()
	ls_chk   = dw_hidden4.GetItemString(l, 'chk')
	If ls_chk = 'Y' Then
		ls_itnbr = dw_hidden4.GetItemString(l, 'itnbr')
		UPDATE PU03_WEEKPLAN
			SET BALJPNO = :ls_baljpno, WEBCNF = :ls_web
		 WHERE SABU   = :gs_saupj
			AND YYMMDD = :gs_gubun
			AND WAIGB  = '2'
			AND CVCOD  = :ls_cvcod
			AND ITNBR  = :ls_itnbr ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('�ڷ� �������', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
			Return
		End If
	End If
Next

SetPointer(Arrow!)

If dw_1.UPDATE() = 1 Then
	If dw_insert.UPDATE() = 1 Then
		If SQLCA.SQLCODE = 0 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
			MessageBox('�ڷ� �������', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
			Return
		End If
	Else
		ROLLBACK USING SQLCA;
		MessageBox('�ڷ� �������', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
		Return
	End If
Else
	ROLLBACK USING SQLCA;
	MessageBox('�ڷ� �������', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
	Return
End If
end event

type dw_hidden4 from datawindow within w_imt_02045
boolean visible = false
integer x = 1262
integer y = 40
integer width = 165
integer height = 120
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_02045_plan_002"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type st_2 from statictext within w_imt_02045
integer x = 55
integer y = 124
integer width = 2491
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 255
long backcolor = 67108864
string text = "�� SCM CKD���� �� ��� ~"CKD����~"�� CKD�� ���� ~"���~"���� CKD���ֹ�ȣ ������ ��"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_imt_02045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4165
integer y = 176
integer width = 443
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_02045
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

