$PBExportHeader$w_sal_01040.srw
$PBExportComments$�Ⱓ �ǸŰ�ȹ���
forward
global type w_sal_01040 from w_inherite
end type
type dw_vnd from datawindow within w_sal_01040
end type
type st_4 from statictext within w_sal_01040
end type
type dw_jogun from u_key_enter within w_sal_01040
end type
type gb_3 from groupbox within w_sal_01040
end type
type dw_update from datawindow within w_sal_01040
end type
type cb_add from commandbutton within w_sal_01040
end type
type st_2 from statictext within w_sal_01040
end type
type dw_model from datawindow within w_sal_01040
end type
type rb_1 from radiobutton within w_sal_01040
end type
type rb_2 from radiobutton within w_sal_01040
end type
type rb_3 from radiobutton within w_sal_01040
end type
type p_create from uo_picture within w_sal_01040
end type
type dw_hidden from datawindow within w_sal_01040
end type
type p_1 from uo_picture within w_sal_01040
end type
type gb_2 from groupbox within w_sal_01040
end type
type rr_2 from roundrectangle within w_sal_01040
end type
end forward

global type w_sal_01040 from w_inherite
integer height = 2468
string title = "�Ⱓ �Ǹ� ��ȹ ���"
dw_vnd dw_vnd
st_4 st_4
dw_jogun dw_jogun
gb_3 gb_3
dw_update dw_update
cb_add cb_add
st_2 st_2
dw_model dw_model
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
p_create p_create
dw_hidden dw_hidden
p_1 p_1
gb_2 gb_2
rr_2 rr_2
end type
global w_sal_01040 w_sal_01040

type variables
string is_cvcod, &
         is_year, &
         is_cvnas2, &
         is_series,isAreaChk
Integer is_chasu
      
end variables

forward prototypes
public function integer wf_dwvnd ()
public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty)
end prototypes

public function integer wf_dwvnd ();dw_vnd.reset()
dw_model.reset()

if dw_jogun.accepttext() = -1 then
	return 1
End if

String syear, ssaupj, ssarea
Long   lchasu

sYear 	= dw_jogun.getitemstring(1, "syy")
lchasu	= dw_jogun.getitemnumber(1, "schasu")
sSaupj   = dw_jogun.getitemstring(1, "saupj")
sSarea   = dw_jogun.getitemstring(1, "ssarea")

If IsNull( sSaupj ) or Trim( sSaupj ) =  '' then
	sSaupj = '%'
End if

If IsNull( sSarea ) or Trim( sSarea ) =  '' then
	sSarea = '%'
End if

If Not isNull(sYear) And lchasu > 0 then
	dw_vnd.retrieve(gs_sabu, syear, lchasu, ssaupj, ssarea)
End if

return 1
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
	dw_insert.SetItem(1, 'danamt', dItemPrice)
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
		dw_insert.SetItem(nrow,"danamt",	dItemPrice)
End Choose


Return dItemPrice
end function

on w_sal_01040.create
int iCurrent
call super::create
this.dw_vnd=create dw_vnd
this.st_4=create st_4
this.dw_jogun=create dw_jogun
this.gb_3=create gb_3
this.dw_update=create dw_update
this.cb_add=create cb_add
this.st_2=create st_2
this.dw_model=create dw_model
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.p_create=create p_create
this.dw_hidden=create dw_hidden
this.p_1=create p_1
this.gb_2=create gb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vnd
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.dw_jogun
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.dw_update
this.Control[iCurrent+6]=this.cb_add
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_model
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.rb_3
this.Control[iCurrent+12]=this.p_create
this.Control[iCurrent+13]=this.dw_hidden
this.Control[iCurrent+14]=this.p_1
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.rr_2
end on

on w_sal_01040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_vnd)
destroy(this.st_4)
destroy(this.dw_jogun)
destroy(this.gb_3)
destroy(this.dw_update)
destroy(this.cb_add)
destroy(this.st_2)
destroy(this.dw_model)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.p_create)
destroy(this.dw_hidden)
destroy(this.p_1)
destroy(this.gb_2)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;//*****************************************************************************//
//***  PGM NAME : �Ⱓ �Ǹ� ��ȹ ����                                       ***//
//***  PGM ID   : W_SAL_01040                                               ***//
//***  SUBJECT  : �Ⱓ �ǸŰ�ȹ ������ ������ �ʿ��� ��� ���              ***//
//***             ���ұ����� ���� �ŷ�ó�� �����Ͽ� �ش�ŷ�ó�� ��ǰ��     ***//
//***             ������ �����Ѵ�.(�߰� �� ���� ����)                       ***//
//*****************************************************************************//
String sYn

dw_Jogun.SetTransObject(sqlca)
dw_Vnd.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_update.Settransobject(sqlca)
dw_model.Settransobject(sqlca)

dw_Jogun.Insertrow(0)
dw_Vnd.Insertrow(0)
dw_Insert.Insertrow(0)
dw_update.InsertRow(0)

//p_ins.enabled = False
//p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'

/* User�� ���ұ��� ��� ���� */
SetNull(isAreaChk)
select substr(dataname,1,1) into :sYn
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 60;

If upper(sYn) = 'Y' Then
  SELECT "LOGIN_T"."L_SAREA"  
    INTO :isAreaChk
    FROM "LOGIN_T"  
   WHERE "LOGIN_T"."L_USERID" = :gs_userid   ;

	If Not IsNull(isAreaChk) Then
		dw_jogun.SetItem(1,'ssarea', isAreaChk)
		dw_jogun.Modify("ssarea.protect=1")
	Else
		isAreaChk = ''
	End If
End If


// �ΰ��� ����� ����
f_mod_saupj(dw_jogun, 'saupj')


w_mdi_frame.sle_msg.Text = '������ ��ȹ�⵵ �� ���� ���ұ����� �Է� �� �����ϼ���'

dw_Jogun.SetFocus()
end event

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_sal_01040
integer x = 64
integer y = 352
integer width = 4503
integer height = 1932
integer taborder = 10
string dataobject = "d_sal_01040"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;String  sNull, sCol_Name, sPlanYYmm, sItnbr, scurr, sYymm, scvcod, scolumn_nm
Long    lRow, lQty, lDan, lAmt, nRow, lAmt_u
Decimal dprice
Int     icnt

if this.accepttext() = -1 then return -1
if dw_jogun.accepttext() = -1 then return -1

sCol_Name = This.GetColumnName()

lRow = GetRow()
If lRow <= 0 Then Return

SetNull(sNull)

dprice = This.Object.sales_danga[lRow]
sitnbr = This.Object.itnbr[lRow]
scvcod = dw_jogun.Object.cvcod[1]

/* �������� */
select to_char(sysdate,'yyyymm')
  into :sYymm  
  from dual;

/* ��ȭ���� */
Select count(*)
  Into :icnt
  From VNDDAN
 Where cvcod = :scvcod
	And itnbr = :sitnbr
	And start_date                 <= To_Char(Sysdate,'YYYYMMDD')
	And Nvl(end_date,'99999999')   >= To_Char(Sysdate,'YYYYMMDD')
	And Rownum = 1;
	
If icnt = 1 Then	
	Select curr
	  Into :scurr
	  From VNDDAN
	 Where cvcod = :scvcod
		And itnbr = :sitnbr
		And start_date               <= To_Char(Sysdate,'YYYYMMDD')
		And Nvl(end_date,'99999999') >= To_Char(Sysdate,'YYYYMMDD');
Else
	Select curr
	  Into :scurr
	  From VNDDAN
	 Where cvcod = :scvcod
		And itnbr = :sitnbr
		And end_date  = (Select Max(End_date)
                    	    From VNDDAN
                      	Where cvcod = :scvcod
                     	  And itnbr = :sitnbr
		                    And End_date <= To_Char(Sysdate,'YYYYMMDD'));	
End If				

Choose Case sCol_Name
   	case "itnbr"
	/* ��ȹ���� ������ ǥ�شܰ��� ���� ��ȹ�ݾ��� ������� */
   	Case "qty1","qty2","qty3","qty4","qty5","qty6","qty7","qty8","qty9"
		lQty = Long(GetText())
//		lDan = this.GetItemNumber(lRow, 'danamt')
//		lAmt = lQty * lDan
		
		//����ȯ�������Ͽ� ��ȭ �ݾ� ����
		lDan = sqlca.erp000000090_1(sYymm, sitnbr, scurr, dprice, '2')
		
		IF IsNull(lDan) Then 
          lDan = 0
		END IF	
		
		lAmt   = lQty * lDan       //��ȭ
		lAmt   = Truncate(lAmt , 2) 
    	lAmt_u = lQty * dprice     //��ȭ
		lAmt_u = Truncate(lAmt_u , 2) 
		
		scolumn_nm = 'amt' + right(sCol_Name,1)
		this.SetItem(lRow, scolumn_nm, lAmt)		
		
		sPlanYYmm = dw_jogun.GetItemString(1,'syy') + String(Integer(Mid(sCol_Name,4)),'00')
		sItnbr = GetItemString(lRow,'itnbr')
      
		nRow = dw_update.Find( "plan_yymm = '" + sPlanYYmm + "' and itnbr = '" + sItnbr + "'",1,dw_update.Rowcount())
		If nRow <= 0 Then	
			nRow = dw_update.InsertRow(0)
			dw_update.SetItem(nRow, 'sabu', gs_sabu)
			dw_update.SetItem(nRow, 'plan_yymm', sPlanYYmm)
			dw_update.SetItem(nRow, 'plan_chasu',is_chasu)
			dw_update.SetItem(nRow, 'cvcod',is_cvcod)
			dw_update.SetItem(nRow, 'itnbr',sItnbr)
		End If
		
		SetItem(lRow, 'amt'+ String(Integer(Mid(sCol_Name,4))) , lAmt)
		dw_update.SetItem(nRow, 'plan_qty', lQty)
		dw_update.SetItem(nRow, 'plan_amt', lAmt)
		dw_update.SetItem(nRow, 'plan_amt_u', lAmt_u)
	Case "qty10","qty11","qty12"
		lQty = Long(GetText())
//		lDan = this.GetItemNumber(lRow, 'danamt')
//		lAmt = lQty * lDan
		
		//����ȯ�������Ͽ� ��ȭ �ݾ� ����
		lDan = sqlca.erp000000090_1(sYymm, sitnbr, scurr, dprice, '2')
		
		IF IsNull(lDan) Then 
          lDan = 0
		END IF	
		
		lAmt   = lQty * lDan       //��ȭ
		lAmt   = Truncate(lAmt , 2) 
    	lAmt_u = lQty * dprice     //��ȭ
		lAmt_u = Truncate(lAmt_u , 2) 
		
		scolumn_nm = 'amt' + right(sCol_Name,2)
		this.SetItem(lRow, scolumn_nm, lAmt)		
		
		sPlanYYmm = dw_jogun.GetItemString(1,'syy') + String(Integer(Mid(sCol_Name,4)),'00')
		sItnbr = GetItemString(lRow,'itnbr')
      
		nRow = dw_update.Find( "plan_yymm = '" + sPlanYYmm + "' and itnbr = '" + sItnbr + "'",1,dw_update.Rowcount())
		If nRow <= 0 Then	
			nRow = dw_update.InsertRow(0)
			dw_update.SetItem(nRow, 'sabu', gs_sabu)
			dw_update.SetItem(nRow, 'plan_yymm', sPlanYYmm)
			dw_update.SetItem(nRow, 'plan_chasu',is_chasu)
			dw_update.SetItem(nRow, 'cvcod',is_cvcod)
			dw_update.SetItem(nRow, 'itnbr',sItnbr)
		End If
		
		SetItem(lRow, 'amt'+ String(Integer(Mid(sCol_Name,4))) , lAmt)
		dw_update.SetItem(nRow, 'plan_qty', lQty)
		dw_update.SetItem(nRow, 'plan_amt', lAmt)
		dw_update.SetItem(nRow, 'plan_amt_u', lAmt_u)	
End Choose

end event

event dw_insert::scrollhorizontal;//dw_hap.Object.DataWindow.HorizontalScrollPosition = scrollpos
end event

type p_delrow from w_inherite`p_delrow within w_sal_01040
boolean visible = false
integer x = 4151
integer y = 3196
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_sal_01040
boolean visible = false
integer x = 3977
integer y = 3196
integer taborder = 60
end type

type p_search from w_inherite`p_search within w_sal_01040
boolean visible = false
integer x = 3282
integer y = 3196
integer taborder = 180
end type

type p_ins from w_inherite`p_ins within w_sal_01040
integer x = 3749
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;str_yearsaplan str_plan
String sconfirm
Double dRtn

if dw_jogun.accepttext() = -1 then return -1

is_year  = Trim(dw_jogun.GetItemString(1, 'syy'))
is_chasu = dw_jogun.GetItemNumber(1, 'schasu')
is_cvcod = Trim(dw_jogun.GetItemString(1, 'cvcod'))

If (is_year = '') or isNull(is_year) or (is_chasu = 0) or isNull(is_chasu) or &
   (is_cvcod = '') or isNull(is_cvcod) then
	If (is_cvcod = '') or isNull(is_cvcod) then
		f_Message_Chk(203, '[�ŷ�ó �Է� Ȯ��]')
		dw_vnd.SetFocus()
	Else
   	f_Message_Chk(30, '[�ʼ��Է��ڷ� Ȯ��]')
	   dw_jogun.SetFocus()
	End If
	Return 1
End If

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from YEARSAPLAN_CONFIRM
 where Sabu         = :gs_sabu
   And Plan_yyyy    = :is_year
	And Plan_chasu   = :is_chasu; 

If sconfirm = 'Y' then
	MessageBox('�˸�', is_year + '��' + string(is_chasu) + '����'+ ' �Ⱓ �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	

w_mdi_frame.sle_msg.Text = '�Ⱓ �Ǹ� ��ȹ ǰ���߰� �۾��� �ϼ���'

str_plan.str_year = is_year
str_plan.str_chasu = is_chasu
str_plan.str_cvcod = is_cvcod
str_plan.str_cvnas2 = is_cvnas2
str_plan.str_series = is_series

openwithparm(w_sal_01040_01, str_plan)
dRtn = Message.DoubleParm 
If dRtn = -1 Then Return

If dw_update.Update() = -1 Then
 	Rollback;
   Return
Else
   Commit;
	ib_any_typing = False
End if

w_mdi_frame.sle_msg.Text = ''
p_inq.TriggerEvent(Clicked!)
dw_insert.scrolltorow(dw_insert.rowcount())
end event

type p_exit from w_inherite`p_exit within w_sal_01040
integer taborder = 160
end type

type p_can from w_inherite`p_can within w_sal_01040
integer taborder = 140
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
dw_update.Reset()

p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
p_create.enabled = true
p_create.PictureName = 'C:\erpman\image\�ڷ����_up.gif'

ib_any_typing = False

//st_4.visible 		= False
//dw_insert.visible = False
//rb_1.visible = false
//rb_2.visible = false
//rb_3.visible = false
//st_2.visible		= True
//dw_vnd.visible		= True
//dw_model.visible	= True

st_4.visible 		= True
dw_insert.visible = True
rb_1.visible = True
rb_2.visible = True
rb_3.visible = True

st_2.visible		= false
dw_vnd.visible		= false
dw_model.visible	= false

w_mdi_frame.sle_msg.Text = '������ ��ȹ�⵵ �� ���� ���ұ����� �Է� �� �����ϼ���'

dw_Jogun.SetFocus()
end event

type p_print from w_inherite`p_print within w_sal_01040
boolean visible = false
integer x = 3456
integer y = 3196
integer taborder = 200
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\����óǰ����_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\����óǰ����_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_01040
integer x = 3575
integer taborder = 20
end type

event p_inq::clicked;String  sYear, sjYear, scvcod
Integer iChasu

SetPointer(hourGlass!)

rb_1.checked = true
rb_2.checked = false
rb_3.checked = false
w_mdi_frame.sle_msg.Text = '�ش� �Ⱓ �Ǹ� ��ȹ�� ��ȸ�� �Դϴ�... ��� ��ٷ� �ּ���'
If dw_Jogun.AcceptText() <> 1 Then Return

sYear  = dw_Jogun.GetItemString(1, 'syy')
sjYear = String(integer(sYear) - 1)
iChasu = dw_Jogun.GetItemNumber(1, 'sChasu')
scvcod = dw_Jogun.GetItemString(1, 'cvcod')

If isnull( scvcod ) or trim( scvcod ) = '' then
	MessageBox("�ŷ�ó", "�ŷ�ó�ڵ带 ���� �Է��ϼ���", stopsign!)
	dw_jogun.SetColumn("cvcod")
	dw_jogun.SetFocus()
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

dw_update.Reset()
If dw_Insert.Retrieve(gs_sabu, sYear, iChasu, is_cvcod, f_today(), sjYear, gs_saupj) < 1 then
	f_message_Chk(50, '[�Ⱓ �Ǹ� ��ȹ ��ȸ]')
	w_mdi_frame.sle_msg.text = ''
End if

dw_update.Retrieve(gs_sabu, sYear, iChasu, is_cvcod)

p_ins.enabled = True
p_ins.PictureName = 'C:\erpman\image\�߰�_up.gif'
p_del.enabled = True
p_del.PictureName = 'C:\erpman\image\����_up.gif'
p_mod.enabled = True
p_mod.PictureName = 'C:\erpman\image\����_up.gif'
p_create.enabled = false
p_create.PictureName = 'C:\erpman\image\�ڷ����_d.gif'

st_4.visible 		= true
dw_insert.visible = true
rb_1.visible = true
rb_2.visible = true
rb_3.visible = true
rb_1.triggerevent(clicked!)
st_2.visible		= False
dw_vnd.visible		= False
dw_model.visible	= False

w_mdi_frame.sle_msg.Text = '�Ⱓ �Ǹ� ��ȹ ��ȸ �Ϸ�. ���� �� �߰�, ������ �� �� �ֽ��ϴ�.'

dw_Insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_sal_01040
integer taborder = 120
end type

event p_del::clicked;call super::clicked;string sitnbr, sitdsc,sconfirm

If dw_insert.AcceptText() <> 1 Then Return
if dw_jogun.accepttext() <> 1 Then Return

is_year  = Trim(dw_jogun.GetItemString(1, 'syy'))
is_chasu = dw_jogun.GetItemNumber(1, 'schasu')
is_cvcod = Trim(dw_jogun.GetItemString(1, 'cvcod'))

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from YEARSAPLAN_CONFIRM
 where Sabu       = :gs_sabu
   And Plan_yyyy  = :is_year
	And Plan_chasu = :is_chasu; 

If sconfirm = 'Y' then
	MessageBox('�˸�', is_year + '��' + string(is_chasu) + '����'+ ' �Ⱓ �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	

If dw_insert.GetRow() <= 0 Then Return

sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itdsc')

if MessageBox("���� Ȯ��", sitdsc + "�� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return

/* �Ⱓ�ǸŰ�ȹ �ش�⵵�� �ŷ�ó�� ǰ�� ����Ÿ ���� */
Delete From yearsaplan
Where (sabu = :gs_sabu) and (substr(plan_yymm,1,4) = :is_Year) and
      (plan_chasu = :is_chasu) and (cvcod = :is_cvcod) and
		(itnbr = :sitnbr);

if SQLCA.SqlCode < 0 then
   f_Message_Chk(31, '[�Ⱓ�ǸŰ�ȹ �ŷ�ó,ǰ�� ����]')
	Rollback;
	return
else
   commit;
	ib_any_typing = False
end if

p_inq.TriggerEvent(Clicked!)


end event

type p_mod from w_inherite`p_mod within w_sal_01040
integer taborder = 90
end type

event p_mod::clicked;call super::clicked;String sconfirm
Long   l_cnt

SetPointer(HourGlass!)

if dw_jogun.accepttext() <> 1 Then Return 1
If dw_update.AcceptText() <> 1 Then Return 1

is_year  = Trim(dw_jogun.GetItemString(1, 'syy'))
is_chasu = dw_jogun.GetItemNumber(1, 'schasu')
is_cvcod = Trim(dw_jogun.GetItemString(1, 'cvcod'))

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from YEARSAPLAN_CONFIRM
 where Sabu       = :gs_sabu
   and Plan_yyyy  = :is_year
	and Plan_chasu = :is_chasu; 

If sconfirm = 'Y' then
	MessageBox('�˸�', is_year + '��' + string(is_chasu) + '����'+ ' �Ⱓ �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	


/* Ȯ�� �ڷ�(YEARSAPLAN_CONFIRM ���̺�) Insert & Update */
select count(*)
  into :l_cnt
  from YEARSAPLAN_CONFIRM
 where Sabu       = :gs_sabu
   and Plan_yyyy  = :is_year
   and Plan_chasu = :is_chasu;
	
If l_cnt = 0 Then
	Insert Into YEARSAPLAN_CONFIRM
	       ( Sabu, Plan_yyyy, Plan_chasu, Maflag)
	   Values
		    ( :gs_sabu, :is_year, :is_chasu, 'N');
End If	
		
if dw_update.Update() = -1 then  
   f_message_Chk(32,'[�Ⱓ�ǸŰ�ȹ �����۾�]')
 	Rollback;
   SetPointer(Arrow!)	 
   return
else	
   Commit;		
   f_message_Chk(202,'[�Ⱓ�ǸŰ�ȹ �����۾�]')
	ib_any_typing = False
end if
SetPointer(Arrow!)	 

p_inq.TriggerEvent(Clicked!)

wf_dwvnd()
end event

type cb_exit from w_inherite`cb_exit within w_sal_01040
integer x = 3369
integer y = 3132
integer width = 352
integer taborder = 270
end type

type cb_mod from w_inherite`cb_mod within w_sal_01040
integer x = 2583
integer y = 3132
integer width = 370
integer taborder = 130
end type

event cb_mod::clicked;call super::clicked;//SetPointer(HourGlass!)
//If dw_update.AcceptText() <> 1 Then Return 1
//
//if dw_update.Update() = -1 then  
//   f_message_Chk(32,'[�Ⱓ�ǸŰ�ȹ �����۾�]')
// 	Rollback;
//   SetPointer(Arrow!)	 
//   return
//else
//   Commit;		
//   f_message_Chk(202,'[�Ⱓ�ǸŰ�ȹ �����۾�]')
//	ib_any_typing = False
//end if
//SetPointer(Arrow!)	 
//
//cb_can.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_sal_01040
integer x = 2459
integer y = 2820
integer taborder = 100
end type

type cb_del from w_inherite`cb_del within w_sal_01040
integer x = 1015
integer y = 3132
integer width = 393
integer taborder = 170
end type

event cb_del::clicked;call super::clicked;//string sitnbr, sitdsc
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//If dw_insert.GetRow() <= 0 Then Return
//
//sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
//sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itdsc')
//
//if MessageBox("���� Ȯ��", sitdsc + "�� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return
//
///* �Ⱓ�ǸŰ�ȹ �ش�⵵�� �ŷ�ó�� ǰ�� ����Ÿ ���� */
//Delete From yearsaplan
//Where (sabu = :gs_sabu) and (substr(plan_yymm,1,4) = :is_Year) and
//      (plan_chasu = :is_chasu) and (cvcod = :is_cvcod) and
//		(itnbr = :sitnbr);
//
//if SQLCA.SqlCode < 0 then
//   f_Message_Chk(31, '[�Ⱓ�ǸŰ�ȹ �ŷ�ó,ǰ�� ����]')
//	Rollback;
//	return
//else
//   commit;
//	ib_any_typing = False
//end if
//
//cb_inq.TriggerEvent(Clicked!)
//
//
end event

type cb_inq from w_inherite`cb_inq within w_sal_01040
integer x = 183
integer y = 3132
integer width = 393
integer taborder = 190
end type

event cb_inq::clicked;call super::clicked;//String  sYear, sjYear
//Integer iChasu
//
//SetPointer(hourGlass!)
//
//sle_msg.Text = '�ش� �Ⱓ �Ǹ� ��ȹ�� ��ȸ�� �Դϴ�... ��� ��ٷ� �ּ���'
//If dw_Jogun.AcceptText() <> 1 Then Return
//
//sYear  = dw_Jogun.GetItemString(1, 'syy')
//sjYear = String(integer(sYear) - 1)
//iChasu = dw_Jogun.GetItemNumber(1, 'sChasu')
//
//cb_add.enabled = True
//cb_del.enabled = True
//
//dw_update.Reset()
//If dw_Insert.Retrieve(gs_sabu, sYear, iChasu, is_cvcod, f_today(), sjYear) < 1 then
//	f_message_Chk(50, '[�Ⱓ �Ǹ� ��ȹ ��ȸ]')
//	sle_msg.text = ''
//	return -1
//End if
//
//dw_update.Retrieve(gs_sabu, sYear, iChasu, is_cvcod)
//
//sle_msg.Text = '�Ⱓ �Ǹ� ��ȹ ��ȸ �Ϸ�. ���� �� �߰�, ������ �� �� �ֽ��ϴ�.'
//
//dw_Insert.SetFocus()
//
end event

type cb_print from w_inherite`cb_print within w_sal_01040
integer x = 2473
integer y = 2692
integer taborder = 210
end type

type st_1 from w_inherite`st_1 within w_sal_01040
end type

type cb_can from w_inherite`cb_can within w_sal_01040
integer x = 2981
integer y = 3132
integer width = 361
integer taborder = 250
end type

event cb_can::clicked;call super::clicked;//dw_insert.Reset()
//dw_update.Reset()
//
//cb_add.enabled = False
//cb_del.enabled = False
//ib_any_typing = False
//
//sle_msg.Text = '������ ��ȹ�⵵ �� ���� ���ұ����� �Է� �� �����ϼ���'
//
//dw_Jogun.SetFocus()
end event

type cb_search from w_inherite`cb_search within w_sal_01040
integer x = 2414
integer y = 2556
integer taborder = 260
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01040
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01040
end type

type dw_vnd from datawindow within w_sal_01040
boolean visible = false
integer x = 69
integer y = 356
integer width = 2208
integer height = 1924
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_sal_01040_02"
boolean vscrollbar = true
boolean livescroll = true
end type

event clicked;// ���õ�(CLICK) ROW�� �Ķ������� ǥ��
if row <= 0 then
	dw_Vnd.SelectRow(0,False)
	return 1
else 
   dw_Vnd.SelectRow(0,False)
   dw_Vnd.SelectRow(row,true)
end if


w_mdi_frame.sle_msg.Text = ''
is_cvcod = dw_Vnd.GetItemString(row, 'cvcod')
is_cvnas2 = dw_Vnd.GetItemString(row, 'cvnas2')
dw_jogun.setitem(1, "cvcod", is_cvcod)
dw_jogun.setitem(1, "cvnas", is_cvnas2)


String syear, ssaupj
Long   lchasu

sYear 	= dw_jogun.getitemstring(1, "syy")
lchasu	= dw_jogun.getitemnumber(1, "schasu")
sSaupj   = dw_jogun.getitemstring(1, "saupj")

If IsNull( sSaupj ) or Trim( sSaupj ) =  '' then
	sSaupj = '%'
End if


dw_model.retrieve(gs_sabu, syear, lchasu, ssaupj, is_cvcod)

return 1
end event

event doubleclicked;p_inq.triggerevent(clicked!)
end event

type st_4 from statictext within w_sal_01040
boolean visible = false
integer x = 69
integer y = 272
integer width = 1243
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
boolean enabled = false
string text = " ��ǰ�� �Ⱓ �ǸŰ�ȹ ����"
boolean focusrectangle = false
end type

type dw_jogun from u_key_enter within w_sal_01040
event ue_key pbm_dwnkey
integer x = 41
integer y = 40
integer width = 2885
integer height = 196
integer taborder = 50
string dataobject = "d_sal_01040_01"
boolean border = false
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(Rbuttondown!)
End if
end event

event itemchanged;String sCol_Name, sNull, mm_chk, sData, sName, sName1
integer ii
long    ll_max

dw_Jogun.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)
//cb_inq.Enabled = False
//p_ins.Enabled = False
//p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.Enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.Enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
dw_insert.Reset()

Choose Case sCol_Name
   // ���س⵵ ��ȿ�� Check
	Case "syy"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 4) then
			f_Message_Chk(35, '[���س⵵]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		is_year = this.GetText()
		//Max������ �⺻���� ����
		select max(plan_chasu) into :ll_max
		  from YearSaPlan where substr(plan_yymm,1,4) = :is_year ;
		if sqlca.sqlcode = 0 then
			this.SetItem(1,"schasu",ll_max)
		end if	
		
		wf_dwvnd()
	Case "schasu"
		is_chasu = this.GetItemNumber(1, "schasu")		
		wf_dwvnd()		
	// �����
	Case "saupj"
		sData = gettext()		
		sName = f_get_reffer('AD', sData)
		If IsNull( sName )  then
			MessageBox("�����", "������� ����Ȯ�մϴ�", stopsign!)
			setitem(1, "saupj", sNull)
			wf_dwvnd()
			return 1
		Else
			wf_dwvnd()			
		End if
	// ���ұ��� ����Ŭ���� �ش� ���ұ����� �ŷ�ó�� ����(dw_vnd) 
	Case "ssarea"
		sData = gettext()
		ii = f_get_name2("���ұ���", 'Y', sdata, sname, sname1)
		if ii = 1 then
			setitem(1, "ssarea", sNull)
			wf_dwvnd()
			return 1
		Else
			wf_dwvnd()			
		End if
	// �ŷ�ó���
	Case "cvcod"
		sData = gettext()
		ii = f_get_name2("V1", 'Y', sdata, sname, sname1)
		if ii = 0 then
			setitem(1, "cvnas", sName)
			is_cvcod = sData
		Else
			setitem(1, "cvcod", sNull)
			setitem(1, "cvnas", sNull)
			return 1
		End if		
end Choose
end event

event itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;String sEmpId, sSaupj

SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'cvcod', gs_code)
		TriggerEvent(ItemChanged!)
END Choose

end event

type gb_3 from groupbox within w_sal_01040
boolean visible = false
integer x = 2551
integer y = 3084
integer width = 1202
integer height = 176
integer taborder = 230
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_update from datawindow within w_sal_01040
boolean visible = false
integer x = 50
integer y = 912
integer width = 2953
integer height = 440
integer taborder = 150
boolean bringtotop = true
string dataobject = "d_sal_01040_04"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_add from commandbutton within w_sal_01040
boolean visible = false
integer x = 599
integer y = 3132
integer width = 393
integer height = 108
integer taborder = 280
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�߰�(&A)"
end type

event cb_add::clicked;call super::clicked;//str_yearsaplan str_plan
//Double dRtn
//
//If (is_year = '') or isNull(is_year) or (is_chasu = 0) or isNull(is_chasu) or &
//   (is_cvcod = '') or isNull(is_cvcod) then
//	If (is_cvcod = '') or isNull(is_cvcod) then
//		f_Message_Chk(203, '[�ŷ�ó �Է� Ȯ��]')
//		dw_vnd.SetFocus()
//	Else
//   	f_Message_Chk(30, '[�ʼ��Է��ڷ� Ȯ��]')
//	   dw_jogun.SetFocus()
//	End If
//	Return 1
//End If
//
//sle_msg.Text = '�Ⱓ �Ǹ� ��ȹ ǰ���߰� �۾��� �ϼ���'
//
//str_plan.str_year = is_year
//str_plan.str_chasu = is_chasu
//str_plan.str_cvcod = is_cvcod
//str_plan.str_cvnas2 = is_cvnas2
//str_plan.str_series = is_series
//
//openwithparm(w_sal_01040_01, str_plan)
//dRtn = Message.DoubleParm 
//If dRtn = -1 Then Return
//
//If dw_update.Update() = -1 Then
// 	Rollback;
//   Return
//Else
//   Commit;
//	ib_any_typing = False
//End if
//
//sle_msg.Text = ''
//cb_inq.TriggerEvent(Clicked!)
//dw_insert.scrolltorow(dw_insert.rowcount())
end event

type st_2 from statictext within w_sal_01040
integer x = 69
integer y = 272
integer width = 1243
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
boolean enabled = false
string text = "�ŷ�ó�� �ǸŰ�ȹ"
boolean focusrectangle = false
end type

type dw_model from datawindow within w_sal_01040
boolean visible = false
integer x = 2304
integer y = 360
integer width = 2208
integer height = 1924
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sal_01040_02_01"
boolean vscrollbar = true
boolean livescroll = true
end type

type rb_1 from radiobutton within w_sal_01040
integer x = 887
integer y = 276
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "���"
boolean checked = true
end type

event clicked;dw_insert.Modify("DataWindow.Header.Height=152")	
dw_insert.Modify("DataWindow.Detail.Height=72")

end event

type rb_2 from radiobutton within w_sal_01040
integer x = 1175
integer y = 276
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "��1"
end type

event clicked;dw_insert.Modify("DataWindow.Header.Height=224")	
dw_insert.Modify("DataWindow.Detail.Height=144")

end event

type rb_3 from radiobutton within w_sal_01040
integer x = 1486
integer y = 276
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "��2"
end type

event clicked;dw_insert.Modify("DataWindow.Header.Height=300")	
dw_insert.Modify("DataWindow.Detail.Height=220")


end event

type p_create from uo_picture within w_sal_01040
boolean visible = false
integer x = 3401
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\�ڷ����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ڷ����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ڷ����_up.gif"
end event

event clicked;call super::clicked;gs_code = dw_jogun.getitemstring(1, "syy")
gi_page = dw_jogun.getitemnumber(1, "schasu")

If isnull( gs_code ) or trim( gs_code ) = '' then
	MessageBox("���س⵵", "���س⵵�� �Է��ϼ���", stopsign!)
	Setnull(gs_code)
	SetNull(gi_page)
	return 
end if

If isnull( gi_page ) or gi_page = 0 then
	MessageBox("��ȹ����", "��ȹ������ �Է��ϼ���", stopsign!)
	Setnull(gs_code)
	SetNull(gi_page)	
	return 
end if

open(w_sal_01037_1)

integer ii

ii = message.doubleparm
if ii = 1 then
	wf_dwvnd()
end if
end event

type dw_hidden from datawindow within w_sal_01040
boolean visible = false
integer x = 9
integer y = 20
integer width = 1317
integer height = 168
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_itmbuy_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_1 from uo_picture within w_sal_01040
boolean visible = false
integer x = 3086
integer y = 24
integer width = 306
integer taborder = 220
boolean bringtotop = true
string picturename = "C:\erpman\image\����óǰ����_up.gif"
end type

event clicked;call super::clicked;//����ó ǰ����	-���ϸ�
string scvcod, ls_saupj, sopt, sitem
int    k, lRow
Decimal {5} ddata

IF dw_jogun.AcceptText() = -1	THEN	RETURN

ls_Saupj = dw_jogun.GetItemString(1, "saupj"   )
sCvcod 	= dw_jogun.getitemstring(1, "cvcod"  )

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[�Ǹ�ó]')
	dw_jogun.SetColumn("cvcod")
	dw_jogun.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code = sCvcod
open(w_itmbuy_popup2)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		lRow = dw_insert.insertrow(0)

      sitem = 	dw_hidden.getitemstring(k, 'itmbuy_itnbr' )
		dw_insert.setitem(lRow, 'itnbr'    , sitem)
		dw_insert.setitem(lRow, 'itdsc'    , dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lRow, 'ispec'    , dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lRow, 'jijil'    , dw_hidden.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lRow, 'man_itnbr', dw_hidden.getitemstring(k, 'itmbuy_budsc' ))
		ddata = wf_calc_danga(lRow, sitem, 0)		
		dw_insert.Setitem(lRow, 'danamt',  ddata)
	end if	
NEXT

dw_hidden.reset()
st_4.visible 		= true
dw_insert.visible = true
rb_1.visible = true
rb_2.visible = true
rb_3.visible = true
dw_insert.ScrollToRow(lRow)
dw_insert.setrow(lRow)
dw_insert.SetColumn("qty1")
dw_insert.SetFocus()


end event

type gb_2 from groupbox within w_sal_01040
boolean visible = false
integer x = 155
integer y = 3084
integer width = 1294
integer height = 176
integer taborder = 240
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_2 from roundrectangle within w_sal_01040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 256
integer width = 4539
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

