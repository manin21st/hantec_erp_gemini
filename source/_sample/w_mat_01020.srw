$PBExportHeader$w_mat_01020.srw
$PBExportComments$���� ��ǰ  ���
forward
global type w_mat_01020 from window
end type
type cb_2 from commandbutton within w_mat_01020
end type
type cb_1 from commandbutton within w_mat_01020
end type
type dw_print from datawindow within w_mat_01020
end type
type pb_1 from u_pb_cal within w_mat_01020
end type
type p_exit from uo_picture within w_mat_01020
end type
type p_cancel from uo_picture within w_mat_01020
end type
type p_delete from uo_picture within w_mat_01020
end type
type p_save from uo_picture within w_mat_01020
end type
type p_retrieve from uo_picture within w_mat_01020
end type
type p_delrow from uo_picture within w_mat_01020
end type
type p_addrow from uo_picture within w_mat_01020
end type
type p_2 from uo_picture within w_mat_01020
end type
type dw_imhist from datawindow within w_mat_01020
end type
type rb_delete from radiobutton within w_mat_01020
end type
type rb_insert from radiobutton within w_mat_01020
end type
type dw_detail from datawindow within w_mat_01020
end type
type dw_list from datawindow within w_mat_01020
end type
type rr_1 from roundrectangle within w_mat_01020
end type
end forward

global type w_mat_01020 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "���� ��ǰ ���"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_open ( )
cb_2 cb_2
cb_1 cb_1
dw_print dw_print
pb_1 pb_1
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
p_delrow p_delrow
p_addrow p_addrow
p_2 p_2
dw_imhist dw_imhist
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
end type
global w_mat_01020 w_mat_01020

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

String     is_ispec ,  is_jijil
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_update ()
public function integer wf_imhist_delete ()
public function integer wf_imhist_create (ref string rsdate, ref long rdseq)
public subroutine wf_jego_qty (integer lrow, string sitem, string spspec, string sdepot)
public function integer wf_initial ()
public function integer wf_print (string as_sabu, string as_jpno)
end prototypes

event ue_open();// commandbutton function
rb_insert.TriggerEvent("clicked")
end event

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//		1. �԰���� = 0		-> RETURN
//////////////////////////////////////////////////////////////////
string	sCode, sLotgub
dec{2}	damt
dec{5}   dPrice
long		lRow

sCode = dw_detail.GetitemString(1, "sdate")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_detail.Setcolumn("sdate")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "saupj")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[�����]')
	dw_detail.Setcolumn("saupj")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "empno")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[�Ƿڴ����]')
	dw_detail.Setcolumn("empno")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "dept")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[�Ƿںμ�]')
	dw_detail.Setcolumn("dept")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "gubun")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[���ұ���]')
	dw_detail.Setcolumn("gubun")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "cvcod")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[�ŷ�ó]')
	dw_detail.Setcolumn("cvcod")
	dw_detail.setfocus()
	RETURN -1
END IF

sCode = dw_detail.GetitemString(1, "depot_no")
IF IsNull(sCode)	or   trim(sCode) = ''	THEN
	f_message_chk(30,'[���â��]')
	dw_detail.ScrollToRow(1)
	dw_detail.Setcolumn("depot_no")
	dw_detail.setfocus()
	RETURN -1
END IF
		
/////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_list.RowCount()

		sCode = dw_list.GetitemString(lRow, "itnbr")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[ǰ��]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("itnbr")
			dw_list.setfocus()
			RETURN -1
		END IF

		SELECT LOTGUB INTO :sLotgub FROM ITEMAS WHERE ITNBR = :sCode ;
		IF sLotgub = 'Y' THEN 
			sCode = dw_list.GetitemString(lRow, "lotsno")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[�԰� LOT NO]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("lotsno")
				dw_list.setfocus()
				RETURN -1
			END IF
      END IF

		sCode = dw_list.GetitemString(lRow, "pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			dw_list.setitem(lrow, 'pspec', '.')
		END IF
		
		/* �̴ܰ� �Է� ������� �䱸 - 2006.12.04 by shingoon */
//		dPrice = dw_list.GetitemDecimal(lRow, "price")
//		IF IsNull(dPrice)	or  dPrice = 0	THEN
//			f_message_chk(30,'[�ܰ�]')
//			dw_list.ScrollToRow(lrow)
//			dw_list.Setcolumn("price")
//			dw_list.setfocus()
//			RETURN -1
//		END IF
//
//		damt = dw_list.GetitemDecimal(lRow, "ioamt")
//		IF IsNull(damt)	or  damt = 0	THEN
//			f_message_chk(30,'[�ݾ�]')
//			dw_list.ScrollToRow(lrow)
//			dw_list.Setcolumn("ioamt")
//			dw_list.setfocus()
//			RETURN -1
//		END IF

NEXT

RETURN 1
end function

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* �������
//		1. �����history -> �԰���� update (�԰������ ������ ��쿡��)
//	
//////////////////////////////////////////////////////////////////
string	sJpno, 		&
			sDate, 		&
			sEmpno,		&
			sDept,		&
			sGubun,	sSaupj,	&
			sNull,	sCvcod, svendor, get_yn, sitgu, spdtgu, sitnbr, siosp, sjnpcrt
long		lRow, lCount
dec {3}  dqty
dec {2}  damt
SetNull(sNull)

dw_detail.AcceptText()

sDate  = dw_detail.GetItemString(1, "sdate")				// �԰��Ƿ�����
sEmpno = dw_detail.GetItemString(1, "empno")				// �԰��Ƿ���
sDept  = dw_detail.GetItemString(1, "dept")
sGubun = dw_detail.GetItemString(1, "gubun")
sCvcod = dw_detail.GetItemString(1, "Cvcod")
sSaupj = dw_detail.GetItemString(1, "saupj")

SELECT PDTGU, IOSP, JNPCRT   INTO :get_yn, :siosp, :sjnpcrt    FROM IOMATRIX  
 WHERE SABU = :gs_sabu AND IOGBN = :sgubun  ;
		 
if isnull(get_yn) then get_yn = 'N'		 
if isnull(sIosp)  then sIosp = 'I'		 
if isnull(sjnpcrt) then sjnpcrt = '027'		 

lCount = 	dw_list.RowCount()

FOR	lRow = 1		TO	lcount

	/////////////////////////////////////////////////////////////////////////
	//	1. ������ -> ���߰��� data�� �Ƿڹ�ȣ : �������� + 1 ->SETITEM
	// 2. ��ǥ��ȣ�� NULL �ΰ͸� �������� + 1 		
	/////////////////////////////////////////////////////////////////////////
	
	sJpno    = dw_list.GetitemString(lRow, "iojpno")
	sVendor  = dw_list.GetitemString(lRow, "depot_no")	
	
	IF IsNull(sjpno)	OR sJpno = '' 	THEN
		is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
		dw_list.SetItem(lRow, "iojpno", is_Last_Jpno)

		dw_list.SetItem(lRow, "sabu",		gs_sabu)
		dw_list.SetItem(lRow, "jnpcrt",	sjnpcrt)			// ��ǥ��������
		dw_list.SetItem(lRow, "inpcnf",  siosp)			// �������
		dw_list.SetItem(lRow, "iogbn",   sGubun) 			// ���ұ���=�԰���
		dw_list.SetItem(lRow, "sudat",	sDate)			// ��������=��������
   	dw_list.SetItem(lRow, "insdat",  sDate)			// �˻�����=�԰��Ƿ�����
	   dw_list.SetItem(lRow, "io_confirm", 'Y')		// ���ҽ��ο���	
   	dw_list.SetItem(lRow, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����

		dw_list.SetItem(lRow, "opseq",	'9999') 			// ��������
		dw_list.SetItem(lRow, "cvcod",	sCvcod) 			// �ŷ�óâ��=�԰��Ƿںμ�

		dw_list.SetItem(lRow, "ioreemp",	sEmpno)			// �����Ƿڴ����=�԰��Ƿ���
		dw_list.SetItem(lRow, "ioredept",sDept)			// �����Ƿںμ�=�԰��Ƿںμ�
		
		dw_list.SetItem(lRow, "saupj",  sSaupj)			// �����
	END IF

   sitnbr = dw_list.GetItemString(lRow, "itnbr")

	SELECT A.ITGU, B.PDTGU 
	  INTO :sItgu, :sPdtgu
	  FROM ITEMAS A, ITNCT B
	 WHERE A.ITNBR = :sitnbr AND A.ITTYP = B.ITTYP and A.ITCLS = B.ITCLS ;  
	//��������� Y �� ��츸 ������ �Է�
	if get_yn = 'Y' then 
		if sqlca.sqlcode = 0 then 
			dw_list.SetItem(lRow, "pdtgu",   spdtgu) 	// ������
		else
			dw_list.SetItem(lRow, "pdtgu",   sNull) 	// ������
		end if	
	else	
		dw_list.SetItem(lRow, "pdtgu",   sNull) 	// ������
   end if
	if sqlca.sqlcode = 0 then 
		dw_list.SetItem(lRow, "itgu",    sitgu) 	// ��������
	else
		dw_list.SetItem(lRow, "itgu",    sNull) 	// ��������
	end if	
	
	dqty   = dw_list.GetItemDecimal(lRow, "ioqty")
	dw_list.SetItem(lRow, "ioreqty",	dqty) 	// �����Ƿڼ���=�԰����		
	dw_list.SetItem(lRow, "iosuqty", dqty)    // �հݼ���=�԰����
	damt   = Truncate(dw_list.GetItemDecimal(lRow, "ioamt"), 0)
	dw_list.SetItem(lRow, "ioamt", damt)		// ���ұݾ�=0(�԰�ܰ�)

NEXT

RETURN 1

end function

public function integer wf_imhist_delete ();long		lRow, lRowCount

lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1

	dw_list.DeleteRow(lRow)
	
NEXT

RETURN 1

end function

public function integer wf_imhist_create (ref string rsdate, ref long rdseq);///////////////////////////////////////////////////////////////////////
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '008'
///////////////////////////////////////////////////////////////////////
string	sJpno, 		&
			sDate, 		&
			sEmpno,		&
			sDept,		&
			sGubun,		&
			sNull, 		&
			svendor, scvcod, sitnbr,&
			sitgu, spdtgu, siosp, get_yn, sjnpcrt, sSaupj, sGungbn
long		lRow, lRowHist, lcount, dSeq
dec {2}   damt
dec {3}  dqty
dec {5}  dprice

SetNull(sNull)
dw_detail.AcceptText()

sDate  = dw_detail.GetItemString(1, "sdate")				// �԰��Ƿ�����
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'')
	RETURN -1
END IF

COMMIT;

rsdate = sdate
rdseq	 = dseq

////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(dSeq, "0000")

sEmpno = dw_detail.GetItemString(1, "empno")				// �԰��Ƿ���
sDept  = dw_detail.GetItemString(1, "dept")
sGubun = dw_detail.GetItemString(1, "gubun")
scvcod = dw_detail.GetItemString(1, "cvcod")
sSaupj = dw_detail.GetItemString(1, "saupj")
svendor = dw_detail.GetItemString(1, "depot_no")
sGungbn = dw_detail.GetItemString(1, "gungbn")

SELECT PDTGU, IOSP, JNPCRT  INTO :get_yn, :siosp, :sjnpcrt    FROM IOMATRIX  
 WHERE SABU = :gs_sabu AND IOGBN = :sgubun  ;
		 
if isnull(get_yn) then get_yn = 'N'		 
if isnull(sIosp)  then sIosp = 'I'		 
if isnull(sjnpcrt) then sjnpcrt = '027'		 

lCount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount

	/////////////////////////////////////////////////////////////////////////
	//
	// ** �����HISTORY ���� **
	//
	////////////////////////////////////////////////////////////////////////
	lRowHist = dw_imhist.InsertRow(0)

	dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
	dw_imhist.SetItem(lRowHist, "jnpcrt",	sjnpcrt)			// ��ǥ��������
	dw_imhist.SetItem(lRowHist, "inpcnf",  siosp)	// �������
	dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
	dw_imhist.SetItem(lRowHist, "iogbn",   sGubun) 			// ���ұ���=�԰���

	dw_imhist.SetItem(lRowHist, "sudat",	sDate)			// ��������=�����Ƿ�����

   sitnbr = 	dw_list.GetItemString(lRow, "itnbr")
	dw_imhist.SetItem(lRowHist, "itnbr",   sitnbr ) // ǰ��
	dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "pspec")) // ���

	dw_imhist.SetItem(lRowHist, "saupj",	sSaupj) // �����
	
	dw_imhist.SetItem(lRowHist, "lotsno",	trim(dw_list.GetItemString(lRow, "lotsno"))) // lot no
	If Trim(dw_list.GetItemString(lRow, "bigo")) = '' OR IsNull(dw_list.GetItemString(lRow, "bigo")) Then
		dw_imhist.SetItem(lRowHist, "bigo",	   f_get_refferance('73', sGungbn))
	Else
		dw_imhist.SetItem(lRowHist, "bigo",    dw_list.GetItemString(lRow, "bigo"))
	End If
	
	dw_imhist.SetItem(lRowHist, "gungbn",  sGungbn) //��ǰ����

   //��������� Y �� ��츸 ������ �Է�
	SELECT A.ITGU, B.PDTGU 
	  INTO :sItgu, :sPdtgu
	  FROM ITEMAS A, ITNCT B
	 WHERE A.ITNBR = :sitnbr AND A.ITTYP = B.ITTYP and A.ITCLS = B.ITCLS ;                   
	
	if get_yn = 'Y' then 
		if sqlca.sqlcode = 0 then 
			dw_imhist.SetItem(lRowHist, "pdtgu",   spdtgu) 	// ������
		else
			dw_imhist.SetItem(lRowHist, "pdtgu",   sNull) 	// ������
		end if	
   end if
	if sqlca.sqlcode = 0 then 
		dw_imhist.SetItem(lRowHist, "itgu",    sitgu) 	// ��������
	else
		dw_imhist.SetItem(lRowHist, "itgu",    sNull) 	// ��������
	end if	
	
	dw_imhist.SetItem(lRowHist, "opseq",	'9999') 			// ��������
//	svendor = dw_list.GetItemString(lRow, "depot_no")
	dw_imhist.SetItem(lRowHist, "depot_no",svendor)	      // ����â��=�԰�ó
	dw_imhist.SetItem(lRowHist, "cvcod",	scvcod) 			// �ŷ�óâ��=�԰��Ƿںμ�
	dw_imhist.SetItem(lRowHist, "ioreemp",	sEmpno)			// �����Ƿڴ����=�԰��Ƿ���
	dw_imhist.SetItem(lRowHist, "ioredept",sDept)			// �����Ƿںμ�=�԰��Ƿںμ�
	dw_imhist.SetItem(lRowHist, "insdat",sDate)			// �˻�����=�԰��Ƿ�����
	
	dw_imhist.SetItem(lRowHist, "io_confirm", 'Y')		// ���ҽ��ο���	
	dw_imhist.SetItem(lRowHist, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
	dw_imhist.SetItem(lRowHist, "io_empno", sNull)		// ���ҽ�����=NULL

   dprice = dw_list.GetItemDecimal(lRow, "price")
	dqty   = dw_list.GetItemDecimal(lRow, "ioqty")
	//damt   = Truncate(dw_list.GetItemDecimal(lRow, "ioamt"), 0) 
	damt   = dw_list.GetItemDecimal(lRow, "ioamt")
	
	dw_imhist.SetItem(lRowHist, "ioprc",	dprice) 				// ���Ҵܰ�=0
	dw_imhist.SetItem(lRowHist, "ioreqty",	dqty) 	// �����Ƿڼ���=�԰����		
	dw_imhist.SetItem(lRowHist, "iosuqty", dqty) // �հݼ���=�԰����
	dw_imhist.SetItem(lRowHist, "ioqty", dqty)  // ���Ҽ���=�԰����		
	dw_imhist.SetItem(lRowHist, "ioamt", damt)		// ���ұݾ�=0(�԰�ܰ�)
	
	dw_imhist.SetItem(lRowHist, "pjt_cd",	dw_list.GetItemString(lRow, "pjt_cd"))	// 2017.06.23 - ����, �����˻������ �۾�������ȣ�� ���
NEXT

////////////////////////////////////////////////////////////////////////////////
// 2002.03.21 ����� : ���Ź�ǰ �ŷ���ǥ ����
////////////////////////////////////////////////////////////////////////////////
SQLCA.ERP000000580(gs_sabu, sJpno)
IF SQLCA.SQLCODE <> 0	THEN
	f_message_chk(32,'')
	ROLLBACK;
	RETURN -1
END IF

////////////////////////////////////////////////////////////////////////////////

RETURN 1

end function

public subroutine wf_jego_qty (integer lrow, string sitem, string spspec, string sdepot);Dec{3} djego
  
SELECT "STOCK"."JEGO_QTY"  
  INTO :dJego 
  FROM "STOCK"  
 WHERE ( "STOCK"."DEPOT_NO" =  :sdepot) AND  
       ( "STOCK"."ITNBR" = :sitem ) AND  
       ( "STOCK"."PSPEC" = :spspec )   ;

if isnull(djego) then djego = 0

dw_list.setitem(lRow, 'jego_qty', djego)

end subroutine

public function integer wf_initial ();String ls_saupj

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()

//cb_save.enabled = false
p_delete.enabled = false

dw_detail.enabled = TRUE

f_child_saupj(dw_detail, 'depot_no', gs_saupj )

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// ��Ͻ�
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("sdate", 10)
	dw_detail.settaborder("saupj", 20)
	dw_detail.settaborder("empno", 30)
	dw_detail.settaborder("gubun", 40)
	dw_detail.settaborder("dept",  50)
	dw_detail.settaborder("cvcod", 60)

	dw_detail.Modify("t_dsp_no.visible = 0")
	
	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_saupj.visible = 1")
	dw_detail.Modify("t_dsp_emp.visible = 1")
	dw_detail.Modify("t_dsp_gbn.visible = 1")
	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_dept.visible = 1")
	dw_detail.Modify("t_dsp_cust.visible = 1")
	
	dw_detail.setcolumn("empno")
	dw_detail.SetItem(1, "sdate", is_Date)
	
	w_mdi_frame.sle_msg.text = "���"
	

ELSE
	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("sdate", 0)
	dw_detail.settaborder("saupj", 0)
	dw_detail.settaborder("empno", 0)
	dw_detail.settaborder("dept",  0)
	dw_detail.settaborder("gubun", 0)
	dw_detail.settaborder("cvcod", 0)

   dw_detail.Modify("t_dsp_no.visible = 1")
	
	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_saupj.visible = 0")
	dw_detail.Modify("t_dsp_emp.visible = 0")
	dw_detail.Modify("t_dsp_gbn.visible = 0")
	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_dept.visible = 0")
	dw_detail.Modify("t_dsp_cust.visible = 0")

	dw_detail.setcolumn("JPNO")

	w_mdi_frame.sle_msg.text = "����"
	
END IF

dw_detail.setfocus()
dw_detail.setredraw(true)

//�����
//f_mod_saupj(dw_detail, 'saupj' )

//�α��� ���� ��������� ����
dw_detail.SetItem(1, 'saupj', gs_saupj)

ls_saupj = dw_detail.GetItemString(1,'saupj')
f_child_saupj(dw_detail, 'depot_no', ls_saupj )

//�԰�â�� _list
f_child_saupj(dw_list, 'depot_no', ls_saupj )

return  1

end function

public function integer wf_print (string as_sabu, string as_jpno);If Trim(as_jpno) = '' OR IsNull(as_jpno) Then
	MessageBox('Ȯ��', '��ǥ��ȣ ������ �����ϴ�.')
	Return 0
End If

dw_print.SetRedraw(False)
Long    ll_cnt
ll_cnt = dw_print.Retrieve(as_sabu, as_jpno)
dw_print.SetRedraw(True)

If ll_cnt < 1 Then
	MessageBox('Ȯ��', '����� ����� �����ϴ�.')
	Return 0
End If

OpenWithParm(w_print_preview, dw_print)	

Return 1
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

IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
ELSE	
	is_ispec = '�԰�'
	is_jijil = '����'
END IF

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

is_Date = f_Today()

PostEvent('ue_open') 
end event

on w_mat_01020.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_print=create dw_print
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_2=create p_2
this.dw_imhist=create dw_imhist
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_print,&
this.pb_1,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.p_delrow,&
this.p_addrow,&
this.p_2,&
this.dw_imhist,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.dw_list,&
this.rr_1}
end on

on w_mat_01020.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_print)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_2)
destroy(this.dw_imhist)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
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
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_retrieve.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_save.TriggerEvent(Clicked!)
	Case KeyD!
		p_delete.TriggerEvent(Clicked!)
	Case KeyC!
		p_cancel.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type cb_2 from commandbutton within w_mat_01020
integer x = 3205
integer y = 168
integer width = 663
integer height = 116
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����˻� ��ǰ ��ȸ"
end type

event clicked;if dw_detail.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

if rb_delete.Checked then
	MessageBox('Ȯ��','��� ��忡���� ��ȸ �����մϴ�.')
	return
end if

If dw_list.RowCount() > 0 Then
	MessageBox('Ȯ��','�ű� ��ϸ� ��ȸ �����մϴ�. ��� �� �ٽ� ��ȸ�Ͻʽÿ�!')
	return
End If


//////////////////////////////////////////////////////////
string		sDept, sDate, stime, stodate, sSaupj, sDepot, sGungbn, snull
long		i, lRow, ll_i = 0
int			iCount
str_code lst_code

stoDate = trim(dw_detail.GetItemString(1, "sdate"))
sSaupj  = dw_detail.GetItemString(1, "saupj")
sDept   = trim(dw_detail.GetItemString(1, "empno"))
sDepot   = trim(dw_detail.GetItemString(1, "depot_no"))

IF isnull(stoDate) or stoDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sSaupj) or sSaupj = "" 	THEN
	f_message_chk(30,'[�����]')
	dw_detail.SetColumn("saupj")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sDepot) or sDepot = "" 	THEN
	f_message_chk(30,'[���â��]')
	dw_detail.SetColumn("depot_no")
	dw_detail.SetFocus()
	RETURN
END IF

// �Ƿڴ����
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[�Ƿڴ����]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = dw_detail.GetItemString(1, "gubun")
// �԰���
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[���ұ���]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = trim(dw_detail.GetItemString(1, "dept"))
// �Ƿںμ�
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[�Ƿںμ�]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF

//sDept = trim(dw_detail.GetItemString(1, "cvcod"))
//// �Ƿڰŷ�ó
//IF isnull(sDept) or sDept = "" 	THEN
//	f_message_chk(30,'[�ŷ�ó]')
//	dw_detail.SetColumn("cvcod")
//	dw_detail.SetFocus()
//	RETURN
//END IF

sGungbn = Trim(dw_detail.GetItemString(1, "gungbn"))
// ��ǰ����(�����ڵ�:73)
If IsNull(sGungbn) OR sGungbn = "" Then
	f_message_chk(30, '[��ǰ����]')
	dw_detail.SetColumn("gungbn")
	dw_detail.SetFocus()
	Return
End If

Open(w_shpfat_popup)
//istr_itnbr.code[ii]     = dw_1.Object.shpfat_rmks[i]
//istr_itnbr.sgubun1[ii]  = dw_1.Object.shpfat_scode2[i]	/* ��åó */
//istr_itnbr.sgubun2[ii]  = dw_1.Object.sname[i]				/* ��åó�� */
//istr_itnbr.sgubun3[ii]  = dw_1.Object.shpfat_shpjpno[i]	/* ������ȣ */
//istr_itnbr.dgubun1[ii]  = dw_1.Object.shpfat_guqty[i]

lst_code = Message.PowerObjectParm
IF IsValid(lst_code) = False Then Return 
If UpperBound(lst_code.code) < 1 Then Return 


For i = 1 To UpperBound(lst_code.code)
	ll_i++

	If i = 1 Then
		dw_detail.SetItem(i,"cvcod",lst_code.sgubun1[ll_i])
		dw_detail.SetItem(i,"cvnas",lst_code.sgubun2[ll_i])
	end iF
	
	p_addrow.triggerevent("clicked")
	
	dw_list.SetItem(i,"itnbr",lst_code.code[ll_i])
	dw_list.SetItem(i,"ioqty",lst_code.dgubun1[ll_i])
	dw_list.SetItem(i,"pjt_cd",lst_code.sgubun3[ll_i])
	dw_list.TriggerEvent("itemchanged")
	
Next


end event

type cb_1 from commandbutton within w_mat_01020
integer x = 3895
integer y = 168
integer width = 663
integer height = 116
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "��ǰ �ŷ���ǥ ����"
end type

event clicked;String  ls_jpno
ls_jpno = dw_detail.GetItemString(1, 'jpno')

wf_print(gs_sabu, ls_jpno)
end event

type dw_print from datawindow within w_mat_01020
boolean visible = false
integer x = 3845
integer y = 568
integer width = 686
integer height = 400
integer taborder = 30
string title = "none"
string dataobject = "d_mat_01025_05_new1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type pb_1 from u_pb_cal within w_mat_01020
integer x = 754
integer y = 36
integer taborder = 20
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type p_exit from uo_picture within w_mat_01020
integer x = 4425
integer y = 16
integer width = 178
integer taborder = 100
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_cancel from uo_picture within w_mat_01020
integer x = 4251
integer y = 16
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_delete from uo_picture within w_mat_01020
integer x = 4078
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
//int i
//if ic_status = '2' then 
//	FOR i=1 TO dw_list.rowcount() 
//		if ic_status = '2' then 
//			IF dw_list.getitemstring(i, 'schk3') = 'N' then 
//				messagebox("Ȯ ��", "�������� �ڷ�� ���� �� �� �����ϴ�.")
//				return 
//			end if
//		
//			IF dw_list.getitemstring(i, 'schk2') = 'N' then 
//				messagebox("Ȯ ��", "���ҽ��ε� �ڷ�� ���� �� �� �����ϴ�.")
//				return 
//			end if
//			 
//			if dw_list.getitemstring(i, 'schk') = 'N' then 
//				messagebox("Ȯ ��", "�˻�Ϸ�� �ڷ�� ������ �� �����ϴ�.")
//				return  
//			end if	 
//		end if
//	NEXT
//end if
//
if dw_detail.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	RETURN

IF dw_list.Update() >= 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_cancel.triggerevent(clicked!)

end event

type p_save from uo_picture within w_mat_01020
integer x = 3904
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		1. �԰���� = 0		-> RETURN
//		2. �����HISTORY : ��ǥä������('C0')
//////////////////////////////////////////////////////////////////////////////////
String sDate
long   dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 
	
IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
   if	wf_imhist_create(sdate, dseq) < 0 then return 

	IF dw_imhist.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
		p_cancel.TriggerEvent("clicked")	
		SetPointer(Arrow!)
		return
	END IF
	
	MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(dSeq,"0000") + "~r~r�����Ǿ����ϴ�.")
	
	
	If MessageBox('��ǰ �ŷ����� ����', '��ǰ �ŷ������� ��� �Ͻðڽ��ϱ�?', Question!, YesNo!, 1) = 1 Then
		wf_print(gs_sabu, sDate + String(dSeq,"0000"))
	End If
/////////////////////////////////////////////////////////////////////////
//	1. ���� 
/////////////////////////////////////////////////////////////////////////
ELSE

	IF wf_imhist_update() = -1	THEN RETURN

	IF dw_list.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

END IF
////////////////////////////////////////////////////////////////////////

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_retrieve from uo_picture within w_mat_01020
integer x = 3730
integer y = 16
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

event clicked;call super::clicked;This.Enabled = False

if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sNull, ls_saupj
long		lRow 
SetNull(sNull)

sJpno  = dw_detail.getitemstring(1, "jpno")
ls_saupj = dw_detail.getitemstring(1, "saupj")

// ��ǥ��ȣ
IF IsNull(sJpno)	or   trim(sJpno) = ''	THEN
	f_message_chk(30,'[��ǥ��ȣ]')
	dw_detail.Setcolumn("jpno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

//////////////////////////////////////////////////////////////////////////

sJpno = sJpno + '%'

dw_list.setredraw(false)
	
f_child_saupj(dw_list, 'depot_no', ls_saupj )

IF	dw_list.Retrieve(gs_sabu, sjpno) <	1	THEN
	dw_list.setredraw(true)
	f_message_chk(50, '[��ǰ����]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN
END IF

dw_list.setredraw(true)
//////////////////////////////////////////////////////////////////////////
// �����Ƿڹ�ȣ
is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "iojpno")

dw_detail.enabled = false

p_delete.enabled = true
p_delete.PictureName = 'c:\erpman\image\����_up.gif'

p_addrow.enabled = true
p_addrow.PictureName = 'c:\erpman\image\���߰�_up.gif'

p_delrow.enabled = true
p_delrow.PictureName = 'c:\erpman\image\�����_up.gif'

dw_list.SetFocus()
//cb_save.enabled = true

This.Enabled = True

end event

type p_delrow from uo_picture within w_mat_01020
integer x = 3547
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

event clicked;call super::clicked;long	lrow

if dw_detail.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(0)


end event

type p_addrow from uo_picture within w_mat_01020
integer x = 3374
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\���߰�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���߰�_up.gif"
end event

event clicked;call super::clicked;if dw_detail.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

//////////////////////////////////////////////////////////
string	sDept, sDate, stime, stodate, sSaupj, sDepot, sGungbn
long		lRow
int		iCount

stoDate = trim(dw_detail.GetItemString(1, "sdate"))
sSaupj  = dw_detail.GetItemString(1, "saupj")
sDept   = trim(dw_detail.GetItemString(1, "empno"))
sDepot   = trim(dw_detail.GetItemString(1, "depot_no"))

IF isnull(stoDate) or stoDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sSaupj) or sSaupj = "" 	THEN
	f_message_chk(30,'[�����]')
	dw_detail.SetColumn("saupj")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sDepot) or sDepot = "" 	THEN
	f_message_chk(30,'[���â��]')
	dw_detail.SetColumn("depot_no")
	dw_detail.SetFocus()
	RETURN
END IF

// �Ƿڴ����
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[�Ƿڴ����]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = dw_detail.GetItemString(1, "gubun")
// �԰���
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[���ұ���]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = trim(dw_detail.GetItemString(1, "dept"))
// �Ƿںμ�
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[�Ƿںμ�]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF

sDept = trim(dw_detail.GetItemString(1, "cvcod"))
// �Ƿڰŷ�ó
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[�ŷ�ó]')
	dw_detail.SetColumn("cvcod")
	dw_detail.SetFocus()
	RETURN
END IF

sGungbn = Trim(dw_detail.GetItemString(1, "gungbn"))
// ��ǰ����(�����ڵ�:73)
If IsNull(sGungbn) OR sGungbn = "" Then
	f_message_chk(30, '[��ǰ����]')
	dw_detail.SetColumn("gungbn")
	dw_detail.SetFocus()
	Return
End If


///////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

type p_2 from uo_picture within w_mat_01020
integer x = 3191
integer y = 16
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\�����ȸ_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����ȸ_up.gif"
end event

event clicked;call super::clicked;Long nRow

if rb_insert.Checked then

	nRow = dw_list.GetRow()
//	p_addrow.triggerevent(clicked!)
	
	string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
				sRelcod, sNaougu, scvcod 
//	long		lRow
//	
//	sDate    = TRIM(dw_detail.GetItemString(1, "sdate"))
	sHouse   = dw_detail.GetItemString(1, "depot_no")
//	sEmpno2  = dw_detail.GetItemString(1, "empno2")
//	sEmpno   = dw_detail.GetItemString(1, "empno")
//	sDept 	= dw_detail.GetItemString(1, "dept")
//	sGubun 	= dw_detail.GetItemString(1, "gubun")
//	sCheck   = dw_detail.GetItemString(1, "check")
//	scvcod   = dw_detail.GetItemString(1, "cvcod")
//	
//	if isnull(sdate)   or trim(sdate)   = '' or &
	if	isnull(shouse)  or trim(shouse)  = '' then
//		isnull(sempno2) or trim(sempno2) = '' or &
//		isnull(sempno)  or trim(sempno)  = '' or &
//		isnull(sdept)   or trim(sdept)   = '' or &
//		isnull(sgubun)  or trim(sgubun)  = '' or &
//		isnull(scheck)  or trim(scheck)  = '' or &
//		isnull(scvcod)  or trim(scvcod)  = '' Then 
		return
	end if
	
//	dw_list.deleterow(nRow)
	
end if

datawindow dwname	

dw_detail.accepttext()
dwname   = dw_list
gs_code  = dw_detail.getitemstring(1, "depot_no")
gs_gubun = dw_detail.getitemstring(1, "cvcod")
openwithparm(w_pdt_04037, dwname)

setnull(gs_code)
end event

type dw_imhist from datawindow within w_mat_01020
boolean visible = false
integer x = 626
integer y = 2300
integer width = 494
integer height = 360
string dataobject = "d_pdt_imhist"
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

type rb_delete from radiobutton within w_mat_01020
integer x = 2839
integer y = 192
integer width = 242
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����"
end type

event clicked;
ic_status = '2'

wf_Initial()

dw_list.DataObject = 'd_mat_01022'
dw_list.SetTransObject(SQLCA)
//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_ispec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

p_retrieve.enabled = true
p_retrieve.PictureName = 'c:\erpman\image\��ȸ_up.gif'

p_addrow.enabled = false
p_addrow.PictureName = 'c:\erpman\image\���߰�_d.gif'

p_delrow.enabled = false
p_delrow.PictureName = 'c:\erpman\image\�����_d.gif'

cb_1.Enabled = True
cb_2.Enabled = False
end event

type rb_insert from radiobutton within w_mat_01020
integer x = 2510
integer y = 192
integer width = 242
integer height = 72
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
ic_status = '1'	// ���

wf_Initial()

dw_list.DataObject = 'd_mat_01021'
dw_list.SetTransObject(SQLCA)

IF f_change_name('1') = 'Y' then 
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
END IF

p_retrieve.enabled = false
p_retrieve.PictureName = 'c:\erpman\image\��ȸ_d.gif'

p_addrow.enabled = true
p_addrow.PictureName = 'c:\erpman\image\���߰�_up.gif'

p_delrow.enabled = true
p_delrow.PictureName = 'c:\erpman\image\�����_up.gif'

cb_1.Enabled = False
cb_2.Enabled = True

end event

type dw_detail from datawindow within w_mat_01020
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 24
integer width = 3118
integer height = 268
integer taborder = 10
string dataobject = "d_mat_01020"
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

IF this.GetColumnName() = 'jpno'	THEN

	gs_gubun = '027'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")

// �԰��Ƿڴ����
ELSEIF this.GetColumnName() = 'empno'	THEN
	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"empno",	gs_code)
	this.TriggerEvent("itemchanged")
// �μ�
ELSEIF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",	gs_code)
	SetItem(1,"deptname", gs_codename)

// �ŷ�ó
ELSEIF this.GetColumnName() = 'cvcod'	THEN

	string	sCheck, sIogbn
	sIogbn = THIS.getitemstring(1, "gubun")

	if sIogbn = "" or isnull(sIogbn) then 
		messagebox('Ȯ ��', '���ұ����� ���� �Է��ϼ���!')
		this.setitem(1, 'cvcod', siogbn)
		this.setitem(1, 'cvnas', siogbn)
		return 1
	end if

	/* ����ó ���� �˻� */
	SELECT RELCOD INTO :SCHECK FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	    
	/* ����ó�ڵ� ���п� ���� �ŷ�ó������ setting */
	Choose case scheck  //����ó�ڵ�(1:â��, 2:�μ�, 3:�ŷ�ó, 4:â��+�μ�, 5:ALL)
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case else
					f_message_chk(208,'[�ŷ�ó]')
					this.setitem(1, 'cvcod', "")
					this.setitem(1, 'cvnas', "")
				   return 1
	End choose

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnas", gs_codename)
	this.TriggerEvent("itemchanged")

END IF

end event

event itemchanged;string	sEmpno, 			&
			sEmpName,		&
			sDept,			&
			sDeptName,		&
			sDate,			&
			sGubun,			&
			sJpno,			&
			sNull, scvcod, scvnas, scode, sname1, sname2, sSaupj, sDepot
int      ireturn, iLen  			
			
SetNull(sNull)

// �԰��Ƿ�����
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[�Ƿ�����]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF

//////////////////////////////////////////////////////////////////////////
// �����
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetcolumnName() = 'empno'	THEN
	
	scode = trim(this.GetText())								
	
   ireturn = f_get_name2('���', 'Y', scode, sname1, sname2)    //1�̸� ����, 0�� ����	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empname', sname1)

	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :sDept, :sDeptName
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		this.setitem(1, 'dept', sDept)
		this.setitem(1, 'deptname', sDeptName)
   END IF	
   return ireturn 
//////////////////////////////////////////////////////////////////////////
// �԰��Ƿںμ�
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "dept" THEN
	scode = trim(this.GetText())								
	
   ireturn = f_get_name2('�μ�', 'Y', scode, sname1, sname2)    //1�̸� ����, 0�� ����	

	this.setitem(1, 'dept', scode)
	this.setitem(1, 'deptname', sname1)
   return ireturn 
//////////////////////////////////////////////////////////////////////////
// �԰���
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "gubun" THEN
	this.setitem(1, 'cvnas', snull)
	this.setitem(1, 'cvcod', snull)
//////////////////////////////////////////////////////////////////////////
// �ŷ�ó(����ó)
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "cvcod" THEN
	sCvcod  = trim(this.GetText())						
	if sCvcod = "" or isnull(scvcod) then 
		this.setitem(1, 'cvnas', snull)
		return 
	end if

	sGubun = this.getitemstring(1, "gubun")
	
	if sGubun = "" or isnull(sGubun) then 
		messagebox('Ȯ ��', '���ұ����� ���� �Է��ϼ���!')
		this.setitem(1, 'cvcod', snull)
		this.setitem(1, 'cvnas', snull)
		return 1
	end if

	/* ����ó ���� �˻� */
	SELECT RELCOD INTO :sCode FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sGubun;
	    
	string	sgbn1, sgbn2, sgbn3, sgbn4, sgbn5

	/* ����ó�ڵ� ���п� ���� �ŷ�ó������ setting */
	Choose case sCode //����ó�ڵ�(1:â��, 2:�μ�, 3:�ŷ�ó, 4:â��+�μ�, 5:ALL)
			 case '1'
					sgbn1 = '5'; sgbn2 = '5'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '2'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '4'; sgbn4 = '4'; sgbn5 = '4'
			 case '3'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '9'; sgbn4 = '9'; sgbn5 = '9'
			 case '4'
					sgbn1 = '4'; sgbn2 = '4'; sgbn3 = '5'; sgbn4 = '5'; sgbn5 = '5'
			 case '5'
					sgbn1 = '1'; sgbn2 = '2'; sgbn3 = '4'; sgbn4 = '5'; sgbn5 = '9'
			 case else
					f_message_chk(208,'[�ŷ�ó]')
					this.setitem(1, 'cvcod', snull)
					this.setitem(1, 'cvnas', snull)
				   return 1
	End choose

	SELECT "CVNAS2"
	  INTO :sName1
	  FROM "VNDMST" 
	 WHERE "CVCOD" = :sCvcod  AND "CVSTATUS" <> '2'
		AND "CVGU"  IN (:sgbn1, :sgbn2, :sgbn3, :sgbn4, :sgbn5) ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[�ŷ�ó]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, 'cvnas', sNull)		
	   return 1
	ELSE
		this.setitem(1, 'cvnas', sName1)
	END IF

//////////////////////////////////////////////////////////////////////////
// ��ǥ��ȣ
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'jpno'	THEN

	sJpno = trim(this.GetText())
	
	if sJpno = '' or isnull(sJpno) then 
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "dept",  	sNull)
		this.SetItem(1, "deptname",sNull)
		this.SetItem(1, "gubun",   sNull)
		this.SetItem(1, "cvcod",  	sNull)
		this.SetItem(1, "cvnas",	sNull)
		this.SetItem(1, "saupj",	sNull)
		this.SetItem(1, "depot_no",	sNull)
		return 
   end if	
   ilen = len(sJpno)
	
	if ilen < 12 then 
		f_message_chk(33,'[��ǥ��ȣ]')
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "dept",  	sNull)
		this.SetItem(1, "deptname",sNull)
		this.SetItem(1, "gubun",   sNull)
		this.SetItem(1, "cvcod",  	sNull)
		this.SetItem(1, "cvnas",	sNull)
		this.SetItem(1, "saupj",	sNull)
		this.SetItem(1, "jpno",	sNull)
		this.SetItem(1, "depot_no",	sNull)
		return 1
   end if	
	
	SELECT A.SUDAT,  A.IOREEMP,
			 A.IOGBN,  A.IOREDEPT, 
			 B.CVNAS2, D.EMPNAME, A.CVCOD, E.CVNAS, A.SAUPJ , DEPOT_NO
	  INTO :sDate, :sEmpno, 
	  		 :sGubun, :sDept, 
	  		 :sDeptName, :sEmpName, :SCVCOD, :SCVNAS, :sSaupj , :sDepot
	  FROM IMHIST A, VNDMST B, P1_MASTER D, VNDMST E
	 WHERE A.SABU     = :gs_sabu		AND
	 		 A.IOJPNO   like :sJpno||'%'	AND
			 A.JNPCRT   = '027' AND
			 A.IOREDEPT = B.CVCOD(+)	AND
			 A.IOREEMP  = D.EMPNO(+)   AND
			 A.CVCOD		= E.CVCOD(+)   AND ROWNUM = 1 ;
	 
	IF SQLCA.SQLCODE = 100	THEN
		f_message_chk(33,'[��ǥ��ȣ]')
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.SetItem(1, "dept",  	sNull)
		this.SetItem(1, "deptname",sNull)
		this.SetItem(1, "gubun",   sNull)
		this.SetItem(1, "cvcod",  	sNull)
		this.SetItem(1, "cvnas",	sNull)
		this.SetItem(1, "saupj",	sNull)
		this.SetItem(1, "jpno",	sNull)
		this.SetItem(1, "depot_no",	sNull)
		RETURN 1
	END IF
	
	f_child_saupj(this, 'depot_no', sSaupj )

	this.SetItem(1, "sdate",   sDate)
	this.SetItem(1, "empno",	sEmpno)
	this.SetItem(1, "empname", sEmpname)
	this.SetItem(1, "dept",  	sDept)
	this.SetItem(1, "deptname",sDeptName)
	this.SetItem(1, "gubun",   sGUBUN)	
	this.SetItem(1, "cvcod",  	scvcod)
	this.SetItem(1, "cvnas",	scvnas)	
	this.SetItem(1, "Saupj",	sSaupj)
	this.SetItem(1, "depot_no",	sDepot)
	
	p_retrieve.PostEvent(Clicked!)

ELSEIF this.GetcolumnName() = 'saupj'	THEN
	sSaupj  = trim(this.GetText())				
	f_child_saupj(this, 'depot_no', sSaupj )
END IF


end event

type dw_list from datawindow within w_mat_01020
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 73
integer y = 300
integer width = 4498
integer height = 1908
integer taborder = 30
string dataobject = "d_mat_01021"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;Long lrow
lrow = this.getrow()

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;dec{3}	dQty,  dstock, dtempqty
dec{2}   damt,dprice
long		lRow, Lunprc
string	sCode, sName, sItem, sSpec, sNull, sPspec, sdepot, sjijil, sispec_code, Scvcod
integer  ireturn

SetNull(sNull)

lRow  = this.GetRow()	

Scvcod = dw_detail.GetItemString(1, "cvcod")

This.AcceptText()

IF this.GetColumnName() = 'itnbr'	THEN
	sItem = trim(THIS.GETTEXT())								
	ireturn = f_get_name4('ǰ��', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.SetItem(lRow, "itemas_itdsc", sName)
	this.SetItem(lRow, "itemas_ispec", sSpec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sispec_code)
	
	/* ��ü�� �ܰ� */
	Select Nvl(unprc, 0)
	  Into :Lunprc
	  From danmst
	 Where itnbr  = :sitem
	   And cvcod  = :Scvcod
		and rownum = 1
	 Using sqlca;	
	this.SetItem(lRow, "price", Lunprc)
	this.SetItem(lRow, "ioamt", Lunprc*ROUND(this.getitemnumber(lRow, 'ioqty'),0))

	sPspec = this.getitemstring(lRow, 'pspec')
	if spspec = '' or isnull(spspec) then spspec = '.' 

	sDepot = this.getitemstring(lRow, 'depot_no')
	
	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name4('ǰ��', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sispec_code)

	sPspec = this.getitemstring(lRow, 'pspec')
	if spspec = '' or isnull(spspec) then spspec = '.' 

	sDepot = this.getitemstring(lRow, 'depot_no')
	
	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name4('�԰�', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
   this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sispec_code)

	sPspec = this.getitemstring(lRow, 'pspec')
	if spspec = '' or isnull(spspec) then spspec = '.' 

	sDepot = this.getitemstring(lRow, 'depot_no')
	
	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name4('����', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
   this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sispec_code)

	sPspec = this.getitemstring(lRow, 'pspec')
	if spspec = '' or isnull(spspec) then spspec = '.' 

	sDepot = this.getitemstring(lRow, 'depot_no')
	
	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sispec_code = trim(this.GetText())
	ireturn = f_get_name4('�԰��ڵ�', 'Y', sitEM, sname, sspec, sjijil, sispec_code)
	
   this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itemas_itdsc", sname)	
	this.setitem(lrow, "itemas_ispec", sspec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sispec_code)

	sPspec = this.getitemstring(lRow, 'pspec')
	if spspec = '' or isnull(spspec) then spspec = '.' 

	sDepot = this.getitemstring(lRow, 'depot_no')
	
	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	RETURN ireturn	
	
ELSEIF this.GetColumnName() = "pspec" THEN
	sPspec = trim(this.GetText())
	sitem = this.getitemstring(lRow, 'itnbr')
	sDepot = this.getitemstring(lRow, 'depot_no')
	
	if spspec = '' or isnull(spspec) then spspec = '.' 

	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	
ELSEIF this.GetColumnName() = "depot_no" THEN
	sDepot = trim(this.GetText())
	sitem  = this.getitemstring(lRow, 'itnbr')
	spspec = this.getitemstring(lRow, 'pspec')

	if spspec = '' or isnull(spspec) then spspec = '.' 

	IF sItem > '.' and sDepot > '.' THEN 
		wf_jego_qty(lrow, sitem, spspec, sdepot)
	ELSE
		this.SetItem(lRow, "jego_qty", 0)
	END IF
	
ELSEIF this.GetColumnName() = "ioqty" THEN
	dqty   = dec(this.GetText())
	
	dStock  = this.GetItemDecimal(lRow, "jego_qty")
	
	IF ic_status = '2'	THEN
		dTempQty = this.GetItemDecimal(lRow, "temp_ioqty")
		dQty = dQty - dTempQty
	END IF
		
//	IF dQty > dStock		THEN
//		MessageBox("Ȯ��", "��ǰ������ ������� Ŭ �� �����ϴ�.")
//		this.SetItem(lRow, "ioqty", 0)
//		RETURN 1
//	END IF

END IF
end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column �� �ƴ� Column ���� Error �߻��� 

IF ib_ItemError = true	THEN	
	ib_ItemError = false		
	RETURN 1
END IF



//	2) Required Column  ���� Error �߻��� 

string	sColumnName
sColumnName = dwo.name + "_t.text"


w_mdi_frame.sle_msg.text = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."

RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// ǰ��
IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
END IF



end event

event retrieverow;//string	sQcgubun, sQcdate, sIoConfirm, sIoDate, siojpno
//long     lcount
//
///* ������ ��쿡�� check */
//if ic_status <> '1' then
//
//	if row > 0 then 
//		// �˻籸��, �˻������Է½� �����Ұ�
//		sQcgubun = dw_list.GetItemString(row, "qcgub")
//		sQcdate  = dw_list.GetItemString(row, "insdat")
//		IF sQcgubun > '1'	THEN
//			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(row, "schk", 'N')
//		END IF
//		
//		// ���ҽ��ο���, ���������Է½� �����Ұ�
//		sIoConfirm = dw_list.GetItemString(row, "io_confirm")
//		sIoDate    = dw_list.GetItemString(row, "io_date")
//		IF sIoConfirm = 'N'	THEN
//			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(row, "schk2", 'N')
//		END IF
//		
//		siojpno = this.getitemstring(row, 'iojpno')
//
//	end if
//end if
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

event editchanged;String Scvcod, Sitnbr
Dec{2} Lioqty, Lioamt, Lprice

//dw_list.AcceptText()
Scvcod = dw_detail.GetItemString(1, "cvcod")
Sitnbr = dw_list.GetItemString(dw_list.GetRow(), "itnbr")
Lioqty = dw_list.GetItemDecimal(dw_list.GetRow(), "ioqty")
Lprice = dw_list.GetItemDecimal(dw_list.GetRow(), "price")

Choose Case dwo.name
    	 Case "ioqty"
			   Lioqty = Dec(data)
				
				Lioamt = Lioqty * Lprice
				
				dw_list.setItem(dw_list.GetRow(), "ioamt", Lioamt)
				
		 Case	"price"
			   Lprice = Dec(data)
				
				Lioamt = Lioqty * Lprice
				
				dw_list.setItem(dw_list.GetRow(), "ioamt", Lioamt)
				
		 Case Else
End Choose	
				
			
end event

type rr_1 from roundrectangle within w_mat_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 292
integer width = 4526
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

