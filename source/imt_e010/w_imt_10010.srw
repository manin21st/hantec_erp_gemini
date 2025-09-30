$PBExportHeader$w_imt_10010.srw
$PBExportComments$ ===> �ְ� ���Ű�ȹ ����
forward
global type w_imt_10010 from w_inherite
end type
type dw_jogun from u_key_enter within w_imt_10010
end type
type gb_3 from groupbox within w_imt_10010
end type
type cb_add from commandbutton within w_imt_10010
end type
type p_create from uo_picture within w_imt_10010
end type
type dw_hidden from datawindow within w_imt_10010
end type
type p_1 from uo_picture within w_imt_10010
end type
type pb_1 from u_pb_cal within w_imt_10010
end type
type gb_2 from groupbox within w_imt_10010
end type
type rr_2 from roundrectangle within w_imt_10010
end type
end forward

global type w_imt_10010 from w_inherite
integer width = 4677
integer height = 2476
string title = "�ְ� ���� ��ȹ ����"
dw_jogun dw_jogun
gb_3 gb_3
cb_add cb_add
p_create p_create
dw_hidden dw_hidden
p_1 p_1
pb_1 pb_1
gb_2 gb_2
rr_2 rr_2
end type
global w_imt_10010 w_imt_10010

type variables
string is_ymd 
        
end variables

forward prototypes
public function integer wf_check_itnbr (integer lrow, string sitnbr)
public subroutine wf_clear_item (integer icurrow)
end prototypes

public function integer wf_check_itnbr (integer lrow, string sitnbr);String spl_yymm, sNull, sToday, sItdsc, sIspec, sJijil, scvcod, stuncu, scvnas, smatch
Decimal {2} dunprc
Long   cnt, frow

SetNull(sNull)

dw_insert.accepttext()

spl_yymm = dw_insert.GetItemString(lrow, "mtr_ymd")
sCvcod   = dw_insert.GetItemString(lrow, "cvcod")

/* �߰� ǰ���� �����ϴ��� ���� üũ */
Select count(*) Into :cnt From mtrpln_week
 Where sabu  = :gs_sabu and mtr_ymd = :is_ymd 
   and cvcod = :scvcod  and itnbr   = :sitnbr;
	
if cnt > 0 then
  	MessageBox("�ڷ� Ȯ��", "�ش� ǰ���� �ְ���ȹ�� �̹� �����մϴ�.")
	dw_insert.SetItem(lrow, "itnbr", sNull)
	dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
	dw_insert.SetItem(lrow, "itemas_ispec", sNull)
	dw_insert.SetItem(lrow, "itemas_jijil", sNull)
	dw_insert.setitem(lrow, "wonprc",       0)
  	return 1			
end if 

sMatch = scvcod + sitnbr

frow = dw_insert.find("match_case = '"+ smatch +"'", 0, dw_insert.rowcount())
if frow > 0 and frow <> lrow then
  	MessageBox("�ڷ� Ȯ��", "�ش� ǰ���� �ְ���ȹ�� �̹� �����մϴ�." + '~n' + &
	  								"Row-No -> " + String(Frow))
	dw_insert.SetItem(lrow, "itnbr", sNull)
	dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
	dw_insert.SetItem(lrow, "itemas_ispec", sNull)
	dw_insert.SetItem(lrow, "itemas_jijil", sNull)
	dw_insert.setitem(lrow, "wonprc",       0)
  	return 1			
end if	

sToday = f_today()
//*****************************************************************************
Select itnbr, itdsc, ispec, jijil Into :sitnbr, :sitdsc, :sispec, :sJijil From itemas
 Where (itnbr = :sitnbr) and (useyn = '0');
//*****************************************************************************
if SQLCA.SQLCODE <> 0  then
   open(w_itemas_popup)
	sitnbr = gs_code 
	sitdsc = gs_codename 
	sispec = gs_gubun			
end if
//*****************************************************************************
dw_insert.SetItem(lrow, "itnbr", sNull)
dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
dw_insert.SetItem(lrow, "itemas_ispec", sNull)
dw_insert.SetItem(lrow, "itemas_jijil", sNull)
dw_insert.SetItem(lrow, "wonprc", 0)
	
if sitnbr = '' Or IsNull(sitnbr) Then Return 1	

/* �ܰ� */
f_buy_unprc(sitnbr, '.' ,  '9999', sCvcod, sCvnas, dUnprc, sTuncu)

If IsNull(dunprc) Then dunprc = 0
dw_insert.SetItem(lrow, "wonprc", dUnprc)
		
dw_insert.SetItem(lrow, "itnbr", sitnbr)
dw_insert.SetItem(lrow, "itemas_itdsc", sitdsc)		  
dw_insert.SetItem(lrow, "itemas_ispec", sispec)
dw_insert.SetItem(lrow, "itemas_jijil", sJijil)




Return 0
end function

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"wonprc",   		   0)


end subroutine

on w_imt_10010.create
int iCurrent
call super::create
this.dw_jogun=create dw_jogun
this.gb_3=create gb_3
this.cb_add=create cb_add
this.p_create=create p_create
this.dw_hidden=create dw_hidden
this.p_1=create p_1
this.pb_1=create pb_1
this.gb_2=create gb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_jogun
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.cb_add
this.Control[iCurrent+4]=this.p_create
this.Control[iCurrent+5]=this.dw_hidden
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.rr_2
end on

on w_imt_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_jogun)
destroy(this.gb_3)
destroy(this.cb_add)
destroy(this.p_create)
destroy(this.dw_hidden)
destroy(this.p_1)
destroy(this.pb_1)
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

//// ���Ŵ����
//datawindowchild state_child1
//integer rtncode
//
//rtncode = dw_jogun.GetChild('empno', state_child1)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ����")
//state_child1.SetTransObject(SQLCA)
//state_child1.Retrieve("1", "1", gs_saupj)


/*����庰 ���Ŵ���� ���� */
f_child_saupj(dw_jogun, "empno", gs_saupj)

dw_Jogun.SetTransObject(sqlca)
dw_Insert.Settransobject(sqlca)

dw_Jogun.Insertrow(0)

p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'

/* �ΰ� ����� */
f_mod_saupj(dw_jogun,"saupj")

w_mdi_frame.sle_msg.Text = '������ ��ȹ�⵵ �� ���� ���ұ����� �Է� �� �����ϼ���'

dw_Jogun.SetFocus()
end event

event open;call super::open;PostEvent('ue_open')
end event

type dw_insert from w_inherite`dw_insert within w_imt_10010
integer x = 64
integer y = 352
integer width = 4544
integer height = 1932
integer taborder = 10
string dataobject = "d_imt_10010_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;String sCol_Name
Long   lrow

sCol_Name = GetColumnName()
lrow = GetRow()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
	// ǰ���ڵ� ����Ʈ�� Right ����Ŭ���� Popup ȭ��
	Case "itnbr", "itemas_itdsc", "itemas_ispec", "itemas_jijil"
   	Open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"itnbr",gs_code)
		
		triggerevent(Itemchanged!)
		Return 1
	Case "cvcod"
   	Open(w_vndmst_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"cvcod",gs_code)
		
		triggerevent(Itemchanged!)
		Return 1		
End Choose

end event

event dw_insert::itemchanged;call super::itemchanged;String sNull, sitnbr, stoday, sitdsc, sispec, spl_yymm, sJijil, sispeccode, scvcod, semp_id, scvnas, scvgu
Long lRow, lQty, cnt, lPqty
Dec  dDan, ddanga, dIncrRate, lAmt

lRow = GetRow()
If lRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()

	/* ǰ�� */
	Case "itnbr"
      sitnbr = Trim(GetText())
      If IsNull(sitnbr) Or sitnbr = '' Then			Return 1
		
		wf_check_itnbr(lrow, sItnbr)
		Return 1
	Case  "itemas_itdsc"                   // ǰ���Է½�
		sitdsc = Trim(GetText())

		/* ǰ������ ǰ��ã�� */
		f_get_name4_sale('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		

		wf_check_itnbr(lrow, sItnbr)
   Case  "itemas_ispec"                   // �԰��Է½�
	   sispec = Trim(GetText())

		f_get_name4_sale('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		
		wf_check_itnbr(lrow, sItnbr)		
   Case  "itemas_jijil"                   // �԰��Է½�
	   sJijil = Trim(GetText())
		f_get_name4_sale('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		
		wf_check_itnbr(lrow, sItnbr)
   Case  "cvcod" 
		scvcod = gettext()
		Select cvgu, cvnas2, emp_id into :scvgu, :scvnas, :semp_id
		  From vndmst
		 Where cvcod = :scvcod;
		If sqlca.sqlcode <> 0  or (scvgu <> '1' and scvgu <> '2' and scvgu <> '9') then
			Setitem(Lrow, "cvcod",  sNull)
			Setitem(Lrow, "cvnas2", sNull)
			Setitem(Lrow, "emp_id", sNull)
			MessageBox("�ŷ�ó", "�ŷ�ó�ڵ尡 ����Ȯ�մϴ�", stopsign!)
			return 1
		End if
		Setitem(Lrow, "cvnas2", scvnas)
		Setitem(Lrow, "emp_id", semp_id)
		
		sitnbr = getitemstring(Lrow, "itnbr")
		if not isnull( sitnbr ) or trim( sitnbr ) = '' then
			wf_check_itnbr(lrow, sItnbr)
		End if
End Choose 
end event

event dw_insert::updatestart;call super::updatestart;long i
String ls_mtrymd, ls_cvcod, ls_itnbr

For i =1 to this.RowCount()
	If this.GetItemString(i, 'opt') ='Y' Then
		ls_mtrymd	=this.GetItemString(i,'mtr_ymd' )
		ls_cvcod		=this.GetItemString(i, 'cvcod')
		ls_itnbr		=this.GetItemString(i, 'itnbr')
	
		Delete MTRPLN_WEEK
		Where  sabu = :gs_sabu
		and    mtr_ymd = :ls_mtrymd
		and    cvcod   = :ls_cvcod
		and    itnbr   = :ls_itnbr;
		
		If sqlca.sqlcode = 0 then
			Commit;
		End If	
	End If
Next
end event

type p_delrow from w_inherite`p_delrow within w_imt_10010
boolean visible = false
integer x = 4151
integer y = 3196
end type

type p_addrow from w_inherite`p_addrow within w_imt_10010
boolean visible = false
integer x = 3977
integer y = 3196
end type

type p_search from w_inherite`p_search within w_imt_10010
boolean visible = false
integer x = 3282
integer y = 3196
end type

type p_ins from w_inherite`p_ins within w_imt_10010
integer x = 3749
end type

event p_ins::clicked;call super::clicked;long lrow

If (is_ymd = '') or isNull(is_ymd) Then
  	f_Message_Chk(30, '[���� Ȯ��]')
   dw_jogun.SetFocus()
	Return 1
End If


Lrow = dw_insert.insertrow(0)
dw_insert.setitem(Lrow, "sabu", gs_sabu)
dw_insert.setitem(Lrow, "mtr_ymd", is_ymd)
dw_insert.setitem(Lrow, "weekhist", f_today())
dw_insert.scrolltorow(Lrow)
dw_insert.setcolumn("cvcod")
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_imt_10010
end type

type p_can from w_inherite`p_can within w_imt_10010
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

 
p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
p_create.enabled = true
p_create.PictureName = 'C:\erpman\image\��������Ƿ�_up.gif'

ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''


f_child_saupj(dw_jogun, "empno", gs_saupj)
f_mod_saupj(dw_jogun, 'saupj')

dw_Jogun.SetFocus()
end event

type p_print from w_inherite`p_print within w_imt_10010
boolean visible = false
integer x = 3456
integer y = 3196
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\����óǰ����_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\����óǰ����_up.gif"
end event

type p_inq from w_inherite`p_inq within w_imt_10010
integer x = 3575
end type

event p_inq::clicked;String  sYmd, scvcod, sitnbr1, sitnbr2, sempno, ssaupj

SetPointer(hourGlass!)

w_mdi_frame.sle_msg.Text = '�ְ� ���� ��ȹ�� ��ȸ�� �Դϴ�... ��� ��ٷ� �ּ���'
If dw_Jogun.AcceptText() <> 1 Then Return

ssaupj  = dw_Jogun.GetItemString(1, 'saupj')
sYmd    = dw_Jogun.GetItemString(1, 'symd')
scvcod  = dw_Jogun.GetItemString(1, 'cvcod')
sempno  = dw_Jogun.GetItemString(1, 'empno')
sitnbr1 = dw_Jogun.GetItemString(1, 'itnbr1')
sitnbr2 = dw_Jogun.GetItemString(1, 'itnbr2')

is_ymd = symd

If isnull( symd ) or trim( symd ) = '' then
	MessageBox("��������", "�������ڸ� ���� �Է��ϼ���", stopsign!)
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

If isnull( scvcod ) or trim( scvcod ) = '' then
	scvcod = '%'
End if

If isnull( sitnbr1 ) or trim( sitnbr1 ) = '' then
	sitnbr1 = '.'
End if

If isnull( sitnbr2 ) or trim( sitnbr2 ) = '' then
	sitnbr2 = 'zzzzzzzzzzzz'
End if

If isnull( sempno )  or trim( sempno ) = '' then
	sempno  = '%'
End if

If dw_Insert.Retrieve(gs_sabu, sYmd, scvcod, sitnbr1, sitnbr2, sempno, ssaupj) < 1 then
	f_message_Chk(50, '[�ְ� ���� ��ȹ ��ȸ]')
	w_mdi_frame.sle_msg.text = ''
End if

p_ins.enabled = True
p_ins.PictureName = 'C:\erpman\image\�߰�_up.gif'
p_del.enabled = True
p_del.PictureName = 'C:\erpman\image\����_up.gif'
p_mod.enabled = True
p_mod.PictureName = 'C:\erpman\image\����_up.gif'
p_create.enabled = false
p_create.PictureName = 'C:\erpman\image\��������Ƿ�_up.gif'

w_mdi_frame.sle_msg.Text = '�ְ� ���� ��ȹ ��ȸ �Ϸ�. ���� �� �߰�, ������ �� �� �ֽ��ϴ�.'

dw_Insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_imt_10010
end type

event p_del::clicked;call super::clicked;string sitnbr, sitdsc

If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.GetRow() <= 0 Then Return

sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itemas_itdsc')

if MessageBox("���� Ȯ��", sitdsc + "�� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return

dw_insert.deleterow(dw_insert.getrow())


end event

type p_mod from w_inherite`p_mod within w_imt_10010
end type

event p_mod::clicked;call super::clicked;long lcnt, i
SetPointer(HourGlass!)
If dw_insert.AcceptText() <> 1 Then Return 1

FOR i = 1 to dw_insert.RowCount()
	dw_insert.SetItem(i, 'sabu', gs_sabu)
NEXT

if dw_insert.Update() = -1 then  
   f_message_Chk(32,'[�ְ����Ű�ȹ �����۾�]')
 	Rollback;
   SetPointer(Arrow!)	 
   return
else
	
	LCNT = sqlca.van_weekplan4(gs_sabu, is_ymd, gs_saupj, '%', '3');		
	
   Commit;		
   f_message_Chk(202,'[�ְ����Ű�ȹ �����۾�]')
	ib_any_typing = False
end if
SetPointer(Arrow!)	 

p_can.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_imt_10010
integer x = 3369
integer y = 3132
integer width = 352
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_imt_10010
integer x = 2583
integer y = 3132
integer width = 370
integer taborder = 60
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

type cb_ins from w_inherite`cb_ins within w_imt_10010
integer x = 2459
integer y = 2820
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_imt_10010
integer x = 1015
integer y = 3132
integer width = 393
integer taborder = 80
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

type cb_inq from w_inherite`cb_inq within w_imt_10010
integer x = 183
integer y = 3132
integer width = 393
integer taborder = 90
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

type cb_print from w_inherite`cb_print within w_imt_10010
integer x = 2473
integer y = 2692
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_imt_10010
end type

type cb_can from w_inherite`cb_can within w_imt_10010
integer x = 2981
integer y = 3132
integer width = 361
integer taborder = 130
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

type cb_search from w_inherite`cb_search within w_imt_10010
integer x = 2414
integer y = 2556
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_10010
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_10010
end type

type dw_jogun from u_key_enter within w_imt_10010
event ue_key pbm_dwnkey
integer x = 41
integer y = 4
integer width = 2441
integer height = 280
integer taborder = 20
string dataobject = "d_imt_10010_01"
boolean border = false
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(Rbuttondown!)
End if
end event

event itemchanged;String sCol_Name, sNull, mm_chk, sData, sName, sName1
integer ii

dw_Jogun.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)
//cb_inq.Enabled = False
p_ins.Enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.Enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.Enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
dw_insert.Reset()

String  s_cod, s_nam1, s_nam2
Integer i_rtn
Long ll

s_cod = Trim(this.GetText())

if this.GetColumnName() = "symd" then //��������
   if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[��������]")
	   this.object.symd[1] = ""
	   return 1
   end if
   
	select Count(*) into :ll
	  from mtrpln_week a
	 where a.sabu = :gs_sabu and a.mtr_ymd = :s_cod;

	if sqlca.sqlcode <> 0 or ll < 1 or IsNull(ll) then
		messagebox("�ְ����Ű�ȹ", "�ְ����Ű�ȹ�� ã�� �� �����ϴ�!", stopsign!)
	end if	
elseif this.getcolumnname() = 'cvcod' then 
	s_cod = this.gettext()
	
	i_rtn = f_get_name2("V1", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod[1] = s_cod
	this.object.cvname[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr1' then 
	s_cod = this.gettext()
	i_rtn = f_get_name2("ǰ��", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1]  = s_cod
//	this.object.itdsc1[1]  = s_nam1
	return i_rtn 
elseif this.getcolumnname() = 'itnbr2' then 
	s_cod = this.gettext()
	i_rtn = f_get_name2("ǰ��", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1]  = s_cod
//	this.object.itdsc2[1]  = s_nam1
	return i_rtn 
elseif GetColumnName() = 'saupj' THEN
	s_cod = GetText()
	/*����庰 ���Ŵ���� ���� */
	f_child_saupj(dw_jogun, "empno", s_cod)
	
end if

return

end event

event itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
if this.getcolumnname() = "itnbr1" then //ǰ��1
   gs_gubun ='3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr1[1] = gs_code
elseif this.getcolumnname() = "itnbr2" then //ǰ��2
   gs_gubun ='3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr2[1] = gs_code
elseif this.getcolumnname() = "cvcod"	then
   gs_gubun ='1'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvname", gs_codename)
end if	
end event

type gb_3 from groupbox within w_imt_10010
boolean visible = false
integer x = 2551
integer y = 3084
integer width = 1202
integer height = 176
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_add from commandbutton within w_imt_10010
boolean visible = false
integer x = 599
integer y = 3132
integer width = 393
integer height = 108
integer taborder = 160
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

type p_create from uo_picture within w_imt_10010
integer x = 3269
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\��������Ƿ�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��������Ƿ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��������Ƿ�_up.gif"
end event

event clicked;call super::clicked;gs_code = dw_jogun.getitemstring(1, "symd")

If isnull( gs_code ) or trim( gs_code ) = '' then
	MessageBox("��������", "�������ڸ� �Է��ϼ���", stopsign!)
	Setnull(gs_code)
	return 
end if

open(w_imt_10010_01)
 


end event

type dw_hidden from datawindow within w_imt_10010
boolean visible = false
integer x = 50
integer y = 276
integer width = 1413
integer height = 480
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_vnditem_popup3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_1 from uo_picture within w_imt_10010
integer x = 2967
integer y = 24
integer width = 306
integer taborder = 100
boolean bringtotop = true
string picturename = "C:\erpman\image\����óǰ����_up.gif"
end type

event clicked;call super::clicked;//����ó ǰ����	-���ϸ�
string scvcod, symd, sopt, sempno, scvnas, sitem
int    k, lRow
Decimal {5} ddata, dan_prc

IF dw_jogun.AcceptText() = -1	THEN	RETURN

sCvcod = dw_jogun.getitemstring(1, "cvcod") /* �԰�ó   */
symd   = dw_jogun.getitemstring(1, "symd" ) /* �������� */

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[�ŷ�ó]')
	dw_jogun.SetColumn("cvcod")
	dw_jogun.SetFocus()
	RETURN
END IF

IF isnull(symd) or symd = "" 	THEN
	f_message_chk(30,'[��������]')
	dw_jogun.SetColumn("symd")
	dw_jogun.SetFocus()
	RETURN
END IF

/* �ŷ�ó �� & ��ü ���Ŵ����(�̵�Ͻ� '�麴������'��ȸ) */
SELECT "VNDMST"."CVNAS2", NVL("VNDMST"."EMP_ID", '870602')
 INTO :scvnas, :sempno
 FROM "VNDMST"  
WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code     = sCvcod
gs_gubun    = '1'
gs_codename = scvnas
open(w_vnditem_popup3)
if Isnull(gs_code)  or Trim(gs_code)  = "" then return
SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\����_up.gif"

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		lRow = dw_insert.insertrow(0)
		
      sitem = dw_hidden.getitemstring(k, 'poblkt_itnbr' )
		/* ���� �ܰ� ���� */
		Select Nvl(unprc, 1)
		  into :dan_prc
		  from danmst
		 Where itnbr = :sitem
		   and cvcod = :Scvcod
			and opseq = '9999'
		 Using sqlca;	

		dw_insert.SetItem(lrow, 'cvcod'       , Scvcod)
		dw_insert.SetItem(lrow, 'cvnas2'      , gs_codename)
		dw_insert.SetItem(lrow, 'emp_id'      , Sempno)
		dw_insert.setitem(lRow, 'itnbr'       , sitem)
		dw_insert.setitem(lRow, 'wonprc'      , dan_prc)
		dw_insert.setitem(lRow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lRow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lRow, 'itemas_jijil', dw_hidden.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lRow, 'mtr_ymd', symd)
		dw_insert.setitem(lRow, 'opt'      , 'Y')
	end if	
NEXT

dw_hidden.reset()
dw_insert.ScrollToRow(lRow)
dw_insert.setrow(lRow)
//dw_insert.SetColumn("outqty")
dw_insert.SetFocus()


end event

type pb_1 from u_pb_cal within w_imt_10010
integer x = 837
integer y = 84
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_jogun.SetColumn('symd')
IF IsNull(gs_code) THEN Return
ll_row = dw_jogun.GetRow()
If ll_row < 1 Then Return
dw_jogun.SetItem(ll_row, 'symd', gs_code)



end event

type gb_2 from groupbox within w_imt_10010
boolean visible = false
integer x = 155
integer y = 3084
integer width = 1294
integer height = 176
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_2 from roundrectangle within w_imt_10010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 328
integer width = 4594
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

