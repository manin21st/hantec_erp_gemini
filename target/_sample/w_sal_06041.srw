$PBExportHeader$w_sal_06041.srw
$PBExportComments$����â�� �̵����
forward
global type w_sal_06041 from w_inherite
end type
type dw_hidden from datawindow within w_sal_06041
end type
type dw_imhist from datawindow within w_sal_06041
end type
type dw_imhist_in from datawindow within w_sal_06041
end type
type dw_print from datawindow within w_sal_06041
end type
type dw_prt from datawindow within w_sal_06041
end type
type cbx_2 from checkbox within w_sal_06041
end type
type cbx_1 from checkbox within w_sal_06041
end type
type rb_delete from radiobutton within w_sal_06041
end type
type rb_insert from radiobutton within w_sal_06041
end type
type p_1 from uo_picture within w_sal_06041
end type
type p_3 from picture within w_sal_06041
end type
type cb_1 from commandbutton within w_sal_06041
end type
type cb_2 from commandbutton within w_sal_06041
end type
type cb_3 from commandbutton within w_sal_06041
end type
type gb_2 from groupbox within w_sal_06041
end type
end forward

global type w_sal_06041 from w_inherite
integer width = 4878
integer height = 2732
string title = "�����̵����(����-�����)"
dw_hidden dw_hidden
dw_imhist dw_imhist
dw_imhist_in dw_imhist_in
dw_print dw_print
dw_prt dw_prt
cbx_2 cbx_2
cbx_1 cbx_1
rb_delete rb_delete
rb_insert rb_insert
p_1 p_1
p_3 p_3
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
gb_2 gb_2
end type
global w_sal_06041 w_sal_06041

type variables
boolean ib_ItemError
char ic_status,   ic_yn    //Ÿ���� ��뿩��(Y:���)
string is_Last_Jpno, is_Date
datawindowchild dws, dws1
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_dup_chk ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_create_saupj (ref string arg_sjpno)
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
public function integer wf_item (string sitem, string sspec, long lrow)
public function integer wf_saupj_chk ()
end prototypes

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. ���� = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sLotgub, sLotNo
dec		dQty
long		lRow, lCount

lCount = dw_insert.RowCount()

FOR	lRow = 1		TO		lCount

	// ǰ��
	sItem = dw_insert.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[ǰ��]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("itnbr")
		dw_insert.setfocus()
		RETURN -1
	END IF
	
	// ����û����	
	dQty = dw_insert.getitemdecimal(lrow, "outqty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[������]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("outqty")
		dw_insert.setfocus()
		RETURN -1
	END IF

	// LOT ���� üũ
   sLotgub = Trim(dw_insert.GetitemString(lRow, "lotgub"))
	sLotNo  = Trim(dw_insert.GetitemString(lRow, "lotsno"))
	If IsNull(sLotgub) Or sLotgub = '' Then sLotgub  = 'N'

	If sLotgub = 'Y' And (IsNull(sLotNo) Or sLotNo = '' ) Then
		f_message_chk(30,'[LOT NO]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("lotsno")
		dw_insert.setfocus()
		RETURN -1
	End If
	/////////////////////////////////////////////////////////////////////////
	//	1. ������ -> ���߰��� data�� �Ƿڹ�ȣ : �������� + 1 ->SETITEM
	// 2. ��ǥ��ȣ�� NULL �ΰ͸� �������� + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_insert.GetitemString(lRow, "imhist_iojpno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_insert.SetItem(lRow, "imhist_iojpno", is_Last_Jpno)
		END IF
	END IF

NEXT

RETURN 1
end function

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind
//
//FOR k = dw_insert.rowcount() TO 1 step - 1
//   sfind = dw_insert.getitemstring(k, 'sfind')
//
//	lReturnRow = dw_insert.Find("sfind = '"+sfind+"' ", 1, dw_insert.RowCount())
//	
//	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
//		f_message_chk(37,'[ǰ��/���]')
//		dw_insert.Setrow(k)
//		dw_insert.Setcolumn('pspec')
//		dw_insert.setfocus()
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

dw_input.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_input.GetItemString(1, "gubun")		// ���ұ���

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

sDate = dw_input.GetItemString(1, "sdate")				// �������
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_input.GetItemString(1, "house")   //â��
sEmpno2 = dw_input.GetItemString(1, "empno2")  //�������
sEmpno  = dw_input.GetItemString(1, "empno")   //�Ƿ���
sDept   = dw_input.GetItemString(1, "dept")    //�Ƿںμ�
sCvcod  = dw_input.GetItemString(1, "cvcod")   //�԰�ó
sProject = dw_input.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_insert.RowCount()

	dOutQty = dw_insert.GetItemDecimal(lRow, "outqty")

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
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // ǰ��

		sPspec = trim(dw_insert.GetItemString(lRow, "pspec"))
		if sPspec = '' or isnull(sPspec) then sPspec = '.'
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // ���
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// ����â��=���â��
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// �ŷ�óâ��=�԰�ó
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=������
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// �˻�����=�������	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// �����ڵ�
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// ���ҽ�������=�������	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// ���ҽ�����=�����	
		dw_imhist.SetItem(lRowHist, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // ����������
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
		dw_imhist.SetItem(lRowHist, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// ��������
      
		//�����  �߰�
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// �����Ƿںμ�=�Ҵ�.�μ�
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// ��������� ��� '99999999' ����
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))

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
//				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "ditnbr")) // ǰ��
//				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_insert.GetItemString(lRow, "dpspec")) // ���
//			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "itnbr")) // ǰ��
				dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // ���
//			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// ����â��=�԰�ó
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // �԰� â���� �ΰ� ����� ������
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// �ŷ�óâ��=���â��
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// �����ڵ�
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // ����������
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))
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
			sItnbr  = dw_insert.GetItemString(lRow, "itnbr")
			sStock  = dw_insert.GetItemString(lRow, "itemas_filsk") // ����������
			sGrpno = dw_insert.GetItemString(lRow, "grpno2")

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
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_insert.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=�԰����
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// ���ҽ��ο���
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// ���ҽ��ο���

			End If
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// ���������
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// ��������

//			dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_insert.GetItemString(lRow, "holdstock_req_dept"))		// �����Ƿںμ�=�Ҵ�.�μ�
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // �԰���ǥ��ȣ=����ȣ
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",    dw_insert.GetItemString(lRow, "cust_no"))
		END IF
	END IF
NEXT

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_create_saupj (ref string arg_sjpno);///////////////////////////////////////////////////////////////////////
//
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '001'
// 4. ��/��� â���� ������� �ٸ���� �԰� ���� ó�� �� ��/��� ��� ���� ó��
// 5. ��� â�� ��� ������ �԰� ���� ������ ����
///////////////////////////////////////////////////////////////////////

string	sJpno, sIOgubun,	sDate, sTagbn, sEmpno2, sDept, &
         sHouse, sEmpno, sRcvcod, sSaleyn, snull, sQcgub, sPspec, sCvcod, sProject, sSaupj, sInsQc, sItnbr, scustom, sOutSaupj
long		lRow, lRowHist, lRowHist_In
dec		dSeq, dOutQty,	dInSeq
String   sStock, sGrpno, sGubun

dw_input.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_input.GetItemString(1, "gubun")		// ���ұ���

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

sDate = dw_input.GetItemString(1, "sdate")				// �������
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno   = sDate + string(dSeq, "0000")
sHouse  = dw_input.GetItemString(1, "house")   //â��
sEmpno2 = dw_input.GetItemString(1, "empno2")  //�������
sEmpno  = dw_input.GetItemString(1, "empno")   //�Ƿ���
sDept   = dw_input.GetItemString(1, "dept")    //�Ƿںμ�
sCvcod  = dw_input.GetItemString(1, "cvcod")   //�԰�ó
sProject = dw_input.GetItemString(1, "project")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

FOR	lRow = 1		TO		dw_insert.RowCount()

	dOutQty = dw_insert.GetItemDecimal(lRow, "outqty")

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
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // ǰ��

		sPspec = trim(dw_insert.GetItemString(lRow, "pspec"))
		if sPspec = '' or isnull(sPspec) then sPspec = '.'
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec) // ���
		
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// ����â��=���â��
		dw_imhist.SetItem(lRowHist, "cvcod",	sCvcod) 			// �ŷ�óâ��=�԰�ó
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// �����ڵ�		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// �˻�����=�������	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������	
		
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=������	
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// ���ҽ�������=�������	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno2)			// ���ҽ�����=�����
		
		
		dw_imhist.SetItem(lRowHist, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // ����������
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
		dw_imhist.SetItem(lRowHist, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// ��������
      
		//�����  �߰�
		dw_imHist.SetItem(lRowHist, "ioredept",sDept)	   	// �����Ƿںμ�=�Ҵ�.�μ�
		dw_imHist.SetItem(lRowHist, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
		dw_imHist.SetItem(lRowHist, "gurdat",	'99999999')  	// ��������� ��� '99999999' ����
		
		dw_imHist.SetItem(lRowHist, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))

		dw_imHist.SetItem(lRowHist, "pjt_cd",	  sProject)
		//dw_imHist.SetItem(lRowHist, "saupj",	  gs_saupj)
		SELECT IPJOGUN
		   INTO :sOutSaupj
		  FROM VNDMST
		WHERE CVGU = '5'
		    AND CVSTATUS = '0'
		    AND CVCOD = :sHouse; /*���â���� �ΰ�������� ���������� ���� 2023.08.09 by dykim*/
		
		dw_imHist.SetItem(lRowHist, "saupj", sOutSaupj)
		
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
//				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "ditnbr")) // ǰ��
//				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_insert.GetItemString(lRow, "dpspec")) // ���
//			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_insert.GetItemString(lRow, "itnbr")) // ǰ��
				dw_imHist_in.SetItem(lRowHist_in, "pspec", spspec) // ���
//			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",sCvcod)   	// ����â��=�԰�ó
			
			select ipjogun into :sSaupj
			  from vndmst where cvcod = :sCvcod;  // �԰� â���� �ΰ� ����� ������
			
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// �ŷ�óâ��=���â��
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	'9999')			// �����ڵ�
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �����Ƿڼ���=������		

			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// �հݼ���=������		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_insert.GetItemString(lRow, "itemas_filsk")) // ����������
			
			dw_imHist_in.SetItem(lRowHist_in, "pjt_cd",	sProject)
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",	dw_insert.GetItemString(lRow, "lotsno"))
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
			sItnbr  = dw_insert.GetItemString(lRow, "itnbr")
			sStock  = dw_insert.GetItemString(lRow, "itemas_filsk") // ����������
			sGrpno = dw_insert.GetItemString(lRow, "grpno2")

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
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_insert.GetItemDecimal(lRow, "outqty")) 	// ���Ҽ���=�԰����
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			// ���ҽ��ο���
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", 'N')			// ���ҽ��ο���

			End If
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// ���������
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// ��������

//			dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_insert.GetItemString(lRow, "holdstock_req_dept"))		// �����Ƿںμ�=�Ҵ�.�μ�
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))  // �԰���ǥ��ȣ=����ȣ
			
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",    dw_insert.GetItemString(lRow, "cust_no"))
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
string	sHist_Jpno, sIodate, sDelgub, syebi5, sItnbr, sField_cd
long		lRow, lRowCount, lCnt, i, k

lRowCount = dw_insert.RowCount()

FOR lrow = 1 TO lRowCount
	 sHist_Jpno = dw_insert.GetItemString(lrow, "imhist_iojpno")
	 sIoDate    = dw_insert.GetItemString(lrow, "cndate")
	 sDelgub    = dw_insert.GetItemString(lrow, "opt")
	 sItnbr     = dw_insert.GetItemString(lrow, "itnbr")
	 sField_cd  = dw_insert.GetItemString(lrow, "field_cd")

   if sDelgub = 'N' then continue
	
	select COUNT('X')
	  into :lCnt
	  from imhist
	 where iogbn = 'O05'
	   and depot_no = 'ZZZ'
	   and field_cd = :sField_cd
	   and itnbr = :sItnbr;
	
	if lCnt > 0 then
		MessageBox("����", "'" + sField_cd + "' P/I�� '" + sItnbr + "' ǰ�� �� ���ⱹ���� ���� �̷��� �ֽ��ϴ�.")
		RETURN -1
	end if

	k ++	
	
	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
	if not isnull(dw_insert.GetItemString(lRow, "cndate")) AND &
	   dw_insert.GetItemString(lRow, "i_confirm") = 'N' then continue

	if not isnull(dw_insert.GetItemString(lRow, "yebi5")) then continue
		
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

lcount = dw_insert.RowCount()

FOR	lRow = 1		TO	lcount

   k++
	
	dOutQty      = dw_insert.GetItemDecimal(lRow, "outqty")			// ������(�����history)
	dTemp_OutQty = dw_insert.GetItemDecimal(lRow, "temp_outqty")	// ������(�����history)
	sHist_Jpno   = dw_insert.GetItemString(lRow, "imhist_iojpno")
	sGubun		 = dw_insert.GetItemString(lRow, "imhist_outchk")
	
	siodate = dw_insert.GetItemString(lRow, "cndate")
	sioyn   = dw_insert.GetItemString(lRow, "i_confirm")
	
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

public function integer wf_initial ();string sCvnas

dw_input.setredraw(false)
dw_input.reset()
dw_insert.reset()

//cb_save.enabled = false
p_del.enabled = false
p_del.PictureName = 'c:\erpman\image\����_d.gif'

dw_input.enabled = TRUE

dw_input.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then
	// ��Ͻ�
	dw_input.settaborder("jpno",   0)
	dw_input.settaborder("sdate",  10)
	dw_input.settaborder("HOUSE",  20)
	dw_input.settaborder("PROJECT",30)
	dw_input.settaborder("empno2", 40)
	dw_input.settaborder("empno",  50)
	dw_input.settaborder("GUBUN",  60)
	dw_input.settaborder("cvcod",  70)

	dw_input.Modify("t_dsp_no.visible = 0")
	
	dw_input.Modify("t_dsp_date.visible = 1")
	dw_input.Modify("t_dsp_chang.visible = 1")
	dw_input.Modify("t_dsp_gbn.visible = 1")
	dw_input.Modify("t_dsp_demp.visible = 1")
	dw_input.Modify("t_dsp_emp.visible = 1")
	dw_input.Modify("t_dsp_cust.visible = 1")

	dw_input.setcolumn("HOUSE")
	dw_input.SetItem(1, "sdate", is_Date)
	if dws.rowcount() > 0 then
		dw_input.setitem(1, "gubun",  dws.getitemstring(1, "iogbn"))
		dw_input.SetItem(1, "check", dws.getitemstring(1, "naougu"))
	end if

	p_inq.enabled = false
	p_inq.PictureName = 'c:\erpman\image\��ȸ_d.gif'
	
	p_addrow.enabled = true
	p_addrow.PictureName = 'c:\erpman\image\���߰�_up.gif'
	
	p_delrow.enabled = true
	p_delrow.PictureName = 'c:\erpman\image\�����_up.gif'
	
	p_3.enabled = false
	p_3.PictureName = 'c:\erpman\image\�μ�_d.gif'
	
	w_mdi_frame.sle_msg.text = "���"

ELSE
	dw_input.settaborder("jpno",   10)
	dw_input.settaborder("GUBUN",  0)
	dw_input.settaborder("sDATE",  0)
	dw_input.settaborder("PROJECT",0)
	dw_input.settaborder("HOUSE",  0)
	dw_input.settaborder("empno",   0)
	dw_input.settaborder("empno2",   0)
	dw_input.settaborder("cvcod",   0)

   dw_input.Modify("t_dsp_no.visible = 1")
	
	dw_input.Modify("t_dsp_date.visible = 0")
	dw_input.Modify("t_dsp_chang.visible = 0")
	dw_input.Modify("t_dsp_gbn.visible = 0")
	dw_input.Modify("t_dsp_demp.visible = 0")
	dw_input.Modify("t_dsp_emp.visible = 0")
	dw_input.Modify("t_dsp_cust.visible = 0")

	dw_input.setcolumn("JPNO")

	p_inq.enabled = true
	p_inq.PictureName = 'c:\erpman\image\��ȸ_up.gif'
	
	p_addrow.enabled = false
	p_addrow.PictureName = 'c:\erpman\image\���߰�_d.gif'
	
	p_delrow.enabled = false
	p_delrow.PictureName = 'c:\erpman\image\�����_d.gif'
	
	w_mdi_frame.sle_msg.text = "����"
	
	p_3.enabled = true
	p_3.PictureName = 'c:\erpman\image\�μ�_up.gif'
	
END IF

dw_input.setfocus()

f_mod_saupj(dw_input, 'saupj')

//���â�� 
String  ls_saupj
ls_saupj = dw_input.GetItemString(1, 'saupj')
f_child_saupj(dw_input, 'house', '%')
f_child_saupj(dw_input, 'cvcod', '%')

dw_input.SetItem(1, "gubun", 'O05')
p_print.Visible = False
cbx_1.Visible = False
cbx_2.Visible = False

select cvnas into :sCvnas from vndmst 
 where cvcod = 'ZZZ';

ic_yn = 'N'

dw_input.setitem(1, "cvcod", 'ZZZ')
dw_input.setitem(1, 'cvnas', sCvnas)	

dw_input.setredraw(true)

return  1

end function

public function integer wf_item (string sitem, string sspec, long lrow);String  sname, sitgu, snull, sispec, sfilsk, sdepot, sjijil, sSpec_code, slotgub, sGrpno2
Decimal {3} dJegoqty, dvalidqty, dqty

Setnull(sNull)

IF sspec = '' OR ISNULL(sspec) then sspec = '.'

sdepot = dw_input.getitemstring(1, 'house')

SELECT A.ITDSC, A.ISPEC, A.ITGU, A.FILSK, A.JIJIL, A.ISPEC_CODE, A.LOTGUB, B.GRPNO2
  INTO :sName, :sIspec, :sItgu, :sFilsk, :sjijil, :sspec_code, :sLotgub, :sGrpno2
  FROM ITEMAS A, ITEMAS_INSPECTION B
 WHERE A.ITNBR = B.ITNBR AND A.ITNBR = :sItem 	AND	 A.USEYN = '0'  ;                   
 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[ǰ��]')
	dw_insert.setitem(lRow, "itnbr", sNull)	
	dw_insert.SetItem(lRow, "itdsc", sNull)
	dw_insert.SetItem(lRow, "ispec", sNull)
	dw_insert.SetItem(lRow, "jijil", sNull)
	dw_insert.SetItem(lRow, "ispec_code", sNull)
	dw_insert.SetItem(lRow, "itemas_filsk", sNull)
	dw_insert.SetItem(lRow, "itemas_itgu",  sNull)
	dw_insert.SetItem(lRow, "lotgub",  sNull)
	dw_insert.SetItem(lRow, "grpno2",  sNull)
	dw_insert.setitem(lrow, "jego_qty", 0)
	dw_insert.setitem(lrow, "valid_qty", 0)
	dw_insert.setitem(lrow, "jego_temp", 0)
	RETURN 1
END IF

dw_insert.SetItem(lRow, "itdsc", sName)
dw_insert.SetItem(lRow, "ispec", sIspec)
dw_insert.SetItem(lRow, "jijil", sjijil)
dw_insert.SetItem(lRow, "ispec_code", sspec_code)
dw_insert.SetItem(lRow, "itemas_itgu",  sitgu)
dw_insert.SetItem(lRow, "itemas_filsk", sfilsk)
dw_insert.SetItem(lRow, "lotgub", sLotgub)
dw_insert.SetItem(lRow, "grpno2", sGrpno2)

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

dw_insert.setitem(lrow, "jego_qty", dJegoqty)
dw_insert.setitem(lrow, "valid_qty", dvalidqty)
dw_insert.setitem(lrow, "jego_temp", dqty)
 	
return 0
end function

public function integer wf_saupj_chk ();dw_input.AcceptText()

String  ls_chl
ls_chl = dw_input.GetItemString(1, 'house')
If Trim(ls_chl) = '' OR IsNull(ls_chl) Then
	MessageBox('Ȯ��', '���â�� ���� �Ͻʽÿ�')
	Return -1
End If

/* ���â�� ����� Ȯ�� */
String  ls_csaupj
SELECT IPJOGUN
  INTO :ls_csaupj
  FROM VNDMST
 WHERE CVGU = '5' AND CVCOD = :ls_chl ;
If Trim(ls_csaupj) = '' Or IsNull(ls_csaupj) Then
	MessageBox('Ȯ��', '���â���� ������ ����� ������ �� �� �����ϴ�.~r~n�����ڿ��� ���� �ٶ��ϴ�.')
	Return -1
End If

String  ls_ip
ls_ip = dw_input.GetItemString(1, 'cvcod')
If Trim(ls_ip) = '' OR IsNull(ls_ip) Then
	MessageBox('Ȯ��', '�԰�ó�� ���� �Ͻʽÿ�')
	Return -1
End If

/* �԰�â�� ����� Ȯ�� */
String  ls_isaupj
SELECT IPJOGUN
  INTO :ls_isaupj
  FROM VNDMST
 WHERE CVGU = '5' AND CVCOD = :ls_ip ;
If Trim(ls_isaupj) = '' Or IsNull(ls_isaupj) Then
	ls_isaupj = ls_csaupj /* ������(���������)���� �ŷ�ó�� ���ó�� �ϴ� ��찡 ����. - by shingoon 2015/12/31 */
//	MessageBox('Ȯ��', '�԰�â���� ������ ����� ������ �� �� �����ϴ�.~r~n�����ڿ��� ���� �ٶ��ϴ�.')
//	Return -1
End If

/* ����� �� */
If ls_csaupj <> ls_isaupj Then
	/* ������� �ٸ���� */
	Return 1
Else
	/* ���� ������� ��� */
	Return 0
End If



end function

event open;call super::open;// datawindow initial value
dw_input.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_input.getchild("gubun", dws)
dws.settransobject(sqlca)
dws.retrieve(gs_sabu, '001')

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")

string sNull, sRelcod, sNaougu, sTagbn, sCvnas
SetNull(sNull)
dw_input.SetItem(1, "gubun", 'O05')
p_print.Visible = False
cbx_1.Visible = False
cbx_2.Visible = False

// ��û���п� ���� ����ó�ڵ�
Setnull(sRelcod)
Setnull(sNaougu)
select relcod, naougu, tagbn into :sRelcod, :sNaougu, :sTagbn from iomatrix 
 where sabu = '1' and iogbn = 'O05';

select cvnas into :sCvnas from vndmst 
 where cvcod = 'ZZZ';

ic_yn = 'N'

dw_input.setitem(1, "cvcod", 'ZZZ')
dw_input.setitem(1, 'cvnas', sCvnas)	

dw_input.setitem(1, "check", sNaougu)
end event

on w_sal_06041.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
this.dw_imhist=create dw_imhist
this.dw_imhist_in=create dw_imhist_in
this.dw_print=create dw_print
this.dw_prt=create dw_prt
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.p_1=create p_1
this.p_3=create p_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
this.Control[iCurrent+2]=this.dw_imhist
this.Control[iCurrent+3]=this.dw_imhist_in
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_prt
this.Control[iCurrent+6]=this.cbx_2
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.rb_delete
this.Control[iCurrent+9]=this.rb_insert
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.p_3
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.cb_3
this.Control[iCurrent+15]=this.gb_2
end on

on w_sal_06041.destroy
call super::destroy
destroy(this.dw_hidden)
destroy(this.dw_imhist)
destroy(this.dw_imhist_in)
destroy(this.dw_print)
destroy(this.dw_prt)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.p_1)
destroy(this.p_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)

end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)

end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)

end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)

end event

event ue_print;call super::ue_print;p_3.TriggerEvent(Clicked!)

end event

event activate;gw_window = this

if gs_lang = "CH" then   //// �߹��� ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("��ʥ(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�(&D)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&S)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", false) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", false) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&P)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", true) //// �̸����� 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�?(&G)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", false)  //// PDF��ȯ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", false) //// ����
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", false) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", false) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", true) //// �̸�����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", false)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", false)
end if

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = true  //// ����
m_main2.m_window.m_save.enabled = true //// ����
m_main2.m_window.m_cancel.enabled = true //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = false  //// ã��
m_main2.m_window.m_filter.enabled = false //// ����
m_main2.m_window.m_excel.enabled = false //// �����ٿ�
m_main2.m_window.m_print.enabled = true  //// ���
m_main2.m_window.m_preview.enabled = true //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_06041
end type

type sle_msg from w_inherite`sle_msg within w_sal_06041
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06041
end type

type st_1 from w_inherite`st_1 within w_sal_06041
end type

type p_search from w_inherite`p_search within w_sal_06041
integer y = 260
end type

type p_addrow from w_inherite`p_addrow within w_sal_06041
integer x = 3383
end type

event p_addrow::clicked;call super::clicked;IF dw_input.AcceptText() = -1	THEN	RETURN

//////////////////////////////////////////////////////////
string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
         sRelcod, sNaougu, scvcod 
long		lRow

sDate    = TRIM(dw_input.GetItemString(1, "sdate"))
sHouse   = dw_input.GetItemString(1, "house")
sProject = dw_input.GetItemString(1, "project")
sEmpno2  = dw_input.GetItemString(1, "empno2")
sEmpno   = dw_input.GetItemString(1, "empno")
sDept 	= dw_input.GetItemString(1, "dept")
sGubun 	= dw_input.GetItemString(1, "gubun")
sCheck   = dw_input.GetItemString(1, "check")
scvcod   = dw_input.GetItemString(1, "cvcod")

// �����
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[�������]')
	dw_input.SetColumn("sdate")
	dw_input.SetFocus()
	RETURN
END IF

// ���â��
IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[���â��]')
	dw_input.SetColumn("house")
	dw_input.SetFocus()
	RETURN
END IF

IF isnull(sempno2) or sempno2 = "" 	THEN
	f_message_chk(30,'[�������]')
	dw_input.SetColumn("empno2")
	dw_input.SetFocus()
	RETURN
END IF

// ��û��
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[��û��]')
	dw_input.SetColumn("empno")
	dw_input.SetFocus()
	RETURN
END IF
// ��û�μ�
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[��û�μ�]')
	dw_input.SetColumn("dept")
	dw_input.SetFocus()
	RETURN
END IF
// ���ұ���
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[���ұ���]')
	dw_input.SetColumn("gubun")
	dw_input.SetFocus()
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
	dw_input.SetColumn("gubun")
	dw_input.SetFocus()
	RETURN
end if 
if isnull(sRelcod) or trim(sRelcod) = '' then
	f_message_chk(208,'[�԰�ó]')
	dw_input.SetColumn("gubun")
	dw_input.SetFocus()
	RETURN
end if

// �԰�ó
IF isnull(scvcod) or scvcod = "" 	THEN
	f_message_chk(30,'[�԰�ó]')
	dw_input.SetColumn("cvcod")
	dw_input.SetFocus()
	RETURN
END IF

IF gs_saupj = '%' THEN
	gs_code = '10'
ELSE
	gs_code = gs_saupj
END IF

open(w_exppid_popup_agent)

string  s_cino,s_pino,s_itnbr,s_itdsc,s_ispec,s_order_spec, sPono, sOrderNo, sJijil, sIspecCode
double  d_piqty,d_piamt,d_piprc,d_ioqty,d_itmprc,d_itmamt,d_jqty
long    nrow,RowCnt,itemp,ix,l_piseq,l_ciseq,ll_found
int     rtn

datastore ds_multi
ds_multi = Create Datastore

/* P/I�������� �о�� ��� : ClipBoard�� ������ copy�Ѵ� */
ds_multi.DataObject = 'd_exppid_popup_agent'
rtn = ds_multi.ImportClipBoard()

/* key check */
If rtn <=0 Then 
	f_message_chk(50,'')
	Return 0
End If

rowcnt = dw_insert.RowCount()

For ix = 1 To rtn
	s_pino   = ds_multi.GetItemString(ix,"pino")
	l_piseq  = ds_multi.GetItemNumber(ix,"piseq")
	s_itnbr  = ds_multi.GetItemString(ix,"itnbr")
	s_itdsc  = ds_multi.GetItemString(ix,"itdsc")
	s_ispec  = ds_multi.GetItemString(ix,"ispec")
	sJijil   = ds_multi.GetItemString(ix,"jijil")
	sispecCode  = ds_multi.GetItemString(ix,"ispec_code")
	s_order_spec = ds_multi.GetItemString(ix,"order_spec")
	
	select sum(ioqty)
	  into :d_ioqty
	  from imhist
	 where iogbn = 'O05'
	   and cvcod = 'ZZZ'
	   and field_cd = :s_pino
	   and itnbr = :s_itnbr;
	
	if isNull(d_ioqty) then d_ioqty = 0
	
	d_piqty  = ds_multi.GetItemNumber(ix,"piqty") - d_ioqty
	
	if d_piqty <= 0 then
		MessageBox('Ȯ��', '�ش� P/I ������ ��� ��� �Ϸ� �Ǿ����ϴ�.')
		Return 0
	end if
	d_piprc  = ds_multi.GetItemNumber(ix,"piprc")
	d_piamt  = ds_multi.GetItemNumber(ix,"piamt")
	d_itmprc = ds_multi.GetItemNumber(ix,"itmprc")
	d_itmamt = ds_multi.GetItemNumber(ix,"itmamt")

	sPono  	= ds_multi.GetItemString(ix,"pono")
	
//	
//	ll_found = tab_1.tabpage_2.dw_insert_2.Find("pino = '" + s_pino + "' and piseq = " + string(l_piseq),1,tab_1.tabpage_2.dw_insert_2.RowCount())	
//	If ll_found > 0 Then Continue
	
	nRow = dw_insert.InsertRow(0)
	dw_insert.SetItem(nRow, 'itnbr', s_itnbr)
	wf_item(s_itnbr, '.', nRow)
	d_jqty = dw_insert.GetItemNumber(nRow, "jego_qty")
	if isNull(d_jqty) then d_jqty = 0
	dw_insert.SetItem(nRow, 'field_cd', s_pino)
	if d_piqty <= d_jqty then
		dw_insert.SetItem(nRow, 'outqty', d_piqty)
	elseif d_jqty >= 0 then
		dw_insert.SetItem(nRow, 'outqty', d_jqty)
	else
		dw_insert.SetItem(nRow, 'outqty', 0)
	end if
Next
end event

type p_delrow from w_inherite`p_delrow within w_sal_06041
integer x = 3557
end type

event p_delrow::clicked;call super::clicked;
long	lrow
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N' �� �ƴ� ���)*/
if not isnull(dw_insert.GetItemString(lRow, "cndate")) AND &
	dw_insert.GetItemString(lRow, "i_confirm") <> 'N' then 
	messagebox("Ȯ ��", "�԰��ڷᰡ ����ó�� �Ǿ� �����Ƿ� ���� �� �� �����ϴ�." + &
							  '~n' + "�԰� �ڷḦ Ȯ���ϼ���!")
	return 
end if	

/* ������ȣ�� ����� ��� ���� �Ұ� */
if not isnull(dw_insert.GetItemString(lRow, "yebi5"))  then 
	messagebox("Ȯ ��", "����峻���� ��ϵǾ��ֽ��ϴ�" + &
							  '~n' + "����� �ڷḦ Ȯ���ϼ���!")
	return 
end if	

// �ڷᰡ ������ HEAD������ ������ �� ����
dw_insert.DeleteRow(lRow)

if dw_insert.rowcount() < 1 then
	dw_input.enabled = true
end if


end event

type p_mod from w_inherite`p_mod within w_sal_06041
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_input.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1		THEN	RETURN

string	sArg_sdate, sJpno

//dw_input.GetItemString(1, "sdate")
//dw_input.GetItemString(1, "house")
//dw_input.GetItemString(1, "gubun")
//dw_input.GetItemString(1, "cvcod")

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
	Integer li_rtn
	li_rtn =  wf_saupj_chk()
	Choose Case li_rtn
		Case 0
			/* ��/���â���� ������� ���� ��� */
			IF wf_imhist_create(sArg_sdate) = -1 THEN
				ROLLBACK;
				RETURN
			END IF
		Case 1
			/* ��/���â���� ������� �ٸ� ��� */
			IF wf_imhist_create_saupj(sArg_sdate) = -1 THEN
				ROLLBACK;
				RETURN
			END IF
		Case Else
			/* ���� */
			Return
	End Choose

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
	ElseIf cbx_2.Checked Then
		dw_prt.retrieve(gs_sabu, sArg_sdate)
		dw_prt.print()
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
								 
p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_del from w_inherite`p_del within w_sal_06041
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN

SetPointer(HourGlass!)

IF wf_Imhist_Delete() = -1		THEN	
	rollback;
	RETURN
end if

COMMIT;

p_can.TriggerEvent("clicked")
	
	

end event

type p_inq from w_inherite`p_inq within w_sal_06041
integer x = 3749
boolean enabled = false
string picturename = "C:\erpman\image\��ȸ_d.gif"
end type

event p_inq::clicked;call super::clicked;
if dw_input.Accepttext() = -1	then 	return

string  	sJpno,		&
			sDate,		&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

sJpno   	= dw_input.getitemstring(1, "jpno")

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[����ȣ]')
	dw_input.SetColumn("jpno")
	dw_input.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_insert.Retrieve(gs_sabu, sjpno) <	1		THEN
	messagebox("Ȯ��","�ش��ڷᰡ �����ϴ�.")
	dw_input.setcolumn("jpno")
	dw_input.setfocus()
	return
end if

is_Last_Jpno = dw_insert.GetItemString(dw_insert.RowCount(), "imhist_iojpno")

dw_input.enabled = false

p_del.enabled = true
p_del.PictureName = 'c:\erpman\image\����_up.gif'

dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()
//cb_save.enabled = true
end event

type p_print from w_inherite`p_print within w_sal_06041
integer x = 3195
integer y = 252
boolean enabled = false
end type

type p_can from w_inherite`p_can within w_sal_06041
end type

event p_can::clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_exit from w_inherite`p_exit within w_sal_06041
end type

type p_ins from w_inherite`p_ins within w_sal_06041
integer y = 260
boolean enabled = false
end type

type p_new from w_inherite`p_new within w_sal_06041
end type

type dw_input from w_inherite`dw_input within w_sal_06041
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 56
integer width = 4742
integer height = 312
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06041"
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
string   scode, sname1, get_dept, get_deptnm, sname2, sEmpno2, sEmpnm2, scvcod, scvnas, sIpjogun
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
		AND	A.DEPOT_NO = :sHouse
		AND   A.REPRE = 'Y'; /* ��ǥ ����ڰ� ���õǵ��� ���� - 2024.04.02 by dykim */
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
		dw_input.SetColumn("gubun")
		dw_input.SetFocus()
		RETURN 1
	end if 
	if isnull(sRelcod) or trim(sRelcod) = '' then
		f_message_chk(208,'[�԰�ó]')
		dw_input.SetColumn("gubun")
		dw_input.SetFocus()
		RETURN 1
	end if	
	
	this.setitem(1, "check", sNaougu)

ELSEIF this.GetColumnName() = "cvcod" THEN
   
	string	sChk, sgbn1, sgbn2, sgbn3, sgbn4, sgbn5 

	sgubun = dw_input.getitemstring(1, "gubun")
	
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

	SELECT "CVNAS2", NVL("IPJOGUN", '10')
	  INTO :sName, :sIpjogun
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
		This.SetItem(1, 'saupj', sIpjogun)
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
				A.CVCOD = 'ZZZ' AND
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
	p_inq.TriggerEvent(Clicked!)
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

ElseIf This.GetColumnName() = 'saupj' Then
	//���â�� 
	String  ls_saupj
	ls_saupj = Trim(This.GetText())
	f_child_saupj(This, 'house', ls_saupj)
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
	sgubun = dw_input.getitemstring(1, "gubun")

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
	gs_gubun = '001'
	open(w_chulgo_popup3_ht1)
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

type cb_delrow from w_inherite`cb_delrow within w_sal_06041
boolean visible = false
integer x = 3918
integer y = 916
end type

event cb_delrow::clicked;call super::clicked;p_delrow.TriggerEvent(Clicked!)

end event

type cb_addrow from w_inherite`cb_addrow within w_sal_06041
boolean visible = false
integer x = 3589
integer y = 912
end type

event cb_addrow::clicked;call super::clicked;p_addrow.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_06041
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 404
integer width = 4742
integer height = 1964
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_06041_2"
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
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
	
   sHouse  = dw_input.GetItemString(1, 'house')  	

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
	sHouse  = dw_input.GetItemString(1, 'house')
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
	  
	dw_insert.setitem(lrow, "jego_qty",  dJegoqty)
	dw_insert.setitem(lrow, "valid_qty", dvalidqty)
	dw_insert.setitem(lrow, "jego_temp", dqty)
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

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

type cb_mod from w_inherite`cb_mod within w_sal_06041
boolean visible = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_06041
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_sal_06041
boolean visible = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06041
boolean visible = false
end type

type cb_print from w_inherite`cb_print within w_sal_06041
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_sal_06041
boolean visible = false
end type

type cb_search from w_inherite`cb_search within w_sal_06041
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_sal_06041
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06041
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06041
end type

type r_head from w_inherite`r_head within w_sal_06041
integer width = 4750
integer height = 320
end type

type r_detail from w_inherite`r_detail within w_sal_06041
integer y = 400
integer width = 4750
end type

type dw_hidden from datawindow within w_sal_06041
boolean visible = false
integer x = 1006
integer y = 1340
integer width = 1317
integer height = 168
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_sal_06041
boolean visible = false
integer x = 96
integer y = 2328
integer width = 494
integer height = 212
integer taborder = 120
boolean bringtotop = true
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_imhist_in from datawindow within w_sal_06041
boolean visible = false
integer x = 713
integer y = 2332
integer width = 494
integer height = 212
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_print from datawindow within w_sal_06041
boolean visible = false
integer x = 1317
integer y = 2336
integer width = 855
integer height = 104
integer taborder = 140
boolean bringtotop = true
boolean titlebar = true
string title = "������� ���"
string dataobject = "d_pdt_04035_02_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_prt from datawindow within w_sal_06041
boolean visible = false
integer x = 3849
integer y = 1804
integer width = 686
integer height = 400
integer taborder = 120
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_pdt_04035_02_p2"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cbx_2 from checkbox within w_sal_06041
integer x = 3561
integer y = 228
integer width = 393
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 12639424
string text = "�ŷ���ǥ"
end type

type cbx_1 from checkbox within w_sal_06041
integer x = 3561
integer y = 288
integer width = 288
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 12639424
string text = "�����"
end type

type rb_delete from radiobutton within w_sal_06041
integer x = 4416
integer y = 252
integer width = 242
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 12639424
string text = "����"
end type

event clicked;ic_status = '2'
ic_yn = 'N'

dw_insert.DataObject = 'd_sal_06041_2'
dw_insert.SetTransObject(SQLCA)

dw_insert.Object.opt.Visible = True
dw_insert.Object.opt_t.Visible = True

p_1.enabled = false

wf_Initial()


end event

type rb_insert from radiobutton within w_sal_06041
integer x = 4055
integer y = 252
integer width = 242
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 12639424
string text = "���"
boolean checked = true
end type

event clicked;ic_status = '1'	// ���
ic_yn = 'N'

dw_insert.DataObject = 'd_sal_06041_1'
dw_insert.SetTransObject(SQLCA)

dw_insert.Object.opt.Visible = false
dw_insert.Object.opt_t.Visible = false

p_1.enabled = true

wf_Initial()


end event

type p_1 from uo_picture within w_sal_06041
boolean visible = false
integer x = 3301
integer y = 80
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;if dw_input.enabled then

	p_addrow.triggerevent(clicked!)
	
	string	sDate, sDept, sGubun, sEmpno2, sHouse, sCheck, sProject, sEmpno, &
				sRelcod, sNaougu, scvcod 
	long		lRow
	
	sDate    = TRIM(dw_input.GetItemString(1, "sdate"))
	sHouse   = dw_input.GetItemString(1, "house")
	sEmpno2  = dw_input.GetItemString(1, "empno2")
	sEmpno   = dw_input.GetItemString(1, "empno")
	sDept 	= dw_input.GetItemString(1, "dept")
	sGubun 	= dw_input.GetItemString(1, "gubun")
	sCheck   = dw_input.GetItemString(1, "check")
	scvcod   = dw_input.GetItemString(1, "cvcod")
	
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
	
	dw_insert.deleterow(dw_insert.getrow())
	
end if

datawindow dwname	

dw_input.accepttext()
dwname = dw_insert
gs_code = dw_input.getitemstring(1, "house")

openwithparm(w_pdt_04037, dwname)

setnull(gs_code)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_3 from picture within w_sal_06041
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3968
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\�μ�_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\�μ�_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\�μ�_up.gif'
end event

event clicked;String sJpno
Long   ll_msg

sJpno   = dw_input.GetItemString(1, "jpno")

if dw_insert.RowCount() > 0 then
	if cbx_1.checked then 	
			dw_print.retrieve(gs_sabu, sJpno, sJpno, gs_saupj)
			dw_print.print()
	end if
	If cbx_2.Checked Then
			dw_prt.retrieve(gs_sabu, sJpno)
			dw_prt.print()
	end if
else
	MessageBox("�μ�Ȯ��", "��ȸ �� �μ��Ͻñ� �ٶ��ϴ�.")	
end if
end event

type cb_1 from commandbutton within w_sal_06041
integer x = 3310
integer y = 84
integer width = 311
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����"
end type

event clicked;p_1.TriggerEvent(Clicked!)

end event

type cb_2 from commandbutton within w_sal_06041
integer x = 3634
integer y = 84
integer width = 311
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���߰�"
end type

event clicked;p_addrow.TriggerEvent(Clicked!)
end event

type cb_3 from commandbutton within w_sal_06041
integer x = 3959
integer y = 84
integer width = 311
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����"
end type

event clicked;p_delrow.TriggerEvent(Clicked!)
end event

type gb_2 from groupbox within w_sal_06041
integer x = 3968
integer y = 200
integer width = 754
integer height = 148
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
end type

