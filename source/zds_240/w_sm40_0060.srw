$PBExportHeader$w_sm40_0060.srw
$PBExportComments$�ŷ�ó �ݼ��� �Ƿ�
forward
global type w_sm40_0060 from w_inherite
end type
type rr_2 from roundrectangle within w_sm40_0060
end type
type rb_insert from radiobutton within w_sm40_0060
end type
type rb_modify from radiobutton within w_sm40_0060
end type
type dw_1 from u_key_enter within w_sm40_0060
end type
type dw_print from datawindow within w_sm40_0060
end type
type dw_imhist from datawindow within w_sm40_0060
end type
type cb_1 from commandbutton within w_sm40_0060
end type
type st_2 from statictext within w_sm40_0060
end type
type rr_1 from roundrectangle within w_sm40_0060
end type
type rr_3 from roundrectangle within w_sm40_0060
end type
end forward

global type w_sm40_0060 from w_inherite
integer height = 2500
string title = "��ǰ�Ƿ� ���"
rr_2 rr_2
rb_insert rb_insert
rb_modify rb_modify
dw_1 dw_1
dw_print dw_print
dw_imhist dw_imhist
cb_1 cb_1
st_2 st_2
rr_1 rr_1
rr_3 rr_3
end type
global w_sm40_0060 w_sm40_0060

type variables

String is_insemp        // �˻�����
String is_iojpnoOK     //�������ȣ �ʼ�����
String isCursor 

end variables

forward prototypes
public subroutine wf_clear_item (integer icurrow)
public function integer wf_set_qc (integer nrow, string sitnbr)
public function integer wf_set_ip_jpno (integer nrow, string siojpno, string scvcodb, string saupj)
public function integer wf_create_imhist (string arg_iojpno)
public function integer wf_requiredchk (string sdwobject, integer icurrow)
public function integer wf_chk (integer nrow)
public subroutine wf_init ()
public function integer wf_create_imhist_oy4_after (long arg_row)
end prototypes

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec_code",snull)
dw_insert.SetItem(iCurRow,"itemas_filsk",snull)
dw_insert.SetItem(iCurRow,"itemas_itgu",snull)
dw_insert.SetItem(iCurRow,"ioprc",      0)
dw_insert.SetItem(iCurRow,"dcrate",     0)
dw_insert.SetItem(iCurRow,"dyebi3",     0)

dw_insert.SetItem(iCurRow,"insemp",snull)
dw_insert.SetItem(iCurRow,"qcgub",snull)

MessageBox('Ȯ��','�ش� ǰ���� �ܰ� ������ �����ϴ�.')

end subroutine

public function integer wf_set_qc (integer nrow, string sitnbr);/* ǰ������ �˻����ڹ� �˻��� Setting */
String sNull, sGu, sInsEmp, sQcGub

SetNull(sNull)

sGu = '1'
f_get_qc(sGu,sItnbr,sNull,sNull, sQcGub, sInsEmp )


dw_insert.SetItem(nRow,'insemp', sInsEmp )
dw_insert.SetItem(nRow,'qcgub', sQcGub )

Return 1

end function

public function integer wf_set_ip_jpno (integer nrow, string siojpno, string scvcodb, string saupj);Double dItemQty, dItemPrice, dDcRate, dVatAmt
String sCVcod, sItnbr, sNull
String sItemDsc, sItemSize, sItemUnit, sItemGbn, sItemUseYn, sItemFilsk, sItemitgu, sJijil, sIspecCode

SetNull(sNull)

/* �������� �ܰ��� ���� */
select x.cvcod, x.itnbr, x.ioreqty, x.ioprc,     y.dc_rate,	x.dyebi3
  into :sCvcod, :sitnbr, :dItemQty, :dItemprice, :dDcRate,  :dVatAmt
  from imhist x, sorder y, iomatrix i
 where x.sabu = y.sabu and
       x.order_no = y.order_no and
		 x.sabu = i.sabu and
		 x.iogbn = i.iogbn and
		 i.salegu = 'Y' and
		 i.jepumio = 'Y' and
		 y.oversea_gu = '1' and
       x.sabu = :gs_sabu and
		 x.iojpno = :siojpno and
		 x.saupj = :saupj;

IF Sqlca.sqlcode <> 0 THEN
	f_message_chk(33,'[�������ȣ]')
	dw_insert.SetItem(nRow,'ip_jpno',sNull)
	Return 1
END If

SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",   "ITEMAS"."UNMSR",		
		 "ITEMAS"."ITTYP", 	"ITEMAS"."USEYN",	  "ITEMAS"."FILSK",	"ITEMAS"."ITGU",
		 "ITEMAS"."JIJIL",   "ITEMAS"."ISPEC_CODE"
  INTO :sItemDsc,   		:sItemSize,   		  :sItemUnit,				
		 :sItemGbn,			:sItemUseYn,		  :sItemFilsk,			:sItemItgu ,
		 :sJijil,			:sIspecCode
  FROM "ITEMAS"
 WHERE "ITEMAS"."ITNBR" = :sItnbr;

IF Sqlca.sqlcode <> 0 THEN
	f_message_chk(33,'[�������ȣ]')
	dw_insert.SetItem(nRow,'ip_jpno',sNull)
	Return 1
END If
		
dw_insert.SetItem(nRow,'ioprc',      dItemPrice)
dw_insert.SetItem(nRow,'imhist_qty', dItemQty)
dw_insert.SetItem(nRow,'ioreqty',    dItemQty)
dw_insert.SetItem(nRow,"dcrate",     dDcRate)

/* �ݾ� ��� */
dw_insert.SetItem(nRow,"ioamt",dItemQty * dItemPrice)
dw_insert.SetItem(nRow,"dyebi3",dVatAmt)

dw_insert.SetItem(nRow,'ip_jpno',sIojpNo)

dw_insert.SetItem(nRow,'itnbr',			  sItnbr)
dw_insert.SetItem(nRow,"itemas_itdsc",   sItemDsc)
dw_insert.SetItem(nRow,"itemas_ispec",   sItemSize)
dw_insert.SetItem(nRow,"itemas_jijil",   sJijil)
dw_insert.SetItem(nRow,"itemas_ispec_code",   sIspecCode)
dw_insert.SetItem(nRow,"itemas_filsk",   sItemFilsk)
dw_insert.SetItem(nRow,"itemas_itgu",    sItemItgu)

/* �˻�����, �˻籸�� */
wf_set_qc(nRow, sItnbr)

Return 0
end function

public function integer wf_create_imhist (string arg_iojpno);// Ÿ���� ����� ��� ����


Return 1
end function

public function integer wf_requiredchk (string sdwobject, integer icurrow);String  sIoDate,sIoCust,sIoReDept,sIoReEmpNo,sIoDepotNo,sItem,sSpec,sBigo, sDepot
String  sIojpNo, sIogbn, sQcGub, sInsEmp, sNull, sSaleGu , sSaupj ,sCvcod ,sDate ,sfactory
String  ls_gubun , ls_bigo, sOutStore
		
Double  dQty,dPrc

If dw_1.AcceptText() < 1 Then Return -1
If dw_insert.AcceptText() < 1 Then Return -1

SetNull(sNull)

// ���ұ���
ls_gubun =  String(dw_1.Object.gubun[1])

// ���â��(��ü�� ���)
sOutStore =  String(dw_1.Object.out_store[1])

Choose Case sdwobject
	Case 'd_sm40_0060_1'

		sIoDate    = Trim(dw_1.GetItemString(1,"sudat"))
		
		IF sIoDate = "" OR IsNull(sIoDate) THEN
			f_message_chk(30,'[����]')
			dw_1.SetColumn("sudat")
			dw_1.SetFocus()
			Return -1
		END IF
		
		
		sSaupj = Trim(dw_1.GetItemString(1,'saupj'))
		If IsNull(sSaupj) or sSaupj = '' Then
			f_message_chk(30,'[�����]')
			dw_1.SetColumn("saupj")
			Return -1
		End If
		
		sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
		If IsNull(sCvcod) or sCvcod = '' Then
			f_message_chk(30,'[�ŷ�ó]')
			dw_1.SetColumn("cvcod")
			Return -1
		End If

		If ls_gubun = '4' Or ls_gubun = '5' Then
			If IsNull(sOutStore) or sOutStore = '' Then
				f_message_chk(30,'[��ü���â��]')
				dw_1.SetColumn("out_store")
				Return -1
			End If
		End If
		
		sDepot = Trim(dw_1.GetItemString(1, 'depot_no'))
		If IsNull(sDepot) or sDepot = '' Then
			f_message_chk(30,'[�԰�â��]')
			dw_1.SetColumn("depot_no")
			Return -1
		End If
		
		sFactory = dw_1.GetItemString(1, 'factory')
		If Trim(sFactory) = '' OR IsNull(sFactory) Then
			f_message_chk(30, '[����]')
			dw_1.SetColumn("factory")
			Return -1
		End If
  	Case 'd_sm40_0060_a'
		Long i
				
		For i = 1 To iCurRow
			
			sDate    = Trim(dw_insert.Object.sudat[i])
			sItem    = Trim(dw_insert.GetItemString(iCurRow,"itnbr"))
		   dQty     = dw_insert.GetItemNumber(iCurRow,"ioreqty")
			dPrc     = dw_insert.GetItemNumber(iCurRow,"ioprc")
			sfactory   = Trim(dw_insert.GetItemString(iCurRow,"facgbn"))
			
			dw_insert.SetFocus()
		
			IF sItem = "" OR IsNull(sItem) THEN
				f_message_chk(30,'[ǰ��]')
				dw_insert.SetColumn("itnbr")
				Return -1
			END IF
			
			IF sfactory = "" OR IsNull(sfactory) THEN
				f_message_chk(30,'[����]')
				dw_insert.SetColumn("facgbn")
				Return -1
			END IF
			
			IF sDate = "" OR IsNull(sDate) THEN
				f_message_chk(30,'[�Ƿ�����]')
				dw_insert.SetColumn("sudat")
				Return -1
			END IF
			
			IF dQty = 0 OR IsNull(dQty) THEN
				f_message_chk(30,'[����]')
				dw_insert.SetColumn("ioreqty")
				Return -1
			END IF
			
			
			If ls_gubun = '1' then
				sIogbn   = Trim(dw_insert.GetItemString(iCurRow,"iogbn"))
				
				IF sIogbn = "" OR IsNull(sIogbn) THEN
					f_message_chk(30,'[ó������]')
					dw_insert.SetColumn("iogbn")
					Return -1
				END IF
			ElseIf ls_gubun = '2' Then
				sIogbn   = Trim(dw_insert.GetItemString(iCurRow,"iogbn_temp1"))
				IF sIogbn = "" OR IsNull(sIogbn) THEN
					f_message_chk(30,'[ó������]')
					dw_insert.SetColumn("iogbn_temp1")
					Return -1
				END IF
				
				ls_bigo   = Trim(dw_insert.GetItemString(iCurRow,"bigo"))
				IF ls_bigo = "" OR IsNull(ls_bigo) THEN
					f_message_chk(30,'[���(��ǰ����)]')
					dw_insert.SetColumn("bigo")
					Return -1
				END IF
			Else
				ls_bigo   = Trim(dw_insert.GetItemString(iCurRow,"bigo"))
				IF ls_bigo = "" OR IsNull(ls_bigo) THEN
					f_message_chk(30,'[���(�ܰ��ұ� ����)]')
					dw_insert.SetColumn("bigo")
					Return -1
				END IF
			End If
			/* �ǸŹ�ǰ�� ��츸 �ܰ� Ȯ�� */
			
			IF dPrc = 0 OR IsNull(dPrc) THEN
				f_message_chk(30,'[�ܰ�]')
				dw_insert.SetColumn("ioprc")
				Return -1
			END IF
	   Next

END Choose

Return 1

end function

public function integer wf_chk (integer nrow);/* ----------------------------------------------------------------------------- */
/* �˻����  ���ҽ��� �˻����� ����� �������� ������ �Ƿڼ��� �հݼ��� ���Ҽ��� */
/* ----------------------------------------------------------------------------- */
/* ���˻�(1)   �ڵ�    sysdate  null   sysdate  null    qty       qty      qty   */
/* ���˻�(1)   ����    sysdate  null     null   null    qty       qty       0    */
/*   �˻�       -        null  insemp    null   null    qty        0        0    */
/* ----------------------------------------------------------------------------- */

String sInsDat, sQcGub, sIoConfirm, sIoDate, sCheckNo
String ls_iogbn

/* �˻����ھ����� �������� */

sQcGub  = Trim(dw_insert.GetItemString(nrow,'qcgub'))
sInsDat = Trim(dw_insert.GetItemString(nrow,'insdat'))
sIoDate = Trim(dw_insert.GetItemString(nrow,'io_date'))
sIoConFirm = Trim(dw_insert.GetItemString(nrow,'io_confirm'))

sCheckNo  = Trim(dw_insert.GetItemString(nrow,'checkno'))

/* ��꼭 ���� */
If Not IsNull(sCheckNo) Then Return -4

/* ���˻��ϰ�� */
If sqcgub = '1' Then
   If sIoConfirm = 'Y' Then
		return 0
	ElseIf IsNull(sIoDate) Then
		return 0
	Else
		return -1
	End If
Else
/* ���˻簡 �ƴѵ� �˻����ڰ� ������� �����Ұ� */
	If IsNull(sInsDat) or sInsDat = '' Then
		return 0
	Else
		return -2
	End If	
End If

Return -3
end function

public subroutine wf_init ();//If rb_insert.Checked = True Then
//	dw_insert.DataObject = 'd_sm40_0060_a'
//Else
//	dw_1.DataObject = 'd_sm40_0060_2'
//	dw_insert.DataObject = 'd_sm40_0060_b'
//End If

dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(SQLCA)

If rb_insert.Checked = True Then
	dw_1.settaborder("iojpno",0)
	dw_1.settaborder("sudat",10)
	dw_1.settaborder("factory",20)
	dw_1.settaborder("cvcod",30)

	dw_insert.settaborder("sudat",10)
	dw_insert.settaborder("itnbr",20)
	dw_insert.settaborder("iogbn_temp1",30)
	dw_insert.settaborder("ioreqty",40)
	dw_insert.settaborder("ioprc",50)
	dw_insert.settaborder("bigo",60)
Else
	dw_1.settaborder("iojpno",10)
	dw_1.settaborder("sudat",0)
	dw_1.settaborder("factory",0)
	dw_1.settaborder("cvcod",0)

	dw_insert.settaborder("sudat",0)
	dw_insert.settaborder("itnbr",0)
	dw_insert.settaborder("iogbn_temp1",0)
	dw_insert.settaborder("ioreqty",0)
	dw_insert.settaborder("ioprc",0)
	dw_insert.settaborder("bigo",10)
End If

dw_1.SetRedraw(False)
dw_1.Enabled = True
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1,"sudat",is_today)

dw_1.SetRedraw(True)


setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If
String sIogbn
sIogbn = Trim(dw_1.GetItemString(1,'gubun'))

If sIogbn = '2' Then
	dw_insert.Modify("iogbn.visible = 0 ")
	dw_insert.Modify("iogbn_temp1.visible = 1 ")
	dw_insert.Modify("iogbn_temp2.visible = 0 ")
//	dw_insert.Modify("ioprc.protect = 1")
	
End If
dw_insert.Reset()

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\�߰�_up.gif"

ib_any_typing = False

dw_1.SetFocus()

end subroutine

public function integer wf_create_imhist_oy4_after (long arg_row);// �ҷ������� ��� �ҷ�â�� �̵� ����� ���� - 2004.03.22 - �ۺ�ȣ

long		i, ll_maxjpno
string	ls_sudat, ls_saupj, ls_depot, ls_depot2, ls_iogbn, ls_iogbn1, ls_iogbn2, ls_jpno
string	ls_jnpcrt1, ls_jnpcrt2, ls_null

setnull(ls_null)
ls_sudat = Trim(dw_1.Object.sudat[1])
ls_saupj = Trim(dw_1.Object.saupj[1])

ls_depot 	= 'Z011'  // ��ǰ â��
ls_depot2	= 'Z019'  // �ҷ� â��

ls_iogbn1 	= 'O05'	// â���̵����
ls_jnpcrt1	= '001'

ls_iogbn2 	= 'I11'	// â���̵��԰�
ls_jnpcrt2	= '011'	// ��ܺҷ� ��ǰ ��˻��

// â�� �ڵ�ó�� ���� �˻� =========================================== 
// ��� â�� �˻�
SELECT cvcod  into :ls_depot
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '1'
	and sangsan is not null;
	
If ls_depot = '' Or isNull(ls_depot) Then
	If gs_saupj = '10' Then
		ls_depot = 'Z011'
	Else
		ls_depot = 'Z021'
	End iF
End If

// �԰� â�� �˻�
SELECT cvcod  into :ls_depot2
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '1'
	and sangsan is null;
	
If ls_depot2 = '' Or isNull(ls_depot2) Then
	If gs_saupj = '10' Then
		ls_depot2 = 'Z015'
	Else
		ls_depot2 = 'Z029'
	End iF
End If

//======================================================================

ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_maxjpno <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
commit;

ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
IF ls_jpno = "" OR IsNull(ls_jpno) THEN
	f_message_chk(51,'[��ǥ��ȣ]')
	Return -1
End If



/////////////////////////////////////////////////////////////////////////////////////////
// ��ǰâ��->�ҷ�â�� ����ڷ�

i = dw_imhist.insertrow(0)

dw_imhist.SetItem(i,"sabu",       gs_sabu)
dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(i,'000'))
dw_imhist.SetItem(i,"iogbn",      ls_iogbn1)
dw_imhist.SetItem(i,"itnbr",      dw_insert.GetItemString(arg_row,'itnbr'))
dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
dw_imhist.SetItem(i,"pspec",   	'.')
dw_imhist.SetItem(i,"opseq",		'9999')
dw_imhist.SetItem(i,"depot_no",   'Z011')				// ��ǰâ��
dw_imhist.SetItem(i,"cvcod",      'Z019')				// �ҷ�â��
dw_imhist.SetItem(i,"io_confirm", 'Y')
dw_imhist.SetItem(i,"filsk",      dw_insert.GetItemString(arg_row,'itemas_filsk'))      // ����������
dw_imhist.SetItem(i,"ioredept",   gs_dept)
dw_imhist.SetItem(i,"ioreemp",    gs_empno)
dw_imhist.SetItem(i,"saupj",      ls_saupj)
dw_imhist.SetItem(i,"inpcnf", 	 'O')   					// �������(�԰�)
dw_imhist.SetItem(i,"outchk",		 'N')
dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt1)	
dw_imhist.SetItem(i,"bigo",	 	 dw_insert.GetItemString(arg_row,'bigo'))

dw_imhist.SetItem(i,"ioreqty",    dw_insert.GetItemNumber(arg_row,"ioreqty"))
dw_imhist.SetItem(i,"ioqty",      dw_insert.GetItemNumber(arg_row,"ioreqty"))
dw_imhist.SetItem(i,"insdat",     ls_sudat)                                  // �˼����� 
dw_imhist.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(arg_row,"ioreqty")) // �հݼ���
dw_imhist.SetItem(i,"io_date",    ls_sudat)                                  // ��������
dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // �˻��պ����� 
dw_imhist.SetItem(i,"qcgub",'1')
dw_imhist.SetItem(i,"ip_jpno",	 dw_insert.GetItemString(arg_row,'iojpno'))	


/////////////////////////////////////////////////////////////////////////////////////////
// ��ǰâ��->�ҷ�â�� �԰��ڷ�

i = dw_imhist.insertrow(0)

dw_imhist.SetItem(i,"sabu",       gs_sabu)
dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(i,'000'))
dw_imhist.SetItem(i,"iogbn",      ls_iogbn2)
dw_imhist.SetItem(i,"itnbr",      dw_insert.GetItemString(arg_row,'itnbr'))
dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
dw_imhist.SetItem(i,"pspec",   	'.')
dw_imhist.SetItem(i,"opseq",		'9999')
dw_imhist.SetItem(i,"depot_no",   'Z019')				// �ҷ�â��
dw_imhist.SetItem(i,"cvcod",      'Z011')				// ��ǰâ��
dw_imhist.SetItem(i,"cust_no",    dw_insert.GetItemString(arg_row,'cvcod'))				// �ŷ�ó
dw_imhist.SetItem(i,"io_confirm", 'Y')
dw_imhist.SetItem(i,"filsk",      dw_insert.GetItemString(arg_row,'itemas_filsk'))      // ����������
dw_imhist.SetItem(i,"ioredept",   gs_dept)
dw_imhist.SetItem(i,"ioreemp",    gs_empno)
dw_imhist.SetItem(i,"saupj",      ls_saupj)
dw_imhist.SetItem(i,"inpcnf", 	 'I')   					// �������(�԰�)
dw_imhist.SetItem(i,"outchk",		 'N')
dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt2)
dw_imhist.SetItem(i,"bigo",	 	 dw_insert.GetItemString(arg_row,'bigo'))

dw_imhist.SetItem(i,"dyebi1",     dw_insert.GetItemNumber(arg_row,"ioprc"))
dw_imhist.SetItem(i,"dyebi2",     Truncate(dw_insert.GetItemNumber(arg_row,"ioreqty") * &
															 dw_insert.GetItemNumber(arg_row,"ioprc") , 0 ))

dw_imhist.SetItem(i,"ioreqty",    dw_insert.GetItemNumber(arg_row,"ioreqty"))
dw_imhist.SetItem(i,"ioqty",      0)
dw_imhist.SetItem(i,"insdat",     ls_null)                                  // �˼����� 
dw_imhist.SetItem(i,"iosuqty",    0) // �հݼ���
dw_imhist.SetItem(i,"io_date",    ls_null)                                  // ��������
//	dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // �˻��պ����� 
dw_imhist.SetItem(i,"qcgub",'2')
dw_imhist.SetItem(i,"ip_jpno",	 dw_insert.GetItemString(arg_row,'iojpno'))
	

Return 1
end function

on w_sm40_0060.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_insert=create rb_insert
this.rb_modify=create rb_modify
this.dw_1=create dw_1
this.dw_print=create dw_print
this.dw_imhist=create dw_imhist
this.cb_1=create cb_1
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_insert
this.Control[iCurrent+3]=this.rb_modify
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.dw_imhist
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_3
end on

on w_sm40_0060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rb_insert)
destroy(this.rb_modify)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.dw_imhist)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_print.SetTransObject(SQLCA)
dw_print.Reset()

dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

dw_imhist.SetTransObject(SQLCA)

/* �������ȣ �ʼ��Է� ���� */
select substr(dataname,1,1) into :is_IojpnoOK
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 30;

/* ǰ���Է½� Ŀ����ġ ���� - '1' : ǰ��, '2' : ǰ�� */
select substr(dataname,1,1) into :isCursor
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 12;

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)

//Wf_Init()

end event

type dw_insert from w_inherite`dw_insert within w_sm40_0060
integer x = 23
integer y = 340
integer width = 4567
integer height = 1960
integer taborder = 20
string dataobject = "d_sm40_0060_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;String  sNull, sIogbn,sItnbrUnit, sIttyp, sItnbruseyn, sItnbrfilsk, sItnbritgu, sItnbrYn, sOrderSpec
String  sIocust, sIocustname, sIojpno, scvcod, ssaupj, sDate
Dec  dItemQty,dDcRate,dNewDcRate,dTemp
Double dItemPrice
Long    nRow,iRtnValue,nCnt
String  sItnbr, sItdsc, sIspec, sJijil, sispeccode, sIoSpec, sGubun, sTaitnbr ,ls_curr

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

dw_1.AcceptText()
dw_insert.AcceptText()

Choose Case GetColumnName() 
	Case "itnbr"
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			Wf_Clear_Item(nRow)
			Return
		END IF
		
		sGubun = dw_1.GetItemString(1, 'gubun')
		
		SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",   "ITEMAS"."UNMSR",		
				 "ITEMAS"."ITTYP", 	"ITEMAS"."USEYN",	  "ITEMAS"."FILSK",	"ITEMAS"."ITGU",
				 "ITEMAS"."JIJIL", 	"ITEMAS"."ISPEC_CODE"
		  INTO :sItdsc,   			:sIspec,   		  	  :sItnbrUnit,
				 :sIttyp,				:sItnbrUseYn,		  :sItnbrFilsk,			:sItnbrItgu,
				 :sJijil,            :sIspeccode
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr ;
		  
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				Wf_Clear_Item(nRow)
				Return 1
			ELSE
				Return 1
			END IF
		ELSE
			// Ÿ���� ����� ���
			If sGubun = '4' Or sGubun = '5' Then
				If IsNull(sTaitnbr) Or Trim(sTaitnbr) = '' Then
					MessageBox('Ȯ ��','Ÿ���� ǰ���� �������� �ʾҽ��ϴ�.!!')
					Wf_Clear_Item(nRow)
					Return 1
				Else
					SetItem(nRow,"field_cd",   Trim(sTaitnbr))
				End If
			End If
			
		   scvcod = Trim(dw_1.Object.cvcod[1])
			
			sDate = dw_1.GetItemString(1,"sudat")
					
			dItemPrice = sqlca.Fun_Erp100000012_1(sdate,scvcod,sItnbr , '1') 
			
			IF dItemPrice <= 0 THEN
				SetItem(nRow,"ioprc",  0)
				Wf_Clear_Item(nRow)
				Return 1
			Else
				SetItem(nRow,"ioprc",  TrunCate(dItemPrice,2))
			End If

			SetItem(nRow,"itemas_itdsc",   sItdsc)
			SetItem(nRow,"itemas_ispec",   sIspec)
			SetItem(nRow,"itemas_jijil",   sJijil)
			SetItem(nRow,"itemas_ispec_code",   sIspecCode)
			SetItem(nRow,"itemas_filsk",   sItnbrFilsk)
			SetItem(nRow,"itemas_itgu",    sItnbrItgu)			
		End If
	Case "ioreqty"
	   String ls_iogbn 
		Dec    ld_ioreqty
		ls_iogbn = Trim(dw_1.Object.gubun[1])
		ld_ioreqty = Dec(GetText())
		If ls_iogbn = '3' Then
			IF ld_ioreqty < 0 THEN
				SetItem(nRow,"iogbn_temp2",   'OY6')
			ElseIf ld_ioreqty > 0 THEN
				SetItem(nRow,"iogbn_temp2",   'OY5')
			Else
				MessageBox('Ȯ��','��������  �����ϴ�.')
				Return 1
			END IF
		Else
			IF ld_ioreqty < 0 THEN
				MessageBox('Ȯ��','��������  �����ϴ�.')
				Return 1
			End If
		End if
			
END Choose
end event

event dw_insert::rbuttondown;Long    nRow
String  sCvcod,sItnbr, sSaupj

long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
lrow = this.GetRow()

str_code lst_code
Long i , ll_i = 0

dw_1.AcceptText()
Choose Case GetcolumnName() 
	Case "itnbr"
	  gs_code = Trim(dw_1.Object.cvcod[1])
		gs_codename = Trim(dw_1.Object.cvnas[1])
		
		IF gs_code = '' Or isNull(gs_code) Then
			MessageBox('Ȯ��','�ŷ�ó�� �����ϼ���')
			dw_insert.SetFocus()
			dw_insert.SetColumn("cvcod")
			Return
		End If
		
		Open(w_sm40_0040_popup02)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = lrow To UpperBound(lst_code.code) + lrow - 1
			ll_i++
			if i > row then p_ins.triggerevent("clicked")
			
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.SetItem(i,"itemas_itdsc",lst_code.codename[ll_i])
			
			this.SetItem(i,"facgbn",lst_code.sgubun1[ll_i])
			
			this.TriggerEvent("itemchanged")
			
		Next
End Choose 

end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::itemfocuschanged;IF this.GetColumnName() = "bigo" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_insert::rowfocuschanging;
//If newrow <= 0 Then Return
//
//If wf_chk(newrow) = 0 Then
//	p_del.Enabled = True
//	p_del.PictureName = "C:\erpman\image\����_up.gif"
//Else
//	p_del.Enabled = False
//	p_del.PictureName = "C:\erpman\image\����_d.gif"
//End If

end event

event dw_insert::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event dw_insert::ue_pressenter;call super::ue_pressenter;If This.GetRow() < 1 Then Return

Choose Case This.GetColumnName()
	Case 'bigo'
		p_ins.PostEvent(Clicked!)
		Return
End Choose

Send(Handle(this),256,9,0)
Return 1
end event

type p_delrow from w_inherite`p_delrow within w_sm40_0060
integer x = 4050
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0060
integer x = 3877
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sm40_0060
integer x = 3182
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sm40_0060
integer x = 3730
end type

event p_ins::clicked;call super::clicked;Long ll_row ,ll_r , ll_fr
String sIoGbn, sNull, sDepotNo, sSaupj , sCvcod, sudat, factory

SetNull(sNull)
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_insert.AcceptText() = -1 THEN RETURN

ll_r = dw_insert.RowCount()

If sModStatus = 'M' And ll_r < 1 Then 
	MessageBox('Ȯ��','��ϻ����϶� �߰� �����մϴ�.')
	Return
End If

dw_1.SetFocus()

If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return

sIogbn = Trim(dw_1.GetItemString(1,'gubun'))
sSaupj = Trim(dw_1.GetItemString(1,'saupj'))
sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
sudat = Trim(dw_1.GetItemString(1,'sudat'))
factory = Trim(dw_1.GetItemString(1,'factory'))

ll_r = ll_r + 1
	
ll_row = dw_insert.InsertRow(ll_r)

If sIogbn = '1' Or sIogbn = '4' Or sIogbn = '5' Then
	dw_insert.Modify("iogbn.visible = 1 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 0 ")
//	dw_insert.Modify("ioprc.protect = 1")
	dw_insert.Object.iogbn[ll_row] = 'OY2'
	
ElseIf sIogbn = '2' Then
	dw_insert.Modify("iogbn.visible = 0 ")
	dw_insert.Modify("iogbn_temp1.visible = 1 ")
	dw_insert.Modify("iogbn_temp2.visible = 0 ")
//	dw_insert.Modify("ioprc.protect = 1")
	dw_insert.Object.iogbn_temp1[ll_row] = 'O4A'
	
	dw_insert.Object.sudat[ll_row] = is_today
	
ElseIf sIogbn = '3' Then
	dw_insert.Modify("iogbn.visible = 0 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 1 ")
//	dw_insert.Modify("ioprc.protect = 0")
	dw_insert.Object.iogbn_temp2[ll_row] = sNull
End If

dw_insert.Object.sudat[ll_row] = sudat
dw_insert.Object.facgbn[ll_row] = factory

dw_insert.AcceptText()
dw_insert.ScrollToRow(ll_r)
dw_insert.SetColumn(1)
dw_insert.SetFocus()

dw_1.Enabled = False

end event

type p_exit from w_inherite`p_exit within w_sm40_0060
integer x = 4425
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm40_0060
integer x = 4251
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_sm40_0060
boolean visible = false
integer x = 3383
end type

event p_print::clicked;call super::clicked;//String  sIoJpNo, sDepotNo
//Integer iRowCount,iModCnt,iCurRow
//
//If dw_1.AcceptText() <> 1 Then return
//
//sIoJpNo = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
//IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
//	f_message_chk(30,'[�Ƿڹ�ȣ]')
//	dw_1.SetColumn("iojpno")
//	dw_1.SetFocus()
//	Return 
//END IF
//
///* ���� â�� */
//select min(cvcod )
//  into :sDepotNo
//  from vndmst
// where cvgu = '5' and
//       juhandle = '1' ;  
//
///* ������ġ�� ����â�� �켱���� �����ش� */
//If sqlca.sqlcode <> 0 or IsNull(sDepotNo) Then
//	sDepotNo = dw_1.GetItemString(1,'depot_no')
//End If
//
//IF dw_print.Retrieve(gs_sabu,sIoJpNo, sDepotNo) > 0 THEN
//	dw_print.object.datawindow.print.preview="yes"
//	
//	gi_page = dw_print.GetItemNumber(1,"last_page")
//	OpenWithParm(w_print_options, dw_print)
//Else
//	f_message_chk(50,'')
//END IF

end event

type p_inq from w_inherite`p_inq within w_sm40_0060
integer x = 3557
end type

event p_inq::clicked;call super::clicked;String  sIoJpNo
Long    nCnt 
String  ls_gubun , ls_sudat , ls_saupj ,ls_cvcod , ls_cvnas

If dw_1.AcceptText() <> 1 Then 	Return

If rb_insert.Checked Then 
	MessageBox('Ȯ��','�űԵ�� ���¿����� ��ȸ �Ұ��� �մϴ�.')
	Return
End If

ls_gubun = Trim(dw_1.GetItemString(1,"gubun"))
sIoJpNo  = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
	f_message_chk(30,'[��ǥ��ȣ]')
	dw_1.SetColumn("iojpno")
	dw_1.SetFocus()
	Return 
END IF

//Select Distinct 
//       a.sudat , a.saupj , a.cvcod ,b.cvnas
//  Into :ls_sudat , :ls_saupj ,:ls_cvcod ,:ls_cvnas
//  From IMHIST a , VNDMST b 
// Where a.cvcod = b.cvcod 
//   And Substr(iojpno,1,12) = :sIoJpNo;
//
//If SQLCA.SQLCODE <> 0 Then
//	MessageBox('Ȯ��','�ش� ��ǥ��ȣ�� ã�� �� �����ϴ�.')
//	Return
//End If
//
//dw_1.Object.sudat[1] = ls_sudat
//dw_1.Object.saupj[1] = ls_saupj
//dw_1.Object.cvcod[1] = ls_cvcod
//dw_1.Object.cvnas[1] = ls_cvnas

If dw_insert.Retrieve(gs_sabu,sIoJpNo) > 0 THEN
   dw_insert.SetFocus()
	dw_1.Enabled = False
	ib_any_typing = False
	
	dw_1.Object.sudat[1] = dw_insert.Object.sudat[1]
	dw_1.Object.saupj[1] = dw_insert.Object.saupj[1]
	dw_1.Object.cvcod[1] = dw_insert.Object.cvcod[1]
	dw_1.Object.cvnas[1] = dw_insert.Object.cvnas[1]
	dw_1.Object.factory[1] = dw_insert.Object.facgbn[1]
	dw_1.Object.depot_no[1] = dw_insert.Object.depot_no[1]
	
ELSE
	wf_init()
	f_message_chk(50,'')
	dw_1.SetColumn("iojpno")
	dw_1.SetFocus()
	Return
END IF

/* �˻�Ȯ�εȰ��� 1���̻��̸� �߰��Ұ�  */
//If ls_gubun <> '1' Then  // ��Ÿ������ ���� 
//
//	SELECT COUNT("IMHIST"."INSDAT")   INTO :nCnt
//	  FROM "IMHIST"  
//	  WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
//			  ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
//			  ( "IMHIST"."JNPCRT" ='004') AND
//			  ( "IMHIST"."INSDAT" IS NOT NULL);
//	
//	If nCnt > 0 Then
//		p_ins.Enabled = False
//		p_ins.PictureName = "C:\erpman\image\�߰�_d.gif"
//	Else
//		p_ins.Enabled = True
//		p_ins.PictureName = "C:\erpman\image\�߰�_up.gif"
//	End If
//
//End If
end event

type p_del from w_inherite`p_del within w_sm40_0060
integer x = 3904
end type

event p_del::clicked;call super::clicked;Integer iCurRow, iCnt
Long    nCnt, nDel, ix
String sIosudate, sGubun, sIojpno, sSaupj ,sIodate ,sIogbn

iCurRow = dw_insert.GetRow()
IF iCurRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* ���⸶���� ���� ���� ���� */
sIoSuDate = dw_1.GetItemString(1,"sudat")						/*�Ƿ�����*/

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sIoSuDate,1,6) );

If iCnt >= 1 then
	f_message_chk(60,'[���⸶��]')
	Return
End if

IF F_Msg_Delete() = -1 THEN Return

sSaupj = dw_1.GetItemString(1, 'saupj')
sGubun = dw_1.GetItemString(1, 'gubun')

nCnt = dw_insert.RowCount()
nDel = 0
IF sModStatus = 'M' Then
//	For ix = nCnt To 1 Step -1
//		If dw_insert.GetItemString(ix, 'del') <> 'Y' Then Continue
		ix = dw_insert.GetRow()
		IF ix > 0 THEN
		
			sIojpno = dw_insert.GetItemString(ix, 'iojpno')
			sIodate = dw_insert.GetItemString(ix, 'io_date')
			sIogbn  = dw_insert.GetItemString(ix, 'iogbn')
			
			// â���̵� ��ǥ ����
			IF sModStatus = 'M' And ( sGubun = '4' Or sGubun = '5' ) THEN
				DELETE FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND SAUPJ = :sSaupj;
				If SQLCA.SQLCODE <> 0 Then
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
					RollBack;
					Return
				End If
			End If
	
			// â���̵� ��ǥ ���� - �ҷ������� ��� - 2004.03.24 - �ۺ�ȣ
			IF sModStatus = 'M' And sGubun = '2' THEN
				
				If sIogbn = 'OY4' Then
					SELECT COUNT(*) INTO :iCnt FROM IMHIST
					 WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno 
						AND SAUPJ = :sSaupj AND IOGBN = 'O10' AND INSDAT IS NOT NULL ;
					
					IF iCnt > 0 or isNull(sIodate) = False THEN
						MESSAGEBOX('Ȯ��','��� �ҷ� ��ǰ ��˻簡 �Ϸ�� �ڷ�� ������ �� �����ϴ�.')
						dw_insert.SetItem(ix, 'del', 'N')
						RETURN
//						CONTINUE
					END IF
				End If
				
	//			DELETE FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND SAUPJ = :sSaupj;
	//			If SQLCA.SQLCODE <> 0 Then
	//				MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	//				RollBack;
	//				Return
	//			End If
	
			End If
	
			dw_insert.DeleteRow(ix)
			
			nDel += 1
			
		END IF
		
//	Next


/* �ű��� ��� ���� 2004.01.26 */
Else
	ix = dw_insert.GetRow()
	If ix > 0 Then
		dw_insert.DeleteRow(ix)
		nDel += 1
	End If
End If

If nDel > 0 Then
	IF sModStatus = 'M' THEN
		IF dw_insert.Update() <> 1 THEN
			ROLLBACK;
			Return
		END IF
		COMMIT;
		
		If dw_insert.RowCount() < 1 Then
			rb_insert.Checked = True
			rb_insert.TriggerEvent(Clicked!)
			Return
		End If
	END IF
	
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	
	w_mdi_frame.sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'
End If

end event

type p_mod from w_inherite`p_mod within w_sm40_0060
integer x = 4078
end type

event p_mod::clicked;String ls_gubun , ls_sudat ,ls_saupj ,ls_cvcod , ls_itnbr ,ls_null
Long   ll_cnt ,ll_maxjpno ,ll_maxseq
String ls_junpo_gb ,ls_jpno ,ls_iogbn
String ls_depot_no ,ls_iocnf ,ls_gumsu ,ls_new, sNull, ls_depot_qc
Long   i ,ll_rcnt, dInseq, lRowHist
Dec    ld_ioamt

String sIogubun, srcvcod, sHousegubun, stagbn, sqcgub, sTaOutJpno, sTaInjpno, sSaleyn, sIojpno, sJnpcrt, sfactory

If dw_insert.RowCount() < 1 Then Return

If f_msg_update() < 1 Then Return

SetNull(ls_null)
SetNull(snull)
   
If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return
	
ls_gubun = Trim(dw_1.Object.gubun[1])
ls_sudat = Trim(dw_1.Object.sudat[1])
ls_saupj = Trim(dw_1.Object.saupj[1])
ls_cvcod = Trim(dw_1.Object.cvcod[1])
sfactory = Trim(dw_1.Object.factory[1])

//ls_depot_no = 'Z01'  // ��� â�� 

/*****************************************************************************************
2008.10.09 by shingoon
����ǰ�� ���翡 ��ǰ �� ����â��� �����ݼ� �� ��� �԰�ó�� ����Ǿ�� ��.

// ��ǰ â��
SELECT min(cvcod)  into :ls_depot_no
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '1' 
	and jumaechul = '2' ;
******************************************************************************************/
//�԰� â��
ls_depot_no = Trim(dw_1.Object.depot_no[1])
/*****************************************************************************************/

// �ҷ� â��
SELECT min(cvcod)  into :ls_depot_qc
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '4' 
	and jumaechul = '2' ;


/* ���⸶�� ���� üũ  ========================================== */
SELECT COUNT(*)  INTO :ll_cnt
  FROM JUNPYO_CLOSING  
WHERE SABU = :gs_sabu 
   AND JPGU = 'G0' 
	AND JPDAT >= substr(:ls_sudat,1,6)  ;
		
If ll_cnt >= 1 then
	f_message_chk(60,'[���⸶��]')
	Return
End if
//================================================================
	
// â�� �ڵ�ó�� ���� �˻� =========================================== 
SELECT VNDMST.HOMEPAGE
  INTO :ls_iocnf
  FROM VNDMST
 WHERE ( VNDMST.CVCOD = :ls_depot_no ) AND  ( VNDMST.CVGU = '5' );
	
If IsNull(ls_iocnf) or ls_iocnf = '' Then	ls_iocnf = 'N'
//======================================================================

// �ŷ�ó �˼����� ���ܿ��� 2003.10.29 ajh
	
SELECT NVL(GUMGU,'N') INTO :ls_gumsu
  FROM VNDMST 
 WHERE CVCOD = :ls_cvcod ;
	 
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Ȯ��','�ŷ�ó �˼� ������ �����ϴ�.')
	Return
End if
//====================================================

dw_imhist.Reset()

If ls_gubun = '1' Or ls_gubun = '4' Or ls_gubun = '5'  Then   // ��Ÿ��� 
//	ll_rcnt = dw_insert.RowCount()
//	If wf_requiredchk(dw_insert.DataObject,ll_rcnt) < 1 Then Return
//	
//	IF sModStatus = 'I' THEN   
//		ls_junpo_gb = 'C0'
//		ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
//		IF ll_maxjpno <= 0 THEN
//			f_message_chk(51,'')
//			ROLLBACK;
//			Return 1
//		END IF
//		commit;
//		ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
//		
//		If ls_gubun = '1' Then
//			sJnpcrt = '024'
//		ElseIf ls_gubun = '4' Then
//			sJnpcrt = '037'
//		ElseIf ls_gubun = '5' Then
//			sJnpcrt = '029'
//		Else
//			sJnpcrt = '004'
//		End If
//
//		// Ÿ���� ����� ��� 
//		If ls_gubun = '4' Or ls_gubun = '5'  Then
//			if ls_depot_no = dw_1.GetItemString(1, "out_store") then 
//				sIOgubun = 'O2A'  // �ڱ�â���ü
//			else
//				sIOgubun = 'O25'  // Ÿâ���ü
//			end if
//			
//			setnull(srcvcod)
//			SELECT AUTIPG, RCVCOD, TAGBN
//			  INTO :sHouseGubun, :sRcvcod, :sTagbn
//			  FROM IOMATRIX
//			 WHERE SABU = :gs_sabu		AND
//					 IOGBN = :sIOgubun ;
//					  
//			if sqlca.sqlcode <> 0 then
//				f_message_chk(208, '[�����]')
//			end if
//			
//			/* â���̵� ����� ��� ��� �԰����� �˻� */
//			if sHousegubun = 'Y' then
//				if isnull(srcvcod) or trim(srcvcod) = '' then
//					f_message_chk(208, '[�����-â���̵��԰�]')	
//					return -1
//				end if
//				//���˻� ����Ÿ ��������
//				SELECT "SYSCNFG"."DATANAME"  
//				  INTO :sQcgub  
//				  FROM "SYSCNFG"  
//				 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
//						 ( "SYSCNFG"."SERIAL" = 13 ) AND  
//						 ( "SYSCNFG"."LINENO" = '2' )   ;
//				if sqlca.sqlcode <> 0 then
//					sQcgub = '1'
//				end if
//			end if
//			
//			dInSeq = SQLCA.FUN_JUNPYO(gs_sabu, ls_sudat, 'C0')
//			IF dInSeq < 0		THEN	
//				rollback;
//				RETURN -1
//			end if
//			COMMIT;
//		End If
//	
//		dw_1.SetItem(1,"iojpno",ls_jpno)
//		MessageBox("Ȯ ��","ä���� ��ǥ��ȣ�� "+ls_jpno+" �� �Դϴ�!!")
//	ELSE
//		ls_jpno = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
//	END IF
//	
//	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
//		f_message_chk(51,'[��ǥ��ȣ]')
//		Return
//	End If
//	
//	If ll_rcnt > 0 Then
//	  ll_maxseq = Long(dw_insert.GetItemString(1,'maxseq'))
//	  If IsNull(ll_maxseq) Then ll_maxseq = 0
//	Else
//		ll_maxseq = 0
//	End If
//
//	For i = 1 TO ll_rcnt
//		
//		ls_new = Trim(dw_insert.Object.is_new[i])
//		
//		If ls_new = 'Y' Then
//			ll_maxseq += 1
//		  	dw_insert.SetItem(i,"sabu",       gs_sabu)
//			
//			sIojpno = ls_jpno+String(ll_maxseq,'000')
//		  	dw_insert.SetItem(i,"iojpno", sIojpno)
//		End If
//		
//		dw_insert.SetItem(i,"iogbn", 		 'OY2')
//      dw_insert.SetItem(i,"sudat", 		 ls_sudat)
//		dw_insert.SetItem(i,"cvcod",      ls_cvcod)
//		
//		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
//		
//		dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//		dw_insert.SetItem(i,"ioamt",      Truncate(dw_insert.GetItemNumber(i,"ioreqty") * &
//		                                           dw_insert.GetItemNumber(i,"ioprc") , 0 ))
//		dw_insert.SetItem(i,"insdat",     ls_sudat)
//		dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))
//		dw_insert.SetItem(i,"io_confirm", ls_iocnf)
//		dw_insert.SetItem(i,"io_date",    ls_sudat)
//		dw_insert.SetItem(i,"filsk",      dw_insert.GetItemString(i,'itemas_filsk'))
//		dw_insert.SetItem(i,"decisionyn", 'Y')
//      
//		If ls_gumsu = 'Y' Then
//			dw_insert.SetItem(i,"yebi1",      ls_null)   // �˼��ϴ� ��ü�� �˼����ڰ� Null
//		Else
//			dw_insert.SetItem(i,"yebi1",      ls_sudat)  // �˼����� �ʴ� ��ü�̸� ������ڰ� �˼�����
//		End If
//		
//	   dw_insert.SetItem(i,"ioreemp",    gs_empno)
//		dw_insert.SetItem(i,"saupj",      ls_saupj )
//      dw_insert.SetItem(i,"inpcnf", 'O')   // �������(���)
//		dw_insert.SetItem(i,"botimh",'')
//		dw_insert.SetItem(i,"outchk",'N')
//		// �˼����� 
//		dw_insert.SetItem(i,"qcgub",'1')
//		dw_insert.SetItem(i,"jnpcrt", sJnpcrt)
//		
//		// Ÿ���� ����� ��� 
//		IF sHouseGubun = 'Y'		THEN
//			lRowHist = dw_imhist.InsertRow(0)
//			
//			dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
//			dw_imhist.SetItem(lRowHist, "jnpcrt",	sJnpcrt)			// ��ǥ��������
//			dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// �������
//			
//			sTaOutJpno = ls_sudat + string(dInSeq, "0000") + string(lRowHist, "000")
//			dw_imhist.SetItem(lRowHist, "iojpno", 	sTaOutJpno)
//			
//			dw_imhist.SetItem(lRowHist, "iogbn",   sIogubun) 		// ���ұ���=��û����
//		
//			dw_imhist.SetItem(lRowHist, "sudat",	ls_sudat)			// ��������=�������
//			dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(i, "field_cd")) // ǰ��
//			dw_imhist.SetItem(lRowHist, "pspec",	'.')
//			dw_imhist.SetItem(lRowHist, "depot_no",dw_1.GetItemString(1, "out_store"))			// ����â��=���â��
//			dw_imhist.SetItem(lRowHist, "cvcod",	ls_depot_no) 	// �ŷ�óâ��=�԰�ó
//			dw_imhist.SetItem(lRowHist, "ioqty",	dw_insert.GetItemNumber(i,"ioreqty")) 	// ���Ҽ���=������
//			dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemNumber(i,"ioreqty")) 	// �����Ƿڼ���=������		
//			dw_imhist.SetItem(lRowHist, "insdat",	ls_sudat)			// �˻�����=�������	
//			dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemNumber(i,"ioreqty")) 	// �հݼ���=������		
//			dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// �����ڵ�
//			dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// ���ҽ��ο���
//			dw_imhist.SetItem(lRowHist, "io_date",	ls_sudat)			// ���ҽ�������=�������	
//			dw_imhist.SetItem(lRowHist, "io_empno",gs_empno)			// ���ҽ�����=�����	
//			dw_imhist.SetItem(lRowHist, "hold_no", sNull) 	// �Ҵ��ȣ
//			dw_imhist.SetItem(lRowHist, "filsk",   dw_insert.GetItemString(i,'itemas_filsk')) // ����������
//			dw_imhist.SetItem(lRowHist, "botimh",	'N')				// ���������
//			dw_imhist.SetItem(lRowHist, "itgu",    '5')			 	// ��������
//			dw_imhist.SetItem(lRowHist, "outchk",  'Y')	 			// ����ǷڿϷ�
//			dw_imhist.SetItem(lRowHist, "pjt_cd",  sNull)			// ������ƮNo
//			dw_imHist.SetItem(lRowHist, "ip_jpno", sIojpno)  		// �԰���ǥ��ȣ=����ȣ
//			dw_imHist.SetItem(lRowHist, "saupj", ls_Saupj)
//			
//			// Ÿ���� �԰� ��ǥ
//			lRowHist = dw_imhist.InsertRow(0)						
//			
//			dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
//			dw_imHist.SetItem(lRowHist, "jnpcrt",	sJnpcrt)			// ��ǥ��������
//			dw_imHist.SetItem(lRowHist, "inpcnf",  'I')				// �������
//			
//			sTaInJpno = ls_sudat + string(dInSeq, "0000") + string(lRowHist, "000")
//			dw_imHist.SetItem(lRowHist, "iojpno", 	sTaInJpno)
//			dw_imHist.SetItem(lRowHist, "iogbn",   srcvcod) 		// ���ұ���=â���̵��԰���
//	
//			dw_imHist.SetItem(lRowHist, "sudat",	ls_sudat)			// ��������=�������
//
//			dw_imHist.SetItem(lRowHist, "itnbr", dw_insert.GetItemString(i, "itnbr")) // ǰ��
//			dw_imHist.SetItem(lRowHist, "pspec", '.') // ���
//
//			dw_imHist.SetItem(lRowHist, "depot_no",ls_depot_no) 	// ����â��=�԰�ó
//			
//			dw_imHist.SetItem(lRowHist, "cvcod",	dw_1.GetItemString(1, "out_store")) 			// �ŷ�óâ��=���â��
//			dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// �����ڵ�
//		
//			dw_imHist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemNumber(i,"ioreqty")) 	// �����Ƿڼ���=������		
//			dw_imHist.SetItem(lRowHist, "insdat",	ls_sudat)			// �˻�����=�������	
//			
//			dw_imHist.SetItem(lRowHist, "qcgub",	sQcgub)			// �˻���=> ���˻�
//			dw_imHist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemNumber(i,"ioreqty")) 	// �հݼ���=������		
//			dw_imHist.SetItem(lRowHist, "filsk",   'Y') // ����������
//
//			
//			Setnull(sSaleyn)
//
//			// Ÿ������ ������ ����
//			Ssaleyn = 'Y' 
//			dw_imhist.SetItem(lRowHist, "io_confirm", sSaleYn)	 // ���ҽ��ο���
//	
//			IF sSaleYn = 'Y' then
//				dw_imhist.SetItem(lRowHist, "ioqty",    dw_insert.GetItemNumber(i,"ioreqty")) 	// ���Ҽ���=�԰����
//				dw_imhist.SetItem(lRowHist, "io_date",  ls_sudat)// ���ҽ�������=�԰��Ƿ�����
//				dw_imhist.SetItem(lRowHist, "io_empno", sNull)	 // ���ҽ�����=NULL
//			END IF			
//
//			dw_imHist.SetItem(lRowHist, "botimh",	'N')			 // ���������
//			dw_imHist.SetItem(lRowHist, "itgu",    '5')		 	 // ��������
//
//			dw_imHist.SetItem(lRowHist, "ioredept",sNull)		 // �����Ƿںμ�=�Ҵ�.�μ�
//			dw_imHist.SetItem(lRowHist, "ioreemp",	gs_empno)	 // �����Ƿڴ����=�����	
//			dw_imHist.SetItem(lRowHist, "ip_jpno", sIojpno) 	 // �԰���ǥ��ȣ=����ȣ
//			dw_imHist.SetItem(lRowHist, "saupj", ls_Saupj)
//		End If
//	Next
ElseIf ls_gubun = '2' AND sModStatus = 'I' Then // ��ǰ  
	
	ll_rcnt = dw_insert.RowCount()
	If wf_requiredchk(dw_insert.DataObject,ll_rcnt) < 1 Then Return

	IF sModStatus = 'I' THEN   
		ls_junpo_gb = 'C0'
		ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
		IF ll_maxjpno <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			Return 1
		END IF
		commit;
		ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
		
		dw_1.SetItem(1,"iojpno",ls_jpno)
		MessageBox("Ȯ ��","ä���� ��ǥ��ȣ�� "+ls_jpno+" �� �Դϴ�!!")
	ELSE
		ls_jpno = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
	END IF
	
	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
		f_message_chk(51,'[��ǥ��ȣ]')
		Return
	End If
	
	If ll_rcnt > 0 Then	
	  ll_maxseq = Long(dw_insert.GetItemString(1,'maxseq'))
	  If IsNull(ll_maxseq) Then ll_maxseq = 0
	Else
		ll_maxseq = 0
	End If
	
	For i = 1 TO ll_rcnt
		
		ls_new = Trim(dw_insert.Object.is_new[i])
		ls_iogbn = dw_insert.GetItemString(i,'iogbn_temp1')
		
		If ls_new = 'Y' Then
			ll_maxseq += 1
		  	dw_insert.SetItem(i,"sabu",       gs_sabu)
		  	dw_insert.SetItem(i,"iojpno",     ls_jpno+String(ll_maxseq,'000'))
		End If
		
		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
		
		dw_insert.SetItem(i,"iogbn",      ls_iogbn)
		dw_insert.SetItem(i,"sudat", 		 ls_sudat)
		dw_insert.SetItem(i,"cvcod",      ls_cvcod)
		dw_insert.SetItem(i,"depot_no",      ls_depot_no)
		dw_insert.SetItem(i,"ioamt",      Truncate(dw_insert.GetItemNumber(i,"ioreqty") * &
		                                           dw_insert.GetItemNumber(i,"ioprc") , 0 ))
		dw_insert.SetItem(i,"io_confirm", ls_iocnf)        // �ڵ�ó������ 
		dw_insert.SetItem(i,"filsk",      dw_insert.GetItemString(i,'itemas_filsk'))      // ����������
		dw_insert.SetItem(i,"ioreemp",    gs_empno)
		dw_insert.SetItem(i,"saupj",      ls_saupj )
      dw_insert.SetItem(i,"inpcnf", 'I')   					// �������(�԰�)
		dw_insert.SetItem(i,"botimh",'')
		dw_insert.SetItem(i,"outchk",'N')
	   dw_insert.SetItem(i,"jnpcrt",'005')
		dw_insert.SetItem(i,"ioredept",gs_dept)
	   dw_insert.SetItem(i,"ioreemp",gs_empno)
		
	   dw_insert.SetItem(i,"facgbn",sfactory)


//		If ls_gumsu = 'N' Then
//			If ls_iogbn = 'OY3' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                  // �˼����� 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))      // �հݼ���
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                  // ��������
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // �˻��պ����� 
//				dw_insert.SetItem(i,"yebi1",      ls_sudat)                                  // �˼����� 
//				dw_insert.SetItem(i,"qcgub",'1')
//				
//			// �ҷ����Ե� �˻�Ϸ� - 2004.03.24 - �ۺ�ȣ
//			ElseIf ls_iogbn = 'OY4' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty") )
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                   // �˼����� 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty") )     // �հݼ���
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                   // ��������
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // �˻��պ����� 
//				dw_insert.SetItem(i,"yebi1",      ls_sudat)   											// �˼�����
//				dw_insert.SetItem(i,"qcgub",'1')
//				
//				// �ҷ�â�� ���� - 2004.03.24 - �ۺ�ȣ
//				//if ls_new = 'Y' then wf_create_imhist_oy4_after(i)
//	      End If
			
//		Else
//         // ���� ��ǰ (����)
//			If ls_iogbn = 'O4A' Or ls_iocnf = 'Y' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                  // �˼����� 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))      // �հݼ���
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                  // ��������
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // �˻��պ����� 
//				dw_insert.SetItem(i,"yebi1",      ls_sudat)                                  // �˼����� 
//				dw_insert.SetItem(i,"qcgub",'1')
//			// �ҷ� ��ǰ
//			ElseIf ls_iogbn = 'O41' Or ls_iocnf = 'N' Then
//				dw_insert.SetItem(i,"ioqty",      0 )
//				dw_insert.SetItem(i,"insdat",     ls_null)                                   // �˼����� 
//				dw_insert.SetItem(i,"iosuqty",    ls_null)                                    // �հݼ���
//				dw_insert.SetItem(i,"io_date",    ls_null)                                   // ��������
//				dw_insert.SetItem(i,"decisionyn", 'N')                                        // �˻��պ����� 
//				dw_insert.SetItem(i,"yebi1",      ls_null)                                   // �˼����� 
//				dw_insert.SetItem(i,"qcgub",'5')
//				
////				if ls_iogbn = 'O41' then
////					dw_insert.SetItem(i,"depot_no",      ls_depot_qc)		// �ҷ�â��
////				end if
//				
//				//if ls_new = 'Y' then wf_create_imhist_oy4_after(i)
//	      End If
			
			//â�� �ڵ�ó�� ����
			If ls_iocnf = 'Y' Then //â�� �ڵ�����
				If ls_iogbn = 'O4A' Then //�����ǰ(���� ��) - QC�˻� ���� �ٷ� �԰� ó��
					dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
					dw_insert.SetItem(i,"insdat",     ls_sudat)                                  // �˼����� 
					dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))      // �հݼ���
					dw_insert.SetItem(i,"io_date",    ls_sudat)                                  // ��������
					dw_insert.SetItem(i,"decisionyn", 'Y')                                       // �˻��պ����� 
					dw_insert.SetItem(i,"yebi1",      ls_sudat)                                  // �˼����� 
					dw_insert.SetItem(i,"qcgub",'1')
				ElseIf ls_iogbn = 'O41' Then //�ҷ���ǰ(��� ��) - QC�˻� Ȯ�� �ʿ�
					dw_insert.SetItem(i,"ioqty",      0 )
					dw_insert.SetItem(i,"insdat",     ls_null)                                   // �˼����� 
					dw_insert.SetItem(i,"iosuqty",    ls_null)                                    // �հݼ���
					dw_insert.SetItem(i,"io_date",    ls_null)                                   // ��������
					dw_insert.SetItem(i,"decisionyn", 'N')                                        // �˻��պ����� 
					dw_insert.SetItem(i,"yebi1",      ls_null)                                   // �˼����� 
					dw_insert.SetItem(i,"qcgub",'4')                                             // �˻籸��(�����˻�)
				End If
			ElseIf ls_iocnf = 'N' Then //â�� ��������
				dw_insert.SetItem(i,"ioqty",      0 )
				dw_insert.SetItem(i,"insdat",     ls_null)                                   // �˼����� 
				dw_insert.SetItem(i,"iosuqty",    ls_null)                                    // �հݼ���
				dw_insert.SetItem(i,"io_date",    ls_null)                                   // ��������
				dw_insert.SetItem(i,"decisionyn", 'N')                                        // �˻��պ����� 
				dw_insert.SetItem(i,"yebi1",      ls_null)                                   // �˼����� 
				dw_insert.SetItem(i,"qcgub",'4')
			End If
			
//		End If
	Next
ElseIf ls_gubun = '3' Then // �ܰ� �ұ�
//	ll_rcnt = dw_insert.RowCount()
//	If wf_requiredchk(dw_insert.DataObject,ll_rcnt) < 1 Then Return
//	
//	IF sModStatus = 'I' THEN   
//		ls_junpo_gb = 'C0'
//		ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
//		IF ll_maxjpno <= 0 THEN
//			f_message_chk(51,'')
//			ROLLBACK;
//			Return 1
//		END IF
//		commit;
//		ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
//		
//		dw_1.SetItem(1,"iojpno",ls_jpno)
//		MessageBox("Ȯ ��","ä���� ��ǥ��ȣ�� "+ls_jpno+" �� �Դϴ�!!")
//	ELSE
//		ls_jpno = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
//	END IF
//	
//	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
//		f_message_chk(51,'[��ǥ��ȣ]')
//		Return
//	End If
//	
//	If ll_rcnt > 0 Then	
//	  ll_maxseq = Long(dw_insert.GetItemString(1,'maxseq'))
//	  If IsNull(ll_maxseq) Then ll_maxseq = 0
//	Else
//		ll_maxseq = 0
//	End If
//	
//	For i = 1 TO ll_rcnt
//		
//		ls_new   = Trim(dw_insert.Object.is_new[i])
//		ls_iogbn = dw_insert.GetItemString(i,'iogbn_temp2')
//		ld_ioamt = dw_insert.GetItemDecimal(i,'c_ioamt')
//	   
//		If ls_new = 'Y' Then
//			ll_maxseq += 1
//		  	dw_insert.SetItem(i,"sabu",       gs_sabu)
//		  	dw_insert.SetItem(i,"iojpno",     ls_jpno+String(ll_maxseq,'000'))
//		End If
//		
//	 	If ld_ioamt < 0 Then
//			dw_insert.SetItem(i,"iogbn", 		 'OY6')
//		ElseIf ld_ioamt > 0 Then
//			dw_insert.SetItem(i,"iogbn", 		 'OY5')
//		Else
//			MessageBox('Ȯ��','�ܰ� �ұޱݾ��� �����ϴ�.')
//			dw_insert.SetFocus()
//			dw_insert.ScrollToRow(i)
//			dw_insert.SetColumn("ioprc")
//			Return
//		End If
//		
//      dw_insert.SetItem(i,"sudat", 		 ls_sudat)
//		dw_insert.SetItem(i,"cvcod",      ls_cvcod)
//		
//		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
//		
//		dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//		dw_insert.SetItem(i,"ioamt",      Truncate(dw_insert.GetItemNumber(i,"ioreqty") * &
//		                                           dw_insert.GetItemNumber(i,"ioprc") , 0 ))
//		dw_insert.SetItem(i,"insdat",     ls_sudat)
//		dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))
//		dw_insert.SetItem(i,"io_confirm", ls_iocnf)
//		dw_insert.SetItem(i,"io_date",    ls_sudat)
//		dw_insert.SetItem(i,"filsk",      'N')
//		dw_insert.SetItem(i,"decisionyn", 'Y')
//      dw_insert.SetItem(i,"yebi1",      ls_sudat)
//		
//	   dw_insert.SetItem(i,"ioreemp",    gs_empno)
//		dw_insert.SetItem(i,"saupj",      ls_saupj )
//		
//		If ls_iogbn = 'OY5' Then
//      	dw_insert.SetItem(i,"inpcnf", 'O')   // �������
//		Else
//			dw_insert.SetItem(i,"inpcnf", 'I')   // �������(���)
//		End If
//		
//		dw_insert.SetItem(i,"botimh",'')
//		dw_insert.SetItem(i,"outchk",'N')
//		dw_insert.SetItem(i,"qcgub",'1')
//		dw_insert.SetItem(i,"jnpcrt",'036')
//	Next
END IF

dw_insert.AcceptText()
IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

//IF dw_imhist.Update() <> 1 THEN
//	ROLLBACK;
//	Return
//END IF

COMMIT;

w_mdi_frame.sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'
//
//If sModStatus = 'I' Then
//	rb_modify.Checked = True
//	rb_modify.TriggerEvent(Clicked!)
//	dw_1.Object.gubun[1] = ls_gubun
//	dw_1.Object.iojpno[1] = ls_jpno
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm40_0060
integer x = 4306
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0060
integer x = 3264
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0060
integer x = 3616
integer y = 5000
integer taborder = 40
string text = "�߰�(&I)"
end type

type cb_del from w_inherite`cb_del within w_sm40_0060
integer x = 3611
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0060
integer x = 3269
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_sm40_0060
integer x = 3963
integer y = 5000
integer width = 626
string text = "��ǰ�Ƿڼ����(&P)"
end type

type st_1 from w_inherite`st_1 within w_sm40_0060
end type

type cb_can from w_inherite`cb_can within w_sm40_0060
integer x = 3959
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sm40_0060
integer x = 2171
integer y = 2448
end type







type gb_button1 from w_inherite`gb_button1 within w_sm40_0060
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0060
end type

type rr_2 from roundrectangle within w_sm40_0060
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3872
integer y = 216
integer width = 741
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_insert from radiobutton within w_sm40_0060
integer x = 82
integer y = 48
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "���"
boolean checked = true
end type

event clicked;sModStatus = 'I'											/*���*/

Wf_Init()

end event

type rb_modify from radiobutton within w_sm40_0060
integer x = 82
integer y = 140
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "����"
end type

event clicked;sModStatus = 'M'											/*����*/

Wf_Init()
end event

type dw_1 from u_key_enter within w_sm40_0060
event ue_key pbm_dwnkey
integer x = 407
integer y = 16
integer width = 2958
integer height = 252
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sm40_0060_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sIoJpNo,sSuDate,sIoCust,sIoCustArea,sIoCustName,sIoConFirm
String  sDepotNo,sDept,sDeptname,snull,sEmpNo,sEmpName, sInsDat
String  sGubun
LONG		lcnt
SetNull(snull)

Choose Case this.GetColumnName()
	/*���� */
//	Case  "gubun" 
//		sGubun = this.GetText()
//		IF sGubun = "" OR IsNull(sGubun) THEN RETURN
//		
//		dw_1.Object.iojpno[1] = snull
////		dw_1.Object.sudat[1] = is_today
////		dw_1.Object.saupj[1] = snull
//		dw_1.Object.cvcod[1] = snull
//		dw_1.Object.cvnas[1] = snull
//	   
//		// �������,���������,as��ü���
//		If sGubun = '1' Or sGubun = '4' Or sGubun = '5'  then
//			dw_insert.Reset()
//			dw_insert.Modify("iogbn.visible = 1 ")
//			dw_insert.Modify("iogbn_temp1.visible = 0 ")
//			dw_insert.Modify("iogbn_temp2.visible = 0 ")
//			dw_insert.Modify("ioprc.protect = 1")
//		ElseIf sGubun = '2' then
//			dw_insert.Reset()
//			dw_insert.Modify("iogbn.visible = 0 ")
//			dw_insert.Modify("iogbn_temp1.visible = 1 ")
//			dw_insert.Modify("iogbn_temp2.visible = 0 ")
//			dw_insert.Modify("ioprc.protect = 1")
//		ElseIf sGubun = '3' then
//			dw_insert.Reset()
//			dw_insert.Modify("iogbn.visible = 0 ")
//			dw_insert.Modify("iogbn_temp1.visible = 0 ")
//			dw_insert.Modify("iogbn_temp2.visible = 1 ")
//			dw_insert.Modify("ioprc.protect = 0")
//		End If
//		
//		If rb_insert.Checked = True Then
//			If ( sGubun = '4' Or sGubun = '5' ) then
//				dw_insert.DataObject = 'd_sm04_00050_c'
//			Else
//				dw_insert.DataObject = 'd_sm04_00050_a'
//			End If
//		Else
//			dw_insert.DataObject = 'd_sm04_00050_b'
//		End If
//		
//		dw_insert.SetTransObject(sqlca)
	/* ��ǰ�Ƿڹ�ȣ */
	Case  "iojpno" 
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
	  /* �˻�Ȯ�� */
		SELECT DISTINCT "IMHIST"."INSDAT"   INTO :sInsDat
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
				 ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
				 ( "IMHIST"."JNPCRT" ='005') AND
				 ( "IMHIST"."INV_NO" IS NULL );
	
		IF SQLCA.SQLCODE <> 0 THEN
		  this.TriggerEvent(RButtonDown!)
		  Return 2
		ELSE
			p_inq.TriggerEvent(Clicked!)
		END IF
	Case "sudat"
		sSuDate = Trim(GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[��ǰ�Ƿ�����]')
			this.SetItem(1,"sudat",snull)
			Return 1
		END IF
	
	/* ��ǰó */
	Case "cvcod"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"cvnas",snull)
			Return 1
		END IF
		
		SELECT "VNDMST"."CVNAS2","VNDMST"."SAREA"		
		  INTO :sIoCustName,	:sIoCustArea
		  FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
		 return 1
		ELSE
			this.SetItem(1,"cvnas",  sIoCustName)
		END IF

		SELECT MAX(RFGUB), COUNT(*)  INTO :sIoCustArea, :lcnt
		  FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = '2A' AND "REFFPF"."RFNA2" = :sIoCust  ;
		IF lcnt = 0 THEN
			this.SetItem(1,"factory",  ".")
		ELSEIF lcnt = 1 THEN
			this.SetItem(1,"factory",  sIoCustArea)
		ELSE
			this.SetItem(1,"factory",  snull)
		END IF

	
	/* ��ǰó�� */
	Case "cvnas" 
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"cvcod",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD","VNDMST"."SAREA"		INTO :sIoCust,	:sIoCustArea
		  FROM "VNDMST"  
		WHERE "VNDMST"."CVNAS2" = :sIoCustName   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"cvcod",    sIoCust)
		END IF

	/* ���� */
	Case "factory"
		sIoCustArea = Trim(GetText())
		IF sIoCustArea ="." OR sIoCustArea ="" OR IsNull(sIoCustArea) THEN
			this.SetItem(1,"cvcod",  snull)
			this.SetItem(1,"cvnas",  snull)
			Return
		END IF
		
		SELECT "REFFPF"."RFNA2"
		  INTO :sIoCust
		  FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = '2A' AND "REFFPF"."RFGUB" = :sIoCustArea  ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.SetItem(1,"cvcod",  snull)
			this.SetItem(1,"cvnas",  snull)
		ELSE
			SELECT "VNDMST"."CVNAS"	INTO :sIoCustName
			  FROM "VNDMST"  
			WHERE "VNDMST"."CVCOD" = :sIoCust   ;
			IF SQLCA.SQLCODE <> 0 THEN
				this.SetItem(1,"cvcod",  snull)
				this.SetItem(1,"cvnas",  snull)
			ELSE
				this.SetItem(1,"cvcod",  sIoCust)
				this.SetItem(1,"cvnas",  sIoCustName)
			END IF
		END IF

END Choose

end event

event editchanged;ib_any_typing = True
end event

event rbuttondown;String sDeptName,sNull, sIoGbn
String ls_gubun

SetNull(sNull)
SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

AcceptText()

Choose Case GetColumnName()
	/* �Ƿڹ�ȣ */
	Case "iojpno" 
		gs_gubun = Trim(This.Object.gubun[1])
		
		Open(w_sm04_00050_popup01)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
		SetItem(1,"iojpno",Left(gs_code,12))
		p_inq.PostEvent(Clicked!)

	/* ��ǰó */
	Case "cvcod" , "cvnas"

		If GetColumnName() = 'cvnas' Then
			gs_codename = Trim(GetText())
		End If
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetItem(1,"cvnas",gs_codename)
		TriggerEvent("itemChanged")
END Choose

ib_any_typing = True
end event

event itemfocuschanged;IF this.GetColumnName() = "cvnas" Then
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type dw_print from datawindow within w_sm40_0060
boolean visible = false
integer x = 3909
integer y = 232
integer width = 654
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "��ǰ�Ƿڼ�"
string dataobject = "d_sal_020503"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_sm40_0060
boolean visible = false
integer x = 3296
integer y = 196
integer width = 475
integer height = 116
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_imhist"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_sm40_0060
boolean visible = false
integer x = 3566
integer y = 192
integer width = 649
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "D1 ��ǰ����"
end type

event clicked;IF dw_insert.RowCount() > 0 Then
	MessageBox('Ȯ��','���� �ڷ� ��� �� ó�������մϴ�.')
	Return
End iF

Long    nRow ,ll_row
String  sCvcod,sItnbr, sSaupj

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)


str_code lst_code
Long i , ll_i = 0

dw_1.AcceptText()

If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return

gs_code = Trim(dw_1.Object.cvcod[1])
gs_codename = Trim(dw_1.Object.cvnas[1])


open(w_sm40_0060_1)

lst_code = Message.PowerObjectParm
IF isValid(lst_code) = False Then Return 
If UpperBound(lst_code.code) < 1 Then Return 

For i = 1 To UpperBound(lst_code.code) 
	ll_i++
	
	ll_row = dw_insert.InsertRow(0)

	dw_insert.ScrollToRow(ll_row)

	dw_insert.SetFocus()
	
	dw_insert.SetItem(ll_row,"itnbr",lst_code.code[i])
	dw_insert.SetItem(ll_row,"itemas_itdsc",lst_code.codename[i])
   
	dw_insert.SetItem(ll_row,"ioreqty",abs(lst_code.dgubun1[i]))
	dw_insert.SetItem(ll_row,"ioprc",lst_code.dgubun2[i])
	
	
	dw_insert.Object.facgbn[ll_row] = Trim(lst_code.sgubun1[i])
	dw_insert.Object.lotsno[ll_row] = Trim(lst_code.sgubun2[i])
	dw_insert.Object.loteno[ll_row] = Trim(lst_code.sgubun3[i])
	dw_insert.Object.sudat[ll_row] = Trim(lst_code.sgubun4[i])
	
	dw_insert.Object.iogbn_temp1[ll_row] = 'OY4'
	dw_insert.Object.bigo[ll_row] = "�ҷ� ��ǰ"

Next

dw_insert.Modify("iogbn.visible = 0 ")
dw_insert.Modify("iogbn_temp1.visible = 1 ")
dw_insert.Modify("iogbn_temp2.visible = 0 ")
dw_insert.Modify("ioprc.protect = 1")


end event

type st_2 from statictext within w_sm40_0060
integer x = 416
integer y = 268
integer width = 1143
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "* ��ǰ������ (-) ���� ����� �Է�...."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sm40_0060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 332
integer width = 4590
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm40_0060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 375
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

