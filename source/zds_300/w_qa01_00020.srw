$PBExportHeader$w_qa01_00020.srw
$PBExportComments$** ����ǰ���˻�
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
string title = "���԰˻� ���"
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


string  is_syscnfg  //�պ����� ���(1:����, 2;�ҷ�����)

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
// 1. �˻�������
//	2. ���ҽ��ε� ������ �����Ұ�
//	3. ���ҽ����� = NULL �γ����� ��������
//////////////////////////////////////////////////////////////////////
string	sConfirm, sEmpno
long		lRow 

FOR lRow = 1	TO		dw_insert.RowCount()

	sConfirm = dw_insert.GetItemString(lRow, "imhist_io_confirm")
	sEmpno   = dw_insert.GetItemString(lRow, "imhist_io_empno")
//	dw_insert.setitem(lrow, "iofaqty_temp", dw_insert.getitemdecimal(lrow, "imhist_iofaqty"))
//	dw_insert.setitem(lrow, "iocdqty_temp", dw_insert.getitemdecimal(lrow, "imhist_iocdqty"))
	dw_insert.SetItem(lRow, "gubun", 'Y')	

	/* ���� ���ε� ������ �����Ұ� */
	IF ( sConfirm = 'N' ) and	Not IsNull(sEmpno)	THEN
		dw_insert.SetItem(lRow, "gubun", 'N')							// �����Ұ�
	END IF
	
	/* Ưä��û�� ������ �����Ұ� 
		-. Ưä��û�� �˻����Ŀ� �߻���	*/
	IF dw_insert.getitemdecimal(lrow, "imhist_tukqty") > 0 then
		dw_insert.SetItem(lRow, "gubun", 'N')							// �����Ұ�
	END IF
		

NEXT

dw_insert.accepttext()
end subroutine

public function integer wf_imhist_create_nitem ();///////////////////////////////////////////////////////////////////////
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '007'
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

siogbn	 = 'O25'		// ǰ���ü���
sjnpcrt	 = '001'
sIogbn_in = 'I13'		// ǰ���ü�԰�
sjnpcrt_in= '011'


FOR lRow = 1 TO dw_insert.RowCount()
	if dw_insert.GetItemString(lRow, "gubun") = 'N' then continue
	
	// ��ǰ�� �ڷḸ ó��
	sitnbr = dw_insert.GetItemString(lRow, "imhist_itnbr")
	select itnbryd into :sitnbr_in from item_rel
	 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
	if sqlca.sqlcode <> 0 then continue

	
	sDate = dw_insert.GetItemString(lRow, "imhist_insdat")
	dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dSeq < 1		THEN
		ROLLBACK;
		f_message_chk(51,'[ǰ���ü��� ��ǥ��ȣ]')	
		RETURN -1
	END IF
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 1		THEN
		ROLLBACK;
		f_message_chk(51,'[ǰ���ü�԰� ��ǥ��ȣ]')
		RETURN -1
	END IF

	sJpno  = sDate + string(dSeq, "0000")

	lRowOut = dw_imhist_nitem_out.InsertRow(0)

	sEmpno  = dw_insert.GetItemString(lRow, "imhist_io_empno")				// �԰��Ƿ���
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
	if sqlca.sqlcode <> 0 then	sdepot_in = 'Z01'		// ����â��
	
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
	dw_imhist_nitem_out.SetItem(lRowOut, "bigo",  	'�����԰� ��ǰ �ڵ� ���')
	dw_imhist_nitem_out.SetItem(lRowOut, "botimh",	'Y')
	dw_imhist_nitem_out.SetItem(lRowOut, "ip_jpno",	sinjpno)
	dw_imhist_nitem_out.SetItem(lRowOut, "ioreemp",	sEmpno)
	select deptcode into :sdeptcode from p1_master where empno = :sempno;
	dw_imhist_nitem_out.SetItem(lRowOut, "ioredept",sDeptcode)
	dw_imhist_nitem_out.SetItem(lRowOut, "saupj",	dw_insert.GetitemString(lRow, "imhist_saupj"))	
	

	/////////////////////////////////////////////////////////////////////////////////////
	// �԰���ǥ ����
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
	dw_imhist_nitem_in.SetItem(lRowIn, "bigo",  		'�����԰� ��ǰ �ڵ� �԰�')
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

// ��ǰ�� �ڷḸ ó��
sitnbr = dw_insert.GetItemString(arg_row, "imhist_itnbr")
select itnbryd into :sitnbryd from item_rel
 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
if sqlca.sqlcode <> 0 then return 1

siojpno = dw_insert.getitemstring(arg_row,'imhist_iojpno')


///1.��ǰ������////////////////////////////////////////////////////////
select iojpno into :soutjpno from imhist
 where sabu = :gs_sabu and ip_jpno = :siojpno 
	and iogbn = 'O25' and saupj = :gs_saupj ;
	
if sqlca.sqlcode = 0 then
	delete from imhist
	 where sabu = :gs_sabu and iojpno = :soutjpno and saupj = :gs_saupj ;
	if sqlca.sqlcode <> 0 then
		messagebox('Ȯ��','�����ǥ��ȣ: '+soutjpno+' ���� ����!!!')
		return -1
	end if
end if


///2.��ǰ�԰����////////////////////////////////////////////////////////
select iojpno into :sinjpno from imhist
 where sabu = :gs_sabu and ip_jpno = :soutjpno 
	and iogbn = 'I13' and saupj = :gs_saupj ;
	
if sqlca.sqlcode = 0 then
	delete from imhist
	 where sabu = :gs_sabu and iojpno = :sinjpno and saupj = :gs_saupj ;
	if sqlca.sqlcode <> 0 then
		messagebox('Ȯ��','�԰���ǥ��ȣ: '+sinjpno+' ���� ����!!!')
		return -1
	end if
end if

return 1
end function

public function integer wf_waiju ();/* �Է� ������ ��쿡�� ����� */
Long   Lrow,  lRowCount
String sIogbn, sWigbn, sError, sIojpno, sGubun, ls_chk

lRowCount = dw_insert.rowcount()

For Lrow = 1 to lRowCount
	
	sGubun = dw_insert.GetItemString(Lrow, "gubun")
	IF sGubun = 'N'	THEN CONTINUE /* �̰˻系���� skip */

	/* �԰����°� �������� check	*/
	siogbn = dw_insert.GetItemString(Lrow, "imhist_iogbn")	
	
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;
	
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		f_message_chk(311,'[���ֿ���]')
		return -1
	end if

	/* ���ְ��� �Ǵ� �����԰��� ��쿡�� ������� �ڵ������ڷ� ���� 
		-. �� �˻����ڰ� �ִ� ��쿡 �� ��*/
	if sWigbn = 'Y' Then
		sError 	= 'X';
		sIojpno	= dw_insert.getitemstring(Lrow, "imhist_iojpno")
		
		/* �ڵ����� �ڷ����� Ȯ�� - BY SHINGOON 2016.05.19 */
		SELECT IOGBN INTO :ls_chk FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
		/* ���ұ����� �����ϸ� ��ǥ��ȣ �ٽ� �������� - �ڵ����� �ڷ��� ��� ls_chk���� [IM7]�� ó�� */
		/* ���� - �ڵ����� �ڷ��� ��� (sIogbn='I01' or sIogbn='I03') �̰� ls_chk='IM7'
		          �ڵ����� �ڷᰡ �ƴ� ��� (sIogbn='I01' or sIogbn='I03') �̰� (ls_chk='I01' or ls_chk='I03') */
		If sIogbn <> ls_chk Then
			SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* �ڵ����� �԰�(IM7)�� �ڵ����� ���(OM7) ��ǥ��ȣ Ȯ�� */
			SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* �ڵ����� ���(OM7)�� ����/�����԰�(I01/I03) ��ǥ��ȣ Ȯ�� */
			If Trim(sIojpno) = '' Or IsNull(sIojpno) Then
				MessageBox('Ȯ��', '�ڵ����� �ڷῡ ���� ����/�����԰� ��ǥ��ȣ�� ã�� �� �����ϴ�.')
				ROLLBACK USING SQLCA;
				Return -1
			End If
		End If
		
		sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[�����ڵ����1]')
			Rollback;
			return -1
		end if;		
		sError 	= 'X';
		sqlca.erp000000360(gs_sabu, sIoJpno, 'I', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[�����ڵ����2]')
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

		sIojpno = dw_insert.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ
		dQty 	   		= dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")				// �԰����
		dIocdQty			= dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
		dIocdQty_Temp 	= dw_insert.GetItemDecimal(lRow, "iocdqty_temp")					// ���Ǻμ���
		dBadQty 			= dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
		dBadQty_Temp 	= dw_insert.GetItemDecimal(lRow, "iofaqty_temp")					// �ҷ�����
		diopeQty  		= dw_insert.GetItemDecimal(lRow, "imhist_iopeqty")				// ������
		diopeQty_TEMP	= dw_insert.GetItemDecimal(lRow, "iopeqty_temp")	   			// ������
		diopeQty  		= dw_insert.GetItemDecimal(lRow, "imhist_iopeqty")				// ������
		diopeQty_TEMP	= dw_insert.GetItemDecimal(lRow, "iopeqty_temp")	   			// ������

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
//				str_01040.gubun   = 'Y' //���԰˻籸��
//				Openwithparm(w_qct_01050, str_01040)			
//         END IF 
      
		IF sDecisionyn  <> sDecisionyn_Temp	THEN
			
			If dw_insert.GetItemString(lRow, "imhist_bigo") = '' Or &
				isNull(dw_insert.GetItemString(lRow, "imhist_bigo")) Then
				
				MessageBox('Ȯ��','�պ����� ��������� ����ϼ���.')
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
			str_00020.gubun   = 'Y' //���԰˻籸��
	
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
//			dIocdQty			= dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
//			dBadQty 			= dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
//			
//			if sDecisionyn = 'Y' then 
//				if dBadQty > 0 or dIocdQty > 0 then 
//					MessageBox(' [�հ� ����!] ', '�ҷ�����/���Ǻμ����� Ȯ���ϼ���! ',Information!)
//					dw_insert.ScrollToRow(lRow)
//					dw_insert.setcolumn("imhist_iofaqty")
//					dw_insert.SetRow(lRow)
//					dw_insert.setfocus()
//					return -1
//				end if
//			elseif sDecisionyn = 'N' then 
//				if dBadQty <= 0 then 
//					MessageBox(' [���հ� ����!] ', '�ҷ������� Ȯ���ϼ���! ',Information!)
//					dw_insert.ScrollToRow(lRow)
//					dw_insert.setcolumn("imhist_iofaqty")
//					dw_insert.SetRow(lRow)
//					dw_insert.setfocus()
//					return -1
//				end if
//			end if 

			dw_insert.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - dIopeqty)	// �հ� = �԰��Ƿ� - �ҷ�

			// �����ǥ��ȣ ����	
			sVendor = dw_insert.GetItemString(lRow, "imhist_depot_no")
			sStockGubun  = dw_insert.GetItemString(lRow, "imhist_filsk")			// ����������
			sJpno  = dw_insert.GetItemString(lRow, "imhist_iojpno")
			saleyn = dw_insert.GetItemString(lRow, "imhist_io_confirm")
			
			// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
			// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
			sOpseq = dw_insert.GetItemString(lRow, "imhist_opseq")
			IF sOpseq <> '9999' Then
				dw_insert.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_insert.getitemdecimal(lrow, "imhist_ioprc"),0))				
				CONTINUE		
			END IF					
			
			if saleyn = 'Y' then // �ڵ�������ǥ�� ���
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
					Messagebox("Ȯ ��", "�����ڷ� ����� ���� �߻�", information!)
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
	sIojpno = dw_insert.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ	
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
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

public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// ������ �۾����� ��ǥ�� �����Ѵ�.
// ���� A = �ű��Է�, U = ������ �Է�, D = ����
// ���ְ����԰�(������ 9999�� �ƴϸ�)�� ��쿡�� ������ǥ�� �ۼ��Ѵ�.
String sitnbr, sup_itnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
String swkctr ,sjocod ,sittyp ,sipgub
Decimal {3} dInqty, dGoqty

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("�۾���������", "�۾����� ������ �����Ͽ����ϴ�", stopsign!)
		return -1	
	end if
end if

dInqty	 = dw_insert.getitemdecimal(lrow, "imhist_iosuqty")							      // ��������
dGoqty	 = dw_insert.getitemdecimal(lrow, "imhist_gongqty")	+ &
				dw_insert.getitemdecimal(lrow, "imhist_iopeqty")									// �������� -> ������

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
		MessageBox("�۾���������", "�۾����� ������ �����Ͽ����ϴ�", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then

	sShpJpno  = sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// �۾�������ȣ
	sitnbr	 =	dw_insert.GetItemString(lRow, "imhist_itnbr") 							      // ǰ��
	sPspec	 =	dw_insert.GetItemString(lRow, "imhist_pspec")					      // ���
	sPordno	 = dw_insert.getitemstring(lrow, "poblkt_pordno")				      // �۾����ù�ȣ	
   
	Setnull(sLastc)
	Setnull(sDe_Lastc)
	Setnull(sshpipno)

	SELECT A.ITNBR ,   A.WKCTR, A.LASTC  , B.JOCOD ,A.OPSEQ    
	  Into :sup_itnbr, :swkctr, :slastc , :sjocod ,:sde_opseq 
	  FROM ROUTNG A, WRKCTR B 
	 WHERE A.WKCTR = B.WKCTR
	   AND A.WAI_ITNBR = :sitnbr ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox('Ȯ��','���ְ��� ����Ÿ�� �����ϴ�.'+&
		          '~n~r~n~r���ֽ����� �ۼ��� �� �����ϴ�. ǥ�ذ�������Ÿ�� Ȯ���ϼ���.')
		Rollback;
		Return -1
	End If
	
	// ������ �������� 
	SELECT PDTGU , ITTYP into :spdtgu , :sittyp 
	  FROM ITEMAS 
	 WHERE ITNBR = :sup_itnbr ;
   
	If sittyp = '1' Then // ����ǰ �϶� 
		SELECT MIN(CVCOD) into :sipgub FROM VNDMST WHERE CVGU = '5' AND JUPROD = '1' ;
	Else                 // ����ǰ �϶� 
		SELECT MIN(CVCOD) into :sipgub FROM VNDMST WHERE CVGU = '5' AND JUPROD = '2' AND JUMAEIP = :spdtgu ;
		
	End If
		  
	// ���������̸� �԰��ȣ�� �����Ѵ�
	if sLastc = '3' or sLastc = '9' then
		sShpipno = sDate + string(dShpipgo, "0000") + string(LrowHist, '000')		// �۾������� ���� �԰��ȣ
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
		  0,					0,						:dInqty,				'ǰ��',				'N',
		  '2',				substr(:sIojpno, 3, 10),				substr(:sIojpno, 3, 10),
		  :sipgub,			null,
		  null,				:sde_opseq,			:sLastc,				:sDe_Lastc,			'N',
		  :sIojpno,			:sShpipno,        :gs_userid  ,
		  :sDate ,        0 ,               0 ,               0 ,               '2' );
		  
	
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
//		MessageBox("SQL ERROR", SQLCA.SQLERRTXT, stopsign!)
		MessageBox("�۾������ۼ�", "�۾����� �ۼ��� �����Ͽ����ϴ�", stopsign!)
		return -1
	End if	
	
	dw_insert.SetItem(lRow, "imhist_jakjino", sPordno)		// �۾����ù�ȣ
	dw_insert.SetItem(lRow, "imhist_jaksino", sShpjpno)	// �۾�������ȣ	
	
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
//	dw_ip.Modify("insdate_t.text= '��������'") 
	
//	w_mdi_frame.sle_msg.text = "�˻��Ƿ�"
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
//	dw_ip.Modify("insdate_t.text= '�˻�����'") 
//	w_mdi_frame.sle_msg.text = "�˻���"
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
//	1. ���HISTORY ����
//
///////////////////////////////////////////////////////////////////////
string	sJpno, snull, sstockgubun, saleyn, sIogbn, sError, sWigbn, siojpno, sOpseq ,siogbn_t
string sItnbr, ls_o25jpno, ls_i13jpno
long		lRow, lCnt
decimal {3} dbuqty, djoqty

setnull(snull)
lrow = ar_row

If dw_insert.isSelected(lrow) = False Then 
	MessageBox('Ȯ��','������ ���� �����ϼ���')
	Return -1
End If

if dw_insert.getitemstring(lrow, "gubun") = 'N' then
	messagebox("Ȯ ��", "������ �� �����ϴ�. �ڷḦ Ȯ���ϼ���.")
	return -1
end if	

if dw_insert.getitemstring(lrow, "imhist_sarea") = 'Y' then
	messagebox("Ȯ ��", "�԰��� Ȯ�ε� �ڷ�� ������ �� �����ϴ�.~n���� �԰��� Ȯ�� ��� �Ͻʽÿ�.")
	return -1
end if	

sJpno = dw_insert.GetItemString(lrow, "imhist_iojpno")  //�ڵ����� ó���� �԰��ڷ��� ��� �ڵ������԰� ��ǥ��ȣ �� - BY SHINGOON 2016.02.27

String ls_om7jpno, ls_insdat, ls_insemp, ls_007jpno, ls_conf, ls_err
Long   ll_err
/* �ڵ������԰�(IM7)�� �ڵ��������(OM7) ��ǥ��ȣ Ȯ�� - BY SHINGOON 2016.02.27 */
SELECT IP_JPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sJpno ;
/* �ڵ��������(OM7)�� �����ڷ�(I01, I03) ��ǥ��ȣ Ȯ�� - BY SHINGOON 2016.02.27 */
SELECT IP_JPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno ;
/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE IOGBN = 'OM7' AND IP_JPNO = :sJpno;*/
If Trim(ls_007jpno) = '' Or IsNull(ls_007jpno) Then ls_007jpno = sJpno
/* ����/���� �԰� �ڷ��� ��ǰâ�� ���ο��� Ȯ�� - BY SHINGOON 2018.03.28 */
SELECT CASE WHEN NVL(IO_EMPNO, '.') <> '.' THEN 'Y' ELSE 'N' END INTO :ls_conf FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno;
If ls_conf = 'Y' Then
	MessageBox('Ȯ��', '�̹� ��ǰ�԰� ���� ó���� �����Դϴ�.~r~n��ǰ�԰� ���� ��� �� �˻系���� ����Ͻñ� �ٶ��ϴ�.')
	Return -1
End If

sStockGubun  = dw_insert.GetItemString(lRow, "imhist_filsk")			// ����������

DELETE FROM IMHIST  
 WHERE SABU    = :gs_sabu AND 
       /*IP_JPNO = :sJpno  AND*/
		 IP_JPNO = :ls_007jpno AND
	  	 JNPCRT  = '008' ;

if sqlca.sqlcode < 0 then
	ROLLBACK;
	Messagebox("Ȯ ��", "���ҳ��� ������ ���� �߻�", information!)
	return -1
end if
	 
/* �ҷ��� ���Ǻ� ������ check�Ͽ� ������ ������ �ҷ������� ���� */
dBuqty = dw_insert.GetItemDecimal(lRow, "iocdqty_temp")				// ���Ǻμ���
dJoqty = dw_insert.GetItemDecimal(lRow, "iofaqty_temp")				// �ҷ�����	
If dBuqty > 0 or dJoqty > 0 then
	
	DELETE FROM "IMHFAT"  
	 WHERE "IMHFAT"."SABU" = :gs_sabu AND "IMHFAT"."IOJPNO" = :ls_007jpno ;  
/*			 "IMHFAT"."IOJPNO" = :sJpno   ;*/
//	if sqlca.sqlnrows < 1 then
	If sqlca.sqlcode <> 0 then
		messagebox(String(sqlca.sqlcode), sqlca.sqlerrtext)
		ROLLBACK;
		Messagebox("Ȯ��", "�ҷ����� ������ ���� �߻�", information!)
		return -1
	end if
	
//	DELETE FROM "IMHFAG"  
//	 WHERE "IMHFAG"."SABU" = :gs_sabu AND  
//			 "IMHFAG"."IOJPNO" = :sJpno   ;
//
//	if sqlca.sqlcode < 0 then
//		ROLLBACK;
//		Messagebox("Ȯ ��", "��ġ���� ������ ���� �߻�", information!)
//		return -1
//	end if
	
END IF

dw_insert.setitem(lrow, "imhist_insdat", snull)
dw_insert.setitem(lrow, "imhist_tukemp", snull)
// �������� ����
dw_insert.SetItem(lRow, "imhist_iocdqty", 0)				// ���Ǻμ���
dw_insert.SetItem(lRow, "imhist_iofaqty", 0)				// �ҷ�����
dw_insert.SetItem(lRow, "imhist_iosuqty", 0)				// �հݼ���
dw_insert.SetItem(lRow, "imhist_iopeqty", 0)				// ������
dw_insert.SetItem(lRow, "imhist_silyoqty", 0)				// �÷����
dw_insert.SetItem(lRow, "imhist_gongqty", 0)				// ��������
dw_insert.SetItem(lRow, "imhist_gongprc", 0)				// �����ܰ�
dw_insert.SetItem(lRow, "imhist_decisionyn", snull)     // �պ�����
dw_insert.SetItem(lRow, "imhist_jaksino",    snull)     // �۾�������ȣ 

// ���ִ��� ����
dw_insert.SetItem(lRow, "imhist_cnviocd", 0)				// ���Ǻμ���
dw_insert.SetItem(lRow, "imhist_cnviofa", 0)				// �ҷ�����
dw_insert.SetItem(lRow, "imhist_cnviosu", 0)				// �հݼ���
dw_insert.SetItem(lRow, "imhist_cnviope", 0)				// ������
dw_insert.SetItem(lRow, "imhist_cnvgong", 0)				// ��������

// ���ο���
saleyn = dw_insert.GetItemString(lRow, "imhist_io_confirm")

if saleyn = 'Y' then // �ڵ�������ǥ�� ���
	dw_insert.setitem(lrow, "imhist_ioqty", 0)
	dw_insert.setitem(lrow, "imhist_ioamt", 0)			
	dw_insert.SetItem(lRow, "imhist_io_date",  sNull)		// ���ҽ�������=�԰��Ƿ�����
	dw_insert.SetItem(lRow, "imhist_io_empno", sNull)		// ���ҽ�����=NULL			
end if


/*����̵�����ڷ� ����ó�� */
/*2016.01.21 �ŵ���*/
/* �԰���ǥ��ȣ �������� ���� ���� - BY SHINGOON 2016.02.27 
   �԰���ǥ��ȣ�� �����ڷ�(I01, I03)�� ��ǥ��ȣ�� �ƴ϶� �ڵ������԰� ��ǥ��ȣ(IM7)�� ó���� - BY SHINGOON 2016.02.27 */
IF IsNull(sJpno) = False Then
	ls_insdat = dw_insert.GetItemString(lRow, "imhist_insdat")				// �˻� ����
	ls_insemp = dw_insert.GetItemString(lRow, "imhist_insemp")				// �˻�����
	
	/* �����ڷ�(I01, I03)�ڷ� ���� - BY SHINGOON 2016.02.27 */
	UPDATE IMHIST
		SET IOQTY = 0, IO_DATE = NULL, IOSUQTY = 0, INSDAT = NULL
	 WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20011]~r~n' + ls_err)
		Return -1
	End If
	
	/* �ڵ��������(OM7)�ڷ� ���� - BY SHINGOON 2016.02.27 */
	UPDATE IMHIST
		SET IOQTY = 0, IO_DATE = NULL, IOREQTY = 0, IOSUQTY = 0, INSDAT = NULL, INSEMP = NULL
	 WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20012]~r~n' + ls_err)
		Return -1
	End If
	
	/* �԰� ǰ���� ǰ����ü ���ҵ� �߻��ϴ��� ��ȸ 2023.07.19 by dykim */
	
	sItnbr = dw_insert.GetItemString(lRow, "imhist_itnbr")
	
	SELECT COUNT('X')
	   INTO  :lCnt
	  FROM REFFPF 
	WHERE RFCOD = '1K'
	    AND RFNA1 = :sItnbr;
		 
	If lCnt > 0 Then
		/* ���õ� �ڵ����� �԰�(IM7) ��ǥ��ȣ�� ǰ���ü ���(O25) ��ǥ��ȣ Ȯ�� 2023.07.19 by dykim */
		SELECT IOJPNO INTO :ls_o25jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'O25' AND IP_JPNO = :sJpno;
		/* ǰ���ü ���(O25) ��ǥ��ȣ�� ǰ���ü �԰�(I13) ��ǥ��ȣ Ȯ�� 2023.07.19 by dykim */
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
				MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20013]~r~n' + ls_err)
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
				MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20014]~r~n' + ls_err)
				Return -1
			End If
		End if
	End If
End If

// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�.
// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
/*sIojpno = dw_insert.GetItemString(lRow, "imhist_iojpno")// �԰��ȣ
sOpseq = dw_insert.GetItemString(lRow, "imhist_opseq")
siogbn_t = dw_insert.GetItemString(lRow, "imhist_iogbn")*/
SELECT OPSEQ, IOGBN INTO :sOpseq, :siogbn_t FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_007jpno ;
IF siogbn_t = 'I03' Then

	/*if wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sNull, 'D') = -1 then*/
	if wf_shpact(Lrow, Lrow, snull, 0, ls_007jpno, sOpseq, 0, sNull, sNull, 'D') = -1 then
		return -1
	end if
	
END IF
			
/* �԰����°� �������� check	*/
/*siogbn = dw_insert.GetItemString(Lrow, "imhist_iogbn")
Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;*/
Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn_t;
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	f_message_chk(311,'[���ֿ���]')
	return -1
end if

String  ls_chk
/* ���ְ��� �Ǵ� �����԰��� ��쿡�� ������� �ڵ������ڷ� ���� 
	-. �� �˻����ڰ� �ִ� ��쿡 �� ��*/
if sWigbn = 'Y' Then
	sError 	= 'X';
	/*sIojpno	= dw_insert.getitemstring(Lrow, "imhist_iojpno")
		
	/* �ڵ����� �ڷ����� Ȯ�� - BY SHINGOON 2016.05.19 */
	SELECT IOGBN INTO :ls_chk FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
	/* ���ұ����� �����ϸ� ��ǥ��ȣ �ٽ� �������� - �ڵ����� �ڷ��� ��� ls_chk���� [IM7]�� ó�� */
	/* ���� - �ڵ����� �ڷ��� ��� (sIogbn='I01' or sIogbn='I03') �̰� ls_chk='IM7'
				 �ڵ����� �ڷᰡ �ƴ� ��� (sIogbn='I01' or sIogbn='I03') �̰� (ls_chk='I01' or ls_chk='I03') */
	If sIogbn <> ls_chk Then
		SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* �ڵ����� �԰�(IM7)�� �ڵ����� ���(OM7) ��ǥ��ȣ Ȯ�� */
		SELECT IP_JPNO INTO :sIojpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ; /* �ڵ����� ���(OM7)�� ����/�����԰�(I01/I03) ��ǥ��ȣ Ȯ�� */
		If Trim(sIojpno) = '' Or IsNull(sIojpno) Then
			MessageBox('Ȯ��', '�ڵ����� �ڷῡ ���� ����/�����԰� ��ǥ��ȣ�� ã�� �� �����ϴ�.')
			ROLLBACK USING SQLCA;
			Return -1
		End If
	End If*/
	
	//sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
	sqlca.erp000000360(gs_sabu, ls_007jpno, 'D', sError);
	if sError = 'X' or sError = 'Y' then
		f_message_chk(41, '[�����ڵ����]~r~n' + sqlca.sqlerrtext)
		Rollback;
		return -1
	end if;		
end if;	


///��ǰ���-��ǰ�԰� ��ǥ����////////////////////////////////////////////////
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
/*�԰���(iogbn) �� �����԰��̸� �۾����� ��ǥ��ȣ�� ���� */
FOR	lRow = 1		TO		lRowCount
	
	sGubun = dw_insert.GetItemString(lRow, "gubun")
	IF sGubun = 'N'	THEN 
		dw_insert.SetItemStatus(lrow, 0, Primary!, NotModified!)
		CONTINUE /* �̰˻系���� skip */	
	END IF
	
	sQcdate = dw_insert.GetItemString(lRow, "imhist_insdat")
	
   If sQcdate = '' Or isNull(sQcdate) Or f_datechk(sQcdate) < 1 Then
		f_message_chk(35 , '[�˻�����]')
		dw_insert.SetFocus()
		dw_insert.ScrollTorow(lRow)
		dw_insert.SetColumn('imhist_insdat')
		Return -1
	End if
	
	if dw_insert.getitemstring(lrow, "imhist_iogbn") = 'I03' then  // �����԰���  ��� 
		/* �۾����� ��ǥ��ȣ */
		dShpSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'N1')
		IF dShpSeq < 1		THEN
			ROLLBACK;
			f_message_chk(51,'[�۾�������ȣ]')
			RETURN -1
		END IF
		/* �۾������� ���� �԰��ȣ */
		dShpipgo = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'C0')
		IF dShpipgo < 1	THEN
			ROLLBACK;
			f_message_chk(51,'[�۾������� ���� �԰��ȣ]')
			RETURN -1
		END IF			
		Exit	
	End if
Next

COMMIT;

/* ���ұ��� (�����԰��� �ڵ����)	*/
Select iogbn into :sIogbn from iomatrix where sabu = :gs_sabu and maiaut = 'Y';

If sqlca.sqlcode <> 0 then 
	f_message_chk(33,'[�����԰��� �ڵ����]')	
	return -1
end if

/* �ڵ����ҷ� ���� ����/�����԰� �ڷᰡ �ƴ� �ڵ������԰� �ڷḦ ������ �˻� ó�� - BY SHINGOON 2016.02.27 */
FOR lRow = 1	TO		lRowCount
	sIojpno      = dw_insert.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ - �ڵ����� �԰��ڷ��� ��ǥ ��ȣ�� - BY SHINGOON 2016.02.27
	dQty 	       = dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")				// �԰����
	dIocdQty     = dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
	dBadQty      = dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
	sStockGubun  = dw_insert.GetItemString(lRow, "imhist_filsk")			// ����������
	sDecision    = dw_insert.GetItemString(lRow,'imhist_decisionyn')
	sGubun       = dw_insert.GetItemString(lRow, "gubun")
	sOpseq 		 = dw_insert.GetItemString(lRow, "imhist_opseq")
	
	sQcdate = dw_insert.GetItemString(lRow, "imhist_insdat")
		
	IF sGubun = 'N'	THEN CONTINUE /* �̰˻系���� skip */
		
	If sQcdate = '' Or isNull(sQcdate) Or f_datechk(sQcdate) < 1 Then
		f_message_chk(35 , '[�˻�����]')
		dw_insert.SetFocus()
		dw_insert.ScrollTorow(lRow)
		dw_insert.SetColumn('imhist_insdat')
		Return -1
	End if
	

   //================================================================
	// �ҷ������� �ΰ� �̻��� ��� �ҷ������� �����ϰ� �ҷ����� �������� 
	sbulcod = dw_insert.GetItemString(lRow,'bulcod')
	if isnull(sbulcod) or sbulcod = '' then
		IF dIocdQty + dBadQty > 0		THEN	
			gs_Code = dw_insert.GetItemString(lRow, "imhist_iojpno") // �԰��ȣ - �ڵ����� �԰��ڷ��� ��ǥ ��ȣ�� - BY SHINGOON 2016.02.27
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
			str_00020.gubun   = 'Y' //���԰˻籸��
			Openwithparm(w_qa01_00021, str_00020)
		END IF
	end if
		
   //================================================================
		
	dw_insert.accepttext()
	dIocdQty= dw_insert.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
	dBadQty = dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
	diopeQty = dw_insert.GetItemDecimal(lRow, "imhist_iopeqty")			// ������
	sindate = dw_insert.GetItemString(lRow, "imhist_sudat")
		
	// ���ִ��� ���ؼ���
	dCnvQty 	= dw_insert.GetItemDecimal(lRow, "imhist_cnviore")				// �԰����
	dCnvIocd = dw_insert.GetItemDecimal(lRow, "imhist_cnviocd")				// ���Ǻμ���
	dCnvBad  = dw_insert.GetItemDecimal(lRow, "imhist_cnviofa")				// �ҷ�����
	dCnviope = dw_insert.GetItemDecimal(lRow, "imhist_cnviope")				// ������		
	   
//	dw_insert.SetItem(lRow, "imhist_qcgub",  '2')			// �˻籸���� ������ 2�� Setting
		
	dw_insert.SetItem(lRow, "imhist_insdat",  sQcDate)			// �˻�����
	dw_insert.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - diopeqty)	 // �հ� = �԰��Ƿ� - �ҷ�(��������) - ���
	dw_insert.SetItem(lRow, "imhist_cnviosu", dCnvQty - dCnvBad - dcnviope) // �հ� = �԰��Ƿ� - �ҷ�(���ִ���) - ���

	dw_insert.SetItem(lRow, "imhist_silyoqty", &
		                      dw_insert.GetItemDecimal(lRow, "siqty")) // �÷����

	string	sVendorGubun, sSaleYN
	sVendor = dw_insert.GetItemString(lRow, "imhist_depot_no")
	sSaleyn = dw_insert.GetItemString(lRow, "imhist_io_confirm")
	If IsNull(sSaleyn) OR Trim(sSaleyn) = '' Then sSaleyn = 'N'

	/////////////////////////////////////////////////////////////////////////////////
	// �԰�ݾ� ��� - 2003.12.17 - �ۺ�ȣ	
	sitnbr_t = dw_insert.GetItemString(lRow, "imhist_itnbr")
	scvcod_t = dw_insert.GetItemString(lRow, "imhist_cvcod")
	dprc = dw_insert.GetItemDecimal(lRow, "ioprc")
//	dprc = sqlca.fun_erp100000012_1(sQcDate,scvcod_t,sitnbr_t,'1')

//	select fun_erp100000012_1(:sQcDate,:scvcod_t,:sitnbr_t,'1') 
//	  into :dprc
//	  from dual ;	
	/////////////////////////////////////////////////////////////////////////////////
	

	IF sSaleYn = 'Y' or  sstockgubun = 'N' then  				// �����ڵ������� ��� �Ǵ� ������ ����� �ƴѰ�
		dw_insert.SetItem(lRow, "imhist_io_date",  sQcDate)		// ���ҽ�������=�԰��Ƿ�����
		dw_insert.SetItem(lRow, "imhist_io_empno", sNull)			// ���ҽ�����=NULL
		dw_insert.setitem(lrow, "imhist_ioqty",  dQty - dBadqty - diopeqty)
		dw_insert.setitem(lrow, "ioprc", dprc)
		dw_insert.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dprc, 0))
		//�ݾ��� �������� ���� ����
	END IF		 	
	
	/*����̵�����ڷ� ����ó�� */
	/*2016.01.21 �ŵ���*/
	/* �ڵ����� �ڷ��� ��� IM7(�ڵ����� �԰�)�� �˻��ڷ� ó�� - by shingoon 2016.02.27 */
	IF IsNull(sIojpno) = False Then
		ls_insdat = dw_insert.GetItemString(lRow, "imhist_insdat")				// �˻� ����
		ls_insemp = dw_insert.GetItemString(lRow, "imhist_insemp")				// �˻�����
		
		ll_ioamt = TRUNCATE((dQty - dBadqty) * dprc, 0)
		
		/* ���õ� �ڵ����� �԰�(IM7) ��ǥ��ȣ�� �ڵ����� ���(OM7) ��ǥ��ȣ Ȯ�� - by shingoon 2016.02.27 */
		SELECT IP_JPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :sIojpno ;
		/* �ڵ����� ���(OM7) ��ǥ��ȣ�� �����ڷ�(I01, I03) ��ǥ��ȣ Ȯ�� - BY SHINGOON 2016.02.27 */
		SELECT IP_JPNO INTO :ls_007jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOJPNO = :ls_om7jpno ;
		/*SELECT IOJPNO INTO :ls_om7jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'OM7' AND IP_JPNO = :sIojpno ;*/
		
		
		If Trim(ls_om7jpno) = '' Or IsNull(ls_om7jpno) Or Trim(ls_007jpno) = '' OR IsNull(ls_007jpno) Then
		Else
			/* IM7�ڷ� ���� */
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
				MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20011]~r~n' + ls_err)
				Return -1
			End If
			
			/* IM7�ڷ� ���� ��� �����ڷ�(I01, I03)�� UPDATEó�� - by shingoon 2016.02.27 */
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
				MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20012]~r~n' + ls_err)
				Return -1
			End If
			
			/* IM7(�ڵ����� �԰�) �ڷ�� ��� ����ڷ�(OM7)�� Ȯ�� - BY SHINGOON 2016.02.27 */
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
				MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20013]~r~n' + ls_err)
				Return -1
			End If
			
			/* ǰ����ü �ڷ�� �����԰� ���(SCM) �޴����� ������  */
			/* �԰� ǰ���� ǰ����ü ���ҵ� �߻��ϴ��� ��ȸ 2023.07.19 by dykim */
			SELECT COUNT('X')
			   INTO  :lCnt2
			  FROM REFFPF 
			WHERE RFCOD = '1K'
			    AND RFNA1 = :sitnbr_t;
		 
			If lCnt2 > 0 Then
				/* ���õ� �ڵ����� �԰�(IM7) ��ǥ��ȣ�� ǰ���ü ���(O25) ��ǥ��ȣ Ȯ�� 2023.07.19 by dykim */
				SELECT IOJPNO INTO :ls_o25jpno FROM IMHIST WHERE SABU = :gs_sabu AND IOGBN = 'O25' AND IP_JPNO = :sIojpno;
				/* ǰ���ü ���(O25) ��ǥ��ȣ�� ǰ���ü �԰�(I13) ��ǥ��ȣ Ȯ�� 2023.07.19 by dykim */
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
						MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20014]~r~n' + ls_err)
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
						MessageBox('Update Err [' + String(ll_err) + ']', '�ڷ� ���� �� ������ �߻� �߽��ϴ�.[-20015]~r~n' + ls_err)
						Return -1
					End If
				End if
			End If
		End If
	End If
	

	
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�.
	
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
	// �����ǥ ���� : ��ǥ��������('008')
	/////////////////////////////////////////////////////////////////////////////////////
	IF sStockGubun = 'N' then   // ������ ���ϸ� �����ǥ ���� 
		dOutSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sQcDate, 'C0')
		IF dOutSeq < 0		THEN	
			
			rollback;
			f_Rollback()
			RETURN -1
		end if

		lRowOut = dw_imhist_out.InsertRow(0)
		
		If swaiju_gb = 'I09' Then  /// mro �԰� �� ������ ���ϸ� �ڵ� ��� 
		
			dw_imhist_out.SetItem(lRowOut, "sabu",		gs_Sabu)
			dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// ��ǥ��������
			dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// �������
			dw_imhist_out.SetItem(lRowOut, "iojpno", 	sQcDate + string(dOutSeq, "0000") + '000')
			dw_imhist_out.SetItem(lRowOut, "iogbn",   'O81') 			// ���ұ���
			dw_imhist_out.SetItem(lRowOut, "sudat",	sQcDate)			// ��������=�԰�����
			dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_insert.GetItemString(lRow, "imhist_itnbr")) // ǰ��
			dw_imhist_out.SetItem(lRowOut, "pspec",	dw_insert.GetItemString(lRow, "imhist_pspec")) // ���
			dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// ��������
			dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// ����â��=�԰�ó
			dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// �ŷ�óâ��=�԰�ó
			dw_imhist_out.SetItem(lRowOut, "ioqty",   dQty - dBadqty - diopeqty)			// ���Ҽ���=�԰����
			dw_imhist_out.SetItem(lRowOut, "ioreqty",	dQty - dBadqty - diopeqty) 			// �����Ƿڼ���=�԰����		
			dw_imhist_out.SetItem(lRowOut, "insdat",	sQcDate) 					// �˻�����=�԰�����
			dw_imhist_out.SetItem(lRowOut, "iosuqty", dQty - dBadqty - diopeqty)			// �հݼ���=�԰����
	
			dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// ���ҽ�����
			dw_imhist_out.SetItem(lRowOut, "io_confirm", 'Y')			// ���ҽ��ο���
			dw_imhist_out.SetItem(lRowOut, "io_date", sQcDate)			// ���ҽ�������=�԰�����
			dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// ����������
			dw_imhist_out.SetItem(lRowOut, "bigo", 'MRO�����԰� ��������')
			dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// ���������
			dw_imhist_out.SetItem(lRowOut, "ip_jpno", dw_insert.GetItemString(lRow, "imhist_iojpno")) 					// �԰��ȣ - �ڵ����� �԰��ڷ��� ��ǥ ��ȣ�� - BY SHINGOON 2016.02.27
			dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// �����Ƿڴ����=�԰��Ƿڴ����

	Else
			dw_imhist_out.SetItem(lRowOut, "sabu",		gs_Sabu)
			dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// ��ǥ��������
			dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// �������
			dw_imhist_out.SetItem(lRowOut, "iojpno", 	sQcDate + string(dOutSeq, "0000") + '000')
			dw_imhist_out.SetItem(lRowOut, "iogbn",   sIogbn) 			// ���ұ���
			dw_imhist_out.SetItem(lRowOut, "sudat",	sQcDate)			// ��������=�԰�����
			dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_insert.GetItemString(lRow, "imhist_itnbr")) // ǰ��
			dw_imhist_out.SetItem(lRowOut, "pspec",	dw_insert.GetItemString(lRow, "imhist_pspec")) // ���
			dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// ��������
			dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// ����â��=�԰�ó
			dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// �ŷ�óâ��=�԰�ó
			dw_imhist_out.SetItem(lRowOut, "ioqty",   dQty - dBadqty - diopeqty)			// ���Ҽ���=�԰����
			dw_imhist_out.SetItem(lRowOut, "ioreqty",	dQty - dBadqty - diopeqty) 			// �����Ƿڼ���=�԰����		
			dw_imhist_out.SetItem(lRowOut, "insdat",	sQcDate) 					// �˻�����=�԰�����
			dw_imhist_out.SetItem(lRowOut, "iosuqty", dQty - dBadqty - diopeqty)			// �հݼ���=�԰����
	
			dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// ���ҽ�����
			dw_imhist_out.SetItem(lRowOut, "io_confirm", 'Y')			// ���ҽ��ο���
			dw_imhist_out.SetItem(lRowOut, "io_date", sQcDate)			// ���ҽ�������=�԰�����
			dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// ����������
			dw_imhist_out.SetItem(lRowOut, "bigo",  '�����԰� ��������')
			dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// ���������
			dw_imhist_out.SetItem(lRowOut, "ip_jpno", dw_insert.GetItemString(lRow, "imhist_iojpno")) 					// �԰��ȣ - �ڵ����� �԰��ڷ��� ��ǥ ��ȣ�� - BY SHINGOON 2016.02.27
			dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// �����Ƿڴ����=�԰��Ƿڴ����


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


// IMHFAT ��� ============================================================
FOR lRow = 1	TO		lRowCount
	sIojpno      = dw_insert.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ - �ڵ����� �԰��ڷ��� ��ǥ ��ȣ�� - BY SHINGOON 2016.02.27
	/* �԰�������� ó�� �� ������ ��Ȳ�� �԰������ ��Ÿ���Ե�. - by shingoon 2008.08.08 */
	//dQty 	       = dw_insert.GetItemDecimal(lRow, "imhist_ioreqty")				// �԰����
	dQty         = dw_insert.GetItemDecimal(lRow, "imhist_iofaqty")          //�ҷ�����
	sDecision    = dw_insert.GetItemString(lRow,'imhist_decisionyn')
	sGubun       = dw_insert.GetItemString(lRow, "gubun")
		
	IF sGubun = 'N'	THEN CONTINUE /* �̰˻系���� skip */
	If dQty < 1 Then Continue /* �ҷ������� 0�� ������ Skip - by shingoon 2008.08.08 */
	if sDecision = 'N' then 
		sbulcod = dw_insert.GetItemString(lRow,'bulcod')
		if isnull(sbulcod) or sbulcod = '' then
			select count(*) into :ll_cnt from imhfat
			 where sabu = :gs_sabu and iojpno = :sIojpno ;
			if ll_cnt = 0 then
				messagebox('Ȯ��','�ҷ������� �����ϼ���!!!')
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
//		str_00020.gubun   = 'Y' //���԰˻籸��
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
			CONTINUE /* �̰˻系���� skip */	
		END IF

      k++

		sdecision = dw_insert.getitemstring(lrow, "imhist_decisionyn")
		
		if isnull(sdecision) or sdecision = '' then
			messagebox('Ȯ ��', '�պ������� �����ϼ���!') 
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_decisionyn")
			dw_insert.setfocus()
			return -1
	
		end if	

		sdate1 = trim(dw_insert.getitemstring(lrow,'imhist_sudat'))
		sdate2 = trim(dw_insert.getitemstring(lrow,'imhist_insdat'))
		if f_datechk(sdate2) = -1 then
			messagebox('Ȯ ��', '�˻����ڸ� Ȯ���ϼ���!') 
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_insdat")
			dw_insert.setfocus()
			return -1	
		end if
		
		if sdate1 > sdate2 then
			messagebox('Ȯ ��', '�˻����ڰ� �������� ������ �� �����ϴ�!') 
			dw_insert.ScrollToRow(lRow)
			dw_insert.setcolumn("imhist_insdat")
			dw_insert.setfocus()
			return -1	
		end if
		
		sempno = trim(dw_insert.getitemstring(lrow,'imhist_insemp'))
		if sempno = '' or isnull(sempno) then
			messagebox('Ȯ ��', '���԰˻� ����ڸ� �Է� �Ͻʽÿ�!')
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
//			messagebox('Ȯ ��', '���԰˻� ����ڰ� �ƴմϴ�!')
//			dw_insert.ScrollToRow(lRow)
//			dw_insert.setcolumn("imhist_insemp")
//			dw_insert.setfocus()
//			return -1
//		end if
		
		//���ֿ� �۾����� no�� ������ �۾����ø� �о ���°� '1', '2' �� �ڷḸ ���� �� ����
		sPordno = dw_insert.getitemstring(lrow, 'poblkt_pordno')
		if not (sPordno = '' or isnull(sPordno)) then 
			SELECT "MOMAST"."PDSTS"  
			  INTO :get_pdsts  
			  FROM "MOMAST"  
			 WHERE ( "MOMAST"."SABU"   = :gs_sabu ) AND  
					 ( "MOMAST"."PORDNO" = :sPordno )   ;
					 
			if not (get_pdsts = '1' or get_pdsts = '2') then 
				messagebox("Ȯ ��", "���԰˻� ó���� �� �� �����ϴ�. " + "~n~n" + &
										  "�۾����ÿ� ���û��°� ����/��������ø� ���԰˻簡 �����մϴ�.")
				dw_insert.ScrollToRow(lRow)
				dw_insert.setfocus()
				return -1
			end if	
	
		end if
Next

if k < 1 then 
	messagebox('Ȯ ��', 'ó���� �ڷḦ �����ϼ���!') 
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

//��/�� ����
SELECT DATANAME  
  into :is_syscnfg
  FROM SYSCNFG   
 WHERE SYSGU  = 'Y' 
   AND SERIAL = 13 
   AND LINENO = '4' ;

if isnull(is_syscnfg) or is_syscnfg = '' or is_syscnfg = '1' then 
	is_syscnfg = '1' //����� ���� �Է�
else
	is_syscnfg = '2' //�ҷ��� �ִ� ��� �ҷ� ���� 
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
If this.GetColumnName() = 'imhist_decisionyn' then  //�߰� ������
	sDecision = GetText()
//	if ic_status = '1' then
		If sDecision = 'Y' or sDecision = 'N' Then
						
			SELECT COUNT('X')
			  INTO :lcnt
			  FROM REFFPF
			 WHERE SABU = '1' AND RFCOD = '45' AND RFGUB <> '00' AND RFNA2 = '2' AND RFGUB = :gs_empno ;
			if lcnt < 1 then
				messagebox('Ȯ ��', '���԰˻� ����ڰ� �ƴմϴ�!')
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
		MessageBox('Ȯ��','�ҷ����� ��������!!!')
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
		
		
		// ȯ�漳�� - ������� - SCM ��������
		select dataname into :ls_path from syscnfg
		 where sysgu = 'C' and serial = 12 and lineno = '2' ;
		
		ls_path = ls_path+ls_filename
		ShellExecuteA(0, "open", ls_path , "", "", 1) // ���� �ڵ� ���� 
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

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ڷ���ȸ_dn.gif"
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
	f_message_chk(30,'[�Ƿ�����FROM]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	RETURN
END IF

IF isnull(eDate) or eDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����TO]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	RETURN
END IF

IF (isnull(sQcDate) or sQcDate = "") and ic_status = '1'	THEN
	f_message_chk(30,'[�˻�����]')
	dw_ip.SetColumn("insdate")
	dw_ip.SetFocus()
	RETURN
END IF

//// ��ǥ��ȣ
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
		f_message_chk(50, '[�˻��Ƿڳ���]')
		dw_ip.setcolumn("sdate")
		dw_ip.setfocus()
		RETURN
	
	END IF
ELSE
	IF	dw_insert.Retrieve(gs_sabu, sdate, edate, scvcod, sempno, ls_saupj, sitnbr) <	1		THEN
		f_message_chk(50, '[�˻�������]')
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
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

if dw_insert.accepttext() = -1 then return 

if dw_insert.rowcount() < 1 then return 
if dw_insert.getrow() < 1 then 
	messagebox("Ȯ ��", "������ �ڷᰡ �������� �ʽ��ϴ�.")
   return 
end if

IF f_msg_delete() = -1 THEN	RETURN
Long i
For i = 1 To dw_insert.RowCount()
	If dw_insert.isSelected(i) Then
		IF wf_Imhist_Delete(i) = -1		THEN	// ��ǰ���-��ǰ�԰� ���� ���� - 2003.12.08 - �ۺ�ȣ
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

	///��ǰ���-��ǰ�԰�////////////////////////////////////////////////
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
string text = "�߰�(&A)"
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
string facename = "����ü"
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
string facename = "����ü"
string text = "BOM��볻�� ��ȸ"
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
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "���"
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
string facename = "����ü"
string pointer = " "
long textcolor = 8388608
long backcolor = 33027312
string text = "����"
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
string picturename = "C:\erpman\image\�˻��̷º���_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String scvcod, sItnbr

if dw_insert.getrow() > 0 then
	gs_code		= dw_insert.getitemstring(dw_insert.getrow(), "imhist_itnbr")
	gs_codename	= dw_insert.getitemstring(dw_insert.getrow(), "imhist_cvcod")
	open(w_qct_01040_1)
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�˻��̷º���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�˻��̷º���_up.gif"
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
string picturename = "C:\erpman\image\����_up.gif"
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
string facename = "����ü"
string pointer = "HyperLink!"
string text = "�˻缺����"
end type

event clicked;Long	lrow

lrow = dw_insert.getrow()
if lrow <= 0 then
	messagebox('Ȯ��', '�԰� ������ �����ϼ���')
	return
end if

gs_gubun = 'Y'
gs_code = dw_insert.getitemstring(lrow, 'imhist_iojpno')
//�˻籸�м���: ���԰˻�(2), ���ְ˻�(5) , �����˻�(6)
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
string facename = "����ü"
string text = "�ϰ��հ�"
end type

event clicked;int li_row, i, lcnt
string snull

SetNull(snull)

li_row = dw_insert.RowCount()

IF li_row <= 0 THEN
	IF ic_status = '1'	THEN
		f_message_chk(50, '[�˻��Ƿڳ���]')
	ELSE
		f_message_chk(50, '[�˻�������]')
	END IF
ELSE
	For i = 1 to li_row
		dw_insert.SetItem(i, 'imhist_decisionyn', 'Y')
		SELECT COUNT('X')
		  INTO :lcnt
		  FROM REFFPF
		 WHERE SABU = '1' AND RFCOD = '45' AND RFGUB <> '00' AND RFNA2 = '2' AND RFGUB = :gs_empno ;
		
		if lcnt < 1 then
			messagebox('Ȯ ��', '���԰˻� ����ڰ� �ƴմϴ�!')
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
	MessageBox("Ȯ��", "�ϰ�ó���� �Ϸ�Ǿ����ϴ�.")
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

