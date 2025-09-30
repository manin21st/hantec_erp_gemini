$PBExportHeader$w_pdt_02060.srw
$PBExportComments$**�۾���������
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
string title = "�۾���������"
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


//�۾����� ���ο��� üũ(������ �����ȵǰ� �����¿��� ��������)
SELECT MATCHK
  INTO :status
  FROM MOMAST
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�۾����� �����ڷ�]')
	return -1 
else
	// ���� LJJ
//	if status = '2' then 
//		messagebox("�����Ұ�", "�۾����� ���ε� �ڷ��Դϴ�. �����¸��� ���������մϴ�.!")
//		Return -1
//	end if	
end if	 

 //�۾����� �� ���� üũ
SELECT COUNT(*)  
  INTO :get_count  
  FROM MOMORD  
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) AND  
		 ( HQTY   > 0 )   ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�۾����� �� ����]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "���ֿ� ����� �ڷᰡ �Ҵ������ �����մϴ�. ���ֿ����� Ȯ���ϼ���!")
		Return -1
	end if	
end if	

//�۾����� üũ
SELECT COUNT(*)  
  INTO :get_count  
  FROM SHPACT  
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�۾�����]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "�۾����� �ڷᰡ �����մϴ�. �۾������� Ȯ���ϼ���!")
		Return -1
	end if	
end if	

//�Ҵ� üũ(������ �ִ� �Ǽ���) 
SELECT COUNT(*)  
  INTO :get_count  
  FROM HOLDSTOCK A
 WHERE ( A.SABU    = :gs_sabu  ) AND  ( A.PORDNO  = :ar_pordno ) AND 
       ( A.ISQTY   > 0   ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�Ҵ�]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "�Ҵ翡 �ڷᰡ �����մϴ�. �Ҵ��� Ȯ���ϼ���!")
		Return -1
	end if	
end if	

//�԰� üũ(IMHIST)
SELECT COUNT(*)  
  INTO :get_count  
  FROM IMHIST
 WHERE ( SABU    = :gs_sabu  ) AND
       ( IOGBN   = 'I10' ) AND
		 ( JAKJINO = :ar_pordno ) ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�԰�]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "�԰�(IMHIST)�� �ڷᰡ �����մϴ�. �԰� Ȯ���ϼ���!")
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
	f_message_chk(41, '[�������]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "â���̵�(IMHIST)�� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	

//���ֹ����� ��� �����Ƿڰ� �Ǿ����� ���� ���� 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�����Ƿ�]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "���� �Ƿ� ����� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//�����Ƿ��� ��� �Ƿڰ� �Ǿ����� ���� ���� - �����߰� - 2001.07.21 - �ۺ�ȣ 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�����Ƿ�]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "���� �Ƿ� ����� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	


//���ֹ����� ��� ���ְ� �Ǿ����� ���� ���� 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�����ڷ�]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "���ֵ� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//���Ź����� ��� ���ְ� �Ǿ����� ���� ���� - �����߰� - 2001.07.21 - �ۺ�ȣ 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	f_message_chk(41, '[�����ڷ�]')
	return -1 
else
	if get_count > 0 then 
		messagebox("�����Ұ�", "���ֵ� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	
		
return 1

end function

public function integer wf_delete (string ar_pordno);DELETE FROM "MOMORD"  
 WHERE ( "SABU" = :gs_sabu ) AND  
		 ( "PORDNO" = :ar_pordno )   ;

if sqlca.sqlcode < 0 then 
	messagebox("��������", "�����۾��� �����Ͽ����ϴ�. [�۾����� �� ����]", StopSign!)
   return -1
end if

DELETE FROM "MOROUT"  
 WHERE ( "MOROUT"."SABU" = :gs_sabu ) AND  
		 ( "MOROUT"."PORDNO" = :ar_pordno )   ;

if sqlca.sqlcode < 0 then 
	MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		
	messagebox("��������", "�����۾��� �����Ͽ����ϴ�. [�۾����� ������]", StopSign!)
   return -1
end if

/* �۾����� ���� �ο� ���� */
DELETE FROM "MOROUT_ETC"  
 WHERE ( "MOROUT_ETC"."SABU" = :gs_sabu ) AND  
		 ( "MOROUT_ETC"."PORDNO" = :ar_pordno )   ;


DELETE FROM "HOLDSTOCK"  
 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND  
		 ( "HOLDSTOCK"."PORDNO" = :ar_pordno )   ;

if sqlca.sqlcode < 0 then 
	messagebox("��������", "�����۾��� �����Ͽ����ϴ�. [�Ҵ�]", StopSign!)
   return -1
end if

DELETE FROM "ESTIMA"  
 WHERE ( "ESTIMA"."SABU" = :gs_sabu ) AND  
       ( "ESTIMA"."PORDNO" = :ar_pordno )   ;
		 
if sqlca.sqlcode < 0 then 
	messagebox("��������", "�����۾��� �����Ͽ����ϴ�. [���ֹ���]", StopSign!)
   return -1
end if

DELETE FROM "ESTIMA"  
 WHERE ( "ESTIMA"."SABU" = :gs_sabu ) AND  
       ( "ESTIMA"."GU_PORDNO" = :ar_pordno )   ;
		 
if sqlca.sqlcode < 0 then 
	messagebox("��������", "�����۾��� �����Ͽ����ϴ�. [�����Ƿ�]", StopSign!)
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

// �����Ƿ��ؾ��� �ڷᰡ �ִ��� check�Ͽ� ��ǥ��ȣ ä��
FOR i = 1 TO tab_1.tabpage_2.dw_morout.RowCount()
	
	// �����Ұ� ������ return
	if tab_1.tabpage_2.dw_morout.getitemstring(i,"mgbn") = 'N' then continue
	
	// �ڷ᰻��(���ֱ����� ����ǰ� ���ַ� ����� ������ �ִ� ��� */
	if tab_1.tabpage_2.dw_morout.getitemstring(i,"morout_purgc") <> tab_1.tabpage_2.dw_morout.getitemstring(i,"old_purgc") then
		if tab_1.tabpage_2.dw_morout.getitemstring(i,"morout_purgc") = 'Y' then
			
			/* �Ƿںμ��� �Ƿڴ���ڴ� ȯ�漳������ ������ */
			/* �����Ƿںμ� */
			select dataname
			  into :swidpt
			  from syscnfg
			 where sysgu = 'Y' and serial = '11' and lineno = '1';
			/* �����Ƿڴ���� */
			select dataname
			  into :swiemp
			  from syscnfg
			 where sysgu = 'Y' and serial = '11' and lineno = '2';			
			 
			/* ���Ű��� ����ڰ� ���� ��� �⺻ ����ڸ� ȯ�漳������ ������ */
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
		f_message_chk(1400,'[ '+string(i)+' �� �۾���]')
		tab_1.tabpage_2.dw_morout.ScrollToRow(i)
		tab_1.tabpage_2.dw_morout.SetColumn('morout_wkctr')
		tab_1.tabpage_2.dw_morout.SetFocus()
		return -1
   end if	
   if isnull(tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_jocod')) or &
		tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_jocod') = "" then
		f_message_chk(1400,'[ '+string(i)+' �� �۾���(��)]')
		tab_1.tabpage_2.dw_morout.ScrollToRow(i)
		tab_1.tabpage_2.dw_morout.SetColumn('morout_wkctr')
		tab_1.tabpage_2.dw_morout.SetFocus()
		return -1
   end if		
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") = 'Y' then
		if isnull(tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wicvcod')) or &
			tab_1.tabpage_2.dw_morout.GetItemString(i,'morout_wicvcod') = "" then
			f_message_chk(1400,'[ '+string(i)+' �� ����ó]')
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
			f_message_chk(1400,'[ '+string(i)+' �� ���ִܰ�]')
			tab_1.tabpage_2.dw_morout.ScrollToRow(i)
			tab_1.tabpage_2.dw_morout.SetColumn('morout_wiunprc')
			tab_1.tabpage_2.dw_morout.SetFocus()
		return -1
		end if			
	end if	
	
	// �����Ұ� ������ return
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "mgbn") = 'N' then continue	
	
	// �ڷ᰻��(���ֱ����� ����� ��쿡�� ó���Ѵ� */
	if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") <> tab_1.tabpage_2.dw_morout.getitemstring(i, "old_purgc") then
		// ���ۿ��� ���ַ� ����� ���
		// 1. Estima(�����Ƿڸ� �����Ѵ�)
		// 2. Holdstock(������� ������� �����Ѵ�)
		if tab_1.tabpage_2.dw_morout.getitemstring(i, "morout_purgc") = 'Y' then
			sEstno = sJpno + String(i, '000')
				
			// ���Ŵ���� ���� 
			sEtnull(sEmpno)			
			Select emp_id into :sEmpno from vndmst where cvcod = :sCvcod;
			if isnull( sEmpno ) then sEmpno = sGiempno
		
      	// ǰ�� �����ڵ� �������� 
 			saccod = sqlca.fun_get_itnacc(sitnbr, '5');			
			 
			// �������� �������� �λ�μ��� �˻��� �� ������ ������ �μ��� ����ϰ� ������ ȯ�漳�� �̿�
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

			// �λ�μ��� �������� �μ����� �˻��� �� ������ �Ƿڴ���ڷ� ����ϰ� ������ ȯ�漳�� �̿�
			Setnull( spdtmain )
			Select empno into :spdtmain
			  from p0_dept
			 where deptcode = :sbuseo;

			if isnull( spdtmain ) then
				spdtemp = spdtbu;
			Else
				spdtemp = swiemp;
			end if;			 
			
			// �����Ƿ� ����
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
				'����->����',	:sIpgo,			'1',				'WON',			null,
				'N',				'N',				null,				:sOpseq,			'1',
				null,				0,					:sPordno,		'N',				:dpdqty,
				'*',				1,					:dPrice,   		null,				:saccod,
				 null,			:ssaupj,		null,				null,				null,		0);
				
			 if sqlca.sqlcode <> 0  then
				 Messagebox("�����Ƿ�", "�����Ƿ� ������ �����߻�", stopsign!)
				 return -1
			 end if		
		
			// ������ ���ֿ�����ȣ Move
			tab_1.tabpage_2.dw_morout.setitem(i, "morout_bajpno", sEstno)		
			
			/* ������� �� ���� ������� �˻� (���ֻ������ 1���̾�� �Ѵ�). */
			Select iogbn into :siogbn from iomatrix 
			 where sabu = '1' and autvnd = 'Y';	
			 if sqlca.sqlcode <> 0  then
				 Messagebox("��ޱ���", "��ޱ��� �˻��� �����߻�", stopsign!)
				 return -1
			 end if			 
	
			// �Ҵ籸��, ���â��, ������, ���/�⹮���� ����	
			 Update Holdstock
			 	 Set hold_gu 	= :siogbn,
				  	  out_store	= :sCvcod,
					  out_chk	= '2',
					  naougu		= '2'
			  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
			 if sqlca.sqlcode <> 0  then
				 Messagebox("������", "������ ����� �����߻�", stopsign!)
				 return -1
			 end if
	
		Else
		// ���ֿ��� ���۷� ����� ���
		// 1. Estima(�����Ƿڸ� �����Ѵ�)
		// 2. Holdstock(������ �������� �����Ѵ�)			
			 Delete From Estima 
			  where sabu  = :gs_sabu And pordno = :sPordno 
			  	 And Opseq = :sOpseq;
			 if sqlca.sqlcode <> 0  then
				 Messagebox("�����Ƿ�", "�����Ƿ� ������ �����߻�", stopsign!)
				 return -1
			 end if
			 
			// ������ ���ֿ�����ȣ CLEAR
			tab_1.tabpage_2.dw_morout.setitem(i, "morout_bajpno", sNull)


			/* ������� �� ���� ������� �˻� (�����ڵ����� 1���̾�� �Ѵ�). */
			Select iogbn into :siogbn from iomatrix 
			 where sabu = :gs_sabu and autpdt = 'Y';		
			 if sqlca.sqlcode <> 0  then
				 Messagebox("�������", "������� �˻��� �����߻�", stopsign!)
				 return -1
			 end if
			 
			// ������ �������� ����â�� �˻�
			Select cvcod
			  into :sDepot
			  from vndmst
			 where jumaeip = :spdtgu and rownum = 1;			
			 if sqlca.sqlcode <> 0  then
				 Messagebox("â���ڵ�", "â���ڵ� �˻��� �����߻�", stopsign!)
				 return -1
			 end if			 
			 
			// �Ҵ籸��, ���â��, ������, ���/�⹮���� ����	
			 Update Holdstock
			 	 Set hold_gu 	= :siogbn,
				  	  out_store	= :sDepot,
					  out_chk	= '1',
					  naougu		= '1'
			  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
			 if sqlca.sqlcode <> 0  then
				 Messagebox("�������", "������� ����� �����߻�", stopsign!)
				 return -1
			 end if	  			 
		End if	
	end if
NEXT

return 1
end function

public subroutine wf_recheck ();// �۾����� ������ check�Ͽ� ���ֱ����� ������ �� �ִ��� Ȯ���Ѵ�.
Long Lrow, Lcnt
String sOpseq, sPordno

for Lrow = 1 to tab_1.tabpage_2.dw_morout.rowcount()
	 sPordno = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "momast_pordno")
	 sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "morout_opseq")
	
	 // �����Ƿ� ���°� '1'�� ��쿡�� ���	
	 Lcnt = 0
	 Select count(*) into :Lcnt From Estima 
	  where sabu  = :gs_sabu And pordno = :sPordno 
	    And Opseq = :sOpseq   And blynd IN ('2', '3', '4');
	 if sqlca.sqlcode <> 0  then
		 Messagebox("��������", "�����Ƿ� �˻��� �����߻�", stopsign!)
		 return
	 end if
	 if Lcnt > 0 then Continue
	 
//	 // �Ҵ翡 ���� ������� ���� ��쿡�� ����
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Holdstock
//	  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq And isqty > 0;
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("��������", "�Ҵ系�� �˻��� �����߻�", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
//	 
//	 // ����� ������ ���� ��쿡�� ����
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Imhist
//	  where sabu = :gs_sabu And Jakjino = :sPordno And (Opseq = :sOpseq Or Opseq = '9999');
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("��������", "�������� �˻��� �����߻�", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
	 
	 // �۾������� ���� ��쿡�� ����	 	 
	 Lcnt = 0
	 Select count(*) into :Lcnt From Shpact
	  where sabu = :gs_sabu And Pordno = :sPordno And Opsno = :sOpseq;
	 if sqlca.sqlcode <> 0  then
		 Messagebox("��������", "�۾����� �˻��� �����߻�", stopsign!)
		 return
	 end if	  
	 if Lcnt > 0 then Continue	 	
	
	
	 tab_1.tabpage_2.dw_morout.setitem(lrow, "mgbn", 'Y')
	 p_mod.Enabled = TRUE
	 p_mod.PictureName = "C:\erpman\image\����_up.gif"
Next


end subroutine

public subroutine wf_modify_check (long lgetrow);// �۾����� ������ check�Ͽ� ���ֱ����� ������ �� �ִ��� Ȯ���Ѵ�.
Long Lrow, Lcnt
String sOpseq, sPordno


if Lgetrow < 1 then return
// ���û��°� '1', '2'�� �ƴϸ� ��ü�� �����Ұ���
if tab_1.tabpage_1.dw_momast.getitemstring(Lgetrow, "momast_old_pdsts") = '1' or &
	tab_1.tabpage_1.dw_momast.getitemstring(Lgetrow, "momast_old_pdsts") = '2' Then
else
	return 
end if


for Lrow = 1 to tab_1.tabpage_2.dw_morout.rowcount()
	 sPordno = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "momast_pordno")
	 sOpseq  = tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "morout_opseq")
	
	 // �����Ƿ� ���°� '1'�� ��쿡�� ���	
	 Lcnt = 0
	 Select count(*) into :Lcnt From Estima 
	  where sabu  = :gs_sabu And pordno = :sPordno 
	    And Opseq = :sOpseq   And blynd IN ('2', '3', '4');
	 if sqlca.sqlcode <> 0  then
		 Messagebox("��������", "�����Ƿ� �˻��� �����߻�", stopsign!)
		 return
	 end if
	 if Lcnt > 0 then Continue
	 
//	 // �Ҵ翡 ���� ������� ���� ��쿡�� ����
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Holdstock
//	  where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq And isqty > 0;
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("��������", "�Ҵ系�� �˻��� �����߻�", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
//	 
//	 // ����� ������ ���� ��쿡�� ����
//	 Lcnt = 0
//	 Select count(*) into :Lcnt From Imhist
//	  where sabu = :gs_sabu And Jakjino = :sPordno And (Opseq = :sOpseq Or Opseq = '9999');
//	 if sqlca.sqlcode <> 0  then
//		 Messagebox("��������", "�������� �˻��� �����߻�", stopsign!)
//		 return
//	 end if	  
//	 if Lcnt > 0 then Continue	 
	 
	 // �۾������� ���� ��쿡�� ����	 	 
	 Lcnt = 0
	 Select count(*) into :Lcnt From Shpact
	  where sabu = :gs_sabu And Pordno = :sPordno And Opsno = :sOpseq;
	 if sqlca.sqlcode <> 0  then
		 Messagebox("��������", "�۾����� �˻��� �����߻�", stopsign!)
		 return
	 end if	  
	 if Lcnt > 0 then Continue	 	
	
	
	 tab_1.tabpage_2.dw_morout.setitem(lrow, "mgbn", 'Y')
	 p_mod.Enabled = TRUE  // �� �߰�
	 p_mod.PictureName = "C:\erpman\image\����_up.gif"	 
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

p_low.PictureName = "C:\erpman\image\��������Ȯ��_d.gif"
p_move.PictureName = "C:\erpman\image\���������̵�_d.gif"
p_mod.PictureName = "C:\erpman\image\����_d.gif"
p_del.PictureName = "C:\erpman\image\����_d.gif"
p_inq.PictureName = "C:\erpman\image\��ȸ_up.gif"

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


 //�۾����� �� ���� üũ
SELECT COUNT(*)  
  INTO :get_count  
  FROM MOMORD  
 WHERE ( SABU   = :gs_sabu  ) AND  
		 ( PORDNO = :ar_pordno ) AND  
		 ( HQTY   > 0 )   ;

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[�۾����� �� ����]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("��ҺҰ�", "���ֿ� ����� �ڷᰡ �Ҵ������ �����մϴ�. ���ֿ����� Ȯ���ϼ���!")
		Return -1
	end if	
end if	

//���ֹ����� ��� �����Ƿڰ� �Ǿ����� ���� ���� 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[�����Ƿ�]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("��ҺҰ�", "���� �Ƿ� ����� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//�����Ƿ��� ��� �Ƿڰ� �Ǿ����� ���� ���� - �����߰� - 2001.07.21 - �ۺ�ȣ 
  SELECT COUNT(*)
    INTO :get_count  
    FROM ESTIMA  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno 
	  AND BLYND IN ('2', '3', '4');

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[�����Ƿ�]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("��ҺҰ�", "���� �Ƿ� ����� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	


//���ֹ����� ��� ���ְ� �Ǿ����� ���� ���� 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[�����ڷ�]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("��ҺҰ�", "���ֵ� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
		Return -1
	end if	
end if	


//--------------------------------------------------------------------------------------------
//���Ź����� ��� ���ְ� �Ǿ����� ���� ���� - �����߰� - 2001.07.21 - �ۺ�ȣ 
  SELECT COUNT(*)
    INTO :get_count  
    FROM POBLKT  
   WHERE SABU   = :gs_sabu 
	  AND GU_PORDNO = :ar_pordno ;

if sqlca.sqlcode < 0 then 
	If ar_msg = 'Y' then f_message_chk(41, '[�����ڷ�]')
	return -1 
else
	if get_count > 0 then 
		If ar_msg = 'Y' then messagebox("��ҺҰ�", "���ֵ� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���!")
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
		MESSAGEBOX("Ȯ ��", "���¸� ���Ƿ� ����Ϸ� ��Ű�ų� �����ų ��  �����ϴ�.")
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
			MessageBox("Ȯ ��","�԰����� �ڷᰡ �����մϴ�. �ڷḦ Ȯ���ϼ���" + "~n~n" +&
									 "���¸� �����ų �� �����ϴ�.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	
		
		get_count = 0
		// ESTIMA(�����Ƿ�)�� �Ƿ�, ���� �̰ų�
		// POBLKT(����ǰ������) ���ֻ��°� ����('1')�ÿ���  ��ҽ�ų �� ����
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM ESTIMA  
		 WHERE SABU = :gs_sabu AND PORDNO = :spordno AND BLYND IN ('1', '2') ;

		if get_count > 0 then 
			MessageBox("Ȯ ��","�����Ƿڻ��°� �Ƿ�, ������ �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���" + "~n~n" +&
									 "���¸� �����ų �� �����ϴ�.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

		get_count = 0
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM POBLKT  
		 WHERE SABU = :gs_sabu AND PORDNO = :spordno AND BALSTS = '1' ;

		if get_count > 0 then 
			MessageBox("Ȯ ��","����ǰ�������� ��������� �ڷ��Դϴ�. �ڷḦ Ȯ���ϼ���" + "~n~n" +&
									 "���¸� �����ų �� �����ϴ�.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

		get_count = 0
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM IMHIST
		 WHERE SABU = :gs_sabu AND INPCNF = 'I' AND JAKJINO = :sPordno AND IO_DATE IS NULL ;

		if get_count > 0 then 
			MessageBox("Ȯ ��","�԰������ �ȵ� �ڷᰡ �ֽ��ϴ�. �ڷḦ Ȯ���ϼ���" + "~n~n" +&
									 "���¸� �����ų �� �����ϴ�.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

	END IF

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
	MessageBox("Ȯ��","��¥�� Ȯ���ϼ���.")
	dw_head.SetColumn('frdate')
	dw_head.SetFocus()
end if

if IsNull(sTodate) or sTodate = '' then
	sTodate = '99991231'
elseif f_datechk(sTodate) = -1 then
	MessageBox("Ȯ��","��¥�� Ȯ���ϼ���.")
	dw_head.SetColumn('todate')
	dw_head.SetFocus()
	return
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	MessageBox("Ȯ��","�������� Ȯ���ϼ���.")
	dw_head.SetColumn('pdtgu')
	dw_head.SetFocus()
	return
end if

SetPointer(HourGlass!)

Choose Case tab_1.SelectedTab	
	Case 1
		if tab_1.tabpage_1.dw_momast.Retrieve(gs_sabu,sPordno,sFrdate,sTodate,sPdtgu, gs_saupj) <= 0 then
			f_message_chk(56,'[�۾����� ����]')
			p_del.Enabled = FALSe
			p_del.PictureName = "C:\erpman\image\����_d.gif"	
			tab_1.tabpage_2.Enabled = FALSE
		
			dw_head.SetColumn("pordno")
			dw_head.SetFocus()
			return
		end if
		
		p_mod.Enabled = FALSE
		p_mod.PictureName = "C:\erpman\image\����_d.gif"
		p_del.Enabled = TRUE
		p_del.PictureName = "C:\erpman\image\����_up.gif"
		p_low.Enabled = TRUE
		p_low.PictureName = "C:\erpman\image\��������Ȯ��_up.gif"
		
		this.Enabled = FALSE
		tab_1.tabpage_2.Enabled = TRUE
	// �۾������� ��ȸ��
	Case 2
		if tab_1.tabpage_2.dw_morout.Retrieve(gs_sabu,'%', sFrdate, sTodate, sPdtgu, gs_saupj) <= 0 then
			f_message_chk(56,'[�۾����� ����]')
			p_del.Enabled = FALSe
			p_del.PictureName = "C:\erpman\image\����_d.gif"	
			tab_1.tabpage_2.Enabled = FALSE
		
			dw_head.SetColumn("pordno")
			dw_head.SetFocus()
			return
		end if
		tab_1.tabpage_2.dw_morout.SetSort("morout_wkctr, morout_moseq")
		tab_1.tabpage_2.dw_morout.Sort()
		
		p_mod.Enabled = True
		p_mod.PictureName = "C:\erpman\image\����_d.gif"
		p_del.Enabled = false
		p_del.PictureName = "C:\erpman\image\����_d.gif"
		p_low.Enabled = false
		p_low.PictureName = "C:\erpman\image\��������Ȯ��_d.gif"
	Case 4
		// ��Ÿ���� ��ȸ
		tab_1.tabpage_4.dw_etc.Retrieve(gs_sabu,sFrdate,sTodate,sPdtgu)
End Choose

ib_any_typing  = FALSE

end event

type p_del from w_inherite`p_del within w_pdt_02060
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;long   		lrow, lFindrow, lCnt
string  		spordno, sformat
boolean		bErr=FALSE

//--------------------------------------------------------------------------------------------
// �۾����ø���Ÿ ���� ���õǾ��� ��
if tab_1.SelectedTab = 1 then
	IF tab_1.tabpage_1.dw_momast.AcceptText() = -1 THEN RETURN 
	if tab_1.tabpage_1.dw_momast.rowcount() <= 0 then return 	
	
	SetPointer(HourGlass!)
	FOR lrow = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(lrow,'chk_flag') = 'N' then Continue
		lCnt ++
	NEXT
	
	if lCnt < 1 then 
		MessageBox("Ȯ��","ó�� üũ�� �ڷᰡ �����ϴ�.")
		return
	end if
	
	sle_msg.text =	"�۾����� �������� üũ ��.............."
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
	
	sle_msg.text =	"�۾����� �����ڷ� ���� ��.............."	
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
	
	
	sle_msg.text =	"�۾������ڷ� ���� ��.............."	
	FOR lrow = 1 TO tab_1.tabpage_1.dw_momast.rowcount()
		if tab_1.tabpage_1.dw_momast.getitemstring(lrow,'chk_flag') = 'N' then Continue
		tab_1.tabpage_1.dw_momast.DeleteRow(lrow)
		lrow = lrow - 1
	NEXT
		
	if tab_1.tabpage_1.dw_momast.Update() = 1 then
		sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		sle_msg.text =	""	
		messagebox("��������", "�ڷḦ �����ϴµ� �����Ͽ����ϴ�")
		return 
	end if	

	p_inq.TriggerEvent(Clicked!)

//--------------------------------------------------------------------------------------------
// ������������Ÿ ���� ���õǾ��� ��
elseif tab_1.SelectedTab = 3 then
	IF tab_1.tabpage_3.dw_low.AcceptText() = -1 THEN RETURN 
	if tab_1.tabpage_3.dw_low.rowcount() <= 0 then return 	
	
	SetPointer(HourGlass!)
	FOR lrow = 1 TO tab_1.tabpage_3.dw_low.rowcount()
		if tab_1.tabpage_3.dw_low.getitemstring(lrow,'chk_flag') = 'N' then Continue
		lCnt ++
	NEXT
	
	if lCnt < 1 then 
		MessageBox("Ȯ��","ó�� üũ�� �ڷᰡ �����ϴ�.")
		return
	end if
	
	sle_msg.text =	"�۾����� �������� üũ ��.............."	
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
	
	sle_msg.text =	"�۾����� �����ڷ� ���� ��.............."	
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
	
	
	sle_msg.text =	"�۾������ڷ� ���� ��.............."	
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
		MessageBox("�����Ұ�","������ȣ: " + sformat + "�� �����ڷḦ �����ϴµ� �����Ͽ����ϴ�.")
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
	
	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
	ib_any_typing = false
	commit ;
	
	sPordno = tab_1.tabpage_3.dw_low.getitemstring(1,"momast_pordno")
	tab_1.tabpage_3.dw_low.SetRedraw(FALSE)
	tab_1.tabpage_3.dw_low.Retrieve(gs_sabu,sPordno,'%','%','%')
	tab_1.tabpage_3.dw_low.SetRedraw(TRUE)
// ��Ÿ���� ���� ���õǾ��� ��
elseif tab_1.SelectedTab = 4 then
	IF tab_1.tabpage_4.dw_etc.AcceptText() = -1 THEN RETURN 
	if tab_1.tabpage_4.dw_etc.rowcount() <= 0 then return 	
	
	lCnt= 0
	FOR lrow = 1 TO tab_1.tabpage_4.dw_etc.rowcount()
		if tab_1.tabpage_4.dw_etc.getitemstring(lrow,'chk') = 'N' then Continue
		lCnt ++
	NEXT
	
	if lCnt < 1 then 
		MessageBox("Ȯ��","ó�� üũ�� �ڷᰡ �����ϴ�.")
		return
	end if
	
	if f_msg_delete() = -1 then return
	
	sle_msg.text =	"��Ÿ�����ڷ� ���� ��.............."	
	FOR lrow = 1 TO tab_1.tabpage_4.dw_etc.rowcount()
		if tab_1.tabpage_4.dw_etc.getitemstring(lrow,'chk') = 'N' then Continue
		tab_1.tabpage_4.dw_etc.DeleteRow(lrow)
		lrow = lrow - 1
	NEXT
		
	if tab_1.tabpage_4.dw_etc.Update() = 1 then
		sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
		ib_any_typing = false
		commit ;
	else
		rollback ;
		sle_msg.text =	""	
		messagebox("��������", "�ڷḦ �����ϴµ� �����Ͽ����ϴ�")
		return 
	end if
end if
end event

type p_mod from w_inherite`p_mod within w_pdt_02060
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_mod::clicked;call super::clicked;long k, iupdate
string spordno, snew_pdsts, sold_pdsts, sopseq

//--------------------------------------------------------------------------------------------
// �۾����ø���Ÿ ���� ���õǾ��� ��
if tab_1.SelectedTab = 1 then
	if tab_1.tabpage_1.dw_momast.AcceptText() = -1 then return 
	if tab_1.tabpage_1.dw_momast.rowcount() <= 0 then	return 

	if f_msg_update() = -1 then return

	SetPointer(HourGlass!)
	w_mdi_frame.sle_msg.text = "�۾����ø���Ÿ ���� ��.........."


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
				f_message_chk(32,'[�۾����� �� ���� ������]') 	
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
				f_message_chk(32,'[�۾����� �� ���� ������]') 	
				return 
			end if	
		end if
	NEXT

	if tab_1.tabpage_1.dw_momast.update() = -1 then
		rollback;
		w_mdi_frame.sle_msg.text = ''
		f_message_chk(32,'[�ڷ�����]') 	
	else
		commit;
	end if

	w_mdi_frame.sle_msg.text = "�ڷ������� �Ϸ��Ͽ����ϴ�."

//--------------------------------------------------------------------------------------------
// �۾����ð����� ���� ���õǾ��� ��
elseif tab_1.SelectedTab = 2 then

	if tab_1.tabpage_1.dw_momast.AcceptText() = -1 then return
	if tab_1.tabpage_2.dw_morout.AcceptText() = -1 then return
	if tab_1.tabpage_2.dw_morout.RowCount() < 1 then return


	// Detail���� check
	IF wf_required_chk_dtl() = -1 THEN 
		Rollback;
		RETURN
	End if

	if f_msg_update() = -1 then return
	
	SetPointer(HourGlass!)
	w_mdi_frame.sle_msg.text = "�۾����� ���������� ���� ��.........."
	
	if tab_1.tabpage_2.dw_morout.update() = -1 Then
		rollback;
		w_mdi_frame.sle_msg.text = ''
		f_message_chk(32,'[�ڷ�����]') 	
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
	w_mdi_frame.sle_msg.text = "�ڷ������� �Ϸ��Ͽ����ϴ�."
	
	tab_1.selecttab(1)
	tab_1.selecttab(2)	
// ��Ÿ����
elseif tab_1.SelectedTab = 4 then
	if tab_1.tabpage_4.dw_etc.AcceptText() = -1 then return

	if tab_1.tabpage_4.dw_etc.update() = -1 Then
		rollback;
		w_mdi_frame.sle_msg.text = ''
		f_message_chk(32,'[�ڷ�����]') 	
		return
	else
		commit;
	end if
	
	ib_any_typing =FALSE
	w_mdi_frame.sle_msg.text = "�ڷ������� �Ϸ��Ͽ����ϴ�."
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
		MessageBox("Ȯ��","��¥�� Ȯ���ϼ���.")
		this.SetItem(1,'frdate',snull)
		return 1
	end if


elseif this.getcolumnname() = 'todate' then
	sdata = this.gettext()
	
	if IsNull(sdata) or sdata = '' then return
	
	if f_datechk(sdata) = -1 then
		MessageBox("Ȯ��","��¥�� Ȯ���ϼ���.")
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
string facename = "����ü"
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

	// ��������Ÿ�� ��ȸ���� ���� ���� skip
	If this.tabpage_1.dw_momast.RowCount() <= 0 Then Return
	
	lRow = this.tabpage_1.dw_momast.GetSelectedRow(0)
	if lRow <= 0 then
		tab_1.tabpage_2.dw_morout.reset()
		tab_1.tabpage_2.dw_estima.reset()		
		tab_1.tabpage_2.dw_poblkt.reset()
	   MessageBox("Ȯ��","�ڷḦ �����ϼ���.")
	   return 1
	end if
	
	SetPointer(HourGlass!)
	sPordno = this.tabpage_1.dw_momast.GetItemString(lRow,'momast_pordno')
	
	p_mod.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\����_d.gif"
	if this.tabpage_2.dw_morout.Retrieve(gs_sabu,sPordno,'10000101','99991231') > 0 then
		wf_modify_check(lRow)
	end if
	
	p_low.Enabled = FALSE
	p_low.PictureName = "C:\erpman\image\��������Ȯ��_d.gif"		
	p_move.Enabled = FALSE
	p_move.PictureName = "C:\erpman\image\���������̵�_d.gif"		
	p_del.Enabled = FALSE
	p_del.PictureName = "C:\erpman\image\����_d.gif"
	
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
	p_low.PictureName = "C:\erpman\image\��������Ȯ��_up.gif"			
	p_del.Enabled = TRUE
	p_del.PictureName = "C:\erpman\image\����_up.gif"		
elseif newindex = 3 then
	p_mod.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\����_d.gif"	
elseif newindex = 4 then
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\����_up.gif"
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
string text = "��������Ÿ"
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
p_mod.PictureName = "C:\erpman\image\����_up.gif"

Long   Lrow
String sdata, sprv, spordno

Lrow = getrow()

if getcolumnname() = 'momast_pdsts' then
	sPrv  = getitemstring(Lrow, "momast_pdsts")
	sData = gettext()
	sPordno = getitemstring(Lrow, "momast_pordno")
	
	if sData = '3' then
		Messagebox("���û���", "����Ϸ�� �ý��ۿ��� �����մϴ�", stopsign!)
		setitem(Lrow, "momast_pdsts", sprv)
		return 1
	end if;
	
	if wf_cancel_check(spordno,'Y') = -1 then
		Messagebox("���û���", "�������� �ڷḦ ���� �����Ͻʽÿ�.", stopsign!)
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
string text = "������"
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
string facename = "����ü"
string text = "��ȸ"
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
	MessageBox("Ȯ��","��¥�� Ȯ���ϼ���.")
	dw_head.SetColumn('frdate')
	dw_head.SetFocus()
end if

if IsNull(sTodate) or sTodate = '' then
	sTodate = '99991231'
elseif f_datechk(sTodate) = -1 then
	MessageBox("Ȯ��","��¥�� Ȯ���ϼ���.")
	dw_head.SetColumn('todate')
	dw_head.SetFocus()
	return
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	MessageBox("Ȯ��","�������� Ȯ���ϼ���.")
	dw_head.SetColumn('pdtgu')
	dw_head.SetFocus()
	return
end if

SetPointer(HourGlass!)

// �۾������� ��ȸ��
if tab_1.tabpage_2.dw_morout.Retrieve(gs_sabu,'%', sFrdate, sTodate, sPdtgu, gs_saupj) <= 0 then
	f_message_chk(56,'[�۾����� ����]')
	p_del.Enabled = FALSe
	p_del.PictureName = "C:\erpman\image\����_d.gif"	
	tab_1.tabpage_2.Enabled = FALSE

	dw_head.SetColumn("pordno")
	dw_head.SetFocus()
	return
end if
tab_1.tabpage_2.dw_morout.SetSort("morout_wkctr, morout_moseq")
tab_1.tabpage_2.dw_morout.Sort()

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\����_d.gif"
p_del.Enabled = false
p_del.PictureName = "C:\erpman\image\����_d.gif"
p_low.Enabled = false
p_low.PictureName = "C:\erpman\image\��������Ȯ��_d.gif"

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
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "#.Double Click�� ��������, �߰�, ������ �� �� �����ϴ�. ( �� ���������� �ִ� ��쿡�� ������ �� �����ϴ� )"
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
	
	ireturn = f_get_name2('�۾���', 'Y', scode, sname, sname2) 
	this.setitem(lrow, "morout_wkctr", scode)
	this.setitem(lrow, "wrkctr_wcdsc", sname)
	if isnull(scode) or trim(sCode) = '' then
		this.setitem(Lrow, "morout_wkctr", sprvcode)
		this.setitem(Lrow, "wrkctr_wcdsc", sprvname)	
		this.setitem(Lrow, "morout_jocod", sprvjo)		
	Else
		select jocod into :sjocod from wrkctr where wkctr = :scode;
		if isnull(sJocod) or trim(sJocod) = '' then
			Messagebox("��", "�۾��忡 ���� ���� �����ϴ�", stopsign!)
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
		Messagebox("�ܰ�", "�ܰ��� Ȯ���Ͻʽÿ�", stopsign!)
		return 1
	end if
// �۾���
elseif this.getcolumnname() = "morout_etc_inwon_nm" then
	sName = Trim(GetText())
	If MessageBox('Ȯ��','�۾��ڸ� �����Ͻðڽ��ϱ�?', Information!, YesNo!, 1) = 2 Then Return 2
	
	sPordno = GetItemString(lrow, 'morout_pordno')
	sOpseq  = GetItemString(lrow, 'morout_opseq')
	sName2  = GetItemString(lrow, 'morout_wkctr')
	
	UPDATE MOROUT_ETC SET INWON_NM = :sName, WKCTR = :sName2
	 WHERE SABU = :gs_sabu
	   AND PORDNO = :sPordno
		AND OPSEQ = :sOpseq;

	COMMIT;
// �ٹ�Ÿ��
elseif this.getcolumnname() = "morout_etc_kuntype" then
	sName = Trim(GetText())
	If MessageBox('Ȯ��','�ٹ����¸� �����Ͻðڽ��ϱ�?', Information!, YesNo!, 1) = 2 Then Return 2
	
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
//	messagebox("��������", "���������� ������ �� �����ϴ�")
//	return
//end if
// 
//ii =  Messagebox("��������", "������ �����Ͻð����ϱ�?" + '~n' + &
//     			                 "��������(��), �����߰�(�ƴϿ�), �۾����(���)", question!, yesnocancel!)
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
string text = "������������Ÿ"
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
string text = "��Ÿ����"
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
string picturename = "C:\erpman\image\��������Ȯ��_d.gif"
end type

event clicked;call super::clicked;Long		lRow
String	sPordno

lRow = tab_1.tabpage_1.dw_momast.GetSelectedRow(0)
if lRow <= 0 then
	MessageBox("Ȯ��","�ڷḦ �����ϼ���.")
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
	p_mod.PictureName = "C:\erpman\image\����_d.gif"	
	p_del.Enabled = FALSE
	p_mod.PictureName = "C:\erpman\image\����_d.gif"		
	return
end if

tab_1.tabpage_3.dw_low.SetRedraw(TRUE)

ib_any_typing  = FALSE
p_mod.Enabled = FALSE
p_del.Enabled = TRUE
this.Enabled   = FALSE
p_move.Enabled = TRUE

p_mod.PictureName = "C:\erpman\image\����_d.gif"
p_del.PictureName = "C:\erpman\image\����_up.gif"
this.PictureName   = "C:\erpman\image\��������Ȯ��_d.gif"
p_move.PictureName = "C:\erpman\image\���������̵�_up.gif"



end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\��������Ȯ��_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\��������Ȯ��_dn.gif'
end event

type p_move from uo_picture within w_pdt_02060
boolean visible = false
integer x = 352
integer y = 24
integer width = 306
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\���������̵�_d.gif"
end type

event clicked;call super::clicked;String	sFilter
Long		lRow


tab_1.SelectTab(1)
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_1.Enabled = TRUE
tab_1.tabpage_2.Enabled = TRUE
tab_1.tabpage_3.Enabled = FALSE



//--------------------------------------------------------------------------------------------
// ��������Ÿ datawindow SQL������ ��ȸ
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

p_mod.PictureName = "C:\erpman\image\����_d.gif"
p_del.PictureName = "C:\erpman\image\����_up.gif"
p_inq.PictureName   = "C:\erpman\image\��ȸ_d.gif"
this.PictureName = "C:\erpman\image\���������̵�_d.gif"


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\���������̵�_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\���������̵�_dn.gif'
end event

type p_1 from uo_picture within w_pdt_02060
boolean visible = false
integer x = 4448
integer y = 176
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\ǰ���߰�_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\ǰ���߰�_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\ǰ���߰�_dn.gif'
end event

event clicked;call super::clicked;String sMsg, sPdtgu

If dw_head.AcceptText() <> 1 Then Return
sPdtgu = Trim(dw_head.GetItemString(1, 'pdtgu'))
If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400,'[������]')
	Return
End If

gs_gubun = sPdtgu
open(w_pdt_02060_1)
sMsg = message.stringparm
if sMsg = 'Y' then
	p_inq.TriggerEvent(Clicked!)
End if

SetNull(gs_code)			// �۾����ù�ȣ
SetNull(gs_codename)		// �����ڵ�
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
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "���� �ϰ� ����"
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
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�ϰ� �����Ϸ�"
end type

event clicked;Long ix
string sPordno

SetPointer(HourGlass!)

For ix = 1 To tab_1.tabpage_1.dw_momast.RowCount()
	// ���°� ������ ��츸 �����Ϸ� ����
	If tab_1.tabpage_1.dw_momast.GetItemString(ix, 'momast_pdsts') = '1' Then
		
		sPordno = tab_1.tabpage_1.dw_momast.getitemstring(ix, "momast_pordno")
	
		if wf_cancel_check(spordno,'N') = -1 then Continue
	
		tab_1.tabpage_1.dw_momast.SetItem(ix, 'momast_pdsts', '4')
	End If
Next
end event

