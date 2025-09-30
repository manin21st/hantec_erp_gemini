$PBExportHeader$w_sys_erp_modify_total_list.srw
$PBExportComments$ERP 수정 작업 일정(총괄표/집계표)
forward
global type w_sys_erp_modify_total_list from w_standard_print
end type
end forward

global type w_sys_erp_modify_total_list from w_standard_print
string title = "ERP 수정작업 일정 총괄표/집계표"
end type
global w_sys_erp_modify_total_list w_sys_erp_modify_total_list

type variables
DataWindowChild dw_child
String is_sql
end variables

forward prototypes
public function integer wf_settransaction ()
public function integer wf_getdata (string as_value)
public subroutine wf_settitle (integer ai_gbn, datawindow adw_target)
public function integer wf_retrieve ()
end prototypes

public function integer wf_settransaction ();// Set Transaction

dw_ip.GetChild("subs_id", dw_child)

dw_child.SetTransObject(SQLCA)

Return 1
end function

public function integer wf_getdata (string as_value);// 중분류 항목을 분류하여 Display
String ls_idx
String ls_rsql
String ls_where
String ls_null

// 분류 범의를 산정
Choose Case as_value
	Case '10'
		ls_idx = '19'
	Case '20'
		ls_idx = '49'
	Case '50'
		ls_idx = '89'
	Case '90'
		ls_idx = '99'
End Choose		

wf_settransaction()

SetNull(ls_null)
dw_ip.SetItem(1, 'subs_id', ls_null)

ls_where = " And main_id between '" + as_value + "' And '" + ls_idx + "'"	
ls_rsql = is_sql + ls_where

dw_child.SetSQLSelect(ls_rsql)

dw_child.Retrieve()

Return 1
end function

public subroutine wf_settitle (integer ai_gbn, datawindow adw_target);// 출력물 타이틀 조정
String ls_pjt, ls_subs_id

Select dataname 
  Into :ls_pjt
  From syscnfg
 Where sysgu = 'C'
   And serial = 1
   And lineno = 3;
				
If SQLCA.SQLcode <> 0 Then SetNull(ls_pjt)			

adw_target.Modify("t_pjt.text = '"+ls_pjt+"'")
		
Choose Case ai_gbn
	Case 1							// 일정 총괄표					
	Case 2							// 일정 집계표
		ls_subs_id = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(subs_id) ', 1)"))
		adw_target.Modify("t_sys.text = '"+ls_subs_id+"'")
End Choose

end subroutine

public function integer wf_retrieve ();String ls_tdate, ls_main_id, ls_subs_id

dw_ip.AcceptText()

ls_tdate = dw_ip.GetItemString(1, 'sys_date')

Choose Case dw_list.DataObject
	CAse 'd_sys_erp_modify_total_list1'			
		If isNull(ls_tdate) Then
			MessageBox("알림", "기준일을 반드시 입력하세요")			
			dw_ip.Setfocus()
			Return -1
		End If
		
		If dw_list.Retrieve(ls_tdate) <= 0 then
			f_message_chk(50,'[프로그램 사용내역 현황]')
			dw_list.Modify("t_pjt.text = ''")
			dw_ip.Setfocus()			
			Return -1
		Else	
			wf_settitle(1, dw_list)
		End If		
	
	Case 'd_sys_erp_modify_total_list2'
		ls_main_id = dw_ip.GetITEmString(1, 'main_id')
		ls_subs_id = dw_ip.GetItemString(1, 'subs_id')
		
		If isNull(ls_tdate) Then
			MessageBox("알림", "기준일을 반드시 입력하세요")			
			dw_ip.Setfocus()
			Return -1
		End If		
		
		If isNull(ls_main_id) Then
			MessageBox("알림", "대분류를 반드시 선택하세요")
			dw_ip.Setfocus()
			Return -1
		End If
		
		If isNull(ls_subs_id) Then
			MessageBox("알림", "중분류를 반드시 선택하세요")
			dw_ip.Setfocus()
			Return -1
		End If
		
		If dw_list.Retrieve(ls_subs_id, ls_tdate) <= 0 then
			f_message_chk(50,'[프로그램 사용내역 현황]')
			dw_list.Modify("t_pjt.text = ''")
			dw_list.Modify("t_sys.text = ''")
			dw_ip.Setfocus()			
			Return -1
		Else	
			wf_settitle(2, dw_list)
		End If		
End Choose		

Return 1
end function

on w_sys_erp_modify_total_list.create
call super::create
end on

on w_sys_erp_modify_total_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.SetItem(1, 'pg_gb', '1')
dw_ip.SetItem(1, 'sys_date', is_today)

// Ancestor에서 share 된 DataWindow를 해제
dw_print.ShareDataoff()

wf_settransaction()
is_sql = dw_child.GetSQLSelect()

end event

type p_preview from w_standard_print`p_preview within w_sys_erp_modify_total_list
integer x = 4265
end type

event p_preview::clicked;// Override 
Choose Case dw_list.DataObject		
	Case 'd_sys_erp_modify_total_list2'
		dw_print.DataObject = 'd_sys_erp_modify_total_list2'
		
	Case 'd_sys_erp_modify_total_list1'
		dw_print.DataObject = 'd_sys_erp_modify_total_list1'		
End Choose

dw_print.SetTransObject(sqlca)
dw_list.ShareData(dw_print)

Choose Case dw_list.DataObject
	Case 'd_sys_erp_modify_total_list1'		
		wf_setTitle(1, dw_print)
	Case 'd_sys_erp_modify_total_list2'
		wf_setTitle(2, dw_print)
End Choose

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_sys_erp_modify_total_list
end type

type p_print from w_standard_print`p_print within w_sys_erp_modify_total_list
boolean visible = false
end type

type p_retrieve from w_standard_print`p_retrieve within w_sys_erp_modify_total_list
integer x = 4087
end type







type st_10 from w_standard_print`st_10 within w_sys_erp_modify_total_list
end type



type dw_print from w_standard_print`dw_print within w_sys_erp_modify_total_list
string dataobject = "d_sys_erp_modify_total_list1"
end type

type dw_ip from w_standard_print`dw_ip within w_sys_erp_modify_total_list
integer width = 2990
string dataobject = "d_sys_erp_modify_total"
end type

event dw_ip::itemchanged;String ls_id

Choose Case dwo.name
	Case 'pg_gb'
		Choose CAse data
			Case '1'	
				dw_list.DataObject = 'd_sys_erp_modify_total_list1'
				
			CAse '2'
				dw_list.DataObject = 'd_sys_erp_modify_total_list2'
				
		End Choose	
		
		dw_list.SetTransObject(SQLCA)	
		
	Case 'main_id'
		dw_ip.Accepttext( )	
		ls_id = this.GetItemString(1, 'main_id')
		wf_getdata(ls_id)	
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sys_erp_modify_total_list
string dataobject = "d_sys_erp_modify_total_list1"
end type

