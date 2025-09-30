$PBExportHeader$w_sal_01010.srw
$PBExportComments$ ===> ���ұ����� ����ǸŰ�ȹ ������ ��� �� ����
forward
global type w_sal_01010 from w_inherite
end type
type gb_3 from groupbox within w_sal_01010
end type
type gb_kkk from groupbox within w_sal_01010
end type
type gb_2 from groupbox within w_sal_01010
end type
type dw_jogun from datawindow within w_sal_01010
end type
type dw_copy from datawindow within w_sal_01010
end type
type st_gubun from statictext within w_sal_01010
end type
type dw_update from u_key_enter within w_sal_01010
end type
type rr_1 from roundrectangle within w_sal_01010
end type
end forward

global type w_sal_01010 from w_inherite
integer width = 4768
integer height = 2488
string title = "���ұ����� ����ǸŰ�ȹ ������ ��� �� ����"
gb_3 gb_3
gb_kkk gb_kkk
gb_2 gb_2
dw_jogun dw_jogun
dw_copy dw_copy
st_gubun st_gubun
dw_update dw_update
rr_1 rr_1
end type
global w_sal_01010 w_sal_01010

type variables
string is_year
end variables

on w_sal_01010.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_kkk=create gb_kkk
this.gb_2=create gb_2
this.dw_jogun=create dw_jogun
this.dw_copy=create dw_copy
this.st_gubun=create st_gubun
this.dw_update=create dw_update
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_kkk
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_jogun
this.Control[iCurrent+5]=this.dw_copy
this.Control[iCurrent+6]=this.st_gubun
this.Control[iCurrent+7]=this.dw_update
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_kkk)
destroy(this.gb_2)
destroy(this.dw_jogun)
destroy(this.dw_copy)
destroy(this.st_gubun)
destroy(this.dw_update)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;//*****************************************************************************//
//***  PGM NAME : ���ұ����� ����ǸŰ�ȹ ������ ��� �� ����               ***//
//***  PGM ID   : W_SAL_01010                                               ***//
//***  SUBJECT  : ���ұ������� ����ǸŰ�ȹ ������ ���� �����⵵ ����       ***//
//***             5����ġ�� �������� ����Ѵ�.                              ***//
//***             ���� ���� 5������ �ڷḦ Display�Ͽ� �����ϰ�,            ***//
//***             ������ ��Ͽ� ���� �ǸŰ�ȹ�ݾ��� �ڵ� ���ȴ�.          ***//
//*****************************************************************************//
dw_Jogun.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_Update.Settransobject(sqlca)
dw_Copy.Settransobject(sqlca)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_01010
integer y = 252
integer width = 4494
integer height = 2036
string dataobject = "d_sal_01010"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

type p_delrow from w_inherite`p_delrow within w_sal_01010
boolean visible = false
integer x = 4142
integer y = 3252
end type

type p_addrow from w_inherite`p_addrow within w_sal_01010
boolean visible = false
integer x = 3968
integer y = 3252
end type

type p_search from w_inherite`p_search within w_sal_01010
boolean visible = false
integer x = 3273
integer y = 3252
end type

type p_ins from w_inherite`p_ins within w_sal_01010
boolean visible = false
integer x = 3794
integer y = 3252
end type

type p_exit from w_inherite`p_exit within w_sal_01010
end type

type p_can from w_inherite`p_can within w_sal_01010
end type

event p_can::clicked;call super::clicked;dw_Jogun.Reset()
dw_Insert.Reset()
dw_Update.Reset()
dw_copy.Reset()

dw_Jogun.Insertrow(0)
dw_Insert.Insertrow(0)
dw_Update.Insertrow(0)
dw_Copy.Insertrow(0)

st_gubun.Text = ''
p_Del.Enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'

w_mdi_frame.sle_msg.Text = '�����⵵�� �Է��ϼ���'

dw_Jogun.SetColumn("sales_yy")
dw_jogun.SetFocus()
end event

type p_print from w_inherite`p_print within w_sal_01010
boolean visible = false
integer x = 3447
integer y = 3252
end type

type p_inq from w_inherite`p_inq within w_sal_01010
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String  sSaleYY, sMonth
Integer cnt, iMonth

if dw_jogun.AcceptText() < 1 then return

sSaleYY = dw_jogun.GetItemString(1, 'sales_yy')
if sSaleYY = '' or isNull(sSaleYY) then
	f_Message_Chk(35, '[�����⵵]')
   dw_Jogun.SetColumn("sales_yy")
	dw_jogun.SetFocus()
end if

if (Not(isNumber(Trim(is_Year)))) or (Len(Trim(is_Year)) <> 4) then
	f_Message_Chk(35, '[�����⵵]')
   dw_Jogun.SetColumn("sales_yy")
	dw_jogun.SetFocus()
	return 1
end if
		
sMonth = Mid(f_today(),5,2)
iMonth = Integer(sMonth)

// �����⵵�� ����ǸŰ�ȹ�� �����ϴ��� Check
Select Count(*) into :cnt From LongPlanSarea
Where sabu = :gs_sabu and setup_Year = :is_Year;

if (cnt = 0) or isNull(cnt) then
	// �������� ������ �ű� ���� DataWindow�� Visible
	MessageBox('Ȯ ��', '�ش� �����⵵�� ����ǸŰ�ȹ ��������' + '~r' + &
	                    '�űԷ� ����ϼ���')
	st_gubun.Text = '�ű԰�ȹ���'
   dw_Insert.Visible = True
	dw_Update.Visible = False
			
	SetPointer(HourGlass!)
	dw_Insert.Retrieve(gs_sabu, is_year, sMonth, iMonth)//�Է¿� DW
	dw_Copy.Retrieve(gs_sabu, is_year) // ��Ͽ� DW
	SetPointer(Arrow!)			

	p_Del.Enabled = False
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
	w_mdi_frame.sle_msg.Text = '������ ��ȹ�� ����ϼ���'
  	dw_Insert.SetFocus()
else
	// �����ϸ� �ش� �ڷḦ Retrieve�ϰ� Update DataWindow�� Visible
	MessageBox('Ȯ ��', '�ش� �����⵵�� ����ǸŰ�ȹ ������ ��ȹ��' + '~r' + &
	                    '�̹� �����Ǿ� �ֽ��ϴ�' + '~r~r' + &
							  '������ ��ȹ�� ������ �� �ֽ��ϴ�.')
	st_gubun.Text = '������ȹ����'			

   dw_Insert.Visible = False
	dw_Update.Visible = True			
			
	SetPointer(HourGlass!)
	dw_Update.Retrieve(gs_sabu, is_year) // ������ DW
	SetPointer(Arrow!)		
			
	p_Del.Enabled = True
	p_del.PictureName = 'C:\erpman\image\����_up.gif'
	w_mdi_frame.sle_msg.Text = '������ ��ȹ�� �����ϼ���'			
  	dw_Update.SetFocus()
end if				

end event

type p_del from w_inherite`p_del within w_sal_01010
end type

event p_del::clicked;call super::clicked;Beep (1)

if MessageBox("���� Ȯ��", "�ش� �����⵵�� ����ǸŰ�ȹ��" + "~r~r" + &
                           "�ϰ� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return

// ���ұ����� ����ǸŰ�ȹ �ش�⵵ ����Ÿ ����
Delete From LongPlanSarea
Where (sabu = :gs_sabu) and (Setup_Year = :is_Year);

if SQLCA.SqlCode < 0 then
   f_Message_Chk(31, '[����ǸŰ�ȹ����]')
	Rollback;
	return
else
   commit;
	ib_any_typing = False
end if

p_can.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sal_01010
end type

event p_mod::clicked;call super::clicked;Integer i
String  s_sabu, s_setup, s_sarea
Double  l_amt1, l_amt2, l_amt3, l_amt4, l_amt5, l_amt6, l_amt7, l_amt8, l_amt9, l_amt10
Long    l_cnt1, l_cnt2, l_cnt3, l_cnt4, l_cnt5, l_cnt6, l_cnt7, l_cnt8, l_cnt9, l_cnt10
Dec     d_rat1, d_rat2, d_rat3, d_rat4, d_rat5, d_rat6, d_rat7, d_rat8, d_rat9, d_rat10

if dw_Insert.Visible then
   // �ű� ��ȹ ������ ��� �Է¿� DW(dw_insert)�� ������ ��Ͽ� DW(dw_copy)���� ����
   dw_Insert.AcceptText()
	dw_copy.reset()

   FOR i = 1 TO dw_Insert.RowCount()
      s_sabu  = dw_Insert.GetItemString(i, 'sabu')
	   s_setup = dw_Insert.GetItemString(i, 'setup_year')
      s_sarea = dw_Insert.GetItemString(i, 'sarea')
	   l_amt1  = dw_Insert.GetItemNumber(i, 'sales_amt_1')
	   l_amt2  = dw_Insert.GetItemNumber(i, 'sales_amt_2')
	   l_amt3  = dw_Insert.GetItemNumber(i, 'sales_amt_3')
	   l_amt4  = dw_Insert.GetItemNumber(i, 'sales_amt_4')
	   l_amt5  = dw_Insert.GetItemNumber(i, 'sales_amt_5')
	   l_amt6  = dw_Insert.GetItemNumber(i, 'sales_amt_6')
	   l_amt7  = dw_Insert.GetItemNumber(i, 'sales_amt_7')
	   l_amt8  = dw_Insert.GetItemNumber(i, 'sales_amt_8')
	   l_amt9  = dw_Insert.GetItemNumber(i, 'sales_amt_9')
	   l_amt10 = dw_Insert.GetItemDecimal(i, 'sales_amt_10')
	   d_rat1  = dw_Insert.GetItemDecimal(i, 'incr_rate_1')
	   d_rat2  = dw_Insert.GetItemDecimal(i, 'incr_rate_2')
	   d_rat3  = dw_Insert.GetItemDecimal(i, 'incr_rate_3')
	   d_rat4  = dw_Insert.GetItemDecimal(i, 'incr_rate_4')
	   d_rat5  = dw_Insert.GetItemDecimal(i, 'incr_rate_5')
	   d_rat6  = dw_Insert.GetItemDecimal(i, 'incr_rate_6')
	   d_rat7  = dw_Insert.GetItemDecimal(i, 'incr_rate_7')
	   d_rat8  = dw_Insert.GetItemDecimal(i, 'incr_rate_8')
	   d_rat9  = dw_Insert.GetItemDecimal(i, 'incr_rate_9')
	   d_rat10 = dw_Insert.GetItemDecimal(i, 'incr_rate_10')
//	   l_cnt1  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_1')	 
//	   l_cnt2  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_2')
//	   l_cnt3  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_3')
//	   l_cnt4  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_4')
//	   l_cnt5  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_5')
//	   l_cnt6  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_6')
//	   l_cnt7  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_7')
//	   l_cnt8  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_8')
//	   l_cnt9  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_9')
//	   l_cnt10 = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_10')
		
	   dw_Copy.setredraw(false)	 
      dw_Copy.InsertRow(i)
	   dw_Copy.SetItem(i, 'sabu', s_sabu)
	   dw_Copy.SetItem(i, 'setup_year', s_setup)
	   dw_Copy.SetItem(i, 'sarea', s_sarea)
	   dw_Copy.SetItem(i, 'sales_amt_1', l_amt1)
	   dw_Copy.SetItem(i, 'sales_amt_2', l_amt2)
	   dw_Copy.SetItem(i, 'sales_amt_3', l_amt3)
	   dw_Copy.SetItem(i, 'sales_amt_4', l_amt4)
	   dw_Copy.SetItem(i, 'sales_amt_5', l_amt5)
	   dw_Copy.SetItem(i, 'sales_amt_6', l_amt6)
	   dw_Copy.SetItem(i, 'sales_amt_7', l_amt7)
	   dw_Copy.SetItem(i, 'sales_amt_8', l_amt8)
	   dw_Copy.SetItem(i, 'sales_amt_9', l_amt9)
	   dw_Copy.SetItem(i, 'sales_amt_10', l_amt10)
	   dw_Copy.SetItem(i, 'incr_rate_1', d_rat1)
	   dw_Copy.SetItem(i, 'incr_rate_2', d_rat1)
	   dw_Copy.SetItem(i, 'incr_rate_3', d_rat3)
	   dw_Copy.SetItem(i, 'incr_rate_4', d_rat4)
	   dw_Copy.SetItem(i, 'incr_rate_5', d_rat5)
	   dw_Copy.SetItem(i, 'incr_rate_6', d_rat6)
	   dw_Copy.SetItem(i, 'incr_rate_7', d_rat7)
	   dw_Copy.SetItem(i, 'incr_rate_8', d_rat8)
	   dw_Copy.SetItem(i, 'incr_rate_9', d_rat9)
	   dw_Copy.SetItem(i, 'incr_rate_10', d_rat10)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_1', l_cnt1)	 
	   dw_Copy.SetItem(i, 'sales_emp_cnt_2', l_cnt2)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_3', l_cnt3)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_4', l_cnt4)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_5', l_cnt5)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_6', l_cnt6)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_7', l_cnt7)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_8', l_cnt8)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_9', l_cnt9)
	   dw_Copy.SetItem(i, 'sales_emp_cnt_10', l_cnt10)	 
	   dw_Copy.setredraw(true)	 
   NEXT

   dw_Copy.AcceptText()
   if dw_Copy.Update() = -1 then  
      f_message_Chk(32, '[����ǸŰ�ȹ ��������]')
    	Rollback;
		ib_any_typing = False
      return
   else
      Commit;	
		ib_any_typing = False
      f_message_Chk(202, '[����ǸŰ�ȹ ��������]')
   end if
else
	// �����۾��� 
   dw_Update.AcceptText()
   if dw_Update.Update() = -1 then  
      f_message_Chk(32, '[����ǸŰ�ȹ ��������]')
    	Rollback;
		ib_any_typing = False
      return
   else
      Commit;		
		ib_any_typing = False
      f_message_Chk(202, '[����ǸŰ�ȹ ��������]')
   end if	
end if

p_can.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sal_01010
integer x = 3337
integer y = 2676
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_01010
integer x = 2245
integer y = 2676
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;//Integer i
//String  s_sabu, s_setup, s_sarea
//Double  l_amt1, l_amt2, l_amt3, l_amt4, l_amt5, l_amt6, l_amt7, l_amt8, l_amt9, l_amt10
//Long    l_cnt1, l_cnt2, l_cnt3, l_cnt4, l_cnt5, l_cnt6, l_cnt7, l_cnt8, l_cnt9, l_cnt10
//Dec     d_rat1, d_rat2, d_rat3, d_rat4, d_rat5, d_rat6, d_rat7, d_rat8, d_rat9, d_rat10
//
//if dw_Insert.Visible then
//   // �ű� ��ȹ ������ ��� �Է¿� DW(dw_insert)�� ������ ��Ͽ� DW(dw_copy)���� ����
//   dw_Insert.AcceptText()
//	dw_copy.reset()
//
//   FOR i = 1 TO dw_Insert.RowCount()
//      s_sabu  = dw_Insert.GetItemString(i, 'sabu')
//	   s_setup = dw_Insert.GetItemString(i, 'setup_year')
//      s_sarea = dw_Insert.GetItemString(i, 'sarea')
//	   l_amt1  = dw_Insert.GetItemNumber(i, 'sales_amt_1')
//	   l_amt2  = dw_Insert.GetItemNumber(i, 'sales_amt_2')
//	   l_amt3  = dw_Insert.GetItemNumber(i, 'sales_amt_3')
//	   l_amt4  = dw_Insert.GetItemNumber(i, 'sales_amt_4')
//	   l_amt5  = dw_Insert.GetItemNumber(i, 'sales_amt_5')
//	   l_amt6  = dw_Insert.GetItemNumber(i, 'sales_amt_6')
//	   l_amt7  = dw_Insert.GetItemNumber(i, 'sales_amt_7')
//	   l_amt8  = dw_Insert.GetItemNumber(i, 'sales_amt_8')
//	   l_amt9  = dw_Insert.GetItemNumber(i, 'sales_amt_9')
//	   l_amt10 = dw_Insert.GetItemDecimal(i, 'sales_amt_10')
//	   d_rat1  = dw_Insert.GetItemDecimal(i, 'incr_rate_1')
//	   d_rat2  = dw_Insert.GetItemDecimal(i, 'incr_rate_2')
//	   d_rat3  = dw_Insert.GetItemDecimal(i, 'incr_rate_3')
//	   d_rat4  = dw_Insert.GetItemDecimal(i, 'incr_rate_4')
//	   d_rat5  = dw_Insert.GetItemDecimal(i, 'incr_rate_5')
//	   d_rat6  = dw_Insert.GetItemDecimal(i, 'incr_rate_6')
//	   d_rat7  = dw_Insert.GetItemDecimal(i, 'incr_rate_7')
//	   d_rat8  = dw_Insert.GetItemDecimal(i, 'incr_rate_8')
//	   d_rat9  = dw_Insert.GetItemDecimal(i, 'incr_rate_9')
//	   d_rat10 = dw_Insert.GetItemDecimal(i, 'incr_rate_10')
////	   l_cnt1  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_1')	 
////	   l_cnt2  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_2')
////	   l_cnt3  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_3')
////	   l_cnt4  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_4')
////	   l_cnt5  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_5')
////	   l_cnt6  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_6')
////	   l_cnt7  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_7')
////	   l_cnt8  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_8')
////	   l_cnt9  = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_9')
////	   l_cnt10 = dw_Insert.GetItemNumber(i, 'sales_emp_cnt_10')
//		
//	   dw_Copy.setredraw(false)	 
//      dw_Copy.InsertRow(i)
//	   dw_Copy.SetItem(i, 'sabu', s_sabu)
//	   dw_Copy.SetItem(i, 'setup_year', s_setup)
//	   dw_Copy.SetItem(i, 'sarea', s_sarea)
//	   dw_Copy.SetItem(i, 'sales_amt_1', l_amt1)
//	   dw_Copy.SetItem(i, 'sales_amt_2', l_amt2)
//	   dw_Copy.SetItem(i, 'sales_amt_3', l_amt3)
//	   dw_Copy.SetItem(i, 'sales_amt_4', l_amt4)
//	   dw_Copy.SetItem(i, 'sales_amt_5', l_amt5)
//	   dw_Copy.SetItem(i, 'sales_amt_6', l_amt6)
//	   dw_Copy.SetItem(i, 'sales_amt_7', l_amt7)
//	   dw_Copy.SetItem(i, 'sales_amt_8', l_amt8)
//	   dw_Copy.SetItem(i, 'sales_amt_9', l_amt9)
//	   dw_Copy.SetItem(i, 'sales_amt_10', l_amt10)
//	   dw_Copy.SetItem(i, 'incr_rate_1', d_rat1)
//	   dw_Copy.SetItem(i, 'incr_rate_2', d_rat1)
//	   dw_Copy.SetItem(i, 'incr_rate_3', d_rat3)
//	   dw_Copy.SetItem(i, 'incr_rate_4', d_rat4)
//	   dw_Copy.SetItem(i, 'incr_rate_5', d_rat5)
//	   dw_Copy.SetItem(i, 'incr_rate_6', d_rat6)
//	   dw_Copy.SetItem(i, 'incr_rate_7', d_rat7)
//	   dw_Copy.SetItem(i, 'incr_rate_8', d_rat8)
//	   dw_Copy.SetItem(i, 'incr_rate_9', d_rat9)
//	   dw_Copy.SetItem(i, 'incr_rate_10', d_rat10)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_1', l_cnt1)	 
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_2', l_cnt2)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_3', l_cnt3)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_4', l_cnt4)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_5', l_cnt5)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_6', l_cnt6)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_7', l_cnt7)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_8', l_cnt8)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_9', l_cnt9)
//	   dw_Copy.SetItem(i, 'sales_emp_cnt_10', l_cnt10)	 
//	   dw_Copy.setredraw(true)	 
//   NEXT
//
//   dw_Copy.AcceptText()
//   if dw_Copy.Update() = -1 then  
//      f_message_Chk(32, '[����ǸŰ�ȹ ��������]')
//    	Rollback;
//		ib_any_typing = False
//      return
//   else
//      Commit;	
//		ib_any_typing = False
//      f_message_Chk(202, '[����ǸŰ�ȹ ��������]')
//   end if
//else
//	// �����۾��� 
//   dw_Update.AcceptText()
//   if dw_Update.Update() = -1 then  
//      f_message_Chk(32, '[����ǸŰ�ȹ ��������]')
//    	Rollback;
//		ib_any_typing = False
//      return
//   else
//      Commit;		
//		ib_any_typing = False
//      f_message_Chk(202, '[����ǸŰ�ȹ ��������]')
//   end if	
//end if
//
//cb_can.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_sal_01010
integer x = 1861
integer y = 2828
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_sal_01010
integer x = 2610
integer y = 2676
integer taborder = 100
end type

event cb_del::clicked;call super::clicked;//Beep (1)
//
//if MessageBox("���� Ȯ��", "�ش� �����⵵�� ����ǸŰ�ȹ��" + "~r~r" + &
//                           "�ϰ� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return
//
//// ���ұ����� ����ǸŰ�ȹ �ش�⵵ ����Ÿ ����
//Delete From LongPlanSarea
//Where (sabu = :gs_sabu) and (Setup_Year = :is_Year);
//
//if SQLCA.SqlCode < 0 then
//   f_Message_Chk(31, '[����ǸŰ�ȹ����]')
//	Rollback;
//	return
//else
//   commit;
//	ib_any_typing = False
//end if
//
//cb_can.TriggerEvent(Clicked!)
end event

type cb_inq from w_inherite`cb_inq within w_sal_01010
integer x = 128
integer y = 2676
integer taborder = 110
end type

event cb_inq::clicked;call super::clicked;//String  sSaleYY, sMonth
//Integer cnt, iMonth
//
//if dw_jogun.AcceptText() < 1 then return
//
//sSaleYY = dw_jogun.GetItemString(1, 'sales_yy')
//if sSaleYY = '' or isNull(sSaleYY) then
//	f_Message_Chk(35, '[�����⵵]')
//   dw_Jogun.SetColumn("sales_yy")
//	dw_jogun.SetFocus()
//end if
//
//if (Not(isNumber(Trim(is_Year)))) or (Len(Trim(is_Year)) <> 4) then
//	f_Message_Chk(35, '[�����⵵]')
//   dw_Jogun.SetColumn("sales_yy")
//	dw_jogun.SetFocus()
//	return 1
//end if
//		
//sMonth = Mid(f_today(),5,2)
//iMonth = Integer(sMonth)
//
//// �����⵵�� ����ǸŰ�ȹ�� �����ϴ��� Check
//Select Count(*) into :cnt From LongPlanSarea
//Where sabu = :gs_sabu and setup_Year = :is_Year;
//
//if (cnt = 0) or isNull(cnt) then
//	// �������� ������ �ű� ���� DataWindow�� Visible
//	MessageBox('Ȯ ��', '�ش� �����⵵�� ����ǸŰ�ȹ ��������' + '~r' + &
//	                    '�űԷ� ����ϼ���')
//	st_gubun.Text = '�ű԰�ȹ���'
//   dw_Insert.Visible = True
//	dw_Update.Visible = False
//			
//	SetPointer(HourGlass!)
//	dw_Insert.Retrieve(gs_sabu, is_year, sMonth, iMonth)//�Է¿� DW
//	dw_Copy.Retrieve(gs_sabu, is_year) // ��Ͽ� DW
//	SetPointer(Arrow!)			
//
//	cb_Del.Enabled = False
//	sle_msg.Text = '������ ��ȹ�� ����ϼ���'
//  	dw_Insert.SetFocus()
//else
//	// �����ϸ� �ش� �ڷḦ Retrieve�ϰ� Update DataWindow�� Visible
//	MessageBox('Ȯ ��', '�ش� �����⵵�� ����ǸŰ�ȹ ������ ��ȹ��' + '~r' + &
//	                    '�̹� �����Ǿ� �ֽ��ϴ�' + '~r~r' + &
//							  '������ ��ȹ�� ������ �� �ֽ��ϴ�.')
//	st_gubun.Text = '������ȹ����'			
//
//   dw_Insert.Visible = False
//	dw_Update.Visible = True			
//			
//	SetPointer(HourGlass!)
//	dw_Update.Retrieve(gs_sabu, is_year) // ������ DW
//	SetPointer(Arrow!)		
//			
//	cb_Del.Enabled = True
//	sle_msg.Text = '������ ��ȹ�� �����ϼ���'			
//  	dw_Update.SetFocus()
//end if				
//
end event

type cb_print from w_inherite`cb_print within w_sal_01010
integer x = 2944
integer y = 2828
integer taborder = 120
end type

type st_1 from w_inherite`st_1 within w_sal_01010
end type

type cb_can from w_inherite`cb_can within w_sal_01010
integer x = 2971
integer y = 2676
integer taborder = 130
end type

event cb_can::clicked;call super::clicked;dw_Jogun.Reset()
dw_Insert.Reset()
dw_Update.Reset()
dw_copy.Reset()

dw_Jogun.Insertrow(0)
dw_Insert.Insertrow(0)
dw_Update.Insertrow(0)
dw_Copy.Insertrow(0)

st_gubun.Text = ''
cb_Del.Enabled = False

sle_msg.Text = '�����⵵�� �Է��ϼ���'

dw_Jogun.SetColumn("sales_yy")
dw_jogun.SetFocus()
end event

type cb_search from w_inherite`cb_search within w_sal_01010
integer x = 3310
integer y = 2828
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01010
integer x = 864
integer y = 3428
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01010
integer x = 1710
integer y = 3456
end type

type gb_3 from groupbox within w_sal_01010
boolean visible = false
integer x = 96
integer y = 2632
integer width = 402
integer height = 168
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_kkk from groupbox within w_sal_01010
boolean visible = false
integer x = 1810
integer y = 2808
integer width = 407
integer height = 184
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_sal_01010
boolean visible = false
integer x = 2213
integer y = 2632
integer width = 1499
integer height = 168
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_jogun from datawindow within w_sal_01010
integer x = 64
integer y = 52
integer width = 1449
integer height = 176
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_01010_01"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if This.GetColumnName() = 'sales_yy' then
	is_year = this.GetText()
	p_inq.TriggerEvent(Clicked!)
end if
//String sCol_Name, sNull, sYear, sMonth
//Integer cnt, iMonth
//
//dw_Jogun.AcceptText()
//sCol_Name = This.GetColumnName()
//SetNull(sNull)
//
//Choose Case sCol_Name
//   // �����⵵ ��ȿ�� Check
//	Case "sales_yy"  
//		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 4) then
//			f_Message_Chk(35, '[�����⵵]')
//			this.SetItem(1, "sales_yy", sNull)
//			return 1
//		end if
//		
//		sYear = this.GetText()
//		sMonth = Mid(f_today(),5,2)
//		iMonth = Integer(sMonth)
//		// �����⵵�� ����ǸŰ�ȹ�� �����ϴ��� Check
//		Select Count(*) into :cnt From LongPlanSarea
//		Where sabu = :gs_sabu and setup_Year = :sYear;
//
//		if (cnt = 0) or isNull(cnt) then
//			// �������� ������ �ű� ���� DataWindow�� Visible
//			MessageBox('Ȯ ��', '�ش� �����⵵�� ����ǸŰ�ȹ ��������' + '~r' + &
//			                    '�űԷ� ����ϼ���')
//			st_gubun.Text = '�ű԰�ȹ���'
//         dw_Insert.Visible = True
//			dw_Update.Visible = False
//			
//			SetPointer(HourGlass!)
//   		dw_Insert.Retrieve(gs_sabu, this.GetItemString(1, 'sales_yy'), sMonth, iMonth)//�Է¿� DW
//   		dw_Copy.Retrieve(gs_sabu, this.GetItemString(1, 'sales_yy')) // ��Ͽ� DW
//			SetPointer(Arrow!)			
//
//			cb_Del.Enabled = False
//			sle_msg.Text = '������ ��ȹ�� ����ϼ���'
//	   	dw_Insert.SetFocus()
//		else
//			// �����ϸ� �ش� �ڷḦ Retrieve�ϰ� Update DataWindow�� Visible
//			MessageBox('Ȯ ��', '�ش� �����⵵�� ����ǸŰ�ȹ ������ ��ȹ��' + '~r' + &
//			                    '�̹� �����Ǿ� �ֽ��ϴ�' + '~r~r' + &
//									  '������ ��ȹ�� ������ �� �ֽ��ϴ�.')
//			st_gubun.Text = '������ȹ����'			
//
//         dw_Insert.Visible = False
//			dw_Update.Visible = True			
//			
//			SetPointer(HourGlass!)
//   		dw_Update.Retrieve(gs_sabu, this.GetItemString(1, 'sales_yy')) // ������ DW
//			SetPointer(Arrow!)		
//			
//			cb_Del.Enabled = True
//			sle_msg.Text = '������ ��ȹ�� �����ϼ���'			
//	   	dw_Update.SetFocus()
//		end if				
//end Choose
end event

event itemerror;return 1
end event

type dw_copy from datawindow within w_sal_01010
boolean visible = false
integer x = 2661
integer y = 40
integer width = 357
integer height = 168
integer taborder = 160
boolean bringtotop = true
string dataobject = "d_sal_01010_03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_gubun from statictext within w_sal_01010
integer x = 965
integer y = 104
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 255
long backcolor = 15780518
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_update from u_key_enter within w_sal_01010
integer x = 82
integer y = 248
integer width = 4494
integer height = 2036
integer taborder = 20
string dataobject = "d_sal_01010_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event itemchanged;String sNull
Long   nRow
Dec{2} dRate, lAmt, lSalesAmt

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	Case "sales_amt_5"
		lAmt = Double(GetText())		
		If IsNull(lAmt) Then lAmt = 0

		dRate = GetItemDecimal(nRow, 'incr_rate_6')
		lSalesAmt = lAmt + lAmt * dRate / 100
		SetItem(nRow, 'sales_amt_6', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_7')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_7', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_8')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_8', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_9')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_9', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_10')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_10', lSalesAmt)		
		
	Case "incr_rate_6"
		dRate = Double(GetText())
		If IsNull(dRate) Then dRate = 0
		
		lAmt = GetItemNumber(nRow, 'sales_amt_5')
		lSalesAmt = lAmt + lAmt * dRate / 100
		SetItem(nRow, 'sales_amt_6', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_7')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_7', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_8')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_8', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_9')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_9', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_10')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_10', lSalesAmt)		
	Case "incr_rate_7"
		dRate = Double(GetText())
		If IsNull(dRate) Then dRate = 0
		
		lAmt = GetItemNumber(nRow, 'sales_amt_6')
		lSalesAmt = lAmt + lAmt * dRate / 100
		SetItem(nRow, 'sales_amt_7', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_8')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_8', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_9')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_9', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_10')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_10', lSalesAmt)		
		
	Case "incr_rate_8"
		dRate = Double(GetText())
		If IsNull(dRate) Then dRate = 0
		
		lAmt = GetItemNumber(nRow, 'sales_amt_7')
		lSalesAmt = lAmt + lAmt * dRate / 100
		SetItem(nRow, 'sales_amt_8', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_9')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_9', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_10')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_10', lSalesAmt)				
		
	Case "incr_rate_9"
		dRate = Double(GetText())
		If IsNull(dRate) Then dRate = 0
		
		lAmt = GetItemNumber(nRow, 'sales_amt_8')
		lSalesAmt = lAmt + lAmt * dRate / 100
		SetItem(nRow, 'sales_amt_9', lSalesAmt)
		
		dRate = GetItemDecimal(nRow, 'incr_rate_10')
		lSalesAmt = lSalesAmt + lSalesAmt * dRate / 100
		SetItem(nRow, 'sales_amt_10', lSalesAmt)
		
	Case "incr_rate_10"
		dRate = Double(GetText())
		If IsNull(dRate) Then dRate = 0
		
		lAmt = GetItemNumber(nRow, 'sales_amt_9')
		lSalesAmt = lAmt + lAmt * dRate / 100
		SetItem(nRow, 'sales_amt_10', lSalesAmt)
end Choose
end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_sal_01010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 240
integer width = 4521
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

