$PBExportHeader$w_sys_erp_modify_list.srw
$PBExportComments$ERP 수정 작업 목록
forward
global type w_sys_erp_modify_list from w_standard_print
end type
end forward

global type w_sys_erp_modify_list from w_standard_print
string title = "ERP 수정작업 목록"
end type
global w_sys_erp_modify_list w_sys_erp_modify_list

type variables
Boolean ib_chk = FALSE
end variables

forward prototypes
public subroutine wf_settitle (integer ai_gbn, datawindow adw_target)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_settitle (integer ai_gbn, datawindow adw_target);// 출력물 Title 조정
String ls_gb, ls_title, ls_duty_id, ls_duty_name, ls_pjt
Integer li_i

ls_gb = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(gb) ', 1)"))

Select dataname 
  Into :ls_pjt
  From syscnfg
 Where sysgu = 'C'
   And serial = 1
   And lineno = 3;
				
If SQLCA.SQLcode <> 0 Then SetNull(ls_pjt)			
			
adw_target.Modify("t_pjt.text = '"+ls_pjt+"'")
		
Choose Case ai_gbn
	Case 1				// 업무별
		ls_title = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(job_gb) ', 1)"))
		adw_target.Modify("t_job_gb.text = '"+ls_title+"'")
		adw_target.Modify("t_gb.text = '"+ls_gb+"'")
		
		For li_i = 1 To dw_list.RowCount()
			ls_duty_id = dw_list.GetItemString(li_i, 'sub2_t_emp_id')
			ls_duty_name = f_get_employee(ls_duty_id)			
			dw_list.SEtItem(li_i, 'txt_duty', ls_duty_name)
		Next
		
	Case 2				// 담당자별
		ls_duty_id = dw_ip.GetItemString(1, 'duty_id')
		ls_title = f_get_employee(ls_duty_id)
		
		adw_target.Modify("t_duty.text = '"+ls_title+"'")
		adw_target.Modify("t_gbn.text = '"+ls_gb+"'")
End Choose
end subroutine

public function integer wf_retrieve ();String ls_pgm_gb, ls_duty_id, ls_gb, ls_job_gb

dw_ip.AcceptText()

ls_pgm_gb = dw_ip.GetItemString(1, 'pgm_gb')
ls_job_gb = dw_ip.GetItemString(1, 'job_gb')
ls_duty_id = dw_ip.GetITemString(1, 'duty_id')
ls_gb = dw_ip.GetItemString(1, 'gb')

Choose Case dw_list.DataObject
	CAse 'd_sys_erp_modify_list2'
		if isNull(ls_job_gb) Then
			MessageBox("알림", "업무구분을 반드시 선택하세요")
			dw_ip.Setfocus()
			Return -1
		End If
		
		If dw_list.Retrieve(ls_job_gb, ls_gb) <= 0 then
			f_message_chk(50,'[프로그램 사용내역 현황]')
			dw_ip.Setfocus()
			dw_list.Modify("t_pjt.text = ''")
			dw_list.Modify("t_job_gb.text = ''")
			dw_list.Modify("t_gb.text = ''")
			Return -1
		Else			
			wf_setTitle(1, dw_list)
		End If
		
	Case 'd_sys_erp_modify_list1'	
		If ib_chk = TRUE Then
			ib_chk = FALSE
			Return -1
		End If
		
		if isNull(ls_duty_id) Then
			MessageBox("알림", "담당자를 반드시 입력하세요")
			dw_ip.Setfocus()			
			Return -1
		End If
		
		If dw_list.Retrieve(ls_duty_id, ls_gb) <= 0 then
			f_message_chk(50,'[프로그램 사용내역 현황]')
			dw_ip.Setfocus()
			dw_list.Modify("t_pjt.text = ''")
			dw_list.Modify("t_duty.text = ''")
			dw_list.Modify("t_gbn.text = ''")
			Return -1
		Else
			wf_setTitle(2, dw_list)
		End If
		
End Choose		

Return 1
end function

on w_sys_erp_modify_list.create
call super::create
end on

on w_sys_erp_modify_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;// Ancestor에서 share 된 DataWindow를 해제
dw_print.ShareDataoff()
dw_ip.setItem(1, 'pgm_gb', '1')
dw_ip.setItem(1, 'gb', '%')
end event

type p_preview from w_standard_print`p_preview within w_sys_erp_modify_list
integer x = 4261
end type

event p_preview::clicked;// Override 
Choose Case dw_list.DataObject
	Case 'd_sys_erp_modify_list2'
		dw_print.DataObject = 'd_sys_erp_modify_list2'
		
	Case 'd_sys_erp_modify_list1'
		dw_print.DataObject = 'd_sys_erp_modify_list1'	
End Choose

dw_print.SetTransObject(sqlca)
dw_list.ShareData(dw_print)

Choose Case dw_list.DataObject
	Case 'd_sys_erp_modify_list2'		
		wf_setTitle(1, dw_print)
	Case 'd_sys_erp_modify_list1'
		wf_setTitle(2, dw_print)
End Choose

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_sys_erp_modify_list
end type

type p_print from w_standard_print`p_print within w_sys_erp_modify_list
boolean visible = false
end type

type p_retrieve from w_standard_print`p_retrieve within w_sys_erp_modify_list
integer x = 4078
end type







type st_10 from w_standard_print`st_10 within w_sys_erp_modify_list
end type



type dw_print from w_standard_print`dw_print within w_sys_erp_modify_list
string dataobject = "d_sys_erp_modify_list1"
end type

type dw_ip from w_standard_print`dw_ip within w_sys_erp_modify_list
integer width = 3634
integer height = 164
string dataobject = "d_sys_erp_modify_list"
end type

event dw_ip::itemchanged;Choose Case dwo.name
	Case 'pgm_gb'
		Choose CAse data
			Case '1'	
				dw_list.DataObject = 'd_sys_erp_modify_list2'				
			CAse '2'
				dw_list.DataObject = 'd_sys_erp_modify_list1'			
		End Choose	
		
		dw_list.SetTransObject(SQLCA)
	Case 'duty_id'
		String ls_duty_name
		String ls_null
	
		ls_duty_name = f_get_employee(data)
		If isNull(ls_duty_name) Then
			MessageBox('알림', '등록되어 있지 않은 사번입니다.')			
			SetNull(ls_null)			
			dw_ip.SetItem(1, 'duty_name', ls_null)
			dw_list.Reset()
			ib_chk = TRUE
			Return 0
		Else
			dw_ip.SetItem(1, 'duty_name', ls_duty_name)
		End If
End Choose
end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_sys_erp_modify_list
string dataobject = "d_sys_erp_modify_list2"
end type

