$PBExportHeader$w_pdt_04030.srw
$PBExportComments$�����(��Ÿ)
forward
global type w_pdt_04030 from window
end type
type dw_lot from datawindow within w_pdt_04030
end type
type p_2 from uo_picture within w_pdt_04030
end type
type p_1 from uo_picture within w_pdt_04030
end type
type p_exit from uo_picture within w_pdt_04030
end type
type p_cancel from uo_picture within w_pdt_04030
end type
type p_delete from uo_picture within w_pdt_04030
end type
type p_save from uo_picture within w_pdt_04030
end type
type p_retrieve from uo_picture within w_pdt_04030
end type
type dw_print from datawindow within w_pdt_04030
end type
type cbx_1 from checkbox within w_pdt_04030
end type
type dw_imhist_in from datawindow within w_pdt_04030
end type
type rb_delete from radiobutton within w_pdt_04030
end type
type rb_insert from radiobutton within w_pdt_04030
end type
type dw_detail from datawindow within w_pdt_04030
end type
type gb_2 from groupbox within w_pdt_04030
end type
type rr_1 from roundrectangle within w_pdt_04030
end type
type dw_imhist from datawindow within w_pdt_04030
end type
type dw_list from datawindow within w_pdt_04030
end type
end forward

global type w_pdt_04030 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "��� ���ε��"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_lot dw_lot
p_2 p_2
p_1 p_1
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
dw_print dw_print
cbx_1 cbx_1
dw_imhist_in dw_imhist_in
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
gb_2 gb_2
rr_1 rr_1
dw_imhist dw_imhist
dw_list dw_list
end type
global w_pdt_04030 w_pdt_04030

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              // ��������
String     is_totime             // ���۽ð�
String     is_window_id          // ������ ID
String     is_usegub             // �̷°��� ����

String     is_ispec ,  is_jijil
String     iSin_store            // â�� �̵��� �԰� â��
String     is_store_gu           // ���ұ��� => 'â���̵�' �ϰ�츸 ���
end variables

forward prototypes
public subroutine wf_setqty ()
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_create (ref string arg_sjpno)
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
end prototypes

public subroutine wf_setqty ();long k, lcount
dec  djego_qty, dunqty

lcount = dw_list.rowcount()

FOR k = 1 TO lcount
	// lot����ǰ�� ��� �������� �������� �ʴ´�
	If dw_list.getitemstring(k, 'lotgub') = 'Y' Then continue
	
	djego_qty = dw_list.GetItemDecimal(k, 'jego_qty') 
	dunqty    = dw_list.GetItemDecimal(k, 'unqty') 
	if djego_qty > 0 then 
		if djego_qty >= dunqty then 
			dw_list.SetItem(k, 'outqty', dunqty)
		else	
			dw_list.SetItem(k, 'outqty', djego_qty)
		end if
	end if
NEXT

end subroutine

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		* ��ϸ��
//		1. ������ = 0		-> SKIP
//		2. ������ > 0 �� �͸� ��ǥó��
//		3. �������� + ������ = ��û���� -> �Ͱ�Ϸ�('Y')
//	
//////////////////////////////////////////////////////////////////
dec{3}	dOutQty, dIsQty, dQty, dTemp_OutQty
long		lRow,	lCount


FOR	lRow = 1		TO		dw_list.RowCount()

	dQty    = dw_list.GetItemDecimal(lRow, "qty")		// ����û����
	dIsQty  = dw_list.GetItemDecimal(lRow, "isqty")		// ��������	
	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")	// ������

	IF ic_status = '1'	THEN
		IF dOutQty > 0		THEN
		
			lCount++

		END IF
	END IF

	
	/////////////////////////////////////////////////////////////////////////
	//	1. ������ 
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		if doutqty < 1 then
			f_message_chk(30, '[������]')
			dw_list.setcolumn("outqty")
			dw_list.scrolltorow(lrow)
			dw_list.setfocus()
			return -1
		end if

		lCount++

	END IF

NEXT


////////////////////////////////////////////////////////////////////////
///// �԰� â�� "���� â��"�� ��츸 �ڷ�üũ PASS(04.03.10 itkim ////
////////////////////////////////////////////////////////////////////////
IF (Isnull(is_store_gu) or is_store_gu = "") and iSin_store <> 'Z09' then	
	IF lCount < 1		THEN	
		MessageBox("Ȯ��", "����ڷᰡ �����ϴ�.")
		RETURN -1
	END IF
END IF


RETURN 1
end function

public function integer wf_imhist_create (ref string arg_sjpno);///////////////////////////////////////////////////////////////////////
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '001'
///////////////////////////////////////////////////////////////////////
string	sJpno, sIOgubun,	&
			sDate, sTagbn, ssaupj, &
			sHouse, sEmpno, sRcvcod, sSaleyn, sinstore, snull, sOpseq, sQcgub, sLotgub, sHoldNo, sLotsno, sLoteno, &
			sStock, sInsQc, sGrpno, sgubun, sItnbr, scustom, scustno
long		lRow, lRowHist, lRowHist_In, ix
dec		dSeq, dOutQty,	dInSeq, dLotrow

dw_detail.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

Setnull(sNull)
//////////////////////////////////////////////////////////////////////////////////////
string	sHouseGubun, sIngubun

sIOgubun = dw_list.GetItemString(1, "hold_gu")		// ��û���� (����Ƿڹ�ȣ���� ����)

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
if	sHousegubun = 'Y' then
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

sDate = dw_detail.GetItemString(1, "edate")				// �������
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  	= sDate + string(dSeq, "0000")
sHouse 	= dw_detail.GetItemString(1, "house")
sEmpno 	= dw_detail.GetItemString(1, "empno")

IF sHouseGubun = 'Y'		THEN
	
	dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dInSeq < 0		THEN	
		rollback;
		RETURN -1
	end if
	COMMIT;

END IF

//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
Decimal LSqlcode

FOR lRow = 1	TO	dw_list.RowCount()

	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")
	IF dOutQty <= 0	THEN Continue

	sHoldNo = dw_list.GetItemString(lRow, "hold_no")
	
	sLotgub = dw_list.GetItemString(lRow, 'lotgub')
	If sLotgub = 'N' Then
		dLotRow = 1
	Else
		dw_lot.SetFilter("hold_no = '" + sHoldNo + "'")
		dw_lot.Filter()
	
		dLotRow = dw_lot.RowCount()
	End If
	
	For ix = 1 To dLotRow
		/* Lot �� ����Ұ��� �׷��� ���� ��� */
		If sLotgub = 'N' Then
			/* ������ */
			dOutQty = dw_list.GetItemNumber(lRow,"outqty")
			If IsNull(dOutQty) Then dOutQty = 0
			
			SetNull(sLotsNo)
			SetNull(sLoteNo)
			SetNull(sCustNo)
		Else
			/* LOT�� ������ */
			dOutQty = dw_lot.GetItemNumber(ix,"hold_qty")
			If IsNull(dOutQty) Then dOutQty = 0
			
			sLotsNo = dw_lot.GetItemString(ix,"lotno")
			sLoteNo = ''
			sCustNo = dw_lot.GetItemString(ix,"cust_no")
		End If
		
		// ������� â������� 
		SELECT HOMEPAGE, ipjogun
		  INTO :sSaleYN, :ssaupj
		  FROM VNDMST
		 WHERE ( CVCOD = :sHouse ) ;
			 
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
		dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "pspec")) // ���
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// ����â��=���â��
		dw_imhist.SetItem(lRowHist, "cvcod",	dw_list.GetItemString(lRow, "in_store")) 	// �ŷ�óâ��=�԰�ó
		dw_imhist.SetItem(lRowHist, "cust_no",	sCustNo)
		dw_imhist.SetItem(lRowHist, "ioqty",	dOutQty) 	   // ���Ҽ���=������
		dw_imhist.SetItem(lRowHist, "ioreqty",	dOutQty) 	   // �����Ƿڼ���=������		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// �˻�����=�������	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dOutQty) 	   // �հݼ���=������		
		sOpseq = dw_list.getitemstring(Lrow, "opseq")
		dw_imhist.SetItem(lRowHist, "opseq",	sopseq)			// �����ڵ�
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// ���ҽ�������=�������	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno)			// ���ҽ�����=�����	
		dw_imhist.SetItem(lRowHist, "hold_no", dw_list.GetItemString(lRow, "hold_no")) 	   // �Ҵ��ȣ
		dw_imhist.SetItem(lRowHist, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // ����������
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
		dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
		dw_imhist.SetItem(lRowHist, "outchk",  dw_list.GetItemString(lRow, "hosts")) 			// ����ǷڿϷ�
		dw_imhist.SetItem(lRowHist, "pjt_cd",  dw_list.GetItemString(lRow, "pjtno"))        // ������ƮNo
		
		dw_imhist.SetItem(lRowHist, "facgbn",  dw_list.GetItemString(lRow, "hyebia1"))        // ����
		
		dw_imhist.SetItem(lRowHist, "lotsno",  sLotsNo)			// LOt No
	   dw_imhist.SetItem(lRowHist, "saupj",   ssaupj)
		
		
//		/* �ܰ� SELECT 2004.02.07(���� ���ǰ(����/����ǰ��)�� �ܰ� �� ��� �ݾ�) */ 
//		string sitnbr, spsspec
//		long   lioprc, lioqty
//		sitnbr  = dw_list.GetItemString(lRow , "itnbr" )
//		spsspec = dw_list.GetItemString(lRow , "pspec" )
//		lioqty  = dw_list.GetItemDecimal(lRow, "outqty")
//		if sIOgubun='O06' then
//			select fun_danmst_danga(:sdate, :sitnbr, :spsspec)
//			  into :lioprc
//			from dual;
//			
//			dw_imhist.SetItem(lRowHist, "ioprc",  lioprc)
//			dw_imhist.SetItem(lRowHist, "ioamt",  lioqty * lioprc)
//		end if
	
		
		IF sHouseGubun = 'Y'	THEN
			
			lRowHist_In = dw_imhist_in.InsertRow(0)						
			
			dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
			dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// ��ǥ��������
			dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// �������
			dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(lRowHist_in, "000") )
			dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// ���ұ���=â���̵��԰���
	
			dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// ��������=�������
			//iomatrix�� Ÿ���� ������ Y�̸� �԰�ǰ�� Ÿ����ǰ���� ����
			if stagbn = 'Y' then 
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "ditnbr")) // ǰ��
				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_list.GetItemString(lRow, "dpspec")) // ���
			else	
				dw_imHist_in.SetItem(lRowHist_in, "itnbr", dw_list.GetItemString(lRow, "itnbr")) // ǰ��
				dw_imHist_in.SetItem(lRowHist_in, "pspec", dw_list.GetItemString(lRow, "pspec")) // ���
			end if
			
			dw_imHist_in.SetItem(lRowHist_in, "depot_no",dw_list.GetItemString(lRow, "in_store")) 	// ����â��=�԰�ó
			sInstore = dw_list.GetItemString(lRow, "in_store")
			dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// �ŷ�óâ��=���â��
			dw_imHist_in.SetItem(lRowHist_in, "cust_no",	sCustNo)
			dw_imhist_in.SetItem(lRowHist_in, "opseq",	sOpseq)			// �����ڵ�
		
			dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dOutQty) 	   // �����Ƿڼ���=������		
			dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// �˻�����=�������	
			
			dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sQcgub)			// �˻���
			dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dOutQty) 	   // �հݼ���=������		
			dw_imHist_in.SetItem(lRowHist_in, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // ����������
			dw_imHist_in.SetItem(lRowHist_in, "lotsno",  sLotsNo)		   // LOt No
			dw_imHist_in.SetItem(lRowHist_in, "facgbn",  dw_list.GetItemString(lRow, "hyebia2"))		   // ����
			dw_imHist_in.SetItem(lRowHist_in, "saupj", sSaupj)
			
			// ���ҽ��ο��δ� �ش� â���� ���ο��θ� �������� �Ѵ�
			// �� ������ ����� �ƴ� ���� �ڵ�����'Y'���� ����
			Setnull(sSaleyn)
			SELECT HOMEPAGE, ipjogun
			  INTO :sSaleYN, :ssaupj
			  FROM VNDMST
			 WHERE ( CVCOD = :sinstore ) ;	
	      
			IF isnull(sSaleyn) or trim(ssaleyn) = '' then
				Ssaleyn = 'N'
			end if			 
			
			sItnbr  = dw_list.GetItemString(lRow, "itnbr")
			sStock  = dw_list.GetItemString(lRow, "itemas_filsk") // ����������
			sGrpno  = dw_list.GetItemString(lRow, "grpno2")        // �˻�ǰ����
			 
			if isnull(sStock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then	
				sStock = 'Y'
			end if
			
			// �˻��Ƿ�(���԰˻�)�̸鼭 �԰��� �˻��� ���
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
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sgubun)           // ���˻�
				dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)
			End If
			
			// ���˻��̸� �ڵ������� ��� ���γ��� ����
			IF sgubun = '1' And sSaleYn = 'Y' then
				dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_list.GetItemDecimal(lRow, "outqty")) 	   // ���Ҽ���=�԰����
				dw_imhist_in.SetItem(lRowHist_in, "io_date",  sDate)	   	                           // ���ҽ�������=�԰��Ƿ�����
				dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		                              // ���ҽ�����=NULL
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			                        // ���ҽ��ο���
			ELSE
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm", sSaleYn)			                        // ���ҽ��ο���				
			END IF
			
			dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				                              // ���������
			dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
			dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			                              // �����Ƿڴ����=�����	
			dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(lRowHist, "000"))             // �԰���ǥ��ȣ=����ȣ
		END IF
	Next
NEXT

//-------------------------------------------------------------------//
if dw_list.update() = -1 then
	rollback;		
	LSqlcode = dec(sqlca.sqlcode)
	f_message_chk(LSqlcode,'[�Ҵ� �ڷ�����]') 
	return -1
End if
Commit;
//-------------------------------------------------------------------//

arg_sJpno = sJpno

RETURN 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. �����HISTORY ����
//
///////////////////////////////////////////////////////////////////////

dec{3}	dOutQty, dNotOutQty, dTempQty
string	sHist_Jpno, sIodate
long		lRow, lRowCount, i, k

lRowCount = dw_list.RowCount()

FOR lrow = 1 TO lRowCount
	 sHist_Jpno = dw_list.GetItemString(lrow, "imhist_iojpno")
	 sIoDate    = dw_list.GetItemString(lrow, "cndate")

	k ++	
	 
	if dw_list.getitemstring(lrow, "del") <> 'Y' then continue
	
	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
	if not isnull(dw_list.GetItemString(lRow, "cndate")) AND &
	   dw_list.GetItemString(lRow, "i_confirm") = 'N' then continue
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU" = :gs_sabu
	   and "IMHIST"."IOJPNO" = :sHist_Jpno   ;
//	messagebox('1', sqlca.sqlerrtext)  
	IF SQLCA.SQLNROWS < 1	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
	  
   DELETE FROM "IMHIST"  
	 WHERE "IMHIST"."SABU"    = :gs_sabu
	   and "IMHIST"."IP_JPNO" = :sHist_Jpno   
	   AND "IMHIST"."JNPCRT" = '011';

	IF SQLCA.SQLCODE < 0	THEN
		ROLLBACK;
		f_Rollback();
		RETURN -1
	END IF			  
		
	i ++	
Next
////////////////////////////////////////////////////////////////////////
IF i < 1 Then
	messagebox("Ȯ ��", "���� �� �ڷḦ �����ϼ���.!")
	Return -1
END IF

if i = k then return -2  //��ü �����Ǿ����� ȭ�� reset

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
dec{3}	dOutQty, dTemp_OutQty
long		lRow, i, k

FOR	lRow = 1		TO		dw_list.RowCount()

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
     		  SET "IOQTY" = :dOutQty,   
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

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()
dw_imhist_in.reset()

p_delete.enabled = false
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then
	// ��Ͻ�
	dw_detail.settaborder("out_jpno",  0)
	dw_detail.settaborder("EDATE", 10)
	dw_detail.settaborder("jpno",  20)
	dw_detail.settaborder("house", 40)
	dw_detail.settaborder("empno", 50)

	dw_detail.Modify("t_dsp_no.visible = 0")
	
	dw_detail.Modify("t_dsp_date.visible = 1")
	dw_detail.Modify("t_dsp_yno.visible = 1")
	dw_detail.Modify("t_dsp_chang.visible = 1")
	dw_detail.Modify("t_dsp_emp.visible = 1")
	
	dw_detail.setcolumn("JPNO")
	dw_detail.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "���"
ELSE
	dw_detail.settaborder("out_jpno",  10)
	dw_detail.settaborder("EDATE", 0)
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("house", 0)
	dw_detail.settaborder("empno", 0)

   dw_detail.Modify("t_dsp_no.visible = 1")
	
	dw_detail.Modify("t_dsp_date.visible = 0")
	dw_detail.Modify("t_dsp_yno.visible = 0")
	dw_detail.Modify("t_dsp_chang.visible = 0")
	dw_detail.Modify("t_dsp_emp.visible = 0")

	dw_detail.setcolumn("OUT_JPNO")

	w_mdi_frame.sle_msg.text = "����"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

f_mod_saupj(dw_detail, 'saupj')

return  1

end function

event open; 
Integer  li_idx

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

//---------------------------------------------------------
//���â��
datawindowchild state_child
integer rtncode

rtncode = dw_detail.GetChild("HOUSE", state_child)
IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ���â��")
state_child.SetTransObject(SQLCA)
//state_child.Retrieve( gs_saupj, "2", gs_empno)
state_child.Retrieve( gs_saupj)

//---------------------------------------------------------
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

//dw_imhist.settransobject(sqlca)
is_Date = f_Today()


// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_pdt_04030.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.dw_lot=create dw_lot
this.p_2=create p_2
this.p_1=create p_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.dw_print=create dw_print
this.cbx_1=create cbx_1
this.dw_imhist_in=create dw_imhist_in
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.rr_1=create rr_1
this.dw_imhist=create dw_imhist
this.dw_list=create dw_list
this.Control[]={this.dw_lot,&
this.p_2,&
this.p_1,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.dw_print,&
this.cbx_1,&
this.dw_imhist_in,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.gb_2,&
this.rr_1,&
this.dw_imhist,&
this.dw_list}
end on

on w_pdt_04030.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lot)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.dw_print)
destroy(this.cbx_1)
destroy(this.dw_imhist_in)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.dw_imhist)
destroy(this.dw_list)
end on

event closequery;
string s_frday, s_frtime

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

type dw_lot from datawindow within w_pdt_04030
boolean visible = false
integer x = 14
integer y = 632
integer width = 2999
integer height = 640
integer taborder = 30
string title = "none"
string dataobject = "d_sal_02040_1"
boolean livescroll = true
end type

type p_2 from uo_picture within w_pdt_04030
integer x = 3515
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;//long lRow
//
//if dw_list.accepttext() = -1 then return 
//if dw_detail.accepttext() = -1 then return 
//if dw_list.rowcount() < 1 then return 
//
//lRow = dw_list.getrow()
//
//if lRow < 1 then 
//	messagebox('Ȯ ��', '��ȸ�� �ڷḦ �����ϼ���!')
//	return 
//end if
//
//gs_code = dw_list.getitemstring(lRow, 'itnbr')
//IF IsNull(gs_code)	or   trim(gs_code) = ''	THEN
//	f_message_chk(30,'[ǰ��]')
//	dw_list.ScrollToRow(lRow)
//	dw_list.Setcolumn("itnbr")
//	dw_list.setfocus()
//	RETURN 
//END IF
//gs_gubun = dw_detail.getitemstring(1, 'house')
//
//// �ڵ���� Y�� �ƴϸ� ������ �� ���� ��ȸ�� 'Y' �̸� ������ �� ����
//gs_codename = 'N' 
//open(w_stock_popup)
//

/* ��� ���� */
datawindow dwname	
Long nRow
Dec  dQty

If dw_list.accepttext() <> 1 Then Return
nRow = dw_list.GetSelectedRow(0)
If nRow <= 0 Then Return

dwname = dw_lot

gs_gubun = dw_detail.GetItemString(1, 'house')
gs_code  = dw_list.getitemstring(nRow, "itnbr")
gs_codename = dw_list.getitemstring(nRow, "hold_no")
gs_codename2 =  String(dw_list.getitemNumber(nRow, "unqty"))
gs_docno ='N'	// ���� üũ

openwithparm(w_stockwan_popup, dwname)
If IsNull(gs_code) Or Not IsNumber(gs_code) Then Return

dw_list.SetItem(nRow, 'outqty', Dec(gs_code))

setnull(gs_code)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_1 from uo_picture within w_pdt_04030
integer x = 3337
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\point.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;OPENSheet(W_MAT_03550, w_mdi_frame, 2, Layered!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_exit from uo_picture within w_pdt_04030
integer x = 4402
integer y = 8
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_cancel from uo_picture within w_pdt_04030
integer x = 4229
integer y = 8
integer width = 178
integer taborder = 80
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

type p_delete from uo_picture within w_pdt_04030
integer x = 4055
integer y = 8
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* ����� ����
//////////////////////////////////////////////////////////////////
int    ireturn 

SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

dw_list.setredraw(false)
ireturn = wf_Imhist_Delete()
	
IF iReturn = -1		THEN	
	rollback;
	dw_list.setredraw(true)
	RETURN
end if

COMMIT;

IF ireturn = -2 THEN 
   p_cancel.triggerevent(clicked!)
ELSE
	p_retrieve.triggerevent(clicked!)
END IF

dw_list.setredraw(true)
SetPointer(Arrow!)

end event

type p_save from uo_picture within w_pdt_04030
integer x = 3881
integer y = 8
integer width = 178
integer taborder = 60
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

string	sDate, sArg_sdate
Decimal  dArg_dseq
sdate  = dw_detail.GetItemstring(1, "Edate")			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ���� = 0		-> RETURN
//		2. �����HISTORY : ��ǥä������('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 
	

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
		dw_print.setfilter("ioseq <> '999'")
		dw_print.filter()	
		dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate, gs_saupj)
		dw_print.print()
   end if      										 
/////////////////////////////////////////////////////////////////////////
//	1. ���� : �Ҵ�TABLE(������, ��������, �Ϸᱸ��)
//				 �����HISTORY(������)
/////////////////////////////////////////////////////////////////////////
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

type p_retrieve from uo_picture within w_pdt_04030
integer x = 3707
integer y = 8
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
			sOutJpno,	&
			sDate,		&
			sHouse, sEmpno,	&
			sNull
SetNull(sNull)

sDate    = TRIM(dw_detail.getitemstring(1, "edate"))
sJpno   	= TRIM(dw_detail.getitemstring(1, "jpno"))
sHouse  	= dw_detail.getitemstring(1, "house")
sEmpno  	= dw_detail.getitemstring(1, "empno")
sOutJpno = TRIM(dw_detail.getitemstring(1, "out_jpno"))

IF ic_status = '1'		THEN
	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[�������]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sJpno) or sJpno = "" 	THEN
		f_message_chk(30,'[�Ƿڹ�ȣ]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sJpno) or sJpno = "" 	THEN sJpno = ''
		
	IF isnull(sHouse) or sHouse = "" 	THEN
		f_message_chk(30,'[���â��]')
		dw_detail.SetColumn("house")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[����ڹ�ȣ]')
		dw_detail.SetColumn("empno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sJpno = sJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sjpno, sHouse, gs_saupj) <	1		THEN
		f_message_chk(50, '[���-��Ÿ]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		return
	END IF
     //--- ����û���� Ȯ��...
     wf_setqty()
ELSE

	IF isnull(sOutJpno) or sOutJpno = "" 	THEN
		f_message_chk(30,'[����ȣ]')
		dw_detail.SetColumn("out_jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sOutJpno = sOutJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sOutjpno) <	1		THEN
		f_message_chk(50, '[���-��Ÿ]')
		dw_detail.setcolumn("out_jpno")
		dw_detail.setfocus()
		return
	END IF

	// ������忡���� ��������
	p_delete.enabled = true	
	
END IF


//////////////////////////////////////////////////////////////////////////

dw_detail.enabled = false


dw_list.SetColumn("outqty")
dw_list.SetFocus()
//cb_save.enabled = true

end event

type dw_print from datawindow within w_pdt_04030
boolean visible = false
integer x = 1317
integer y = 2324
integer width = 855
integer height = 104
boolean titlebar = true
string title = "��Ÿ��� ���"
string dataobject = "d_mat_03550_02_p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_pdt_04030
integer x = 3218
integer y = 236
integer width = 695
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "����� �ڵ���� ����"
end type

type dw_imhist_in from datawindow within w_pdt_04030
boolean visible = false
integer x = 713
integer y = 2324
integer width = 494
integer height = 212
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
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

type rb_delete from radiobutton within w_pdt_04030
integer x = 4274
integer y = 208
integer width = 242
integer height = 64
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

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_pdt_04032'
dw_list.SetTransObject(sqlca)
dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

wf_Initial()
end event

type rb_insert from radiobutton within w_pdt_04030
integer x = 3963
integer y = 208
integer width = 242
integer height = 64
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

event clicked;
ic_status = '1'	// ���

dw_list.DataObject = 'd_pdt_04030'
dw_list.SetTransObject(sqlca)
dw_list.object.ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

wf_Initial()
end event

type dw_detail from datawindow within w_pdt_04030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 12
integer width = 3141
integer height = 288
integer taborder = 10
string dataobject = "d_pdt_04031"
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

event itemchanged;string	sDate, sDept, 		&
			sCode, sName, 		&
			sJpno, sHist_Jpno, 		&
			sHouse,sEmpno,				&
			sNull, sGubun, sname2, stagbn, spass
int      ireturn 			

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'edate' THEN
	sDate = trim(this.gettext())
	
	if isnull(sDate) or sDate = '' then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[�������]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'house' THEN
	sHouse = this.gettext()
	
	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[���â��]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			return 1
      END IF		
	END IF

	SELECT A.EMPNO, B.EMPNAME INTO :sempno, :sname
		FROM DEPOT_EMP A, P1_MASTER B
		WHERE A.EMPNO = B.EMPNO
		AND	A.DEPOT_NO = :sHouse AND ROWNUM = 1;//AND A.OWNER = 'Y';
		
	If isNull(sempno) Or sempno = '' Then
		this.SetItem(1,"empno", '')
		this.SetItem(1,"name", '')
	Else
		this.SetItem(1,"empno", sempno)
		this.SetItem(1,"name", sname)
	End If

ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sname)
      return 
   end if
   this.accepttext()
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("Ȯ ��", "â�� ���� �Է��ϼ���")
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if
	
   ireturn = f_get_name2('��������', 'Y', scode, sname, sname2)    //1�̸� ����, 0�� ����	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
	
ELSEIF this.getcolumnname() = "jpno"	then

	sJpno = TRIM(this.gettext())
	
	IF sJpno = '' or isnull(sJpno) THEN 
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
	   return 
	END IF	
		

  SELECT "HOLDSTOCK"."OUT_STORE", "HOLDSTOCK"."REQ_DEPT", 
  			"HOLDSTOCK"."HOLD_GU"  , "VNDMST"."CVNAS2", "IOMATRIX"."TAGBN", "HOLDSTOCK"."IN_STORE"
    INTO :sHouse, :sDept, :sGubun, :sName, :sTagbn, :iSin_store
    FROM "HOLDSTOCK",  		"VNDMST", 		"IOMATRIX" 
 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu )	AND
  		 ( "HOLDSTOCK"."HOLD_NO" like :sJpno||'%' )   AND
 		 ( "HOLDSTOCK"."REQ_DEPT" = "VNDMST"."CVCOD" ) AND
		 ( "HOLDSTOCK"."SABU"     = "IOMATRIX"."SABU" ) AND
		 ( "HOLDSTOCK"."HOLD_GU" = "IOMATRIX"."IOGBN" ) AND
		 ( "HOLDSTOCK"."PORDNO"   IS NULL )  AND 
		 ( "IOMATRIX"."JNPCRT" = '001' ) AND ROWNUM = 1 ;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[����Ƿڹ�ȣ]')
		this.setitem(1, "jpno", sNull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if

	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		SetNull(sPass)
		this.SetItem(1, "house", snull)
//		f_message_chk(33,'[���â��]')
//		this.setitem(1, "jpno", sNull)
//		this.SetItem(1, "dept",  snull)
//		this.SetItem(1, "deptname", snull)
//		this.SetItem(1, "hold_gu", snull)
//		this.setitem(1, "empno", sNull)
//		this.setitem(1, "name", sNull)
//		return 1
	Else
		this.SetItem(1, "house", sHouse)
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "jpno", sNull)
			this.SetItem(1, "house", snull)
			this.SetItem(1, "dept",  snull)
			this.SetItem(1, "deptname", snull)
			this.SetItem(1, "hold_gu", snull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			return 1
      END IF		
	END IF

   /* ���ұ����� "â���̵�"�̰�, �԰�â�� "����â��"�϶� ==> ������� ������ ����...(2004.03.10 itkim add!!) */
   if sgubun = 'O05' and iSin_store = 'Z09' then
	   is_store_gu = sgubun
	else
		setnull(is_store_gu)
	end if
	
	
	this.SetItem(1, "dept",  sDept)
	this.SetItem(1, "deptname", sName)
	this.SetItem(1, "hold_gu", sgubun)	
	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	
	if sTagbn = 'Y' then 
		dw_list.DataObject = 'd_pdt_04030_1'
		dw_list.object.dispec_t.text = 'Ÿ���� ��ü ' + is_ispec
		dw_list.object.djijil_t.text = 'Ÿ���� ��ü ' + is_jijil
	else
		dw_list.DataObject = 'd_pdt_04030'
	end if	
   dw_list.SetTransObject(sqlca)
	
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
	
	this.Setcolumn("empno")
	this.SetFocus()
	
ELSEIF this.getcolumnname() = "out_jpno"	then
	
	sHist_Jpno = TRIM(this.GetText())
	
	IF sHist_Jpno = '' or isnull(sHist_Jpno) then 
		this.SetItem(1, "edate", snull)
		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
   END IF
	
  SELECT A.INSDAT,			// �������
			A.IO_EMPNO,			// �����
			D.EMPNAME,			// ����ڸ�
			A.IOGBN,			   // �����
  			A.DEPOT_NO,			// ���â��
			SUBSTR(A.HOLD_NO, 1, 12), 
  			B.REQ_DEPT, 		// ��û�μ�
			C.CVNAS		
	 INTO :sDate,
			:sEmpno,
			:sName2,
			:sGubun,
			:sHouse,
			:sjpno, 
			:sDept,
			:sName
	 FROM IMHIST A, HOLDSTOCK B, VNDMST C, P1_MASTER D
	WHERE A.SABU = :gs_sabu AND
			A.IOJPNO LIKE :sHist_Jpno||'%' 	AND
			A.SABU = B.SABU	AND
			A.HOLD_NO = B.HOLD_NO	AND
			A.IO_EMPNO = D.EMPNO	(+) AND
			B.REQ_DEPT = C.CVCOD(+)	 	AND
			TRIM(A.JNPCRT) LIKE '001' AND ROWNUM = 1	;
	
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[����ȣ]')
		this.setitem(1, "out_jpno", sNull)
		this.SetItem(1, "edate", snull)
		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
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
		this.setitem(1, "out_jpno", sNull)
		this.SetItem(1, "edate", snull)
		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "dept",  snull)
		this.SetItem(1, "deptname", snull)
		this.SetItem(1, "hold_gu", snull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "out_jpno", sNull)
			this.SetItem(1, "edate", snull)
			this.SetItem(1, "jpno",  snull)
			this.SetItem(1, "empno", snull)
			this.SetItem(1, "name", snull)
			this.SetItem(1, "house", snull)
			this.SetItem(1, "dept",  snull)
			this.SetItem(1, "deptname", snull)
			this.SetItem(1, "hold_gu", snull)
			return 1
      END IF		
	END IF

	this.SetItem(1, "edate", sDate)
	this.SetItem(1, "jpno",  sJpno)
	this.SetItem(1, "empno", sEmpno)
	this.SetItem(1, "name", sName2)
	this.SetItem(1, "house", sHouse)
	this.SetItem(1, "dept",  sDept)
	this.SetItem(1, "deptname", sName)
	this.SetItem(1, "hold_gu", sGubun)

  SELECT "IOMATRIX"."TAGBN"  
    INTO :stagbn
    FROM "IOMATRIX"  
   WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND  
         ( "IOMATRIX"."IOGBN" = :sgubun )   ;

	if sTagbn = 'Y' then 
		dw_list.DataObject = 'd_pdt_04032_1'
		dw_list.object.dispec_t.text = 'Ÿ���� ��ü ' + is_ispec
		dw_list.object.djijil_t.text = 'Ÿ���� ��ü ' + is_jijil
	else
		dw_list.DataObject = 'd_pdt_04032'
	end if	
   dw_list.SetTransObject(sqlca)
	dw_list.object.ispec_t.text = is_ispec
	dw_list.object.jijil_t.text = is_jijil
ElseIf This.GetColumnName() = 'saupj' Then
	String  ls_saupj
	ls_saupj = Trim(This.GetText())
	
	If Trim(ls_saupj) = '' Or IsNull(ls_saupj) Then ls_saupj = '%'
	
	f_child_saupj(This, 'house', ls_saupj)
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;string sPass, shouse

gs_gubun = ''
gs_code = ''
gs_codename = ''

// �����δ����
IF this.GetColumnName() = 'empno'	THEN
	this.accepttext() 
   gs_gubun = '4' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code
	
	Open(w_depot_emp_popup)
	If Isnull(gs_code) or Trim(gs_code) = "" Then Return
   
   If isnull(shouse) or shouse = '' or shouse <> gs_gubun then 
		SELECT DAJIGUN
		  INTO :sPass
		  FROM VNDMST
		 WHERE CVCOD = :gs_gubun AND 
				 CVGU = '5'		  AND
				 CVSTATUS = '0' ;
		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[���â��]')
			return 
		end if
	
		IF not (sPass ="" OR IsNull(sPass)) THEN
			OpenWithParm(W_PGM_PASS,spass)
			IF Message.StringParm = "CANCEL" THEN 
				return 
			END IF		
		END IF
   End if
	
	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno",gs_code)
	SetItem(1,"name",gs_codename)
// ����Ƿڹ�ȣ
elseif this.getcolumnname() = "jpno" 	then
	open(w_haldang_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
   return 1	
// ����ȣ
elseif this.getcolumnname() = "out_jpno" 	then
	gs_gubun = '001'
	open(w_chulgo_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "out_jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
end if

end event

type gb_2 from groupbox within w_pdt_04030
integer x = 3918
integer y = 152
integer width = 654
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_pdt_04030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 312
integer width = 4539
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_imhist from datawindow within w_pdt_04030
boolean visible = false
integer x = 3072
integer y = 624
integer width = 1189
integer height = 396
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
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

type dw_list from datawindow within w_pdt_04030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 324
integer width = 4507
integer height = 1880
integer taborder = 20
string dataobject = "d_pdt_04030"
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

event itemchanged;string	sNull, sGub, sHouse, sLotgub
long		lRow
dec {3}	dOutQty, dNotOutQty, dStock, dTempQty
SetNull(sNull)

lRow  = this.GetRow()	

///////////////////////////////////////////////////////////////////////////
// 1. ������ > ����� �̸� ERROR
// 2. ������ > ����� �̸� ERROR
///////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = "outqty" THEN

	dOutQty = dec(this.GetText())
	
	if isnull(dOutQty) or dOutQty = 0 then return 
	
	dStock  = this.GetItemDecimal(lRow, "jego_qty")
	dNOtOutQty = this.GetItemDecimal(lRow, "unqty")
   sHouse  = dw_detail.GetItemString(1, 'house')  	
	sLotgub = this.GetItemString(lrow, 'lotgub')
	
	// ��� ��뿩�� â���� ��ȸ 
   SELECT KYUNGY INTO :sGub FROM VNDMST WHERE CVCOD = :sHouse ;

	IF ic_status = '2'	THEN
		dTempQty = this.GetItemDecimal(lRow, "temp_outqty")
		if isnull(dTempQty) then dTempQty = 0 
		dOutQty = dOutQty - dTempQty
	END IF
		
	IF sGub = 'N' then 
		IF dOutQty > dStock		THEN
			MessageBox("Ȯ��", "�������� ������� Ŭ �� �����ϴ�.")
			this.SetItem(lRow, "outqty", 0)
			RETURN 1
		END IF
	END IF

	IF dOutQty > dNotOutQty		THEN
		MessageBox("Ȯ��", "�������� ������������ Ŭ �� �����ϴ�.")
		this.SetItem(lRow, "outqty", 0)
		RETURN 1
	END IF

	IF sLotGub = 'Y' then 
		MessageBox("Ȯ��", "LOT NO ����ǰ�� ����� ��ư�� ����ϼ���")
		this.SetItem(lRow, "outqty", 0)
		RETURN 1
	END IF
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

	open(w_itemas_popup3)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
END IF


// �ŷ�ó
IF this.GetColumnName() = 'cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"cvcod",gs_code)
	SetItem(lRow,"vndmst_cvnas2",gs_codename)

	this.TriggerEvent("itemchanged")
	
END IF


// �Ƿڴ����
IF this.GetColumnName() = 'rempno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"rempno",gs_code)
//	SetItem(Row,"",gs_codename)

END IF


// �԰���â��
IF this.GetColumnName() = 'ipdpt'	THEN

	Open(w_vndmst_45_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"ipdpt",gs_code)
	SetItem(lRow,"vndmst_cvnas",gs_codename)

END IF



end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

event clicked;if dw_list.Rowcount() < 0 then return

dw_list.selectrow(0, false)
dw_list.selectrow(row, true)
end event

