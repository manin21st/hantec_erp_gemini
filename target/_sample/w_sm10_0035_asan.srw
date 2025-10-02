$PBExportHeader$w_sm10_0035_asan.srw
$PBExportComments$VAN ����(CKD�̳� ������ ����) - �ƻ�
forward
global type w_sm10_0035_asan from w_inherite
end type
type pb_1 from u_pic_cal within w_sm10_0035_asan
end type
type pb_2 from u_pic_cal within w_sm10_0035_asan
end type
type dw_2 from datawindow within w_sm10_0035_asan
end type
type pb_3 from u_pic_cal within w_sm10_0035_asan
end type
type cb_1 from commandbutton within w_sm10_0035_asan
end type
type cb_2 from commandbutton within w_sm10_0035_asan
end type
type st_2 from statictext within w_sm10_0035_asan
end type
type st_3 from statictext within w_sm10_0035_asan
end type
type r_1 from rectangle within w_sm10_0035_asan
end type
end forward

global type w_sm10_0035_asan from w_inherite
string title = "�ƻ�CKD VAN ��ǰ�� ����"
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
pb_3 pb_3
cb_1 cb_1
cb_2 cb_2
st_2 st_2
st_3 st_3
r_1 r_1
end type
global w_sm10_0035_asan w_sm10_0035_asan

forward prototypes
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("������ ���ϸ��� �����ϼ���." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("��������" , ls_filepath + " ������ �̹� �����մϴ�.~r~n" + &
												 "������ ������ ����ðڽ��ϱ�?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end subroutine

on w_sm10_0035_asan.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.pb_3=create pb_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_2=create st_2
this.st_3=create st_3
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.r_1
end on

on w_sm10_0035_asan.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.pb_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.r_1)
end on

event open;call super::open;dw_input.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_input.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))



end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// �߹��� ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("��ʥ(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�(&D)", true) //// ����
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
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", true) //// ����
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
m_main2.m_window.m_del.enabled = true  //// ����
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

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0035_asan
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0035_asan
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0035_asan
end type

type st_1 from w_inherite`st_1 within w_sm10_0035_asan
integer y = 3400
end type

type p_search from w_inherite`p_search within w_sm10_0035_asan
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0035_asan
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0035_asan
end type

type p_mod from w_inherite`p_mod within w_sm10_0035_asan
integer y = 3200
end type

event p_mod::clicked;call super::clicked;Long   ll_cnt 

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

If f_msg_update() <> 1 Then Return

Long   i
String ls_ord_h

//For i = 1 To ll_cnt
//	ls_ord_h = dw_insert.GetItemString(i, 'order_date_hantec')
//	If Trim(ls_ord_h) = '' OR IsNull(ls_ord_h) Then
//		MessageBox('���س�ǰ��', '���س�ǰ���� �Է� �Ͻʽÿ�.')
//		dw_insert.SetColumn('order_date_hantec')
//		dw_insert.SetRow(i)
//		dw_insert.SetFocus()
//		dw_insert.ScrollToRow(i)
//		Return
//	End If
//Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('���� Ȯ��', '���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('���� ����', '�ڷ� ���� �� ������ �߻��߽��ϴ�.')
	Return
End If

end event

type p_del from w_inherite`p_del within w_sm10_0035_asan
integer y = 3200
end type

event p_del::clicked;call super::clicked;dw_insert.AcceptText()

If f_msg_delete() <> 1 Then Return

String ls_chk
Long   i

For i = 1 To dw_insert.RowCount()
	ls_chk = dw_insert.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		dw_insert.DeleteRow(i)	
		i = i - 1
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('����', '���� �Ǿ����ϴ�.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('����', '���� �� ������ �߻� �߽��ϴ�.')
	Return
End If
end event

type p_inq from w_inherite`p_inq within w_sm10_0035_asan
integer y = 3200
end type

event p_inq::clicked;call super::clicked;dw_input.AcceptText()

Long   row

row = dw_input.GetRow()
If row < 1 Then Return

String ls_st

ls_st = dw_input.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		Messagebox('�������� Ȯ��', '���������� �߸� �Ǿ����ϴ�.')
		dw_input.SetColumn('d_st')
		dw_input.SetFocus()
		Return
	End If
End If

String ls_ed

ls_ed = dw_input.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		Messagebox('�������� Ȯ��', '���������� �߸� �Ǿ����ϴ�.')
		dw_input.SetColumn('d_ed')
		dw_input.SetFocus()
		Return
	End If
End If

If ls_st > ls_ed Then
	MessageBox('�Ⱓ Ȯ��', '������ ���� �������� �����ϴ�.')
	dw_input.SetColumn('d_st')
	dw_input.SetFocus()
	Return
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_st, ls_ed)
dw_insert.SetRedraw(True)

end event

type p_print from w_inherite`p_print within w_sm10_0035_asan
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0035_asan
integer y = 3200
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
dw_insert.SetTransObject(SQLCA)
end event

type p_exit from w_inherite`p_exit within w_sm10_0035_asan
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_sm10_0035_asan
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0035_asan
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0035_asan
integer y = 56
integer width = 1280
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0030_asan_001"
end type

event constructor;dw_input.SetTransObject(SQLCA)
dw_input.InsertRow(0)
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0035_asan
integer x = 37
integer y = 324
integer width = 3488
integer height = 1964
string dataobject = "d_sm10_0030_asan_002"
end type

event dw_insert::constructor;call super::constructor;dw_insert.SetTransObject(SQLCA)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dw_insert::clicked;call super::clicked;//This.SelectRow(0, False)
//This.SelectRow(row, True)

f_multi_select(this)
end event

event dw_insert::itemchanged;call super::itemchanged;This.AcceptText()

String ls_base

ls_base = dw_2.GetItemString(1, 'd_base')
If Trim(ls_base) = '' OR IsNull(ls_base) Then
	MessageBox('������ Ȯ��', '�������� �Է� �Ͻʽÿ�.')
	dw_2.SetColumn('d_base')
	dw_2.SetFocus()
	Return -1
End If

Choose Case dwo.name
	Case 'chk'
		If data = 'Y' Then
//			This.SetItem(row, 'ord_han', This.GetItemString(row, 'order_date_hantec'))
			This.SetItem(row, 'podate', ls_base)
		Else
			If Trim(This.GetItemString(row, 'podate')) = '' OR IsNull(This.GetItemString(row, 'podate')) Then
				Return
			Else
//				This.SetItem(row, 'order_date_hantec', This.GetItemString(row, 'ord_han'))
				This.SetItem(row, 'podate', '')
			End If
		End If
		
End Choose
end event

type cb_mod from w_inherite`cb_mod within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0035_asan
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0035_asan
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0035_asan
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0035_asan
end type

type r_head from w_inherite`r_head within w_sm10_0035_asan
integer width = 1289
end type

type r_detail from w_inherite`r_detail within w_sm10_0035_asan
integer y = 320
end type

type pb_1 from u_pic_cal within w_sm10_0035_asan
integer x = 690
integer y = 120
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('d_st')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'd_st', gs_code)

end event

type pb_2 from u_pic_cal within w_sm10_0035_asan
integer x = 1134
integer y = 120
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('d_ed')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'd_ed', gs_code)

end event

type dw_2 from datawindow within w_sm10_0035_asan
integer x = 1998
integer y = 56
integer width = 672
integer height = 188
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0030_asan_003"
boolean border = false
boolean livescroll = true
end type

event constructor;This.InsertRow(0)

This.SetItem(1, 'd_base', String(RelativeDate(TODAY(), 1), 'yyyymmdd'))
end event

type pb_3 from u_pic_cal within w_sm10_0035_asan
integer x = 2533
integer y = 120
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_2.SetColumn('d_base')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_2.SetItem(1, 'd_base', gs_code)

end event

type cb_1 from commandbutton within w_sm10_0035_asan
integer x = 1353
integer y = 68
integer width = 114
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   i
	
dw_2.AcceptText()

String ls_base

ls_base = dw_2.GetItemString(1, 'd_base')
If Trim(ls_base) = '' OR IsNull(ls_base) Then
	MessageBox('������ Ȯ��', '�������� �Է� �Ͻʽÿ�.')
	dw_2.SetColumn('d_base')
	dw_2.SetFocus()
	Return -1
End If
	
For i = 0 To ll_cnt
	i = dw_insert.GetSelectedRow(i - 1)
	If i < 1 Then Return
	
	dw_insert.SetItem(i, 'chk', 'Y')

	//dw_insert.SetItem(i, 'ord_han', dw_insert.GetItemString(i, 'order_date_hantec'))
	//dw_insert.SetItem(i, 'order_date_hantec', ls_base)
	
	dw_insert.SetItem(i, 'gujb_date', dw_insert.GetItemString(i, 'podate'))
	dw_insert.SetItem(i, 'podate', ls_base)
Next
end event

type cb_2 from commandbutton within w_sm10_0035_asan
integer x = 1353
integer y = 156
integer width = 114
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   i

For i = 1 To ll_cnt	
	dw_insert.SetItem(i, 'chk', 'N')	
	
	
	//If Trim(dw_insert.GetItemString(i, 'ord_han')) = '' OR IsNull(dw_insert.GetItemString(i, 'ord_han')) Then
	//	Continue ;
	//Else
	//	dw_insert.SetItem(i, 'order_date_hantec', dw_insert.GetItemString(i, 'ord_han'))
	//	dw_insert.SetItem(i, 'ord_han', '')
	//End If
	
	If Trim(dw_insert.GetItemString(i, 'gujb_date')) = '00000000' OR IsNull(dw_insert.GetItemString(i, 'gujb_date')) Then
		Continue ;
	Else
		dw_insert.SetItem(i, 'podate', dw_insert.GetItemString(i, 'gujb_date'))
		dw_insert.SetItem(i, 'gujb_date', '')
	End If
	
Next
end event

type st_2 from statictext within w_sm10_0035_asan
integer x = 1477
integer y = 80
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
string text = "�ϰ�����"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm10_0035_asan
integer x = 1477
integer y = 172
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
string text = "�ϰ�����"
boolean focusrectangle = false
end type

type r_1 from rectangle within w_sm10_0035_asan
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 33028087
integer x = 1993
integer y = 52
integer width = 681
integer height = 196
end type

