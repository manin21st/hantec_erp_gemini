$PBExportHeader$w_kglb03.srw
$PBExportComments$��ǥ �˻�
forward
global type w_kglb03 from window
end type
type lb_qry_column from listbox within w_kglb03
end type
type uo_where from uo_search_conditions_ac within w_kglb03
end type
type uo_retrieve_items from uo_search_outputs_ac within w_kglb03
end type
type uo_where_items from uo_search_items_ac within w_kglb03
end type
type uo_retrieve from uo_search_result_ac within w_kglb03
end type
type uo_buttons from uo_cond_qry_button_ac within w_kglb03
end type
end forward

global type w_kglb03 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "��ǥ �˻�"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_open pbm_custom01
event ue_where_items pbm_custom10
event ue_where pbm_custom11
event ue_retrieve_items pbm_custom12
event ue_retrieve pbm_custom13
event ue_close pbm_custom14
event ue_print_popup pbm_custom15
lb_qry_column lb_qry_column
uo_where uo_where
uo_retrieve_items uo_retrieve_items
uo_where_items uo_where_items
uo_retrieve uo_retrieve
uo_buttons uo_buttons
end type
global w_kglb03 w_kglb03

type variables
userobject	iuo_current_view

long		il_prevrow

string	iv_sql_select, iv_sql_from, iv_sql_where

integer	iv_column_count
string	iv_column_name[56]
string	iv_id, iv_title, iv_remark
string	iv_empnocloumn

string	is_select_clause, is_from_clause
string	is_where_clause, is_join_clause
string	is_sql_statement

string	is_orderby

string        Is_fsGbn
Boolean    ib_any_typing

w_preview  iw_preview


String	is_window_id
String     is_today              //��������
String     is_totime             //���۽ð�
String     sModStatus
String     is_usegub           //�̷°��� ����
end variables

forward prototypes
public function integer wf_make_where_clause ()
public function integer wf_retrieve_dw ()
public function string wf_get_columnname (string sgbn, string scolumnid)
public function integer wf_make_sql ()
public function integer wf_add_where_items ()
public function integer wf_create_dw ()
end prototypes

event ue_open;
//uo_where.dw_codelist.SetTransObject(SQLCA)

iuo_current_view = uo_where_items

this.Title = '���� �˻� - �����׸� ����'

uo_retrieve.Hide()

end event

event ue_where_items;uo_buttons.p_where_items.triggerevent(clicked!)
end event

event ue_where;uo_buttons.p_where.triggerevent(clicked!)

end event

on ue_retrieve_items;
uo_buttons.p_retrieve_items.TriggerEvent(clicked!)

end on

event ue_retrieve;uo_buttons.p_retrieve.TriggerEvent(clicked!)

end event

event ue_close;uo_buttons.p_close.TriggerEvent(clicked!)
end event

event ue_print_popup;uo_buttons.p_print.TriggerEvent(clicked!)
end event

public function integer wf_make_where_clause ();If uo_where.uf_make_where_clause() = 1 Then
	is_where_clause = uo_where.is_where_clause
	Return 1
Else
	Return -1
end if
end function

public function integer wf_retrieve_dw ();Long	 ll_rt, i
String sSqlSyntax

uo_retrieve.dw_result.SetTransObject(SQLCA)
sSqlSynTax = uo_retrieve.dw_result.GetsqlSelect()

ll_rt = uo_retrieve.dw_result.Retrieve()

Choose Case ll_rt
	Case 0
		uo_retrieve.st_emp_count.Text = "0"
	Case Is > 0
		uo_retrieve.st_emp_count.Text = string(ll_rt) 
		//uo_retrieve.st_emp_count.Text = String(uo_retrieve.dw_result.GetItemNumber(1, "empno_count"))
	Case Else
		MessageBox("Ȯ��", "�ڷ� �˻� ����!")
		Return -1
End Choose

//iSQLCA_main.AutoCommit = False

Return 1
end function

public function string wf_get_columnname (string sgbn, string scolumnid);
String sColumnName

IF sGbn ='SORT' THEN
	IF scolumnid = 'A' THEN
		sColumnName = '��������,'
	ELSEIF scolumnid = 'D' THEN
		sColumnName = '��������,'
	END IF
ELSE	
	Choose Case Trim(scolumnid)
		Case "saupjname"
			sColumnName = "�����"
		Case "deptname"
			sColumnName = "�ۼ��μ�"
		Case "bal_date"
			sColumnName = "�ۼ�����"
		Case "upmuname"
			sColumnName = "��ǥ����"
		Case "bjun_no"
			sColumnName = "��ǥ��ȣ"
		Case "lin_no"
			sColumnName = "���ι�ȣ"
		Case "jun_gu"
			sColumnName = "��ǥ����"
		Case "acc1_cd"
			sColumnName = "��������"
		Case "acc2_cd"
			sColumnName = "��������"
		Case "acc1_nm"
			sColumnName = "����������"
		Case "acc2_nm"
			sColumnName = "���������"
		Case "sawonname"
			sColumnName = "�ۼ���"
		Case "dcr_gu"
			sColumnName = "���뱸��"
		Case "amt"
			sColumnName = "��ǥ�ݾ�"
		Case "descr"
			sColumnName = "�� ��"
		Case "cdeptname"
			sColumnName = "����μ�"
		Case "cost_nm"
			sColumnName = "�����ι�"
		Case "saup_no"
			sColumnName = "�ŷ�ó�ڵ�"
		Case "in_nm"
			sColumnName = "���ðŷ�ó��"
		Case "kwan_no"
			sColumnName = "������ȣ"
		Case "k_amt"
			sColumnName = "�ݾ�(����)"
		Case "k_rate"
			sColumnName = "�� ��"
		Case "k_qty"
			sColumnName = "�� ��"
		Case "k_uprice"
			sColumnName = "�� ��"
		Case "k_symd"
			sColumnName = "��������"
		Case "k_eymd"
			sColumnName = "��������"
		Case "y_amt"
			sColumnName = "��ȭ�ݾ�"
		Case "y_rate"
			sColumnName = "����ȯ��"
		Case "y_curr"
			sColumnName = "��ȭ����"
		Case "in_cd"
			sColumnName = "�з��ڵ�"
		Case "gyul_date"
			sColumnName = "������������"
		Case "gyul_method"
			sColumnName = "���޹��"
		Case "pjt_no"
			sColumnName = "������Ʈ��ȣ"
		Case "pjtname"
			sColumnName = "������Ʈ��"
		Case "itm_gu"
			sColumnName = "����"
		Case "jub_gu"
			sColumnName = "����񱸺�"
		Case "jbill_gu"
			sColumnName = "���޾�������"
		Case "rbill_gu"
			sColumnName = "������������"
		Case "vat_gu"
			sColumnName = "�ΰ�������"
		Case "chaip_gu"
			sColumnName = "���Աݱ���"
		Case "secu_gu"
			sColumnName = "�������Ǳ���"
		Case "exp_gu"
			sColumnName = "���±���"
		Case "cross_gu"
			sColumnName = "��������"
		Case "aset_gu"
			sColumnName = "�ڻ걸��"	
		Case "acc_date"
			sColumnName = "ȸ������"			
		Case "jun_no"
			sColumnName = "ȸ����ǥ��ȣ"
		Case "indat"
			sColumnName = "�Է�����"
	End Choose
END IF
	
Return sColumnName
end function

public function integer wf_make_sql ();uo_retrieve_items.uf_make_sql()

is_select_clause = uo_retrieve_items.is_select_clause
is_from_clause = uo_retrieve_items.is_from_clause

IF wf_make_where_clause() <> 1 THEN
	Return 0
END IF

//is_join_clause = uo_retrieve_items.is_join_clause

If isnull(is_from_clause) or Trim(is_from_clause) = "" Then
	MessageBox("Ȯ��", "���õ� ��ȸ�׸��� �����ϴ�.")
	Return 0
End If

//is_select_clause = is_select_clause 

//If Len(is_join_clause) <> 0 then
//	If Len(is_where_clause) = 0 then
//		MessageBox("Ȯ��", "���ǽ��� �������� �ʾҽ��ϴ�.")
//		Return -1
//	Else
//		is_join_clause = " AND " + is_join_clause
//	End if
//End if

is_sql_statement = is_select_clause + is_from_clause + is_where_clause // + is_join_clause

Return 1
end function

public function integer wf_add_where_items ();//	���Ǽ���(uo_where)�� �׸� DDLB�� ä���ش�.

Integer				i, imax, dindex
DropDownListBox	d[8]
String            sCurValue

imax = uo_where_items.lb_selected.TotalItems()

d[1] = uo_where.ddlb_field_1; d[2] = uo_where.ddlb_field_2
d[3] = uo_where.ddlb_field_3; d[4] = uo_where.ddlb_field_4
d[5] = uo_where.ddlb_field_5; d[6] = uo_where.ddlb_field_6
d[7] = uo_where.ddlb_field_7; d[8] = uo_where.ddlb_field_8

//uo_where.uf_clear_rows(1)

If imax > 0 Then
	For dindex = 1 to 8	// 9 -> ���� ��
		sCurValue = d[dindex].text
		d[dindex].Reset()
		For i = 1 to imax
			d[dindex].AddItem(uo_where_items.lb_selected.Text(i))
		Next
		d[dindex].text = sCurValue
	Next
	uo_where.sle_parenthesis_f_1.Enabled = True
	uo_where.ddlb_field_1.Enabled = True
	uo_where.ddlb_op_1.Enabled = True
	uo_where.sle_value_1.Enabled = True
	uo_where.sle_parenthesis_r_1.Enabled = True
	uo_where.ddlb_logical_1.Enabled = True
Else
	MessageBox("Ȯ��", "���ǽ��� ����� ���� �׸��� �����ؾ��մϴ�.")
	Return -1
End If

uo_where.lb_fieldnames.Reset()	// Hidden Control!!!
For i = 1 to imax
	uo_where.lb_fieldnames.AddItem(uo_where_items.lb_selected_fieldnames.Text(i))
Next

Return 1
end function

public function integer wf_create_dw ();String	ls_dw_syntax, ls_dw_style, ls_dw_err
String	ls_Rt, ls_Modify_Err
String	ls_Column_Name[56], ls_Column_Title[56]
Integer	i, imax, cp, pt
Long	ll_rt
Integer	li_unit_per_char = 210		// unit : 1/ 1000 Cm

ls_dw_style = "style(type=grid) datawindow(units=3 color=16777215) "

//��db �߰�(98/09/12)
string sand
int    ilen

ilen = len(is_sql_statement)

sand = right(is_sql_statement, 4) 

if sand = 'And)' OR sand = ' Or)' then 
	is_sql_statement = left(is_sql_statement, ilen - 4) + ')'
end if	

ls_dw_syntax = SQLCA.SyntaxFromSQL(is_sql_statement, ls_dw_style, ls_dw_err)
If ls_dw_err <> "" Then
	MessageBox("�ڷ� Ȯ��", ls_dw_err)
	Return -1
End If

cp = 1
Do While True
	i = i + 1
	cp = Pos(ls_dw_syntax, "column=", cp)
	If cp = 0 Then Exit

	cp = Pos(ls_dw_syntax, " name=", cp)

	pt = cp + 6

	cp = Pos(ls_dw_syntax, "dbname=", cp)

	ls_Column_Name[i] = Trim(Mid(ls_dw_syntax, pt, cp - pt))
Loop
SetNull(ls_Column_Name[i])

If uo_retrieve.dw_result.Create(ls_dw_syntax) = -1 Then
	MessageBox("Error", "dw_result Creation Failure in wf_create_dw()")
	Return -1
End If

lb_qry_Column.Reset()
uo_retrieve_items.lb_ColumnTitle.Reset()

i = 1
Do While Not IsNull(ls_Column_Name[i])
	Choose Case ls_Column_Name[i]
		Case "saupjname"
			ls_Column_Title[i] = "�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width =" + String(li_unit_per_char * 7))
			
		Case "deptname","dept_cd"
			ls_Column_Title[i] = "�ۼ��μ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))

		Case "bal_date"
			ls_Column_Title[i] = "�ۼ�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "upmuname","upmu_gu"
			ls_Column_Title[i] = "��ǥ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
		
		Case "bjun_no"
			ls_Column_Title[i] = "��ǥ��ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			
		Case "lin_no"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			
		Case "jun_gu"
			ls_Column_Title[i] = "��ǥ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 7))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '�Ա���ǥ~t1/�����ǥ~t2/��ü��ǥ~t3'")
			
		Case "acc1_cd"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 5))
		
		Case "acc2_cd"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 5))

//		Case "acc1_nm"
//			ls_Column_Title[i] = "����������"
//			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))

		Case "acc2_nm"
			ls_Column_Title[i] = "���������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "sawonname"
			ls_Column_Title[i] = "�ۼ���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 7))
			
		Case "dcr_gu"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/�뺯~t2'")

		Case "amt"
			ls_Column_Title[i] = "��ǥ�ݾ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 13))

		Case "descr"
			ls_Column_Title[i] = "�� ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 30))
			
		Case "cdeptname"
			ls_Column_Title[i] = "����μ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
					
		Case "cost_nm"
			ls_Column_Title[i] = "�����ι�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "saup_no"
			ls_Column_Title[i] = "�ŷ�ó"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "in_nm"
			ls_Column_Title[i] = "���ðŷ�ó��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 25))
			
		Case "kwan_no"
			ls_Column_Title[i] = "������ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))
			
		Case "k_amt"
			ls_Column_Title[i] = "�ݾ�(����)"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "k_rate"
			ls_Column_Title[i] = "�� ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "k_qty"
			ls_Column_Title[i] = "�� ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "k_uprice"
			ls_Column_Title[i] = "�� ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "k_symd"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "k_eymd"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "y_amt"
			ls_Column_Title[i] = "��ȭ�ݾ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "y_rate"
			ls_Column_Title[i] = "����ȯ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "y_curr"
			ls_Column_Title[i] = "��ȭ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "in_cd"
			ls_Column_Title[i] = "�з��ڵ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "gyul_date"
			ls_Column_Title[i] = "������������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "gyul_method"
			ls_Column_Title[i] = "���޹��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "pjt_no"
			ls_Column_Title[i] = "������Ʈ��ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))
			
		Case "pjtname"
			ls_Column_Title[i] = "������Ʈ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 40))

		Case "itm_gu"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))

		Case "jub_gu"
			ls_Column_Title[i] = "�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")
			
		Case "jbill_gu"
			ls_Column_Title[i] = "���޾���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")
			
		Case "rbill_gu"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")

		Case "vat_gu"
			ls_Column_Title[i] = "�ΰ���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")

		Case "chaip_gu"
			ls_Column_Title[i] = "���Ա�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")
				
		Case "secu_gu"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")
		
		Case "exp_gu"
			ls_Column_Title[i] = "���±���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))

		Case "cross_gu"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")

		Case "aset_gu"
			ls_Column_Title[i] = "�ڻ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")

		Case "jun_no"
			ls_Column_Title[i] = "ȸ����ǥ��ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))

		Case "indat"
			ls_Column_Title[i] = "�Է�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))			
			
		Case "acc_date"
			ls_Column_Title[i] = "ȸ������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))			
		Case "alc_gu"
			ls_Column_Title[i] = "���α���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 2))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = 'Y~tY/N~tN'")
	End Choose

//	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.Height = 530")
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.Color = " + String(RGB(73,117,173)))
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.TextColor = " + String(RGB(255,255,255)))
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.selected.mouse=no")
	
	ls_Modify_Err = uo_retrieve.dw_result.Modify('datawindow.print.orientation=1 &
																	datawindow.print.margin.left=280 datawindow.zoom=100' )
		
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.text='" + ls_Column_Title[i] + "'")
//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.y='90'")
//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.height.autosize=Yes")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.face='����ü'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.height='-9'")
//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.weight='329'")
//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.family='1'")
//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.pitch='1'")
//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.charset='-127'")

//	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".font.height='-10'")
				
	Choose Case ls_Column_Title[i]
		CASE "�ۼ�����", "��������", "��������", "������������","�Է�����","ȸ������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='@@@@.@@.@@'")
		Case "�ݾ�(����)","��ǥ�ݾ�","����","�ܰ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='###,###,###,###,##0'")
		Case "����", "��ȭ�ݾ�", "����ȯ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='#,###,###,###,##0.00'")
	End Choose

	lb_qry_Column.AddItem(ls_Column_Name[i])
	uo_retrieve_items.lb_ColumnTitle.AddItem(ls_Column_Title[i])

	iv_column_count = i
	i = i + 1
Loop

For i = 1 To iv_column_count	
	iv_Column_Name[i] = ls_Column_Name[i]
Next

Return 1
end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = Upper(is_window_id)


this.postevent("ue_open")


end event

on w_kglb03.create
this.lb_qry_column=create lb_qry_column
this.uo_where=create uo_where
this.uo_retrieve_items=create uo_retrieve_items
this.uo_where_items=create uo_where_items
this.uo_retrieve=create uo_retrieve
this.uo_buttons=create uo_buttons
this.Control[]={this.lb_qry_column,&
this.uo_where,&
this.uo_retrieve_items,&
this.uo_where_items,&
this.uo_retrieve,&
this.uo_buttons}
end on

on w_kglb03.destroy
destroy(this.lb_qry_column)
destroy(this.uo_where)
destroy(this.uo_retrieve_items)
destroy(this.uo_where_items)
destroy(this.uo_retrieve)
destroy(this.uo_buttons)
end on

event closequery;w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type lb_qry_column from listbox within w_kglb03
boolean visible = false
integer x = 1307
integer y = 2332
integer width = 439
integer height = 164
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "����ü"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type uo_where from uo_search_conditions_ac within w_kglb03
integer y = 576
integer width = 4581
integer taborder = 30
long backcolor = 33027312
end type

on uo_where.destroy
call uo_search_conditions_ac::destroy
end on

type uo_retrieve_items from uo_search_outputs_ac within w_kglb03
integer x = 18
integer y = 192
integer width = 4571
integer height = 360
integer taborder = 20
end type

on ue_clear;call uo_search_outputs_ac::ue_clear;
lb_output_item.Reset()
lb_columnname.Reset()

lb_qry_column.Reset()
lb_columntitle.Reset()

end on

on uo_retrieve_items.destroy
call uo_search_outputs_ac::destroy
end on

type uo_where_items from uo_search_items_ac within w_kglb03
integer x = 23
integer taborder = 10
end type

on ue_clear;call uo_search_items_ac::ue_clear;
lb_where_item.Reset()

end on

on uo_where_items.destroy
call uo_search_items_ac::destroy
end on

type uo_retrieve from uo_search_result_ac within w_kglb03
event ue_sort_text pbm_custom03
boolean visible = false
integer y = 576
integer width = 4581
integer height = 1704
end type

event ue_sort_text;Integer il_Pos
String  sSubSyntax,sSortSyntax,sOrderBySyntax,sSort,sColumn,sColumnName,sSortName

sOrderBySyntax = is_orderby

il_Pos = Pos(sOrderBySyntax,',')

DO 
	IF il_Pos <=0 THEN
		sSubSyntax = sOrderBySyntax
		
	ELSE
		sSubSynTax    = Left(sOrderBySyntax,il_Pos - 1)
		sOrderBySynTax = Mid(sOrderBySynTax,il_Pos + 1,50)
	END IF
	
	sColumn = Left(sSubSyntax,Len(sSubSyntax) - 2)
	sSort   = Right(sSubSyntax,1)
	
	sColumnName = Wf_Get_ColumnName('COLUMN',sColumn)
	sSortName   = Wf_Get_ColumnName('SORT',sSort)
	
	sSortSyntax = sSortSyntax + sColumnName + sSortName
	
	il_Pos = Pos(sOrderBySyntax,',')
	IF il_Pos <=0 THEN
		sSubSyntax = sOrderBySyntax
	END IF
	
LOOP UNTIL il_Pos <= 0

sColumn = Left(sSubSyntax,Len(sSubSyntax) - 2)
sSort   = Right(sSubSyntax,1)
	
sColumnName = Wf_Get_ColumnName('COLUMN',sColumn)
sSortName   = Wf_Get_ColumnName('SORT',sSort)
	
sSortSyntax = sSortSyntax + sColumnName + sSortName
il_Pos = Pos(sOrderBySyntax,',')
	
uo_retrieve.dw_result.title = '���� ���� : '+ Left(sSortSyntax,Len(sSortSyntax) - 1)



end event

event ue_dw_dblclicked;//String		ls_empno
//Long		ll_row
//
//ll_row = dw_result.GetRow()
//If ll_row > 0 Then
//	sle_msg.text = "�ش� ����� ���� ������ ���÷��� Double Click�� �ϼ���.!!!"
//	ls_empno = dw_result.GetItemString(ll_row, iv_empnocloumn)
//	OpenWithParm(w_kglb031, ls_empno)
//End If
//
end event

event ue_sort;st_cond_qry_sort_parm	lst_sort_parm

lst_sort_parm.lb_columnname = lb_qry_column
lst_sort_parm.lb_columntitle = uo_retrieve_items.lb_columntitle

OpenWithParm(w_kglb031, lst_sort_parm)
is_orderby = Message.StringParm

If is_orderby <> "" Then
	If uo_retrieve.dw_result.SetSort(is_orderby) = 1 Then
		uo_retrieve.dw_result.Sort()
	End If
	this.TriggerEvent("ue_sort_text")
ELSE
	uo_retrieve.dw_result.title = ' '
End If




end event

on uo_retrieve.destroy
call uo_search_result_ac::destroy
end on

type uo_buttons from uo_cond_qry_button_ac within w_kglb03
integer x = 3333
integer y = 12
integer width = 1275
integer height = 160
boolean bringtotop = true
boolean border = false
end type

event ue_retrieve;
//Parent.SetRedraw(False)

If wf_make_sql() <> 1 Then
//	Parent.SetRedraw(True)
	Return
End If

If wf_create_dw() <> 1 Then
//	Parent.SetRedraw(True)
	Return
End If

If wf_retrieve_dw() <> 1 Then
//	Parent.SetRedraw(True)
	Return
End If

//iuo_current_view.Hide()
uo_retrieve.Show()
iuo_current_view = uo_retrieve

Parent.Title = "���ǰ˻� - ��ȸ���"
//Parent.SetRedraw(True)

/* Last page ���ϴ� routine */
//long Li_row = 1, Ll_prev_row
//
//gi_page = 1
//
//do while true
//	ll_prev_row = Li_row
//	Li_row = uo_retrieve.dw_result.ScrollNextPage()
//	If Li_row = ll_prev_row or Li_row <= 0 then
//		exit
//	Else
//		gi_page++
//	End if
//loop

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.p_retrieve.Hide()
uo_buttons.p_clear.Hide()
uo_buttons.SetRedraw(True)

//sle_msg.text = "�ش� ����� ���� �� ������ ���÷��� Double Click�� �ϼ���.!!!"
end event

event ue_where;
If iuo_current_view = uo_where_items Then
	If wf_add_where_items() <> 1 Then Return
End If

Parent.SetRedraw(False)
uo_retrieve.Hide()

uo_retrieve_items.Enabled = False
uo_where.Enabled = True
uo_where_items.Enabled = False
	
iuo_current_view = uo_where
Parent.Title = "���ǰ˻� - ���� ����"
Parent.SetRedraw(True)

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.p_where.Hide()
uo_buttons.p_print.Hide()
uo_buttons.SetRedraw(True)

end event

event ue_retrieve_items;
If wf_make_where_clause() = 1 Then
	Parent.SetRedraw(False)
	uo_retrieve.Hide()
	
	uo_retrieve_items.Enabled = True
	uo_where.Enabled = False
	uo_where_items.Enabled = False
	
	iuo_current_view = uo_retrieve_items
	Parent.Title = "���ǰ˻� - ��ȸ�׸� ����"
	Parent.SetRedraw(True)

	uo_buttons.SetRedraw(False)
	uo_buttons.uf_show_all()
	uo_buttons.p_retrieve_items.Hide()
	uo_buttons.p_print.Hide()
	uo_buttons.SetRedraw(True)
Else
	MessageBox("Ȯ��", "���ǽ��� �ݵ�� �Է��ؾ��մϴ�.", Exclamation!)
End If

end event

event ue_where_items;
Parent.SetRedraw(False)
uo_retrieve.Hide()

uo_retrieve_items.Enabled = False
uo_where.Enabled = False
uo_where_items.Enabled = True
	
iuo_current_view = uo_where_items
Parent.Title = "���ǰ˻� - �����׸� ����"
Parent.SetRedraw(True)

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.p_where_items.Hide()
uo_buttons.p_print.Hide()
uo_buttons.SetRedraw(True)

end event

on uo_buttons.destroy
call uo_cond_qry_button_ac::destroy
end on

event ue_clear;call super::ue_clear;
uo_retrieve_items.TriggerEvent("ue_clear")
uo_where_items.TriggerEvent("ue_clear")
uo_where.TriggerEvent("ue_clear")
end event

event ue_close;close(parent)
end event

event ue_print;
openwithparm(w_print_options, uo_retrieve.dw_result)
end event

