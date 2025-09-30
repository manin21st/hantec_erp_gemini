$PBExportHeader$w_condition_qry_vw.srw
$PBExportComments$** 인사 조건검색
forward
global type w_condition_qry_vw from w_inherite_standard
end type
type uo_buttons from uo_cond_qry_button within w_condition_qry_vw
end type
type gb_title1 from groupbox within w_condition_qry_vw
end type
type gb_title from groupbox within w_condition_qry_vw
end type
type lb_qry_column from listbox within w_condition_qry_vw
end type
type uo_where_items_vw from uo_search_items_vw within w_condition_qry_vw
end type
type uo_retrieve_items_vw from uo_search_outputs_vw within w_condition_qry_vw
end type
type uo_where from uo_search_conditions_vw within w_condition_qry_vw
end type
type uo_retrieve from uo_search_result within w_condition_qry_vw
end type
end forward

global type w_condition_qry_vw from w_inherite_standard
string title = "조건 검색"
event ue_open ( )
event ue_print_popup pbm_custom15
event ue_retrieve pbm_custom13
event ue_retrieve_items pbm_custom12
event ue_where pbm_custom11
event ue_where_items pbm_custom10
event ue_close pbm_custom14
uo_buttons uo_buttons
gb_title1 gb_title1
gb_title gb_title
lb_qry_column lb_qry_column
uo_where_items_vw uo_where_items_vw
uo_retrieve_items_vw uo_retrieve_items_vw
uo_where uo_where
uo_retrieve uo_retrieve
end type
global w_condition_qry_vw w_condition_qry_vw

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
String	is_title			//타이틀을 기억해 두었다 close할 때 사용

String print_gu                 //window가 조회인지 인쇄인지  


String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
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
end prototypes

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

//유db 추가(98/09/12)
string sand
int    ilen

ilen = len(is_sql_statement)

sand = right(is_sql_statement, 4) 

if sand = 'And)' OR sand = ' Or)' then 
	is_sql_statement = left(is_sql_statement, ilen - 4) + ')'
end if	

ls_dw_syntax = SQLCA.SyntaxFromSQL(is_sql_statement, ls_dw_style, ls_dw_err)
If ls_dw_err <> "" Then
	MessageBox("자료 확인", ls_dw_err)
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
uo_retrieve_items_vw.lb_ColumnTitle.Reset()

i = 1
Do While Not IsNull(ls_Column_Name[i])
	Choose Case ls_Column_Name[i]
		Case "empno2", "cempno2", "vw_p7_qry_collection_empno2"
			uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".visible = 0")
			iv_empnocloumn = ls_Column_Name[i]	// Row의 사번을 기억

			ls_Modify_Err = uo_retrieve.dw_result.Modify("Create compute(band=footer &
				alignment='0' expression='count( " + ls_Column_Name[i] + " for all distinct )' &
				border='0' color= '12632256' x='2200' y='5' height='300' width='1' &
				format='[GENERAL]' name=empno_count  font.face='굴림체' font.height='-10' &
				font.weight='400'  font.family='1' font.pitch='1' font.charset='-127' &
				background.mode='2' background.color='12632256' ) ")
			If ls_Modify_Err <> "" Then MessageBox("DataWindow Modify Error", ls_Modify_Err)
		Case "empno", "cempno", "vw_p7_qry_collection_empno"
			ls_Column_Title[i] = "사번"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width =" + String(li_unit_per_char * 6))
		Case "empname", "cempname", "vw_p7_qry_collection_empname"
			ls_Column_Title[i] = "성명"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))

		Case "deptname", "cdeptname", "vw_p7_qry_collection_deptname"
			ls_Column_Title[i] = "소속부서"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
		
	   Case "saupname", "csaupname", "vw_p7_qry_collection_saupname"
			ls_Column_Title[i] = "사업장"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 12))
			
		Case "deptcode", "cdeptcode", "vw_p7_qry_collection_deptcode"
			ls_Column_Title[i] = "소속부서code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))
		
		Case "adddeptname", "cadddeptname", "vw_p7_qry_collection_adddeptname"
			ls_Column_Title[i] = "출력부서"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "adddeptcode", "cadddeptcode", "vw_p7_qry_collection_adddeptcode"
			ls_Column_Title[i] = "출력부서code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))
			
		Case "majorname", "cmajorname", "vw_p7_qry_collection_majorname"
			ls_Column_Title[i] = "전공"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 15))
			
		Case "majorcode", "cmajorcode", "vw_p7_qry_collection_majorcode"
			ls_Column_Title[i] = "전공code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))
		
		Case "gradecode", "cgradecode", "vw_p7_qry_collection_gradecode"
			ls_Column_Title[i] = "직위code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(0))

		Case "gradename", "cgradename", "vw_p7_qry_collection_gradename"
			ls_Column_Title[i] = "직위"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "levelcode", "clevelcode", "vw_p7_qry_collection_levelcode"
			ls_Column_Title[i] = "직급code"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			
		Case "levelname", "clevelname", "vw_p7_qry_collection_levelname"
			ls_Column_Title[i] = "직급"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "salary", "csalary", "vw_p7_qry_collection_salary"
			ls_Column_Title[i] = "호봉"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
		
		Case "jobkindname", "cjobkindname", "vw_p7_qry_collection_jobkindname"
			ls_Column_Title[i] = "직책"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "kunmuname", "ckunmuname", "vw_p7_qry_collection_kunmuname"
			ls_Column_Title[i] = "근무구분"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "jikmuname", "cjikmuname", "p0_duty_jikmuname"
			ls_Column_Title[i] = "직무"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
		
		Case "newfacekind", "cnewfacekind", "vw_p7_qry_collection_newfacekind"
			ls_Column_Title[i] = "입사구분"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '신입~t1/경력~t0'")
			
		Case "servicekindcode", "cservicekindcode", "vw_p7_qry_collection_servicekindcode"
			ls_Column_Title[i] = "입퇴구분"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '재직~t1/휴직~t2/퇴직~t3'")
			
		Case "jikjonggubn", "cjikjonggubn", "vw_p7_qry_collection_jikjonggubn"
			ls_Column_Title[i] = "직종"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '관리직~t1/생산직~t2'")
			
      Case "jikjongname", "cjikjongname", "vw_p7_qry_collection_jikjongname"
			ls_Column_Title[i] = "직종"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "paygubn", "cpaygubn", "vw_p7_qry_collection_paygubn"
			ls_Column_Title[i] = "급여구분"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '월급자~t1/일급자~t2/연봉자~t3'")
			
		Case "serviceyears", "cserviceyears", "vw_p7_qry_collection_serviceyears"
			ls_Column_Title[i] = "근무년수"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "enterdate", "centerdate", "vw_p7_qry_collection_enterdate"
			ls_Column_Title[i] = "입사일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "temprestdate", "ctemprestdate", "vw_p7_qry_collection_temprestdate"
			ls_Column_Title[i] = "휴직일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "retiredate", "cretiredate", "vw_p7_qry_collection_retiredate"
			ls_Column_Title[i] = "퇴직일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "promotiondate", "cpromotiondate", "vw_p7_qry_collection_promotiondate"
			ls_Column_Title[i] = "최종승진일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "educationname", "ceducationname", "vw_p7_qry_collection_educationname"
			ls_Column_Title[i] = "교육사항"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 18))
			
		Case "rpname", "crpname", "vw_p7_qry_collection_rpname"
			ls_Column_Title[i] = "상벌사항"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "guaranteeenddate", "cguaranteeenddate", "vw_p7_qry_collection_guaranteeenddate"
			ls_Column_Title[i] = "졸업일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "affiliatename", "caffiliatename", "vw_p7_qry_collection_affiliatename"
			ls_Column_Title[i] = "지인근무처"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 12))
			
		Case "passportenddate", "cpassportenddate", "vw_p7_qry_collection_passportenddate"
			ls_Column_Title[i] = "여권유효일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "licensename", "clicensename", "vw_p7_qry_collection_licensename"
			ls_Column_Title[i] = "자격/면허"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 20))
			
		Case "licenseupdatedate", "clicenseupdatedate", "vw_p7_qry_collection_licenseupdatedate"
			ls_Column_Title[i] = "자격증갱신일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "birthday", "cbirthday", "vw_p7_qry_collection_birthday"
			ls_Column_Title[i] = "생년월일"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "sex", "csex", "vw_p7_qry_collection_sex"
			ls_Column_Title[i] = "성별"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '남성~t1/여성~t2'")
			
		Case "religioncode", "creligioncode", "vw_p7_qry_collection_religioncode"
			ls_Column_Title[i] = "종교"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '기독교~t1/천주교~t2/이슬람교~t3/불교~t4/유교~t5/기타~t6'")
		
		Case "religioname", "creligioname", "vw_p7_qry_collection_religioname"
			ls_Column_Title[i] = "종교"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "bornname", "cbornname", "vw_p7_qry_collection_bornname"
			ls_Column_Title[i] = "본적"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			
		Case "weddingtag", "cweddingtag", "vw_p7_qry_collection_weddingtag"
			ls_Column_Title[i] = "결혼여부"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '기혼~t1/미혼~t0'")
			
		Case "bloodtype", "cbloodtype", "vw_p7_qry_collection_bloodtype"
			ls_Column_Title[i] = "혈액형"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = &
				'RH+ A~t1/RH+ B~t2/RH+ AB~t3/RH+ O~t4/RH- A~t5/RH- B~t6/RH- AB~t7/RH- O~t8/'")
				
		Case "schoolingname", "cschoolingname", "vw_p7_qry_collection_schoolingname"
			ls_Column_Title[i] = "최종학력"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
		
		Case "jhgubn", "cjhgubn", "vw_p7_qry_collection_jhgubn"
			ls_Column_Title[i] = "재학여부"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '재학~tY/    ~tN'")

		Case "jhtgubn", "cjhtgubn", "vw_p7_qry_collection_jhtgubn"
			ls_Column_Title[i] = "등교공제"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '공제~tY/미공제~tN'")

		Case "jhhgubn", "cjhhgubn", "vw_p7_qry_collection_jhhgubn"
			ls_Column_Title[i] = "학비지원"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '지원~tY/비지원~tN'")

		Case "consmatgubn", "cconsmatgubn", "vw_p7_qry_collection_consmatgubn"
			ls_Column_Title[i] = "상조회가입"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '가입~tY/비가입~tN'")

		Case "engineergubn", "cengineergubn", "vw_p7_qry_collection_engineergubn"
			ls_Column_Title[i] = "현장기술인력여부"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '적용~tY/비적용~tN'")
			
		Case "medingbn", "cmedingbn", "vw_p7_qry_collection_medingbn"
			ls_Column_Title[i] = "의료보험증 반납"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '반납~tY/미반납~tN'")

		Case "armyservicetag", "carmyservicetag", "vw_p7_qry_collection_armyservicetag"
			ls_Column_Title[i] = "군필"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 4))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '군필~t1/미필~t0'")
			
		Case "armykindcode", "carmykindcode", "vw_p7_qry_collection_armykindcode"
			ls_Column_Title[i] = "군별"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '육군~t1/해군~t2/공군~t3/해병대~t4/전투경찰~t5/특전대~t6'")
		
		Case "armykindname", "carmykindname", "vw_p7_qry_collection_armykindname"
			ls_Column_Title[i] = "군별"
		   ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
		
		Case "dischargename", "cdischargename", "vw_p7_qry_collection_dischargename"
			ls_Column_Title[i] = "제대구분"
		   ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 10))
			
		Case "armyclassname", "carmyclassname", "vw_p7_qry_collection_armyclassname"
			ls_Column_Title[i] = "계급"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))
			
		Case "armyname", "carmyname", "vw_p7_qry_collection_armyname"
			ls_Column_Title[i] = "병과"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 6))

		Case "reservecode", "creservecode", "vw_p7_qry_collection_reservecode"
			ls_Column_Title[i] = "역종"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '예비역~t1/준예(방위)~t2/제1국민역(입영대기)~t3/제2국민역(민방위)~t4/미필보충역(특례보충)~t5/기타~t6/면제~t7'")
		
		Case "reservename", "creservename", "vw_p7_qry_collection_reservename"
			ls_Column_Title[i] = "역종"
		   ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 12))
			
		Case "dialoglevel1", "cdialoglevel1", "vw_p7_qry_collection_dialoglevel1"
			ls_Column_Title[i] = "영어회화"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "readlevel1", "creadlevel1", "vw_p7_qry_collection_readlevel1"
			ls_Column_Title[i] = "영어독해"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "writelevel1", "cwritelevel1", "vw_p7_qry_collection_writelevel1"
			ls_Column_Title[i] = "영어작문"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "dialoglevel2", "cdialoglevel2", "vw_p7_qry_collection_dialoglevel2"
			ls_Column_Title[i] = "일어회화"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "readlevel2", "creadlevel2", "vw_p7_qry_collection_readlevel2"
			ls_Column_Title[i] = "일어독해"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "writelevel2", "cwritelevel2", "vw_p7_qry_collection_writelevel2"
			ls_Column_Title[i] = "일어작문"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "dialoglevel3", "cdialoglevel3", "vw_p7_qry_collection_dialoglevel3"
			ls_Column_Title[i] = "불어회화"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "readlevel3", "creadlevel3", "vw_p7_qry_collection_readlevel3"
			ls_Column_Title[i] = "불어독해"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "writelevel3", "cwritelevel3", "vw_p7_qry_collection_writelevel3"
			ls_Column_Title[i] = "불어작문"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 8))
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Edit.CodeTable = Yes")
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Values = '상급~t1/중급~t2/하급~t3'")
			
		Case "phoneno", "cphoneno", "vw_p7_qry_collection_phoneno"
			ls_Column_Title[i] = "전화번호"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "address", "caddress", "vw_p7_qry_collection_address"
			ls_Column_Title[i] = "주  소"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 40))
			
		Case "residentno", "cresidentno", "vw_p7_qry_collection_residentno"
			ls_Column_Title[i] = "주민등록번호"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "medinsuranceno", "cmedinsuranceno", "vw_p7_qry_collection_medinsuranceno"
			ls_Column_Title[i] = "의료보험번호"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 12))
			
		Case "hphone", "vw_p7_qry_collection_hphone"
			ls_Column_Title[i] = "핸드폰"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 14))
			
		Case "email", "cemail", "vw_p7_qry_collection_email"
			ls_Column_Title[i] = "이메일"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".Width = " + String(li_unit_per_char * 50))	
	
	End Choose

	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.Height = 530")
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.Header.Color = " + String(RGB(192, 192, 192)))
	ls_Modify_Err = uo_retrieve.dw_result.Modify("DataWindow.selected.mouse=no")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.text='" + ls_Column_Title[i] + "'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.y='90'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.height.autosize=Yes")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.face='굴림체'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.height='-10'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.weight='700'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.family='1'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.pitch='1'")
	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + "_t.font.charset='-127'")

	ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".font.height='-10'")

	Choose Case ls_Column_Title[i]
		Case "입사일자", "휴직일자", "퇴직일자", "생년월일", "여권유효일자", "최종승진일자", "졸업일자"
			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='@@@@.@@.@@'")
//		Case "전화번호"
//			ls_Modify_Err = uo_retrieve.dw_result.Modify(ls_Column_Name[i] + ".format='@@@@)@@@@-@@@@'")
	End Choose

	lb_qry_Column.AddItem(ls_Column_Name[i])
	uo_retrieve_items_vw.lb_ColumnTitle.AddItem(ls_Column_Title[i])

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
		sColumnName = '오름차순,'
	ELSEIF scolumnid = 'D' THEN
		sColumnName = '내림차순,'
	END IF
ELSE	
	Choose Case Trim(scolumnid)
		Case "empno"
			sColumnName = '사번 '
		Case "saupname"
			sColumnName = '사업장 '	
		Case "empname"
			sColumnName = '성명 '
		Case "deptname"
			sColumnName = '소속부서 '
		Case "adddeptname"
			sColumnName = '출력부서 '
		Case "majorname"
			sColumnName = '전공 '
		Case "gradename"
			sColumnName = '직위 '
		Case "levelname"
			sColumnName = '직급 '
		Case "salary"
			sColumnName = '호봉 '
		Case "jobkindname"
			sColumnName = '직책 '
		Case "kunmuname"
			sColumnName = '근무구분 '
		Case "jikmuname"
			sColumnName = '직무 '
		Case "servicekindcode"
			sColumnName = '입퇴구분 '
		Case "jikjonggubn"
			sColumnName = '직종 '
		Case "jikjongname"
			sColumnName = '직종 '	
		Case "paygubn"
			sColumnName = '급여구분 '
		Case "serviceyears"
			sColumnName = '근속년수 '
		Case "enterdate"
			sColumnName = '입사일자 '
		Case "temprestdate"
			sColumnName = '휴직일자 '
		Case "retiredate"
			sColumnName = '퇴사일자 '
		Case "educationname"
			sColumnName = '교육사항 '
		Case "rpname"
			sColumnName = '상벌 '
		Case "guaranteeenddate"
			sColumnName = '졸업일자 '
		Case "affiliatename"
			sColumnName = '관계처 '
		Case "passportenddate"
			sColumnName = '여권만료일자 '
		Case "licensename"
			sColumnName = '자격/면허 '
		Case "licenseupdatedate"
			sColumnName = '자격증갱신일자 '
		Case "birthday"
			sColumnName = '생년월일 '
		Case "sex"
			sColumnName = '성별 '
		Case "religioncode"
			sColumnName = '종교 '
		Case "bornname"
			sColumnName = '본적 '
		Case "bloodtype"
			sColumnName = '혈액형 '
		Case "schoolingname"
			sColumnName = '학교명 '
		Case "armykindcode"
			sColumnName = '군별 '
		Case "armyclassname"
			sColumnName = '계급 '
		Case "armyname"
			sColumnName = '병과 '
		Case "reservecode"
			sColumnName = '역종 '
		Case "phoneno"
			sColumnName = '전화번호 '
		Case "address"
			sColumnName = '주소 '
		Case "residentno"
			sColumnName = '주민등록번호 '
		Case "medinsuranceno"
			sColumnName = '의료보험번호 '
		Case "email"
			sColumnName = '이메일 '			
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

public function integer wf_make_sql ();uo_retrieve_items_vw.uf_make_sql()

is_select_clause = uo_retrieve_items_vw.is_select_clause
is_from_clause = uo_retrieve_items_vw.is_from_clause

IF wf_make_where_clause() <> 1 THEN
	Return 0
END IF

//is_join_clause = uo_retrieve_items.is_join_clause

If isnull(is_from_clause) or Trim(is_from_clause) = "" Then
	MessageBox("확인", "선택된 조회항목이 없습니다.")
	Return 0
End If

is_select_clause = is_select_clause + ", vw_p7_qry_collection.empno empno2"

//If Len(is_join_clause) <> 0 then
//	If Len(is_where_clause) = 0 then
//		MessageBox("확인", "조건식이 설정되지 않았습니다.")
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
	Case Is > 0
		uo_retrieve.st_emp_count.Text = string(ll_rt) 
		//uo_retrieve.st_emp_count.Text = String(uo_retrieve.dw_result.GetItemNumber(1, "empno_count"))
	Case Else
		MessageBox("확인", "자료 검색 실패!")
		Return -1
End Choose

//iSQLCA_main.AutoCommit = False

Return 1
end function

public function integer wf_add_where_items ();//	조건설정(uo_where)의 항목 DDLB를 채워준다.

Integer				i, imax, dindex
DropDownListBox	d[8]

imax = uo_where_items_vw.lb_selected.TotalItems()

d[1] = uo_where.ddlb_field_1; d[2] = uo_where.ddlb_field_2
d[3] = uo_where.ddlb_field_3; d[4] = uo_where.ddlb_field_4
d[5] = uo_where.ddlb_field_5; d[6] = uo_where.ddlb_field_6
d[7] = uo_where.ddlb_field_7; d[8] = uo_where.ddlb_field_8

uo_where.uf_clear_rows(1)

If imax > 0 Then
	For dindex = 1 to 8	// 9 -> 행의 수
		d[dindex].Reset()
		For i = 1 to imax
			d[dindex].AddItem(uo_where_items_vw.lb_selected.Text(i))
		Next
	Next
	uo_where.sle_parenthesis_f_1.Enabled = True
	uo_where.ddlb_field_1.Enabled = True
	uo_where.ddlb_op_1.Enabled = True
	uo_where.sle_value_1.Enabled = True
	uo_where.sle_parenthesis_r_1.Enabled = True
	uo_where.ddlb_logical_1.Enabled = True
Else
	MessageBox("확인", "조건식을 만들기 위한 항목을 선택해야합니다.")
	Return -1
End If

uo_where.lb_fieldnames.Reset()	// Hidden Control!!!
For i = 1 to imax
	uo_where.lb_fieldnames.AddItem(uo_where_items_vw.lb_selected_fieldnames.Text(i))
Next

Return 1
end function

event open;call super::open;w_mdi_frame.sle_msg.text =""

dw_datetime.InsertRow(0)
uo_where_items_vw.Border = False; uo_where.Border = False; uo_retrieve_items_vw.Border = False; uo_retrieve.Border = False

iuo_current_view = uo_where_items_vw
is_title = this.Title



this.Title = '조건 검색 - 조건항목 선택'
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

on w_condition_qry_vw.create
int iCurrent
call super::create
this.uo_buttons=create uo_buttons
this.gb_title1=create gb_title1
this.gb_title=create gb_title
this.lb_qry_column=create lb_qry_column
this.uo_where_items_vw=create uo_where_items_vw
this.uo_retrieve_items_vw=create uo_retrieve_items_vw
this.uo_where=create uo_where
this.uo_retrieve=create uo_retrieve
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_buttons
this.Control[iCurrent+2]=this.gb_title1
this.Control[iCurrent+3]=this.gb_title
this.Control[iCurrent+4]=this.lb_qry_column
this.Control[iCurrent+5]=this.uo_where_items_vw
this.Control[iCurrent+6]=this.uo_retrieve_items_vw
this.Control[iCurrent+7]=this.uo_where
this.Control[iCurrent+8]=this.uo_retrieve
end on

on w_condition_qry_vw.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_buttons)
destroy(this.gb_title1)
destroy(this.gb_title)
destroy(this.lb_qry_column)
destroy(this.uo_where_items_vw)
destroy(this.uo_retrieve_items_vw)
destroy(this.uo_where)
destroy(this.uo_retrieve)
end on

type p_mod from w_inherite_standard`p_mod within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_del from w_inherite_standard`p_del within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_inq from w_inherite_standard`p_inq within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_print from w_inherite_standard`p_print within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_can from w_inherite_standard`p_can within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_exit from w_inherite_standard`p_exit within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_ins from w_inherite_standard`p_ins within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_search from w_inherite_standard`p_search within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_addrow from w_inherite_standard`p_addrow within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type p_delrow from w_inherite_standard`p_delrow within w_condition_qry_vw
boolean visible = false
integer y = 2412
end type

type dw_insert from w_inherite_standard`dw_insert within w_condition_qry_vw
boolean visible = false
integer x = 969
integer y = 2420
end type

type st_window from w_inherite_standard`st_window within w_condition_qry_vw
end type

type cb_exit from w_inherite_standard`cb_exit within w_condition_qry_vw
end type

type cb_update from w_inherite_standard`cb_update within w_condition_qry_vw
end type

type cb_insert from w_inherite_standard`cb_insert within w_condition_qry_vw
end type

type cb_delete from w_inherite_standard`cb_delete within w_condition_qry_vw
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_condition_qry_vw
end type

type st_1 from w_inherite_standard`st_1 within w_condition_qry_vw
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_condition_qry_vw
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_condition_qry_vw
end type

type sle_msg from w_inherite_standard`sle_msg within w_condition_qry_vw
end type

type gb_2 from w_inherite_standard`gb_2 within w_condition_qry_vw
end type

type gb_1 from w_inherite_standard`gb_1 within w_condition_qry_vw
end type

type gb_10 from w_inherite_standard`gb_10 within w_condition_qry_vw
end type

type uo_buttons from uo_cond_qry_button within w_condition_qry_vw
event destroy ( )
event ue_excel ( )
integer x = 2898
integer width = 1678
integer height = 180
integer taborder = 10
boolean bringtotop = true
boolean border = false
end type

on uo_buttons.destroy
call uo_cond_qry_button::destroy
end on

event ue_excel(datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel( uo_retrieve.dw_result,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"	


end event

event ue_where_items;w_mdi_frame.sle_msg.text =""

Parent.SetRedraw(False)
gb_title1.visible = True
gb_title.visible = True
iuo_current_view.Hide()
uo_where_items_vw.Show()
uo_retrieve_items_vw.Show()
iuo_current_view = uo_where_items_vw
Parent.Title = "조건검색 - 조건항목 선택"
Parent.SetRedraw(True)

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.pb_where_items.Hide()
uo_buttons.pb_print.Hide()
uo_buttons.pb_excel.Hide()
uo_buttons.SetRedraw(True)

end event

event ue_where;w_mdi_frame.sle_msg.text =""

If iuo_current_view = uo_where_items_vw Then
	If wf_add_where_items() <> 1 Then Return
End If

Parent.SetRedraw(False)
gb_title1.visible = false
gb_title.visible = false
uo_retrieve.Hide()
iuo_current_view.Hide()
uo_where.Show()
iuo_current_view = uo_where
Parent.Title = "조건검색 - 조건 설정"
Parent.SetRedraw(True)

uo_buttons.SetRedraw(False)
uo_buttons.uf_show_all()
uo_buttons.pb_where.Hide()
uo_buttons.pb_print.Hide()
uo_buttons.pb_excel.Hide()
uo_buttons.SetRedraw(True)

end event

event ue_retrieve_items;w_mdi_frame.sle_msg.text =""

If wf_make_where_clause() = 1 Then
	Parent.SetRedraw(False)
	gb_title1.visible = True
   gb_title.visible = True
	iuo_current_view.Hide()
	uo_retrieve_items_vw.Show()
	uo_where_items_vw.Show()
	iuo_current_view = uo_retrieve_items_vw
	Parent.Title = "조건검색 - 조회항목 선택"
	Parent.SetRedraw(True)

	uo_buttons.SetRedraw(False)
	uo_buttons.uf_show_all()
	uo_buttons.pb_retrieve_items.Hide()
	uo_buttons.pb_print.Hide()
	uo_buttons.pb_excel.Hide()
	uo_buttons.SetRedraw(True)
Else
	MessageBox("확인", "조건식을 반드시 입력해야합니다.", Exclamation!)
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

Parent.Title = "조건검색 - 조회결과"
//Parent.SetRedraw(True)

/* Last page 구하는 routine */
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

//w_mdi_frame.sle_msg.text = "해당 사원에 대한 상세 내역을 보시려면 Double Click을 하세요.!!!"
end event

event ue_clear;call super::ue_clear;w_mdi_frame.sle_msg.text =""

iuo_current_view.TriggerEvent("ue_clear")
end event

event ue_print;w_mdi_frame.sle_msg.text =""
openwithparm(w_print_options, uo_retrieve.dw_result)
end event

event ue_close;call super::ue_close;close(parent)
end event

type gb_title1 from groupbox within w_condition_qry_vw
integer x = 475
integer y = 208
integer width = 3451
integer height = 920
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "조건항목"
end type

type gb_title from groupbox within w_condition_qry_vw
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
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "조회항목"
end type

type lb_qry_column from listbox within w_condition_qry_vw
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
string facename = "바탕체"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type uo_where_items_vw from uo_search_items_vw within w_condition_qry_vw
integer x = 507
integer y = 280
integer taborder = 200
boolean bringtotop = true
end type

event ue_clear;call super::ue_clear;lb_where_item.Reset()
end event

on uo_where_items_vw.destroy
call uo_search_items_vw::destroy
end on

type uo_retrieve_items_vw from uo_search_outputs_vw within w_condition_qry_vw
integer x = 507
integer y = 1192
integer taborder = 550
boolean bringtotop = true
end type

event ue_clear;call super::ue_clear;
lb_output_item.Reset()
lb_columnname.Reset()

lb_qry_column.Reset()
lb_columntitle.Reset()

end event

on uo_retrieve_items_vw.destroy
call uo_search_outputs_vw::destroy
end on

type uo_where from uo_search_conditions_vw within w_condition_qry_vw
integer x = 503
integer y = 252
integer width = 3392
integer height = 1836
integer taborder = 120
end type

on uo_where.destroy
call uo_search_conditions_vw::destroy
end on

type uo_retrieve from uo_search_result within w_condition_qry_vw
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
	
uo_retrieve.dw_result.title = '정렬 순서 : '+ Left(sSortSyntax,Len(sSortSyntax) - 1)



end event

on uo_retrieve.destroy
call uo_search_result::destroy
end on

event ue_sort;st_cond_qry_sort_parm	lst_sort_parm

lst_sort_parm.lb_columnname = lb_qry_column
lst_sort_parm.lb_columntitle = uo_retrieve_items_vw.lb_columntitle

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
//	sle_msg.text = "해당 사원에 대한 내역을 보시려면 Double Click을 하세요.!!!"
//	ls_empno = dw_result.GetItemString(ll_row, iv_empnocloumn)
//	OpenWithParm(w_piz1105, ls_empno)
//End If
//
end event

