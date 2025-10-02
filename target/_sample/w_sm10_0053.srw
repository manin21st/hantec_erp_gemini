$PBExportHeader$w_sm10_0053.srw
$PBExportComments$VAN ����(M1 �����ϼ���)
forward
global type w_sm10_0053 from w_inherite
end type
type pb_1 from u_pic_cal within w_sm10_0053
end type
type pb_2 from u_pic_cal within w_sm10_0053
end type
end forward

global type w_sm10_0053 from w_inherite
string title = "MOBIS AUTO VAN ��ǰ�� ����"
pb_1 pb_1
pb_2 pb_2
end type
global w_sm10_0053 w_sm10_0053

on w_sm10_0053.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_sm10_0053.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_input.SetItem(1, 'jisi_date', String(TODAY(), 'yyyymmdd'))
dw_input.SetItem(1, 'jisi_date2', String(TODAY(), 'yyyymmdd'))

end event

event activate;gw_window = this

if gs_lang = "CH" then   //// �߹��� ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("��ʥ(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�(&D)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&S)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", true) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", true) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// �̸����� 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�?(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF��ȯ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true) //// ����
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", true) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", true) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)
end if

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = false  //// ����
m_main2.m_window.m_save.enabled = true //// ����
m_main2.m_window.m_cancel.enabled = true //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = true  //// ã��
m_main2.m_window.m_filter.enabled = true //// ����
m_main2.m_window.m_excel.enabled = true //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0053
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0053
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0053
end type

type st_1 from w_inherite`st_1 within w_sm10_0053
end type

type p_search from w_inherite`p_search within w_sm10_0053
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0053
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0053
end type

type p_mod from w_inherite`p_mod within w_sm10_0053
integer y = 3200
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   i
String ls_yodate

For i = 1 To dw_insert.RowCount()
	ls_yodate = dw_insert.GetItemString(i, 'yodate')
	If Trim(ls_yodate) = '' OR IsNull(ls_yodate) Then
		MessageBox('���� �Է�', '�������ڸ� �Է� �Ͻʽÿ�.')
		Return
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('����', '�ڷᰡ ���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('����', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
End If
end event

type p_del from w_inherite`p_del within w_sm10_0053
integer y = 3200
end type

type p_inq from w_inherite`p_inq within w_sm10_0053
integer y = 3200
end type

event p_inq::clicked;call super::clicked;dw_input.AcceptText()

String ls_fac
String ls_itn
String ls_st
String ls_ed

ls_fac = dw_input.GetItemString(1, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = 'M1'

ls_itn = dw_input.GetItemString(1, 'itnbr')
If Trim(ls_itn) = '' OR IsNull(ls_itn) Then ls_itn = '%'

ls_st = dw_input.GetItemString(1, 'jisi_date')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '20000101'

ls_ed = dw_input.GetItemString(1, 'jisi_date2')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '29991231'

If ls_st > ls_ed Then
	MessageBox('�ⰣȮ��', '������ ���� �������� �����ϴ�.')
	Return
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_saupj, ls_st, ls_ed, ls_itn, ls_fac)
dw_insert.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_sm10_0053
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0053
integer y = 3200
end type

type p_exit from w_inherite`p_exit within w_sm10_0053
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_sm10_0053
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0053
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0053
integer y = 56
integer width = 3488
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0053_1"
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0053
integer x = 37
integer y = 284
integer width = 3488
integer height = 1964
string dataobject = "d_sm10_0053_ckd_b"
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type cb_mod from w_inherite`cb_mod within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0053
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0053
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0053
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0053
end type

type r_head from w_inherite`r_head within w_sm10_0053
end type

type r_detail from w_inherite`r_detail within w_sm10_0053
end type

type pb_1 from u_pic_cal within w_sm10_0053
integer x = 809
integer y = 156
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('jisi_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pic_cal within w_sm10_0053
integer x = 1312
integer y = 156
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('jisi_date2')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'jisi_date2', gs_code)

end event

