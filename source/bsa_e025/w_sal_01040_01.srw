$PBExportHeader$w_sal_01040_01.srw
$PBExportComments$ ===> �Ⱓ �ǸŰ�ȹ ������ �߰�
forward
global type w_sal_01040_01 from window
end type
type p_exit from uo_picture within w_sal_01040_01
end type
type p_mod from uo_picture within w_sal_01040_01
end type
type dw_ip from u_key_enter within w_sal_01040_01
end type
type dw_add from datawindow within w_sal_01040_01
end type
type rr_1 from roundrectangle within w_sal_01040_01
end type
end forward

global type w_sal_01040_01 from window
integer x = 951
integer y = 336
integer width = 1888
integer height = 1996
boolean titlebar = true
string title = "�Ⱓ �Ǹ� ��ȹ �߰�"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
dw_ip dw_ip
dw_add dw_add
rr_1 rr_1
end type
global w_sal_01040_01 w_sal_01040_01

type variables
decimal is_danga
string is_cvcod, &
         is_year, &
         is_series
integer is_chasu
end variables

forward prototypes
public function integer wf_check_itnbr (string sitnbr)
public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty)
end prototypes

public function integer wf_check_itnbr (string sitnbr);Long   cnt, iRtnValue
String sNull
Dec    dDanga

SetNull(sNull)

//**********************************************		
Select count(*) Into :cnt From yearsaplan
Where (sabu = :gs_sabu) and (substr(plan_yymm,1,4)) = (:is_year) and 
		(plan_chasu = :is_chasu) and (cvcod = :is_cvcod) and (itnbr = :sitnbr);	
//**********************************************

if cnt > 0 then
	f_message_Chk(1, '[�ش�ǰ���� �Ⱓ��ȹ �������� Ȯ��]')
	dw_ip.SetItem(1,"itnbr",   sNull)
	dw_ip.SetItem(1,"itdsc",   sNull)
	dw_ip.SetItem(1,"ispec",   sNull)
	dw_ip.SetItem(1,"ispec_code",   sNull)
	dw_ip.SetItem(1,"shtnm",   sNull)
	dw_ip.SetItem(1,"tuncu",   sNull)
	dw_ip.SetItem(1,"dprice",   0)
	Return -1
End If


//iRtnValue = wf_calc_danga(1, sItnbr, 0)

//SELECT Fun_Erp100000012(to_char(sysdate,'yyyymmdd'), :sitnbr, '.')		  INTO :dDanga	  FROM DUAL;

//If IsNull(dDanga) Then dDanga = 0
//
//is_danga = dDanga
//dw_ip.setitem(1, "dprice", ddanga)


		
Return 1
end function

public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty);/* �ǸŴܰ��� ������ */
/* --------------------------------------------------- */
/* ���ݱ��� : 2000.05.16('0' �߰���)                   */
/* 0 - ������ ������ ��� �ܰ�              		       */ 
/* 1 - Ư������ �ŷ�ó ��� �ܰ�                       */ 
/* 2 - �̺�Ʈ ������ ��� �ܰ�                    	    */ 
/* 3 - �ŷ�ó�� ��ǰ�ܰ� ��� �ܰ�                     */ 
/* 4 - �ŷ�ó�� ������ ��� �ܰ�                       */ 
/* 5 - ǰ�񸶽�Ÿ ��� �ܰ�                  		    */ 
/* 9 - �̵�� �ܰ�                         		       */ 
/* --------------------------------------------------- */
string sOrderDate, sCvcod, sOrderSpec, sSalegu, sOutgu 
int    iRtnValue = -1, iRtn
double ditemprice,ddcrate, dQtyPrice, dQtyRate

sOrderDate 	= f_today()
sCvcod 	  	= is_cvcod
sOrderSpec = '.'

/* ���� */
IF IsNull(dItemQty) THEN dItemQty =0


/* ��������� ��� */
sSalegu 	='Y'
If 	sSaleGu = 'N' Then
	dItemPrice = sqlca.Fun_Erp100000025(Itnbr,sOrderSpec, sOrderDate) 
	If IsNull(dItemPrice) Then dItemPrice = 0
	dw_ip.SetItem(1, 'dprice', dItemPrice)
	Return 0
End If
		
/* ������ 0�̻��� ��� ����base�ܰ�,�������� ���Ѵ� */
If dItemQty > 0 Then
	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, Itnbr, dItemQty, &
                                    'WON', dQtyPrice, dQtyRate) 
End If

If IsNull(dQtyPrice) Then dQtyPrice = 0
If IsNull(dQtyRate)	Then dQtyRate = 0

/* �Ǹ� �⺻�ܰ�,�������� ���Ѵ� */
iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sOrderDate, sCvcod, Itnbr, sOrderSpec, &
												'WON','1', dItemPrice, dDcRate) 

/* Ư��ܰ��� �ŷ�ó�ܰ��ϰ�� ������ �������� ������� */
If iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0

/* �⺻������ ����ܰ� * ������ ������ */
If dQtyRate <> 0 Then
	
	dItemPrice = dItemPrice * (100 - dQtyRate)/100
	
	/* ������2�ڸ� */
	dItemPrice = Truncate(dItemPrice , 2) 
	
	/* ������ ���� */
   iRtn = sqlca.fun_erp100000014(itnbr,sOrderSpec, dItemPrice, sOrderDate, 'WON', '1', dDcRate)
   If iRtn = -1 Then dDcRate = 0
End If

If IsNull(dItemPrice) Then dItemPrice = 0
If IsNull(dDcRate) 	 Then dDcRate = 0

/* �ܰ� : ���� */
dItemPrice = truncate(dItemPrice,0)

Choose Case iRtnValue
	Case IS < 0 
		f_message_chk(41,'[�ܰ� ���]'+string(irtnvalue))
		Return 1
	Case Else
		dw_ip.SetItem(1,"dprice",	dItemPrice)
End Choose

is_danga = dw_ip.GetItemDecimal(1, "dprice")
Return 0
end function

on w_sal_01040_01.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_ip=create dw_ip
this.dw_add=create dw_add
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_mod,&
this.dw_ip,&
this.dw_add,&
this.rr_1}
end on

on w_sal_01040_01.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_ip)
destroy(this.dw_add)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

string sYYMM, get_nm, get_nm2
integer i

str_yearsaplan str_plan

str_plan =  Message.PowerObjectParm
dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_ip.SetItem(1,'cvnas', str_plan.str_cvnas2)
dw_ip.SetItem(1,'cvcod', str_plan.str_cvcod)


is_chasu  = str_plan.str_chasu
is_cvcod  = str_plan.str_cvcod
is_year   = str_plan.str_year
is_series = str_plan.str_series

f_get_name2('V1', 'Y', is_cvcod, get_nm, get_nm2)
dw_ip.setitem(1, "cvcod", is_cvcod)	
dw_ip.setitem(1, "cvnas", get_nm)	

for i = 1 to 12 
   dw_add.insertrow(0)
   dw_add.SetItem(i, 'sabu', gs_sabu)
   dw_add.SetItem(i, 'plan_chasu', str_plan.str_chasu)
   dw_add.SetItem(i, 'cvcod', str_plan.str_cvcod)
   sYYMM = str_plan.str_year + Mid('0'+ string(i), len(string(i)), 2)
   dw_add.SetItem(i, 'plan_yymm', sYYMM)
   dw_add.SetItem(i, 'plan_qty', 0)
   dw_add.SetItem(i, 'plan_amt', 0)	
next

dw_add.SetTransObject(sqlca)

end event

type p_exit from uo_picture within w_sal_01040_01
integer x = 1655
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;CloseWithReturn(parent,-1)	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_mod from uo_picture within w_sal_01040_01
integer x = 1481
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;String  sItnbr, stuncu, syyyy, sconfirm
Long    i, l_cnt, l_chasu
Decimal dprice

If dw_ip.AcceptText() <> 1 Then Return
If dw_add.AcceptText() <> 1 Then Return

/* ����Ȱ� ������ return */
If f_ischanged(dw_add) = False Then Return

sItnbr = Trim(dw_ip.Object.itnbr[1])
stuncu = Trim(dw_ip.Object.tuncu[1])
dprice = dw_ip.Object.dprice[1]

syyyy   = mid(dw_add.Object.plan_yymm[1], 1, 4)
l_chasu = dw_add.Object.plan_chasu[1]

If IsNull(sItnbr) Or sItnbr = '' Then 
	f_message_chk(30,'[ǰ��]')
	dw_ip.SetFocus()
	Return -1
END IF

for i = 1 to 12 
   dw_add.SetItem(i, 'itnbr', sItnbr)
	dw_add.SetItem(i, 'rcurr', stuncu)
	dw_add.SetItem(i, 'plan_prc', dprice)
next

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from YEARSAPLAN_CONFIRM
 where Sabu       = :gs_sabu
   and Plan_yyyy  = :syyyy
   and Plan_chasu = :l_chasu; 

If sconfirm = 'Y' then
	MessageBox('�˸�', is_year + '��' + string(is_chasu) + '����'+ ' �Ⱓ �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	

/* Ȯ�� �ڷ�(YEARSAPLAN_CONFIRM ���̺�) Insert & Update */
select count(*)
  into :l_cnt
  from YEARSAPLAN_CONFIRM
 where Sabu       = :gs_sabu
   and Plan_yyyy  = :syyyy
   and Plan_chasu = :l_chasu;
	
If l_cnt = 0 Then
	Insert Into YEARSAPLAN_CONFIRM
	       ( Sabu, Plan_yyyy, Plan_chasu, Maflag)
	   Values
		    ( :gs_sabu, :syyyy, :l_chasu, 'N');
End If	

If dw_add.Update() = -1 then  
	messagebox("Ȯ��","�߰��۾�����!")
	Rollback;
	CloseWithReturn(parent,-1)
Else
	Commit;		
	messagebox("Ȯ��","�Ⱓ �Ǹ� ��ȹ�� �߰� �Ǿ����ϴ�!")
	CloseWithReturn(parent,1)	
End if

w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type dw_ip from u_key_enter within w_sal_01040_01
integer x = 41
integer y = 172
integer width = 1792
integer height = 368
integer taborder = 10
string dataobject = "d_sal_01040_01_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sNull, sItnbr, sItdsc, sIspec, sIspecCode, sshtnm, scvcod, scurr
Int    ireturn, icnt
Double dprice

SetNull(sNull)

If This.AcceptText() <> 1 Then Return

scvcod = This.Object.cvcod[1]

Choose Case GetColumnName() 
	/* ǰ�� */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_itmsht('ǰ��', 'Y', sitnbr, sitdsc, sispec, sshtnm, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "shtnm", sshtnm)
		If ireturn <> 0 Then		RETURN ireturn
		
		Post wf_check_itnbr(sItnbr)		
		
   /* ǰ�� */
	Case "itdsc"
		sitdsc = trim(GetText())
	
		ireturn = f_get_itmsht('ǰ��', 'Y', sitnbr, sitdsc, sispec, sshtnm, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "shtnm", sshtnm)
		If ireturn <> 0 Then		RETURN ireturn
		
		Post wf_check_itnbr(sItnbr)		
		 
	/* �԰� */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_itmsht('�԰�', 'Y', sitnbr, sitdsc, sispec, sshtnm, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "shtnm", sshtnm)
		If ireturn <> 0 Then		RETURN ireturn
		
		Post wf_check_itnbr(sItnbr)
	/* ��ȣ */
	Case "shtnm"
		sshtnm = trim(GetText())
	
		ireturn = f_get_itmsht('��ȣ','Y', sitnbr, sitdsc, sispec, sshtnm, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "shtnm", sshtnm)
		If ireturn <> 0 Then		RETURN ireturn
		
		Post wf_check_itnbr(sItnbr)
	/* �԰��ڵ� */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_itmsht('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sshtnm, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "shtnm", sshtnm)
		If ireturn <> 0 Then		RETURN ireturn
		
		Post wf_check_itnbr(sItnbr)
End Choose

/* ��ȭ����, �ܰ� */
/* ����Ⱓ���� ȯ���� ���� ��� ����ȯ���� ������*/
Select count(*)
  Into :icnt
  From VNDDAN
 Where cvcod = :scvcod
	And itnbr = :sitnbr
	And start_date                 <= To_Char(Sysdate,'YYYYMMDD')
	And Nvl(end_date,'99999999')   >= To_Char(Sysdate,'YYYYMMDD')
	And Rownum = 1;
	
If icnt = 1 Then	
	Select curr, sales_price
	  Into :scurr, :dprice
	  From VNDDAN
	 Where cvcod = :scvcod
		And itnbr = :sitnbr
		And start_date               <= To_Char(Sysdate,'YYYYMMDD')
		And Nvl(end_date,'99999999') >= To_Char(Sysdate,'YYYYMMDD');
	dprice = Truncate(dprice , 2) 
   setitem(1, "tuncu", scurr)	
   setitem(1, "dprice", dprice)		
Else
	Select curr, sales_price
	  Into :scurr, :dprice
	  From VNDDAN
	 Where cvcod = :scvcod
		And itnbr = :sitnbr
		And end_date  = (Select Max(End_date)
                    	    From VNDDAN
                      	Where cvcod = :scvcod
                     	  And itnbr = :sitnbr
		                    And End_date <= To_Char(Sysdate,'YYYYMMDD'));	
	dprice = Truncate(dprice , 2) 
   setitem(1, "tuncu", scurr)	
   setitem(1, "dprice", dprice)
End If							  
	
	  

 

end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;Long nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

/* ���ֻ��� check */
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
End Choose
end event

type dw_add from datawindow within w_sal_01040_01
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 560
integer width = 1755
integer height = 1308
integer taborder = 20
string dataobject = "d_sal_01040_01_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;String  sNull, sCol_Name, sYymm, sitnbr, srcurr
Long    lRow, lQty
Double  Dprice, DDanga, DQty, DAmt, DAmt_u


If dw_ip.AcceptText() <> 1 Then Return
If dw_add.AcceptText() <> 1 Then Return

sCol_Name = This.GetColumnName()
lRow = this.GetRow()
SetNull(sNull)

dprice = dw_ip.Object.dprice[1]
sitnbr = dw_ip.Object.itnbr[1]
srcurr = dw_ip.Object.tuncu[1]

Choose Case sCol_Name
	// ��ȹ���� ������ ����ȯ�� �����Ͽ� �ݾ� ����
   Case "plan_qty"
		
		sYymm  = this.Object.plan_yymm[lRow]
		DQty   = this.Object.plan_qty[lRow]
				
		//����ȯ�������Ͽ� ��ȭ �ݾ� ����
		DDanga = sqlca.erp000000090_1(sYymm, sitnbr, srcurr, dprice, '2') 

		IF IsNull(DDanga) Then 
          DDanga = 0
		ELSE	 
	      dw_add.SetItem(lRow, 'plan_prc', DDanga)
		END IF	
		
		DAmt   = DQty * DDanga //��ȭ
		DAmt_u = DQty * dprice //��ȭ
		DAmt   = Truncate(DAmt , 2) 
		DAmt_u = Truncate(DAmt_u , 2) 
		this.SetItem(lRow, 'plan_amt', DAmt)		
		this.SetItem(lRow, 'plan_amt_u', DAmt_u)		
end Choose

//Choose Case sCol_Name
//	// ��ȹ���� ������ ǥ�شܰ��� ���� ��ȹ�ݾ��� �������
//   Case "plan_qty"
//		lQty = this.GetItemNumber(lRow, 'plan_qty')
//		if isNull(is_danga) then
//			is_danga = 0
//		end if
//		lAmt = lQty * is_Danga
//		this.SetItem(lRow, 'plan_amt', lAmt)
//end Choose
end event

type rr_1 from roundrectangle within w_sal_01040_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 552
integer width = 1778
integer height = 1328
integer cornerheight = 40
integer cornerwidth = 55
end type

