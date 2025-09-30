$PBExportHeader$w_qct_01040.srw
$PBExportComments$���԰˻� ���
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
string title = "���԰˻� ���"
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

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

string  is_syscnfg  //�պ����� ���(1:����, 2;�ҷ�����)
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

public function integer wf_waiju ();/* �Է� ������ ��쿡�� ����� */
Long   Lrow,  lRowCount
String sIogbn, sWigbn, sError, sIojpno, sGubun

lRowCount = dw_list.rowcount()

For Lrow = 1 to lRowCount
	
	sGubun = dw_list.GetItemString(lRow, "gubun") 
	
	/* �԰����°� �������� check	*/
	siogbn = dw_list.GetItemString(Lrow, "imhist_iogbn")	
	
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
		sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")
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

public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// ������ �۾����� ��ǥ�� �����Ѵ�.
// ���� A = �ű��Է�, U = ������ �Է�, D = ����
// ���ְ����԰�(������ 9999�� �ƴϸ�)�� ��쿡�� ������ǥ�� �ۼ��Ѵ�.
String sitnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
Decimal {3} dInqty, dGoqty

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("�۾���������", "�۾����� ������ �����Ͽ����ϴ�", stopsign!)
		return -1	
	end if
end if

dInqty	 = dw_list.getitemdecimal(lrow, "imhist_iosuqty")							      // ��������
dGoqty	 = dw_list.getitemdecimal(lrow, "imhist_gongqty")	+ &
				dw_list.getitemdecimal(lrow, "imhist_iopeqty")									// �������� -> ������

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
		MessageBox("�۾���������", "�۾����� ������ �����Ͽ����ϴ�", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then
	
	sShpJpno  = sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// �۾�������ȣ
	sitnbr	 =	dw_list.GetItemString(lRow, "imhist_itnbr") 							      // ǰ��
	sPspec	 =	dw_list.GetItemString(lRow, "imhist_pspec")					      // ���
	select fun_get_pdtgu(:sitnbr, '1') into :sPdtgu from dual;				      // ������
	sPordno	 = dw_list.getitemstring(lrow, "poblkt_pordno");				      // �۾����ù�ȣ	

	Setnull(sLastc)
	Setnull(sDe_Lastc)
	Setnull(sshpipno)
	Select Lastc, De_opseq Into :sLastc, :sDe_opseq From morout
	 Where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("�۾�����", "�۾����� �˻��� �����Ͽ����ϴ�", stopsign!)
		return -1
	End if
	
	Select Lastc Into :sDe_lastc From morout
	 Where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sDe_Opseq;
	 
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
		  PR_SHPJPNO, 		IPJPNO,           CRT_USER )
		VALUES
		( :gs_sabu,	   	:sShpjpno,			:sItnbr,				:sPspec,				null,
		  :sPdtgu,			null,					null,					:sEmpno,				:sDate,
		  0,					0,						0,						0,						0,
		  :sPordno,			'4',					'Y',					:dinqty + :dGoqty,0,
		  0,					:dGoqty,				:dInqty,				'����',				'N',
		  '2',				substr(:sIojpno, 3, 10),				substr(:sIojpno, 3, 10),			
		  :sVendor,			null,
		  null,				:sOpseq,				:sLastc,				:sDe_Lastc,			'N',
		  :sIojpno,			:sShpipno,        :gs_userid );
		  
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("�۾������ۼ�", "�۾����� �ۼ��� �����Ͽ����ϴ�", stopsign!)
		return -1
	End if	
	
	dw_list.SetItem(lRow, "imhist_jakjino", sPordno)		// �۾����ù�ȣ
	dw_list.SetItem(lRow, "imhist_jaksino", sShpjpno)	// �۾�������ȣ	
	
end if

return 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. ���HISTORY ����
//
///////////////////////////////////////////////////////////////////////
string	sJpno, snull, sstockgubun, saleyn, sIogbn, sError, sWigbn, siojpno, sOpseq
long		lRow
decimal {3} dbuqty, djoqty

setnull(snull)
lrow = dw_list.getrow()

if dw_list.getitemstring(lrow, "gubun") = 'N' then
	messagebox("Ȯ ��", "������ �� �����ϴ�. �ڷḦ Ȯ���ϼ���.")
	return -1
end if	

sJpno = dw_list.GetItemString(lrow, "imhist_iojpno")
sStockGubun  = dw_list.GetItemString(lRow, "imhist_filsk")			// ����������

DELETE FROM IMHIST  
 WHERE SABU    = :gs_sabu AND 
       IP_JPNO = :sJpno  AND
	  	 JNPCRT  = '008' ;

if sqlca.sqlcode < 0 then
	ROLLBACK;
	Messagebox("Ȯ ��", "���ҳ��� ������ ���� �߻�", information!)
	return -1
end if
	 
/* �ҷ��� ���Ǻ� ������ check�Ͽ� ������ ������ �ҷ������� ���� */
dBuqty = dw_list.GetItemDecimal(lRow, "iocdqty_temp")				// ���Ǻμ���
dJoqty = dw_list.GetItemDecimal(lRow, "iofaqty_temp")				// �ҷ�����	
If dBuqty > 0 or dJoqty > 0 then
	DELETE FROM "IMHFAT"  
	 WHERE "IMHFAT"."SABU" = :gs_sabu AND  
			 "IMHFAT"."IOJPNO" = :sJpno   ;
	if sqlca.sqlnrows < 1 then
		ROLLBACK;
		Messagebox("�ҷ�, ���Ǻγ���", "�ҷ����� ������ ���� �߻�", information!)
		return -1
	end if
	
	DELETE FROM "IMHFAG"  
	 WHERE "IMHFAG"."SABU" = :gs_sabu AND  
			 "IMHFAG"."IOJPNO" = :sJpno   ;

	if sqlca.sqlcode < 0 then
		ROLLBACK;
		Messagebox("Ȯ ��", "��ġ���� ������ ���� �߻�", information!)
		return -1
	end if
	
END IF

dw_list.setitem(lrow, "imhist_insdat", snull)
// �������� ����
dw_list.SetItem(lRow, "imhist_iocdqty", 0)				// ���Ǻμ���
dw_list.SetItem(lRow, "imhist_iofaqty", 0)				// �ҷ�����
dw_list.SetItem(lRow, "imhist_iosuqty", 0)				// �հݼ���
dw_list.SetItem(lRow, "imhist_iopeqty", 0)				// ������
dw_list.SetItem(lRow, "imhist_iodeqty", 0)				// �İ�����
dw_list.SetItem(lRow, "imhist_silyoqty", 0)				// �÷����
dw_list.SetItem(lRow, "imhist_gongqty", 0)				// ��������
dw_list.SetItem(lRow, "imhist_gongprc", 0)				// �����ܰ�
dw_list.SetItem(lRow, "imhist_decisionyn", snull)     // �պ�����
dw_list.SetItem(lRow, "imhist_jaksino",    snull)     // �۾�������ȣ 

// ���ִ��� ����
dw_list.SetItem(lRow, "imhist_cnviocd", 0)				// ���Ǻμ���
dw_list.SetItem(lRow, "imhist_cnviofa", 0)				// �ҷ�����
dw_list.SetItem(lRow, "imhist_cnviosu", 0)				// �հݼ���
dw_list.SetItem(lRow, "imhist_cnviope", 0)				// ������
dw_list.SetItem(lRow, "imhist_cnviode", 0)				// �ı�����
dw_list.SetItem(lRow, "imhist_cnvgong", 0)				// ��������

// ���ο���
saleyn 			= dw_list.GetItemString(lRow, "imhist_io_confirm")

if saleyn = 'Y' then // �ڵ�������ǥ�� ���
	dw_list.setitem(lrow, "imhist_ioqty", 0)
	dw_list.setitem(lrow, "imhist_ioamt", 0)			
	dw_list.SetItem(lRow, "imhist_io_date",  sNull)		// ���ҽ�������=�԰��Ƿ�����
	dw_list.SetItem(lRow, "imhist_io_empno", sNull)		// ���ҽ�����=NULL			
end if

// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ
sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
IF sOpseq <> '9999' Then
	
	if wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sNull, 'D') = -1 then
		return -1
	end if
		  
END IF
			
/* �԰����°� �������� check	*/
siogbn = dw_list.GetItemString(Lrow, "imhist_iogbn")	
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
	sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")
	sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
	if sError = 'X' or sError = 'Y' then
		f_message_chk(41, '[�����ڵ����]')
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
	dw_detail.Modify("sdate_t.text= '�԰�����'") 
	
	w_mdi_frame.sle_msg.text = "�˻��Ƿ�"
ELSE
	dw_detail.Modify("insdate_t.Visible= 0") 
	dw_detail.Modify("insdate.Visible= 0") 
	dw_detail.settaborder("insdate", 0)
	dw_detail.Modify("sdate_t.text= '�˻�����'") 
	w_mdi_frame.sle_msg.text = "�˻���"
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
// 1. �˻�������
//	2. ���ҽ��ε� ������ �����Ұ�
//	3. ���ҽ����� = NULL �γ����� ��������
//////////////////////////////////////////////////////////////////////
string	sConfirm, sEmpno
long		lRow 

FOR lRow = 1	TO		dw_list.RowCount()

	sConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
	sEmpno   = dw_list.GetItemString(lRow, "imhist_io_empno")
	dw_list.setitem(lrow, "iofaqty_temp", dw_list.getitemdecimal(lrow, "imhist_iofaqty"))
	dw_list.setitem(lrow, "iocdqty_temp", dw_list.getitemdecimal(lrow, "imhist_iocdqty"))
	dw_list.SetItem(lRow, "gubun", 'Y')	

	/* ���� ���ε� ������ �����Ұ� */
	IF ( sConfirm = 'N' ) and	Not IsNull(sEmpno)	THEN
		dw_list.SetItem(lRow, "gubun", 'N')							// �����Ұ�
	END IF
	
	/* Ưä��û�� ������ �����Ұ� 
		-. Ưä��û�� �˻����Ŀ� �߻���	*/
	IF dw_list.getitemdecimal(lrow, "imhist_tukqty") > 0 then
		dw_list.SetItem(lRow, "gubun", 'N')							// �����Ұ�
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
/* ������ '9999'�� �ƴϸ� �۾����� ��ǥ��ȣ�� ���� */
FOR	lRow = 1		TO		lRowCount
	
	sGubun = dw_list.GetItemString(lRow, "gubun")

	IF sGubun = 'N'	THEN 
		dw_list.SetItemStatus(lrow, 0, Primary!, NotModified!)
		CONTINUE /* �̰˻系���� skip */	
	END IF

	if dw_list.getitemstring(lrow, "imhist_opseq") <> '9999' then
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

FOR lRow = 1	TO		lRowCount

		sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ
		dQty 	  = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// �԰����
		dIocdQty= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
		sStockGubun  = dw_list.GetItemString(lRow, "imhist_filsk")			// ����������
		
		sGubun = dw_list.GetItemString(lRow, "gubun")
		IF sGubun = 'N'	THEN CONTINUE /* �̰˻系���� skip */
		
		/* �˻系�� �Ǵ� ����ڰ� ����� ��쿡�� �ܰ�������, ǰ�񸶽����� �˻籸���� update */
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
				Messagebox("�ܰ�������", "�ܰ��������� �˻纯���� �ȵǾ����ϴ�", stopsign!)
				rollback;
				return -1
			end if

			Update itemas Set qcgub  = :sQcgub1, qcemp = :sEpno1
			 Where itnbr = :sitnbr;
			 
			if sqlca.sqlnrows < 1 then
				Messagebox("ǰ�񸶽���", "ǰ�񸶽����� �˻纯���� �ȵǾ����ϴ�", stopsign!)
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
			str_01040.gubun   = 'Y' //���԰˻籸��
			Openwithparm(w_qct_01050, str_01040)
		END IF
		
		dw_list.accepttext()
		dIocdQty= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
		dBadQty = dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
		diopeQty = dw_list.GetItemDecimal(lRow, "imhist_iopeqty")			// ������
		diodeQty = dw_list.GetItemDecimal(lRow, "imhist_iodeqty")			// �ı�����
		sindate = dw_list.GetItemString(lRow, "imhist_sudat")
		
		// ���ִ��� ���ؼ���
		dCnvQty 	= dw_list.GetItemDecimal(lRow, "imhist_cnviore")				// �԰����
		dCnvIocd = dw_list.GetItemDecimal(lRow, "imhist_cnviocd")				// ���Ǻμ���
		dCnvBad  = dw_list.GetItemDecimal(lRow, "imhist_cnviofa")				// �ҷ�����
		dCnviope = dw_list.GetItemDecimal(lRow, "imhist_cnviope")				// ������
		dCnviode = dw_list.GetItemDecimal(lRow, "imhist_cnviode")				// �ı�����
		
		dw_list.SetItem(lRow, "imhist_insdat",  sQcDate)			// �˻�����
		dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - diopeqty - diodeqty)	 // �հ� = �԰��Ƿ� - �ҷ�(��������) - ��� - �ı�
		dw_list.SetItem(lRow, "imhist_cnviosu", dCnvQty - dCnvBad - dcnviope - dcnviode) // �հ� = �԰��Ƿ� - �ҷ�(���ִ���) - ���

		dw_list.SetItem(lRow, "imhist_silyoqty", &
		                      dw_list.GetItemDecimal(lRow, "siqty")) // �÷����

		string	sVendorGubun, sSaleYN
		sVendor = dw_list.GetItemString(lRow, "imhist_depot_no")
		sSaleyn = dw_list.GetItemString(lRow, "imhist_io_confirm")
		
		IF sSaleYn = 'Y' or  sstockgubun = 'N' then  				// �����ڵ������� ��� �Ǵ� ������ ����� �ƴѰ�
			dw_list.SetItem(lRow, "imhist_io_date",  sQcDate)		// ���ҽ�������=�԰��Ƿ�����
			dw_list.SetItem(lRow, "imhist_io_empno", sNull)			// ���ҽ�����=NULL
			dw_list.setitem(lrow, "imhist_ioqty",  dQty - dBadqty - diopeqty - diodeqty)
			dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_list.getitemdecimal(lrow, "ioprc"), 0))
			//�ݾ��� �������� ���� ����
		END IF		 
		
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
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
	// �����ǥ ���� : ��ǥ��������('008')
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
		dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// ��ǥ��������
		dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// �������
		dw_imhist_out.SetItem(lRowOut, "iojpno", 	sQcDate + string(dOutSeq, "0000") + '001')
		dw_imhist_out.SetItem(lRowOut, "iogbn",   'O23') 			// ���ұ���
		dw_imhist_out.SetItem(lRowOut, "sudat",	sQcDate)			// ��������=�԰�����
		dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_list.GetItemString(lRow, "imhist_itnbr")) // ǰ��
		dw_imhist_out.SetItem(lRowOut, "pspec",	dw_list.GetItemString(lRow, "imhist_pspec")) // ���
		dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// ��������
		dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// ����â��=�԰�ó
		dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// �ŷ�óâ��=�԰�ó
		dw_imhist_out.SetItem(lRowOut, "ioqty",   dQty - dBadqty - diopeqty - diodeqty)			// ���Ҽ���=�԰����
		dw_imhist_out.SetItem(lRowOut, "ioreqty",	dQty - dBadqty - diopeqty - diodeqty) 			// �����Ƿڼ���=�԰����		
		dw_imhist_out.SetItem(lRowOut, "insdat",	sQcDate) 					// �˻�����=�԰�����
		dw_imhist_out.SetItem(lRowOut, "iosuqty", dQty - dBadqty - diopeqty - diodeqty)			// �հݼ���=�԰����

		dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// ���ҽ�����
		dw_imhist_out.SetItem(lRowOut, "io_confirm", 'Y')			// ���ҽ��ο���
		dw_imhist_out.SetItem(lRowOut, "io_date", sQcDate)			// ���ҽ�������=�԰�����
		dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// ����������
		dw_imhist_out.SetItem(lRowOut, "bigo",  '�����԰� ��������')
		dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// ���������
		dw_imhist_out.SetItem(lRowOut, "ip_jpno", dw_list.GetItemString(lRow, "imhist_iojpno")) 					// �԰���ǥ��ȣ
		dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// �����Ƿڴ����=�԰��Ƿڴ����

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
			CONTINUE /* �̰˻系���� skip */	
		END IF

      k++
		
		sdecision = dw_list.getitemstring(lrow, "imhist_decisionyn")
		
		if isnull(sdecision) or sdecision = '' then
			messagebox('Ȯ ��', '�պ������� �����ϼ���!') 
			dw_list.ScrollToRow(lRow)
			dw_list.setcolumn("imhist_decisionyn")
			dw_list.setfocus()
			return -1
		//--�� �հ� ������ ��� - ���հ� ������ �����ؾ� ��.
		elseif sdecision = 'N' then 
			
			dBadQty = dw_list.GetItemDecimal(lRow, 'imhist_iofaqty')
			
			if dBadQty <= 0 then 
				MessageBox(' [���հ� ����!] ', '���հ� ������ Ȯ���ϼ���! ',Information!)
				dw_list.ScrollToRow(lRow)
				dw_list.setcolumn("imhist_iofaqty")
				dw_list.SetRow(lRow)
				dw_list.setfocus()
				return -1
			end if
		end if	

		
		//���ֿ� �۾����� no�� ������ �۾����ø� �о ���°� '1', '2' �� �ڷḸ ���� �� ����
		sPordno = dw_list.getitemstring(lrow, 'poblkt_pordno')
		if not (sPordno = '' or isnull(sPordno)) then 
			SELECT "MOMAST"."PDSTS"  
			  INTO :get_pdsts  
			  FROM "MOMAST"  
			 WHERE ( "MOMAST"."SABU"   = :gs_sabu ) AND  
					 ( "MOMAST"."PORDNO" = :sPordno )   ;
					 
			if not (get_pdsts = '1' or get_pdsts = '2') then 
				messagebox("Ȯ ��", "���԰˻� ó���� �� �� �����ϴ�. " + "~n~n" + &
										  "�۾����ÿ� ���û��°� ����/��������ø� ���԰˻簡 �����մϴ�.")
				dw_list.ScrollToRow(lRow)
				dw_list.setfocus()
				return -1
			end if	
	
		end if
Next

if k < 1 then 
	messagebox('Ȯ ��', 'ó���� �ڷḦ �����ϼ���!') 
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

		sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ
		dQty 	   		= dw_list.GetItemDecimal(lRow, "imhist_ioreqty")				// �԰����
		dIocdQty			= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
		dIocdQty_Temp 	= dw_list.GetItemDecimal(lRow, "iocdqty_temp")					// ���Ǻμ���
		dBadQty 			= dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
		dBadQty_Temp 	= dw_list.GetItemDecimal(lRow, "iofaqty_temp")					// �ҷ�����
		diopeQty  		= dw_list.GetItemDecimal(lRow, "imhist_iopeqty")				// ������
		diopeQty_TEMP	= dw_list.GetItemDecimal(lRow, "iopeqty_temp")	   			// ������
		diodeQty  		= dw_list.GetItemDecimal(lRow, "imhist_iodeqty")				// �ı�����
		diodeQty_TEMP	= dw_list.GetItemDecimal(lRow, "imhist_iodeqty_temp")	   			// �ı�����

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
				str_01040.gubun   = 'Y' //���԰˻籸��
				Openwithparm(w_qct_01050, str_01040)			
         END IF 
			
			dw_list.accepttext()
			dIocdQty			= dw_list.GetItemDecimal(lRow, "imhist_iocdqty")				// ���Ǻμ���
			dBadQty 			= dw_list.GetItemDecimal(lRow, "imhist_iofaqty")				// �ҷ�����
			
			if sDecisionyn = 'Y' then 
//				if dBadQty > 0 or dIocdQty > 0 then 
//					MessageBox(' [�հ� ����!] ', '�ҷ�����/���Ǻμ����� Ȯ���ϼ���! ',Information!)
//					dw_list.ScrollToRow(lRow)
//					dw_list.setcolumn("imhist_iofaqty")
//					dw_list.SetRow(lRow)
//					dw_list.setfocus()
//					return -1
//				end if
			elseif sDecisionyn = 'N' then 
				if dBadQty <= 0 then 
					MessageBox(' [���հ� ����!] ', '�ҷ������� Ȯ���ϼ���! ',Information!)
					dw_list.ScrollToRow(lRow)
					dw_list.setcolumn("imhist_iofaqty")
					dw_list.SetRow(lRow)
					dw_list.setfocus()
					return -1
				end if
			end if 

			dw_list.SetItem(lRow, "imhist_iosuqty", dQty - dBadqty - dIopeqty - diodeqty)	// �հ� = �԰��Ƿ� - �ҷ�

			// �����ǥ��ȣ ����	
			sVendor = dw_list.GetItemString(lRow, "imhist_depot_no")
			sStockGubun  = dw_list.GetItemString(lRow, "imhist_filsk")			// ����������
			sJpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
			saleyn = dw_list.GetItemString(lRow, "imhist_io_confirm")
			
			// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
			// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
			sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
			IF sOpseq <> '9999' Then
				dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE((dQty - dBadqty) * dw_list.getitemdecimal(lrow, "imhist_ioprc"),0))				
				CONTINUE		
			END IF					
			
			if saleyn = 'Y' then // �ڵ�������ǥ�� ���
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
					Messagebox("Ȯ ��", "�����ڷ� ����� ���� �߻�", information!)
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
	sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// �԰��ȣ	
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
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
string picturename = "C:\erpman\image\�˻��̷º���_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String scvcod, sItnbr

if dw_list.getrow() > 0 then
	gs_code		= dw_list.getitemstring(dw_list.getrow(), "imhist_itnbr")
	gs_codename	= dw_list.getitemstring(dw_list.getrow(), "imhist_cvcod")
	open(w_qct_01040_1)
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�˻��̷º���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�˻��̷º���_up.gif"
end event

type p_1 from uo_picture within w_qct_01040
boolean visible = false
integer x = 41
integer y = 8
integer width = 178
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\��������_up.gif"
end type

event clicked;call super::clicked;gs_code = '���԰˻� �Ϸ� �뺸'
//gs_codename = 'ǰ��� :~r~n~r~n�԰� :~r~n~r~n��� :'
gs_codename = ''
//gs_gubun = 'w_qct_01040'
SetNull(gs_gubun)
Open(w_mail_insert)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��������_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��������_up.gif"
end event

type p_exit from uo_picture within w_qct_01040
integer x = 4416
integer y = 12
integer width = 178
integer taborder = 90
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_can from uo_picture within w_qct_01040
integer x = 4242
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type p_del from uo_picture within w_qct_01040
integer x = 4069
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

if dw_list.accepttext() = -1 then return 

if dw_list.rowcount() < 1 then return 
if dw_list.getrow() < 1 then 
	messagebox("Ȯ ��", "������ �ڷḦ �����ϼ���.")
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

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_mod from uo_picture within w_qct_01040
integer x = 3895
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
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

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_inq from uo_picture within w_qct_01040
integer x = 3374
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
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
		f_message_chk(30,'[�԰�����]')
	ELSE	
		f_message_chk(30,'[�˻�����]')
	END IF
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF
IF isnull(eDate) or eDate = "" 	THEN
	IF ic_status = '1'	THEN
		f_message_chk(30,'[�԰�����]')
	ELSE	
		f_message_chk(30,'[�˻�����]')
	END IF
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

IF (isnull(sQcDate) or sQcDate = "") and ic_status = '1'	THEN
	f_message_chk(30,'[�˻�����]')
	dw_detail.SetColumn("insdate")
	dw_detail.SetFocus()
	RETURN
END IF

// ��ǥ��ȣ
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
		f_message_chk(50, '[�˻��Ƿڳ���]')
		dw_detail.setcolumn("sdate")
		dw_detail.setfocus()
		RETURN
	END IF
ELSE
	IF	dw_list.Retrieve(gs_Sabu, sDate, eDate, sEmpno, sjpno, scvcod, ecvcod, is_syscnfg) <	1		THEN
//		f_message_chk(50, '[�˻�������]')
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

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
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
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event updatestart;///* Update() function ȣ��� user ���� */
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
string facename = "����ü"
string pointer = " "
long textcolor = 8388608
long backcolor = 33027312
string text = "�˻���"
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
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "�˻��Ƿ�"
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
      f_message_chk(35, '[��������]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN
	sDate  = TRIM(this.gettext())
	
	if sDate = '' or isnull(sDate) then return 
	
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[��������]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'insdate' THEN
	sDate  = TRIM(this.gettext())
	
	if sDate = '' or isnull(sDate) then return 
	
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[�˻�����]')
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
		f_message_chk(33,'[�԰��ȣ]')
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
	ireturn = f_get_name2('V0', 'N', sCode, sName, sName2)    //1�̸� ����, 0�� ����	
	this.setitem(1, "fcvcod", scode)	
	this.setitem(1, "fcvnm", sname)	
	RETURN ireturn
ELSEIF this.GetcolumnName() = 'tcvcod'	THEN
	sCode = this.GetText()								
	if scode = '' or isnull(scode) then
   	this.setitem(1, "tcvnm", snull)	
		return 
	end if
	ireturn = f_get_name2('V0', 'N', sCode, sName, sName2)    //1�̸� ����, 0�� ����	
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
		MessageBox("Ȯ��", "�ҷ����� + ���Ǻμ��� + �������� �԰��Ƿڼ������� Ŭ �� �����ϴ�.")
		this.SetItem(lRow, "imhist_cnviofa", 0)
		this.SetItem(lRow, "imhist_iofaqty", 0)
		this.SetItem(lRow, "imhist_gongqty", 0)
		this.SetItem(lRow, "imhist_gongprc", 0)
		this.SetItem(lRow, "imhist_cnvgong", 0)
		//�պ�����
		if is_syscnfg = '2' then  //�ҷ��������� ó���� 
			this.SetItem(lRow, "imhist_decisionyn", '')
		end if
		RETURN 1
	END IF

	//�պ�����
	if dbadqty > 0 and is_syscnfg = '2' then  //�ҷ��������� ó���� 
		this.SetItem(lRow, "imhist_decisionyn", 'N')
	end if
	
	// �ҷ������� 0 �̰ų� ������������ ������� ���������� 0���� �Ѵ�.
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
		MessageBox("Ȯ��", "�ҷ����� + ���Ǻμ��� + �������� �԰��Ƿڼ������� Ŭ �� �����ϴ�.")
		this.SetItem(lRow, "imhist_cnviocd", 0)
		this.SetItem(lRow, "imhist_iocdqty", 0)
		RETURN 1
	END IF
// ������
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
		MessageBox("Ȯ��", "�ҷ����� + ���Ǻμ��� + �������� �԰��Ƿڼ������� Ŭ �� �����ϴ�.")
		this.SetItem(lRow, "imhist_cnviope", 0)
		this.SetItem(lRow, "imhist_iopeqty", 0)
		RETURN 1
	END IF
// �ı�����
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
		MessageBox("Ȯ��", "�ҷ����� + ���Ǻμ��� + �������� �԰��Ƿڼ������� Ŭ �� �����ϴ�.")
		this.SetItem(lRow, "imhist_cnviode", 0)
		this.SetItem(lRow, "imhist_iodeqty", 0)
		RETURN 1
	END IF
elseif this.getcolumnname() = 'imhist_qcgub' then /* �˻������ �ٲ�� �÷������ ���� */
	
	sdata = gettext()
	if sData = '1' then
		Messagebox("���԰˻�", "���˻�� ������ �� �����ϴ�", stopsign!)
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
	
Elseif this.getcolumnname() = 'imhist_gongqty' then /* �������� - �ҷ����� ������������ �Է°����� */
	
	//�����ܰ�, ���� ó�� 
	dGongqty = dec(gettext())
	dBadqty  = this.getitemdecimal(Lrow, "imhist_iofaqty")
	
	If dGongqty > dBadqty Then
		MessageBox("��������", "���������� �ҷ����� ������������ �Է��� �����մϴ�", stopsign!)
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
elseif this.GetColumnName() = 'imhist_decisionyn' then  //�߰� ������
	
	sDecision = this.GetItemString(lRow,'imhist_decisionyn')
	
	if sDecision = 'N' then
		dBadQty = this.GetItemDecimal(lRow,'imhist_iofaqty')
		
		if dBadQty <= 0 then 
			MessageBox(' Ȯ��! ', '���հ� ������ ��� ���հ� ������ �ԷµǾ�� �մϴ�. ', Information!)
			this.SetRow(lRow)
			this.SetColumn('imhist_iofaqty')
			Return 
		end if
	end if
	
end if
end event

event updatestart;///* Update() function ȣ��� user ���� */
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

