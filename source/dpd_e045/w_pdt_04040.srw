$PBExportHeader$w_pdt_04040.srw
$PBExportComments$�����(�Ҵ�)
forward
global type w_pdt_04040 from window
end type
type dw_lot from datawindow within w_pdt_04040
end type
type st_3 from statictext within w_pdt_04040
end type
type st_2 from statictext within w_pdt_04040
end type
type p_3 from uo_picture within w_pdt_04040
end type
type p_2 from uo_picture within w_pdt_04040
end type
type p_1 from uo_picture within w_pdt_04040
end type
type p_exit from uo_picture within w_pdt_04040
end type
type p_can from uo_picture within w_pdt_04040
end type
type p_del from uo_picture within w_pdt_04040
end type
type p_mod from uo_picture within w_pdt_04040
end type
type p_inq from uo_picture within w_pdt_04040
end type
type p_print from uo_picture within w_pdt_04040
end type
type cb_3 from commandbutton within w_pdt_04040
end type
type cb_2 from commandbutton within w_pdt_04040
end type
type dw_imhist from datawindow within w_pdt_04040
end type
type dw_imhist_in from datawindow within w_pdt_04040
end type
type dw_print from datawindow within w_pdt_04040
end type
type cbx_1 from checkbox within w_pdt_04040
end type
type cb_1 from commandbutton within w_pdt_04040
end type
type dw_2 from datawindow within w_pdt_04040
end type
type dw_1 from datawindow within w_pdt_04040
end type
type rb_2 from radiobutton within w_pdt_04040
end type
type rb_1 from radiobutton within w_pdt_04040
end type
type cb_delete from commandbutton within w_pdt_04040
end type
type cb_cancel from commandbutton within w_pdt_04040
end type
type rb_delete from radiobutton within w_pdt_04040
end type
type rb_insert from radiobutton within w_pdt_04040
end type
type dw_detail from datawindow within w_pdt_04040
end type
type cb_save from commandbutton within w_pdt_04040
end type
type cb_exit from commandbutton within w_pdt_04040
end type
type cb_retrieve from commandbutton within w_pdt_04040
end type
type rr_1 from roundrectangle within w_pdt_04040
end type
type rr_3 from roundrectangle within w_pdt_04040
end type
type rr_4 from roundrectangle within w_pdt_04040
end type
type rr_5 from roundrectangle within w_pdt_04040
end type
type rr_6 from roundrectangle within w_pdt_04040
end type
type gb_1 from groupbox within w_pdt_04040
end type
type rr_2 from roundrectangle within w_pdt_04040
end type
type dw_list from u_d_select_sort within w_pdt_04040
end type
end forward

global type w_pdt_04040 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "��� ���(�Ҵ�)"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_lot dw_lot
st_3 st_3
st_2 st_2
p_3 p_3
p_2 p_2
p_1 p_1
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
p_print p_print
cb_3 cb_3
cb_2 cb_2
dw_imhist dw_imhist
dw_imhist_in dw_imhist_in
dw_print dw_print
cbx_1 cbx_1
cb_1 cb_1
dw_2 dw_2
dw_1 dw_1
rb_2 rb_2
rb_1 rb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
rr_1 rr_1
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
rr_6 rr_6
gb_1 gb_1
rr_2 rr_2
dw_list dw_list
end type
global w_pdt_04040 w_pdt_04040

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date, is_pordno, &
       is_house, is_empno, is_empnm  //�ʱ�ȭ ��ų�� �ٽ� ���� ó���ϱ� ����

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

String     is_ispec ,  is_jijil, is_holdgu

end variables

forward prototypes
public function integer wf_imhist_update ()
public subroutine wf_set_qty ()
public subroutine wf_jego_qty ()
public function integer wf_imhist_create (ref string arg_jpno)
public function integer wf_checkrequiredfield ()
public function integer wf_initial ()
public function integer wf_imhist_delete ()
public function integer wf_qcgub ()
end prototypes

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* �������
//		1. �����history -> ������ update (�������� ������ ��쿡��)
//		2. �������� + ������ = ��û���� -> �Ͱ�Ϸ�('Y')
//	
//////////////////////////////////////////////////////////////////
string	sHist_Jpno, sGubun, sDelYn
dec		dOutQty, dTemp_OutQty
long		lRow

FOR	lRow = 1		TO		dw_list.RowCount()

	dOutQty      = dw_list.GetItemDecimal(lRow, "outqty")			// ������(�����history)
	dTemp_OutQty = dw_list.GetItemDecimal(lRow, "temp_outqty")	// ������(�����history)
	sHist_Jpno   = dw_list.GetItemString(lRow, "imhist_iojpno")
	sGubun		 = dw_list.GetItemString(lRow, "hosts")

   sDelYn        = dw_list.GetItemString(lrow, "delyn")
	 
	/* �����ǥ�� ���ε� ���(�������ڰ� �ְ� ���ҽ��� ���ΰ� 'N') ���� */
	if (not isnull(sDelYn)) AND sDelYn = 'N' then continue
	
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
		IF sDelYn = 'Y'  then 
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
NEXT

COMMIT;

RETURN 1
end function

public subroutine wf_set_qty ();long k, lcount
dec  djego_qty, dunqty

lcount = dw_list.rowcount()

FOR k = 1 TO lcount
	If dw_list.GetItemString(k, 'lotgub') = 'Y' Then Continue	// LOT����ǰ�� ��쿡�� �ݵ�� LOT�����ؾ�...
	
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

public subroutine wf_jego_qty ();long    k, lcount, i
dec     djego_qty, dunqty
string  sitnbr, sfind, schange

lcount = dw_list.rowcount()

//ǰ��, ����� �������� ������ �װͿ� ���(����)������ �� ������ ������ �ٽ� �����Ѵ�. 
FOR k = 1 TO lcount
	sChange   = dw_list.GetItemString(k, 'change_yn') 
	
	IF sChange = 'N' THEN 
		sitnbr  = dw_list.GetItemString(k, 'sfind')
	
		djego_qty = dw_list.GetItemDecimal(k, 'jego_qty') 
		dunqty    = dw_list.GetItemDecimal(k, 'unqty') 
      
		if k < lcount then 
			FOR i = k + 1 TO lcount
				sfind = dw_list.GetItemString(i, 'sfind')
				if sitnbr = sfind then 
					if djego_qty > dunqty then 
                  dw_list.setitem(i, 'jego_qty', djego_qty - dunqty) 					
						djego_qty = djego_qty - dunqty 
						dunqty    = dw_list.GetItemDecimal(i, 'unqty') 
					else	
                  dw_list.setitem(i, 'jego_qty', 0) 					
					end if
               dw_list.setitem(i, 'change_yn', 'Y') 					
				end if
			NEXT
      end if
   END IF	
NEXT

end subroutine

public function integer wf_imhist_create (ref string arg_jpno);///////////////////////////////////////////////////////////////////////
//
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '002'
//
///////////////////////////////////////////////////////////////////////
string	sJpno, sProject, 	&
			sDate, sToday,	sQcgub,	sOutside, &
			sHouse, sEmpno, sRcvcod, siogubun, snull, ssaleyn, soutstore, shold_no, sopseq
long		lRow, lRowHist, lRowHist_In, lCOUNT, dSeq, dInseq, old_dseq, i, k, l 
dec{3}	dOutQty
Dec		dLotRow, ix, dValqty
String   sHoldNo, sLotsNo, sGrpNo2, sInsdat, sCustNo

dw_detail.AcceptText()

/* Save Data window Clear */
dw_imhist.reset()
dw_imhist_in.reset()

sDate = trim(dw_detail.GetItemString(1, "edate"))				// �������
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
IF dInSeq < 0		THEN	
	rollback;
	RETURN -1
end if
COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno    = sDate + string(dSeq, "0000")
sHouse   = dw_detail.GetItemString(1, "house")
sEmpno   = dw_detail.GetItemString(1, "empno")

////���˻� ����Ÿ ��������
//SELECT "SYSCNFG"."DATANAME"  
//  INTO :sQcgub  
//  FROM "SYSCNFG"  
// WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
//		 ( "SYSCNFG"."SERIAL" = 13 ) AND  
//		 ( "SYSCNFG"."LINENO" = '2' )   ;
//if sqlca.sqlcode <> 0 then
//	sQcgub = '1'
//end if

i = 0 //�����ǥ ä����
k = 0 //ä�� ����
l = 0 //�԰���ǥ ä����

lcount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount 

	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")

	IF dOutQty > 0		THEN
      if i > 997 then 
			exit 
		end if

		// �Ҵ��� ����â���� �������(1)����, ���� ����â��� �����û(2)������ ���� â������ Ʋ��
		If is_holdgu = '1' Then
      	sOutstore = dw_list.GetItemString(lRow,  "out_store")
		Else
			sOutstore = dw_list.GetItemString(lRow,  "in_store")
		End If
	
		/////////////////////////////////////////////////////////////////////////
		//
		// ** �����HISTORY ���� **
		//
		////////////////////////////////////////////////////////////////////////
		sHoldNo = dw_list.GetItemString(lRow, "hold_no")
		If dw_list.GetItemString(lRow,'lotgub') = 'N' Then
			dLotRow = 1
		Else
			dw_lot.SetFilter("hold_no = '" + sHoldNo + "'")
			dw_lot.Filter()
		
			dLotRow = dw_lot.RowCount()
		End If
		
		For ix = 1 To dLotRow
	
			/* Lot �� ����Ұ��� �׷��� ���� ��� */
			If dw_list.GetItemString(lRow,'lotgub') = 'N' Then
				/* ������ */
				dValQty = dw_list.GetItemNumber(lRow,"outqty")
				If IsNull(dValQty) Then dValQty = 0
				
				SetNull(sLotsNo)
				SetNull(sCustNo)
			Else
				/* LOT�� ������ */
				dValQty = dw_lot.GetItemNumber(ix,"hold_qty")
				If IsNull(dValQty) Then dValQty = 0
				
				sLotsNo = dw_lot.GetItemString(ix,"lotno")
				sCustNo = dw_lot.GetItemString(ix,"cust_no")
			End If
		
			lRowHist = dw_imhist.InsertRow(0)
			i++ 		
			
			dw_imhist.SetItem(lRowHist, "io_confirm", 'N')			// ���ҽ��ο���
			dw_imhist.SetItem(lRowHist, "ioqty", 	 dValQty) 	// ���Ҽ���=�԰����
			dw_imhist.SetItem(lRowHist, "io_date",  sDate)		// ���ҽ�������=�԰��Ƿ�����
			dw_imhist.SetItem(lRowHist, "io_empno", sempno)		// ���ҽ�����
	
			dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
			dw_imhist.SetItem(lRowHist, "jnpcrt",	'002')			// ��ǥ��������
			dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// �������
			dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(i, "000") )
			dw_imhist.SetItem(lRowHist, "iogbn",   dw_list.GetItemString(lRow, "hold_gu")) // ���ұ���=��û����
		
			dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// ��������=�������
			dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // ǰ��
			dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "pspec")) // ���
			dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// ����â��=���â��
			dw_imhist.SetItem(lRowHist, "cvcod",	soutstore) 	// �ŷ�óâ��=�԰�ó
			dw_imhist.SetItem(lRowHist, "cust_no",	scustno)
			dw_imhist.SetItem(lRowHist, "ioreqty",	dValQty) 	// �����Ƿڼ���=������		
			dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// �˻�����=�������	
			dw_imhist.SetItem(lRowHist, "iosuqty",	dValQty) 	// �հݼ���=������		
			dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
			
			sHold_no = dw_list.GetItemString(lRow, "hold_no")
			dw_imhist.SetItem(lRowHist, "ip_jpno", sHold_no) 	// �Ҵ��ȣ(�԰��ȣ�� ����)
			
	//		sOpseq	= dw_list.GetItemString(lRow, "opseq")
	// 2000/11/10 ����� ���� => �������� �۾������� �ƴϰ� ������ ������ '9999'
			dw_imhist.SetItem(lRowHist, "opseq", '9999') 	// ��������
			
			dw_imhist.SetItem(lRowHist, "filsk",   'Y') // ����������
			dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
			dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
			dw_imhist.SetItem(lRowHist, "outchk",  dw_list.GetItemString(lRow, "hosts")) 			// ����ǷڿϷ�
			dw_imhist.SetItem(lRowHist, "jakjino", dw_list.GetItemString(lRow, "pordno"))
	
			dw_imhist.SetItem(lRowHist, "lotsno",  sLotsNo)
			dw_imhist.SetItem(lRowHist, "saupj",  gs_saupj)
			
			// �Ҵ��� ����â��� �����û(2)�� ��� �Ҵ��ȣ�� �����Ѵ�
			If is_holdgu = '2' Then
				dw_imhist.SetItem(lRowHist, "hold_no",  sHoldno)
			End If
			
			// ��� â�� ���� �԰��Ƿ� �ڵ� ����
			sIogubun = dw_list.getitemstring(lrow, "hold_gu")
			
			setnull(srcvcod)
			SELECT RCVCOD, OUTSIDE_IN
			  INTO :sRcvcod, :sOutside
			  FROM IOMATRIX
			 WHERE SABU = :gs_sabu		AND
					 IOGBN = :sIOgubun ;
					  
			if sqlca.sqlcode <> 0 then
				f_message_chk(208, '[�����]')
			end if
			/* ���� â���̵� ����� ��� ��� �԰����� �˻� 
				-. �� ���ֻ������� ��쿡�� ���� */
			if sOutside = 'Y' then
			else
					if isnull(srcvcod) or trim(srcvcod) = '' then
						messagebox("���â��", "�԰����� �����ϴ�.")
						return -1
					end if
					
					// �԰��� �˻�ǰ ���� : Y�� ��� ���� -> ���԰˻� -> �԰���� -> �԰�(����â��)
					sGrpNo2 = dw_list.GetItemString(lRow, "grpno2")
					If IsNull(sGrpNo2) Or sGrpNo2 <> 'Y' Then sGrpNo2 = 'N'
					
					lRowHist_In = dw_imhist_in.InsertRow(0)
					l++
					// ���ҽ��ο��δ� �ش� â���� ���ο��θ� �������� �Ѵ�
					// �� ������ ����� �ƴ� ���� �ڵ�����'Y'���� ����
					Setnull(sSaleyn)
					SELECT HOMEPAGE
					  INTO :sSaleYN
					  FROM VNDMST
					 WHERE ( CVCOD = :sOutstore ) ;	
			
					IF isnull(sSaleyn) or trim(ssaleyn) = '' then
						Ssaleyn = 'N'
					end if			 
					
					// �԰��� �˻�ǰ�� ��� �������� ó����
					If sGrpNo2 = 'Y' Then	ssaleyn = 'N'
					
					sQcgub = dw_list.GetItemString(lRow, "qcgubun")
					If IsNull(sQcgub) Then sQcgub = '1'	
					
					If sQcgub = '1' Then // ���˻�
						dw_imHist_in.SetItem(lRowHist_in, "qcgub",	dw_list.GetItemString(lRow, "qcgubun"))		// �˻���
						dw_imHist_in.SetItem(lRowHist_in, "insemp",	sNull)			// �˻�����
						dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dValQty) 	// �հݼ���=������
						dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// �˻�����=�������	
						dw_imHist_in.SetItem(lRowHist_in, "decisionyn",	'Y')
					Else
						dw_imHist_in.SetItem(lRowHist_in, "qcgub",	dw_list.GetItemString(lRow, "qcgubun"))		// �˻���
						dw_imHist_in.SetItem(lRowHist_in, "insemp",	dw_list.GetItemString(lRow, "empno"))			// �˻�����
						dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	0) 	// �հݼ���=������
						dw_imHist_in.SetItem(lRowHist_in, "insdat",	sNull)			// �˻�����=�������	
						dw_imHist_in.SetItem(lRowHist_in, "gurdat",	sDate)			// �˻��û��
					End If
					
					// ���˻��̸鼭 �ڵ�����
					IF sQcgub = '1' And sSaleYn = 'Y' then
						dw_imhist_in.SetItem(lRowHist_in, "ioqty", dValQty) 	// ���Ҽ���=�԰����
						dw_imhist_in.SetItem(lRowHist_in, "io_date",  sdate)		// ���ҽ�������=�԰��Ƿ�����
						dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
					ELSE
						dw_imhist_in.SetItem(lRowHist_in, "ioqty", 0) 	// ���Ҽ���=�԰����
						dw_imhist_in.SetItem(lRowHist_in, "io_date",  sNull)		// ���ҽ�������=�԰��Ƿ�����
						dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// ���ҽ�����=NULL
					END IF	
					dw_imhist_in.SetItem(lRowHist_in, "io_confirm",	ssaleyn)			// ���ҽ��ο���
	
					// 2000/11/10 ����� ���� => �������� �۾������� �ƴϰ� ������ ������ '9999'
					dw_imhist_in.SetItem(lRowHist_in, "opseq", '9999') 	// ��������
					
					dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
					dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// ��ǥ��������
					dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// �������
					dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(l, "000") )
					dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// ���ұ���=â���̵��԰���
			
					dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// ��������=�������
					dw_imHist_in.SetItem(lRowHist_in, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // ǰ��
					dw_imHist_in.SetItem(lRowHist_in, "pspec",	dw_list.GetItemString(lRow, "pspec")) // ���
					dw_imHist_in.SetItem(lRowHist_in, "depot_no",sOutStore) 	// ����â��=�԰�ó
					dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// �ŷ�óâ��=���â��
					dw_imHist_in.SetItem(lRowHist_in, "cust_no",	sCustNo)
					
					dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dValqty) 	// �����Ƿڼ���=������		
	
					dw_imHist_in.SetItem(lRowHist_in, "filsk",   'Y') // ����������
					dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// ���������
					dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// ��������
			
					dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_list.GetItemString(lRow, "holdstock_req_dept"))		// �����Ƿںμ�=�Ҵ�.�μ�
					dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// �����Ƿڴ����=�����	
					dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(i, "000"))  // �԰���ǥ��ȣ=����ȣ		
					
					dw_imhist_in.SetItem(lRowHist_in, "lotsno", sLotsNo)
					dw_imhist_in.SetItem(lRowHist_in, "saupj", gs_saupj)
			end if	
		Next
	END IF

NEXT

if dw_imhist.update() <> 1 then
	rollback;
	f_rollback()		
	return -1
end if

if dw_imhist_in.update() <> 1 then
	rollback;
	f_rollback()		
	return -1
end if

commit;

if k > 0 then 
	MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(old_dSeq,"0000")+	' ����' +	&
										 string(dSeq,"0000")+	' ����' +	&
										 "~r~r�����Ǿ����ϴ�.")
else
	MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(dSeq,"0000")+		&
										 "~r~r�����Ǿ����ϴ�.")
end if

arg_jpno = sJpno

RETURN 1
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		* ��ϸ��
//		1. ������ = 0		-> SKIP
//		2. ������ > 0 �� �͸� ��ǥó��
//	
//////////////////////////////////////////////////////////////////
dec		dOutQty, dIsQty, dQty, dTemp_OutQty
long		lRow,	lCount


FOR	lRow = 1		TO		dw_list.RowCount()

	dQty  = dw_list.GetItemDecimal(lRow, "qty")			// ����û����
	dIsQty  = dw_list.GetItemDecimal(lRow, "btqty")		// ��������	
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
		if dOutQty < 1 then
			f_message_chk(1400, '[������]')
			return -1
		else
			lCount++
		end if
	END IF

NEXT



IF lCount < 1		THEN	RETURN -1

RETURN 1
end function

public function integer wf_initial ();
dw_detail.setredraw(false)
dw_1.reset()
dw_2.reset()
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()
dw_imhist_in.reset()

// �԰�â��
datawindowchild state_child, st_child
integer 	rtncode


rtncode = dw_detail.GetChild("house", state_child)
IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - �԰�â��")
state_child.SetTransObject(SQLCA)
state_child.Retrieve( gs_saupj)

if ic_status = '1' then
	rtncode = dw_detail.GetChild("ittyp", st_child)
	IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ǰ�񱸺�")
	st_child.SetTransObject(SQLCA)
	st_child.Retrieve()
End if

dw_detail.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_detail.setfocus()
dw_detail.setredraw(true)

p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\����_d.gif'
dw_detail.enabled = TRUE


dw_detail.insertrow(0)
////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

   if rb_1.checked then 
		dw_detail.setitem(1, 'project', is_pordno)
		dw_detail.setitem(1, 'house', is_house)
		dw_detail.setitem(1, 'empno', is_empno)
		dw_detail.setitem(1, 'name',  is_empnm)
		dw_detail.setcolumn("PROJECT")
	else
		dw_detail.setcolumn("fdate")
		dw_detail.SetItem(1, "Fdate", is_Date)
		dw_detail.SetItem(1, "tdate", is_Date)
   end if		
	dw_detail.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "���"
//	cb_3.enabled = true

ELSE
	dw_detail.setcolumn("OUT_JPNO")

	w_mdi_frame.sle_msg.text = "����"
//	cb_3.enabled = false
	
END IF

return  1

end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. �����HISTORY ����
//
///////////////////////////////////////////////////////////////////////

dec		dOutQty, dNotOutQty, dTempQty
string	sHist_Jpno, sDelyn
long		lRow, lRowCount

SetPointer(HourGlass!)

if dw_list.accepttext() = -1 then return -1

lRowCount = dw_list.RowCount()

FOR lrow = 1 to lRowCount
	
	 // ����ǥ�õ� ������ ������
	 if dw_list.getitemstring(Lrow, "delgu") = 'N' then continue
	
	 sHist_Jpno = dw_list.GetItemString(lrow, "imhist_iojpno")
	 sDelyn    = dw_list.GetItemString(lrow, "delyn")
	 
	 /* ��� �԰����� ���ε��� ���� ��� */
	 if sDelyn = 'Y' then
	 
		  DELETE FROM "IMHIST"  
   		WHERE "IMHIST"."SABU" = :gs_sabu
			  AND "IMHIST"."IOJPNO" = :sHist_Jpno   ;
			  
			IF SQLCA.SQLNROWS <> 1	THEN
				ROLLBACK;
				f_Rollback();
				RETURN -1
			END IF			  
			  
		  DELETE FROM "IMHIST"  
   		WHERE "IMHIST"."SABU"    = :gs_sabu
			  and "IMHIST"."IP_JPNO" = :sHist_Jpno   
			  and "IMHIST"."JNPCRT"  = '011' ;		/* ��� ���(�Ҵ�)���� ��ϵ� �ڷḸ ���� */

			IF SQLCA.SQLCODE < 0	THEN
				ROLLBACK;
				messagebox('Ȯ ��','��� �԰���ǥ ������ �����Ͽ����ϴ�.!')
				RETURN -1
			END IF			  
	 Else
		MessageBox('Ȯ��','���԰˻糪 �԰���ε� �ڷ��Դϴ�.!!')
		
	 End if
Next
////////////////////////////////////////////////////////////////////////


RETURN 1

end function

public function integer wf_qcgub ();string	sItem, 		&
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
	sCust  = '' //dw_list.GetItemString(lRow, "cvcod")
	sStock = dw_list.GetItemString(lRow, "grpno2")
	sOpseq = '9999' //dw_list.GetItemString(lRow, "opseq")
	
  SELECT "DANMST"."QCEMP",   
         "DANMST"."QCGUB"  
    INTO :sEmpno,   
         :sGubun  
    FROM "DANMST"  
   WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
         ( "DANMST"."CVCOD" = :sCust ) AND ("DANMST"."OPSEQ" = :sOpseq )  ;
			
	IF SQLCA.SQLCODE <> 0	THEN
		SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
        INTO :sgubun,  :sempno    
        FROM "ITEMAS"  
       WHERE "ITEMAS"."ITNBR" = :sitem ;
		
		if sgubun = '' or isnull(sgubun) then 
			dw_list.SetItem(lRow, "qcgubun", '4')		// ��ٷο� �˻�
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
		IF Isnull(sGubun)		THEN	sGubun = '4'
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

	// �԰��� �˻�ǰ�� �ƴ� ��� ������ ���˻�
	if isnull(sstock) or trim(sStock) = '' or  sStock <> 'Y' then
		sStock = 'N'
	end if
	
	IF sStock = 'N'	THEN	
		dw_list.SetItem(lRow, "qcgubun", '1')
		dw_list.Setitem(lrow, "empno", snull)
	End if

//	dw_list.setitem(lrow, "qcsugbn", is_qccheck)		// �˻籸�� ��������
	
NEXT

RETURN 1


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
//������ �Ҵ籸��(1:�������,2:����û), ��������� ��� �԰�â��� out_store, ����û�� in_store��
select dataname into :is_holdgu from syscnfg where sysgu = 'Y' and serial = 15 and lineno = 8;
If IsNull(is_holdgu) Then is_holdgu = '1'

// datawindow initial value
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")
end event

on w_pdt_04040.create
this.dw_lot=create dw_lot
this.st_3=create st_3
this.st_2=create st_2
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.p_print=create p_print
this.cb_3=create cb_3
this.cb_2=create cb_2
this.dw_imhist=create dw_imhist
this.dw_imhist_in=create dw_imhist_in
this.dw_print=create dw_print
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.rr_1=create rr_1
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
this.rr_6=create rr_6
this.gb_1=create gb_1
this.rr_2=create rr_2
this.dw_list=create dw_list
this.Control[]={this.dw_lot,&
this.st_3,&
this.st_2,&
this.p_3,&
this.p_2,&
this.p_1,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.p_print,&
this.cb_3,&
this.cb_2,&
this.dw_imhist,&
this.dw_imhist_in,&
this.dw_print,&
this.cbx_1,&
this.cb_1,&
this.dw_2,&
this.dw_1,&
this.rb_2,&
this.rb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.rr_1,&
this.rr_3,&
this.rr_4,&
this.rr_5,&
this.rr_6,&
this.gb_1,&
this.rr_2,&
this.dw_list}
end on

on w_pdt_04040.destroy
destroy(this.dw_lot)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.p_print)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.dw_imhist)
destroy(this.dw_imhist_in)
destroy(this.dw_print)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.rr_6)
destroy(this.gb_1)
destroy(this.rr_2)
destroy(this.dw_list)
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
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_lot from datawindow within w_pdt_04040
boolean visible = false
integer x = 2002
integer y = 36
integer width = 1472
integer height = 120
integer taborder = 10
string title = "none"
string dataobject = "d_sal_02040_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_pdt_04040
integer x = 3653
integer y = 2080
integer width = 457
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "�Ҵ��ȣ ����"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_04040
integer x = 55
integer y = 2076
integer width = 457
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "�԰�â�� ����"
boolean focusrectangle = false
end type

type p_3 from uo_picture within w_pdt_04040
boolean visible = false
integer x = 242
integer y = 44
integer width = 178
boolean enabled = false
boolean originalsize = true
string picturename = "C:\Erpman\image\�����ʱ�ȭ_up.gif"
end type

event clicked;call super::clicked;long lcount, k

lcount = dw_list.rowcount()

FOR k = 1 TO lcount
    dw_list.setitem(k, 'outqty', 0) 					
NEXT

end event

type p_2 from uo_picture within w_pdt_04040
integer x = 3712
integer y = 20
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\�Ϸ�����_up.gif"
end type

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_list.AcceptText() = -1		THEN	RETURN

string  shold_no, sBuwan, sOld_buwan
long	  lcount, k

IF Messagebox('�Ϸ�����','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) <> 1 THEN Return

lcount = dw_list.rowcount()

FOR k = 1 TO lcount 
	sHold_no   = dw_list.GetItemString(k, "hold_no")
	sBuwan     = dw_list.GetItemString(k, "buwan")
	sold_Buwan = dw_list.GetItemString(k, "old_buwan")
	
	if isnull(sOld_buwan) then sOld_buwan = 'N'
	if isnull(sbuwan) then sbuwan = 'N'
	IF sBuwan <> sOld_buwan THEN 
		UPDATE "HOLDSTOCK"  
			SET "BUWAN" = :sBuwan  
		 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND  
				 ( "HOLDSTOCK"."HOLD_NO" = :shold_no )   ;

		if sqlca.sqlcode < 0 or sqlca.sqlnrows < 1 then 
			messagebox("Ȯ ��", "�Ҵ��ڷ� ������ �����Ͽ����ϴ�.")
			rollback; 
		end if	
	END IF		
NEXT

COMMIT;

end event

type p_1 from uo_picture within w_pdt_04040
boolean visible = false
integer x = 55
integer y = 44
integer width = 178
boolean enabled = false
string picturename = "C:\Erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;OPEN(W_MAT_03550)
end event

type p_exit from uo_picture within w_pdt_04040
integer x = 4407
integer y = 20
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("����") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_can from uo_picture within w_pdt_04040
integer x = 4233
integer y = 20
integer width = 178
integer taborder = 70
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

type p_del from uo_picture within w_pdt_04040
integer x = 4059
integer y = 20
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	
	rollback;
	RETURN
end if


COMMIT;

p_can.TriggerEvent("clicked")
	
	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_mod from uo_picture within w_pdt_04040
integer x = 3886
integer y = 20
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sarg_sdate, shold_no, sBuwan, sOld_buwan
sdate  = trim(dw_detail.GetItemstring(1, "Edate"))			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ���� = 0		-> RETURN
//		2. �����HISTORY : ��ǥä������('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 

IF f_msg_update() = -1 	THEN	RETURN

p_2.triggerevent(clicked!)

/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN

	if wf_imhist_create(sarg_sdate) = -1 then return
	
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

	IF wf_imhist_update() = -1	THEN	RETURN

END IF

////////////////////////////////////////////////////////////////////////

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_inq from uo_picture within w_pdt_04040
integer x = 3538
integer y = 20
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

if 	dw_detail.Accepttext() = -1	then 	return

string  	sProject, sOutJpno, sDate, sFDate, sTdate, sHouse, sEmpno, sNull, sittyp, Shold_gu

SetNull(sNull)

SetPointer(HourGlass!)

IF 	rb_insert.checked Then
	sDate	   = trim(dw_detail.getitemstring(1, "edate"))	// �������
	sHouse  	= dw_detail.getitemstring(1, "house")			// ���â��
	sEmpno  	= dw_detail.getitemstring(1, "empno")			// �����
	sIttyp   = dw_detail.getitemstring(1, "ittyp")			// ǰ�񱸺�
	
	if rb_2.Checked = True then
		Shold_gu = dw_detail.getitemstring(1, "hold_gu")+ '%' // ��û����
		
		if Isnull(Shold_gu) or Shold_gu= '' then
			Shold_gu = '%'
		end if
	end if

	IF 	isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[�������]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

   	if 	rb_1.checked THEN
				sProject = dw_detail.getitemstring(1, "project")		// �۾����ù�ȣ
		
				IF 	isnull(sProject) or sProject = "" 	THEN
					f_message_chk(30,'[�۾����ù�ȣ]')
					dw_detail.SetColumn("project")
					dw_detail.SetFocus()
					RETURN
				END IF
   	else
				sfDate  = trim(dw_detail.getitemstring(1, "fdate"))
				stDate  = trim(dw_detail.getitemstring(1, "tdate"))
				IF isnull(sfDate) or sfDate = "" 	THEN sfdate = '10000101'
				IF isnull(stDate) or stDate = "" 	THEN stdate = '99991231'
				
				if 	sfdate > stdate then 
					f_message_chk(34,'[���䱸��]')
					dw_detail.SetColumn("fdate")
					dw_detail.SetFocus()
					RETURN
				end if	
   	end if		

	IF 	isnull(sHouse) or sHouse = "" 	THEN
		f_message_chk(30,'[���â��]')
		dw_detail.SetColumn("house")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[����ڹ�ȣ]')
		dw_detail.SetColumn("empno")
		dw_detail.SetFocus()
		RETURN
	END IF

  	if sittyp = '' or isnull(sittyp) then 
		dw_list.SetFilter(" (qty  -  btqty)  > 0")
		dw_list.Filter()
	else
		dw_list.SetFilter(" ( qty  -  btqty ) > 0  and ittyp = '"+ sittyp +"'")
		dw_list.Filter()
	end if

   	if 	rb_1.checked THEN
				IF	dw_list.Retrieve(gs_sabu,gs_saupj, sProject, sHouse+'%', gs_saupj) <	1		THEN
					f_message_chk(50, '[���-�Ҵ�]')
					dw_detail.setcolumn("Project")
					dw_detail.setfocus()
					return
				END IF
		
				wf_jego_qty()
	
   	else
				IF	dw_list.Retrieve(gs_sabu, gs_saupj, sfdate, stdate, sHouse, sHold_gu+'%', gs_saupj) <	1		THEN
					f_message_chk(50, '[���-�Ҵ�]')
					dw_detail.setcolumn("fdate")
					dw_detail.setfocus()
					return
				END IF
	   end if
	
	wf_set_qty()
	
	// �˻籸�� ����
	wf_qcgub()

ELSE
  	sOutJpno = dw_detail.getitemstring(1, "out_jpno")	+ '%'	// ����ȣ

	IF isnull(sOutJpno) or sOutJpno = "" 	THEN
		f_message_chk(30,'[����ȣ]')
		dw_detail.SetColumn("out_jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	dw_list.Retrieve(gs_sabu, sOutjpno) <	1		THEN
		f_message_chk(50, '[���-�Ҵ�]')
		dw_detail.setcolumn("out_jpno")
		dw_detail.setfocus()
		return
	END IF

	// ������忡���� ��������
//	cb_delete.enabled = true	
   	p_del.enabled = true
   	p_del.picturename = "C:\erpman\image\����_up.gif"
	
END IF
//////////////////////////////////////////////////////////////////////////
dw_detail.enabled = false

dw_list.SetColumn("outqty")
dw_list.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

type p_print from uo_picture within w_pdt_04040
boolean visible = false
integer x = 2811
integer y = 2896
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\�μ�_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�μ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�μ�_up.gif"
end event

type cb_3 from commandbutton within w_pdt_04040
boolean visible = false
integer x = 3895
integer y = 2880
integer width = 343
integer height = 108
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����ʱ�ȭ"
end type

event clicked;long lcount, k

lcount = dw_list.rowcount()

FOR k = 1 TO lcount
    dw_list.setitem(k, 'outqty', 0) 					
NEXT

end event

type cb_2 from commandbutton within w_pdt_04040
boolean visible = false
integer x = 3547
integer y = 2880
integer width = 334
integer height = 108
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�Ϸ�����"
end type

event clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_list.AcceptText() = -1		THEN	RETURN

string  shold_no, sBuwan, sOld_buwan
long	  lcount, k

IF Messagebox('�Ϸ�����','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) <> 1 THEN Return

lcount = dw_list.rowcount()

FOR k = 1 TO lcount 
	sHold_no   = dw_list.GetItemString(k, "hold_no")
	sBuwan     = dw_list.GetItemString(k, "buwan")
	sold_Buwan = dw_list.GetItemString(k, "old_buwan")
	
	if isnull(sOld_buwan) then sOld_buwan = 'N'
	if isnull(sbuwan) then sbuwan = 'N'
	IF sBuwan <> sOld_buwan THEN 
		UPDATE "HOLDSTOCK"  
			SET "BUWAN" = :sBuwan  
		 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND  
				 ( "HOLDSTOCK"."HOLD_NO" = :shold_no )   ;

		if sqlca.sqlcode < 0 or sqlca.sqlnrows < 1 then 
			messagebox("Ȯ ��", "�Ҵ��ڷ� ������ �����Ͽ����ϴ�.")
			rollback; 
		end if	
	END IF		
NEXT

COMMIT;

end event

type dw_imhist from datawindow within w_pdt_04040
boolean visible = false
integer x = 2158
integer y = 12
integer width = 1385
integer height = 412
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

type dw_imhist_in from datawindow within w_pdt_04040
boolean visible = false
integer x = 768
integer y = 2604
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

type dw_print from datawindow within w_pdt_04040
boolean visible = false
integer x = 631
integer y = 32
integer width = 2226
integer height = 152
boolean titlebar = true
string title = "�Ҵ���� ���"
string dataobject = "d_mat_03550_03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_pdt_04040
integer x = 3127
integer y = 320
integer width = 512
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����� �ڵ���� ����"
end type

type cb_1 from commandbutton within w_pdt_04040
boolean visible = false
integer x = 3200
integer y = 2880
integer width = 334
integer height = 108
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����(&P)"
end type

event clicked;OPEN(W_MAT_03550)
end event

type dw_2 from datawindow within w_pdt_04040
integer x = 3639
integer y = 2144
integer width = 919
integer height = 156
string dataobject = "d_pdt_04040_2"
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_pdt_04040
integer x = 50
integer y = 2140
integer width = 2848
integer height = 156
string dataobject = "d_pdt_04040_1"
boolean border = false
boolean livescroll = true
end type

type rb_2 from radiobutton within w_pdt_04040
boolean visible = false
integer x = 73
integer y = 44
integer width = 521
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "���䱸���� ��"
boolean checked = true
end type

event clicked;dw_detail.setredraw(false)

dw_detail.DataObject = 'd_pdt_04041_1'
dw_list.DataObject = 'd_pdt_04040_0'

wf_Initial()
end event

type rb_1 from radiobutton within w_pdt_04040
boolean visible = false
integer x = 73
integer y = 108
integer width = 521
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "�۾����ù�ȣ ��"
end type

event clicked;
dw_detail.setredraw(false)

dw_detail.DataObject = 'd_pdt_04041'
dw_list.DataObject = 'd_pdt_04040'


//dw_list.object.ispec_t.text = is_ispec
//dw_list.object.jijil_t.text = is_jijil

wf_Initial()
end event

type cb_delete from commandbutton within w_pdt_04040
boolean visible = false
integer x = 2304
integer y = 2588
integer width = 334
integer height = 108
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "����(&D)"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	
	rollback;
	RETURN
end if


COMMIT;

cb_cancel.TriggerEvent("clicked")
	
	

end event

type cb_cancel from commandbutton within w_pdt_04040
boolean visible = false
integer x = 2793
integer y = 2616
integer width = 334
integer height = 108
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type rb_delete from radiobutton within w_pdt_04040
integer x = 4329
integer y = 332
integer width = 224
integer height = 48
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

dw_detail.setredraw(false)

dw_detail.DataObject = 'd_pdt_04041_2'

dw_list.DataObject = 'd_pdt_04042'


rb_1.Enabled = false
rb_2.Enabled = false

wf_Initial()
end event

type rb_insert from radiobutton within w_pdt_04040
integer x = 4329
integer y = 252
integer width = 224
integer height = 48
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

rb_1.Enabled = true
rb_2.Enabled = true

dw_detail.setredraw(false)

//�Ҵ籸��(is_holdgu-1:�������,2:����û)�� ���� ��������� ��� �԰�â��� out_store, ����û�� in_store��
//datawindow�����ؾ���... ���� �ݿ����� ����... ���� 2�� ����û�� ���ؼ��� �ݿ��� �����̸� 1�� ���� ��Ű�� dw����ϸ��
if rb_1.checked then 
	dw_detail.DataObject = 'd_pdt_04041'
	dw_list.DataObject = 'd_pdt_04040'
else	
	dw_detail.DataObject = 'd_pdt_04041_1'
	dw_list.DataObject = 'd_pdt_04040_0'
end if

//dw_detail.SetTransObject(sqlca)
//dw_list.SetTransObject(sqlca)
//dw_detail.setredraw(true)


wf_Initial()
end event

type dw_detail from datawindow within w_pdt_04040
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 78
integer y = 232
integer width = 3301
integer height = 168
integer taborder = 10
string dataobject = "d_pdt_04041_1"
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

event itemchanged;string	sDate, sConfirm,		&
			sDept, sDeptName, 	&
			sHouse,					&
			sEmpno,sEmpname,		&
			sHist_jpno,	&
			sProject,				&
			sNull, scode, sname, sname2, spass
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
	
//	IF is_Date > sDate	THEN
//		MessageBox("Ȯ��", "������ڴ� �������ں��� Ŭ �� �����ϴ�.")
//		this.setitem(1, "edate", is_Date)
//		return 1
//	END IF
//	
ELSEIF this.getcolumnname() = "project"	then

	sProject = trim(this.gettext()) 
	
	if sProject = '' or isnull(sProject) then 
		this.setitem(1, "deptname", sNull)
		return 
   end if		

	is_pordno = sProject
	
   SELECT "MOMAST"."PORDNO"  
     INTO :sConfirm  
     FROM "MOMAST"  
    WHERE ( "MOMAST"."SABU" 	= :gs_sabu ) AND  
          ( "MOMAST"."PORDNO"  = :sProject ) ;   
//          ( "MOMAST"."PDSTS" in ('1','2') )   ;

	IF sqlca.sqlcode = 100 		THEN
		Messagebox("Ȯ��","���õ� ������ �������ð� �ƴմϴ�.")
		this.setitem(1, "project", sNull)
		this.setitem(1, "deptname", sNull)
		return 1
	elseif sqlca.sqlcode <> 0 then
		Messagebox("Ȯ��","�۾����� ������ �����ϴ�.")
		this.setitem(1, "project", sNull)
		this.setitem(1, "deptname", sNull)
		return 1		
	END IF
	
   SELECT "VNDMST"."CVNAS"  
     INTO :sDeptName  
	  FROM "HOLDSTOCK", "VNDMST"  
    WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND  
          ( "HOLDSTOCK"."PORDNO"   = :sProject ) AND 		
			 ( "HOLDSTOCK"."REQ_DEPT" = "VNDMST"."CVCOD" ) AND ROWNUM = 1 ;
//   GROUP BY SUBSTR("HOLDSTOCK"."HOLD_NO",1,12),   "VNDMST"."CVNAS"  			;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[�۾����ù�ȣ ���� �Ҵ�]')
		this.setitem(1, "PROJECT", sNull)
		this.setitem(1, "deptname", sNull)
		return 1
	end if

	this.SetItem(1, "deptname", sDeptName)
	
ELSEIF this.GetColumnName() = 'house' THEN
	sHouse = this.gettext()
	is_house = sHouse
	
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
		is_house = snull
		is_empno = snull
		is_empnm = snull
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			is_house = snull
			is_empno = snull
			is_empnm = snull
			return 1
      END IF		
	END IF

	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	is_empno = snull
	is_empnm = snull
	
ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sname)
		is_empno = snull
		is_empnm = snull
      return 
   end if
   this.accepttext()
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("Ȯ ��", "â�� ���� �Է��ϼ���")
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		is_empno = snull
		is_empnm = snull
		return 1
	end if
	
   ireturn = f_get_name2('��������', 'Y', scode, sname, sname2)    //1�̸� ����, 0�� ����	

	is_empno = scode
	is_empnm = sname
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
	

ELSEIF this.getcolumnname() = "out_jpno"	then
//////////////////////////////////////////////////////////////////////////////
// ����ȣ(�����history)
//////////////////////////////////////////////////////////////////////////////
	sHist_Jpno = trim(this.GetText())	

   setnull(is_pordno)

	if sHist_Jpno = '' or isnull(sHist_Jpno) then 
		this.SetItem(1, "edate",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.SetItem(1, "house", snull)
		return 
   end if		

   SELECT A.INSDAT, A.IO_EMPNO,	B.EMPNAME, A.DEPOT_NO
 	  INTO :sDate, :sEmpno, :sEmpname, :sHouse
	  FROM IMHIST A, P1_MASTER B
	 WHERE A.SABU	= :gs_sabu	AND  A.IOJPNO like :sHist_Jpno||'%' 	
	   AND A.JNPCRT LIKE '002'    AND  A.IO_EMPNO = B.EMPNO(+)  AND ROWNUM = 1	;
	
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[����ȣ]')
		this.setitem(1, "out_jpno", sNull)
		this.SetItem(1, "edate",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "name", snull)
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
		this.SetItem(1, "edate",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "house", snull)
		this.SetItem(1, "name", snull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "out_jpno", sNull)
			this.SetItem(1, "edate",  snull)
			this.SetItem(1, "empno", snull)
			this.SetItem(1, "house", snull)
			this.SetItem(1, "name", snull)
			return 1
      END IF		
	END IF

	this.SetItem(1, "edate",  sDate)
	this.SetItem(1, "empno", sEmpno)
	this.SetItem(1, "name", sEmpname)
	this.SetItem(1, "house", sHouse)
ELSEIF this.GetColumnName() = 'fdate' THEN

	sDate = trim(this.gettext())
	
	if isnull(sDate) or sDate = '' then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[���䱸��]')
		this.setitem(1, "fdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'tdate' THEN

	sDate = trim(this.gettext())
	
	if isnull(sDate) or sDate = '' then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[���䱸��]')
		this.setitem(1, "tdate", sNull)
		return 1
	END IF
	
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;string  shouse, spass

gs_code = ''
gs_codename = ''
gs_gubun = ''

// �����δ����
IF this.GetColumnName() = 'empno'	THEN
	this.accepttext() 
   gs_gubun = '4' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code

	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

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

	is_house = gs_gubun
	is_empno = gs_code
	is_empnm = gs_codename
 
	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno",gs_code)
	SetItem(1,"name",gs_codename)
	
// ����ȣ(�Ҵ� ��ȸ)
elseif this.getcolumnname() = "out_jpno" 	then

	gs_gubun = '002'
	open(w_chulgo_popup2)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "out_jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
	RETURN 1
	
// �۾����ù�ȣ
elseif this.getcolumnname() = "project" 	then

	gs_gubun = '30' 
	open(w_jisi_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "project", gs_code)
	this.triggerevent("itemchanged")
	RETURN 1
end if

end event

type cb_save from commandbutton within w_pdt_04040
boolean visible = false
integer x = 1961
integer y = 2588
integer width = 334
integer height = 108
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sarg_sdate, shold_no, sBuwan, sOld_buwan
sdate  = trim(dw_detail.GetItemstring(1, "Edate"))			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ���� = 0		-> RETURN
//		2. �����HISTORY : ��ǥä������('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq

IF	wf_CheckRequiredField() = -1		THEN	RETURN 

IF f_msg_update() = -1 	THEN	RETURN

cb_2.triggerevent(clicked!)

/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN

	if wf_imhist_create(sarg_sdate) = -1 then return
	
	if cbx_1.checked then 
		dw_print.setfilter("ioseq <> '999'")
		dw_print.filter()	
		dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate)
		dw_print.print()
   end if      										 

/////////////////////////////////////////////////////////////////////////
//	1. ���� : �Ҵ�TABLE(������, ��������, �Ϸᱸ��)
//				 �����HISTORY(������)
/////////////////////////////////////////////////////////////////////////
ELSE

	IF wf_imhist_update() = -1	THEN	RETURN

END IF

////////////////////////////////////////////////////////////////////////

cb_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from commandbutton within w_pdt_04040
event key_in pbm_keydown
boolean visible = false
integer x = 3141
integer y = 2616
integer width = 334
integer height = 108
integer taborder = 100
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_pdt_04040
boolean visible = false
integer x = 1618
integer y = 2588
integer width = 334
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȸ(&R)"
end type

event clicked;	
if dw_detail.Accepttext() = -1	then 	return

string  	sProject,	&
			sOutJpno,	&
			sDate,		&
			sFDate, sTdate, 	&
			sHouse, sEmpno,	&
			sNull, sittyp
SetNull(sNull)

SetPointer(HourGlass!)

IF rb_insert.checked Then
	sDate	   = trim(dw_detail.getitemstring(1, "edate"))			// �������
	sHouse  	= dw_detail.getitemstring(1, "house")			// ���â��
	sEmpno  	= dw_detail.getitemstring(1, "empno")			// �����
	sIttyp   = dw_detail.getitemstring(1, "ittyp")			// ǰ�񱸺�

	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[�������]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

   if rb_1.checked THEN
		sProject = dw_detail.getitemstring(1, "project")		// �۾����ù�ȣ

		IF isnull(sProject) or sProject = "" 	THEN
			f_message_chk(30,'[�۾����ù�ȣ]')
			dw_detail.SetColumn("project")
			dw_detail.SetFocus()
			RETURN
		END IF
   else
		sfDate  = trim(dw_detail.getitemstring(1, "fdate"))
		stDate  = trim(dw_detail.getitemstring(1, "tdate"))
		IF isnull(sfDate) or sfDate = "" 	THEN sfdate = '10000101'
		IF isnull(stDate) or stDate = "" 	THEN stdate = '99991231'
		
		if sfdate > stdate then 
			f_message_chk(34,'[���䱸��]')
			dw_detail.SetColumn("fdate")
			dw_detail.SetFocus()
			RETURN
		end if	
   end if		

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

   if sittyp = '' or isnull(sittyp) then 
		dw_list.SetFilter("unqty > 0")
		dw_list.Filter()
	else
		dw_list.SetFilter("unqty > 0  and ittyp = '"+ sittyp +"'")
		dw_list.Filter()
	end if

   if rb_1.checked THEN
		IF	dw_list.Retrieve(gs_sabu, sProject, sHouse) <	1		THEN
			f_message_chk(50, '[���-�Ҵ�]')
			dw_detail.setcolumn("Project")
			dw_detail.setfocus()
			return
		END IF

		wf_jego_qty()
	
   else
		IF	dw_list.Retrieve(gs_sabu, sfdate, stdate, sHouse) <	1		THEN
			f_message_chk(50, '[���-�Ҵ�]')
			dw_detail.setcolumn("fdate")
			dw_detail.setfocus()
			return
		END IF
	end if
	
	wf_set_qty()

ELSE
   sOutJpno = dw_detail.getitemstring(1, "out_jpno")		// ����ȣ

	IF isnull(sOutJpno) or sOutJpno = "" 	THEN
		f_message_chk(30,'[����ȣ]')
		dw_detail.SetColumn("out_jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sOutJpno = sOutJpno + '%'
	dw_list.SetFilter("")
	dw_list.Filter()

	IF	dw_list.Retrieve(gs_sabu, sOutjpno) <	1		THEN
		f_message_chk(50, '[���-�Ҵ�]')
		dw_detail.setcolumn("out_jpno")
		dw_detail.setfocus()
		return
	END IF

	// ������忡���� ��������
	cb_delete.enabled = true	
	
END IF
//////////////////////////////////////////////////////////////////////////
dw_detail.enabled = false

dw_list.SetColumn("outqty")
dw_list.SetFocus()

end event

type rr_1 from roundrectangle within w_pdt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4302
integer y = 220
integer width = 274
integer height = 192
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_pdt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 220
integer width = 3621
integer height = 192
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_pdt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 436
integer width = 4530
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_5 from roundrectangle within w_pdt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 2136
integer width = 2871
integer height = 168
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_6 from roundrectangle within w_pdt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3625
integer y = 2136
integer width = 946
integer height = 168
integer cornerheight = 40
integer cornerwidth = 46
end type

type gb_1 from groupbox within w_pdt_04040
boolean visible = false
integer x = 55
integer y = 228
integer width = 558
integer height = 164
integer taborder = 90
integer textsize = -2
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
end type

type rr_2 from roundrectangle within w_pdt_04040
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 4
integer width = 608
integer height = 192
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from u_d_select_sort within w_pdt_04040
integer x = 55
integer y = 448
integer width = 4507
integer height = 1608
integer taborder = 30
string dataobject = "d_pdt_04040_0"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;IF row < 1	THEN	RETURN
	
string	sItem, sHouse, sHoldno, sIspec

sItem   = this.GetItemString(row, "itnbr")
sIspec  = this.GetItemString(row, "pspec")
If is_holdgu = '1' Then
	sHouse  = this.GetItemString(row, "out_store")
Else
	sHouse  = this.GetItemString(row, "in_store")
End If
sHoldno = this.GetItemString(row, "hold_no")

dw_1.Retrieve(gs_sabu, sItem, sHouse, sIspec)
dw_2.Retrieve(gs_sabu, sHoldno)
end event

event getfocus;call super::getfocus;IF this.getrow() < 1	THEN	RETURN
	
string	sItem, sHouse, sHoldno, sIspec, sOpseq

sItem   = this.GetItemString(this.getrow(), "itnbr")
sIspec  = this.GetItemString(this.getrow(), "pspec")
sHouse  = this.GetItemString(this.getrow(), "out_store")
sHoldno = this.GetItemString(this.getrow(), "hold_no")
sOpseq  = this.GetItemString(this.getrow(), "opseq")

dw_1.Retrieve(gs_sabu, sItem, sHouse, sIspec)
dw_2.Retrieve(gs_sabu, sHoldno)
end event

event itemchanged;call super::itemchanged;string	sNull, sHouse, sGub
long		lRow
dec{3}	dOutQty, dNotOutQty, dStock, dTempQty
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
	
// �ǹ�â���� ����â��� ���ÿ��� ���������� �˻����� �ʴ´�.
//	IF dOutQty > dNotOutQty		THEN
//		MessageBox("Ȯ��", "�������� ������������ Ŭ �� �����ϴ�.")
//		this.SetItem(lRow, "outqty", 0)
//		RETURN 1
//	END IF
// �˻籸��
ELSEIF this.GetColumnName() = 'qcgubun' THEN
	sGub  = this.gettext()
	
	if sGub = '1' then // ���˻�
   	this.setitem(lRow, "empno", sNull)
		if ic_status = '1' then //��Ͻ� 
//			this.setitem(lRow, "qcdate", sNull)
		else
			this.setitem(lRow, "imhist_gurdat", sNull)
		end if
	else
		if ic_status = '1' then //��Ͻ� 
//			this.setitem(lRow, "qcdate", is_today)
		else
			this.setitem(lRow, "imhist_gurdat", is_today)
		end if
	end if
END IF

end event

event itemerror;call super::itemerror;////////////////////////////////////////////////////////////////////////////
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

event losefocus;call super::losefocus;this.AcceptText()
end event

event buttonclicked;call super::buttonclicked;datawindow dwname	
Dec  dQty

If Row <= 0 Then Return

dwname = dw_lot

gs_gubun = dw_detail.GetItemString(1, 'house')
gs_code  = getitemstring(Row, "itnbr")
gs_codename = getitemstring(Row, "hold_no")
gs_codename2 = String(getitemnumber(Row, "unqty"))

openwithparm(w_stockwan_popup, dwname)
If IsNull(gs_code) Or Not IsNumber(gs_code) Then Return

SetItem(Row, 'outqty', Dec(gs_code))

setnull(gs_code)
end event

