$PBExportHeader$w_mm01_00010.srw
$PBExportComments$** ���� ���� ó�� ( ��� )
forward
global type w_mm01_00010 from w_inherite
end type
type dw_detail from datawindow within w_mm01_00010
end type
type rb_insert from radiobutton within w_mm01_00010
end type
type rb_delete from radiobutton within w_mm01_00010
end type
type cbx_2 from checkbox within w_mm01_00010
end type
type cbx_1 from checkbox within w_mm01_00010
end type
type cbx_3 from checkbox within w_mm01_00010
end type
type p_1 from picture within w_mm01_00010
end type
type dw_imhist_nitem_in from datawindow within w_mm01_00010
end type
type dw_imhist_nitem_out from datawindow within w_mm01_00010
end type
type dw_imhist_out from datawindow within w_mm01_00010
end type
type pb_1 from u_pb_cal within w_mm01_00010
end type
type dw_print from datawindow within w_mm01_00010
end type
type cbx_wall from checkbox within w_mm01_00010
end type
type cbx_print from checkbox within w_mm01_00010
end type
type rr_1 from roundrectangle within w_mm01_00010
end type
type rr_2 from roundrectangle within w_mm01_00010
end type
type rr_4 from roundrectangle within w_mm01_00010
end type
type rr_3 from roundrectangle within w_mm01_00010
end type
type dw_list from datawindow within w_mm01_00010
end type
type p_sort from picture within w_mm01_00010
end type
type cb_1 from commandbutton within w_mm01_00010
end type
type st_2 from statictext within w_mm01_00010
end type
type dw_imhist from datawindow within w_mm01_00010
end type
type dw_autoimhist from datawindow within w_mm01_00010
end type
type cbx_move from checkbox within w_mm01_00010
end type
type cbx_io_confirm from checkbox within w_mm01_00010
end type
end forward

global type w_mm01_00010 from w_inherite
integer width = 4686
integer height = 3236
string title = "�����԰� �Ƿڵ��(SCM)"
boolean controlmenu = false
dw_detail dw_detail
rb_insert rb_insert
rb_delete rb_delete
cbx_2 cbx_2
cbx_1 cbx_1
cbx_3 cbx_3
p_1 p_1
dw_imhist_nitem_in dw_imhist_nitem_in
dw_imhist_nitem_out dw_imhist_nitem_out
dw_imhist_out dw_imhist_out
pb_1 pb_1
dw_print dw_print
cbx_wall cbx_wall
cbx_print cbx_print
rr_1 rr_1
rr_2 rr_2
rr_4 rr_4
rr_3 rr_3
dw_list dw_list
p_sort p_sort
cb_1 cb_1
st_2 st_2
dw_imhist dw_imhist
dw_autoimhist dw_autoimhist
cbx_move cbx_move
cbx_io_confirm cbx_io_confirm
end type
global w_mm01_00010 w_mm01_00010

type variables
boolean 	  ib_ItemError
char 		  ic_status
string 	  is_Last_Jpno, is_Date
String     is_RateGub       //ȯ�� ��뿩��(1:����,2:����)            
String     is_qccheck         //�˻��������
String     is_cnvart             //��ȯ������
String     is_gubun             //��ȯ�����뿩��
string     is_ispec, is_jijil  //�԰�, ������
string	  is_barmode
long		  il_count
end variables

forward prototypes
public function integer wf_set_janqty (long ar_row, string ar_gubun)
public function integer wf_rate_chk ()
public function integer wf_update_gubun ()
public function integer wf_imhist_delete_nitem (long arg_row)
public function integer wf_imhist_delete ()
public function integer wf_imhist_create_nitem ()
public function integer wf_poblkt_update ()
public function integer wf_imhist_create_waiju ()
public function integer wf_imhist_create (ref string rsdate, ref decimal rdseq)
public function integer wf_waiju (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun)
public function integer wf_checkrequiredfield ()
public function integer wf_initial ()
public function integer wf_calc_amount ()
public function integer wf_setfilter ()
public function integer wf_danmst ()
public subroutine wf_print ()
public function integer wf_imhist_update ()
public function integer wf_imhist_update_waiju ()
public function integer wf_automoveout (integer arg_rownum, datawindow arg_imhistdw, string arg_date, string arg_iojpno, string arg_qcgubn)
end prototypes

public function integer wf_set_janqty (long ar_row, string ar_gubun);///////////////////////////////////////////////////////////////////////////////////////////
// 2000/03/30 ����� - ��ȯ ��� ���ø� �����  
// ���ִ����� �ܷ��� ���ִ��� �԰� ������ ���� ��� �԰���� �ܷ��� ��ȯ�Ͽ� �����Ѵ�.
// �����԰��� ���� ����ǰ�������� ��ȯ���ּ��� - (��ȯ�˻��� + ��ȯ�հݼ���) ������ SET 
// B/L �԰��� ���� B/L��ȣ�� ���ֹ�ȣ�� ã�Ƽ� ���ֿ� �ٸ� B/L�� ã�Ƽ� ��� �԰�Ǿ�����
//            ���θ� üũ�Ͽ� �������̸� ���� ������� ������ SETTING
// Argument => ar_Gubun�� '1'�̸� ���� '2'�̸� ������
///////////////////////////////////////////////////////////////////////////////////////////

dw_detail.Accepttext()

string  	sMaigbn, sGubun, sLocal 
Dec{3}   dcnvjan, dcnvqty, djanqty, dqty, dTEMP_QTY  

SetPointer(HourGlass!)  

sGubun = dw_detail.getitemstring(1, "gubun")

Select maigbn, ioyea2 into :sMaigbn, :sLocal from iomatrix
 where sabu = :gs_sabu and iogbn = :sGubun;
 
if sqlca.sqlcode <> 0 then
	Messagebox("�԰���", "�԰����� ����Ȯ�մϴ�")
	return -1
end if;

IF ar_gubun = '1'	THEN		//���ֿ��� �԰��Ƿڽ� 
	dcnvJan = dw_list.GetItemDecimal(ar_row, 'cnv_balju')   //��ȯ���� or B/L �ܷ�
	dJanqty = dw_list.GetItemDecimal(ar_row, 'balju')       //���� or B/L �ܷ�

	IF sMaigbn = '1'	THEN		// �����԰�(���Ծƴ�)
		dw_list.setitem(ar_row, "inqty", djanqty)
	ELSE
   	dcnvqty = dw_list.GetItemDecimal(ar_row, 'cnv_janqty')   //��ȯ���� �ܷ�
   	dqty    = dw_list.GetItemDecimal(ar_row, 'janqty')       //���� �ܷ�
		
		if dcnvjan = dcnvqty then 
   		dw_list.setitem(ar_row, "inqty", dqty)
		else
			return 0
		end if
	END IF
ELSE //�԰��ڷ� ������
	dcnvJan = dw_list.GetItemDecimal(ar_row, 'cnv_balju')   //��ȯ���� or B/L �ܷ�
	dJanqty = dw_list.GetItemDecimal(ar_row, 'balju')       //���� or B/L �ܷ�

   dtemp_qty = dw_list.GetItemDecimal(ar_row, "TEMP_QTY")   //�԰��Ƿ� ����(�԰����)
	IF sMaigbn = '1'	THEN		// �����԰�(���Ծƴ�)
		dw_list.setitem(ar_row, "imhist_ioreqty", djanqty + dtemp_qty)
	ELSE
   	dcnvqty = dw_list.GetItemDecimal(ar_row, 'cnv_janqty')   //��ȯ���� �ܷ�
   	dqty    = dw_list.GetItemDecimal(ar_row, 'janqty')       //���� �ܷ�

		
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

public function integer wf_rate_chk ();string s_today
long   get_count
 
s_today  = dw_detail.getitemstring(1, 'sdate')	

IF is_RateGub = '1' then  
	 SELECT COUNT(*)
		INTO :get_count
		FROM RATEMT  
	  WHERE RDATE = :s_today  ;	
	if get_count < 1 then 		
		messagebox("Ȯ ��", "���� ȯ���� ���� �Է��ؾ� �մϴ�.")
		return -1
	end if	
ELSE
	SELECT COUNT(*)
	  INTO :get_count
	  FROM EXCHRATE_FORECAST
	 WHERE BASE_YYMM = SUBSTR(:s_today, 1, 6) ;
	
	if get_count < 1 then 		
		messagebox("Ȯ ��", "���� ȯ���� ���� �Է��ؾ� �մϴ�.")
		return -1
	end if	
END IF

RETURN 1
end function

public function integer wf_update_gubun ();long		lRow, lCount
string	sQcgubun, sQcdate, sIoConfirm, sIoDate, sMagub, sBlno

string   sittyp, sitcls, scvcod, sitnbr, sPspec, spdayn

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

if ic_status <> '1' then

//	FOR  lRow = 1	TO	lCount
//		// �˻籸��, �˻������Է½� �����Ұ�
//		sQcgubun = dw_list.GetItemString(lRow, "qcgubun")
//		sQcdate  = dw_list.GetItemString(lRow, "imhist_insdat")
//		
//		dw_list.SetItem(lRow, "updategubun", 'Y')
//		
//		IF sQcgubun > '1'	THEN
//			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
//		END IF
//		
//		dw_list.setitem(lRow, "qcsugbn", is_qccheck)		// �˻籸�� ��������
//	NEXT

	FOR  lRow = 1	TO	lCount
		// �˻籸��, �˻������Է½� �����Ұ�
		sQcgubun = dw_list.GetItemString(lRow, "qcgubun")
		sQcdate  = dw_list.GetItemString(lRow, "imhist_insdat")
		spdayn   = left(dw_list.GetItemString(lRow, "imhist_iojpno"),1)
	If spdayn = 'P' then //pda���� �������� ó��
		dw_list.SetItem(lRow, "updategubun", 'Y')
   Else
		dw_list.SetItem(lRow, "updategubun", 'Y')
	
		if sMagub = 'Y' then 
			dw_list.SetItem(lRow, "blmagub", 'Y')
		end if
		
		IF sQcgubun > '1'	THEN
			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
		END IF
		
		// ���ҽ��ο���, ���������Է½� �����Ұ�
		sIoConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
		sIoDate    = dw_list.GetItemString(lRow, "imhist_io_date")
		IF sIoConfirm = 'N'	THEN
			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
		END IF
		
		// ������ ��� �����԰�CHECK
		IF dw_list.getitemstring(LRow, "shpgu") = 'N' then
			dw_list.SetItem(lRow, "updategubun", 'N')			
		end if
	 End If
		dw_list.setitem(lRow, "qcsugbn", is_qccheck)		// �˻籸�� ��������
	NEXT
END IF

RETURN 1


end function

public function integer wf_imhist_delete_nitem (long arg_row);long		lrow
string	sitnbr, sitnbryd, siojpno, soutjpno, sinjpno

if arg_row < 1 then return 1

// ��ǰ�� �ڷḸ ó��
sitnbr = dw_list.GetItemString(arg_row, "itnbr")
select itnbryd into :sitnbryd from item_rel
 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
if sqlca.sqlcode <> 0 then return 1

siojpno = dw_list.getitemstring(arg_row,'imhist_iojpno')


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

public function integer wf_imhist_delete ();string	sIo_gubun ,sHist_jpno, sjpno, sWigbn, sError, sgubun, sOpseq, sNull, sqcgubun, sBlno, smagub
long		lRow, lRowCount, i, k
Long		lbalseq
String	ls_gbn, ls_baljpno, sqcgub
Decimal	dcbalqty

Setnull(sNull)

lRowCount = dw_list.RowCount()

//Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sGubun;
//
//If sqlca.sqlcode <> 0 then
//	ROLLBACK;
//	f_message_chk(311,'[���ֿ���]')
//	return -1
//end if

FOR  lRow = lRowCount 	TO		1		STEP  -1
	i++
	if dw_list.getitemstring(lrow, "del") <> 'Y' then continue

	/* �˻� �Ǵ� ���ε� �ڷ�� �����Ұ� */
	if dw_list.getitemstring(lrow, "updategubun") = 'N' then continue
	
	sHist_Jpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
	sgubun		= dw_list.GetItemString(lRow, "imhist_iogbn")
	ls_gbn		= dw_list.GetItemString(lRow, "gungbn")
	ls_baljpno	= dw_list.GetItemString(lRow, "baljpno")
	lbalseq		= dw_list.GetItemDecimal(lRow, "balseq")

	sqcgub		= dw_list.GetItemString(lRow, "qcgubun")
	
	// �԰��� ���� ����.
	if	ls_gbn = 'M' and sqcgub > '1' 	then
		dcbalqty		= dw_list.GetItemDecimal(lRow, "imhist_ioreqty")
	
		update poblkt
			set vndinqty = vndinqty - :dcbalqty,
			    balsts   = '1'
		 where sabu = :gs_sabu and baljpno = :ls_baljpno
			and balseq = :lbalseq ;
		if sqlca.sqlcode <> 0  then
			MessageBox('����Ȯ��', 'NOT SCM  ���ּ����� ERROR !.')
			rollback;
			return -1
		end if	
	end if
	
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
	sQcGubun  =  dw_list.GetItemString(lRow, "qcgubun")
	sOpseq    =  dw_list.GetItemString(lRow, "imhist_opseq")
	
	IF sOpseq <> '9999' and sqcgubun = '1' THEN
		if wf_waiju(Lrow, 0, sNull, 0, sHist_jpno, sOpseq, 0, snull, sNull, 'D') = -1 then
			return -1
		end if
	END IF			

	if dw_list.getitemstring(lrow, "imhist_filsk") = 'N' then
	  DELETE FROM IMHIST  
   	WHERE ( TRIM(SABU) = :gs_sabu ) 	AND  
        		( IP_JPNO = :sHist_Jpno )  AND
				( JNPCRT  = '008' ) ;
		if SQLCA.SQLCODE < 0 then
			Rollback;
			MessageBox('����Ȯ��', '�ڵ����� ��ǥ������ �����Ͽ����ϴ�.')
			return -1
		end if;
	end if
	

	/* ���ְ��� �Ǵ� �����԰��� ��쿡�� ������� �ڵ������ڷ� ����
		-. �� �˻����ڰ� �ִ� ��쿡 �� �� - 2004.01.07 - �ۺ�ȣ */
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sGubun;

	if sWigbn = 'Y' Then
//		sError = 'X';
		sqlca.erp000000360(gs_sabu, sHist_Jpno, 'D', sError);	/* ���� */
		if sError = 'X' or sError = 'Y' then
			Rollback;
			f_message_chk(41, '[�����ڵ����]')
			return -1
		end if;
	end if;	
	
	/*����̵�����ڷ� ���� */
	/*2016.01.21 �ŵ���*/
	IF IsNull(sHist_Jpno) = False Then
		String ls_om6jpno, ls_im7jpno, ls_o25jpno
		
		SELECT IOJPNO
		    INTO :ls_om6jpno
		   FROM IMHIST
		 WHERE IOGBN = 'OM7'
			 AND IP_JPNO = :sHist_Jpno;
			
		SELECT IOJPNO
		    INTO :ls_im7jpno
	 	   FROM IMHIST
		 WHERE IOGBN = 'IM7'
		      AND IP_JPNO = :ls_om6jpno;
			 
	    if IsNull(ls_im7jpno) = False Then
             SELECT IOJPNO
		        INTO :ls_o25jpno
		      FROM IMHIST
		     WHERE IOGBN = 'O25'
			     AND IP_JPNO = :ls_im7jpno;
				  
		    DELETE FROM IMHIST WHERE IOGBN = 'I13' AND IP_JPNO = :ls_o25jpno;
		    DELETE FROM IMHIST WHERE IOGBN = 'O25' AND IOJPNO = :ls_o25jpno AND IP_JPNO = :ls_im7jpno;
	    End if
		
		DELETE FROM IMHIST WHERE IOGBN = 'IM7' AND IP_JPNO = :ls_om6jpno;
		DELETE FROM IMHIST WHERE IOGBN = 'OM7' AND IOJPNO = :ls_om6jpno;
		
		if SQLCA.SQLCODE < 0 then
			Rollback;
			MessageBox('����Ȯ��', '����̵���� �ڷ� ���� ����.')
			return -1
		end if;
	End If
	
	
	///��ǰ���-��ǰ�԰� ��ǥ����////////////////////////////////////////////////
	//wf_imhist_delete_nitem(lRow)

	dw_list.DeleteRow(lRow)
	k++
NEXT

IF k < 1 Then
	messagebox("Ȯ ��", "���� �� �ڷḦ �����ϼ���.!")
	Return -1
END IF

if i = k then return -2  //��ü �����Ǿ����� ȭ�� reset

RETURN 1
end function

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

dw_detail.AcceptText()
dw_list.AcceptText()

sDate = trim(dw_detail.getitemstring(1,'Tdate'))

FOR lRow = 1 TO dw_list.RowCount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	if dw_list.GetItemString(lrow, "qcgubun") <> '1' then continue
	
	// ��ǰ�� �ڷḸ ó��
	sitnbr = dw_list.GetItemString(lRow, "itnbr")
	select itnbryd into :sitnbr_in from item_rel
	 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
	if sqlca.sqlcode <> 0 then continue

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
	EXIT
NEXT

//COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(dSeq, "0000")
sEmpno = dw_detail.GetItemString(1, "empno")				// �԰��Ƿ���

dw_imhist_nitem_out.reset()
dw_imhist_nitem_in.reset()

siogbn	 = 'O25'		// ǰ���ü���
sjnpcrt	 = '001'
sIogbn_in = 'I13'		// ǰ���ü�԰�
sjnpcrt_in= '011'


FOR lRow = 1 TO dw_list.RowCount()
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	if dw_list.GetItemString(lrow, "qcgubun") <> '1' then continue
	
	// ��ǰ�� �ڷḸ ó��
	sitnbr = dw_list.GetItemString(lRow, "itnbr")
	select itnbryd into :sitnbr_in from item_rel
	 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
	if sqlca.sqlcode <> 0 then continue
	
	lRowOut = dw_imhist_nitem_out.InsertRow(0)

	sVendor = dw_list.GetItemString(lRow, "vendor")
	sinjpno = dw_list.GetItemString(lRow, "injpno")

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
	 WHERE CVGU = '5' AND SOGUAN = '1' AND IPJOGUN = :gs_saupj ;
	if sqlca.sqlcode <> 0 then	sdepot_in = 'Z01'		// ����â��
	
	dw_imhist_nitem_out.SetItem(lRowOut, "cvcod",	sdepot_in)
	dw_imhist_nitem_out.SetItem(lRowOut, "ioqty",  	dw_list.GetItemDecimal(lRow, "inqty"))
	dw_imhist_nitem_out.SetItem(lRowOut, "ioprc",	0)
	dw_imhist_nitem_out.SetItem(lRowOut, "ioreqty",	dw_list.GetItemDecimal(lRow, "inqty"))
	dw_imhist_nitem_out.SetItem(lRowOut, "insdat",	sDate)
	dw_imhist_nitem_out.SetItem(lRowOut, "iosuqty",	dw_list.GetItemDecimal(lRow, "inqty"))

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
	dw_imhist_nitem_out.SetItem(lRowOut, "saupj",	dw_list.GetitemString(lRow, "poblkt_saupj"))	
	

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
	dw_imhist_nitem_in.SetItem(lRowIn, "ioqty",   	dw_list.GetItemDecimal(lRow, "inqty"))
	dw_imhist_nitem_in.SetItem(lRowIn, "ioprc",		0)
	dw_imhist_nitem_in.SetItem(lRowIn, "ioreqty",	dw_list.GetItemDecimal(lRow, "inqty"))
	dw_imhist_nitem_in.SetItem(lRowIn, "insdat",		sDate)
	dw_imhist_nitem_in.SetItem(lRowIn, "iosuqty", 	dw_list.GetItemDecimal(lRow, "inqty"))

	dw_imhist_nitem_in.SetItem(lRowIn, "io_empno",	sNull)
	dw_imhist_nitem_in.SetItem(lRowIn, "io_confirm", sSaleYn)
	dw_imhist_nitem_in.SetItem(lRowIn, "io_date", 	sDate)
	dw_imhist_nitem_in.SetItem(lRowIn, "filsk", 		'N')
	dw_imhist_nitem_in.SetItem(lRowIn, "bigo",  		'�����԰� ��ǰ �ڵ� �԰�')
	dw_imhist_nitem_in.SetItem(lRowIn, "ip_jpno", 	sJpno + string(lRowOut, "000"))
	dw_imhist_nitem_in.SetItem(lRowIn, "ioreemp", 	sEmpno)
	dw_imhist_nitem_in.SetItem(lRowIn, "ioredept",	sDeptcode)
	dw_imhist_nitem_in.SetItem(lRowIn, "saupj",		dw_list.GetitemString(lRow, "poblkt_saupj"))	
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

public function integer wf_poblkt_update ();long  lrow, lbalseq, ll_err
string status1, status2, sbaljpno, ls_saupj, ls_err
decimal dbalqty, djanqty, dinqty, dcbalqty

ls_saupj = dw_detail.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('Ȯ��', '���� ������� ���� �Ͻʽÿ�')
	dw_detail.SetFocus()
	dw_detail.SetColumn('saupj')
	Return -1
End If

FOR lrow = 1 TO dw_list.rowcount()
 status1 = dw_list.getitemstring(lrow,'poblkt_balsts')
 status2 = dw_list.getitemstring(lrow,'status')
 dbalqty = dw_list.getitemnumber(lrow,'balqty')
 djanqty = dw_list.getitemnumber(lrow,'balju') // �ܷ�
 If ic_status = '1' Then
	dinqty  = dw_list.getitemnumber(lrow,'inqty') // ���Ϸ�
 Else
	dinqty  = dw_list.getitemnumber(lrow,'imhist_ioreqty') // ���Ϸ�
 End If
 
 if status1 = status2 then continue
 
 sbaljpno = dw_list.getitemstring(lrow,'baljpno')
 lbalseq = dw_list.getitemnumber(lrow,'balseq')
 
 if status1 = '3' then // ���ֻ���-�����Ϸ� , 2 �� �ý��� �ڵ��Ϸ�� ��� - 2004.02.07 - �ۺ�ȣ
  dcbalqty = dbalqty - djanqty + dinqty
 else
  dcbalqty = dbalqty
 end if  
  
 update poblkt
  set balsts = :status1, cnvqty = :dcbalqty
  where sabu = :gs_sabu and baljpno = :sbaljpno
    and balseq = :lbalseq and saupj = :ls_saupj ;
 if sqlca.sqlcode <> 0 then
	ll_err = sqlca.sqldbcode ; ls_err = sqlca.sqlerrtext
	rollback using sqlca;
	messagebox('update err [' + string(ll_err) + ']', '�ڷ� ó�� �� ������ �߻� �߽��ϴ�.[-20011]~r~n' + ls_err)
	return -1
 end if
NEXT

//COMMIT ;

return 1

//long		lrow, lbalseq
//string	status1, status2, sbaljpno, sdtime, sqcgub
//decimal	dbalqty, djanqty, dinqty, dcbalqty, dnaqty
//
//IF ic_status = '1' THEN
//	FOR lrow = 1 TO dw_list.rowcount()
//		status1 	= dw_list.getitemstring(lrow,'poblkt_balsts')
//		dbalqty 	= dw_list.getitemnumber(lrow,'balqty')
//		djanqty 	= dw_list.getitemnumber(lrow,'balju')	// �ܷ�
//		dinqty  	= dw_list.getitemnumber(lrow,'inqty')	// ���Ϸ�
//		dnaqty  	= dw_list.getitemnumber(lrow,'naqty')	// ��ǰ��
//		sdtime	= dw_list.getitemstring(lrow,'dtime')  //��߽ð�
//		sqcgub	= dw_list.getitemstring(lrow,'qcgubun')  //�˻籸��
//		
//		if	dinqty = 0  	then  continue
//		
//		sbaljpno = dw_list.getitemstring(lrow,'baljpno')
//		lbalseq	= dw_list.getitemnumber(lrow,'balseq')
//		
//	//--- ���ó���� �ѰͿ� ���ؼ��� �ڵ�����(vndinqty)���� ������ ��Ÿ�� ���ܵǹǷ�...
//	//  IMHIST---> gungbn = 'M'  ( ���˻�� ���� )
//	//	if	(dnaqty = 0	 or isNull(sdtime)  or sdtime = '') ANd sqcgub > '1'  then	
//		if	(dnaqty = 0	 or isNull(sdtime)  or sdtime = '') then	
//			update poblkt
//				set cnvqty = :dinqty, 
//					 vndinqty = vndinqty + :dinqty
////					 balsts = :status1
//			 where sabu = :gs_sabu and baljpno = :sbaljpno
//				and balseq = :lbalseq ;
//	
//			if sqlca.sqlcode <> 0  then
//				MessageBox('����Ȯ��', 'NOT SCM  ���ּ����� ERROR !.')
//				rollback;
//				return -1
//			end if	
//				
//		end if;	
//		
//	NEXT
//Else
//	FOR lrow = 1 TO dw_list.rowcount()
//		sbaljpno = dw_list.getitemstring(lrow,'baljpno')
//		lbalseq	= dw_list.getitemnumber(lrow,'balseq')
////      status2 	= dw_list.getitemstring(lrow,'poblkt_balsts')
//			update poblkt
//				set cnvqty = rcqty, 
//					 vndinqty = rcqty
////					 balsts = :status2
//			 where sabu = :gs_sabu and baljpno = :sbaljpno
//				and balseq = :lbalseq ;
//	
//			if sqlca.sqlcode <> 0  then
//				MessageBox('����Ȯ��', 'NOT SCM  ���ּ����� ERROR !.')
//				rollback;
//				return -1
//			end if	
//	Next
//
//End If
//
////COMMIT ;
//
//return 1
end function

public function integer wf_imhist_create_waiju ();///////////////////////////////////////////////////////////////////////
//	* �԰������ ���� �ڵ������� ������� �ۼ�
///////////////////////////////////////////////////////////////////////
string	sDate, 		&
			sEmpno,		&
			sVendor,		&
			sGubun,		&
			sQcGubun,	&
			sQcEmpno, sNull, sIojpno, sOpseq,ls_host_gubun, ls_pordno, ls_opseq, ls_opseq_prv, sinjpno
long		lRow, lRowHist, lRowOut
dec {2}	dShpSeq, dShpipgo, ld_inqty, ld_coqty
SetNull(sNull)

sDate  = trim(dw_detail.GetItemString(1, "tdate"))				// �԰��Ƿ�����

/* ������ '9999'�� �ƴϸ� �۾����� ��ǥ��ȣ�� ����(���˻� �ڷᰡ �ִ� ��쿡��) */
FOR	lRow = 1		TO		dw_list.RowCount()
		if dw_list.getitemstring(lrow, "opseq") <> '9999' AND &
			dw_list.getitemstring(lrow, "qcgubun") = '1' And &
			dw_list.getitemdecimal(lrow, "inqty") > 0 then			
			/* �۾����� ��ǥ��ȣ */
			dShpSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'N1')
			IF dShpSeq < 1		THEN
				ROLLBACK;
				f_message_chk(51,'[�۾�������ȣ]')
				RETURN -1
			END IF
			/* �۾������� ���� �԰��ȣ */
			dShpipgo = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
			IF dShpipgo < 1	THEN
				ROLLBACK;
				f_message_chk(51,'[�۾������� ���� �԰��ȣ]')
				RETURN -1
			END IF			
			Exit	
		End if
Next

sEmpno = dw_detail.GetItemString(1, "empno")				// �԰��Ƿ���
sGubun = dw_detail.GetItemString(1, "gubun")

FOR	lRow = 1		TO		dw_list.RowCount()
	/////////////////////////////////////////////////////////////////////////
	//																							  //	
	// ** �����HISTORY ���� **														  //	
	//																							  //
	/////////////////////////////////////////////////////////////////////////
	//lRowHist++
	
	if dw_list.getitemdecimal(lrow, "inqty") = 0 then continue

	sQcGubun 	= dw_list.GetItemString(lRow, "qcgubun")
	sQcEmpno		= dw_list.GetItemString(lRow, "empno")
	sVendor		= dw_list.GetItemString(lRow, "vendor")
	sinjpno		= dw_list.GetItemString(lRow, "injpno")  // �԰���ǥ��ȣ
	
	lRowHist = dw_imhist.find("iojpno='"+sinjpno+"'",1,dw_imhist.rowcount())
	if lRowHist > 0 then
		sIojpno     	= dw_imhist.GetItemString(lRowHist, "iojpno")
		sOpseq      	= dw_imhist.GetItemString(lRowHist, "opseq")
	End If
	
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
	sOpseq = dw_list.GetItemString(lRow, "opseq")
	IF sOpseq <> '9999' And sQcgubun = '1' THEN
		
		//������ ���� ȯ���� 'Y'�ΰ�� ������ ���� Check�Ͽ� Imhist�� MOROUT, SHPACT�� 
		//�ݿ����� �ʵ��� ��.
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
//				 MessageBox('Ȯ��',"�۾����ù�ȣ '" + ls_pordno + "'�� '"+ ls_opseq_prv + "' ���� ������~r�Էµ��� �ʾҽ��ϴ�.") 
				 continue
			End If
		End If
		
		il_count = il_count + 1
		
		if wf_waiju(Lrow, Lrowhist, sDate, dShpseq, sIojpno, sOpseq, dShpipgo, Sempno, sVendor, 'I') = -1 then
			return -1
		end if
				  
		CONTINUE

	END IF

NEXT

RETURN 1
end function

public function integer wf_imhist_create (ref string rsdate, ref decimal rdseq);///////////////////////////////////////////////////////////////////////
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
			sLcno, sLocal, sitnbr, sitnbr_in
long		lRow, lRowHist, lRowOut 
long 		dSeq, dOutSeq 
string	sitnbr_t, scvcod_t, curr_t
Double	dprc , dinqty, damt                       // DECIMAL �� ��ĥ ��� �Ҽ��� �ȳ��� 2004,02,06
Decimal  dnaqty

string ls_sys, ls_gbn


// �ܰ� ����... 1:���ֽ�, 2:���Ͻ�..
SELECT NVL(dataname,'1') INTO :ls_sys FROM SYSCNFG
 WHERE sysgu = 'Y' AND serial = '51' AND lineno = '1';
 
if isnull(ls_sys) or ls_sys = '' then ls_sys = '1' 


SetNull(sNull)

dw_detail.AcceptText()
dw_list.AcceptText()

//sDate  = f_today()
sDate  = trim(dw_detail.getitemstring(1,'Tdate'))

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[�԰��Ƿڹ�ȣ]')
	RETURN -1
END IF
COMMIT ;

rSdate = sDate
rDseq	 = dseq

/* ��� �̰��� ����� �ִ��� �˻��Ͽ� ������ ���ұ��й� ��ǥ��ȣ�� ���� */
FOR	lRow = 1		TO		dw_list.RowCount()	
	if dw_list.getitemstring(lrow, "itemas_filsk") = 'N' then
		/* ��ǥ��ȣ */
		dOutSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
		IF dOutSeq < 1		THEN
			ROLLBACK;
			f_message_chk(51,'[�ڵ�����ȣ]')
			RETURN -1
		END IF
		
		/* ���ұ���	*/
		Select iogbn into :sIogbn from iomatrix where maiaut = 'Y' ;
		If sqlca.sqlcode <> 0 then
			ROLLBACK;
			f_message_chk(41,'[���ұ���]')
			return -1
		end if
		Exit	
	End if
Next

//COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  	 = sDate + string(dSeq, "0000")

lrow = dw_detail.Rowcount()
dw_detail.SetItem(1, "in_jpno", 	sJpno)	

sEmpno = dw_detail.GetItemString(1, "empno")				// �԰��Ƿ���

/* �ű��Է��ڷḦ ���� clear */
dw_imhist.reset()
dw_imhist_out.reset()

//sGubun = dw_detail.GetItemString(1, "gubun")  // ���� : 1  , ���� :2
//
//If sGubun = '1' Then   
//	sIogbn_in = 'I01'
//Else
//	sIogbn_in = 'I03'
//End If

Long   ll_rowcnt
ll_rowcnt = dw_list.RowCount()

String  ls_factory, ls_chk
FOR	lRow = 1		TO		ll_rowcnt//dw_list.RowCount()
	/////////////////////////////////////////////////////////////////////////
	//																							  //	
	// ** �����HISTORY ���� **														  //	
	//																							  //
	/////////////////////////////////////////////////////////////////////////
	
	//������ �͸� ó��  
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	
	if dw_list.getitemdecimal(lrow, "inqty") = 0 then 
		dw_list.Object.chk_flag[lRow] = 'N'
		continue
	End if
	//================================
	
	sGubun = dw_list.GetItemString(lRow, "pomast_balgu")  // ���� : 1  , ���� : 3
	If sGubun = '3' Then   
		sIogbn_in = 'I03'
	Else
		sIogbn_in = 'I01'
	End If

	dnaqty	=	dw_list.GetItemDecimal(lRow, "naqty")
  
	lRowHist = dw_imhist.InsertRow(0)

	sQcGubun 	= dw_list.GetItemString(lRow, "qcgubun")
	sQcEmpno		= dw_list.GetItemString(lRow, "empno")
	sStockGubun = dw_list.GetItemString(lRow, "itemas_filsk")
	sVendor		= dw_list.GetItemString(lRow, "vendor")
	ls_factory  = dw_list.GetItemString(lRow, 'plant')  //������ �����ڵ� �� �߰� by shingoon 2013.12.04

	dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
	dw_imhist.SetItem(lRowHist, "jnpcrt",	'007')			// ��ǥ��������
	dw_imhist.SetItem(lRowHist, "inpcnf",  'I')				// �������
	sIojpno = sJpno + string(lRowHist, "000")
	dw_imhist.SetItem(lRowHist, "iojpno", 	sIojpno)
	dw_imhist.SetItem(lRowHist, "iogbn", siogbn_in  ) 			// ���ұ���=�԰���

	dw_imhist.SetItem(lRowHist, "sudat",	sDate)			// ��������=��������
	dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // ǰ��
	dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "poblkt_pspec"))	//���
	
	dw_imhist.SetItem(lRowHist, "opseq",	dw_list.GetItemString(lRow, "opseq")) // ��������	
	
	dw_imhist.SetItem(lRowHist, "depot_no",sVendor) 		// ����â��=�԰�ó
	dw_imhist.SetItem(lRowHist, "cvcod",	dw_list.GetItemString(lRow, "cvcod")) 		// �ŷ�óâ��=�ŷ�ó
	
	dw_imhist.SetItem(lRowHist, "ioreqty",	dw_list.GetItemDecimal(lRow, "inqty")) 	// �����Ƿڼ���=�԰����(��������)
	dw_imhist.SetItem(lRowHist, "cnviore",	dw_list.GetItemDecimal(lRow, "cinqty")) 	// �����Ƿڼ���=�԰����(���ִ���)		

	dw_imhist.SetItem(lRowHist, "yebi1",	dw_list.GetItemString(lRow, "yebi1")) 	   // ������
	dw_imhist.SetItem(lRowHist, "yebi2",	dw_list.GetItemString(lRow, "tuncu")) 	   // ��ȭ����
	dw_imhist.SetItem(lRowHist, "dyebi1",	dw_list.GetItemDecimal(lRow, "trate")) 	// ����ȯ��
	dw_imhist.SetItem(lRowHist, "dyebi2",	dw_list.GetItemDecimal(lRow, "funprc")) 	// ��ȭ�ܰ�
	dw_imhist.SetItem(lRowHist, "dyebi3",	dw_list.GetItemDecimal(lRow, "prate")) 	// ������ + ���Ժ����
	
	dw_imhist.SetItem(lRowHist, 'facgbn',  ls_factory)  //������ �����ڵ� �� �߰� by shingoon 2013.12.04 (����ó�԰� ��Ÿ����.)

	dw_imhist.SetItem(lRowHist, "qcgub",	sQcGubun) 		// �˻籸��= �ܰ�����Ÿ
	dw_imhist.SetItem(lRowHist, "insemp",	sQcEmpno) 		// �˻�����=�ܰ�����Ÿ
	dw_imhist.SetItem(lRowHist, "filsk",   sStockGubun) 	// ����������

	dw_imhist.SetItem(lRowHist, "baljpno", dw_list.getitemstring(lrow, "baljpno"))			// ���ֹ�ȣ
	dw_imhist.SetItem(lRowHist, "balseq",  dw_list.GetItemNumber(lRow, "balseq"))
	dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������

	dw_imhist.SetItem(lRowHist, "GUNGBN",'I') 	   	// SCM ���õ� �ڷ����� Ȯ��.
 	Setnull(ls_gbn)
   if	dnaqty = 0	then
		dw_imhist.SetItem(lRowHist, "GUNGBN",'M') 		// SCM ���ó������ �԰��Ҷ�.
	end if	
	
	select deptcode into :sdeptcode from p1_master where empno = :sempno;
	
	dw_imhist.SetItem(lRowHist, "ioredept",	sDeptcode)	// �����Ƿںμ�
	dw_imhist.SetItem(lRowHist, "ioreemp",	sEmpno)			// �����Ƿڴ����=�԰��Ƿ���
    
	//�ΰ� �����  
	dw_imhist.SetItem(lRowHist, "saupj",	dw_list.GetitemString(lRow, "poblkt_saupj"))	
   
	// Lot no ��� �ŷ�ó������ǥ��ȣ �߰� --> ������ �ʿ�
	dw_imhist.SetItem(lRowHist, "ip_jpno",	dw_list.GetitemString(lRow, "poblkt_hist_jpno"))
	dw_imhist.SetItem(lRowHist, "loteno",	dw_list.GetitemString(lRow, "loteno"))

   // ���ִ��� �� ��ȯ���
	dw_imhist.SetItem(lRowHist, "cnvfat",  dw_list.getitemdecimal(lrow, "poblkt_cnvfat"))			
	dw_imhist.SetItem(lRowHist, "cnvart",  dw_list.GetItemstring(lRow, "poblkt_cnvart"))
	
	dw_imhist.SetItem(lRowHist, "gurdat",	dw_list.GetItemString(lRow, "qcdate"))		// �˻��û��
	dw_imhist.SetItem(lRowHist, "jakjino", dw_list.GetItemString(lRow, "pordno"))		// �۾����ù�ȣ
	
   // SCM ���ž�ü�� LOTNO �Է�
	dw_imhist.SetItem(lRowHist, "lotsno",  dw_list.getitemstring(lrow, "lotsno"))
	dw_imhist.SetItem(lRowHist, "loteno",  dw_list.getitemstring(lrow, "loteno"))
	
	//�԰��� �˻�ǰ ����
	dw_imhist.SetItem(lRowHist, "yebi3",	'N')	// itemas_inspection.grpno2�� ������ ����

	dw_imhist.SetItem(lRowHist, "bigo",  dw_list.getitemstring(lrow, "poblkt_bigo"))

	////////////////////////////////////////////////////// ���߰� 
	dw_list.SetItem(lRow, "injpno", sIojpno)

	// ���ҽ��ο��δ� �ش� â���� ���ο��θ� �������� �Ѵ�
	// �� ������ ����� �ƴ� ���� �ڵ�����'Y'���� ����
	SELECT HOMEPAGE
	  INTO :sSaleYN
	  FROM VNDMST
	 WHERE ( CVCOD = :sVendor ) ;	
	
	/* �԰�â�� ����-��ǰâ��, CKDâ���� ��� �������� - BY SHINGOON 2016.03.01 */
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	  INTO :ls_chk
	  FROM VNDMST
	 WHERE CVGU = '5' AND SOGUAN = '1' AND JUPROD = '1' AND JUMAECHUL = '2' AND CVCOD = :sVendor ;
	If ls_chk = 'Y' Then
		ssaleyn = 'N'
	Else
		// ������ ����� �ƴϸ� �ڵ�����
		if sstockgubun = 'N' then ssaleyn = 'Y'
	End If
	
	// �԰���� üũ�� ��� �ڵ����� - JHOON 2020.03.30
	IF cbx_io_confirm.checked THEN
		ssaleyn = 'Y'
	END IF
	
	// ��, ���������� ��쿡�� ������ �������� => ������ (����� �ȵǵ���)
	//if sIogbn_in = 'I03' then ssaleyn = 'N'
	
	dw_imhist.SetItem(lRowHist, "io_confirm", sSaleYn)			// ���ҽ��ο���


	/////////////////////////////////////////////////////////////////////////////////
	// �԰�ݾ� ��� - 2003.12.17 - �ۺ�ȣ
	sitnbr_t = dw_list.GetItemString(lRow, "itnbr")
	scvcod_t = dw_list.GetItemString(lRow, "cvcod")
	curr_t = dw_list.GetItemString(lRow, "tuncu")
	
	choose case ls_sys
		case '1'
			// ���ֽ�...
			dprc = dw_list.GetItemDecimal(lRow, "unprc") 	// ���ִܰ�.
		case '2'
			// ���Ͻ�...
			// ���ܰ� ��������..
			//select Fun_get_unprc(:sDate,:scvcod_t,:sitnbr_t, :curr_t,'0')	into :dprc from dual ;
			dprc = dw_list.GetItemDecimal(lRow, "unprc") 	// ���ִܰ�.
	end choose 
	
	
	// 2004.02.16 - �ۺ�ȣ
	IF sIogbn_in = 'I03' THEN
		select opseq into :sopseq from routng
		 where wai_itnbr = :sitnbr_t and purgc = 'Y'	and rownum = 1 ;
		if sqlca.sqlcode = 0 then
			dw_imhist.SetItem(lRowHist, "opseq", sopseq)
		end if
	end if

	/////////////////////////////////////////////////////////////////////////////////
	
	dw_imhist.SetItem(lRowHist, "ioprc",	dprc ) 	// ���Ҵܰ�=�԰�ܰ�


	/* GetItemDecimal	���� */
	dinqty = dw_list.GetItemNumber(lRow, "inqty")
	/* 2007.05.01�� ���� ������� ����
	   - ���� �� ����(���� �԰� �� ���� ���� ����. �Ҽ��� 1�ڸ����� ����) by shingoon 2007.05.14 */
	damt = dinqty * dprc//Truncate(Round(dinqty * dprc, 2), 1)
//	damt = Truncate(round(dinqty * dprc, 2),0) //Truncate(dinqty * dprc,0) Truncate�Լ� ����

	// ���˻��� ��� 
	IF sQcGubun = '1'		THEN										// �˻籸��=���˻��� ���
		dw_imhist.SetItem(lRowHist, "insdat",sDate)			// �˻�����=�԰��Ƿ�����
		dw_imhist.SetItem(lRowHist, "insemp",snull)			// �˻�����=null
		dw_imhist.SetItem(lRowHist, "iosuqty",dinqty)	// �հݼ���=�԰����(��������)
		dw_imhist.SetItem(lRowHist, "cnviosu",dw_list.GetItemDecimal(lRow, "cinqty"))	// �հݼ���=�԰����(���ִ���)
		dw_imhist.SetItem(lRowHist, "decisionyn", 'Y')		// �հ�ó��
		
		/////////////////////////////////////////////////////////////////////////////////
		// �԰�ݾ� ��� - 2003.12.17 - �ۺ�ȣ
		dw_imhist.SetItem(lRowHist, "ioprc", dprc)
		dw_imhist.SetItem(lRowHist, "ioamt", damt)
		/////////////////////////////////////////////////////////////////////////////////

		If	sSaleYn = 'Y' then // ���˻��̰� �����ڵ������� ��� �Ǵ� ������ ����� �ƴѰ�
			dw_imhist.SetItem(lRowHist, "io_confirm", sSaleYn)	// ���ҽ��ο���	
			dw_imhist.SetItem(lRowHist, "ioqty", dinqty) 	// ���Ҽ���=�԰����
			dw_imhist.SetItem(lRowHist, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
			dw_imhist.SetItem(lRowHist, "io_empno", sNull)		// ���ҽ�����=NULL
		END IF
	
	END IF
		
	/* ----------------------------------------------------- */
	/* ����̵���� ó�� 2016.01.21 �ŵ��� 			 */
	/* ---------------------------------------------------- */		
	If cbx_move.Checked = True Then
		If wf_automoveout(lRowHist, dw_imhist, sDate, sIojpno, sQcGubun) = -1 Then
			MessageBox('����', '����̵�����ڷ� ���� ����-3')
			return -1			
		End If
	End If
	
	// �˻��� ��� ioqty , iodat ��  Null
	// ������ ��� ������� ��ǥ�� �ۼ��Ѵ�. 
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
	
	IF sIogbn_in = 'I03' And sQcgubun = '1' THEN
		
		/////////////////////////////////////////////////////////////////////////////////
		// �԰�ݾ� ��� - 2003.12.17 - �ۺ�ȣ
		dw_imhist.SetItem(lRowHist, "ioprc", dprc)
		dw_imhist.SetItem(lRowHist, "ioamt", damt)
		/////////////////////////////////////////////////////////////////////////////////
					  
		CONTINUE

	END IF	

//	// ��ǰ�� �ڷ�� SKIP
//	sitnbr = dw_list.GetItemString(lRow, "itnbr")
//	select itnbryd into :sitnbr_in from item_rel
//	 where itnbr = :sitnbr and itnbryd is not null and rownum = 1 ;
//	if sqlca.sqlcode = 0 then continue
	
	
	/////////////////////////////////////////////////////////////////////////////////////
	// �����ǥ ���� : ��ǥ��������('008')
	/////////////////////////////////////////////////////////////////////////////////////
	IF (sQcgubun = '1' And sSaleYn = 'Y') and sstockgubun = 'N' then 

		lRowOut = dw_imhist_out.InsertRow(0)
	
		dw_imhist_out.SetItem(lRowOut, "sabu",		gs_sabu)
		dw_imhist_out.SetItem(lRowOut, "jnpcrt",	'008')			// ��ǥ��������
		dw_imhist_out.SetItem(lRowOut, "inpcnf",  'O')				// �������
		dw_imhist_out.SetItem(lRowOut, "iojpno", 	sDate+string(dOutSeq, "0000")+string(lRowout, "000"))
		dw_imhist_out.SetItem(lRowOut, "iogbn",   siogbn) 			// ���ұ���
		dw_imhist_out.SetItem(lRowOut, "sudat",	sDate)			// ��������=��������
		dw_imhist_out.SetItem(lRowOut, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // ǰ��
		dw_imhist_out.SetItem(lRowOut, "pspec",	dw_list.GetItemString(lRow, "poblkt_pspec"))//���
		dw_imhist_out.SetItem(lRowOut, "opseq",	'9999') 			// ��������
		dw_imhist_out.SetItem(lRowOut, "depot_no",sVendor) 		// ����â��=�԰�ó
		dw_imhist_out.SetItem(lRowOut, "cvcod",	sVendor) 		// �ŷ�óâ��=�԰�ó
		dw_imhist_out.SetItem(lRowOut, "ioqty",   dw_list.GetItemDecimal(lRow, "inqty"))		// ���Ҽ���=�԰����
		dw_imhist_out.SetItem(lRowOut, "ioprc",	0)	
		dw_imhist_out.SetItem(lRowOut, "ioreqty",	dw_list.GetItemDecimal(lRow, "inqty")) 	// �����Ƿڼ���=�԰����		
		dw_imhist_out.SetItem(lRowOut, "insdat",	sDate) 			// �˻�����=�԰��Ƿ�����
		dw_imhist_out.SetItem(lRowOut, "iosuqty", dw_list.GetItemDecimal(lRow, "inqty"))		// �հݼ���=�԰����

		dw_imhist_out.SetItem(lRowOut, "io_empno",sNull)			// ���ҽ�����
		dw_imhist_out.SetItem(lRowOut, "io_confirm", sSaleYn)		// ���ҽ��ο���
		dw_imhist_out.SetItem(lRowOut, "io_date", sDate)			// ���ҽ�������=�԰�����
		dw_imhist_out.SetItem(lRowOut, "filsk", 'N')					// ����������
		dw_imhist_out.SetItem(lRowOut, "saupj", dw_list.GetitemString(lRow, "poblkt_saupj"))					// ����������
		dw_imhist_out.SetItem(lRowOut, "bigo",  '�����԰� ��������')
		dw_imhist_out.SetItem(lRowOut, "botimh", 'Y')				// ���������
		dw_imhist_out.SetItem(lRowOut, "ip_jpno", sJpno + string(lRowHist, "000")) // �԰���ǥ��ȣ
		dw_imhist_out.SetItem(lRowOut, "ioreemp", sEmpno)			// �����Ƿڴ����=�԰��Ƿڴ����
	END IF

NEXT

RETURN 1
end function

public function integer wf_waiju (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// ������ �۾����� ��ǥ�� �����Ѵ�.
// ���� A = �ű��Է�, U = ������ �Է�, D = ����
// ���ְ����԰�(������ 9999�� �ƴϸ�)�� ��쿡�� ������ǥ�� �ۼ��Ѵ�.
String sitnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
Decimal {3} dInqty
String ls_iojpno

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno And sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("�۾���������", "�۾����� ������ �����Ͽ����ϴ�", stopsign!)
		return -1	
	end if
end if

if sGubun = 'U' then
	
	dInqty	 = dw_list.getitemdecimal(lrow, "imhist_ioreqty")							      // ��������	
	
	Update Shpact
		Set roqty 	= :dInqty,
			 coqty 	= :dInqty,
			 ipgub   = :sVendor, 
			 upd_user = :gs_userid
	 Where sabu 	= :gs_sabu And Pr_shpjpno = :sIojpno And sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("�۾���������", "�۾����� ������ �����Ͽ����ϴ�", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then
	
	sShpJpno  	= sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// �۾�������ȣ
	sitnbr	 		=	dw_list.GetItemString(lRow, "itnbr") 							      // ǰ��
	sPspec	 	=	dw_list.GetItemString(lRow, "poblkt_pspec")					      // ���
	select fun_get_pdtgu(:sitnbr, '1') into :sPdtgu from dual;				      // ������
	sPordno	 	= dw_list.getitemstring(lrow, "poblkt_pordno");				      // �۾����ù�ȣ	
	dInqty	 		= dw_list.getitemdecimal(lrow, "inqty")							      // ��������	

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
	 
	// ���������̸� �԰��ȣ�� �����Ѵ�(���ֽ����� 4�� ǥ��)
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
		MessageBox("�۾������ۼ�", "�۾����� �ۼ��� �����Ͽ����ϴ�", stopsign!)
		return -1
	End if	
	
	ls_iojpno	=  dw_imhist.getitemstring(lRowHist, "iojpno");				      // ����� ��ǥ��ȣ.
	UPDATE IMHIST SET JAKJINO = :sPordno , JAKSINO = :sShpjpno
	where SABU = :gs_sabu AND IOJPNO = :ls_iojpno;
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("�۾�����", "�۾����� UPDATE�� �����Ͽ����ϴ�", stopsign!)
		return -1
	End if	
	
	Commit;

end if

Return 1
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. �԰���� = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sCode, sQcgub, get_nm, spordno, get_pdsts
dec{3}	dQty, dBalQty
dec{5}   dPrice
long		lRow, lcount1 = 0 ,lcount2 = 0


FOR	lRow = 1		TO		dw_list.RowCount()

	IF ic_status = '1'	THEN		
		
		If dw_list.getitemdecimal(lrow, "inqty") <= 0 then
			dw_list.Object.chk_flag[lRow] = 'N'
			continue
		end if
		
		dw_list.Object.chk_flag[lRow] = 'Y'
		lcount1 ++
		lcount2 ++

		dPrice = dw_list.GetitemDecimal(lRow, "unprc")
		
//		IF IsNull(dPrice)	or dPrice <= 0	THEN
//			f_message_chk(30,'[�԰�ܰ�]')
//			dw_list.ScrollToRow(lrow)
//			dw_list.Setcolumn("unprc")
//			dw_list.setfocus()
//			RETURN -1
//		END IF
		
		sCode = dw_list.GetitemString(lRow, "poblkt_pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			dw_list.Setitem(lRow, "poblkt_pspec", '.')
		END IF

		sCode = dw_list.GetitemString(lRow, "vendor")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[�԰�ó]')
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
			f_message_chk(33,'[�˻籸��]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("qcgubun")
			dw_list.setfocus()
			RETURN -1
		END IF		

		if dw_list.getitemstring(lrow, "qcgubun") = '7' then  // �˻������� ����˾�
			messagebox('Ȯ��','�˻籸���� �˻������� ���� ó���� �� �����ϴ�.~nǰ���� �����ϼ���!!!')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("qcgubun")
			dw_list.setfocus()
			RETURN -1
		END IF		
			
		
		
		/* �˻�ǰ���� ��쿡�� check */
		String sdate
		sdate = dw_detail.GetItemString(1, "fdate")
		if dw_list.getitemstring(lrow, "qcgubun") > '1' then 
			dw_list.SetItem(lRow, "qcdate", is_date)
			
			sCode = dw_list.GetitemString(lRow, "empno")
			IF IsNull(scode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[�˻�����]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("empno")
				dw_list.setfocus()
				RETURN -1
			END IF		
		end if
		
		//���ֿ� �۾����� no�� ������ �۾����ø� �о ���°� '1', '2' �� �ڷḸ ���� �� ����
		sPordno = dw_list.getitemstring(lrow, 'poblkt_pordno')
		if not (sPordno = '' or isnull(sPordno)) then 
			SELECT "MOMAST"."PDSTS"  
			  INTO :get_pdsts  
			  FROM "MOMAST"  
			 WHERE ( "MOMAST"."SABU"   = :gs_sabu ) AND  
					 ( "MOMAST"."PORDNO" = :sPordno )   ;
					 
			if not (get_pdsts = '1' or get_pdsts = '2' or get_pdsts = '3') then 
				messagebox("Ȯ ��", "�԰��Ƿ� ó���� �� �� �����ϴ�. " + "~n~n" + &
										  "�۾����ÿ� ���û��°� ����/��������ø� �԰��Ƿڰ� �����մϴ�.")
				dw_list.ScrollToRow(lrow)
   			dw_list.Setcolumn("inqty")
				dw_list.setfocus()
				return -1							  
			end if	
	
		end if
	
	// ��ȸ�� ����
	ElseIF ic_status = '2'	THEN
			
		sCode = dw_list.GetitemString(lRow, "imhist_depot_no")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[�԰�ó]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_depot_no")
			dw_list.setfocus()
			RETURN -1
		END IF

		dQty = dw_list.getitemdecimal(lrow, "imhist_ioreqty")
		IF IsNull(dQty)  or  dQty = 0		THEN
			f_message_chk(30,'[�԰����]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioreqty")
			dw_list.setfocus()
			RETURN -1
		END IF

		/* �˻�ǰ���� ��쿡�� check */
		if dw_list.getitemstring(lrow, "qcgubun") > '1' then
			sCode = dw_list.GetitemString(lRow, "empno")
			IF IsNull(scode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[�˻�����]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("empno")
				dw_list.setfocus()
				RETURN -1
			END IF

			sCode = dw_list.GetitemString(lRow, "imhist_gurdat")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[�˻��û��]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("imhist_gurdat")
				dw_list.setfocus()
				RETURN -1
			END IF
		End if	
      lcount1++
		lcount2++
	END IF
	
NEXT

//if lcount1 < 1 then 
//	MessageBox('Ȯ��','�԰�ó����  �԰��ȣ�� üũ�ڽ��� �����ϼ���.')
//	return -1
//end if

//if lcount2 < 1 then 
//	f_message_chk(30,'[�԰����]')
//	return -1
//end if	

RETURN 1

end function

public function integer wf_initial ();String sIogbn, sMaigbn, sNull, sLocal

Setnull(sNull)

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()
dw_imhist_out.reset()
dw_autoimhist.reset()

p_mod.enabled = false
p_mod.picturename = "C:\erpman\image\����_d.gif"
p_del.enabled = false
p_del.picturename = "C:\erpman\image\����_d.gif"
dw_detail.enabled = TRUE
//cbx_chk.checked = False


is_barmode = 'N'

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	dw_detail.DataObject = 'd_mm01_00010_1'	
	dw_list.DataObject = 'd_mm01_00010_a'
	dw_print.DataObject = 'd_mm01_00010_1_p'
	
	cbx_1.visible 	= true
	cbx_2.visible 	= true
	cbx_3.visible 	= true
	cbx_io_confirm.visible = true
	rr_4.visible 	= true
	pb_1.visible 	= true
	
//	cbx_print.visible = true
	cbx_wall.visible = true	
	
	
	dw_detail.insertrow(0)
	
	dw_detail.Object.fdate[1] = f_afterday(is_date , -30)
	dw_detail.Object.tdate[1] = is_date

//	/* User�� ����� Setting Start */
//	String saupj
//	 
//	If f_check_saupj(saupj) = 1 Then
//		dw_detail.Modify("saupj.protect=1")
//	End If
//	dw_detail.SetItem(1, 'saupj', saupj)
	
//	f_mod_saupj(dw_detail,'saupj')
	DataWindowChild dwc_ittyp, dwc_saupj
   dw_detail.GetChild("ittyp", dwc_ittyp)
   dwc_ittyp.SetTransObject(SQLCA)
   dwc_ittyp.Retrieve()
	
	dw_detail.GetChild('saupj', dwc_saupj)
	dwc_saupj.SetTransObject(SQLCA)
	dwc_saupj.Retrieve()
ELSE
	dw_detail.DataObject = 'd_mm01_00010_2'
	dw_list.DataObject = 'd_mm01_00010_b'
	dw_print.DataObject = 'd_mm01_00010_1_p2'	
	
	cbx_1.visible 	= false
	cbx_2.visible 	= false
	cbx_3.visible 	= false
	cbx_io_confirm.visible = false
	rr_4.visible 	= false
	pb_1.visible 	= false
	
	cbx_print.visible = false
	cbx_wall.visible = false	
	
	dw_detail.insertrow(0)
	
	dw_detail.Object.fdate[1] = f_afterday(is_date , -30)
	dw_detail.Object.tdate[1] = is_date

END IF

dw_detail.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
	
string	sempname

select empname
  into :sempname
  from p1_master
 where empno = :gs_empno ;

dw_detail.setitem(1,'empno',gs_empno)
dw_detail.setitem(1,'empname',sempname)

dw_detail.setcolumn(1)
dw_detail.setfocus()
dw_detail.setredraw(true)



return  1

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

public function integer wf_setfilter ();string	sfilt, sfilt1, sfilt2, sdate, sgubun

sdate = dw_detail.getitemstring(1,'Tdate')

// ���� ������
select  week_sdate into :sdate from pdtweek where week_sdate <= :sdate and week_edate >= :sdate;

// ���ϳ���
if cbx_2.checked then
	sfilt = " gudat >= '" + sdate + "'"
else
	sfilt = ""
end if

// �̳��ڷ�
if cbx_3.checked then
	sfilt1 = " gudat < '" + sdate + "'"
	if isnull(sfilt) or sfilt = "" then
		sfilt = sfilt1
	else
		sfilt = sfilt + " or " + sfilt1
	end if
end if

// ���ó��
if cbx_1.checked then
	sfilt2 = " not isnull(dtime) "
	if isnull(sfilt) or sfilt = "" then
		sfilt = sfilt2
	else
		sfilt =" ( " + sfilt + " ) and  " + sfilt2
	end if
end if

// ������
sgubun = dw_detail.getitemstring(1,'filter')
if sgubun = '%' then
else
	if isnull(sfilt) or sfilt = "" then
		sfilt = sgubun
	else
		sfilt = " ( " + sfilt + " ) and " + sgubun
	end if
end if

//MESSAGEBOX('A',SFILT)
dw_list.setfilter(sfilt)
dw_list.filter()

return 1
end function

public function integer wf_danmst ();string	sItem, 		&
			sCust,		&
			sCustName,	&
			sIndate,		&
			sRedate,		&
			sCustom,		&	
			sNull
long		lRow
int		iCount

SetPointer(HourGlass!)
/* �ܰ������Ϳ� �˻����ڰ� ���� ��� ȯ�漳���� �ִ� �⺻ �˻����ڸ� �̿��Ѵ� */
Setnull(sNull)
select dataname
  into :scustom
  from syscnfg
 where sysgu = 'Y' and serial = '13' and lineno = '1';

if sqlca.sqlcode <> 0 then
	f_message_chk(207,'[�˻�����]') 	
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
	
  SELECT ITEMAS_QC.QCEMP,   
         ITEMAS_QC.QCGUB  
    INTO :sEmpno,   
         :sGubun  
    FROM ITEMAS_QC  
   WHERE ( ITEMAS_QC.ITNBR = :sItem ) AND  
         ( ITEMAS_QC.CVCOD = :sCust ) AND
			( ITEMAS_QC.OPSEQ = :sOpseq ) AND
			( ITEMAS_QC.GUBUN = '2' ) ;

//  SELECT DANMST.QCEMP,   
//         DANMST.QCGUB  
//    INTO :sEmpno,   
//         :sGubun  
//    FROM DANMST  
//   WHERE ( DANMST.ITNBR = :sItem ) AND  
//         ( DANMST.CVCOD = :sCust ) AND
//			( DANMST.OPSEQ = :sOpseq )  ;

//    SELECT DANMST.QCEMP,   
//         DANMST.QCGUB  
//    INTO :sEmpno,   
//         :sGubun  
//    FROM DANMST  
//   WHERE ( DANMST.ITNBR = :sItem ) AND  
//         ( DANMST.CVCOD = :sCust ) ;
			
	IF SQLCA.SQLCODE <> 0	THEN
		
		SELECT ITEMAS.QCGUB, ITEMAS.QCEMP  
        INTO :sgubun,  :sempno    
        FROM ITEMAS  
       WHERE ITEMAS.ITNBR = :sitem ;
		
		if sgubun = '' or isnull(sgubun) then 
			dw_list.SetItem(lRow, "qcgubun", '1')		// ��ٷο� �˻�
		else
			dw_list.SetItem(lRow, "qcgubun", sgubun)		// ��ٷο� �˻�
		end if
		
		if sgubun = '1' then //���˻��� ���
			dw_list.SetItem(lRow, "empno", sNull) 
		else
			if sempno = '' or isnull(sempno) then 
				dw_list.SetItem(lRow, "empno", scustom) // �⺻�˻� �����		
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

	// ������ ���� ���� ��� : ���˻�, �˻����� ����
	if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then
		sStock = 'Y'
	end if
	dw_list.setitem(lRow, "itemas_filsk", sStock)
	IF sStock = 'N'	THEN	
		dw_list.SetItem(lRow, "qcgubun", '1')
		dw_list.Setitem(lrow, "empno", snull)
	End if
		
	// �˻�䱸���ڴ� ���˻� �̸� null 
	IF sStock = 'N' or sgubun = '1'	THEN	
		dw_list.SetItem(lRow, "qcdate", sNull)
	ELSE
		dw_list.SetItem(lRow, "qcdate", sRedate)
   END IF		
	dw_list.setitem(lrow, "qcsugbn", is_qccheck)		// �˻籸�� ��������
	
NEXT

RETURN 1


end function

public subroutine wf_print ();int  icount, icount2
String sName

icount = dw_print.rowcount()

if icount < 1  then return 

//// ����ȸ�� ��Ī
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '1';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head1.text = sName
//
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '2';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head2.text = sName
//
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '3';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head3.text = sName
//
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '4';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head4.text = sName
//
//SELECT A.CVNAS2  into :sName
//  FROM VNDMST A, ( SELECT NVL(DATANAME, '000000') AS JASA FROM SYSCNFG 
//						  WHERE SYSGU = 'C' AND SERIAL = 4 AND LINENO	= 1 ) B
// WHERE A.CVCOD = B.JASA ;
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.footer1.text = sName
//
if icount > 0 then 
	// DW_PRINT PRINT START EVENT���� ��½� ��¿��ο� Y�� UPDATE
	dw_print.print()
end if
dw_print.reset()
//OpenWithParm(w_print_options, dw_print)
end subroutine

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* �������
//		1. �����history -> �԰���� update (�԰������ ������ ��쿡��)
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

	/* �˻� �Ǵ� ���ε� �ڷ�� �����Ұ� */
	if dw_list.getitemstring(lrow, "updategubun") = 'N' then continue

	dcinQty     = dw_list.GetItemDecimal(lRow, "imhist_cnviore")
	//�Ƿڼ���
	dINQty      = dw_list.GetItemDecimal(lRow, "imhist_ioreqty")			
	dTemp_Qty   = dw_list.GetItemDecimal(lRow, "temp_qty")	
	if isnull(dinqty) then dinqty = 0
	if isnull(dTemp_Qty) then dTemp_Qty = 0
	
	//â�� (2001.7.21 ���� ����ö : �԰�â��� 1��)
	//sHouse		= dw_list.GetItemString(lRow, "imhist_depot_no")
	sHouse		= dw_detail.GetItemString(1, "in_house")
	sTemp_depot = dw_list.GetItemString(lRow, "temp_depot")
   //�˻籸�� 	
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
	
	// �� ������ ����� �ƴ� ���� �ڵ�����'Y'���� ����
	SELECT HOMEPAGE
	  INTO :sSaleYN
	  FROM VNDMST
	 WHERE ( CVCOD = :sHouse ) ;	
	if sstockgubun = 'N' then ssaleyn = 'Y'
	
	// ��, ���������� ��쿡�� ������ �������� 2000/10/24 �߰�
	if dw_list.GetItemString(lRow, "imhist_opseq") <> '9999' then
		ssaleyn = 'N'
	end if//2000/10/24 �߰�
	
	// �԰���� üũ�� ��� �ڵ����� - JHOON 2020.03.30
	IF cbx_io_confirm.checked THEN
		ssaleyn = 'Y'
	END IF
	
	dw_list.SetItem(lRow, "imhist_io_confirm", ssaleyn)	// ���ҽ��ο���	

	IF sQcGubun = '1'		THEN										// �˻籸��=���˻��� ���
		dw_list.SetItem(lRow, "imhist_insdat",sDate)			// �˻�����=�԰��Ƿ�����
		dw_list.SetItem(lRow, "empno",snull)      			// �˻�����=null
		dw_list.SetItem(lRow, "imhist_iosuqty",dw_list.GetItemDecimal(lRow, "imhist_ioreqty"))	// �հݼ���=�԰����(��������)
		dw_list.SetItem(lRow, "imhist_cnviosu",dw_list.GetItemDecimal(lRow, "imhist_cnviore"))	// �հݼ���=�԰����(���ִ���)
		dw_list.SetItem(lRow, "decisionyn", 'Y')		// �հ�ó��
	ELSE
		dw_list.SetItem(lRow, "imhist_insdat",snull)			// �˻�����=�԰��Ƿ�����
		dw_list.SetItem(lRow, "imhist_iosuqty",0)				// �հݼ���=�԰����(��������)
		dw_list.SetItem(lRow, "imhist_cnviosu",0)				// �հݼ���=�԰����(���ִ���)
		dw_list.SetItem(lRow, "decisionyn", snull)		   // �պ����� null
	END IF
	
	IF sSaleYn = 'Y' and sQcGubun = '1'	then
		// ���˻��̰� �����ڵ������� ��� �Ǵ� ������ ����� �ƴѰ�
		dw_list.SetItem(lRow, "imhist_io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
		dw_list.SetItem(lRow, "imhist_io_empno", sNull)		// ���ҽ�����=NULL
		dw_list.SetItem(lRow, "imhist_ioqty", dw_list.GetItemDecimal(lRow, "imhist_ioreqty")) 	// ���Ҽ���=�԰����
		dw_list.SetItem(lRow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") * dw_list.GetItemDecimal(lRow, "imhist_ioprc"), 0))	// ���ұݾ�=�԰�ܰ�
		dw_list.SetItem(lRow, "imhist_io_confirm", 'Y')
   ELSE
		dw_list.SetItem(lRow, "imhist_io_date",  sNull)		// ���ҽ�������=�԰��Ƿ�����
		dw_list.SetItem(lRow, "imhist_io_empno", sNull)		// ���ҽ�����=NULL
		dw_list.SetItem(lRow, "imhist_ioqty", 0)  // ���Ҽ���=�԰����
		dw_list.SetItem(lRow, "imhist_ioamt", 0)  // ���Ҽ���=�԰����
		dw_list.SetItem(lRow, "imhist_io_confirm", 'N')
	END IF
	

	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
	sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
	IF sOpseq <> '9999' then
		
		if sQcgubun = '1' then
			dw_imhist.SetItem(lRow, "imhist_ioamt", Truncate(dw_list.GetItemDecimal(lRow, "imhist_ioreqty") * dw_list.GetItemDecimal(lRow, "imhist_unprc"), 0))	// ���ұݾ�=�԰�ܰ�		
		end if
		
		Continue

	END IF 

	// ���˻��̰� �ڵ������̰� �������� �ƴ� ���
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
			messagebox('Ȯ��', '��� �����ǥ ���� ����!')
			RETURN -1
		END IF
	END IF
NEXT

RETURN 1

end function

public function integer wf_imhist_update_waiju ();//////////////////////////////////////////////////////////////////
//
//		* �������
//		1. ������� �ۼ�
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sHouse, sDate, sNull, sQcgubun, sOpseq
long		lRow

Setnull(sNull)

dw_list.accepttext()

FOR	lRow = 1		TO		dw_list.RowCount()

	/* �˻� �Ǵ� ���ε� �ڷ�� �����Ұ� */
	if dw_list.getitemstring(lrow, "updategubun") = 'N' then continue

	sHist_Jpno  = dw_list.GetItemString(lRow, "imhist_iojpno")
	sHouse		= dw_list.GetItemString(lRow, "imhist_depot_no")
	sDate			= dw_list.GetItemString(lRow, "imhist_sudat")
	sQcgubun		= dw_list.GetItemString(lRow, "qcgubun")	
	
	// ���ְ����� ��쿡�� ������� ��ǥ�� �ۼ��Ѵ�. (������ '9999'�� �ƴ� ��쿡�� ó��)
	// ���˻��� ��쿡�� ����(���ְ��� �԰�� ��������� ���� ����)
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

public function integer wf_automoveout (integer arg_rownum, datawindow arg_imhistdw, string arg_date, string arg_iojpno, string arg_qcgubn);/*�����԰�ó���� �ڵ����� ��꿡�� ������� ���ó��, ��ȿ��� �԰�ó�� �ϱ����� �Լ�, �Ϸ� ������ �����Ѵ�.
   ��꿡�� �����԰��� ���� �����ͼ� �ڵ���� ó���Ѵ�.
	arg_rownum : ������ ��
	arg_imhistdw : ������ ������ ������
	arg_date : �������
	arg_iojpno : ��꿡 �԰�� ��ǥ��ȣ*/

If IsNull(arg_date) Or arg_date = '' Then
	MessageBox('Ȯ��', '�԰����ڸ� Ȯ���� �ֽʽÿ�. (automove)')
	Return -1
End If
	
String ls_chulStock, ls_chIogbn, ls_chIojpno //���ó�� ����
String ls_ipStock, ls_ipIogbn, ls_ipIojpno //�԰�ó�� ����
String ls_outItnbr, ls_outStock, ls_outIojpno, ls_outIogbn //ǰ���ü��� ����
String ls_inItnbr, ls_inStock, ls_inIojpno, ls_inIogbn //ǰ���ü�԰� ����
Int li_seq, li_chRow, li_ipRow, li_outRow, li_inRow

String ls_cvgu, ls_ipjogun, ls_jumaechul, ls_juhandle, ls_soguan

ls_ipStock = arg_imhistdw.GetItemString(arg_rownum, 'depot_no')

SELECT CVGU, IPJOGUN, JUMAECHUL, JUHANDLE, SOGUAN
INTO :ls_cvgu, :ls_ipjogun, :ls_jumaechul, :ls_juhandle, :ls_soguan
FROM VNDMST
WHERE CVCOD = :ls_ipStock AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('������', '����̵���� â����ȸ ���� 1')
    Return -1
End If

//�԰�â���� ������� ����ϰ�� ����̵����ó�� ���� �ʴ´�.
If ls_ipjogun = '10' Then Return 0

SELECT CVCOD
INTO :ls_chulStock
FROM VNDMST
WHERE NVL(CVGU, '.') LIKE NVL(:ls_cvgu, '%')
    AND NVL(IPJOGUN, '.') = '10'
    AND NVL(JUMAECHUL, '.') LIKE NVL(:ls_jumaechul, '%')
    AND NVL(JUHANDLE, '.') LIKE NVL(:ls_juhandle, '%')
    AND NVL(SOGUAN, '.') LIKE NVL(:ls_soguan, '%')
    AND ROWNUM = 1;
     
IF SQLCA.SQLCODE <> 0 THEN
    MessageBox('������', '����̵���� â����ȸ ���� 2')
    Return -1
End If

//ls_chulStock = 'Z03'	//��� ����â�� (�ڵ� ���â��)
//ls_ipStock = 'Z06' //��� ����â�� (�ڵ� �԰�â��)

//���尣 �̵���,��� ���ұ���
ls_chIogbn = 'OM7'
ls_ipIogbn = 'IM7'

li_seq = SQLCA.FUN_JUNPYO(gs_sabu, arg_date, 'C0')
If li_seq < 0 Then
	RollBack;
	Return -1
End If
Commit;

String ls_pspec, ls_itnbr, ls_opseq, ls_ioreemp, ls_filsk, ls_itgu, ls_pjtcd
Double ld_ioqty, ld_ioreqty

ls_pspec = trim(arg_imhistdw.GetItemString(arg_rownum, 'pspec'))
If ls_pspec = '' Or isnull(ls_pspec) Then ls_pspec = '.'

ls_itnbr = arg_imhistdw.GetItemString(arg_rownum, 'itnbr')
ld_ioqty = arg_imhistdw.GetItemNumber(arg_rownum, 'ioqty')
ld_ioreqty = arg_imhistdw.GetItemNumber(arg_rownum, 'ioreqty')
ls_opseq = arg_imhistdw.GetitemString(arg_rownum, 'opseq')
ls_ioreemp = arg_imhistdw.GetitemString(arg_rownum, 'ioreemp')
ls_filsk = arg_imhistdw.GetitemString(arg_rownum, 'filsk')
ls_itgu = arg_imhistdw.GetitemString(arg_rownum, 'itgu')
ls_pjtcd = arg_imhistdw.GetitemString(arg_rownum, 'pjt_cd')

//���� �ڷḦ ����԰� �ڷ�� ����� �ش�.
arg_imhistdw.SetItem(arg_rownum, 'saupj', '10')
arg_imhistdw.SetItem(arg_rownum, 'depot_no', ls_chulStock)

//�ڵ���� ó�� (���â���� ���)
li_chRow = dw_autoimhist.InsertRow(0)

ls_chIojpno = arg_date + String(li_seq, '0000') + String(li_chRow, '000')

dw_autoimhist.SetItem(li_chRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_chRow, 'jnpcrt', '001')		//��ǥ��������
dw_autoimhist.SetItem(li_chRow, 'inpcnf', 'O')		//����� ����
dw_autoimhist.SetItem(li_chRow, 'iojpno', ls_chIojpno)	
dw_autoimhist.SetItem(li_chRow, 'iogbn', ls_chIogbn)		//���ұ���

dw_autoimhist.SetItem(li_chRow, 'sudat', arg_date)	//�������
dw_autoimhist.SetItem(li_chRow, 'itnbr', ls_itnbr)		//ǰ��
dw_autoimhist.SetItem(li_chRow, 'pspec', ls_pspec)		//���

dw_autoimhist.SetItem(li_chRow, 'depot_no', ls_chulStock)		//���â��
dw_autoimhist.SetItem(li_chRow, 'cvcod', ls_ipStock)		//�԰�â��
dw_autoimhist.SetItem(li_chRow, 'ioreqty', ld_ioreqty)		//����Ƿڼ���
dw_autoimhist.SetItem(li_chRow, 'opseq', ls_opseq)

dw_autoimhist.SetItem(li_chRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_chRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_chRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_chRow, 'pjt_cd', ls_pjtcd)
dw_autoimhist.SetItem(li_chRow, 'ip_jpno', arg_iojpno)
dw_autoimhist.SetItem(li_chRow, 'bigo', '�ڵ����(����̵�)')

String ls_chSaupj
select ipjogun into :ls_chSaupj from vndmst where cvcod = :ls_chulStock;  // ��� â���� �ΰ� ����� ������
dw_autoimhist.SetItem(li_chRow, 'saupj', ls_chSaupj)

//�ڵ��԰� ó�� (���â���� �԰�)
li_ipRow = dw_autoimhist.InsertRow(0)

ls_ipIojpno = arg_date + String(li_seq, '0000') + String(li_ipRow, '000')

dw_autoimhist.SetItem(li_ipRow, 'sabu', gs_sabu)
dw_autoimhist.SetItem(li_ipRow, 'jnpcrt', '001')		//��ǥ��������
dw_autoimhist.SetItem(li_ipRow, 'inpcnf', 'O')		//����� ����
dw_autoimhist.SetItem(li_ipRow, 'iojpno', ls_ipIojpno)	
dw_autoimhist.SetItem(li_ipRow, 'iogbn', ls_ipIogbn)		//���ұ���

dw_autoimhist.SetItem(li_ipRow, 'sudat', arg_date)	//�������
dw_autoimhist.SetItem(li_ipRow, 'itnbr', ls_itnbr)		//ǰ��
dw_autoimhist.SetItem(li_ipRow, 'pspec', ls_pspec)		//���

dw_autoimhist.SetItem(li_ipRow, 'depot_no', ls_ipStock)		//�԰�â��
dw_autoimhist.SetItem(li_ipRow, 'cvcod', ls_chulStock)		//���â��
dw_autoimhist.SetItem(li_ipRow, 'ioreqty', ld_ioreqty)		//����Ƿڼ���
dw_autoimhist.SetItem(li_ipRow, 'opseq', ls_opseq)

dw_autoimhist.SetItem(li_ipRow, 'filsk', ls_filsk)
dw_autoimhist.SetItem(li_ipRow, 'botimh', 'N')
dw_autoimhist.SetItem(li_ipRow, 'itgu', ls_itgu)

dw_autoimhist.SetItem(li_ipRow, 'pjt_cd', ls_pjtcd)

String ls_ipSaupj
select ipjogun into :ls_ipSaupj from vndmst where cvcod = :ls_ipStock;  // ��� â���� �ΰ� ����� ������
dw_autoimhist.SetItem(li_ipRow, 'saupj', ls_ipSaupj)

dw_autoimhist.SetItem(li_ipRow, 'ip_jpno', ls_chIojpno)
dw_autoimhist.SetItem(li_ipRow, 'bigo', '�ڵ��԰�(����̵�)')

String  ls_chk
IF arg_qcgubn = '1'		THEN										// �˻籸��=���˻��� ���
	//���
	dw_autoimhist.SetItem(li_chRow, 'insdat', arg_date)		//�˻�����
	dw_autoimhist.SetItem(li_chRow, 'iosuqty', ld_ioreqty)		//�հݼ���
	dw_autoimhist.SetItem(li_chRow, 'decisionyn', 'Y')       //�հ�ó��
	
	//�԰�
	dw_autoimhist.SetItem(li_ipRow, 'insdat', arg_date)		//�˻�����
	dw_autoimhist.SetItem(li_ipRow, 'iosuqty', ld_ioreqty)		//�հݼ���
	dw_autoimhist.SetItem(li_chRow, 'decisionyn', 'Y')       //�հ�ó��
	
	/* ���� �԰�ó�� ����â�� �̸� ���� ���� - BY SHINGOON 2016.03.08 */
	SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	  INTO :ls_chk
	  FROM VNDMST
	 WHERE CVGU = '5' AND SOGUAN = '1' AND JUMAECHUL = '2' AND CVCOD = :ls_ipStock ;
	 
	// �԰���� üũ�� ��� �ڵ����� - JHOON 2020.03.30
	IF cbx_io_confirm.checked THEN
		ls_chk = 'N'
	END IF
	
	If ls_chk = 'Y' Then /* �������� */
		//���
		dw_autoimhist.SetItem(li_chRow, 'ioqty', 0)		//������
		dw_autoimhist.SetItem(li_chRow, 'io_confirm', 'N') //����ҽ��ο���
		dw_autoimhist.SetItem(li_chRow, 'io_date', '') //���ҽ�������
		dw_autoimhist.SetItem(li_chRow, 'ioreemp', '')
		//�԰�
		dw_autoimhist.SetItem(li_ipRow, 'ioqty', 0)		//������
		dw_autoimhist.SetItem(li_ipRow, 'io_confirm', 'N') //���ҽ��ο���
		dw_autoimhist.SetItem(li_ipRow, 'io_date', '') //���ҽ�������
		dw_autoimhist.SetItem(li_ipRow, 'ioreemp', '')
	Else
		//���
		dw_autoimhist.SetItem(li_chRow, 'ioqty', ld_ioreqty)		//������
		dw_autoimhist.SetItem(li_chRow, 'io_confirm', 'Y') //����ҽ��ο���
		dw_autoimhist.SetItem(li_chRow, 'io_date', arg_date) //���ҽ�������
		dw_autoimhist.SetItem(li_chRow, 'ioreemp', ls_ioreemp)
		//�԰�
		dw_autoimhist.SetItem(li_ipRow, 'ioqty', ld_ioreqty)		//������
		dw_autoimhist.SetItem(li_ipRow, 'io_confirm', 'Y') //���ҽ��ο���
		dw_autoimhist.SetItem(li_ipRow, 'io_date', arg_date) //���ҽ�������
		dw_autoimhist.SetItem(li_ipRow, 'ioreemp', ls_ioreemp)
	End If
END IF

/* ǰ���ü���԰� ���� Ȯ�� - DYKIM 2023.04.18 */
int li_count

SELECT COUNT(RFNA1)
   INTO :li_count
 FROM REFFPF
WHERE RFNA1 = :ls_itnbr
    AND RFCOD = '1K'
    AND RFGUB <> '00';
	 
If SQLCA.SQLCODE <> 0 THEN
	MessageBox('������','ǰ���ü��� ���� ��ȸ ����')
	return -1
End if

If li_count > 0 Then
	
    SELECT RFNA1, RFNA2, RFNA3, RFNA5 
       INTO :ls_outItnbr, :ls_inItnbr, :ls_outStock, :ls_inStock
      FROM  REFFPF
    WHERE RFNA1 = :ls_itnbr
        AND RFCOD = '1K'
        AND RFGUB <> '00'
        AND ROWNUM = 1;
	
	ls_outIogbn = 'O25' //ǰ���ü���
	ls_inIogbn = 'I13' //ǰ���ü�԰�
	/* ��� */
	li_outRow = dw_autoimhist.InsertRow(0)

    ls_outIojpno = arg_date + String(li_seq, '0000') + String(li_outRow, '000')
	
    dw_autoimhist.SetItem(li_outRow, 'sabu', gs_sabu)
    dw_autoimhist.SetItem(li_outRow, 'jnpcrt', '001')		//��ǥ��������
    dw_autoimhist.SetItem(li_outRow, 'inpcnf', 'O')		//����� ����
    dw_autoimhist.SetItem(li_outRow, 'iojpno', ls_outIojpno)	
    dw_autoimhist.SetItem(li_outRow, 'iogbn', ls_outIogbn)		//���ұ���

    dw_autoimhist.SetItem(li_outRow, 'sudat', arg_date)	//�������
    dw_autoimhist.SetItem(li_outRow, 'itnbr', ls_outItnbr)		//ǰ��
    dw_autoimhist.SetItem(li_outRow, 'pspec', ls_pspec)		//���

    dw_autoimhist.SetItem(li_outRow, 'depot_no', ls_outStock)		//���â��
    dw_autoimhist.SetItem(li_outRow, 'cvcod', ls_inStock)		//�԰�â��
    dw_autoimhist.SetItem(li_outRow, 'ioreqty', ld_ioreqty)		//����Ƿڼ���
    dw_autoimhist.SetItem(li_outRow, 'opseq', ls_opseq)

    dw_autoimhist.SetItem(li_outRow, 'filsk', ls_filsk)
    dw_autoimhist.SetItem(li_outRow, 'botimh', 'N')
    dw_autoimhist.SetItem(li_outRow, 'itgu', ls_itgu)

    dw_autoimhist.SetItem(li_outRow, 'pjt_cd', ls_pjtcd)
    dw_autoimhist.SetItem(li_outRow, 'ip_jpno', ls_ipIojpno)
    dw_autoimhist.SetItem(li_outRow, 'bigo', 'ǰ���ü �ڵ����')
	 
	String ls_outSaupj
    select ipjogun into :ls_outSaupj from vndmst where cvcod = :ls_outStock;  // ��� â���� �ΰ� ����� ������
    dw_autoimhist.SetItem(li_outRow, 'saupj', ls_outSaupj)
	 
	/* �԰�  */
    li_inRow = dw_autoimhist.InsertRow(0)

    ls_inIojpno = arg_date + String(li_seq, '0000') + String(li_inRow, '000')

    dw_autoimhist.SetItem(li_inRow, 'sabu', gs_sabu)
    dw_autoimhist.SetItem(li_inRow, 'jnpcrt', '011')		//��ǥ�������� /* ��ǥ���� 001�̴��κ� 011�� ���� 2023.07.20 by dykim */
    dw_autoimhist.SetItem(li_inRow, 'inpcnf', 'I')		//����� ����
    dw_autoimhist.SetItem(li_inRow, 'iojpno', ls_inIojpno)	
    dw_autoimhist.SetItem(li_inRow, 'iogbn', ls_inIogbn)		//���ұ���
	 
    dw_autoimhist.SetItem(li_inRow, 'sudat', arg_date)	//�������
    dw_autoimhist.SetItem(li_inRow, 'itnbr', ls_inItnbr)		//ǰ��
    dw_autoimhist.SetItem(li_inRow, 'pspec', ls_pspec)		//���

    dw_autoimhist.SetItem(li_inRow, 'depot_no', ls_inStock)		//�԰�â��
    dw_autoimhist.SetItem(li_inRow, 'cvcod', ls_outStock)		//���â��
    dw_autoimhist.SetItem(li_inRow, 'ioreqty', ld_ioreqty)		//����Ƿڼ���
    dw_autoimhist.SetItem(li_inRow, 'opseq', ls_opseq)

    dw_autoimhist.SetItem(li_inRow, 'filsk', ls_filsk)
    dw_autoimhist.SetItem(li_inRow, 'botimh', 'N')
    dw_autoimhist.SetItem(li_inRow, 'itgu', ls_itgu)

    dw_autoimhist.SetItem(li_inRow, 'pjt_cd', ls_pjtcd)
    dw_autoimhist.SetItem(li_inRow, 'ip_jpno', ls_outIojpno)
    dw_autoimhist.SetItem(li_inRow, 'bigo', 'ǰ���ü �ڵ��԰�')
	 
    String ls_inSaupj
    select ipjogun into :ls_inSaupj from vndmst where cvcod = :ls_inStock;  // �԰� â���� �ΰ� ����� ������
    dw_autoimhist.SetItem(li_inRow, 'saupj', ls_inSaupj)
	
	/* ǰ���˻� ����� ��쿡�� ���԰˻� ��Ͽ��� ó���� 2023.07.25 by dykim */
    IF arg_qcgubn = '1'		THEN										// �˻籸��=���˻��� ���
         //���
	    dw_autoimhist.SetItem(li_outRow, 'insdat', arg_date)		//�˻�����
         dw_autoimhist.SetItem(li_outRow, 'iosuqty', ld_ioreqty)		//�հݼ���
         dw_autoimhist.SetItem(li_outRow, 'decisionyn', 'Y')       //�հ�ó��
	
	    //�԰�
         dw_autoimhist.SetItem(li_inRow, 'insdat', arg_date)		//�˻�����
         dw_autoimhist.SetItem(li_inRow, 'iosuqty', ld_ioreqty)		//�հݼ���
         dw_autoimhist.SetItem(li_inRow, 'decisionyn', 'Y')       //�հ�ó��
			
        /* SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
	        INTO :ls_chk
	       FROM VNDMST
	     WHERE CVGU = '5' AND SOGUAN = '1' AND JUMAECHUL = '2' AND CVCOD = :ls_inStock ;*/
	  
	     /*IF cbx_io_confirm.checked THEN
		      ls_chk = 'N'
 	     END IF*/
			
		/*If ls_chk = 'Y' Then /* �������� */
		    //���
		    dw_autoimhist.SetItem(li_outRow, 'ioqty', 0)		//������
		    dw_autoimhist.SetItem(li_outRow, 'io_confirm', 'N') //����ҽ��ο���
		    dw_autoimhist.SetItem(li_outRow, 'io_date', '') //���ҽ�������
		    dw_autoimhist.SetItem(li_outRow, 'ioreemp', '')
		    //�԰�
		    dw_autoimhist.SetItem(li_inRow, 'ioqty', 0)		//������
		    dw_autoimhist.SetItem(li_inRow, 'io_confirm', 'N') //���ҽ��ο���
		    dw_autoimhist.SetItem(li_inRow, 'io_date', '') //���ҽ�������
		    dw_autoimhist.SetItem(li_inRow, 'ioreemp', '')
	     Else
		    //���
		    dw_autoimhist.SetItem(li_outRow, 'ioqty', ld_ioreqty)		//������
		    dw_autoimhist.SetItem(li_outRow, 'io_confirm', 'Y') //����ҽ��ο���
		    dw_autoimhist.SetItem(li_outRow, 'io_date', arg_date) //���ҽ�������
		    dw_autoimhist.SetItem(li_outRow, 'ioreemp', ls_ioreemp)
		    //�԰�
		    dw_autoimhist.SetItem(li_inRow, 'ioqty', ld_ioreqty)		//������
		    dw_autoimhist.SetItem(li_inRow, 'io_confirm', 'Y') //���ҽ��ο���
		    dw_autoimhist.SetItem(li_inRow, 'io_date', arg_date) //���ҽ�������
		    dw_autoimhist.SetItem(li_inRow, 'ioreemp', ls_ioreemp)
	    End If	
		 */
		 
		 /* �����ڵ� 1K�� ��ϵ� ǰ���� �ڵ����� ����� �ǵ��� ���� 2023.07.06 by dykim */
		 //���
		 dw_autoimhist.SetItem(li_outRow, 'ioqty', ld_ioreqty)		//������
		 dw_autoimhist.SetItem(li_outRow, 'io_confirm', 'Y') //����ҽ��ο���
		 dw_autoimhist.SetItem(li_outRow, 'io_date', arg_date) //���ҽ�������
		 dw_autoimhist.SetItem(li_outRow, 'ioreemp', ls_ioreemp)
		 //�԰�
		 dw_autoimhist.SetItem(li_inRow, 'ioqty', ld_ioreqty)		//������
		 dw_autoimhist.SetItem(li_inRow, 'io_confirm', 'Y') //���ҽ��ο���
		 dw_autoimhist.SetItem(li_inRow, 'io_date', arg_date) //���ҽ�������
		 dw_autoimhist.SetItem(li_inRow, 'ioreemp', ls_ioreemp)
    End if
End if

Return 1
end function

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
// ��ǥ���������� '007'
///////////////////////////////////////////////////////////////////////////////////

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_out.settransobject(sqlca)
dw_imhist_nitem_out.settransobject(sqlca)
dw_imhist_nitem_in.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_autoimhist.settransobject(sqlca)

is_Date = f_Today()

rb_insert.TriggerEvent("clicked")
end event

on w_mm01_00010.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.cbx_3=create cbx_3
this.p_1=create p_1
this.dw_imhist_nitem_in=create dw_imhist_nitem_in
this.dw_imhist_nitem_out=create dw_imhist_nitem_out
this.dw_imhist_out=create dw_imhist_out
this.pb_1=create pb_1
this.dw_print=create dw_print
this.cbx_wall=create cbx_wall
this.cbx_print=create cbx_print
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_4=create rr_4
this.rr_3=create rr_3
this.dw_list=create dw_list
this.p_sort=create p_sort
this.cb_1=create cb_1
this.st_2=create st_2
this.dw_imhist=create dw_imhist
this.dw_autoimhist=create dw_autoimhist
this.cbx_move=create cbx_move
this.cbx_io_confirm=create cbx_io_confirm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.rb_insert
this.Control[iCurrent+3]=this.rb_delete
this.Control[iCurrent+4]=this.cbx_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cbx_3
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.dw_imhist_nitem_in
this.Control[iCurrent+9]=this.dw_imhist_nitem_out
this.Control[iCurrent+10]=this.dw_imhist_out
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.dw_print
this.Control[iCurrent+13]=this.cbx_wall
this.Control[iCurrent+14]=this.cbx_print
this.Control[iCurrent+15]=this.rr_1
this.Control[iCurrent+16]=this.rr_2
this.Control[iCurrent+17]=this.rr_4
this.Control[iCurrent+18]=this.rr_3
this.Control[iCurrent+19]=this.dw_list
this.Control[iCurrent+20]=this.p_sort
this.Control[iCurrent+21]=this.cb_1
this.Control[iCurrent+22]=this.st_2
this.Control[iCurrent+23]=this.dw_imhist
this.Control[iCurrent+24]=this.dw_autoimhist
this.Control[iCurrent+25]=this.cbx_move
this.Control[iCurrent+26]=this.cbx_io_confirm
end on

on w_mm01_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.cbx_3)
destroy(this.p_1)
destroy(this.dw_imhist_nitem_in)
destroy(this.dw_imhist_nitem_out)
destroy(this.dw_imhist_out)
destroy(this.pb_1)
destroy(this.dw_print)
destroy(this.cbx_wall)
destroy(this.cbx_print)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_4)
destroy(this.rr_3)
destroy(this.dw_list)
destroy(this.p_sort)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.dw_imhist)
destroy(this.dw_autoimhist)
destroy(this.cbx_move)
destroy(this.cbx_io_confirm)
end on

type dw_insert from w_inherite`dw_insert within w_mm01_00010
boolean visible = false
integer x = 82
integer y = 2184
end type

type p_delrow from w_inherite`p_delrow within w_mm01_00010
boolean visible = false
integer x = 4923
integer y = 152
end type

type p_addrow from w_inherite`p_addrow within w_mm01_00010
boolean visible = false
integer x = 4750
integer y = 152
end type

type p_search from w_inherite`p_search within w_mm01_00010
boolean visible = false
integer x = 4759
integer y = 284
end type

type p_ins from w_inherite`p_ins within w_mm01_00010
boolean visible = false
integer x = 1330
integer y = 188
string powertiptext = "����ī���ȣ �Է�"
end type

event p_ins::clicked;call super::clicked;open(w_barcode)
end event

type p_exit from w_inherite`p_exit within w_mm01_00010
integer x = 4407
integer y = 28
end type

type p_can from w_inherite`p_can within w_mm01_00010
integer x = 4233
integer y = 28
end type

event p_can::clicked;call super::clicked;rb_insert.checked = true
ic_status = '1'	// ���
rb_insert.TriggerEvent("clicked")


end event

type p_print from w_inherite`p_print within w_mm01_00010
boolean visible = false
integer x = 3534
integer y = 28
string picturename = "C:\erpman\image\�μ�_UP.gif"
end type

event p_print::clicked;call super::clicked;If dw_list.RowCount() < 1 Then Return
String ls_baljpno
Long   li , l_balseq, ii = 0

string ls_no[]
long ll_seq[]



if rb_insert.checked  then
	// ���
	For li =1 To dw_list.RowCount()
		If dw_list.GetItemString(li, "p_chk") = 'Y'	Then
			ls_baljpno 	= Trim(dw_list.Object.baljpno[li])
			l_balseq 	= dw_list.Object.balseq[li]
			ii++
			ls_no[ii] 	= ls_baljpno
			ll_seq[ii]	= l_balseq
			Continue
		End If
	Next	
	
else
	
	// ����
	For li =1 To dw_list.RowCount()
		ls_baljpno 	= Trim(dw_list.Object.baljpno[li])
		l_balseq 	= dw_list.Object.balseq[li]
		ii++
		ls_no[ii] 	= ls_baljpno
		ll_seq[ii]	= l_balseq
	Next		
end if

If upperbound(ls_no) < 1 Then
	MessageBox('Ȯ��','��ȸ�� ����Ʈ �߿��� �ش� [���� ǰ��]�� �����ϼ���.')
	Return
End If

If dw_print.Retrieve(GS_SABU, ls_no, ll_seq) > 0 Then
	dw_print.object.datawindow.print.preview = "yes"	
	OpenWithParm(w_print_preview, dw_print)
End If

end event

type p_inq from w_inherite`p_inq within w_mm01_00010
integer x = 3712
integer y = 28
end type

event p_inq::clicked;call super::clicked;integer ix

if dw_detail.Accepttext() = -1	then 	return
if is_barmode = 'Y' then
	messagebox('Ȯ��','BAR CODE �Է� ����Դϴ�!!!')
	return
end if

string  	sGubun, sGubun2,		&
			sNull, sfdate, stdate, scvcod ,ls_gubun ,ls_injpno,ls_baljuno, ls_ittyp, ls_saupj
long		lRow 
integer	irtn
Decimal{3}  dQty, dprice

SetNull(sNull)

SetPointer(HourGlass!)  

dw_list.setredraw(false)


//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	ls_injpno = trim(dw_detail.getitemstring(1, "in_jpno"))
	sGubun = trim(dw_detail.getitemstring(1, "gubun"))
	stdate = trim(dw_detail.getitemstring(1, "tdate"))
	sfdate = f_afterday((dw_detail.getitemstring(1, "tdate")),-3)
	
	sGubun2= trim(dw_detail.getitemstring(1, "gubun2"))
	scvcod = dw_detail.getitemstring(1, "vendor")
	ls_baljuno= dw_detail.getitemstring(1, "baljuno")
	ls_ittyp = dw_detail.GetItemString(1, 'ittyp')
	ls_saupj = dw_detail.GetItemString(1, 'saupj')
	
	If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'
	
	//If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'
	
	if isnull(ls_baljuno) or ls_baljuno = '' then 
		ls_baljuno = '%'
	else 
		ls_baljuno = ls_baljuno + '%'
	end if
	
	if isnull(scvcod) or scvcod = '' then scvcod = '%'

	IF f_datechk(sTdate) = -1 	THEN
		dw_list.setredraw(true)
		f_message_chk(30,'[��������]')
		dw_detail.SetColumn("fdate")
		dw_detail.SetFocus()
		This.Enabled = True
		RETURN
	END IF
	
	IF isnull(ls_ittyp) or ls_ittyp = "" 	THEN
		f_message_chk(30,'[ǰ�񱸺�]')
		dw_detail.SetColumn("ittyp")
		dw_detail.SetFocus()
		RETURN
	END IF

//	if sfdate < f_today() then
//		messagebox('Ȯ��','�������ڸ� �������� �������� ������ �� �����ϴ�.')
//		dw_detail.setcolumn('fdate')
//		dw_detail.setfocus()
//		return
//	end if

	If sgubun = '1' Then
		dw_list.dataobject = 'd_mm01_00010_a'
	Else
		dw_list.dataobject = 'd_mm01_00010_a_1'
	End if
	dw_list.settransobject(sqlca)

	wf_setfilter()
	
   //==========================================================================================	
//	IF	dw_list.Retrieve(sGubun2, gs_sabu, scvcod,ls_baljuno, sfdate, sTdate, ls_ittyp) <	1		THEN
	/* ����� ��ȸ���� �߰� - by shingoon 2016.03.02 */
	IF	dw_list.Retrieve(ls_saupj, sGubun2, gs_sabu, scvcod,ls_baljuno, sfdate, sTdate, ls_ittyp) <	1		THEN
		dw_list.setredraw(true)
		f_message_chk(50, '[���ϳ���]')
		dw_detail.setcolumn("fdate")
		dw_detail.setfocus()
		This.Enabled = True
//		dw_list.SetSQLSelect(ls_oldsql)
		Return 
	END IF
	
	
	// �˻籸��, �˻�����
	IF wf_Danmst() = -1	THEN
		This.Enabled = True
		dw_list.setredraw(true)
//		dw_list.SetSQLSelect(ls_oldsql)
		RETURN
	END IF	
	
	// �����ܷ������� �ڵ����� �԰�������� ��ȸ 
	/*    ��ǰ������ 0�̸� �����ܷ����� ������ �Է�  rcqty_h*/
	
//-- �ڵ����� ���ó���� ������ ������ ����ϳ� ������ Ȯ�� �����ϱ� ���� remark
//	for ix = 1 to dw_list.rowcount()
//		dQty	=  dw_list.getitemdecimal(ix,"naqty") - dw_list.getitemdecimal(ix,"rcqty_h")
//		if	dQty <= 0	then 
//			dQty	= dw_list.getitemdecimal(ix,"balju")
//		end if
//		dw_list.SetItem(ix, "inqty" , dQty)
//		
//		dPrice = dw_list.getitemdecimal(ix, "unprc")
//		if isnull(dqty) or dqty <= 0 then 
//			dw_list.SetItem(ix, "chk_flag", 'N')	
//			return
//		else
//			dw_list.SetItem(ix, "chk_flag", 'Y')	
//		end if	
//		
//		dw_list.SetItem(ix, "inamt", Truncate(dQty * dPrice, 0))		
//	next
//   //======================================================================
//   dw_list.SetSQLSelect(ls_oldsql)            // sql�� ������� �س��� 
	//=======================================================================
ELSE
	string	sjpno, ls_balno
	sjpno = trim(dw_detail.getitemstring(1, "jpno"))
	ls_balno = trim(dw_detail.getitemstring(1, "baljuno"))

	if isnull(sjpno) or sjpno = '' then 
		sjpno = '%'
	else 
		sjpno = sjpno + '%'
	end if
	
	if isnull(ls_balno) or ls_balno = '' then 
		ls_balno = '%'
	else 
		ls_balno = ls_balno + '%'
	end if
	
	
/*	if isnull(sjpno) or sjpno = '' or len(sjpno) < 12 then
		dw_list.setredraw(true)
		f_message_chk(30,'[�԰��ȣ]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		This.Enabled = True
		RETURN
	END IF  */ 
	
	IF	dw_list.Retrieve(gs_sabu, sjpno, '%' ,ls_balno) <	1		THEN
		dw_list.setredraw(true)
		f_message_chk(50, '[���ϳ���]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		This.Enabled = True
		RETURN
	END IF
	
	wf_Update_Gubun()
	p_del.enabled = true
	p_del.picturename = "C:\erpman\image\����_up.gif"
END IF
dw_list.setredraw(true)


//dw_detail.enabled = false

dw_list.SetFocus()
p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\����_up.gif"

This.Enabled = True

SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_mm01_00010
integer x = 4059
integer y = 28
end type

event p_del::clicked;call super::clicked;if is_barmode = 'Y' then
	messagebox('Ȯ��','BAR CODE �Է� ����Դϴ�!!!')
	return
end if

//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
String sError, sGubun, sIojpno, sWigbn
int    ireturn 

SetPointer(HourGlass!)

if ic_status = '1' then return
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

type p_mod from w_inherite`p_mod within w_mm01_00010
integer x = 3886
integer y = 28
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. �԰���� = 0		-> RETURN
//		2. �����HISTORY : ��ǥä������('C0')
//
//////////////////////////////////////////////////////////////////////////////////

string sdate, sWigbn, sError, sIojpno, sGubun
long	 lRow
dec	 dSeq
long		lfrow, lmail=0, ix
string	sjpno

//IF ic_status = '2'	THEN 
//	MessageBox('Ȯ��','��� �����϶� ���� �����մϴ�.')
//	Return
//End if

IF	wf_CheckRequiredField() = -1		THEN	RETURN 

IF f_msg_update() = -1 	THEN	RETURN

lmail=0

IF ic_status = '1' THEN
	String  ls_saupj
	ls_saupj = dw_detail.GetItemString(1, 'saupj')
	If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
		MessageBox('Ȯ��', '������� ���� �Ͻʽÿ�.')
		Return
	End If

	// ���԰˻�ǰ���� 1�� �̻��� ��� ���� ������
	For ix = 1 To dw_list.RowCount()
		If dw_list.GetItemString(ix, 'qcgubun') > '1' Then
			lmail = ix
			exit;
		End If
	Next
	
//	///1.���ֻ��� ����/////////////////////////////////////////////////////
//	IF wf_poblkt_update() < 0 THEN RETURN 
// st_2.Visible = True
//	st_2.Text = '�԰��ڷ� ���� ��... Step 1'
	///2.�԰��ڷ� ����/////////////////////////////////////////////////////
	IF wf_imhist_create(sdate, dseq) < 0 THEN RETURN 
//	st_2.Text = '����̵�����ڷ� ���� ��...'	
	IF dw_autoimhist.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF	
//	st_2.Text = '�԰��ڷ� ���� ��... Step 2'	
	IF dw_imhist.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF
//	st_2.Text = '�԰��ڷ� ���� ��... Step 3'
	IF dw_imhist_out.Update() <> 1	THEN
		ROLLBACK;
		f_Rollback()
		RETURN		
	END IF
	
	If dw_imhist.RowCount() > 0 Then 	
		/////////////////////////////////////////////////////////////////////////
		sjpno	= left(dw_imhist.GetItemString(1,"iojpno"),12)
		lfrow	= dw_imhist.find("iogbn='I03'",1,dw_imhist.rowcount())
		if lfrow > 0 then
			swigbn = 'Y'
		else
			swigbn = 'N'
		end if
		
		/* ���ְ��� �Ǵ� �����԰��� ��쿡�� ������� �ڵ������ڷ� ���� 
			-. �� �˻����ڰ� �ִ� ��쿡 �� ��  - 2004.01.07 - �ۺ�ȣ */
		if sWigbn = 'Y' Then
			sError = 'X';
//			st_2.Text = '������� �ڵ������ڷ� ���� ��...'
			sqlca.erp000000360(gs_sabu, sjpno, 'I', sError);
			if sError = 'X' or sError = 'Y' then
				f_message_chk(41, '[�����ڵ����]')
				Rollback;
				return 
			end if
		end if
		
		
		///3.��ǰ���-��ǰ�԰�////////////////////////////////////////////////
		//IF wf_imhist_create_nitem() < 0 THEN RETURN 
		
		
		///4.����ǰó��///////////////////////////////////////////////////////
		if swigbn = 'Y' then
//			st_2.Text = '����ǰ ó�� ��...'
			IF wf_imhist_create_waiju() <> 1 THEN return
		end if
	End If
Else	
//	IF wf_imhist_update() = -1	THEN RETURN

	IF dw_list.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		return 
	END IF

	/* �԰����°� �������� check	*/
	sjpno	= left(dw_list.GetItemString(1,"imhist_iojpno"),12)
	lfrow	= dw_list.find("imhist_iogbn='I03'",1,dw_list.rowcount())
	if lfrow > 0 then
		swigbn = 'Y'
	else
		swigbn = 'N'
	end if
	
	/* ���ְ��� �Ǵ� �����԰��� ��쿡�� ������� �ڵ������ڷ� �����׻��� 
		-. �� �˻����ڰ� �ִ� ��쿡 �� ��*/
	if sWigbn = 'Y' Then
		sError 	= 'X';
		dw_detail.accepttext()
		sIojpno = dw_detail.GetItemString(1, "jpno")
		sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);	/* ���� */
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[�����ڵ����]')
			Rollback;
			return -1
		end if;
		sqlca.erp000000360(gs_sabu, sIoJpno, 'I', sError);	/* ���� */
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[�����ڵ����]')
			Rollback;
			return -1
		end if;		
	end if;

	IF wf_imhist_update_waiju() <> 1 THEN return
End If


/// SCM ���� ���ֻ��� ����/////////////////////////////////////////////////////
IF wf_poblkt_update() < 0 THEN RETURN 

Commit;	
	
//MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(dSeq,"0000")+		&
//										 "~r~r�����Ǿ����ϴ�.")

//If lmail > 0 Then
//	gs_code = '���԰˻� �Ƿ� �뺸'
//	gs_codename = '��ü�� : ' + dw_list.GetItemString(lmail, 'cvnas') + '~r~n~r~n' + 'ǰ  �� : ' + dw_list.GetItemString(lmail, 'itemas_itdsc') + ' ��'
//	gs_gubun = 'w_mm01_00010'
//	Open(w_mail_insert)
//Else
//	messagebox('Ȯ��','�ڷḦ �����Ͽ����ϴ�')
//End If

////////////////////////////////////////////////////////////////////////
//rb_delete.Checked = True
//rb_delete.TriggerEvent(Clicked!)

is_barmode = 'N'
p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)

end event

type cb_exit from w_inherite`cb_exit within w_mm01_00010
end type

type cb_mod from w_inherite`cb_mod within w_mm01_00010
end type

type cb_ins from w_inherite`cb_ins within w_mm01_00010
end type

type cb_del from w_inherite`cb_del within w_mm01_00010
end type

type cb_inq from w_inherite`cb_inq within w_mm01_00010
end type

type cb_print from w_inherite`cb_print within w_mm01_00010
end type

type st_1 from w_inherite`st_1 within w_mm01_00010
end type

type cb_can from w_inherite`cb_can within w_mm01_00010
end type

type cb_search from w_inherite`cb_search within w_mm01_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_mm01_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_mm01_00010
end type

type dw_detail from datawindow within w_mm01_00010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 73
integer y = 40
integer width = 2999
integer height = 168
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_mm01_00010_1"
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

event itemchanged;string	scode, sName1,	sname2, sNull, sjpno, sdate, scust, sempno, sgubun, sbalno, sblno, &
         scustname, sempname, s_today, soldcode, sBalgu, sWaigu, sLocal, sLcno
int      ireturn, get_count 
			
SetNull(sNull)

Choose	Case 	this.GetColumnName() 
	Case	'empno'
	
		sDate = trim(this.gettext())
		if sdate = '' or isnull(sdate) then return 1

	Case 'fdate' , 'tdate' 

		sDate = trim(this.gettext())
		if sdate = '' or isnull(sdate) then return 
		
		IF f_datechk(sDate) = -1	then
			f_message_chk(35,'[��¥]')
		
			return 1
		END IF
	
	Case 	"vendor"
		scode = this.GetText()
		
		ireturn = f_get_name2('V1', 'Y', scode, sname1, sname2)
		this.setitem(1, "vendor", scode)	
		this.setitem(1, "vendorname", sname1)	
		RETURN ireturn

	Case	'jpno'

		sJpno = TRIM(this.GetText())
	
		IF sJPno = '' or isnull(sJpno) or len(sjpno) < 12 then
			this.setitem(1, "jpno", sNull)
			this.SetItem(1, "empno",	sNull)
			this.SetItem(1, "empname", sNull)
			return 1
		END IF
		/* �ڵ����� �߰�(IM7) - BY SHINGOON 2016.02.27 */
		SELECT IOREEMP, FUN_GET_EMPNO(IOREEMP)
		  INTO :sEmpno, :sEmpName 
		  FROM IMHIST
		 WHERE SABU = :gs_sabu			AND
				 IOJPNO like :sJpno||'%'	AND
				 IOGBN IN ('I01','I03','IM7') and rownum = 1;
		 
		IF SQLCA.SQLCODE <> 0	THEN
			f_message_chk(33,'[�԰��ȣ]')
			this.setitem(1, "jpno", sNull)
			RETURN 1
		END IF
		
		this.SetItem(1, "empno",	sEmpno)
		this.SetItem(1, "empname", sEmpname)
		p_inq.triggerevent(clicked!)
	
	Case 	"ittyp"
		scode = this.GetText()
		
		// ǰ�񱸺��� ����ǰ�� ��� �԰���� üũ
		if scode = '1' then
//			cbx_io_confirm.checked = true
			cbx_io_confirm.checked = false
		else
			cbx_io_confirm.checked = false
		end if
END Choose

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// �԰���δ����
IF this.GetColumnName() = 'empno'	THEN
   gs_gubun = '1' 
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
	SetItem(1,"empname",gs_codename)
ElseIF this.GetColumnName() = 'in_jpno'	THEN
	
	Open(w_mm01_00010_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"in_jpno",gs_code)
ELSEIF this.GetColumnName() = 'jpno'	THEN
	gs_gubun = '007'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")
//ELSEif this.getcolumnname() = 'balno' then
//	open(w_poblkt_popup)
//	setitem(1, "balno", Trim(left(gs_code, 12)))
//	this.TriggerEvent("itemchanged")	
//ELSEif this.getcolumnname() = 'blno' then
//	open(w_bl_popup3)
//	setitem(1, "blno", gs_code)
//	this.TriggerEvent("itemchanged")	
//ELSEIF this.GetColumnName() = 'lcno'	THEN
//	gs_gubun = 'LOCAL' 
//	Open(w_lc_popup)
//	if Isnull(gs_code) or Trim(gs_code) = "" then return
//	THIS.SetItem(1,"lcno",	gs_code)
//	this.TriggerEvent("itemchanged")	
//ELSE
ElseIF this.GetColumnName() = "vendor" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then return
	this.SetItem(1, "vendor", gs_Code)
	this.TriggerEvent("itemchanged")	
ElseIF this.GetColumnName() = "baljuno" THEN
	gs_gubun = '2' //�������û��� => 1:�Ƿ�
	open(w_poblkt_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
   this.setitem(1, 'baljuno', gs_code)
//   p_inq.TriggerEvent(Clicked!)
//   return 1 	
END IF


end event

type rb_insert from radiobutton within w_mm01_00010
integer x = 3634
integer y = 224
integer width = 219
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "���"
boolean checked = true
end type

event clicked;ic_status = '1'	// ���

cb_1.Enabled = True

dw_list.setredraw(False)
wf_Initial()
dw_list.setredraw(true)




end event

type rb_delete from radiobutton within w_mm01_00010
integer x = 3936
integer y = 224
integer width = 219
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "����"
end type

event clicked;ic_status = '2'

cb_1.Enabled = False

dw_list.setredraw(false)
wf_Initial()
dw_list.setredraw(true)


end event

type cbx_2 from checkbox within w_mm01_00010
integer x = 3150
integer y = 96
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "���� ����"
boolean checked = true
end type

type cbx_1 from checkbox within w_mm01_00010
integer x = 3150
integer y = 40
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��� ó��"
boolean checked = true
end type

type cbx_3 from checkbox within w_mm01_00010
integer x = 3150
integer y = 156
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "�̳� �ڷ�"
end type

type p_1 from picture within w_mm01_00010
integer x = 4233
integer y = 172
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\barcode.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow, lrowcnt
string	sgubun

IF ic_status = '2'	THEN 
	MessageBox('Ȯ��','��� �����϶� �����մϴ�.')
	Return
End if
	
String  ls_saupj
ls_saupj = dw_detail.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('Ȯ��', '���� ������� ���� �Ͻʽÿ�.')
	dw_detail.SetFocus()
	dw_detail.SetColumn('saupj')
	Return
End If

String  ls_ittyp
ls_ittyp = dw_detail.GetItemString(1, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
	MessageBox('Ȯ��', 'ǰ�񱸺��� ���� �Ͻʽÿ�.')
	dw_detail.SetFocus()
	dw_detail.SetColumn('ittyp')
	Return
End If

is_barmode = 'Y'

open(w_barcode)
if gs_gubun = 'OK' then
	dw_list.dataobject = 'd_mm01_00010_a_bar'
	dw_list.settransobject(sqlca)
	
	dw_list.setfilter("")
	dw_list.filter()
	
	setpointer(hourglass!)
	lrowcnt = dw_list.retrieve(ls_saupj, gs_code, ls_ittyp)
	FOR lrow = 1 TO lrowcnt
//		If dw_list.getitemdecimal(lrow,"naqty") > dw_list.getitemdecimal(lrow,"balju") Then
//			MessageBox('ǰ�� : '+ dw_list.GetItemString(lrow, 'itnbr'), '�����ܷ����� ��ǰ������ �ʰ��Ǿ����ϴ�.!!')
//			dw_list.setitem(lrow,"inqty",dw_list.getitemdecimal(lrow,"balju"))
//		Else
//			dw_list.setitem(lrow,"inqty",dw_list.getitemdecimal(lrow,"naqty"))
//		End If

		dw_list.setitem(lrow,"inqty",dw_list.getitemdecimal(lrow,"naqty"))
		
		dw_list.SetItem(lrow,"chk_flag",'Y')
		sGubun = dw_list.GetItemString(lRow, "pomast_balgu")  // ���� : 1  , ���� : 3
	NEXT

	If sGubun = '3' Then
		dw_detail.setitem(1,'gubun','2')
	Else
		dw_detail.setitem(1,'gubun','1')
	End if

	
	if lrowcnt > 0 then
		p_mod.enabled = true
		p_mod.picturename = "C:\erpman\image\����_up.gif"
	end if		

	// �˻籸��, �˻�����
	wf_Danmst()

end if
end event

type dw_imhist_nitem_in from datawindow within w_mm01_00010
boolean visible = false
integer x = 4713
integer y = 1620
integer width = 1600
integer height = 360
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_nitem_in"
string dataobject = "d_pdt_imhist"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist_nitem_out from datawindow within w_mm01_00010
boolean visible = false
integer x = 4713
integer y = 848
integer width = 1600
integer height = 360
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_nitem_out"
string dataobject = "d_pdt_imhist"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist_out from datawindow within w_mm01_00010
boolean visible = false
integer x = 1893
integer y = 520
integer width = 1600
integer height = 360
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "dw_imhist_out"
string dataobject = "d_pdt_imhist"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
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

type pb_1 from u_pb_cal within w_mm01_00010
integer x = 1166
integer y = 44
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_detail.SetColumn('Tdate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_detail.SetItem(1, 'Tdate', gs_code)

end event

type dw_print from datawindow within w_mm01_00010
boolean visible = false
integer x = 123
integer y = 972
integer width = 2363
integer height = 1140
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "���ϳ���"
string dataobject = "d_mm01_00010_1_p"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_wall from checkbox within w_mm01_00010
integer x = 261
integer y = 244
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��üó��"
end type

event clicked;Boolean   bchk
decimal {3}  dqty, dPrice
integer ix

bChk	=  cbx_wall.Checked
For ix = 1 to dw_list.Rowcount()		
	if bChk = True then
		dQty	=  dw_list.getitemdecimal(ix,"naqty") - dw_list.getitemdecimal(ix,"rcqty_h")
		if	dQty <= 0	then 
			dQty	= dw_list.getitemdecimal(ix,"balju")
		end if
		
		If dQty > dw_list.getitemdecimal(ix,"balju") Then
			dQty = dw_list.getitemdecimal(ix,"balju")
		End If
		
		dw_list.SetItem(ix, "inqty" , dQty)
		
		dPrice = dw_list.getitemdecimal(ix, "unprc")
		if isnull(dqty) or dqty <= 0 then 
			dw_list.SetItem(ix, "chk_flag", 'N')	
		else
			dw_list.SetItem(ix, "chk_flag", 'Y')	
		end if	
		dw_list.SetItem(ix, "inamt", Truncate(dQty * dPrice, 0))		
		dw_list.SetItem(ix, "w_chk", 'Y')		
		dw_list.SetItem(ix, 'yebi1', left(dw_detail.getitemstring(1,'tdate'),6))
	else
		dw_list.SetItem(ix, "inqty" , 0)
		dw_list.SetItem(ix, "chk_flag", 'N')	
		dw_list.SetItem(ix, "inamt", 0)		
		dw_list.SetItem(ix, "w_chk", 'N')		
		dw_list.SetItem(ix, 'lotsno', '')
		dw_list.SetItem(ix, 'yebi1', '')
	end if		
next

end event

type cbx_print from checkbox within w_mm01_00010
boolean visible = false
integer x = 119
integer y = 232
integer width = 96
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
end type

event clicked;Boolean   bchk
integer ix
bChk	=  this.Checked
For ix = 1 to dw_list.Rowcount()		
	if bChk = True then
		dw_list.SetItem(ix, "p_chk", 'Y')		
	else
		dw_list.SetItem(ix, "p_chk", 'N')		
   end if		
next

end event

type rr_1 from roundrectangle within w_mm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 28
integer width = 3031
integer height = 192
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_mm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3547
integer y = 196
integer width = 667
integer height = 112
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_mm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3099
integer y = 28
integer width = 430
integer height = 196
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_mm01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 324
integer width = 4553
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_mm01_00010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 336
integer width = 4517
integer height = 1944
integer taborder = 50
string dataobject = "d_mm01_00010_a_1"
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

event editchanged;dec{3} dQty
dec{5} dPrice
long	lRow
string	schk

lRow = this.GetRow()

// �԰����
IF this.getcolumnname() = "inqty"		THEN
	dQty   = dec(this.gettext() )
	dPrice = this.getitemdecimal(lRow, "unprc")
	
	if isnull(dqty) or dqty <= 0 then 
		this.SetItem(lRow, "chk_flag", 'N')	
		return
	else
		this.SetItem(lRow, "chk_flag", 'Y')	
	end if	
	
   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		

//ELSEIF this.getcolumnname() = "imhist_ioreqty"		THEN
//
//	this.AcceptText()
//	dQty   = this.getitemdecimal(lRow, "imhist_ioreqty") 
//	dPrice = this.getitemdecimal(lRow, "imhist_ioprc")
//	
//   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
//
//ELSEIF this.getcolumnname() = "unprc"		THEN
//	this.AcceptText()
//	dQty   = this.getitemdecimal(lRow, "inqty") 
//	dPrice = this.getitemdecimal(lRow, "unprc")
//	
//   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))	
//	
END IF

end event

event itemchanged;dec {2}	  dBalRate
dec {3}  dQty,  dCinqty, dtemp, DtEMP1, dInqty, dPrice
long		lRow, frow , ireturn 
String   sNull , schk ,ls_in_no

SetNull(sNull)

lRow  = this.GetRow()	

this.accepttext()


// �԰���� > �԰��ܷ� �̸� ERROR(�ű��Է½�)
Choose	Case 	this.GetColumnName() 
	case 'w_chk'
		schk = this.gettext()
		if	sChk = 'Y'	then
			dQty	=  dw_list.getitemdecimal(lRow,"naqty") - dw_list.getitemdecimal(lRow,"rcqty_h")
			if	dQty <= 0	then 
				dQty	= dw_list.getitemdecimal(lRow,"balju")
			end if
			
			If dQty > dw_list.getitemdecimal(lRow,"balju") Then
				dQty = dw_list.getitemdecimal(lRow,"balju")
			End If
			
			dw_list.SetItem(lRow, "inqty" , dQty)
			
			dPrice = dw_list.getitemdecimal(lRow, "unprc")
			if isnull(dqty) or dqty <= 0 then 
				dw_list.SetItem(lRow, "chk_flag", 'N')	
			else
				dw_list.SetItem(lRow, "chk_flag", 'Y')	
			end if	
			dw_list.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
			dw_list.SetItem(lRow, 'yebi1', left(dw_detail.getitemstring(1,'tdate'),6))
		else
			dw_list.SetItem(lRow, "inqty" , 0)
			dw_list.SetItem(lRow, "chk_flag", 'N')	
			dw_list.SetItem(lRow, "inamt", 0)		
			dw_list.SetItem(lRow, 'lotsno', '')
			dw_list.SetItem(lRow, 'yebi1', sNull)
		end if
	case 'poblkt_balsts'
			
			dQty   = this.getitemdecimal(lRow, 'inqty')
			dPrice = this.getitemdecimal(lRow, "unprc")
			
			if isnull(dqty) or dqty <= 0 then 
				this.SetItem(lRow, "chk_flag", 'N')	
				return
			else
				this.SetItem(lRow, "chk_flag", 'Y')	
			end if	
			
			this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
		
	Case	"inqty" 
	
		dInqty   = dec(this.GetText())
		dQty     = this.GetItemDecimal(lRow, "balju")
		dBalRate = this.GetItemDecimal(lRow, "itemas_balrate")
		if isnull(dBalRate) OR dBalRate < 100 THEN  dBalRate = 100
		
//		If dinqty > dqty Then
		IF dInqty > truncate(dQty * dBalRate / 100, 3)	THEN
		
			MessageBox('Ȯ��' ,'�԰��� �����ܷ����� Ŭ�� �����ϴ�. ')
			This.Object.inqty[lrow] = 0
			This.Object.w_chk[lrow] = 'N'
			SetColumn("inqty")
			Return 1
		End if
	
		If dQty > 0 Then
			This.Object.w_chk[lrow] = 'Y'
		Else
			This.Object.w_chk[lrow] = 'N'
		End IF
	Case 	"chk_flag"	
		schk = this.gettext()
		ls_in_no = Trim(Object.jpno[row])
		
		
		frow 	= Find("jpno = '"+ls_in_no+"'",1,RowCount())
		
		if schk = 'Y' then
			Do While frow > 0
				/*    ��ǰ������ 0�̸� �����ܷ����� ������ �Է� */
				dQty	= this.getitemdecimal(fRow,"naqty")
				if	dQty < 0	then 
					dQty	= this.getitemdecimal(fRow,"balju")
				end if
				this.SetItem(fRow,"inqty",dQty)
				this.SetItem(fRow,"chk_flag",'Y')
				if frow = this.rowcount() then exit
				frow = Find("jpno = '"+ls_in_no+"'",frow + 1,RowCount())
				If frow < 1 Then Exit
			Loop
		Else
			Do While frow > 0
				this.SetItem(fRow,"inqty",0)
				this.SetItem(fRow,"chk_flag",'M')
				if frow = this.rowcount() then exit
				frow = Find("jpno = '"+ls_in_no+"'",frow + 1,RowCount())
				If frow < 1 Then Exit
			Loop
			
		End If

	Case 	 "p_chk"
		
		
		return 0
		
		/*  ����� �Ѱ��� ����� �ϱ⿡ �ʿ����.  */
		schk = this.gettext()
		ls_in_no = Trim(Object.jpno[row])
		
		
		frow 	= Find("jpno = '"+ls_in_no+"'",1,RowCount())
		
		if schk = 'Y' then
			Do While frow > 0
				/*    ��ǰ������ 0�̸� �����ܷ����� ������ �Է� */
				dQty	= this.getitemdecimal(fRow,"naqty")
				if	dQty < 0	then 
					dQty	= this.getitemdecimal(fRow,"balju")
				end if
				this.SetItem(fRow,"inqty",dQty)
				this.SetItem(fRow,"p_chk",'Y')
				if frow = this.rowcount() then exit
				frow = Find("jpno = '"+ls_in_no+"'",frow + 1,RowCount())
				If frow < 1 Then Exit
			Loop
		Else
			Do While frow > 0
				this.SetItem(fRow,"inqty",0)
				this.SetItem(fRow,"p_chk",'N')
				if frow = this.rowcount() then exit
				frow = Find("jpno = '"+ls_in_no+"'",frow + 1,RowCount())
				If frow < 1 Then Exit
			Loop
			
		End If
		
	Case 'lotsno'
		String ls_lot
		Long   ll_dup
		
		ls_lot = This.GetItemString(row, 'lotsno')
		
		SELECT COUNT('X')
		  INTO :ll_dup
		  FROM IMHIST
		 WHERE IOGBN IN ('I01', 'I03')
		   AND LOTSNO = :ls_lot ;
		If ll_dup < 1 Then Return
		
		MessageBox('Lot No. �ߺ�', '�Է��� Lot No. �� �̹� �Էµ� ��ȣ �Դϴ�.')
		SetNull(ls_lot)
		This.SetItem(row, 'lotsno', ls_lot)
		
		Return 1

END Choose


end event

event itemerror;//////////////////////////////////////////////////////////////////////////////
////		* Error Message Handling  1
//////////////////////////////////////////////////////////////////////////////
//
////	1) ItemChanged -> Required Column �� �ƴ� Column ���� Error �߻��� 
//
//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF
//
//
//
////	2) Required Column  ���� Error �߻��� 
//
//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//w_mdi_frame.sle_msg.text = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."
//
//RETURN 1
//	
//	

RETURN 1
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// �԰�ó(�Է½� â��)
IF this.GetColumnName() = 'vendor'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"vendor",		gs_code)
	SetItem(lRow,"vendorname", gs_codename)
	this.TriggerEvent("itemchanged")

// �԰�ó(������ â��)
ELSEIF this.GetColumnName() = 'imhist_depot_no'	THEN

	Open(w_vndmst_46_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"imhist_depot_no", gs_code)
	SetItem(lRow,"vendorname", gs_codename)
//	this.TriggerEvent("itemchanged")

	/* ������ȣ */
ELSEIF this.GetColumnName() = "kumno" THEN 
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		SetItem(lRow,'kumno', gs_code)
END IF



end event

event rowfocuschanged;If currentrow <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(currentrow,TRUE)
END IF
end event

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

type p_sort from picture within w_mm01_00010
integer x = 4407
integer y = 172
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_list)
end event

type cb_1 from commandbutton within w_mm01_00010
integer x = 672
integer y = 228
integer width = 594
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�԰� LOT No. ����"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_list.RowCount()
If ll_cnt < 1 Then Return

String ls_dat

ls_dat = dw_detail.GetItemString(1, 'tdate')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then
	MessageBox('�������� Ȯ��', '�������ڸ� Ȯ�� �Ͻñ� �ٶ��ϴ�.')
	dw_detail.SetColumn('tdate')
	dw_detail.SetFocus()
	Return 
End If

String ls_max

SELECT MAX(LOTSNO)
  INTO :ls_max
  FROM IMHIST
 WHERE IOGBN IN ('I01', 'I03')
   AND SUDAT =  :ls_dat ;
	
If Trim(ls_max) = '' OR IsNull(ls_max) Then
	ls_max = '001'
Else
	ls_max = String(Long(RIGHT(ls_max, 3)) + 1, '000')
End If

Long   i

String ls_chk
String ls_itm
String ls_typ

//MessageBox('�԰� LOT No. ����', 'ǰ�񱸺��� ������ COIL�� ǰ�� ���� �˴ϴ�!!')
MessageBox('�԰� LOT No. ����', 'ǰ�񱸺��� ������ �� ������ COIL�� ǰ�� ���� �˴ϴ�!!')
For i = 1 To ll_cnt
	ls_chk = dw_list.GetItemString(i, 'w_chk')
	ls_itm = dw_list.GetItemString(i, 'itnbr')
	
	If ls_chk = 'Y' Then	
		SELECT ITTYP
		  INTO :ls_typ
		  FROM ITEMAS
		 WHERE SABU  = :gs_sabu
			AND ITNBR = :ls_itm  ;
		//  ���� ls_typ = '4' ������ �߰� (2011�� 3�� 30��)
		If ls_typ = '4' Then
			dw_list.SetItem(i, 'lotsno', ls_dat + ls_max)
			ls_max = String(Long(ls_max) + 1, '000')
		Else
			If LEFT(ls_itm, 1) = 'C' Then
				If ls_typ = '3' Then
					dw_list.SetItem(i, 'lotsno', ls_dat + ls_max)
					ls_max = String(Long(ls_max) + 1, '000')
				End If
			End If
		End If
	End If
	
	// 2017.07.26 - �������� LOT-NO�� �԰����ڷ� ����/ �ۺ�ȣ
	dw_list.SetItem(i, 'loteno', ls_dat)
Next
end event

type st_2 from statictext within w_mm01_00010
boolean visible = false
integer x = 1147
integer y = 1496
integer width = 2574
integer height = 376
boolean bringtotop = true
integer textsize = -36
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_imhist from datawindow within w_mm01_00010
boolean visible = false
integer x = 366
integer y = 548
integer width = 1166
integer height = 388
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "dw_imhist"
string dataobject = "d_pdt_imhist"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
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

type dw_autoimhist from datawindow within w_mm01_00010
boolean visible = false
integer x = 1093
integer y = 1528
integer width = 686
integer height = 400
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "dw_autoimhist"
string dataobject = "d_mm01_00010_auto"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_move from checkbox within w_mm01_00010
integer x = 1349
integer y = 244
integer width = 448
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "����̵����"
boolean checked = true
end type

type cbx_io_confirm from checkbox within w_mm01_00010
integer x = 3054
integer y = 240
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "�԰� ���� PASS"
end type

