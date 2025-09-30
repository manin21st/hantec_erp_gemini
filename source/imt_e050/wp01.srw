$PBExportHeader$wp01.srw
$PBExportComments$금형수리의뢰등록
forward
global type wp01 from w_inherite
end type
type rr_1 from roundrectangle within wp01
end type
type dw_top from datawindow within wp01
end type
type rb_2 from radiobutton within wp01
end type
type rb_1 from radiobutton within wp01
end type
type dw_print from datawindow within wp01
end type
type pb_3 from u_pb_cal within wp01
end type
type pb_1 from u_pb_cal within wp01
end type
type pb_2 from u_pb_cal within wp01
end type
type pb_4 from u_pb_cal within wp01
end type
type dw_list from u_d_select_sort within wp01
end type
type pb_5 from u_pb_cal within wp01
end type
type gb_5 from groupbox within wp01
end type
end forward

global type wp01 from w_inherite
integer width = 4695
integer height = 4240
string title = "금형 수리의뢰 등록"
rr_1 rr_1
dw_top dw_top
rb_2 rb_2
rb_1 rb_1
dw_print dw_print
pb_3 pb_3
pb_1 pb_1
pb_2 pb_2
pb_4 pb_4
dw_list dw_list
pb_5 pb_5
gb_5 gb_5
end type
global wp01 wp01

forward prototypes
public function integer wf_chk ()
public subroutine wf_ini ()
public function integer wf_update ()
end prototypes

public function integer wf_chk ();dw_top.AcceptText()
dw_insert.AcceptText()

String ls_dat
String ls_kum
String ls_gub
String ls_emp
String ls_dpt
String ls_cod
String ls_stdat
String ls_sttim
String ls_eddat
String ls_edtim
String ls_hogi

ls_dat = dw_insert.GetItemString(1, 'kumrsl_kum_sidat')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then dw_insert.SetItem(1, 'kumrsl_kum_sidat', dw_top.GetItemString(1, 'sidat'))

ls_kum = dw_insert.GetItemString(1, 'kumrsl_kum_kumno')
If Trim(ls_kum) = '' OR IsNull(ls_kum) Then dw_insert.SetItem(1, 'kumrsl_kum_kumno', dw_top.GetItemSTring(1, 'kumno'))

String ls_chk[]

ls_chk[1] = dw_insert.GetItemString(1, 'gbn1')
If Trim(ls_chk[1]) = '' OR IsNull(ls_chk[1]) Then ls_chk[1] = 'N'

ls_chk[2] = dw_insert.GetItemString(1, 'gbn2')
If Trim(ls_chk[2]) = '' OR IsNull(ls_chk[2]) Then ls_chk[2] = 'N'

ls_chk[3] = dw_insert.GetItemString(1, 'gbn3')
If Trim(ls_chk[3]) = '' OR IsNull(ls_chk[3]) Then ls_chk[3] = 'N'

ls_chk[4] = dw_insert.GetItemString(1, 'gbn4')
If Trim(ls_chk[4]) = '' OR IsNull(ls_chk[4]) Then ls_chk[4] = 'N'

If ls_chk[1] + ls_chk[2] + ls_chk[3] + ls_chk[4] = 'NNNN' Then
	MessageBox('의뢰구분', '의뢰 구분을 선택하십시오.')
	Return -1
Else
	dw_insert.SetItem(1, 'kumrsl_kum_gubun', ls_chk[1] + ls_chk[2] + ls_chk[3] + ls_chk[4])
End If

//ls_gub = dw_insert.GetItemString(1, 'kumrsl_kum_gubun')
//If Trim(ls_gub) = '' OR IsNull(ls_gub) Then
//	MessageBox('구분', '구분을 선택하십시오.')
//	dw_insert.SetColumn('kumrsl_kum_gubun')
//	dw_insert.SetFocus()
//	Return -1
//End If

ls_emp = dw_insert.GetItemString(1, 'kumrsl_kum_wiemp')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	MessageBox('의뢰자', '의뢰 신청자를 입력하십시오.')
	dw_insert.SetColumn('kumrsl_kum_wiemp')
	dw_insert.SetFocus()
	Return -1
End If

ls_dpt = dw_insert.GetItemString(1, 'kumrsl_kum_widpt')
If Trim(ls_dpt) = '' OR IsNull(ls_dpt) Then
	MessageBox('의뢰부서', '의뢰부서를 입력하십시오.')
	dw_insert.SetColumn('kumrsl_kum_widpt')
	dw_insert.SetFocus()
	Return -1
End If

ls_cod = dw_insert.GetItemString(1, 'kumrsl_kum_jecod')
If Trim(ls_cod) = '' OR IsNull(ls_cod) Then
	MessageBox('고장현상', '금형고장현상을 선택하십시오.')
	dw_insert.SetColumn('kumrsl_kum_jecod')
	dw_insert.SetFocus()
	Return -1
End If

//ls_stdat = dw_insert.GetItemString(1, 'kumrsl_kum_stdat')
//If Trim(ls_stdat) = '' OR IsNull(ls_stdat) Then
//	MessageBox('생산개시일', '생산개시일자를 입력하십시오!')
//	dw_insert.SetColumn('kumrsl_kum_stdat')
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//ls_sttim = dw_insert.GetItemString(1, 'kumrsl_kum_sttim')
//If Trim(ls_sttim) = '' OR IsNull(ls_sttim) Then
//	MessageBox('생산개시시간', '생산개시시간을 입력하십시오!')
//	dw_insert.SetColumn('kumrsl_kum_sttim')
//	dw_insert.SetFocus()
//	Return -1
//End If

ls_eddat = dw_insert.GetItemString(1, 'kumrsl_kum_eddat')
If Trim(ls_eddat) = '' OR IsNull(ls_eddat) Then
	MessageBox('생산종료일', '생산종료일자를 입력하십시오!')
	dw_insert.SetColumn('kumrsl_kum_eddat')
	dw_insert.SetFocus()
	Return -1
End If

ls_edtim = dw_insert.GetItemString(1, 'kumrsl_kum_edtim')
If Trim(ls_edtim) = '' OR IsNull(ls_edtim) Then
	MessageBox('생산종료시간', '생산종료시간을 입력하십시오!')
	dw_insert.SetColumn('kumrsl_kum_edtim')
	dw_insert.SetFocus()
	Return -1
End If

////일자 및 시간 검증
////생산개시일 보다 생산종료일이 빠를경우
//If ls_stdat > ls_eddat Then
//	MessageBox('일자확인', '생산개시일 보다 생산종료일이 빠릅니다.')
//	dw_insert.SetColumn('kumrsl_kum_eddat')
//	dw_insert.SetFocus()
//	Return -1
//End If
//
////생산개시일과 생산종료일이 같을 경우 시간 검사
//If ls_stdat = ls_eddat Then
//	If ls_sttim > ls_edtim Then
//		MessageBox('시간확인', '생산개시시간 보다 생산종료시간이 빠릅니다.')
//		dw_insert.SetColumn('kumrsl_kum_edtim')
//		dw_insert.SetFocus()
//		Return -1
//	End If
//End If

ls_hogi = dw_insert.GetItemString(1, 'kumrsl_kum_hogi')
If Trim(ls_hogi) = '' OR IsNull(ls_hogi) Then
	MessageBox('호기확인', '호기는 필수 항목입니다.')
	dw_insert.SetColumn('kumrsl_kum_hogi')
	dw_insert.SetFocus()
	Return -1
Else
	Long   ll_chk
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM WRKCTR
	 WHERE WKCTR = :ls_hogi ;
	If ll_chk < 1 OR IsNull(ll_chk) Then
		MessageBox('등록코드오류', '호기 코드는 등록된 코드가 아닙니다.')
		dw_insert.SetColumn('kumrsl_kum_hogi')
		dw_insert.SetFocus()
		Return -1
	End If
End If

Return 1







































end function

public subroutine wf_ini ();//String ls_sec
//
//SELECT SECTION
//  INTO :ls_sec
//  FROM PRODMAN_KUM
// WHERE EMPNO = :gs_empno ;
//dw_top.SetItem(1, 'section', ls_sec)

String ls_day

If rb_1.Checked = True Then
	dw_top.SetTabOrder('sidat', 0)
	dw_top.SetTabOrder('eddat', 0)
	dw_top.SetTabOrder('kumno', 0)
	
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_inq.PictureName   = 'C:\erpman\image\조회_d.gif'
	p_del.PictureName   = 'C:\erpman\image\삭제_d.gif'
	
	p_print.Enabled = False
	p_inq.Enabled   = False
	p_del.Enabled   = False
	
	dw_top.ReSet()
	dw_top.InsertRow(0)
	
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	
	dw_list.ReSet()

	dw_top.SetItem(1, 'sidat', String(TODAY(), 'yyyymm' + '01'))
	dw_top.SetItem(1, 'eddat', String(TODAY(), 'yyyymmdd'))
	
	dw_insert.SetItem(1, 'kumrsl_kum_sidat', String(TODAY(), 'yyyymmdd'))
	dw_insert.SetItem(1, 'kumrsl_kum_wiemp', gs_empno)
	dw_insert.SetITem(1, 'kumrsl_kum_widpt', gs_dept)
	dw_insert.SetItem(1, 'p1_master_empname', f_get_name5('02', gs_empno, ''))
	dw_insert.SetItem(1, 'vndmst_cvnas', f_get_name5('01', gs_dept, ''))
	
ElseIf rb_2.Checked = True Then	
	dw_top.SetTabOrder('sidat', 10)
	dw_top.SetTabOrder('eddat', 20)
	dw_top.SetTabOrder('kumno', 30)
	
	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'
	p_inq.PictureName   = 'C:\erpman\image\조회_up.gif'
	p_del.PictureName   = 'C:\erpman\image\삭제_up.gif'
	
	p_print.Enabled = True
	p_inq.Enabled   = True
	p_del.Enabled   = True
	
//	dw_top.ReSet()
//	dw_top.InsertRow(0)
	
	dw_insert.ReSet()
	dw_insert.InsertRow(0)

//	dw_top.SetItem(1, 'sidat', String(TODAY(), 'yyyymm' + '01'))
//	dw_top.SetItem(1, 'eddat', String(TODAY(), 'yyyymmdd'))
End If

dw_insert.SetItemStatus(1, 0, Primary!, NotModified!)



				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
end subroutine

public function integer wf_update ();String ls_jpno
String ls_date

Long   row
Long   seq

If dw_insert.AcceptText() = -1 Then Return -1

row = dw_insert.GetRow()
If row < 1 Then Return -1

ls_date = Trim(dw_insert.GetItemString(1, 'kumrsl_kum_sidat'))
seq     = SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'K2')

If seq < 1 OR seq > 9999 Then
	ROLLBACK USING SQLCA;
	f_message_chk(51, '')
	Return -1
End If

COMMIT USING SQLCA;

ls_jpno = ls_date + String(seq, '0000')

dw_insert.SetItem(row, 'kumrsl_kum_jpno', ls_jpno + String(row, '000'))

MessageBox('전표번호 확인', '전표번호 : ' + ls_date + '-' + String(seq, '0000') + '~r~r생성 되었습니다.')

Return 1

end function

on wp01.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_top=create dw_top
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_print=create dw_print
this.pb_3=create pb_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_4=create pb_4
this.dw_list=create dw_list
this.pb_5=create pb_5
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_top
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_4
this.Control[iCurrent+10]=this.dw_list
this.Control[iCurrent+11]=this.pb_5
this.Control[iCurrent+12]=this.gb_5
end on

on wp01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_top)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_print)
destroy(this.pb_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.dw_list)
destroy(this.pb_5)
destroy(this.gb_5)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_top.InsertRow(0)
dw_top.SetTransObject(SQLCA)

dw_insert.InsertRow(0)
dw_insert.SetTransObject(SQLCA)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

wf_ini()
end event

type dw_insert from w_inherite`dw_insert within wp01
integer x = 2341
integer y = 264
integer width = 2277
integer height = 1892
string dataobject = "d_kumpe01_00030_02"
boolean border = false
end type

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_gubun) 
SetNull(gs_code) 
SetNull(gs_codename)

String ls_cod
String ls_dpcd
String ls_dpnm
String ls_model_nm

ls_cod = This.GetColumnName()

Choose Case ls_cod
	Case 'kumrsl_kum_kumno'
		gs_gubun = 'M'
		Open(w_imt_04630_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(row, 'kumrsl_kum_kumno', gs_code)
		
		String ls_name
		
		SELECT KUMNAME,model_nm
		  INTO :ls_name, :ls_model_nm
		  FROM KUMMST
		 WHERE SABU  = :gs_sabu 
		   AND KUMNO = :gs_code ;
			
		This.SetItem(row, 'kummst_kumname' , ls_name)
		This.SetItem(row, ' kummst_model_nm', ls_model_nm)
		
		
	Case 'kumrsl_kum_widpt'
		Open(w_vndmst_4_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(1, 'kumrsl_kum_widpt', gs_code    )
		This.SetItem(1, 'vndmst_cvnas'    , gs_codename)
		
	Case 'kumrsl_kum_wiemp'
		Open(w_sawon_popup)
//      gs_gubun = dw_top.GetItemString(1, 'section')
//		If Trim(gs_gubun) = '' OR IsNull(gs_gubun) Then
//			MessageBox('Section 확인', 'SECTION을 선택하십시오.')
//			Return
//		End If
//		gs_code  = '1'
//      Open(w_workemp_popup2)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(1, 'kumrsl_kum_wiemp' , gs_code                       )
		This.SetItem(1, 'p1_master_empname', f_get_name5('02', gs_code, ''))
		
		SELECT A.DEPTCODE, B.CVNAS
		  INTO :ls_dpcd  , :ls_dpnm
  		  FROM P1_MASTER A,
			    VNDMST    B
       WHERE A.DEPTCODE        =  B.CVCOD
		   AND A.SERVICEKINDCODE <> '3' 
		   AND A.EMPNO           =  :gs_code ;
		
		This.SetItem(1, 'kumrsl_kum_widpt', ls_dpcd)
		This.SetItem(1, 'vndmst_cvnas'    , ls_dpnm)
		
	Case 'kumrsl_kum_hogi'
		Open(w_workplace_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'kumrsl_kum_hogi', gs_code    )
		This.SetItem(row, 'wrkctr_wcdsc'   , gs_codename)

End Choose
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

String ls_epnm
String ls_dpnm
String ls_dpcd
String ls_name

Choose Case dwo.name
	Case 'kumrsl_kum_wiemp'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'kumrsl_kum_widpt' , '')
			This.SetItem(row, 'vndmst_cvnas'     , '')
			This.SetItem(row, 'p1_master_empname', '')
			Return
		End If
		
		SELECT A.EMPNAME, A.DEPTCODE, B.CVNAS
		  INTO :ls_epnm , :ls_dpcd  , :ls_dpnm
  		  FROM P1_MASTER A,
			    VNDMST    B
       WHERE A.DEPTCODE = B.CVCOD
		   AND A.SERVICEKINDCODE <> '3' 
		   AND A.EMPNO = :data ;
			  
		This.SetItem(row, 'kumrsl_kum_widpt' , ls_dpcd)
		This.SetItem(row, 'vndmst_cvnas'     , ls_dpnm)
		This.SetItem(row, 'p1_master_empname', ls_epnm)
		
	Case 'kumrsl_kum_hogi'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'wrkctr_wcdsc', '')
			Return
		End If
		
		SELECT WCDSC
		  INTO :ls_name
		  FROM WRKCTR
		 WHERE WKCTR = :data ;
		If Trim(ls_name) = '' OR IsNull(ls_name) Then
			MessageBox('호기코드오류', '등록된 코드가 아닙니다.')
			This.SetColumn('kumrsl_kum_hogi')
			This.SetFocus()
			Return 1
		End If
		
		This.SetItem(row, 'wrkctr_wcdsc', ls_name)
	
		
End Choose
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::ue_pressenter;//

end event

type p_delrow from w_inherite`p_delrow within wp01
boolean visible = false
integer x = 786
integer y = 2392
end type

type p_addrow from w_inherite`p_addrow within wp01
boolean visible = false
integer x = 613
integer y = 2392
end type

type p_search from w_inherite`p_search within wp01
boolean visible = false
integer x = 439
integer y = 2392
end type

type p_ins from w_inherite`p_ins within wp01
boolean visible = false
integer x = 992
integer y = 2396
end type

type p_exit from w_inherite`p_exit within wp01
integer x = 4434
end type

type p_can from w_inherite`p_can within wp01
integer x = 4261
end type

event p_can::clicked;call super::clicked;wf_ini()
end event

type p_print from w_inherite`p_print within wp01
integer x = 3566
end type

event p_print::clicked;call super::clicked;Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

String ls_jpno

ls_jpno = dw_insert.GetItemString(row, 'kumrsl_kum_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then Return

dw_print.Retrieve(ls_jpno)

OpenWithParm(w_print_preview, dw_print)	

end event

type p_inq from w_inherite`p_inq within wp01
integer x = 3739
end type

event p_inq::clicked;call super::clicked;dw_top.AcceptText()

String ls_st
String ls_ed
String ls_kum

Long   row

row = dw_top.GetRow()
If row < 1 Then Return

ls_st = dw_top.GetItemString(row, 'sidat')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('확인', '의뢰일자를 입력하십시오.')
	dw_top.SetColumn('sidat')
	dw_top.SetFocus()
	Return
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('확인', '일자형식이 잘못되었습니다.')
		dw_top.SetColumn('sidat')
		dw_top.SetFocus()
		Return
	End If
End If

ls_ed = dw_top.GetItemString(row, 'eddat')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	MessageBox('확인', '의뢰일자를 입력하십시오.')
	dw_top.SetColumn('eddat')
	dw_top.SetFocus()
	Return
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('확인', '일자형식이 잘못되었습니다.')
		dw_top.SetColumn('eddat')
		dw_top.SetFocus()
		Return
	End If
End If

ls_kum = dw_top.GetItemString(row, 'kumno')
If Trim(ls_kum) = '' OR IsNull(ls_kum) Then ls_kum = '%'

String ls_gubun

ls_gubun = dw_top.GetItemString(row, 'gubun')
If Trim(ls_gubun) = '' OR IsNull(ls_gubun) Then ls_gubun = '%'

If dw_list.Retrieve(ls_st, ls_ed, ls_kum, ls_gubun) < 1 Then
	dw_insert.InsertRow(0)
End If

	

end event

type p_del from w_inherite`p_del within wp01
integer x = 4087
end type

event p_del::clicked;call super::clicked;dw_insert.AcceptText()

If dw_insert.RowCount() < 1 Then Return

If dw_list.GetItemString(dw_list.GetRow(), 'status') <> '1' Then
	MessageBox('주의!', '선택된 정보는 의뢰상태가 아닙니다.~r삭제 하실 수 없습니다.')
	Return
End IF

If f_msg_delete() = -1 Then Return

String ls_jpno

ls_jpno = dw_insert.GetItemString(1, 'kumrsl_kum_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('확인', '선택된 항목이 없습니다.')
	Return
End If

DELETE KUMRSL_KUM
 WHERE JPNO = :ls_jpno ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('확인', '삭제에 실패했습니다.')
End If

wf_ini()

p_inq.TriggerEvent('Clicked')
end event

type p_mod from w_inherite`p_mod within wp01
integer x = 3913
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() = -1 Then Return

If dw_insert.RowCount() < 1 Then Return

If dw_insert.ModifiedCount() < 1 Then Return

String ls_dat
String ls_kum

ls_dat = dw_insert.GetItemString(1, 'kumrsl_kum_sidat')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then
	MessageBox('의뢰일자', '의뢰일자를 입력하십시오.')
	dw_insert.SetColumn('kumrsl_kum_sidat')
	dw_insert.SetFocus()
	Return
End If

ls_kum = dw_insert.GetItemString(1, 'kumrsl_kum_kumno')
If Trim(ls_kum) = '' OR IsNull(ls_kum) Then
	MessageBox('금형코드', '금형코드를 선택하십시오.')
	dw_insert.SetColumn('kumrsl_kum_kumno')
	dw_insert.SetFocus()
	Return
End If

//필수확인
If wf_chk() = -1 Then Return

//저장여부
If f_msg_update() = -1 Then Return

//전표생성
If rb_1.Checked = True Then
	If wf_update() = -1 Then Return
End If

String ls_jpno
ls_jpno = dw_insert.GetItemString(1, 'kumrsl_kum_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('전표번호', '전표번호 생성 오류입니다.')
	Return -1
End If

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	rb_2.Checked = True
//	p_inq.TriggerEvent(Clicked!)
Else
	ROLLBACK USING SQLCA;
	f_message_chk(32, '[저장실패]')
	Return
End If

If MessageBox('출력', '수리 의뢰서를 출력 하시겠습니까?', Question!, YesNo!, 2) = 1 Then
	p_print.TriggerEvent(Clicked!)
End If

ib_any_typing = False


end event

type cb_exit from w_inherite`cb_exit within wp01
end type

type cb_mod from w_inherite`cb_mod within wp01
end type

type cb_ins from w_inherite`cb_ins within wp01
end type

type cb_del from w_inherite`cb_del within wp01
end type

type cb_inq from w_inherite`cb_inq within wp01
end type

type cb_print from w_inherite`cb_print within wp01
end type

type st_1 from w_inherite`st_1 within wp01
end type

type cb_can from w_inherite`cb_can within wp01
end type

type cb_search from w_inherite`cb_search within wp01
end type







type gb_button1 from w_inherite`gb_button1 within wp01
end type

type gb_button2 from w_inherite`gb_button2 within wp01
end type

type rr_1 from roundrectangle within wp01
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 268
integer width = 2299
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_top from datawindow within wp01
integer x = 27
integer y = 28
integer width = 2459
integer height = 236
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_kumpe01_00030_01"
boolean border = false
boolean livescroll = true
end type

event itemchanged;If row < 1 Then Return

String ls_name
String ls_tyno

Choose Case This.GetColumnName()
	Case 'sidat'
		dw_insert.SetItem(1, 'kumrsl_kum_sidat', data)
	Case 'kumno'
		SELECT KUMNAME , TYPENO
		  INTO :ls_name, :ls_tyno
		  FROM KUMMST
		 WHERE SABU  = :gs_sabu 
		   AND KUMNO = :data   ;
			
		This.SetItem(row, 'kumnm' , ls_name)
		This.SetItem(row, 'typeno', ls_tyno)
End Choose
end event

event rbuttondown;SetNull(gs_code    )
SetNull(gs_codename)

String ls_name
String ls_tyno

Choose Case dwo.name
	Case 'kumno'
		If rb_1.Checked = True Then
			gs_gubun = this.getitemstring(1, 'gubun')
			Open(w_imt_04630_popup)
			If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
			
			This.SetItem(row, 'kumno', gs_code    )
			
			SELECT KUMNAME , TYPENO
			  INTO :ls_name, :ls_tyno
		     FROM KUMMST
		    WHERE SABU  = :gs_sabu 
			   AND KUMNO = :gs_code ;
			
			This.SetItem(row, 'kumnm' , ls_name)
			This.SetItem(row, 'typeno', ls_tyno)
			
		ElseIf rb_2.Checked = True Then
			gs_gubun = this.getitemstring(1, 'gubun')
			Open(w_kumpe01_pop01)
			If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
			
			This.SetItem(row, 'kumno', gs_code)
			
			SELECT KUMNAME , TYPENO
			  INTO :ls_name, :ls_tyno
		     FROM KUMMST
		    WHERE SABU  = :gs_sabu 
			   AND KUMNO = :gs_code ;
			
			This.SetItem(row, 'kumnm' , ls_name)
			This.SetItem(row, 'typeno', ls_tyno)
//			This.SetItem(row, 'sidat' , gs_codename)
		End If
End Choose
end event

type rb_2 from radiobutton within wp01
integer x = 3255
integer y = 64
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "수정"
end type

event clicked;wf_ini()
end event

type rb_1 from radiobutton within wp01
integer x = 2981
integer y = 64
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;wf_ini()
end event

type dw_print from datawindow within wp01
boolean visible = false
integer x = 1221
integer y = 2388
integer width = 352
integer height = 248
integer taborder = 120
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_kumpe01_00030_p_new"
boolean border = false
end type

type pb_3 from u_pb_cal within wp01
integer x = 3072
integer y = 636
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('kumrsl_kum_eddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'kumrsl_kum_eddat', gs_code)
end event

type pb_1 from u_pb_cal within wp01
integer x = 4398
integer y = 296
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('kumrsl_kum_sidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'kumrsl_kum_sidat', gs_code)
end event

type pb_2 from u_pb_cal within wp01
integer x = 718
integer y = 48
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_top.Setcolumn('sidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_top.SetItem(1, 'sidat', gs_code)
end event

type pb_4 from u_pb_cal within wp01
boolean visible = false
integer x = 2651
integer y = 172
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('kumrsl_kum_stdat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'kumrsl_kum_stdat', gs_code)
end event

type dw_list from u_d_select_sort within wp01
integer x = 41
integer y = 276
integer width = 2267
integer height = 1860
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_kumpe01_00030_04"
boolean border = false
boolean hsplitscroll = true
end type

event retrieveend;call super::retrieveend;If rowcount < 1 Then
	wf_ini()
	Return
End If

String ls_jp

ls_jp = This.GetItemString(1, 'kumrsl_kum_jpno')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_jp)
dw_insert.SetRedraw(True)


end event

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow < 1 Then
	wf_ini()
	Return
End If

This.SelectRow(0, FALSE)
This.SetRow(currentrow)	
This.SelectRow(currentrow, TRUE)

String ls_jp

ls_jp = This.GetItemString(currentrow, 'kumrsl_kum_jpno')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_jp)
dw_insert.SetRedraw(True)
end event

type pb_5 from u_pb_cal within wp01
integer x = 1184
integer y = 48
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_top.Setcolumn('eddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_top.SetItem(1, 'eddat', gs_code)
end event

type gb_5 from groupbox within wp01
integer x = 2935
integer y = 12
integer width = 594
integer height = 160
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

