$PBExportHeader$w_sys_sms.srw
$PBExportComments$사용자별 문자메세지 수신여부
forward
global type w_sys_sms from window
end type
type p_ret from uo_picture within w_sys_sms
end type
type p_exit from uo_picture within w_sys_sms
end type
type p_mod from uo_picture within w_sys_sms
end type
type dw_2 from u_d_popup_sort within w_sys_sms
end type
type dw_1 from u_key_enter within w_sys_sms
end type
type rr_1 from roundrectangle within w_sys_sms
end type
end forward

global type w_sys_sms from window
integer width = 3634
integer height = 2388
boolean titlebar = true
string title = "사용자별 문자메세지 수신여부"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
p_ret p_ret
p_exit p_exit
p_mod p_mod
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_sys_sms w_sys_sms

on w_sys_sms.create
this.p_ret=create p_ret
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_ret,&
this.p_exit,&
this.p_mod,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_sys_sms.destroy
destroy(this.p_ret)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;
dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setcolumn('deptcode')
dw_1.setfocus()

dw_2.settransobject(sqlca)
end event

type p_ret from uo_picture within w_sys_sms
integer x = 3013
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type

event clicked;String sCode

If dw_1.accepttext() <> 1 Then Return 
sCode = dw_1.GetItemString(1,"deptcode")
if sCode = '' or IsNull(sCode) then sCode = '%'

If dw_2.Retrieve(sCode) <= 0 then
	Messagebox("확인", "조회한 자료가 없습니다.")
	return 
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\조회_up.gif'
end event

type p_exit from uo_picture within w_sys_sms
integer x = 3360
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\닫기_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\닫기_up.gif'
end event

type p_mod from uo_picture within w_sys_sms
integer x = 3186
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\ERPMAN\image\저장_up.gif"
end type

event clicked;dw_2.AcceptText()

Long    ll_cnt
ll_cnt = dw_2.RowCount()
If ll_cnt < 1 Then Return

Long    i
Long    ll_err
String  ls_err
String  ls_comp
String  ls_emp
String  ls_hpn
String  ls_sts
String  ls_chk
dwItemStatus	l_sts1, l_sts2
For i = 0 To ll_cnt
	i = dw_2.GetNextModified(i, Primary!)
	If i < 1 Then Exit
	
	ls_comp = dw_2.GetItemString(i, 'p1_master_companycode' )
	ls_emp  = dw_2.GetItemString(i, 'p1_master_empno'       )
	ls_hpn  = dw_2.GetItemString(i, 'p1_etc_hphone'         )
	ls_sts  = dw_2.GetItemString(i, 'sts'                   )
	
	l_sts1 = dw_2.GetItemStatus(i, 'p1_etc_hphone', Primary!)
	Choose Case l_sts1
		Case DataModified!
			SetNull(ls_chk)
			SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
			  INTO :ls_chk
			  FROM P1_ETC
			 WHERE COMPANYCODE = :ls_comp AND EMPNO = :ls_emp ;
			If ls_chk <> 'Y' Then
				MessageBox('확인', '인사기록 정보가 없습니다.~r~n인사담당자에게 문의 바랍니다.')
				Return
			End If
			 
			UPDATE P1_ETC
				SET HPHONE = :ls_hpn
			 WHERE COMPANYCODE = :ls_comp AND EMPNO = :ls_emp ;
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[1]~r~n' + ls_err)
				Return
			End If
	End Choose
	
	l_sts2 = dw_2.GetItemStatus(i, 'sts', Primary!)
	Choose Case l_sts2
		Case DataModified!, New!, NewModified!
			SetNull(ls_chk)
			SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
			  INTO :ls_chk
			  FROM SDK_SMS_SEND_EMPNO
			 WHERE EMPNO = :ls_emp ;
			If ls_chk <> 'Y' Then
				INSERT INTO SDK_SMS_SEND_EMPNO (EMPNO, STS)
				VALUES (:ls_emp, :ls_sts) ;
			Else
				UPDATE SDK_SMS_SEND_EMPNO
					SET STS = :ls_sts
				 WHERE EMPNO = :ls_emp ;
			End If
			If SQLCA.SQLCODE <> 0 Then
				ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
				ROLLBACK USING SQLCA;
				MessageBox('Update Err [' + String(ll_err) + ']', '자료 갱신 중 오류가 발생 했습니다.[2]~r~n' + ls_err)
				Return
			End If
	End Choose
Next
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\저장_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\저장_up.gif'
end event

type dw_2 from u_d_popup_sort within w_sys_sms
integer x = 46
integer y = 196
integer width = 3511
integer height = 2044
integer taborder = 20
string dataobject = "d_sys_sms_020"
boolean vscrollbar = true
boolean border = false
end type

type dw_1 from u_key_enter within w_sys_sms
integer x = 37
integer y = 16
integer width = 1627
integer height = 144
integer taborder = 10
string dataobject = "d_sys_sms_010"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String sDeptCode,sCodeName,sNull

SetNull(sNull)

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return
	END IF
	sCodeName = f_code_select('부서',sDeptCode )
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return 1
	ELSE
		this.SetItem(1,"p0_dept_deptname2",sCodeName)	
	END IF
END IF
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = '%'
IF this.GetColumnName() ="deptcode" THEN
	
//	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"p0_dept_deptname2",gs_codename)	
END IF

end event

type rr_1 from roundrectangle within w_sys_sms
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 188
integer width = 3538
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

