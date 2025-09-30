$PBExportHeader$w_condition_qry.srw
$PBExportComments$** �λ� ���ǰ˻�
forward
global type w_condition_qry from w_inherite_standard
end type
type uo_buttons from uo_cond_qry_button within w_condition_qry
end type
type p_update from uo_picture within w_condition_qry
end type
type uo_where_items from uo_search_items within w_condition_qry
end type
type gb_title1 from groupbox within w_condition_qry
end type
type uo_retrieve_items from uo_search_outputs within w_condition_qry
end type
type gb_title from groupbox within w_condition_qry
end type
type uo_where from uo_search_conditions within w_condition_qry
end type
type uo_retrieve from uo_search_result within w_condition_qry
end type
type lb_qry_column from listbox within w_condition_qry
end type
type p_preview from picture within w_condition_qry
end type
end forward

global type w_condition_qry from w_inherite_standard
string title = "���� �˻�"
event ue_open ( )
event ue_print_popup pbm_custom15
event ue_retrieve pbm_custom13
event ue_retrieve_items pbm_custom12
event ue_where pbm_custom11
event ue_where_items pbm_custom10
event ue_close pbm_custom14
uo_buttons uo_buttons
p_update p_update
uo_where_items uo_where_items
gb_title1 gb_title1
uo_retrieve_items uo_retrieve_items
gb_title gb_title
uo_where uo_where
uo_retrieve uo_retrieve
lb_qry_column lb_qry_column
p_preview p_preview
end type
global w_condition_qry w_condition_qry

type variables
//uo_query_button	iuo_query_button
userobject	iuo_current_view

long		il_prevrow

//transaction	iSQLCA_main

//st_cond_qry_open_parm	ist_arg

string	iv_sql_select, iv_sql_from, iv_sql_where

integer	iv_column_count
string	iv_column_name[56]
string	iv_id, iv_title, iv_remark
string	iv_empnocloumn

string	is_select_clause, is_from_clause
string	is_where_clause, is_join_clause
string	is_sql_statement

string	is_orderby
String	is_title			//Ÿ��Ʋ�� ����� �ξ��� close�� �� ���

String print_gu                 //window�� ��ȸ���� �μ�����  


String     is_preview        // dw���°� preview����
Integer   ii_factor = 100           // ����Ʈ Ȯ�����
boolean   iv_b_down = false

char c_status


end variables

forward prototypes
public function integer wf_create_dw ()
public function string wf_get_columnname (string sgbn, string scolumnid)
public function integer wf_make_where_clause ()
public function integer wf_make_sql ()
public function integer wf_retrieve_dw ()
public function integer wf_add_where_items ()
public function integer wf_objectcheck ()
end prototypes

event ue_open;iuo_current_view = uo_where_items
is_title = this.Title

p_update.TriggerEvent(Clicked!)

this.Title = '���� �˻� - �����׸� ����'
end event

event ue_print_popup;uo_buttons.pb_print.TriggerEvent(clicked!)
end event

event ue_retrieve;uo_buttons.pb_retrieve.TriggerEvent(clicked!)





end event

event ue_retrieve_items;uo_buttons.pb_retrieve_items.TriggerEvent(clicked!)
end event

event ue_where;uo_buttons.pb_where.triggerevent(clicked!)
end event

event ue_where_items;uo_buttons.pb_where_items.triggerevent(clicked!)
end event

event ue_close;uo_buttons.pb_close.TriggerEvent(clicked!)
end event

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
		Case "empno2", "cempno2", "p7_qry_collection_empno2"
			uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".visible = 0")
			iv_empnocloumn = ls_Column_Name[i]	// Row�� ����� ���

			ls_Modify_Err = uo_retrieve.dw_result.Modify("Create compute(band=footer &
				alignment='0' expression='count( " + ls_Column_Name[i] + " for all distinct )' &
				border='0' color= '12632256' x='2200' y='5' height='300' width='1' &
				format='[GENERAL]' name=empno_count  font.face='����ü' font.height='-10' &
				font.weight='400'  font.family='1' font.pitch='1' font.charset='-127' &
				background.mode='2' background.color='12632256' ) ")
			If ls_Modify_Err <> "" Then MessageBox("DataWindow Modify Error", ls_Modify_Err)
		Case "empno", "cempno", "p7_qry_collection_empno"
			ls_Column_Title[i] = "���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width =" + String(li_unit_per_char * 6))
		Case "empname", "cempname", "p7_qry_collection_empname"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))

		Case "deptname", "cdeptname", "p7_qry_collection_deptname"
			ls_Column_Title[i] = "�ҼӺμ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "deptcode", "cdeptcode", "p7_qry_collection_deptcode"
			ls_Column_Title[i] = "�ҼӺμ�code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))
		
		Case "adddeptname", "cadddeptname", "p7_qry_collection_adddeptname"
			ls_Column_Title[i] = "��ºμ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "adddeptcode", "cadddeptcode", "p7_qry_collection_adddeptcode"
			ls_Column_Title[i] = "��ºμ�code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))
			
		Case "majorname", "cmajorname", "p7_qry_collection_majorname"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "majorcode", "cmajorcode", "p7_qry_collection_majorcode"
			ls_Column_Title[i] = "����code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))
		
		Case "gradecode", "cgradecode", "p7_qry_collection_gradecode"
			ls_Column_Title[i] = "����code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))

		Case "gradename", "cgradename", "p7_qry_collection_gradename"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "levelcode", "clevelcode", "p7_qry_collection_levelcode"
			ls_Column_Title[i] = "����code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			
		Case "levelname", "clevelname", "p7_qry_collection_levelname"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "salary", "csalary", "p7_qry_collection_salary"
			ls_Column_Title[i] = "ȣ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
		
		Case "jobkindname", "cjobkindname", "p7_qry_collection_jobkindname"
			ls_Column_Title[i] = "��å"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "kunmuname", "ckunmuname", "p7_qry_collection_kunmuname"
			ls_Column_Title[i] = "�ٹ�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "jikmuname", "cjikmuname", "p0_duty_jikmuname"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
		
		Case "newfacekind", "cnewfacekind", "p7_qry_collection_newfacekind"
			ls_Column_Title[i] = "�Ի籸��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/���~t0'")
			
		Case "servicekindcode", "cservicekindcode", "p7_qry_collection_servicekindcode"
			ls_Column_Title[i] = "���𱸺�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/����~t2/����~t3'")
			
		Case "jikjonggubn", "cjikjonggubn", "p7_qry_collection_jikjonggubn"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '������~t1/������~t2'")

		Case "paygubn", "cpaygubn", "p7_qry_collection_paygubn"
			ls_Column_Title[i] = "�޿�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '������~t1/�ϱ���~t2/������~t3'")
			
		Case "serviceyears", "cserviceyears", "p7_qry_collection_serviceyears"
			ls_Column_Title[i] = "�ٹ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "enterdate", "centerdate", "p7_qry_collection_enterdate"
			ls_Column_Title[i] = "�Ի�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "temprestdate", "ctemprestdate", "p7_qry_collection_temprestdate"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "retiredate", "cretiredate", "p7_qry_collection_retiredate"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "promotiondate", "cpromotiondate", "p7_qry_collection_promotiondate"
			ls_Column_Title[i] = "������������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "educationname", "ceducationname", "p7_qry_collection_educationname"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 18))
			
		Case "rpname", "crpname", "p7_qry_collection_rpname"
			ls_Column_Title[i] = "�������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "guaranteeenddate", "cguaranteeenddate", "p7_qry_collection_guaranteeenddate"
			ls_Column_Title[i] = "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "affiliatename", "caffiliatename", "p7_qry_collection_affiliatename"
			ls_Column_Title[i] = "���αٹ�ó"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 12))
			
		Case "passportenddate", "cpassportenddate", "p7_qry_collection_passportenddate"
			ls_Column_Title[i] = "������ȿ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "licensename", "clicensename", "p7_qry_collection_licensename"
			ls_Column_Title[i] = "�ڰ�/����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))
			
		Case "licenseupdatedate", "clicenseupdatedate", "p7_qry_collection_licenseupdatedate"
			ls_Column_Title[i] = "�ڰ�����������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "birthday", "cbirthday", "p7_qry_collection_birthday"
			ls_Column_Title[i] = "�������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "sex", "csex", "p7_qry_collection_sex"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/����~t2'")
			
		Case "religioncode", "creligioncode", "p7_qry_collection_religioncode"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '�⵶��~t1/õ�ֱ�~t2/�̽�����~t3/�ұ�~t4/����~t5/��Ÿ~t6'")
			
		Case "bornname", "cbornname", "p7_qry_collection_bornname"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "weddingtag", "cweddingtag", "p7_qry_collection_weddingtag"
			ls_Column_Title[i] = "��ȥ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '��ȥ~t1/��ȥ~t0'")
			
		Case "bloodtype", "cbloodtype", "p7_qry_collection_bloodtype"
			ls_Column_Title[i] = "������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = &
				'RH+ A~t1/RH+ B~t2/RH+ AB~t3/RH+ O~t4/RH- A~t5/RH- B~t6/RH- AB~t7/RH- O~t8/'")
				
		Case "schoolingname", "cschoolingname", "p7_qry_collection_schoolingname"
			ls_Column_Title[i] = "�����з�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
		
		Case "jhgubn", "cjhgubn", "p7_qry_collection_jhgubn"
			ls_Column_Title[i] = "���п���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~tY/    ~tN'")

		Case "jhtgubn", "cjhtgubn", "p7_qry_collection_jhtgubn"
			ls_Column_Title[i] = "�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~tY/�̰���~tN'")

		Case "jhhgubn", "cjhhgubn", "p7_qry_collection_jhhgubn"
			ls_Column_Title[i] = "�к�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~tY/������~tN'")

		Case "consmatgubn", "cconsmatgubn", "p7_qry_collection_consmatgubn"
			ls_Column_Title[i] = "����ȸ����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~tY/����~tN'")

		Case "engineergubn", "cengineergubn", "p7_qry_collection_engineergubn"
			ls_Column_Title[i] = "�������η¿���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~tY/������~tN'")
			
		Case "medingbn", "cmedingbn", "p7_qry_collection_medingbn"
			ls_Column_Title[i] = "�ǷẸ���� �ݳ�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '�ݳ�~tY/�̹ݳ�~tN'")

		Case "armyservicetag", "carmyservicetag", "p7_qry_collection_armyservicetag"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/����~t0'")
			
		Case "armykindcode", "carmykindcode", "p7_qry_collection_armykindcode"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/�ر�~t2/����~t3/�غ���~t4/��������~t5/Ư����~t6'")
			
		Case "armyclassname", "carmyclassname", "p7_qry_collection_armyclassname"
			ls_Column_Title[i] = "���"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "armyname", "carmyname", "p7_qry_collection_armyname"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "reservecode", "creservecode", "p7_qry_collection_reservecode"
			ls_Column_Title[i] = "����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '����~t1/�ؿ�(����)~t2/��1���ο�(�Կ����)~t3/��2���ο�(�ι���)~t4/���ʺ��濪(Ư�ʺ���)~t5/��Ÿ~t6/����~t7'")
			
		Case "dialoglevel1", "cdialoglevel1", "p7_qry_collection_dialoglevel1"
			ls_Column_Title[i] = "����ȸȭ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "readlevel1", "creadlevel1", "p7_qry_collection_readlevel1"
			ls_Column_Title[i] = "�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "writelevel1", "cwritelevel1", "p7_qry_collection_writelevel1"
			ls_Column_Title[i] = "�����۹�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "dialoglevel2", "cdialoglevel2", "p7_qry_collection_dialoglevel2"
			ls_Column_Title[i] = "�Ͼ�ȸȭ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "readlevel2", "creadlevel2", "p7_qry_collection_readlevel2"
			ls_Column_Title[i] = "�Ͼ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "writelevel2", "cwritelevel2", "p7_qry_collection_writelevel2"
			ls_Column_Title[i] = "�Ͼ��۹�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "dialoglevel3", "cdialoglevel3", "p7_qry_collection_dialoglevel3"
			ls_Column_Title[i] = "�Ҿ�ȸȭ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "readlevel3", "creadlevel3", "p7_qry_collection_readlevel3"
			ls_Column_Title[i] = "�Ҿ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "writelevel3", "cwritelevel3", "p7_qry_collection_writelevel3"
			ls_Column_Title[i] = "�Ҿ��۹�"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t1/�߱�~t2/�ϱ�~t3'")
			
		Case "phoneno", "cphoneno", "p7_qry_collection_phoneno"
			ls_Column_Title[i] = "��ȭ��ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "address", "caddress", "p7_qry_collection_address"
			ls_Column_Title[i] = "��  ��"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 40))
			
		Case "residentno", "cresidentno", "p7_qry_collection_residentno"
			ls_Column_Title[i] = "�ֹε�Ϲ�ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "medinsuranceno", "cmedinsuranceno", "p7_qry_collection_medinsuranceno"
			ls_Column_Title[i] = "�ǷẸ���ȣ"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 12))
		
		Case "saupcd", "csaupcd", "p7_qry_collection_saupcd"
			ls_Column_Title[i] = "�����"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '���~t10/�ƻ�~t20/������~t30'")
	End Choose

	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.Height = 530")
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.Color = " + String(RGB(192, 192, 192)))
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.selected.mouse=no")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.text='" + ls_Column_Title[i] + "'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.y='90'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.height.autosize=Yes")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.face='����ü'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.height='-10'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.weight='700'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.family='1'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.pitch='1'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.charset='-127'")

	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".font.height='-10'")

	Choose Case ls_Column_Title[i]
		Case "�Ի�����", "��������", "��������", "�������", "������ȿ����", "������������", "��������"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='@@@@.@@.@@'")
//		Case "��ȭ��ȣ"
//			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='@@@@)@@@@-@@@@'")
	End Choose

	lb_qry_Column.AddItem(ls_Column_Name[i])
	uo_retrieve_items.lb_ColumnTitle.AddItem(ls_Column_Title[i])

	iv_column_count = i
	i = i + 1
Loop

For i = 1 To iv_column_count	//////////////////// ?????????????????????
	iv_Column_Name[i] = ls_Column_Name[i]
Next

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
		Case "empno"
			sColumnName = '��� '
		Case "empname"
			sColumnName = '���� '
		Case "deptname"
			sColumnName = '�ҼӺμ� '
		Case "adddeptname"
			sColumnName = '��ºμ� '
		Case "majorname"
			sColumnName = '���� '
		Case "gradename"
			sColumnName = '���� '
		Case "levelname"
			sColumnName = '���� '
		Case "salary"
			sColumnName = 'ȣ�� '
		Case "jobkindname"
			sColumnName = '��å '
		Case "kunmuname"
			sColumnName = '�ٹ����� '
		Case "jikmuname"
			sColumnName = '���� '
		Case "servicekindcode"
			sColumnName = '���𱸺� '
		Case "jikjonggubn"
			sColumnName = '���� '
		Case "paygubn"
			sColumnName = '�޿����� '
		Case "serviceyears"
			sColumnName = '�ټӳ�� '
		Case "enterdate"
			sColumnName = '�Ի����� '
		Case "temprestdate"
			sColumnName = '�������� '
		Case "retiredate"
			sColumnName = '������� '
		Case "educationname"
			sColumnName = '�������� '
		Case "rpname"
			sColumnName = '��� '
		Case "guaranteeenddate"
			sColumnName = '�������� '
		Case "affiliatename"
			sColumnName = '����ó '
		Case "passportenddate"
			sColumnName = '���Ǹ������� '
		Case "licensename"
			sColumnName = '�ڰ�/���� '
		Case "licenseupdatedate"
			sColumnName = '�ڰ����������� '
		Case "birthday"
			sColumnName = '������� '
		Case "sex"
			sColumnName = '���� '
		Case "religioncode"
			sColumnName = '���� '
		Case "bornname"
			sColumnName = '���� '
		Case "bloodtype"
			sColumnName = '������ '
		Case "schoolingname"
			sColumnName = '�б��� '
		Case "armykindcode"
			sColumnName = '���� '
		Case "armyclassname"
			sColumnName = '��� '
		Case "armyname"
			sColumnName = '���� '
		Case "reservecode"
			sColumnName = '���� '
		Case "phoneno"
			sColumnName = '��ȭ��ȣ '
		Case "address"
			sColumnName = '�ּ� '
		Case "residentno"
			sColumnName = '�ֹε�Ϲ�ȣ '
		Case "medinsuranceno"
			sColumnName = '�ǷẸ���ȣ '
		Case "saupcd"
			sColumnName = '����� '		
	End Choose
END IF
	
Return sColumnName
end function

public function integer wf_make_where_clause ();If uo_where.uf_make_where_clause() = 1 Then
	is_where_clause = uo_where.is_where_clause
	Return 1
Else
	Return -1
end if
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

is_select_clause = is_select_clause + ", p7_qry_collection.empno empno2"

//If Len(is_join_clause) <> 0 then
//	If Len(is_where_clause) = 0 then
//		MessageBox("Ȯ��", "���ǽ��� �������� �ʾҽ��ϴ�.")
//		Return -1
//	Else
//		is_join_clause = " AND " + is_join_clause
//	End if
//End if
//
is_sql_statement = is_select_clause + is_from_clause + is_where_clause // + is_join_clause

Return 1
end function

public function integer wf_retrieve_dw ();Long	ll_rt, i

uo_retrieve.dw_result.SetTransObject(SQLCA)

ll_rt = uo_retrieve.dw_result.Retrieve()

Choose Case ll_rt
	Case 0
		uo_retrieve.st_emp_count.Text = "0"
		p_preview.enabled = False
	   p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
	Case Is > 0
		uo_retrieve.st_emp_count.Text = string(ll_rt) 
		 p_preview.enabled = true
	    p_preview.PictureName = 'C:\erpman\image\�̸�����_up.gif'
		//uo_retrieve.st_emp_count.Text = String(uo_retrieve.dw_result.GetItemNumber(1, "empno_count"))
	Case Else
		p_preview.enabled = False
	   p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
		MessageBox("Ȯ��", "�ڷ� �˻� ����!")
		Return -1
End Choose





//iSQLCA_main.AutoCommit = False

Return 1
end function

public function integer wf_add_where_items ();//	���Ǽ���(uo_where)�� �׸� DDLB�� ä���ش�.

Integer				i, imax, dindex
DropDownListBox	d[8]

imax = uo_where_items.lb_selected.TotalItems()

d[1] = uo_where.ddlb_field_1; d[2] = uo_where.ddlb_field_2
d[3] = uo_where.ddlb_field_3; d[4] = uo_where.ddlb_field_4
d[5] = uo_where.ddlb_field_5; d[6] = uo_where.ddlb_field_6
d[7] = uo_where.ddlb_field_7; d[8] = uo_where.ddlb_field_8

uo_where.uf_clear_rows(1)

If imax > 0 Then
	For dindex = 1 to 8	// 9 -> ���� ��
		d[dindex].Reset()
		For i = 1 to imax
			d[dindex].AddItem(uo_where_items.lb_selected.Text(i))
		Next
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

public function integer wf_objectcheck ();//���� ��¹��� ����(preview = yes�̸� �˻�������� �����Ѵ�)
is_preview = 'yes'

String sobject

Setnull(sObject)

sObject =uo_retrieve.dw_result.dataobject

if isnull(sObject) or trim(sObject) = '' or not uo_retrieve.dw_result.visible then
	return -1
else
	is_preview =uo_retrieve.dw_result.object.datawindow.print.preview
end if

if is_preview = 'yes' then return -1

// menu�� window�� check�Ͽ� 0�̸� skip�ϰ� 0���� ũ�� horizontalscroll�� ���
integer ipoint
String sWindow, sFindyn
sWindow = string(this)

Setnull(sfindyn)
ipoint = 0

ipoint = 0
select hpoint, findyn into :ipoint, :sfindyn from sub2_t
 where window_name = :sWindow;
 
if isnull(sfindyn) Or trim(sfindyn) = '' Or sfindyn = 'N' then
	if is_preview = 'yes' then
		return -1
	end if
end if
 
//em_split.text = string(ipoint)
//
//if ipoint > 0 then
//	dw_list.object.datawindow.horizontalscrollsplit			=	ipoint
//	dw_list.object.datawindow.horizontalscrollposition2	= 	ipoint
//end if
//
String this_class[]
windowobject the_object[]

integer i, cnt

For i = 1 to upperbound(control[])
	the_object[i]	=	control[i]
	this_class[i]	=	the_object[i].classname()
Next

// ���window�� tabl�� �ִ��� �˻��Ͽ� ������ -1�� return
// ������ ������ �˻���󿡼� �����Ѵ�.
// window���� object�� ������ ���� nameing rule�� ��ų ��
// ln_(Line), r_(Rectangle), rr_(RoundRectangle), oval_(Oval)

dragobject temp

cnt = upperbound(this.control)
for i = cnt to 1 step -1
	if Left(this_class[i], 3) = 'ln_' 	or &
		Left(this_class[i], 2) = 'r_' 		or &	
		Left(this_class[i], 3) = 'rr_' 	or &	
		Left(this_class[i], 5) = 'oval_' 	Then	Continue
		
	Temp	=	this.control[i]
	
	Choose Case TypeOf(temp)
			 Case tab!
					is_preview = 'yes'
					return -1
	End choose
Next

//em_split.enabled = true

return 1
end function

event open;call super::open;w_mdi_frame.sle_msg.text =""

dw_datetime.InsertRow(0)
uo_where_items.Border = False; uo_where.Border = False; uo_retrieve_items.Border = False; uo_retrieve.Border = False
this.postevent("ue_open")
end event

event key;Choose Case key
	Case KeyQ!
		uo_buttons.pb_retrieve.TriggerEvent(Clicked!)
	Case KeyW!
		uo_buttons.pb_print.TriggerEvent(Clicked!)
	Case KeyD!
		uo_buttons.pb_clear.TriggerEvent(Clicked!)
	Case KeyX!
		uo_buttons.pb_close.TriggerEvent(Clicked!)
End Choose
end event

on w_condition_qry.create
int iCurrent
call super::create
this.uo_buttons=create uo_buttons
this.p_update=create p_update
this.uo_where_items=create uo_where_items
this.gb_title1=create gb_title1
this.uo_retrieve_items=create uo_retrieve_items
this.gb_title=create gb_title
this.uo_where=create uo_where
this.uo_retrieve=create uo_retrieve
this.lb_qry_column=create lb_qry_column
this.p_preview=create p_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_buttons
this.Control[iCurrent+2]=this.p_update
this.Control[iCurrent+3]=this.uo_where_items
this.Control[iCurrent+4]=this.gb_title1
this.Control[iCurrent+5]=this.uo_retrieve_items
this.Control[iCurrent+6]=this.gb_title
this.Control[iCurrent+7]=this.uo_where
this.Control[iCurrent+8]=this.uo_retrieve
this.Control[iCurrent+9]=this.lb_qry_column
this.Control[iCurrent+10]=this.p_preview
end on

on w_condition_qry.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_buttons)
destroy(this.p_update)
destroy(this.uo_where_items)
destroy(this.gb_title1)
destroy(this.uo_retrieve_items)
destroy(this.gb_title)
destroy(this.uo_where)
destroy(this.uo_retrieve)
destroy(this.lb_qry_column)
destroy(this.p_preview)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" +is_title + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
w_mdi_frame.st_window.Text = ""

end event

type p_mod from w_inherite_standard`p_mod within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_del from w_inherite_standard`p_del within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_inq from w_inherite_standard`p_inq within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_print from w_inherite_standard`p_print within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_can from w_inherite_standard`p_can within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_exit from w_inherite_standard`p_exit within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_ins from w_inherite_standard`p_ins within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_search from w_inherite_standard`p_search within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_addrow from w_inherite_standard`p_addrow within w_condition_qry
boolean visible = false
integer y = 2412
end type

type p_delrow from w_inherite_standard`p_delrow within w_condition_qry
boolean visible = false
integer y = 2412
end type

type dw_insert from w_inherite_standard`dw_insert within w_condition_qry
boolean visible = false
integer x = 969
integer y = 2420
end type

type st_window from w_inherite_standard`st_window within w_condition_qry
end type

type cb_exit from w_inherite_standard`cb_exit within w_condition_qry
end type

type cb_update from w_inherite_standard`cb_update within w_condition_qry
end type

type cb_insert from w_inherite_standard`cb_insert within w_condition_qry
end type

type cb_delete from w_inherite_standard`cb_delete within w_condition_qry
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_condition_qry
end type

type st_1 from w_inherite_standard`st_1 within w_condition_qry
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_condition_qry
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_condition_qry
end type

type sle_msg from w_inherite_standard`sle_msg within w_condition_qry
end type

type gb_2 from w_inherite_standard`gb_2 within w_condition_qry
end type

type gb_1 from w_inherite_standard`gb_1 within w_condition_qry
end type

type gb_10 from w_inherite_standard`gb_10 within w_condition_qry
end type

type uo_buttons from uo_cond_qry_button within w_condition_qry
event destroy ( )
integer x = 3095
integer width = 1495
integer height = 180
integer taborder = 10
boolean bringtotop = true
boolean border = false
end type

on uo_buttons.destroy
call uo_cond_qry_button::destroy
end on

event ue_where_items;w_mdi_frame.sle_msg.text =""

Parent.SetRedraw(False)
gb_title1.visible = True
gb_title.visible = True
iuo_current_view.Hide()
uo_where_items.Show()
uo_retrieve_items.Show()
iuo_current_view = uo_where_items
Parent.Title = "���ǰ˻� - �����׸� ����"
Parent.SetRedraw(True)

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.pb_where_items.Hide()
uo_buttons.pb_print.Hide()
uo_buttons.SetRedraw(True)

end event

event ue_where;w_mdi_frame.sle_msg.text =""

If iuo_current_view = uo_where_items Then
	If wf_add_where_items() <> 1 Then Return
End If

Parent.SetRedraw(False)
gb_title1.visible = false
gb_title.visible = false
uo_retrieve.Hide()
iuo_current_view.Hide()
uo_where.Show()
iuo_current_view = uo_where
Parent.Title = "���ǰ˻� - ���� ����"
Parent.SetRedraw(True)

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.pb_where.Hide()
uo_buttons.pb_print.Hide()
uo_buttons.SetRedraw(True)

end event

event ue_retrieve_items;w_mdi_frame.sle_msg.text =""

If wf_make_where_clause() = 1 Then
	Parent.SetRedraw(False)
	gb_title1.visible = True
   gb_title.visible = True
	iuo_current_view.Hide()
	uo_retrieve_items.Show()
	uo_where_items.Show()
	iuo_current_view = uo_retrieve_items
	Parent.Title = "���ǰ˻� - ��ȸ�׸� ����"
	Parent.SetRedraw(True)

	uo_buttons.SetRedraw(False)
	uo_buttons.uf_show_all()
	uo_buttons.pb_retrieve_items.Hide()
	uo_buttons.pb_print.Hide()
	uo_buttons.SetRedraw(True)
Else
	MessageBox("Ȯ��", "���ǽ��� �ݵ�� �Է��ؾ��մϴ�.", Exclamation!)
End If

end event

event ue_retrieve;w_mdi_frame.sle_msg.text =""

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
gb_title1.visible = false
gb_title.visible = false
iuo_current_view.Hide()
uo_retrieve.Show()
iuo_current_view = uo_retrieve

Parent.Title = "���ǰ˻� - ��ȸ���"
//Parent.SetRedraw(True)

/* Last page ���ϴ� routine */
long Li_row = 1, Ll_prev_row

gi_page = 1

do while true
	ll_prev_row = Li_row
	Li_row = uo_retrieve.dw_result.ScrollNextPage()
	If Li_row = ll_prev_row or Li_row <= 0 then
		exit
	Else
		gi_page++
	End if
loop

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.pb_retrieve.Hide()
uo_buttons.pb_clear.Hide()
uo_buttons.SetRedraw(True)

//w_mdi_frame.sle_msg.text = "�ش� ����� ���� �� ������ ���÷��� Double Click�� �ϼ���.!!!"
end event

event ue_clear;call super::ue_clear;w_mdi_frame.sle_msg.text =""

iuo_current_view.TriggerEvent("ue_clear")
end event

event ue_print;w_mdi_frame.sle_msg.text =""
openwithparm(w_print_options, uo_retrieve.dw_result)
end event

event ue_close;call super::ue_close;close(parent)
end event

type p_update from uo_picture within w_condition_qry
integer x = 2793
integer y = 20
integer width = 311
integer taborder = 50
boolean bringtotop = true
string picturename = "C:\erpman\image\�ֽ��ڷ᰻��_up.gif"
end type

event clicked;IF MessageBox("Ȯ��", "�ֽ��ڷ�� ���� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN

setpointer(hourglass!)

w_mdi_frame.sle_msg.text ="���� �ڷḦ �����ϰ� �ֽ��ϴ�....."

DELETE FROM "P7_QRY_COLLECTION"  ;

IF sqlca.sqlcode >= 0 THEN			
	COMMIT USING sqlca;
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	Return
END IF

w_mdi_frame.sle_msg.text ="�ֽ��ڷ�� �����ϰ� �ֽ��ϴ�....."
  
INSERT INTO "P7_QRY_COLLECTION"  
	( "COMPANYCODE",   	"EMPNO",   			"EMPNAME",   		 "RESIDENTNO",   "MEDINSURANCENO",   
	  "DEPTCODE",   		"DEPTNAME", 		"SAUPCD",          "GRADECODE",       "GRADENAME",     "GRADETAG",
	  "LEVELCODE",       "LEVELNAME",   		"SALARY",   	"JOBKINDCODE", 	 "JOBKINDNAME", 
	  "DUTYCODE",  	  "SERVICEKINDCODE","EMPLOYMENTCODE",  "EMPLOYMENTNAME", "ENTERDATE",   
     "TEMPRESTDATE", "RETIREDATE",       "PROMOTIONDATE",   "SERVICEYEARS",   "LABORUNIONTAG",
	  "BIRTHDAY",     "BORNCODE",         "BORNNAME",        "SEX",   				"ADDRESS",   	
	  "PHONENO",   		 "RELIGIONCODE", "ARMYSERVICETAG",  "ARMYKINDCODE",    "ARMYCLASSCODE", 
	  "ARMYCLASSNAME",	 "ARMYCODE",     "ARMYNAME",        "BLOODTYPE",   	"PASSPORTENDDATE",
     "GUARANTEEENDDATE","SCHOOLINGCODE","SCHOOLINGNAME",    "SCHOOLCODE",   	"SCHOOLNAME", 
     "LANGUAGECODE1",   "LANGUAGENAME1","DIALOGLEVEL1",     "READLEVEL1",   	"WRITELEVEL1",
     "LANGUAGECODE2",   "LANGUAGENAME2","DIALOGLEVEL2",     "READLEVEL2",   	"WRITELEVEL2", 
     "LANGUAGECODE3",   "LANGUAGENAME3","DIALOGLEVEL3",     "READLEVEL3",   	"WRITELEVEL3",
     "WEDDINGTAG",   	 "RPCODE",   	  "RPNAME",          "LICENSECODE",   	"LICENSENAME",
     "LICENSEUPDATEDATE","AFFILIATECODE","AFFILIATENAME",   "EDUCATIONCODE",  "EDUCATIONNAME",  
     "EMPLOYEEKIND",    "MAJORCODE",   	  "MAJORNAME",		   "PQLEVEL"  ,   "JIKMUGUBN",
	  "JIKMUNAME",			"KUNMUGUBN",		"KUNMUNAME",		  "JIKJONGGUBN",	"ADDDEPTCODE",
	  "ADDDEPTNAME",		"PAYGUBN",			"JHGUBN",			  "JHTGUBN",		"JHHGUBN",
	  "CONSMATGUBN",		"SPONSENDDATE",   "RESERVECODE",		  "MEDINGBN",     "ENGINEERGUBN",
	  "NEWFACEKIND")  
SELECT  distinct "P1_MASTER"."COMPANYCODE",   
		"P1_MASTER"."EMPNO",                                         /*�����ȣ*/
		"P1_MASTER"."EMPNAME",                                       /*�����*/ 
		"P1_MASTER"."RESIDENTNO1"||'-'||"P1_MASTER"."RESIDENTNO2",   /*�ֹι�ȣ*/
		"P1_MASTER"."MEDINSURANCENO",                                /*�Ƿ��ȣ*/ 
		"P1_MASTER"."DEPTCODE",                                      /*�μ��ڵ�*/ 
		"P0_DEPT"."DEPTNAME2",                                       /*�μ���*/
		"P0_DEPT"."SAUPCD",                                          /*�����*/
		"P1_MASTER"."GRADECODE",                                     /*�����ڵ�*/
		"P0_GRADE"."GRADENAME",                                      /*������*/ 
		' ',
		"P1_MASTER"."LEVELCODE",                                     /*�����ڵ�*/ 
		"P0_LEVEL"."LEVELNAME",                                      /*���޸�*/
		"P1_MASTER"."SALARY",                                        /*ȣ��*/ 
		"P1_MASTER"."JOBKINDCODE",                                   /*��å�ڵ�?*/
		"P0_JOBKIND"."JOBKINDNAME",                                  /*��å��*/
		"P1_MASTER"."DUTYCODE",
		"P1_MASTER"."SERVICEKINDCODE",                               /*���𱸺� ex)1:����*/
		"P1_MASTER"."EMPLOYMENTCODE",                                /*ä�뱸��*/
		"P0_EMPLOYMENT"."EMPLOYMENTNAME",                            /*ä�뱸�и�*/
		"P1_MASTER"."ENTERDATE",                                     /*�Ի���*/ 
		"P1_MASTER"."TEMPRESTDATE",                                  /*������*/
		"P1_MASTER"."RETIREDATE",                                    /*������*/
		"P1_MASTER"."PROMOTIONDATE",                                 /*������*/
      FUN_CALC_YEAR_CNT(SUBSTR("P1_MASTER"."ENTERDATE",1,4),       /*�ټӳ��*/
								SUBSTR("P1_MASTER"."ENTERDATE",5,2),
							   SUBSTR("P1_MASTER"."ENTERDATE",7,2),
			SUBSTR(DECODE("P1_MASTER"."SERVICEKINDCODE",'3',"P1_MASTER"."RETIREDATE",TO_CHAR(SYSDATE,'YYYYMMDD')),1,4),
			SUBSTR(DECODE("P1_MASTER"."SERVICEKINDCODE",'3',"P1_MASTER"."RETIREDATE",TO_CHAR(SYSDATE,'YYYYMMDD')),5,2),
			SUBSTR(DECODE("P1_MASTER"."SERVICEKINDCODE",'3',"P1_MASTER"."RETIREDATE",TO_CHAR(SYSDATE,'YYYYMMDD')),7,2),'Y') ,
		"P1_MASTER"."LABORUNIONTAG" ,						
		"P1_MASTER"."BIRTHDAY",                                      /*����*/ 
		a.boncd,                                                     /*�����*/
		a.bonnm,                                                     /*�������*/
		substr("P1_MASTER"."RESIDENTNO2", 1, 1),                     /*��������*/
		a.addr1||' '||a.addr2,                                       /*�ּ�*/
		a.phone,                                                     /*��ȭ��ȣ*/ 
		a.relcd,                                                     /*�����ڵ�*/ 
      decode(b.armyno, null,decode(substr("P1_MASTER"."RESIDENTNO2",1,1),'1',0,''),1), /*���ʿ���*/  
		b.armykind,                                                  /*����*/
		b.classcd,                                                   /*����ڵ�*/ 
		b.classnm,                                                   /*��޸�*/ 
		b.armycd,                                                    /*�����ڵ�*/ 
		b.armynm,                                                    /*������*/
		physique.bloodtype,                                          /*������*/
		passports.validityend,                                       /*���Ǹ�����*/
		c.gradate,                                                   /*��������*/
		c.schoolingcd,                                               /*�з��ڵ�*/
		c.schoolingnm,                                               /*�з�*/
		c.schoolcd,                                                  /*�����б�*/
		c.schoolnm,                                                  /*�����б���*/
		
		d1.languagecd,                                                /*�ܱ���1*/
		d1.languagenm,                                                /*�ܱ����1*/ 
		d1.dialevel,                                                  /*ȸȭ1*/
		d1.relevel,                                                   /*����1*/
		d1.wrilevel,                                                  /*���۹�1*/
		
		d2.languagecd,                                                /*�ܱ���2*/
		d2.languagenm,                                                /*�ܱ����2*/ 
		d2.dialevel,                                                  /*ȸȭ2*/
		d2.relevel,                                                   /*����2*/
		d2.wrilevel,                                                  /*���۹�2*/
				
		d3.languagecd,                                                /*�ܱ���3*/
		d3.languagenm,                                                /*�ܱ����3*/ 
		d3.dialevel,                                                  /*ȸȭ3*/
		d3.relevel,                                                   /*����3*/
		d3.wrilevel,                                                  /*���۹�3*/
		
		a.wedtag,                                                    /*��ȥ����*/      
		h.rpcd,                                                      /*����ڵ�*/ 
		h.rpnm,                                                      /*�����*/
		e.licensecd,                                                 /*�ڰ����ڵ�*/
		e.licensenm,                                                 /*�ڰ�����*/
		e.updatedate,                                                /*�ڰ���������*/
		f.affcd,                                                     /*����ó�ڵ�*/
		f.affnm,                                                     /*����ó��*/
		g.educd,                                                     /*�����ڵ�*/
		g.edunm,                                                     /*������*/
		'',
		c.majorcd,                                                   /*�����ڵ�*/
		c.majornm,                                                   /*������*/
		'',
		"P1_MASTER"."JIKMUGUBN",												 /*��������*/
		"P0_JIKMU"."JIKMUNAME",													 /*�������и�*/
		"P1_MASTER"."KUNMUGUBN",												 /*�ٹ�����*/
		"P0_KUNMU"."KUNMUNAME",													 /*�ٹ����и�*/
		"P1_MASTER"."JIKJONGGUBN",												 /*��������*/
		"P1_MASTER"."ADDDEPTCODE",												 /*��ºμ�*/
		FUN_GET_DPTNO("P1_MASTER"."ADDDEPTCODE")	,						 /*��ºμ���*/
		"P1_MASTER"."PAYGUBN",													 /*�޿�����*/
		"P1_MASTER"."JHGUBN",													 /*���п���*/
		"P1_MASTER"."JHTGUBN",												    /*��ð�����*/
		"P1_MASTER"."JHHGUBN",												    /*�к�����*/
		"P1_MASTER"."CONSMATGUBN",												 /*����ȸ���Կ���*/
		"P1_GUARANTEE"."ENDDATE",												 /*������������*/
		b.resercode,																 /*����*/
		"P1_MASTER"."MEDINGBN",													 /*�ǷẸ���� �ݳ�����*/
		"P1_MASTER"."ENGINEERGUBN",											 /*�������η¿���*/
		"P1_MASTER"."NEWFACEKIND"												 /*�Ի籸��(����/���)*/
 FROM "P1_MASTER",   
		"P0_DEPT",   
		"P0_GRADE",   
		"P0_LEVEL",   
		"P0_JOBKIND",   
		"P0_EMPLOYMENT", 
		"P0_KUNMU",
		"P0_JIKMU",
		"P1_GUARANTEE",
		( select "P1_ETC"."COMPANYCODE" as com,   
					"P1_ETC"."EMPNO" as emp,   
					"P1_ETC"."BORNCODE" as boncd,   
					"P0_BORN"."BORNNAME" as bonnm,   
					"P1_ETC"."WEDDINGTAG" as wedtag,   
					"P1_ETC"."ADDRESS21" as addr1,   
					"P1_ETC"."ADDRESS22" as addr2,   
					"P1_ETC"."PHONENO2" as phone,   
					"P1_ETC"."RELIGIONCODE" as relcd   
			 from "P1_ETC", "P0_BORN"
			where "P1_ETC"."BORNCODE" = "P0_BORN"."BORNCODE" (+)) a, 
			
		( select "P1_MILITARY"."COMPANYCODE" as com,   
					"P1_MILITARY"."EMPNO" as emp,   
					"P1_MILITARY"."ARMYNO" as armyno,
					"P1_MILITARY"."RESERVECODE" as resercode,
					"P1_MILITARY"."ARMYKINDCODE" as armykind,    
					"P1_MILITARY"."ARMYCODE" as armycd,   
					"P1_MILITARY"."CLASSCODE" as classcd,   
					"P0_ARMY"."ARMYNAME" as armynm,   
					"P0_CLASS"."CLASSNAME" as classnm 
			 from "P1_MILITARY", "P0_ARMY", "P0_CLASS"   
			where ( "P1_MILITARY"."ARMYCODE" = "P0_ARMY"."ARMYCODE" (+)) and  
					( "P1_MILITARY"."CLASSCODE" = "P0_CLASS"."CLASSCODE" (+))) b,  
		(select a.companycode, a.empno,a.bloodtype from p1_physique a, 
          (select companycode, empno, max(medicaldate) as medicaldate 
           from p1_physique  
           group by companycode, empno) b
          where a.companycode = b.companycode and
                a.empno = b.empno and
                a.medicaldate = b.medicaldate ) physique,   
		(select "P1_PASSPORTS"."COMPANYCODE","P1_PASSPORTS"."EMPNO",
               max("P1_PASSPORTS"."VALIDITYEND") as validityend
       from   "P1_PASSPORTS"
       group by "P1_PASSPORTS"."COMPANYCODE","P1_PASSPORTS"."EMPNO" ) passports, 
		( select "P1_SCHOOLING"."COMPANYCODE" as com,   
					"P1_SCHOOLING"."EMPNO" as emp,   
					"P1_SCHOOLING"."SCHOOLINGCODE" as schoolingcd,   
					"P1_SCHOOLING"."SCHOOLCODE" as schoolcd,   
					"P0_SCHOOLING"."SCHOOLINGNAME" as schoolingnm,   
					"P0_SCHOOL"."SCHOOLNAME" as schoolnm,
					"P1_SCHOOLING"."MAJORCODE" as majorcd,   
					"P0_MAJOR"."MAJORNAME" as majornm,   
					"P1_SCHOOLING"."GRADUATEDATE" as gradate
			 from "P1_SCHOOLING", 
					( select "P1_SCHOOLING"."COMPANYCODE" as compy,   
								"P1_SCHOOLING"."EMPNO" as empy, 
								max("P1_SCHOOLING"."GRADUATEDATE") as gdate     
						 from "P1_SCHOOLING"    
						where "P1_SCHOOLING"."FINALSCHOOLTAG" = 'Y' 
					group by "P1_SCHOOLING"."COMPANYCODE" ,   
								"P1_SCHOOLING"."EMPNO" ) x, 
					"P0_SCHOOL", 
					"P0_SCHOOLING",
					"P0_MAJOR"     
			where ( "P1_SCHOOLING"."COMPANYCODE" = x.compy ) and  
					( "P1_SCHOOLING"."EMPNO" = x.empy ) and  
					( "P1_SCHOOLING"."GRADUATEDATE" = x.gdate ) and 
					("P1_SCHOOLING"."FINALSCHOOLTAG" = 'Y')  and 
					( "P1_SCHOOLING"."SCHOOLCODE" = "P0_SCHOOL"."SCHOOLCODE" (+)) and  
					( "P1_SCHOOLING"."SCHOOLINGCODE" = "P0_SCHOOLING"."SCHOOLINGCODE" (+)) and
					( "P1_SCHOOLING"."MAJORCODE" = "P0_MAJOR"."MAJORCODE" (+)))c,  

		( select "P1_LANGUAGE"."COMPANYCODE" as com,   
					"P1_LANGUAGE"."EMPNO" as emp,   
					"P1_LANGUAGE"."LANGUAGECODE" as languagecd,   
					"P0_LANGUAGE"."LANGUAGENAME" as languagenm,   
					"P1_LANGUAGE"."DIALOGLEVEL" as dialevel,   
					"P1_LANGUAGE"."READLEVEL" as relevel,   
					"P1_LANGUAGE"."WRITELEVEL" as wrilevel  
			 from "P1_LANGUAGE",
					"P0_LANGUAGE"  
			where ("P1_LANGUAGE"."LANGUAGECODE" = "P0_LANGUAGE"."LANGUAGECODE" (+)) AND 
               ("P1_LANGUAGE"."LANGUAGECODE" = '1')) d1,  /* LANGUAGECODE = '1' ���*/
					
		( select "P1_LANGUAGE"."COMPANYCODE" as com,   
					"P1_LANGUAGE"."EMPNO" as emp,   
					"P1_LANGUAGE"."LANGUAGECODE" as languagecd,   
					"P0_LANGUAGE"."LANGUAGENAME" as languagenm,   
					"P1_LANGUAGE"."DIALOGLEVEL" as dialevel,   
					"P1_LANGUAGE"."READLEVEL" as relevel,   
					"P1_LANGUAGE"."WRITELEVEL" as wrilevel  
			 from "P1_LANGUAGE",
					"P0_LANGUAGE"  
			where ("P1_LANGUAGE"."LANGUAGECODE" = "P0_LANGUAGE"."LANGUAGECODE" (+)) AND 
               ("P1_LANGUAGE"."LANGUAGECODE" = '2')) d2,  /* LANGUAGECODE = '1' ���*/
					
		( select "P1_LANGUAGE"."COMPANYCODE" as com,   
					"P1_LANGUAGE"."EMPNO" as emp,   
					"P1_LANGUAGE"."LANGUAGECODE" as languagecd,   
					"P0_LANGUAGE"."LANGUAGENAME" as languagenm,   
					"P1_LANGUAGE"."DIALOGLEVEL" as dialevel,   
					"P1_LANGUAGE"."READLEVEL" as relevel,   
					"P1_LANGUAGE"."WRITELEVEL" as wrilevel  
			 from "P1_LANGUAGE",
					"P0_LANGUAGE"  
			where ("P1_LANGUAGE"."LANGUAGECODE" = "P0_LANGUAGE"."LANGUAGECODE" (+)) AND 
               ("P1_LANGUAGE"."LANGUAGECODE" = '3')) d3,  /* LANGUAGECODE = '1' ���*/			
					
		( select "P1_LICENSE"."COMPANYCODE" as com,   
					"P1_LICENSE"."EMPNO" as emp,   
					"P1_LICENSE"."LICENSECODE" as licensecd,   
					"P0_LICENSE"."LICENSENAME" as licensenm,    
					"P1_LICENSE"."UPDATEDATE" as updatedate  
			 from "P1_LICENSE",
					(select "P1_LICENSE"."COMPANYCODE" as com,   
							  "P1_LICENSE"."EMPNO" as emp,   
							  min("P1_LICENSE"."LICENSECODE") as licensecd   
						from "P1_LICENSE"  
				  group by "P1_LICENSE"."COMPANYCODE" ,   
							  "P1_LICENSE"."EMPNO") z,
					"P0_LICENSE"  
			where ("P1_LICENSE"."COMPANYCODE" = z.com ) and 
					("P1_LICENSE"."EMPNO" = z.emp ) and 
					("P1_LICENSE"."LICENSECODE" = z.licensecd ) and  
					("P1_LICENSE"."LICENSECODE" = "P0_LICENSE"."LICENSECODE" (+)))e, 
		( select "P1_AFFILIATES"."COMPANYCODE" as com,   
					"P1_AFFILIATES"."EMPNO" as emp,   
					"P1_AFFILIATES"."AFFILIATECODE" as affcd, 
					"P0_AFFILIATE"."AFFILIATENAME" as affnm 
			 from "P1_AFFILIATES", "P0_AFFILIATE",   
					( select "P1_AFFILIATES"."COMPANYCODE" as compy,   
								"P1_AFFILIATES"."EMPNO" as empy, 
								MIN("P1_AFFILIATES"."SEQ") as seq     
						 from "P1_AFFILIATES"    
					group by "P1_AFFILIATES"."COMPANYCODE" ,   
								"P1_AFFILIATES"."EMPNO" ) v 
			where ( "P1_AFFILIATES"."COMPANYCODE" = v.compy ) and
					( "P1_AFFILIATES"."EMPNO" = v.empy ) and 
					( "P1_AFFILIATES"."SEQ" = v.seq ) and 
					( "P1_AFFILIATES"."AFFILIATECODE" = "P0_AFFILIATE"."AFFILIATECODE" (+)))f, 
					
		( select "P5_EDUCATIONS_S"."COMPANYCODE" as com,   
					"P5_EDUCATIONS_S"."EDUEMPNO" as emp,   
					"P5_EDUCATIONS_S"."EKIND" as educd, 
					"P0_EDUCATION"."EDUCATIONNAME" as edunm,
					"P5_EDUCATIONS_S"."STRTDATE" as startdate
			 from "P5_EDUCATIONS_S", "P0_EDUCATION",
			 		(select "P5_EDUCATIONS_S"."COMPANYCODE" as compy,
					 		  "P5_EDUCATIONS_S"."EDUEMPNO" as empy,
							  MAX("P5_EDUCATIONS_S"."STRTDATE") as stdate
						from "P5_EDUCATIONS_S"
						group by "P5_EDUCATIONS_S"."COMPANYCODE" ,   
								"P5_EDUCATIONS_S"."EDUEMPNO") z
			where ("P5_EDUCATIONS_S"."COMPANYCODE" = z.compy) and
					("P5_EDUCATIONS_S"."EDUEMPNO" = z.empy) and
					("P5_EDUCATIONS_S"."STRTDATE" = z.stdate) and
					( "P5_EDUCATIONS_S"."EKIND" = "P0_EDUCATION"."EDUCATIONCODE" (+)))g,		
					
		( select "P1_REWARDS"."COMPANYCODE" as com,   
					"P1_REWARDS"."EMPNO" as emp,   
					"P1_REWARDS"."RPCODE" as rpcd, 
					"P0_REWARD"."RPNAME" as rpnm 
			 from "P1_REWARDS", "P0_REWARD",   
					( select "P1_REWARDS"."COMPANYCODE" as compy,   
								"P1_REWARDS"."EMPNO" as empy, 
								MAX("P1_REWARDS"."RPOCCURDATE") as rpdate,
                        MAX("P1_REWARDS"."SEQ") AS SEQ          
						 from "P1_REWARDS"    
					group by "P1_REWARDS"."COMPANYCODE" ,   
								"P1_REWARDS"."EMPNO" ) y 
			where ( "P1_REWARDS"."COMPANYCODE" = y.compy ) and
					( "P1_REWARDS"."EMPNO" = y.empy ) and 
					( "P1_REWARDS"."RPOCCURDATE" = y.rpdate ) and 
					( "P1_REWARDS"."SEQ" = y.seq ) and
					( "P1_REWARDS"."RPCODE" = "P0_REWARD"."RPCODE" (+)))h
			
WHERE ( p1_master.companycode = p0_dept.companycode (+)) and  
		( p1_master.deptcode = p0_dept.deptcode (+)) and  
		( p1_master.gradecode = p0_grade.gradecode (+)) and  
		( p1_master.levelcode = p0_level.levelcode (+)) and  
		( p1_master.jobkindcode = p0_jobkind.jobkindcode (+)) and  
		( p1_master.jikmugubn = p0_jikmu.jikmugubn (+)) and
		( p1_master.kunmugubn = p0_kunmu.kunmugubn (+)) and
		( p1_master.employmentcode = p0_employment.employmentcode (+)) and  
		( p1_master.companycode = physique.companycode (+)) and  
		( p1_master.empno = physique.empno (+)) and  
		( p1_master.companycode = passports.companycode (+)) and  
		( p1_master.empno = passports.empno (+)) and  
		( p1_master.companycode = p1_guarantee.companycode (+)) and  
		( p1_master.empno = p1_guarantee.empno (+)) and  
		( p1_master.companycode = a.com (+)) and  
		( p1_master.empno = a.emp (+)) and  
		( p1_master.companycode = b.com (+)) and  
		( p1_master.empno = b.emp (+)) and  
		( p1_master.companycode = c.com (+)) and  
		( p1_master.empno = c.emp (+)) and  
		( p1_master.companycode = d1.com (+)) and  
		( p1_master.empno = d1.emp (+)) and

		( p1_master.companycode = d2.com (+)) and  
		( p1_master.empno = d2.emp (+)) and
		( p1_master.companycode = d3.com (+)) and  
		( p1_master.empno = d3.emp (+)) and

		( p1_master.companycode = e.com (+)) and  
		( p1_master.empno = e.emp (+)) and
		( p1_master.companycode = f.com (+)) and  
		( p1_master.empno = f.emp (+)) and
		( p1_master.companycode = g.com (+)) and  
		( p1_master.empno = g.emp (+)) and
		( p1_master.companycode = h.com (+)) and  
		( p1_master.empno = h.emp (+)) ;

IF sqlca.sqlcode >= 0 THEN			
	COMMIT USING sqlca;
	w_mdi_frame.sle_msg.text ="�ֽ��ڷ�� �����Ͽ����ϴ�!!"
ELSE
	ROLLBACK USING sqlca;
   w_mdi_frame.sle_msg.text =" "
	Return
END IF

setpointer(arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ֽ��ڷ᰻��_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ֽ��ڷ᰻��_up.gif"
end event

type uo_where_items from uo_search_items within w_condition_qry
event destroy ( )
integer x = 489
integer y = 252
integer width = 3406
integer height = 844
integer taborder = 30
boolean bringtotop = true
borderstyle borderstyle = styleraised!
end type

on uo_where_items.destroy
call uo_search_items::destroy
end on

on ue_clear;call uo_search_items::ue_clear;
lb_where_item.Reset()

end on

type gb_title1 from groupbox within w_condition_qry
integer x = 466
integer y = 208
integer width = 3451
integer height = 920
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "�����׸�"
end type

type uo_retrieve_items from uo_search_outputs within w_condition_qry
event destroy ( )
integer x = 475
integer y = 1208
integer width = 3401
integer height = 916
integer taborder = 50
borderstyle borderstyle = stylelowered!
end type

on uo_retrieve_items.destroy
call uo_search_outputs::destroy
end on

on ue_clear;call uo_search_outputs::ue_clear;
lb_output_item.Reset()
lb_columnname.Reset()

lb_qry_column.Reset()
lb_columntitle.Reset()

end on

type gb_title from groupbox within w_condition_qry
integer x = 466
integer y = 1128
integer width = 3451
integer height = 1048
integer taborder = 490
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "��ȸ�׸�"
end type

type uo_where from uo_search_conditions within w_condition_qry
event destroy ( )
integer x = 498
integer y = 252
integer width = 3392
integer height = 1836
integer taborder = 40
end type

on uo_where.destroy
call uo_search_conditions::destroy
end on

type uo_retrieve from uo_search_result within w_condition_qry
event ue_sort_text pbm_custom03
event destroy ( )
integer x = 485
integer y = 252
integer width = 3415
integer height = 1864
integer taborder = 40
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

on uo_retrieve.destroy
call uo_search_result::destroy
end on

event ue_sort;st_cond_qry_sort_parm	lst_sort_parm

lst_sort_parm.lb_columnname = lb_qry_column
lst_sort_parm.lb_columntitle = uo_retrieve_items.lb_columntitle

OpenWithParm(w_condition_qry_sort, lst_sort_parm)
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

event ue_dw_dblclicked;String		ls_empno
Long		ll_row

ll_row = dw_result.GetRow()
//If ll_row > 0 Then
//	sle_msg.text = "�ش� ����� ���� ������ ���÷��� Double Click�� �ϼ���.!!!"
//	ls_empno = dw_result.GetItemString(ll_row, iv_empnocloumn)
//	OpenWithParm(w_piz1105, ls_empno)
//End If
//
end event

type lb_qry_column from listbox within w_condition_qry
boolean visible = false
integer x = 3936
integer y = 2008
integer width = 585
integer height = 148
integer taborder = 60
boolean bringtotop = true
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

type p_preview from picture within w_condition_qry
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 2610
integer y = 20
integer width = 178
integer height = 144
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\preview.cur"
boolean enabled = false
string picturename = "C:\erpman\image\�̸�����_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;IF This.Enabled = True THEN
	PictureName = 'C:\erpman\image\�̸�����_dn.gif'
END IF

end event

event ue_lbuttonup;IF This.Enabled = True THEN
	PictureName =  'C:\erpman\image\�̸�����_up.gif'
END IF
end event

event clicked;OpenWithParm(w_print_preview, uo_retrieve.dw_result)	

end event

