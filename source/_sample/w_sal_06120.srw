$PBExportHeader$w_sal_06120.srw
$PBExportComments$���� ��ǰ ���
forward
global type w_sal_06120 from w_inherite
end type
type gb_5 from groupbox within w_sal_06120
end type
type gb_4 from groupbox within w_sal_06120
end type
type rb_insert from radiobutton within w_sal_06120
end type
type rb_modify from radiobutton within w_sal_06120
end type
type dw_imhist_ins from u_key_enter within w_sal_06120
end type
type dw_cid from datawindow within w_sal_06120
end type
type dw_cih from datawindow within w_sal_06120
end type
type pb_1 from u_pb_cal within w_sal_06120
end type
type rr_1 from roundrectangle within w_sal_06120
end type
type rr_2 from roundrectangle within w_sal_06120
end type
type rr_3 from roundrectangle within w_sal_06120
end type
end forward

global type w_sal_06120 from w_inherite
integer height = 3772
string title = "�����ǰ �Ƿ� ��� �� ���"
gb_5 gb_5
gb_4 gb_4
rb_insert rb_insert
rb_modify rb_modify
dw_imhist_ins dw_imhist_ins
dw_cid dw_cid
dw_cih dw_cih
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_06120 w_sal_06120

type variables

String is_insemp        // �˻�����
String is_iojpnoOK     //�������ȣ �ʼ�����
String isCursor, sNappum, isOldCino


end variables

forward prototypes
public function integer wf_chk (integer nrow)
public function integer wf_set_qc (integer nrow, string sitnbr)
public function integer wf_set_ip_jpno (string scino)
public function integer wf_requiredchk (string sdwobject, integer icurrow)
public subroutine wf_init ()
public function integer wf_create_ci (string scino)
public subroutine wf_clear_item (integer icurrow)
public function integer wf_catch_special_danga (integer nrow, ref double ioprc, ref double dcrate, string gbn)
end prototypes

public function integer wf_chk (integer nrow);/* ----------------------------------------------------------------------------- */
/* �˻����  ���ҽ��� �˻����� ����� �������� ������ �Ƿڼ��� �հݼ��� ���Ҽ��� */
/* ----------------------------------------------------------------------------- */
/* ���˻�(1)   �ڵ�    sysdate  null   sysdate  null    qty       qty      qty   */
/* ���˻�(1)   ����    sysdate  null     null   null    qty       qty       0    */
/*   �˻�       -        null  insemp    null   null    qty        0        0    */
/* ----------------------------------------------------------------------------- */

String sInsDat, sQcGub, sIoConfirm, sIoDate, sCheckNo

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
		MessageBox('Ȯ��','�˻�Ϸ� �ڷ�� �����ϽǼ� �����ϴ�.!!')
		return -2
	End If	
End If

Return -3
end function

public function integer wf_set_qc (integer nrow, string sitnbr);/* ǰ������ �˻����ڹ� �˻��� Setting */
String sNull, sGu, sInsEmp, sQcGub

SetNull(sNull)

sGu = '1'
f_get_qc(sGu,sItnbr,sNull,sNull, sQcGub, sInsEmp )

dw_insert.SetItem(nRow,'insemp', sInsEmp )
dw_insert.SetItem(nRow,'qcgub', sQcGub )

Return 1

end function

public function integer wf_set_ip_jpno (string scino);Double dItemQty, dItemPrice, dDcRate, dWrate, dUrate, dCiprc
String sCVcod, sItnbr, sNull, sIojpno, sIoGbn, sPspec, sCurr, sJijil, sIspeccode
String sItemDsc, sItemSize, sItemUnit, sItemGbn, sItemUseYn, sItemFilsk, sItemitgu, sSaupj, sLocalYn, sAmtgu
Long 	 nRow, ix

SetNull(sNull)

/* ��ǰ��� CI NO */
isOldCino = sCino

/* ����Ÿ ����� �ۼ� */
DataStore ds1

ds1 = Create datastore
ds1.DataObject = 'ds_sal_061201'
ds1.SetTransObject(sqlca)

If ds1.Retrieve(gs_sabu, sCino) <= 0 Then
	f_message_chk(33,'[�����ȣ]')
	Return -1
END If

sIoGbn = Trim(dw_imhist_ins.GetItemString(1,"iogbn"))

sSaupj = Trim(dw_imhist_ins.GetItemString(1,'saupj'))
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(30,'[�ΰ������]')
	dw_imhist_ins.SetColumn("sSaupj")
	dw_imhist_ins.SetFocus()	
	Return -1
End If

dw_insert.Reset()
dw_cid.Reset()
For ix = 1 To ds1.RowCount()
	sIojpno		= ds1.GetItemString(ix, 'iojpno')
	sCvcod		= ds1.GetItemString(ix, 'cvcod')
	If sCvcod <> Trim(dw_imhist_ins.GetItemString(1,'cvcod')) Then
		dw_insert.Reset()
		dw_cih.Reset()
		dw_cid.Reset()
		MessageBox('Ȯ ��','������ ���̾ ��ġ���� �ʽ��ϴ�')
		Return -1
	End If
	
	sitnbr		= ds1.GetItemString(ix, 'itnbr')
	sPspec		= ds1.GetItemString(ix, 'pspec')
	dItemQty 	= ds1.GetItemNumber(ix, 'ioqty')
	dItemprice	= ds1.GetItemNumber(ix, 'ioprc')
	dDcRate		= ds1.GetItemNumber(ix, 'dc_rate')
	sItemDsc		= ds1.GetItemString(ix, 'itdsc')
	sItemSize	= ds1.GetItemString(ix, 'ispec')
	sJijil		= ds1.GetItemString(ix, 'jijil')
	sIspeccode	= ds1.GetItemString(ix, 'ispec_code')
	
	sItemUnit	= ds1.GetItemString(ix, 'unmsr')
	sItemGbn		= ds1.GetItemString(ix, 'ittyp')
	sItemUseYn	= ds1.GetItemString(ix, 'useyn')
	sItemFilsk	= ds1.GetItemString(ix, 'filsk')
	sItemItgu 	= ds1.GetItemString(ix, 'itgu')
   sAmtgu      = ds1.GetItemString(ix, 'expcid_amtgu')
	
	sCurr		 	= ds1.GetItemString(ix, 'curr')
	dWRate		= ds1.GetItemNumber(ix, 'wrate')
	dURate		= ds1.GetItemNumber(ix, 'urate')
	dCiprc		= ds1.GetItemNumber(ix, 'ciprc')
	
	/* Imhist ���� */
	nRow = dw_insert.InsertRow(0)
	dw_insert.SetItem(nRow,'ioprc',      dItemPrice)
	dw_insert.SetItem(nRow,'imhist_qty', dItemQty)
	dw_insert.SetItem(nRow,'ioreqty',    dItemQty)
	dw_insert.SetItem(nRow,"dcrate",     dDcRate)
	dw_insert.SetItem(nRow,"saupj",	    ds1.GetItemString(ix, 'saupj'))
	
	/* �ݾ� ��� */
	dw_insert.SetItem(nRow,"ioamt",		 ds1.GetItemNumber(ix, 'ioamt'))
	
	dw_insert.SetItem(nRow,'ip_jpno',sIojpNo)
	
	dw_insert.SetItem(nRow,'itnbr',			  sItnbr)
	dw_insert.SetItem(nRow,'pspec',			  sPspec)
	dw_insert.SetItem(nRow,"itemas_itdsc",   sItemDsc)
	dw_insert.SetItem(nRow,"itemas_ispec",   sItemSize)
	dw_insert.SetItem(nRow,"itemas_jijil",   sJijil)
	dw_insert.SetItem(nRow,"itemas_ispec_code",  sIspecCode)
	dw_insert.SetItem(nRow,"itemas_filsk",   sItemFilsk)
	dw_insert.SetItem(nRow,"itemas_itgu",    sItemItgu)
	dw_insert.SetItem(nRow,"inv_seq",    	  ix)
	
	/* �˻�����, �˻籸�� */
	wf_set_qc(nRow, sItnbr)
	
	dw_insert.SetItem(nRow,"iogbn",sIoGbn)
	/* �ǸŹ�ǰ�� ��� �˻籸�� �Է¾��� */
	If sIoGbn = 'O41' Then
		dw_insert.SetItem(nRow,"qcgub",sNull)
	Else
		dw_insert.SetItem(nRow,"qcgub",'4')
	End If
	
	/* CI DETAIL ���� */
	nRow = dw_cid.InsertRow(0)
	
	dw_cid.SetItem(nRow, 'sabu',  gs_sabu)
	dw_cid.SetItem(nRow, 'itnbr', sItnbr)
	dw_cid.SetItem(nRow, 'order_spec', sPspec)
	dw_cid.SetItem(nRow, 'ciqty', 0)
	dw_cid.SetItem(nRow, 'ciprc', dCiprc)
	dw_cid.SetItem(nRow, 'ciamt', 0)
	dw_cid.SetItem(nRow, 'wamt', 0)
	dw_cid.SetItem(nRow, 'uamt', 0)
	dw_cid.SetItem(nRow, 'amtgu', samtgu)
	dw_cid.SetItem(nRow, 'ciseq', ix)
Next

/* EXPCIH ���� */
select localyn into :sLocalYn from expcih where sabu = :gs_sabu and cino = :scino;

dw_cih.Reset()
nRow = dw_cih.insertRow(0)

dw_cih.SetItem(nRow, 'sabu',   gs_sabu)
dw_cih.SetItem(nRow, 'cists',  '4')
dw_cih.SetItem(nRow, 'cvcod',  sCvcod)
dw_cih.SetItem(nRow, 'curr',   sCurr)
dw_cih.SetItem(nRow, 'wrate',  dWrate)
dw_cih.SetItem(nRow, 'urate',  dUrate)
dw_cih.SetItem(nRow, 'expamt', 0)
dw_cih.SetItem(nRow, 'wamt',   0)
dw_cih.SetItem(nRow, 'uamt',   0)
dw_cih.SetItem(nRow, 'saupj',  sSaupj)
dw_cih.SetItem(nRow, 'localyn',sLocalYn)

Destroy ds1

Return 0
end function

public function integer wf_requiredchk (string sdwobject, integer icurrow);String  sIoDate,sIoCust,sIoReDept,sIoReEmpNo,sIoDepotNo,sItem,sSpec,sBigo
String  sIojpNo, sIogbn, sQcGub, sInsEmp, sNull, sSaleGu

Double  dQty,dPrc

SetNull(sNull)

/* ��ǰ���� */
sIoGbn     = Trim(dw_imhist_ins.GetItemString(1,"iogbn"))
IF sIoGbn = "" OR IsNull(sIoGbn) THEN
	f_message_chk(30,'[��ǰ����]')
	dw_imhist_ins.SetColumn("iogbn")
	dw_imhist_ins.SetFocus()
	Return -1
END IF

/* �Ǹű��� */
SELECT SALEGU INTO :sSaleGu
  FROM IOMATRIX
 WHERE SABU = :gs_sabu AND
 		 IOGBN = :sIogbn;

If IsNull(sSaleGu) Then sSaleGu = 'N'
	
/* key check */
IF sDwObject = 'd_sal_061201' THEN
	sIoDate    = Trim(dw_imhist_ins.GetItemString(1,"sudat"))
	sIoReDept  = Trim(dw_imhist_ins.GetItemString(1,"ioredept") )
	sIoReEmpNo = Trim(dw_imhist_ins.GetItemString(1,"ioreemp")) 
	sIoCust    = Trim(dw_imhist_ins.GetItemString(1,"cvcod"))
	sIoDepotNo = Trim(dw_imhist_ins.GetItemString(1,"depot_no"))

	IF sIoDate = "" OR IsNull(sIoDate) THEN
		f_message_chk(30,'[��ǰ�Ƿ�����]')
		dw_imhist_ins.SetColumn("sudat")
		dw_imhist_ins.SetFocus()
		Return -1
	END IF
	
	IF sIoReDept = "" OR IsNull(sIoReDept) THEN
		f_message_chk(30,'[��ǰ���μ�]')
		dw_imhist_ins.SetColumn("ioredept")
		dw_imhist_ins.SetFocus()
		Return -1
	END IF
	IF sIoReEmpNo = "" OR IsNull(sIoReEmpNo) THEN
		f_message_chk(30,'[��ǰ�Ƿ���]')
		dw_imhist_ins.SetColumn("ioreemp")
		dw_imhist_ins.SetFocus()
		Return -1
	END IF
	
	/* �μ�����ǰ�� ��� ��ǰó ���Է� */
	If sIoGbn <> 'O44' Then
	  IF sIoCust = "" OR IsNull(sIoCust) THEN
		 f_message_chk(30,'[��ǰó]')
		 dw_imhist_ins.SetColumn("cvcod")
		 dw_imhist_ins.SetFocus()
		 Return -1
	  END IF
   End If
	
	IF sIoDepotNo = "" OR IsNull(sIoDepotNo) THEN
		f_message_chk(30,'[��ǰâ��]')
		dw_imhist_ins.SetColumn("depot_no")
		dw_imhist_ins.SetFocus()
		Return -1
	END IF
ELSEIF sDwObject = 'd_sal_06120' THEN
	sItem    = Trim(dw_insert.GetItemString(iCurRow,"itnbr"))
	dQty     = dw_insert.GetItemNumber(iCurRow,"ioreqty")
	dPrc     = dw_insert.GetItemNumber(iCurRow,"ioprc")
	sSpec    = dw_insert.GetItemString(iCurRow,"pspec")
	sBigo    = dw_insert.GetItemString(iCurRow,"bigo")
	sInsEmp  = dw_insert.GetItemString(iCurRow,"insemp")
	sQcGub   = dw_insert.GetItemString(iCurRow,"qcgub")

	dw_insert.SetFocus()

	IF sItem = "" OR IsNull(sItem) THEN
		f_message_chk(30,'[ǰ��]')
		dw_insert.SetColumn("itnbr")
		Return -1
	END IF
	
	IF dQty = 0 OR IsNull(dQty) THEN
		f_message_chk(30,'[����]')
		dw_insert.SetColumn("ioreqty")
		Return -1
	END IF

	/* �ǸŹ�ǰ�� ��츸 �ܰ� Ȯ�� */
	If sSaleGu = 'Y' Then
		IF dPrc = 0 OR IsNull(dPrc) THEN
			f_message_chk(30,'[�ܰ�]')
			dw_insert.SetColumn("ioprc")
			Return -1
		END IF
	End If

  /* ��� ���Է½� */
	IF sSpec = "" OR IsNull(sSpec) THEN
		dw_insert.SetItem(iCurRow,'pspec','.')
	END IF

  /* �˻籸��, �˻����� */
	IF sQcGub  = "" OR IsNull(sQcGub) THEN
		f_message_chk(30,'[�˻籸��]')
		dw_insert.SetColumn("qcgub")
		Return -1
	END IF

  /* ���˻簡 �ƴҰ�� �˻����� �ʼ� �Է� */
	IF sQcGub  <> "1" And ( sInsEmp = '' Or IsNull(sInsEmp)) THEN
		f_message_chk(30,'[�˻�����]')
		dw_insert.SetColumn("insemp")
		Return -1
	END IF

  /* ���˻��� ��� �˻����� */
	IF sQcGub  = "1"  THEN
		dw_insert.SetItem(iCurRow,'insemp', sNull)
	END IF
	
  /* �μ���ǰ�� ��� ��ǰ���� ���Է� */
	If sIoGbn <> 'O44' Then
	  IF sBigo = "" OR IsNull(sBigo) THEN
		  f_message_chk(30,'[��ǰ����]')
		  dw_insert.SetColumn("bigo")
		  dw_insert.SetFocus()
		  Return -1
	  END IF
   End If
	
	/* �������ȣ check */
	sIojpNo  = Trim(dw_insert.GetItemString(iCurRow,"ip_jpno"))
	If sIoGbn = 'O41' and is_IojpnoOK = 'Y' and ( sIojpno = '' or IsNull(sIojpno)) then
		f_message_chk(30,'[�������ȣ]')
		dw_insert.SetColumn("ip_jpno")
		dw_insert.SetFocus()
		Return -1
	end if
END IF

Return 1

end function

public subroutine wf_init ();String sDepotNo

dw_imhist_ins.SetRedraw(False)

// â����
f_child_saupj(dw_imhist_ins, 'depot_no', gs_saupj)
dw_imhist_ins.Reset()
dw_imhist_ins.InsertRow(0)

// �ΰ��� ����� ����
f_mod_saupj  (dw_imhist_ins, 'saupj')
dw_imhist_ins.SetRedraw(True)

dw_insert.Reset()
dw_cih.Reset()
dw_cid.Reset()

p_ins.Enabled = True
p_ins.PictureName = 'C:\erpman\image\���弱��_up.gif'

dw_imhist_ins.SetItem(1,"sudat",is_today)
dw_imhist_ins.SetItem(1,"ioreemp", Gs_empno)
dw_imhist_ins.SetItem(1,"empname", f_get_name('EMPNO',Gs_empno))

ib_any_typing = False

/* ��� */
IF sModStatus = 'I' THEN
	dw_imhist_ins.Modify('iojpno.protect = 1')
	//dw_imhist_ins.Modify("iojpno.background.color = '" + String(Rgb(192,192,192))+"'")
	dw_imhist_ins.Modify('iogbn.protect = 0')
	//dw_imhist_ins.Modify("iogbn.background.color = '" + String(Rgb(195,225,184))+"'")
	dw_imhist_ins.Modify('depot_no.protect = 0')
	//dw_imhist_ins.Modify("depot_no.background.color = '" + String(Rgb(195,225,184))+"'")

	dw_imhist_ins.Modify('sudat.protect = 0')
	//dw_imhist_ins.Modify("sudat.background.color = '" + String(Rgb(195,225,184))+"'")
	
//	dw_imhist_ins.Modify('saupj.protect = 0')
	//dw_imhist_ins.Modify("saupj.background.color = '" + String(Rgb(195,225,184))+"'")
	
	dw_imhist_ins.Modify('cvcod.protect = 0')
		
	dw_imhist_ins.SetColumn("ioredept")
ELSE
/* ���� */
	dw_imhist_ins.Modify('iojpno.protect = 0')
	//dw_imhist_ins.Modify("iojpno.background.color = 65535")
	dw_imhist_ins.Modify('iogbn.protect = 1')
	//dw_imhist_ins.Modify("iogbn.background.color = 80859087")
	dw_imhist_ins.Modify('depot_no.protect = 1')
	//dw_imhist_ins.Modify("depot_no.background.color = 80859087")

	dw_imhist_ins.Modify('cvcod.protect = 1')
	
	dw_imhist_ins.SetColumn("iojpno")
END IF

dw_imhist_ins.SetFocus()

end subroutine

public function integer wf_create_ci (string scino);


Return 1
end function

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"itemas_filsk",snull)
dw_insert.SetItem(iCurRow,"itemas_itgu",snull)
dw_insert.SetItem(iCurRow,"ioprc",      0)
dw_insert.SetItem(iCurRow,"dcrate",     0)

dw_insert.SetItem(iCurRow,"insemp",snull)
dw_insert.SetItem(iCurRow,"qcgub",snull)
end subroutine

public function integer wf_catch_special_danga (integer nrow, ref double ioprc, ref double dcrate, string gbn);/* ----------------------------------------------------- */
/* Ư���� ��� �������� �ܰ� ���                        */
/* ----------------------------------------------------- */
string s_order_date,s_itnbr,s_ispec,s_curr,s_pricegbn
int irow,rtn

If dw_insert.RowCount() < nRow Then Return 2

s_order_date = dw_imhist_ins.GetItemString(1,'sudat')
s_itnbr      = dw_insert.GetItemString(nRow,'itnbr')
s_ispec      = dw_insert.GetItemString(nRow,'itemas_ispec')
s_pricegbn   = '1'  //��ȭ
s_curr       = 'WON'		 

If IsNull(s_order_date) Or s_order_date = '' Then
   f_message_chk(40,'[��ǰ����]')
   Return -1
End If

If IsNull(s_itnbr) Or s_itnbr = '' Then
   f_message_chk(40,'[ǰ��]')
   Return -1
End If

If gbn = '1' Then
	/* �ܰ� �Է½� ������ ��� */
   rtn = sqlca.fun_erp100000014(s_itnbr , '.' ,ioprc,s_order_date,s_curr,s_pricegbn,dcrate)
   If rtn = -1 Then dcrate = 0
Else
	/* ������ �Է½� �ܰ���� */
   rtn = sqlca.fun_erp100000015(s_itnbr , '.' ,s_order_date,s_curr,s_pricegbn,dcrate,ioprc)
	ioprc  = TrunCate(ioprc,0)
   If rtn = -1 Then 	ioprc = 0
End If

return 1
end function

on w_sal_06120.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.rb_insert=create rb_insert
this.rb_modify=create rb_modify
this.dw_imhist_ins=create dw_imhist_ins
this.dw_cid=create dw_cid
this.dw_cih=create dw_cih
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.rb_insert
this.Control[iCurrent+4]=this.rb_modify
this.Control[iCurrent+5]=this.dw_imhist_ins
this.Control[iCurrent+6]=this.dw_cid
this.Control[iCurrent+7]=this.dw_cih
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_3
end on

on w_sal_06120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.rb_insert)
destroy(this.rb_modify)
destroy(this.dw_imhist_ins)
destroy(this.dw_cid)
destroy(this.dw_cih)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;
PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_imhist_ins.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

dw_Cih.SetTransObject(SQLCA)
dw_Cid.SetTransObject(SQLCA)

/* �������ȣ �ʼ��Է� ���� */
is_IojpnoOK = 'Y'

/* ǰ���Է½� Ŀ����ġ ���� - '1' : ǰ��, '2' : ǰ�� */
select substr(dataname,1,1) into :isCursor
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 12;

/* �˼����� ��� ���� - ��� ���� */
sNappum = 'N'

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_06120
integer x = 46
integer y = 356
integer width = 4553
integer height = 1932
integer taborder = 20
string dataobject = "d_sal_06120"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;String sNull, sIocust, sIocustname
Double  dItemQty,dItemPrice,dDcRate,dNewDcRate,dTemp
Long    nRow,iRtnValue,nCnt

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* ���ڵ� */
	Case "cust_no"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(nRow,"cust_name",snull)
			Return
		END IF
		
		SELECT "CUSTOMER"."CUST_NAME"  INTO :sIoCustName  
		  FROM "CUSTOMER"  
		 WHERE "CUSTOMER"."CUST_NO" = :sIoCust   ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 1
		ELSE
			SetItem(nRow,"cust_name",sIoCustName)
		END IF
	Case "cust_name"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			SetItem(nRow,"cust_no",snull)
			Return
		END IF
		
		SELECT "CUSTOMER"."CUST_NO"  INTO :sIoCust  
		  FROM "CUSTOMER"  
		 WHERE "CUSTOMER"."CUST_NAME" = :sIoCustName ;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				SetItem(nRow,"cust_no",snull)
				SetItem(nRow,"cust_name",snull)
				Return 1
			END IF
		ELSE
			SetItem(nRow,"cust_no",sIoCust)
		END IF
	/* ���� */
	Case "ioreqty"
		dItemQty = Double(GetText())
		IF IsNull(dItemQty) THEN SetItem(nRow,'ioreqty',0)
		
		/* �������� �� */
		dTemp = GetItemNumber(nRow,"imhist_qty")
		If dTemp = 0 Or IsNull(dTemp) Then
		ElseIf dItemQty > dTemp Then
			f_message_chk(150,'~r~n~r~n[����Ƿڼ���:'+string(dTemp,'#,###')+ ']')
			Return 1
		End If
		
		dItemPrice = GetItemNumber(nRow,"ioprc")
		IF IsNull(dItemPrice) THEN dItemPrice =0
		
		SetItem(nRow,"ioamt",TrunCate(dItemQty * dItemPrice,0))
	/* �ܰ� */
	Case "ioprc"
		dItemPrice = Double(GetText())
		If IsNull(dItemPrice) Then dItemPrice = 0
		
		/* Ư�� ������ ��� */
		dNewDcRate = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'1') <> 1 Then Return 2
		SetItem(nRow,"dcrate",dNewDcRate)
		
		/* �ݾ� ��� */
		dItemQty = GetItemNumber(nRow,"ioreqty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		SetItem(nRow,"ioamt",TrunCate(dItemQty * dItemPrice,0))
	/* ������ */
	Case "dcrate"
		dNewDcRate = Double(GetText())
		If IsNull(dNewDcRate) Then dNewDcRate = 0
		
		/* Ư�� ������ ��� */
		dItemPrice = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'2') <> 1 Then Return 2
		SetItem(nRow,"ioprc",dItemPrice)
		
		/* �ݾ� ��� */
		dItemQty = GetItemNumber(nRow,"ioreqty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		SetItem(nRow,"ioamt",TrunCate(dItemQty * dItemPrice,0))
END Choose
end event

event dw_insert::rbuttondown;Long    nRow
String  sCvcod,sItnbr

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		TriggerEvent(ItemChanged!)
	Case "itemas_itdsc"
	  gs_gubun = '1'  
	  open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  SetColumn("itnbr")
	  SetFocus()
	
	  TriggerEvent(ItemChanged!)
	Case "itemas_ispec"
	  gs_gubun = '1'  
	  open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  SetColumn("itnbr")
	  SetFocus()
		
	  TriggerEvent(ItemChanged!)
	Case "cust_no"
	  Open(w_cust_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"cust_no",gs_code)
	  SetItem(nRow,"cust_name",gs_codename)
	Case "cust_name"
		Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"cust_name",gs_codeName)
		TriggerEvent(ItemChanged!)
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

event dw_insert::rowfocuschanging;If newrow <= 0 Then Return

If wf_chk(newrow) = 0 Then
	p_del.Enabled = True
	p_ins.PictureName = 'C:\erpman\image\����_d.gif'
Else
	p_del.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\����_up.gif'
End If

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

type p_delrow from w_inherite`p_delrow within w_sal_06120
boolean visible = false
integer x = 4375
integer y = 2840
end type

type p_addrow from w_inherite`p_addrow within w_sal_06120
boolean visible = false
integer x = 4201
integer y = 2840
end type

type p_search from w_inherite`p_search within w_sal_06120
boolean visible = false
integer x = 3493
integer y = 2832
end type

type p_ins from w_inherite`p_ins within w_sal_06120
integer x = 3575
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\���弱��_up.gif"
end type

event p_ins::clicked;call super::clicked;Long il_currow,il_functionvalue
String sNull, sDepotNo, sSaupj
String sCvcod, sCvName

SetNull(sNull)

IF dw_insert.AcceptText() = -1 THEN RETURN

il_currow = dw_insert.RowCount()
IF il_currow <=0 THEN
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(dw_insert.DataObject,il_currow)
END IF

sSaupj = Trim(dw_imhist_ins.GetItemString(1,'saupj'))
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(30,'[�ΰ������]')
	dw_imhist_ins.SetColumn("saupj")
	dw_imhist_ins.SetFocus()	
	Return 
End If

sDepotNo = Trim(dw_imhist_ins.GetItemString(1,'depot_no'))
If IsNull(sDepotNo) or sDepotNo = '' Then
	f_message_chk(30,'[��ǰâ��]')
	dw_imhist_ins.SetColumn("depot_no")
	dw_imhist_ins.SetFocus()	
	Return 
End If

sCvcod = Trim(dw_imhist_ins.GetItemString(1,'cvcod'))
sCvName  = Trim(dw_imhist_ins.GetItemString(1,'cvname'))
If sCvcod = '' Or IsNull(sCvcod) Then
	f_message_chk(40,'[��ǰó]')
	dw_imhist_ins.SetFocus()
	dw_imhist_ins.SetColumn('cvcod')
	Return 2
End If

IF il_functionvalue = 1 THEN
	/* ������� �������ϵ��� ���� */
	dw_imhist_ins.Modify('iogbn.protect = 1')
	//dw_imhist_ins.Modify("iogbn.background.color = 80859087")
	dw_imhist_ins.Modify('depot_no.protect = 1')
	//dw_imhist_ins.Modify("depot_no.background.color = 80859087")

	dw_imhist_ins.Modify('cvcod.protect = 1')

	/* �ش� CI �� �о�´� */
	gs_code = 'A'
	gs_gubun = 'Y'
	OpenWithParm(w_expci_popup, sSaupj)	/* �ΰ������ */
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN		

	wf_set_ip_jpno(gs_code)
		
	dw_insert.SetFocus()
END IF
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\���弱��_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\���弱��_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sal_06120
end type

type p_can from w_inherite`p_can within w_sal_06120
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_sal_06120
boolean visible = false
integer x = 3680
integer y = 2840
end type

type p_inq from w_inherite`p_inq within w_sal_06120
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String  sIoJpNo, sCino, sSaleDt
Long    nCnt

If dw_imhist_ins.AcceptText() <> 1 Then 	Return

sIoJpNo = Mid(dw_imhist_ins.GetItemString(1,"iojpno"),1,12)
IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
	f_message_chk(30,'[��ǰ�Ƿڹ�ȣ]')
	dw_imhist_ins.SetColumn("iojpno")
	dw_imhist_ins.SetFocus()
	Return 
END IF

IF dw_imhist_ins.Retrieve(gs_sabu,sIoJpNo) > 0 THEN
	sCino = dw_imhist_ins.GetItemString(1,'inv_no')
	
	/* Invoice���� ��ȸ */
	dw_cih.Retrieve(gs_sabu, sCino)
	dw_cid.Retrieve(gs_sabu, sCino)
	
	dw_insert.Retrieve(gs_sabu,sIoJpNo)
	dw_imhist_ins.Modify('iojpno.protect = 1')
	//dw_imhist_ins.Modify("iojpno.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_imhist_ins.Modify('sudat.protect = 1')
	//dw_imhist_ins.Modify("sudat.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_imhist_ins.Modify('iogbn.protect = 1')
	//dw_imhist_ins.Modify("iogbn.background.color = '"+String(Rgb(192,192,192))+"'")

	dw_imhist_ins.Modify('saupj.protect = 1')
	//dw_imhist_ins.Modify("saupj.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_insert.ScrollToRow(1)
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	
	P_ins.Enabled = False //���弱��
	p_ins.PictureName = 'C:\erpman\image\���弱��_d.gif'
	ib_any_typing = False
ELSE
	wf_init()
	f_message_chk(50,'')
	dw_imhist_ins.SetColumn("iojpno")
	dw_imhist_ins.SetFocus()
	Return
END IF

/* �˻�Ȯ�εȰ��� 1���̻��̸� �߰��Ұ�  */
SELECT COUNT("IMHIST"."INSDAT")   INTO :nCnt
  FROM "IMHIST"  
  WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
	     ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
		  ( "IMHIST"."JNPCRT" ='005') AND
		  ( "IMHIST"."INSDAT" IS NOT NULL);

If nCnt > 0 Then
	P_ins.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\���弱��_d.gif'
Else
	P_ins.Enabled = True
	p_ins.PictureName = 'C:\erpman\image\���弱��_up.gif'
End If

/* ��ǰȮ���Ǿ� ������ ���� �Ұ� */
sSaleDt = dw_cih.GetItemString(1,'saledt')

If Not IsNull(sSaleDt) Then
	p_del.Enabled = False
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
	w_mdi_frame.sle_msg.text = '��ǰȮ���� �ڷ��Դϴ�.!!'
Else
	P_del.Enabled = True
	p_del.PictureName = 'C:\erpman\image\����_up.gif'
End If

end event

type p_del from w_inherite`p_del within w_sal_06120
end type

event p_del::clicked;call super::clicked;Long iCurRow, lCiseq, nRow
Double dCiamt

iCurRow = dw_insert.GetRow()
IF iCurRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

If wf_chk(iCurRow) <> 0 Then Return

IF F_Msg_Delete() = -1 THEN Return

/* Ci ���� */
lCiSeq = dw_insert.GetItemNumber(iCurRow,"inv_seq")
nRow = dw_cid.Find("ciseq = " + string(lciseq), 1, dw_cid.RowCount())
If nRow <= 0 Then
	MessageBox('Ȯ��','������ ǰ���� ã�� ���� �����ϴ�.!!')
	RollBack;
	Return
End If

dw_cid.DeleteRow(nRow)

If dw_cid.RowCount() <= 0 Then
	dw_cih.DeleteRow(1)
Else
	dCiamt = dw_cid.GetItemNumber(1,'sum_ciamt')
	If IsNull(dCiamt) Then dCiamt = 0

	dw_cih.SetItem(1,"expamt",    dCiamt)
End If

/* IMHIST ���� -> CI DETAIL ���� -> CI HEADER ���� */
dw_insert.DeleteRow(iCurRow)

IF sModStatus = 'M' THEN
	IF dw_insert.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF

	/* CI DETAIL ���� �����ϰ� HEADER �����ؾ��� */
	IF dw_cid.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF
	
	IF dw_cih.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF

	COMMIT;
	If dw_insert.RowCount() <= 0 Then wf_init()
END IF

dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()

w_mdi_frame.sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'
end event

type p_mod from w_inherite`p_mod within w_sal_06120
end type

event p_mod::clicked;call super::clicked;/* ----------------------------------------------------------------------------- */
/* ��ǰ�Ƿڽ� setting ���                                                       */
/* ----------------------------------------------------------------------------- */
/* �˻����  ���ҽ��� �˻����� ����� �������� ������ �Ƿڼ��� �հݼ��� ���Ҽ��� */
/* ----------------------------------------------------------------------------- */
/* ���˻�(1)   �ڵ�    sysdate  null   sysdate  null    qty       qty      qty   */
/* ���˻�(1)   ����    sysdate  null     null   null    qty       qty       0    */
/*   �˻�       -        null  insemp    null   null    qty        0        0    */
/* ----------------------------------------------------------------------------- */
Integer	iFunctionValue,iRowCount,k,iMaxIoNo,iCurRow
String   sIoJpNo,sIoJpGbn,sIoSuDate, sDepotNo, sCino, sCurr
string   qcgub,sIoConfirm,sNull,sIoDate, sSaupj
Long     nMaxSeq, lciseq, nRow, ix
Double   dIoPrc, dCiQty, dCiPrc, Wrate, Urate, dCiAmt

SetNull(sNull)

w_mdi_frame.sle_msg.text =""

/* header key check */
If dw_imhist_ins.accepttext() <> 1 Then Return
iFunctionValue = Wf_RequiredChk(dw_imhist_ins.DataObject,1)
IF iFunctionValue = -1 THEN Return

If Not (dw_cih.RowCount() > 0 and dw_cid.RowCount() > 0 ) Then Return

/* detail key check */
If dw_insert.accepttext() <> 1 then Return
iRowCount = dw_insert.RowCount()
IF iRowCount <=0 THEN Return
FOR k = 1 TO iRowCount 													/*�ʼ� üũ*/
	iFunctionValue = Wf_RequiredChk(dw_insert.DataObject,k)
	IF iFunctionValue = -1 THEN
		dw_insert.ScrollToRow(k)
		Return
	END IF
NEXT

sIoSuDate = dw_imhist_ins.GetItemString(1,"sudat")						/*�Ƿ�����*/

IF F_Msg_Update() = -1 THEN Return

sSaupj = Trim(dw_imhist_ins.GetItemString(1,'saupj'))

IF sModStatus = 'I' THEN
	/*��ǰ�Ƿڹ�ȣ ä��*/
   sIoJpGbn = 'C0'
	iMaxIoNo = sqlca.fun_junpyo(gs_sabu,sIoSuDate,sIoJpGbn)
	IF iMaxIoNo <= 0 THEN
		f_message_chk(51,'')
		ROLLBACK;
		Return 1
	END IF
	commit;
	sIoJpNo = sIoSuDate + String(iMaxIoNo,'0000')
	
	dw_imhist_ins.SetItem(1,"iojpno",sIoJpNo)
	MessageBox("Ȯ ��","ä���� ��ǰ�Ƿڹ�ȣ�� "+sIoJpNo+" �� �Դϴ�!!")
	
	/* CI NO ä�� */
	iMaxIoNo = sqlca.fun_junpyo(gs_sabu,sIoSuDate,'X2')
	IF iMaxIoNo <= 0 THEN
		f_message_chk(51,'')
		ROLLBACK;
		Return 1
	END IF
	commit;
	
	sCiNo = sIoSuDate + String(iMaxIoNo,'000')
ELSE
	/* ������ ��� */
	sIoJpNo = Mid(dw_imhist_ins.GetItemString(1,"iojpno"),1,12)
	sCiNo	  = dw_imhist_ins.GetItemString(1,"inv_no")
END IF

/* ���� �ִ밪 */
If dw_insert.RowCount() > 0 Then
	nMaxSeq = Long(dw_insert.GetItemString(1,'maxseq'))
	If IsNull(nMaxSeq) Then nMaxSeq = 0
Else
	nMaxSeq = 0
End If

/* ���ҽ����ڵ� ���� */
sDepotNo =  dw_imhist_ins.GetItemString(1,'depot_no')

SELECT "VNDMST"."HOMEPAGE"
  INTO :sIoconFirm
  FROM "VNDMST"
 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' );

If IsNull(sIoConFirm) or sIoConFirm = '' Then	sIoConfirm = 'N'

dw_imhist_ins.SetItem(1,'io_confirm',sIoconFirm) 
 
IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN
	f_message_chk(51,'[��ǰ�Ƿڹ�ȣ]')
	Return
ELSE
	/* Ci ���� */
	wrate = dw_cih.GetItemNumber(1,'wrate')
	urate = dw_cih.GetItemNumber(1,'urate')
	If IsNull(wrate) Or wrate = 0 Then wrate = 1
	If IsNull(urate) Or urate = 0 Then urate = 1
	If IsNull(dCiprc) Then dCiprc = 0
		
	For k = 1 TO dw_cid.RowCount()
		dw_cid.SetItem(k, 'sabu', 	 gs_sabu)
		dw_cid.SetItem(k, 'cino', 	 sCino)
		
		dCiqty = dw_insert.GetItemNumber(k,"ioreqty")
		dCiprc = dw_cid.GetItemNumber(k,'ciprc')
		
		dw_cid.SetItem(k,'ciqty', dCiqty*-1) // �������
		dw_cid.SetItem(k,'ciamt', TrunCate(Round(dCiqty,2) * Round(dCiprc,5),2)*-1) // ����ݾ�
		dw_cid.SetItem(k,'itmamt',TrunCate(Round(dCiqty,2) * Round(dCiprc,5),2)*-1) // ǰ��ݾ�
	Next
	
	/* CI header SETTING */
	dw_cih.SetItem(1, "sabu",     gs_sabu)
	dw_cih.SetItem(1, "cino",     sCino)
	dw_cih.SetItem(1, 'outcfdt',  sIoSuDate) /* ���Ȯ���� (����Ȯ������ �����Ͻ�) */
	dw_cih.SetItem(1, 'cidate', sIoSuDate)	
	
	dCiamt = dw_cid.GetItemNumber(1,'sum_ciamt')
	If IsNull(dCiamt) Then dCiamt = 0

	dw_cih.SetItem(1, "expamt",    dCiamt)
	dw_cih.SetItem(1, "saupj",     sSaupj)

	/* ci detail-> header update : trigger���� ��ȭ���� ���� ó�� */
	IF dw_cid.Update() <> 1 THEN
		ROLLBACK;
		f_message_chk(32,'[EXPCID]')
		Wf_Init()
		Return
	END IF
	
	IF dw_cih.Update() <> 1 THEN
		ROLLBACK;
		f_message_chk(32,'[EXPCIH]')
		Wf_Init()
		Return
	END IF
	
	If dw_cid.Retrieve(gs_sabu, sCino) <= 0 Then
		ROLLBACK;
		f_message_chk(32,'[��ȸ]')
		Wf_Init()
		Return
	END IF
	
	For k = 1 TO dw_insert.RowCount()
      If dw_insert.GetItemStatus(k,0,Primary!) = NewModified! Then
			nMaxSeq += 1
			dw_insert.SetItem(k,"sabu",       gs_sabu)
			dw_insert.SetItem(k,"iojpno",     sIoJpNo+String(nMaxseq,'000'))
			
			dw_insert.SetItem(k,"inv_no",     sCino)	/* CI NO SETTING */
		End If

		/* ------------------ CI Detail Setting ------------------ */
		lCiSeq = dw_insert.GetItemNumber(k,"inv_seq")
		nRow = dw_cid.Find("ciseq = " + string(lciseq), 1, dw_cid.RowCount())
		If nRow <= 0 Then
			RollBack;
			MessageBox('Ȯ��','������ ǰ���� ã�� ���� �����ϴ�.!!')
			wf_init()
			Return
		End If
			

		dCiqty = dw_insert.GetItemNumber(k,"ioreqty")
		dCiprc = dw_cid.GetItemNumber(nRow,'ciprc')
		
		/* ------------------ IMHIST Setting ------------------ */
		/* �˻�Ϸᳪ �԰���� ���ο� ���� */
		If wf_chk(k) = 0 Then
			/* ���� �������� : ���˻��ϰ�� �Է�*/
			qcgub      = dw_insert.GetItemString(k,'qcgub')
			
			dw_insert.SetItem(k,"io_date",    sNull)
			dw_insert.SetItem(k,"iosuqty",    0)
			dw_insert.SetItem(k,"ioqty",      0)
			dw_insert.SetItem(k,"ioamt",      0)
			dw_insert.SetItem(k,"insdat",     sNull)
			dw_insert.SetItem(k,"decisionyn", sNull)
			
			/* ���˻��ϰ�� */
			If qcgub = '1' Then
				dw_insert.SetItem(k,"insdat",     sIoSuDate)		
				dw_insert.SetItem(k,"io_confirm", sIoConFirm)
				dw_insert.SetItem(k,"iosuqty",    dw_insert.GetItemNumber(k,"ioreqty"))
				dw_insert.SetItem(k,"decisionyn", 'Y')
				
				/* �����ڵ� */
				If sIoConFirm = 'Y' Then				
					dw_insert.SetItem(k,"io_date",    sIoSuDate)
					dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,"ioreqty"))
					
					dIoPrc = dw_insert.GetItemNumber(k,"ioprc")
					If IsNull(dIoPrc) Then dIoPrc = 0
					dw_insert.SetItem(k,"ioamt",      dw_insert.GetItemNumber(k,"iosuqty") * dw_insert.GetItemNumber(k,"ioprc"))
					
					/* �˼����� ������ ��� */
					If sNappum = 'N' Then
						dw_insert.SetItem(k,"imhist_yebi1",  sIoSuDate) 
					End If
				End If
			End If
			
			dw_insert.SetItem(k,"iogbn",      dw_imhist_ins.GetItemString(1,"iogbn"))
			dw_insert.SetItem(k,"sudat", 		 sIoSuDate)
		End If
		
		dw_insert.SetItem(k,"ioredept",   dw_imhist_ins.GetItemString(1,"ioredept"))
		dw_insert.SetItem(k,"ioreemp",    dw_imhist_ins.GetItemString(1,"ioreemp"))
		dw_insert.SetItem(k,"cvcod",      dw_imhist_ins.GetItemString(1,"cvcod"))
		dw_insert.SetItem(k,"sarea",      dw_imhist_ins.GetItemString(1,"cust_area"))
		dw_insert.SetItem(k,"depot_no",   sDepotNo)
	
		dw_insert.SetItem(k,"inpcnf", 'I')   // �������(�԰�)
		dw_insert.SetItem(k,"botimh",'')
		dw_insert.SetItem(k,"jnpcrt", '005') // ��ǥ��������(��ǰ�Ƿ�)
		dw_insert.SetItem(k,"opseq",'9999')
		dw_insert.SetItem(k,"outchk",'N')
		
		/* �������ȣ :�ǸŹ�ǰ�ϰ�츸 �Է����*/
		If dw_imhist_ins.GetItemString(1,"iogbn") <> 'O41' Then
			dw_insert.SetItem(k,"ip_jpno",'')
		End If
		
		/* �μ���ǰ�ϰ�� �Ƿںμ� -> �ŷ�ó */
		If dw_imhist_ins.GetItemString(1,"iogbn") = 'O44' Then
			dw_insert.SetItem(k,"cvcod",      dw_imhist_ins.GetItemString(1,"ioredept"))
		End If
	Next
END IF

IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	f_message_chk(32,'[IMHIST]')
	Wf_Init()
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

Wf_Init()
end event

type cb_exit from w_inherite`cb_exit within w_sal_06120
integer x = 4361
integer y = 3324
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_sal_06120
integer x = 3305
integer y = 3324
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;///* ----------------------------------------------------------------------------- */
///* ��ǰ�Ƿڽ� setting ���                                                       */
///* ----------------------------------------------------------------------------- */
///* �˻����  ���ҽ��� �˻����� ����� �������� ������ �Ƿڼ��� �հݼ��� ���Ҽ��� */
///* ----------------------------------------------------------------------------- */
///* ���˻�(1)   �ڵ�    sysdate  null   sysdate  null    qty       qty      qty   */
///* ���˻�(1)   ����    sysdate  null     null   null    qty       qty       0    */
///*   �˻�       -        null  insemp    null   null    qty        0        0    */
///* ----------------------------------------------------------------------------- */
//Integer	iFunctionValue,iRowCount,k,iMaxIoNo,iCurRow
//String   sIoJpNo,sIoJpGbn,sIoSuDate, sDepotNo, sCino, sCurr, sLocalyn
//string   qcgub,sIoConfirm,sNull,sIoDate, sSaupj
//Long     nMaxSeq, lciseq, nRow, ix
//Double   dIoPrc, dCiQty, dCiPrc, Wrate, Urate, dCiAmt
//
//SetNull(sNull)
//
//sle_msg.text =""
//
///* header key check */
//If dw_imhist_ins.accepttext() <> 1 Then Return
//iFunctionValue = Wf_RequiredChk(dw_imhist_ins.DataObject,1)
//IF iFunctionValue = -1 THEN Return
//
//If Not (dw_cih.RowCount() > 0 and dw_cid.RowCount() > 0 ) Then Return
//
///* detail key check */
//If dw_insert.accepttext() <> 1 then Return
//iRowCount = dw_insert.RowCount()
//IF iRowCount <=0 THEN Return
//FOR k = 1 TO iRowCount 													/*�ʼ� üũ*/
//	iFunctionValue = Wf_RequiredChk(dw_insert.DataObject,k)
//	IF iFunctionValue = -1 THEN
//		dw_insert.ScrollToRow(k)
//		Return
//	END IF
//NEXT
//
//sIoSuDate = dw_imhist_ins.GetItemString(1,"sudat")						/*�Ƿ�����*/
//
//IF F_Msg_Update() = -1 THEN Return
//
//sSaupj = Trim(dw_imhist_ins.GetItemString(1,'saupj'))
//
//IF sModStatus = 'I' THEN
//	/*��ǰ�Ƿڹ�ȣ ä��*/
//   sIoJpGbn = 'C0'
//	iMaxIoNo = sqlca.fun_junpyo(gs_sabu,sIoSuDate,sIoJpGbn)
//	IF iMaxIoNo <= 0 THEN
//		f_message_chk(51,'')
//		ROLLBACK;
//		Return 1
//	END IF
//	commit;
//	sIoJpNo = sIoSuDate + String(iMaxIoNo,'0000')
//	
//	dw_imhist_ins.SetItem(1,"iojpno",sIoJpNo)
//	MessageBox("Ȯ ��","ä���� ��ǰ�Ƿڹ�ȣ�� "+sIoJpNo+" �� �Դϴ�!!")
//	
//	/* CI NO ä�� */
//	iMaxIoNo = sqlca.fun_junpyo(gs_sabu,sIoSuDate,'X2')
//	IF iMaxIoNo <= 0 THEN
//		f_message_chk(51,'')
//		ROLLBACK;
//		Return 1
//	END IF
//	commit;
//	
//	sCiNo = sIoSuDate + String(iMaxIoNo,'000')
//ELSE
//	/* ������ ��� */
//	sIoJpNo = Mid(dw_imhist_ins.GetItemString(1,"iojpno"),1,12)
//	sCiNo	  = dw_imhist_ins.GetItemString(1,"inv_no")
//END IF
//
///* ���� �ִ밪 */
//If dw_insert.RowCount() > 0 Then
//	nMaxSeq = Long(dw_insert.GetItemString(1,'maxseq'))
//	If IsNull(nMaxSeq) Then nMaxSeq = 0
//Else
//	nMaxSeq = 0
//End If
//
///* ���ҽ����ڵ� ���� */
//sDepotNo =  dw_imhist_ins.GetItemString(1,'depot_no')
//
//SELECT "VNDMST"."HOMEPAGE"
//  INTO :sIoconFirm
//  FROM "VNDMST"
// WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' );
//
//If IsNull(sIoConFirm) or sIoConFirm = '' Then	sIoConfirm = 'N'
//
//dw_imhist_ins.SetItem(1,'io_confirm',sIoconFirm) 
// 
//IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN
//	f_message_chk(51,'[��ǰ�Ƿڹ�ȣ]')
//	Return
//ELSE
//	/* Ci ���� */
//	wrate = dw_cih.GetItemNumber(1,'wrate')
//	urate = dw_cih.GetItemNumber(1,'urate')
//	If IsNull(wrate) Or wrate = 0 Then wrate = 1
//	If IsNull(urate) Or urate = 0 Then urate = 1
//	If IsNull(dCiprc) Then dCiprc = 0
//		
//	For k = 1 TO dw_cid.RowCount()
//		dw_cid.SetItem(k, 'sabu', 	 gs_sabu)
//		dw_cid.SetItem(k, 'cino', 	 sCino)
//		
//		dCiqty = dw_insert.GetItemNumber(k,"ioreqty")
//		dCiprc = dw_cid.GetItemNumber(k,'ciprc')
//		
//		dw_cid.SetItem(k,'ciqty', dCiqty*-1) // �������
//		dw_cid.SetItem(k,'ciamt', TrunCate(Round(dCiqty,2) * Round(dCiprc,5),2)*-1) // ����ݾ�
//		dw_cid.SetItem(k,'itmamt',TrunCate(Round(dCiqty,2) * Round(dCiprc,5),2)*-1) // ǰ��ݾ�
//	Next
//	
//	/* CI header SETTING */
//	dw_cih.SetItem(1, "sabu",     gs_sabu)
//	dw_cih.SetItem(1, "cino",     sCino)
//	dw_cih.SetItem(1, 'outcfdt',  sIoSuDate) /* ���Ȯ���� (����Ȯ������ �����Ͻ�) */
//	dw_cih.SetItem(1, 'cidate', sIoSuDate)	
//	
//	// Local, Direct�� �� ����������� �Ѵ�.
//	SetNull(sLocalYn)
//	Select localyn into :sLocalyn from expcih
//	 Where sabu = :gs_sabu And cino = :sCino;
//
//	dw_cih.SetItem(1, 'localyn', slocalyn)
//	
//	dCiamt = dw_cid.GetItemNumber(1,'sum_ciamt')
//	If IsNull(dCiamt) Then dCiamt = 0
//
//	dw_cih.SetItem(1, "expamt",    dCiamt)
//	dw_cih.SetItem(1, "saupj",     sSaupj)
//
//	/* ci detail-> header update : trigger���� ��ȭ���� ���� ó�� */
//	IF dw_cid.Update() <> 1 THEN
//		ROLLBACK;
//		f_message_chk(32,'[EXPCID]')
//		Wf_Init()
//		Return
//	END IF
//	
//	IF dw_cih.Update() <> 1 THEN
//		ROLLBACK;
//		f_message_chk(32,'[EXPCIH]')
//		Wf_Init()
//		Return
//	END IF
//	
//	If dw_cid.Retrieve(gs_sabu, sCino) <= 0 Then
//		ROLLBACK;
//		f_message_chk(32,'[��ȸ]')
//		Wf_Init()
//		Return
//	END IF
//	
//	For k = 1 TO dw_insert.RowCount()
//      If dw_insert.GetItemStatus(k,0,Primary!) = NewModified! Then
//			nMaxSeq += 1
//			dw_insert.SetItem(k,"sabu",       gs_sabu)
//			dw_insert.SetItem(k,"iojpno",     sIoJpNo+String(nMaxseq,'000'))
//			
//			dw_insert.SetItem(k,"inv_no",     sCino)	/* CI NO SETTING */
//		End If
//
//		/* ------------------ CI Detail Setting ------------------ */
//		lCiSeq = dw_insert.GetItemNumber(k,"inv_seq")
//		nRow = dw_cid.Find("ciseq = " + string(lciseq), 1, dw_cid.RowCount())
//		If nRow <= 0 Then
//			RollBack;
//			MessageBox('Ȯ��','������ ǰ���� ã�� ���� �����ϴ�.!!')
//			wf_init()
//			Return
//		End If
//			
//
//		dCiqty = dw_insert.GetItemNumber(k,"ioreqty")
//		dCiprc = dw_cid.GetItemNumber(nRow,'ciprc')
//		
//		/* ------------------ IMHIST Setting ------------------ */
//		/* �˻�Ϸᳪ �԰���� ���ο� ���� */
//		If wf_chk(k) = 0 Then
//			/* ���� �������� : ���˻��ϰ�� �Է�*/
//			qcgub      = dw_insert.GetItemString(k,'qcgub')
//			
//			dw_insert.SetItem(k,"io_date",    sNull)
//			dw_insert.SetItem(k,"iosuqty",    0)
//			dw_insert.SetItem(k,"ioqty",      0)
//			dw_insert.SetItem(k,"ioamt",      0)
//			dw_insert.SetItem(k,"insdat",     sNull)
//			dw_insert.SetItem(k,"decisionyn", sNull)
//			
//			/* ���˻��ϰ�� */
//			If qcgub = '1' Then
//				dw_insert.SetItem(k,"insdat",     sIoSuDate)		
//				dw_insert.SetItem(k,"io_confirm", sIoConFirm)
//				dw_insert.SetItem(k,"iosuqty",    dw_insert.GetItemNumber(k,"ioreqty"))
//				dw_insert.SetItem(k,"decisionyn", 'Y')
//				
//				/* �����ڵ� */
//				If sIoConFirm = 'Y' Then				
//					dw_insert.SetItem(k,"io_date",    sIoSuDate)
//					dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,"ioreqty"))
//					
//					dIoPrc = dw_insert.GetItemNumber(k,"ioprc")
//					If IsNull(dIoPrc) Then dIoPrc = 0
//					dw_insert.SetItem(k,"ioamt",      dw_insert.GetItemNumber(k,"iosuqty") * dw_insert.GetItemNumber(k,"ioprc"))
//					
//					/* �˼����� ������ ��� */
//					If sNappum = 'N' Then
//						dw_insert.SetItem(k,"imhist_yebi1",  sIoSuDate) 
//					End If
//				End If
//			End If
//			
//			dw_insert.SetItem(k,"iogbn",      dw_imhist_ins.GetItemString(1,"iogbn"))
//			dw_insert.SetItem(k,"sudat", 		 sIoSuDate)
//		End If
//		
//		dw_insert.SetItem(k,"ioredept",   dw_imhist_ins.GetItemString(1,"ioredept"))
//		dw_insert.SetItem(k,"ioreemp",    dw_imhist_ins.GetItemString(1,"ioreemp"))
//		dw_insert.SetItem(k,"cvcod",      dw_imhist_ins.GetItemString(1,"cvcod"))
//		dw_insert.SetItem(k,"sarea",      dw_imhist_ins.GetItemString(1,"cust_area"))
//		dw_insert.SetItem(k,"depot_no",   sDepotNo)
//	
//		dw_insert.SetItem(k,"inpcnf", 'I')   // �������(�԰�)
//		dw_insert.SetItem(k,"botimh",'')
//		dw_insert.SetItem(k,"jnpcrt", '005') // ��ǥ��������(��ǰ�Ƿ�)
//		dw_insert.SetItem(k,"opseq",'9999')
//		dw_insert.SetItem(k,"outchk",'N')
//		
//		/* �������ȣ :�ǸŹ�ǰ�ϰ�츸 �Է����*/
//		If dw_imhist_ins.GetItemString(1,"iogbn") <> 'O41' Then
//			dw_insert.SetItem(k,"ip_jpno",'')
//		End If
//		
//		/* �μ���ǰ�ϰ�� �Ƿںμ� -> �ŷ�ó */
//		If dw_imhist_ins.GetItemString(1,"iogbn") = 'O44' Then
//			dw_insert.SetItem(k,"cvcod",      dw_imhist_ins.GetItemString(1,"ioredept"))
//		End If
//	Next
//END IF
//
//IF dw_insert.Update() <> 1 THEN
//	ROLLBACK;
//	f_message_chk(32,'[IMHIST]')
//	Wf_Init()
//	Return
//END IF
//
//COMMIT;
//
//sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'
//
//Wf_Init()
end event

type cb_ins from w_inherite`cb_ins within w_sal_06120
integer x = 3502
integer y = 172
integer width = 416
integer taborder = 40
boolean enabled = false
string text = "���弱��(&I)"
end type

event cb_ins::clicked;call super::clicked;//Long il_currow,il_functionvalue
//String sNull, sDepotNo, sSaupj
//String sCvcod, sCvName
//
//SetNull(sNull)
//
//IF dw_insert.AcceptText() = -1 THEN RETURN
//
//il_currow = dw_insert.RowCount()
//IF il_currow <=0 THEN
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredchk(dw_insert.DataObject,il_currow)
//END IF
//
//sSaupj = Trim(dw_imhist_ins.GetItemString(1,'saupj'))
//If IsNull(sSaupj) or sSaupj = '' Then
//	f_message_chk(30,'[�ΰ������]')
//	dw_imhist_ins.SetColumn("saupj")
//	dw_imhist_ins.SetFocus()	
//	Return 
//End If
//
//sDepotNo = Trim(dw_imhist_ins.GetItemString(1,'depot_no'))
//If IsNull(sDepotNo) or sDepotNo = '' Then
//	f_message_chk(30,'[��ǰâ��]')
//	dw_imhist_ins.SetColumn("depot_no")
//	dw_imhist_ins.SetFocus()	
//	Return 
//End If
//
//sCvcod = Trim(dw_imhist_ins.GetItemString(1,'cvcod'))
//sCvName  = Trim(dw_imhist_ins.GetItemString(1,'cvname'))
//If sCvcod = '' Or IsNull(sCvcod) Then
//	f_message_chk(40,'[��ǰó]')
//	dw_imhist_ins.SetFocus()
//	dw_imhist_ins.SetColumn('cvcod')
//	Return 2
//End If
//
//IF il_functionvalue = 1 THEN
//	/* ������� �������ϵ��� ���� */
//	dw_imhist_ins.Modify('iogbn.protect = 1')
//	dw_imhist_ins.Modify("iogbn.background.color = 80859087")
//	dw_imhist_ins.Modify('depot_no.protect = 1')
//	dw_imhist_ins.Modify("depot_no.background.color = 80859087")
//
//	dw_imhist_ins.Modify('cvcod.protect = 1')
//
//	/* �ش� CI �� �о�´� */
//	gs_code = 'A'
//	gs_gubun = 'Y'
//	OpenWithParm(w_expci_popup, sSaupj)	/* �ΰ������ */
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN		
//
//	wf_set_ip_jpno(gs_code)
//		
//	dw_insert.SetFocus()
//END IF
end event

type cb_del from w_inherite`cb_del within w_sal_06120
integer x = 3657
integer y = 3324
integer taborder = 90
end type

event cb_del::clicked;call super::clicked;//Long iCurRow, lCiseq, nRow
//Double dCiamt
//
//iCurRow = dw_insert.GetRow()
//IF iCurRow <=0 THEN
//	f_message_chk(36,'')
//	Return
//END IF
//
//If wf_chk(iCurRow) <> 0 Then Return
//
//IF F_Msg_Delete() = -1 THEN Return
//
///* Ci ���� */
//lCiSeq = dw_insert.GetItemNumber(iCurRow,"inv_seq")
//nRow = dw_cid.Find("ciseq = " + string(lciseq), 1, dw_cid.RowCount())
//If nRow <= 0 Then
//	MessageBox('Ȯ��','������ ǰ���� ã�� ���� �����ϴ�.!!')
//	RollBack;
//	Return
//End If
//
//dw_cid.DeleteRow(nRow)
//
//If dw_cid.RowCount() <= 0 Then
//	dw_cih.DeleteRow(1)
//Else
//	dCiamt = dw_cid.GetItemNumber(1,'sum_ciamt')
//	If IsNull(dCiamt) Then dCiamt = 0
//
//	dw_cih.SetItem(1,"expamt",    dCiamt)
//End If
//
///* IMHIST ���� -> CI DETAIL ���� -> CI HEADER ���� */
//dw_insert.DeleteRow(iCurRow)
//
//IF sModStatus = 'M' THEN
//	IF dw_insert.Update() <> 1 THEN
//		ROLLBACK;
//		Return
//	END IF
//
//	/* CI DETAIL ���� �����ϰ� HEADER �����ؾ��� */
//	IF dw_cid.Update() <> 1 THEN
//		ROLLBACK;
//		Return
//	END IF
//	
//	IF dw_cih.Update() <> 1 THEN
//		ROLLBACK;
//		Return
//	END IF
//
//	COMMIT;
//	If dw_insert.RowCount() <= 0 Then wf_init()
//END IF
//
//dw_insert.SetColumn("itnbr")
//dw_insert.SetFocus()
//
//sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'
end event

type cb_inq from w_inherite`cb_inq within w_sal_06120
integer x = 238
integer y = 3200
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;//String  sIoJpNo, sCino, sSaleDt
//Long    nCnt
//
//If dw_imhist_ins.AcceptText() <> 1 Then 	Return
//
//sIoJpNo = Mid(dw_imhist_ins.GetItemString(1,"iojpno"),1,12)
//IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
//	f_message_chk(30,'[��ǰ�Ƿڹ�ȣ]')
//	dw_imhist_ins.SetColumn("iojpno")
//	dw_imhist_ins.SetFocus()
//	Return 
//END IF
//
//IF dw_imhist_ins.Retrieve(gs_sabu,sIoJpNo) > 0 THEN
//	sCino = dw_imhist_ins.GetItemString(1,'inv_no')
//	
//	/* Invoice���� ��ȸ */
//	dw_cih.Retrieve(gs_sabu, sCino)
//	dw_cid.Retrieve(gs_sabu, sCino)
//	
//	dw_insert.Retrieve(gs_sabu,sIoJpNo)
//	dw_imhist_ins.Modify('iojpno.protect = 1')
//	dw_imhist_ins.Modify("iojpno.background.color = '"+String(Rgb(192,192,192))+"'")
//	
//	dw_imhist_ins.Modify('sudat.protect = 1')
//	dw_imhist_ins.Modify("sudat.background.color = '"+String(Rgb(192,192,192))+"'")
//	
//	dw_imhist_ins.Modify('iogbn.protect = 1')
//	dw_imhist_ins.Modify("iogbn.background.color = '"+String(Rgb(192,192,192))+"'")
//
//	dw_imhist_ins.Modify('saupj.protect = 1')
//	dw_imhist_ins.Modify("saupj.background.color = '"+String(Rgb(192,192,192))+"'")
//	
//	dw_insert.ScrollToRow(1)
//	dw_insert.SetColumn("itnbr")
//	dw_insert.SetFocus()
//	
//	cb_ins.Enabled = False
//	ib_any_typing = False
//ELSE
//	wf_init()
//	f_message_chk(50,'')
//	dw_imhist_ins.SetColumn("iojpno")
//	dw_imhist_ins.SetFocus()
//	Return
//END IF
//
///* �˻�Ȯ�εȰ��� 1���̻��̸� �߰��Ұ�  */
//SELECT COUNT("IMHIST"."INSDAT")   INTO :nCnt
//  FROM "IMHIST"  
//  WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
//	     ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
//		  ( "IMHIST"."JNPCRT" ='005') AND
//		  ( "IMHIST"."INSDAT" IS NOT NULL);
//
//If nCnt > 0 Then
//	cb_ins.Enabled = False
//Else
//	cb_ins.Enabled = True
//End If
//
///* ��ǰȮ���Ǿ� ������ ���� �Ұ� */
//sSaleDt = dw_cih.GetItemString(1,'saledt')
//
//If Not IsNull(sSaleDt) Then
//	cb_del.Enabled = False
//	sle_msg.text = '��ǰȮ���� �ڷ��Դϴ�.!!'
//Else
//	cb_del.Enabled = True
//End If
//
end event

type cb_print from w_inherite`cb_print within w_sal_06120
integer x = 37
integer y = 2816
integer width = 626
boolean enabled = false
string text = "��ǰ�Ƿڼ����(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_06120
end type

type cb_can from w_inherite`cb_can within w_sal_06120
integer x = 4009
integer y = 3324
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;//Wf_Init()
end event

type cb_search from w_inherite`cb_search within w_sal_06120
integer x = 1431
integer y = 2816
integer width = 425
boolean enabled = false
string text = "���弱��(&W)"
end type



type sle_msg from w_inherite`sle_msg within w_sal_06120
integer x = 329
integer y = 2956
end type



type gb_button1 from w_inherite`gb_button1 within w_sal_06120
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06120
end type

type gb_5 from groupbox within w_sal_06120
integer x = 3255
integer y = 3272
integer width = 1467
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_sal_06120
boolean visible = false
integer x = 101
integer y = 3136
integer width = 873
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_insert from radiobutton within w_sal_06120
integer x = 96
integer y = 104
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 33027312
string text = "���"
boolean checked = true
end type

event clicked;sModStatus = 'I'											/*���*/

Wf_Init()

end event

type rb_modify from radiobutton within w_sal_06120
integer x = 96
integer y = 188
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 33027312
string text = "����"
end type

event clicked;sModStatus = 'M'											/*����*/

Wf_Init()
end event

type dw_imhist_ins from u_key_enter within w_sal_06120
event ue_key pbm_dwnkey
integer x = 439
integer y = 56
integer width = 2871
integer height = 256
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_061201"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sIoJpNo, sSuDate, sIoConFirm, sDept, sDeptName
String  sDepotNo, snull,sEmpNo,sEmpName, sInsDat
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'depot_no', sSaupj)
	/* ��ǰ�Ƿڹ�ȣ */
	Case  "iojpno" 
		sIoJpNo = Mid(GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
	  /* �˻�Ȯ�� */
		SELECT MAX("IMHIST"."INSDAT")   INTO :sInsDat
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
				 ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
				 ( "IMHIST"."JNPCRT" ='005')  and
				 ( "IMHIST"."INV_NO" IS NOT NULL );
	
		IF SQLCA.SQLCODE <> 0 THEN
		  TriggerEvent(RButtonDown!)
		  Return 2
		ELSE
			p_inq.TriggerEvent(Clicked!)
		END IF
	Case "sudat"
		sSuDate = Trim(GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[��ǰ�Ƿ�����]')
			SetItem(1,"sudat",snull)
			Return 1
		END IF
	/* ��ǰ���μ� */
	Case "ioredept"
		sDept = Trim(GetText())
		IF sDept ="" OR IsNull(sDept) THEN
			SetItem(1,"deptname",snull)
			SetItem(1,"ioreemp",sNull)
			SetItem(1,"empname",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sDeptName
		 FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sDept AND "VNDMST"."CVGU" ='4';
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptname",sDeptName)
			SetItem(1,"ioreemp",sNull)
			SetItem(1,"empname",sNull)
		END IF
	/* ��ǰ���μ��� */
	Case "deptname"
		sDeptName = Trim(GetText())
		IF sDeptName ="" OR IsNull(sDeptName) THEN
			SetItem(1,"ioredept",snull)
			SetItem(1,"ioreemp",sNull)
			SetItem(1,"empname",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD"			INTO :sDept
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVNAS2" = :sDeptName AND "VNDMST"."CVGU" ='4'  ;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"ioredept",sDept)
			SetItem(1,"ioreemp",sNull)
			SetItem(1,"empname",sNull)
		END IF
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvname",	 snull)
			SetItem(1,"cust_area",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod',  sNull)
			SetItem(1, 'cvname', snull)
			SetItem(1,"cust_area",snull)
			Return 1
		ELSE		
//			SetItem(1,"saupj",   	ssaupj)
			SetItem(1,"cust_area",  sarea)
			SetItem(1,"cvname",		scvnas)
		END IF
	/* �ŷ�ó�� */
	Case "cvname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			SetItem(1,"cust_area",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvname', snull)
			SetItem(1,"cust_area",snull)
			Return 1
		ELSE
//			SetItem(1,"saupj",   	 ssaupj)
			SetItem(1,"cust_area",   sarea)
			SetItem(1,'cvcod', 		 sCvcod)
			SetItem(1,"cvname", 		 scvnas)
			Return 1
		END IF
	Case "depot_no"
		sDepotNo = GetText()
		IF sDepotNo = "" OR IsNull(sDepotNo) THEN RETURN
		
		SELECT "VNDMST"."CVNAS2" , "VNDMST"."HOMEPAGE"
		  INTO :sDepotNo  , :sIoconFirm  
		  FROM "VNDMST"  
		 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[â��]')
			SetItem(1,"depot_no",snull)
			Return 1
		END IF
		
		SetItem(1,'io_confirm',sIoconFirm) /* ���ҽ��ο��� */
	/* ��ǰ����� */
	Case "ioreemp"
	  sEmpNo = Trim(GetText())
	  If sEmpno = '' Or IsNull(sEmpno) Then
		  SetItem(1,'empname',sNull)
		  Return
	  End If
	
	  SELECT "P1_MASTER"."EMPNO", "P1_MASTER"."EMPNAME" 
		 INTO :sEmpNo, :sEmpName
		 FROM "P1_MASTER"  
		WHERE ("P1_MASTER"."EMPNO" = :sEmpNo ) AND 
				("P1_MASTER"."SERVICEKINDCODE" <> '3' );
	
	  IF SQLCA.SQLCODE <> 0 THEN
		 TriggerEvent(RbuttonDown!)
		 Return 2
	  ELSE
		 SetItem(1,"empname",sEmpName)
	  END IF
	/* ��ǰ����ڸ� */
	Case "empname"
	  sEmpName = Trim(GetText())
	  If sEmpName = '' Or IsNull(sEmpName) Then
		  SetItem(1,'ioreemp',sNull)
		  Return
	  End If
	
	  SELECT "P1_MASTER"."EMPNO", "P1_MASTER"."EMPNAME" 
		 INTO :sEmpNo, :sEmpName
		 FROM "P1_MASTER"  
		WHERE ("P1_MASTER"."EMPNAME" = :sEmpName ) AND 
				("P1_MASTER"."SERVICEKINDCODE" <> '3' );
	
	  IF SQLCA.SQLCODE <> 0 THEN
		 TriggerEvent(RbuttonDown!)
		 Return 2
	  ELSE
		 SetItem(1,"ioreemp",sEmpNo)
	  END IF
	
	/* ��ǰ���� :�μ�����ǰ�� ��� ��ǰó �ԷºҰ�*/  
	Case "iogbn"
		If Trim(GetText()) = 'O44' Then
			SetItem(row,'cvcod',sNull)
			SetItem(row,'cvname',sNull)
			Return
		End If
	
		SetFocus()
		SetRow(1)
		SetColumn('ioredept')
END Choose

end event

event editchanged;ib_any_typing = True
end event

event rbuttondown;String sDeptName,sNull, sIoGbn

SetNull(sNull)
SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* ��ǰ�Ƿڹ�ȣ */
	Case "iojpno" 
		gs_gubun = '005'
		gs_codename = 'C'
		Open(w_imhist_02600_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"iojpno",Left(gs_code,12))
		p_inq.PostEvent(Clicked!)
	/* ��ǰ�Ƿںμ� */
	Case "ioredept"
		Open(w_dept_popup2)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"ioredept",gs_code)
		SetItem(1,"deptname",gs_codename)
		SetItem(1,"ioreemp",sNull)
		SetItem(1,"empname",sNull)
		
		SetColumn("ioreemp")
	/* ��ǰ�Ƿںμ��� */
	Case "deptname" 
		Open(w_dept_popup2)
		
		IF gs_codename ="" OR IsNull(gs_codename) THEN RETURN
		
		SetItem(1,"ioredept",gs_code)
		SetItem(1,"deptname",gs_codename)
		SetItem(1,"ioreemp",sNull)
		SetItem(1,"empname",sNull)
		
		SetColumn("ioreemp")
	/* ��ǰ����� */
	Case "ioreemp" , "empname"
		gs_gubun = GetItemString(1,"ioredept")
		Open(w_sawon_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		If gs_gubun <> GetItemString(1,"ioredept") Then
		  SELECT "VNDMST"."CVNAS2"
			 INTO :sDeptName
			 FROM "VNDMST"  
			WHERE "VNDMST"."CVCOD" = :gs_gubun AND "VNDMST"."CVGU" ='4';
			
		  SetItem(1,"ioredept",gs_gubun)
		  SetItem(1,"deptname",sDeptName)
		End If
		
		SetItem(1,"ioreemp",gs_code)
		SetItem(1,"empname",gs_codename)
		SetColumn("cvcod")
	/* ��ǰó */
	Case "cvcod", "cvname"
		gs_gubun = '2'
		If GetColumnName() = "cvname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose

ib_any_typing = True
end event

event itemfocuschanged;IF this.GetColumnName() = "cvname" OR this.GetColumnName() ='empname' OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type dw_cid from datawindow within w_sal_06120
boolean visible = false
integer x = 1801
integer y = 2484
integer width = 1787
integer height = 236
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_061202"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_cih from datawindow within w_sal_06120
boolean visible = false
integer x = 101
integer y = 2484
integer width = 1682
integer height = 188
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_sal_061203"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_sal_06120
integer x = 1829
integer y = 56
integer width = 78
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_imhist_ins.SetColumn('sudat')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_imhist_ins.SetItem(1, 'sudat', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 416
integer y = 40
integer width = 2917
integer height = 284
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_06120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 348
integer width = 4576
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_06120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 40
integer width = 357
integer height = 284
integer cornerheight = 40
integer cornerwidth = 55
end type

