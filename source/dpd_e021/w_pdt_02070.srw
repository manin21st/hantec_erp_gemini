$PBExportHeader$w_pdt_02070.srw
$PBExportComments$����������� ����(�����)
forward
global type w_pdt_02070 from w_inherite
end type
type dw_head from u_key_enter within w_pdt_02070
end type
type dw_hold from u_key_enter within w_pdt_02070
end type
type pb_1 from u_pb_cal within w_pdt_02070
end type
type pb_2 from u_pb_cal within w_pdt_02070
end type
type dw_momast from datawindow within w_pdt_02070
end type
type st_2 from statictext within w_pdt_02070
end type
type cbx_1 from checkbox within w_pdt_02070
end type
type dw_jaje from datawindow within w_pdt_02070
end type
type dw_ban from datawindow within w_pdt_02070
end type
type cbx_2 from checkbox within w_pdt_02070
end type
type st_3 from statictext within w_pdt_02070
end type
type dw_waiju from datawindow within w_pdt_02070
end type
type st_4 from statictext within w_pdt_02070
end type
type rr_1 from roundrectangle within w_pdt_02070
end type
type rr_2 from roundrectangle within w_pdt_02070
end type
end forward

global type w_pdt_02070 from w_inherite
integer height = 2840
string title = "����������� ����"
dw_head dw_head
dw_hold dw_hold
pb_1 pb_1
pb_2 pb_2
dw_momast dw_momast
st_2 st_2
cbx_1 cbx_1
dw_jaje dw_jaje
dw_ban dw_ban
cbx_2 cbx_2
st_3 st_3
dw_waiju dw_waiju
st_4 st_4
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02070 w_pdt_02070

type variables
String is_sysno='', ispordno, isholdno
String isgub='1'	// 1:�������,2:���ֺ���
end variables

forward prototypes
public function string wf_depotno (string oversea_gu, string sjumaechul)
public function integer wf_create_waiju ()
end prototypes

public function string wf_depotno (string oversea_gu, string sjumaechul);string  sSaupj, sdepotNo, sPdtgu

If	IsNull(oversea_gu) Or oversea_gu = '' Then Return ''

sSaupj 	= gs_saupj
sPdtgu	= dw_head.GetItemString(1, 'pdtgu')

if	sSaupj	=  '%'	then
	sSaupj	=  gs_saupj
End If 

If	isnull(sJumaechul) or sJumaechul = "" then
	select min(cvcod )
	  into :sDepotNo
	  from vndmst
	 where cvgu = '5' and
			 juprod = :oversea_gu and                               // 1:  ����ǰ , 2: ����ǰ, 3:������
			 ipjogun = :sSaupj ;
else	
	select min(cvcod )
	  into :sDepotNo
	  from vndmst
	 where cvgu = '5' and
			 juprod       = :oversea_gu and                        // 1:  ����ǰ , 2: ����ǰ, 3:������
			 jumaechul 	  = :sJumaechul and                        // 1: ����, 2:�Ϲ�
			 jumaeip      = :sPdtgu and                            // ������
			 ipjogun      = :sSaupj;
End if	

If IsNull(sDepotNo) Then 
	f_message_chk(1400,'[â��]')
	sDepotNo = ''
End If

Return sDepotNo

end function

public function integer wf_create_waiju ();Int iok, inot, ierr, ix, iy, ll_row
String sBaljpno, sBaldate, ls_Jpno, sError,sjpno, sItnbr
Dec    dBalseq, ld_Seq
DataStore ds_bom, ds_imhist

/* ��󳻿��� �����Ѵ�*/
w_mdi_frame.sle_msg.text = '��󳻿��� �������Դϴ�....!!'

dw_insert.SetFilter("chk_flag = 'Y'")
dw_insert.Filter()
dw_insert.RowsDiscard(1, dw_insert.FilteredCount(), Filter!)

// ��ü ������ ��ȸ��.
dw_hold.SetFilter('')
dw_hold.Filter()

ds_bom   = create datastore
ds_imhist = create datastore
ds_bom.DataObject = 'd_pu01_00010_b'
ds_imhist.DataObject = 'd_pdt_imhist'
ds_bom.SetTransObject(sqlca)
ds_imhist.SetTransObject(sqlca)

For ix = 1 To dw_insert.RowCount()
	sBaljpno = dw_insert.GetItemString(ix, 'poblkt_baljpno')
	dBalseq  = dw_insert.GetItemNumber(ix, 'poblkt_balseq')
	sBaldate = dw_insert.GetItemString(ix, 'pomast_baldate')
	sItnbr   = dw_insert.GetItemString(ix, 'poblkt_itnbr')
	
	// ������⳻�� ����
	DECLARE erp_create_pstruc_to_soje PROCEDURE FOR erp_create_pstruc_to_soje(:sitnbr);
	EXECUTE erp_create_pstruc_to_soje;
	
	// ���̳����� ���� ��� skip
	dw_hold.Retrieve(gs_sabu, sBaljpno, dBalseq)
	If dw_hold.RowCount() <= 0 Then 
		inot++
		dw_insert.SetItem(ix, 'status', 'N')
		Continue
	End If

	If dw_hold.GetItemNumber(1, 'sum_sts') <= 0 Then
		inot++
		dw_insert.SetItem(ix, 'status', 'N')
		Continue
	End If
	
	// �԰��� ��ȸ
	dw_waiju.Retrieve(gs_sabu, sBaljpno, dBalseq)
	
	// ���ֻ����� ��ǥ��ȣ ����
	ld_Seq = SQLCA.FUN_JUNPYO(gs_sabu, sBaldate, 'C0')			
	If ld_Seq < 0	Then	
		Rollback;
		RETURN -1
	End If			
	COMMIT;
	ls_Jpno  = sBaldate + String(ld_Seq, "0000")
	
	// ���� ���ֻ������� ���� ����
	delete from imhist where sabu = :gs_sabu and baljpno = :sBaljpno and balseq = :dBalseq and iogbn = 'O06';
	If sqlca.sqlcode <> 0 Then
		dw_insert.SetItem(ix, 'status', 'X')
		ierr++
		rollback;
		Continue
	End If
		
	// �߰����� ����
	ll_row=0
	For iy = 1 To dw_hold.RowCount()
		// ������ ������ �ݿ����� �ʴ´�
		If dw_hold.GetItemNumber(iy, 'sts') > 0 Then Continue
		
		////////////////////////////////////////////////////////////////////////////////
		// ** ��� HISTORY ���� **
		////////////////////////////////////////////////////////////////////////////////
		ll_row = ds_imhist.InsertRow(0)

		ds_imhist.Object.sabu[ll_row]	   	=	gs_sabu
		ds_imhist.Object.jnpcrt[ll_row]	   = '002'			                           // ��ǥ��������
		ds_imhist.Object.inpcnf[ll_row]    	= 'O'				                           // �������
		ds_imhist.Object.iojpno[ll_row] 		= ls_Jpno + String(ll_row, "000") 
		ds_imhist.Object.iogbn[ll_row]     	= 'O06'   											// ���ұ���=��û����
		ds_imhist.Object.sudat[ll_row]	   = sBaldate			                        // ��������=�������
		ds_imhist.Object.itnbr[ll_row]	   = dw_hold.GetItemString(iy, 'itnbr')      // ǰ��
		ds_imhist.Object.pspec[ll_row]	   = '.'										         // ���
		ds_imhist.Object.depot_no[ll_row]  	= dw_insert.GetItemString(ix, 'poblkt_ipdpt')   // ����â��=���â��
		ds_imhist.Object.cvcod[ll_row]	   = dw_insert.GetItemString(ix, 'pomast_cvcod')   // �ŷ�óâ��=�԰�ó
		ds_imhist.Object.ioqty[ll_row]	   = dw_hold.GetItemNumber(iy, 'hold2')      // ���Ҽ���=������
		ds_imhist.Object.ioreqty[ll_row]		= dw_hold.GetItemNumber(iy, 'hold2')      // �����Ƿڼ���=������		
		ds_imhist.Object.insdat[ll_row]	   = sBaldate			                        // �˻�����=�������	
		ds_imhist.Object.iosuqty[ll_row]		= dw_hold.GetItemNumber(iy, 'hold2')      // �հݼ���=������		
		ds_imhist.Object.opseq[ll_row]	   = '9999'                                	// �����ڵ�
		ds_imhist.Object.ip_jpno[ll_row]   	= ''			 	                           // �Ҵ��ȣ
		ds_imhist.Object.filsk[ll_row]     	= 'Y'												   // ����������
		ds_imhist.Object.botimh[ll_row]	   = 'N'                         				// ���������
		ds_imhist.Object.ioredept[ll_row]  	= gs_dept      									// �����Ƿںμ�=�Ҵ�.�μ�
		ds_imhist.Object.io_confirm[ll_row]	= 'Y'		                              	// ���ҽ��ο���
		ds_imhist.Object.io_date[ll_row]		= sBaldate			                        // ���ҽ�������=�������	
		ds_imhist.Object.io_empno[ll_row]  	= gs_empno			                        // ���ҽ�����=�����	
		ds_imhist.Object.outchk[ll_row]    	= 'Y'                              			// ����ǷڿϷ�
		ds_imhist.Object.baljpno[ll_row]   	= sBaljpno
		ds_imhist.Object.balseq[ll_row]    	= dBalseq
		ds_imhist.Object.bigo[ll_row]    	= "���ֺ��⿡ ���� �����ǰ���"
	Next

	// �԰����� �������� �����ڵ�������� ������ ������Ѵ�.
	For iy = 1 To dw_waiju.RowCount()
		sError = 'X';
		sjpno = Left(dw_waiju.GetItemString(iy, 'iojpno'),12)
		
		sqlca.erp000000360(gs_sabu, sjpno, 'D', sError);
		if sError = 'X' or sError = 'Y' then
			rollback;
			exit
		end if
		sError = 'X';
		sqlca.erp000000360(gs_sabu, sjpno, 'I', sError);
		if sError = 'X' or sError = 'Y' then
			rollback;
			exit
		end if
	Next
	if sError = 'X' or sError = 'Y' then
		dw_insert.SetItem(ix, 'status', 'X')
		ierr++
		Continue
	end if
	
	if ds_imhist.update() <> 1 then
		MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
		Dw_insert.SetItem(ix, 'status', 'X')
		ierr++
		rollback ;
	else
		commit;
		dw_insert.SetItem(ix, 'status', 'Y')
		iok++
	end if

	w_mdi_frame.sle_msg.text = string(ix)+'/'+string(dw_insert.rowcount()) + ' ó���Ϸ�!!'
Next

MessageBox('Ȯ��','ó  �� : '+string(iok) + '~r~n��ó�� : '+string(inot)+ '~r~n��  �� : '+string(ierr))

destroy ds_bom
destroy ds_imhist

Return 1
end function

on w_pdt_02070.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.dw_hold=create dw_hold
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_momast=create dw_momast
this.st_2=create st_2
this.cbx_1=create cbx_1
this.dw_jaje=create dw_jaje
this.dw_ban=create dw_ban
this.cbx_2=create cbx_2
this.st_3=create st_3
this.dw_waiju=create dw_waiju
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.dw_hold
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_momast
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.dw_jaje
this.Control[iCurrent+9]=this.dw_ban
this.Control[iCurrent+10]=this.cbx_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.dw_waiju
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
end on

on w_pdt_02070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.dw_hold)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_momast)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.dw_jaje)
destroy(this.dw_ban)
destroy(this.cbx_2)
destroy(this.st_3)
destroy(this.dw_waiju)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_head.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_hold.SetTransObject(sqlca)
dw_momast.SetTransObject(sqlca)
dw_jaje.SetTransObject(sqlca)
dw_ban.SetTransObject(sqlca)
dw_waiju.SetTransObject(sqlca)

dw_head.InsertRow(0)
dw_jaje.InsertRow(0)
dw_ban.InsertRow(0)

dw_head.SetItem(1,'frdate',Left(f_today(),6) + '01')
dw_head.SetItem(1,'todate',f_today())

f_child_saupj(dw_head,'pdtgu', gs_saupj)
String  ls_pdtgu
SELECT RFGUB INTO :ls_pdtgu FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :gs_saupj ;
dw_head.SetItem(1,'pdtgu', ls_pdtgu)

String sCode

/* ����ǰ â�� �˻� */
//sCode 	= wf_DepotNo('2', '2')	// ����ǰâ�� �Ѱ��
sCode 	= wf_DepotNo('2', '1')	// ����ǰ�� ����â��� �������
dw_ban.setitem(1, "ban_code", sCode)

/* ���� â�� �˻� */
//sCode 	= wf_DepotNo('3', '')	// ����â���� ����û�Ұ��
sCode 	= wf_DepotNo('2', '1')	// ����â�� ���� ���簡 ����â��� �԰�� ���
dw_jaje.setitem(1, "jaje_code", sCode)

dw_head.SetColumn('pordno')
dw_head.SetFocus()
end event

event closequery;call super::closequery;String sError

IF is_sysno > '' then
	if Messagebox("����������� ����", "�۾����Դϴ�" + '~n' + &
									  "����Ͻð����ϱ�?", question!, yesno!) = 1 then
	
		/* �Ҵ系���� ���� */
		Delete From holdstock_copy 			Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

		/* ���ó����� ���� */
		Delete From momast_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

		/* ���������� ���� */
		Delete From morout_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

		/* ����ǰ �ҿ���� ���� */
		Delete From momast_copy_lotsim 		Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

	   COMMIT;

	Else	
		return 1
	End if
end if
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02070
integer x = 50
integer y = 292
integer width = 4494
integer height = 940
string dataobject = "d_pdt_02070_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
	Return
End If

/* ������� ������ ��� */
If isGub = '1' Then
	dw_hold.Retrieve(gs_sabu, GetItemString(row, 'momast_pordno'), is_sysno)
	dw_head.SetItem(1, 'itnbr', GetItemString(row, 'momast_itnbr'))
	
	datawindowchild dwc
	dw_hold.getchild("opseq", dwc)
	dwc.settransobject(sqlca)
	IF dwc.retrieve(gs_sabu, GetItemString(row, 'momast_pordno')) < 1 THEN 
		dwc.insertrow(0)
	END IF
Else
	dw_hold.Retrieve(gs_sabu, GetItemString(row, 'poblkt_baljpno'), GetItemNumber(row, 'poblkt_balseq'))
	
	dw_head.SetItem(1, 'itnbr', GetItemString(row, 'poblkt_itnbr'))
End If
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02070
boolean visible = false
integer y = 168
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02070
boolean visible = false
integer y = 168
end type

type p_search from w_inherite`p_search within w_pdt_02070
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02070
integer x = 3922
string picturename = "C:\erpman\image\���_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

event p_ins::clicked;call super::clicked;String  swanch, sbanch, stoday, ntoday, schk, sgubun, ls_saupj, sitnbr, spdtgu, sitgu, sittyp, snapgi, sban, sjaje
String  sitcls, sporgu, srtnbr, scvcod, stuncu, sordgbn, ls_pspec, scvnas, sjasacode, sMasterNo, sPordno
String  sjdate, ssdate, sedate, serror
Integer ii, nn, k, ireturn
Long    lrow, lopt, Linsrow, ij
Dec{3}  dpdqty, doptqty, dmod
Dec{5}  dpdprc, dunprc

If dw_head.AcceptTExt() <> 1 Then Return -1
If dw_insert.AcceptTExt() <> 1 Then Return -1

/* -------------------------------------------------------------------------------------------------------------- */
/*  �����۾����� ������ MOROUT_COPY, MOMAST_COPY�� �����Ѵ�                                                       */
/* -------------------------------------------------------------------------------------------------------------- */

// �������� üũ
sPdtgu = dw_head.getitemstring(1, "pdtgu")
If isnull(sPdtgu) or Trim(sPdtgu) = '' then
	f_message_chk(309, '[����������]')
	return -1
end if

/* ��󳻿��� �����Ѵ�*/
w_mdi_frame.sle_msg.text = '��󳻿��� �������Դϴ�....!!'

dw_insert.SetFilter("chk_flag = 'Y'")
dw_insert.Filter()
dw_insert.RowsDiscard(1, dw_insert.FilteredCount(), Filter!)

/* ������� ������ ��� */
If isGub = '1' Then
	lopt = dw_insert.RowCount()
	For Lrow = lOpt to 1 Step -1
		sChk     = dw_insert.getitemstring(Lrow, "chk_flag")
		If schk = 'N' then 
			dw_insert.RowsDiscard(Lrow, Lrow, Primary!)
		Else
			sPordno = dw_insert.GetItemString(lRow, 'momast_pordno')
			
			/* ���� ���ó����� ���� */
			Delete From momast_copy	Where sabu = :gs_sabu and pordno = :sPordno;
			Delete From morout_copy	Where sabu = :gs_sabu and pordno = :sPordno;
		End If
	Next
	
	commit;
	
	dw_insert.SetFilter("")
	dw_insert.Filter()
	
	If dw_insert.RowCount() <= 0 Then
		MessageBox('Ȯ��','�۾������ �����ϴ�.!!')
		Return
	End If
	
	SetPointer(HourGlass!)
	
	/* â��� ����ǰ, ����ǰ�� ��� ù��° â�� �����Ѵ� */
	ls_saupj	= gs_saupj
	Select Min(cvcod) Into :sWanch from Vndmst where cvgu = '5' and juprod = '1' and ipjogun = :ls_saupj;
	Select Min(cvcod) Into :sBanch from Vndmst where cvgu = '5' and juprod = '2' and jumaeip = :spdtgu and ipjogun = :ls_saupj;
	
	/* �۾����ù�ȣ ä��(Visual) */
	stoday = f_today()
	
	// ����Ÿ������ȣ�� �Է��� ��쿡�� ���������� ��ȸ�Ѵ�
	If IsNull(sMasterNo) Or sMasterNo = '' Then
		// ȭ��� ���̴� �۾����ù�ȣ ä��
		ii = sqlca.fun_junpyo(gs_sabu, stoday, 'N0')
		if ii < 1 then
			f_message_chk(51,'[�۾����ù�ȣ]') 
			rollback;
			return -1
		end if
		Commit;
		ispordno = stoday + String(ii, '0000')		// �ű��߰��� ǰ�� �۾����ù�ȣ
	
		// �۾����� ���ع�ȣ ä��(��� �������� �۾����� ���ع�ȣ�� �������� �Ѵ�)
		ntoday = f_today()
		Nn = sqlca.fun_junpyo(gs_sabu, nToday, 'N3')
		if Nn < 1 then
			f_message_chk(51,'[�۾����� ���ع�ȣ]') 
			rollback;
			return -1
		end if
		
		is_sysno = nToday + String(Nn, '0000')		// master_no��
	Else
		is_sysno = sMasterNo
		ispordno = sMasterNo
	End If
	
	/* �ڷ� ����� datawindow clear */
	dw_momast.reset()
		 
	/* ���� ǰ������ �۾����� �ϴ� ��� */
	For Lrow = 1 to dw_insert.rowcount()
		 sChk     = dw_insert.getitemstring(Lrow, "chk_flag")
		 if schk = 'N' then continue
		 
		 sGubun	 = '9'	// ��ȹ����(1:��,7:����, 9:�����۾�����)
		 
		 dPdqty	 = dw_insert.getitemdecimal(Lrow, "momast_pdqty") 	//���ü�
	
		 sItnbr = dw_insert.getitemstring(Lrow, "momast_itnbr")
	
		 /* ǰ�񸶽����� ����/�������¸� �������� �ۼ� */
		 Setnull(sItgu)
		 Setnull(sIttyp)
		 Setnull(sItcls)
		 Setnull(sporgu)
		 
		 Select a.itgu, a.ittyp, a.itcls, nvl(a.stdnbr,a.itnbr)   Into :sItgu, :sIttyp, :sitcls, :sRtnbr
			From itemas a	  Where a.itnbr = :sItnbr ;
	
		 /* �ְ���ȹ���� �о�� ��� ���������� ���� */
		 sporgu = '12'	
	
			 
		 dPdprc  =	sqlca.fun_erp100000012(stoday, sitnbr, '.')		
			 
		 /* �۾����ø� �ӽ÷� ���� */
		 Linsrow = dw_momast.insertrow(0)
		 dw_momast.setitem(Linsrow, "momast_copy_sabu",   gs_sabu)
		 dw_momast.setitem(Linsrow, "momast_copy_jidat",  dw_insert.getitemstring(lrow, "momast_jidat"))
		 
		 dw_momast.setitem(Linsrow, "momast_copy_itnbr",  sItnbr)
		 dw_momast.setitem(Linsrow, "momast_copy_pspec",  '.')	// �⺻����� ����
		 
		 dw_momast.setitem(Linsrow, "momast_copy_pdtgu",  sPdtgu )
		 dw_momast.setitem(Linsrow, "momast_copy_pdqty",  dPdqty)
		 dw_momast.setitem(Linsrow, "momast_copy_pdmqty", dPdqty)
	
		 dw_momast.setitem(Linsrow, "momast_copy_pdsts",  '1')
		 dw_momast.setitem(Linsrow, "momast_copy_matchk", '2')
		 dw_momast.setitem(Linsrow, "momast_copy_stditnbr", sRtnbr)
	
		 //ǰ��з� ��з��� ���� �۾����ñ����� ����
		 dw_momast.setitem(Linsrow, "momast_copy_porgu", sPorgu)
	
	//	 If sItgu = '6' then		// ������ ��� 
	//		 dw_momast.setitem(Linsrow, "momast_copy_purgc",  'Y')	
	//	 Else
	//		 dw_momast.setitem(Linsrow, "momast_copy_purgc",  'N')
	//	 End if
		 dw_momast.setitem(Linsrow, "momast_copy_purgc",  dw_insert.getitemstring(lrow, "momast_purgc"))
		  
		 If sIttyp = '1' Or sIttyp = '8' then
			 dw_momast.Setitem(Linsrow, "momast_copy_ipchango", sWanch)
		 Else
			 dw_momast.Setitem(Linsrow, "momast_copy_ipchango", sBanch)
		 End if
		 
		 /* ������� �ۼ��� �ܰ� ���� */
		 dw_momast.setitem(Linsrow, "momast_copy_pdprc", dPdprc)
		 
		 /* ������ �ְ���ȹ�� ��쿡�� ������ȣ�� ���� ������ȣ�� ����Ѵ� (������)*/
		 if sGubun = '9' then
			sPordno = dw_insert.getitemstring(Lrow, "momast_pordno")
			dw_momast.setitem(Linsrow, "momast_copy_pordno",  sPordno)
			dw_momast.setitem(Linsrow, "momast_copy_mogubn",  '9') // �۾����� ���� : �ְ���ȹ
			dw_momast.setitem(Linsrow, "momast_copy_holdct",  dw_insert.getitemstring(Lrow, "momast_holdct"))	// �Ҵ��꿩��
		 End if	
		 
		/* �۾��������ڴ� �ְ���ȹ �������ڷ� �ۼ� */
		dw_momast.setitem(Linsrow, "momast_copy_esdat",  dw_insert.getitemstring(Lrow, "momast_jidat"))
		
		/* �۾����� ���ع�ȣ �ۼ� */
		dw_momast.setitem(Linsrow, "momast_copy_master_no", is_sysno)
		dw_momast.setitem(Linsrow, "momast_copy_mocnt",  String(Linsrow, '00'))
		
		// ���������� �����Ѵ�
		Insert into morout_copy
			(sabu,		pordno,		itnbr,		pspec,		opseq,		de_opseq,			mchcod,
			 wkctr,		jocod,		purgc,		uptgu,		esdat,		eedat,				estim,
			 esinw,		rstim,		tsinw,		ntime,		lastc,		fsdat,				fedat,
			 roqty,		faqty,		suqty,		peqty,		coqty,		paqty,				nedat,
			 ladat,		wicvcod,		wiunprc,		pr_opseq,	do_opseq,	system_end_date,	bajpno,
			 rmks,		watims,		sttim,		esset,		esman,		esmch,				esgbn,
			 rsset,		rsman,		rsmch,		qcgub,		opdsc,		roslt,				system_str_date,	qcgin,  stdmn,
			 master_no, fstim,      fetim,      pdqty)
		 Select
			 sabu,		pordno,		itnbr,		pspec,		opseq,		de_opseq,			mchcod,
			 wkctr,		jocod,		purgc,		uptgu,		null,			null,					estim,
			 esinw,		rstim,		tsinw,		ntime,		lastc,		fsdat,				fedat,
			 roqty,		faqty,		suqty,		peqty,		coqty,		paqty,				nedat,
			 ladat,		wicvcod,		wiunprc,		pr_opseq,	do_opseq,	system_end_date,	bajpno,
			 rmks,		watims,		sttim,		esset,		esman,		esmch,				esgbn,
			 rsset,		rsman,		rsmch,		qcgub,		opdsc,		roslt,				system_str_date,	qcgin,  stdmn,
			 :is_sysno, fstim,      fetim,      :dpdqty
			From Morout
		  Where sabu = :gs_sabu and pordno = :sPordno;
		If SQLCA.SQLCODE <> 0 Then
			MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
			RollBack;
			REturn
		End If
	Next
	
	if dw_momast.update() =  1 then
		commit;
	Else
		Rollback;
		messagebox("����","�����ۼ��� Error(wf_requiredchk_tabpage)")	
		return -1
	end if
	
	// ���Ҵ� ó���Ѵ�
	/* �۾����ÿ� ���� �Ҵ��� �ۼ� - �� �Ҵ������ check�� ��� */
	w_mdi_frame.sle_msg.text = '�Ҵ系���� �������Դϴ�....!!'
	
	sBan		=	dw_ban.getitemstring(1, "ban_code")
	sJaje		=	dw_jaje.getitemstring(1, "jaje_code")
	
	For Lrow = 1 to dw_momast.rowcount()
		
		 sPordno = dw_momast.getitemstring(Lrow, "momast_copy_pordno")
		 sjdate  = dw_momast.getitemstring(Lrow, "momast_copy_jidat")
		 
		 /* �Ҵ系�� ������ �ƴϸ� BOM�� �˻��� �� */
		 if dw_momast.getitemstring(Lrow, "momast_copy_holdct") = 'N' then continue;
	
		/* �Ҵ��ȣ ä�� */
		iJ = sqlca.fun_junpyo(gs_sabu, sjdate, 'B0')
		if iJ < 1 then
			rollback;
			f_message_chk(51,'[�Ҵ��ȣ]') 
			return -1
		end if
		
		/* �Ҵ��ȣ�ۼ�(12�ڸ� ����) */
		isholdno = sjdate + String(iJ, '0000')	
		Commit;
	
		sError = 'X'
		sqlca.erp000000840(gs_sabu, spordno, isholdno, sError);
	
		Choose Case sError
				 Case 'X'
						MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
						Rollback;
						F_message_chk(41,'[�Ҵ系�� ���]')
						return;
				 Case 'Y'
						MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
						Rollback;
						F_message_chk(89,'[�Ҵ系�� ���]'+spordno)
						p_can.TriggerEvent(Clicked!)
						return;
		End Choose
		
		// �����â�� Update
		Update HoldsTock_copy a
			Set hold_store = (select Decode(b.ittyp, '2', :sBan, :sJaje) as chango
									  From Itemas b
									 Where b.itnbr = a.itnbr)
		 Where a.sabu = :gs_sabu and a.hold_no like :isholdno||'%';
	Next
	
	Commit;
Else
	/* ���ֺ��� ������ ��� */
	
End If

p_inq.Enabled = False
p_inq.PictureName = 'C:\erpman\image\��ȸ_d.gif'
p_ins.Enabled = False
p_ins.PictureName = 'C:\erpman\image\���_d.gif'
p_mod.Enabled = True
p_mod.PictureName = 'C:\erpman\image\Ȯ��_up.gif'

w_mdi_frame.sle_msg.text = 'sysno : ' + is_sysno
end event

type p_exit from w_inherite`p_exit within w_pdt_02070
end type

type p_can from w_inherite`p_can within w_pdt_02070
end type

event p_can::clicked;call super::clicked;String sError, sNull

SetNull(sNull)

dw_head.SetItem(1, 'itnbr', sNull)

dw_insert.Reset()
dw_hold.Reset()

cbx_2.Checked = False
dw_insert.SetFilter("")
dw_insert.Filter()

p_inq.Enabled = True
p_inq.PictureName = 'C:\erpman\image\��ȸ_up.gif'
p_ins.Enabled = True
p_ins.PictureName = 'C:\erpman\image\���_up.gif'
p_mod.Enabled = False
p_mod.PictureName = 'C:\erpman\image\Ȯ��_d.gif'
end event

type p_print from w_inherite`p_print within w_pdt_02070
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02070
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String	sPordno, sFrdate, sTodate, sPdtgu, splfrdate, spltodate, sItnbr

if dw_head.AcceptText() = -1 then return 

dw_insert.ReSet()
dw_hold.ReSet()

sPordno   = Trim(dw_head.getitemstring(1,"pordno"))
sFrdate   = dw_head.getitemstring(1,"frdate")
sTodate   = dw_head.getitemstring(1,"todate")
sItnbr    = dw_head.getitemstring(1,"itnbr")
sPdtgu    = dw_head.getitemstring(1,"pdtgu")

If IsNull(sItnbr) Then sItnbr = ''

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
/* ������� ������ ��� */
If isGub = '1' Then
	if dw_insert.Retrieve(gs_sabu,sPordno,sFrdate,sTodate,sPdtgu, gs_saupj, sItnbr+'%') <= 0 then
		f_message_chk(56,'[����������� ����]')
	
		dw_head.SetColumn("itnbr")
		dw_head.SetFocus()
		return
	end if
Else
	/* ���ֺ��� ������ ��� */
	if dw_insert.Retrieve(gs_sabu,sFrdate,sTodate, sItnbr+'%') <= 0 then
		f_message_chk(56,'[���ֺ��⳻�� ����]')
	
		dw_head.SetColumn("itnbr")
		dw_head.SetFocus()
		return
	end if
	
	p_ins.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\���_d.gif'
	p_mod.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\Ȯ��_up.gif'
End If
end event

type p_del from w_inherite`p_del within w_pdt_02070
boolean visible = false
integer y = 168
end type

type p_mod from w_inherite`p_mod within w_pdt_02070
integer x = 4096
boolean enabled = false
string picturename = "C:\erpman\image\Ȯ��_d.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\Ȯ��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\Ȯ��_up.gif"
end event

event p_mod::clicked;call super::clicked;String sPordno, sOut
Long   ix, iok, inot, ierr

IF MessageBox("Ȯ ��","�ϰ� Ȯ�� ó���� �Ͻðڽ��ϱ�?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

/* ������� ������ ��� */
If isGub = '1' Then
	For ix = 1 To dw_insert.RowCount()
		sPordno = dw_insert.GetItemString(ix, 'momast_pordno')
		
		//���ν��� ����
		sOut = 'X'
		
		DECLARE ERP_JAJE_CHULGO_RECREATE procedure for ERP_JAJE_CHULGO_RECREATE(:gs_sabu, :sPordno, :is_sysno) ;
		EXECUTE ERP_JAJE_CHULGO_RECREATE;
		FETCH   ERP_JAJE_CHULGO_RECREATE INTO :sOut;
	
		Choose Case sout
			Case 'N'
				inot++
			Case 'Y'
				iok++
			Case Else
				ierr++
		End Choose
		
		dw_insert.SetItem(ix, 'status', sOut)
		w_mdi_frame.sle_msg.text = string(ix)+'/'+string(dw_insert.rowcount()) + ' ó���Ϸ�!!'
		
		CLOSE ERP_JAJE_CHULGO_RECREATE;
	Next
	
	IF is_sysno > '' then
	//	if Messagebox("����������� ����", "�۾����Դϴ�" + '~n' + &
	//									  "����Ͻð����ϱ�?", question!, yesno!) = 1 then
		
			/* �Ҵ系���� ���� */
			Delete From holdstock_copy 			Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			/* ���ó����� ���� */
			Delete From momast_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			/* ���������� ���� */
			Delete From morout_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			/* ����ǰ �ҿ���� ���� */
			Delete From momast_copy_lotsim 		Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			COMMIT;
			
			is_sysno=''
	//	Else	
	//		return 1
	//	End if
	end if

	MessageBox('Ȯ��','ó  �� : '+string(iok) + '~r~n��ó�� : '+string(inot)+ '~r~n��  �� : '+string(ierr))
Else
	/* ���ֺ��� ������ ��� */	
	wf_create_waiju()
End If

//p_can.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_pdt_02070
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02070
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02070
end type

type cb_del from w_inherite`cb_del within w_pdt_02070
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02070
end type

type cb_print from w_inherite`cb_print within w_pdt_02070
end type

type st_1 from w_inherite`st_1 within w_pdt_02070
end type

type cb_can from w_inherite`cb_can within w_pdt_02070
end type

type cb_search from w_inherite`cb_search within w_pdt_02070
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02070
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02070
end type

type dw_head from u_key_enter within w_pdt_02070
integer x = 37
integer y = 48
integer width = 3328
integer height = 136
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_02070_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;

choose case getcolumnname()
	case 'frdate'
		
		SetItem(row, 'todate', gettext())
	Case 'gub'
		If GetText() = '1' Then
			dw_insert.DataObject = 'd_pdt_02070_2'
			dw_hold.DataObject = 'd_pdt_02070_3'
			isgub = '1'
		Else
			// ������� �������̸� ���ó���Ѵ�
			IF is_sysno > '' then
				p_can.TriggerEvent(Clicked!)
			End If
			
			dw_insert.DataObject = 'd_pdt_02070_4'
			dw_hold.DataObject = 'd_pdt_02070_5'
			isgub = '2'
		End If
		
		dw_insert.SetTransObject(sqlca)
		dw_hold.SetTransObject(sqlca)
end Choose
end event

type dw_hold from u_key_enter within w_pdt_02070
integer x = 55
integer y = 1360
integer width = 4485
integer height = 896
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_02070_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type pb_1 from u_pb_cal within w_pdt_02070
integer x = 658
integer y = 72
integer taborder = 21
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.SetColumn('frdate')
IF IsNull(gs_code) THEN Return
If dw_head.Object.frdate.protect = '1' Or dw_head.Object.frdate.TabSequence = '0' Then Return

dw_head.SetItem(1, 'frdate', gs_code)
dw_head.SetItem(1, 'todate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02070
boolean visible = false
integer x = 1111
integer y = 72
integer taborder = 31
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.SetColumn('todate')
IF IsNull(gs_code) THEN Return
If dw_head.Object.todate.protect = '1' Or dw_head.Object.todate.TabSequence = '0' Then Return

dw_head.SetItem(1, 'todate', gs_code)
end event

type dw_momast from datawindow within w_pdt_02070
boolean visible = false
integer y = 1776
integer width = 4453
integer height = 400
integer taborder = 21
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_1"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_pdt_02070
integer x = 78
integer y = 1288
integer width = 425
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "* �����Ҵ� ����"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_pdt_02070
integer x = 4073
integer y = 1276
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "���̺�"
boolean checked = true
end type

event clicked;If This.Checked = True Then
	dw_hold.SetFilter('sts <> 0')
Else
	dw_hold.SetFilter('')
End If

dw_hold.Filter()
end event

type dw_jaje from datawindow within w_pdt_02070
boolean visible = false
integer x = 2469
integer y = 144
integer width = 695
integer height = 80
integer taborder = 41
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_42"
boolean border = false
boolean livescroll = true
end type

type dw_ban from datawindow within w_pdt_02070
boolean visible = false
integer x = 2427
integer y = 228
integer width = 722
integer height = 80
integer taborder = 51
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_40"
boolean border = false
boolean livescroll = true
end type

type cbx_2 from checkbox within w_pdt_02070
integer x = 3424
integer y = 136
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "��ü����"
end type

event clicked;string schk
Long   ix

If This.Checked Then
	schk = 'Y'
Else
	sChk = 'N'
End If

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix, 'chk_flag', schk)
Next
end event

type st_3 from statictext within w_pdt_02070
integer x = 1019
integer y = 204
integer width = 722
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "* ��ü������ ���ܵ�.."
boolean focusrectangle = false
end type

type dw_waiju from datawindow within w_pdt_02070
boolean visible = false
integer x = 2912
integer y = 2040
integer width = 686
integer height = 400
integer taborder = 31
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02070_6"
boolean border = false
boolean livescroll = true
end type

type st_4 from statictext within w_pdt_02070
integer x = 82
integer y = 204
integer width = 887
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "* �����۾��� �ش�(���۾�����)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02070
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 46
integer y = 280
integer width = 4512
integer height = 964
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02070
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 46
integer y = 1260
integer width = 4512
integer height = 1016
integer cornerheight = 40
integer cornerwidth = 55
end type

