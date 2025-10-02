$PBExportHeader$w_sm10_0055_pt.srw
$PBExportComments$VAN���� ��Ʈ��VAN(�Ŀ��ػ����ڵ�)
forward
global type w_sm10_0055_pt from w_inherite
end type
type cb_1 from commandbutton within w_sm10_0055_pt
end type
type rb_1 from radiobutton within w_sm10_0055_pt
end type
type rb_2 from radiobutton within w_sm10_0055_pt
end type
type dw_1 from datawindow within w_sm10_0055_pt
end type
type pb_1 from u_pic_cal within w_sm10_0055_pt
end type
type rr_1 from roundrectangle within w_sm10_0055_pt
end type
end forward

global type w_sm10_0055_pt from w_inherite
string title = "�Ŀ��� VAN ����(�����ڵ�)"
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
pb_1 pb_1
rr_1 rr_1
end type
global w_sm10_0055_pt w_sm10_0055_pt

forward prototypes
public subroutine wf_day ()
public subroutine wf_week ()
end prototypes

public subroutine wf_day ();String ls_docname
String ls_named[]
Long   ll_value

//Excel IMPORT ***************************************************************

ll_value = GetFileOpenName("���� ��ǰ��ȹ Data ��������", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

If FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('Ȯ��','date_conv.xls'+' ������ �������� �ʽ��ϴ�.')
	Return
End If

uo_xlobject uo_xl
uo_xlobject uo_xltemp

uo_xltemp = Create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', False, 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1, 1, '@' + Space(30))

Long   ix
Long   ll_xl_row
Long   ll_r
Long   ll_cnt
Long   i
Long   ll_dqty, ll_dqtyold
Long   ll_find
String ls_file
String ls_gubun
String ls_name
String ls_dqty
String ls_bigo
String ls_ymd

ls_ymd = dw_input.GetItemString(1, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('������ Ȯ��', '�������� �ʼ� �׸� �Դϴ�.~r~n�������� �Է� �Ͻʽÿ�.')
	Return
End If

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('Ȯ��',ls_file+' ������ �������� �ʽ��ϴ�.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//������ ����
	uo_xl.uf_excel_connect(ls_file, false , 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data ���� Row Setting////
	ll_xl_row = 2
	///////////////////////////
	
	Do While(True)
		
		//Data�� ������쿣 Return...........
		If IsNull(uo_xl.uf_gettext(ll_xl_row, 2)) OR Trim(uo_xl.uf_gettext(ll_xl_row, 2)) = '' Then Exit
		 
		ll_cnt++
		
		dw_insert.ScrollToRow(ll_r)
		
		//Excel ��-Format ����
		For i = 1 To 10
			uo_xl.uf_set_format(ll_xl_row, i, '@' + Space(30))
		Next
		
		//////////////////////////////////////////////////////////////////////
		ls_gubun = Trim(uo_xl.uf_gettext(ll_xl_row, 2)) //�����ڵ�
		ls_dqty  = Trim(uo_xl.uf_gettext(ll_xl_row, 3)) //����
		
		ll_dqty  = Long(ls_dqty)
		//////////////////////////////////////////////////////////////////////
		w_mdi_frame.sle_msg.text = ls_gubun + ' / ' + String(ll_cnt) + '��'
		
		If IsNull(ls_gubun) OR Trim(ls_gubun) = '' Then
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Exit
		End If
		
		ll_find = dw_insert.FIND("cdate = '" + ls_ymd + "' and gubun = '" + ls_gubun + "'", 1, ll_cnt)
		
		If ll_find > 0 Then
			ll_dqtyold = dw_insert.GetItemNumber(ll_find, 'dqty')
			dw_insert.SetItem(ll_find, 'dqty', ll_dqty + ll_dqtyold)
		Else
			ll_r = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(ll_r, 'cdate' , ls_ymd  )
			dw_insert.SetItem(ll_r, 'gubun' , ls_gubun)
			dw_insert.SetItem(ll_r, 'dqty'  , ll_dqty )
		End If
		
		ll_xl_row++
		
		w_mdi_frame.sle_msg.text = ls_named[ix] + ' ������ ' + String(ll_xl_row) + '���� �а� �ֽ��ϴ�.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	//���� IMPORT END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

w_mdi_frame.sle_msg.text = '���������� ' + String(ll_cnt) + '���� Import �Ǿ����ϴ�.'

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('Import Success!', '�ڷᰡ ���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('Import Failure!', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
	Return
End If
end subroutine

public subroutine wf_week ();String ls_docname
String ls_named[]
Long   ll_value

//Excel IMPORT ***************************************************************

ll_value = GetFileOpenName("���� ��ǰ��ȹ Data ��������", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

If FileExists('date_conv.xls') = False Then
	MessageBox('Ȯ��','date_conv.xls'+' ������ �������� �ʽ��ϴ�.')
	Return
End If

uo_xlobject uo_xl
uo_xlobject uo_xltemp

uo_xltemp = Create uo_xlobject
uo_xltemp.uf_excel_connect('date_conv.xls', False, 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1, 1, '@' + Space(30))

Long   ix
Long   ll_xl_row
Long   ll_r
Long   ll_cnt
Long   i
Long   ll_d0, ll_d1, ll_d2, ll_d3, ll_d4, ll_d5, ll_d6, ll_d7, ll_d8, ll_d9, ll_d10, ll_d11
Long   ll_find
String ls_file
String ls_gubun
String ls_d0, ls_d1, ls_d2, ls_d3, ls_d4, ls_d5, ls_d6, ls_d7, ls_d8, ls_d9, ls_d10, ls_d11
String ls_ymd

ls_ymd = dw_input.GetItemString(1, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('������ Ȯ��', '�������� �ʼ� �׸� �Դϴ�.~r~n�������� �Է� �Ͻʽÿ�.')
	Return
End If

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('Ȯ��',ls_file+' ������ �������� �ʽ��ϴ�.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//������ ����
	uo_xl.uf_excel_connect(ls_file, false , 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data ���� Row Setting////
	ll_xl_row = 2
	///////////////////////////
	
	Do While(True)
		
		//Data�� ������쿣 Return...........
		If IsNull(uo_xl.uf_gettext(ll_xl_row, 2)) OR Trim(uo_xl.uf_gettext(ll_xl_row, 2)) = '' Then Exit
		
		ll_cnt++
		
		//Excel ��-Format ����
		For i = 1 To 10
			uo_xl.uf_set_format(ll_xl_row, i, '@' + Space(30))
		Next
		
		//////////////////////////////////////////////////////////////////////
		ls_gubun = Trim(uo_xl.uf_gettext(ll_xl_row, 2) ) //�����ڵ�
		ls_d0    = Trim(uo_xl.uf_gettext(ll_xl_row, 3) ) //D0����
		ls_d1    = Trim(uo_xl.uf_gettext(ll_xl_row, 4) ) //D1����
		ls_d2    = Trim(uo_xl.uf_gettext(ll_xl_row, 5) ) //D2����
		ls_d3    = Trim(uo_xl.uf_gettext(ll_xl_row, 6) ) //D3����
		ls_d4    = Trim(uo_xl.uf_gettext(ll_xl_row, 7) ) //D4����
		ls_d5    = Trim(uo_xl.uf_gettext(ll_xl_row, 8) ) //D5����
		ls_d6    = Trim(uo_xl.uf_gettext(ll_xl_row, 9) ) //D6����
		ls_d7    = Trim(uo_xl.uf_gettext(ll_xl_row, 10)) //D7����
		ls_d8    = Trim(uo_xl.uf_gettext(ll_xl_row, 11)) //D8����
		ls_d9    = Trim(uo_xl.uf_gettext(ll_xl_row, 12)) //D9����
		ls_d10   = Trim(uo_xl.uf_gettext(ll_xl_row, 13)) //D10����
		ls_d11   = Trim(uo_xl.uf_gettext(ll_xl_row, 14)) //D11����
				
		ll_d0   = Long(ls_d0)
		ll_d1   = Long(ls_d1)
		ll_d2   = Long(ls_d2)
		ll_d3   = Long(ls_d3)
		ll_d4   = Long(ls_d4)
		ll_d5   = Long(ls_d5)
		ll_d6   = Long(ls_d6)
		ll_d7   = Long(ls_d7)
		ll_d8   = Long(ls_d8)
		ll_d9   = Long(ls_d9)
		ll_d10  = Long(ls_d10)
		ll_d11  = Long(ls_d11)
		//////////////////////////////////////////////////////////////////////
		w_mdi_frame.sle_msg.text = ls_gubun + ' / ' + String(ll_cnt) + '��'
		
		If IsNull(ls_gubun) OR Trim(ls_gubun) = '' Then
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Exit
		End If
		
		ll_find = dw_insert.FIND("cdate = '" + ls_ymd + "' and gubun = '" + ls_gubun + "'", 1, ll_cnt)
		
		If ll_find > 0 Then			
			dw_insert.SetItem(ll_find, 'd0' , dw_insert.GetItemNumber(ll_find, 'd0' ) + ll_d0 )
			dw_insert.SetItem(ll_find, 'd1' , dw_insert.GetItemNumber(ll_find, 'd1' ) + ll_d1 )
			dw_insert.SetItem(ll_find, 'd2' , dw_insert.GetItemNumber(ll_find, 'd2' ) + ll_d2 )
			dw_insert.SetItem(ll_find, 'd3' , dw_insert.GetItemNumber(ll_find, 'd3' ) + ll_d3 )
			dw_insert.SetItem(ll_find, 'd4' , dw_insert.GetItemNumber(ll_find, 'd4' ) + ll_d4 )
			dw_insert.SetItem(ll_find, 'd5' , dw_insert.GetItemNumber(ll_find, 'd5' ) + ll_d5 )
			dw_insert.SetItem(ll_find, 'd6' , dw_insert.GetItemNumber(ll_find, 'd6' ) + ll_d6 )
			dw_insert.SetItem(ll_find, 'd7' , dw_insert.GetItemNumber(ll_find, 'd7' ) + ll_d7 )
			dw_insert.SetItem(ll_find, 'd8' , dw_insert.GetItemNumber(ll_find, 'd8' ) + ll_d8 )
			dw_insert.SetItem(ll_find, 'd9' , dw_insert.GetItemNumber(ll_find, 'd9' ) + ll_d9 )
			dw_insert.SetItem(ll_find, 'd10', dw_insert.GetItemNumber(ll_find, 'd10') + ll_d10)
			dw_insert.SetItem(ll_find, 'd11', dw_insert.GetItemNumber(ll_find, 'd11') + ll_d11)
		Else
			ll_r = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(ll_r, 'cdate', ls_ymd  )
			dw_insert.SetItem(ll_r, 'gubun', ls_gubun)
			dw_insert.SetItem(ll_r, 'd0'   , ll_d0   )
			dw_insert.SetItem(ll_r, 'd1'   , ll_d1   )
			dw_insert.SetItem(ll_r, 'd2'   , ll_d2   )
			dw_insert.SetItem(ll_r, 'd3'   , ll_d3   )
			dw_insert.SetItem(ll_r, 'd4'   , ll_d4   )
			dw_insert.SetItem(ll_r, 'd5'   , ll_d5   )
			dw_insert.SetItem(ll_r, 'd6'   , ll_d6   )
			dw_insert.SetItem(ll_r, 'd7'   , ll_d7   )
			dw_insert.SetItem(ll_r, 'd8'   , ll_d8   )
			dw_insert.SetItem(ll_r, 'd9'   , ll_d9   )
			dw_insert.SetItem(ll_r, 'd10'  , ll_d10  )
			dw_insert.SetItem(ll_r, 'd11'  , ll_d11  )
		End If
		
		dw_insert.ScrollToRow(ll_r)
		
		ll_xl_row++
		
		w_mdi_frame.sle_msg.text = ls_named[ix] + ' ������ ' + String(ll_xl_row) + '���� �а� �ֽ��ϴ�.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	//���� IMPORT END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

w_mdi_frame.sle_msg.text = '���������� ' + String(ll_cnt) + '���� Import �Ǿ����ϴ�.'

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('Import Success!', '�ڷᰡ ���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('Import Failure!', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
	Return
End If
end subroutine

on w_sm10_0055_pt.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_sm10_0055_pt.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_input.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))

p_inq.Enabled = False
p_del.Enabled = False
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// �߹��� ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("��ʥ(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�(&D)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&S)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", false) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", false) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// �̸����� 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�?(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF��ȯ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true) //// ����
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", false) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", false) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)
end if

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = true  //// ����
m_main2.m_window.m_save.enabled = false //// ����
m_main2.m_window.m_cancel.enabled = true //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = false  //// ã��
m_main2.m_window.m_filter.enabled = false //// ����
m_main2.m_window.m_excel.enabled = false //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;if p_del.Enabled = False then return

p_del.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;if p_inq.Enabled = False then return

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0055_pt
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0055_pt
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0055_pt
end type

type st_1 from w_inherite`st_1 within w_sm10_0055_pt
integer y = 3400
end type

type p_search from w_inherite`p_search within w_sm10_0055_pt
integer x = 2981
integer y = 84
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0055_pt
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0055_pt
end type

type p_mod from w_inherite`p_mod within w_sm10_0055_pt
integer y = 3200
end type

type p_del from w_inherite`p_del within w_sm10_0055_pt
integer y = 3200
end type

event p_del::clicked;call super::clicked;dw_input.AcceptText()

String ls_ymd

ls_ymd = dw_input.GetItemString(1, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('������ Ȯ��', '�������� Ȯ�� �Ͻʽÿ�.')
	Return
End If

If MessageBox('�������� Ȯ��', LEFT(ls_ymd, 4) + '.' + MID(ls_ymd, 5, 2) + '.' + RIGHT(ls_ymd, 2) + &
										 '���� �ڷḦ ���� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) <> 1 Then Return


If rb_1.Checked = True Then
	//�ϰ��ڷ� ����
	DELETE FROM VAN_PTDAY
	 WHERE CDATE = :ls_ymd ;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
		ROLLBACK USING SQLCA;
		MessageBox('�������� �߻�', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
		Return
	End If
ElseIf rb_2.Checked = True Then
	//�ְ��ڷ� ����
	DELETE FROM VAN_PTWEEK
	 WHERE CDATE = :ls_ymd ;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
		ROLLBACK USING SQLCA;
		MessageBox('�������� �߻�', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
		Return
	End If
End If

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('���� �Ϸ�', '�ڷᰡ ���� �Ǿ����ϴ�.')
	dw_insert.ReSet()
End If
end event

type p_inq from w_inherite`p_inq within w_sm10_0055_pt
integer y = 3200
end type

event p_inq::clicked;call super::clicked;dw_input.AcceptText()

Long   row

row = dw_input.GetRow()
If row < 1 Then Return

String ls_ymd

ls_ymd = dw_input.GetItemString(row, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('���� Ȯ��', '���ڴ� �ʼ� �׸��Դϴ�.')
	Return
End If

String ls_gbn

ls_gbn = dw_input.GetItemString(row, 'd_ed')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then ls_gbn = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_ymd, ls_gbn)
dw_insert.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_sm10_0055_pt
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0055_pt
integer y = 3200
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
dw_input.ReSet()

dw_input.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_sm10_0055_pt
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_sm10_0055_pt
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0055_pt
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0055_pt
integer x = 32
integer y = 52
integer width = 2089
integer height = 200
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0055_pt_001-1"
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event dw_input::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gbn'
		If data = 'I' Then
			cb_1.Enabled = True
			This.DataObject = 'd_sm10_0055_pt_001-1'
			
			p_inq.Enabled = False
			p_del.Enabled = False
//			p_inq.Visible = False
//			p_del.Visible = False
		Else
			cb_1.Enabled = False
			This.DataObject = 'd_sm10_0055_pt_001-2'

			p_inq.Enabled = True
			p_del.Enabled = True
//			p_inq.Visible = True
//			p_del.Visible = True
		End If
		
		This.SetTransObject(SQLCA)
		This.InsertRow(0)
End Choose
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0055_pt
integer x = 37
integer y = 284
integer width = 3488
integer height = 1964
string dataobject = "d_sm10_0055_pt_002"
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type cb_mod from w_inherite`cb_mod within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0055_pt
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0055_pt
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0055_pt
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0055_pt
end type

type r_head from w_inherite`r_head within w_sm10_0055_pt
boolean visible = false
integer y = 2484
end type

type r_detail from w_inherite`r_detail within w_sm10_0055_pt
end type

type cb_1 from commandbutton within w_sm10_0055_pt
integer x = 2533
integer y = 88
integer width = 402
integer height = 132
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ڷ���"
end type

event clicked;If rb_1.Checked = True Then
	wf_day()
Else
	wf_week()
End If
end event

type rb_1 from radiobutton within w_sm10_0055_pt
integer x = 2245
integer y = 92
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 12639424
string text = "�ϰ�"
boolean checked = true
end type

event clicked;If rb_1.Checked = True Then
	dw_insert.DataObject = 'd_sm10_0055_pt_002'
	dw_insert.SetTransObject(SQLCA)
End If
end event

type rb_2 from radiobutton within w_sm10_0055_pt
integer x = 2245
integer y = 164
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 12639424
string text = "�ְ�"
end type

event clicked;If rb_2.Checked = True Then
	dw_insert.DataObject = 'd_sm10_0055_pt_003'
	dw_insert.SetTransObject(SQLCA)
End If
end event

type dw_1 from datawindow within w_sm10_0055_pt
boolean visible = false
integer x = 3547
integer y = 1552
integer width = 983
integer height = 664
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "�ְ�"
string dataobject = "d_sm10_0055_pt_003"
boolean border = false
end type

type pb_1 from u_pic_cal within w_sm10_0055_pt
integer x = 603
integer y = 116
integer height = 76
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('d_st')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_sm10_0055_pt
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 12639424
integer x = 2190
integer y = 56
integer width = 306
integer height = 196
integer cornerheight = 40
integer cornerwidth = 55
end type

