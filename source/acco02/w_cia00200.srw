$PBExportHeader$w_cia00200.srw
$PBExportComments$������� ����
forward
global type w_cia00200 from w_inherite
end type
type dw_cond from datawindow within w_cia00200
end type
end forward

global type w_cia00200 from w_inherite
string title = "������� ����"
dw_cond dw_cond
end type
global w_cia00200 w_cia00200

forward prototypes
public function integer wf_clear_cia (string syearmonth, string syearmontht)
end prototypes

public function integer wf_clear_cia (string syearmonth, string syearmontht);/*************************************************************************/
/* ���� ���� table �� master�κ� �����ϰ� delete or �ʱ�ȭ�Ѵ�.			 */
/* reg : sgbn(ġ����,�系���� ����='Y')											 */
/*************************************************************************/
delete from cia06t where yymm = :sYearMonth and yymmt = :sYearMonthT ;				/*�������� �۾��ð� ����*/
delete from cia06t1 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			/*�۾��� ���� ���·�*/

delete from cia07t where yymm = :sYearMonth and yymmt = :sYearMonthT ;				/*ǰ������� �۾���������*/
delete from cia07t1 where yymm = :sYearMonth and yymmt = :sYearMonthT;				/*������ȣ�� �۾���������*/

delete from cia08t1 where io_yymm = :sYearMonth  and io_yymmt = :sYearMonthT ;			/*ǰ�� ������ ����*/
	
delete from cia09t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;				/*�ι��� �ο�����*/

delete from cia11t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;				/*�빫�� ���Ը�*/
delete from cia11t1 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			/*�����빫�� ���� ��� �̷�*/
delete from cia12tl where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;				/*������� ���Ը�*/
delete from cia12t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;				/*������� ���Ը�*/
delete from cia12t1 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			/*���ְ����� ���� ��*/
delete from cia12t2 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			/*�����󰢺� ���� ��*/
delete from cia13t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;				/*��������*/
delete from cia14t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;				/*ȸ���� ��*/							
delete from cia15t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;	/*Ÿ���� ��*/							
delete from cia20Ot where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			/*�����ι��� ��ΰ��ǥ*/
delete from cia20otl where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			/*�����ι��� ��ΰ��ǥ*/

/* �̿� �ڷ� �Ⱓ ��������:2005.06.17 */
/* ���(0) : ���� ����(1): ���⸻ */
String   sBefYm, sBefYmT, sDateGbn
Integer  iCount

sDateGbn = dw_cond.GetItemString(1,"dategbn")
if sDateGbn = '0' then
	if Mid(sYearMonth,5,2) = '01' then
		sBefYm   = String(Integer(Left(sYearMonth,4)) - 1,'0000') + '12'
		sBefYmt  = String(Integer(Left(sYearMonth,4)) - 1,'0000') + '12'
	else
		sBefYm  = Left(sYearMonth,4) + String(Integer(Mid(sYearMonth,5,2)) - 1,'00')
		sBefYmt = Left(sYearMonth,4) + String(Integer(Mid(sYearMonth,5,2)) - 1,'00')
	end if
else
	sBefYm  = String(Integer(Left(sYearMonth,4)) - 1,'0000') + '01'
	sBefYmt = String(Integer(Left(sYearMonth,4)) - 1,'0000') + '12'
end if
if sYearMonth = '200501' then
	sBefYm = '200412'
	sBefYmt = '200412'
end if

select Count(*) 	into :iCount									/*����� ���ǥ*/				
	from cia04t
	where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and data_gu = 'A' ;
if sqlca.sqlcode = 0 and iCount > 0 then
	update cia04t
		set babu_num = 0,			babu_rate = 0
		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and data_gu = 'A';
else
	insert into cia04t
		(io_yymm,				io_yymmt,				ucost_cd,			cost_cd,				cost_gu2,			cost_gbn,	
		 babu,					babu_num,				babu_rate,			data_gu)
	select :sYearMonth,		:sYearMontht,			ucost_cd,			cost_cd,				cost_gu2,			cost_gbn,	
			 babu,				0,							0,						data_gu
		from cia04t
		where io_yymm = :sBefYm and io_yymmt = :sBefYmt and data_gu = 'A' ;
end if

select Count(*) 	into :iCount									/*�����,�۾��庰 ��������ǥ*/	
	from cia04t1
	where io_yymm = :sYearMonth and io_yymmt = :sYearMontht and data_gu = 'A' ;
if sqlca.sqlcode = 0 and iCount > 0 then
	update cia04t1
		set babu_num = 0,			babu_rate = 0
		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and data_gu = 'A';
else
	insert into cia04t1
		(io_yymm,			io_yymmt,		cost_cd,			wkctr,			cost_gu2,			cost_gbn,
		 babu,				babu_num,		babu_rate,		data_gu )
	select :sYearMonth,	:sYearMonthT,	cost_cd,			wkctr,		cost_gu2,			cost_gbn,	
			 babu,			0,					0,					data_gu
		from cia04t1
		where io_yymm = :sBefYm and io_yymmt = :sBefYmt and data_gu = 'A' ;
end if

select Count(*) into :iCount								/*ǰ�� ��������*/
	from cia22t
	where io_yymm = :sBefYm and io_yymmt = :sBefYmt;
if sqlca.sqlcode <> 0  then
	iCount = 0
else
	if IsNull(iCount) then iCount = 0
end if

if iCount = 0 then
	update cia22t  														/*ǰ�� ��������*/
		set ip_qty  = 0,		op_qty  = 0,	wp_qty = 0,     lo_qty =0,
			 ips_mat = 0,		ips_lab = 0,	ips_over = 0,
			 ipp_mat = 0,		ipp_lab = 0,	ipp_over = 0,
			 wp_mat  = 0,		wp_lab  = 0,	wp_over  = 0,
			 op_mat  = 0,		op_lab  = 0,	op_over  = 0,
			 lo_mat  = 0,		lo_lab  = 0,	lo_over  = 0
		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;
	
	delete from cia22t
		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and
				iwol_qty = 0 and iwol_mat = 0 and iwol_lab = 0 and iwol_over = 0;
else
	delete from cia22t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			
	
	insert into cia22t
		(io_yymm,	io_yymmt,itnbr,	pordno,		opseq,		roslt,		iwol_qty,	ip_qty,	op_qty,	wp_qty,
		 iwol_mat,	iwol_lab,iwol_over,	ips_mat,		ips_lab,		ips_over,ipp_mat,	ipp_lab,
		 ipp_over,	wp_mat,	wp_lab,		wp_over,		pdtgu,		op_mat,	op_lab,	op_over,
		 lo_qty,		lo_mat,	lo_lab,		lo_over)
		 
	select :sYearMonth,:sYearMonthT,itnbr,pordno,		opseq,		roslt,		wp_qty,		0,			0,			wp_qty,
		 wp_mat,		wp_lab,	wp_over,		0,				0,				0,			0,			0,
		 0,			wp_mat,	wp_lab,		wp_over,		pdtgu,		0,			0,			0,
		 0,			0,			0,				0
		from cia22t
		where io_yymm = :sBefYm and io_yymmt = :sBefYmt and 
				(nvl(wp_qty,0) <> 0 or nvl(wp_mat,0) <> 0 or nvl(wp_lab,0) <> 0 or nvl(wp_over,0) <> 0) ;

end if

delete from cia22t1 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;		

select Count(*) into :iCount	
	from cia23t
	where io_yymm = :sBefYm and io_yymmt = :sBefYmT ;
if sqlca.sqlcode <> 0 then
	iCount = 0
else
	if IsNull(iCount) then iCount = 0
end if

if iCount <=0 then
	update cia23t															/*������*/
		set ip_qty = 0,		op_qty = 0,		im_qty = 0,		ti_qty = 0,		to_qty = 0,
			 ip_mat = 0,		ip_lab = 0,		ip_over = 0,	ti_mat = 0,		ti_lab = 0,
			 op_mat = 0,		op_lab = 0,		op_over = 0,	to_mat = 0,		to_lab = 0,
			 to_over = 0,		im_mat = 0,		im_lab  = 0,	im_over = 0,	im_uprc = 0,
			 opmat_uprc =0,	oplab_uprc = 0,opover_uprc = 0,
			 ipt_qty = 0, 		ipt_mat = 0, 	ipt_lab = 0, 	ipt_over = 0,
			 opt_qty = 0, 		opt_mat = 0, 	opt_lab = 0, 	opt_over = 0
		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;
		
	delete from cia23t
		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and
				iwol_qty = 0 and iwol_mat = 0 and iwol_lab = 0 and iwol_over = 0;

else
	delete from cia23t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT ;			
	
	insert into cia23t
		(io_yymm,		io_yymmt,	itnbr,		iwol_qty,		ip_qty,		op_qty,		im_qty,		ti_qty,
		 to_qty,			iwol_mat,	iwol_lab,		iwol_over,	ip_mat,		ip_lab,		ip_over,
		 op_mat,			op_lab,		op_over,
		 ti_mat,			ti_lab,		ti_over,			to_mat,		to_lab,		to_over,		im_mat,
		 im_lab,			im_over,		im_uprc,			pdtgu,
		 opmat_uprc,	oplab_uprc,	opover_uprc)  
	select :sYearMonth,:sYearMonthT,itnbr,		im_qty,			0,				0,				im_qty,		0,
		 0,				im_mat,		im_lab,			im_over,		0,				0,				0,
		 0,				0,				0,
		 0,				0,		 		0,					0,				0,				0,				im_mat,
		 im_lab,			im_over,		0,					pdtgu,
		 0,				0,				0
		from cia23t
		where io_yymm = :sBefYm and io_yymmt = :sBefYmt and
				(nvl(im_qty,0) <> 0 or nvl(im_mat,0) + nvl(im_lab,0) + nvl(im_over,0) <> 0);

end if

Long  lSeq = 50000,lCount10 ,lCount21

Do
	delete from cia10t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and rownum <= :lSeq;				/*������ ǰ�� �������Ը�*/
	delete from cia21t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT and rownum <= :lSeq;				/*������ȣ�� ǰ�� ��ΰ��ǥ*/
	Commit;
	
	select Count(*)	into :lCount10	 from cia10t where io_yymm = :sYearMonth  and io_yymmt = :sYearMonthT;		
	select Count(*)	into :lCount21 from cia21t where io_yymm = :sYearMonth  and io_yymmt = :sYearMonthT ;	
Loop Until lCount10 <= 0 and lCount21 <= 0

delete from cia08t where io_yymm = :sYearMonth  and io_yymmt = :sYearMonthT;				/*�ι��� ��������*/
delete from cia08t2 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;			/*ǰ��,���̾ ������ ����*/	
delete from cia10t1 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;			/*������ ǰ�� ������������*/

delete from cia21t1 where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;			/*ǰ�� ��ΰ��ǥ*/
	
delete from cia24t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;				/*��ǰ�� �������� ����*/
delete from cia25t where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;				/*��ǰ�� ������� ����*/

delete from ciaitemcost where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;		/*ǰ�� ��������*/

commit ;

Return 1
end function

on w_cia00200.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
end on

on w_cia00200.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(dw_cond.GetRow(),"yearmon",Left(f_Today(),6))
dw_cond.SetItem(dw_cond.GetRow(),"yearmont",Left(f_Today(),6))

dw_cond.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_cia00200
boolean visible = false
integer x = 137
integer y = 2600
end type

type p_delrow from w_inherite`p_delrow within w_cia00200
boolean visible = false
integer x = 4119
integer y = 3320
end type

type p_addrow from w_inherite`p_addrow within w_cia00200
boolean visible = false
integer x = 3945
integer y = 3320
end type

type p_search from w_inherite`p_search within w_cia00200
boolean visible = false
integer x = 3250
integer y = 3320
end type

type p_ins from w_inherite`p_ins within w_cia00200
boolean visible = false
integer x = 3771
integer y = 3320
end type

type p_exit from w_inherite`p_exit within w_cia00200
end type

type p_can from w_inherite`p_can within w_cia00200
boolean visible = false
integer x = 3968
integer y = 3088
end type

type p_print from w_inherite`p_print within w_cia00200
boolean visible = false
integer x = 3424
integer y = 3320
end type

type p_inq from w_inherite`p_inq within w_cia00200
boolean visible = false
integer x = 3598
integer y = 3320
end type

type p_del from w_inherite`p_del within w_cia00200
boolean visible = false
integer x = 3794
integer y = 3088
end type

type p_mod from w_inherite`p_mod within w_cia00200
integer x = 4270
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::clicked;//String  sYearMonth,sYearMonthT,sClearGbn,sCalc1,sCalc2,sCalc3,sCalc4,sCalc5,sCalc6,sCalc7,sCalc9,sErrors,&
//		  sNextYearMonth,sSabu = '1',sCurrYearMonth
//
//String  sErrMsg[] = {'���Һ�(����)',				'���Һ�(Ÿ�Լ���)',			'Ÿ�� ����',		&
//							'���Һ�(Ÿ�Աݾ� Ȯ��)',	'���Һ�(Ÿ��ݾ� Ȯ��)',	'Ÿ����ݾ� Ȯ��', &
//							'���Һ� �����)',			'����',						'�빫��1',				&
//							'�빫��2',						'�������',		 				'���ְ�����',				&			
//							'�����󰢺�',					' ',								'',&
//					 		'�۾����ú� ����',			'ǰ�� ����',					'�������� �ð�����',			&
//						   'ǰ�� ��������', 			'���������1',					'���������2',				&
//							'ǰ�� �ǸŽ���',	 		'���������3'}
//
//Integer iRtnValue,iFrom,iTo,k
//
//dw_cond.AcceptText()
//
//sYearMonth = Trim(dw_cond.GetItemString(dw_cond.GetRow(),"yearmon"))
//sYearMonthT = Trim(dw_cond.GetItemString(dw_cond.GetRow(),"yearmont"))
//sCalc9     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn9")		/*���� ���� ����*/
//sClearGbn  = dw_cond.GetItemString(dw_cond.GetRow(),"cleargbn")		/*�ʱ�ȭ*/
//sCalc1     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn1")		/*�������Һ�*/
//sCalc2     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn2")		/*��Һ� ����*/
//sCalc3     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn3")		/*��α��� ����*/
//sCalc4     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn4")		/*����� ���*/
//sCalc5     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn5")		/*�������(��ΰ��ǥ)*/
//sCalc6     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn6")		/*�������(��������)*/
//sCalc7     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn7")		/*�������(���Һ� Ȯ��)*/
//
//IF sYearMonth = "" OR IsNull(sYearMonth) THEN
//	F_Messagechk(1,'[ó�����]')
//	dw_cond.SetColumn("yearmon")
//	dw_cond.SetFocus()
//	Return
//ELSE
//	IF Right(sYearMonth,2) = '12' THEN
//		sNextYearMonth = String(Long(Left(sYearMonth,4)) + 1,'0000')+'01'
//	ELSE
//		sNextYearMonth = Left(sYearMonth,4) + String(Integer(Right(sYearMonth,2)) + 1,'00')
//	END IF
//END IF
//
//iFrom = Integer(Mid(sYearMonth,5,2))
//iTo   = Integer(Mid(sYearMontht,5,2))
//
//SetPointer(HourGlass!)
//
//IF sCalc9 = 'Y' THEN
//	w_mdi_frame.sle_msg.text = '���� ���� ���� ��...'
//	
//	sErrors = 'A'	
//	
//	for k = iFrom to iTo
//		sCurrYearMonth = Left(sYearMonth,4)+String(k,'00')
//		
//		IF Right(sCurrYearMonth,2) = '12' THEN
//			sNextYearMonth = String(Long(Left(sCurrYearMonth,4)) + 1,'0000')+'01'
//		ELSE
//			sNextYearMonth = Left(sCurrYearMonth,4) + String(Integer(Right(sCurrYearMonth,2)) + 1,'00')
//		END IF
//	
//		Sqlca.ERP000000770('1',sCurrYearMonth,sNextYearMonth,sErrors);
//	
//		IF sErrors = 'Y' THEN
//			MessageBox('Ȯ ��','���� ���� ������ �����Ͽ����ϴ�...')
//			Rollback;
//			sle_msg.text = ''
//			Return
//		END IF
//	next
//	
//END IF
//
//IF sClearGbn = 'Y' THEN						/*�ʱ�ȭ = YES*/
//	w_mdi_frame.sle_msg.Text = '�ڷḦ �ʱ�ȭ ��...'
//	
//	Wf_Clear_Cia(sYearMonth,sYearMontht)
//END IF
//
//IF sCalc1 = 'Y' THEN							/*�������Һ� �ۼ� = 'Y'*/
//	sErrMsg[] = {'���Һ�-��/��/Ÿ��',		'���Һ�-Ÿ��',				'Ÿ���',			'ȸ���� ��',			&
//		          '���Һ�-Ÿ��/��� Ȯ��','Ÿ���-Ÿ��ݾ� Ȯ��','���Һ�-�����'}
//
//
//	w_mdi_frame.sle_msg.text = '�������Һ� �ۼ� ��...'
//	iRtnValue = Sqlca.Fun_Cia0010a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[�������Һ� �ۼ�]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -7 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -700 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc2 = 'Y' THEN							/*������� ���� = 'Y'*/
//	sErrMsg[] = {'����','�빫��','�������','���ְ�����','�����󰢺�'}
//
//
//	w_mdi_frame.sle_msg.text = '������� ���� ��...'
//	iRtnValue = Sqlca.Fun_Cia0011a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[������� ����]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -5 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -500 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc3 = 'Y' THEN							/*��α��� ���� = 'Y'*/
//	sErrMsg[] = {'�������ð�����',		'ǰ�񺰽ð�����',		'������������-�۾��ð�', 		'�������� ����-�빫��',&
//					 'ǰ�� ������',		'ǰ�� �ǸŽ���'}
//	
//	w_mdi_frame.sle_msg.text = '��α��� ���� ��...'
//	iRtnValue = Sqlca.Fun_Cia0020a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[��α��� ����]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -6 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -600 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc4 = 'Y' THEN							/*����� ��� = 'Y'*/
//	sErrMsg[] = {'���������(30)',	'���������(31)', 	'���������(20)',	'���������(32)',	'���������(22)',&
//					 '���������(50)'}
//	
//	w_mdi_frame.sle_msg.text = '����� ��� ��...'
//	iRtnValue = Sqlca.Fun_Cia0021a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[����� ���]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -6 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -600 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc5 = 'Y' THEN							/*�������(��ΰ��ǥ) = 'Y'*/
//	sErrMsg[] = {'�����ι��� ��ΰ��ǥ1(cia20ot) �ۼ�-�빫��(fun_cia00301)',							&
//							   '�����ι��� ��ΰ��ǥ2(cia20ot) �ۼ�-�������(fun_cia003011)',							&
//							   '�����ι��� ��ΰ��ǥ3(cia20ot) �ۼ�-�����󰢺�(fun_cia003012)',						&
//							   'Ÿ�μ����� �������� ����,������ ���� ����(fun_cia003014)',								&
//							   '���� ��ü���� ���(fun_cia003015)',																&
//							   '�����ι��� ��ΰ��ǥ(cia20ot) ��� ����(fun_cia003019)',									&
//							   '�� ��ü���� ����(fun_cia0030151)',																&
//								'ǰ�� ��ΰ��ǥ(cia21t)-���󰢺�(������)(fun_cia00302)',					&
//								'ǰ�� ��ΰ��ǥ(cia21t)-���󰢺�(ǰ����)(fun_cia003021)',					&
//								'ǰ�� ��ΰ��ǥ(cia21t)-���º�(������)(fun_cia003024)',					&
//								'ǰ�� ��ΰ��ǥ(cia21t)-���ƺ�(ǰ����)(fun_cia0030241)',					&
//							   'ǰ�� ��ΰ��ǥ(cia21t)-������ȣ �ִ� ��(fun_cia00303)',					&
//							   'ǰ�� ��ΰ��ǥ(cia21t)-��������(fun_cia003031)',						&
//							   'ǰ�� ��ΰ��ǥ(cia21t) ���� - ���(fun_cia00304)',						&
//							   'ǰ�� ��ΰ��ǥ(cia21t) ���� - ���ְ�����I(fun_cia00305)',				&
//							   'ǰ�� ��ΰ��ǥ(cia21t) ���� - ���ְ�����II(fun_cia003051)',			&
//							   'ǰ�� ��ΰ��ǥ(cia21t1) �ۼ� - cia21t ����(fun_cia003059)',							&
//							   '������ ǰ�� ��������(cia22t) �ۼ�(fun_cia00306)'}
//	
//	w_mdi_frame.sle_msg.text = '�������(��ΰ��ǥ ����) ��...'
//	iRtnValue = Sqlca.Fun_Cia0030a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[�������(��ΰ��ǥ ����)]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -20 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -2000 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc6 = 'Y' THEN							/*�������(��������) = 'Y'*/
//	sErrMsg[] = {'ȸ����ǰ���� �԰�ݾ� ���',								&
//					 'ȸ����ǰ���� ���ݾ� ���',								&
//					 'LOW LEVEL CODE�� ó���� ǰ���� ���� Ȯ��',				&
//					 'ǰ�� ��������(cia22t) ������,���ݾ� ���(fun_cia0030811)',							&
//					 'ǰ�� ��������(cia22t) �������� �ܼ� ����(fun_cia003082)',								&
//					 '�������� ����(fun_cia001011)'}
//	
//	w_mdi_frame.sle_msg.text = '�������(���� ����) ��...'
//	iRtnValue = Sqlca.Fun_Cia0031a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[�������(��������)]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -6 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -600 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc7 = 'Y' THEN							/*�������(���Һ� Ȯ��) = 'Y'*/
//	sErrMsg[] = {'�������� ���ݾ� Ȯ��(������)(fun_cia003084)',	&
//					 'Ÿ���ڷ��� ���ݾ� ����(fun_cia0030841)',														&
//					 'ǰ�� �ǸŽ����� ������� ���(fun_cia0030843)',				&
//					 '�������� Ÿ�������ݾ� Ȯ��(fun_cia0030842)',					&
//					 '�������� �԰�ݾ� Ȯ��(ȸ����ǰ��)(fun_cia0030844)',			&
//					 '�������� ���ݾ� Ȯ��(��ǰ,��ǰ),�����(fun_cia0030845)',							&
//					 'ǰ�� ���������� ������(��������)(fun_cia00309(cia22t1)',								&
//					 '��ǰ�� �������� ����(fun_cia003091(cia24t)',													&
//					 'ǰ�� �������� ����(fun_cia003092(ciaitemcost)',											&
//					 'ǰ�� ������� ���� ����(fun_cia003095(cia25t))'                                 }
//							
//	w_mdi_frame.sle_msg.text = '���� ��� ��...'
//	iRtnValue = Sqlca.Fun_Cia0032a(sYearMonth,sYearMontht)
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[���� ��� ���]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -10 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -1000 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//w_mdi_frame.sle_msg.text = 'ó���� �Ϸ��Ͽ����ϴ�!!'
//SetPointer(Arrow!)		
//
//
//
end event

type cb_exit from w_inherite`cb_exit within w_cia00200
boolean visible = true
integer x = 2665
integer y = 3288
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_cia00200
boolean visible = true
integer x = 2277
integer y = 3288
integer width = 361
integer taborder = 20
string text = "ó��(&E)"
end type

event cb_mod::clicked;call super::clicked;//String  sYearMonth,sClearGbn,sCalc1,sCalc2,sCalc3,sCalc4,sCalc5,sCalc6,sCalc7,sCalc9,sErrors,sNextYearMonth,sSabu = '1'
//
//String  sErrMsg[] = {'���Һ�(����)',				'���Һ�(Ÿ�Լ���)',			'Ÿ�� ����',		&
//							'���Һ�(Ÿ�Աݾ� Ȯ��)',	'���Һ�(Ÿ��ݾ� Ȯ��)',	'Ÿ����ݾ� Ȯ��', &
//							'���Һ� �����)',			'����',						'�빫��1',				&
//							'�빫��2',						'�������',		 				'���ְ�����',				&			
//							'�����󰢺�',					' ',								'',&
//					 		'�۾����ú� ����',			'ǰ�� ����',					'�������� �ð�����',			&
//						   'ǰ�� ��������', 			'���������1',					'���������2',				&
//							'ǰ�� �ǸŽ���',	 		'���������3'}
//
//Integer iRtnValue
//
//dw_cond.AcceptText()
//
//sYearMonth = Trim(dw_cond.GetItemString(dw_cond.GetRow(),"yearmon"))
//sCalc9     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn9")		/*���� ���� ����*/
//sClearGbn  = dw_cond.GetItemString(dw_cond.GetRow(),"cleargbn")		/*�ʱ�ȭ*/
//sCalc1     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn1")		/*�������Һ�*/
//sCalc2     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn2")		/*��Һ� ����*/
//sCalc3     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn3")		/*��α��� ����*/
//sCalc4     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn4")		/*����� ���*/
//sCalc5     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn5")		/*�������(��ΰ��ǥ)*/
//sCalc6     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn6")		/*�������(��������)*/
//sCalc7     = dw_cond.GetItemString(dw_cond.GetRow(),"calcgbn7")		/*�������(���Һ� Ȯ��)*/
//
//IF sYearMonth = "" OR IsNull(sYearMonth) THEN
//	F_Messagechk(1,'[ó�����]')
//	dw_cond.SetColumn("yearmon")
//	dw_cond.SetFocus()
//	Return
//ELSE
//	IF Right(sYearMonth,2) = '12' THEN
//		sNextYearMonth = String(Long(Left(sYearMonth,4)) + 1,'0000')+'01'
//	ELSE
//		sNextYearMonth = Left(sYearMonth,4) + String(Integer(Right(sYearMonth,2)) + 1,'00')
//	END IF
//END IF
//
//SetPointer(HourGlass!)
//
//IF sCalc9 = 'Y' THEN
//	sle_msg.text = '���� ���� ���� ��...'
//
//	Sqlca.ERP000000770('1',sYearMonth,sNextYearMonth,sErrors);
//	
//	IF sErrors = 'Y' THEN
//		MessageBox('Ȯ ��','���� ���� ������ �����Ͽ����ϴ�...')
//		Rollback;
//		sle_msg.text = ''
//		Return
//	END IF
//END IF
//
//IF sClearGbn = 'Y' THEN						/*�ʱ�ȭ = YES*/
//	sle_msg.Text = '�ڷḦ �ʱ�ȭ ��...'
//	
//	Wf_Clear_Cia(sYearMonth)
//END IF
//
//IF sCalc1 = 'Y' THEN							/*�������Һ� �ۼ� = 'Y'*/
//	sErrMsg[] = {'���Һ�-��/��/Ÿ��',		'���Һ�-Ÿ��',				'Ÿ���',			'ȸ���� ��',			&
//		          '���Һ�-Ÿ��/��� Ȯ��','Ÿ���-Ÿ��ݾ� Ȯ��','���Һ�-�����'}
//
//
//	sle_msg.text = '�������Һ� �ۼ� ��...'
//	iRtnValue = Sqlca.Fun_Cia0010a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[�������Һ� �ۼ�]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -7 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -700 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc2 = 'Y' THEN							/*������� ���� = 'Y'*/
//	sErrMsg[] = {'����','�빫��','�����빫�� ����','�������','���ְ�����'}
//
//
//	sle_msg.text = '������� ���� ��...'
//	iRtnValue = Sqlca.Fun_Cia0011a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[������� ����]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -5 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -500 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc3 = 'Y' THEN							/*��α��� ���� = 'Y'*/
//	sErrMsg[] = {'�������ð�����',		'ǰ�񺰽ð�����',		'������������-�۾��ð�', 		'�������� ����-�빫��',&
//					 'ǰ�� ������',		'ǰ�� �ǸŽ���'}
//	
//	sle_msg.text = '��α��� ���� ��...'
//	iRtnValue = Sqlca.Fun_Cia0020a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[��α��� ����]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -6 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -600 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc4 = 'Y' THEN							/*����� ��� = 'Y'*/
//	sErrMsg[] = {'���������(30)',	'���������(31)', 	'���������(20)',	'���������(32)',	'���������(22)',&
//					 '���������(50)'}
//	
//	sle_msg.text = '����� ��� ��...'
//	iRtnValue = Sqlca.Fun_Cia0021a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[����� ���]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -6 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -600 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc5 = 'Y' THEN							/*�������(��ΰ��ǥ) = 'Y'*/
//	sErrMsg[] = {'�����ι��� ��ΰ��ǥ1(cia20ot) �ۼ�-�빫��(fun_cia00301)',							&
//							   '�����ι��� ��ΰ��ǥ2(cia20ot) �ۼ�-�������(fun_cia003011)',							&
//							   '�����ι��� ��ΰ��ǥ3(cia20ot) �ۼ�-�����󰢺�(fun_cia003012)',						&
//							   'Ÿ�μ����� �������� ����,������ ���� ����(fun_cia003014)',								&
//							   '���� ��ü���� ���(fun_cia003015)',																&
//							   '�����ι��� ��ΰ��ǥ(cia20ot) ��� ����(fun_cia00302)',									&
//							   '�� ��ü���� ����(fun_cia0030151)',																&
//							   '������ȣ�� ǰ�� ��ΰ��ǥ(cia21t)-������ȣ �ִ� ��(fun_cia00303)',					&
//							   '������ȣ�� ǰ�� ��ΰ��ǥ(cia21t)-��������(fun_cia003031)',						&
//							   '������ȣ�� ǰ�� ��ΰ��ǥ(cia21t) ���� - ���(fun_cia00304)',						&
//							   '������ȣ�� ǰ�� ��ΰ��ǥ(cia21t) ���� - ���ְ�����I(fun_cia00305)',				&
//							   '������ȣ�� ǰ�� ��ΰ��ǥ(cia21t) ���� - ���ְ�����II(fun_cia003051)',			&
//							   'ǰ�� ��ΰ��ǥ(cia21t1) �ۼ� - cia21t ����(fun_cia003059)',							&
//							   '������ ǰ�� ��������(cia22t) �ۼ�(fun_cia00306)'}
//	
//	sle_msg.text = '�������(��ΰ��ǥ ����) ��...'
//	iRtnValue = Sqlca.Fun_Cia0030a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[�������(��ΰ��ǥ ����)]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -14 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -1400 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc6 = 'Y' THEN							/*�������(��������) = 'Y'*/
//	sErrMsg[] = {'ȸ����ǰ���� �԰�ݾ� ���',								&
//					 'ȸ����ǰ���� ���ݾ� ���',								&
//					 'LOW LEVEL CODE�� ó���� ǰ���� ���� Ȯ��',				&
//					 'ǰ�� ��������(cia22t) ������,���ݾ� ���(fun_cia0030811)',							&
//					 'ǰ�� ��������(cia22t) �������� �ܼ� ����(fun_cia003082)',								&
//					 '�������� ����(fun_cia001011)'}
//	
//	sle_msg.text = '�������(���� ����) ��...'
//	iRtnValue = Sqlca.Fun_Cia0031a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[�������(��������)]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -6 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -600 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//IF sCalc7 = 'Y' THEN							/*�������(���Һ� Ȯ��) = 'Y'*/
//	sErrMsg[] = {'�������� ���ݾ� Ȯ��(������)(fun_cia003084)',	&
//					 'Ÿ���ڷ��� ���ݾ� ����(fun_cia0030841)',														&
//					 'ǰ�� �ǸŽ����� ������� ���(fun_cia0030843)',				&
//					 '�������� Ÿ�������ݾ� Ȯ��(fun_cia0030842)',					&
//					 '�������� �԰�ݾ� Ȯ��(ȸ����ǰ��)(fun_cia0030844)',			&
//					 '�������� ���ݾ� Ȯ��(��ǰ,��ǰ),�����(fun_cia0030845)',							&
//					 'ǰ�� ���������� ������(��������)(fun_cia00309(cia22t1)',								&
//					 '��ǰ�� �������� ����(fun_cia003091(cia24t)',													&
//					 'ǰ�� �������� ����(fun_cia003092(ciaitemcost)',											&
//					 'ǰ�� ������� ���� ����(fun_cia003095(cia25t))'                                 }
//							
//	sle_msg.text = '���� ��� ��...'
//	iRtnValue = Sqlca.Fun_Cia0032a(sYearMonth,'N')
//	
//	IF iRtnValue = 0 THEN
//		F_MessageChk(59,'[���� ��� ���]')
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -10 and iRtnValue <= -1 THEN
//		F_MessageChk(13,'['+sErrMsg[Abs(iRtnValue)]+']')
//		
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSEIF iRtnValue >= -1000 and iRtnValue <= -100 THEN
//		F_MessageChk(59,'['+sErrMsg[Abs(iRtnValue) / 100]+']')
//		Rollback;
//		SetPointer(Arrow!)
//		Return
//	ELSE
//		Commit;
//	END IF
//END IF
//
//sle_msg.text = 'ó���� �Ϸ��Ͽ����ϴ�!!'
//SetPointer(Arrow!)		
//
//
//
end event

type cb_ins from w_inherite`cb_ins within w_cia00200
boolean visible = true
integer x = 475
integer y = 3020
end type

type cb_del from w_inherite`cb_del within w_cia00200
boolean visible = true
integer x = 1577
integer y = 2988
end type

type cb_inq from w_inherite`cb_inq within w_cia00200
boolean visible = true
integer x = 114
integer y = 3020
end type

type cb_print from w_inherite`cb_print within w_cia00200
boolean visible = true
integer x = 2752
integer y = 2900
end type

type st_1 from w_inherite`st_1 within w_cia00200
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_cia00200
boolean visible = true
integer x = 1934
integer y = 2988
end type

type cb_search from w_inherite`cb_search within w_cia00200
boolean visible = true
integer x = 2208
integer y = 2888
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00200
boolean visible = true
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_cia00200
boolean visible = true
integer width = 2487
end type

type gb_10 from w_inherite`gb_10 within w_cia00200
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_cia00200
boolean visible = true
integer x = 78
integer y = 2960
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00200
boolean visible = true
integer x = 2235
integer y = 3232
integer width = 795
end type

type dw_cond from datawindow within w_cia00200
event ue_keyenter pbm_dwnprocessenter
integer x = 585
integer y = 124
integer width = 3072
integer height = 2052
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_cia002001"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String sYm,snull,sDateGbn

SetNull(snull)

IF this.GetColumnName() = "yearmont" THEN
	sYm = Trim(this.GetText())
	IF sYm = "" OR IsNull(sYm) THEN Return
	
	IF F_DateChk(sYm+'01') = -1 THEN
		F_MessageChk(21,'[ó�����')
		this.SetItem(this.GetRow(),"yearmont",snull)
		Return 1
	END IF
	
	sDateGbn = this.GetItemString(1,"dategbn")
	if sDateGbn = '0' then				/*��*/
		this.SetItem(this.GetRow(),"yearmon", sYm)
	else										/*����*/
		this.SetItem(this.GetRow(),"yearmon", Left(sYm,4)+'01')
	end if
END IF

IF this.GetColumnName() = 'dategbn' then
	sDateGbn = this.GetText()
	if sDateGbn = '' or IsNull(sDateGbn) then Return
	
	if sDateGbn = '0' then				/*��*/
		this.SetItem(this.GetRow(),"yearmon", this.GetItemString(1,"yearmont"))
	else										/*����*/
		this.SetItem(this.GetRow(),"yearmon", Left(this.GetItemString(1,"yearmont"),4)+'01')
	end if
END IF
end event

