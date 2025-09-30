$PBExportHeader$w_pdt_04035_han4.srw
$PBExportComments$������������� - ����
forward
global type w_pdt_04035_han4 from window
end type
type pb_1 from u_pb_cal within w_pdt_04035_han4
end type
type dw_hidden from datawindow within w_pdt_04035_han4
end type
type p_print from uo_picture within w_pdt_04035_han4
end type
type p_2 from uo_picture within w_pdt_04035_han4
end type
type p_1 from uo_picture within w_pdt_04035_han4
end type
type p_retrieve from uo_picture within w_pdt_04035_han4
end type
type p_save from uo_picture within w_pdt_04035_han4
end type
type p_delete from uo_picture within w_pdt_04035_han4
end type
type p_cancel from uo_picture within w_pdt_04035_han4
end type
type p_exit from uo_picture within w_pdt_04035_han4
end type
type p_addrow from uo_picture within w_pdt_04035_han4
end type
type p_delrow from uo_picture within w_pdt_04035_han4
end type
type dw_print from datawindow within w_pdt_04035_han4
end type
type cbx_1 from checkbox within w_pdt_04035_han4
end type
type dw_imhist_in from datawindow within w_pdt_04035_han4
end type
type rb_delete from radiobutton within w_pdt_04035_han4
end type
type rb_insert from radiobutton within w_pdt_04035_han4
end type
type dw_imhist from datawindow within w_pdt_04035_han4
end type
type dw_list from datawindow within w_pdt_04035_han4
end type
type gb_2 from groupbox within w_pdt_04035_han4
end type
type rr_1 from roundrectangle within w_pdt_04035_han4
end type
type dw_detail from datawindow within w_pdt_04035_han4
end type
end forward

global type w_pdt_04035_han4 from window
integer width = 4686
integer height = 2516
boolean titlebar = true
string title = "�������������"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_1 pb_1
dw_hidden dw_hidden
p_print p_print
p_2 p_2
p_1 p_1
p_retrieve p_retrieve
p_save p_save
p_delete p_delete
p_cancel p_cancel
p_exit p_exit
p_addrow p_addrow
p_delrow p_delrow
dw_print dw_print
cbx_1 cbx_1
dw_imhist_in dw_imhist_in
rb_delete rb_delete
rb_insert rb_insert
dw_imhist dw_imhist
dw_list dw_list
gb_2 gb_2
rr_1 rr_1
dw_detail dw_detail
end type
global w_pdt_04035_han4 w_pdt_04035_han4

type variables
boolean ib_ItemError
char ic_status,   ic_yn    //Ÿ���� ��뿩��(Y:���)
string is_Last_Jpno, is_Date

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

datawindowchild dws
end variables

forward prototypes
public function integer wf_dup_chk ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_item (string sitem, string sspec, long lrow)
public function integer wf_checkrequiredfield ()
public function integer wf_initial ()
end prototypes

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind
//
//FOR k = dw_list.rowcount() TO 1 step - 1
//   sfind = dw_list.getitemstring(k, 'sfind')
//
//	lReturnRow = dw_list.Find("sfind = '"+sfind+"' ", 1, dw_list.RowCount())
//	
//	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
//		f_message_chk(37,'[ǰ��/���]')
//		dw_list.Setrow(k)
//		dw_list.Setcolumn('pspec')
//		dw_list.setfocus()
//		RETURN  -1
//	END IF
//NEXT

return 1
end function

public function integer wf_imhist_create (ref string arg_sjpno);///////////////////////////////////////////////////////////////////////
//
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '001'
//
///////////////////////////////////////////////////////////////////////

string	sJpno, sIOgubun,	sDate, sTagbn, sEmpno2, sDept, &
         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom
long		lRow, lRowHist, lRowHist_In
dec		dSeq, dOutQty,	dInSeq
String   sStock, sGrpno, sGubun

dw_detail.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_detail.GetItemString(1, "gubun")		// ���ұ���

setnull(srcvcod)
SELECT AUTIPG, RCVCOD, TAGBN, NVL(IOYEA4,'N')
  INTO :sHouseGubun, :sRcvcod, :sTagbn, :sInsQc
  FROM IOMATRIX
 WHERE SABU = :gs_sabu		AND
 		 IOGBN = :sIOgubun ;
		  
if sqlca.sqlcode <> 0 then
	f_message_chk(208, '[�����]')
end if
/* â���̵� ����� ��� ��� �԰����� �˻� */
if sHousegubun = 'Y' then
	if isnull(srcvcod) or trim(srcvcod) = '' then
		f_message_chk(208, '[�����-â���̵��԰�]')	
		return -1
	end if
	//���˻� ����Ÿ ��������
   SELECT "SYSCNFG"."DATANAME"  
     INTO :sQcgub  
     FROM "SYSCNFG"  
    WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
          ( "SYSCNFG"."SERIAL" = 13 ) AND  
          ( "SYSCNFG"."LINENO" = '2' )   ;
	if sqlca.sqlcode <> 0 then
		sQcgub = '1'
	end if
	
	/* �ܰ������Ϳ� �˻����ڰ� ���� ��� ȯ�漳���� �ִ� �⺻ �˻����ڸ� �̿��Ѵ� */
	select dataname
	  into :scustom
	  from syscnfg
	 where sysgu = 'Y' and serial = '13' and lineno = '1';
end if

sDate = dw_detail.GetItemString(1, "sdate")				// �������
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_detail.GetItemString(1, "house")   //â��
sEmpno2 = dw_detail.GetItemString(1, "empno2")  //�������
sEmpno  = dw_detail.GetItemString(1, "empno")   //�Ƿ���
sDept   = dw_detail.GetItemString(1, "dept")    //�Ƿںμ�
sCvcod  = dw_detail.GetItemString(1, "cvcod")   //�԰�ó
sProject = dw_detail.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_list.RowCount()

	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")

	IF abs(dOutQty) > 0		THEN

		////////////////////////////////////////////////////////////////////////////////
		// ** �����HISTORY ���� **
		////////////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
		
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'001')			// ��ǥ��������
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// �������
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// ���ұ���=��û����
	
		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// ��������=�������
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // ǰ��

		sPspec = trim(dw_list.GetItemString(lRow, "pspec"))
		if sPspec = '' or isnull(sPspec) then sPspec = '.'
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // ���
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// ����â��=���â��
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// �ŷ�óâ��=�԰�ó
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=������
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// �˻�����=�������	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// �����ڵ�
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// ���ҽ�������=�������	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// ���ҽ�����=�����	
		dw_imhist.SetItem(lRowHist, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // ����������
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
		dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
      
		//�����  �߰�
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// �����Ƿںμ�=�Ҵ�.�μ�
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// ��������� ��� '99999999' ����
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_list.GetItemString(lRow, "lotsno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  sProject)
		dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)
		
// 	dw_imhist.SetItem(lRowHist, "outchk",  'Y') 			// ����ǷڿϷ�
		
		// â���̵� �԰��� ����
		IF sHouseGubun = 'Y'	and dOutQty > 0	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// ��ǥ��������
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// �������
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// ���ұ���=â���̵��԰���
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// ��������=�������
         //iomatrix�� Ÿ���� ������ Y�̸� �԰�ǰ�� Ÿ����ǰ���� ����
//			if stagbn = 'Y' then 
//				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "ditnbr")) // ǰ��
//				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_list.GetItemString(lRow, "dpspec")) // ���
//			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "itnbr")) // ǰ��
				dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // ���
//			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// ����â��=�԰�ó
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // �԰� â���� �ΰ� ����� ������
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// �ŷ�óâ��=���â��
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// �����ڵ�
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_list.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // ����������
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_list.GetItemString(lRow, "lotsno"))
/***************************************************************************************************************************/
/* �������������(W_PDT_04035_HAN4) ȭ���� ����â���� ����â��� â���̵� ó���� ��                *********************/
/* ����â���� ���� ����ǰ, ������ ���� ����â��� ȯ�� ��Ű�� ȭ����                                 *********************/
/* ���� �˻翩��, �ڵ����ο��� ���о��� ������ �԰� ����ڷ�� ����                                  *********************/
/* â���̵����(O05)�� ����ó��, â���̵��԰�(I11)�� ���������� �԰���ε��(ǰ��) ȭ�鿡�� �԰�ó�� *********************/
/***************************************************************************************************************************/
			dw_imHist_in.SetItem(lRowHist_in, "qcgub",	'1') // ���˻�
			dw_imHist_in.SetItem(lRowHist_in, "gurdat",	sdate)  // �˻��Ƿ�����
			dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)  //�˻���
			dw_imHist_in.SetItem(lRowHist_in, "insdat",	sdate)  //�˻�����
			dw_imhist_in.SetItem(lRowHist_in, "ioqty", sNull) 	// ���Ҽ���=�԰����
			dw_imhist_in.SetItem(lRowHist_in, "io_date",  sNull)		// ���ҽ�������=�԰��Ƿ�����
			dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
			dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// ���ҽ��ο���
/***************************************************************************************************************************
			// ���ҽ��ο��δ� �ش� â���� ���ο��θ� �������� �Ѵ�
			// �� ������ ����� �ƴ� ���� �ڵ�����'Y'���� ����
			Setnull(sSaleyn)
			SELECT HOMEPAGE
			  INTO :sSaleYN
			  FROM VNDMST
			 WHERE CVCOD = :sCvcod ;	

			IF isnull(sSaleyn) or trim(ssaleyn) = '' then
				Ssaleyn = 'N'
			end if
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////	
			sItnbr  = dw_list.GetItemString(lRow, "itnbr")
			sStock  = dw_list.GetItemString(lRow, "itemas_filsk") // ����������
			sGrpno = dw_list.GetItemString(lRow, "grpno2")

			if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then	sStock = 'Y'
				
			// ���԰˻� �Ƿ��̸鼭 �԰��� �˻�ǰ�� ���
			IF sInsQc = 'Y' and sGrpno = 'Y'	THEN			
				SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
				  INTO :sgubun,  :sempno    
				  FROM "ITEMAS"  
				 WHERE "ITEMAS"."ITNBR" = :sItnbr ;
				
				if sgubun = '' or isnull(sgubun) then		sGubun = '1'
								
				// ������ ���� ���� ��� : ���˻�, �˻����� ����				
				IF sStock = 'N'	THEN sGubun = '1'
				
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sGubun) // ���˻�
				dw_imHist_in.SetItem(lRowHist_in, "gurdat",	sdate)  // �˻��Ƿ�����
				
				if sgubun = '1' then //���˻��� ���
					dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
					dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// �˻�����=�������
				else
					if sempno = '' or isnull(sempno) then
						dw_imHist_in.SetItem(lRowHist_in, "insemp",	scustom) // �⺻�˻� �����
					else
						dw_imHist_in.SetItem(lRowHist_in, "insemp",	sempno)
					end if
					dw_imHist_in.SetItem(lRowHist_in, "insdat",	sNull)			// �˻�����
				end if
			Else
				sgubun = '1'
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun) // ���˻�
				dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
				dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)
			End If
			//////////////////////////////////////////////////////////////////////////////////////////////////////

			// ���˻��̸� �ڵ������� ��� ���γ��� ����
			IF sgubun = '1' And sSaleYn = 'Y' then
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_list.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=�԰����
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// ���ҽ��ο���
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// ���ҽ��ο���

			End If
*************************************************************************************************************************/			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// ���������
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������

//			dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_list.GetItemString(lRow, "holdstock_req_dept"))		// �����Ƿںμ�=�Ҵ�.�μ�
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // �԰���ǥ��ȣ=����ȣ
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",    dw_list.GetItemString(lRow, "cust_no"))
		END IF
	END IF
NEXT

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. �����HISTORY ����
//
///////////////////////////////////////////////////////////////////////

dec		dOutQty, dNotOutQty, dTempQty
string	sHist_Jpno, sIodate, sDelgub, syebi5
long		lRow, lRowCount, i, k

lRowCount = dw_list.RowCount()

FOR lrow = 1 TO lRowCount
	 sHist_Jpno = dw_list.GetItemString(lrow, "imhist_iojpno")
	 sIoDate    = dw_list.GetItemString(lrow, "cndate")
	 sDelgub    = dw_list.GetItemString(lrow, "opt")

   if sDelgub = 'N' then continue

	k ++	
	
	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
	if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
	   dw_list.GetItemString(lRow, "i_confirm") = 'N' then continue

	if not isnull(dw_list.GetItemString(lRow, "yebi5")) then continue
		
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU" = :gs_sabu
	   and "IMHIST"."IOJPNO" = :sHist_Jpno   ;
	  
	IF SQLCA.SQLNROWS < 1	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
	  
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU"    = :gs_sabu
	   and "IMHIST"."IP_JPNO" = :sHist_Jpno   
	   AND "IMHIST"."JNPCRT"  = '011';

	IF SQLCA.SQLCODE < 0	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
		
	i ++	
Next
////////////////////////////////////////////////////////////////////////

if k < 1 then 
	messagebox("Ȯ ��", "�����ڷḦ ���� �� ���� �Ͻʽÿ�!")
	return -1						  
end if

if i < 1 then 
	messagebox("Ȯ ��", "�԰��ڷᰡ ����ó�� �Ǿ� �����Ƿ�  ���� �� �� �����ϴ�." + &
	                    '~n' + "�԰� �ڷḦ Ȯ���ϼ���!")
	return -1						  
elseif	k <> i then 
	messagebox("Ȯ ��", "�԰��ڷᰡ �Ϻ� ����ó�� �Ǿ� �����Ƿ� �Ϻθ� ���� �Ǿ����ϴ�." + &
	                    '~n' + "�԰� �ڷḦ Ȯ���ϼ���!")
end if	

RETURN 1
end function

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* �������
//		1. �����history -> ������ update (�������� ������ ��쿡��)
//		2. �������� + ������ = ��û���� -> �Ͱ�Ϸ�('Y')
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sGubun, siodate, sioyn
dec		dOutQty, dTemp_OutQty
long		lRow, i, k, lCount

lcount = dw_list.RowCount()

FOR	lRow = 1		TO	lcount

   k++
	
	dOutQty      = dw_list.GetItemDecimal(lRow, "outqty")			// ������(�����history)
	dTemp_OutQty = dw_list.GetItemDecimal(lRow, "temp_outqty")	// ������(�����history)
	sHist_Jpno   = dw_list.GetItemString(lRow, "imhist_iojpno")
	sGubun		 = dw_list.GetItemString(lRow, "imhist_outchk")
	
	siodate = dw_list.GetItemString(lRow, "cndate")
	sioyn   = dw_list.GetItemString(lRow, "i_confirm")
	
	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
	if (not isnull(siodate)) AND sioyn = 'N' then continue
	
	IF dOutQty <> dTemp_OutQty		THEN

		  UPDATE "IMHIST"  
     		  SET "IOQTY"   = :dOutQty,   
         		"IOREQTY" = :dOutQty,   
         		"IOSUQTY" = :dOutQty,   
         		"OUTCHK" = :sGubun,  
					"UPD_USER" = :gs_userid    
   		WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
         		( "IMHIST"."IOJPNO" = :sHist_Jpno )   ;

		IF SQLCA.SQLNROWS <> 1	THEN
			ROLLBACK;
			f_Rollback();
			RETURN -1
		END IF
		
		//�ڵ��� ��� �԰�������� ���� ����
		IF sioyn = 'Y' and (not isnull(sIodate)) then 
		   UPDATE "IMHIST"  
			   SET "IOQTY"   = :dOutQty,   
					 "IOREQTY" = :dOutQty,   
					 "IOSUQTY" = :dOutQty,  
					 "UPD_USER" = :gs_userid  
			 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
					 ( "IMHIST"."IP_JPNO" = :sHist_Jpno )   AND
					 ( "IMHIST"."JNPCRT" = '011' ) ;		
		ELSE
		   UPDATE "IMHIST"  
			   SET "IOREQTY" = :dOutQty,   
					 "IOSUQTY" = :dOutQty,  
 					 "UPD_USER" = :gs_userid  
			 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
					 ( "IMHIST"."IP_JPNO" = :sHist_Jpno )   AND
					 ( "IMHIST"."JNPCRT" = '011' ) ;		
		END IF
		
		IF SQLCA.SQLCODE < 0	THEN
			ROLLBACK;
			f_Rollback();
			RETURN -1
		END IF
	END IF
   i++
NEXT

if i < 1 then 
	messagebox("Ȯ ��", "�԰��ڷᰡ ����ó�� �Ǿ� �����Ƿ� ���� �� �� �����ϴ�." + &
	                    'N' + "�԰� �ڷḦ Ȯ���ϼ���!")
	return -1						  
elseif	k <> i then 
	messagebox("Ȯ ��", "�԰��ڷᰡ �Ϻ� ����ó�� �Ǿ� �����Ƿ� �Ϻθ� ���� �Ǿ����ϴ�." + &
	                    'N' + "�԰� �ڷḦ Ȯ���ϼ���!")
end if	

RETURN 1
end function

public function integer wf_item (string sitem, string sspec, long lrow);String  sname, sitgu, snull, sispec, sfilsk, sdepot, sjijil, sSpec_code, slotgub, sGrpno2
Decimal {3} dJegoqty, dvalidqty, dqty

Setnull(sNull)

IF sspec = '' OR ISNULL(sspec) then sspec = '.'

sdepot = dw_detail.getitemstring(1, 'house')

SELECT A.ITDSC, A.ISPEC, A.ITGU, A.FILSK, A.JIJIL, A.ISPEC_CODE, A.LOTGUB, B.GRPNO2
  INTO :sName, :sIspec, :sItgu, :sFilsk, :sjijil, :sspec_code, :sLotgub, :sGrpno2
  FROM ITEMAS A, ITEMAS_INSPECTION B
 WHERE A.ITNBR = B.ITNBR AND A.ITNBR = :sItem 	AND	 A.USEYN = '0'  ;                   
 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[ǰ��]')
	dw_list.setitem(lRow, "itnbr", sNull)	
	dw_list.SetItem(lRow, "itdsc", sNull)
	dw_list.SetItem(lRow, "ispec", sNull)
	dw_list.SetItem(lRow, "jijil", sNull)
	dw_list.SetItem(lRow, "ispec_code", sNull)
	dw_list.SetItem(lRow, "itemas_filsk", sNull)
	dw_list.SetItem(lRow, "itemas_itgu",  sNull)
	dw_list.SetItem(lRow, "lotgub",  sNull)
	dw_list.SetItem(lRow, "grpno2",  sNull)
	dw_list.setitem(lrow, "jego_qty", 0)
	dw_list.setitem(lrow, "valid_qty", 0)
	dw_list.setitem(lrow, "jego_temp", 0)
	RETURN 1
END IF

dw_list.SetItem(lRow, "itdsc", sName)
dw_list.SetItem(lRow, "ispec", sIspec)
dw_list.SetItem(lRow, "jijil", sjijil)
dw_list.SetItem(lRow, "ispec_code", sspec_code)
dw_list.SetItem(lRow, "itemas_itgu",  sitgu)
dw_list.SetItem(lRow, "itemas_filsk", sfilsk)
dw_list.SetItem(lRow, "lotgub", sLotgub)
dw_list.SetItem(lRow, "grpno2", sGrpno2)

/* ������� : lot�������ϴ� ��츸*/
If sLotgub = 'N' Then
	SELECT NVL(A.JEGO_QTY, 0), NVL(A.VALID_QTY,0), 
			 A.JEGO_QTY + ( A.JISI_QTY + A.PROD_QTY  + A.BALJU_QTY + A.POB_QC_QTY +  
								 A.INS_QTY  + A.GI_QC_QTY + A.GITA_IN_QTY ) 
							- ( A.HOLD_QTY + A.ORDER_QTY + A.MFGCNF_QTY ) 
	 INTO :dJegoqty, :dvalidqty, :dqty
	 FROM STOCK A
	WHERE A.DEPOT_NO = :SDEPOT 
	  AND A.ITNBR    = :SITEM
	  AND A.PSPEC    = :SSPEC; 
End If

dw_list.setitem(lrow, "jego_qty", dJegoqty)
dw_list.setitem(lrow, "valid_qty", dvalidqty)
dw_list.setitem(lrow, "jego_temp", dqty)
 	
return 0
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. ���� = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sLotgub, sLotNo
dec		dQty
long		lRow, lCount

lCount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount

	// ǰ��
	sItem = dw_list.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[ǰ��]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("itnbr")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	// ����û����	
	dQty = dw_list.getitemdecimal(lrow, "outqty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[������]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("outqty")
		dw_list.setfocus()
		RETURN -1
	END IF

	// LOT ���� üũ
   sLotgub = Trim(dw_list.GetitemString(lRow, "lotgub"))
	sLotNo  = Trim(dw_list.GetitemString(lRow, "lotsno"))
	If IsNull(sLotgub) Or sLotgub = '' Then sLotgub  = 'N'

	If sLotgub = 'Y' And (IsNull(sLotNo) Or sLotNo = '' ) Then
		f_message_chk(30,'[LOT NO]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("lotsno")
		dw_list.setfocus()
		RETURN -1
	End If
	/////////////////////////////////////////////////////////////////////////
	//	1. ������ -> ���߰��� data�� �Ƿڹ�ȣ : �������� + 1 ->SETITEM
	// 2. ��ǥ��ȣ�� NULL �ΰ͸� �������� + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_list.GetitemString(lRow, "imhist_iojpno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_list.SetItem(lRow, "imhist_iojpno", is_Last_Jpno)
		END IF
	END IF

NEXT

RETURN 1
end function

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()

//cb_save.enabled = false
p_delete.enabled = false
p_delete.PictureName = 'c:\erpman\image\����_d.gif'

dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then
	// ��Ͻ�
	dw_detail.settaborder("jpno",   0)
	dw_detail.settaborder("sdate",  10)
//	dw_detail.settaborder("HOUSE",  20)
//	dw_detail.settaborder("PROJECT",30)
	dw_detail.settaborder("empno2", 40)
	dw_detail.settaborder("empno",  50)
//	dw_detail.settaborder("GUBUN",  60)
//	dw_detail.settaborder("cvcod",  70)

	dw_detail.Modify("t_dsp_no.visible = 0")
	
	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_chang.visible = 1")
	dw_detail.Modify("t_dsp_gbn.visible = 1")
	dw_detail.Modify("t_dsp_demp.visible = 1")
	dw_detail.Modify("t_dsp_emp.visible = 1")
	dw_detail.Modify("t_dsp_cust.visible = 1")

	dw_detail.setcolumn("HOUSE")

	dw_detail.setitem(1,'empno',gs_empno)
	dw_detail.setitem(1,'empnm',f_get_name5('02',gs_empno,''))
	dw_detail.setitem(1,'empno2',gs_empno)
	dw_detail.setitem(1,'empnm2',f_get_name5('02',gs_empno,''))
	dw_detail.setitem(1,'dept',gs_dept)
	dw_detail.setitem(1,'deptname',f_get_name5('01',gs_dept,''))
	dw_detail.SetItem(1, "sdate", is_Date)
	if dws.rowcount() > 0 then
		dw_detail.setitem(1, "gubun",  dws.getitemstring(1, "iogbn"))
		dw_detail.SetItem(1, "check", dws.getitemstring(1, "naougu"))
	end if

	p_retrieve.enabled = false
	p_retrieve.PictureName = 'c:\erpman\image\��ȸ_d.gif'
	
	p_addrow.enabled = true
	p_addrow.PictureName = 'c:\erpman\image\���߰�_up.gif'
	
	p_delrow.enabled = true
	p_delrow.PictureName = 'c:\erpman\image\�����_up.gif'
	
	w_mdi_frame.sle_msg.text = "���"

ELSE
	dw_detail.settaborder("jpno",   10)
	dw_detail.settaborder("GUBUN",  0)
	dw_detail.settaborder("sDATE",  0)
	dw_detail.settaborder("PROJECT",0)
	dw_detail.settaborder("HOUSE",  0)
	dw_detail.settaborder("empno",   0)
	dw_detail.settaborder("empno2",   0)
	dw_detail.settaborder("cvcod",   0)

   dw_detail.Modify("t_dsp_no.visible = 1")
	
	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_chang.visible = 0")
	dw_detail.Modify("t_dsp_gbn.visible = 0")
	dw_detail.Modify("t_dsp_demp.visible = 0")
	dw_detail.Modify("t_dsp_emp.visible = 0")
	dw_detail.Modify("t_dsp_cust.visible = 0")

	dw_detail.setcolumn("JPNO")

	p_retrieve.enabled = true
	p_retrieve.PictureName = 'c:\erpman\image\��ȸ_up.gif'
	
	p_addrow.enabled = false
	p_addrow.PictureName = 'c:\erpman\image\���߰�_d.gif'
	
	p_delrow.enabled = false
	p_delrow.PictureName = 'c:\erpman\image\�����_d.gif'
	
	w_mdi_frame.sle_msg.text = "����"
	
END IF

dw_detail.setfocus()

//�԰�â�� 
//f_child_saupj(dw_detail, 'house', gs_saupj)

dw_detail.setredraw(true)

return  1

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

// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

//dw_detail.getchild("gubun", dws)
//dws.settransobject(sqlca)
//dws.retrieve(gs_sabu, '001')

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")
p_print.Visible = False

end event

on w_pdt_04035_han4.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_1=create pb_1
this.dw_hidden=create dw_hidden
this.p_print=create p_print
this.p_2=create p_2
this.p_1=create p_1
this.p_retrieve=create p_retrieve
this.p_save=create p_save
this.p_delete=create p_delete
this.p_cancel=create p_cancel
this.p_exit=create p_exit
this.p_addrow=create p_addrow
this.p_delrow=create p_delrow
this.dw_print=create dw_print
this.cbx_1=create cbx_1
this.dw_imhist_in=create dw_imhist_in
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_imhist=create dw_imhist
this.dw_list=create dw_list
this.gb_2=create gb_2
this.rr_1=create rr_1
this.dw_detail=create dw_detail
this.Control[]={this.pb_1,&
this.dw_hidden,&
this.p_print,&
this.p_2,&
this.p_1,&
this.p_retrieve,&
this.p_save,&
this.p_delete,&
this.p_cancel,&
this.p_exit,&
this.p_addrow,&
this.p_delrow,&
this.dw_print,&
this.cbx_1,&
this.dw_imhist_in,&
this.rb_delete,&
this.rb_insert,&
this.dw_imhist,&
this.dw_list,&
this.gb_2,&
this.rr_1,&
this.dw_detail}
end on

on w_pdt_04035_han4.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.dw_hidden)
destroy(this.p_print)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_retrieve)
destroy(this.p_save)
destroy(this.p_delete)
destroy(this.p_cancel)
destroy(this.p_exit)
destroy(this.p_addrow)
destroy(this.p_delrow)
destroy(this.dw_print)
destroy(this.cbx_1)
destroy(this.dw_imhist_in)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_imhist)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.dw_detail)
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
   Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyQ!
		p_retrieve.TriggerEvent(Clicked!)
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

type pb_1 from u_pb_cal within w_pdt_04035_han4
integer x = 686
integer y = 36
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type dw_hidden from datawindow within w_pdt_04035_han4
boolean visible = false
integer x = 1006
integer y = 1340
integer width = 1317
integer height = 168
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_print from uo_picture within w_pdt_04035_han4
boolean visible = false
integer x = 3013
integer y = 176
integer width = 306
integer taborder = 100
string picturename = "C:\erpman\image\����óǰ����_up.gif"
end type

event clicked;call super::clicked;//����ó ǰ����	-���ϸ�
string scvcod, sempno1, sempno2, sin_house, soutno, sopt, sitem, sopseq
int    k, lRow
Decimal {5} ddata

IF dw_detail.AcceptText() = -1	THEN	RETURN

sCvcod 	= dw_detail.getitemstring(1, "cvcod" ) /* �԰�ó */
Sempno1  = dw_detail.getitemstring(1, "empno" ) /* ��û�� */
Sempno2  = dw_detail.getitemstring(1, "empno2") /* ������� */
sin_house= dw_detail.getitemstring(1, "house" ) /* ��� â��  */
Soutno   = dw_detail.getitemstring(1, "jpno"  ) /* ��� ��ȣ  */

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[�԰�ó]')
	dw_detail.SetColumn("cvcod")
	dw_detail.SetFocus()
	RETURN
END IF

// �������
IF IsNull(Sempno2)	or   trim(Sempno2) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[�������]')
	dw_detail.Setcolumn("empno2")
	dw_detail.setfocus()
	RETURN 
END IF

// ���â��
IF IsNull(sin_house)	or   trim(sin_house) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[���â��]')
	dw_detail.Setcolumn("house")
	dw_detail.setfocus()
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
	if 	sopt = 'Y' then 
		lRow = dw_list.insertrow(0)

      sitem = 	dw_hidden.getitemstring(k, 'poblkt_itnbr' )
		dw_list.setitem(lRow, 'itnbr', sitem)
		dw_list.setitem(lRow, 'itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_list.setitem(lRow, 'ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_list.setitem(lRow, 'jijil', dw_hidden.getitemstring(k, 'itemas_jijil' ))
	end if	
NEXT
dw_hidden.reset()
dw_list.ScrollToRow(lRow)
dw_list.setrow(lRow)
dw_list.SetColumn("outqty")
dw_list.SetFocus()


end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\����óǰ����_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\����óǰ����_up.gif"
end event

type p_2 from uo_picture within w_pdt_04035_han4
boolean visible = false
integer x = 3191
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\�����ȸ_up.gif"
end type

event clicked;call super::clicked;long lRow

if dw_list.accepttext() = -1 then return 
if dw_detail.accepttext() = -1 then return 
if dw_list.rowcount() < 1 then return 

lRow = dw_list.getrow()

if lRow < 1 then 
	messagebox('Ȯ ��', '��ȸ�� �ڷḦ �����ϼ���!')
	return 
end if

gs_code = dw_list.getitemstring(lRow, 'itnbr')
IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
	f_message_chk(30,'[ǰ��]')
	dw_list.ScrollToRow(lRow)
	dw_list.Setcolumn("itnbr")
	dw_list.setfocus()
	RETURN 
END IF
gs_gubun = dw_detail.getitemstring(1, 'house')

// �ڵ���� Y�� �ƴϸ� ������ �� ���� ��ȸ�� 'Y' �̸� ������ �� ����
gs_codename = 'N' 

open(w_stock_popup)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����ȸ_up.gif"
end event

type p_1 from uo_picture within w_pdt_04035_han4
integer x = 3017
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;if dw_detail.enabled then

	p_addrow.triggerevent(clicked!)
	
	string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
				sRelcod, sNaougu, scvcod 
	long		lRow
	
	sDate    = TRIM(dw_detail.GetItemString(1, "sdate"))
	sHouse   = dw_detail.GetItemString(1, "house")
	sEmpno2  = dw_detail.GetItemString(1, "empno2")
	sEmpno   = dw_detail.GetItemString(1, "empno")
	sDept 	= dw_detail.GetItemString(1, "dept")
	sGubun 	= dw_detail.GetItemString(1, "gubun")
	sCheck   = dw_detail.GetItemString(1, "check")
	scvcod   = dw_detail.GetItemString(1, "cvcod")
	
	if isnull(sdate)   or trim(sdate)   = '' or &
		isnull(shouse)  or trim(shouse)  = '' or &
		isnull(sempno2) or trim(sempno2) = '' or &
		isnull(sempno)  or trim(sempno)  = '' or &
		isnull(sdept)   or trim(sdept)   = '' or &
		isnull(sgubun)  or trim(sgubun)  = '' or &
		isnull(scheck)  or trim(scheck)  = '' or &
		isnull(scvcod)  or trim(scvcod)  = '' Then 
		return
	end if
	
	dw_list.deleterow(dw_list.getrow())
	
end if

datawindow dwname	

dw_detail.accepttext()
dwname = dw_list
gs_code = dw_detail.getitemstring(1, "house")

openwithparm(w_pdt_04037, dwname)

setnull(gs_code)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_retrieve from uo_picture within w_pdt_04035_han4
integer x = 3730
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

event clicked;call super::clicked;
if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

sJpno   	= dw_detail.getitemstring(1, "jpno")

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[����ȣ]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	messagebox("Ȯ��","�ش��ڷᰡ �����ϴ�.")
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	return
end if

is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "imhist_iojpno")

dw_detail.enabled = false

p_delete.enabled = true
p_delete.PictureName = 'c:\erpman\image\����_up.gif'

dw_list.SetColumn("itnbr")
dw_list.SetFocus()
//cb_save.enabled = true
end event

type p_save from uo_picture within w_pdt_04035_han4
integer x = 3904
integer y = 24
integer width = 178
integer taborder = 80
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

string	sArg_sdate

//dw_detail.GetItemString(1, "sdate")
//dw_detail.GetItemString(1, "house")
//dw_detail.GetItemString(1, "gubun")
//dw_detail.GetItemString(1, "cvcod")

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ���� = 0		-> RETURN
//		2. �����HISTORY : ��ǥä������('C0')
//
//////////////////////////////////////////////////////////////////////////////////
IF	wf_CheckRequiredField() = -1		THEN	RETURN 

If wf_dup_chk() = -1 then return 

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_imhist_create(sArg_sdate) = -1 THEN
		ROLLBACK;
		RETURN
	END IF

	IF dw_imhist.Update() <= 0		THEN
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF
	
	IF dw_imhist_in.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
		RETURN
	END IF
	
	MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " + left(sArg_sDate, 8)+ '-' + right(sArg_sDate,4)+		&
										 "~r~r�����Ǿ����ϴ�.")	
	
	if cbx_1.checked then 
		dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate, gs_saupj)
		dw_print.print()
   end if      										 
ELSE

	IF wf_imhist_update() = -1 THEN
		ROLLBACK;
		RETURN
	else
		commit;
	END IF
	
END IF

////////////////////////////////////////////////////////////////////////
								 
p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_delete from uo_picture within w_pdt_04035_han4
integer x = 4078
integer y = 24
integer width = 178
integer taborder = 90
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

IF f_msg_delete() = -1 THEN	RETURN

SetPointer(HourGlass!)

IF wf_Imhist_Delete() = -1		THEN	
	rollback;
	RETURN
end if

COMMIT;

p_cancel.TriggerEvent("clicked")
	
	

end event

type p_cancel from uo_picture within w_pdt_04035_han4
integer x = 4251
integer y = 24
integer width = 178
integer taborder = 100
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

type p_exit from uo_picture within w_pdt_04035_han4
integer x = 4425
integer y = 24
integer width = 178
integer taborder = 110
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_addrow from uo_picture within w_pdt_04035_han4
integer x = 3374
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\���߰�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���߰�_up.gif"
end event

event clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

//////////////////////////////////////////////////////////
string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
         sRelcod, sNaougu, scvcod 
long		lRow

sDate    = TRIM(dw_detail.GetItemString(1, "sdate"))
sHouse   = dw_detail.GetItemString(1, "house")
sProject = dw_detail.GetItemString(1, "project")
sEmpno2  = dw_detail.GetItemString(1, "empno2")
sEmpno   = dw_detail.GetItemString(1, "empno")
sDept 	= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")
sCheck   = dw_detail.GetItemString(1, "check")
scvcod   = dw_detail.GetItemString(1, "cvcod")

// �����
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[�������]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// ���â��
IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[���â��]')
	dw_detail.SetColumn("house")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(sempno2) or sempno2 = "" 	THEN
	f_message_chk(30,'[�������]')
	dw_detail.SetColumn("empno2")
	dw_detail.SetFocus()
	RETURN
END IF

// ��û��
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[��û��]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF
// ��û�μ�
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[��û�μ�]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN
END IF
// ���ұ���
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[���ұ���]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

// ��û���п� ���� ����ó�ڵ�
Setnull(sRelcod)
Setnull(sNaougu)
select relcod, naougu into :sRelcod, :sNaougu from iomatrix 
 where sabu = :gs_sabu and iogbn = :sGubun;
if  isnull(sNaougu) or trim(sNaougu) = '' or &
	(sNaougu <> '1' and sNaougu <> '2') then
	f_message_chk(208,'[���,�⹮����]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
end if 
if isnull(sRelcod) or trim(sRelcod) = '' then
	f_message_chk(208,'[�԰�ó]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
end if

// �԰�ó
IF isnull(scvcod) or scvcod = "" 	THEN
	f_message_chk(30,'[�԰�ó]')
	dw_detail.SetColumn("cvcod")
	dw_detail.SetFocus()
	RETURN
END IF

///////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

//dw_list.SetItem(lRow, "sabu",     gs_sabu)
//dw_list.SetItem(lRow, "hold_date", sDate)
//dw_list.SetItem(lRow, "req_dept",  sDept)
//dw_list.SetItem(lRow, "wiemp",     sEmpno)
//dw_list.SetItem(lRow, "hold_gu",   sGubun)
//dw_list.SetItem(lRow, "out_store", sHouse)
//dw_list.SetItem(lRow, "naougu",	  sCheck)
//dw_list.SetItem(lRow, "pjtno",	  sProject)
//dw_list.SetItem(lRow, "pspec",	  '.')
//
// �ڷᰡ �Ѱ��̶� ������ HEAD������ ������ �� ����
dw_detail.enabled = False

dw_list.setrow(Lrow)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

type p_delrow from uo_picture within w_pdt_04035_han4
integer x = 3547
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

event clicked;call super::clicked;
long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N' �� �ƴ� ���)*/
if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
	dw_list.GetItemString(lRow, "i_confirm") <> 'N' then 
	messagebox("Ȯ ��", "�԰��ڷᰡ ����ó�� �Ǿ� �����Ƿ� ���� �� �� �����ϴ�." + &
							  '~n' + "�԰� �ڷḦ Ȯ���ϼ���!")
	return 
end if	

/* ������ȣ�� ����� ��� ���� �Ұ� */
if not isnull(dw_list.GetItemString(lRow, "yebi5"))  then 
	messagebox("Ȯ ��", "����峻���� ��ϵǾ��ֽ��ϴ�" + &
							  '~n' + "����� �ڷḦ Ȯ���ϼ���!")
	return 
end if	

// �ڷᰡ ������ HEAD������ ������ �� ����
dw_list.DeleteRow(lRow)

if dw_list.rowcount() < 1 then
	dw_detail.enabled = true
end if


end event

type dw_print from datawindow within w_pdt_04035_han4
boolean visible = false
integer x = 1317
integer y = 2336
integer width = 855
integer height = 104
boolean titlebar = true
string title = "������� ���"
string dataobject = "d_pdt_04035_02_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_pdt_04035_han4
boolean visible = false
integer x = 3543
integer y = 232
integer width = 288
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�����"
end type

type dw_imhist_in from datawindow within w_pdt_04035_han4
boolean visible = false
integer x = 713
integer y = 2332
integer width = 494
integer height = 212
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type rb_delete from radiobutton within w_pdt_04035_han4
integer x = 4288
integer y = 208
integer width = 242
integer height = 72
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
ic_yn = 'N'
//dw_list.DataObject = 'd_pdt_04035_1'
//dw_list.SetTransObject(SQLCA)

dw_list.Object.opt.Visible = True
dw_list.Object.opt_t.Visible = True

p_1.enabled = false

wf_Initial()


end event

type rb_insert from radiobutton within w_pdt_04035_han4
integer x = 3927
integer y = 208
integer width = 242
integer height = 72
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
ic_yn = 'N'
//dw_list.DataObject = 'd_pdt_04035_1'
//dw_list.SetTransObject(SQLCA)
//
dw_list.Object.opt.Visible = false
dw_list.Object.opt_t.Visible = false

p_1.enabled = true

wf_Initial()


end event

type dw_imhist from datawindow within w_pdt_04035_han4
boolean visible = false
integer x = 96
integer y = 2328
integer width = 494
integer height = 212
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_list from datawindow within w_pdt_04035_han4
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 344
integer width = 4553
integer height = 1864
integer taborder = 30
string dataobject = "d_pdt_04035_han3_1"
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

event itemchanged;string	sItem, sName, sSpec, sCode, sHouse, sIogbn, sNull, spspec, sGub, sJijil, sSpec_code,sLotNo, sLotgub
long		lRow
dec{3}	dOutQty, dStock, dTempQty, djegoqty, dvalidqty, dqty
integer  ireturn
SetNull(sNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = 'itnbr'	THEN
	sItem  = trim(this.GetText())
	spspec = this.getitemstring(lrow, "pspec")
	ireturn = wf_item(sitem, sPspec, lrow)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name3('ǰ��', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sspec = trim(this.GetText())
	ireturn = f_get_name3('�԰�', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name3('����', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sspec_code = trim(this.GetText())
	ireturn = f_get_name3('�԰��ڵ�', 'Y', sItem, sName, sSpec, sJijil, sSpec_code)
	this.setitem(lrow, "itnbr", sitem)	
	this.setitem(lrow, "itdsc", sname)	
	this.setitem(lrow, "ispec", sspec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sSpec_code)
	if sitem > '.' then
		spspec = this.getitemstring(lrow, "pspec")
		wf_item(sitem, sPspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "pspec"	THEN
	spspec = trim(this.GetText())
	sitem = this.getitemstring(lrow, "itnbr")
	IF sitem = '' OR ISNULL(sitem) then return 
	wf_item(sitem, sPspec, lrow)
ELSEIF this.GetColumnName() = "outqty" THEN

	dOutQty = dec(this.GetText())
	if isnull(dOutQty) or dOutQty = 0 then return 

	dStock  = this.GetItemDecimal(lRow, "jego_qty")
	
   sHouse  = dw_detail.GetItemString(1, 'house')  	

	// ��� ��뿩�� â���� ��ȸ 
   SELECT KYUNGY INTO :sGub FROM VNDMST WHERE CVCOD = :sHouse ;

	IF sGub = 'N' then 
		IF ic_status = '2'	THEN
			dTempQty = this.GetItemDecimal(lRow, "temp_outqty")
			dOutQty = dOutQty - dTempQty
		END IF
			
		IF dOutQty > dStock		THEN
			MessageBox("Ȯ��", "�������� ������� Ŭ �� �����ϴ�.")
			this.SetItem(lRow, "outqty", 0)
			RETURN 1
		END IF
	END IF
// Lot No �Է½�
ELSEIF this.GetColumnName() = "lotsno" THEN
	sLotNo = Trim(GetText())
	sItem  = this.getitemstring(lrow, "itnbr")
	spspec = this.getitemstring(lrow, "pspec")
	sHouse  = dw_detail.GetItemString(1, 'house')
	sLotgub = this.getitemstring(lrow, "lotgub")
	
	If IsnUll(sItem) Or Trim(sItem) = '' Then
		MessageBox("Ȯ��", "ǰ���� ���� �����ϼ���.!!")
		this.SetItem(lRow, "itnbr", 0)
		RETURN 1
	END IF

	If sLotgub <> 'Y' Then
		MessageBox("Ȯ��", "LOT NO����ǰ���� �ƴմϴ�.!!")
		this.SetItem(lRow, "itnbr", 0)
		RETURN 1
	END IF
	
	SELECT NVL(A.JEGO_QTY, 0), NVL(A.VALID_QTY,0), 
			 A.JEGO_QTY + ( A.JISI_QTY + A.PROD_QTY  + A.BALJU_QTY + A.POB_QC_QTY +  
								 A.INS_QTY  + A.GI_QC_QTY + A.GITA_IN_QTY ) 
							- ( A.HOLD_QTY + A.ORDER_QTY + A.MFGCNF_QTY ) 
	 INTO :dJegoqty, :dvalidqty, :dqty
	 FROM STOCK_LOT_VIEW A
	WHERE A.DEPOT_NO = :sHouse 
	  AND A.ITNBR    = :SITEM
	  AND A.PSPEC    = :spspec
	  AND A.LOTNO    = :sLotno; 
	  
	dw_list.setitem(lrow, "jego_qty",  dJegoqty)
	dw_list.setitem(lrow, "valid_qty", dvalidqty)
	dw_list.setitem(lrow, "jego_temp", dqty)
END IF

end event

event itemerror;RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	THEN
	gs_gubun = '1'
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

type gb_2 from groupbox within w_pdt_04035_han4
integer x = 3840
integer y = 156
integer width = 754
integer height = 148
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_pdt_04035_han4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 332
integer width = 4576
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_pdt_04035_han4
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 9
integer y = 16
integer width = 2990
integer height = 312
integer taborder = 10
string dataobject = "d_pdt_04035_han4"
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

event itemchanged;string	sDate,  sDate2, sDept, sName, sProject, old_gubun,	&
			sGubun, sHouse, sCheck, sNull, sRelcod, sNaougu, sEmpno, sEmpnm, sTagbn, spass
string   scode, sname1, get_dept, get_deptnm, sname2, sEmpno2, sEmpnm2, scvcod, scvnas
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[�������]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'house' THEN
	sHouse = trim(this.gettext())
	
	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[���â��]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno2", sNull)
		this.setitem(1, "empnm2", sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno2", sNull)
			this.setitem(1, "empnm2", sNull)
			return 1
      END IF		
	END IF

	this.setitem(1, "empno2", sNull)
	this.setitem(1, "empnm2", sNull)

	SELECT A.EMPNO, B.EMPNAME INTO :sempno, :sname
		FROM DEPOT_EMP A, P1_MASTER B
		WHERE A.EMPNO = B.EMPNO
		AND	A.DEPOT_NO = :sHouse;
		//AND A.OWNER = 'Y'
		
	If isNull(sempno) Or sempno = '' Then
		this.SetItem(1,"empno2", '')
		this.SetItem(1,"empnm2", '')
	Else
		this.SetItem(1,"empno2", sempno)
		this.SetItem(1,"empnm2", sname)
	End If
	
ELSEIF this.GetColumnName() = "empno2" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empnm2', sname)
      return 
   end if
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("Ȯ ��", "â�� ���� �Է��ϼ���")
		this.setitem(1, "empno2", sNull)
		this.setitem(1, "empnm2", sNull)
		this.setcolumn('house')
		this.setfocus()
		return 1
	end if
	
   ireturn = f_get_name2('��������', 'Y', scode, sname, sname2)    //1�̸� ����, 0�� ����	

	this.setitem(1, 'empno2', scode)
	this.setitem(1, 'empnm2', sname)
   return ireturn 
	
ELSEIF this.GetColumnName() = 'empno' THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empnm', sNull)
      return 
   end if
   ireturn = f_get_name2('���', 'Y', scode, sname1, shouse)    //1�̸� ����, 0�� ����	
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empnm', sname1)
	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :get_dept, :get_deptnm  
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		this.setitem(1, 'dept', get_dept)
		this.setitem(1, 'deptname', get_deptnm)
	END IF	
   return ireturn 
ELSEif this.getcolumnname() = 'gubun' then
	sGubun = this.gettext()
	if sGubun = 'O06' or sGubun = 'O11' then
		p_print.Visible = True
	else
		p_print.Visible = False
	end if
	old_Gubun = this.getitemstring(1, 'gubun')
	// ��û���п� ���� ����ó�ڵ�
	Setnull(sRelcod)
	Setnull(sNaougu)
	select relcod, naougu, tagbn into :sRelcod, :sNaougu, :sTagbn from iomatrix 
	 where sabu = :gs_sabu and iogbn = :sGubun;

	IF sTagbn = 'Y' then
		ic_yn = 'Y'
		MessageBox("Ȯ ��", "Ÿ���� ��ü�� ����Ƿڿ��� ����ϼ���!", StopSign!)
		this.setitem(1, 'gubun', old_gubun)
		return 1
	ELSE
		ic_yn = 'N'
	END IF
	
	this.setitem(1, "cvcod", sNull)
	this.setitem(1, 'cvnas', sNull)		

	if  isnull(sNaougu) or trim(sNaougu) = '' or &
		(sNaougu <> '1' and sNaougu <> '2') then
		f_message_chk(208,'[���,�⹮����]')
		dw_detail.SetColumn("gubun")
		dw_detail.SetFocus()
		RETURN 1
	end if 
	if isnull(sRelcod) or trim(sRelcod) = '' then
		f_message_chk(208,'[�԰�ó]')
		dw_detail.SetColumn("gubun")
		dw_detail.SetFocus()
		RETURN 1
	end if	
	
	this.setitem(1, "check", sNaougu)

ELSEIF this.GetColumnName() = "cvcod" THEN
   
	string	sChk, sgbn1, sgbn2, sgbn3, sgbn4, sgbn5 

	sgubun = dw_detail.getitemstring(1, "gubun")
	
	if sgubun = '' or isnull(sgubun) then 
		messagebox("Ȯ ��", "���ұ����� ���� �Է��ϼ���!")
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, 'cvnas', sNull)		
		this.setcolumn('gubun')
		this.setfocus()
		return 1
	end if
	
	/* ����ó ���� �˻� */
	SELECT RELCOD INTO :sChk FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sGubun;
	    
	sCode  = this.GetText()						
	if sCode = "" or isnull(sCode) then 
		this.setitem(1, 'cvnas', snull)
		return 
	end if
	
	/* ����ó�ڵ� ���п� ���� �ŷ�ó������ setting */
	Choose case schk
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
					f_message_chk(208,'[�԰�ó]')
					this.setitem(1, "cvcod", sNull)
					this.setitem(1, 'cvnas', sNull)		
				   return 1
	End choose

	SELECT "CVNAS2"
	  INTO :sName
	  FROM "VNDMST" 
	 WHERE "CVCOD" = :sCode  AND
			 "CVGU"  IN (:sgbn1, :sgbn2, :sgbn3, :sgbn4, :sgbn5) ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[�԰�ó]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, 'cvnas', sNull)		
	   return 1
	ELSE
		this.setitem(1, 'cvnas', sName)
	END IF
	
ELSEIF this.getcolumnname() = "jpno"	then
	string	sJpno
	sJpno = this.gettext() 
	
	  SELECT A.INSDAT,						// �������
				A.IO_EMPNO,			         // �������
				FUN_GET_EMPNO(A.IO_EMPNO),	// ������ڸ�
				A.IOGBN,			            // �����
				A.DEPOT_NO,			         // ���â��
				A.IOREDEPT, 	            // ��û�μ�
				FUN_GET_DPTNO(A.IOREDEPT), // �μ���
				A.IOREEMP,		            // ��û��
				FUN_GET_EMPNO(A.IOREEMP), 	// ��û�ڸ�
            A.PJT_CD,                  // ������Ʈ ��ȣ
            B.NAOUGU,
            A.CVCOD,                   // �԰�ó �ڵ�
				FUN_GET_CVNAS(A.CVCOD)     // �԰�ó��
		 INTO :sDate,   :sEmpno2, :sEmpnm2,  :sGubun, :sHouse, :sDept, :sName, 
				:sEmpno,  :sEmpnm,  :sProject, :sCheck ,:sCvcod, :sCvnas   	
		 FROM IMHIST A, IOMATRIX B 
		WHERE A.SABU   = :gs_sabu AND
				A.IOJPNO LIKE :sJpno||'%' 	AND
				TRIM(A.JNPCRT) LIKE '001' AND
				A.GURDAT = '99999999' AND   //�������� �˻��û�Ͽ� '99999999' ����
            A.SABU   = B.SABU AND
            A.IOGBN  = B.IOGBN AND 
				ROWNUM = 1    	;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[����ȣ]')
		this.setitem(1, "jpno",     sNull)
		this.setitem(1, "sdate",    sNull)
		this.setitem(1, "dept",     sNull)
		this.setitem(1, "deptname", sNull)
		this.setitem(1, "empno", 	 sNull)
		this.setitem(1, "empnm",    sNull)
		this.setitem(1, "empno2", 	 sNull)
		this.setitem(1, "empnm2",    sNull)
		this.setitem(1, "gubun",    sNull)
		this.setitem(1, "house",    sNull)
		this.setitem(1, "check",    sNull)
		this.setitem(1, "project",  sNull)
		this.setitem(1, "cvcod",    sNull)
		this.setitem(1, "cvnas",    sNull)
		return 1
	end if

	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[���â��]')
		this.setitem(1, "jpno",     sNull)
		this.setitem(1, "sdate",    sNull)
		this.setitem(1, "dept",     sNull)
		this.setitem(1, "deptname", sNull)
		this.setitem(1, "empno", 	 sNull)
		this.setitem(1, "empnm",    sNull)
		this.setitem(1, "empno2", 	 sNull)
		this.setitem(1, "empnm2",    sNull)
		this.setitem(1, "gubun",    sNull)
		this.setitem(1, "house",    sNull)
		this.setitem(1, "check",    sNull)
		this.setitem(1, "project",  sNull)
		this.setitem(1, "cvcod",    sNull)
		this.setitem(1, "cvnas",    sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "jpno",     sNull)
			this.setitem(1, "sdate",    sNull)
			this.setitem(1, "dept",     sNull)
			this.setitem(1, "deptname", sNull)
			this.setitem(1, "empno", 	 sNull)
			this.setitem(1, "empnm",    sNull)
			this.setitem(1, "empno2", 	 sNull)
			this.setitem(1, "empnm2",    sNull)
			this.setitem(1, "gubun",    sNull)
			this.setitem(1, "house",    sNull)
			this.setitem(1, "check",    sNull)
			this.setitem(1, "project",  sNull)
			this.setitem(1, "cvcod",    sNull)
			this.setitem(1, "cvnas",    sNull)
			return 1
      END IF		
	END IF

	this.setitem(1, "sdate",    sDate)	
	this.setitem(1, "empno2", 	 sEmpno2)	
	this.setitem(1, "empnm2",   sempnm2)	
	this.setitem(1, "gubun",    sGubun)	
	this.setitem(1, "house",    sHouse)		
	this.setitem(1, "dept", 	 sDept)	
	this.setitem(1, "deptname", sName)	
	this.setitem(1, "empno", 	 sEmpno)	
	this.setitem(1, "empnm",    sempnm)	
	this.setitem(1, "project",  sProject)		
	this.setitem(1, "check",    sCheck)		
	this.setitem(1, "cvcod",    scvcod)
	this.setitem(1, "cvnas",    scvnas)
	
	select tagbn into :sTagbn from iomatrix where sabu = :gs_sabu and iogbn = :sGubun; 

	IF sTagbn = 'Y' then
		ic_yn = 'Y'
		MessageBox("Ȯ ��", "Ÿ���� ��ü�� ����Ƿڿ��� ��밡���մϴ�.", StopSign!)
		return 1
	ELSE
		ic_yn = 'N'
	END IF
ELSEIF this.getcolumnname() = "project"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
	SELECT "VW_PROJECT"."SABU"  
     INTO :sCode
     FROM "VW_PROJECT"  
    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
          ( "VW_PROJECT"."PJTNO" = :sProject )   ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[������Ʈ ��ȣ]')
		this.setitem(1, "project", sNull)
	   return 1
	END IF
	
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// �μ�
IF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",gs_code)
	SetItem(1,"deptname",gs_codename)

elseIF this.GetColumnName() = "empno" THEN
   
	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
   this.triggerEvent(itemchanged!)	
elseIF this.GetColumnName() = 'empno2'	THEN
	this.accepttext() 
   gs_gubun = '4' 
	gs_code = this.getitemstring(1, 'house')
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno2",gs_code)
	SetItem(1,"empnm2",gs_codename)
ELSEIF this.GetColumnName() = 'cvcod'	THEN

	string	sCheck, sgubun
	sgubun = dw_detail.getitemstring(1, "gubun")

	if sgubun = '' or isnull(sgubun) then 
		messagebox("Ȯ ��", "���ұ����� ���� �Է��ϼ���!")
		this.setcolumn('gubun')
		this.setfocus()
		return 1
	end if

	/* ����ó ���� �˻� */
	SELECT RELCOD INTO :SCHECK FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sgubun;
	    
	/* ����ó�ڵ� ���п� ���� �ŷ�ó������ setting */
	Choose case scheck
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
					open(w_vndmst_popup)
	End choose

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	SetItem(1,"cvcod",gs_code)
	this.TriggerEvent("itemchanged")
elseif this.getcolumnname() = "jpno" 	then
	gs_gubun = 'O05'
	open(w_chulgo_popup4)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
elseif this.getcolumnname() = "project" 	then
	gs_gubun = '1'
	open(w_project_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "project", gs_code)
end if


end event

